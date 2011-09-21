METHOD AccountSelect(Caller as object,BrwsValue:="" as string,ItemName as string,Unique:=false as logic ) as logic CLASS AccountBrowser
	local 
	self:oCaller := Caller
	IF Empty(Unique)
		self:lUnique := FALSE
	ELSE
		self:lUnique := true
	ENDIF 
	
	IF !Empty(BrwsValue)
		IF IsDigit(BrwsValue)
			self:SearchREK := BrwsValue
		ELSE
			self:SearchUni := BrwsValue
			self:oDCSearchUni:SetFocus()
		ENDIF
	ENDIF
	self:CallerName := ItemName
	self:Caption := "Select "+ItemName
	self:Server:GoTop()
	self:Show()
	if !Empty(BrwsValue)
		self:FindButton()
	endif
	RETURN true
METHOD FilePrint CLASS AccountBrowser
LOCAL oDB as SQLselect
LOCAL kopregels:={},aYearStartEnd as ARRAY
LOCAL nRow as int
LOCAL nPage as int
LOCAL oReport as PrintDialog
LOCAL cRootName:=AllTrim(SEntity)+" "+sLand as STRING
LOCAL cTab:=CHR(9) as STRING
LOCAL YrSt,MnSt as int
LOCAL Gran as LOGIC
local cFrom as string
local cFields as string

aYearStartEnd:=GetBalYear(Year(Today()),Month(Today()))
YrSt:=aYearStartEnd[1]
MnSt:=aYearStartEnd[2]

oReport := PrintDialog{self,oLan:RGet("Accounts"),,136,DMORIENT_LANDSCAPE,"xls"}

oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
IF Lower(oReport:Extension) #"xls"
	cTab:=Space(1)
	kopregels :={oLan:RGet('Accounts',,"@!"),' '}
ENDIF

AAdd(kopregels, ;
oLan:RGet("Number",LENACCNBR,"!")+cTab+oLan:RGet("Name",25,"!")+cTab+oLan:RGet("Rep.item",20,"!")+cTab+;
oLan:RGet("Gift",6,"!")+cTab+PadL(AllTrim(oLan:RGet("Budget",7,"!","R"))+Str(YrSt,4,0),11)+cTab+oLan:RGet("Subsc.pr",9,"!","R")+cTab+;
oLan:RGet("Mailcd",6,"!")+cTab+oLan:RGet("Currency",8,"!")+cTab+oLan:RGet("Multi",5,"!")+cTab+oLan:RGet("Reevl",5,"!")+cTab+if(Departments,oLan:RGet("Department",20,"!"),""))
IF oReport:Destination#"File"
	AAdd(kopregels,' ')
ENDIF
nRow := 0
nPage := 0 
cFrom:="balanceitem b, (account a"+iif(departments," left join department d on (a.department=d.depid)","") +")"+;
" left join budget bu on (bu.accid=a.accid and (bu.year*12+bu.Month) between "+Str(YrSt*12+MnSt,-1)+" and "+Str(YrSt*12+MnSt+12,-1) +")"
cFields:="a.*,b.Heading"+iif(Departments,",if(a.department,d.descriptn,'"+cRootName+"') as depname","") +",sum(bu.amount) as budgt"
oDB:=SQLSelect{"Select "+cFields+" from "+cFrom+" where "+self:cWhere+iif(Empty(self:cAccFilter),""," and "+self:cAccFilter)+" group by a.accid order by "+cOrder,oConn}
do WHILE .not. oDB:EOF
	oReport:PrintLine(@nRow,@nPage,Pad(oDB:ACCNUMBER,LENACCNBR)+cTab+Pad(oDB:description,25)+cTab+Pad(oDB:Heading,20,0)+cTab+;
	iif(ConI(oDB:giftalwd)=1,"X"," ")+Space(5)+cTab+Str(iif(Empty(oDB:Budgt),0,oDB:Budgt),11,0)+cTab;
	+Str(oDB:subscriptionprice,9,DecAantal)+cTab+PadC(oDB:clc,6)+cTab+PadC(oDB:Currency,8)+cTab+PadC( iif(ConI(oDB:MULTCURR)=1,"X"," "),5)+cTab+PadC( iif(ConI(oDB:REEVALUATE)=1,"X"," "),5)+cTab+Pad(iif(Departments,oDB:depname,cRootName),20),kopregels)
	oDB:skip()
ENDDO
oReport:prstart()
oReport:prstop()
RETURN self

METHOD NewButton CLASS AccountBrowser

	self:EditButton(true)
	
	RETURN nil
