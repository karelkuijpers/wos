CLASS DueAmountBrowser INHERIT DataWindowExtra 

	PROTECT oDCmPerson AS SINGLELINEEDIT
	PROTECT oDCmAccount AS SINGLELINEEDIT
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oDCSC_AR1 AS FIXEDTEXT
	PROTECT oDCSC_OMS AS FIXEDTEXT
	PROTECT oCCPersonButton AS PUSHBUTTON
	PROTECT oCCAccButton AS PUSHBUTTON
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oSFDueAmountBrowser_DETAIL AS DueAmountBrowser_DETAIL

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
    PROTECT cPersonName,cAccountName AS STRING
	PROTECT mCLN AS STRING
	PROTECT mREK AS STRING
	PROTECT lReconc:=true
	export oDue as SQLSelect
	export cWhere,cFields,cFrom,cOrder as string
RESOURCE DueAmountBrowser DIALOGEX  12, 11, 479, 258
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", DUEAMOUNTBROWSER_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 56, 16, 73, 12, WS_EX_CLIENTEDGE
	CONTROL	"", DUEAMOUNTBROWSER_MACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 56, 31, 73, 12, WS_EX_CLIENTEDGE
	CONTROL	"", DUEAMOUNTBROWSER_DUEAMOUNTBROWSER_DETAIL, "static", WS_CHILD|WS_BORDER, 18, 68, 380, 176
	CONTROL	"Delete", DUEAMOUNTBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 406, 145, 54, 13
	CONTROL	"&Account:", DUEAMOUNTBROWSER_SC_AR1, "Static", WS_CHILD, 24, 32, 30, 12
	CONTROL	"&Person:", DUEAMOUNTBROWSER_SC_OMS, "Static", WS_CHILD, 24, 15, 26, 12
	CONTROL	"v", DUEAMOUNTBROWSER_PERSONBUTTON, "Button", WS_CHILD, 127, 16, 15, 12
	CONTROL	"v", DUEAMOUNTBROWSER_ACCBUTTON, "Button", WS_CHILD, 127, 31, 15, 12
	CONTROL	"Due Amounts", DUEAMOUNTBROWSER_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 56, 462, 195
	CONTROL	"Select due amounts of:", DUEAMOUNTBROWSER_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 3, 150, 50
	CONTROL	"", DUEAMOUNTBROWSER_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 220, 7, 47, 12
	CONTROL	"Found:", DUEAMOUNTBROWSER_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 184, 8, 27, 12
END

METHOD AccButton(lUnique ) CLASS DueAmountBrowser
	LOCAL cFilter:="" as STRING
	local aIncl:={} as array
	Default(@lUnique,FALSE)
// 	AccountSelect(self,AllTrim(oDCmAccount:TEXTValue ),"General Ledger Account of Bank Account",lUnique,afilter[2],afilter[1],oAccount,,false)
	cFilter:='!Empty(subscriptionprice).or.giftalwd'

	IF !Empty(sdon)
		AAdd(aIncl,SDON)
	ENDIF
	IF !Empty(sdeb)
		AAdd(aIncl,SDEB)
	ENDIF
	cFilter:=MakeFilter(aIncl,{"AK","PA","BA","KO"},"B",1,true)

// 	AccountSelect(self,AllTrim(oDCmAccount:TEXTValue ),"Account",lUnique,cFilter,pFilter,oAcc)
	AccountSelect(self,AllTrim(oDCmAccount:TEXTValue ),"Account",lUnique,cFilter)
	RETURN nil

METHOD CancelButton( ) CLASS DueAmountBrowser
	SELF:EndWindow()
	RETURN
METHOD Close(oEvent) CLASS DueAmountBrowser
*SUPER:Close(oEvent)
	//Put your changes here

SELF:oSFDueAmountBrowser_DETAIL:Close()
SELF:oSFDueAmountBrowser_DETAIL:Destroy()
SELF:Destroy()

	RETURN NIL
