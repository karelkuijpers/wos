define asset:="AK"
class Balances
	* Result from getbalance are returned here
	EXPORT per_deb as FLOAT  //calculated debit balance over period
	EXPORT per_cre as FLOAT   //calculated credit balance over period
	EXPORT begin_deb as FLOAT  //calculated begin  debit balance
	EXPORT begin_cre as FLOAT   //calculated begin credit balance
	EXPORT vorig_deb as FLOAT //calculated debit balance previous period in yearstart
	EXPORT vorig_cre as FLOAT //calculated credit balance previous period in yearstart
	EXPORT vjr_deb as FLOAT   //calculated debit balance previous year
	EXPORT vjr_cre  as FLOAT  //calculated credit balance previous year
//	Idem for foreign currency
	EXPORT per_debF as FLOAT  //calculated debit balance over period
	EXPORT per_creF as FLOAT   //calculated credit balance over period
	EXPORT begin_debF as FLOAT  //calculated begin  debit balance
	EXPORT begin_creF as FLOAT   //calculated begin credit balance
	EXPORT vorig_debF as FLOAT //calculated debit balance previous period in yearstart
	EXPORT vorig_creF as FLOAT //calculated credit balance previous period in yearstart
	EXPORT vjr_debF as FLOAT   //calculated debit balance previous year
	EXPORT vjr_creF  as FLOAT  //calculated credit balance previous year
	EXPORT cRubrSoort as STRING // Classification of corresponding balance item
	
	protect cAccSelection as string  
	
	declare method GetBalance,SQLGetBalance
	
	assign AccSelection(uValue) class Balances
	self:cAccSelection:=uValue
	return self:cAccSelection
METHOD GetBalance( pAccount as string ,ptype as string ,pPeriodStart:=nil as usual ,pPeriodEnd:=nil as usual, pCurrency:='' as string) as void pascal CLASS Balances
	******************************************************************************
	*  Name      : GetBalance
	*              Calculation of balance values of a account during a certain period
	*  Author    : K. Kuijpers
	*  Date      : 11-12-2010
	******************************************************************************

	************** PARAMETERS and DECLARATION OF VARIABLEs ***********************
	*
	* pAccount     : accountId (string)
	* pType        : type of the related balance item
	* pPeriodStart : year and month, at which the required period starts; default: First month of the current balance year
	*              : it is possible that this value is filled with a specific date in case a date within a month is needed.
	* pPeriodEnd   : year and month, at which the required period ends;  default: today + 31 days
	*              : it is also possible that this value is filled with a specific date
	*
	* There are three periods during which balance values are calculated:
	* 1. Required period determined by pPeriodStart and pPeriodEnd
	* 2. Previous period in the balance year of pPeriodStart from first month of this year until pPeriodStart
	* 3. Previuos year: the balance year before the balance year of pPeriodStart
	*
	* Illustrated as follows:
	*
	*                         |---- previous year---|prev.period |--- required period ---|
	*                         |                     |            |                       |
	*                         |                     |            |                       |
	* --+---------------------+---------------------+---------------------+---------------------+--
	*   .                     .                     .                   ^ .                     .
	*   .   balance year 1    .   balance year 2    .    balance year 3 | .    balance year 4   .
	*                         ^                                         |
	*                         |                                         |
	*                     last close(e.g.)                            budget
	*
	* Returned are as export variables of own class:
	* per_deb (+per_debF)		: calculated debit balance value during required period  (+ foreign currency)
	* per_cre (+per_creF)  		: idem for credit
	* begin_deb (+self:begin_debF)	: calculated debit balance value at begin of required period
	* begin_cre (+self:begin_creF)	: idem for credit
	* vjr_deb (+self:vjr_debF)  		: calculated debit balance value during previous year
	* vjr_cre (+self:vjr_creF)  		: idem for credit
	* All these values have the following meaning:
	* in case of Cost/profit       : sum of transactions during the specifief period,
	* in case of liabilities/assets: actual balance value at end of the specified period)
	*
	**************
	*
	LOCAL CurrStartYear, CurrStartMonth as int // variables for stepping through years and months
	LOCAL PrevPeriodStart as int// start of previous period as number of months since year zero
	LOCAL PeriodStartYear, PeriodStartMonth   // start of requested period in years and months
	LOCAL PeriodStart as int // Idem but as number of months since year zero
	LOCAL PeriodEndYear, PeriodEndMonth as int // end of requested period in years and months
	LOCAL PeriodEnd as int // Idem but as number of months since year zero
	LOCAL LastClose as int // moment of last closing of balance year in number of months since year zero
	LOCAL CurrMonth as int // Current month during processing in number of months since year zero
	LOCAL lCostProfit as LOGIC // Is account a Cost or profit account: true
	LOCAL nState:=1 as int // State of proces: previous Year, previous period, required period
	LOCAL oAccBal as SQLSelect
	local oMBal as SQLSelect 
	local oTrans as SQLSelect
	local cTransSelect as string
	local YearBeginEnd:={} as array //{year start, monthstart, year end, month end}
	local per_deb,per_debF,per_cre,per_creF,month_deb,month_cre,month_debF,month_creF as float
	local cStatement as string 

	if Empty(pCurrency)
		pCurrency:=sCURR
	endif 
	// per_deb:=0
	// per_cre:=0
	// self:vorig_deb:=0
	// self:vorig_cre:=0
	// self:vjr_deb:=0
	// self:vjr_cre:=0
	LastClose := Round(Year(MinDate)*12,0)+Month(MinDate)
	*
	* Determine required period from inputparameters:
	*
	IF pPeriodEnd==nil
		PeriodEndMonth:=Month(Today()+31)
		PeriodEndYear:=Year(Today()+31)
	ELSEIF IsDate(pPeriodEnd)
		PeriodEndMonth:=Month(pPeriodEnd)
		PeriodEndYear:=Year(pPeriodEnd)
	ELSE
		PeriodEndMonth:= Round(pPeriodEnd,0)%100
		PeriodEndYear:=Round((pPeriodEnd - PeriodEndMonth)/100,0)
	ENDIF
	IF pPeriodStart==nil
		* default first month of current balance year:
		* determine start of balance year of enddate:
		YearBeginEnd:=GetBalYear(PeriodEndYear,PeriodEndMonth)
		PeriodStartMonth := YearBeginEnd[2]
		PeriodStartYear:=YearBeginEnd[1]
	ELSEIF IsDate(pPeriodStart)
		PeriodStartMonth:=Month(pPeriodStart)
		PeriodStartYear:=Year(pPeriodStart)
	ELSE
		PeriodStartMonth:= Round(pPeriodStart,0)%100
		PeriodStartYear:=Round((pPeriodStart - PeriodStartMonth)/100,0)
	ENDIF
	PeriodStart := Round(PeriodStartYear*12+ PeriodStartMonth,0)
	PeriodEnd   := Round(PeriodEndYear*12+ PeriodEndMonth,0)
   if pAccount="100762"
   	pAccount:=pAccount
   endif
   self:cAccSelection:=" a.accid='"+pAccount+"'"
   cStatement:= self:SQLGetBalance(PeriodStartYear*100+ PeriodStartMonth, PeriodEndYear*100+PeriodEndMonth-;
	iif(IsDate(pPeriodEnd) .and.pPeriodEnd<EndOfMonth(pPeriodEnd),1,0))
	oAccBal:=SQLSelect{cStatement,oConn}
	if !Empty(oAccBal:Status).or.oAccBal:RecCount<1
		LogEvent(,"Error in Getbalance:"+oAccBal:errinfo:errormessage+CRLF+"account:"+pAccount+"cStatement:"+cStatement,"logerrors")
		return
	endif
	
	self:per_deb:=oAccBal:per_deb
	self:per_cre:=oAccBal:per_cre
	self:vjr_deb:=oAccBal:PrvYrYtD_deb
	self:vjr_cre:=oAccBal:PrvYrYtD_cre
// 	self:vorig_deb:=oAccBal:PrvYr_deb
// 	self:vorig_cre:=oAccBal:PrvYr_cre
	self:begin_deb:=oAccBal:PrvPer_deb
	self:begin_cre:=oAccBal:PrvPer_cre
	if !pCurrency=sCURR
		self:per_debF:=oAccBal:per_debF
		self:per_creF:=oAccBal:per_creF
		self:vjr_debF:=oAccBal:PrvYrYtD_debF
		self:vjr_creF:=oAccBal:PrvYrYtD_creF