METHOD RegBalance(myNum) CLASS AccountBrowser
local oBal as SQLSelect
	Default(@myNum,null_string)
	IF Empty(myNum) .or. myNum='0'
		self:cCurBal:="0:Balance Items"
		self:WhatFrom:=''
	ELSE
		oBal:=SQLSelect{"select number,heading,balitemid from balanceitem where balitemid='"+myNum+"'",oConn} 
		IF oBal:RecCount>0
			self:cCurBal:=AllTrim(oBal:number)+":"+oBal:heading
			self:WhatFrom:=Str(oBal:balitemid,-1)
		ENDIF
	ENDIF
	self:oDCFromBal:TextValue:=self:cCurBal 
	self:FindButton()	
RETURN
 
METHOD RegDepartment(myNum,ItemName) CLASS AccountBrowser
	LOCAL depnr:="", deptxt:=""  as STRING
	local oDep as SQLSelect
	Default(@myNum,null_string)
	Default(@Itemname,null_string)
	IF Empty(myNum) .or. myNum='0'
		depnr:="0"
		deptxt:=sEntity+" "+sLand
	ELSE
		oDep:=SQLSelect{"select depid,descriptn  from department where depid="+myNum,oConn}
		if oDep:RecCount>0
			depnr:=Str(oDep:DEPID,-1)
			deptxt:=oDep:DESCRIPTN
		ENDIF
	ENDIF	
	IF ItemName == "From Department"
		self:WhoFrom:= depnr
		self:oDCFromDep:TextValue := deptxt
	ENDIF
	self:FindButton()	
RETURN
FUNCTION AccountSelect(oCaller as object,BrwsValue as string,ItemName as string,lUnique:=false as logic,cAccFilter:="" as string ,;
		oWindow:=null_object as Window,lNoDepartmentRestriction:=false as logic,oAccCnt:=null_object as AccountContainer) as logic
	* oWindow: to be used as owner of AccountBrowser
	/*
	oCaller:	object who calls this function; this object should have the method RegAccount
	BrwsValue:	Search value with which to find the account	
	ItemName:	Name to be show as type of account to search for (also used in regAccount to discriminate between different account types
	lUnique:		(optional) indicator if account has to be found unique , otherwise browse: false: always browse ; default false
	cAccFilter:	(optional) filter text to be applied on found accounts
	oAccP:		(optional) account server object; default a new server object is created
	oWindow:		(optional) to be used as owner of AccountBrowser; default: owner of caller
	lNoDepartmentRestriction:	(optional) normally only the accounts of the department of the employee will be selected, If this indocator is
	set, all accounts within cAccFilter will be shown.
	*/
	LOCAL oAccBw as AccountBrowser, oAcc as SQLSelect
	// 	LOCAL pFilter as _CODEBLOCK
	local cWhere:="a.balitemid=b.balitemid", myWhere as string
	local cOrder:="accnumber" as string
// 	local cFrom:="account as a,balanceitem as b" as string
	local cFrom:="balanceitem as b,account as a left join member m on (m.accid=a.accid or m.depid=a.department) left join department d on (d.depid=m.depid) " as string 

