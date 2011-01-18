DEFINE AG:=1
STATIC DEFINE amnt:=1
STATIC DEFINE AREAREPORT_AFSLDAG := 104 
STATIC DEFINE AREAREPORT_AFSLDAGTEXT := 103 
STATIC DEFINE AREAREPORT_BALANCETEXT := 102 
STATIC DEFINE AREAREPORT_CANCELBUTTON := 101 
STATIC DEFINE AREAREPORT_OKBUTTON := 100 
STATIC DEFINE ASKSEND_CANCELBUTTON := 100 
STATIC DEFINE ASKSEND_FIXEDTEXT1 := 102 
STATIC DEFINE ASKSEND_FIXEDTEXT2 := 103 
STATIC DEFINE ASKSEND_OKBUTTON := 101 
STATIC DEFINE ASKUPLD_CANCELBUTTON := 100 
STATIC DEFINE ASKUPLD_FIXEDTEXT2 := 103 
STATIC DEFINE ASKUPLD_OKBUTTON := 101 
STATIC DEFINE ASKUPLD_TEXTQESTION := 102 
RESOURCE BalanceReport DIALOGEX  37, 34, 371, 225
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Year under review:", BALANCEREPORT_FIXEDTEXT1, "Static", WS_CHILD, 16, 14, 70, 12
	CONTROL	"Start with month:", BALANCEREPORT_FIXEDTEXT2, "Static", WS_CHILD, 16, 36, 53, 12
	CONTROL	"", BALANCEREPORT_BALYEARS, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 85, 13, 88, 72
	CONTROL	"", BALANCEREPORT_MONTHSTART, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 85, 35, 33, 12, WS_EX_CLIENTEDGE
	CONTROL	"End with month:", BALANCEREPORT_FIXEDTEXT3, "Static", WS_CHILD, 16, 55, 53, 12
	CONTROL	"", BALANCEREPORT_MONTHEND, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 85, 54, 32, 13, WS_EX_CLIENTEDGE
	CONTROL	"", BALANCEREPORT_MBALNUMBER, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 85, 81, 93, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", BALANCEREPORT_BALBUTTON, "Button", WS_CHILD, 176, 81, 16, 13
	CONTROL	"With details of subitems?", BALANCEREPORT_WHATDETAILS, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 202, 81, 114, 12
	CONTROL	"", BALANCEREPORT_MDEPARTMENT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 85, 116, 93, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", BALANCEREPORT_DEPBUTTON, "Button", WS_CHILD, 176, 116, 16, 13
	CONTROL	"With details of subdepartments?", BALANCEREPORT_WHODETAILS, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 202, 116, 120, 12
	CONTROL	"With Numbers of all items", BALANCEREPORT_NUMBERS, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 85, 148, 97, 12
	CONTROL	"With explanation", BALANCEREPORT_IND_TOEL, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 85, 166, 80, 11
	CONTROL	"Condense", BALANCEREPORT_LCONDENSE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 85, 183, 80, 11
	CONTROL	"With account statements", BALANCEREPORT_IND_ACCSTMNT, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 85, 200, 80, 11
	CONTROL	"OK", BALANCEREPORT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 306, 5, 54, 12
	CONTROL	"Cancel", BALANCEREPORT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 307, 29, 53, 12
	CONTROL	"Down from:", BALANCEREPORT_FIXEDTEXT4, "Static", WS_CHILD, 14, 83, 40, 13
	CONTROL	"Balance Items:", BALANCEREPORT_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 72, 350, 29
	CONTROL	"Departments:", BALANCEREPORT_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 107, 350, 29
	CONTROL	"Down from:", BALANCEREPORT_FIXEDTEXT5, "Static", WS_CHILD, 14, 118, 40, 13
	CONTROL	"Options", BALANCEREPORT_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 70, 139, 116, 79
END

CLASS BalanceReport INHERIT DataWindowMine

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCBalYears AS COMBOBOX
	PROTECT oDCMONTHSTART AS SINGLELINEEDIT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCMONTHEND AS SINGLELINEEDIT
	PROTECT oDCmBalNumber AS SINGLELINEEDIT
	PROTECT oCCBalButton AS PUSHBUTTON
	PROTECT oDCWhatDetails AS CHECKBOX
	PROTECT oDCmDepartment AS SINGLELINEEDIT
	PROTECT oCCDepButton AS PUSHBUTTON
	PROTECT oDCWhoDetails AS CHECKBOX
	PROTECT oDCNumbers AS CHECKBOX
	PROTECT oDCind_toel AS CHECKBOX
	PROTECT oDClCondense AS CHECKBOX
	PROTECT oDCind_accstmnt AS CHECKBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCGroupBox3 AS GROUPBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	INSTANCE BalYears
	INSTANCE MONTHSTART
	INSTANCE MONTHEND
	INSTANCE mBalNumber
	INSTANCE WhatDetails
	INSTANCE mDepartment
	INSTANCE WhoDetails
	INSTANCE Numbers
	INSTANCE ind_toel
	INSTANCE lCondense
	INSTANCE ind_accstmnt
	PROTECT balsoort, cCurBal, cCurDep as STRING
	PROTECT BalCount, DepCount AS INT
	PROTECT oTransMonth AS AccountStatements

PROTECT hfdkop:={},;
		HeadingCache:={} AS ARRAY
PROTECT TAB:=" " as STRING, lXls as logic
PROTECT mbud  AS FLOAT
EXPORT oReport AS PrintDialog
EXPORT iLine,iPage AS INT
EXPORT BeginReport:=FALSE AS LOGIC
EXPORT YEARSTART,YEAREND AS INT
PROTECT BalSt, BalEnd, CurSt, CurEnd AS INT
* Options for report type:
//EXPORT WhatFrom:=Space(11), WhoFrom:=Space(11) AS STRING
EXPORT WhatFrom, WhoFrom as int
PROTECT BalColWidth, TotalWidth, maxlevel as int
EXPORT SendToMail AS LOGIC
EXPORT  netassBalId as int
EXPORT showopeningclosingfund:=FALSE as LOGIC 
Protect BoldOn, BoldOff, YellowOn, YellowOff, GreenOn, GreenOff, RedOn,RedOff,RedCharOn,RedCharOff as STRING 
Protect PrvYearNotClosed, YearBeforePrvNotClosed  as LOGIC 
export SimpleDepStmnt as logic
// Fiexed texts to print:
protect cSummary,cDirectText,cDirectOn,cIncome,cIncomeL,cExpense,cExpenseL,cLiability,cAsset,cDetailed,cInscriptionInEx,cInscriptionAsLi as string 
protect cFrom,cTo,cYear,cFullyear,cDescription,cPrvYrYTD,cCurPeriod,cYtD,cSurPlus,cClsBal,cClosingBal,cAmount,cBudget,cOpeningBal as string 
protect cNegative,cPositive as string


declare method SubDepartment, ProcessDepBal,SUBBALITEM,BalancePrint,AddSubDep,AddSubBal,SubNetDepartment
METHOD AddSubBal(ParentNum:=0 as int, nCurrentRec:=0 as int,aItem as array, level as int,r_indmain as array,r_parentid as array,r_balid as array,r_balnbr as array,r_cat as array,r_heading as array,r_footer) as int  CLASS BalanceReport
* Find subbalance items and add to arrays withbalance Items
	LOCAL nChildRec, iWidth, p	AS INT
	LOCAL nCurNum		as int 
	local oBal 			as SQLSelect
	local lFirst		as logic

	if Empty(aItem)
		oBal:=SQLSelect{"select * from balanceitem order by number",oConn} 
		if oBal:reccount>0
			do while !oBal:EoF
				AAdd(aItem,{oBal:balitemid,oBal:number,oBal:balitemidparent,oBal:category,oBal:Heading,oBal:Footer})   
				//                  1             2              3                  4             5            6
				oBal:Skip()
			enddo
		endif
	endif
	IF !Empty(nCurrentRec).and.!aItem[nCurrentRec,3]==ParentNum
		nCurrentRec:=0
	endif
	lFirst:=Empty(nCurrentRec)
	nCurrentRec:=AScan(aItem,{|x|x[3]==ParentNum},nCurrentRec+1)
	IF Empty(nCurrentRec)
		RETURN 0
	elseif lFirst.and.!Empty(ParentNum)
		r_indmain[Len(r_balid)]:=true		
	ENDIF
	IF level>25
		(ErrorBox{self:OWNER,self:oLan:WGet('Hierarchy of referred items too large or recursive')+":"+;
		oBal:number}):show()
		SELF:EndWindow()
	ENDIF
	// add sub balance item:
	nCurNum:= aItem[nCurrentRec,1]
	AAdd(r_balid,aItem[nCurrentRec,1])
	AAdd(r_balnbr,aItem[nCurrentRec,2])   // number
	AAdd(r_cat,aItem[nCurrentRec,4])  //category
	AAdd(r_parentid,aItem[nCurrentRec,3])   //balitemidparent
	AAdd(r_indmain,FALSE)
	AAdd(r_heading,if(Numbers,aItem[nCurrentRec,2]+self:TAB,"")+aItem[nCurrentRec,5])
	AAdd(r_footer,if(Numbers,aItem[nCurrentRec,2]+self:TAB,"")+aItem[nCurrentRec,6])
	p:=Len(r_heading)
	iWidth:=level*2+Max(Len(r_heading[p]),Len(r_footer[p]))
	IF iWidth>self:BalColWidth
		self:BalColWidth:=iWidth
	ENDIF
	if level> self:Maxlevel
		self:MaxLevel:=level
	endif

	// add all child balance items of this sub balance item:
	DO WHILE TRUE
		nChildRec:=self:AddSubBal(nCurNum, nChildRec,aItem, level+1,r_indmain,r_parentid,r_balid,r_balnbr,r_cat,r_heading,r_footer)
		IF Empty(nChildRec)
			EXIT
		ENDIF
	ENDDO
RETURN nCurrentRec
METHOD AddSubDep(ParentNum:=0 as int, nCurrentRec:=0 as int,aItem as array,d_dep as array,d_parentdep as array,d_indmaindep as array,d_depname as array,d_acc as array,d_netasset as array,d_netnum as array) as int CLASS BalanceReport
	* Find subdepartments and add to arrays with departments
	local oDep as SQLSelect
	LOCAL nChildRec	as int
	LOCAL nCurNum		as int
	local lFirst		as logic
	
	if Empty(aItem)
		oDep:=SQLSelect{"SELECT d.depid as itemid,d.parentdep as parentid,d.descriptn as description,d.deptmntnbr as number,d.netasset,an.balitemid "+;
		"FROM `department` d left join account an on(an.accid=d.netasset) order by d.deptmntnbr",oConn}
		if oDep:reccount>0
			do while !oDep:EoF
				AAdd(aItem,{oDep:itemid,oDep:parentid,oDep:description,oDep:number,oDep:NETASSET,oDep:balitemid}) 
				//           1                 2           3                4             5              6         
				oDep:Skip()
			enddo
		endif
	endif

	IF !Empty(nCurrentRec).and.!aItem[nCurrentRec,2]==ParentNum
		nCurrentRec:=0
	endif
	lFirst:=Empty(nCurrentRec)
	nCurrentRec:=AScan(aItem,{|x|x[2]==ParentNum},nCurrentRec+1)
	IF Empty(nCurrentRec)
		RETURN 0
	elseif lFirst
		*	ParentNum main item, i.e. used as parent of other department:
		d_indmaindep[Len(d_dep)]:=true
	ENDIF
	// add subdepartments:
	nCurNum:= aItem[nCurrentRec,1]
	AAdd(d_dep,aItem[nCurrentRec,1])
	AAdd(d_parentdep,aItem[nCurrentRec,2])
	AAdd(d_indmaindep,FALSE)
	AAdd(d_depname,iif(self:Numbers,aItem[nCurrentRec,4]+self:TAB,"")+aItem[nCurrentRec,3])
	AAdd(d_acc,{})
	AAdd(d_netasset,aItem[nCurrentRec,5])
	AAdd(d_netnum,aItem[nCurrentRec,6])
	do WHILE true	
		// add child records of this sub department:
		nChildRec:=self:AddSubDep(nCurNum,nChildRec,aItem,d_dep,d_parentdep,d_indmaindep,d_depname,d_acc,d_netasset,d_netnum)
		IF Empty(nChildRec)
			exit
		ENDIF
	ENDDO
	
	RETURN nCurrentRec
	

METHOD BalancePrint(FileInit:="" as string) as void pascal CLASS BalanceReport
	**********************************************************************************************
	*																							 *
	* 	Producing of balance report									 							 *
	*																							 *
	*	Down from department WhoFrom and only for balance items down from WhatFrom				 *
	*																							 *
	*	whodetails						¦ True	¦ True	¦ False	¦ False	¦						 *
	*	whatdetails						¦ False	¦ True	¦ False	¦ True	¦						 *
	*	------------------------------------------------¦---------------------------------------------------------------¦				 *
	*	explorer view depmt  			¦    x	¦		¦		¦		¦						 *
	*	heading dep.name incl parents  	¦		¦     x	¦    x	¦    x	¦						 *
	*	one line /depmt  				¦    x	¦		¦    x	¦   	¦						 *
	*																							 *
	*	FileInit: first line for output																						 *
	**********************************************************************************************
	*
	LOCAL aant_gev,rektel, i  AS INT
	LOCAL mType,m_cat:="",kop,m_accid,m_balId, cBalName as STRING
	LOCAL Totalize as LOGIC
	LOCAL BalYear,BalMonth as int
	LOCAL PrvYr_YtD as FLOAT
	LOCAL TopWhatPtr, TopWhoPtr AS INT
	LOCAL nCurRec, Bal_Ptr,Dep_Ptr,net_ptr,nCurAcc,nRecno as int
	LOCAL d_sort:={},accnts:={}, d_PrfLssPrYr:={} as ARRAY
	LOCAL lSaveWho, lSaveWhat AS LOGIC
	LOCAL YearGranularity as LOGIC 
	Local iLine:=self:iLine, iPage:=self:iPage as int 
	local aBalYr:={} as array 
	Local oAcc,oBal,oDep as SQLSelect
	local oMbal as balances 
	local aSQL:={} as array   // array with cFields,cFrom,cWhere and cGroup to retreive accounts with theier balances
	local aItem:={} as array  // temporary array with all department or balance items
	local cStatement as string   // string with selection of accounts and their total values 
