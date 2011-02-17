METHOD RegAccount(oAcc,ItemName) CLASS EditMember
LOCAL oItem AS ListViewItem

	IF Empty(oAcc) .or.oAcc:reccount<1
	else
		IF ItemName="Member Account"
			self:mRek :=  Str(oAcc:accid,-1)
			self:oDCmAccount:TEXTValue := AllTrim(oAcc:Description)
			self:cAccountName := AllTrim(oAcc:Description)
			self:cCurType:=oAcc:type
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
	LOCAL DestDesc AS STRING
	LOCAL nRow as int
	LOCAL nPage as int
	LOCAL oReport AS PrintDialog
	//LOCAL nCurRec:= oDB:RecNo
	LOCAL aDest as STRING
	LOCAL oSel as SQLSelect
	LOCAL cTab:=CHR(9) AS STRING
	LOCAL YrSt,MnSt AS INT
	LOCAL Gran AS LOGIC
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
	cFields:= "p.persid,a.description,a.accnumber,m.accid,m.grade,m.co,m.offcrate,m.homepp,m.homeacc,m.householdid,group_concat(distinct ass.accnumber separator ',') as assacc"+;
	",group_concat(IF(d.desttyp<2,concat(cast(d.destamt as char),if(d.desttyp=1,'%',''),' to ',d.destpp,' ',d.destacc),concat('Remaining to ',d.destpp,' ',d.destacc)) separator ',') as distr"
	 
	cFrom:="account as a, person as p,balanceitem as b, member as m left join memberassacc ma on (ma.mbrid=m.mbrid) left join account as ass on (ass.accid=ma.accid)"+;
	" left join distributioninstruction d on (d.mbrid=m.mbrid and d.disabled=0) "  
   cStatement:= "select y.*,sum(bu.amount) as budget from ("+;
	"select "+cFields+" from "+cFrom+" where "+self:cWhere+" group by m.accid ) as y"+;
	" left join budget bu on (bu.accid=y.accid and (bu.year*12+bu.month) between "+Str(YrSt*12+MnSt,-1)+" and "+Str(aYearStartEnd[3]*12+aYearStartEnd[4],-1)+") group by y.accid "+;
	" order by "+self:cOrder 
	LogEvent(self,cStatement,"logsql")
	oSel:=SQLSelect{cStatement,oConn} 
	IF Lower(oReport:Extension) #"xls"
		cTab:=Space(1)
		kopregels :={oLan:RGet('Members',,"@!"),' '}
	ENDIF

	//oLan:RGet("Members",,"@!"),' ',;
	AAdd(kopregels, ;
		oLan:RGet("Account",11,"!")+cTab+oLan:RGet("name",25,"!")+cTab+;
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
		oReport:PrintLine(@nRow,@nPage,Pad(oSel:ACCNUMBER,11)+cTab+Pad(oSel:description,25)+cTab+;
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