// 	local cFields:="a.accid,a.accnumber,a.description,a.department,a.balitemid,a.currency,b.category as type" as string
// 	local cFields:="a.*,b.category as type,m.co,m.persid as persid,"+SQLAccType()+" as accounttype"  as string
	local cFields:="a.accid,a.accnumber,a.description,a.department,a.balitemid,a.currency,a.multcurr,a.active, if(active=0,'NO','') as activedescr,a.subscriptionprice,b.category as type,m.co,m.persid as persid,"+SQLIncExpFd()+" as incexpfd,"+SQLAccType()+" as accounttype"  as string

	
	IF lUnique.and.Empty(BrwsValue)
		IF IsMethod(oCaller, #RegAccount)
			oCaller:RegAccount(null_object,ItemName)
		ENDIF
		RETURN true
	ENDIF
	myWhere:=cWhere
	if !Empty(BrwsValue)
		myWhere+=" and (accnumber like '"+AddSlashes(BrwsValue)+"%' or description like '"+AddSlashes(BrwsValue)+"%')" 
	endif
	if !lNoDepartmentRestriction .and.!Empty(cDepmntIncl)
		cAccFilter+=	iif(Empty(cAccFilter),""," and ")+"(department IN ("+cDepmntIncl+")"+;
		iif(ADMIN=="WA" .and. USERTYPE=="D".and.!Empty(cAccAlwd)," or a.accid in ("+cAccAlwd+")",'')+")"		
	endif
	IF lUnique
		oAcc:=SQLSelect{"Select "+cFields+" from "+cFrom+" where "+myWhere+iif(Empty(cAccFilter),""," and "+cAccFilter)+" order by "+cOrder,oConn}
		oAcc:Execute()
		if oAcc:RecCount=1 
			*	First try to find the account:
			IF IsMethod(oCaller, #RegAccount)
				oCaller:RegAccount(oAcc,ItemName)
			ENDIF
			RETURN true 
		endif
	ENDIF
	if Empty(oWindow) .and. IsObject(oCaller:Owner)
		oWindow:=oCaller:Owner
	endif 
	
	// 	Default(@oWindow,oCaller:Owner) 
	if Empty(oAccCnt)
		oAccCnt:=AccountContainer{}
	endif
	if Empty(oAccCnt:m51_description) .and. !Empty(BrwsValue)
		oAccCnt:m51_description:=BrwsValue
	endif
	oAccCnt:cFields:=cFields
	oAccCnt:cFrom:=cFrom
	oAccCnt:cWhere:=cWhere+iif(Empty(BrwsValue),''," and (accnumber like '"+AddSlashes(BrwsValue)+"%' or description like '%"+AddSlashes(BrwsValue)+"%')") 
	oAccCnt:cAccFilter:=cAccFilter
	oAccCnt:cOrder:=cOrder
	oAccBw := AccountBrowser{oWindow,,,{oCaller,oAccCnt}}
// 	if !Empty(BrwsValue)
// 		oAccBw:cWhere+=" and (accnumber like '"+BrwsValue+"%' or description like '"+BrwsValue+"%')" 
// 	endif
//  	oAccBw:cAccFilter:=cAccFilter
// 	oAccBw:cOrder:=cOrder
// 	oAccBw:oAcc:SQLString:="Select "+oAccBw:cFields+" from "+oAccBw:cFrom+" where "+cWhere+iif(Empty(cAccFilter),""," and "+cAccFilter)+" order by "+cOrder
// 	oAccBw:oAcc:Execute()
	oAccBw:Found:=Str(oAccBw:oAcc:RecCount,-1) 
	
	oAccBw:AccountSelect(oCaller,BrwsValue,ItemName,lUnique)
	
	RETURN FALSE // false means not directly found
Function AddSubBal(a_bal as array,ParentNum as int, nCurrentRec as int,aBalIncl ref array) as int
	* Find subdepartments and add to arrays with balance items
	local nSubRec as int
	local lFirst:=true as logic
	// reposition the customer server to the searched record
	nCurrentRec:=AScan(a_bal,{|x|x[2]==ParentNum},nCurrentRec+1)
	IF Empty(nCurrentRec)
		return nCurrentRec
	ENDIF
	AAdd(aBalIncl,a_bal[nCurrentRec,1])
	do WHILE nSubRec > 0 .or. lFirst
		lFirst:=false
		nSubRec:=AddSubBal(a_bal,a_bal[nCurrentRec,1],nSubRec,@aBalIncl)
	ENDDO	
	RETURN nCurrentRec
Function AddSubDep(d_dep as array,ParentNum as int, nCurrentRec as int,aDepIncl ref array) as int
	* Find subdepartments and add to arrays with departments
	local nSubRec as int
	local lFirst:=true as logic
	// reposition the customer server to the searched record
	nCurrentRec:=AScan(d_dep,{|x|x[2]==ParentNum},nCurrentRec+1)
	IF Empty(nCurrentRec)
		return nCurrentRec
	ENDIF
	AAdd(aDepIncl,d_dep[nCurrentRec,1])
	do WHILE nSubRec > 0 .or. lFirst
		lFirst:=false
		nSubRec:=AddSubDep(d_dep,d_dep[nCurrentRec,1],nSubRec,@aDepIncl)
	ENDDO	
	RETURN nCurrentRec
Function DeleteAccount(cAccId:="" as string ) as logic 
	* Delete a account occurrence
	LOCAL oTrans as SQLSelect
	LOCAL oMBal as Balances
	LOCAL oDep as SQLSelect
	Local oAcc as SQLSelect
	local oStmnt as SQLSTatement
	LOCAL oTextbox as TextBox
	local oLan as language
	
	if Empty(cAccId)
		return false
	endif
   oAcc:=SQLSelect{"select accnumber,description,department from account where accid="+cAccId,oConn}
   if oAcc:RecCount<1
   	return false
   endif 
   oLan:=Language{}
	oTextbox := TextBox{ , oLan:WGet("Delete Record"),;
		oLan:WGet("Delete Account")+" " + FullName( oAcc:ACCNUMBER,	oAcc:Description ) + "?",BUTTONYESNO + BOXICONQUESTIONMARK }
	
	IF ( oTextBox:Show() == BOXREPLYYES )
		// check if account belongs to a member: 
		oDep:=SQLSelect{"select m.mbrid from member m where m.accid="+cAccId,oConn}
		IF oDep:RecCount>0
			InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("This account belongs to a member")+"!"}:Show()
			RETURN FALSE
		ENDIF
		* Check if account net asset,income or expense of a department:
		IF !Empty(oAcc:Department)
			oDep:=SQLSelect{"select depid,descriptn from department where depid="+Str(oAcc:Department,-1)+ " and incomeacc="+cAccId+" or expenseacc="+cAccId+" or netasset="+cAccId,oConn}
			IF oDep:RecCount>0
				InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("This account is net asset, income or expense account of its department "+oDep:DESCRIPTN)+"!"}:Show()
				RETURN FALSE
			ENDIF
		ENDIF
		oTrans:=SQLSelect{"select count(*) as total from ("+UnionTrans("select t.transid from transaction t where accid="+cAccId)+") as tot",oConn}
		IF oTrans:RecCount>0 .and. ConI(oTrans:total)>0
			InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("Financial transactions associated with this account")+"!"}:Show()
			return false
		endif
		oMBal:=Balances{}
		oMBal:GetBalance(cAccId)
		IF !oMBal:per_cre - oMBal:per_deb==0
			InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("Balance not zero for this account")+"!"}:Show()
			return false
		endif
		// check if account not used as ROE-gain/loss:
		oAcc:=SQLSelect{"select accnumber from account where gainlsacc="+cAccId,oConn}
		if oAcc:RecCount>0
			InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("Account used as Exchange rate Gain/loss account in account")+" "+AllTrim(oAcc:ACCNUMBER)+"!"}:Show()
			return false
		endif
		// check if account used in standorderline:
		oAcc:=SQLSelect{"select stordrid from standingorderline where accountid="+cAccId,oConn}
		if oAcc:RecCount>0
			InfoBox { , oLan:WGet("Delete Record"),oLan:WGet("Account used in standing orders")+"!"}:Show()
			return false
		endif
		
		oStmnt:=SQLStatement{"delete from account where accid='"+cAccId+"'",oConn}
		oStmnt:Execute()							
		if oStmnt:NumSuccessfulRows>0
			* remove also corresponding subscriptions/donations: 
			oStmnt:SQLString:="delete from subscription where accid="+cAccId
			oStmnt:Execute()
			// remove corresponding balance years: 
			oStmnt:SQLString:="delete from accountbalanceyear where accid="+cAccId
			oStmnt:Execute()
			// remove also corresponding month balances: 
			oStmnt:SQLString:="delete from mbalance where accid="+cAccId
			oStmnt:Execute()
			// remove related telepattern too:
			oStmnt:SQLString:="delete from telebankpatterns where accid="+cAccId
			oStmnt:Execute()
			// remove related budget too: 
			oStmnt:SQLString:="delete from budget where accid="+cAccId
			oStmnt:Execute() 
		ENDIF
	ENDIF
	RETURN true