// 	local aAcc:={} as array   // array with detail values of accounts
	* 	Arrays for balance items:
	LOCAL r_balid:={},;
		r_balnbr:={},;
		r_cat:={},;
		r_parentid:={},;
		r_indmain:={},;
		r_heading:={},;
		r_footer:={},;
		r_balpryrtot:={},;
		r_balPrYrYtD:={},;
		r_balPrvPer:={},;
		r_balPer:={},;
		r_bud:={},;
		r_budper:={},;
		r_budytd:={} as array

	* Arrays for departments:
	LOCAL	d_dep:={},;
		d_parentdep:={},;
		d_indmaindep:={},;
		d_depname:={},;
		d_PLdeb:={},;
		d_PLcre:={},;
		d_acc:={},;
		d_netasset:={},;
		d_netnum:={} as array

	* Arrays for values per department per balance item:
	LOCAL rd_BalPrvYr:={},;  // two dimenional array: X: department, Y: balance item
			rd_BalPrvYrYtD:={},;  // idem
			rd_BalPrvPer:={},;  // idem
			rd_BalPer:={},;  // idem
			rd_bud:={},;  // idem
			rd_budper:={},;  // idem
			rd_budytd:={} as array // idem
	// LOCAL BoldOn, BoldOff, YellowOn, YellowOff, GreenOn, GreenOff as STRING
	IF self:SendToMail
		BoldOn:="{\b "
		BoldOff:="}" 
		RedCharOn:="\cf1 "
		RedCharOff:="\cf0 "
		RedOn:= "\highlight1 "
		RedOff:="\highlight0 "
		YellowOn:="\highlight2 "
		YellowOff:="\highlight0 "
		GreenOn:="\highlight3 "
		GreenOff:="\highlight0 "
	else
		BoldOn:=""
		BoldOff:="" 
		RedCharOn:=""
		RedCharOff:=""
		RedOn:= ""
		RedOff:=""
		YellowOn:=""
		YellowOff:=""
		GreenOn:=""
		GreenOff:=""	
	ENDIF

	// Check input data:
	IF !ValidateControls( SELF, SELF:AControls )
		RETURN
	END

	aBalYr:=GetBalYear(Val(SubStr(BalYears,1,4)),Val(SubStr(BalYears,5,2)))
	self:YEARSTART:=aBalYr[1]
	BalYear:=YEARSTART
	BalMonth:= aBalYr[2]
	self:YEAREND:=aBalYr[3]
	IF BalMonth>aBalYr[4] // spanning two calendar years?
		IF self:MONTHSTART < BalMonth
			* apparently in next year:
			++self:YEARSTART
		ENDIF
		IF self:MONTHEND > aBalYr[4]
			* apperently in previous year:
			--self:YEAREND
		ENDIF
	ENDIF
	self:CurSt:=self:YEARSTART*12+self:MONTHSTART
	self:CurEnd:=self:YEAREND*12+MONTHEND
	self:BalSt:=BalYear*12+BalMonth
	self:BalEnd:=self:YEAREND*12+aBalYr[4]
	IF self:CurSt>self:CurEnd
		(ErrorBox{self:OWNER,self:oLan:WGet('Starting month must precede ending month')}):Show()
		RETURN
	ENDIF
	IF self:CurSt > self:BalEnd .or. self:CurSt < self:BalSt
		(ErrorBox{self:OWNER,self:oLan:WGet('Starting month out of range')}):Show()
		RETURN
	ENDIF
	IF self:CurEnd < self:BalSt .or. self:CurEnd > self:BalEnd
		(ErrorBox{self:OWNER,self:oLan:WGet('Ending month out of range')}):Show()
		RETURN
	ENDIF
	self:PrvYearNotClosed:=(self:BalSt>(Year(LstYearClosed)*12+Month(LstYearClosed)))
	self:YearBeforePrvNotClosed:=(self:BalSt-12>(Year(LstYearClosed)*12+Month(LstYearClosed)))
	iLine:=0
	iPage:=0
	TopWhatPtr:=0
	TopWhoPtr:=0
	IF Empty(skap)
		(ErrorBox{self:OWNER,self:oLan:WGet('Account for net assets not specified in system data')}):Show()
		SELF:EndWindow()
		RETURN
	ENDIF

	* Reading Departments and Balance Items:
	IF IsMethod(SELF,#StatusMessage)
		self:STATUSMESSAGE(self:oLan:WGet("Checking and collecting data, moment please"))
	ELSE
		IF IsAccess(SELF,#Owner)
			IF IsMethod(SELF:Owner,#StatusMessage)
				self:OWNER:STATUSMESSAGE(self:oLan:WGet("Checking and collecting balance data , moment please"))
			ENDIF
		ENDIF
	ENDIF
	SELF:Pointer := Pointer{POINTERHOURGLASS}


	* Check and fill requested Departments:
	IF Empty(self:WhoFrom)
		* Top department is WO Office:
		oAcc:= SQLSelect{"select balitemid from account where accid='"+skap+"'",oConn}
		if oAcc:reccount<1
			(ErrorBox{self:OWNER,self:oLan:WGet('Account for net assets not found')}):Show()
			self:EndWindow()
			RETURN 
		ENDIF
		netassBalId:=oAcc:balitemid
		AAdd(d_dep,0)
		AAdd(d_parentdep,nil)
		AAdd(d_indmaindep,if(Departments,true,FALSE))
		AAdd(d_depname,if(Numbers,"0"+self:TAB,"")+sEntity+" "+AllTrim(SLAND))
		AAdd(d_acc,{})
		AAdd(d_netasset,Val(SKAP))
		AAdd(d_netnum,self:netassBalId)
	ELSE
		oDep:=SQLSelect{"select d.parentdep,d.deptmntnbr,d.descriptn,d.depid,d.netasset,a.balitemid from department d left join account a on (a.accid=d.netasset) where depid='"+Str(self:WhoFrom,-1)+"'",oConn}
		if oDep:reccount>0
			AAdd(d_dep,oDep:DepId)
			AAdd(d_parentdep,oDep:ParentDep)
			AAdd(d_indmaindep,FALSE)
			AAdd(d_depname,if(Numbers,AllTrim(oDep:DEPTMNTNBR)+SELF:TAB,"")+AllTrim(oDep:Descriptn))
			AAdd(d_acc,{})
			AAdd(d_netasset,oDep:NETASSET)
			AAdd(d_netnum,oDep:balitemid)
		endif
	ENDIF

	* Add all subdepartments down from self:WhoFrom:  
	aItem:={}
	DO WHILE TRUE
		nCurRec:=self:AddSubDep(self:WhoFrom,nCurRec,aItem,d_dep,d_parentdep,d_indmaindep,d_depname,d_acc,d_netasset,d_netnum)
		IF Empty(nCurrec)
			EXIT
		ENDIF
	ENDDO
	*SELF:AddSubDep(self:WhoFrom)
	DepCount:=Len(d_dep)
	d_PLdeb:=AReplicate(0,DepCount)
	d_PLcre:=AReplicate(0,DepCount)
	d_PrfLssPrYr:=AReplicate(0,DepCount)

	* Fill all requested balance items:
	IF !Empty(self:WhatFrom) 
		oBal:=SQLSelect{"select * from balanceitem where balitemid='"+Str(self:WhatFrom,-1)+"'",oConn} 
		IF oBal:reccount>0
			* Add Top item:
			AAdd(r_balid,oBal:balitemid)
			AAdd(r_balnbr,AllTrim(oBal:number))  
			AAdd(r_cat,oBal:category)
			AAdd(r_parentid,oBal:balitemidparent)
			AAdd(r_indmain,FALSE)
			AAdd(r_heading,iif(self:Numbers,AllTrim(oBal:number)+self:TAB,"")+if(Empty(oBal:Heading),AllTrim(oBal:Footer),AllTrim(oBal:Heading)))
			AAdd(r_footer,iif(self:Numbers,AllTrim(oBal:number)+self:TAB,"")+AllTrim(oBal:Footer))
		ENDIF
	ENDIF
	* Add all child balance items:
	nCurRec:=0 
	aItem:={}
	DO WHILE TRUE
		nCurRec:=self:AddSubBal(self:WhatFrom,nCurRec,aItem,0,r_indmain,r_parentid,r_balid,r_balnbr,r_cat,r_heading,r_footer)
		IF Empty(nCurrec)
			EXIT
		ENDIF
	ENDDO
	self:BalCount:=Len(r_balid) 
	if self:BalCount=0
		(ErrorBox{self:OWNER,self:oLan:WGet('No report structure defined yet')}):Show()
		self:EndWindow()
		RETURN
	ENDIF
	
	self:BalColWidth:=Max(self:BalColWidth,24)
	self:TotalWidth:=self:BalColWidth+88 
	// self:Maxlevel++
	* Initialize value arrays with NILvalues:
	rd_BalPrvYr:=ArrayNew(DepCount,BalCount)
	rd_BalPrvPer:=ArrayNew(DepCount,BalCount)
	rd_BalPer:=ArrayNew(DepCount,BalCount)
	rd_BalPrvYrYtD:=ArrayNew(DepCount,BalCount)
	rd_bud:=ArrayNew(DepCount,BalCount)
	rd_budper:=ArrayNew(DepCount,BalCount)
	rd_budytd:=ArrayNew(DepCount,BalCount) 

	self:oReport:MaxWidth:=Max(self:oReport:MaxWidth,TotalWidth)
	// First time reinit:
	IF Len(self:oReport:oPrintJob:aFiFo)<2
		self:oReport:ReInitPrint(SendToMail)
	ENDIF
	IF !Empty(FileInit)
		AAdd(self:oReport:oPrintJob:aFiFo,FileInit)
		SELF:iLine := 0
	ENDIF
	self:STATUSMESSAGE(self:oLan:WGet("Producing report, moment please"))
	self:Pointer := Pointer{POINTERHOURGLASS}
	oMBal:=Balances{}
	oMbal:AccSelection:=iif(Empty(self:WhatFrom),"","a.balitemid in ("+Implode(r_balid,",")+")")+;
	iif(Empty(self:WhoFrom),"",iif(Empty(self:WhatFrom),""," and ")+"a.department in ("+Implode(d_dep,",")+")")
	cStatement:=oMbal:SQLGetBalance(self:YEARSTART*100+self:MONTHSTART,self:YEAREND*100+MONTHEND,;
	true,false,true,self:ind_toel)
	oAcc:=SQLSelect{cStatement,oConn}

	* Add balances of accounts to the balance item values: 
	oAcc:GoTop() 
	DO WHILE !oAcc:EOF
		Bal_Ptr:=AScan(r_balid,oAcc:balitemid) 
		m_accid:=Str(oAcc:accid,-1)
		IF Bal_Ptr=0
			*  No requested balance item:
			IF Empty(self:WhatFrom)  // total structure specified?
				SELF:Pointer := Pointer{POINTERARROW}
				(errorbox{self:OWNER,self:oLan:WGet('Not defined balance item in account')+':'+oAcc:AccNumber}):show()
				RETURN 
			ENDIF
			oAcc:Skip()
			LOOP
		ENDIF
		Dep_Ptr:=AScan(d_dep,oAcc:Department)
		IF Dep_Ptr=0
			* No requested department:
			IF Empty(self:WhoFrom)  // total hierarchy specified?
				SELF:Pointer := Pointer{POINTERARROW}
				(errorbox{self:OWNER,self:oLan:WGet('Not defined department in account')+':'+oAcc:AccNumber}):show()
				RETURN 
			ENDIF
			oAcc:Skip()
			LOOP
		ENDIF

		rd_BalPrvYr[Dep_Ptr,Bal_Ptr]:=if(Empty(rd_BalPrvYr[Dep_Ptr,Bal_Ptr]),0,rd_BalPrvYr[Dep_Ptr,Bal_Ptr])+oAcc:PrvYr_deb-oAcc:PrvYr_cre
		rd_BalPrvPer[Dep_Ptr,Bal_Ptr]  :=if(Empty(rd_BalPrvPer[Dep_Ptr,Bal_Ptr]),0,rd_BalPrvPer[Dep_Ptr,Bal_Ptr])+oAcc:PrvPer_deb-oAcc:PrvPer_cre +;
		 iif(oAcc:category=LIABILITY.or.oAcc:category=ASSET,oAcc:PrvYrYtD_deb-oAcc:PrvYrYtD_cre,0)  // add balance previous year
		rd_BalPer[Dep_Ptr,Bal_Ptr]  :=if(Empty(rd_BalPer[Dep_Ptr,Bal_Ptr]),0,rd_BalPer[Dep_Ptr,Bal_Ptr])+oAcc:per_deb - oAcc:per_cre
		rd_bud[Dep_Ptr,Bal_Ptr]     :=if(Empty(rd_bud[Dep_Ptr,Bal_Ptr]),0,rd_bud[Dep_Ptr,Bal_Ptr]) +oAcc:Yr_Bud
		rd_budper[Dep_Ptr,Bal_Ptr]  :=if(Empty(rd_budper[Dep_Ptr,Bal_Ptr]),0,rd_budper[Dep_Ptr,Bal_Ptr]) +oAcc:Per_Bud
		rd_budytd[Dep_Ptr,Bal_Ptr]  :=if(Empty(rd_budytd[Dep_Ptr,Bal_Ptr]),0,rd_budytd[Dep_Ptr,Bal_Ptr]) +oAcc:Per_Bud+oAcc:PrvPer_bud

		IF r_cat[Bal_Ptr]==INCOME  
			balsoort:='1'
		ELSEIF r_cat[Bal_Ptr]==EXPENSE
			balsoort:='2'
		ELSEIF r_cat[Bal_Ptr]==ASSET
			balsoort:='3'
		ELSE
			balsoort:='4'
		ENDIF
		cBalName:=r_heading[Bal_Ptr]
		IF Empty(cBalName)
			cBalName:=r_footer[Bal_Ptr]
		ENDIF
		AAdd(d_acc[Dep_Ptr],balsoort+Pad(cBalName,25)+Str(oAcc:balitemid,11,0)+Str(oAcc:recno,11,0)+"P")
		* 	When previous year not yet closed calculated sum of all income and expense accounts uptill end of previous year
		* 	and add it to the corresponding netasset accounts (because not yet added by year balancing)
		IF balsoort == '1' .or. balsoort == '2'
			IF self:PrvYearNotClosed
				d_PLdeb[Dep_Ptr]:=Round(if(IsNil(d_PLdeb[Dep_Ptr]),0,d_PLdeb[Dep_Ptr]) + oAcc:PL_deb,DecAantal)
				d_PLcre[Dep_Ptr]:=Round(if(IsNil(d_PLcre[Dep_Ptr]),0,d_PLcre[Dep_Ptr]) + oAcc:PL_cre,DecAantal)
				IF YearBeforePrvNotClosed
					* When year before previous year also not closed do the same for net assets account balances of previous year
					d_PrfLssPrYr[Dep_Ptr]:=Round(if(IsNil(d_PrfLssPrYr[Dep_Ptr]),0,d_PrfLssPrYr[Dep_Ptr]) + oAcc:PrvYrPL_deb - oAcc:PrvYrPL_cre,DecAantal)
				ENDIF
			ENDIF
		ENDIF
		// 		oMbal:GetBalance(m_accid,oAcc:category,(self:YEARSTART-1)*100+self:MONTHSTART,(self:YEAREND-1)*100+MonthEnd) && zelfde periode een jaar eerder
		rd_BalPrvYrYtD[Dep_Ptr,Bal_Ptr]:=if(Empty(rd_BalPrvYrYtD[Dep_Ptr,Bal_Ptr]),0,rd_BalPrvYrYtD[Dep_Ptr,Bal_Ptr])+oAcc:PrvYrYtD_deb - oAcc:PrvYrYtD_cre
		if oAcc:recno%50=1
			nCurAcc:=nCurAcc
		endif
		oAcc:skip()
	ENDDO

	* When previous year not closed add sum of profit/loss previous year to netasset accounts
	IF self:PrvYearNotClosed
		self:SubNetDepartment(1,d_parentdep,d_dep,d_PLdeb,d_PLcre,d_netnum,r_balid,rd_BalPer,rd_BalPrvYr,rd_BalPrvYrYtD,rd_BalPrvPer,;
		rd_bud,rd_budper,rd_budytd,d_PrfLssPrYr)
	ENDIF

	********************************************************************************************************************************************************************
	*                                                                                                                                                                                                                                                                              *
	* Printing of balance items starting with hierarchily top item self:WhatFrom:                                                                                                                            *
	*                                                                                                                                                                                                                                                                              *
	********************************************************************************************************************************************************************
	*
	self:STATUSMESSAGE(self:oLan:WGet("Printing summary")) 
	// prefill fixed textes:
   self:cSummary:=oLan:Get("SUMMARY",,"@!")
   self:cDirectText:=oLan:Get("Direct Records",,"!")
   self:cDirectOn:=oLan:Get("Direct on",,"!") 
   self:cIncome:= oLan:Get('INCOME',,"@!") 
   self:cIncomeL:=oLan:Get('Income',13,"!","R")
   self:cExpense:=oLan:Get('EXPENSE',,"@!") 
   self:cExpenseL:=oLan:Get('Expense',11,"!","R")
   self:cLiability:=oLan:Get('LIABILITIES AND FUNDS',,"@!")
   self:cAsset:=oLan:Get('ASSET',,"@!")
   self:cDetailed:=oLan:Get('DETAILED',,"@!")
   self:cInscriptionInEx:=oLan:Get('INCOME AND EXPENSE',,"@!")
	self:cInscriptionAsLi:=oLan:Get('BALANCE SHEET',,"@!")
	self:cFrom:=oLan:Get('from',6)
	self:cTo:=oLan:Get('to',5,,'C')
	self:cYear:=oLan:Get('Year',7,"!","L") 
	self:cFullyear:=oLan:Get('FULL YEAR',21,"@!","C")
	self:cDescription:=oLan:Get('Description',iif(lXls,24,self:BalColWidth),"!")+iif(lXls,Replicate(self:TAB,self:MaxLevel),"")
	self:cPrvYrYTD:=oLan:get('PREVIOUS YEAR TO DATE',21,'@!','R')
	self:cCurPeriod:=oLan:Get('CURRENT PERIOD',15,"@!","R")
	self:cYtD:=oLan:Get('YEAR TO DATE',20,"@!","R")
	self:cSurPlus:=oLan:Get('Surplus',9,"!","R")
	self:cClsBal:=oLan:Get('Cls.Balance',11,"!","R")
	self:cClosingBal:=oLan:Get('CLOSING BALANCE',,"!")
	self:cAmount:=oLan:Get('Amount',11,"!","R") 
	self:cBudget:=oLan:Get('Budget-%',8,"!","R")
	self:cOpeningBal:=Pad(oLan:Get('OPENING FUND BALANCE',,"!"),BalColWidth+iif(self:SimpleDepStmnt,2,46))
	self:cNegative:=oLan:Get('Negative',,"!")
	self:cPositive:=oLan:Get('Posative',,"!")

	hfdkop:=self:prkop(self:cSummary,r_cat[1],1,,d_dep,d_parentdep,d_depname,;
		r_balid,r_heading,r_footer,r_parentid)
	hfdkop[1]:= BoldOn+YellowOn+ hfdkop[1]+YellowOff+BoldOff

	SELF:SubDepartment(1,0,d_netnum,d_indmaindep,d_depname,d_parentDep,d_dep,;
		r_cat,r_balpryrtot,r_balPrYrYtD,r_balPrvPer,r_balPer,r_indmain,r_parentid,;
		r_heading,r_footer,r_balnbr,r_balid,r_bud,r_budper,r_budytd,;
		rd_BalPrvYr,rd_BalPrvYrYtD,rd_BalPrvPer,rd_BalPer,rd_bud,rd_budper,rd_budytd,@iLine,@iPage)

	* Toelichting op de balans afdrukken:
	IF ind_toel
		self:STATUSMESSAGE(self:oLan:WGet("Printing details, moment please"))
		* reset What/Who:
		lSaveWhat:=WhatDetails
		lsaveWho:=WhoDetails
		self:WhatDetails:=true
		self:WhoDetails:=true
		* Enforce order on department name:
		FOR i:=1 TO DepCount
			AAdd(d_sort,{Upper(d_depName[i]),i})
		NEXT
		ASort(d_sort,,,{|x,y| x[1]<=y[1]})
		FOR i:= 1 TO DepCount
			Dep_Ptr:=d_Sort[i,2]
			accnts:=d_acc[Dep_Ptr]
			ASort(accnts)
			m_balId:=Space(11)
			mType:=' '
			Totalize:=FALSE
			aant_gev:=0
			FOR rektel=1 to Len(accnts)
				IF SubStr(accnts[rektel],27,11) # m_balId
					IF Totalize
						IF aant_gev>1
							self:prtotaal(m_cat,@iLine,@iPage)
							self:prAmounts(m_cat,rd_BalPrvYr[Dep_Ptr,Bal_Ptr],;
								rd_BalPrvYrYtD[Dep_Ptr,Bal_Ptr],;
								rd_BalPrvPer[Dep_Ptr,Bal_Ptr],rd_BalPer[Dep_Ptr,Bal_Ptr],;
								rd_bud[dep_ptr,bal_ptr],rd_budper[dep_ptr,bal_ptr],rd_budytd[dep_ptr,bal_ptr],0,r_footer[bal_ptr],r_heading,0.00,0.00,@iLine,@iPage)
						ENDIF
					ENDIF
					IF SubStr(accnts[rektel],1,1) # mType
						mType:=SubStr(accnts[rektel],1,1)
						IF mType='1'
							m_cat:=INCOME
							kop:=self:cIncome
						ELSEIF mType='2'
							m_cat:=EXPENSE
							kop:=self:cExpense
						ELSEIF mType='3'
							m_cat:=ASSET
							kop:=self:cAsset
						ELSE
							m_cat:=LIABILITY 
							kop:=self:cLiability
						ENDIF
						hfdkop:=self:prkop(self:cDetailed,m_cat,Dep_Ptr,,d_dep,d_parentdep,d_depname,;
							r_balid,r_heading,r_footer,r_parentid)
						iLine:=0  && forceer iPageskip 
						self:oReport:PrintLine(@iLine,@iPage,kop,hfdkop,0)
					ENDIF
					m_balId:=SubStr(accnts[rektel],27,11)
					Bal_Ptr:=AScan(r_balid,Val(m_balId))
					aant_gev:=0
				ENDIF
// 				m_accid:=SubStr(accnts[rektel],27+11,11)
// 				oMbal:GetBalance(m_accid,m_cat,(self:YEARSTART-1)*100+self:MONTHSTART,(self:YEAREND-1)*100+MonthEnd) && zelfde periode een jaar eerder
				nRecno:=Val(SubStr(accnts[rektel],27+11,11))
				oAcc:GoTo(nRecno)
				m_accid:=Str(oAcc:accid,-1)
				PrvYr_YtD:=oAcc:PrvYrYtD_deb - oAcc:PrvYrYtD_cre
// 				PrYr_BalPrvPer:=oAcc:PrvPer_deb-oAcc:PrvPer_cre
// 				oMbal:GetBalance(m_accid,m_cat,self:YEARSTART*100+self:MONTHSTART,self:YEAREND*100+MonthEnd)  && bal jaar
				IF !lCondense.or.!PrvYr_YtD=0.or.!(oAcc:PrvPer_deb=oAcc:PrvPer_cre).or.!(oAcc:per_deb=oAcc:per_cre)
					//SELF:StatusMessage("Printing details:"+oAcc:ACCNUMBER)
					IF Empty(aant_gev)
						Totalize:=true
						self:oReport:PrintLine(@iLine,@iPage,' ',hfdkop,1)
						*					self:oReport:PrintLine(@iLine,@iPage,r_footer[Dep_Ptr,Bal_Ptr],hfdkop,0)
						self:oReport:PrintLine(@iLine,@iPage,r_heading[Bal_Ptr],hfdkop,0)
					ENDIF
					self:prAmounts(m_cat,oAcc:PrvYr_deb-oAcc:PrvYr_cre,PrvYr_YtD,;
						oAcc:PrvPer_deb-oAcc:PrvPer_cre,oAcc:per_deb-oAcc:per_cre,;
						oAcc:Yr_Bud,oAcc:Per_Bud,oAcc:PrvPer_bud+oAcc:Per_Bud,;
						1,if(self:Numbers,oAcc:AccNumber+self:TAB,"")+oAcc:description,r_heading,0.00,0.00,@iLine,@iPage) 
					++aant_gev
					/*		ELSE
					// save printing=false in accnts:
					accnts[rektel]=SubStr(accnts[rektel],1,32)+"N" */
				ENDIF
			NEXT
			IF Totalize .and. aant_gev>1
				self:prtotaal(m_cat,@iLine,@iPage)
				self:prAmounts(m_cat,rd_BalPrvYr[Dep_Ptr,Bal_Ptr],;
					rd_BalPrvYrYtD[Dep_Ptr,Bal_Ptr],;
					rd_BalPrvPer[Dep_Ptr,Bal_Ptr],rd_BalPer[Dep_Ptr,Bal_Ptr],;
					rd_bud[Dep_Ptr,Bal_Ptr],rd_budper[Dep_Ptr,Bal_Ptr],rd_budytd[Dep_Ptr,Bal_Ptr],1,r_footer[Bal_Ptr],r_heading,0.00,0.00,@iLine,@iPage)
				self:oReport:PrintLine(@iLine,@iPage,' ',hfdkop,1)
				self:oReport:PrintLine(@iLine,@iPage,' ',hfdkop,0)
			ENDIF
			iLine:=0  && forceer bladskip		
		NEXT
		self:WhatDetails:=lSaveWhat
		self:WhoDetails:=lSaveWho
	ENDIF
	SELF:Pointer := Pointer{POINTERARROW}
	* Reset arrays to free memory:
	r_balid:={}
	r_balnbr:={}
	r_cat:={}
	r_parentid:={}
	r_indmain:={}
	r_heading:={}
	r_footer:={}
	d_dep:={}
	d_depname:={}
	d_parentdep:={}
	d_indmaindep:={}
	d_PLdeb:={}
	d_PLcre:={}
	d_PrfLssPrYr:={}
	d_acc:={}
	d_netasset:={}
	d_netnum:={}
	rd_BalPrvYr:={}
	rd_BalPrvYrYtD:={}
	rd_BalPrvPer:={}
	rd_BalPer:={}
	rd_bud:={}
	rd_budper:={}
	rd_budytd:={}
	accnts:={}
	d_sort:={}
	CollectForced()
	self:iLine:=iLine
	self:iPage:=iPage

	RETURN
METHOD BalButton( ) CLASS BalanceReport
	LOCAL cBalValue AS STRING
	LOCAL nPntr AS INT

	cBalValue:=AllTrim(oDCmBalNumber:TextValue)
	nPntr:=At(":",cBalValue)
	IF nPntr>1
		cBalValue:=SubStr(cBalValue,1,nPntr-1)
	ENDIF
	(BalanceItemExplorer{self:OWNER,"Balance Item",str(self:WhatFrom,-1),self,cBalValue}):show()
RETURN NIL
METHOD BalFishTot(Type,aTot) CLASS BalanceReport
	// determine totals of income and expense or of assets and liabilities and funds
	// Type:	I: income and expense
	//	 		B: assest and libilities
	// aTot: array with per element: type amount (KO,BA,PA,AK), level, amount
	//
	// Returns {amount income, amount expense} or {amount assets, amount liiability}
	//
LOCAL fAmnt1, fAmnt2 AS FLOAT
LOCAL i,j,Ind1,Ind2 AS INT
LOCAL typ1,typ2 AS STRING
IF Type="I"
	typ1:="KO"
	typ2:="BA"
ELSE
	typ1:="PA"
	typ2:="AK"
ENDIF		
IF !Empty(aTot)
	Ind1:=AScan(aTot,{|x| x[1]=typ1})
	Ind2:=AScan(aTot,{|x| x[1]=typ2})

	IF Empty(Ind1)
		IF !Empty(Ind2)
			fAmnt2:=SELF:BalTot(aTot,typ2,aTot[Ind2,2],Ind2)
		ENDIF
	ELSE
		IF Empty(Ind2)
			fAmnt1:=SELF:BalTot(aTot,typ1,aTot[Ind1,2],Ind1)
		ELSE
			IF aTot[Ind1,2]=aTot[Ind2,2]   // identical levels?
				fAmnt1:=SELF:BalTot(aTot,typ1,aTot[Ind1,2],Ind1)
				fAmnt2:=SELF:BalTot(aTot,typ2,aTot[Ind2,2],Ind2)
			ELSEIF aTot[Ind1,2]>aTot[Ind2,2]
				fAmnt1:=SELF:BalTot(aTot,typ1,aTot[Ind1,2],Ind1)
				Ind2:=AScan(aTot,{|x|x[1]=typ2 .and. x[2]=aTot[Ind1,2]}) // search corresponing level
				IF Ind2=0
					fAmnt2:=0
				ELSE
					fAmnt2:=SELF:BalTot(aTot,typ2,aTot[Ind2,2],Ind2)
				ENDIF
			ELSE
				fAmnt2:=SELF:BalTot(aTot,typ2,aTot[Ind2,2],Ind2)
				Ind1:=AScan(aTot,{|x|x[1]=typ1 .and. x[2]=aTot[Ind2,2]}) // search corresponing level
				IF Ind1=0
					fAmnt1:=0
				ELSE
					fAmnt1:=SELF:BalTot(aTot,typ1,aTot[Ind1,2],Ind1)
				ENDIF
			ENDIF
		ENDIF
	ENDIF
ENDIF
RETURN {fAmnt2, fAmnt1}
METHOD BalTot(aTot,Type,level, start) CLASS BalanceReport
	// sum all values of same type and level
	LOCAL i:=start AS INT, fAmnt AS FLOAT
	
	FOR i:=start TO Len(aTot)
		IF aTot[i,1]#Type .or. aTot[i,2]#level
			EXIT
		ENDIF
		fAmnt+=aTot[i,3]
	NEXT
	RETURN Round(fAmnt,decaantal)
access BalYears() class BalanceReport
return self:FieldGet(#BalYears)

assign BalYears(uValue) class BalanceReport
self:FieldPut(#BalYears, uValue)
return BalYears := uValue

METHOD ButtonClick(oControlEvent) CLASS BalanceReport
	LOCAL oControl AS Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:NameSym == #ind_toel
		IF oDCind_toel:Checked
			oDClCondense:Show()
			//oDCind_accstmnt:Show()
		ELSE
			oDClCondense:Hide()
			oDCind_accstmnt:Hide()
		ENDIF
	ENDIF
	RETURN NIL

METHOD CancelButton( ) CLASS BalanceReport
	SELF:EndWindow()
	RETURN NIL
METHOD Close(oEvent) CLASS BalanceReport
	LOCAL stt,eindt AS STRING
	SUPER:Close(oEvent)
	//Put your changes here
//CollectForced()

SELF:Destroy()
	RETURN

METHOD DepButton( ) CLASS BalanceReport
	LOCAL cCurValue AS STRING
	LOCAL nPntr AS INT

	cCurValue:=AllTrim(oDCmDepartment:TextValue)
	nPntr:=At(":",cCurValue)
	IF nPntr>1
		cCurValue:=SubStr(cCurValue,1,nPntr-1)
	ENDIF
	(DepartmentExplorer{self:OWNER,"Department",Str(self:WhoFrom,-1),self,cCurValue}):Show()
RETURN NIL
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS BalanceReport
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	LOCAL cCurValue as string
	LOCAL nPntr AS INT
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:NameSym==#mBalNumber.and.!AllTrim(oControl:TextValue)==cCurBal
			cCurValue:=AllTrim(oControl:TextValue)
			cCurBal:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindBal(@cCurValue)
				SELF:RegBalance(cCurValue)
			ELSE
				SELF:BalButton()
			ENDIF
		ELSEIF Departments
			IF oControl:NameSym==#mDepartment .and.!AllTrim(oControl:TextValue)==cCurDep
				cCurValue:=AllTrim(oControl:TextValue)
				cCurDep:=cCurValue
				nPntr:=At(":",cCurValue)
				IF nPntr>1
					cCurValue:=SubStr(cCurValue,1,nPntr-1)
				ENDIF
				IF FindDep(@cCurValue)
					SELF:RegDepartment(cCurValue,"")
				ELSE
					SELF:DepButton()
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	RETURN NIL

METHOD GetBalYears() CLASS BalanceReport
	// get array with balance years
	RETURN (GetBalYears())
access ind_accstmnt() class BalanceReport
return self:FieldGet(#ind_accstmnt)

assign ind_accstmnt(uValue) class BalanceReport
self:FieldPut(#ind_accstmnt, uValue)
return ind_accstmnt := uValue

access ind_toel() class BalanceReport
return self:FieldGet(#ind_toel)

assign ind_toel(uValue) class BalanceReport
self:FieldPut(#ind_toel, uValue)
return ind_toel := uValue

method Init(oWindow,iCtlID,oServer,uExtra) class BalanceReport 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

super:Init(oWindow,ResourceID{"BalanceReport",_GetInst()},iCtlID)

oDCFixedText1 := FixedText{self,ResourceID{BALANCEREPORT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Year under review:",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{self,ResourceID{BALANCEREPORT_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Start with month:",NULL_STRING,NULL_STRING}

oDCBalYears := combobox{self,ResourceID{BALANCEREPORT_BALYEARS,_GetInst()}}
oDCBalYears:FillUsing(Self:GetBalYears( ))
oDCBalYears:HyperLabel := HyperLabel{#BalYears,NULL_STRING,"Balance Years",NULL_STRING}

oDCMONTHSTART := SingleLineEdit{self,ResourceID{BALANCEREPORT_MONTHSTART,_GetInst()}}
oDCMONTHSTART:FieldSpec := MONTHW{}
oDCMONTHSTART:HyperLabel := HyperLabel{#MONTHSTART,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMONTHSTART:Picture := "99"

oDCFixedText3 := FixedText{self,ResourceID{BALANCEREPORT_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"End with month:",NULL_STRING,NULL_STRING}

oDCMONTHEND := SingleLineEdit{self,ResourceID{BALANCEREPORT_MONTHEND,_GetInst()}}
oDCMONTHEND:FieldSpec := MONTHW{}
oDCMONTHEND:HyperLabel := HyperLabel{#MONTHEND,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMONTHEND:Picture := "99"

oDCmBalNumber := SingleLineEdit{self,ResourceID{BALANCEREPORT_MBALNUMBER,_GetInst()}}
oDCmBalNumber:HyperLabel := HyperLabel{#mBalNumber,NULL_STRING,"Number of Balancegroup",NULL_STRING}
oDCmBalNumber:TooltipText := "Enter number or name of required Top of balance structure"

oCCBalButton := PushButton{self,ResourceID{BALANCEREPORT_BALBUTTON,_GetInst()}}
oCCBalButton:HyperLabel := HyperLabel{#BalButton,"v","Browse in balance items",NULL_STRING}
oCCBalButton:TooltipText := "Browse in balance items"

oDCWhatDetails := CheckBox{self,ResourceID{BALANCEREPORT_WHATDETAILS,_GetInst()}}
oDCWhatDetails:HyperLabel := HyperLabel{#WhatDetails,"With details of subitems?",NULL_STRING,NULL_STRING}

oDCmDepartment := SingleLineEdit{self,ResourceID{BALANCEREPORT_MDEPARTMENT,_GetInst()}}
oDCmDepartment:HyperLabel := HyperLabel{#mDepartment,NULL_STRING,"From Who is it: Department",NULL_STRING}
oDCmDepartment:TooltipText := "Enter number or name of required Top of department structure"

oCCDepButton := PushButton{self,ResourceID{BALANCEREPORT_DEPBUTTON,_GetInst()}}
oCCDepButton:HyperLabel := HyperLabel{#DepButton,"v","Browse in Departments",NULL_STRING}
oCCDepButton:TooltipText := "Browse in Departments"

oDCWhoDetails := CheckBox{self,ResourceID{BALANCEREPORT_WHODETAILS,_GetInst()}}
oDCWhoDetails:HyperLabel := HyperLabel{#WhoDetails,"With details of subdepartments?",NULL_STRING,NULL_STRING}

oDCNumbers := CheckBox{self,ResourceID{BALANCEREPORT_NUMBERS,_GetInst()}}
oDCNumbers:HyperLabel := HyperLabel{#Numbers,"With Numbers of all items",NULL_STRING,NULL_STRING}
oDCNumbers:TooltipText := "Show all items with their numbers besid their name"

oDCind_toel := CheckBox{self,ResourceID{BALANCEREPORT_IND_TOEL,_GetInst()}}
oDCind_toel:HyperLabel := HyperLabel{#ind_toel,"With explanation",NULL_STRING,NULL_STRING}

oDClCondense := CheckBox{self,ResourceID{BALANCEREPORT_LCONDENSE,_GetInst()}}
oDClCondense:HyperLabel := HyperLabel{#lCondense,"Condense",NULL_STRING,NULL_STRING}
oDClCondense:TooltipText := "Suppress zero balanced accounts"

oDCind_accstmnt := CheckBox{self,ResourceID{BALANCEREPORT_IND_ACCSTMNT,_GetInst()}}
oDCind_accstmnt:HyperLabel := HyperLabel{#ind_accstmnt,"With account statements",NULL_STRING,NULL_STRING}
oDCind_accstmnt:TooltipText := "Show account statements per month for explanation accounts"

oCCOKButton := PushButton{self,ResourceID{BALANCEREPORT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{self,ResourceID{BALANCEREPORT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{self,ResourceID{BALANCEREPORT_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Down from:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{self,ResourceID{BALANCEREPORT_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Balance Items:",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{self,ResourceID{BALANCEREPORT_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Departments:",NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{self,ResourceID{BALANCEREPORT_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Down from:",NULL_STRING,NULL_STRING}

oDCGroupBox3 := GroupBox{self,ResourceID{BALANCEREPORT_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"Options",NULL_STRING,NULL_STRING}

self:Caption := "Balance Report"
self:HyperLabel := HyperLabel{#BalanceReport,"Balance Report",NULL_STRING,NULL_STRING}
self:EnableStatusBar(True)

if !IsNil(oServer)
	self:Use(oServer)
endif

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

access lCondense() class BalanceReport
return self:FieldGet(#lCondense)

assign lCondense(uValue) class BalanceReport
self:FieldPut(#lCondense, uValue)
return lCondense := uValue

METHOD ListBoxSelect(oControlEvent) CLASS BalanceReport
	LOCAL oControl AS Control
	LOCAL uValue as USUAL
	local aBal:={} as array
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControlEvent:NameSym==#BalYears
		uValue:=oControlEvent:Control:Value
		aBal:=GetBalYear(Val(SubStr(uValue,1,4)),Val(SubStr(uValue,5,2)))
		MONTHSTART:=aBal[2]
		MONTHEND:=aBal[4]
	ENDIF

	RETURN NIL

access mBalNumber() class BalanceReport
return self:FieldGet(#mBalNumber)

assign mBalNumber(uValue) class BalanceReport
self:FieldPut(#mBalNumber, uValue)
return mBalNumber := uValue

access mDepartment() class BalanceReport
return self:FieldGet(#mDepartment)

assign mDepartment(uValue) class BalanceReport
self:FieldPut(#mDepartment, uValue)
return mDepartment := uValue

access MONTHEND() class BalanceReport
return self:FieldGet(#MONTHEND)

assign MONTHEND(uValue) class BalanceReport
self:FieldPut(#MONTHEND, uValue)
return MONTHEND := uValue

access MONTHSTART() class BalanceReport
return self:FieldGet(#MONTHSTART)

assign MONTHSTART(uValue) class BalanceReport
self:FieldPut(#MONTHSTART, uValue)
return MONTHSTART := uValue

access Numbers() class BalanceReport
return self:FieldGet(#Numbers)

assign Numbers(uValue) class BalanceReport
self:FieldPut(#Numbers, uValue)
return Numbers := uValue

METHOD OKButton( ) CLASS BalanceReport
* Check input data:
IF !ValidateControls( SELF, SELF:AControls )
	RETURN
END


*oReport := PrintDialog{oParent,"Balance Report",,118}
//oReport := PrintDialog{oParent,"Balance Report",,118,DMORIENT_LANDSCAPE,"xls"}
oReport := PrintDialog{oParent,self:oLan:RGet("Balance Report"),,118,DMORIENT_LANDSCAPE,"xls"}
oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
if Lower(oReport:Extension)=="xls"
	self:TAB:=CHR(9) 
	self:lXls:=true
else
	self:TAB:=Space(1)
	self:lXls:=false
endif

// IF oReport:Destination=="File"
// 	SELF:TAB:=CHR(9)
// ENDIF
self:BalancePrint()

SELF:Pointer := Pointer{POINTERARROW}
oReport:PrStart()
oReport:PrStop()
RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS BalanceReport
	//Put your PostInit additions here 
	local aBal:={} as array
self:SetTexts()
// aBal:=GetBalYear(Year(Today()),Month(Today()))
// self:MONTHSTART:=aBal[2]
// self:MONTHEND:=aBal[4]
self:MONTHSTART:=Month(Today()-28)
self:MONTHEND:=self:MONTHSTART
self:oDCBalYears:CurrentItemNo:=1
self:WhatDetails:=true
self:WhoDetails:=true
self:mBalNumber:="0: Balance Structure"
self:mDepartment:="0:"+sEntity+" "+sLand
self:cCurBal:=mBalNumber
self:cCurDep:=mDepartment
self:WhatFrom:=0
self:WhoFrom:=0

IF !Departments
	oDCGroupBox2:Hide()
	oDCFixedText5:Hide()
	oCCDepButton:Hide()
	oDCmDepartment:Hide()
	oDCWhoDetails:Hide()
ENDIF

RETURN NIL
		
METHOD prAmounts(pr_soort,pr_salvjtot,pr_balprvyrYtD,pr_salvrg,pr_sal,;
		pr_bud,pr_budper,pr_budytd,pr_level,pr_oms,r_koptekst,pr_inc,pr_exp,iLine,iPage) CLASS BalanceReport
	* Printing oof amounts per category or account
	LOCAL regel as STRING
	LOCAL mvjsaltot,mvrgsal,msal,mbalprvyrYtD,vjtm_perc as FLOAT
	LOCAL mtmsal,vrbr_perc,per_perc,tm_perc as FLOAT
	LOCAL i,Hlevel,bal_ptr,levelrest as int
	Default(@pr_inc,0)
	Default(@pr_exp,0)

	IF IsNil(pr_sal)
		* apparently no account add to these values
		RETURN
	ENDIF
	Default(@pr_salvjtot,0)
	Default(@pr_balprvyrYtD,0)
	Default(@pr_salvrg,0)
	Default(@pr_sal,0)
	Default(@pr_bud,0)
	Default(@pr_budper,0)
	Default(@pr_budytd,0)
	Default(@pr_oms,null_string)

	* Print first preceding headings:
	// test eerst op baldskip voor hele heading:
	self:oReport:PrintLine(@iLine,@iPage,nil,hfdkop,Len(HeadingCache))
	FOR i:=1 to Len(HeadingCache)
		Hlevel:=HeadingCache[i,1]
		bal_ptr:=HeadingCache[i,2]
		oReport:PrintLine(@iLine,@iPage,iif(self:lXls,Replicate(self:Tab,Hlevel),Space(Hlevel*2))+r_koptekst[bal_ptr],hfdkop,0)
	NEXT 

	levelrest:=self:MaxLevel-pr_level 
	if Left(pr_oms,3)="299"
		pr_oms:=pr_oms
	endif
	HeadingCache:={}

	IF pr_soort==EXPENSE.or.pr_soort==LIABILITY
		mvjsaltot:=-pr_salvjtot
		mvrgsal:=-pr_salvrg
		msal:=-pr_sal
		mbalprvyrYtD:=-pr_balprvyrYtD
	ELSE
		mvjsaltot:=pr_salvjtot
		mvrgsal:=pr_salvrg
		msal:=pr_sal
		mbalprvyrYtD:=pr_balprvyrYtD
	ENDIF
	*   regel:=Pad(Space(pr_level*2)+pr_oms,30)+' '
	// 	regel:=iif(self:Numbers,self:Tab,"")+iif(self:lXls,iif(pr_level>1,Replicate(self:Tab,pr_level-1),'')+pr_oms+iif(levelrest>0,Replicate(self:Tab,levelrest),''),Pad(Space(pr_level*2)+pr_oms,BalColWidth))+self:Tab
	regel:=iif(self:lXls,iif(pr_level>0,Replicate(self:Tab,pr_level),'')+pr_oms+iif(levelrest>0,Replicate(self:Tab,levelrest),''),Pad(Space(pr_level*2)+pr_oms,BalColWidth))+self:Tab
	IF pr_soort==INCOME.or.pr_soort==EXPENSE
		if !self:SimpleDepStmnt
			IF mvjsaltot # 0
				vjtm_perc:=(mbalprvyrYtD)*100/mvjsaltot
				regel:=regel+Str(vjtm_perc,9,1)
			ELSE
				regel:=regel+Space(9)
			ENDIF
		endif
	ELSEIF pr_soort=='SD'
		regel:=regel+Str(mbalprvyrYtD,9,DecAantal)+self:TAB+Str(mvjsaltot,11,DecAantal)+self:TAB+;
			Str(-pr_inc,13,decaantal)+self:TAB+Str(pr_exp,11,decaantal)+self:TAB+Str(mvrgsal,11,decaantal)+self:TAB+Str(msal,11,decaantal)
	ELSE
		regel:=regel+Space(9)
	ENDIF
	IF pr_soort==LIABILITY.or.pr_soort==ASSET
		regel:=regel+self:TAB+Str(mbalprvyrYtD,11,decaantal)+'  '+self:TAB+Str(msal,11,decaantal)
	ENDIF
	IF pr_soort==INCOME.or.pr_soort==EXPENSE
		mtmsal:=mvrgsal+msal
		vrbr_perc:=0
		per_perc:=0
		tm_perc:=0
		IF pr_bud # 0
			vrbr_perc:=(mtmsal/pr_bud)*100
			//          per_perc:=msal*1200/(pr_bud*(CurEnd-CurSt+1))
			//         tm_perc:=mtmsal*1200/(pr_bud*(CurEnd-BalSt+1))
		ENDIF
		IF pr_budper # 0
			per_perc:=msal*100/pr_budper
		ENDIF
		IF pr_budytd # 0
			tm_perc:=mtmsal*100/pr_budytd
		ENDIF
		regel:=regel+iif(self:SimpleDepStmnt,'',self:TAB+Str(mbalprvyrYtD,11,decaantal)+space(2)+self:TAB+Str(msal,11,decaantal)+;
			self:TAB+Str(per_perc,8,1))+self:TAB+Str(mvrgsal+msal,11,DecAantal)+self:TAB+;
			Str(tm_perc,8,1)+self:TAB+Str(pr_bud,11,DecAantal)+self:TAB+;
			Str(vrbr_perc,8,1)
	ENDIF
	oReport:PrintLine(@iLine,@iPage,regel,hfdkop,0)
	RETURN
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS BalanceReport
	//Put your PreInit additions here
	RETURN NIL
METHOD prkop(kop_type,kop_soort,dep_ptr,cDirect,d_dep,d_parentDep,d_depname,;
r_balid,r_heading,r_footer,r_parentid) CLASS BalanceReport
* Compose Heading
LOCAL Heading:={} as ARRAY
LOCAL inscription as STRING
LOCAL pntr as int
LOCAL cDepName as STRING
Default(@cDirect,null_string)

IF kop_soort==EXPENSE.or.kop_soort==INCOME
	inscription:=self:cInscriptionInEx
ELSE
	inscription:=self:cInscriptionAsLi
ENDIF
IF WhatDetails
	* Determine departname in heading:
	IF !WhoDetails
		* name of WhoFrom inclusive names of its parents in heading:
		pntr:=AScan(d_dep,WhoFrom)
	ELSE
		* name of current department in header:
		pntr:=dep_ptr
	ENDIF
	cDepName:=d_depname[pntr]
	DO WHILE !pntr==1
		pntr:=AScan(d_dep,d_parentDep[pntr])
		cDepName:=d_depname[pntr]+"/"+cDepName
	ENDDO
ELSE
	* Name of WhatFrom in Heading:
	IF Empty(WhatFrom)
		pntr:=1
	ELSE
		pntr:=AScan(r_balid,WhatFrom)
	ENDIF
	cDepName:=r_footer[pntr]
	IF Empty(cDepName)
		cDepName:=r_heading[pntr]
	ENDIF
	DO WHILE !pntr==1
		pntr:=AScan(r_balid,r_parentid[pntr])
		cDepName:=r_heading[pntr]+"/"+cDepName
	ENDDO
	kop_soort:="SD"
ENDIF

Heading:={cDepName+cDirect+Replicate(self:TAB,8),;
+ BoldOn+YellowOn+inscription+" "+Trim(kop_type)+'  '+self:cFrom+;
' '+maand[MONTHSTART]+self:cTo + maand[MonthEnd]+BoldOff+YellowOff,;
self:cYear+oDCBalYears:TextValue,' ',;
iif(self:lXls.and.self:Numbers,self:TAB,"")+self:cDescription+;
iif(self:SimpleDepStmnt,"",self:TAB+self:cPrvYrYTD+Space(6)+self:TAB+self:TAB+;
self:cCurPeriod+self:TAB)+;
IF(kop_soort=EXPENSE.or.kop_soort=INCOME,self:TAB+self:cYtD+self:TAB+self:TAB+self:cFullyear,''),;
iif(lXls,Replicate(self:TAB,self:MaxLevel+iif(self:Numbers,1,0)),Space (BalColWidth))+;
iif(kop_soort='SD',;
	self:TAB+self:cSurPlus+self:TAB+self:cClsBal+self:TAB+;
	self:cIncomeL+self:TAB+self:cExpenseL+;
	self:TAB+PadL(self:cSurPlus,11)+self:TAB+self:cClsBal,'')+;
iif(kop_soort=ASSET.or.kop_soort=LIABILITY,;
	self:TAB+Space(9) +;
	self:TAB+self:cAmount+self:TAB+PadL(self:cAmount,13),'')+;
iif(kop_soort=EXPENSE.or.kop_soort=INCOME,;
	self:TAB+iif(self:SimpleDepStmnt,"",PadL(self:cBudget,9) +;
	self:TAB+self:cAmount+self:TAB+PadL(self:cAmount,13)+;
	self:TAB+self:cBudget)+;
	self:TAB+self:cAmount+self:TAB+self:cBudget+;
	self:TAB+PadL(self:cBudget,11)+self:TAB+self:cBudget,''),;
Replicate(CHR(95),TotalWidth),' '}
//Replicate('-',TotalWidth),' '}

RETURN(Heading)
METHOD ProcessDepBal(p_depptr as int,lDirect as logic, dLevel as int,d_netnum as array,d_depname as array,d_parentdep as array,d_dep as array,;
		r_cat as array,r_balpryrtot as array,r_balPrYrYtD as array,r_balPrvPer as array,r_balPer as array,r_indmain as array,r_parentid as array,r_heading as array,r_footer as array,r_bud as array,r_budper as array,r_budytd as array,r_balid as array,;
		rd_salvjtot as array,rd_BalPrvYrYtD as array,rd_salvrg as array,rd_salper as array,rd_bud as array,rd_budper as array,rd_budytd as array,iLine ref int,iPage ref int) as void pascal CLASS BalanceReport
	* Process all balance items FOR given department: p_depptr
	LOCAL TopWhatPtr AS INT
	LOCAL aTot:={},aTotprv:={} AS ARRAY  // arrays with: type, level, amount for !Whatdetails .and. WhoDetails
	IF IsNil(lDirect)
		lDirect:=FALSE
	ENDIF
	IF IsNil(dLevel)
		dLevel:=0
	ENDIF

	* save values of arrays of  p_depptr in balance arrays:
	r_balpryrtot:={}
	r_balPrYrYtD:={}
	r_balPrvPer:={}
	r_balPer:={}
	r_bud:={}
	r_budper:={}
	r_budytd:={}

	FOR TopWhatPtr:=1 to self:BalCount
		AAdd(r_balpryrtot, rd_salvjtot[p_depptr, TopWhatPtr])
		AAdd(r_balPrYrYtD,rd_BalPrvYrYtD[p_depptr, TopWhatPtr])
		AAdd(r_balPrvPer,rd_salvrg[p_depptr, TopWhatPtr])
		AAdd(r_balPer,rd_salper[p_depptr, TopWhatPtr])
		AAdd(r_bud,rd_bud[p_depptr, TopWhatPtr])
		AAdd(r_budper,rd_budper[p_depptr, TopWhatPtr])
		AAdd(r_budytd,rd_budytd[p_depptr, TopWhatPtr])
	NEXT

	IF Empty(self:WhatFrom)  // virtual Top
		TopWhatPtr:=0
		DO WHILE TopWhatPtr<self:BalCount
			TopWhatPtr:=AScan(r_parentid,0,TopWhatPtr+1)
			IF TopWhatPtr=0
				EXIT
			ENDIF
			self:hfdkop:=self:prkop(self:cSummary,r_cat[TopWhatPtr],p_depptr,if(lDirect,"("+self:cDirectText+")",""),d_dep,d_parentdep,d_depname,;
				r_balid,r_heading,r_footer,r_parentid)
			IF self:WhatDetails.and.(self:WhoDetails.or.d_dep[p_depptr]==self:WhoFrom)
				iLine:=0
				self:oReport:Beginreport:=self:Beginreport
			ENDIF
			TopWhatPtr:=self:SUBBALITEM(TopWhatPtr,0,p_depptr,lDirect,dLevel,r_parentid,r_indmain,r_heading,r_footer,r_balpryrtot,;
				r_balPrYrYtD,r_balPrvPer,r_balPer,r_bud,r_budper,r_budytd,r_cat,r_balid,d_netnum,d_depname,aTot,aTotprv,@iLine,@iPage)
		ENDDO
	ELSE
		self:hfdkop:=self:prkop(self:cSummary,r_cat[1],p_depptr,,d_dep,d_parentdep,d_depname,;
			r_balid,r_heading,r_footer,r_parentid)
		IF self:WhatDetails
			* Force pageskip:
			iLine:=0
			oReport:Beginreport:=SELF:BeginReport
		ENDIF
		self:SUBBALITEM(1,0,p_depptr,lDirect,dLevel,r_parentid,r_indmain,r_heading,r_footer,r_balpryrtot,;
			r_balPrYrYtD,r_balPrvPer,r_balPer,r_bud,r_budper,r_budytd,r_cat,r_balid,d_netnum,d_depname,aTot,aTotprv,@iLine,@iPage)
	ENDIF
	RETURN
METHOD prtotaal(tot_soort,iLine,iPage) CLASS BalanceReport
* Afdrukken van sommatielijnen
   oReport:PrintLine(@iLine,@iPage,iif(self:lXls.and.self:Numbers,self:TAB,"")+ Space(iif(self:lXls,24,BalColWidth))+iif(self:lXls,Replicate(self:TAB,self:MaxLevel),"")+self:TAB+;
   iif(tot_soort==EXPENSE.or. tot_soort==INCOME.or. tot_soort=='SD',iif(self:SimpleDepStmnt,"",'---------'),Space(9))+;
   iif(self:SimpleDepStmnt,"",self:TAB+'-----------  '+self:TAB+'-----------')+;
   iif(tot_soort==EXPENSE.or.tot_soort==INCOME,;
      iif(self:SimpleDepStmnt,"",self:TAB+'--------')+self:TAB+'-----------'+self:TAB+'--------'+self:TAB+'-----------'+self:TAB+'--------',;
	iif(tot_soort=='SD',self:TAB+'-----------'+self:TAB+'-----------'+self:TAB+'-----------','')),hfdkop,2) 
RETURN
METHOD RegBalance(myNum) CLASS BalanceReport 
	local oBal as SQLSelect
	self:WhatFrom:=Val(MyNum)
	IF Empty(self:WhatFrom)
		self:cCurBal:="0: Balance Structure"
		self:mBalNumber:=cCurBal
		self:oDCmBalNumber:TEXTValue:=cCurBal
	ELSE
		oBal:=SQLSelect{"select number,heading from balanceitem where balitemid='"+Str(self:WhatFrom,-1)+"'",oConn}
		IF oBal:RecCount>0
			self:cCurBal:=AllTrim(oBal:number)+":"+oBal:Heading
			self:mBalNumber:=cCurBal
			self:oDCmBalNumber:TEXTValue:=cCurBal
		ENDIF
	ENDIF
	RETURN
METHOD RegDepartment(myNum,myItemName) CLASS BalanceReport
	local oDep as SQLSelect
	Default(@myItemName,null_string)
	//	IF !myNum==WhoFrom
	self:WhoFrom:=Val(MyNum)
	IF Empty(self:WhoFrom)
		cCurDep:="0:"+sEntity+" "+sLand
		mDepartment:=cCurDep
		oDCmDepartment:TextValue:=cCurDep
	ELSE
		oDep:=SQLSelect{"select deptmntnbr,descriptn from department where depid='"+Str(self:WhoFrom,-1)+"'",oConn}
		if oDep:RecCount>0  
			cCurDep:=AllTrim(oDep:deptmntnbr)+":"+oDep:descriptn
			mDepartment:=cCurDep
			oDCmDepartment:TextValue:=cCurDep
		ENDIF
	ENDIF
	//	ENDIF
	RETURN
METHOD SUBBALITEM(Bal_Ptr as int,level as int,Dep_Ptr as int,lDirect as logic,dLevel as int,r_parentid as array,r_indmain as array,r_heading as array,r_footer as array,r_balpryrtot as array,;
		r_balPrvYrYtD as array,r_balPrvPer as array,r_balPer as array,r_bud as array,r_budper as array,r_budytd as array,r_cat as array,r_balid as array,d_netnum as array,d_depname as array,aTot as array,aTotprv as array,iLine ref int,iPage ref int) as int CLASS BalanceReport
	* Recursive processing of a balance item with its subbalance items
	*
	LOCAL TotalFound,SubBalPtr, CachePtr,kap_num AS INT
	LOCAL m_soort, pr_oms AS STRING
	LOCAL openfund, surplusvj,surplus,clbalvj,clbal AS FLOAT
	LOCAL SDgevonden:=FALSE AS LOGIC
	LOCAL i,j AS INT, fInc, fExp AS FLOAT, fAmnt:={} AS ARRAY

	IF IsNil(lDirect)
		lDirect:=FALSE
	ENDIF
	IF IsNil(dLevel)
		dLevel:=0
	ENDIF

	IF r_indmain[Bal_Ptr]
		IF WhatDetails
			IF .not.Empty(r_heading[Bal_Ptr])
				AAdd(HeadingCache,{level,bal_ptr})
				CachePtr:=Len(HeadingCache)
				*			oReport:PrintLine(@iLine,@iPage,Space(level*2)+r_heading[bal_ptr],hfdkop,0)
			ENDIF
			TotalFound:=0
			* test if accounts record directly to this level
			IF !Empty( r_balpryrtot[Bal_Ptr]).or.;
					!Empty(r_balPrvYrYtD[Bal_Ptr]).or.;
					!Empty(r_balPrvPer[Bal_Ptr]).or.;
					!Empty(r_balPer[Bal_Ptr])
				* Print directly recorded amounts:
				pr_oms:=self:cDirectOn+" "
				IF Empty(r_heading[Bal_Ptr])
					pr_oms:=pr_oms+r_footer[Bal_Ptr]
				ELSE
					pr_oms:=pr_oms+r_heading[Bal_Ptr]
				ENDIF
				if (r_cat[bal_ptr]==INCOME.or.r_cat[bal_ptr]==EXPENSE) .or. !self:SimpleDepStmnt      // skip balance items in case of simple report
					self:prAmounts(Upper(r_cat[bal_ptr]),r_balpryrtot[bal_ptr],;
						r_balPrvYrYtD[Bal_Ptr],;
						r_balPrvPer[Bal_Ptr],r_balPer[Bal_Ptr],r_bud[Bal_Ptr],r_budper[Bal_Ptr],r_budytd[Bal_Ptr],level,pr_oms,r_heading,0.00,0.00,@iLine,@iPage)
					TotalFound:=1
				endif
			ENDIF
		ENDIF
		SubBalPtr:=0
		DO WHILE TRUE
			SubBalPtr:=AScan(r_parentid,r_balid[Bal_Ptr],SubBalPtr+1)
			IF Empty(SubBalPtr)
				EXIT
			ELSE
				SubBalPtr:=self:SUBBALITEM(SubBalPtr,level+1,Dep_Ptr,lDirect,dLevel,r_parentid,r_indmain,r_heading,r_footer,r_balpryrtot,;
					r_balPrvYrYtD,r_balPrvPer,r_balPer,r_bud,r_budper,r_budytd,r_cat,r_balid,d_netnum,d_depname,aTot,aTotprv,@iLine,@iPage)
				IF !IsNil(r_balPer[SubBalPtr])
					TotalFound:=TotalFound+1
					r_balpryrtot[bal_ptr]:=if(Empty(r_balpryrtot[bal_ptr]),0.00,r_balpryrtot[bal_ptr])+r_balpryrtot[SubBalPtr]
					r_balPrvYrYtD[bal_ptr]:=if(Empty(r_balPrvYrYtD[bal_ptr]),0.00,r_balPrvYrYtD[bal_ptr])+r_balPrvYrYtD[SubBalPtr]
					r_balPrvPer[bal_ptr]:=if(Empty(r_balPrvPer[bal_ptr]),0.00,r_balPrvPer[bal_ptr])+r_balPrvPer[SubBalPtr]
					r_balPer[Bal_Ptr]  :=if(Empty(r_balPer[Bal_Ptr]),0.00,r_balPer[Bal_Ptr])  +r_balPer[SubBalPtr]
					IF r_cat[SubBalPtr]== INCOME .or. r_cat[SubBalPtr]== LIABILITY;
							.or. r_cat[Bal_Ptr]== r_cat[SubBalPtr]
						r_bud[bal_ptr] :=if(Empty(r_bud[bal_ptr]),0.00,r_bud[bal_ptr]) +r_bud[SubBalPtr]
						r_budper[bal_ptr] :=if(Empty(r_budper[bal_ptr]),0.00,r_budper[bal_ptr]) +r_budper[SubBalPtr]
						r_budytd[bal_ptr] :=if(Empty(r_budytd[bal_ptr]),0.00,r_budytd[bal_ptr]) +r_budytd[SubBalPtr]
					ELSE
						r_bud[bal_ptr] :=if(Empty(r_bud[bal_ptr]),0.00,r_bud[bal_ptr]) -r_bud[SubBalPtr]
						r_budper[bal_ptr] :=if(Empty(r_budper[bal_ptr]),0.00,r_budper[bal_ptr]) -r_budper[SubBalPtr]
						r_budytd[bal_ptr] :=if(Empty(r_budytd[bal_ptr]),0.00,r_budytd[bal_ptr]) -r_budytd[SubBalPtr]
					ENDIF
				ENDIF
			ENDIF
		ENDDO
	ENDIF
	IF (WhatDetails)
		m_soort:=Upper(r_cat[Bal_Ptr]) 
		if (m_soort==INCOME.or.m_soort==expense) .or. !self:SimpleDepStmnt      // skip balance items in case of simple report
			IF	r_indmain[Bal_Ptr].and. TotalFound>1
				self:prtotaal(m_soort,@iLine,@iPage)
			ENDIF
			IF	!r_indmain[Bal_Ptr] .or.	TotalFound>1
				IF	!TotalFound>1
					pr_oms:=r_heading[Bal_Ptr]
				ELSE
					pr_oms:=r_footer[Bal_Ptr]
				ENDIF
				self:prAmounts(m_soort,r_balpryrtot[bal_ptr],;
					r_balPrvYrYtD[Bal_Ptr],r_balPrvPer[Bal_Ptr],;
					r_balPer[Bal_Ptr],r_bud[Bal_Ptr],r_budper[Bal_Ptr],r_budytd[Bal_Ptr],level,pr_oms,r_heading,0.00,0.00,@iLine,@iPage)
			ENDIF
			IF	TotalFound>1 && extra space after total
				oReport:PrintLine(@iLine,@iPage,' ',hfdkop,0)
			ENDIF
		endif
		IF r_indmain[Bal_Ptr]
			IF ALen(HeadingCache)>=CachePtr
				* If nothing printed downstream, discard rest of headings:
				ASize(HeadingCache,Max(0,CachePtr-1))
			ENDIF
		ENDIF
	ENDIF
	IF SELF:showopeningclosingfund .or.!WhatDetails
		// add for summary lines for BTA: opening fund balance, end closing balance :
		m_soort:=Upper(r_cat[Bal_Ptr])
		IF !IsNil(r_balPer[Bal_Ptr]).and.!Empty(r_balPer[Bal_Ptr])
			AAdd(aTot,{m_soort,level,r_balPer[Bal_Ptr]})
		ENDIF
		IF !IsNil(r_balpryrtot[Bal_Ptr]).and.!Empty(r_balpryrtot[Bal_Ptr])
			AAdd(aTotprv,{m_soort,level,r_balpryrtot[Bal_Ptr]})
		ENDIF
		IF level==0 .and. (!Empty(self:WhatFrom).or.Bal_Ptr>1) && second time "down"in tree: surplus income or liabilities
			kap_num:=AScan(r_balid, d_netnum[Dep_Ptr])
			clbalvj:=0
			clbal:=0
			IF !Empty(kap_num) .and. !IsNil(r_balPer[kap_num]).and.!IsNil(r_balpryrtot[kap_num])
				clbalvj:=r_balpryrtot[kap_num]
				clbal:=r_balPer[kap_num]
			ENDIF
			IF !IsNil(r_balpryrtot[Bal_Ptr]) .and.!IsNil(r_balPer[Bal_Ptr])  .and.!IsNil(r_balPrvPer[Bal_Ptr])   //added: +r_balPrvPer[1] because starting month > 1
				IF m_soort==INCOME.or.m_soort==LIABILITY
					surplusvj:=-r_balpryrtot[Bal_Ptr]-r_balPrvPer[Bal_Ptr]
					surplus:=-r_balPer[Bal_Ptr] - r_balPrvPer[Bal_Ptr]     //added: -r_balPrvPer[bal_ptr] because starting month > 1
				ELSE
					surplusvj:=r_balpryrtot[Bal_Ptr]+r_balPrvPer[Bal_Ptr]
					surplus:=r_balPer[bal_ptr] +r_balPrvPer[bal_ptr]     //added: +r_balPrvPer[bal_ptr] because starting month > 1
				ENDIF
				//IF clbalvj#surplusvj .or. clbal#surplus
				SDgevonden:=TRUE
				//ENDIF
			ENDIF
			IF !SDgevonden
				// 1e keer proberen:
				m_soort:=Upper(r_cat[1])
				IF !IsNil(r_balpryrtot[1]) .and.!IsNil(r_balPer[1]) .and.!IsNil(r_balPrvPer[1])     //added: +r_balPrvPer[1] because starting month > 1
					IF m_soort==INCOME.or.m_soort==LIABILITY
						surplusvj:=-r_balpryrtot[1]-r_balPrvPer[1]
						surplus:=-r_balPer[1]-r_balPrvPer[1]     //added: -r_balPrvPer[1] because starting month > 1
					ELSE
						surplusvj:=r_balPrvYrYtD[1]+r_balPrvPer[1]
						surplus:=r_balPer[1]+r_balPrvPer[1]     //added: +r_balPrvPer[1] because starting month > 1
					ENDIF
					//IF clbalvj#surplusvj .or. clbal#surplus
					SDgevonden:=TRUE
					//ENDIF
				ENDIF
			ENDIF
			IF SDgevonden
				ASort(aTot,,,{|x, y| x[1] < y[1] .or. (x[1]=y[1] .and. x[2] <= y[2])})
				ASort(aTotprv,,,{|x, y| x[1] < y[1] .or. (x[1]=y[1] .and. x[2] <= y[2])})
				IF !Empty(kap_num) .and. !IsNil(r_balPer[kap_num]).and.!IsNil(r_balpryrtot[kap_num])
					//				clbalvj:=-(r_balpryrtot[kap_num]-surplusvj)
					clbalvj:=-r_balpryrtot[kap_num]
					clbal:=-(r_balPer[kap_num]-surplus)
					IF SELF:showopeningclosingfund
						oReport:PrintLine(@iLine,@iPage,' ',hfdkop,2)
						oReport:PrintLine(@iLine,@iPage,self:cOpeningBal+Str(clbalvj,11,DecAantal),hfdkop,0)
						oReport:PrintLine(@iLine,@iPage,BoldOn+Pad(iif(clbal<0,RedOn+self:cNegative,GreenOn+self:cPositive)+" "+self:cClosingBal,BalColWidth+iif(self:SimpleDepStmnt,2,46))+Str(clbal,11,DecAantal)+iif(clbal<0,RedOff,GreenOff)+BoldOff,hfdkop,0)
					ENDIF
				ENDIF
				IF !SELF:showopeningclosingfund
					// determine highest level Income and expenses:
					fAmnt:=SELF:BalFishTot("I",aTot)
					fInc:=fAmnt[1]
					fExp:=fAmnt[2]
					fAmnt:=SELF:BalFishTot("B",aTot)
					clbal:=Round(fAmnt[1] - fAmnt[2] + surplus, decaantal)
					fAmnt:=SELF:BalFishTot("B",aTotprv)
					clbalvj:=Round(fAmnt[1] - fAmnt[2] + iif( self:PrvYearNotClosed,surplusvj,0),DecAantal)
					pr_oms:=if(dLevel=0,"",Space(dLevel*2))+if(lDirect,self:cDirectOn+" ","")+d_depname[Dep_Ptr]
// 					self:prAmounts("SD",clbalvj,r_balPrvYrYtD[Bal_Ptr],;
// 						surplus,clbal,r_bud[bal_ptr],r_budper[bal_ptr],r_budytd[bal_ptr],level,pr_oms,r_heading,fInc,fExp,@iLine,@iPage)
					self:prAmounts("SD",clbalvj,surplusvj,;
						surplus,clbal,r_bud[Bal_Ptr],r_budper[Bal_Ptr],r_budytd[Bal_Ptr],level,pr_oms,r_heading,fInc,fExp,@iLine,@iPage)
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	RETURN(bal_ptr)
METHOD SubDepartment(p_depptr as int,level as int,d_netnum as array,d_indmaindep as array,d_depname as array,d_parentdep as array,d_dep as array,;
		r_cat as array,r_balpryrtot as array,r_balPrYrYtD as array,r_balPrvPer as array,r_balPer as array,r_indmain as array,r_parentid as array,;
		r_heading as array,r_footer as array,r_balnbr as array,r_balid as array,r_bud as array,r_budper as array,r_budytd as array,;
		rd_salvjtot as array,rd_BalPrvYrYtD as array,rd_salvrg as array,rd_salper as array,rd_bud as array,rd_budper as array,rd_budytd as array,iLine ref int,iPage ref int) as int CLASS BalanceReport
	* Recursive processing of a department with its subdeparments
	*
	LOCAL TotalFound,subDepPtr AS INT
	LOCAL TopWhatPtr AS INT
	IF d_indmaindep[p_depptr]
		IF self:WhoDetails
			IF !self:WhatDetails
				self:oReport:PrintLine(@iLine,@iPage,Space(level*2)+d_depname[p_depptr],hfdkop,0)
			ENDIF
			* test if accounts record directly to this department:
			IF AScan( rd_salvjtot[p_depptr], {|x| !IsNil(x)})>0 .or.;
					AScan( rd_BalPrvYrYtD[p_depptr], {|x| !IsNil(x)})>0 .or.;
					AScan( rd_salvrg[p_depptr], {|x| !IsNil(x)})>0 .or.;
					AScan( rd_salper[p_depptr], {|x| !IsNil(x)})>0
				* Process directly recorded amounts:
				SELF:ProcessDepBal(p_depptr,TRUE,level+1,d_netnum,d_depname,d_parentDep,d_dep,;
					r_cat,r_balpryrtot,r_balPrYrYtD,r_balPrvPer,r_balPer,r_indmain,r_parentid,r_heading,r_footer,r_bud,r_budper,r_budytd,r_balid,;
					rd_salvjtot,rd_BalPrvYrYtD,rd_salvrg,rd_salper,rd_bud,rd_budper,rd_budytd,@iLine,@iPage)
				IF !self:WhatDetails
					TotalFound:=1
				ENDIF
			ENDIF
		ENDIF
		subDepPtr:=0
		DO WHILE TRUE
			subDepPtr:=AScan(d_parentdep,d_dep[p_depptr],subDepPtr+1)
			IF Empty(subDepPtr)
				EXIT
			ELSE
				TotalFound:=TotalFound+1
				IF level>25
					(errorbox{SELF:OWNER,'Hierarchy of referred departments too large or recursive'+;
						r_balnbr[p_depptr]}):show()
					SELF:EndWindow()
				ENDIF
				subDepPtr:=SELF:SubDepartment(subDepPtr,level+1,d_netnum,d_indmaindep,d_depname,d_parentDep,d_dep,;
					r_cat,r_balpryrtot,r_balPrYrYtD,r_balPrvPer,r_balPer,r_indmain,r_parentid,;
					r_heading,r_footer,r_balnbr,r_balid,r_bud,r_budper,r_budytd,;
					rd_salvjtot,rd_BalPrvYrYtD,rd_salvrg,rd_salper,rd_bud,rd_budper,rd_budytd,@iLine,@iPage)
				* consolidate values of subdepartment into itself:
				FOR TopWhatPtr:= 1 to self:BalCount
					IF !IsNil(rd_salvjtot[subDepPtr,TopWhatPtr])
						rd_salvjtot[p_depptr,TopWhatPtr]:=if(Empty(rd_salvjtot[p_depptr,TopWhatPtr]),0.00,;
							rd_salvjtot[p_depptr,TopWhatPtr])+rd_salvjtot[subDepPtr,TopWhatPtr]
					ENDIF
					IF !IsNil(rd_BalPrvYrYtD[subDepPtr,TopWhatPtr])
						rd_BalPrvYrYtD[p_depptr,TopWhatPtr]:=if(Empty(rd_BalPrvYrYtD[p_depptr,TopWhatPtr]),0.00,;
							rd_BalPrvYrYtD[p_depptr,TopWhatPtr])+rd_BalPrvYrYtD[subDepPtr,TopWhatPtr]
					ENDIF
					IF !IsNil(rd_salvrg[subDepPtr,TopWhatPtr])
						rd_salvrg[p_depptr,TopWhatPtr]:=if(Empty(rd_salvrg[p_depptr,TopWhatPtr]),0.00,;
							rd_salvrg[p_depptr,TopWhatPtr])+rd_salvrg[subDepPtr,TopWhatPtr]
					ENDIF
					IF !IsNil(rd_salper[subDepPtr,TopWhatPtr])
						rd_salper[p_depptr,TopWhatPtr]:=if(Empty(rd_salper[p_depptr,TopWhatPtr]),0.00,;
							rd_salper[p_depptr,TopWhatPtr])+rd_salper[subDepPtr,TopWhatPtr]
					ENDIF
					IF !IsNil(rd_bud[subDepPtr,TopWhatPtr])
						IF r_cat[TopWhatPtr]== INCOME .or. r_cat[TopWhatPtr]== LIABILITy;
								.or. r_cat[TopWhatPtr]== r_cat[TopWhatPtr]
							rd_bud[p_depptr,TopWhatPtr] :=if(Empty(rd_bud[p_depptr,TopWhatPtr]),0.00,;
								rd_bud[p_depptr,TopWhatPtr]) +rd_bud[subDepPtr,TopWhatPtr]
						ELSE
							rd_bud[p_depptr,TopWhatPtr] :=if(Empty(rd_bud[p_depptr,TopWhatPtr]),0.00,;
								rd_bud[p_depptr,TopWhatPtr]) -rd_bud[subDepPtr,TopWhatPtr]
						ENDIF
					ENDIF
					IF !IsNil(rd_budper[subDepPtr,TopWhatPtr])
						IF r_cat[TopWhatPtr]== INCOME .or. r_cat[TopWhatPtr]== LIABILITy;
								.or. r_cat[TopWhatPtr]== r_cat[TopWhatPtr]
							rd_budper[p_depptr,TopWhatPtr] :=if(Empty(rd_budper[p_depptr,TopWhatPtr]),0.00,;
								rd_budper[p_depptr,TopWhatPtr]) +rd_budper[subDepPtr,TopWhatPtr]
						ELSE
							rd_budper[p_depptr,TopWhatPtr] :=if(Empty(rd_budper[p_depptr,TopWhatPtr]),0.00,;
								rd_budper[p_depptr,TopWhatPtr]) -rd_budper[subDepPtr,TopWhatPtr]
						ENDIF
					ENDIF
					IF !IsNil(rd_budper[subDepPtr,TopWhatPtr])
						IF r_cat[TopWhatPtr]== INCOME .or. r_cat[TopWhatPtr]== LIABILITy;
								.or. r_cat[TopWhatPtr]== r_cat[TopWhatPtr]
							rd_budytd[p_depptr,TopWhatPtr] :=if(Empty(rd_budytd[p_depptr,TopWhatPtr]),0.00,;
								rd_budytd[p_depptr,TopWhatPtr]) +rd_budytd[subDepPtr,TopWhatPtr]
						ELSE
							rd_budytd[p_depptr,TopWhatPtr] :=if(Empty(rd_budytd[p_depptr,TopWhatPtr]),0.00,;
								rd_budytd[p_depptr,TopWhatPtr]) -rd_budytd[subDepPtr,TopWhatPtr]
						ENDIF
					ENDIF
				NEXT
			ENDIF
		ENDDO
	ENDIF
	IF self:WhoDetails.or.p_depptr==1
		IF self:WhoDetails .and. !self:WhatDetails
			IF d_indmaindep[p_depptr].and. TotalFound>1
				IF level=0
					self:oReport:PrintLine(@iLine,@iPage,' ',hfdkop,0)
				ENDIF
				self:prtotaal("SD",@iLine,@iPage)
			ENDIF
			IF (!d_indmaindep[p_depptr] .or. TotalFound>1)
				SELF:ProcessDepBal(p_depptr,FALSE,level,d_netnum,d_depname,d_parentDep,d_dep,;
					r_cat,r_balpryrtot,r_balPrYrYtD,r_balPrvPer,r_balPer,r_indmain,r_parentid,r_heading,r_footer,r_bud,r_budper,r_budytd,r_balid,;
					rd_salvjtot,rd_BalPrvYrYtD,rd_salvrg,rd_salper,rd_bud,rd_budper,rd_budytd,@iLine,@iPage)
			ENDIF
			IF TotalFound>1 && extra space after total
				oReport:PrintLine(@iLine,@iPage,' ',hfdkop,0)
			ENDIF
		ELSE
			SELF:ProcessDepBal(p_depptr,FALSE,level,d_netnum,d_depname,d_parentDep,d_dep,;
				r_cat,r_balpryrtot,r_balPrYrYtD,r_balPrvPer,r_balPer,r_indmain,r_parentid,r_heading,r_footer,r_bud,r_budper,r_budytd,r_balid,;
				rd_salvjtot,rd_BalPrvYrYtD,rd_salvrg,rd_salper,rd_bud,rd_budper,rd_budytd,@iLine,@iPage)
		ENDIF
	ENDIF
	RETURN(p_depptr)
METHOD SubNetDepartment(p_depptr as int,d_parentdep as array,d_dep as array,d_PLdeb as array,d_PLcre as array,d_netnum as array,;
r_balid as array,rd_BalPer as array,rd_BalPrvYr as array,rd_BalPrvYrYtD as array,rd_BalPrvPer as array,rd_bud as array,rd_budper as array,;
rd_budytd as array,d_PrfLssPrYr as array) as void pascal CLASS BalanceReport
* Recursive processing of netasset balances of a department with its subdeparments
*
LOCAL subDepPtr,net_ptr as int

DO WHILE true
	subDepPtr:=AScan(d_parentdep,d_dep[p_depptr],subDepPtr+1)
	IF Empty(subDepPtr)
		exit
	ELSE
		self:SubNetDepartment(subDepPtr,d_parentdep,d_dep,d_PLdeb,d_PLcre,d_netnum,r_balid,rd_BalPer,rd_BalPrvYr,rd_BalPrvYrYtD,rd_BalPrvPer,;
		rd_bud,rd_budper,rd_budytd,d_PrfLssPrYr)
		* consolidate values of subdepartment into itself:
		d_PLdeb[p_depptr]:=Round(d_PLdeb[p_depptr]+d_PLdeb[subDepPtr],DecAantal)
		d_PLcre[p_depptr]:=Round(d_PLcre[p_depptr]+d_PLcre[subDepPtr],DecAantal)
	ENDIF
ENDDO
*
* Add Profit/loss to netassetaccount of the  department:
IF !Empty(d_netnum[p_depptr])
	* Determine pointer to balance item for netasset: (can be empty)
	net_ptr:=AScan(r_balid, d_netnum[p_depptr])
	IF !Empty(net_ptr)
		IF IsNil(rd_BalPer[p_depptr,net_ptr])
			rd_BalPer[p_depptr,net_ptr]:=0
		ENDIF
		IF IsNil(rd_BalPrvYr[p_depptr,net_ptr])
			rd_BalPrvYr[p_depptr,net_ptr]:=0
		ENDIF
		IF IsNil(rd_BalPrvYrYtD[p_depptr,net_ptr])
			rd_BalPrvYrYtD[p_depptr,net_ptr]:=0
		ENDIF
		IF IsNil(rd_BalPrvPer[p_depptr,net_ptr])
			rd_BalPrvPer[p_depptr,net_ptr]:=0
		ENDIF
		IF IsNil(rd_bud[p_depptr,net_ptr])
			rd_bud[p_depptr,net_ptr]:=0
		ENDIF
		IF IsNil(rd_budper[p_depptr,net_ptr])
			rd_budper[p_depptr,net_ptr]:=0
		ENDIF
		IF IsNil(rd_budytd[p_depptr,net_ptr])
			rd_budytd[p_depptr,net_ptr]:=0
		ENDIF
		rd_BalPer[p_depptr,net_ptr]  := Round(rd_BalPer[p_depptr,net_ptr] + d_PLdeb[p_depptr] - d_PLcre[p_depptr],DecAantal)
		IF self:YearBeforePrvNotClosed
			rd_BalPrvYrYtD[p_depptr,net_ptr]:=Round(if(Empty(rd_BalPrvYrYtD[p_depptr,net_ptr]),0,rd_BalPrvYrYtD[p_depptr,net_ptr])+ d_PrfLssPrYr[p_depptr],DecAantal)
		ENDIF
		* Clear d_PLdeb/cre:
		d_PLdeb[p_depptr]:=0
		d_PLcre[p_depptr]:=0
	ENDIF
ENDIF
RETURN
access WhatDetails() class BalanceReport
return self:FieldGet(#WhatDetails)

assign WhatDetails(uValue) class BalanceReport
self:FieldPut(#WhatDetails, uValue)
return WhatDetails := uValue

access WhoDetails() class BalanceReport
return self:FieldGet(#WhoDetails)

assign WhoDetails(uValue) class BalanceReport
self:FieldPut(#WhoDetails, uValue)
return WhoDetails := uValue

STATIC DEFINE BALANCEREPORT_BALBUTTON := 107 
STATIC DEFINE BALANCEREPORT_BALYEARS := 102 
STATIC DEFINE BALANCEREPORT_CANCELBUTTON := 117 
STATIC DEFINE BALANCEREPORT_DEPBUTTON := 110 
STATIC DEFINE BALANCEREPORT_FIXEDTEXT1 := 100 
STATIC DEFINE BALANCEREPORT_FIXEDTEXT2 := 101 
STATIC DEFINE BALANCEREPORT_FIXEDTEXT3 := 104 
STATIC DEFINE BALANCEREPORT_FIXEDTEXT4 := 118 
STATIC DEFINE BALANCEREPORT_FIXEDTEXT5 := 121 
STATIC DEFINE BALANCEREPORT_GROUPBOX1 := 119 
STATIC DEFINE BALANCEREPORT_GROUPBOX2 := 120 
STATIC DEFINE BALANCEREPORT_GROUPBOX3 := 122 
STATIC DEFINE BALANCEREPORT_IND_ACCSTMNT := 115 
STATIC DEFINE BALANCEREPORT_IND_TOEL := 113 
STATIC DEFINE BALANCEREPORT_LCONDENSE := 114 
STATIC DEFINE BALANCEREPORT_MBALNUMBER := 106 
STATIC DEFINE BALANCEREPORT_MDEPARTMENT := 109 
STATIC DEFINE BALANCEREPORT_MONTHEND := 105 
STATIC DEFINE BALANCEREPORT_MONTHSTART := 103 
STATIC DEFINE BALANCEREPORT_NUMBERS := 112 
STATIC DEFINE BALANCEREPORT_OKBUTTON := 116 
STATIC DEFINE BALANCEREPORT_WHATDETAILS := 108 
STATIC DEFINE BALANCEREPORT_WHODETAILS := 111 
STATIC DEFINE CONFIRMSEND_CANCELBUTTON := 101 
STATIC DEFINE CONFIRMSEND_FIXEDTEXT1 := 102 
STATIC DEFINE CONFIRMSEND_FIXEDTEXT2 := 103 
STATIC DEFINE CONFIRMSEND_OKBUTTON := 100 
CLASS DeptReport INHERIT DataWindowMine 

	PROTECT oDCFromDep AS SINGLELINEEDIT
	PROTECT oCCFromDepButton AS PUSHBUTTON
	PROTECT oDCBalYears AS COMBOBOX
	PROTECT oDCMONTHSTART AS SINGLELINEEDIT
	PROTECT oDCMONTHEND AS SINGLELINEEDIT
	PROTECT oDCBeginReport AS CHECKBOX
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCSubSet AS LISTBOXBAL
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oCCLastMonth AS RADIOBUTTON
	PROTECT oCCAllMonths AS RADIOBUTTON
	PROTECT oDCFootnotes AS RADIOBUTTONGROUP
	PROTECT oDCSendingMethod AS RADIOBUTTONGROUP
	PROTECT oCCPrintAll AS RADIOBUTTON
	PROTECT oCCSeparateFile AS RADIOBUTTON
	PROTECT oCCSeparateFileMail AS RADIOBUTTON
	PROTECT oDCSimpleDepStmnt AS CHECKBOX
	PROTECT oDCSelectedCnt AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	instance FromDep 
	instance BalYears 
	instance MONTHSTART 
	instance MONTHEND 
	instance BeginReport 
	instance SubSet 
	instance Footnotes 
	instance SendingMethod 
	PROTECT YEARSTART,YEAREND AS INT
	PROTECT BalSt, BalEnd, CurSt, CurEnd AS INT
* Options for report type:
PROTECT mDepartment AS STRING
	EXPORT cFromDepName AS STRING
	EXPORT oReport AS PrintDialog
	EXPORT oBalReport AS BalanceReport
	PROTECT oTransMonth AS AccountStatements
	PROTECT oGiftRpt AS GiftsReport
	PROTECT oPPcd as SQLSelect
	declare method RegDepartment,GiftsPrint
	
RESOURCE DeptReport DIALOGEX  26, 24, 401, 212
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", DEPTREPORT_FROMDEP, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 84, 18, 136, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", DEPTREPORT_FROMDEPBUTTON, "Button", WS_CHILD, 220, 18, 15, 12
	CONTROL	"", DEPTREPORT_BALYEARS, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 84, 51, 118, 72
	CONTROL	"", DEPTREPORT_MONTHSTART, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 84, 72, 32, 12, WS_EX_CLIENTEDGE
	CONTROL	"", DEPTREPORT_MONTHEND, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 84, 91, 32, 13, WS_EX_CLIENTEDGE
	CONTROL	"Reduced pageskips", DEPTREPORT_BEGINREPORT, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 84, 110, 80, 11
	CONTROL	"Departments", DEPTREPORT_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|WS_CLIPSIBLINGS, 8, 4, 377, 39
	CONTROL	"Cancel", DEPTREPORT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 324, 195, 53, 13
	CONTROL	"", DEPTREPORT_SUBSET, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 248, 22, 125, 170, WS_EX_CLIENTEDGE
	CONTROL	"Down from:", DEPTREPORT_FIXEDTEXT1, "Static", WS_CHILD, 14, 20, 53, 10
	CONTROL	"Subset:", DEPTREPORT_FIXEDTEXT7, "Static", WS_CHILD, 250, 9, 53, 10
	CONTROL	"Year under review:", DEPTREPORT_FIXEDTEXT3, "Static", WS_CHILD, 14, 51, 71, 12
	CONTROL	"Start with month:", DEPTREPORT_FIXEDTEXT4, "Static", WS_CHILD, 14, 73, 54, 12
	CONTROL	"End with month:", DEPTREPORT_FIXEDTEXT5, "Static", WS_CHILD, 14, 92, 54, 12
	CONTROL	"Last month", DEPTREPORT_LASTMONTH, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 169, 80, 53, 11
	CONTROL	"All months", DEPTREPORT_ALLMONTHS, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 169, 94, 49, 11
	CONTROL	"Footnotes", DEPTREPORT_FOOTNOTES, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 165, 70, 70, 38
	CONTROL	"Required Action:", DEPTREPORT_SENDINGMETHOD, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 12, 144, 196, 61
	CONTROL	"Print", DEPTREPORT_PRINTALL, "Button", BS_AUTORADIOBUTTON|WS_CHILD|WS_OVERLAPPED|0x1000L, 19, 155, 181, 11
	CONTROL	"Save seperate printfile per department", DEPTREPORT_SEPARATEFILE, "Button", BS_AUTORADIOBUTTON|WS_CHILD|WS_OVERLAPPED|0x1000L, 19, 171, 181, 11
	CONTROL	"Send separate printfile by email to each department", DEPTREPORT_SEPARATEFILEMAIL, "Button", BS_AUTORADIOBUTTON|WS_CHILD|WS_OVERLAPPED|0x1000L, 19, 187, 181, 11
	CONTROL	"Simplified report", DEPTREPORT_SIMPLEDEPSTMNT, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 84, 125, 80, 11
	CONTROL	"", DEPTREPORT_SELECTEDCNT, "Static", WS_CHILD, 312, 11, 64, 9
END

ACCESS BalYears() CLASS DeptReport
RETURN SELF:FieldGet(#BalYears)

ASSIGN BalYears(uValue) CLASS DeptReport
SELF:FieldPut(#BalYears, uValue)
RETURN uValue

ACCESS BeginReport() CLASS DeptReport
RETURN SELF:FieldGet(#BeginReport)

ASSIGN BeginReport(uValue) CLASS DeptReport
SELF:FieldPut(#BeginReport, uValue)
RETURN uValue

METHOD ButtonClick(oControlEvent) CLASS DeptReport
	LOCAL oControl AS Control
	LOCAL nDep AS STRING
	LOCAL filename as STRING
	local aBal:={} as array
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	filename:=oControl:Name
	IF !filename="SEPARATEFILE" .and. filename #"PRINTALL"
		RETURN
	ENDIF
	IF ValidateControls( SELF, SELF:AControls )
		IF filename == "SEPARATEFILEMAIL"
			IF !IsMAPIAvailable()
				(errorbox{SELF:Owner,"Outlook not default mailing system or no interface to it"}):show()
				RETURN
			ENDIF
		ENDIF
		IF Empty(SELF:FromDep)
			(errorbox{SELF:Owner,"Specify From Department"}):show()
		ELSE
			aBal:=GetBalYear(Val(SubStr(BalYears,1,4)),Val(SubStr(BalYears,5,2)))
			self:YEARSTART:=aBal[1]
			self:YEAREND:=aBal[3]
			IF	aBal[2]>aBal[4] // spanning two	calendar	years?
				IF	self:MONTHSTART < aBal[2]  // MONTHSTART
					* apparently in next	year:
					++self:YEARSTART
				ENDIF
				IF	self:MONTHEND	> aBal[4]  //MONTHEND
					* appenntly	in	previous	year:
					--self:YEAREND
				ENDIF
			ENDIF

		   self:oReport := PrintDialog{,self:oLan:WGet("Dept statements")+" "+Str(self:YEAREND,4,0)+"-"+StrZero(self:MONTHEND,2),,137,DMORIENT_LANDSCAPE}
			IF filename = "SEPARATEFILE"
				self:oReport:OkButton("File",true)
			ELSE
				self:oReport:show()
			ENDIF
			IF .not. self:oReport:lPrintOk
				RETURN
			ENDIF
			SELF:DepstmntPrint()
			self:oReport:PrStop()
			SELF:StatusMessage("Done",4)
		ENDIF
	ENDIF
	RETURN
METHOD CancelButton( ) CLASS DeptReport
	SELF:EndWindow()
RETURN TRUE

METHOD Close(oEvent) CLASS DeptReport
	SUPER:Close(oEvent)
	//Put your changes here
IF  !oBalReport==NULL_OBJECT
	oBalReport:Close()
	oBalReport:=NULL_OBJECT
ENDIF
CollectForced()
IF !oTransMonth == NULL_OBJECT
	//oTransMonth:Close()
	oTransMonth:=NULL_OBJECT
ENDIF
CollectForced()

SELF:destroy()
	RETURN NIL

METHOD DepstmntPrint() CLASS DeptReport
LOCAL lPrintFile, lSkip, lFirst, lFirstInMonth AS LOGIC
LOCAL scheiding = Replicate('-',40)+'|-------|-------|-------|-------|-------|'+;
'-------|-------|-------|-------|-------|-------|-------|'
LOCAL regtel,medtel,GClen,i,nRow,nPage as int
LOCAL aDep:={} AS ARRAY
LOCAL PeriodText, mailname as STRING
local nDep as int
LOCAL  DueRequired,GiftsRequired,AddressRequired,RepeatingPossible as LOGIC
LOCAL brieftxt AS STRING
LOCAL oSelpers AS Selpers
LOCAL oMapi AS MAPISession
LOCAL oRecip1,oRecip2 as MAPIRecip
LOCAL aMailDepartment:={} AS ARRAY
LOCAL cFileName AS USUAL, oFileSpec AS FileSpec
LOCAL oEMLFrm AS eMailFormat
LOCAL aASS,aAcc,aAccGift as ARRAY
LOCAL FileInit, cDepName as STRING 
local oBal as SQLSelect 
local nCurFifo,i as int
local addHeading as string 
local oAcc,oAccAss as SQLSelect
local cLastName as string 
local mDepNumber as string
PeriodText:=Str(self:YEARSTART,4)+' '+maand[self:MONTHSTART]+" "+oLan:Get('up incl')+Str(self:YEAREND,4)+' '+maand[self:MonthEnd]
//TotalWidth=137
lPrintFile:=(self:oReport:Destination=="File")
IF self:SendingMethod=="SeperateFileMail"
	(oEMLFrm := eMailFormat{oParent}):Show()
	IF oEMLFrm:lCancel
		RETURN FALSE
	ENDIF
ENDIF

SELF:Pointer := Pointer{POINTERHOURGLASS}
SELF:Statusmessage("Collecting data for the report, please wait...")
IF SendingMethod=="SeperateFileMail"
	oMAPI := MAPISession{}	
	IF !oMAPI:Open( "" , "" )
		MessageBox( 0 , "MAPI-Services not available." , "Problem" , MB_ICONEXCLAMATION )
		RETURN
	ENDIF		
ENDIF
aDep:=self:oDCSubSet:GetSelectedItems()
if Empty(aDep)
	ErrorBox{self,self:oLan:Wget("No departments selected in Subset")}:Show()
	return
endif
IF oBalReport==NULL_OBJECT
	oBalReport:=BalanceReport{}
ENDIF 
		
self:oBalReport:BalYears:=self:BalYears
self:oBalReport:lCondense:=true
self:oBalReport:ind_accstmnt:=FALSE
self:oBalReport:ind_toel:=FALSE
self:oBalReport:WhatDetails:=true
self:oBalReport:WhoDetails:=FALSE
self:oBalReport:WhatFrom:=0
self:oBalReport:MONTHEND:=self:MONTHEND
self:oBalReport:MONTHSTART:=self:MONTHSTART
self:oBalReport:oReport:=self:oReport
self:oBalReport:showopeningclosingfund:=true 
self:oBalReport:SimpleDepStmnt:= self:oDCSimpleDepStmnt:Checked
IF self:SendingMethod="SeperateFile"
	self:oBalReport:SendToMail:=true
else
	self:oBalReport:SendToMail:=false	
ENDIF
self:oBalReport:BeginReport:=self:BeginReport	
//DO WHILE oDep:DEPTMNTNBR <= ToDep .and. !oDep:EOF
oAcc:=SQLSelect{"select d.descriptn,d.deptmntnbr,d.depid,d.assacc1,d.assacc2,d.assacc3,d.persid,d.persid2,a.accnumber,a.description,a.giftalwd,a.accid"+;
",p1.lastname as lastname1,p1.email as email1,"+SQLFullName(0,"p1")+" as fullname1,p2.lastname as lastname2,p2.email as email2,"+SQLFullName(0,"p2")+" as fullname2 "+;
"from account a,department d left join person p1 on(p1.persid=d.persid) left join person p2 on (p2.persid=d.persid2) "+;
"where a.department=d.depid and d.depid in ("+Implode(aDep,",")+")",oConn}
if oAcc:RecCount<1
	if !Empty(oAcc:Status)
		LogEvent(self,"Error:"+oAcc:ErrInfo:ErrorMessage+CRLF+"statement:"+oAcc:SQLString,"logerrors") 
		ErrorBox{self,"Error:"+oAcc:ErrInfo:ErrorMessage+CRLF+"statement:"+oAcc:SQLString}:Show()
	endif
	return
endif
do WHILE !oAcc:Eof
	nDep:=oAcc:DepId
	cDepName:=CleanFileName(AllTrim(StrTran(oAcc:DESCRIPTN,"."," "))) 
	mDepNumber:=oAcc:DEPTMNTNBR
	nCurFifo:=Len(self:oReport:oPrintJob:aFIFO) 
	addHeading:=self:oLan:RGet("Department")+Space(1)+cDepName
	self:STATUSMESSAGE("Collecting data for for "+cDepName+", please wait...")
	self:oBalReport:WhoFrom:=oAcc:DepId
	self:oBalReport:iPage:=nPage
	* Insert departmentname if print to seperate file:
	FileInit:=""
	IF lPrintFile .and. self:SendingMethod="SeperateFile"
		FileInit:=MEMBER_START+cDepName
	ENDIF

	self:oBalReport:BalancePrint(FileInit)
	self:STATUSMESSAGE("Printing Accountstatements for "+cDepName+", please wait...")

   IF self:oTransMonth==null_object
   	self:oTransMonth:=AccountStatements{60}
   ENDIF
	self:oTransMonth:oReport:=self:oReport
	self:oTransMonth:BeginReport:=self:BeginReport
	self:oTransMonth:SendingMethod:=SendingMethod 

// Proces e-mail:
	IF lPrintFile.and. SendingMethod=="SeperateFileMail"
		IF !Empty(oAcc:persid).or.!Empty(oAcc:persid2)
			AAdd(aMailDepartment,oAcc:RECNO)
		endif
	ENDIF

	// Print accountstatements of all department accounts:
	nPage:=self:oBalReport:iPage
	aAcc:={}
	aAccGift:={}
	nRow:=0
	DO WHILE !oAcc:Eof .and. oAcc:DepId==nDep
		AAdd(aAcc,oAcc:ACCNUMBER)
		if oAcc:Giftalwd==1
			AAdd(aAccGift,oAcc:accid)
		endif
		oAcc:Skip()
	ENDDO
	ASort(aAcc,,,{|x,y|x<=y})
 	self:STATUSMESSAGE("Printing Accountstatements for "+cDepName+", please wait...")

	FOR i=1 to Len(aAcc)
		nRow:=0  && force page skip
		self:oTransMonth:MonthPrint(aAcc[i],aAcc[i],self:YEARSTART,self:MONTHSTART,self:YEAREND,self:MonthEnd,@nRow,@nPage,addHeading,self:oLan)
	NEXT
	
	*	If associated accounts for this department, print also corresponding accountstatements for this month:
	IF !Empty(oAcc:ASSACC1).or.!Empty(oAcc:ASSACC2).or.!Empty(oAcc:ASSACC3)
		nRow:=0  && force page skip 
		aASS:={oAcc:ASSACC1,oAcc:ASSACC2,oAcc:ASSACC3}
		oAccAss:=SQLSelect{"select accnumber from account where accid in ("+Implode(aASS)+")",oConn} 
		self:Statusmessage("Printing Associated Accountstatements for "+cDepName+", please wait...")
		Do While !oAccAss:Eof
			self:oTransMonth:MonthPrint(oAccAss:ACCNUMBER,oAccAss:ACCNUMBER,self:YEARSTART,self:MONTHSTART,self:YEAREND,self:MonthEnd,@nRow,@nPage,addHeading+Space(1)+oLan:Get("Associated",,"@!"),self:oLan)
			nRow:=0  && force page skip
			oAccAss:Skip()
		enddo
	ENDIF
	// Print gift reports for each gift allowed account:
	self:STATUSMESSAGE("Printing Gift reports for "+cDepName+", please wait...")
	self:GiftsPrint(aAccGift,@nRow,@nPage,addHeading,mDepNumber,cDepName)
	if	nCurFiFo==Len(self:oReport:oPrintJob:aFIFO)
		// nothing printed:
		self:oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("No financial activity in given period"),{self:oLan:RGet("Department")+Space(1)+cDepName+":"+PeriodText},2)
		
	endif

ENDDO

cFileName:=oReport:prstart((SendingMethod="SeperateFile"))    // generate rtf-format when seperate files
IF IsString(cFileName)
	IF SendingMethod=="SeperateFileMail" 
		FOR i:=1 TO Len(aMailDepartment)
			SELF:Statusmessage("Placing mail messages in outbox of mailing system, please wait...")
			oAcc:Goto(aMailDepartment[i])
			if !empty(oAcc:Persid) .or.!empty(oAcc:Persid2) 
				oSelpers:=Selpers{}
				oSelpers:AnalyseTxt(oEMLFrm:Template,@DueRequired,@GiftsRequired,@AddressRequired,@RepeatingPossible,1)
				oRecip1:=null_object
				oRecip2:=null_object
				if !Empty(oAcc:persid) 
					* Resolve department responsible person name:   
					cLastName:=StrTran(StrTran(oAcc:Lastname1,"\",""),"/","")
					oRecip1 := oMapi:ResolveName( cLastName,oAcc:persid,oAcc:fullname1,oAcc:email1)
				endif
				if Empty(oAcc:persid).and.!Empty(oAcc:persid2) 
					* Resolve department responsible person name:   
					cLastName:=StrTran(StrTran(oAcc:Lastname2,"\",""),"/","")
					oRecip1 := oMapi:ResolveName( cLastName,oAcc:persid2,oAcc:fullname2,oAcc:email2)
				endif
				if !Empty(oAcc:persid).and.!Empty(oAcc:persid2) 
					* Resolve department responsible person name:   
					cLastName:=StrTran(StrTran(oAcc:Lastname2,"\",""),"/","")
					oRecip2 := oMapi:ResolveName( cLastName,oAcc:persid2,oAcc:fullname2,oAcc:email2)
				endif
				IF oRecip1 != null_object
					IF !Empty(oEMLFrm:Template) 
						brieftxt:=oSelpers:FillText(oEMLFrm:Template,1,DueRequired,GiftsRequired,AddressRequired,RepeatingPossible,60)
					ELSE
						brieftxt:=""
					ENDIF
					oFileSpec:=FileSpec{cFileName}
					oFileSpec:FileName:=AllTrim(oFileSpec:FileName)+" "+oAcc:DESCRIPTN
					oMapi:SendDocument( oFileSpec,oRecip1,oRecip2,oLan:Get('Department Statements',,"@!")+": "+PeriodText,brieftxt)
				ENDIF
			ENDIF
		NEXT
		oMAPI:Close()
	ENDIF
ENDIF

SELF:Pointer := Pointer{POINTERARROW}

RETURN
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS DeptReport
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "FROMDEP"
			IF !Upper(AllTrim(oControl:TEXTValue))==Upper(AllTrim(cFromDepName))
				self:cFromDepName:=AllTrim(oControl:VALUE)
				SELF:FromDepButton(TRUE)
			ENDIF
		ENDIF
	ENDIF
	RETURN
ACCESS Footnotes() CLASS DeptReport
RETURN SELF:FieldGet(#Footnotes)

ASSIGN Footnotes(uValue) CLASS DeptReport
SELF:FieldPut(#Footnotes, uValue)
RETURN uValue

ACCESS FromDep() CLASS DeptReport
RETURN SELF:FieldGet(#FromDep)

ASSIGN FromDep(uValue) CLASS DeptReport
SELF:FieldPut(#FromDep, uValue)
RETURN uValue

METHOD FromDepButton( ) CLASS DeptReport
	LOCAL cCurValue AS STRING
	LOCAL nPntr AS INT

	cCurValue:=AllTrim(oDCFromDep:TextValue)
	(DepartmentExplorer{self:Owner,"Department",FromDep,self,cCurValue,"From Department"}):show()
RETURN
METHOD GetBalYears() CLASS DeptReport
	// get array with balance years
	RETURN (GetBalYears())
METHOD GiftsPrint(aAcc as array,nRow ref int,nPage ref int,addHeading:='' as string,DepNumber as string,Depname as string) as void pascal CLASS DeptReport
	// printing of the gifts of one department
	* aAcc: array with ids of the gift accounts of the department
	* Giftreport for departemnt in year
	* YEAREND to month MONTHEND
	*

	LOCAL a,b as STRING
	LOCAL kopmnd as ARRAY
	LOCAL i,j,iMonth, AssmntRow  as int
	LOCAL fAmnt as FLOAT
	LOCAL Inhdrij as int
	LOCAL myLang:=Alg_taal as STRING
	* Array aAssmntAmount met 12 totaalbedragen per inhoudingscode per maand:
	* rij 1:total, 2:AG,  3:PF,  4:PF,  5: MG
	LOCAL dim aAssmntAmount[4,12] as float
	* ARRAY aGiversdata with gift amounts and giver data per row:
	* 1 - Amount
	* 2 - persid
	* 3 - description
	* 4 - GC
	* 5 - Month
	* 6-11 - NAC1-6
	* 12 - SORTKEY
	LOCAL aGiversdata as ARRAY
	LOCAL lSkip as LOGIC
	LOCAL BoldOn, BoldOff,RedOn,RedOff as STRING
	LOCAL oAcc,oTrans,oPPcd as SQLSelect
	local oMBal as Balances 
	local aPPCode:={} as array
	local startdate,enddate as date

	IF self:SendingMethod="SeperateFile"
		BoldOn:="{\b "
		BoldOff:="}"
		RedOn:="\cf1 "
		RedOff:="\cf0 "
	ENDIF 

	oMBal:=Balances{}
	oPPcd := SQLSelect{"select ppcode,ppname from ppcodes order by ppcode",oConn} 
	aPPCode:=oPPcd:GetLookupTable(200,#ppcode,#ppname)
	startdate:=SToD(Str(self:YEARSTART,4,0)+StrZero(self:MONTHSTART,2,0)+'01') 
	enddate:=endofmonth(SToD(str(self:YEAREND,4,0)+strzero(self:MonthEnd,2)+'01'))

	IF oGiftRpt==null_object
		oGiftRpt:=GiftsReport{YEAREND,MonthEnd}
		oGiftRpt:Country:=sLand
	ENDIF


	self:Pointer := Pointer{POINTERHOURGLASS}
	self:STATUSMESSAGE(self:oLan:WGet("Collecting data for the report, please wait")+"...")
	nRow := 0

	// oAcc:=SQLSelect{"select a.accid,a.description,a.accnumber,b.category,m.persid,m.householdid,m.homepp,m.contact,m.RPTDEST,"+;
	// 	"group_concat(cast(ass.accid as char) separator ',') as assacc,"+SQLFullName(0,'pc')+" as contactfullname,pc.lastname as contactlstname,pc.email as contactemail"+;
	// 	",pm.lastname,pm.email "+;
	// 	" from balanceitem b,Account a left join member m on (a.accid=m.accid) left join memberassacc ass on (ass.mbrid=m.mbrid)"+ ;
	// 	" left join person pc on (pc.persid=m.contact) left join person pm on (pm.persid=m.persid)"+;
	// 	" where a.balitemid=b.balitemid and a.giftalwd=1 "+;
	// 	" and a.accid in ('"+Implode(aAcc,"','")+"' ) group by a.accid order by a.accnumber",oConn}
	// IF oAcc:RecCount<1
	// 	return
	// endif

	oTrans:=SQLSelect{UnionTrans("select t.docid,t.transid,a.accid,t.persid,t.dat,t.deb,t.cre,t.fromrpp,bfm,t.opp,t.gc,t.description "+;
		"from transaction t, account a "+;
		"where a.accid=t.accid and t.dat>='"+SQLdate(startdate)+"' and t.dat<='"+SQLdate(enddate)+"'"+;
		" and t.accid in ('"+Implode(aAcc,"','")+"') order by accnumber,dat"),oConn}

	if oTrans:RecCount<1
		return
	endif 

	aGiversdata:={}
	for i:=1 to 4
		for j:=1 to 12
			aAssmntAmount[i,j]:=0.00
		next
	next
	lSkip:=FALSE
	
	do WHILE !oTrans:EOF

		*	Fill geverlst with gifts values and calculate totals:
		*	processing of gifts:
		IF .not. Empty(oTrans:persid) .and. oTrans:deb#oTrans:cre .and.!oTrans:gc=="CH"
			fAmnt:=  Round( oTrans:cre - oTrans:deb,DecAantal)
			iMonth:= Month(oTrans:dat)
			AAdd(aGiversdata,{fAmnt,oTrans:persid,AllTrim(oTrans:Description),;
				IF(ADMIN="WO".or.Admin="HO",Upper(oTrans:gc),""),iMonth,;
				"","","","","","",""})
			*				calculate totals assesment percode and month:
			aAssmntAmount[1,iMonth]:=aAssmntAmount[1,iMonth] + fAmnt   && total
			IF Upper(oTrans:GC) = "AG"
				AssmntRow := 2
			ELSEIF Upper(oTrans:GC) = "MG"
				AssmntRow := 4
			ELSE
				AssmntRow := 3         && default = personal fund
			ENDIF
			aAssmntAmount[AssmntRow,iMonth]:=aAssmntAmount[AssmntRow,iMonth]+fAmnt
		ENDIF
		oTrans:Skip()
	ENDDO 


	* processing end of month:
	*	Skip departments without gifts:
	IF Len(aGiversdata)=0
		IF MONTHEND=1
			lSkip:=true
		elseIF aAssmntAmount[1,MonthEnd-1]=0  && vorige maand ook al niks?
			lSkip:=true
		ENDIF
	ENDIF

	IF lSkip
		RETURN
	ENDIF

	nRow:=0  && forceer bladskip

	// Print gifts matrix: 
	for i:=1 to 4
		for j:=1 to 12
			self:oGiftRpt:aAssmntAmount[i,j]:=aAssmntAmount[i,j]
		next
	next
	self:oGiftRpt:GiftsOverview(self:YEAREND,self:MONTHEND,self:Footnotes, aGiversdata,self:oReport,DepNumber+' '+DepName,@nRow,@nPage,addHeading)


	self:Pointer := Pointer{POINTERARROW}
	RETURN 
	
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS DeptReport 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"DeptReport",_GetInst()},iCtlID)

oDCFromDep := SingleLineEdit{SELF,ResourceID{DEPTREPORT_FROMDEP,_GetInst()}}
oDCFromDep:HyperLabel := HyperLabel{#FromDep,NULL_STRING,NULL_STRING,NULL_STRING}
oDCFromDep:TooltipText := "Enter number or name of required Top of department structure"

oCCFromDepButton := PushButton{SELF,ResourceID{DEPTREPORT_FROMDEPBUTTON,_GetInst()}}
oCCFromDepButton:HyperLabel := HyperLabel{#FromDepButton,"v","Browse in departments",NULL_STRING}
oCCFromDepButton:TooltipText := "Browse in departments"

oDCBalYears := combobox{SELF,ResourceID{DEPTREPORT_BALYEARS,_GetInst()}}
oDCBalYears:FillUsing(Self:GetBalYears( ))
oDCBalYears:HyperLabel := HyperLabel{#BalYears,NULL_STRING,"Balance Years",NULL_STRING}

oDCMONTHSTART := SingleLineEdit{SELF,ResourceID{DEPTREPORT_MONTHSTART,_GetInst()}}
oDCMONTHSTART:FieldSpec := MONTHW{}
oDCMONTHSTART:HyperLabel := HyperLabel{#MONTHSTART,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMONTHSTART:Picture := "99"

oDCMONTHEND := SingleLineEdit{SELF,ResourceID{DEPTREPORT_MONTHEND,_GetInst()}}
oDCMONTHEND:FieldSpec := MONTHW{}
oDCMONTHEND:HyperLabel := HyperLabel{#MONTHEND,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMONTHEND:Picture := "99"

oDCBeginReport := CheckBox{SELF,ResourceID{DEPTREPORT_BEGINREPORT,_GetInst()}}
oDCBeginReport:HyperLabel := HyperLabel{#BeginReport,"Reduced pageskips",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{DEPTREPORT_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Departments",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{DEPTREPORT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCSubSet := ListboxBal{SELF,ResourceID{DEPTREPORT_SUBSET,_GetInst()}}
oDCSubSet:TooltipText := "Select subset of given range of departments"
oDCSubSet:HyperLabel := HyperLabel{#SubSet,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{DEPTREPORT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Down from:",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{DEPTREPORT_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Subset:",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{DEPTREPORT_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Year under review:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{DEPTREPORT_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Start with month:",NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{DEPTREPORT_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"End with month:",NULL_STRING,NULL_STRING}

oCCLastMonth := RadioButton{SELF,ResourceID{DEPTREPORT_LASTMONTH,_GetInst()}}
oCCLastMonth:HyperLabel := HyperLabel{#LastMonth,"Last month",NULL_STRING,NULL_STRING}

oCCAllMonths := RadioButton{SELF,ResourceID{DEPTREPORT_ALLMONTHS,_GetInst()}}
oCCAllMonths:HyperLabel := HyperLabel{#AllMonths,"All months",NULL_STRING,NULL_STRING}

oCCPrintAll := RadioButton{SELF,ResourceID{DEPTREPORT_PRINTALL,_GetInst()}}
oCCPrintAll:HyperLabel := HyperLabel{#PrintAll,"Print",NULL_STRING,NULL_STRING}
oCCPrintAll:TooltipText := "Print report to printer/screen/file"

oCCSeparateFile := RadioButton{SELF,ResourceID{DEPTREPORT_SEPARATEFILE,_GetInst()}}
oCCSeparateFile:HyperLabel := HyperLabel{#SeparateFile,"Save seperate printfile per department","Generates files: Balancereport<department name>",NULL_STRING}
oCCSeparateFile:TooltipText := "Generate for each department a file with the report"

oCCSeparateFileMail := RadioButton{SELF,ResourceID{DEPTREPORT_SEPARATEFILEMAIL,_GetInst()}}
oCCSeparateFileMail:HyperLabel := HyperLabel{#SeparateFileMail,"Send separate printfile by email to each department",NULL_STRING,NULL_STRING}
oCCSeparateFileMail:TooltipText := "Send report to each department by mail"

oDCSimpleDepStmnt := CheckBox{SELF,ResourceID{DEPTREPORT_SIMPLEDEPSTMNT,_GetInst()}}
oDCSimpleDepStmnt:HyperLabel := HyperLabel{#SimpleDepStmnt,"Simplified report",NULL_STRING,NULL_STRING}
oDCSimpleDepStmnt:TooltipText := "Show only income/expense year to date"

oDCSelectedCnt := FixedText{SELF,ResourceID{DEPTREPORT_SELECTEDCNT,_GetInst()}}
oDCSelectedCnt:HyperLabel := HyperLabel{#SelectedCnt,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFootnotes := RadioButtonGroup{SELF,ResourceID{DEPTREPORT_FOOTNOTES,_GetInst()}}
oDCFootnotes:FillUsing({ ;
							{oCCLastMonth,"Last"}, ;
							{oCCAllMonths,"All"} ;
							})
oDCFootnotes:HyperLabel := HyperLabel{#Footnotes,"Footnotes",NULL_STRING,NULL_STRING}

oDCSendingMethod := RadioButtonGroup{SELF,ResourceID{DEPTREPORT_SENDINGMETHOD,_GetInst()}}
oDCSendingMethod:FillUsing({ ;
								{oCCPrintAll,"PrintAll"}, ;
								{oCCSeparateFile,"SeperateFile"}, ;
								{oCCSeparateFileMail,"SeperateFileMail"} ;
								})
oDCSendingMethod:HyperLabel := HyperLabel{#SendingMethod,"Required Action:",NULL_STRING,NULL_STRING}

SELF:Caption := "Department Statements and Gift Reports"
SELF:HyperLabel := HyperLabel{#DeptReport,"Department Statements and Gift Reports","Print report to printer/screen/file",NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method ListBoxSelect(oControlEvent) class DeptReport
	local oControl as Control
	LOCAL uValue as USUAL
	local aBal:={} as array
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	super:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControlEvent:NameSym==#BalYears
		uValue:=oControlEvent:Control:Value
		FillBalYears()
		aBal:=GetBalYear(Val(SubStr(uValue,1,4)),Val(SubStr(uValue,5,2)))
		MONTHSTART:=aBal[2]
		MONTHEND:=aBal[4]
	elseif oControlEvent:NameSym==#SubSet
		self:oDCSelectedCnt:TEXTValue:=Str(self:oDCSubSet:SelectedCount,-1)+" selected"
	endif	

	return nil

ACCESS MONTHEND() CLASS DeptReport
RETURN SELF:FieldGet(#MONTHEND)

ASSIGN MONTHEND(uValue) CLASS DeptReport
SELF:FieldPut(#MONTHEND, uValue)
RETURN uValue

ACCESS MONTHSTART() CLASS DeptReport
RETURN SELF:FieldGet(#MONTHSTART)

ASSIGN MONTHSTART(uValue) CLASS DeptReport
SELF:FieldPut(#MONTHSTART, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS DeptReport
	//Put your PostInit additions here
self:SetTexts()
self:MONTHSTART:=Month(Today()-28)
self:MONTHEND:=self:MONTHSTART
self:oDCBalYears:CurrentItemNo:=1
self:mDepartment:="0:"+sEntity+" "+sLand
IF SQLSelect{"select depid from department",oConn}:RecCount>0
	self:RegDepartment(iif(empty(cDepmntIncl),"",split(cDepmntIncl,",")[1]),"From Department")
ENDIF
SELF:BeginReport:=TRUE
self:Footnotes:="Last" 
self:oDCSimpleDepStmnt:Checked:=true

RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS DeptReport
	//Put your PreInit additions here
	RETURN NIL
METHOD RegDepartment(MyNum:='' as string,ItemName:="" as string) as void pascal CLASS DeptReport
	LOCAL  deptxt:="",deporder  as STRING
	local depnr as int 
	local oDep as SQLSelect
	IF Empty(myNum)
		depnr:=0
		deptxt:=sEntity+" "+sLand
	ELSE
		oDep:=SQLSelect{"select depid,descriptn from department where depid="+MyNum,oConn}
		IF oDep:Reccount>0
			depnr:=oDep:DEPID
			deptxt:=oDep:DESCRIPTN
		ENDIF
	ENDIF	
	IF ItemName == "From Department"
		SELF:FromDep:= depnr
		SELF:oDCFromDep:TEXTValue := deptxt
		SELF:cFromDepName := deptxt
		SELF:oDCSubSet:DepNameStart:=deptxt
		self:oDCSubSet:DepNbrStart:=Str(depnr,-1) 
		self:oDCSelectedCnt:TEXTValue:=Str(self:oDCSubSet:SelectedCount,-1)+" selected"		
	ENDIF
		
RETURN 
ACCESS SendingMethod() CLASS DeptReport
RETURN SELF:FieldGet(#SendingMethod)

ASSIGN SendingMethod(uValue) CLASS DeptReport
SELF:FieldPut(#SendingMethod, uValue)
RETURN uValue

ACCESS SimpleDepStmnt() CLASS DeptReport
RETURN SELF:FieldGet(#SimpleDepStmnt)

ASSIGN SimpleDepStmnt(uValue) CLASS DeptReport
SELF:FieldPut(#SimpleDepStmnt, uValue)
RETURN uValue

ACCESS SubSet() CLASS DeptReport
RETURN SELF:FieldGet(#SubSet)

ASSIGN SubSet(uValue) CLASS DeptReport
SELF:FieldPut(#SubSet, uValue)
RETURN uValue

STATIC DEFINE DEPTREPORT_ALLMONTHS := 115 
STATIC DEFINE DEPTREPORT_BALYEARS := 102 
STATIC DEFINE DEPTREPORT_BEGINREPORT := 105 
STATIC DEFINE DEPTREPORT_CANCELBUTTON := 107 
STATIC DEFINE DEPTREPORT_FIXEDTEXT1 := 109 
STATIC DEFINE DEPTREPORT_FIXEDTEXT3 := 111 
STATIC DEFINE DEPTREPORT_FIXEDTEXT4 := 112 
STATIC DEFINE DEPTREPORT_FIXEDTEXT5 := 113 
STATIC DEFINE DEPTREPORT_FIXEDTEXT7 := 110 
STATIC DEFINE DEPTREPORT_FOOTNOTES := 116 
STATIC DEFINE DEPTREPORT_FROMDEP := 100 
STATIC DEFINE DEPTREPORT_FROMDEPBUTTON := 101 
STATIC DEFINE DEPTREPORT_GROUPBOX1 := 106 
STATIC DEFINE DEPTREPORT_LASTMONTH := 114 
STATIC DEFINE DEPTREPORT_MONTHEND := 104 
STATIC DEFINE DEPTREPORT_MONTHSTART := 103 
STATIC DEFINE DEPTREPORT_PRINTALL := 118 
STATIC DEFINE DEPTREPORT_SELECTEDCNT := 122 
STATIC DEFINE DEPTREPORT_SENDINGMETHOD := 117 
STATIC DEFINE DEPTREPORT_SEPARATEFILE := 119 
STATIC DEFINE DEPTREPORT_SEPARATEFILEMAIL := 120 
STATIC DEFINE DEPTREPORT_SIMPLEDEPSTMNT := 121 
STATIC DEFINE DEPTREPORT_SUBSET := 108 
STATIC DEFINE DESCR:=3
DEFINE DT:=4 // direct transaction to own WO


STATIC DEFINE EXCHANGERATE_FIXEDTEXT1 := 101 
STATIC DEFINE EXCHANGERATE_MEXCHRATE := 100 
STATIC DEFINE EXCHANGERATE_OKBUTTON := 102 
STATIC DEFINE GC:=4
FUNCTION Getal_inv (f_getal,f_size)
* Tonen inverse van getal
IF f_getal<0
    RETURN(Str(Abs(f_getal),f_size,decaantal)+' ')
ELSE
    IF f_getal>0
        RETURN(Str(f_getal,f_size,decaantal)+'-')
    ELSE
        RETURN(Space(f_size+1))
    ENDIF
ENDIF
RETURN('')
FUNCTION Getal_invf(f_getal,f_size,f_dec)
	LOCAL DecSep AS STRING
	DecSep:=CHR(SetDecimalSep())

* Tonen inverse van getal
RETURN(StrTran(StrZero(Abs(f_getal),f_size,f_dec),DecSep)+if(f_getal<=0," ","-"))

FUNCTION Getal_invPMIS (f_getal)
* Tonen inverse van getal
IF f_getal<0
    RETURN(Trim(Str(Abs(f_getal),,decaantal)))
ELSE
    IF f_getal>0
        RETURN('-'+Trim(Str(f_getal,,decaantal)))
    ELSE
        RETURN(Space(f_size+1))
    ENDIF
ENDIF
RETURN('')

STATIC DEFINE GETEXCHANGERATE_FIXEDTEXT1 := 101 
STATIC DEFINE GETEXCHANGERATE_MEXCHRATE := 100 
STATIC DEFINE GETEXCHANGERATE_OKBUTTON := 102 
STATIC DEFINE GETEXCHRATE_CURNAME := 103 
STATIC DEFINE GETEXCHRATE_MEXCHRATE := 100 
STATIC DEFINE GETEXCHRATE_OKBUTTON := 102 
STATIC DEFINE GETEXCHRATE_ROETEXT1 := 101 
STATIC DEFINE GETEXCHRATE_ROETEXT2 := 104 
CLASS GiftReport INHERIT DataWindowMine 

	PROTECT oDCHomeBox AS CHECKBOX
	PROTECT oDCNonHomeBox AS CHECKBOX
	PROTECT oDCProjectsBox AS CHECKBOX
	PROTECT oDCFromAccount AS SINGLELINEEDIT
	PROTECT oCCFromAccButton AS PUSHBUTTON
	PROTECT oDCToAccount AS SINGLELINEEDIT
	PROTECT oCCToAccButton AS PUSHBUTTON
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCSubSet AS LISTBOXGIFTREPORT
	PROTECT oDCPeilJaar AS SINGLELINEEDIT
	PROTECT oDCPeilMnd AS SINGLELINEEDIT
	PROTECT oCCLastMonth1 AS RADIOBUTTON
	PROTECT oCCAllMonths1 AS RADIOBUTTON
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCTextfrom AS FIXEDTEXT
	PROTECT oDCTextTill AS FIXEDTEXT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCMemberstmnt AS RADIOBUTTONGROUP
	PROTECT oCCPrintreport AS PUSHBUTTON
	PROTECT oCCSeparateFiles AS PUSHBUTTON
	PROTECT oCCSeparateFilesMail AS PUSHBUTTON
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oCCLastMonth AS RADIOBUTTON
	PROTECT oCCAllMonths AS RADIOBUTTON
	PROTECT oDCFootnotes AS RADIOBUTTONGROUP
	PROTECT oDCmailcontact AS CHECKBOX
	PROTECT oDCSkipInactive AS CHECKBOX
	PROTECT oCCNoStmnts AS RADIOBUTTON
	PROTECT oDCSelectedCnt AS FIXEDTEXT

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	INSTANCE HomeBox
	INSTANCE NonHomeBox
	INSTANCE ProjectsBox
	INSTANCE FromAccount
	INSTANCE ToAccount
	INSTANCE SubSet
	INSTANCE PeilJaar
	INSTANCE PeilMnd
	INSTANCE Memberstmnt
	INSTANCE Footnotes
	INSTANCE mailcontact
	PROTECT PeilMax, MaxJaar,MinJaar, StartJaar as int
	EXPORT cFromAccName as STRING
	EXPORT cToAccName as STRING
	EXPORT oReport as PrintDialog
	EXPORT oPers as SQLSelect
	PROTECT oTransMonth as AccountStatements
	PROTECT Country as STRING
	PROTECT cFileTrans as STRING
	PROTECT SendingMethod as STRING
	PROTECT oGftRpt as GiftsReport
	PROTECT CalcYear, CalcMonth as int
	
	declare method CheckAccInRange,GiftsPrint

	
RESOURCE GiftReport DIALOGEX  58, 59, 396, 267
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Members of", GIFTREPORT_HOMEBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 13, 16, 211, 11
	CONTROL	"Members not of", GIFTREPORT_NONHOMEBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 13, 27, 215, 11
	CONTROL	"Projects", GIFTREPORT_PROJECTSBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 13, 38, 80, 11
	CONTROL	"", GIFTREPORT_FROMACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 13, 61, 79, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", GIFTREPORT_FROMACCBUTTON, "Button", WS_CHILD, 91, 61, 15, 12
	CONTROL	"", GIFTREPORT_TOACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 136, 60, 78, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", GIFTREPORT_TOACCBUTTON, "Button", WS_CHILD, 214, 60, 16, 13
	CONTROL	"Print up to which month?", GIFTREPORT_FIXEDTEXT5, "Static", WS_CHILD, 8, 99, 84, 12
	CONTROL	"", GIFTREPORT_SUBSET, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 250, 25, 125, 215, WS_EX_CLIENTEDGE
	CONTROL	"", GIFTREPORT_PEILJAAR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 96, 34, 12, WS_EX_CLIENTEDGE
	CONTROL	"", GIFTREPORT_PEILMND, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 136, 96, 19, 12, WS_EX_CLIENTEDGE
	CONTROL	"Last month", GIFTREPORT_LASTMONTH1, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 12, 139, 53, 11
	CONTROL	"All months", GIFTREPORT_ALLMONTHS1, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 12, 152, 48, 11
	CONTROL	"Members/funds", GIFTREPORT_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|WS_CLIPSIBLINGS, 8, 6, 377, 81
	CONTROL	"Cancel", GIFTREPORT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 324, 251, 53, 12
	CONTROL	"From:", GIFTREPORT_FIXEDTEXT1, "Static", WS_CHILD, 14, 52, 52, 10
	CONTROL	"To:", GIFTREPORT_FIXEDTEXT2, "Static", WS_CHILD, 136, 51, 56, 9
	CONTROL	"", GIFTREPORT_TEXTFROM, "Static", WS_CHILD, 13, 73, 111, 13
	CONTROL	"", GIFTREPORT_TEXTTILL, "Static", WS_CHILD, 136, 73, 111, 13
	CONTROL	"Subset:", GIFTREPORT_FIXEDTEXT7, "Static", WS_CHILD, 250, 16, 42, 9
	CONTROL	"Member statements", GIFTREPORT_MEMBERSTMNT, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 115, 70, 51
	CONTROL	"Print", GIFTREPORT_PRINTREPORT, "Button", WS_TABSTOP|WS_CHILD, 16, 215, 180, 12
	CONTROL	"Save seperate printfile per member", GIFTREPORT_SEPARATEFILES, "Button", WS_TABSTOP|WS_CHILD, 15, 230, 181, 12
	CONTROL	"Send separate printfile by email to each member", GIFTREPORT_SEPARATEFILESMAIL, "Button", WS_TABSTOP|WS_CHILD, 15, 245, 181, 12
	CONTROL	"Requierd action:", GIFTREPORT_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 206, 196, 55
	CONTROL	"Last month", GIFTREPORT_LASTMONTH, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 142, 128, 53, 11
	CONTROL	"All months", GIFTREPORT_ALLMONTHS, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 142, 142, 48, 11
	CONTROL	"Footnotes", GIFTREPORT_FOOTNOTES, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 138, 118, 70, 38
	CONTROL	"eMail also to contact person", GIFTREPORT_MAILCONTACT, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 12, 173, 121, 11
	CONTROL	"Skip inactive accounts", GIFTREPORT_SKIPINACTIVE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 12, 184, 92, 11
	CONTROL	"None", GIFTREPORT_NOSTMNTS, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 12, 125, 51, 11
	CONTROL	"", GIFTREPORT_SELECTEDCNT, "Static", WS_CHILD, 312, 16, 64, 9
END

METHOD AccFil() CLASS GiftReport
	LOCAL i AS INT
	LOCAL SubLen AS INT
	SELF:FromAccount:="0"
	self:ToAccount:="zzzzzzzzz" 
	self:oDCSubSet:cCurStart:=""
	self:oDCSubSet:cCurEnd:=""
	SELF:oDCSubSet:FillUsing(SELF:oDCSubSet:GetAccnts())
	* Select all:
	SubLen:=SELF:oDCSubSet:ItemCount
	FOR i = 1 TO SubLen
		SELF:oDCSubSet:SelectItem(i)
	NEXT
	self:oDCSelectedCnt:TEXTValue:=Str(SubLen,-1)+" selected"
	SELF:FromAccount:= LTrimZero(SELF:oDCSubSet:GetItem(1,LENACCNBR))
	SELF:oDCFromAccount:TEXTValue := FromAccount
	SELF:cFromAccName := FromAccount
	SELF:oDCTextfrom:caption := AllTrim(SubStr(SELF:oDCSubSet:GetItem(1),LENACCNBR+1))
	self:oDCSubSet:cAccStart:=self:FromAccount
	self:ToAccount:= LTrimZero(self:oDCSubSet:GetItem(SubLen,LENACCNBR))
	SELF:oDCToAccount:TEXTValue := ToAccount
	SELF:cToAccName := ToAccount
	self:oDCTextTill:caption := AllTrim(SubStr(self:oDCSubSet:GetItem(SubLen),LENACCNBR+1)) 
	self:oDCSubSet:cAccEnd:=self:ToAccount
	RETURN
METHOD ButtonClick(oControlEvent) CLASS GiftReport
	LOCAL oControl AS Control
	LOCAL i AS INT
	LOCAL SubLen AS INT
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:NameSym=#HomeBox .or. oControl:NameSym=#NonHomeBox .or. oControl:NameSym=#ProjectsBox
		SELF:AccFil()
	ENDIF
	if !oControl:NameSym=#SkipInactive
		if FromAccount==ToAccount
			self:SkipInactive:=false
		else
			if self:Memberstmnt="ALLST"
				self:SkipInactive:=false 
				self:oDCSkipInactive:ToolTipText:="Suppress reports with no financial transaction in All Months"
			else
				self:SkipInactive:=true
				self:oDCSkipInactive:ToolTipText:="Suppress reports with no financial transaction in Last Month"
			endif
		endif
	endif

	RETURN NIL
METHOD CancelButton( ) CLASS GiftReport
	SELF:EndWindow()
	RETURN TRUE
Method CheckAccInRange(accid as int, AccNbr as string) as logic class GiftReport 
	// check if account within range of 
	if self:HomeBox
		if AScan(self:aMemHome,{|x|x[2]==AccId})>0
			return true
		endif
	endif
	if self:NonHomeBox
		if AScan(self:aMemNonHome,{|x|x[2]==AccId})>0
			return true
		endif
	endif
	if self:ProjectsBox
		if AScan(self:aProjects,{|x|x[2]==AccId})>0
			return true
		endif
	endif
	ErrorBox{self,self:oLan:WGet("Account")+" "+AllTrim(AccNbr)+" "+self:oLan:WGet("not in range")}:Show()
	Return false

METHOD Close(oEvent) CLASS GiftReport
	//Put your changes here
// IF !self:Owner:oPersbw == null_object
// 	self:Owner:oPersbw:EndWindow()
// ENDIF
// IF !self:Owner:oAccbw == null_object
// 	self:Owner:oAccBw:EndWindow()
// ENDIF

self:oGftRpt:=null_object
// force garbage collection
// CollectForced()
	SUPER:Close(oEvent)
// CollectForced()
self:destroy()
	
RETURN
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS GiftReport
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "FROMACCOUNT"
			IF !Upper(AllTrim(oControl:Value))==Upper(AllTrim(cFromAccName))
				cFromAccName:=AllTrim(oControl:Value)
				SELF:FromAccButton(TRUE)
*				AccountSelect(SELF,AllTrim(oControl:Value),"From Member",TRUE,"GiftAlwd")
			ENDIF
		ELSEIF oControl:Name == "TOACCOUNT"
			IF !Upper(AllTrim(oControl:Value))==Upper(AllTrim(cToAccName))
				cToAccName:=AllTrim(oControl:Value)
				SELF:ToAccButton(TRUE)
*				AccountSelect((SELF,AllTrim(oControl:Value),"Till Member",TRUE,"GiftAlwd")
			ENDIF
		ENDIF
	ENDIF
	RETURN
ACCESS Footnotes() CLASS GiftReport
RETURN SELF:FieldGet(#Footnotes)

ASSIGN Footnotes(uValue) CLASS GiftReport
SELF:FieldPut(#Footnotes, uValue)
RETURN uValue

METHOD FromAccButton(lUnique ) CLASS GiftReport
	Default(@lUnique,FALSE)
// 	AccountSelect(self,AllTrim(oDCFromAccount:TEXTValue ),"From Member",lUnique,"GiftAlwd",,oAcc,,true)
	AccountSelect(self,AllTrim(oDCFromAccount:TEXTValue ),"From Member",lUnique,"GiftAlwd=1",,true)
RETURN true
ACCESS FromAccount() CLASS GiftReport
RETURN SELF:FieldGet(#FromAccount)

ASSIGN FromAccount(uValue) CLASS GiftReport
SELF:FieldPut(#FromAccount, uValue)
RETURN uValue

METHOD GiftsPrint(FromAccount as string,ToAccount as string,ReportYear as int,ReportMonth as int,nRow ref int,nPage ref int) as void pascal CLASS GiftReport
	* Memberstatements and Giftreport for member FromAccount till ToAccount in year
	* ReportYear to month ReportMonth
	*

	LOCAL a,b as STRING
	LOCAL aHeading as ARRAY
	local cHeading1,cFrom,cSubTotal as string
	LOCAL i,j,mndnum,gvr,gvrcur,nMonth, nReturn  as int
	LOCAL m71_deb,m71_cre,m71_gifthb,m71_giftrst,m71_chdeb,m71_chcre as FLOAT
	LOCAL  me_hbn, ocln,mndtxt,hlptxt, g_na1, cDesc as STRING
	LOCAL cPeriod,mPersid,mAccid, memberName, description as STRING
	LOCAL startdate,enddate as date
	LOCAL previousyear,previousmonth,regnaw, ASsStart,nMem as int
	LOCAL AssmntRow as int
	local dim aAssmntAmount[4,12] as float
	LOCAL fAmnt as FLOAT, iMonth as int
	LOCAL myLang:=Alg_taal as STRING
	* Array aAssmntAmount with 12 totals per code per month:
	* row 1:total, 2:AG,  3:PF,  4:PF,  5: MG
	* ARRAY aGiversdata with data of giver and gifts for each row:
	* 1 - Amount
	* 2 - persid
	* 3 - description
	* 4 - GC
	* 5 - Month
	* 6-11 - NAT 1-6
	* 12 - SORTKEY
	LOCAL aGiversdata as ARRAY
	LOCAL aASS as ARRAY
	LOCAL aOPP as ARRAY // {OPP,Trans_Type_Code,debit,credit} 
	local aPPCode:={} as array
	LOCAL nOPP as int, cOPP, cTypeOPP as STRING
	LOCAL oPPcd as SQLSelect
	LOCAL lSuccess as LOGIC
	LOCAL aTrType as ARRAY
	LOCAL lPrintFile, lSkip, lFirst, lFirstInMonth as LOGIC
	//LOCAL nRow, nPage AS INT
	LOCAL oMapi as MAPISession
	LOCAL oRecip1, oRecip2 as MAPIRecip
	LOCAL aMailMember:={}, aOneMember:={} as ARRAY
	LOCAL cFileName as USUAL, oFileSpec as FileSpec
	LOCAL oEMLFrm as eMailFormat
	LOCAL DueRequired,GiftsRequired,AddressRequired,repeatingGroup, lXls as LOGIC
	LOCAL mailcontent as STRING
	LOCAL oSelpers as Selpers
	LOCAL aAcc:={} as ARRAY
	LOCAL BoldOn, BoldOff, RedOn, RedOff as STRING
	LOCAL oPF as FileSpec, aFilePF as ARRAY 
	local nBeginmember as int  // position of start member statement in aFifo of a current member 
	local lTransFound as logic // is account active? 
	local oMBal as Balances 
	local PMCLastSend as date
	local oAcc,oTrans,oAccAss as SQLSelect
	local oPers as SQLSelectPerson
	LOCAL oPro as ProgressPer
	local CurLanguage as string 

	IF self:SendingMethod="SeperateFile"
		BoldOn:="{\b "
		BoldOff:="}"
		RedOn:="\cf1 "
		RedOff:="\cf0 "
	ENDIF

	IF .not.oReport:lPrintOk
		RETURN 
	ENDIF
	lPrintFile:=(oReport:Destination=="File")
	IF SendingMethod=="SeperateFileMail"
		(oEMLFrm := eMailFormat{oParent}):Show()
		IF oEMLFrm:lCancel
			RETURN 
		ENDIF
	ENDIF

	self:Pointer := Pointer{POINTERHOURGLASS}

	IF oGftRpt == null_object
		oGftRpt:=GiftsReport{}
		oGftRpt:Country:=self:Country
	ENDIF		
	oMBal:=Balances{}
	oPPcd := SQLSelect{"select ppcode,ppname from ppcodes order by ppcode",oConn} 
	PMCLastSend:=SQLSelect{"select pmislstsnd from sysparms",oConn}:FIELDGET(1)
	aPPCode:=oPPcd:GetLookupTable(200,#ppcode,#ppname)

	startdate:=SToD(Str(ReportYear,4)+'0101') 
	enddate:=SToD(Str(ReportYear,4)+Strzero(ReportMonth,2)+strzero(MonthEnd(ReportMonth,ReportYear),2))
	self:Pointer := Pointer{POINTERHOURGLASS}
	self:STATUSMESSAGE(self:oLan:WGet("Collecting data for the report, please wait")+"...")
	nRow := 0
	cPeriod:=Str(ReportYear,4)+Space(1)+iif(ReportMonth=1,'',oLan:Get('up incl'))+Space(1)+oLan:Get(MonthEn[ReportMonth],,"!")
	* Adapt Top of TransHistory to oldest year:
	// 	oTrans:ResetHistory(ReportYear,1,ReportYear,ReportMonth)

	// 	oAcc:SetFilter("GiftAlwd")
	// 	oAcc:Seek(FromAccount)
	IF SendingMethod=="SeperateFileMail"
		oMapi := MAPISession{}	
		IF !oMapi:Open( "" , "" )
			MessageBox( 0 , self:oLan:WGet("MAPI-Services not available") , self:oLan:WGet("Problem") , MB_ICONEXCLAMATION )
			RETURN
		ENDIF		
	ENDIF
	IF self:Memberstmnt=="ALLST"
		ASsStart:=1
	ELSE
		ASsStart:=ReportMonth
	ENDIF
	*
	*	Begin balance:
	previousyear:=ReportYear
	previousmonth:=ASsStart-1
	IF previousmonth<=0
		--previousyear
		previousmonth:=previousmonth+12
	ENDIF
	aAcc:=self:oDCSubSet:GetSelectedItems()
	if Len(aAcc)<1
		return
	endif

	oAcc:=SQLSelect{"select a.accid,a.description,a.accnumber,b.category,m.persid,m.householdid,m.homepp,m.contact,m.RPTDEST,"+;
		"group_concat(cast(ass.accid as char) separator ',') as assacc,"+SQLFullName(0,'pc')+" as contactfullname,pc.lastname as contactlstname,pc.email as contactemail"+;
		",pm.lastname,pm.email "+;
		" from balanceitem b,account a left join member m on (a.accid=m.accid) left join memberassacc ass on (ass.mbrid=m.mbrid)"+ ;
		" left join person pc on (pc.persid=m.contact) left join person pm on (pm.persid=m.persid)"+;
		" where a.balitemid=b.balitemid and a.giftalwd=1 and a.accnumber between '"+FromAccount+"' and '"+ToAccount+"'"+;
		" and a.accid in ('"+Implode(aAcc,"','")+"' ) group by a.accid order by a.accnumber",oConn}
	if oAcc:RecCount>1
		oPro:=ProgressPer{,oMainWindow}
		oPro:Caption:="Printing giftreports and member statements"
		oPro:SetRange(1,oAcc:RecCount+1)
		oPro:SetUnit(1)
		oPro:Show()
	endif
	oTrans:=SQLSelect{UnionTrans("select t.docid,t.transid,a.accid,t.persid,t.dat,t.deb,t.cre,t.fromrpp,bfm,t.opp,t.gc,t.description "+;
		"from transaction t, account a "+;
		"where a.accid=t.accid and t.dat>='"+SQLdate(startdate)+"' and t.dat<='"+SQLdate(enddate)+"'"+;
		" and t.accid in ('"+Implode(aAcc,"','")+"') order by accnumber,dat"),oConn}
	if oTrans:RecCount<1
		TextBox{self,self:oLan:WGet("Gift report"),self:oLan:WGet("Nothing to be reported")}:Show()
		return
	endif 

	do WHILE !oAcc:EOF
		mAccid:=Str(oAcc:accid,-1)
		lSkip:=FALSE
		lFirst:=true
		aOPP:={}
		aGiversdata:={}
		for i:=1 to 4
			for j:=1 to 12
				aAssmntAmount[i,j]:=0.00
			next
		next
// 		aAssmntAmount:={{0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0},;
// 			{0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0}}
		nPage :=0
		* Insert membername if print to seperate file: 
		nBeginmember:=Len(oReport:oPrintJob:aFiFo) 
		lTransFound:=false
		IF lPrintFile.and.!Empty(SendingMethod)
			AAdd(oReport:oPrintJob:aFiFo,MEMBER_START+AllTrim(StrTran(StrTran(oAcc:description,".",Space(1)),"/","")))
			nRow := 0
		ENDIF
		myLang:=Alg_taal
		IF Empty(oAcc:persid)
			me_hbn := Space(8)
		ELSE
			me_hbn:=oAcc:householdid
			IF oAcc:HOMEPP!=sEntity
				Alg_taal:="E"
			ENDIF
		ENDIF
		if !Alg_taal==CurLanguage
			aTrType:={{"AG",oLan:Get("Assessed Gifts (-10%)",,"!")},{"CH",oLan:Get("Charges",,"!")},{"MG",oLan:Get("Member Gifts",,"!")},{"PF",oLan:Get("Personal Funds",,"!")}}
			cHeading1:=Str(ReportYear,4)+Space(1)+iif(ASsStart # ReportMonth,oLan:Get(MonthEn[1],,"!")+Space(1)+oLan:Get("up incl")+Space(1)+oLan:Get(MonthEn[ReportMonth],,"!")+Space(1),;
			oLan:Get(MonthEn[ReportMonth],,"!")+Space(2))+oLan:Get('ACCOUNTBALANCE',,"@!")+":"+Space(1)+'%description%'
			* Compose heading:
			aHeading:={Space(1),Space(1),oLan:Get("Doc-id",10,"!")+Space(1)+oLan:Get("Date",10,"!")+Space(1)+;
			oLan:Get("Description",75,"!")+oLan:Get("Debit",12,"!","R")+Space(1)+;
			oLan:Get("Credit",12,"!","R")+Space(1)+oLan:Get("Transnbr",10,"!","R"),;
			Replicate ('-',133)} 
			cSubTotal:=oLan:Get('Subtotal',,"!")
			cFrom:=oLan:Get("from",,"!")
			CurLanguage:=Alg_taal
		endif
		aHeading[1]:=StrTran(cHeading1,'%description%',oAcc:ACCNUMBER+Space(1)+oAcc:description+Space(1)+iif(empty(me_hbn),'',' HOUSECD:'+me_hbn+space(1))+self:Country)
		*	Fill array aGivers with data of givers and gifts of corresponding destination and totalize them
		*	Print statement report


		memberName:=AllTrim(oAcc:Description)

		FOR nMonth:=1 to ReportMonth step 1
			IF ReportMonth=nMonth.or.self:Memberstmnt=="ALLST"
				store 0 to m71_deb,m71_cre,m71_gifthb,m71_giftrst,m71_chdeb,m71_chcre
				lFirstInMonth:=true
			ENDIF
			IF	lFirst .and.lFirstInMonth
				oReport:PrintLine(@nRow,@nPage,oLan:Get(MonthEn[nMonth],,"@!")+Space(1)+Str(ReportYear,4,0),aHeading)	
				lFirst:=FALSE
				oMBal:GetBalance(mAccid,,previousyear*100+previousmonth)
				oReport:PrintLine(@nRow,@nPage,;
					Pad(oLan:Get("Beginning Account balance",,"!")+Space(1)+oLan:Get(MonthEn[nMonth],,"!"),97)+;
					IF(oMBal:Per_deb-oMBal:Per_cre<0,Space(13)+Str(oMBal:Per_cre-oMBal:Per_deb,12,DecAantal),;
					Str(oMBal:Per_deb-oMBal:Per_cre,12,DecAantal)),aHeading) 
				lFirstInMonth:=false
			ENDIF

			aOPP:={}
			DO WHILE !oTrans:EOF .and.oTrans:accid==oAcc:accid .and. Month(oTrans:dat)<=nMonth 
				if	self:Memberstmnt=="NOST"
					IF	ReportMonth==Month(oTrans:dat) 
						lTransFound:=true
					ENDIF					
				ELSE

					*			Processing accountstatement:
					IF	ReportMonth==Month(oTrans:dat) .or. self:Memberstmnt=="ALLST"
						m71_deb:=m71_deb+oTrans:deb
						m71_cre:=m71_cre+oTrans:cre 
						lTransFound:=true
						//				IF	.not.Empty(Val(oAcc:persid)).and.!Empty(oTrans:persid)
						// 					IF	.not.	Empty(oTrans:persid)	.and.	oTrans:deb#oTrans:cre .and.!oTrans:FROMRPP .and.!oTrans:GC=="CH"
						IF	.not.	Empty(oTrans:persid)	.and.	oTrans:deb#oTrans:cre .and.!oTrans:gc=="CH"
							IF	oTrans:bfm='H'
								m71_gifthb:=m71_gifthb+oTrans:cre-oTrans:deb
							ELSE
								m71_giftrst:=m71_giftrst+oTrans:cre-oTrans:deb
							ENDIF
						ELSEIF oTrans:FROMRPP==1
							//	Processing of transactions	from other PO's:
							cOPP:=AllTrim(oTrans:OPP)
							cTypeOPP:=oTrans:gc
							IF	self:SendingMethod="SeperateFile"
								description:=StrTran(StrTran(StrTran(oTrans:description,"\","\\"),"{","\{"),"}","\}")
							else
								description:=oTrans:description
							endif
							IF	(nOPP:=AScan(aOPP,{|x|x[1]==cOPP	.and.	x[2]==cTypeOPP}))=0
								//						AAdd(aOPP,{cOPP,cTypeOPP,oTrans:DEB,oTrans:CRE,{oTrans:docid+space(1)+DToC(oTrans:dat)+space(1)+Pad(oTrans:description,80)+;
								AAdd(aOPP,{cOPP,cTypeOPP,oTrans:deb,oTrans:cre,{Pad(oTrans:docid,10)+Space(1)+DToC(oTrans:dat)+Space(1)+MemoLine(description,74,1)+Space(1)+;
									Str(oTrans:deb,12,DecAantal)+Space(1)+Str(oTrans:cre,12,DecAantal)+PadL(oTrans:TransId,11)}})
								nOPP:=Len(aOPP)
							ELSE
								aOpp[nOPP,3]+=oTrans:DEB
								aOpp[nOPP,4]+=oTrans:CRE
								AAdd(aOPP[nOPP,5],Pad(oTrans:docid,10)+Space(1)+DToC(oTrans:dat)+Space(1)+MemoLine(oTrans:description,74,1)+Space(1)+;
									Str(oTrans:deb,12,DecAantal)+Space(1)+Str(oTrans:cre,12,DecAantal)+PadL(oTrans:TransId,11))
							ENDIF
							nMem:=2
							DO	WHILE	!Empty(cDesc:=MemoLine(description,74,nMem))
								AAdd(aOPP[nOPP,5],Space(22)+cDesc)
								nMem++
							ENDDO
						ELSE
							m71_chdeb:=m71_chdeb+oTrans:deb
							m71_chcre:=m71_chcre+oTrans:cre
							IF	lFirstInMonth
								lFirstInMonth:=FALSE
								//	separation line
								oReport:PrintLine(@nRow,@nPage,Space(1),aHeading,2)
								oReport:PrintLine(@nRow,@nPage,oLan:Get(MonthEn[nMonth],,"@!")+Space(1)+Str(ReportYear,4,0),aHeading)	
							ENDIF
							IF	self:SendingMethod="SeperateFile"
								description:=StrTran(StrTran(StrTran(oTrans:description,"\","\\"),"{","\{"),"}","\}")
							ELSE
								description:=oTrans:description
							ENDIF
							oReport:PrintLine(@nRow,@nPage,;
								Pad(oTrans:docid,10)+space(1)+DToC(oTrans:dat)+space(1)+MemoLine(description,74,1)+space(1)+;
								Str(oTrans:deb,12,DecAantal)+Space(1)+Str(oTrans:cre,12,DecAantal)+PadL(oTrans:TransId,11),aHeading)
							IF	Len(aHeading)>4
								aHeading:=ASize(aHeading,4)
							ENDIF
							nMem:=2
							DO	WHILE	!Empty(cDesc:=MemoLine(description,74,nMem))
								oReport:PrintLine(@nRow,@nPage,Space(22)+cDesc,aHeading)
								nMem++
							ENDDO
						ENDIF
					ENDIF
				ENDIF

				*			processing of gifts:
				IF .not. Empty(oTrans:persid) .and. oTrans:deb#oTrans:cre .and.!oTrans:gc=="CH"
					fAmnt:=  oTrans:cre - oTrans:deb
					iMonth:= Month(oTrans:dat)
					AAdd(aGiversdata,{fAmnt,oTrans:persid,AllTrim(oTrans:description),;
						IF(ADMIN="WO".or.Admin="HO",Upper(oTrans:gc),""),iMonth,;
						"","","","","","",""})
					*				calculate totals assesment percode and month:
					aAssmntAmount[1,iMonth]:=aAssmntAmount[1,iMonth] + fAmnt   && total
					IF Upper(oTrans:gc) = "AG"
						AssmntRow := 2
					ELSEIF Upper(oTrans:gc) = "MG"
						AssmntRow := 4
					ELSE
						AssmntRow := 3         && default = personal fund
					ENDIF
					aAssmntAmount[AssmntRow,iMonth]:=aAssmntAmount[AssmntRow,iMonth]+fAmnt
				ENDIF
				oTrans:Skip()
			ENDDO 
			IF ReportMonth=nMonth.and.self:SkipInactive .and. !lTransFound
				*  Skip members without transactions:
				* remove added member lines:
				ASize(oReport:oPrintJob:aFiFo,nBeginmember)
				lSkip:=true
				exit
			ENDIF
			if !self:Memberstmnt=="NOST"
				* processing end of month:
				IF	ReportMonth=nMonth.or.self:Memberstmnt=="ALLST"
					*	Print closing lines account statement:
					IF	Len(aOPP)>0	.or. m71_gifthb#0	.or. m71_giftrst#0
						oReport:PrintLine(@nRow,@nPage,+Space(97)+'------------ ------------',aHeading,3)
						oReport:PrintLine(@nRow,@nPage,;
							Pad(Space(11)+cSubTotal,97)+;
							Str(m71_chdeb,12,decaantal)+space(1)+Str(m71_chcre,12,decaantal),aHeading)
					ENDIF
					* Printing of amounts from	OPP's:
					aOPP:=ASort(aOPP,,,{|x,y|x[1]<=y[1]	.and.	x[2]<=y[2]})
					FOR i:=1	to	Len(aOPP)
						cOPP:=aOPP[i,1]
						j:=AScan(aPPCode,{|x|x[1]==cOPP})
						IF	j>0
							cOPP:=AllTrim(aPPCode[j,2])
						ENDIF
						cTypeOPP:=aOPP[i,2]
						j:=AScan(aTrType,{|x|x[1]==cTypeOPP})
						IF	j>0
							cTypeOPP:=aTrType[j,2]
						ENDIF
						oReport:PrintLine(@nRow,@nPage,;
							Pad(cFrom+Space(1)+cOPP+": "+cTypeOPP,87),aHeading)
						FOR j:=1	to	Len(aOPP[i,5])
							oReport:PrintLine(@nRow,@nPage,aOPP[i,5][j],aHeading)									
						NEXT
						oReport:PrintLine(@nRow,@nPage,Space(97)+'------------ ------------',aHeading)
						oReport:PrintLine(@nRow,@nPage,;
							Pad(Space(11)+cSubTotal+Space(1)+cFrom+Space(1)+cOPP+": "+cTypeOPP,97)+;
							Str(aOPP[i,3],12,decaantal)+Space(1)+Str(aOPP[i,4],12,decaantal),aHeading)				
					NEXT
					* Printing of amounts received as gifts:
					m71_gifthb:=Round(m71_gifthb,DecAantal)
					m71_giftrst:=Round(m71_giftrst,DecAantal)			
					IF	PMCLastSend<Today()-400
						//	still	IES
						IF	m71_gifthb#0
							oReport:PrintLine(@nRow,@nPage,;
								Pad(oLan:Get("Total gifts/own funds",,"!")+Space(1)+oLan:Get("sent to")+' PMC',110)+;
								Str(m71_gifthb,12,DecAantal),aHeading)
						ENDIF
						IF	m71_giftrst#0
							oReport:PrintLine(@nRow,@nPage,;
								Pad(oLan:Get("Total gifts/own funds",,"!")+Space(1)+;
								IF(ADMIN="WO".or.ADMIN="HO",""+oLan:Get("not yet send TO",,"!")+" PMC",""),110)+;
								Str(m71_giftrst,12,DecAantal),aHeading)
						ENDIF
					ELSE
						IF	m71_gifthb+m71_giftrst#0
							//	separation line
							oReport:PrintLine(@nRow,@nPage,Space(1),aHeading,2)
							oReport:PrintLine(@nRow,@nPage,;
								Pad(oLan:Get("Total gifts/own funds (See below)",,"!")+Space(1),110)+;
								Str(m71_gifthb+m71_giftrst,12,DecAantal),aHeading)
						ENDIF				
					ENDIF
					oReport:PrintLine(@nRow,@nPage,Space(97)+'------------ ------------',aHeading,3)
					oReport:PrintLine(@nRow,@nPage,;
						Pad(oLan:Get('total',,"!")+Space(1)+oLan:Get('transactions'),97)+;
						Str(m71_deb,12,decaantal)+Space(1)+Str(m71_cre,12,decaantal),aHeading)
					oReport:PrintLine(@nRow,@nPage,;
						Pad(oLan:Get('Balance',,"!")+Space(1)+oLan:Get('transactions'),97)+;
						IF(m71_deb-m71_cre<=0,Space(13)+Str(m71_cre-m71_deb,12,DecAantal),;
						Str(m71_deb-m71_cre,12,DecAantal)),aHeading) 
					oMBal:GetBalance(mAccid,,ReportYear*100+nMonth)
					
					oReport:PrintLine(@nRow,@nPage,;
						BoldOn+Pad(oLan:Get('Account balance',,"!")+Space(1)+oLan:Get(MonthEn[nMonth],,"!"),97)+;
						IF(oMBal:Per_deb-oMBal:Per_cre<=0,Space(13)+Str(oMBal:Per_cre-oMBal:Per_deb,12,DecAantal),;
						RedOn+Str(oMBal:Per_deb-oMBal:Per_cre,12,DecAantal)+RedOff)+BoldOff,aHeading)
				ENDIF
			ENDIF
		NEXT
		IF lSkip
			oAcc:Skip()
			Alg_taal:=myLang
			loop
		ENDIF
		if	!self:Memberstmnt=="NOST"
			nRow:=0	&&	enforce page skip
			*	If	associated accounts for	this member, print also	corresponding accountstatements for	this month:
			IF	!Empty(oAcc:persid) .and.!Empty(oAcc:assacc)
				IF	oTransMonth==null_object
					oTransMonth:=AccountStatements{79}
				ENDIF
				oTransMonth:oReport:=self:oReport
				oTransMonth:SendingMethod:=SendingMethod
				aASS:=Split(oAcc:assacc,',')
				//aASS:={oMbr:REK1,oMbr:REK2,oMbr:REK3}
				FOR i:=1	to	Len(aASS)
					IF	!Empty(aASS[i])
						oAccAss:=SQLSelect{"select accnumber from account where accid='"+aASS[i]+"'",oConn}
						if oAccAss:RecCount>0
							oTransMonth:MonthPrint(oAccAss:ACCNUMBER,oAccAss:ACCNUMBER,ReportYear,ASsStart,ReportYear,ReportMonth,@nRow,@nPage,,oLan)
							nRow:=0	&&	forceer bladskip
						endif
					ENDIF
				NEXT
			ENDIF
		endif

		// Print gifts matrix:
		for i:=1 to 4
			for j:=1 to 12
				oGftRpt:aAssmntAmount[i,j]:=aAssmntAmount[i,j]
			next
		next
		oGftRpt:GiftsOverview(ReportYear,ReportMonth,Footnotes, aGiversdata,oReport, oAcc:ACCNUMBER+Space(1)+oAcc:description,@nRow,@nPage)
		*	
		*	Proces e-mail:
		IF lPrintFile.and. SendingMethod=="SeperateFileMail"
			IF !Empty(oAcc:persid)  // skip funds
				aOneMember:={}          //
				AAdd(aOneMember,{AllTrim(StrTran(oAcc:description,".",Space(1))),oAcc:persid,oAcc:email})
				IF !Empty(oAcc:CONTACT)
					IF self:mailcontact .and.Empty(oAcc:RPTDEST)
						AAdd(aOneMember,{2,oAcc:contactlstname,oAcc:CONTACT,oAcc:contactfullname,oAcc:contactemail})
					ELSE
						AAdd(aOneMember,{oAcc:RPTDEST,oAcc:contactlstname,oAcc:CONTACT,oAcc:contactfullname,oAcc:contactemail})		//Destination member statements: 0: member, 1: contact, 2: member+contact			
					ENDIF
				ELSE
					AAdd(aOneMember,{0,""})
				ENDIF
				AAdd(aMailMember,aOneMember)
				//			AAdd(aMailMember,{AllTrim(StrTran(oAcc:description,".",space(1))),oAcc:persid})
			ENDIF
		ENDIF
		oAcc:Skip()
		Alg_taal:=myLang
		if !Empty(oPro)
			oPro:AdvancePro()
		endif

	ENDDO
	IF !oPro==null_object
		oPro:EndDialog()
		oPro:Destroy()
	ENDIF

	cFileName:=oReport:prstart(!Empty(SendingMethod))    // generate rtf-format when seperate files
	IF IsString(cFileName)
		IF SendingMethod=="SeperateFileMail"
			oSelpers:=Selpers{self,,}
			oSelpers:AnalyseTxt(oEMLFrm:Template,@DueRequired,@GiftsRequired,@AddressRequired,@repeatingGroup,1,0)
			
			FOR i:=1 to Len(aMailMember)
				self:STATUSMESSAGE(self:oLan:WGet("Placing mail messages in outbox of mailing system, please wait")+"...")
				oRecip1:=null_object
				oRecip2:=null_object
				// 					memberName:=StrTran(StrTran(GetFullName(aMailMember[i,1,2]),"\",""),"/","")
				memberName:=StrTran(StrTran(aMailMember[i,1,1],"\",""),"/","")
				IF aMailMember[i,2,1]<>1    // Destination 0: member, 1: contact, 2: member+contact
					* Resolve membername:
					oRecip1 := oMapi:ResolveName( memberName,aMailMember[i,1,2],memberName,aMailMember[i,1,3])
					IF !IsNil(aMailMember[i,2,1]).and.!Empty(aMailMember[i,2,1])
						IF aMailMember[i,2,1]=2
							* Resolve contactname for cc:
							oRecip2 := oMapi:ResolveName(aMailMember[i,2,2],aMailMember[i,2,3],aMailMember[i,2,4],aMailMember[i,2,5])
						ENDIF
					ENDIF
				ELSE
					// only contact:
					* Resolve contactname for to:
					oRecip1 := oMapi:ResolveName( aMailMember[i,2,2],aMailMember[i,2,3],aMailMember[i,2,4],aMailMember[i,2,5])
				ENDIF
				IF oRecip1 != null_object
					IF !Empty(oEMLFrm:Template)
						oPers:=SQLSelectPerson{"select * from person where persid='"+iif(aMailMember[i,2,1]=1,Str(aMailMember[i,2,3],-1),Str(aMailMember[i,1,2],-1))+"'",oConn}
						oSelpers:oDB:=oPers 
						oSelpers:ReportMonth:=cPeriod
						mailcontent:=oSelpers:FillText(oEMLFrm:Template,1,DueRequired,GiftsRequired,AddressRequired,repeatingGroup,60)
					ELSE
						mailcontent:=""
					ENDIF
					oFileSpec:=FileSpec{cFileName}
					oFileSpec:FileName:=AllTrim(oFileSpec:FileName)+Space(1)+StrTran(StrTran(aMailMember[i,1,1],"\",""),"/","")
					oMapi:SendDocument( oFileSpec,oRecip1,oRecip2,oLan:Get('GIFTREPORT',,"@!")+Space(1)+memberName+": "+cPeriod,mailcontent)
				ENDIF
			NEXT
			oMapi:Close()
		ENDIF
	ENDIF
	self:Pointer := Pointer{POINTERARROW}
	IF !oSelpers==null_object
		oSelpers:Close()
		oSelpers:=null_object
	ENDIF
	oReport:prstop()
	// remove old giftreports:
	aFilePF:=Directory(CurPath+"\"+self:oLan:RGet("Giftreport")+"*.doc")
	FOR i:=1 to Len(aFilePF)
		IF aFilePF[i,F_DATE]<(Today()-90)
			oPF := MyFileSpec{aFilePF[i,F_NAME]}
			IF oPF:FileLock()
				oPF:Delete()
			ENDIF
		ENDIF
	NEXT
	RETURN
ACCESS HomeBox() CLASS GiftReport
RETURN SELF:FieldGet(#HomeBox)

ASSIGN HomeBox(uValue) CLASS GiftReport
SELF:FieldPut(#HomeBox, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS GiftReport 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"GiftReport",_GetInst()},iCtlID)

oDCHomeBox := CheckBox{SELF,ResourceID{GIFTREPORT_HOMEBOX,_GetInst()}}
oDCHomeBox:HyperLabel := HyperLabel{#HomeBox,"Members of",NULL_STRING,NULL_STRING}

oDCNonHomeBox := CheckBox{SELF,ResourceID{GIFTREPORT_NONHOMEBOX,_GetInst()}}
oDCNonHomeBox:HyperLabel := HyperLabel{#NonHomeBox,"Members not of",NULL_STRING,NULL_STRING}

oDCProjectsBox := CheckBox{SELF,ResourceID{GIFTREPORT_PROJECTSBOX,_GetInst()}}
oDCProjectsBox:HyperLabel := HyperLabel{#ProjectsBox,"Projects",NULL_STRING,NULL_STRING}

oDCFromAccount := SingleLineEdit{SELF,ResourceID{GIFTREPORT_FROMACCOUNT,_GetInst()}}
oDCFromAccount:HyperLabel := HyperLabel{#FromAccount,NULL_STRING,NULL_STRING,NULL_STRING}
oDCFromAccount:FieldSpec := Account_AccNumber{}

oCCFromAccButton := PushButton{SELF,ResourceID{GIFTREPORT_FROMACCBUTTON,_GetInst()}}
oCCFromAccButton:HyperLabel := HyperLabel{#FromAccButton,"v","Browse in accounts",NULL_STRING}
oCCFromAccButton:TooltipText := "Browse in accounts"

oDCToAccount := SingleLineEdit{SELF,ResourceID{GIFTREPORT_TOACCOUNT,_GetInst()}}
oDCToAccount:HyperLabel := HyperLabel{#ToAccount,NULL_STRING,NULL_STRING,NULL_STRING}
oDCToAccount:FieldSpec := Account_AccNumber{}

oCCToAccButton := PushButton{SELF,ResourceID{GIFTREPORT_TOACCBUTTON,_GetInst()}}
oCCToAccButton:HyperLabel := HyperLabel{#ToAccButton,"v",NULL_STRING,NULL_STRING}
oCCToAccButton:TooltipText := "Browse in Accounts"

oDCFixedText5 := FixedText{SELF,ResourceID{GIFTREPORT_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Print up to which month?",NULL_STRING,NULL_STRING}

oDCSubSet := ListboxGiftReport{SELF,ResourceID{GIFTREPORT_SUBSET,_GetInst()}}
oDCSubSet:TooltipText := "Select subset of given range of member/funds"
oDCSubSet:HyperLabel := HyperLabel{#SubSet,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSubSet:OwnerAlignment := OA_WIDTH_HEIGHT

oDCPeilJaar := SingleLineEdit{SELF,ResourceID{GIFTREPORT_PEILJAAR,_GetInst()}}
oDCPeilJaar:HyperLabel := HyperLabel{#PeilJaar,NULL_STRING,NULL_STRING,NULL_STRING}
oDCPeilJaar:Picture := "9999"

oDCPeilMnd := SingleLineEdit{SELF,ResourceID{GIFTREPORT_PEILMND,_GetInst()}}
oDCPeilMnd:Picture := "99"
oDCPeilMnd:HyperLabel := HyperLabel{#PeilMnd,NULL_STRING,NULL_STRING,NULL_STRING}

oCCLastMonth1 := RadioButton{SELF,ResourceID{GIFTREPORT_LASTMONTH1,_GetInst()}}
oCCLastMonth1:HyperLabel := HyperLabel{#LastMonth1,"Last month",NULL_STRING,NULL_STRING}

oCCAllMonths1 := RadioButton{SELF,ResourceID{GIFTREPORT_ALLMONTHS1,_GetInst()}}
oCCAllMonths1:HyperLabel := HyperLabel{#AllMonths1,"All months",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{GIFTREPORT_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Members/funds",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{GIFTREPORT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}
oCCCancelButton:OwnerAlignment := OA_Y

oDCFixedText1 := FixedText{SELF,ResourceID{GIFTREPORT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"From:",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{GIFTREPORT_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"To:",NULL_STRING,NULL_STRING}

oDCTextfrom := FixedText{SELF,ResourceID{GIFTREPORT_TEXTFROM,_GetInst()}}
oDCTextfrom:HyperLabel := HyperLabel{#Textfrom,NULL_STRING,NULL_STRING,NULL_STRING}

oDCTextTill := FixedText{SELF,ResourceID{GIFTREPORT_TEXTTILL,_GetInst()}}
oDCTextTill:HyperLabel := HyperLabel{#TextTill,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{GIFTREPORT_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Subset:",NULL_STRING,NULL_STRING}

oCCPrintreport := PushButton{SELF,ResourceID{GIFTREPORT_PRINTREPORT,_GetInst()}}
oCCPrintreport:HyperLabel := HyperLabel{#Printreport,"Print",NULL_STRING,NULL_STRING}

oCCSeparateFiles := PushButton{SELF,ResourceID{GIFTREPORT_SEPARATEFILES,_GetInst()}}
oCCSeparateFiles:HyperLabel := HyperLabel{#SeparateFiles,"Save seperate printfile per member",NULL_STRING,NULL_STRING}

oCCSeparateFilesMail := PushButton{SELF,ResourceID{GIFTREPORT_SEPARATEFILESMAIL,_GetInst()}}
oCCSeparateFilesMail:HyperLabel := HyperLabel{#SeparateFilesMail,"Send separate printfile by email to each member",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{GIFTREPORT_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Requierd action:",NULL_STRING,NULL_STRING}

oCCLastMonth := RadioButton{SELF,ResourceID{GIFTREPORT_LASTMONTH,_GetInst()}}
oCCLastMonth:HyperLabel := HyperLabel{#LastMonth,"Last month",NULL_STRING,NULL_STRING}

oCCAllMonths := RadioButton{SELF,ResourceID{GIFTREPORT_ALLMONTHS,_GetInst()}}
oCCAllMonths:HyperLabel := HyperLabel{#AllMonths,"All months",NULL_STRING,NULL_STRING}

oDCmailcontact := CheckBox{SELF,ResourceID{GIFTREPORT_MAILCONTACT,_GetInst()}}
oDCmailcontact:HyperLabel := HyperLabel{#mailcontact,"eMail also to contact person",NULL_STRING,NULL_STRING}

oDCSkipInactive := CheckBox{SELF,ResourceID{GIFTREPORT_SKIPINACTIVE,_GetInst()}}
oDCSkipInactive:HyperLabel := HyperLabel{#SkipInactive,"Skip inactive accounts","Suppress reports with no financial transaction in Last/All Months",NULL_STRING}
oDCSkipInactive:UseHLforToolTip := True

oCCNoStmnts := RadioButton{SELF,ResourceID{GIFTREPORT_NOSTMNTS,_GetInst()}}
oCCNoStmnts:HyperLabel := HyperLabel{#NoStmnts,"None",NULL_STRING,NULL_STRING}

oDCSelectedCnt := FixedText{SELF,ResourceID{GIFTREPORT_SELECTEDCNT,_GetInst()}}
oDCSelectedCnt:HyperLabel := HyperLabel{#SelectedCnt,NULL_STRING,NULL_STRING,NULL_STRING}

oDCMemberstmnt := RadioButtonGroup{SELF,ResourceID{GIFTREPORT_MEMBERSTMNT,_GetInst()}}
oDCMemberstmnt:FillUsing({ ;
							{oCCLastMonth1,"LastSt"}, ;
							{oCCAllMonths1,"ALLST"}, ;
							{oCCNoStmnts,"NOST"} ;
							})
oDCMemberstmnt:HyperLabel := HyperLabel{#Memberstmnt,"Member statements",NULL_STRING,NULL_STRING}

oDCFootnotes := RadioButtonGroup{SELF,ResourceID{GIFTREPORT_FOOTNOTES,_GetInst()}}
oDCFootnotes:FillUsing({ ;
							{oCCLastMonth,"Last"}, ;
							{oCCAllMonths,"All"} ;
							})
oDCFootnotes:HyperLabel := HyperLabel{#Footnotes,"Footnotes",NULL_STRING,NULL_STRING}

SELF:Caption := "Gift report and member statement"
SELF:HyperLabel := HyperLabel{#GiftReport,"Gift report and member statement",NULL_STRING,NULL_STRING}
SELF:EnableStatusBar(True)

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method ListBoxSelect(oControlEvent) class GiftReport
	local oControl as Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControlEvent:NameSym==#SubSet
		self:oDCSelectedCnt:TEXTValue:=Str(self:oDCSubSet:SelectedCount,-1)+" selected"
	endif	
	return nil

ACCESS mailcontact() CLASS GiftReport
RETURN SELF:FieldGet(#mailcontact)

ASSIGN mailcontact(uValue) CLASS GiftReport
SELF:FieldPut(#mailcontact, uValue)
RETURN uValue

ACCESS Memberstmnt() CLASS GiftReport
RETURN SELF:FieldGet(#Memberstmnt)

ASSIGN Memberstmnt(uValue) CLASS GiftReport
SELF:FieldPut(#Memberstmnt, uValue)
RETURN uValue

ACCESS NonHomeBox() CLASS GiftReport
RETURN SELF:FieldGet(#NonHomeBox)

ASSIGN NonHomeBox(uValue) CLASS GiftReport
SELF:FieldPut(#NonHomeBox, uValue)
RETURN uValue

METHOD OKButton( ) CLASS GiftReport
	LOCAL nAcc as STRING
	LOCAL nRow, nPage as int


	IF ValidateControls( self, self:AControls )
		IF SendingMethod=="SeperateFileMail"
			IF !IsMAPIAvailable()
				(ErrorBox{self:Owner,self:oLan:WGet("Outlook not default mailing system or no interface to it")}):show()
				RETURN true
			ENDIF
		ENDIF
		self:CalcYear:=Round(Val(self:oDCPeilJaar:TextValue),0)
		self:CalcMonth:=Round(Val(self:oDCPeilMnd:TextValue),0)
		IF self:CalcYear>self:MaxJaar
			(ErrorBox{self:Owner,self:oLan:WGet("Year out of range")}):show()
		ELSEIF self:CalcYear<self:MinJaar
			(ErrorBox{self:Owner,self:oLan:WGet("Year out of range")}):show()
		ELSEIF self:CalcMonth<1
			(ErrorBox{self:Owner,self:oLan:WGet("Month out of range")}):show()
		ELSEIF self:CalcMonth>12
			(ErrorBox{self:Owner,self:oLan:WGet("Month out of range")}):show()
		ELSEIF Empty(self:FromAccount)
			(ErrorBox{self:Owner,self:oLan:WGet("Specify From Member")}):show()
		ELSE
			IF Empty(self:ToAccount)
				self:ToAccount := self:FromAccount
			ELSEIF self:ToAccount < self:FromAccount
				nAcc := self:ToAccount
				self:ToAccount := self:FromAccount
				self:FromAccount := nAcc
			ENDIF
			self:oReport := PrintDialog{oParent,self:oLan:RGet("Giftreport")+Str(self:PeilJaar,4)+StrZero(self:PeilMnd,2),,137,DMORIENT_LANDSCAPE}
			IF	SendingMethod="SeperateFile"
				self:oReport:OKButton("File",true)
			ELSE
				self:oReport:show()
			ENDIF
			self:GiftsPrint(self:FromAccount,self:ToAccount,self:CalcYear,self:CalcMonth,@nRow,@nPage)
		ENDIF
	ENDIF
	RETURN true
ACCESS PeilJaar() CLASS GiftReport
RETURN SELF:FieldGet(#PeilJaar)

ASSIGN PeilJaar(uValue) CLASS GiftReport
SELF:FieldPut(#PeilJaar, uValue)
RETURN uValue

ACCESS PeilMnd() CLASS GiftReport
RETURN SELF:FieldGet(#PeilMnd)

ASSIGN PeilMnd(uValue) CLASS GiftReport
SELF:FieldPut(#PeilMnd, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS GiftReport
	//Put your PostInit additions here
self:SetTexts()

store Month(Today()-27) to peilmnd,peilmax
store Year(Today()-27) to peiljaar
store Year(LstYearClosed) to startjaar
store Year(Today()) to maxjaar
self:Country:=SQLSelect{"select countryown from sysparms",oConn}:FIELDGET(1)

Footnotes:="Last"
Memberstmnt:="LastSt"
self:oDCHomeBox:Caption:=self:oLan:WGet("Members of")+" "+sLand
self:oDCNonHomeBox:Caption:=self:oLan:WGet("Members not of")+" "+sLand
HomeBox:=true
self:NonHomeBox:=true
self:ProjectsBox:=true
self:AccFil() 
if FromAccount==ToAccount
	self:SkipInactive:=false
else
	if self:Memberstmnt="ALLST"
		self:SkipInactive:=false 
		self:oDCSkipInactive:ToolTipText:=self:oLan:WGet("Suppress reports with no financial transaction in All Months")
	else
		self:SkipInactive:=true
		self:oDCSkipInactive:ToolTipText:=self:oLan:WGet("Suppress reports with no financial transaction in Last Month")
	endif
endif


RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS GiftReport
	//Put your PreInit additions here
	self:FillMbrProjArray()

	RETURN NIL

METHOD Printreport( ) CLASS GiftReport 
	self:SendingMethod:=""
	self:OKButton()
RETURN NIL
ACCESS ProjectsBox() CLASS GiftReport
RETURN SELF:FieldGet(#ProjectsBox)

ASSIGN ProjectsBox(uValue) CLASS GiftReport
SELF:FieldPut(#ProjectsBox, uValue)
RETURN uValue

METHOD RegAccount(omAcc,ItemName) CLASS GiftReport
	LOCAL oAccount as SQLSelect
	IF Empty(omAcc).or.omAcc==null_object
		RETURN
	ENDIF
	oAccount:=omAcc
	IF ItemName == "From Member"
		if self:CheckAccInRange(oAccount:accid,oAccount:ACCNUMBER)
			self:FromAccount:= LTrimZero(oAccount:AccNumber) 
			self:oDCFromAccount:TEXTValue := FromAccount
			self:cFromAccName := FromAccount
			self:oDCTextfrom:caption := AllTrim(oAccount:Description)
			self:oDCSubSet:AccNbrStart:=self:FromAccount
			self:oDCSelectedCnt:TEXTValue:=Str(self:oDCSubSet:SelectedCount,-1)+" selected"
		endif
	ELSEIF ItemName == "Till Member"
		if self:CheckAccInRange(oAccount:accid,oAccount:ACCNUMBER)
			self:ToAccount:= LTrimZero(oAccount:AccNumber)
			self:oDCToAccount:TEXTValue := ToAccount
			self:cToAccName := ToAccount
			self:oDCTextTill:caption := AllTrim(oAccount:Description)
			self:oDCSubSet:AccNbrEnd:=ToAccount
			self:oDCSelectedCnt:TEXTValue:=Str(self:oDCSubSet:SelectedCount,-1)+" selected"
		endif
	ENDIF
	if FromAccount==ToAccount
		self:SkipInactive:=false
	else
		if self:Memberstmnt="ALLST"
			self:SkipInactive:=false
		else
			self:SkipInactive:=true
		endif
	endif
	
	RETURN true
METHOD SeparateFiles( ) CLASS GiftReport
	SendingMethod:="SeperateFile"
	SELF:OKButton()
METHOD SeparateFilesMail( ) CLASS GiftReport
	SendingMethod:="SeperateFileMail"
	SELF:OKButton()
ACCESS SkipInactive() CLASS GiftReport
RETURN SELF:FieldGet(#SkipInactive)

ASSIGN SkipInactive(uValue) CLASS GiftReport
SELF:FieldPut(#SkipInactive, uValue)
RETURN uValue

ACCESS SubSet() CLASS GiftReport
RETURN SELF:FieldGet(#SubSet)

ASSIGN SubSet(uValue) CLASS GiftReport
SELF:FieldPut(#SubSet, uValue)
RETURN uValue

METHOD ToAccButton(lUnique ) CLASS GiftReport
	Default(@lUnique,FALSE)
// 	AccountSelect(self,AllTrim(oDCToAccount:TEXTValue ),"Till Member",lUnique,"GiftAlwd",,oAcc,,true)
	AccountSelect(self,AllTrim(oDCToAccount:TEXTValue ),"Till Member",lUnique,"GiftAlwd=1",,true)
RETURN true
ACCESS ToAccount() CLASS GiftReport
RETURN SELF:FieldGet(#ToAccount)

ASSIGN ToAccount(uValue) CLASS GiftReport
SELF:FieldPut(#ToAccount, uValue)
RETURN uValue

STATIC DEFINE GIFTREPORT_ALLMONTHS := 126 
STATIC DEFINE GIFTREPORT_ALLMONTHS1 := 112 
STATIC DEFINE GIFTREPORT_CANCELBUTTON := 114 
STATIC DEFINE GIFTREPORT_FIXEDTEXT1 := 115 
STATIC DEFINE GIFTREPORT_FIXEDTEXT2 := 116 
STATIC DEFINE GIFTREPORT_FIXEDTEXT5 := 107 
STATIC DEFINE GIFTREPORT_FIXEDTEXT7 := 119 
STATIC DEFINE GIFTREPORT_FOOTNOTES := 127 
STATIC DEFINE GIFTREPORT_FROMACCBUTTON := 104 
STATIC DEFINE GIFTREPORT_FROMACCOUNT := 103 
STATIC DEFINE GIFTREPORT_GROUPBOX1 := 113 
STATIC DEFINE GIFTREPORT_GROUPBOX2 := 124 
STATIC DEFINE GIFTREPORT_HOMEBOX := 100 
STATIC DEFINE GIFTREPORT_LASTMONTH := 125 
STATIC DEFINE GIFTREPORT_LASTMONTH1 := 111 
STATIC DEFINE GIFTREPORT_MAILCONTACT := 128 
STATIC DEFINE GIFTREPORT_MEMBERSTMNT := 120 
STATIC DEFINE GIFTREPORT_NONHOMEBOX := 101 
STATIC DEFINE GIFTREPORT_NOSTMNTS := 130 
STATIC DEFINE GIFTREPORT_PEILJAAR := 109 
STATIC DEFINE GIFTREPORT_PEILMND := 110 
STATIC DEFINE GIFTREPORT_PRINTREPORT := 121 
STATIC DEFINE GIFTREPORT_PROJECTSBOX := 102 
STATIC DEFINE GIFTREPORT_SELECTEDCNT := 131 
STATIC DEFINE GIFTREPORT_SEPARATEFILES := 122 
STATIC DEFINE GIFTREPORT_SEPARATEFILESMAIL := 123 
STATIC DEFINE GIFTREPORT_SKIPINACTIVE := 129 
STATIC DEFINE GIFTREPORT_SUBSET := 108 
STATIC DEFINE GIFTREPORT_TEXTFROM := 117 
STATIC DEFINE GIFTREPORT_TEXTTILL := 118 
STATIC DEFINE GIFTREPORT_TOACCBUTTON := 106 
STATIC DEFINE GIFTREPORT_TOACCOUNT := 105 
CLASS GiftsReport
	EXPORT Country as STRING
	protect oLan as Language
	protect DecFrac as int
	protect aAsmntDescr as ARRAY
	protect GiftDesc,NonEarDesc,cHeading1,cHeading2,cHeading3,cHeading4,cHeading5 as string
	protect CurLanguage as string
	export dim aAssmntAmount[4,12] as float

	declare method GiftsOverview,InitializeTexts
METHOD GiftsOverview(ReportYear as int,ReportMonth as int,Footnotes as string, aGiversdata as array,oReport as PrintDialog ,description as string,nRow ref int,nPage ref int,addHeading:='' as string) as void pascal CLASS GiftsReport
	*	Markup of overview of givers and gifts from the beginning of a year for one destination 
	*  aGiversdata: contains all gifts with id of giver
	LOCAL g_na1,mndtxt,cPeriodTxt,hlptxt,me_hbn as STRING
	LOCAL CurOrder as STRING
	LOCAL oPers as SQLSelectPerson
	LOCAL i,j,mndnum,gvr,gvrcur,AddrPnt,nMonth, nReturn,asmntRow,RowCnt,AddressRow,RowSav,nDecFrac:=self:DecFrac,nDecFrac1,iMonth,PersidSav  as int 
	local lFirst as logic
	local dim GiftAmnt[12] as float
	local AssTot as float
	* Array aAssmntAmount with 12 totalised amounts per assessment code per month:
	* per row [1]:total, [2]:AG,  [3]:PF,  [4]:PF,  [5]: MG
	LOCAL AsmntRowCnt:=4 as int
	LOCAL aAddress as ARRAY  // contains address lines of one giver 
	LOCAL aMbrAddresses:={} as ARRAY // contains of all givers the addresslines {Recno,aAsdress),...}
	local dim aGiversGC[12] as string                  
	LOCAL dim NoteRef[12] as string
	LOCAL aMsg, aRow as ARRAY
	LOCAL aHeading as ARRAY
	LOCAL separator = Replicate('-',40)+'|-------|-------|-------|-------|-------|'+;
		'-------|-------|-------|-------|-------|-------|-------|'
	LOCAL RowCnt,NoteNumber,GClen,CurPersid as int
	local cPersids as string 

	nRow:=0  && enforce page skip
	nDecFrac1:=Max(0,nDecFrac - 1)
	self:InitializeTexts(ReportYear,ReportMonth)
	* Sort on person id: 

	ASort(aGiversdata,,,{|x,y| x[PRSID]<y[PRSID].or.x[PRSID]==y[PRSID].and.x[MND]<=y[MND]})
	for i:=1 to Len(aGiversdata)
		if !aGiversdata[i,PRSID]==PersidSav
			cPersids+=","+Str(aGiversdata[i,PRSID],-1)
			PersidSav:=aGiversdata[i,PRSID]
		endif
	next
	// select all person data:
	oPers:=SQLSelectPerson{"select email,country,address,city,postalcode,gender,title,prefix,lastname,firstname,initials,attention,nameext,persid from person where persid in ("+SubStr(cPersids,2)+") order by lastname,city,address",oConn}
	oPers:Execute()
	do while !oPers:EOF 
		CurPersid:=oPers:persid
		aAddress	:=	MarkUpAddress(oPers,,36)
		* remove trailing blank address lines:
		ADel(aAddress,7)
		FOR i	= 1 to 6
			IF	Empty(aAddress[1])
				ADel(aAddress,1)
			ELSE
				exit
			ENDIF
		NEXT
		//	add email address:
		IF	!Empty(oPers:EMAIL)
			FOR i=1 to 6
				IF	Empty(aAddress[i])
					aAddress[i]:=AllTrim(oPers:EMAIL)
					exit
				ENDIF
			NEXT
		ENDIF
		AAdd(aMbrAddresses,{CurPersid,aAddress})
		gvr:=0
// 		lFirst:=true
		do while true
			gvr:=AScan(aGiversdata,{|x|x[PRSID]==CurPersid},gvr+1)
			if gvr==0
				exit
			endif
			aGiversdata[gvr,6] := oPers:Recno     // sort key 
		enddo
		oPers:Skip()
	enddo
	// check if all giverdate are assigned to a person:
	if (gvr:=ascan(aGiversdata,{|x|empty(x[6])}))>0
		if (TextBox{,self:oLan:WGet("GiftReport"),self:oLan:WGet("Giver of gift")+" :"+AllTrim(Str(aGiversdata[gvr,1]))+" "+AllTrim(aGiversdata[gvr,3])+;
				" in "+self:oLan:WGet(MonthEn[aGiversdata[gvr,5]],,"!")+' '+self:oLan:WGet('to')+': "'+description+'" '+self:oLan:WGet('not found'),BUTTONOKAYCANCEL}):Show();
				==BOXREPLYCANCEL
			RETURN
		ENDIF	
	ENDIF				

	*	Print givers with their gifts:
	*	Sort in ascending order
	ASort(aGiversdata,,,{|x,y| x[6]<=y[6]})  

	RowCnt := 0
	aMsg := {}
	NoteNumber:=0
	if !Empty(addHeading)
		aHeading:={addHeading}
	else
		aHeading:={}
	endif
	AAdd(aHeading,StrTran(StrTran(self:cHeading1,' %description%',Description),'%hbn%',me_hbn))
	AAdd(aHeading,' ')
	AAdd(aHeading,self:cHeading2)
	AAdd(aHeading,separator)

	IF !(Admin="WO".or.Admin="HO")
		AsmntRowCnt:=1
	ENDIF
	FOR asmntRow= 1 to AsmntRowCnt
		AssTot:=0
		for i:=1 to 12
			AssTot:=AssTot + aAssmntAmount[asmntRow,i]
		next
		IF AssTot#0
			hlptxt:=''
			FOR i=1 to 12
				hlptxt:=hlptxt+Str(Round(aAssmntAmount[asmntRow,i],nDecFrac1),8,nDecFrac1)
			NEXT
			oReport:PrintLine(@nRow,@nPage,Pad(aAsmntDescr[asmntRow],40)+hlptxt,aHeading)
		ENDIF
	NEXT
	oReport:PrintLine(@nRow,@nPage,separator,aHeading)

	FOR gvr=1 to Len(aGiversdata)
		++RowCnt
		for i:=1 to 12
			aGiversGC[i]:=Space(8)
		next
		for i:=1 to 12
			GiftAmnt[i]:=0.00
		next
		for i:=1 to 12
			NoteRef[i]:=Space(8)
		next
		aRow:={}
		AddrPnt++
		AAdd(aRow,Pad(Space(4)+ if(Empty(aMbrAddresses[AddrPnt,2,1]),"",aMbrAddresses[AddrPnt,2,1]),40))
		AAdd(aRow,Pad(Str(RowCnt,3) + ' ' + if(Empty(aMbrAddresses[AddrPnt,2,2]),"",aMbrAddresses[AddrPnt,2,2]),40))
		AAdd(aRow,Pad(Space(4) + if(Empty(aMbrAddresses[AddrPnt,2,3]),"",aMbrAddresses[AddrPnt,2,3]),40))
		AddressRow:=3
		IF !Empty(aMbrAddresses[AddrPnt,2,4])
			AAdd(aRow,Pad(Space(4) + aMbrAddresses[AddrPnt,2,4],40))
			++AddressRow
			IF !Empty(aMbrAddresses[AddrPnt,2,5])
				AAdd(aRow,Pad(Space(4) + aMbrAddresses[AddrPnt,2,5],40))
				++AddressRow
				IF !Empty(aMbrAddresses[AddrPnt,2,6])
					AAdd(aRow,Pad(Space(4) + aMbrAddresses[AddrPnt,2,6],40))
					++AddressRow
				ENDIF
			ENDIF
		ENDIF
		PersidSav := aGiversdata[gvr,PRSID]
		gvrCur:=gvr
		FOR gvr=gvrcur to Len(aGiversdata)
			iMonth:= aGiversdata[gvr,MND]
			IF Empty(aGiversGC[iMonth])
				aGiversGC[iMonth]:=Space(6)+aGiversdata[gvr,GC]
			ELSE
				GClen:=Len(AllTrim(aGiversGC[iMonth]))
				IF GClen<= 5 .and. AtC(aGiversdata[gvr,GC],aGiversGC[iMonth])=0
					aGiversGC[iMonth]:=if(GClen>0,Space(5-GClen),"")+;
						AllTrim(aGiversGC[iMonth])+"/"+aGiversdata[gvr,GC]
				ENDIF
			ENDIF
			GiftAmnt[iMonth]:=GiftAmnt[iMonth]+aGiversdata[gvr,amnt]
			IF iMonth=ReportMonth.or.Footnotes="All"
				*          	processing Footnotes:
				IF .not.Empty(aGiversdata[gvr,DESCR]).and.Upper(aGiversdata[gvr,DESCR]) # GiftDesc;
						.and. aGiversdata[gvr,AMNT] # 0.and.aGiversdata[gvr,DESCR] # NonEarDesc
					IF Empty(NoteRef[iMonth])
						++NoteNumber
						NoteRef[iMonth]:=Pad("    *"+AllTrim(Str(NoteNumber,3)),8)
						AAdd(aMsg,Pad("*"+AllTrim(Str(NoteNumber,4)),5)+AllTrim(aGiversdata[gvr,DESCR]))
					ELSE
						aMsg[NoteNumber]:=aMsg[NoteNumber]+'/'+Trim(aGiversdata[gvr,DESCR])
					ENDIF
				ENDIF
			ENDIF
			IF gvr<Len(aGiversdata)
				IF !PersidSav==aGiversdata[gvr+1,PRSID]
					exit
				ENDIF
			ENDIF
		NEXT
		oReport:PrintLine(@nRow,@nPage,;
			aRow[1] + aGiversGC[1]+aGiversGC[2]+aGiversGC[3]+aGiversGC[4]+aGiversGC[5]+;
			aGiversGC[6]+aGiversGC[7]+aGiversGC[8]+aGiversGC[9]+aGiversGC[10]+;
			aGiversGC[11]+aGiversGC[12],aHeading,AddressRow)
		FOR mndnum=1 to 12
			IF GiftAmnt[mndnum]#0
				aRow[2]:=aRow[2]+Str(Round(GiftAmnt[mndnum],nDecFrac),8,nDecFrac)
			ELSE
				aRow[2]:=aRow[2]+Space(8)
			ENDIF
		NEXT
		oReport:PrintLine(@nRow,@nPage,aRow[2],aHeading)
		oReport:PrintLine(@nRow,@nPage,aRow[3] + NoteRef[1]+NoteRef[2]+NoteRef[3];
			+NoteRef[4]+NoteRef[5]+NoteRef[6]+NoteRef[7]+;
			NoteRef[8]+NoteRef[9]+NoteRef[10]+;
			NoteRef[11]+NoteRef[12],aHeading)
		FOR i=4 to AddressRow
			oReport:PrintLine(@nRow,@nPage,aRow[i],aHeading)
		NEXT
		oReport:PrintLine(@nRow,@nPage,separator,aHeading)
	NEXT

	ASize(aHeading,2)
	*	Footnotes for special messages:
	IF NoteNumber > 0
		RowSav:=nRow
		oReport:PrintLine(@nRow,@nPage,,aHeading,if(NoteNumber>10,12,NoteNumber+2))
		IF nRow=RowSav
			oReport:PrintLine(@nRow,@nPage,' ',aHeading)
			oReport:PrintLine(@nRow,@nPage,' ',aHeading)
		ENDIF
		oReport:PrintLine(@nRow,@nPage,;
			self:cHeading3,aHeading)
		FOR i = 1 to NoteNumber
			oReport:PrintLine(@nRow,@nPage,aMsg[i],aHeading)
		NEXT
	ENDIF
	RowSav:=nRow
	oReport:PrintLine(@nRow,@nPage,,aHeading,7)
	IF nRow=RowSav
		oReport:PrintLine(@nRow,@nPage,' ',aHeading)
		oReport:PrintLine(@nRow,@nPage,' ',aHeading)
	ENDIF
	oReport:PrintLine(@nRow,@nPage,;
		self:cHeading4 +":",aHeading)
	oReport:PrintLine(@nRow,@nPage,"AG: Assessable Gift",aHeading)
	oReport:PrintLine(@nRow,@nPage,"PF: Personal Fund",aHeading)
	oReport:PrintLine(@nRow,@nPage,"CH: Charge",aHeading)
	oReport:PrintLine(@nRow,@nPage,;
		"OT: "+self:cHeading5,aHeading)
	oReport:PrintLine(@nRow,@nPage,"MG: Member Gift",aHeading)
	RETURN
method Init() class GiftsReport 
	self:oLan:=Language{}
	self:DecFrac:=SQLSelect{"select decmgift from sysparms",oConn}:FIELDGET(1)

	return self
method InitializeTexts(ReportYear as int,ReportMonth as int) as void pascal class GiftsReport  
	local mtxt,cPeriodTxt as string
	local i as int
	if !self:CurLanguage== Alg_taal
		self:CurLanguage := Alg_taal
		// different language? Tranlate texts again
		self:aAsmntDescr:={self:oLan:Get("Total Gifts/Own Funds",28,"!"),self:oLan:Get("Assessable Gifts",36,"!"),;
			self:oLan:Get("Personal Funds",36,"!"),self:oLan:Get("Member Gifts",36,"!")}
		self:GiftDesc:=self:oLan:Get("gift",,"@!")
		self:NonEarDesc:=self:oLan:Get("Allotted non-designated gift",,"@!")
		mtxt:=''
		FOR i=1 to 12
			mtxt:=mtxt+' '+PadL(self:oLan:Get(MonthEn[i],,"!"),7)
		NEXT
		cPeriodTxt:=Str(ReportYear,4)+' '+iif(ReportMonth=1,'',self:oLan:Get('up incl'))+' '+self:oLan:Get(MonthEn[ReportMonth],,"!")
		self:cHeading1:=self:oLan:Get('Year',,"!")+' '+cPeriodTxt+Space(15)+self:oLan:Get('GIFTREPORT',,"@!")+': %description%'+;
			'   '+self:Country+' HOUSECD: %hbn%'
		self:cHeading2:=Pad(self:oLan:Get('name',,"!")+' '+self:oLan:Get('and')+' '+self:oLan:Get('address')+' '+;
			self:oLan:Get('giver'),40)+mtxt
		self:cHeading3:=self:oLan:Get('footnotes',,"@!")
		self:cHeading4:=self:oLan:Get('Explanation',,"!")+' '+self:oLan:Get('of')+' '+self:oLan:Get('codes')
		self:cHeading5:=self:oLan:Get("non-designated",,"!")+' '+self:oLan:Get('gift')
	endif

DEFINE GT:=2
STATIC DEFINE IESREPORT_AFSLDAG := 100 
STATIC DEFINE IESREPORT_AFSLDAGTEXT := 104 
STATIC DEFINE IESREPORT_BALANCETEXT := 103 
STATIC DEFINE IESREPORT_CANCELBUTTON := 102 
STATIC DEFINE IESREPORT_OKBUTTON := 101 
CLASS ListboxGiftReport INHERIT ListBoxExtra 
METHOD GetAccnts(dummy:=nil as string) as array CLASS ListboxGiftReport
	// get accounts for subset of listbox
	LOCAL aAcc:={} AS ARRAY
	LOCAL cExchAcc, cStart, cEnd AS STRING
	LOCAL oParent:=SELF:Owner AS GiftReport
	LOCAL aMemHome:=oParent:aMemHome AS ARRAY
	LOCAL aMemNonHome:=oParent:aMemNonHome AS ARRAY
	LOCAL aProjects:=oParent:aProjects AS ARRAY
	LOCAL lHome:=oParent:HomeBox,lNonHome:=oParent:NonHomeBox,lProjects:=oParent:ProjectsBox AS LOGIC
	* Enforce correct sequence:
	cStart:=LTrimZero(oParent:FromAccount)
	cEnd:=LTrimZero(oParent:ToAccount)
	IF Empty(cStart).and.Empty(cEnd)
		RETURN {}
	ENDIF
	IF !Empty(cEnd).and. cStart>cEnd
		cExchAcc := cEnd
		cEnd:=cStart
		cStart:=cExchAcc
	ENDIF
	IF lHome
		AEval(aMemHome,{|x| FilterAcc(aAcc,x,cStart,cEnd)})
	ENDIF
	IF lNonHome
		AEval(aMemNonHome,{|x| FilterAcc(aAcc,x,cStart,cEnd)})
	ENDIF
	IF lProjects
		AEval(aProjects,{|x| FilterAcc(aAcc,x,cStart,cEnd)})
	ENDIF
	RETURN aAcc 
STATIC DEFINE MND:=5
CLASS MonthClose INHERIT DataDialogMine 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCMindate AS DATETIMEPICKER
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
RESOURCE MonthClose DIALOGEX  4, 3, 288, 69
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Journaling is allowed from:", MONTHCLOSE_FIXEDTEXT1, "Static", WS_CHILD, 4, 25, 88, 13
	CONTROL	"zaterdag 15 januari 2011", MONTHCLOSE_MINDATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 96, 25, 118, 14
	CONTROL	"OK", MONTHCLOSE_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 224, 18, 54, 12
	CONTROL	"Cancel", MONTHCLOSE_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 224, 36, 53, 12
END

METHOD CancelButton( ) CLASS MonthClose
super:Cancel() 
self:EndWindow() 

RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS MonthClose 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"MonthClose",_GetInst()},iCtlID)

oDCFixedText1 := FixedText{SELF,ResourceID{MONTHCLOSE_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Journaling is allowed from:",NULL_STRING,NULL_STRING}

oDCMindate := DateTimePicker{SELF,ResourceID{MONTHCLOSE_MINDATE,_GetInst()}}
oDCMindate:FieldSpec := Subscription_P04{}
oDCMindate:HyperLabel := HyperLabel{#Mindate,NULL_STRING,"Up to this date it is not allowed to record transactions",NULL_STRING}
oDCMindate:UseHLforToolTip := True
oDCMindate:TooltipText := "Up to this date it is not allowed to record transactions"

oCCOKButton := PushButton{SELF,ResourceID{MONTHCLOSE_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{MONTHCLOSE_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

SELF:Caption := "Restrict journaling"
SELF:HyperLabel := HyperLabel{#MonthClose,"Restrict journaling",NULL_STRING,NULL_STRING}
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS MonthClose 
self:Server:Mindate:=self:oDCMindate:SelectedDate
self:Commit()
Mindate:=self:oDCMindate:SelectedDate
self:EndWindow()
RETURN NIL
method PostInit(oWindow,iCtlID,oServer,uExtra) class MonthClose
	//Put your PostInit additions here 
	self:oDCMindate:DateRange:=DateRange{LstyearClosed,Today()+31}       // it is possible to change date backwards to begin of current year
	
   self:oDCMindate:SelectedDate:=Mindate
	return NIL
STATIC DEFINE MONTHCLOSE_CANCELBUTTON := 103 
STATIC DEFINE MONTHCLOSE_FIXEDTEXT1 := 100 
STATIC DEFINE MONTHCLOSE_MINDATE := 101 
STATIC DEFINE MONTHCLOSE_OKBUTTON := 102 
DEFINE MT:=3
STATIC DEFINE PMISSEND_AFSLDAG := 104 
STATIC DEFINE PMISSEND_AFSLDAGTEXT := 103 
STATIC DEFINE PMISSEND_BALANCETEXT := 102 
STATIC DEFINE PMISSEND_CANCELBUTTON := 101 
STATIC DEFINE PMISSEND_OKBUTTON := 100 
STATIC DEFINE PRSID:=2
CLASS ReImbursement INHERIT DataWindowExtra 

	PROTECT oDCBalanceText AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  protect oEmp as SQLSelect 
  protect Begindate,CloseDate as date
RESOURCE ReImbursement DIALOGEX  4, 3, 300, 64
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", REIMBURSEMENT_BALANCETEXT, "Static", WS_CHILD, 12, 18, 216, 29
	CONTROL	"OK", REIMBURSEMENT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 240, 14, 53, 13
	CONTROL	"Cancel", REIMBURSEMENT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 240, 32, 53, 12
END

METHOD CancelButton( ) CLASS ReImbursement 
	self:ENDWindow()
	super:Cancel()
RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS ReImbursement 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"ReImbursement",_GetInst()},iCtlID)

oDCBalanceText := FixedText{SELF,ResourceID{REIMBURSEMENT_BALANCETEXT,_GetInst()}}
oDCBalanceText:HyperLabel := HyperLabel{#BalanceText,NULL_STRING,NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{REIMBURSEMENT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{REIMBURSEMENT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

SELF:Caption := "Request for reimbursement"
SELF:HyperLabel := HyperLabel{#ReImbursement,"Request for reimbursement",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS ReImbursement 
	local oTrans as SQLSelect 
	local cFileName,cRef, cTask:=olan:WGet("Sending reimbursement request") as string 
	LOCAL cDelim:=Listseparator as STRING
	LOCAL ToFileFS as FileSpec
	LOCAL ptrHandle,ptrHandleEml
	LOCAL oReport as PrintDialog
	LOCAL nRow, nPage, i, nCurRec,nMem, nWidth:=101 as int, cDesc, cTab:=Space(1) as STRING
	local aHeaders as array 
	local fTransAmnt, fCurAmnt as float 
	local nMem as int
	LOCAL oMapi as MAPISession
	LOCAL oRecip,oRecip2 as MAPIRecip
	LOCAL cExportMail as STRING
	LOCAL lSent as LOGIC
	LOCAL oSys,oAcc as SQLSelect
	local fTotReimb as float
	LOCAL oEMLFrm as eMailFormat
	LOCAL  ind_openpost,ind_gift,ind_naw,ind_herh as LOGIC 
	local brieftxt as string
	LOCAL oSelpers as Selpers
	local oPers as SQLSelect
	
// 	oTrans:SetOrder("TRANSNR")
// 	oAcc:=Account{}
// 	if !Empty(oAcc:Filter).and.!Empty(cAccAlwd) 
// 		oAcc:Filter+=".or.EvAlw(accid)"
// 	endif
// 	oAcc:setOrder("accid") 
// 	oTrans:SetSelectiveRelation(oAcc,"accid")
// 	if !Empty( cAccAlwd)
// 		oTrans:setFilter(,"Userid='"+LOGON_EMP_ID+"'.and.DToS(Dat)>='"+DToS(self:Begindate)+"'.and.Dtos(dat)<='"+DToS(self:CloseDate)+"'")
// 	ENDIF
// 	oTrans:gotop()
// 	if oTrans:EoF
// 		ErrorBox{self,"Nothing to reimburse"}:Show()
// 		oTrans:Close()
// 		oAcc:Close()
// 		self:EndWindow()
// 		self:Close()
// 		return false
// 	endif
	
	cFileName := "reimbursement request "+LOGON_EMP_ID
	ToFileFS:=AskFileName(self,cFileName,cTask,"*.csv","comma separated file")
	if Empty(ToFileFS)
		return false
	endif
	cFileName:=ToFileFS:FullPath
	ptrHandle:=MakeFile(self,cFileName,cTask)
	IF !ptrHandle = F_ERROR .and. !ptrHandle==nil
		* Write heading TO file:
		FWriteLine(ptrHandle,'"TRANSDATE"'+cDelim+'"DOCID"'+cDelim+'"TRANSACTNR"'+cDelim+'"ACCOUNTNR"'+cDelim+'"ACCNAME"'+cDelim+'"DESCRIPTN"'+cDelim+'"DEBITAMNT"'+cDelim+'"CREDITAMNT"'+cDelim+'"REFERENCE"')
	else
		return false
	ENDIF
	oReport := PrintDialog{self,cTask+"-"+DToC(self:CloseDate),,nWidth,DMORIENT_LANDSCAPE}
	oReport:Show()
	IF .not.oReport:lPrintOk 
		FClose(ptrHandle)
		RETURN FALSE
	ENDIF
	aHeaders:={cTask+Space(3)+DToC(self:CloseDate),;
		olan:RGet("Account",30)+cTab+olan:RGet("Date",10)+cTab+olan:RGet("Reference",15)+cTab+olan:RGet("Description",30)+cTab+PadL(olan:RGet("Amount")+"-EUR",12),;
		Replicate('_',nWidth)}

	do while !oTrans:EoF
		cRef:=AllTrim(oTrans:REFERENCE)
		if oTrans:accid== sToPP
			cRef:=AllTrim(oTrans:PPDEST+" "+AllTrim(oTrans:REFERENCE))
		endif
		if Empty(cRef)
			cRef:=AllTrim(oTrans:DOCID)
		endif 
// 		if oAcc:REIMB
// 			fTotReimb:=Round(fTotReimb+oTrans:CRE - oTrans:DEB,2)
// 		endif

		FWriteLine(ptrHandle,;
			'"'+DToS(oTrans:dat)+'"'+cDelim+'"'+oTrans:docid+'"'+cDelim+'"'+oTrans:TransId+'"'+cDelim+'"'+SubStr(oAcc:accnumber,1,11)+'"'+cDelim+'"'+;
			AllTrim(oAcc:description)+'"'+cDelim+'"'+AllTrim(oTrans:description)+'"'+cDelim+'"'+Str(oTrans:DEB,10,DecAantal)+'"'+cDelim+'"'+Str(oTrans:CRE,10,DecAantal);
			+'"'+cDelim+'"'+cRef+'"')

		oReport:PrintLine(@nRow,@nPage,;
			Pad(AllTrim(oAcc:accnumber)+Space(1)+AllTrim(oAcc:description),30)+cTab+DToC(oTrans:DAT)+cTab+Pad(cRef,15)+cTab+;
			MemoLine(oTrans:description,30,1)+cTab+Str(oTrans:cre - oTrans:deb,12,2),aHeaders)
		nMem:=2
		DO WHILE !Empty(cDesc:=MemoLine(oTrans:description,30,nMem))
			oReport:PrintLine(@nRow,@nPage,Space(30)+cTab+Space(10)+cTab+Space(15)+cTab+cDesc,aHeaders)
			nMem++
		ENDDO
		
		oTrans:Skip()
	enddo 
	oReport:PrintLine(@nRow,@nPage,Space(89)+Replicate("_",12),aHeaders,2)
	oReport:PrintLine(@nRow,@nPage,Pad("Total to be reimbursed",89)+Str(fTotReimb,12,2),aHeaders,2)
	FWriteLine(ptrHandle,Replicate('""'+cDelim,5)+'"Total to be reimbursed"'+cDelim+'""'+cDelim+'"'+Str(fTotReimb,10,DecAantal)+'"'+cDelim+'""')
	
	FClose(ptrHandle)
	oReport:prstart()
	oReport:prstop()
	
	if ((TextBox{self,cTask,;
			"Are printed transactions OK and can they be sent by email for reimbursement?",;
			BOXICONQUESTIONMARK + BUTTONYESNO}):Show()) == BOXREPLYYES
// 		IF oPers == null_object
// 			oPers := Person{}
// 			IF !oPers:Used
// 				self:EndWindow()
// 			ENDIF
// 		ENDIF
// 		oPers:SetOrder("ASSRE")
// 		if	!File(CurPath+"\Reimb_"+LOGON_EMP_ID+".Eml")
			ptrHandleEml:=FCreate(CurPath+"\Reimb_"+LOGON_EMP_ID+".Eml")
			FWriteLine(ptrHandleEml,'Dear Sally,')
			FWriteLine(ptrHandleEml,'I send you attached my financial report of '+maand[Month(self:CloseDate)]+' '+Str(Year(self:CloseDate),4,0)+' '+CRLF+'and would be grateful if you would approve the reimbursement of '+AllTrim(Str(fTotReimb,10,DecAantal))+' '+sCurr+'.')
			FWriteLine(ptrHandleEml,oPers:GetFullName(self:oEmp:mCLN,1))
			FClose(ptrHandleEml)
// 		endif				 
		SetRTRegString( "WYC\Runtime", "eMlBrief", "Reimb_"+LOGON_EMP_ID)
		(oEMLFrm := eMailFormat{oParent}):Show()
		IF oEMLFrm:lCancel
			RETURN FALSE
		ENDIF 

		IF !Empty(oEMLFrm:Template)
			brieftxt:=oEMLFrm:Template
		ELSE
			brieftxt:=""
		ENDIF

// 		oSys:=Sysparms{}
// 		cExportMail:=AllTrim(oSys:EXPMAILACC)
// 		cExportMail:=StrTran(cExportMail,";"+AllTrim(oSys:OWNMAILACC))
// 		cExportMail:=StrTran(cExportMail,AllTrim(oSys:OWNMAILACC)) 
		* Send file by email:
		IF IsMAPIAvailable()
			* Resolve IESname
			oMapi := MAPISession{}	
			IF oMapi:Open( "" , "" )
				oRecip := oMapi:ResolveMailName( "Headquarters",@cExportMail,"Headquarters financial approval")
				IF oRecip != null_object
					oMapi:SendDocument( FileSpec{cFileName} ,oRecip,oRecip2,"Financial Report "+maand[Month(self:CloseDate)]+' '+Str(Year(self:CloseDate),4,0),brieftxt)
					(InfoBox{self:OWNER,cTask,;
						"Placed one mail message in your outbox with attached the file: "+cFileName}):Show()
					lSent:=true
				ENDIF
			ENDIF
			oMapi:Close()		
			IF !lSent
				(InfoBox{self:OWNER,cTask,"Generated one file:"+cFilename+" (mail to approval account "+;
					AllTrim(oSys:EXPMAILACC)+")"}):Show()
			ELSE
				// 			ToFileFS:DELETE()
			ENDIF
// 			IF !cExportMail==oSys:EXPMAILACC
// 				oSys:RecLock()
// 				oSys:EXPMAILACC:=cExportMail
// 				oSys:UnLock()
// 			ENDIF
// 			oSys:commit()
// 			oSys:UnLock()
// 			self:oEmp:RecLock()
// 			self:oEmp:LSTREIMB:=self:CloseDate
// 			self:oEmp:commit()
		ENDIF
	else
		if !ToFileFS:DELETE()
			FErase(cFilename)
		endif
	endif
	self:EndWindow()
	self:Close()
	RETURN nil
method PostInit(oWindow,iCtlID,oServer,uExtra) class ReImbursement
	//Put your PostInit additions here 
	local oEmpl:=self:oEmp as SQLSelect
	self:SetTexts()
	self:oEmp:=SQLSelect{"select lstreimb from employee where empid="+MYEMPID,oConn} 
	oEmpl:=self:oEmp
	if oEmpl:RecCount>0
		self:Begindate:=iif(Empty(oEmpl:LSTREIMB),Mindate,oEmpl:LSTREIMB+1) 
		self:CloseDate:=SToD(SubStr(DToS(Today()),1,6)+"01") - 1 
		if !self:CloseDate>self:Begindate
			self:CloseDate:=EndOfMonth(Today())
			if	self:CloseDate	<= oEmpl:LSTREIMB
				ErrorBox{self,'Month '+maand[Month(oEmpl:LSTREIMB)]+' already reimbursed!'}:Show()
				self:EndWindow()
				self:Close()
				return
			endif			
			if Day(Today())> 23
				if (TextBox{self,"Sending reimbursement request","Do you really already want to request for reimbursement for "+maand[Month(Today())]+"?", BUTTONYESNO+BOXICONQUESTIONMARK}):Show()= BOXREPLYNO
					self:EndWindow()
					self:Close()
					return
				endif
			else
				ErrorBox{self,self:oLan:WGet("You are too early to send the reimbursement request for")+" "+maand[Month(self:CloseDate)]+"!"}:Show()
				self:ENDWindow()
				self:Close()
				return
			endif
		endif
		self:oDCBalanceText:TextValue:=self:oLan:WGet("Sending request for reimbursement for expenses from")+CRLF+DToC(self:Begindate)+space(2)+self:oLan:WGet("up till")+space(2)+DToC(self:CloseDate)
	endif
	return NIL
STATIC DEFINE REIMBURSEMENT_BALANCETEXT := 100 
STATIC DEFINE REIMBURSEMENT_CANCELBUTTON := 102 
STATIC DEFINE REIMBURSEMENT_OKBUTTON := 101 
class TaxReport inherit DataWindowMine 

	protect oDCYearTax as COMBOBOX
	protect oDCFixedText1 as FIXEDTEXT
	protect oCCOKButton as PUSHBUTTON
	protect oCCCancelButton as PUSHBUTTON
	protect oDCFixedText2 as FIXEDTEXT
	protect oDCThreshold as SINGLELINEEDIT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	instance YearTax 
	instance Threshold 
  PROTECT TaxID as STRING
RESOURCE TaxReport DIALOGEX  8, 7, 268, 103
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TAXREPORT_YEARTAX, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 78, 9, 104, 83
	CONTROL	"Tax year", TAXREPORT_FIXEDTEXT1, "Static", WS_CHILD, 12, 9, 54, 12
	CONTROL	"OK", TAXREPORT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 202, 8, 53, 12
	CONTROL	"Cancel", TAXREPORT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 201, 28, 53, 12
	CONTROL	"Threshold amount:", TAXREPORT_FIXEDTEXT2, "Static", WS_CHILD, 12, 38, 66, 13
	CONTROL	"", TAXREPORT_THRESHOLD, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 35, 104, 12, WS_EX_CLIENTEDGE
END

METHOD CancelButton( ) CLASS TaxReport
	SELF:endWindow()
	RETURN
METHOD FillTaxYears CLASS TaxReport
	LOCAL aTaxYr:={} AS ARRAY
	LOCAL cYear,i AS INT
	cYear:=Year(Today())
	FOR i:=1 TO 5
		AAdd(aTaxYr,Str(cYear,-1))
		cYear--
	NEXT
	RETURN aTaxYr
method Init(oWindow,iCtlID,oServer,uExtra) class TaxReport 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

super:Init(oWindow,ResourceID{"TaxReport",_GetInst()},iCtlID)

oDCYearTax := combobox{self,ResourceID{TAXREPORT_YEARTAX,_GetInst()}}
oDCYearTax:FillUsing(Self:FillTaxYears( ))
oDCYearTax:HyperLabel := HyperLabel{#YearTax,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{self,ResourceID{TAXREPORT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Tax year",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{self,ResourceID{TAXREPORT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{self,ResourceID{TAXREPORT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{self,ResourceID{TAXREPORT_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Threshold amount:",NULL_STRING,NULL_STRING}

oDCThreshold := SingleLineEdit{self,ResourceID{TAXREPORT_THRESHOLD,_GetInst()}}
oDCThreshold:HyperLabel := HyperLabel{#Threshold,NULL_STRING,"Minimum amount per year per person to be reported to the Tax autorities",NULL_STRING}
oDCThreshold:UseHLforToolTip := True
oDCThreshold:Picture := "999999"

self:Caption := "Tax report of Norwegian givers"
self:HyperLabel := HyperLabel{#TaxReport,"Tax report of Norwegian givers",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	self:Use(oServer)
endif

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS TaxReport
LOCAL tottax, nLines as FLOAT
LOCAL Heading as ARRAY, ad_banmsg as STRING
LOCAL TaxYear as int, TaxAmount as FLOAT
LOCAL cType,cSoort, cFileName, cFilter as STRING
LOCAL oPers as SQLselect,	 oTrans as SQLselect, oSys as SQLselect
LOCAL cFileName as STRING
LOCAL lSuc as LOGIC
LOCAL ToFileFS as Filespec
LOCAL oXMLDoc as XMLDocument
LOCAL PersonNbr as STRING
LOCAL ptrHandle as ptr
LOCAL cHeader as STRING
LOCAL nThreshold as FLOAT
LOCAL oReport as PrintDialog, headinglines as ARRAY , nRow, nPage as int 
LOCAL sqlStr as STRING

* Check values:
* Check input data:
IF !ValidateControls( self, self:AControls )
	RETURN
END
TaxYear:=Val(self:YearTax)
nThreshold:=self:Threshold
cFileName := "GRUNNLAG"+Str(TaxYear,-1)
oReport := PrintDialog{self,"Producing of Tax Report",,70}
oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
headinglines:={"Overview of generated Tax reduction report"}
oLan:=Language{}
headinglines:={oLan:Get("Overview of Tax reduction report")+" "+Str(TaxYear,4),oLan:Get("Name",41)+oLan:Get("Amount",12,,"R")+" "+oLan:Get("Person Number",13),Replicate('-',67)}
ToFileFS:=AskFileName(self,cFileName,"Save Taxreport to file","*.txt","TEXT file")

self:STATUSMESSAGE("Producing report, please wait...")
self:Pointer := Pointer{POINTERHOURGLASS}


// Get data header line:

oSys:=SQLSelect{"select idorg, idcontact from sysparms",oConn}

IF oSys:RecCount<1
	(ErrorBox{self,self:oLan:WGet("Database does not contain sysparms")}):Show()
	RETURN
ENDIF
IF Empty(oSys:IDORG)
	(ErrorBox{self,"No own organisation specified in System Parameters"}):Show()
	RETURN
ENDIF
IF Empty(oSys:IDCONTACT)
	(ErrorBox{self,"No financial contact person specified in System Parameters"}):Show()
	RETURN
ENDIF

oPers:=SQLSelect{"select lastname,address,postalcode,city,telbusiness from person where persid=" + Str(oSys:IDORG,-1), oConn}
if oPers:RecCount<1
	(ErrorBox{self,"No own organisation specified in System Parameters"}):Show()
	RETURN
ENDIF
cHeader:="22100980334600"+PadR(oPers:lastname,30)+PadR(AllTrim(oPers:address)+" "+AllTrim(oPers:postalcode)+" "+oPers:city,60)+PadR(AllTrim(oPers:telbusiness),8)

oPers:=SQLSelect{"select firstname,lastname,telbusiness from person where persid=" + Str(oSys:IDCONTACT,-1), oConn} 
if oPers:RecCount<1
	(ErrorBox{self,"No financial contact person specified in System Parameters"}):Show()
	RETURN
ENDIF
cHeader+=PadR(AllTrim(oPers:firstname)+" "+AllTrim(oPers:lastname),30)+PadR(AllTrim(oPers:telbusiness),8)+Str(TaxYear+1,4,0)+DToS(Today()) + " 1"
oSys:Close()
oSys:=null_object


sqlStr:=UnionTrans("select sum(t.cre-t.deb) as taxamount,p.persid,p.propextr,p.lastname,p.firstname,p.prefix,p.address,p.attention,p.postalcode,p.city,p.country," ;
   + SQLFullName(0,"p") + " as fullname from person as p,transaction as t,account ";
   + "where p.persid=t.persid and INSTR(p.propextr,'</" + self:TaxID ;
	+ ">') and NOT INSTR(p.propextr,'<" + self:TaxID + "></" + self:TaxID + ">') and " ;
	+ "account.accid=t.accid and account.giftalwd=1 and " ; 
	+ "t.dat>='" + Str(TaxYear,-1) + "-01-01' and t.dat<='" + Str(TaxYear,-1) + "-12-31' group by p.persid having taxamount>=" + Str(nThreshold,-1))
	
oTrans:=SQLSelect{sqlStr,oConn}

if oTrans:RecCount<1
	RETURN
ENDIF

cFileName:=ToFileFS:FullPath
ptrHandle:=MakeFile(,@cFileName,"Exporting Report to text file")

//FWriteLine(ptrHandle,PadR("22100980334600Wycliffe                      Postboks 6625 St. Olavs plass 0129 OSLO                     22932780Kjell-Arne Haldorsen          229327822"+Str(TaxYear,4,0)+DToS(Today())+" 1",200))
FWriteLine(ptrHandle,PadR(cHeader,200))

* Stel kop samen:
do WHILE !oTrans:EOF
	oXMLDoc:=XMLDocument{oTrans:PROPEXTR}
	IF oXMLDoc:GetElement(TaxID)
		PersonNbr:=PadL(oXMLDoc:GetContentCurrentElement(),11,"0")
		if !IsModulus11(PersonNbr)
			(ErrorBox{self,"Personnumber "+PersonNbr+" of "+ oTrans:fullname +" is not correct"}):Show()
			exit
		endif
	ELSE
		loop
	ENDIF
	TaxAmount:=Round(oTrans:TaxAmount,0)
	// write line to file

	nLines++
	tottax:=Round(tottax+TaxAmount,0)
	FWriteLine(ptrHandle,"22500980334600"+PersonNbr+StrZero(TaxAmount,12,0)+"+"+Space(11)+PadR(AllTrim(oTrans:lastname)+" "+AllTrim(oTrans:firstname)+" "+oTrans:prefix,24)+" "+;
	PadR(AllTrim(oTrans:address)+" "+oTrans:attention,49)+" "+PadR(oTrans:postalcode,5)+PadR(AllTrim(oTrans:city)+" "+oTrans:country,71))
	oReport:PrintLine(@nRow,@nPage,;
	Pad(oTrans:fullname,40)+" "+Str(TaxAmount,12,2)+' '+Pad(PersonNbr,15),headinglines)
	oTrans:Skip()
ENDDO 

Tottax:=Round(tottax,decaantal)
FWriteLine(ptrHandle,PadR("22800980334600"+StrZero(nLines,7,0)+StrZero(tottax,15,0)+"+",200))
oReport:PrintLine(@nRow,@nPage,Replicate('-',67),headinglines,3)
oReport:PrintLine(@nRow,@nPage,Space(41)+Str(tottax,12,2),headinglines)
oReport:prstart()
oReport:prstop()
(TextBox{self,"Tax Report",Str(nLines,-1)+" lines written to "+ToFileFS:FullPath}):Show()

FClose(ptrHandle)
// restore default path
SetPath(CurPath)

self:Pointer := Pointer{POINTERARROW}
self:EndWindow()
RETURN

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TaxReport
	//Put your PostInit additions here
	// Check if field for tax id exists:
	// add extra properties:
LOCAL i AS INT, Name, ID AS STRING
	self:SetTexts()
self:oDCYearTax:CurrentItemNo:=2
SELF:Threshold:=500
FOR i:=1 TO Len(pers_propextra)
	Name:=pers_propextra[i,1]
	TaxID := "V"+Str(pers_propextra[i,2],-1)
	IF Name=="Person Number".and. pers_propextra[i,3]==TEXTBX
		RETURN NIL
	ENDIF
NEXT	
(ErrorBox{self,"Text field 'Person Number' not defined as extra property for person."}):Show()
self:EndWindow()
RETURN NIL
access Threshold() class TaxReport
return self:FieldGet(#Threshold)

assign Threshold(uValue) class TaxReport
self:FieldPut(#Threshold, uValue)
return Threshold := uValue

access YearTax() class TaxReport
return self:FieldGet(#YearTax)

assign YearTax(uValue) class TaxReport
self:FieldPut(#YearTax, uValue)
return YearTax := uValue

STATIC DEFINE TAXREPORT_CANCELBUTTON := 103 
STATIC DEFINE TAXREPORT_FIXEDTEXT1 := 101 
STATIC DEFINE TAXREPORT_FIXEDTEXT2 := 104 
STATIC DEFINE TAXREPORT_OKBUTTON := 102 
STATIC DEFINE TAXREPORT_THRESHOLD := 105 
STATIC DEFINE TAXREPORT_YEARTAX := 100 
class TrialBalance inherit DataWindowMine 

	protect oDCmDepartment as SINGLELINEEDIT
	protect oCCDepButton as PUSHBUTTON
	protect oDCYearTrial as COMBOBOX
	protect oDCMonthStart as SINGLELINEEDIT
	protect oDCMonthEnd as SINGLELINEEDIT
	protect oDClCondense as CHECKBOX
	protect oCCOKButton as PUSHBUTTON
	protect oCCCancelButton as PUSHBUTTON
	protect oDCFixedText1 as FIXEDTEXT
	protect oDCFixedText2 as FIXEDTEXT
	protect oDCFixedText3 as FIXEDTEXT
	protect oDCFixedText4 as FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	instance mDepartment 
	instance YearTrial 
	instance MonthStart 
	instance MonthEnd 
	instance lCondense 
  	PROTECT oAcc as SQLSelect
	PROTECT oMBal as SQLSelect
	PROTECT oReport AS PrintDialog
	PROTECT lPrint AS LOGIC
	PROTECT oDep as SQLSelect
	PROTECT WhoFrom AS STRING
	PROTECT	d_dep:={} AS ARRAY
	PROTECT cCurDep AS STRING
RESOURCE TrialBalance DIALOGEX  20, 18, 266, 153
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TRIALBALANCE_MDEPARTMENT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 22, 93, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TRIALBALANCE_DEPBUTTON, "Button", WS_CHILD, 163, 22, 15, 12
	CONTROL	"", TRIALBALANCE_YEARTRIAL, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 72, 44, 88, 72
	CONTROL	"", TRIALBALANCE_MONTHSTART, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 64, 53, 12, WS_EX_CLIENTEDGE
	CONTROL	"", TRIALBALANCE_MONTHEND, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 182, 64, 54, 12, WS_EX_CLIENTEDGE
	CONTROL	"Condense", TRIALBALANCE_LCONDENSE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 72, 83, 80, 11
	CONTROL	"OK", TRIALBALANCE_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 184, 96, 54, 12
	CONTROL	"Cancel", TRIALBALANCE_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 184, 116, 53, 12
	CONTROL	"Financial year", TRIALBALANCE_FIXEDTEXT1, "Static", WS_CHILD, 16, 44, 53, 12
	CONTROL	"From month:", TRIALBALANCE_FIXEDTEXT2, "Static", WS_CHILD, 16, 64, 53, 12
	CONTROL	"To month:", TRIALBALANCE_FIXEDTEXT3, "Static", WS_CHILD, 137, 64, 41, 12
	CONTROL	"Department:", TRIALBALANCE_FIXEDTEXT4, "Static", WS_CHILD, 16, 22, 43, 13
END

METHOD AddSubDep(ParentNum, nCurrentRec)  CLASS TrialBalance
* Find subdepartments and add to arrays with departments
	LOCAL nChildRec			AS INT
	LOCAL nCurNum			AS STRING
	//Default(@nCurrentRec,NULL_STRING)

	// reposition the customer server to the searched record
	IF !Empty(nCurrentRec)
		oDep:GoTo(nCurrentRec)
	ENDIF
	IF Empty(nCurrentRec).or.!oDep:ParentDep==ParentNum
		oDep:Seek(ParentNum)
	ELSE
		oDep:Skip()
	ENDIF
	IF oDep:EoF .or. !oDep:ParentDep==ParentNum
		RETURN 0
	ENDIF
	nCurrentRec:=oDep:RecNo
	nCurNum:= oDep:DepId
 	AAdd(d_dep,oDep:DepId)

	// add all child departments:
	DO WHILE TRUE
		nChildRec:=SELF:AddSubDep(nCurNum, nChildRec)
		IF Empty(nChildRec)
			EXIT
		ENDIF
	ENDDO
RETURN nCurrentRec
METHOD CancelButton( ) CLASS TrialBalance
	SELF:endWindow()
	RETURN
	
METHOD Close(oEvent) CLASS TrialBalance
	SUPER:Close(oEvent)
	//Put your changes here
IF !oAcc==NULL_OBJECT
	IF oAcc:Used
		oAcc:Close()
	ENDIF
	oAcc:=NULL_OBJECT
ENDIF
IF !oMBal==NULL_OBJECT
	IF oMBal:Used
		oMBal:Close()
	ENDIF
	oMBal:=NULL_OBJECT
ENDIF
IF !oLan==NULL_OBJECT
	IF oLan:Used
		oLan:Close()
	ENDIF
	oLan:=NULL_OBJECT
ENDIF
SELF:Destroy()
	
	RETURN

METHOD DepButton( ) CLASS TrialBalance
	LOCAL cCurValue AS STRING
	LOCAL nPntr AS INT

	cCurValue:=AllTrim(oDCmDepartment:TextValue)
	nPntr:=At(":",cCurValue)
	IF nPntr>1
		cCurValue:=SubStr(cCurValue,1,nPntr-1)
	ENDIF
	(DepartmentExplorer{SELF:Owner,"Department",WhoFrom,SELF,cCurValue}):show()
RETURN NIL

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS TrialBalance
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	LOCAL cCurValue AS USUAL
	LOCAL nPntr AS INT
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !Departments
		RETURN NIL
	ENDIF
	IF !lGotFocus
		IF oControl:NameSym==#mDepartment .and.!AllTrim(oControl:TextValue)==cCurDep
			cCurValue:=AllTrim(oControl:TextValue)
			cCurDep:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF SELF:oDep:FindDep(@cCurValue)
				SELF:RegDepartment(cCurValue,"")
			ELSE
				SELF:DepButton()
			ENDIF
		ENDIF
	ENDIF
	RETURN NIL

METHOD GetBalYears() CLASS TrialBalance
	// get array with balance years
	RETURN GetBalYears()
method Init(oWindow,iCtlID,oServer,uExtra) class TrialBalance 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

super:Init(oWindow,ResourceID{"TrialBalance",_GetInst()},iCtlID)

oDCmDepartment := SingleLineEdit{self,ResourceID{TRIALBALANCE_MDEPARTMENT,_GetInst()}}
oDCmDepartment:HyperLabel := HyperLabel{#mDepartment,NULL_STRING,"From Who is it: Department",NULL_STRING}
oDCmDepartment:TooltipText := "Enter number or name of required Top of department structure"

oCCDepButton := PushButton{self,ResourceID{TRIALBALANCE_DEPBUTTON,_GetInst()}}
oCCDepButton:HyperLabel := HyperLabel{#DepButton,"v","Browse in Departments",NULL_STRING}
oCCDepButton:TooltipText := "Browse in Departments"

oDCYearTrial := combobox{self,ResourceID{TRIALBALANCE_YEARTRIAL,_GetInst()}}
oDCYearTrial:FillUsing(Self:GetBalYears( ))
oDCYearTrial:HyperLabel := HyperLabel{#YearTrial,NULL_STRING,NULL_STRING,NULL_STRING}

oDCMonthStart := SingleLineEdit{self,ResourceID{TRIALBALANCE_MONTHSTART,_GetInst()}}
oDCMonthStart:HyperLabel := HyperLabel{#MonthStart,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMonthStart:FieldSpec := MONTHW{}

oDCMonthEnd := SingleLineEdit{self,ResourceID{TRIALBALANCE_MONTHEND,_GetInst()}}
oDCMonthEnd:HyperLabel := HyperLabel{#MonthEnd,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMonthEnd:FieldSpec := MONTHW{}

oDClCondense := CheckBox{self,ResourceID{TRIALBALANCE_LCONDENSE,_GetInst()}}
oDClCondense:HyperLabel := HyperLabel{#lCondense,"Condense",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{self,ResourceID{TRIALBALANCE_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{self,ResourceID{TRIALBALANCE_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{self,ResourceID{TRIALBALANCE_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Financial year",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{self,ResourceID{TRIALBALANCE_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"From month:",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{self,ResourceID{TRIALBALANCE_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"To month:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{self,ResourceID{TRIALBALANCE_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Department:",NULL_STRING,NULL_STRING}

self:Caption := "Trial Balance"
self:HyperLabel := HyperLabel{#TrialBalance,"Trial Balance",NULL_STRING,NULL_STRING}
self:EnableStatusBar(True)
self:PreventAutoLayout := True

if !IsNil(oServer)
	self:Use(oServer)
endif

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

access lCondense() class TrialBalance
return self:FieldGet(#lCondense)

assign lCondense(uValue) class TrialBalance
self:FieldPut(#lCondense, uValue)
return lCondense := uValue

METHOD ListBoxSelect(oControlEvent) CLASS TrialBalance
	LOCAL oControl AS Control
	LOCAL uValue AS USUAL
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControlEvent:NameSym==#YearTrial
		uValue:=oControlEvent:Control:Value
		oMbal:GetBalYear(Val(SubStr(uValue,1,4)),Val(SubStr(uValue,5,2)))
		MonthStart:=oMBal:MONTHSTART
		MonthEnd:=oMBal:MONTHEND
	ENDIF
	RETURN NIL

access mDepartment() class TrialBalance
return self:FieldGet(#mDepartment)

assign mDepartment(uValue) class TrialBalance
self:FieldPut(#mDepartment, uValue)
return mDepartment := uValue

access MonthEnd() class TrialBalance
return self:FieldGet(#MonthEnd)

assign MonthEnd(uValue) class TrialBalance
self:FieldPut(#MonthEnd, uValue)
return MonthEnd := uValue

access MonthStart() class TrialBalance
return self:FieldGet(#MonthStart)

assign MonthStart(uValue) class TrialBalance
self:FieldPut(#MonthStart, uValue)
return MonthStart := uValue

METHOD OKButton( ) CLASS TrialBalance
LOCAL perlengte,YEARSTART,YEAREND, TrialYear,BalMonth AS INT
LOCAL nRow, nPage as int
LOCAL CurSt, CurEnd,BalSt, BalEnd, TrialEnd AS INT
LOCAL omzetdeel, totdeb,totcre,vw_deb, vw_cre, m_bud, omzet, totBegin, totBeginCostProfit,PerDeb,PerCre AS FLOAT
LOCAL Heading:={} as ARRAY, ad_banmsg, omztxt as STRING
LOCAL PrvYearNotClosed AS LOGIC
LOCAL aDep:={} AS ARRAY
LOCAL cType,cSoort AS STRING
LOCAL nChildRec			AS INT
LOCAL Gran AS LOGIC
LOCAL cTab:=CHR(9) AS STRING


*LOCAL cFilter AS STRING

* Check values:
* Check input data:
IF !ValidateControls( SELF, SELF:AControls )
	RETURN
END

oMbal:GetBalYear(Val(SubStr(YearTrial,1,4)),Val(SubStr(YearTrial,5,2)))
YEARSTART:=oMBal:YEARSTART
TrialYear:=YEARSTART
BalMonth:= oMBal:MONTHSTART
YEAREND:=oMBal:YEAREND
IF oMBal:MONTHSTART>oMBal:MONTHEND // spanning two calendar years?
	IF MONTHSTART < oMBal:MONTHSTART
		* apparently in next year:
		++YEARSTART
	ENDIF
	IF MONTHEND > oMBal:MONTHEND
		* appenntly in previous year:
		--YEAREND
	ENDIF
ENDIF
CurSt:=YEARSTART*12+MONTHSTART
CurEnd:=YEAREND*12+MONTHEND
BalSt:=TrialYear*12+BalMonth
BalEnd:=oMBal:YEAREND*12+oMBal:MONTHEND
IF CurSt>CurEnd
   (ErrorBox{self:OWNER,self:oLan:WGet('Starting month must precede ending month')}):Show()
	RETURN
ENDIF
IF CurSt > BalEnd .or. CurSt < BalSt
   (ErrorBox{self:OWNER,self:oLan:WGet('Starting month out of range')}):Show()
	RETURN
ENDIF
IF CurEnd < BalSt .or. CurEnd > BalEnd
   (ErrorBox{self:OWNER,self:oLan:WGet('Ending month out of range')}):Show()
	RETURN
ENDIF
PrvYearNotClosed:=(BalSt>(Year(LstYearClosed)*12+Month(LstYearClosed)))

perlengte:= YEAREND*12+MonthEnd+1-(YEARSTART*12+MonthStart)
* Check and fill requested Departments:
d_dep:={}
IF Empty(WhoFrom)
	* Top department is WO Office:
	d_dep:={Space(11)}
ELSE
	IF !oDep:OrderInfo(DBOI_NAME)=="DEPID"
		oDep:SetOrder("DEPID")
	ENDIF
	oDep:Seek(WhoFrom)
	d_dep:={oDep:DEPID}
ENDIF
IF !oDep:OrderInfo(DBOI_NAME)=="SUBDEP"
	oDep:SetOrder("SUBDEP")
ENDIF

* Add all subdepartments down from WhoFrom:
DO WHILE TRUE
	nChildRec:=SELF:AddSubDep(WhoFrom, nChildRec)
	IF Empty(nChildRec)
		EXIT
	ENDIF
ENDDO

aDep:=d_Dep

// IF oAcc==NULL_OBJECT
// 	oAcc:=Account{}
// 	IF !oAcc:Used
// 		SELF:EndWindow()
// 	ENDIF
// ENDIF
// IF oAcc:OrderInfo(DBOI_NAME)#"ACCNTNBR"
// 	oAcc:SetOrder("AccNtNbr")
// ENDIF
*cFilter:="AScan(aDep,Department)>0"
*pFilter:=&("{||"+ cFilter+"}")
*lSuccess:=oAcc:SetFilter(,cFilter)

*lSuccess:=oAcc:SetFilter({|x| AScan(aDep,x:Department)>0})
oAcc:GoTop()
* aanmaken naam report bestand
*store 1 TO blad,r
IF lPrint
	oReport := PrintDialog{oParent,self:oLan:RGet('Trial Balance'),,121,,"xls"}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
ENDIF

* Stel kop samen:
oLan:=Language{}
IF !oLan:Used
	SELF:EndWindow()
ENDIF
IF Lower(oReport:Extension) #"xls"
	cTab:=Space(1)
	Heading:={oLan:Get('Trial Balance',,"!")}
ENDIF
SELF:Pointer := Pointer{POINTERHOURGLASS}
self:STATUSMESSAGE(self:oLan:WGet("Collecting data, moment please"))

AAdd(Heading,oLan:Get('Account',43,"!")+cTab+oLan:Get('Type',11,"!","C")+cTab+oLan:Get('BEGIN Balnc',11,"!","R")+cTab+oLan:Get('Debit',11,"!","R")+cTab+oLan:Get('Credit',11,"!","R")+;
cTab+oLan:Get('Balance',11,"!","R")+cTab+oLan:Get('Budget',10,"!","R") )
AAdd(Heading,oLan:Get('year',,"!")+cTab+oDCYearTrial:TextValue+;
'  '+maand[MonthStart]+' - '+maand[MonthEnd])
AAdd(Heading,' ')
vw_deb:=0
vw_cre:=0
DO WHILE !oAcc:EOF
	IF AScan(aDep,oAcc:Department)=0
		oAcc:Skip()
		LOOP
	ENDIF
   * Bepalen maandsaldo:
	oMBal:GetBalance(oAcc:accid,oAcc:balitemid,YEARSTART*100+MonthStart,YEAREND*100+MonthEnd)
	m_bud:=oAcc:GetPerBudget(YEARSTART,MONTHSTART,perlengte,@Gran)
	cSoort:= oMBal:cRubrSoort
  	cType:=aBalType[AScan(aBalType,{|x|x[1]=cSoort}),2]
	IF cSoort=="KO" .or. cSoort=="BA"
		PerDeb:=oMBAL:per_deb
		PerCre:=oMBal:per_cre
	ELSE
		// determine sum of transactions by comparing with previous month for balance accounts:
		PerDeb:=Round(oMBAL:per_deb - oMBAL:begin_deb,decaantal)
		PerCre:=Round(oMBal:per_cre - oMBAL:begin_cre,decaantal)
	ENDIF
   IF !self:lCondense .or. PerDeb # PerCre .or. oMbal:begin_deb#oMBAL:begin_cre

      && total percentage invullen van alles tot nu toe
      omzet:= PerDeb-PerCre
      IF omzet<> 0
         IF oMBal:cRubrSoort = "BA"
            omzet:=-omzet
         ENDIF
      ENDIF
      omztxt:='    0%'
      IF !m_bud == 0
         IF Abs((omzet/m_bud)*100) < 1000 .and.;
         (omzet/m_bud)*100 <> 0
            omzetdeel:=(omzet/m_bud)*100
            omzetdeel:=Round(omzetdeel,1)
            omztxt:=Str(omzetdeel,5,1)+'%'
         ENDIF
      ENDIF
  	  IF lPrint
      	oReport:PrintLine(@nRow,@nPage,Pad(oAcc:ACCNUMBER+" "+oAcc:description,43)+;
      	cTab+PadC(cType,11)+cTab+Str(oMBal:begin_deb-oMBal:begin_cre,11,decaantal) +;
      	cTab+Str(PerDeb,11,decaantal)+cTab+Str(PerCre,11,decaantal)+;
      	cTab+Str(oMBal:begin_deb-oMBal:begin_cre+PerDeb-PerCre,11,decaantal)+;
      	cTab+Str(Round(m_bud,DecAantal),10,decaantal)+cTab+omztxt,Heading,0)
      ENDIF
      totdeb:=Round(totdeb+PerDeb,decaantal)
      totcre:=Round(totcre+PerCre,decaantal)
/*      IF cSoort=="KO" .or. cSoort=="BA"
	  	totBeginCostProfit :=Round(totBeginCostProfit+oMBal:begin_deb-oMBal:begin_cre,decaantal)
	  ENDIF      */
      totBegin:=Round(totBegin+oMBal:begin_deb-oMBal:begin_cre,decaantal)
   	ENDIF
   * Indien voorgaande jaar nog niet afgesloten, dan som van V&W bepalen om
   * bij kapitaal op te tellen (immers nog niet bijgeboekt):
   IF PrvYearNotClosed .and. (oMBal:cRubrSoort="KO".or.oMBal:cRubrSoort="BA")
   		IF BalMonth==1
   			TrialEnd:=(TrialYear-1)*100+12
   		ELSE
   			TrialEnd:=TrialYear*100+BalMonth-1
   		ENDIF
		oMbal:GetBalance(oAcc:accid,oAcc:balitemid,Year(LstYearClosed)*100+Month(LstYearClosed),TrialEnd)  && balans t/m vorig balansjaar
		vw_deb:=Round(vw_deb + oMBal:per_deb,decaantal)
		vw_cre:=Round(vw_cre + oMBal:per_cre,decaantal)
   ENDIF

   oAcc:SKIP()
ENDDO
IF PrvYearNotClosed .and. (vw_deb#0.or.vw_cre#0)
	IF lPrint
	   oReport:PrintLine(@nRow,@nPage,oLan:Get('Balance income and expense prev.year',64,"!");
	   +Replicate(cTab,4)+Str(vw_deb,11,decaantal)+cTab+Str(vw_cre,11,decaantal)+;
	   cTab+Str(vw_deb-vw_cre,11,DecAantal),Heading,0)
	ENDIF
    totdeb:=totdeb+Round(vw_deb,decaantal)
    totcre:=totcre+Round(vw_cre,decaantal)
ENDIF
totdeb:=Round(totdeb,decaantal)
totcre:=Round(totcre,decaantal)
totBegin=Round(totBegin,decaantal)
IF lPrint
	oReport:PrintLine(@nRow,@nPage,' ',Heading,1)
	oReport:PrintLine(@nRow,@nPage,Space(43)+cTab+Space(11)+cTab+Str(totBegin,11,DecAantal)+cTab+Str(totdeb,11,DecAantal)+;
	cTab+Str(totcre,11,decaantal)+cTab+Str(Round(totBegin+totdeb-totcre,decaantal),11,decaantal),NULL_ARRAY,0)
ENDIF
/*oReport:PrintLine(@nRow,@nPage,Space(65)+"Total begin Cost/Profit:"+Str(totBeginCostProfit,12,decaantal))
oReport:PrintLine(@nRow,@nPage,Space(89)+Replicate("-",12))
oReport:PrintLine(@nRow,@nPage,Space(89)+Str(Round(totdeb-totcre+totBeginCostProfit,decaantal),12,decaantal))   */
*oVBal:Close()
SELF:Pointer := Pointer{POINTERARROW}
IF lPrint
	oReport:prstart()
	oReport:prstop()
ENDIF
RETURN Val(Str(TOtcre-totdeb))
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TrialBalance
	//Put your PostInit additions here
	LOCAL aYearStartEnd:={} as ARRAY
	
	Default(@uExtra,true)
self:SetTexts()
	self:lPrint:=uExtra
	IF ADMIN="WO"
		aYearStartEnd := GetBalYear(Year(Today()),Month(Today()))
		oDCYearTrial:Value := Str(aYearStartEnd[1],4,0)+StrZero(aYearStartEnd[2],2,0)
		MONTHSTART := aYearStartEnd[2]
		MonthEnd := aYearStartEnd[4]
	ELSE
		oDCYearTrial:CurrentItemNo:=1
		MonthStart := Month(Today())
		MonthEnd := Month(Today())
	ENDIF	
	lCondense:=FALSE
	mDepartment:="0:"+sEntity+" "+sLand
	cCurDep:=mDepartment
	WhoFrom:=Space(11)
	IF !Departments
		oDCFixedText4:Hide()
		oCCDepButton:Hide()
		oDCmDepartment:Hide()
	ENDIF

	
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS TrialBalance
	//Put your PreInit additions here
	// oMBal:=MBalance{,DBSHARED,DBREADONLY}
	RETURN NIL
METHOD RegDepartment(myNum,myItemName) CLASS TrialBalance
	Default(@myItemname,NULL_STRING)
	IF !myNum==WhoFrom
		WhoFrom:=myNum
		IF Empty(WhoFrom)
			cCurDep:="0:"+sEntity+" "+sLand
			mDepartment:=cCurDep
			oDCmDepartment:TextValue:=cCurDep
		ELSE
       		IF !oDep:OrderInfo(DBOI_NAME)=="DEPID"
				oDep:SetOrder("DEPID")
			ENDIF
			IF oDep:seek(WhoFrom)
				cCurDep:=AllTrim(oDep:DEPTMNTNBR)+":"+oDep:DESCRIPTN
				mDepartment:=cCurDep
				oDCmDepartment:TextValue:=cCurDep
			ENDIF
		ENDIF
	ENDIF
RETURN

access YearTrial() class TrialBalance
return self:FieldGet(#YearTrial)

assign YearTrial(uValue) class TrialBalance
self:FieldPut(#YearTrial, uValue)
return YearTrial := uValue

STATIC DEFINE TRIALBALANCE_CANCELBUTTON := 107 
STATIC DEFINE TRIALBALANCE_DEPBUTTON := 101 
STATIC DEFINE TRIALBALANCE_FIXEDTEXT1 := 108 
STATIC DEFINE TRIALBALANCE_FIXEDTEXT2 := 109 
STATIC DEFINE TRIALBALANCE_FIXEDTEXT3 := 110 
STATIC DEFINE TRIALBALANCE_FIXEDTEXT4 := 111 
STATIC DEFINE TRIALBALANCE_LCONDENSE := 105 
STATIC DEFINE TRIALBALANCE_MDEPARTMENT := 100 
STATIC DEFINE TRIALBALANCE_MONTHEND := 104 
STATIC DEFINE TRIALBALANCE_MONTHSTART := 103 
STATIC DEFINE TRIALBALANCE_OKBUTTON := 106 
STATIC DEFINE TRIALBALANCE_YEARTRIAL := 102 
CLASS YearClosing INHERIT DataWindowMine 

	PROTECT oCCOKButton as PUSHBUTTON
	PROTECT oCCCancelButton as PUSHBUTTON
	PROTECT oDCFixedText2 as FIXEDTEXT
	PROTECT oDCStartYearText as FIXEDTEXT

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	PROTECT YearClose, MonthClose, BalanceYearEnd, YearStart, MonthStart as int
	EXPORT BalanceEndDate as date
	PROTECT YearBalance as STRING
	Protect cError,cWarning as string 
	PROTECT d_netasset:={},;
		d_dep:={},;
		d_depnbr:={},;
		d_depname:={},;
		d_parentdep:={},;
		d_PLdeb:={},;
		d_PLcre:={}	   as ARRAY 
	
	declare method SubDepartment
RESOURCE YearClosing DIALOGEX  16, 14, 278, 88
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"OK", YEARCLOSING_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 206, 14, 53, 12
	CONTROL	"Cancel", YEARCLOSING_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 204, 36, 53, 13
	CONTROL	"Balance Year:", YEARCLOSING_FIXEDTEXT2, "Static", WS_CHILD, 22, 19, 64, 13
	CONTROL	"", YEARCLOSING_STARTYEARTEXT, "Static", WS_CHILD, 77, 19, 109, 13
END

METHOD CancelButton( ) CLASS YearClosing
	SELF:EndWindow()
	RETURN
METHOD Close(oEvent) CLASS YearClosing
	SUPER:Close(oEvent)
	//Put your changes here
SELF:Destroy()
	RETURN

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS YearClosing 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"YearClosing",_GetInst()},iCtlID)

oCCOKButton := PushButton{SELF,ResourceID{YEARCLOSING_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{YEARCLOSING_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{YEARCLOSING_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Balance Year:",NULL_STRING,NULL_STRING}

oDCStartYearText := FixedText{SELF,ResourceID{YEARCLOSING_STARTYEARTEXT,_GetInst()}}
oDCStartYearText:HyperLabel := HyperLabel{#StartYearText,NULL_STRING,NULL_STRING,NULL_STRING}
oDCStartYearText:TextColor := Color{0,0,128}

SELF:Caption := "Year closing and balancing"
SELF:HyperLabel := HyperLabel{#YearClosing,"Year closing and balancing",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS YearClosing
	* Balancing and closing a year
	LOCAL oWarn as warningbox, lSuc as LOGIC
	LOCAL ProfitLossCre:={}, ProfitLossDeb:={},  ProfitLossAccount:={} as ARRAY
	LOCAL ProfitLossCreF:={}, ProfitLossDebF:={},  ProfitLossCurrency:={} as ARRAY  // deficit/profit foreign currency

	LOCAL cTransnr,backup,cWarning as STRING
	LOCAL min_balance as FLOAT
	LOCAL i, Dep_Ptr as int
	LOCAL cCurrency as STRING
	LOCAL AfterBalance as int
	Local oBord as SQLSelect
	local nMindate as int
	local oSel as SQLSelect
	local oTrans as SQLSelect
	local oDep as SQLSelect
	local oMBal as SQLSelect
	local oBal as balances
	local cName as string
	local cStatement as string
	local oStmnt as SQLStatement
	local nSeqNbr as int // sequence number of generated transaction lines 
	local fTotal as float  // to check if year is correct in balance

	IF Today() <= self:BalanceEndDate
		(ErrorBox{self:OWNER,self:oLan:WGet('End of year not yet reached')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF
	if !Empty(SPROJ)
		* Are there sill non-earmarekd gifts?
		if SQLSelect{"select transid from transaction where bfm='O' and cre>deb and dat <='"+SQLdate(self:BalanceEndDate)+"' and accid='"+SPROJ+"'",oConn}:reccount>0
			(ErrorBox{self:OWNER,self:oLan:WGet('Allot first non-designated gifts in year')+':'+YearBalance}):Show()
			self:EndWindow()
			RETURN true
		ENDIF
	endif
	IF Empty(sCURR) 
		(ErrorBox{self:OWNER,self:oLan:WGet('First specify the currency in System parameters')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF

	* Are there gifts to be send to PMC?
	if ADMIN=='WO'
		oTrans:=SQLSelect{"select t.transid,t.dat,a.accnumber,a.description from transaction t, account a "+;
			",member m where a.accid=m.accid and m.householdid<>'' and grade<>'staf' and "+;
			" a.accid=t.accid and t.bfm='' and t.dat<='"+SQLdate(self:BalanceEndDate)+"'",oConn}
		if oTrans:reccount>0
			do while !oTrans:EOF
				self:cError+=CRLF+'Trnsnr '+Str(oTrans:TransId,-1)+' with date '+DToC(oTrans:dat)+' to '+oTrans:ACCNUMBER+'-'+oTrans:Description
				oTrans:skip()
			enddo
			ErrorBox{self:OWNER,self:oLan:WGet("The following transactions have to be send to PMC first")+":"+self:cError}:Show()
			self:EndWindow()
			return true
		endif
	endif

	// Check if all reevaluations has been done: 
	if SQLSelect{"select lstreeval from Sysparms",oConn}:LSTREEVAL <  self:BalanceEndDate 
		if SQLSelect{"select accid from account where multicurr=0 and currency<>'"+sCURR+"'",oConn}:reccount>0
			(ErrorBox{self:OWNER,self:oLan:WGet('perform first required reevaluations')}):Show()
			self:EndWindow()
			RETURN true
		ENDIF
	endif		


	IF Empty(SKAP)
		(ErrorBox{self:OWNER,self:oLan:WGet('Account for net assets not specified in system data')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF
	IF SQLSelect{"select accid from account where accid='"+skap+"'",oConn}:reccount<1
		(ErrorBox{self:OWNER,self:oLan:WGet('Account for net assets not found')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF
	* Read departments into arrays:
	self:d_dep:={0}
	self:d_netasset:={Val(SKAP)}
	self:d_parentdep:={nil}
	self:d_depname:={sEntity+" "+AllTrim(SLAND)}
	self:d_depnbr:={''}     	
	self:d_PLdeb:={0.00}
	self:d_PLcre:={0.00}
	oDep:=SQLSelect{"select d.parentdep,d.deptmntnbr,d.descriptn,d.depid,d.netasset,b.category from department d "+;
		"left join account a on (a.accid=d.netasset) left join balanceitem b on (a.balitemid=b.balitemid)",oConn}
	if oDep:reccount>0
		
		DO WHILE !oDep:EOF
			AAdd(self:d_dep,oDep:DepId)
			AAdd(self:d_netasset,oDep:netasset)
			AAdd(self:d_parentdep,oDep:ParentDep)
			AAdd(self:d_depname,oDep:Descriptn) 
			AAdd(self:d_depnbr,oDep:DEPTMNTNBR)
			AAdd(self:d_PLdeb,0.00)
			AAdd(self:d_PLcre,0.00)
			IF !Empty(oDep:netasset)
				if Empty(oDep:category)
					(ErrorBox{self:OWNER,self:oLan:WGet('Account for net assets for department')+' '+oDep:DEPTMNTNBR+' '+self:oLan:WGet('not found')}):Show()
					self:EndWindow()
					RETURN true 
				elseif !oDep:category==Liability
					(ErrorBox{self:OWNER,self:oLan:WGet('Account for net assets for department')+' '+oDep:DEPTMNTNBR+' '+self:oLan:WGet('should be liablity/fund')}):Show()
					self:EndWindow()
					RETURN true 			
				ENDIF
			ENDIF
			oDep:skip()
		ENDDO 
	endif

	oWarn := WarningBox{self:OWNER,self:oLan:WGet("Year Balancing"),;
		self:oLan:WGet('Certificate of auditing accountant given for year')+' '+self:YearBalance+'?'}
	oWarn:Type := BOXICONQUESTIONMARK + BUTTONYESNO
	IF (oWarn:Show() = BOXREPLYNO)
		self:EndWindow()
		RETURN true
	ENDIF

	oWarn := WarningBox{self:OWNER,self:oLan:WGet("Year Balancing"),self:oLan:WGet('Have you backed up your data')+'?'}
	oWarn:Type := BOXICONQUESTIONMARK + BUTTONYESNO
	IF (oWarn:Show() = BOXREPLYNO)
		self:EndWindow()
		RETURN true
	ENDIF
	oWarn := WarningBox{self:OWNER,"Year Balancing",;
		'Closing of the year is irrevocable, are you sure?'}
	oWarn:Type := BOXICONQUESTIONMARK + BUTTONYESNO
	IF (oWarn:Show() = BOXREPLYNO)
		self:EndWindow()
		RETURN true
	ENDIF

	oWarn := WarningBox{self:OWNER,self:oLan:WGet("Year Balancing"),self:oLan:WGet("Everyone else is locked out from the system")}
	oWarn:Type := BOXICONQUESTIONMARK + BUTTONYESNO
	IF (oWarn:Show() = BOXREPLYNO)
		self:EndWindow()
		RETURN true
	ENDIF 
	// check if there is someone else in the system: 
	oSel:=SQLSelect{'select e.empid,'+SQLFullName(2)+' as fullname';
	+' from employee as e, person as p where p.persid='+Crypt_Emp(false,"e.persid")+" and online=1" + ;
	" and "+Crypt_Emp(false,"e.loginname")+"<>'"+LOGON_EMP_ID+"' order by lastname",oConn}
	do while oSel:reccount>0
		cWarning:=""
		do while !oSel:EOF
			cWarning+=CRLF+oSel:fullname
			oSel:skip()
		enddo
		ErrorBox{self:OWNER,self:oLan:WGet("following employees are still in the system")+":"+cWarning}:Show()
		oSel:Execute()  // reread
		oSel:Gotop()
	enddo
   SQLStatement{"start transaction",oConn}:Execute()
	// lock employee table:
	oStmnt:=SQLStatement{"select empid from employee for update",oConn}
	oStmnt:Execute()
	if !Empty(oStmnt:Status)
		SQLStatement{"rollback",oConn}:Execute()
		ErrorBox{self,self:oLan:WGet("can't lock others out")}:Show()
		return
	endif 	
	
	self:Pointer := Pointer{POINTERHOURGLASS}

	self:OWNER:STATUSMESSAGE(self:oLan:WGet("Collecting balance data, please wait")+"...")
	* save balances of profit/loss accounts over year to be closed into arrays ProfitLossDeb/Cre
	AfterBalance :=Year(self:BalanceEndDate+1)*100+Month(self:BalanceEndDate+1) 
   oBal:=Balances{}
   oMBal:=SQLSelect{oBal:SQLGetBalance(self:YearStart*100+self:MonthStart,self:YearClose*100+self:MonthClose,false,true,,true),oConn}
   oMBal:Gotop()
   self:cError:=""
	DO WHILE !oMBal:EOF 
		cCurrency:=oMBal:Currency

		* balance of year to be closed = balance of previous versus following year:
		* balances of expense and income accounts have to be added to corresponding netassets and zero balanced:
		IF oMBal:category == Expense .or. oMBal:category == Income
			* saldo van V&W verminderen met stand afgelopen jaar:
			AAdd(ProfitLossAccount,oMBal:accid)
			Dep_Ptr:=AScan(self:d_dep,oMBal:Department)
			IF Dep_Ptr=0
				* No requested department: 
				self:cError:=self:oLan:WGet("Not defined department in account")+":"+oMBal:ACCNUMBER
				exit
			ENDIF
			AAdd(ProfitLossDeb,oMBal:per_deb)
			AAdd(ProfitLossCre,oMBal:per_cre)
			AAdd(ProfitLossDebF,oMBal:per_debF)        // reserve place for foreign currency
			AAdd(ProfitLossCreF,oMBal:per_creF) 
			AAdd(ProfitLossCurrency,oMBal:Currency)
			self:d_PLdeb[Dep_Ptr]:=Round(self:d_PLdeb[Dep_Ptr]+oMBal:per_deb,DecAantal)
			self:d_PLcre[Dep_Ptr]:=Round(self:d_PLcre[Dep_Ptr]+oMBal:per_cre,DecAantal) 
			fTotal:=Round(fTotal+oMBal:per_cre-oMBal:per_deb,DecAantal)
		else
			fTotal:=Round(fTotal+oMBal:per_cre-oMBal:per_deb+oMBal:PrvPer_cre-oMBal:PrvPer_deb,DecAantal)
		ENDIF

		IF oMBal:per_deb#0.or.oMBal:per_cre#0 .or. oMBal:per_debF # 0 .or. oMBal:per_creF # 0
			* Save per_deb and per_cre AccountBalanceYear next year:
			IF oMBal:category == Expense .or. oMBal:category == Income
				min_balance:=0
			else
				min_balance:=Min(oMBal:per_deb,oMBal:per_cre)
			endif
			oStmnt:=SQLStatement{"insert into accountbalanceyear set "+;
			"accid='"+Str(oMBal:accid,-1)+"'"+;
			",yearstart="+Str(AfterBalance/100,4,0)+;
			",monthstart="+Str(AfterBalance%100,2,0)+; 
			",currency='"+sCURR+"'"+;
			",svjd='"+Str(Round(oMBal:per_deb - min_balance,DecAantal),-1)+"',svjc='"+Str(Round(oMBal:per_cre - min_balance,DecAantal),-1)+"'",oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows>0
				if oMBal:Currency # sCURR
					// also foreign currency balance: 
					if oMBal:category == Expense .or. oMBal:category == Income
						min_balance:=0
					else
						min_balance:=Min(oMBal:per_debF,oMBal:per_creF)
					endif
					oStmnt:=SQLStatement{"insert into accountbalanceyear	set "+;
					"accid='"+Str(oMBal:accid,-1)+"'"+;
					",yearstart="+Str(AfterBalance/100,4,0)+;
					",monthstart="+Str(AfterBalance%100,2,0)+;	
					",currency='"+oMBal:Currency+"'"+;
					",svjd='"+Str(Round(oMBal:per_debF - min_balance,DecAantal),-1)+"',svjc='"+Str(Round(oMBal:per_creF - min_balance,DecAantal),-1)+"'",oConn}
					oStmnt:Execute()
					if	!Empty(oStmnt:Status)
						self:cError:=self:oLan:WGet("could	not update accountbalanceyear")+":"+oMBal:ACCNUMBER+"	- "+oMBal:Description
						LogEvent(self,self:cError+"; statement:"+oStmnt:SQLString+CRLF+"Error:"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
						exit
					endif
				endif
			else
				self:cError:=self:oLan:WGet("could	not update accountbalanceyear")+":"+oMBal:ACCNUMBER+"	- "+oMBal:Description 
				LogEvent(self,self:cError+"; statement:"+oStmnt:SQLString+CRLF+"Error:"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
				exit			
			ENDIF
		endif
		oMBal:skip()
	ENDDO
	if !Empty(self:cError)
		SQLStatement{"rollback",oConn}:Execute()
		self:Pointer := Pointer{POINTERARROW}
		(ErrorBox{self:OWNER,self:cError}):Show()
		return
	endif
	if fTotal<>0.00
		SQLStatement{"rollback",oConn}:Execute()
		self:Pointer := Pointer{POINTERARROW}
		(ErrorBox{self:OWNER,self:oLan:WGet("balance year is not in balance")}):Show()
		return
	endif
		
	* Make records to netassetaccounts per department:
	self:STATUSMESSAGE(self:oLan:WGet("Recording to netasset accounts, moment please"))
	self:cWarning:=''
	if !self:SubDepartment(1,@cTransnr,@nSeqNbr,AfterBalance)
		SQLStatement{"rollback",oConn}:Execute()
		self:Pointer := Pointer{POINTERARROW}
		if !Empty(self:cError)
			(ErrorBox{self:OWNER,self:cError}):Show()
		endif
		return
	ENDIF
	if !Empty(self:cWarning)
		self:Pointer := Pointer{POINTERARROW}
		IF (TextBox{self:OWNER,self:oLan:WGet("Year balancing"),self:oLan:WGet('Warning: Net Asset account not defined for Departments')+': '+CRLF+;
			self:cWarning+CRLF+self:oLan:WGet("Is this correct")+"?",BUTTONYESNO+BOXICONHAND}):Show()==BOXREPLYNO
			RETURN FALSE
		else
			self:Pointer := Pointer{POINTERHOURGLASS}
		endif
	endif

	* Record transfer of profit/Loss to netasset accounts:
	self:STATUSMESSAGE(self:oLan:WGet("Recording profit/loss transactions, moment please"))

	FOR i = 1 to Len(ProfitLossAccount)
		IF ProfitLossDeb[i]#0 .or. ProfitLossCre[i]#0
			nSeqNbr++
			cStatement:="insert into transaction set "+;
			"transid="+cTransnr+;
			",dat='"+SQLdate(self:BalanceEndDate)+"'"+;
			",docid='CL"+StrZero(self:YearClose,4)+StrZero(self:MonthClose,2)+"'"+;
			",description='"+self:oLan:Get('Closing year',,"!")+'	'+self:oDCStartYearText:TEXTvalue+"'"+; 
			",accid='"+Str(ProfitLossAccount[i],-1)+"'"+;
			",deb="+Str(-ProfitLossDeb[i],-1)+;
			",cre="+Str(-ProfitLossCre[i],-1)+;
			",userid='"+LOGON_EMP_ID +"'"+;
			",currency='"+ProfitLossCurrency[i] +"'"+;
			",debforgn="+Str(-ProfitLossDebF[i],-1)+;
			",creforgn="+Str(-ProfitLossCreF[i],-1)+;
			",seqnr="+Str(nSeqNbr,-1)+;
			",poststatus=2"	
			oStmnt:=SQLStatement{cStatement,oConn}
			oStmnt:Execute()
			if	oStmnt:NumSuccessfulRows<1
				self:cError:=self:oLan:WGet("could not add transaction")+";Error:"+oStmnt:ErrInfo:ErrorMessage
				LogEvent(self,self:cError+CRLF+"statement:"+oStmnt:SQLString,"LogErrors")
				SQLStatement{"rollback",oConn}:Execute()
				self:Pointer := Pointer{POINTERARROW}
				(ErrorBox{self:OWNER,self:cError}):Show()
				return
			endif
		ENDIF
	NEXT


	* Update closed year:
	oStmnt:=SQLStatement{"insert into balanceyear set "+;
	"yearstart="+Str(Year(LstYearClosed),-1)+;
	",monthstart="+Str(Month(LstYearClosed),-1)+;
	",yearlength="+Str(self:YearClose*12+self:MonthClose+1-Year(LstYearClosed)*12-Month(LstYearClosed),-1)+;
	",state='C'",oConn}
	oStmnt:Execute()
	if oStmnt:NumSuccessfulRows<1
		self:cError:=self:oLan:WGet("could not add transaction")+";Error:"+oStmnt:ErrInfo:ErrorMessage
		LogEvent(self,self:cError+CRLF+"statement:"+oStmnt:SQLString,"LogErrors")
		SQLStatement{"rollback",oConn}:Execute()
		self:Pointer := Pointer{POINTERARROW}
		(ErrorBox{self:OWNER,self:cError}):Show()
		return
	endif
	oStmnt:=SQLStatement{"update sysparms set yearclosed="+Str(self:YearClose,-1)+",mindate='"+SQLdate(self:BalanceEndDate+1)+"'",oConn}
	oStmnt:Execute()	
	if !Empty(oStmnt:Status)
		self:cError:=self:oLan:WGet("could not change sysparms")+";Error:"+oStmnt:ErrInfo:ErrorMessage
		LogEvent(self,self:cError+CRLF+"statement:"+oStmnt:SQLString,"LogErrors")
		SQLStatement{"rollback",oConn}:Execute()
		self:Pointer := Pointer{POINTERARROW}
		(ErrorBox{self:OWNER,self:cError}):Show()
		return
	endif

	* Clearing of the database:
	* Archiving Transactions: 
	// create archive table: 
	self:STATUSMESSAGE(self:oLan:WGet("Creating archive file, moment please"))
	cName:= 'Tr'+Str(self:YearStart,4)+StrZero(self:MonthStart,2)
	oStmnt:=SQLStatement{"create table "+cName+" (primary key (transid,seqnr)) engine=MyIsam select * from transaction where dat<='"+SQLdate(self:BalanceEndDate)+"'",oConn} 
	oStmnt:Execute()                        
	if Empty(oStmnt:Status)
		// create other indexes:
		
	endif		
	
	if !Empty(oStmnt:Status)
		self:cError:=self:oLan:WGet("could not create archive file")+": "+cName+"; Error:"+oStmnt:ErrInfo:ErrorMessage
		LogEvent(self,self:cError+CRLF+"statement:"+oStmnt:SQLString,"LogErrors")
		SQLStatement{"rollback",oConn}:Execute()
		self:Pointer := Pointer{POINTERARROW}
		(ErrorBox{self:OWNER,self:cError}):Show()
		return
	endif
	// remove old transactions from transaction table:
	self:STATUSMESSAGE(self:oLan:WGet("Removing of transactions, moment please"))
	oStmnt:=SQLStatement{"delete from transaction where dat<='"+SQLdate(self:BalanceEndDate)+"'",oConn} 
	oStmnt:Execute() 
	if !Empty(oStmnt:Status)
		self:cError:=self:oLan:WGet("could not clear old transactions")+"; Error:"+oStmnt:ErrInfo:ErrorMessage
		LogEvent(self,self:cError+CRLF+"statement:"+oStmnt:SQLString,"LogErrors")
		SQLStatement{"rollback",oConn}:Execute()
		self:Pointer := Pointer{POINTERARROW}
		(ErrorBox{self:OWNER,self:cError}):Show()
		return
	endif

	* Clearing Due Amounts:
	self:STATUSMESSAGE(self:oLan:WGet("Removing of received invoiced amounts, moment please"))
	oStmnt:=SQLStatement{"delete from dueamount where invoicedate<subdate(curdate(),120) and amountrecvd >=amountinvoice or invoicedate<subdate(curdate(), interval 1 year)",oConn} 
	oStmnt:Execute()
  	if !Empty(oStmnt:Status)
		self:cError:=self:oLan:WGet("could not clear old dueamounts")+"; Error:"+oStmnt:ErrInfo:ErrorMessage
		LogEvent(self,self:cError+CRLF+"statement:"+oStmnt:SQLString,"LogErrors")
		SQLStatement{"rollback",oConn}:Execute()
		self:Pointer := Pointer{POINTERARROW}
		(ErrorBox{self:OWNER,self:cError}):Show()
		return
	endif

	* Clearing Bank orders:
	self:STATUSMESSAGE(self:oLan:WGet("Removing of payable amounts, moment please"))
	oStmnt:=SQLStatement{"delete from bankorder where datepayed>'000-00-00' and datepayed<subdate(Curdate(),200)",oConn} 
	oStmnt:Execute()
  	if !Empty(oStmnt:Status)
		self:cError:=self:oLan:WGet("could not clear old bank orders")+"; Error:"+oStmnt:ErrInfo:ErrorMessage
		LogEvent(self,self:cError+CRLF+"statement:"+oStmnt:SQLString,"LogErrors")
		SQLStatement{"rollback",oConn}:Execute()
		self:Pointer := Pointer{POINTERARROW}
		(ErrorBox{self:OWNER,self:cError}):Show()
		return
	endif
	oStmnt:=SQLStatement{"commit",oConn}
	oStmnt:Execute()
	self:Pointer := Pointer{POINTERARROW}
	if empty(oStmnt:status)
		TextBox{self,self:oLan:WGet("year balancing and closing"),self:oLan:WGet("Year")+space(1)+self:YearBalance+space(1)+self:oLan:WGet("successfully closed")}:Show()
		LstYearClosed	:=self:BalanceEndDate+1
	else
		TextBox{self,self:oLan:WGet("year balancing and closing"),self:oLan:WGet("Year")+space(1)+self:YearBalance+space(1)+self:oLan:WGet("not closed")}:Show()
		return		
	endif
	FillBalYears()  // refill GLBalYears
	self:EndWindow() 
	self:Close()
	RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS YearClosing
	//Put your PostInit additions here 
	local aYear:={} as array
self:SetTexts()
	aYear:=GetBalYear(Year(LstYearClosed),Month(LstYearClosed))
	self:YearStart:=aYear[1]
	self:MonthStart:=aYear[2]
	self:YearClose :=aYear[3]
	self:MonthClose:=aYear[4]
	self:BalanceYearEnd:=self:YearClose*12+self:MonthClose
	self:BalanceEndDate:=SToD(Str(self:YearClose,4)+StrZero(self:MonthClose,2)+StrZero(MonthEnd(self:MonthClose,self:YearClose),2))
	self:oDCStartYearText:TextValue:=Str(self:YearStart,4)+":"+StrZero(self:MonthStart,2)+"  -  "+;
	Str(self:YearClose,4)+":"+StrZero(self:MonthClose,2)
	self:YearBalance := self:oDCStartYearText:TextValue
	RETURN NIL
METHOD SubDepartment(p_depptr as int, cTransnr ref string,nSeqNbr ref int,AfterBalance as int) as logic pascal CLASS YearClosing
	* Recursive processing of a department with its subdeparments
	*
	LOCAL subDepPtr AS INT
	LOCAL min_balance, PL_totdeb, PL_totcre as FLOAT
	local cStatement as string
	local oStmnt as SQLStatement

	subDepPtr:=0
	DO WHILE TRUE
		subDepPtr:=AScan(self:d_parentdep,self:d_dep[p_depptr],subDepPtr+1)
		IF Empty(subDepPtr)
			EXIT
		ELSE
			if self:SubDepartment(subDepPtr,@cTransnr,@nSeqNbr,AfterBalance)
				* consolidate values of subdepartment into itself:
				self:d_PLdeb[p_depptr]:=Round(self:d_PLdeb[p_depptr]+self:d_PLdeb[subDepPtr],DecAantal)
				self:d_PLcre[p_depptr]:=Round(self:d_PLcre[p_depptr]+self:d_PLcre[subDepPtr],DecAantal)
			else
				return false
			endif
		ENDIF
	ENDDO
	*
	* Make records to netassetaccount of the  department:
	if !Round(self:d_PLcre[p_depptr]-self:d_PLdeb[p_depptr],DecAantal)==0.00
		IF Empty(self:d_netasset[p_depptr])
			self:cWarning+=self:d_depnbr[p_depptr]+":"+self:d_depname[p_depptr]+CRLF
// 			self:Pointer := Pointer{POINTERARROW}
// 			IF (TextBox{self:OWNER,self:oLan:WGet("Year balancing"),self:oLan:WGet('Warning: Net Asset account not defined for Department')+': '+self:d_depnbr[p_depptr]+":";
// 				+self:d_depname[p_depptr]+CRLF+self:oLan:WGet("Is this correct")+"?",BUTTONYESNO+BOXICONHAND}):Show()==BOXREPLYNO
// 				RETURN FALSE
// 			else
// 				self:Pointer := Pointer{POINTERHOURGLASS}
// 			endif
		else
			PL_totdeb:=self:d_PLdeb[p_depptr]
			PL_totcre:=self:d_PLcre[p_depptr]
			min_balance:=Min(PL_totdeb,PL_totcre)	 && afletteren	deb -	cre
			PL_totdeb := Round(PL_totdeb - min_balance,DecAantal)
			PL_totcre := Round(PL_totcre - min_balance,DecAantal)
			nSeqNbr++
			cStatement:="insert into transaction set "+;
				iif(Empty(cTransnr),'',"transid="+cTransnr+",")+;
				"dat='"+SQLdate(self:BalanceEndDate)+"'"+;
				",docid='CL"+StrZero(self:YearClose,4)+StrZero(self:MonthClose,2)+"'"+;
				",description='"+self:oLan:Get('Closing year',,"!")+'	'+self:oDCStartYearText:TEXTvalue+"'"+; 
				",accid='"+Str(self:d_netasset[p_depptr],-1)+"'"+;
				",deb="+Str(PL_totdeb,-1)+;
				",cre="+Str(PL_totcre,-1)+;
				",userid='"+LOGON_EMP_ID +"'"+;
				",currency='"+sCURR +"'"+;
				",debforgn="+Str(PL_totdeb,-1)+;
				",creforgn="+Str(PL_totcre,-1)+;
				",seqnr="+Str(nSeqNbr,-1)+;
				",poststatus=2"	
				oStmnt:=SQLStatement{cStatement,oConn}
				oStmnt:Execute()
				if	oStmnt:NumSuccessfulRows>0
					if	Empty(cTransnr)
						cTransnr:=SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)
					endif
					* adapt last year	balance of net	asset	account: 
					oStmnt:=SQLStatement{"insert into accountbalanceyear set "+;
						"accid='"+Str(self:d_netasset[p_depptr],-1)+"'"+;
						",yearstart="+Str(AfterBalance/100,4,0)+;
						",monthstart="+Str(AfterBalance%100,2,0)+; 
						",currency='"+sCURR+"'"+;
						",svjd='"+Str(PL_totdeb,-1)+"',svjc='"+Str(PL_totcre,-1)+"'",oConn}
					oStmnt:Execute()
					if	oStmnt:NumSuccessfulRows<1
						oStmnt:=SQLStatement{"update accountbalanceyear	set "+;
						"svjd=svjd+"+Str(PL_totdeb,-1)+",svjc=svjc+"+Str(PL_totcre,-1)+;
						" where accid='"+Str(self:d_netasset[p_depptr],-1)+"' and "+;
						" yearstart="+Str(AfterBalance/100,4,0)+;
						" and	monthstart="+Str(AfterBalance%100,2,0)+; 
						" and	currency='"+sCURR+"'",oConn}
						oStmnt:Execute()
						if	!Empty(oStmnt:Status)
							self:cError:=self:oLan:WGet("could not	update accountbalanceyear")+";Error:"+oStmnt:ErrInfo:ErrorMessage
							LogEvent(self,self:cError+CRLF+"statement:"+oStmnt:SQLString,"LogErrors")
							return false
						endif
					endif
					* Clear self:d_PLdeb/cre:
					self:d_PLdeb[p_depptr]:=0.00
					self:d_PLcre[p_depptr]:=0.00 
				else
					self:cError:=self:oLan:WGet("could not add transaction")+";Error:"+oStmnt:ErrInfo:ErrorMessage
					LogEvent(self,self:cError+CRLF+"statement:"+oStmnt:SQLString,"LogErrors")
					return false
				endif
		endif
	ENDIF
	RETURN true
STATIC DEFINE YEARCLOSING_CANCELBUTTON := 101 
STATIC DEFINE YEARCLOSING_FIXEDTEXT2 := 102 
STATIC DEFINE YEARCLOSING_OKBUTTON := 100 
STATIC DEFINE YEARCLOSING_STARTYEARTEXT := 103 
