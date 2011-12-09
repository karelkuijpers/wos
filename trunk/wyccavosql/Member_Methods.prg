METHOD RegBalance(myNum,myItemName) CLASS ConvertMembers
local oBal as SQLSelect
	Default(@myNum,null_string) 
	if myItemName=="Balance Item Expense"
		IF	!myNum==self:mBalExp
			self:mBalExp:=myNum
			IF	Empty(self:mBalExp)
				self:cCurExpBal:="0:Balance Items"
				self:expensecat:=''
			ELSE
				oBal:=SqlSelect{"select	number,heading,category	from balanceitem where balitemid='"+self:mBalExp+"'",oConn}	
				IF	oBal:reccount>0
					self:cCurExpBal:=AllTrim(oBal:NUMBER)+":"+oBal:Heading
					self:expensecat:=oBal:category 
				ENDIF
			ENDIF
			self:ExpenseBal:=self:cCurExpBal
			self:oDCExpenseBal:TextValue:=self:cCurExpBal
		ENDIF
	elseif myItemName=="Balance Item Income"
		IF	!myNum==self:mBalInc
			self:mBalInc:=myNum
			IF	Empty(self:mBalInc)
				self:cCurIncBal:="0:Balance Items"
				self:incomecat:=''
			ELSE
				oBal:=SqlSelect{"select	number,heading,category	from balanceitem where balitemid='"+self:mBalInc+"'",oConn}	
				IF	oBal:reccount>0
					self:cCurIncBal:=AllTrim(oBal:NUMBER)+":"+oBal:Heading
					self:incomecat:=oBal:category 
				ENDIF
			ENDIF
			self:IncomeBal:=self:cCurIncBal
			self:oDcIncomeBal:TextValue:=self:cCurIncBal 
		ENDIF
	endif
RETURN
		
METHOD RegDepartment(myNum,myItemName) CLASS ConvertMembers
	local oDep as SQLSelect
	Default(@myItemName,null_string)
	Default(@myNum,null_string) 
	
	IF !myNum==self:mParentDep
		self:mParentDep:=myNum
		IF Empty(self:mParentDep)
			self:cCurDep:="0:"+sEntity+" "+sLand
			self:ParentDep:=self:cCurDep
			self:oDCParentDep:TextValue:=self:cCurDep
		ELSE
			oDep:=SqlSelect{"select deptmntnbr,descriptn from department where depid='"+myNum+"'",oConn} 
			IF oDep:reccount>0
				self:cCurDep:=AllTrim(oDep:DEPTMNTNBR)+":"+oDep:DESCRIPTN
				self:ParentDep:=self:cCurDep
				self:oDCParentDep:TextValue:=self:cCurDep
			ENDIF
		ENDIF
	ENDIF
RETURN
METHOD RegAccount(oAcc,ItemName) CLASS EditDistribution

	IF Empty(oAcc) .or.oAcc:reccount<1
	else
		self:cAccountName := oAcc:ACCNUMBER
		self:mDestAcc := self:cAccountName
	ENDIF
RETURN true

