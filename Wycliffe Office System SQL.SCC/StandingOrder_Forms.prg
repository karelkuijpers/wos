STATIC DEFINE EDITPERIODIC_CANCELBUTTON := 109 
STATIC DEFINE EDITPERIODIC_DATLTSBOEK := 121 
STATIC DEFINE EDITPERIODIC_FIXEDTEXT10 := 120 
STATIC DEFINE EDITPERIODIC_FIXEDTEXT11 := 122 
STATIC DEFINE EDITPERIODIC_FIXEDTEXT13 := 119 
STATIC DEFINE EDITPERIODIC_FIXEDTEXT7 := 113 
STATIC DEFINE EDITPERIODIC_GIVERTEXT := 114 
STATIC DEFINE EDITPERIODIC_LstRecording := 121 
STATIC DEFINE EDITPERIODIC_MCURRENCY := 104 
STATIC DEFINE EDITPERIODIC_MDAY := 102 
STATIC DEFINE EDITPERIODIC_MDOCID := 105 
STATIC DEFINE EDITPERIODIC_MEDAT := 101 
STATIC DEFINE EDITPERIODIC_MIDAT := 100 
STATIC DEFINE EDITPERIODIC_MPERIOD := 103 
STATIC DEFINE EDITPERIODIC_MPERSON := 106 
STATIC DEFINE EDITPERIODIC_OKBUTTON := 108 
STATIC DEFINE EDITPERIODIC_PERSONBUTTON := 107 
STATIC DEFINE EDITPERIODIC_SC_BOEKDAG := 112 
STATIC DEFINE EDITPERIODIC_SC_BST := 115 
STATIC DEFINE EDITPERIODIC_SC_day := 112 
STATIC DEFINE EDITPERIODIC_SC_docid := 115 
STATIC DEFINE EDITPERIODIC_SC_EDAT := 111 
STATIC DEFINE EDITPERIODIC_SC_IDAT := 110 
STATIC DEFINE EDITPERIODIC_SC_TOTAL := 117 
STATIC DEFINE EDITPERIODIC_STORDERLINES := 116 
STATIC DEFINE EDITPERIODIC_STORDRID := 123 
STATIC DEFINE EDITPERIODIC_TOTALTEXT := 118 
CLASS EditStandingOrder INHERIT DataWindowExtra 

	PROTECT oDCmIDAT AS DATETIMEPICKER
	PROTECT oDCmEDAT AS DATETIMEPICKER
	PROTECT oDCmDAY AS SINGLELINEEDIT
	PROTECT oDCmPeriod AS SINGLELINEEDIT
	PROTECT oDCmCurrency AS COMBOBOX
	PROTECT oDCmDOCID AS SINGLELINEEDIT
	PROTECT oDCmPerson AS SINGLELINEEDIT
	PROTECT oCCPersonButton AS PUSHBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCSC_IDAT AS FIXEDTEXT
	PROTECT oDCSC_EDAT AS FIXEDTEXT
	PROTECT oDCSC_BOEKDAG AS FIXEDTEXT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCGiverText AS FIXEDTEXT
	PROTECT oDCSC_BST AS FIXEDTEXT
	PROTECT oDCSC_Total AS FIXEDTEXT
	PROTECT oDCTotalText AS FIXEDTEXT
	PROTECT oDCFixedText13 AS FIXEDTEXT
	PROTECT oDCFixedText10 AS FIXEDTEXT
	PROTECT oDCDATLTSBOEK AS SINGLELINEEDIT
	PROTECT oDCFixedText11 AS FIXEDTEXT
	PROTECT oDCSTORDRID AS SINGLELINEEDIT
	PROTECT oDCFixedText12 AS FIXEDTEXT
	PROTECT oDCLstChanged AS SINGLELINEEDIT
	PROTECT oDCFixedText14 AS FIXEDTEXT
	PROTECT oDCUserid AS SINGLELINEEDIT
	PROTECT oSFStOrderLines AS StOrderLines

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	*	PROTECT lNew AS LOGIC
	instance mday 
	instance mperiod 
	instance mdocid
	instance mPerson
	instance mBankAccnt
	instance mCurrency 
	protect 	oPers as SQLSelect
	PROTECT mFrom, cFromNbr,curStordid as STRING
	PROTECT mTO AS STRING
	PROTECT cFromName AS STRING
	PROTECT cToName as STRING
	protect mCLN, mCLNFrom, mCLNTo,cGiverName,mStordrid as STRING
	EXPORT cAccFilter as STRING
	PROTECT nCurRec AS INT
	EXPORT oCaller as OBJECT 
	protect oPersBank as SQLSelect 
	protect fTotal as float 
	Export lMemberGiver as logic
	export oStOrdr,oStOrdL as SQLSelect
	
	declare method UpdateStOrd,UpdStOrdLn,ValidateHelpLine, ValidateBooking
	
RESOURCE EditStandingOrder DIALOGEX  41, 37, 399, 234
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"18-12-2014", EDITSTANDINGORDER_MIDAT, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 80, 11, 74, 13
	CONTROL	"18-12-2014", EDITSTANDINGORDER_MEDAT, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 80, 29, 74, 14
	CONTROL	"", EDITSTANDINGORDER_MDAY, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 44, 36, 12, WS_EX_CLIENTEDGE
	CONTROL	"Period", EDITSTANDINGORDER_MPERIOD, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 59, 36, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITSTANDINGORDER_MCURRENCY, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 264, 81, 96, 111
	CONTROL	"", EDITSTANDINGORDER_MDOCID, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 81, 104, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITSTANDINGORDER_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 80, 99, 94, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITSTANDINGORDER_PERSONBUTTON, "Button", WS_CHILD|NOT WS_VISIBLE, 172, 99, 13, 13
	CONTROL	"OK", EDITSTANDINGORDER_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 284, 214, 53, 12
	CONTROL	"Cancel", EDITSTANDINGORDER_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 340, 214, 53, 12
	CONTROL	"Starting Date", EDITSTANDINGORDER_SC_IDAT, "Static", WS_CHILD, 12, 11, 49, 12
	CONTROL	"Ending date:", EDITSTANDINGORDER_SC_EDAT, "Static", WS_CHILD, 12, 25, 52, 13
	CONTROL	"Record day in month:", EDITSTANDINGORDER_SC_BOEKDAG, "Static", WS_CHILD, 12, 44, 68, 12
	CONTROL	"Period (months):", EDITSTANDINGORDER_FIXEDTEXT7, "Static", WS_CHILD, 12, 59, 64, 12
	CONTROL	"Giver:", EDITSTANDINGORDER_GIVERTEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 12, 99, 53, 13
	CONTROL	"Document id:", EDITSTANDINGORDER_SC_BST, "Static", WS_CHILD, 12, 81, 43, 12
	CONTROL	"", EDITSTANDINGORDER_STORDERLINES, "static", WS_CHILD|WS_BORDER, 4, 118, 388, 86
	CONTROL	"Total:", EDITSTANDINGORDER_SC_TOTAL, "Static", WS_CHILD, 4, 211, 22, 12
	CONTROL	"", EDITSTANDINGORDER_TOTALTEXT, "Static", WS_CHILD|WS_BORDER, 36, 210, 73, 12, WS_EX_CLIENTEDGE
	CONTROL	"Currency:", EDITSTANDINGORDER_FIXEDTEXT13, "Static", WS_CHILD, 216, 81, 43, 12
	CONTROL	"Last booked:", EDITSTANDINGORDER_FIXEDTEXT10, "Static", WS_CHILD, 296, 22, 53, 12
	CONTROL	"", EDITSTANDINGORDER_DATLTSBOEK, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 352, 22, 40, 12, WS_EX_CLIENTEDGE
	CONTROL	"Order#:", EDITSTANDINGORDER_FIXEDTEXT11, "Static", WS_CHILD, 296, 7, 53, 12
	CONTROL	"", EDITSTANDINGORDER_STORDRID, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 352, 7, 40, 12, WS_EX_CLIENTEDGE
	CONTROL	"Changed:", EDITSTANDINGORDER_FIXEDTEXT12, "Static", WS_CHILD, 296, 37, 54, 12
	CONTROL	"", EDITSTANDINGORDER_LSTCHANGED, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 352, 37, 40, 12, WS_EX_CLIENTEDGE
	CONTROL	"By:", EDITSTANDINGORDER_FIXEDTEXT14, "Static", WS_CHILD, 296, 52, 54, 12
	CONTROL	"", EDITSTANDINGORDER_USERID, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 352, 51, 40, 13, WS_EX_CLIENTEDGE
END

METHOD CancelButton( ) CLASS EditStandingOrder
SELF:ENDWindow()
RETURN NIL
METHOD Close(oEvent) CLASS EditStandingOrder
if !Empty(self:Server) .and. self:Server:used 
	self:Server:Close()
endif
	
	//Put your changes here

	RETURN SUPER:Close(oEvent)
