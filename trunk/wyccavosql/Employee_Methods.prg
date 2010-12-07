Function CheckPassword(cPW as string, Empid:=0 as int ) as logic 
	// check if given password is correct
	//
	// Empid: id of an existing employee; empty when new employee
	//	
	local oSys as SQLSelect
	LOCAL  lAlpha, lNum, lUpper, lLower as LOGIC
	local cErrorMsg, cNew as string
	local oEmp as SQLSelect 
	oSys:=SQLSelect{"select PSWRDLEN from sysparms",oConn}
	oSys:Execute()
	cPW:=AllTrim(cPW)
	IF Empty(cPW)
		ErrorBox{ , " Fill Password" }:Show()
		RETURN false
	ENDIF

	IF oSys:PSWRDLEN > Len(cPW)
		cErrorMsg:=" Minimum length of password is: "+Str(oSys:PSWRDLEN,1) 
	ENDIF
	SEval(cPW,{|x|iif(IsAlpha(CHR(x)),iif(IsUpper(CHR(x)),lUpper:=true,lLower:=true),lNum:=true)})
	if lUpper.or.lLower
		lAlpha:=true
	endif
	IF !(lAlpha.and.lNum)
		cErrorMsg+=iif(Empty(cErrorMsg),"",CRLF)+" Password should contain alphabetics and numerics"
	ENDIF

	IF !(lUpper.and.lLower)
		cErrorMsg+=iif(Empty(cErrorMsg),"",CRLF)+" Password should contain upper and lower case characters"
	ENDIF
	oSys:Close()
	if !Empty(Empid)
		oEmp:=SQLSelect{"select password,PSWPRV1,PSWPRV2,PSWPRV3 from employee where empid="+Str(Empid,-1),oConn}
		if oEmp:RecCount=1
			cNew:=HashPassword(Empid, cPW)
			IF cNew==oEmp:Password .or.;
					cNew==oEmp:PSWPRV1.or.;
					cNew==oEmp:PSWPRV2.or.;
					cNew==oEmp:PSWPRV3
				cErrorMsg+=iif(Empty(cErrorMsg),"",CRLF)+"You must enter a password different from a previous one!"
			ENDIF
		endif
	endif 

	if !Empty(cErrorMsg)
		ErrorBox{,cErrorMsg}:Show()
		RETURN false
	endif
	Return true
METHOD GetMenuItems(myType)  CLASS EditEmployeeWindow
	* get menu items corresponding with myType (A, F, P, M or empty==A)
	LOCAL aAllItems, aReturn:={} AS ARRAY
	LOCAL i AS INT
	Default(@myType,"A")
	aAllItems:=InitMenu(0,"")
	FOR i:=1 TO Len(aAllItems)
		IF !Empty(aAllItems[i,MEVENT])
			// 			IF aAllItems[i,MAUTH]>=myType .and.!aAllItems[i,MAUTH]="Z"
			IF (myType="A" .or.myType $ aAllItems[i,MAUTH]) .and.!aAllItems[i,MAUTH]="Z"
				AAdd(aReturn,{StrTran(aAllItems[i,MITEMTEXT],"&"),aAllItems[i,MACCEL]})
			ENDIF
		ENDIF
	NEXT
	RETURN aReturn
