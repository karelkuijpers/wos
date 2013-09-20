RESOURCE EditPeriodic DIALOGEX  41, 37, 399, 234
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"15-1-2011", EDITPERIODIC_MIDAT, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 80, 11, 74, 13
	CONTROL	"15-1-2011", EDITPERIODIC_MEDAT, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 80, 29, 74, 14
	CONTROL	"", EDITPERIODIC_MDAY, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 44, 36, 12, WS_EX_CLIENTEDGE
	CONTROL	"Period", EDITPERIODIC_MPERIOD, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 59, 36, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITPERIODIC_MCURRENCY, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 264, 81, 96, 111
	CONTROL	"", EDITPERIODIC_MDOCID, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 81, 104, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITPERIODIC_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 80, 99, 94, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITPERIODIC_PERSONBUTTON, "Button", WS_CHILD|NOT WS_VISIBLE, 172, 99, 13, 13
	CONTROL	"OK", EDITPERIODIC_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 284, 214, 53, 12
	CONTROL	"Cancel", EDITPERIODIC_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 340, 214, 53, 12
	CONTROL	"Starting Date", EDITPERIODIC_SC_IDAT, "Static", WS_CHILD, 12, 11, 49, 12
	CONTROL	"Ending date:", EDITPERIODIC_SC_EDAT, "Static", WS_CHILD, 12, 25, 52, 13
	CONTROL	"Record day in month:", EDITPERIODIC_SC_BOEKDAG, "Static", WS_CHILD, 12, 44, 68, 12
	CONTROL	"Period (months):", EDITPERIODIC_FIXEDTEXT7, "Static", WS_CHILD, 12, 59, 64, 12
	CONTROL	"Giver:", EDITPERIODIC_GIVERTEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 12, 99, 53, 13
	CONTROL	"Document id:", EDITPERIODIC_SC_BST, "Static", WS_CHILD, 12, 81, 43, 12
	CONTROL	"", EDITPERIODIC_STORDERLINES, "static", WS_CHILD|WS_BORDER, 4, 118, 388, 86
	CONTROL	"Total:", EDITPERIODIC_SC_TOTAL, "Static", WS_CHILD, 4, 211, 22, 12
	CONTROL	"", EDITPERIODIC_TOTALTEXT, "Static", WS_CHILD|WS_BORDER, 36, 210, 73, 12, WS_EX_CLIENTEDGE
	CONTROL	"Currency:", EDITPERIODIC_FIXEDTEXT13, "Static", WS_CHILD, 216, 81, 43, 12
	CONTROL	"Last booked:", EDITPERIODIC_FIXEDTEXT10, "Static", WS_CHILD, 296, 22, 53, 12
	CONTROL	"", EDITPERIODIC_DATLTSBOEK, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 352, 22, 40, 12, WS_EX_CLIENTEDGE
	CONTROL	"Order#:", EDITPERIODIC_FIXEDTEXT11, "Static", WS_CHILD, 296, 7, 53, 12
	CONTROL	"", EDITPERIODIC_STORDRID, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 352, 7, 40, 12, WS_EX_CLIENTEDGE
END

CLASS EditPeriodic INHERIT DataWindowExtra 

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
	
METHOD CancelButton( ) CLASS EditPeriodic
SELF:ENDWindow()
RETURN NIL
METHOD Close(oEvent) CLASS EditPeriodic
if !Empty(self:Server) .and. self:Server:used 
	self:Server:Close()
endif
	SUPER:Close(oEvent)
	//Put your changes here

	SELF:Destroy()
	RETURN NIL