METHOD Commit() CLASS EditAccount
 	LOCAL oTextBox as TextBox
	IF .not. self:Server:Commit()
		oTextBox := TextBox{ self, "Changes discarded:",;
		"Changes discarded because somebody else has updated the person at the same time ";
	    	+ self:Server:Status:Caption +;
		":" + self:Server:Status:Description}		
		oTextBox:Type := BUTTONOKAY
		oTextBox:show()
		RETURN FALSE
	ENDIF
	RETURN true
	
METHOD FillBudget(Amount,pntr,aContr,BudMonth,BudYear) CLASS EditAccount
	// Fill mBud<pntr> with Amount and show it
	* aContr: array with control objects of the window
	LOCAL cNum as STRING
	LOCAL ic as int
	LOCAL x as Control
	LOCAL y as FixedText
	Default(@BudMonth,pntr)
	cNum:=Str(pntr,-1)
	IF Empty(aContr)
		aContr:= self:GetAllChildren()
	ENDIF
	IF (ic:=AScan(aContr,{|x|x:Name=="MBUD"+cNum}))>0
		x:=(aContr[ic])
		x:Show()
		x:Value:=Amount
		IF BudYear*12+BudMonth<Year(Mindate)*12+Month(Mindate)
			x:Disable()
		ELSE
			x:Enable()
		ENDIF
	ENDIF
	IF (ic:=AScan(aContr,{|x|x:Name=="TEXTBUD"+cNum}))>0
		y:=(aContr[ic])
		y:Show()
		y:TextValue:=SubStr(maand[(BudMonth+11)%12+1],1,3)+":"
	ENDIF
