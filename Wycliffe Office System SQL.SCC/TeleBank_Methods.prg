Class AddToIncExp
	protect aMbr:={} as array  // array with liabiliy members {accid,has},..
	declare method AddToIncome,AddToIncomeExp
method AddToIncome(gc:="" as string,FROMRPP:=false as logic,accid as string,cre as float,deb as float,debforgn as float,creforgn as float,;
		Currency as string,DESCRIPTN as string,cPersId as string,mDAT as string,mDocId as string,nSeqnbr ref int,poststatus:='2' as string,cTransnr:='' as string) ; 
	as array class AddToIncExp
	// Add current record to Ministry Income/Expense in case of assessable gift to liability member 
	// mDat: sqlstring for date
	//	Returns array with recordings to income/exp (can be empty) with:
	// {
	LOCAL mOms as STRING
	LOCAL nCre,nCreF as FLOAT
	Local lHas as logic
	local i as int 
	local aTrans:={} as array  // to be returned array with values to be inserted into table transaction
	//aTrans: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
	//          1    2     3      4      5      6            7      8   9  10      11         12    13     14       15      16    17   18
	IF Empty(SINC) .and.Empty(SINCHOME) .or.Empty(self:aMbr)
		RETURN aTrans
	ENDIF
	IF (!Empty(cPersId).or. FROMRPP) .and.gc=="AG"
		
		// add to gifts income:
			if (i:=AScan(self:aMbr,{|x|x[1]==accid}))>0 
				lHas:=self:aMbr[i,2]
				nCre:=Round(cre-deb,DecAantal)
				nCreF:=Round(creforgn-DEBFORGN,DecAantal)
				mOms:=DESCRIPTN
				if nCre <>0
					nSeqnbr++
					AAdd(aTrans,{iif(lHas,SINCHOME,SINC),0.00,0.00,nCre,nCreF,Currency,mOms,mDAT,'',LOGON_EMP_ID,poststatus,;
						Str(nSeqnbr,-1),mDocId,'','0','0','',cTransnr})
					nSeqnbr++
					AAdd(aTrans,{iif(lHas,SEXPHOME,SEXP),nCre,nCreF,0.00,0.00,Currency,mOms,mDAT,'',LOGON_EMP_ID,poststatus,;
						Str(nSeqnbr,-1),mDocId,'','0','0','',cTransnr})
				ENDIF
			ENDIF
	endif
	RETURN aTrans
	Method AddToIncomeExp(gc:="" as string,FROMRPP:=false as logic,accid as string,cre as float,deb as float,debforgn as float,creforgn as float,;
		Currency as string,DESCRIPTN as string,cType as string,cPersId as string,mDAT as date,mDocId as string,cTransnr as string,nSeqnbr ref int,poststatus:=2 as int) as logic  class AddToIncExp
	// Add current record to Gifts Income/Expense in case of assessable gift to liability member
	LOCAL mOms as STRING
	LOCAL nCre,nCreF as FLOAT
	Local lHas as logic
	LOCAL OfficeRate as FLOAT, me_rate,me_stat as STRING 
	local oMbr as SQLSelect
	local cStatement as string
	local oStmnt as SQLStatement 
	local lError as logic 
	local aTransIncExp:={} as array // array with transactions to income/expense
	//aTransIncExp: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
	//                1    2     3      4      5      6            7      8   9  10      11         12    13     14       15      16    17   18
	if !cType=liability
		return true
	endif  
	aTransIncExp:=self:AddToIncome(gc,FROMRPP,AllTrim(accid),cre,deb,debforgn,creforgn,Currency,DESCRIPTN,cPersId,SQLdate(mDAT),mDocId,@nSeqnbr,Str(poststatus,-1),cTransnr) 
	if Len(aTransIncExp)=2
		
		// add to gifts income:
		oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid) "+;
			" values "+Implode(aTransIncExp,"','"),oConn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows>0 
			if ChgBalance(aTransIncExp[1,1],mDAT,aTransIncExp[1,2],aTransIncExp[1,4],aTransIncExp[1,3],aTransIncExp[1,5],aTransIncExp[1,6],poststatus)
				if !ChgBalance(aTransIncExp[2,1],mDAT,aTransIncExp[2,2],aTransIncExp[2,4],aTransIncExp[2,3],aTransIncExp[2,5],aTransIncExp[2,6],poststatus)
					lError:=true
				endif
			else
				lError:=true
			endif
		else
			LogEvent(self,"add to income ("+oStmnt:SQLString+") error:"+oStmnt:ErrInfo:errormessage,"logerrors")
			lError:=true
		endif
	endif
	RETURN !lError
	

	

method Init() class AddToIncExp
	// initialize 
	local oMbr as SQLSelect
	local lHas as logic
	if !Empty(SINCHOME) .or.!Empty(SINC)
		oMbr:=SqlSelect{"select m.accid,has from member m, account a, balanceitem b where a.accid=m.accid and b.balitemid=a.balitemid "+;
			"and b.category='"+LIABILITY+"'",oConn}
		IF oMbr:RecCount>0
			do while !oMbr:EoF
				lHas:= if(ConI(oMbr:HAS)>0,true,false) 
				IF !Empty(SINC).or.lHas
					AAdd(self:aMbr,{ConS(oMbr:accid),lHas}) 
				ENDIF
				oMbr:Skip()
			enddo
		endif
	endif

CLASS SelBankAcc INHERIT DataDialogMine 

	PROTECT oDCListBoxBank AS LISTBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oCCFindButton AS PUSHBUTTON
	PROTECT oDCSearchUni AS SINGLELINEEDIT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  export oCaller as TeleMut 
  declare method FillBank
RESOURCE SelBankAcc DIALOGEX  4, 3, 218, 293
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", SELBANKACC_LISTBOXBANK, "ListBox", LBS_DISABLENOSCROLL|LBS_EXTENDEDSEL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 8, 36, 204, 251, WS_EX_CLIENTEDGE
	CONTROL	"OK", SELBANKACC_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 160, 3, 53, 13
	CONTROL	"Cancel", SELBANKACC_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 160, 18, 53, 12
	CONTROL	"", SELBANKACC_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 64, 18, 47, 12
	CONTROL	"Found:", SELBANKACC_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 32, 18, 27, 12
	CONTROL	"Find", SELBANKACC_FINDBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 72, 3, 40, 13
	CONTROL	"", SELBANKACC_SEARCHUNI, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 4, 3, 68, 13
END

METHOD CancelButton( ) CLASS SelBankAcc 
   self:EndWindow(1)
RETURN NIL
method Close(oEvent) class SelBankAcc
	
	//Put your changes here
	if !self:oCaller:lOK
		self:oCaller:m57_BankAcc:={}
	endif 
	return super:Close(oEvent)

METHOD FillBank(dummy:=false as logic) as array CLASS SelBankAcc
	local cStatement as string 
	local cSelect as string
	local oSel as SQLSelect 
	cSelect:=self:oCaller:GetTeleSelect()
	cStatement:="select concat('(', lpad(cast(count(t.teletrid) AS CHAR),4,' ') ,') ', b.banknumber,' ',a.description) as description,b.banknumber"+; 
	" from bankaccount b, account a, teletrans as t "+;
		" where a.accid=b.accid and b.Telebankng=1 and t.bankaccntnbr = b.banknumber and t.processed<>'X' and "+cSelect+; 
	" group by  b.banknumber order by description desc" 
	oSel:=SqlSelect{cStatement,oConn}
	if oSel:RecCount>0
		return oSel:GetLookupTable(500,#description,#banknumber)
	else
		return {{"No more telebanking transactions",""}}
	endif
		

METHOD FindButton( ) CLASS SelBankAcc 
	local aKeyw:={} as array
	local i,j,nPos, nFound as int
	local cvalue as string
	if !Empty(self:SearchUni)
		self:SearchUni:=Lower(AllTrim(self:SearchUni)) 
		aKeyw:=GetTokens(self:SearchUni)
		for nPos:=1 to self:oDCListBoxBank:ItemCount 
			cvalue:=self:oDCListBoxBank:getItem(nPos)
			self:oDCListBoxBank:SelectItem(nPos)		
			for i:=1 to Len(aKeyw)
				if AtC(aKeyw[i,1],cvalue)=0
					self:oDCListBoxBank:DeselectItem(nPos)
					exit
				endif
				self:oDCListBoxBank:SelectItem(nPos)
				nFound++		
			next
		next
	endif
   if nFound>0
   	self:oDCListBoxBank:SetTop(self:oDCListBoxBank:FirstSelected())
   endif
	self:oDCFound:TextValue :=Str(nFound,-1)

	RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS SelBankAcc 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"SelBankAcc",_GetInst()},iCtlID)

