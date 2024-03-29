CLASS EditSubscription INHERIT DataWindowExtra 

	PROTECT oDCSC_RLN AS FIXEDTEXT
	PROTECT oDCSC_P01N AS FIXEDTEXT
	PROTECT oDCSC_P04 AS FIXEDTEXT
	PROTECT oDCSC_P06 AS FIXEDTEXT
	PROTECT oDCSC_P07 AS FIXEDTEXT
	PROTECT oDCSC_P08 AS FIXEDTEXT
	PROTECT oDCSC_P13 AS FIXEDTEXT
	PROTECT oDCmPerson AS SINGLELINEEDIT
	PROTECT oCCPersonButton AS PUSHBUTTON
	PROTECT oDCmAccount AS SINGLELINEEDIT
	PROTECT oCCAccButton AS PUSHBUTTON
	PROTECT oDCmbegindate AS DATETIMEPICKER
	PROTECT oDCmDueDate AS DATETIMEPICKER
	PROTECT oDCmamount AS MYSINGLEEDIT
	PROTECT oDCInvoiceText AS FIXEDTEXT
	PROTECT oCCRadioButtonGiro AS RADIOBUTTON
	PROTECT oCCRadioButtonCollection AS RADIOBUTTON
	PROTECT oDCmType AS RADIOBUTTONGROUP
	PROTECT oDCmInvoiceID AS SINGLELINEEDIT
	PROTECT oDCmBankAccnt AS COMBOBOX
	PROTECT oDCmReference AS SINGLELINEEDIT
	PROTECT oDCmLstchange AS SINGLELINEEDIT
	PROTECT oDCTypeText AS FIXEDTEXT
	PROTECT oDCmPayMethod AS RADIOBUTTONGROUP
	PROTECT oDCBankText AS FIXEDTEXT
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCSC_REF AS FIXEDTEXT
	PROTECT oDCmEndDate AS DATETIMEPICKER
	PROTECT oDCFixedText11 AS FIXEDTEXT
	PROTECT oDCmBlocked AS CHECKBOX
	PROTECT oDCmterm AS COMBOBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)

    PROTECT cPersonName,cAccountName as STRING
	PROTECT mCLN,msubid as STRING
	PROTECT mRek,mAccNumber as STRING 
	protect mCurRek,mCurCLN as string
	protect mBic,mCurBic as string 
	protect mTermOrig as int
	protect aBankaccs:={} as array 
	protect oCaller as SubScriptionBrowser
*  	PROTECT lNew AS LOGIC
	PROTECT mCod as STRING
	PROTECT nCurRec as int
	PROTECT cType, cHeading as STRING 
	protect dLastDDdate as date
	protect oSub as SQLSelect 
	// oSub: accid,personid,begindate,duedate,enddate,paymethod,bankaccnt,term,amount,lstchange,category,invoiceid,reference,personname,accountname,accnumber,bankaccs

RESOURCE EditSubscription DIALOGEX  37, 30, 423, 195
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Person:", EDITSUBSCRIPTION_SC_RLN, "Static", WS_CHILD, 6, 0, 30, 12
	CONTROL	"Account:", EDITSUBSCRIPTION_SC_P01N, "Static", WS_CHILD, 129, 0, 41, 12
	CONTROL	"Begin date:", EDITSUBSCRIPTION_SC_P04, "Static", WS_CHILD, 8, 51, 38, 13
	CONTROL	"Next due date:", EDITSUBSCRIPTION_SC_P06, "Static", WS_CHILD, 8, 66, 48, 12
	CONTROL	"Frequency:", EDITSUBSCRIPTION_SC_P07, "Static", WS_CHILD, 8, 81, 52, 12
	CONTROL	"Periodic amount:", EDITSUBSCRIPTION_SC_P08, "Static", WS_CHILD, 8, 96, 54, 12
	CONTROL	"Alter date:", EDITSUBSCRIPTION_SC_P13, "Static", WS_CHILD, 8, 147, 34, 14
	CONTROL	"", EDITSUBSCRIPTION_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 4, 11, 92, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITSUBSCRIPTION_PERSONBUTTON, "Button", WS_CHILD, 96, 11, 13, 12
	CONTROL	"", EDITSUBSCRIPTION_MACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 128, 11, 92, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITSUBSCRIPTION_ACCBUTTON, "Button", WS_CHILD, 218, 11, 15, 13
	CONTROL	"21-11-2014", EDITSUBSCRIPTION_MBEGINDATE, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 68, 48, 83, 13
	CONTROL	"21-11-2014", EDITSUBSCRIPTION_MDUEDATE, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 68, 62, 83, 14
	CONTROL	"", EDITSUBSCRIPTION_MAMOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 68, 96, 83, 12, WS_EX_CLIENTEDGE
	CONTROL	"Invoice ID (KID):", EDITSUBSCRIPTION_INVOICETEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 204, 125, 53, 12
	CONTROL	"Giro Accept", EDITSUBSCRIPTION_RADIOBUTTONGIRO, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 268, 92, 53, 11
	CONTROL	"Direct Debit", EDITSUBSCRIPTION_RADIOBUTTONCOLLECTION, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 268, 103, 56, 11
	CONTROL	"Type:", EDITSUBSCRIPTION_MTYPE, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 344, 7, 66, 25
	CONTROL	"", EDITSUBSCRIPTION_MINVOICEID, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 260, 125, 152, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITSUBSCRIPTION_MBANKACCNT, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_VSCROLL, 68, 110, 126, 72
	CONTROL	"", EDITSUBSCRIPTION_MREFERENCE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 68, 126, 126, 13, WS_EX_CLIENTEDGE
	CONTROL	"", EDITSUBSCRIPTION_MLSTCHANGE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 68, 147, 83, 13, WS_EX_CLIENTEDGE
	CONTROL	"", EDITSUBSCRIPTION_TYPETEXT, "Static", WS_CHILD, 348, 14, 53, 13
	CONTROL	"Payment Method", EDITSUBSCRIPTION_MPAYMETHOD, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 260, 81, 66, 38
	CONTROL	"Bank account:", EDITSUBSCRIPTION_BANKTEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 8, 112, 53, 12
	CONTROL	"Cancel", EDITSUBSCRIPTION_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 304, 155, 53, 12
	CONTROL	"OK", EDITSUBSCRIPTION_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 360, 155, 53, 12
	CONTROL	"Reference:", EDITSUBSCRIPTION_SC_REF, "Static", WS_CHILD|NOT WS_VISIBLE, 8, 126, 53, 13
	CONTROL	"21-11-2014", EDITSUBSCRIPTION_MENDDATE, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 260, 48, 83, 13
	CONTROL	"End date:", EDITSUBSCRIPTION_FIXEDTEXT11, "Static", WS_CHILD, 204, 51, 44, 13
	CONTROL	"Blocked temporary for debiting", EDITSUBSCRIPTION_MBLOCKED, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 204, 66, 140, 11
	CONTROL	"", EDITSUBSCRIPTION_MTERM, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD, 68, 81, 84, 71
END

METHOD AccButton(lUnique ) CLASS EditSubscription
	local cFilter as string
	Default(@lUnique,FALSE)
	IF cType=="STANDARD GIFTS" 
		cFilter:=MakeFilter(,,,1,false,{SDON})
	ELSEIF cType=="SUBSCRIPTIONS"
		cFilter:=MakeFilter(,,,0,false,{SDON})
	ELSEIF cType=="DONATIONS"
		cFilter:=MakeFilter({SDON},,,,false,)
	ELSE
		cFilter:=MakeFilter({SDON},,,1,true,)
	ENDIF	
	AccountSelect(self,AllTrim(oDCmAccount:TEXTValue ),cHeading,lUnique,cFilter)
	RETURN NIL
METHOD ButtonClick(oControlEvent) CLASS EditSubscription
	LOCAL oControl AS Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:Name=="RADIOBUTTONCOLLECTION" 
		self:oDCmInvoiceID:Show() 
		self:oDCInvoiceText:Show()	
		IF Empty(self:oDCmInvoiceID:TextValue) .or.sepaenabled
			self:GenerateInvoiceID()
		ENDIF
	elseif oControl:Name=="RadioButtonGiro"
		self:oDCmInvoiceID:hide() 
		self:oDCInvoiceText:hide()
	elseif oControl:Name=="SINGLEUSE"
		if self:oDCSingleUse:checked
			self:mterm:=999
			self:oDCmterm:hide()
			self:oDCmEndDate:hide()
			self:oDCFixedText11:hide()
			self:oDCSC_P07:hide()
		else
			if self:mTermOrig>0 .and. self:mTermOrig<=12
				self:mterm:=self:mTermOrig
			else
				self:mterm:=1
			endif
			self:oDCmterm:Show()
			self:oDCmEndDate:Show()
			self:oDCFixedText11:Show()
			self:oDCSC_P07:Show()
		endif  
	elseif oControl:Name=="MBLOCKED"
		if oControl:Value==FALSE
			self:oDCmBlocked:TextColor:=Color{COLORBLACK}
		else
			self:oDCmBlocked:TextColor:=Color{COLORRED}
		endif
	
	ENDIF

	RETURN NIL

METHOD CancelButton( ) CLASS EditSubscription
SELF:EndWindow()
RETURN
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS EditSubscription
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "MPERSON"
			if !IsNil(oControl:VALUE)
				if !AllTrim(oControl:VALUE)==AllTrim(cPersonName)
					cPersonName:=AllTrim(oControl:VALUE)
					self:PersonButton(true)
				endif
			else
				self:PersonButton(true)
			endif				
		ELSEIF oControl:Name == "MACCOUNT"
			if !IsNil(oControl:VALUE)
				if !AllTrim(oControl:VALUE)==AllTrim(cAccountName)
					cAccountName:=AllTrim(oControl:VALUE)
					self:AccButton(true)
				endif
			else
				self:AccButton(true)
			endif				
		ENDIF
	ENDIF
	
	RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditSubscription 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditSubscription",_GetInst()},iCtlID)

