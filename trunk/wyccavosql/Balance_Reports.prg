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
	PROTECT oDCind_explanation AS CHECKBOX
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
	INSTANCE ind_explanation
	INSTANCE lCondense
	INSTANCE ind_accstmnt
	PROTECT balsoort, cCurBal, cCurDep as STRING
	PROTECT BalCount, DepCount AS INT
	PROTECT oTransMonth AS AccountStatements

PROTECT mainheading:={},;
		HeadingCache:={} as ARRAY 
export addheading as string
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
protect cSummary,cDirectText,cDirectOn,cIncome,cIncomeL,cExpense,cExpenseL,cLiability,cAsset,cDetailed,cInscriptionInEx,cInscriptionAsLi,cInscriptionDep as string 
protect cFrom,cTo,cYear,cFullyear,cDescription,cPrvYrYTD,cCurPeriod,cYtD,cSurPlus,cClsBal,cClosingBal,cAmount,cBudget,cOpeningBal as string 
protect cNegative,cPositive as string 


declare method SubDepartment, ProcessDepBal,SUBBALITEM,BalancePrint,AddSubDep,AddSubBal,SubNetDepartment,prheading,BalFishTot
RESOURCE BalanceReport DIALOGEX  38, 35, 371, 225
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
	CONTROL	"With explanation", BALANCEREPORT_IND_EXPLANATION, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 85, 166, 80, 11
	CONTROL	"Condense", BALANCEREPORT_LCONDENSE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 85, 183, 80, 11
	CONTROL	"With account statements", BALANCEREPORT_IND_ACCSTMNT, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 85, 200, 99, 11
	CONTROL	"OK", BALANCEREPORT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 306, 5, 54, 12
	CONTROL	"Cancel", BALANCEREPORT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 307, 29, 53, 12
	CONTROL	"Down from:", BALANCEREPORT_FIXEDTEXT4, "Static", WS_CHILD, 14, 83, 40, 13
	CONTROL	"Balance Items:", BALANCEREPORT_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 72, 350, 29
	CONTROL	"Departments:", BALANCEREPORT_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 107, 350, 29
	CONTROL	"Down from:", BALANCEREPORT_FIXEDTEXT5, "Static", WS_CHILD, 14, 118, 40, 13
	CONTROL	"Options", BALANCEREPORT_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 70, 139, 116, 79
END

METHOD AddSubBal(ParentNum:=0 as int, nCurrentRec:=0 as int,aItem ref array, level as int,r_indmain ref array,r_parentid ref array,r_balid ref array,r_balnbr ref array,r_cat ref array,r_heading ref array,r_footer ref array) as int  CLASS BalanceReport
* Find subbalance items and add to arrays withbalance Items
	LOCAL nChildRec, iWidth, p	AS INT
	LOCAL nCurNum		as int 
	local oBal 			as SQLSelect
	local lFirst		as logic

	if Empty(aItem)
		oBal:=SQLSelect{"select * from balanceitem order by number",oConn} 
		if oBal:reccount>0
			do while !oBal:EoF
				AAdd(aItem,{oBal:balitemid,oBal:number,oBal:balitemidparent,oBal:category,iif(Empty(oBal:Heading),'',oBal:Heading),iif(Empty(oBal:Footer),''oBal:Footer)})   
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
		nChildRec:=self:AddSubBal(nCurNum, nChildRec,@aItem,level+1,@r_indmain,@r_parentid,@r_balid,@r_balnbr,@r_cat,@r_heading,@r_footer)
		IF Empty(nChildRec)
			EXIT
		ENDIF
	ENDDO
RETURN nCurrentRec
METHOD AddSubDep(ParentNum:=0 as int, nCurrentRec:=0 as int,aItem ref array,d_dep ref array,d_parentdep ref array,d_indmaindep ref array,d_depname ref array,d_acc ref array,d_netasset ref array,d_netnum ref array) as int CLASS BalanceReport
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
		nChildRec:=self:AddSubDep(nCurNum,nChildRec,@aItem,@d_dep,@d_parentdep,@d_indmaindep,@d_depname,@d_acc,@d_netasset,@d_netnum)
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
	*	whodetails						� True	� True	� False	� False	�						 *
	*	whatdetails						� False	� True	� False	� True	�						 *
	*	------------------------------------------------�---------------------------------------------------------------�				 *
	*	explorer view depmt  			�    x	�		�		�		�						 *
	*	heading dep.name incl parents  	�		�     x	�    x	�    x	�						 *
	*	one line /depmt  				�    x	�		�    x	�   	�						 *
	*																							 *
	*	FileInit: first line for output																						 *
	**********************************************************************************************
	*
	LOCAL aant_gev,rektel, i,j,BalStrt  as int
	LOCAL mType,m_cat:="",cHeading,CurHeading,m_accid,m_balId, cBalName as STRING
	LOCAL Totalize as LOGIC
	LOCAL BalYear,BalMonth,CurBalId as int
	LOCAL PrvYr_YtD as FLOAT
	LOCAL TopWhatPtr, TopWhoPtr AS INT
	LOCAL nCurRec, Bal_Ptr,Dep_Ptr,net_ptr,nCurAcc,nRecno as int
	LOCAL d_sort:={},b_sort:={},accnts:={}, d_PrfLssPrYr:={} as ARRAY
	LOCAL lSaveWho, lSaveWhat AS LOGIC
	LOCAL YearGranularity as LOGIC 
	Local iLine:=self:iLine, iPage:=self:iPage as int 
	local aBalYr:={} as array 
	Local oAcc,oBal,oDep as SQLSelect
	local oMbal as balances
	local fPrvYr_bal,fPrvYr_YtD,fPrvPer_bal,fper_bal,fYr_Bud,fPer_Bud,fYTDbud as float   // totals per department for details per department 
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
// 	IF self:SendToMail
if self:oReport:lRTF 
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
// 	IF !ValidateControls( SELF, SELF:AControls )
// 		RETURN
// 	END
	aBalYr:=GetBalYear(Val(SubStr(self:BalYears,1,4)),Val(SubStr(self:BalYears,5,2)))
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
	self:CurEnd:=self:YEAREND*12+self:MONTHEND
	self:BalSt:=BalYear*12+BalMonth
	self:BalEnd:=aBalYr[3]*12+aBalYr[4]
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
		nCurRec:=self:AddSubDep(self:WhoFrom,nCurRec,@aItem,@d_dep,@d_parentdep,@d_indmaindep,@d_depname,@d_acc,@d_netasset,@d_netnum)
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
		nCurRec:=self:AddSubBal(self:WhatFrom,nCurRec,@aItem,0,@r_indmain,@r_parentid,@r_balid,@r_balnbr,@r_cat,@r_heading,@r_footer)
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
		true,false,true,true)
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
		self:SubNetDepartment(1,d_parentdep,d_dep,@d_PLdeb,@d_PLcre,d_netnum,r_balid,@rd_BalPer,@rd_BalPrvYr,@rd_BalPrvYrYtD,@rd_BalPrvPer,;
			@rd_bud,@rd_budper,@rd_budytd,d_PrfLssPrYr)
	ENDIF

	********************************************************************************************************************************************************************
	*                                                                                                                                                                                                                                                                              *
	* Printing of balance items starting with hierarchily top item self:WhatFrom:                                                                                                                            *
	*                                                                                                                                                                                                                                                                              *
	********************************************************************************************************************************************************************
	*
	self:STATUSMESSAGE(self:oLan:WGet("Printing summary")) 
	// prefill fixed textes:
	self:cSummary:=oLan:RGet("SUMMARY",,"@!")
	self:cDirectText:=oLan:RGet("Direct Records",,"!")
	self:cDirectOn:=oLan:RGet("Direct on",,"!") 
	self:cIncome:= oLan:RGet('INCOME',,"@!") 
	self:cIncomeL:=oLan:RGet('Income',13,"!","R")
	self:cExpense:=oLan:RGet('EXPENSE',,"@!") 
	self:cExpenseL:=oLan:RGet('Expense',11,"!","R")
	self:cLiability:=oLan:RGet('LIABILITIES AND FUNDS',,"@!")
	self:cAsset:=oLan:RGet('ASSET',,"@!")
	self:cDetailed:=oLan:RGet('DETAILED',,"@!")
	self:cInscriptionInEx:=oLan:RGet('INCOME AND EXPENSE',,"@!")
	self:cInscriptionAsLi:=oLan:RGet('BALANCE SHEET',,"@!")
	self:cInscriptionDep:=oLan:RGet('DEPARTMENTS',,"@!")
	self:cFrom:=oLan:RGet('from',6)
	self:cTo:=oLan:RGet('to',5,,'C')
	self:cYear:=oLan:RGet('Year',7,"!","L") 
	self:cFullyear:=oLan:RGet('FULL YEAR',21,"@!","C")
	self:cDescription:=oLan:RGet('Description',iif(lXls,24,self:BalColWidth),"!")+iif(lXls,Replicate(self:TAB,self:MaxLevel),"")
	self:cPrvYrYTD:=oLan:RGet('PREVIOUS YEAR TO DATE',21,'@!','R')
	self:cCurPeriod:=oLan:RGet('CURRENT PERIOD',15,"@!","R")
	self:cYtD:=oLan:RGet('YEAR TO DATE',20,"@!","R")
	self:cSurPlus:=oLan:RGet('Surplus',9,"!","R")
	self:cClsBal:=oLan:RGet('Cls.Balance',11,"!","R")
	self:cClosingBal:=oLan:RGet('CLOSING BALANCE',,"!")+Space(1)+DToC(SToD(Str(self:YEAREND,4,0)+StrZero(MONTHEND,2,0)+StrZero(MonthEnd(self:MONTHEND,self:YEAREND),2,0)))
	self:cAmount:=oLan:RGet('Amount',11,"!","R") 
	self:cBudget:=oLan:RGet('Budget-%',8,"!","R")
	self:cOpeningBal:=Pad(oLan:RGet('OPENING FUND BALANCE',,"!")+Space(1)+DToC(stod(str(self:BalSt/12,4,0)+strzero(self:Balst%12,2,0)+'01')),BalColWidth+iif(self:SimpleDepStmnt,2,46))
	self:cNegative:=oLan:RGet('Negative',,"!")
	self:cPositive:=oLan:RGet('Posative',,"!")

	self:mainheading:=self:prheading(self:cSummary,r_cat[1],1,,d_dep,d_parentDep,d_depname,;
		r_balid,r_heading,r_footer,r_parentid)
	
	self:mainheading[1]:= BoldOn+YellowOn+ self:mainheading[1]+YellowOff+BoldOff
	SetDecimalSep(Asc(DecSeparator))

	SELF:SubDepartment(1,0,d_netnum,d_indmaindep,d_depname,d_parentDep,d_dep,;
		r_cat,@r_balpryrtot,@r_balPrYrYtD,@r_balPrvPer,@r_balPer,r_indmain,r_parentid,;
		r_heading,r_footer,r_balnbr,r_balid,@r_bud,@r_budper,@r_budytd,;
		rd_BalPrvYr,rd_BalPrvYrYtD,rd_BalPrvPer,rd_BalPer,rd_bud,rd_budper,rd_budytd,@iLine,@iPage)

	* Printing explanation details per account:      
	IF self:ind_explanation .and. (self:WhatDetails .or. self:WhoDetails)
		self:STATUSMESSAGE(self:oLan:WGet("Printing details, moment please"))
		iLine:=0  && force iPageskip 
		if !self:WhoDetails
			// details per balance item over all accounts:
			// assemble accounts from all departments from d_acc: {balsoort+Pad(cBalName,25)+Str(oAcc:balitemid,11,0)+Str(oAcc:recno,11,0)+"P")
			FOR i:= 1 to self:DepCount
				for j:=1 to Len(d_acc[i])
					AAdd(accnts,d_acc[i,j])
				next
			next	
			self:DepCount:=1
			d_acc:={accnts}
			d_sort:={{'',1}}
		else
			// details per subdepartment:
			* Enforce order on department name:
			FOR i:=1 to self:DepCount
				AAdd(d_sort,{Upper(d_depName[i]),i})
			NEXT
			ASort(d_sort,,,{|x,y| x[1]<=y[1]}) 
		ENDIF
		FOR i:= 1 to self:DepCount
			Dep_Ptr:=d_sort[i,2]
			accnts:=d_acc[Dep_Ptr]    //accounts from d_acc: {balsoort+Pad(cBalName,25)+Str(oAcc:balitemid,11,0)+Str(oAcc:recno,11,0)+"P")
			ASort(accnts)
			m_balId:=Space(11)
			mType:=' '
			Totalize:=FALSE
			aant_gev:=0 
			if !self:WhatDetails
				// details per department: 
				self:mainheading:=self:prheading(self:cDetailed,'DEP',Dep_Ptr,,d_dep,d_parentdep,d_depname,;
					r_balid,r_heading,r_footer,r_parentid)
// 				iLine:=0  && force iPageskip 
				store 0.00 to fPrvYr_bal,fPrvYr_YtD,fPrvPer_bal,fper_bal,fYr_Bud,fPer_Bud,fYTDbud 
				CurHeading:=''
			endif
			FOR rektel=1 to Len(accnts)
				if self:WhatDetails
					IF SubStr(accnts[rektel],27,11) # m_balId
						IF Totalize
							IF aant_gev>1
								self:prtotaal(m_cat,@iLine,@iPage)
								self:prAmounts(m_cat,rd_BalPrvYr[Dep_Ptr,Bal_Ptr],;
									rd_BalPrvYrYtD[Dep_Ptr,Bal_Ptr],;
									rd_BalPrvPer[Dep_Ptr,Bal_Ptr],rd_BalPer[Dep_Ptr,Bal_Ptr],;
									rd_bud[Dep_Ptr,bal_ptr],rd_budper[Dep_Ptr,bal_ptr],rd_budytd[Dep_Ptr,bal_ptr],0,r_footer[bal_ptr],r_heading,0.00,0.00,@iLine,@iPage)
							ENDIF
						ENDIF
						IF SubStr(accnts[rektel],1,1) # mType
							mType:=SubStr(accnts[rektel],1,1)
							IF mType='1'
								m_cat:=INCOME
								cHeading:=self:cIncome
							ELSEIF mType='2'
								m_cat:=EXPENSE
								cHeading:=self:cExpense
							ELSEIF mType='3'
								m_cat:=ASSET
								cHeading:=self:cAsset
							ELSE
								m_cat:=LIABILITY 
								cHeading:=self:cLiability
							ENDIF
							self:mainheading:=self:prheading(self:cDetailed,m_cat,Dep_Ptr,,d_dep,d_parentdep,d_depname,;
								r_balid,r_heading,r_footer,r_parentid)
						ENDIF
						m_balId:=SubStr(accnts[rektel],27,11)
						Bal_Ptr:=AScan(r_balid,Val(m_balId))
						aant_gev:=0
					ENDIF
				endif
				nRecno:=Val(SubStr(accnts[rektel],27+11,11))
				oAcc:GoTo(nRecno)
				m_accid:=Str(oAcc:accid,-1)
				PrvYr_YtD:=oAcc:PrvYrYtD_deb - oAcc:PrvYrYtD_cre
				IF !lCondense.or.!PrvYr_YtD=0.or.!(oAcc:PrvPer_deb=oAcc:PrvPer_cre).or.!(oAcc:per_deb=oAcc:per_cre)
					IF Empty(aant_gev)
						if self:WhatDetails    // only then usefull totalization
							Totalize:=true
						endif
						if !cHeading==CurHeading
							self:oReport:PrintLine(@iLine,@iPage,cHeading,self:mainheading,12)
// 							self:oReport:PrintLine(@iLine,@iPage,' ',self:mainheading,1) 
							CurHeading:=cHeading
						endif
						self:oReport:PrintLine(@iLine,@iPage,iif(self:WhatDetails,r_heading[Bal_Ptr],d_depname[Dep_Ptr]),self:mainheading,11)
					ENDIF
					self:prAmounts(oAcc:category,oAcc:PrvYr_deb-oAcc:PrvYr_cre,PrvYr_YtD,;
						oAcc:PrvPer_deb-oAcc:PrvPer_cre,oAcc:per_deb-oAcc:per_cre,;
						oAcc:Yr_Bud,oAcc:Per_Bud,oAcc:PrvPer_bud+oAcc:Per_Bud,;
						1,if(self:Numbers,oAcc:AccNumber+self:TAB,"")+oAcc:description,r_heading,0.00,0.00,@iLine,@iPage)
					++aant_gev
				ENDIF
			NEXT
			IF Totalize .and. aant_gev>1 
				self:prtotaal(m_cat,@iLine,@iPage)
				if self:WhatDetails .and. self:WhoDetails
					self:prAmounts(m_cat,rd_BalPrvYr[Dep_Ptr,Bal_Ptr],;
						rd_BalPrvYrYtD[Dep_Ptr,Bal_Ptr],;
						rd_BalPrvPer[Dep_Ptr,Bal_Ptr],rd_BalPer[Dep_Ptr,Bal_Ptr],;
						rd_bud[Dep_Ptr,Bal_Ptr],rd_budper[Dep_Ptr,Bal_Ptr],rd_budytd[Dep_Ptr,Bal_Ptr],1,r_footer[Bal_Ptr],r_heading,0.00,0.00,@iLine,@iPage)
				elseif self:WhatDetails
					self:prAmounts(Upper(r_cat[Bal_Ptr]),r_balpryrtot[Bal_Ptr], r_balPrYrYtD[Bal_Ptr],;
						r_balPrvPer[Bal_Ptr],r_balPer[Bal_Ptr],r_bud[Bal_Ptr],r_budper[Bal_Ptr],r_budytd[Bal_Ptr],1,r_footer[Bal_Ptr],r_heading,0.00,0.00,@iLine,@iPage)
				endif
				self:oReport:PrintLine(@iLine,@iPage,' ',self:mainheading,1)
