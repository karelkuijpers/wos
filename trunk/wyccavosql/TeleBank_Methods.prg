FUNCTION __DBG_EXP( ) AS USUAL PASCAL
RETURN ( NIL )
Class AddToIncExp
	protect aMbr:={} as array  // array with liabiliy members {accid,has},..
	declare method AddToIncome
method AddToIncome(gc:="" as string,FROMRPP:=false as logic,accid as string,cre as float,deb as float,debforgn as float,creforgn as float,;
		Currency as string,DESCRIPTN as string,cPersId as string,mDAT as string,mDocId as string,nSeqnbr ref int,poststatus:='2' as string) ; 
	as array class AddToIncExp
	// Add current record to Gifts Income/Expense in case of assessable gift to liability member 
	// mDat: sqlstring for date
	//	Returns array with recordings to income/exp (can be empty) with:
	// {
	LOCAL mOms as STRING
	LOCAL nCre,nCreF as FLOAT
	Local lHas as logic
	local i as int 
	local aTrans:={} as array  // to be reurned array with values to be inserted into table transaction
	//aTrans: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid 
	//          1    2     3      4      5      6            7      8   9  10      11         12    13     14       15      16   
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
						Str(nSeqnbr,-1),mDocId,'','',''})
					nSeqnbr++
					AAdd(aTrans,{iif(lHas,SEXPHOME,SEXP),nCre,nCreF,0.00,0.00,Currency,mOms,mDAT,'',LOGON_EMP_ID,poststatus,;
						Str(nSeqnbr,-1),mDocId,'','',''})
				ENDIF
			ENDIF
	endif
	RETURN aTrans
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
	CONTROL	"", SELBANKACC_LISTBOXBANK, "ListBox", LBS_DISABLENOSCROLL|LBS_EXTENDEDSEL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 8, 36, 204, 251, WS_EX_CLIENTEDGE
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
	super:Close(oEvent)
	//Put your changes here
	if !self:oCaller:lOK
		self:oCaller:m57_BankAcc:={}
	endif 
	return NIL

METHOD FillBank(dummy:=false as logic) as array CLASS SelBankAcc
	RETURN FillBankAccount('b.Telebankng=1')

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
	self:oCaller:lOK:= true
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
function SpecialMessage(message_tele as string,Destname:='' as string,cSpecialmessage:='' ref string) as logic 
	// returns special message cSpecialmessage within message_tele from telebank message 
	// returns true if manually processing needed
	local nMsgPos as int 
	local cSpecMessage as string
	local lSpecmessage,lManually as logic
	local aNospecmess:={'donatie','steun','bijdr','maand','mnd','kw','algeme','werk','onderh','comit','komit','com.','onderst','wycliff','betalingskenm','support','gave','period','spons','fam','overb','eur','behoev','hgr','woord','nodig','vriend','zegen'}  as array
	local aSpecmess:={'pensioen','lijfrente','nalaten','extra','jubil','collecte','kollekte','opbr','cadeau','kado','contant'} as array 
	// determine extra messsage in description of transaction: 
	nMsgPos:=At('%%',message_tele)
	if nMsgPos>0 
		cSpecMessage:=AllTrim(StrTran(StrTran(Lower(SubStr(message_tele,nMsgPos+2)),'giften'),'gift'))
		if !Empty(cSpecMessage) 
			lSpecmessage:=false 
			AEval(aSpecmess,{|x|lSpecmessage:=iif(AtC(x,cSpecMessage)>0,true,lSpecmessage)})
			if !lSpecmessage
				lSpecmessage:=true
				if !Empty(Destname)
					if AtC(Destname,SubStr(message_tele,nMsgPos+2))>0      // skip with name of destination
						lSpecmessage:=false 
					endif
				endif
				if lSpecmessage
					AEval(aNospecmess,{|x|lSpecmessage:=iif(AtC(x,cSpecMessage)>0,false,lSpecmessage)})
				endif
				if lSpecmessage
					// check month name in message:
					AEval(Maand,{|x|lSpecmessage:=iif(AtC(SubStr(x,1,4),cSpecMessage)>0,false,lSpecmessage)})    // skip with month name
				endif
			else 
				lManually:=true
			endif
		endif
	endif
	if lSpecmessage
		cSpecialmessage:=cSpecMessage
	else
		cSpecialmessage:=null_string
	endif
	return lManually
CLASS TeleMut

	PROTECT m56_recnr as int
	EXPORT m56_sgir,m56_kind,m56_description,m56_contra_name,m56_budgetcd,m56_cod_mut_r,;
		m56_addsub, m56_accnumber,m56_accid:="   ", m56_Payahead,m56_persid as STRING,;
		m56_bookingdate as date,;
		m56_amount as REAL,;
		m56_seqnr:=0 as int 
	export m56_contra_bankaccnt, m56_bankaccntnbr as USUAL,;
		m56_processed,m56_recognised, m56_autmut,m56_mode_aut:=true,m56_autom as LOGIC
	export m56_address, m56_zip, m56_town, m56_country as string

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
	// { {bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,processed},...} 

	declare method TooOldTeleTrans,ImportBBS,ImportPGAutoGiro ,ImportBRI,ImportPostbank,ImportVerwInfo,ImportBBSInnbetal,;
		ImportCliop,ImportGiro,ImportKB,ImportMT940,ImportSA,ImportTL1,ImportUA,CheckPattern,NextTeleNonGift,GetPaymentPattern, AddTeleTrans,SaveTeleTrans,;
		GetAddress,AllreadyImported
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
		persid as string ) as logic CLASS TeleMut 
	IF !self:TooOldTeleTrans(bankaccntnbr,bookingdate) .and.!Empty(amount) 
		if self:CurBank==bankaccntnbr .and. seqnr==self:CurSeq .and.(!Empty(seqnr) .or.self:CurDate==bookingdate)
			self:nSubSeqnr++
		else
			self:nSubSeqnr:=1
			self:CurDate:=bookingdate
			self:CurSeq:=seqnr
			self:CurBank:=bankaccntnbr
		endif
		AAdd(self:aValuesTrans,{bankaccntnbr,SQLdate(bookingdate),seqnr+iif(self:nSubSeqnr>1,Str(self:nSubSeqnr,-1),''),contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,Description,persid,''})
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
METHOD CheckPattern(dummy:=nil as logic) as logic  CLASS TeleMut
LOCAL i AS INT
LOCAL tG:=self:m56_contra_bankaccnt, tS:= self:m56_kind, tN:= self:m56_contra_name, tC:= self:m56_addsub,tD:=self:m56_description  as STRING
i := AScan(self:Teleptrn,{|x| (Empty(x[1]) .or. ;
					tG	== x[1])	.and.;
					tS	= x[2]	.and.;
					tN	= x[3]	.and.;
					tC 	== x[4]	.and.;
					CompareKeyString(x[5],tD)})
IF i>0
	self:m56_accid:= self:Teleptrn[i,6]
	self:m56_recognised:=true
	self:m56_autmut:=Logic(_cast,self:Teleptrn[i,7])
	if Empty(self:Teleptrn[i,1])
		self:m56_autmut:=false         // in case of empty contra bankaccount no unique identification possible 
	endif
	RETURN TRUE
