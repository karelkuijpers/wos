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


	oReport := PrintDialog{SELF,oLan:Get("Members"),,if(Admin=="WO",127,86),,"xls"}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	aYearStartEnd:=GetBalYear(Year(Today()),Month(Today()))
	YrSt:=aYearStartEnd[1]
	MnSt:=aYearStartEnd[2]
	cFields:= "p.persid,a.description,a.accnumber,m.*,group_concat(distinct ass.accnumber separator ',') as assacc"+;
	",group_concat(IF(d.desttyp<2,concat(cast(d.DESTAMT as char),if(d.desttyp=1,'%',''),' to ',d.DESTPP,' ',d.DESTACC),concat('Remaining to ',d.DESTPP,' ',d.DESTACC)) separator ',') as distr"
	 
	cFrom:="account as a, person as p,balanceitem as b, member as m left join memberassacc ma on (ma.mbrid=m.mbrid) left join account as ass on (ass.accid=ma.accid)"+;
	" left join distributioninstruction d on (d.mbrid=m.mbrid and d.disabled=0) " 

	oSel:=SQLSelect{"select "+cFields+" from "+cFrom+" where "+self:cWhere+" group by m.accid order by "+self:cOrder,oConn} 
	IF Lower(oReport:Extension) #"xls"
		cTab:=Space(1)
		kopregels :={oLan:Get('Members',,"@!"),' '}
	ENDIF

	//oLan:Get("Members",,"@!"),' ',;
	AAdd(kopregels, ;
		oLan:Get("Account",11,"!")+cTab+oLan:get("name",25,"!")+cTab+;
		IF(Admin=="WO",oLan:get("State",6,"!","C")+cTab+oLan:Get("home rate",10,"!","C")+cTab+;
		oLan:Get("HomePP",6,"!")+cTab+oLan:Get("HomeAccount",11,"!")+cTab+oLan:Get("HouseCd",7,"!")+cTab,"")+;
		PadL(AllTrim(oLan:Get("Budget",6,"!","R"))+Str(YrSt,4,0),11)+cTab+;
		oLan:Get("Associated accounts",37,"!","L")+;
		IF(oReport:Destination#"File","",;
		cTab+oLan:Get("Distribution Instructions",,"!")))

	IF oReport:Destination#"File"
		AAdd(kopregels,' ')
	ENDIF

	nRow := 0
	nPage := 0
	DO WHILE .not. oSel:EOF
		fBud:=GetPerBudget(YrSt,MnSt,12,@Gran,Str(oSel:accid,-1))		
		oReport:PrintLine(@nRow,@nPage,Pad(oSel:ACCNUMBER,11)+cTab+Pad(oSel:description,25)+cTab+;
			IF(Admin=="WO".or.Admin="HO",;
			PadC(iif(oSel:co=="M",oSel:Grade,"Entity"),6)+cTab+PadC(iif(Empty(oSel:OFFCRATE),"",oSel:OFFCRATE),10)+cTab+;
			Pad(oSel:HOMEPP,6)+cTab+Pad(iif(oSel:HOMEPP=sEntity,"",SubStr(oSel:HOMEACC,1,11)),11)+cTab+Pad(iif(oSel:co="M",oSel:householdid,''),7)+cTab,cTab)+Str(fBud,11,0)+cTab+;
			Pad(AllTrim(iif(Empty(oSel:assacc),"",oSel:assacc)),37) +;
			iif(oReport:Extension #"xls" .or. oSel:HOMEPP#SEntity,"",cTab+iif(Empty(oSel:Distr),"",oSel:Distr)),kopregels) 
		oSel:Skip()
	ENDDO
	//oSFMemberBrowser_DETAIL:Browser:RestoreUpdate()
	//oDB:GoTO(nCurRec)
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