oDCListBoxBank := ListBox{SELF,ResourceID{SELBANKACC_LISTBOXBANK,_GetInst()}}
oDCListBoxBank:HyperLabel := HyperLabel{#ListBoxBank,NULL_STRING,NULL_STRING,NULL_STRING}
oDCListBoxBank:FillUsing(Self:FillBank( ))
oDCListBoxBank:OwnerAlignment := OA_X_HEIGHT

oCCOKButton := PushButton{SELF,ResourceID{SELBANKACC_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{SELBANKACC_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCFound := FixedText{SELF,ResourceID{SELBANKACC_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{SELBANKACC_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

oCCFindButton := PushButton{SELF,ResourceID{SELBANKACC_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Find",NULL_STRING,NULL_STRING}

oDCSearchUni := SingleLineEdit{SELF,ResourceID{SELBANKACC_SEARCHUNI,_GetInst()}}
oDCSearchUni:HyperLabel := HyperLabel{#SearchUni,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchUni:FocusSelect := FSEL_TRIM
oDCSearchUni:TooltipText := "Enter one or more (part of) key values "
oDCSearchUni:UseHLforToolTip := True

SELF:Caption := "Select bank accounts to be processed"
SELF:HyperLabel := HyperLabel{#SelBankAcc,"Select bank accounts to be processed",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS ListBoxBank() CLASS SelBankAcc
RETURN SELF:FieldGet(#ListBoxBank)

ASSIGN ListBoxBank(uValue) CLASS SelBankAcc
SELF:FieldPut(#ListBoxBank, uValue)
RETURN uValue

method ListBoxSelect(oControlEvent) class SelBankAcc
	local oControl as Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:ListBoxSelect(oControlEvent)
	//Put your changes here 
	self:oDCFound:TextValue :=Str(self:oDCListBoxBank:SelectedCount,-1)

	return NIL

METHOD OKButton( ) CLASS SelBankAcc 
	// set filter on oServer with selected bank accounts:
	LOCAL nPos,i,l as int
	local aBank:={}, aBankAcc:=oCaller:m57_BankAcc as array 
	nPos :=self:oDCListBoxBank:FirstSelected()
	do WHILE nPos>0
		AAdd(aBank,self:oDCListBoxBank:getItemValue(nPos))
		nPos:=self:oDCListBoxBank:NextSelected()
	ENDDO 
	// reduce m57_BankAcc:
	l:=Len(aBankAcc)
	for i:=1 to l
		if AScan(aBank,aBankAcc[i][1])==0
			ADel(aBankAcc,i)
			l--
			ASize(aBankAcc,l)
			i--
		endif
	next
	if IsObject(self:oCaller) .and.!self:oCaller==null_object
		self:oCaller:lOK:= true 
	endif
	self:EndWindow(true)
	RETURN nil
method PostInit(oWindow,iCtlID,oServer,uExtra) class SelBankAcc
	//Put your PostInit additions here
	Local nPos as int 
	self:SetTexts()
	self:oCaller:=uExtra 
	for nPos:=1 to self:oDCListBoxBank:ItemCount
		self:oDCListBoxBank:SelectItem(nPos)		
	next
	self:oCaller:lOK:=false
	self:oDCFound:TextValue :=Str(self:oDCListBoxBank:ItemCount,-1)
	return nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class SelBankAcc
	//Put your PreInit additions here
	self:oCaller := uExtra
	return nil

ACCESS SearchUni() CLASS SelBankAcc
RETURN SELF:FieldGet(#SearchUni)

ASSIGN SearchUni(uValue) CLASS SelBankAcc
SELF:FieldPut(#SearchUni, uValue)
RETURN uValue

STATIC DEFINE SELBANKACC_CANCELBUTTON := 102 
STATIC DEFINE SELBANKACC_FINDBUTTON := 105 
STATIC DEFINE SELBANKACC_FOUND := 103 
STATIC DEFINE SELBANKACC_FOUNDTEXT := 104 
STATIC DEFINE SELBANKACC_LISTBOXBANK := 100 
STATIC DEFINE SELBANKACC_OKBUTTON := 101 
STATIC DEFINE SELBANKACC_SEARCHUNI := 106 
CLASS TeleMut

	PROTECT m56_recnr as int
	EXPORT m56_sgir,m56_kind,m56_description,m56_contra_name,m56_budgetcd,m56_cod_mut_r,;
		m56_addsub, m56_accnumber,m56_accid:="   ", m56_Payahead,m56_persid,m56_accnumber,m56_seqnr as STRING,;
		m56_bookingdate as date,;
		m56_amount as REAL,;
		m56_dueid as int 
	export m56_contra_bankaccnt, m56_bankaccntnbr as USUAL,;
		m56_processed,m56_recognised, m56_autmut,m56_mode_aut:=true,m56_autom as LOGIC
	export m56_address, m56_zip, m56_town, m56_country,m56_bic as string

	PROTECT m56_auto_verw as LOGIC
	PROTECT lGift as LOGIC

	// PROTECT oTelPat as SQLSelect, oBank as SQLSelect
	EXPORT teleptrn:={} as ARRAY //{contra_bankaccnt,kind,contra_name,addsub,description,accid,ind_autmut}
	EXPORT oTelTr as SQLSelect
	EXPORT oParent as OBJECT
	EXPORT m57_bankacc := {} as ARRAY   //with: banknumber, usedforgifts, datlaatst, giftsall,singledst,destname,accid,payahead,singlenumber,fgmlcodes,syscodover
	//                                               1            2           3          4         5         6      7     8           9        10          11
	PROTECT bankacc := {} as ARRAY  // all bankaccounts 
	export cBankAcc as string   // all bankaccounts 
	//export aBankProc:={} as array // bankaccounts to be processed 
	export CurTelId as int
	PROTECT lv_mm, lv_jj as int
	PROTECT lv_aant_toe:=0, lv_aant_vrw,lv_processed:=0 as int
	PROTECT CurTelePtr as int // pointer to current telebanking account within m57_BankAcc
	PROTECT NonTeleAcc:={} as ARRAY
	EXport lOK as logic 
	export oLan as Language 
	export cReqTeleBnk as string // required bank accounts to import 
	protect cAccnumberCross as string  // accnumber of account for cross bank transfer (sKruis)
	protect aMessages:={} as array  // messages about successfully imported files  
	protect CurDate as date, CurSeq, CurBank as string  // current values of bookingdate, sequencenumber and bankaccntnbr in import file
	protect nSubSeqnr as int  // sub seqence nunber for same CurDate and CurSeq 
	protect aValuesTrans:={} as array  // array with values to be stored into table teletrans:
	// { {bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,adrline,country,bic,dueid,processed},...}  
	protect avaluesBal:={} as array  // array with values to be stored in bankbalances: {{banknumber,SQLdate,value},...
	export nTooOld as int // number of too old trasnactions
	export nNonTele as int // number of transactions not on telebanking account  
	export nDuplicate as int // number of transactions skipped because of duplicates 
	export nReversals as int // numbers of transactions whic are reversals of direct debits

	declare method TooOldTeleTrans,ImportBBS,ImportPGAutoGiro ,ImportPostbank,ImportBBSInnbetal,;
		ImportGiro,ImportKB,ImportSA,ImportTL1,ImportUA,CheckPattern,NextTeleNonGift,GetPaymentPattern, AddTeleTrans,SaveTeleTrans,;
		GetAddress,AllreadyImported,ImportSA2, ImportCAMT053,GetTeleSelect,ImportMT940,ImportMT940ING,ImportMT940IBANING,ImportHU
method AddTeleTrans(bankaccntnbr as string,;
		bookingdate as date,; 
	seqnr as string,;
		contra_bankaccnt:="" as string,;
		kind:="" as string,;
		contra_name:="" as string,;
		budgetcd:="" as string,;
		amount as float,;
		addsub:="" as string,;
		description:="" as string,;
		persid as string,adrline:='' as string,country:='' as string,bic:="" as string,dueid:="" as string,;
		lv_rtrn:='' as string,lv_eref:='' as string,lv_marf:='' as string) as logic CLASS TeleMut 
	if !Empty(amount)
		bankaccntnbr:=AllTrim(bankaccntnbr)
		IF self:TooOldTeleTrans(bankaccntnbr,bookingdate) 
			// 			LogEvent(self,"Skipped:"+ bankaccntnbr +' on '+DToC(bookingdate)+", contra_bankaccnt:"+contra_bankaccnt+", contra_name:"+contra_name+", amount:"+Str(amount,-1)+",description:"+description,"logsql")
		else
//			if self:CurBank==bankaccntnbr .and. seqnr==self:CurSeq .and.(!Empty(seqnr) .or.self:CurDate==bookingdate)
			if self:CurBank==bankaccntnbr .and. seqnr==self:CurSeq .and.self:CurDate==bookingdate
				self:nSubSeqnr++
			else
				self:nSubSeqnr:=1
				self:CurDate:=bookingdate
				self:CurSeq:=seqnr
				self:CurBank:=bankaccntnbr
			endif
			// aValuesTrans:
			// bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,adrline,country,bic,dueid,lv_rtrn,lv_eref,lv_marfl,processed 
			//      1            2        3          4           5      6           7      8      9        10        11       12     13    14   15    16        17     18      19
			AAdd(self:aValuesTrans,{bankaccntnbr,SQLdate(bookingdate),ZeroTrim(seqnr+iif(self:nSubSeqnr>1,Str(self:nSubSeqnr,-1),'')),AllTrim(contra_bankaccnt),SubStr(kind,1,6),contra_name,AllTrim(budgetcd),amount,addsub,description,persid,adrline,country,bic,dueid,lv_rtrn,lv_eref,lv_marf,''})
			// 			LogEvent(self,Str(Len(self:aValuesTrans),-1)+':'+contra_name+'('+ contra_bankaccnt+')',"logsql")
		endif 
	endif

	return true
METHOD AllreadyImported(transdate as date,transamount as float,codedebcre:="" as string,transdescription:="" as string,TransType:="" as string,ContrBankNbr:="" as string,ContraName:="" as string,BudgetCode:="" as string) as logic CLASS TeleMut
	local oSel as SQLSelect 
	local cStatement as string
	// check if transaction has allready been imported
// 	IF transdate <= m57_BankAcc[CurTelePtr,3] 
		cStatement:="select teletrid from teletrans where "+;
		"bankaccntnbr='" +m57_BankAcc[CurTelePtr,1]+"'"+;
		" and bookingdate='"+SQLdate(transdate)+"' and "+;
		"amount="+Str(transamount,-1)+" and "+;
		"addsub='"+codedebcre+"' and "+;
		"kind='"+AllTrim(SubStr(TransType,1,4))+"' and "+;
		"contra_bankaccnt='"+ZeroTrim(ContrBankNbr)+"' and "+;
		"contra_name='"+AllTrim(ContraName)+"' and "+;
		"budgetcd='"+AllTrim(SubStr(BudgetCode,1,20))+"' and "+;
		"description='"+AllTrim(transdescription)+"'"
		oSel:=SqlSelect{cStatement,oConn}
		if oSel:reccount>0
        	RETURN true
		ENDIF
//    ENDIF
 	RETURN FALSE
METHOD CheckPattern(tG as usual,tS as usual, tN as usual, tC as usual,tD as usual) as logic  CLASS TeleMut
// check againt telebankpatterns given transaction with:
// tG: contra_bankaccnt
// tS: kind, 
// tN: contra_name, 
// tC: addsub,
// tD: description   
LOCAL i AS INT
	local aTelePtr:=self:teleptrn as array
//LOCAL tG:=self:m56_contra_bankaccnt, tS:= self:m56_kind, tN:= self:m56_contra_name, tC:= self:m56_addsub,tD:=self:m56_description  as STRING
// {contra_bankaccnt,kind,contra_name,addsub,description,accid,ind_autmut,accnumber},...
//        1            2     3           4       5          6        7        8
    i := AScan(aTelePtr,{|x| (Empty(x[1]) .or. ;
					tG	== x[1])	.and.;
					tS	= x[2]	.and.;
					tN	= x[3]	.and.;
					(tC == x[4] .or.x[4]=='D') .and.;
					CompareKeyString(x[5],tD)})
IF i>0
	self:m56_accid:= self:Teleptrn[i,6]
	self:m56_recognised:=true
	self:m56_autmut:=conl(self:Teleptrn[i,7])
	self:m56_accnumber:=self:teleptrn[i,8]
	if Empty(self:Teleptrn[i,1])
		self:m56_autmut:=false         // in case of empty contra bankaccount no unique identification possible 
	endif
	RETURN TRUE
ELSE
	self:m56_accid:=Space(25)
	self:m56_accnumber:=''
	self:m56_autmut:=false 
ENDIF
RETURN FALSE


METHOD Close() CLASS TeleMut
// unlock current teletrans transaction 
if !Empty(self:CurTelId)
	SQLStatement{"update teletrans set lock_id=0 where teletrid="+Str(self:CurTelId,-1),oConn}:execute()
endif
RETURN true
METHOD CloseMut(oHlp ,lSave,oCaller)  CLASS TeleMut
	* End of telebanking transaction
	LOCAL oNewTeleWindow as EditTeleBankPattern
	Default(@lSave,false)
	
// 	SQLStatement{"update teletrans set processed='X', lock_id=0 where teletrid="+Str(self:CurTelId,-1),oConn}:execute()
// 	SQLStatement{"commit",oConn}:execute()

	IF !self:m56_recognised.and.!self:m56_autmut.and.!lGift.and.lSave
		oHlp:GoBottom()
		oNewTeleWindow := EditTeleBankPattern{ oCaller,,,self}
		oNewTeleWindow:maccid := oHlp:accid
		oNewTeleWindow:mAccount:=oHlp:accdesc
		oNewTeleWindow:mdescription := self:m56_description
		oNewTeleWindow:mkind := self:m56_kind
 		oNewTeleWindow:mcontra_bankaccnt := self:m56_contra_bankaccnt
 		oNewTeleWindow:mcontra_name := self:m56_contra_name
        oNewTeleWindow:mAddSub := self:m56_addsub
        oNewTeleWindow:mInd_AutMut := TRUE

		oNewTeleWindow:Show()
	ENDIF

RETURN
method GetAddress(Description as string,lZipFromWeb:=true as logic) as void pascal class TeleMut
	// get address from transaction description and
	// returns it into self:m56_address,self:m56_zip,self:m56_town,self:m56_country and self:m56_description 
	local oPers as PersonContainer
	LOCAL oXMLDoc as XMLDocument
	local cAddrLine as string 
	local XMLPos,nAddrEnd as int
	Local aWord as array
	local lZipCode,lCity,lAddress as logic
	self:m56_address:=""
	self:m56_zip:=""
	self:m56_town:=""
	XMLPos:=At("<n>",Description)
	if XMLPos=0
		XMLPos:=At("<a>",Description)
		if XMLPos=0
			XMLPos:=At("<t>",Description)
			if XMLPos=0
				XMLPos:=At("<d>",Description)
			endif
		endif
	endif
	
	if "</" $ Description .and. XMLPos>0 
		self:m56_country:="" 
		oXMLDoc:=XMLDocument{SubStr(Description,XMLPos)}
		IF oXMLDoc:GetElement("n")
			self:m56_contra_name:=Upper(oXMLDoc:GetContentCurrentElement())
		ENDIF
		IF oXMLDoc:GetElement("a")
			self:m56_address:=oXMLDoc:GetContentCurrentElement()
		ENDIF
		IF oXMLDoc:GetElement("p")
			self:m56_zip:=StandardZip(oXMLDoc:GetContentCurrentElement())
		ENDIF
		IF oXMLDoc:GetElement("t")
			self:m56_town:=Compress(oXMLDoc:GetContentCurrentElement())
			// check if it contains a zip code:
			if IsDigit(self:m56_town)
				aWord:=GetTokens(self:m56_town) 
				if oPers==null_object
					oPers:=PersonContainer{}
				endif
				lAddress:=true
				oPers:m51_country:=self:m56_country 
				oPers:Adres_Analyse(aWord,1,@lZipCode,@lCity,@lAddress,false)
				self:m56_town:=oPers:m51_city
				if Empty(self:m56_zip)
					self:m56_zip:=oPers:m51_pos
				endif
				oPers:m51_city:=""
				oPers:m51_pos:=""
			endif				
		ENDIF
		IF oXMLDoc:GetElement("c")
			self:m56_country:=oXMLDoc:GetContentCurrentElement()
		ENDIF
		if oXMLDoc:GetElement("d")
			self:m56_description:=AllTrim(oXMLDoc:GetContentCurrentElement())
		endif	
	else
		// 		self:m56_description:= Upper(Compress(Description))
		// 		if (nAddrEnd:=At('%%',Description))>0  
		if (nAddrEnd:=At('%%',Description))=0
			if (nAddrEnd:=AtC('EndToEnd',Description))=0
				nAddrEnd:=Len(Description)+1
			endif
		endif  
		// separate address line probably
		if oPers==null_object
			oPers:=PersonContainer{}
		endif
		oPers:m51_country:=self:m56_country 
		cAddrLine:=SubStr(Description,1,nAddrEnd-1)
		if Len(oPers:m51_country)>2
			cAddrLine:=AllTrim(strtran(cAddrLine,oPers:m51_country,''))
		endif
		aWord:=GetTokens(cAddrLine,{" ",",",".","&","/"}) 
		oPers:Adres_Analyse(aWord,,@lZipCode,@lCity,@lAddress,false,lZipFromWeb)
		self:m56_address:=oPers:m51_ad1
		self:m56_zip:=StandardZip(oPers:m51_pos) 
		self:m56_town:=oPers:m51_city
		// 		endif
	endif
	return 
METHOD GetNxtMut(LookingForGifts) CLASS TeleMut
	* get next bank transaction from teletrans
	* return .t.: next found
	*        .f.: not found
	LOCAL hlpbank:=0, iBpos,nBudLen,nLength as int
	// 	local XMLPos,nAddrEnd as int
	LOCAL BankNbr, TegNbr as STRING 
	// 	LOCAL oXMLDoc as XMLDocument 
	// 	Local aWord as array
	// 	local oPers as PersonContainer 
	local oBank as SQLSelect 
	local oLockSt as SQLStatement 
	local cSelect as string 
	// 	local lZipCode,lCity,lAddress as logic

	self:m56_processed:=FALSE
	self:m56_accid:=Space(3)
	self:m56_accnumber:=Space(11) 
	self:m56_description:=""
	self:m56_contra_name:=""
	if Empty(self:m57_BankAcc)    // skip if no telebanking accounts
		Return false
	endif
	cSelect:=self:GetTeleSelect()
	cSelect+=iif(Empty(cSelect),""," and ")+"t.bankaccntnbr in ("+self:cReqTeleBnk+")"     // should contain requested bankaccounts

	DO WHILE true
		SQLStatement{"start transaction",oConn}:execute() 
		// select next row not yet locked by somebody else:
		self:oTelTr:= SqlSelect{"select t.teletrid,t.seqnr,t.amount,t.bankaccntnbr,cast(t.bookingdate as date) as bookingdate,t.kind,t.contra_bankaccnt,"+; 
		"t.addsub,t.code_mut_r,t.budgetcd,t.description,t.persid,t.contra_name,t.bic,t.adrline,t.country,t.dueid,"+;
			"b.accid,b.payahead,cast(b.giftsall as unsigned) as giftsall,cast(b.openall as unsigned) as openall from teletrans t, bankaccount b where processed='' and "+;
			"t.bankaccntnbr<>'' and t.bankaccntnbr=b.banknumber and b.telebankng=1 and "+;
			+"(t.lock_id=0 or t.lock_id="+MYEMPID+" or t.lock_time < subdate(now(),interval 20 minute))"+;
			iif(Empty(self:CurTelId),''," and teletrid>"+Str(self:CurTelId,-1))+;
			+" and "+cSelect+" order by teletrid limit 1 for UPDATE" ,oConn}
		
		if self:oTelTr:reccount<1 .or.!Empty(self:oTelTr:status) 
			IF !Empty(self:oTelTr:status) 
				LogEvent(self,"error:"+self:oTelTr:errinfo:errormessage+"; statement:"+self:oTelTr:SQlString,"LogErrors") 
			endif
			SQLStatement{"rollback",oConn}:execute()
			return false
		endif
		// software lock teletrans row:
		oLockSt:=SQLStatement{"update teletrans set lock_id="+MYEMPID+",lock_time=now() where teletrid="+Str(self:oTelTr:teletrid,-1),oConn}
		oLockSt:execute()		
		if oLockSt:NumSuccessfulRows < 1
			SQLStatement{"rollback",oConn}:execute()
			loop
		else
			SQLStatement{"commit",oConn}:execute()
		endif
		
		BankNbr:= self:oTelTr:bankaccntnbr
		self:CurTelId:=self:oTelTr:teletrid
		self:m56_sgir:=Str(self:oTelTr:accid,-1) // Account of banknbr
		self:m56_Payahead:=iif(Empty(self:oTelTr:PAYAHEAD),'',Str(self:oTelTr:PAYAHEAD,-1)) // Account of clearing automatic collection
		self:m56_persid:=""
		self:m56_bankaccntnbr:=self:oTelTr:bankaccntnbr
		self:m56_bookingdate:= self:oTelTr:bookingdate
		self:m56_kind:=AllTrim(self:oTelTr:kind)
		self:m56_seqnr:=self:oTelTr:seqnr
		self:m56_contra_bankaccnt:=ZeroTrim(self:oTelTr:contra_bankaccnt) 
		self:m56_contra_name:=self:oTelTr:contra_name 
		self:m56_country:=GetCountryName(self:oTelTr:country)
		self:m56_bic:= self:oTelTr:bic
		self:m56_dueid:=ConI(self:oTelTr:dueid)
		// 		IF At(">",self:m56_contra_name)=Len(self:m56_contra_name).and.!Empty(self:m56_contra_name)
		// 			self:m56_contra_name:=SubStr(self:m56_contra_name,1,Len(self:m56_contra_name)-1)
		// 		ENDIF	
		self:m56_amount:= self:oTelTr:amount
		self:m56_addsub:= self:oTelTr:AddSub
		self:m56_cod_mut_r:= self:oTelTr:code_mut_r
		if !Empty(self:oTelTr:BUDGETCD)
			self:m56_budgetcd:=ZeroTrim(self:oTelTr:BUDGETCD)
			nBudLen:=At(' ',self:m56_budgetcd)
			if nBudLen>0
				self:m56_budgetcd:=SubStr(self:m56_budgetcd,1,nBudLen-1)
			endif
		else
			self:m56_budgetcd:=""
		endif
		self:m56_description:= self:oTelTr:Description
//		self:GetAddress(iif(Empty(self:oTelTr:adrline),self:oTelTr:Description,self:oTelTr:adrline))
		//    if !Empty(Val(AllTrim(oTelTr:persid))) .and. oTelTr:addsub="B"
		if !Empty(self:oTelTr:persid) .and. self:oTelTr:persid>0 
			self:m56_persid:=Str(self:oTelTr:persid,-1)
		endif
		IF LookingForGifts
			oParent:GiftsAutomatic := iif(ConI(self:oTelTr:GIFTSALL)=1,true,false)
			oParent:DueAutomatic := iif(ConI(self:oTelTr:OPENALL)=1,true,false)
		ENDIF
		RETURN true
	ENDDO
	RETURN FALSE
method GetPaymentPattern(lv_Oms as string,lv_addsub as string,lv_budget ref string,lv_persid ref string, lv_bankid ref string,lv_kind ref string) as void pascal class TeleMut
	// analyse if description of transaction contains a payment pattern (betalingkenmerk) 
	local cText as string 
	local oDue as SQLSelect 
	local dateCol as date                    
	if	Empty(lv_budget) 
		if Upper(SubStr(lv_Oms,1,10))=='ACCEPTGIRO'
			lv_kind='AC'
			return
		endif
		cText	:=	SubStr(lv_Oms,1,16)
		if Len(cText)<7
			return
		endif 
		// 		IF	isnum(AllTrim(cText)) .and. Upper(SubStr(lv_Oms,17,2))=='AC'
		IF	isnum(AllTrim(cText)) .and. IsMod11(cText) 
			//	betalingskenmerk
			lv_kind:="AC"
		elseif Upper(SubStr(lv_Oms,1,13))=="BETALINGSKENM" .or. Upper(SubStr(lv_Oms,1,12))=="BET. KENMERK"
			lv_budget:=AllTrim(SubStr(lv_Oms,At3(Space(1),lv_Oms,12)+1,16)) 
			if	Len(lv_budget)>=15	.and.	isnum(lv_budget)  
				if IsMod11(lv_budget)
					cText:=SubStr(lv_budget,2)
					if	lv_addsub='A'
						lv_persid:=ZeroTrim(SubStr(cText,1,5))	  // terugboeking 
						dateCol:= SToD(SubStr(cText,6,8))
						if !Empty(lv_persid) .and.!dateCol==null_date .and. dateCol<Today() .and. dateCol> Today()-300 
							//	 Look	for Due amount:
							oDue:=SQLSelect{'select s.personid as persid,a.accnumber from dueamount d, account a, subscription s where '+;
								's.subscribid=d.subscribid and s.personid="'+lv_persid+'" and d.invoicedate="'+;
								SQLdate(dateCol)+'" and seqnr='+ZeroTrim(SubStr(cText,14))+' and s.accid=a.accid',oConn}	  
							if	oDue:Reccount>0	//	without check digit
								lv_persid:=Str(oDue:persid,-1)
								lv_budget:=oDue:ACCNUMBER
								lv_kind:="COL"
							else
								lv_budget:=""
								lv_persid:=""
							endif
						else
							lv_budget:=""
							lv_persid:=""
						endif
					elseif Empty(lv_kind) 
						lv_kind:="AC"
					endif
				endif
			else
				lv_budget:=""				
			endif
		elseif IsDigit(lv_Oms)
			cText	:=	SubStr(AllTrim(StrTran(StrTran(SubStr(lv_Oms,1,19),' ',''),'+','')),1,16)
			// 			IF	isnum(cText) .and. Len(cText)=16	.and.	IsMod11(cText)							
			IF	isnum(cText) .and.	IsMod11(cText)							
				//	betalingskenmerk
				lv_kind:="AC"
			endif                                      
		endif
		if	lv_kind=="AC"
			if	lv_addsub =	"B" .and.isnum(cText) .and. SEntity="NED"            //9824060000051254
				if Len(cText)>11                                                 //4000008240163516
					lv_persid:=Str(Val(SubStr(cText,-5)),-1)                      //1234567890123456
				endif
				lv_bankid:=SubStr(cText,2,6)
				lv_budget:=SubStr(cText,2,Max(5,Len(cText)-6.00))
				if	Val(SubStr(lv_budget,6))==0         // ???
					lv_budget:=ZeroTrim(SubStr(lv_budget,1,5)) 
				else
					lv_budget:=ZeroTrim(lv_budget)
				endif
			endif
		endif
	endif
	return

Method GetTeleSelect(dummy:=nil as logic) as string class TeleMut
	local cSelect as string 
	cSelect:="b.usedforgifts=1 "+;
		"and addsub='B' and t.kind not in ('OCR','CLR','BGC') and t.description <> 'Betreft acceptgiro' and not t.description  like 'NAAM/NUMMER STEMMEN NIET OVEREEN%' and "+; 
	"(t.kind<>'COL' or cast(t.contra_bankaccnt as unsigned)>0) and "+;
		"(cast(t.contra_bankaccnt as unsigned)=0 or t.contra_bankaccnt not in ("+self:cBankAcc+")) "
	if self:lGift
		if ADMIN="HO"
			cSelect=""
		endif
	else
		cSelect:="not ("+cSelect+")"		
	endif
	return cSelect
METHOD Import() CLASS TeleMut
	* Import of telebanking data into table teletrans
	LOCAL i, nf as int
	local cFileName as STRING 
	local nOld:=18 as int   // after Nold months imported transactions are removed
	LOCAL lv_eind as date
	LOCAL lSuccess,lFilesFound as LOGIC
	local aFiles:={} as array  // files to be deleted 
	LOCAL aFileMT:={},aFileMTING:={},aFileMTIBANING:={}, aFilePB:={}, aFileSA,aFileSA2, aFileN, aFileUA, aFileBBS, aFileINN, aFilePG, aFileTL,aFileKB,aFileRO,aFileHU,aFileCamT:={} as ARRAY
	LOCAL oFs, oFrabo as MyFileSpec
	LOCAL oBF as MyFileSpec
	LOCAL oPF as FileSpec
	Local oLock,oSel as SQLSelect 
	local oStmnt as SQLStatement
	// force only one person is importing:
	oLock:=SqlSelect{'select 1 from importlock where importfile="telelock" and '+;
		" lock_id<>"+MYEMPID+" and lock_time > subdate(now(),interval 10 minute)",oConn}
	if oLock:Reccount>0 
		ErrorBox{,self:oLan:WGet("somebody else busy with importing telebank transactions")}:Show()
		return
	endif 
	SQLStatement{"start transaction",oConn}:execute()
	oLock:=SqlSelect{"select importfile from importlock where importfile='telelock' for update",oConn}
	oLock:execute() 
	if !Empty(oLock:Status)
		ErrorBox{,self:oLan:WGet("could not select importlock")+Space(1)+' ('+oLock:Status:description+')'}:Show()
		SQLStatement{"rollback",oConn}:execute() 
		return
	endif
	// set software lock:
	oStmnt:=SQLStatement{"update importlock set lock_id="+MYEMPID+",lock_time=now() where importfile='telelock'",oConn}
	oStmnt:execute()
	if !Empty(oStmnt:Status)
		ErrorBox{,self:oLan:WGet("could not lock required transactions")}:Show()
		SQLStatement{"rollback",oConn}:execute() 
		return
	endif
	SQLStatement{"commit",oConn}:execute()  // save locks 

	// 	oLock:=SQLSelect{"select importfile from importlock where importfile='telelock' for update",oConn}

	oFs := MyFileSpec{"mutgiro.txt"}
	oFs:Path:=CurPath
	IF !oFs:Find()
		oFs:FileName:="download.asc"  // try TeleBanking online name
	ENDIF
// 	oFC := MyFileSpec{"mutcliop.txt"}
// 	oFC:Path:=CurPath
	// 	oFrabo := MyFileSpec{"mut.asc"}
	// 	oFrabo:Path:=CurPath
	SetPath(CurPath)
	* Determine filenames of MT940 files:
	aFileMT:=Directory(CurPath+"\*.STA")
	AEval(Directory("*.SWI"),{|x|AAdd(aFileMT,x)}) 
	AEval(Directory("*_ME940file20*.txt"),{|x|AAdd(aFileMT,x)})          // e.g.: 3001715206_ME940file20110117     MT940 extended
	AEval(Directory("*_MST940file20*.txt"),{|x|AAdd(aFileMT,x)})          // e.g.: 3001715206_MST940file20110117   MT940 structured
// 	AEval(Directory("*.940"),{|x|iif(At('IBAN',x[F_NAME])=0,AAdd(aFileMTING,x),AAdd(aFileMTIBANING,x))})          // e.g.: 6547100_01-10-2013_06-11-2013   MT940 postbank
	AEval(Directory("*.940"),{|x|AAdd(aFileMTIBANING,x)})          // e.g.: 6547100_01-10-2013_06-11-2013   MT940 postbank
	AEval(Directory("*CAMT*053*.xml"),{|x|AAdd(aFileCamT,x)})          // CamT053 file
	aFilePB:=Directory(CurPath+"\*-20??.CSV")
	aFileKB:=Directory(CurPath+"\*KTO*_*.CSV")
	aFileRO:=Directory(CurPath+"\RO??BTRL????????N???????-??.??.????-??.??.????.csv")  //RO38BTRLRONCRT00N3407802-01.07.2014-31.07.2014
	aFileHU:=Directory(CurPath+"\szamlatortenet_20??????_20??????.csv")   // szamlatortenet_20160101_20160123.csv
	aFileSA:=Directory(CurPath+"\statement-*-20??????.txt") 
	aFileSA2:=Directory(CurPath+"\multiple*.dat") 
	aFileUA:=Directory(CurPath+"\x*statements.TXT")
	aFileINN:=Directory(CurPath+"\ocrinnbet.txt*")
	aFileBBS:=Directory(CurPath+"\transliste*.csv")
	// 	aFileVWI:=Directory(CurPath+"\*????????verwinfo??.txt")
	//aFileVWI:=Directory(CurPath+"\*verwinfo*.txt")
	aFilePG:=Directory(CurPath+"\PG_8502000149_BG4_20??-??-??*.txt")
	aFileTL:=Directory(CurPath+"\PG_TOTALIN_TL1_*.txt")  
// 	AEval(Directory(CurPath+"\mut*.ASC"),{|x|AAdd(aFileRabo,x)})
	AEval(Directory(CurPath+"\*-20??.ASC"),{|x|AAdd(aFilePB,x)})
	AEval(Directory(CurPath+"\*-20??.TXT"),{|x|AAdd(aFilePB,x)})
	self:aValuesTrans:={}
// 	IF oFs:Find() .or. oFC:Find() .or.!Empty(aFileRabo).or.!Empty(aFileMT).or.!Empty(aFileMTING).or.!Empty(aFileMTIBANING);
	IF oFs:Find() .or.!Empty(aFileMT).or.!Empty(aFileMTIBANING);
		.or.!Empty(aFilePB).or.!Empty(aFileSA).or.!Empty(aFileSA2).or.!Empty(aFileKB).or.;
		!Empty(aFileUA).or.!Empty(aFileBBS).or.!Empty(aFileINN).or.!Empty(aFilePG);
		.or.!Empty(aFileTL).or.!Empty(aFileRO) .or. !Empty(aFileCamT) .or.!Empty(aFileHU) 
		lFilesFound:=true 
		self:oParent:Pointer := Pointer{POINTERHOURGLASS}

		* Establish last recording date per bank account: 
		oSel:=SQLSelect{"select bankaccntnbr,max(bookingdate) as maxdat from teletrans where bankaccntnbr in ("+self:cReqTeleBnk+") and bookingdate<=NOW() group by bankaccntnbr",oConn}
		oSel:execute()
		Do while !oSel:EOF 
			if !Empty(oSel:FIELDGET(1))
				i:=AScan(self:m57_BankAcc,{|x|x[1]==oSel:FIELDGET(1)}) 
				if i>0
					if !Empty(oSel:maxdat)
						self:m57_BankAcc[i,3]:=oSel:maxdat
					endif
				endif
			endif
			oSel:Skip()
		enddo
		
		IF oFs:Find()
			if self:ImportGiro(oFs)
				AAdd(aFiles,oFs)
			endif				
		ENDIF

// 		IF oFC:Find()
// 			if self:ImportCliop(oFC)
// 				AAdd(aFiles,oFC)
// 			endif				
// 		ENDIF

		// Import Bulk Rekening Info:	
// 		FOR nf:=1 to Len(aFileRabo)
// 			cFileName:=aFileRabo[nf,F_NAME]
// 			oBF := MyFileSpec{cFileName}
// 			if self:ImportBRI(oBF)
// 				AAdd(aFiles,oBF)
// 			endif				
// 		NEXT
// 		FOR nf:=1 to Len(aFileVWI)
// 			// VERWINFO of Equens
// 			cFileName:=aFileVWI[nf,F_NAME]
// 			oBF := MyFileSpec{cFileName}
// 			if self:ImportVerwInfo(oBF)
// 				AAdd(aFiles,oBF)
// 			endif				
// 		NEXT
		
		FOR nf:=1 to Len(aFileINN)
			cFileName:=aFileINN[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			if self:ImportBBSInnbetal(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT
		// Norwegian BBS Bank:
		FOR nf:=1 to Len(aFileBBS)
			cFileName:=aFileBBS[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			if	self:ImportBBS(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT
		// Import Sweden TOTAL IN data:	
		FOR nf:=1 to Len(aFileTL)
			cFileName:=aFileTL[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			if	self:ImportTL1(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT

		// MT940:
		FOR nf:=1 to Len(aFileMT)
			cFileName:=aFileMT[nf,F_NAME]
			oBF := MyFileSpec{cFileName} 
			if self:ImportMT940(oBF)
				AAdd(afiles,oBF)
			endif
		NEXT
		// MT940ING:
		FOR nf:=1 to Len(aFileMTING)
			cFileName:=aFileMTING[nf,F_NAME]
			oBF := MyFileSpec{cFileName} 
			if self:ImportMT940ING(oBF)
				AAdd(afiles,oBF)
			endif
		NEXT
		// MT940IBANING:
		FOR nf:=1 to Len(aFileMTIBANING)
			cFileName:=aFileMTIBANING[nf,F_NAME]
			oBF := MyFileSpec{cFileName} 
			if self:ImportMT940IBANING(oBF)
				AAdd(aFiles,oBF)
			elseif self:ImportMT940ING(oBF)    // apparently no IBAN 
				AAdd(aFiles,oBF)
			endif
		NEXT
		// CAMT.053:
		FOR nf:=1 to Len(aFileCamT)
			cFileName:=aFileCamT[nf,F_NAME]
			oBF := MyFileSpec{cFileName} 
			if self:ImportCAMT053(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT
		// South Africa Standard Bank:
		FOR nf:=1 to Len(aFileSA)
			cFileName:=aFileSA[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			if	self:ImportSA(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT
		FOR nf:=1 to Len(aFileSA2)
			cFileName:=aFileSA2[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			if	self:ImportSA2(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT
		// KB Bank Germany:
		FOR nf:=1 to Len(aFileKB)
			cFileName:=aFileKB[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			SQLStatement{"start transaction",oConn}:execute()
			if	self:ImportKB(oBF)
				SQLStatement{"commit",oConn}:execute()	
				AAdd(aFiles,oBF)
			else
				SQLStatement{"rollback",oConn}:execute()	
			endif				
		NEXT
		// Transilvania Bank Romania:
		FOR nf:=1 to Len(aFileRO)
			cFileName:=aFileRO[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			if	self:ImportRO(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT

		// Hungarian Bank:
		FOR nf:=1 to Len(aFileHU)
			cFileName:=aFileHU[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			if	self:ImportHU(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT

		// Ukraine Bank:
		FOR nf:=1 to Len(aFileUA)
			cFileName:=aFileUA[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			if	self:ImportUA(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT
		// Swedisch PG AutoGiro:
		FOR nf:=1 to Len(aFilePG)
			cFileName:=aFilePG[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			if	self:ImportPGAutoGiro(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT

		FOR nf:=1 to Len(aFilePB)
			cFileName:=aFilePB[nf,F_NAME]
			IF Len(cFileName)<29
				* no postbank file
				loop
			ENDIF
			aFileN:=Split(cFileName,"_")
			IF Len(aFileN)<3
				* no postbank file
				loop
			ENDIF
			IF !isnum(aFileN[1]) .and. !SubStr(aFileN[1],5,4)=="INGB"
				* no postbank file
				loop
			ENDIF
			IF Len(aFileN[2])#10 .or. Len(aFileN[3])#14 .or.IsAlpha(aFileN[2]).or.IsAlpha(aFileN[3]) .or. !"-"$aFileN[2].or. !"-"$aFileN[3]
				* no postbank file
				loop
			ENDIF
			
			oPF := FileSpec{cFileName}

			IF Upper(oPF:Extension)==".ASC"
				lSuccess:=self:ImportGiro(oPF)
			ELSE
				lSuccess:=self:ImportPostbank(oPF)
			ENDIF
			if	lSuccess
				AAdd(aFiles,oPF)
			endif
			// force garbage collection
// 			CollectForced()
			
		NEXT


		* Removing old transactions:
		IF self:lv_aant_toe>0
			* Calculate date too old (6 months old):
			//nOld:=Min(nOld,12)
			lv_mm := Month(Today())
			lv_jj := Year(Today())
			if lv_mm < (nOld+1)
				--lv_jj
				lv_mm:=lv_mm+(12-nOld)
			ELSE
				lv_mm:=lv_mm-nOld
			ENDIF

			lv_eind:=SToD(StrZero(lv_jj,4)+StrZero(lv_mm,2)+'01')
			SQLStatement{"delete from teletrans where bookingdate<'"+SQLdate(lv_eind)+"' and processed='X'",oConn}:execute()
		ELSE
		ENDIF
		self:oParent:Pointer := Pointer{POINTERARROW}

		// remove all files:
		for i:=1 to Len(aFiles)
			IF	!aFiles[i]:DELETE()
				if	!FErase(aFiles[i]:Fullpath)
					(WarningBox{,"Import	of	telebank transactions","Could not delete	file "+aFiles[i]:Fullpath}):Show()
				endif
			ENDIF
		next
	ENDIF
	// unlock software lock:
	SQLStatement{"start transaction",oConn}:execute()
	oLock:=SqlSelect{"select importfile from importlock where importfile='telelock' for update",oConn}
	oLock:execute() 
	if !Empty(oLock:Status)
		ErrorBox{,self:oLan:WGet("could not select importlock")+Space(1)+' ('+oLock:Status:description+')'}:Show()
		SQLStatement{"rollback",oConn}:execute() 
		return
	endif
	oStmnt:=SQLStatement{"update importlock set lock_id='0',lock_time= NULL where importfile='telelock'",oConn}
	oStmnt:execute()
	if !Empty(oStmnt:Status)
		ErrorBox{,self:oLan:WGet("could not unlock required transactions")}:Show()
		SQLStatement{"rollback",oConn}:execute()
	else 
		SQLStatement{"commit",oConn}:execute()  // save locks 
	endif
	if self:nTooOld>0 .or. self:nNonTele>0 .or. self:nDuplicate>0
		WarningBox{,"Import of telebanking transactions",iif(self:nTooOld>0,Str(self:nTooOld,-1) +" transactions skipped because older than 240 days or before month closing date"+CRLF,"")+;
			iif(self:nNonTele>0,Str(self:nNonTele,-1) +" transactions skipped because non telebank accounts:"+Implode(self:NonTeleAcc,', '),"")+CRLF+;
			iif(self:nDuplicate>0,Str(self:nDuplicate,-1) +" transactions skipped because duplicates of already imported transactions","")}:Show()	
		LogEvent(self,iif(self:nTooOld>0,Str(self:nTooOld,-1) +" transactions skipped because older than 240 days or before month closing date"+CRLF,"")+;
			iif(self:nNonTele>0,Str(self:nNonTele,-1) +" transactions skipped because non telebank accounts:"+Implode(self:NonTeleAcc,', '),"")+CRLF+;
			iif(self:nDuplicate>0,Str(self:nDuplicate,-1) +" transactions skipped because duplicates of already imported transactions",""))	
	endif
	if lFilesFound
		(InfoBox{,"Import of telebanking transactions",Str(self:lv_aant_toe,4)+" transactions imported"+iif(self:nReversals>0,+" including "+Str(self:nReversals,-1)+" REVERSALS OF DIRECT DEBIT","")+" (processed automatically "+Str(self:lv_processed,-1)+")"}):Show()
		for i:=1 to Len(self:aMessages)
			LogEvent(self,self:aMessages[i],"Log")
		next
	endif
	RETURN
METHOD ImportBBS(oFb as MyFileSpec) as logic CLASS TeleMut
	* Import of Norwegian BBS Bank data into teletrans.dbf
	LOCAL oHlS as HulpSA
	LOCAL m57_laatste := {} as ARRAY
	LOCAL i, TelPtr as int
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()) as int
	LOCAL lv_description, lv_bankAcntOwn,lv_addsub,lv_BankAcntContra,lv_NameContra,lv_budget,lv_persid,lv_kind as STRING
	LOCAL cSep as int
	LOCAL cDelim:=CHR(9) as STRING
	LOCAL ptrHandle as MyFile
	LOCAL hl_boekdat,lv_addsub as STRING
	LOCAL oFs:=oFb as FileSpec
	LOCAL cBuffer as STRING, nRead, nAccEnd as int
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate, ptPay, ptDesc, ptDep, nVnr as int
	LOCAL lv_Amount, Hl_balan as FLOAT
	LOCAL ld_bookingdate as date
	Local cBankAcc as string
	local oStmnt as SQLStatement
	local nTrans,nImp,nProc as int
	Local lSuccess as logic

	ptrHandle:=MyFile{oFs}
	IF FError() >0
		(ErrorBox{,"Could not open file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine()
	IF Empty(cBuffer)
		ptrHandle:Close()
		ptrHandle:=null_object 
		(ErrorBox{,"Could not read file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	if !GetDelimiter(cBuffer,@aStruct,@cDelim,4,5)
		ptrHandle:Close()
		ptrHandle:=null_object 
		(ErrorBox{,"Wrong fileformat of importfile from BBS Bank: "+oFs:FullPath+"(See help)"}):show()
		RETURN FALSE
	ENDIF
	ptDate:=AScan(aStruct,{|x| "DATO" $ x})
	ptDesc:=AScan(aStruct,{|x| "FORKLARING" $ x})
	ptPay:=AScan(aStruct,{|x| "UT AV KONTO" $ x})
	ptDep:=AScan(aStruct,{|x| "INN P� KONTO" $ x})
	IF ptDate==0 .or. ptDesc==0 .or. ptPay==0 .or. ptDep==0
		(ErrorBox{,"Wrong fileformat of importfile from BBS Bank: "+oFs:FullPath+"(See help)"}):show()
		RETURN FALSE
	ENDIF
	// Determine Bankaccount of Wycliffe at BBS:
	lv_bankAcntOwn:=ZeroTrim(BANKNBRDEB)
	if Empty(lv_bankAcntOwn)
		(ErrorBox{,self:oLan:WGet("Bank account for direct debit not specified within system parameters, invoicing")}):show()
		return false
	endif
	cBuffer:=ptrHandle:FReadLine()
	aFields:=Split(cBuffer,cDelim)
	nImp:=0
	nTrans:=0
	SaveUse("ImportBBS")
	DO WHILE Len(AFields)>3
		ld_bookingdate:=CToD(AFields[ptDate])
		IF ld_bookingdate >=Today() .or. self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_description:=AllTrim(StrTran(AllTrim(AFields[ptDesc]),'"',''))
		lv_amount:=AbsFloat(Val(strtran(aFIELDs[ptPay],',','.')) )
		IF lv_Amount=0
			lv_Amount:=Val(StrTran(AFields[ptDep],',','.'))
			lv_addsub:="B"
		ELSE
			lv_addsub:="A"
		ENDIF 
		lv_kind:='BBS'
		IF Empty(lv_Amount)  && skip empty lines
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_Amount:=Round(lv_Amount,DecAantal) 
		lv_BankAcntContra:=""
		IF Upper(lv_description)=="TOTALT KREDITERT OCR-GIRO" .or. Upper(lv_description)=="SUM OCR-GIRO"
			lv_kind:= "OCR"
		elseif Upper(SubStr(lv_description,1,4))=="FRA:"
			nAccEnd:=At3(lv_description," ",6)
			if nAccEnd>0
				cBankAcc:=StrTran(AllTrim(SubStr(lv_description,5,nAccEnd-6)),".","")
				if isnum(cBankAcc)
					// apparently bankaccount:
					lv_BankAcntContra:=cBankAcc
				endif
			endif
		ENDIF
		* check if allready loaded:
		lv_description:=AddSlashes(AllTrim(lv_description))
		lv_BankAcntContra:=ZeroTrim(lv_BankAcntContra) 
		IF !self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,lv_kind,"","","")
			nTrans++
			self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,'',lv_BankAcntContra,;
				lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid) 
		endif
		lv_description:=""
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	ptrHandle:=null_object 
// 	nImp:=self:lv_aant_toe
// 	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(false,false,"BBS file:"+oFb:FileName,nTrans)
// 	AAdd(self:aMessages,"Imported BBS file:"+oFb:FileName+" "+Str(self:lv_aant_toe -nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		return true
	else
		return false                                              
	endif

METHOD ImportBBSInnbetal(oFm as MyFileSpec) as logic CLASS TeleMut
	*	Import of one BBS Innbetaling transaction file (with KID numbers)
	LOCAL lv_Amount as FLOAT
	local fSum as float
	local nTrans,nImp,nSub,nProc,nPos,nTot as int  
	LOCAL lv_bankAcntOwn, lv_description, lv_addsub, lv_AmountStr, lv_Budgetcd,  lv_reference, lv_persid,lv_NameContra,lv_dueid as STRING
	LOCAL AccSDON as STRING 
	local cWarning as string
	local lv_InvoiceID as usual
	LOCAL lSuccess:=true as LOGIC
	LOCAL lv_loaded as LOGIC
	LOCAL ld_bookingdate as date 
	local startdate,enddate as date
	local aSubscr:={} as array // array with persid's in donation subscriptions {persid,invoiceid,accid,accnumber,dueid,amountinvoice,amountrcvd,fullname},... 
	LOCAL oHlp as FileSpec
	local oStmnt as SQLStatement
	local oSel as SQLSelect
	local oStmnt as SQLStatement
	LOCAL oHlM as HlpMT940

	
	IF Empty(SDON)
		(WarningBox{,"Import of Innbetal transactions","Specify first within system parameters account for donations as default destination"}):Show()
		RETURN FALSE
	ENDIF	
	SaveUse("ImportBBSInnbetal")
	oSel:=SqlSelect{"select accnumber from account where accid="+SDON,oConn}
	if oSel:Reccount>0
		AccSDON:=oSel:ACCNUMBER
	ENDIF 
	oHlM :=HLPMT940{HelpDir+"\HBBI"+StrTran(StrTran(Time(),":"),' ','')+".DBF",DBEXCLUSIVE}
	oHlM:Zap()
	
	lSuccess:=oHlM:AppendSDF(oFm)
	oHlM:Gotop()
	// search for first bookingdate in ocrinnbet:
	do while !oHlM:EOF
		if (SubStr(oHlM:MTLINE,1,4)=="NY09".and.SubStr(oHlM:MTLINE,7,2)=="30")   // first line of transaction
			ld_bookingdate:=SToD("20"+SubStr(oHlM:MTLINE,20,2)+SubStr(oHlM:MTLINE,18,2)+SubStr(oHlM:MTLINE,16,2)) // valuta date  
			// determine begin and end of corresponding month (ocrinnbet only of one month)
			startdate:=SToD(Str(Year(ld_bookingdate),4)+StrZero(Month(ld_bookingdate),2)+'01')
			enddate:=EndOfMonth(ld_bookingdate)
			exit
		else
			oHlM:Skip()
		endif
	enddo
	if Empty(ld_bookingdate)
		ErrorBox{self,self:oLan:WGet("illegal file format")+' '+oFm:FullPath}:Show()
		return false
	endif
	// find corresponding due amounts:
	oSel:=SqlSelect{"select group_concat(cast(COALESCE(gr.personid,0) as char),'#$#',COALESCE(gr.invoiceid,''),'#$#',cast(COALESCE(gr.accid,0) as char),'#$#',COALESCE(gr.accnumber,''),'#$#',gr.dueid,'#$#',cast(gr.amountinvoice as char),'#$#',cast(gr.amountrecvd as char),'#$#',gr.fullname separator '#%#') as grdueamnts from "+;
	"(select s.personid,s.invoiceid,a.accid,a.accnumber,d.dueid,d.amountinvoice,d.amountrecvd,"+SQLFullName(0,'p')+" as fullname from dueamount d left join subscription s on (d.subscribid=s.subscribid) left join account a on (a.accid=s.accid) "+; 
	'left join person p on(p.persid=s.personid) '+;
	'where d.amountinvoice>d.amountrecvd and d.invoicedate between "'+SQLdate(startdate)+'" and "'+SQLdate(enddate)+'") as gr',oConn}   
	if oSel:Reccount>0 .and.!Empty(oSel:grdueamnts)
		// aSubscr: {{personid,invoiceid,accid,accnumber,dueid,amountinvoice,amountrcvd,fullname},...}
		//                1       2        3      4        5          6           7         8
		AEval(Split(oSel:grdueamnts,'#%#'),{|x|AAdd(aSubscr,Split(x,'#$#')) }) 
	endif
// 	oSel:=SqlSelect{"select group_concat(cast(s.personid as char),,invoiceid,cast(a.accid as char).a.accnumber,
// 	oSel:=SqlSelect{"select s.personid,invoiceid,s.accid,a.accnumber  from subscription s left join account a on (a.accid=s.accid) where category='D'",oConn} 
// 	if oSel:Reccount>0
// 		do while !oSel:EOF
// 			AAdd(aSubscr,{ConS(oSel:personid),oSel:invoiceid,Transform(oSel:ACCNUMBER,""),ConS(oSel:accid)})
// 			oSel:Skip()
// 		enddo
// 	endif
	*Look for NY090020: record with accountnumber
	*	Look for next line until line =NY090020
	*		if 61: amount
	*		if 85: corresponding description with counteraccount
	*			add record to teletrans
	*
	oHlM:Gotop()
	nImp:=0
	nTrans:=0
	DO WHILE .not.oHlM:EOF
		* Search NY090020 record:
		IF !SubStr(oHlM:MTLINE,1,8)=="NY090020"
			oHlM:Skip()
			loop
		ENDIF
		lv_bankAcntOwn:=ZeroTrim(SubStr(oHlM:MTLINE,25,11))
		oHlM:Skip()
		DO WHILE .not.oHlM:EOF
			* Search for NY09XX30 (amount and kidnbr):
			* Stop if NY090088 record:
			IF SubStr(oHlM:MTLINE,1,8)=="NY090088"
				exit
			ENDIF
			IF (SubStr(oHlM:MTLINE,1,4)=="NY09".and.SubStr(oHlM:MTLINE,7,2)=="30")   // first line of transaction
				ld_bookingdate:=SToD("20"+SubStr(oHlM:MTLINE,20,2)+SubStr(oHlM:MTLINE,18,2)+SubStr(oHlM:MTLINE,16,2)) // valuta date
				lv_addsub:="B"
				lv_AmountStr:=SubStr(oHlM:MTLINE,33,17)
				lv_Amount:=Round(Val(lv_AmountStr)/100.00,2)
				// Determine from KIDnr personid and accountnbr:
				lv_InvoiceID:=AllTrim(SubStr(oHlM:MTLINE,62,13))
				lv_description:=lv_InvoiceID 
				lv_Budgetcd:=ZeroTrim(SubStr(lv_InvoiceID,7,6))
				lv_persid:=ZeroTrim(SubStr(lv_InvoiceID,1,6)) 
				lv_dueid:=''
				// aSubscr: {{personid,invoiceid,accid,accnumber,dueid,amountinvoice,amountrcvd,fullname},...}
				//                1       2        3      4        5          6           7         8
				nSub:=AScan(aSubscr,{|x|x[2]==lv_InvoiceID.and.lv_Amount==round((Val(x[6])-val(x[7])),2)})
				if nSub>0
					lv_persid:=aSubscr[nSub,1]
					if !Empty(aSubscr[nSub,3])
						lv_Budgetcd:=aSubscr[nSub,4]
					endif
					lv_dueid:=aSubscr[nSub,5]
					aSubscr[nSub,7]:=Str(Round(Val(aSubscr[nSub,7])+lv_Amount,2),-1)
				elseif (oSel:=SqlSelect{"select persid from personbank where banknumber='"+ZeroTrim(lv_InvoiceID)+"'",oConn}):Reccount>0
					lv_persid:=Str(oSel:persid,-1)
				elseif SqlSelect{"select persid from person where persid="+lv_persid,oConn}:Reccount>0
					lv_persid:=lv_persid
				else
					lv_persid:="0"
				endif
				IF Empty(lv_Budgetcd)
					// try to find corresponding donation:
					lv_Budgetcd:=AccSDON  // default Donations account
				ENDIF
				lv_reference:=SubStr(oHlM:MTLINE,5,2)
				lv_description:=AddSlashes(AllTrim(lv_description))
				nTrans++
				* save transaction:
				self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(Val(SubStr(oHlM:MTLINE,9,7)),-1),ZeroTrim(lv_InvoiceID),;
					'KID',lv_NameContra,lv_Budgetcd,lv_Amount,lv_addsub,lv_description,lv_persid,,,,lv_dueid)
				lv_description:=""
			ENDIF
			oHlM:Skip()
		ENDDO
	ENDDO

	oHlp:=FileSpec{oHlM:FileSpec:FullPath}
	oHlM:Close()
	oHlM:=null_object
	oHlp:DELETE()
// 	nImp:=self:lv_aant_toe 
// 	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(false,true,"Innbetalinger fra BBS file:"+oFm:FileName,nTrans)
// 	AAdd(self:aMessages,"Imported Innbetalinger fra BBS file:"+oFm:FileName+" "+Str(self:lv_aant_toe -nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		// show missing direct debits:
		ASort(aSubscr,,,{|x,y|x[8]<=y[8]})
		do while (nPos:=AScan(aSubscr,{|x|x[7]='0.00'},nPos+1))>0
			cWarning+=CRLF+aSubscr[nPos,8]+' -> '+aSubscr[nPos,4]+': '+aSubscr[nPos,6]+' '+sCurr
			nTot++
			fSum:=round(fSum+val(aSubscr[nPos,6]),2)
		enddo
		if !Empty(cWarning)
			cWarning:="The following "+str(nTot,-1)+" direct debits ("+str(fSum,-1)+' '+sCurr+") are missing:"+cWarning
			LogEvent(self,cWarning)
			WarningBox{,"Innbetalinger fra BBS",cWarning}:Show()
		endif 
		return true
	else
		return false                                              
	endif
METHOD ImportCAMT053(oFm as MyFileSpec) as logic CLASS TeleMut
	*	Import of one CAMT.053 telebnk transaction file 
	local nStmnt,nNtry,j,nSepPos,nOffset,nNumPos,nSeqnr as int 
	LOCAL i,np,nn,nEl1,nEl2,nEl3,nEl4, nTrans,nBal as int
	
	LOCAL lv_Amount,lv_balance as FLOAT
	LOCAL cBuffer as STRING
	local lv_bankAcntOwn,lv_description,lv_kind,lv_kindORG, lv_addsub,  lv_BankAcntContra,lv_NameContra,lv_AdrLine,lv_Country, lv_reference,lv_BIC, cText as string 
	local lv_budget , Cur_enRoute,lv_persid,lv_bankid,lv_Oms,lv_EndtoEnd,lv_dueid,lv_rtrn,lv_marf as string
	local cType86 as string  //type of tag 86: B=bank,
	LOCAL BalFound,AmntFound,lDebit,lReversal,lResult,lDetails as LOGIC 
	local aBudg:={} as array
	local aWord:={} as array
	LOCAL ptrHandle as ptr
	LOCAL oXMLParser as XMLParser
	local oBkToCstmrStmt as XMLElement
	local oStmt,oAcct,oBal,oNtry,oSub,oTx,oId,oIdent,oElm,oElm2,oElm3,oElm4 as XMLElement
	local oBank as SQLSelect
	local	oBord	as	SQLSelect 
	
	
	// 	LOCAL childfound, Statementfound, IBANfound as LOGIC
	// 	LOCAL i, nEndAmnt, nDC, nOffset, nTrans,nImp,nNumPos,nSepPos,nLenLine1,nBGCSeq,nProc as int
	// 	LOCAL lv_Oms, lv_AmountStr,lv_referenceCur  as STRING
	LOCAL lv_loaded as LOGIC 
//	local Cur_RekNrOwn as string
	LOCAL lSuccess:=true as LOGIC
	LOCAL ld_bookingdate as date 
	local lMTExtended as logic
	local aWord as array
	local oStment as SQLStatement
	// 	local time0,time1 as float

	self:oParent:Pointer := Pointer{POINTERHOURGLASS} 
	
	// Proces records: 
	// 	LogEvent(self,"start "+oFm:Fullpath,"logsql")
	// 	time0:=Seconds()
	oXMLParser := XMLParser{}
	oXMLParser:loadFile(oFm:Fullpath) 
	// 	time1:=time0
	// 	LogEvent(self,"load:"+Str((time0:=Seconds())-time1,-1),"logsql")
	if !oXMLParser:RootElement:Name==#Document  .or. (oBkToCstmrStmt:=oXMLParser:RootElement:GetElementOnName(#BkToCstmrStmt))==null_object
		(ErrorBox{,self:oLan:WGet('No correct CAMT053 file')+' '+AllTrim(oFm:FileName)}):show()
		RETURN false
	ENDIF 
	// 	LogEvent(self,"loaded","logsql")
	self:aValuesTrans:={} 
	// 	do while (nStmnt:=oBkToCstmrStmt:XMLScan(#Stmt,nStmnt))>0
	// 		oStmt:=oBkToCstmrStmt:GetElementOnPosition(nStmnt) 
	nStmnt:=0
	SaveUse("ImportCAMT053")
	do while !(oStmt:=oBkToCstmrStmt:ScanElement(#Stmt,@nStmnt))==null_object
		BalFound:=false 
		lv_bankAcntOwn:=''
		nSeqnr:=0 
		nn:=0
		if !(oAcct:=oStmt:ScanElement(#Acct,@nn))==null_object 
			i:=0
			if !(oId:=oAcct:ScanElement(#Id,@i))==null_object
				for j:=1 to oId:NbrOfSubElements
					oIdent:=oId:GetElementOnPosition(j)
					if oIdent:Name==#IBAN
						lv_bankAcntOwn:=oIdent:STRINGValue
						exit
					elseif oIdent:Name==#othr
						nEl3:=0
						oElm3:= oIdent:ScanElement(#Id,@nEl3)
						lv_bankAcntOwn:=StrTran(oElm3:STRINGValue,'P','0')
						exit
					endif 
				next
			endif
			if !Empty(lv_bankAcntOwn)
				Cur_enRoute:=""
				oBank:=SqlSelect{"select b.payahead,a.accnumber from bankaccount b, account a where not b.payahead is null and a.accid=b.payahead and banknumber='"+lv_bankAcntOwn+"'",oConn}
				if oBank:Reccount>0
					Cur_enRoute:=oBank:ACCNUMBER
				endif
			endif
			// 			oBal:=oStmt:GetElementOnName(#Bal)
			BalFound:=false 
			nBal:=0
			do while !(oBal:=oStmt:ScanElement(#Bal,@nBal))==null_object .and.!BalFound
				lDebit:=false 
				AmntFound:=false
				For j:=1 to oBal:NbrOfSubElements
					if (oSub:=oBal:GetElementOnPosition(j))==null_object
						exit
					endif
					DO case
					case oSub:Name==#Tp
						nEl1:=0
						if !(oElm:= oSub:ScanElement(#CdOrPrtry,@nEl1))==null_object 
							nEl2:=0
							if !(oElm2:=oElm:ScanElement(#Cd,@nEl2))==null_object
								if oElm2:STRINGValue=='CLBD'
									// 					if oSub:GetElementOnName(#CdOrPrtry):GetElementOnName(#Cd):STRINGValue=='CLBD'
									BalFound:=true
								else
									exit // to next Bal
								endif 
							endif
						endif
					case oSub:Name==#Amt
						lv_balance:=Val(oSub:STRINGValue) 
					case oSub:Name==#CdtDbtInd
						if oSub:STRINGValue=='DBIT'
							lDebit:=true
						endif 
					case oSub:Name==#Dt
						oElm:= oSub:GetElementOnPosition(1)
						ld_bookingdate:=SQLDate2Date(oElm:STRINGValue)	
					endcase 
				next
				if BalFound
					if lDebit
						lv_balance:=-lv_balance
					endif
					AAdd(self:avaluesBal,{lv_bankAcntOwn,ld_bookingdate,lv_balance}) 
					exit
				endif
				
				// 				oBal:=oStmt:GetNextElementOnName(#Bal)
			enddo
			// 			oNtry:=oStmt:GetElementOnName(#Ntry)
			nNtry:=0
			do while !(oNtry:=oStmt:ScanElement(#Ntry,@nNtry))==null_object 
				// process transaction: 
				lDebit:=false 
				lReversal:=false
				lv_Amount:=0.00
				lv_reference:=""
				lv_NameContra:=""
				lv_BankAcntContra:="" 
				lv_AdrLine:=""
				lv_Country:='' 
				lv_description:=''
				lv_BIC:='' 
				lv_budget:=''
				lv_dueid:='' 
				lv_rtrn:=''
				lv_marf:=''
				lv_addsub:='B' 
				lv_persid:=''
				lv_EndtoEnd:=''
				lDetails:=false 
				For j:=1 to oNtry:NbrOfSubElements
					if (oSub:=oNtry:GetElementOnPosition(j))==null_object
						exit
					endif
					DO case
					case oSub:Name==#Amt
						lv_Amount:=Val(oSub:STRINGValue)
					case oSub:Name==#CdtDbtInd
						if oSub:STRINGValue=='DBIT'
							lDebit:=true 
							lv_addsub:='A'
						endif
					case oSub:Name==#BookgDt
						oElm:= oSub:GetElementOnPosition(1)
						ld_bookingdate:=SQLDate2Date(oElm:STRINGValue)	
					case oSub:Name==#AddtlNtryInf 
						lv_description:=oSub:STRINGValue 
						* get contra bank account number:
						IF  Empty(lv_BankAcntContra) 
							IF lv_description = "GIRO "
								lv_BankAcntContra:= SubStr(lv_description,8,8)
								if sepaEnabled
									PadL(lv_BankAcntContra,10,'0')
								else
									ZeroTrim(lv_BankAcntContra)
								endif
								lv_description := AllTrim(SubStr(lv_description,16))
							ELSE
								cText := SubStr(lv_description,1,13)
								IF isnum(AllTrim(cText))
									lv_BankAcntContra:=ZeroTrim(StrTran(cText,"."))
									IF Val(lv_BankAcntContra)<100000000
										lv_BankAcntContra:=""
									ELSE
										if sepaEnabled
											PadL(lv_BankAcntContra,10,'0')
										else
											ZeroTrim(lv_BankAcntContra)
										endif
										lv_description := AllTrim(SubStr(lv_description,14))
									ENDIF
								ELSE
									lv_BankAcntContra:=""
								ENDIF
							endif
						endif
					case oSub:Name==#NtryRef
						lv_reference:=oSub:STRINGValue
					case oSub:Name==#RvslInd
						lReversal:=true
					case oSub:Name==#BkTxCd
						nEl1:=0
						if !(oElm:=oSub:ScanElement(#Prtry,@nEl1))==null_object
							oElm2:=oElm:GetElementOnPosition(1)
							lv_kind:=oElm2:STRINGValue
							lv_kindORG:=lv_kind
							if lv_kind=='123' ;     // bijschrijving acceptgiro equens
								.or. lv_kind=='583' .or. lv_kind=='055' .or. lv_kind=='401'  // crediteuren betaling equens/rflp
								lv_kind:='CLR'
							elseif lv_kind=='134'   // bijschrijving acceptgiro
								lv_kind:='AC' 
							elseif lv_kind=='100' .or. lv_kind=='103' //ideal bijschrijving 
								lv_kind:='IDEAL' 
							elseif lv_kind=='640' // doorlopende machtiging     (eigen)
								lv_kind:='COL' 
							elseif lv_kind=='104' .or.lv_kind=='106'.or.lv_kind=='107' .or.lv_kind=='108' .or.lv_kind=='110'.or.lv_kind=='111' ; // terugboeking euro-incasso
								.or.lv_kind=='631'.or.lv_kind=='632'.or.lv_kind=='633'.or.lv_kind=='166' ;                     // terugboeking euro-incasso
								.or. lv_kind=='629';      // euro incasso core equens
								.or. lv_kind=='680'.or. lv_kind=='681'     // euro-incasso rflp bijschrijving
								lv_kind:='COL'+iif(lv_kindORG='166',"REJ",'')  
							endif 
						endif
					case oSub:Name==#NtryDtls .and.(lv_kindORG=='583' .or. lv_kindORG=='055' .or. lv_kindORG=='401')   // crediteuren betaling equens/rflp 
						// record only total batch:
						lv_description:="Total batch credit transfer" 
						lv_budget:=Cur_enRoute 
					case oSub:Name==#NtryDtls .and.!(lv_kindORG=='583' .or. lv_kindORG=='055' .or. lv_kindORG=='401')   // no crediteuren betaling equens/rflp
						nn:=0 
						lDetails:=true
						do while !(oTx:=oSub:ScanElement(#TxDtls,@nn))==null_object 
							// transaction details: 
							nEl1:=0
							if !Empty(oElm:=oTx:ScanElement(#Refs,@nEl1))
								nEl2:=0 
								if !Empty(oElm2:=oElm:ScanElement(#EndToEndId,@nEl2))
									lv_reference:='EndtoEnd:'+oElm2:STRINGValue
									lv_EndtoEnd:= oElm2:STRINGValue
								endif
								nEl2:=0 
								if !Empty(oElm2:=oElm:ScanElement(#MndtId,@nEl2))
									lv_reference+=' Mandateid:'+ oElm2:STRINGValue
									lv_marf:=oElm2:STRINGValue
								endif
								
								nEl2:=0 
								if !Empty(oElm2:=oElm:ScanElement(#PmtInfId,@nEl2))
									lv_reference:=oElm2:STRINGValue
								endif
							endif 
							nEl1:=0
							if !Empty(oElm:=oTx:ScanElement(#AmtDtls,@nEl1))
								nEl2:=0 
								if !Empty(oElm2:=oElm:ScanElement(#InstdAmt,@nEl2)) 
									oElm3:=oElm2:GetElementOnPosition(1)    // Amt
									lv_Amount:=Val(oElm3:STRINGValue)
								endif
							endif 
							nEl1:=0
							if !Empty(oElm:=oTx:ScanElement(#RltdPties,@nEl1))  
								// Dbtr or Cdtr: 
								nEl2:=0
								nEl1:=0
								if !Empty(oElm2:=oElm:ScanElement(#Dbtr,@nEl2)) .or.!Empty(oElm2:=oElm:ScanElement(#Cdtr,@nEl1)) 
									nEl3:=0
									if !Empty(oElm3:=oElm2:ScanElement(#Nm,@nEl3))
										lv_NameContra:=oElm3:STRINGValue
									endif
									nEl3:=0
									if !Empty(oElm3:=oElm2:ScanElement(#PstlAdr,@nEl3)) 
										nEl4:=0
										if !Empty(oElm4:=oElm3:ScanElement(#Ctry,@nEl4))
											lv_Country:=oElm4:STRINGValue 							 		 	
										endif 
										nEl3:=0
										Do while !(oElm4:=oElm3:ScanElement(#AdrLine,@nEl3))==null_object
											lv_AdrLine+=oElm4:STRINGValue+' '
										enddo
									endif
								endif
								nEl1:=0
								nEl2:=0
								if !Empty(oElm2:=oElm:ScanElement(#DbtrAcct,@nEl1)) .or. !Empty(oElm2:=oElm:ScanElement(#CdtrAcct,@nEl2))
									nEl2:=0								 	
									if !(oId:=oElm2:ScanElement(#Id,@nEl2))==null_object
										oIdent:=oId:GetElementOnPosition(1)
										if oIdent:Name==#IBAN
											lv_BankAcntContra:=oIdent:STRINGValue
										elseif oIdent:Name==#othr
											nEl3:=0
											oElm3:= oIdent:ScanElement(#Id,@nEl3)
											if !lv_kindORG=='199'     // internal bank account for bank cost etc
												lv_BankAcntContra:=StrTran(oElm3:STRINGValue,'P','0')
											endif 
										endif 
									endif
								endif
							endif
							nEl1:=0
							if !Empty(oElm:=oTx:ScanElement(#RltdAgts,@nEl1))
								if !Empty(oElm2:=oElm:GetElementOnPosition(1))  // DbtrAgt or CdtrAgt
									if !Empty(oElm3:=oElm2:GetElementOnPosition(1)) //FinInstnId
										if !Empty(oElm4:=oElm3:GetElementOnPosition(1)) //BIC
											lv_BIC:=oElm4:STRINGValue 
										endif
									endif
								endif
							endif
							nEl1:=0
							nEl2:=0
							if !Empty(oElm:=oTx:ScanElement(#RmtInf,@nEl1)) 
								// 								if !Empty(oElm2:=oElm:ScanElement(#Ustrd,@nEl2))
								cType86:='' 
								do while !Empty(oElm2:=oElm:ScanElement(#Ustrd,@nEl2)) 
									lv_Oms:=oElm2:STRINGValue 
									nNumPos:=AtC('-nummer',lv_Oms)
									if AtC('BETREFT ACCEPTGIRO',lv_Oms)>0  .or. AtC('VX-NUMMER',lv_Oms)>0.or. AtC('CREDITEURENBETALING',lv_Oms)>0
										if AtC('VX-NUMMER',lv_Oms)>0
											cType86:='VX'                     // terugboeking incasso?
										else 
											cType86:='CLR'
										endif
										if isnum(lv_kind)
											// 											if Empty(Cur_enRoute)
											// 												(ErrorBox{,"for bank account "+ Cur_RekNrOwn+" no 'Account payments en route' specified; import aborted1"}):show()
											// 												return false 
											// 											endif
											lv_budget:=Cur_enRoute
											lv_kind:="CLR"
										endif
									elseif nNumPos>2
										cType86:='Bank'
									else
										cType86:="ADRES" 

										// 										if !lv_Oms="TRANSACTIEDATUM".and. AtC('-nummer',lv_Oms)=0 ;   // skip line with "TRANSACTIEDATUM" or number
										// 											.and. !(SubStr(lv_Oms,1,2)='BE' .and. IsDigit(SubStr(lv_Oms,3)))  // skip belgi� nummers
										// 											self:GetPaymentPattern(lv_Oms,lv_addsub,@lv_budget,@lv_persid,@lv_bankid,@lv_kind)
										if Empty(lv_budget)
											//	look for	payment pattern:
											aWord:=GetTokens(lv_Oms,{'	',','})
											if	(np:=AScan(aWord,{|x|isdigit(x[1]).and.isnum(x[1]).and.len(x[1])=16}))>0
												self:GetPaymentPattern(aWord[np,1],lv_addsub,@lv_budget,@lv_persid,@lv_bankid,@lv_kind) 
											endif
										endif
									endif
									lv_description+=" "+lv_Oms
								ENDDO
								if	cType86=="VX" .and.isnum(lv_kind)
									if	(nNumPos:=AtC("BETALINGSKENM",lv_description))>0
										if	!isnum(AllTrim(SubStr(lv_description,nNumPos+16,16)) )
											lv_budget:=''	 // no really Cur-en-route         Ideal??
										endif
									endif
								endif
								//	check	on	special messages:	
								nSepPos:=0
								if	cType86='Bank'
									if	Empty(lv_kind)
										nSepPos:=AtC('EUROBETALING	SHA',lv_description)
										if	nSepPos>0
											nSepPos+=Len('EUROBETALING	SHA')-1
											lv_BankAcntContra:=""	//	ignore account	in	case of payment from	other	country in Euro 
										else
											if	isnum(lv_kind) .and.AtC('TOTAAL	INCASSO',lv_description)>0	.or. AtC('DOORLOPENDE MACHTIGING	ALGEMEEN',lv_description)>0
												lv_budget:=Cur_enRoute 
												lv_kind:="COL"
											endif
										endif
									endif
								endif	            							

								if	lv_kind=='593' .or.;  // Terugboeking/afkeuring Eurobetaling
									AtC('NAAM/NUMMER STEMMEN NIET	OVEREEN',lv_description)>0	
									nSepPos:=0 
									//	look for	bankorder: 
									oBord:=SqlSelect{'select a.accnumber,s.gc from	bankorder o, account	a, standingorderline s where banknbrcre="'+lv_BankAcntContra+'"'+;
										' and datepayed>"'+SQLdate(ld_bookingdate-10)+'"'+' and s.stordrid=o.stordrid and s.deb>s.cre and a.accid=s.accountid',	oConn} 
									if	oBord:Reccount>0	 
										lv_budget:=AllTrim(oBord:ACCNUMBER)
									else
										lv_budget:=""
									endif
								endif
								if	nSepPos>0 .and.!lDebit	.and.AtC('AFROMEN',lv_description)=0
									lv_description:=AllTrim(SubStr(lv_description,1,nSepPos))+'%%'+SubStr(lv_description,nSepPos+1,)
								endif 

								nEl2:=0									
								if	!Empty(oElm2:=oElm:ScanElement(#Strd,@nEl2))
									//	process structured info	
									nEl3:=0
									if	!Empty(oElm3:=oElm2:ScanElement(#CdtrRefInf,@nEl3))
										nEl4:=0
										if	!Empty(oElm4:=oElm3:ScanElement(#Ref,@nEl4))
											lv_reference:=oElm4:STRINGValue
										endif
									endif									
								endif
								
							endif
							nEl1:=0
							nEl2:=0
							if !Empty(oElm:=oTx:ScanElement(#RtrInf,@nEl1))
								if	!Empty(oElm2:=oElm:ScanElement(#Rsn,@nEl2))
									nEl3:=0 
									if	!Empty(oElm3:=oElm2:ScanElement(#Cd,@nEl3))
										lv_description+=' '+oElm3:STRINGValue
										lv_rtrn:=oElm3:STRINGValue
									endif
								endif
								nEl2:=0
								if	!Empty(oElm2:=oElm:ScanElement(#AddtlInf,@nEl2)) 
									lv_description+=' '+oElm2:STRINGValue
									if SubStr(lv_kind,1,3)=='COL'
										if Len(Split(lv_EndtoEnd,'-'))>=3
											lv_persid:=Split(lv_EndtoEnd,'-')[1]
											if !isnum(lv_persid)
												lv_persid:=''
											else
												lv_dueid:=Split(lv_EndtoEnd,'-')[3]
												if !isnum(lv_dueid)
													lv_dueid:=''
												endif 
											endif
										endif
									endif
								endif
							endif 
							
							* save transaction: 
							if Empty(lv_budget) .and.(lv_kind=='CLR' .or. (SubStr(lv_kind,1,3)=='COL' .and.lv_addsub='B' .and. Empty(lv_rtrn))) 
								if Empty(Cur_enRoute)
									(ErrorBox{,"for bank account "+ lv_bankAcntOwn+" no 'Account payments en route' specified; import aborted"}):show()
									return false 
								endif
								lv_budget:=Cur_enRoute
							endif

							nTrans++
							if	Empty(lv_budget)
								//	Look for	budget code	between * or [] or ()
								if	(nOffset:=At('*',lv_description))>0
									if At3('*',lv_description,nOffset+1)>0  // 2e *	
										aBudg:=Split(SubStr(lv_description,nOffset+1),'*')
										if	Len(aBudg)>0 .and. isnum(aBudg[1])
											lv_budget:=aBudg[1]
										endif
									endif
								endif
								if	Empty(lv_budget) .and. (nOffset:=At('[',lv_description))>0
									aBudg:=Split(SubStr(lv_description,nOffset+1),']')	
									if	Len(aBudg)>0 .and. isnum(aBudg[1])
										lv_budget:=aBudg[1]
									endif					
								endif
								if	Empty(lv_budget) .and. (nOffset:=At('(',lv_description))>0
									aBudg:=Split(SubStr(lv_description,nOffset+1),')')	
									if	Len(aBudg)>0 .and. isnum(aBudg[1])
										lv_budget:=aBudg[1]
									endif
								endif
							endif
							if lv_kind=='AC' .and.empty(lv_budget) .and. !empty(lv_reference)
								self:GetPaymentPattern(lv_reference,lv_addsub,@lv_budget,@lv_persid,@lv_bankid,@lv_kind)
							endif
							lv_description:=Compress(lv_description+' '+lv_reference)
							lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))   //max length 32 in teletrans 
							if Empty(lv_Country).and.IsAlpha(lv_BankAcntContra)
								lv_Country:=SubStr(lv_BankAcntContra,1,2)
							endif
							if Empty(lv_BIC) .and.IsAlpha(lv_BankAcntContra)
								lv_BIC:=GetBIC(lv_BankAcntContra)
							endif

							lv_NameContra:=AddSlashes(AllTrim(SubStr(HtmlDecode(lv_NameContra),1,32)))   //max length 32 in teletrans
							nSeqnr++
							self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(nSeqnr,-1),lv_BankAcntContra,;
								lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,AddSlashes(HtmlDecode(lv_description)),lv_persid,AddSlashes(lv_AdrLine),lv_Country,lv_BIC,lv_dueid,lv_rtrn,lv_EndtoEnd,lv_marf) 
							lv_Amount:=0.00
							lv_reference:=""
							lv_NameContra:=""
							lv_BankAcntContra:="" 
							lv_AdrLine:=""
							lv_Country:='' 
							lv_description:=''
							lv_BIC:='' 
							lv_budget:=''
							lv_dueid:=''
							lv_rtrn:=''
							lv_marf:=''
							lv_persid:=''
							lv_EndtoEnd:=''
						enddo
					endcase 
				next
				if !lDetails
					nSeqnr++
					lv_NameContra:=AddSlashes(AllTrim(SubStr(HtmlDecode(lv_NameContra),1,32)))   //max length 32 in teletrans
					self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(nSeqnr,-1),lv_BankAcntContra,;
						lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,AddSlashes(HtmlDecode(lv_description)),lv_persid,AddSlashes(lv_AdrLine),lv_Country,lv_BIC,lv_dueid,lv_rtrn,lv_EndtoEnd,lv_marf)
				endif
			enddo
			
		endif
	enddo
	oBkToCstmrStmt:=null_object // clear
	oXMLParser:=null_object
	oStmt:=null_object
	oNtry:=null_object 
	oSub:=null_object   // clear
	aBudg:=null_array // clear  
	// 	time1:=time0
	// 	LogEvent(self,"interprete:"+Str((time0:=Seconds())-time1,-1),"logsql")
	//    LogEvent(self,"all transactions loaded","logsql")

	// store read data into database:
	lResult:= self:SaveTeleTrans(true,true,"CAMT.053 file "+oFm:FileName+'.'+oFm:Extension,nTrans)
	// 	time1:=time0
	// 	LogEvent(self,"save:"+Str((time0:=Seconds())-time1,-1),"logsql")
	return lResult
	
METHOD ImportGiro(oFs as MyFileSpec) as logic CLASS TeleMut
	* Import of postgiro data into teletrans.dbf
	LOCAL oHlG as HulpGiro
	LOCAL m57_laatste := {} as ARRAY
	LOCAL i as int
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()),nImp,nTrans,nProc as int
	LOCAL lv_loaded as LOGIC,  hlpbank as USUAL, lv_Amount as FLOAT
	LOCAL lv_addsub,lv_addsub,cCurrency,lv_description, lv_NameContra,lv_bankAcntOwn,lv_BankAcntContra,lv_cod_mut,lv_persid as STRING
	LOCAL cSep as STRING
	LOCAL lSuccess:=true as LOGIC
	LOCAL oHlp as FileSpec 
	LOCAL ld_bookingdate as date
	local oStmnt as SQLStatement


	cSep:=CHR(SetDecimalSep())
	//oHlG := Hulpgiro{,DBEXCLUSIVE}
	oHlG :=Hulpgiro{HelpDir+"\HGiro"+StrTran(StrTran(Time(),":"),' ','')+".DBF",DBEXCLUSIVE}
	* Clear HulpGiro
	oHlG:Zap()
	// lSuccess:=oFs:FileLock()       
	lSuccess:=oHlG:AppendSDF(oFs)
	if lSuccess	 
		SaveUse("ImportGiro")
		oHlG:Gotop()
		DO WHILE .not.oHlG:EOF
			lv_bankAcntOwn:=Str(Val(oHlG:HL_GIRONUM),-1) 
			if Empty(lv_bankAcntOwn)
				oHlG:Skip()
				loop
			ENDIF
			nTrans++	
			ld_bookingdate:=SToD(oHlG:hl_boekdat)
			lv_bankAcntOwn:=ZeroTrim(lv_bankAcntOwn) 
			if sepaenabled .and. Len(lv_bankAcntOwn)<=7
				// convert to sepa: 
				lv_bankAcntOwn:=  "INGB000"+PadL(lv_bankAcntOwn,7,"0")
				lv_bankAcntOwn:= 'NL'+StrZero(IbanChecksum("NL00"+lv_bankAcntOwn),2,0)+lv_bankAcntOwn	   	
			endif
			IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
				oHlG:Skip()
				loop
			ENDIF
			lv_bankAcntOwn:= self:m57_BankAcc[self:CurTelePtr,1]  // translate to sepa if sepaenabaled 
			cCurrency := SubStr(oHlG:hl_oms,1,3)
			IF cCurrency == "NLG" .or. cCurrency == "EUR"
				lv_cod_mut := SubStr(oHlG:hl_oms,5,1)
				lv_addsub := SubStr(oHlG:hl_oms,4,1)
				lv_description := SubStr(oHlG:hl_oms,6)
			ELSE
				lv_cod_mut := SubStr(oHlG:hl_oms,2,1)
				lv_addsub := SubStr(oHlG:hl_oms,1,1)
				lv_description := SubStr(oHlG:hl_oms,3)
			ENDIF		
			IF lv_cod_mut # "M".or.Empty(oHlG:hl_mutsoor)  && alleen mutaties laden
				oHlG:Skip()
				loop
			ENDIF
			IF lv_addsub # "A".and.lv_addsub # "B"    && alleen Af/BIJ-mutaties laden
				oHlG:Skip()
				loop
			ENDIF
			IF lv_addsub=="A"    && geen mededelingen laden
				IF "OPDRACHT NIET VERWERKT" $ lv_description
					oHlG:Skip()
					loop
				ENDIF
			ENDIF
			IF Empty(Val(oHlG:HL_BEDRAG))  && geen lege mutaties laden
				oHlG:Skip()
				loop
			ENDIF
			lv_BankAcntContra:=Str(Val(oHlG:HL_TEGENGI),-1)
			lv_description := AllTrim(Compress(SubStr(lv_description,1,32)+' ';
				+SubStr(lv_description,33,32)+' '+SubStr(lv_description,65,32)+' '+SubStr(lv_description,97)))
			if Len(lv_description)>2
				IF SubStr(lv_description,Len(lv_description)-3)="EUR"
					lv_description:=SubStr(lv_description,1,Len(lv_description)-3)
				endif
			endif
			lv_NameContra:=AllTrim(Compress(oHlG:HL_TEG_NAA))
			lv_Amount:=Round(Val(SubStr(oHlG:HL_BEDRAG,1,10)+cSep+SubStr(oHlG:HL_BEDRAG,11)),2)
			* Nagaan of banknumber in begin omschrijving opgenomen:
			hlpbank:=SubStr(oHlG:hl_teg_naa,1,10)
			IF isnum(hlpbank)
				hlpbank:=Val(hlpbank)
				IF hlpbank<=999999
					hlpbank:=0
				ENDIF
			ELSE
				hlpbank:=0
			ENDIF
			IF hlpbank>0  && Zoja, dat als tegennummer opnemen:
				lv_BankAcntContra := Str(Val(SubStr(lv_NameContra,1,10)),-1)
				lv_NameContra := AllTrim(Compress(SubStr(lv_NameContra,11)))
			ENDIF
			lv_description:=AddSlashes(AllTrim(lv_description))
			lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))
			lv_BankAcntContra:=ZeroTrim(lv_BankAcntContra)
			self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(Val(AllTrim(oHlG:hl_volgnum)),-1),lv_BankAcntContra,;
				oHlG:hl_mutsoor,lv_NameContra,AllTrim(oHlG:hl_budget),lv_Amount,lv_addsub,lv_description,lv_persid)
			lv_description:=""
			oHlG:Skip()
		ENDDO
		oHlp:=FileSpec{oHlG:FileSpec:FullPath}
		oHlG:Close()
		oHlG:=null_object
		oHlp:DELETE()
		lSuccess:=self:SaveTeleTrans(true,true,"ING file:"+oFs:FileName,nTrans)
		if lSuccess
			return true
		else
			return false                                              
		endif

	ENDIF
	RETURN true
METHOD ImportHU(oFb as MyFileSpec) as logic CLASS TeleMut
	* Import of K&H bank in to teletrans
	LOCAL i as int
	LOCAL lv_description, lv_bankAcntOwn,lv_addsub,lv_BankAcntContra,lv_persid,lv_kind,lv_NameContra,lv_budget,lv_transid as STRING
	LOCAL lSuccess:=true as LOGIC
	LOCAL cDelim:=CHR(9) as STRING
	LOCAL ptrHandle as MyFile
	LOCAL cBuffer as STRING, nRead as int
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate, ptDebCre, ptDesc, ptType,ptOwnBank,ptContrAcc,ptContrName,ptTransid,  nVnr,nCnt,nTot,nProc as int
	LOCAL pbType as STRING
	LOCAL lv_Amount, Hl_balan as FLOAT
	LOCAL ld_bookingdate as date
	local oStmnt as SQLStatement 

	ptrHandle:=MyFile{oFb,1}
	pbType:=Upper(oFb:Extension) 
	if Empty(ptrHandle)
		return false
	endif
	cBuffer:=ptrHandle:FReadLine()   // read first line with column headers
	cBuffer:=StrTran(StrTran(cBuffer,';',''),':','')
	
	if !GetDelimiter(cBuffer,@aStruct,@cDelim,10,21)
		(ErrorBox{,self:oLan:Wget("Wrong fileformat of importfile from K&H Bank")+": "+oFb:FullPath+"("+self:oLan:Wget("See help")+")"}):show()
		ptrHandle:Close()
		RETURN FALSE
	ENDIF
	ptDate:=AScan(aStruct,{|x| "K�NYVEL�S D�TUMA" $ x})
	ptDesc:=AScan(aStruct,{|x| "K�ZLEM�NY" $ x})
	ptDebCre:=AScan(aStruct,{|x| "�SSZEG" $ x}) 
	ptOwnBank:=AScan(aStruct,{|x| "K�NYVEL�SI SZ�MLA" $ x}) 
	ptContrAcc:=AScan(aStruct,{|x| "PARTNER SZ�MLA" $ x}) 
	ptContrName:=AScan(aStruct,{|x| "PARTNER ELNEVEZ�SE" $ x}) 
	ptType:=AScan(aStruct,{|x| "T�PUS" $ x})
	ptTransid:=AScan(aStruct,{|x| "TRANZAKCI� AZONOS�T�" $ x}) 
	
	IF ptDate==0 .or. ptDesc==0 .or. ptDebCre==0 .or.ptOwnBank==0  .or.ptContrAcc==0.or.ptContrName==0.or.ptType==0
		(ErrorBox{,self:oLan:Wget("Wrong fileformat of importfile from K&H Bank")+": "+oFb:FullPath+"("+self:oLan:Wget("See help")+")"}):show()
		RETURN FALSE
	ENDIF
	SaveUse("ImportHU")

	cBuffer:=ptrHandle:FReadLine()   // read first transaction
	cBuffer:=StrTran(cBuffer,'""','"')
	aFields:=Split(cBuffer,cDelim)
	if Empty(AFields[ptDate])
		cBuffer:=ptrHandle:FReadLine()                                       
		cBuffer:=StrTran(cBuffer,'""','"')
		aFields:=Split(cBuffer,cDelim)
	endif

	DO WHILE Len(AFields)>3
		lv_bankAcntOwn := AllTrim(AFields[ptOwnBank]) 
		ld_bookingdate:=SToD(StrTran(SubStr(AFields[ptDate],1,10),'.',''))        //   2016.01.22
		IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			cBuffer:=ptrHandle:FReadLine()
			cBuffer:=StrTran(cBuffer,'""','"')
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_kind:=AllTrim(AFields[ptType])
		lv_description:=Compress(StrTran(AllTrim(AFields[ptDesc]),'"','')) +' ('+lv_kind+')'
		lv_Amount:=Round(Val(StrTran(StrTran(AFields[ptDebCre],'"',''),',','')),DecAantal) 
		if lv_kind == 'K�szp�nz befizet�s' .or. lv_kind == 'Konv. deviza�tut. j�v��r�s b.k�v�l' .or. lv_kind== '�tutal�s j�v��r�s'
			lv_description:= self:oLan:RGet("Gift")+Space(1)+lv_description
		elseif lv_kind == 'Csoportos beszed�s'
		endif
		IF Empty(lv_Amount)  && skip empty transactions
			cBuffer:=ptrHandle:FReadLine()
			cBuffer:=StrTran(cBuffer,'""','"')
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		IF lv_Amount>=0
			lv_addsub:="B"
		ELSE
			lv_addsub:="A" 
			lv_Amount:=-lv_Amount
		ENDIF
		lv_Amount:=Round(lv_Amount,DecAantal)
		lv_BankAcntContra:=AllTrim(AFields[ptContrAcc])
		lv_NameContra:=AllTrim(AFields[ptContrName]) 
		lv_transid:=AllTrim(AFields[ptTransid]) 
		nTot++
		self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,lv_transid,lv_BankAcntContra,;
			lv_kind,AddSlashes(lv_NameContra),lv_budget,lv_Amount,lv_addsub,AddSlashes(lv_description),lv_persid)
		lv_description:=""
		cBuffer:=ptrHandle:FReadLine()
		cBuffer:=StrTran(cBuffer,'""','"')
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	ptrHandle:=null_object 
// 	nCnt:=self:lv_aant_toe
// 	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(true,false,"K&H Bank file:"+oFb:FileName,nTot)
// 	AAdd(self:aMessages,"Imported silvanTrania file:"+oFb:FileName+" "+Str(self:lv_aant_toe -nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		return true
	else
		return false                                              
	endif
METHOD ImportKB(oFb as MyFileSpec) as logic CLASS TeleMut
	* Import of KB Bank data into teletrans.dbf
	LOCAL oHlS as HulpSA
	LOCAL m57_laatste := {} as ARRAY
	LOCAL i, TelPtr as int
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()) as int
	LOCAL lv_loaded as LOGIC,  hlpbank as USUAL
	LOCAL lv_description, lv_bankAcntOwn,lv_addsub as STRING
	LOCAL cSep as int
	LOCAL lSuccess:=true as LOGIC
	LOCAL cDelim:=';' as STRING
	LOCAL ptrHandle as MyFile
	LOCAL hl_boekdat as STRING
	LOCAL oFs:=oFb as FileSpec
	LOCAL cBuffer as STRING, nCnt,nTot as int
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate, ptPay, ptDesc, ptCur,  nVnr as int
	LOCAL pbType as STRING
	LOCAL lv_Amount, Hl_balan as FLOAT
	LOCAL ld_bookingdate as date
	local oStmnt as SQLStatement

	i:=AtC("KTO",oFs:FileName)+3
	lv_bankAcntOwn:=SubStr(oFs:FileName,i) 
	i:= At("_",lv_bankAcntOwn)-1
	lv_bankAcntOwn:=ZeroTrim(SubStr(lv_bankAcntOwn,1,iif(i>0,i,Len(lv_bankAcntOwn))))
	cSep:=SetDecimalSep(Asc(","))
	ptrHandle:=MyFile{oFs}
	pbType:=Upper(oFs:Extension)
	IF FError() >0
		(ErrorBox{,self:oLan:Wget("Could not open file")+": "+oFs:FullPath+"; "+self:oLan:Wget("Error")+":"+DosErrString(FError())}):show()
		ptrHandle:Close()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine()
	IF Empty(cBuffer)
		(ErrorBox{,self:oLan:Wget("Could not read file")+": "+oFs:FullPath+"; "+self:oLan:Wget("Error")+":"+DosErrString(FError())}):show()
		ptrHandle:Close()
		RETURN FALSE
	ENDIF 
	// skip first comment lines:
	do while Left(cBuffer,1)=='#'
		cBuffer:=ptrHandle:FReadLine()
	enddo	
	if !GetDelimiter(cBuffer,@aStruct,@cDelim,5,6)
		(ErrorBox{,self:oLan:Wget("Wrong fileformat of importfile from KB Bank")+": "+oFs:FullPath+"("+self:oLan:Wget("See help")+")"}):show()
		ptrHandle:Close()
		RETURN FALSE
	ENDIF
	ptDate:=AScan(aStruct,{|x| "BUCHUNGSTAG" $ x})
	ptDesc:=AScan(aStruct,{|x| "TEXT" $ x})
	ptPay:=AScan(aStruct,{|x| "BETRAG" $ x})
	ptCur:=AScan(aStruct,{|x| "W�HRUNG" $ x})
	IF ptDate==0 .or. ptDesc==0 .or. ptPay==0 .or. ptCur==0 
		(ErrorBox{,self:oLan:Wget("Wrong fileformat of importfile from KB Bank")+": "+oFs:FullPath+"("+self:oLan:Wget("See help")+")"}):show()
		RETURN FALSE
	ENDIF
	SaveUse("ImportKB")
	cBuffer:=ptrHandle:FReadLine()   // skip first line
	// skip balance line:
	aFields:=Split(cBuffer,cDelim)
	if Empty(AFields[ptDate])
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim)
	endif

	DO WHILE Len(AFields)>4
		hl_boekdat:=AFields[ptDate]
		ld_bookingdate:=SToD(SubStr(hl_boekdat,7,4)+SubStr(hl_boekdat,4,2)+SubStr(hl_boekdat,1,2))
		IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_description:=AllTrim(StrTran(AllTrim(AFields[ptDesc]),'"',''))
		lv_Amount:=AbsFloat(Val(AFields[ptPay]))
		IF Val(AFields[ptPay])>0
			lv_addsub:="B"
		ELSE
			lv_addsub:="A"
		ENDIF
		IF Empty(lv_Amount)  && geen lege mutaties laden
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_Amount:=Round(lv_Amount,DecAantal) 
		lv_description:=AddSlashes(lv_description)
		* controleer op reeds geladen zijn van mutatie:
		nTot++
		IF self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,"KDB","","","")
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		oStmnt:=SQLStatement{"insert into teletrans set	"+;
			"bankaccntnbr='"+lv_bankAcntOwn+"'"+;
			",bookingdate='"+SQLdate(Min(Today(),ld_bookingdate)),;  // no dates in the future)+"'"+;
			",kind='KDB'"+;
			",amount='"+Str(lv_Amount,-1)+"'"+;
			",addsub='"+lv_addsub	+"'"+;
			",code_mut_r='M'"+;
			",description='"+lv_description	+"'",oConn}
		oStmnt:Execute()
		if	oStmnt:NumSuccessfulRows>0
			++lv_aant_toe
			nCnt++
		endif
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	ptrHandle:=null_object
	SetDecimalSep(Asc('.'))  // restore decimal separator 
	AAdd(self:aMessages,"Imported KB file:"+oFb:FileName+" "+Str(nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions")

	return true
METHOD ImportMT940(oFm as MyFileSpec) as logic CLASS TeleMut
	*	Import of one MT940 telebnk transaction file
	LOCAL i, nEndAmnt, nDC, nOffset, nTrans,nImp,nNumPos,nSepPos,nLenLine1,nProc,nBetKnm,nSeqnr as int
	LOCAL lv_bankAcntOwn, lv_description, lv_Oms, lv_addsub, lv_AmountStr, lv_reference, lv_NameContra as STRING
	local lv_BankAcntContra,lv_BIC, cText,lv_budget,lv_budgethlp,lv_kind,lv_persid,lv_bankid,lv_country as STRING 
	local Cur_RekNrOwn, Cur_enRoute as string 
	local lv_AdrLine,cSep as string
	local cType86 as string  //type of tag 86: B=bank,
	local cRefType as string // type of reference: EREF,MARF,PREF, NONREF 
	local cBuffer as string
	LOCAL lv_Amount,lv_balance as FLOAT
	LOCAL lSuccess:=true as LOGIC 
	LOCAL lv_loaded as LOGIC
	local lMTExtended as logic 
	local lMT940 as logic
	local lReverse as logic
	local lStructured as logic 
	// 	local lMTStructured as logic
	LOCAL ld_bookingdate as date
	local oMyFile as MyFile 
	local aBudg:={} as array
	local aWord as array
	local oBank as SQLSelect, oBord as SQLSelect 
	LOCAL oHlp as Filespec
	local oStmnt as SQLStatement

	
	// 	oHlM :=HLPMT940{HelpDir+"\HMT"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE} 
	// 	oHlM:Zap()
	lMTExtended:=(AtC('ME940',oFm:FileName)>0)
	lMT940:=(oFm:Extension=='.940') 

	*Look for 25: record with accountname
	*	Look for next line until line :25:
	*		if 61: amount
	*		if 86: corresponding description with counteraccount
	*			add record to teletrans
	*
	oMyFile:=MyFile{oFm}
	IF FError() >0
		//	(ErrorBox{,"Could not open file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=oMyFile:FReadLine()
	IF Empty(cBuffer)
		oMyFile:Close()
		oMyFile:=null_object 
		(ErrorBox{,"Could not read file: "+oFm:Fullpath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF

	if !lMT940 .and.!SubStr(cBuffer,1,5)==':940:'
		oMyFile:=null_object 
		ErrorBox{,"file "+Transform(oFm:Fullpath,"")+" is not a MT940 (IBAN) file"}:show()
		Return false
	endif
	SaveUse("ImportMT940")
	nTrans:=0
	nImp:=0
	self:aValuesTrans:={}
	DO WHILE !oMyFile:FEof
		* Search 20 or 25 record:
		IF !SubStr(cBuffer,1,4)==":25:" .and. !SubStr(cBuffer,1,4)==":20:"
			cBuffer:=oMyFile:FReadLine()
			loop
		ENDIF
		if SubStr(cBuffer,1,4)==":20:"
			ld_bookingdate:=SToD("20"+SubStr(cBuffer,9,6)) // booking date
			cBuffer:=oMyFile:FReadLine()
			nSeqnr:=0
			loop
		ENDIF
		nSeqnr:=0
		
		lv_bankAcntOwn:=AllTrim(SubStr(cBuffer,5))
		lv_bankAcntOwn:=StrTran(ZeroTrim(StrTran(lv_bankAcntOwn,".","")),"EUR","")
		if	!lv_bankAcntOwn==	Cur_RekNrOwn
			Cur_RekNrOwn:=lv_bankAcntOwn
			Cur_enRoute:=""
			oBank:=SqlSelect{"select b.payahead,a.accnumber from bankaccount b, account a where not b.payahead is null and a.accid=b.payahead and banknumber='"+lv_bankAcntOwn+"'",oConn}
			if oBank:Reccount>0
				Cur_enRoute:=oBank:ACCNUMBER
			endif
		endif
		cBuffer:=oMyFile:FReadLine()
		DO WHILE !oMyFile:FEof
			* Search for :61: (amount,book date), :86: (account, name, description) combinations:
			* Stop if new 25:
			IF SubStr(cBuffer,1,4)==":25:"
				exit
			ENDIF
			// 			IF SubStr(cBuffer,1,3)==":28"  // statement number + sequence number
			// 				lv_reference:=AllTrim(SubStr(cBuffer,At3(':',cBuffer,3)+1))
			// 			ENDIF 

			IF !SubStr(cBuffer,1,4)==":61:"
				cBuffer:=oMyFile:FReadLine()
				loop
			ENDIF
			do while SubStr(cBuffer,1,4)==":61:" 
				// go through lines with amount and description
				lv_budget:=""
				lv_kind:=""
				lv_persid:=""
				lv_bankid:=""
				lv_reference:=""
				if Empty(ld_bookingdate)
					ld_bookingdate:=SToD("20"+SubStr(cBuffer,5,6)) // valuta date   ????
				endif
				lv_description:=""
				
				lv_addsub:= SubStr(cBuffer,11,2) 
				lReverse:=false
				IF lv_addsub='C' .or. lv_addsub=='RC'
					lv_addsub:="B"
				ELSE
					lv_addsub:="A"
				ENDIF
				if lv_addsub='R'
					lReverse:=true
					nDC:=13
				else
					nDC:=12
				endif 
				lv_AmountStr:=StrTran(cBuffer,",",'.',,1)
				nEndAmnt:= At3('.',lv_AmountStr,nDC)+3
				lv_kind:=SubStr(cBuffer,nEndAmnt+1,3)  // transactioncode
				// 				lv_AmountStr:=StrTran(SubStr(cBuffer,12,nEndAmnt-1),",",'.')
				lv_AmountStr:=SubStr(lv_AmountStr,nDC,nEndAmnt-12)
				if lv_kind=='123' ;     // bijschrijving acceptgiro equens
					.or. lv_kind=='583' .or. lv_kind=='055' .or. lv_kind=='401'  // crediteuren betaling equens/rflp
					lv_kind:='CLR'
				elseif lv_kind=='134'   // bijschrijving acceptgiro
					lv_kind:='AC' 
				elseif lv_kind=='100' .or. lv_kind=='103' //ideal bijschrijving 
					lv_kind:='IDEAL' 
				elseif lv_kind=='640' // doorlopende machtiging     (eigen)
					lv_kind:='COL' 
				elseif lv_kind=='104' .or.lv_kind=='106'.or.lv_kind=='107' .or.lv_kind=='108' .or.lv_kind=='110'.or.lv_kind=='111' ; // terugboeking euro-incasso
					.or.lv_kind=='631'.or.lv_kind=='632'.or.lv_kind=='633' ;                     // terugboeking euro-incasso
					.or. lv_kind=='629';      // euro incasso core equens
					.or. lv_kind=='680'.or. lv_kind=='681'     // euro-incasso rflp bijschrijving
					lv_kind:='COL' 
				endif 
				// 				lv_AmountStr:=StrTran(lv_AmountStr,".",DecSeparator)
				lv_Amount:=Round(Val(lv_AmountStr),2)
				lv_NameContra:=""
				lv_BankAcntContra:=""
				cText:=''
				cRefType:=''
				lStructured:=false
				* get reference type or contra bank account number:
				IF Len(cBuffer)>nEndAmnt+3
					cText:=AllTrim(SubStr(cBuffer,nEndAmnt+4,16))
					if cText=="EREF" .or.cText=="MARF" .or. cText=="PREF" .or. cText=="NONREF"
						cRefType:=cText
						if !lMT940
							lStructured:=true
						endif
					else 
						cText:=StrTran(SubStr(cBuffer,nEndAmnt+4,16),"P","")
						IF	isnum(cText)
							lv_BankAcntContra:=ZeroTrim(StrTran(cText,"."))	
							if sepaenabled .and. At('P',SubStr(cBuffer,nEndAmnt+4,16))>0
								// Giro:
								lv_BankAcntContra:=  "INGB"+PadL(lv_BankAcntContra,10,"0")
								lv_BankAcntContra:= 'NL'+StrZero(IbanChecksum("NL00"+lv_BankAcntContra),2,0)+lv_BankAcntContra	   	
							endif		
						else
							if	IsSEPA(cText)
								lv_BankAcntContra:= cText
							else
								//	check	if	pseudo IBAN:
								if	IsAlphabetic(SubStr(cText,3,4)) .and.isnum(SubStr(cText,1,2) )
									if	isnum(SubStr(cText,7))
										if sepaenabled
											lv_BankAcntContra:= 'NL'+cText
										else	   	
											// 											lv_BankAcntContra:=ZeroTrim(SubStr(cText,7))
											lv_BankAcntContra:=SubStr(cText,7)
										endif	
									endif
								endif
							endif
						ENDIF
						* get	contra name:
						IF	Len(cBuffer)>nEndAmnt+19
							lv_NameContra:=ZeroTrim(SubStr(cBuffer,nEndAmnt+19))
						ENDIF
					endif
				ENDIF
				cBuffer:=oMyFile:FReadLine() 
				if !SubStr(cBuffer,1,1)==":"
					// apparently contra bank account:
					cText:=AllTrim(cBuffer)
					IF	isnum(SubStr(cText,2))
						// 						lv_BankAcntContra:=ZeroTrim(StrTran(StrTran(cText,"."),'P',''))     
						lv_BankAcntContra:=StrTran(StrTran(cText,"."),'P','')     
						if sepaenabled .and. At('P',SubStr(cBuffer,1,16))>0
							// Giro:
							lv_BankAcntContra:=  "INGB"+PadL(lv_BankAcntContra,10,"0")
							lv_BankAcntContra:= 'NL'+StrZero(IbanChecksum("NL00"+lv_BankAcntContra),2,0)+lv_BankAcntContra	   	
						endif		
					else
						if	IsSEPA(cText)
							if !sepaenabled .and. Left(cText,2)=='NL'
								lv_BankAcntContra:=ZeroTrim(Right(cText,10))
							else
								lv_BankAcntContra:= cText
							endif
						else
							//	check	if	pseudo IBAN:
							if	IsAlphabetic(SubStr(cText,3,4)) .and.isnum(SubStr(cText,1,2) )
								if	isnum(SubStr(cText,7))
									if sepaenabled
										// convert to sepa:
										lv_BankAcntContra:= 'NL'+cText
									else	   	
										// 										lv_BankAcntContra:=ZeroTrim(SubStr(cText,7))
										lv_BankAcntContra:=SubStr(cText,7)
									endif	
								endif
							endif
						endif
					ENDIF
					if lv_BankAcntContra == "NL94ABNA0476004446"
						lv_BankAcntContra:=lv_BankAcntContra
					endif
					cBuffer:=oMyFile:FReadLine() 
				endif				 
				lv_description:=""
				lv_Oms:=''
				lv_AdrLine:=''
				lv_country:=''
				lv_BIC:='' 
				IF !oMyFile:FEof .and. SubStr(cBuffer,1,4)==":86:"
					* description of transaction:
					if lStructured
						// 						lv_Oms+=AllTrim(SubStr(cBuffer,5,))
						lv_Oms+=SubStr(cBuffer,5,)
					else
						if lMT940
							lv_Oms:=AllTrim(SubStr(cBuffer,5))
						else 
							lv_Oms:=AllTrim(SubStr(cBuffer,5,36)+' '+SubStr(cBuffer,41))
						endif
						IF !lMTExtended
							IF  Empty(lv_BankAcntContra) 
								IF lv_Oms = "GIRO "
									lv_BankAcntContra:= ZeroTrim(SubStr(lv_Oms,8,8))
									if sepaEnabled .and. Val(lv_BankAcntContra)>0 
										lv_BankAcntContra:=  "INGB"+PadL(lv_BankAcntContra,10,"0")
										lv_BankAcntContra:= 'NL'+StrZero(IbanChecksum("NL00"+lv_BankAcntContra),2,0)+lv_BankAcntContra
									endif	   	
									lv_description := AllTrim(SubStr(lv_Oms,16))
								ELSE
									aWord:=GetTokens(lv_Oms)
									cText := aWord[1,1]
									IF isnum(AllTrim(cText))
										lv_BankAcntContra:=ZeroTrim(StrTran(cText,"."))
										IF Val(lv_BankAcntContra)<100000000
											lv_BankAcntContra:=""
										ELSE
											lv_Oms := AllTrim(SubStr(lv_Oms,Len(cText)+1))
										ENDIF
									ELSE
										lv_BankAcntContra:=""
									ENDIF
									IF Empty(lv_BankAcntContra)
										// 									lv_description := lv_Oms
									ENDIF
								ENDIF
							ENDIF
							if Empty(lv_NameContra) .and.lv_addsub=="B" 
								aWord:=GetTokens(lv_Oms,{" ",","})
								lv_NameContra:=aWord[Len(aWord),1] 
							endif 
						endif
						// 					Analyze first line: 
						cType86:=''
						nNumPos:=AtC('-nummer',lv_Oms)
						if AtC('BETREFT ACCEPTGIRO',lv_Oms)>0  .or. AtC('VX-NUMMER',lv_Oms)>0.or. AtC('CREDITEURENBETALING',lv_Oms)>0
							if AtC('VX-NUMMER',lv_Oms)>0
								cType86:='VX'
							else 
								cType86:='CLR'
							endif
							// 							if Empty(Cur_enRoute)
							// 								(ErrorBox{,"for bank account "+ Cur_RekNrOwn+" no 'Account payments en route' specified; import aborted"}):Show()
							// 								return false 
							// 							endif
							// 							lv_budget:=Cur_enRoute
							lv_kind:="CLR"
						elseif nNumPos>2
							cType86:='Bank'
						else
							cType86:="ADRES" 
							nLenLine1:=Len(lv_Oms)
						endif
						if nNumPos=0
							lv_description:=lv_Oms
						endif 
					endif
					if lv_kind=="CLR"
						if Empty(Cur_enRoute)
							(ErrorBox{,"for bank account "+ Cur_RekNrOwn+" no 'Account payments en route' specified; import aborted"}):show()
							return false 
						endif
						lv_budget:=Cur_enRoute
						
					endif
					cBuffer:=oMyFile:FReadLine()
					// compose description:
					DO WHILE !oMyFile:FEof .and. SubStr(cBuffer,1,4)==":86:"  // all :86: with description 
						if lStructured
							lv_Oms+=AllTrim(SubStr(cBuffer,5,))
						else
							if lMT940
								lv_Oms:=AllTrim(SubStr(cBuffer,5))
							else 
								lv_Oms:=AllTrim(SubStr(cBuffer,5,36)+' '+SubStr(cBuffer,41))
							endif
							if !lv_Oms="TRANSACTIEDATUM"             // skip line with "TRANSACTIEDATUM"
								self:GetPaymentPattern(lv_Oms,lv_addsub,@lv_budget,@lv_persid,@lv_bankid,@lv_kind)
								lv_description+=" "+lv_Oms
							endif
						endif
						cBuffer:=oMyFile:FReadLine()
					ENDDO 
					DO WHILE !oMyFile:FEof .and. !(Occurs(":",SubStr(cBuffer,1,6))=2)  // no TAG
						if lStructured
							// 							lv_Oms+=AllTrim(cBuffer)
							lv_Oms+=cBuffer
						else
							lv_Oms:=AllTrim(cBuffer) 
							if !lv_Oms="TRANSACTIEDATUM".and. AtC('-nummer',lv_Oms)=0 ;   // skip line with "TRANSACTIEDATUM" or number
								.and. !(SubStr(lv_Oms,1,2)='BE' .and. IsDigit(SubStr(lv_Oms,3)))  // skip belgi� nummers
								self:GetPaymentPattern(lv_Oms,lv_addsub,@lv_budget,@lv_persid,@lv_bankid,@lv_kind)
								lv_description+=" "+lv_Oms
							endif
						endif
						cBuffer:=oMyFile:FReadLine()
					ENDDO
					if lStructured
						// mt940 structured:
						aWord:=GetTokensEx(lv_Oms,;
							{'/MARF/','/EREF/','/PREF/','/RTRN/','/ACCW/','/BENM/','/ORDP/','/NAME/','/ID/','/ADDR/','/REMI/','/CSID/','/ISDT/','/CDTRREF/',;
							'/CDTRREFTP/','/CD/','/ISSR/'})
						// analyse aWord:
						for i:=1 to Len(aWord)
							cSep:=aWord[i,2]
							do case 
							case cSep=='/MARF/'
							case cSep=='/EREF/'
								lv_reference:=AllTrim(aWord[i,1]) 
							case cSep=='/PREF/'
							case cSep=='/RTRN/'
							case cSep=='/ACCW/'
								if Empty(lv_BankAcntContra)
									lv_BankAcntContra:=AllTrim(aWord[i,1]) 
									if At(',',lv_BankAcntContra)>0
										lv_BIC:=Split(lv_BankAcntContra,',')[2]
										lv_BankAcntContra:=Split(lv_BankAcntContra,',')[1]
									endif
								elseif At(',',AllTrim(aWord[i,1]))>0
									lv_BIC:=Split(AllTrim(aWord[i,1]),',')[2]
								endif							
							case cSep=='/BENM/' .or.cSep=='/ORDP/' 
							case cSep=='/NAME/'
								lv_NameContra:=AllTrim(aWord[i,1])
							case cSep=='/ID/'
							case cSep=='/ADDR/'
								lv_AdrLine+=AllTrim(aWord[i,1])
							case cSep=='/REMI/'
								if nBetKnm=0
									// 									lv_description+=AllTrim(aWord[i,1])
									lv_description+=aWord[i,1]
								endif
							case cSep=='/CSID/'
							case cSep=='/ISDT/'
							case cSep=='/CDTRREF/'
								lv_budgethlp:=''
								self:GetPaymentPattern(AllTrim(aWord[i,1]),lv_addsub,@lv_budgethlp,@lv_persid,@lv_bankid,@lv_kind)
								if !Empty(lv_budgethlp)
									lv_budget:=lv_budgethlp
									lv_reference:=''  // entoendid
								endif
								lv_description+=' '+AllTrim(aWord[i,1])
							case cSep=='/CDTRREFTP/'
							case cSep=='/CD/'
							case cSep=='/ISSR/'
							endcase
						next
					endif
					if cType86=="VX"
						if (nNumPos:=AtC("BETALINGSKENM",lv_description))>0
							if !isnum(AllTrim(SubStr(lv_description,nNumPos+16,16)) )
								lv_budget:=''   // no really Cur-en-route
							endif
						endif
					endif 
					
					// check on special messages: 
					nSepPos:=0
					if cType86='Bank'
						if Empty(lv_kind)
							nSepPos:=AtC('EUROBETALING SHA',lv_description)
							if nSepPos>0
								nSepPos+=Len('EUROBETALING SHA')-1
								lv_BankAcntContra:=""   // ignore account in case of payment from other country in Euro 
							else
								if AtC('TOTAAL INCASSO',lv_description)>0 .or. AtC('DOORLOPENDE MACHTIGING ALGEMEEN',lv_description)>0
									lv_budget:=Cur_enRoute 
									lv_kind:="COL"
								endif
							endif
						endif
					elseif !cType86=='CLR'
						// address:
						nSepPos:=nLenLine1 // at end of first line with address
					endif
					if AtC('NAAM/NUMMER STEMMEN NIET OVEREEN',lv_description)>0 
						nSepPos:=0 
						//	look for	bankorder:
						oBord:=SqlSelect{"select a.accnumber from	bankorder o, account	a where banknbrcre="+lv_BankAcntContra+;
							" and	datepayed>'"+SQLdate(ld_bookingdate-10)+"'"+' and a.accid=o.accntfrom',	oConn} 
						if	oBord:Reccount>0	 
							lv_budget:=AllTrim(oBord:ACCNUMBER)
						else
							lv_budget:=""
						endif
					endif
					if nSepPos>0 .and.lMTExtended.and.lv_addsub=='B' .and.AtC('AFROMEN',lv_description)=0
						lv_description:=AllTrim(SubStr(lv_description,1,nSepPos))+'%%'+SubStr(lv_description,nSepPos+1,)
					endif
					lv_description:=Compress(lv_description)+' '+lv_reference
				ENDIF 
				if Empty(lv_budget)
					// Look for budget code between * or [] or ()
					if (nOffset:=At('*',lv_description))>0
						if At3('*',lv_description,nOffset+1)>0  //2e * 
							aBudg:=Split(SubStr(lv_description,nOffset+1),'*')
							if	Len(aBudg)>0 .and. isnum(aBudg[1])
								lv_budget:=aBudg[1]
							endif
						endif
					endif
					if Empty(lv_budget) .and. (nOffset:=At('[',lv_description))>0
						aBudg:=Split(SubStr(lv_description,nOffset+1),']') 
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
						endif					
					endif
					if Empty(lv_budget) .and. (nOffset:=At('(',lv_description))>0
						aBudg:=Split(SubStr(lv_description,nOffset+1),')') 
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
						endif
					endif
				else
				endif
				lv_description:=AddSlashes(AllTrim(lv_description))
				lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))   //max length 32 in teletrans
				* save transaction:
				nTrans++ 
				if IsAlpha(lv_BankAcntContra)
					lv_country:=SubStr(lv_BankAcntContra,1,2)
					if Empty(lv_BIC)
						lv_BIC:=GetBIC(lv_BankAcntContra)
					endif
				endif
				
				// 				self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(Val(lv_reference),-1),lv_BankAcntContra,;
				nSeqnr++
				self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(nSeqnr,-1),lv_BankAcntContra,;
					lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid,AddSlashes(lv_AdrLine),lv_country,lv_BIC)
				lv_Oms:=""
			enddo     // end 61 /86 combinations 

			IF SubStr(cBuffer,1,5)==":62F:"
				// balance new:
				lv_balance:=Val(iif(SubStr(cBuffer,6)='C','','-')+SubStr(cBuffer,16,15))
				ld_bookingdate:=SToD("20"+SubStr(cBuffer,7,6)) // valuta date
				AAdd(self:avaluesBal,{lv_bankAcntOwn,ld_bookingdate,lv_balance})
			endif
			// 
			exit
		ENDDO       // end :25 transaction
	ENDDO
	oMyFile:Close()
	oMyFile:=null_object 
	// store read data into database:
	lSuccess:=self:SaveTeleTrans(true,true,"MT940 file "+oFm:FileName+'.'+oFm:Extension,nTrans)
	if lSuccess
		return true
	else
		return false
	endif
METHOD ImportMT940IBANING(oFm as MyFileSpec) as logic CLASS TeleMut
	*	Import of one Mijn ING Zakelijk MT940 telebnk transaction file
	LOCAL i,j,iSt, nEndAmnt, nOffset, nTrans,nImp,nNumPos,nSepPos,nLenLine1,nProc,nBetKnm,nSeqnr as int
	LOCAL lv_Amount,lv_balance as FLOAT
	LOCAL lv_bankAcntOwn, lv_description, lv_Oms, lv_addsub, lv_AmountStr, lv_reference, lv_NameContra as STRING
	local lv_BankAcntContra,lv_BIC, cText,lv_budget,lv_budgethlp,lv_kind,lv_persid,lv_bankid,lv_country as STRING
	local lv_rtrn,lv_eref,lv_marf,cKey,lv_kindorg as string 
	local Cur_RekNrOwn, Cur_enRoute as string
	local Cur_bank as string // name of bank: INGB or RABO 
	local lv_AdrLine,cSep as string
	local cBuffer as string
	local lv_dueid as string
	LOCAL lSuccess:=true as LOGIC 
	LOCAL lv_loaded as LOGIC
	local lMTExtended as logic 
	local lMT940 as logic
	local lStructured as logic 
	// 	local lMTStructured as logic
	LOCAL ld_bookingdate as date
	local oMyFile as MyFile 
	local aBudg:={} as array
	local aWord:={} as array 
	local aCntp:={} as array
	local aRemi:={} as array
	local aMarf:={} as array 
	local aEref:={} as array
	local aKey:={'/RTRN/','/EREF/','/PREF/','/MARF/','/CSID/','/CNTP/','/REMI/','/PURP/','/ULTC/','/ULTD/'} as array
	local oBank as SQLSelect, oBord as SQLSelect 
	LOCAL oHlp as FileSpec
	local oStmnt as SQLStatement

	

	*Look for 25: record with accountname
	*	Look for next line until line :25:
	*		if 61: amount
	*		if 86: corresponding description with counteraccount
	*			add record to teletrans
	*
	oMyFile:=MyFile{oFm}
	IF FError() >0
		//	(ErrorBox{,"Could not open file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=oMyFile:FReadLine()
	IF Empty(cBuffer)
		oMyFile:Close()
		oMyFile:=null_object 
		(ErrorBox{,"Could not read file: "+oFm:Fullpath+"; Error:"+DosErrString(FError())}):Show()
		RETURN FALSE
	ENDIF
	SaveUse("ImportMT940IBANING")
	if !Substr(cBuffer,1,3)=='{1:' .and.!Substr(cBuffer,1,3)=='{2:'
		oMyFile:Close()
		oMyFile:=null_object 
// 		ErrorBox{,"file "+Transform(oFm:Fullpath,"")+" is not a Mijn ING Zakelijk MT940 IBAN file"}:Show()
		Return false
	endif
	nTrans:=0
	nImp:=0
	self:aValuesTrans:={}
	DO WHILE !oMyFile:FEof
		* Search 25 record:
		IF !SubStr(cBuffer,1,4)==":25:" 
			cBuffer:=oMyFile:FReadLine()
			loop
		ENDIF
		nSeqnr:=0
		
		lv_bankAcntOwn:=StrTran(AllTrim(SubStr(cBuffer,5)),'EUR','')
		if !IsIban(lv_bankAcntOwn)
			lv_bankAcntOwn:=ZeroTrim(lv_bankAcntOwn)			
			if sepaenabled 
				lv_bankAcntOwn:= "INGB"+PadL(lv_bankAcntOwn,10,'0')
				lv_bankAcntOwn:= 'NL'+StrZero(IbanChecksum("NL00"+lv_bankAcntOwn),2,0)+lv_bankAcntOwn
			endif
		endif		
		if	!lv_bankAcntOwn==	Cur_RekNrOwn
			Cur_RekNrOwn:=lv_bankAcntOwn
			Cur_enRoute:=""
			oBank:=SqlSelect{"select b.payahead,a.accnumber from bankaccount b, account a where not b.payahead is null and a.accid=b.payahead and banknumber='"+lv_bankAcntOwn+"'",oConn}
			if oBank:Reccount>0
				Cur_enRoute:=oBank:ACCNUMBER
			endif
			Cur_bank:=Upper(SubStr(Cur_RekNrOwn,5,4))
		endif
		cBuffer:=oMyFile:FReadLine()
		DO WHILE !oMyFile:FEof
			* Search for :61: (amount,book date), :86: (account, name, description) combinations:
			* Stop if new 25:
			IF SubStr(cBuffer,1,4)==":25:"
				exit
			ENDIF

			IF !SubStr(cBuffer,1,4)==":61:"
				cBuffer:=oMyFile:FReadLine()
				loop
			ENDIF
			do while SubStr(cBuffer,1,4)==":61:" 
				// go through lines with amount and description
				lv_budget:=""
				lv_kind:=""
				lv_kindorg:=""
				lv_persid:=""
				lv_bankid:=""
				lv_reference:=""
				lv_rtrn:=""
				lv_eref:=""
				lv_marf:=""
				lv_AdrLine:=''
				lv_country:=''
				lv_BIC:=''
				lv_dueid:=''
				lv_description:=""
				lv_Oms:=''
				cText:=''
				ld_bookingdate:=SToD("20"+SubStr(cBuffer,5,6))   // valuta date
				
				lv_addsub:= SubStr(cBuffer,15,1) 
				IF lv_addsub='C' 
					lv_addsub:="B"
				ELSE
					lv_addsub:="A"
				ENDIF
				nEndAmnt:= At3(',',cBuffer,16)+3
				lv_AmountStr:=StrTran(SubStr(cBuffer,16,nEndAmnt-16),",",'.',,1)
				//				lv_kind:=AllTrim(SubStr(cBuffer,nEndAmnt+1,3))  // Swift transactioncode
				lv_Amount:=Round(Val(lv_AmountStr),2)
				lv_NameContra:=""
				lv_BankAcntContra:=""
				* get reference type or payment pattern:
				IF Len(cBuffer)>nEndAmnt+3 .and. !SubStr(cBuffer,nEndAmnt+4,6)=="NONREF" 
					cText:=  SubStr(cBuffer,nEndAmnt+4,16)
					IF	isnum(cText)
						lv_reference:=' '+cText 
						// payment pattern:
						self:GetPaymentPattern(cText,lv_addsub,@lv_budget,@lv_persid,@lv_bankid,@lv_kind)
					ENDIF
				endif
				cBuffer:=oMyFile:FReadLine()
				if SubStr(cBuffer,1,6)=='/TRCD/'
					// subpart 9 with ING transaction code:
					lv_kindorg:=AllTrim(SubStr(cBuffer,7,5)) 
					cBuffer:=oMyFile:FReadLine()     // read next line
				endif  
				IF !oMyFile:FEof .and. SubStr(cBuffer,1,4)==":86:"
					* description of transaction:
					lv_Oms:=AllTrim(SubStr(cBuffer,5))
					cBuffer:=oMyFile:FReadLine()
					DO WHILE !oMyFile:FEof .and. !(Occurs(":",SubStr(cBuffer,1,5))=2)  // no TAG
						lv_Oms+=cBuffer 
						cBuffer:=oMyFile:FReadLine()
					ENDDO
					aWord:=GetTokensEx(lv_Oms,aKey,6)
					//lv_description:=lv_Oms
					for i:=1 to Len(aWord)
						cKey:=aWord[i,2]
						do case
						case cKey=='/RTRN/'
							// Return reason
							lv_rtrn:=StrTran(aWord[i,1],'/','')
						case cKey=='/PREF/'
							// Payment Information ID / Batch ID
							if Left(lv_kindorg,2)=='01'   // sepa direct debit  or reject
// 								lv_budget:=Cur_enRoute  //???
// 								lv_kind:='COL'  // ????
							endif
						case cKey=='/EREF/'
							// End to End Reference 
							lv_eref:=StrTran(aWord[i,1],'/','')
							if Left(lv_kindorg,2)=='01'
								// sepa DD 
								aEref:= Split(lv_eref,'-')
								if Len(aEref)>=3 .and. isnum(aEref[1])
									lv_persid:=aEref[1]
									lv_dueid:=aEref[3] 
								endif
							endif
						case cKey=='/MARF/' 
							//  Mandate Reference (Machtigingskenmerk):
							lv_marf:=StrTran(aWord[i,1],'/','')
							if Left(lv_kindorg,2)=='01'
								// sepa DD
								aMarf:= Split(lv_marf,'-')
								if Len(aMarf)>=5 .and. aMarf[2]=='A'
									lv_budget:=aMarf[3]
								endif
							endif
						case cKey=='/CSID/' 
							//  Creditor ID (Incassant ID):  ignored
						case cKey=='/CNTP/' 
							//  Counterparty ID Tegenpartij ID: <AccountNumber (35x))>/ BIC (11x)/<Name (50x)>/<City (35x)>/
							aCntp:=Split(aWord[i,1],'/',false,true)
							for j:=1 to Len(aCntp)
								do case
								case j=1
									lv_BankAcntContra:=aCntp[j]
									if !IsIban(lv_BankAcntContra)
										lv_BankAcntContra:=  "INGB"+PadL(lv_BankAcntContra,10,'0')
										lv_BankAcntContra:= 'NL'+StrZero(IbanChecksum("NL00"+lv_BankAcntContra),2,0)+lv_BankAcntContra
									endif
								case j=2
									lv_BIC:=aCntp[j]
								case j=3
									lv_NameContra:=aCntp[j]
								case j=4
									lv_AdrLine:=aCntp[j]
								endcase
							next
						case cKey=='/REMI/'
							// Remittance Information 
							aRemi:=Split(aWord[i,1],'/',false,true) 
							if Len(aRemi)>=3
								if aRemi[1]=='USTD'
									lv_description+=' '+AllTrim(aRemi[3])
								elseif aRemi[1]=='STRD'
									lv_reference+=' '+SubStr(aWord[i,1],10)
									if aRemi[2]=='STRD/CUR/' 
										// Payment pattern
										self:GetPaymentPattern(SubStr(aRemi[3]),lv_addsub,@lv_budget,@lv_persid,@lv_bankid,@lv_kind)
									endif
								endif
							endif
						endcase
					next
				ENDIF 
				// Translate ing transaction code to general code: 
				if Cur_bank="INGB"
					if lv_kindorg=='00108'
						lv_kind='AC'  // IBAN acceptgiro
					elseif lv_kindorg=='00360' ; //acc equens
						 .or. lv_kindorg=='00400' ; // crediteuren betaling equens 
						lv_kind:='CLR'
					elseif lv_kindorg=='00106' .or.lv_kindorg=='00206' .or. lv_kindorg=='00305'  // ideal bijschrijving
						lv_kind:='IDEAL' 
					elseif lv_kindorg=='00300' .or.lv_kindorg=='00370' 
						lv_kind:='OV'
					elseif Left(lv_kindorg,2)=='01'
						lv_kind:='COL'+iif(Left(lv_kindorg,3)=='011','REJ',"") 
					elseif lv_kindorg=='00100' .or.lv_kindorg=='00112' 
						lv_kind:='GT'
					elseif lv_kindorg=='05000'
						lv_kind:='FL'
					elseif Left(lv_kindorg,2)=='09'
						lv_kind:='DV'
					elseif Empty(lv_kind)
						lv_kind:=lv_kindorg
					endif
				elseif  Cur_bank="RABO"
					lv_kindorg:=lv_kind
					if lv_kind=='123' ;     // bijschrijving acceptgiro equens
						.or. lv_kind=='583' .or. lv_kind=='055' .or. lv_kind=='401'  // crediteuren betaling equens/rflp
						lv_kind:='CLR'
					elseif lv_kind=='134'   // bijschrijving acceptgiro
						lv_kind:='AC' 
					elseif lv_kind=='100' .or. lv_kind=='103' //ideal bijschrijving 
						lv_kind:='IDEAL' 
					elseif lv_kind=='640' // doorlopende machtiging     (eigen)
						lv_kind:='COL' 
					elseif lv_kind=='104' .or.lv_kind=='106'.or.lv_kind=='107' .or.lv_kind=='108' .or.lv_kind=='110'.or.lv_kind=='111' ; // terugboeking euro-incasso
						.or.lv_kind=='631'.or.lv_kind=='632'.or.lv_kind=='633'.or.lv_kind=='166' ;                     // terugboeking euro-incasso
						.or. lv_kind=='629';      // euro incasso core equens
						.or. lv_kind=='680'.or. lv_kind=='681'     // euro-incasso rflp bijschrijving
						lv_kind:='COL'+iif(lv_kindorg='166',"REJ",'')  
					elseif Empty(lv_kind)
						lv_kind:=lv_kindorg
					endif 					
				endif
				if Empty(lv_budget) .and.(lv_kind=='CLR' .or. (SubStr(lv_kind,1,3)=='COL' .and.lv_addsub='B')) 
					if Empty(Cur_enRoute)
						(ErrorBox{,"for bank account "+ Cur_RekNrOwn+" no 'Account payments en route' specified; import aborted2"}):Show()
						return false 
					endif
					lv_budget:=Cur_enRoute
				endif
				if Empty(lv_budget)
					// Look for budget code between * or [] or ()
					if (nOffset:=At('*',lv_description))>0
						if At3('*',lv_description,nOffset+1)>0  //2e * 
							aBudg:=Split(SubStr(lv_description,nOffset+1),'*')
							if	Len(aBudg)>0 .and. isnum(aBudg[1])
								lv_budget:=aBudg[1]
							endif
						endif
					endif
					if Empty(lv_budget) .and. (nOffset:=At('[',lv_description))>0
						aBudg:=Split(SubStr(lv_description,nOffset+1),']') 
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
						endif					
					endif
					if Empty(lv_budget) .and. (nOffset:=At('(',lv_description))>0
						aBudg:=Split(SubStr(lv_description,nOffset+1),')') 
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
						endif
					endif
				endif
				lv_description+=iif(Empty(lv_reference),'',' '+lv_reference)+iif(Empty(lv_rtrn),'',' '+lv_rtrn)+;
					iif(Empty(lv_eref),'',' EndToEnd:'+lv_eref)+iif(Empty(lv_marf),'',' Mandate:'+lv_marf)
				lv_description:=AddSlashes(Compress(lv_description))
				lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))   //max length 32 in teletrans
				* save transaction:
				nTrans++ 
				if IsAlpha(lv_BankAcntContra)
					lv_country:=SubStr(lv_BankAcntContra,1,2)
					if Empty(lv_BIC)
						lv_BIC:=GetBIC(lv_BankAcntContra)
					endif
				endif
				
				// 				self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(Val(lv_reference),-1),lv_BankAcntContra,;
				nSeqnr++ 
				self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(nSeqnr,-1),lv_BankAcntContra,;
					lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid,AddSlashes(lv_AdrLine),lv_country,lv_BIC,lv_dueid,lv_rtrn,lv_eref,lv_marf)
			enddo     // end 61 /86 combinations 

			IF SubStr(cBuffer,1,5)==":62F:"
				// balance new:
				lv_balance:=Val(iif(SubStr(cBuffer,6)='C','','-')+SubStr(cBuffer,16,15))
				ld_bookingdate:=SToD("20"+SubStr(cBuffer,7,6)) // valuta date
				AAdd(self:avaluesBal,{lv_bankAcntOwn,ld_bookingdate,lv_balance}) 
				cBuffer:=oMyFile:FReadLine()
			endif
			// 
			exit
		ENDDO       // end :25 transaction
	ENDDO
	oMyFile:Close()
	oMyFile:=null_object 
	// store read data into database:
	lSuccess:=self:SaveTeleTrans(true,true,"MT940 IBAN file "+oFm:FileName+'.'+oFm:Extension,nTrans)
	if lSuccess
		return true
	else
		return false
	endif
METHOD ImportMT940ING(oFm as MyFileSpec) as logic CLASS TeleMut
	*	Import of one Mijn ING Zakelijk MT940 telebnk transaction file
	LOCAL i,iSt, nEndAmnt, nOffset, nTrans,nImp,nNumPos,nSepPos,nLenLine1,nProc,nBetKnm,nSeqnr as int
	LOCAL lv_bankAcntOwn, lv_description, lv_Oms, lv_addsub, lv_AmountStr, lv_reference, lv_NameContra as STRING
	local lv_BankAcntContra,lv_BIC, cText,lv_budget,lv_budgethlp,lv_kind,lv_persid,lv_bankid,lv_country as STRING 
	local Cur_RekNrOwn, Cur_enRoute as string 
	local lv_AdrLine,cSep as string
	local cType86 as string  //type of tag 86: B=bank,
	local cRefType as string // type of reference: EREF,MARF,PREF, NONREF 
	local cBuffer as string
	local lv_EndtoEnd,lv_dueid as string
	LOCAL lv_Amount,lv_balance as FLOAT
	LOCAL lSuccess:=true as LOGIC 
	LOCAL lv_loaded as LOGIC
	local lMTExtended as logic 
	local lMT940 as logic
	local lStructured as logic 
	// 	local lMTStructured as logic
	LOCAL ld_bookingdate as date
	local oMyFile as MyFile 
	local aBudg:={} as array
	local aWord as array
	local oBank as SQLSelect, oBord as SQLSelect 
	LOCAL oHlp as Filespec
	local oStmnt as SQLStatement

	

	*Look for 25: record with accountname
	*	Look for next line until line :25:
	*		if 61: amount
	*		if 86: corresponding description with counteraccount
	*			add record to teletrans
	*
	oMyFile:=MyFile{oFm}
	IF FError() >0
		//	(ErrorBox{,"Could not open file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=oMyFile:FReadLine()
	IF Empty(cBuffer)
		oMyFile:Close()
		oMyFile:=null_object 
		(ErrorBox{,"Could not read file: "+oFm:Fullpath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	SaveUse("ImportMT940ING")

	nTrans:=0
	nImp:=0
	self:aValuesTrans:={}
	DO WHILE !oMyFile:FEof
		* Search 25 and 20 record:
		IF !SubStr(cBuffer,1,4)==":25:" .and.!SubStr(cBuffer,1,4)==":20:" 
			cBuffer:=oMyFile:FReadLine()
			loop
		ENDIF
		if SubStr(cBuffer,1,4)==":20:"
			if !SubStr(cBuffer,5,4)=='MPBZ'
				oMyFile:=null_object 
				ErrorBox{,"file "+Transform(oFm:Fullpath,"")+" is not a Mijn ING Zakelijk MT940 file"}:show()
				Return false
			endif
			cBuffer:=oMyFile:FReadLine()
			nSeqnr:=0
			loop
		endif
		nSeqnr:=0
		
		lv_bankAcntOwn:=AllTrim(SubStr(cBuffer,5))
		lv_bankAcntOwn:=ZeroTrim(lv_bankAcntOwn)			
		if sepaenabled 
			lv_bankAcntOwn:=  "INGB"+PadL(lv_bankAcntOwn,10,'0')
			lv_bankAcntOwn:= 'NL'+StrZero(IbanChecksum("NL00"+lv_bankAcntOwn),2,0)+lv_bankAcntOwn
		else
		endif		
		if	!lv_bankAcntOwn==	Cur_RekNrOwn
			Cur_RekNrOwn:=lv_bankAcntOwn
			Cur_enRoute:=""
			oBank:=SqlSelect{"select b.payahead,a.accnumber from bankaccount b, account a where not b.payahead is null and a.accid=b.payahead and banknumber='"+lv_bankAcntOwn+"'",oConn}
			if oBank:Reccount>0
				Cur_enRoute:=oBank:ACCNUMBER
			endif
		endif
		cBuffer:=oMyFile:FReadLine()
		DO WHILE !oMyFile:FEof
			* Search for :61: (amount,book date), :86: (account, name, description) combinations:
			* Stop if new 25:
			IF SubStr(cBuffer,1,4)==":25:"
				exit
			ENDIF

			IF !SubStr(cBuffer,1,4)==":61:"
				cBuffer:=oMyFile:FReadLine()
				loop
			ENDIF
			do while SubStr(cBuffer,1,4)==":61:" 
				// go through lines with amount and description
				lv_budget:=""
				lv_kind:=""
				lv_persid:=""
				lv_bankid:=""
				lv_reference:=""
				ld_bookingdate:=SToD("20"+SubStr(cBuffer,5,6))   // valuta date
				
				lv_addsub:= SubStr(cBuffer,11,1) 
				IF lv_addsub='C' 
					lv_addsub:="B"
				ELSE
					lv_addsub:="A"
				ENDIF
				nEndAmnt:= At3(',',cBuffer,12)+3
				lv_AmountStr:=StrTran(SubStr(cBuffer,12,nEndAmnt-12),",",'.',,1)
				lv_kind:=AllTrim(SubStr(cBuffer,nEndAmnt+1,3))  // transactioncode
				lv_Amount:=Round(Val(lv_AmountStr),2)
				lv_NameContra:=""
				lv_BankAcntContra:=""
				cText:=''
				cRefType:=''
				lStructured:=false
				* get reference type or contra bank account number:
				IF Len(cBuffer)>nEndAmnt+3
					cText:=AllTrim(SubStr(cBuffer,nEndAmnt+4,16))
					if cText=="EREF" .or.cText=="MARF" .or. cText=="PREF" .or. cText=="NONREF"
						cRefType:=cText
					else 
						cText:=SubStr(cBuffer,nEndAmnt+4,16)
						IF	isnum(cText) 
							// payment pattern:
							self:GetPaymentPattern(cText,lv_addsub,@lv_budget,@lv_persid,@lv_bankid,@lv_kind)
						ENDIF
					endif
				ENDIF
				cBuffer:=oMyFile:FReadLine() 
				lv_description:=""
				lv_Oms:=''
				lv_AdrLine:=''
				lv_country:=''
				lv_BIC:=''
				lv_EndtoEnd:='' 
				lv_dueid:=''
				IF !oMyFile:FEof .and. SubStr(cBuffer,1,4)==":86:"
					* description of transaction:
					lv_Oms:=AllTrim(SubStr(cBuffer,5))
					cBuffer:=oMyFile:FReadLine()
					DO WHILE !oMyFile:FEof .and. !(Occurs(":",SubStr(cBuffer,1,6))=2)  // no TAG
						if !Empty(cRefType) .and. !cRefType=='NONREF'
							lv_Oms+=cBuffer
						else
							lv_Oms+=' '+cBuffer 
						endif
						cBuffer:=oMyFile:FReadLine()
					ENDDO
					aWord:=GetTokens(lv_Oms,{" ",","},false)
					lv_description:=lv_Oms
					do case
					case cRefType=='PREF'
						// batch 
						if lv_kind=='IC'
							lv_kind:='COL'
						endif
						lv_budget:=Cur_enRoute 
					case cRefType=='EREF'
						if !(lv_kind=='VZ' .or. lv_kind=='DV')
							if sepaenabled .and. Len(aWord)>=2
								if IsSEPA(aWord[1,1])
									lv_BankAcntContra:=aWord[1,1]
									lv_BIC:=aWord[2,1]
									iSt:=3
								elseif IsSEPA(aWord[2,1])
									lv_BankAcntContra:=aWord[2,1]
									if Len(aWord)>2
										lv_BIC:=aWord[3,1]
										iSt:=4
									endif
								else
									lv_BankAcntContra:=ZeroTrim(aWord[1,1])
									iSt:=2
								endif
							else
								lv_BankAcntContra:=ZeroTrim(aWord[1,1])
								iSt:=2
							endif
							for i:=iSt to Len(aWord)
								if aWord[i,1]=='NOTPROVIDED'
									// end of name
									i++
									exit
								elseif Lower(aWord[i,1])=='transactiedatum'
									// end of name
									i+=2
									exit
								elseif (Len(aWord[i,1])>5 .and.isnum(aWord[i,1])) .or. i==Len(aWord)
									// end of name
									exit
								endif
								lv_NameContra+=iif(Empty(lv_NameContra),'',' ')+ aWord[i,1]
							next
							lv_description:=Implode(aWord,,i,,1)
						endif
					case cRefType=='MARF'
						if lv_kind=='IC'
							// SEPA DD debited:
							if sepaenabled .and. Len(aWord)>3
								lv_BankAcntContra:=aWord[3,1]
								lv_BIC:=aWord[4,1]
							else
								lv_BankAcntContra:=ZeroTrim(aWord[1,1])
							endif
							lv_description:=Implode(aWord,,4,,1)
						elseif lv_kind=='DV'
							// reversal DD:
							if Right(aWord[2,1],1)=='1'
								lv_kind:='COLREJ'
							else
								lv_kind:='COL'
							endif
							if sepaenabled .and. Len(aWord)>5
								lv_BankAcntContra:=aWord[5,1]
								lv_BIC:=aWord[6,1]
							else
								lv_BankAcntContra:=ZeroTrim(aWord[1,1])
							endif
							for i:=7 to Len(aWord)
								if At('ZZZ',aWord[i,1])>4
									// incassant id
									if Len(aWord)>i+1 
										lv_EndtoEnd:=aWord[i+2,1]
										if Len(Split(lv_EndtoEnd,'-'))>=3
											lv_persid:=Split(lv_EndtoEnd,'-')[1]
											lv_dueid:=Split(lv_EndtoEnd,'-')[3] 
										endif
									endif
									lv_description:=Implode(aWord,,i+1,,1)
									exit
								endif
								lv_NameContra+=iif(Empty(lv_NameContra),'',' ')+ aWord[i,1]
							next
						endif
					case cRefType=='NONREF' .or. Empty(cRefType) 
						if lv_kind=='IC' .and. lv_addsub=='B'
							// crediting of total direct debits:
							lv_budget:=Cur_enRoute 
						elseif !(lv_kind=='VZ' .or. lv_kind=='DV')
							lv_BankAcntContra:=ZeroTrim(aWord[1,1]) 								
							if sepaenabled .and. !IsIban(lv_BankAcntContra)
								if Val(lv_BankAcntContra)<10000000
									// inq-PB:
									lv_BankAcntContra:=  "INGB"+PadL(lv_BankAcntContra,10,'0')
									lv_BankAcntContra:= 'NL'+StrZero(IbanChecksum("NL00"+lv_BankAcntContra),2,0)+lv_BankAcntContra
								endif
							endif
							if lv_addsub=='B'
								for i:=2 to Len(aWord)
									if Lower(aWord[i,1])=='transactiedatum'
										// end of name
										i+=2
										exit
									elseif (Len(aWord[i,1])>5 .and.isnum(aWord[i,1])) .or. i==Len(aWord)
										// end of name
										exit
									endif
									lv_NameContra+=iif(Empty(lv_NameContra),'',' ')+ aWord[i,1]
								next
								lv_description:=Implode(aWord,,i,,1) 
							else
								lv_description:=Implode(aWord,,2,,1) 
							endif
						endif
					endcase 
				ENDIF 
				if Empty(lv_budget)
					// Look for budget code between * or [] or ()
					if (nOffset:=At('*',lv_description))>0
						if At3('*',lv_description,nOffset+1)>0  //2e * 
							aBudg:=Split(SubStr(lv_description,nOffset+1),'*')
							if	Len(aBudg)>0 .and. isnum(aBudg[1])
								lv_budget:=aBudg[1]
							endif
						endif
					endif
					if Empty(lv_budget) .and. (nOffset:=At('[',lv_description))>0
						aBudg:=Split(SubStr(lv_description,nOffset+1),']') 
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
						endif					
					endif
					if Empty(lv_budget) .and. (nOffset:=At('(',lv_description))>0
						aBudg:=Split(SubStr(lv_description,nOffset+1),')') 
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
						endif
					endif
				endif
				lv_description:=AddSlashes(AllTrim(lv_description))
				lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))   //max length 32 in teletrans
				* save transaction:
				nTrans++ 
				if IsAlpha(lv_BankAcntContra)
					lv_country:=SubStr(lv_BankAcntContra,1,2)
					if Empty(lv_BIC)
						lv_BIC:=GetBIC(lv_BankAcntContra)
					endif
				endif
				
				// 				self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(Val(lv_reference),-1),lv_BankAcntContra,;
				nSeqnr++ 
				self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(nSeqnr,-1),lv_BankAcntContra,;
					lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid,AddSlashes(lv_AdrLine),lv_country,lv_BIC,lv_dueid)
				lv_Oms:=""
			enddo     // end 61 /86 combinations 

			IF SubStr(cBuffer,1,5)==":62F:"
				// balance new:
				lv_balance:=Val(iif(SubStr(cBuffer,6)='C','','-')+SubStr(cBuffer,16,15))
				ld_bookingdate:=SToD("20"+SubStr(cBuffer,7,6)) // valuta date
				AAdd(self:avaluesBal,{lv_bankAcntOwn,ld_bookingdate,lv_balance})
			endif
			// 
			exit
		ENDDO       // end :25 transaction
	ENDDO
	oMyFile:Close()
	oMyFile:=null_object 
	// store read data into database:
	lSuccess:=self:SaveTeleTrans(true,true,"MT940 file "+oFm:FileName+'.'+oFm:Extension,nTrans)
	if lSuccess
		return true
	else
		return false
	endif
METHOD ImportPGAutoGiro(oFm as MyFileSpec) as logic CLASS TeleMut
	*	Import of one PostGiro AutoGiro transaction file (Sweden)
	LOCAL oHlM as HlpMT940
	LOCAL lv_bankAcntOwn, lv_description, lv_addsub, lv_AmountStr, lv_budget, lv_InvoiceID, lv_reference, lv_persid,lv_BankAcntContra,lv_NameContra as STRING
	LOCAL lv_loaded as LOGIC
	LOCAL lv_Amount as FLOAT
	LOCAL lSuccess:=true as LOGIC
	LOCAL oSub as SQLSelect
	LOCAL oHlp as FileSpec
	LOCAL ld_bookingdate as date 
	local oStmnt as SQLStatement
	local nCnt,nTot,nProc as int

	// IF !oFm:FileLock()
	// 	RETURN FALSE
	// ENDIF
	
	oHlM :=HLPMT940{HelpDir+"\HPG"+StrTran(StrTran(Time(),":"),' ','')+".DBF",DBEXCLUSIVE} 
	oHlM:Zap()
	
	lSuccess:=oHlM:AppendSDF(oFm)
	oHlM:Gotop()
	// First line contains own giro#:
	IF SubStr(oHlM:MTLINE,1,2)#"01"
		ErrorBox{,"File "+oFm:Fullpath+" is not a correct PG Autogiro file"}:Show()
		oHlp:=FileSpec{oHlM:Filespec:Fullpath}
		oHlM:Close()
		oHlM:=null_object
		oHlp:DELETE() 
		oHlM:=null_object
		RETURN false
	ENDIF
	SaveUse("ImportPGAutoGiro")
	lv_bankAcntOwn:=ZeroTrim(SubStr(oHlM:MTLINE,69,10))
	oHlM:skip()
	DO WHILE .not.oHlM:EoF
		* Search NY090020 record:
		IF !SubStr(oHlM:MTLINE,1,2)=="82" .or.SubStr(oHlM:MTLINE,80,1)=="1" 
			oHlM:skip()
			loop
		ENDIF 
		ld_bookingdate:=SToD(SubStr(oHlM:MTLINE,3,8)) // valuta date
		lv_addsub:="B"
		lv_AmountStr:=SubStr(oHlM:MTLINE,32,12)
		lv_Amount:=Round(Val(lv_AmountStr)/100.00,2)
		lv_bankAcntOwn:=ZeroTrim(SubStr(oHlM:MTLINE,44,10))
		// Determine from KIDnr personid and accountnbr:
		lv_InvoiceID:=ZeroTrim(SubStr(oHlM:MTLINE,16,16))
		lv_description:=lv_InvoiceID
		lv_persid:=SubStr(lv_InvoiceID,1,5)
		// 	lv_Budget:=SubStr(lv_InvoiceID,10,5)
		// 	IF Len(lv_Budget)=2
		// 		lv_Budget:="22"+lv_Budget+"0"  // expanded to 5 numbers account#
		// 	ENDIF
		lv_reference:=SubStr(oHlM:MTLINE,7,8)
		lv_description:=AddSlashes(AllTrim(lv_description))
		
		* save transaction:
		nTot++ 
		oSub:=SqlSelect{"select personid from subscription where invoiceid='"+lv_InvoiceID+"'",oConn}
		if oSub:RecCount>0
			lv_persid:=Str(oSub:Personid,-1)
		endif
		self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,'',lv_BankAcntContra,;
			'PGA',lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid)
		lv_description:=""
		oHlM:skip()
	ENDDO
	

	oHlp:=FileSpec{oHlM:FileSpec:Fullpath}
	oHlM:Close()
	oHlM:=null_object
	oHlp:DELETE() 
// 	nCnt:=self:lv_aant_toe
// 	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(true,false,"PGAutoGiro file:"+oFm:FileName,nTot)
// 	AAdd(self:aMessages,"Imported PGAutoGiro file:"+oFm:FileName+" "+Str(self:lv_aant_toe -nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		return true
	else
		return false                                              
	endif

METHOD ImportPostbank( oFs as MyFileSpec ) as logic CLASS TeleMut
	* Import of postgiro data into teletrans
	LOCAL i, lName, nRead,nOms as int
	LOCAL cSep as int
	LOCAL ptDate, ptAcc, ptDesc, ptTeg, ptCode, ptAfBij,ptBedr, ptSoort,ptMed as int
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()),nImp,nTrans,nProc as int
	Local lv_Amount as FLOAT
	LOCAL lv_addsub,lv_addsub,cCurrency,lv_description, lv_kind, lv_NameContra,lv_budget,lv_persid as STRING
	LOCAL lv_bankAcntOwn, lv_BankAcntContra,lv_Bic,lv_Country as STRING
	LOCAL cDelim:="," as STRING
	LOCAL hl_boekdat as STRING
	LOCAL pbType as STRING
	LOCAL cBuffer as STRING 
	LOCAL lSuccess:=true as LOGIC
	LOCAL lv_loaded as LOGIC
	LOCAL ld_bookingdate as date 
	Local hlpbank as USUAL
	LOCAL m57_laatste := {} as ARRAY
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptrHandle as MyFile
	local oStmnt as SQLStatement

// 	cSep:=SetDecimalSep(Asc(","))
	ptrHandle:=MyFile{oFs}
	pbType:=Upper(oFs:Extension)
	IF FError() >0
		//	(ErrorBox{,"Could not open file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine()
	IF Empty(cBuffer)
		ptrHandle:Close()
		ptrHandle:=null_object 
		(ErrorBox{,"Could not read file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	SaveUse("ImportPostbank")
	//cDelim:=','
	aStruct:=Split(Upper(cBuffer),cDelim)
	IF Len(aStruct)<9
		cDelim:=';'
		aStruct:=Split(Upper(cBuffer),cDelim)
	ENDIF
	ptDate:=AScan(aStruct,{|x| "DATUM" $ x})
	ptDesc:=AScan(aStruct,{|x| "NAAM / OMSCHRIJVING" $ x})
	ptAcc:=AScan(aStruct,{|x| "REKENING" $ x})
	ptTeg:=AScan(aStruct,{|x| "TEGENREKENING" $ x})
	ptCode:=AScan(aStruct,{|x| "CODE" $ x})
	ptAfBij:=AScan(aStruct,{|x| "AF BIJ" $ x})
	ptBedr:=AScan(aStruct,{|x| "BEDRAG (EUR)" $ x})
	ptSoort:=AScan(aStruct,{|x| "MUTATIESOORT" $ x})
	ptMed:=AScan(aStruct,{|x| "MEDEDELINGEN" $ x})
	IF ptDate==0 .or. ptDesc==0 .or. ptAcc==0 .or. ptTeg==0 .or. ptCode==0 .or. ptAfBij==0 .or. ptBedr==0 .or.ptSoort==0.or. ptMed==0
		(ErrorBox{,"Wrong fileformat of importfile from Postbank: "+oFs:FullPath+"(See help)"}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine()
	aFields:=Split(cBuffer,cDelim)

	DO WHILE Len(AFields)>7
		lv_bankAcntOwn:=ZeroTrim(StrTran(AFields[ptAcc],' ',''))
		if sepaenabled .and. Len(lv_bankAcntOwn)<=7
			// convert to sepa: 
			lv_bankAcntOwn:=  "INGB000"+PadL(lv_bankAcntOwn,7,"0")
			lv_bankAcntOwn:= 'NL'+StrZero(IbanChecksum("NL00"+lv_bankAcntOwn),2,0)+lv_bankAcntOwn	   	
		endif
		hl_boekdat:=AFields[ptDate]
		IF Len(hl_boekdat)=8
			ld_bookingdate:=SToD(hl_boekdat)
		ELSE
			ld_bookingdate:=SToD(SubStr(hl_boekdat,7,4)+;
				SubStr(hl_boekdat,4,2)+SubStr(hl_boekdat,1,2))
		ENDIF
		++nTrans
		IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_bankAcntOwn:= self:m57_BankAcc[self:CurTelePtr,1]  // translate to sepa if sepaenabaled 
		lv_NameContra:=AllTrim(AFields[ptDesc])
		lName:=Len(lv_NameContra)
		lv_description:=AllTrim(AFields[ptMed])
		//lv_description := SubStr(lv_description,1,32)+' '+SubStr(lv_description,33,32)+' '+SubStr(lv_description,65,32)+' '+SubStr(lv_description,97)
		IF lv_NameContra==SubStr(lv_description,1,lName)
			* haal naam eruit:
			lv_description:=Trim(SubStr(lv_description,lName+1))
		ENDIF
		lv_description:=AllTrim(Compress(lv_description))
		lv_NameContra:=AllTrim(Compress(lv_NameContra))
		lv_kind:=AFields[ptCode]
// 		lv_addsub:=PadR(AFields[ptCode],3)
		lv_addsub:=SubStr(AFields[ptAfBij],1,1)
		cCurrency := "EUR"
// 		lv_kind:=AFields[ptSoort]		
		IF Empty(lv_kind)  && alleen mutaties laden
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		IF lv_addsub # "A".and.lv_addsub # "B"    && alleen Af/BIJ-mutaties laden
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		IF lv_addsub=="A"    && geen mededelingen laden
			IF "OPDRACHT NIET VERWERKT" $ Upper(lv_description)
				cBuffer:=ptrHandle:FReadLine()
				aFields:=Split(cBuffer,cDelim)
				loop
			ENDIF
		ENDIF
		lv_BankAcntContra:=ZeroTrim(AFields[ptTeg])
		lv_Amount:=Val(StrTran(AFields[ptBedr],',','.',,1))
		IF Empty(lv_Amount)  && geen lege mutaties laden
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		* Nagaan of banknumber in begin omschrijving opgenomen:
		hlpbank:=SubStr(lv_NameContra,1,10)
		IF isnum(hlpbank)
			hlpbank:=Val(hlpbank)
			IF hlpbank<=999999
				hlpbank:=0
			ENDIF
		ELSE
			hlpbank:=0
		ENDIF
		IF hlpbank>0  && Zoja, dat als tegennummer opnemen:
			lv_BankAcntContra := Str(Val(SubStr(lv_NameContra,1,10)),-1)
			lv_NameContra := SubStr(lv_NameContra,11)
		ENDIF
		
		if (i:=AtC('BIC:',lv_description))>0
			// standard format:
			lv_Bic:=Split(AllTrim(SubStr(lv_description,i+4)))[1]
			lv_Country:=SubStr(lv_BankAcntContra,1,2)
			if (nOms:=AtC('Omschrijving:',lv_description))>0
				lv_description:=AllTrim(SubStr(lv_description,nOms+13)) 
			else
				lv_description:=''
			endif
		else
			lv_Bic:=''
			if IsIban(lv_BankAcntContra)
				lv_Country:=SubStr(lv_BankAcntContra,1,2)
			else				
				lv_Country:=''
			endif
		endif
	  	lv_description:=AddSlashes(AllTrim(lv_description))
  		lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))
	  	lv_BankAcntContra:=ZeroTrim(lv_BankAcntContra)
		self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,'0',lv_BankAcntContra,;
		lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid,,lv_Country,lv_Bic)
		lv_description:="" 
// 		nTrans++
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	ptrHandle:=null_object 
	SetDecimalSep('.')  // restore decimal separator
	lSuccess:=self:SaveTeleTrans(true,true,"ING file:"+oFs:FileName+'.'+oFs:Extension,nTrans)
	if lSuccess
		return true
	else
		return false                                              
	endif
METHOD ImportRO(oFb) CLASS TeleMut
	* Import of Romenian Banca Transilvania into Mutgiro.dbf
	LOCAL i as int
	LOCAL lv_description,lv_descriptionPrv, lv_bankAcntOwn,lv_addsub,lv_BankAcntContra,lv_persid,lv_kind,lv_NameContra,lv_budget as STRING
	LOCAL lSuccess:=true as LOGIC
	LOCAL cDelim:=',' as STRING
	LOCAL ptrHandle as MyFile
	LOCAL cBuffer as STRING, nRead as int
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate, ptDeb,ptCre, ptDesc, ptBal,  nVnr,nCnt,nTot,nProc as int
	LOCAL pbType as STRING
	LOCAL lv_Amount, Hl_balan as FLOAT
	LOCAL ld_bookingdate as date
	local oStmnt as SQLStatement 

	lv_bankAcntOwn:=SubStr(oFb:FileName,1,24)
	ptrHandle:=MyFile{oFb}
	pbType:=Upper(oFb:Extension) 
	if Empty(ptrHandle)
		return false
	endif
	// skip first non transaction lines:
	cBuffer:=ptrHandle:FReadLine()
	do while !Upper(Left(cBuffer,15))=='DATA TRANZACTIE' .and. !ptrHandle:FEof
		cBuffer:=ptrHandle:FReadLine()
	enddo
	cBuffer:=StrTran(StrTran(cBuffer,';',''),':','')
	if !GetDelimiter(cBuffer,@aStruct,@cDelim,5,7)
		(ErrorBox{,self:oLan:Wget("Wrong fileformat of importfile from Transilvania Bank")+": "+oFb:FullPath+"("+self:oLan:Wget("See help")+")"}):show()
		ptrHandle:Close()
		RETURN FALSE
	ENDIF
	ptDate:=AScan(aStruct,{|x| "DATA TRANZACTIE" $ x})
	ptDesc:=AScan(aStruct,{|x| "DESCRIERE" $ x})
	ptDeb:=AScan(aStruct,{|x| "DEBIT" $ x})
	ptCre:=AScan(aStruct,{|x| "CREDIT" $ x})
	ptBal:=AScan(aStruct,{|x| "SOLD" $ x})
	IF ptDate==0 .or. ptDesc==0 .or. ptDeb==0.or. ptCre==0   
		(ErrorBox{,self:oLan:Wget("Wrong fileformat of importfile from Transilvania Bank")+": "+oFb:FullPath+"("+self:oLan:Wget("See help")+")"}):show()
		RETURN FALSE
	ENDIF
	SaveUse("ImportRO")

	cBuffer:=ptrHandle:FReadLine()   // skip first line
	// skip balance line: 
	cBuffer:=StrTran(cBuffer,'""','"')
	aFields:=Split(cBuffer,cDelim)
	if Empty(AFields[ptDate])
		cBuffer:=ptrHandle:FReadLine()                                       
		cBuffer:=StrTran(cBuffer,'""','"')
		aFields:=Split(cBuffer,cDelim)
	endif

	DO WHILE Len(AFields)>3 
		ld_bookingdate:=SToD(StrTran(SubStr(AFields[ptDate],1,10),'-',''))        //   2013-01-17T12:21:30
		IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			cBuffer:=ptrHandle:FReadLine()
			cBuffer:=StrTran(cBuffer,'""','"')
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_description:=iif(Empty(lv_descriptionPrv),'',lv_descriptionPrv+' ')+AllTrim(StrTran(AllTrim(AFields[ptDesc]),'"','')) 
		lv_descriptionPrv:=''
		if Upper(lv_description)=="SOLD CONTABIL" 
			// save balance:
			lv_Amount:=Round(Val(StrTran(StrTran(AFields[ptBal],'"',''),',','')),DecAantal)
			AAdd(self:avaluesBal,{lv_bankAcntOwn,ld_bookingdate,lv_Amount})
			cBuffer:=ptrHandle:FReadLine()   // skip balance lines
			cBuffer:=StrTran(cBuffer,'""','"')
			aFields:=Split(cBuffer,cDelim) 
			loop
		ENDIF
		lv_Amount:=Round(Val(StrTran(StrTran(AFields[ptCre],'"',''),',',''))+Val(StrTran(StrTran(AFields[ptDeb],'"',''),',','')),DecAantal)
		IF Empty(lv_Amount)  && skip empty transactions
			IF SubStr(lv_description,1,4)=='Ref:' 
				lv_descriptionPrv:=lv_description
			endif
			cBuffer:=ptrHandle:FReadLine()
			cBuffer:=StrTran(cBuffer,'""','"')
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		IF lv_Amount>=0
			lv_addsub:="B"
		ELSE
			lv_addsub:="A" 
			lv_Amount:=-lv_Amount
		ENDIF
		lv_Amount:=Round(lv_Amount,DecAantal)
		nTot++
		self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,'',lv_BankAcntContra,;
			lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid)
		lv_description:=""
		cBuffer:=ptrHandle:FReadLine()
		cBuffer:=StrTran(cBuffer,'""','"')
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	ptrHandle:=null_object
// 	nCnt:=self:lv_aant_toe
// 	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(false,false,"silvanTrania file:"+oFb:FileName,nTot)
// 	AAdd(self:aMessages,"Imported silvanTrania file:"+oFb:FileName+" "+Str(self:lv_aant_toe -nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		return true
	else
		return false                                              
	endif
METHOD ImportSA(oFb as MyFileSpec) as logic CLASS TeleMut
	* Import of SA Standard\Bank data into teletrans.dbf
	LOCAL oHlS as HulpSA
	LOCAL m57_laatste := {} as ARRAY
	LOCAL i, TelPtr as int
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()) as int
	LOCAL lv_loaded as LOGIC,  hlpbank as USUAL
	LOCAL lv_description, lv_bankAcntOwn,lv_addsub,lv_BankAcntContra,lv_budget,lv_persid,lv_kind:='SAB',lv_NameContra as STRING
	LOCAL lSuccess:=true as LOGIC
	LOCAL cDelim:=CHR(9) as STRING
	LOCAL ptrHandle as MyFile
	LOCAL hl_boekdat as STRING
	LOCAL oFs:=oFb as FileSpec
	LOCAL cBuffer as STRING, nCnt,nTot as int
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate, ptPay, ptDesc, ptDep, ptBal, nVnr,nProc as int
	LOCAL pbType as STRING
	LOCAL lv_Amount, lv_balance as FLOAT
	LOCAL ld_bookingdate,curdate as date 
	local oStmnt as SQLStatement

	lv_bankAcntOwn:=SubStr(oFs:FileName,11)
	lv_bankAcntOwn:=ZeroTrim(SubStr(lv_bankAcntOwn,1,At("-",lv_bankAcntOwn)-1))
	ptrHandle:=MyFile{oFs}
	pbType:=Upper(oFs:Extension)
	IF FError() >0
		(ErrorBox{,"Could not open file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine()
	IF Empty(cBuffer)
		ptrHandle:Close()
		ptrHandle:=null_object
		(ErrorBox{,"Could not read file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	//cDelim:=','
	aStruct:=Split(Upper(cBuffer),cDelim)
	IF Len(aStruct)<5
		ptrHandle:Close()
		ptrHandle:=null_object
		(ErrorBox{,"Wrong fileformat of importfile from Standard Bank: "+oFs:FullPath+"(See help)"}):show()
		RETURN FALSE
	ENDIF
	ptDate:=AScan(aStruct,{|x| "DATE" $ x})
	ptDesc:=AScan(aStruct,{|x| "DESCRIPTION" $ x})
	ptPay:=AScan(aStruct,{|x| "PAYMENTS" $ x})
	ptDep:=AScan(aStruct,{|x| "DEPOSITS" $ x})
	ptBal:=AScan(aStruct,{|x| "BALANCE" $ x})
	IF ptDate==0 .or. ptDesc==0 .or. ptPay==0 .or. ptDep==0 .or. ptBal==0
		ptrHandle:Close()
		ptrHandle:=null_object
		(ErrorBox{,"Wrong fileformat of importfile from Standard Bank: "+oFs:FullPath+"(See help)"}):show()
		RETURN FALSE
	ENDIF
	SaveUse("ImportSA")
	cBuffer:=ptrHandle:FReadLine()   // skip first line
	cBuffer:=ptrHandle:FReadLine()
	aFields:=Split(cBuffer,cDelim)

	DO WHILE Len(AFields)>4
		hl_boekdat:=AFields[ptDate]
		ld_bookingdate:=SToD(SubStr(hl_boekdat,1,4)+SubStr(hl_boekdat,6,2)+SubStr(hl_boekdat,9,2)) 
// 		IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate,500)
// 			cBuffer:=ptrHandle:FReadLine()
// 			aFields:=Split(cBuffer,cDelim)
// 			loop
// 		ENDIF
		if Empty(curdate)
			curdate:=ld_bookingdate
		endif
		if !ld_bookingdate==curdate 
			// save previous balance 
			AAdd(self:avaluesBal,{lv_bankAcntOwn,curdate,lv_balance}) 
			curdate:=ld_bookingdate
		endif 
		lv_description:=AllTrim(StrTran(AllTrim(AFields[ptDesc]),'"',''))
		lv_Amount:=AbsFloat(Val(AFields[ptPay]))
		IF lv_Amount=0
			lv_Amount:=Val(AFields[ptDep])
			lv_addsub:="B"
		ELSE
			lv_addsub:="A"
		ENDIF
		IF Empty(lv_Amount)  && no empty lines
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_Amount:=Round(lv_Amount,DecAantal)
		lv_balance:=Val(AFields[ptBal]) 
		lv_description:=AddSlashes(AllTrim(lv_description))
		nTot++
		self:AddTeleTrans(lv_bankAcntOwn,Min(Today(),ld_bookingdate),Str(Val(SubStr(lv_description,-4,4)),-1),lv_BankAcntContra,;     // no dates in the future)
		lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid)
		lv_description:=""
		//     * controleer op reeds geladen zijn van mutatie:
		// 	IF self:AllreadyImported(ld_bookingdate,lv_amount,lv_addsub,lv_description,"SAB","","","")
		// 		cBuffer:=ptrHandle:FReadLine()
		// 		aFields:=Split(cBuffer,cDelim)
		//         loop
		// 	ENDIF
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	if !Empty(curdate)
		// save last balance 
		AAdd(self:avaluesBal,{lv_bankAcntOwn,curdate,lv_balance}) 
	endif 
	ptrHandle:Close()
	ptrHandle:=null_object
	SetDecimalSep(Asc('.'))  // restore decimal separator
	lSuccess:=self:SaveTeleTrans(false,false,"SA file:"+oFb:FileName,nTot)
	if lSuccess
		return true
	else
		return false                                              
	endif
	

	RETURN true
METHOD ImportSA2(oFb as MyFileSpec) as logic CLASS TeleMut
	* Import of SA Standard Bank multiple.dat data into teletrans.dbf
	LOCAL oHlS as HulpSA
	LOCAL m57_laatste := {} as ARRAY
	LOCAL i, TelPtr as int
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()) as int
	LOCAL lv_loaded as LOGIC,  hlpbank as USUAL
	LOCAL lv_description, lv_bankAcntOwn,lv_addsub,lv_BankAcntContra,lv_budget,lv_persid,lv_kind:='SB',lv_NameContra,lv_seqnr as STRING
	LOCAL lSuccess:=true as LOGIC
	LOCAL cDelim:=',' as STRING
	LOCAL ptrHandle as MyFile
	LOCAL oFs:=oFb as FileSpec
	LOCAL cBuffer as STRING, nCnt,nTot as int
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate:=2, ptAmount:=4, ptDesc:=5, ptName:=6, ptBal:=7,ptBranch:=3,ptSeqnr:=7, nVnr,nProc as int
	LOCAL pbType as STRING
	LOCAL lv_Amount, lv_balance as FLOAT
	LOCAL ld_bookingdate as date 
	local oStmnt as SQLStatement

	// 	lv_bankAcntOwn:=SubStr(oFs:FileName,11)
	// 	lv_bankAcntOwn:=ZeroTrim(SubStr(lv_bankAcntOwn,1,At("-",lv_bankAcntOwn)-1))
	ptrHandle:=MyFile{oFs}
	pbType:=Upper(oFs:Extension)
	IF FError() >0
		(ErrorBox{,"Could not open file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine()
	IF Empty(cBuffer)
		ptrHandle:Close()
		ptrHandle:=null_object
		(ErrorBox{,"Could not read file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	//cDelim:=','
	aFields:=Split(Upper(cBuffer),cDelim)
	IF !Len(AFields)=8
		ptrHandle:Close()
		ptrHandle:=null_object
		(ErrorBox{,"Wrong fileformat of importfile from Standard Bank: "+oFs:FullPath+"(See help)"}):show()
		RETURN FALSE
	ENDIF
	SaveUse("ImportSA2")
	cBuffer:=ptrHandle:FReadLine()   // read next line
	aFields:=Split(cBuffer,cDelim)
	lv_bankAcntOwn:=ZeroTrim(AFields[ptDate])
	// read next line:
	cBuffer:=ptrHandle:FReadLine()
	aFields:=Split(cBuffer,cDelim)
	SetDecimalSep(Asc('.'))  // just to be sure
	do WHILE Len(AFields)>7
		ld_bookingdate:=SToD(ZeroTrim(AFields[ptDate]))
		lv_Amount:=Val(AFields[ptAmount])
		lv_kind:=AllTrim(AFields[ptBranch])
		if Upper(lv_kind)=="CLOSE"
			// save balance 
			AAdd(self:avaluesBal,{lv_bankAcntOwn,ld_bookingdate,lv_Amount}) 
			// skip to next line:
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop 
		elseif Upper(lv_kind)=="OPEN"
			// skip to next line:
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop 
		endif
		lv_description:=AddSlashes(AllTrim(StrTran(AllTrim(AFields[ptDesc]),'"','')))
		lv_NameContra:=AddSlashes(AllTrim(StrTran(AllTrim(AFields[ptName]),'"',''))) 
		IF lv_Amount<0
			lv_Amount:=-lv_Amount
			lv_addsub:="A"
		ELSE
			lv_addsub:="B"
		ENDIF
		IF Empty(lv_Amount)  && no empty lines
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_Amount:=Round(lv_Amount,DecAantal)
		lv_seqnr:=ZeroTrim(AFields[ptSeqnr])
		lv_BankAcntContra:=sha2(lv_kind+Str(lv_Amount,-1)+lv_description+lv_NameContra) 
		nTot++
		self:AddTeleTrans(lv_bankAcntOwn,Min(Today(),ld_bookingdate),lv_seqnr,lv_BankAcntContra,;     // no dates in the future)
		lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid)
		lv_description:=""
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	ptrHandle:=null_object
	SetDecimalSep(Asc('.'))  // restore decimal separator
	lSuccess:=self:SaveTeleTrans(false,false,"SA file:"+oFb:FileName,nTot)
	if lSuccess
		return true
	else
		return false                                              
	endif
	

	RETURN true
METHOD ImportTL1(oFm as MyFileSpec) as logic CLASS TeleMut
	* Import of Total IN  data of Swedisch PlusGiroT into teletrans.dbf
	*	Import of one TL1 telebnk transaction file
	LOCAL oHlM as HlpMT940
	LOCAL i, nEndAmnt, nDC,nCnt,nTot,nProc as int
	LOCAL lv_bankAcntOwn, lv_Oms, lv_addsub, lv_AmountStr, lv_reference,lv_NameContra, lv_address,lv_zip,lv_city, lv_country, lv_description,lv_budget,lv_persid as STRING
	LOCAL lv_loaded as LOGIC,  lv_BankAcntContra as string, cText, recordcode as STRING
	LOCAL lv_Amount as FLOAT
	LOCAL lSuccess:=true as LOGIC
	LOCAL oHlp as Filespec
	LOCAL ld_bookingdate as date 
	local aExcludebank:={;                  // the following bank accounts should be ignored as belonging to givers
	"44528602";		//PRIVATGIROT AB
	,"92486";		//PLUSGIROT, NBGIRO,DEBETKONTO                                                  
	,"8057085";		//Swedbank 
	,"42750125";	//Scandiabanken Ab
	,"10669430";	//Svenska Handelsbanken
	,"44603660";	//Nordea bank
	,"8561813";		//Scandinaviska enskilda banke 
	,"11219961";	//Danske bank A/S
	} as array
	local oStmnt as SQLStatement

	
	oHlM :=HLPMT940{HelpDir+"\HTL1"+StrTran(StrTran(Time(),":"),' ','')+".DBF",DBEXCLUSIVE} 
	oHlM:Zap()
	*Look for 2: record with transction record
	*			add record to teletrans
	*
	lSuccess:=oHlM:AppendSDF(oFm)
	oHlM:Gotop()
	SaveUse("ImportTL1")
	DO WHILE .not.oHlM:EOF
		* Search 10 Start record Account record:
		if !oHlM:EOF .and. !(SubStr(oHlM:MTLINE,1,2)=="20" .or.SubStr(oHlM:MTLINE,1,2)=="25" .or.SubStr(oHlM:MTLINE,1,2)=="10")
			oHlM:Skip()
			loop
		ENDIF
		IF SubStr(oHlM:MTLINE,1,2)=="10"
			lv_bankAcntOwn:=AllTrim(SubStr(oHlM:MTLINE,3,36))
			lv_bankAcntOwn:=SubStr(lv_bankAcntOwn,1,Len(lv_bankAcntOwn)-1)+"-"+SubStr(lv_bankAcntOwn,Len(lv_bankAcntOwn))
			lv_bankAcntOwn:=ZeroTrim(lv_bankAcntOwn) 
			
			ld_bookingdate:=SToD(SubStr(oHlM:MTLINE,42,8)) // book date 
			oHlM:Skip()
			loop
		endif
		// Search for Payment record: 
		if SubStr(oHlM:MTLINE,1,2)=="20"
			// proces Payment: 
			lv_reference:=ALLTRIM(SubStr(oHlM:MTLINE,3,35))	// banken transactiecode
			lv_Amount:=Round(Val(AllTrim(SubStr(oHlM:MTLINE,38,15)))/100.00,2)
			//lv_BankAcntContra:=ZeroTrim(AllTrim(SubStr(oHlM:MTLINE,70,8)))
			lv_addsub:="B" 
		elseif SubStr(oHlM:MTLINE,1,2)=="25"     
			lv_reference:=AllTrim(SubStr(oHlM:MTLINE,3,35))	// invoice id
			lv_Amount:=Round(Val(AllTrim(SubStr(oHlM:MTLINE,38,15)))/100.00,2)
			lv_addsub:="A" 		
		endif 
		// Initialize values:
		lv_NameContra:=""
		lv_address:=""
		lv_zip:=""
		lv_city:=""
		lv_country:=""
		lv_BankAcntContra:=""
		lv_oms:=""
		// Process additional records until next 20, 25 or 10 or 90 record.
		oHlM:Skip() 
		do while !oHlM:EOF 
			recordcode:= SubStr(oHlM:MTLINE,1,2)
			do CASE 
			case recordcode=="30"
				if Empty(lv_reference) 
					lv_reference:=Compress(AllTrim(SubStr(oHlM:MTLINE,3,70)))
				endif	
			case recordcode=="40"
				lv_oms+=Compress(SubStr(oHlM:MTLINE,3,35)+SubStr(oHlM:MTLINE,38,35))+" " 
			case recordcode=="50" .or.(recordcode=="61" .and. Empty(lv_NameContra))
				lv_NameContra:=Compress(AllTrim(SubStr(oHlM:MTLINE,3,70)))			
			case recordcode=="51" .or.(recordcode=="62" .and.Empty(lv_address)) 
				lv_address :=Compress(AllTrim(SubStr(oHlM:MTLINE,3,70)))						
			case recordcode=="52" .or.( recordcode=="63".and.Empty(lv_zip) )
				lv_zip :=StandardZip(AllTrim(SubStr(oHlM:MTLINE,3,8)))						
				lv_city :=AllTrim(SubStr(oHlM:MTLINE,12,35))						
				lv_country :=AllTrim(SubStr(oHlM:MTLINE,47,2))						
			case recordcode=="60"
				if Empty(lv_zip) .and. AScan(aExcludeBank,AllTrim(SubStr(oHlM:MTLINE,3,36)))=0 // no 51 record with original sender and no account of other bank at plusgirot, then 61 is account of giver
					lv_BankAcntContra:=ZeroTrim(AllTrim(SubStr(oHlM:MTLINE,3,36)))
				endif
			case recordcode=="70" .or.recordcode=="61".or.recordcode=="62".or.recordcode=="63"
			otherwise
				exit
			endcase
			oHlM:Skip() 
		ENDDO
		* save transaction:
		lv_description:=""
		if !Empty(lv_NameContra)
			lv_description+="<n>"+lv_NameContra+"</n>"
		endif
		if !Empty(lv_address)
			lv_description+="<a>"+lv_address+"</a>"
		endif
		if !Empty(lv_zip)
			lv_description+="<p>"+lv_zip+"</p>"
		endif
		if !Empty(lv_city)
			lv_description+="<t>"+lv_city+"</t>"
		endif
		if !Empty(lv_country)
			lv_description+="<c>"+lv_country+"</c>"
		endif
		if !Empty(lv_oms)
			lv_description+="<d>"+lv_Oms+"</d>"
		endif
		lv_description:=AddSlashes(AllTrim(lv_description))
		lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))
		nTot++ 
		self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,'',lv_BankAcntContra,;
			lv_reference,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid)
		lv_description:=""
	ENDDO
	

	oHlp:=FileSpec{oHlM:Filespec:Fullpath}
	oHlM:Close()
	oHlM:=null_object
	oHlp:DELETE()
	lSuccess:=self:SaveTeleTrans(false,false,"TL/1 file:"+oFm:FileName,nTot)
	if lSuccess
		return true
	else
		return false                                              
	endif
METHOD ImportUA(oFr as MyFileSpec) as logic CLASS TeleMut
	* Import of one bankstatements of Ukraine Bank into teletrans.dbf
	LOCAL cBuffer,childbuffer AS STRING
	LOCAL ptrHandle
	LOCAL oTelTr:=self:oTelTr as SQLSelect
	LOCAL UADocument, UAChildDocument AS XMLDocument
	LOCAL childfound, recordfound,lv_loaded,lSuccess as LOGIC
	LOCAL ChildName AS STRING
	LOCAL lv_Amount as FLOAT
	LOCAL lv_NameContra,lv_description, Docid, lv_kind,currency,lv_bankAcntOwn,lv_BankAcntContra,lv_addsub,Datestr,entitycode,contrabankid as STRING 
	local lv_budget,lv_persid as string
	LOCAL ld_bookingdate, rppdate as date
	LOCAL nCol,i, nVnr AS INT
	LOCAL ld_bookingdate as date
	local oStmnt as SQLStatement
	local nCnt,nTot as int

	ptrHandle:=FOpen(oFr:FullPath,FO_READ)
	IF ptrHandle = F_ERROR
		(ErrorBox{,"Could not open file: "+oFr:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN false
	ENDIF
	cBuffer:=StrTran(Compress(FReadStr(ptrHandle,4096000)),"&nbsp;")
	cBuffer:=SubStr(cBuffer,At("</tr>",cBuffer)+5)
	cBuffer:=StrTran(StrTran(cBuffer,CHR(10)),CHR(9))
	cBuffer:=StrTran(StrTran(StrTran(StrTran(StrTran(cBuffer,"<small>"),"</small>"),"<nobr>"),"</nobr>"),"&nbsp;")
	IF ptrHandle = F_ERROR
		(ErrorBox{,"Could not read file: "+oFr:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN false
	ENDIF
	FClose(ptrHandle)
	// Proces records:
	UADocument:=XMLDocument{cBuffer}
	recordfound:= UADocument:GetElement("tr")
	SaveUse("ImportUA")
	
	DO WHILE recordfound
		childfound:=UADocument:GetFirstChild()
		docId:=""
		currency:=""
		lv_NameContra:=""
		entitycode:=""
		lv_description:=""
		lv_Amount:=0.00
		ld_bookingdate:=Today()
		lv_bankAcntOwn:=""
		lv_BankAcntContra:=""
		contrabankid:=""
		nCol:=0
		DO WHILE childfound
			ChildName:=UADocument:ChildName
			IF ChildName=="td"
				nCol++
				DO CASE
				CASE nCol=2
					Datestr:=StrTran(AllTrim(UADocument:ChildContent)," ",NULL_STRING)
					ld_bookingdate:=CToD(Datestr)
				CASE nCol=4
					lv_Amount:=Val(UADocument:ChildContent)
					IF lv_Amount < 0
						lv_addsub:="A"
					ELSE
						lv_addsub:="B"
					ENDIF
					lv_amount:=AbsFloat(lv_amount)
				CASE nCol=5
					currency:=UADocument:ChildContent
				CASE nCol=6
					lv_description+=UADocument:ChildContent+" "
				CASE nCol=7
					entitycode:=AllTrim(UADocument:ChildContent)
				CASE nCol=8
					lv_NameContra:=AllTrim(UADocument:ChildContent)
				CASE nCol=9
					lv_BankAcntContra:=AllTrim(UADocument:ChildContent)
				CASE nCol=10
					contrabankid:=AllTrim(UADocument:ChildContent)
				CASE nCol=11
					lv_bankAcntOwn:=ZeroTrim(UADocument:ChildContent)
				CASE nCol=13
					DocId:=UADocument:ChildContent
					lv_kind := SubStr(Docid,1,3)
					DocId:=SubStr(DocId,4)
					DO WHILE !IsDigit(DocId) .and. Len(DocId)>1
						DocId:=SubStr(DocId,2)
					ENDDO
					nVnr:=Val(SubStr(Str(Val(DocId),-1,0),-5))
				ENDCASE
			ENDIF
			childfound:=UADocument:GetNextChild()			
		ENDDO
		IF nCol>9
			i := AScan(m57_BankAcc,{|x| x[1]==lv_bankAcntOwn})
			IF i==0
				recordfound:=UADocument:GetNextSibbling()
				LOOP
			ENDIF
		ELSE
			recordfound:=UADocument:GetNextSibbling()
			LOOP
		ENDIF

		IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)	
			recordfound:=UADocument:GetNextSibbling()
			LOOP
		ENDIF
		IF Empty(lv_BankAcntContra)
			lv_BankAcntContra:=entitycode
		ELSEIF !Empty(contrabankid)
			lv_BankAcntContra+="-"+contrabankid
		ENDIF
		lv_description:=AddSlashes(AllTrim(lv_description))
		lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))
		lv_BankAcntContra:=ZeroTrim(lv_BankAcntContra)
		nTot++
		self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(nVnr,-1),lv_BankAcntContra,;
			lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid)
		lv_description:=""
		// 	IF self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,lv_kind,lv_BankAcntContra,lv_NameContra,"")
		// 		recordfound:=UADocument:GetNextSibbling()
		//       loop
		// 	ENDIF
		// 	oStmnt:=SQLStatement{"insert into teletrans set	"+;
		// 	"contra_bankaccnt='"+lv_BankAcntContra+"'"+;
		// 	",contra_name='"+lv_NameContra+"'"+;
		// 	",bankaccntnbr='"+lv_bankAcntOwn+"'"+;
		// 	",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
		// 	",kind='"+lv_kind +"'"+;
		// 	",amount='"+Str(lv_Amount,-1)+"'"+;
		// 	",addsub='"+lv_addsub	+"'"+;
		// 	",code_mut_r='M'"+;
		// 	",seqnr="+Str(nVnr,-1)+;
		// 	",description='"+lv_description	+"'",oConn}
		// 	oStmnt:Execute()
		// 	if	oStmnt:NumSuccessfulRows>0
		// 		++self:lv_aant_toe
		// 		nCnt++
		// 	endif
		recordfound:=UADocument:GetNextSibbling()
	ENDDO 
	nCnt:=self:lv_aant_toe 
	lSuccess:=self:SaveTeleTrans(true,true,"UA file:"+oFr:FileName,nTot)
// 	AAdd(self:aMessages,"Imported UA file:"+oFr:FileName+" "+Str(self:lv_aant_toe -nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions")
	if lSuccess
		return true
	else
		return false                                              
	endif
METHOD INIT(Gift,oOwner) CLASS TeleMut
	* Gift: true: next gift
	*       false: next nongift
	local oSelBank as SelBankAcc 
	local oBank,oAcc as SQLSelect
	local cReq,cDestname as string  

	self:oLan:=Language{}
	oBank := SQLSelect{"select banknumber from bankaccount where banknumber<>''",oConn}
	IF oBank:reccount<1
		RETURN self
	ENDIF
	DO WHILE .not.oBank:EOF
		AAdd(self:bankacc,oBank:banknumber)
		oBank:skip()
	ENDDO
	ASort(self:bankacc,,,{|x,y| x<=y} ) 
	self:cBankAcc:=Implode(self:bankacc,"','")
	oBank:SQLString:= "select banknumber,usedforgifts,giftsall,singledst,a.description,a.accnumber,payahead,b.accid,fgmlcodes,syscodover from bankaccount b left join account a on (a.accid=b.singledst) where banknumber<>'' and telebankng=1" 
	oBank:Execute()
	DO WHILE .not.oBank:EOF
		if Empty(oBank:Description)
			cDestname:=''
		else
			cDestname:=GetTokens(ConS(oBank:Description))[1,1]
		endif
		//m57_bankacc: banknumber, usedforgifts, datlaatst, giftsall,singledst,destname,accid,payahead,singlenumber,fgmlcodes,syscodover
		//                 1            2           3          4         5         6      7      8           9        10          11
		AAdd(self:m57_bankacc,{oBank:banknumber,ConL(oBank:usedforgifts),null_date,ConL(oBank:giftsall),ConS(oBank:singledst),cDestname,ConS(oBank:accid),ConS(oBank:payahead),ConS(oBank:ACCNUMBER),oBank:fgmlcodes,oBank:syscodover})
		oBank:skip()
	ENDDO
	ASort(self:m57_BankAcc,,,{|x,y| x[1]<=y[1]} ) 
	self:InitteleNonGift()   // fill self:teleptrn
	self:m56_kind:=Space(6)
	self:m56_contra_name:=Space(10)
	self:oParent:=oOwner
	self:cReqTeleBnk:=Implode(self:m57_BankAcc,"','",1,,1) 
	self:Import(oBank)
	// 	oTelTr:= SQLSelect{"select * from teletrans where processed='' and bankaccntnbr<>''" ,oConn}
	self:lGift := Gift
	if Len(self:m57_BankAcc)>1 
		oSelBank:=SelBankAcc{,,,self}
		oSelBank:Show() 
	endif
	self:cReqTeleBnk:=Implode(self:m57_BankAcc,"','",1,,1) 
	// determine ACCNUMBER of sKruis:
	IF !Gift .and.!Empty(SKruis)
		* Seek accountnumber of skruis: 
		oAcc:=SQLSelect{"select accnumber from account where accid="+SKruis+" limit 1",oConn }
		if oAcc:reccount>0
			self:cAccnumberCross:=oAcc:ACCNUMBER
		endif
	endif

	RETURN self
METHOD InitTeleNonGift() CLASS TeleMut
local i as int
	LOCAL lSuc as LOGIC
	local aTelePtr:={} as array
	local oTelPat as SQLSelect
// 	oTelPat:=SQLSelect{"select * from TeleBankPatterns where accid>0 and kind<>'' and contra_bankaccnt<>'' and addsub<>'' and description<>''",oConn}
	oTelPat:=SqlSelect{"select group_concat(contra_bankaccnt,'#$#',kind,'#$#',contra_name,'#$#',addsub,'#$#',p.description,'#$#',cast(p.accid as char),'#$#',cast(ind_autmut as char),'#$#',a.accnumber separator '#%#')"+;
	" as telepatgrp from telebankpatterns p, account a where a.accid>0 and a.accid=p.accid",oConn} 
	oTelPat:execute()
	if oTelPat:Reccount>0 .and. !Empty(oTelPat:telepatgrp)
		AEval(Split(oTelPat:telepatgrp,'#%#'),{|x|AAdd(aTelePtr,Split(x,'#$#')) }) 
		for i:=1 to Len(aTelePtr)
			aTelePtr[i,5]:=Split(aTelePtr[i,5],Space(1))
		next
      self:teleptrn:=aTelePtr  // {contra_bankaccnt,kind,contra_name,addsub,description,accid,ind_autmut,accnumber},...
                               //        1            2     3           4       5          6        7        8
	endif
	RETURN nil
	
METHOD NextTeleGift CLASS TeleMut
	* Give next telebanking gift transaction from teletrans
DO WHILE SELF:GetNxtMut(TRUE)
	m56_autom:= FALSE
	RETURN TRUE
ENDDO
RETURN FALSE
METHOD NextTeleNonGift(dummy:=nil as logic) as logic CLASS TeleMut
	* Give next telebanking transaction from teletrans
	LOCAL oAcc as SQLSelect
	DO WHILE self:GetNxtMut(false)
		self:m56_recognised:=FALSE
		self:m56_autmut:=FALSE
		IF .not.Empty(SKruis).and..not.Empty(self:m56_contra_bankaccnt).and.Empty(self:m56_budgetcd)
			if SQLSelect{"select accid from bankaccount where banknumber='"+AllTrim(self:m56_contra_bankaccnt)+"'",oConn}:reccount>0 
				self:m56_budgetcd:=self:cAccnumberCross 
				if Empty(self:m56_description)
					self:m56_description:=self:oLan:rget("clearing")
				endif
			ENDIF
		ENDIF
// 		IF .not.Empty(self:m56_budgetcd).and..not.IsAlpha(self:m56_budgetcd)
		IF .not.Empty(self:m56_budgetcd)
			self:m56_accnumber:=self:m56_budgetcd
			self:m56_recognised:=true
			if (self:m56_kind=="CLL" .or.self:m56_kind="COL") .and. self:m56_addsub=="A";   // storno:
				.or. self:m56_kind=='593' // rejected bank order
				self:m56_autmut:=false
				IF self:m56_kind=="CLL"
					self:m56_sgir:=self:m56_Payahead
				endif
			else	
				self:m56_autmut:=true
			endif
		ELSEIF (self:m56_kind=="IC" .or.self:m56_kind=="OCR") .and.Empty(Val(self:m56_contra_bankaccnt)).and.self:m56_addsub =="B" .and.!Empty(self:m56_Payahead)
			// in case of recording of automatic collections take payahead as contra account:
			self:m56_accid:=self:m56_Payahead
			self:m56_recognised:=true
			self:m56_autmut:=true 
		endif
		IF !self:m56_recognised
			self:CheckPattern(self:m56_contra_bankaccnt ,self:m56_kind,self:m56_contra_name, self:m56_addsub,self:m56_description)
		ENDIF
		RETURN true
	ENDDO

	RETURN FALSE
method SaveTeleTrans(lCheckPerson:=true as logic,lCheckAccount:=true as logic, cFilename as string, nTot as int) as logic class TeleMut 
	// Process imported transactions in array self:aValueTrans to save them into table teletrans and record them where possible into transactions
	// lCheckPerson: check if persid within aValueTrans is an existing person
	// lCheckAccount: check if budgetcd belongs to an existing account as accnumber
	// cFilename: filename of importfile for messages 
	// nTot: total transaction within cFilename for messages 
	//  
	local i,j,k,l,m,nProc,nTransId,nTele,maxTeleId,nSeqnbr as int
	local nAddrEnd as int
	local fDeb,fDebForgn,fCre,fCreForgn,fDirecDebit as float 
	local cPersids,cPersid,cBudgetcds,cBudgetcd,cBankAcc,cBankAcc2,lv_description,lv_specmessage,lv_gc,lv_persid,cBankAccOwn,lv_accid,cDestAcc,cTransid as string 
	local cDueids,cDueidsInv,cDueid,endtoend,lv_address as string
	local cBankContrNotIBAN,cBankContr,cBankAcctContr as string 
	local cStatement as string
	local invoicedate as date 
	local	lAddressChanged,lProcAuto as logic
	local aPersids:={}, aPersidsDb:={} as array
	local aSubPersids:={}, aSubscr:={} as array, aSubscrtn:={} as array, aSub:={} as array,aValueSubPtr:={}  // arrays for getting gifts patterns
	local aBudgetcd:={}, aAccnbrDb:={}, aAccnbrDbExp:={}, aAccnbrDbInc:={}, aAccnbrDbFund:={},aDueid:={}
	local aAccnbrDue:={} as array  // accnumber, dueid, yes/no invalid mandateid, yes/no to be blocked 
	local aBankContra:={},aBankContraNonIban:={},aBankCont:={} as array  // {{bankacc,persid,ismember},...}
	local avalueTrans:=self:aValuesTrans as array
	local aAddr:={},aAddrDB:={} as array // address: {streetname,housenbr} 
	local aTrans:={} as array  // array with values to be inserted into table transaction:
	//aTrans: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
	//          1    2     3      4      5      6            7      8   9  10      11         12    13     14       15      16    17    18
	local aTransIncExp:={} as array // array like aTrans for ministry income/expense transactions   
	local avaluesPers:={} as array // {persid,dategift},...  array with values to be updated into table person 
	local aZip:={} as array // {persid,postalcode},...   array with postalcode per person 
	local aTransTele:={} as array  // {{rownr aValuesTrans,nTransid},...}  : cross reference between aValuesTrans and corresponding generated aTrans
	local aStornoCodes:={"AC01","AC04","AC06","AG01","AG02","MD01","MS02","MD06","RC01","RR01"} as array   //Known SEPA storno codes
	local oAddInc as AddToIncExp
	local oStmnt as SQLStatement
	local oSel as SQLSelect
	local oMBal as Balances
	if Len(avalueTrans)=0
		return true
	endif
	// sort imported transactions on bookingdate 
	ASort(avalueTrans,,,{|x,y|x[2]<=y[2]})
	if lCheckPerson
		//
		// check if persid's belongs to persons
		//
		// aValuesTrans:
		// bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,adrline,country,bic,dueid,lv_rtrn,lv_eref,lv_marf,processed, 
		//      1            2        3          4           5      6           7      8      9        10        11       12     13    14    15    16      17      18     19
		cPersids:=Implode(avalueTrans,'","',,,11)
		if !Empty(cPersids)
			aPersidsDb:={}
			oSel:=SqlSelect{"select group_concat(cast(persid as char)) as grpersids from person where deleted=0 and persid in ("+cPersids+")",oConn}
			if oSel:Reccount>0 .and.!Empty(oSel:grpersids)
				aPersidsDb:=Split(oSel:grpersids,',')
			endif
			aPersids:=Split(cPersids,',')
			// compare both arrays 
			for i:=1 to Len(aPersids)
				cPersid:=aPersids[i]
				if AScanExact(aPersidsDb,cPersid)=0
					// remove persid from aValuesTrans: 
					j:=AScan(avalueTrans,{|x|x[11]==cPersid})
					if j>0
						avalueTrans[j,11]:='0'
					endif
				endif
			next
		endif
		aPersidsDb:=null_array  // clear 
		aPersids:=null_array	// clear
		if sepaEnabled 
			//	first	translate non-iban to iban	if	known	within system:
			i:=1 
			do	while	(i:=AScan(aValuesTrans,{|x|!Empty(x[4]) .and.	!IsIban(x[4])},i))>0 
				if Len((cBankAcctContr:=ZeroTrim(aValuesTrans[i,4])))<=7
					// giro:
					// convert to sepa: 
					if cBankAcctContr>'0' 
						cBankAcctContr:=  "INGB"+PadL(cBankAcctContr,10,"0")
						aValuesTrans[i,4]:= 'NL'+StrZero(IbanChecksum("NL00"+cBankAcctContr),2,0)+cBankAcctContr
					endif	   	
				else
					cBankAcctContr:= PadL(aValuesTrans[i,4],10,'0')
					if AScanExact(aBankContraNonIban,cBankAcctContr)=0
						AAdd(aBankContraNonIban, PadL(aValuesTrans[i,4],10,'0'))
					endif
					// 					cBankContrNotIBAN+=iif(Empty(cBankContrNotIBAN),'',',')+'"'++'"'
				endif
				i++ 
			enddo 
			if !Empty(aBankContraNonIban)
				oSel:=SqlSelect{"select group_concat(banknumber separator '#') as grbanknbrs from personbank where right(banknumber,10) in ("+Implode(aBankContraNonIban,'","')+')',oConn}
				if oSel:Reccount>0
					// replace bankaccounts with iban-bank accounts within aValueTrans:
					if !Empty(oSel:grbanknbrs) 
						aBankContra:=Split(oSel:grbanknbrs,'#')
						i:=1 
						do	while	(i:=AScan(aValuesTrans,{|x|!Empty(x[4]) .and.	!IsIban(x[4])},i))>0
							cBankAcctContr:=PadL(avalueTrans[i,4],10,'0')
							if (j:=AScan(aBankContra,{|x|Right(x,10)==cBankAcctContr}))>0 
								aValuesTrans[i,4]:=aBankContra[j] 
							endif
							i++ 
						enddo 
					endif			
				endif
				aBankContraNonIban:=null_array //clear
			endif
		endif
		//
		// complete persid from contrabankaccount:
		// 
		cBankContr:=Implode(avalueTrans,'","',,,4,,{|x|!Empty(x[4]).and.Val(x[11])=0}) 			
		aBankContra:={}
		if !Empty(cBankContr) 
			cStatement:="select group_concat(gr.banknumber,',',gr.grpersid,',',gr.ismember separator '#') as grpersids from (select cast(p.persid as char) as grpersid,banknumber,"+;
				"if(m.mbrid is null,'0','1') as ismember "+;
				"from personbank p left join member m on (m.persid=p.persid) where banknumber in ("+cBankContr+') ) as gr group by 1=1' 
			oSel:=SqlSelect{cStatement,oConn}
			if oSel:Reccount>0 
				// 				aBankCont:=Split(oSel:grpersids,'#') 
				if !Empty(oSel:grpersids)
					AEval(Split(oSel:grpersids,'#'),{|x|AAdd(aBankContra,Split(x,','))}) 
					i:=0
					do while i<Len(avalueTrans)
						i:=AScan(avalueTrans,{|x|!Empty(x[4]).and.Val(x[11])=0},i+1)
						if i>0
							cBankAcc:=avalueTrans[i,4] 
							j:=AScan(aBankContra,{|x|x[1]==cBankAcc})   
							if j>0
								if AScan(self:m57_bankacc,{|x|x[1]==cBankAcc})=0  // contra bank account is a own bank account?
									avalueTrans[i,11]:=iif(Empty(aBankContra[j,2]),'0',aBankContra[j,2])    // fill persid only when no cross bank account
								endif
							endif
						else
							exit
						endif
					enddo
				endif
			endif
		endif

	endif 
	if lCheckAccount
		//
		// check if budgetcd is an accountnumber of an account:
		//
		for i:=1 to Len(avalueTrans)
			cBudgetcd:=avalueTrans[i,7]
			if !Empty(cBudgetcd) .and. AScanExact(aBudgetcd,cBudgetcd)=0
				AAdd(aBudgetcd,cBudgetcd)
			endif
		next
		if Len(aBudgetcd)>0
			cBudgetcds:=Implode(aBudgetcd,'","')	
			oSel:=SqlSelect{"select group_concat(gr.accnumber) as graccnumber from (select accnumber from account where accnumber in ("+cBudgetcds+") ) as gr group by 1=1",oConn}
			if oSel:Reccount>0
				aAccnbrDb:=Split(oSel:graccnumber,',')
			endif
			oSel:=SqlSelect{"select group_concat(gr.accnumber) as graccnumber from (select accnumber from account as a, department as d where deptmntnbr in ("+cBudgetcds+") and a.accid=d.expenseacc ) as gr group by 1=1",oConn}
			if oSel:Reccount>0
				aAccnbrDbExp:=Split(oSel:graccnumber,',')
			endif
			oSel:=SqlSelect{"select group_concat(gr.accnumber) as graccnumber from (select accnumber from account as a, department as d where deptmntnbr in ("+cBudgetcds+") and a.accid=d.incomeacc ) as gr group by 1=1",oConn}
			if oSel:Reccount>0
				aAccnbrDbInc:=Split(oSel:graccnumber,',')
			endif
			// compare arrays 
			for i:=1 to Len(aBudgetcd)
				if (k:=AScan(aAccnbrDbExp,{|x|AtC(aBudgetcd[i],x)>0}))>0
					// replace all charges with expense account:
					j:=0
					do while (j:=AScan(avalueTrans,{|x|x[7]==aBudgetcd[i].and.x[9]=='A'},j+1))>0
						avalueTrans[j,7]:= aAccnbrDbExp[k]
						if j>=Len(avalueTrans)
							exit
						endif
					enddo
				endif
				if (k:=AScan(aAccnbrDbInc,{|x|AtC(aBudgetcd[i],x)>0}))>0
					// replace all gifts with income account:
					j:=0
					do while (j:=AScan(avalueTrans,{|x|x[7]==aBudgetcd[i].and.x[9]=='B'},j+1))>0
						avalueTrans[j,7]:= aAccnbrDbInc[k]
						if j>=Len(avalueTrans)
							exit
						endif
					enddo
				endif
				if AScanExact(aAccnbrDb,aBudgetcd[i])=0
					
					// remove remaining budgetcd from aValuesTrans:
					j:=0
					do while (j:=AScan(avalueTrans,{|x|x[7]==aBudgetcd[i]},j+1))>0
						avalueTrans[j,7]:='0'
						if j>=Len(avalueTrans)
							exit
						endif
					enddo
				endif
			next								
		endif
		// use dueid to complement accnumber of corresponding destination:
		for i:=1 to Len(avalueTrans)
			cDueid:=avalueTrans[i,15]
			if !Empty(cDueid) 
				if AScanExact(aDueid,cDueid)=0
					AAdd(aDueid,cDueid)
				endif
				if aValueTrans[i,9]=='B'
					fDirecDebit:=Round(fDirecDebit+avalueTrans[i,8],2)
				endif
			endif
		next
		if sepaEnabled
			if Len(aDueid)>0
				cDueids:=Implode(aDueid,'","')
				aAccnbrDue:={}
				oSel:=SqlSelect{"select cast(group_concat(gr.accnumber,'#$#',gr.dueid,'#$#','0','#$#','0' separator '#%#') as char) as graccnumbers from (select accnumber,dueid from account a,subscription s,dueamount d where d.subscribid=s.subscribid and a.accid=s.accid and d.dueid in ("+cDueids+") ) as gr group by 1=1",oConn}
				if oSel:Reccount>0 .and.!Empty(oSel:graccnumbers)
					AEval(Split(oSel:graccnumbers,'#%#'),{|x|AAdd(aAccnbrDue,Split(x,'#$#')) }) 
					if Len(aAccnbrDue)>0
						// insert accnumber in storno's:
						for i:=1 to Len(aAccnbrDue)
							j:=0
							do while (j:=AScan(avalueTrans,{|x|x[15]==aAccnbrDue[i,2]},j+1))>0
								avalueTrans[j,7]:=aAccnbrDue[i,1]
								if avalueTrans[j,16]=='MD01' .or. AtC('MD01',avalueTrans[j,10])>0
									aAccnbrDue[i,3]:='1'  // mark as mandate invalid
								endif   
								if !Empty(avalueTrans[j,16]).and. AScan(aStornoCodes,avalueTrans[j,16])>0 .or. FindKeyString(aStornoCodes,avalueTrans[j,10])
									aAccnbrDue[i,4]:='1'  // mark subscription as blocked
								endif
								if j>=Len(avalueTrans)
									exit
								endif
							enddo
						next
					endif
				endif
			endif
		endif
	endif
	//
	// complete budgetcodes from gifts to single destinations and gifts patterns:  
	//
	i:=0
	lv_description:=self:oLan:WGet('Gift') 
	do while i<Len(avalueTrans)
		// aValuesTrans:
		// bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,adrline,country,bic,dueid,processed 
		//      1            2        3          4           5      6           7      8      9        10        11       12     13    14    15    16
		i:=AScan(avalueTrans,{|x|Empty(x[7]) .and.x[9]='B'},i+1)
		if i>0
			cBankAcc:=avalueTrans[i,1] 
			//m57_bankacc: banknumber, usedforgifts, datlaatst, giftsall,singledst,destname,accid,payahead,singlenumber,fgmlcodes,syscodover
			//                 1            2           3          4         5          6      7      8           9		  10           11
			// 			j:=AScan(self:m57_bankacc,{|x|x[1]==cBankAcc.and.(x[9]>'0'.or.x[4])})
			j:=AScan(self:m57_bankacc,{|x|x[1]==cBankAcc})
			if j>0
				if self:m57_bankacc[j,9]>'0' 							
					avalueTrans[i,7]:=self:m57_bankacc[j,9]
				else
					// save persid for analysing gifts pattern:
					cPersid:=avalueTrans[i,11] 
					if !Empty(cPersid).and.Val(cPersid)>0
						AAdd(aValueSubPtr,i)  // save pntr into avalueTrans
						if AScanExact(aSubPersids,cPersid)=0
							AAdd(aSubPersids,cPersid)
						endif
					endif
				endif
			endif
		else
			exit
		endif
	enddo
	if Len(aSubPersids)>0
		// Lookup gift patterns: 
		oSel:=SqlSelect{"select group_concat(persid,'#$#',subsc separator '#%#') as subscrs from "+; 
		"(select cast(personid as char) as persid,group_concat(a.accnumber,'&&',cast(amount as char)  separator '$$') as subsc from subscription s, account a "+;
			"where category='G' and s.accid=a.accid and personid in ("+Implode(aSubPersids,'","')+") group by personid order by personid) as sub",oConn}
		// 		oSel:=SqlSelect{"select group_concat(cast(personid as char),'#$#',cast(accid as char),'#$#',cast(amount as char) order by personid separator '#%#') as subscrs from subscription where category='G' and personid in ("+Implode(aSubPersids,',')+")",oConn}
		if oSel:Reccount>0 .and.!Empty(oSel:subscrs) 
			AEval(Split(oSel:subscrs,'#%#'),{|x|AAdd(aSubscr,Split(x,'#$#')) }) 
			for i:=1 to Len(aSubscr)
				aSub:=aevala(Split(aSubscr[i,2],'$$'),{|x|split(x,'&&')})
				AAdd(aSubscrtn,{aSubscr[i,1],aSub})
			next
			aSub:=null_array
			aSubscr:=null_array
			aSubPersids:=null_array	
			// add destinations from gift patterns:
			for i:=1 to Len(aValueSubPtr) 
				// aValuesTrans:
				// bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,adrline,country,bic,dueid,processed 
				//      1            2        3          4           5      6           7      8      9        10        11       12     13    14    15    16
				k:= aValueSubPtr[i]
				cPersid:=avalueTrans[k,11]
				if (j:=AScan(aSubscrtn,{|x|x[1]==cPersid}))>0
					if (l:=AScan(aSubscrtn[j,2],{|x|Val(x[2])== avalueTrans[k,8]}))>0
						if l<Len(aSubscrtn[j,2])
							// more left:
							if AScan(aSubscrtn[j,2],{|x|Val(x[2])== avalueTrans[k,8]},l+1) = 0
								// only one with same amount:
								avalueTrans[k,7]:=aSubscrtn[j,2,l,1]
							endif
						else
							// only one with same amount:
							avalueTrans[k,7]:=aSubscrtn[j,2,l,1]							
						endif
					elseif self:CheckPattern(avalueTrans[k,4] ,avalueTrans[k,5],avalueTrans[k,6], avalueTrans[k,9],avalueTrans[k,10])
						// lookup telebankpattern 
						if self:m56_autmut
							avalueTrans[k,7]:=self:m56_accnumber
						endif
					endif
				elseif self:CheckPattern(avalueTrans[k,4] ,avalueTrans[k,5],avalueTrans[k,6], avalueTrans[k,9],avalueTrans[k,10])
					// lookup telebankpattern 
					if self:m56_autmut
						avalueTrans[k,7]:=self:m56_accnumber
					endif
				endif
			next
			aSubscrtn:=null_array
			aValueSubPtr:=null_array
		endif
	endif
	// find accid for banknumbers in array with bank account balances aValuesBal
	if !Empty(self:avaluesBal)
		for i:=1 to Len(self:avaluesBal)
			cBankAcc:=AllTrim(self:avaluesBal[i,1])
			j:=AScan(self:m57_bankacc,{|x|x[1]==cBankAcc})
			if j>0							
				self:avaluesBal[i,1]:=self:m57_bankacc[j,7]
				self:aValuesBal[i,2]:=SQLdate(self:aValuesBal[i,2])
			else
				ADel(self:avaluesBal,i)
				ASize(self:avaluesBal,Len(self:aValuesBal)-1) 
				i--
			endif
		next
	endif
	// Check telebankpatterns for non-gifts:
	i:=0
	do while i<Len(avalueTrans)
		i:=AScan(avalueTrans,{|x|Empty(x[7]) .and.(x[9]='A' .or.Empty(x[11])) },i+1)
		if i=0
			exit
		endif
		if self:CheckPattern(avalueTrans[i,4] ,avalueTrans[i,5],avalueTrans[i,6], avalueTrans[i,9],avalueTrans[i,10])
			// lookup telebankpattern 
			if self:m56_autmut
				avalueTrans[i,7]:=self:m56_accnumber
			endif
		endif
	enddo	
	// 	CollectForced() 
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	//      
	// select bank transactions which can be processed automatically 
	//
	///////////////////////////////////////////////////////////////////////////////////////////////////////// 
	// get accid of budgetcd's
	for i:=1 to Len(avalueTrans)
		cBudgetcd:=avalueTrans[i,7]
		if !Empty(cBudgetcd) .and. AScanExact(aBudgetcd,cBudgetcd)=0
			AAdd(aBudgetcd,cBudgetcd)
		endif
	next
	if Len(aBudgetcd)>0
		cBudgetcds:=Implode(aBudgetcd,'","')	
		oSel:=SqlSelect{"select group_concat(gr.accnumber,',',gr.graccid,',',gr.ismember,',',gr.grpersid,',',gr.incomeacc,',',gr.expenseacc,',',gr.netasset separator '#') as graccnumber "+;
			"from (select a.accnumber,cast(a.accid as char) as graccid,if(m.mbrid IS NULL,'0','1') as ismember,cast(COALESCE(m.persid,0) as char) as grpersid, "+;
			"cast(COALESCE(d.incomeacc,0) as char) as incomeacc,cast(COALESCE(d.expenseacc,0) as char) as expenseacc,cast(COALESCE(d.netasset,0) as char) as netasset "+;
			"from account a left join department d on (d.depid=a.department) "+;
			"left join member as m on (a.accid=m.accid or m.depid=d.depid and (d.incomeacc=a.accid or d.expenseacc=a.accid or d.netasset=a.accid)) "+; 
		" where accnumber in ("+cBudgetcds+") ) as gr group by 1=1",oConn}
		if oSel:Reccount>0
			aAccnbrDb:={}  
			// aAccnbrDb: {{accnumber, accid, ismember, member persid, incomeacc,expenseacc,netasset)
			AEval(Split(oSel:graccnumber,'#'),{|x|AAdd(aAccnbrDb,Split(x,','))})
		endif 
		// determine fund accounts of members for PF transactions:
		oSel:=SqlSelect{"select group_concat(gr.graccid,',',gr.grpersid separator '#') as graccnumber "+;
			"from (select cast(d.netasset as char) as graccid,cast(m.persid as char) as grpersid "+;
			"from member as m, department d "+;
			" where m.depid=d.depid  ) as gr group by 1=1",oConn}
		if oSel:Reccount>0
			AEval(Split(oSel:graccnumber,'#'),{|x|AAdd(aAccnbrDbFund,Split(x,','))})   //aAccnbrDbFund: {{accid, persid}...}
		endif
		aBudgetcd:=null_array  // clear
	endif
	if !Empty(SINCHOME) .or.!Empty(SINC)
		// prepare for add transactions for ministry income/expense:
		oAddInc:=AddToIncExp{}
	endif

	// GIFTS:
	if (k:=AScan(avalueTrans,{|x|!Empty(x[7]).and.Val(x[11])>0 .and.x[9]='B'}))>0  // gifts with known destination and giver?
		if CountryCode="31"
			//	get postal codes of persons into array aZip {persid,zipcoce},...  to determine if address has been changed
			cPersids:=''
			do	while	k>0
				cPersids+=','+avalueTrans[k,11]
				if k<Len(avalueTrans)
					k:=AScan(avalueTrans,{|x|!Empty(x[7]).and.Val(x[11])>0 .and.x[9]='B'},k+1)
				else
					exit
				endif
			enddo
			// 				oSel:=SqlSelect{"select	group_concat(gr.grpersid,',',postalcode,',',address separator	'#') as grpersids	from (select cast(persid as char) as grpersid,postalcode,address from person	where	persid in ("+SubStr(cPersids,2)+") and deleted=0) as gr group by 1=1",oConn}
			oSel:=SqlSelect{"select	group_concat(gr.grpersid,',',postalcode,',',address separator '#') as grpersids	from (select cast(persid as char) as grpersid,postalcode,address from person	where	persid in ("+SubStr(cPersids,2)+") and deleted=0) as gr group by 1=1",oConn}
			if	oSel:Reccount>0 
				aZip:={}
				AEval(Split(oSel:grpersids,'#'),{|x|AAdd(aZip, Split(x,','))})
			endif
		endif
		i:=0
		do while i<Len(avalueTrans)
			i:=AScan(avalueTrans,{|x|!Empty(x[7]).and.Val(x[11])>0 .and.x[9]='B'},i+1)
			if i=0
				exit
			endif
			cBankAcc:=avalueTrans[i,1]
			
			//m57_bankacc: banknumber, usedforgifts, datelatest, giftsall,singledst,destname,accid,payahead,singlenumber,fgmlcodes,syscodover
			//                 1            2           3          4         5          6      7      8          9          10        11
			// aValuesTrans:
			// bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,adrline,country,bic,dueid,processed 
			//      1            2        3          4           5      6           7      8      9        10        11       12     13    14    15    16
			j:=AScan(self:m57_bankacc,{|x|x[1]==cBankAcc})
			if j>0							
				if self:m57_bankacc[j,4].or.; // giftsall, i.e. automatic processing of all gifts? 
					!self:m57_bankacc[j,2] .or.; // not used for gifts but credit amount from a giver coming in
					self:m57_bankacc[j,2] .and. ;   // used for gifts
					((self:m57_bankacc[j,8]>'0' .and.	(aValueTrans[i,5]='ACC'.or.aValueTrans[i,5]='KID'.or.aValueTrans[i,5]='COL')).or.;  // payahead filled for acceptgiro
					(Trim(aValueTrans[i,5])="AC" .or.(SubStr(aValueTrans[i,10],17,2)=="AC").and.isnum(SubStr(aValueTrans[i,10],1,16))))

					lv_persid:=avalueTrans[i,11]
					if Val(lv_persid)>0
						if !CountryCode=="31" .or.;
								!SpecialMessage(avalueTrans[i,10], self:m57_bankacc[j,6],@lv_specmessage)  // with special message manually processed
							lAddressChanged:=false
// 							if (CountryCode=="31" .or.avalueTrans[i,13]=='NL') ;  
// 								.and. !(Empty(avalueTrans[i,10]) .and.Empty(avalueTrans[i,12]))
// 								// check no address change
// 								k:=AScan(aZip,{|x|x[1]==lv_persid})
// 								if k>0
// 									lv_address:=avalueTrans[i,10] 
// 									if (nAddrEnd:=At('%%',lv_address))=0
// 										if (nAddrEnd:=AtC('EndToEnd',lv_address))=0
// 											nAddrEnd:=Len(lv_address)+1
// 										endif
// 									endif  
// 									lv_address:=AllTrim(SubStr(lv_address,1,nAddrEnd-1))
// 									if !(Empty(avalueTrans[i,12]) .and.Empty(lv_address))
// 										self:GetAddress(iif(Empty(avalueTrans[i,12]),lv_address,avalueTrans[i,12]),false)
// 										if !Empty(self:m56_zip) .and.Len(self:m56_zip)>=7 .and.!Empty(self:m56_town)
// 											// 											IF !self:m56_zip==aZip[k,2] .and.!Empty(aZip[k,2]) 
// 											IF !self:m56_zip==aZip[k,2] 
// 												lAddressChanged:=true
// 											ENDIF
// 										elseif Len(self:m56_address)>1 .and.!Lower(self:m56_address)==Lower(aZip[k,3])  .and.!Empty(self:m56_town)
// 											aAddr:=GetStreetHousnbr(self:m56_address)
// 											aAddrDB:=GetStreetHousnbr(aZip[k,3])
// 											if !Val(aAddr[2])==Val(aAddrDB[2])      // unequal housenumbers-> moved
// 												lAddressChanged:=true
// 											endif
// 										endif
// 										if Empty(avalueTrans[i,12]) .and.!(Empty(self:m56_zip).and.Empty(self:m56_town))
// 											aValuesTrans[i,12]:=self:m56_address+' '+self:m56_zip+' '+self:m56_town  // as determined by getaddress
// 										endif
// 									endif
// 								endif
// 							endif
							if !lAddressChanged 
								cBudgetcd:=avalueTrans[i,7] 
								// aAccnbrDb: {{accnumber, accid, ismember, member persid, incomeacc,expenseacc,netasset) 
								//                 1          2       3         4              5          6         7
								if (l:=AScan(aAccnbrDb,{|x|x[1]==cBudgetcd}))>0
									avalueTrans[i,19]:='X'   // record as processed 
									lv_accid:=aAccnbrDb[l,2]
									// transaction can be processed automatically:
									nProc++ 
									
									// add to transaction array:
									//aTrans: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
									//          1    2     3      4      5      6            7      8   9  10      11         12    13     14       15     16    17     18
									// first row: 
									cBankAccOwn:=self:m57_bankacc[j,7]
									if self:m57_bankacc[j,8]>'0' .and.	(aValueTrans[i,5]='ACC'.or.aValueTrans[i,5]='KID'.or.aValueTrans[i,5]='COL')  // acceptgiro
										cBankAccOwn:=self:m57_bankacc[j,8]
									endif
									if aAccnbrDb[l,3]='1'  //destination member?
										lv_gc:='AG'
										if lv_accid==aAccnbrDb[l,6]   // expense account?
											lv_gc:='CH'
										elseif lv_accid==aAccnbrDb[l,7]  // net asset account?
											lv_gc:='PF'
										else											
											//aBankContra: {{bankacc,persid,ismember},...}
											if AScan(aBankContra,{|x|x[2]==lv_persid .and.x[3]='1'})>0    // giver member? 
												// gift from member self?:
												if aAccnbrDb[l,4]==lv_persid
													// personal fund:
													lv_gc:='PF'
													// replace destination by fund account: 
													//aAccnbrDbFund: {{ accid, persid}...}
													if (m:=AScan(aAccnbrDbFund,{|x|x[2]==lv_persid}))>0 
														lv_accid:=aAccnbrDbFund[m,1]
													endif
												else
													lv_gc:='MG'
												endif
											endif
										endif
									else
										lv_gc:=''
									endif
									nTransId++
									AAdd(aTrans,{cBankAccOwn,avalueTrans[i,8],avalueTrans[i,8],0.00,0.00,sCurr,iif(!lv_gc=='PF',lv_description,'')+' ('+aValuesTrans[i,6]+ iif(Len(aValuesTrans[i,4])>60,' ',' ('+aValuesTrans[i,4]+') ')+;
										+aValuesTrans[i,10]+', '+aValuesTrans[i,12]+')',;
										avalueTrans[i,2],'',LOGON_EMP_ID,'2','1',avalueTrans[i,5]+avalueTrans[i,3],'','0','0','',Str(nTransId,-1)} )
									AAdd(aTransTele,{i,nTransId}) 
									// second row: 
									AAdd(aTrans,{lv_accid,0.00,0.00,aValueTrans[i,8],aValueTrans[i,8],sCurr,iif(!lv_gc=='PF',lv_description,'')+iif(aValueTrans[i,5]="AC",'',' '+lv_specmessage),;
										avalueTrans[i,2],lv_gc,LOGON_EMP_ID,'2','2',avalueTrans[i,5]+avalueTrans[i,3],'',Str(Val(avalueTrans[i,11]),-1),'0','',Str(nTransId,-1)} )
									// person data:
									AAdd(avaluesPers,{lv_persid,avalueTrans[i,2]}) 
								endif
							endif
						endif
					endif
				endif
			endif
		enddo
	endif
	aBankContra:=null_array  //clear
	aAccnbrDbFund:=null_array  //clear 
	aZip:=null_array
	
	// NON-GIFTS:
	// aValuesTrans:
	// bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,adrline,country,bic,dueid,processed 
	//      1            2        3          4           5      6           7      8      9        10        11       12     13    14    15     16       
	i:=0
	do while i<Len(avalueTrans) 
		// 		i:=AScan(avalueTrans,{|x|(Val(x[11])=0 .or.(x[9]='A' .and.!x[5]='COL')) .and.!x[16]='X'},i+1)   // non-gifts or person unknown and no storno's  
		i:=AScan(avalueTrans,{|x|(Val(x[11])=0 .or.x[9]='A')  .and.!x[16]='X'},i+1)   // non-gifts or person unknown and no storno's  
		if i=0                //          !Empty(x[4]).or.!Empty(x[7]))
			exit
		endif
		cBankAcc:=avalueTrans[i,1] 
		//m57_bankacc: banknumber, usedforgifts, datelatest, giftsall,singledst,destname,accid,payahead,singlenumber,fgmlcodes,syscodover
		//                 1            2           3          4         5          6      7      8          9          10        11
		j:=AScan(self:m57_bankacc,{|x|x[1]==cBankAcc})
		if j>0							
			lProcAuto:=false
			lv_gc:=''
			if aValueTrans[i,4]>='01' .and.Empty(aValueTrans[i,7])   // contra_bankaccnt but no budgetcd
				// check if cross banking?
				IF !Empty(SKruis)
					cBankAcc:=avalueTrans[i,4] 
					// 					k:=AScan(self:m57_bankacc,{|x|x[1]==cBankAcc})  
					if !sepaEnabled .or. IsIban(cBankAcc)
						k:=AScanExact(self:bankacc,cBankAcc)   // is a bank account?
					else
						if Len(cBankAcc)<10
							cBankAcc:=PadL(cBankAcc,10,'0')
						endif
						k:=AScan(self:bankacc,{|x|Right(x,Len(cBankAcc))==cBankAcc})
					endif
					if k>0 
						// cross banking:
						cDestAcc:=SKruis
						if Empty(aValueTrans[i,10]) .or. aValueTrans[i,5]=='FL'  // empty description?
							avalueTrans[i,10]:='Cash Balancing'
						endif
						lProcAuto:=true
					endif
				endif
			elseif avalueTrans[i,5]='COL'.and.avalueTrans[i,9]=='A' .and.!Empty(avalueTrans[i,7]) .and.!Empty(avalueTrans[i,11]).and.!Empty(avalueTrans[i,15])
				// reversal of direct debit:
				cBudgetcd:=avalueTrans[i,7]
				// aAccnbrDb: {{accnumber, accid, ismember, member persid, incomeacc,expenseacc,netasset)
				if (l:=AScan(aAccnbrDb,{|x|x[1]==cBudgetcd}))>0
					cDestAcc:=aAccnbrDb[l,2]
					if aAccnbrDb[l,3]='1'  // is member
						lv_gc:='AG'
					endif
					lProcAuto:=true
				endif
			elseif !Empty(aValueTrans[i,7]).and.(self:m57_bankacc[j,8]>'0' .and.	aValueTrans[i,5]=='CLR';  // payahead filled for collective recording of acceptgiro's
				.or.avalueTrans[i,9]=='A') //debit with known destination?
				cBudgetcd:=avalueTrans[i,7]
				if (l:=AScan(aAccnbrDb,{|x|x[1]==cBudgetcd}))>0
					// aAccnbrDb: {{accnumber, accid, ismember, member persid, incomeacc,expenseacc,netasset)
					cDestAcc:=aAccnbrDb[l,2]
					if aAccnbrDb[l,3]='1'  // is member
						if !Empty(avalueTrans[i,11])  // giver connected?
							lv_gc:='CH'
							if cDestAcc==aAccnbrDb[l,5]   // income account?
								lv_gc:='AG'
							elseif cDestAcc==aAccnbrDb[l,7]  // net asset account?
								lv_gc:='PF'
							endif											
							lProcAuto:=true
						endif
					else
						lProcAuto:=true
					endif
				endif
			ELSEIF (aValueTrans[i,5]=="IC" .or.aValueTrans[i,5]="COL" .or.aValueTrans[i,5]=="OCR") .and.aValueTrans[i,4]<'01' .and.aValueTrans[i,9] =="B" .and.self:m57_bankacc[j,8]>'0'  // payahead for OCR
				// in case of recording of automatic collections take payahead as contra account:
				cDestAcc:=self:m57_bankacc[j,8]
				lProcAuto:=true 
			elseif !Empty(SKruis) .and. AtC('SUMMER INSTITUTE',avalueTrans[i,6])>0 // or transfer to RIA?
				// cross banking:
				cDestAcc:=SKruis
				lProcAuto:=true
			elseif aValueTrans[i,5]=="587" .and.aValueTrans[i,9] =="A" .and. self:m57_bankacc[j,8]>'0'  //payahead 
				// eurobetaling batch
				// check if amount avalueTrans[i,8] on date aValueTrans[i,2] found in payahead self:m57_bankacc[j,8] transaction  
				oSel:=SqlSelect{"select Count(*) from transaction where accid="+self:m57_bankacc[j,8]+" and docid='SEPACT' and cre="+Str(avalueTrans[i,8],-1)+" and dat between '"+avalueTrans[i,2]+"' and '"+SQLdate(SQLDate2Date(avalueTrans[i,2])+4)+"'",oConn} 
				if oSel:Reccount=1
					cDestAcc:=self:m57_bankacc[j,8]
					lProcAuto:=true 
				endif
			endif
			if lProcAuto
				avalueTrans[i,19]:='X'   // record as processed 
				// transaction can be processed automatically:
				nProc++ 
				
				// add to transaction array:
				//aTrans: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
				//          1    2     3      4      5      6            7      8   9  10      11         12    13     14       15     16     17   18
				// first row: 
				cBankAccOwn:=self:m57_bankacc[j,7]
				lv_persid:=''
				if avalueTrans[i,9]='B'
					fDeb:=avalueTrans[i,8]
					fDebForgn:=avalueTrans[i,8]
					fCre:=0.00
					fCreForgn:=0.00
					if avalueTrans[i,11]>'0' 
						lv_persid:=avalueTrans[i,11] 
					endif
				else
					fDeb:=0.00
					fDebForgn:=0.00
					fCre:=avalueTrans[i,8]
					fCreForgn:=avalueTrans[i,8]
					if avalueTrans[i,15]>'0'  // reversal of direct debit
						lv_persid:=avalueTrans[i,11] 						
					endif 
				endif 
				nTransId++
				AAdd(aTrans,{cBankAccOwn,fDeb,fDebForgn,fCre,fCreForgn,sCurr,AllTrim(avalueTrans[i,6]+;
					iif(Empty(avalueTrans[i,4]).or.Len(aValuesTrans[i,4])>60,'',' ('+avalueTrans[i,4]+') ')+' '+avalueTrans[i,10]),;  // contra name + contra bank account as description
				aValueTrans[i,2],'',LOGON_EMP_ID,'2','1',aValueTrans[i,5]+aValueTrans[i,3],'','0','0','',str(nTransId,-1)} ) 
				AAdd(aTransTele,{i,nTransId}) 
				// second row: 
				AAdd(aTrans,{cDestAcc,fCre,fCreForgn,fDeb,fDebForgn,sCurr,AllTrim(avalueTrans[i,6]+' '+avalueTrans[i,10]),;
					aValueTrans[i,2],lv_gc,LOGON_EMP_ID,'2','2',aValueTrans[i,5]+aValueTrans[i,3],'',str(Val(lv_persid),-1),'0','',str(nTransId,-1)} )
			endif
		endif
	enddo
	aBudgetcd:=null_array  //clear   
	aAccnbrDb:=null_array

	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// Execute database statements
	//
	//////////////////////////////////////////////////////////////////////////////////////////////////////////           
	
	if Len(aTrans)>0
		if !Empty(SINCHOME) .or.!Empty(SINC)
			// add transactions for ministry income/expense:
			for i:=2 to Len(aTrans) step 2
				nSeqnbr:=2 
				aTransIncExp:=oAddInc:AddToIncome(aTrans[i,9],false,aTrans[i,1],aTrans[i,4],aTrans[i,2],aTrans[i,3],aTrans[i,5],aTrans[i,6],;
					aTrans[i,7],aTrans[i,15],aTrans[i,8],aTrans[i,13],@nSeqnbr,aTrans[i,11],aTrans[i,18]) 
				if Len(aTransIncExp)=2
					asize(aTrans,len(aTrans)+2)
					i++
					AIns(aTrans,i)
					aTrans[i]:=aTransIncExp[1]
					i++
					AIns(aTrans,i)
					aTrans[i]:=aTransIncExp[2]
				endif
			next		
		endif 
		oMBal:=Balances{}
		for i:=1 to Len(aTrans) 
			//  1    2      3     4     5        6          7       8   9   10        11      12    13      14       15    16     17   18
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
			oMBal:ChgBalance(aTrans[i,1],SQLDate2Date(aTrans[i,8]),aTrans[i,2],aTrans[i,4],aTrans[i,3],;
				aTrans[i,5],aTrans[i,6],ConI(aTrans[i,11]))
		next
		
	endif	
	// 	cDueids:=Implode(aAccnbrDue,",",,,2)
	oStmnt:=SQLStatement{"set autocommit=0",oConn}
	oStmnt:execute()
	oStmnt:=SQLStatement{'lock tables '+iif(Len(self:avaluesBal)>0,'`bankbalance` write,','')+',`dueamount` write'+;
		iif(Empty(cFilename),'','`log` write,')+iif(Len(avaluesPers)>0,'`person` write,','')+;
		iif(Len(aTrans)>0,'`mbalance` write,','')+iif(Len(aAccnbrDue)>0,',`subscription` write','')+'`teletrans` write'+iif(Len(aTrans)>0,',`transaction` write',''),oConn}        // alphabetic order
	oStmnt:execute()
	maxTeleId:=ConI(SqlSelect{"select max(teletrid) as maxtele from teletrans",oConn}:maxtele)
	oStmnt:=SQLStatement{"insert IGNORE into teletrans "+;
		"(bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,adrline,country,bic,dueid,rtrn,eref,marf,processed) values "+;
		Implode(avalueTrans,'","'),oConn} 
	oStmnt:execute()
	if !Empty(oStmnt:Status)
		SQLStatement{"rollback",oConn}:execute()
		SQLStatement{"unlock tables",oConn}:execute()
		avalueTrans:={}
		LogEvent(self,oStmnt:SQLString+CRLF+"Error:"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
		ErrorBox{,self:oLan:WGet('Telebank transactions could not be imported')+":"+oStmnt:ErrInfo:ErrorMessage}:show()
		return false 
	endif
	nTele:=oStmnt:NumSuccessfulRows 
	// insert bank balances:
	if !Empty(self:avaluesBal)
		oStmnt:=SQLStatement{"insert into bankbalance (accid,datebalance,balance) values "+Implode(self:avaluesBal,'","')+;
			" ON DUPLICATE KEY UPDATE balance=values(balance)",oConn}
		oStmnt:execute()
		if	!Empty(oStmnt:Status)
			SQLStatement{"rollback",oConn}:execute() 
			SQLStatement{"unlock tables",oConn}:execute()
			LogEvent(self,"error:"+oMBal:cError,"LogErrors")
			ErrorBox{,self:oLan:WGet("bank balances could not be updated")+":"+oStmnt:ErrInfo:ErrorMessage}:show()
			self:aValuesTrans:={}
			return false 
		endif
	endif

	if nTele>0 .and.Len(aTrans)>0  .and. nTele<Len(avalueTrans) 
		// remove transactions to be stored from ingnored teletrans transactions: 
		self:nDuplicate+=(Len(avalueTrans)-nTele)
		nProc:=0
		// teletransactions ignored: which ones?
		oSel:=SqlSelect{"select seqnr,amount,bankaccntnbr,cast(bookingdate as date) as bookingdate,kind,contra_bankaccnt,"+; 
		"addsub,description,contra_name "+;
			"from teletrans where processed='X' and teletrid>"+Str(maxTeleId,-1),oConn}
		if oSel:Reccount>0
			// compare with aValueTrans:
			// aValuesTrans:
			// bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,adrline,country,bic,dueid,processed 
			//      1            2        3          4           5      6           7      8      9        10        11       12     13    14    15    16
			nProc:=oSel:Reccount         // recount automatic processed transactions
			do while !oSel:EoF
				// search imported avaluetrans:
				if (i:=AScan(avalueTrans,{|x|x[16]=='X'.and.x[1]==oSel:bankaccntnbr.and.x[2]==SQLdate(oSel:bookingdate).and.x[3]==ConS(oSel:seqnr).and.;
						x[4]==oSel:contra_bankaccnt.and.x[5]==oSel:kind.and.x[6]==AddSlashes(oSel:contra_name).and.;
						ConS(x[8])==ConS(oSel:amount).and.x[9]==oSel:addsub.and.x[10]==AddSlashes(oSel:Description)}))>0 
					// mark aValuesTrans as imported: 
					avalueTrans[i,19]:='I'
				endif 
				oSel:Skip()
			enddo
			// remove corresponding aTrans of ignored teletrans:			  
			k:=0
			do while (k:=AScan(avalueTrans,{|x|x[19]=='X'},k+1))>0
				i:=AScan(aTransTele,{|x|x[1]==k})
				if i>0    // corresponding aTrans? remove them
					j:=1
					cTransid:=Str(aTransTele[i,2],-1)
					do while j>0 .and. j<=Len(aTrans)
						if (j:=AScan(aTrans,{|x|x[18]==cTransid},j))>0
							ADel(aTrans,j)
							ASize(aTrans,Len(aTrans)-1) 
						else
							exit
						endif   
					enddo 
					// remove also corresponding dueid from direct debit reversals:
					if avalueTrans[k,15]>'0' .and. Len(aAccnbrDue)>0
						if (j:=AScan(aAccnbrDue,{|x|x[2]==avalueTrans[k,15]}))>0
							ADel(aAccnbrDue,j)
							ASize(aAccnbrDue,Len(aAccnbrDue)-1)
						endif
						if (j:=AScan(aDueid,{|x|x==avalueTrans[k,15]}))>0
							ADel(aDueid,j)
							ASize(aDueid,Len(aDueid)-1)
						endif
						
					endif
				endif 
			enddo
			// 			cDueids:=Implode(aAccnbrDue,",",,,2)
			// setup again chgbalance:
			oMBal:=Balances{}
			for i:=1 to Len(aTrans) 
				//  1    2      3     4     5        6          7       8   9   10        11      12    13      14       15    16     17   18
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
				oMBal:ChgBalance(aTrans[i,1],SQLDate2Date(aTrans[i,8]),aTrans[i,2],aTrans[i,4],aTrans[i,3],;
					aTrans[i,5],aTrans[i,6],ConI(aTrans[i,11]))
			next
		endif
	endif
	if nTele>0 .and.Len(aTrans)>0  // telebank transactions imported?
		// insert autmaticallly processed transactions:
		// insert first line:
		oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp) "+;
			" values ("+Implode(aTrans[1],"','",1,17)+')',oConn}
		oStmnt:execute()
		nTransId:=ConI(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
		aTrans[2,18]:=nTransId
		for i:=3 to Len(aTrans) step 2
			// next line income/expense?
			if aTrans[i,12]=='3'
				aTrans[i,18]:=nTransId
				aTrans[i+1,18]:=nTransId
				i+=2
			endif		
			nTransId++
			if i<Len(aTrans)
				aTrans[i,18]:=nTransId
				aTrans[i+1,18]:=nTransId
			endif
		next
		oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid) "+;
			" values "+Implode(aTrans,"','",2),oConn}
		oStmnt:execute()
		if oStmnt:NumSuccessfulRows<1
			SQLStatement{"rollback",oConn}:execute() 
			SQLStatement{"unlock tables",oConn}:execute()
			LogEvent(self,self:oLan:WGet('Transactions could not be inserted')+":"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
			ErrorBox{,self:oLan:WGet('Transactions could not be inserted')+":"+oStmnt:ErrInfo:ErrorMessage}:show()
			self:aValuesTrans:={}
			return false 
		endif
		// adapt mbalance values:
		if !oMBal:ChgBalanceExecute()
			SQLStatement{"rollback",oConn}:execute() 
			SQLStatement{"unlock tables",oConn}:execute()
			LogEvent(self,self:oLan:WGet('Month balances could not be updated')+":"+oMBal:cError,"LogErrors")
			ErrorBox{,self:oLan:WGet('Month balances could not be updated')+":"+oMBal:cError}:show()
			self:aValuesTrans:={}
			return false 
		endif
		//	update person data of givers: 
		if Len(avaluesPers)>0
			oStmnt:=SQLStatement{"insert into person (persid,datelastgift)	values "+Implode(avaluesPers,'","')+;
				" ON DUPLICATE	KEY UPDATE datelastgift=if(values(datelastgift)>datelastgift,values(datelastgift),datelastgift)	",oConn}
			oStmnt:execute()
			if	!Empty(oStmnt:Status)
				SQLStatement{"rollback",oConn}:execute() 
				SQLStatement{"unlock tables",oConn}:execute()
				LogEvent(self,self:oLan:WGet('persons could not be updated')+":"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
				ErrorBox{,self:oLan:WGet('persons could not be updated')+":"+oStmnt:ErrInfo:ErrorMessage}:show()
				self:aValuesTrans:={}
				return false 
			endif
		endif
		// update dueamounts because of direct debit reversals:
		if Len(aAccnbrDue)>0
			cDueids:=Implode(aAccnbrDue,'","',,,2)
			oStmnt:=SQLStatement{"update dueamount set amountrecvd:=0.00 where dueid in ("+cDueids+")",oConn}
			oStmnt:execute()
			if	!Empty(oStmnt:Status)
				SQLStatement{"rollback",oConn}:execute() 
				SQLStatement{"unlock tables",oConn}:execute()
				LogEvent(self,self:oLan:WGet("due amounts couldn't be updated")+":"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
				ErrorBox{,self:oLan:WGet("due amounts couldn't be updated")+":"+oStmnt:ErrInfo:ErrorMessage}:show()
				self:aValuesTrans:={}
				return false 
			endif
			// update subscriptions: 
			cDueids:=''
			cDueidsInv:=''
			AEval(aAccnbrDue,{|x|iif(x[3]='0',cDueids+=','+x[2],cDueidsInv+=','+x[2]) })
			if !Empty(cDueids)
				oStmnt:=SQLStatement{'update subscription,dueamount set firstinvoicedate= NULL where subscription.subscribid=dueamount.subscribid '+; 
				'and dueid in ('+SubStr(cDueids,2)+') and ifnull(firstinvoicedate,"0000-00-00")=dueamount.invoicedate',oConn}
				oStmnt:execute()
				if	!Empty(oStmnt:Status)
					SQLStatement{"rollback",oConn}:execute() 
					SQLStatement{"unlock tables",oConn}:execute()
					LogEvent(self,self:oLan:WGet("donations couldn't be updated")+":"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
					ErrorBox{,self:oLan:WGet("donations couldn't be updated")+":"+oStmnt:ErrInfo:ErrorMessage}:show()
					self:aValuesTrans:={}
					return false 
				endif
			endif
			if !Empty(cDueidsInv)
				// set all invalid mandate ids to FRST
				oStmnt:=SQLStatement{'update subscription,dueamount set firstinvoicedate= NULL where subscription.subscribid=dueamount.subscribid '+; 
				'and dueid in ('+SubStr(cDueidsInv,2)+') ',oConn}
				oStmnt:execute()
				if	!Empty(oStmnt:Status)
					SQLStatement{"rollback",oConn}:execute() 
					SQLStatement{"unlock tables",oConn}:execute()
					LogEvent(self,self:oLan:WGet("donations couldn't be updated")+":"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
					ErrorBox{,self:oLan:WGet("donations couldn't be updated")+":"+oStmnt:ErrInfo:ErrorMessage}:show()
					self:aValuesTrans:={}
					return false 
				endif
			endif  
			
			cDueids:=''
			cDueidsInv:=''
			AEval(aAccnbrDue,{|x|iif(x[4]='0',cDueids+=','+x[2],cDueidsInv+=','+x[2]) })
			if !Empty(cDueidsInv)     
				// set all invalid mandate to blocked
				oStmnt:=SQLStatement{'update subscription,dueamount  set blocked=1 where  subscription.subscribid=dueamount.subscribid '+;
					'and dueid in ('+SubStr(cDueidsInv,2)+') ',oConn}
				oStmnt:execute()
				if	!Empty(oStmnt:Status)
					SQLStatement{"rollback",oConn}:execute() 
					SQLStatement{"unlock tables",oConn}:execute()
					LogEvent(self,self:oLan:WGet("donations couldn't be updated")+":"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
					ErrorBox{,self:oLan:WGet("donations couldn't be updated")+":"+oStmnt:ErrInfo:ErrorMessage}:show()
					self:aValuesTrans:={}
					return false 
				endif
			endif
			if nTele>0 .and.Len(aAccnbrDue)>0
				self:nReversals+=Len(aAccnbrDue)
			endif
		endif
		if !sepaEnabled.and. Len(aDueid)>0
			// 
			// reconcile dueamounts because of direct debit (Norway):
			cDueids:=Implode(aDueid,'","')
			oStmnt:=SQLStatement{"update dueamount set amountrecvd:=amountinvoice where dueid in ("+cDueids+")",oConn}
			oStmnt:execute()
			if	!Empty(oStmnt:Status)
				SQLStatement{"rollback",oConn}:execute() 
				SQLStatement{"unlock tables",oConn}:execute()
				LogEvent(self,self:oLan:WGet("due amounts couldn't be reconciled")+":"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
				ErrorBox{,self:oLan:WGet("due amounts couldn't be reconciled")+":"+oStmnt:ErrInfo:ErrorMessage}:show()
				self:aValuesTrans:={}
				return false 
			endif
		endif
		self:lv_processed+=nProc
	endif
	if !Empty (cFilename)
		LogEvent(self,"Imported "+cFilename+" "+Str(nTele,-1)+" imported of "+Str(nTot,-1)+" transactions"+;
		iif(nTele>0", processed automatically:"+Str(nProc,-1)+;
		iif(Len(aAccnbrDue)>0,' including '+Str(Len(aAccnbrDue),-1)+' direct debit reversals','')+;
		iif(!sepaEnabled.and.Len(aDueid)>0,' including '+Str(Len(aDueid),-1)+' direct debits('+Str(fDirecDebit,-1)+' '+sCurr+')',''),"")) 
		// 	else
		// 		AAdd(self:aMessages,"Imported "+cFilename+" "+Str(nTele,-1)+" imported of "+Str(nTot,-1)+" transactions"+iif(nTele>0", processed automatically:"+Str(nProc,-1),""))
	endif
	avalueTrans:=null_array
	aAccnbrDue:=null_array
	aTrans:=null_array
	avaluesPers:=null_array
	self:lv_aant_toe+=nTele
	oStmnt:=SQLStatement{"commit",oConn}
	oStmnt:execute()
	if !Empty(oStmnt:Status)
		SQLStatement{"rollback",oConn}:execute() 
		SQLStatement{"unlock tables",oConn}:execute()
		LogEvent(self,"error:"+oMBal:cError,"LogErrors")
		ErrorBox{,self:oLan:WGet('could not commit bank statement')+":"+oStmnt:ErrInfo:ErrorMessage}:show()
		self:aValuesTrans:={}
		return false 
	endif
	
	SQLStatement{"unlock tables",oConn}:execute()
	self:aValuesTrans:={}
	return true
METHOD SkipMut()  CLASS TeleMut
	* Skip of telebanking transaction aftre showing it
	SQLStatement{"update teletrans set lock_id=0 where teletrid="+Str(self:CurTelId,-1),oConn}:execute()
return
METHOD TooOldTeleTrans(banknbr as string,transdate as date,NbrDays:=360 as int) as logic CLASS TeleMut
	// check if found banknumber is part of telebanking accounts within the system
	// 	Default(@NbrDays,120) 
	local oStMnt as SQLStatement
	local oBank,oSel as SQLSelect
	local cDestname as string
	banknbr:=AllTrim(banknbr)
	IF (self:CurTelePtr:=AScan(self:m57_BankAcc,{|x| x[1]==banknbr}))=0 
		if sepaenabled .and. Len(ZeroTrim(banknbr))<10
			banknbr:=PadL(banknbr,10,'0')
			self:CurTelePtr:=AScan(self:m57_BankAcc,{|x| Right(x[1],10)==banknbr}) 
		endif
	endif
	if self:CurTelePtr=0 
		IF AScan(self:NonTeleAcc,banknbr)=0 
			oStmnt:=SQLStatement{"update bankaccount set telebankng=1 where banknumber='"+banknbr+"'",oConn}
			oStMnt:Execute()
			if oStMnt:NumSuccessfulRows<1  
				LogEvent(self,"Bank account "+banknbr+" not as telebanking account in system data")
				(ErrorBox{,"Bank account "+banknbr+" not as telebanking account in system data"}):Show()
				AAdd(self:NonTeleAcc,AllTrim(banknbr)) 
				self:nNonTele++
				RETURN true
			else
				// add to tele bank accounts:                                            
				oBank:= SqlSelect{"select b.banknumber,usedforgifts,giftsall,singledst,a.description,a.accnumber,b.accid,payahead,fgmlcodes,syscodover,max(bookingdate) as maxdat from bankaccount b left join account a on (a.accid=b.singledst) left join teletrans t on(t.bankaccntnbr=b.banknumber and bookingdate<=NOW()) where banknumber='"+AllTrim(banknbr)+"' group by banknumber",oConn}
				if oBank:reccount>0 
					if Empty(oBank:Description)
						cDestname:=''
					else
						cDestname:=GetTokens(ConS(oBank:Description))[1,1]
					endif
					//with: banknumber, usedforgifts, datlaatst, giftsall,singledst,destname,accid,payahead,singlenumber,fgmlcodes,syscodover 
					AAdd(self:m57_BankAcc,{oBank:banknumber,ConL(oBank:usedforgifts),iif(!Empty(oBank:maxdat),oBank:maxdat,null_date),ConL(obank:giftsall),;
					oBank:singledst,cDestname,ConS(oBank:accid),ConS(oBank:payahead),ConS(oBank:ACCNUMBER),oBank:fgmlcodes,oBank:syscodover})
					ASort(self:m57_BankAcc,,,{|x,y| x[1]<=y[1]} ) 
					LogEvent(self,"Bank account "+banknbr+" changed to telebanking account in system data") 
					self:CurTelePtr:=AScan(self:m57_BankAcc,{|x| x[1]==AllTrim(banknbr)})
				endif
			endif
		else
			self:nNonTele++ 
// 			LogEvent(self,"Non tele:"+ banknbr +' on '+DToC(transdate),"logsql")
			RETURN true
		ENDIF
	else
		
	ENDIF
	// temporary:
// 	NbrDays:=1000
	// check if transaction is too old in comparison with latest recorded for this bankaccount
 	IF transdate +NbrDays < self:m57_BankAcc[self:CurTelePtr,3] .or. transdate < mindate // older than 240 days compared to oldest transaction or before month closed 
//  		RETURN true 
//  	else
// 		if transdate <(Today() - NbrDays) .or. transdate < mindate        // older than 240 days or before month closed      
// 			// too old:
			self:nTooOld++
			return true
		endif
// 	ENDIF
	RETURN FALSE