ACCESS DATLTSBOEK() CLASS EditStandingOrder
RETURN SELF:FieldGet(#DATLTSBOEK)

ASSIGN DATLTSBOEK(uValue) CLASS EditStandingOrder
SELF:FieldPut(#DATLTSBOEK, uValue)
RETURN uValue

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS EditStandingOrder
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		if oControl:Name == "MPERSON".and.!AllTrim(oControl:VALUE)==AllTrim(cGiverName)
			cGiverName:=AllTrim(oControl:VALUE)
			self:PersonButton(true)

		ENDIF
	ENDIF
	RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditStandingOrder 
LOCAL DIM aBrushes[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditStandingOrder",_GetInst()},iCtlID)

aBrushes[1] := Brush{Color{COLORWHITE}}

oDCmIDAT := DateTimePicker{SELF,ResourceID{EDITSTANDINGORDER_MIDAT,_GetInst()}}
oDCmIDAT:HyperLabel := HyperLabel{#mIDAT,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmEDAT := DateTimePicker{SELF,ResourceID{EDITSTANDINGORDER_MEDAT,_GetInst()}}
oDCmEDAT:HyperLabel := HyperLabel{#mEDAT,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmDAY := SingleLineEdit{SELF,ResourceID{EDITSTANDINGORDER_MDAY,_GetInst()}}
oDCmDAY:HyperLabel := HyperLabel{#mDAY,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmDAY:Picture := "99"

oDCmPeriod := SingleLineEdit{SELF,ResourceID{EDITSTANDINGORDER_MPERIOD,_GetInst()}}
oDCmPeriod:HyperLabel := HyperLabel{#mPeriod,"Period",NULL_STRING,NULL_STRING}
oDCmPeriod:TooltipText := "Period in month after which the record will be repeated"
oDCmPeriod:Picture := "9999"

oDCmCurrency := combobox{SELF,ResourceID{EDITSTANDINGORDER_MCURRENCY,_GetInst()}}
oDCmCurrency:HyperLabel := HyperLabel{#mCurrency,NULL_STRING,"Currency of the amount",NULL_STRING}
oDCmCurrency:FillUsing(SQLSelect{"select united_ara,aed from currencylist",oConn}:getLookupTable(300,#UNITED_ARA,#AED))
oDCmCurrency:TooltipText := "Apply this currency to the debit and credit amounts below."

oDCmDOCID := SingleLineEdit{SELF,ResourceID{EDITSTANDINGORDER_MDOCID,_GetInst()}}
oDCmDOCID:HyperLabel := HyperLabel{#mDOCID,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmDOCID:FieldSpec := transaction_BST{}

oDCmPerson := SingleLineEdit{SELF,ResourceID{EDITSTANDINGORDER_MPERSON,_GetInst()}}
oDCmPerson:HyperLabel := HyperLabel{#mPerson,NULL_STRING,"The person, who is the member","HELP_CLN"}
oDCmPerson:FocusSelect := FSEL_HOME
oDCmPerson:FieldSpec := Person_NA1{}

oCCPersonButton := PushButton{SELF,ResourceID{EDITSTANDINGORDER_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v","Browse in persons",NULL_STRING}
oCCPersonButton:TooltipText := "Browse in Persons"

oCCOKButton := PushButton{SELF,ResourceID{EDITSTANDINGORDER_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}
oCCOKButton:OwnerAlignment := OA_PX_Y

oCCCancelButton := PushButton{SELF,ResourceID{EDITSTANDINGORDER_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}
oCCCancelButton:OwnerAlignment := OA_PX_Y

oDCSC_IDAT := FixedText{SELF,ResourceID{EDITSTANDINGORDER_SC_IDAT,_GetInst()}}
oDCSC_IDAT:HyperLabel := HyperLabel{#SC_IDAT,"Starting Date",NULL_STRING,NULL_STRING}

oDCSC_EDAT := FixedText{SELF,ResourceID{EDITSTANDINGORDER_SC_EDAT,_GetInst()}}
oDCSC_EDAT:HyperLabel := HyperLabel{#SC_EDAT,"Ending date:",NULL_STRING,NULL_STRING}

oDCSC_BOEKDAG := FixedText{SELF,ResourceID{EDITSTANDINGORDER_SC_BOEKDAG,_GetInst()}}
oDCSC_BOEKDAG:HyperLabel := HyperLabel{#SC_BOEKDAG,"Record day in month:",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{EDITSTANDINGORDER_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Period (months):",NULL_STRING,NULL_STRING}

oDCGiverText := FixedText{SELF,ResourceID{EDITSTANDINGORDER_GIVERTEXT,_GetInst()}}
oDCGiverText:HyperLabel := HyperLabel{#GiverText,"Giver:",NULL_STRING,NULL_STRING}

oDCSC_BST := FixedText{SELF,ResourceID{EDITSTANDINGORDER_SC_BST,_GetInst()}}
oDCSC_BST:HyperLabel := HyperLabel{#SC_BST,"Document id:",NULL_STRING,NULL_STRING}

oDCSC_Total := FixedText{SELF,ResourceID{EDITSTANDINGORDER_SC_TOTAL,_GetInst()}}
oDCSC_Total:HyperLabel := HyperLabel{#SC_Total,"Total:",NULL_STRING,NULL_STRING}
oDCSC_Total:OwnerAlignment := OA_Y

oDCTotalText := FixedText{SELF,ResourceID{EDITSTANDINGORDER_TOTALTEXT,_GetInst()}}
oDCTotalText:HyperLabel := HyperLabel{#TotalText,NULL_STRING,NULL_STRING,NULL_STRING}
oDCTotalText:TextColor := Color{COLORBLUE}
oDCTotalText:BackGround := aBrushes[1]
oDCTotalText:OwnerAlignment := OA_Y

oDCFixedText13 := FixedText{SELF,ResourceID{EDITSTANDINGORDER_FIXEDTEXT13,_GetInst()}}
oDCFixedText13:HyperLabel := HyperLabel{#FixedText13,"Currency:",NULL_STRING,NULL_STRING}

oDCFixedText10 := FixedText{SELF,ResourceID{EDITSTANDINGORDER_FIXEDTEXT10,_GetInst()}}
oDCFixedText10:HyperLabel := HyperLabel{#FixedText10,"Last booked:",NULL_STRING,NULL_STRING}

oDCDATLTSBOEK := SingleLineEdit{SELF,ResourceID{EDITSTANDINGORDER_DATLTSBOEK,_GetInst()}}
oDCDATLTSBOEK:HyperLabel := HyperLabel{#DATLTSBOEK,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText11 := FixedText{SELF,ResourceID{EDITSTANDINGORDER_FIXEDTEXT11,_GetInst()}}
oDCFixedText11:HyperLabel := HyperLabel{#FixedText11,"Order#:",NULL_STRING,NULL_STRING}

oDCSTORDRID := SingleLineEdit{SELF,ResourceID{EDITSTANDINGORDER_STORDRID,_GetInst()}}
oDCSTORDRID:FieldSpec := PeriodicRec_STORDRID{}
oDCSTORDRID:HyperLabel := HyperLabel{#STORDRID,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText12 := FixedText{SELF,ResourceID{EDITSTANDINGORDER_FIXEDTEXT12,_GetInst()}}
oDCFixedText12:HyperLabel := HyperLabel{#FixedText12,"Changed:",NULL_STRING,NULL_STRING}

oDCLstChanged := SingleLineEdit{SELF,ResourceID{EDITSTANDINGORDER_LSTCHANGED,_GetInst()}}
oDCLstChanged:HyperLabel := HyperLabel{#LstChanged,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText14 := FixedText{SELF,ResourceID{EDITSTANDINGORDER_FIXEDTEXT14,_GetInst()}}
oDCFixedText14:HyperLabel := HyperLabel{#FixedText14,"By:",NULL_STRING,NULL_STRING}

oDCUserid := SingleLineEdit{SELF,ResourceID{EDITSTANDINGORDER_USERID,_GetInst()}}
oDCUserid:HyperLabel := HyperLabel{#Userid,NULL_STRING,NULL_STRING,NULL_STRING}

SELF:Caption := "Edit Standing Order"
SELF:HyperLabel := HyperLabel{#EditStandingOrder,"Edit Standing Order",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:Menu := WOBrowserMENU{}
SELF:AllowServerClose := False

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
SELF:ViewAs(#FormView)

oSFStOrderLines := StOrderLines{SELF,EDITSTANDINGORDER_STORDERLINES}
oSFStOrderLines:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS LstChanged() CLASS EditStandingOrder
RETURN SELF:FieldGet(#LstChanged)

ASSIGN LstChanged(uValue) CLASS EditStandingOrder
SELF:FieldPut(#LstChanged, uValue)
RETURN uValue

ACCESS lstrecording() CLASS EditStandingOrder
RETURN self:FIELDGET(#LstRecording)

ASSIGN lstrecording(uValue) CLASS EditStandingOrder
self:FIELDPUT(#LstRecording, uValue)
RETURN uValue

ACCESS mCurrency() CLASS EditStandingOrder
RETURN SELF:FieldGet(#mCurrency)

ASSIGN mCurrency(uValue) CLASS EditStandingOrder
SELF:FieldPut(#mCurrency, uValue)
RETURN uValue

ACCESS mDAY() CLASS EditStandingOrder
RETURN SELF:FieldGet(#mDAY)

ASSIGN mDAY(uValue) CLASS EditStandingOrder
SELF:FieldPut(#mDAY, uValue)
RETURN uValue

ACCESS mDOCID() CLASS EditStandingOrder
RETURN SELF:FieldGet(#mDOCID)

ASSIGN mDOCID(uValue) CLASS EditStandingOrder
SELF:FieldPut(#mDOCID, uValue)
RETURN uValue

ACCESS mPeriod() CLASS EditStandingOrder
RETURN SELF:FieldGet(#mPeriod)

ASSIGN mPeriod(uValue) CLASS EditStandingOrder
SELF:FieldPut(#mPeriod, uValue)
RETURN uValue

ACCESS mPerson() CLASS EditStandingOrder
RETURN SELF:FieldGet(#mPerson)

ASSIGN mPerson(uValue) CLASS EditStandingOrder
SELF:FieldPut(#mPerson, uValue)
RETURN uValue

METHOD OKButton( ) CLASS EditStandingOrder
	Local nSeq:=1,nErr,nCH,nAG,nPF,nMG as int
	local cPersid as string
	local cStatement,cSep as string 
	local lError as logic
	local lChanged as logic
	local aGCAcc:={} as array  // array with assessment codes and account id's of lines 
	local oStmnt as SQLStatement
	LOCAL oStOrdLH:=self:oSFStOrderLines:server as StOrdLineHelp 
	IF self:ValidatePeriodic() .and. self:ValidateHelpLine(false,@nErr) .and. self:ValidateBooking(oStOrdLH)
		if Len(oStOrdLH:aMirror)=0 .or. AScan(oStOrdLH:aMirror,{|x|x[2]<>x[1]})=0
			if !lNew
				self:oCaller:DeleteButton()
			endif
			self:EndWindow()
			return
		endif
		if !Empty(self:mCLNFrom)
			cPersid:=self:mCLNFrom
		else
			cPersid:=self:mCLN
		endif 
		oStmnt:=SQLStatement{"set autocommit=0",oConn}
		oStmnt:execute()
		oStmnt:=SQLStatement{'lock tables `standingorder` write,`standingorderline` write',oConn} 
		oStmnt:execute()
		
		cStatement:=iif(self:lNew,"insert into","update")+" standingorder set "+;
			"idat='"+SQLdate(self:oDCmIDAT:SelectedDate)+"'"+;
			",edat='"+SQLdate(self:oDCmEDAT:SelectedDate)+"'"+;
			",`day`="+Str(self:mday,-1)+;
			",docid='"+self:mdocid+"'"+;
			",`period`="+Str(self:mperiod,-1)+;
			",currency='"+self:mCurrency+"'"+;
			",persid='"+Str(val(cPersid),-1)+"'"+;
			iif(lNew,",userid='"+LOGON_EMP_ID+"',lstchange=CURDATE()"," where stordrid="+ self:curStordid)
		// 		iif(!Empty(self:mCLN),",persid="+self:mCLN,iif(!Empty(self:mCLNFrom),",persid="+self:mCLNFrom,""))+;
		oStmnt:=SQLStatement{cStatement,oConn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows>0 .or.Empty(oStmnt:Status) 
			if oStmnt:NumSuccessfulRows>0
				lChanged:=true
			endif 
			// save Standing Order Lines: 
			oStOrdLH:GoTop() 
			if self:lNew 
				self:curStordid:= Str(ConI(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)),-1) 
				cStatement:="insert into standingorderline (stordrid,accountid,seqnr,deb,cre,descriptn,gc,reference,creditor,bankacct) values "
				do	while	!oStOrdLH:EoF
					if oStOrdLH:DEB <> oStOrdLH:CRE       // no empty lines
						cStatement+=cSep+"("+self:curStordid+","+Str(oStOrdLH:ACCOUNTID,-1)+","+Str(nSeq++,3,0)+","+Str(oStOrdLH:DEB,-1)+","+Str(oStOrdLH:CRE,-1)+","+;
							"'"+AllTrim(oStOrdLH:DESCRIPTN)+"','"+AllTrim(oStOrdLH:GC)+"','"+AllTrim(oStOrdLH:REFERENCE)+"',"+Str(oStOrdLH:CREDITOR,-1)+",'"+AllTrim(oStOrdLH:BANKACCT)+"')" 
						cSep:=','
					endif				
					oStOrdLH:Skip()
				enddo				
			else
				if !self:UpdateStOrd(@lChanged)
					lError:=true
				endif
			endif
		elseif Empty(oStmnt:Status)
			lError:=true
		endif
		if !lError .and. self:lNew
			oStmnt:SQLString:=cStatement
			oStmnt:Execute()
			if !Empty(oStmnt:Status) .or. oStmnt:NumSuccessfulRows<1
				lError:=true
			endif
		endif
		if !lError .and. !self:lNew .and. lChanged
			oStmnt:=SQLStatement{"update `standingorder` set `userid`='"+LOGON_EMP_ID+"',`lstchange`=curdate() where stordrid="+ self:curStordid,oConn}
			oStmnt:Execute()
		endif  
		if !lError
			SQLStatement{"commit",oConn}:execute()
			SQLStatement{"unlock tables",oConn}:execute()
			SQLStatement{"set autocommit=1",oConn}:execute()
			oCaller:ReFresh()
		else
			SQLStatement{"rollback",oConn}:execute()
			SQLStatement{"unlock tables",oConn}:execute()
			SQLStatement{"set autocommit=1",oConn}:execute()
			LogEvent(self,self:oLan:WGet("standingorder could not be saved")+":ID-"+self:curStordid,"LogErrors")
			ErrorBox{self,self:oLan:WGet("standingorder could not be saved")}:Show()
		endif
		self:EndWindow()
	ELSE
		RETURN 
	ENDIF
	
	
METHOD PersonButton(lUnique ) CLASS EditStandingOrder
	LOCAL cValue := AllTrim(oDCmPerson:TEXTValue ) as STRING
	Default(@lUnique,FALSE)
//	PersonSelect(self,cValue,lUnique,'persid=="'+mCLN+'".or.Empty(accid)',"Giver")
	PersonSelect(self,cValue,lUnique,'',"Giver")
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditStandingOrder
	//Put your PostInit additions here
	LOCAL oPer:=self:oStOrdr as SQLSelect
	local oOrdLnH:=self:Server as StOrdLineHelp 

	self:SetTexts()
	SaveUse(self)
	IF Empty(uExtra)
		lNew :=FALSE
	ELSE
		lNew:=TRUE
	ENDIF
	IF lNew
		self:oDCmIDAT:SetFocus()
		self:mperiod:=1
		self:mday:=1
		self:oDCmIDAT:SelectedDate:=Today()
		self:oDCmEDAT:SelectedDate:=Today()+40000 
		self:mCurrency:=sCurr
		self:oDCSTORDRID:TextValue :=''
		self:Append()
	ELSE
		self:nCurRec:=oPer:RecNo
		self:mperiod:=oPer:period

		self:mCurrency:=iif(Empty(oPer:Currency),sCurr,oPer:Currency)
		self:odcmIdat:SelectedDate := oPer:Idat
		self:mCLN:=Str(oPer:persid,-1) 
		self:oDCmEDAT:SelectedDate := oPer:Edat
		self:mday := oPer:day
		self:mdocid := oPer:docid 
		self:DATLTSBOEK:=oPer:lstrecording 
		self:LstChanged:=oPer:LstChange
		self:Userid:=oPer:Userid
		self:oStOrdL := SqlSelect{"Select l.*,a.accnumber,a.description as accountname,a.department as depid,"+SQLAccType()+" as accounttype,"+SQLIncExpFd()+" as incexpfd,m.co,m.persid as persid"+;
			" from standingorderline as l left join account as a on (a.accid=l.accountid) left join member m on (a.accid=m.accid or m.depid=a.department)"+;
			" left join department d on (d.depid=a.department)"+;
			" where l.stordrid="+self:curStordid+" order by seqnr",oConn}
		oOrdLnH:=self:oSFStOrderLines:Server
		oOrdLnH:aMirror:={}

		// 		oOrdLine:SetOrder("STORDLID")
		if self:oStOrdL:Reccount>0
			do while !self:oStOrdL:EOF 
				oOrdLnH:Append()
				oOrdLnH:DEB:=self:oStOrdL:DEB
				oOrdLnH:CRE:=self:oStOrdL:CRE
				oOrdLnH:GC:=self:oStOrdL:GC
				oOrdLnH:DESCRIPTN:=self:oStOrdL:DESCRIPTN 
				oOrdLnH:RECNBR:=self:oStOrdL:RecNo
				oOrdLnH:SEQNR:=self:oStOrdL:SEQNR 
				oOrdLnH:INCEXPFD:=self:oStOrdL:INCEXPFD
				if self:oStOrdL:ACCOUNTID=Val(sCRE) .and. self:oStOrdL:CRE > self:oStOrdL:DEB .and. !Empty(self:oStOrdL:CREDITOR)
					oOrdLnH:CREDTRNAM:= GetFullName(Str(self:oStOrdL:CREDITOR,-1)) 
					oOrdLnH:CREDITOR:=self:oStOrdL:CREDITOR
					oOrdLnH:BANKACCT:=self:oStOrdL:BANKACCT
				endif
				oOrdLnH:REFERENCE:=self:oStOrdL:REFERENCE
				oOrdLnH:ACCOUNTID:=self:oStOrdL:ACCOUNTID
				oOrdLnH:ACCOUNTNBR:=self:oStOrdL:ACCNUMBER
				oOrdLnH:ACCOUNTNAM:=self:oStOrdL:accountname
				oOrdLnH:CATEGORY:=self:oStOrdL:accounttype 
				oOrdLnH:DEPID:=self:oStOrdL:depid
				// save in mirror: // {{ [1]deb,[2[]cre, [3]category, [4]gc, [5]accountid, [6]recno, [7]account#,[8]creditor,[9]bankacct,[10]persid,[11]INCEXPFD},[12]depid}
				AAdd(oOrdLnH:aMirror,{oOrdLnH:DEB,oOrdLnH:CRE,oOrdLnH:CATEGORY,oOrdLnH:GC,oOrdLnH:ACCOUNTID,oOrdLnH:RECNBR,oOrdLnH:ACCOUNTNBR,;
				Str(oOrdLnH:CREDITOR,-1),oOrdLnH:BANKACCT,iif(Empty(self:oStOrdL:persid),"",Str(self:oStOrdL:persid,-1)),oOrdLnH:INCEXPFD,oOrdLnH:DEPID})
				self:oStOrdL:Skip()				
			enddo
			self:Totalise()
		endif
		self:ShowAssGift()
		self:oSFStOrderLines:AddCredtr()
		self:oSFStOrderLines:GoTop()
		self:oDCmIDAT:SetFocus() 
	ENDIF
	RETURN NIL	
method PreInit(oWindow,iCtlID,oServer,uExtra) class EditStandingOrder
	//Put your PreInit additions here
   self:lNew:=uExtra
	if !self:lNew 
		self:curStordid:=ConS(oServer:stordrid)
		self:oStOrdr:=SqlSelect{"select s.stordrid,s.persid,s.`day`,s.`period`,cast(s.idat as date) as idat,cast(s.edat as date) as edat,cast(s.lstrecording as date) as lstrecording,s.docid,"+;
		"s.currency,cast(s.lstchange as date) as lstchange,s.userid from standingorder s where s.stordrid="+self:curStordid,oConn} 
		self:oStOrdr:Execute()
	endif
	return nil
ACCESS STORDRID() CLASS EditStandingOrder
RETURN SELF:FieldGet(#STORDRID)

ASSIGN STORDRID(uValue) CLASS EditStandingOrder
SELF:FieldPut(#STORDRID, uValue)
RETURN uValue

ACCESS Userid() CLASS EditStandingOrder
RETURN SELF:FieldGet(#Userid)

ASSIGN Userid(uValue) CLASS EditStandingOrder
SELF:FieldPut(#Userid, uValue)
RETURN uValue

STATIC DEFINE EDITSTANDINGORDER_CANCELBUTTON := 109 
STATIC DEFINE EDITSTANDINGORDER_DATLTSBOEK := 121 
STATIC DEFINE EDITSTANDINGORDER_FIXEDTEXT10 := 120 
STATIC DEFINE EDITSTANDINGORDER_FIXEDTEXT11 := 122 
STATIC DEFINE EDITSTANDINGORDER_FIXEDTEXT12 := 124 
STATIC DEFINE EDITSTANDINGORDER_FIXEDTEXT13 := 119 
STATIC DEFINE EDITSTANDINGORDER_FIXEDTEXT14 := 126 
STATIC DEFINE EDITSTANDINGORDER_FIXEDTEXT7 := 113 
STATIC DEFINE EDITSTANDINGORDER_GIVERTEXT := 114 
STATIC DEFINE EDITSTANDINGORDER_LSTCHANGED := 125 
STATIC DEFINE EDITSTANDINGORDER_MCURRENCY := 104 
STATIC DEFINE EDITSTANDINGORDER_MDAY := 102 
STATIC DEFINE EDITSTANDINGORDER_MDOCID := 105 
STATIC DEFINE EDITSTANDINGORDER_MEDAT := 101 
STATIC DEFINE EDITSTANDINGORDER_MIDAT := 100 
STATIC DEFINE EDITSTANDINGORDER_MPERIOD := 103 
STATIC DEFINE EDITSTANDINGORDER_MPERSON := 106 
STATIC DEFINE EDITSTANDINGORDER_OKBUTTON := 108 
STATIC DEFINE EDITSTANDINGORDER_PERSONBUTTON := 107 
STATIC DEFINE EDITSTANDINGORDER_SC_BOEKDAG := 112 
STATIC DEFINE EDITSTANDINGORDER_SC_BST := 115 
STATIC DEFINE EDITSTANDINGORDER_SC_EDAT := 111 
STATIC DEFINE EDITSTANDINGORDER_SC_IDAT := 110 
STATIC DEFINE EDITSTANDINGORDER_SC_TOTAL := 117 
STATIC DEFINE EDITSTANDINGORDER_STORDERLINES := 116 
STATIC DEFINE EDITSTANDINGORDER_STORDRID := 123 
STATIC DEFINE EDITSTANDINGORDER_TOTALTEXT := 118 
STATIC DEFINE EDITSTANDINGORDER_USERID := 127 
STATIC DEFINE PERIODICBROWSER_ACCBUTTONFROM := 109 
STATIC DEFINE PERIODICBROWSER_CANCELBUTTON := 104 
STATIC DEFINE PERIODICBROWSER_CANCELBUTTON5 := 102 
STATIC DEFINE PERIODICBROWSER_DELETEBUTTON := 103 
STATIC DEFINE PERIODICBROWSER_DELETEBUTTON5 := 101 
STATIC DEFINE PERIODICBROWSER_DETAIL_ACCOUNTNAME := 105 
STATIC DEFINE PERIODICBROWSER_DETAIL_BESTEMMINGSACC := 106 
STATIC DEFINE PERIODICBROWSER_DETAIL_CRE := 114 
STATIC DEFINE PERIODICBROWSER_DETAIL_DAY := 109 
STATIC DEFINE PERIODICBROWSER_DETAIL_DEB := 113 
STATIC DEFINE PERIODICBROWSER_DETAIL_DESCRIPTN := 110 
STATIC DEFINE PERIODICBROWSER_DETAIL_DOCID := 116 
STATIC DEFINE PERIODICBROWSER_DETAIL_EDAT := 108 
STATIC DEFINE PERIODICBROWSER_DETAIL_FROMACCOUNT := 105 
STATIC DEFINE PERIODICBROWSER_DETAIL_IDAT := 107 
STATIC DEFINE PERIODICBROWSER_DETAIL_LSTRECORDING := 111 
STATIC DEFINE PERIODICBROWSER_DETAIL_PERIOD := 112 
STATIC DEFINE PERIODICBROWSER_DETAIL_SC_BESTEMMING := 101 
STATIC DEFINE PERIODICBROWSER_DETAIL_SC_BOEKDAG := 104 
STATIC DEFINE PERIODICBROWSER_DETAIL_SC_day := 104 
STATIC DEFINE PERIODICBROWSER_DETAIL_SC_EDAT := 103 
STATIC DEFINE PERIODICBROWSER_DETAIL_SC_IDAT := 102 
STATIC DEFINE PERIODICBROWSER_DETAIL_SC_REK := 100 
STATIC DEFINE PERIODICBROWSER_DETAIL_STORDRID := 115 
STATIC DEFINE PERIODICBROWSER_EDITBUTTON := 101 
STATIC DEFINE PERIODICBROWSER_FINDBUTTON := 113 
STATIC DEFINE PERIODICBROWSER_FIXEDTEXT4 := 110 
STATIC DEFINE PERIODICBROWSER_FIXEDTEXT5 := 115 
STATIC DEFINE PERIODICBROWSER_FOUND := 111 
STATIC DEFINE PERIODICBROWSER_FOUNDTEXT := 112 
STATIC DEFINE PERIODICBROWSER_GROUPBOX1 := 107 
STATIC DEFINE PERIODICBROWSER_GROUPBOX2 := 116 
STATIC DEFINE PERIODICBROWSER_NEWBUTTON := 102 
STATIC DEFINE PERIODICBROWSER_NEWBUTTON5 := 100 
STATIC DEFINE PERIODICBROWSER_PERIODICBROWSER_DETAIL := 100 
STATIC DEFINE PERIODICBROWSER_SC_REK := 105 
STATIC DEFINE PERIODICBROWSER_SC_REK5 := 103 
STATIC DEFINE PERIODICBROWSER_SEARCHREK := 108 
STATIC DEFINE PERIODICBROWSER_SEARCHREK6 := 104 
STATIC DEFINE PERIODICBROWSER_SEARCHREKOLD := 106 
STATIC DEFINE PERIODICBROWSER_SEARCHUNI := 114 
STATIC DEFINE PROGRESSPER_CANCELBUTTON := 100 
CLASS StandingOrderBrowser INHERIT DataWindowExtra 

	PROTECT oDBSEARCHREKOLD as DataColumn
	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCSC_REK AS FIXEDTEXT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCSearchRek AS SINGLELINEEDIT
	PROTECT oCCAccButtonFrom AS PUSHBUTTON
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oCCFindButton AS PUSHBUTTON
	PROTECT oDCSearchUni AS SINGLELINEEDIT
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oSFPeriodicBrowser_DETAIL as StandingOrderBrowser_Detail

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT cAccFilter,cAccountNameFrom,cAccountNameTo as STRING
	EXPORT oAcc, oAccDest, oAccSearch as SQLSelect
	export oStOrd as SQLSelectPagination
	export cWhere,cOrder,cFields,cFrom as string 
	protect cAccId as string 
	protect aFields:={} as array
RESOURCE StandingOrderBrowser DIALOGEX  10, 11, 561, 262
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", STANDINGORDERBROWSER_PERIODICBROWSER_DETAIL, "static", WS_CHILD|WS_BORDER, 12, 51, 461, 197
	CONTROL	"Edit", STANDINGORDERBROWSER_EDITBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 488, 70, 53, 12
	CONTROL	"New", STANDINGORDERBROWSER_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 488, 108, 53, 13
	CONTROL	"Delete", STANDINGORDERBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 488, 147, 53, 12
	CONTROL	"Cancel", STANDINGORDERBROWSER_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 488, 185, 52, 13
	CONTROL	"Account:", STANDINGORDERBROWSER_SC_REK, "Static", WS_CHILD, 12, 8, 40, 12
	CONTROL	"Periodic amounts", STANDINGORDERBROWSER_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 40, 544, 217
	CONTROL	"", STANDINGORDERBROWSER_SEARCHREK, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 60, 7, 72, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", STANDINGORDERBROWSER_ACCBUTTONFROM, "Button", WS_CHILD, 132, 7, 16, 12
	CONTROL	"lines", STANDINGORDERBROWSER_FIXEDTEXT4, "Static", SS_CENTERIMAGE|WS_CHILD, 328, 3, 53, 13
	CONTROL	"", STANDINGORDERBROWSER_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 288, 3, 36, 13
	CONTROL	"Found:", STANDINGORDERBROWSER_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 260, 3, 27, 13
	CONTROL	"Find", STANDINGORDERBROWSER_FINDBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 192, 3, 53, 13
	CONTROL	"", STANDINGORDERBROWSER_SEARCHUNI, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 60, 22, 116, 12
	CONTROL	"Universal:", STANDINGORDERBROWSER_FIXEDTEXT5, "Static", WS_CHILD, 12, 22, 44, 12
	CONTROL	"Search", STANDINGORDERBROWSER_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 0, 184, 40
END

METHOD AccButtonFrom(lUnique ) CLASS StandingOrderBrowser 
	Default(@lUnique,FALSE)	
	AccountSelect(self,AllTrim(self:oDCSearchRek:TEXTValue ),"Account from",lUnique,"a.active=1")

RETURN NIL
METHOD AccButtonTo(lUnique ) CLASS StandingOrderBrowser 
	Default(@lUnique,FALSE)	
	AccountSelect(self,AllTrim(self:oDCSearchRekTo:TEXTValue ),"Account to",lUnique,"a.active=1")

RETURN NIL
METHOD CancelButton( ) CLASS StandingOrderBrowser
SELF:ENDwindow()
RETURN NIL
METHOD Close(oEvent) CLASS StandingOrderBrowser
*	SUPER:Close(oEvent)
	//Put your changes here
SELF:oSFPeriodicBrowser_DETAIL:Close()
RETURN NIL
METHOD DeleteButton( ) CLASS StandingOrderBrowser
	LOCAL oTextBox as TextBox 
	local curStorId as string
	local oStmnt as SQLStatement
	IF SELF:Server:EOF.or.SELF:Server:BOF
		(Errorbox{,"Select a periodic amount first"}):Show()
		RETURN
	ENDIF
	curStorId:=Str(self:oStOrd:STORDRID,-1)
	oTextBox := TextBox{ self, self:oLan:WGet("Delete Standing Order"),;
		self:oLan:WGet("Delete Order with number")+Space(1)+curStorId+Space(1)+self:oLan:WGet("with all its lines")+"?" }	
	oTextBox:Type := BUTTONYESNO + BOXICONQUESTIONMARK
	
	IF ( oTextBox:Show() == BOXREPLYYES )
		SQLStatement{"start transaction",oConn}:Execute()
		oStmnt:=SQLStatement{"delete from standingorderline where stordrid="+curStorId,oConn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows>0
			oStmnt:=SQLStatement{"delete from standingorder where stordrid="+curStorId,oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows>0
				SQLStatement{"commit",oConn}:Execute()
				self:Refresh()
				return nil
			endif
		endif
		SQLStatement{"rollback",oConn}:Execute()
		Errorbox{,self:oLan:WGet("Standing order could not be removed")}:show()
	ENDIF

	RETURN NIL
METHOD EditButton(lNew) CLASS StandingOrderBrowser
	LOCAL oEditPeriodicWindow as EditStandingOrder
	Default(@lNew,FALSE)
	IF !lNew.and.(SELF:Server:EOF.or.SELF:Server:BOF)
		(ErrorBox{,"Select a standing order first"}):Show()
		RETURN
	ENDIF
	
	oEditPeriodicWindow := EditStandingOrder{ self:Owner,,self:oStOrd,lNew  }
	oEditPeriodicWindow:cAccFilter:=self:cAccFilter
// 	oEditPeriodicWindow:oCaller:=self:oSFPeriodicBrowser_DETAIL:Browser
	oEditPeriodicWindow:oCaller:=self
	oEditPeriodicWindow:Show()

	RETURN NIL
method EditFocusChange(oEditFocusChangeEvent) class StandingOrderBrowser
	local oControl as Control
	local lGotFocus as logic
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	super:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF Upper(oControl:Name) == "SEARCHREK".and.!IsNil(oControl:VALUE)
			if !AllTrim(oControl:VALUE)==AllTrim(self:cAccountNameFrom)
				cAccountNameFrom:=AllTrim(oControl:VALUE)
				self:AccButtonFrom(true)
			endif
		ELSEif Upper(oControl:Name) == "SEARCHREKTO".and.!IsNil(oControl:VALUE).and.!AllTrim(oControl:VALUE)==AllTrim(self:cAccountNameTo)
			cAccountNameTo:=AllTrim(oControl:VALUE)
			self:AccButtonTo(true)

		ENDIF
	ENDIF

	RETURN nil
	return NIL
METHOD FilePrint() CLASS  StandingOrderBrowser
LOCAL aHeading as ARRAY
LOCAL nRij AS INT
LOCAL nBlad AS INT
LOCAL oReport AS PrintDialog
LOCAL cTab:=CHR(9) as STRING

oReport := PrintDialog{self,self:oLan:WGet("Standing Orders"),,158,,"xls"}
oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
self:oStOrd:SuspendNotification()
self:oStOrd:goTop()
IF oReport:Extension#"xls"
	cTab:=Space(1)
	aHeading :={oLan:RGet("Standing Orders",,"@!")}
ELSE
	aHeading :={}
ENDIF

AAdd(aHeading,;
oLan:RGet("Order#",6,"@!")+cTab+oLan:RGet("account",21,"@!")+cTab+oLan:RGet("STARTDATE",10,"@!")+cTab;
+oLan:RGet("RECORDDAY",9,"@!")+cTab+oLan:RGet("PERIOD",6,"@!")+cTab+oLan:RGet("Deb",11,"@!","R")+cTab+oLan:RGet("Cre",11,"@!","R")+cTab+oLan:RGet("ENDDATE",10,"@!")+cTab+oLan:RGet("LST BOOKED",10,"@!")+cTab;
+oLan:RGet("Changed",10,'@!')+cTab+oLan:RGet("Employee",8,'@!')+cTab+oLan:RGet("DESCRIPTION",,"@!")) 
self:oStOrd:goTop()
do WHILE !self:oStOrd:EOF
	oReport:PrintLine(@nRij,@nBlad,Str(self:oStOrd:STORDRID,6,0)+cTab+ Pad(Transform(self:oStOrd:ACCNUMBER,"")+Space(1)+Transform(self:oStOrd:accountname,""),21)+cTab+;
	DToC(self:oStOrd:IDAT)+cTab+PadC(Transform(self:oStOrd:day,'999'),9)+cTab+PadC(Transform(self:oStOrd:period,'999'),6)+cTab+;
	Str(self:oStOrd:deb,11,2)+cTab+Str(self:oStOrd:cre,11,2)+cTab+DToC(iif(Empty(self:oStOrd:edat),null_date,self:oStOrd:edat))+cTab+;
	DToC(iif(Empty(self:oStOrd:lstrecording),null_date,self:oStOrd:lstrecording))+;
	cTab+DToC(iif(Empty(self:oStOrd:lstchange),null_date,self:oStOrd:lstchange))+cTab+PadL(self:oStOrd:userid,8)+cTab+ self:oStOrd:DESCRIPTN,aHeading,0)
	self:oStOrd:skip()
ENDDO
oReport:prstart()
oReport:prstop()
self:oStOrd:ResetNotification()
RETURN NIL
METHOD FindButton( ) CLASS StandingOrderBrowser
local i,j as int 
	local aKeyw:={} as array 
	if !Empty(self:cAccId)
		self:cWhere:='accountid='+self:cAccId 
	else
		self:cWhere:=""
	endif
	if !Empty(self:SearchUni)
// 		self:cWhere+=iif(Empty(self:cWhere),""," and ")
		self:SearchUni:=Lower(AllTrim(self:SearchUni)) 
		aKeyw:=GetTokens(self:SearchUni) 
		for i:=1 to Len(aKeyw)
			self:cWhere+=iif(Empty(self:cWhere),""," and ")+"("
			for j:=1 to Len(self:AFields)
				self:cWhere+=iif(j=1,""," or ")+self:AFields[j]+" like '%"+aKeyw[i,1]+"%'"
			next
			self:cWhere+=")"
		next
	endif
	self:Refresh()

RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS StandingOrderBrowser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"StandingOrderBrowser",_GetInst()},iCtlID)

oCCEditButton := PushButton{SELF,ResourceID{STANDINGORDERBROWSER_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:OwnerAlignment := OA_PY

oCCNewButton := PushButton{SELF,ResourceID{STANDINGORDERBROWSER_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}
oCCNewButton:OwnerAlignment := OA_PY

oCCDeleteButton := PushButton{SELF,ResourceID{STANDINGORDERBROWSER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PY

oCCCancelButton := PushButton{SELF,ResourceID{STANDINGORDERBROWSER_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}
oCCCancelButton:OwnerAlignment := OA_PY

oDCSC_REK := FixedText{SELF,ResourceID{STANDINGORDERBROWSER_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,"Account:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{STANDINGORDERBROWSER_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Periodic amounts",NULL_STRING,NULL_STRING}
oDCGroupBox1:OwnerAlignment := OA_HEIGHT

oDCSearchRek := SingleLineEdit{SELF,ResourceID{STANDINGORDERBROWSER_SEARCHREK,_GetInst()}}
oDCSearchRek:HyperLabel := HyperLabel{#SearchRek,NULL_STRING,"The account from which to record",NULL_STRING}
oDCSearchRek:FieldSpec := MEMBERACCOUNT{}
oDCSearchRek:FocusSelect := FSEL_HOME
oDCSearchRek:TooltipText := "The person, who is a subscriber"
oDCSearchRek:UseHLforToolTip := True

oCCAccButtonFrom := PushButton{SELF,ResourceID{STANDINGORDERBROWSER_ACCBUTTONFROM,_GetInst()}}
oCCAccButtonFrom:HyperLabel := HyperLabel{#AccButtonFrom,"v","Browse in from accounts",NULL_STRING}
oCCAccButtonFrom:TooltipText := "Browse in accounts"
oCCAccButtonFrom:UseHLforToolTip := True

oDCFixedText4 := FixedText{SELF,ResourceID{STANDINGORDERBROWSER_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"lines",NULL_STRING,NULL_STRING}

oDCFound := FixedText{SELF,ResourceID{STANDINGORDERBROWSER_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{STANDINGORDERBROWSER_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

oCCFindButton := PushButton{SELF,ResourceID{STANDINGORDERBROWSER_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Find",NULL_STRING,NULL_STRING}

oDCSearchUni := SingleLineEdit{SELF,ResourceID{STANDINGORDERBROWSER_SEARCHUNI,_GetInst()}}
oDCSearchUni:HyperLabel := HyperLabel{#SearchUni,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchUni:FocusSelect := FSEL_TRIM
oDCSearchUni:TooltipText := "Enter one or more (part of) key values "
oDCSearchUni:UseHLforToolTip := True

oDCFixedText5 := FixedText{SELF,ResourceID{STANDINGORDERBROWSER_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Universal:",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{STANDINGORDERBROWSER_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Search",NULL_STRING,NULL_STRING}

SELF:Caption := "Standing Orders"
SELF:HyperLabel := HyperLabel{#StandingOrderBrowser,"Standing Orders",NULL_STRING,NULL_STRING}
SELF:Menu := WOMenu{}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True
SELF:EnableStatusBar(True)

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
self:Browser := DataBrowser{self}

oDBSEARCHREKOLD := DataColumn{11}
oDBSEARCHREKOLD:Width := 11
oDBSEARCHREKOLD:HyperLabel := HyperLabel{#SearchREKold,NULL_STRING,"Enter characters to match accountnumber from which to transfer periodic amounts","Account_Rek"} 
oDBSEARCHREKOLD:Caption := ""
self:Browser:AddColumn(oDBSEARCHREKOLD)


SELF:ViewAs(#FormView)

oSFPeriodicBrowser_DETAIL := StandingOrderBrowser_Detail{self,STANDINGORDERBROWSER_PERIODICBROWSER_DETAIL}
oSFPeriodicBrowser_DETAIL:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD NewButton( ) CLASS StandingOrderBrowser
	SELF:EditButton(TRUE)
RETURN NIL
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS StandingOrderBrowser
	//Put your PostInit additions here
	LOCAL oBank as SQLSelect
	LOCAL lSuccess AS LOGIC
self:SetTexts()
// 	SaveUse(self)
// 	*Determine accountfilter for use in From and To-account:
// 	IF !Empty(SKAP)
// 		cAccFilter:='accid<>'+SKAP
// 	ENDIF
// 	IF !Empty(SDEB)
// 		self:cAccFilter:=if(Empty(self:cAccFilter),"",self:cAccFilter+' and ')+'accid<>'+SDEB
// 	ENDIF
// 	IF !Empty(SPROJ)
// 		self:cAccFilter:=if(Empty(self:cAccFilter),"",self:cAccFilter+' and ')+'accid<>'+SPROJ
// 	ENDIF
// 	oBank:=SQLSelect{"select accid from bankaccount where not accid is null and accid>0",oConn}
// 	DO WHILE !oBank:EOF
// 		self:cAccFilter:=if(Empty(self:cAccFilter),"",self:cAccFilter+' and accid<>'+Str(oBank:accid,-1))
// 		oBank:Skip()
// 	ENDDO 
  	self:oDCFound:TextValue :=Str(self:oStOrd:RecCount,-1)

	SELF:oDCSearchREK:SetFocus()
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS StandingOrderBrowser
	//Put your PreInit additions here
	local lSuccess as logic 
	self:cWhere:=""
	self:cOrder:="l.stordrid,l.seqnr" 
	self:cFields:="s.stordrid,s.`day`,s.`period`,cast(s.idat as date) as idat,cast(s.edat as date) as edat,cast(s.lstrecording as date) as lstrecording,s.docid,"+;
	 		"l.accountid,l.deb,l.cre,l.descriptn,l.accountid,a.description as accountname,a.accnumber,cast(s.lstchange as date) as lstchange,s.userid"
	self:aFields:={"s.stordrid","s.day","s.period","s.idat","s.edat","s.lstrecording","s.docid",""+;
		"l.accountid","l.deb","l.cre","l.descriptn","l.accountid","a.description","a.accnumber","s.userid","s.lstchange"}
	self:cFrom:="standingorder s, standingorderline l left join account a on (a.accid=l.accountid)"
// 	self:oStOrd:=SQLSelect{"select "+self:cFields+" from "+self:cFrom+" where l.stordrid=s.stordrid"+iif(Empty(self:cWhere),""," and "+self:cWhere)+" order by "+self:cOrder,oConn}
	self:oStOrd:=SQLSelectPagination{"select "+self:cFields+" from "+self:cFrom+" where l.stordrid=s.stordrid order by "+self:cOrder,oConn}
	self:oStOrd:Execute()
	

	RETURN NIL
Method Refresh() class StandingOrderBrowser
	if IsObject(self:Server) .and. !self:Server==null_object .and. CheckInstanceOf(self:Server, #SQLSelectPagination) 
		self:Server:sqlstring:="select "+self:cFields+" from "+self:cFrom+" where l.stordrid=s.stordrid"+iif(Empty(self:cWhere),""," and "+self:cWhere)+" order by "+self:cOrder
		self:Server:Execute() 
		self:oSFPeriodicBrowser_DETAIL:Browser:Refresh()
	  	self:oDCFound:TextValue :=Str(self:oStOrd:RecCount,-1)
	endif
	return
ACCESS SearchRek() CLASS StandingOrderBrowser
RETURN SELF:FieldGet(#SearchRek)

ASSIGN SearchRek(uValue) CLASS StandingOrderBrowser
SELF:FieldPut(#SearchRek, uValue)
RETURN uValue

ACCESS SearchREKold() CLASS StandingOrderBrowser
RETURN SELF:FieldGet(#SearchREKold)

ASSIGN SearchREKold(uValue) CLASS StandingOrderBrowser
SELF:FieldPut(#SearchREKold, uValue)
RETURN uValue

ACCESS SearchRekTo() CLASS StandingOrderBrowser
RETURN SELF:FieldGet(#SearchRekTo)

ASSIGN SearchRekTo(uValue) CLASS StandingOrderBrowser
SELF:FieldPut(#SearchRekTo, uValue)
RETURN uValue

ACCESS SearchUni() CLASS StandingOrderBrowser
RETURN SELF:FieldGet(#SearchUni)

ASSIGN SearchUni(uValue) CLASS StandingOrderBrowser
SELF:FieldPut(#SearchUni, uValue)
RETURN uValue

STATIC DEFINE STANDINGORDERBROWSER_ACCBUTTONFROM := 109 
STATIC DEFINE STANDINGORDERBROWSER_CANCELBUTTON := 104 
STATIC DEFINE STANDINGORDERBROWSER_DELETEBUTTON := 103 
CLASS StandingOrderBrowser_DETAIL INHERIT DataWindowMine 

	PROTECT oDBSTORDRID as DataColumn
	PROTECT oDBACCOUNTNAME as DataColumn
	PROTECT oDBDAY as DataColumn
	PROTECT oDBPERIOD as DataColumn
	PROTECT oDBDESCRIPTN as DataColumn
	PROTECT oDBDOCID as DataColumn
	PROTECT oDBDEB as DataColumn
	PROTECT oDBCRE as DataColumn
	PROTECT oDBLSTRECORDING as DataColumn
	PROTECT oDCSC_REK AS FIXEDTEXT
	PROTECT oDCSC_BESTEMMING AS FIXEDTEXT
	PROTECT oDCSC_IDAT AS FIXEDTEXT
	PROTECT oDCSC_EDAT AS FIXEDTEXT
	PROTECT oDCSC_BOEKDAG AS FIXEDTEXT
	PROTECT oDCAccountName AS SINGLELINEEDIT
	PROTECT oDCBESTEMMINGSACC AS SINGLELINEEDIT
	PROTECT oDCIDAT AS SINGLELINEEDIT
	PROTECT oDCEdat AS SINGLELINEEDIT
	PROTECT oDCDAY AS SINGLELINEEDIT
	PROTECT oDCdescriptn AS SINGLELINEEDIT
	PROTECT oDClstrecording AS SINGLELINEEDIT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
RESOURCE StandingOrderBrowser_DETAIL DIALOGEX  26, 24, 458, 196
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Account number", STANDINGORDERBROWSER_DETAIL_SC_REK, "Static", WS_CHILD, 13, 14, 54, 13
	CONTROL	"Bestemming", STANDINGORDERBROWSER_DETAIL_SC_BESTEMMING, "Static", WS_CHILD, 13, 29, 40, 12
	CONTROL	"Idat", STANDINGORDERBROWSER_DETAIL_SC_IDAT, "Static", WS_CHILD, 13, 44, 14, 12
	CONTROL	"Edat", STANDINGORDERBROWSER_DETAIL_SC_EDAT, "Static", WS_CHILD, 13, 59, 17, 12
	CONTROL	"Boekdag", STANDINGORDERBROWSER_DETAIL_SC_BOEKDAG, "Static", WS_CHILD, 13, 73, 31, 13
	CONTROL	"Account", STANDINGORDERBROWSER_DETAIL_ACCOUNTNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 14, 100, 13, WS_EX_CLIENTEDGE
	CONTROL	"To", STANDINGORDERBROWSER_DETAIL_BESTEMMINGSACC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 29, 100, 12, WS_EX_CLIENTEDGE
	CONTROL	"Start", STANDINGORDERBROWSER_DETAIL_IDAT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 44, 80, 12, WS_EX_CLIENTEDGE
	CONTROL	"End", STANDINGORDERBROWSER_DETAIL_EDAT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 59, 80, 12, WS_EX_CLIENTEDGE
	CONTROL	"Day#", STANDINGORDERBROWSER_DETAIL_DAY, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 73, 36, 13, WS_EX_CLIENTEDGE
	CONTROL	"Description", STANDINGORDERBROWSER_DETAIL_DESCRIPTN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 6, 103, 432, 12, WS_EX_CLIENTEDGE
	CONTROL	"Latest Rec", STANDINGORDERBROWSER_DETAIL_LSTRECORDING, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 76, 118, 80, 12, WS_EX_CLIENTEDGE
END

ACCESS AccountName() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#AccountName)

ASSIGN AccountName(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#AccountName, uValue)
RETURN uValue

ACCESS BESTEMMINGSACC() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#BESTEMMINGSACC)

ASSIGN BESTEMMINGSACC(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#BESTEMMINGSACC, uValue)
RETURN uValue

ACCESS CRE() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#CRE)

ASSIGN CRE(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#CRE, uValue)
RETURN uValue

ACCESS DAY() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#DAY)

ASSIGN DAY(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#DAY, uValue)
RETURN uValue

ACCESS DEB() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#DEB)

ASSIGN DEB(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#DEB, uValue)
RETURN uValue

ACCESS descriptn() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#descriptn)

ASSIGN descriptn(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#descriptn, uValue)
RETURN uValue

ACCESS docid() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#docid)

ASSIGN docid(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#docid, uValue)
RETURN uValue

ACCESS Edat() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#Edat)

ASSIGN Edat(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#Edat, uValue)
RETURN uValue

ACCESS FromAccount() CLASS StandingOrderBrowser_Detail
RETURN SELF:FieldGet(#FromAccount)

ASSIGN FromAccount(uValue) CLASS StandingOrderBrowser_Detail
SELF:FieldPut(#FromAccount, uValue)
RETURN uValue

ACCESS IDAT() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#IDAT)

ASSIGN IDAT(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#IDAT, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS StandingOrderBrowser_DETAIL 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"StandingOrderBrowser_DETAIL",_GetInst()},iCtlID)

oDCSC_REK := FixedText{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,"Account number",NULL_STRING,NULL_STRING}

oDCSC_BESTEMMING := FixedText{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_SC_BESTEMMING,_GetInst()}}
oDCSC_BESTEMMING:HyperLabel := HyperLabel{#SC_BESTEMMING,"Bestemming",NULL_STRING,NULL_STRING}

oDCSC_IDAT := FixedText{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_SC_IDAT,_GetInst()}}
oDCSC_IDAT:HyperLabel := HyperLabel{#SC_IDAT,"Idat",NULL_STRING,NULL_STRING}

oDCSC_EDAT := FixedText{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_SC_EDAT,_GetInst()}}
oDCSC_EDAT:HyperLabel := HyperLabel{#SC_EDAT,"Edat",NULL_STRING,NULL_STRING}

oDCSC_BOEKDAG := FixedText{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_SC_BOEKDAG,_GetInst()}}
oDCSC_BOEKDAG:HyperLabel := HyperLabel{#SC_BOEKDAG,"Boekdag",NULL_STRING,NULL_STRING}

oDCAccountName := SingleLineEdit{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_ACCOUNTNAME,_GetInst()}}
oDCAccountName:FieldSpec := account_OMS{}
oDCAccountName:HyperLabel := HyperLabel{#AccountName,"Account","Number of an Account",NULL_STRING}
oDCAccountName:TooltipText := "Account from/to transfer a periodic amount"

oDCBESTEMMINGSACC := SingleLineEdit{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_BESTEMMINGSACC,_GetInst()}}
oDCBESTEMMINGSACC:FieldSpec := Account_AccNumber{}
oDCBESTEMMINGSACC:HyperLabel := HyperLabel{#BESTEMMINGSACC,"To",NULL_STRING,"Rek_REK"}
oDCBESTEMMINGSACC:TooltipText := "Account to which to transfer a periodic amount"

oDCIDAT := SingleLineEdit{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_IDAT,_GetInst()}}
oDCIDAT:FieldSpec := PeriodicRec_IDAT{}
oDCIDAT:HyperLabel := HyperLabel{#IDAT,"Start",NULL_STRING,"PeriodicRec_IDAT"}
oDCIDAT:TooltipText := "Date to start with first periodic transfer"

oDCEdat := SingleLineEdit{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_EDAT,_GetInst()}}
oDCEdat:FieldSpec := PeriodicRec_EDAT{}
oDCEdat:HyperLabel := HyperLabel{#Edat,"End",NULL_STRING,"PeriodicRec_EDAT"}
oDCEdat:TooltipText := "Date to stop with periodic transfer of the amount"

oDCDAY := SingleLineEdit{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_DAY,_GetInst()}}
oDCDAY:FieldSpec := standingorder_day{}
oDCDAY:HyperLabel := HyperLabel{#DAY,"Day#",NULL_STRING,NULL_STRING}
oDCDAY:TooltipText := "Day in month transfer has to take place"

oDCdescriptn := SingleLineEdit{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_DESCRIPTN,_GetInst()}}
oDCdescriptn:FieldSpec := StandingOrderLine_DESCRIPTN{}
oDCdescriptn:HyperLabel := HyperLabel{#descriptn,"Description",NULL_STRING,NULL_STRING}
oDCdescriptn:TooltipText := "Description to add to each periodic transaction"

oDClstrecording := SingleLineEdit{SELF,ResourceID{STANDINGORDERBROWSER_DETAIL_LSTRECORDING,_GetInst()}}
oDClstrecording:FieldSpec := standingorder_lstrecording{}
oDClstrecording:HyperLabel := HyperLabel{#lstrecording,"Latest Rec",NULL_STRING,NULL_STRING}
oDClstrecording:TooltipText := "Date of latest actual transfer"

SELF:Caption := ""
SELF:HyperLabel := HyperLabel{#StandingOrderBrowser_DETAIL,NULL_STRING,NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:OwnerAlignment := OA_PWIDTH_PHEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBSTORDRID := DataColumn{PeriodicRec_STORDRID{}}
oDBSTORDRID:Width := 12
oDBSTORDRID:HyperLabel := HyperLabel{#stordrid,"Order#",NULL_STRING,NULL_STRING} 
oDBSTORDRID:Caption := "Order#"
self:Browser:AddColumn(oDBSTORDRID)

oDBACCOUNTNAME := DataColumn{account_OMS{}}
oDBACCOUNTNAME:Width := 19
oDBACCOUNTNAME:HyperLabel := oDCACCOUNTNAME:HyperLabel 
oDBACCOUNTNAME:Caption := "Account"
self:Browser:AddColumn(oDBACCOUNTNAME)

oDBDAY := DataColumn{standingorder_day{}}
oDBDAY:Width := 6
oDBDAY:HyperLabel := oDCDAY:HyperLabel 
oDBDAY:Caption := "Day#"
self:Browser:AddColumn(oDBDAY)

oDBPERIOD := DataColumn{standingorder_period{}}
oDBPERIOD:Width := 7
oDBPERIOD:HyperLabel := HyperLabel{#Period,"Period",NULL_STRING,NULL_STRING} 
oDBPERIOD:Caption := "Period"
self:Browser:AddColumn(oDBPERIOD)

oDBDESCRIPTN := DataColumn{StandingOrderLine_DESCRIPTN{}}
oDBDESCRIPTN:Width := 25
oDBDESCRIPTN:HyperLabel := oDCDESCRIPTN:HyperLabel 
oDBDESCRIPTN:Caption := "Description"
self:Browser:AddColumn(oDBDESCRIPTN)

oDBDOCID := DataColumn{11}
oDBDOCID:Width := 11
oDBDOCID:HyperLabel := HyperLabel{#docid,"DocmntID",NULL_STRING,NULL_STRING} 
oDBDOCID:Caption := "DocmntID"
self:Browser:AddColumn(oDBDOCID)

oDBDEB := DataColumn{StandingOrderLine_DEB{}}
oDBDEB:Width := 10
oDBDEB:HyperLabel := HyperLabel{#DEB,"Debit",NULL_STRING,NULL_STRING} 
oDBDEB:Caption := "Debit"
self:Browser:AddColumn(oDBDEB)

oDBCRE := DataColumn{StandingOrderLine_CRE{}}
oDBCRE:Width := 10
oDBCRE:HyperLabel := HyperLabel{#CRE,"Credit",NULL_STRING,NULL_STRING} 
oDBCRE:Caption := "Credit"
self:Browser:AddColumn(oDBCRE)

oDBLSTRECORDING := DataColumn{standingorder_lstrecording{}}
oDBLSTRECORDING:Width := 11
oDBLSTRECORDING:HyperLabel := oDCLSTRECORDING:HyperLabel 
oDBLSTRECORDING:Caption := "Latest Rec"
self:Browser:AddColumn(oDBLSTRECORDING)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS lstrecording() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#lstrecording)

ASSIGN lstrecording(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#lstrecording, uValue)
RETURN uValue

ACCESS Period() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#Period)

ASSIGN Period(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#Period, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class StandingOrderBrowser_Detail
	//Put your PostInit additions here 
	self:Browser:SetStandardStyle( gbsReadOnly )
	return NIL

METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS StandingOrderBrowser_Detail
	//Put your PreInit additions here 
	local lSuccess as logic
// 	oWindow:Server:SetRelation(oWindow:oAcc,"accid")		
	oWindow:use(oWindow:oStOrd)
	RETURN nil
ACCESS stordrid() CLASS StandingOrderBrowser_DETAIL
RETURN SELF:FieldGet(#stordrid)

ASSIGN stordrid(uValue) CLASS StandingOrderBrowser_DETAIL
SELF:FieldPut(#stordrid, uValue)
RETURN uValue

STATIC DEFINE STANDINGORDERBROWSER_DETAIL_ACCOUNTNAME := 105 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_BESTEMMINGSACC := 106 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_CRE := 114 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_DAY := 109 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_DEB := 113 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_DESCRIPTN := 110 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_DOCID := 116 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_EDAT := 108 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_IDAT := 107 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_LSTRECORDING := 111 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_PERIOD := 112 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_SC_BESTEMMING := 101 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_SC_BOEKDAG := 104 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_SC_EDAT := 103 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_SC_IDAT := 102 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_SC_REK := 100 
STATIC DEFINE STANDINGORDERBROWSER_DETAIL_STORDRID := 115 
STATIC DEFINE STANDINGORDERBROWSER_EDITBUTTON := 101 
STATIC DEFINE STANDINGORDERBROWSER_FINDBUTTON := 113 
STATIC DEFINE STANDINGORDERBROWSER_FIXEDTEXT4 := 110 
STATIC DEFINE STANDINGORDERBROWSER_FIXEDTEXT5 := 115 
STATIC DEFINE STANDINGORDERBROWSER_FOUND := 111 
STATIC DEFINE STANDINGORDERBROWSER_FOUNDTEXT := 112 
STATIC DEFINE STANDINGORDERBROWSER_GROUPBOX1 := 107 
STATIC DEFINE STANDINGORDERBROWSER_GROUPBOX2 := 116 
STATIC DEFINE STANDINGORDERBROWSER_NEWBUTTON := 102 
STATIC DEFINE STANDINGORDERBROWSER_PERIODICBROWSER_DETAIL := 100 
STATIC DEFINE STANDINGORDERBROWSER_SC_REK := 105 
STATIC DEFINE STANDINGORDERBROWSER_SEARCHREK := 108 
STATIC DEFINE STANDINGORDERBROWSER_SEARCHREKOLD := 106 
STATIC DEFINE STANDINGORDERBROWSER_SEARCHUNI := 114 
RESOURCE StOrderLines DIALOGEX  2, 2, 496, 123
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

CLASS StOrderLines INHERIT DataWindowExtra 

	PROTECT oDBACCOUNTNBR as JapDataColumn
	PROTECT oDBACCOUNTNAM as JapDataColumn
	PROTECT oDBREFERENCE as JapDataColumn
	PROTECT oDBDESCRIPTN as JapDataColumn
	PROTECT oDBDEB as JapDataColumn
	PROTECT oDBCRE as JapDataColumn
	PROTECT oDBGC as JapDataColumn
	PROTECT oDBCREDTRNAM as JapDataColumn
	PROTECT oDBBANKACCT as JapDataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
ACCESS ACCOUNTNAM() CLASS StOrderLines
RETURN SELF:FieldGet(#ACCOUNTNAM)

ASSIGN ACCOUNTNAM(uValue) CLASS StOrderLines
SELF:FieldPut(#ACCOUNTNAM, uValue)
RETURN uValue

ACCESS ACCOUNTNBR() CLASS StOrderLines
RETURN SELF:FieldGet(#ACCOUNTNBR)

ASSIGN ACCOUNTNBR(uValue) CLASS StOrderLines
SELF:FieldPut(#ACCOUNTNBR, uValue)
RETURN uValue

method AddCredtr() class StOrderLines
	// add/remove  columns for creditor
	LOCAL oBrowse:=self:Browser as StOrdLnBrowser
	local oStLine:=self:Server as StOrdLineHelp
	local lAdd as logic

	AEval(oStLine:aMirror,{|x|lAdd:=iif(x[5]==Val(sCRE),true,lAdd) })

	if oBrowse:GetColumn(#CREDTRNAM)==nil 
		if lAdd 
			oBrowse:AddColumn({self:oDBCREDTRNAM,self:oDBBANKACCT}) 
			if self:Owner:Size:Width <700
				self:Owner:SetWidth(self:Owner:Size:Width+=164)
			endif
			oBrowse:Refresh() 
		endif
	elseif !lAdd
		oBrowse:RemoveColumn( oDBCREDTRNAM)
		oBrowse:RemoveColumn( oDBBANKACCT)
		if self:Owner:Size:Width >=700
			self:Owner:SetWidth(self:Owner:Size:Width-=164)
		endif
		oBrowse:Refresh()
	endif
ACCESS BankAcct() CLASS StOrderLines
RETURN SELF:FieldGet(#BankAcct)

ASSIGN BankAcct(uValue) CLASS StOrderLines
SELF:FieldPut(#BankAcct, uValue)
RETURN uValue

method Close(oEvent) class StOrderLines
	LOCAL oServer as FileSpec

IF !self:Server==null_object
	oServer:=FileSpec{self:Server:FileSpec:FullPath}
	IF self:Server:Used
		self:Server:Close()
	ENDIF
	//FErase(cServer)
	oServer:DELETE()
	IF oServer:Find()
		FErase(oServer:FullPath)
	ENDIF 
endif
	
	//Put your changes here
	return super:Close(oEvent) 
ACCESS CRE() CLASS StOrderLines
RETURN SELF:FieldGet(#CRE)

ASSIGN CRE(uValue) CLASS StOrderLines
SELF:FieldPut(#CRE, uValue)
RETURN uValue

ACCESS CREDTRNAM() CLASS StOrderLines
RETURN SELF:FieldGet(#CREDTRNAM)

ASSIGN CREDTRNAM(uValue) CLASS StOrderLines
SELF:FieldPut(#CREDTRNAM, uValue)
RETURN uValue

ACCESS DEB() CLASS StOrderLines
RETURN SELF:FieldGet(#DEB)

ASSIGN DEB(uValue) CLASS StOrderLines
SELF:FieldPut(#DEB, uValue)
RETURN uValue

ACCESS DESCRIPTN() CLASS StOrderLines
RETURN SELF:FieldGet(#DESCRIPTN)

ASSIGN DESCRIPTN(uValue) CLASS StOrderLines
SELF:FieldPut(#DESCRIPTN, uValue)
RETURN uValue

ACCESS GC() CLASS StOrderLines
RETURN SELF:FieldGet(#GC)

ASSIGN GC(uValue) CLASS StOrderLines
SELF:FieldPut(#GC, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS StOrderLines 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"StOrderLines",_GetInst()},iCtlID)

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#StOrderLines,"DataWindow Caption",NULL_STRING,NULL_STRING}
SELF:OwnerAlignment := OA_PWIDTH_PHEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := StOrdLnBrowser{self}

oDBACCOUNTNBR := JapDataColumn{Account_AccNumber{}}
oDBACCOUNTNBR:Width := 11
oDBACCOUNTNBR:HyperLabel := HyperLabel{#ACCOUNTNBR,"Account",NULL_STRING,NULL_STRING} 
oDBACCOUNTNBR:Caption := "Account"
self:Browser:AddColumn(oDBACCOUNTNBR)

oDBACCOUNTNAM := JapDataColumn{account_OMS{}}
oDBACCOUNTNAM:Width := 17
oDBACCOUNTNAM:HyperLabel := HyperLabel{#ACCOUNTNAM,"Accountname",NULL_STRING,NULL_STRING} 
oDBACCOUNTNAM:Caption := "Accountname"
self:Browser:AddColumn(oDBACCOUNTNAM)

oDBREFERENCE := JapDataColumn{Transaction_REFERENCE{}}
oDBREFERENCE:Width := 11
oDBREFERENCE:HyperLabel := HyperLabel{#Reference,"Reference",NULL_STRING,NULL_STRING} 
oDBREFERENCE:Caption := "Reference"
self:Browser:AddColumn(oDBREFERENCE)

oDBDESCRIPTN := JapDataColumn{23}
oDBDESCRIPTN:Width := 23
oDBDESCRIPTN:HyperLabel := HyperLabel{#DESCRIPTN,"Description",NULL_STRING,NULL_STRING} 
oDBDESCRIPTN:Caption := "Description"
self:Browser:AddColumn(oDBDESCRIPTN)

oDBDEB := JapDataColumn{StOrdLineHelp_DEB{}}
oDBDEB:Width := 9
oDBDEB:HyperLabel := HyperLabel{#DEB,"Debit",NULL_STRING,NULL_STRING} 
oDBDEB:Caption := "Debit"
self:Browser:AddColumn(oDBDEB)

oDBCRE := JapDataColumn{StOrdLineHelp_CRE{}}
oDBCRE:Width := 9
oDBCRE:HyperLabel := HyperLabel{#CRE,"Credit",NULL_STRING,NULL_STRING} 
oDBCRE:Caption := "Credit"
self:Browser:AddColumn(oDBCRE)

oDBGC := JapDataColumn{11}
oDBGC:Width := 11
oDBGC:HyperLabel := HyperLabel{#GC,"Asmt",NULL_STRING,NULL_STRING} 
oDBGC:Caption := "Asmt"
self:Browser:AddColumn(oDBGC)

oDBCREDTRNAM := JapDataColumn{Person_NA1{}}
oDBCREDTRNAM:Width := 15
oDBCREDTRNAM:HyperLabel := HyperLabel{#CREDTRNAM,"Creditor",NULL_STRING,NULL_STRING} 
oDBCREDTRNAM:Caption := "Creditor"
self:Browser:AddColumn(oDBCREDTRNAM)

oDBBANKACCT := JapDataColumn{BANK{}}
oDBBANKACCT:Width := 14
oDBBANKACCT:HyperLabel := HyperLabel{#BankAcct,"Bank Acnt#",NULL_STRING,NULL_STRING} 
oDBBANKACCT:Caption := "Bank Acnt#"
self:Browser:AddColumn(oDBBANKACCT)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method PostInit(oWindow,iCtlID,oServer,uExtra) class StOrderLines
	//Put your PostInit additions here     
	LOCAL oBrowse:=self:Browser as StOrdLnBrowser
	self:oDBACCOUNTNAM:SetStandardStyle(gbsReadOnly)
	IF !(ADMIN=="WO".or.ADMIN=="HO")
		* remove assessment column:
		self:Browser:RemoveColumn(self:oDBGC)
	ENDIF
	oBrowse:RemoveColumn(self:oDBCREDTRNAM)
	oBrowse:RemoveColumn(self:oDBBANKACCT)
	

	return NIL
method PreInit(oWindow,iCtlID,oServer,uExtra) class StOrderLines
	//Put your PreInit additions here 
	local oStLine:=self:Server as StOrdLineHelp
	GetHelpDir()
	oStLine:=StOrdLineHelp{HelpDir+"\HO"+StrTran(StrTran(Time(),":"),' ','')+".DBF",DBEXCLUSIVE} 
	oWindow:use(oStLine) 
	
	return nil
ACCESS Reference() CLASS StOrderLines
RETURN SELF:FieldGet(#Reference)

ASSIGN Reference(uValue) CLASS StOrderLines
SELF:FieldPut(#Reference, uValue)
RETURN uValue

STATIC DEFINE STORDERLINES_ACCOUNTNAM := 104 
STATIC DEFINE STORDERLINES_ACCOUNTNBR := 103 
STATIC DEFINE STORDERLINES_BANKACCT := 108 
STATIC DEFINE STORDERLINES_CRE := 102 
STATIC DEFINE STORDERLINES_CREDTRNAM := 107 
STATIC DEFINE STORDERLINES_DEB := 101 
STATIC DEFINE STORDERLINES_DESCRIPTN := 100 
STATIC DEFINE STORDERLINES_GC := 105 
STATIC DEFINE STORDERLINES_REFERENCE := 106 