// 		self:vorig_debF:=oAccBal:PrvYr_debF
// 		self:vorig_creF:=oAccBal:PrvYr_creF
		self:begin_debF:=oAccBal:PrvPer_debF
		self:begin_creF:=oAccBal:PrvPer_creF
	endif
	if	IsDate(pPeriodEnd).and.pPeriodEnd < SToD(Str(PeriodEndYear,4)+StrZero(PeriodEndMonth,2)+;
		Str(MonthEnd(PeriodEndMonth,PeriodEndYear),2))
		* Before	ultimo of the month?
		* Calculate	sum of transactions in last month: 
		cTransSelect:=UnionTrans("select	Round(sum(t.deb),2) as monthdeb,Round(sum(t.cre),2) as monthcre,"+;
			"Round(sum(t.debforgn),2) as monthdebf,Round(sum(t.creforgn),2) as monthcref from transaction as t	"+;
			"where t.DAT>='"+Str(PeriodEndYear,4)+"-"+StrZero(PeriodEndMonth,2)+"-01' and	t.DAT<='"+SQLdate(pPeriodEnd)+"'	and t.accid='"+pAccount+"'") 
		oTrans:=SQLSelect{cTransSelect,oConn}
		if	Empty(oTrans:Status)	.and.	oTrans:RecCount=1
			if	!Empty(oTrans:monthdeb)
				self:per_deb :=Round(self:per_deb+oTrans:monthdeb, DecAantal)
			endif
			if	!Empty(oTrans:monthcre)
				self:per_cre :=Round(self:per_cre+oTrans:monthcre, DecAantal)
			endif
			if	!pCurrency=sCURR
				if	!Empty(oTrans:monthdebf)
					self:per_debF	:=Round(self:per_debF+oTrans:monthdebf, DecAantal)
				endif
				if	!Empty(oTrans:monthcref)
					self:per_creF	:=Round(self:per_creF+oTrans:monthcref, DecAantal)
				endif							
			endif
		endif
	endif

	RETURN

