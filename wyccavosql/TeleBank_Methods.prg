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
CLASS TeleMut

	PROTECT m56_recnr AS INT
	EXPORT m56_sgir,m56_kind,m56_description,m56_contra_name,m56_budgetcd,m56_cod_mut_r,;
		m56_addsub, m56_accnumber,m56_accid:="   ", m56_Payahead,m56_persid as STRING,;
		m56_bookingdate as date,;
		m56_amount as REAL,;
		m56_seqnr:=0 as int 
	export m56_contra_bankaccnt, m56_bankaccntnbr as USUAL,;
		m56_processed,m56_recognised, m56_autmut,m56_mode_aut:=true,m56_autom as LOGIC
	export m56_address, m56_zip, m56_town, m56_country as string

	PROTECT m56_auto_verw AS LOGIC
	PROTECT lGift AS LOGIC

	// PROTECT oTelPat as SQLSelect, oBank as SQLSelect
	EXPORT teleptrn:={} as ARRAY //{contra_bankaccnt,kind,contra_name,addsub,description,accid,ind_autmut}
	EXPORT oTelTr as SQLSelect
	EXPORT oParent AS OBJECT
	EXPORT m57_BankAcc := {} as ARRAY   //met: banknumber, usedforgifts, betaalind, datlaatst 
	PROTECT bankacc := {} as ARRAY  // all bankaccounts 
	export cBankAcc as string   // all bankaccounts 
	//export aBankProc:={} as array // bankaccounts to be processed 
	export CurTelId as int
	PROTECT lv_mm, lv_jj AS INT
	PROTECT lv_aant_toe:=0, lv_aant_vrw AS INT
	PROTECT CurTelePtr as int // pointer to current telebanking account within m57_BankAcc
	PROTECT NonTeleAcc:={} as ARRAY
	EXport lOK as logic 
	export oLan as Language 
	export cReqTeleBnk as string // required bank accounts to import 
	protect cAccnumberCross as string  // accnumber of account for cross bank transfer (sKruis)
	protect aMessages:={} as array  // messages about successfully imported files

	declare method AllreadyImported, TooOldTeleTrans,ImportBBS,ImportPGAutoGiro ,ImportBRI,ImportPostbank,ImportVerwInfo,ImportBBSInnbetal,;
	ImportCliop,ImportGiro,ImportKB,ImportMT940,ImportSA,ImportTL1,ImportUA,CheckPattern,NextTeleNonGift,GetPaymentPattern
