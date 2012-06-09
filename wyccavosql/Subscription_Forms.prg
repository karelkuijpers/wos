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
	PROTECT oDCmterm AS SINGLELINEEDIT
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

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	instance mPerson 
	instance mAccount 
	instance mterm 
	instance mamount 
	instance mlstchange 
	instance mtype 
	instance mPayMethod 
	instance mInvoiceID 
	instance mBankAccnt 

    PROTECT cPersonName,cAccountName as STRING
	PROTECT mCLN,msubid as STRING
	PROTECT mRek,mAccNumber as STRING 
	protect mCurRek,mCurCLN as string 
	protect oCaller as object
*  	PROTECT lNew AS LOGIC
	PROTECT mCod AS STRING
	PROTECT nCurRec AS INT
	PROTECT cType, cHeading as STRING
RESOURCE EditSubscription DIALOGEX  37, 30, 271, 165
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Person:", EDITSUBSCRIPTION_SC_RLN, "Static", WS_CHILD, 6, 0, 30, 12
	CONTROL	"Account:", EDITSUBSCRIPTION_SC_P01N, "Static", WS_CHILD, 135, 0, 41, 12
	CONTROL	"Begin date:", EDITSUBSCRIPTION_SC_P04, "Static", WS_CHILD, 8, 44, 38, 12
	CONTROL	"Next due date:", EDITSUBSCRIPTION_SC_P06, "Static", WS_CHILD, 8, 59, 48, 12
	CONTROL	"Term in months:", EDITSUBSCRIPTION_SC_P07, "Static", WS_CHILD, 8, 73, 52, 13
	CONTROL	"Periodic amount:", EDITSUBSCRIPTION_SC_P08, "Static", WS_CHILD, 8, 88, 54, 12
	CONTROL	"Alter date:", EDITSUBSCRIPTION_SC_P13, "Static", WS_CHILD, 8, 140, 34, 13
	CONTROL	"", EDITSUBSCRIPTION_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 4, 11, 92, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITSUBSCRIPTION_PERSONBUTTON, "Button", WS_CHILD, 96, 11, 14, 13
	CONTROL	"", EDITSUBSCRIPTION_MACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 134, 11, 92, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITSUBSCRIPTION_ACCBUTTON, "Button", WS_CHILD, 224, 11, 15, 12
	CONTROL	"21-2-2011", EDITSUBSCRIPTION_MBEGINDATE, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 68, 40, 83, 14
	CONTROL	"21-2-2011", EDITSUBSCRIPTION_MDUEDATE, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 68, 55, 83, 13
	CONTROL	"", EDITSUBSCRIPTION_MTERM, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 68, 73, 83, 11, WS_EX_CLIENTEDGE
	CONTROL	"", EDITSUBSCRIPTION_MAMOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 68, 88, 83, 12, WS_EX_CLIENTEDGE
	CONTROL	"Invoice ID (KID):", EDITSUBSCRIPTION_INVOICETEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 8, 103, 53, 12
	CONTROL	"Giro Accept", EDITSUBSCRIPTION_RADIOBUTTONGIRO, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 183, 94, 53, 11
	CONTROL	"Direct Debit", EDITSUBSCRIPTION_RADIOBUTTONCOLLECTION, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 183, 108, 56, 12
	CONTROL	"Type:", EDITSUBSCRIPTION_MTYPE, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 178, 59, 67, 24
	CONTROL	"", EDITSUBSCRIPTION_MINVOICEID, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 68, 103, 83, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITSUBSCRIPTION_MBANKACCNT, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_VSCROLL, 68, 105, 83, 72
	CONTROL	"", EDITSUBSCRIPTION_MREFERENCE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 68, 119, 84, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITSUBSCRIPTION_MLSTCHANGE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 44, 140, 50, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITSUBSCRIPTION_TYPETEXT, "Static", WS_CHILD, 182, 66, 54, 12
	CONTROL	"Payment Method", EDITSUBSCRIPTION_MPAYMETHOD, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 176, 85, 66, 38
	CONTROL	"Bank account:", EDITSUBSCRIPTION_BANKTEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 8, 107, 53, 12
	CONTROL	"Cancel", EDITSUBSCRIPTION_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 152, 147, 53, 13
	CONTROL	"OK", EDITSUBSCRIPTION_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 208, 147, 53, 13
	CONTROL	"Reference:", EDITSUBSCRIPTION_SC_REF, "Static", WS_CHILD|NOT WS_VISIBLE, 8, 119, 53, 12
	CONTROL	"21-2-2011", EDITSUBSCRIPTION_MENDDATE, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 180, 40, 83, 14
	CONTROL	"End:", EDITSUBSCRIPTION_FIXEDTEXT11, "Static", WS_CHILD, 156, 44, 20, 12