METHOD RegAccount(oAcc,ItemName) CLASS EditMember
LOCAL oItem AS ListViewItem

	IF Empty(oAcc) .or.oAcc:reccount<1
	else
		IF ItemName="Member Account"
			self:mRek :=  Str(oAcc:accid,-1)
			self:oDCmAccDept:TEXTValue := AllTrim(oAcc:Description)
			self:cAccountName := AllTrim(oAcc:Description)
			self:cCurType:=oAcc:type 
			self:mDepid:=''
		ELSEIF ItemName=="Associated Accounts"
			oItem:=ListViewItem{}
			oItem:SetText(oAcc:ACCNUMBER,#Number)
			oItem:SetValue(Str(oAcc:accid,-1),#Number)
			oItem:SetText(oAcc:description,#Name)
			oItem:SetValue(oAcc:accid,#Name)
			SELF:oDCListViewAssAcc:AddItem(oItem)
		ENDIF
	ENDIF
RETURN TRUE

METHOD RegDepartment(myNum,myItemName) CLASS EditMember
	local oDep as SQLSelect
	Default(@myItemName,null_string)
	Default(@myNum,null_string) 
	
	oDep:=SQLSelect{"select deptmntnbr,descriptn from department where depid='"+myNum+"'",oConn} 
	IF oDep:reccount=1 
		self:mDepid:=AllTrim(myNum)
		self:mAccDept:=oDep:DESCRIPTN 
		self:cDepartmentName:=oDep:DESCRIPTN 
		self:mRek:=''
	else
		ErrorBox{self,self:olan:WGet("select a department")}:show()
	ENDIF
	RETURN
METHOD RegPerson(oCLN,ItemName) CLASS EditMember
IF !Empty(oCLN) .and. !IsNil(oCLN).and.!oCLN:EoF
	IF ItemName=="Member"
		self:mCLN :=  Str(oCLN:persid,-1)
		self:cMemberName := GetFullName(self:mCLN,0)
		self:oDCmPerson:TEXTValue := self:cMemberName
		
		self:mCod:=SQLSelect{"select mailingcodes from person where persid="+self:mCLN,oConn}:mailingcodes
	ELSE
		self:mCLNContact :=  Str(oCLN:persid,-1)
		self:cContactName := GetFullName(self:mCLNContact,0)
		SELF:oDCmPersonContact:TEXTValue := SELF:cContactName
	ENDIF
ENDIF
SELF:ShowStmntDest()
RETURN TRUE
METHOD Close( oE ) CLASS MemberBrowser

SELF:oSFMemberBrowser_DETAIL:Close()
SELF:oSFMemberBrowser_DETAIL:Destroy()
SELF:Destroy()
	RETURN NIL

METHOD FilePrint CLASS MemberBrowser
	LOCAL kopregels:={},aYearStartEnd as ARRAY
	LOCAL DestDesc as STRING
	LOCAL nRow as int
	LOCAL nPage as int
	LOCAL oReport as PrintDialog
	//LOCAL nCurRec:= oDB:RecNo
	LOCAL aDest as STRING
	LOCAL oSel as SQLSelect
	LOCAL cTab:=CHR(9) as STRING
	LOCAL YrSt,MnSt as int
	LOCAL Gran as LOGIC
	local cFrom as string
	local cFields as string
	local fBud as float
	local cStatement as string 


	oReport := PrintDialog{self,oLan:RGet("Members"),,if(Admin=="WO",127,86),,"xls"}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	aYearStartEnd:=GetBalYear(Year(Today()),Month(Today()))
	YrSt:=aYearStartEnd[1]
	MnSt:=aYearStartEnd[2]
	cFields:= "p.persid,a.accnumber,m.mbrid,a.accid,m.grade,m.co,m.offcrate,m.homepp,m.homeacc,m.householdid,d.deptmntnbr,"+;
	SQLFullName(0,"p")+" as membername,"+;
	"group_concat(distinct ass.accnumber separator ',') as assacc"+;
	",group_concat(IF(di.desttyp<2,concat(cast(di.destamt as char),if(di.desttyp=1,'%',''),' to ',di.destpp,' ',di.destacc),concat('Remaining to ',di.destpp,' ',di.destacc)) separator ',') as distr"
	 
	cFrom:="member as m left join memberassacc ma on (ma.mbrid=m.mbrid) left join account as ass on (ass.accid=ma.accid)"+;
	" left join distributioninstruction di on (di.mbrid=m.mbrid and di.disabled=0) left join department d on (m.depid=d.depid) "+;
	"left join account a on (a.accid=m.accid) "+;
	",person as p " 
   cStatement:= "select y.*,sum(bu.amount) as budget from ("+;
	"select "+cFields+" from "+cFrom+" where "+self:cWhere+" group by m.mbrid ) as y"+;
	" left join budget bu on (bu.accid=y.accid and (bu.year*12+bu.month) between "+Str(YrSt*12+MnSt,-1)+" and "+Str(aYearStartEnd[3]*12+aYearStartEnd[4],-1)+") group by y.mbrid "+;
	" order by "+self:cOrder 
	oSel:=SqlSelect{cStatement,oConn}
	LogEvent(self,oSel:sqlstring,"logSQL") 
	IF Lower(oReport:Extension) #"xls"
		cTab:=Space(1)
		kopregels :={oLan:RGet('Members',,"@!"),' '}
	ENDIF

	//oLan:RGet("Members",,"@!"),' ',;
	AAdd(kopregels, ;
		oLan:RGet("Number",11,"!")+cTab+oLan:RGet("name",25,"!")+cTab+;
		IF(Admin=="WO",oLan:RGet("State",6,"!","C")+cTab+oLan:RGet("home rate",10,"!","C")+cTab+;
		oLan:RGet("HomePP",6,"!")+cTab+oLan:RGet("HomeAccount",11,"!")+cTab+oLan:RGet("HouseCd",7,"!")+cTab,"")+;
		PadL(AllTrim(oLan:RGet("Budget",6,"!","R"))+Str(YrSt,4,0),11)+cTab+;
		oLan:RGet("Associated accounts",37,"!","L")+;
		IF(oReport:Destination#"File","",;
		cTab+oLan:RGet("Distribution Instructions",,"!")))

	IF oReport:Destination#"File"
		AAdd(kopregels,' ')
	ENDIF

	nRow := 0
	nPage := 0
	DO WHILE .not. oSel:EOF
		oReport:PrintLine(@nRow,@nPage,Pad(iif(Empty(oSel:deptmntnbr),oSel:ACCNUMBER,oSel:deptmntnbr),11)+cTab+Pad(oSel:membername,25)+cTab+;
			IF(Admin=="WO".or.Admin="HO",;
			PadC(iif(oSel:co=="M",oSel:Grade,"Entity"),6)+cTab+PadC(iif(Empty(oSel:OFFCRATE),"",oSel:OFFCRATE),10)+cTab+;
			Pad(oSel:HOMEPP,6)+cTab+Pad(iif(oSel:HOMEPP=sEntity,"",SubStr(oSel:HOMEACC,1,11)),11)+cTab+Pad(iif(oSel:co="M",oSel:householdid,''),7)+;
			cTab,cTab)+Str(iif(Empty(oSel:budget),0,oSel:budget),11,0)+cTab+;
			Pad(AllTrim(iif(Empty(oSel:assacc),"",oSel:assacc)),37) +;
			iif(oReport:Extension #"xls" .or. oSel:HOMEPP#SEntity,"",cTab+iif(Empty(oSel:Distr),"",oSel:Distr)),kopregels) 
		oSel:Skip()
	ENDDO
	oReport:prstart()
	oReport:prstop()
	RETURN nil
METHOD GoBottom() CLASS MemberBrowser
	RETURN SELF:oSFMemberBrowser_Detail:GoBottom()
METHOD GoTop() CLASS MemberBrowser
	RETURN SELF:oSFMemberBrowser_Detail:GoTop()
METHOD MarkUpDistribution(DestAcc,DestPP,Type,Amount) CLASS MemberBrowser
	// Markup text to print about a destribution instruction
	LOCAL DistrStr AS STRING
	IF !Empty(DestPP)
		IF Type==0 // fixed amount
			DistrStr:=AllTrim(Str(Amount))+" to "+AllTrim(DestPP)+;
			" "+AllTrim(DestAcc)+", "
		ELSEIF Type==1 // proportional amount
			DistrStr:=AllTrim(Str(Amount))+"% to "+AllTrim(DestPP)+;
			" "+AllTrim(DestAcc)+", "
		ELSE
			DistrStr:="Remaining to "+AllTrim(DestPP)+;
			" "+AllTrim(DestAcc)+", "
		ENDIF
	ENDIF
	RETURN DistrStr

METHOD NewButton CLASS MemberBrowser

	SELF:EditButton(TRUE)
	RETURN NIL
METHOD SkipNext() CLASS MemberBrowser

	SELF:oSFMemberBrowser_Detail:Browser:SuspendUpdate()

	SELF:oSFMemberBrowser_Detail:SkipNext()
	IF SELF:oSFMemberBrowser_Detail:Server:Eof
		SELF:SkipPrevious()
	ENDIF

	SELF:oSFMemberBrowser_Detail:Browser:RestoreUpdate()

	RETURN TRUE
METHOD SkipPrevious() CLASS MemberBrowser
	RETURN SELF:oSFMemberBrowser_Detail:SkipPrevious()

function ValidateMemberType(CO as string,HomePP as string, Type as string ) as string
	// check if member has account with correct type
	// returns errormesage if not correct
	local cError as string
	if CO=="M"  // member
		IF HomePP # Sentity .and. Type #"PA"
			cError := "Type of corresponding account of this not own member should be liability/fund"
		elseif Type #"PA" .and.Type #"BA"
			cError := "Type of corresponding account of this (non project)member should be liability/fund or income"
		endif
	else    // PP
		if !HomePP == Sentity .and.(Type #"PA" .and.Type #"AK") 
			cError := "Type of corresponding account of this not own entity should be liability/fund or asset"
		elseif HomePP = Sentity 
			// everything allowed
		endif
	endif
return cError