oDCSC_RLN := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_SC_RLN,_GetInst()}}
oDCSC_RLN:HyperLabel := HyperLabel{#SC_RLN,"Person:",NULL_STRING,NULL_STRING}

oDCSC_P01N := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_SC_P01N,_GetInst()}}
oDCSC_P01N:HyperLabel := HyperLabel{#SC_P01N,"Account:",NULL_STRING,NULL_STRING}

oDCSC_P04 := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_SC_P04,_GetInst()}}
oDCSC_P04:HyperLabel := HyperLabel{#SC_P04,"Begin date:",NULL_STRING,NULL_STRING}

oDCSC_P06 := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_SC_P06,_GetInst()}}
oDCSC_P06:HyperLabel := HyperLabel{#SC_P06,"Next due date:",NULL_STRING,NULL_STRING}

oDCSC_P07 := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_SC_P07,_GetInst()}}
oDCSC_P07:HyperLabel := HyperLabel{#SC_P07,"Frequency:",NULL_STRING,NULL_STRING}

oDCSC_P08 := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_SC_P08,_GetInst()}}
oDCSC_P08:HyperLabel := HyperLabel{#SC_P08,"Periodic amount:",NULL_STRING,NULL_STRING}

oDCSC_P13 := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_SC_P13,_GetInst()}}
oDCSC_P13:HyperLabel := HyperLabel{#SC_P13,"Alter date:",NULL_STRING,NULL_STRING}

oDCmPerson := SingleLineEdit{SELF,ResourceID{EDITSUBSCRIPTION_MPERSON,_GetInst()}}
oDCmPerson:HyperLabel := HyperLabel{#mPerson,NULL_STRING,"The person, who is a subscriber/donor","HELP_CLN"}
oDCmPerson:UseHLforToolTip := True

oCCPersonButton := PushButton{SELF,ResourceID{EDITSUBSCRIPTION_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v","Browse in persons",NULL_STRING}
oCCPersonButton:TooltipText := "Browse in Persons"

oDCmAccount := SingleLineEdit{SELF,ResourceID{EDITSUBSCRIPTION_MACCOUNT,_GetInst()}}
oDCmAccount:HyperLabel := HyperLabel{#mAccount,NULL_STRING,"Number of account of the subscription",NULL_STRING}

oCCAccButton := PushButton{SELF,ResourceID{EDITSUBSCRIPTION_ACCBUTTON,_GetInst()}}
oCCAccButton:HyperLabel := HyperLabel{#AccButton,"v","Browse in accounts",NULL_STRING}
oCCAccButton:TooltipText := "Browse in accounts"

oDCmbegindate := DateTimePicker{SELF,ResourceID{EDITSUBSCRIPTION_MBEGINDATE,_GetInst()}}
oDCmbegindate:HyperLabel := HyperLabel{#mbegindate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmDueDate := DateTimePicker{SELF,ResourceID{EDITSUBSCRIPTION_MDUEDATE,_GetInst()}}
oDCmDueDate:HyperLabel := HyperLabel{#mDueDate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmamount := mySingleEdit{SELF,ResourceID{EDITSUBSCRIPTION_MAMOUNT,_GetInst()}}
oDCmamount:HyperLabel := HyperLabel{#mamount,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmamount:FieldSpec := Transaction_DEB{}

oDCInvoiceText := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_INVOICETEXT,_GetInst()}}
oDCInvoiceText:HyperLabel := HyperLabel{#InvoiceText,"Invoice ID (KID):",NULL_STRING,NULL_STRING}

oCCRadioButtonGiro := RadioButton{SELF,ResourceID{EDITSUBSCRIPTION_RADIOBUTTONGIRO,_GetInst()}}
oCCRadioButtonGiro:HyperLabel := HyperLabel{#RadioButtonGiro,"Giro Accept",NULL_STRING,NULL_STRING}

oCCRadioButtonCollection := RadioButton{SELF,ResourceID{EDITSUBSCRIPTION_RADIOBUTTONCOLLECTION,_GetInst()}}
oCCRadioButtonCollection:HyperLabel := HyperLabel{#RadioButtonCollection,"Direct Debit",NULL_STRING,NULL_STRING}

oDCmInvoiceID := SingleLineEdit{SELF,ResourceID{EDITSUBSCRIPTION_MINVOICEID,_GetInst()}}
oDCmInvoiceID:HyperLabel := HyperLabel{#mInvoiceID,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmInvoiceID:FieldSpec := BANK{}

oDCmBankAccnt := combobox{SELF,ResourceID{EDITSUBSCRIPTION_MBANKACCNT,_GetInst()}}
oDCmBankAccnt:HyperLabel := HyperLabel{#mBankAccnt,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmReference := SingleLineEdit{SELF,ResourceID{EDITSUBSCRIPTION_MREFERENCE,_GetInst()}}
oDCmReference:HyperLabel := HyperLabel{#mReference,NULL_STRING,"Reference code to be inserted in transaction",NULL_STRING}

oDCmLstchange := SingleLineEdit{SELF,ResourceID{EDITSUBSCRIPTION_MLSTCHANGE,_GetInst()}}
oDCmLstchange:HyperLabel := HyperLabel{#mLstchange,NULL_STRING,NULL_STRING,NULL_STRING}

oDCTypeText := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_TYPETEXT,_GetInst()}}
oDCTypeText:HyperLabel := HyperLabel{#TypeText,NULL_STRING,NULL_STRING,NULL_STRING}

oDCBankText := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_BANKTEXT,_GetInst()}}
oDCBankText:HyperLabel := HyperLabel{#BankText,"Bank account:",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITSUBSCRIPTION_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{EDITSUBSCRIPTION_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oDCSC_REF := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_SC_REF,_GetInst()}}
oDCSC_REF:HyperLabel := HyperLabel{#SC_REF,"Reference:",NULL_STRING,NULL_STRING}

oDCmEndDate := DateTimePicker{SELF,ResourceID{EDITSUBSCRIPTION_MENDDATE,_GetInst()}}
oDCmEndDate:HyperLabel := HyperLabel{#mEndDate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText11 := FixedText{SELF,ResourceID{EDITSUBSCRIPTION_FIXEDTEXT11,_GetInst()}}
oDCFixedText11:HyperLabel := HyperLabel{#FixedText11,"End date:",NULL_STRING,NULL_STRING}

oDCmBlocked := CheckBox{SELF,ResourceID{EDITSUBSCRIPTION_MBLOCKED,_GetInst()}}
oDCmBlocked:HyperLabel := HyperLabel{#mBlocked,"Blocked temporary for debiting",NULL_STRING,NULL_STRING}

oDCmterm := combobox{SELF,ResourceID{EDITSUBSCRIPTION_MTERM,_GetInst()}}
oDCmterm:FillUsing(GiftFrequency)
oDCmterm:HyperLabel := HyperLabel{#mterm,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmType := RadioButtonGroup{SELF,ResourceID{EDITSUBSCRIPTION_MTYPE,_GetInst()}}
oDCmType:HyperLabel := HyperLabel{#mType,"Type:",NULL_STRING,NULL_STRING}

oDCmPayMethod := RadioButtonGroup{SELF,ResourceID{EDITSUBSCRIPTION_MPAYMETHOD,_GetInst()}}
oDCmPayMethod:FillUsing({ ;
							{oCCRadioButtonGiro,"G"}, ;
							{oCCRadioButtonCollection,"C"} ;
							})
oDCmPayMethod:HyperLabel := HyperLabel{#mPayMethod,"Payment Method",NULL_STRING,NULL_STRING}

SELF:Caption := "Edit subscription/donation/standard gift"
SELF:HyperLabel := HyperLabel{#EditSubscription,"Edit subscription/donation/standard gift",NULL_STRING,NULL_STRING}
SELF:EnableStatusBar(True)
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method ListBoxSelect(oControlEvent) class EditSubscription
	local oControl as Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControl:Name=="MTERM"
		if self:mterm==999
			self:oDCmEndDate:hide()
			self:oDCFixedText11:hide()
		else
			self:oDCmEndDate:Show()
			self:oDCFixedText11:Show()			
		endif
	endif 
	return nil

ACCESS mAccount() CLASS EditSubscription
RETURN SELF:FieldGet(#mAccount)

ASSIGN mAccount(uValue) CLASS EditSubscription
SELF:FieldPut(#mAccount, uValue)
RETURN uValue

ACCESS mamount() CLASS EditSubscription
RETURN SELF:FieldGet(#mamount)

ASSIGN mamount(uValue) CLASS EditSubscription
SELF:FieldPut(#mamount, uValue)
RETURN uValue

ACCESS mBankAccnt() CLASS EditSubscription
RETURN SELF:FieldGet(#mBankAccnt)

ASSIGN mBankAccnt(uValue) CLASS EditSubscription
SELF:FieldPut(#mBankAccnt, uValue)
RETURN uValue

ACCESS mBlocked() CLASS EditSubscription
RETURN SELF:FieldGet(#mBlocked)

ASSIGN mBlocked(uValue) CLASS EditSubscription
SELF:FieldPut(#mBlocked, uValue)
RETURN uValue

ACCESS mInvoiceID() CLASS EditSubscription
RETURN SELF:FieldGet(#mInvoiceID)

ASSIGN mInvoiceID(uValue) CLASS EditSubscription
SELF:FieldPut(#mInvoiceID, uValue)
RETURN uValue

ACCESS mLstchange() CLASS EditSubscription
RETURN SELF:FieldGet(#mLstchange)

ASSIGN mLstchange(uValue) CLASS EditSubscription
SELF:FieldPut(#mLstchange, uValue)
RETURN uValue

ACCESS mPayMethod() CLASS EditSubscription
RETURN SELF:FieldGet(#mPayMethod)

ASSIGN mPayMethod(uValue) CLASS EditSubscription
SELF:FieldPut(#mPayMethod, uValue)
RETURN uValue

ACCESS mPerson() CLASS EditSubscription
RETURN SELF:FieldGet(#mPerson)

ASSIGN mPerson(uValue) CLASS EditSubscription
SELF:FieldPut(#mPerson, uValue)
RETURN uValue

ACCESS mReference() CLASS EditSubscription
RETURN SELF:FieldGet(#mReference)

ASSIGN mReference(uValue) CLASS EditSubscription
SELF:FieldPut(#mReference, uValue)
RETURN uValue

ACCESS mterm() CLASS EditSubscription
RETURN SELF:FieldGet(#mterm)

ASSIGN mterm(uValue) CLASS EditSubscription
SELF:FieldPut(#mterm, uValue)
RETURN uValue

ACCESS mType() CLASS EditSubscription
RETURN SELF:FieldGet(#mType)

ASSIGN mType(uValue) CLASS EditSubscription
SELF:FieldPut(#mType, uValue)
RETURN uValue

METHOD OKButton( ) CLASS EditSubscription
	LOCAL i, nPrevRec,m,d,y,me,term as int 
	local fLimit as float
	local mBankacc as string 
	local cStatement,cDueDeleteWhere as string 
	local cmessage,cError as string
	local LastDDdate,dNewDuedate,dThisMonthBegin,dInvoiceBegin as date 
	local cLog as string
	local lAmendmentdel,lAmendmentIns,lProlongate,lChanged as logic 
	local aMndt as array
	local oDue,oSel as SQLSelect
	local oStmnt,oStmntDue as SQLStatement

	*Check obliged fields:
	IF Empty(self:mRek)
		(ErrorBox{,self:oLan:WGet("You have to enter an Account") }):Show()
		self:oDCmAccount:SetFocus()
		RETURN nil
	ELSEIF Empty(self:mCLN)
		(ErrorBox{self,self:oLan:WGet("You should enter a Person") }):Show()
		self:oDCmPerson:SetFocus()
		RETURN nil
	ELSEIF Empty(self:mamount)
		(ErrorBox{self,self:oLan:WGet("You have to enter a periodic amount") }):Show()
		self:oDCmPerson:SetFocus()
		RETURN nil
	ELSE
		if !self:mtype == 'G'
			IF Empty(oDCmDueDate:SelectedDate)
				(ErrorBox{self:Owner,self:oLan:WGet("Due date obliged in case of donor/subscription") }):Show()
				self:oDCmDueDate:SetFocus()
				RETURN nil
			ENDIF
			IF !Empty(self:oDCmbegindate:SelectedDate).and.self:oDCmbegindate:SelectedDate>self:oDCmDueDate:SelectedDate
				(ErrorBox{self:Owner,self:oLan:WGet("Enter a due date later than the startdate")}):Show()
				self:oDCmDueDate:SetFocus()
				RETURN nil
			ENDIF
			IF mindate>self:oDCmDueDate:SelectedDate
				(ErrorBox{self:Owner,self:oLan:WGet("Enter a due date later than last closed month")}):Show()
				self:oDCmDueDate:SetFocus()
				RETURN nil
			ENDIF
			IF !Empty(self:oDCmbegindate:SelectedDate).and. self:oDCmbegindate:SelectedDate>self:oDCmEndDate:SelectedDate
				(ErrorBox{self:Owner,"Enter an end date later than the startdate"}):Show()
				self:oDCmEndDate:SetFocus()
				RETURN nil
			ENDIF
			term:=ConI(self:mterm)
			IF Empty(term)
				(ErrorBox{,self:oLan:WGet("Term obliged in case of donor/subscription") }):Show()
				self:oDCmterm:SetFocus()
				RETURN nil
			ENDIF
			d:=Day(self:oDCmDueDate:SelectedDate)
			if d>28
				m:=Month(self:oDCmDueDate:SelectedDate) 
				y:=Year(self:oDCmDueDate:SelectedDate)
				for i:=term to 144 step term
					me:=MonthEnd((m+i)%12,y+(m+i-1)/12) 
					if d>me
						(ErrorBox{self:Owner,self:oLan:WGet("Enter a due date with a day before")+Space(1)+Str(me+1,-1)}):Show()
						self:oDCmDueDate:SetFocus()
						RETURN nil
					endif
				next
			endif					
		ENDIF
		IF !Empty(self:mInvoiceID)
			IF CountryCode=="47"
				if !IsMod10(AllTrim(self:mInvoiceID))
					(ErrorBox{,self:oLan:WGet("Invoice ID is not a modulus 10 number") }):Show()
					self:oDCmInvoiceID:SetFocus()
					RETURN nil
				ENDIF
			ENDIF
		ELSEIF self:mPayMethod="C"
			(ErrorBox{,self:oLan:WGet(iif(SepaEnabled,"Mandate id","Invoice ID")+" is mandatory in case of Direct Debit") }):Show()
			self:oDCmInvoiceID:SetFocus()
			RETURN nil		
		endif
		IF self:lNew .and. term<=12
			* check if subscription allready exists: 
			if (oSel:=SqlSelect{"select subscribid from subscription where personid="+mCLN+" and accid="+mRek+" and category='"+self:mtype+"'"+;
					" and term <=12 and extract(year_month from adddate(curdate(),interval term month))<extract(year_month from enddate)",oConn}):reccount>0 
				// 				LogEvent(self,oSel:SQLString,"loginfo")
				if (TextBox{self,self:oLan:WGet("Donations"),self:oLan:WGet("Warning")+': '+self:oLan:WGet(iif(self:mtype='D',"Donation","Subscription")+' of person already exists for this account')+;
						'. '+self:oLan:WGet("Continue")+'?',BUTTONYESNO+BOXICONHAND}):Show()==BOXREPLYNO
					RETURN nil
				endif
			ENDIF
		ENDIF
		
		IF Empty(self:mBankAccnt)
			IF CountryCode="31" .and. self:mPayMethod="C"
				(ErrorBox{,self:oLan:WGet("Bank account is mandatory in case of Direct Debit") }):Show()
				self:oDCmBankAccnt:SetFocus()
				RETURN nil		
			ENDIF 
		else
			if SepaEnabled
				if !IsSEPA(AllTrim(self:mBankAccnt))
					(ErrorBox{,self:oLan:WGet("Bankaccount")+Space(1)+AllTrim(self:mBankAccnt)+Space(1)+self:oLan:WGet("is not a valid SEPA bank account number")+"!!" }):Show()
					self:oDCmBankAccnt:SetFocus()
					RETURN nil		
				endif
			elseIF CountryCode="31"
				if Len(AllTrim(self:mBankAccnt))>7
					if !IsDutchBanknbr(AllTrim(self:mBankAccnt))
						(ErrorBox{,self:oLan:WGet("Bankaccount")+Space(1)+AllTrim(self:mBankAccnt)+Space(1)+self:oLan:WGet("is not correct")+"!!" }):Show()
						self:oDCmBankAccnt:SetFocus()
						RETURN nil		
					endif 
				endif
			endif
		endif
		if self:mPayMethod="C" .and. SepaEnabled                    
			// check mandate id is unique:
			self:mInvoiceID:=AllTrim(self:mInvoiceID)
			// 			if	SqlSelect{"select subscribid from subscription where invoiceid='"+self:mInvoiceID+"' and personid<>"+mCLN+iif(self:lNew,''," and subscribid<>"+self:msubid),oConn}:reccount>0
			// 			if SqlSelect{"select subscribid from subscription where invoiceid='"+self:mInvoiceID+"' and bankaccnt='"+AllTrim(self:mBankAccnt)+"'"+iif(self:lNew,''," and subscribid<>"+self:msubid),oConn}:reccount>0
			if SqlSelect{"select subscribid from subscription where invoiceid='"+AddSlashes(self:mInvoiceID)+"'"+iif(self:lNew,''," and subscribid<>"+self:msubid),oConn}:reccount>0
				(ErrorBox{,self:oLan:WGet("Mandate id allready exists")}):Show()
				self:oDCmInvoiceID:SetFocus()
				RETURN nil
			endif		
		endif
		IF self:mPayMethod="C" 
			fLimit:=SqlSelect{"select ddmaxindvdl from sysparms",oConn}:ddmaxindvdl
			if fLimit>0.00
				if self:mamount> fLimit
					(ErrorBox{,self:oLan:WGet("Periodic amount")+Space(1)+str(self:mamount,-1)+Space(1)+self:oLan:WGet("is above limit")+": "+str(fLimit,-1) }):Show()
					self:oDCmamount:SetFocus()
					RETURN nil		
				endif 
			endif
		endif
		
	ENDIF

	if SepaEnabled .and. !Empty(self:mBankAccnt)
		self:mBic:=''
		mBankacc:=self:mBankAccnt
		if (i:=AScan(self:aBankaccs,{|x|x[1]==mBankacc}))>0
			self:mBic:=self:aBankaccs[i,2]
		endif 
		if Empty(self:mBic)
			(ErrorBox{,self:oLan:WGet('No Bic filled for this bankaccount')}):Show()
			RETURN nil
		ENDIF
	endif
	if self:mtype=="D" .and. self:mPayMethod=="C"
		if self:lNew
			cLog:=self:oLan:RGet("Inserted donation")+':'+;
				"personid="+ self:mCLN +;
				", personname="+self:cPersonName+;
				", account="+ self:mAccNumber+' '+self:cAccountName+;
				", begindate="+ DToC(self:oDCmbegindate:SelectedDate)+;
				", enddate="+ DToC(self:oDCmEndDate:SelectedDate)+;
				", duedate="+ DToC(self:oDCmDueDate:SelectedDate)+;
				", term="+ Str(term,-1)+;
				", amount="+ Str(self:mamount,-1) +;
				", "+iif(SepaEnabled,"mandateid","invoiceid")+"="+self:mInvoiceID+;
				", bankaccount="+self:oDCmBankAccnt:CurrentItem
		else

			// check if dueamounts or next due date has to be updated: 
			if !term==self:oSub:term .or. !self:oDCmDueDate:SelectedDate==self:oSub:duedate.or.!self:mamount==self:oSub:amount.or. !self:oSub:enddate==self:oDCmEndDate:SelectedDate
				// term, nextduedate or amount changed:
				// determine last collection date for this subscription:
				oDue:=SqlSelect{'select cast(invoicedate as date) as invoicedate from dueamount d where subscribid='+self:msubid+' and amountrecvd>0.00 order by invoicedate desc limit 1',oConn}
				oDue:Execute()
				if oDue:reccount=1
					LastDDdate:=oDue:invoicedate
				endif
				if self:oDCmDueDate:SelectedDate<self:oSub:duedate
					if self:oDCmDueDate:SelectedDate <= EndOfMonth(LastDDdate)
						ErrorBox{self,self:oLan:WGet("Next due date should be after last direct debit date")+': '+maand[Month(LastDDdate)]+' '+Str(Year(LastDDdate),-1)}:Show()
						return
					endif
				endif
				if !self:oSub:enddate==self:oDCmEndDate:SelectedDate
					if self:oDCmEndDate:SelectedDate <= EndOfMonth(LastDDdate)
						ErrorBox{self,self:oLan:WGet("End date should be after last direct debit date")+': '+maand[Month(LastDDdate)]+' '+Str(Year(LastDDdate),-1)}:Show()
						return
					endif
					cDueDeleteWhere:='invoicedate >="'+SQLdate(BeginOfMonth(self:oDCmEndDate:SelectedDate))+'"'
				endif
				if self:oDCmDueDate:SelectedDate==self:oSub:duedate 
					if !term==self:oSub:term
						// adapt next due date
						LastDDdate:= getvaliddate(day(LastDDdate),month(LastDDdate)+1,year(LastDDdate))
						self:oDCmDueDate:SelectedDate:=Max(stod(substr(dtos(Today()),1,6)+strzero(min(25,day(self:oDCmDueDate:SelectedDate)),2,0)),LastDDdate )
					elseif !self:mamount==self:oSub:amount // amount changed 
						dThisMonthBegin:=BeginOfMonth(Today())
						oDue:=SqlSelect{'select cast(invoicedate as date) as invoicedate from dueamount d where subscribid='+self:msubid+' and amountrecvd=0.00 '+;
							'and invoicedate >= "'+SQLdate(dThisMonthBegin)+'" order by invoicedate asc limit 1',oConn}
						if oDue:reccount>0 // open due amount in this month or later:
							// set next due date n term back:
							dInvoiceBegin:=BeginOfMonth(oDue:invoicedate)
							dNewDuedate:=self:oDCmDueDate:SelectedDate
							do while dNewDuedate>EndOfMonth(Today()) .and. dNewDuedate>EndOfMonth(dInvoiceBegin)
								dNewDuedate:=getvaliddate(day(dNewDuedate),-term+month(dNewDuedate),year(dNewDuedate))
								if dNewDuedate>=dThisMonthBegin .and. dNewDuedate>=dInvoiceBegin .and. (Empty(LastDDdate) .or. SubStr(DToS(dNewDuedate),1,6)>SubStr(DToS(LastDDdate),1,6) )
									self:oDCmDueDate:SelectedDate:=dNewDuedate
								endif
							enddo
						endif
					endif
					if !self:oDCmDueDate:SelectedDate==self:oSub:duedate 
						lProlongate:=true
						// 						cmessage:=self:oLan:WGet("Next due date adapted")
						cDueDeleteWhere+=iif(Empty(cDueDeleteWhere),'',' or ')+'invoicedate>="'+SQLdate(BeginOfMonth(self:oDCmDueDate:SelectedDate))+'"' 
					endif
				else
					cDueDeleteWhere+=iif(Empty(cDueDeleteWhere),'',' or ')+'invoicedate>="'+SQLdate(BeginOfMonth(self:oDCmDueDate:SelectedDate))+'"' 
				endif
			endif
			if SepaEnabled .and.!self:mBankAccnt==self:oSub:BANKACCNT
				// bank account changed
				if !Empty(self:oSub:firstinvoicedate)  // not first time
					// check if already amendment present:
					if (oSel:=sqlselect{"select banknumber,bic from amendment where subscribid="+self:msubid,oConn}):reccount>0
						// if same as new banknumber: remove:
						if oSel:banknumber==self:mBankAccnt 
							lAmendmentDel:=true
						endif
					else
						lAmendmentIns:=true
					endif
					/*			// same bank? new mandateid needed
					aMndt:=Split(self:mInvoiceID,'-')
					if Len(aMndt)<7
					self:mInvoiceID+='-1'
					else
					self:mInvoiceID:=aMndt[1]+'-'+aMndt[2]+'-'+aMndt[3]+'-'+aMndt[4]+'-'+aMndt[5]+'-'+aMndt[6]+'-'+Str(Val(aMndt[7])+1,-1)
					ENDIF */
				ENDIF
			endif 
			cLog:=iif(self:mCLN==self:mCurCLN,'','personid:'+self:mCurCLN+' '+self:oSub:personname +'-> '+self:mCLN+' '+self:cPersonName+CRLF)+;
				iif(self:mAccNumber==self:oSub:ACCNUMBER,'','account:'+self:oSub:ACCNUMBER+' '+self:oSub:accountname+'-> '+self:mAccNumber+CRLF)+;
				iif(self:oDCmbegindate:SelectedDate==self:oSub:begindate,'','begindate:'+DToC(self:oSub:begindate)+'-> '+DToC(self:oDCmbegindate:SelectedDate)+CRLF)+;
				iif(self:oDCmenddate:SelectedDate==self:oSub:enddate,'','enddate:'+dtoc(self:oSub:enddate)+'-> '+dtoc(self:oDCmenddate:SelectedDate)+CRLF)+;
				iif(self:oDCmduedate:SelectedDate==self:oSub:duedate,'','duedate:'+dtoc(self:oSub:duedate)+'-> '+dtoc(self:oDCmduedate:SelectedDate)+CRLF)+;
				iif(ConS(term)==ConS(self:oSub:term),'','term:'+ConS(self:oSub:term)+'-> '+ConS(term)+CRLF)+;
				iif(self:mamount==self:oSub:amount,'','amount:'+Str(self:oSub:amount,-1)+'-> '+Str(self:mamount,-1)+CRLF)+;
				iif(ConS(self:mInvoiceID)==self:oSub:InvoiceID,'',iif(SepaEnabled,"mandateid","invoiceid")+"="+self:oSub:InvoiceID+'-> '+ConS(self:mInvoiceID)+CRLF)+;
				iif(ConS(self:mBankAccnt)==self:oSub:BANKACCNT,'','bankaccnt:'+self:oSub:BANKACCNT+'-> '+ConS(self:oDCmBankAccnt:TextValue)+CRLF)+;   
			iif(iif(self:mblocked,"1","0")==self:oSub:blocked,'','blocked:'+;
				iif(ConI(self:oSub:blocked)=1,"true","false")+'-> '+ iif(self:mblocked,"true","false")+CRLF)
			if Empty(cLog)
				// nothing changed: 
				self:EndWindow()
				return
			endif 
			cLog:=self:oLan:RGet("Updated donation")+':'+; 
			"personid="+ self:mCLN+;
				", personname="+self:cPersonName+;
				", account="+ self:mAccNumber+' '+self:cAccountName+;
				CRLF+"CHANGES:"+CRLF+cLog
			
		endif
	endif
	SetDecimalSep(Asc('.'))  // to be sure
	
	cStatement:=iif(self:lNew,"insert into","update")+" subscription set "+;
		"accid="+ self:mRek   +;
		",personid="+ self:mCLN +;
		",begindate='"+ SQLdate(iif(Empty(self:oDCmbegindate:SelectedDate),Today(),self:oDCmbegindate:SelectedDate))+"'"+;
		",enddate='"+ SQLdate(self:oDCmEndDate:SelectedDate)+"'"+;
		",duedate='"+ SQLdate(self:oDCmDueDate:SelectedDate)+"'"+;
		",term="+ Str(term,-1)+;
		",amount="+ Str(self:mamount,-1) +;
		",lstchange=NOW()"+;
		",category='"+ self:mtype+"'"+;
		",invoiceid='"+ iif(IsNil(self:mInvoiceID),"",AddSlashes(self:mInvoiceID))+"'"+;
		",reference='"+iif(IsNil(self:mReference),"",AddSlashes(self:mReference))+"'"+;
		",paymethod='"+iif(IsNil(self:mPayMethod),"",self:mPayMethod)+"'"+; 
	",bankaccnt='"+iif(IsNil(self:oDCmBankAccnt:TextValue),"",self:oDCmBankAccnt:TextValue)+"'"+;
		",bic='"+ConS(self:mBic)+"'"+;  
	",blocked="+iif(self:mblocked,"1","0")+;
		iif(self:lNew,''," where subscribid="+self:msubid)
	// 		iif(self:lNew .or.!ConS(self:mBankAccnt)==self:oSub:BANKACCNT,',firstinvoicedate="0000-00-00"','')+;   // reset to first in case of bankaccount change
	oStmnt:=SQLStatement{"set autocommit=0",oConn}
	oStmnt:Execute()
	oStmnt:=SQLStatement{'lock tables '+iif(lAmendmentDel.or. lAmendmentIns,'`amendment` write,','')+'`dueamount` write,`subscription` write',oConn} 
	oStmnt:Execute()
	oStmnt:=SQLStatement{cStatement,oConn}
	oStmnt:Execute()
	if Empty(oStmnt:status) 
		if !Empty(cDueDeleteWhere)
			oStmntDue:=SQLStatement{"delete from dueamount where subscribid="+self:msubid+" and amountrecvd=0.00 and ("+cDueDeleteWhere+")",oConn}
			oStmntDue:Execute()
			if !Empty(oStmntDue:status)
				cError:=oStmntDue:ErrInfo:errormessage+CRLF+"statement:"+oStmntDue:SQLString 
			else
				if oStmntDue:NumSuccessfulRows>0
					lProlongate:=true
					// 					cmessage+=iif(Empty(CMessage),'',' and ')+self:oLan:WGet("corresponding due amounts removed")
				endif
			endif	 
		endif
	else
		cError:=oStmnt:ErrInfo:errormessage+CRLF+"statement:"+cStatement
	endif
	if Empty(cError) 
		if lAmendmentDel
			oStmnt:=SQLStatement{'delete from amendment where subscribid='+self:msubid,oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				cError:=oStmnt:ErrInfo:errormessage+CRLF+"statement:"+oStmnt:SQLString 
			endif
		elseif lAmendmentIns
			oStmnt:=SQLStatement{'insert into amendment set subscribid='+self:msubid+',banknumber="'+self:oSub:BANKACCNT+'",bic="'+self:mCurBic+'"',oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				cError:=oStmnt:ErrInfo:errormessage+CRLF+"statement:"+oStmnt:SQLString 
			endif			
		endif
	endif
	if !Empty(cError) 
		SQLStatement{"rollback",oConn}:Execute()
		SQLStatement{"unlock tables",oConn}:Execute() 
		SQLStatement{"set autocommit=1",oConn}:Execute()
		ErrorBox{self,self:oLan:WGet("Could not update subscription")}:Show()
		LogEvent(self,"Could not update subscription"+"; error:"+cError,"logerrors")
		return
	endif
	SQLStatement{"commit",oConn}:Execute()
	SQLStatement{"unlock tables",oConn}:Execute() 
	SQLStatement{"set autocommit=1",oConn}:Execute() 
	self:oCaller:nTerm := term
	if lProlongate
		ProlongateAll(self)
		cmessage+=iif(Empty(CMessage),'',' '+self:oLan:WGet('and')+' ')+self:oLan:WGet("corresponding due amounts adapted")
	endif
	if !Empty(cLog)
		LogEvent(self,cLog+iif(Empty(CMessage),'',CRLF+CMessage))
	endif 
	if !Empty(CMessage)
		TextBox{self,self:oLan:WGet("Editing donation"),CMessage}:Show()
	endif
	if !(self:mtype=="D" .and. self:mPayMethod=="C") .or. !Empty(cLog) 
		self:oCaller:oSub:Execute()
		self:oCaller:FindButton()
		if self:lNew
			self:oCaller:goTop()
		else
			self:oCaller:goto(self:nCurRec)
		endif
	else
		WarningBox{self,self:oLan:WGet("editing subscription"),self:oLan:WGet("Nothing changed")}:Show()
	endif
	self:EndWindow()
	return nil
	// 	ELSE
	// 		RETURN
	// 	ENDIF
METHOD PersonButton(lUnique ) CLASS EditSubscription
LOCAL cValue := AllTrim(oDCmPerson:TEXTValue ) as STRING 
local oPers as PersonContainer
Default(@lUnique,FALSE) 
oPers:=PersonContainer{}

if !Empty(self:mCLN) .and. !Val(mCLN)=0
	oPers:persid:=self:mCLN
endif

PersonSelect(self,cValue,lUnique,,"Person for "+cType,oPers)

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditSubscription
	//Put your PostInit additions here
	LOCAL oSel as SQLSelect 
	Local aBankaccs:=self:aBankaccs as array 
	local aFreq:={} as array
	self:SetTexts()
	self:lNew :=uExtra[1]
	self:oCaller:=uExtra[2]
	self:cType:=iCtlID
	aFreq:=AClone(GiftFrequency) 
	if !self:cType=="DONATIONS"
		ADel(aFreq,1)           // only for donations one-off
		ASize(aFreq,4)
	endif		
	self:oDCmterm:FillUsing(aFreq)							
	IF !self:lNew
		self:msubid:=Str(oServer:subscribid,-1) 
		self:nCurRec:=oServer:RecNo
		self:oSub:=SqlSelect{"select s.accid,s.personid,cast(s.begindate as date) as begindate, cast(s.duedate as date) as duedate,cast(ifnull(s.firstinvoicedate,'0000-00-00') as date) as firstinvoicedate,"+;
			"cast(s.enddate as date) as enddate,s.paymethod,s.bankaccnt,s.bic,s.term,s.amount, cast(s.lstchange as date) as lstchange,s.category,s.invoiceid,s.reference,s.blocked,"+;
			SQLFullName(0,"p")+" as personname,a.description as accountname,a.accnumber,group_concat(b.banknumber,'#%#',b.bic separator ',') as bankaccs "+;
			"from subscription s, account a,person p "+; 
		+" left join personbank b on (b.persid=p.persid) " +;
			" where a.accid=s.accid and p.persid=s.personid and subscribid="+self:msubid+" group by s.personid",oConn}
		if oSub:reccount>0
			if SepaEnabled .and. !Empty(oSub:firstinvoicedate) .and. SQLdate(oSub:firstinvoicedate)>'0000-00-00' .or.!self:cType=="DONATIONS" 
				aFreq:=AClone(GiftFrequency) 
				if oSub:term<999 .and. oSub:term>0
					ADel(aFreq,1) 
					ASize(aFreq,4)
					self:oDCmterm:FillUsing(aFreq)
				else
					ASize(aFreq,1)
					self:oDCmterm:FillUsing(aFreq)					
				endif
			endif
		endif
	ENDIF 

	SaveUse("EDIT"+self:cType)
	IF self:cType=="STANDARD GIFTS"
		self:mtype:="G"
		self:oDCInvoiceText:hide()
		self:oDCmInvoiceID:hide()
		self:oDCmPayMethod:hide()
		self:oCCRadioButtonCollection:hide()
		self:oCCRadioButtonGiro:hide() 
		self:oDCmDueDate:hide()
		self:oDCmterm:hide()
		self:oDCmEndDate:hide()
		self:oDCFixedText11:hide()
		self:oDCSC_P06:hide()
		self:oDCSC_P07:hide()
		self:oDCmReference:Show()
		self:oDCSC_REF:Show()
		self:oDCmBlocked:hide()
	ELSEIF cType=="SUBSCRIPTIONS"
		self:mtype:="A"
		if sEntity == "NOR"
			self:oDCInvoiceText:Show()
			self:oDCmInvoiceID:Show()
		endif
		self:oDCmBlocked:hide()
	ELSEIF cType=="DONATIONS"
		self:mtype:="D"
		if CountryCode=="47"
			self:oDCInvoiceText:Show()
			self:oDCmInvoiceID:Show()
		endif
		self:dLastDDdate:=self:oCaller:dLastDDdate
		self:mBankAccnt:=''  
	ENDIF

	IF self:lNew
// 		self:cPersonName :="" 
// 		self:cPersonName:=self:oCaller:cPersonName
// 		self:mCLN:=self:oCaller:mCLN
// 		self:oDCmPerson:TextValue := self:cPersonName
		self:cAccountName :=""
		self:oDCmbegindate:SelectedDate:=stod(substr(dtos(Today()),1,6)+'01')
		IF self:mtype=="D" .and. self:dLastDDdate>=self:oDCmbegindate:SelectedDate  // allready collected?
			self:oDCmbegindate:SelectedDate:=EndOfMonth(Today())+1  // next month
		endif	
		self:oDCmDueDate:SelectedDate:=SToD(SubStr(DToS(self:oDCmbegindate:SelectedDate),1,6)+'20')
		self:oDCmEndDate:SelectedDate:=self:oDCmDueDate:SelectedDate+365*100
		self:mterm   := self:oCaller:nTerm
		self:mamount   := 0  
		self:mBlocked:= false  
		self:oDCmBlocked:hide()
		IF !self:cType=="STANDARD GIFTS"
			self:oDCmPayMethod:Value:="C"
		endif
		IF self:mtype=="D".and.!Empty(SDON)
			oSel:=SqlSelect{"select accnumber,description from account where accid="+SDON,oConn}
			if oSel:reccount>0
				self:cAccountName :=oSel:description 
				self:mAccount:= cAccountName
				self:mRek:=SDON
				self:mAccNumber:=oSel:ACCNUMBER
			ENDIF			
		ENDIF
		self:RegPerson(self:oCaller)
	ELSE
		self:mRek := Str(self:oSub:accid,-1)                  
		self:cAccountName := self:oSub:accountname
		self:mAccount:= cAccountName
		self:mAccNumber:=self:oSub:ACCNUMBER
		self:mCLN:=Str(self:oSub:personid,-1) 
		self:mCurRek:=self:mRek 
		self:mCurCLN:=self:mCLN
		self:cPersonName := self:oSub:personname
		self:mPerson:= cPersonName
		self:mCurBic:=self:oSub:Bic
		self:mBic:=self:mCurBic  
		self:mBlocked:=iif(ConI(self:oSub:blocked)=1,true,false)      
		// self:oDCmBlocked:TextCo

		self:oDCmbegindate:SelectedDate := self:oSub:begindate
		IF Empty(self:oSub:duedate)
			self:oDCmDueDate:SelectedDate := Today()+40000
		ELSE
			self:oDCmDueDate:SelectedDate := self:oSub:duedate
		ENDIF
		self:oDCmEndDate:SelectedDate := iif(Empty(self:oSub:enddate),Today()+365*100,self:oSub:enddate)

		self:mterm := ConI(self:oSub:term)
		self:mTermOrig:=ConI(self:mterm)
		self:mamount := self:oSub:amount
		self:mlstchange := self:oSub:lstchange                 
		self:mtype := self:oSub:category
		IF Empty(self:oSub:PAYMETHOD)
			self:oDCmPayMethod:Value:="G"
		ELSE
			self:oDCmPayMethod:Value:=self:oSub:PAYMETHOD
		ENDIF
		self:mInvoiceID:=self:oSub:InvoiceID
		self:mReference:=self:oSub:REFERENCE     
		IF !Empty(self:oSub:BankAccs)
			Aeval(split(self:oSub:bankaccs,','),{|x|aadd(aBankaccs,split(x,'#%#'))})
			self:oDCmBankAccnt:FillUsing(Split(Implode(self:aBankaccs,',',,,1),',') )
			if !Empty(self:oSub:BANKACCNT)
				self:oDCmBankAccnt:CurrentItem :=self:oSub:BANKACCNT
			endif
		endif
		if cType=="DONATIONS" 
			if ConI(oSub:term) >=999
				self:oDCmEndDate:hide()
				self:oDCFixedText11:hide()
			endif
		endif
	ENDIF
	IF self:mtype=="D"
		self:oDCTypeText:Value:=self:oLan:WGet("Donation")
		self:cHeading:="Donation Account"
		self:Caption:=self:oLan:WGet("Edit ")
		if CountryCode="31"
			self:oDCBankText:Show()
			self:oDCmBankAccnt:Show()
			// find bankaccounts if empty:
		endif                                                                        c

	ELSEIF self:mtype == "A"
		self:oDCTypeText:Value:=self:oLan:WGet("Subscription")
		self:cHeading:=self:oLan:WGet("Subscription Account")
	ELSE
		self:oDCTypeText:Value:=self:oLan:WGet("Periodic Gift")
		self:cHeading:=self:oLan:WGet("Periodic Gift Account")
	ENDIF
	self:Caption:="Edit "+self:oDCTypeText:Value
	IF self:mtype=="A"
		self:oDCmamount:Disable()
	ELSE
		self:oDCmamount:Enable()
	ENDIF 
	if SepaEnabled .and. self:mPayMethod='C' 
		self:oDCInvoiceText:TextValue:=self:oLan:WGet("Mandate id")+': '
		if !lNew
			self:oDCmInvoiceID:Show() 
			self:oDCInvoiceText:Show()
			if (oSel:=SqlSelect{"select cast(ifnull(firstinvoicedate,'0000-00-00') as char) as firstinvoicedate from subscription where subscribid="+self:msubid,oConn}):reccount>0  
				if !Empty(oSel:firstinvoicedate).and.oSel:firstinvoicedate>'0000-00-00'
					self:oDCmInvoiceID:Disable() 
					if ConI(oSub:term) >=999
						self:oCCOKButton:hide() 
						self:oDCmBlocked:hide()
					endif
// 				elseif self:mterm>=999 .and. ( self:oDCmDueDate:SelectedDate - self:oDCmbegindate:SelectedDate)>400       // already debited
// 					self:oCCOKButton:hide()     
// 					self:oDCmBlocked:hide()
				endif
			endif
		endif
	endif   
	
	if self:mBlocked
		self:oDCmBlocked:TextColor:=Color{COLORRED}		
	else
		self:oDCmBlocked:TextColor:=Color{COLORBLACK}
	endif	

	RETURN nil
STATIC DEFINE EDITSUBSCRIPTION_ACCBUTTON := 110 
STATIC DEFINE EDITSUBSCRIPTION_BANKTEXT := 124 
STATIC DEFINE EDITSUBSCRIPTION_CANCELBUTTON := 125 
STATIC DEFINE EDITSUBSCRIPTION_FIXEDTEXT11 := 129 
STATIC DEFINE EDITSUBSCRIPTION_INVOICETEXT := 114 
STATIC DEFINE EDITSUBSCRIPTION_MACCOUNT := 109 
STATIC DEFINE EDITSUBSCRIPTION_MAMOUNT := 113 
STATIC DEFINE EDITSUBSCRIPTION_MBANKACCNT := 119 
STATIC DEFINE EDITSUBSCRIPTION_MBEGINDATE := 111 
STATIC DEFINE EDITSUBSCRIPTION_MBLOCKED := 130 
STATIC DEFINE EDITSUBSCRIPTION_MDUEDATE := 112 
STATIC DEFINE EDITSUBSCRIPTION_MENDDATE := 128 
STATIC DEFINE EDITSUBSCRIPTION_MINVOICEID := 118 
STATIC DEFINE EDITSUBSCRIPTION_MLSTCHANGE := 121 
STATIC DEFINE EDITSUBSCRIPTION_MPAYMETHOD := 123 
STATIC DEFINE EDITSUBSCRIPTION_MPERSON := 107 
STATIC DEFINE EDITSUBSCRIPTION_MREFERENCE := 120 
STATIC DEFINE EDITSUBSCRIPTION_MTERM := 131 
STATIC DEFINE EDITSUBSCRIPTION_MTYPE := 117 
STATIC DEFINE EDITSUBSCRIPTION_OKBUTTON := 126 
STATIC DEFINE EDITSUBSCRIPTION_PERSONBUTTON := 108 
STATIC DEFINE EDITSUBSCRIPTION_RADIOBUTTONCOLLECTION := 116 
STATIC DEFINE EDITSUBSCRIPTION_RADIOBUTTONGIRO := 115 
STATIC DEFINE EDITSUBSCRIPTION_SC_accid := 101 
STATIC DEFINE EDITSUBSCRIPTION_SC_amount := 105 
STATIC DEFINE EDITSUBSCRIPTION_SC_lstchange := 106 
STATIC DEFINE EDITSUBSCRIPTION_SC_P01N := 101 
STATIC DEFINE EDITSUBSCRIPTION_SC_P04 := 102 
STATIC DEFINE EDITSUBSCRIPTION_SC_P06 := 103 
STATIC DEFINE EDITSUBSCRIPTION_SC_P07 := 104 
STATIC DEFINE EDITSUBSCRIPTION_SC_P08 := 105 
STATIC DEFINE EDITSUBSCRIPTION_SC_P13 := 106 
STATIC DEFINE EDITSUBSCRIPTION_SC_personid := 100 
STATIC DEFINE EDITSUBSCRIPTION_SC_REF := 127 
STATIC DEFINE EDITSUBSCRIPTION_SC_RLN := 100 
STATIC DEFINE EDITSUBSCRIPTION_SC_term := 104 
STATIC DEFINE EDITSUBSCRIPTION_TYPETEXT := 122 
Function ProlongateAll(oCall as Window ) as logic
	local cValuesDue,cValuesSub as string  // values to insert into the database 
	local cError, cErrorMessage as string 
	LOCAL mSubid,SeqType as STRING, bed_toez as FLOAT
	LOCAL DueCount as int
	LOCAL rjaar,rmnd,rdag,nbrdue as int
	LOCAL mSeqnr as int
	local lError as logic
	
	local CurSubId as int, dDueDate as date 
	local aValuesDue:={} as array // {{subscribid,invoicedate,seqnr,amountinvoice,SeqTp},..
	LOCAL oSub as SQLSelect
	local oStmnt as SQLStatement 

	* last end date should be after next due date
	* only donations and subscriptions 
	oSub:=SqlSelect{"select s.subscribid,s.amount,cast(s.duedate as date) as duedate,s.term,cast(s.begindate as date) as begindate,cast(s.enddate as date) as enddate,"+;
	"s.personid,count(dueid) as nbrdue from subscription s left join dueamount d on (s.subscribid=d.subscribid) "+; 
	"where (s.category='D' or s.category='A') and s.duedate between subdate(Now(),INTERVAL 3 MONTH) and adddate(Now(),INTERVAL 1 MONTH) and s.enddate>s.duedate group by s.subscribid",oConn}       
	if oSub:RecCount<1
		return false
	endif
	oCall:STATUSMESSAGE("Busy with prolongating donations/subscriptions:")
	DO WHILE !oSub:EOF
		IF Empty(oSub:term)
			(ErrorBox{,"Empty term for:"+GetFullName(oSub:personid)}):Show()
			oSub:Skip()
			LOOP
		ENDIF
		DueCount:=DueCount+1
		mSubid:=Str(oSub:subscribid,-1)
		bed_toez:=oSub:amount
		dDueDate:=oSub:DueDate
		// determine sequence type:
		nbrdue:=ConI(oSub:nbrdue)
		SeqType:=''
		if nbrdue=0
			if Empty(oSub:term) .or. oSub:term>12
				SeqType:='OOFF' //OOFF
			elseif (Today() - oSub:begindate) < 120
				SeqType:='FRST'
			endif
		endif
		if Empty(SeqType)
			// final??
			if (oSub:enddate - oSub:DueDate) < oSub:term*30
				SeqType:='FNAL' //final
			else
				SeqType:='RCUR'
			endif
		endif
		* Add new due amount: 
		AAdd(aValuesDue,{mSubid, SQLdate(dDueDate),'1' ,Str(bed_toez,-1),SeqType })
		* update date due with term within subscription: 
		oSub:skip()
	ENDDO
	if !Empty(aValuesDue)
		oStmnt:=SQLStatement{"set autocommit=0",oConn}
		oStmnt:Execute()
		oStmnt:=SQLStatement{'lock tables `dueamount` write,`subscription` write',oConn} 
		oStmnt:Execute()
		if !Empty(oStmnt:Status)
			lError:=true
			cError:="could not produce direct debit dueamounts:"+oStmnt:ErrInfo:errormessage
			cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
		endif
		if !lError
			oStmnt:=SQLStatement{"insert ignore into dueamount (subscribid,invoicedate,seqnr,amountinvoice,seqtype) values "+Implode(aValuesDue,'","'),oConn}
			oStmnt:Execute()
			// 		if Empty(oStmnt:Status) .and. oStmnt:NumSuccessfulRows>0
			if !Empty(oStmnt:Status)
				lError:=true
				cError:="could not produce direct debit dueamounts:"+oStmnt:ErrInfo:errormessage
				cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
			endif 
		endif
		if !lError
			* update date due with term within subscription:
			oStmnt:=SQLStatement{"insert into subscription (subscribid) values "+Implode(aValuesDue,',',,,1,'),(')+;
				" on DUPLICATE KEY UPDATE duedate=adddate(duedate,INTERVAL term MONTH)",oConn} 
			oStmnt:Execute() 
			if !Empty(oStmnt:Status)
				lError:=true
				cError:="could not produce direct debit dueamounts:"+oStmnt:ErrInfo:errormessage
				cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
			endif
		endif
		if !lError
			* remove old due amounts:
			oStmnt:=SQLStatement{"delete from dueamount where invoicedate<subdate(Now(),INTERVAL 8 MONTH)",oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:Status)
				lError:=true
				cError:="could not produce direct debit dueamounts:"+oStmnt:ErrInfo:errormessage
				cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
			endif
		endif
		if !lError
			SQLStatement{"commit",oConn}:Execute()
			SQLStatement{"unlock tables",oConn}:Execute() 
			SQLStatement{"set autocommit=1",oConn}:Execute()
		else
			SQLStatement{"rollback",oConn}:Execute()
			SQLStatement{"unlock tables",oConn}:Execute() 
			SQLStatement{"set autocommit=1",oConn}:Execute()
			LogEvent(,"ProlongateAll:"+cErrorMessage,"LogErrors")
			ErrorBox{,cError}:Show()
			return false		
		endif
	endif

	oCall:STATUSMESSAGE(Space(80))

	RETURN true
STATIC DEFINE PROLONGATION_ACCBUTTON := 102 
STATIC DEFINE PROLONGATION_CANCELBUTTON := 106 
STATIC DEFINE PROLONGATION_DUEDATE := 107 
STATIC DEFINE PROLONGATION_FIXEDTEXT1 := 103 
STATIC DEFINE PROLONGATION_GROUPBOX1 := 105 
STATIC DEFINE PROLONGATION_MACCOUNT := 100 
STATIC DEFINE PROLONGATION_OKBUTTON := 104 
STATIC DEFINE PROLONGATION_SC_accid := 101 
RESOURCE SubscriptionBrowser DIALOGEX  22, 20, 550, 293
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", SUBSCRIPTIONBROWSER_SUBSCRIPTIONBROWSER_DETAIL, "static", WS_CHILD|WS_BORDER, 24, 96, 432, 172
	CONTROL	"&Account:", SUBSCRIPTIONBROWSER_SC_AR1, "Static", WS_CHILD, 24, 51, 32, 13
	CONTROL	"&Person:", SUBSCRIPTIONBROWSER_SC_OMS, "Static", WS_CHILD, 24, 36, 28, 13
	CONTROL	"", SUBSCRIPTIONBROWSER_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 100, 36, 120, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", SUBSCRIPTIONBROWSER_PERSONBUTTON, "Button", WS_CHILD, 220, 36, 13, 13
	CONTROL	"", SUBSCRIPTIONBROWSER_MACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 100, 51, 120, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", SUBSCRIPTIONBROWSER_ACCBUTTON, "Button", WS_CHILD, 220, 51, 13, 13
	CONTROL	"Edit", SUBSCRIPTIONBROWSER_EDITBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 476, 107, 53, 12
	CONTROL	"New", SUBSCRIPTIONBROWSER_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 476, 151, 53, 12
	CONTROL	"Delete", SUBSCRIPTIONBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 476, 195, 53, 13
	CONTROL	"Subscriptions", SUBSCRIPTIONBROWSER_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 84, 532, 190
	CONTROL	"Select subscriptions of:", SUBSCRIPTIONBROWSER_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 12, 3, 224, 70
	CONTROL	"", SUBSCRIPTIONBROWSER_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 280, 59, 156, 12
	CONTROL	"Found:", SUBSCRIPTIONBROWSER_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 248, 59, 27, 12
	CONTROL	"Universal like google:", SUBSCRIPTIONBROWSER_FIXEDTEXT2, "Static", WS_CHILD, 24, 22, 72, 12
	CONTROL	"", SUBSCRIPTIONBROWSER_SEARCHUNI, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 100, 22, 120, 12
	CONTROL	"Find", SUBSCRIPTIONBROWSER_FINDBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 244, 11, 53, 12
	CONTROL	"Filter Blocked Donations", SUBSCRIPTIONBROWSER_MBLOCKED, "Button", BS_LEFTTEXT|BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 248, 36, 96, 12
END

CLASS SubscriptionBrowser INHERIT DataWindowExtra 

	PROTECT oDCSC_AR1 AS FIXEDTEXT
	PROTECT oDCSC_OMS AS FIXEDTEXT
	PROTECT oDCmPerson AS SINGLELINEEDIT
	PROTECT oCCPersonButton AS PUSHBUTTON
	PROTECT oDCmAccount AS SINGLELINEEDIT
	PROTECT oCCAccButton AS PUSHBUTTON
	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCSearchUni AS SINGLELINEEDIT
	PROTECT oCCFindButton AS PUSHBUTTON
	PROTECT oDCmBlocked AS CHECKBOX
	PROTECT oSFSubscriptionBrowser_DETAIL AS SubscriptionBrowser_DETAIL

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  Export cPersonName,cAccountName as STRING
	Export mCLN,persid as STRING
	Export mREK as STRING
	EXPORT cType AS STRING
	EXPORT mtype as STRING
	Export nTerm:=1 as int
	export oSub as SQLSelectPagination
	export cFields,cFrom,cWhere,cOrder, cFilterWhere as string
	export dLastDDdate as date 
                                               
METHOD AccButton(lUnique ) CLASS SubscriptionBrowser
	LOCAL cFilter AS STRING
	Default(@lUnique,FALSE)
	IF cType=="STANDARD GIFTS" 
		cFilter:=MakeFilter(,,,1,false,{SDON})
	ELSEIF cType=="SUBSCRIPTIONS"
		cFilter:=MakeFilter(,,,0,false,{SDON})
	ELSEIF cType=="DONATIONS"
		cFilter:='('+MakeFilter({SDON},,,1,false,)+" or a.accid in (select accid from subscription where category='D'))"
	ELSE
		cFilter:=MakeFilter({SDON},,,1,true,)
	ENDIF	
	AccountSelect(self,AllTrim(oDCmAccount:TEXTValue ),"Account for "+cType,lUnique,cFilter)
	RETURN nil
 method ButtonClick(oControlEvent) class SubscriptionBrowser

     local oControl as Control

     oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)

     super:ButtonClick(oControlEvent)

     //Put your changes here

      IF oControl:Name=="MBLOCKED"

              self:FindButton()

       endif

 return nil
METHOD Close(oEvent) CLASS SubscriptionBrowser
*	
	//Put your changes here
SELF:oSFSubscriptionBrowser_DETAIL:Close()
RETURN SUPER:Close(oEvent)

METHOD DeleteButton( ) CLASS SubscriptionBrowser
	LOCAL oTextBox AS TextBox
	LOCAL mSubid, mtype as STRING
	local cLog as string
	LOCAL posit as int
	local lError as logic
	local oStmnt as SQLStatement
	local oSel as SqlSelect
	
	IF self:oSub:EOF.or.self:oSub:BOF
		(ErrorBox{,self:oLan:WGet("Select a")+space(1)+self:cType+space(1)+self:oLan:WGet("first")}):Show()
		RETURN
	ENDIF
	mSubid:=Str(self:oSub:subscribid,-1)
	if SepaEnabled .and. self:oSub:PayMethod='C' 
		if (oSel:=SqlSelect{"select cast(ifnull(firstinvoicedate,'0000-00-00') as char) as firstinvoicedate from subscription where subscribid="+mSubid,oConn}):reccount>0  
			if !Empty(oSel:firstinvoicedate).and.oSel:firstinvoicedate>'0000-00-00'
				(ErrorBox{,self:cType+Space(1)+self:oLan:WGet("can't be deleted because already sent to bank")}):Show()
				RETURN
			endif
		endif
	endif

	oTextBox := TextBox{ self, self:oLan:WGet("Delete")+Space(1)+self:cType,;
		self:oLan:WGet("Delete")+Space(1)+self:cType+Space(1)+self:oLan:WGet("for account")+Space(1)+self:oSub:AccountName+;
		+Space(1)+self:oLan:WGet("of person")+' '+self:oSub:personname+"?"}	
	oTextBox:Type := BUTTONYESNO + BOXICONQUESTIONMARK
	
	IF ( oTextBox:Show() == BOXREPLYYES )

		posit:=self:oSub:Recno 
		mtype:=self:oSub:category
		if mtype=="D" 
			cLog:=self:oLan:RGet("Deleted donation")+':'+; 
			"personid="+ ConS(self:oSub:personid)+;
				", personname="+self:oSub:personname+;
				", account="+ self:oSub:accountname
		endif
		oStmnt:=SQLStatement{"set autocommit=0",oConn}
		oStmnt:Execute()
		oStmnt:=SQLStatement{'lock tables `dueamount` write,`subscription` write',oConn} 
		oStmnt:Execute()

		oStmnt:=SQLStatement{"delete from subscription where subscribid="+mSubid,oConn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows>0
			IF mtype = "D" .or. mtype = "A"
				oStmnt:=SQLStatement{"delete from dueamount where subscribid="+mSubid,oConn}
				oStmnt:Execute()
				if !Empty(oStmnt:status) 
					lError:=true
				endif
			ENDIF
		else
			lError:=true
		endif

		if lError
			SQLStatement{"rollback",oConn}:Execute()
			SQLStatement{"unlock tables",oConn}:Execute() 
			SQLStatement{"set autocommit=1",oConn}:Execute()
			LogEvent(self,"Could not delete subscription"+"; error:"+oStmnt:ErrInfo:errormessage+CRLF+"statement:"+oStmnt:SQLString,"logerrors")
			ErrorBox{self,self:oLan:WGet("Could not delete")+' '+self:cType}:Show()
			return nil
		endif
		SQLStatement{"commit",oConn}:Execute()
		SQLStatement{"unlock tables",oConn}:Execute() 
		SQLStatement{"set autocommit=1",oConn}:Execute() 
		if !Empty(cLog)
			LogEvent(self,cLog)
		endif
		self:oSub:Execute()
		if posit>1
			self:GoTo(posit-1)
		else
			self:GoTop()
		ENDIF
		oSFSubscriptionBrowser_DETAIL:Browser:REFresh()
	ENDIF

	RETURN NIL
METHOD EditButton(lNewSub ) CLASS SubscriptionBrowser
	LOCAL oEditSubscriptionWindow AS EditSubscription
	LOCAL lNew AS LOGIC
	IF !IsNil(lNewSub)
		IF IsLogic(lNewSub)
			lNew:= lNewSub
		ENDIF
	ENDIF
	IF !lNew.and.(SELF:Server:EOF.or.SELF:Server:BOF)
		(ErrorBox{,self:oLan:WGet("Select a subscription first")}):Show()
		RETURN
	ENDIF
	
	oEditSubscriptionWindow := EditSubscription{ self:Owner,cType,self:Server,{lNew,self}  }
	oEditSubscriptionWindow:Show()

   	RETURN

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS SubscriptionBrowser
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "MPERSON".and.!AllTrim(oControl:Value)==AllTrim(cPersonName)
			IF Empty(oControl:Value) && leeg gemaakt?
				SELF:RegPerson()
			ELSE
				cPersonName:=AllTrim(oControl:Value)
				SELF:PersonButton()
			ENDIF
		ELSEIF oControl:Name == "MACCOUNT".and.!AllTrim(oControl:Value)==AllTrim(cAccountName)
			cAccountName:=AllTrim(oControl:Value)
			SELF:AccButton(TRUE)
		ENDIF
	ENDIF

	RETURN NIL

METHOD FilePrint() CLASS  SubscriptionBrowser
LOCAL aHeading as ARRAY
LOCAL nRow as int
LOCAL nPage as int
LOCAL oReport AS PrintDialog
*LOCAL oPers AS Person
*LOCAL oAcc AS Account
LOCAL oms3 as STRING 
local fsum as float
LOCAL cTab:=CHR(9) as STRING
local aDescription:={} as array
local oSel as SQLSelect
local cField:=self:cFields as string

IF self:cType=="STANDARD GIFTS"
	oms3:=oLan:RGet("Periodic gifts",,"!")
ELSEIF self:cType=="DONATIONS"
	oms3:=oLan:RGet("Donations",,"!")
ELSEIF self:cType=="SUBSCRIPTIONS"
	oms3:=oLan:RGet("Subscriptions",,"!")
endif
oReport := PrintDialog{self,oms3,,118,,"xls"}
oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
SELF:StatusMessage("Collecting data, moment please")
SELF:Pointer := Pointer{POINTERHOURGLASS}
AAdd(aDescription,self:oLan:RGet("subscription",,"!"))
AAdd(aDescription,self:oLan:RGet("donation",,"!"))
AAdd(aDescription,self:oLan:RGet("gift",,"!"))
cFields+=",invoiceid,bankaccnt"
oSel:= SqlSelect{"select "+cFields+" from "+self:cFrom+" where "+self:cWhere+ cFilterWhere +" order by "+self:cOrder,oConn}   


IF oReport:Extension#"xls"
	cTab:=Space(1)
	aHeading :={oms3,' '}
ELSE
	aHeading :={}
ENDIF


AAdd(aHeading, ;
self:oLan:RGet("account",20,"@!")+cTab+self:oLan:RGet("PERSON",30,"@!")+cTab+iif(CountryCode=="47",self:oLan:RGet("KID",13,"@!"),self:oLan:RGet("Bankaccount",20,"@!"))+cTab+self:oLan:RGet("amount",12,"@!","R")+;
+cTab+self:oLan:RGet("Frequency",9,"@!")+cTab+self:oLan:RGet("due date",12,"@!")+cTab+self:oLan:RGet("type",12,"@!")+cTab+self:oLan:RGet("blocked",7,"@!")) 
SetDecimalSep(Asc(DecSeparator))

do WHILE !oSel:EOF
	oReport:PrintLine(@nRow,@nPage,Pad(oSel:accountname,20)+cTab+Pad(oSel:PersonName,30)+cTab+iif(CountryCode=="47",Pad(oSel:INVOICEID,13),Pad(oSel:BANKACCNT,20))+;
	cTab+Str(oSel:amount,12,DecAantal)+cTab+PadR(GetFreq(oSel:term),9)+cTab+;
	PadC(DToC(iif(Empty(oSel:DueDate),null_date,oSel:DueDate)),12," ")+cTab+;
	iif(oSel:category=="A",aDescription[1],;
	iif(oSel:category=="D",aDescription[2],aDescription[3]))+cTab+;
	PadC(oSel:blockeddescr,7),aHeading) 
	fsum+= oSel:amount
	oSel:skip()
ENDDO
IF oReport:Extension#"xls"
	oReport:PrintLine(@nRow,@nPage,Replicate("-",111),aHeading)
	oReport:PrintLine(@nRow,@nPage,Space(66)+Str(fsum,12,DecAantal),aHeading)
endif
SetDecimalSep(Asc('.'))

*oPers:Close()
*oAcc:Close()
SELF:Pointer := Pointer{POINTERARROW}
oReport:prstart()
oReport:prstop()
RETURN SELF
METHOD FindButton( ) CLASS SubscriptionBrowser        

	local aKeyw:={} as array
	local AFields:={"a.accnumber","a.description","p.lastname","p.postalcode","s.bankaccnt","s.invoiceid"} as array
	local i,j as int                                            

	cFilterWhere:=""

	
	if !Empty(self:SearchUni)
// 		self:SearchUni:=Lower(AllTrim(self:SearchUni)) 
		aKeyw:=GetTokens(self:SearchUni)
		for i:=1 to Len(aKeyw)
			cFilterWhere+=" and ("
			for j:=1 to Len(AFields)
				cFilterWhere+=iif(j=1,""," or ")+AFields[j]+" like '%"+StrTran(aKeyw[i,1],"'","\'")+"%'"
			next
			
			cFilterWhere+=")"
		next
	endif               
	
	if ConL(self:mBlocked)== .T.
		cFilterWhere +=" and s.blocked = 1"  
	end if
	
	
	self:oSub:SQLString:="select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+ cFilterWhere +" order by "+self:cOrder 

	self:oSub:Execute()
	self:oSFSubscriptionBrowser_DETAIL:Browser:REFresh()
	self:GoTop()
	self:oDCFound:TEXTValue:=Str(self:oSub:Reccount,-1) 

RETURN NIL
             
ASSIGN FOUND(uValue) CLASS SubscriptionBrowser
self:FIELDPUT(#Found, uValue)
RETURN uValue


METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS SubscriptionBrowser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"SubscriptionBrowser",_GetInst()},iCtlID)

oDCSC_AR1 := FixedText{SELF,ResourceID{SUBSCRIPTIONBROWSER_SC_AR1,_GetInst()}}
oDCSC_AR1:HyperLabel := HyperLabel{#SC_AR1,_chr(38)+"Account:",NULL_STRING,NULL_STRING}

oDCSC_OMS := FixedText{SELF,ResourceID{SUBSCRIPTIONBROWSER_SC_OMS,_GetInst()}}
oDCSC_OMS:HyperLabel := HyperLabel{#SC_OMS,_chr(38)+"Person:",NULL_STRING,NULL_STRING}

oDCmPerson := SingleLineEdit{SELF,ResourceID{SUBSCRIPTIONBROWSER_MPERSON,_GetInst()}}
oDCmPerson:HyperLabel := HyperLabel{#mPerson,NULL_STRING,"The person, who is a subscriber","HELP_CLN"}
oDCmPerson:FieldSpec := MEMBERPERSON{}
oDCmPerson:FocusSelect := FSEL_HOME
oDCmPerson:TooltipText := "The person, who is a subscriber"

oCCPersonButton := PushButton{SELF,ResourceID{SUBSCRIPTIONBROWSER_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v","Browse in persons",NULL_STRING}
oCCPersonButton:TooltipText := "Browse in Persons"

oDCmAccount := SingleLineEdit{SELF,ResourceID{SUBSCRIPTIONBROWSER_MACCOUNT,_GetInst()}}
oDCmAccount:HyperLabel := HyperLabel{#mAccount,NULL_STRING,"The person, who is a subscriber",NULL_STRING}
oDCmAccount:FieldSpec := MEMBERACCOUNT{}
oDCmAccount:FocusSelect := FSEL_HOME
oDCmAccount:TooltipText := "The person, who is a subscriber"

oCCAccButton := PushButton{SELF,ResourceID{SUBSCRIPTIONBROWSER_ACCBUTTON,_GetInst()}}
oCCAccButton:HyperLabel := HyperLabel{#AccButton,"v","Browse in accounts",NULL_STRING}
oCCAccButton:TooltipText := "Browse in accounts"

oCCEditButton := PushButton{SELF,ResourceID{SUBSCRIPTIONBROWSER_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:OwnerAlignment := OA_PY

oCCNewButton := PushButton{SELF,ResourceID{SUBSCRIPTIONBROWSER_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}
oCCNewButton:OwnerAlignment := OA_PY

oCCDeleteButton := PushButton{SELF,ResourceID{SUBSCRIPTIONBROWSER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PY

oDCGroupBox1 := GroupBox{SELF,ResourceID{SUBSCRIPTIONBROWSER_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Subscriptions",NULL_STRING,NULL_STRING}
oDCGroupBox1:OwnerAlignment := OA_HEIGHT

oDCGroupBox2 := GroupBox{SELF,ResourceID{SUBSCRIPTIONBROWSER_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Select subscriptions of:",NULL_STRING,NULL_STRING}

oDCFound := FixedText{SELF,ResourceID{SUBSCRIPTIONBROWSER_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{SUBSCRIPTIONBROWSER_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{SUBSCRIPTIONBROWSER_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Universal like google:",NULL_STRING,NULL_STRING}

oDCSearchUni := SingleLineEdit{SELF,ResourceID{SUBSCRIPTIONBROWSER_SEARCHUNI,_GetInst()}}
oDCSearchUni:HyperLabel := HyperLabel{#SearchUni,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchUni:FocusSelect := FSEL_TRIM
oDCSearchUni:TooltipText := "Enter one or more (part of) key values"
oDCSearchUni:UseHLforToolTip := True

oCCFindButton := PushButton{SELF,ResourceID{SUBSCRIPTIONBROWSER_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Find",NULL_STRING,NULL_STRING}

oDCmBlocked := CheckBox{SELF,ResourceID{SUBSCRIPTIONBROWSER_MBLOCKED,_GetInst()}}
oDCmBlocked:HyperLabel := HyperLabel{#mBlocked,"Filter Blocked Donations",NULL_STRING,NULL_STRING}

SELF:Caption := "Filter Blocked Donations"
SELF:HyperLabel := HyperLabel{#SubscriptionBrowser,"Filter Blocked Donations",NULL_STRING,NULL_STRING}
SELF:Menu := WOMenu{}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True
SELF:EnableStatusBar(True)

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFSubscriptionBrowser_DETAIL := SubscriptionBrowser_DETAIL{SELF,SUBSCRIPTIONBROWSER_SUBSCRIPTIONBROWSER_DETAIL}
oSFSubscriptionBrowser_DETAIL:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mBlocked() CLASS SubscriptionBrowser
RETURN self:FIELDGET(#mBlocked)

ASSIGN mBlocked(uValue) CLASS SubscriptionBrowser
self:FIELDPUT(#mBlocked, uValue)
RETURN uValue
                                               
METHOD NewButton( ) CLASS SubscriptionBrowser
	self:persid:=self:mCLN
	SELF:EditButton(TRUE)
	RETURN

METHOD PersonButton( ) CLASS SubscriptionBrowser
LOCAL cValue := AllTrim(oDCmPerson:TEXTValue ) AS STRING
PersonSelect(SELF,cValue,FALSE)

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS SubscriptionBrowser
	//Put your PostInit additions here 
	local oSel as SQLSelect
self:SetTexts()
// 	SaveUse(self:cType+"BROWSER")
	IF self:cType=="STANDARD GIFTS"
		self:Caption:=self:oLan:WGet("Browse in Periodic Gifts")  
		self:oDCmBlocked:hide()
	ELSEIF cType=="DONATIONS"
		self:Caption:=self:oLan:WGet("Browse in Donations")
   	// determine last incasso batch:
   	oSel:=SqlSelect{'select cast(invoicedate as date) as invoicedate from dueamount d, subscription s where s.subscribid=d.subscribid and s.category="D" and paymethod="C" and d.amountrecvd>0.00 order by d.invoicedate desc limit 1',oConn}
   	oSel:Execute()
   	if oSel:RecCount=1
   		self:dLastDDdate:=oSel:invoicedate
   	endif
/*		SELF:oDCmAccount:Hide()
		SELF:oDCSC_AR1:Hide()
		SELF:oCCAccButton:Hide() */
	ELSEIF self:cType=="SUBSCRIPTIONS"
		self:Caption:=self:oLan:WGet("Browse in Subscriptions") 
		self:oDCmBlocked:hide()
	ENDIF
//    self:oDCFound:TextValue:=Str(ConI(SqlSelect{"select count(*) as totcount from subscription where category='"+self:mtype+"'",oConn}:totcount),-1)+' ('+self:oLan:WGet(" only 100 shown")+')'   

  	self:oDCFound:TextValue:=Str(self:oSub:RecCount,-1)

	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS SubscriptionBrowser
	//Put your PreInit additions here   
	// uExtra can contain extra filter
	local cFilter,myType as string 
	Default(@uExtra,null_string)
	if !empty(uExtra) .and. isstring(uExtra)
		myType:= AllTrim(uExtra)
		self:cType:= myType
		IF myType=="SUBSCRIPTIONS"
			self:mtype:="A"
		ELSEIF myType=="DONATIONS"
			self:mtype:="D"
		ELSEIF myType=="STANDARD GIFTS"
			self:mtype:="G"
		else
			// apparently filter
			cFilter:=uExtra
		ENDIF 
	endif
	
	self:cFields:=SQLFullName(0,"p")+" as personname,a.description as accountname,cast(s.begindate as date) as begindate,"+;
		"if(s.category='G','Periodic Gift',if(s.category='A','Subscription','Donation')) as catdesc,"+;
		"cast(s.duedate as date) as duedate,s.term,s.amount,s.category,s.subscribid,s.personid,s.accid, if(s.blocked=0,' ','X') as blockeddescr,invoiceid,bankaccnt,s.paymethod"
	self:cFrom:="person p, account a, subscription s" 
	self:cWhere:="a.accid=s.accid and p.persid=s.personid"+iif(Empty(self:mtype),''," and category='"+self:mtype+"'" 
	self:cOrder:="personname"
	self:oSub:=SQLSelectPagination{"select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+iif(Empty(cFilter),''," and "+cFilter)+" order by "+self:cOrder;
		,oConn} 
	// 	+" limit 100",oConn} 
	RETURN nil                 

ACCESS SearchUni() CLASS SubscriptionBrowser
RETURN self:FIELDGET(#SearchUni)              
ASSIGN SearchUni(uValue) CLASS SubscriptionBrowser
self:FIELDPUT(#SearchUni, uValue)
RETURN uValue

STATIC DEFINE SUBSCRIPTIONBROWSER_ACCBUTTON := 106 
STATIC DEFINE SUBSCRIPTIONBROWSER_DELETEBUTTON := 109 
RESOURCE SubscriptionBrowser_DETAIL DIALOGEX  50, 27, 416, 195
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

CLASS SubscriptionBrowser_DETAIL INHERIT DataWindowMine 

	PROTECT oDBPERSONNAME as DataColumn
	PROTECT oDBACCOUNTNAME as DataColumn
	PROTECT oDBBEGINDATE as DataColumn
	PROTECT oDBDUEDATE as DataColumn
	PROTECT oDBFREQ as DataColumn
	PROTECT oDBAMOUNT as DataColumn
	PROTECT oDBCATDESC as DataColumn
	PROTECT oDBBLOCKEDDESCR as DataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  protect oOwner as SubscriptionBrowser
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS SubscriptionBrowser_DETAIL 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"SubscriptionBrowser_DETAIL",_GetInst()},iCtlID)

SELF:Caption := "Blocked"
SELF:HyperLabel := HyperLabel{#SubscriptionBrowser_DETAIL,"Blocked",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:OwnerAlignment := OA_HEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBPERSONNAME := DataColumn{17}
oDBPERSONNAME:Width := 17
oDBPERSONNAME:HyperLabel := HyperLabel{#PersonName,"Person","Person",NULL_STRING} 
oDBPERSONNAME:Caption := "Person"
self:Browser:AddColumn(oDBPERSONNAME)

oDBACCOUNTNAME := DataColumn{20}
oDBACCOUNTNAME:Width := 20
oDBACCOUNTNAME:HyperLabel := HyperLabel{#AccountName,"Account","Number of an Account",NULL_STRING} 
oDBACCOUNTNAME:Caption := "Account"
self:Browser:AddColumn(oDBACCOUNTNAME)

oDBBEGINDATE := DataColumn{12}
oDBBEGINDATE:Width := 12
oDBBEGINDATE:HyperLabel := HyperLabel{#begindate,"Begin",NULL_STRING,NULL_STRING} 
oDBBEGINDATE:Caption := "Begin"
self:Browser:AddColumn(oDBBEGINDATE)

oDBDUEDATE := DataColumn{12}
oDBDUEDATE:Width := 12
oDBDUEDATE:HyperLabel := HyperLabel{#duedate,"Due",NULL_STRING,NULL_STRING} 
oDBDUEDATE:Caption := "Due"
self:Browser:AddColumn(oDBDUEDATE)

oDBFREQ := DataColumn{10}
oDBFREQ:Width := 10
oDBFREQ:HyperLabel := HyperLabel{#Freq,"Frequency",NULL_STRING,NULL_STRING} 
oDBFREQ:Caption := "Frequency"
oDBFreq:BlockOwner := self:server 
oDBFreq:Block := {|x|GetFreq(x:term)}
self:Browser:AddColumn(oDBFREQ)

oDBAMOUNT := DataColumn{Budget_AMOUNT{}}
oDBAMOUNT:Width := 10
oDBAMOUNT:HyperLabel := HyperLabel{#amount,"Amount",NULL_STRING,NULL_STRING} 
oDBAMOUNT:Caption := "Amount"
self:Browser:AddColumn(oDBAMOUNT)

oDBCATDESC := DataColumn{13}
oDBCATDESC:Width := 13
oDBCATDESC:HyperLabel := HyperLabel{#catdesc,"Type",NULL_STRING,NULL_STRING} 
oDBCATDESC:Caption := "Type"
self:Browser:AddColumn(oDBCATDESC)

oDBBLOCKEDDESCR := DataColumn{9}
oDBBLOCKEDDESCR:Width := 9
oDBBLOCKEDDESCR:HyperLabel := HyperLabel{#blockeddescr,"Blocked",NULL_STRING,NULL_STRING} 
oDBBLOCKEDDESCR:Caption := "Blocked"
oDBblockeddescr:TextColor := Color{255,0,0}
self:Browser:AddColumn(oDBBLOCKEDDESCR)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS SubscriptionBrowser_DETAIL
	//Put your PostInit additions here
self:SetTexts()

	self:Browser:SetStandardStyle(gbsReadOnly)
	if self:oOwner:mtype="G"
		self:Browser:RemoveColumn(self:odbduedate)
		self:Browser:RemoveColumn(self:oDBFREQ)
		self:Browser:removecolumn(self:oDBBLOCKEDDESCR)
	endif
	self:Browser:RemoveColumn(self:oDBCATDESC)
	
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS SubscriptionBrowser_DETAIL
	
	//Put your PreInit additions here 
	self:oOwner:=oWindow
	oWindow:use(oWindow:oSub)
	oWindow:Server:GoTop()
	RETURN NIL

STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_ACCOUNTNAME := 101 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_ACCOUNTNUMBER := 109 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_AMOUNT := 105 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_BEGINDATE := 102 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_BLOCKEDDESCR := 107 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_CATDESC := 106 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_DUEDATE := 103 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_FREQ := 104 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_lstchange := 114 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_MPERSON := 108 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_MTYPE := 106 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_PERSONNAME := 100 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_SC_accid := 101 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_SC_amount := 105 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_SC_lstchange := 106 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_SC_P04 := 102 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_SC_P06 := 103 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_SC_personid := 100 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_SC_term := 104 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_SC_type := 107 
STATIC DEFINE SUBSCRIPTIONBROWSER_EDITBUTTON := 107 
STATIC DEFINE SUBSCRIPTIONBROWSER_FINDBUTTON := 116 
STATIC DEFINE SUBSCRIPTIONBROWSER_FIXEDTEXT2 := 114 
STATIC DEFINE SUBSCRIPTIONBROWSER_FOUND := 112 
STATIC DEFINE SUBSCRIPTIONBROWSER_FOUNDTEXT := 113 
STATIC DEFINE SUBSCRIPTIONBROWSER_GROUPBOX1 := 110 
STATIC DEFINE SUBSCRIPTIONBROWSER_GROUPBOX2 := 111 
STATIC DEFINE SUBSCRIPTIONBROWSER_MACCOUNT := 105 
STATIC DEFINE SUBSCRIPTIONBROWSER_MBLOCKED := 117 
STATIC DEFINE SUBSCRIPTIONBROWSER_MPERSON := 103 
STATIC DEFINE SUBSCRIPTIONBROWSER_NEWBUTTON := 108 
STATIC DEFINE SUBSCRIPTIONBROWSER_PERSONBUTTON := 104 
STATIC DEFINE SUBSCRIPTIONBROWSER_SC_AR1 := 101 
STATIC DEFINE SUBSCRIPTIONBROWSER_SC_OMS := 102 
STATIC DEFINE SUBSCRIPTIONBROWSER_SEARCHUNI := 115 
STATIC DEFINE SUBSCRIPTIONBROWSER_SUBSCRIPTIONBROWSER_DETAIL := 100 