RETURN
METHOD FillBudgets() CLASS EditAccount
	// Fill all budgets for given balance year from database on window:
	LOCAL BudYear,BudMonth as int
  	LOCAL i as int
 	LOCAL BudAmnt,CurAmnt:=0.00 as FLOAT
	LOCAL MonthEqual:=true as LOGIC
	LOCAL aContr:={} as ARRAY

		// Lees budget uit database:
		BudYear:=Val(SubStr(self:oDCBalYears:Value,1,4))
		BudMonth:=Val(SubStr(self:oDCBalYears:Value,5,2))
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
		ELSE
			self:BudgetGranularity:="Month"
		ENDIF		
	
METHOD FillBudgetYear(aContr) CLASS EditAccount
	// fill yearbudget and hide month budgets
	LOCAL cNum as STRING
	LOCAL i,ic as int
	LOCAL x as Control
	LOCAL y as FixedText
	LOCAL YearAmnt:=0 as FLOAT
	IF Empty(aContr)
		aContr:= self:GetAllChildren()
	ENDIF
	// Jaarbedrag bepalen:
 	FOR i:=1 to 12
		cNum:=Str(i,-1)
 		IF (ic:=AScan(aContr,{|x|x:Name=="MBUD"+cNum}))>0
	 		x:=(aContr[ic])
			x:Hide()
	 		YearAmnt+=x:Value
	 	ENDIF
 		IF (ic:=AScan(aContr,{|x|x:Name=="TEXTBUD"+cNum}))>0
	 		y:=(aContr[ic])
			y:Hide()
	 	ENDIF
	NEXT
 	self:mBud1:=Round(YearAmnt,DecAantal)
 	self:oDCmBUD1:Show()
RETURN	
Method FillProprst() class EditAccount
local amProp as array
amProp:={} 
AEval(pers_propextra,{|x|AAdd(amProp,{PadR(x[1],30)+Space(20),x[2]})})
self:aProp:=amProp 
return

Method FillProps() class EditAccount
return self:aProp
METHOD GetBalYears() CLASS EditAccount
	// get array with balance years
	RETURN GetBalYears(3)
METHOD Import(apMapping,Checked)  CLASS EditAccount
	IF Checked
		lImportAutomatic:=FALSE
		self:oImport:lImportAutomatic:=FALSE
	ENDIF
	self:oImport:Import(self)
	
METHOD RegAccount(oRek,ItemName) CLASS EditAccount
	IF Empty(oRek).or.oRek:reccount<1
		RETURN
	ENDIF

	IF ItemName=="Gain/Loss account"
		//self:mGLAccount:=  AllTrim(oRek:description)
		self:oDCmGainLossacc:TEXTValue := AllTrim(oRek:Description)
		self:cCurGainLossAcc := AllTrim(oRek:Description)
		self:mGainLsacc := Str(oRek:accid,-1)
	ENDIF
	
RETURN true 
METHOD RegBalance(myNum) CLASS EditAccount
local oBal as SQLSelect
	Default(@myNum,null_string)
	IF !myNum==self:mNumSave
		self:mNumSave:=myNum
		IF Empty(self:mNumSave)
			self:cCurBal:="0:Balance Items"
		ELSE
			oBal:=SQLSelect{"select number,heading,category from balanceitem where balitemid='"+self:mNumSave+"'",oConn} 
			IF oBal:Reccount>0
				self:cCurBal:=AllTrim(oBal:NUMBER)+":"+oBal:Heading
				self:mSoort:=oBal:category 
				self:ShowCurrency()
			ENDIF
		ENDIF
		self:mBalitemid:=self:cCurBal
		self:oDCmBalitemid:TextValue:=self:cCurBal 
	ENDIF
RETURN
		
METHOD RegDepartment(myNum,myItemName) CLASS EditAccount
	local oDep as SQLSelect
	Default(@myItemName,null_string)
	Default(@myNum,null_string) 
	
	IF !myNum==self:mDep
		self:mDep:=myNum
		IF Empty(self:mDep)
			self:cCurDep:="0:"+sEntity+" "+sLand
			self:mDepartment:=self:cCurDep
			self:oDCmDepartment:TextValue:=self:cCurDep
		ELSE
			oDep:=SQLSelect{"select deptmntnbr,descriptn from department where depid='"+self:mDep+"'",oConn} 
			IF oDep:Reccount>0
				self:cCurDep:=AllTrim(oDep:DEPTMNTNBR)+":"+oDep:DESCRIPTN
				self:mDepartment:=self:cCurDep
				self:oDCmDepartment:TextValue:=self:cCurDep
			ENDIF
		ENDIF
	ENDIF