METHOD DeleteButton( ) CLASS DueAmountBrowser
	LOCAL oTextBox AS TextBox
	
	IF SELF:Server:EOF.or.SELF:Server:BOF
		(ErrorBox{,self:oLan:WGet("Select a due amount first")}):Show()
		RETURN
	ENDIF
	oTextBox := TextBox{ self, self:oLan:WGet("Delete Due Amount"),;
	self:oLan:WGet("Delete due amount for account")+": "+AllTrim(self:oSFDueAmountBrowser_DETAIL:accountname)+Space(1)+self:oLan:WGet("of person")+": "+;
	AllTrim(self:oSFDueAmountBrowser_DETAIL:PERSONName)+"?"}	
	oTextBox:Type := BUTTONYESNO + BOXICONQUESTIONMARK
	
	IF ( oTextBox:Show() == BOXREPLYYES )
		* Check toegestaan: 
		SQLStatement{"delete from dueamount where dueid="+Str(oDue:dueid,-1),oConn}:execute() 
		self:oDue:execute()
		
		self:Server:Gotop()
		oSFDueAmountBrowser_DETAIL:Browser:REFresh()
			
	ENDIF

	RETURN NIL
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS DueAmountBrowser
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus 
		IF oControl:Name == "MPERSON".and.!AllTrim(oControl:textVALUE)==AllTrim(self:cPersonName)
			self:cPersonName:=AllTrim(oControl:textVALUE)
			IF Empty(oControl:textVALUE) && leeg gemaakt?
				SELF:RegPerson()
			ELSE
				SELF:PersonButton(TRUE)
			ENDIF
		ELSEIF oControl:Name == "MACCOUNT".and.!AllTrim(oControl:textVALUE)==AllTrim(self:cAccountName)
			self:cAccountName:=AllTrim(oControl:textVALUE)
			IF Empty(oControl:textVALUE) && leeg gemaakt?
				self:RegAccount()
			ELSE
				self:AccButton(true)
			endif
		ENDIF
	ENDIF

	RETURN NIL
METHOD FilePrint() CLASS  DueAmountBrowser
LOCAL kopregels as ARRAY
LOCAL nRow as int
LOCAL nPage as int
LOCAL oReport AS PrintDialog
*LOCAL oPers AS Person
*LOCAL oAcc AS Account
LOCAL oDue:=self:Server as SQLSelect
LOCAL oms1,oms2 AS STRING
LOCAL cTab:=CHR(9) as STRING

oReport := PrintDialog{self,"Due Amounts",,75,,"xls"}
oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
SELF:Pointer := Pointer{POINTERHOURGLASS}
oDue:SuspendNotification()

IF oReport:Extension#"xls"
	cTab:=Space(1)
	kopregels :={oLan:Get('Due Amounts',,"@!"),' '}
ELSE
	kopregels :={}
ENDIF

AAdd(kopregels, ;
oLan:Get("Account",20,"@!")+cTab+oLan:Get("person",30,"@!")+cTab+oLan:Get("amount",10,"@!","R")+;
cTab+oLan:Get("due date",12,"@!"))
IF oReport:Extension#"xls"
	AAdd(kopregels,' ')
ENDIF
oDue:GoTop()
DO WHILE !oDue:EOF
	oReport:PrintLine(@nRow,@nPage,Pad(oDue:accountname,20)+cTab+Pad(oDue:personname,30)+;
	cTab+Str(oDue:amountinvoice-oDue:AmountRecvd,10,DecAantal)+cTab+;
	DToC(oDue:invoicedate),kopregels)
	oDue:skip()
ENDDO

*oPers:Close()
*oAcc:Close()
oDue:ResetNotification()
SELF:Pointer := Pointer{POINTERARROW}
oReport:prstart()
oReport:prstop()
RETURN
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS DueAmountBrowser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"DueAmountBrowser",_GetInst()},iCtlID)