ACCESS DATLTSBOEK() CLASS EditPeriodic
RETURN SELF:FieldGet(#DATLTSBOEK)

ASSIGN DATLTSBOEK(uValue) CLASS EditPeriodic
SELF:FieldPut(#DATLTSBOEK, uValue)
RETURN uValue

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS EditPeriodic
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
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditPeriodic 
LOCAL DIM aBrushes[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditPeriodic",_GetInst()},iCtlID)

aBrushes[1] := Brush{Color{COLORWHITE}}

oDCmIDAT := DateTimePicker{SELF,ResourceID{EDITPERIODIC_MIDAT,_GetInst()}}
oDCmIDAT:HyperLabel := HyperLabel{#mIDAT,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmEDAT := DateTimePicker{SELF,ResourceID{EDITPERIODIC_MEDAT,_GetInst()}}
oDCmEDAT:HyperLabel := HyperLabel{#mEDAT,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmDAY := SingleLineEdit{SELF,ResourceID{EDITPERIODIC_MDAY,_GetInst()}}
oDCmDAY:HyperLabel := HyperLabel{#mDAY,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmDAY:Picture := "99"

oDCmPeriod := SingleLineEdit{SELF,ResourceID{EDITPERIODIC_MPERIOD,_GetInst()}}
oDCmPeriod:HyperLabel := HyperLabel{#mPeriod,"Period",NULL_STRING,NULL_STRING}
oDCmPeriod:TooltipText := "Period in month after which the record will be repeated"
oDCmPeriod:Picture := "9999"

oDCmCurrency := combobox{SELF,ResourceID{EDITPERIODIC_MCURRENCY,_GetInst()}}
oDCmCurrency:HyperLabel := HyperLabel{#mCurrency,NULL_STRING,"Currency of the amount",NULL_STRING}
oDCmCurrency:FillUsing(SQLSelect{"select united_ara,aed from currencylist",oConn}:getLookupTable(300,#UNITED_ARA,#AED))
oDCmCurrency:TooltipText := "Apply this currency to the debit and credit amounts below."

oDCmDOCID := SingleLineEdit{SELF,ResourceID{EDITPERIODIC_MDOCID,_GetInst()}}
oDCmDOCID:HyperLabel := HyperLabel{#mDOCID,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmDOCID:FieldSpec := transaction_BST{}

oDCmPerson := SingleLineEdit{SELF,ResourceID{EDITPERIODIC_MPERSON,_GetInst()}}
oDCmPerson:HyperLabel := HyperLabel{#mPerson,NULL_STRING,"The person, who is the member","HELP_CLN"}
oDCmPerson:FocusSelect := FSEL_HOME
oDCmPerson:FieldSpec := Person_NA1{}

oCCPersonButton := PushButton{SELF,ResourceID{EDITPERIODIC_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v","Browse in persons",NULL_STRING}
oCCPersonButton:TooltipText := "Browse in Persons"

oCCOKButton := PushButton{SELF,ResourceID{EDITPERIODIC_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}
oCCOKButton:OwnerAlignment := OA_PX_Y

oCCCancelButton := PushButton{SELF,ResourceID{EDITPERIODIC_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}
oCCCancelButton:OwnerAlignment := OA_PX_Y

oDCSC_IDAT := FixedText{SELF,ResourceID{EDITPERIODIC_SC_IDAT,_GetInst()}}
oDCSC_IDAT:HyperLabel := HyperLabel{#SC_IDAT,"Starting Date",NULL_STRING,NULL_STRING}

oDCSC_EDAT := FixedText{SELF,ResourceID{EDITPERIODIC_SC_EDAT,_GetInst()}}
oDCSC_EDAT:HyperLabel := HyperLabel{#SC_EDAT,"Ending date:",NULL_STRING,NULL_STRING}

oDCSC_BOEKDAG := FixedText{SELF,ResourceID{EDITPERIODIC_SC_BOEKDAG,_GetInst()}}
oDCSC_BOEKDAG:HyperLabel := HyperLabel{#SC_BOEKDAG,"Record day in month:",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{EDITPERIODIC_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Period (months):",NULL_STRING,NULL_STRING}

oDCGiverText := FixedText{SELF,ResourceID{EDITPERIODIC_GIVERTEXT,_GetInst()}}
oDCGiverText:HyperLabel := HyperLabel{#GiverText,"Giver:",NULL_STRING,NULL_STRING}

oDCSC_BST := FixedText{SELF,ResourceID{EDITPERIODIC_SC_BST,_GetInst()}}
oDCSC_BST:HyperLabel := HyperLabel{#SC_BST,"Document id:",NULL_STRING,NULL_STRING}

oDCSC_Total := FixedText{SELF,ResourceID{EDITPERIODIC_SC_TOTAL,_GetInst()}}
oDCSC_Total:HyperLabel := HyperLabel{#SC_Total,"Total:",NULL_STRING,NULL_STRING}
oDCSC_Total:OwnerAlignment := OA_Y

oDCTotalText := FixedText{SELF,ResourceID{EDITPERIODIC_TOTALTEXT,_GetInst()}}
oDCTotalText:HyperLabel := HyperLabel{#TotalText,NULL_STRING,NULL_STRING,NULL_STRING}
oDCTotalText:TextColor := Color{COLORBLUE}
oDCTotalText:BackGround := aBrushes[1]
oDCTotalText:OwnerAlignment := OA_Y

oDCFixedText13 := FixedText{SELF,ResourceID{EDITPERIODIC_FIXEDTEXT13,_GetInst()}}
oDCFixedText13:HyperLabel := HyperLabel{#FixedText13,"Currency:",NULL_STRING,NULL_STRING}

oDCFixedText10 := FixedText{SELF,ResourceID{EDITPERIODIC_FIXEDTEXT10,_GetInst()}}
oDCFixedText10:HyperLabel := HyperLabel{#FixedText10,"Last booked:",NULL_STRING,NULL_STRING}

oDCDATLTSBOEK := SingleLineEdit{SELF,ResourceID{EDITPERIODIC_DATLTSBOEK,_GetInst()}}
oDCDATLTSBOEK:HyperLabel := HyperLabel{#DATLTSBOEK,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText11 := FixedText{SELF,ResourceID{EDITPERIODIC_FIXEDTEXT11,_GetInst()}}
oDCFixedText11:HyperLabel := HyperLabel{#FixedText11,"Order#:",NULL_STRING,NULL_STRING}

oDCSTORDRID := SingleLineEdit{SELF,ResourceID{EDITPERIODIC_STORDRID,_GetInst()}}
oDCSTORDRID:FieldSpec := PeriodicRec_STORDRID{}
oDCSTORDRID:HyperLabel := HyperLabel{#STORDRID,NULL_STRING,NULL_STRING,NULL_STRING}

SELF:Caption := "Edit Standing Order"
SELF:HyperLabel := HyperLabel{#EditPeriodic,"Edit Standing Order",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:Menu := WOBrowserMENU{}
SELF:AllowServerClose := False

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
SELF:ViewAs(#FormView)

oSFStOrderLines := StOrderLines{SELF,EDITPERIODIC_STORDERLINES}
oSFStOrderLines:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS LstRecording() CLASS EditPeriodic
RETURN self:FIELDGET(#LstRecording)

ASSIGN LstRecording(uValue) CLASS EditPeriodic
self:FIELDPUT(#LstRecording, uValue)
RETURN uValue

ACCESS mCurrency() CLASS EditPeriodic
RETURN SELF:FieldGet(#mCurrency)

ASSIGN mCurrency(uValue) CLASS EditPeriodic
SELF:FieldPut(#mCurrency, uValue)
RETURN uValue

ACCESS mDAY() CLASS EditPeriodic
RETURN SELF:FieldGet(#mDAY)

ASSIGN mDAY(uValue) CLASS EditPeriodic
SELF:FieldPut(#mDAY, uValue)
RETURN uValue

ACCESS mDOCID() CLASS EditPeriodic
RETURN SELF:FieldGet(#mDOCID)

ASSIGN mDOCID(uValue) CLASS EditPeriodic
SELF:FieldPut(#mDOCID, uValue)
RETURN uValue

ACCESS mPeriod() CLASS EditPeriodic
RETURN SELF:FieldGet(#mPeriod)

ASSIGN mPeriod(uValue) CLASS EditPeriodic
SELF:FieldPut(#mPeriod, uValue)
RETURN uValue

ACCESS mPerson() CLASS EditPeriodic
RETURN SELF:FieldGet(#mPerson)

ASSIGN mPerson(uValue) CLASS EditPeriodic
SELF:FieldPut(#mPerson, uValue)
RETURN uValue

METHOD OKButton( ) CLASS EditPeriodic
	LOCAL oStOrdLH:=self:oSFStOrderLines:server as StOrdLineHelp 
	Local nSeq:=1,nErr,nCH,nAG,nPF,nMG as int
	local cStatement,cSep as string
	local oStmnt as SQLStatement
	local lError as logic
	local aGCAcc:={} as array  // array with assessment codes and account id's of lines 
	local cPersid as string
// 	IF ValidateControls( self, self:AControls ) .and. self:ValidatePeriodic() .and. self:ValidateHelpLine(false,@nErr) 
	IF self:ValidatePeriodic() .and. self:ValidateHelpLine(false,@nErr) .and. self:ValidateBooking(oStOrdLH)
		if Len(oStOrdLH:aMirror)=0 .or. AScan(oStOrdLH:aMirror,{|x|x[2]<>x[1]})=0
			if !lNew
				self:oCaller:DeleteButton()
			endif
			self:EndWindow()
			return
		endif
// 		if !Empty(self:mCLNFrom) .or. !Empty(self:mCLN)
// 			oStOrdLH:GoTop() 
// 			aGCAcc:=oStOrdLH:GetLookupTable(500,#GC,#ACCOUNTID)
// 			nCh:=AScan(aGCAcc,{|x|x[1]=='CH'})
// 			nAG:=AScan(aGCAcc,{|x|x[1]=='AG'})
// 			nPF:=AScan(aGCAcc,{|x|x[1]=='PF'})
// 			nMG:=AScan(aGCAcc,{|x|x[1]=='MG'}) 
// 			if nAG>0 .or. nMG>0 .or. nPF>0
// 				if nCh>0 
// 					if !Empty(self:mCLN) .or. !Empty(self:mCLNFrom)
// 						if nAG>0 .and. !aGCAcc[nCh,2]==aGCAcc[nAG,2] ;
// 								.or.nMG>0 .and. !aGCAcc[nCh,2]==aGCAcc[nMG,2];
// 								.or.nPF>0 .and. !aGCAcc[nCH,2]==aGCAcc[nPF,2]
// 							cPersid:=self:mCLNFrom
// 							if Empty(cPersid) 
// 								cPersid:=self:mCLNFrom
// 							endif
// 						endif
// 					endif
// 				else
					if !Empty(self:mCLNFrom)
						cPersid:=self:mCLNFrom
					else
						cPersid:=self:mCLN
					endif
// 				endif
// 			endif 
// 		endif
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
			iif(lNew,""," where stordrid="+ self:curStordid)
		// 		iif(!Empty(self:mCLN),",persid="+self:mCLN,iif(!Empty(self:mCLNFrom),",persid="+self:mCLNFrom,""))+;
		oStmnt:=SQLStatement{cStatement,oConn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows>0 .or.Empty(oStmnt:Status)
			// save Standing Order Lines: 
			oStOrdLH:GoTop() 
			if lNew 
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
				if !self:UpdateStOrd()
					lError:=true
				endif
			endif
		elseif Empty(oStmnt:Status)
			lError:=true
		endif
		if !lError .and.lNew
			oStmnt:SQLString:=cStatement
			oStmnt:Execute()
			if !Empty(oStmnt:Status) .or. oStmnt:NumSuccessfulRows<1
				lError:=true
			endif
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
	
	
METHOD PersonButton(lUnique ) CLASS EditPeriodic
	LOCAL cValue := AllTrim(oDCmPerson:TEXTValue ) as STRING
	Default(@lUnique,FALSE)
//	PersonSelect(self,cValue,lUnique,'persid=="'+mCLN+'".or.Empty(accid)',"Giver")
	PersonSelect(self,cValue,lUnique,'',"Giver")
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditPeriodic
	//Put your PostInit additions here
	LOCAL oPer:=self:oStOrdr as SQLSelect
	local oOrdLnH:=self:Server as StOrdLineHelp 

	self:SetTexts()
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
method PreInit(oWindow,iCtlID,oServer,uExtra) class EditPeriodic
	//Put your PreInit additions here
   self:lNew:=uExtra
	if !self:lNew 
		self:curStordid:=Str(oServer:stordrid,-1)
		self:oStOrdr:=SqlSelect{"select s.stordrid,s.persid,s.`day`,s.`period`,cast(s.idat as date) as idat,cast(s.edat as date) as edat,cast(s.lstrecording as date) as lstrecording,s.docid,s.currency from standingorder s where s.stordrid="+self:curStordid,oConn} 
		self:oStOrdr:Execute()
	endif
	return nil
ACCESS STORDRID() CLASS EditPeriodic
RETURN SELF:FieldGet(#STORDRID)

ASSIGN STORDRID(uValue) CLASS EditPeriodic
SELF:FieldPut(#STORDRID, uValue)
RETURN uValue

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
RESOURCE PeriodicBrowser DIALOGEX  10, 11, 561, 262
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", PERIODICBROWSER_PERIODICBROWSER_DETAIL, "static", WS_CHILD|WS_BORDER, 12, 51, 461, 197
	CONTROL	"Edit", PERIODICBROWSER_EDITBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 488, 70, 53, 12
	CONTROL	"New", PERIODICBROWSER_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 488, 108, 53, 13
	CONTROL	"Delete", PERIODICBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 488, 147, 53, 12
	CONTROL	"Cancel", PERIODICBROWSER_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 488, 185, 52, 13
	CONTROL	"Account:", PERIODICBROWSER_SC_REK, "Static", WS_CHILD, 12, 8, 40, 12
	CONTROL	"Periodic amounts", PERIODICBROWSER_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 40, 544, 217
	CONTROL	"", PERIODICBROWSER_SEARCHREK, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 60, 7, 72, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", PERIODICBROWSER_ACCBUTTONFROM, "Button", WS_CHILD, 132, 7, 16, 12
	CONTROL	"lines", PERIODICBROWSER_FIXEDTEXT4, "Static", SS_CENTERIMAGE|WS_CHILD, 328, 3, 53, 13
	CONTROL	"", PERIODICBROWSER_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 288, 3, 36, 13
	CONTROL	"Found:", PERIODICBROWSER_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 260, 3, 27, 13
	CONTROL	"Find", PERIODICBROWSER_FINDBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 192, 3, 53, 13
	CONTROL	"", PERIODICBROWSER_SEARCHUNI, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 60, 22, 116, 12
	CONTROL	"Universal:", PERIODICBROWSER_FIXEDTEXT5, "Static", WS_CHILD, 12, 22, 44, 12
	CONTROL	"Search", PERIODICBROWSER_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 0, 184, 40
END

CLASS PeriodicBrowser INHERIT DataWindowExtra 

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
	PROTECT oSFPeriodicBrowser_DETAIL AS PeriodicBrowser_DETAIL

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT cAccFilter,cAccountNameFrom,cAccountNameTo as STRING
	EXPORT oAcc, oAccDest, oAccSearch as SQLSelect
	export oStOrd as SQLSelect
	export cWhere,cOrder,cFields,cFrom as string 
	protect cAccId as string 
	protect aFields:={} as array
METHOD AccButtonFrom(lUnique ) CLASS PeriodicBrowser 
	Default(@lUnique,FALSE)	
	AccountSelect(self,AllTrim(self:oDCSearchRek:TEXTValue ),"Account from",lUnique,"a.active=1")

RETURN NIL
METHOD AccButtonTo(lUnique ) CLASS PeriodicBrowser 
	Default(@lUnique,FALSE)	
	AccountSelect(self,AllTrim(self:oDCSearchRekTo:TEXTValue ),"Account to",lUnique,"a.active=1")

RETURN NIL
METHOD CancelButton( ) CLASS PeriodicBrowser
SELF:ENDwindow()
RETURN NIL
METHOD Close(oEvent) CLASS PeriodicBrowser
*	SUPER:Close(oEvent)
	//Put your changes here
SELF:oSFPeriodicBrowser_DETAIL:Close()
SELF:oSFPeriodicBrowser_DETAIL:Destroy()
SELF:destroy()
RETURN NIL
METHOD DeleteButton( ) CLASS PeriodicBrowser
	LOCAL oTextBox as TextBox 
	local curStorId as string
	local oStmnt as SQLStatement
	IF SELF:Server:EOF.or.SELF:Server:BOF
		(Errorbox{,"Select a periodic amount first"}):Show()
		RETURN
	ENDIF
	curStorId:=Str(self:oStOrd:STORDRID,-1)
	oTextBox := TextBox{ self, "Delete Standing Order",;
		"Delete Order "+curStorId+" with all its lines?" }	
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
METHOD EditButton(lNew) CLASS PeriodicBrowser
	LOCAL oEditPeriodicWindow AS EditPeriodic
	Default(@lNew,FALSE)
	IF !lNew.and.(SELF:Server:EOF.or.SELF:Server:BOF)
		(ErrorBox{,"Select a standing order first"}):Show()
		RETURN
	ENDIF
	
	oEditPeriodicWindow := EditPeriodic{ self:Owner,,self:oStOrd,lNew  }
	oEditPeriodicWindow:cAccFilter:=self:cAccFilter
// 	oEditPeriodicWindow:oCaller:=self:oSFPeriodicBrowser_DETAIL:Browser
	oEditPeriodicWindow:oCaller:=self
	oEditPeriodicWindow:Show()

	RETURN NIL
method EditFocusChange(oEditFocusChangeEvent) class PeriodicBrowser
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
METHOD FilePrint() CLASS  PeriodicBrowser
LOCAL aHeading as ARRAY
LOCAL nRij AS INT
LOCAL nBlad AS INT
LOCAL oReport AS PrintDialog
LOCAL cTab:=CHR(9) as STRING

oReport := PrintDialog{self,self:oLan:WGet("Standing Orders"),,138,,"xls"}
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
+oLan:RGet("DESCRIPTION",,"@!")) 
self:oStOrd:goTop()
do WHILE !self:oStOrd:EOF
	oReport:PrintLine(@nRij,@nBlad,Str(self:oStOrd:STORDRID,6,0)+cTab+ Pad(Transform(self:oStOrd:ACCNUMBER,"")+Space(1)+Transform(self:oStOrd:accountname,""),21)+cTab+;
	DToC(self:oStOrd:IDAT)+cTab+PadC(Transform(self:oStOrd:day,'999'),9)+cTab+PadC(Transform(self:oStOrd:period,'999'),6)+cTab+;
	Str(self:oStOrd:deb,11,2)+cTab+Str(self:oStOrd:cre,11,2)+cTab+DToC(iif(Empty(self:oStOrd:edat),null_date,self:oStOrd:edat))+cTab+DToC(iif(Empty(self:oStOrd:lstrecording),null_date,self:oStOrd:lstrecording))+cTab+self:oStOrd:DESCRIPTN,aHeading,0)
	self:oStOrd:skip()
ENDDO
oReport:prstart()
oReport:prstop()
self:oStOrd:ResetNotification()
RETURN NIL
METHOD FindButton( ) CLASS PeriodicBrowser
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
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS PeriodicBrowser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"PeriodicBrowser",_GetInst()},iCtlID)

oCCEditButton := PushButton{SELF,ResourceID{PERIODICBROWSER_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:OwnerAlignment := OA_PY

oCCNewButton := PushButton{SELF,ResourceID{PERIODICBROWSER_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}
oCCNewButton:OwnerAlignment := OA_PY

oCCDeleteButton := PushButton{SELF,ResourceID{PERIODICBROWSER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PY

oCCCancelButton := PushButton{SELF,ResourceID{PERIODICBROWSER_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}
oCCCancelButton:OwnerAlignment := OA_PY

oDCSC_REK := FixedText{SELF,ResourceID{PERIODICBROWSER_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,"Account:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{PERIODICBROWSER_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Periodic amounts",NULL_STRING,NULL_STRING}
oDCGroupBox1:OwnerAlignment := OA_HEIGHT

oDCSearchRek := SingleLineEdit{SELF,ResourceID{PERIODICBROWSER_SEARCHREK,_GetInst()}}
oDCSearchRek:HyperLabel := HyperLabel{#SearchRek,NULL_STRING,"The account from which to record",NULL_STRING}
oDCSearchRek:FieldSpec := MEMBERACCOUNT{}
oDCSearchRek:FocusSelect := FSEL_HOME
oDCSearchRek:TooltipText := "The person, who is a subscriber"
oDCSearchRek:UseHLforToolTip := True

oCCAccButtonFrom := PushButton{SELF,ResourceID{PERIODICBROWSER_ACCBUTTONFROM,_GetInst()}}
oCCAccButtonFrom:HyperLabel := HyperLabel{#AccButtonFrom,"v","Browse in from accounts",NULL_STRING}
oCCAccButtonFrom:TooltipText := "Browse in accounts"
oCCAccButtonFrom:UseHLforToolTip := True

oDCFixedText4 := FixedText{SELF,ResourceID{PERIODICBROWSER_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"lines",NULL_STRING,NULL_STRING}

oDCFound := FixedText{SELF,ResourceID{PERIODICBROWSER_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{PERIODICBROWSER_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

oCCFindButton := PushButton{SELF,ResourceID{PERIODICBROWSER_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Find",NULL_STRING,NULL_STRING}

oDCSearchUni := SingleLineEdit{SELF,ResourceID{PERIODICBROWSER_SEARCHUNI,_GetInst()}}
oDCSearchUni:HyperLabel := HyperLabel{#SearchUni,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchUni:FocusSelect := FSEL_TRIM
oDCSearchUni:TooltipText := "Enter one or more (part of) key values "
oDCSearchUni:UseHLforToolTip := True

oDCFixedText5 := FixedText{SELF,ResourceID{PERIODICBROWSER_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Universal:",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{PERIODICBROWSER_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Search",NULL_STRING,NULL_STRING}

SELF:Caption := "Standing Orders"
SELF:HyperLabel := HyperLabel{#PeriodicBrowser,"Standing Orders",NULL_STRING,NULL_STRING}
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

oSFPeriodicBrowser_DETAIL := PeriodicBrowser_DETAIL{SELF,PERIODICBROWSER_PERIODICBROWSER_DETAIL}
oSFPeriodicBrowser_DETAIL:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD NewButton( ) CLASS PeriodicBrowser
	SELF:EditButton(TRUE)
RETURN NIL
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS PeriodicBrowser
	//Put your PostInit additions here
	LOCAL oBank as SQLSelect
	LOCAL lSuccess AS LOGIC
self:SetTexts()
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
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS PeriodicBrowser
	//Put your PreInit additions here
	local lSuccess as logic 
	self:cWhere:=""
	self:cOrder:="l.stordrid,l.seqnr" 
// 	self:cFields:="s.stordrid,s.`day`,s.`period`,s.idat,s.edat,cast(s.lstrecording as date) as lstrecording,s.docid,"+;
// 		"l.accountid,l.deb,l.cre,l.descriptn,l.accountid,a.description as accountname,a.accnumber" 
	self:cFields:="s.stordrid,s.`day`,s.`period`,cast(s.idat as date) as idat,cast(s.edat as date) as edat,cast(s.lstrecording as date) as lstrecording,s.docid,"+;
	 		"l.accountid,l.deb,l.cre,l.descriptn,l.accountid,a.description as accountname,a.accnumber"
	self:aFields:={"s.stordrid","s.day","s.period","s.idat","s.edat","s.lstrecording","s.docid",""+;
		"l.accountid","l.deb","l.cre","l.descriptn","l.accountid","a.description","a.accnumber"}
	self:cFrom:="standingorder s, standingorderline l left join account a on (a.accid=l.accountid)"
	self:oStOrd:=SQLSelect{"select "+self:cFields+" from "+self:cFrom+" where l.stordrid=s.stordrid"+iif(Empty(self:cWhere),""," and "+self:cWhere)+" order by "+self:cOrder,oConn}
	self:oStOrd:Execute()
	

	RETURN NIL
Method Refresh() class PeriodicBrowser
	self:Server:sqlstring:="select "+self:cFields+" from "+self:cFrom+" where l.stordrid=s.stordrid"+iif(Empty(self:cWhere),""," and "+self:cWhere)+" order by "+self:cOrder
	self:Server:Execute() 
	self:oSFPeriodicBrowser_DETAIL:Browser:Refresh()
  	self:oDCFound:TextValue :=Str(self:oStOrd:RecCount,-1)

	return
ACCESS SearchRek() CLASS PeriodicBrowser
RETURN SELF:FieldGet(#SearchRek)

ASSIGN SearchRek(uValue) CLASS PeriodicBrowser
SELF:FieldPut(#SearchRek, uValue)
RETURN uValue

ACCESS SearchREKold() CLASS PeriodicBrowser
RETURN SELF:FieldGet(#SearchREKold)

ASSIGN SearchREKold(uValue) CLASS PeriodicBrowser
SELF:FieldPut(#SearchREKold, uValue)
RETURN uValue

ACCESS SearchRekTo() CLASS PeriodicBrowser
RETURN SELF:FieldGet(#SearchRekTo)

ASSIGN SearchRekTo(uValue) CLASS PeriodicBrowser
SELF:FieldPut(#SearchRekTo, uValue)
RETURN uValue

ACCESS SearchUni() CLASS PeriodicBrowser
RETURN SELF:FieldGet(#SearchUni)

ASSIGN SearchUni(uValue) CLASS PeriodicBrowser
SELF:FieldPut(#SearchUni, uValue)
RETURN uValue

STATIC DEFINE PERIODICBROWSER_ACCBUTTONFROM := 109 
STATIC DEFINE PERIODICBROWSER_CANCELBUTTON := 104 
STATIC DEFINE PERIODICBROWSER_CANCELBUTTON5 := 102 
STATIC DEFINE PERIODICBROWSER_DELETEBUTTON := 103 
STATIC DEFINE PERIODICBROWSER_DELETEBUTTON5 := 101 
CLASS PeriodicBrowser_DETAIL INHERIT DataWindowMine 

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
RESOURCE PeriodicBrowser_DETAIL DIALOGEX  26, 24, 458, 196
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Account number", PERIODICBROWSER_DETAIL_SC_REK, "Static", WS_CHILD, 13, 14, 54, 13
	CONTROL	"Bestemming", PERIODICBROWSER_DETAIL_SC_BESTEMMING, "Static", WS_CHILD, 13, 29, 40, 12
	CONTROL	"Idat", PERIODICBROWSER_DETAIL_SC_IDAT, "Static", WS_CHILD, 13, 44, 14, 12
	CONTROL	"Edat", PERIODICBROWSER_DETAIL_SC_EDAT, "Static", WS_CHILD, 13, 59, 17, 12
	CONTROL	"Boekdag", PERIODICBROWSER_DETAIL_SC_BOEKDAG, "Static", WS_CHILD, 13, 73, 31, 13
	CONTROL	"Account", PERIODICBROWSER_DETAIL_ACCOUNTNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 14, 100, 13, WS_EX_CLIENTEDGE
	CONTROL	"To", PERIODICBROWSER_DETAIL_BESTEMMINGSACC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 29, 100, 12, WS_EX_CLIENTEDGE
	CONTROL	"Start", PERIODICBROWSER_DETAIL_IDAT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 44, 80, 12, WS_EX_CLIENTEDGE
	CONTROL	"End", PERIODICBROWSER_DETAIL_EDAT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 59, 80, 12, WS_EX_CLIENTEDGE
	CONTROL	"Day#", PERIODICBROWSER_DETAIL_DAY, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 73, 36, 13, WS_EX_CLIENTEDGE
	CONTROL	"Description", PERIODICBROWSER_DETAIL_DESCRIPTN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 6, 103, 432, 12, WS_EX_CLIENTEDGE
	CONTROL	"Latest Rec", PERIODICBROWSER_DETAIL_LSTRECORDING, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 76, 118, 80, 12, WS_EX_CLIENTEDGE
END

ACCESS AccountName() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#AccountName)

ASSIGN AccountName(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#AccountName, uValue)
RETURN uValue

ACCESS BESTEMMINGSACC() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#BESTEMMINGSACC)

ASSIGN BESTEMMINGSACC(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#BESTEMMINGSACC, uValue)
RETURN uValue

ACCESS CRE() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#CRE)

ASSIGN CRE(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#CRE, uValue)
RETURN uValue

ACCESS DAY() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#DAY)

ASSIGN DAY(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#DAY, uValue)
RETURN uValue

ACCESS DEB() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#DEB)

ASSIGN DEB(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#DEB, uValue)
RETURN uValue

ACCESS descriptn() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#descriptn)

ASSIGN descriptn(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#descriptn, uValue)
RETURN uValue

ACCESS docid() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#docid)

ASSIGN docid(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#docid, uValue)
RETURN uValue

ACCESS Edat() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#Edat)

ASSIGN Edat(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#Edat, uValue)
RETURN uValue

ACCESS FromAccount() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#FromAccount)

ASSIGN FromAccount(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#FromAccount, uValue)
RETURN uValue

ACCESS IDAT() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#IDAT)

ASSIGN IDAT(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#IDAT, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS PeriodicBrowser_DETAIL 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"PeriodicBrowser_DETAIL",_GetInst()},iCtlID)

oDCSC_REK := FixedText{SELF,ResourceID{PERIODICBROWSER_DETAIL_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,"Account number",NULL_STRING,NULL_STRING}

oDCSC_BESTEMMING := FixedText{SELF,ResourceID{PERIODICBROWSER_DETAIL_SC_BESTEMMING,_GetInst()}}
oDCSC_BESTEMMING:HyperLabel := HyperLabel{#SC_BESTEMMING,"Bestemming",NULL_STRING,NULL_STRING}

oDCSC_IDAT := FixedText{SELF,ResourceID{PERIODICBROWSER_DETAIL_SC_IDAT,_GetInst()}}
oDCSC_IDAT:HyperLabel := HyperLabel{#SC_IDAT,"Idat",NULL_STRING,NULL_STRING}

oDCSC_EDAT := FixedText{SELF,ResourceID{PERIODICBROWSER_DETAIL_SC_EDAT,_GetInst()}}
oDCSC_EDAT:HyperLabel := HyperLabel{#SC_EDAT,"Edat",NULL_STRING,NULL_STRING}

oDCSC_BOEKDAG := FixedText{SELF,ResourceID{PERIODICBROWSER_DETAIL_SC_BOEKDAG,_GetInst()}}
oDCSC_BOEKDAG:HyperLabel := HyperLabel{#SC_BOEKDAG,"Boekdag",NULL_STRING,NULL_STRING}

oDCAccountName := SingleLineEdit{SELF,ResourceID{PERIODICBROWSER_DETAIL_ACCOUNTNAME,_GetInst()}}
oDCAccountName:FieldSpec := account_OMS{}
oDCAccountName:HyperLabel := HyperLabel{#AccountName,"Account","Number of an Account",NULL_STRING}
oDCAccountName:TooltipText := "Account from/to transfer a periodic amount"

oDCBESTEMMINGSACC := SingleLineEdit{SELF,ResourceID{PERIODICBROWSER_DETAIL_BESTEMMINGSACC,_GetInst()}}
oDCBESTEMMINGSACC:FieldSpec := Account_AccNumber{}
oDCBESTEMMINGSACC:HyperLabel := HyperLabel{#BESTEMMINGSACC,"To",NULL_STRING,"Rek_REK"}
oDCBESTEMMINGSACC:TooltipText := "Account to which to transfer a periodic amount"

oDCIDAT := SingleLineEdit{SELF,ResourceID{PERIODICBROWSER_DETAIL_IDAT,_GetInst()}}
oDCIDAT:FieldSpec := PeriodicRec_IDAT{}
oDCIDAT:HyperLabel := HyperLabel{#IDAT,"Start",NULL_STRING,"PeriodicRec_IDAT"}
oDCIDAT:TooltipText := "Date to start with first periodic transfer"

oDCEdat := SingleLineEdit{SELF,ResourceID{PERIODICBROWSER_DETAIL_EDAT,_GetInst()}}
oDCEdat:FieldSpec := PeriodicRec_EDAT{}
oDCEdat:HyperLabel := HyperLabel{#Edat,"End",NULL_STRING,"PeriodicRec_EDAT"}
oDCEdat:TooltipText := "Date to stop with periodic transfer of the amount"

oDCDAY := SingleLineEdit{SELF,ResourceID{PERIODICBROWSER_DETAIL_DAY,_GetInst()}}
oDCDAY:FieldSpec := standingorder_day{}
oDCDAY:HyperLabel := HyperLabel{#DAY,"Day#",NULL_STRING,NULL_STRING}
oDCDAY:TooltipText := "Day in month transfer has to take place"

oDCdescriptn := SingleLineEdit{SELF,ResourceID{PERIODICBROWSER_DETAIL_DESCRIPTN,_GetInst()}}
oDCdescriptn:FieldSpec := StandingOrderLine_DESCRIPTN{}
oDCdescriptn:HyperLabel := HyperLabel{#descriptn,"Description",NULL_STRING,NULL_STRING}
oDCdescriptn:TooltipText := "Description to add to each periodic transaction"

oDClstrecording := SingleLineEdit{SELF,ResourceID{PERIODICBROWSER_DETAIL_LSTRECORDING,_GetInst()}}
oDClstrecording:FieldSpec := standingorder_lstrecording{}
oDClstrecording:HyperLabel := HyperLabel{#lstrecording,"Latest Rec",NULL_STRING,NULL_STRING}
oDClstrecording:TooltipText := "Date of latest actual transfer"

SELF:Caption := ""
SELF:HyperLabel := HyperLabel{#PeriodicBrowser_DETAIL,NULL_STRING,NULL_STRING,NULL_STRING}
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

ACCESS lstrecording() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#lstrecording)

ASSIGN lstrecording(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#lstrecording, uValue)
RETURN uValue

ACCESS Period() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#Period)

ASSIGN Period(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#Period, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class PeriodicBrowser_DETAIL
	//Put your PostInit additions here 
	self:Browser:SetStandardStyle( gbsReadOnly )
	return NIL

METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS PeriodicBrowser_DETAIL
	//Put your PreInit additions here 
	local lSuccess as logic
// 	oWindow:Server:SetRelation(oWindow:oAcc,"accid")		
	oWindow:use(oWindow:oStOrd)
	RETURN nil
ACCESS stordrid() CLASS PeriodicBrowser_DETAIL
RETURN SELF:FieldGet(#stordrid)

ASSIGN stordrid(uValue) CLASS PeriodicBrowser_DETAIL
SELF:FieldPut(#stordrid, uValue)
RETURN uValue

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
STATIC DEFINE PROGRESSPER_PROGRESSBAR := 101 
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
	super:Close(oEvent)
	//Put your changes here
	return nil 
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
	oStLine:=StOrdLineHelp{HelpDir+"\HO"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE} 
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