RETURN
METHOD ValidateAccount() CLASS EditAccount
	LOCAL lValid := true as LOGIC
	LOCAL cError,cLastname as STRING
	local oSel as SQLSelect
	self:mAccNumber:=AllTrim(self:mAccNumber)
	IF Empty(self:mAccNumber)
		lValid := FALSE
		cError := self:oLan:WGet("Account number is mandatory")+"!"
	ENDIF
	IF Val(self:mNumSave)=0
		IF Empty(self:mNum)
			cError := self:oLan:WGet("Number balancegroup is mandatory")+"!"
			lValid := FALSE
		ELSEif !self:lImport
			cError:=self:oLan:WGet("Root not allowed as balancegroup")+"!"
			lValid := FALSE
		ENDIF
	ELSEIF Empty(self:mDescription)
		lValid := FALSE
		cError := self:oLan:WGet("Description is mandatory")+"!"
	ENDIF
	if self:lMemberDep
		// account should contain lastname of corresponding member
		cLastname:=SQLSelect{"select lastname from person where persid="+self:mCln,oConn}:lastname
		if AtC(cLastname,self:oDCmDescription:TextValue) =0
			cError:=self:oLan:WGet('Description should contain lastname of corresponding member')+': "'+AllTrim(cLastname)+'" '
			lValid:=FALSE
			self:oDCmDescription:SetFocus()
		endif 
	endif

	IF lValid .and. self:mSubscriptionprice > 0 .and. self:mGIFTALWD
		lValid := FALSE
		cError := self:oLan:WGet("No gifts for subscriptions")
	ENDIF
	IF lValid .and. !(self:mCurrency==sCurr.or.Empty(self:mCurrency) )
		if self:mReevaluate .and.Empty(self:mGainLsacc)
			lValid := FALSE
			cError := self:oLan:WGet("Account for Exchange rate gain/loss is mandatory")+"!"
			self:oDCmGLAccount:SetFocus()
		endif
	ENDIF
	/*	IF lValid .and. mabp = 0 .and. !Empty(mClc)
	lValid := FALSE
	cError := "Mail code only for subscription accounts"
	ENDIF*/
	IF !lNew .and. !self:mAccNumber == AllTrim(oAcc:ACCNUMBER) .and. !self:Enabled
		IF (TextBox{self,self:oLan:WGet("Editing Account"),;
				self:oLan:WGet('Are you sure you whish to change the account number')+"? ("+self:oLan:WGet('Maybe confusing for your other coworkers')+')',;
				BOXICONQUESTIONMARK + BUTTONYESNO}):Show()= BOXREPLYNO
			RETURN FALSE
		ENDIF
	ENDIF
	if !lNew
		// check if currency changed:
		if !self:mCurrency== oAcc:Currency
			if !(self:mCurrency==sCurr .and. Empty(oAcc:Currency))
				if CurBal<>0
					(ErrorBox{self,self:oLan:WGet("You can not change currency when balance <> zero")}):Show()
					return false
				endif
			endif
			if self:mAccNumber== SHB .and. self:mCurrency # sCurr .and. self:mCurrency # "USD" 
				(ErrorBox{self,self:oLan:WGet("Only currencies USD and")+" "+sCurr+ " "+self:oLan:WGet("allowed for PMC Clearance account")}):Show()
				return false
			endif
		endif
	endif

	* Check if account allready exists:
	oSel:=SQLSelect{"select accid from account where accnumber='"+self:mAccNumber+"'"+iif(lNew,''," and accid<>'"+self:mAccId+"'"),oConn}
	if oSel:Reccount>0
		cError:=self:oLan:WGet("Account number")+" "+AllTrim(self:mAccNumber)+" "+self:oLan:WGet("allready exist")
		lValid:=FALSE
	ENDIF
	oSel:=SQLSelect{"select accid from account where description='"+AllTrim(self:mDescription)+"'"+iif(lNew,''," and accid<>'"+self:mAccId+"'"),oConn}
	if oSel:Reccount>0
		cError:=self:oLan:WGet('Account description')+'	"'+AllTrim(self:mDescription)+'" '+self:oLan:WGet('allready exist')
		lValid:=FALSE
	ENDIF
	IF!lNew .and.lValid
		cError:=ValidateAccTransfer(self:mNumSave,self:mAccId)
		IF !Empty(cError)
			lValid:=FALSE
		ENDIF
		if lValid
			cError:=ValidateDepTransfer(self:mDep,self:mAccId)
			IF !Empty(cError)
				lValid:=FALSE
			ENDIF		
		endif
	ENDIF
	
	IF ! lValid
		(ErrorBox{self,cError}):Show()
	ENDIF

	RETURN lValid