Method SQLGetBalance( dPeriodStart:=0 as int ,dPeriodEnd:=0 as int,lPrvYrYtD:=false as logic, lForeignCurr:=false as logic, lBudget:=false as logic, lDetails:=false as logic ) as string class Balances 
	******************************************************************************
	*  Name      : SQLGetBalance
	*              Generate SQL code for calculation of balance values of selected accounts during a certain period 
	*					Used aliasses for tables: account a, balance item b, mbalance mb
	*  Author    : K. Kuijpers
	*  Date      : 29-11-2010
	******************************************************************************

	************** PARAMETERS and DECLARATION OF VARIABLEs ***********************
	*
	* dPeriodStart : year and month, at which the required period starts; default: First month of the current balance year
	* dPeriodEnd   : year and month, at which the required period ends;  default: today + 31 days
	* cAccSelection: criteria to select accounts e.g. a.department in(..,..,...) and a.balitemid in (..,..,..) (in self:cAccSelection) 
	* lPrvYrYtD		: if true also PrvYrAfterYtD_deb and PrvYrAfterYtD_cre are returned 
	* lForeignCurr	: if true _debF and _creF values are also returned from the SQLSelect
	* lBudget		; if true return also fields with budget values PrvPer_bud, Per_bud, Yr_bud from the SQLSelect
	* lDetails		: if true return also account values accnumber and description from the SQLSelect 
	*
	* There are three periods during which balance values are calculated:
	* 1. Required period determined by dPeriodStart and dPeriodEnd
	* 2. Previous period in the balance year of dPeriodStart from first month of this year until dPeriodStart
	* 3. Previuos year: the balance year before the balance year of dPeriodStart
	*
	* Illustrated as follows:
	*
	*                         |---- previous year---|prev.period |--- required period ---|
	*                         |                     |            |                       |
	*                         |                     |            |                       |
	* --+---------------------+---------------------+---------------------+---------------------+--
	*   .                     .                     .                   ^ .                     .
	*   .   balance year 1    .   balance year 2    .    balance year 3 | .    balance year 4   .
	*                         ^                                         |
	*                         |                                         |
	*                     last close(e.g.)                            budget
	*
	* Returned: array with the following string values:
	* - cFields:	fields to select
	* - cFrom:		tables to retrieve
	* - cWhere:		selection values
	* - cGroup:		grouping values
	* 
	* Generated SQL retrieves the following values:
	* per_deb (+per_debF)			: calculated debit balance value during required period  (+ foreign currency)
	* per_cre (+per_creF)  			: idem for credit
	* PrvPer_deb (+PrvPer_debF)	: calculated debit balance value at begin of previous period
	* PrvPer_cre (+PrvPer_creF)	: idem for credit
	* PrvYr_deb (+PrvYr_debF)  	: calculated debit balance value during previous year
	* PrvYr_cre (+PrvYr_creF)  	: idem for credit
	* Optional:
	* If lPrvYrYtD true: 
	* - PrvYrYtD_deb,PrvYrYtD_cre: previous year YtD 
	* - PL_deb (PL_debF)	: Profit/Loss from previous year to add to netasset accounts 
	* - PrvYrPL_deb (PrvYrPL_debF)	: Profit/Loss from year before previous year to add to balances of previous year of net aset accounts 
	*                                  (If year before previous year not closed)  
	* if lBudget true:
	* - PrvPer_bud		: budget during prev.period
	* - Per_bud			: budget during required period 
	* - Yr_bud				: budget during whole balance year
	* accnumber and description of account   
	* All these values have the following meaning:
	* in case of Cost/profit       : sum of transactions during the specifief period,
	* in case of liabilities/assets: actual balance value at end of the specified period)   
	*
	* CALCULATION
	* PrvYr_deb/cre: if previous year closed: svjc/d from Accountbalanceyear of balance year required period starts with
	*                else: if Cost/profit: total of mbalance from previous year, else: svjc/d of Accountbalanceyear of MinDate + 
	*                                                                                  total of mbalance up till including previous year
	* PrvYrYtD_deb/cre: if Cost/profit: total of mbalance from same yeartodate period during previous year as required period
	*                   else: svjc/d from last available accountbalanceyear of previous year or earlier + 
	* 									total of mbalance from same yeartodate period during previous year as required period	* 
	* Thus needed accountbalanceyear: 
	*		if previous year closed:	year/month of required balance year 3 or one year before
	*		else:								year/month of Mindate							
	**************
	*
	LOCAL CurrStartYear, CurrStartMonth as int // variables for stepping through years and months
	LOCAL PrvYearStartYr,PrvYearStartMn as int // starting year and month of previous year for assets and libalities 
	LOCAL PrevPeriodStart as int// start of previous period as number of months since year zero
	LOCAL PeriodStartYear, PeriodStartMonth   // start of requested period in years and months
	LOCAL PeriodStart as int // Idem but as number of months since year zero
	LOCAL PeriodEndYear, PeriodEndMonth as int // end of requested period in years and months
	LOCAL PeriodEnd as int // Idem but as number of months since year zero
	LOCAL LastClose as int // moment of last closing of balance year in number of months since year zero
	LOCAL CurrMonth as int // Current month during processing in number of months since year zero
	LOCAL lCostProfit as LOGIC // Is account a Cost or profit account: true
	LOCAL nState:=1 as int // State of proces: previous Year, previous period, required period
	LOCAL oAccBal as SQLSelect
	local oMBal as SQLSelect 
	local oTrans as SQLSelect
	local cTransSelect as string
	local YearBeginEnd:={} as array //{year start, monthstart, year end, month end}
	local PrvYearBeginEnd:={} as array //{previous year start, monthstart, year end, month end}
	local per_deb,per_debF,per_cre,per_creF,month_deb,month_cre,month_debF,month_creF as float
	local cFields, cFrom, cWhere, cGroup as string
	local cPrvYrCondition as string  // condition to select mbalance row into sum of Previous Year 
	local cPrvYrYtDCondition as string  // condition to select mbalance row into sum of Previous YtD Year 
	local cPLCondition as string  // condition to select mbalance row into sum of profit/loss Previous Year 
	local cPrvYrPLCondition as string  // condition to select mbalance row into sum of profit/loss Year before previous Year 
	local cPrvPerCondition as string  // condition to select mbalance row into sum of Previous Period 
	local cPerCondition as string  // condition to select mbalance row into sum of Required Period 
	local cPrvPerConditionBud as string  // condition to select budget row into sum of Previous Period 
	local cPerConditionBud as string  // condition to select budget row into sum of Required Period 
	local cYrConditionBud as string  // condition to select budget row into sum of balance year 
	local cmBalCondition as string  // condition to select mbalance mb 
	local cConditionAccBalYr as string // condition to select accountbalanceyear ay
	local cAccBalYrCondition as string  // condition to select accountbalanceyear into sum balance year 2
	local cAccBalYrYtDCondition as string // condition to select accountbalanceyear into sum balance year 3
	local cBudgetCondition as string // condition to select budget 
	local cStandardCurrCond,cNonStandardCurrCond as string // condition selecting standard and non standard currency
	local PrvYearNotClosed as logic
	local YearBeforePrvNotClosed as logic
	local cStatement as string
	local cSelectx,cSelecty,cSelectz as string 

	LastClose := Round(Year(MinDate)*12,0)+Month(MinDate) 
	*
	* Determine required period from inputparameters:
	*
	IF Empty(dPeriodEnd)
		PeriodEndMonth:=Month(Today()+31)
		PeriodEndYear:=Year(Today()+31)
	ELSE
		PeriodEndMonth:= Round(dPeriodEnd,0)%100
		PeriodEndYear:=Round((dPeriodEnd - PeriodEndMonth)/100,0)
	ENDIF
	IF Empty(dPeriodStart)
		* default first month of current balance year:
		* determine start of balance year of enddate:
		YearBeginEnd:=GetBalYear(PeriodEndYear,PeriodEndMonth)
		PeriodStartMonth := YearBeginEnd[2]
		PeriodStartYear:=YearBeginEnd[1]
	ELSE
		PeriodStartMonth:= Round(dPeriodStart,0)%100
		PeriodStartYear:=Round((dPeriodStart - PeriodStartMonth)/100,0)
	ENDIF
	PeriodStart := Round(PeriodStartYear*12+ PeriodStartMonth,0)
	PeriodEnd   := Round(PeriodEndYear*12+ PeriodEndMonth,0)


	* Determine start and enddate of the previous year, previous period and moment
	* to start stepping through the months (CurrrStart):

	*	Determine start of corresponding balance year:
	YearBeginEnd:=GetBalYear(PeriodStartYear,PeriodStartMonth)
	CurrStartYear := YearBeginEnd[1]
	CurrStartMonth:= YearBeginEnd[2]
	PrvYearBeginEnd:=GetBalYear(CurrStartYear-1,CurrStartMonth)
	PrevPeriodStart:=Integer(CurrStartYear*12)+CurrStartMonth  // i.e. beginning of corresponding balance year
	PrvYearNotClosed:=(PrevPeriodStart>LastClose)
	YearBeforePrvNotClosed:=((PrvYearBeginEnd[1]*12+PrvYearBeginEnd[2])>LastClose)

	IF PrvYearNotClosed
		*	start at first non closed year to cumulate from last svjd/c for assets/liability:
		PrvYearStartYr:=Year(MinDate)
		PrvYearStartMn:=Month(MinDate)
	else
		PrvYearStartYr:=CurrStartYear
		PrvYearStartMn:=CurrStartMonth
	endif
	// condition for selecting mbalance into sum previous year:
	if PrvYearStartYr==CurrStartYear-1 .and.PrvYearStartMn==CurrStartMonth
		// same period for costprofit as assets/liablities:
		cPrvYrCondition:="if((mb.year*12+mb.month) between "+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+" and "+Str(PrevPeriodStart-1,-1)
	elseIF PrvYearNotClosed  // get also mbalance for previous year 
		cPrvYrCondition:="if((mb.year*12+mb.month) between if(x.category between '"+income+"' and '"+expense+"',"+;
			Str((CurrStartYear-1)*12+CurrStartMonth,-1)+","+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+") and "+Str(PrevPeriodStart-1,-1)			
	else
		// no mbalance needed for (last year balance in Accountbalanceyear):
		cPrvYrCondition:="if(mb.year<0"      // always false
	endif
	// condition for selecting mbalance into sum last months for previous YtD year: 
	if lPrvYrYtD
		if PrvYearNotClosed
			cPrvYrYtDCondition:="if((mb.year*12+mb.month) between if(x.category between '"+income+"' and '"+expense+"',"+;
			Str((CurrStartYear-1)*12+CurrStartMonth,-1)+","+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+") and "+Str(PeriodEnd-12,-1)			
			cPLCondition:="if((mb.year*12+mb.month) between "+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+" and "+Str(PrevPeriodStart-1,-1)+;
			" and category between '"+income+"' and '"+expense+"'"
			if YearBeforePrvNotClosed 
				cPrvYrPLCondition:="if((mb.year*12+mb.month) between "+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+" and "+Str(PrvYearBeginEnd[1]*12+PrvYearBeginEnd[2]-1,-1)+;
				" and category between '"+income+"' and '"+expense+"'"
			else
				cPrvYrPLCondition:="if(mb.year<0"      // always false  // not needed			
			endif
		else
			cPrvYrYtDCondition:="if((mb.year*12+mb.month) between "+Str(PrvYearBeginEnd[1]*12+PrvYearBeginEnd[2],-1)+" and "+Str(PeriodEnd-12,-1)
			cPLCondition:="if((mb.year*12+mb.month) between "+Str(PrvYearBeginEnd[1]*12+PrvYearBeginEnd[2],-1)+" and "+Str(PrevPeriodStart-1,-1)+;
			" and category between '"+income+"' and '"+expense+"'"
			cPrvYrPLCondition:="if(mb.year<0"      // always false  // not needed
		endif
		if lForeignCurr
			cPLCondition+=" and mb.currency='"+sCURR+"'"
			cPrvYrPLCondition+=" and mb.currency='"+sCURR+"'"
		endif
	endif
	
	// condition for selecting mbalance into sum previous period: 
	if PrevPeriodStart=PeriodStart   
		// no previous period
		cPrvPerCondition:="if(mb.year<0"      // always false
	else
		cPrvPerCondition:="if((mb.year*12+mb.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(PeriodStart-1,-1)						
	endif
	if lForeignCurr
		cPrvPerCondition+=" and mb.currency='"+sCURR+"'"
	endif

	// condition for selecting mbalance mb:
	IF PrvYearNotClosed 
		cmBalCondition:="(mb.year*12+mb.month) between "+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+" and "+Str(PeriodEnd,-1)			
	elseif lPrvYrYtD
		cmBalCondition:="(mb.year*12+mb.month) between "+Str(PrvYearBeginEnd[1]*12+PrvYearBeginEnd[2],-1)+" and "+Str(PeriodEnd,-1)				
	else
		// only balance years of required period:
		cmBalCondition:="(mb.year*12+mb.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(PeriodEnd,-1)						
	endif
	if !lForeignCurr
		cmBalCondition+=" and mb.currency='"+sCURR+"'"
	endif
	
	cPerCondition:="if((mb.year*12+mb.month) between "+Str(PeriodStart,-1)+" and "+Str(PeriodEnd,-1)

	if lBudget
		// condition for selecting budget:
		cBudgetCondition:="(bu.year*12+bu.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(PeriodEnd,-1)						
		// condition for selecting budget into sum previous period: 
		if PrevPeriodStart=PeriodStart   
			// no previous period
			cPrvPerConditionBud:="if(bu.year<0"      // always false
		else
			cPrvPerConditionBud:="if((bu.year*12+bu.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(PeriodStart-1,-1)						
		endif
		cPerConditionBud:="if((bu.year*12+bu.month) between "+Str(PeriodStart,-1)+" and "+Str(PeriodEnd,-1)
		// condition for selecting budget into sum balance year: 
		cYrConditionBud:="if((bu.year*12+bu.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(PeriodEnd,-1)							
	endif

	// condition for selecting accountbalanceyear ay: 
	IF PrvYearNotClosed
		// go to last closed year for assets/liabilities
		cConditionAccBalYr:="ay.yearstart="+Str(PrvYearStartYr,-1)+" and ay.monthstart="+Str(PrvYearStartMn,-1) +" and (b.category='"+LIABILITY+"' or b.category='"+ASSET+"')"
	else
		// Previous year and current year contain balances of year before: 
		cConditionAccBalYr:="ay.yearstart between "+Str(CurrStartYear-1,-1)+" and "+Str(CurrStartYear,-1) 		
	endif
	if !lForeignCurr
		cConditionAccBalYr+=" and ay.currency='"+sCURR+"'"
	endif

	// condition for selecting accountbalanceyear into sum of balance year 3: 
	IF PrvYearNotClosed
		// go to last closed year for assets/liabilities
		cAccBalYrCondition:="ay.yearstart="+Str(PrvYearStartYr,-1)+" and ay.monthstart="+Str(PrvYearStartMn,-1) +" and (b.category='"+LIABILITY+"' or b.category='"+ASSET+"')"
	else
		// current year contains balances of previous year:
		cAccBalYrCondition:="ay.yearstart="+Str(CurrStartYear,-1)+" and ay.monthstart="+Str(CurrStartMonth,-1) 		
	endif
