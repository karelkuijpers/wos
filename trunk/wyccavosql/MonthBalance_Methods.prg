define asset:="AK"
class Balances
	* Result from getbalance are returned here
	EXPORT per_deb as FLOAT  //calculated debit balance over period
	EXPORT per_cre as FLOAT   //calculated credit balance over period
	EXPORT begin_deb as FLOAT  //calculated begin  debit balance
	EXPORT begin_cre as FLOAT   //calculated begin credit balance
	EXPORT vorig_deb as FLOAT //calculated debit balance previous period in yearstart
	EXPORT vorig_cre as FLOAT //calculated credit balance previous period in yearstart
	EXPORT prvyr_deb as FLOAT   //calculated debit balance previous year
	EXPORT prvyr_cre  as FLOAT  //calculated credit balance previous year
//	Idem for foreign currency
	EXPORT per_debF as FLOAT  //calculated debit balance over period
	EXPORT per_creF as FLOAT   //calculated credit balance over period
	EXPORT begin_debF as FLOAT  //calculated begin  debit balance
	EXPORT begin_creF as FLOAT   //calculated begin credit balance
	EXPORT vorig_debF as FLOAT //calculated debit balance previous period in yearstart
	EXPORT vorig_creF as FLOAT //calculated credit balance previous period in yearstart
	EXPORT prvyr_debF as FLOAT   //calculated debit balance previous year
	EXPORT prvyr_creF  as FLOAT  //calculated credit balance previous year
	EXPORT cRubrSoort as STRING // Classification of corresponding balance item
	
	export cAccSelection as string       // selection criteria voor selection of account as a
	export cTransSelection as string    // selection criteria voor selection of transaction as t
	export cError as string  // error te be returned  
	protect aMbalValues:={} as array // {accid,year,month,currency,deb,cre} 

	
	declare method GetBalance,SQLGetBalance,ChgBalance,ChgBalanceExecute,SQLGetBalanceDate
	
	assign AccSelection(uValue) class Balances
	self:cAccSelection:=uValue
	return self:cAccSelection
