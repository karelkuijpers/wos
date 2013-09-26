RESOURCE EditEmployeeWindow DIALOGEX  23, 33, 410, 247
STYLE	WS_CHILD|WS_BORDER
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", EDITEMPLOYEEWINDOW_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 84, 11, 99, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITEMPLOYEEWINDOW_PERSONBUTTON, "Button", WS_CHILD, 180, 11, 13, 12
	CONTROL	"", EDITEMPLOYEEWINDOW_MTYPE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 84, 29, 112, 72
	CONTROL	"Allowed menu functions", EDITEMPLOYEEWINDOW_SUBSET, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_NOTIFY|WS_CHILD|WS_BORDER|WS_VSCROLL, 212, 14, 125, 133, WS_EX_CLIENTEDGE
	CONTROL	"User Id:", EDITEMPLOYEEWINDOW_THEFIXEDTEXT2, "Static", WS_CHILD, 16, 90, 44, 12
	CONTROL	"Login", EDITEMPLOYEEWINDOW_THEGROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 77, 176, 70
	CONTROL	"Logon Name:", EDITEMPLOYEEWINDOW_MLOGON_NAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 84, 88, 88, 12
	CONTROL	"Password:", EDITEMPLOYEEWINDOW_THEFIXEDTEXT1, "Static", WS_CHILD, 16, 108, 44, 13
	CONTROL	"Password:", EDITEMPLOYEEWINDOW_MPASSWORD, "Edit", ES_AUTOHSCROLL|ES_PASSWORD|WS_TABSTOP|WS_CHILD|WS_BORDER, 84, 107, 88, 12
	CONTROL	"Retype Password:", EDITEMPLOYEEWINDOW_THEFIXEDTEXT3, "Static", WS_CHILD, 16, 128, 62, 12
	CONTROL	"Password:", EDITEMPLOYEEWINDOW_MPASSWORD2, "Edit", ES_AUTOHSCROLL|ES_PASSWORD|WS_TABSTOP|WS_CHILD|WS_BORDER, 84, 125, 88, 12
	CONTROL	"OK", EDITEMPLOYEEWINDOW_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 348, 7, 53, 13
	CONTROL	"Cancel", EDITEMPLOYEEWINDOW_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 348, 29, 53, 14
	CONTROL	"Employee Name:", EDITEMPLOYEEWINDOW_FIXEDTEXT3, "Static", WS_CHILD, 8, 11, 56, 12
	CONTROL	"Role:", EDITEMPLOYEEWINDOW_FIXEDTEXT4, "Static", WS_CHILD, 8, 29, 53, 12
	CONTROL	"Permission for:", EDITEMPLOYEEWINDOW_FIXEDTEXT5, "Static", WS_CHILD, 212, 3, 129, 13
	CONTROL	"v", EDITEMPLOYEEWINDOW_DEPBUTTON, "Button", WS_CHILD, 184, 51, 13, 13
	CONTROL	"Allowed departments:", EDITEMPLOYEEWINDOW_ALLWDDEPTXT, "Static", WS_CHILD, 8, 51, 71, 13
	CONTROL	"", EDITEMPLOYEEWINDOW_MDEPARTMENT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 84, 51, 100, 13, WS_EX_CLIENTEDGE
	CONTROL	"Allowed accounts from other departments:", EDITEMPLOYEEWINDOW_ALWDACC, "SysListView32", LVS_REPORT|LVS_SINGLESEL|LVS_SHOWSELALWAYS|LVS_SORTASCENDING|LVS_EDITLABELS|WS_CHILD|WS_BORDER, 8, 166, 328, 74
	CONTROL	"Allowed accounts from other departments:", EDITEMPLOYEEWINDOW_TEXTALWDACC, "Static", WS_CHILD, 8, 153, 143, 12
	CONTROL	"Add", EDITEMPLOYEEWINDOW_ADDBUTTON, "Button", WS_TABSTOP|WS_CHILD, 344, 169, 53, 13
	CONTROL	"Remove", EDITEMPLOYEEWINDOW_REMOVEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 344, 217, 53, 13
END

CLASS EditEmployeeWindow INHERIT DataWindowExtra 

	PROTECT oDBMLOGON_NAME as DataColumn
	PROTECT oDCmPerson AS SINGLELINEEDIT
	PROTECT oCCPersonButton AS PUSHBUTTON
	PROTECT oDCmTYPE AS COMBOBOX
	PROTECT oDCSubSet AS LISTBOX
	PROTECT oDCtheFixedText2 AS FIXEDTEXT
	PROTECT oDCtheGroupBox1 AS GROUPBOX
	PROTECT oDCmLOGON_NAME AS SINGLELINEEDIT
	PROTECT oDCtheFixedText1 AS FIXEDTEXT
	PROTECT oDCmPASSWORD AS SINGLELINEEDIT
	PROTECT oDCtheFixedText3 AS FIXEDTEXT
	PROTECT oDCmPASSWORD2 AS SINGLELINEEDIT
	PROTECT oCCOkButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oCCDepButton AS PUSHBUTTON
	PROTECT oDCAllwdDepTxt AS FIXEDTEXT
	PROTECT oDCmDepartment AS SINGLELINEEDIT
	PROTECT oDCAlwdAcc AS LISTVIEW
	PROTECT oDCTextAlwdAcc AS FIXEDTEXT
	PROTECT oCCAddButton AS PUSHBUTTON
	PROTECT oCCRemoveButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
*  PROTECT lNew AS LOGIC
	INSTANCE mPerson
	INSTANCE mTYPE
	INSTANCE SubSet
	INSTANCE mLOGON_NAME
	INSTANCE mPASSWORD
	INSTANCE mPASSWORD2
	instance mDepartment
  PROTECT lOwnServer as LOGIC
  PROTECT lCurRec AS INT
  PROTECT cOrigType as STRING 
  protect cLoginNameOrg as string
	PROTECT mCln, mCLNOrg as STRING
	PROTECT cMemberName as STRING 
	PROTECT cCurDep as STRING
  	PROTECT WhoFrom as STRING
	protect PasswordOrg
	protect mEmpID as string 
	protect aAcAlwd:={} as array
	protect oCaller as EmployeeBrowser 
  	protect mDEPID as string