// 	cAccBalYrCondition+=" and ay.currency='"+sCURR+"'"

	// condition for selecting accountbalanceyear into sum of balance year 2: 
	IF PrvYearNotClosed
		// go to last closed year for assets/liabilities
		cAccBalYrYtDCondition:="ay.yearstart="+Str(PrvYearStartYr,-1)+" and ay.monthstart="+Str(PrvYearStartMn,-1) +" and (b.category='"+LIABILITY+"' or b.category='"+ASSET+"')"
	else
		// Previous year contains balances of year before: 
		cAccBalYrYtDCondition:="ay.yearstart="+Str(CurrStartYear-1,-1)+" and ay.monthstart="+Str(CurrStartMonth,-1)+" and (b.category='"+LIABILITY+"' or b.category='"+ASSET+"')" 		
	endif
	if lForeignCurr
		cStandardCurrCond:=" and ay.currency='"+sCURR+"'"
		cNonStandardCurrCond:=" and ay.currency<>'"+sCURR+"'"
	else
		cStandardCurrCond:=""
	endif  
	// cSelectx: Center select on account a and accountbalanceyear ay
	cSelectx:="select a.accid,a.balitemid,a.currency,a.department"+iif(lDetails,",a.accnumber,a.description","")+",b.category"+;
	",sum(IF("+cAccBalYrYtDCondition+cStandardCurrCond+",ay.svjd,0)) as svjdyr2,sum(IF("+cAccBalYrYtDCondition+cStandardCurrCond+",ay.svjc,0)) as svjcyr2"+;
	",sum(IF("+cAccBalYrCondition+cStandardCurrCond+",ay.svjd,0)) as svjdyr3,sum(IF("+cAccBalYrCondition+cStandardCurrCond+",ay.svjc,0)) as svjcyr3"+;
	iif(lForeignCurr,;
	",sum(IF("+cAccBalYrYtDCondition+cNonStandardCurrCond+",ay.svjd,0)) as svjdyr2f,sum(IF("+cAccBalYrYtDCondition+cNonStandardCurrCond+",ay.svjc,0)) as svjcyr2f"+;
	",sum(IF("+cAccBalYrCondition+cNonStandardCurrCond+",ay.svjd,0)) as svjdyr3f,sum(IF("+cAccBalYrCondition+cNonStandardCurrCond+",ay.svjc,0)) as svjcyr3f","")+;
	" from (account a, balanceitem b) left join accountbalanceyear ay ON (ay.accid=a.accid and "+cConditionAccBalYr+")"+;   
	" where a.balitemid=b.balitemid"+iif(Empty(self:cAccSelection),""," and "+self:cAccSelection)+" group by a.accid" 
	
	// cSelecty: 2e level select on x and mbalance mb
	if lForeignCurr
		cStandardCurrCond:=" and mb.currency='"+sCURR+"'"
		cNonStandardCurrCond:=" and mb.currency<>'"+sCURR+"'"
	else
		cStandardCurrCond:=""
	endif  
	cSelecty:="select x.*,"+;   
	"sum("+cPrvYrCondition+cStandardCurrCond+",mb.deb,0)) as prvyr_deby,sum("+cPrvYrCondition+cStandardCurrCond+",mb.cre,0)) as prvyr_crey,"+;
	"sum("+cPrvPerCondition+cStandardCurrCond+",mb.deb,0)) as prvper_deby,sum("+cPrvPerCondition+cStandardCurrCond+",mb.cre,0)) as prvper_crey," +;
	"sum("+cPerCondition+cStandardCurrCond+",mb.deb,0)) as per_deby,sum("+cPerCondition+cStandardCurrCond+",mb.cre,0)) as per_crey"+;
	iif(lPrvYrYtD,",sum("+cPrvYrYtDCondition+cStandardCurrCond+",mb.deb,0)) as prvyrytd_deby,sum("+cPrvYrYtDCondition+cStandardCurrCond+",mb.cre,0)) as prvyrytd_crey",",0.00 as prvyrytd_deby,0.00 as prvyrytd_crey")+;
	iif(lPrvYrYtD,",sum("+cPLCondition+",mb.deb,0)) as PL_deb,sum("+cPLCondition+cStandardCurrCond+",mb.cre,0)) as PL_cre",",0.00 as PL_deb,0.00 as PL_cre")+;
	iif(lPrvYrYtD,",sum("+cPrvYrPLCondition+",mb.deb,0)) as prvyrpl_deb,sum("+cPrvYrPLCondition+cStandardCurrCond+",mb.cre,0)) as prvyrpl_cre",",0.00 as prvyrpl_deb,0.00 as prvyrpl_cre")+;
 	iif(lForeignCurr,;
 	",sum("+cPrvYrCondition+cNonStandardCurrCond+",mb.deb,0)) as prvyr_debyf,sum("+cPrvYrCondition+cNonStandardCurrCond+",mb.cre,0)) as prvyr_creyf"+;
 	",sum("+cPrvPerCondition+cNonStandardCurrCond+",mb.deb,0)) as prvper_debyf,sum("+cPrvPerCondition+cNonStandardCurrCond+",mb.cre,0)) as prvper_creyf" +;
 	",sum("+cPerCondition+cNonStandardCurrCond+",mb.deb,0)) as per_debyf,sum("+cPerCondition+cNonStandardCurrCond+",mb.cre,0)) as per_creyf"+;
	iif(lPrvYrYtD,",sum("+cPrvYrYtDCondition+cNonStandardCurrCond+",mb.deb,0)) as prvyrytd_debyf,sum("+cPrvYrYtDCondition+cNonStandardCurrCond+",mb.cre,0)) as PrvYrYtD_creyF",",0.00 as PrvYrYtD_debyF,0.00 as PrvYrYtD_creyF");
 	,"")+;
	" from ("+cSelectx+") as x left join mbalance as mb ON (mb.accid=x.accid and "+cmBalCondition+") group by x.accid"
	
	// cSelectz: 3e level select on y and budget bu
   
   cSelectz:="select y.accid,y.balitemid,y.currency,y.department"+iif(lDetails,",y.accnumber,y.description","")+",y.category"+; 
   ",y.svjdyr3+y.prvyr_deby as prvyr_deb,y.svjcyr3+y.prvyr_crey as prvyr_cre"+;
   ",y.prvyrytd_deby+y.svjdyr2 as prvyrytd_deb,y.prvyrytd_crey+y.svjcyr2 as prvyrytd_cre,"+;
	"y.prvper_deby+if(category='"+LIABILITY+"' or category='"+asset+"',y.svjdyr3+y.prvyr_deby,0) as prvper_deb,"+;
	"y.prvper_crey+if(category='"+LIABILITY+"' or category='"+asset+"',y.svjcyr3+y.prvyr_crey,0) as prvper_cre,"+;
	"y.per_deby+if(category='"+LIABILITY+"' or category='"+ASSET+"',y.svjdyr3+y.prvyr_deby+prvper_deby,0) as per_deb,"+;
	"y.per_crey+if(category='"+LIABILITY+"' or category='"+ASSET+"',y.svjcyr3+y.prvyr_crey+prvper_crey,0) as per_cre,"+;
	"y.pl_deb,y.pl_cre,y.prvyrpl_deb,y.prvyrpl_cre"+;    
	iif(lForeignCurr,;
   ",y.svjdyr3f+y.prvyr_debyf as prvyr_debf,y.svjcyr3f+y.prvyr_creyf as prvyr_cref"+;
   ",y.prvyrytd_debyf+y.svjdyr2f as prvyrytd_debf,y.prvyrytd_creyf+y.svjcyr2f as prvyrytd_cref"+;
	",y.prvper_debyf+if(category='"+LIABILITY+"' or category='"+asset+"',y.svjdyr3f+y.prvyr_debyf,0) as prvper_debf"+;
	",y.prvper_creyf+if(category='"+LIABILITY+"' or category='"+ASSET+"',y.svjcyr3f+y.prvyr_creyf,0) as prvper_cref"+;
	",y.per_debyf+if(category='"+liability+"' or category='"+asset+"',y.svjdyr3f+y.prvyr_debyf+prvper_debyf,0) as per_debf"+;
	",y.per_creyf+if(category='"+liability+"' or category='"+asset+"',y.svjcyr3f+y.prvyr_creyf+prvper_creyf,0) as per_cref";
	,"")+;
	iif(lBudget,",sum("+cPrvPerConditionBud+",bu.amount,0)) as prvper_bud,sum("+cPerConditionBud+",bu.amount,0)) as per_bud,sum("+cYrConditionBud+",bu.amount,0)) as yr_bud","")+;
	" from ("+cSelecty+") as y "+;
	iif(lBudget," left join budget bu ON (y.accid=bu.accid and "+cBudgetCondition+") group by y.accid","") 
	RETURN cSelectz

