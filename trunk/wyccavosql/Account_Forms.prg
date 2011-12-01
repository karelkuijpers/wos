CLASS AccountBrowser INHERIT DataWindowExtra 

	PROTECT oDCSearchUni AS SINGLELINEEDIT
	PROTECT oDCSC_REK AS FIXEDTEXT
	PROTECT oDCSC_OMS AS FIXEDTEXT
	PROTECT oDCSearchREK AS SINGLELINEEDIT
	PROTECT oDCSearchOMS AS SINGLELINEEDIT
	PROTECT oCCFindButton AS PUSHBUTTON
	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oCCFromDepButton AS PUSHBUTTON
	PROTECT oDCFromDep AS SINGLELINEEDIT
	PROTECT oDCSC_DEP AS FIXEDTEXT
	PROTECT oCCFromBalButton AS PUSHBUTTON
	PROTECT oDCFromBal AS SINGLELINEEDIT
	PROTECT oDCSC_BAL AS FIXEDTEXT
	PROTECT oDCCheckBoxInactive AS CHECKBOX
	PROTECT oSFAccountBrowser_DETAIL AS AccountBrowser_DETAIL

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
   	EXPORT oCaller as OBJECT
   	EXPORT CallerName as STRING
   	EXPORT lUnique as LOGIC // Test for uniqeness of found value required
   	EXPORT lFoundUnique as LOGIC //Result of uniqeness test
	PROTECT oExtServer as OBJECT
	PROTECT lOk as LOGIC
	export cAccFilter as string
	export cSearch:="", cWhere,cFrom,cOrder,cFields as string
	export oAccCnt as AccountContainer 
	export oAcc as SQLSelect
	protect cCurDep,WhoFrom as string 
	protect cCurBal,WhatFrom as string 
	
	declare method AccountSelect
RESOURCE AccountBrowser DIALOGEX  4, 3, 348, 298
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", ACCOUNTBROWSER_SEARCHUNI, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 96, 22, 116, 12
	CONTROL	"&Number:", ACCOUNTBROWSER_SC_REK, "Static", WS_CHILD, 20, 36, 31, 13
	CONTROL	"&Description:", ACCOUNTBROWSER_SC_OMS, "Static", WS_CHILD, 20, 51, 39, 13
	CONTROL	"", ACCOUNTBROWSER_SEARCHREK, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 96, 36, 116, 13
	CONTROL	"", ACCOUNTBROWSER_SEARCHOMS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 96, 51, 116, 13
	CONTROL	"Find", ACCOUNTBROWSER_FINDBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 232, 22, 53, 12
	CONTROL	"", ACCOUNTBROWSER_ACCOUNTBROWSER_DETAIL, "static", WS_CHILD|WS_BORDER, 17, 116, 250, 141
	CONTROL	"&Edit", ACCOUNTBROWSER_EDITBUTTON, "Button", WS_TABSTOP|WS_CHILD, 278, 115, 54, 13
	CONTROL	"&New", ACCOUNTBROWSER_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 278, 158, 54, 13
	CONTROL	"&Delete", ACCOUNTBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 278, 201, 54, 13
	CONTROL	"Select", ACCOUNTBROWSER_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 278, 244, 54, 13
	CONTROL	"Accounts", ACCOUNTBROWSER_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 103, 336, 164
	CONTROL	"Search accounts with:", ACCOUNTBROWSER_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 7, 8, 217, 88
	CONTROL	"Universal like google:", ACCOUNTBROWSER_FIXEDTEXT2, "Static", WS_CHILD, 20, 22, 72, 12
	CONTROL	"", ACCOUNTBROWSER_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 268, 40, 47, 12
	CONTROL	"Found:", ACCOUNTBROWSER_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 232, 40, 27, 12
	CONTROL	"v", ACCOUNTBROWSER_FROMDEPBUTTON, "Button", WS_CHILD|NOT WS_VISIBLE, 200, 81, 13, 12
	CONTROL	"", ACCOUNTBROWSER_FROMDEP, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 96, 81, 105, 12, WS_EX_CLIENTEDGE
	CONTROL	"Department from:", ACCOUNTBROWSER_SC_DEP, "Static", WS_CHILD|NOT WS_VISIBLE, 20, 81, 67, 12
	CONTROL	"v", ACCOUNTBROWSER_FROMBALBUTTON, "Button", WS_CHILD, 200, 66, 13, 12
	CONTROL	"", ACCOUNTBROWSER_FROMBAL, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 96, 66, 105, 12, WS_EX_CLIENTEDGE
	CONTROL	"Balance item from:", ACCOUNTBROWSER_SC_BAL, "Static", WS_CHILD, 20, 68, 72, 12
	CONTROL	"Include inactive accounts", ACCOUNTBROWSER_CHECKBOXINACTIVE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 232, 81, 104, 11
END

method ButtonClick(oControlEvent) class AccountBrowser
	local oControl as Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:Name=="CHECKBOXINACTIVE"
		self:FindButton()
	endif
	return nil 
