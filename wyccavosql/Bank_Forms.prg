RESOURCE BankBrowser DIALOGEX  14, 9, 421, 234
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Delete", BANKBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 357, 144, 53, 12
	CONTROL	"New", BANKBROWSER_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 356, 107, 53, 12
	CONTROL	"Edit", BANKBROWSER_EDITBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 356, 66, 53, 12
	CONTROL	"", BANKBROWSER_BANKSUB_FORM, "static", WS_CHILD|WS_BORDER, 12, 29, 326, 172
	CONTROL	"Find", BANKBROWSER_FINDBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 196, 7, 53, 12
	CONTROL	"", BANKBROWSER_SEARCHUNI, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 7, 116, 12
	CONTROL	"Search like google:", BANKBROWSER_FIXEDTEXT4, "Static", WS_CHILD, 12, 7, 64, 12
	CONTROL	"", BANKBROWSER_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 324, 7, 47, 12
	CONTROL	"Found:", BANKBROWSER_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 288, 8, 27, 12
END

CLASS BankBrowser INHERIT DataWindowExtra 

	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCFindButton AS PUSHBUTTON
	PROTECT oDCSearchUni AS SINGLELINEEDIT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oSFBankSub_Form AS BankSub_Form

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT oBank as SQLSelect
  export cFields, cFrom, cWhere,cOrder as string

METHOD Close(oEvent) CLASS BankBrowser
	SUPER:Close(oEvent)
	//Put your changes here
InitGlobals()	
SELF:oSFBankSub_Form:Close()
SELF:oSFBankSub_Form:Destroy()
SELF:Destroy()

	RETURN NIL

METHOD DeleteButton( ) CLASS BankBrowser
	LOCAL oTextBox AS TextBox
	IF SELF:Server:EOF.or.SELF:Server:BOF
		(Errorbox{,"Select a pbank account first"}):Show()
		RETURN
	ENDIF
	
	oTextBox := TextBox{ SELF, "Delete Bank Account",;
		"Delete Bank Account?" }	
	oTextBox:Type := BUTTONYESNO + BOXICONQUESTIONMARK
	
	IF ( oTextBox:Show() == BOXREPLYYES )
		oSFBankSub_Form:Delete()
		oSFBankSub_Form:Browser:REFresh()

	ENDIF


METHOD EditButton(lNew ) CLASS BankBrowser
	LOCAL oEditBankWindow AS EditBank
	Default(@lNew,FALSE)
	IF !lNew.and.(SELF:Server:EOF.or.SELF:Server:BOF)
		(Errorbox{,"Select a bank account first"}):Show()
		RETURN
	ENDIF
	
	oEditBankWindow := EditBank{ self:Owner,,self:Server,{lNew,self}  }
	oEditBankWindow:Show()

RETURN NIL
METHOD FilePrint CLASS BankBrowser
LOCAL oSel as SQLSelect
LOCAL kopregels as ARRAY
LOCAL nRow,n,k as int
LOCAL nPage as int
LOCAL oReport as PrintDialog
local cPayAhead, cSingledest, cCodOms,mCodH as string 
local cFields as string
local cWhere as string
local cFrom as string 
local cTab:=Space(1) as string

oReport := PrintDialog{self,oLan:RGet("BankAccounts"),,142,DMORIENT_LANDSCAPE }

oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
cFields:="b.*,a.description,a.accnumber,sd.description as accountsingle,pa.description as AccountPaymnt "
cFrom:="Account a, bankaccount b"+;
		" left join account sd on (sd.accid=b.singledst) left join account pa on (pa.accid=b.payahead)"
oSel := SQLSelect{"select "+cFields+" from "+cFrom+" where "+self:cWhere+" order by "+self:cOrder,oConn}
kopregels := {oLan:RGet('BankAccounts',,"@!"),' ',;
oLan:RGet("Number",20,"!")+cTab+oLan:RGet("Account",25,"!")+cTab+;
oLan:RGet("Gifts/Payments",14,"!","C")+cTab+oLan:RGet("TeleBanking",11,"!","C")+cTab+;
oLan:RGet("Account en route",20)+cTab+;
oLan:RGet("Single destintn",20)+cTab+;
oLan:RGet("FrstGvrs mlc",12)+cTab+;
oLan:RGet("Overwrite Sys",13),cTab}
nRow := 0
nPage := 0
DO WHILE .not. oSel:EOF 
	cPayAhead:=""
	cSingledest:=""
	cCodOms:=""
	IF .not.Empty(oSel:FGMLCODES)
		FOR n:=1 to 8 step 3
			mCodH  := SubStr(oSel:FGMLCODES,n,2)
			IF Empty(mCodH)
				exit
			ELSE
				IF (k:=AScan(mail_abrv,{|x|x[2]==mCodH}))>0
					cCodOms:=cCodOms+Pad(mail_abrv[k,1],4)
				ENDIF
			endif
		NEXT
	ENDIF		

   oReport:PrintLine(@nRow,@nPage,Pad(oSel:banknumber,20)+cTab+Pad(oSel:Description,25)+cTab+;
   PadC(iif(oSel:usedforgifts==1,"X",Space(1)),14)+cTab+PadC(iif(oSel:telebankng==0,Space(1),"X"),11)+cTab+;
   iif(Empty(oSel:AccountPaymnt),Space(20),Pad(oSel:AccountPaymnt,20))+cTab+;
   iif(empty(oSel:accountsingle),space(20),Pad(oSel:accountsingle,20))+cTab+Pad(cCodOms,12)+;
   cTab+PadC(iif(Empty(oSel:SYSCODOVER),Space(1),"X"),13),kopregels)
   oSel:skip()
ENDDO
oReport:prstart()
oReport:prstop() 
RETURN SELF
METHOD FindButton( ) CLASS BankBrowser 
	local aKeyw:={} as array
	local aFields:={"a.accnumber","a.description","b.banknumber"} as array
	local i,j as int 
	self:cOrder:="a.description"
	self:cWhere:="a.accid=b.accid"
	if !Empty(self:SearchUni)
		self:SearchUni:=Lower(AllTrim(self:SearchUni)) 
		aKeyw:=GetTokens(self:SearchUni)
		for i:=1 to Len(aKeyw)
			cWhere+=" and ("
			for j:=1 to Len(AFields)
				cWhere+=iif(j=1,""," or ")+AFields[j]+" like '%"+aKeyw[i,1]+"%'"
			next
			cWhere+=")"
		next
	endif
	self:oBank:SQLString :="select "+self:cFields+" from "+self:cFrom+" where "+cWhere+" order by "+self:cOrder 
   self:oBank:Execute() 
	if !Empty(self:oBank:status) 
	 	LogEvent(,"findbutton Bank:"+self:oAcc:status:description+"( statmnt:"+self:oBank:SQLString,"LogErrors")
	endif
   self:oBank:GoTop()
   self:GoTop()
  	self:oDCFound:TextValue :=Str(self:oBank:Reccount,-1)

RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS BankBrowser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"BankBrowser",_GetInst()},iCtlID)