Function ChgBalance(pAccount as string,pRecordDate as date,pDebAmnt as float,pCreAmnt as float,pDebFORGN as float,pCreFORGN as float,Currency as string)  as logic
	******************************************************************************
	*              Update of month balance values per account
	*					Should be used between Start transaction and commit
	*  Auteur    : K. Kuijpers
	*  Datum     : 19-08-1991
	******************************************************************************
	*
	local cSearchStr as string 
	local oStmnt as SQLStatement
	local oMBal,oAcc as SQLSelect 
	IF !Empty(pDebAmnt).or.!Empty(pCreAmnt)
		// intential lock:
		oMBal:=SQLSelect{"select mbalid from mbalance where accid="+pAccount+;
			" and year="+Str(Year(pRecordDate),-1)+;
			" and Month="+Str(Month(pRecordDate),-1)+" and currency='"+sCurr+"' for update",oConn}
		if oMBal:RecCount>0  
			// update existing:  
			oStmnt:=SQLStatement{"update mbalance set deb=round(deb+"+Str(pDebAmnt,-1)+",2),cre=round(cre+"+Str(pCreAmnt,-1)+",2) where accid="+pAccount+;
				" and year="+Str(Year(pRecordDate),-1)+;
				" and month="+Str(Month(pRecordDate),-1)+" and currency='"+sCurr+"'",oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				LogEvent(,"error:"+oStmnt:status:description+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
				return false
			endif
		else
			// insert new one
			oStmnt:=SQLStatement{"insert into mbalance set accid="+pAccount+",year="+Str(Year(pRecordDate),-1)+",month="+Str(Month(pRecordDate),-1)+",currency='"+;
				sCurr+"',deb="+Str(pDebAmnt,-1)+",cre="+Str(pCreAmnt,-1),oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				LogEvent(,"error:"+oStmnt:status:description+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
				return false
			endif
		endif
	ENDIF
	IF !Empty(Currency) .and.!Currency==sCurr .and. (!Empty(pDebFORGN).or.!Empty(pCreFORGN)) .and.(!pDebFORGN==pDebAmnt.or. !pCreFORGN==pCreAmnt)
		oAcc:=SQLSelect{"select currency,multcurr from account where accid="+pAccount,oConn}
		if oAcc:RecCount>0
			if !(Empty(oAcc:Currency).or.oAcc:Currency==sCurr.or.oAcc:MULTCURR=1)
				// intential lock:
				oMBal:=SQLSelect{"select mbalid from mbalance where accid="+pAccount+;
					" and year="+Str(Year(pRecordDate),-1)+;
					" and month="+Str(Month(pRecordDate),-1)+" and currency='"+oAcc:Currency+"' for update",oConn}
				if oMBal:RecCount>0
					// update existing:  
					oStmnt:=SQLStatement{"update mbalance set deb=round(deb+"+Str(pDebFORGN,-1)+",2),cre=round(cre+"+Str(pCreFORGN,-1)+",2) where accid="+pAccount+;
					" and year="+Str(Year(pRecordDate),-1)+;
					" and Month="+Str(Month(pRecordDate),-1)+" and currency='"+oAcc:Currency+"'",oConn}
					oStmnt:Execute()
					if !Empty(oStmnt:status)
						LogEvent(,"error:"+oStmnt:status:description+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
						return false
					endif
				else
					// insert new one
					oStmnt:=SQLStatement{"insert into mbalance set accid="+pAccount+",year="+Str(Year(pRecordDate),-1)+",month="+Str(Month(pRecordDate),-1)+",currency='"+;
						oAcc:Currency+"',deb="+Str(pDebFORGN,-1)+",cre="+Str(pCreFORGN,-1),oConn}
					oStmnt:Execute()
					if !Empty(oStmnt:status)
						LogEvent(,"error:"+oStmnt:status:description+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
						return false
					endif	 
				endif
			ENDIF
		endif
	endif
	RETURN true
define expense:="KO"
Function GetBalYear(pStartYear as int,pStartMonth as int) as array 
	/* Give parameters of balance year, in which given year and month occurs
	Returns array with the values:
	-YEARSTART: 	Start Year of found balance year
	-MonthStart:	Start Month of found balance year
	-YEAREND: 		End Year of found balance year
	-MONTHEND:		End Month of found balance year
	*/
	LOCAL nDateMonth, nMinStart, nSecondStart, nNewStart, nEnd,i as int
	Local Startdate:=SToD(Str(pStartYear,4,0)+StrZero(pStartMonth,2,0)+"01"),enddate as date 
	local YEARSTART,MONTHSTART,YEAREND,MonthEnd as int
	
	nDateMonth:=Round(pStartYear*12+pStartMonth,0)
	nMinStart:=Round(Year(LstYearClosed)*12+Month(LstYearClosed),0)
	IF nDateMonth >=nMinStart
		* In Non closed year
		* Calculate start of next balance year:
		IF Month(LstYearClosed) < ClosingMonth
			nSecondStart:=Round(Year(LstYearClosed)*12+ClosingMonth+1,0)
		ELSE
			nSecondStart:=Round(Year(LstYearClosed)*12+ClosingMonth+13,0)
		ENDIF
		
		IF nDateMonth < nSecondStart // before second balance year?
			YEARSTART:=Year(LstYearClosed)
			MONTHSTART:=Month(LstYearClosed)
			YEAREND:=Integer((nSecondStart-2)/12)
		ELSE
			nNewStart:=nSecondStart+Integer(((nDateMonth - nSecondStart)/12)*12)
			YEARSTART:=Integer(nNewStart/12)
			MONTHSTART:=nNewStart%12
			YEAREND:=Integer((nNewStart+10)/12)
		ENDIF
		MonthEnd:=ClosingMonth
		RETURN {YEARSTART,MONTHSTART,YEAREND,MonthEnd}
	ENDIF
	IF Empty(GlBalYears)
		* empty closed balanceyears:
		RETURN {YEARSTART,MONTHSTART,YEAREND,MonthEnd}
	ENDIF
	for i:=1 to Len(GlBalYears)
		IF GlBalYears[i,1]<=Startdate // start before given date?
			YEARSTART:=Year(GlBalYears[i,1])
			MONTHSTART:=Month(GlBalYears[i,1])
			if i==1 
				enddate:=SToD(Str(YEARSTART+1,4)+StrZero(MONTHSTART,2)+"01")-1
			else
				enddate:=GlBalYears[i-1,1]-1
			endif
			YEAREND:=Year(enddate)
			MonthEnd:=Month(enddate)
			RETURN {YEARSTART,MONTHSTART,YEAREND,MonthEnd}
		ENDIF
	Next
	* per default oldest year:
	i--
	YEARSTART:=Year(GlBalYears[i,1])
	MONTHSTART:=Month(GlBalYears[i,1])
	if	i==1 
		enddate:=SToD(Str(YEARSTART+1,4)+StrZero(MONTHSTART,2)+"01")-1
	else
		enddate:=GlBalYears[i,1]-1
	endif
	YEAREND:=Year(enddate)
	MonthEnd:=Month(enddate)
	RETURN {YEARSTART,MONTHSTART,YEAREND,MonthEnd}
function GetBalYears(NbrFutureYears:=0 as int) as array
	// get array with balance years
	LOCAL aMyYear:={} as ARRAY  // {text of balance year, jjjjmm of start of balance year}
	LOCAL oBalY as SQLSelect
	LOCAL nEnd,MONTHEND,YEAREND as int 
	local aYearStartEnd:={} as array

	
	oBalY:=SQLSelect{"select * from balanceyear order by yearstart desc,monthstart desc",oConn}
	oBalY:Execute()	                       
	
	DO WHILE !oBalY:EoF
		IF !Empty(oBalY:YEARSTART)
			nEnd:=Round(oBalY:YEARSTART*12+oBalY:MONTHSTART+oBalY:YEARLENGTH-2,0)
			MONTHEND:=nEnd%12+1
			YEAREND:=Integer(nEnd/12)
			AAdd(aMyYear,{Str(oBalY:YEARSTART,4,0)+":"+StrZero(oBalY:MONTHSTART,2,0)+" - "+;
				Str(YEAREND,4,0)+":"+StrZero(MONTHEND,2,0),Str(oBalY:YEARSTART,4,0)+StrZero(oBalY:MONTHSTART,2,0)})
		ENDIF
		oBalY:Skip()
	ENDDO
	*	Add non closed years:

	
	aYearStartEnd:=GetBalYear(Year(MinDate),ClosingMonth)
	AAdd(aMyYear,{Str(aYearStartEnd[1],4,0)+":"+StrZero(aYearStartEnd[2],2,0)+" - "+;
	Str(aYearStartEnd[3],4,0)+":"+StrZero(aYearStartEnd[4],2,0),Str(aYearStartEnd[1],4,0)+StrZero(aYearStartEnd[2],2,0)})
	MONTHEND:=aYearStartEnd[4]
	YEAREND:=aYearStartEnd[3]
	DO WHILE true
		++MONTHEND
		IF MONTHEND>12
			MONTHEND:=1
			++YEAREND
		ENDIF
		IF Round(YEAREND*12+MONTHEND,0)>Round(Year(Today())*12+Month(Today())+NbrFutureYears*12,0)
			*	last year determined:
			exit
		ENDIF
		aYearStartEnd:=GetBalYear(YEAREND,MonthEnd)
		AAdd(aMyYear,{Str(aYearStartEnd[1],4,0)+":"+StrZero(aYearStartEnd[2],2,0)+" - "+;
			Str(aYearStartEnd[3],4,0)+":"+StrZero(aYearStartEnd[4],2,0),Str(aYearStartEnd[1],4,0)+StrZero(aYearStartEnd[2],2,0)})
		MONTHEND:=aYearStartEnd[4]
		YEAREND:=aYearStartEnd[3]
	ENDDO
	ASort(aMyYear,,,{|x,y| x[2]>=y[2]})
	RETURN aMyYear

define income:="BA"
STATIC DEFINE  INPERIOD := 3
define liability:="PA"
METHOD ChgBalance(pAccount as string,pRecordDate as date,pDebAmnt as float,pCreAmnt as float,pDebFORGN as float,pCreFORGN as float) CLASS MBalance
******************************************************************************
*              Update of month balance values and of budget per account
*  Auteur    : K. Kuijpers
*  Datum     : 19-08-1991
******************************************************************************
*
local cSearchStr as string 
local lChanged as logic
local oMBln:=self:oMBal as MBalance 
//local CurRec:=self:RECNO as int
//Default(@pDebFORGN,0)
//Default(@pCreFORGN,0)
if oMBln==null_object
	oMBln:=MBalance{}
endif
if !oMBln:Used
	(ErrorBox{,"Can not open MBalance"}):Show()
	return 
endif
IF !IsNil(pDebAmnt).or.!IsNil(pCreAmnt)
	cSearchStr:=AllTrim(pAccount)+SubStr(DToS(pRecordDate),1,6)+sCurr
	if !oMBln:Seek({#REK,#YEAR,#MONTH,#CURRENCY},{AllTrim(pAccount),Year(pRecordDate),Month(pRecordDate),sCURR})
		IF !oMBln:Append()
			RETURN
		ENDIF
		oMBln:accid := pAccount
		oMBln:Year := Year(pRecordDate)
		oMBln:Month:= Month(pRecordDate)
		oMBln:CURRENCY:=sCurr
	else
		oMBln:RLOCK()
	ENDIF 
	lChanged:=true
	oMBln:deb+= pDebAmnt
	oMBln:cre+= pCreAmnt 
ENDIF
IF !IsNil(pDebFORGN).or.!IsNil(pCreFORGN)
	if !oAcc:accid==pAccount
		oAcc:Seek(#REK,pAccount)
	endif
	if !(Empty(oAcc:Currency).or.oAcc:CURRENCY==sCurr.or.oAcc:MULTCURR)
		if !oMBln:Seek({#REK,#YEAR,#MONTH,#CURRENCY},{AllTrim(pAccount),Year(pRecordDate),Month(pRecordDate),oAcc:CURRENCY})
			if !oMBln:Append()
				RETURN
			ENDIF
			oMBln:accid := pAccount
			oMBln:Year := Year(pRecordDate)
			oMBln:Month:= Month(pRecordDate)
			oMBln:CURRENCY:=oAcc:CURRENCY
		else
			oMBln:RLOCK()
		ENDIF 
		oMBln:deb+= pDebFORGN
		oMBln:cre+= pCreFORGN 
		lChanged:=true
	endif
ENDIF
if lChanged
	oMBln:Commit()
	oMBln:unlock()
	oMBln:Notify(NOTIFYFILECHANGE )
ENDIF 
//self:RECNO:=CurRec

RETURN
Method Close() Class MBalance
Super:Close()
if !self:oAcc==null_object
	if self:oAcc:Used
		oAcc:Close()
	endif
	oAcc:=null_object
endif
if !self:oMBal==null_object
	if self:oMBal:Used
		oMBal:Close()
	endif
	oMBal:=null_object
endif 
METHOD GetBalance( pAccount ,pNum ,pPeriodStart ,pPeriodEnd, pCurrency)  CLASS MBalance
******************************************************************************
*  Name      : GetBalance
*              Calculation of balance values of a account during a certain period
*  Author    : K. Kuijpers
*  Date      : 23-08-1991
******************************************************************************

************** PARAMETERS and DECLARATION OF VARIABLEs ***********************
*
* pAccount     : accountnumber
* pNum         : number of the related balance item
* pPeriodStart : year and month, at which the required period starts; default: First month of the current balance year
*              : it is possible that this value is filled with a specific date in case a date within a month is needed.
* pPeriodEnd   : year and month, at which the required period ends;  default: today + 31 days
*              : it is also possible that this value is filled with a specific date
*
* There are three periods during which balance values are calculated:
* 1. Required period determined by pPeriodStart and pPeriodEnd
* 2. Previous period in the balance year of pPeriodStart from first month of this year until pPeriodStart
* 3. Previuos year: the balance year before the balance year of pPeriodStart
*
* Illustrated as follows:
*
*                         |---- previous year---|prev.period |--- required period ---|
*                         |                     |            |                       |
*                         |                     |            |                       |
* --+---------------------+---------------------+---------------------+---------------------+--
*   .                     .                     .                   ^ .                     .
*   .   balance year 1    .   balance year 2    .    balance year 3 | .    balance year 4   .
*                         ^                                         |
*                         |                                         |
*                     last close(e.g.)                            budget
*
* Returned are as export variables of database MONTHBALANCE:
* per_deb   : calculated debit balance value during required period
* per_cre   : idem for credit
* begin_deb : calculated debit balance value at begin of required period
* begin_cre : idem for credit
* vorig_deb : calculated debit balance value at begin of previous period
* vorig_cre : idem for credit
* vjr_deb   : calculated debit balance value during previous year
* vjr_cre   : idem for credit
* All these values have the following meaning:
* in case of Cost/profit       : sum of transactions during the specifief period,
* in case of liabilities/assets: actual balance value at end of the specified period)
*
* RubrSoort : balancecode: KO: Cost, BA: profit, AK: assets, PA: liabilities&funds
*
**************
*
LOCAL CurrStartYear, CurrStartMonth as int // variables for stepping through years and months
LOCAL PrevPeriodStart as int// start of previous period as number of months since year zero
LOCAL PeriodStartYear, PeriodStartMonth   // start of requested period in years and months
LOCAL PeriodStart as int // Idem but as number of months since year zero
LOCAL PeriodEndYear, PeriodEndMonth as int // end of requested period in years and months
LOCAL PeriodEnd as int // Idem but as number of months since year zero
LOCAL LastClose as int // moment of last closing of balance year in number of months since year zero
LOCAL CurrMonth as int // Current month during processing in number of months since year zero
LOCAL m_recnr as int
LOCAL lCostProfit as LOGIC // Is account a Cost or profit account: true
LOCAL nState:=1 as int // State of proces: previous Year, previous period, required period
LOCAL oAccBal as SQLSelect
local oMBal as SQLSelect 
local oTrans as SQLSelect
local cTransSelect as string
local YearBeginEnd:={} as array //{year start, monthstart, year end, month end} 

Default(@pCurrency,sCURR) 
per_deb:=0
per_cre:=0
vorig_deb:=0
vorig_cre:=0
vjr_deb:=0
vjr_cre:=0
LastClose := Round(Year(MinDate)*12,0)+Month(MinDate)
*
* Determine required period from inputparameters:
*
IF pPeriodEnd==nil
	PeriodEndMonth:=Month(Today()+31)
	PeriodEndYear:=Year(Today()+31)
ELSEIF IsDate(pPeriodEnd)
	PeriodEndMonth:=Month(pPeriodEnd)
	PeriodEndYear:=Year(pPeriodEnd)
ELSE
	PeriodEndMonth:= Round(pPeriodEnd,0)%100
	PeriodEndYear:=Round((pPeriodEnd - PeriodEndMonth)/100,0)
ENDIF
IF pPeriodStart==nil
	* default first month of current balance year:
	* determine start of balance year of enddate:
	GetBalYear(PeriodEndYear,PeriodEndMonth)
	PeriodStartMonth := self:MONTHSTART
	PeriodStartYear:=self:YEARSTART
ELSEIF IsDate(pPeriodStart)
	PeriodStartMonth:=Month(pPeriodStart)
	PeriodStartYear:=Year(pPeriodStart)
ELSE
	PeriodStartMonth:= Round(pPeriodStart,0)%100
	PeriodStartYear:=Round((pPeriodStart - PeriodStartMonth)/100,0)
ENDIF
PeriodStart := Round(PeriodStartYear*12+ PeriodStartMonth,0)
PeriodEnd   := Round(PeriodEndYear*12+ PeriodEndMonth,0)

m_recnr := self:RECNO
self:cRubrSoort := self:GetCategory(pNum)
lCostProfit:= (self:cRubrSoort == 'KO' .or. self:cRubrSoort == 'BA')



* Determine start and enddate of the previous year, previous period and moment
* to start stepping through the months (CurrrStart):

*	Determine start of corresponding balance year:
YearBeginEnd:=GetBalYear(PeriodStartYear,PeriodStartMonth)
CurrStartYear := YearBeginEnd[1]
CurrStartMonth:= YearBeginEnd[2]
PrevPeriodStart:=Integer(CurrStartYear*12)+CurrStartMonth  // i.e. beginning of corresponding balance year
IF lCostProfit
*	if profit / cost account skip one year back for calculation of balance in previous year:
	CurrStartYear-=1
ELSE // assets/liabilities
	IF PrevPeriodStart > LastClose
	*	start at first non closed year to cumulate from last svjd/c:
		CurrStartYear:=Year(MinDate)
		CurrStartMonth:=Month(MinDate)
	ENDIF
	* seek corresponding account balance for balances of previous year:
	oAccBal := SQLSelect{"select svjd,svjc from AccountBalanceYear where accid='"+pAccount+"' and yearstart="+;
	Str(CurrStartYear,-1)+" and MONTHSTART="+Str(CurrStartMonth,-1)+" and currency='"+pCurrency+"'",oConn}
	IF oAccBal:RecCount=1
		per_deb:=oAccBal:SVJD
		per_cre:=oAccBal:SVJC
	ENDIF
ENDIF

* Seek first required Monthbalance: 
oMBal:=SQLSelect{"select * from MBalance where accid="+pAccount+;
" and (year*12+month) between "+Str(CurrStartYear*12+CurrStartMonth,-1)+" and "+Str(PeriodEnd,-1)+" and currency='"+pCurrency+"'"+;
" order by year,month,currency asc",oConn}
// self:Seek({#REK,#YEAR,#MONTH,#CURRENCY},{pAccount,Str(CurrStartYear,4),StrZero(CurrStartMonth,2),pCurrency},true)
// IF !(self:EoF.or.self:rek#pAccount.or.self:Year>PeriodEndYear)
IF oMBal:RecCount>0
	IF oMBal:Year > CurrStartYear // first year not found?
		CurrStartMonth:=1 // start next year in month 1
	ENDIF
ENDIF
begin_deb:=0
begin_cre:=0

* Cumulation of all month balances up to and including the requested end of period.
* There are three important date's:
* 1.	Transition from previous balance year to the requested balance year.
*		At this moment (PrevPeriodStart) vjr_deb/cre should be known.
* 2.	Transition within requested balance year from previous period to the requested period.
*		At this moment (PeriodStart) vorig_deb/cre should be known.
* 3.	The end of the requested period, at which moment (PeriodEnd) per_deb/cre should be known
* 
   

// DO WHILE !oMBal:EoF.and.(CurrMonth:=Round(oMBal:Year*12+ oMBal:Month,0)) <= PeriodEnd .and.  oMBal:accid==Val(pAccount)
DO WHILE !oMBal:EoF
	CurrMonth:=Round(oMBal:Year*12+ oMBal:Month,0)
	* Check transition from previous balance year:
	IF nState==PREVYEAR .and. CurrMonth >= PrevPeriodStart
		* Determine previous year balance:
		vjr_deb:=per_deb
		vjr_cre:=per_cre
		IF lCostProfit
		* 	In case of Cost/profit reset balance for previous period:
			per_deb:=0
			per_cre:=0
		ENDIF
		nState:=PREVPERIOD
	ENDIF
	* Check transition from previous period within balance year to requested period:
	IF nState==PREVPERIOD .and. CurrMonth >= PeriodStart
		IF PeriodStart > PrevPeriodStart // Is there a previous period?
			vorig_deb:=per_deb
			vorig_cre:=per_cre
		ENDIF
		begin_deb:=per_deb
		begin_cre:=per_cre
		IF lCostProfit
		* 	Bij V&W opnieuw tellen voor voorgaande periode saldo:
			per_deb:=0
			per_cre:=0
		ENDIF
		nState:=INPERIOD
	ENDIF
	per_deb :=Round(per_deb+oMBal:deb, DecAantal)
	per_cre :=Round(per_cre+oMBal:cre, DecAantal) 
	* Check end of period:
	IF nState==INPERIOD .and. CurrMonth >= PeriodEnd
   	* Check if period end during the month:
   	IF IsDate(pPeriodEnd)
   		* Before ultimo of the month?
   		IF pPeriodEnd < SToD(Str(PeriodEndYear,4)+StrZero(PeriodEndMonth,2)+;
				Str(MonthEnd(PeriodEndMonth,PeriodEndYear),2))
				*	Reverse last month:
				per_deb :=Round(per_deb-oMBal:deb, DecAantal)
				per_cre :=Round(per_cre-oMBal:cre, DecAantal) 
				* Calculate sum of transactions in last month: 
				cTransSelect:=UnionTrans("select Round(sum(t.deb),2) as monthdeb,Round(sum(t.cre),2) as monthcre,"+;
				"Round(sum(t.DEBFORGN),2) as monthdebf,Round(sum(t.CREFORGN),2) as monthcref from transaction as t "+;
				"where t.DAT>='"+Str(PeriodEndYear,4)+"-"+StrZero(PeriodEndMonth,2)+"-01' and t.DAT<='"+SQLdate(pPeriodEnd)+"' and t.accid='"+pAccount+"'") 
				oTrans:=SQLSelect{cTransSelect,oConn}
				LogEvent(,"GetBalance:"+oTrans:SQLString,'logsql') 
				IF Empty(oTrans:Status) .and. oTrans:RecCount=1
					if pCurrency=sCURR
						per_deb :=Round(per_deb+oTrans:monthdeb, DecAantal)
						per_cre :=Round(per_cre+oTrans:monthcre, DecAantal)
					else
						per_deb :=Round(per_deb+oTrans:monthdebf, DecAantal)
						per_cre :=Round(per_cre+oTrans:monthcref, DecAantal)							
					endif
				else
					LogEvent(,"GetBalance:Error:"+oTrans:Status:Description+"; statement:"+oTrans:SQLString,"LogSQL")
				ENDIF
			ENDIF
		ENDIF
		exit
	ENDIF
	oMBal:Skip()
ENDDO
IF nState==PREVYEAR
   * Apperently balance year not found:
	vjr_deb:=per_deb                    && total = previous year
	vjr_cre:=per_cre
	IF lCostProfit
    * In case of profit/cost apparently no previous period:
		per_deb:=0
		per_cre:=0
	ENDIF
	begin_deb:=per_deb
	begin_cre:=per_cre
ENDIF
IF nState==PREVPERIOD
	* Apperently period not found
	IF PeriodStart > PrevPeriodStart // Is there a previous period?
		vorig_deb:=per_deb
		vorig_cre:=per_cre
	ENDIF
	begin_deb:=per_deb
	begin_cre:=per_cre
	IF lCostProfit
	* 	In case of profit/cost reset previous period balance:
		per_deb:=0
		per_cre:=0
	ENDIF
ENDIF
per_deb:=Round(per_deb,DecAantal)
per_cre:=Round(per_cre,DecAantal)
vjr_deb:=Round(vjr_deb,DecAantal)
vjr_cre:=Round(vjr_cre,DecAantal)
vorig_deb:=Round(vorig_deb,DecAantal)
vorig_cre:=Round(vorig_cre,DecAantal)
begin_deb:=Round(begin_deb,DecAantal)
begin_cre:=Round(begin_cre,DecAantal)
IF .not.Empty(m_recnr)
   self:goto( m_recnr)
ENDIF

RETURN
METHOD GetBalYear(pStartYear,pStartMonth) CLASS MBalance
	* Give parameters of balance year, in which given year and month occurs
	* Return the values om MBalance:
*	YEARSTART: 	Start Year of found balance year
*	MonthStart:	Start Month of found balance year
*	YEAREND: 	End Year of found balance year
*	MONTHEND:	End Month of found balance year

	LOCAL oBalY as BalanceYear
	LOCAL nDateMonth, nMinStart, nSecondStart, nNewStart, nEnd as int
	
	nDateMonth:=Round(pStartYear*12+pStartMonth,0)
	nMinStart:=Round(Year(LstYearClosed)*12+Month(LstYearClosed),0)
	IF nDateMonth >=nMinStart
		* In Non closed year
		* Calculate start of next balance year:
		IF Month(LstYearClosed) < ClosingMonth
			nSecondStart:=Round(Year(LstYearClosed)*12+ClosingMonth+1,0)
		ELSE
			nSecondStart:=Round(Year(LstYearClosed)*12+ClosingMonth+13,0)
		ENDIF
		
		IF nDateMonth < nSecondStart // before second balance year?
			YEARSTART:=Year(LstYearClosed)
			MONTHSTART:=Month(LstYearClosed)
			YEAREND:=Integer((nSecondStart-2)/12)
		ELSE
			nNewStart:=nSecondStart+Integer(((nDateMonth - nSecondStart)/12)*12)
			YEARSTART:=Integer(nNewStart/12)
			MONTHSTART:=nNewStart%12
			YEAREND:=Integer((nNewStart+10)/12)
		ENDIF
		MONTHEND:=ClosingMonth
		RETURN true
	ENDIF
	IF oBalanceYear==null_object
		oBalanceYear:=BalanceYear{}
	ENDIF
	IF !oBalanceYear:Used
		oBalanceYear:=BalanceYear{}
	ENDIF
	oBalY:= self:oBalanceYear
	oBalY:GoBottom()
	IF oBalY:EoF
		* empty balanceyear:
		RETURN FALSE
	ENDIF
	DO WHILE !oBalY:BoF
		IF Round(oBalY:YEARSTART*12+oBalY:MONTHSTART,0)<=nDateMonth.and.!Empty(oBalY:YEARSTART) // start before given date?
			self:YEARSTART:=oBalY:YEARSTART
			self:MonthStart:=oBaly:MONTHSTART
			nEND:=Round(YEARSTART*12+MONTHSTART+oBalY:YEARLENGTH-2,0)
			self:MONTHEND:=nEND%12+1
			self:YEAREND:=Integer(nEND/12)
			RETURN true
		ENDIF
		oBalY:Skip(-1)
	ENDDO
	* per default oldest year:
	oBalY:GoTop()
	self:YEARSTART:=oBalY:YEARSTART
	self:MonthStart:=oBaly:MONTHSTART
	nEND:=Round(YEARSTART*12+MONTHSTART+oBalY:YEARLENGTH-2,0)
	self:MONTHEND:=nEND%12+1
	self:YEAREND:=Integer(nEND/12)
RETURN true

METHOD GetBalYears(NbrFutureYears) CLASS MBalance
	// get array with balance years
	LOCAL aMyYear:={} as ARRAY  // {text of balance year, jjjjmm of start of balance year}
	LOCAL oBalY as SQLSelect
	LOCAL nEnd,MONTHEND,YEAREND as int
	Default(@NbrFutureYears,0)

	
	oBalY:=SQLSelect{"select * from balanceyear order by yearstart desc,monthstart desc",oConn}
   oBalY:Execute()	                       
	                       
	DO WHILE !oBalY:EoF
		IF !Empty(oBalY:YEARSTART)
			nEND:=Round(oBalY:YEARSTART*12+oBalY:MONTHSTART+oBalY:YEARLENGTH-2,0)
			MONTHEND:=nEND%12+1
			YEAREND:=Integer(nEND/12)
			AAdd(aMyYear,{Str(oBalY:YEARSTART,4,0)+":"+StrZero(oBalY:MONTHSTART,2,0)+" - "+;
			Str(YEAREND,4,0)+":"+StrZero(MONTHEND,2,0),Str(oBalY:YEARSTART,4,0)+StrZero(oBalY:MONTHSTART,2,0)})
		ENDIF
		oBalY:Skip()
	ENDDO
	*	Add non closed years:
	IF Empty(YEAREND)
		* Nothing yet closed:
		YEAREND:=Integer((Year(Today())*12+ClosingMonth-13)/12)
		MONTHEND:=ClosingMonth
		IF self:GetBalYear(YEAREND,MonthEnd)
			AAdd(aMyYear,{Str(self:YEARSTART,4,0)+":"+StrZero(self:MONTHSTART,2,0)+" - "+;
			Str(self:YEAREND,4,0)+":"+StrZero(self:MONTHEND,2,0),Str(self:YEARSTART,4,0)+StrZero(self:MONTHSTART,2,0)})
			MONTHEND:=self:MONTHEND
			YEAREND:=self:YEAREND
		ENDIF
	ENDIF
	DO WHILE true
		++MONTHEND
		IF MONTHEND>12
			MONTHEND:=1
			++YEAREND
		ENDIF
		IF Round(YEAREND*12+MONTHEND,0)>Round(Year(Today())*12+Month(Today())+NbrFutureYears*12,0)
			*	last year determined:
			exit
		ENDIF
		IF self:GetBalYear(YEAREND,MonthEnd)
			AAdd(aMyYear,{Str(self:YEARSTART,4,0)+":"+StrZero(self:MONTHSTART,2,0)+" - "+;
			Str(self:YEAREND,4,0)+":"+StrZero(self:MONTHEND,2,0),Str(self:YEARSTART,4,0)+StrZero(self:MONTHSTART,2,0)})
			MONTHEND:=self:MONTHEND
			YEAREND:=self:YEAREND
		ENDIF
	ENDDO
	ASort(aMyYear,,,{|x,y| x[2]>=Y[2]})
	RETURN aMyYear
METHOD GetCategory(p_num as string) as string CLASS MBalance
* Determination of kind of balance-item, value returned
IF self:oRubr == null_object
	self:oRubr := BalanceItem{}
ENDIF
IF self:oRubr:Used
	IF !self:oRubr:balitemid == Val(p_num)
		self:oRubr:Seek(#NUM,p_num)
	ENDIF
	RETURN self:oRubr:category
ELSE
	RETURN "  "
ENDIF
STATIC DEFINE  PREVPERIOD := 2
STATIC DEFINE  PREVYEAR := 1