METHOD AllreadyImported(transdate as date,transamount as float,codedebcre:="" as string,transdescription:="" as string,TransType:="" as string,ContrBankNbr:="" as string,ContraName:="" as string,BudgetCode:="" as string) as logic CLASS TeleMut
	local oSEl as SQLSelect 
	local cStatement as string
	// check if transaction has allready been imported
	IF transdate <= m57_BankAcc[CurTelePtr,3] 
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
		oSEl:=SQLSelect{cStatement,oConn}
		if oSEl:Reccount>0
        	RETURN true
		ENDIF
   ENDIF
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
METHOD GetNxtMut(LookingForGifts) CLASS TeleMut
	* get next bank transaction from teletrans
	* return .t.: next found
	*        .f.: not found
	LOCAL hlpbank:=0, iBpos,XMLPos,nBudLen,nAddrEnd,nLength as int
	LOCAL BankNbr, TegNbr as STRING 
	LOCAL oXMLDoc as XMLDocument 
	Local aWord as array, oPers as PersonContainer 
	local oBank as SQLSelect 
	local oLockSt as SQLStatement 
	local cSelect as string 
	local lZipCode,lCity,lAddress as logic

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
		self:m56_address:=""
		self:m56_zip:=""
		self:m56_town:=""
		self:m56_country:="" 
		XMLPos:=At("<n>",self:oTelTr:Description)
		if XMLPos=0
			XMLPos:=At("<a>",self:oTelTr:Description)
			if XMLPos=0
				XMLPos:=At("<t>",self:oTelTr:Description)
				if XMLPos=0
					XMLPos:=At("<d>",self:oTelTr:Description)
				endif
			endif
		endif
		
		if "</" $ self:oTelTr:Description .and. XMLPos>0 
			oXMLDoc:=XMLDocument{SubStr(self:oTelTr:Description,XMLPos)}
			IF oXMLDoc:GetElement("n")
				self:m56_contra_name:=Upper(oXMLDoc:GetContentCurrentElement())
			ENDIF
			IF oXMLDoc:GetElement("a")
				self:m56_address:=oXMLDoc:GetContentCurrentElement()
			ENDIF
			IF oXMLDoc:GetElement("p")
				self:m56_zip:=oXMLDoc:GetContentCurrentElement()
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
			self:m56_description:= Upper(Compress(self:oTelTr:Description))
			self:m56_contra_name:= Upper(Compress(StrTran(self:oTelTr:contra_name,' - ','-'))) 
			if (nAddrEnd:=At('%%',self:oTelTr:Description))>0  
				// separate address line probably
				if oPers==null_object
					oPers:=PersonContainer{}
				endif
				aWord:=GetTokens(SubStr(self:oTelTr:Description,1,nAddrEnd-1)) 
				oPers:Adres_Analyse(aWord,,@lZipCode,@lCity,@lAddress,false)
				self:m56_address:=oPers:m51_ad1
				self:m56_zip:=oPers:m51_pos 
				self:m56_town:=oPers:m51_city
			endif
		endif		
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
		if Upper(SubStr(lv_oms,1,10))=='ACCEPTGIRO'
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
	LOCAL aFileMT, aFilePB, aFileSA, aFileN, aFileUA, aFileBBS, aFileINN, aFilePG, aFileVWI, aFileRabo,aFileTL,aFileKB as ARRAY
	local cFileName as STRING, nf,i as int
	LOCAL oBF as MyFileSpec
	LOCAL oPF as FileSpec
	LOCAL i as int
	local nOld:=4 as int   // after Nold months imported transactions are removed
	LOCAL lDelete,lSuccess as LOGIC
	LOCAL lv_eind as date
	Local oLock,oSel as SQLSelect
	local aFiles:={} as array  // files to be deleted 
	// force only one person is importing:
	SQLStatement{"start transaction",oConn}:execute()
	oLock:=SQLSelect{"select importfile from importlock where importfile='telelock' for update",oConn}

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
	aFileSA:=Directory(CurPath+"\statement-*-20??????.txt") 
	aFileUA:=Directory(CurPath+"\x*statements.TXT")
	aFileINN:=Directory(CurPath+"\ocrinnbet.txt")
	aFileBBS:=Directory(CurPath+"\TRANSLISTE.CSV")
	// 	aFileVWI:=Directory(CurPath+"\*????????verwinfo??.txt")
	aFileVWI:=Directory(CurPath+"\*verwinfo*.txt")
	aFilePG:=Directory(CurPath+"\PG_8502000149_BG4_20??-??-??*.txt")
	aFileRabo:=Directory(CurPath+"\BR0?????????.0??") 
	aFileTL:=Directory(CurPath+"\PG_TOTALIN_TL1_*.txt")  
	AEval(Directory(CurPath+"\mut*.ASC"),{|x|AAdd(aFileRabo,x)})
	AEval(Directory(CurPath+"\*-20??.ASC"),{|x|AAdd(aFilePB,x)})
	AEval(Directory(CurPath+"\*-20??.TXT"),{|x|AAdd(aFilePB,x)})
	IF oFs:Find() .or. oFC:Find() .or.!Empty(aFileRabo).or.!Empty(aFileMT).or.!Empty(aFilePB).or.!Empty(aFileSA).or.!Empty(aFileKB).or.!Empty(aFileUA).or.!Empty(aFileBBS).or.!Empty(aFileINN).or.!Empty(aFilePG).or.!Empty(aFileVWI).or.!Empty(aFileTL)
		lDelete:=true 
		self:oParent:Pointer := Pointer{POINTERHOURGLASS}

		* Establish last recording date per bak account: 
		oSel:=SQLSelect{"select bankaccntnbr,max(bookingdate) as maxdat from teletrans where bankaccntnbr in ("+self:cReqTeleBnk+") and bookingdate<=NOW() group by bankaccntnbr",oConn}
		oSel:execute()
		Do while !oSel:EOF 
			if !Empty(oSel:FIELDGET(1))
				i:=AScan(m57_BankAcc,{|x|x[1]==oSel:FIELDGET(1)}) 
				if i>0
					if !Empty(oSel:maxdat)
						m57_BankAcc[i,3]:=oSel:maxdat
					endif
				endif
			endif
			oSel:Skip()
		enddo
		
		IF oFs:Find()
			self:ImportGiro(oFs)
			AAdd(aFiles,oFs)
		ENDIF

		IF oFC:Find()
			self:ImportCliop(oFC)
			AAdd(aFiles,oFC)
		ENDIF

		// Import Bulk Rekening Info:	
		FOR nf:=1 to Len(aFileRabo)
			cFileName:=aFileRabo[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			self:ImportBRI(oBF)
			AAdd(aFiles,oBF)
		NEXT
		FOR nf:=1 to Len(aFileVWI)
			// VERWINFO of Equens
			cFileName:=aFileVWI[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			self:ImportVerwInfo(oBF)
			AAdd(aFiles,oBF)
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
			self:ImportBBS(oBF)
			AAdd(aFiles,oBF)
		NEXT
		// Import Sweden TOTAL IN data:	
		FOR nf:=1 to Len(aFileTL)
			cFileName:=aFileTL[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			self:ImportTL1(oBF)
			AAdd(aFiles,oBF)
		NEXT


		FOR nf:=1 to Len(aFileMT)
			cFileName:=aFileMT[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			self:ImportMT940(oBF)
			AAdd(aFiles,oBF)
		NEXT
		// South Africa Standard Bank:
		FOR nf:=1 to Len(aFileSA)
			cFileName:=aFileSA[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			self:ImportSA(oBF)
			AAdd(aFiles,oBF)
		NEXT
		// KB Bank Germany:
		FOR nf:=1 to Len(aFileKB)
			cFileName:=aFileKB[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			self:ImportKB(oBF)
			AAdd(aFiles,oBF)
		NEXT

		// Ukraine Bank:
		FOR nf:=1 to Len(aFileUA)
			cFileName:=aFileUA[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			self:ImportUA(oBF)
			AAdd(aFiles,oBF)
		NEXT
		// Swedisch PG AutoGiro:
		FOR nf:=1 to Len(aFilePG)
			cFileName:=aFilePG[nf,F_NAME]
			oBF := MyFileSpec{cFileName}
			self:ImportPGAutoGiro(oBF)
			AAdd(aFiles,oBF)
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
				self:ImportGiro(oPF)
			ELSE
				self:ImportPostbank(oPF)
			ENDIF
			AAdd(aFiles,oPF)
		NEXT


		* Removing old transactions:
		IF lv_aant_toe>0
			* Calculate date too old (4 months old):
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
	SQLStatement{"commit",oConn}:Execute()  // release lock
	if Len(self:aMessages)>0
		(InfoBox{,"Import of telebanking transactions",Str(lv_aant_toe,4)+" transactions imported"}):Show()
		for i:=1 to Len(self:aMessages)
			LogEvent(self,self:aMessages[i],"Log")
		next
	endif
	RETURN
METHOD ImportBBS(oFb as MyFileSpec) as logic CLASS TeleMut
	* Import of Norwagian BBS Bank data into teletrans.dbf
	LOCAL oHlS AS HulpSA
	LOCAL m57_laatste := {} AS ARRAY
	LOCAL i, TelPtr AS INT
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()) AS INT
	LOCAL lv_description, lv_bankAcntOwn,lv_addsub,lv_BankAcntContra as STRING
	LOCAL cSep AS INT
	LOCAL cDelim:=CHR(9) AS STRING
	LOCAL ptrHandle AS MyFile
	LOCAL hl_boekdat,lv_addsub as STRING
	LOCAL oFs:=oFb AS FileSpec
	LOCAL cBuffer as STRING, nRead, nAccEnd as int
	LOCAL aStruct:={} AS ARRAY // array with fieldnames
	LOCAL aFields:={} AS ARRAY // array with fieldvalues
	LOCAL ptDate, ptPay, ptDesc, ptDep, nVnr AS INT
	LOCAL lv_Amount, Hl_balan as FLOAT
	LOCAL ld_bookingdate as date
	Local cBankAcc as string
	local oStmnt as SQLStatement
	local nTrans,nImp as int

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
cDelim:=CHR(9)
aStruct:=Split(Upper(cBuffer),cDelim)
IF Len(aStruct)<4
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
cSep:=SetDecimalSep(Asc(","))
// Determine Bankaccount of Wycliffe at BBS:
lv_bankAcntOwn:=ZeroTrim(BANKNBRDEB)
cBuffer:=ptrHandle:FReadLine(ptrHandle)
aFields:=Split(cBuffer,cDelim)
nImp:=0
nTrans:=0

DO WHILE Len(aFields)>3
	ld_bookingdate:=CToD(AFields[ptDate])
	IF ld_bookingdate >=Today() .or. self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
		cBuffer:=ptrHandle:FReadLine(ptrHandle)
		aFields:=Split(cBuffer,cDelim)
		LOOP
	ENDIF
    lv_description:=AllTrim(StrTran(AllTrim(AFields[ptDesc]),'"',''))
    lv_amount:=AbsFloat(Val(aFIELDs[ptPay]))
    IF lv_Amount=0
	    lv_Amount:=Val(aFields[ptDep])
	    lv_addsub:="B"
	ELSE
		lv_addsub:="A"
	ENDIF
    IF Empty(lv_Amount)  && geen lege mutaties laden
		cBuffer:=ptrHandle:FReadLine(ptrHandle)
		aFields:=Split(cBuffer,cDelim)
    	LOOP
    ENDIF
	lv_Amount:=Round(lv_Amount,DecAantal) 
	lv_addsub:="BBS" 
	lv_BankAcntContra:=""
	IF Upper(lv_description)=="TOTALT KREDITERT OCR-GIRO" .or. Upper(lv_description)=="SUM OCR-GIRO"
		lv_addsub:= "OCR"
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
	nTrans++
	IF self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,lv_addsub,"","","")
		cBuffer:=ptrHandle:FReadLine(ptrHandle)
		aFields:=Split(cBuffer,cDelim)
        LOOP
	ENDIF 
	oStmnt:=SQLStatement{"insert into teletrans set	"+;
	"bankaccntnbr='"+lv_bankAcntOwn+"'"+;
	",contra_bankaccnt='"+lv_BankAcntContra+"'"+;
	",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
	",kind='"+lv_addsub+"'"+;
	",amount='"+Str(lv_Amount,-1)+"'"+;
	",addsub='"+lv_addsub	+"'"+;
	",code_mut_r='M'"+;
	",description='"+lv_description	+"'",oConn}
	oStmnt:Execute()
	if	oStmnt:NumSuccessfulRows>0
		++self:lv_aant_toe
		++nImp
	else
		LogEvent(self,oStmnt:SQLString+CRLF+"Error:"+oStmnt:Status:Description,"LogErrors")
	endif
	cBuffer:=ptrHandle:FReadLine(ptrHandle)
	aFields:=Split(cBuffer,cDelim)
ENDDO
ptrHandle:Close()
ptrHandle:=NULL_OBJECT
AAdd(self:aMessages,"Imported BBS file:"+oFb:FileName+" "+Str(nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions")
SetDecimalSep(cSep)  // restore decimal separator
RETURN TRUE
METHOD ImportBBSInnbetal(oFm as MyFileSpec) as logic CLASS TeleMut
	*	Import of one BBS Innbetaling transaction file (with KID numbers)
	LOCAL oHlM AS HlpMT940
	LOCAL lv_bankAcntOwn, lv_description, lv_addsub, lv_AmountStr, lv_Budgetcd, lv_InvoiceID, lv_reference, lv_persid as STRING
	LOCAL lv_loaded as LOGIC
	LOCAL lv_Amount AS FLOAT
	LOCAL lSuccess:=TRUE AS LOGIC
	LOCAL AccSDON AS STRING
	LOCAL oHlp AS Filespec
	LOCAL ld_bookingdate as date
	local oStmnt as SQLStatement
	local oSel as SQLSelect
	local cPersId as string
	local oStmnt as SQLStatement
	local nTrans,nImp as int

	
	oHlM :=HlpMT940{HelpDir+"\HMT"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
	
	*Look for NY090020: record with accountnumber
	*	Look for next line until line =NY090020
	*		if 61: amount
	*		if 85: corresponding description with counteraccount
	*			add record to teletrans
	*
	lSuccess:=oHlM:AppendSDF(oFm)
	oHlM:Gotop()
	IF Empty(SDON)
		(Warningbox{,"Import of Innbetal transactions","Specify first within system parameters account for donations as default destination"}):Show()
		RETURN FALSE
	ENDIF	
	oSel:=SQLSelect{"select accnumber from account where accid="+SDON,oConn}
	if oSel:reccount>0
		AccSDON:=oSel:ACCNUMBER
	ENDIF
	nImp:=0
	nTrans:=0
	DO WHILE .not.oHlM:EOF
		* Search NY090020 record:
		IF !SubStr(oHLM:MTLINE,1,8)=="NY090020"
			oHlM:Skip()
			LOOP
		ENDIF
		lv_bankAcntOwn:=ZeroTrim(SubStr(oHlM:MTLINE,25,11))
		oHlm:Skip()
		DO WHILE .not.oHlM:EOF
			* Search for NY091330 or NY091030  (amount and kidnbr):
			* Stop if NY090088 record:
			IF SubStr(oHLM:MTLINE,1,8)=="NY090088"
				EXIT
			ENDIF
			IF (SubStr(oHLM:MTLINE,1,4)=="NY09".and.SubStr(oHLM:MTLINE,7,2)=="30")   // first line of transaction
				ld_bookingdate:=SToD("20"+SubStr(oHlM:MTLINE,20,2)+SubStr(oHlM:MTLINE,18,2)+SubStr(oHlM:MTLINE,16,2)) // valuta date
				lv_addsub:="B"
				lv_AmountStr:=SubStr(oHlM:MTLINE,33,17)
				lv_Amount:=Round(Val(lv_AmountStr)/100.00,2)
				// Determine from KIDnr personid and accountnbr:
				lv_InvoiceID:=SubStr(oHlM:MTLINE,64,11)
				lv_description:=lv_InvoiceID
				lv_Budgetcd:=SubStr(lv_InvoiceID,6,5)
				IF Empty(lv_Budgetcd)
					lv_Budgetcd:=AccSDON  // default Donations account
				ELSEIF SQLSelect{"select accid from account where accid="+lv_Budgetcd,oConn}:reccount<1
					lv_Budgetcd:=AccSDON  // default Donations account
				ENDIF
				lv_reference:=SubStr(oHLM:MTLINE,5,2)
				lv_persid:=SubStr(lv_InvoiceID,2,5)
			  	lv_description:=AddSlashes(AllTrim(lv_description))
				nTrans++
				* save transaction:
				IF !self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
					IF !self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,"KID","","",lv_Budgetcd) .and.!Empty(lv_Amount) 
						oSel:=SQLSelect{"select personid from subscription where invoiceid='"+lv_InvoiceID+"'",oConn}
						if oSel:reccount>0
							cPersId:=Str(oSel:personid,-1)
						else
							cPersId:=""
						endif
						oStmnt:=SQLStatement{"insert into teletrans set "+;
							"contra_bankaccnt='"+lv_InvoiceID+"'"+;
							",bankaccntnbr='"+lv_bankAcntOwn+"'"+;
							",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
							",kind='KID'"+;
							",amount='"+Str(lv_Amount,-1)+"'"+;
							",addsub='"+lv_addsub +"'"+;
							",code_mut_r='"+lv_reference+"'"+;
							",description='"+lv_description +"'"+;
							",seqnr="+Str(Val(SubStr(oHlM:MTLINE,9,7)),-1)+;
							iif(Empty(cPersId),'',",persid="+cPersId),oConn}
						oStmnt:Execute() 
						lv_description:=""
						if	oStmnt:NumSuccessfulRows>0
							++self:lv_aant_toe
							++nImp
						else
							LogEvent(self,oStmnt:SQLString+CRLF+"Error:"+oStmnt:Status:Description,"LogErrors")
						endif
					ENDIF
				ENDIF
			ENDIF
			oHlm:Skip()
		ENDDO
	ENDDO
	

	oHlp:=Filespec{oHLM:FileSpec:Fullpath}
	oHlM:Close()
	oHlM:=null_object
	AAdd(self:aMessages,"Imported Innbetalinger fra BBS file:"+oFm:FileName+" "+Str(nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions")
	oHlp:Delete()
	RETURN true
METHOD ImportBRI(oFm as MyFileSpec) as logic CLASS TeleMut
	* Import of Bulk Rekening Informatie data into teletrans.dbf
*	Import of one BRI telebnk transaction file
	LOCAL oHlM as HlpMT940
	LOCAL i, nEndAmnt, nDC, nPtr, nOffset, nVnr, nTrans, nImp as int
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
  	IF !self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
  		IF !self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,lv_reference,lv_BankAcntContra,lv_NameContra,lv_budget) .and.!Empty(lv_Amount)
			oStmnt:=SQLStatement{"insert into teletrans set	"+;
				"contra_bankaccnt='"+ZeroTrim(lv_BankAcntContra)+"'"+;
				",contra_name='"+lv_NameContra+"'"+;
				",bankaccntnbr='"+ZeroTrim(lv_bankAcntOwn)+"'"+;
				",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
				",kind='"+lv_reference +"'"+;
				",amount="+Str(lv_Amount,-1)+;
				",addsub='"+lv_addsub	+"'"+;
				",budgetcd='"+lv_budget	+"'"+;
				iif(Empty(lv_persid),"",",persid='"+lv_persid +"'")+;
				",seqnr="+Str(nVnr,-1)+;
				",description='"+lv_description	+"'",oConn}
			oStmnt:Execute()
			if	oStmnt:NumSuccessfulRows>0
				++self:lv_aant_toe
				++nImp
			else
				LogEvent(self,oStmnt:SQLString+CRLF+"Error:"+oStmnt:Status:Description,"LogErrors")
			endif
  		endif
	ENDIF
ENDDO
		
oHlp:=FileSpec{oHlM:FileSpec:Fullpath}
oHlM:Close()
oHlM:=null_object 
AAdd(self:aMessages,"Imported BRI file:"+oFm:FileName+" "+Str(nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions")
oHlp:DELETE()
RETURN true
METHOD ImportCliop(oFs as MyFileSpec) as logic CLASS TeleMut
	* Import of Clieop03 data with automatic collection details into teletrans.dbf
	LOCAL oHlC AS HulpCliop
	LOCAL i AS INT
	LOCAL lv_bestandid, lv_bankAcntOwn, lv_BankAcntContra, lv_Budgetcd:=Space(5),lv_AmountStr  as STRING
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
				lv_Budgetcd:=SubStr(oHlC:TRANSSOORT+oHlC:BEDRAG,1,5)
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
      * controleer op reeds geladen zijn van mutatie:
	IF self:AllreadyImported(ld_bookingdate,lv_Amount,"B",lv_description,"IC",lv_BankAcntContra,"",lv_Budgetcd)
       	*	Skip THIS transaction
        LOOP
	ENDIF
	oStmnt:=SQLStatement{"insert into teletrans set	"+;
	"contra_bankaccnt='"+lv_BankAcntContra+"'"+;
	",bankaccntnbr='"+lv_bankAcntOwn+"'"+;
	",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
	",kind='COL'"+;
	",amount='"+Str(lv_Amount,-1)+"'"+;
	",addsub='B'"+;
	",code_mut_r='M'"+;
	",budgetcd='"+lv_Budgetcd	+"'"+;
	",description='"+lv_description	+"'",oConn}
	oStmnt:Execute()
	if	oStmnt:NumSuccessfulRows>0
		++self:lv_aant_toe 
	endif
	lv_budgetcd:=Space(5)
	lv_description:=""
ENDDO
oHlp:=Filespec{oHLC:FileSpec:Fullpath}
oHlC:Close()
oHLC:=NULL_OBJECT
oHlp:Delete()
RETURN true
METHOD ImportGiro(oFs as MyFileSpec) as logic CLASS TeleMut
	* Import of postgiro data into teletrans.dbf
	LOCAL oHlG AS HulpGiro
	LOCAL m57_laatste := {} AS ARRAY
	LOCAL i AS INT
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()),nImp,nTrans as int
	LOCAL lv_loaded as LOGIC,  hlpbank as USUAL, lv_Amount as FLOAT
	LOCAL lv_addsub,lv_addsub,cCurrency,lv_description, lv_NameContra,lv_bankAcntOwn,lv_BankAcntContra,lv_cod_mut as STRING
	LOCAL cSep AS STRING
	LOCAL lSuccess:=TRUE AS LOGIC
	LOCAL oHlp as Filespec 
	LOCAL ld_bookingdate as date
	local oStmnt as SQLStatement


cSep:=CHR(SetDecimalSep())
	//oHlG := Hulpgiro{,DBEXCLUSIVE}
oHlG :=Hulpgiro{HelpDir+"\HGiro"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
* Clear HulpGiro
oHlG:Zap()
// lSuccess:=oFs:FileLock()       
lSuccess:=oHlG:appendSDF(oFs)
if lSuccess	 
	oHlg:Gotop()
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
			oHlg:Skip()
			LOOP
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
			oHlG:skip()
			LOOP
		ENDIF
		IF lv_addsub # "A".and.lv_addsub # "B"    && alleen Af/BIJ-mutaties laden
			oHlG:skip()
			LOOP
		ENDIF
		IF lv_addsub=="A"    && geen mededelingen laden
			IF "OPDRACHT NIET VERWERKT" $ lv_description
				oHlG:skip()
				LOOP
			ENDIF
		ENDIF
    	IF Empty(Val(oHlG:HL_BEDRAG))  && geen lege mutaties laden
    		oHlG:Skip()
	    	LOOP
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
		hlpbank:=SubStr(oHlg:hl_teg_naa,1,10)
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

	      * Check allready loaded:
    	IF self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,oHlG:hl_mutsoor,lv_BankAcntContra,lv_NameContra,oHlG:hl_budget)
			oHlg:skip()
	        LOOP
    	ENDIF
		oStmnt:=SQLStatement{"insert into teletrans set "+;
		"contra_bankaccnt='"+lv_BankAcntContra+"'"+;
		",contra_name='"+lv_NameContra+"'"+;
		",bankaccntnbr='"+lv_bankAcntOwn+"'"+;
		",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
		",kind='"+oHlG:hl_mutsoor +"'"+;
		",amount='"+Str(lv_Amount,-1)+"'"+;
		",addsub='"+lv_addsub +"'"+;
		",code_mut_r='"+lv_cod_mut+"'"+;
		",budgetcd='"+AllTrim(oHlG:hl_budget)+"'"+;
		",seqnr='"+Str(Val(AllTrim(oHlG:hl_volgnum)),-1)+"'"+;
		",description='"+lv_description +"'",oConn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows>0
			++lv_aant_toe 
			++nImp			
		endif
		oHlG:skip()
	ENDDO
	oHlp:=Filespec{oHLG:FileSpec:Fullpath}
	ohlG:Close()
	oHLG:=NULL_OBJECT
	oHlp:DELETE()
	AAdd(self:aMessages,"Imported ING file:"+oFs:FileName+" "+Str(nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions")

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
	LOCAL i, nEndAmnt, nDC, nOffset, nTrans,nImp,nNumPos,nSepPos,nLenLine1 as int
	LOCAL lv_bankAcntOwn, lv_description, lv_Oms, lv_addsub, lv_AmountStr, lv_reference, lv_NameContra as STRING
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
					// Look for budget cdoe between * or [] or ()
					if (nOffset:=At('*',lv_description))>0 
						aBudg:=Split(SubStr(lv_description,nOffset+1),'*')
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
							if SQLSelect{"select accid from account where accnumber='"+lv_budget+"'",oConn}:Reccount<1   // no existing account?
								lv_budget:=""
							endif
						endif
					endif
					if Empty(lv_budget) .and. (nOffset:=At('[',lv_description))>0
						aBudg:=Split(SubStr(lv_description,nOffset+1),']') 
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
							if SQLSelect{"select accid from account where accnumber='"+lv_budget+"'",oConn}:Reccount<1   // no existing account?
								lv_budget:=""
							endif
						endif					
					endif
					if Empty(lv_budget) .and. (nOffset:=At('(',lv_description))>0
						aBudg:=Split(SubStr(lv_description,nOffset+1),')') 
						if	Len(aBudg)>0 .and. isnum(aBudg[1])
							lv_budget:=aBudg[1]
							if SQLSelect{"select accid from account where accnumber='"+lv_budget+"'",oConn}:Reccount<1   // no existing account?
								lv_budget:=""
							endif
						endif
					endif
				else
					lv_budget:=iif(SQLSelect{"select accnumber from account where accnumber='"+lv_budget+"'",oConn}:Reccount>0,lv_budget,'')					
				endif
				lv_description:=AddSlashes(AllTrim(lv_description))
				lv_NameContra:=AddSlashes(AllTrim(SubStr(lv_NameContra,1,32)))   //max length 32 in teletrans
				* save transaction:
				nTrans++
				IF !self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
					if !Empty(lv_persid)
						lv_persid:=iif(SQLSelect{"select persid from person where persid='"+lv_persid+"'",oConn}:Reccount>0,lv_persid,'')
					endif
					IF !self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,lv_kind,lv_BankAcntContra,lv_NameContra,lv_budget) .and.!Empty(lv_Amount)
						oStmnt:=SQLStatement{"insert into teletrans set "+;
							"contra_bankaccnt='"+lv_BankAcntContra+"'"+;
							",contra_name='"+lv_NameContra+"'"+;
							",bankaccntnbr='"+lv_bankAcntOwn+"'"+;
							",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
							",amount='"+Str(lv_Amount,-1)+"'"+;
							",addsub='"+lv_addsub +"'"+; 
						",seqnr='"+Str(Val(lv_reference),-1)+"'"+;
							iif(Empty(lv_kind),'',",kind='"+lv_kind +"'")+;
							iif(Empty(lv_budget),'',",budgetcd='"+lv_budget	+"'")+;
							iif(Empty(lv_persid),"",",persid='"+lv_persid +"'")+;
							",description='"+lv_description +"'",oConn}
						oStmnt:Execute()
						if oStmnt:NumSuccessfulRows>0
							++self:lv_aant_toe 
							++nImp
						else
							LogEvent(self,oStmnt:SQLString+CRLF+"Error:"+oStmnt:ErrInfo:ErrorMessage+CRLF+oStmnt:SQLString,"LogErrors")
						endif
					ENDIF
				ENDIF
				lv_Oms:=""
			enddo     // end 61 /86 combinations
			exit
		ENDDO       // end :25 transaction
	ENDDO
	

	oHlp:=FileSpec{oHlM:Filespec:Fullpath}
	oHlM:Close()
	oHlM:=null_object
	AAdd(self:aMessages,"Imported MT940 file:"+oFm:FileName+" "+Str(nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions")
	oHlp:DELETE()                                                             
	RETURN true
METHOD ImportPGAutoGiro(oFm as MyFileSpec) as logic CLASS TeleMut
	*	Import of one PostGiro AutoGiro transaction file (Sweden)
	LOCAL oHlM as HlpMT940
	LOCAL lv_bankAcntOwn, lv_description, lv_addsub, lv_AmountStr, lv_Budgetcd, lv_InvoiceID, lv_reference, lv_persid as STRING
	LOCAL lv_loaded as LOGIC
	LOCAL lv_Amount as FLOAT
	LOCAL lSuccess:=true as LOGIC
	LOCAL oSub as SQLSelect
	LOCAL oHlp as FileSpec
	LOCAL ld_bookingdate as date 
	local oStmnt as SQLStatement
	local nCnt,nTot as int

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
		nTot++
		ld_bookingdate:=SToD(SubStr(oHlM:MTLINE,3,8)) // valuta date
		lv_addsub:="B"
		lv_AmountStr:=SubStr(oHlM:MTLINE,32,12)
		lv_Amount:=Round(Val(lv_AmountStr)/100.00,2)
		lv_bankAcntOwn:=ZeroTrim(SubStr(oHlM:MTLINE,44,10))
		// Determine from KIDnr personid and accountnbr:
		lv_InvoiceID:=ZeroTrim(SubStr(oHlM:MTLINE,16,16))
		lv_description:=lv_InvoiceID
		lv_persid:=SubStr(lv_InvoiceID,1,5)
		// 	lv_Budgetcd:=SubStr(lv_InvoiceID,10,5)
		// 	IF Len(lv_Budgetcd)=2
		// 		lv_Budgetcd:="22"+lv_Budgetcd+"0"  // expanded to 5 numbers account#
		// 	ENDIF
		lv_reference:=SubStr(oHlM:MTLINE,7,8)
	  	lv_description:=AddSlashes(AllTrim(lv_description))
		
		* save transaction:
		IF !self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			IF !self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,"PGA","","",lv_Budgetcd) .and.!Empty(lv_Amount)
				oSub:=SQLSelect{"select personid from subscription where invoiceid='"+lv_InvoiceID+"'",oConn}
				if oSub:RecCount>0
					lv_persid:=Str(oSub:Personid,-1)
// 				else
// 					lv_persid:=""
				endif
				oStmnt:=SQLStatement{"insert into teletrans set	"+;
					"bankaccntnbr='"+lv_bankAcntOwn+"'"+;
					",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
					",kind='PGA'"+;
					",amount='"+Str(lv_Amount,-1)+"'"+;
					",addsub='"+lv_addsub	+"'"+;
					",budgetcd='"+lv_Budgetcd	+"'"+;
					iif(Empty(lv_persid),"",",persid='"+lv_persid +"'")+;
					",code_mut_r='"+lv_reference+"'"+;
					",description='"+lv_description	+"'",oConn}
				oStmnt:Execute()
				if	oStmnt:NumSuccessfulRows>0
					++self:lv_aant_toe
					nCnt++
				endif
				lv_description:=""
			ENDIF
		ENDIF
		oHlM:skip()
	ENDDO
	

	oHlp:=FileSpec{oHlM:FileSpec:Fullpath}
	oHlM:Close()
	oHlM:=null_object
	oHlp:DELETE() 
	AAdd(self:aMessages,"Imported PGAutoGiro file:"+oFm:FileName+" "+Str(nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions")

	RETURN true
METHOD ImportPostbank( oFs as MyFileSpec ) as logic CLASS TeleMut
	* Import of postgiro data into teletrans
	LOCAL m57_laatste := {} AS ARRAY
	LOCAL i, lName AS INT
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()),nImp,nTrans as int
	LOCAL lv_loaded as LOGIC,  hlpbank as USUAL
	LOCAL lv_addsub,lv_addsub,cCurrency,lv_description, cHl_kind, lv_NameContra   as STRING
	LOCAL lv_bankAcntOwn as STRING, lv_BankAcntContra as STRING, lv_Amount as FLOAT
	LOCAL lSuccess:=TRUE AS LOGIC
	LOCAL cSep AS INT
	LOCAL cDelim:="," AS STRING
	LOCAL hl_boekdat AS STRING
	LOCAL ptrHandle AS MyFile
	LOCAL cBuffer AS STRING, nRead AS INT
	LOCAL aStruct:={} AS ARRAY // array with fieldnames
	LOCAL aFields:={} AS ARRAY // array with fieldvalues
	LOCAL ptDate, ptAcc, ptDesc, ptTeg, ptCode, ptAfBij,ptBedr, ptSoort,ptMed AS INT
	LOCAL pbType AS STRING
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

	DO WHILE Len(aFields)>7
		lv_bankAcntOwn:=ZeroTrim(AFields[ptAcc])
		hl_boekdat:=aFields[ptDate]
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
			LOOP
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
		cHl_kind:=AFields[ptSoort]		
		IF Empty(cHl_kind)  && alleen mutaties laden
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
			aFields:=Split(cBuffer,cDelim)
			LOOP
		ENDIF
		IF lv_addsub # "A".and.lv_addsub # "B"    && alleen Af/BIJ-mutaties laden
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
			aFields:=Split(cBuffer,cDelim)
			LOOP
		ENDIF
		IF lv_addsub=="A"    && geen mededelingen laden
			IF "OPDRACHT NIET VERWERKT" $ Upper(lv_description)
				cBuffer:=ptrHandle:FReadLine(ptrHandle)
				aFields:=Split(cBuffer,cDelim)
				LOOP
			ENDIF
		ENDIF
		lv_BankAcntContra:=Str(Val(AFields[ptTeg]),-1)
		lv_Amount:=Val(aFields[ptBedr])
		IF Empty(lv_Amount)  && geen lege mutaties laden
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
			aFields:=Split(cBuffer,cDelim)
			LOOP
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
		
		* controleer op reeds geladen zijn van mutatie:
		IF self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,lv_addsub,lv_BankAcntContra,lv_NameContra,"")
			cBuffer:=ptrHandle:FReadLine(ptrHandle)
			aFields:=Split(cBuffer,cDelim)
			LOOP
		ENDIF 
		oStmnt:=SQLStatement{"insert into teletrans set "+;
			"contra_bankaccnt='"+lv_BankAcntContra+"'"+;
			",contra_name='"+lv_NameContra+"'"+;
			",bankaccntnbr='"+lv_bankAcntOwn+"'"+;
			",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
			",kind='"+lv_addsub +"'"+;
			",amount='"+Str(lv_Amount,-1)+"'"+;
			",addsub='"+lv_addsub +"'"+;
			",code_mut_r='"+"M"+"'"+;
			",description='"+lv_description +"'",oConn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows>0
			++self:lv_aant_toe
			++nImp
		endif
		cBuffer:=ptrHandle:FReadLine(ptrHandle)
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	ptrHandle:=NULL_OBJECT
	AAdd(self:aMessages,"Imported ING file:"+oFs:FileName+" "+Str(nImp,-1)+" imported of "+Str(nTrans,-1)+" transactions")
	SetDecimalSep(cSep)  // restore decimal separator
	RETURN true
METHOD ImportSA(oFb as MyFileSpec) as logic CLASS TeleMut
	* Import of SA Standard\Bank data into teletrans.dbf
	LOCAL oHlS as HulpSA
	LOCAL m57_laatste := {} as ARRAY
	LOCAL i, TelPtr as int
	LOCAL lv_mm := Month(Today()), lv_jj := Year(Today()) as int
	LOCAL lv_loaded as LOGIC,  hlpbank as USUAL
	LOCAL lv_description, lv_bankAcntOwn,lv_addsub as STRING
	LOCAL cSep as int
	LOCAL lSuccess:=true as LOGIC
	LOCAL cDelim:=CHR(9) as STRING
	LOCAL ptrHandle as MyFile
	LOCAL hl_boekdat as STRING
	LOCAL oFs:=oFb as FileSpec
	LOCAL cBuffer as STRING, nCnt,nTot as int
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate, ptPay, ptDesc, ptDep, ptBal, nVnr as int
	LOCAL pbType as STRING
	LOCAL lv_amount, Hl_balan as FLOAT
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
	nTot++
	hl_boekdat:=AFields[ptDate]
	ld_bookingdate:=SToD(SubStr(hl_boekdat,1,4)+SubStr(hl_boekdat,6,2)+SubStr(hl_boekdat,9,2))
	IF self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
		cBuffer:=ptrHandle:FReadLine(ptrHandle)
		aFields:=Split(cBuffer,cDelim)
		loop
	ENDIF
    lv_description:=AllTrim(StrTran(AllTrim(AFields[ptDesc]),'"',''))
    lv_amount:=AbsFloat(Val(AFields[ptPay]))
    IF lv_amount=0
	    lv_amount:=Val(AFields[ptDep])
	    lv_addsub:="B"
	ELSE
		lv_addsub:="A"
	ENDIF
    IF Empty(lv_amount)  && geen lege mutaties laden
		cBuffer:=ptrHandle:FReadLine(ptrHandle)
		aFields:=Split(cBuffer,cDelim)
    	loop
    ENDIF
	lv_amount:=Round(lv_amount,DecAantal)
	Hl_balan:=Val(AFields[ptBal])
  	lv_description:=AddSlashes(AllTrim(lv_description))
    * controleer op reeds geladen zijn van mutatie:
	IF self:AllreadyImported(ld_bookingdate,lv_amount,lv_addsub,lv_description,"SAB","","","")
		cBuffer:=ptrHandle:FReadLine(ptrHandle)
		aFields:=Split(cBuffer,cDelim)
        loop
	ENDIF
	oStmnt:=SQLStatement{"insert into teletrans set	"+;
		"bankaccntnbr='"+lv_bankAcntOwn+"'"+;
		",bookingdate='"+SQLdate(Min(Today(),ld_bookingdate))+"'"+;  // no dates in the future)+"'"+;
		",kind='SAB'"+;
		",amount='"+Str(lv_amount,-1)+"'"+;
		",addsub='"+lv_addsub	+"'"+;
		",code_mut_r='M'"+;
		",seqnr='"+Str(Val(SubStr(lv_description,-4,4)),-1)+"'"+;
		",description='"+lv_description	+"'",oConn}
	oStmnt:Execute()
	if	oStmnt:NumSuccessfulRows>0
		++lv_aant_toe
		nCnt++
	endif
	cBuffer:=ptrHandle:FReadLine(ptrHandle)
	aFields:=Split(cBuffer,cDelim)
ENDDO
ptrHandle:Close()
ptrHandle:=null_object
SetDecimalSep(cSep)  // restore decimal separator 
AAdd(self:aMessages,"Imported SA file:"+oFb:FileName+" "+Str(nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions")

RETURN true
METHOD ImportTL1(oFm as MyFileSpec) as logic CLASS TeleMut
	* Import of Total IN  data of Swedisch PlusGiroT into teletrans.dbf
*	Import of one TL1 telebnk transaction file
	LOCAL oHlM as HlpMT940
	LOCAL i, nEndAmnt, nDC,nCnt,nTot as int
	LOCAL lv_bankAcntOwn, lv_Oms, lv_addsub, lv_AmountStr, lv_reference,lv_NameContra, lv_address,lv_zip,lv_city, lv_country, lv_description as STRING
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
  	nTot++
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

	IF !self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
  		IF !self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,lv_reference,lv_BankAcntContra,lv_NameContra,"") .and.!Empty(lv_Amount)
			oStmnt:=SQLStatement{"insert into teletrans set	"+;
			"bankaccntnbr='"+lv_bankAcntOwn+"'"+;
			",contra_bankaccnt='"+lv_BankAcntContra+"'"+;
			",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
			",kind='"+lv_reference+"'"+;
			",amount='"+Str(lv_Amount,-1)+"'"+;
			",addsub='"+lv_addsub	+"'"+;
			",contra_name='"+lv_NameContra	+"'"+;
			",description='"+AllTrim(lv_description)	+"'",oConn}
			oStmnt:Execute()
			if	oStmnt:NumSuccessfulRows>0
				++lv_aant_toe 
				nCnt++
			ENDIF
  		endif
	ENDIF
ENDDO
		

oHlp:=FileSpec{oHlM:Filespec:Fullpath}
oHlM:Close()
oHlM:=null_object
oHlp:DELETE()
AAdd(self:aMessages,"Imported TL/1 file:"+oFm:FileName+" "+Str(nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions")

RETURN true
METHOD ImportUA(oFr as MyFileSpec) as logic CLASS TeleMut
	* Import of one bankstatements of Ukraine Bank into teletrans.dbf
LOCAL cBuffer,childbuffer AS STRING
LOCAL ptrHandle
LOCAL oTelTr:=self:oTelTr as SQLSelect
LOCAL UADocument, UAChildDocument AS XMLDocument
LOCAL childfound, recordfound,lv_loaded as LOGIC
LOCAL ChildName AS STRING
LOCAL lv_Amount as FLOAT
LOCAL lv_NameContra,lv_description, Docid, kind,currency,lv_bankAcntOwn,lv_BankAcntContra,lv_addsub,Datestr,entitycode,contrabankid as STRING
LOCAL transdate, rppdate AS DATE
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
	transdate:=Today()
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
					transdate:=CToD(Datestr)
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
					kind := SubStr(Docid,1,3)
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

	IF self:TooOldTeleTrans(lv_bankAcntOwn,transdate)	
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
	// check of record allreaedy in database: 
	nTot++
	IF self:AllreadyImported(transdate,lv_Amount,lv_addsub,lv_description,kind,lv_BankAcntContra,lv_NameContra,"")
		recordfound:=UADocument:GetNextSibbling()
      loop
	ENDIF
	oStmnt:=SQLStatement{"insert into teletrans set	"+;
	"contra_bankaccnt='"+lv_BankAcntContra+"'"+;
	",contra_name='"+lv_NameContra+"'"+;
	",bankaccntnbr='"+lv_bankAcntOwn+"'"+;
	",bookingdate='"+SQLdate(transdate)+"'"+;
	",kind='"+kind +"'"+;
	",amount='"+Str(lv_Amount,-1)+"'"+;
	",addsub='"+lv_addsub	+"'"+;
	",code_mut_r='M'"+;
	",seqnr="+Str(nVnr,-1)+;
	",description='"+lv_description	+"'",oConn}
	oStmnt:Execute()
	if	oStmnt:NumSuccessfulRows>0
		++self:lv_aant_toe
		nCnt++
	endif
	recordfound:=UADocument:GetNextSibbling()
ENDDO 
AAdd(self:aMessages,"Imported UA file:"+oFr:FileName+" "+Str(nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions")

RETURN TRUE
METHOD ImportVerwInfo(oFm as MyFileSpec) as logic CLASS TeleMut
	* Import of VerwerkingsInfo data from Equens into teletrans.dbf
	*	Import of one VerwInfo telebnk transaction file
	LOCAL oHlM as HlpMT940
	LOCAL i, nEndAmnt, nDC, nTrans,nTot as int
	LOCAL lv_bankAcntOwn, lv_description, lv_Oms, lv_addsub, lv_AmountStr, lv_reference, lv_NameContra, lv_straat, lv_woonplaats as STRING
	Local betkenm as string
	LOCAL lv_loaded as LOGIC,  lv_BankAcntContra, lv_budget,lv_persid as string, cText, recordcode, batchsoort as STRING
	LOCAL lv_Amount as FLOAT
	LOCAL cSep as STRING
	LOCAL lSuccess:=true as LOGIC
	LOCAL oHlp as Filespec
	LOCAL ld_bookingdate as date 
	local oDue as SQLSelect, oAcc as SQLSelect
	local oStMnt as SQLStatement
	
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
		lv_reference:=""
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
					lv_reference:="CLL" 
					lv_persid:=ZeroTrim(SubStr(betkenm,2,5)) 
					oDue:=SQLSelect{"select a.accnumber from account a, dueamount d, subscription s where s.subscribid=d.subscribid and s.accid=a.accid and "+;
						"s.personid="+lv_persid+" and d.invoicedate='"+;
						SQLdate(SToD(SubStr(betkenm,7,8)))+"' and seqnr="+ZeroTrim(SubStr(betkenm,15)),oConn} //persid + DTOS(invoicedate) + seqnr
					if oDue:Reccount>0
						lv_budget:= oAcc:ACCNUMBER
					endif
				else	 
					lv_reference:="ACC"
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
				lv_reference:=SubStr(oHlM:MTLINE,36,4)	// banken transactiecode
				if lv_reference=="1144" .or. lv_reference="1145"
					lv_reference:="ACC" // acceptgiro 
				elseif SubStr(lv_reference,1,3)=="022"
					lv_reference:="COL"
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
		IF !self:TooOldTeleTrans(lv_bankAcntOwn,ld_bookingdate)
			if !Empty(lv_budget)
				lv_budget:=iif(SQLSelect{"select accnumber from account where accnumber='"+lv_budget+"'",oConn}:Reccount>0,lv_budget,'')
			endif
			if !Empty(lv_persid)
				lv_persid:=iif(SQLSelect{"select persid from person where persid='"+lv_persid+"'",oConn}:Reccount>0,lv_persid,'')
			endif
			IF !self:AllreadyImported(ld_bookingdate,lv_Amount,lv_addsub,lv_description,lv_reference,lv_BankAcntContra,lv_NameContra,lv_budget) .and.!Empty(lv_Amount)
				oStMnt:=SQLStatement{"insert into teletrans set	"+;
					"contra_bankaccnt='"+lv_BankAcntContra+"'"+;
					",contra_name='"+lv_NameContra+"'"+;
					",bankaccntnbr='"+lv_bankAcntOwn+"'"+;
					",bookingdate='"+SQLdate(ld_bookingdate)+"'"+;
					",kind='"+lv_reference +"'"+;
					",amount='"+Str(lv_Amount,-1)+"'"+;
					",addsub='"+lv_addsub	+"'"+;
					iif(Empty(lv_budget),'',",budgetcd='"+lv_budget	+"'")+;
					iif(Empty(lv_persid),"",",persid='"+lv_persid +"'")+;
					",description='"+lv_description	+"'",oConn}
				oStMnt:Execute()
				if	oStMnt:NumSuccessfulRows>0
					++self:lv_aant_toe 
					nTrans++
				endif
			ENDIF
		ENDIF
		lv_description:=""
	ENDDO

	oHlp:=FileSpec{oHlM:Filespec:Fullpath}
	oHlM:Close()
	oHlM:=null_object 
	AAdd(self:aMessages,"Imported "+Str(nTrans,-1)+" of "+Str(nTot,-1)+" transactions from VerwInfo file:"+oFm:FileName)

	oHlp:DELETE()
	RETURN true
METHOD INIT(Gift,oOwner) CLASS TeleMut
	* Gift: true: next gift
	*       false: next nongift
	local oSelBank as SelBankAcc 
	local oBank,oAcc as SQLSelect
	// 	local m57_bank:=self:m57_BankAcc as array
	local cReq as string 
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
	oBank:SQLString:= "select banknumber,usedforgifts from bankaccount where banknumber<>'' and telebankng=1" 
	oBank:Execute()
	DO WHILE .not.oBank:EOF
		AAdd(self:m57_BankAcc,{oBank:banknumber,iif(ConI(oBank:usedforgifts)=1,true, false),null_date})
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
METHOD SkipMut()  CLASS TeleMut
	* Skip of telebanking transaction aftre showing it
	SQLStatement{"update teletrans set lock_id=0 where teletrid="+Str(self:CurTelId,-1),oConn}:execute()
return
METHOD TooOldTeleTrans(banknbr as string,transdate as date,NbrDays:=120 as int) as logic CLASS TeleMut
	// check if found banknumber is part of telebanking accounts within the system
	// 	Default(@NbrDays,120) 
	local oStMnt as SQLStatement
	local oBank as SQLSelect
	IF (self:CurTelePtr:=AScan(m57_BankAcc,{|x| x[1]==AllTrim(banknbr)}))=0
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
				oBank:= SqlSelect{"select banknumber,usedforgifts from bankaccount where banknumber='"+AllTrim(banknbr)+"'",oConn}
				if oBank:Reccount>0 
					AAdd(self:m57_BankAcc,{oBank:banknumber,iif(ConI(oBank:usedforgifts)=1,true, false),null_date})
					ASort(self:m57_BankAcc,,,{|x,y| x[1]<=y[1]} ) 
					LogEvent(self,"Bank account "+banknbr+" changed to telebanking account in system data")
				endif
			endif
		else
			RETURN true
		ENDIF		
	ENDIF
	// check if transaction is too old in comparison with latest recorded for this bankaccount
	IF transdate +NbrDays < m57_BankAcc[self:CurTelePtr,3]
		RETURN TRUE
	ENDIF
	RETURN FALSE