END

METHOD AccButton(lUnique ) CLASS EditSubscription
	local cFilter as string
	Default(@lUnique,FALSE)
	IF cType=="STANDARD GIFTS" 
		cFilter:=MakeFilter(,,,1,false,{SDON})
	ELSEIF cType=="SUBSCRIPTIONS"
		cFilter:=MakeFilter(,,,0,false,{SDON})
	ELSEIF cType=="DONATIONS"
		cFilter:=MakeFilter({SDON},,,1,false,)
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
		 IF Empty(SELF:oDCmInvoiceID:TextValue)
		 	SELF:GenerateInvoiceID()
		 ENDIF
	ENDIF

	RETURN NIL

METHOD CancelButton( ) CLASS EditSubscription
SELF:EndWindow()
RETURN
METHOD Close(oEvent) CLASS EditSubscription
	SUPER:Close(oEvent)
	//Put your changes here
SELF:Destroy()	

RETURN NIL

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
oDCSC_P07:HyperLabel := HyperLabel{#SC_P07,"Term in months:",NULL_STRING,NULL_STRING}

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

oDCmterm := SingleLineEdit{SELF,ResourceID{EDITSUBSCRIPTION_MTERM,_GetInst()}}
oDCmterm:HyperLabel := HyperLabel{#mterm,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmterm:Picture := "9999"

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
oDCFixedText11:HyperLabel := HyperLabel{#FixedText11,"End:",NULL_STRING,NULL_STRING}

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
	LOCAL i, nPrevRec,m,d,y,me as int
	local mCurRek, mCurCLN as string 
	local oDue as SQLSelect
	local cStatement as string
	local oStmnt as SQLStatement 
	// 	IF !lNew
	// 		oSub:GoTo(nCurRec)
	// 		oSub:Skip(-1)
	// 		nPrevRec:=oSub:RecNo
	// 		oSub:GoTo(nCurRec)
	// 	ENDIF
	// 	IF ValidateControls( self, self:AControls )
	*Check obliged fields:
	IF Empty(mRek)
		(ErrorBox{,self:oLan:WGet("You have to enter an Account") }):Show()
		self:oDCmAccount:SetFocus()
		RETURN nil
	ELSEIF Empty(mCLN)
		(ErrorBox{self,self:oLan:WGet("You should enter a Person") }):Show()
		self:oDCmPerson:SetFocus()
		RETURN nil
	ELSEIF Empty(mamount)
		(ErrorBox{self,self:oLan:WGet("You have to enter a periodic amount") }):Show()
		self:oDCmPerson:SetFocus()
		RETURN nil
	ELSE
		if mType#'G'
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
			IF !Empty(self:oDCmbegindate:SelectedDate).and. self:oDCmbegindate:SelectedDate>self:oDCmEndDate:SelectedDate
				(ErrorBox{self:Owner,"Enter a end date later than the startdate"}):Show()
				self:oDCmEndDate:SetFocus()
				RETURN nil
			ENDIF
			IF Empty(self:mterm)
				(ErrorBox{,self:oLan:WGet("Term obliged in case of donor/subscription") }):Show()
				self:oDCmterm:SetFocus()
				RETURN nil
			ENDIF
			d:=Day(self:oDCmDueDate:SelectedDate)
			if d>28
				m:=Month(self:oDCmDueDate:SelectedDate) 
				y:=Year(self:oDCmDueDate:SelectedDate)
				for i:=self:mterm to 144 step self:mterm
					me:=MonthEnd((m+i)%12,y+(m+i-1)/12) 
					if d>me
						(ErrorBox{self:Owner,self:oLan:WGet("Enter a due date with a day before")+Space(1)+Str(me+1,-1)}):Show()
						self:oDCmDueDate:SetFocus()
						RETURN nil
					endif
				next
			endif					
		ENDIF
		IF !Empty(mInvoiceID)
			IF CountryCode=="47"
				if !IsMod10(AllTrim(mInvoiceID))
					(ErrorBox{,self:oLan:WGet("Invoice ID is not a modulus 10 number") }):Show()
					self:oDCmInvoiceID:SetFocus()
					RETURN nil
				ENDIF
			ENDIF
		ELSEIF self:mPayMethod="C"
			(ErrorBox{,self:oLan:WGet("Invoice ID is mandatory in case of Direct Debit") }):Show()
			self:oDCmInvoiceID:SetFocus()
			RETURN nil		
		ENDIF
		IF Empty(mBankAccnt)
			IF CountryCode="31" .and. self:mPayMethod="C"
				(ErrorBox{,self:oLan:WGet("Bank account is mandatory in case of Direct Debit") }):Show()
				self:oDCmBankAccnt:SetFocus()
				RETURN nil		
			ENDIF 
		else
			IF CountryCode="31"
				if Len(AllTrim(mBankAccnt))>7
					if !IsDutchBanknbr(AllTrim(mBankAccnt))
						(ErrorBox{,self:oLan:WGet("Bankaccount")+Space(1)+AllTrim(mBankAccnt)+Space(1)+self:oLan:WGet("is not correct")+"!!" }):Show()
						self:oDCmBankAccnt:SetFocus()
						RETURN nil		
					endif 
				endif
			endif
		endif
		
	ENDIF

	IF self:lNew
		* check if subscription allready exists: 
		if SQLSelect{"select subscribid from subscription where personid="+mCLN+" and accid="+mRek+" and category='"+self:mtype+"'",oConn}:reccount>0
			(ErrorBox{,self:oLan:WGet('Subscription of person already exists for this account')}):Show()
			RETURN nil
		ENDIF
	ENDIF
	// 		mCurRek:=oSub:accid 
	// 		mCurCLN:=oSub:personid   
	cStatement:=iif(self:lNew,"insert into","update")+" subscription set "+;
		"accid="+ self:mRek   +;
		",personid="+ self:mCLN +;
		",begindate='"+ SQLdate(iif(Empty(self:oDCmbegindate:SelectedDate),Today(),self:oDCmbegindate:SelectedDate))+"'"+;
		",enddate='"+ SQLdate(self:oDCmEndDate:SelectedDate)+"'"+;
		",duedate='"+ SQLdate(self:oDCmDueDate:SelectedDate)+"'"+;
		",term="+ Str(mterm,-1)+;
		",amount="+ Str(self:mamount,-1) +;
		",lstchange=NOW()"+;
		",category='"+ self:mtype+"'"+;
		",INVOICEID='"+ iif(IsNil(self:mInvoiceID),"",self:mInvoiceID)+"'"+;
		",REFERENCE='"+iif(IsNil(self:mReference),"",self:mReference)+"'"+;
		",PAYMETHOD='"+iif(IsNil(self:mPayMethod),"",self:mPayMethod)+"'"+; 
	",BANKACCNT='"+iif(IsNil(self:mBankAccnt),"",self:mBankAccnt)+"'"+;
		iif(self:lNew,''," where subscribid="+self:msubid)
	oStmnt:=SQLStatement{cStatement,oConn}
	oStmnt:Execute()
	//		// change corresponding due amounts:
	// 		if !self:lNew .and.(!self:mCurRek== self:mRek .or. !self:mCurCLN==self:mCLN) 
	// 			SQLStatement{"update dueamount set accid="+self:mRek+",persid="+self:mCLN+" where accid="+self:mCurRek+" and persid="+self:mCurCLN+" and AmountInvoice>AmountRecvd",oConn}:Execute() 
	// 		endif
	if Empty(oStmnt:status) .and. oStmnt:NumSuccessfulRows>0
		self:oCaller:oSub:Execute()
		if self:lNew
			self:oCaller:goTop()
		else
			self:oCaller:goto(self:nCurRec)
		endif
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
	LOCAL oSub,oSel as SQLSelect
self:SetTexts()
	self:lNew :=uExtra[1]
	self:oCaller:=uExtra[2]
	IF !self:lNew
		self:msubid:=Str(oServer:subscribid,-1) 
		self:nCurRec:=oServer:RecNo
		oSub:=SQLSelect{"select s.accid,s.personid,cast(s.begindate as date) as begindate, cast(s.duedate as date) as duedate,"+;
		"cast(s.enddate as date) as enddate,s.paymethod,s.bankaccnt,s.term,s.amount, cast(s.lstchange as date) as lstchange,s.category,s.invoiceid,s.reference,"+;
		SQLFullName(0,"p")+" as personname,a.description as accountname,a.accnumber,group_concat(b.banknumber separator ',') as bankaccs "+;
		"from subscription s, account a,person p "+; 
		+" left join personbank b on (b.persid=p.persid) " +;
		" where a.accid=s.accid and p.persid=s.personid and subscribid="+self:msubid+" group by s.personid",oConn}
	ENDIF 

   self:cType:=iCtlID
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
	ELSEIF cType=="SUBSCRIPTIONS"
		self:mtype:="A"
		if sEntity == "NOR"
			self:oDCInvoiceText:Show()
			self:oDCmInvoiceID:Show()
		endif

	ELSEIF cType=="DONATIONS"
		self:mtype:="D"
		if CountryCode=="47"
			self:oDCInvoiceText:Show()
			self:oDCmInvoiceID:Show()
		endif
	ELSE
	ENDIF	

	IF self:lNew
		self:cPersonName :=""
		self:cAccountName :=""
		self:oDCmbegindate:SelectedDate:=Today()
		self:oDCmDueDate:SelectedDate:=Today()
		if Day(Today())>28
			self:oDCmDueDate:SelectedDate:=stod(substr(dtos(today()),1,6)+'28')
		endif			
		self:oDCmEndDate:SelectedDate:=Today()+365*100
		self:mterm   := 1
  		self:mamount   := 0
		IF !self:cType=="STANDARD GIFTS"
	      self:oDCmPayMethod:Value:="C"
		endif
		IF self:mtype=="D".and.!Empty(SDON)
			oSel:=SQLSelect{"select accnumber,description from account where accid="+SDON,oConn}
			if oSel:RecCount>0
				self:cAccountName :=oSel:description 
				self:mAccount:= cAccountName
				self:mRek:=SDON
	      	self:mAccNumber:=oSel:ACCNUMBER
			ENDIF			
		ENDIF
    ELSE
		self:mRek := Str(oSub:accid,-1)                  
		self:cAccountName := oSub:AccountName
		self:mAccount:= cAccountName
		self:mAccNumber:=oSub:ACCNUMBER
		self:mCLN:=Str(oSub:personid,-1) 
		self:mCurRek:=self:mRek 
		self:mCurCLN:=self:mCLN
		self:cPersonName := oSub:PersonName
		self:mPerson:= cPersonName

		self:oDCmbegindate:SelectedDate := oSub:begindate
		IF Empty(oSub:DueDate)
			self:oDCmDueDate:SelectedDate := Today()+40000
		ELSE
			self:oDCmduedate:SelectedDate := oSub:duedate
		ENDIF
		self:oDCmEndDate:SelectedDate := iif(Empty(oSub:ENDDATE),Today()+365*100,oSub:ENDDATE)

		self:mterm := ConI(oSub:term)
		self:mamount := oSub:amount
		self:mlstchange := oSub:lstchange                 
		self:mtype := oSub:category
		IF Empty(oSub:PAYMETHOD)
	        self:oDCmPayMethod:Value:="G"
		ELSE
			self:oDCmPayMethod:Value:=oSub:PAYMETHOD
		ENDIF
		self:mInvoiceID:=oSub:INVOICEID
		self:mReference:=oSub:REFERENCE     
		IF !Empty(oSub:BankAccs)
			self:oDCmBankAccnt:FillUsing(Split(oSub:BankAccs,','))
			if !Empty(oSub:BANKACCNT)
				self:oDCmBankAccnt:CurrentItem:=oSub:BANKACCNT
			endif
		else
			self:oDCmBankAccnt:CurrentItemNo:=1
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

	RETURN nil
STATIC DEFINE EDITSUBSCRIPTION_ACCBUTTON := 110 
STATIC DEFINE EDITSUBSCRIPTION_BANKTEXT := 125 
STATIC DEFINE EDITSUBSCRIPTION_CANCELBUTTON := 126 
STATIC DEFINE EDITSUBSCRIPTION_FIXEDTEXT11 := 130 
STATIC DEFINE EDITSUBSCRIPTION_INVOICETEXT := 115 
STATIC DEFINE EDITSUBSCRIPTION_MACCOUNT := 109 
STATIC DEFINE EDITSUBSCRIPTION_MAMOUNT := 114 
STATIC DEFINE EDITSUBSCRIPTION_MBANKACCNT := 120 
STATIC DEFINE EDITSUBSCRIPTION_MBEGINDATE := 111 
STATIC DEFINE EDITSUBSCRIPTION_MDUEDATE := 112 
STATIC DEFINE EDITSUBSCRIPTION_MENDDATE := 129 
STATIC DEFINE EDITSUBSCRIPTION_MINVOICEID := 119 
STATIC DEFINE EDITSUBSCRIPTION_MLSTCHANGE := 122 
STATIC DEFINE EDITSUBSCRIPTION_MPAYMETHOD := 124 
STATIC DEFINE EDITSUBSCRIPTION_MPERSON := 107 
STATIC DEFINE EDITSUBSCRIPTION_MREFERENCE := 121 
STATIC DEFINE EDITSUBSCRIPTION_MTERM := 113 
STATIC DEFINE EDITSUBSCRIPTION_MTYPE := 118 
STATIC DEFINE EDITSUBSCRIPTION_OKBUTTON := 127 
STATIC DEFINE EDITSUBSCRIPTION_PERSONBUTTON := 108 
STATIC DEFINE EDITSUBSCRIPTION_RADIOBUTTONCOLLECTION := 117 
STATIC DEFINE EDITSUBSCRIPTION_RADIOBUTTONGIRO := 116 
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
STATIC DEFINE EDITSUBSCRIPTION_SC_REF := 128 
STATIC DEFINE EDITSUBSCRIPTION_SC_RLN := 100 
STATIC DEFINE EDITSUBSCRIPTION_SC_term := 104 
STATIC DEFINE EDITSUBSCRIPTION_TYPETEXT := 123 
Function ProlongateAll(oCall as Window ) as logic
	LOCAL mSubid as STRING, bed_toez as FLOAT
	LOCAL DueCount as int
	LOCAL rjaar,rmnd,rdag AS INT
	LOCAL mSeqnr as int
	LOCAL DueDate:=Today()+31, MinDate:=Today()-93 as date
	LOCAL oSub as SQLSelect
	local oStmnt as SQLStatement 
	local CurSubId as int, dDueDate as date 
	local cValuesDue,cValuesSub as string  // values to insert into the database


	* last end date should be after next due date
	* only donations and subscriptions 
// 	oSub:=SQLSelect{"select s.*,max(d.seqnr) as maxseqnbr from subscription s left join dueamount d "+; 
// 	"on (s.subscribid=d.subscribid and d.invoicedate=s.duedate) "+;
// 		"where (s.category='D' or s.category='A') and s.duedate between '"+SQLdate(MinDate)+"' and '"+SQLdate(DueDate)+"' and s.enddate>s.duedate " +;
// 		" group by s.subscribid,s.duedate",oConn}
	oSub:=SqlSelect{"select s.* from subscription s "+; 
		"where (s.category='D' or s.category='A') and s.duedate between '"+SQLdate(MinDate)+"' and '"+SQLdate(DueDate)+"' and s.enddate>s.duedate ",oConn}
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
		*	Calculate seqnr:
// 		CurSubId:=oSub:subscribid 
		dDueDate:=oSub:DueDate
// 		if	!Empty(oSub:maxseqnbr)
// 			mSeqnr:=oSub:maxseqnbr+1
// 		ELSE
			mSeqnr:=1
// 		ENDIF

		* Add new due amount:
		cValuesDue+=',('+mSubid+',"'+SQLdate(dDueDate)+'",'+Str(mSeqnr,-1)+','+Str(bed_toez,-1)+')' 
		* update date due with term within subscription: 
		cValuesSub+=',('+mSubid+')'
		oSub:skip()
	ENDDO
	if !Empty(cValuesDue)
		SQLStatement{"start transaction",oConn}:Execute()
		oStmnt:=SQLStatement{"insert ignore into dueamount (subscribid,invoicedate,seqnr,amountinvoice) values "+SubStr(cValuesDue,2),oConn}
		oStmnt:Execute()
// 		if Empty(oStmnt:Status) .and. oStmnt:NumSuccessfulRows>0
		if Empty(oStmnt:Status)
			* update date due with term within subscription:
			oStmnt:=SQLStatement{"insert into subscription (subscribid) values "+SubStr(cValuesSub,2)+;
			" on DUPLICATE KEY UPDATE duedate=adddate(duedate,INTERVAL term MONTH)",oConn} 
			oStmnt:Execute() 
			if !Empty(oStmnt:Status)
				LogEvent(,"could no produce direct debit dueamounts:"+oStmnt:ErrInfo:errormessage,"LogErrors")
				SQLStatement{"rollback",oConn}:Execute()
				return false				
			endif
		elseif !Empty(oStmnt:Status)
			LogEvent(,"could no produce direct debit dueamounts:"+oStmnt:ErrInfo:errormessage,"LogErrors")
			SQLStatement{"rollback",oConn}:Execute()
			return false				
		endif
		* remove old due amounts:
		oStmnt:=SQLStatement{"delete from dueamount where invoicedate<subdate(Now(),240)",oConn}
		oStmnt:Execute()
		SQLStatement{"commit",oConn}:Execute()
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
RESOURCE SubscriptionBrowser DIALOGEX  22, 20, 499, 254
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", SUBSCRIPTIONBROWSER_SUBSCRIPTIONBROWSER_DETAIL, "static", WS_CHILD|WS_BORDER, 21, 69, 395, 172
	CONTROL	"&Account:", SUBSCRIPTIONBROWSER_SC_AR1, "Static", WS_CHILD, 24, 31, 32, 12
	CONTROL	"&Person:", SUBSCRIPTIONBROWSER_SC_OMS, "Static", WS_CHILD, 24, 14, 28, 13
	CONTROL	"", SUBSCRIPTIONBROWSER_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 56, 14, 72, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", SUBSCRIPTIONBROWSER_PERSONBUTTON, "Button", WS_CHILD, 129, 15, 13, 12
	CONTROL	"", SUBSCRIPTIONBROWSER_MACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 56, 30, 73, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", SUBSCRIPTIONBROWSER_ACCBUTTON, "Button", WS_CHILD, 129, 30, 13, 13
	CONTROL	"Edit", SUBSCRIPTIONBROWSER_EDITBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 425, 91, 53, 13
	CONTROL	"New", SUBSCRIPTIONBROWSER_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 425, 130, 53, 12
	CONTROL	"Delete", SUBSCRIPTIONBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 424, 169, 53, 13
	CONTROL	"Subscriptions", SUBSCRIPTIONBROWSER_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 12, 57, 478, 191
	CONTROL	"Select subscriptions of:", SUBSCRIPTIONBROWSER_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 12, 3, 142, 50
	CONTROL	"", SUBSCRIPTIONBROWSER_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 215, 14, 47, 13
	CONTROL	"Found:", SUBSCRIPTIONBROWSER_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 180, 15, 27, 12
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
	PROTECT oSFSubscriptionBrowser_DETAIL AS SubscriptionBrowser_DETAIL

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  PROTECT cPersonName,cAccountName AS STRING
	PROTECT mCLN AS STRING
	PROTECT mREK AS STRING
	EXPORT cType AS STRING
	EXPORT mtype as STRING
	export oSub as SQLSelect
	export cFields,cFrom,cWhere,cOrder as string
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
METHOD Close(oEvent) CLASS SubscriptionBrowser
*	SUPER:Close(oEvent)
	//Put your changes here
SELF:oSFSubscriptionBrowser_DETAIL:Close()
SELF:oSFSubscriptionBrowser_DETAIL:Destroy()
SELF:Destroy()

RETURN NIL

METHOD DeleteButton( ) CLASS SubscriptionBrowser
	LOCAL oTextBox AS TextBox
	LOCAL mSubid, mtype as STRING
	LOCAL posit AS INT
	local oStmnt as SQLStatement
	
	IF self:oSub:EOF.or.self:oSub:BOF
		(ErrorBox{,self:oLan:WGet("Select a")+space(1)+self:cType+space(1)+self:oLan:WGet("first")}):Show()
		RETURN
	ENDIF
	oTextBox := TextBox{ self, self:oLan:WGet("Delete")+Space(1)+self:cType,;
		self:oLan:WGet("Delete")+Space(1)+self:cType+Space(1)+self:oLan:WGet("for account")+Space(1)+self:oSub:AccountName+;
		+Space(1)+self:oLan:WGet("of person")+self:oSub:personname+"?"}	
	oTextBox:Type := BUTTONYESNO + BOXICONQUESTIONMARK
	
	IF ( oTextBox:Show() == BOXREPLYYES )

		mSubid:=Str(self:oSub:subscribid,-1)
		posit:=oSub:Recno 
		mtype:=oSub:category
		oStmnt:=SQLStatement{"delete from subscription where subscribid="+mSubid,oConn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows>0
			self:oSub:Execute() 
			if posit>1
				self:GoTo(posit-1)
			else
				self:GoTop()
			endif
			oSFSubscriptionBrowser_DETAIL:Browser:REFresh()

			IF mtype = "D" .or. mtype = "A"
				oStmnt:=SQLStatement{"delete from dueamount where subscribid="+mSubid,oConn}
				oStmnt:Execute()
			ENDIF
		endif
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
oReport := PrintDialog{self,oms3,,111,,"xls"}
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
oSel:=SQLSelect{"select "+cFields+" from "+self:cFrom+" where "+self:cWhere+" order by "+self:cOrder,oConn} 

IF oReport:Extension#"xls"
	cTab:=Space(1)
	aHeading :={oms3,' '}
ELSE
	aHeading :={}
ENDIF

AAdd(aHeading, ;
self:oLan:RGet("account",20,"@!")+cTab+self:oLan:RGet("PERSON",30,"@!")+cTab+iif(CountryCode=="47",self:oLan:RGet("KID",13,"@!"),self:oLan:RGet("Bankaccount",13,"@!"))+cTab+self:oLan:RGet("amount",12,"@!","R")+;
+cTab+self:oLan:RGet("Period",6,"@!")+cTab+self:oLan:RGet("due date",12,"@!")+cTab+self:oLan:RGet("type",12,"@!") )
do WHILE !oSel:EOF
	oReport:PrintLine(@nRow,@nPage,Pad(oSel:accountname,20)+cTab+Pad(oSel:PersonName,30)+cTab+iif(CountryCode=="47",Pad(oSel:INVOICEID,13),Pad(oSel:BANKACCNT,13))+;
	cTab+Str(oSel:amount,12,DecAantal)+cTab+PadR(Str(oSel:term,-1),6)+cTab+;
	PadC(DToC(iif(Empty(oSel:DueDate),null_date,oSel:DueDate)),12," ")+cTab+;
	iif(oSel:category=="A",aDescription[1],;
	iif(oSel:category=="D",aDescription[2],aDescription[3])),aHeading) 
	fsum+= oSel:amount
	oSel:skip()
ENDDO
IF oReport:Extension#"xls"
	oReport:PrintLine(@nRow,@nPage,Replicate("-",111),aHeading)
	oReport:PrintLine(@nRow,@nPage,Space(66)+Str(fsum,12,DecAantal),aHeading)
endif

*oPers:Close()
*oAcc:Close()
SELF:Pointer := Pointer{POINTERARROW}
oReport:prstart()
oReport:prstop()
RETURN SELF
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

SELF:Caption := "Subscriptions, Donations and Standard Gifts"
SELF:HyperLabel := HyperLabel{#SubscriptionBrowser,"Subscriptions, Donations and Standard Gifts",NULL_STRING,NULL_STRING}
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

METHOD NewButton( ) CLASS SubscriptionBrowser
	SELF:EditButton(TRUE)
	RETURN

METHOD PersonButton( ) CLASS SubscriptionBrowser
LOCAL cValue := AllTrim(oDCmPerson:TEXTValue ) AS STRING
PersonSelect(SELF,cValue,FALSE)

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS SubscriptionBrowser
	//Put your PostInit additions here
self:SetTexts()
	IF cType=="STANDARD GIFTS"
		self:Caption:=self:oLan:WGet("Browse in Periodic Gifts") 
	ELSEIF cType=="DONATIONS"
		self:Caption:=self:oLan:WGet("Browse in Donations")
/*		SELF:oDCmAccount:Hide()
		SELF:oDCSC_AR1:Hide()
		SELF:oCCAccButton:Hide() */
	ELSEIF cType=="SUBSCRIPTIONS"
		self:Caption:=self:oLan:WGet("Browse in Subscriptions")
	ENDIF
   self:oDCFound:TextValue:=Str(ConI(SQLSelect{"select count(*) as totcount from "+self:cFrom+" where "+self:cWhere,oConn}:totcount),-1)

//   	self:oDCFound:TextValue:=Str(self:oSub:RecCount,-1)

	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS SubscriptionBrowser
	//Put your PreInit additions here   
	// uExtra can contain extra filter
	local cFilter as string 
	Default(@uExtra,null_string)
	self:cType:=uExtra
	IF self:cType="SUBSCRIPTIONS"
		self:mtype:="A"
	ELSEIF self:cType="DONATIONS"
		self:mtype:="D"
	ELSEIF self:cType="STANDARD GIFTS"
		self:mtype:="G"
	elseif !Empty(uExtra)
		// apparently filter
		cFilter:=uExtra
	ENDIF
 
	self:cFields:=SQLFullName(0,"p")+" as personname,a.description as accountname,cast(s.begindate as date) as begindate,"+;
	"if(s.category='G','Periodic Gift',if(s.category='A','Subscription','Donation')) as catdesc,"+;
	"cast(s.duedate as date) as duedate,s.term,s.amount,s.category,s.subscribid,s.personid,s.accid"
	self:cFrom:="person p, account a, subscription s" 
	self:cWhere:="a.accid=s.accid and p.persid=s.personid"+iif(Empty(self:mtype),''," and category='"+self:mtype+"'" 
	self:cOrder:="personname"
	self:oSub:=SQLSelect{"select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+iif(Empty(cFilter),''," and "+cFilter)+;
	" order by "+self:cOrder+" limit 200",oConn} 
	RETURN nil                 

STATIC DEFINE SUBSCRIPTIONBROWSER_ACCBUTTON := 106 
STATIC DEFINE SUBSCRIPTIONBROWSER_DELETEBUTTON := 109 
CLASS SubscriptionBrowser_DETAIL INHERIT DataWindowMine 

	PROTECT oDBPERSONNAME as DataColumn
	PROTECT oDBACCOUNTNAME as DataColumn
	PROTECT oDBBEGINDATE as DataColumn
	PROTECT oDBDUEDATE as DataColumn
	PROTECT oDBTERM as DataColumn
	PROTECT oDBAMOUNT as DataColumn
	PROTECT oDBCATDESC as DataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  protect oOwner as SubscriptionBrowser
RESOURCE SubscriptionBrowser_DETAIL DIALOGEX  29, 27, 382, 195
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS SubscriptionBrowser_DETAIL 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"SubscriptionBrowser_DETAIL",_GetInst()},iCtlID)

SELF:Caption := ""
SELF:HyperLabel := HyperLabel{#SubscriptionBrowser_DETAIL,NULL_STRING,NULL_STRING,NULL_STRING}
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

oDBACCOUNTNAME := DataColumn{24}
oDBACCOUNTNAME:Width := 24
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

oDBTERM := DataColumn{Subscription_term{}}
oDBTERM:Width := 7
oDBTERM:HyperLabel := HyperLabel{#term,"Term",NULL_STRING,NULL_STRING} 
oDBTERM:Caption := "Term"
self:Browser:AddColumn(oDBTERM)

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


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS SubscriptionBrowser_DETAIL
	//Put your PostInit additions here
self:SetTexts()

	self:Browser:SetStandardStyle(gbsReadOnly)
	if self:oOwner:mtype="G"
		self:Browser:RemoveColumn(self:odbduedate)
		self:Browser:RemoveColumn(self:oDBTERM)
	endif
	
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
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_CATDESC := 106 
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_DUEDATE := 103 
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
STATIC DEFINE SUBSCRIPTIONBROWSER_DETAIL_TERM := 104 
STATIC DEFINE SUBSCRIPTIONBROWSER_EDITBUTTON := 107 
STATIC DEFINE SUBSCRIPTIONBROWSER_FOUND := 112 
STATIC DEFINE SUBSCRIPTIONBROWSER_FOUNDTEXT := 113 
STATIC DEFINE SUBSCRIPTIONBROWSER_GROUPBOX1 := 110 
STATIC DEFINE SUBSCRIPTIONBROWSER_GROUPBOX2 := 111 
STATIC DEFINE SUBSCRIPTIONBROWSER_MACCOUNT := 105 
STATIC DEFINE SUBSCRIPTIONBROWSER_MPERSON := 103 
STATIC DEFINE SUBSCRIPTIONBROWSER_NEWBUTTON := 108 
STATIC DEFINE SUBSCRIPTIONBROWSER_PERSONBUTTON := 104 
STATIC DEFINE SUBSCRIPTIONBROWSER_SC_AR1 := 101 
STATIC DEFINE SUBSCRIPTIONBROWSER_SC_OMS := 102 
STATIC DEFINE SUBSCRIPTIONBROWSER_SUBSCRIPTIONBROWSER_DETAIL := 100 
