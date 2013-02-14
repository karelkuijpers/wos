static define AMNTSND:=11
static define CHECKSAVE:=14
CLASS ConvertMembers INHERIT DataWindowExtra 

	PROTECT oCCParentDepButton AS PUSHBUTTON
	PROTECT oDCParentDep AS SINGLELINEEDIT
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oCCBalIncButton AS PUSHBUTTON
	PROTECT oDCIncomeBal AS SINGLELINEEDIT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oCCBalExpButton AS PUSHBUTTON
	PROTECT oDCExpenseBal AS SINGLELINEEDIT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCNetAsset AS SINGLELINEEDIT
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCIncomeAcc AS SINGLELINEEDIT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oDCExpenseAcc AS SINGLELINEEDIT
	PROTECT oDCFixedText9 AS FIXEDTEXT
	PROTECT oDCFixedText10 AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCFixedText11 AS FIXEDTEXT
	PROTECT oDCFixedText12 AS FIXEDTEXT
	PROTECT oDCFixedText13 AS FIXEDTEXT
	PROTECT oDCFixedText14 AS FIXEDTEXT
	PROTECT oDCFixedText15 AS FIXEDTEXT
	PROTECT oDCNetAssetName AS SINGLELINEEDIT
	PROTECT oDCIncomeAccName AS SINGLELINEEDIT
	PROTECT oDCExpenseAccName AS SINGLELINEEDIT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)    
  protect mParentDep,cCurDep,mBalInc,cCurIncBal,mBalExp,cCurExpBal as string 
  protect incomecat, expensecat as string
protect oCaller as memberbrowser
protect cWhere as String
RESOURCE ConvertMembers DIALOGEX  4, 3, 344, 190
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"v", CONVERTMEMBERS_PARENTDEPBUTTON, "Button", WS_CHILD, 260, 25, 15, 13
	CONTROL	"", CONVERTMEMBERS_PARENTDEP, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 124, 25, 136, 13, WS_EX_CLIENTEDGE
	CONTROL	"Parent department:", CONVERTMEMBERS_FIXEDTEXT1, "Static", WS_CHILD, 12, 25, 83, 13
	CONTROL	"v", CONVERTMEMBERS_BALINCBUTTON, "Button", WS_CHILD, 260, 48, 16, 12
	CONTROL	"", CONVERTMEMBERS_INCOMEBAL, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 124, 48, 136, 12, WS_EX_CLIENTEDGE
	CONTROL	"Balance item of income account:", CONVERTMEMBERS_FIXEDTEXT2, "Static", WS_CHILD, 12, 48, 112, 12
	CONTROL	"v", CONVERTMEMBERS_BALEXPBUTTON, "Button", WS_CHILD, 260, 66, 16, 12
	CONTROL	"", CONVERTMEMBERS_EXPENSEBAL, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 124, 66, 136, 12, WS_EX_CLIENTEDGE
	CONTROL	"Balance item of expense account:", CONVERTMEMBERS_FIXEDTEXT3, "Static", WS_CHILD, 12, 66, 112, 12
	CONTROL	"Netasset account:", CONVERTMEMBERS_FIXEDTEXT4, "Static", WS_CHILD, 12, 110, 72, 13
	CONTROL	"", CONVERTMEMBERS_NETASSET, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 96, 110, 47, 13, WS_EX_CLIENTEDGE
	CONTROL	"-<department #>", CONVERTMEMBERS_FIXEDTEXT5, "Static", WS_CHILD, 143, 110, 63, 13
	CONTROL	"Specify for all departments to be created:", CONVERTMEMBERS_FIXEDTEXT6, "Static", WS_CHILD, 8, 3, 263, 18
	CONTROL	"", CONVERTMEMBERS_INCOMEACC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 96, 129, 47, 12, WS_EX_CLIENTEDGE
	CONTROL	"-<department #>", CONVERTMEMBERS_FIXEDTEXT7, "Static", WS_CHILD, 143, 129, 63, 12
	CONTROL	"Income account:", CONVERTMEMBERS_FIXEDTEXT8, "Static", WS_CHILD, 12, 129, 72, 12
	CONTROL	"", CONVERTMEMBERS_EXPENSEACC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 96, 147, 47, 13, WS_EX_CLIENTEDGE
	CONTROL	"Expense account:", CONVERTMEMBERS_FIXEDTEXT9, "Static", WS_CHILD, 12, 147, 72, 13
	CONTROL	"-<department #>", CONVERTMEMBERS_FIXEDTEXT10, "Static", WS_CHILD, 143, 147, 63, 13
	CONTROL	"OK", CONVERTMEMBERS_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 284, 169, 53, 13
	CONTROL	"Cancel", CONVERTMEMBERS_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 224, 169, 53, 13
	CONTROL	"Department accounts", CONVERTMEMBERS_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 88, 332, 78
	CONTROL	"Numbers", CONVERTMEMBERS_FIXEDTEXT11, "Static", WS_CHILD, 96, 96, 54, 12
	CONTROL	"Names", CONVERTMEMBERS_FIXEDTEXT12, "Static", WS_CHILD, 220, 96, 53, 12
	CONTROL	"<member name> ", CONVERTMEMBERS_FIXEDTEXT13, "Static", WS_CHILD, 220, 110, 53, 13
	CONTROL	"<member name> ", CONVERTMEMBERS_FIXEDTEXT14, "Static", WS_CHILD, 220, 129, 53, 12
	CONTROL	"<member name> ", CONVERTMEMBERS_FIXEDTEXT15, "Static", WS_CHILD, 220, 147, 53, 13
	CONTROL	"", CONVERTMEMBERS_NETASSETNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 276, 110, 54, 13, WS_EX_CLIENTEDGE
	CONTROL	"", CONVERTMEMBERS_INCOMEACCNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 276, 129, 53, 12, WS_EX_CLIENTEDGE
	CONTROL	"", CONVERTMEMBERS_EXPENSEACCNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 276, 147, 53, 13, WS_EX_CLIENTEDGE
END

METHOD BalExpButton(cBalValue ) CLASS ConvertMembers 
	(BalanceItemExplorer{self:Owner,"Balance Item Expense",self:mBalExp,self,cBalValue}):show()
RETURN NIL
METHOD BalIncButton(cBalValue ) CLASS ConvertMembers 
	(BalanceItemExplorer{self:owner,"Balance Item Income",self:mBalInc,self,cBalValue}):show()
RETURN NIL
METHOD CancelButton( ) CLASS ConvertMembers 
	self:endwindow()
RETURN NIL
method EditFocusChange(oEditFocusChangeEvent) class ConvertMembers
	local oControl as Control
	local lGotFocus as logic
	local cCurValue as string 
	local nPntr as int
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	super:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here 
	IF !lGotFocus

		IF oControl:NameSym==#IncomeBal.and.!IsNil(oControl:VALUE).and.!AllTrim(oControl:VALUE)==self:cCurIncBal
			cCurValue:=AllTrim(oControl:VALUE)
			self:cCurBal:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindBal(@cCurValue)
				self:RegBalance(cCurValue,"Balance item Income")
			ELSE
				self:BalIncButton(cCurValue,"Balance item Income")
			ENDIF
		ELSEIF oControl:NameSym==#ExpenseBal.and.!IsNil(oControl:VALUE).and.!AllTrim(oControl:VALUE)==self:cCurExpBal
			cCurValue:=AllTrim(oControl:VALUE)
			self:cCurBal:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindBal(@cCurValue)
				self:RegBalance(cCurValue,"Balance item Expense")
			ELSE
				self:BalExpButton(cCurValue,"Balance item Expense")
			ENDIF
		ELSEIF oControl:NameSym==#ParentDep .and.!IsNil(oControl:VALUE).and.!AllTrim(oControl:VALUE)==self:cCurDep
			cCurValue:=AllTrim(oControl:VALUE)
			self:cCurDep:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindDep(@cCurValue)
				self:RegDepartment(cCurValue,"")
			ELSE
				self:ParentDepButton(cCurValue)
			ENDIF
		endif 
	endif
	return NIL