Method ChgBalance(pAccount as string,pRecordDate as date,pDebAmnt as float,pCreAmnt as float,pDebFORGN as float,pCreFORGN as float,Currency as string)  as logic class Balances
	******************************************************************************
	*              Adding values per account and currency to string cMbalStmt to update Mbalance later with ChgBalanceExecute()
	*					Should be used between Start transaction and commit and  
	*              record to be changed should be locked for update beforehand                                        
	*  Auteur    : K. Kuijpers
	*  Date      : 02-12-2011
	******************************************************************************
	*
	local lError as logic 
	local cDate,cMonth,cYear as string 
	local i as int
	IF !Empty(pDebAmnt).or.!Empty(pCreAmnt)
		// insert new one/update existing
		cDate:=DToS(pRecordDate)
		cYear:=SubStr(cDate,1,4)
		cMonth:=ZeroTrim(SubStr(cDate,5,2))
		if !Currency==sCurr
			if Empty(currency) .or. len(currency)<>3 
				Currency:=sCurr
			else
				SEval(Currency,{|c|lError:=iif(c<65 .or. c>90,true,lError)})
				if lError
					Currency:=sCurr
				endif
			endif
		endif
		if !(pDebAmnt==0.00.and.pCreAmnt==0.00)
 	 		// add to balance values:
			// {accid,year,month,currency,deb,cre} 
			i:=AScan(self:aMbalValues,{|x|x[1]==pAccount.and.x[4]==sCurr.and.x[2]==cYear.and.x[3]==CMonth})
			if i>0
				self:aMbalValues[i,5]:=Round(self:aMbalValues[i,5]+pDebAmnt,DecAantal)
				self:aMbalValues[i,6]:=Round(self:aMbalValues[i,6]+pCreAmnt,DecAantal)
			else
				AAdd(self:aMbalValues,{pAccount,cYear,cMonth,sCurr,pDebAmnt,pCreAmnt})		
			endif
		endif 
		if !Currency==sCurr
			if !(pDebFORGN==pDebAmnt.and. pCreFORGN==pCreAmnt)
				if !(pDebFORGN==0.00.and.pCreFORGN=0.00)
					//	add to balance	values:
					//	{accid,year,month,currency,deb,cre}	
					i:=AScan(self:aMbalValues,{|x|x[1]==pAccount.and.x[4]==Currency.and.x[2]==cYear.and.x[3]==CMonth})
					if	i>0
						self:aMbalValues[i,5]:=Round(self:aMbalValues[i,5]+pDebFORGN,DecAantal)
						self:aMbalValues[i,6]:=Round(self:aMbalValues[i,6]+pCreFORGN,DecAantal)
					else
						AAdd(self:aMbalValues,{pAccount,cYear,cMonth,Currency,pDebFORGN,pCreFORGN})		
					endif
				endif
			endif
		endif
	endif
	RETURN true 
	method ChgBalanceExecute(pDummy:=nil as logic) as logic class Balances
	// Apply string cMbalStmt to MBalance
	local lSuccess:=true as logic
	local oStmnt as SQLStatement 
	self:cError:=''
		if !Empty(self:aMbalValues)
			oStmnt:=SQLStatement{"INSERT INTO mbalance (`accid`,`year`,`month`,`currency`,`deb`,`cre`) VALUES "+Implode(self:aMbalValues,"','")+;
				" ON DUPLICATE KEY UPDATE deb=round(deb+values(deb),2),cre=round(cre+values(cre),2)",oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:status) 
				self:cError:="ChgBalance error:"+oStmnt:status:description
				LogEvent(,cError+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors") 
				lSuccess:=false
			endif
		endif
	self:aMbalValues:={}	
	return lSuccess 
METHOD GetBalance( pAccount as string  ,pPeriodStart:=nil as usual ,pPeriodEnd:=nil as usual, pCurrency:='' as string) as void pascal CLASS Balances
	******************************************************************************
	*  Name      : GetBalance
	*              Calculation of balance values of a account during a certain period
	*  Author    : K. Kuijpers
	*  Date      : 11-12-2010
	******************************************************************************

	************** PARAMETERS and DECLARATION OF VARIABLEs ***********************
	*
	* pAccount     : accountId (string)
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
	LastClose := Round(Year(LstYearClosed)*12,0)+Month(LstYearClosed)
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
   self:cAccSelection:=" a.accid='"+pAccount+"'"
   cStatement:= self:SQLGetBalance(PeriodStartYear*100+ PeriodStartMonth, PeriodEndYear*100+PeriodEndMonth-;
	iif(IsDate(pPeriodEnd) .and.pPeriodEnd<EndOfMonth(pPeriodEnd),1,0),,iif(pCurrency==sCURR,false,true)) 
// 	logevent(self,cStatement,"logsql")
	oAccBal:=SQLSelect{cStatement,oConn}
	oAccBal:Execute()
	if !Empty(oAccBal:Status).or.oAccBal:RecCount<1
		logevent(self,"Error in Getbalance:"+oAccBal:errinfo:errormessage+CRLF+"account:"+pAccount+"cStatement:"+cStatement,"LogErrors")
		return
	endif
	
	self:per_deb:=oAccBal:per_deb
	self:per_cre:=oAccBal:per_cre
	self:prvyr_deb:=oAccBal:prvyr_deb
	self:PrvYr_cre:=oAccBal:PrvYr_cre
// 	self:vorig_deb:=oAccBal:PrvYr_deb
// 	self:vorig_cre:=oAccBal:PrvYr_cre
	self:begin_deb:=oAccBal:PrvPer_deb
	self:begin_cre:=oAccBal:PrvPer_cre
	if !pCurrency=sCURR
		self:per_debF:=oAccBal:per_debF
		self:per_creF:=oAccBal:per_creF
		self:PrvYr_debF:=oAccBal:PrvYr_debF
		self:PrvYr_creF:=oAccBal:PrvYr_creF
// 		self:vorig_debF:=oAccBal:PrvYr_debF
// 		self:vorig_creF:=oAccBal:PrvYr_creF
		self:begin_debF:=oAccBal:PrvPer_debF
		self:begin_creF:=oAccBal:PrvPer_creF
	endif
	if	IsDate(pPeriodEnd).and.pPeriodEnd < SToD(Str(PeriodEndYear,4)+StrZero(PeriodEndMonth,2)+;
		Str(MonthEnd(PeriodEndMonth,PeriodEndYear),2))
		* Before	ultimo of the month?
		* Calculate	sum of transactions in last month: 
		cTransSelect:=UnionTrans('select Round(sum(t.deb),2) as monthdeb,Round(sum(t.cre),2) as monthcre,'+;
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

Method SQLGetBalance( dPeriodStart:=0 as int ,dPeriodEnd:=0 as int,lprvyrYtD:=false as logic, lForeignCurr:=false as logic, lBudget:=false as logic, lDetails:=false as logic ) as string class Balances 
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
	* lprvyrYtD		: if true also prvyrAfterytd_deb and prvyrAfterytd_cre are returned 
	* lForeignCurr	: if true _debf and _creF values are also returned from the SQLSelect
	* lBudget		; if true return also fields with budget values prvper_bud, per_bud, yr_bud from the SQLSelect
	* lDetails		: if true return also account values accnumber and description from the SQLSelect
	* A extra selection to be used in the where clause to select accounts can be given by: Balances:cAccSelection:=<selection criteria>, 
	*	e.g. a.department in(..,..,...) and a.balitemid in (..,..,..)  
   *
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
	* 
	* Generated SQL retrieves the following values:
	* per_deb (+per_debf)			: calculated debit balance value during required period  (+ foreign currency)
	* per_cre (+per_creF)  			: idem for credit
	* prvper_deb (+prvper_debf)	: calculated debit balance at the end of previous period
	* prvper_cre (+prvper_cref)	: idem for credit
	* prvyr_deb (+prvyr_debf)  	: calculated debit balance value during previous year
	* prvyr_cre (+prvyr_creF)  	: idem for credit
	* Optional:
	* If lprvyrYtD true: 
	* - prvyrytd_deb,prvyrytd_cre: previous year YtD 
	* - pl_deb (pl_debf)	: Profit/Loss from previous year to add to netasset accounts 
	* - prvyrpl_deb (prvyrpl_debf)	: Profit/Loss from year before previous year to add to balances of previous year of net aset accounts 
	*                                  (If year before previous year not closed)  
	* if lBudget true:
	* - prvper_bud		: budget during prev.period
	* - per_bud			: budget during required period 
	* - yr_bud				: budget during whole balance year
	* Besides that data of the accounts are returned:
	* - category (assets/liability/income/expense)
   * - accid,
   * - balitemid,
   * - currency,
   * - department 
	* if lDetails true:
	* accnumber and description  of account   
	* All these values have the following meaning:
	* in case of Cost/profit       : sum of transactions during the specifief period,
	* in case of liabilities/assets: actual balance value at end of the specified period)   
	*
	* CALCULATION
	* prvyr_deb/cre: if previous year closed: svjc/d from Accountbalanceyear of balance year required period starts with
	*                else: if Cost/profit: total of mbalance from previous year, else: svjc/d of Accountbalanceyear of LstYearClosed + 
	*                                                                                  total of mbalance up till including previous year
	* prvyrytd_deb/cre: if Cost/profit: total of mbalance from same yeartodate period during previous year as required period
	*                   else: svjc/d from last available accountbalanceyear of previous year or earlier + 
	* 									total of mbalance from same yeartodate period during previous year as required period	* 
	* Thus needed accountbalanceyear: 
	*		if previous year closed:	year/month of required balance year 3 or one year before
	*		else:								year/month of LstYearClosed							
	**************
	*
	LOCAL CurrStartYear, CurrStartMonth,CurrEndYear, CurrEndMonth as int // variables for stepping through years and months
	LOCAL PrvYearStartYr,PrvYearStartMn as int // starting year and month of previous year for assets and libalities 
	LOCAL PrevPeriodStart as int// start of previous period as number of months since year zero
	LOCAL PeriodStartYear, PeriodStartMonth   // start of requested period in years and months
	LOCAL PeriodStart as int // Idem but as number of months since year zero
	LOCAL PeriodEndYear, PeriodEndMonth as int // end of requested period in years and months
	LOCAL PeriodEnd as int // Idem but as number of months since year zero
	LOCAL LastClose as int // moment of last closing of balance year in number of months since year zero
	LOCAL CurrMonth as int // Current month during processing in number of months since year zero
	local YearBeginEnd:={} as array //{year start, monthstart, year end, month end}
	LOCAL YearEnd as int // End of year as number of months since year zero
	local PrvYearBeginEnd:={} as array //{previous year start, monthstart, year end, month end}
	local cprvyrCondition as string  // condition to select mbalance row into sum of Previous Year 
	local cprvyrYtDCondition as string  // condition to select mbalance row into sum of Previous YtD Year 
	local cPLCondition as string  // condition to select mbalance row into sum of profit/loss Previous Year 
	local cprvyrPLCondition as string  // condition to select mbalance row into sum of profit/loss Year before previous Year 
	local cprvperCondition as string  // condition to select mbalance row into sum of Previous Period 
	local cPerCondition as string  // condition to select mbalance row into sum of Required Period 
	local cprvperConditionBud as string  // condition to select budget row into sum of Previous Period 
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

	LastClose := Round(Year(LstYearClosed)*12,0)+Month(LstYearClosed) 
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
	CurrEndYear := YearBeginEnd[3]
	CurrEndMonth:= YearBeginEnd[4]
	PrvYearBeginEnd:=GetBalYear(CurrStartYear-1,CurrStartMonth)
	PrevPeriodStart:=Integer(CurrStartYear*12)+CurrStartMonth  // i.e. beginning of corresponding balance year
	PrvYearNotClosed:=(PrevPeriodStart>LastClose)
	YearBeforePrvNotClosed:=((PrvYearBeginEnd[1]*12+PrvYearBeginEnd[2])>LastClose) 
	YearEnd:=Integer(CurrEndYear*12)+CurrEndMonth   // end of current year

	IF PrvYearNotClosed
		*	start at first non closed year to cumulate from last svjd/c for assets/liability:
		PrvYearStartYr:=Year(LstYearClosed)
		PrvYearStartMn:=Month(LstYearClosed)
	else
		PrvYearStartYr:=CurrStartYear
		PrvYearStartMn:=CurrStartMonth
	endif
	// condition for selecting mbalance into sum previous year:
	if PrvYearStartYr==CurrStartYear-1 .and.PrvYearStartMn==CurrStartMonth
		// same period for costprofit as assets/liablities:
		cprvyrCondition:="if((mb.year*12+mb.month) between "+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+" and "+Str(PrevPeriodStart-1,-1)
	elseIF PrvYearNotClosed  // get also mbalance for previous year 
		cprvyrCondition:="if((mb.year*12+mb.month) between if(x.category between '"+income+"' and '"+expense+"',"+;
			Str((CurrStartYear-1)*12+CurrStartMonth,-1)+","+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+") and "+Str(PrevPeriodStart-1,-1)			
	else
		// no mbalance needed for (last year balance in Accountbalanceyear):
		cprvyrCondition:="if(mb.year<0"      // always false
	endif
	// condition for selecting mbalance into sum last months for previous YtD year: 
	if lprvyrYtD
		if PrvYearNotClosed
			cprvyrYtDCondition:="if((mb.year*12+mb.month) between if(x.category between '"+income+"' and '"+expense+"',"+;
			Str((CurrStartYear-1)*12+CurrStartMonth,-1)+","+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+") and "+Str(PeriodEnd-12,-1)			
			cPLCondition:="if((mb.year*12+mb.month) between "+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+" and "+Str(PrevPeriodStart-1,-1)+;
			" and category between '"+income+"' and '"+expense+"'"
			if YearBeforePrvNotClosed 
				cprvyrPLCondition:="if((mb.year*12+mb.month) between "+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+" and "+Str(PrvYearBeginEnd[1]*12+PrvYearBeginEnd[2]-1,-1)+;
				" and category between '"+income+"' and '"+expense+"'"
			else
				cprvyrPLCondition:="if(mb.year<0"      // always false  // not needed			
			endif
		else
			cprvyrYtDCondition:="if((mb.year*12+mb.month) between "+Str(PrvYearBeginEnd[1]*12+PrvYearBeginEnd[2],-1)+" and "+Str(PeriodEnd-12,-1)
			cPLCondition:="if((mb.year*12+mb.month) between "+Str(PrvYearBeginEnd[1]*12+PrvYearBeginEnd[2],-1)+" and "+Str(PrevPeriodStart-1,-1)+;
			" and category between '"+income+"' and '"+expense+"'"
			cprvyrPLCondition:="if(mb.year<0"      // always false  // not needed
		endif
		if lForeignCurr
			cPLCondition+=" and mb.currency='"+sCURR+"'"
			cprvyrPLCondition+=" and mb.currency='"+sCURR+"'"
		endif
	endif
	
	// condition for selecting mbalance into sum previous period: 
	if PrevPeriodStart=PeriodStart   
		// no previous period
		cprvperCondition:="if(mb.year<0"      // always false
	else
		cprvperCondition:="if((mb.year*12+mb.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(PeriodStart-1,-1)						
	endif

	// condition for selecting mbalance mb:
	IF PrvYearNotClosed 
		cmBalCondition:="(mb.year*12+mb.month) between "+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+" and "+Str(PeriodEnd,-1)			
	elseif lprvyrYtD
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
// 		cBudgetCondition:="(bu.year*12+bu.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(PeriodEnd,-1)						
		cBudgetCondition:="(bu.year*12+bu.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(YearEnd,-1)						
		// condition for selecting budget into sum previous period: 
		if PrevPeriodStart=PeriodStart   
			// no previous period
			cprvperConditionBud:="if(bu.year<0"      // always false
		else
			cprvperConditionBud:="if((bu.year*12+bu.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(PeriodStart-1,-1)						
		endif
		cPerConditionBud:="if((bu.year*12+bu.month) between "+Str(PeriodStart,-1)+" and "+Str(PeriodEnd,-1)
		// condition for selecting budget into sum balance year: 
// 		cYrConditionBud:="if((bu.year*12+bu.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(PeriodEnd,-1)							
		cYrConditionBud:="if((bu.year*12+bu.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(YearEnd,-1)							
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
	"sum("+cprvyrCondition+cStandardCurrCond+",mb.deb,0)) as prvyr_deby,sum("+cprvyrCondition+cStandardCurrCond+",mb.cre,0)) as prvyr_crey,"+;
	"sum("+cprvperCondition+cStandardCurrCond+",mb.deb,0)) as prvper_deby,sum("+cprvperCondition+cStandardCurrCond+",mb.cre,0)) as prvper_crey," +;
	"sum("+cPerCondition+cStandardCurrCond+",mb.deb,0)) as per_deby,sum("+cPerCondition+cStandardCurrCond+",mb.cre,0)) as per_crey"+;
	iif(lprvyrYtD,",sum("+cprvyrYtDCondition+cStandardCurrCond+",mb.deb,0)) as prvyrytd_deby,sum("+cprvyrYtDCondition+cStandardCurrCond+",mb.cre,0)) as prvyrytd_crey",",0.00 as prvyrytd_deby,0.00 as prvyrytd_crey")+;
	iif(lprvyrYtD,",sum("+cPLCondition+",mb.deb,0)) as pl_deb,sum("+cPLCondition+cStandardCurrCond+",mb.cre,0)) as pl_cre",",0.00 as pl_deb,0.00 as pl_cre")+;
	iif(lprvyrYtD,",sum("+cprvyrPLCondition+",mb.deb,0)) as prvyrpl_deb,sum("+cprvyrPLCondition+cStandardCurrCond+",mb.cre,0)) as prvyrpl_cre",",0.00 as prvyrpl_deb,0.00 as prvyrpl_cre")+;
 	iif(lForeignCurr,;
 	",sum("+cprvyrCondition+cNonStandardCurrCond+",mb.deb,0)) as prvyr_debyf,sum("+cprvyrCondition+cNonStandardCurrCond+",mb.cre,0)) as prvyr_creyf"+;
 	",sum("+cprvperCondition+cNonStandardCurrCond+",mb.deb,0)) as prvper_debyf,sum("+cprvperCondition+cNonStandardCurrCond+",mb.cre,0)) as prvper_creyf" +;
 	",sum("+cPerCondition+cNonStandardCurrCond+",mb.deb,0)) as per_debyf,sum("+cPerCondition+cNonStandardCurrCond+",mb.cre,0)) as per_creyf"+;
	iif(lprvyrYtD,",sum("+cprvyrYtDCondition+cNonStandardCurrCond+",mb.deb,0)) as prvyrytd_debyf,sum("+cprvyrYtDCondition+cNonStandardCurrCond+",mb.cre,0)) as prvyrytd_creyF",",0.00 as prvyrytd_debyF,0.00 as prvyrytd_creyF");
 	,"")+;
	" from ("+cSelectx+") as x left join mbalance as mb ON (mb.accid=x.accid and "+cmBalCondition+") group by x.accid"
	
	// cSelectz: 3e level select on y and budget bu
   
   cSelectz:="select y.accid,y.balitemid,y.currency,y.department"+iif(lDetails,",y.accnumber,y.description","")+",y.category"+; 
   ",y.svjdyr3+y.prvyr_deby as prvyr_deb,y.svjcyr3+y.prvyr_crey as prvyr_cre"+;
   ",y.prvyrytd_deby+y.svjdyr2 as prvyrytd_deb,y.prvyrytd_crey+y.svjcyr2 as prvyrytd_cre,"+;
	"y.prvper_deby+if(category='"+LIABILITY+"' or category='"+asset+"',y.svjdyr3+y.prvyr_deby,0) as prvper_deb,"+;
	"y.prvper_crey+if(category='"+LIABILITY+"' or category='"+asset+"',y.svjcyr3+y.prvyr_crey,0) as prvper_cre,"+;
	"y.per_deby+if(category='"+LIABILITY+"' or category='"+ASSET+"',y.svjdyr3+y.prvyr_deby+y.prvper_deby,0) as per_deb,"+;
	"y.per_crey+if(category='"+LIABILITY+"' or category='"+ASSET+"',y.svjcyr3+y.prvyr_crey+y.prvper_crey,0) as per_cre,"+;
	"y.pl_deb,y.pl_cre,y.prvyrpl_deb,y.prvyrpl_cre"+;    
	iif(lForeignCurr,;
   ",y.svjdyr3f+y.prvyr_debyf as prvyr_debf,y.svjcyr3f+y.prvyr_creyf as prvyr_cref"+;
   ",y.prvyrytd_debyf+y.svjdyr2f as prvyrytd_debf,y.prvyrytd_creyf+y.svjcyr2f as prvyrytd_cref"+;
	",y.prvper_debyf+if(category='"+LIABILITY+"' or category='"+asset+"',y.svjdyr3f+y.prvyr_debyf,0) as prvper_debf"+;
	",y.prvper_creyf+if(category='"+LIABILITY+"' or category='"+asset+"',y.svjcyr3f+y.prvyr_creyf,0) as prvper_cref"+;
	",y.per_debyf+if(category='"+LIABILITY+"' or category='"+ASSET+"',y.svjdyr3f+y.prvyr_debyf+y.prvper_debyf,0) as per_debf"+;
	",y.per_creyf+if(category='"+LIABILITY+"' or category='"+ASSET+"',y.svjcyr3f+y.prvyr_creyf+y.prvper_creyf,0) as per_cref";
	,"")+;
	iif(lBudget,",sum("+cprvperConditionBud+",bu.amount,0)) as prvper_bud,sum("+cPerConditionBud+",bu.amount,0)) as per_bud,sum("+cYrConditionBud+",bu.amount,0)) as yr_bud","")+;
	" from ("+cSelecty+") as y "+;
	iif(lBudget," left join budget bu ON (y.accid=bu.accid and "+cBudgetCondition+") group by y.accid","") 
	RETURN cSelectz

Method SQLGetBalanceDate( dDate:=Today() as date, lForeignCurr:=false as logic, lDetails:=false as logic ) as string class Balances 
	******************************************************************************
	*  Name      : SQLGetBalance
	*              Generate SQL code for calculation of balance values of selected accounts om a certain date 
	*					Used aliasses for tables: account a, balance item b, mbalance mb
	*  Author    : K. Kuijpers
	*  Date      : 09-07-2012
	******************************************************************************

	******************************************************************************

	************** PARAMETERS and DECLARATION OF VARIABLEs ***********************
	*
	* dDate : Date, at which the required balance should be calculated; default: today
	* lForeignCurr	: if true _debf and _creF values are also returned from the SQLSelect 
	* lDetails: details of account are returned
	* A extra selection to be used in the where clause to select accounts can be given by: Balances:cAccSelection:=<selection criteria>, 
	*	e.g. a.department in(..,..,...) and a.balitemid in (..,..,..)  
	* A extra selection to be used in the where clause to select transactions can be given by: Balances:cTransSelection:=<selection criteria>, 
	*	e.g. t.accid in(..,..,...)   
	*
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
	*                                                                     
	* Generated SQL retrieves the following values:
	* per_deb (+per_debf)			: calculated debit balance value during required period  (+ foreign currency)
	* per_cre (+per_creF)  			: idem for credit
	* prvyr_deb (+prvyr_debf)		: calculated debit balance value during whole pevious year  (+ foreign currency)
	* prvyr_cre (+prvyr_creF)		: idem for credit
	* Besides that data of the accounts are returned:
	* - accid, 
	* and if lDetails: 
	* - category (assets/liability/income/expense)
	* - balitemid,
	* - currency,
	* - department 
	* - accnumber,
	* These values are returned after executing the generated string in an array balancevalues: 
	// {{accid,per_deb,per_cre,per_debf,per_cref,prvyr_deb,prvyr_cre,prvyr_debf,prvyr_cref,[balitemid,departemnt,category,currency,accnumber]},...} 
	//     1       2      3        4       5        6         7          8             9      10          11       12      13         14
	* All these values have the following meaning:
	* in case of Cost/profit       : sum of transactions during the specifief period,
	* in case of liabilities/assets: actual balance value at end of the specified period)   
	*
	* Thus needed accountbalanceyear: 
	*		if previous year closed:	year/month of required balance year 3 or one year before
	*		else:								year/month of LstYearClosed							
	**************
	*
	// 	LOCAL CurrStartYear, CurrStartMonth,CurrEndYear, CurrEndMonth as int // variables for stepping through years and months
	LOCAL CurrStartYear, CurrStartMonth as int // variables for stepping through years and months
	LOCAL PrvYearStartYr,PrvYearStartMn as int // starting year and month of previous year for assets and libalities 
	LOCAL PrevPeriodStart as int// start of previous period as number of months since year zero
	LOCAL PeriodStartYear, PeriodStartMonth   // start of requested period in years and months
	LOCAL PeriodStart as int // Idem but as number of months since year zero
	LOCAL PeriodEndYear, PeriodEndMonth as int // end of requested period in years and months
	LOCAL PeriodEnd as int // Idem but as number of months since year zero
	LOCAL LastClose as int // moment of last closing of balance year in number of months since year zero
	LOCAL CurrMonth as int // Current month during processing in number of months since year zero
	local YearBeginEnd:={} as array //{year start, monthstart, year end, month end}
	// 	LOCAL YearEnd as int // End of year as number of months since year zero
	// 	local PrvYearBeginEnd:={} as array //{previous year start, monthstart, year end, month end}
	local cprvyrCondition as string  // condition to select mbalance row into sum of Previous Year 
	local cprvperCondition as string  // condition to select mbalance row into sum of Previous Period 
	local cPerCondition as string  // condition to select mbalance row into sum of Required Period 
	local cmBalCondition as string  // condition to select mbalance mb 
	local cmTransCondition as string  // condition to select Transaction t 
	local cConditionAccBalYr as string // condition to select accountbalanceyear ay
	local cAccBalYrCondition as string  // condition to select accountbalanceyear into sum balance year 3
	local cStandardCurrCond,cNonStandardCurrCond as string // condition selecting standard and non standard currency
	local PrvYearNotClosed as logic
	local lBeforeUlt as logic  // required date before en of month  
	local dUltMonth as date
	local cStatement as string
	local cSelectx,cSelecty,cSelectz,cSelectt,cSelectR as string 

	LastClose := Round(Year(LstYearClosed)*12,0)+Month(LstYearClosed) 
	dUltMonth:=EndOfMonth(dDate)
	if	dDate < dUltMonth
		lBeforeUlt:=true
	endif
	*
	* Determine required period from inputparameters:
	*
	PeriodEndMonth:=Month(dDate)
	PeriodEndYear:=Year(dDate)
	* determine start of balance year of enddate:
	YearBeginEnd:=GetBalYear(PeriodEndYear,PeriodEndMonth)
	PeriodStartMonth := YearBeginEnd[2]
	PeriodStartYear:=YearBeginEnd[1]

	PeriodStart := Round(PeriodStartYear*12+ PeriodStartMonth,0)
	PeriodEnd   := Round(PeriodEndYear*12+ PeriodEndMonth-iif(lBeforeUlt,1,0),0)


	* Determine start and enddate of the previous year, previous period and moment
	* to start stepping through the months (CurrrStart):

	*	Determine start of corresponding balance year:
	YearBeginEnd:=GetBalYear(PeriodStartYear,PeriodStartMonth)
	CurrStartYear := YearBeginEnd[1]
	CurrStartMonth:= YearBeginEnd[2]
	// 	CurrEndYear := YearBeginEnd[3]
	// 	CurrEndMonth:= YearBeginEnd[4]
	// 	PrvYearBeginEnd:=GetBalYear(CurrStartYear-1,CurrStartMonth)
	PrevPeriodStart:=Integer(CurrStartYear*12)+CurrStartMonth  // i.e. beginning of corresponding balance year
	PrvYearNotClosed:=(PrevPeriodStart>LastClose)
	// 	YearEnd:=Integer(CurrEndYear*12)+CurrEndMonth   // end of current year

	IF PrvYearNotClosed
		*	start at first non closed year to cumulate from last svjd/c for assets/liability:
		PrvYearStartYr:=Year(LstYearClosed)
		PrvYearStartMn:=Month(LstYearClosed)
	else
		PrvYearStartYr:=CurrStartYear
		PrvYearStartMn:=CurrStartMonth
	endif
	// condition for selecting mbalance into sum previous year:
	if PrvYearStartYr==CurrStartYear-1 .and.PrvYearStartMn==CurrStartMonth
		// same period for costprofit as assets/liablities:
		cprvyrCondition:="if((mb.year*12+mb.month) between "+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+" and "+Str(PrevPeriodStart-1,-1)
	elseIF PrvYearNotClosed  // get also mbalance for previous year 
		cprvyrCondition:="if((mb.year*12+mb.month) between if(x.category between '"+income+"' and '"+expense+"',"+;
			Str((CurrStartYear-1)*12+CurrStartMonth,-1)+","+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+") and "+Str(PrevPeriodStart-1,-1)			
	else
		// no mbalance needed for (last year balance in Accountbalanceyear):
		cprvyrCondition:="if(mb.year<0"      // always false
	endif
	
	// condition for selecting mbalance into sum previous period: 
	if PrevPeriodStart=PeriodStart   
		// no previous period
		cprvperCondition:="if(mb.year<0"      // always false
	else
		cprvperCondition:="if((mb.year*12+mb.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(PeriodStart-1,-1)						
	endif

	// condition for selecting mbalance mb:
	IF PrvYearNotClosed 
		cmBalCondition:="(mb.year*12+mb.month) between "+Str(PrvYearStartYr*12+PrvYearStartMn,-1)+" and "+Str(PeriodEnd,-1)			
	else
		// only balance years of required period:
		cmBalCondition:="(mb.year*12+mb.month) between "+Str(PrevPeriodStart,-1)+" and "+Str(PeriodEnd,-1)						
	endif
	if !lForeignCurr
		cmBalCondition+=" and mb.currency='"+sCURR+"'"
	endif
	
	cPerCondition:="if((mb.year*12+mb.month) between "+Str(PeriodStart,-1)+" and "+Str(PeriodEnd,-1)

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

	if lForeignCurr
		cStandardCurrCond:=" and ay.currency='"+sCURR+"'"
		cNonStandardCurrCond:=" and ay.currency<>'"+sCURR+"'"
	else
		cStandardCurrCond:=""
	endif
	if	lBeforeUlt
		* Before	ultimo of the month?
		cmTransCondition:="t.dat>='"+Str(PeriodEndYear,4,0)+'-'+StrZero(PeriodEndMonth,2,0)+"-01' and t.dat<='"+SQLdate(dDate)+"'" +;
			iif(Empty(self:cTransSelection),"",'and '+self:cTransSelection)
		* Calculate	sum of transactions in last month: 
		cSelectt:=UnionTrans("select t.accid,"+'Round(sum(t.deb),2) as monthdeb,Round(sum(t.cre),2) as monthcre,'+;
			"Round(sum(t.debforgn),2) as monthdebf,Round(sum(t.creforgn),2) as monthcref "+;
			" from transaction as t where "+cmTransCondition +" group by t.accid")
	endif

	// cSelectx: Center select on account a and accountbalanceyear ay
	cSelectx:="select a.accid,b.category,a.currency,"+iif(lDetails,"a.balitemid,a.department,a.accnumber,","")+;
		"sum(IF("+cAccBalYrCondition+cStandardCurrCond+",ay.svjd,0)) as svjdyr3,sum(IF("+cAccBalYrCondition+cStandardCurrCond+",ay.svjc,0)) as svjcyr3"+;
		iif(lForeignCurr,;
		",sum(IF("+cAccBalYrCondition+cNonStandardCurrCond+",ay.svjd,0)) as svjdyr3f,sum(IF("+cAccBalYrCondition+cNonStandardCurrCond+",ay.svjc,0)) as svjcyr3f","")+;  
	iif(lBeforeUlt,",y.monthdeb,y.monthcre"+iif(lForeignCurr,",y.monthdebf,y.monthcref",""),"")+;		
	" from (account a, balanceitem b) left join accountbalanceyear ay ON (ay.accid=a.accid and "+cConditionAccBalYr+")"+;
		iif(lBeforeUlt," left join ("+cSelectt+") as y on (y.accid=a.accid)","")+;   
	" where a.balitemid=b.balitemid"+iif(Empty(self:cAccSelection),""," and "+self:cAccSelection)+" group by a.accid" 
	
	// cSelecty: 2e level select on x and mbalance mb
	if lForeignCurr
		cStandardCurrCond:=" and mb.currency='"+sCURR+"'"
		cNonStandardCurrCond:=" and mb.currency<>'"+sCURR+"'"
	else
		cStandardCurrCond:=""
	endif  
	cSelecty:="select x.*,"+;   
	"sum("+cprvyrCondition+cStandardCurrCond+",mb.deb,0)) as prvyr_deby,sum("+cprvyrCondition+cStandardCurrCond+",mb.cre,0)) as prvyr_crey,"+;
		"sum("+cprvperCondition+cStandardCurrCond+",mb.deb,0)) as prvper_deby,sum("+cprvperCondition+cStandardCurrCond+",mb.cre,0)) as prvper_crey," +;
		"sum("+cPerCondition+cStandardCurrCond+",mb.deb,0)) as per_deby,sum("+cPerCondition+cStandardCurrCond+",mb.cre,0)) as per_crey"+;
		iif(lForeignCurr,;
		",sum("+cprvyrCondition+cNonStandardCurrCond+",mb.deb,0)) as prvyr_debyf,sum("+cprvyrCondition+cNonStandardCurrCond+",mb.cre,0)) as prvyr_creyf"+;
		",sum("+cprvperCondition+cNonStandardCurrCond+",mb.deb,0)) as prvper_debyf,sum("+cprvperCondition+cNonStandardCurrCond+",mb.cre,0)) as prvper_creyf" +;
		",sum("+cPerCondition+cNonStandardCurrCond+",mb.deb,0)) as per_debyf,sum("+cPerCondition+cNonStandardCurrCond+",mb.cre,0)) as per_creyf","")+;
		" from ("+cSelectx+") as x left join mbalance as mb ON (mb.accid=x.accid and "+cmBalCondition+") group by x.accid"
	
	// cSelectz: 3e level select on y 
	cSelectz:="select y.accid,"+iif(lDetails,"y.balitemid,y.department,y.category,y.currency,y.accnumber,","")+; 
	"y.svjdyr3+y.prvyr_deby as prvyr_deb,y.svjcyr3+y.prvyr_crey as prvyr_cre,"+;
		"y.per_deby+if(category='"+LIABILITY+"' or category='"+ASSET+"',y.svjdyr3+y.prvyr_deby+y.prvper_deby,0)"+iif(lBeforeUlt,"+if(y.monthdeb IS NULL,0,y.monthdeb)","")+" as per_deb,"+;
		"y.per_crey+if(category='"+LIABILITY+"' or category='"+ASSET+"',y.svjcyr3+y.prvyr_crey+y.prvper_crey,0)"+iif(lBeforeUlt,"+if(y.monthcre IS NULL,0,y.monthcre)","")+" as per_cre"+;
		iif(lForeignCurr,;
		",y.per_debyf+if(category='"+LIABILITY+"' or category='"+ASSET+"',y.svjdyr3f+y.prvyr_debyf+y.prvper_debyf,0)"+iif(lBeforeUlt,"+if(y.monthdebf IS NULL,0,y.monthdebf)","")+" as per_debf"+;
		",y.per_creyf+if(category='"+LIABILITY+"' or category='"+ASSET+"',y.svjcyr3f+y.prvyr_creyf+y.prvper_creyf,0)"+iif(lBeforeUlt,"+if(y.monthcref IS NULL,0,y.monthcref)","")+" as per_cref"+;
		",y.svjdyr3f+y.prvyr_debyf as prvyr_debf,y.svjcyr3f+y.prvyr_creyf as prvyr_cref";
		,"")+;
		" from ("+cSelecty+") as y " 
	// make result an array:
	cSelectR:="select group_concat(cast(z.accid as char),',',cast(z.per_deb as char),',',cast(z.per_cre as char),',',"+;
		iif(lForeignCurr,"cast(z.per_debf as char),',',cast(z.per_cref as char),',',","',',',',")+;
		"cast(z.prvyr_deb as char),',',cast(z.prvyr_cre as char),',',"+;
		iif(lForeignCurr,"cast(z.prvyr_debf as char),',',cast(z.prvyr_cref as char)","',',','")+; 
	+iif(lDetails,",',',cast(z.balitemid as char),',',cast(z.department as char),',',z.category,',',z.currency,',',z.accnumber","")+; 
	" order by z.accid separator '#' ) as balances from ("+cSelectz+") as z group by 1=1"
	RETURN cSelectR