// 				self:oReport:PrintLine(@iLine,@iPage,' ',self:mainheading,0)
			ENDIF
			iLine:=0  && force bladskip		
		NEXT
	ENDIF 
	SetDecimalSep(Asc('.'))      //back to .

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
METHOD BalFishTot(Type as string,aTot as array) as array CLASS BalanceReport
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
			fAmnt2:=self:BalTot(aTot,typ2,aTot[Ind2,2],Ind2)
// 		else
// 			return null_array
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
ACCESS BalYears() CLASS BalanceReport
RETURN SELF:FieldGet(#BalYears)

ASSIGN BalYears(uValue) CLASS BalanceReport
SELF:FieldPut(#BalYears, uValue)
RETURN uValue

METHOD ButtonClick(oControlEvent) CLASS BalanceReport
	LOCAL oControl AS Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	if oControl:NameSym== #WhatDetails .or. oControl:NameSym== #WhoDetails  
		if !self:oDCWhatDetails:Checked .and. !self:oDCWhoDetails:Checked
			self:oDCind_explanation:Checked:=false
			self:oDCind_explanation:Hide()
			self:oDClCondense:Hide()
		else
			self:oDCind_explanation:Show()
		endif		
	elseIF oControl:NameSym == #ind_explanation
		IF self:oDCind_explanation:Checked
			self:oDClCondense:Show()
			//oDCind_accstmnt:Show()
		ELSE
			self:oDClCondense:Hide()
			self:oDCind_accstmnt:Hide()
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
	(DepartmentExplorer{self:OWNER,"Department",Str(self:WhoFrom,-1),self,cCurValue,"From Department"}):Show()
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
ACCESS ind_accstmnt() CLASS BalanceReport
RETURN SELF:FieldGet(#ind_accstmnt)

ASSIGN ind_accstmnt(uValue) CLASS BalanceReport
SELF:FieldPut(#ind_accstmnt, uValue)
RETURN uValue

ACCESS ind_explanation() CLASS BalanceReport
RETURN SELF:FieldGet(#ind_explanation)

ASSIGN ind_explanation(uValue) CLASS BalanceReport
SELF:FieldPut(#ind_explanation, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS BalanceReport 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"BalanceReport",_GetInst()},iCtlID)

oDCFixedText1 := FixedText{SELF,ResourceID{BALANCEREPORT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Year under review:",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{BALANCEREPORT_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Start with month:",NULL_STRING,NULL_STRING}

oDCBalYears := combobox{SELF,ResourceID{BALANCEREPORT_BALYEARS,_GetInst()}}
oDCBalYears:FillUsing(Self:GetBalYears( ))
oDCBalYears:HyperLabel := HyperLabel{#BalYears,NULL_STRING,"Balance Years",NULL_STRING}

oDCMONTHSTART := SingleLineEdit{SELF,ResourceID{BALANCEREPORT_MONTHSTART,_GetInst()}}
oDCMONTHSTART:FieldSpec := MONTHW{}
oDCMONTHSTART:HyperLabel := HyperLabel{#MONTHSTART,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMONTHSTART:Picture := "99"

oDCFixedText3 := FixedText{SELF,ResourceID{BALANCEREPORT_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"End with month:",NULL_STRING,NULL_STRING}

oDCMONTHEND := SingleLineEdit{SELF,ResourceID{BALANCEREPORT_MONTHEND,_GetInst()}}
oDCMONTHEND:FieldSpec := MONTHW{}
oDCMONTHEND:HyperLabel := HyperLabel{#MONTHEND,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMONTHEND:Picture := "99"

oDCmBalNumber := SingleLineEdit{SELF,ResourceID{BALANCEREPORT_MBALNUMBER,_GetInst()}}
oDCmBalNumber:HyperLabel := HyperLabel{#mBalNumber,NULL_STRING,"Number of Balancegroup",NULL_STRING}
oDCmBalNumber:TooltipText := "Enter number or name of required Top of balance structure"

oCCBalButton := PushButton{SELF,ResourceID{BALANCEREPORT_BALBUTTON,_GetInst()}}
oCCBalButton:HyperLabel := HyperLabel{#BalButton,"v","Browse in balance items",NULL_STRING}
oCCBalButton:TooltipText := "Browse in balance items"

oDCWhatDetails := CheckBox{SELF,ResourceID{BALANCEREPORT_WHATDETAILS,_GetInst()}}
oDCWhatDetails:HyperLabel := HyperLabel{#WhatDetails,"With details of subitems?",NULL_STRING,NULL_STRING}

oDCmDepartment := SingleLineEdit{SELF,ResourceID{BALANCEREPORT_MDEPARTMENT,_GetInst()}}
oDCmDepartment:HyperLabel := HyperLabel{#mDepartment,NULL_STRING,"From Who is it: Department",NULL_STRING}
oDCmDepartment:TooltipText := "Enter number or name of required Top of department structure"

oCCDepButton := PushButton{SELF,ResourceID{BALANCEREPORT_DEPBUTTON,_GetInst()}}
oCCDepButton:HyperLabel := HyperLabel{#DepButton,"v","Browse in Departments",NULL_STRING}
oCCDepButton:TooltipText := "Browse in Departments"

oDCWhoDetails := CheckBox{SELF,ResourceID{BALANCEREPORT_WHODETAILS,_GetInst()}}
oDCWhoDetails:HyperLabel := HyperLabel{#WhoDetails,"With details of subdepartments?",NULL_STRING,NULL_STRING}

oDCNumbers := CheckBox{SELF,ResourceID{BALANCEREPORT_NUMBERS,_GetInst()}}
oDCNumbers:HyperLabel := HyperLabel{#Numbers,"With Numbers of all items",NULL_STRING,NULL_STRING}
oDCNumbers:TooltipText := "Show all items with their numbers besid their name"

oDCind_explanation := CheckBox{SELF,ResourceID{BALANCEREPORT_IND_EXPLANATION,_GetInst()}}
oDCind_explanation:HyperLabel := HyperLabel{#ind_explanation,"With explanation",NULL_STRING,NULL_STRING}

oDClCondense := CheckBox{SELF,ResourceID{BALANCEREPORT_LCONDENSE,_GetInst()}}
oDClCondense:HyperLabel := HyperLabel{#lCondense,"Condense",NULL_STRING,NULL_STRING}
oDClCondense:TooltipText := "Suppress zero balanced accounts"

oDCind_accstmnt := CheckBox{SELF,ResourceID{BALANCEREPORT_IND_ACCSTMNT,_GetInst()}}
oDCind_accstmnt:HyperLabel := HyperLabel{#ind_accstmnt,"With account statements",NULL_STRING,NULL_STRING}
oDCind_accstmnt:TooltipText := "Show account statements per month for explanation accounts"

oCCOKButton := PushButton{SELF,ResourceID{BALANCEREPORT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{BALANCEREPORT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{BALANCEREPORT_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Down from:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{BALANCEREPORT_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Balance Items:",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{BALANCEREPORT_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Departments:",NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{BALANCEREPORT_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Down from:",NULL_STRING,NULL_STRING}

oDCGroupBox3 := GroupBox{SELF,ResourceID{BALANCEREPORT_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"Options",NULL_STRING,NULL_STRING}

SELF:Caption := "Balance Report"
SELF:HyperLabel := HyperLabel{#BalanceReport,"Balance Report",NULL_STRING,NULL_STRING}
SELF:EnableStatusBar(True)

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS lCondense() CLASS BalanceReport
RETURN SELF:FieldGet(#lCondense)

ASSIGN lCondense(uValue) CLASS BalanceReport
SELF:FieldPut(#lCondense, uValue)
RETURN uValue

METHOD ListBoxSelect(oControlEvent) CLASS BalanceReport
	LOCAL oControl AS Control
	LOCAL uValue as USUAL
	local aBal:={} as array
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControlEvent:NameSym==#BalYears
		uValue:=oControlEvent:Control:Value 
		GlBalYears:=FillBalYears()
		aBal:=GetBalYear(Val(SubStr(uValue,1,4)),Val(SubStr(uValue,5,2)))
		self:MONTHSTART:=aBal[2]
		self:MONTHEND:=aBal[4]
	ENDIF

	RETURN NIL

ACCESS mBalNumber() CLASS BalanceReport
RETURN SELF:FieldGet(#mBalNumber)

ASSIGN mBalNumber(uValue) CLASS BalanceReport
SELF:FieldPut(#mBalNumber, uValue)
RETURN uValue

ACCESS mDepartment() CLASS BalanceReport
RETURN SELF:FieldGet(#mDepartment)

ASSIGN mDepartment(uValue) CLASS BalanceReport
SELF:FieldPut(#mDepartment, uValue)
RETURN uValue

ACCESS MONTHEND() CLASS BalanceReport
RETURN SELF:FieldGet(#MONTHEND)

ASSIGN MONTHEND(uValue) CLASS BalanceReport
SELF:FieldPut(#MONTHEND, uValue)
RETURN uValue

ACCESS MONTHSTART() CLASS BalanceReport
RETURN SELF:FieldGet(#MONTHSTART)

ASSIGN MONTHSTART(uValue) CLASS BalanceReport
SELF:FieldPut(#MONTHSTART, uValue)
RETURN uValue

ACCESS Numbers() CLASS BalanceReport
RETURN SELF:FieldGet(#Numbers)

ASSIGN Numbers(uValue) CLASS BalanceReport
SELF:FieldPut(#Numbers, uValue)
RETURN uValue

METHOD OKButton( ) CLASS BalanceReport
* Check input data:
// IF !ValidateControls( SELF, SELF:AControls )
// 	RETURN
// END


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
aBal:=GetBalYear(Year(Today()-28),Month(Today()-28))
// self:MONTHSTART:=aBal[4]
// self:MONTHEND:=aBal[4]
self:MONTHSTART:=Month(Today()-28)
self:MONTHEND:=self:MONTHSTART
self:oDCBalYears:Value:=Str(aBal[1],4,0)+StrZero(aBal[2],2,0)
self:WhatDetails:=true
self:WhoDetails:=false 
self:lCondense:=true
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
		
METHOD prAmounts(pr_cat,pr_salvjtot,pr_balprvyrYtD,pr_salvrg,pr_sal,;
		pr_bud,pr_budper,pr_budytd,pr_level,pr_footer,pr_heading,pr_inc,pr_exp,iLine,iPage) CLASS BalanceReport
	//////////////////////////////////////////////////////////////////
	// Printing of amounts per category or account
	// pr_cat: INCOME, EXPENSE,ASSET, LIABILITY,SD 
	//////////////////////////////////////////////////////////////////
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
	Default(@pr_footer,null_string)

	* Print first preceding headings:
	// test skip page for complete heading: 
	self:oReport:PrintLine(@iLine,@iPage,nil,self:mainheading,Len(self:HeadingCache))
	FOR i:=1 to Len(self:HeadingCache)
		Hlevel:=self:HeadingCache[i,1]
		Bal_Ptr:=self:HeadingCache[i,2]
		self:oReport:PrintLine(@iLine,@iPage,iif(self:lXls,Replicate(self:TAB,Hlevel),Space(Hlevel*2))+pr_heading[bal_ptr],self:mainheading,0)
	NEXT 

	levelrest:=self:MaxLevel-pr_level 
	self:HeadingCache:={}

	IF pr_cat==INCOME .or.pr_cat==LIABILITY
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
	regel:=iif(self:lXls,iif(pr_level>0,Replicate(self:TAB,pr_level),'')+pr_footer+iif(levelrest>0,Replicate(self:TAB,levelrest),''),Pad(Space(pr_level*2)+pr_footer,BalColWidth))+self:TAB
	IF pr_cat==INCOME.or.pr_cat==EXPENSE
		if !self:SimpleDepStmnt
			IF mvjsaltot # 0
				vjtm_perc:=(mbalprvyrYtD)*100/mvjsaltot
				regel:=regel+Str(vjtm_perc,9,1)
			ELSE
				regel:=regel+Space(9)
			ENDIF
		endif
	ELSEIF pr_cat=='SD'
		regel:=regel+Str(mbalprvyrYtD,9,DecAantal)+self:TAB+Str(mvjsaltot,11,DecAantal)+self:TAB+;
			Str(-pr_inc,13,DecAantal)+self:TAB+Str(pr_exp,11,DecAantal)+self:TAB+Str(mvrgsal,11,DecAantal)+self:TAB+iif(msal<0,self:BoldOn+self:RedOn,'')+Str(msal,11,DecAantal)+iif(msal<0,self:Boldoff+self:RedOff,'')
	ELSE
		regel:=regel+Space(9)
	ENDIF
	IF pr_cat==LIABILITY.or.pr_cat==ASSET
		regel:=regel+self:TAB+Str(mbalprvyrYtD,11,decaantal)+'  '+self:TAB+Str(msal,11,decaantal)
	ENDIF
	IF pr_cat==INCOME.or.pr_cat==EXPENSE
		mtmsal:=mvrgsal+msal
		vrbr_perc:=0
		per_perc:=0
		tm_perc:=0
		IF pr_bud # 0
			vrbr_perc:=(mtmsal/pr_bud)*100
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
	oReport:PrintLine(@iLine,@iPage,regel,self:mainheading,0)
	RETURN
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS BalanceReport
	//Put your PreInit additions here
	RETURN NIL
METHOD prheading(heading_type as string,heading_category as string,dep_ptr as int,cDirect:="" as string,d_dep as array,d_parentDep as array,d_depname as array,;
r_balid as array,r_heading as array,r_footer as array,r_parentid  as array) CLASS BalanceReport 
//////////////////////////////////////////////////////////
// Compose Heading
// headingtype: string with name of type: summary, details
// heading_category: EXPENSE, INCOME, ASSET, LIABILITY or DEP (=department)
//  
//////////////////////////////////////////////////////////
LOCAL Heading:={} as ARRAY
LOCAL inscription as STRING
LOCAL pntr as int
LOCAL cDepName as STRING

IF heading_category==EXPENSE.or.heading_category==INCOME
	inscription:=self:cInscriptionInEx
ELSEIF heading_category==ASSET .or.heading_category==LIABILITY
	inscription:=self:cInscriptionAsLi
elseif  heading_category=='DEP'
	inscription:=cInscriptionDep
ENDIF
IF self:WhatDetails
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
	IF Empty(self:WhatFrom)
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
	if ! heading_category=='DEP'
		heading_category:="SD"
	endif
ENDIF

Heading:={iif(Empty(self:addheading),cDepName+cDirect,self:addheading)+Replicate(self:TAB,8),;
+ BoldOn+YellowOn+inscription+" "+Trim(heading_type)+'  '+self:cFrom+;
' '+maand[MONTHSTART]+self:cTo + maand[MonthEnd]+BoldOff+YellowOff,;
self:cYear+oDCBalYears:TextValue,' ',;
iif(self:lXls.and.self:Numbers,self:TAB,"")+self:cDescription+;
iif(self:SimpleDepStmnt,"",self:TAB+self:cPrvYrYTD+Space(6)+self:TAB+self:TAB+;
self:cCurPeriod+self:TAB)+;
IF(heading_category=EXPENSE.or.heading_category=INCOME.or.heading_category='DEP',self:TAB+self:cYtD+self:TAB+self:TAB+self:cFullyear,''),;
iif(lXls,Replicate(self:TAB,self:MaxLevel+iif(self:Numbers,1,0)),Space (BalColWidth))+;
iif(heading_category='SD',;
	self:TAB+self:cSurPlus+self:TAB+self:cClsBal+self:TAB+;
	self:cIncomeL+self:TAB+self:cExpenseL+;
	self:TAB+PadL(self:cSurPlus,11)+self:TAB+self:cClsBal,'')+;
iif(heading_category=ASSET.or.heading_category=LIABILITY,;
	self:TAB+Space(9) +;
	self:TAB+self:cAmount+self:TAB+PadL(self:cAmount,13),'')+;
iif(heading_category=EXPENSE.or.heading_category=INCOME.or.heading_category='DEP',;
	self:TAB+iif(self:SimpleDepStmnt,"",PadL(self:cBudget,9) +;
	self:TAB+self:cAmount+self:TAB+PadL(self:cAmount,13)+;
	self:TAB+self:cBudget)+;
	self:TAB+self:cAmount+self:TAB+self:cBudget+;
	self:TAB+PadL(self:cAmount,11)+self:TAB+self:cBudget,''),;
Replicate(CHR(95),TotalWidth),' '} 
// if !self:WhoDetails .and.!self:WhoDetails  
if !self:WhatDetails  
	// no need for heading, only summary line
// 	ADel(Heading,4)
/*	ADel(Heading,3)
	ADel(Heading,2)
	Asize(Heading,len(Heading)-2)  */ 
	ADel(Heading,1)
	ASize(Heading,Len(Heading)-1) 	
endif	
// if !Empty(self:addheading)
// 	asize(Heading,len(Heading)+1)
// 	AIns(Heading,1)
// 	Heading[1]:= self:addheading 
// endif
	
//Replicate('-',TotalWidth),' '}

RETURN(Heading)
METHOD ProcessDepBal(p_depptr as int,lDirect as logic, dLevel as int,d_netnum as array,d_depname as array,d_parentdep as array,d_dep as array,;
		r_cat as array,r_balpryrtot ref array,r_balPrYrYtD ref array,r_balPrvPer ref array,r_balPer ref array,r_indmain as array,r_parentid as array,r_heading as array,r_footer as array,r_bud ref array,r_budper ref array,r_budytd ref array,r_balid as array,;
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
			self:mainheading:=self:prheading(self:cSummary,r_cat[TopWhatPtr],p_depptr,if(lDirect,"("+self:cDirectText+")",""),d_dep,d_parentdep,d_depname,;
				r_balid,r_heading,r_footer,r_parentid)
			IF self:WhatDetails.and.(self:WhoDetails.or.d_dep[p_depptr]==self:WhoFrom)
				iLine:=0
				self:oReport:Beginreport:=self:Beginreport
			ENDIF
			TopWhatPtr:=self:SUBBALITEM(TopWhatPtr,0,p_depptr,lDirect,dLevel,r_parentid,r_indmain,r_heading,r_footer,@r_balpryrtot,;
				@r_balPrYrYtD,@r_balPrvPer,@r_balPer,@r_bud,@r_budper,@r_budytd,r_cat,r_balid,d_netnum,d_depname,@aTot,@aTotprv,@iLine,@iPage)
		ENDDO
	ELSE
		self:mainheading:=self:prheading(self:cSummary,r_cat[1],p_depptr,,d_dep,d_parentdep,d_depname,;
			r_balid,r_heading,r_footer,r_parentid)
		IF self:WhatDetails
			* Force pageskip:
			iLine:=0
			oReport:Beginreport:=SELF:BeginReport
		ENDIF
		self:SUBBALITEM(1,0,p_depptr,lDirect,dLevel,r_parentid,r_indmain,r_heading,r_footer,@r_balpryrtot,;
			@r_balPrYrYtD,@r_balPrvPer,@r_balPer,@r_bud,@r_budper,@r_budytd,r_cat,r_balid,d_netnum,d_depname,@aTot,@aTotprv,@iLine,@iPage)
	ENDIF
	RETURN
METHOD prtotaal(tot_soort,iLine,iPage) CLASS BalanceReport
* Printing of totals:
   oReport:PrintLine(@iLine,@iPage,iif(self:lXls.and.self:Numbers,self:TAB,"")+ Space(iif(self:lXls,24,BalColWidth))+iif(self:lXls,Replicate(self:TAB,self:MaxLevel),"")+self:TAB+;
   iif(tot_soort==EXPENSE.or. tot_soort==INCOME.or. tot_soort=='SD',iif(self:SimpleDepStmnt,"",'---------'),Space(9))+;
   iif(self:SimpleDepStmnt,"",self:TAB+'-----------  '+self:TAB+'-----------')+;
   iif(tot_soort==EXPENSE.or.tot_soort==INCOME,;
      iif(self:SimpleDepStmnt,"",self:TAB+'--------')+self:TAB+'-----------'+self:TAB+'--------'+self:TAB+'-----------'+self:TAB+'--------',;
	iif(tot_soort=='SD',self:TAB+'-----------'+self:TAB+'-----------'+self:TAB+'-----------','')),self:mainheading,2) 
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
		self:cCurDep:="0:"+sEntity+" "+sLand
		self:mDepartment:=self:cCurDep
		self:oDCmDepartment:TextValue:=self:cCurDep
	ELSE
		oDep:=SQLSelect{"select deptmntnbr,descriptn from department where depid='"+Str(self:WhoFrom,-1)+"'",oConn}
		if oDep:RecCount>0  
			self:cCurDep:=AllTrim(oDep:deptmntnbr)+":"+oDep:descriptn
			self:mDepartment:=self:cCurDep
			self:oDCmDepartment:TextValue:=self:cCurDep
		ENDIF
	ENDIF
	//	ENDIF
	RETURN
METHOD SUBBALITEM(Bal_Ptr as int,level as int,Dep_Ptr as int,lDirect as logic,dLevel as int,r_parentid as array,r_indmain as array,r_heading as array,;
r_footer as array,r_balpryrtot ref array,r_balPrvYrYtD ref array,r_balPrvPer ref array,r_balPer ref array,r_bud ref array,r_budper ref array,;
r_budytd ref array,r_cat as array,r_balid as array,d_netnum as array,d_depname as array,aTot ref array,aTotprv ref array,;
iLine ref int,iPage ref int) as int CLASS BalanceReport
	* Recursive processing of a balance item with its subbalance items
	*
	LOCAL TotalFound,SubBalPtr, CachePtr,kap_num AS INT
	LOCAL m_soort, pr_oms AS STRING
	LOCAL openfund, surplusvj,surplus,clbalvj,clbal AS FLOAT
	LOCAL SDfound:=FALSE as LOGIC
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
				*			oReport:PrintLine(@iLine,@iPage,Space(level*2)+r_heading[bal_ptr],self:mainheading,0)
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
				SubBalPtr:=self:SUBBALITEM(SubBalPtr,level+1,Dep_Ptr,lDirect,dLevel,r_parentid,r_indmain,r_heading,r_footer,@r_balpryrtot,;
					@r_balPrvYrYtD,@r_balPrvPer,@r_balPer,@r_bud,@r_budper,@r_budytd,r_cat,r_balid,d_netnum,d_depname,@aTot,@aTotprv,@iLine,@iPage)
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
					r_balPer[bal_ptr],r_bud[bal_ptr],r_budper[bal_ptr],r_budytd[bal_ptr],level,pr_oms,r_heading,0.00,0.00,@iLine,@iPage)
			ENDIF
			IF	TotalFound>1 && extra space after total
				oReport:PrintLine(@iLine,@iPage,' ',self:mainheading,0)
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
				SDfound:=true
				//ENDIF
			ENDIF
			IF !SDfound
				// try first time:
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
					SDfound:=true
					//ENDIF
				ENDIF
			ENDIF
			IF SDfound
				ASort(aTot,,,{|x, y| x[1] < y[1] .or. (x[1]=y[1] .and. x[2] <= y[2])})
				ASort(aTotprv,,,{|x, y| x[1] < y[1] .or. (x[1]=y[1] .and. x[2] <= y[2])})
				IF !Empty(kap_num) .and. !IsNil(r_balPer[kap_num]).and.!IsNil(r_balpryrtot[kap_num])
					//				clbalvj:=-(r_balpryrtot[kap_num]-surplusvj)
					clbalvj:=Round(-r_balpryrtot[kap_num] + iif( self:PrvYearNotClosed,surplusvj,0),DecAantal)
					clbal:=-(r_balPer[kap_num]-surplus)
					IF SELF:showopeningclosingfund
						oReport:PrintLine(@iLine,@iPage,' ',self:mainheading,2)
						oReport:PrintLine(@iLine,@iPage,self:cOpeningBal+Str(clbalvj,11,DecAantal),self:mainheading,0)
						oReport:PrintLine(@iLine,@iPage,self:BoldOn+iif(clbal<0,RedOn,GreenOn)+Pad(iif(clbal<0,self:cNegative,self:cPositive)+Space(1)+self:cClosingBal,BalColWidth+iif(self:SimpleDepStmnt,2,46))+Str(clbal,11,DecAantal)+iif(clbal<0,RedOff,GreenOff)+BoldOff,self:mainheading,0)
					ENDIF
				ENDIF
				IF !SELF:showopeningclosingfund
					// determine highest level Income and expenses:
					fAmnt:=SELF:BalFishTot("I",aTot)
					fInc:=fAmnt[1]
					fExp:=fAmnt[2]
					IF !Empty(kap_num) .and. !IsNil(r_balPer[kap_num]).and.!IsNil(r_balpryrtot[kap_num]) 
						// clbal and clbalvj already known
					else 
						fAmnt:=self:BalFishTot("B",aTot)
						clbal:=Round(fAmnt[1] - fAmnt[2] + surplus, DecAantal)
						fAmnt:=self:BalFishTot("B",aTotprv)
						clbalvj:=Round(fAmnt[1] - fAmnt[2] + iif( self:PrvYearNotClosed,surplusvj,0),DecAantal)
					endif
					pr_oms:=if(dLevel=0,"",Space(dLevel*2))+if(lDirect,self:cDirectOn+" ","")+d_depname[Dep_Ptr] 
					self:prAmounts("SD",clbalvj,surplusvj,;
						surplus,clbal,r_bud[Bal_Ptr],r_budper[Bal_Ptr],r_budytd[Bal_Ptr],level,pr_oms,r_heading,fInc,fExp,@iLine,@iPage)
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	RETURN(bal_ptr)
METHOD SubDepartment(p_depptr as int,level as int,d_netnum as array,d_indmaindep as array,d_depname as array,d_parentdep as array,d_dep as array,;
		r_cat as array,r_balpryrtot ref array,r_balPrYrYtD ref array,r_balPrvPer ref array,r_balPer ref array,r_indmain as array,r_parentid as array,;
		r_heading as array,r_footer as array,r_balnbr as array,r_balid as array,r_bud ref array,r_budper ref array,r_budytd ref array,;
		rd_salvjtot as array,rd_BalPrvYrYtD as array,rd_salvrg as array,rd_salper as array,rd_bud as array,rd_budper as array,rd_budytd as array,iLine ref int,iPage ref int) as int CLASS BalanceReport
	* Recursive processing of a department with its subdeparments
	*
	LOCAL TotalFound,subDepPtr AS INT
	LOCAL TopWhatPtr AS INT
	IF d_indmaindep[p_depptr]
		IF self:WhoDetails
			IF !self:WhatDetails
				self:oReport:PrintLine(@iLine,@iPage,Space(level*2)+d_depname[p_depptr],self:mainheading,0)
			ENDIF
			* test if accounts record directly to this department:
			IF AScan( rd_salvjtot[p_depptr], {|x| !IsNil(x)})>0 .or.;
					AScan( rd_BalPrvYrYtD[p_depptr], {|x| !IsNil(x)})>0 .or.;
					AScan( rd_salvrg[p_depptr], {|x| !IsNil(x)})>0 .or.;
					AScan( rd_salper[p_depptr], {|x| !IsNil(x)})>0
				* Process directly recorded amounts:
				SELF:ProcessDepBal(p_depptr,TRUE,level+1,d_netnum,d_depname,d_parentDep,d_dep,;
					r_cat,@r_balpryrtot,@r_balPrYrYtD,@r_balPrvPer,@r_balPer,r_indmain,r_parentid,r_heading,r_footer,@r_bud,@r_budper,@r_budytd,r_balid,;
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
					r_cat,@r_balpryrtot,@r_balPrYrYtD,@r_balPrvPer,@r_balPer,r_indmain,r_parentid,;
					r_heading,r_footer,r_balnbr,r_balid,@r_bud,@r_budper,@r_budytd,;
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
					self:oReport:PrintLine(@iLine,@iPage,' ',self:mainheading,0)
				ENDIF
				self:prtotaal("SD",@iLine,@iPage)
			ENDIF
			IF (!d_indmaindep[p_depptr] .or. TotalFound>1)
				SELF:ProcessDepBal(p_depptr,FALSE,level,d_netnum,d_depname,d_parentDep,d_dep,;
					r_cat,@r_balpryrtot,@r_balPrYrYtD,@r_balPrvPer,@r_balPer,r_indmain,r_parentid,r_heading,r_footer,@r_bud,@r_budper,@r_budytd,r_balid,;
					rd_salvjtot,rd_BalPrvYrYtD,rd_salvrg,rd_salper,rd_bud,rd_budper,rd_budytd,@iLine,@iPage)
			ENDIF
			IF TotalFound>1 && extra space after total
				oReport:PrintLine(@iLine,@iPage,' ',self:mainheading,0)
			ENDIF
		ELSE
			SELF:ProcessDepBal(p_depptr,FALSE,level,d_netnum,d_depname,d_parentDep,d_dep,;
				r_cat,@r_balpryrtot,@r_balPrYrYtD,@r_balPrvPer,@r_balPer,r_indmain,r_parentid,r_heading,r_footer,@r_bud,@r_budper,@r_budytd,r_balid,;
				rd_salvjtot,rd_BalPrvYrYtD,rd_salvrg,rd_salper,rd_bud,rd_budper,rd_budytd,@iLine,@iPage)
		ENDIF
	ENDIF
	RETURN(p_depptr)
METHOD SubNetDepartment(p_depptr as int,d_parentdep as array,d_dep as array,d_PLdeb ref array,d_PLcre ref array,d_netnum as array,;
r_balid as array,rd_BalPer ref array,rd_BalPrvYr ref array,rd_BalPrvYrYtD ref array,rd_BalPrvPer ref array,rd_bud ref array,rd_budper ref array,;
rd_budytd ref array,d_PrfLssPrYr as array) as void pascal CLASS BalanceReport
* Recursive processing of netasset balances of a department with its subdeparments
*
LOCAL subDepPtr,net_ptr as int

DO WHILE true
	subDepPtr:=AScan(d_parentdep,d_dep[p_depptr],subDepPtr+1)
	IF Empty(subDepPtr)
		exit
	ELSE
		self:SubNetDepartment(subDepPtr,d_parentdep,d_dep,@d_PLdeb,@d_PLcre,d_netnum,r_balid,@rd_BalPer,@rd_BalPrvYr,@rd_BalPrvYrYtD,@rd_BalPrvPer,;
		@rd_bud,@rd_budper,@rd_budytd,d_PrfLssPrYr)
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
ACCESS WhatDetails() CLASS BalanceReport
RETURN SELF:FieldGet(#WhatDetails)

ASSIGN WhatDetails(uValue) CLASS BalanceReport
SELF:FieldPut(#WhatDetails, uValue)
RETURN uValue

ACCESS WhoDetails() CLASS BalanceReport
RETURN SELF:FieldGet(#WhoDetails)

ASSIGN WhoDetails(uValue) CLASS BalanceReport
SELF:FieldPut(#WhoDetails, uValue)
RETURN uValue

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
STATIC DEFINE BALANCEREPORT_IND_EXPLANATION := 113 
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
RESOURCE DeptReport DIALOGEX  26, 24, 404, 227
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
	CONTROL	"Required Action:", DEPTREPORT_SENDINGMETHOD, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 12, 164, 196, 62
	CONTROL	"Print", DEPTREPORT_PRINTALL, "Button", BS_AUTORADIOBUTTON|WS_CHILD|WS_OVERLAPPED|0x1000L, 19, 176, 181, 11
	CONTROL	"Save seperate printfile per department", DEPTREPORT_SEPARATEFILE, "Button", BS_AUTORADIOBUTTON|WS_CHILD|WS_OVERLAPPED|0x1000L, 19, 192, 181, 11
	CONTROL	"Send separate printfile by email to each department", DEPTREPORT_SEPARATEFILEMAIL, "Button", BS_AUTORADIOBUTTON|WS_CHILD|WS_OVERLAPPED|0x1000L, 19, 208, 181, 11
	CONTROL	"Simplified report", DEPTREPORT_SIMPLEDEPSTMNT, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 84, 125, 80, 11
	CONTROL	"", DEPTREPORT_SELECTEDCNT, "Static", WS_CHILD, 312, 11, 64, 9
	CONTROL	"Show details of gifts", DEPTREPORT_GIFTDETAILS, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 84, 140, 80, 11
END

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
	PROTECT oDCGiftDetails AS CHECKBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	instance FromDep 
	instance BalYears 
	instance MONTHSTART 
	instance MONTHEND 
	instance BeginReport 
	instance SubSet 
	instance Footnotes 
	instance SendingMethod 
	export YEARSTART,YEAREND as int
	PROTECT BalSt, BalEnd, CurSt, CurEnd as int 
	protect oGftRpt as GiftsReport
* Options for report type:
PROTECT mDepartment AS STRING
	EXPORT cFromDepName AS STRING
	EXPORT oReport AS PrintDialog
	EXPORT oBalReport AS BalanceReport
	PROTECT oTransMonth AS AccountStatements
	Export oGiftRpt as GiftsReport
	PROTECT oPPcd as SQLSelect 
	export oMapi as MAPISession
	export oEMLFrm as eMailFormat 
	export Country as STRING 
	export lDebCreMerge:=true as logic 
	export mailsubject as string   // subject of emailmessage 
	export lNoBalance as logic   // skip balancesheet 
	export WhatDetails:=true as logic 
	export showopeningclosingfund:=true as logic


	declare method RegDepartment,DepartmentStmntPrint
	
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
	// 	IF ValidateControls( SELF, SELF:AControls )
	IF filename == "SEPARATEFILEMAIL"
		IF !IsMAPIAvailable()
			(ErrorBox{self:Owner,"No email client available or no interface to it"}):show()
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

		self:oReport := PrintDialog{,self:oLan:WGet("Dept statements")+" "+Str(self:YEAREND,4,0)+"-"+StrZero(self:MONTHEND,2),,145,DMORIENT_LANDSCAPE,iif(filename = "SEPARATEFILE",'doc','txt')}
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
	// 	ENDIF
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

METHOD DepartmentStmntPrint(aDep as array,nRow:=0 ref int,nPage:=0 ref int) as logic CLASS DeptReport 
	// printing statement of departments aDep
	LOCAL lPrintFile, lSkip, lFirst, lFirstInMonth as LOGIC
	LOCAL regtel,medtel,GClen,i,j as int
	LOCAL PeriodText, mailname as STRING
	local nDep as int
	LOCAL  DueRequired,GiftsRequired,AddressRequired,RepeatingPossible as LOGIC
	LOCAL mailcontent as STRING
	LOCAL oSelpers as Selpers
	LOCAL oMapi as MAPISession
	LOCAL oRecip1,oRecip2 as MAPIRecip
	LOCAL aMailDepartment:={} as ARRAY
	LOCAL cFileName as USUAL, oFileSpec as FileSpec
	LOCAL aASS,aDepAcc,aDepAccD,aAccGift as ARRAY
	LOCAL cAccs as string 
	local dim aLastname[2] as string
	local dim aFullname[2] as string
	local dim aEmail[2] as string
	local dim aPersid[2] as int
	LOCAL FileInit, cDepName as STRING 
	local oBal as SQLSelect 
	local nCurFifo,i as int
	local addHeading as string 
	local oAcc,oDep,oAccAss,oTrans, oTransAss as SQLSelect
	local cLastName,cFileNameBasic as string 
	local mDepNumber,me_hbn as string
	LOCAL myLang:=Alg_taal as STRING
	local aAssmntAmount:=ArrayNew(4,12) as array
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
	LOCAL startdate,enddate,startdategifts as date

	PeriodText:=Str(self:YEARSTART,4)+Space(1)+maand[self:MONTHSTART]+Space(1)+oLan:RGet('up incl')+Space(1)+Str(self:YEAREND,4)+Space(1)+maand[self:MonthEnd]
	//TotalWidth=137
	lPrintFile:=(self:oReport:Destination=="File")
	cFileNameBasic:=self:oReport:ToFileFS:FileName
	startdate:=SToD(Str(self:YEARSTART,4)+StrZero(self:MONTHSTART,2)+'01') 
	enddate:=SToD(Str(self:YEAREND,4)+StrZero(self:MonthEnd,2)+StrZero(MonthEnd(self:MonthEnd,self:YEAREND),2))
	startdategifts:=SToD(Str(self:YEARSTART,4)+'0101')
	self:Pointer := Pointer{POINTERHOURGLASS}
	self:STATUSMESSAGE("Collecting data for the report, please wait...") 
	IF self:oGftRpt == null_object
		self:oGftRpt:=GiftsReport{}
		self:oGftRpt:Country:=self:Country
	ENDIF		

	IF oBalReport==null_object
		oBalReport:=BalanceReport{}
		self:oBalReport:ind_accstmnt:=FALSE
		self:oBalReport:ind_explanation:=FALSE
		self:oBalReport:WhatDetails:=self:WhatDetails
		self:oBalReport:WhoDetails:=FALSE
		self:oBalReport:WhatFrom:=0
		self:oBalReport:showopeningclosingfund:=self:showopeningclosingfund	
	ENDIF 
	IF	self:SendingMethod="SeperateFile"
		self:oBalReport:SendToMail:=true
	else
		self:oBalReport:SendToMail:=false	
	ENDIF
	self:oBalReport:BalYears:=self:BalYears
	self:oBalReport:lCondense:=true
	self:oBalReport:MonthEnd:=self:MonthEnd
	self:oBalReport:MONTHSTART:=self:MONTHSTART
	self:oBalReport:SimpleDepStmnt:=	self:SimpleDepStmnt
	self:oBalReport:oReport:=self:oReport
	self:oBalReport:BeginReport:=self:BeginReport
	myLang:=Alg_taal
	
	//DO WHILE oDep:DEPTMNTNBR <= ToDep .and. !oDep:EOF
	oDep:=SQLSelect{"select d.descriptn,d.deptmntnbr,d.depid,d.assacc1,d.assacc2,d.assacc3,d.persid,d.persid2,"+ ;
		"group_concat(distinct a.accnumber,'#',a.description,'#',cast(a.giftalwd as char),'#',if(a.accid=d.netasset,'1','0'),'#',cast(a.accid as char) order by a.accnumber separator '%%') as depaccs "+;
		",p1.lastname as lastname1,p1.email as email1,"+SQLFullName(0,"p1")+" as fullname1,p2.lastname as lastname2,p2.email as email2,"+SQLFullName(0,"p2")+" as fullname2 "+;
		",m.mbrid,m.persid as mbrpersid,m.householdid,m.homepp,m.contact,m.rptdest,group_concat(distinct cast(ma.accid as char) separator ',') as assacc "+ ; 
	",mc.lastname as lastnamemc,mc.email as emailmc,"+SQLFullName(0,"mc")+" as fullnamemc,mm.lastname as lastnamemm,mm.email as emailmm,"+SQLFullName(0,"mm")+" as fullnamemm "+;
		"from account a,department d left join person p1 on(p1.persid=d.persid) left join person p2 on (p2.persid=d.persid2) "+;
		"left join member m on (m.depid=d.depid) left join memberassacc ma on (ma.mbrid=m.mbrid) left join person mm on (mm.persid=m.persid) left join person mc on (mc.persid=m.contact) " +;
		"where a.department=d.depid and d.depid in ("+Implode(aDep,",")+") group by d.depid order by d.descriptn",oConn}
	if oDep:RecCount<1
		if !Empty(oDep:Status)
			LogEvent(self,"Error:"+oDep:ErrInfo:ErrorMessage+CRLF+"statement:"+oDep:SQLString,"LogErrors") 
			ErrorBox{self,"Error:"+oDep:ErrInfo:ErrorMessage}:Show()
		endif
		return false
	endif 
	SetDecimalSep(Asc(DecSeparator)) 
	nDep:=0

	do WHILE !oDep:Eof
		nDep:=oDep:DepId
		cDepName:=CleanFileName(StrTran(oDep:DESCRIPTN,'.',' ')) 
		mDepNumber:=oDep:DEPTMNTNBR
		nCurFifo:=Len(self:oReport:oPrintJob:aFIFO)
		me_hbn:=AllTrim(Transform(oDep:householdid,""))
		IF oDep:HOMEPP!=sEntity
			Alg_taal:="E"
		ENDIF
		// 		addHeading:=self:oLan:RGet("Department")+Space(1)+cDepName+Space(1)+mDepNumber+Space(1)+iif(empty(me_hbn),'',' HOUSECD:'+me_hbn+space(1))+self:Country
		addHeading:=Str(self:YEARSTART,4)+Space(1)+iif(self:MONTHSTART # self:MonthEnd,oLan:RGet(MonthEn[self:MONTHSTART],,"!")+Space(1)+oLan:RGet("up incl")+Space(1),"")+oLan:RGet(MonthEn[self:MonthEnd],,"!")+Space(2);
			+self:oLan:RGet("Department")+Space(1)+cDepName+Space(1)+mDepNumber+Space(1)+iif(Empty(me_hbn),'',' HOUSECD:'+me_hbn+Space(1)+self:oLan:RGet("Currency")+':'+sCurr+Space(1))+self:Country
		IF SendingMethod="SeperateFile" 
			// rename filename to add department name:                   
			self:oReport:ToFileFS:FileName:= cFileNameBasic+Space(1)+cDepName
			nRow := 0
			// 		FileInit:=MEMBER_START+cDepName
		ENDIF
		FileInit:=""
		if !self:lNoBalance
			self:STATUSMESSAGE("Collecting data for for "+cDepName+", please wait...")
			self:oBalReport:WhoFrom:=oDep:DepId
			self:oBalReport:iPage:=nPage 
			self:oBalReport:addHeading:=addHeading
			* Insert departmentname if print to seperate file:
			self:oBalReport:BalancePrint(FileInit) 
		endif
		self:STATUSMESSAGE("Printing Accountstatements for "+cDepName+", please wait...")

		IF self:oTransMonth==null_object
			self:oTransMonth:=AccountStatements{90}
			self:oTransMonth:lDebCreMerge:=self:lDebCreMerge 
		ENDIF
		self:oTransMonth:oReport:=self:oReport
		self:oTransMonth:SendingMethod:=self:SendingMethod
		self:oTransMonth:BeginReport:=self:BeginReport
		self:oTransMonth:GiftDetails:=self:GiftDetails


		// Print accountstatements of all department accounts:
		nPage:=self:oBalReport:iPage
		// 		aAcc:={}
		aAccGift:={}
		aDepAccD:={}
		nRow:=0
		aDepAcc:=Split(Hex2Str(oDep:depaccs),'%%') 
		AEval(aDepAcc,{|x|AAdd(aDepAccD,Split(x,'#'))})
		ASort(aDepAccD,,,{|x,y|x[5]<=y[5]}) 
		cAccs:=''
		for i:=1 to Len(aDepAccD)
			// 			AAdd(aAcc,aDepAccD[i,1])  //ACCNUMBER 
			cAccs+=iif(Empty(cAccs),'',',')+ aDepAccD[i,5]  // accid
			if aDepAccD[i,3]=='1' .or. aDepAccD[i,4]='1'   //Giftalwd==1 .or.netasset='1'
				AAdd(aAccGift,Val(aDepAccD[i,5]))  //accid
			endif
		next
		// 		ASort(aAcc,,,{|x,y|x<=y})
		self:STATUSMESSAGE("Printing Accountstatements for "+cDepName+", please wait...")
		oAcc:=SqlSelect{"select accid,accnumber,description,a.currency,a.giftalwd,b.category from account a, balanceitem b where a.balitemid=b.balitemid and a.accid in ("+;
			cAccs+") order by accnumber",oConn} 
		oAcc:Execute()
		oTrans:=SqlSelect{UnionTrans('select t.docid,t.transid,t.seqnr,t.accid,a.accnumber,t.persid,t.dat,t.deb,t.cre,t.debforgn,t.creforgn,t.fromrpp,bfm,t.opp,t.gc,t.description '+;
			'from transaction t,account a where a.accid=t.accid and'+;
			" t.dat>='"+SQLdate(startdategifts)+"' and t.dat<='"+SQLdate(enddate)+"'"+;
			" and t.accid in ("+cAccs+")")+" order by a.accnumber,t.dat,t.transid,t.seqnr",oConn}
		oTrans:Execute() 
		aGiversdata:={}
		for i:=1 to 4
			for j:=1 to 12
				aAssmntAmount[i,j]:=0.00
			next
		next

		do while !oAcc:Eof
			if AScan(aAccGift,oAcc:accid)>0
				self:oTransMonth:MonthPrint(oAcc,oTrans,self:YEARSTART,self:MONTHSTART,self:YEAREND,self:MonthEnd,@nRow,@nPage,addHeading,self:oLan,aGiversdata,aAssmntAmount)
			else
				self:oTransMonth:MonthPrint(oAcc,oTrans,self:YEARSTART,self:MONTHSTART,self:YEAREND,self:MonthEnd,@nRow,@nPage,addHeading,self:oLan)
			endif
			oAcc:Skip()
		enddo
		// 		NEXT
		
		*	If associated accounts for this department, print also corresponding accountstatements for this month:
		IF !Empty(oDep:ASSACC1).or.!Empty(oDep:ASSACC2) .or.!Empty(oDep:ASSACC3) .or.!Empty(oDep:assacc)
			nRow:=0  && force page skip
			if !Empty(oDep:assacc)    // incase of member department, print associated accounts of the member
				aASS:=Split(oDep:assacc,',')
			else
				aASS:={oDep:ASSACC1,oDep:ASSACC2,oDep:ASSACC3}      // otherwise of the department
			endif
			oAccAss:=SqlSelect{"select accnumber,accid,description,currency,a.giftalwd,b.category from account a,balanceitem b where a.balitemid=b.balitemid and accid in ("+Implode(aASS,"','")+")",oConn}
			oAccAss:Execute()
			oTransAss:=	SqlSelect{UnionTrans('select t.docid,t.transid,t.accid,t.persid,t.dat,t.deb,t.cre,t.debforgn,t.creforgn,t.fromrpp,bfm,t.opp,t.gc,t.description '+;
				'from transaction t where t.dat>="'+SQLdate(startdate)+'" and t.dat<="'+SQLdate(enddate)+'"'+;
				" and t.accid in ("+Implode(aASS,",")+") order by t.accid,t.dat"),oConn}
			oTransAss:Execute() 
			Do While !oAccAss:Eof
				self:oTransMonth:MonthPrint(oAccAss,oTransAss,self:YEARSTART,self:MONTHSTART,self:YEAREND,self:MonthEnd,@nRow,@nPage,addHeading+Space(1)+oLan:RGet("Associated",,"@!"),self:oLan,,,"accid")
				nRow:=0  && force page skip
				oAccAss:Skip()
			enddo
		ENDIF
		// Print gift reports for each gift allowed account:
		self:STATUSMESSAGE("Printing Gift reports for "+cDepName+", please wait...")
		nRow:=0  // force page skip
		// 			endif
		if Len(aAccGift)>0  
			self:oGftRpt:GiftsOverview(self:YEAREND,self:MonthEnd,Footnotes, aGiversdata,aAssmntAmount,self:oReport, oDep:DEPTMNTNBR+Space(1)+oDep:DESCRIPTN,me_hbn,@nRow,@nPage)
		endif
		if	nCurFifo==Len(self:oReport:oPrintJob:aFIFO) .and.nPage=0 .and.nRow=0
			// nothing printed:
			self:oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("No financial activity in given period"),{self:oLan:RGet("Department")+Space(1)+cDepName+":"+PeriodText},2)
		endif
		IF lPrintFile.and.self:SendingMethod="SeperateFile" 
			// separate files:
			cFileName:=self:oReport:prstart() // save separate file
			// Proces e-mail:
			IF self:SendingMethod=="SeperateFileMail"
				if !Empty(oDep:mbrid).or.!Empty(oDep:persid).or.!Empty(oDep:persid2)
					AAdd(aMailDepartment,{oDep:RECNO,cFileName})
				endif
			ENDIF
		endif
		oDep:Skip()
		Alg_taal:=myLang
	ENDDO
	SetDecimalSep(Asc('.'))
	// 	IF !lPrintFile.or.Empty(self:SendingMethod)
	// 		self:oReport:prstart()    
	// 	endif

	IF self:SendingMethod=="SeperateFileMail" 
		oSelpers:=Selpers{self,,}
		oSelpers:AnalyseTxt(self:oEMLFrm:Template,@DueRequired,@GiftsRequired,@AddressRequired,@RepeatingPossible,1)
		oSelpers:ReportMonth:=PeriodText
		FOR i:=1 to Len(aMailDepartment)
			self:STATUSMESSAGE("Placing mail messages in outbox of mailing system, please wait...") 
			oDep:GoTo(aMailDepartment[i,1])
			if Empty(oDep:mbrid)
				// normal department
				aLastname[1]:=oDep:Lastname1
				aFullname[1]:=oDep:fullname1
				aEmail[1]:=oDep:email1 
				aPersid[1]:=oDep:persid
				aLastname[2]:=oDep:Lastname2
				aFullname[2]:=oDep:fullname2
				aEmail[2]:=oDep:email2
				aPersid[2]:=oDep:persid2
			else
				// member department 
				if oDep:rptdest<>1      // Destination 0: member, 1: contact, 2: member+contact
					aLastname[1]:=oDep:Lastnamemm     // member
					aFullname[1]:=oDep:fullnamemm
					aEmail[1]:=oDep:emailmm
					aPersid[1]:=oDep:mbrpersid
				endif
				if oDep:rptdest>0                 // contact
					aLastname[2]:=oDep:Lastnamemc
					aFullname[2]:=oDep:fullnamemc
					aEmail[2]:=oDep:emailmc
					aPersid[2]:=oDep:contact
				endif
			endif
			if !Empty(aPersid[1]) .or.!Empty(aPersid[2]) 
				oRecip1:=null_object
				oRecip2:=null_object
				if !Empty(aPersid[1]) 
					* Resolve department responsible person name:   
					cLastName:=StrTran(StrTran(aLastname[1],"\",""),"/","")
					oRecip1 := self:oMapi:ResolveName( cLastName,aPersid[1],aFullname[1],aEmail[1]) 
				endif
				if Empty(aPersid[1]).and.!Empty(aPersid[2]) 
					* Resolve department responsible person name:   
					cLastName:=StrTran(StrTran(aLastname[2],"\",""),"/","")
					oRecip1 := self:oMapi:ResolveName( cLastName,aPersid[2],aFullname[2],aEmail[2])
				endif
				if !Empty(aPersid[1]).and.!Empty(aPersid[2]) 
					* Resolve department responsible person name:   
					cLastName:=StrTran(StrTran(aLastname[2],"\",""),"/","")
					oRecip2 := self:oMapi:ResolveName( cLastName,aPersid[2],aFullname[2],aEmail[2])
				endif
				IF oRecip1 != null_object                         
					IF !Empty(self:oEMLFrm:Template)
						oSelpers:oDB:=SQLSelect{"select persid,gender,title,initials,prefix,lastname,firstname,nameext,address,postalcode,city,country,"+;
							"attention,cast(datelastgift as date) as datelastgift from person "+;
							"where persid='"+iif( !Empty(aPersid[1]),Str(aPersid[1],-1),Str(aPersid[2],-1))+"'",oConn} 
						mailcontent:=oSelpers:FillText(self:oEMLFrm:Template,1,DueRequired,GiftsRequired,AddressRequired,RepeatingPossible,60)
					ELSE
						mailcontent:=""
					ENDIF
					IF !Empty(self:oEMLFrm:Template) 
						mailcontent:=oSelpers:FillText(self:oEMLFrm:Template,1,DueRequired,GiftsRequired,AddressRequired,RepeatingPossible,60)
					ELSE
						mailcontent:=""
					ENDIF
					oFileSpec:=FileSpec{aMailDepartment[i,2]}
					self:oMapi:SendDocument( oFileSpec,oRecip1,oRecip2,self:mailsubject+": "+PeriodText,mailcontent)
				ENDIF
			ENDIF
		NEXT
	ENDIF

	self:Pointer := Pointer{POINTERARROW}

	RETURN true
METHOD DepstmntPrint() CLASS DeptReport
	LOCAL lPrintFile as LOGIC
	LOCAL nRow,nPage as int
	LOCAL aDep:={} AS ARRAY
	//TotalWidth=137
	lPrintFile:=(self:oReport:Destination=="File")
	IF self:SendingMethod=="SeperateFileMail"
		(self:oEMLFrm := eMailFormat{self:oParent}):show()
		IF self:oEMLFrm:lCancel
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
	self:mailsubject:=oLan:RGet('Department Statements') 
	self:DepartmentStmntPrint(aDep,@nRow,@nPage)
	self:STATUSMESSAGE(Space(100))

	SetDecimalSep(Asc('.'))
	IF !lPrintFile.or.!SendingMethod="SeperateFile"
		self:oReport:prstart()    
	endif

	IF self:SendingMethod=="SeperateFileMail" 
		self:oMapi:Close()
	ENDIF

	SELF:Pointer := Pointer{POINTERARROW}

	RETURN
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS DeptReport
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	LOCAL nPntr as int
	LOCAL cCurValue as string
	oControl := iif(oEditFocusChangeEvent == null_object, null_object, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "FROMDEP"
			IF !Upper(AllTrim(oControl:TextValue))==Upper(AllTrim(self:cFromDepName))
				cCurValue:=AllTrim(oControl:TextValue)
				self:cFromDepName:=cCurValue
				nPntr:=At(":",cCurValue)
				IF nPntr>1
					cCurValue:=SubStr(cCurValue,1,nPntr-1)
				ENDIF
				IF FindDep(@cCurValue)
					self:RegDepartment(cCurValue,"From Department")
				ELSE
					self:FromDepButton(true)
				ENDIF
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
	cCurValue:=AllTrim(self:oDCFromDep:TEXTValue)
	nPntr:=At(":",cCurValue)
	IF nPntr>1
		cCurValue:=SubStr(cCurValue,1,nPntr-1)
	ENDIF

	(DepartmentExplorer{self:OWNER,"Department",self:FromDep,self,cCurValue,"From Department"}):Show()
RETURN
METHOD GetBalYears() CLASS DeptReport
	// get array with balance years
	RETURN (GetBalYears())
ACCESS GiftDetails() CLASS DeptReport
RETURN SELF:FieldGet(#GiftDetails)

ASSIGN GiftDetails(uValue) CLASS DeptReport
SELF:FieldPut(#GiftDetails, uValue)
RETURN uValue

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

oDCGiftDetails := CheckBox{SELF,ResourceID{DEPTREPORT_GIFTDETAILS,_GetInst()}}
oDCGiftDetails:HyperLabel := HyperLabel{#GiftDetails,"Show details of gifts",NULL_STRING,NULL_STRING}
oDCGiftDetails:TooltipText := "Show gifts also as separate transactions"

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
SELF:HyperLabel := HyperLabel{#DeptReport,"Department Statements and Gift Reports",NULL_STRING,NULL_STRING}

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
self:Country:=SQLSelect{"select countryown from sysparms",oConn}:FIELDGET(1)

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
		oDep:=SQLSelect{"select deptmntnbr,depid,descriptn from department where depid="+MyNum,oConn}
		IF oDep:Reccount>0
			depnr:=oDep:DEPID
			deptxt:=AllTrim(oDep:deptmntnbr)+":"+oDep:DESCRIPTN 
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
STATIC DEFINE DEPTREPORT_GIFTDETAILS := 123 
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
	PROTECT oDCReportYear AS SINGLELINEEDIT
	PROTECT oDCMonthStart AS SINGLELINEEDIT
	PROTECT oDCMonthEnd AS SINGLELINEEDIT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCTextfrom AS FIXEDTEXT
	PROTECT oDCTextTill AS FIXEDTEXT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oCCLastMonth AS RADIOBUTTON
	PROTECT oCCAllMonths AS RADIOBUTTON
	PROTECT oDCFootnotes AS RADIOBUTTONGROUP
	PROTECT oDCmailcontact AS CHECKBOX
	PROTECT oDCSkipInactive AS CHECKBOX
	PROTECT oDCSelectedCnt AS FIXEDTEXT
	PROTECT oCCPrintreport AS PUSHBUTTON
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oCCSeparateFiles AS PUSHBUTTON
	PROTECT oDCFixedText9 AS FIXEDTEXT
	PROTECT oCCSeparateFilesMail AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCGiftDetails AS CHECKBOX

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	INSTANCE HomeBox
	INSTANCE NonHomeBox
	INSTANCE ProjectsBox
	INSTANCE FromAccount
	INSTANCE ToAccount
	INSTANCE SubSet
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
	PROTECT CalcYear, CalcMonthStart,CalcMonthEnd as int
	EXPORT BeginReport:=FALSE as LOGIC
	
	declare method CheckAccInRange,GiftsPrint

	


RESOURCE GiftReport DIALOGEX  58, 59, 398, 267
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
	CONTROL	"Year:", GIFTREPORT_FIXEDTEXT5, "Static", WS_CHILD, 8, 96, 28, 12
	CONTROL	"", GIFTREPORT_SUBSET, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 250, 25, 125, 215, WS_EX_CLIENTEDGE
	CONTROL	"", GIFTREPORT_REPORTYEAR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 36, 96, 34, 12, WS_EX_CLIENTEDGE
	CONTROL	"", GIFTREPORT_MONTHSTART, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 128, 96, 19, 12, WS_EX_CLIENTEDGE
	CONTROL	"", GIFTREPORT_MONTHEND, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 176, 96, 19, 12, WS_EX_CLIENTEDGE
	CONTROL	"Members/funds", GIFTREPORT_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|WS_CLIPSIBLINGS, 8, 6, 377, 81
	CONTROL	"From:", GIFTREPORT_FIXEDTEXT1, "Static", WS_CHILD, 14, 52, 52, 10
	CONTROL	"To:", GIFTREPORT_FIXEDTEXT2, "Static", WS_CHILD, 136, 51, 56, 9
	CONTROL	"", GIFTREPORT_TEXTFROM, "Static", WS_CHILD, 13, 73, 111, 13
	CONTROL	"", GIFTREPORT_TEXTTILL, "Static", WS_CHILD, 136, 73, 111, 13
	CONTROL	"Subset:", GIFTREPORT_FIXEDTEXT7, "Static", WS_CHILD, 250, 16, 42, 9
	CONTROL	"Requierd action:", GIFTREPORT_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 210, 196, 55
	CONTROL	"Last month", GIFTREPORT_LASTMONTH, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 12, 127, 53, 11
	CONTROL	"All months", GIFTREPORT_ALLMONTHS, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 12, 141, 48, 11
	CONTROL	"Footnotes", GIFTREPORT_FOOTNOTES, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 118, 70, 38
	CONTROL	"eMail also to contact person", GIFTREPORT_MAILCONTACT, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 12, 166, 121, 11
	CONTROL	"Skip inactive accounts", GIFTREPORT_SKIPINACTIVE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 12, 177, 92, 11
	CONTROL	"", GIFTREPORT_SELECTEDCNT, "Static", WS_CHILD, 312, 16, 64, 9
	CONTROL	"Print", GIFTREPORT_PRINTREPORT, "Button", WS_TABSTOP|WS_CHILD, 16, 219, 180, 12
	CONTROL	"From month:", GIFTREPORT_FIXEDTEXT8, "Static", WS_CHILD, 80, 96, 48, 12
	CONTROL	"Save seperate printfile per member", GIFTREPORT_SEPARATEFILES, "Button", WS_TABSTOP|WS_CHILD, 15, 233, 181, 13
	CONTROL	"till:", GIFTREPORT_FIXEDTEXT9, "Static", WS_CHILD, 156, 96, 16, 12
	CONTROL	"Send separate printfile by email to each member", GIFTREPORT_SEPARATEFILESMAIL, "Button", WS_TABSTOP|WS_CHILD, 15, 249, 181, 12
	CONTROL	"Cancel", GIFTREPORT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 324, 243, 53, 13
	CONTROL	"Show details of gifts", GIFTREPORT_GIFTDETAILS, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 12, 188, 80, 11
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
				self:oDCSkipInactive:ToolTipText:="Suppress reports with no financial transaction in All Months"
		else
// 			if self:Memberstmnt
				self:SkipInactive:=false 
				self:oDCSkipInactive:ToolTipText:="Suppress reports with no financial transaction in All Months"
// 			else
// 				self:SkipInactive:=true
// 				self:oDCSkipInactive:ToolTipText:="Suppress reports with no financial transaction in Last Month"
// 			endif
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

ACCESS GiftDetails() CLASS GiftReport
RETURN SELF:FieldGet(#GiftDetails)

ASSIGN GiftDetails(uValue) CLASS GiftReport
SELF:FieldPut(#GiftDetails, uValue)
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
	LOCAL fAmnt as FLOAT, iMonth as int
	LOCAL myLang:=Alg_taal as STRING
	local aAssmntAmount:=ArrayNew(4,12) as array
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
	local oAcc,oTrans,oAccAss,oTransAss,oSys as SQLSelect
	local oPers as SQLSelectPerson
	LOCAL oPro as ProgressPer
	local CurLanguage as string
	local cFileNameBasic as string  // standard part of filename
	local oDepStmnt as DeptReport   // used for sending reports to member departments
	local aBal:={},aDep:={} as array 

	IF self:SendingMethod="SeperateFile"
		BoldOn:="{\b "
		BoldOff:="}"
		RedOn:="\cf1 "
		RedOff:="\cf0 "
	ENDIF

	IF !self:oReport:lPrintOk
		RETURN 
	ENDIF
	lPrintFile:=(self:oReport:Destination=="File")
	cFileNameBasic:=self:oReport:ToFileFS:FileName

	IF self:SendingMethod=="SeperateFileMail"
		(oEMLFrm := eMailFormat{oParent}):Show()
		IF oEMLFrm:lCancel
			RETURN 
		ENDIF
	ENDIF

	self:Pointer := Pointer{POINTERHOURGLASS}

	IF self:oGftRpt == null_object
		self:oGftRpt:=GiftsReport{}
		self:oGftRpt:Country:=self:Country
	ENDIF		
	oMBal:=Balances{}
	oPPcd := SqlSelect{"select ppcode,ppname from ppcodes order by ppcode",oConn} 
	
	oSys:=SqlSelect{"select cast(pmislstsnd as date) as pmislstsnd from sysparms",oConn}
	PMCLastSend:=iif(Empty(oSys:pmislstsnd),null_date,oSys:pmislstsnd)
	aPPCode:=oPPcd:GetLookupTable(200,#ppcode,#ppname)

	startdate:=SToD(Str(ReportYear,4)+'0101') 
	enddate:=SToD(Str(ReportYear,4)+Strzero(ReportMonth,2)+strzero(MonthEnd(ReportMonth,ReportYear),2))
	self:Pointer := Pointer{POINTERHOURGLASS}
	self:STATUSMESSAGE(self:oLan:WGet("Collecting data for the report, please wait")+"...")
	nRow := 0
	cPeriod:=Str(ReportYear,4)+Space(1)+iif(ReportMonth=1,'',oLan:RGet('up incl'))+Space(1)+oLan:RGet(MonthEn[ReportMonth],,"!")
	IF self:SendingMethod=="SeperateFileMail"
		oMapi := MAPISession{}	
		IF !oMapi:Open( "" , "" )
			MessageBox( 0 , self:oLan:WGet("MAPI-Services not available") , self:oLan:WGet("Problem") , MB_ICONEXCLAMATION )
			RETURN
		ENDIF		
	ENDIF
	ASsStart:=self:CalcMonthStart
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

	oAcc:=SQLSelect{"select a.accid,a.description,a.accnumber,a.currency,a.giftalwd,b.category,m.persid,m.householdid,m.homepp,m.contact,m.RPTDEST,m.depid,"+;
		"group_concat(cast(ass.accid as char) separator ',') as assacc,"+SQLFullName(0,'pc')+" as contactfullname,pc.lastname as contactlstname,pc.email as contactemail"+;
		",pm.lastname,pm.email "+;
		" from balanceitem b,account a left join department d on (d.depid=a.department) left join member m on (a.accid=m.accid or m.depid=d.depid) left join memberassacc ass on (ass.mbrid=m.mbrid)"+ ;
		" left join person pc on (pc.persid=m.contact) left join person pm on (pm.persid=m.persid)"+;
		" where a.balitemid=b.balitemid and a.giftalwd=1 and a.accnumber between '"+FromAccount+"' and '"+ToAccount+"'"+;
		" and a.accid in ("+Implode(aAcc,"','")+" ) group by a.accid order by "+iif(self:SendingMethod="SeperateFile","a.accnumber","a.accid"),oConn}
	if oAcc:RecCount>1 
		oPro:=ProgressPer{,oMainWindow}
		oPro:Caption:="Printing giftreports and member statements"
		oPro:SetRange(1,oAcc:RecCount+1)
		oPro:SetUnit(1)
		oPro:Show()
	endif
	oTrans:=SqlSelect{UnionTrans('select t.docid,t.transid,t.seqnr,t.accid,t.persid,t.dat,t.deb,t.cre,t.debforgn,t.creforgn,t.fromrpp,bfm,t.opp,t.gc,t.description'+;
		+iif(self:SendingMethod="SeperateFile",",a.accnumber",'')+;
		' from transaction t'+iif(self:SendingMethod="SeperateFile",', account a where a.accid=t.accid and',' where')+;
		" t.dat>='"+SQLdate(startdate)+"' and t.dat<='"+SQLdate(enddate)+"'"+;
		" and t.accid in ("+Implode(aAcc,"','")+")")+" order by "+iif(self:SendingMethod="SeperateFile","accnumber","accid")+",dat,transid,seqnr",oConn} 
	oTrans:Execute() 
	// 	if oTrans:RecCount<1
	// 		TextBox{self,self:oLan:WGet("Gift report"),self:oLan:WGet("Nothing to be reported")}:Show()
	// 	endif

	SetDecimalSep(Asc(DecSeparator))
	IF self:oTransMonth==null_object
		self:oTransMonth:=AccountStatements{90}
	ENDIF
	self:oTransMonth:oReport:=self:oReport
	self:oTransMonth:SendingMethod:=self:SendingMethod
	self:oTransMonth:lDebCreMerge:=true
	self:oTransMonth:BeginReport:=self:BeginReport 
	self:oTransMonth:GiftDetails:=self:oDCGiftDetails:checked
	
	do WHILE !oAcc:EOF
		memberName:=AllTrim(oAcc:Description)
		self:STATUSMESSAGE(self:oLan:WGet('Printing the report of')+Space(1)+memberName) 
		if !Empty(oPro)
			oPro:AdvancePro()
		endif
		if !Empty(oAcc:depid)
			// member department:
			if Empty(oDepStmnt)
				oDepStmnt:=DeptReport{} 
				oDepStmnt:SimpleDepStmnt:= false
				oDepStmnt:lDebCreMerge:=true
				// 				oDepStmnt:lNoBalance:=true 
				oDepStmnt:WhatDetails:=false
				oDepStmnt:showopeningclosingfund:=false
				oDepStmnt:oEMLFrm:= oEMLFrm
				oDepStmnt:BeginReport:=self:BeginReport 
				oDepStmnt:oGiftRpt:=self:oGftRpt 
				oDepStmnt:Country:=self:Country
				oDepStmnt:oMapi:=oMapi
			endif
			oDepStmnt:YEARSTART:=ReportYear
			oDepStmnt:YEAREND:=ReportYear				
			oDepStmnt:MonthEnd:=ReportMonth
			oDepStmnt:MONTHSTART:=ASsStart
			aBal:=GetBalYear(ReportYear,ReportMonth)
			oDepStmnt:BalYears:=str(aBal[1],4,0)+strzero(aBal[2],2,0)
			oDepStmnt:SendingMethod:=self:SendingMethod
			oDepStmnt:Footnotes:=self:Footnotes
			oDepStmnt:oReport:=self:oReport 
			oDepStmnt:GiftDetails:=self:GiftDetails
			aDep:={oAcc:DepId}
			self:oReport:ToFileFS:FileName:= cFileNameBasic
			oDepStmnt:mailsubject:=oLan:RGet('Giftreport')  
			oDepStmnt:DepartmentStmntPrint(aDep,@nRow,@nPage)
		else
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
			nPage :=0
			* Insert membername if print to seperate file: 
			nBeginmember:=Len(self:oReport:oPrintJob:aFiFo) 
			lTransFound:=false
			IF lPrintFile.and.!Empty(self:SendingMethod) 
				// rename filename to add member name:                   
				self:oReport:ToFileFS:FileName:= cFileNameBasic+Space(1)+CleanFileName(StrTran(oAcc:description,'.',' '))
				nRow := 0
			ENDIF
			self:oTransMonth:oReport:=self:oReport
			self:oTransMonth:SkipInactive:=self:SkipInactive
			myLang:=Alg_taal
			me_hbn:=Transform(oAcc:householdid,"")
			IF !Empty(oAcc:HOMEPP) .and.oAcc:HOMEPP!=sEntity
				Alg_taal:="E"
			ENDIF
			if !Alg_taal==CurLanguage
				CurLanguage:=Alg_taal
			endif
			*	Fill array aGivers with data of givers and gifts of corresponding destination and totalize them
			*	Print statement report
			cHeading1:=Str(ReportYear,4)+Space(1)+iif(Empty(me_hbn),'',self:oLan:RGet('HOUSECD')+':'+me_hbn+Space(1))+self:oLan:RGet("Currency")+':'+sCurr+Space(1)+self:Country

			self:oTransMonth:MonthPrint(oAcc,oTrans,ReportYear,ASsStart,ReportYear,ReportMonth,@nRow,@nPage,cHeading1,self:oLan,aGiversdata,aAssmntAmount,iif(self:SendingMethod="SeperateFile","accnumber","accid"))
			nRow:=0  && force page skip 
			IF self:SkipInactive .and. Len(self:oReport:oPrintJob:aFiFo)== nBeginmember
				*  skip member without transactions
				* remove added member lines:
				lSkip:=true 
				IF lPrintFile.and.!Empty(self:SendingMethod)
					self:oReport:RemovePrFile() 
				endif									
			ENDIF
			
			IF lSkip
				oAcc:Skip()
				Alg_taal:=myLang
				loop
			ENDIF
			*	If	associated accounts for	this member, print also	corresponding accountstatements for	this month:
			IF	!Empty(oAcc:persid) .and.!Empty(oAcc:assacc)
				// 					IF	oTransMonth==null_object
				// 						oTransMonth:=AccountStatements{79}
				// 					ENDIF
				// 					oTransMonth:oReport:=self:oReport
				// 					oTransMonth:SendingMethod:=self:SendingMethod
				oAccAss:=SqlSelect{"select accid,accnumber,a.description,a.giftalwd,a.currency,b.category from account a, balanceitem b "+;
					"where b.balitemid=a.balitemid and accid in ("+oAcc:assacc+") order by accid",oConn}
				oAccAss:Execute()
				oTransAss:=	SqlSelect{UnionTrans('select t.docid,t.transid,t.accid,t.persid,t.dat,t.deb,t.cre,t.debforgn,t.creforgn,t.fromrpp,bfm,t.opp,t.gc,t.description '+;
					'from transaction t where t.dat>="'+SQLdate(SToD(Str(ReportYear,4,0)+StrZero(ASsStart,2,0)+'01'))+'" and t.dat<="'+SQLdate(enddate)+'"'+;
					" and t.accid in ("+oAcc:assacc+") order by t.accid,t.dat"),oConn}
				oTransAss:Execute() 

				// 					aASS:=Split(oAcc:assacc,',')
				//aASS:={oMbr:REK1,oMbr:REK2,oMbr:REK3}
				do while !oAccAss:EOF
					nRow:=0	&&	force page skip
					// 					oTransMonth:MonthPrint(oAccAss:ACCNUMBER,oAccAss:ACCNUMBER,ReportYear,ASsStart,ReportYear,ReportMonth,@nRow,@nPage,,oLan)
					oTransMonth:MonthPrint(oAccAss,oTransAss,ReportYear,ASsStart,ReportYear,ReportMonth,@nRow,@nPage,cHeading1,oLan,,,"accid")
					oAccAss:Skip()
				enddo
			endif

			// Print gifts matrix:
			nRow:=0  // force page skip
			oGftRpt:GiftsOverview(ReportYear,ReportMonth,Footnotes, aGiversdata,aAssmntAmount,self:oReport, oAcc:ACCNUMBER+Space(1)+oAcc:description,me_hbn,@nRow,@nPage)
			IF lPrintFile.and.!Empty(self:SendingMethod)
				// separate files:
				cFileName:=self:oReport:prstart() // save separate file
			endif 
			*	
			*	Proces e-mail:
			IF lPrintFile.and. self:SendingMethod=="SeperateFileMail"
				IF !Empty(oAcc:persid)  // skip funds
					aOneMember:={}          //
					AAdd(aOneMember,{AllTrim(StrTran(oAcc:description,".",Space(1))),oAcc:persid,oAcc:email,cFileName})
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
				ENDIF
			ENDIF
		endif
		oAcc:Skip()
		Alg_taal:=myLang

	ENDDO 
	SetDecimalSep(Asc('.'))      //back to .
	IF !oPro==null_object
		oPro:EndDialog()
		oPro:Destroy()
	ENDIF
// 	IF !lPrintFile.or.!self:SendingMethod="SeperateFile"   ????
		self:oReport:prstart()    
// 	endif
	IF self:SendingMethod=="SeperateFileMail"
		oSelpers:=Selpers{self,,}
		oSelpers:AnalyseTxt(oEMLFrm:Template,@DueRequired,@GiftsRequired,@AddressRequired,@repeatingGroup,1)
		
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
					oSelpers:oDB:=SQLSelect{"select persid,gender,title,initials,prefix,lastname,firstname,nameext,address,postalcode,city,country,"+;
						"attention,cast(datelastgift as date) as datelastgift from person "+;
						"where persid='"+iif(aMailMember[i,2,1]=1,Str(aMailMember[i,2,3],-1),Str(aMailMember[i,1,2],-1))+"'",oConn} 
					oSelpers:ReportMonth:=iif(ReportMonth=1,'',oLan:RGet('up incl'))+Space(1)+oLan:RGet(MonthEn[ReportMonth],,"!")+Space(1)+Str(ReportYear,4)
					mailcontent:=oSelpers:FillText(oEMLFrm:Template,1,DueRequired,GiftsRequired,AddressRequired,repeatingGroup,60)
				ELSE
					mailcontent:=""
				ENDIF
				oFileSpec:=FileSpec{aMailMember[i,1,4]}
				oMapi:SendDocument( oFileSpec,oRecip1,oRecip2,oLan:RGet('Giftreport')+Space(1)+memberName+": "+cPeriod,mailcontent)
			ENDIF
		NEXT
		oMapi:Close()
	ENDIF
	self:Pointer := Pointer{POINTERARROW}
	IF !oSelpers==null_object
		oSelpers:Close()
		oSelpers:=null_object
	ENDIF
	self:oReport:prstop()
	// remove old giftreports:
	aFilePF:=Directory(CurPath+"\"+self:oLan:RGet("Giftreport")+"*.doc")
	FOR i:=1 to Len(aFilePF)
		IF aFilePF[i,F_DATE]<(Today()-90)
			oPF := MyFileSpec{aFilePF[i,F_NAME]}
			IF oPF:FileLock()
				oPF:DELETE()
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
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Year:",NULL_STRING,NULL_STRING}

oDCSubSet := ListboxGiftReport{SELF,ResourceID{GIFTREPORT_SUBSET,_GetInst()}}
oDCSubSet:TooltipText := "Select subset of given range of member/funds"
oDCSubSet:HyperLabel := HyperLabel{#SubSet,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSubSet:OwnerAlignment := OA_WIDTH_HEIGHT

oDCReportYear := SingleLineEdit{SELF,ResourceID{GIFTREPORT_REPORTYEAR,_GetInst()}}
oDCReportYear:HyperLabel := HyperLabel{#ReportYear,NULL_STRING,NULL_STRING,NULL_STRING}
oDCReportYear:Picture := "9999"

oDCMonthStart := SingleLineEdit{SELF,ResourceID{GIFTREPORT_MONTHSTART,_GetInst()}}
oDCMonthStart:Picture := "99"
oDCMonthStart:HyperLabel := HyperLabel{#MonthStart,NULL_STRING,NULL_STRING,NULL_STRING}

oDCMonthEnd := SingleLineEdit{SELF,ResourceID{GIFTREPORT_MONTHEND,_GetInst()}}
oDCMonthEnd:Picture := "99"
oDCMonthEnd:HyperLabel := HyperLabel{#MonthEnd,NULL_STRING,NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{GIFTREPORT_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Members/funds",NULL_STRING,NULL_STRING}

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

oDCSelectedCnt := FixedText{SELF,ResourceID{GIFTREPORT_SELECTEDCNT,_GetInst()}}
oDCSelectedCnt:HyperLabel := HyperLabel{#SelectedCnt,NULL_STRING,NULL_STRING,NULL_STRING}

oCCPrintreport := PushButton{SELF,ResourceID{GIFTREPORT_PRINTREPORT,_GetInst()}}
oCCPrintreport:HyperLabel := HyperLabel{#Printreport,"Print",NULL_STRING,NULL_STRING}

oDCFixedText8 := FixedText{SELF,ResourceID{GIFTREPORT_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"From month:",NULL_STRING,NULL_STRING}

oCCSeparateFiles := PushButton{SELF,ResourceID{GIFTREPORT_SEPARATEFILES,_GetInst()}}
oCCSeparateFiles:HyperLabel := HyperLabel{#SeparateFiles,"Save seperate printfile per member",NULL_STRING,NULL_STRING}

oDCFixedText9 := FixedText{SELF,ResourceID{GIFTREPORT_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"till:",NULL_STRING,NULL_STRING}

oCCSeparateFilesMail := PushButton{SELF,ResourceID{GIFTREPORT_SEPARATEFILESMAIL,_GetInst()}}
oCCSeparateFilesMail:HyperLabel := HyperLabel{#SeparateFilesMail,"Send separate printfile by email to each member",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{GIFTREPORT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}
oCCCancelButton:OwnerAlignment := OA_Y

oDCGiftDetails := CheckBox{SELF,ResourceID{GIFTREPORT_GIFTDETAILS,_GetInst()}}
oDCGiftDetails:HyperLabel := HyperLabel{#GiftDetails,"Show details of gifts",NULL_STRING,NULL_STRING}
oDCGiftDetails:TooltipText := "Show gifts also as separate transactions "

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

ACCESS MonthEnd() CLASS GiftReport
RETURN SELF:FieldGet(#MonthEnd)

ASSIGN MonthEnd(uValue) CLASS GiftReport
SELF:FieldPut(#MonthEnd, uValue)
RETURN uValue

ACCESS MonthStart() CLASS GiftReport
RETURN SELF:FieldGet(#MonthStart)

ASSIGN MonthStart(uValue) CLASS GiftReport
SELF:FieldPut(#MonthStart, uValue)
RETURN uValue

ACCESS NonHomeBox() CLASS GiftReport
RETURN SELF:FieldGet(#NonHomeBox)

ASSIGN NonHomeBox(uValue) CLASS GiftReport
SELF:FieldPut(#NonHomeBox, uValue)
RETURN uValue

METHOD OKButton( ) CLASS GiftReport
	LOCAL nAcc as STRING
	LOCAL nRow, nPage as int


	// 	IF ValidateControls( self, self:AControls )
	IF SendingMethod=="SeperateFileMail"
		IF !IsMAPIAvailable()
			(ErrorBox{self:Owner,self:oLan:WGet("Outlook not default mailing system or no interface to it")}):show()
			RETURN true
		ENDIF
	ENDIF
	self:CalcYear:=Round(Val(self:oDCReportYear:TextValue),0)
	self:CalcMonthEnd:=Round(Val(self:oDCMonthEnd:TextValue),0)
	self:CalcMonthStart:=Round(Val(self:oDCMonthStart:TextValue),0)
	IF self:CalcYear>self:MaxJaar
		(ErrorBox{self:Owner,self:oLan:WGet("Year out of range")}):show()
	ELSEIF self:CalcYear<self:MinJaar
		(ErrorBox{self:Owner,self:oLan:WGet("Year out of range")}):show()
	ELSEIF self:CalcMonthStart <1 .or.self:CalcMonthEnd <self:CalcMonthStart
		(ErrorBox{self:Owner,self:oLan:WGet("Month out of range")}):show()
	ELSEIF self:CalcMonthEnd>12 
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
		self:oReport := PrintDialog{oParent,self:oLan:RGet("Giftreport")+Str(self:CalcYear,4)+StrZero(self:CalcMonthEnd,2),,145,DMORIENT_LANDSCAPE,"doc"}
		IF	SendingMethod="SeperateFile"
			self:oReport:OKButton("File",true)
		ELSE
			self:oReport:show()
		ENDIF
		self:GiftsPrint(self:FromAccount,self:ToAccount,self:CalcYear,self:CalcMonthEnd,@nRow,@nPage)
	ENDIF
	// 	ENDIF
	RETURN true
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS GiftReport
	//Put your PostInit additions here
	self:SetTexts()

	self:PeilMax:=Month(Today()-27)
	self:MonthStart:=self:PeilMax   
	self:MonthEnd:=self:PeilMax   
	self:ReportYear:=Year(Today()-27)
	self:StartJaar:=Year(LstYearClosed)
	self:MaxJaar:=Year(Today())
	self:Country:=SQLSelect{"select countryown from sysparms",oConn}:FIELDGET(1)

	self:Footnotes:="Last"
	self:oDCHomeBox:Caption:=self:oLan:WGet("Members of")+" "+sLand
	self:oDCNonHomeBox:Caption:=self:oLan:WGet("Members not of")+" "+sLand
	self:HomeBox:=true
	self:NonHomeBox:=true
	self:ProjectsBox:=true
	self:AccFil()
	if FromAccount==ToAccount
		self:SkipInactive:=false
	else
// 		if self:Memberstmnt="ALLST"
// 			self:SkipInactive:=false 
// 			self:oDCSkipInactive:ToolTipText:=self:oLan:WGet("Suppress reports with no financial transaction in All Months")
// 		else
			self:SkipInactive:=true
			self:oDCSkipInactive:ToolTipText:=self:oLan:WGet("Suppress reports with no financial transaction in Last Month")
// 		endif
	endif
	self:BeginReport:=true 
	if sEntity=='FRN'
		self:oDCGiftDetails:Checked :=true
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
		self:SkipInactive:=true
	endif
	
	RETURN true
ACCESS ReportYear() CLASS GiftReport
RETURN SELF:FieldGet(#ReportYear)

ASSIGN ReportYear(uValue) CLASS GiftReport
SELF:FieldPut(#ReportYear, uValue)
RETURN uValue

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

STATIC DEFINE GIFTREPORT_ALLMONTHS := 120 
STATIC DEFINE GIFTREPORT_CANCELBUTTON := 130 
STATIC DEFINE GIFTREPORT_FIXEDTEXT1 := 113 
STATIC DEFINE GIFTREPORT_FIXEDTEXT2 := 114 
STATIC DEFINE GIFTREPORT_FIXEDTEXT5 := 107 
STATIC DEFINE GIFTREPORT_FIXEDTEXT7 := 117 
STATIC DEFINE GIFTREPORT_FIXEDTEXT8 := 126 
STATIC DEFINE GIFTREPORT_FIXEDTEXT9 := 128 
STATIC DEFINE GIFTREPORT_FOOTNOTES := 121 
STATIC DEFINE GIFTREPORT_FROMACCBUTTON := 104 
STATIC DEFINE GIFTREPORT_FROMACCOUNT := 103 
STATIC DEFINE GIFTREPORT_GIFTDETAILS := 131 
STATIC DEFINE GIFTREPORT_GROUPBOX1 := 112 
STATIC DEFINE GIFTREPORT_GROUPBOX2 := 118 
STATIC DEFINE GIFTREPORT_HOMEBOX := 100 
STATIC DEFINE GIFTREPORT_LASTMONTH := 119 
STATIC DEFINE GIFTREPORT_MAILCONTACT := 122 
STATIC DEFINE GIFTREPORT_MONTHEND := 111 
STATIC DEFINE GIFTREPORT_MONTHSTART := 110 
STATIC DEFINE GIFTREPORT_NONHOMEBOX := 101 
STATIC DEFINE GIFTREPORT_PRINTREPORT := 125 
STATIC DEFINE GIFTREPORT_PROJECTSBOX := 102 
STATIC DEFINE GIFTREPORT_REPORTYEAR := 109 
STATIC DEFINE GIFTREPORT_SELECTEDCNT := 124 
STATIC DEFINE GIFTREPORT_SEPARATEFILES := 127 
STATIC DEFINE GIFTREPORT_SEPARATEFILESMAIL := 129 
STATIC DEFINE GIFTREPORT_SKIPINACTIVE := 123 
STATIC DEFINE GIFTREPORT_SUBSET := 108 
STATIC DEFINE GIFTREPORT_TEXTFROM := 115 
STATIC DEFINE GIFTREPORT_TEXTTILL := 116 
STATIC DEFINE GIFTREPORT_TOACCBUTTON := 106 
STATIC DEFINE GIFTREPORT_TOACCOUNT := 105 
CLASS GiftsReport
	EXPORT Country as STRING
	protect oLan as Language
	protect DecFrac as int
	protect aAsmntDescr as ARRAY
	protect GiftDesc,NonEarDesc,cHeading1,cHeading2,cHeading3,cHeading4,cHeading5 as string
	protect CurLanguage as string
// 	export dim aAssmntAmount[4,12] as float

	declare method GiftsOverview,InitializeTexts
METHOD GiftsOverview(ReportYear as int,ReportMonth as int,Footnotes as string, aGiversdata as array,aAssmntAmount as array,oReport as PrintDialog ,description as string,me_hbn as string,nRow ref int,nPage ref int,addHeading:='' as string) as void pascal CLASS GiftsReport
	*	Markup of overview of givers and gifts from the beginning of a year for one destination 
	*  aGiversdata: contains all gifts with id of giver
	LOCAL g_na1,mndtxt,cPeriodTxt,hlptxt as STRING
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
	local LineContent as string
	LOCAL aMsg, aRow as ARRAY
	LOCAL aHeading as ARRAY
	LOCAL separator := Replicate('-',40)+'|-------|-------|-------|-------|-------|'+;
		'-------|-------|-------|-------|-------|-------|-------|'  as string
	local HeadingRTF:="\trowd\trautofit1\trgaph60"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx3950"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx4750"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx5620"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx6455"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx7290"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx8125"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx8960"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx9795"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx10630"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx11465"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx12300"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx13135"+;
"\clbrdrl\brdrw10\brdrs\clbrdrt\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw20\brdrth\clcbpat4"+; 
"\cellx13950\f0"
	local RowRTFline:="\trowd\trautofit1\aspalpha\aspnum\trpaddr40\trpaddfr3\trgaph60"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs\clNoWrap"+; 
"\cellx3950"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx4750"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx5620"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx6455"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx7290"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx8125"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx8960"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx9795"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx10630"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx11465"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx12300"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx13135"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clbrdrb\brdrw10\brdrs"+; 
"\cellx13950"  as string
	local RowRTF:="\trowd\trautofit1\aspalpha\aspnum\trpaddr40\trpaddfr3\trgaph60"+;
"\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs\clNoWrap"+;
"\cellx3950\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx4750\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx5620\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx6455\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx7290\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx8125\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx8960\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx9795\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx10630\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx11465\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx12300\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx13135\clbrdrl\brdrw10\brdrs\clbrdrr\brdrw10\brdrs"+;
"\cellx13950"  as string 
	LOCAL RowCnt,NoteNumber,GClen,CurPersid as int
	local cPersids as string 

	nRow:=0  && enforce page skip 
	self:CurLanguage:=''
	nDecFrac1:=Max(0,nDecFrac - 1)
	self:InitializeTexts(ReportYear,ReportMonth,oReport)
	* Sort on person id: 

	ASort(aGiversdata,,,{|x,y| x[PRSID]<y[PRSID].or.x[PRSID]==y[PRSID].and.x[MND]<=y[MND]})
	for i:=1 to Len(aGiversdata)
		if !aGiversdata[i,PRSID]==PersidSav
			cPersids+=","+Str(aGiversdata[i,PRSID],-1)
			PersidSav:=aGiversdata[i,PRSID]
		endif
	next
	// select all person data:
	if Empty(cPersids)
		cPersids:=',0'
	endif
	oPers:=SQLSelectPerson{"select email,country,address,city,postalcode,gender,title,prefix,lastname,firstname,initials,attention,nameext,persid from person where persid in ("+SubStr(cPersids,2)+") order by lastname,city,address",oConn}
	oPers:Execute()
	do while !oPers:EOF 
		CurPersid:=oPers:persid
		aAddress	:=	MarkUpAddress(oPers,,iif(sEntity='THD',72,40))
		* remove trailing blank address lines:
		ADel(aAddress,7)
		ASize(aAddress,6)
		FOR i	= 1 to 6
			IF	Empty(aAddress[1])
				ADel(aAddress,1)
				aAddress[6]:=null_string
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
	gvr:=0
	do while (gvr:=ascan(aGiversdata,{|x|empty(x[6])},gvr+1))>0
		if (TextBox{,self:oLan:WGet("GiftReport"),self:oLan:WGet("Giver of gift")+" :"+AllTrim(Str(aGiversdata[gvr,1]))+" "+AllTrim(aGiversdata[gvr,3])+;
				" in "+self:oLan:WGet(MonthEn[aGiversdata[gvr,5]],,"!")+' '+self:oLan:WGet('to')+': "'+description+'" '+self:oLan:WGet('not found'),BUTTONOKAYCANCEL}):Show();
				==BOXREPLYCANCEL
			RETURN
		ENDIF
		aGiversdata[gvr,6]:=0
	enddo				

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
	AAdd(aHeading,iif(oReport:lRTF,HeadingRTF,'')+self:cHeading2 )
	IF !oReport:lRTF
		AAdd(aHeading,separator)
	endif
	IF !(Admin="WO".or.Admin="HO")
		AsmntRowCnt:=1
	ENDIF
	FOR asmntRow= 1 to AsmntRowCnt
		LineContent:=iif(oReport:lRTF,iif(asmntRow=AsmntRowCnt,StrTran(RowRTFline,"\clbrdrb\brdrw10\brdrs","\clbrdrb\brdrw20\brdrth"),RowRTF)+"\intbl\ql "+AllTrim(self:aAsmntDescr[asmntRow])+"\cell",Pad(self:aAsmntDescr[asmntRow],40))
		for i:=1 to 12
			LineContent+=iif(oReport:lRTF,"\intbl"+iif(i=1,"\qr ",' ')+Str(aAssmntAmount[asmntRow,i],-1,nDecFrac1)+"\cell",Str(aAssmntAmount[asmntRow,i],8,nDecFrac1))
		next
		LineContent+=+iif(oReport:lRTF,"\row\pard",'')
		oReport:PrintLine(@nRow,@nPage,LineContent,aHeading,iif(asmntRow=1,30,1))
	NEXT
	IF !oReport:lRTF
		oReport:PrintLine(@nRow,@nPage,separator,aHeading,20-AsmntRowCnt)
	endif

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
		if aGiversdata[gvr,6]=0
			aRow:=AReplicate(Space(40),3)
			AddressRow:=3
		else
			AddrPnt++ 
			AAdd(aRow,iif(oReport:lRTF, AllTrim(aMbrAddresses[AddrPnt,2,1]),Pad(aMbrAddresses[AddrPnt,2,1],40)))
			AAdd(aRow,iif(oReport:lRTF, AllTrim(aMbrAddresses[AddrPnt,2,2]),Pad(aMbrAddresses[AddrPnt,2,2],40)))
			AAdd(aRow,iif(oReport:lRTF, AllTrim(aMbrAddresses[AddrPnt,2,3]),Pad(aMbrAddresses[AddrPnt,2,3],40)))
			AddressRow:=3
			IF !Empty(aMbrAddresses[AddrPnt,2,4])
				AAdd(aRow,iif(oReport:lRTF, AllTrim(aMbrAddresses[AddrPnt,2,4]), Pad(aMbrAddresses[AddrPnt,2,4],40)))
				++AddressRow
				IF !Empty(aMbrAddresses[AddrPnt,2,5])
					AAdd(aRow,iif(oReport:lRTF, AllTrim(aMbrAddresses[AddrPnt,2,5]), Pad(aMbrAddresses[AddrPnt,2,5],40)))
					++AddressRow
					IF !Empty(aMbrAddresses[AddrPnt,2,6])
						AAdd(aRow,iif(oReport:lRTF, AllTrim(aMbrAddresses[AddrPnt,2,6]), Pad(aMbrAddresses[AddrPnt,2,6],40)))
						++AddressRow
					ENDIF
				ENDIF
			ENDIF
		endif
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
					.and. AtC('maandelijks',aGiversdata[gvr,DESCR])=0 .and.AtC('kwartaal',aGiversdata[gvr,DESCR])=0 ;
					.and. aGiversdata[gvr,amnt] # 0.and.aGiversdata[gvr,DESCR] # NonEarDesc
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
		LineContent:=iif(oReport:lRTF,RowRTF+"\intbl\ql "+AllTrim(aRow[1])+"\cell",aRow[1])
		for i:=1 to 12
			LineContent+=iif(oReport:lRTF,"\intbl"+iif(i=1,"\qr ",' ')+AllTrim(aGiversGC[i])+"\cell",aGiversGC[i])
		next
		LineContent+=+iif(oReport:lRTF,"\row\pard",'')
		oReport:PrintLine(@nRow,@nPage,LineContent,aHeading,AddressRow)
		LineContent:=iif(oReport:lRTF,RowRTF+"\intbl\ql "+AllTrim(aRow[2])+"\cell",aRow[2])
		for i:=1 to 12
			LineContent+=iif(oReport:lRTF,"\intbl"+iif(i=1,"\qr ",' ')+iif(GiftAmnt[i]=0.00,'',Str(GiftAmnt[i],-1,nDecFrac))+"\cell",iif(GiftAmnt[i]=0.00,Space(8),Str(GiftAmnt[i],8,nDecFrac)))
		next
		LineContent+=+iif(oReport:lRTF,"\row\pard",'')
		oReport:PrintLine(@nRow,@nPage,LineContent,aHeading)
		LineContent:=iif(oReport:lRTF,iif(AddressRow<=3,RowRTFline,RowRTF)+"\intbl\ql "+AllTrim(aRow[3]) +"\cell",aRow[3])
		for i:=1 to 12
			LineContent+=iif(oReport:lRTF,"\intbl"+iif(i=1,"\qr ",' ')+AllTrim(NoteRef[i])+"\cell",NoteRef[i])
		next
		LineContent+=+iif(oReport:lRTF,"\row\pard",'')
		oReport:PrintLine(@nRow,@nPage,LineContent,aHeading)
// 		oReport:PrintLine(@nRow,@nPage,aRow[3] + NoteRef[1]+NoteRef[2]+NoteRef[3];
// 			+NoteRef[4]+NoteRef[5]+NoteRef[6]+NoteRef[7]+;
// 			NoteRef[8]+NoteRef[9]+NoteRef[10]+;
// 			NoteRef[11]+NoteRef[12],aHeading)
			
		if AddressRow>3 
			FOR i=4 to AddressRow
				LineContent:=iif(oReport:lRTF,iif(i=AddressRow,RowRTFline,RowRTF)+"\intbl\ql "+AllTrim(aRow[i]) +"\cell\intbl\cell\intbl\cell\intbl\cell"+;
				"\intbl\cell\intbl\cell\intbl\cell\intbl\cell\intbl\cell\intbl\cell\intbl\cell\intbl\cell\intbl\cell\row\pard",aRow[i])
				oReport:PrintLine(@nRow,@nPage,LineContent,aHeading)
			NEXT
		endif
		if !oReport:lRTF
			oReport:PrintLine(@nRow,@nPage,separator,aHeading)
		endif
	NEXT

	ASize(aHeading,2) 
	oReport:PrintLine(@nRow,@nPage,' ',aHeading)
	oReport:PrintLine(@nRow,@nPage,Str(oPers:RecCount,-1)+Space(1) +self:oLan:RGet("givers"),aHeading)
	
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
	self:DecFrac:=ConI(SQLSelect{"select decmgift from sysparms",oConn}:FIELDGET(1))

	return self
method InitializeTexts(ReportYear as int,ReportMonth as int,oReport as PrintDialog ) as void pascal class GiftsReport  
	local mtxt,cPeriodTxt as string
	local i as int
	if !self:CurLanguage== Alg_taal
		self:CurLanguage := Alg_taal
		// different language? Tranlate texts again
		self:aAsmntDescr:={self:oLan:RGet("Total Gifts/Own Funds",28,"!"),self:oLan:RGet("Assessable Gifts",36,"!"),;
			self:oLan:RGet("Personal Funds",36,"!"),self:oLan:RGet("Member Gifts",36,"!")}
		self:GiftDesc:=self:oLan:RGet("gift",,"@!")
		self:NonEarDesc:=self:oLan:RGet("Allotted non-designated gift",,"@!")
		mtxt:=''
		FOR i=1 to 12
			mtxt:=mtxt+iif(oReport:lRTF,"\intbl"+iif(i=1,"\qc","")+" "+self:oLan:RGet(MonthEn[i],,"!")+"\cell",' '+PadL(self:oLan:RGet(MonthEn[i],,"!"),7))
		NEXT
		mtxt+=iif(oReport:lRTF,"\row\pard\f1","")

		cPeriodTxt:=Str(ReportYear,4)+' '+iif(ReportMonth=1,'',self:oLan:RGet('up incl'))+' '+self:oLan:RGet(MonthEn[ReportMonth],,"!")
		self:cHeading1:=self:oLan:RGet('Year',,"!")+' '+cPeriodTxt+Space(15)+self:oLan:RGet('GIFTREPORT',,"@!")+': %description%'+;
			'   '+self:Country+' HOUSECD: %hbn%'
		IF oReport:lRTF
			self:cHeading2:="\intbl\ql "+self:oLan:RGet('name',,"!")+' '+self:oLan:RGet('and')+' '+self:oLan:RGet('address')+' '+;
			self:oLan:RGet('giver')+"\cell"+mtxt 
		else
			self:cHeading2:=Pad(self:oLan:RGet('name',,"!")+' '+self:oLan:RGet('and')+' '+self:oLan:RGet('address')+' '+;
			self:oLan:RGet('giver'),40)+mtxt
		endif
		self:cHeading3:=self:oLan:RGet('footnotes',,"@!")
		self:cHeading4:=self:oLan:RGet('Explanation',,"!")+' '+self:oLan:RGet('of')+' '+self:oLan:RGet('codes')
		self:cHeading5:=self:oLan:RGet("non-designated",,"!")+' '+self:oLan:RGet('gift')
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
	Local oSel as SQLSelect
	// check if no open transactions in that period: 
	if Posting
		oSel:=SqlSelect{"select count(*) as tot from transaction where poststatus<2 and dat<'"+SQLdate(self:oDCMindate:SelectedDate)+"'",oConn}
		if oSel:reccount>0 .and.ConI(oSel:tot)>0
			ErrorBox{self,ConS(oSel:tot)+' '+self:oLan:WGet("transactions")+' '+self:oLan:WGet("before")+' '+DToC(self:oDCMindate:SelectedDate)+' '+ self:oLan:WGet("are still to be posted")}:Show()
			self:EndWindow()
			return false
		endif
	endif
	if !Empty(SPROJ)
		* Are there still non-earmarekd gifts?
		oSel:=SqlSelect{"select count(*) as tot from transaction where bfm='O' and cre>deb and dat <='"+SQLdate(self:oDCMindate:SelectedDate)+"' and accid='"+SPROJ+"'",oConn}
		if oSel:reccount>0 .and. ConI(oSel:tot)>0
			(ErrorBox{self:OWNER,self:oLan:WGet('Allot first non-designated gifts')+' '+self:oLan:WGet("before")+' '+DToC(self:oDCMindate:SelectedDate)}):Show()
			self:EndWindow()
			RETURN true
		ENDIF
	ENDIF
	if ADMIN=='WO' 
		oSel:=SqlSelect{"select count(*) as tot from transaction t "+;
		"where t.bfm='' and t.gc<>'' and t.dat<='"+SQLdate(self:oDCMindate:SelectedDate)+"' and "+; 
		"exists (select 1 from member m left join department d on (m.depid=d.depid) where m.householdid<>'' and grade<>'staf' and (m.accid=t.accid or t.accid in (d.incomeacc,d.expenseacc,d.netasset)))  ";
		,oConn}
		if oSel:reccount>0 .and. ConI(oSel:tot)>0
			ErrorBox{self:OWNER,self:oLan:WGet("Send first to PMC all transaction before")+' '+DToC(self:oDCMindate:SelectedDate)}:Show()
			self:EndWindow()
			return true
		endif
	endif
	
	SQLStatement{"update sysparms set mindate='"+SQLdate(self:oDCMindate:SelectedDate)+"'",oConn}:Execute()
	Mindate:=self:oDCMindate:SelectedDate
	self:EndWindow()
	RETURN NIL
method PostInit(oWindow,iCtlID,oServer,uExtra) class MonthClose
	//Put your PostInit additions here 
	self:SetTexts()
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
// IF !ValidateControls( self, self:AControls )
// 	RETURN
// END
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
headinglines:={oLan:RGet("Overview of Tax reduction report")+" "+Str(TaxYear,4),oLan:RGet("Name",41)+oLan:RGet("Amount",12,,"R")+" "+oLan:RGet("Person Number",13),Replicate('-',67)}
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
resource TrialBalance DIALOGEX  20, 18, 266, 153
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
	PROTECT oReport as PrintDialog
	PROTECT lPrint as LOGIC
	PROTECT oDep as SQLSelect
	PROTECT WhoFrom as STRING
	PROTECT	d_dep:={} as ARRAY
	PROTECT cCurDep as STRING

	DECLARE METHOD AddSubDep
METHOD AddSubDep(ParentNum:=0 as int, nCurrentRec:=0 as int,aItem as array,d_dep as array) as int CLASS TrialBalance
	* Find subdepartments and add to arrays with departments
	local oDep as SQLSelect
	LOCAL nChildRec	as int
	LOCAL nCurNum		as int
	local lFirst		as logic
	
	if Empty(aItem)
		oDep:=SQLSelect{"SELECT depid as itemid, parentdep as parentid	FROM `department` order by deptmntnbr",oConn}
		if oDep:reccount>0
			do while !oDep:EoF
				AAdd(aItem,{oDep:itemid,oDep:parentid}) 
				//           1                 2               
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
	ENDIF
	// add subdepartments:
	nCurNum:= aItem[nCurrentRec,1]
	AAdd(d_dep,aItem[nCurrentRec,1])
	do WHILE true	
		// add child records of this sub department:
		nChildRec:=self:AddSubDep(nCurNum,nChildRec,aItem,d_dep)
		IF Empty(nChildRec)
			exit
		ENDIF
	ENDDO
	
	RETURN nCurrentRec
	
METHOD CancelButton( ) CLASS TrialBalance
	self:endWindow()
	RETURN
	
METHOD Close(oEvent) CLASS TrialBalance
	SUPER:Close(oEvent)
	//Put your changes here
self:Destroy()
	
	RETURN

METHOD DepButton( ) CLASS TrialBalance
	LOCAL cCurValue as STRING
	LOCAL nPntr as int

	cCurValue:=AllTrim(oDCmDepartment:TextValue)
	nPntr:=At(":",cCurValue)
	IF nPntr>1
		cCurValue:=SubStr(cCurValue,1,nPntr-1)
	ENDIF
	(DepartmentExplorer{self:Owner,"Department",WhoFrom,self,cCurValue}):show()
RETURN nil

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS TrialBalance
	LOCAL oControl as CONTROL
	LOCAL lGotFocus as LOGIC
	LOCAL cCurValue as USUAL
	LOCAL nPntr as int
	oControl := iif(oEditFocusChangeEvent == null_object, null_object, oEditFocusChangeEvent:Control)
	lGotFocus := iif(oEditFocusChangeEvent == null_object, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !Departments
		RETURN nil
	ENDIF
	IF !lGotFocus
		IF oControl:NameSym==#mDepartment .and.!AllTrim(oControl:TextValue)==cCurDep
			cCurValue:=AllTrim(oControl:TextValue)
			cCurDep:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindDep(@cCurValue)
				self:RegDepartment(cCurValue,"")
			ELSE
				self:DepButton()
			ENDIF
		ENDIF
	ENDIF
	RETURN nil

METHOD GetBalYears() CLASS TrialBalance
	// get array with balance years
	RETURN GetBalYears()
method Init(oWindow,iCtlID,oServer,uExtra) class TrialBalance 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

super:Init(oWindow,ResourceID{"TrialBalance",_GetInst()},iCtlID)

oDCmDepartment := SingleLineEdit{self,ResourceID{TRIALBALANCE_MDEPARTMENT,_GetInst()}}
oDCmDepartment:HyperLabel := HyperLabel{#mDepartment,null_string,"From Who is it: Department",null_string}
oDCmDepartment:TooltipText := "Enter number or name of required Top of department structure"

oCCDepButton := PushButton{self,ResourceID{TRIALBALANCE_DEPBUTTON,_GetInst()}}
oCCDepButton:HyperLabel := HyperLabel{#DepButton,"v","Browse in Departments",null_string}
oCCDepButton:TooltipText := "Browse in Departments"

oDCYearTrial := ComboBox{self,ResourceID{TRIALBALANCE_YEARTRIAL,_GetInst()}}
oDCYearTrial:FillUsing(self:GetBalYears( ))
oDCYearTrial:HyperLabel := HyperLabel{#YearTrial,null_string,null_string,null_string}

oDCMonthStart := SingleLineEdit{self,ResourceID{TRIALBALANCE_MONTHSTART,_GetInst()}}
oDCMonthStart:HyperLabel := HyperLabel{#MonthStart,null_string,null_string,null_string}
oDCMonthStart:FieldSpec := MonthW{}

oDCMonthEnd := SingleLineEdit{self,ResourceID{TRIALBALANCE_MONTHEND,_GetInst()}}
oDCMonthEnd:HyperLabel := HyperLabel{#MonthEnd,null_string,null_string,null_string}
oDCMonthEnd:FieldSpec := MonthW{}

oDClCondense := CheckBox{self,ResourceID{TRIALBALANCE_LCONDENSE,_GetInst()}}
oDClCondense:HyperLabel := HyperLabel{#lCondense,"Condense",null_string,null_string}

oCCOKButton := PushButton{self,ResourceID{TRIALBALANCE_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",null_string,null_string}

oCCCancelButton := PushButton{self,ResourceID{TRIALBALANCE_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",null_string,null_string}

oDCFixedText1 := FixedText{self,ResourceID{TRIALBALANCE_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Financial year",null_string,null_string}

oDCFixedText2 := FixedText{self,ResourceID{TRIALBALANCE_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"From month:",null_string,null_string}

oDCFixedText3 := FixedText{self,ResourceID{TRIALBALANCE_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"To month:",null_string,null_string}

oDCFixedText4 := FixedText{self,ResourceID{TRIALBALANCE_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Department:",null_string,null_string}

self:Caption := "Trial Balance"
self:HyperLabel := HyperLabel{#TrialBalance,"Trial Balance",null_string,null_string}
self:EnableStatusBar(true)
self:PreventAutoLayout := true

if !IsNil(oServer)
	self:Use(oServer)
endif

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

access lCondense() class TrialBalance
return self:FIELDGET(#lCondense)

assign lCondense(uValue) class TrialBalance
self:FIELDPUT(#lCondense, uValue)
return lCondense := uValue

METHOD ListBoxSelect(oControlEvent) CLASS TrialBalance
	LOCAL oControl as CONTROL
	LOCAL uValue as USUAL
	LOCAL aBal:={} as array
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControlEvent:NameSym==#YearTrial
		uValue:=oControlEvent:CONTROL:Value
		aBal := GetBalYear(Val(SubStr(uValue,1,4)),Val(SubStr(uValue,5,2)))
		MonthStart:=aBal[2]
		MonthEnd:=aBal[4]
	ENDIF
	RETURN nil

access mDepartment() class TrialBalance
return self:FIELDGET(#mDepartment)

assign mDepartment(uValue) class TrialBalance
self:FIELDPUT(#mDepartment, uValue)
return mDepartment := uValue

access MonthEnd() class TrialBalance
return self:FIELDGET(#MonthEnd)

assign MonthEnd(uValue) class TrialBalance
self:FIELDPUT(#MonthEnd, uValue)
return MonthEnd := uValue

access MonthStart() class TrialBalance
return self:FIELDGET(#MonthStart)

assign MonthStart(uValue) class TrialBalance
self:FIELDPUT(#MonthStart, uValue)
return MonthStart := uValue

METHOD OKButton( ) CLASS TrialBalance
LOCAL perlengte,YEARSTART,YEAREND, TrialYear,BalMonth as int
LOCAL nRow, nPage as int
LOCAL CurSt, CurEnd,BalSt, BalEnd, TrialEnd as int
LOCAL omzetdeel, totdeb,totcre, m_bud, omzet, totBegin, totBeginCostProfit,PerDeb,PerCre as FLOAT 
local pl_deb,pl_cre as float // profit loss previous year
LOCAL Heading:={} as ARRAY, ad_banmsg, omztxt as STRING
LOCAL PrvYearNotClosed as LOGIC
LOCAL aDep:={} as ARRAY
LOCAL cType,cSoort as STRING
LOCAL nChildRec			as int
LOCAL Gran as LOGIC
LOCAL cTab:=CHR(9) as STRING  
LOCAL aYearStartEnd:={} as ARRAY
LOCAL aItem:={} as ARRAY
local oMBal as balances
local cStatement as string   // string with selection of accounts and their total values 

* Check input data:
// IF !ValidateControls( self, self:AControls )
// 	RETURN
// END
                                
aYearStartEnd := GetBalYear(Val(SubStr(YearTrial,1,4)),Val(SubStr(YearTrial,5,2)))                              

YEARSTART := aYearStartEnd[1]
TrialYear := YEARSTART
BalMonth  := aYearStartEnd[2]
YEAREND   := aYearStartEnd[3]

IF aYearStartEnd[2] > aYearStartEnd[4] // spanning two calendar years?
	IF MonthStart < aYearStartEnd[2]
		* apparently in next year:
		++YEARSTART
	ENDIF
	IF MonthEnd > aYearStartEnd[4]
		* apparently in previous year:
		--YEAREND
	ENDIF
ENDIF

CurSt  := YEARSTART * 12 + MonthStart
CurEnd := YEAREND * 12 + MonthEnd
BalSt  := TrialYear * 12 + BalMonth
BalEnd := aYearStartEnd[3] * 12 + aYearStartEnd[4]

if CurSt>CurEnd
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

perlengte := YEAREND * 12 + MonthEnd + 1 - (YEARSTART * 12 + MonthStart)

* Check and fill requested Departments:
d_dep := {}
IF Empty(WhoFrom)
	* Top department is WO Office:
	d_dep := {Space(11)}
ELSE
	d_dep:={Val(WhoFrom)}
ENDIF

* Add all subdepartments down from WhoFrom:
aItem:={}
DO WHILE true
	nChildRec := self:AddSubDep(Val(self:WhoFrom),nChildRec,aItem,d_dep)
	IF Empty(nChildRec)
		exit
	ENDIF
ENDDO

aDep:=d_dep
oMBal:=Balances{}
oMBal:AccSelection:=iif(Empty(self:WhoFrom),"","a.department in ("+Implode(d_dep,",")+")")
cStatement := oMBal:SQLGetBalance(YEARSTART * 100 + MONTHSTART, YEAREND * 100 + MONTHEND,true,false,true,true)

oAcc:=SQLSelect{cStatement + " order by category,accnumber",oConn}

* Add balances of accounts to the balance item values: 
oAcc:GoTop() 

* Create name report file
* store 1 TO blad,r
IF lPrint
	oReport := PrintDialog{oParent,self:oLan:RGet('Trial Balance'),,121,,"xls"}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
ENDIF

IF Lower(oReport:Extension) #"xls"
	cTab:=Space(1)
	Heading:={oLan:RGet('Trial Balance',,"!")}
ENDIF
self:Pointer := Pointer{POINTERHOURGLASS}
self:STATUSMESSAGE(self:oLan:WGet("Collecting data, moment please"))

AAdd(Heading,self:oLan:RGet('Account',43,"!")+cTab+self:oLan:RGet('Type',11,"!","C")+cTab+self:oLan:RGet('BEGIN Balnc',11,"!","R")+cTab+self:oLan:RGet('Debit',11,"!","R")+cTab+self:oLan:RGet('Credit',11,"!","R")+;
cTab+self:oLan:RGet('Balance',11,"!","R")+cTab+self:oLan:RGet('Budget',10,"!","R") )
AAdd(Heading,self:oLan:RGet('year',,"!")+cTab+oDCYearTrial:TextValue+;
'  '+maand[MonthStart]+' - '+maand[MonthEnd])
AAdd(Heading,' ')
DO WHILE !oAcc:EoF
	cSoort:= oAcc:category
  	cType:=aBalType[AScan(aBalType,{|x|x[1]=cSoort}),2]
	IF cSoort=="KO" .or. cSoort=="BA"
		PerDeb:=oAcc:per_deb
		PerCre:=oAcc:per_cre
		pl_cre:=Round(pl_cre+oAcc:pl_cre,DecAantal)
		pl_deb:=Round(pl_deb+oAcc:pl_deb,DecAantal)
	ELSE
		// determine sum of transactions by comparing with previous month for balance accounts:
		PerDeb:=Round(oAcc:per_deb - oAcc:PrvPer_deb,DecAantal)
		PerCre:=Round(oAcc:per_cre - oAcc:PrvPer_cre,DecAantal)
	ENDIF
   IF !self:lCondense .or. !PerDeb == PerCre .or. !oAcc:PrvPer_deb == oAcc:PrvPer_cre

      && calcaulate total percentage of everything up till now
      omzet:= PerDeb-PerCre
      IF omzet<> 0
         IF oAcc:category = "BA"
            omzet:=-omzet
         ENDIF
      ENDIF
      omztxt:='    0%'
		m_bud:=oAcc:Yr_Bud
// 		oAcc:Per_Bud
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
      	cTab+PadC(cType,11)+cTab+Str(oAcc:PrvPer_deb-oAcc:PrvPer_cre,11,DecAantal) +;
      	cTab+Str(PerDeb,11,decaantal)+cTab+Str(PerCre,11,decaantal)+;
      	cTab+Str(oAcc:PrvPer_deb-oAcc:prvper_cre+PerDeb-PerCre,11,DecAantal)+;
      	cTab+Str(Round(m_bud,DecAantal),10,DecAantal)+cTab+omztxt,Heading,0)
      ENDIF
      totdeb:=Round(totdeb+PerDeb,DecAantal)
      totcre:=Round(totcre+PerCre,DecAantal)
      totBegin:=Round(totBegin+oAcc:PrvPer_deb-oAcc:prvper_cre,DecAantal)
   	ENDIF

   oAcc:Skip()
ENDDO
IF PrvYearNotClosed .and. (pl_deb#0.or.pl_cre#0) 
	// in case previous year not yet closed add total cost/profit to total as increase of netasset:
	IF lPrint
	   oReport:PrintLine(@nRow,@nPage,oLan:RGet('Balance income and expense prev.year',64,"!");
	   +Replicate(cTab,4)+Str(pl_deb,11,DecAantal)+cTab+Str(pl_cre,11,DecAantal)+;
	   cTab+Str(pl_deb-pl_cre,11,DecAantal),Heading,0)
	ENDIF
    totdeb:=totdeb+Round(pl_deb,DecAantal)
    totcre:=totcre+Round(pl_cre,DecAantal)
ENDIF
totdeb:=Round(totdeb,DecAantal)
totcre:=Round(totcre,DecAantal)
totBegin=Round(totBegin,DecAantal)
IF lPrint
	oReport:PrintLine(@nRow,@nPage,' ',Heading,1)
	oReport:PrintLine(@nRow,@nPage,Space(43)+cTab+Space(11)+cTab+Str(totBegin,11,DecAantal)+cTab+Str(totdeb,11,DecAantal)+;
	cTab+Str(totcre,11,decaantal)+cTab+Str(Round(totBegin+totdeb-totcre,decaantal),11,decaantal),null_array,0)
ENDIF
self:Pointer := Pointer{POINTERARROW}
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
		MonthStart := aYearStartEnd[2]
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

	
	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS TrialBalance
	//Put your PreInit additions here
	// oMBal:=MBalance{,DBSHARED,DBREADONLY}
	RETURN nil
METHOD RegDepartment(myNum,myItemName) CLASS TrialBalance
	local oDep as SQLSelect
	Default(@myItemName,null_string)
	IF !myNum==self:WhoFrom
		self:WhoFrom:=myNum
		IF Empty(self:WhoFrom) .or.self:WhoFrom='0'
			self:cCurDep:="0:"+sEntity+" "+sLand
			self:mDepartment:=cCurDep
			self:oDCmDepartment:TextValue:=cCurDep
		ELSE
			oDep:=SQLSelect{"select deptmntnbr,descriptn from department where depid='"+self:WhoFrom+"'",oConn}
			if oDep:RecCount>0  
				self:cCurDep:=AllTrim(oDep:deptmntnbr)+":"+oDep:descriptn
				self:mDepartment:=self:cCurDep
				self:oDCmDepartment:TextValue:=self:cCurDep
			ENDIF
		ENDIF
	ENDIF
RETURN

access YearTrial() class TrialBalance
return self:FIELDGET(#YearTrial)

assign YearTrial(uValue) class TrialBalance
self:FIELDPUT(#YearTrial, uValue)
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
RESOURCE YearClosing DIALOGEX  16, 14, 278, 88
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"OK", YEARCLOSING_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 206, 14, 53, 12
	CONTROL	"Cancel", YEARCLOSING_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 204, 36, 53, 13
	CONTROL	"Balance Year:", YEARCLOSING_FIXEDTEXT2, "Static", WS_CHILD, 22, 19, 64, 13
	CONTROL	"", YEARCLOSING_STARTYEARTEXT, "Static", WS_CHILD, 77, 19, 109, 13
END

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
	local cMess as string
	local dLstReeval as date 
	local cFatalError as string

	IF Today() <= self:BalanceEndDate
		(ErrorBox{self:OWNER,self:oLan:WGet('End of year not yet reached')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF
	self:Pointer := Pointer{POINTERHOURGLASS}
	if !Empty(SPROJ)
		* Are there still non-earmarekd gifts?
		if SQLSelect{"select transid from transaction where bfm='O' and cre>deb and dat <='"+SQLdate(self:BalanceEndDate)+"' and accid='"+SPROJ+"'",oConn}:reccount>0
			(ErrorBox{self:OWNER,self:oLan:WGet('Allot first non-designated gifts in year')+':'+YearBalance}):Show()
			self:EndWindow()
			RETURN true
		ENDIF
	endif
	if Posting
		oSel:=SqlSelect{"select count(*) as tot from transaction where poststatus<2 and dat<'"+SQLdate(self:BalanceEndDate)+"'",oConn}
		if oSel:reccount>0 .and.ConI(oSel:tot)>0
			ErrorBox{self,ConS(oSel:tot)+' '+self:oLan:WGet("transactions")+' '+self:oLan:WGet("before")+' '+DToC(self:BalanceEndDate)+' '+ self:oLan:WGet("are still to be posted")}:Show()
			self:EndWindow()
			return false
		endif
	endif
	IF Empty(sCURR) 
		(ErrorBox{self:OWNER,self:oLan:WGet('First specify the currency in System parameters')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF
	self:Pointer := Pointer{POINTERHOURGLASS}

	* Are there gifts to be send to PMC?
	oMainwindow:STATUSMESSAGE("Checking data...")
	if ADMIN=='WO' 
		oTrans:=SQLSelect{"select t.transid,t.dat,t.description from transaction t "+;
		"where t.bfm='' and t.gc<>'' and t.dat<='"+SQLdate(self:BalanceEndDate)+"' and "+; 
		"exists (select 1 from member m left join department d on (m.depid=d.depid) where m.householdid<>'' and grade<>'staf' and (m.accid=t.accid or t.accid in (d.incomeacc,d.expenseacc,d.netasset)))  ";
		,oConn}
		if oTrans:reccount>0
			do while !oTrans:EOF
				self:cError+=CRLF+'Trnsnr '+Str(oTrans:TransId,-1)+' with date '+DToC(oTrans:dat)+': '+oTrans:Description +CRLF
				oTrans:skip()
			enddo
			ErrorBox{self:OWNER,self:oLan:WGet("The following transactions have to be send to PMC first")+":"+self:cError}:Show()
			self:EndWindow()
			return true
		endif
	endif
	self:Pointer := Pointer{POINTERHOURGLASS}

	// Check if all reevaluations has been done:
	dLstReeval:=SQLSelect{"select lstreeval from sysparms",oConn}:LSTREEVAL 
	if dLstReeval <  self:BalanceEndDate 
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
	oMainwindow:STATUSMESSAGE("Collecting data...")
	self:Pointer := Pointer{POINTERHOURGLASS}
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
   	// Check consistency data
	if !CheckConsistency(oMainwindow,true,false,@cFatalError)
		ErrorBox{self,cFatalError}:Show()
		self:EndWindow()
		RETURN true
	ENDIF

// 	oWarn := WarningBox{self:OWNER,self:oLan:WGet("Year Balancing"),self:oLan:WGet('Have you backed up your data')+'?'}
// 	oWarn:Type := BOXICONQUESTIONMARK + BUTTONYESNO
// 	IF (oWarn:Show() = BOXREPLYNO)
// 		self:EndWindow()
// 		RETURN true
// 	ENDIF
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
		if TextBox{self:OWNER,self:oLan:WGet("Year closing"),self:oLan:WGet("following employees are still in the system")+":"+cWarning,BUTTONRETRYCANCEL+BOXICONHAND}:Show()=BOXREPLYRETRY 
			oSel:Execute()  // reread
			oSel:Gotop()
		else
			return
		endif
	enddo
	self:Pointer := Pointer{POINTERHOURGLASS}
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

	self:OWNER:STATUSMESSAGE(self:oLan:WGet("Closing balance data, please wait")+"...")
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
						SQLStatement{"rollback",oConn}:Execute()
						self:Pointer := Pointer{POINTERARROW}
						(ErrorBox{self:OWNER,self:cError}):Show()
						return
					endif
				endif
			else
				self:cError:=self:oLan:WGet("could	not update accountbalanceyear")+":"+oMBal:ACCNUMBER+"	- "+oMBal:Description 
				LogEvent(self,self:cError+"; statement:"+oStmnt:SQLString+CRLF+"Error:"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
				SQLStatement{"rollback",oConn}:Execute()
				self:Pointer := Pointer{POINTERARROW}
				(ErrorBox{self:OWNER,self:cError}):Show()
				return
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
			SQLStatement{"rollback",oConn}:Execute()
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
			",description='"+self:oLan:RGet('Closing year',,"!")+'	'+self:oDCStartYearText:TEXTvalue+"'"+; 
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
	cName:= 'tr'+Str(self:YearStart,4)+StrZero(self:MonthStart,2)
	oStmnt:=SQLStatement{"create table "+cName+" (primary key (transid,seqnr)) engine=InnoDb collate utf8_unicode_ci select * from transaction where dat<='"+SQLdate(self:BalanceEndDate)+"'",oConn} 
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
		LogEvent(self,self:oLan:WGet("year balancing and closing"),self:oLan:WGet("Year")+Space(1)+self:YearBalance+Space(1)+self:oLan:WGet("successfully closed"))
		LstYearClosed	:=self:BalanceEndDate+1
	else
		TextBox{self,self:oLan:WGet("year balancing and closing"),self:oLan:WGet("Year")+space(1)+self:YearBalance+space(1)+self:oLan:WGet("not closed")}:Show()
		return		
	endif
	InitGlobals()
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
	LOCAL subDepPtr as int
	LOCAL min_balance, PL_totdeb, PL_totcre as FLOAT
	local cStatement as string
	local oStmnt as SQLStatement

	subDepPtr:=0
	DO WHILE true
		subDepPtr:=AScan(self:d_parentdep,self:d_dep[p_depptr],subDepPtr+1)
		IF Empty(subDepPtr)
			exit
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
				",description='"+self:oLan:RGet('Closing year',,"!")+'	'+self:oDCStartYearText:TEXTvalue+"'"+; 
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
						cTransnr:=ConS(SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
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