METHOD AddButton( ) CLASS EditEmployeeWindow
	LOCAL cSelect as STRING
	LOCAL oLVI	as ListViewItem, x as int
	LOCAL aAccExcl:={} as ARRAY
	LOCAL lSuccess as LOGIC
	LOCAL cfilter as string

	// add all existing ass.accounts:
	aAccExcl:={}
	FOR x := 1 upto self:oDCAlwdAcc:ItemCount
		oLVI := self:oDCAlwdAcc:GetNextItem( LV_GNIBYITEM,,,,,x-1 )
		AAdd(aAccExcl,Str(oLVI:GetValue(#Number),-1))
	NEXT x
	cfilter:=MakeFilter(,{"BA","PA","KO","AK"},"B",,true,aAccExcl)
	AccountSelect(self,"","Allowed Accounts",FALSE,cfilter,self:Owner,true)
	

	RETURN NIL
METHOD CancelButton( ) CLASS EditEmployeeWindow
	SELF:EndWindow()
	RETURN
METHOD Close(oEvent) CLASS EditEmployeeWindow
	SUPER:Close(oEvent)
	//Put your changes here
	IF lOwnServer
		IF !SELF:Server==NULL_OBJECT
			IF SELF:Server:used
				SELF:Server:Close()
			ENDIF
		ENDIF
	ENDIF
SELF:Destroy()
	RETURN NIL

METHOD DepButton( ) CLASS EditEmployeeWindow 
	LOCAL cCurValue as STRING
	LOCAL nPntr as int

	cCurValue:=AllTrim(oDCmDepartment:TextValue)
	nPntr:=At(":",cCurValue)
	IF nPntr>1
		cCurValue:=SubStr(cCurValue,1,nPntr-1)
	ENDIF
	(DepartmentExplorer{self:Owner,"Department",WhoFrom,self,cCurValue}):show()
RETURN nil
RETURN NIL
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS EditEmployeeWindow
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	LOCAL cCurValue as USUAL
	LOCAL nPntr as int
	oControl := iif(oEditFocusChangeEvent == null_object, null_object, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus .and.!Empty(AllTrim(oControl:TextValue))
		IF oControl:Name == "MPERSON".and.!AllTrim(oControl:TextValue)==AllTrim(self:cMemberName)
			self:cMemberName:=AllTrim(oControl:TextValue)
			SELF:PersonButton(TRUE)
		elseif oControl:NameSym==#mDepartment .and.!AllTrim(oControl:VALUE)==self:cCurDep
			cCurValue:=AllTrim(oControl:VALUE)
			self:cCurDep:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF self:oDep:FindDep(@cCurValue)
				self:RegDepartment(cCurValue,"")
			ELSE
				self:DepButton()
			ENDIF
		ENDIF

		
	ENDIF
	RETURN nil
	
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditEmployeeWindow 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditEmployeeWindow",_GetInst()},iCtlID)

oDCmPerson := SingleLineEdit{SELF,ResourceID{EDITEMPLOYEEWINDOW_MPERSON,_GetInst()}}
oDCmPerson:HyperLabel := HyperLabel{#mPerson,NULL_STRING,"The person, who is the employee","HELP_CLN"}
oDCmPerson:FocusSelect := FSEL_HOME

oCCPersonButton := PushButton{SELF,ResourceID{EDITEMPLOYEEWINDOW_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v","Browse in persons",NULL_STRING}
oCCPersonButton:TooltipText := "Browse in Persons"

oDCmTYPE := combobox{SELF,ResourceID{EDITEMPLOYEEWINDOW_MTYPE,_GetInst()}}
oDCmTYPE:HyperLabel := HyperLabel{#mTYPE,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmTYPE:FillUsing(USRTypes)

oDCSubSet := ListBox{SELF,ResourceID{EDITEMPLOYEEWINDOW_SUBSET,_GetInst()}}
oDCSubSet:TooltipText := "Select subset of possible menu items"
oDCSubSet:HyperLabel := HyperLabel{#SubSet,"Allowed menu functions",NULL_STRING,NULL_STRING}

oDCtheFixedText2 := FixedText{SELF,ResourceID{EDITEMPLOYEEWINDOW_THEFIXEDTEXT2,_GetInst()}}
oDCtheFixedText2:HyperLabel := HyperLabel{#theFixedText2,"User Id:",NULL_STRING,NULL_STRING}

oDCtheGroupBox1 := GroupBox{SELF,ResourceID{EDITEMPLOYEEWINDOW_THEGROUPBOX1,_GetInst()}}
oDCtheGroupBox1:HyperLabel := HyperLabel{#theGroupBox1,"Login",NULL_STRING,NULL_STRING}

oDCmLOGON_NAME := SingleLineEdit{SELF,ResourceID{EDITEMPLOYEEWINDOW_MLOGON_NAME,_GetInst()}}
oDCmLOGON_NAME:HyperLabel := HyperLabel{#mLOGON_NAME,"Logon Name:",NULL_STRING,"Employee Controls"}
oDCmLOGON_NAME:Picture := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

oDCtheFixedText1 := FixedText{SELF,ResourceID{EDITEMPLOYEEWINDOW_THEFIXEDTEXT1,_GetInst()}}
oDCtheFixedText1:HyperLabel := HyperLabel{#theFixedText1,"Password:",NULL_STRING,NULL_STRING}

oDCmPASSWORD := SingleLineEdit{SELF,ResourceID{EDITEMPLOYEEWINDOW_MPASSWORD,_GetInst()}}
oDCmPASSWORD:HyperLabel := HyperLabel{#mPASSWORD,"Password:",NULL_STRING,"Employee Controls"}
oDCmPASSWORD:OverWrite := OVERWRITE_ALWAYS

oDCtheFixedText3 := FixedText{SELF,ResourceID{EDITEMPLOYEEWINDOW_THEFIXEDTEXT3,_GetInst()}}
oDCtheFixedText3:HyperLabel := HyperLabel{#theFixedText3,"Retype Password:",NULL_STRING,NULL_STRING}

oDCmPASSWORD2 := SingleLineEdit{SELF,ResourceID{EDITEMPLOYEEWINDOW_MPASSWORD2,_GetInst()}}
oDCmPASSWORD2:HyperLabel := HyperLabel{#mPASSWORD2,"Password:",NULL_STRING,"Employee Controls"}
oDCmPASSWORD2:OverWrite := OVERWRITE_ALWAYS

oCCOkButton := PushButton{SELF,ResourceID{EDITEMPLOYEEWINDOW_OKBUTTON,_GetInst()}}
oCCOkButton:HyperLabel := HyperLabel{#OkButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITEMPLOYEEWINDOW_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{EDITEMPLOYEEWINDOW_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Employee Name:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{EDITEMPLOYEEWINDOW_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Role:",NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{EDITEMPLOYEEWINDOW_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Permission for:",NULL_STRING,NULL_STRING}

oCCDepButton := PushButton{SELF,ResourceID{EDITEMPLOYEEWINDOW_DEPBUTTON,_GetInst()}}
oCCDepButton:HyperLabel := HyperLabel{#DepButton,"v","Browse in Departments",NULL_STRING}
oCCDepButton:TooltipText := "Browse in Departments"

oDCAllwdDepTxt := FixedText{SELF,ResourceID{EDITEMPLOYEEWINDOW_ALLWDDEPTXT,_GetInst()}}
oDCAllwdDepTxt:HyperLabel := HyperLabel{#AllwdDepTxt,"Allowed departments:",NULL_STRING,NULL_STRING}

oDCmDepartment := SingleLineEdit{SELF,ResourceID{EDITEMPLOYEEWINDOW_MDEPARTMENT,_GetInst()}}
oDCmDepartment:HyperLabel := HyperLabel{#mDepartment,NULL_STRING,"From Who is it: Department",NULL_STRING}
oDCmDepartment:TooltipText := "Top of allowed department hierarchy"

oDCAlwdAcc := ListView{SELF,ResourceID{EDITEMPLOYEEWINDOW_ALWDACC,_GetInst()}}
oDCAlwdAcc:HyperLabel := HyperLabel{#AlwdAcc,"Allowed accounts from other departments:",NULL_STRING,NULL_STRING}

oDCTextAlwdAcc := FixedText{SELF,ResourceID{EDITEMPLOYEEWINDOW_TEXTALWDACC,_GetInst()}}
oDCTextAlwdAcc:HyperLabel := HyperLabel{#TextAlwdAcc,"Allowed accounts from other departments:",NULL_STRING,NULL_STRING}

oCCAddButton := PushButton{SELF,ResourceID{EDITEMPLOYEEWINDOW_ADDBUTTON,_GetInst()}}
oCCAddButton:HyperLabel := HyperLabel{#AddButton,"Add",NULL_STRING,NULL_STRING}

oCCRemoveButton := PushButton{SELF,ResourceID{EDITEMPLOYEEWINDOW_REMOVEBUTTON,_GetInst()}}
oCCRemoveButton:HyperLabel := HyperLabel{#RemoveButton,"Remove",NULL_STRING,NULL_STRING}

SELF:Caption := "Edit Employee"
SELF:HyperLabel := HyperLabel{#EditEmployeeWindow,"Edit Employee","Edit of user-id and password",NULL_STRING}
SELF:Icon := EmployeeIcon{}
SELF:AllowServerClose := False
SELF:PreventAutoLayout := True
SELF:EnableStatusBar(True)

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
self:Browser := DataBrowser{self}

oDBMLOGON_NAME := DataColumn{18}
oDBMLOGON_NAME:Width := 18
oDBMLOGON_NAME:HyperLabel := oDCMLOGON_NAME:HyperLabel 
oDBMLOGON_NAME:Caption := "Logon Name:"
self:Browser:AddColumn(oDBMLOGON_NAME)


SELF:ViewAs(#FormView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListBoxSelect(oControlEvent) CLASS EditEmployeeWindow
	LOCAL oControl as Control
	local i as int
	local cValue as string 
	
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControl:NameSym==#mType
		IF !oDCmTYPE:Value==cOrigType.or. oDCmTYPE:ValueChanged
			* value changed:
			SELF:SelectSubset()
		ENDIF
// 	ELSEIF oControl:NameSym==#SubSet
// 		cValue:=self:oDCSubSet:CurrentItem 
// // 		i:=self:oDCSubSet:CurrentItemNo
// // 		if i>0
// // 			cValue:=self:oDCSubSet:GetItemvalue(i)
// // 			cValue:=self:oDCSubSet:CurrentItem 
// // 		endif
	ENDIF
	
	RETURN NIL
ACCESS mDepartment() CLASS EditEmployeeWindow
RETURN SELF:FieldGet(#mDepartment)

ASSIGN mDepartment(uValue) CLASS EditEmployeeWindow
SELF:FieldPut(#mDepartment, uValue)
RETURN uValue

ACCESS mLOGON_NAME() CLASS EditEmployeeWindow
RETURN SELF:FieldGet(#mLOGON_NAME)

ASSIGN mLOGON_NAME(uValue) CLASS EditEmployeeWindow
SELF:FieldPut(#mLOGON_NAME, uValue)
RETURN uValue

ACCESS mPASSWORD2() CLASS EditEmployeeWindow
RETURN SELF:FieldGet(#mPASSWORD2)

ASSIGN mPASSWORD2(uValue) CLASS EditEmployeeWindow
SELF:FieldPut(#mPASSWORD2, uValue)
RETURN uValue

ACCESS mPASSWORD() CLASS EditEmployeeWindow
RETURN SELF:FieldGet(#mPASSWORD)

ASSIGN mPASSWORD(uValue) CLASS EditEmployeeWindow
SELF:FieldPut(#mPASSWORD, uValue)
RETURN uValue

ACCESS mPerson1() CLASS EditEmployeeWindow
RETURN SELF:FieldGet(#mPerson1)

ASSIGN mPerson1(uValue) CLASS EditEmployeeWindow
SELF:FieldPut(#mPerson1, uValue)
RETURN uValue

ACCESS mPerson() CLASS EditEmployeeWindow
RETURN SELF:FieldGet(#mPerson)

ASSIGN mPerson(uValue) CLASS EditEmployeeWindow
SELF:FieldPut(#mPerson, uValue)
RETURN uValue

ACCESS mTYPE() CLASS EditEmployeeWindow
RETURN SELF:FieldGet(#mTYPE)

ASSIGN mTYPE(uValue) CLASS EditEmployeeWindow
SELF:FieldPut(#mTYPE, uValue)
RETURN uValue

METHOD OkButton( ) CLASS EditEmployeeWindow
	LOCAL oEmp as SQLStatement
	LOCAL oAuthF as SQLStatement
	local oAuth as SQLSelect
	LOCAL i,j,x, nEmpId as int
	LOCAL lDeleted, lCalcCheck as LOGIC
	LOCAL Start as date
	local cLName:=Lower(AllTrim(self:mLogon_name)), cCLN_Encr, mFunc, cUpdate as string
	local aFunc:={} as array 
	local cErrMsg, cAccId as string
	local aAlwdAcc:={} as array //{AccId} 
	local oLVI as ListViewItem 
	local oStmnt as SQLStatement
	local oSql as SQLSelect 
	local aAuth:={} as array

	
	IF Empty(self:mCln)
		ErrorBox{ self, self:oLan:WGet("Fill Employee Name") }:Show()
		RETURN
	ENDIF
	IF Empty(self:mType)
		ErrorBox{ self, self:oLan:WGet("Fill User Type") }:Show()
		RETURN
	ENDIF
	IF Empty(cLName)
		ErrorBox{ self, self:oLan:WGet("Fill UserId") }:Show()
		RETURN
	ENDIF
	IF lNew .or.!Empty(self:oDCmPASSWORD:VALUE)
		if Empty(self:oDCmPASSWORD:VALUE)
			ErrorBox{ self, self:oLan:WGet("Fill Password") }:Show()
			RETURN
		endif
		IF !AllTrim( self:oDCmPASSWORD:TextValue ) ==;
			 AllTrim( self:oDCmPASSWORD2:TextValue )
			ErrorBox{ self, self:oLan:WGet("Passwords do not match")+"!" }:Show()
			RETURN
		ENDIF
		if !CheckPassword( self:oDCmPASSWORD:VALUE,iif(lNew,0,Val(self:mEmpID)))
			return false
		endif
	endif
	* check duplicate loginname:
	IF lNew .or. !cLName==Lower(self:cLoginNameOrg)
		if SqlSelect{"select empid from employee where "+Crypt_Emp(false,"loginname")+'="'+cLName+'"'+iif(self:lNew,""," and empid<>"+self:mEmpID),oConn}:reccount>0 
			ErrorBox{self,self:oLan:WGet("UserId allready exists")+"!"}:Show()
			RETURN
		ENDIF
	ENDIF
	// check duplicate person:
	IF lNew .or. !self:mCln==self:mCLNOrg
		if SQLSelect{"select empid from employee where "+Crypt_Emp(false,"persid")+'="'+self:mCln+'"'+iif(self:lNew,""," and empid<>"+self:mEmpID),oConn}:reccount>0 
			ErrorBox{self,self:oLan:WGet("Person allready an employee")+"!"}:Show()
			RETURN
		ENDIF
		lCalcCheck:=true
	ENDIF
	IF lNew 
		oStmnt:=SQLStatement{"insert employee set loginname='dummy'",oConn}
		oStmnt:Execute()
		if !IsNil(oStmnt:Status)
			(ErrorBox{self,'Add employee Error:'+oStmnt:Status:Description}):Show()
			return false
		endif
		self:mEmpID:= ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
	ENDIF
	nEmpId:=Val(self:mEmpID)
	if !lNew .and. Lower(self:cLoginNameOrg)==Lower(LOGON_EMP_ID)
		LOGON_EMP_ID:=cLName   // adapt current login id
	endif
	cUpdate:="update employee set persid="+Crypt_Emp(true,"persid",self:mCln)    
	oStmnt:=SQLStatement{cUpdate+" where empid='"+AllTrim(self:mEmpID)+"'",oConn}
	oStmnt:Execute()
	if !IsNil(oStmnt:Status)
		(ErrorBox{self,'Update employee: Error:'+oStmnt:Status:Description}):Show() 
		return false 
	endif
	
	cUpdate:="update employee set loginname="+Crypt_Emp(true,"loginname",cLName)
	if lNew .or.(!Empty(mPassword) .and.!HashPassword(nEmpId,self:oDCmPASSWORD:TextValue )== self:PasswordOrg) 
		Start:=(Today()-10000) 
		cUpdate+=", lstupdpw='"+SQLdate(iif(lNew.and.lOwnServer,Today(),Start))+"', password='"+HashPassword(nEmpId,mPassword)+"'"
	ENDIF
	IF lNew.and.lOwnServer
		IF ConI(SqlSelect{"select count(*) as nbr from employee",oConn}:nbr)==1
			self:mType:="A"
			cUpdate+=", type="+ Crypt_Emp(true,"type","A")
			LOGON_EMP_ID := cLName
		ENDIF
	ELSE
		cUpdate+=", type="+Crypt_Emp(true,"type",self:mType)
	ENDIF
	if self:mType=="A"
		cUpdate+=", depid="+Crypt_Emp(true,"depid","")
	else 
		cUpdate+=", depid="+Crypt_Emp(true,"depid",self:WhoFrom)
	endif
	oStmnt:=SQLStatement{cUpdate+" where empid="+self:mEmpID,oConn}
	oStmnt:Execute()
	if !IsNil(oStmnt:Status) 
		LogEvent(self,'Update employee Error:'+oStmnt:Status:Description+CRLF+"empid:"+self:mEmpID+" ; statement:"+oStmnt:SQLString,"LogErrors")
		(ErrorBox{self,'Update employee Error:'+oStmnt:Status:Description}):Show() 
		return false 
	endif
	* Add AuthFunc:
	*	Save selected subset:
	oAuthF:=SQLStatement{"",oConn}
		if Posting .and.!mType=="A"
			// correct batch posting:
			i:=self:oDCSubSet:FirstSelected()
			do while i > 0
				j:=self:oDCSubSet:GetItemvalue(i)
				if AScan({36,106,104,105},j) >0
					AAdd(aFunc,{i,j})
				endif
				i:=self:oDCSubSet:NextSelected()
			enddo
			if Len(aFunc) > 1
				if (j:=AScan(aFunc,{|x|x[2]=105}))>0
					if mType="M"
						for i:=1 to Len(aFunc)
							if j#i
								self:oDCSubSet:DeselectItem(aFunc[i,1]) 
								cErrMsg+=self:oDCSubSet:GetItem(aFunc[i,1])+CRLF
							endif
						Next
					else
						self:oDCSubSet:DeselectItem(aFunc[j,1])
						cErrMsg+=self:oDCSubSet:GetItem(aFunc[j,1])+CRLF
					endif
					WarningBox{,self:oLan:WGet("Employee Edit"),cErrMsg+iif(!mType="M".or.Len(aFunc)=2,self:oLan:WGet("is"),self:oLan:WGet("are"))+" "+self:oLan:WGet("removed because of illegal combination with Posting Batch")}:Show()
				endif
			endif
						
		endif 
		// read current authfunc:
		oAuth := SqlSelect{"select cast("+Crypt_Emp(false,"funcname")+" as char) as mfuncname from authfunc where empid="+self:mEmpID+" order by mfuncname",oConn}
		oAuth:GoTop() 
		do while !oAuth:Eof
			AAdd(aAuth,oAuth:mfuncname) 
			oAuth:Skip()
		enddo

		FOR i:= 1 to self:oDCSubSet:ItemCount 
			mFunc:=StrZero(self:oDCSubSet:GetItemvalue(i),3,0) 
			IF !lNew.and.!cOrigType=="A"
// 				if oAuthF:Locate({||oAuthF:EmpId==nEmpId .and.oAuthF:mFUNCNAME==mFunc})
// 				IF oAuthF:Seek(oEmp:EMPID+CryptK(StrZero(self:oDCSubSet:GetItemvalue(i),3)))
				IF !self:oDCSubSet:IsSelected(i) .and. AScan(aAuth,mFunc)>0
					oAuthF:SQLString:="delete from authfunc where empid="+self:mEmpID+" and "+Crypt_Emp(false,"funcname")+"='"+mFunc+"'"
					oAuthF:Execute()
					lDeleted:=true
				ENDIF
			ENDIF
			IF self:oDCSubSet:Isselected(i)
				IF !mType=="A".and.(lNew.or.AScan(aAuth,mFunc)=0)
					oAuthF:SQLString:="insert authfunc set empid="+self:mEmpID+",funcname="+Crypt_Emp(true,"funcname",mFunc,Val(self:mEmpID) )
					oAuthF:Execute()
				ENDIF
			ENDIF
		NEXT
	// Add allowed accounts:
	if !Empty(Val(self:WhoFrom) )
		// read current allowe accounts:
		// loop through specified account:
		FOR x := 1 upto self:oDCAlwdAcc:ItemCount
			oLVI := self:oDCAlwdAcc:GetNextItem( LV_GNIBYITEM,,,,,x-1 ) 
			cAccId:=Str(oLVI:GetValue(#Number),-1)
			if AScan(self:aAcAlwd,cAccId)=0
				oStmnt:SQLString:="insert emplacc set empid="+self:mEmpID+",accid="+cAccId
				oStmnt:Execute()
			endif
			AAdd(aAlwdAcc,cAccId)
		NEXT x 
	endif
	if !Empty(Val(self:mDEPID))
		// loop through stored accounts:
		for i:=1 to Len(self:aAcAlwd) 
			cAccId:=self:aAcAlwd[i]
			if AScan(aAlwdAcc,cAccId)=0
				// delete item:
				oStmnt:SQLString:="delete from emplacc where empid='"+self:mEmpID+"' and accid='"+cAccId+"'"
				oStmnt:Execute()
			endif
		next
	endif
	if lCalcCheck
		SaveCheckDigit()
	endif
	if IsObject(self:oCaller:oSelEmp)
		self:oCaller:oSelEmp:Execute()  // reread
		self:oCaller:GoTop()
	endif


	self:EndWindow()
	
RETURN
METHOD PersonButton( lUnique) CLASS EditEmployeeWindow
	LOCAL cValue := AllTrim(oDCmPerson:TEXTValue ) as STRING 
	local oPersCnt as PersonContainer
	Default(@lUnique,FALSE)
	oPersCnt:=PersonContainer{}
	oPersCnt:persid:=self:mCLN
	
	PersonSelect(self,cValue,lUnique,,"employee",oPersCnt)

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditEmployeeWindow
	//Put your PostInit additions here
	LOCAL aMyItems, aAllItems as ARRAY 
	LOCAL i,j, jSt:=1 as int
	local oEmp as SQLSelect
	LOCAL oColREk, oColName as ListViewColumn
	LOCAL oItem as ListViewItem 
	local oSel as SQLSelect
	local cEmpStmnt as string
	self:SetTexts()
	
	mDepartment:="0:"+sEntity+" "+sLand 
	self:oDCmDepartment:TextValue:=mDepartment
	cCurDep:=mDepartment
	WhoFrom:="0"
	IF !Departments
		self:oDCAllwdDepTxt:Hide()
		oCCDepButton:Hide()
		oDCmDepartment:Hide()
	ENDIF

	* Fill listbox:
	aAllItems:=self:GetMenuItems()
	oDCSubSet:FillUsing(aAllItems)
	self:oDCmPASSWORD:Value  := ""
	self:oDCmPASSWORD2:Value  := ""
	IF lNew
		self:mLogon_name := ""
		self:mType		:= "P"
		IF self:Server:Eof .and. self:Server:Bof  // First User?
			self:mType:="A"
			oDCmTYPE:Disable()
		ENDIF
		self:SelectSubset() 
		self:mEmpID:=''
	ELSE
		cEmpStmnt:='select e.empid,cast('+Crypt_Emp(false,"e.persid");
		+' as char) as mcln,'+SQLFullName()+' as memplname,';
		+"cast("+Crypt_Emp(false,"e.loginname")+" as char) as loginname,online,cast(lstlogin as datetime),";
		+"cast("+Crypt_Emp(false,"e.type") +" as char) as type, e.password,cast("+Crypt_Emp(false,"e.depid")+" as char) as depid";
		+' from employee as e left join person as p on (p.persid='+Crypt_Emp(false,"e.persid")+ ") where empid="+self:mEmpID + " order by lastname"

		oEmp:=SQLSelect{cEmpStmnt,oConn} 
		oEmp:Execute()
		if !IsNil(oEmp:Status)
			LogEvent(self,"Error:"+oEmp:ErrInfo:ErrorMessage+"(Statement:"+cEmpStmnt+")","LogErrors")
			return		
		endif
		self:mLogon_name := oEmp:LOGINNAME
		self:cLoginNameOrg := self:mLogon_name 
		// 		PasswordOrg   := AllTrim(Crypt(oEmp:Password,oEmp:EmpId+"er45pofDOIoiijodsoi*)mxcd eDFP456^)_fghj=") )
		PasswordOrg   := oEmp:PASSWORD
		// 		self:oDCmTYPE:Value		:= oEmp:mType
		self:mType:=Transform(oEmp:TYPE,"") 
		if self:mType='M' .and.!posting
			self:mType:='F'
		endif
		self:mCln := Transform(oEmp:mCln,"")
		self:mCLNOrg:=self:mCln 
		mDEPID:=oEmp:DEPID
		self:mPerson := Transform(oEmp:mEMPLNAME,"")
		self:cMemberName := mPerson
		IF AllTrim(self:mLOGON_NAME)==LOGON_EMP_ID .and. self:mTYPE=="A"  // of user him self?
			self:mType:="A"
			oDCmTYPE:Disable()
		ELSE
			IF !self:mType=="A"
				* Select current allowed items:
				aMyItems:=InitMenu(Val(mEmpId),self:mType)
				FOR i:=1 to Len(aMyItems)
					j:=AScan(aAllItems,{|x| x[2]==aMyItems[i,MACCEL]},jSt)
					IF j>0
						jSt:=j+1
						oDCSubSet:SelectItem(j)
					ENDIF
				NEXT
				if !Empty(mDEPID)
					oSel:=SQLSelect{"select deptmntnbr,descriptn from department where depid='"+mDEPID+"'",oConn} 
					if oSel:RecCount=1
						self:oDCmDepartment:TextValue:= oSel:DEPTMNTNBR+": "+ oSel:DESCRIPTN
					endif
					self:WhoFrom:=mDEPID 
				endif
			ENDIF
		ENDIF
	ENDIF
		self:ShowAllwdAcc()
		IF mType=="A"
			oDCSubSet:Hide()
			oDCFixedText5:Hide()
			self:oDCAllwdDepTxt:Hide()
			oCCDepButton:Hide()
			oDCmDepartment:Hide()
		ENDIF
	self:cOrigType	:= self:mType
	// initialize listview with alwd.accounst:
	oColREk:=ListViewColumn{11,"Account#"}
	oColREk:NameSym:=#Number
	oColName:=ListViewColumn{32,"Name"}
	oColName:NameSym:=#Name
	self:oDCAlwdAcc:AddColumn(oColREk)
	self:oDCAlwdAcc:AddColumn(oColName) 
	if !lNew .and.!Empty(mDEPID) 
		oSel:=SQLSelect{"select a.accid,a.accnumber,a.description from account a, emplacc as e where a.accid=e.accid and e.empid="+Str(oEmp:EMPID,-1),oConn}
		oSel:Execute()
		oSel:GoTop()
		do while !oSel:Eof
			oItem:=ListViewItem{}
			oItem:SetText(oSel:ACCNUMBER,#Number)
			oItem:SetValue(oSel:accid,#Number)
			oItem:SetText(oSel:Description,#Name)
			oItem:SetValue(oSel:accid,#Name)
			self:oDCAlwdAcc:AddItem(oItem) 
			AAdd(self:aAcAlwd,Str(oSel:accid,-1))
			oSel:Skip()
		enddo			
	endif
	self:oDCmPerson:SetFocus()

	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS EditEmployeeWindow
	//Put your PreInit additions here
	IF IsNil(oServer)
		lOwnServer:=true
	else
		self:mEmpId:=Str(oServer:EMPID,-1)
	ENDIF 
	IF IsArray(uExtra)
		IF IsLogic(uExtra[1])
			lNew:=uExtra[1]
		ENDIF 
		if Len(uExtra)>1
			self:oCaller:=uExtra[2]
		endif	
	ENDIF

	RETURN NIL
METHOD RemoveButton( ) CLASS EditEmployeeWindow 
	IF Empty(self:oDCAlwdAcc:GetSelectedItem())
 		(ErrorBox{,"Select first an ASsociated account"}):Show()
 	ELSE
		self:oDCAlwdAcc:DeleteItem((self:oDCAlwdAcc:GetSelectedItem()):ItemIndex)
	ENDIF

RETURN NIL
METHOD SelectSubset() CLASS EditEmployeeWindow
	* select subset of menu subitems in listbox Subset
	LOCAL aMyItems, aAllItems AS ARRAY
	LOCAL i,j, jSt:=1 AS INT
	IF oDCmTYPE:Value=="A"
		oDCSubSet:Hide()
		oDCFixedText5:Hide()
		IF Departments
			self:oDCAllwdDepTxt:Hide()
			oCCDepButton:Hide()
			oDCmDepartment:Hide()
		endif
	ELSE
		oDCSubSet:Show()
		oDCFixedText5:show()
		* Select corresponding items:
		aAllItems:=SELF:GetMenuItems()
		oDCSubSet:FillUSING(aAllItems)
		* Select current allowed items:
		aMyItems:=SELF:GetMenuItems(mType)
		FOR i:=1 TO Len(aMyItems)
			j:=AScan(aAllItems,{|x| x[2]==aMyItems[i,2]},jSt)
			IF j>0
				jSt:=j+1
				oDCSubSet:SelectItem(j)
			ENDIF
		NEXT 
		IF Departments
			self:oDCAllwdDepTxt:Show()
			oCCDepButton:Show()
			oDCmDepartment:Show()
		endif
ENDIF
	
RETURN
method ShowAllwdAcc() class EditEmployeeWindow 
if mDepartment="0:"
	self:oDCTextAlwdAcc:Hide()
	self:oDCAlwdAcc:Hide()
	self:oCCAddButton:Hide()
	self:oCCRemoveButton:Hide()
else
	self:oDCTextAlwdAcc:Show()
	self:oDCAlwdAcc:Show()
	self:oCCAddButton:Show()
	self:oCCRemoveButton:Show()
endif
ACCESS SubSet() CLASS EditEmployeeWindow
RETURN SELF:FieldGet(#SubSet)

ASSIGN SubSet(uValue) CLASS EditEmployeeWindow
SELF:FieldPut(#SubSet, uValue)
RETURN uValue

STATIC DEFINE EDITEMPLOYEEWINDOW_ADDBUTTON := 121 
STATIC DEFINE EDITEMPLOYEEWINDOW_ALLWDDEPTXT := 117 
STATIC DEFINE EDITEMPLOYEEWINDOW_ALWDACC := 119 
STATIC DEFINE EDITEMPLOYEEWINDOW_CANCELBUTTON := 112 
STATIC DEFINE EDITEMPLOYEEWINDOW_DEPBUTTON := 116 
STATIC DEFINE EDITEMPLOYEEWINDOW_FIXEDTEXT3 := 113 
STATIC DEFINE EDITEMPLOYEEWINDOW_FIXEDTEXT4 := 114 
STATIC DEFINE EDITEMPLOYEEWINDOW_FIXEDTEXT5 := 115 
STATIC DEFINE EDITEMPLOYEEWINDOW_MDEPARTMENT := 118 
STATIC DEFINE EDITEMPLOYEEWINDOW_MLOGON_NAME := 106 
STATIC DEFINE EDITEMPLOYEEWINDOW_MPASSWORD := 108 
STATIC DEFINE EDITEMPLOYEEWINDOW_MPASSWORD2 := 110 
STATIC DEFINE EDITEMPLOYEEWINDOW_MPERSON := 100 
STATIC DEFINE EDITEMPLOYEEWINDOW_MTYPE := 102 
STATIC DEFINE EDITEMPLOYEEWINDOW_OKBUTTON := 111 
STATIC DEFINE EDITEMPLOYEEWINDOW_PERSONBUTTON := 101 
STATIC DEFINE EDITEMPLOYEEWINDOW_REMOVEBUTTON := 122 
STATIC DEFINE EDITEMPLOYEEWINDOW_SUBSET := 103 
STATIC DEFINE EDITEMPLOYEEWINDOW_TEXTALWDACC := 120 
STATIC DEFINE EDITEMPLOYEEWINDOW_THEFIXEDTEXT1 := 107 
STATIC DEFINE EDITEMPLOYEEWINDOW_THEFIXEDTEXT2 := 104 
STATIC DEFINE EDITEMPLOYEEWINDOW_THEFIXEDTEXT3 := 109 
STATIC DEFINE EDITEMPLOYEEWINDOW_THEGROUPBOX1 := 105 
CLASS employee_INSITEUID INHERIT FIELDSPEC
METHOD Init() CLASS employee_INSITEUID
super:Init(HyperLabel{"INSITEUID","Insiteuid","","employee_INSITEUID"},"C",40,0)

RETURN SELF
CLASS Employee_InsittePW INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Employee_InsittePW
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#InSitePW, "InSitePW", "", "" },  "C", 11, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS employee_LOGINNAME INHERIT FIELDSPEC
METHOD Init() CLASS employee_LOGINNAME
super:Init(HyperLabel{"LOGINNAME","Loginname","","employee_LOGINNAME"},"C",32,0)

RETURN SELF
CLASS employee_LSTLOGIN INHERIT FIELDSPEC
METHOD Init() CLASS employee_LSTLOGIN
super:Init(HyperLabel{"LSTLOGIN","Lstlogin","","employee_LSTLOGIN"},"C",19,0)

RETURN SELF
CLASS EmployeeBrowser INHERIT DataWindowExtra 

	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oSFEmployeeBrowser_DETAIL AS EmployeeBrowser_DETAIL

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  export oSelEmp as SQLSelect 
RESOURCE EmployeeBrowser DIALOGEX  18, 17, 398, 195
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", EMPLOYEEBROWSER_EMPLOYEEBROWSER_DETAIL, "static", WS_CHILD|WS_BORDER, 4, 7, 328, 177
	CONTROL	"&Edit", EMPLOYEEBROWSER_EDITBUTTON, "Button", WS_TABSTOP|WS_CHILD, 340, 7, 53, 12
	CONTROL	"&New", EMPLOYEEBROWSER_NEWBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 340, 58, 53, 12
	CONTROL	"&Delete", EMPLOYEEBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 340, 109, 53, 12
END

METHOD Close( oE ) CLASS EmployeeBrowser
SELF:oSFEmployeeBrowser_DETAIL:Close()
SELF:oSFEmployeeBrowser_DETAIL:Destroy()
SELF:Destroy()
	
	RETURN NIL
METHOD CloseButton CLASS EmployeeBrowser

	SELF:EndWindow()
	
	RETURN SELF
METHOD DeleteButton CLASS EmployeeBrowser 
local oEmp:=self:Server as SQLSelect 
local oStmnt as SQLStatement

	LOCAL oTextBox as TextBox
	
	IF oEmp:EmpId==Val(MYEMPID)
		(ErrorBox{,"You must not delete your own userid"}):Show()
		RETURN
	ENDIF
	
	oTextBox := TextBox{ self, "Delete Record",;
		"Delete User " + oEmp:LOGINNAME + "?" }	
	oTextBox:Type := BUTTONYESNO + BOXICONQUESTIONMARK
	
	IF ( oTextBox:Show() == BOXREPLYYES )
		// delete corresponding authfunc records:
		oStmnt:=SQLStatement{"delete from authfunc where empid='"+Str(oEmp:EmpId,-1)+"'",oConn}
		oStmnt:Execute()
		oStmnt:SQLString:="delete from employee where empid='"+Str(oEmp:EmpId,-1)+"'" 
		oStmnt:Execute()
		
		SaveCheckDigit()
// 		self:oSFEmployeeBrowser_DETAIL:GoTop()  
		self:oSelEmp:Execute()  // reread
		self:GoTop()

	ENDIF

	RETURN
METHOD EditButton CLASS EmployeeBrowser
	
	(EditEmployeeWindow{ self:Owner,, self:Server,{FALSE,self} }):Show()

	RETURN NIL
METHOD FilePrint CLASS EmployeeBrowser
LOCAL oEmp as SQLSelect
LOCAL kopregels as ARRAY
LOCAL nRow as int
LOCAL nPage as int
LOCAL oReport as PrintDialog 
Local cEmpStmnt as string


oReport := PrintDialog{self,oLan:RGet("Employees"),,86}

oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
cEmpStmnt:='select e.empid,'+SQLFullName()+' as fullname,';
	+"cast("+Crypt_Emp(false,"e.loginname")+" as char) as loginname,online,DATE_FORMAT(lstlogin,'%Y%m%d') as lstlogin,";
	+"cast("+Crypt_Emp(false,"e.type") +" as char) as type, cast("+Crypt_Emp(false,"e.depid")+" as char) as depid";
	+' from employee as e, person as p where p.persid='+Crypt_Emp(false,"e.persid")+" order by lastname"

oEmp:=SQLSelect{"",oConn}
oEmp:SQLString:=cEmpStmnt 

oEmp:GoTop()
kopregels := {oLan:RGet('Employees',,"@!"),' ',;
oLan:RGet("Name",25,"!")+" "+oLan:RGet("Logon Id",20,"!")+;
oLan:RGet("User Type",25,"!","C")+oLan:RGet("Date Last Password",18,"!","C"),' '}
nRow := 0
nPage := 0
DO WHILE .not. oEmp:EOF
   oReport:PrintLine(@nRow,@nPage,Pad(oEmp:FULLNAME,25)+" "+Pad(oEmp:LOGINNAME,20)+' '+;
	Pad(TYPEDescr(oEmp:TYPE),25)+"   "+iif(Empty(oEmp:LSTLOGIN),"",DToC(SToD(oEmp:LSTLOGIN))),kopregels)
   oEmp:skip()
ENDDO
oReport:prstart()
oReport:prstop()
RETURN self
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EmployeeBrowser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EmployeeBrowser",_GetInst()},iCtlID)

oCCEditButton := PushButton{SELF,ResourceID{EMPLOYEEBROWSER_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,_chr(38)+"Edit","Edit of a record","File_Edit"}
oCCEditButton:OwnerAlignment := OA_PX

oCCNewButton := PushButton{SELF,ResourceID{EMPLOYEEBROWSER_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,_chr(38)+"New","Create a new user","File_New"}
oCCNewButton:OwnerAlignment := OA_PX

oCCDeleteButton := PushButton{SELF,ResourceID{EMPLOYEEBROWSER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,_chr(38)+"Delete","Remove a user",NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PX

SELF:Caption := "Employees"
SELF:HyperLabel := HyperLabel{#EmployeeBrowser,"Employees",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True
SELF:Menu := WOMenu{}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
SELF:ViewAs(#FormView)

oSFEmployeeBrowser_DETAIL := EmployeeBrowser_DETAIL{SELF,EMPLOYEEBROWSER_EMPLOYEEBROWSER_DETAIL}
oSFEmployeeBrowser_DETAIL:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD NewButton CLASS EmployeeBrowser

	(EditEmployeeWindow{ oMainWindow,, self:Server,{true,self} }):Show()

	RETURN NIL
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EmployeeBrowser
	//Put your PostInit additions here
self:SetTexts()
self:GoTop()
 
	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS EmployeeBrowser
	//Put your PreInit additions here 
	local cEmpStmnt as string
	cEmpStmnt:='select e.empid,'+SQLFullName(2)+' as fullname,';
	+"cast("+Crypt_Emp(false,"e.loginname")+" as char) as loginname,online,cast(lstlogin as char) as lstlogin,cast("+Crypt_Emp(false,"e.type") +" as char) as type"+;
	' from employee as e left join person as p on (p.persid='+Crypt_Emp(false,'e.persid')+") where 1 order by online desc, lastname asc"
	self:oSelEmp:=SqlSelect{cEmpStmnt,oConn}
	self:oSelEmp:Execute()
	RETURN nil 
	

method Refresh() class EmployeeBrowser
self:oSFEmployeeBrowser_DETAIL:Browser:Refresh()
return
STATIC DEFINE EMPLOYEEBROWSER_DELETEBUTTON := 103 
RESOURCE EmployeeBrowser_DETAIL DIALOGEX  21, 19, 325, 164
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

CLASS EmployeeBrowser_DETAIL INHERIT DataWindowExtra 

	PROTECT oDBLOGINNAME as DataColumn
	PROTECT oDBFULLNAME as DataColumn
	PROTECT oDBMTYPE as DataColumn
	PROTECT oDBLSTLOGIN as DataColumn
	PROTECT oDBMONLINE as DataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EmployeeBrowser_DETAIL 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EmployeeBrowser_DETAIL",_GetInst()},iCtlID)

SELF:Caption := ""
SELF:HyperLabel := HyperLabel{#EmployeeBrowser_DETAIL,NULL_STRING,NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:OwnerAlignment := OA_PWIDTH_PHEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBLOGINNAME := DataColumn{employee_LOGINNAME{}}
oDBLOGINNAME:Width := 15
oDBLOGINNAME:HyperLabel := HyperLabel{#LOGINNAME,"Loginname",NULL_STRING,NULL_STRING} 
oDBLOGINNAME:Caption := "Loginname"
self:Browser:AddColumn(oDBLOGINNAME)

oDBFULLNAME := DataColumn{Description{}}
oDBFULLNAME:Width := 21
oDBFULLNAME:HyperLabel := HyperLabel{#fullname,"Employee name",NULL_STRING,NULL_STRING} 
oDBFULLNAME:Caption := "Employee name"
self:Browser:AddColumn(oDBFULLNAME)

oDBMTYPE := DataColumn{Description{}}
oDBMTYPE:Width := 17
oDBMTYPE:HyperLabel := HyperLabel{#mType,"Role",NULL_STRING,NULL_STRING} 
oDBMTYPE:Caption := "Role"
oDBmType:BlockOwner := self:server
oDBmType:Block := {|x| typedescr(x:type)}
self:Browser:AddColumn(oDBMTYPE)

oDBLSTLOGIN := DataColumn{18}
oDBLSTLOGIN:Width := 18
oDBLSTLOGIN:HyperLabel := HyperLabel{#LSTLOGIN,"Last Login",NULL_STRING,NULL_STRING} 
oDBLSTLOGIN:Caption := "Last Login"
self:Browser:AddColumn(oDBLSTLOGIN)

oDBMONLINE := DataColumn{8}
oDBMONLINE:Width := 8
oDBMONLINE:HyperLabel := HyperLabel{#mOnline,"Online?",NULL_STRING,NULL_STRING} 
oDBMONLINE:Caption := "Online?"
oDBmOnline:BlockOwner := self:server
oDBmOnline:Block := {|x|iif(coni(x:Online)=1,'  X  ','')}
self:Browser:AddColumn(oDBMONLINE)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EmployeeBrowser_DETAIL
	//Put your PostInit additions here
self:SetTexts()
	self:Browser:SetStandardStyle(gbsReadOnly)
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS EmployeeBrowser_DETAIL
	//Put your PreInit additions here 
	if Empty(oWindow:Server) 
	 	oWindow:Use(oWindow:oSelEmp)
	endif

	RETURN NIL
STATIC DEFINE EMPLOYEEBROWSER_DETAIL_FULLNAME := 101 
STATIC DEFINE EMPLOYEEBROWSER_DETAIL_LOGINNAME := 100 
STATIC DEFINE EMPLOYEEBROWSER_DETAIL_LSTLOGIN := 103 
STATIC DEFINE EMPLOYEEBROWSER_DETAIL_MONLINE := 104 
STATIC DEFINE EMPLOYEEBROWSER_DETAIL_MTYPE := 102 
STATIC DEFINE EMPLOYEEBROWSER_EDITBUTTON := 101 
STATIC DEFINE EMPLOYEEBROWSER_EMPLOYEEBROWSER_DETAIL := 100 
STATIC DEFINE EMPLOYEEBROWSER_EMPLOYEESUBFORM := 102 
STATIC DEFINE EMPLOYEEBROWSER_NEWBUTTON := 102 
STATIC DEFINE EMPLOYEEBROWSER_SEARCHSLE := 101 
STATIC DEFINE EMPLOYEEBROWSER_THEFIXEDTEXT1 := 100 
STATIC DEFINE EMPLOYEESUBFORM_ADDRESS := 106 
STATIC DEFINE EMPLOYEESUBFORM_CITY := 108 
STATIC DEFINE EMPLOYEESUBFORM_EMP_ID := 100 
STATIC DEFINE EMPLOYEESUBFORM_FIRST_NAME_ := 102 
STATIC DEFINE EMPLOYEESUBFORM_LAST_NAME := 104 
STATIC DEFINE EMPLOYEESUBFORM_LOGON_NAME := 116 
STATIC DEFINE EMPLOYEESUBFORM_PASSWORD := 118 
STATIC DEFINE EMPLOYEESUBFORM_PHONE := 114 
STATIC DEFINE EMPLOYEESUBFORM_SC_ADDRESS := 107 
STATIC DEFINE EMPLOYEESUBFORM_SC_CITY := 109 
STATIC DEFINE EMPLOYEESUBFORM_SC_EMP_ID := 101 
STATIC DEFINE EMPLOYEESUBFORM_SC_FIRST_NAME := 103 
STATIC DEFINE EMPLOYEESUBFORM_SC_LAST_NAME := 105 
STATIC DEFINE EMPLOYEESUBFORM_SC_LOGON_NAME := 117 
STATIC DEFINE EMPLOYEESUBFORM_SC_PASSWORD := 119 
STATIC DEFINE EMPLOYEESUBFORM_SC_PHONE := 115 
STATIC DEFINE EMPLOYEESUBFORM_SC_STATE_ID := 111 
STATIC DEFINE EMPLOYEESUBFORM_SC_ZIP := 113 
STATIC DEFINE EMPLOYEESUBFORM_STATE_ID := 110 
STATIC DEFINE EMPLOYEESUBFORM_ZIP := 112 
CLASS FirstUser INHERIT DataDialogMine 

	PROTECT oDCtheFixedText2 AS FIXEDTEXT
	PROTECT oDCtheFixedText1 AS FIXEDTEXT
	PROTECT oDCtheFixedText3 AS FIXEDTEXT
	PROTECT oDCSC_NA1 AS FIXEDTEXT
	PROTECT oDCSC_HISN AS FIXEDTEXT
	PROTECT oDCSC_VRN AS FIXEDTEXT
	PROTECT oDCSC_NA2 AS FIXEDTEXT
	PROTECT oDCSC_AD1 AS FIXEDTEXT
	PROTECT oDCSC_POS AS FIXEDTEXT
	PROTECT oDCSC_PLA AS FIXEDTEXT
	PROTECT oDCmNA1 AS SINGLELINEEDIT
	PROTECT oDCmHISN AS SINGLELINEEDIT
	PROTECT oDCmVRN AS SINGLELINEEDIT
	PROTECT oDCmNA2 AS SINGLELINEEDIT
	PROTECT oDCmAD1 AS SINGLELINEEDIT
	PROTECT oDCmPOS AS SINGLELINEEDIT
	PROTECT oDCmPLA AS SINGLELINEEDIT
	PROTECT oDCtheGroupBox1 AS GROUPBOX
	PROTECT oDCmLOGON_NAME AS SINGLELINEEDIT
	PROTECT oDCmPASSWORD AS SINGLELINEEDIT
	PROTECT oDCmPASSWORD2 AS SINGLELINEEDIT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCmAdminType AS COMBOBOX
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCmNA1mbr AS SINGLELINEEDIT
	PROTECT oDCmHISNmbr AS SINGLELINEEDIT
	PROTECT oDCmVRNmbr AS SINGLELINEEDIT
	PROTECT oDCmNA2mbr AS SINGLELINEEDIT
	PROTECT oDCmBANKNUMMER AS SINGLELINEEDIT
	PROTECT oDCmTelebankng AS CHECKBOX
	PROTECT oDCSC_NA2mbr AS FIXEDTEXT
	PROTECT oDCSC_HISNmbr AS FIXEDTEXT
	PROTECT oDCSC_VRNmbr AS FIXEDTEXT
	PROTECT oDCSC_NA1mbr AS FIXEDTEXT
	PROTECT oDCSC_BANKNUMMER AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCMemberBox AS GROUPBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  PROTECT cOrigType as STRING
// 	PROTECT CountryCode, LocaleCode AS STRING
// 	PROTECT cEntityCode, cEntityName, cCurrencyCode, cCurrencyName,cUser as STRING  
	Protect cUser as string


RESOURCE FirstUser DIALOGEX  36, 35, 425, 254
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"User Id:", FIRSTUSER_THEFIXEDTEXT2, "Static", WS_CHILD, 16, 78, 44, 12
	CONTROL	"Password:", FIRSTUSER_THEFIXEDTEXT1, "Static", WS_CHILD, 16, 96, 44, 12
	CONTROL	"Retype Password:", FIRSTUSER_THEFIXEDTEXT3, "Static", WS_CHILD, 16, 116, 62, 12
	CONTROL	"Lastname:", FIRSTUSER_SC_NA1, "Static", WS_CHILD, 14, 13, 35, 12
	CONTROL	"Prefix:", FIRSTUSER_SC_HISN, "Static", WS_CHILD, 219, 13, 43, 12
	CONTROL	"First name:", FIRSTUSER_SC_VRN, "Static", WS_CHILD, 15, 27, 36, 12
	CONTROL	"Initials:", FIRSTUSER_SC_NA2, "Static", WS_CHILD, 218, 27, 24, 12
	CONTROL	"Street+number:", FIRSTUSER_SC_AD1, "Static", WS_CHILD, 15, 41, 48, 12
	CONTROL	"Zip code:", FIRSTUSER_SC_POS, "Static", WS_CHILD, 218, 41, 32, 12
	CONTROL	"City:", FIRSTUSER_SC_PLA, "Static", WS_CHILD, 300, 40, 15, 12
	CONTROL	"", FIRSTUSER_MNA1, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 69, 13, 143, 12
	CONTROL	"", FIRSTUSER_MHISN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 260, 11, 140, 12
	CONTROL	"", FIRSTUSER_MVRN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 69, 27, 143, 12
	CONTROL	"", FIRSTUSER_MNA2, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 260, 25, 140, 13
	CONTROL	"", FIRSTUSER_MAD1, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 69, 41, 143, 12
	CONTROL	"", FIRSTUSER_MPOS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 260, 40, 36, 12
	CONTROL	"", FIRSTUSER_MPLA, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 316, 40, 83, 12
	CONTROL	"Your logon data:", FIRSTUSER_THEGROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 65, 176, 69
	CONTROL	"Logon Name:", FIRSTUSER_MLOGON_NAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 77, 88, 12
	CONTROL	"Password:", FIRSTUSER_MPASSWORD, "Edit", ES_AUTOHSCROLL|ES_PASSWORD|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 96, 88, 12
	CONTROL	"Password:", FIRSTUSER_MPASSWORD2, "Edit", ES_AUTOHSCROLL|ES_PASSWORD|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 114, 88, 12
	CONTROL	"Your personal data", FIRSTUSER_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 3, 398, 57
	CONTROL	"Administration data", FIRSTUSER_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 7, 137, 399, 93
	CONTROL	"", FIRSTUSER_MADMINTYPE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 93, 148, 120, 61
	CONTROL	"Type of Administration:", FIRSTUSER_FIXEDTEXT5, "Static", WS_CHILD, 15, 150, 75, 13
	CONTROL	"Lastname:", FIRSTUSER_MNA1MBR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 68, 177, 143, 12
	CONTROL	"Prefix:", FIRSTUSER_MHISNMBR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 260, 177, 133, 12
	CONTROL	"First name:", FIRSTUSER_MVRNMBR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 68, 192, 143, 12
	CONTROL	"Initials:", FIRSTUSER_MNA2MBR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 260, 192, 133, 12
	CONTROL	"Bank/Giro:", FIRSTUSER_MBANKNUMMER, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 68, 206, 143, 13
	CONTROL	"Telebanking?", FIRSTUSER_MTELEBANKNG, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 216, 206, 80, 11
	CONTROL	"Initials:", FIRSTUSER_SC_NA2MBR, "Static", WS_CHILD|NOT WS_VISIBLE, 220, 192, 23, 12
	CONTROL	"Prefix:", FIRSTUSER_SC_HISNMBR, "Static", WS_CHILD|NOT WS_VISIBLE, 220, 177, 36, 12
	CONTROL	"First name:", FIRSTUSER_SC_VRNMBR, "Static", WS_CHILD|NOT WS_VISIBLE, 16, 192, 36, 12
	CONTROL	"Lastname:", FIRSTUSER_SC_NA1MBR, "Static", WS_CHILD|NOT WS_VISIBLE, 16, 177, 34, 12
	CONTROL	"Bank/Giro gifts:", FIRSTUSER_SC_BANKNUMMER, "Static", WS_CHILD, 16, 206, 52, 13
	CONTROL	"OK", FIRSTUSER_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 352, 235, 54, 12
	CONTROL	"Member data", FIRSTUSER_MEMBERBOX, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|NOT WS_VISIBLE, 10, 163, 391, 59
END

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS FirstUser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"FirstUser",_GetInst()},iCtlID)

oDCtheFixedText2 := FixedText{SELF,ResourceID{FIRSTUSER_THEFIXEDTEXT2,_GetInst()}}
oDCtheFixedText2:HyperLabel := HyperLabel{#theFixedText2,"User Id:",NULL_STRING,NULL_STRING}

oDCtheFixedText1 := FixedText{SELF,ResourceID{FIRSTUSER_THEFIXEDTEXT1,_GetInst()}}
oDCtheFixedText1:HyperLabel := HyperLabel{#theFixedText1,"Password:",NULL_STRING,NULL_STRING}

oDCtheFixedText3 := FixedText{SELF,ResourceID{FIRSTUSER_THEFIXEDTEXT3,_GetInst()}}
oDCtheFixedText3:HyperLabel := HyperLabel{#theFixedText3,"Retype Password:",NULL_STRING,NULL_STRING}

oDCSC_NA1 := FixedText{SELF,ResourceID{FIRSTUSER_SC_NA1,_GetInst()}}
oDCSC_NA1:HyperLabel := HyperLabel{#SC_NA1,"Lastname:",NULL_STRING,NULL_STRING}

oDCSC_HISN := FixedText{SELF,ResourceID{FIRSTUSER_SC_HISN,_GetInst()}}
oDCSC_HISN:HyperLabel := HyperLabel{#SC_HISN,"Prefix:",NULL_STRING,NULL_STRING}

oDCSC_VRN := FixedText{SELF,ResourceID{FIRSTUSER_SC_VRN,_GetInst()}}
oDCSC_VRN:HyperLabel := HyperLabel{#SC_VRN,"First name:",NULL_STRING,NULL_STRING}

oDCSC_NA2 := FixedText{SELF,ResourceID{FIRSTUSER_SC_NA2,_GetInst()}}
oDCSC_NA2:HyperLabel := HyperLabel{#SC_NA2,"Initials:",NULL_STRING,NULL_STRING}

oDCSC_AD1 := FixedText{SELF,ResourceID{FIRSTUSER_SC_AD1,_GetInst()}}
oDCSC_AD1:HyperLabel := HyperLabel{#SC_AD1,"Street+number:",NULL_STRING,NULL_STRING}

oDCSC_POS := FixedText{SELF,ResourceID{FIRSTUSER_SC_POS,_GetInst()}}
oDCSC_POS:HyperLabel := HyperLabel{#SC_POS,"Zip code:",NULL_STRING,NULL_STRING}

oDCSC_PLA := FixedText{SELF,ResourceID{FIRSTUSER_SC_PLA,_GetInst()}}
oDCSC_PLA:HyperLabel := HyperLabel{#SC_PLA,"City:",NULL_STRING,NULL_STRING}

oDCmNA1 := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MNA1,_GetInst()}}
oDCmNA1:FieldSpec := Person_NA1{}
oDCmNA1:HyperLabel := HyperLabel{#mNA1,NULL_STRING,NULL_STRING,"Person_NA1"}
oDCmNA1:FocusSelect := FSEL_HOME
oDCmNA1:OverWrite := OVERWRITE_ONKEY
oDCmNA1:Picture := "!XXXXXXXXXXXXXXXXXXXXXXXXXXX"

oDCmHISN := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MHISN,_GetInst()}}
oDCmHISN:FieldSpec := Person_HISN{}
oDCmHISN:HyperLabel := HyperLabel{#mHISN,NULL_STRING,NULL_STRING,"Person_HISN"}
oDCmHISN:FocusSelect := FSEL_HOME

oDCmVRN := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MVRN,_GetInst()}}
oDCmVRN:FieldSpec := Person_VRN{}
oDCmVRN:HyperLabel := HyperLabel{#mVRN,NULL_STRING,NULL_STRING,"Person_VRN"}
oDCmVRN:FocusSelect := FSEL_HOME
oDCmVRN:Picture := "!XXXXXXXXXXXXXXXXXXXXXXXXXXX"

oDCmNA2 := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MNA2,_GetInst()}}
oDCmNA2:HyperLabel := HyperLabel{#mNA2,NULL_STRING,NULL_STRING,"Person_NA2"}
oDCmNA2:FocusSelect := FSEL_HOME
oDCmNA2:Picture := "@!"

oDCmAD1 := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MAD1,_GetInst()}}
oDCmAD1:HyperLabel := HyperLabel{#mAD1,NULL_STRING,NULL_STRING,"Person_AD1"}
oDCmAD1:FocusSelect := FSEL_HOME
oDCmAD1:OverWrite := OVERWRITE_ONKEY
oDCmAD1:FieldSpec := Person_AD1{}
oDCmAD1:Picture := "!XXXXXXXXXXXXXXXXXXXXXXXXXXX"

oDCmPOS := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MPOS,_GetInst()}}
oDCmPOS:FieldSpec := Person_POS{}
oDCmPOS:HyperLabel := HyperLabel{#mPOS,NULL_STRING,NULL_STRING,"Person_POS"}
oDCmPOS:FocusSelect := FSEL_HOME
oDCmPOS:OverWrite := OVERWRITE_ONKEY
oDCmPOS:Picture := "@!"

oDCmPLA := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MPLA,_GetInst()}}
oDCmPLA:FieldSpec := Person_PLA{}
oDCmPLA:HyperLabel := HyperLabel{#mPLA,NULL_STRING,NULL_STRING,"Person_PLA"}
oDCmPLA:FocusSelect := FSEL_HOME
oDCmPLA:OverWrite := OVERWRITE_ONKEY
oDCmPLA:Picture := "@!"

oDCtheGroupBox1 := GroupBox{SELF,ResourceID{FIRSTUSER_THEGROUPBOX1,_GetInst()}}
oDCtheGroupBox1:HyperLabel := HyperLabel{#theGroupBox1,"Your logon data:",NULL_STRING,NULL_STRING}

oDCmLOGON_NAME := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MLOGON_NAME,_GetInst()}}
oDCmLOGON_NAME:FieldSpec := Employee_LOGINNAME{}
oDCmLOGON_NAME:HyperLabel := HyperLabel{#mLOGON_NAME,"Logon Name:",NULL_STRING,"Employee Controls"}

oDCmPASSWORD := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MPASSWORD,_GetInst()}}
oDCmPASSWORD:HyperLabel := HyperLabel{#mPASSWORD,"Password:",NULL_STRING,"Employee Controls"}
oDCmPASSWORD:OverWrite := OVERWRITE_ALWAYS

oDCmPASSWORD2 := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MPASSWORD2,_GetInst()}}
oDCmPASSWORD2:HyperLabel := HyperLabel{#mPASSWORD2,"Password:",NULL_STRING,"Employee Controls"}
oDCmPASSWORD2:OverWrite := OVERWRITE_ALWAYS

oDCGroupBox1 := GroupBox{SELF,ResourceID{FIRSTUSER_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Your personal data",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{FIRSTUSER_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Administration data",NULL_STRING,NULL_STRING}

oDCmAdminType := combobox{SELF,ResourceID{FIRSTUSER_MADMINTYPE,_GetInst()}}
oDCmAdminType:TooltipText := "Type of administration determining shown menu choices"
oDCmAdminType:HyperLabel := HyperLabel{#mAdminType,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{FIRSTUSER_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Type of Administration:",NULL_STRING,NULL_STRING}

oDCmNA1mbr := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MNA1MBR,_GetInst()}}
oDCmNA1mbr:FieldSpec := Person_NA1{}
oDCmNA1mbr:HyperLabel := HyperLabel{#mNA1mbr,"Lastname:",NULL_STRING,"Person_NA1"}
oDCmNA1mbr:FocusSelect := FSEL_HOME
oDCmNA1mbr:OverWrite := OVERWRITE_ONKEY

oDCmHISNmbr := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MHISNMBR,_GetInst()}}
oDCmHISNmbr:FieldSpec := Person_HISN{}
oDCmHISNmbr:HyperLabel := HyperLabel{#mHISNmbr,"Prefix:",NULL_STRING,"Person_HISN"}
oDCmHISNmbr:FocusSelect := FSEL_HOME

oDCmVRNmbr := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MVRNMBR,_GetInst()}}
oDCmVRNmbr:FieldSpec := Person_VRN{}
oDCmVRNmbr:HyperLabel := HyperLabel{#mVRNmbr,"First name:",NULL_STRING,"Person_VRN"}
oDCmVRNmbr:FocusSelect := FSEL_HOME

oDCmNA2mbr := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MNA2MBR,_GetInst()}}
oDCmNA2mbr:FieldSpec := Person_NA2{}
oDCmNA2mbr:HyperLabel := HyperLabel{#mNA2mbr,"Initials:",NULL_STRING,"Person_NA2"}
oDCmNA2mbr:FocusSelect := FSEL_HOME

oDCmBANKNUMMER := SingleLineEdit{SELF,ResourceID{FIRSTUSER_MBANKNUMMER,_GetInst()}}
oDCmBANKNUMMER:FieldSpec := BANK{}
oDCmBANKNUMMER:HyperLabel := HyperLabel{#mBANKNUMMER,"Bank/Giro:","Number of bankaccount","BANK"}

oDCmTelebankng := CheckBox{SELF,ResourceID{FIRSTUSER_MTELEBANKNG,_GetInst()}}
oDCmTelebankng:HyperLabel := HyperLabel{#mTelebankng,"Telebanking?",NULL_STRING,NULL_STRING}

oDCSC_NA2mbr := FixedText{SELF,ResourceID{FIRSTUSER_SC_NA2MBR,_GetInst()}}
oDCSC_NA2mbr:HyperLabel := HyperLabel{#SC_NA2mbr,"Initials:",NULL_STRING,NULL_STRING}

oDCSC_HISNmbr := FixedText{SELF,ResourceID{FIRSTUSER_SC_HISNMBR,_GetInst()}}
oDCSC_HISNmbr:HyperLabel := HyperLabel{#SC_HISNmbr,"Prefix:",NULL_STRING,NULL_STRING}

oDCSC_VRNmbr := FixedText{SELF,ResourceID{FIRSTUSER_SC_VRNMBR,_GetInst()}}
oDCSC_VRNmbr:HyperLabel := HyperLabel{#SC_VRNmbr,"First name:",NULL_STRING,NULL_STRING}

oDCSC_NA1mbr := FixedText{SELF,ResourceID{FIRSTUSER_SC_NA1MBR,_GetInst()}}
oDCSC_NA1mbr:HyperLabel := HyperLabel{#SC_NA1mbr,"Lastname:",NULL_STRING,NULL_STRING}

oDCSC_BANKNUMMER := FixedText{SELF,ResourceID{FIRSTUSER_SC_BANKNUMMER,_GetInst()}}
oDCSC_BANKNUMMER:HyperLabel := HyperLabel{#SC_BANKNUMMER,"Bank/Giro gifts:",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{FIRSTUSER_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oDCMemberBox := GroupBox{SELF,ResourceID{FIRSTUSER_MEMBERBOX,_GetInst()}}
oDCMemberBox:HyperLabel := HyperLabel{#MemberBox,"Member data",NULL_STRING,NULL_STRING}

SELF:Caption := "First user Initialization"
SELF:HyperLabel := HyperLabel{#FirstUser,"First user Initialization",NULL_STRING,NULL_STRING}
SELF:AllowServerClose := True
SELF:ClipperKeys := True
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListBoxSelect(oControlEvent) CLASS FirstUser
	LOCAL oControl AS Control
	LOCAL i AS INT

	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControl:NameSym==#mAdminType
		IF !oDCmAdminType:Value==cOrigType .or. oDCmAdminType:ValueChanged
			* value changed:
			IF oDCmAdminType:Value=="HO"
				oDCMemberBox:Show()
				oDCmNA2mbr:Show()
				oDCSC_NA2mbr:Show()
				oDCmVRNmbr:Show()
				oDCSC_VRNmbr:Show()
				oDCmHISNmbr:Show()
				oDCSC_HISNmbr:Show()
				oDCmNA1mbr:Show()
				oDCSC_NA1mbr:Show()
				oDCSC_BANKNUMMER:Show()
				oDCmBANKNUMMER:Show()
				oDCmTelebankng:Show()
				self:mTelebankng:=true
			ELSE
				oDCMemberBox:Hide()
				oDCmNA2mbr:Hide()
				oDCSC_NA2mbr:Hide()
				oDCmVRNmbr:Hide()
				oDCSC_VRNmbr:Hide()
				oDCmHISNmbr:Hide()
				oDCSC_HISNmbr:Hide()
				oDCmNA1mbr:Hide()
				oDCSC_NA1mbr:Hide()
				IF oDCmAdminType:Value=="GI" .or.oDCmAdminType:Value=="WO"
					oDCSC_BANKNUMMER:Show()
					oDCmBANKNUMMER:Show()
					oDCmTelebankng:Show()
					self:mTelebankng:=true
				ELSE
					oDCSC_BANKNUMMER:Hide()
					oDCmBANKNUMMER:Hide()
					oDCmTelebankng:Hide()
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	RETURN NIL
ACCESS mAD1() CLASS FirstUser
RETURN SELF:FieldGet(#mAD1)

ASSIGN mAD1(uValue) CLASS FirstUser
SELF:FieldPut(#mAD1, uValue)
RETURN uValue

ACCESS mAdminType() CLASS FirstUser
RETURN SELF:FieldGet(#mAdminType)

ASSIGN mAdminType(uValue) CLASS FirstUser
SELF:FieldPut(#mAdminType, uValue)
RETURN uValue

ACCESS mBANKNUMMER() CLASS FirstUser
RETURN SELF:FieldGet(#mBANKNUMMER)

ASSIGN mBANKNUMMER(uValue) CLASS FirstUser
SELF:FieldPut(#mBANKNUMMER, uValue)
RETURN uValue

ACCESS mHISN() CLASS FirstUser
RETURN SELF:FieldGet(#mHISN)

ASSIGN mHISN(uValue) CLASS FirstUser
SELF:FieldPut(#mHISN, uValue)
RETURN uValue

ACCESS mHISNmbr() CLASS FirstUser
RETURN SELF:FieldGet(#mHISNmbr)

ASSIGN mHISNmbr(uValue) CLASS FirstUser
SELF:FieldPut(#mHISNmbr, uValue)
RETURN uValue

ACCESS mLOGON_NAME() CLASS FirstUser
RETURN SELF:FieldGet(#mLOGON_NAME)

ASSIGN mLOGON_NAME(uValue) CLASS FirstUser
SELF:FieldPut(#mLOGON_NAME, uValue)
RETURN uValue

ACCESS mNA1() CLASS FirstUser
RETURN SELF:FieldGet(#mNA1)

ASSIGN mNA1(uValue) CLASS FirstUser
SELF:FieldPut(#mNA1, uValue)
RETURN uValue

ACCESS mNA1mbr() CLASS FirstUser
RETURN SELF:FieldGet(#mNA1mbr)

ASSIGN mNA1mbr(uValue) CLASS FirstUser
SELF:FieldPut(#mNA1mbr, uValue)
RETURN uValue

ACCESS mNA2() CLASS FirstUser
RETURN SELF:FieldGet(#mNA2)

ASSIGN mNA2(uValue) CLASS FirstUser
SELF:FieldPut(#mNA2, uValue)
RETURN uValue

ACCESS mNA2mbr() CLASS FirstUser
RETURN SELF:FieldGet(#mNA2mbr)

ASSIGN mNA2mbr(uValue) CLASS FirstUser
SELF:FieldPut(#mNA2mbr, uValue)
RETURN uValue

ACCESS mPASSWORD2() CLASS FirstUser
RETURN SELF:FieldGet(#mPASSWORD2)

ASSIGN mPASSWORD2(uValue) CLASS FirstUser
SELF:FieldPut(#mPASSWORD2, uValue)
RETURN uValue

ACCESS mPASSWORD() CLASS FirstUser
RETURN SELF:FieldGet(#mPASSWORD)

ASSIGN mPASSWORD(uValue) CLASS FirstUser
SELF:FieldPut(#mPASSWORD, uValue)
RETURN uValue

ACCESS mPLA() CLASS FirstUser
RETURN SELF:FieldGet(#mPLA)

ASSIGN mPLA(uValue) CLASS FirstUser
SELF:FieldPut(#mPLA, uValue)
RETURN uValue

ACCESS mPOS() CLASS FirstUser
RETURN SELF:FieldGet(#mPOS)

ASSIGN mPOS(uValue) CLASS FirstUser
SELF:FieldPut(#mPOS, uValue)
RETURN uValue

ACCESS mTelebankng() CLASS FirstUser
RETURN SELF:FieldGet(#mTelebankng)

ASSIGN mTelebankng(uValue) CLASS FirstUser
SELF:FieldPut(#mTelebankng, uValue)
RETURN uValue

ACCESS mVRN() CLASS FirstUser
RETURN SELF:FieldGet(#mVRN)

ASSIGN mVRN(uValue) CLASS FirstUser
SELF:FieldPut(#mVRN, uValue)
RETURN uValue

ACCESS mVRNmbr() CLASS FirstUser
RETURN SELF:FieldGet(#mVRNmbr)

ASSIGN mVRNmbr(uValue) CLASS FirstUser
SELF:FieldPut(#mVRNmbr, uValue)
RETURN uValue

METHOD OkButton( ) CLASS FirstUser
	LOCAL oEmp as SQLStatement
// 	LOCAL oSys as SQLSelect 
	local oPers, oSel as SQLSelect 
	LOCAL mCLN, mRek, mNum, mNum1, mNumAsset, mNumLiability, cP,mPsw as STRING
	LOCAL i as int
	LOCAL  lAlpha, lNum as LOGIC
	LOCAL ptrhandle as USUAL
	LOCAL MyName as STRING 
	Local oStmnt as SQLStatement, cUpdate as string
	
	// 	IF !ValidateControls( SELF, SELF:AControls )
	// 		RETURN
	// 	ENDIF
	IF IsNil(self:mNA1).or.Empty(self:mNA1)
		ErrorBox{ self, " Fill Your Last Name" }:Show()
		RETURN
	ENDIF
	IF IsNil(self:mVRN) .or.Empty(self:mVRN)
		ErrorBox{ self, " Fill Your First Name" }:Show()
		RETURN
	ENDIF
	IF IsNil(self:mNA2).or.Empty(self:mNA2) 
		ErrorBox{ self, " Fill Your Initials" }:Show()
		RETURN
	ENDIF
	IF IsNil(self:mAD1) .or.Empty(self:mAD1)  
		ErrorBox{ self, " Fill YourAddress" }:Show()
		RETURN
	ENDIF
	IF Empty(self:mPLA)
		ErrorBox{ self, " Fill Your City Name" }:Show()
		RETURN
	ENDIF
	IF Empty(self:mLOGON_NAME)
		ErrorBox{ self, " Fill UserId" }:Show()
		RETURN
	ENDIF
	IF Empty(self:mPASSWORD)
		ErrorBox{ self, " Fill Password" }:Show()
		RETURN
	ENDIF
	IF !Trim(Upper( Trim( self:oDCmPassword:Textvalue ) )) ==;
			Trim(Upper( Trim( self:oDCmPassword2:Textvalue ) ))
		ErrorBox{ self, " Passwords do not match!" }:Show()
		RETURN
	ENDIF
	IF Empty(self:mAdminType)
		ErrorBox{ self, " Fill Type of Administration" }:Show()
		RETURN
	ENDIF
	IF self:mAdminType=="HO" .or. self:mAdminType=="WO" .or. self:mAdminType=="GI"
		IF Empty(self:mBANKNUMMER)
			ErrorBox{ self, " Fill Bank/Giro" }:Show()
			RETURN
		ENDIF
	endif
	IF self:mAdminType=="HO" 
		IF Empty(self:mNA1mbr)
			ErrorBox{ self, " Fill Members Last Name" }:Show()
			RETURN
		ENDIF
		IF Empty(self:mVRNmbr)
			ErrorBox{ self, " Fill Members First Name" }:Show()
			RETURN
		ENDIF
		IF Empty(self:mNA2mbr)
			ErrorBox{ self, " Fill Members Initials" }:Show()
			RETURN
		ENDIF
	ENDIF 
	mPsw:=AllTrim(self:mPassword) 
	if !CheckPassword(mPsw)
		return 
	endif
// 	oSys:=SQLSelect{"select * from sysparms",oConn}
	oPers:=SQLSelect{"select persid from person where lastname='"+self:mNA1+"' and firstname='"+self:mVRN+"' and city='"+self:mPLA+"'",oConn} 
	IF oPers:Reccount>0
		mCLN:=Str(oPers:persid,-1)
	ENDIF
	IF Empty(mCLN)
		oStmnt:=SQLStatement{"insert into person set lastname='"+self:mNA1+"',initials='"+self:mNA2+"',prefix='"+self:mHISN+"',firstname='"+self:mVRN+;
			"',address='"+self:mAD1+"',city='"+self:mPLA+"',postalcode='"+StandardZip(self:mPOS)+"',OPC='"+AllTrim(self:mLOGON_NAME)+;
			"',creationdate='"+SQLdate(Today())+"',alterdate='"+SQLdate(Today())+"'",oConn}
		oStmnt:Execute()
		mCLN:=ConS(SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
	ENDIF
	MyName:= AllTrim(self:mVRN)+' '+if(Empty(self:mHISN),"",AllTrim(self:mHISN)+" ")+AllTrim(self:mNA1)
	oStmnt:=SQLStatement{"insert into employee set empid=1000, persid="+Crypt_Emp(true,"persid",mCLN,1000),oConn} 

	oStmnt:Execute()
	if !IsNil(oStmnt:Status)
		(ErrorBox{self,'Add employee Error:'+oStmnt:Status:Description}):Show()
		return false
	endif
	MYEMPID:='1000'
	cUpdate:="update employee set loginName="+Crypt_Emp(true,"loginname",Lower(AllTrim(self:mLOGON_NAME))) ;
		+", lstupdpw=NOW(), password='"+HashPassword(1000,self:oDCmPassword:TextValue)+"', type="+Crypt_Emp(true,"type","A")+", depid="+Crypt_Emp(true,"depid","")
	oStmnt:SQLString:=cUpdate
	oStmnt:Execute()
	LOGON_EMP_ID := AllTrim(self:mLOGON_NAME)
	MYEMPID := "1000"
	UserType:="A"
	* Add balance items:  Income and expense, Balance: Assets&Liabilities, 
	oStmnt:=SQLStatement{"insert into balanceitem (number,heading,footer,category,balitemidparent) values "+;
	"('400','Income and Expense','Surplus/Deficit','"+Income+"','0')",oConn}
	oStmnt:Execute()
	mNum:=ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
	oStmnt:=SQLStatement{"insert into balanceitem (number,heading,footer,category,balitemidparent) values ('4000','Income','Income','"+Income+"',"+mNum+")"+;
	",('6000','Expenses','Expenses','"+Expense+"',"+mNum+")",oConn}	
	oStmnt:Execute()	
	oStmnt:=SQLStatement{"insert into balanceitem (number,heading,footer,category,balitemidparent) values ('100','Balance','Increment Netassets','"+asset+"','0')",oConn}
	oStmnt:Execute()	
	mNum:=ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
	oStmnt:=SQLStatement{"insert into balanceitem (number,heading,footer,category,balitemidparent) values ('1000','Assets','Assets','"+asset+"',"+mNum+")",oConn}
	oStmnt:Execute()	
	mNumAsset:=ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
	oStmnt:=SQLStatement{"insert into balanceitem (number,heading,footer,category,balitemidparent) values ('2000','Liabilities and Funds','Liabilities and Funds','"+liability+"',"+mNum+")",oConn}
	oStmnt:Execute()	
	mNumLiability:=ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
	IF self:mAdminType=="HO"
		* Registrate member:
		* add Person:
		oStmnt:=SQLStatement{"insert into person set "+;
			"creationdate='"+SQLdate(Today())+"'"+;
			",lastname='"+AllTrim(self:mNA1mbr)+"'"+;
			",initials='"+AllTrim(self:mNA2mbr)+"'"+;
			",prefix='"+AllTrim(self:mHISNmbr)+"'"+;
			",firstname='"+AllTrim(self:mVRNmbr) +"'"+;
			",mailingcodes='MW '"+;
			",type=2"+;
			",opc='"+AllTrim(self:mLOGON_NAME) +"'"+;
			",alterdate='"+SQLdate(Today()) +"'",oConn}
		oStmnt:Execute()
		mCLN:=ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
		oStmnt:=SQLStatement{"insert into account set "+;
			"description='"+GetFullName(mCLN) +"'"+;
			",balitemid ='"+ mNumLiability+"'"+;
			",accnumber='77001'"+;
			",giftalwd='1'",oConn}
		oStmnt:Execute()
		mRek:=ConS(ConI(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)))			
		// 		SQLStatement{"update person set accid='"+mRek+"' where persid="+mCln,oConn}:Execute() 
		* Add Member:
		oStmnt:=SQLStatement{"insert into member set "+;
			"accid ='"+ mRek +"'"+;
			",persid ='"+ mCLN+"'"+;
			",co='M',grade='SM',homepp='"+sEntity+"'",oConn}
		oStmnt:Execute()
		* Generate email for member:
		ptrHandle := FCreate("GiftReport.eMl")
		FWrite(ptrhandle, "Dear %FIRSTNAME,"+CRLF+;
			"Here is your memberstatements and gifts report about last month."+CRLF;
			+"Blessings, "+AllTrim(MyName))
		FClose(ptrHandle)
		SetRTRegString( "WYC\Runtime", "eMlBrief", "GiftReport") 
	endif
	IF self:mAdminType=="HO" .or.  self:mAdminType=="GI" .or.  self:mAdminType=="WO"
		oStmnt:=SQLStatement{"insert into account set "+;
			"description='"+"Bank: "+self:mBANKNUMMER+"'"+;
			",accnumber='60001'"+;
			",currency='"+sCurr+"'"+;
			",balitemid ='"+ mNumAsset +"'",oConn}
		oStmnt:Execute()
		mRek:=ConS(SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))

		* Add Bankaccount:
		oStmnt:=SQLStatement{"insert into bankaccount set "+;
			"banknumber='"+self:mBANKNUMMER+"'"+;				
			",accid='"+mRek+"'"+;
			",usedforgifts=1"+;
			",telebankng="+if(self:mTelebankng,'1','0')+;
			iif(self:mTelebankng,",giftsall=1,openall=1",""),oConn}
		oStmnt:Execute()
	ENDIF
	* Add Account for Netasset:
	oStmnt:=SQLStatement{"insert into account set "+;
		"description='Netassets'"+;
		",currency='"+sCurr+"'"+;
		",balitemid ='"+ mNumLiability+"'"+;
		",accnumber='15000'",oConn}
	oStmnt:Execute()
	mRek:=ConS(SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
	oStmnt:=SQLStatement{"update sysparms set capital='"+mRek+"',admintype='"+self:mAdminType+"'",oConn}
	oStmnt:Execute()
	
	ADMIN:=self:mAdminType
	SaveCheckDigit()
	InitGlobals()
	(TextBox{,"First use","Go to Help/Index/Configuration for instructions how to setup the system"}):Show()

	self:EndWindow()
	
	RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS FirstUser
	//Put your PostInit additions here
	LOCAL oReg AS CLASS_HKCU
	LOCAL i AS INT
	self:SetTexts()
	self:oDCmAdminType:FillUsing({{"Wycliffe Office","WO"},{"Home Front of one Member","HO"},{"Wycliffe Area","WA"},;
		{"General Gifts Administration","GI"},{"General Accounting","GE"}})
	self:oDCmAdminType:Value:="WO"
	self:mLOGON_NAME:=uExtra 
	cUser:=uExtra 
	self:oDCmPASSWORD:TextValue:=""
	self:oDCmPASSWORD2:TextValue:=""
	cOrigType:=SELF:oDCmAdminType:Value
	
	RETURN NIL
STATIC DEFINE FIRSTUSER_FIXEDTEXT5 := 124 
STATIC DEFINE FIRSTUSER_GROUPBOX1 := 121 
STATIC DEFINE FIRSTUSER_GROUPBOX2 := 122 
STATIC DEFINE FIRSTUSER_MAD1 := 114 
STATIC DEFINE FIRSTUSER_MADMINTYPE := 123 
STATIC DEFINE FIRSTUSER_MBANKNUMMER := 129 
STATIC DEFINE FIRSTUSER_MEMBERBOX := 137 
STATIC DEFINE FIRSTUSER_MHISN := 111 
STATIC DEFINE FIRSTUSER_MHISNMBR := 126 
STATIC DEFINE FIRSTUSER_MLOGON_NAME := 118 
STATIC DEFINE FIRSTUSER_MNA1 := 110 
STATIC DEFINE FIRSTUSER_MNA1MBR := 125 
STATIC DEFINE FIRSTUSER_MNA2 := 113 
STATIC DEFINE FIRSTUSER_MNA2MBR := 128 
STATIC DEFINE FIRSTUSER_MPASSWORD := 119 
STATIC DEFINE FIRSTUSER_MPASSWORD2 := 120 
STATIC DEFINE FIRSTUSER_MPLA := 116 
STATIC DEFINE FIRSTUSER_MPOS := 115 
STATIC DEFINE FIRSTUSER_MTELEBANKNG := 130 
STATIC DEFINE FIRSTUSER_MVRN := 112 
STATIC DEFINE FIRSTUSER_MVRNMBR := 127 
STATIC DEFINE FIRSTUSER_OKBUTTON := 136 
STATIC DEFINE FIRSTUSER_SC_AD1 := 107 
STATIC DEFINE FIRSTUSER_SC_BANKNUMMER := 135 
STATIC DEFINE FIRSTUSER_SC_HISN := 104 
STATIC DEFINE FIRSTUSER_SC_HISNMBR := 132 
STATIC DEFINE FIRSTUSER_SC_NA1 := 103 
STATIC DEFINE FIRSTUSER_SC_NA1MBR := 134 
STATIC DEFINE FIRSTUSER_SC_NA2 := 106 
STATIC DEFINE FIRSTUSER_SC_NA2MBR := 131 
STATIC DEFINE FIRSTUSER_SC_PLA := 109 
STATIC DEFINE FIRSTUSER_SC_POS := 108 
STATIC DEFINE FIRSTUSER_SC_VRN := 105 
STATIC DEFINE FIRSTUSER_SC_VRNMBR := 133 
STATIC DEFINE FIRSTUSER_THEFIXEDTEXT1 := 101 
STATIC DEFINE FIRSTUSER_THEFIXEDTEXT2 := 100 
STATIC DEFINE FIRSTUSER_THEFIXEDTEXT3 := 102 
STATIC DEFINE FIRSTUSER_THEGROUPBOX1 := 117 
CLASS LogonDialog INHERIT DialogWinDowExtra 

	PROTECT oDCtheFixedText1 AS FIXEDTEXT
	PROTECT oDCName AS SINGLELINEEDIT
	PROTECT oDCtheFixedText2 AS FIXEDTEXT
	PROTECT oDCPassword AS SINGLELINEEDIT
	PROTECT oCCOkButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
   EXPORT  logonOk, ChangePsw as LOGIC
  EXPORT  logonID as STRING
  PROTECT wLogonCount as word
RESOURCE LogonDialog DIALOGEX  5, 17, 227, 51
STYLE	DS_3DLOOK|DS_MODALFRAME|DS_CENTER|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Login"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"&User Id:", LOGONDIALOG_THEFIXEDTEXT1, "Static", WS_CHILD, 8, 11, 40, 12
	CONTROL	"", LOGONDIALOG_NAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 52, 7, 94, 13
	CONTROL	"&Password:", LOGONDIALOG_THEFIXEDTEXT2, "Static", WS_CHILD, 8, 29, 36, 12
	CONTROL	"", LOGONDIALOG_PASSWORD, "Edit", ES_AUTOHSCROLL|ES_PASSWORD|WS_TABSTOP|WS_CHILD|WS_BORDER, 52, 29, 94, 14
	CONTROL	"OK", LOGONDIALOG_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 164, 7, 53, 13
	CONTROL	"Cancel", LOGONDIALOG_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 164, 27, 53, 13
END

METHOD CancelButton() CLASS LogonDialog

	logonOk := FALSE
	logonID := ""
	self:EndDialog()
	
	RETURN self
METHOD Close(oEvent) CLASS LogonDialog
	SUPER:Close(oEvent)
	//Put your changes here
	self:Destroy()
	RETURN nil
METHOD Init(oParent,uExtra) CLASS LogonDialog 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"LogonDialog",_GetInst()},TRUE)

oDCtheFixedText1 := FixedText{SELF,ResourceID{LOGONDIALOG_THEFIXEDTEXT1,_GetInst()}}
oDCtheFixedText1:HyperLabel := HyperLabel{#theFixedText1,_chr(38)+"User Id:",NULL_STRING,NULL_STRING}

oDCName := SingleLineEdit{SELF,ResourceID{LOGONDIALOG_NAME,_GetInst()}}
oDCName:HyperLabel := HyperLabel{#Name,NULL_STRING,NULL_STRING,NULL_STRING}

oDCtheFixedText2 := FixedText{SELF,ResourceID{LOGONDIALOG_THEFIXEDTEXT2,_GetInst()}}
oDCtheFixedText2:HyperLabel := HyperLabel{#theFixedText2,_chr(38)+"Password:",NULL_STRING,NULL_STRING}

oDCPassword := SingleLineEdit{SELF,ResourceID{LOGONDIALOG_PASSWORD,_GetInst()}}
oDCPassword:HyperLabel := HyperLabel{#Password,NULL_STRING,NULL_STRING,NULL_STRING}

oCCOkButton := PushButton{SELF,ResourceID{LOGONDIALOG_OKBUTTON,_GetInst()}}
oCCOkButton:HyperLabel := HyperLabel{#OkButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{LOGONDIALOG_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

SELF:Caption := "Login"
SELF:HyperLabel := HyperLabel{#LogonDialog,"Login",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OkButton() CLASS LogonDialog

	LOCAL oEmp as SQLSelect
	LOCAL nDuration, Cnt as int 
	Local cUser:=Lower(AllTrim(oDCName:Textvalue)),MyCLN,cEmpStmnt  as string
	local oSys as SQLSelect
	Cnt:= ConI(SQLSelect{"select count(*) as nbr from employee",oConn}:nbr)
	if Cnt=0
		InfoBox{ self, "Logon", "Employee database is empty! Restore Employee.dbf from backup first!"}:Show()
		self:logonOk := false
		wLogonCount:=5
	ELSE
		cEmpStmnt:="select empid, cast("+Crypt_Emp(false,"persid")+" as char) as persid,cast("+Crypt_Emp(false,"type") +" as char) as mtype,cast("+Crypt_Emp(false,"depid")+" as char) as mdepid,"+;
			" cast("+Crypt_Emp(false,"loginname")+" as char) as loginname,cast(lstupdpw as date) as lstupdpw,password from employee where ";
			+ Crypt_Emp(false,"loginname")+'="'+cUser+'"'

		oEmp := SQLSelect{cEmpStmnt,oConn}
		oSys:=SQLSelect{"select pswdura,sysname from sysparms",oConn}
		oSys:Execute()
		IF oEmp:Reccount==1
			self:logonOk := ( HashPassword(oEmp:EMPID,AllTrim(oDCPassword:Textvalue)) == oEmp:Password)
			self:logonID := AllTrim(oEmp:LOGINNAME)
			MyCLN:=oEmp:persid 					
			IF self:logonOk
				MYEMPID := Str(oEmp:EMPID,-1) 
				if !GetUserMenu(AllTrim(self:logonID))
					( ErrorBox{ nil, "Sorry, logon attempt failed!" } ):Show()
					// Exit program
					Break
				endif
				* check duration of password:
				nDuration:=oSys:PSWDURA
				IF !Empty(nDuration)
					IF Empty(oEmp:LSTUPDPW)
						SQLStatement{"update employee set lstupdpw='"+SQLdate(Today())+"'",oConn}:Execute()
					ELSE
						IF (Today()-oEmp:LSTUPDPW)>nDuration
							IF (Today()-oEmp:LSTUPDPW)>=10000
								ErrorBox{self,"First use of userid/password; please change it"}:Show()
							ELSE
								ErrorBox{ self, "Password has expired, change it now!" }:Show()
							ENDIF
							self:ChangePsw:=true
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ELSE
			if IsAdminUser(cUser,AllTrim( Transform(self:oDCPassword:Textvalue,"" ) ) )
				SuperUser:=true
				cEmpStmnt:="select empid,cast("+Crypt_Emp(false,"loginname")+" as char) as loginname from employee where ";
					+ Crypt_Emp(false,"type")+"='A'"
				oEmp := SQLSelect{cEmpStmnt,oConn} 
				UserType:="A"
				self:logonOk:=true 
				IF oEmp:Reccount>0
					oEmp:GoTop()
					MYEMPID := Str(oEmp:EMPID,-1) 
					self:logonID := AllTrim(oEmp:LOGINNAME)
					LOGON_EMP_ID := AllTrim(self:logonID)
				else
					MYEMPID:='0'
				endif
				aMenu:=InitMenu(Val(MYEMPID),UserType)
				InitSystemMenu()
				oMainWindow:SetCaption(oSys:SYSNAME) 
			else
				self:logonOk := FALSE
			endif
		ENDIF
	endif

	IF ( self:logonOk .or. ( wLogonCount >= 3 ) )
		// check if database false
		if !EvalCheckDigit() 
			LogEvent(self,"Somebody has manipulated the Employee database. Restore it first from backup!","logerrors")
			ErrorBox{ self, "Somebody has manipulated the Employee database. Restore it first from backup!" }:Show()
			IF !SuperUser
				self:logonOk:=false 
   		endif
		endif
		self:EndDialog()
	ELSE
		ErrorBox{ self, "Invalid login attempt!" }:Show()

		wLogonCount	+= 1

		oDCName:SetFocus()
	ENDIF	
	
	RETURN
METHOD PostInit(oParent,uExtra) CLASS LogonDialog
self:SetTexts()

	logonOk := FALSE
	logonID := ""
	wLogonCount := 1
	oDCName:TextValue:=uExtra

RETURN self
STATIC DEFINE LOGONDIALOG_CANCELBUTTON := 105 
STATIC DEFINE LOGONDIALOG_NAME := 101 
STATIC DEFINE LOGONDIALOG_OKBUTTON := 104 
STATIC DEFINE LOGONDIALOG_PASSWORD := 103 
STATIC DEFINE LOGONDIALOG_THEFIXEDTEXT1 := 100 
STATIC DEFINE LOGONDIALOG_THEFIXEDTEXT2 := 102 
STATIC DEFINE NEWEMPLOYEEWINDOW_CANCELBUTTON := 111 
STATIC DEFINE NEWEMPLOYEEWINDOW_MFIRST_NAME := 102 
STATIC DEFINE NEWEMPLOYEEWINDOW_MLAST_NAME := 104 
STATIC DEFINE NEWEMPLOYEEWINDOW_MLOGON_NAME := 107 
STATIC DEFINE NEWEMPLOYEEWINDOW_MPASSWORD := 109 
STATIC DEFINE NEWEMPLOYEEWINDOW_OKBUTTON := 110 
STATIC DEFINE NEWEMPLOYEEWINDOW_THEFIXEDTEXT1 := 108 
STATIC DEFINE NEWEMPLOYEEWINDOW_THEFIXEDTEXT2 := 106 
STATIC DEFINE NEWEMPLOYEEWINDOW_THEFIXEDTEXT8 := 103 
STATIC DEFINE NEWEMPLOYEEWINDOW_THEFIXEDTEXT9 := 101 
STATIC DEFINE NEWEMPLOYEEWINDOW_THEGROUPBOX1 := 105 
STATIC DEFINE NEWEMPLOYEEWINDOW_THEGROUPBOX3 := 100 
RESOURCE NewPasswordDialog DIALOGEX  8, 24, 294, 62
STYLE	DS_MODALFRAME|DS_CENTER|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Change Password"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"&New Password:", NEWPASSWORDDIALOG_THEFIXEDTEXT2, "Static", WS_CHILD, 8, 17, 72, 12
	CONTROL	"Password:", NEWPASSWORDDIALOG_NEWPASSWORDSLE, "Edit", ES_AUTOHSCROLL|ES_PASSWORD|WS_TABSTOP|WS_CHILD|WS_BORDER, 87, 14, 125, 14
	CONTROL	"&Retype Password:", NEWPASSWORDDIALOG_THEFIXEDTEXT3, "Static", WS_CHILD, 8, 35, 78, 16
	CONTROL	"Password:", NEWPASSWORDDIALOG_RETYPEPASSWORDSLE, "Edit", ES_AUTOHSCROLL|ES_PASSWORD|WS_TABSTOP|WS_CHILD|WS_BORDER, 88, 33, 125, 13
	CONTROL	"OK", NEWPASSWORDDIALOG_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 230, 14, 54, 14
	CONTROL	"Cancel", NEWPASSWORDDIALOG_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 230, 33, 54, 14
END

CLASS NewPasswordDialog INHERIT DialogWinDowExtra 

	PROTECT oDCtheFixedText2 AS FIXEDTEXT
	PROTECT oDCNewPasswordSLE AS SINGLELINEEDIT
	PROTECT oDCtheFixedText3 AS FIXEDTEXT
	PROTECT oDCRetypePasswordSLE AS SINGLELINEEDIT
	PROTECT oCCOkButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT ChangePsw AS LOGIC
METHOD CancelButton CLASS NewPasswordDialog

	SELF:EndDialog()
	
	RETURN SELF
METHOD Close(oEvent) CLASS NewPasswordDialog
	SUPER:Close(oEvent)
	//Put your changes here
	SELF:Destroy()
	RETURN NIL

METHOD Init(oParent,uExtra) CLASS NewPasswordDialog 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"NewPasswordDialog",_GetInst()},TRUE)

oDCtheFixedText2 := FixedText{SELF,ResourceID{NEWPASSWORDDIALOG_THEFIXEDTEXT2,_GetInst()}}
oDCtheFixedText2:HyperLabel := HyperLabel{#theFixedText2,_chr(38)+"New Password:",NULL_STRING,NULL_STRING}

oDCNewPasswordSLE := SingleLineEdit{SELF,ResourceID{NEWPASSWORDDIALOG_NEWPASSWORDSLE,_GetInst()}}
oDCNewPasswordSLE:HyperLabel := HyperLabel{#NewPasswordSLE,"Password:","Enter the employee's password",NULL_STRING}

oDCtheFixedText3 := FixedText{SELF,ResourceID{NEWPASSWORDDIALOG_THEFIXEDTEXT3,_GetInst()}}
oDCtheFixedText3:HyperLabel := HyperLabel{#theFixedText3,_chr(38)+"Retype Password:",NULL_STRING,NULL_STRING}

oDCRetypePasswordSLE := SingleLineEdit{SELF,ResourceID{NEWPASSWORDDIALOG_RETYPEPASSWORDSLE,_GetInst()}}
oDCRetypePasswordSLE:HyperLabel := HyperLabel{#RetypePasswordSLE,"Password:","Enter the employee's password",NULL_STRING}

oCCOkButton := PushButton{SELF,ResourceID{NEWPASSWORDDIALOG_OKBUTTON,_GetInst()}}
oCCOkButton:HyperLabel := HyperLabel{#OkButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{NEWPASSWORDDIALOG_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

SELF:Caption := "Change Password"
SELF:HyperLabel := HyperLabel{#NewPasswordDialog,"Change Password",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OkButton CLASS NewPasswordDialog
LOCAL cError, cNew, cCur,cUser:=AllTrim(LOGON_EMP_ID ) as STRING
LOCAL cP as STRING
LOCAL i as int
LOCAL lAlpha, lNum as LOGIC 
local oEmp as SQLSelect 
local oStmnt as SQLStatement

self:oDCNewPasswordSLE:SetFocus()
IF !Empty( self:oDCNewPasswordSLE:Textvalue )
	IF AllTrim( self:oDCNewPasswordSLE:Textvalue ) ==;
		AllTrim( self:oDCRetypePasswordSLE:Textvalue )
      if !CheckPassword(self:oDCNewPasswordSLE:Textvalue,Val(MYEMPID))
        	return false
      endif
		oEmp:=SQLSelect{"select password,pswprv1,pswprv2 from employee where empid="+MYEMPID,oConn} 
		if Empty(oEmp:Status) 
			* shift passwords:
			oStmnt:= SQLStatement{"update employee set pswprv3='"+iif(IsNil(oEmp:PSWPRV2),"",oEmp:PSWPRV2)+;
			"',pswprv2='"+iif(IsNil(oEmp:PSWPRV1),"",oEmp:PSWPRV1)+"',pswprv1='"+oEmp:Password+;
			"',password = '"+HashPassword(Val(MYEMPID),self:oDCNewPasswordSLE:TextValue)+"',lstupdpw=NOW() where empid="+MYEMPID,oConn}  
			oStmnt:Execute()
			self:ChangePsw:=true
			self:EndDialog(1)
			RETURN 1
		endif
	ELSE
		cError:="New Passwords do not match!"
	ENDIF
ELSE
	cError:="You must enter a new password!"
ENDIF
ErrorBox{ self, cError }:Show()

RETURN
METHOD PostInit() CLASS NewPasswordDialog
self:SetTexts() 

	RETURN SELF
STATIC DEFINE NEWPASSWORDDIALOG_CANCELBUTTON := 105 
STATIC DEFINE NEWPASSWORDDIALOG_NEWPASSWORDSLE := 101 
STATIC DEFINE NEWPASSWORDDIALOG_OKBUTTON := 104 
STATIC DEFINE NEWPASSWORDDIALOG_RETYPEPASSWORDSLE := 103 
STATIC DEFINE NEWPASSWORDDIALOG_THEFIXEDTEXT2 := 100 
STATIC DEFINE NEWPASSWORDDIALOG_THEFIXEDTEXT3 := 102 
STATIC DEFINE USERBROWSER_CLOSEBUTTON := 104 
STATIC DEFINE USERBROWSER_DELETEBUTTON := 103 
STATIC DEFINE USERBROWSER_EDITBUTTON := 101 
STATIC DEFINE USERBROWSER_NEWBUTTON := 102 
STATIC DEFINE USERBROWSER_USERSUBFORM := 100 
STATIC DEFINE USERSUBFORM_LOGON_NAME := 100 