Function MakeFilter(aAccIncl:=null_array as array,aTypeAllwd:=null_array as array,IsMember:="B" as string,giftalwd:=2 as int,;
SubscriptionAllowed:=false as logic,aAccExcl:=null_array as array) as string
// make filter condition for account
// select from ARRAY AAccNot WITH accounts TO be excluded
// IsMember: M: member, N: not member, B: both (default), E: entity member(project)
// giftalwd: 1=true / 0=false/2: don't care
// SubscriptionAllowed: true/false
// aAccIncl: accounts to be included (id as string)
// aAccExcl: extra accounts to be excluded (id as string) 
// returns array with filter expression text
LOCAL cFilter, cType, cAcc, cIncl as STRING, i,j as int
// LOCAL bFilter as _CODEBLOCK
LOCAL aType:={"AK","PA","BA","KO"} as ARRAY
LOCAL aTypeAcc:={{SDEB,SKAS,SKRUIS,SHB},{SHB,SKAP,SPROJ},{SAM,SAMProj,SDON,SINC,SPROJ},{SEXP,SPOSTZ}} as ARRAY 
// if Empty(aTypeAllwd)
// 	aTypeAllwd:={"AK","PA","BA","KO"}
// endif
IF !Empty(aTypeAllwd)
	FOR i:=1 to Len(aTypeAllwd)
		j:=AScan(aType,aTypeAllwd[i])
		IF j>0 
			cType+=' or b.category="'+aType[j]+'"'        // function rejected in VO28
			AEval(aTypeAcc[j],{|x|cFilter+=iif(Val(x)=0,'',iif(AScan(aAccIncl,x)>0,'',' and a.accid<>'+x))})
		ENDIF
	NEXT
	IF !Empty(cType)
		cFilter+=' and ('+SubStr(cType,5)+')'
//		self:ForBlock:=SubStr(cType,5)
	ENDIF
// ELSE
// 	AEval(aAccExcl,{|x|cFilter+=iif(Val(x)=0,'',iif(AScan(aAccIncl,x)>0,'',' and a.accid<>'+x))})
ENDIF
AEval(aAccExcl,{|x|cAcc+=iif(Val(x)=0,'',iif(AScanExact(aAccIncl,x)>0,'',','+x))})
IF !Empty(cAcc)
	cFilter+=iif(Empty(cFilter),'',' and ')+"a.accid not in ("+SubStr(cAcc,2)+")"
ENDIF

IF !Empty(aAccIncl)
	AEval(aAccIncl,{|x|cIncl+=iif(Val(x)=0,'',iif(Empty(cIncl),"",' or ')+'a.accid='+x)})
ENDIF	
IF IsMember=="M"
	cFilter+=' and (a.accid in (select accid from member where accid IS NOT NULL) or a.department in (select depid from member where depid IS NOT NULL))'
ELSEIF IsMember=="N"
	cFilter+=' and a.accid not in (select accid from member where accid IS NOT NULL) and a.department not in (select depid from member where depid IS NOT NULL)'
ENDIF
IF giftalwd=0
	cFilter+=' and a.giftalwd<>1'
elseif giftalwd=1	
	cFilter+=' and a.giftalwd=1'
ENDIF
IF !SubscriptionAllowed
	cFilter+=' and a.subscriptionprice=0'
ENDIF	
IF SubStr(cFilter,1,5)==' and '
	cFilter:=SubStr(cFilter,6)
ENDIF
IF !Empty(cIncl)
	cFilter+=' or '+cIncl 
ENDIF
if !Empty(cFilter) 
	Return "("+cFilter +")"
else
	Return ''
endif
function SetAccFilter(WhatFrom as int) as string 
	// compose filter for balance items branch from given WhatFrom balitemid 
	LOCAL i,j			as int
	local a_bal:={},aBalIncl:={} as array
	local oBal as SQLSelect
	
	IF !Empty(WhatFrom)
		oBal:=SQLSelect{"select balitemid,balitemidparent from balanceitem order by balitemidparent,balitemid",oConn}
		if oBal:RecCount>0
			aBalIncl:={WhatFrom} 
			a_bal:=oBal:getlookuptable(1000) 
			do WHILE (i:=AddSubBal(a_bal,WhatFrom,i,@aBalIncl))>0
			ENDDO 
		endif
	endif
	return Implode(aBalIncl,",")