ELSE
	self:m56_accid:=Space(25)
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
	
	SQLStatement{"update teletrans set processed='X', lock_id=0 where teletrid="+Str(self:CurTelId,-1),oConn}:execute()
	SQLStatement{"commit",oConn}:execute()

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
	local XMLPos,nAddrEnd as int
	Local aWord as array
	local lZipCode,lCity,lAddress as logic
	self:m56_address:=""
	self:m56_zip:=""
	self:m56_town:=""
	self:m56_country:="" 
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
		self:m56_description:= Upper(Compress(Description))
		if (nAddrEnd:=At('%%',Description))>0  
			// separate address line probably
			if oPers==null_object
				oPers:=PersonContainer{}
			endif
			aWord:=GetTokens(SubStr(Description,1,nAddrEnd-1)) 
			oPers:Adres_Analyse(aWord,,@lZipCode,@lCity,@lAddress,false,lZipFromWeb)
			self:m56_address:=oPers:m51_ad1
			self:m56_zip:=StandardZip(oPers:m51_pos) 
			self:m56_town:=oPers:m51_city
		endif
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
	cSelect:="b.usedforgifts=1 "+;
		"and addsub='B' and t.kind not in ('OCR','BGC') and t.description <> 'Betreft acceptgiro' and not t.description  like 'NAAM/NUMMER STEMMEN NIET OVEREEN%' and "+; 
	"(t.kind<>'COL' or cast(t.contra_bankaccnt as unsigned)>0) and "+;
		"(cast(t.contra_bankaccnt as unsigned)=0 or t.contra_bankaccnt not in ("+self:cBankAcc+")) "
	if LookingForGifts
		if ADMIN="HO"
			cSelect=""
		endif
	else
		cSelect:="not ("+cSelect+")"		
	endif
	cSelect+=iif(Empty(cSelect),""," and ")+"t.bankaccntnbr in ("+self:cReqTeleBnk+")"     // should contain requested bankaccounts

	DO WHILE true
		SQLStatement{"start transaction",oConn}:execute() 
		// select next row not yet locked by somebody else:
		self:oTelTr:= SqlSelect{"select t.teletrid,t.seqnr,t.amount,t.bankaccntnbr,cast(t.bookingdate as date) as bookingdate,t.kind,t.contra_bankaccnt,"+; 
		"t.addsub,t.code_mut_r,t.budgetcd,t.description,t.persid,t.contra_name,"+;
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
		self:m56_contra_name:=""
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
		self:GetAddress(self:oTelTr:Description)
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
						lv_kind:="COL"
						dateCol:= SToD(SubStr(cText,6,8))
						if !Empty(lv_persid) .and.!dateCol==null_date .and. dateCol<Today() .and. dateCol> Today()-300 
							//	 Look	for Due amount:
							oDue:=SQLSelect{'select s.personid as persid,a.accnumber from dueamount d, account a, subscription s where '+;
								's.subscribid=d.subscribid and s.personid="'+lv_persid+'" and d.invoicedate="'+;
								SQLdate(dateCol)+'" and seqnr='+ZeroTrim(SubStr(cText,14))+' and s.accid=a.accid',oConn}	  
							if	oDue:Reccount>0	//	without check digit
								lv_persid:=Str(oDue:persid,-1)
								lv_budget:=oDue:ACCNUMBER
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
			cText	:=	StrTran(SubStr(lv_Oms,1,19),' ','')
			// 			IF	isnum(cText) .and. Len(cText)=16	.and.	IsMod11(cText)							
			IF	isnum(cText) .and.	IsMod11(cText)							
				//	betalingskenmerk
				lv_kind:="AC"
			endif
			
			
		endif
		if	lv_kind=="AC"
			if	lv_addsub =	"B" .and.isnum(cText)
				if Len(cText)>11
					lv_persid:=ZeroTrim(SubStr(cText,-5))
				endif
				lv_bankid:=SubStr(cText,2,6)
				lv_budget:=SubStr(cText,2,Max(5,Len(cText)-6))
				if	Val(SubStr(lv_budget,6))==0
					lv_budget:=LTrimZero(SubStr(lv_budget,1,5))
				endif
			endif
		endif
	endif
	return

METHOD Import() CLASS TeleMut
	* Import of telebanking data into table teletrans
	LOCAL oFs, oFC, oFrabo as MyFileSpec
	LOCAL aFileMT, aFilePB, aFileSA, aFileN, aFileUA, aFileBBS, aFileINN, aFilePG, aFileVWI, aFileRabo,aFileTL,aFileKB,aFileRO as ARRAY
	local cFileName as STRING, nf,i as int
	LOCAL oBF as MyFileSpec
	LOCAL oPF as FileSpec
	LOCAL i as int
	local nOld:=6 as int   // after Nold months imported transactions are removed
	LOCAL lDelete,lSuccess as LOGIC
	LOCAL lv_eind as date
	Local oLock,oSel as SQLSelect 
	local oStmnt as SQLStatement
	local aFiles:={} as array  // files to be deleted 
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
	oFC := MyFileSpec{"mutcliop.txt"}
	oFC:Path:=CurPath
	// 	oFrabo := MyFileSpec{"mut.asc"}
	// 	oFrabo:Path:=CurPath
	SetPath(CurPath)
	* Determine filenames of MT940 files:
	aFileMT:=Directory(CurPath+"\*.STA")
	AEval(Directory("*.SWI"),{|x|AAdd(aFileMT,x)}) 
	AEval(Directory("*_ME940file20*.txt"),{|x|AAdd(aFileMT,x)})          // e.g.: 3001715206_ME940file20110117
	aFilePB:=Directory(CurPath+"\*-20??.CSV")
	aFileKB:=Directory(CurPath+"\*KTO*_*.CSV")
	aFileRO:=Directory(CurPath+"\RO??BTRL????????N?????XX-??.??.????-??.??.????.csv")
	aFileSA:=Directory(CurPath+"\statement-*-20??????.txt") 
	aFileUA:=Directory(CurPath+"\x*statements.TXT")
	aFileINN:=Directory(CurPath+"\ocrinnbet.txt*")
	aFileBBS:=Directory(CurPath+"\transliste*.csv")
	// 	aFileVWI:=Directory(CurPath+"\*????????verwinfo??.txt")
	aFileVWI:=Directory(CurPath+"\*verwinfo*.txt")
	aFilePG:=Directory(CurPath+"\PG_8502000149_BG4_20??-??-??*.txt")
	aFileRabo:=Directory(CurPath+"\BR0?????????.0??") 
	aFileTL:=Directory(CurPath+"\PG_TOTALIN_TL1_*.txt")  
	AEval(Directory(CurPath+"\mut*.ASC"),{|x|AAdd(aFileRabo,x)})
	AEval(Directory(CurPath+"\*-20??.ASC"),{|x|AAdd(aFilePB,x)})
	AEval(Directory(CurPath+"\*-20??.TXT"),{|x|AAdd(aFilePB,x)})
   self:aValuesTrans:={}
	IF oFs:Find() .or. oFC:Find() .or.!Empty(aFileRabo).or.!Empty(aFileMT).or.!Empty(aFilePB).or.!Empty(aFileSA).or.!Empty(aFileKB).or.;
			!Empty(aFileUA).or.!Empty(aFileBBS).or.!Empty(aFileINN).or.!Empty(aFilePG).or.!Empty(aFileVWI).or.!Empty(aFileTL).or.!Empty(aFileRO)
		lDelete:=true 
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

		IF oFC:Find()
			if self:ImportCliop(oFC)
				AAdd(aFiles,oFC)
			endif				
		ENDIF

		// Import Bulk Rekening Info:	
		FOR nf:=1 to Len(aFileRabo)
			cFileName:=aFileRabo[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			if self:ImportBRI(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT
		FOR nf:=1 to Len(aFileVWI)
			// VERWINFO of Equens
			cFileName:=aFileVWI[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			if self:ImportVerwInfo(oBF)
				AAdd(aFiles,oBF)
			endif				
		NEXT
		
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


		FOR nf:=1 to Len(aFileMT)
			cFileName:=aFileMT[nf,F_NAME]
			oBF := MyFileSpec{cFileName} 
			if self:ImportMT940(oBF)
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
			IF !isnum(aFileN[1]) .and. !aFileN[1]=="ING"
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
		NEXT


		* Removing old transactions:
		IF lv_aant_toe>0
			* Calculate date too old (6 months old):
			nOld:=Min(nOld,12)
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
		ErrorBox{self,self:oLan:WGet("could not select importlock")+Space(1)+' ('+oLock:Status:description+')'}:Show()
		SQLStatement{"rollback",oConn}:execute() 
		return
	endif
	oStmnt:=SQLStatement{"update importlock set lock_id='',lock_time='0000-00-00' where importfile='telelock'",oConn}
	oStmnt:execute()
	if !Empty(oStmnt:Status)
		ErrorBox{self,self:oLan:WGet("could not unlock required transactions")}:Show()
		SQLStatement{"rollback",oConn}:execute()
	else 
		SQLStatement{"commit",oConn}:execute()  // save locks 
	endif

	if Len(self:aMessages)>0
		(InfoBox{,"Import of telebanking transactions",Str(lv_aant_toe,4)+" transactions imported (processed automatically "+Str(self:lv_processed,-1)+")"}):Show()
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
	cBuffer:=ptrHandle:FReadLine(ptrHandle)
	IF Empty(cBuffer)
		(ErrorBox{,"Could not read file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	if !GetDelimiter(cBuffer,@aStruct,@cDelim,4,5)
// 	cDelim:=CHR(9)
// 	aStruct:=Split(Upper(cBuffer),cDelim)
// 	IF Len(aStruct)<4
		(ErrorBox{,"Wrong fileformat of importfile from BBS Bank: "+oFs:FullPath+"(See help)"}):show()
		RETURN FALSE
	ENDIF
	ptDate:=AScan(aStruct,{|x| "DATO" $ x})
	ptDesc:=AScan(aStruct,{|x| "FORKLARING" $ x})
	ptPay:=AScan(aStruct,{|x| "UT AV KONTO" $ x})
	ptDep:=AScan(aStruct,{|x| "INN PÅ KONTO" $ x})
	IF ptDate==0 .or. ptDesc==0 .or. ptPay==0 .or. ptDep==0
		(ErrorBox{,"Wrong fileformat of importfile from BBS Bank: "+oFs:FullPath+"(See help)"}):show()
		RETURN FALSE
	ENDIF
	// Determine Bankaccount of Wycliffe at BBS:
	lv_bankAcntOwn:=ZeroTrim(BANKNBRDEB)
	cBuffer:=ptrHandle:FReadLine(ptrHandle)
	aFields:=Split(cBuffer,cDelim)
	nImp:=0
	nTrans:=0

	DO WHILE Len(AFields)>3
		ld_bookingdate:=CToD(AFields[ptDate])
		IF ld_bookingdate >=Today() .or. self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
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
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
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
		cBuffer:=ptrHandle:FReadLine(ptrHandle)
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	ptrHandle:=null_object 
	nImp:=self:lv_aant_toe
	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(false,false)
	AAdd(self:aMessages,"Imported BBS file:"+oFb:FileName+" "+Str(self:lv_aant_toe -nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		return true
	else
		return false                                              
	endif

METHOD ImportBBSInnbetal(oFm as MyFileSpec) as logic CLASS TeleMut
	*	Import of one BBS Innbetaling transaction file (with KID numbers)
	LOCAL oHlM as HlpMT940
	LOCAL lv_bankAcntOwn, lv_description, lv_addsub, lv_AmountStr, lv_Budgetcd, lv_InvoiceID, lv_reference, lv_persid,lv_NameContra as STRING
	LOCAL lv_loaded as LOGIC
	LOCAL lv_Amount as FLOAT
	LOCAL lSuccess:=true as LOGIC
	LOCAL AccSDON as STRING
	LOCAL oHlp as FileSpec
	LOCAL ld_bookingdate as date
	local oStmnt as SQLStatement
	local oSel as SQLSelect
	local oStmnt as SQLStatement
	local nTrans,nImp,nSub,nProc as int 
	local aSubscr:={} as array // array with persid's in donation subscriptions {persid,invoiceid},... 

	
	oHlM :=HLPMT940{HelpDir+"\HMT"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
	
	*Look for NY090020: record with accountnumber
	*	Look for next line until line =NY090020
	*		if 61: amount
	*		if 85: corresponding description with counteraccount
	*			add record to teletrans
	*
	lSuccess:=oHlM:AppendSDF(oFm)
	oHlM:Gotop()
	IF Empty(SDON)
		(WarningBox{,"Import of Innbetal transactions","Specify first within system parameters account for donations as default destination"}):Show()
		RETURN FALSE
	ENDIF	
	oSel:=SqlSelect{"select accnumber from account where accid="+SDON,oConn}
	if oSel:Reccount>0
		AccSDON:=oSel:ACCNUMBER
	ENDIF 
	oSel:=SqlSelect{"select personid,invoiceid from subscription where category='D'",oConn} 
	aSubscr:=oSel:GetLookupTable(1000)
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
			* Search for NY091330 or NY091030  (amount and kidnbr):
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
				IF Empty(lv_Budgetcd)
					lv_Budgetcd:=AccSDON  // default Donations account
				ENDIF
				lv_reference:=SubStr(oHlM:MTLINE,5,2)
				lv_persid:=ZeroTrim(SubStr(lv_InvoiceID,1,6))
				lv_description:=AddSlashes(AllTrim(lv_description))
				nTrans++
				nSub:=AScan(aSubscr,{|x|x[2]==lv_InvoiceID})
				if nSub>0
					lv_persid:=Str(aSubscr[nSub,1],-1)
				elseif (oSel:=SqlSelect{"select persid from personbank where banknumber='"+ZeroTrim(lv_InvoiceID)+"'",oConn}):Reccount>0
					lv_persid:=Str(oSel:persid,-1)
				elseif SqlSelect{"select persid from person where persid="+lv_persid,oConn}:Reccount>0
					lv_persid:=lv_persid
				else
					lv_persid:="0"
				endif
				* save transaction:
				self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(Val(SubStr(oHlM:MTLINE,9,7)),-1),ZeroTrim(lv_InvoiceID),;
					'KID',lv_NameContra,lv_Budgetcd,lv_Amount,lv_addsub,lv_description,lv_persid)
				lv_description:=""
			ENDIF
			oHlM:Skip()
		ENDDO
	ENDDO

	oHlp:=FileSpec{oHlM:FileSpec:FullPath}
	oHlM:Close()
	oHlM:=null_object
	oHlp:DELETE()
	nImp:=self:lv_aant_toe 
	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(false,true)
	AAdd(self:aMessages,"Imported Innbetalinger fra BBS file:"+oFm:FileName+" "+Str(self:lv_aant_toe -nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		return true
	else
		return false                                              
	endif
METHOD ImportBRI(oFm as MyFileSpec) as logic CLASS TeleMut
	* Import of Bulk Rekening Informatie data into teletrans.dbf
	*	Import of one BRI telebnk transaction file
	LOCAL oHlM as HlpMT940
	LOCAL i, nEndAmnt, nDC, nPtr, nOffset, nVnr, nTrans, nImp,nProc as int
	LOCAL lv_bankAcntOwn, lv_description, lv_addsub, lv_AmountStr, lv_reference, lv_NameContra, lv_budget,Cur_RekNrOwn, Cur_enRoute, lv_bankid as STRING
	LOCAL lv_loaded as LOGIC,  lv_BankAcntContra as string, cText, recordcode, cAccount as STRING
	LOCAL lv_Amount as FLOAT
	LOCAL cSep, DescrPart, betkenm,lv_persid as STRING, nAcPos as int
	LOCAL lSuccess:=true as LOGIC
	LOCAL oHlp as FileSpec
	LOCAL ld_bookingdate as date 
	local oAcc1, oAcc2 as SQLSelect, oBank as SQLSelect, oDue as SQLSelect , oBord as SQLSelect 
	Local BRI as logic 
	local aBudg:={} as array
	local oStmnt as SQLStatement

	
	oHlM :=HLPMT940{HelpDir+"\HMT"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
	cSep:=CHR(SetDecimalSep())
	*Look for 2: record with transction record
	*			add record to teletrans
	*
	lSuccess:=oHlM:AppendSDF(oFm)
	oHlM:Gotop()
	if SubStr(oHlM:MTLINE,24,1)=="0" .or. SubStr(oHlM:MTLINE,24,1)=="1"
		BRI:=true
	endif
	nImp:=0
	nTrans:=0
	DO WHILE .not.oHlM:EoF
		if SubStr(oHlM:MTLINE,14,5)=="SPECS"
			cSep:=cSep
		endif 
		* Search 2 record:
		IF !SubStr(oHlM:MTLINE,24,1)=="2" .or. (BRI .and.!SubStr(oHlM:MTLINE,14,5)=="BOEK.")  //skip saldo and specifications
			oHlM:skip()
			loop
		ENDIF
		lv_bankAcntOwn:=ZeroTrim(AllTrim(SubStr(oHlM:MTLINE,1,10)))
		if !lv_bankAcntOwn== Cur_RekNrOwn
			Cur_RekNrOwn:=lv_bankAcntOwn
			Cur_enRoute:=""
			oBank:=SQLSelect{"select b.payahead,a.accnumber from bankaccount b, account a where not b.payahead is null and a.accid=b.payahead and banknumber='"+lv_bankAcntOwn+"'",oConn}
			if oBank:Reccount>0
				Cur_enRoute:=oBank:ACCNUMBER
			endif
		endif
		lv_BankAcntContra:=ZeroTrim(AllTrim(StrTran(SubStr(oHlM:MTLINE,39,10),"P",""))) 
		lv_NameContra:=AllTrim(SubStr(oHlM:MTLINE,49,24))
		lv_Amount:=Val(AllTrim(SubStr(oHlM:MTLINE,74,13)))/100.00 
		lv_addsub:=iif(SubStr(oHlM:MTLINE,87,1)=="D","A","B") 
		ld_bookingdate:=SToD("20"+SubStr(oHlM:MTLINE,88,6)) // book date
		lv_reference:=SubStr(oHlM:MTLINE,100,4)	// bankafschrift+postnummer 
		nVnr:=Val(SubStr(oHlM:MTLINE,104,5))
		lv_description:=""
		lv_persid:=""
		lv_bankid:=""
		lv_budget:=AllTrim(SubStr(oHlM:MTLINE,109,16))   // bet.kenmerk 
		if Len(lv_budget)==16 .and.isnum(lv_budget) .and. IsMod11(lv_budget)
			lv_reference:="AC"
			if lv_addsub = "B"
				lv_persid:=SubStr(lv_budget,-5)
				lv_bankid:=SubStr(lv_budget,2,6)
				lv_budget:=ZeroTrim(SubStr(lv_budget,2,Len(lv_budget)-6))
				if Val(SubStr(lv_budget,6))==0
					lv_budget:=LTrimZero(SubStr(lv_budget,1,5))
				endif
			else
				lv_description:=lv_budget+" "
				lv_budget:=""			
			endif
		else
			lv_description:=lv_budget+" "
			lv_budget:=""
		endif			

		oHlM:skip() 
		// determine descriptions:
		do WHILE !oHlM:EoF .and.(SubStr(oHlM:MTLINE,24,1)=="3" .or.SubStr(oHlM:MTLINE,24,1)=="4")
			recordcode:= SubStr(oHlM:MTLINE,24,1)
			IF recordcode=="3"
				* description of transaction:
				if IsDigit(SubStr(oHlM:MTLINE,57,1)) .or.(SubStr(oHlM:MTLINE,57,1)=="(" .and.IsDigit(SubStr(oHlM:MTLINE,58,1)))
					if SubStr(oHlM:MTLINE,57,1)=="("
						nPtr:= At(")",SubStr(oHlM:MTLINE,58,32)) 
						nOffset:=58
					else
						nPtr:= At(" ",SubStr(oHlM:MTLINE,57,32))
						nOffset:=57
					endif
					if nPtr>5 .and. nPtr<15  
						// Budgetcode? i.e. gen.ledger account? 
						lv_budget:=SubStr(oHlM:MTLINE,nOffset,nPtr-1)
						if !SQLSelect{"select accid from account where accnumber='"+lv_budget+"'",oConn}:reccount>0   // no existing account?
							lv_budget:=""
						endif
					endif
				elseif SubStr(oHlM:MTLINE,57,32)="TOTAAL INCASSO" .or.Upper(SubStr(oHlM:MTLINE,57,32))="DOORLOPENDE MACHTIGING ALGEMEEN"
					lv_budget:=Cur_enRoute 
					lv_reference:="COL"
				elseif (Upper(SubStr(oHlM:MTLINE,57,32))="RESTITUTIE INCASSO".or.Upper(SubStr(oHlM:MTLINE,57,32))="TERUGBOEKING")
					if Empty(lv_budget)  //filled betalingskenmerk 
						lv_budget:=SubStr(AllTrim(lv_description),2)
					endif 			
					lv_persid:=SubStr(lv_budget,1,5)
					lv_reference:="COL"
					//  Look for Due amount:
					oDue:=SQLSelect{"select s.personid as persid,a.accnumber from dueamount d, account a, subscription s where "+;
						"s.subscribid=d.subscribid and s.personid="+lv_persid+" and d.invoicedate='"+;
						SQLdate(stod(substr(lv_budget,6,8)))+"' and seqnr="+zerotrim(substr(lv_budget,14))+" and d.accid=a.accid",oConn}    
					if oDue:Reccount>0   // without check digit
						lv_persid:=Str(oDue:persid,-1)
						lv_budget:=oDue:ACCNUMBER
					else
						lv_budget:=""
						lv_persid:=""
					endif
				elseif Upper(SubStr(oHlM:MTLINE,57,32))="NAAM/NUMMER STEMMEN NIET OVEREEN" .and.!Empty(lv_budget)  //filled betalingskenmerk
					// look for bankorder:
					oBord:=SQLSelect{"select a.accnumber from bankorder o, account a where id="+ZeroTrim(lv_bankid)+" and a.accid=b.accntfrom", oConn} 
					if oBord:Reccount>0   
						lv_budget:=AllTrim(oAcc2:ACCNUMBER)
					else
						lv_budget:=""
					endif
				elseif Upper(SubStr(oHlM:MTLINE,57,32))="CREDITEURENBETALING" .or. Upper(SubStr(oHlM:MTLINE,57,32))="BETREFT ACCEPTGIRO" 
					// total amount BETOPD file or BGC Acceptgiro run:
					if Empty(Cur_enRoute)
						(ErrorBox{,"for bank account "+ Cur_RekNrOwn+" no 'Account payments en route' specified; import aborted"}):Show()
						return false 
					endif
					lv_budget:=Cur_enRoute
					lv_reference:="BGC"
				elseif Upper(SubStr(oHlM:MTLINE,57,32))="EUROBETALING SHA"
					lv_BankAcntContra:=""   // ignore account in case of payment from other country in Euro
				endif
				//lv_description+=Compress(SubStr(oHlM:MTLINE,57,32)+SubStr(oHlM:MTLINE,89,32))+" "
			endif 
			for i:=25 to 119 step 32
				DescrPart:=SubStr(oHlM:MTLINE,i,32) 
				if !Empty(DescrPart) .and. !DescrPart="TRANSACTIEDATUM" .and.!DescrPart="Overstapservice via "
					betkenm:=""
					if IsDigit(DescrPart) .and. (nAcPos:=At("AC",DescrPart))>0
						if nAcPos<=17 .and. nAcPos>10 
							betkenm:=AllTrim(SubStr(DescrPart,1,nAcPos-1))
						endif
					elseif SubStr(DescrPart,1,13)=="BET KENMERK* "
						// also betalingskenmerk acceptgiro:
						betkenm:=AllTrim(StrTran(SubStr(DescrPart,14)," ","")) 
					elseif isnum(SubStr(DescrPart,1,4)) .and. isnum(SubStr(DescrPart,6,4))
						betkenm:=AllTrim(StrTran(SubStr(DescrPart,1)," ",""))
						if Len(betkenm)<10
							betkenm=""
						endif 					
					endif
					if !Empty(betkenm) .and. isnum(betkenm) .and. IsMod11(betkenm) .and.!lv_reference="COL"
						// betalingskenmerk acceptgiro:
						if lv_addsub = "B"
							lv_reference:="AC"
							lv_persid:=SubStr(betkenm,-5)
							lv_budget:=SubStr(betkenm,2,Len(betkenm)-6)
							if Val(SubStr(lv_budget,6))==0
								lv_budget:=LTrimZero(SubStr(lv_budget,1,5))
							endif
						endif
					else
						lv_description+=Compress(DescrPart)+" "
					endif
				endif
			next
			oHlM:skip()
		ENDDO
		lv_budget:=AllTrim(lv_budget)
		lv_description:=AllTrim(lv_description)
		if	Len(lv_budget)==0	
			nOffset:=At('*',lv_description)
			if (nOffset=1.or. nOffset=32) 
				aBudg:=Split(lv_description,"*")
				if	Len(aBudg)>1
					lv_budget:=aBudg[2]
				endif
			elseif SubStr(lv_description,1,1)="["
				aBudg:=Split(SubStr(lv_description,2),"]")
				if	Len(aBudg)>1
					lv_budget:=aBudg[1]
				endif					
			endif
		endif
		* save transaction:
		nTrans++
		lv_description:=AddSlashes(AllTrim(lv_description))
		lv_NameContra:=AddSlashes(AllTrim(lv_NameContra))
		lv_BankAcntContra:=ZeroTrim(lv_BankAcntContra)
		lv_bankAcntOwn:=ZeroTrim(lv_bankAcntOwn)
		self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(nVnr,-1),lv_BankAcntContra,;
			lv_reference,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid)
		lv_description:=""
		//   	IF !self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
		//   		IF !self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,lv_reference,lv_BankAcntContra,lv_NameContra,lv_budget) .and.!Empty(lv_Amount)
		// 			oStmnt:=SQLStatement{"insert into teletrans set	"+;
		// 				"contra_bankaccnt='"+ZeroTrim(lv_BankAcntContra)+"'"+;
		// 				",contra_name='"+lv_NameContra+"'"+;
		// 				",bankaccntnbr='"+ZeroTrim(lv_bankAcntOwn)+"'"+;
		// 				",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
		// 				",kind='"+lv_reference +"'"+;
		// 				",amount="+Str(lv_Amount,-1)+;
		// 				",addsub='"+lv_addsub	+"'"+;
		// 				",budgetcd='"+lv_budget	+"'"+;
		// 				iif(Empty(lv_persid),"",",persid='"+lv_persid +"'")+;
		// 				",seqnr="+Str(nVnr,-1)+;
		// 				",description='"+lv_description	+"'",oConn}
		// 			oStmnt:Execute()
		// 			if	oStmnt:NumSuccessfulRows>0
		// 				++self:lv_aant_toe
		// 				++nImp
		// 			else
		// 				LogEvent(self,oStmnt:SQLString+CRLF+"Error:"+oStmnt:Status:Description,"LogErrors")
		// 			endif
		//   		endif
		// 	ENDIF
	ENDDO
	
	oHlp:=FileSpec{oHlM:FileSpec:Fullpath}
	oHlM:Close()
	oHlM:=null_object 
	oHlp:DELETE()
	nImp:=self:lv_aant_toe
	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(true,true)
	AAdd(self:aMessages,"Imported BRI file:"+oFm:FileName+" "+Str(self:lv_aant_toe -nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		return true
	else
		return false                                              
	endif
METHOD ImportCliop(oFs as MyFileSpec) as logic CLASS TeleMut
	* Import of Clieop03 data with automatic collection details into teletrans.dbf
	LOCAL oHlC AS HulpCliop
	LOCAL i,nTot,nTrans as int
	LOCAL lv_bestandid, lv_bankAcntOwn, lv_BankAcntContra, lv_budget:=Space(5),lv_AmountStr,lv_persid,lv_NameContra  as STRING
	LOCAL lv_loaded as LOGIC
	LOCAL cCurrency,lv_description as STRING
	LOCAL cSep AS STRING
	LOCAL lSuccess:=TRUE AS LOGIC
	LOCAL lAutCollection:=FALSE AS LOGIC
	LOCAL lv_Amount as FLOAT
	LOCAL oHlp AS Filespec
	LOCAL ld_bookingdate as date
	local oStmnt as SQLStatement

	oHlC :=HulpCliop{HelpDir+"\HCLIOP"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
	* Clear HulpCliop
	cSep:=CHR(SetDecimalSep())
	lSuccess:=oHlC:AppendSDF(oFs)
	oHlC:Gotop()
	*Search for automatic collection:
	* Check correct file:
	IF !(oHlC:INFOCODE=="0001".and. oHLC:VARIANTCOD=="A" .and. SubStr(oHLC:BEDRAG,3,8)=="CLIEOP03")
		ErrorBox{,"File MutCliop.TXT is not a correct CLieop file"}:Show()
		oHLC:Close()
		oHLC:=NULL_OBJECT
		RETURN FALSE
	ENDIF
	DO WHILE .not.oHlC:EOF
		IF oHlC:INFOCODE=="0001"  //bestandsvoorloopinfo
			ld_bookingdate:=SToD("20"+SubStr(oHlC:bedrag,1,2)+;
				SubStr(oHlC:TRANSSOORT,3,2)+SubStr(oHlC:TRANSSOORT,1,2))
			lv_bestandid:=SubStr(oHlc:ReknrBet,4,4)
			oHlC:Skip()
			LOOP
		ENDIF
		IF !lAutCollection
			DO WHILE !oHlC:EoF
				IF oHlC:INFOCODE=="0010"  // batch voorlooprecord
					IF SubStr(oHlC:TRANSSOORT,1,2)=="10"   // transactiegroep:incassi
						* Juiste batch
						lAutCollection:=TRUE
						cCurrency:=SubStr(oHlC:ReknrBet,1,3)
						oHlC:Skip()
						EXIT
					ENDIF
				ENDIF
				oHlC:Skip()
			ENDDO
			IF oHlC:eof.or.!lAutCollection
				LOOP
			ENDIF
		ENDIF
		IF oHlC:INFOCODE=="9990" //batchsluitrecord
			lAutCollection:=FALSE
			oHlc:Skip()
			LOOP
		ENDIF	
		IF oHlC:INFOCODE=="0010"  // batch voorlooprecord
			IF SubStr(oHlC:TRANSSOORT,1,2)=="10"   // transactiegroep:incassi
				ld_bookingdate:=SToD("20"+SubStr(oHlC:bedrag,1,2)+;
					SubStr(oHlC:TRANSSOORT,3,2)+SubStr(oHlC:TRANSSOORT,1,2))
				lv_bestandid:=SubStr(oHlc:ReknrBet,4,4)
				oHlC:Skip()
				LOOP
			ENDIF
		ENDIF

		IF oHlC:INFOCODE=="0100"
			*		Transactieinfo:
			lv_bankAcntOwn:=ZeroTrim(Str(Val(oHlC:REKNRONTV),-1))
			lv_BankAcntContra:=ZeroTrim(Str(Val(oHlC:ReknrBet),-1))
			lv_AmountStr:=oHlC:BEDRAG
			oHlC:Skip()
			* search for Betalinsgkenmerk (150) or Omschrijving (160) or next
			DO WHILE !oHlC:EoF
				IF oHlC:INFOCODE=="0100".or. oHlC:INFOCODE=="9990"
					* end of transaction:
					EXIT
				ELSEIF oHlC:INFOCODE=="0150"
					* Betalingskenmerk:
					lv_budget:=SubStr(oHlC:TRANSSOORT+oHlC:BEDRAG,1,5)
				ELSEIF oHlC:INFOCODE=="0160"
					* Omschrijving:
					lv_description:=oHlC:TRANSSOORT+oHlC:BEDRAG+oHlC:ReknrBet+SubStr(lv_bankAcntOwn,1,6)
				ENDIF
				oHlC:Skip()
			ENDDO
		ELSE
			* No Transactioninfo:
			oHlC:Skip()
			LOOP
		ENDIF
		IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate,14)
			* Skip mutaties 14 dagen ouder dan laatste:
			oHlC:Skip()
			LOOP
		ENDIF

		IF Empty(Val(lv_AmountStr))  && geen lege mutaties laden
			oHlC:Skip()
			LOOP
		ENDIF
		lv_amount:=Round(Val(SubStr(lv_amountStr,1,10)+cSep+SubStr(lV_amountStr,11)),2)
		lv_description := AddSlashes(AllTrim(Compress(lv_description)))
		nTot++ 
		self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,'',lv_BankAcntContra,;
			'COL',lv_NameContra,lv_budget,lv_Amount,'B',lv_description,lv_persid)
		//       * controleer op reeds geladen zijn van mutatie:
		// 	IF self:AllreadyImported(ld_bookingdate,lv_Amount,"B",lv_description,"IC",lv_BankAcntContra,"",lv_budget)
		//        	*	Skip THIS transaction
		//         LOOP
		// 	ENDIF
		// 	oStmnt:=SQLStatement{"insert into teletrans set	"+;
		// 	"contra_bankaccnt='"+lv_BankAcntContra+"'"+;
		// 	",bankaccntnbr='"+lv_bankAcntOwn+"'"+;
		// 	",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
		// 	",kind='COL'"+;
		// 	",amount='"+Str(lv_Amount,-1)+"'"+;
		// 	",addsub='B'"+;
		// 	",code_mut_r='M'"+;
		// 	",budgetcd='"+lv_budget	+"'"+;
		// 	",description='"+lv_description	+"'",oConn}
		// 	oStmnt:Execute()
		// 	if	oStmnt:NumSuccessfulRows>0
		// 		++self:lv_aant_toe 
		// 	endif
		// 	lv_budget:=Space(5)
		lv_description:=""
	ENDDO
	oHlp:=Filespec{oHLC:FileSpec:Fullpath}
	oHlC:Close()
	oHLC:=NULL_OBJECT
	oHlp:Delete()
	nTrans:=self:lv_aant_toe 
	lSuccess:=self:SaveTeleTrans(true,true)
	AAdd(self:aMessages,"Imported Cliop file:"+oFs:FileName+" "+Str(self:lv_aant_toe -nTrans,-1)+" imported of "+Str(nTot,-1)+" transactions")
	if lSuccess
		return true
	else
		return false                                              
	endif
	RETURN true
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
oHlG :=Hulpgiro{HelpDir+"\HGiro"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
* Clear HulpGiro
oHlG:Zap()
// lSuccess:=oFs:FileLock()       
lSuccess:=oHlG:AppendSDF(oFs)
if lSuccess	 
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
		IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			oHlG:Skip()
			loop
		ENDIF

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
	nImp:=self:lv_aant_toe
	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(true,true)
	AAdd(self:aMessages,"Imported ING file:"+oFs:FileName+" "+Str(self:lv_aant_toe -nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		return true
	else
		return false                                              
	endif
// 	AAdd(self:aMessages,"Imported ING file:"+oFs:FileName+" "+Str(nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions")

ENDIF
RETURN true
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
	ptCur:=AScan(aStruct,{|x| "WÄHRUNG" $ x})
	IF ptDate==0 .or. ptDesc==0 .or. ptPay==0 .or. ptCur==0 
		(ErrorBox{,self:oLan:Wget("Wrong fileformat of importfile from KB Bank")+": "+oFs:FullPath+"("+self:oLan:Wget("See help")+")"}):show()
		RETURN FALSE
	ENDIF

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
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
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
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_Amount:=Round(lv_Amount,DecAantal) 
		lv_description:=AddSlashes(lv_description)
		* controleer op reeds geladen zijn van mutatie:
		nTot++
		IF self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,"KDB","","","")
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
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
	SetDecimalSep(cSep)  // restore decimal separator 
	AAdd(self:aMessages,"Imported KB file:"+oFb:FileName+" "+Str(nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions")

	return true
METHOD ImportMT940(oFm as MyFileSpec) as logic CLASS TeleMut
	*	Import of one MT940 telebnk transaction file
	LOCAL oHlM as HlpMT940
	LOCAL i, nEndAmnt, nDC, nOffset, nTrans,nImp,nNumPos,nSepPos,nLenLine1,nBGCSeq,nProc as int
	LOCAL lv_bankAcntOwn, lv_description, lv_Oms, lv_addsub, lv_AmountStr, lv_reference,lv_referenceCur, lv_NameContra as STRING
	LOCAL lv_loaded as LOGIC,  lv_BankAcntContra as USUAL, cText,lv_budget,lv_kind,lv_persid,lv_bankid as STRING 
	local Cur_RekNrOwn, Cur_enRoute as string
	local cType86 as string  //type of tag 86: B=bank,
	LOCAL lv_Amount as FLOAT
	LOCAL cSep as STRING
	local oBank as SQLSelect, oBord as SQLSelect 
	LOCAL lSuccess:=true as LOGIC
	LOCAL oHlp as Filespec
	LOCAL ld_bookingdate as date 
	local lMTExtended as logic
	local aBudg:={} as array
	local aWord as array
	local oStmnt as SQLStatement

	
	oHlM :=HLPMT940{HelpDir+"\HMT"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
	cSep:=CHR(SetDecimalSep()) 
	lMTExtended:=(AtC('ME940',oFm:FileName)>0) 

	*Look for 25: record with accountname
	*	Look for next line until line :25:
	*		if 61: amount
	*		if 86: corresponding description with counteraccount
	*			add record to teletrans
	*
	lSuccess:=oHlM:AppendSDF(oFm)
	oHlM:Gotop()
	if !SubStr(oHlM:MTLINE,1,5)==':940:'
		ErrorBox{self,"file "+oFm:Fullpath+" is not a MT940 file"}:Show()
		Return false
	endif
	nTrans:=0
	nImp:=0
   self:aValuesTrans:={}
	DO WHILE .not.oHlM:EOF
		* Search 25 record:
		IF !SubStr(oHlM:MTLINE,1,4)==":25:"
			oHlM:Skip()
			loop
		ENDIF
		lv_bankAcntOwn:=AllTrim(SubStr(oHlM:MTLINE,5))
		lv_bankAcntOwn:=ZeroTrim(StrTran(lv_bankAcntOwn,".",""))
		lv_bankAcntOwn:=Str(Val(lv_bankAcntOwn),-1)  // remove currency
		if	!lv_bankAcntOwn==	Cur_RekNrOwn
			Cur_RekNrOwn:=lv_bankAcntOwn
			Cur_enRoute:=""
			oBank:=SQLSelect{"select b.payahead,a.accnumber from bankaccount b, account a where not b.payahead is null and a.accid=b.payahead and banknumber='"+lv_bankAcntOwn+"'",oConn}
			if oBank:Reccount>0
				Cur_enRoute:=oBank:ACCNUMBER
			endif
		endif
		lv_reference:=""
		oHlM:Skip()
		DO WHILE .not.oHlM:EOF
			* Search for :61: (amount,book date), :86: (account, name, description) combinations:
			* Stop if new 25:
			IF SubStr(oHlM:MTLINE,1,4)==":25:"
				exit
			ENDIF
			IF SubStr(oHlM:MTLINE,1,4)==":28:"  // statement number + sequence number
				lv_reference:=AllTrim(SubStr(oHlM:MTLINE,5))
				if !lv_reference == lv_referenceCur
					lv_referenceCur:=lv_reference
					nBGCSeq:=0
				endif
			ENDIF
			IF !SubStr(oHlM:MTLINE,1,4)==":61:"
				oHlM:Skip()
				loop
			ENDIF
			do while SubStr(oHlM:MTLINE,1,4)==":61:" 
				// go through lines with amount and description

				lv_budget:=""
				lv_kind:=""
				lv_persid:=""
				lv_bankid:=""
				ld_bookingdate:=SToD("20"+SubStr(oHlM:MTLINE,5,6)) // valuta date 
				lv_description:=""
				
				nDC:=At("C",SubStr(oHlM:MTLINE,11,6))  //D or C
				IF nDC==0
					lv_addsub:="A"
					nDC:=At("D",SubStr(oHlM:MTLINE,11,6))  //D or C
				ELSE
					lv_addsub:="B"
				ENDIF
				nEndAmnt:= At("N",SubStr(oHlM:MTLINE,nDC+11,16))
				lv_AmountStr:=StrTran(SubStr(oHlM:MTLINE,nDC+11,nEndAmnt-1),",",cSep)
				lv_AmountStr:=StrTran(lv_AmountStr,".",cSep)
				lv_Amount:=Round(Val(lv_AmountStr),2)
				lv_NameContra:=""
				lv_BankAcntContra:=""
				* get contra bank account number:
				IF Len(oHlM:MTLINE)>nEndAmnt+nDC+20
					cText:=AllTrim(StrTran(SubStr(oHlM:MTLINE,nDC+11+nEndAmnt+3,16),"P",""))
					IF isnum(cText)
						lv_BankAcntContra:=ZeroTrim(StrTran(cText,"."))
					ENDIF
					* get contra name:
					IF Len(oHlM:MTLINE)>nEndAmnt+nDC+35
						lv_NameContra:=ZeroTrim(SubStr(oHlM:MTLINE,nDC+11+nEndAmnt+19))
					ENDIF
				ENDIF
				oHlM:Skip()
				lv_description:="" 
				IF !oHlM:EOF .and. SubStr(oHlM:MTLINE,1,4)==":86:"
					* description of transaction:
					lv_Oms:=AllTrim(SubStr(oHlM:MTLINE,5))
					IF !lMTExtended
						IF  Empty(lv_BankAcntContra) 
							IF lv_Oms = "GIRO "
								lv_BankAcntContra:= ZeroTrim(SubStr(lv_Oms,8,8))
								lv_description := AllTrim(SubStr(lv_Oms,16))
							ELSE
								cText := SubStr(lv_Oms,1,13)
								IF isnum(AllTrim(cText))
									lv_BankAcntContra:=ZeroTrim(StrTran(cText,"."))
									IF Val(lv_BankAcntContra)<100000000
										lv_BankAcntContra:=""
									ELSE
										lv_Oms := AllTrim(SubStr(lv_Oms,14))
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
							aWord:=GetTokens(lv_Oms)
							lv_NameContra:=aWord[Len(aWord),1] 
						endif 
					endif
					// 					Analyze first line: 
					cType86:=''
					nNumPos:=AtC('-nummer',lv_Oms)
					if AtC('BETREFT ACCEPTGIRO',lv_Oms)>0  .or. AtC('VX-NUMMER',lv_Oms)>0.or. AtC('CREDITEURENBETALING',lv_Oms)>0
						cType86:='BGC'
						if Empty(Cur_enRoute)
							(ErrorBox{,"for bank account "+ Cur_RekNrOwn+" no 'Account payments en route' specified; import aborted"}):Show()
							return false 
						endif
						lv_budget:=Cur_enRoute
						lv_kind:="BGC"
					elseif nNumPos>2
						cType86:='Bank'
					else
						cType86:="ADRES" 
						nLenLine1:=Len(lv_Oms)
					endif
					if nNumPos=0
						lv_description:=lv_Oms
					endif
					oHlM:Skip()
					// compose description:
					DO WHILE !oHlM:EOF .and. SubStr(oHlM:MTLINE,1,4)==":86:"  // all :86: with description
						lv_Oms:=AllTrim(SubStr(oHlM:MTLINE,5)) 
						if !lv_Oms="TRANSACTIEDATUM"             // skip line with "TRANSACTIEDATUM"
							self:GetPaymentPattern(lv_Oms,lv_addsub,@lv_budget,@lv_persid,@lv_bankid,@lv_kind)
							lv_description+=" "+lv_Oms
						endif
						oHlM:Skip()
					ENDDO 
					DO WHILE !oHlM:EOF .and. !(Occurs(":",SubStr(oHlM:MTLINE,1,6))=2)  // no TAG
						lv_Oms:=AllTrim(oHlM:MTLINE) 
						if !lv_Oms="TRANSACTIEDATUM".and. AtC('-nummer',lv_Oms)=0 ;   // skip line with "TRANSACTIEDATUM" or number
							.and. !(substr(lv_oms,1,2)='BE' .and. isdigit(substr(lv_oms,3)))  // skip belgié nummers
							self:GetPaymentPattern(lv_Oms,lv_addsub,@lv_budget,@lv_persid,@lv_bankid,@lv_kind)
							lv_description+=" "+lv_Oms
						endif
						oHlM:Skip()
					ENDDO
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
					elseif !cType86=='BGC'
						// address:
						nSepPos:=nlenLine1 // at end of first line with address
					endif
					if AtC('NAAM/NUMMER STEMMEN NIET OVEREEN',lv_description)>0 
						nSepPos:=0 
						//	look for	bankorder:
						oBord:=SQLSelect{"select a.accnumber from	bankorder o, account	a where banknbrcre="+lv_BankAcntContra+;
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
					lv_description:=Compress(lv_description)
				ENDIF 
				if Empty(lv_budget)
					// Look for budget code between * or [] or ()
					if (nOffset:=At('*',lv_description))>0 
						aBudg:=Split(SubStr(lv_description,nOffset+1),'*')
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
// 							if SQLSelect{"select accid from account where accnumber='"+lv_budget+"'",oConn}:Reccount<1   // no existing account?
// 								lv_budget:=""
// 							endif
						endif
					endif
					if Empty(lv_budget) .and. (nOffset:=At('[',lv_description))>0
						aBudg:=Split(SubStr(lv_description,nOffset+1),']') 
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
// 							if SQLSelect{"select accid from account where accnumber='"+lv_budget+"'",oConn}:Reccount<1   // no existing account?
// 								lv_budget:=""
// 							endif
						endif					
					endif
					if Empty(lv_budget) .and. (nOffset:=At('(',lv_description))>0
						aBudg:=Split(SubStr(lv_description,nOffset+1),')') 
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
// 							if SQLSelect{"select accid from account where accnumber='"+lv_budget+"'",oConn}:Reccount<1   // no existing account?
// 								lv_budget:=""
// 							endif
						endif
					endif
				else
// 					lv_budget:=iif(SQLSelect{"select accnumber from account where accnumber='"+lv_budget+"'",oConn}:Reccount>0,lv_budget,'')					
				endif
				lv_description:=AddSlashes(AllTrim(lv_description))
				lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))   //max length 32 in teletrans
				* save transaction:
				nTrans++
// 				IF !self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
					self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,Str(Val(lv_reference),-1),lv_BankAcntContra,;
					lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid)
// 				ENDIF
				lv_Oms:=""
			enddo     // end 61 /86 combinations
			exit
		ENDDO       // end :25 transaction
	ENDDO
	// store read data into database:
	oHlp:=FileSpec{oHlM:Filespec:Fullpath}
	oHlM:Close()
	oHlM:=null_object
	oHlp:DELETE()
	nImp:=self:lv_aant_toe
	nProc:= self:lv_processed
	lSuccess:=self:SaveTeleTrans(true,true)
	AAdd(self:aMessages,"Imported MT940 file:"+oFm:FileName+" "+Str(self:lv_aant_toe -nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
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
	
	oHlM :=HLPMT940{HelpDir+"\HMT"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
	
	lSuccess:=oHlM:AppendSDF(oFm)
	oHlM:Gotop()
	// First line contains own giro#:
	IF SubStr(oHlM:MTLINE,1,2)#"01"
		ErrorBox{,"File "+oFm:Fullpath+" is not a correct PG Autogiro file"}:Show()
		oHlM:Close()
		oHlM:=null_object
		RETURN false
	ENDIF
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
	nCnt:=self:lv_aant_toe
	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(true,false)
	AAdd(self:aMessages,"Imported PGAutoGiro file:"+oFm:FileName+" "+Str(self:lv_aant_toe -nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		return true
	else
		return false                                              
	endif

METHOD ImportPostbank( oFs as MyFileSpec ) as logic CLASS TeleMut
	* Import of postgiro data into teletrans
	LOCAL m57_laatste := {} as ARRAY
	LOCAL i, lName as int
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()),nImp,nTrans,nProc as int
	LOCAL lv_loaded as LOGIC,  hlpbank as USUAL
	LOCAL lv_addsub,lv_addsub,cCurrency,lv_description, lv_kind, lv_NameContra,lv_budget,lv_persid as STRING
	LOCAL lv_bankAcntOwn as STRING, lv_BankAcntContra as STRING, lv_Amount as FLOAT
	LOCAL lSuccess:=true as LOGIC
	LOCAL cSep as int
	LOCAL cDelim:="," as STRING
	LOCAL hl_boekdat as STRING
	LOCAL ptrHandle as MyFile
	LOCAL cBuffer as STRING, nRead as int
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate, ptAcc, ptDesc, ptTeg, ptCode, ptAfBij,ptBedr, ptSoort,ptMed as int
	LOCAL pbType as STRING
	LOCAL ld_bookingdate as date 
	local oStmnt as SQLStatement

	cSep:=SetDecimalSep(Asc(","))
	ptrHandle:=MyFile{oFs}
	pbType:=Upper(oFs:Extension)
	IF FError() >0
		//	(ErrorBox{,"Could not open file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine(ptrHandle)
	IF Empty(cBuffer)
		(ErrorBox{,"Could not read file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
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
	cBuffer:=ptrHandle:FReadLine(ptrHandle)
	aFields:=Split(cBuffer,cDelim)

	DO WHILE Len(AFields)>7
		lv_bankAcntOwn:=ZeroTrim(AFields[ptAcc])
		hl_boekdat:=AFields[ptDate]
		IF Len(hl_boekdat)=8
			ld_bookingdate:=SToD(hl_boekdat)
		ELSE
			ld_bookingdate:=SToD(SubStr(hl_boekdat,7,4)+;
				SubStr(hl_boekdat,4,2)+SubStr(hl_boekdat,1,2))
		ENDIF
		++nTrans
		IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_NameContra:=AllTrim(AFields[ptDesc])
		lName:=Len(lv_NameContra)
		lv_description:=AllTrim(AFields[ptMed])
		IF Instr("CREDIT",lv_description)
			lv_description=lv_description
		ENDIF
		//lv_description := SubStr(lv_description,1,32)+' '+SubStr(lv_description,33,32)+' '+SubStr(lv_description,65,32)+' '+SubStr(lv_description,97)
		IF lv_NameContra==SubStr(lv_description,1,lName)
			* haal naam eruit:
			lv_description:=Trim(SubStr(lv_description,lName+1))
		ENDIF
		lv_description:=AllTrim(Compress(lv_description))
		lv_NameContra:=AllTrim(Compress(lv_NameContra))
		lv_addsub:=PadR(AFields[ptCode],3)
		lv_addsub:=SubStr(AFields[ptAfBij],1,1)
		cCurrency := "EUR"
		lv_kind:=AFields[ptSoort]		
		IF Empty(lv_kind)  && alleen mutaties laden
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		IF lv_addsub # "A".and.lv_addsub # "B"    && alleen Af/BIJ-mutaties laden
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		IF lv_addsub=="A"    && geen mededelingen laden
			IF "OPDRACHT NIET VERWERKT" $ Upper(lv_description)
				cBuffer:=ptrHandle:FReadLine(ptrHandle)
				aFields:=Split(cBuffer,cDelim)
				loop
			ENDIF
		ENDIF
		lv_BankAcntContra:=Str(Val(AFields[ptTeg]),-1)
		lv_Amount:=Val(AFields[ptBedr])
		IF Empty(lv_Amount)  && geen lege mutaties laden
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
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
	  	lv_description:=AddSlashes(AllTrim(lv_description))
  		lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))
	  	lv_BankAcntContra:=ZeroTrim(lv_BankAcntContra)
		self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,'',lv_BankAcntContra,;
		lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid)
		lv_description:="" 
		nTrans++
		
// 		* controleer op reeds geladen zijn van mutatie:
// 		IF self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,lv_addsub,lv_BankAcntContra,lv_NameContra,"")
// 			cBuffer:=ptrHandle:FReadLine(ptrHandle)
// 			aFields:=Split(cBuffer,cDelim)
// 			LOOP
// 		ENDIF 
// 		oStmnt:=SQLStatement{"insert into teletrans set "+;
// 			"contra_bankaccnt='"+lv_BankAcntContra+"'"+;
// 			",contra_name='"+lv_NameContra+"'"+;
// 			",bankaccntnbr='"+lv_bankAcntOwn+"'"+;
// 			",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
// 			",kind='"+lv_addsub +"'"+;
// 			",amount='"+Str(lv_Amount,-1)+"'"+;
// 			",addsub='"+lv_addsub +"'"+;
// 			",code_mut_r='"+"M"+"'"+;
// 			",description='"+lv_description +"'",oConn}
// 		oStmnt:Execute()
// 		if oStmnt:NumSuccessfulRows>0
// 			++self:lv_aant_toe
// 			++nImp
// 		endif
		cBuffer:=ptrHandle:FReadLine(ptrHandle)
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	ptrHandle:=null_object 
	SetDecimalSep(cSep)  // restore decimal separator
	nImp:=self:lv_aant_toe
	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(false,false)
	AAdd(self:aMessages,"Imported ING file:"+oFs:FileName+" "+Str(self:lv_aant_toe -nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		return true
	else
		return false                                              
	endif
METHOD ImportRO(oFb) CLASS TeleMut
	* Import of Romenian Banca Transilvania into Mutgiro.dbf
	LOCAL oHlS as HulpSA
	LOCAL m57_laatste := {} as ARRAY
	LOCAL i, TelPtr as int
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()) as int
	LOCAL lv_geladen as LOGIC,  hlpbank as USUAL
	LOCAL lv_description,lv_descriptionPrv, lv_bankAcntOwn,lv_addsub,lv_BankAcntContra,lv_persid,lv_kind,lv_NameContra,lv_budget as STRING
	LOCAL cSep as int
	LOCAL lSuccess:=true as LOGIC
	LOCAL cDelim:=';' as STRING
	LOCAL ptrHandle as MyFile
	LOCAL cBuffer as STRING, nRead as int
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate, ptDeb,ptCre, ptDesc, ptCur,  nVnr,nCnt,nTot,nProc as int
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
	do while !Left(cBuffer,15)=='Data tranzactie'
		cBuffer:=ptrHandle:FReadLine()
	enddo	
	if !GetDelimiter(cBuffer,@aStruct,@cDelim,5,6)
		(ErrorBox{,self:oLan:Wget("Wrong fileformat of importfile from Transilvania Bank")+": "+oFb:FullPath+"("+self:oLan:Wget("See help")+")"}):show()
		ptrHandle:Close()
		RETURN FALSE
	ENDIF
	ptDate:=AScan(aStruct,{|x| "DATA TRANZACTIE" $ x})
	ptDesc:=AScan(aStruct,{|x| "DESCRIERE" $ x})
	ptDeb:=AScan(aStruct,{|x| "DEBIT" $ x})
	ptCre:=AScan(aStruct,{|x| "CREDIT" $ x})
	IF ptDate==0 .or. ptDesc==0 .or. ptDeb==0.or. ptCre==0   
		(ErrorBox{,self:oLan:Wget("Wrong fileformat of importfile from Transilvania Bank")+": "+oFb:FullPath+"("+self:oLan:Wget("See help")+")"}):show()
		RETURN FALSE
	ENDIF
	cSep:=SetDecimalSep(Asc("."))

	cBuffer:=ptrHandle:FReadLine()   // skip first line
	// skip balance line:
	aFields:=Split(cBuffer,cDelim)
	if Empty(AFields[ptDate])
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim)
	endif

	DO WHILE Len(AFields)>3
		ld_bookingdate:=SToD(StrTran(AFields[ptDate],'-',''))
		IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_description:=iif(Empty(lv_descriptionPrv),'',lv_descriptionPrv+' ')+AllTrim(StrTran(AllTrim(AFields[ptDesc]),'"','')) 
		lv_descriptionPrv:=''
		if Upper(lv_description)=="SOLD CONTABIL"
			cBuffer:=ptrHandle:FReadLine(ptrHandle)   // skip balance lines
			aFields:=Split(cBuffer,cDelim) 
			loop
		ENDIF
		lv_Amount:=Round(Val(StrTran(StrTran(AFields[ptCre],'"',''),',',''))+Val(StrTran(StrTran(AFields[ptDeb],'"',''),',','')),DecAantal)
		IF Empty(lv_Amount)  && skip empty transactions
			IF SubStr(lv_description,1,4)=='Ref:' 
				lv_descriptionPrv:=lv_description
			endif
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
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
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	ptrHandle:=null_object
	SetDecimalSep(cSep)  // restore decimal separator
	nCnt:=self:lv_aant_toe
	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(false,false)
	AAdd(self:aMessages,"Imported Transilvania file:"+oFb:FileName+" "+Str(self:lv_aant_toe -nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
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
	LOCAL cSep as int
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
	LOCAL lv_Amount, Hl_balan as FLOAT
	LOCAL ld_bookingdate as date 
	local oStmnt as SQLStatement

	lv_bankAcntOwn:=SubStr(oFs:FileName,11)
	lv_bankAcntOwn:=ZeroTrim(SubStr(lv_bankAcntOwn,1,At("-",lv_bankAcntOwn)-1))
	cSep:=SetDecimalSep(Asc("."))
	ptrHandle:=MyFile{oFs}
	pbType:=Upper(oFs:Extension)
	IF FError() >0
		(ErrorBox{,"Could not open file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine(ptrHandle)
	IF Empty(cBuffer)
		(ErrorBox{,"Could not read file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	//cDelim:=','
	aStruct:=Split(Upper(cBuffer),cDelim)
	IF Len(aStruct)<5
		(ErrorBox{,"Wrong fileformat of importfile from Standard Bank: "+oFs:FullPath+"(See help)"}):show()
		RETURN FALSE
	ENDIF
	ptDate:=AScan(aStruct,{|x| "DATE" $ x})
	ptDesc:=AScan(aStruct,{|x| "DESCRIPTION" $ x})
	ptPay:=AScan(aStruct,{|x| "PAYMENTS" $ x})
	ptDep:=AScan(aStruct,{|x| "DEPOSITS" $ x})
	ptBal:=AScan(aStruct,{|x| "BALANCE" $ x})
	IF ptDate==0 .or. ptDesc==0 .or. ptPay==0 .or. ptDep==0 .or. ptBal==0
		(ErrorBox{,"Wrong fileformat of importfile from Standard Bank: "+oFs:FullPath+"(See help)"}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine(ptrHandle)   // skip first line
	cBuffer:=ptrHandle:FReadLine(ptrHandle)
	aFields:=Split(cBuffer,cDelim)

	DO WHILE Len(AFields)>4
		hl_boekdat:=AFields[ptDate]
		ld_bookingdate:=SToD(SubStr(hl_boekdat,1,4)+SubStr(hl_boekdat,6,2)+SubStr(hl_boekdat,9,2))
		IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_description:=AllTrim(StrTran(AllTrim(AFields[ptDesc]),'"',''))
		lv_Amount:=AbsFloat(Val(AFields[ptPay]))
		IF lv_Amount=0
			lv_Amount:=Val(AFields[ptDep])
			lv_addsub:="B"
		ELSE
			lv_addsub:="A"
		ENDIF
		IF Empty(lv_Amount)  && no empty lines
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
			aFields:=Split(cBuffer,cDelim)
			loop
		ENDIF
		lv_Amount:=Round(lv_Amount,DecAantal)
		Hl_balan:=Val(AFields[ptBal])
		lv_description:=AddSlashes(AllTrim(lv_description))
		nTot++
		self:AddTeleTrans(lv_bankAcntOwn,Min(Today(),ld_bookingdate),Str(Val(SubStr(lv_description,-4,4)),-1),lv_BankAcntContra,;     // no dates in the future)
		lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid)
		lv_description:=""
		//     * controleer op reeds geladen zijn van mutatie:
		// 	IF self:AllreadyImported(ld_bookingdate,lv_amount,lv_addsub,lv_description,"SAB","","","")
		// 		cBuffer:=ptrHandle:FReadLine(ptrHandle)
		// 		aFields:=Split(cBuffer,cDelim)
		//         loop
		// 	ENDIF
		// 	oStmnt:=SQLStatement{"insert into teletrans set	"+;
		// 		"bankaccntnbr='"+lv_bankAcntOwn+"'"+;
		// 		",bookingdate='"+SQLdate(Min(Today(),ld_bookingdate))+"'"+;  // no dates in the future)+"'"+;
		// 		",kind='SAB'"+;
		// 		",amount='"+Str(lv_amount,-1)+"'"+;
		// 		",addsub='"+lv_addsub	+"'"+;
		// 		",code_mut_r='M'"+;
		// 		",seqnr='"+Str(Val(SubStr(lv_description,-4,4)),-1)+"'"+;
		// 		",description='"+lv_description	+"'",oConn}
		// 	oStmnt:Execute()
		// 	if	oStmnt:NumSuccessfulRows>0
		// 		++lv_aant_toe
		// 		nCnt++
		// 	endif
		cBuffer:=ptrHandle:FReadLine(ptrHandle)
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	ptrHandle:=null_object
	SetDecimalSep(cSep)  // restore decimal separator
	nCnt:=self:lv_aant_toe
	nProc:=lv_processed 
	lSuccess:=self:SaveTeleTrans(false,false)
	AAdd(self:aMessages,"Imported SA file:"+oFb:FileName+" "+Str(self:lv_aant_toe -nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
	if lSuccess
		return true
	else
		return false                                              
	endif
	
	// AAdd(self:aMessages,"Imported SA file:"+oFb:FileName+" "+Str(nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions")

	RETURN true
METHOD ImportTL1(oFm as MyFileSpec) as logic CLASS TeleMut
	* Import of Total IN  data of Swedisch PlusGiroT into teletrans.dbf
	*	Import of one TL1 telebnk transaction file
	LOCAL oHlM as HlpMT940
	LOCAL i, nEndAmnt, nDC,nCnt,nTot,nProc as int
	LOCAL lv_bankAcntOwn, lv_Oms, lv_addsub, lv_AmountStr, lv_reference,lv_NameContra, lv_address,lv_zip,lv_city, lv_country, lv_description,lv_budget,lv_persid as STRING
	LOCAL lv_loaded as LOGIC,  lv_BankAcntContra as string, cText, recordcode as STRING
	LOCAL lv_Amount as FLOAT
	LOCAL cSep as STRING
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

	
	oHlM :=HLPMT940{HelpDir+"\HMT"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
	cSep:=CHR(SetDecimalSep())
	*Look for 2: record with transction record
	*			add record to teletrans
	*
	lSuccess:=oHlM:AppendSDF(oFm)
	oHlM:Gotop()
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
	nCnt:=self:lv_aant_toe
	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(false,false)
	AAdd(self:aMessages,"Imported TL/1 file:"+oFm:FileName+" "+Str(self:lv_aant_toe -nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
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
	lSuccess:=self:SaveTeleTrans(true,true)
	AAdd(self:aMessages,"Imported UA file:"+oFr:FileName+" "+Str(self:lv_aant_toe -nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions")
	if lSuccess
		return true
	else
		return false                                              
	endif
METHOD ImportVerwInfo(oFm as MyFileSpec) as logic CLASS TeleMut
	* Import of VerwerkingsInfo data from Equens into teletrans.dbf
	*	Import of one VerwInfo telebnk transaction file
	LOCAL oHlM as HlpMT940
	LOCAL i, nEndAmnt, nDC, nTrans,nTot,nProc as int
	LOCAL lv_bankAcntOwn, lv_description, lv_Oms, lv_addsub, lv_AmountStr, lv_kind, lv_NameContra, lv_straat, lv_woonplaats as STRING
	Local betkenm as string
	LOCAL lv_loaded as LOGIC,  lv_BankAcntContra, lv_budget,lv_persid as string, cText, recordcode, batchsoort as STRING
	LOCAL lv_Amount as FLOAT
	LOCAL cSep as STRING
	LOCAL lSuccess:=true as LOGIC
	LOCAL oHlp as FileSpec
	LOCAL ld_bookingdate as date 
	local oDue as SQLSelect, oAcc as SQLSelect
	local oStmnt as SQLStatement
	
	oHlM :=HLPMT940{HelpDir+"\HMT"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
	cSep:=CHR(SetDecimalSep())
	*Look for 2: record with transction record
	*			add record to teletrans
	*
	lSuccess:=oHlM:AppendSDF(oFm)
	oHlM:Gotop()
	oHlM:Skip() 
	// second record type of batch:
	batchsoort:=SubStr(oHlM:MTLINE,43,1)
	if batchsoort=="B" .or. batchsoort=="D"
		// only A= refused orders and C=acceptgiro
		oHlM:Close()
		return false 
	endif
	oHlM:Skip()
   self:aValuesTrans:={}
	DO WHILE .not.oHlM:EOF
		* Search Post record 1 record:
		IF !SubStr(oHlM:MTLINE,1,3)=="100"
			oHlM:Skip()
			loop
		ENDIF
		lv_bankAcntOwn:=ZeroTrim(AllTrim(SubStr(oHlM:MTLINE,27,10)))
		lv_BankAcntContra:=ZeroTrim(AllTrim(StrTran(SubStr(oHlM:MTLINE,17,10),"P","")))
		lv_Amount:=Round(Val(AllTrim(SubStr(oHlM:MTLINE,4,13)))/100.00,2)
		lv_addsub:=iif(batchsoort=="A","A","B") 
		lv_Oms:=""
		lv_budget:=""
		lv_persid:=""
		lv_kind:=""
		lv_NameContra:=""
		lv_straat:=""
		lv_woonplaats:=""
		ld_bookingdate:=SToD(" ")
		oHlM:Skip() 
		// determine additional info:
		do WHILE !oHlM:EOF .and.(!SubStr(oHlM:MTLINE,1,3)=="100")
			recordcode:= SubStr(oHlM:MTLINE,1,3)
			DO CASE
			CASE recordcode=="105"
				// bet.kenmerk: 
				betkenm:=SubStr(oHlM:MTLINE,4,16)
				lv_Oms:=betkenm+" "+lv_Oms
				if batchsoort=="A"          // storno
					lv_kind:="CLL" 
					lv_persid:=ZeroTrim(SubStr(betkenm,2,5)) 
					oDue:=SQLSelect{"select a.accnumber from account a, dueamount d, subscription s where s.subscribid=d.subscribid and s.accid=a.accid and "+;
						"s.personid="+lv_persid+" and d.invoicedate='"+;
						SQLdate(SToD(SubStr(betkenm,7,8)))+"' and seqnr="+ZeroTrim(SubStr(betkenm,15)),oConn} //persid + DTOS(invoicedate) + seqnr
					if oDue:Reccount>0
						lv_budget:= oAcc:ACCNUMBER
					endif
				else	 
					lv_kind:="ACC"
					lv_persid:=SubStr(betkenm,-5)
					lv_budget:=SubStr(betkenm,2,Len(betkenm)-6)
					if Val(SubStr(lv_budget,6))==0
						lv_budget:=LTrimZero(SubStr(lv_budget,1,5))
					endif
				endif
				
			CASE recordcode=="110"
				// omschrijving:
				lv_Oms+=Compress(SubStr(oHlM:MTLINE,4,32))+" " 
			CASE recordcode=="115"
				// bankinfo
				lv_Oms+=Compress(SubStr(oHlM:MTLINE,4,30))+" " 
			CASE recordcode=="500"
				// vereveningsdatum:
				ld_bookingdate:=SToD("20"+SubStr(oHlM:MTLINE,30,6)) // book date
				lv_kind:=SubStr(oHlM:MTLINE,36,4)	// banken transactiecode
				if lv_kind=="1144" .or. lv_kind="1145"
					lv_kind:="ACC" // acceptgiro 
				elseif SubStr(lv_kind,1,3)=="022"
					lv_kind:="COL"
				endif			
			CASE recordcode=="505"
				// naam:
				lv_NameContra:=AllTrim(SubStr(oHlM:MTLINE,4,35))
			CASE recordcode=="510"
				// straat:
				lv_straat:=AllTrim(SubStr(oHlM:MTLINE,4.35))
				if Len(lv_straat)>1 .and. IsUpper(SubStr(lv_straat,2,1))
					lv_straat:=Upper(substr(lv_straat,1,1))+Lower(substr(lv_straat,2))
				endif
			CASE recordcode=="515"
				// woonplaats:
				lv_woonplaats:=AllTrim(SubStr(oHlM:MTLINE,4.35))
			CASE recordcode=="600"
				// signaalkode: 
				lv_Oms+="Storno: "+AllTrim(SubStr(oHlM:MTLINE,8,32))+" " 			
			END CASE			
			oHlM:Skip()
		ENDDO
		* save transaction: 
		lv_description:=""
		if !Empty(lv_NameContra)
			lv_description+="<n>"+lv_NameContra+"</n>"
		endif
		if !Empty(lv_straat)
			lv_description+="<a>"+lv_straat+"</a>"
		endif
		if !Empty(lv_woonplaats)
			lv_description+="<t>"+lv_woonplaats+"</t>"
		endif
		if !Empty(lv_Oms)
			lv_description+="<d>"+AllTrim(lv_Oms)+"</d>"
		endif
		lv_description:=AddSlashes(AllTrim(lv_description))
		lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))
		nTot++ 
		self:AddTeleTrans(lv_bankAcntOwn,ld_bookingdate,'',lv_BankAcntContra,;
			lv_kind,lv_NameContra,lv_budget,lv_Amount,lv_addsub,lv_description,lv_persid)
		lv_description:=""
	ENDDO

	oHlp:=FileSpec{oHlM:FileSpec:FullPath}
	oHlM:Close()
	oHlM:=null_object
	oHlp:DELETE()
	nTrans:=self:lv_aant_toe
	nProc:=self:lv_processed 
	lSuccess:=self:SaveTeleTrans(true,true)
	AAdd(self:aMessages,"Imported VerwInfo file:"+oFm:FileName+" "+Str(self:lv_aant_toe -nTrans,-1)+" imported of "+Str(nTot,-1)+" transactions, processed automatically:"+Str(self:lv_processed-nProc,-1))
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

	IF Gift
		self:InitTeleGift()
	ELSE
		self:InitteleNonGift()
	ENDIF
	RETURN self
METHOD InitTeleGift() CLASS TeleMut
	//oBank:SetFilter("!Empty(telebankng)")
	
METHOD InitTeleNonGift() CLASS TeleMut
	LOCAL lSuc as LOGIC
	local oTelPat as SQLSelect
// 	oTelPat:=SQLSelect{"select * from TeleBankPatterns where accid>0 and kind<>'' and contra_bankaccnt<>'' and addsub<>'' and description<>''",oConn}
	oTelPat:=SqlSelect{"select contra_bankaccnt,kind,contra_name,addsub,description,accid,cast(ind_autmut as signed) as ind_autmut from telebankpatterns where accid>0",oConn} 
	oTelPat:execute()
	DO WHILE !oTelPat:EOF
		AAdd(self:teleptrn,{oTelPat:contra_bankaccnt,;
			oTelPat:kind,;
			oTelPat:contra_name,;
			oTelPat:AddSub,;
			split(oTelPat:description,space(1)),;
			Str(oTelPat:accid,-1),;
			iif(ConI(oTelPat:ind_autmut)==1,true,false)})
		oTelPat:skip()
	ENDDO
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
		IF .not.Empty(self:m56_budgetcd).and..not.IsAlpha(self:m56_budgetcd)
			self:m56_accnumber:=self:m56_budgetcd
			self:m56_recognised:=true
			if (self:m56_kind=="CLL" .or.self:m56_kind=="COL") .and. self:m56_addsub=="A"   // storno:
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
			self:CheckPattern()
		ENDIF
		RETURN true
	ENDDO

	RETURN FALSE
method SaveTeleTrans(lCheckPerson:=true as logic,lCheckAccount:=true as logic) as logic class TeleMut
	local oStmnt as SQLStatement
	local oSel as SQLSelect
	local oMBal as Balances
	local cPersids,cBudgetcds,cBudgetcd,cBankContr,cBankAcc,cBankAcc2,lv_description,lv_specmessage,lv_gc,lv_persid,cBankAccOwn,lv_accid,cDestAcc as string 
	local	lAddressChanged,lProcAuto as logic
	local aPersids:={}, aPersidsDb:={} as array 
	local aBudgetcd:={}, aAccnbrDb:={} as array
	local aBankContra:={},aBankCont:={} as array  // {{bankacc,persid,ismember},...}
	local avalueTrans:=self:aValuesTrans as array
	local aAddr:={},aAddrDB:={} // address: {streetname,housenbr} 
	local i,j,k,l,nProc,nTransId,nTele,maxTeleId,nSeqnbr as int
	local fDeb,fDebForgn,fCre,fCreForgn as float 
	local aTrans:={} as array  // array with values to be inserted into table transaction:
	//aTrans: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid 
	//          1    2     3      4      5      6            7      8   9  10      11         12    13     14       15      16
	local aTransIncExp:={} as array // array like aTrans for ministry income/expense transactions   
	local avaluesPers:={} as array // {persid,dategift},...  array with values to be updated into table person 
	local aZip:={} as array // {persid,postalcode},...   array with postalcode per person
	local oAddInc as AddToIncExp 
	// 	local time1,time0 as float
	// 	(time1:=Seconds()) 
	if Len(avalueTrans)=0
		return true
	endif
	// bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,processed 
	//      1            2        3          4           5      6           7      8      9        10        11       12
	if lCheckPerson
		//
		// check if persid's belongs to persons
		//
		cPersids:=Implode(avalueTrans,',',,,11)
		if !Empty(cPersids)
			oSel:=SqlSelect{"select group_concat(gr.grpersid) as grpersids from (select cast(persid as char) as grpersid from person where persid in ("+cPersids+") and deleted=0) as gr group by 1=1",oConn}
			if oSel:RecCount>0
				aPersidsDb:=Split(oSel:grpersids,',')
				AEval(aPersidsDb,{|x|AAdd(aZip,Split(x,','))})
				aevala(aPersidsDb,{|x|split(x,',')[1]})
			endif
			aPersids:=Split(cPersids,',')
			// compare both arrays 
			for i:=1 to Len(aPersids)
				if AScanExact(aPersidsDb,aPersids[i])=0
					// remove persid from aValuesTrans: 
					j:=AScanExact(avalueTrans,{|x|x[11]=aPersids[i]})
					if j>0
						avalueTrans[j,11]:='0'
					endif
				endif
			next
		endif
		//
		// complete persid from contrabankaccount:
		//
		AEval(aValueTrans,{|x|cBankContr+=iif(empty(x[4]).or.!empty(x[11]),'',','+x[4])})
		if !Empty(cBankContr)
			oSel:=SqlSelect{"select group_concat(gr.banknumber,',',gr.grpersid,',',gr.ismember separator '#') as grpersids from (select cast(p.persid as char) as grpersid,banknumber,if(m.mbrid IS NULL,'0','1') as ismember from personbank p left join member m on (m.persid=p.persid) where banknumber in ("+SubStr(cBankContr,2)+")) as gr group by 1=1",oConn}
			if oSel:RecCount>0 
				aBankCont:=Split(oSel:grpersids,'#') 
				if Len(aBankCont)>0
					AEval(aBankCont,{|x|AAdd(aBankContra,Split(x,','))}) 
					i:=0
					do while i<Len(avalueTrans)
						i:=AScan(avalueTrans,{|x|!Empty(x[4]).and.Empty(x[11])},i+1)
						if i>0
							cBankAcc:=avalueTrans[i,4]
							j:=AScan(aBankContra,{|x|x[1]==cBankAcc})
							if j>0							
								avalueTrans[i,11]:=aBankContra[j,2]
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
			if oSel:RecCount>0
				aAccnbrDb:=Split(oSel:graccnumber,',')
			endif
			// compare both arrays 
			for i:=1 to Len(aBudgetcd)
				if AScanExact(aAccnbrDb,aBudgetcd[i])=0
					// remove budgetcd from aValuesTrans:
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
	endif
	//
	// complete budgetcodes from gifts to single destinations:  
	//
	i:=0
	lv_description:=self:oLan:WGet('Gift') 
	do while i<Len(avalueTrans)
		// aValuesTrans:
		// bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,processed 
		//      1            2        3          4           5      6           7      8      9        10        11       12
		i:=AScan(avalueTrans,{|x|Empty(x[7]) .and.x[9]='B'},i+1)
		if i>0
			cBankAcc:=avalueTrans[i,1] 
			//m57_bankacc: banknumber, usedforgifts, datlaatst, giftsall,singledst,destname,accid,payahead,singlenumber,fgmlcodes,syscodover
			//                 1            2           3          4         5          6      7      8           9		  10           11
			j:=AScan(self:m57_bankacc,{|x|x[1]==cBankAcc.and.x[9]>'0'})
			if j>0							
				avalueTrans[i,7]:=self:m57_bankacc[j,9]
			endif
		else
			exit
		endif
	enddo
	
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
		oSel:=SqlSelect{"select group_concat(gr.accnumber,',',gr.graccid,',',gr.ismember separator '#') as graccnumber "+;
			"from (select a.accnumber,cast(a.accid as char) as graccid,if(m.mbrid IS NULL,'0','1') as ismember "+;
			"from account a left join department d on (d.depid=a.department) "+;
			"left join member as m on (a.accid=m.accid or m.depid=d.depid) "+; 
		" where accnumber in ("+cBudgetcds+") ) as gr group by 1=1",oConn}
		if oSel:RecCount>0
			aAccnbrDb:=Split(oSel:graccnumber,'#')
			AeValA(aAccnbrDb,{|x|split(x,',')})
		endif
	endif
	// Gifts:
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
			oSel:=SqlSelect{"select	group_concat(gr.grpersid,',',postalcode,',',address separator	'#') as grpersids	from (select cast(persid as char) as grpersid,postalcode,address from person	where	persid in ("+SubStr(cPersids,2)+") and deleted=0) as gr group by 1=1",oConn}
			if	oSel:RecCount>0
				aZip:=Split(oSel:grpersids,'#')
				aevala(aZip,{|x|split(x,',')})
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
			j:=AScan(self:m57_bankacc,{|x|x[1]==cBankAcc})
			if j>0							
				// 					if self:m57_bankacc[j,4] .and.self:m57_bankacc[j,5]>'0'.or.; // single destination and giftsall, i.e. automatic processing of all gifts?
				if self:m57_bankacc[j,4].or.; // giftsall, i.e. automatic processing of all gifts?
					self:m57_bankacc[j,2] .and. ;   // used for gifts
					((self:m57_bankacc[j,8]>'0' .and.	(aValueTrans[i,5]='ACC'.or.aValueTrans[i,5]='KID'.or.aValueTrans[i,5]='COL')).or.;  // payahead filled for acceptgiro
					(Trim(aValueTrans[i,5])="AC" .or.(SubStr(aValueTrans[i,10],17,2)=="AC").and.isnum(SubStr(aValueTrans[i,10],1,16))))

					lv_persid:=avalueTrans[i,11]
					// 						if AtC("Dassenbos 149",aValueTrans[i,10])>0
					// 							aValueTrans[i,10]:=aValueTrans[i,10]
					// 						endif
					if Val(lv_persid)>0
						if !CountryCode=="31" .or.;
								!SpecialMessage(avalueTrans[i,10], self:m57_bankacc[j,6],@lv_specmessage)  // with special message manually processed
							lAddressChanged:=false
							if CountryCode=="31"
								// check no address change
								k:=AScan(aZip,{|x|x[1]==lv_persid})
								if k>0
									self:GetAddress(avalueTrans[i,10],false)
									if !Empty(self:m56_zip) .and.Len(self:m56_zip)>=7
										IF !self:m56_zip==aZip[k,2] .and.!Empty(aZip[k,2]) 
											lAddressChanged:=true
										ENDIF
									elseif Len(self:m56_address)>1 .and.!Lower(self:m56_address)==Lower(aZip[k,3])
										aAddr:=GetStreetHousnbr(self:m56_address)
										aAddrDB:=GetStreetHousnbr(aZip[k,3]) 
										if !Val(aAddr[2])==Val(aAddrDB[2])      // unequal housenumbers-> moved
											if !Empty(aZip[k,2]) 
												self:GetAddress(avalueTrans[i,10],true)   // now with getting zip code from internet:
												if !Empty(self:m56_zip) .and.Len(self:m56_zip)>=7
													IF !self:m56_zip==aZip[k,2]  
														lAddressChanged:=true
													ENDIF
												else
													lAddressChanged:=true
												endif
											else
												lAddressChanged:=true
											endif
										endif
									endif
								endif
							endif
							if !lAddressChanged 
								cBudgetcd:=avalueTrans[i,7]
								if (l:=AScan(aAccnbrDb,{|x|x[1]==cBudgetcd}))>0
									avalueTrans[i,12]:='X'   // record as processed 
									// transaction can be processed automatically:
									nProc++ 
									
									// add to transaction array:
									//aTrans: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid 
									//          1    2     3      4      5      6            7      8   9  10      11         12    13     14       15     16      
									// first row: 
									cBankAccOwn:=self:m57_bankacc[j,7]
									if self:m57_bankacc[j,8]>'0' .and.	(aValueTrans[i,5]='ACC'.or.aValueTrans[i,5]='KID'.or.aValueTrans[i,5]='COL')  // acceptgiro
										cBankAccOwn:=self:m57_bankacc[j,8]
									endif
									AAdd(aTrans,{cBankAccOwn,aValueTrans[i,8],aValueTrans[i,8],0.00,0.00,sCurr,lv_description+iif(aValueTrans[i,5]="AC",'',' '+lv_specmessage),;
										aValueTrans[i,2],'',LOGON_EMP_ID,'1','1',aValueTrans[i,5]+aValueTrans[i,3],'','',''} ) 
									// second row: 
									if aAccnbrDb[l,3]='1'  //destination member?
										lv_gc:='AG'
										if AScan(aBankContra,{|x|x[2]==lv_persid .and.x[3]='1'})>0    // giver member?
											lv_gc:='MG'
										endif
									else
										lv_gc:=''
									endif
									AAdd(aTrans,{aAccnbrDb[l,2],0.00,0.00,aValueTrans[i,8],aValueTrans[i,8],sCurr,lv_description+iif(aValueTrans[i,5]="AC",'',' '+lv_specmessage),;
										aValueTrans[i,2],lv_gc,LOGON_EMP_ID,'1','2',aValueTrans[i,5]+aValueTrans[i,3],'',aValueTrans[i,11],''} )
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
	// non-gifts:
	// aValuesTrans:
	// bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,processed 
	//      1            2        3          4           5      6           7      8      9        10        11       12
	i:=0
	do while i<Len(avalueTrans)
		i:=AScan(avalueTrans,{|x|(Val(x[11])=0 .or.x[9]='A') .and.!x[12]='X'},i+1)   // non-gifts with known destination 
		if i=0                //          !Empty(x[4]).or.!Empty(x[7]))
			exit
		endif
		
		cBankAcc:=avalueTrans[i,1] 
		//m57_bankacc: banknumber, usedforgifts, datelatest, giftsall,singledst,destname,accid,payahead,singlenumber,fgmlcodes,syscodover
		//                 1            2           3          4         5          6      7      8          9          10        11
		j:=AScan(self:m57_bankacc,{|x|x[1]==cBankAcc})
		if j>0							
			lProcAuto:=false
			if !Empty(aValueTrans[i,4]) .and.Empty(aValueTrans[i,7])   // contra_bankaccnt but no budgetcd
				// check if cross banking?
				IF !Empty(SKruis).and.!Empty(avalueTrans[i,4])
					cBankAcc:=avalueTrans[i,4] 
					k:=AScan(self:m57_bankacc,{|x|x[1]==cBankAcc}) 
					if k>0
						// cross banking:
						cDestAcc:=SKruis
						if Empty(aValueTrans[i,10])  // empty description?
							avalueTrans[i,10]:='Clearing'
						endif
						lProcAuto:=true
					endif
				endif
			elseif (!Empty(aValueTrans[i,7]).and.(self:m57_bankacc[j,8]>'0' .and.	aValueTrans[i,5]=='BGC');  // payahead filled for collective recording of acceptgiro's
				.or.avalueTrans[i,9]=='A') //debit with known destination?
				cBudgetcd:=avalueTrans[i,7]
				if (l:=AScan(aAccnbrDb,{|x|x[1]==cBudgetcd}))>0
					cDestAcc:=aAccnbrDb[l,2]
					lProcAuto:=true
				endif
			ELSEIF (aValueTrans[i,5]=="IC" .or.aValueTrans[i,5]=="OCR") .and.Empty(aValueTrans[i,4]).and.aValueTrans[i,9] =="B" .and.self:m57_bankacc[j,8]>'0'  // payahead for OCR
				// in case of recording of automatic collections take payahead as contra account:
				cDestAcc:=self:m57_bankacc[j,8]
				lProcAuto:=true
			endif
			if lProcAuto
				avalueTrans[i,12]:='X'   // record as processed 
				// transaction can be processed automatically:
				nProc++ 
				
				// add to transaction array:
				//aTrans: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid 
				//          1    2     3      4      5      6            7      8   9  10      11         12    13     14       15     16      
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
				endif
				AAdd(aTrans,{cBankAccOwn,fDeb,fDebForgn,fCre,fCreForgn,sCurr,avalueTrans[i,10],;
					aValueTrans[i,2],'',LOGON_EMP_ID,'1','1',aValueTrans[i,5]+aValueTrans[i,3],'','',''} ) 
				// second row: 
				AAdd(aTrans,{cDestAcc,fCre,fCreForgn,fDeb,fDebForgn,sCurr,avalueTrans[i,10],;
					aValueTrans[i,2],'',LOGON_EMP_ID,'1','2',aValueTrans[i,5]+aValueTrans[i,3],'',lv_persid,''} )
			endif
		endif
	enddo
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// Execute database statements
	//
	//////////////////////////////////////////////////////////////////////////////////////////////////////////           
	
	if Len(aTrans)>0
		if !Empty(SINCHOME) .or.!Empty(SINC)
			// add transactions for ministry income/expense:
			oAddInc:=AddToIncExp{}
			for i:=2 to Len(aTrans) step 2
				nSeqnbr:=2 
				aTransIncExp:=oAddInc:AddToIncome(aTrans[i,9],false,aTrans[i,1],aTrans[i,4],aTrans[i,2],aTrans[i,3],aTrans[i,5],aTrans[i,6],;
					aTrans[i,7],aTrans[i,15],aTrans[i,8],aTrans[i,13],@nSeqnbr,aTrans[i,11]) 
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
			//  1    2      3     4     5        6          7       8   9   10        11      12    13      14       15    16
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid 
			oMBal:ChgBalance(aTrans[i,1],SQLDate2Date(aTrans[i,8]),aTrans[i,2],aTrans[i,4],aTrans[i,3],;
				aTrans[i,5],aTrans[i,6])
		next
		
		oStmnt:=SQLStatement{"set autocommit=0",oConn}
		oStmnt:execute()
		oStmnt:=SQLStatement{'lock tables `transaction` write,`teletrans` write,`mbalance` write'+iif(Len(avaluesPers)>0,',`person` write',''),oConn} 
		oStmnt:execute()
	else
		SQLStatement{"start transaction",oConn}:execute()
	endif	
	maxTeleId:=ConI(SqlSelect{"select max(teletrid) as maxtele from teletrans",oConn}:maxtele)
	oStmnt:=SQLStatement{"insert IGNORE into teletrans "+;
		"(bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,processed) values "+;
		Implode(avalueTrans,'","'),oConn}
	oStmnt:execute()
	if !Empty(oStmnt:Status)
		SQLStatement{"rollback",oConn}:execute()
		if Len(aTrans)>0
			SQLStatement{"unlock tables",oConn}:execute()
		endif
		avalueTrans:={}
		LogEvent(self,oStmnt:SQLString+CRLF+"Error:"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
		ErrorBox{,self:oLan:WGet('Telebank transactions could not be imported')+":"+oStmnt:ErrInfo:ErrorMessage}:show()
		return false 
	endif
	nTele:=oStmnt:NumSuccessfulRows
	if nTele>0 .and.Len(aTrans)>0  .and. nTele<Len(avalueTrans) 
		// remove transactions to be stored from ingnored teletrans transactions:
		// teletransactions ignored: which ones?
		oSel:=SqlSelect{"select seqnr,amount,bankaccntnbr,cast(bookingdate as date) as bookingdate,kind,contra_bankaccnt,"+; 
		"addsub,description,contra_name "+;
			"from teletrans where processed='X' and teletrid>"+Str(maxTeleId,-1),oConn}
		if oSel:RecCount>0
			// compare with aValueTrans:
			// aValuesTrans:
			// bankaccntnbr,bookingdate,seqnr,contra_bankaccnt,kind,contra_name,budgetcd,amount,addsub,description,persid,processed 
			//      1            2        3          4           5      6           7      8      9        10        11       12
			do while !oSel:EoF
				// search imported avaluetrans:
				if (i:=AScan(avalueTrans,{|x|x[12]=='X'.and.x[1]==oSel:bankaccntnbr.and.x[2]==SQLdate(oSel:bookingdate).and.x[3]==ConS(oSel:seqnr).and.;
						x[4]==oSel:contra_bankaccnt.and.x[5]==oSel:kind.and.x[6]==AddSlashes(oSel:contra_name).and.;
						ConS(x[8])==ConS(oSel:amount).and.x[9]==oSel:addsub.and.x[10]==AddSlashes(oSel:Description)}))>0 
					// mark aValuesTrans as imported:
					avalueTrans[i,12]:='I'
				endif 
				oSel:Skip()
			enddo
			// remove corresponding aTrans of ignored teletrans:  
			k:=0
			do while (k:=AScan(avalueTrans,{|x|x[12]=='X'},k+1))>0
				cBankAcc:=avalueTrans[k,1] 
				//m57_bankacc: banknumber, usedforgifts, datelatest, giftsall,singledst,destname,accid,payahead,singlenumber,fgmlcodes,syscodover
				//                 1            2           3          4         5          6      7      8          9          10        11
				j:=AScan(self:m57_bankacc,{|x|x[1]==cBankAcc})
				if j>0
					lv_accid:=self:m57_bankacc[j,7]							
					// search corresponding aTrans:
					//  1    2      3     4     5        6          7       8   9   10        11      12    13      14       15    16
					//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid
					i:=-1
					do while true
						i:=AScan(aTrans,{|x|avalueTrans[k,8]==iif(avalueTrans[k,9]='A',x[4],x[2]).and.avalueTrans[k,2]==x[8];
							.and.x[12]=='1'.and.x[1]==lv_accid.and.x[13]==avalueTrans[k,5]+avalueTrans[k,3]},i+2)
						if i>0
							// check next line:
							if aTrans[i+1,15]==avalueTrans[k,11] 
								cDestAcc:=''
								if Val(avalueTrans[k,11])=0 .or.avalueTrans[k,9]=='A'
									// non gift 
									if !Empty(aValueTrans[k,4]) .and.Empty(aValueTrans[k,7])   // contra_bankaccnt but no budgetcd
										// check if cross banking?
										IF !Empty(SKruis)
											l:=AScan(self:m57_bankacc,{|x|x[1]==avalueTrans[k,4]}) 
											if l>0
												// cross banking:
												cDestAcc:=SKruis
											endif
										endif
									elseif (!Empty(aValueTrans[k,7]).and.(self:m57_bankacc[j,8]>'0'.and.aValueTrans[k,5]=='BGC');  // payahead filled for collective recording of acceptgiro's
										.or.avalueTrans[k,9]=='A') //debit with known destination?
										cBudgetcd:=avalueTrans[k,7]
										if (l:=AScan(aAccnbrDb,{|x|x[1]==cBudgetcd}))>0
											cDestAcc:=aAccnbrDb[l,2]
										endif
									ELSEIF (aValueTrans[k,5]=="IC" .or.aValueTrans[k,5]=="OCR") .and.Empty(aValueTrans[k,4]).and.aValueTrans[k,9] =="B" ;
											.and.self:m57_bankacc[j,8]>'0'  // payahead for OCR
										// in case of recording of automatic collections take payahead as contra account:
										cDestAcc:=self:m57_bankacc[j,8]
									endif
								else    // gift
									cBudgetcd:=avalueTrans[k,7]
									if (l:=AScan(aAccnbrDb,{|x|x[1]==cBudgetcd}))>0
										cDestAcc:=aAccnbrDb[l,2]
									endif
								endif
								if cDestAcc==aTrans[i+1,1] 
									nProc--
									// remove both transaction lines:
									ADel(aTrans,i)
									ADel(aTrans,i)
									ASize(aTrans,Len(aTrans)-2)
									// next line income/expense?
									if aTrans[i,12]=='3'
										ADel(aTrans,i)
										ADel(aTrans,i)							
										ASize(aTrans,Len(aTrans)-2) 
									endif
									exit
								endif
							endif
						else
							exit
						endif
					enddo
				endif
			enddo
			// setup again chgbalance:
			oMBal:=Balances{}
			for i:=1 to Len(aTrans) 
				//  1    2      3     4     5        6          7       8   9   10        11      12    13      14       15    16
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid 
				oMBal:ChgBalance(aTrans[i,1],SQLDate2Date(aTrans[i,8]),aTrans[i,2],aTrans[i,4],aTrans[i,3],;
					aTrans[i,5],aTrans[i,6])
			next
		endif
	endif
	if nTele>0 .and.Len(aTrans)>0  // telebank transactions imported?
		// 		if nTele<Len(avalueTrans)
		// 			// duplicates ignored, nothing automatically:
		// 			SQLStatement{"update teletrans set processed='' where teletrid>"+Str(maxTeleId,-1),oConn}:execute()
		// 		else 
		// insert autmaticallly processed transactions:
		// insert first line:
		oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid) "+;
			" values ("+Implode(aTrans[1],"','",1,15)+')',oConn}
		oStmnt:execute()
		nTransId:=ConI(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
		aTrans[2,16]:=nTransId
		for i:=3 to Len(aTrans) step 2
			// next line income/expense?
			if aTrans[i,12]=='3'
				aTrans[i,16]:=nTransId
				aTrans[i+1,16]:=nTransId
				i+=2
			endif		
			nTransId++
			if i<Len(aTrans)
				aTrans[i,16]:=nTransId
				aTrans[i+1,16]:=nTransId
			endif
		next
		oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid) "+;
			" values "+Implode(aTrans,"','",2),oConn}
		oStmnt:execute()
		if oStmnt:NumSuccessfulRows<1
			SQLStatement{"rollback",oConn}:execute() 
			SQLStatement{"unlock tables",oConn}:execute()
			LogEvent(self,oStmnt:SQLString+CRLF+"Error:"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
			ErrorBox{,self:oLan:WGet('Transactions could not be inserted')+":"+oStmnt:ErrInfo:ErrorMessage}:show()
			self:aValuesTrans:={}
			return false 
		endif
		// adapt mbalance values:
		if !oMBal:ChgBalanceExecute()
			SQLStatement{"rollback",oConn}:execute() 
			SQLStatement{"unlock tables",oConn}:execute()
			LogEvent(self,"error:"+oMBal:cError,"LogErrors")
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
				LogEvent(self,"error:"+oMBal:cError,"LogErrors")
				ErrorBox{,self:oLan:WGet('persons could not be updated')+":"+oStmnt:ErrInfo:ErrorMessage}:show()
				self:aValuesTrans:={}
				return false 
			endif
		endif
		self:lv_processed+=nProc
		// 		endif
	endif		
	self:lv_aant_toe+=nTele
	SQLStatement{"commit",oConn}:execute()	
	if Len(aTrans)>0
		SQLStatement{"unlock tables",oConn}:execute()
	endif
	self:aValuesTrans:={}
	return true
METHOD SkipMut()  CLASS TeleMut
	* Skip of telebanking transaction aftre showing it
	SQLStatement{"update teletrans set lock_id=0 where teletrid="+Str(self:CurTelId,-1),oConn}:execute()
return
METHOD TooOldTeleTrans(banknbr as string,transdate as date,NbrDays:=120 as int) as logic CLASS TeleMut
	// check if found banknumber is part of telebanking accounts within the system
	// 	Default(@NbrDays,120) 
	local oStMnt as SQLStatement
	local oBank,oSel as SQLSelect
	local cDestname as string
	IF (self:CurTelePtr:=AScan(self:m57_BankAcc,{|x| x[1]==AllTrim(banknbr)}))=0
		IF AScan(self:NonTeleAcc,AllTrim(banknbr))=0 
			oStMnt:=SQLStatement{"update bankaccount set telebankng=1 where banknumber='"+AllTrim(banknbr)+"'",oConn}
			oStMnt:Execute()
			if oStMnt:NumSuccessfulRows<1  
				LogEvent(self,"Bank account "+banknbr+" not as telebanking account in system data")
				(ErrorBox{,"Bank account "+banknbr+" not as telebanking account in system data"}):Show()
				AAdd(self:NonTeleAcc,AllTrim(banknbr)) 
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
			RETURN true
		ENDIF		
	ENDIF
	// check if transaction is too old in comparison with latest recorded for this bankaccount
	IF transdate +NbrDays < self:m57_BankAcc[self:CurTelePtr,3]
		RETURN TRUE
	ENDIF
	RETURN FALSE