oCCDeleteButton := PushButton{SELF,ResourceID{BANKBROWSER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PX

oCCNewButton := PushButton{SELF,ResourceID{BANKBROWSER_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}
oCCNewButton:OwnerAlignment := OA_PX

oCCEditButton := PushButton{SELF,ResourceID{BANKBROWSER_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:OwnerAlignment := OA_PX

oCCFindButton := PushButton{SELF,ResourceID{BANKBROWSER_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Find",NULL_STRING,NULL_STRING}

oDCSearchUni := SingleLineEdit{SELF,ResourceID{BANKBROWSER_SEARCHUNI,_GetInst()}}
oDCSearchUni:HyperLabel := HyperLabel{#SearchUni,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchUni:FocusSelect := FSEL_TRIM
oDCSearchUni:TooltipText := "Enter one or more (part of) key values "
oDCSearchUni:UseHLforToolTip := True

oDCFixedText4 := FixedText{SELF,ResourceID{BANKBROWSER_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Search like google:",NULL_STRING,NULL_STRING}

oDCFound := FixedText{SELF,ResourceID{BANKBROWSER_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{BANKBROWSER_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

SELF:Caption := "Bank Browser"
SELF:HyperLabel := HyperLabel{#BankBrowser,"Bank Browser",NULL_STRING,NULL_STRING}
SELF:AllowServerClose := True
SELF:PreventAutoLayout := True
SELF:Menu := WOMENU{}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFBankSub_Form := BankSub_Form{SELF,BANKBROWSER_BANKSUB_FORM}
oSFBankSub_Form:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD NewButton( ) CLASS BankBrowser
		SELF:EditButton(TRUE)
RETURN NIL
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS BankBrowser
	//Put your PostInit additions here
	self:SetTexts()
	self:oSFBankSub_Form:Browser:SetStandardStyle( gbsReadOnly )
	self:GoTop() 
  	self:oDCFound:TextValue :=Str(self:oBank:Reccount,-1)

	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS BankBrowser
	//Put your PreInit additions here 
	self:cFrom:="bankaccount b, account a"
	self:cFields:="b.bankid,b.banknumber,a.description,a.accnumber,a.accid,b.telebankng,b.usedforgifts"
	self:cOrder:="a.description"
	self:cWhere:="a.accid=b.accid"
	oBank:=SQLSelect{"select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+" order by "+self:cOrder,oConn}
	RETURN nil
ACCESS SearchUni() CLASS BankBrowser
RETURN SELF:FieldGet(#SearchUni)

ASSIGN SearchUni(uValue) CLASS BankBrowser
SELF:FieldPut(#SearchUni, uValue)
RETURN uValue

STATIC DEFINE BANKBROWSER_BANKSUB_FORM := 103 
STATIC DEFINE BANKBROWSER_DELETEBUTTON := 100 
STATIC DEFINE BANKBROWSER_EDITBUTTON := 102 
STATIC DEFINE BANKBROWSER_FINDBUTTON := 104 
STATIC DEFINE BANKBROWSER_FIXEDTEXT4 := 106 
STATIC DEFINE BANKBROWSER_FOUND := 107 
STATIC DEFINE BANKBROWSER_FOUNDTEXT := 108 
STATIC DEFINE BANKBROWSER_NEWBUTTON := 101 
STATIC DEFINE BANKBROWSER_SEARCHUNI := 105 
STATIC DEFINE BANKREG_BANKNUMMER := 103 
STATIC DEFINE BANKREG_BETAALIND := 105 
STATIC DEFINE BANKREG_COMALL := 108 
STATIC DEFINE BANKREG_COMFL := 107 
STATIC DEFINE BANKREG_GIFTENIND := 104 
STATIC DEFINE BANKREG_GIFTSALL := 110 
STATIC DEFINE BANKREG_GROUPBOX1 := 113 
STATIC DEFINE BANKREG_OKBUTTON := 115 
STATIC DEFINE BANKREG_OPENAC := 111 
STATIC DEFINE BANKREG_OPENALL := 112 
STATIC DEFINE BANKREG_PO := 109 
STATIC DEFINE BANKREG_REK := 114 
STATIC DEFINE BANKREG_SC_BANKNUMMER := 100 
STATIC DEFINE BANKREG_SC_REK := 101 
STATIC DEFINE BANKREG_SC_TELEBANKNG := 102 
STATIC DEFINE BANKREG_TELEBANKNG := 106 
RESOURCE BankSub_Form DIALOGEX  20, 18, 323, 168
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Bank/Giro:", BANKSUB_FORM_SC_BANKNUMMER, "Static", WS_CHILD, 13, 14, 37, 13
	CONTROL	"AccountId:", BANKSUB_FORM_SC_REK, "Static", WS_CHILD, 13, 29, 37, 12
	CONTROL	"Account for commission:", BANKSUB_FORM_SC_PROVISIERK, "Static", WS_CHILD, 13, 73, 79, 13
	CONTROL	"Bank/Giro", BANKSUB_FORM_BANKNUMBER, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 102, 14, 60, 13, WS_EX_CLIENTEDGE
	CONTROL	"Account#", BANKSUB_FORM_DESCRIPTION, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 102, 29, 22, 12, WS_EX_CLIENTEDGE
	CONTROL	"Gifts/Payments?", BANKSUB_FORM_GIFTENIND, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 102, 44, 80, 12
	CONTROL	"Account commission", BANKSUB_FORM_PROVIACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 102, 73, 22, 13, WS_EX_CLIENTEDGE
	CONTROL	"Account#", BANKSUB_FORM_ACCNTNUMBER1, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 106, 33, 22, 12, WS_EX_CLIENTEDGE
END

CLASS BankSub_Form INHERIT DATAWINDOW 

	PROTECT oDBBANKNUMBER as DataColumn
	PROTECT oDBDESCRIPTION as DataColumn
	PROTECT oDBMGIFTIND as DataColumn
	PROTECT oDBMTELEBANKNG as DataColumn
	PROTECT oDCSC_BANKNUMMER AS FIXEDTEXT
	PROTECT oDCSC_REK AS FIXEDTEXT
	PROTECT oDCSC_PROVISIERK AS FIXEDTEXT
	PROTECT oDCBANKNUMBER AS SINGLELINEEDIT
	PROTECT oDCdescription AS SINGLELINEEDIT
	PROTECT oDCGIFTENIND AS CHECKBOX
	PROTECT oDCPROVIAccount AS SINGLELINEEDIT
	PROTECT oDCAccntnumber1 AS SINGLELINEEDIT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
ACCESS Accntnumber1() CLASS BankSub_Form
RETURN SELF:FieldGet(#Accntnumber1)

ASSIGN Accntnumber1(uValue) CLASS BankSub_Form
SELF:FieldPut(#Accntnumber1, uValue)
RETURN uValue

ACCESS BANKNUMBER() CLASS BankSub_Form
RETURN SELF:FieldGet(#BANKNUMBER)

ASSIGN BANKNUMBER(uValue) CLASS BankSub_Form
SELF:FieldPut(#BANKNUMBER, uValue)
RETURN uValue

ACCESS description() CLASS BankSub_Form
RETURN SELF:FieldGet(#description)

ASSIGN description(uValue) CLASS BankSub_Form
SELF:FieldPut(#description, uValue)
RETURN uValue

ACCESS GIFTENIND() CLASS BankSub_Form
RETURN SELF:FieldGet(#GIFTENIND)

ASSIGN GIFTENIND(uValue) CLASS BankSub_Form
SELF:FieldPut(#GIFTENIND, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS BankSub_Form 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"BankSub_Form",_GetInst()},iCtlID)

oDCSC_BANKNUMMER := FixedText{SELF,ResourceID{BANKSUB_FORM_SC_BANKNUMMER,_GetInst()}}
oDCSC_BANKNUMMER:HyperLabel := HyperLabel{#SC_BANKNUMMER,"Bank/Giro:",NULL_STRING,NULL_STRING}

oDCSC_REK := FixedText{SELF,ResourceID{BANKSUB_FORM_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,"AccountId:",NULL_STRING,NULL_STRING}

oDCSC_PROVISIERK := FixedText{SELF,ResourceID{BANKSUB_FORM_SC_PROVISIERK,_GetInst()}}
oDCSC_PROVISIERK:HyperLabel := HyperLabel{#SC_PROVISIERK,"Account for commission:",NULL_STRING,NULL_STRING}

oDCBANKNUMBER := SingleLineEdit{SELF,ResourceID{BANKSUB_FORM_BANKNUMBER,_GetInst()}}
oDCBANKNUMBER:FieldSpec := BANK{}
oDCBANKNUMBER:HyperLabel := HyperLabel{#BANKNUMBER,"Bank/Giro","Number of bankaccount","BANK"}

oDCdescription := SingleLineEdit{SELF,ResourceID{BANKSUB_FORM_DESCRIPTION,_GetInst()}}
oDCdescription:FieldSpec := Description{}
oDCdescription:HyperLabel := HyperLabel{#description,"Account#","Number of an Account",NULL_STRING}

oDCGIFTENIND := CheckBox{SELF,ResourceID{BANKSUB_FORM_GIFTENIND,_GetInst()}}
oDCGIFTENIND:HyperLabel := HyperLabel{#GIFTENIND,"Gifts/Payments?","Indicates if account can be use for gifts","BankAccount_GIFTENIND"}

oDCPROVIAccount := SingleLineEdit{SELF,ResourceID{BANKSUB_FORM_PROVIACCOUNT,_GetInst()}}
oDCPROVIAccount:FieldSpec := Account_AccNumber{}
oDCPROVIAccount:HyperLabel := HyperLabel{#PROVIAccount,"Account commission","Number of  Account","Rek_REK"}

oDCAccntnumber1 := SingleLineEdit{SELF,ResourceID{BANKSUB_FORM_ACCNTNUMBER1,_GetInst()}}
oDCAccntnumber1:FieldSpec := Account_AccNumber{}
oDCAccntnumber1:HyperLabel := HyperLabel{#Accntnumber1,"Account#","Number of an Account",NULL_STRING}

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#BankSub_Form,"DataWindow Caption",NULL_STRING,NULL_STRING}
SELF:OwnerAlignment := OA_PWIDTH_HEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBBANKNUMBER := DataColumn{BANK{}}
oDBBANKNUMBER:Width := 18
oDBBANKNUMBER:HyperLabel := oDCBANKNUMBER:HyperLabel 
oDBBANKNUMBER:Caption := "Bank/Giro"
self:Browser:AddColumn(oDBBANKNUMBER)

oDBDESCRIPTION := DataColumn{Description{}}
oDBDESCRIPTION:Width := 26
oDBDESCRIPTION:HyperLabel := oDCDESCRIPTION:HyperLabel 
oDBDESCRIPTION:Caption := "Account#"
self:Browser:AddColumn(oDBDESCRIPTION)

oDBMGIFTIND := DataColumn{Indicator{}}
oDBMGIFTIND:Width := 17
oDBMGIFTIND:HyperLabel := HyperLabel{#mGiftInd,"Gifts/Paymnts?",NULL_STRING,NULL_STRING} 
oDBMGIFTIND:Caption := "Gifts/Paymnts?"
oDBmGiftInd:Block := {|x| if(x:usedforgifts==1,'Yes','No')}
oDBmGiftInd:BlockOwner := self:Server
self:Browser:AddColumn(oDBMGIFTIND)

oDBMTELEBANKNG := DataColumn{indicator{}}
oDBMTELEBANKNG:Width := 17
oDBMTELEBANKNG:HyperLabel := HyperLabel{#mTELEBANKNG,"Telebank?",NULL_STRING,NULL_STRING} 
oDBMTELEBANKNG:Caption := "Telebank?"
oDBmTELEBANKNG:Block := {|x| if(x:telebankng==0,'No','Yes')}
oDBmTELEBANKNG:BlockOwner := self:Server
self:Browser:AddColumn(oDBMTELEBANKNG)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mGiftInd() CLASS BankSub_Form
RETURN SELF:FieldGet(#mGiftInd)

ASSIGN mGiftInd(uValue) CLASS BankSub_Form
SELF:FieldPut(#mGiftInd, uValue)
RETURN uValue

ACCESS mTELEBANKNG() CLASS BankSub_Form
RETURN SELF:FieldGet(#mTELEBANKNG)

ASSIGN mTELEBANKNG(uValue) CLASS BankSub_Form
SELF:FieldPut(#mTELEBANKNG, uValue)
RETURN uValue

METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS BankSub_Form
	//Put your PreInit additions here
	oWindow:use(oWindow:oBank)
	RETURN nil
ACCESS PROVIAccount() CLASS BankSub_Form
RETURN SELF:FieldGet(#PROVIAccount)

ASSIGN PROVIAccount(uValue) CLASS BankSub_Form
SELF:FieldPut(#PROVIAccount, uValue)
RETURN uValue

ACCESS usedforgifts() CLASS BankSub_Form
RETURN SELF:FieldGet(#GIFTENIND)

ASSIGN usedforgifts(uValue) CLASS BankSub_Form
SELF:FieldPut(#GIFTENIND, uValue)
RETURN uValue

STATIC DEFINE BANKSUB_FORM_ACCNTNUMBER1 := 107 
STATIC DEFINE BANKSUB_FORM_BANKNUMBER := 103 
STATIC DEFINE BANKSUB_FORM_DESCRIPTION := 104 
STATIC DEFINE BANKSUB_FORM_GIFTENIND := 105 
STATIC DEFINE BANKSUB_FORM_MGIFTIND := 109 
STATIC DEFINE BANKSUB_FORM_MTELEBANKNG := 108 
STATIC DEFINE BANKSUB_FORM_PROVIACCOUNT := 106 
STATIC DEFINE BANKSUB_FORM_SC_BANKNUMMER := 100 
STATIC DEFINE BANKSUB_FORM_SC_PROVISIERK := 102 
STATIC DEFINE BANKSUB_FORM_SC_REK := 101 
CLASS EditBank INHERIT DataWindowExtra 

	PROTECT oDCmBANKNUMMER AS SINGLELINEEDIT
	PROTECT oDCmAccount AS SINGLELINEEDIT
	PROTECT oDCmGIFTENIND AS CHECKBOX
	PROTECT oDCmTelebankng AS CHECKBOX
	PROTECT oDCmGIFTSALL AS CHECKBOX
	PROTECT oDCGroupBox AS GROUPBOX
	PROTECT oDCmOPENALL AS CHECKBOX
	PROTECT oDCmAccountPaymnt AS SINGLELINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCAccButton AS PUSHBUTTON
	PROTECT oDCSC_REK AS FIXEDTEXT
	PROTECT oCCAccButtonP AS PUSHBUTTON
	PROTECT oDCSC_BANKNUMMER AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCSingleDest AS CHECKBOX
	PROTECT oDCmFGCod2 AS COMBOBOX
	PROTECT oDCmFGCod1 AS COMBOBOX
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCmFGCod3 AS COMBOBOX
	PROTECT oCCAccButtonSingle AS PUSHBUTTON
	PROTECT oDCmAccountSingle AS SINGLELINEEDIT
	PROTECT oDCSingleText AS FIXEDTEXT
	PROTECT oDCOverride AS CHECKBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	instance mBANKNUMMER 
	instance mAccount 
	instance mGIFTENIND 
	instance mTelebankng 
	instance mCOMFL 
	instance mCOMALL 
	instance mPO 
	instance mGIFTSALL 
	instance mOPENAC 
	instance mOPENALL 
	instance mAccountPaymnt 
	instance mAccountSingle
	instance mFGCod1  
	instance mFGCod2  
	instance mFGCod3  
  	PROTECT mRek, mRekP, mRekS,mBankId as STRING
	PROTECT cAccountName, cAccountNameP, cAccountNameS as STRING
	PROTECT nCurRec as int
	protect oCaller as object 
	protect oBank as SQLSelect
RESOURCE EditBank DIALOGEX  29, 27, 317, 187
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Bank/Giro:", EDITBANK_MBANKNUMMER, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 108, 22, 122, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITBANK_MACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 108, 36, 106, 13, WS_EX_CLIENTEDGE
	CONTROL	"Gifts/Payments?", EDITBANK_MGIFTENIND, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 108, 51, 79, 13
	CONTROL	"Telebanking?", EDITBANK_MTELEBANKNG, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 8, 51, 80, 11
	CONTROL	"Gifts all", EDITBANK_MGIFTSALL, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 8, 77, 56, 12
	CONTROL	"Automatic telebank recording ", EDITBANK_GROUPBOX, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 66, 100, 48
	CONTROL	"Due amounts all", EDITBANK_MOPENALL, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 8, 92, 64, 12
	CONTROL	"", EDITBANK_MACCOUNTPAYMNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 104, 159, 106, 12, WS_EX_CLIENTEDGE
	CONTROL	"OK", EDITBANK_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 249, 23, 53, 12
	CONTROL	"Cancel", EDITBANK_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 249, 51, 53, 13
	CONTROL	"v", EDITBANK_ACCBUTTON, "Button", WS_CHILD, 212, 36, 15, 13
	CONTROL	"Account general ledger: ", EDITBANK_SC_REK, "Static", WS_CHILD, 8, 37, 79, 12
	CONTROL	"v", EDITBANK_ACCBUTTONP, "Button", WS_CHILD, 210, 158, 15, 13
	CONTROL	"Bank/Giro:", EDITBANK_SC_BANKNUMMER, "Static", WS_CHILD, 9, 23, 37, 12
	CONTROL	"Account payments en route:", EDITBANK_FIXEDTEXT2, "Static", WS_CHILD, 8, 159, 94, 12
	CONTROL	"Single destination for gifts?", EDITBANK_SINGLEDEST, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 108, 66, 104, 11
	CONTROL	"", EDITBANK_MFGCOD2, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_VSCROLL, 172, 107, 61, 72
	CONTROL	"", EDITBANK_MFGCOD1, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_VSCROLL, 108, 107, 61, 72
	CONTROL	"Mailing codes for first givers via this bank account", EDITBANK_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|NOT WS_VISIBLE, 104, 96, 204, 40
	CONTROL	"", EDITBANK_MFGCOD3, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_VSCROLL, 236, 107, 61, 72
	CONTROL	"v", EDITBANK_ACCBUTTONSINGLE, "Button", WS_CHILD|NOT WS_VISIBLE, 284, 81, 15, 12
	CONTROL	"", EDITBANK_MACCOUNTSINGLE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 180, 81, 106, 12, WS_EX_CLIENTEDGE
	CONTROL	"Account destination:", EDITBANK_SINGLETEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 108, 81, 68, 12
	CONTROL	"Override system default mailing codes?", EDITBANK_OVERRIDE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 108, 121, 140, 11
END

METHOD AccButton(lUnique ) CLASS EditBank
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter(,{"AK"},"N",0)
// 	AccountSelect(self,AllTrim(oDCmAccount:TEXTValue ),"General Ledger Account of Bank Account",lUnique,afilter[2],afilter[1],oAccount,,false)
	AccountSelect(self,AllTrim(oDCmAccount:TEXTValue ),"General Ledger Account of Bank Account",lUnique,cfilter)
	RETURN nil
METHOD AccButtonP(lUnique ) CLASS EditBank
	LOCAL cfilter as string
	Default(@lUnique,FALSE)	
	cfilter:=MakeFilter(,{"AK"},"N",0)
// 	AccountSelect(self,AllTrim(oDCmAccountPaymnt:TEXTValue ),"General Ledger Account of Interbank fit",lUnique,afilter[2],afilter[1],oAccount,,false)
	AccountSelect(self,AllTrim(oDCmAccountPaymnt:TEXTValue ),"General Ledger Account of Interbank fit",lUnique,cfilter)
	RETURN nil
METHOD AccButtonSingle(lUnique ) CLASS EditBank 
	LOCAL cfilter as string
	Default(@lUnique,FALSE) 
	cfilter:=MakeFilter(,{"BA","PA"},,1,false,{mRek,mRekP})
	//oAccount:ClearFilter()
	//oAccount:SetFilter("REK# mRek .and. REK# mRekP .and. GIFTALWD")
// 	AccountSelect(self,AllTrim(self:oDCmAccountSingle:TEXTValue ),"General Ledger Account of destination",lUnique,afilter[2],afilter[1],oAccount,,false)
	AccountSelect(self,AllTrim(self:oDCmAccountSingle:TEXTValue ),"General Ledger Account of destination",lUnique,cfilter)
	RETURN nil
METHOD ButtonClick(oControlEvent) CLASS EditBank
	LOCAL oControl AS Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:NameSym==#mTelebankng.or.oControl:NameSym==#mGIFTENIND .or.oControl:NameSym==#SingleDest
		SELF:SetTele()
	ENDIF
	RETURN NIL

METHOD CancelButton( ) CLASS EditBank
SELF:EndWindow()
RETURN
METHOD Close(oEvent) CLASS EditBank
	SUPER:Close(oEvent)
	//Put your changes here
	SELF:Destroy()
	RETURN NIL

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS EditBank
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "MACCOUNT".and.!AllTrim(oControl:Value)==AllTrim(cAccountName)
			cAccountName:=AllTrim(oControl:VALUE) 
			if Empty(cAccountName)  //emptied?
				self:mRek :=  "0"
				self:oDCmAccount:TEXTValue := ""
			else
				self:AccButton(true)
			endif
			RETURN
		ELSEIF oControl:Name == "MACCOUNTPAYMNT".and.!AllTrim(oControl:Value)==AllTrim(cAccountNameP)
			cAccountNameP:=AllTrim(oControl:Value)
			if Empty(cAccountNameP)  //emptied?
				self:mRekP :=  "0"
				self:oDCmAccountPaymnt:TEXTValue := ""
			else
				self:AccButtonP(true)
			endif
			RETURN
		ELSEIF oControl:Name == "MACCOUNTSINGLE".and.!AllTrim(oControl:VALUE)==AllTrim(cAccountNameS)
			cAccountNameS:=AllTrim(oControl:VALUE)
			if Empty(cAccountNameS)  //emptied?
				self:mRekS :=  "0"
				self:oDCmAccountSingle:TEXTValue := ""
			else
				self:AccButtonSingle(true)
			endif
			RETURN
		ENDIF
	ENDIF
	RETURN NIL

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditBank 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditBank",_GetInst()},iCtlID)

oDCmBANKNUMMER := SingleLineEdit{SELF,ResourceID{EDITBANK_MBANKNUMMER,_GetInst()}}
oDCmBANKNUMMER:FieldSpec := BANK{}
oDCmBANKNUMMER:HyperLabel := HyperLabel{#mBANKNUMMER,"Bank/Giro:","Number of bankaccount","BANK"}

oDCmAccount := SingleLineEdit{SELF,ResourceID{EDITBANK_MACCOUNT,_GetInst()}}
oDCmAccount:HyperLabel := HyperLabel{#mAccount,NULL_STRING,"Number of account",NULL_STRING}
oDCmAccount:FieldSpec := MEMBERACCOUNT{}

oDCmGIFTENIND := CheckBox{SELF,ResourceID{EDITBANK_MGIFTENIND,_GetInst()}}
oDCmGIFTENIND:HyperLabel := HyperLabel{#mGIFTENIND,"Gifts/Payments?","Indicates if account can be use for gifts","BankAccount_GIFTENIND"}

oDCmTelebankng := CheckBox{SELF,ResourceID{EDITBANK_MTELEBANKNG,_GetInst()}}
oDCmTelebankng:HyperLabel := HyperLabel{#mTelebankng,"Telebanking?",NULL_STRING,NULL_STRING}

oDCmGIFTSALL := CheckBox{SELF,ResourceID{EDITBANK_MGIFTSALL,_GetInst()}}
oDCmGIFTSALL:HyperLabel := HyperLabel{#mGIFTSALL,"Gifts all",NULL_STRING,"BankAccount_GIFTSALL"}
oDCmGIFTSALL:FieldSpec := BankAccount_GIFTSALL{}

oDCGroupBox := GroupBox{SELF,ResourceID{EDITBANK_GROUPBOX,_GetInst()}}
oDCGroupBox:HyperLabel := HyperLabel{#GroupBox,"Automatic telebank recording ",NULL_STRING,NULL_STRING}

oDCmOPENALL := CheckBox{SELF,ResourceID{EDITBANK_MOPENALL,_GetInst()}}
oDCmOPENALL:HyperLabel := HyperLabel{#mOPENALL,"Due amounts all",NULL_STRING,"BankAccount_OPENALL"}
oDCmOPENALL:FieldSpec := BankAccount_OPENALL{}

oDCmAccountPaymnt := SingleLineEdit{SELF,ResourceID{EDITBANK_MACCOUNTPAYMNT,_GetInst()}}
oDCmAccountPaymnt:HyperLabel := HyperLabel{#mAccountPaymnt,NULL_STRING,"Clearing account for automatic collection","Clearing account for automatic collection"}
oDCmAccountPaymnt:FieldSpec := MEMBERACCOUNT{}
oDCmAccountPaymnt:TooltipText := "Clearing account for automatic collection"
oDCmAccountPaymnt:UseHLforToolTip := True

oCCOKButton := PushButton{SELF,ResourceID{EDITBANK_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITBANK_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oCCAccButton := PushButton{SELF,ResourceID{EDITBANK_ACCBUTTON,_GetInst()}}
oCCAccButton:HyperLabel := HyperLabel{#AccButton,"v","Browse in accounts",NULL_STRING}
oCCAccButton:TooltipText := "Browse in accounts"

oDCSC_REK := FixedText{SELF,ResourceID{EDITBANK_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,"Account general ledger: ",NULL_STRING,NULL_STRING}

oCCAccButtonP := PushButton{SELF,ResourceID{EDITBANK_ACCBUTTONP,_GetInst()}}
oCCAccButtonP:HyperLabel := HyperLabel{#AccButtonP,"v","Browse in accounts",NULL_STRING}
oCCAccButtonP:TooltipText := "Browse in accounts"

oDCSC_BANKNUMMER := FixedText{SELF,ResourceID{EDITBANK_SC_BANKNUMMER,_GetInst()}}
oDCSC_BANKNUMMER:HyperLabel := HyperLabel{#SC_BANKNUMMER,"Bank/Giro:",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{EDITBANK_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Account payments en route:",NULL_STRING,NULL_STRING}

oDCSingleDest := CheckBox{SELF,ResourceID{EDITBANK_SINGLEDEST,_GetInst()}}
oDCSingleDest:HyperLabel := HyperLabel{#SingleDest,"Single destination for gifts?",NULL_STRING,NULL_STRING}

oDCmFGCod2 := combobox{SELF,ResourceID{EDITBANK_MFGCOD2,_GetInst()}}
oDCmFGCod2:HyperLabel := HyperLabel{#mFGCod2,NULL_STRING,"Mailing code",NULL_STRING}
oDCmFGCod2:FillUsing(pers_codes)

oDCmFGCod1 := combobox{SELF,ResourceID{EDITBANK_MFGCOD1,_GetInst()}}
oDCmFGCod1:HyperLabel := HyperLabel{#mFGCod1,NULL_STRING,"Mailing code",NULL_STRING}
oDCmFGCod1:FillUsing(pers_codes)

oDCGroupBox2 := GroupBox{SELF,ResourceID{EDITBANK_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Mailing codes for first givers via this bank account","These codes will be assigned to a person at his first gift",NULL_STRING}
oDCGroupBox2:UseHLforToolTip := True

oDCmFGCod3 := combobox{SELF,ResourceID{EDITBANK_MFGCOD3,_GetInst()}}
oDCmFGCod3:HyperLabel := HyperLabel{#mFGCod3,NULL_STRING,"Mailing code",NULL_STRING}
oDCmFGCod3:FillUsing(pers_codes)

oCCAccButtonSingle := PushButton{SELF,ResourceID{EDITBANK_ACCBUTTONSINGLE,_GetInst()}}
oCCAccButtonSingle:HyperLabel := HyperLabel{#AccButtonSingle,"v","Browse in accounts",NULL_STRING}
oCCAccButtonSingle:TooltipText := "Browse in accounts"
oCCAccButtonSingle:UseHLforToolTip := False

oDCmAccountSingle := SingleLineEdit{SELF,ResourceID{EDITBANK_MACCOUNTSINGLE,_GetInst()}}
oDCmAccountSingle:HyperLabel := HyperLabel{#mAccountSingle,NULL_STRING,"Number of account single deistination for gifts",NULL_STRING}
oDCmAccountSingle:FieldSpec := MEMBERACCOUNT{}
oDCmAccountSingle:UseHLforToolTip := True

oDCSingleText := FixedText{SELF,ResourceID{EDITBANK_SINGLETEXT,_GetInst()}}
oDCSingleText:HyperLabel := HyperLabel{#SingleText,"Account destination:",NULL_STRING,NULL_STRING}

oDCOverride := CheckBox{SELF,ResourceID{EDITBANK_OVERRIDE,_GetInst()}}
oDCOverride:HyperLabel := HyperLabel{#Override,"Override system default mailing codes?","Do not assign default maling codes specified in system parameters",NULL_STRING}
oDCOverride:UseHLforToolTip := True

SELF:Caption := "Edit of a Bank Account"
SELF:HyperLabel := HyperLabel{#EditBank,"Edit of a Bank Account",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mAccount() CLASS EditBank
RETURN SELF:FieldGet(#mAccount)

ASSIGN mAccount(uValue) CLASS EditBank
SELF:FieldPut(#mAccount, uValue)
RETURN uValue

ACCESS mAccountPaymnt() CLASS EditBank
RETURN SELF:FieldGet(#mAccountPaymnt)

ASSIGN mAccountPaymnt(uValue) CLASS EditBank
SELF:FieldPut(#mAccountPaymnt, uValue)
RETURN uValue

ACCESS mAccountSingle() CLASS EditBank
RETURN SELF:FieldGet(#mAccountSingle)

ASSIGN mAccountSingle(uValue) CLASS EditBank
SELF:FieldPut(#mAccountSingle, uValue)
RETURN uValue

ACCESS mBANKNUMMER() CLASS EditBank
RETURN SELF:FieldGet(#mBANKNUMMER)

ASSIGN mBANKNUMMER(uValue) CLASS EditBank
SELF:FieldPut(#mBANKNUMMER, uValue)
RETURN uValue

ACCESS mCOMALL() CLASS EditBank
RETURN SELF:FieldGet(#mCOMALL)

ASSIGN mCOMALL(uValue) CLASS EditBank
SELF:FieldPut(#mCOMALL, uValue)
RETURN uValue

ACCESS mCOMFL() CLASS EditBank
RETURN SELF:FieldGet(#mCOMFL)

ASSIGN mCOMFL(uValue) CLASS EditBank
SELF:FieldPut(#mCOMFL, uValue)
RETURN uValue

ACCESS mFGCod1() CLASS EditBank
RETURN SELF:FieldGet(#mFGCod1)

ASSIGN mFGCod1(uValue) CLASS EditBank
SELF:FieldPut(#mFGCod1, uValue)
RETURN uValue

ACCESS mFGCod2() CLASS EditBank
RETURN SELF:FieldGet(#mFGCod2)

ASSIGN mFGCod2(uValue) CLASS EditBank
SELF:FieldPut(#mFGCod2, uValue)
RETURN uValue

ACCESS mFGCod3() CLASS EditBank
RETURN SELF:FieldGet(#mFGCod3)

ASSIGN mFGCod3(uValue) CLASS EditBank
SELF:FieldPut(#mFGCod3, uValue)
RETURN uValue

ACCESS mGIFTENIND() CLASS EditBank
RETURN SELF:FieldGet(#mGIFTENIND)

ASSIGN mGIFTENIND(uValue) CLASS EditBank
SELF:FieldPut(#mGIFTENIND, uValue)
RETURN uValue

ACCESS mGIFTSALL() CLASS EditBank
RETURN SELF:FieldGet(#mGIFTSALL)

ASSIGN mGIFTSALL(uValue) CLASS EditBank
SELF:FieldPut(#mGIFTSALL, uValue)
RETURN uValue

ACCESS mOPENAC() CLASS EditBank
RETURN SELF:FieldGet(#mOPENAC)

ASSIGN mOPENAC(uValue) CLASS EditBank
SELF:FieldPut(#mOPENAC, uValue)
RETURN uValue

ACCESS mOPENALL() CLASS EditBank
RETURN SELF:FieldGet(#mOPENALL)

ASSIGN mOPENALL(uValue) CLASS EditBank
SELF:FieldPut(#mOPENALL, uValue)
RETURN uValue

ACCESS mPO() CLASS EditBank
RETURN SELF:FieldGet(#mPO)

ASSIGN mPO(uValue) CLASS EditBank
SELF:FieldPut(#mPO, uValue)
RETURN uValue

ACCESS mTelebankng() CLASS EditBank
RETURN SELF:FieldGet(#mTelebankng)

ASSIGN mTelebankng(uValue) CLASS EditBank
SELF:FieldPut(#mTelebankng, uValue)
RETURN uValue

METHOD OKButton( ) CLASS EditBank
local cStatement as string
local oStmnt as SQLstatement
local nCurrec as int
// 	 	",OPENAC="+iif(self:mOPENAC,"1","0")+;
// 		",PO="+iif(self:mPO,"1","0")+;
// 		",COMALL="+iif(self:mCOMALL,"1","0")+;
// 	 	",COMFL="+iif(self:mCOMFL,"1","0")+;

	IF self:ValidateBank()
		cStatement:=iif(self:lNew,"insert into ","update ")+"bankaccount set "+;
		"accid="+self:mRek +;
		",telebankng="+iif(self:mTelebankng,"1","0")+;
		",usedforgifts="+iif(self:mGIFTENIND,"1","0")+;
		",banknumber='"+ZeroTrim(self:mBANKNUMMER)+"'"+;
		",openall="+iif(self:mOPENALL,"1","0")+;
		",giftsall ="+iif(self:mGIFTSALL,"1","0")+;
	 	",payahead='"+ self:mRekP +"'"+;
	 	iif(self:mGIFTENIND .and. self:oDCSingleDest:Checked,; 
		 	",singledst='"+mRekS +"'"+;
		 	",syscodover='"+iif(self:oDCOverride:Checked,"O","A")+"'"+;
 			",fgmlcodes ='"+ MakeCod({self:mFGCod1,self:mFGCod2,self:mFGCod3})+"'",;
		 	",singledst='',fgmlcodes='',syscodover=''")+;
		iif(self:lNew,""," where bankid="+self:mBankId)	
		oStmnt:=SQLStatement{cStatement,oConn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows>0 
			nCurrec:=self:oCaller:oBank:recno
			self:oCaller:oBank:Execute()
			if self:lNew
				self:oCaller:goTop()
			else
				self:oCaller:goto(nCurrec)
			endif
		endif
		InitGlobals()
		SELF:EndWindow()
		
	ELSE
		RETURN FALSE
	ENDIF
ACCESS Override() CLASS EditBank
RETURN SELF:FieldGet(#Override)

ASSIGN Override(uValue) CLASS EditBank
SELF:FieldPut(#Override, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditBank
	//Put your PostInit additions here
	self:SetTexts()

	IF lNew
		self:oDCmBANKNUMMER:SetFocus()
    ELSE
		self:mRek := Str(self:oBank:accid,-1)
		self:mAccount := AllTrim(self:oBank:Description)
		SELF:cAccountName := mAccount
		if !Empty(self:oBank:payahead)			
			self:mRekP:=Str(self:oBank:payahead,-1)
		 	self:mAccountPaymnt := self:oBank:AccountPaymnt
			self:cAccountNameP:= mAccountPaymnt
		endif
		if !Empty(self:oBank:SINGLEDST)
			self:mRekS:=Str(self:oBank:SINGLEDST,-1)
		 	self:mAccountSingle := self:oBank:accountsingle
			self:cAccountNameS:= mAccountSingle
		endif
		self:mBANKNUMMER:=AllTrim(self:oBank:banknumber)
		self:oDCmTelebankng:Checked:=iif(self:oBank:telebankng=0,FALSE,true)
		self:oDCmGIFTENIND:Checked:=iif(self:oBank:usedforgifts=0,false,true)
		self:mBANKNUMMER:=self:oBank:banknumber
		self:mOPENALL:=self:oBank:openall
// 	 	self:mOPENAC   :=self:oBank:OPENAC
		self:mGIFTSALL :=self:oBank:giftsall
// 		self:mPO       :=self:oBank:PO
// 		self:mCOMALL   :=self:oBank:COMALL
// 	 	self:mCOMFL    :=self:oBank:COMFL
	 	if !Empty(mAccountSingle) 
			self:oDCSingleDest:Checked:=true
			self:oDCOverride:Checked:=iif(self:oBank:SYSCODOVER=="O",true,false)
			IF!Empty(self:oBank:FGMLCODES)
				self:mFGCod1  := if(Empty(SubStr(self:oBank:FGMLCODES,1,2)),nil,SubStr(self:oBank:FGMLCODES,1,2))
				self:mFGCod2  := if(Empty(SubStr(self:oBank:FGMLCODES,4,2)),nil,SubStr(self:oBank:FGMLCODES,4,2))
				self:mFGCod3  := if(Empty(SubStr(self:oBank:FGMLCODES,7,2)),nil,SubStr(self:oBank:FGMLCODES,7,2))
			ENDIF
	 	else
	 		 self:oDCSingleDest:Checked:=false
	 	endif	
    ENDIF
	SELF:SetTele()
	RETURN NIL	

method PreInit(oWindow,iCtlID,oServer,uExtra) class EditBank
	//Put your PreInit additions here 
	IF !uExtra[1]
		self:lNew :=FALSE
		self:mBankId:=Str(oServer:BANKID,-1)
		self:oBank:=SQLSelect{"select b.*,a.description,a.accnumber,sd.description as accountsingle,pa.description as accountpaymnt from account a, bankaccount b"+;
		" left join account sd on (sd.accid=b.singledst) left join account pa on (pa.accid=b.payahead) where a.accid=b.accid and b.bankid='"+self:mBankId+"'",oConn} 
	ELSE
		self:lNew:=true
	ENDIF
	self:oCaller:=uExtra[2]

	return NIL

METHOD RegAccount(oAcc,ItemName) CLASS EditBank
IF Empty(oAcc) .or.oAcc:reccount=0
	IF ItemName="General Ledger Account of Bank Account"
		self:mRek :=  "0"
		SELF:oDCmAccount:TEXTValue := ""
		self:cAccountName := "0"
	ELSEIF ItemName="General Ledger Account of Interbank fit"
		SELF:oDCmAccountPaymnt:TextValue := ""
		self:mRekP:= "0"
		self:cAccountNameP:= ""
	ELSEIF ItemName="General Ledger Account of destination"
		self:oDCmAccountSingle:TEXTValue := ""
		self:mRekS:= "0"
		self:cAccountNameS:= ""
	ENDIF
ELSE
	IF ItemName="General Ledger Account of Bank Account"
		self:mRek :=  Str(oAcc:accid,-1)
		self:oDCmAccount:TEXTValue := AllTrim(oAcc:Description)
		self:cAccountName := AllTrim(oAcc:Description)
	ELSEIF ItemName="General Ledger Account of Interbank fit"
		SELF:oDCmAccountPaymnt:TextValue := AllTrim(oAcc:description)
		self:mRekP:= Str(oAcc:accid,-1)
		self:cAccountNameP:= AllTrim(oAcc:Description)
	ELSEIF ItemName="General Ledger Account of destination"
		self:oDCmAccountSingle:TEXTValue := AllTrim(oAcc:Description)
		self:mRekS:= Str(oAcc:accid,-1)
		self:cAccountNameS:= AllTrim(oAcc:Description)
	ENDIF
ENDIF

RETURN TRUE
METHOD SetTele() CLASS EditBank
	IF self:mTelebankng
	 	oDCmAccountPaymnt:Show()
	 	oCCAccButtonP:Show()
	 	oDCFixedText2:Show()
	else
	 	oDCmAccountPaymnt:Hide()
	 	oCCAccButtonP:Hide()
	 	oDCFixedText2:Hide()
	endif		
	IF self:mTelebankng.and.self:mGIFTENIND
// 	 	oDCmCOMFL:Show()
// 	 	oDCmCOMALL:Show()
// 		oDCmPO:Show()
	 	oDCmGIFTSALL:Show()
// 	 	oDCmOPENAC:Show()
		oDCmOPENALL:Show()
	 	oDCGroupBox:Show()
	ELSE
	 	oDCmGIFTSALL:Hide()
 		oDCmOPENALL:Hide()
	 	oDCGroupBox:Hide()
	ENDIF 
	if self:mGIFTENIND
		// show single destination checkbutton:
		self:oDCSingleDest:Show() 
	else
		self:oDCSingleDest:Hide()				
	endif
	if self:mGIFTENIND .and. self:oDCSingleDest:Checked
		self:oDCmAccountSingle:Show()
		self:oDCSingleText:Show()
		self:oDCmAccountSingle:Show()
		self:oDCGroupBox2:Show()
		self:oDCmFGCod1:Show()
		self:oDCmFGCod2:Show()
		self:oDCmFGCod3:Show() 
		self:oDCOverride:Show()
		self:oCCAccButtonSingle:Show()
	else
		self:oDCmAccountSingle:Hide()
		self:oDCSingleText:Hide()
		self:oDCmAccountSingle:Hide()
		self:oDCGroupBox2:Hide()
		self:oDCmFGCod1:Hide()
		self:oDCmFGCod2:Hide()
		self:oDCmFGCod3:Hide()
		self:oDCOverride:Hide() 
		self:oCCAccButtonSingle:Hide()
	endif
RETURN nil	
ACCESS SingleDest() CLASS EditBank
RETURN SELF:FieldGet(#SingleDest)

ASSIGN SingleDest(uValue) CLASS EditBank
SELF:FieldPut(#SingleDest, uValue)
RETURN uValue

METHOD ValidateBank() CLASS EditBank
	LOCAL lValid:= true as LOGIC
	local cError as string
	IF Empty(mRek)
		lValid := FALSE
		cError := "Account general ledger is mandatory!"
		self:oDCmAccount:SetFocus()
	ELSEIF Empty(mBANKNUMMER)
		lValid := FALSE
		cError := "Number bank account is mandatory!" 
		self:oDCmBANKNUMMER:SetFocus()
	ELSEif self:mGIFTENIND .and. self:oDCSingleDest:Checked .and.Empty(mRekS)
		lValid := FALSE
		cError := "Single desitination account is mandatory!" 
		self:oDCmAccountSingle:SetFocus()
	endif	
	IF lNew .or.!AllTrim(oBank:banknumber)==AllTrim(self:mBANKNUMMER)
		* Check if bank account allready exists: 
		if SQLSelect{"select banknumber from bankaccount where banknumber='"+AllTrim(self:mBANKNUMMER)+"'" +iif(self:lNew,""," and bankid<>"+self:mBankId),oConn}:Reccount>0 
			cError:="Bank Account number allready exits"
			lValid:=FALSE
		endif
	endif
	if lValid.and.(lNew .or.oBank:accid # Val(self:mRek))
		if SQLSelect{"select banknumber from bankaccount where accid='"+self:mRek+iif(self:lNew,""," and bankid<>"+self:mBankId),oConn}:Reccount>0 
			If TextBox{,"Edit Bank account", 'Account "'+AllTrim(cAccountName)+'" allready assigned to Bank Account '+oBank:banknumber,BUTTONOKAYCANCEL+BOXICONQUESTIONMARK}:Show()= BOXREPLYCANCEL
				return false
			ENDIF
		endif
	endif
	if lValid.and.!Empty(mRekS).and.(self:lNew.or.oBank:SINGLEDST # Val(mRekS))  // single destination account changed?
		if SQLSelect{"select banknumber from bankaccount where singledst='"+self:mRekS+iif(self:lNew,""," and bankid<>"+self:mBankId),oConn}:Reccount>0 
			If TextBox{,"Edit Bank account", 'Account "'+AllTrim(cAccountNameS)+'" allready assigned as destination to Bank Account '+oBank:banknumber,BUTTONOKAYCANCEL+BOXICONQUESTIONMARK}:Show()= BOXREPLYCANCEL
				return false
			ENDIF
		ENDIF
	ENDIF
	IF ! lValid
		(ErrorBox{SELF,cError}):Show()
	ENDIF

	RETURN lValid
STATIC DEFINE EDITBANK_ACCBUTTON := 110 
STATIC DEFINE EDITBANK_ACCBUTTONP := 112 
STATIC DEFINE EDITBANK_ACCBUTTONSINGLE := 120 
STATIC DEFINE EDITBANK_CANCELBUTTON := 109 
STATIC DEFINE EDITBANK_FIXEDTEXT2 := 114 
STATIC DEFINE EDITBANK_GROUPBOX := 105 
STATIC DEFINE EDITBANK_GROUPBOX2 := 118 
STATIC DEFINE EDITBANK_MACCOUNT := 101 
STATIC DEFINE EDITBANK_MACCOUNTPAYMNT := 107 
STATIC DEFINE EDITBANK_MACCOUNTSINGLE := 121 
STATIC DEFINE EDITBANK_MBANKNUMMER := 100 
STATIC DEFINE EDITBANK_MFGCOD1 := 117 
STATIC DEFINE EDITBANK_MFGCOD2 := 116 
STATIC DEFINE EDITBANK_MFGCOD3 := 119 
STATIC DEFINE EDITBANK_MGIFTENIND := 102 
STATIC DEFINE EDITBANK_MGIFTSALL := 104 
STATIC DEFINE EDITBANK_MOPENALL := 106 
STATIC DEFINE EDITBANK_MTELEBANKNG := 103 
STATIC DEFINE EDITBANK_OKBUTTON := 108 
STATIC DEFINE EDITBANK_OVERRIDE := 123 
STATIC DEFINE EDITBANK_SC_BANKNUMMER := 113 
STATIC DEFINE EDITBANK_SC_REK := 111 
STATIC DEFINE EDITBANK_SINGLEDEST := 115 
STATIC DEFINE EDITBANK_SINGLETEXT := 122 
CLASS Indicator INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Indicator
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Indicator, "", "", "" },  "C", 3, 0 )
    cPict       := "xxx"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF


RESOURCE SelBankOrder DIALOGEX  5, 18, 235, 137
STYLE	DS_3DLOOK|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Select bank orders to send to bank"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Bank data:", SELBANKORDER_KEUS21, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 55, 216, 41
	CONTROL	"zaterdag 20 november 2010", SELBANKORDER_BEGIN_VERV, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 84, 14, 118, 14
	CONTROL	"zaterdag 20 november 2010", SELBANKORDER_EIND_VERV, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 84, 30, 118, 14
	CONTROL	"zaterdag 20 november 2010", SELBANKORDER_DATEPAYMENT, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 96, 70, 119, 13
	CONTROL	"Up to and including:", SELBANKORDER_FIXEDTEXT2, "Static", WS_CHILD, 16, 34, 64, 12
	CONTROL	"From:", SELBANKORDER_FIXEDTEXT1, "Static", WS_CHILD, 16, 17, 50, 12
	CONTROL	"Date of payment of bank order is :", SELBANKORDER_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 6, 216, 46
	CONTROL	"OK", SELBANKORDER_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 168, 121, 53, 13
	CONTROL	"Cancel", SELBANKORDER_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 168, 103, 53, 12
	CONTROL	"Date bank processing:", SELBANKORDER_DATE_PAYMENTTEXT, "Static", WS_CHILD, 16, 72, 76, 12
END

CLASS SelBankOrder INHERIT DialogWinDowExtra 

	PROTECT oDCkeus21 AS RADIOBUTTONGROUP
	PROTECT oDCbegin_verv AS DATESTANDARD
	PROTECT oDCeind_verv AS DATESTANDARD
	PROTECT oDCDatePayment AS WORKDAYDATE
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCDate_PaymentText AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  declare method MakeCliop03File
METHOD CancelButton( ) CLASS SelBankOrder 
	self:EndDialog()
RETURN NIL
METHOD Init(oParent,uExtra) CLASS SelBankOrder 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"SelBankOrder",_GetInst()},FALSE)

oDCbegin_verv := DateStandard{SELF,ResourceID{SELBANKORDER_BEGIN_VERV,_GetInst()}}
oDCbegin_verv:FieldSpec := Transaction_DAT{}
oDCbegin_verv:HyperLabel := HyperLabel{#begin_verv,NULL_STRING,NULL_STRING,NULL_STRING}

oDCeind_verv := DateStandard{SELF,ResourceID{SELBANKORDER_EIND_VERV,_GetInst()}}
oDCeind_verv:FieldSpec := Transaction_DAT{}
oDCeind_verv:HyperLabel := HyperLabel{#eind_verv,NULL_STRING,NULL_STRING,NULL_STRING}

oDCDatePayment := WorkDayDate{SELF,ResourceID{SELBANKORDER_DATEPAYMENT,_GetInst()}}
oDCDatePayment:FieldSpec := Transaction_DAT{}
oDCDatePayment:HyperLabel := HyperLabel{#DatePayment,NULL_STRING,"Date for processing payment orders at the bank",NULL_STRING}
oDCDatePayment:UseHLforToolTip := True

oDCFixedText2 := FixedText{SELF,ResourceID{SELBANKORDER_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Up to and including:",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{SELBANKORDER_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"From:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{SELBANKORDER_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Date of payment of bank order is :",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{SELBANKORDER_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{SELBANKORDER_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCDate_PaymentText := FixedText{SELF,ResourceID{SELBANKORDER_DATE_PAYMENTTEXT,_GetInst()}}
oDCDate_PaymentText:HyperLabel := HyperLabel{#Date_PaymentText,"Date bank processing:",NULL_STRING,NULL_STRING}

oDCkeus21 := RadioButtonGroup{SELF,ResourceID{SELBANKORDER_KEUS21,_GetInst()}}
oDCkeus21:HyperLabel := HyperLabel{#keus21,"Bank data:",NULL_STRING,NULL_STRING}

SELF:Caption := "Select bank orders to send to bank"
SELF:HyperLabel := HyperLabel{#SelBankOrder,"Select bank orders to send to bank",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

ACCESS keus21() CLASS SelBankOrder
RETURN SELF:FieldGet(#keus21)

ASSIGN keus21(uValue) CLASS SelBankOrder
SELF:FieldPut(#keus21, uValue)
RETURN uValue

Method MakeCliop03File(begin_due as date,end_due as date, process_date as date) as logic CLASS SelBankOrder
	// make CLIEOP03 file for payment orders for Dutch Banks
	LOCAL cFilter as STRING
	LOCAL oBord as SQLSelect, oPers as SQLSelect, oPersBank as SQLSelect 
	LOCAL oAcc as SQLSelect, oBank as SQLSelect, oMBal as SQLSelect, oTrans as SQLSelect
	LOCAL ptrHandle
	LOCAL cFilename, cOrgName, cDescr,cTransnr,m56_Payahead, cErrMsg as STRING 
	local cAmnt as string
	LOCAL fSum:=0 as FLOAT, rekeningnrsTot:=0, fBANKNBRCRE,fAmnt as float
	LOCAL lError as LOGIC
	LOCAL oReport as PrintDialog, headinglines as ARRAY , nRow, nPage,i, nSeq as int
	LOCAL cBank, cAccFrom as STRING
	Local oWarn as TextBox
	Local aTrans:={} as array // persid,Dtos(invoicedate)+seqnr,accid,AmountInvoice, banknumber, Description 
	Local aDir as array
	local oPro as ProgressPer
	local oStmnt as SQLStatement

	if Empty(BANKNBRCRE)
		(ErrorBox{self,"Bank account for payments not specified in system data"}):Show()
		return FALSE
	endif
	oBank:=SQLSelect{"select payahead,accid from bankaccount where banknumber='"+BANKNBRCRE+"' and telebankng=1",oConn}
	if oBank:Reccount<1
		(ErrorBox{self,self:oLan:WGet("Bank account number")+Space(1)+BANKNBRCRE+Space(1)+;
			self:oLan:WGet("not specified as telebanking in system data")}):Show()
		RETURN FALSE
	else
		cAccFrom:=Str(oBank:accid,-1)
		m56_Payahead:=Str(oBank:payahead,-1) 
		if Empty(m56_Payahead)
			(ErrorBox{self,self:oLan:WGet("For bank account number")+space(1)+BANKNBRCRE+space(1)+;
				self:oLan:WGet("no account for Payments en route specified in system data")}):Show()
			RETURN FALSE
		endif
	endif

	if Len(BANKNBRCRE)>7 .and.!IsDutchBanknbr(BANKNBRCRE)
		(ErrorBox{self,self:oLan:WGet("Bank account number")+Space(1)+BANKNBRCRE+Space(1)+;
			self:oLan:WGet("for Payments is not correct")}):Show()
		RETURN FALSE
	ENDIF
	IF Empty(sIDORG)
		(ErrorBox{self,self:oLan:WGet("No own organisation specified in System Parameters")}):Show()
		RETURN FALSE
	ENDIF
	cOrgName:=GetFullName(sIDORG,2)
	if Empty(cOrgName)
		(ErrorBox{self,self:oLan:WGet("No own organisation specified in System Parameters")}):Show()
		RETURN FALSE
	ENDIF
	fBANKNBRCRE:=Val(BANKNBRCRE)
	// Check validity of recipient bankaccounts:
	oBord:=SQLSelect{"select distinct o.banknbrcre,o.stordrid, a.accnumber,a.description from bankorder o"+;
		" left join account a on (a.accid=o.idfrom) "+;
		" where datepayed='0000-00-00' and datedue between '"+SQLdate(begin_due)+"' and '"+SQLdate(end_due)+"'"+;
		" and banknbrcre not in (select b.banknumber from personbank b)",oConn}
	if oBord:Reccount>0
		cErrMsg:=self:oLan:WGet("The following bank accounts are not found in person data")+":"
		do while !oBord:EoF
			cErrMsg+=CRLF+PadR(oBord:BANKNBRCRE,20)+Space(1)+self:oLan:WGet("from")+Space(1)+;
				iif(Empty(oBord:stordrid),;
				iif(Empty(oBord:IDFrom),"unknown account",self:oLan:WGet("account")+" "+oBord:ACCNUMBER+"("+oBord:Description+")"),;
				self:oLan:WGet("standing order")+Space(1)+Str(oBord:stordrid,-1))
			oBord:skip()
		enddo
		ErrorBox{self,cErrMsg}:Show()
		return false
	endif	
	
	oBord:=SQLSelect{"select o.id,o.banknbrcre,o.amount,o.datedue,o.description,"+SQLFullName(0,"p")+"as fullname "+;
		"from bankorder o,personbank b,person p "+;
		" where o.banknbrcre=b.banknumber and b.persid=p.persid "+;
		"and datepayed='0000-00-00' and datedue between '"+SQLdate(begin_due)+"' and '"+SQLdate(end_due)+"' order by fullname",oConn}
	IF oBord:Reccount<1
		(WarningBox{self,"Producing CLIEOP03 file","No bank orders to be sent to the bank!"}):Show()
		RETURN FALSE
	ENDIF
	headinglines:={oLan:RGet("Overview of payment orders (CLIEOP03)"),oLan:RGet("bankaccount",11)+oLan:RGet("Amount",12,,"R")+" "+oLan:RGet("Destination",12)+oLan:RGet("Due Date",11)+" "+oLan:RGet("Name",25)+oLan:RGet("Description",20),Replicate('-',105)}
	// write Header
	oReport := PrintDialog{self,"Producing of CLIEOP03 file for payments",,105}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	// remove old clieop03-files:
	aDir := Directory(CurPath +"\CLIEOP03*.txt") 
	nSeq:=1
	FOR i := 1 upto ALen(ADir)
		if ADir[i][F_DATE] < (Today()-12) 	
			(FileSpec{ADir[i][F_NAME]}):DELETE()
		elseif ADir[i][F_DATE] == Today() 
			nSeq++
		endif
	NEXT 
	
	* Datafile aanmaken:
	cFilename := CurPath + "\CLIEOP03"+DToS(Today())+Str(nSeq,-1)+'.txt'
	ptrHandle := MakeFile(self,cFilename,"Creating CLIEOP03-file")
	IF ptrHandle = F_ERROR .or. ptrHandle==nil
		RETURN false
	ENDIF
	// determine sequencenumber per day:
	
	FWriteLine(ptrHandle,"0001A"+StrZero(Day(Today()),2)+StrZero(Month(Today()),2)+SubStr(StrZero(Year(Today()),4,0),3,2) +"CLIEOP03"+"WYCLF"+StrZero(Month(Today()),2)+StrZero(Day(Today()),2)+"1"+Space(21))
	FWriteLine(ptrHandle,"0010B00"+PadL(BANKNBRCRE,10,"0")+"0001"+"EUR"+Space(26) )
	FWriteLine(ptrHandle,"0030B1"+StrZero(Day(process_date),2)+StrZero(Month(process_date),2)+SubStr(StrZero(Year(process_date),4,0),3,2)+PadR(cOrgName,35)+"P"+Space(2))
	DO WHILE !oBord:EoF
		cBank:=oBord:BANKNBRCRE
		if Len(cBank)>7
			if !IsDutchBanknbr(cBank)
				(ErrorBox{self,"bankaccount "+cBank+" in bank order is not correct!"}):Show()
				FClose(ptrHandle) 
				(FileSpec{cFilename}):DELETE()
				FErase(cFilename)
				return false
			endif
		endif
		rekeningnrsTot:=Round(rekeningnrsTot+fBANKNBRCRE+Val(cBank),0)
// 		LogEvent(,CHR(9)+Str(fBANKNBRCRE,-1)+CHR(9)+cBank+CHR(9)+Str(rekeningnrsTot,-1),"logcalcNew")
		// Transactie record:
		FWriteLine(ptrHandle,"0100A0005"+StrZero(oBord:AMOUNT*100,12,0)+ PadL(BANKNBRCRE,10,"0")+PadL(cBank,10,"0") +Space(9))
		// Betalingsknemerk record:
		FWriteLine(ptrHandle,"0150A"+PadR(Mod11(StrZero(oBord:ID,6,0)+DToS(oBord:DATEDUE)+"1"),16)+Space(29))	              
		FWriteLine(ptrHandle,"0160A"+PadR(oBord:Description,32)+Space(13))
		if !Empty(oBord:FullName) 
			FWriteLine(ptrHandle,"0170B"+PadR(oBord:FullName,35)+Space(10))
		endif 
		
		fSum:=Round(fSum+oBord:AMOUNT,DecAantal) 
		oReport:PrintLine(@nRow,@nPage,;
			Pad(BANKNBRCRE,11)+Str(oBord:AMOUNT,12,2)+' '+Pad(cBank,12)+DToC(oBord:DATEDUE)+"  "+Pad(oBord:FullName,24)+" "+oBord:Description,headinglines)  
		// add to aTrans: 
		AAdd(aTrans,{oBord:AMOUNT,oBord:Description})
		oBord:skip()		
	ENDDO
	// Write closing lines:
	FWriteLine(ptrHandle,"9990A"+StrZero(fSum*100,18,0)+SubStr(Str(rekeningnrsTot,-1,0),-10)+StrZero(Len(aTrans),7,0)+Space(10))
	FWriteLine(ptrHandle,"9999A"+Space(45))
	
	FClose(ptrHandle)
	oReport:PrintLine(@nRow,@nPage,Replicate('-',105),headinglines,3)
	oReport:PrintLine(@nRow,@nPage,Space(11)+Str(Round(fSum,2),12,2),headinglines)
	oReport:prstart()
	oReport:prstop()
	oWarn:=TextBox{self,"Bank Orders",;
		"Printing O.K.? Can shown "+Str(Len(aTrans),-1)+" bankorders("+sCurrName+Str(fSum,-1)+") be imported into telebanking"+'?',BOXICONQUESTIONMARK + BUTTONYESNO}
	IF (oWarn:Show() = BOXREPLYNO)
		// remove file:
		(FileSpec{cFilename}):DELETE() 
		cFilename:=""
	else
		oPro:=ProgressPer{,self}
		oPro:Caption:="Recording bank order transactions"
		oPro:SetRange(1,Len(aTrans)+3)
		oPro:SetUnit(1)
		oPro:Show() 
		self:oCCCancelButton:Disable()
		self:oCCOKButton:Disable()

		self:Owner:STATUSMESSAGE("Producing cliop03 file, moment please")
		self:Pointer := Pointer{POINTERHOURGLASS}
		// add accounts for add to income
		
		SQLStatement{"start transaction",oConn}:execute()
		// lock mbalance record for update:
		oMBal:=SQLSelect{"select mbalid from mbalance where accid in ("+m56_Payahead+','+cAccFrom+")"+;
			" and	year="+Str(Year(process_date),-1)+;
			" and	month="+Str(Month(process_date),-1)+" order by mbalid for update",oConn}
		if	!Empty(oMBal:Status)
			ErrorBox{self,self:oLan:WGet("balance records locked by someone else, thus	skipped")}:Show()
			SQLStatement{"rollback",oConn}:execute()
			return true
		endif	  
		// Reconcile Bank Order:
		oStmnt:=SQLStatement{"update bankorder set datepayed='"+SQLdate(process_date)+"' "+;
			"where datepayed='0000-00-00' and datedue between '"+SQLdate(begin_due)+"' and '"+SQLdate(end_due)+"'",oConn}
		oStmnt:execute()
		oPro:AdvancePro()
		if !Empty(oStmnt:Status)
			lError:=true
			LogEvent(self,"error "+oStmnt:ErrInfo:errormessage+CRLF+"statement:"+oStmnt:SQLString,"LogErrors")
		else

			// make transactions: 
			for i:=1 to Len(aTrans) 
				oPro:AdvancePro()
				* add transaction:
				* book against account payable:
				fAmnt:=float(_cast,aTrans[i,1])
				cAmnt:=Str(fAmnt,-1)
				cDescr:=Transform(aTrans[i,2],"") 
 
				oStmnt:=SQLStatement{"insert into transaction set "+;
				"dat='"+SQLdate(process_date)+"'"+;
				",docid='BETOPD'"+;
				",description ='"+cDescr +"'"+;
				",accid ='"+m56_Payahead+"'"+;
				",cre ='"+cAmnt+"'"+;
				",creforgn ='"+cAmnt+"'"+;
				",seqnr=1,poststatus=2"+;
				",userid ='"+LOGON_EMP_ID+"',currency='"+sCurr+"'",oConn}
				oStmnt:execute()
				if oStmnt:NumSuccessfulRows<1
					LogEvent(,"error:"+oStmnt:Status:Description+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
					lError:=true
					exit
				endif
				cTransnr:=SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)
				// record debit on from account:
				oStmnt:=SQLStatement{"insert into transaction set "+;
				"transid='"+cTransnr+"'"+;
				",dat='"+SQLdate(process_date)+"'"+;
				",docid='BETOPD'"+;
				",description ='"+cDescr +"'"+;
				",accid ='"+cAccFrom+"'"+;
				",deb ='"+cAmnt+"'"+;
				",debforgn ='"+cAmnt+"'"+;
				",seqnr=2,poststatus=2"+;
				",userid ='"+LOGON_EMP_ID+"',currency='"+sCurr+"'",oConn}
				oStmnt:execute()
				if oStmnt:NumSuccessfulRows<1
					LogEvent(,"error:"+oStmnt:Status:Description+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
					lError:=true
					exit
				endif
				nSeq:=2
			next
			if !lError
				if !ChgBalance(m56_Payahead,process_date,0,fSum,0,fSum,sCURR) // payahead cre
					lError:=true
					exit
				endif
				oPro:AdvancePro()				
				if !ChgBalance(cAccFrom,process_date,fSum,0,fSum,0,sCURR)  //account payable deb
					lError:=true
					exit
				ENDIF
				oPro:AdvancePro()
			endif
		endif
		oPro:EndDialog()
		oPro:Close()
		if lError
			SQLStatement{"rollback",oConn}:execute()
			self:Pointer := Pointer{POINTERARROW}
			LogEvent(self,self:oLan:WGet("could not record bank order transaction"),"LogErrors")
			ErrorBox{self,self:oLan:WGet("could not record bank ordert transaction")}:Show()
			RETURN false
		else
			SQLStatement{"commit",oConn}:execute()
		endif
		self:oCCCancelButton:Enable()
		self:oCCOKButton:Enable()
		self:Pointer := Pointer{POINTERARROW}
		(InfoBox{self,"Producing CLIEOP03 file","File "+cFilename+" generated with "+Str(Len(aTrans),-1)+" bank orders"}):Show() 
		LogEvent(, "CLIEOP03 file "+cFilename+" generated with "+Str(Len(aTrans),-1)+" bank orders; total:"+Str(Round(fSum,2),12,2),"Log")
	endif
	RETURN true
METHOD OKButton( ) CLASS SelBankOrder 
	LOCAL begin_due:=oDCbegin_verv:SelectedDate, end_due:=oDCeind_verv:SelectedDate, process_date:=self:oDCDatePayment:SelectedDate as date

	IF CountryCode="31"
		if self:MakeCliop03File(begin_due,end_due,process_date)
			self:EndDialog()
		endif
	endif

RETURN NIL
method PostInit(oWindow,iCtlID,oServer,uExtra) class SelBankOrder
	//Put your PostInit additions here
	LOCAL rjaar := Year(Today()) as int
	LOCAL rmnd := Month(Today()) as int 
	self:SetTexts()
	oDCbegin_verv:SelectedDate := Today()-35
//	oDCeind_verv:SelectedDate := SToD(Str(rjaar,4)+StrZero(rmnd,2)+Str(MonthEnd(rmnd,rjaar),2))
	oDCeind_verv:SelectedDate := Today()+15
	self:oDCDatePayment:SelectedDate:=Today()+1
	if DoW(self:oDCDatePayment:SelectedDate)=1       // not on sunday
		self:oDCDatePayment:SelectedDate++
	elseif DoW(self:oDCDatePayment:SelectedDate)=7   // not on saturday
		self:oDCDatePayment:SelectedDate+=2
	endif
	return nil
ACCESS Selx_rek() CLASS SelBankOrder
RETURN SELF:FieldGet(#Selx_rek)

ASSIGN Selx_rek(uValue) CLASS SelBankOrder
SELF:FieldPut(#Selx_rek, uValue)
RETURN uValue

STATIC DEFINE SELBANKORDER_BEGIN_VERV := 101 
STATIC DEFINE SELBANKORDER_CANCELBUTTON := 108 
STATIC DEFINE SELBANKORDER_DATE_PAYMENTTEXT := 109 
STATIC DEFINE SELBANKORDER_DATEPAYMENT := 103 
STATIC DEFINE SELBANKORDER_EIND_VERV := 102 
STATIC DEFINE SELBANKORDER_FIXEDTEXT1 := 105 
STATIC DEFINE SELBANKORDER_FIXEDTEXT2 := 104 
STATIC DEFINE SELBANKORDER_GROUPBOX1 := 106 
STATIC DEFINE SELBANKORDER_KEUS21 := 100 
STATIC DEFINE SELBANKORDER_OKBUTTON := 107 
STATIC DEFINE SELBANKORDEROLD_BEGIN_VERV := 101 
STATIC DEFINE SELBANKORDEROLD_CANCELBUTTON := 108 
STATIC DEFINE SELBANKORDEROLD_DATE_PAYMENTTEXT := 109 
STATIC DEFINE SELBANKORDEROLD_DATEPAYMENT := 103 
STATIC DEFINE SELBANKORDEROLD_EIND_VERV := 102 
STATIC DEFINE SELBANKORDEROLD_FIXEDTEXT1 := 105 
STATIC DEFINE SELBANKORDEROLD_FIXEDTEXT2 := 104 
STATIC DEFINE SELBANKORDEROLD_GROUPBOX1 := 106 
STATIC DEFINE SELBANKORDEROLD_KEUS21 := 100 
STATIC DEFINE SELBANKORDEROLD_OKBUTTON := 107 