ACCESS ExpenseAcc() CLASS ConvertMembers
RETURN SELF:FieldGet(#ExpenseAcc)

ASSIGN ExpenseAcc(uValue) CLASS ConvertMembers
SELF:FieldPut(#ExpenseAcc, uValue)
RETURN uValue

ACCESS ExpenseAccName() CLASS ConvertMembers
RETURN SELF:FieldGet(#ExpenseAccName)

ASSIGN ExpenseAccName(uValue) CLASS ConvertMembers
SELF:FieldPut(#ExpenseAccName, uValue)
RETURN uValue

ACCESS ExpenseBal() CLASS ConvertMembers
RETURN SELF:FieldGet(#ExpenseBal)

ASSIGN ExpenseBal(uValue) CLASS ConvertMembers
SELF:FieldPut(#ExpenseBal, uValue)
RETURN uValue

ACCESS IncomeAcc() CLASS ConvertMembers
RETURN SELF:FieldGet(#IncomeAcc)

ASSIGN IncomeAcc(uValue) CLASS ConvertMembers
SELF:FieldPut(#IncomeAcc, uValue)
RETURN uValue

ACCESS IncomeAccName() CLASS ConvertMembers
RETURN SELF:FieldGet(#IncomeAccName)

ASSIGN IncomeAccName(uValue) CLASS ConvertMembers
SELF:FieldPut(#IncomeAccName, uValue)
RETURN uValue

ACCESS IncomeBal() CLASS ConvertMembers
RETURN SELF:FieldGet(#IncomeBal)

ASSIGN IncomeBal(uValue) CLASS ConvertMembers
SELF:FieldPut(#IncomeBal, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS ConvertMembers 
LOCAL DIM aFonts[2] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"ConvertMembers",_GetInst()},iCtlID)

aFonts[1] := Font{,10,"Microsoft Sans Serif"}
aFonts[2] := Font{,8,"Microsoft Sans Serif"}
aFonts[2]:Bold := TRUE

oCCParentDepButton := PushButton{SELF,ResourceID{CONVERTMEMBERS_PARENTDEPBUTTON,_GetInst()}}
oCCParentDepButton:HyperLabel := HyperLabel{#ParentDepButton,"v","Browse in departments",NULL_STRING}
oCCParentDepButton:TooltipText := "Browse in departments"

oDCParentDep := SingleLineEdit{SELF,ResourceID{CONVERTMEMBERS_PARENTDEP,_GetInst()}}
oDCParentDep:HyperLabel := HyperLabel{#ParentDep,NULL_STRING,NULL_STRING,NULL_STRING}
oDCParentDep:TooltipText := "Enter number or name of required Top of department structure"

oDCFixedText1 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Parent department:",NULL_STRING,NULL_STRING}

oCCBalIncButton := PushButton{SELF,ResourceID{CONVERTMEMBERS_BALINCBUTTON,_GetInst()}}
oCCBalIncButton:HyperLabel := HyperLabel{#BalIncButton,"v","Balance item of Income acount",NULL_STRING}
oCCBalIncButton:TooltipText := "Browse in balance items"

oDCIncomeBal := SingleLineEdit{SELF,ResourceID{CONVERTMEMBERS_INCOMEBAL,_GetInst()}}
oDCIncomeBal:HyperLabel := HyperLabel{#IncomeBal,NULL_STRING,"Balance item of Income account",NULL_STRING}
oDCIncomeBal:UseHLforToolTip := True

oDCFixedText2 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Balance item of income account:",NULL_STRING,NULL_STRING}

oCCBalExpButton := PushButton{SELF,ResourceID{CONVERTMEMBERS_BALEXPBUTTON,_GetInst()}}
oCCBalExpButton:HyperLabel := HyperLabel{#BalExpButton,"v","Balance item of Income acount",NULL_STRING}
oCCBalExpButton:TooltipText := "Browse in balance items"

oDCExpenseBal := SingleLineEdit{SELF,ResourceID{CONVERTMEMBERS_EXPENSEBAL,_GetInst()}}
oDCExpenseBal:HyperLabel := HyperLabel{#ExpenseBal,NULL_STRING,"Balance item of expense account",NULL_STRING}
oDCExpenseBal:UseHLforToolTip := True

oDCFixedText3 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Balance item of expense account:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Netasset account:",NULL_STRING,NULL_STRING}

oDCNetAsset := SingleLineEdit{SELF,ResourceID{CONVERTMEMBERS_NETASSET,_GetInst()}}
oDCNetAsset:HyperLabel := HyperLabel{#NetAsset,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"-<department #>",NULL_STRING,NULL_STRING}

oDCFixedText6 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"Specify for all departments to be created:",NULL_STRING,NULL_STRING}
oDCFixedText6:Font(aFonts[1], FALSE)

oDCIncomeAcc := SingleLineEdit{SELF,ResourceID{CONVERTMEMBERS_INCOMEACC,_GetInst()}}
oDCIncomeAcc:HyperLabel := HyperLabel{#IncomeAcc,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"-<department #>",NULL_STRING,NULL_STRING}

oDCFixedText8 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"Income account:",NULL_STRING,NULL_STRING}

oDCExpenseAcc := SingleLineEdit{SELF,ResourceID{CONVERTMEMBERS_EXPENSEACC,_GetInst()}}
oDCExpenseAcc:HyperLabel := HyperLabel{#ExpenseAcc,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText9 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"Expense account:",NULL_STRING,NULL_STRING}

oDCFixedText10 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT10,_GetInst()}}
oDCFixedText10:HyperLabel := HyperLabel{#FixedText10,"-<department #>",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{CONVERTMEMBERS_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{CONVERTMEMBERS_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{CONVERTMEMBERS_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Department accounts",NULL_STRING,NULL_STRING}

oDCFixedText11 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT11,_GetInst()}}
oDCFixedText11:HyperLabel := HyperLabel{#FixedText11,"Numbers",NULL_STRING,NULL_STRING}
oDCFixedText11:Font(aFonts[2], FALSE)

oDCFixedText12 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT12,_GetInst()}}
oDCFixedText12:HyperLabel := HyperLabel{#FixedText12,"Names",NULL_STRING,NULL_STRING}
oDCFixedText12:Font(aFonts[2], FALSE)

oDCFixedText13 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT13,_GetInst()}}
oDCFixedText13:HyperLabel := HyperLabel{#FixedText13,"<member name> ",NULL_STRING,NULL_STRING}

oDCFixedText14 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT14,_GetInst()}}
oDCFixedText14:HyperLabel := HyperLabel{#FixedText14,"<member name> ",NULL_STRING,NULL_STRING}

oDCFixedText15 := FixedText{SELF,ResourceID{CONVERTMEMBERS_FIXEDTEXT15,_GetInst()}}
oDCFixedText15:HyperLabel := HyperLabel{#FixedText15,"<member name> ",NULL_STRING,NULL_STRING}

oDCNetAssetName := SingleLineEdit{SELF,ResourceID{CONVERTMEMBERS_NETASSETNAME,_GetInst()}}
oDCNetAssetName:HyperLabel := HyperLabel{#NetAssetName,NULL_STRING,NULL_STRING,NULL_STRING}

oDCIncomeAccName := SingleLineEdit{SELF,ResourceID{CONVERTMEMBERS_INCOMEACCNAME,_GetInst()}}
oDCIncomeAccName:HyperLabel := HyperLabel{#IncomeAccName,NULL_STRING,NULL_STRING,NULL_STRING}

oDCExpenseAccName := SingleLineEdit{SELF,ResourceID{CONVERTMEMBERS_EXPENSEACCNAME,_GetInst()}}
oDCExpenseAccName:HyperLabel := HyperLabel{#ExpenseAccName,NULL_STRING,NULL_STRING,NULL_STRING}

SELF:Caption := "Convert members to department members"
SELF:HyperLabel := HyperLabel{#ConvertMembers,"Convert members to department members",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS NetAsset() CLASS ConvertMembers
RETURN SELF:FieldGet(#NetAsset)

ASSIGN NetAsset(uValue) CLASS ConvertMembers
SELF:FieldPut(#NetAsset, uValue)
RETURN uValue

ACCESS NetAssetName() CLASS ConvertMembers
RETURN SELF:FieldGet(#NetAssetName)

ASSIGN NetAssetName(uValue) CLASS ConvertMembers
SELF:FieldPut(#NetAssetName, uValue)
RETURN uValue

METHOD OKButton( ) CLASS ConvertMembers 
	// convert selected members
	local oSel,oAss as SQLSelect
	local oStmnt as SQLStatement 
	local cSelect,cSQLStatement,mDepId,maccidInc,mAccidExp,mAccidPrv,cAccPrvNbr,cIncAccNbr,cExpAccNbr,cNetAccNbr as string
	local cFatalError as string
	local nCount as int
	local oWindow as Window 
	local mAlgTaal:=Alg_Taal as string 
	local lError as logic
	
	// check validity:
	if !self:incomecat==income
		ErrorBox{self,"Category of income balance item should be income"}:show() 
		return
	endif
	if !self:expensecat==expense
		ErrorBox{self,"Category of expense balance item should be expense"}:show() 
		return
	endif
	if Empty(self:NetAsset)
		ErrorBox{self,"Specify netasset account number"}:show() 
		return
	endif
	if Empty(self:NetAssetName)
		ErrorBox{self,"Specify netasset account name"}:show() 
		return
	endif
	if Empty( self:IncomeAcc)
		ErrorBox{self,"Specify income account number"}:show() 
		return
	endif
	if Empty( self:IncomeAccName)
		ErrorBox{self,"Specify income account name"}:show() 
		return
	endif
	if Empty(self:ExpenseAcc)
		ErrorBox{self,"Specify expense account number"}:show() 
		return
	endif
	if Empty(self:ExpenseAccName)
		ErrorBox{self,"Specify expense account name"}:show() 
		return
	endif 
	if self:NetAsset==self:IncomeAcc .or.self:NetAsset==self:ExpenseAcc .or.self:IncomeAcc==self:ExpenseAcc 
		ErrorBox{self,self:oLan:WGet("numbers income, expense and netasset should be different")}:show() 
		return
	endif 
	
	self:NetAssetName:=Transform(self:NetAssetName,"!xxxxxxxxxxxxxxxxxxxxx")
	self:IncomeAccName:=Transform(self:IncomeAccName,"!xxxxxxxxxxxxxxxxxxxxx")
	self:ExpenseAccName:=Transform(self:ExpenseAccName,"!xxxxxxxxxxxxxxxxxxxxx")
	// 	dConvdate:=Mindate
	// 	if Today() - dConvdate > 400
	// 		dConvdate:=SToD(Str(Year(Today()),2,0)+StrZero(Month(dConvdate),2,0)+'01')
	// 	endif
	oWindow:=GetParentWindow(self) 
	oWindow:Pointer := Pointer{POINTERHOURGLASS} 

	cSelect:="select a.accid,a.accnumber,a.description,a.clc,a.propxtra,m.mbrid,m.homepp from "+self:oCaller:cFrom+" where "+self:oCaller:cWhere+" and a.active=1 and m.co='M' and m.accid IS NOT NULL and b.category='"+liability+"'"
	oSel:=SqlSelect{cSelect,oConn}
	oSel:Execute()
	do while !oSel:EoF
		// convert each account to member department 
		mAccidPrv:=Str(oSel:accid,-1)
		cAccPrvNbr:= oSel:accnumber
		self:STATUSMESSAGE(self:oLan:WGet('converting')+' '+oSel:accnumber+' '+oSel:Description+' ('+Str(nCount+1,-1)+')')
		if oSel:homePP==sEntity
			alg_taal:=mAlgTaal
		else
			alg_taal:='E'  // for foreign members foreign texts
		endif
		SQLStatement{"start transaction",oConn}:Execute() 
		lError:=false
		// create department: 
		oStmnt:=SQLStatement{"insert into department set "+; 
		"deptmntnbr='"+AddSlashes(cAccPrvNbr)+"',"+;
			"descriptn='"+AddSlashes(oSel:Description)+"',"+;
			"parentdep='"+self:mParentDep+"'",oConn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows<1
			ErrorBox{self,"Could not create member department "+cAccPrvNbr}:show()
			lError:=true
		endif
		if !lError
			mDepId:=ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
			
			// create income account 
			cIncAccNbr:=AddSlashes(LTrimZero(self:IncomeAcc)+'-'+cAccPrvNbr)
			oStmnt:=SQLStatement{"insert into account set "+;
				"accnumber='"+cIncAccNbr+"'"+;
				", description='"+ AddSlashes(AllTrim(oSel:Description))+Space(1)+self:IncomeAccName+"'"+;
				", balitemid='"+self:mBalInc+"'"+;
				", department='"+mDepId+"'"+;
				", giftalwd=1"+;
				", clc='"+Transform(oSel:clc,"")+"',propxtra='"+Transform(oSel:propxtra,"")+"'"+;
				", currency='"+sCURR+"'",oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				LogEvent(self,"Could not create income account for "+cAccPrvNbr+"; error:"+oStmnt:ErrInfo:errormessage+CRLF+;
					+oStmnt:SQLString,"logerrors")
				ErrorBox{self,"Could not create income account for "+cAccPrvNbr}:show()
				lError:=true
			endif
		endif
		if !lError
			maccidInc:=ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
			
			// create expense account
			cExpAccNbr:=AddSlashes(LTrimZero(self:ExpenseAcc)+'-'+cAccPrvNbr)
			oStmnt:=SQLStatement{"insert into account set "+;
				"accnumber='"+cExpAccNbr+"'"+;
				", description='"+ AddSlashes(AllTrim(oSel:Description))+Space(1)+self:ExpenseAccName+"'"+;
				", balitemid='"+self:mBalExp+"'"+;
				", department='"+mDepId+"'"+;
				", currency='"+sCURR+"'",oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				LogEvent(self,"Could not create expense account for "+cAccPrvNbr+"; error:"+oStmnt:ErrInfo:errormessage+CRLF+;
					+oStmnt:SQLString,"logerrors")
				ErrorBox{self,"Could not create expense account for "+cAccPrvNbr}:show()
				lError:=true
			endif
		endif
		if !lError
			mAccidExp:=ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))

			// move member liablility account to new departement and change it
			cNetAccNbr:=AddSlashes(LTrimZero(self:NetAsset)+'-'+cAccPrvNbr)
			oStmnt:=SQLStatement{"update account set department="+mDepId+;
				",description=concat(Description,' "+self:NetAssetName+"'),giftalwd=0,accnumber='"+cNetAccNbr+"'"+;
				" where accid="+mAccidPrv,oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				alg_taal:=mAlgTaal
				ErrorBox{self,"Could not change liability account "+cAccPrvNbr}:show()
				lError:=true
			endif
		endif
		// fill netasset, incomeacc and expenseacc of department
		if !lError
			cSQLStatement:="update department set netasset="+Str(oSel:accid,-1)+",incomeacc="+maccidInc+",expenseacc="+mAccidExp+" where depid="+mDepId
			oStmnt:=SQLStatement{cSQLStatement,oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				ErrorBox{self,"Could not change department "+cAccPrvNbr}:show()
				lError:=true
			endif
		endif
		// change Member 
		if !lError
			oStmnt:=SQLStatement{ "update member set accid=NULL, depid="+mDepId+" where mbrid="+Str(oSel:mbrid,-1),oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				ErrorBox{self,"Could not change member "+cAccPrvNbr}:show()
				lError:=true
			endif
		endif
		if !lError
			// change subscriptions to new income account 
			oStmnt:SQLString:="update subscription set "+sIdentChar+"accid"+sIdentChar+"="+maccidInc+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				lError:=true
			endif
		endif
		if !lError
			//	change standing orders to new	expense or income	account:
			oStmnt:SQLString:="update standingorderline set	"+sIdentChar+"accountid"+sIdentChar+"="+maccidInc+" where "+sIdentChar+"accountid"+sIdentChar+"="+mAccidPrv	+"	and cre>deb"
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				lError:=true
			endif
		endif
		if !lError
			oStmnt:SQLString:="update standingorderline set	"+sIdentChar+"accountid"+sIdentChar+"="+mAccidExp+" where "+sIdentChar+"accountid"+sIdentChar+"="+mAccidPrv	+"	and deb>cre"
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				lError:=true
			endif
		endif
		if !lError
			//	change telepatterns
			oStmnt:SQLString:="update telebankpatterns set "+sIdentChar+"accid"+sIdentChar+"="+maccidInc+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv +"	and addsub='B'"
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				lError:=true
			endif
		endif
		if !lError
			oStmnt:SQLString:="update telebankpatterns set "+sIdentChar+"accid"+sIdentChar+"="+mAccidExp+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv	+"	and addsub='A'"
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				lError:=true
			endif
		endif
		if !lError
			//	change import patterns
			oStmnt:SQLString:="update importpattern set "+sIdentChar+"accid"+sIdentChar+"="+maccidInc+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv +"	and debcre='C'"
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				lError:=true
			endif
		endif
		if !lError
			oStmnt:SQLString:="update importpattern set "+sIdentChar+"accid"+sIdentChar+"="+mAccidExp+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv	+"	and debcre='D'"
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				lError:=true
			endif
		endif
		if !lError
			//	change bankaccount single destination:
			oStmnt:SQLString:="update bankaccount set	"+sIdentChar+"singledst"+sIdentChar+"="+maccidInc+" where "+sIdentChar+"singledst"+sIdentChar+"="+mAccidPrv	
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				lError:=true
			endif
		endif
		if !lError
			
			//	change transactions not	yet sent	to	PMC: 
			if	(!Empty(SINCHOME)	.or.!Empty(SINC))
				//	remove recordings	to	gift income/expense:
				oStmnt:SQLString:='delete from transaction where (accid='+SINC+iif(SINC==SINCHOME,'','	or	accid='+SINCHOME)+' or accid='+SEXP+;
					iif(SEXP==SEXPHOME,'','	or	accid='+SEXPHOME)+')	and '+;
					'`transid` in (select `transid` from (select	transid from transaction b	where	b.accid='+mAccidPrv+' and bfm="" and	b.gc<>"") as x)'
				//	and `transid` in (select `transid` from( select	`transid` from	transaction	b where b.accid=100412 and	b.bfm=""	and b.gc<>"") as x)
				oStmnt:Execute()
				if !Empty(oStmnt:status)
					lError:=true
				endif
			endif	  
		endif
		if !lError
			oStmnt:SQLString:="update transaction set	"+sIdentChar+"accid"+sIdentChar+"="+mAccidExp+"	where	"+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv +" and bfm='' and gc='CH'"
			oStmnt:Execute() 
			if !Empty(oStmnt:status)
				lError:=true
			endif
		endif
		if !lError
			oStmnt:SQLString:="update transaction set	"+sIdentChar+"accid"+sIdentChar+"="+maccidInc+"	where	"+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv +" and bfm='' and gc in ('AG','MG')"
			oStmnt:Execute() 
			if !Empty(oStmnt:status)
				lError:=true
			endif
		endif
		if !lError
			// change importtrans not yet processed: ???  (normally all immediately after import processed) 
			if ConI(SqlSelect{"select count(*) as total from importtrans where processed=0",oConn}:total)>0
				oStmnt:SQLString:="update importtrans set "+sIdentChar+"accountnr"+sIdentChar+"='"+cIncAccNbr+;
					"' where "+sIdentChar+"accountnr"+sIdentChar+"='"+cAccPrvNbr +"' and processed=0 and assmntcd in ('AG','MG')"
				oStmnt:Execute()
				if !Empty(oStmnt:status)
					lError:=true
				endif
				oStmnt:SQLString:="update importtrans set "+sIdentChar+"accountnr"+sIdentChar+"='"+cNetAccNbr+;
					"' where "+sIdentChar+"accountnr"+sIdentChar+"='"+cAccPrvNbr +"' and processed=0 and assmntcd='PF'"
				oStmnt:Execute()
				if !Empty(oStmnt:status)
					lError:=true
				endif
				oStmnt:SQLString:="update importtrans set "+sIdentChar+"accountnr"+sIdentChar+"='"+cExpAccNbr+;
					"' where "+sIdentChar+"accountnr"+sIdentChar+"='"+cAccPrvNbr +"' and processed=0 and assmntcd='CH'"
				oStmnt:Execute() 
				if !Empty(oStmnt:status)
					lError:=true
				endif
			endif
		endif
		if !lError
			// move associated accounts not belonging to project department to this department and remove them
			oAss:=SqlSelect{"select ma.accid from memberassacc ma,account a where ma.accid=a.accid and a.accid=ma.accid and a.department=0 and ma.mbrid="+Str(oSel:mbrid,-1),oConn}
			if oAss:RecCount>0 
				cSelect:=Implode(oAss:GetLookupTable(40,#accid,#accid),",",,,1)
				oStmnt:=SQLStatement{"update account a set department="+mDepId+" where accid in ("+cSelect+")",oConn}
				oStmnt:Execute()
				if !Empty(oStmnt:status)
					lError:=true
				endif
				if oStmnt:NumSuccessfulRows>0
					// remove associated accounts from member:
					oStmnt:=SQLStatement{"delete from memberassacc where accid in ("+cSelect+")",oConn}
					oStmnt:Execute()
					if !Empty(oStmnt:status)
						lError:=true
					endif
				endif
			endif
		endif
		if lError
			SQLStatement{"rollback",oConn}:Execute()
		else
			SQLStatement{"commit",oConn}:Execute()
			nCount++
		endif			
		oSel:Skip()
	enddo
	Alg_Taal:=mAlgTaal
	self:STATUSMESSAGE(self:oLan:WGet('Updating balances')+'...')
	// correct month balances data
	CheckConsistency(oMainWindow,true,false,@cFatalError)	
	oWindow:Pointer := Pointer{POINTERARROW}
	TextBox{self,"Converting members to departments",Str(nCount,-1)+" members converted"}:show() 
	self:oCaller:FindButton()
	self:EndWindow()
	self:Close()
	RETURN nil
ACCESS ParentDep() CLASS ConvertMembers
RETURN SELF:FieldGet(#ParentDep)

ASSIGN ParentDep(uValue) CLASS ConvertMembers
SELF:FieldPut(#ParentDep, uValue)
RETURN uValue

METHOD ParentDepButton(cCurValue ) CLASS ConvertMembers 
	(DepartmentExplorer{self:Owner,"Department parent",self:mParentDep,self,cCurValue}):show()
RETURN NIL
method PostInit(oWindow,iCtlID,oServer,uExtra) class ConvertMembers
	//Put your PostInit additions here
	local oSel as SQLSelect
	local cMemberWhere,cStmnt as string
	local mAlgTaal:=Alg_Taal as string
	local nW as int 
	local aWord:={} as array
	self:SetTexts() 
	self:oCaller:=uExtra 
	self:cWhere:=self:oCaller:cWhere+" and co='M' and m.accid IS NOT NULL"
	// search for existing member department: 
	if self:oCaller:HomeBox
		if !self:oCaller:NonHomeBox
			cMemberWhere:=" and homepp='"+sEntity+"'"
		endif
	elseif self:oCaller:NonHomeBox
		Alg_Taal:='E'
		cMemberWhere:=" and homepp<>'"+sEntity+"'"
	endif

		
	cStmnt:="select pd.deptmntnbr,pd.descriptn,pd.depid,an.accnumber as netnumber,an.description as netname"+;
	",ai.accnumber as incnumber,ai.balitemid as incbal,ai.description as incomename"+;
	",ae.accnumber as expnumber,ae.description as expensename,ae.balitemid as expbal,bi.number as incbalnum,bi.heading as incheading,bi.category as incomecat,"+;
	"be.number as expbalnum,be.heading as expheading,be.category as expensecat "+;
	"from department d left join department pd on (pd.depid=d.parentdep) left join account an on (an.accid=d.netasset) "+;
	" left join account ai on (ai.accid=d.incomeacc) left join balanceitem bi on(bi.balitemid=ai.balitemid) "+;
	"left join account ae on (ae.accid=d.expenseacc) left join balanceitem be on(be.balitemid=ae.balitemid) "+;
	"where exists (select 1 from member where depid=d.depid and co='M' and depid IS NOT NULL"
	oSel:=SqlSelect{cStmnt+cMemberWhere+") limit 1",oConn} 
	if oSel:RecCount<1
		oSel:=SqlSelect{cStmnt+") limit 1",oConn}
	endif 
	if oSel:RecCount>0
		self:cCurDep:=AllTrim(oSel:DEPTMNTNBR)+":"+oSel:DESCRIPTN
		self:ParentDep:=self:cCurDep
  		self:mParentDep:=Str(oSel:depid,-1)
		self:mBalExp:=iif(Empty(oSel:expbal),'',Str(oSel:expbal,-1))
		IF	Empty(self:mBalExp)
			self:cCurExpBal:="0:Balance Items"
		ELSE
			self:cCurExpBal:=AllTrim(oSel:expbalnum)+":"+oSel:expheading
		ENDIF
		self:ExpenseBal:=self:cCurExpBal
		self:mBalInc:=iif(Empty(oSel:Incbal),'',Str(oSel:Incbal,-1))
		IF	Empty(self:mBalInc)
			self:cCurIncBal:="0:Balance Items"
		ELSE
			self:cCurIncBal:=AllTrim(oSel:Incbalnum)+":"+oSel:Incheading
		ENDIF
		self:IncomeBal:=self:cCurIncBal
		self:IncomeAcc:=Split(oSel:incnumber,'-')[1]
		self:ExpenseAcc:=Split(oSel:expnumber,'-')[1]
		self:NetAsset:=Split(oSel:netnumber,'-')[1] 
		self:incomecat:=oSel:incomecat 
		self:expensecat:=oSel:expensecat
		aWord:=Split(oSel:NetName)
		nW:=Len(aWord)
		if nW>1 
			self:NetAssetName:=aWord[nW]
		else
			self:NetAssetName:=self:oLan:WGet('Fund')
		endif	
		aWord:=Split(oSel:IncomeName)
		nW:=Len(aWord)
		if nW>1 
			self:IncomeAccName:=aWord[nW]
		else
			self:IncomeAccName:=self:oLan:WGet('Income')
		endif	
		aWord:=Split(oSel:ExpenseName)
		nW:=Len(aWord)
		if nW>1 
			self:ExpenseAccName:=aWord[nW]
		else
			self:ExpenseAccName:=self:oLan:WGet('Expense')
		endif	
	else
		self:cCurDep:="0:"+sEntity+" "+sLand
		self:ParentDep:=self:cCurDep
		self:mParentDep:=''
		self:cCurExpBal:="0:Balance Items"
		self:ExpenseBal:=self:cCurExpBal 
		self:mBalExp:=''
		self:mBalInc:=''
		self:cCurIncBal:="0:Balance Items"
		self:IncomeBal:=self:cCurIncBal
		self:IncomeAcc:='80000'
		self:ExpenseAcc:='40000'
		self:NetAsset:='17000' 
		self:NetAssetName:=self:oLan:WGet('Fund')
		self:IncomeAccName :=self:oLan:WGet('Income')
		self:ExpenseAccName :=self:oLan:WGet('Expense')
		self:incomecat:=INCOME
		self:expensecat:=EXPENSE
	endif
   Alg_Taal:=mAlgTaal
	  
	
	return NIL

STATIC DEFINE CONVERTMEMBERS_BALEXPBUTTON := 106 
STATIC DEFINE CONVERTMEMBERS_BALINCBUTTON := 103 
STATIC DEFINE CONVERTMEMBERS_CANCELBUTTON := 120 
STATIC DEFINE CONVERTMEMBERS_EXPENSEACC := 116 
STATIC DEFINE CONVERTMEMBERS_EXPENSEACCNAME := 129 
STATIC DEFINE CONVERTMEMBERS_EXPENSEBAL := 107 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT1 := 102 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT10 := 118 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT11 := 122 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT12 := 123 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT13 := 124 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT14 := 125 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT15 := 126 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT2 := 105 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT3 := 108 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT4 := 109 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT5 := 111 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT6 := 112 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT7 := 114 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT8 := 115 
STATIC DEFINE CONVERTMEMBERS_FIXEDTEXT9 := 117 
STATIC DEFINE CONVERTMEMBERS_GROUPBOX1 := 121 
STATIC DEFINE CONVERTMEMBERS_INCOMEACC := 113 
STATIC DEFINE CONVERTMEMBERS_INCOMEACCNAME := 128 
STATIC DEFINE CONVERTMEMBERS_INCOMEBAL := 104 
STATIC DEFINE CONVERTMEMBERS_NETASSET := 110 
STATIC DEFINE CONVERTMEMBERS_NETASSETNAME := 127 
STATIC DEFINE CONVERTMEMBERS_OKBUTTON := 119 
STATIC DEFINE CONVERTMEMBERS_PARENTDEP := 101 
STATIC DEFINE CONVERTMEMBERS_PARENTDEPBUTTON := 100 
static define CURRENCY:=9
static define DESCRPTN:=8
static define DESTACC:=3
static define DESTAMT:=6
static define DESTPP:=4
static define DESTTYP:=5
static define DFIA:=13
static define DFIR:= 12
static define DISABLED:=10
CLASS EditDistribution INHERIT DataWindowExtra 

	PROTECT oDCMemberText AS FIXEDTEXT
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCperc AS FIXEDTEXT
	PROTECT oDCmDestAmt AS MYSINGLEEDIT
	PROTECT oDCmDestAcc AS SINGLELINEEDIT
	PROTECT oDCmDestPP AS COMBOBOX
	PROTECT oDCmDestTyp AS COMBOBOX
	PROTECT oDCFixedText10 AS FIXEDTEXT
	PROTECT oDCAmountTxt AS FIXEDTEXT
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oDCAccountFix AS FIXEDTEXT
	PROTECT oDCFixedText9 AS FIXEDTEXT
	PROTECT oDCmDescription AS SINGLELINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCCurrencyGroup AS RADIOBUTTONGROUP
	PROTECT oCCCurrencyButton1 AS RADIOBUTTON
	PROTECT oCCCurrencyButton2 AS RADIOBUTTON
	PROTECT oDCCheckBoxActive AS CHECKBOX
	PROTECT oDCChecBoxSingelUse AS CHECKBOX
	PROTECT oCCAccButton AS PUSHBUTTON

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	instance mDestAmt 
	instance mDestAcc 
	instance mDestPP 
	instance mDestTyp 
	instance mDescription 
	instance CurrencyGroup 
	instance CheckBoxActive 
	PROTECT lNew as LOGIC
	PROTECT nCurRec AS INT
	PROTECT mMbrId,mSeq as STRING
	PROTECT oCaller as Window 
	protect OwnPPCode as string 
	protect oDis as SQLSelect
	protect aDis:={} as array // contains content of distribution instruction 
	protect nPos as int // position of aDis within aDistr of caller 
	protect cAccountName as string

	declare method ValidateDistribution  
RESOURCE EditDistribution DIALOGEX  20, 18, 334, 178
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Fixed Text", EDITDISTRIBUTION_MEMBERTEXT, "Static", WS_CHILD, 68, 10, 144, 12
	CONTROL	"Member:", EDITDISTRIBUTION_FIXEDTEXT1, "Static", WS_CHILD, 8, 11, 54, 13
	CONTROL	"%", EDITDISTRIBUTION_PERC, "Static", WS_CHILD, 216, 88, 30, 12
	CONTROL	"", EDITDISTRIBUTION_MDESTAMT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 168, 88, 48, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITDISTRIBUTION_MDESTACC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 68, 62, 238, 13, WS_EX_CLIENTEDGE
	CONTROL	"PP Codes", EDITDISTRIBUTION_MDESTPP, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 68, 35, 123, 142
	CONTROL	"type of amount to be distributed of gifts", EDITDISTRIBUTION_MDESTTYP, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 68, 88, 68, 72
	CONTROL	"Type of amount", EDITDISTRIBUTION_FIXEDTEXT10, "Static", WS_CHILD, 8, 88, 56, 12
	CONTROL	"amount", EDITDISTRIBUTION_AMOUNTTXT, "Static", WS_CHILD, 140, 88, 27, 12
	CONTROL	"Receiving PP", EDITDISTRIBUTION_FIXEDTEXT8, "Static", WS_CHILD, 8, 35, 56, 13
	CONTROL	"Account", EDITDISTRIBUTION_ACCOUNTFIX, "Static", WS_CHILD, 8, 62, 59, 13
	CONTROL	"Description", EDITDISTRIBUTION_FIXEDTEXT9, "Static", WS_CHILD, 10, 126, 53, 12
	CONTROL	"", EDITDISTRIBUTION_MDESCRIPTION, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 68, 125, 254, 12, WS_EX_CLIENTEDGE
	CONTROL	"OK", EDITDISTRIBUTION_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 268, 148, 54, 12
	CONTROL	"Cancel", EDITDISTRIBUTION_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 210, 148, 54, 12
	CONTROL	"Currency of amount", EDITDISTRIBUTION_CURRENCYGROUP, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 248, 81, 74, 39
	CONTROL	"own currency", EDITDISTRIBUTION_CURRENCYBUTTON1, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 252, 89, 68, 11
	CONTROL	"US Dollar", EDITDISTRIBUTION_CURRENCYBUTTON2, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 253, 104, 61, 11
	CONTROL	"Active", EDITDISTRIBUTION_CHECKBOXACTIVE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 213, 10, 34, 11
	CONTROL	"Single use", EDITDISTRIBUTION_CHECBOXSINGELUSE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 212, 25, 80, 12
	CONTROL	"v", EDITDISTRIBUTION_ACCBUTTON, "Button", WS_CHILD|NOT WS_VISIBLE, 305, 62, 15, 13
END

METHOD AccButton(lUnique ) CLASS EditDistribution 
	LOCAL cfilter as string
	LOCAL aExclRek:={},aInclRek:={} as ARRAY 
	local oSel as SQLSelect	
	Default(@lUnique,false) 
	if self:oCaller:AccDepSelect='account'
		if !Empty(self:oCaller:mREK)
			aExclRek:={self:oCaller:mREK}
		endif
	else
		if !Empty(self:oCaller:cCurDep)
			oSel:=SqlSelect{"select netasset,incomeacc,expenseacc from department where d.depid="+self:oCaller:cCurDep,oConn}
			if oSel:RecCount>0
				if !Empty(oSel:netasset)
					aadd(aExclRek,str(oSel:netasset,-1))
				endif
				if !Empty(oSel:incomeacc)
					aadd(aExclRek,str(oSel:incomeacc,-1))
				endif
				if !Empty(oSel:expenseacc)
					aadd(aExclRek,str(oSel:expenseacc,-1))
				endif 
			endif
		endif
	endif
	cfilter:=MakeFilter(,,"N",,,aExclRek)
	AccountSelect(self,AllTrim(self:oDCmDestAcc:TEXTValue ),"Account Destination",lUnique,cfilter,,,)

RETURN NIL
METHOD CancelButton( ) CLASS EditDistribution
SELF:EndWindow()
	
RETURN NIL
ACCESS ChecBoxSingelUse() CLASS EditDistribution
RETURN SELF:FieldGet(#ChecBoxSingelUse)

ASSIGN ChecBoxSingelUse(uValue) CLASS EditDistribution
SELF:FieldPut(#ChecBoxSingelUse, uValue)
RETURN uValue

ACCESS CheckBoxActive() CLASS EditDistribution
RETURN SELF:FieldGet(#CheckBoxActive)

ASSIGN CheckBoxActive(uValue) CLASS EditDistribution
SELF:FieldPut(#CheckBoxActive, uValue)
RETURN uValue

METHOD Close(oEvent) CLASS EditDistribution
	//Put your changes here 
	SELF:Destroy()
	// force garbage collection
	//CollectForced()

	RETURN SUPER:Close(oEvent)

ACCESS CurrencyGroup() CLASS EditDistribution
RETURN SELF:FieldGet(#CurrencyGroup)

ASSIGN CurrencyGroup(uValue) CLASS EditDistribution
SELF:FieldPut(#CurrencyGroup, uValue)
RETURN uValue

method EditFocusChange(oEditFocusChangeEvent) class EditDistribution
	local oControl as Control
	local lGotFocus as logic
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	super:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus .and. self:mDestPP=SEntity
		IF oControl:Name == "MDESTACC".and. !AllTrim(oControl:VALUE)==AllTrim(self:cAccountName)
			self:cAccountName:=AllTrim(oControl:VALUE)
			self:AccButton(true)
		endif		
	endif
	return nil

method FillDestTypes() class EditDistribution
	if self:mDestPP='ACH' 
		Return {{DistributionTypes[1],0},{DistributionTypes[2],1},{DistributionTypes[3],2},{DistributionTypes[4],3}}
	else
		Return {{DistributionTypes[1],0},{DistributionTypes[2],1},{DistributionTypes[3],2}}
	endif
	
method FillPPCodes() class EditDistribution
return SqlSelect{"select ppname,ppcode from ppcodes",oConn}:GetlookUpTable() 
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditDistribution 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditDistribution",_GetInst()},iCtlID)

oDCMemberText := FixedText{SELF,ResourceID{EDITDISTRIBUTION_MEMBERTEXT,_GetInst()}}
oDCMemberText:HyperLabel := HyperLabel{#MemberText,"Fixed Text",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{EDITDISTRIBUTION_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Member:",NULL_STRING,NULL_STRING}

oDCperc := FixedText{SELF,ResourceID{EDITDISTRIBUTION_PERC,_GetInst()}}
oDCperc:HyperLabel := HyperLabel{#perc,"%",NULL_STRING,NULL_STRING}

oDCmDestAmt := mySingleEdit{SELF,ResourceID{EDITDISTRIBUTION_MDESTAMT,_GetInst()}}
oDCmDestAmt:HyperLabel := HyperLabel{#mDestAmt,NULL_STRING,"amount per month",NULL_STRING}
oDCmDestAmt:FieldSpec := Transaction_CRE{}
oDCmDestAmt:UseHLforToolTip := True

oDCmDestAcc := SingleLineEdit{SELF,ResourceID{EDITDISTRIBUTION_MDESTACC,_GetInst()}}
oDCmDestAcc:HyperLabel := HyperLabel{#mDestAcc,NULL_STRING,"Destination account for the amounts within the receiving PP",NULL_STRING}
oDCmDestAcc:UseHLforToolTip := True

oDCmDestPP := combobox{SELF,ResourceID{EDITDISTRIBUTION_MDESTPP,_GetInst()}}
oDCmDestPP:HyperLabel := HyperLabel{#mDestPP,"PP Codes","PP code of home of member",NULL_STRING}
oDCmDestPP:UseHLforToolTip := True
oDCmDestPP:FillUsing(Self:FillPPCodes( ))

oDCmDestTyp := combobox{SELF,ResourceID{EDITDISTRIBUTION_MDESTTYP,_GetInst()}}
oDCmDestTyp:FillUsing(Self:FillDestTypes( ))
oDCmDestTyp:HyperLabel := HyperLabel{#mDestTyp,"type of amount to be distributed of gifts","type of amount to be distributed of gifts",NULL_STRING}
oDCmDestTyp:UseHLforToolTip := True

oDCFixedText10 := FixedText{SELF,ResourceID{EDITDISTRIBUTION_FIXEDTEXT10,_GetInst()}}
oDCFixedText10:HyperLabel := HyperLabel{#FixedText10,"Type of amount",NULL_STRING,NULL_STRING}

oDCAmountTxt := FixedText{SELF,ResourceID{EDITDISTRIBUTION_AMOUNTTXT,_GetInst()}}
oDCAmountTxt:HyperLabel := HyperLabel{#AmountTxt,"amount",NULL_STRING,NULL_STRING}

oDCFixedText8 := FixedText{SELF,ResourceID{EDITDISTRIBUTION_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"Receiving PP",NULL_STRING,NULL_STRING}

oDCAccountFix := FixedText{SELF,ResourceID{EDITDISTRIBUTION_ACCOUNTFIX,_GetInst()}}
oDCAccountFix:HyperLabel := HyperLabel{#AccountFix,"Account",NULL_STRING,NULL_STRING}

oDCFixedText9 := FixedText{SELF,ResourceID{EDITDISTRIBUTION_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"Description",NULL_STRING,NULL_STRING}

oDCmDescription := SingleLineEdit{SELF,ResourceID{EDITDISTRIBUTION_MDESCRIPTION,_GetInst()}}
oDCmDescription:HyperLabel := HyperLabel{#mDescription,NULL_STRING,NULL_STRING,"Description to be added to that of the PMC transaction"}
oDCmDescription:UseHLforToolTip := True
oDCmDescription:FieldSpec := DistributionInstruction_DESCRPTN{}

oCCOKButton := PushButton{SELF,ResourceID{EDITDISTRIBUTION_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITDISTRIBUTION_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oCCCurrencyButton1 := RadioButton{SELF,ResourceID{EDITDISTRIBUTION_CURRENCYBUTTON1,_GetInst()}}
oCCCurrencyButton1:HyperLabel := HyperLabel{#CurrencyButton1,"own currency",NULL_STRING,NULL_STRING}

oCCCurrencyButton2 := RadioButton{SELF,ResourceID{EDITDISTRIBUTION_CURRENCYBUTTON2,_GetInst()}}
oCCCurrencyButton2:HyperLabel := HyperLabel{#CurrencyButton2,"US Dollar",NULL_STRING,NULL_STRING}

oDCCheckBoxActive := CheckBox{SELF,ResourceID{EDITDISTRIBUTION_CHECKBOXACTIVE,_GetInst()}}
oDCCheckBoxActive:HyperLabel := HyperLabel{#CheckBoxActive,"Active","Apply this instruction when sending to PMC?",NULL_STRING}
oDCCheckBoxActive:UseHLforToolTip := True

oDCChecBoxSingelUse := CheckBox{SELF,ResourceID{EDITDISTRIBUTION_CHECBOXSINGELUSE,_GetInst()}}
oDCChecBoxSingelUse:HyperLabel := HyperLabel{#ChecBoxSingelUse,"Single use",NULL_STRING,NULL_STRING}
oDCChecBoxSingelUse:TooltipText := "Deactivate after distribution"

oCCAccButton := PushButton{SELF,ResourceID{EDITDISTRIBUTION_ACCBUTTON,_GetInst()}}
oCCAccButton:HyperLabel := HyperLabel{#AccButton,"v","Browse in accounts",NULL_STRING}
oCCAccButton:TooltipText := "Browse in accounts/departments"

oDCCurrencyGroup := RadioButtonGroup{SELF,ResourceID{EDITDISTRIBUTION_CURRENCYGROUP,_GetInst()}}
oDCCurrencyGroup:FillUsing({ ;
								{oCCCurrencyButton1,"own"}, ;
								{oCCCurrencyButton2,"dollar"} ;
								})
oDCCurrencyGroup:HyperLabel := HyperLabel{#CurrencyGroup,"Currency of amount",NULL_STRING,NULL_STRING}

SELF:Caption := "Edit Distribution Instruction"
SELF:HyperLabel := HyperLabel{#EditDistribution,"Edit Distribution Instruction",NULL_STRING,NULL_STRING}
SELF:AllowServerClose := False

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListBoxSelect(oControlEvent) CLASS EditDistribution
	LOCAL oControl as Control, uValue as USUAL 
	local nCur as int
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControlEvent:NameSym==#mDestTyp
		uValue:=oControlEvent:Control:Value
		IF uValue=1  // "proportional"
			SELF:oDCperc:TextValue:="%"
			SELF:oDCAmountTxt:Hide()
			SELF:oDCmDestAmt:HyperLabel:Description:="percentage of balance of member account"
		ELSE
			SELF:oDCAmountTxt:Show()
			SELF:oDCperc:TextValue:="a month"
			IF uValue>=2  // "remaining"
				SELF:oDCAmountTxt:TextValue:="up to"
				self:oDCmDestAmt:HyperLabel:Description:="maximum amount a month; 0 means no limit"
			ELSE
				SELF:oDCAmountTxt:TextValue:="amount"
				SELF:oDCmDestAmt:HyperLabel:Description:="fixed amount per month"
			ENDIF
		ENDIF

		IF uValue=1  // proportional
			self:oDCCurrencyGroup:Hide()
			self:oCCCurrencyButton1:Hide()
			self:oCCCurrencyButton2:Hide()
		ELSE     // fixed or remaining
			self:oDCCurrencyGroup:Show()
			self:oCCCurrencyButton1:Show()
			self:oCCCurrencyButton2:Show()
		ENDIF
	ELSEIF oControlEvent:NameSym==#mDestPP
		nCur:=self:oDCmDestTyp:Value
		self:oDCmDestTyp:FillUsing(self:FillDestTypes()) 
		self:mDestTyp:=nCur
		SELF:oDCmDestAcc:Show()
		self:odcAccountFix:Show()
		if self:oDCmDestPP:Value="AAA"
			self:odcAccountFix:TextValue:="Bank Number:"
		else
			self:odcAccountFix:TextValue:="Account:"
		endif
		if self:oDCmDestPP:Value=sEntity
			self:oCCAccButton:Show()
		else
			self:oCCAccButton:Hide()
		endif
	ENDIF
	RETURN NIL

ACCESS mCHECKSAVE() CLASS EditDistribution
RETURN SELF:FieldGet(#mCHECKSAVE)

ASSIGN mCHECKSAVE(uValue) CLASS EditDistribution
SELF:FieldPut(#mCHECKSAVE, uValue)
RETURN uValue

ACCESS mDescription() CLASS EditDistribution
RETURN SELF:FieldGet(#mDescription)

ASSIGN mDescription(uValue) CLASS EditDistribution
SELF:FieldPut(#mDescription, uValue)
RETURN uValue

ACCESS mDestAcc() CLASS EditDistribution
RETURN SELF:FieldGet(#mDestAcc)

ASSIGN mDestAcc(uValue) CLASS EditDistribution
SELF:FieldPut(#mDestAcc, uValue)
RETURN uValue

ACCESS mDestAmt() CLASS EditDistribution
RETURN SELF:FieldGet(#mDestAmt)

ASSIGN mDestAmt(uValue) CLASS EditDistribution
SELF:FieldPut(#mDestAmt, uValue)
RETURN uValue

ACCESS mDestPP() CLASS EditDistribution
RETURN SELF:FieldGet(#mDestPP)

ASSIGN mDestPP(uValue) CLASS EditDistribution
SELF:FieldPut(#mDestPP, uValue)
RETURN uValue

ACCESS mDestTyp() CLASS EditDistribution
RETURN SELF:FieldGet(#mDestTyp)

ASSIGN mDestTyp(uValue) CLASS EditDistribution
SELF:FieldPut(#mDestTyp, uValue)
RETURN uValue

ACCESS mDFIA() CLASS EditDistribution
RETURN SELF:FieldGet(#mDFIA)

ASSIGN mDFIA(uValue) CLASS EditDistribution
SELF:FieldPut(#mDFIA, uValue)
RETURN uValue

ACCESS mDFIR() CLASS EditDistribution
RETURN SELF:FieldGet(#mDFIR)

ASSIGN mDFIR(uValue) CLASS EditDistribution
SELF:FieldPut(#mDFIR, uValue)
RETURN uValue

METHOD OKButton( ) CLASS EditDistribution
local oLast as SQLSelect 
local cStatement as string
local oStmnt as SQLStatement 
local nSeq as int
IF SELF:ValidateDistribution()
	if self:lNew
		ASize(aDis,15)
		aDis[mbrid]:=Val(self:mMbrId)
		aDis[SEQNBR]:=self:oCaller:maxseq
		self:oCaller:maxseq++ 
		// expand aDistr of oCaller:
	endif
	aDis[DESCRPTN]:=AllTrim(self:mDescription)
	aDis[DESTPP]:= AllTrim(self:mDestPP)
	aDis[DESTACC]:= iif(Empty(self:mDestPP),"",AllTrim(self:mDestAcc))
	aDis[DESTAMT]:=iif(Empty(self:mDestPP),0.00,self:mDestAmt)
	aDis[DESTTYP]:= iif(Empty(self:mDestPP),0,oDCmDestTyp:CurrentItemNo-1)
	aDis[CURRENCY]:=iif(self:CurrencyGroup=="dollar",1,0)
	aDis[DISABLED]:= iif(!self:CheckBoxActive,1,0)
	aDis[SINGLEUSE]:= iif(self:ChecBoxSingelUse,1,0)
	if self:lNew
		AAdd(self:oCaller:aDistr,aDis)
	else
		self:oCaller:aDistr[self:nPos]:=aDis
	endif
	self:oCaller:FillDistribution()

	
	SELF:EndWindow()
	
ENDIF
	
RETURN NIL
//mRekPrv:=oDis:accid
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditDistribution
	//Put your PostInit additions here
	local oPP as SQLSelect
	LOCAL it AS INT
self:SetTexts()
	SELF:oDCMemberText:TextValue:=oCaller:cMemberName
	if !self:OwnPPCode==SEntity
		oPP:= SqlSelect{"select ppcode,ppname from ppcodes where ppcode='AAA' or ppcode='"+SEntity+"'",oConn} 
		oDCmDestPP:FillUsing(oPP,#PPNAME,#PPCODE)
	endif
	IF !lNew
		self:mDescription := self:aDis[DESCRPTN]
		self:CheckBoxActive:=iif(self:aDis[DISABLED]=1,false,true)
		IF self:aDis[DISABLED] =1
			self:oDCCheckBoxActive:TextColor:=Color{COLORRED}
		ENDIF 
		self:ChecBoxSingelUse:=iif(self:aDis[SINGLEUSE]=1,true,false)
		self:mDestAcc := self:aDis[DESTACC]
		self:mDestAmt:=self:aDis[DESTAMT]
		self:mDestPP := self:aDis[DESTPP]
		if self:oDCmDestPP:Value=SEntity
			self:oCCAccButton:Show()
			self:mDestAcc:=Transform(SqlSelect{"select accnumber from account where accnumber='"+Transform(self:mDestAcc,"")+"'",oConn}:FIELDGET(1),"")
		else
			self:oCCAccButton:Hide()
		endif
 
		self:oDCmDestTyp:FillUsing(self:FillDestTypes())
		it:= self:aDis[DESTTYP]
// 		self:mDestTyp := DistributionTypes[self:aDis[DESTTYP]+1]
		self:mDestTyp := self:aDis[DESTTYP]
		IF it!=1
			self:oDCperc:TextValue:="a month"
			IF it>=2   // remaining
				self:oDCAmountTxt:TextValue:="up to"
				self:oDCmDestAmt:HyperLabel:Description:="maximum amount a month; 0 means no limit"
			ELSE
				self:oDCAmountTxt:TextValue:="amount"
				self:oDCmDestAmt:HyperLabel:Description:="fixed amount per month"
			ENDIF
		ELSE
			self:oDCperc:TextValue:="%"
			self:oDCAmountTxt:Hide()
			self:oDCmDestAmt:HyperLabel:Description:="percentage of balance of member account"
		ENDIF
		IF self:aDis[CURRENCY]=1
			self:CurrencyGroup:="dollar"
		ELSE
			self:CurrencyGroup:="own"
		ENDIF
	ELSE
    	SELF:mDestAcc:=""
		if !self:OwnPPCode==SEntity
			self:mDestPP:=SEntity
		else
	    	self:mDestPP:=""
		endif
    	SELF:mDestAmt:=0
		self:CheckBoxActive:=true
    	self:mDestTyp := 0
		SELF:oDCperc:TextValue:="a month"
		it:=0
		self:CurrencyGroup:="own"
	ENDIF
		SELF:oDCmDestAcc:Show()
		SELF:odcAccountFix:Show()
		if self:oDCmDestPP:Value="AAA"
			self:odcAccountFix:TextValue:="Bank Number:"
		else
			self:odcAccountFix:TextValue:="Account:"				
		endif			
	SELF:oCCCurrencyButton1:Caption:=sCURR
	IF it=1 // proportional
		self:oDCCurrencyGroup:Hide()
		self:oCCCurrencyButton1:Hide()
		self:oCCCurrencyButton2:Hide()
	ELSE
		self:oDCCurrencyGroup:Show()
		SELF:oCCCurrencyButton1:Show()
		self:oCCCurrencyButton2:Show()
	ENDIF
	RETURN NIL
method PreInit(oWindow,iCtlID,oServer,uExtra) class EditDistribution
	//Put your PreInit additions here
	local aDistrb as array
	local nSeq as int
	if IsArray(uExtra) 
		if Len(uExtra)=5
			self:lNew:=uExtra[1]
			self:oCaller:=uExtra[2]
			self:OwnPPCode:=uExtra[3]
			self:mMbrId:=uExtra[4]
			self:mSeq:=uExtra[5]
		endif
	endif
	if !self:lNew 
		aDistrb:=self:oCaller:aDistr
		nSeq:=Val(self:mSeq)
		self:nPos:=AScan(aDistrb,{|x|x[SEQNBR]==nSeq})
		ASize(self:aDis,15) 
		ACopy(self:oCaller:aDistr[self:nPos],self:aDis)
		self:oDis:=SQLSelect{"select * from distributioninstruction where mbrid ="+self:mMbrId+" and seqnbr="+self:mSeq ,oConn} 

	endif
	return NIL

METHOD ValidateDistribution(dummy:=nil as logic) as logic CLASS EditDistribution
	LOCAL lValid := true as LOGIC
	LOCAL cError,cAcc as STRING
	LOCAL oTextBox as TextBox
	LOCAL uRet as USUAL
	LOCAL propsum as FLOAT
	LOCAL CurRec, nSeq:=Val(self:mSeq),nDPos as int
	Local oPersBank as SQLSelect
	local aDistrm:=self:oCaller:aDistr as array
	
	IF Empty(self:mDestPP)
		lValid := FALSE
		cError :=  "Destination PP is obliged!"
		self:oDCmDestPP:SetFocus()
	ENDIF
	// 	IF lValid .and. self:mDestTyp # DistributionTypes[3] .and. self:mDestAmt<=0
	IF lValid .and. self:mDestTyp >1 .and. self:mDestAmt<=0
		lValid := FALSE
		cError :=  "Amount should be larger than zero!"
		self:oDCmDestAmt:SetFocus()
	ENDIF
	IF lValid .and. self:mDestPP="ACH"
		IF !Empty(self:mDestAcc)
			cAcc:=AllTrim(self:mDestAcc)
			IF !(cAcc=='1' .or. cAcc=='2')
				lValid:=False
				cError:="Account should be filled with sequence number of member account at ACH: 1 or 2"
				self:oDCmDestAcc:SetFocus() 
			ENDIF
		ENDIF	 			
	ENDIF
	if lValid .and. self:oDCmDestPP:Value="AAA" // to local bank
		if Empty(self:mDestAcc) 
			lValid:=False
			cError:="Bank Number should be filled in case of destination "+self:oDCmDestPP:TextValue
			self:oDCmDestAcc:SetFocus() 
		else
			// check if bank number can be found in person data:
			oPersBank:=SQLSelect{"select banknumber from personbank where banknumber='"+AllTrim(self:mDestAcc)+"'",oConn}
			if oPersBank:RecCount=0
				cError:="Bankaccount "+AllTrim(mDestAcc)+" not found in Person data!"
				lValid:=False
				self:oDCmDestAcc:SetFocus() 
			endif
			if lValid .and.CountryCode="31"
				if Len(AllTrim(self:mDestAcc))>7
					if !IsDutchBanknbr(AllTrim(self:mDestAcc))
						cError:="Bankaccount "+AllTrim(self:mDestAcc)+" is not correct!!"
						lValid:=False
						self:oDCmDestAcc:SetFocus()
					endif 
				endif
			endif
		endif		
	endif
	if lValid .and. self:mDestPP==SEntity
		// check if account is in local general ledger:
		if Empty(self:mDestAcc) 
			lValid:=False
			cError:="Account should be filled in case of destination "+SEntity
			self:oDCmDestAcc:SetFocus()
		else
			if SQLselect{"select accnumber from account where accnumber='"+AllTrim(self:mDestAcc)+"'",oConn}:RecCount=0
				lValid:=False
				cError:="Account should be known within own general ledger in case of destination "+SEntity
				self:oDCmDestAcc:SetFocus()	
			endif
		endif 
	endif 

	// 	IF lValid .and. self:mDestTyp # DistributionTypes[1] .and. CheckBoxActive
	IF lValid .and. self:mDestTyp >0 .and. CheckBoxActive
		// 		IF mDestTyp=DistributionTypes[2]
		IF mDestTyp=1
			propsum:=self:mDestAmt
		endif		
		do WHILE (nDPos:=AScan(aDistrm,{|x|x[disabled]==0 .and. !x[seqnbr]==nSeq},NDPos+1))>0
			// 			IF self:mDestTyp=DistributionTypes[3] .and. aDistrm[nDPos,DESTTYP]==2
			IF self:mDestTyp=2 .and. aDistrm[nDPos,DESTTYP]==2
				lValid := FALSE
				cError :=  "Only one destination of type remaining allowed!"
				self:oDCmDestTyp:SetFocus()
				exit
			endif
			IF self:mDestTyp=3 .and. aDistrm[nDPos,DESTTYP]==3
				lValid := FALSE
				cError :=  "Only one destination of type remaining from RPP allowed!"
				self:oDCmDestTyp:SetFocus()
				exit
			endif
			IF self:mDestTyp=1 .and. aDistrm[nDPos,DESTTYP]==1
				propsum+=aDistrm[nDPos,DESTAMT]
			endif
		ENDDO
		IF lValid .and. propsum>100
			lValid := FALSE
			cError :=  "Proportions must be less than 100%!"
			self:oDCmDestAmt:SetFocus()
		endif			
	endif
	IF ! lValid
		(ErrorBox{,cError}):Show()
	endif

	RETURN lValid
	

	
STATIC DEFINE EDITDISTRIBUTION_ACCBUTTON := 120 
STATIC DEFINE EDITDISTRIBUTION_ACCOUNTFIX := 110 
STATIC DEFINE EDITDISTRIBUTION_ACHFIX1 := 119 
STATIC DEFINE EDITDISTRIBUTION_ACHFIX2 := 121 
STATIC DEFINE EDITDISTRIBUTION_AMOUNTTXT := 108 
STATIC DEFINE EDITDISTRIBUTION_CANCELBUTTON := 114 
STATIC DEFINE EDITDISTRIBUTION_CHECBOXSINGELUSE := 119 
STATIC DEFINE EDITDISTRIBUTION_CHECKBOXACTIVE := 118 
STATIC DEFINE EDITDISTRIBUTION_CHECKBUTTON := 124 
STATIC DEFINE EDITDISTRIBUTION_CURRENCYBUTTON1 := 116 
STATIC DEFINE EDITDISTRIBUTION_CURRENCYBUTTON2 := 117 
STATIC DEFINE EDITDISTRIBUTION_CURRENCYGROUP := 115 
STATIC DEFINE EDITDISTRIBUTION_FIXEDTEXT1 := 101 
STATIC DEFINE EDITDISTRIBUTION_FIXEDTEXT10 := 107 
STATIC DEFINE EDITDISTRIBUTION_FIXEDTEXT8 := 109 
STATIC DEFINE EDITDISTRIBUTION_FIXEDTEXT9 := 111 
STATIC DEFINE EDITDISTRIBUTION_MCHECKSAVE := 123 
STATIC DEFINE EDITDISTRIBUTION_MDESCRIPTION := 112 
STATIC DEFINE EDITDISTRIBUTION_MDESTACC := 104 
STATIC DEFINE EDITDISTRIBUTION_MDESTAMT := 103 
STATIC DEFINE EDITDISTRIBUTION_MDESTPP := 105 
STATIC DEFINE EDITDISTRIBUTION_MDESTTYP := 106 
STATIC DEFINE EDITDISTRIBUTION_MDFIA := 122 
STATIC DEFINE EDITDISTRIBUTION_MDFIR := 120 
STATIC DEFINE EDITDISTRIBUTION_MEMBERTEXT := 100 
STATIC DEFINE EDITDISTRIBUTION_OKBUTTON := 113 
STATIC DEFINE EDITDISTRIBUTION_PERC := 102 
STATIC DEFINE EDITDISTRIBUTION_SAVEBUTTON := 125 
STATIC DEFINE EDITDISTRIBUTIONDIAL_CANCELBUTTON := 114 
STATIC DEFINE EDITDISTRIBUTIONDIAL_CURRENCYBUTTON1 := 116 
STATIC DEFINE EDITDISTRIBUTIONDIAL_CURRENCYBUTTON2 := 117 
STATIC DEFINE EDITDISTRIBUTIONDIAL_CURRENCYGROUP := 115 
STATIC DEFINE EDITDISTRIBUTIONDIAL_FIXEDAMOUNT := 108 
STATIC DEFINE EDITDISTRIBUTIONDIAL_FIXEDTEXT1 := 101 
STATIC DEFINE EDITDISTRIBUTIONDIAL_FIXEDTEXT10 := 107 
STATIC DEFINE EDITDISTRIBUTIONDIAL_FIXEDTEXT7 := 110 
STATIC DEFINE EDITDISTRIBUTIONDIAL_FIXEDTEXT8 := 109 
STATIC DEFINE EDITDISTRIBUTIONDIAL_FIXEDTEXT9 := 111 
STATIC DEFINE EDITDISTRIBUTIONDIAL_MDESCRIPTION := 112 
STATIC DEFINE EDITDISTRIBUTIONDIAL_MDESTACC := 104 
STATIC DEFINE EDITDISTRIBUTIONDIAL_MDESTAMT := 103 
STATIC DEFINE EDITDISTRIBUTIONDIAL_MDESTPP := 105 
STATIC DEFINE EDITDISTRIBUTIONDIAL_MDESTTYP := 106 
STATIC DEFINE EDITDISTRIBUTIONDIAL_MEMBERTEXT := 100 
STATIC DEFINE EDITDISTRIBUTIONDIAL_OKBUTTON := 113 
STATIC DEFINE EDITDISTRIBUTIONDIAL_PERC := 102 
STATIC DEFINE EDITDISTRIBUTIONOUD_CANCELBUTTON := 114 
STATIC DEFINE EDITDISTRIBUTIONOUD_FIXEDAMOUNT := 108 
STATIC DEFINE EDITDISTRIBUTIONOUD_FIXEDTEXT1 := 100 
STATIC DEFINE EDITDISTRIBUTIONOUD_FIXEDTEXT10 := 107 
STATIC DEFINE EDITDISTRIBUTIONOUD_FIXEDTEXT7 := 110 
STATIC DEFINE EDITDISTRIBUTIONOUD_FIXEDTEXT8 := 109 
STATIC DEFINE EDITDISTRIBUTIONOUD_FIXEDTEXT9 := 111 
STATIC DEFINE EDITDISTRIBUTIONOUD_MDESCRIPTION := 112 
STATIC DEFINE EDITDISTRIBUTIONOUD_MDESTACC := 104 
STATIC DEFINE EDITDISTRIBUTIONOUD_MDESTAMT := 103 
STATIC DEFINE EDITDISTRIBUTIONOUD_MDESTPP := 105 
STATIC DEFINE EDITDISTRIBUTIONOUD_MDESTTYP := 106 
STATIC DEFINE EDITDISTRIBUTIONOUD_MEMBERTEXT := 101 
STATIC DEFINE EDITDISTRIBUTIONOUD_OKBUTTON := 113 
STATIC DEFINE EDITDISTRIBUTIONOUD_PERC := 102 
RESOURCE EditMember DIALOGEX  34, 32, 433, 363
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", EDITMEMBER_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 12, 14, 94, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITMEMBER_PERSONBUTTON, "Button", WS_CHILD, 106, 14, 13, 12
	CONTROL	"", EDITMEMBER_MACCDEPT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 131, 14, 93, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITMEMBER_ACCBUTTON, "Button", WS_CHILD, 223, 14, 15, 12
	CONTROL	"Is person:", EDITMEMBER_SC_CLN, "Static", SS_CENTERIMAGE|WS_CHILD, 12, 0, 38, 12
	CONTROL	"OK", EDITMEMBER_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 353, 8, 53, 12
	CONTROL	"Cancel", EDITMEMBER_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 291, 8, 53, 12
	CONTROL	"Delete", EDITMEMBER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 364, 162, 42, 12
	CONTROL	"Edit", EDITMEMBER_EDITBUTTON, "Button", WS_TABSTOP|WS_CHILD, 364, 125, 42, 12
	CONTROL	"New", EDITMEMBER_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 364, 88, 42, 12
	CONTROL	"Distribution instructions for received gifts", EDITMEMBER_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 15, 78, 401, 102
	CONTROL	"Type:", EDITMEMBER_SC_GRADE, "Static", WS_CHILD, 20, 49, 23, 13
	CONTROL	"", EDITMEMBER_MHBN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 350, 49, 73, 12, WS_EX_CLIENTEDGE
	CONTROL	"Household id", EDITMEMBER_HOUSECODETXT, "Static", WS_CHILD, 276, 48, 52, 12
	CONTROL	"Primary Finance PO", EDITMEMBER_SC_FINANCEPO, "Static", WS_CHILD, 20, 65, 70, 13
	CONTROL	"PP Codes", EDITMEMBER_MPPCODE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 112, 66, 156, 208
	CONTROL	"Status", EDITMEMBER_MGRADE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 112, 48, 156, 72
	CONTROL	"Pension amount:", EDITMEMBER_SC_AOW, "Static", WS_CHILD, 11, 281, 61, 12
	CONTROL	"Health Insurance saving amount:", EDITMEMBER_SC_ZKV, "Static", WS_CHILD, 159, 281, 106, 13
	CONTROL	"Pension amount:", EDITMEMBER_MAOW, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 75, 281, 72, 13
	CONTROL	"Health Insurance saving amount:", EDITMEMBER_MZKV, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 272, 281, 72, 13
	CONTROL	"", EDITMEMBER_MPERSONCONTACT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 75, 298, 94, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITMEMBER_PERSONBUTTONCONTACT, "Button", WS_CHILD, 168, 298, 14, 12
	CONTROL	"Partner Monetary Clearing house", EDITMEMBER_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 12, 36, 416, 149
	CONTROL	"", EDITMEMBER_MHOMEACC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 112, 81, 166, 12, WS_EX_CLIENTEDGE
	CONTROL	"Account at Primary Fin PO:", EDITMEMBER_HOMEACCTXT, "Static", WS_CHILD|NOT WS_VISIBLE, 20, 81, 87, 12
	CONTROL	"Associated accounts (saving, etc):", EDITMEMBER_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 12, 187, 404, 86
	CONTROL	"", EDITMEMBER_LISTVIEWASSACC, "SysListView32", LVS_REPORT|LVS_SINGLESEL|LVS_SHOWSELALWAYS|LVS_SORTASCENDING|LVS_EDITLABELS|WS_GROUP|WS_CHILD|WS_BORDER, 18, 199, 339, 69
	CONTROL	"Add", EDITMEMBER_ADDBUTTON, "Button", WS_TABSTOP|WS_CHILD, 364, 214, 42, 12
	CONTROL	"Remove", EDITMEMBER_REMOVEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 364, 243, 42, 13
	CONTROL	"", EDITMEMBER_DISTRLISTVIEW, "SysListView32", LVS_REPORT|LVS_SINGLESEL|LVS_SHOWSELALWAYS|LVS_EDITLABELS|WS_CHILD|WS_BORDER, 18, 88, 339, 88
	CONTROL	"Office assessment rate:", EDITMEMBER_WITHLDOFFTXT, "Static", WS_CHILD, 276, 66, 76, 12
	CONTROL	"", EDITMEMBER_WITHLDOFFRATE, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 352, 66, 72, 57
	CONTROL	"Contact Person", EDITMEMBER_FIXEDTEXT9, "Static", WS_CHILD, 11, 300, 53, 12
	CONTROL	"Memberstatements should be send to:", EDITMEMBER_STATEMNTSDEST, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 200, 297, 133, 57
	CONTROL	"None", EDITMEMBER_DESTBUTTON4, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 208, 306, 116, 11
	CONTROL	"Member", EDITMEMBER_DESTBUTTON1, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 208, 317, 80, 11
	CONTROL	"Contact Person", EDITMEMBER_DESTBUTTON2, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 208, 328, 80, 11
	CONTROL	"Member && Contact Person", EDITMEMBER_DESTBUTTON3, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 208, 339, 116, 11
	CONTROL	"Home assigned?", EDITMEMBER_MHAS, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 352, 66, 68, 12
	CONTROL	"", EDITMEMBER_ACCDEPSELECT, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 160, 0, 73, 72, WS_EX_TRANSPARENT
	CONTROL	"Owns ", EDITMEMBER_SC_ACCDEP, "Static", SS_CENTERIMAGE|WS_CHILD, 132, 0, 27, 12
END

CLASS EditMember INHERIT DataWindowExtra 

	PROTECT oDCmPerson AS SINGLELINEEDIT
	PROTECT oCCPersonButton AS PUSHBUTTON
	PROTECT oDCmAccDept AS SINGLELINEEDIT
	PROTECT oCCAccButton AS PUSHBUTTON
	PROTECT oDCSC_CLN AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oDCGroupBox3 AS GROUPBOX
	PROTECT oDCSC_GRADE AS FIXEDTEXT
	PROTECT oDCmHBN AS SINGLELINEEDIT
	PROTECT oDCHousecodetxt AS FIXEDTEXT
	PROTECT oDCSC_FinancePO AS FIXEDTEXT
	PROTECT oDCmPPCode AS COMBOBOX
	PROTECT oDCmGrade AS COMBOBOX
	PROTECT oDCSC_AOW AS FIXEDTEXT
	PROTECT oDCSC_ZKV AS FIXEDTEXT
	PROTECT oDCmAOW AS MYSINGLEEDIT
	PROTECT oDCmZKV AS MYSINGLEEDIT
	PROTECT oDCmPersonContact AS SINGLELINEEDIT
	PROTECT oCCPersonButtonContact AS PUSHBUTTON
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCmHomeAcc AS SINGLELINEEDIT
	PROTECT oDCHomeAccTxt AS FIXEDTEXT
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCListViewAssAcc AS LISTVIEW
	PROTECT oCCAddButton AS PUSHBUTTON
	PROTECT oCCRemoveButton AS PUSHBUTTON
	PROTECT oDCDistrListView AS LISTVIEW
	PROTECT oDCwithldofftxt AS FIXEDTEXT
	PROTECT oDCwithldoffrate AS COMBOBOX
	PROTECT oDCFixedText9 AS FIXEDTEXT
	PROTECT oDCStatemntsDest AS RADIOBUTTONGROUP
	PROTECT oCCDestButton4 AS RADIOBUTTON
	PROTECT oCCDestButton1 AS RADIOBUTTON
	PROTECT oCCDestButton2 AS RADIOBUTTON
	PROTECT oCCDestButton3 AS RADIOBUTTON
	PROTECT oDCmHAS AS CHECKBOX
	PROTECT oDCAccDepSelect AS COMBOBOX
	PROTECT oDCSC_AccDep AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	instance mPerson 
	instance mAccDept 
	instance mHBN 
	instance mPPCode 
	instance mGrade 
	instance mAOW 
	instance mZKV 
	instance mPersonContact 
	instance mHomeAcc 
	instance withldoffrate 
	instance StatemntsDest
	instance mHAS 
   PROTECT lNewMember := FALSE as LOGIC
	PROTECT oAccount, oAcc, oAccA as SQLSelect
	PROTECT oMbr,oMemA as SQLSelect
	PROTECT oPerson,oPers as SQLSelect
	PROTECT mCLN, mCLNContact AS STRING
	EXPORT cMemberName, cContactName, mCod as STRING
	EXPORT mREK,mRekOrg,mGradeOrg,mMbrId,mDepId as STRING
	PROTECT cDepartmentName:="" as STRING
	PROTECT cAccountName:="" as STRING
	PROTECT cAccount1Name AS STRING
	PROTECT cAccount2Name as STRING
	PROTECT cAccount3Name AS STRING
	PROTECT cOrdInfo AS STRING
	PROTECT cFilter AS STRING
	EXPORT dReportDate AS DATE
	PROTECT cCurBal, cCurDep,cCurType as STRING 
	protect aAssOrg:={} as array
	export oCaller as MemberBrowser
	export aDistr:={},aDistrOrg as array  // content of all corresponding distribution instructions:
	//{1:mbrid,2:SEQNBR,3:DESTACC,4:DESTPP,5:DESTTYP,6:DESTAMT,7:LSTDATE,8:DESCRPTN,9:CURRENCY,10:DISABLED,11:AMNTSND,12:DFIR,13:DFIA,14:CHECKSAVE,15:SINGLEUSE}
	export maxseq as int // next available sequence number within distribution instructions of this member
	declare method FillDistribution, ValidateMember
METHOD AccButton(lUnique ) CLASS EditMember
	LOCAL cAccDepName as STRING
	LOCAL cfilter as string
	LOCAL aExclRek:={},aInclRek:={} as ARRAY
	LOCAL oLVI	AS ListViewItem, x AS INT
	LOCAL lSuccess as LOGIC
	local oDep as SQLSelect 
	Default(@lUnique,FALSE)
// 	oMem:MemberBal:=cCurBal
// 	oMem:MemberDep:=cCurDep
	IF Empty(self:oDCmAccDept:TEXTValue)
		cAccDepName:=self:cMemberName
	ELSE
		cAccDepName:= AllTrim(self:oDCmAccDept:TEXTValue)
	ENDIF
	FOR x := 1 UPTO SELF:oDCListViewAssAcc:ItemCount
		oLVI := SELF:oDCListViewAssAcc:GetNextItem( LV_GNIBYITEM,,,,,x-1 )
		AAdd(aExclRek,oLVI:GetValue(#Number))
	NEXT x

	if self:oDCAccDepSelect:Value=='account'
		if !Empty(self:cCurDep)
			oDep:=SQLSelect{"select incomeacc, expenseacc,netasset from department where depid="+self:cCurDep,oConn}
			if oDep:RecCount>0
				aInclRek:={Str(oDep:incomeacc,-1),Str(oDep:expenseacc,-1),Str(oDep:netasset,-1),SDON}
			endif
		else
			aInclRek:={self:mREK,self:mRekOrg,SDON}
		endif
		cfilter:=MakeFilter(aInclRek,{income,liability,asset},"N",,,aExclRek)
		AccountSelect(self,cAccDepName,"Member Account",lUnique,cfilter,self:Owner)
	else
		(DepartmentExplorer{self:Owner,"Department Member",self:mDepId,self,cAccDepName}):show()	
	endif

	RETURN NIL
ACCESS AccDepSelect() CLASS EditMember
RETURN SELF:FieldGet(#AccDepSelect)

ASSIGN AccDepSelect(uValue) CLASS EditMember
SELF:FieldPut(#AccDepSelect, uValue)
RETURN uValue

METHOD AddButton( ) CLASS EditMember
	LOCAL cSelect AS STRING
	LOCAL oLVI	AS ListViewItem, x AS INT
	LOCAL aAccExcl:={} AS ARRAY
	LOCAL lSuccess AS LOGIC
	LOCAL cfilter as string

	IF SELF:oDCListViewAssAcc:ItemCount=30
		(ErrorBox{,"maximum of 30 associated accounts!"}):Show()
		RETURN NIL
	ENDIF
	// add all existing ass.accounts:
	aAccExcl:={mRek}
	FOR x := 1 UPTO SELF:oDCListViewAssAcc:ItemCount
		oLVI := SELF:oDCListViewAssAcc:GetNextItem( LV_GNIBYITEM,,,,,x-1 )
		AAdd(aAccExcl,oLVI:GetValue(#Number))
	NEXT x
	cfilter:=MakeFilter(,{"BA","PA","KO"},"B",,,aAccExcl)
	AccountSelect(self,"","Associated Accounts",FALSE,cfilter,self:Owner,)
	RETURN nil
METHOD Append() CLASS EditMember
	SELF:oSFSub_Distributions:Append()
RETURN NIL
METHOD CancelButton() CLASS EditMember

	SELF:EndWindow()
	
	RETURN NIL
METHOD Close( oE ) CLASS EditMember
	if !Comparr(self:aDistrOrg,self:aDistr)
		if TextBox{self,self:olan:wget("Editing member"),self:olan:wget("Do you really want to discard changes"),BUTTONYESNO+BOXICONQUESTIONMARK}:Show()==BOXREPLYNO
			self:OkButton()
		endif
	endif
	IF !oPerson == null_object
		IF oPerson:Used
			oPerson:Close()
		ENDIF
		oPerson:=NULL_OBJECT
	ENDIF
	IF !oAcc == NULL_OBJECT
		IF oAcc:Used
			oAcc:Close()
		ENDIF
		oAcc:=NULL_OBJECT
	ENDIF
	SELF:Destroy()
	// force garbage collection
	CollectForced()

	RETURN SUPER:Close(oE)

METHOD Commit() CLASS EditMember
 	LOCAL oTextBox AS TextBox
	IF .not. SELF:oMbr:Commit()
		oTextBox := TextBox{ SELF, "Changes discarded:",;
		"Changes discarded because somebody else has updated the person at the same time ";
	    	+ SELF:oMbr:Status:Caption +;
		":" + SELF:oMbr:Status:Description}		
		oTextBox:Type := BUTTONOKAY
		oTextBox:Show()
		RETURN FALSE
	ENDIF
	RETURN TRUE

METHOD DeleteButton( ) CLASS EditMember
	LOCAL oDis as SqlStatement
	LOCAL oItem AS ListViewItem
	LOCAL mSeq as STRING 
	local nPos,nSeq as int
	local aDistrm:=self:aDistr as array
	oItem:=SELF:oDCDistrListView:GetSelectedItem()
	IF Empty(oItem)
		(Errorbox{,"Select a distribution Instruction first"}):Show()
		RETURN NIL
	ENDIF
	IF (TextBox{ SELF, "Delete Distribution Instruction",;
		"Delete Distribution Instruction: " + AllTrim(oItem:GetText(#DestTyp))+" "+oItem:GetText(#DestAmt) + "?";
		,BUTTONYESNO + BOXICONQUESTIONMARK }):Show();
		== BOXREPLYYES
		nSeq:=oItem:GetValue(#DestPP) 
		mSeq:=Str(nSeq,-1) 
		nPos:=AScan(aDistrm,{|x|x[SEQNBR]=nSeq})
		if nPos>0
			ADel(self:aDistr,nPos) 
			aSize(self:aDistr,len(self:aDistr)-1)
					
// 		oDis:=SQLStatement{"delete from DistributionInstruction where mbrId="+self:mMbrId+" and seqnbr="+mSeq,oConn} 
// 		oDis:Execute()
// 		if oDis:NumSuccessfulRows=1
    	    self:FillDistribution()
		ENDIF
	ENDIF

	RETURN NIL
METHOD EditButton(lNewDis ) CLASS EditMember

	LOCAL EditDistribution AS EditDistribution
	LOCAL oDis as SQLSelect
	LOCAL oItem AS ListViewItem
	LOCAL mSeq AS STRING
	Default(@lNewDis,FALSE)
	oItem:=SELF:oDCDistrListView:GetSelectedItem()
	IF !lNewDis
		IF Empty(oItem)
			(Errorbox{,"Select a distribution Instruction first"}):Show()
			RETURN
		ENDIF
	ENDIF
// 	oDis:=SELF:oDist
	IF !lNewDis
		mSeq:=Str(oItem:GetValue(#DestPP),-1)
	ENDIF
	EditDistribution := EditDistribution{ self:Owner,,,{lNewDis,self,self:mPPCode,self:mMbrId,mSeq} }
	EditDistribution:Show()
	RETURN NIL
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS EditMember
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "MPERSON".and.!AllTrim(oControl:Value)==AllTrim(cMemberName)
			cMemberName:=AllTrim(oControl:Value)
			SELF:PersonButton(TRUE)
		ELSEIF oControl:Name == "MPERSONCONTACT".and.!AllTrim(oControl:VALUE)==AllTrim(self:cContactName)
			cContactName:=AllTrim(oControl:Value)
			IF Empty(oControl:Value) && leeg gemaakt?
				SELF:mCLNContact :=  ""
				SELF:cContactName := ""
				SELF:oDCmPersonContact:TEXTValue := SELF:cContactName
				SELF:ShowStmntDest()
			ELSE
				SELF:PersonButtonContact(TRUE)
			ENDIF
		ELSEIF oControl:Name == "MACCDEPT".and. self:AccDepSelect="department".and.!AllTrim(oControl:VALUE)==AllTrim(self:cDepartmentName)
			self:cDepartmentName:=AllTrim(oControl:VALUE)
			self:AccButton(true)
		ELSEIF oControl:Name == "MACCDEPT".and. self:AccDepSelect="account".and.!AllTrim(oControl:VALUE)==AllTrim(self:cAccountName)
			self:cAccountName:=AllTrim(oControl:VALUE)
			self:AccButton(true)
		ENDIF
	ENDIF
	RETURN NIL
METHOD FillDistribution() as void pascal CLASS EditMember
	// LOCAL oDist as SQLSelect
	LOCAL oItem as ListViewItem
	local i as int
	// oDist:=SQLSelect{"select * from DistributionInstruction where mbrid="+self:mMbrId,oConn}
	self:oDCDistrListView:DeleteAll() 
	// DO WHILE oDist:RecCount>0 .and. !oDist:EoF
	for i:=1 to Len(self:aDistr) 
		// add item to listview:
		oItem:=ListViewItem{}
		oItem:SetText(iif(self:aDistr[i,DISABLED]=1," ","X"),#DestEnabled)
		oItem:SetValue(iif(self:aDistr[i,DISABLED]=1,false,true),#DestEnabled)
		oItem:SetText(self:aDistr[i,DESTPP],#DestPP)
		oItem:SetValue(self:aDistr[i,SEQNBR],#DestPP)
		oItem:SetText(AllTrim(self:aDistr[i,DESTACC]),#DestAcc)
		oItem:SetText(AllTrim(self:aDistr[i,DESCRPTN]),#Descrptn)
		oItem:SetText(DistributionTypes[self:aDistr[i,DESTTYP]+1],#DestTyp)
		oItem:SetText(Str(self:aDistr[i,DESTAMT],-1,DecAantal),#DestAmt)
		self:oDCDistrListView:AddItem(oItem)

	next

method FillPP() class EditMember
return FillPP()
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditMember 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditMember",_GetInst()},iCtlID)

oDCmPerson := SingleLineEdit{SELF,ResourceID{EDITMEMBER_MPERSON,_GetInst()}}
oDCmPerson:HyperLabel := HyperLabel{#mPerson,NULL_STRING,"The person, who is the member","HELP_CLN"}
oDCmPerson:FocusSelect := FSEL_HOME
oDCmPerson:FieldSpec := Person_NA1{}

oCCPersonButton := PushButton{SELF,ResourceID{EDITMEMBER_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v","Browse in persons",NULL_STRING}
oCCPersonButton:TooltipText := "Browse in Persons"

oDCmAccDept := SingleLineEdit{SELF,ResourceID{EDITMEMBER_MACCDEPT,_GetInst()}}
oDCmAccDept:HyperLabel := HyperLabel{#mAccDept,NULL_STRING,"Number of account/department of the member",NULL_STRING}
oDCmAccDept:FocusSelect := FSEL_HOME
oDCmAccDept:TooltipText := "Account/Department of this member"
oDCmAccDept:FieldSpec := Description{}
oDCmAccDept:UseHLforToolTip := False

oCCAccButton := PushButton{SELF,ResourceID{EDITMEMBER_ACCBUTTON,_GetInst()}}
oCCAccButton:HyperLabel := HyperLabel{#AccButton,"v","Browse in accounts",NULL_STRING}
oCCAccButton:TooltipText := "Browse in accounts/departments"

oDCSC_CLN := FixedText{SELF,ResourceID{EDITMEMBER_SC_CLN,_GetInst()}}
oDCSC_CLN:HyperLabel := HyperLabel{#SC_CLN,"Is person:",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{EDITMEMBER_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITMEMBER_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oCCDeleteButton := PushButton{SELF,ResourceID{EDITMEMBER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}

oCCEditButton := PushButton{SELF,ResourceID{EDITMEMBER_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}

oCCNewButton := PushButton{SELF,ResourceID{EDITMEMBER_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}

oDCGroupBox3 := GroupBox{SELF,ResourceID{EDITMEMBER_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"Distribution instructions for received gifts",NULL_STRING,NULL_STRING}

oDCSC_GRADE := FixedText{SELF,ResourceID{EDITMEMBER_SC_GRADE,_GetInst()}}
oDCSC_GRADE:HyperLabel := HyperLabel{#SC_GRADE,"Type:",NULL_STRING,NULL_STRING}

oDCmHBN := SingleLineEdit{SELF,ResourceID{EDITMEMBER_MHBN,_GetInst()}}
oDCmHBN:HyperLabel := HyperLabel{#mHBN,NULL_STRING,"Personal System unique code of the member",NULL_STRING}
oDCmHBN:UseHLforToolTip := True
oDCmHBN:FieldSpec := Members_HBN{}

oDCHousecodetxt := FixedText{SELF,ResourceID{EDITMEMBER_HOUSECODETXT,_GetInst()}}
oDCHousecodetxt:HyperLabel := HyperLabel{#Housecodetxt,"Household id",NULL_STRING,NULL_STRING}

oDCSC_FinancePO := FixedText{SELF,ResourceID{EDITMEMBER_SC_FINANCEPO,_GetInst()}}
oDCSC_FinancePO:HyperLabel := HyperLabel{#SC_FinancePO,"Primary Finance PO",NULL_STRING,NULL_STRING}

oDCmPPCode := combobox{SELF,ResourceID{EDITMEMBER_MPPCODE,_GetInst()}}
oDCmPPCode:HyperLabel := HyperLabel{#mPPCode,"PP Codes","Primary Finance PO of member",NULL_STRING}
oDCmPPCode:UseHLforToolTip := True
oDCmPPCode:FillUsing(Self:FillPP( ))
oDCmPPCode:TooltipText := "PP code of Primary Finance PO of member"

oDCmGrade := combobox{SELF,ResourceID{EDITMEMBER_MGRADE,_GetInst()}}
oDCmGrade:HyperLabel := HyperLabel{#mGrade,"Status",NULL_STRING,NULL_STRING}
oDCmGrade:FillUsing(Self:Memberstates( ))

oDCSC_AOW := FixedText{SELF,ResourceID{EDITMEMBER_SC_AOW,_GetInst()}}
oDCSC_AOW:HyperLabel := HyperLabel{#SC_AOW,"Pension amount:",NULL_STRING,NULL_STRING}

oDCSC_ZKV := FixedText{SELF,ResourceID{EDITMEMBER_SC_ZKV,_GetInst()}}
oDCSC_ZKV:HyperLabel := HyperLabel{#SC_ZKV,"Health Insurance saving amount:",NULL_STRING,NULL_STRING}

oDCmAOW := mySingleEdit{SELF,ResourceID{EDITMEMBER_MAOW,_GetInst()}}
oDCmAOW:FieldSpec := Members_AOW{}
oDCmAOW:HyperLabel := HyperLabel{#mAOW,"Pension amount:","Saving amount for pension","AOW"}
oDCmAOW:FocusSelect := FSEL_HOME

oDCmZKV := mySingleEdit{SELF,ResourceID{EDITMEMBER_MZKV,_GetInst()}}
oDCmZKV:FieldSpec := Members_ZKV{}
oDCmZKV:HyperLabel := HyperLabel{#mZKV,"Health Insurance saving amount:",NULL_STRING,"ZKV"}

oDCmPersonContact := SingleLineEdit{SELF,ResourceID{EDITMEMBER_MPERSONCONTACT,_GetInst()}}
oDCmPersonContact:HyperLabel := HyperLabel{#mPersonContact,NULL_STRING,"The contact person , normally the treasurer","HELP_CLN"}
oDCmPersonContact:FocusSelect := FSEL_HOME
oDCmPersonContact:FieldSpec := Person_NA1{}
oDCmPersonContact:UseHLforToolTip := True

oCCPersonButtonContact := PushButton{SELF,ResourceID{EDITMEMBER_PERSONBUTTONCONTACT,_GetInst()}}
oCCPersonButtonContact:HyperLabel := HyperLabel{#PersonButtonContact,"v","Browse in persons",NULL_STRING}
oCCPersonButtonContact:TooltipText := "Browse in Persons"

oDCGroupBox1 := GroupBox{SELF,ResourceID{EDITMEMBER_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Partner Monetary Clearing house",NULL_STRING,NULL_STRING}

oDCmHomeAcc := SingleLineEdit{SELF,ResourceID{EDITMEMBER_MHOMEACC,_GetInst()}}
oDCmHomeAcc:HyperLabel := HyperLabel{#mHomeAcc,NULL_STRING,"Account at home office",NULL_STRING}
oDCmHomeAcc:UseHLforToolTip := True
oDCmHomeAcc:FieldSpec := Members_HomeAcc{}

oDCHomeAccTxt := FixedText{SELF,ResourceID{EDITMEMBER_HOMEACCTXT,_GetInst()}}
oDCHomeAccTxt:HyperLabel := HyperLabel{#HomeAccTxt,"Account at Primary Fin PO:",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{EDITMEMBER_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Associated accounts (saving, etc):",NULL_STRING,NULL_STRING}

oDCListViewAssAcc := ListView{SELF,ResourceID{EDITMEMBER_LISTVIEWASSACC,_GetInst()}}
oDCListViewAssAcc:HyperLabel := HyperLabel{#ListViewAssAcc,NULL_STRING,NULL_STRING,NULL_STRING}
oDCListViewAssAcc:GridLines := True
oDCListViewAssAcc:FullRowSelect := True

oCCAddButton := PushButton{SELF,ResourceID{EDITMEMBER_ADDBUTTON,_GetInst()}}
oCCAddButton:HyperLabel := HyperLabel{#AddButton,"Add",NULL_STRING,NULL_STRING}

oCCRemoveButton := PushButton{SELF,ResourceID{EDITMEMBER_REMOVEBUTTON,_GetInst()}}
oCCRemoveButton:HyperLabel := HyperLabel{#RemoveButton,"Remove",NULL_STRING,NULL_STRING}

oDCDistrListView := ListView{SELF,ResourceID{EDITMEMBER_DISTRLISTVIEW,_GetInst()}}
oDCDistrListView:HyperLabel := HyperLabel{#DistrListView,NULL_STRING,NULL_STRING,NULL_STRING}

oDCwithldofftxt := FixedText{SELF,ResourceID{EDITMEMBER_WITHLDOFFTXT,_GetInst()}}
oDCwithldofftxt:HyperLabel := HyperLabel{#withldofftxt,"Office assessment rate:",NULL_STRING,NULL_STRING}

oDCwithldoffrate := combobox{SELF,ResourceID{EDITMEMBER_WITHLDOFFRATE,_GetInst()}}
oDCwithldoffrate:FillUsing(Self:OffRates())
oDCwithldoffrate:HyperLabel := HyperLabel{#withldoffrate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText9 := FixedText{SELF,ResourceID{EDITMEMBER_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"Contact Person",NULL_STRING,NULL_STRING}

oCCDestButton4 := RadioButton{SELF,ResourceID{EDITMEMBER_DESTBUTTON4,_GetInst()}}
oCCDestButton4:HyperLabel := HyperLabel{#DestButton4,"None",NULL_STRING,NULL_STRING}

oCCDestButton1 := RadioButton{SELF,ResourceID{EDITMEMBER_DESTBUTTON1,_GetInst()}}
oCCDestButton1:HyperLabel := HyperLabel{#DestButton1,"Member",NULL_STRING,NULL_STRING}

oCCDestButton2 := RadioButton{SELF,ResourceID{EDITMEMBER_DESTBUTTON2,_GetInst()}}
oCCDestButton2:HyperLabel := HyperLabel{#DestButton2,"Contact Person",NULL_STRING,NULL_STRING}

oCCDestButton3 := RadioButton{SELF,ResourceID{EDITMEMBER_DESTBUTTON3,_GetInst()}}
oCCDestButton3:HyperLabel := HyperLabel{#DestButton3,"Member "+_chr(38)+_chr(38)+" Contact Person",NULL_STRING,NULL_STRING}

oDCmHAS := CheckBox{SELF,ResourceID{EDITMEMBER_MHAS,_GetInst()}}
oDCmHAS:HyperLabel := HyperLabel{#mHAS,"Home assigned?",NULL_STRING,NULL_STRING}

oDCAccDepSelect := combobox{SELF,ResourceID{EDITMEMBER_ACCDEPSELECT,_GetInst()}}
oDCAccDepSelect:FillUsing({{"account:     ","account"},{"department:","department"}})
oDCAccDepSelect:HyperLabel := HyperLabel{#AccDepSelect,NULL_STRING,NULL_STRING,NULL_STRING}

oDCSC_AccDep := FixedText{SELF,ResourceID{EDITMEMBER_SC_ACCDEP,_GetInst()}}
oDCSC_AccDep:HyperLabel := HyperLabel{#SC_AccDep,"Owns ",NULL_STRING,NULL_STRING}

oDCStatemntsDest := RadioButtonGroup{SELF,ResourceID{EDITMEMBER_STATEMNTSDEST,_GetInst()}}
oDCStatemntsDest:FillUsing({ ;
								{oCCDestButton4,"3"}, ;
								{oCCDestButton1,"0"}, ;
								{oCCDestButton2,"1"}, ;
								{oCCDestButton3,"2"} ;
								})
oDCStatemntsDest:HyperLabel := HyperLabel{#StatemntsDest,"Memberstatements should be send to:",NULL_STRING,NULL_STRING}

SELF:Caption := "Edit Member/PP"
SELF:HyperLabel := HyperLabel{#EditMember,"Edit Member/PP",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListBoxSelect(oControlEvent) CLASS EditMember
	LOCAL oControl AS Control, uValue AS USUAL
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControlEvent:NameSym==#mGrade .or. oControlEvent:NameSym==#mPPCode
		IF SELF:oDCmPPCode:Value=SEntity
			SELF:oDCHomeAccTxt:Hide()
			self:oDCmHomeAcc:Hide() 
			SELF:ShowDistribution(TRUE)
		ELSE
			IF SELF:oDCmGrade:Value="Entity"
				SELF:oDCHomeAccTxt:Show()
				SELF:oDCmHomeAcc:Show()
				self:ShowDistribution(FALSE)
			ELSE
				SELF:oDCHomeAccTxt:Hide()
				SELF:oDCmHomeAcc:Hide()				
				self:ShowDistribution(true)  // in case of foreign member allow distribution instruction to charge to own account
			ENDIF
		ENDIF		
		IF SELF:oDCmGrade:Value="Entity"
			SELF:oDCmHBN:Hide()
			oDCHousecodetxt:Hide()
			self:oDCwithldoffrate:show()
			self:oDCwithldofftxt:show()			
			self:oDCmHAS:Hide()
		ELSE
			SELF:oDCmHBN:Show()
			oDCHousecodetxt:Show()
			self:oDCwithldoffrate:Hide()
			self:oDCwithldofftxt:Hide()
			IF self:oDCmPPCode:Value=SEntity
				self:oDCmHAS:Show()
			else
				self:oDCmHAS:Hide()
			endif
			
     	ENDIF
	elseif oControlEvent:NameSym==#AccDepSelect
		if self:oDCAccDepSelect:TextValue='account'
			self:mAccDept:=self:cAccountName
		else	
			self:mAccDept:=self:cDepartmentName
		endif
	ENDIF
	RETURN NIL
ACCESS mAccDept() CLASS EditMember
RETURN SELF:FieldGet(#mAccDept)

ASSIGN mAccDept(uValue) CLASS EditMember
SELF:FieldPut(#mAccDept, uValue)
RETURN uValue

ACCESS mAOW() CLASS EditMember
RETURN SELF:FieldGet(#mAOW)

ASSIGN mAOW(uValue) CLASS EditMember
SELF:FieldPut(#mAOW, uValue)
RETURN uValue

METHOD MemberStates( ) CLASS EditMember
	RETURN {{"Entity","Entity"},{"Senior member","SM"},{"Junior member","JM"},{"Member in training","MIT"},{"Trainy","Sta"},{"Staff","Staf"}}
ACCESS mGrade() CLASS EditMember
RETURN SELF:FieldGet(#mGrade)

ASSIGN mGrade(uValue) CLASS EditMember
SELF:FieldPut(#mGrade, uValue)
RETURN uValue

ACCESS mHAS() CLASS EditMember
RETURN SELF:FieldGet(#mHAS)

ASSIGN mHAS(uValue) CLASS EditMember
SELF:FieldPut(#mHAS, uValue)
RETURN uValue

ACCESS mHBN() CLASS EditMember
RETURN SELF:FieldGet(#mHBN)

ASSIGN mHBN(uValue) CLASS EditMember
SELF:FieldPut(#mHBN, uValue)
RETURN uValue

ACCESS mHomeAcc() CLASS EditMember
RETURN SELF:FieldGet(#mHomeAcc)

ASSIGN mHomeAcc(uValue) CLASS EditMember
SELF:FieldPut(#mHomeAcc, uValue)
RETURN uValue

ACCESS mPerson() CLASS EditMember
RETURN SELF:FieldGet(#mPerson)

ASSIGN mPerson(uValue) CLASS EditMember
SELF:FieldPut(#mPerson, uValue)
RETURN uValue

ACCESS mPersonContact() CLASS EditMember
RETURN SELF:FieldGet(#mPersonContact)

ASSIGN mPersonContact(uValue) CLASS EditMember
SELF:FieldPut(#mPersonContact, uValue)
RETURN uValue

ACCESS mPPCode() CLASS EditMember
RETURN SELF:FieldGet(#mPPCode)

ASSIGN mPPCode(uValue) CLASS EditMember
SELF:FieldPut(#mPPCode, uValue)
RETURN uValue

ACCESS mZKV() CLASS EditMember
RETURN SELF:FieldGet(#mZKV)

ASSIGN mZKV(uValue) CLASS EditMember
SELF:FieldPut(#mZKV, uValue)
RETURN uValue

METHOD NewButton( ) CLASS EditMember
	SELF:EditButton(TRUE)
	RETURN NIL
METHOD OffRates() CLASS EditMember
	LOCAL aRate AS ARRAY
	LOCAL oSys as SQLSelect
	oSys:=SQLSelect{"select withldoffl,assmntOffc,withldoffM,withldoffH from sysparms",oConn} 
	if oSys:RecCount=1
		aRate:={{"low ("+Str(oSys:withldoffl,-1,0)+"%)","L"},{"standard ("+Str(oSys:assmntOffc,-1,2)+"%)",""},{"middle ("+Str(oSys:withldoffM,-1,2)+"%)","M"},{"high ("+Str(oSys:withldoffH,-1,2)+"%)","H"}}
	endif
RETURN aRate
METHOD OkButton CLASS EditMember
	LOCAL nMWPos as int
	LOCAL cFilter, cStatement,cIncAcc,cExpAcc,cNetAcc,cIncAccPrv,cExpAccPrv,cNetAccPrv as STRING
	local cIncAccNbr,cExpAccNbr,cNetAccNbr,cIncAccPrvNbr,cExpAccPrvNbr,cNetAccPrvNbr,cAccPrvNbr as string
	LOCAL lResetBFM:=false as LOGIC
	LOCAL oLVI	as ListViewItem, x as int, cAss, mCLNPrv, mAccidPrv,mCOPrv,mDepPrv as STRING
	local oStmnt as SQLStatement
	local cStatement as string
	local aAss:={} as array
	local i,j as int
	local aDistrm:=self:aDistr,aDistrOrgm:=self:aDistrOrg as array 
	local oDep as SQLSelect
	local cFatalError as string
   SetDecimalSep(Asc('.'))
	IF self:ValidateMember()
		self:Pointer := Pointer{POINTERHOURGLASS}

		IF !self:lNewMember.and. self:oMbr:GRADE=="Staf".and.!self:mGrade=="Staf"
			lResetBFM:=true
		ENDIF
		if !self:lNewMember
// 			mAccidPrv:=Transform(oMbr:accid,"") 
			mAccidPrv:=self:mRekOrg                                                         
			mCLNPrv:=Str(oMbr:persid,-1)
// 			mDepPrv:=Transform(oMbr:depid,"") 
			mDepPrv:=self:cCurDep
			mCOPrv:=oMbr:CO
		endif
		cAss:=""
		FOR x := 1 upto self:oDCListViewAssAcc:ItemCount
			oLVI := self:oDCListViewAssAcc:GetNextItem( LV_GNIBYITEM,,,,,x-1 )
			// 			cAss+=iif(Empty(cAss),"",",")+Str(oLVI:GetValue(#Number),-1) 
			AAdd(aAss,oLVI:GetValue(#Number))
		NEXT x
		cStatement:=iif(self:lNewMember,"insert into member ","update member ")+;
			"set accid="+iif( self:AccDepSelect=='account',self:mREK,'DEFAULT')+",depid="+iif( self:AccDepSelect=='department',self:mDepId,'DEFAULT')+;
			",persid="+self:mCLN+;
			",aow="+Str(self:mAOW,-1)+;                                                                 
		",zkv="+Str(self:mZKV,-1)+;
			",has="+iif(self:mGrade='Entity','0',iif(self:mPPCode=Sentity,iif(self:mHAS,'1','0'),'0')) +;
			",contact='"+Str(val(self:mCLNContact),-1)+"'"+;
			",rptdest='"+iif(IsNil(self:StatemntsDest).or.Empty(self:StatemntsDest),"0",self:StatemntsDest)+"'"+;
			",grade='"+if(mGrade='Entity','',self:mGrade)+"'" +;
			",co='"+iif(self:mGrade='Entity',if(self:mGrade=='Entity','S','6'),'M')+"'"+;
			",homepp='"+self:mPPCode+"'"+;
			",offcrate='"+iif(self:mGrade='Entity',self:withldoffrate,"")+"'"+;
			",householdid ='"+iif(self:mGrade='Entity'," ",AllTrim(self:mHBN))+"'"+;
			",homeacc='"+iif(self:mPPCode=Sentity,"",self:mHomeAcc)+"'"+;
			iif(self:lNewMember,""," where mbrid="+self:mMbrId)
		oStmnt:=SQLStatement{cStatement,oConn}
		oStmnt:Execute()
		if !Empty(oStmnt:Status) 
			self:Pointer := Pointer{POINTERARROW}
			ErrorBox{,"Error:"+oStmnt:Status:Description}:Show()
			return false
		endif		

		IF !lNewMember .and.;
				(!mCLNPrv == self:mCLN .or. !mAccidPrv == self:mREK.or. !mDepPrv == self:mDepId )
			* connected person, account or department changed?
			IF mCLNPrv # self:mCLN  
				// disconnect old person from member:
				oStmnt:SQLString:="update person set type='"+iif(mCOPrv="M","1",PersTypeValue("COM"))+"',mailingcodes=replace(replace(mailingcodes,'MW ',''),'MW','') where persid="+mCLNPrv
				oStmnt:Execute()
			ENDIF 
			// connect new person to member:
			// 			oStmnt:SQLString:="update person set accid="+self:mREK+",type='"+iif(self:mGrade='Entity',PersTypeValue("ENT"),PersTypeValue("MBR"))+"'"+;
			oStmnt:SQLString:="update person set type='"+iif(self:mGrade='Entity',PersTypeValue("ENT"),PersTypeValue("MBR"))+"'"+;
				iif(self:mGrade='Entity',",gender=4",",gender=(if(gender=4,0,gender))") +;
				iif(lNewMember .or.! mCLNPrv == mCLN,",mailingcodes='"+MergeMLCodes(self:mCod,"MW")+"'","")+;
				" where persid="+self:mCLN 
			oStmnt:Execute()
			IF !Empty(mAccidPrv) .and.(!Empty(self:mDepId) .or. !Empty(self:mREK) .and.!mAccidPrv == self:mREK)
				* From account to department or Account replaced:
				if !Empty(self:mDepId)
					oDep:=SQLSelect{"select incomeacc,expenseacc,netasset from department where depid="+self:mDepId,oConn}
					cIncAcc:=Str(oDep:incomeacc,-1) 
					cExpAcc:=Str(oDep:expenseacc,-1) 
					cNetAcc:=Str(oDep:netasset,-1) 
				else
					cIncAcc:=self:mREK 
					cExpAcc:=self:mREK
					cNetAcc:=self:mREK
				endif
				* Disconnect old account from member:
				oStmnt:SQLString:="update account set giftalwd=0"+iif(mAccidPrv==cNetAcc,"",",description=concat('Disconnected:',description)")+" where accid="+mAccidPrv
				oStmnt:Execute()
				// change subscriptions to new income account 
				oStmnt:SQLString:="update subscription set "+sIdentChar+"accid"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv
				oStmnt:Execute()
				// change standing orders to new expense or income account:
				oStmnt:SQLString:="update standingorderline set "+sIdentChar+"accountid"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"accountid"+sIdentChar+"="+mAccidPrv +" and cre>deb"
				oStmnt:Execute()
				oStmnt:SQLString:="update standingorderline set "+sIdentChar+"accountid"+sIdentChar+"="+cExpAcc+" where "+sIdentChar+"accountid"+sIdentChar+"="+mAccidPrv +" and deb>cre"
				oStmnt:Execute()
				// change telepatterns
				oStmnt:SQLString:="update telebankpatterns set "+sIdentChar+"accid"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv  + " and addsub='B'"
				oStmnt:Execute()
				oStmnt:SQLString:="update telebankpatterns set "+sIdentChar+"accid"+sIdentChar+"="+cExpAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv  + " and addsub='A'"
				oStmnt:Execute()
				// change importpatterns
				oStmnt:SQLString:="update importpattern set "+sIdentChar+"accid"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv + " and addsub='C'" 
				oStmnt:Execute()
				oStmnt:SQLString:="update importpattern set "+sIdentChar+"accid"+sIdentChar+"="+cExpAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv + " and addsub='D'" 
				oStmnt:Execute()
				// change bankaccount single destination:
				oStmnt:SQLString:="update bankaccount set "+sIdentChar+"singledst"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"singledst"+sIdentChar+"="+mAccidPrv 
				oStmnt:Execute()
				 
				// change transactions not yet sent to PMC: 
				if	(!Empty(SINCHOME) .or.!Empty(SINC))
					// remove recordings to gift income/expense:
					oStmnt:SQLString:='delete from transaction where (accid='+SINC+iif(SINC==SINCHOME,'',' or accid='+SINCHOME)+' or accid='+SEXP+;
					iif(SEXP==SEXPHOME,'',' or accid='+SEXPHOME)+') and '+;
					'`transid` in (select `transid` from (select transid from transaction b where b.accid='+mAccidPrv+' and b.bfm="" and b.gc<>"") as x)'
					// and `transid` in (select `transid` from( select `transid` from transaction b where b.accid=100412 and b.bfm="" and b.gc<>"") as x)
					oStmnt:Execute()
				endif   
				oStmnt:SQLString:="update transaction set "+sIdentChar+"accid"+sIdentChar+"="+cExpAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv +" and bfm='' and gc='CH'"
				oStmnt:Execute() 
				if cNetAcc<>mAccidPrv 
					oStmnt:SQLString:="update transaction set "+sIdentChar+"accid"+sIdentChar+"="+cNetAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv +" and bfm='' and gc='PF'"
					oStmnt:Execute() 
				endif 
				oStmnt:SQLString:="update transaction set "+sIdentChar+"accid"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+mAccidPrv +" and bfm='' and gc in ('AG','MG')"
				oStmnt:Execute() 
				// change importtrans not yet processed: ???  (normally all immediately after import processed) 
				if ConI(SQLSelect{"select count(*) as total from importtrans where processed=0",oConn}:total)>0
					cAccPrvNbr:=Transform(SQLSelect{"select accnumber from account where accid="+mAccidPrv,oConn}:accnumber,"") 
					cIncAccNbr:=Transform(SQLSelect{"select accnumber from account where accid="+cIncAcc,oConn}:accnumber,"") 
					cExpAccNbr:=Transform(SQLSelect{"select accnumber from account where accid="+cExpAcc,oConn}:accnumber,"") 
					cNetAccNbr:=Transform(SQLSelect{"select accnumber from account where accid="+cNetAcc,oConn}:accnumber,"") 
					oStmnt:SQLString:="update importtrans set "+sIdentChar+"accountnr"+sIdentChar+"='"+cIncAccNbr+;
					"' where "+sIdentChar+"accountnr"+sIdentChar+"='"+cAccPrvNbr +"' and processed=0 and assmntcd in ('AG','MG')"
					oStmnt:Execute()
					oStmnt:SQLString:="update importtrans set "+sIdentChar+"accountnr"+sIdentChar+"='"+cNetAccNbr+;
					"' where "+sIdentChar+"accountnr"+sIdentChar+"='"+cAccPrvNbr +"' and processed=0 and assmntcd='PF'"
					oStmnt:Execute()
					oStmnt:SQLString:="update importtrans set "+sIdentChar+"accountnr"+sIdentChar+"='"+cExpAccNbr+;
					"' where "+sIdentChar+"accountnr"+sIdentChar+"='"+cAccPrvNbr +"' and processed=0 and assmntcd='CH'"
					oStmnt:Execute() 
				endif
				// correct month balances data
				CheckConsistency(oMainWindow,true,false,@cFatalError)
								
			elseIF !Empty(mDepPrv) .and.(!Empty(self:mREK) .or.!Empty(self:mDepId) .and.!mDepPrv == self:mDepId)
				* From department to account or Department replaced:
				* Disconnect old department from member:
				SQLStatement{"update department set descriptn=concat('disconnected:',descriptn) where depid="+mDepPrv,oConn}:Execute() 
				// set all its accounts on no gifts
				SQLStatement{"update account set giftalwd=0 where department="+mDepPrv,oConn}:Execute()
				oDep:=SQLSelect{"select incomeacc,expenseacc,netasset from department where depid="+mDepPrv,oConn}
				cIncAccPrv:=Transform(oDep:incomeacc,"") 
				cExpAccPrv:=Transform(oDep:expenseacc,"") 
				cNetAccPrv:=Transform(oDep:netasset,"") 
				if !Empty(self:mDepId)
					oDep:=SQLSelect{"select incomeacc,expenseacc,netasset from department where depid="+self:mDepId,oConn}
					cIncAcc:=Transform(oDep:incomeacc,"") 
					cExpAcc:=Transform(oDep:expenseacc,"") 
					cNetAcc:=Transform(oDep:netasset,"") 
// 					cIncAcc:=Transform(SQLSelect{"select accid from account a where a.accid in (select incomeacc from department where depid="+self:mDepId+")",oConn}:accid,"")
// 					cExpAcc:=Transform(SQLSelect{"select accid from account a where a.accid in (select expenseacc from department where depid="+self:mDepId+")",oConn}:accid,"")					
// 					cNetAcc:=Transform(SQLSelect{"select accid from account a where a.accid in (select netasset from department where depid="+self:mDepId+")",oConn}:accid,"")					
				else
					cIncAcc:=self:mREK 
					cExpAcc:=self:mREK
					cNetAcc:=self:mREK 
				endif
				// change subscriptions to new income account 
				oStmnt:SQLString:="update subscription set "+sIdentChar+"accid"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+cIncAccPrv
				oStmnt:Execute()
				// change standing orders to new expense or income account:
				oStmnt:SQLString:="update standingorderline set "+sIdentChar+"accountid"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"accountid"+sIdentChar+"="+cIncAccPrv
				oStmnt:Execute()
				oStmnt:SQLString:="update standingorderline set "+sIdentChar+"accountid"+sIdentChar+"="+cExpAcc+" where "+sIdentChar+"accountid"+sIdentChar+"="+cExpAccPrv
				oStmnt:Execute()
				// change telepatterns
				oStmnt:SQLString:="update telebankpatterns set "+sIdentChar+"accid"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+cIncAccPrv +" and addsub='B'"
				oStmnt:Execute()
				oStmnt:SQLString:="update telebankpatterns set "+sIdentChar+"accid"+sIdentChar+"="+cExpAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+cExpAccPrv +" and addsub='A'"
				oStmnt:Execute()
				// change importpatterns
				oStmnt:SQLString:="update importpattern set "+sIdentChar+"accid"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+cIncAccPrv  +" and addsub='C'"
				oStmnt:Execute()
				oStmnt:SQLString:="update importpattern set "+sIdentChar+"accid"+sIdentChar+"="+cExpAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+cExpAccPrv +" and addsub='D'" 
				oStmnt:Execute()
				// change bankaccount single destination:
				oStmnt:SQLString:="update bankaccount set "+sIdentChar+"singledst"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"singledst"+sIdentChar+"="+cIncAccPrv 
				oStmnt:Execute()
				// change transactions not yet sent to PMC:
				oStmnt:SQLString:="update transaction set "+sIdentChar+"accid"+sIdentChar+"="+cExpAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+cExpAccPrv +" and bfm='' and gc='CH'"
				oStmnt:Execute() 
				oStmnt:SQLString:="update transaction set "+sIdentChar+"accid"+sIdentChar+"="+cIncAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+cIncAccPrv +" and bfm='' and gc in ('AG,'MG')"
				oStmnt:Execute() 
				oStmnt:SQLString:="update transaction set "+sIdentChar+"accid"+sIdentChar+"="+cNetAcc+" where "+sIdentChar+"accid"+sIdentChar+"="+cNetAccPrv +" and bfm='' and gc='PF'"
				oStmnt:Execute() 
				// correct month balances data
				CheckConsistency(oMainWindow,true,false,@cFatalError)
				// change importtrans not yet processed: (normally all immediately after import processed) 
				if ConI(SQLSelect{"select count(*) as total from importtrans where processed=0",oConn}:total)>0
					cIncAccPrvNbr:=Transform(SQLSelect{"select accnumber from account where accid="+cIncAccPrv,oConn}:accnumber,"") 
					cExpAccPrvNbr:=Transform(SQLSelect{"select accnumber from account where accid="+cExpAccPrv,oConn}:accnumber,"") 
					cNetAccPrvNbr:=Transform(SQLSelect{"select accnumber from account where accid="+cNetAccPrv,oConn}:accnumber,"") 
					cIncAccNbr:=Transform(SQLSelect{"select accnumber from account where accid="+cIncAcc,oConn}:accnumber,"") 
					cExpAccNbr:=Transform(SQLSelect{"select accnumber from account where accid="+cExpAcc,oConn}:accnumber,"") 
					cNetAccNbr:=Transform(SQLSelect{"select accnumber from account where accid="+cNetAcc,oConn}:accnumber,"") 
					oStmnt:SQLString:="update importtrans set "+sIdentChar+"accountnr"+sIdentChar+"='"+cIncAccNbr+;
					"' where "+sIdentChar+"accountnr"+sIdentChar+"='"+cIncAccPrvNbr +"' and processed=0 and assmntcd in ('AG','MG')"
					oStmnt:Execute() 
					oStmnt:SQLString:="update importtrans set "+sIdentChar+"accountnr"+sIdentChar+"='"+cNetAccNbr+;
					"' where "+sIdentChar+"accountnr"+sIdentChar+"='"+cNetAccPrvNbr +"' and processed=0 and assmntcd='PF'"
					oStmnt:Execute() 
					oStmnt:SQLString:="update importtrans set "+sIdentChar+"accountnr"+sIdentChar+"='"+cExpAccNbr+;
					"' where "+sIdentChar+"accountnr"+sIdentChar+"='"+cExpAccPrvNbr +"' and processed=0 and assmntcd='CH'"
					oStmnt:Execute() 
				endif
			endif 
		ENDIF
		IF lNewMember
			self:mMbrId:=ConS(SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
			* Connect person to member: 
			// 			oStmnt:SQLString:="update person set accid="+self:mREK+",type='"+iif(self:mGrade='Entity',PersTypeValue("ENT"),PersTypeValue("MBR"))+"'"+;
			oStmnt:SQLString:="update person set type='"+iif(self:mGrade='Entity',PersTypeValue("ENT"),PersTypeValue("MBR"))+"'"+;
				iif(self:mGrade='Entity',",gender=4","") +;
				",mailingcodes='"+MergeMLCodes(self:mCod,"MW")+"'"+;
				" where persid="+self:mCLN 
			oStmnt:Execute()
		ENDIF
		IF self:AccDepSelect=='account'
			if lNewMember .or. !mAccidPrv == self:mREK .or. !mCLNPrv == mCLN
				* New Account or new description?
				* Connect new Account:
				// 			oStmnt:SQLString:="update account set persid="+self:mCLN+",GIFTALWD=1,description='"+cMemberName+"' where accid="+self:mREK
				oStmnt:SQLString:="update account set giftalwd=1,description='"+StrTran(self:cMemberName,"'","\'")+"' where accid="+self:mREK
				oStmnt:Execute()
			ELSEIF !AllTrim(self:cAccountName)==AllTrim(self:cMemberName)
				* Name changed of member:
				oStmnt:SQLString:="update account set description='"+StrTran(self:cMemberName,"'","\'")+"' where accid="+self:mREK
				oStmnt:Execute()
			ENDIF
		else
			if lNewMember .or. !mDepPrv == self:mDepId   .or. !mCLNPrv == mCLN
				* New Department 
				* Connect new Department:
				oStmnt:SQLString:="update account set giftalwd=1 where accid in (select incomeacc from department where depid="+self:mDepId+")"
				oStmnt:execute()
				oStmnt:SQLString:="update department set descriptn='"+StrTran(self:cMemberName,"'","\'")+"' where depid="+self:mDepId
				oStmnt:Execute()
			endif
		endif
		// remove associated accounts:
		for i:=1 to Len(self:aAssOrg)
			if AScan(aAss,self:aAssOrg[i])=0
				// remove:
				SQLStatement{"delete from memberassacc where mbrid="+self:mMbrId+" and accid="+self:aAssOrg[i],oConn}:Execute()
			endif
		next
		// add associated accounts:
		for i:=1 to Len(aAss)
			if AScan(self:aAssOrg,aAss[i])=0
				// add:
				SQLStatement{"insert into memberassacc set mbrid="+self:mMbrId+",accid="+aAss[i],oConn}:Execute()
			endif
		next
		// remove distribution instructions:
		for i:=1 to Len(self:aDistrOrg)
			if AScan(aDistrm,{|x|x[SEQNBR]=aDistrOrgm[i,SEQNBR]})=0
				// remove:
				SQLStatement{"delete from distributioninstruction where mbrid="+self:mMbrId+" and seqnbr="+Str(self:aDistrOrg[i,SEQNBR],-1),oConn}:Execute()
			endif
		next
		// add distribution instructions:
		for i:=1 to Len(self:aDistr)
			// 			",dfir='"+self:aDistr[i,DFIR]+"',dfia='"+self:aDistr[i,DFIA]+"',checksave='"+self:aDistr[i,CHECKSAVE]+"'"+;
			cStatement:=iif(self:lNew.or.AScan(aDistrOrgm,{|x|x[SEQNBR]=aDistrm[i,SEQNBR]})=0, "insert into distributioninstruction set mbrid='"+self:mMbrId+"', seqnbr='" +Str(self:aDistr[i,SEQNBR],-1)+"',",;
				"update distributioninstruction set ")+;
				"descrptn='"+self:aDistr[i,DESCRPTN]+"'"+;
				",destpp='"+ self:aDistr[i,DESTPP]+"'"+;                      
			",destacc='"+ self:aDistr[i,DESTACC]+"'"+;
				",destamt  ="+ Str(self:aDistr[i,DESTAMT],-1) +;
				",desttyp  ="+ str(self:aDistr[i,Desttyp],-1)+;
				",currency="+Str(self:aDistr[i,CURRENCY],-1)+;
				",disabled="+Str(self:aDistr[i,DISABLED],-1)+; 
			",singleuse="+Str(self:aDistr[i,SINGLEUSE],-1) +;
				iif(self:lNew.or.AScan(aDistrOrgm,{|x|x[SEQNBR]=aDistrm[i,SEQNBR]})=0,""," where mbrid="+self:mMbrId+" and seqnbr="+Str(self:aDistr[i,SEQNBR],-1)) 
			oStmnt:=SQLStatement{cStatement,oConn}
			oStmnt:Execute()
		next 
		self:aDistrOrg:=self:aDistr    // for close
		* Reset BFM for not-reporting backwards to IES/PMC:  ( at this moment dReportDate always empty) 
		// 		IF lResetBFM.and. dReportDate>LstYearClosed
		// 			* Reset all transactions: 
		// 			oStmnt:SQLString:="update transaction set bfm='H' where accid="+self:mREK+" and bfm='' and dat<"+SQLdate(dReportDate)
		// 			oStmnt:Execute()
		// 		ENDIF
		// refresh oCaller:
		if !Empty( self:oCaller)
			self:oCaller:oMem:Execute()
			self:oCaller:GoTop()
		endif
		self:Pointer := Pointer{POINTERARROW}
		self:EndWindow()
		
	ENDIF
	
	RETURN nil
METHOD PersonButton(lUnique )  CLASS EditMember
	LOCAL cValue := AllTrim(oDCmPerson:TEXTValue ) as STRING 
	local oPersCnt:=PersonContainer{} as PersonContainer
	Default(@lUnique,FALSE)
	if self:lNewMember 
		PersonSelect(self,cValue,lUnique,'p.persid not in (select m.persid from member m where m.persid=p.persid)',"Member")
	else
		oPersCnt:current_PersonID:=self:oMbr:persid 
		oPersCnt:persid:=ConS(self:oMbr:persid)
//  		PersonSelect(self,cValue,lUnique,'persid="'+Str(self:oMbr:persid,-1)+'" or p.persid not in (select m.persid from member m where m.persid=p.persid)',"Member",oPersCnt)
 		PersonSelect(self,cValue,lUnique,,"Member",oPersCnt)
	endif
METHOD PersonButtonContact(lUnique) CLASS EditMember
	LOCAL cValue := AllTrim(SELF:oDCmPersonContact:TEXTValue ) AS STRING
	local oPersCnt:=PersonContainer{} as PersonContainer
	Default(@lUnique,FALSE)
	if self:lNewMember 
		PersonSelect(self,cValue,lUnique,'p.persid<>"'+self:mCLN+'"',"Contact Person")
	else
		oPersCnt:current_PersonID:=self:oMbr:CONTACT
 		PersonSelect(self,cValue,lUnique,'p.persid<>"'+self:mCLN+'"',"Contact Person",oPersCnt)
	endif
// 	PersonSelect(self,cValue,lUnique,'persid<>"'+self:mCLN+'"',"Contact Person")
	return
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditMember
	//Put your PostInit additions here
	LOCAL it as int
	LOCAL oColREk, oColName as ListViewColumn
	LOCAL oColPP,oColAcc,oColDesc,oColTyp,oColAmt,oColEnabled as ListViewColumn
	LOCAL aAss:={},oneAss as ARRAY, i as int
	LOCAL oAccAss as SQLSelect
	LOCAL oItem	as ListViewItem
	local oDis as SQLSelect
	local oLast as SQLSelect 
	self:SetTexts()
	// initialize listview with ass.accounst:
	oColREk:=ListViewColumn{11,self:oLan:WGet("Account")+'#'}
	oColREk:NameSym:=#Number
	oColName:=ListViewColumn{32,self:oLan:WGet("Name")}
	oColName:NameSym:=#Name
	self:oDCListViewAssAcc:AddColumn(oColREk)
	self:oDCListViewAssAcc:AddColumn(oColName) 


	// initialize listview with distribution instructions:
	oColEnabled:=ListViewColumn{5,self:oLan:WGet("Active")}
	oColEnabled:NameSym:=#DestEnabled
	oColPP:=ListViewColumn{6,self:oLan:WGet("Dest PO")}
	oColPP:NameSym:=#DestPP
	oColAcc:=ListViewColumn{9,self:oLan:WGet("Destn Acct")}
	oColAcc:NameSym:=#DestAcc
	oColDesc:=ListViewColumn{19,self:oLan:WGet("Description")}
	oColDesc:NameSym:=#Descrptn
	oColTyp:=ListViewColumn{10,self:oLan:WGet("Type")}
	oColTyp:NameSym:=#DestTyp
	oColAmt:=ListViewColumn{7,self:oLan:WGet("Amount"),LVCFMT_RIGHT}
	oColAmt:NameSym:=#DestAmt
	self:oDCDistrListView:AddColumn(oColEnabled)
	self:oDCDistrListView:AddColumn(oColPP)
	self:oDCDistrListView:AddColumn(oColAcc)
	self:oDCDistrListView:AddColumn(oColDesc)
	self:oDCDistrListView:AddColumn(oColTyp)
	self:oDCDistrListView:AddColumn(oColAmt)
	oDCDistrListView:GridLines := true
	oDCDistrListView:FullRowSelect := true
// 	if SuperUser .or. SEntity=='NED'
// 		self:oDCAccDepSelect:AddItem("department:",2,'department')
// 	endif
	self:oDCAccDepSelect:Value:='account'

	IF lNewMember
		// 		SELF:oDCmAccount:SetFocus()
		self:oDCmPPCode:Value:=SEntity
		self:mAccDept:=""
		self:mPerson:=""
		self:mPersonContact=""
		self:mCLN=""
		self:mCLNContact=""
		self:mHomeAcc:=""
		self:mCod:=""
		self:mAOW:=0
		self:mZKV:=0
		self:mHAS:=False
		self:withldoffrate:=""
		self:oDCwithldoffrate:Hide()
		self:oDCwithldofftxt:Hide()
	ELSE 
		self:oMbr:=SQLSelect{"select m.householdid,m.mbrid,m.aow,m.zkv,m.homeacc,m.has,m.contact,m.rptdest,m.homepp,m.co,m.grade,m.offcrate,"+;
		"m.accid,m.depid,m.persid,a.description,p.mailingcodes,"+SQLFullName(0,"p")+" as membername, "+; 
		"d.depid,d.deptmntnbr,d.descriptn as depname, ";
			+SQLFullName(0,"c")+" as contactname,b.category as type, group_concat(cast(am.accid as char),']',am.accnumber,']',am.description separator '|') as assoctd "+;
			" from person p,member m "+;
			" left join account a on (a.accid=m.accid) left join balanceitem as b on ( b.balitemid=a.balitemid)"+;
			" left join department d on (d.depid=m.depid) "+;
			"left join person as c on (c.persid=m.contact) "+; 
		"left join memberassacc ass on (m.mbrid=ass.mbrid) left join account am on (am.accid=ass.accid) " +;
			" where p.persid=m.persid and m.mbrid="+self:mMbrId,oConn} 
		self:cCurDep:=AllTrim(Transform(self:oMbr:depid,""))
		self:mDepid:=self:cCurDep
		self:cCurType:=Transform(self:oMbr:Type,"")

		self:mHBN := self:oMbr:householdid
		self:mAOW := self:oMbr:AOW
		self:mZKV := self:oMbr:ZKV
		self:mHomeAcc:= self:oMbr:HOMEACC
		self:mCLN := Str(self:oMbr:persid,-1)
		self:mREK := AllTrim(Transform(self:oMbr:accid,""))
		self:mMbrId:=Str(self:oMbr:MbrId,-1)
		self:mRekOrg:=self:mREK 
		self:mCLN := Str(self:oMbr:persid,-1)
		self:mHAS := iif(ConI(self:oMbr:HAS)=1,true,false)
		self:mPerson := self:oMbr:membername
		self:cMemberName := mPerson
		self:cAccountName:=AllTrim(Transform(self:oMbr:Description,""))
		self:cDepartmentName:=AllTrim(Transform(self:oMbr:depname,""))
		if Empty(self:oMbr:accid)
			// member with department:
			self:AccDepSelect:='department'
			self:mAccDept:=self:oMbr:depname
		else
			self:AccDepSelect:='account'
			self:mAccDept:=self:oMbr:Description
		endif

		self:mCod:=self:oMbr:mailingcodes
		self:mCLNContact := ConS(self:oMbr:CONTACT)
		if !Empty(self:mCLNContact)
			self:mPersonContact := self:oMbr:contactname
			self:cContactName := self:mPersonContact
			if Empty(self:mPersonContact)
				self:mCLNContact:=''  // apparently non-existing person 
			endif
		endif
		self:StatemntsDest:=Str(self:oMbr:RPTDEST,-1)
		self:oDCmPPCode:Value:=self:oMbr:HomePP
		IF !Empty(self:oMbr:assoctd)
			aAss:={} 
			aAss:=Split(self:oMbr:assoctd,"|")
			FOR i:=1 to Len(aAss)
				IF !Empty(aAss[i]) 
					//	add item	to	listview:
					oneAss:=Split(aAss[i],']')
					oItem:=ListViewItem{}
					oItem:SetText(oneAss[2],#Number)
					oItem:SetValue(oneAss[1],#Number)
					oItem:SetText(oneAss[3],#Name)
					oItem:SetValue(oneAss[1],#Name)
					self:oDCListViewAssAcc:AddItem(oItem)
					AAdd(self:aAssOrg,oneAss[1])
				ENDIF
				// 				ENDIF
			NEXT
		ENDIF
		self:withldoffrate:=oMbr:OFFCRATE
		// fill array with distribution instruction:
		oDis:=SQLSelect{"select mbrid,seqnbr,destacc,destpp,desttyp,destamt,cast(lstdate as date) as lstdate,descrptn,currency,disabled,amntsnd,dfir,dfia,checksave,singleusE from distributioninstruction where mbrid ="+self:mMbrId+" order by seqnbr" ,oConn} 
		if oDis:RecCount>0
			DO WHILE !oDis:EoF 
				AAdd(self:aDistr,{+;
					oDis:MbrId,+;
					oDis:SEQNBR,+;
					oDis:DESTACC,+;
					oDis:DESTPP,+;
					oDis:DESTTYP,+;
					oDis:DESTAMT,+;
					oDis:LSTDATE,+;
					oDis:DESCRPTN,+;
					ConI(oDis:CURRENCY),+;
					ConI(oDis:DISABLED),+;
					oDis:AMNTSND,+;
					oDis:DFIR,+;
					oDis:DFIA,+;
					oDis:CHECKSAVE,+; 
				ConI(oDis:SINGLEUSE)})	
				oDis:Skip()
			ENDDO
			self:aDistrOrg:=AClone(self:aDistr)	
		endif
		oLast:=SqlSelect{"select max(seqnbr) as maxseq from distributioninstruction where mbrid="+self:mMbrId,oConn}
		IF Empty(oLast:maxseq)
			self:maxseq:=1
		ELSE
			self:maxseq:=oLast:maxseq+1
		ENDIF

		// fill distribution instructions:
		self:FillDistribution()
		IF self:oMbr:CO=='M'
			self:mGRADE := self:oMbr:Grade
			IF mPPCode=SEntity
				self:oDCmHAS:show()
			else
				self:oDCmHAS:Hide()
			endif
			self:ShowDistribution(true)
			//	ELSE
			//		SELF:ShowDistribution(FALSE)
			//	ENDIF
			self:oDCwithldoffrate:Hide()
			self:oDCwithldofftxt:Hide()
		ELSE
			self:oDCmHBN:Hide()
			self:oDCmHAS:Hide()
			self:oDCHousecodetxt:Hide()
			IF self:oMbr:HomePP!=SEntity
				self:oDCHomeAccTxt:show()
				self:oDCmHomeAcc:show()
				self:ShowDistribution(FALSE)
			ELSE
				self:ShowDistribution(true)
			ENDIF
			self:oDCwithldoffrate:show()
			self:oDCwithldofftxt:show()			
			IF self:oMbr:CO='S'
				self:mGRADE:='Entity'
			ELSE
				self:mGRADE:='Entity 19999'
			ENDIF
		ENDIF
		self:mGradeOrg:=self:mGRADE
		self:oDCmGrade:SetFocus()
	ENDIF
	self:ShowStmntDest()
	IF Admin#"WO"
		// Hide PMC details:
		self:oDCGroupBox1:Hide()
		self:oDCSC_GRADE:Hide()
		self:oDCmGrade:Hide()
		self:oDCmHBN:Hide()
		self:oDCmHAS:Hide()
		self:oDCHousecodetxt:Hide()
		self:oDCSC_FinancePO:Hide()
		self:oDCmPPCode:Hide()
		self:oDCmHomeAcc:Hide()
		self:oDCHomeAccTxt:Hide()
		self:oDCDistrListView:Hide()
		self:oDCwithldofftxt:Hide()
		self:oDCwithldoffrate:Hide()
		self:oCCNewButton:Hide()
		self:oCCEditButton:Hide()
		self:oCCDeleteButton:Hide()
		self:oDCGroupBox3:Hide()
	ENDIF 
	if AScan(aMenu,{|x|x[4]=="MemberEdit"})=0
		self:oCCNewButton:Hide()
		self:oCCEditButton:Hide()
		self:oCCDeleteButton:Hide()
		self:oCCOKButton:Hide()
		self:oCCAddButton:Hide()
		self:oCCRemoveButton:Hide()		
	endif
	RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class EditMember
	//Put your PreInit additions here
   IF !Empty(uExtra)
   	IF IsArray(uExtra)
	  		IF IsObject(uExtra[2])
	   	    self:oCaller:=uExtra[2]
	  		ENDIF
			self:lNew:=uExtra[1]
			IF Len(uExtra) > 2
// 				self:mRek := iif(Empty(uExtra[3]),"",iif(IsNumeric(uExtra[3]),Str(uExtra[3],-1),uExtra[3]))
				self:mMbrId := iif(Empty(uExtra[3]),"",iif(IsNumeric(uExtra[3]),Str(uExtra[3],-1),uExtra[3]))
			endif
		ELSE
			self:lNew:=uExtra
   	ENDIF
   	self:lNewMember:=lNew
	ENDIF
	return nil

METHOD Refresh() CLASS EditMember
	SELF:oSFSub_Distributions:Browser:Refresh()
RETURN NIL
METHOD RemoveButton( ) CLASS EditMember
	IF Empty(SELF:oDCListViewAssAcc:GetSelectedItem())
 		(ErrorBox{,"Select first an ASsociated account"}):Show()
 	ELSE
		SELF:oDCListViewAssAcc:DeleteItem((SELF:oDCListViewAssAcc:GetSelectedItem()):ItemIndex)
	ENDIF
	RETURN NIL
METHOD RestoreUpdate() CLASS EditMember
	SELF:oSFSub_Distributions:Browser:RestoreUpdate()
RETURN NIL
METHOD ShowDistribution(show)  CLASS EditMember
	// show or hide distribution instructions:
	IF show
     	SELF:oDCGroupBox3:Show()
     	//SELF:oSFSub_Distributions:Show()
     	SELF:oDCDistrListView:Show()
     	SELF:oCCNewButton:Show()
     	SELF:oCCEditButton:Show()
     	SELF:oCCDeleteButton:Show()
	ELSE
     	SELF:oDCGroupBox3:Hide()
     	//SELF:oSFSub_Distributions:Hide()
     	SELF:oDCDistrListView:Hide()
     	SELF:oCCNewButton:Hide()
     	SELF:oCCEditButton:Hide()
     	SELF:oCCDeleteButton:Hide()

     ENDIF


METHOD ShowStmntDest() CLASS EditMember
	IF Empty(mCLNContact)
		SELF:oCCDestButton2:Hide()
		self:oCCDestButton3:Hide() 
		if self:StatemntsDest=='1'
			self:StatemntsDest:='3'
		elseif self:StatemntsDest=='2'
			self:StatemntsDest:='0'
		endif
	ELSE
		SELF:oCCDestButton2:Show()
		self:oCCDestButton3:show()
	ENDIF		
RETURN
ACCESS StatemntsDest() CLASS EditMember
RETURN SELF:FieldGet(#StatemntsDest)

ASSIGN StatemntsDest(uValue) CLASS EditMember
SELF:FieldPut(#StatemntsDest, uValue)
RETURN uValue

METHOD SuspendUpdate() CLASS EditMember
	SELF:oSFSub_Distributions:Browser:SuspendUpdate()
RETURN NIL
METHOD ValidateMember(dummy:=nil as logic) as logic CLASS EditMember
	LOCAL lValid := TRUE AS LOGIC
	LOCAL cError as STRING
	LOCAL oTextBox AS TextBox
	LOCAL uRet AS USUAL
	LOCAL propsum AS FLOAT
	LOCAL oMem as SQLSelect
	LOCAL aDistrm:=self:aDistr as array
	Local n,myMbrId:=Val(self:mMbrId) as int
	local cLastname,cGiftsAccs as string
	local oDep,aAcc as SQLSelect 

	*Check obliged fields:
	IF Empty(self:mCLN)
		lValid := FALSE
		cError :=  oLan:WGet("Person is obliged")+"!"
		SELF:oDCmPerson:SetFocus()
	ELSEIF Empty(self:mRek).and. self:AccDepSelect=='account'
		lValid := FALSE
		cError :=  oLan:WGet("Account is obliged")+"!"
		self:oDCmAccDept:SetFocus()
	ELSEIF Empty(self:mDepId).and. self:AccDepSelect=='department'
		lValid := FALSE
		cError :=  oLan:WGet("Department is obliged")+"!"
		self:oDCmAccDept:SetFocus()
	ENDIF
	IF Admin="WO".or.Admin="HO"
		IF lValid.and. Empty(self:mGRADE)
			lValid := FALSE
			cError :=  oLan:WGet("Type is obliged")+"!"
			SELF:oDCmGrade:SetFocus()
		ENDIF
	ENDIF
	IF Admin="WO"
		IF lValid.and. Empty(SELF:mPPCode)
			lValid := FALSE
			cError :=  oLan:WGet("Home PP is obliged")+"!"
			SELF:oDCmPPCode:SetFocus()
		ENDIF
		IF lValid.and. Empty(SELF:mGrade)
			lValid := FALSE
			cError :=  oLan:WGet("Type is obliged")+"!"
			SELF:oDCmGrade:SetFocus()
		ENDIF
		IF lValid.and. self:mGRADE # "Entity" .and. Empty(self:mHBN)
			lValid := FALSE
			cError :=  oLan:WGet("Household id is obliged")+"!"
			SELF:oDCmHBN:SetFocus()
		ENDIF
		IF lValid .and.self:mGRADE # "Entity"
			// check unique household code:
			// 			oMem:=SQLSelect{"select a.accid,m.persid from member m, account a where a.accid=m.accid and householdid='"+AllTrim(self:mHBN)+"'"+iif(self:lNewMember,""," and accid<>"+self:mRekOrg),oConn}
			oMem:=SQLSelect{"select m.persid from member m where householdid='"+AllTrim(self:mHBN)+"'"+iif(self:lNewMember,""," and mbrid<>"+self:mMbrId),oConn}
			if oMem:RecCount>0
				lValid := FALSE
				cError := oLan:WGet("Household id allready assigned to member")+" "+GetFullName(Str(oMem:persid,-1))
				self:oDCmHBN:SetFocus()
				exit
			ENDIF
		ENDIF
		IF lValid .and.self:mGRADE # "Entity" .and. self:mPPCode # Sentity
			// check legal distribution codes for foreign members 
			if AScan(aDistrm,{|x|x[mbrid]=myMbrId.and. !x[DESTPP]==Sentity .and.!x[DESTPP]=='AAA' }) >0
				// 			if SQLSelect{"select destpp,accid from DistributionInstruction where (accid="+self:mRek+iif(self:lNewMember,""," or accid="+self:mRekOrg)+") and DESTPP<>'"+Sentity+"' and DESTPP<>'AAA'",oConn}:RecCount>0
				lValid := FALSE
				cError := oLan:WGet("Only distribution instructions to")+" "+Sentity+" "+oLan:WGet("and bank allowed in case of this not own member")
				self:oDCDistrListView:SetFocus() 
				self:oDCDistrListView:SelectItem(n)
			endif			
		endif
		IF lValid .and. self:AccDepSelect=='account'
			cError:=ValidateMemberType(iif(self:mGRADE='Entity','S','M'),self:mPPCode,self:cCurType)
			if !Empty(cError)
				lValid := FALSE
				self:oDCmAccDept:SetFocus()
			endif
		endif
		// Check if name allready exists of the account: 
		if lValid .and. self:AccDepSelect=='account'
			if self:lNewMember .or. !AllTrim(self:cMemberName)== AllTrim(self:oMbr:membername)
				if SqlSelect{"select description from account where accid<>"+self:mRek +iif(self:lNewMember.or.!Empty(self:cCurDep),""," and accid<>'"+self:mRekOrg+"'")+" and description='"+AllTrim(cMemberName)+"'",oConn}:RecCount>0
					cError:=self:oLan:WGet('Account description')+' "'+AllTrim(cMemberName)+'" '+self:oLan:WGet('allready exist')
					lValid:=FALSE
					self:oDCmAccDept:SetFocus()
				ENDIF
			endif 
		endif
		if lValid .and. self:AccDepSelect=='department'
			// department: check if name of department contains lastname of member:
			cLastname:=SQLSelect{"select lastname from person where persid="+self:mCLN,oConn}:lastname
			if AtC(cLastname,self:cDepartmentName)=0
				cError:=self:oLan:WGet('Department description should contain lastname of member')+': "'+AllTrim(cLastname)+'" '
				lValid:=FALSE
				self:oDCmAccDept:SetFocus()
			endif 
			if lValid
				oDep:=SQLSelect{"select d.incomeacc,d.expenseacc,ai.description as incname,ae.description as expname from department d "+;
					"left join account ai on (ai.accid=d.incomeacc) left join account ae on (ae.accid=d.expenseacc) where d.depid="+self:mDepId,oConn}
				if oDep:RecCount>0
					if Empty(oDep:incomeacc)
						cError:=self:oLan:WGet('Account income obliged for department member')
						lValid:=FALSE
						self:oDCmAccDept:SetFocus()
					ELSEif AtC(cLastname,oDep:incname)=0
						cError:=self:oLan:WGet('Description of Account Income  of the Department should contain lastname of member')+': "'+AllTrim(cLastname)+'" '
						lValid:=FALSE
						self:oDCmAccDept:SetFocus() 
					elseif Empty(oDep:expenseacc)
						cError:=self:oLan:WGet('Account expense obliged for department member')
						lValid:=FALSE
						self:oDCmAccDept:SetFocus()
					ELSEif AtC(cLastname,oDep:expname)=0
						cError:=self:oLan:WGet('Description of Account Expense  of the Department should contain lastname of member')+': "'+AllTrim(cLastname)+'" '
						lValid:=FALSE
						self:oDCmAccDept:SetFocus() 
					ENDIF
					if lValid 
						// check if only Income account is Gifts receivable:
						cGiftsAccs:=ConS(SqlSelect{" select group_concat(description separator ', ') as giftsaccs from account where department="+self:mDepId+" and giftalwd=1 and accid<>"+ConS(oDep:incomeacc),oConn}:giftsaccs)
						if !Empty(cGiftsAccs)
							cError:=self:oLan:WGet("Following accounts should not be gifts receivable")+': '+cGiftsAccs
							lValid:=FALSE
							self:oDCmAccDept:SetFocus()
						endif 
					endif
				endif				
			endif
		endif
		// Clearing Person code
		IF lValid 
			if !self:lNewMember.and.!AllTrim(self:oMbr:GRADE) == AllTrim(self:mGrade)
				IF AllTrim(self:mGrade)="Staf"
					* Changed to staff:
					oTextBox := TextBox{ self, oLan:WGet("Editing of a member"),;
						oLan:WGet("No gifts will be assessed anymore")+"!"}
					oTextBox:Type := BUTTONOKAYCANCEL
					IF ( oTextBox:Show() == BOXREPLYCANCEL )
						lValid := FALSE
						cError := oLan:WGet("Choose other type than Staf")
						self:oDCmGrade:SetFocus()
					ENDIF
				ELSEIF AllTrim(self:oMbr:GRADE)="Staf"
					* from staff to other type:
					uRet:=(ReportDateMember{self}):Show()
					IF uRet=0
						lValid := FALSE
						cError := oLan:WGet("Keep type Staf")
						self:oDCmGrade:SetFocus()
					ENDIF
				ENDIF
			endif
		ENDIF
	ENDIF
	IF ! lValid
		(ErrorBox{,cError}):Show()
	ENDIF

	RETURN lValid
ACCESS withldoffrate() CLASS EditMember
RETURN SELF:FieldGet(#withldoffrate)

ASSIGN withldoffrate(uValue) CLASS EditMember
SELF:FieldPut(#withldoffrate, uValue)
RETURN uValue

STATIC DEFINE EDITMEMBER_ACCBUTTON := 103 
STATIC DEFINE EDITMEMBER_ACCDEPSELECT := 140 
STATIC DEFINE EDITMEMBER_ADDBUTTON := 128 
STATIC DEFINE EDITMEMBER_CANCELBUTTON := 106 
STATIC DEFINE EDITMEMBER_DELETEBUTTON := 107 
STATIC DEFINE EDITMEMBER_DESTBUTTON1 := 136 
STATIC DEFINE EDITMEMBER_DESTBUTTON2 := 137 
STATIC DEFINE EDITMEMBER_DESTBUTTON3 := 138 
STATIC DEFINE EDITMEMBER_DESTBUTTON4 := 135 
STATIC DEFINE EDITMEMBER_DISTRLISTVIEW := 130 
STATIC DEFINE EDITMEMBER_EDITBUTTON := 108 
STATIC DEFINE EDITMEMBER_FIXEDTEXT9 := 133 
STATIC DEFINE EDITMEMBER_GROUPBOX1 := 123 
STATIC DEFINE EDITMEMBER_GROUPBOX2 := 126 
STATIC DEFINE EDITMEMBER_GROUPBOX3 := 110 
STATIC DEFINE EDITMEMBER_HOMEACCTXT := 125 
STATIC DEFINE EDITMEMBER_HOUSECODETXT := 113 
STATIC DEFINE EDITMEMBER_LISTVIEWASSACC := 127 
STATIC DEFINE EDITMEMBER_MACCDEPT := 102 
STATIC DEFINE EDITMEMBER_MAOW := 119 
STATIC DEFINE EDITMEMBER_MGRADE := 116 
STATIC DEFINE EDITMEMBER_MHAS := 139 
STATIC DEFINE EDITMEMBER_MHBN := 112 
STATIC DEFINE EDITMEMBER_MHOMEACC := 124 
STATIC DEFINE EDITMEMBER_MPERSON := 100 
STATIC DEFINE EDITMEMBER_MPERSONCONTACT := 121 
STATIC DEFINE EDITMEMBER_MPPCODE := 115 
STATIC DEFINE EDITMEMBER_MZKV := 120 
STATIC DEFINE EDITMEMBER_NEWBUTTON := 109 
STATIC DEFINE EDITMEMBER_OKBUTTON := 105 
STATIC DEFINE EDITMEMBER_PERSONBUTTON := 101 
STATIC DEFINE EDITMEMBER_PERSONBUTTONCONTACT := 122 
STATIC DEFINE EDITMEMBER_REMOVEBUTTON := 129 
STATIC DEFINE EDITMEMBER_SC_ACCDEP := 141 
STATIC DEFINE EDITMEMBER_SC_AOW := 117 
STATIC DEFINE EDITMEMBER_SC_CLN := 104 
STATIC DEFINE EDITMEMBER_SC_FINANCEPO := 114 
STATIC DEFINE EDITMEMBER_SC_GRADE := 111 
STATIC DEFINE EDITMEMBER_SC_REK := 104 
STATIC DEFINE EDITMEMBER_SC_ZKV := 118 
STATIC DEFINE EDITMEMBER_STATEMNTSDEST := 134 
STATIC DEFINE EDITMEMBER_WITHLDOFFRATE := 132 
STATIC DEFINE EDITMEMBER_WITHLDOFFTXT := 131 
STATIC DEFINE EDITMEMBERNEW_DELETEBUTTON := 100 
STATIC DEFINE EDITMEMBERNEW_EDITBUTTON := 101 
STATIC DEFINE EDITMEMBERNEW_NEWBUTTON := 102 
STATIC DEFINE EDITMEMBERNEW_SUB_DISTRIBUTIONS := 103 
STATIC DEFINE EDITMEMBEROUD_ACCBUTTON := 103 
STATIC DEFINE EDITMEMBEROUD_ADDBUTTON := 119 
STATIC DEFINE EDITMEMBEROUD_CANCELBUTTON := 124 
STATIC DEFINE EDITMEMBEROUD_DELETEBUTTON := 130 
STATIC DEFINE EDITMEMBEROUD_EDITBUTTON := 129 
STATIC DEFINE EDITMEMBEROUD_GROUPBOX1 := 109 
STATIC DEFINE EDITMEMBEROUD_GROUPBOX2 := 114 
STATIC DEFINE EDITMEMBEROUD_GROUPBOX3 := 117 
STATIC DEFINE EDITMEMBEROUD_HOMEACCTXT := 125 
STATIC DEFINE EDITMEMBEROUD_HOUSECODETXT := 115 
STATIC DEFINE EDITMEMBEROUD_LISTVIEWASSACC := 118 
STATIC DEFINE EDITMEMBEROUD_MACCOUNT := 102 
STATIC DEFINE EDITMEMBEROUD_MAOW := 121 
STATIC DEFINE EDITMEMBEROUD_MGRADE := 110 
STATIC DEFINE EDITMEMBEROUD_MHAS := 111 
STATIC DEFINE EDITMEMBEROUD_MHBN := 113 
STATIC DEFINE EDITMEMBEROUD_MHOMEACC := 126 
STATIC DEFINE EDITMEMBEROUD_MPERSON := 100 
STATIC DEFINE EDITMEMBEROUD_MPPCODE := 112 
STATIC DEFINE EDITMEMBEROUD_MZKV := 122 
STATIC DEFINE EDITMEMBEROUD_NEWBUTTON := 128 
STATIC DEFINE EDITMEMBEROUD_OKBUTTON := 123 
STATIC DEFINE EDITMEMBEROUD_PERSONBUTTON := 101 
STATIC DEFINE EDITMEMBEROUD_REMOVEBUTTON := 120 
STATIC DEFINE EDITMEMBEROUD_SC_AOW := 107 
STATIC DEFINE EDITMEMBEROUD_SC_CLN := 105 
STATIC DEFINE EDITMEMBEROUD_SC_FINANCEPO := 116 
STATIC DEFINE EDITMEMBEROUD_SC_GRADE := 106 
STATIC DEFINE EDITMEMBEROUD_SC_REK := 104 
STATIC DEFINE EDITMEMBEROUD_SC_ZKV := 108 
STATIC DEFINE EDITMEMBEROUD_SUB_DISTRIBUTIONS := 127 
CLASS Employee_Grade INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Employee_Grade

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL   
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL  

    symHlName   := #Grade 

    cPict       := ""
    cTypeDiag   := "" 
    cTypeHelp   := "" 
    cLenDiag    := "" 
    cLenHelp    := "" 
    cMinLenDiag := "" 
    cMinLenHelp := "" 
    cRangeDiag  := "" 
    cRangeHelp  := "" 
    cValidDiag  := "" 
    cValidHelp  := "" 
    cReqDiag    := "" 
    cReqHelp    := "" 

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL              
    lRequired   := .F.   


    SUPER:Init( HyperLabel{symHlName, "Status", "Status", "Employee_Grade" },  "C", 3, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




function FillPP() as array
	local oPP as SQLSelect
oPP:=SqlSelect{"select concat(ppname,if(ppcode='','',concat(' (',ppcode,')'))) as ppname ,ppcode from ppcodes where ppcode<>'AAA' and ppcode<>'ACH'",oConn}
// oPP:SetFilter({||!oPP:PPCODE=="AAA".and. !oPP:PPCODE=="ACH" .and.!Empty(oPP:PPCODE)})
// oPP:GoTop()
return oPP:GetLookupTable(500,#PPNAME,#PPCODE)

static define LSTDATE:=7
static define mbrid:=1
CLASS MemberBrowser INHERIT DataWindowExtra 

	PROTECT oDCSearchUni AS SINGLELINEEDIT
	PROTECT oDCSC_REK AS FIXEDTEXT
	PROTECT oDCSC_OMS AS FIXEDTEXT
	PROTECT oDCSearchREK AS SINGLELINEEDIT
	PROTECT oDCSearchOMS AS SINGLELINEEDIT
	PROTECT oCCFindButton AS PUSHBUTTON
	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oDCProjectsBox AS CHECKBOX
	PROTECT oDCNonHomeBox AS CHECKBOX
	PROTECT oDCHomeBox AS CHECKBOX
	PROTECT oCCConvertButton AS PUSHBUTTON
	PROTECT oSFMemberBrowser_DETAIL AS MemberBrowser_DETAIL

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)  
  export oMem as SQLSelect 
  export cFrom,cOrder,cFields,cWhere as string
RESOURCE MemberBrowser DIALOGEX  21, 19, 431, 341
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", MEMBERBROWSER_SEARCHUNI, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 18, 116, 12
	CONTROL	"&Number:", MEMBERBROWSER_SC_REK, "Static", WS_CHILD, 16, 33, 30, 12
	CONTROL	"N&ame", MEMBERBROWSER_SC_OMS, "Static", WS_CHILD, 16, 49, 24, 12
	CONTROL	"", MEMBERBROWSER_SEARCHREK, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 33, 116, 12
	CONTROL	"", MEMBERBROWSER_SEARCHOMS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 48, 116, 12
	CONTROL	"Find", MEMBERBROWSER_FINDBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 224, 18, 53, 12
	CONTROL	"", MEMBERBROWSER_MEMBERBROWSER_DETAIL, "static", WS_CHILD|WS_BORDER, 8, 118, 350, 210
	CONTROL	"&Edit", MEMBERBROWSER_EDITBUTTON, "Button", WS_TABSTOP|WS_CHILD, 364, 125, 53, 12
	CONTROL	"&New", MEMBERBROWSER_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 364, 176, 53, 12
	CONTROL	"&Delete", MEMBERBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 364, 227, 53, 12
	CONTROL	"Members", MEMBERBROWSER_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 107, 420, 225
	CONTROL	"Search member with:", MEMBERBROWSER_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 8, 208, 91
	CONTROL	"Universal like google:", MEMBERBROWSER_FIXEDTEXT4, "Static", WS_CHILD, 16, 18, 72, 12
	CONTROL	"", MEMBERBROWSER_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 259, 44, 47, 12
	CONTROL	"Found:", MEMBERBROWSER_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 224, 44, 27, 13
	CONTROL	"Projects", MEMBERBROWSER_PROJECTSBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 16, 84, 80, 12
	CONTROL	"Members not of", MEMBERBROWSER_NONHOMEBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 16, 73, 200, 11
	CONTROL	"Members of", MEMBERBROWSER_HOMEBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 16, 62, 200, 11
	CONTROL	"Convert", MEMBERBROWSER_CONVERTBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 284, 18, 53, 12
END

method ButtonClick(oControlEvent) class MemberBrowser
	local oControl as Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:ButtonClick(oControlEvent)
	//Put your changes here 
	IF oControl:NameSym=#HomeBox .or. oControl:NameSym=#NonHomeBox .or. oControl:NameSym=#ProjectsBox
		self:FindButton()
	endif		
	return NIL

METHOD CloseButton( ) CLASS MemberBrowser
	SELF:EndWindow()
	RETURN NIL
METHOD ConvertButton( ) CLASS MemberBrowser 
// convert shown members to a member department 
local oSelH, oSelnH as SQLselect
local nHome,nNonHome as int       
local oConv as ConvertMembers
oSelH:=SqlSelect{"select count(*) as nConv from "+self:cFrom+" where "+self:cWhere+" and a.active=1 and (homepp='"+sEntity+"' and co='M' and m.accid IS NOT NULL)  and b.category='"+liability+"'",oConn}
nHome:=ConI(oSelH:nConv)
oSelnH:=SqlSelect{"select count(*) as nConv from "+self:cFrom+" where "+self:cWhere+" and a.active=1 and (homepp<>'"+sEntity+"' and co='M' and m.accid IS NOT NULL)  and b.category='"+liability+"'",oConn}
nNonHome:=ConI(oSelnH:nConv) 
if TextBox{self,oLan:WGet("Members"),oLan:WGet("Do you really want to convert")+space(1)+str(nHome,-1)+space(1)+sEntity+space(1)+ oLan:WGet("members")+space(1)+;
	self:oLan:WGet("and")+Space(1)+Str(nNonHome,-1)+Space(1)+self:oLan:WGet("non")+'-'+sEntity+Space(1) + oLan:WGet("members")+'?',BUTTONOKAYCANCEL+BOXICONQUESTIONMARK}:show()==BOXREPLYOKAY
	oConv:=ConvertMembers{self:Owner,,,self}
	oConv:show()
endif 
 
RETURN NIL
METHOD DeleteButton CLASS MemberBrowser
	LOCAL oTextBox as TextBox
	LOCAL mMbrId,mAccid,mDepid,mNetasset,mExpAcc,mIncAcc,cMemName as STRING
	local oStmnt as SQLStatement
	local oMBAL as Balances
	local fBal as float
	local oDep as SQLSelect
	IF self:Server:EOF.or.self:Server:BOF
		(ErrorBox{,"Select a member first"}):Show()
		RETURN
	ENDIF 
	cMemName:=AllTrim(oSFMemberBrowser_DETAIL:Server:membername)
	oTextBox := TextBox{ self, "Delete Record",;
		"Delete Member " +cMemName  + "?" }
	
	oTextBox:Type := BUTTONYESNO + BOXICONQUESTIONMARK
	
	IF ( oTextBox:Show() == BOXREPLYYES )
		mMbrId:=Str(oSFMemberBrowser_DETAIL:Server:MbrId,-1)
		mAccid:=Transform(oSFMemberBrowser_DETAIL:Server:accid,"")
		mDepid:=Transform(oSFMemberBrowser_DETAIL:Server:depid,"")
		oMBAL :=Balances{}
		if !Empty(mAccid)
			oMBAL:GetBalance(mAccid)
			IF !oMBAL:per_deb==oMBAL:per_cre
				if TextBox{self,self:oLan:WGet("Deleting member")+Space(1)+cMemName,;
						self:oLan:WGet("No zero balance")+'! '+self:oLan:WGet("Do you really want to delete this member")+'?',BUTTONYESNO+BOXICONHAND}:Show()==BOXREPLYNO 
					RETURN
				endif
			endif
		else
			oDep:=SQLSelect{"select netasset,incomeacc,expenseacc from department where depid="+mDepid,oConn}
			if oDep:RecCount>0
				mNetasset:=Transform(oDep:netasset,"")
				mIncAcc:=Str(oDep:incomeacc,-1)
				mExpAcc:=Str(oDep:expenseacc,-1) 
				oMBAL:GetBalance(mIncAcc)
				fBal:=Round(oMBAL:per_cre - oMBAL:per_deb,DecAantal)
				oMBAL:GetBalance(mExpAcc)
				fBal:=Round(fBal+oMBAL:per_cre - oMBAL:per_deb,DecAantal)
				if fBal<>0.00
					if TextBox{self,self:oLan:WGet("Deleting member")+Space(1)+cMemName,;
							self:oLan:WGet("No zero balance")+'! '+self:oLan:WGet("Do you really want to delete this member")+'?',BUTTONYESNO+BOXICONHAND}:Show()==BOXREPLYNO 
						RETURN
					endif
				endif					
			endif		
		endif
		* Delete this member:
		oStmnt:=SQLStatement{"delete from member where MbrId='"+mMbrId+"'",oConn}
		oStmnt:execute()
		if oStmnt:NumSuccessfulRows<1
			(ErrorBox{,"Could not delete member"}):Show()
			RETURN
		endif			                                   
		* Disconnect corresponding person:
		SQLStatement{"update person set mailingcodes=replace(replace(mailingcodes,'MW ',''),'MW',''),type='"+;
			iif(Empty(self:Server:grade),PersTypeValue("COM"),"1")+"' where persid='"+Str(oSFMemberBrowser_DETAIL:Server:persid,-1)+"'",oConn}:execute()
		// delete corresponding Distribution Instructions:
		oStmnt:=SQLStatement{"delete from distributioninstruction where mbrid='"+mMbrId+"'",oConn}
		oStmnt:execute()
		// remove associated accounts:
		SQLStatement{"delete from memberassacc where mbrid="+mMbrId,oConn}:execute() 
		if !Empty(mAccid)
			* disconnect corresponding account 
			SQLStatement{"update account set description=concat('disconnected:',description),giftalwd=0 where accid="+mAccid,oConn}:execute()
			// delete corresponding subscription? 
			oStmnt:=SQLStatement{"delete from subscription where "+sIdentChar+"accid"+sIdentChar+"="+mAccid+" and (category='G' or category='D')",oConn}
			oStmnt:execute()

		else
			* disconnect corresponding department 
			SQLStatement{"update department set descriptn=concat('disconnected:',descriptn) where depid="+mDepid,oConn}:execute() 
			// set all its accounts on no gifts
			SQLStatement{"update account set giftalwd=0 where department="+mDepid,oConn}:execute()      	
			// delete corresponding subscription?
			oStmnt:=SQLStatement{"delete from subscription where "+sIdentChar+"accid"+sIdentChar+"="+mIncAcc+" and (category='G' or category='D')",oConn}
			oStmnt:execute()
		endif
		LogEvent(self,"member "+cMemName+" deleted")
		self:oMem:execute()
		oSFMemberBrowser_DETAIL:GoTop()
	ENDIF

	RETURN nil
METHOD EditButton(lNew) CLASS MemberBrowser

	Default(@lNew,FALSE)
	IF !lNew
		IF SELF:Server:EOF.or.SELF:Server:BOF
			(Errorbox{,"Select a member first"}):Show()
			RETURN
		ENDIF
	ENDIF
// 	(EditMember{self:Owner,,,{lNew,self,self:oSFMemberBrowser_DETAIL:Server:accid} }):Show()
	(EditMember{self:Owner,,,{lNew,self,self:oSFMemberBrowser_DETAIL:Server:mbrid} }):show()
	


	RETURN NIL

METHOD FindButton( ) CLASS MemberBrowser 
	local aKeyw:={} as array
	local aFields:={"a.accnumber","a.description","d.deptmntnbr","d.descriptn","m.grade","m.householdid","m.homepp"} as array
	local i,j as int 
	local cWhereType as string
	local oSel as SQLSelect
	self:cWhere:="m.persid=p.persid"
	self:cOrder:="membername"  
	
	if !Empty(self:SearchUni)
		self:SearchUni:=Lower(AllTrim(self:SearchUni)) 
		aKeyw:=GetTokens(self:SearchUni)
		for i:=1 to Len(aKeyw)
			self:cWhere+=" and ("
			for j:=1 to Len(AFields)
				self:cWhere+=iif(j=1,""," or ")+AFields[j]+" like '%"+StrTran(aKeyw[i,1],"'","\'")+"%'"
			next
			if aKeyw[i,1]=="entity"
				self:cWhere+=" or m.grade=''"
			endif
			self:cWhere+=")"
		next
	endif
	if !Empty(self:searchOms)
		self:cWhere+=	iif(Empty(self:cWhere),""," and ")+SQLFullName(0,"p")+" like '"+StrTran(AllTrim(self:searchOms),"'","\'")+"%'"
		self:cOrder:="membername"
	endif
	if !Empty(self:searchRek)
		self:cWhere+=	iif(Empty(self:cWhere),""," and ")+"( a.accnumber like '"+AllTrim(self:searchRek)+"%' or d.deptmntnbr like '"+AllTrim(self:searchRek)+"%')"
		self:cOrder:="accnumber,deptmntnbr"
	endif 
	if !(self:HomeBox .and. self:NonHomeBox .and. self:ProjectsBox)
		cWhereType:=""
		if self:ProjectsBox
			cWhereType:="co='S'"
		endif
		if self:HomeBox
			if self:NonHomeBox
				cWhereType+=iif(Empty(cWhereType),""," or ")+"co='M'"
			else
				cWhereType+=iif(Empty(cWhereType),""," or ")+"(homepp='"+sEntity+"' and co='M')"
			endif
		elseif self:NonHomeBox
			cWhereType+=iif(Empty(cWhereType),""," or ")+"(homepp<>'"+sEntity+"' and co='M')"
		endif
		if !Empty(cWhereType)
			self:cWhere+=iif(Empty(self:cWhere),""," and ")+"("+cWhereType+")"
		else
	  		self:cWhere+=' and m.mbrid IS NULL'  // nothing found
		endif
	endif
  	if Empty(self:cWhere)
  		self:cWhere:='m.mbrid IS NULL'  // nothing found
  	endif
		
	self:oMem:SQLString :="select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+" order by "+self:cOrder 
   self:oMem:Execute() 
   self:GoTop()
   self:oSFMemberBrowser_DETAIL:Browser:refresh()
  	self:FOUND :=Str(self:oMem:Reccount,-1)
	oSel:=SqlSelect{"select count(*) as nConv from "+self:cFrom+" where "+self:cWhere+" and m.co='M' and m.accid IS NOT NULL and b.category='"+liability+"'",oConn}
	oSel:Execute()
	if ConI(oSel:nConv)>0
		self:oCCConvertButton:show()
	else
		self:oCCConvertButton:Hide()		
	endif
RETURN NIL
ASSIGN FOUND(uValue) CLASS MemberBrowser
self:FIELDPUT(#Found, uValue)
RETURN uValue
ACCESS HomeBox() CLASS MemberBrowser
RETURN SELF:FieldGet(#HomeBox)

ASSIGN HomeBox(uValue) CLASS MemberBrowser
SELF:FieldPut(#HomeBox, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS MemberBrowser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"MemberBrowser",_GetInst()},iCtlID)

oDCSearchUni := SingleLineEdit{SELF,ResourceID{MEMBERBROWSER_SEARCHUNI,_GetInst()}}
oDCSearchUni:HyperLabel := HyperLabel{#SearchUni,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchUni:FocusSelect := FSEL_TRIM
oDCSearchUni:TooltipText := "Enter one or more (part of) key values "
oDCSearchUni:UseHLforToolTip := True

oDCSC_REK := FixedText{SELF,ResourceID{MEMBERBROWSER_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,_chr(38)+"Number:",NULL_STRING,NULL_STRING}

oDCSC_OMS := FixedText{SELF,ResourceID{MEMBERBROWSER_SC_OMS,_GetInst()}}
oDCSC_OMS:HyperLabel := HyperLabel{#SC_OMS,"N"+_chr(38)+"ame",NULL_STRING,NULL_STRING}

oDCSearchREK := SingleLineEdit{SELF,ResourceID{MEMBERBROWSER_SEARCHREK,_GetInst()}}
oDCSearchREK:HyperLabel := HyperLabel{#SearchREK,NULL_STRING,"Enter characters to match accountnumber","Account_Rek"}

oDCSearchOMS := SingleLineEdit{SELF,ResourceID{MEMBERBROWSER_SEARCHOMS,_GetInst()}}
oDCSearchOMS:HyperLabel := HyperLabel{#SearchOMS,NULL_STRING,"Enter characters to match member name","Rek_OMS"}

oCCFindButton := PushButton{SELF,ResourceID{MEMBERBROWSER_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Find",NULL_STRING,NULL_STRING}

oCCEditButton := PushButton{SELF,ResourceID{MEMBERBROWSER_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,_chr(38)+"Edit","Edit of a record","File_Edit"}
oCCEditButton:OwnerAlignment := OA_PY

oCCNewButton := PushButton{SELF,ResourceID{MEMBERBROWSER_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,_chr(38)+"New",NULL_STRING,NULL_STRING}
oCCNewButton:OwnerAlignment := OA_PY

oCCDeleteButton := PushButton{SELF,ResourceID{MEMBERBROWSER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,_chr(38)+"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PY

oDCGroupBox1 := GroupBox{SELF,ResourceID{MEMBERBROWSER_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Members",NULL_STRING,NULL_STRING}
oDCGroupBox1:OwnerAlignment := OA_HEIGHT

oDCGroupBox2 := GroupBox{SELF,ResourceID{MEMBERBROWSER_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Search member with:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{MEMBERBROWSER_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Universal like google:",NULL_STRING,NULL_STRING}

oDCFound := FixedText{SELF,ResourceID{MEMBERBROWSER_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{MEMBERBROWSER_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

oDCProjectsBox := CheckBox{SELF,ResourceID{MEMBERBROWSER_PROJECTSBOX,_GetInst()}}
oDCProjectsBox:HyperLabel := HyperLabel{#ProjectsBox,"Projects",NULL_STRING,NULL_STRING}

oDCNonHomeBox := CheckBox{SELF,ResourceID{MEMBERBROWSER_NONHOMEBOX,_GetInst()}}
oDCNonHomeBox:HyperLabel := HyperLabel{#NonHomeBox,"Members not of",NULL_STRING,NULL_STRING}

oDCHomeBox := CheckBox{SELF,ResourceID{MEMBERBROWSER_HOMEBOX,_GetInst()}}
oDCHomeBox:HyperLabel := HyperLabel{#HomeBox,"Members of",NULL_STRING,NULL_STRING}

oCCConvertButton := PushButton{SELF,ResourceID{MEMBERBROWSER_CONVERTBUTTON,_GetInst()}}
oCCConvertButton:HyperLabel := HyperLabel{#ConvertButton,"Convert",NULL_STRING,NULL_STRING}
oCCConvertButton:TooltipText := "Convert shown members to  member departments"

SELF:Caption := "Member & PPs Browser"
SELF:HyperLabel := HyperLabel{#MemberBrowser,"Member "+_chr(38)+" PPs Browser",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:Menu := WOMenu{}
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFMemberBrowser_DETAIL := MemberBrowser_DETAIL{SELF,MEMBERBROWSER_MEMBERBROWSER_DETAIL}
oSFMemberBrowser_DETAIL:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS NonHomeBox() CLASS MemberBrowser
RETURN SELF:FieldGet(#NonHomeBox)

ASSIGN NonHomeBox(uValue) CLASS MemberBrowser
SELF:FieldPut(#NonHomeBox, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS MemberBrowser
	//Put your PostInit additions here 
	local oSel as SQLSelect
self:SetTexts()
*	SELF:SetupMenu()
	if AScan(aMenu,{|x|x[4]=="MemberEdit"})=0
		self:oCCNewButton:Hide()
		self:oCCDeleteButton:Hide()
	endif
	self:GoTop() 
  	self:FOUND :=Str(self:oMem:Reccount,-1)
	oSel:=SqlSelect{"select count(*) as nConv from "+self:cFrom+" where "+self:cWhere+" and m.co='M' and m.accid IS NOT NULL and b.category='"+liability+"'",oConn}
	oSel:Execute()
	if ConI(oSel:nConv)>0
		self:oCCConvertButton:show()
	else
		self:oCCConvertButton:Hide()		
	endif
	self:oDCHomeBox:Caption:=self:oLan:WGet("Members of")+" "+sLand
	self:oDCNonHomeBox:Caption:=self:oLan:WGet("Members not of")+" "+sLand
	self:HomeBox:=true
	self:NonHomeBox:=true
	self:ProjectsBox:=true

	self:oDCSearchOMS:SetFocus()

	RETURN NIL
method PreInit(oWindow,iCtlID,oServer,uExtra) class MemberBrowser
	//Put your PreInit additions here 
	self:cFields:= "m.mbrid,m.accid,m.depid,p.persid,a.description,a.accnumber,d.deptmntnbr,d.descriptn as depname,"+SQLFullName(0,"p")+" as membername,b.category as type,m.grade,m.householdid,m.homepp"
	self:cFrom:="person as p, member as m left join department as d on (m.depid=d.depid) left join account as a on (m.accid=a.accid) left join balanceitem as b on (b.balitemid=a.balitemid) " 
	self:cWhere:="m.persid=p.persid "
	self:cOrder:="membername"
	self:oMem:=SQLSelect{"select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+" order by "+self:cOrder,oConn} 

	return NIL

ACCESS ProjectsBox() CLASS MemberBrowser
RETURN SELF:FieldGet(#ProjectsBox)

ASSIGN ProjectsBox(uValue) CLASS MemberBrowser
SELF:FieldPut(#ProjectsBox, uValue)
RETURN uValue

ACCESS SearchOMS() CLASS MemberBrowser
RETURN SELF:FieldGet(#SearchOMS)

ASSIGN SearchOMS(uValue) CLASS MemberBrowser
SELF:FieldPut(#SearchOMS, uValue)
RETURN uValue

ACCESS SearchREK() CLASS MemberBrowser
RETURN SELF:FieldGet(#SearchREK)

ASSIGN SearchREK(uValue) CLASS MemberBrowser
SELF:FieldPut(#SearchREK, uValue)
RETURN uValue

ACCESS SearchUni() CLASS MemberBrowser
RETURN SELF:FieldGet(#SearchUni)

ASSIGN SearchUni(uValue) CLASS MemberBrowser
SELF:FieldPut(#SearchUni, uValue)
RETURN uValue

STATIC DEFINE MEMBERBROWSER_CONVERTBUTTON := 118 
STATIC DEFINE MEMBERBROWSER_DELETEBUTTON := 109 
RESOURCE MemberBrowser_DETAIL DIALOGEX  14, 14, 350, 183
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

CLASS MemberBrowser_DETAIL INHERIT DataWindowExtra 

	PROTECT oDBMEMBERNAME as DataColumn
	PROTECT oDBACCNUMBER as DataColumn
	PROTECT oDBHOUSEHOLDID as DataColumn
	PROTECT oDBMGRADE as DataColumn
	PROTECT oDBHOMEPP as DataColumn
	PROTECT oDBDEPTMNTNBR as DataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)  
protect aPP:={} as array

ACCESS AccNumber() CLASS MemberBrowser_DETAIL
RETURN SELF:FieldGet(#AccNumber)

ASSIGN AccNumber(uValue) CLASS MemberBrowser_DETAIL
SELF:FieldPut(#AccNumber, uValue)
RETURN uValue

ACCESS deptmntnbr() CLASS MemberBrowser_DETAIL
RETURN SELF:FieldGet(#deptmntnbr)

ASSIGN deptmntnbr(uValue) CLASS MemberBrowser_DETAIL
SELF:FieldPut(#deptmntnbr, uValue)
RETURN uValue

ACCESS description() CLASS MemberBrowser_DETAIL
RETURN SELF:FieldGet(#description)

ASSIGN description(uValue) CLASS MemberBrowser_DETAIL
SELF:FieldPut(#description, uValue)
RETURN uValue

ACCESS HomePP() CLASS MemberBrowser_DETAIL
RETURN SELF:FieldGet(#HomePP)

ASSIGN HomePP(uValue) CLASS MemberBrowser_DETAIL
SELF:FieldPut(#HomePP, uValue)
RETURN uValue

ACCESS householdid() CLASS MemberBrowser_DETAIL
RETURN SELF:FieldGet(#householdid)

ASSIGN householdid(uValue) CLASS MemberBrowser_DETAIL
SELF:FieldPut(#householdid, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS MemberBrowser_DETAIL 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"MemberBrowser_DETAIL",_GetInst()},iCtlID)

SELF:Caption := "Browse thru members"
SELF:HyperLabel := HyperLabel{#MemberBrowser_DETAIL,"Browse thru members",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := False
SELF:OwnerAlignment := OA_HEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBMEMBERNAME := DataColumn{32}
oDBMEMBERNAME:Width := 32
oDBMEMBERNAME:HyperLabel := HyperLabel{#membername,"Name",NULL_STRING,NULL_STRING} 
oDBMEMBERNAME:Caption := "Name"
self:Browser:AddColumn(oDBMEMBERNAME)

oDBACCNUMBER := DataColumn{Account_AccNumber{}}
oDBACCNUMBER:Width := 12
oDBACCNUMBER:HyperLabel := HyperLabel{#AccNumber,"Account","Number of an Account",NULL_STRING} 
oDBACCNUMBER:Caption := "Account"
self:Browser:AddColumn(oDBACCNUMBER)

oDBHOUSEHOLDID := DataColumn{Members_HBN{}}
oDBHOUSEHOLDID:Width := 11
oDBHOUSEHOLDID:HyperLabel := HyperLabel{#householdid,"Household",NULL_STRING,NULL_STRING} 
oDBHOUSEHOLDID:Caption := "Household"
self:Browser:AddColumn(oDBHOUSEHOLDID)

oDBMGRADE := DataColumn{9}
oDBMGRADE:Width := 9
oDBMGRADE:HyperLabel := HyperLabel{#mgrade,"Type",NULL_STRING,NULL_STRING} 
oDBMGRADE:Caption := "Type"
oDBmgrade:BlockOwner := self:server
oDBmgrade:Block := {|x|iif(empty(x:grade),'entity',x:grade)}
self:Browser:AddColumn(oDBMGRADE)

oDBHOMEPP := DataColumn{Members_HOMEPP{}}
oDBHOMEPP:Width := 9
oDBHOMEPP:HyperLabel := HyperLabel{#HomePP,"Home PP",NULL_STRING,NULL_STRING} 
oDBHOMEPP:Caption := "Home PP"
self:Browser:AddColumn(oDBHOMEPP)

oDBDEPTMNTNBR := DataColumn{12}
oDBDEPTMNTNBR:Width := 12
oDBDEPTMNTNBR:HyperLabel := HyperLabel{#deptmntnbr,"Department",NULL_STRING,NULL_STRING} 
oDBDEPTMNTNBR:Caption := "Department"
self:Browser:AddColumn(oDBDEPTMNTNBR)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS membername() CLASS MemberBrowser_DETAIL
RETURN SELF:FieldGet(#membername)

ASSIGN membername(uValue) CLASS MemberBrowser_DETAIL
SELF:FieldPut(#membername, uValue)
RETURN uValue

ACCESS mgrade() CLASS MemberBrowser_DETAIL
RETURN SELF:FieldGet(#mgrade)

ASSIGN mgrade(uValue) CLASS MemberBrowser_DETAIL
SELF:FieldPut(#mgrade, uValue)
RETURN uValue

METHOD PostInit() CLASS MemberBrowser_DETAIL
	//Put your PostInit additions here
self:SetTexts()
	self:Browser:SetStandardStyle(gbsReadOnly)
// 	SELF:GoTop()
	RETURN NIL
method PreInit(oWindow,iCtlID,oServer,uExtra) class MemberBrowser_DETAIL
	//Put your PreInit additions here
	local oParent:=oWindow as MemberBrowser
 	oParent:Use(oParent:oMem)
	return nil 

STATIC DEFINE MEMBERBROWSER_DETAIL_ACCNTNUMBER := 100 
STATIC DEFINE MEMBERBROWSER_DETAIL_ACCNUMBER := 100 
STATIC DEFINE MEMBERBROWSER_DETAIL_DEPTMNTNBR := 105 
STATIC DEFINE MEMBERBROWSER_DETAIL_DESCRIPTION := 101 
STATIC DEFINE MEMBERBROWSER_DETAIL_HOMEPP := 104 
STATIC DEFINE MEMBERBROWSER_DETAIL_HOUSEHOLDID := 102 
STATIC DEFINE MEMBERBROWSER_DETAIL_MEMBERNAME := 101 
STATIC DEFINE MEMBERBROWSER_DETAIL_MGRADE := 103 
STATIC DEFINE MEMBERBROWSER_EDITBUTTON := 107 
STATIC DEFINE MEMBERBROWSER_FINDBUTTON := 105 
STATIC DEFINE MEMBERBROWSER_FIXEDTEXT4 := 112 
STATIC DEFINE MEMBERBROWSER_FOUND := 113 
STATIC DEFINE MEMBERBROWSER_FOUNDTEXT := 114 
STATIC DEFINE MEMBERBROWSER_GROUPBOX1 := 110 
STATIC DEFINE MEMBERBROWSER_GROUPBOX2 := 111 
STATIC DEFINE MEMBERBROWSER_HOMEBOX := 117 
STATIC DEFINE MEMBERBROWSER_MEMBERBROWSER_DETAIL := 106 
STATIC DEFINE MEMBERBROWSER_NEWBUTTON := 108 
STATIC DEFINE MEMBERBROWSER_NONHOMEBOX := 116 
STATIC DEFINE MEMBERBROWSER_PROJECTSBOX := 115 
STATIC DEFINE MEMBERBROWSER_SC_OMS := 102 
STATIC DEFINE MEMBERBROWSER_SC_REK := 101 
STATIC DEFINE MEMBERBROWSER_SEARCHOMS := 104 
STATIC DEFINE MEMBERBROWSER_SEARCHREK := 103 
STATIC DEFINE MEMBERBROWSER_SEARCHUNI := 100 
CLASS MemberPerson INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS MemberPerson

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #MemberPerson

    cPict       := "XXXXXXXXXXXXXXXXXXXX"
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := ""
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := "Person is obliged!"
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "", "Person a member  is", "" },  "C", 50, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




class ReportDateMember inherit DialogWinDowExtra 

	protect oDCFixedText as FIXEDTEXT
	protect oDCReportDate as DATETIMEPICKER
	protect oCCCancelButton as PUSHBUTTON
	protect oCCOKButton as PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
RESOURCE ReportDateMember DIALOGEX  9, 24, 256, 49
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Editing of a member"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Gifts will be assessed backwards from date:", REPORTDATEMEMBER_FIXEDTEXT, "Static", WS_CHILD, 6, 11, 161, 13
	CONTROL	"19-05-2006", REPORTDATEMEMBER_REPORTDATE, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 172, 10, 71, 14, WS_EX_CLIENTEDGE
	CONTROL	"Cancel", REPORTDATEMEMBER_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 128, 29, 54, 12
	CONTROL	"OK", REPORTDATEMEMBER_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 189, 28, 53, 13
END

METHOD CancelButton( ) CLASS ReportDateMember
	SELF:EndDialog(0)
	RETURN NIL
method Init(oParent,uExtra) class ReportDateMember 

self:PreInit(oParent,uExtra)

super:Init(oParent,ResourceID{"ReportDateMember",_GetInst()},TRUE)

oDCFixedText := FixedText{self,ResourceID{REPORTDATEMEMBER_FIXEDTEXT,_GetInst()}}
oDCFixedText:HyperLabel := HyperLabel{#FixedText,"Gifts will be assessed backwards from date:",NULL_STRING,NULL_STRING}

oDCReportDate := DateTimePicker{self,ResourceID{REPORTDATEMEMBER_REPORTDATE,_GetInst()}}
oDCReportDate:HyperLabel := HyperLabel{#ReportDate,NULL_STRING,NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{self,ResourceID{REPORTDATEMEMBER_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{self,ResourceID{REPORTDATEMEMBER_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

self:Caption := "Editing of a member"
self:HyperLabel := HyperLabel{#ReportDateMember,"Editing of a member",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS ReportDateMember
SELF:Owner:dReportDate:=SELF:oDCReportDate:SelectedDate
SELF:EndDialog(1)
RETURN
METHOD PostInit(oParent,uExtra) CLASS ReportDateMember
	//Put your PostInit additions here
	self:SetTexts()
	oDCReportDate:DateRange:=;
	DateRange{LstYearClosed,SToD(Str(Year(Today()),4)+StrZero(Month(Today()),2)+"01")}
	oDCReportDate:SelectedDate:=LstYearClosed
	RETURN NIL
STATIC DEFINE REPORTDATEMEMBER_CANCELBUTTON := 102 
STATIC DEFINE REPORTDATEMEMBER_FIXEDTEXT := 100 
STATIC DEFINE REPORTDATEMEMBER_OKBUTTON := 103 
STATIC DEFINE REPORTDATEMEMBER_REPORTDATE := 101 
static define SEQNBR:=2
static define SINGLEUSE:=15
STATIC DEFINE SUB_DISTRIBUTIONS_DESCRPTN := 102 
STATIC DEFINE SUB_DISTRIBUTIONS_DESTACC := 101 
STATIC DEFINE SUB_DISTRIBUTIONS_DESTAMT := 104 
STATIC DEFINE SUB_DISTRIBUTIONS_DESTPP := 100 
STATIC DEFINE SUB_DISTRIBUTIONS_MDESTTYP := 103 
STATIC DEFINE SUB_FORMASSACC_ACCNUMBER := 100 
STATIC DEFINE SUB_FORMASSACC_OMS := 101 
CLASS UpdateHouseHoldID 
declare method Processaffiliated_person_account_list 
METHOD Importaffiliated_person_account_list CLASS UpdateHouseHoldID
	// import and process affiliated_person_account_list.csv downloaded from Insite
	LOCAL oFs AS FileSpec
	LOCAL aStruct:={} AS ARRAY // array with fieldnames
	LOCAL aFields:={} AS ARRAY // array with fieldvalues
	LOCAL ptOld, ptNew,PTReason AS INT
	LOCAL cDelim:="," AS STRING
	LOCAL ptrHandle as MyFile
	LOCAL cBuffer AS STRING, nRead AS INT
	LOCAL HouseOld, HouseNew AS STRING
	LOCAL cReport as STRING, nUpd, nRemoved as int
	local cPersonName as string
	local oSel as SQLSelect
	local ostmnt as SQLStatement


	oFs:=FileSpec{"affiliated_person_account_list*.csv"}
	oFs:Path:=CurPath
	IF oFs:Find()
		// Process changes:
		ptrHandle:=MyFile{oFs}
		IF FError() >0
			(ErrorBox{,"Could not open file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
			RETURN FALSE
		ENDIF
		cBuffer:=ptrHandle:FReadLine()
		IF Empty(cBuffer)
			(ErrorBox{,"Could not read file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
			RETURN FALSE
		ENDIF
		aStruct:=Split(Upper(cBuffer),cDelim)
		IF Len(aStruct)<9
			(ErrorBox{,"Wrong fileformat of importfile from Insite: "+oFs:FullPath+"(See help)"}):show()
			RETURN FALSE
		ENDIF
		ptOld:=AScan(aStruct,{|x| "OLD HOUSEHOLD ID" $ x})
		ptNew:=AScan(aStruct,{|x| "NEW HOUSEHOLD ID" $ x})
		PTReason:=AScan(aStruct,{|x| "REASON FOR CHANGE" $ x})
		IF ptOld==0 .or. ptNew==0
			(ErrorBox{,"Wrong fileformat of importfile from Insite: "+oFs:FullPath+"(See help)"}):show()
			RETURN FALSE
		ENDIF
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim)

		DO WHILE !Empty(cBuffer) .and. Len(AFields)>8 
			HouseOld:=AllTrim(aFields[ptOld])
			HouseNew:=AllTrim(AFields[ptNew])
			if !HouseNew==HouseOld .and. !Empty(HouseNew)    // process only new household id cecause we can't trust other changes
// 				if !Lower(AllTrim(AFields[PTReason]))="completion" .and.!Lower(AllTrim(AFields[PTReason]))="household name" .and.!Empty(AllTrim( AFields[PTReason]))
// 					IF Empty(HouseNew)
// 						// removal:
// 						// Disconnect corresponding persons:
// 						ostmnt:= SQLStatement{"update person set mailingcodes=replace(replace(mailingcodes,'MW ',''),'MW',''),type=1 where persid in (select persid from member where householdid='"+HouseOld+"')",oConn}
// 						ostmnt:Execute()
// 						if ostmnt:NumSuccessfulRows>0 
// 						* Disconnect corresponding account:
// 						SQLStatement{"update account set description=concat(description,' ','"+AllTrim(AFields[PTReason])+"'),GIFTALWD=0 where persid in (select persid from member where householdid='"+HouseOld+"')",oConn}:Execute()
// 						cPersonName:=""
// 						oSel:= SQLSelect{"select "+SQLFullName(0,) +"as personname from person where persid in (select persid from member where householdid='"+HouseOld+"')",oConn}
// 						if oSel:RecCount>0
// 							cPersonName:=oSel:personname 
// 							cReport+=cPersonName+ " removed because: "+AllTrim(AFields[PTReason])+CRLF
// 							nRemoved++ 
// 						endif
// 						// delete corresponding Distribution Instructions:
// 						SQLStatement{"delete from distributioninstruction where mbrid in (select mbrid from member where householdid='"+HouseOld+"')",oConn}:Execute() 
// 						// disconnect member:
// 						SQLStatement{"delete from member where householdid='"+HouseOld+"'",oConn}:Execute()
// 						endif 
// 					else
						// update household code:
						ostmnt:=SQLStatement{"update member set householdid='"+HouseNew+"' where householdid='"+HouseOld+"'",oConn}
						ostmnt:Execute()
						if ostmnt:NumSuccessfulRows>0
							nUpd++
						endif
// 					endif 
// 				endif 
			endif
			cBuffer:=ptrHandle:FReadLine()
			aFields:=Split(cBuffer,cDelim)
		ENDDO
		ptrHandle:Close()
		// update date of last account changes report:
		SQLStatement{"update sysparms set datlstafl='"+SQLdate( oFs:DateChanged)+"'",oConn}:Execute()
		ptrHandle:=NULL_OBJECT
		oFs:Delete()
		if nUpd>0
			cReport:=Str(nUpd,-1)+" updated household codes; "
			LogEvent(self,cReport)
			(TextBox{,"Importing Account Change Report",cReport}):show()
		endif	
	ELSE
		RETURN FALSE
	ENDIF
	RETURN true
METHOD Init() CLASS UpdateHouseHoldID
	RETURN SELF
	
METHOD Processaffiliated_person_account_list(cDownload as string) as logic CLASS UpdateHouseHoldID
	// import and process affiliated_person_account_list.csv downloaded from Insite
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptOld, ptNew,PTReason as int
	LOCAL cDelim:="," as STRING
	LOCAL ptrHandle as MyFile
	LOCAL cBuffer as STRING, nRead as int
	LOCAL HouseOld, HouseNew as STRING
	LOCAL oMem as SQLSelect
	LOCAL mAccId, mPersId,mMbrId as STRING
	LOCAL cReport as STRING, nUpd, nRemoved as int
	Local ptrN as DWord 
	local oStmnt as SQLStatement

	cBuffer:=MLine4(cDownload,@ptrN)
	aStruct:=Split(Upper(cBuffer),cDelim)
	IF Len(aStruct)<9
		//	(ErrorBox{,"Wrong fileformat of download from Insite (See help)"}):show()
		RETURN FALSE
	ENDIF
	ptOld:=AScan(aStruct,{|x| "OLD HOUSEHOLD ID" $ x})
	ptNew:=AScan(aStruct,{|x| "NEW HOUSEHOLD ID" $ x})
	PTReason:=AScan(aStruct,{|x| "REASON FOR CHANGE" $ x})
	IF ptOld==0 .or. ptNew==0
		//	(ErrorBox{,"Wrong fileformat of importfile from Insite (See help)"}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=MLine4(cDownload,@ptrN) // read next line

	aFields:=Split(cBuffer,cDelim)
	oMem:=SQLSelect{"select m.accid,m.persid,m.mbrid,a.description from member m left join account a on (a.accid=m.accid) where householdid=?",oConn}

	do WHILE Len(AFields)>8
		HouseOld:=AllTrim(AFields[ptOld])
		HouseNew:=AllTrim(AFields[ptNew]) 
		if !Empty(HouseNew)   // only process new house hold id because we can't trust other changes
			oStmnt:=SQLStatement{"update member set householdid='"+HouseNew+"' where householdid='"+HouseOld+"'",oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows>0
				nUpd++
			endif
		/*	oMem:Execute(HouseOld)
			do WHILE !oMem:EoF
				mMbrId:=Str(oMem:Mbrid,-1)
				IF Empty(HouseNew)
					// disconnect member:
					nRemoved++
					mAccId:=Str(oMem:accid,-1)
					mPersId:=Str(oMem:persid,-1)
					cReport+= AllTrim(oMem:Description)+ " removed because: "+AllTrim(AFields[PTReason])+CRLF
					oStmnt:=SQLStatement{"delete from member where mbrid="+mMbrId,oConn}
					oStmnt:Execute()
					if oStmnt:NumSuccessfulRows>0
						* Disconnect corresponding person: 
						oStmnt:=SQLStatement{"update person set mailingcodes=replace(replace(mailingcodes,'MW ',''),'MW','') where persid="+mPersId,oConn}
						oStmnt:Execute()
						// delete corresponding Distribution Instructions: 
						oStmnt:=SQLStatement{"delete from distributioninstruction where mbrid="+mMbrId,oConn}
						oStmnt:Execute()
						* Disconnect corresponding account: 
						oStmnt:=SQLStatement{"update account set description=concat(description,' ','"+AllTrim(AFields[PTReason])+"'),giftalwd=0 where accid="+mAccId,oConn}
						oStmnt:Execute()
					endif  
				ELSE
					oStmnt:=SQLStatement{"update member set householdid='"+HouseNew+"' where mbrid="+mMbrId,oConn}
					oStmnt:Execute()
					nUpd++
				ENDIF
				oMem:skip()
			ENDDO         */
		endif
		cBuffer:=MLine4(cDownload,@ptrN)
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	SQLStatement{"update sysparms set datlstafl=CurDate()",oConn}:Execute()
	if nRemoved>0 .or.nUpd>0
		cReport:=Str(nUpd,-1)+" updated household codes; "+Str(nRemoved,-1)+" members removed:"+CRLF+ cReport 
		LogEvent(self,cReport)
		(TextBox{,"Importing Account Change Report",cReport}):show()
	endif	
	RETURN true