METHOD RegAccount(oRek,ItemName) CLASS EditEmployeeWindow
LOCAL oItem as ListViewItem

	IF !oRek==nil .and.oRek:reccount>0
		IF ItemName=="Allowed Accounts"
			oItem:=ListViewItem{}
			oItem:SetText(oRek:ACCNUMBER,#Number)
			oItem:SetValue(oRek:accid,#Number)
			oItem:SetText(oRek:description,#Name)
			oItem:SetValue(oRek:accid,#Name)
			self:oDCAlwdAcc:AddItem(oItem)
		ENDIF
	ENDIF
RETURN true
METHOD RegDepartment(myNum,myItemName) CLASS EditEmployeeWindow 
local oSel as SQLSelect
	Default(@myItemname,null_string)
	IF !myNum==self:WhoFrom
		self:WhoFrom:=myNum
		IF Empty(Val(self:WhoFrom))
			cCurDep:="0:"+sEntity+" "+sLand
			mDepartment:=cCurDep
			oDCmDepartment:TextValue:=cCurDep
		ELSE
			oSel:=SQLSelect{"select DEPTMNTNBR,DESCRIPTN from department where depid='"+myNum+"'",oConn} 
			if oSel:RecCount=1
				self:oDCmDepartment:TextValue:= oSel:DEPTMNTNBR+": "+ oSel:DESCRIPTN
				self:cCurDep:=AllTrim(oDep:DEPTMNTNBR)+":"+oDep:DESCRIPTN
				self:mDepartment:=cCurDep
			endif
		ENDIF
		self:ShowAllwdAcc()
	ENDIF
RETURN
METHOD RegPerson(oCLN) CLASS EditEmployeeWindow 
local myCln:=oCLN as SqlSelect
IF !Empty(oCLN)
	self:mCLN :=  Str(oCLN:persid,-1)
	self:cMemberName := GetFullName(self:mCLN)
	SELF:oDCmPerson:TEXTValue := SELF:cMemberName
ENDIF
RETURN TRUE	
function EvalCheckDigit() as logic
local cCheckEmp as string 
Local mChecpEmp as string
cCheckEmp:=CalcCheckDigit(oConn) 
mChecpEmp:= (SQLSelect{"select checkemp from sysparms",oConn}):CHECKEMP 

if !cCheckEmp== mChecpEmp
	return false
endif 
return true

                                                                                          
                                                                                          
FUNCTION GetUserMenu(cUserName as string) as logic
	* Determine menu array for given user
	LOCAL oEmp as SQLSelect
	LOCAL lFirstuse, logonOk:=true as logic,  cUser:=Lower(AllTrim(cUserName)) as string 
	local oSQL as SQLSelect, oStmt as SQLStatement 
	local cEmpStmnt as string
	IF Empty(cUser)
		return true
	endif
   cEmpStmnt:="select empid,"+Crypt_Emp(false,"persid")+" as persid,"+Crypt_Emp(false,"type") +" as mtype,"+Crypt_Emp(false,"depid")+" as mDepId from employee where "
	if Empty(MYEMPID)
		cEmpStmnt+= Crypt_Emp(false,"loginname")+'="'+cUser+'" and datediff(Now(),LSTUPDPW)<10000'
	else
		cEmpStmnt+='empid="'+MYEMPID+'"'
	endif
	oEmp:=SQLSelect{cEmpStmnt,oConn}
	oEmp:Execute() 
	IF !IsNil( oEmp:Status )
		LogEvent(,"Fout:"+oEmp:ErrInfo:ErrorMessage+"(Statement:"+cEmpStmnt+")")
	endif	
	if oEmp:RecCount=1
		if !EvalCheckDigit()
			ErrorBox{ , "Somebody has manipulated the Employee database. Restore it first from backup!" }:Show()
			logonOk:=false
		else
			oSQL:=SQLSelect{"select persid from person where persid="+oEmp:persid,oConn} 
			oSQL:Execute()
			If oSQL:RecCount=0
				ErrorBox{ , "Employee database corrupted. Restore it first from backup!" }:Show()
				logonOk:=false
			endif
		endif
		if logonOk
			LOGON_EMP_ID:=cUser
			MYEMPID := Str(oEmp:EmpId,-1)
			UserType:=oEmp:mTYPE
			aMenu:=InitMenu(oEmp:EmpId,UserType) 
			// record login date and set user online: 
			InitSystemMenu()
			cDepmntIncl:=SetDepFilter(Val(oEmp:mDepId))
			oMainWindow:SetCaption(SQLSelect{"select sysname from sysparms",oConn}:SYSNAME)
			cAccAlwd:=""
			if !Empty(cDepmntIncl)
				oSQL:=SQLSelect{"select accid from emplacc where empid='"+MYEMPID+"'",oConn} 
				oSQL:Execute()
				oSQL:GoTop()
				do while !oSQL:EoF
					cAccAlwd+=iif(Empty(cAccAlwd),"",",")+oSQL:ACCID 
					oSQL:Skip()
				enddo						
			endif
			oEmp:Close()
			oStmt:=SQLStatement{"update employee set online='1',lstlogin='"+SQLdate(Today())+" "+Time24()+"' where empid='"+MYEMPID+"'",oConn}
			oStmt:Execute()
		ENDIF
	else
		logonOk:=false
	endif
	RETURN logonOk 
Function IsFirstUse( ) as logic 
	// determine if this is the first use of the system
	IF SQLSelect{"select count(*) as total from Employee",oConn}:total='0' .and.;
		SQLSelect{"select count(*) as total from Person",oConn}:total='0' .and.;
		SQLSelect{"select count(*) as total from Account",oConn}:total='0' .and.;		
		SQLSelect{"select count(*) as total from Transaction",oConn}:total='0' 
		* first user:
		return true
	endif
	return false
function SaveCheckDigit() 
local oStmnt as SQLStatement
SQLStatement{"start transaction",oConn}:Execute()
SQLStatement{"select sysparms for update",oConn}:Execute()
oStmnt:= SQLStatement{'update sysparms set checkemp="'+CalcCheckDigit(oConn)+'"',oConn}
oStmnt:Execute()
if !Empty(oStmnt:Status)
	LogEvent(,"Error:"+oStmnt:Status:Description)
	SQLStatement{"rollback",oConn}:Execute()
else
	SQLStatement{"commit",oConn}:Execute()
endif 

 
function TYPEDescr(cType as string) as string 
local i as int
i:=AScan(USRTYpes,{|x|x[2]=cType})
if i>0
	return USRTypes[i,1]
endif
return null_string