ACCESS CheckBoxInactive() CLASS AccountBrowser
RETURN SELF:FieldGet(#CheckBoxInactive)

ASSIGN CheckBoxInactive(uValue) CLASS AccountBrowser
SELF:FieldPut(#CheckBoxInactive, uValue)
RETURN uValue

METHOD DeleteButton( ) CLASS AccountBrowser 
	* Delete a account occurrence
	LOCAL oTrans as SQLSelect
	LOCAL oMBal as Balances
	LOCAL  oDep as SQLSelect
	Local oAcc, oAccSelf:=self:Server as SQLSelect
	local oStmnt as SQLSTatement
	LOCAL oTextbox as TextBox
// 	LOCAL cRek as STRING
	IF oAccSelf:EOF.or.oAccSelf:BOF
		(ErrorBox{,oLan:WGet("Select a account first")}):Show()
		RETURN FALSE
	ENDIF

	if DeleteAccount(Str(oAccSelf:accid,-1))	
		// 	oTextbox := TextBox{ , oLan:WGet("Delete Record"),;
		// 		oLan:WGet("Delete Account")+" " + FullName( oAccSelf:ACCNUMBER,	oAccSelf:Description ) + "?",BUTTONYESNO + BOXICONQUESTIONMARK }
		// 	
		// 	IF ( oTextBox:Show() == BOXREPLYYES )
		// 		// check if account belongs to a member: 
		// 		// 		oDep:=SQLSelect{"select m.mbrid from member m where (m.accid="+cRek+" or "+cRek+" in (select a.accid from account a, department d where a.accid="+cRek+;
		// 		// 		" and (d.netasset=a.accid or d.incomeacc=a.accid or d.expenseacc=a.accid)))",oConn}
		// 		oDep:=SQLSelect{"select m.mbrid from member m where m.accid="+cRek,oConn}
		// 		IF oDep:Reccount>0
		// 			InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("This account belongs to a member")+"!"}:Show()
		// 			RETURN FALSE
		// 		ENDIF
		// 		* Check if account net asset,income or expense of a department:
		// 		IF !Empty(oAccSelf:Department)
		// 			oDep:=SQLSelect{"select depid,descriptn from department where depid="+Str(oAccSelf:Department,-1)+ " and incomeacc="+cRek+" or expenseacc="+cRek+" or netasset="+cRek,oConn}
		// 			IF oDep:Reccount>0
		// 				InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("This account is net asset, income or expense account of its department "+oDep:DESCRIPTN)+"!"}:Show()
		// 				RETURN FALSE
		// 			ENDIF
		// 		ENDIF
		// 		oTrans:=SQLSelect{"select count(*) as total from ("+UnionTrans("select t.transid from transaction t where accid="+cRek)+") as tot",oConn}
		// 		IF oTrans:Reccount>0 .and. Val(oTrans:total)>0
		// 			// 			InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("Financial transactions in non balanced years associated with this account")+"!"}:Show()
		// 			InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("Financial transactions associated with this account")+"!"}:Show()
		// 			return false
		// 		endif
		// 		oMBal:=Balances{}
		// 		oMBal:GetBalance(cRek)
		// 		IF !oMBal:per_cre - oMBal:per_deb==0
		// 			InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("Balance not zero for this account")+"!"}:Show()
		// 			return false
		// 		endif
		// 		// check if account not used as ROE-gain/loss:
		// 		oAcc:=SQLSelect{"select accnumber from account where gainlsacc="+cRek,oConn}
		// 		if oAcc:Reccount>0
		// 			InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("Account used as Exchange rate Gain/loss account in account")+" "+AllTrim(oAcc:ACCNUMBER)+"!"}:Show()
		// 			return false
		// 		endif
		// 		// check if account used in standorderline:
		// 		oAcc:=SQLSelect{"select stordrid from standingorderline where accountid="+cRek,oConn}
		// 		if oAcc:Reccount>0
		// 			InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("Account used in standing orders")+"!"}:Show()
		// 			return false
		// 		endif
		// 		
		// 		oStmnt:=SQLStatement{"delete from account where accid='"+cRek+"'",oConn}
		// 		oStmnt:Execute()							
		// 		if oStmnt:NumSuccessfulRows>0
		// 			* remove also corresponding subscriptions/donations: 
		// 			oStmnt:SQLString:="delete from subscription where accid="+cRek
		// 			oStmnt:Execute()
		// 			// remove corresponding balance years: 
		// 			oStmnt:SQLString:="delete from accountbalanceyear where accid="+cRek
		// 			oStmnt:Execute()
		// 			// remove also corresponding month balances: 
		// 			oStmnt:SQLString:="delete from mbalance where accid="+cRek
		// 			oStmnt:Execute()
		// 			// remove related telepattern too:
		// 			oStmnt:SQLString:="delete from telebankpatterns where accid="+cRek
		// 			oStmnt:Execute()
		// 			// remove related budget too: 
		// 			oStmnt:SQLString:="delete from budget where accid="+cRek
		// 			oStmnt:Execute() 
		//refresh:
		self:oAcc:Execute()
		self:oSFAccountBrowser_DETAIL:Browser:Refresh()
		self:GoTop()
	else
		return false
	ENDIF
	// 	ENDIF
	RETURN true

METHOD EditButton(lNew) CLASS AccountBrowser
	Default(@lNew,FALSE)
	if Empty(oAccCnt)
		oAccCnt:=AccountContainer{}
	endif
	IF !lNew
		if (self:Server:EOF.or.self:Server:BOF)
			(ErrorBox{,self:oLan:WGet("Select a account first")}):Show()
			RETURN
		endif
		self:oAccCnt:accid:=Str(self:oAcc:accid,-1)
	ENDIF
	(EditAccount{self:Owner,,,{lNew,self,self:oAccCnt} }):Show()

	RETURN
method EditFocusChange(oEditFocusChangeEvent) class AccountBrowser
	local oControl as Control
	local lGotFocus as logic
	LOCAL cCurValue as USUAL
	LOCAL nPntr as int
	oControl := iif(oEditFocusChangeEvent == null_object, null_object, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	super:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:NameSym==#FromDep .and.!AllTrim(oControl:TextValue)==self:cCurDep
			cCurValue:=AllTrim(oControl:TextValue)
			self:cCurDep:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindDep(@cCurValue)
				self:RegDepartment(cCurValue,"From Department")
			ELSE
				self:FromDepButton()
			ENDIF
		elseIF oControl:NameSym==#FromBal .and.!AllTrim(oControl:TextValue)==self:cCurBal
			cCurValue:=AllTrim(oControl:TextValue)
			self:cCurBal:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindBal(@cCurValue)
				self:RegBalance(cCurValue)
			ELSE
				self:FromBalButton()
			ENDIF

		ENDIF
	ENDIF
	return nil

method EnableSelect() class AccountBrowser
// enable/disbale select button
  	if self:oAcc:Reccount>0
  		self:oCCOKButton:Enable()
  	else
  		self:oCCOKButton:Disable()
  	endif
return
METHOD FindButton( ) CLASS AccountBrowser
	local aKeyw:={} as array
	local i as int                                           
	local cBalIncl,cDepIncl as string
	local cAccFilter:=self:cAccFilter as string
	self:cOrder:="accnumber"
	self:cWhere:="a.balitemid=b.balitemid" 
	// 	self:cFrom:="balanceitem as b,account as a left join member m on (m.accid=a.accid)"
	// 	self:cFields:="a.accid,a.accnumber,a.description,a.department,a.balitemid,a.currency,a.active,b.category as type,m.co"
	
	if !Empty(self:SearchUni) 
		aKeyw:=GetTokens(AllTrim(self:SearchUni))
		for i:=1 to Len(aKeyw)
			cWhere+=" and (accnumber like '%"+AddSlashes(aKeyw[i,1])+"%' or description like '%"+AddSlashes(aKeyw[i,1])+"%')"
		next
	endif
	if !Empty(self:searchOms)
		self:cWhere+=	iif(Empty(self:cWhere),""," and ")+" description like '"+AddSlashes(AllTrim(self:searchOms))+"%'"
		self:cOrder:="description"
	endif
	if !Empty(self:searchRek)
		self:cWhere+=	iif(Empty(self:cWhere),""," and ")+" accnumber like '"+AddSlashes(AllTrim(self:searchRek))+"%'"
	endif
	cDepIncl:=""
	if !Empty(self:WhoFrom)
		cDepIncl:=SetDepFilter(Val(self:WhoFrom))
		if !Empty(cDepIncl)
			self:cWhere+=iif(Empty(self:cWhere),""," and ")+" a.department in ("+cDepIncl+")" 
		endif
	endif
	if !Empty(self:WhatFrom)
		cBalIncl:=SetAccFilter(Val(self:WhatFrom))
		if !Empty(cBalIncl)
			self:cWhere+=iif(Empty(self:cWhere),""," and ")+" a.balitemid in ("+cBalIncl+")" 
		endif
	endif
	if !self:CheckBoxInactive
		self:cWhere+=iif(Empty(self:cWhere),"",' and ')+"a.active=1"
	else
		// remove from accfiler
		cAccFilter:=StrTran(StrTran(StrTran(cAccFilter,"and a.active=1",""),'a.active=1 and ',""),'a.active=1',"")
	endif   	
	self:oAcc:SQLString :="Select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+iif(Empty(cAccFilter),""," and "+cAccFilter)+" order by "+cOrder
	self:oAcc:Execute() 
	if !Empty(oAcc:status)
		LogEvent(self,"findbutton Acc:"+self:oAcc:status:Description+"( stamnt:"+self:oAcc:SQLString,"LogErrors")
	endif
	
	self:GoTop()
	self:oSFAccountBrowser_DETAIL:Browser:refresh()
	self:FOUND :=Str(self:oAcc:Reccount,-1)
	self:EnableSelect()

	RETURN nil 
ASSIGN FOUND(uValue) CLASS AccountBrowser
self:FIELDPUT(#Found, uValue)
RETURN uValue
ACCESS FromBal() CLASS AccountBrowser
RETURN SELF:FieldGet(#FromBal)

ASSIGN FromBal(uValue) CLASS AccountBrowser
SELF:FieldPut(#FromBal, uValue)
RETURN uValue

METHOD FromBalButton( ) CLASS AccountBrowser 
	LOCAL cCurValue as STRING
	LOCAL nPntr as int

	cCurValue:=AllTrim(self:oDCFromBal:TextValue)
	(BalanceItemExplorer{self:Owner,"BalanceItem",self:cCurBal,self,cCurValue,"From Balance Item"}):Show()

RETURN NIL
ACCESS FromDep() CLASS AccountBrowser
RETURN SELF:FieldGet(#FromDep)

ASSIGN FromDep(uValue) CLASS AccountBrowser
SELF:FieldPut(#FromDep, uValue)
RETURN uValue

 METHOD FromDepButton( ) CLASS AccountBrowser 
	LOCAL cCurValue as STRING
	LOCAL nPntr as int

	cCurValue:=AllTrim(self:oDCFromDep:TextValue)
	(DepartmentExplorer{self:Owner,"Department",self:cCurDep,self,cCurValue,"From Department"}):Show()

RETURN nil
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS AccountBrowser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"AccountBrowser",_GetInst()},iCtlID)

oDCSearchUni := SingleLineEdit{SELF,ResourceID{ACCOUNTBROWSER_SEARCHUNI,_GetInst()}}
oDCSearchUni:HyperLabel := HyperLabel{#SearchUni,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchUni:FocusSelect := FSEL_TRIM
oDCSearchUni:TooltipText := "Enter one or more (part of) key values"
oDCSearchUni:UseHLforToolTip := True

oDCSC_REK := FixedText{SELF,ResourceID{ACCOUNTBROWSER_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,_chr(38)+"Number:",NULL_STRING,NULL_STRING}

oDCSC_OMS := FixedText{SELF,ResourceID{ACCOUNTBROWSER_SC_OMS,_GetInst()}}
oDCSC_OMS:HyperLabel := HyperLabel{#SC_OMS,_chr(38)+"Description:",NULL_STRING,NULL_STRING}

oDCSearchREK := SingleLineEdit{SELF,ResourceID{ACCOUNTBROWSER_SEARCHREK,_GetInst()}}
oDCSearchREK:HyperLabel := HyperLabel{#SearchREK,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchREK:FocusSelect := FSEL_TRIM
oDCSearchREK:TooltipText := "Enter characters to match accountnumber"
oDCSearchREK:UseHLforToolTip := True

oDCSearchOMS := SingleLineEdit{SELF,ResourceID{ACCOUNTBROWSER_SEARCHOMS,_GetInst()}}
oDCSearchOMS:HyperLabel := HyperLabel{#SearchOMS,NULL_STRING,NULL_STRING,"Rek_OMS"}
oDCSearchOMS:FocusSelect := FSEL_HOME
oDCSearchOMS:UseHLforToolTip := True
oDCSearchOMS:TooltipText := "Enter characters to match account name"

oCCFindButton := PushButton{SELF,ResourceID{ACCOUNTBROWSER_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Find",NULL_STRING,NULL_STRING}

oCCEditButton := PushButton{SELF,ResourceID{ACCOUNTBROWSER_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,_chr(38)+"Edit","Edit of a record","File_New"}
oCCEditButton:OwnerAlignment := OA_PX

oCCNewButton := PushButton{SELF,ResourceID{ACCOUNTBROWSER_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,_chr(38)+"New",NULL_STRING,NULL_STRING}
oCCNewButton:OwnerAlignment := OA_PX

oCCDeleteButton := PushButton{SELF,ResourceID{ACCOUNTBROWSER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,_chr(38)+"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PX

oCCOKButton := PushButton{SELF,ResourceID{ACCOUNTBROWSER_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"Select","Return highlighted record",NULL_STRING}
oCCOKButton:UseHLforToolTip := True
oCCOKButton:OwnerAlignment := OA_PX

oDCGroupBox1 := GroupBox{SELF,ResourceID{ACCOUNTBROWSER_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Accounts",NULL_STRING,NULL_STRING}
oDCGroupBox1:OwnerAlignment := OA_HEIGHT

oDCGroupBox2 := GroupBox{SELF,ResourceID{ACCOUNTBROWSER_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Search accounts with:",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{ACCOUNTBROWSER_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Universal like google:",NULL_STRING,NULL_STRING}

oDCFound := FixedText{SELF,ResourceID{ACCOUNTBROWSER_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{ACCOUNTBROWSER_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

oCCFromDepButton := PushButton{SELF,ResourceID{ACCOUNTBROWSER_FROMDEPBUTTON,_GetInst()}}
oCCFromDepButton:HyperLabel := HyperLabel{#FromDepButton,"v","Browse in departments",NULL_STRING}
oCCFromDepButton:TooltipText := "Browse in departments"

oDCFromDep := SingleLineEdit{SELF,ResourceID{ACCOUNTBROWSER_FROMDEP,_GetInst()}}
oDCFromDep:HyperLabel := HyperLabel{#FromDep,NULL_STRING,NULL_STRING,NULL_STRING}
oDCFromDep:FieldSpec := Description{}
oDCFromDep:TooltipText := "Enter number or name of required Top of department structure"

oDCSC_DEP := FixedText{SELF,ResourceID{ACCOUNTBROWSER_SC_DEP,_GetInst()}}
oDCSC_DEP:HyperLabel := HyperLabel{#SC_DEP,"Department from:",NULL_STRING,NULL_STRING}

oCCFromBalButton := PushButton{SELF,ResourceID{ACCOUNTBROWSER_FROMBALBUTTON,_GetInst()}}
oCCFromBalButton:HyperLabel := HyperLabel{#FromBalButton,"v","Browse in balance items",NULL_STRING}
oCCFromBalButton:TooltipText := "Browse in balance items"

oDCFromBal := SingleLineEdit{SELF,ResourceID{ACCOUNTBROWSER_FROMBAL,_GetInst()}}
oDCFromBal:HyperLabel := HyperLabel{#FromBal,NULL_STRING,"Number of Balancegroup",NULL_STRING}
oDCFromBal:TooltipText := "Enter number or name of required Top of balance structure"

oDCSC_BAL := FixedText{SELF,ResourceID{ACCOUNTBROWSER_SC_BAL,_GetInst()}}
oDCSC_BAL:HyperLabel := HyperLabel{#SC_BAL,"Balance item from:",NULL_STRING,NULL_STRING}

oDCCheckBoxInactive := CheckBox{SELF,ResourceID{ACCOUNTBROWSER_CHECKBOXINACTIVE,_GetInst()}}
oDCCheckBoxInactive:HyperLabel := HyperLabel{#CheckBoxInactive,"Include inactive accounts",NULL_STRING,NULL_STRING}

SELF:Caption := "Browse in Accounts"
SELF:HyperLabel := HyperLabel{#AccountBrowser,"Browse in Accounts",NULL_STRING,NULL_STRING}
SELF:Menu := WOMenu{}
SELF:PreventAutoLayout := True
SELF:EnableStatusBar(True)

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFAccountBrowser_DETAIL := AccountBrowser_DETAIL{SELF,ACCOUNTBROWSER_ACCOUNTBROWSER_DETAIL}
oSFAccountBrowser_DETAIL:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS AccountBrowser
*	LOCAL oMyColumn AS OBJECT
Local oAcc:=self:Server, oAcct as SQLSelect
if oAcc:Reccount>0
	self:EndWindow()
	IF !self:oCaller==null_object
	    IF IsMethod(self:oCaller, #RegAccount)
			self:oCaller:RegAccount(oAcc,self:CallerName)
		ENDIF
	ENDIF
	lOK:=true
endif

	RETURN
method PostInit(oWindow,iCtlID,oServer,uExtra) class AccountBrowser
	//Put your PostInit additions here 
	
	self:SetTexts()
	IF !self:oCaller==null_object
		oCCOKButton:Show()
	ENDIF

	self:oDCSearchREK:SetFocus()
	IF AScan(aMenu,{|x| x[4]=="AccountEdit"})=0
		self:oCCDeleteButton:Hide()
		self:oCCNewButton:Hide()
	ENDIF
	self:GoTop() 
  	self:FOUND :=Str(self:oAcc:Reccount,-1) 
  	if self:oAcc:Reccount>0
  		self:oCCOKButton:Enable()
  	else
  		self:oCCOKButton:Disable()
  	endif
	if Departments
		self:oDCSC_DEP:Show()
		self:oDCFromDep:Show()
		self:oCCFromDepButton:Show()
		self:cCurDep:=iif(Empty(cDepmntIncl),"",Split(cDepmntIncl,",")[1])
		self:RegDepartment(self:cCurDep,"From Department")
	endif
   self:RegBalance(self:cCurBal)
	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS AccountBrowser
	//Put your PreInit additions here 

	if IsArray(uExtra)
		self:oCaller := uExtra[1]
		self:oAccCnt:=uExtra[2] 
		self:cOrder:=self:oAccCnt:cOrder
		self:cFields:=self:oAccCnt:cFields
		self:cFrom:=self:oAccCnt:cFrom 
		self:cWhere:=self:oAccCnt:cWhere
		self:cAccFilter:=self:oAccCnt:cAccFilter
	else
		self:cOrder:="accnumber" 
		self:cFields:="a.accid,a.accnumber,a.description,a.balitemid,a.currency,a.active, if(active=0,'NO','') as activedescr,a.department,b.category as type"
		self:cFrom:="balanceitem as b,account as a "
		self:cWhere:="a.balitemid=b.balitemid"
		self:cAccFilter:=iif(Empty(cDepmntIncl),"","a.department IN ("+cDepmntIncl+")")
		self:oAccCnt:=AccountContainer{}
	endif
	self:oAcc:=SQLSelect{"Select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+" and a.active=1"+iif(Empty(self:cAccFilter),""," and "+cAccFilter)+" order by "+cOrder,oConn}
//	LogEvent(self,"error:"+self:oAcc:errinfo:errormessage+"; statement:"+self:oAcc:SQLString,"logerrors")
	RETURN nil
METHOD Refresh() CLASS AccountBrowser 
	self:oAcc:Execute() 
	self:FOUND :=Str(self:oAcc:Reccount,-1)
	self:EnableSelect()
	self:oSFAccountBrowser_DETAIL:Browser:Refresh()
RETURN nil

ACCESS SearchOMS() CLASS AccountBrowser
RETURN SELF:FieldGet(#SearchOMS)

ASSIGN SearchOMS(uValue) CLASS AccountBrowser
SELF:FieldPut(#SearchOMS, uValue)
RETURN uValue

ACCESS SearchREK() CLASS AccountBrowser
RETURN SELF:FieldGet(#SearchREK)

ASSIGN SearchREK(uValue) CLASS AccountBrowser
SELF:FieldPut(#SearchREK, uValue)
RETURN uValue

ACCESS SearchUni() CLASS AccountBrowser
RETURN SELF:FieldGet(#SearchUni)

ASSIGN SearchUni(uValue) CLASS AccountBrowser
SELF:FieldPut(#SearchUni, uValue)
RETURN uValue

STATIC DEFINE ACCOUNTBROWSER_ACCOUNTBROWSER_DETAIL := 106 
STATIC DEFINE ACCOUNTBROWSER_CHECKBOXINACTIVE := 122 
STATIC DEFINE ACCOUNTBROWSER_DELETEBUTTON := 109 
RESOURCE AccountBrowser_DETAIL DIALOGEX  2, 2, 270, 140
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

CLASS AccountBrowser_DETAIL INHERIT DataWindowExtra 

	PROTECT oDBACCNUMBER as DataColumn
	PROTECT oDBACTIVEDESCR as DataColumn
	PROTECT oDBDESCRIPTION as DataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
ACCESS AccNumber() CLASS AccountBrowser_DETAIL
RETURN SELF:FieldGet(#AccNumber)
ASSIGN AccNumber(uValue) CLASS AccountBrowser_DETAIL
SELF:FieldPut(#AccNumber, uValue)
RETURN uValue

ACCESS Description() CLASS AccountBrowser_DETAIL
RETURN self:FIELDGET(#description)

ASSIGN Description(uValue) CLASS AccountBrowser_DETAIL
self:FIELDPUT(#description, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS AccountBrowser_DETAIL 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"AccountBrowser_DETAIL",_GetInst()},iCtlID)

SELF:Caption := ""
SELF:HyperLabel := HyperLabel{#AccountBrowser_DETAIL,NULL_STRING,NULL_STRING,NULL_STRING}
SELF:OwnerAlignment := OA_HEIGHT
SELF:DeferUse := False
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBACCNUMBER := DataColumn{account_ACCNUMBER{}}
oDBACCNUMBER:Width := 17
oDBACCNUMBER:HyperLabel := HyperLabel{#AccNumber,"Number",NULL_STRING,NULL_STRING} 
oDBACCNUMBER:Caption := "Number"
self:Browser:AddColumn(oDBACCNUMBER)

oDBACTIVEDESCR := DataColumn{6}
oDBACTIVEDESCR:Width := 6
oDBACTIVEDESCR:HyperLabel := HyperLabel{#activedescr,"Active",NULL_STRING,NULL_STRING} 
oDBACTIVEDESCR:Caption := "Active"
oDBactivedescr:TextColor := Color{COLORRED}
self:Browser:AddColumn(oDBACTIVEDESCR)

oDBDESCRIPTION := DataColumn{account_OMS{}}
oDBDESCRIPTION:Width := 54
oDBDESCRIPTION:HyperLabel := HyperLabel{#description,"Description",NULL_STRING,NULL_STRING} 
oDBDESCRIPTION:Caption := "Description"
self:Browser:AddColumn(oDBDESCRIPTION)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method PostInit(oWindow,iCtlID,oServer,uExtra) class AccountBrowser_DETAIL
	//Put your PostInit additions here 
// 	self:Use(oWindow:oAcc)
self:SetTexts() 
	self:Browser:SetStandardStyle(gbsReadOnly)
// 	self:GoTop() 
	return nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class AccountBrowser_DETAIL
	//Put your PreInit additions here
	if Empty(oWindow:Server) 
	 	oWindow:Use(oWindow:oAcc)
	endif
	return nil
STATIC DEFINE ACCOUNTBROWSER_DETAIL_ACCNUMBER := 100 
STATIC DEFINE ACCOUNTBROWSER_DETAIL_ACTIVEDESCR := 102 
STATIC DEFINE ACCOUNTBROWSER_DETAIL_DESCRIPTION := 101 
STATIC DEFINE ACCOUNTBROWSER_DETAIL_MACTIVE := 102 
STATIC DEFINE ACCOUNTBROWSER_EDITBUTTON := 107 
STATIC DEFINE ACCOUNTBROWSER_FINDBUTTON := 105 
STATIC DEFINE ACCOUNTBROWSER_FIXEDTEXT2 := 113 
STATIC DEFINE ACCOUNTBROWSER_FOUND := 114 
STATIC DEFINE ACCOUNTBROWSER_FOUNDTEXT := 115 
STATIC DEFINE ACCOUNTBROWSER_FROMBAL := 120 
STATIC DEFINE ACCOUNTBROWSER_FROMBALBUTTON := 119 
STATIC DEFINE ACCOUNTBROWSER_FROMDEP := 117 
STATIC DEFINE ACCOUNTBROWSER_FROMDEPBUTTON := 116 
STATIC DEFINE ACCOUNTBROWSER_GROUPBOX1 := 111 
STATIC DEFINE ACCOUNTBROWSER_GROUPBOX2 := 112 
STATIC DEFINE ACCOUNTBROWSER_NEWBUTTON := 108 
STATIC DEFINE ACCOUNTBROWSER_OKBUTTON := 110 
STATIC DEFINE ACCOUNTBROWSER_SC_BAL := 121 
STATIC DEFINE ACCOUNTBROWSER_SC_DEP := 118 
STATIC DEFINE ACCOUNTBROWSER_SC_OMS := 102 
STATIC DEFINE ACCOUNTBROWSER_SC_REK := 101 
STATIC DEFINE ACCOUNTBROWSER_SEARCHOMS := 104 
STATIC DEFINE ACCOUNTBROWSER_SEARCHREK := 103 
STATIC DEFINE ACCOUNTBROWSER_SEARCHUNI := 100 
class AccountContainer
// class to contain account attributes
	EXPORT m51_balid, m51_depid, m51_description as string 
	export cWhere,cFrom,cOrder,cFields,cAccFilter as string
	export accid as string
CLASS EditAccount INHERIT DataWindowExtra 

	PROTECT oDCSC_REK AS FIXEDTEXT
	PROTECT oDCSC_OMS AS FIXEDTEXT
	PROTECT oDCSC_NUM AS FIXEDTEXT
	PROTECT oDCSC_CLC AS FIXEDTEXT
	PROTECT oDCSC_ABP AS FIXEDTEXT
	PROTECT oDCmAccNumber AS SINGLELINEEDIT
	PROTECT oDCmGIFTALWD AS CHECKBOX
	PROTECT oDCmDescription AS SINGLELINEEDIT
	PROTECT oDCmBalitemid AS SINGLELINEEDIT
	PROTECT oCCBalButton AS PUSHBUTTON
	PROTECT oDCmDepartment AS SINGLELINEEDIT
	PROTECT oCCDepButton AS PUSHBUTTON
	PROTECT oDCmQtyMailing AS SINGLELINEEDIT
	PROTECT oDCmSubscriptionprice AS MYSINGLEEDIT
	PROTECT oDCmIPCaccount AS COMBOBOX
	PROTECT oDCBalanceDate AS DATETIMEPICKER
	PROTECT oDCmMultCurr AS CHECKBOX
	PROTECT oDCmCurrency AS COMBOBOX
	PROTECT oDCmReevaluate AS CHECKBOX
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCGainLossText AS FIXEDTEXT
	PROTECT oDCmGainLossacc AS SINGLELINEEDIT
	PROTECT oCCGLAccButton AS PUSHBUTTON
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCGroupBox3 AS GROUPBOX
	PROTECT oDCBalYears AS COMBOBOX
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oCCRadioButtonYear AS RADIOBUTTON
	PROTECT oDCmBalance AS SINGLELINEEDIT
	PROTECT oCCRadioButtonMonth AS RADIOBUTTON
	PROTECT oDCFixedText9 AS FIXEDTEXT
	PROTECT oDCTextBud1 AS FIXEDTEXT
	PROTECT oDCTextBud2 AS FIXEDTEXT
	PROTECT oDCmBUD1 AS MYSINGLEEDIT
	PROTECT oDCmBUD2 AS MYSINGLEEDIT
	PROTECT oDCmBUD3 AS MYSINGLEEDIT
	PROTECT oDCmBUD4 AS MYSINGLEEDIT
	PROTECT oDCmBUD5 AS MYSINGLEEDIT
	PROTECT oDCmBUD6 AS MYSINGLEEDIT
	PROTECT oDCmBUD7 AS MYSINGLEEDIT
	PROTECT oDCmBUD8 AS MYSINGLEEDIT
	PROTECT oDCmBUD9 AS MYSINGLEEDIT
	PROTECT oDCmBUD10 AS MYSINGLEEDIT
	PROTECT oDCmBUD11 AS MYSINGLEEDIT
	PROTECT oDCmBUD12 AS MYSINGLEEDIT
	PROTECT oDCTextBud3 AS FIXEDTEXT
	PROTECT oDCTextBud4 AS FIXEDTEXT
	PROTECT oDCTextBud6 AS FIXEDTEXT
	PROTECT oDCTextBud5 AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCTextBud12 AS FIXEDTEXT
	PROTECT oDCTextBud11 AS FIXEDTEXT
	PROTECT oDCTextBud10 AS FIXEDTEXT
	PROTECT oDCTextBud9 AS FIXEDTEXT
	PROTECT oDCTextBud8 AS FIXEDTEXT
	PROTECT oDCTextBud7 AS FIXEDTEXT
	PROTECT oDCBudgetGranularity AS RADIOBUTTONGROUP
	PROTECT oDCDefaultBox AS GROUPBOX
	PROTECT oDCmCod3 AS COMBOBOX
	PROTECT oDCmCod2 AS COMBOBOX
	PROTECT oDCmCod1 AS COMBOBOX
	PROTECT oDCXTRText AS FIXEDTEXT
	PROTECT oDCValueText AS FIXEDTEXT
	PROTECT oDCPropValueCombo AS COMBOBOX
	PROTECT oDCPropBox AS LISTBOX
	PROTECT oDCPropValueSingle AS SINGLELINEEDIT
	PROTECT oDCCurrText AS FIXEDTEXT
	PROTECT oDCGroupBox4 AS GROUPBOX
	PROTECT oDCTextSysCur AS FIXEDTEXT
	PROTECT oDCmBalanceF AS SINGLELINEEDIT
	PROTECT oDCTextForgnCur AS FIXEDTEXT
	PROTECT oDCIPCText AS FIXEDTEXT
	PROTECT oDCmReimb AS CHECKBOX
	PROTECT oDCmActive AS CHECKBOX
	PROTECT oDCmembertext AS FIXEDTEXT
	PROTECT oDCFixedText29 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
//    		instance mAccNumber 
// 	instance mGIFTALWD 
// 	instance mDescription 
// 	instance mNum 
// 	instance mDepartment 
// 	instance mSubscriptionprice
// 	instance mReevaluate
// 	instance mMultiCurr
// 	instance mCurrency
// 	instance mGLAccount  
// 	instance mCod1, mCod2, mCod3 
// 	instance BalYears 
// 	instance mBalance 
// 	instance mBUD1 
// 	instance mBUD2 
// 	instance mBUD3 
// 	instance mBUD4 
// 	instance mBUD5 
// 	instance mBUD6 
// 	instance mBUD7 
// 	instance mBUD8 
// 	instance mBUD9 
// 	instance mBUD10 
// 	instance mBUD11 
// 	instance mBUD12 
// 	instance BudgetGranularity
// 	instance PropValueSingle,PropValueCombo 
  	EXPORT oAcc as SQLSelect
  	PROTECT nCurRec as int
  	PROTECT nCurNum,cCurGainLossAcc, nCurDep, cCurSingle as STRING
  	Export  mNumSave,mDep as string
  	PROTECT dCurDate as date
  	PROTECT oCaller as OBJECT
  	PROTECT lMember,lMemberDep as LOGIC
  	PROTECT mMainId, mAccId as STRING
  	export mGainLsacc as string
  	PROTECT mSoort as STRING
	PROTECT cCurBal, cCurDep as STRING
	EXPORT mCln, mAccId as STRING 
	protect aProp as Array
	protect CurBal as float 
	Protect Enabled:=true as logic
	export lExists as logic 
	export oAccCnt as AccountContainer 
	
	declare method PropValueShow
RESOURCE EditAccount DIALOGEX  4, 3, 409, 391
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Accountnumber", EDITACCOUNT_SC_REK, "Static", WS_CHILD, 12, 18, 52, 12
	CONTROL	"Description:", EDITACCOUNT_SC_OMS, "Static", WS_CHILD, 12, 36, 39, 13
	CONTROL	"What is it:", EDITACCOUNT_SC_NUM, "Static", WS_CHILD, 12, 55, 52, 12
	CONTROL	"Mailing Code:", EDITACCOUNT_SC_CLC, "Static", WS_CHILD, 8, 292, 45, 12
	CONTROL	"Subscription price:", EDITACCOUNT_SC_ABP, "Static", WS_CHILD, 184, 73, 59, 13
	CONTROL	"", EDITACCOUNT_MACCNUMBER, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 18, 93, 12
	CONTROL	"Gifts Receivable", EDITACCOUNT_MGIFTALWD, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 180, 18, 72, 12
	CONTROL	"", EDITACCOUNT_MDESCRIPTION, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 36, 224, 13
	CONTROL	"", EDITACCOUNT_MBALITEMID, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 55, 93, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITACCOUNT_BALBUTTON, "Button", WS_CHILD, 164, 55, 15, 12
	CONTROL	"", EDITACCOUNT_MDEPARTMENT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 228, 55, 97, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITACCOUNT_DEPBUTTON, "Button", WS_CHILD, 324, 55, 15, 12
	CONTROL	"", EDITACCOUNT_MQTYMAILING, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 73, 60, 13, WS_EX_CLIENTEDGE
	CONTROL	"Subscriptionprice:", EDITACCOUNT_MSUBSCRIPTIONPRICE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 256, 73, 68, 13
	CONTROL	"", EDITACCOUNT_MIPCACCOUNT, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_VSCROLL, 72, 92, 108, 72
	CONTROL	"15-10-2011", EDITACCOUNT_BALANCEDATE, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 36, 118, 70, 13
	CONTROL	"Multi Currency", EDITACCOUNT_MMULTCURR, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 12, 155, 60, 11
	CONTROL	"", EDITACCOUNT_MCURRENCY, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 112, 155, 104, 72
	CONTROL	"Reevaluate", EDITACCOUNT_MREEVALUATE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 224, 155, 56, 11
	CONTROL	"Date:", EDITACCOUNT_FIXEDTEXT6, "Static", WS_CHILD, 8, 118, 23, 12
	CONTROL	"Account", EDITACCOUNT_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 7, 340, 100
	CONTROL	"Gain/Loss account:", EDITACCOUNT_GAINLOSSTEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 224, 169, 64, 13
	CONTROL	"", EDITACCOUNT_MGAINLOSSACC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 288, 169, 92, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITACCOUNT_GLACCBUTTON, "Button", WS_CHILD|NOT WS_VISIBLE, 380, 169, 15, 13
	CONTROL	"Balance", EDITACCOUNT_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 0, 110, 368, 27
	CONTROL	"Of who is it:", EDITACCOUNT_FIXEDTEXT7, "Static", WS_CHILD, 184, 55, 42, 12
	CONTROL	"Budget:", EDITACCOUNT_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 188, 366, 86
	CONTROL	"", EDITACCOUNT_BALYEARS, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 72, 195, 88, 72
	CONTROL	"Year:", EDITACCOUNT_FIXEDTEXT8, "Static", WS_CHILD, 9, 196, 53, 13
	CONTROL	"Budget per year", EDITACCOUNT_RADIOBUTTONYEAR, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 72, 226, 80, 11
	CONTROL	"", EDITACCOUNT_MBALANCE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 108, 118, 78, 12, WS_EX_CLIENTEDGE
	CONTROL	"Budget per month", EDITACCOUNT_RADIOBUTTONMONTH, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 72, 240, 80, 11
	CONTROL	"Amount:", EDITACCOUNT_FIXEDTEXT9, "Static", WS_CHILD, 168, 197, 28, 12
	CONTROL	"Jan:", EDITACCOUNT_TEXTBUD1, "Static", WS_CHILD|NOT WS_VISIBLE, 202, 197, 18, 12
	CONTROL	"Feb:", EDITACCOUNT_TEXTBUD2, "Static", WS_CHILD|NOT WS_VISIBLE, 202, 209, 18, 12
	CONTROL	"Budget:", EDITACCOUNT_MBUD1, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 222, 197, 54, 12
	CONTROL	"Budget:", EDITACCOUNT_MBUD2, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 222, 209, 54, 12
	CONTROL	"Budget:", EDITACCOUNT_MBUD3, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 222, 220, 54, 12
	CONTROL	"Budget:", EDITACCOUNT_MBUD4, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 222, 232, 54, 12
	CONTROL	"Budget:", EDITACCOUNT_MBUD5, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 222, 243, 54, 12
	CONTROL	"Budget:", EDITACCOUNT_MBUD6, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 222, 254, 54, 13
	CONTROL	"Budget:", EDITACCOUNT_MBUD7, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 304, 198, 53, 12
	CONTROL	"Budget:", EDITACCOUNT_MBUD8, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 304, 209, 53, 13
	CONTROL	"Budget:", EDITACCOUNT_MBUD9, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 304, 221, 53, 12
	CONTROL	"Budget:", EDITACCOUNT_MBUD10, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 304, 233, 53, 12
	CONTROL	"Budget:", EDITACCOUNT_MBUD11, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 304, 244, 53, 12
	CONTROL	"Budget:", EDITACCOUNT_MBUD12, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 304, 256, 53, 12
	CONTROL	"Mar:", EDITACCOUNT_TEXTBUD3, "Static", WS_CHILD|NOT WS_VISIBLE, 202, 220, 18, 12
	CONTROL	"Apr:", EDITACCOUNT_TEXTBUD4, "Static", WS_CHILD|NOT WS_VISIBLE, 202, 232, 18, 12
	CONTROL	"Jun:", EDITACCOUNT_TEXTBUD6, "Static", WS_CHILD|NOT WS_VISIBLE, 202, 254, 18, 13
	CONTROL	"May:", EDITACCOUNT_TEXTBUD5, "Static", WS_CHILD|NOT WS_VISIBLE, 202, 243, 17, 12
	CONTROL	"OK", EDITACCOUNT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 348, 11, 53, 13
	CONTROL	"Cancel", EDITACCOUNT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 348, 30, 53, 13
	CONTROL	"Dec:", EDITACCOUNT_TEXTBUD12, "Static", WS_CHILD|NOT WS_VISIBLE, 285, 256, 18, 12
	CONTROL	"Nov:", EDITACCOUNT_TEXTBUD11, "Static", WS_CHILD|NOT WS_VISIBLE, 285, 244, 18, 12
	CONTROL	"Oct:", EDITACCOUNT_TEXTBUD10, "Static", WS_CHILD|NOT WS_VISIBLE, 285, 233, 18, 12
	CONTROL	"Sep:", EDITACCOUNT_TEXTBUD9, "Static", WS_CHILD|NOT WS_VISIBLE, 285, 221, 17, 12
	CONTROL	"Aug:", EDITACCOUNT_TEXTBUD8, "Static", WS_CHILD|NOT WS_VISIBLE, 285, 209, 18, 13
	CONTROL	"Jul:", EDITACCOUNT_TEXTBUD7, "Static", WS_CHILD|NOT WS_VISIBLE, 285, 198, 18, 12
	CONTROL	"Budget granularity:", EDITACCOUNT_BUDGETGRANULARITY, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 67, 217, 93, 39
	CONTROL	"Default person parameter values for givers/payers to this account:", EDITACCOUNT_DEFAULTBOX, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 0, 280, 366, 107
	CONTROL	"", EDITACCOUNT_MCOD3, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 196, 291, 61, 72
	CONTROL	"", EDITACCOUNT_MCOD2, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 131, 291, 61, 72
	CONTROL	"", EDITACCOUNT_MCOD1, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 68, 291, 61, 72
	CONTROL	"Extra properties for new persons:", EDITACCOUNT_XTRTEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 8, 309, 164, 12
	CONTROL	"change value:", EDITACCOUNT_VALUETEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 232, 309, 136, 13
	CONTROL	"", EDITACCOUNT_PROPVALUECOMBO, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_VSCROLL, 232, 321, 133, 58
	CONTROL	"", EDITACCOUNT_PROPBOX, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER|WS_VSCROLL, 4, 321, 216, 63, WS_EX_CLIENTEDGE
	CONTROL	"", EDITACCOUNT_PROPVALUESINGLE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 232, 321, 133, 12, WS_EX_CLIENTEDGE
	CONTROL	"Currency:", EDITACCOUNT_CURRTEXT, "Static", WS_CHILD, 80, 156, 32, 12
	CONTROL	"Currencies ", EDITACCOUNT_GROUPBOX4, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 144, 396, 44
	CONTROL	"Fixed Text", EDITACCOUNT_TEXTSYSCUR, "Static", WS_CHILD, 188, 118, 24, 12
	CONTROL	"", EDITACCOUNT_MBALANCEF, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 216, 118, 78, 12, WS_EX_CLIENTEDGE
	CONTROL	"Fixed Text", EDITACCOUNT_TEXTFORGNCUR, "Static", WS_CHILD|NOT WS_VISIBLE, 296, 118, 20, 12
	CONTROL	"IPC Account:", EDITACCOUNT_IPCTEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 12, 92, 53, 12
	CONTROL	"Used for reimbursement?", EDITACCOUNT_MREIMB, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 248, 18, 92, 11
	CONTROL	"Active", EDITACCOUNT_MACTIVE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 308, 36, 36, 12
	CONTROL	"", EDITACCOUNT_MEMBERTEXT, "Static", SS_RIGHT|SS_CENTERIMAGE|WS_CHILD, 252, 0, 91, 12
	CONTROL	"Quantity mailing:", EDITACCOUNT_FIXEDTEXT29, "Static", WS_CHILD, 12, 73, 53, 13
END

METHOD BalButton(cBalValue) CLASS EditAccount
	(BalanceItemExplorer{self:Owner,"Balance Item",mNumSave,self,cBalValue}):show()
RETURN nil
ACCESS BalYears() CLASS EditAccount
RETURN SELF:FieldGet(#BalYears)

ASSIGN BalYears(uValue) CLASS EditAccount
SELF:FieldPut(#BalYears, uValue)
RETURN uValue

ACCESS BudgetGranularity() CLASS EditAccount
RETURN SELF:FieldGet(#BudgetGranularity)

ASSIGN BudgetGranularity(uValue) CLASS EditAccount
SELF:FieldPut(#BudgetGranularity, uValue)
RETURN uValue

METHOD ButtonClick(oControlEvent) CLASS EditAccount
	LOCAL oControl as Control
	LOCAL MonthAmnt:=0, YearAmnt:=0 as FLOAT
	LOCAL i,ic as int
	LOCAL BudYear,BudMonth as int
	LOCAL aContr as ARRAY
	LOCAL x as Control
	LOCAL y as FixedText
	LOCAL cNum as STRING
	LOCAL lEnable:=true as LOGIC
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:Name=="RADIOBUTTONMONTH"
		BudYear:=Val(SubStr(self:oDCBalYears:Value,1,4))
		BudMonth:=Val(SubStr(self:oDCBalYears:Value,5,2))

		 // Maandbedragen bepalen:
	 	MonthAmnt:=Round(self:mBud1/12,DecAantal)
	 	FOR i:=1 to 12
		 	self:FillBudget(MonthAmnt,i,aContr,BudMonth,BudYear)
		 	BudMonth++
	 	NEXT
	ELSEIF oControl:Name=="RADIOBUTTONYEAR"
	 	self:FillBudgetYear(aContr)
	elseif oControl:Name=="MGIFTALWD"
		self:ShowDefaults()		
	elseif oControl:Name=="MMULTCURR"
		self:ShowCurrency()		
	elseif oControl:Name=="MREEVALUATE"
		self:ShowCurrency()		
	elseif oControl:Name=="MACTIVE"
		if oControl:Value==FALSE
			self:oDCmActive:TextColor:=Color{COLORRED}
		else
			self:oDCmActive:TextColor:=Color{COLORBLACK}
		endif
	ENDIF

	RETURN nil
METHOD CancelButton( ) CLASS EditAccount 
	IF self:lImport
		self:oImport:NextImport(self,false)
		RETURN
	ENDIF

	self:EndWindow()

RETURN NIL
METHOD DateTimeSelectionChanged(oDateTimeSelectionEvent) CLASS EditAccount
	local oBalncs as Balances
	SUPER:DateTimeSelectionChanged(oDateTimeSelectionEvent) 
	//Put your changes here
	IF !oDCBalanceDate:SelectedDate == dCurDate
		
		dCurDate := oDCBalanceDate:SelectedDate
		oBalncs:=Balances{}
		oBalncs:GetBalance(mAccId,,oDCBalanceDate:SelectedDate,self:mCurrency)

		self:mBalance:=Round(oBalncs:per_cre-oBalncs:per_deb,DecAantal)
// 		oMBal:GetBalance(mAccId,mNumSave,,oDCBalanceDate:SelectedDate,self:mCurrency) 
		if self:mCurrency # sCURR
	     	self:oDCmBalanceF:Value:=Round(oBalncs:per_creF-oBalncs:per_debF,DecAantal)
		endif
	ENDIF

	RETURN nil
METHOD DepButton( cCurValue) CLASS EditAccount
	(DepartmentExplorer{self:Owner,"Department",mDep,self,cCurValue}):show()
RETURN nil
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS EditAccount
	LOCAL oControl as Control
	LOCAL lGotFocus as LOGIC
	LOCAL cCurValue as USUAL
	LOCAL nPntr, nSel as int
	local amProp:=self:aProp as array
	Local mPropBox:=self:oDCPropBox as ListBox
	Local cNewValue as string
	oControl := iif(oEditFocusChangeEvent == null_object, null_object, oEditFocusChangeEvent:Control)
	lGotFocus := iif(oEditFocusChangeEvent == null_object, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus

		IF oControl:NameSym==#mBalitemid.and.!IsNil(oControl:VALUE).and.!AllTrim(oControl:VALUE)==self:cCurBal
			cCurValue:=AllTrim(oControl:VALUE)
			self:cCurBal:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindBal(@cCurValue)
				self:RegBalance(cCurValue)
			ELSE
				self:BalButton(cCurValue)
			ENDIF
		ELSEIF oControl:NameSym==#mDepartment .and.!IsNil(oControl:VALUE).and.!AllTrim(oControl:VALUE)==self:cCurDep
			cCurValue:=AllTrim(oControl:VALUE)
			self:cCurDep:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindDep(@cCurValue)
				self:RegDepartment(cCurValue,"")
			ELSE
				self:DepButton(cCurValue)
			ENDIF
		ELSEIF oControl:NameSym==#PropValueSingle .and.!IsNil(oControl:VALUE).and.!AllTrim(oControl:VALUE)==self:cCurSingle
			self:cCurSingle:=AllTrim(oControl:VALUE)
			nSel:= oDCPropBox:CurrentItemNo
			self:oDCPropBox:SelectItem(nSel) 
			cNewValue:=SubStr(self:oDCPropBox:CurrentItem,1,30)+self:cCurSingle
			nPntr:=AScan(amProp,{|x| x[2]==mPropBox:VALUE })
			if nPntr>0
				self:aProp[nPntr][1]:=cNewValue 
				oDCPropBox:FillUsing(self:FillProps( ))
			endif
		ELSEIF oControl:NameSym==#mGainLossacc .and.!IsNil(oControl:VALUE).and.!AllTrim(oControl:VALUE)==self:cCurGainLossAcc
			self:cCurGainLossAcc:=AllTrim(oControl:VALUE)
         self:GLAccButton()
		ENDIF
	ENDIF
	RETURN nil
METHOD FillIPC() class EditAccount
local aIPC:={} as Array
local oIPC as SQLSelect
oIPC:=SQLSelect{"select descriptn,ipcaccount from ipcaccounts where ipcaccount "+iif(self:mSoort="BA","<60000",">50000"), oConn}
// if self:mSoort="BA"
// 	oIPC:SetFilter({||oIPC:IPCACCOUNT<60000})
// else
// 	oIPC:SetFilter({||oIPC:IPCACCOUNT>50000})
// endif
oIPC:GoTop()
return oIPC:GetLookupTable(,#Descriptn,#IPCAccount) 
METHOD GLAccButton(lUnique ) CLASS EditAccount 
	Default(@lUnique,FALSE)	
	AccountSelect(self,AllTrim(self:oDCmGainLossacc:textValue ),"Gain/Loss account",lUnique,"currency='"+sCurr+"'"+iif(Empty(self:mGainLsacc),""," and a.accid='"+self:mGainLsacc+"'"))

RETURN nil
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditAccount 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditAccount",_GetInst()},iCtlID)

oDCSC_REK := FixedText{SELF,ResourceID{EDITACCOUNT_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,"Accountnumber",NULL_STRING,NULL_STRING}

oDCSC_OMS := FixedText{SELF,ResourceID{EDITACCOUNT_SC_OMS,_GetInst()}}
oDCSC_OMS:HyperLabel := HyperLabel{#SC_OMS,"Description:",NULL_STRING,NULL_STRING}

oDCSC_NUM := FixedText{SELF,ResourceID{EDITACCOUNT_SC_NUM,_GetInst()}}
oDCSC_NUM:HyperLabel := HyperLabel{#SC_NUM,"What is it:",NULL_STRING,NULL_STRING}

oDCSC_CLC := FixedText{SELF,ResourceID{EDITACCOUNT_SC_CLC,_GetInst()}}
oDCSC_CLC:HyperLabel := HyperLabel{#SC_CLC,"Mailing Code:",NULL_STRING,NULL_STRING}

oDCSC_ABP := FixedText{SELF,ResourceID{EDITACCOUNT_SC_ABP,_GetInst()}}
oDCSC_ABP:HyperLabel := HyperLabel{#SC_ABP,"Subscription price:",NULL_STRING,NULL_STRING}

oDCmAccNumber := SingleLineEdit{SELF,ResourceID{EDITACCOUNT_MACCNUMBER,_GetInst()}}
oDCmAccNumber:HyperLabel := HyperLabel{#mAccNumber,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmAccNumber:Picture := "XXXXXXXXXXXX"
oDCmAccNumber:FieldSpec := account_ACCNUMBER{}

oDCmGIFTALWD := CheckBox{SELF,ResourceID{EDITACCOUNT_MGIFTALWD,_GetInst()}}
oDCmGIFTALWD:HyperLabel := HyperLabel{#mGIFTALWD,"Gifts Receivable","Indication if gifts are allowed for this account","Rek_GIFTALWD"}
oDCmGIFTALWD:FieldSpec := account_GIFTALWD{}

oDCmDescription := SingleLineEdit{SELF,ResourceID{EDITACCOUNT_MDESCRIPTION,_GetInst()}}
oDCmDescription:HyperLabel := HyperLabel{#mDescription,NULL_STRING,"Description","Rek_OMS"}
oDCmDescription:FieldSpec := account_OMS{}

oDCmBalitemid := SingleLineEdit{SELF,ResourceID{EDITACCOUNT_MBALITEMID,_GetInst()}}
oDCmBalitemid:HyperLabel := HyperLabel{#mBalitemid,NULL_STRING,"What is it: Assoiciated balance item",NULL_STRING}
oDCmBalitemid:TooltipText := "Enter number or heading of required item"

oCCBalButton := PushButton{SELF,ResourceID{EDITACCOUNT_BALBUTTON,_GetInst()}}
oCCBalButton:HyperLabel := HyperLabel{#BalButton,"v","What is it: Assoiciated balance item",NULL_STRING}
oCCBalButton:TooltipText := "Browse in balance items"

oDCmDepartment := SingleLineEdit{SELF,ResourceID{EDITACCOUNT_MDEPARTMENT,_GetInst()}}
oDCmDepartment:HyperLabel := HyperLabel{#mDepartment,NULL_STRING,"From Who is it: Department",NULL_STRING}
oDCmDepartment:TooltipText := "Enter number or name of required department"

oCCDepButton := PushButton{SELF,ResourceID{EDITACCOUNT_DEPBUTTON,_GetInst()}}
oCCDepButton:HyperLabel := HyperLabel{#DepButton,"v","Browse in Departments",NULL_STRING}
oCCDepButton:TooltipText := "Browse in Departments"

oDCmQtyMailing := SingleLineEdit{SELF,ResourceID{EDITACCOUNT_MQTYMAILING,_GetInst()}}
oDCmQtyMailing:TooltipText := "Nbr of persons receiving this mailing when this account is used for a campaign"
oDCmQtyMailing:HyperLabel := HyperLabel{#mQtyMailing,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmQtyMailing:FieldSpec := account_qtymailing{}

oDCmSubscriptionprice := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MSUBSCRIPTIONPRICE,_GetInst()}}
oDCmSubscriptionprice:HyperLabel := HyperLabel{#mSubscriptionprice,"Subscriptionprice:","Optionally price of a subscription",NULL_STRING}
oDCmSubscriptionprice:FieldSpec := account_ABP{}
oDCmSubscriptionprice:UseHLforToolTip := True

oDCmIPCaccount := combobox{SELF,ResourceID{EDITACCOUNT_MIPCACCOUNT,_GetInst()}}
oDCmIPCaccount:HyperLabel := HyperLabel{#mIPCaccount,NULL_STRING,NULL_STRING,"Select corresponding IPC account"}
oDCmIPCaccount:UseHLforToolTip := True
oDCmIPCaccount:FillUsing(Self:FillIPC())

oDCBalanceDate := DateTimePicker{SELF,ResourceID{EDITACCOUNT_BALANCEDATE,_GetInst()}}
oDCBalanceDate:HyperLabel := HyperLabel{#BalanceDate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmMultCurr := CheckBox{SELF,ResourceID{EDITACCOUNT_MMULTCURR,_GetInst()}}
oDCmMultCurr:HyperLabel := HyperLabel{#mMultCurr,"Multi Currency","Account can be used for more than one currency",NULL_STRING}
oDCmMultCurr:UseHLforToolTip := True

oDCmCurrency := combobox{SELF,ResourceID{EDITACCOUNT_MCURRENCY,_GetInst()}}
oDCmCurrency:HyperLabel := HyperLabel{#mCurrency,NULL_STRING,"Currency used by this account",NULL_STRING}
oDCmCurrency:FillUsing(SQLSelect{"select united_ara,aed from currencylist",oConn}:getLookupTable(300,#UNITED_ARA,#AED))
oDCmCurrency:UseHLforToolTip := True

oDCmReevaluate := CheckBox{SELF,ResourceID{EDITACCOUNT_MREEVALUATE,_GetInst()}}
oDCmReevaluate:HyperLabel := HyperLabel{#mReevaluate,"Reevaluate",NULL_STRING,"Reevaluate to local currency everey month automatically"}

oDCFixedText6 := FixedText{SELF,ResourceID{EDITACCOUNT_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"Date:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{EDITACCOUNT_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Account",NULL_STRING,NULL_STRING}

oDCGainLossText := FixedText{SELF,ResourceID{EDITACCOUNT_GAINLOSSTEXT,_GetInst()}}
oDCGainLossText:HyperLabel := HyperLabel{#GainLossText,"Gain/Loss account:",NULL_STRING,NULL_STRING}

oDCmGainLossacc := SingleLineEdit{SELF,ResourceID{EDITACCOUNT_MGAINLOSSACC,_GetInst()}}
oDCmGainLossacc:HyperLabel := HyperLabel{#mGainLossacc,NULL_STRING,"Account for exchange rate gain/loss for reevaluation",NULL_STRING}
oDCmGainLossacc:TooltipText := "Account of this member"
oDCmGainLossacc:FieldSpec := Description{}
oDCmGainLossacc:UseHLforToolTip := True

oCCGLAccButton := PushButton{SELF,ResourceID{EDITACCOUNT_GLACCBUTTON,_GetInst()}}
oCCGLAccButton:HyperLabel := HyperLabel{#GLAccButton,"v","Browse in accounts",NULL_STRING}
oCCGLAccButton:TooltipText := "Browse in accounts"

oDCGroupBox2 := GroupBox{SELF,ResourceID{EDITACCOUNT_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Balance",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{EDITACCOUNT_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Of who is it:",NULL_STRING,NULL_STRING}

oDCGroupBox3 := GroupBox{SELF,ResourceID{EDITACCOUNT_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"Budget:",NULL_STRING,NULL_STRING}

oDCBalYears := combobox{SELF,ResourceID{EDITACCOUNT_BALYEARS,_GetInst()}}
oDCBalYears:FillUsing(Self:GetBalYears( ))
oDCBalYears:HyperLabel := HyperLabel{#BalYears,NULL_STRING,"Balance Years",NULL_STRING}

oDCFixedText8 := FixedText{SELF,ResourceID{EDITACCOUNT_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"Year:",NULL_STRING,NULL_STRING}

oCCRadioButtonYear := RadioButton{SELF,ResourceID{EDITACCOUNT_RADIOBUTTONYEAR,_GetInst()}}
oCCRadioButtonYear:HyperLabel := HyperLabel{#RadioButtonYear,"Budget per year",NULL_STRING,NULL_STRING}

oDCmBalance := SingleLineEdit{SELF,ResourceID{EDITACCOUNT_MBALANCE,_GetInst()}}
oDCmBalance:HyperLabel := HyperLabel{#mBalance,NULL_STRING,NULL_STRING,NULL_STRING}

oCCRadioButtonMonth := RadioButton{SELF,ResourceID{EDITACCOUNT_RADIOBUTTONMONTH,_GetInst()}}
oCCRadioButtonMonth:HyperLabel := HyperLabel{#RadioButtonMonth,"Budget per month",NULL_STRING,NULL_STRING}

oDCFixedText9 := FixedText{SELF,ResourceID{EDITACCOUNT_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"Amount:",NULL_STRING,NULL_STRING}

oDCTextBud1 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD1,_GetInst()}}
oDCTextBud1:HyperLabel := HyperLabel{#TextBud1,"Jan:",NULL_STRING,NULL_STRING}

oDCTextBud2 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD2,_GetInst()}}
oDCTextBud2:HyperLabel := HyperLabel{#TextBud2,"Feb:",NULL_STRING,NULL_STRING}

oDCmBUD1 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD1,_GetInst()}}
oDCmBUD1:FieldSpec := Budget_Amount{}
oDCmBUD1:HyperLabel := HyperLabel{#mBUD1,"Budget:",NULL_STRING,NULL_STRING}

oDCmBUD2 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD2,_GetInst()}}
oDCmBUD2:FieldSpec := Budget_Amount{}
oDCmBUD2:HyperLabel := HyperLabel{#mBUD2,"Budget:",NULL_STRING,"Rek_BUD"}

oDCmBUD3 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD3,_GetInst()}}
oDCmBUD3:FieldSpec := Budget_Amount{}
oDCmBUD3:HyperLabel := HyperLabel{#mBUD3,"Budget:",NULL_STRING,"Rek_BUD"}

oDCmBUD4 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD4,_GetInst()}}
oDCmBUD4:FieldSpec := Budget_Amount{}
oDCmBUD4:HyperLabel := HyperLabel{#mBUD4,"Budget:",NULL_STRING,"Rek_BUD"}

oDCmBUD5 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD5,_GetInst()}}
oDCmBUD5:FieldSpec := Budget_Amount{}
oDCmBUD5:HyperLabel := HyperLabel{#mBUD5,"Budget:",NULL_STRING,"Rek_BUD"}

oDCmBUD6 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD6,_GetInst()}}
oDCmBUD6:FieldSpec := Budget_Amount{}
oDCmBUD6:HyperLabel := HyperLabel{#mBUD6,"Budget:",NULL_STRING,"Rek_BUD"}

oDCmBUD7 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD7,_GetInst()}}
oDCmBUD7:FieldSpec := Budget_Amount{}
oDCmBUD7:HyperLabel := HyperLabel{#mBUD7,"Budget:",NULL_STRING,"Rek_BUD"}

oDCmBUD8 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD8,_GetInst()}}
oDCmBUD8:FieldSpec := Budget_Amount{}
oDCmBUD8:HyperLabel := HyperLabel{#mBUD8,"Budget:",NULL_STRING,"Rek_BUD"}

oDCmBUD9 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD9,_GetInst()}}
oDCmBUD9:FieldSpec := Budget_Amount{}
oDCmBUD9:HyperLabel := HyperLabel{#mBUD9,"Budget:",NULL_STRING,"Rek_BUD"}

oDCmBUD10 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD10,_GetInst()}}
oDCmBUD10:FieldSpec := Budget_Amount{}
oDCmBUD10:HyperLabel := HyperLabel{#mBUD10,"Budget:",NULL_STRING,"Rek_BUD"}

oDCmBUD11 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD11,_GetInst()}}
oDCmBUD11:FieldSpec := Budget_Amount{}
oDCmBUD11:HyperLabel := HyperLabel{#mBUD11,"Budget:",NULL_STRING,"Rek_BUD"}

oDCmBUD12 := mySingleEdit{SELF,ResourceID{EDITACCOUNT_MBUD12,_GetInst()}}
oDCmBUD12:FieldSpec := Budget_Amount{}
oDCmBUD12:HyperLabel := HyperLabel{#mBUD12,"Budget:",NULL_STRING,"Rek_BUD"}

oDCTextBud3 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD3,_GetInst()}}
oDCTextBud3:HyperLabel := HyperLabel{#TextBud3,"Mar:",NULL_STRING,NULL_STRING}

oDCTextBud4 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD4,_GetInst()}}
oDCTextBud4:HyperLabel := HyperLabel{#TextBud4,"Apr:",NULL_STRING,NULL_STRING}

oDCTextBud6 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD6,_GetInst()}}
oDCTextBud6:HyperLabel := HyperLabel{#TextBud6,"Jun:",NULL_STRING,NULL_STRING}

oDCTextBud5 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD5,_GetInst()}}
oDCTextBud5:HyperLabel := HyperLabel{#TextBud5,"May:",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{EDITACCOUNT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITACCOUNT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCTextBud12 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD12,_GetInst()}}
oDCTextBud12:HyperLabel := HyperLabel{#TextBud12,"Dec:",NULL_STRING,NULL_STRING}

oDCTextBud11 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD11,_GetInst()}}
oDCTextBud11:HyperLabel := HyperLabel{#TextBud11,"Nov:",NULL_STRING,NULL_STRING}

oDCTextBud10 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD10,_GetInst()}}
oDCTextBud10:HyperLabel := HyperLabel{#TextBud10,"Oct:",NULL_STRING,NULL_STRING}

oDCTextBud9 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD9,_GetInst()}}
oDCTextBud9:HyperLabel := HyperLabel{#TextBud9,"Sep:",NULL_STRING,NULL_STRING}

oDCTextBud8 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD8,_GetInst()}}
oDCTextBud8:HyperLabel := HyperLabel{#TextBud8,"Aug:",NULL_STRING,NULL_STRING}

oDCTextBud7 := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTBUD7,_GetInst()}}
oDCTextBud7:HyperLabel := HyperLabel{#TextBud7,"Jul:",NULL_STRING,NULL_STRING}

oDCDefaultBox := GroupBox{SELF,ResourceID{EDITACCOUNT_DEFAULTBOX,_GetInst()}}
oDCDefaultBox:HyperLabel := HyperLabel{#DefaultBox,"Default person parameter values for givers/payers to this account:",NULL_STRING,NULL_STRING}

oDCmCod3 := combobox{SELF,ResourceID{EDITACCOUNT_MCOD3,_GetInst()}}
oDCmCod3:HyperLabel := HyperLabel{#mCod3,NULL_STRING,"Mailing code to be assigned to each giver to this account",NULL_STRING}
oDCmCod3:FillUsing(pers_codes)
oDCmCod3:UseHLforToolTip := True

oDCmCod2 := combobox{SELF,ResourceID{EDITACCOUNT_MCOD2,_GetInst()}}
oDCmCod2:HyperLabel := HyperLabel{#mCod2,NULL_STRING,"Mailing code to be assigned to each giver to this account",NULL_STRING}
oDCmCod2:FillUsing(pers_codes)
oDCmCod2:UseHLforToolTip := True

oDCmCod1 := combobox{SELF,ResourceID{EDITACCOUNT_MCOD1,_GetInst()}}
oDCmCod1:HyperLabel := HyperLabel{#mCod1,NULL_STRING,"Mailing code to be assigned to each giver to this account",NULL_STRING}
oDCmCod1:FillUsing(pers_codes)
oDCmCod1:UseHLforToolTip := True

oDCXTRText := FixedText{SELF,ResourceID{EDITACCOUNT_XTRTEXT,_GetInst()}}
oDCXTRText:HyperLabel := HyperLabel{#XTRText,"Extra properties for new persons:",NULL_STRING,NULL_STRING}

oDCValueText := FixedText{SELF,ResourceID{EDITACCOUNT_VALUETEXT,_GetInst()}}
oDCValueText:HyperLabel := HyperLabel{#ValueText,"change value:",NULL_STRING,NULL_STRING}

oDCPropValueCombo := combobox{SELF,ResourceID{EDITACCOUNT_PROPVALUECOMBO,_GetInst()}}
oDCPropValueCombo:HyperLabel := HyperLabel{#PropValueCombo,NULL_STRING,"Select value as default value for new persons giving to this account",NULL_STRING}
oDCPropValueCombo:UseHLforToolTip := True

oDCPropBox := ListBox{SELF,ResourceID{EDITACCOUNT_PROPBOX,_GetInst()}}
oDCPropBox:HyperLabel := HyperLabel{#PropBox,NULL_STRING,"Select default value for an extra property",NULL_STRING}
oDCPropBox:UseHLforToolTip := True
oDCPropBox:FillUsing(Self:FillProps( ))

oDCPropValueSingle := SingleLineEdit{SELF,ResourceID{EDITACCOUNT_PROPVALUESINGLE,_GetInst()}}
oDCPropValueSingle:HyperLabel := HyperLabel{#PropValueSingle,NULL_STRING,"Enter value as default value for new givers to this account",NULL_STRING}
oDCPropValueSingle:UseHLforToolTip := True

oDCCurrText := FixedText{SELF,ResourceID{EDITACCOUNT_CURRTEXT,_GetInst()}}
oDCCurrText:HyperLabel := HyperLabel{#CurrText,"Currency:",NULL_STRING,NULL_STRING}

oDCGroupBox4 := GroupBox{SELF,ResourceID{EDITACCOUNT_GROUPBOX4,_GetInst()}}
oDCGroupBox4:HyperLabel := HyperLabel{#GroupBox4,"Currencies ",NULL_STRING,NULL_STRING}

oDCTextSysCur := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTSYSCUR,_GetInst()}}
oDCTextSysCur:HyperLabel := HyperLabel{#TextSysCur,"Fixed Text",NULL_STRING,NULL_STRING}

oDCmBalanceF := SingleLineEdit{SELF,ResourceID{EDITACCOUNT_MBALANCEF,_GetInst()}}
oDCmBalanceF:HyperLabel := HyperLabel{#mBalanceF,NULL_STRING,NULL_STRING,NULL_STRING}

oDCTextForgnCur := FixedText{SELF,ResourceID{EDITACCOUNT_TEXTFORGNCUR,_GetInst()}}
oDCTextForgnCur:HyperLabel := HyperLabel{#TextForgnCur,"Fixed Text",NULL_STRING,NULL_STRING}

oDCIPCText := FixedText{SELF,ResourceID{EDITACCOUNT_IPCTEXT,_GetInst()}}
oDCIPCText:HyperLabel := HyperLabel{#IPCText,"IPC Account:",NULL_STRING,NULL_STRING}

oDCmReimb := CheckBox{SELF,ResourceID{EDITACCOUNT_MREIMB,_GetInst()}}
oDCmReimb:HyperLabel := HyperLabel{#mReimb,"Used for reimbursement?",NULL_STRING,NULL_STRING}

oDCmActive := CheckBox{SELF,ResourceID{EDITACCOUNT_MACTIVE,_GetInst()}}
oDCmActive:HyperLabel := HyperLabel{#mActive,"Active",NULL_STRING,NULL_STRING}
oDCmActive:TooltipText := "Can this account be used for recording financial transactions?"

oDCmembertext := FixedText{SELF,ResourceID{EDITACCOUNT_MEMBERTEXT,_GetInst()}}
oDCmembertext:HyperLabel := HyperLabel{#membertext,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText29 := FixedText{SELF,ResourceID{EDITACCOUNT_FIXEDTEXT29,_GetInst()}}
oDCFixedText29:HyperLabel := HyperLabel{#FixedText29,"Quantity mailing:",NULL_STRING,NULL_STRING}

oDCBudgetGranularity := RadioButtonGroup{SELF,ResourceID{EDITACCOUNT_BUDGETGRANULARITY,_GetInst()}}
oDCBudgetGranularity:FillUsing({ ;
									{oCCRadioButtonYear,"Year"}, ;
									{oCCRadioButtonMonth,"Month"} ;
									})
oDCBudgetGranularity:HyperLabel := HyperLabel{#BudgetGranularity,"Budget granularity:",NULL_STRING,NULL_STRING}

SELF:Caption := "Edit of  an account"
SELF:HyperLabel := HyperLabel{#EditAccount,"Edit of  an account",NULL_STRING,NULL_STRING}
SELF:Icon := ITEMICON{}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := False

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListBoxSelect(oControlEvent) CLASS EditAccount
	LOCAL oControl as Control
	LOCAL i as int
	LOCAL aContr:={} as ARRAY
	LOCAL BudYear,BudMonth as int
// 	LOCAL oAcc:=self:Server as Account
	LOCAL BudAmnt,CurAmnt:=0.00 as FLOAT
	LOCAL MonthEqual:=true as LOGIC
	LOCAL nPntr, nSel as int
	local amProp:=self:aProp as array
	Local mPropBox:=self:oDCPropBox as ListBox
	Local cNewValue as string
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControl:Name=="BALYEARS" .and. !self:lNew
		// Lees budget uit database:
		BudYear:=Val(SubStr(oControl:Value,1,4))
		BudMonth:=Val(SubStr(oControl:Value,5,2))
		FOR i:=1 to 12
			BudAmnt:=GetBudget(BudYear,BudMonth,self:mAccId)		
			self:FillBudget(BudAmnt,i,aContr,BudMonth,BudYear)
			IF i==1
				CurAmnt:=BudAmnt
			ELSEIF CurAmnt!=BudAmnt
				MonthEqual:=FALSE
			ENDIF
			BudMonth++
			IF BudMonth>12
				BudMonth:=1
				BudYear++
			ENDIF
		NEXT
		IF MonthEqual
			self:FillBudgetYear(aContr)
			self:BudgetGranularity:="Year"
		ENDIF
	elseif oControl:Name=="PROPBOX"
		self:PropValueShow(oControl:Value,SubStr(oControl:TextValue,30))
	elseif oControl:Name=="PROPVALUECOMBO"
		cCurSingle:=AllTrim(oControl:VALUE)
		nSel:= oDCPropBox:CurrentItemNo
		self:oDCPropBox:SelectItem(nSel) 
		cNewValue:=SubStr(self:oDCPropBox:CurrentItem,1,30)+cCurSingle
		nPntr:=AScan(amProp,{|x| x[2]==mPropBox:VALUE })
		if nPntr>0
			self:aProp[nPntr][1]:=cNewValue 
			oDCPropBox:FillUsing(self:FillProps( ))
		endif
	elseif oControl:Name=="MCURRENCY" 
		self:ShowCurrency()
	ENDIF
	RETURN nil 
ACCESS mABP() CLASS EditAccount
RETURN SELF:FieldGet(#mABP)

ASSIGN mABP(uValue) CLASS EditAccount
SELF:FieldPut(#mABP, uValue)
RETURN uValue

ACCESS mAccNumber() CLASS EditAccount
RETURN SELF:FieldGet(#mAccNumber)

ASSIGN mAccNumber(uValue) CLASS EditAccount
SELF:FieldPut(#mAccNumber, uValue)
RETURN uValue

ACCESS mActive() CLASS EditAccount
RETURN SELF:FieldGet(#mActive)

ASSIGN mActive(uValue) CLASS EditAccount
SELF:FieldPut(#mActive, uValue)
RETURN uValue

ACCESS mBalance() CLASS EditAccount
RETURN SELF:FieldGet(#mBalance)

ASSIGN mBalance(uValue) CLASS EditAccount
SELF:FieldPut(#mBalance, uValue)
RETURN uValue

ACCESS mBalanceF() CLASS EditAccount
RETURN SELF:FieldGet(#mBalanceF)

ASSIGN mBalanceF(uValue) CLASS EditAccount
SELF:FieldPut(#mBalanceF, uValue)
RETURN uValue

ACCESS mBalitemid() CLASS EditAccount
RETURN SELF:FieldGet(#mBalitemid)

ASSIGN mBalitemid(uValue) CLASS EditAccount
SELF:FieldPut(#mBalitemid, uValue)
RETURN uValue

ACCESS mBUD10() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD10)

ASSIGN mBUD10(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD10, uValue)
RETURN uValue

ACCESS mBUD11() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD11)

ASSIGN mBUD11(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD11, uValue)
RETURN uValue

ACCESS mBUD12() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD12)

ASSIGN mBUD12(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD12, uValue)
RETURN uValue

ACCESS mBUD1() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD1)

ASSIGN mBUD1(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD1, uValue)
RETURN uValue

ACCESS mBUD2() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD2)

ASSIGN mBUD2(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD2, uValue)
RETURN uValue

ACCESS mBUD3() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD3)

ASSIGN mBUD3(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD3, uValue)
RETURN uValue

ACCESS mBUD4() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD4)

ASSIGN mBUD4(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD4, uValue)
RETURN uValue

ACCESS mBUD5() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD5)

ASSIGN mBUD5(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD5, uValue)
RETURN uValue

ACCESS mBUD6() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD6)

ASSIGN mBUD6(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD6, uValue)
RETURN uValue

ACCESS mBUD7() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD7)

ASSIGN mBUD7(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD7, uValue)
RETURN uValue

ACCESS mBUD8() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD8)

ASSIGN mBUD8(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD8, uValue)
RETURN uValue

ACCESS mBUD9() CLASS EditAccount
RETURN SELF:FieldGet(#mBUD9)

ASSIGN mBUD9(uValue) CLASS EditAccount
SELF:FieldPut(#mBUD9, uValue)
RETURN uValue

ACCESS mCod1() CLASS EditAccount
RETURN SELF:FieldGet(#mCod1)

ASSIGN mCod1(uValue) CLASS EditAccount
SELF:FieldPut(#mCod1, uValue)
RETURN uValue

ACCESS mCod2() CLASS EditAccount
RETURN SELF:FieldGet(#mCod2)

ASSIGN mCod2(uValue) CLASS EditAccount
SELF:FieldPut(#mCod2, uValue)
RETURN uValue

ACCESS mCod3() CLASS EditAccount
RETURN SELF:FieldGet(#mCod3)

ASSIGN mCod3(uValue) CLASS EditAccount
SELF:FieldPut(#mCod3, uValue)
RETURN uValue

ACCESS mCurrency() CLASS EditAccount
RETURN SELF:FieldGet(#mCurrency)

ASSIGN mCurrency(uValue) CLASS EditAccount
SELF:FieldPut(#mCurrency, uValue)
RETURN uValue

ACCESS mDepartment() CLASS EditAccount
RETURN SELF:FieldGet(#mDepartment)

ASSIGN mDepartment(uValue) CLASS EditAccount
SELF:FieldPut(#mDepartment, uValue)
RETURN uValue

ACCESS mDescription() CLASS EditAccount
RETURN SELF:FieldGet(#mDescription)

ASSIGN mDescription(uValue) CLASS EditAccount
SELF:FieldPut(#mDescription, uValue)
RETURN uValue

ACCESS mGainLossacc() CLASS EditAccount
RETURN SELF:FieldGet(#mGainLossacc)

ASSIGN mGainLossacc(uValue) CLASS EditAccount
SELF:FieldPut(#mGainLossacc, uValue)
RETURN uValue

ACCESS mGIFTALWD() CLASS EditAccount
RETURN SELF:FieldGet(#mGIFTALWD)

ASSIGN mGIFTALWD(uValue) CLASS EditAccount
SELF:FieldPut(#mGIFTALWD, uValue)
RETURN uValue

ACCESS mIPCaccount() CLASS EditAccount
RETURN SELF:FieldGet(#mIPCaccount)

ASSIGN mIPCaccount(uValue) CLASS EditAccount
SELF:FieldPut(#mIPCaccount, uValue)
RETURN uValue

ACCESS mMultCurr() CLASS EditAccount
RETURN SELF:FieldGet(#mMultCurr)

ASSIGN mMultCurr(uValue) CLASS EditAccount
SELF:FieldPut(#mMultCurr, uValue)
RETURN uValue

ACCESS mQtyMailing() CLASS EditAccount
RETURN SELF:FieldGet(#mQtyMailing)

ASSIGN mQtyMailing(uValue) CLASS EditAccount
SELF:FieldPut(#mQtyMailing, uValue)
RETURN uValue

ACCESS mReevaluate() CLASS EditAccount
RETURN SELF:FieldGet(#mReevaluate)

ASSIGN mReevaluate(uValue) CLASS EditAccount
SELF:FieldPut(#mReevaluate, uValue)
RETURN uValue

ACCESS mReimb() CLASS EditAccount
RETURN SELF:FieldGet(#mReimb)

ASSIGN mReimb(uValue) CLASS EditAccount
SELF:FieldPut(#mReimb, uValue)
RETURN uValue

ACCESS mSubscriptionprice() CLASS EditAccount
RETURN SELF:FieldGet(#mSubscriptionprice)

ASSIGN mSubscriptionprice(uValue) CLASS EditAccount
SELF:FieldPut(#mSubscriptionprice, uValue)
RETURN uValue

METHOD OkButton CLASS EditAccount
	LOCAL oListViewItem as ListViewItem
	LOCAL cCurId as STRING
	LOCAL AmntMonth as FLOAT
	LOCAL BudYear,BudMonth as int
	LOCAL BudChanged:=FALSE as LOGIC
	LOCAL i, nPntr as int
	local cExtra,cValue as string 
	local amProp:=self:aProp as array
	local oStmt,oBudUpd,oBudIns as SQLSTatement
	local cStatement as string 
	

	IF self:ValidateAccount()
		if self:mGIFTALWD
  			// fill extra properties defaults:
			cExtra:=""
			FOR i:=1 to Len(amProp) step 1
				nPntr:=AScan(pers_propextra,{|x| x[2]==amProp[i,2] })
				cValue:=AddSlashes(AllTrim(SubStr(amProp[i,1],31)))
				if !Empty(cValue)
					cExtra+=iif(Empty(cExtra),"<velden>","")+"<V"+Str(amProp[i,2],-1)+">"+cValue+"</V"+Str(amProp[i,2],-1)+">"
				endif
			NEXT
			cExtra+=iif(Empty(cExtra),"","</velden>")
		endif
		cStatement:=iif(self:lNew,"Insert into","update")+" account Set "+;
		"accnumber='"+LTrimZero(self:mAccNumber)+"'"+;
		", description='"+ AddSlashes(AllTrim(self:mDescription))+"'"+;
		", balitemid='"+self:mNumSave+"'"+;
		", department='"+self:mDep+"'"+;
      iif(ADMIN=="WA",", reimb="+self:mReimb,"")+;
      ", subscriptionprice="+ Str(self:mSubscriptionprice,-1)+;
      ", qtymailing="+ Str(self:mQtyMailing,-1)+;
		", giftalwd="+iif(self:lMember.and.!self:lMemberDep,"1",iif(self:mGIFTALWD,"1","0"))+;
		",active="+iif(self:mactive,"1","0")+;
		", ipcaccount="+iif(IsNil(self:mIPCaccount) .or. Empty(self:oDCmIPCaccount:VALUE) .or. IsString(self:oDCmIPCaccount:VALUE),"0",Str(self:oDCmIPCaccount:VALUE,-1))+;
		iif(self:mGIFTALWD,", clc='"+	MakeCod({self:mCod1,self:mCod2,self:mCod3})+"',propxtra='"+Transform(cExtra,"@B")+"'",", clc='',propxtra=''")+;
		", multcurr="+ iif(self:mMultCurr,"1","0")+; 
		iif(!self:mMultCurr,;
			iif(self:mCurrency # sCURR,", currency='"+self:mCurrency+"',reevaluate="+iif(self:mReevaluate,"1,gainlsacc="+self:mGainLsacc,"0,gainlsacc=0"),;
				", currency='"+sCURR+"',reevaluate=0,gainlsacc=0"),;
			", currency='"+sCURR+"',reevaluate=0,gainlsacc=0")+;
		iif(self:lNew,""," where accid="+self:mAccId)
		oStmt:=SQLStatement{cStatement,oConn}
		oStmt:Execute()
		if !Empty(oStmt:status)
			LogEvent(self,"Error:"+oStmt:ErrInfo:errormessage+CRLF+"stmnt:"+cStatement,"LogErrors")
			(ErrorBox{self,"Fout:"+AllTrim(oStmt:status:Description)+CRLF+oStmt:SQLString}):Show()
			return nil
		endif

		if self:lNew
			self:mAccId:=ConS(SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
		endif
		// Save also Budget: 
		BudYear:=Val(SubStr(self:oDCBalYears:VALUE,1,4))
		BudMonth:=Val(SubStr(self:oDCBalYears:VALUE,5,2))
		IF BudYear*12+BudMonth>=Year(MinDate)*12+Month(MinDate)
			oBudUpd:=SQLStatement{"update budget set amount=? where accid="+self:mAccId+" and year=? and month=?",oConn}
			oBudIns:=SQLStatement{"insert into budget (accid,amount,year,month) values("+self:mAccId+",?,?,?)",oConn}
 			IF self:BudgetGranularity="Year"
 				AmntMonth:=Round(self:mBud1/12,DecAantal) 
				FOR i:=1 to 12
					oBudUpd:Execute({Str(AmntMonth,-1),Str(BudYear,4),StrZero(BudMonth,2)})
					if oBudUpd:NumSuccessfulRows<1
						// not found, thus insert:
						oBudIns:Execute({Str(AmntMonth,-1),Str(BudYear,4),StrZero(BudMonth,2)})
					endif
					BudMonth++
					IF BudMonth>12
						BudMonth:=1
						BudYear++
					ENDIF
				NEXT
 			ELSE
				// Save every separate budget:
				FOR i:=1 to 12
					AmntMonth:=IVarGetSelf(self,String2Symbol("mBud"+Str(i,-1)))
					oBudUpd:Execute({Str(AmntMonth,-1),Str(BudYear,4),StrZero(BudMonth,2)})
					if oBudUpd:NumSuccessfulRows<1
						// not found, thus insert:
						oBudIns:Execute({Str(AmntMonth,-1),Str(BudYear,4),StrZero(BudMonth,2)})
					endif
					BudMonth++
					IF BudMonth>12
						BudMonth:=1
						BudYear++
					ENDIF
				NEXT
    		ENDIF
		ENDIF
		IF IsObject(oCaller).and.!oCaller==null_object
			IF IsMethod(oCaller,#RefreshTree)
				IF lNew 
// 					oAcc:seek(#ACCNUMBER,LTrimZero(self:mAccNumber))
					IF Empty(self:nCurNum).and.!Empty(self:nCurDep)
						cCurId:=self:mDep
					ELSEIF Empty(self:nCurDep).and.!Empty(self:nCurNum)
						cCurId:=self:mNumSave
					ENDIF
					IF !Empty(cCurId)
						AAdd(self:oCaller:aAccnts,{Val(self:mAccId),Val(cCurId),self:mDescription,AllTrim(self:mAccNumber),self:mSoort}) 
						self:oCaller:Treeview:AddTreeItem(Val(cCurId),Val(self:mAccId),AllTrim(self:mAccNumber)+":"+self:mDescription,true) 
						self:oCaller:Treeview:expand(String2Symbol("Parent_" + cCurId))
						IF cCurId==self:nCurNum.or.cCurId==self:nCurDep 
							self:oCaller:Refresh()
// 							oListViewItem := ListViewItem{}
// 							oListViewItem:ImageIndex	:= 3
// 							// for each field, set the value in the item 
// 							oListViewItem:SetValue(self:mAccId, #Identifier)
// 							oListViewItem:SetText(self:mAccNumber,	#Identifier)
// 							oListViewItem:SetValue(self:mDescription, #Description)
// 							oListViewItem:SetValue("Account", #Type)
// 							oCaller:ListView:AddItem(oListViewItem)
						ENDIF
					ENDIF
				ELSE
*					IF !nCurNum==mNumSave
	*					IF IsMethod(oCaller,#TransferItem)
*							oCaller:TransferItem(oItemDrag , oItemDrop)
*						endif
// 						oCaller:Refresh()
						oCaller:RefreshTree()
*					ENDIF
				ENDIF
			elseIF IsMethod(oCaller,#Refresh) 
				self:oCaller:Refresh()
// 			ELSEIF IsObject(self:oCaller:oAcc)
// 				self:oCaller:oAcc:Execute()
// 				if !Empty(self:oCaller:oAcc:status)
// 					LogEvent(self,"wrong:"+self:oCaller:oAcc:SQLString,"LogErrors")
// 				endif 
// 				self:oCaller:oAcc:SuspendNotification() 
// 				// reposition owner at current person:
// 				self:oCaller:GoTop()
// 				do while !self:oCaller:oAcc:EOF .and. !self:oCaller:oAcc:accid==Val(self:mAccId)
// 					self:oCaller:oAcc:Skip()
// 				enddo
// 				self:nCurRec:=self:oCaller:oAcc:Recno
// 				self:oCaller:oAcc:ResetNotification()
// 				if !Empty(self:nCurRec)
// 					self:oCaller:goto(self:nCurRec)
// 				endif
// 			  	self:oCaller:FOUND :=Str(self:oCaller:oAcc:Reccount,-1)
// 				self:oCaller:EnableSelect()
			endif
		ENDIF
		IF self:lImport
			self:oImport:NextImport(self)
			RETURN nil
		ENDIF
		self:EndWindow()
	
	ENDIF
	
	RETURN nil
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditAccount
	//Put your PostInit additions here
	LOCAL i,rYear as int
	LOCAL cCaller as STRING
	LOCAL oAccG as SQLSelect
	LOCAL CurYear:=Year(Today())*100+Month(Today()) as int
	LOCAL oXMLDoc as XMLDocument
	local osel as SQLSelect
	local oBalncs as Balances 
	self:SetTexts()
	
	// 	oDep:=Department{}
	// 	IF !oDep:Used
	// 		oDep:=null_object
	// 		self:EndWindow()
	// 		RETURN FALSE
	// 	ENDIF
	self:oDCBalYears:CurrentItemNo:=3
	self:oDCBudgetGranularity:VALUE:="Year"
	FOR i:=1 to oDCBalYears:ItemCount
		rYear:=Round(Val(oDCBalYears:GetItemValue(i)),0)
		IF rYear-CurYear<= 2
			self:oDCBalYears:CurrentItemNo:=i
			exit
		ENDIF			
	NEXT
	if Empty(sCURR)
		(ErrorBox{self,self:oLan:WGet("Specify first System Currency within System parameters")}):Show()
		self:EndWindow()
	endif
	self:oDCTextSysCur:textValue:=sCURR
	if ADMIN=="WA"
		self:oDCmReimb:Show()
	endif 
	IF	IsArray(uExtra)
		self:lNew:=uExtra[1]
		if Len(uExtra) > 2
			self:oAccCnt:=uExtra[3]
			self:nCurNum:= self:oAccCnt:m51_balid
			self:nCurDep:=self:oAccCnt:m51_depid
			self:mNumSave := self:nCurNum
			self:mDep:= self:nCurDep
			self:mAccId:=self:oAccCnt:accid
		endif
	ENDIF
	
	IF self:lNew
		self:oDCmAccNumber:SetFocus()
		self:oDCBalanceDate:Disable()
		// 		self:mGIFTALWD:=FALSE 
		// 		mDep:=" "
		self:mCurrency:=sCURR 
		self:mCLN:="0"
		// 		mNumSave:=self:oDCmNum:textValue
		IF !Empty(self:oCaller)
			IF IsAccess(self:oCaller,#SearchOms)
				self:mDescription:=IVarGet(oCaller,#SearchOms)
				self:mAccNumber:=IVarGet(oCaller,#SearchRek)
				cCaller:=IVarGet(oCaller,#CallerName)
				IF cCaller=="Member Account"
					// 					IF !Empty(oAcc:MemberBal)
					// 						mNumSave:=oAcc:MemberBal
					// 					ENDIF
					// 					IF !Empty(oAcc:MemberDep)
					// 						mDep:=oAcc:MemberDep
					// 					ENDIF
					self:mGIFTALWD:=true
					self:oDCmGIFTALWD:Disable()
				ENDIF
			ENDIF
		ENDIF
		self:mactive:=true
		if empty(self:mDescription) .and.!empty(self:oAccCnt:m51_description)
			self:mDescription:=self:oAccCnt:m51_description
		endif
		if !Empty(self:mNumSave)
			// read balance item:
			osel:=SQLSelect{"select number,heading from balanceitem where balitemid="+mNumSave,oConn}
			self:mBalitemid:=AllTrim(osel:NUMBER)+":"+osel:heading
			self:cCurBal:=self:mBalitemid
		ENDIF
		IF Empty(self:mDep)
			self:mDepartment:="0:"+sEntity+" "+sLand
		else
			osel:=SQLSelect{"select deptmntnbr,descriptn,ipcproject from department where depid="+self:mDep,oConn}
			self:mDepartment:=osel:DEPTMNTNBR+":"+osel:DESCRIPTN
			self:ShowIPC(osel:IPCPROJECT)
		ENDIF
		self:cCurDep:=self:mDepartment
	ELSE
		// 		oAcc:seek(#REK,self:mAccId)
		// 		oAcc:GoTop() 
		// 		oAcc:=SQLSelect{"select a.* from account left join (m.persid as mcln from member m ) where a.accid="+self:mAccId,oConn}
		self:oAcc:=SQLSelect{;
			"select a.accid,a.accnumber,a.description,a.balitemid,department,a.gainlsacc,subscriptionprice,a.currency,a.multcurr,reevaluate,"+; 
			"reimb,a.active,a.clc,a.propxtra,a.giftalwd,a.qtymailing,ipcaccount,"+;
			"b.category as type,b.heading,b.number,d.deptmntnbr,d.descriptn,d.ipcproject,d.incomeacc,d.expenseacc,d.netasset, m.persid as mcln from balanceitem as b, account as a "+;
			"left join department d on (d.depid=a.department) "+;
			"left join member as m on (a.accid=m.accid or m.depid=d.depid) "+; 
			"where a.accid="+self:mAccId+" and b.balitemid=a.balitemid",oConn}

		self:mAccNumber := self:oAcc:ACCNUMBER 
		self:mAccId:= Str(self:oAcc:accid,-1)
		*    	SELF:oDCmREK:Disable()
		self:mDescription := self:oAcc:Description
		self:mNumSave := Str(self:oAcc:balitemid,-1)
		self:nCurNum:=mNumSave
		self:mDep:=Str(self:oAcc:Department,-1) 
		if !Empty(self:oAcc:GAINLSACC) 
			oAccG:=SQLSelect{"select accid,description from account where accid="+Str(self:oAcc:GAINLSACC,-1),oConn}
			// 			oAccG:seek(#REK,self:oAcc:GAINLSACC)
			self:cCurGainLossAcc:=AllTrim(oAccG:Description)
			self:oDCmGainLossacc:textValue:= oAccG:Description
			self:mGainLsacc:=Str(oAccG:accid,-1)
		else
			self:mGainLossacc:=""
		endif
		self:mSubscriptionprice := self:oAcc:subscriptionprice 
		self:mQtyMailing:=self:oAcc:qtymailing
		self:mSoort:=self:oAcc:TYPE 
		self:mCurrency:=self:oAcc:Currency 
		if Empty(self:mCurrency)
			self:mCurrency:=sCURR
		endif 
		oBalncs:=Balances{}
		oBalncs:GetBalance(mAccId,,,self:mCurrency) 
		self:CurBal:=Round(oBalncs:per_cre-oBalncs:per_deb,DecAantal)
		self:mBalance:=self:CurBal 
		
		// 		oMBal:GetBalance(self:mAccId,self:mNumSave)

		// 		self:CurBal:=oMBal:per_cre-oMBal:per_deb 
		if oBalncs:per_cre#0 .or.oBalncs:per_deb#0
			self:oDCmCurrency:Disable()
			self:Enabled:=false
		else
			self:oDCmCurrency:Enable()
			self:Enabled:=true
		endif 
		// 		self:mBalance:=self:CurBal

		self:mMultCurr:=iif(ConI(self:oAcc:MULTCURR)=1,true,false)
		if !self:mMultCurr .and. !self:mCurrency==sCURR
			self:oDCmBalanceF:Show()
			self:oDCTextForgnCur:Show()
			self:oDCTextForgnCur:textValue:=self:mCurrency
			self:oDCmBalanceF:VALUE:=Round(oBalncs:per_creF-oBalncs:per_debF,DecAantal)
		else
			self:oDCmBalanceF:Hide()
			self:oDCTextForgnCur:Hide()
			self:oDCTextForgnCur:textValue :=self:mCurrency
			self:oDCmBalanceF:VALUE:=self:CurBal
		endif
		self:mReevaluate:=iif(ConI(self:oAcc:reevaluate)=1,true,false)
		self:mactive:=iif(ConI(self:oAcc:active)=1,true,false)
		if ADMIN=="WA"
			self:mReimb:=self:oAcc:REIMB
		endif
		IF!Empty(self:oAcc:CLC) 
			self:mCod1  := if(Empty(SubStr(self:oAcc:CLC,1,2)),nil,SubStr(self:oAcc:CLC,1,2))
			self:mCod2  := if(Empty(SubStr(self:oAcc:CLC,4,2)),nil,SubStr(self:oAcc:CLC,4,2))
			self:mCod3  := if(Empty(SubStr(self:oAcc:CLC,7,2)),nil,SubStr(self:oAcc:CLC,7,2))
		else
			self:mCod1:=nil
			self:mCod2:=nil
			self:mCod2:=nil
		ENDIF
		// Fill extra properties:
		if !Empty(self:oAcc:PROPXTRA) .and.Len(self:aProp)>0
			oXMLDoc:=XMLDocument{self:oAcc:PROPXTRA}
			FOR i:=1 to Len(self:aProp)
				IF oXMLDoc:GetElement("V"+Str(self:aProp[i][2],-1))
					self:aProp[i,1]:=SubStr(self:aProp[i,1],1,30)+oXMLDoc:GetContentCurrentElement()
				ENDIF
			NEXT
			self:oDCPropBox:FillUsing(self:aProp)
// 		else
// 			self:oDCPropBox:FillUsing({})			
		endif
		self:oDCmGIFTALWD:Checked:=ConL(self:oAcc:GIFTALWD)
// 		IF !Empty(self:oAcc:mCLN) .and. (Empty(self:oAcc:incomeacc) .or.(self:oAcc:incomeacc=self:oAcc:accid).or.self:oAcc:expenseacc=self:oAcc:accid.or.self:oAcc:netasset=self:oAcc:accid)
		self:mCLN:=Transform(self:oAcc:mCLN,"")
		IF !Empty(self:oAcc:mCLN) .and. (Empty(self:oAcc:incomeacc) .or.(self:oAcc:incomeacc=self:oAcc:accid).or.self:oAcc:expenseacc=self:oAcc:accid)
			* member:
			self:oDCmGIFTALWD:Disable()
		else
			self:oDCmGIFTALWD:Enable()
		ENDIF
		// Read budget:
		self:FillBudgets()
		self:oDCBalanceDate:SelectedDate:=EndOfMonth(Today()+31)

		// 		IF !IsNil(self:oAcc:persid) .and.!self:oAcc:persid==0  // Member account?
		IF !Empty(self:oAcc:mCLN)
			* No update of description allowed:
			self:lMember:=true
			if Empty(self:oAcc:incomeacc)
				self:oDCmDescription:Disable()
				self:lMemberDep:=false
				self:odcmembertext:textValue :='member account'
			else
				self:lMemberDep:=true
				self:odcmembertext:textValue :='department member'
			endif
		ELSE
			self:lMember:=false
			self:oDCmDescription:SetFocus()
		ENDIF
		IF Empty(self:mNumSave)
			self:mBalitemid:=""
			self:cCurBal:=""
		else 
			self:oDCmBalitemid:textValue:=AllTrim(self:oAcc:NUMBER)+":"+self:oAcc:heading
			self:cCurBal:=self:mBalitemid
		ENDIF
		IF Empty(oAcc:DEPTMNTNBR)
			self:mDepartment:="0:"+sEntity+" "+sLand
			// 	ELSEIF oDep:seek(#DEPID,mDep)
		else
			self:mDepartment:=oAcc:DEPTMNTNBR+":"+oAcc:DESCRIPTN
			self:ShowIPC(oAcc:IPCPROJECT)
			if !Empty(self:oAcc:IPCACCOUNT)
				self:mIPCaccount:=self:oAcc:IPCACCOUNT
			endif
		ENDIF
		self:cCurDep:=self:mDepartment
	ENDIF
	if self:mactive
		self:oDCmActive:TextColor:=Color{COLORBLACK}		
	else
		self:oDCmActive:TextColor:=Color{COLORRED}
	endif		
	self:ShowDefaults()
	self:ShowCurrency()
	IF !Departments
		self:oDCFixedText7:Hide()
		self:oCCDepButton:Hide()
		self:oDCmDepartment:Hide()
	ENDIF
	IF AScan(aMenu,{|x| x[4]=="AccountEdit"})=0
		self:oCCOKButton:Hide()
	ENDIF
	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS EditAccount
	//Put your PreInit additions here 
	self:oAccCnt:=AccountContainer{}
	IF !Empty(uExtra)
		IF IsArray(uExtra)
			IF IsObject(uExtra[2])
				oCaller:=uExtra[2]
			ENDIF
			self:lNew:=uExtra[1]
			// 			IF Len(uExtra) > 2
			// 				self:oAccCnt:=uExtra[3]
			// 				self:nCurNum:= self:oAccCnt:m51_balid
			// 				self:nCurDep:=self:oAccCnt:m51_depid
			// 				self:mNumSave := self:nCurNum
			// 				self:mDep:= self:nCurDep
			// 				self:mAccId:=self:oAccCnt:accid
			// 			ENDIF

		ELSE
			self:lNew:=uExtra
		ENDIF
	ENDIF
	self:FillProprst()
	RETURN nil
ACCESS PropBox() CLASS EditAccount
RETURN SELF:FieldGet(#PropBox)

ASSIGN PropBox(uValue) CLASS EditAccount
SELF:FieldPut(#PropBox, uValue)
RETURN uValue

ACCESS PropValueCombo() CLASS EditAccount
RETURN SELF:FieldGet(#PropValueCombo)

ASSIGN PropValueCombo(uValue) CLASS EditAccount
SELF:FieldPut(#PropValueCombo, uValue)
RETURN uValue

method PropValueShow(PropId as int, cValue as string) as void pascal class EditAccount
	local i as int
	i:=AScan(pers_propextra,{|x|x[2]= PropId}) 
	if i> 0
		if pers_propextra[i,3]=2  //dropdown
			self:oDCPropValueCombo:Show()
			self:oDCPropValueSingle:Hide()
			self:oDCPropValueCombo:FillUsing(Split(pers_propextra[i,4],","))
			self:oDCPropValueCombo:Value:=AllTrim(cValue)
		elseif pers_propextra[i,3]=0  //textbox
			self:oDCPropValueCombo:Hide()
			self:oDCPropValueSingle:Show()
			self:oDCPropValueSingle:Value:=cValue
		endif 
		self:oDCValueText:TextValue:="Change value of "+AllTrim(pers_propextra[i,1])							
	endif
	return
ACCESS PropValueSingle() CLASS EditAccount
RETURN SELF:FieldGet(#PropValueSingle)

ASSIGN PropValueSingle(uValue) CLASS EditAccount
SELF:FieldPut(#PropValueSingle, uValue)
RETURN uValue

Method ShowCurrency() class EditAccount
// local oAcc:=self:Server as Account
if self:oDCmMultCurr:Checked
	self:oDCCurrText:Hide()
	self:oDCmCurrency:Hide()
	self:oDCmReevaluate:Hide()
else
	self:oDCCurrText:Show()
	self:oDCmCurrency:Show()
	if self:oDCmCurrency:Value==sCurr
		self:oDCmReevaluate:Hide()
	else
		if self:mSoort=="PA" .or. self:mSoort=="AK"
			self:oDCmReevaluate:Show() 
			if self:oDCmReevaluate:Checked
				self:oDCmGainLossacc:Show()
				self:oCCGLAccButton:Show()
				self:oDCGainLossText:Show()
			else
				self:oDCmGainLossacc:Hide()
				self:oCCGLAccButton:Hide()
				self:oDCGainLossText:Hide()
			endif				
		else
			self:oDCmReevaluate:Hide()
		endif
	endif
endif
		
Method ShowDefaults() class EditAccount
// HO:homefront; WO:Wycliffe Office;GI: general gift admin; GE: general accounting; WA: wycliffe area
if ADMIN="GE" .or. ADMIN="WA"
	self:oDCmGIFTALWD:Hide()
	self:mGIFTALWD:=false
endif
if self:mGIFTALWD
	self:oDCDefaultBox:Show()
	self:oDCSC_CLC:Show()
	self:oDCmCod1:Show()
	self:oDCmCod2:Show()
	self:oDCmCod3:Show()
	self:oDCSC_ABP:Hide()
	self:ODCmsubscriptionprice:Hide() 
else
	self:oDCDefaultBox:Hide()
	self:oDCSC_CLC:Hide()
	self:oDCmCod1:Hide()
	self:oDCmCod2:Hide()
	self:oDCmCod3:Hide()
	self:oDCSC_ABP:Show()
	self:ODCmsubscriptionprice:Show() 
endif 

if Len(self:aProp)>0 .and.self:mGIFTALWD
	self:oDCPropBox:Show()
	self:oDCXTRText:Show()
	self:oDCValueText:Show()
	self:oDCPropBox:CurrentItemNo:=1
	self:PropValueShow(int(_cast,self:oDCPropBox:VALUE),SubStr(self:oDCPropBox:CurrentItem,30))
else
	self:oDCPropBox:Hide()
	self:oDCXTRText:Hide()
	self:oDCValueText:Hide()
	self:oDCPropValueCombo:Hide()
	self:oDCPropValueSingle:Hide()		
endif
method ShowIPC(IPCProj) class EditAccount
if !Empty(IPCProj) .and. (self:mSoort=INCOME .or. self:mSoort=expense)
	self:oDCIPCText:Show()
	self:oDCmIPCaccount:Show()
	self:oDCmIPCaccount:FillUsing(self:FillIPC())
	if self:mIPCaccount="0" .or.IsNil(self:mIPCaccount)
		self:oDCmIPCaccount:CurrentItemNo:=1
	endif
else
	self:oDCIPCText:Hide()
	self:oDCmIPCaccount:Hide() 
	self:oDCmIPCaccount:Value:=0
endif

METHOD StateExtra() CLASS EditAccount
local oBal,oDep as SQLSelect
	IF !lImport
		RETURN
	ENDIF
	self:mNumSave:=AllTrim(self:mBalitemid)
	oBal:=SQLSelect{"select heading,balitemid from balanceitem where number='"+mNumSave+"'",oConn}
	IF oBal:reccount>0
			self:oDCmBalitemid:textValue :=AllTrim(oBal:NUMBER)+":"+oBal:heading
			self:cCurBal:=self:mBalitemid
			self:mNumSave:=oBal:balitemid
		ELSE
			self:mBalitemid:=""
			self:mNumSave:=""
			self:cCurBal:=""
	ENDIF
	self:mDep:=AllTrim(self:mDepartment)
	IF Empty(self:mDep)
		self:mDepartment:="0:"+sEntity+" "+sLand
	ELSE
		oDep:=SQLSelect{"select deptmntnbr,descriptn from department where deptmntnbr='"+self:mDep+"'",oConn}  
		IF oDep:reccount>0
			self:mDepartment:=AllTrim(oDep:DEPTMNTNBR)+":"+oDep:DESCRIPTN
		ELSE
			self:mDep:=""
			self:mDepartment:="0:"+sEntity+" "+sLand
		ENDIF
	ENDIF
	self:cCurDep:=self:mDepartment
	self:oDCmDepartment:textValue:=self:cCurDep
   self:mCLN:=""

RETURN
	
STATIC DEFINE EDITACCOUNT_BALANCEDATE := 115 
STATIC DEFINE EDITACCOUNT_BALBUTTON := 109 
STATIC DEFINE EDITACCOUNT_BALYEARS := 127 
STATIC DEFINE EDITACCOUNT_BUDGETGRANULARITY := 159 
STATIC DEFINE EDITACCOUNT_CANCELBUTTON := 152 
STATIC DEFINE EDITACCOUNT_CURRTEXT := 169 
STATIC DEFINE EDITACCOUNT_DEFAULTBOX := 160 
STATIC DEFINE EDITACCOUNT_DEPBUTTON := 111 
STATIC DEFINE EDITACCOUNT_FIXEDTEXT29 := 178 
STATIC DEFINE EDITACCOUNT_FIXEDTEXT6 := 119 
STATIC DEFINE EDITACCOUNT_FIXEDTEXT7 := 125 
STATIC DEFINE EDITACCOUNT_FIXEDTEXT8 := 128 
STATIC DEFINE EDITACCOUNT_FIXEDTEXT9 := 132 
STATIC DEFINE EDITACCOUNT_GAINLOSSTEXT := 121 
STATIC DEFINE EDITACCOUNT_GLACCBUTTON := 123 
STATIC DEFINE EDITACCOUNT_GROUPBOX1 := 120 
STATIC DEFINE EDITACCOUNT_GROUPBOX2 := 124 
STATIC DEFINE EDITACCOUNT_GROUPBOX3 := 126 
STATIC DEFINE EDITACCOUNT_GROUPBOX4 := 170 
STATIC DEFINE EDITACCOUNT_IPCTEXT := 174 
STATIC DEFINE EDITACCOUNT_MACCNUMBER := 105 
STATIC DEFINE EDITACCOUNT_MACTIVE := 176 
STATIC DEFINE EDITACCOUNT_MBALANCE := 130 
STATIC DEFINE EDITACCOUNT_MBALANCEF := 172 
STATIC DEFINE EDITACCOUNT_MBALITEMID := 108 
STATIC DEFINE EDITACCOUNT_MBUD1 := 135 
STATIC DEFINE EDITACCOUNT_MBUD10 := 144 
STATIC DEFINE EDITACCOUNT_MBUD11 := 145 
STATIC DEFINE EDITACCOUNT_MBUD12 := 146 
STATIC DEFINE EDITACCOUNT_MBUD2 := 136 
STATIC DEFINE EDITACCOUNT_MBUD3 := 137 
STATIC DEFINE EDITACCOUNT_MBUD4 := 138 
STATIC DEFINE EDITACCOUNT_MBUD5 := 139 
STATIC DEFINE EDITACCOUNT_MBUD6 := 140 
STATIC DEFINE EDITACCOUNT_MBUD7 := 141 
STATIC DEFINE EDITACCOUNT_MBUD8 := 142 
STATIC DEFINE EDITACCOUNT_MBUD9 := 143 
STATIC DEFINE EDITACCOUNT_MCOD1 := 163 
STATIC DEFINE EDITACCOUNT_MCOD2 := 162 
STATIC DEFINE EDITACCOUNT_MCOD3 := 161 
STATIC DEFINE EDITACCOUNT_MCURRENCY := 117 
STATIC DEFINE EDITACCOUNT_MDEPARTMENT := 110 
STATIC DEFINE EDITACCOUNT_MDESCRIPTION := 107 
STATIC DEFINE EDITACCOUNT_MEMBERTEXT := 177 
STATIC DEFINE EDITACCOUNT_MGAINLOSSACC := 122 
STATIC DEFINE EDITACCOUNT_MGIFTALWD := 106 
STATIC DEFINE EDITACCOUNT_MGLACCOUNT := 120 
STATIC DEFINE EDITACCOUNT_MIPCACCOUNT := 114 
STATIC DEFINE EDITACCOUNT_MMULTCURR := 116 
STATIC DEFINE EDITACCOUNT_MNUM := 108 
STATIC DEFINE EDITACCOUNT_MOMS := 107 
STATIC DEFINE EDITACCOUNT_MQTYMAILING := 112 
STATIC DEFINE EDITACCOUNT_MREEVALUATE := 118 
STATIC DEFINE EDITACCOUNT_MREIMB := 175 
STATIC DEFINE EDITACCOUNT_MSUBSCRIPTIONPRICE := 113 
STATIC DEFINE EDITACCOUNT_OKBUTTON := 151 
STATIC DEFINE EDITACCOUNT_PROPBOX := 167 
STATIC DEFINE EDITACCOUNT_PROPVALUECOMBO := 166 
STATIC DEFINE EDITACCOUNT_PROPVALUESINGLE := 168 
STATIC DEFINE EDITACCOUNT_RADIOBUTTONMONTH := 131 
STATIC DEFINE EDITACCOUNT_RADIOBUTTONYEAR := 129 
STATIC DEFINE EDITACCOUNT_SC_ABP := 104 
STATIC DEFINE EDITACCOUNT_SC_CLC := 103 
STATIC DEFINE EDITACCOUNT_SC_NUM := 102 
STATIC DEFINE EDITACCOUNT_SC_OMS := 101 
STATIC DEFINE EDITACCOUNT_SC_REK := 100 
STATIC DEFINE EDITACCOUNT_TEXTBUD1 := 133 
STATIC DEFINE EDITACCOUNT_TEXTBUD10 := 155 
STATIC DEFINE EDITACCOUNT_TEXTBUD11 := 154 
STATIC DEFINE EDITACCOUNT_TEXTBUD12 := 153 
STATIC DEFINE EDITACCOUNT_TEXTBUD2 := 134 
STATIC DEFINE EDITACCOUNT_TEXTBUD3 := 147 
STATIC DEFINE EDITACCOUNT_TEXTBUD4 := 148 
STATIC DEFINE EDITACCOUNT_TEXTBUD5 := 150 
STATIC DEFINE EDITACCOUNT_TEXTBUD6 := 149 
STATIC DEFINE EDITACCOUNT_TEXTBUD7 := 158 
STATIC DEFINE EDITACCOUNT_TEXTBUD8 := 157 
STATIC DEFINE EDITACCOUNT_TEXTBUD9 := 156 
STATIC DEFINE EDITACCOUNT_TEXTFORGNCUR := 173 
STATIC DEFINE EDITACCOUNT_TEXTSYSCUR := 171 
STATIC DEFINE EDITACCOUNT_VALUETEXT := 165 
STATIC DEFINE EDITACCOUNT_XTRTEXT := 164 