function SetDepFilter(WhoFrom as int) as string 
	// compose filter for department branch from given WhoFrom depid 
	LOCAL i,j			as int
	local d_dep:={},aDepIncl:={} as array
	local oDep as SQLSelect
	
	IF !Empty(WhoFrom)
		oDep:=SQLSelect{"select depid,parentdep from department order by parentdep,depid",oConn}
		if oDep:RecCount>0
			aDepIncl:={WhoFrom} 
			d_dep:=oDep:getlookuptable(1000) 
			do WHILE (i:=AddSubDep(d_dep,WhoFrom,i,@aDepIncl))>0
			ENDDO 
		endif
	endif
	return Implode(aDepIncl,",")
function SQLAccType() as string
// compose sql code for determining account type: of account a, member m:
// A=subscription
// F=invoice
// C=bankorder
// M=member
// G=project
// D=donation
// K=member department
	return ;
		"upper(if(a.subscriptionprice>0,'A',"+;                          // subscribtion
			"if(a.accid='"+SDEB+"','F',"+;              //invoice
				"if(a.accid='"+scre+"','C',"+;           // bankorder
					"if(a.giftalwd=1 and m.depid IS NULL,"+;
						"if(m.co IS NOT NULL and m.co<>'','M','G')"+;        // member, else project
					","+; // else
						"if(a.accid='"+SDON+"','D'"+;  // debitors, 
						","+;		//else 
							"if(m.depid=a.department,if(d.incomeacc=a.accid,'M','K'),'')"+;  // income account: member, else member department
						")"+;
					")"+;
				")"+;
			")"+;
		"))"

Function ValidateAccTransfer (cParentId as string,mAccId as string) as string 
	* Check if transfer of current account mAccId to another balance item with identifciation cParentid is allowed
	* Returns Error text if not allowed

	LOCAL oRB as SQLSelect
	LOCAL cNewClass, cError  as STRING
	LOCAL lValid:=true,lSucc as LOGIC
	LOCAL oAcc as SQLSelect, oMbr as SQLSelect  
	local oAccB as SQLSelect
	local oLan as Language 
	IF Empty(cParentId)
		oLan:=Language{}
		RETURN oLan:WGet("Root not allowed as parent of an account")
	ENDIF	

	* Member account .or. transactions for this account:
	* No change of balancegroupclassification allowed
	oRB:=SQLSelect{"select category from balanceitem where balitemid='"+cParentId+"'",oConn} 
	if oRB:RecCount=1	
		cNewClass:= oRB:category 
		oAcc:=SQLSelect{"select accnumber,b.balitemid,co,homepp,b.category from balanceitem as b, account as a left join member as m on (a.accid=m.accid) where a.accid='"+mAccId+"' and b.balitemid=a.balitemid",oConn}
		if oAcc:RecCount=1	
			IF	!oAcc:category== cNewClass
				IF	!(cNewClass	$ expense+income	.and.	oAcc:category $ expense+income .or. cNewClass $ asset+liability .and. oAcc:category $ asset+liability)
					oAccB:=SQLSelect{"select accid from accountbalanceyear where accid='"+mAccId+"' and (svjc-svjd)<>0.00",oConn}
					IF oAccB:RecCount>0
						if oLan==null_object 
							oLan:=Language{}
						endif
						cError:=oLan:WGet("Balancegroup of account")+" "+AllTrim(oAcc:ACCNUMBER)+" "+oLan:WGet('cannot be changed to different category after year closing')
						lValid:=FALSE
					ENDIF 
				ENDIF
			ENDIF
			IF	lValid .and.!Empty(oAcc:CO)	//	Member?
				cError:=ValidateMemberType( oAcc:CO,oAcc:HOMEPP,cNewClass)
				IF	!Empty(cError)
					lValid:=FALSE 
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	// ENDIF
	RETURN cError
Function ValidateDepTransfer (cDepartment as string,mAccId as string) as string 
	* Check if transfer of current account mAccId to another department with identifciation cDepartment is allowed
	* Returns Error text if not allowed

	LOCAL cError  as STRING
	LOCAL oAcc as SQLSelect  
	local oLan as Language 

	oAcc:=SQLSelect{"select d.deptmntnbr,d.descriptn,d.netasset,d.incomeacc,d.expenseacc from department d where d.incomeacc="+mAccId+" or d.expenseacc="+mAccId+" or d.netasset="+mAccId,oConn}
	if oAcc:Reccount>0 .and. Str(oAcc:depid,-1)<>cDepartment
		oLan:=Language{}
		cError:=oLan:WGet("Account is assigned to department")+': '+oAcc:deptmntnbr+' '+oAcc:descriptn+' '+oLan:WGet("as")+' '+iif(Transform(oAcc:netasset,"")==mAccId,;
		oLan:WGet("netasset account"),iif(Transform(oAcc:incomeacc,"")==mAccId,oLan:WGet("income account"),oLan:WGet("expense account"))) 
	endif
	return cError