oDCmPerson := SingleLineEdit{SELF,ResourceID{DUEAMOUNTBROWSER_MPERSON,_GetInst()}}
oDCmPerson:HyperLabel := HyperLabel{#mPerson,NULL_STRING,NULL_STRING,"HELP_CLN"}
oDCmPerson:FieldSpec := Person_NA1{}
oDCmPerson:FocusSelect := FSEL_HOME
oDCmPerson:TooltipText := "The person, who has a due amount"

oDCmAccount := SingleLineEdit{SELF,ResourceID{DUEAMOUNTBROWSER_MACCOUNT,_GetInst()}}
oDCmAccount:HyperLabel := HyperLabel{#mAccount,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmAccount:FocusSelect := FSEL_HOME
oDCmAccount:TooltipText := "Number of account due"

oCCDeleteButton := PushButton{SELF,ResourceID{DUEAMOUNTBROWSER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PY

oDCSC_AR1 := FixedText{SELF,ResourceID{DUEAMOUNTBROWSER_SC_AR1,_GetInst()}}
oDCSC_AR1:HyperLabel := HyperLabel{#SC_AR1,_chr(38)+"Account:",NULL_STRING,NULL_STRING}

oDCSC_OMS := FixedText{SELF,ResourceID{DUEAMOUNTBROWSER_SC_OMS,_GetInst()}}
oDCSC_OMS:HyperLabel := HyperLabel{#SC_OMS,_chr(38)+"Person:",NULL_STRING,NULL_STRING}

oCCPersonButton := PushButton{SELF,ResourceID{DUEAMOUNTBROWSER_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v","Browse in persons",NULL_STRING}
oCCPersonButton:TooltipText := "Browse in Persons"

oCCAccButton := PushButton{SELF,ResourceID{DUEAMOUNTBROWSER_ACCBUTTON,_GetInst()}}
oCCAccButton:HyperLabel := HyperLabel{#AccButton,"v","Browse in accounts",NULL_STRING}
oCCAccButton:TooltipText := "Browse in accounts"

oDCGroupBox1 := GroupBox{SELF,ResourceID{DUEAMOUNTBROWSER_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Due Amounts",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{DUEAMOUNTBROWSER_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Select due amounts of:",NULL_STRING,NULL_STRING}

oDCFound := FixedText{SELF,ResourceID{DUEAMOUNTBROWSER_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{DUEAMOUNTBROWSER_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

SELF:Caption := "Browse in Due Amounts"
SELF:HyperLabel := HyperLabel{#DueAmountBrowser,"Browse in Due Amounts",NULL_STRING,NULL_STRING}
SELF:Menu := WOMenu{}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFDueAmountBrowser_DETAIL := DueAmountBrowser_DETAIL{SELF,DUEAMOUNTBROWSER_DUEAMOUNTBROWSER_DETAIL}
oSFDueAmountBrowser_DETAIL:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD PersonButton(lUnique ) CLASS  DueAmountBrowser
LOCAL cValue := AllTrim(oDCmPerson:TEXTValue ) AS STRING
Default(@lUnique,FALSE)
PersonSelect(self,cValue,lUnique,,"debtor")
	RETURN NIL
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS DueAmountBrowser
	//Put your PostInit additions here
	self:SetTexts()
	self:oDCFound:TextValue:=Str(self:oDue:RecCount,-1)
	RETURN NIL
method PreInit(oWindow,iCtlID,oServer,uExtra) class DueAmountBrowser
	//Put your PreInit additions here
	self:cWhere:="p.persid=s.personid and a.accid=s.accid and amountinvoice >amountrecvd and d.subscribid=s.subscribid"
	self:cFields:= "a.description as accountname,"+SQLFullName(0,"p")+" as personname,d.invoicedate,d.amountinvoice,d.amountrecvd,d.dueid,s.personid,s.accid,d.seqnr"
	self:cFrom:="person p,account a, dueamount d,subscription s" 
	self:cOrder:="personname"
	oDue:=SQLSelect{"select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+" order by "+self:cOrder ,oConn}
	return NIL

STATIC DEFINE DUEAMOUNTBROWSER_ACCBUTTON := 107 
STATIC DEFINE DUEAMOUNTBROWSER_DELETEBUTTON := 103 
RESOURCE DueAmountBrowser_DETAIL DIALOGEX  32, 29, 362, 196
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

CLASS DueAmountBrowser_DETAIL INHERIT DataWindowMine 

	PROTECT oDBACCOUNTNAME as DataColumn
	PROTECT oDBPERSONNAME as DataColumn
	PROTECT oDBINVOICEDATE as DataColumn
	PROTECT oDBAMOUNTINVOICE as DataColumn
	PROTECT oDBAMOUNTRECVD as DataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT oPers AS Person
ACCESS Accntnumber() CLASS DueAmountBrowser_DETAIL
RETURN SELF:FieldGet(#Accntnumber)

ASSIGN Accntnumber(uValue) CLASS DueAmountBrowser_DETAIL
SELF:FieldPut(#Accntnumber, uValue)
RETURN uValue

ACCESS AccountName() CLASS DueAmountBrowser_DETAIL
RETURN SELF:FieldGet(#AccountName)

ASSIGN AccountName(uValue) CLASS DueAmountBrowser_DETAIL
SELF:FieldPut(#AccountName, uValue)
RETURN uValue

ACCESS amountinvoice() CLASS DueAmountBrowser_DETAIL
RETURN SELF:FieldGet(#AmountInvoice)

ASSIGN amountinvoice(uValue) CLASS DueAmountBrowser_DETAIL
SELF:FieldPut(#AmountInvoice, uValue)
RETURN uValue

ACCESS AmountRecvd() CLASS DueAmountBrowser_DETAIL
RETURN SELF:FieldGet(#AmountRecvd)

ASSIGN AmountRecvd(uValue) CLASS DueAmountBrowser_DETAIL
SELF:FieldPut(#AmountRecvd, uValue)
RETURN uValue

METHOD Close(oEvent) CLASS DueAmountBrowser_DETAIL
*	SUPER:Close(oEvent)
	//Put your changes here
IF !oPers==NULL_OBJECT
	IF oPers:Used
		oPers:Close()
	ENDIF
	oPers:=NULL_OBJECT
ENDIF
RETURN NIL

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS DueAmountBrowser_DETAIL 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"DueAmountBrowser_DETAIL",_GetInst()},iCtlID)

SELF:Caption := ""
SELF:HyperLabel := HyperLabel{#DueAmountBrowser_DETAIL,NULL_STRING,NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:OwnerAlignment := OA_HEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := DataBrowser{self}

oDBACCOUNTNAME := DataColumn{account_OMS{}}
oDBACCOUNTNAME:Width := 16
oDBACCOUNTNAME:HyperLabel := HyperLabel{#AccountName,"Account","Number of an Account",NULL_STRING} 
oDBACCOUNTNAME:Caption := "Account"
self:Browser:AddColumn(oDBACCOUNTNAME)

oDBPERSONNAME := DataColumn{28}
oDBPERSONNAME:Width := 28
oDBPERSONNAME:HyperLabel := HyperLabel{#PersonName,"Person",NULL_STRING,NULL_STRING} 
oDBPERSONNAME:Caption := "Person"
self:Browser:AddColumn(oDBPERSONNAME)

oDBINVOICEDATE := DataColumn{DueAmount_FAKTDAT{}}
oDBINVOICEDATE:Width := 14
oDBINVOICEDATE:HyperLabel := HyperLabel{#InvoiceDate,"Invoice date",NULL_STRING,NULL_STRING} 
oDBINVOICEDATE:Caption := "Invoice date"
self:Browser:AddColumn(oDBINVOICEDATE)

oDBAMOUNTINVOICE := DataColumn{DueAmount_BEDRAGFAKT{}}
oDBAMOUNTINVOICE:Width := 16
oDBAMOUNTINVOICE:HyperLabel := HyperLabel{#AmountInvoice,"Amount invoiced",NULL_STRING,NULL_STRING} 
oDBAMOUNTINVOICE:Caption := "Amount invoiced"
self:Browser:AddColumn(oDBAMOUNTINVOICE)

oDBAMOUNTRECVD := DataColumn{DueAmount_BEDRAGONTV{}}
oDBAMOUNTRECVD:Width := 16
oDBAMOUNTRECVD:HyperLabel := HyperLabel{#AmountRecvd,"Amount received",NULL_STRING,NULL_STRING} 
oDBAMOUNTRECVD:Caption := "Amount received"
self:Browser:AddColumn(oDBAMOUNTRECVD)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS InvoiceDate() CLASS DueAmountBrowser_DETAIL
RETURN SELF:FieldGet(#InvoiceDate)

ASSIGN InvoiceDate(uValue) CLASS DueAmountBrowser_DETAIL
SELF:FieldPut(#InvoiceDate, uValue)
RETURN uValue

ACCESS personname() CLASS DueAmountBrowser_DETAIL
RETURN SELF:FieldGet(#PersonName)

ASSIGN personname(uValue) CLASS DueAmountBrowser_DETAIL
SELF:FieldPut(#PersonName, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class DueAmountBrowser_DETAIL
	//Put your PostInit additions here 
	self:Browser:SetStandardStyle( gbsReadOnly )
	return NIL

METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS DueAmountBrowser_DETAIL
	//Put your PreInit additions here
	oWindow:use(oWindow:oDue)
	oWindow:Server:GoTop()
	RETURN NIL

STATIC DEFINE DUEAMOUNTBROWSER_DETAIL_ACCNTNUMBER := 113 
STATIC DEFINE DUEAMOUNTBROWSER_DETAIL_ACCOUNTNAME := 103 
STATIC DEFINE DUEAMOUNTBROWSER_DETAIL_AMOUNTINVOICE := 101 
STATIC DEFINE DUEAMOUNTBROWSER_DETAIL_AMOUNTRECVD := 102 
STATIC DEFINE DUEAMOUNTBROWSER_DETAIL_INVOICEDATE := 100 
STATIC DEFINE DUEAMOUNTBROWSER_DETAIL_PERSONNAME := 104 
STATIC DEFINE DUEAMOUNTBROWSER_DUEAMOUNTBROWSER_DETAIL := 102 
STATIC DEFINE DUEAMOUNTBROWSER_FOUND := 110 
STATIC DEFINE DUEAMOUNTBROWSER_FOUNDTEXT := 111 
STATIC DEFINE DUEAMOUNTBROWSER_GROUPBOX1 := 108 
STATIC DEFINE DUEAMOUNTBROWSER_GROUPBOX2 := 109 
STATIC DEFINE DUEAMOUNTBROWSER_MACCOUNT := 101 
STATIC DEFINE DUEAMOUNTBROWSER_MPERSON := 100 
STATIC DEFINE DUEAMOUNTBROWSER_PERSONBUTTON := 106 
STATIC DEFINE DUEAMOUNTBROWSER_SC_AR1 := 104 
STATIC DEFINE DUEAMOUNTBROWSER_SC_OMS := 105 
STATIC DEFINE INVOICE_BRFCOL := 121 
STATIC DEFINE INVOICE_BRFREGN := 119 
STATIC DEFINE INVOICE_CANCELBUTTON := 114 
STATIC DEFINE INVOICE_CFOOTING := 110 
STATIC DEFINE INVOICE_DETAIL_AMOUNT := 113 
STATIC DEFINE INVOICE_DETAIL_ARTNBR := 107 
STATIC DEFINE INVOICE_DETAIL_DESC := 110 
STATIC DEFINE INVOICE_DETAIL_DISCOUNT := 108 
STATIC DEFINE INVOICE_DETAIL_PURCHPR := 111 
STATIC DEFINE INVOICE_DETAIL_QTY := 109 
STATIC DEFINE INVOICE_DETAIL_SC_AMOUNT := 106 
STATIC DEFINE INVOICE_DETAIL_SC_ARTNBR := 100 
STATIC DEFINE INVOICE_DETAIL_SC_DESC := 103 
STATIC DEFINE INVOICE_DETAIL_SC_PURCHPR := 104 
STATIC DEFINE INVOICE_DETAIL_SC_QTY := 102 
STATIC DEFINE INVOICE_DETAIL_SC_RABAT := 101 
STATIC DEFINE INVOICE_DETAIL_SC_SELLPR := 105 
STATIC DEFINE INVOICE_DETAIL_SELLPR := 112 
STATIC DEFINE INVOICE_FIXEDTEXT10 := 123 
STATIC DEFINE INVOICE_FIXEDTEXT6 := 115 
STATIC DEFINE INVOICE_FIXEDTEXT7 := 116 
STATIC DEFINE INVOICE_FIXEDTEXT8 := 118 
STATIC DEFINE INVOICE_FIXEDTEXT9 := 120 
STATIC DEFINE INVOICE_GROUPBOX1 := 122 
STATIC DEFINE INVOICE_INVOICE_DETAIL := 109 
STATIC DEFINE INVOICE_INVOICENBR := 117 
STATIC DEFINE INVOICE_MDAT := 101 
STATIC DEFINE INVOICE_MPERSON := 106 
STATIC DEFINE INVOICE_MTRANSAKTNR := 102 
STATIC DEFINE INVOICE_OKBUTTON := 113 
STATIC DEFINE INVOICE_PERSONBUTTON := 108 
STATIC DEFINE INVOICE_POSTAGE := 105 
STATIC DEFINE INVOICE_SC_CLN := 107 
STATIC DEFINE INVOICE_SC_DAT := 100 
STATIC DEFINE INVOICE_SC_TOTAL := 112 
STATIC DEFINE INVOICE_SC_TRANSAKTNR1 := 104 
STATIC DEFINE INVOICE_SC_TRANSAKTNR2 := 103 
STATIC DEFINE INVOICE_TOTALTEXT := 111 