Function ChgBalance(pAccount as string,pRecordDate as date,pDebAmnt as float,pCreAmnt as float,pDebFORGN as float,pCreFORGN as float,Currency as string)  as logic
	******************************************************************************
	*              Update of month balance values per account
	*					Should be used between Start transaction and commit and  
	*              record to be changed should be locked for update beforehand                                        
	*  Auteur    : K. Kuijpers
	*  Date      : 21-09-2011
	******************************************************************************
	*
	local cValues as string 
	local oStmnt as SQLStatement
	local oMBal,oAcc as SQLSelect
	local lError as logic 
	IF !Empty(pDebAmnt).or.!Empty(pCreAmnt)
		// insert new one/update existing 
		if !Currency==sCurr
			if Empty(currency) .or. len(currency)<>3 
				Currency:=sCurr
			else
				SEval(Currency,{|c|lError:=iif(c<65 .or. c>90,true,lError)})
				if lError
					Currency:=sCurr
				endif
			endif
		endif
		if !(pDebAmnt==0.00.and.pCreAmnt==0.00)
			cValues:="("+pAccount+","+Str(Year(pRecordDate),-1)+","+Str(Month(pRecordDate),-1)+",'"+sCurr+"',"+Str(pDebAmnt,-1)+","+Str(pCreAmnt,-1)+")"
		endif 
		if !Currency==sCurr
			if !(pDebFORGN==pDebAmnt.and. pCreFORGN==pCreAmnt)
				if !(pDebFORGN==0.00.and.pCreFORGN=0.00)
					cValues+=iif(Empty(cValues),'',",")+"("+pAccount+","+Str(Year(pRecordDate),-1)+","+Str(Month(pRecordDate),-1)+",'"+Currency+"',"+Str(pDebFORGN,-1)+","+Str(pCreFORGN,-1)+")"
				endif
			endif
		endif
		if !Empty(cValues)
			oStmnt:=SQLStatement{"INSERT INTO mbalance (`accid`,`year`,`month`,`currency`,`deb`,`cre`) VALUES "+cValues+;
				" ON DUPLICATE KEY UPDATE deb=round(deb+values(deb),2),cre=round(cre+values(cre),2)",oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				LogEvent(,"ChgBalance error:"+oStmnt:Status:description+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
				return false
			endif
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

	
	oBalY:=SQLSelect{"select yearstart,monthstart,yearlength from balanceyear order by yearstart desc,monthstart desc",oConn}
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

	
// 	aYearStartEnd:=GetBalYear(Year(LstYearClosed),ClosingMonth)
	aYearStartEnd:=GetBalYear(Year(LstYearClosed),Month(LstYearClosed))
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
STATIC DEFINE  PREVPERIOD := 2
STATIC DEFINE  PREVYEAR := 1
