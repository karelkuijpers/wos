STATIC DEFINE AREAREPORT_AFSLDAG := 104 
STATIC DEFINE AREAREPORT_AFSLDAGTEXT := 103 
STATIC DEFINE AREAREPORT_BALANCETEXT := 102 
STATIC DEFINE AREAREPORT_CANCELBUTTON := 101 
STATIC DEFINE AREAREPORT_OKBUTTON := 100 
CLASS AskSend INHERIT DataDialogMine 

	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  export Result as shortint
RESOURCE AskSend DIALOGEX  4, 3, 265, 83
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"&No", ASKSEND_CANCELBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 132, 56, 53, 12
	CONTROL	"&Yes", ASKSEND_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 194, 55, 53, 12
	CONTROL	"Do you want the printed transactions to be sent to PMC?", ASKSEND_FIXEDTEXT1, "Static", WS_CHILD, 4, 7, 244, 12
	CONTROL	"(this is IRREVOCABLE)", ASKSEND_FIXEDTEXT2, "Static", WS_CHILD, 4, 25, 236, 13
END

METHOD CancelButton( ) CLASS AskSend 
     Result:=0
     self:EndWindow()
RETURN nil
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS AskSend 
LOCAL DIM aFonts[2] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"AskSend",_GetInst()},iCtlID)

aFonts[1] := Font{,9,"Microsoft Sans Serif"}
aFonts[2] := Font{,10,"Microsoft Sans Serif"}
aFonts[2]:Bold := TRUE

oCCCancelButton := PushButton{SELF,ResourceID{ASKSEND_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,_chr(38)+"No",NULL_STRING,NULL_STRING}
oCCCancelButton:TooltipText := "Do not send to PMC now!"

oCCOKButton := PushButton{SELF,ResourceID{ASKSEND_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,_chr(38)+"Yes",NULL_STRING,NULL_STRING}
oCCOKButton:TooltipText := "Transactions will be recorded and sent to PMC"

oDCFixedText1 := FixedText{SELF,ResourceID{ASKSEND_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Do you want the printed transactions to be sent to PMC?",NULL_STRING,NULL_STRING}
oDCFixedText1:Font(aFonts[1], FALSE)

oDCFixedText2 := FixedText{SELF,ResourceID{ASKSEND_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"(this is IRREVOCABLE)",NULL_STRING,NULL_STRING}
oDCFixedText2:TextColor := Color{255,0,0}
oDCFixedText2:Font(aFonts[2], FALSE)

SELF:Caption := "Send to PMC"
SELF:HyperLabel := HyperLabel{#AskSend,"Send to PMC",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS AskSend 
	self:Result:=1
	self:EndWindow()
RETURN NIL
method PostInit(oWindow,iCtlID,oServer,uExtra) class AskSend
	//Put your PostInit additions here 
	self:SetTexts()
	return NIL
STATIC DEFINE ASKSEND_CANCELBUTTON := 100 
STATIC DEFINE ASKSEND_FIXEDTEXT1 := 102 
STATIC DEFINE ASKSEND_FIXEDTEXT2 := 103 
STATIC DEFINE ASKSEND_OKBUTTON := 101 
CLASS AskUpld INHERIT DataDialogMine 

	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCTextQestion AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  export Result as shortint
RESOURCE AskUpld DIALOGEX  4, 3, 212, 86
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"&No", ASKUPLD_CANCELBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 84, 70, 53, 12
	CONTROL	"&Yes", ASKUPLD_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 144, 70, 53, 12
	CONTROL	"Has file with transactions successfully been uploaded without errors into Insite?", ASKUPLD_TEXTQESTION, "Static", WS_CHILD, 4, 7, 196, 29
	CONTROL	"(this is IRREVOCABLE)", ASKUPLD_FIXEDTEXT2, "Static", WS_CHILD, 4, 40, 196, 12
END

METHOD CancelButton( ) CLASS AskUpld 
     Result:=0
     self:EndWindow()
RETURN nil

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS AskUpld 
LOCAL DIM aFonts[2] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"AskUpld",_GetInst()},iCtlID)

aFonts[1] := Font{,9,"Microsoft Sans Serif"}
aFonts[2] := Font{,10,"Microsoft Sans Serif"}
aFonts[2]:Bold := TRUE

oCCCancelButton := PushButton{SELF,ResourceID{ASKUPLD_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,_chr(38)+"No",NULL_STRING,NULL_STRING}
oCCCancelButton:TooltipText := "Upload not successfull!"

oCCOKButton := PushButton{SELF,ResourceID{ASKUPLD_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,_chr(38)+"Yes",NULL_STRING,NULL_STRING}
oCCOKButton:TooltipText := "Transactions will be recorded"

oDCTextQestion := FixedText{SELF,ResourceID{ASKUPLD_TEXTQESTION,_GetInst()}}
oDCTextQestion:HyperLabel := HyperLabel{#TextQestion,"Has file with transactions successfully been uploaded without errors into Insite?",NULL_STRING,NULL_STRING}
oDCTextQestion:Font(aFonts[1], FALSE)

oDCFixedText2 := FixedText{SELF,ResourceID{ASKUPLD_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"(this is IRREVOCABLE)",NULL_STRING,NULL_STRING}
oDCFixedText2:TextColor := Color{255,0,0}
oDCFixedText2:Font(aFonts[2], FALSE)

SELF:Caption := "Send to PMC"
SELF:HyperLabel := HyperLabel{#AskUpld,"Send to PMC",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS AskUpld 
	self:Result:=1
	self:EndWindow()
RETURN nil
method PostInit(oWindow,iCtlID,oServer,uExtra) class AskUpld
	//Put your PostInit additions here
	self:SetTexts() 
	self:oDCTextQestion:TextValue:=self:oLan:WGet("Has file")+Space(1)+uExtra+Space(1)+self:oLan:WGet("successfully been uploaded to Insite")+"?"
	return NIL

STATIC DEFINE ASKUPLD_CANCELBUTTON := 100 
STATIC DEFINE ASKUPLD_FIXEDTEXT2 := 103 
STATIC DEFINE ASKUPLD_OKBUTTON := 101 
STATIC DEFINE ASKUPLD_TEXTQESTION := 102 
STATIC DEFINE CONFIRMSEND_CANCELBUTTON := 101 
STATIC DEFINE CONFIRMSEND_FIXEDTEXT1 := 102 
STATIC DEFINE CONFIRMSEND_FIXEDTEXT2 := 103 
STATIC DEFINE CONFIRMSEND_OKBUTTON := 100 
STATIC DEFINE IESREPORT_AFSLDAG := 100 
STATIC DEFINE IESREPORT_AFSLDAGTEXT := 104 
STATIC DEFINE IESREPORT_BALANCETEXT := 103 
STATIC DEFINE IESREPORT_CANCELBUTTON := 102 
STATIC DEFINE IESREPORT_OKBUTTON := 101 
RESOURCE PMISsend DIALOGEX  13, 12, 319, 143
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"OK", PMISSEND_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 250, 16, 53, 12
	CONTROL	"Cancel", PMISSEND_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 250, 33, 53, 12
	CONTROL	"Fixed Text", PMISSEND_BALANCETEXT, "Static", WS_CHILD, 12, 19, 221, 29
	CONTROL	"Up to day:", PMISSEND_AFSLDAGTEXT, "Static", WS_CHILD, 23, 67, 39, 13
	CONTROL	"donderdag 30 mei 2013", PMISSEND_AFSLDAG, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 92, 66, 118, 14
	CONTROL	"", PMISSEND_MAXTRANSID, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 92, 81, 54, 13, WS_EX_CLIENTEDGE
	CONTROL	"Up till transaction#", PMISSEND_TRANSACTIONEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 24, 84, 64, 13
END

CLASS PMISsend INHERIT DataWindowExtra 

	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCBalanceText AS FIXEDTEXT
	PROTECT oDCAfsldagtext AS FIXEDTEXT
	PROTECT oDCAfsldag AS DATESTANDARD
	PROTECT oDCMaxTransId AS MYSINGLEEDIT
	PROTECT oDCTransactionext AS FIXEDTEXT

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	//   	PROTECT oAcc as SQLSelect
	//   	PROTECT oTrans as SQLSelect
	PROTECT oSys as SQLSelect
	//   	PROTECT oMbr as SQLSelect
	//   	PROTECT oMBal as SQLSelect
	//   	PROTECT BalYear, BalMonth, nRowCnt AS INT
	// 	PROTECT BalMonthStart, BalMonthEnd AS DATE
	PROTECT closingDate as date
	protect sAssmntOffc,sWithldOffl,sWithldOffM,sWithldOffH as FLOAT
	protect sAssmntField as FLOAT
	protect sPercAssInt as FLOAT
	protect AssPeriod as STRING
	protect cPMCCurr as string // currency of Clearance PMC account
	protect mxrate as float
	PROTECT rmaand as STRING 
	protect nMaxTransid as int // maximum transid up till which report trasnactions to PMC
	
	declare method RefreshLocks
METHOD CancelButton( ) CLASS PMISsend
 	SELF:EndWindow()
	RETURN TRUE
METHOD Close(oEvent) CLASS PMISsend
	SUPER:Close(oEvent)
	//Put your changes here
	SELF:Destroy()
	RETURN
method DateTimeSelectionChanged(oDateTimeSelectionEvent) class PMISsend
	local oControl as Control 
	local oSel as SQLSelect
	oControl := iif(oDateTimeSelectionEvent == null_object, null_object, oDateTimeSelectionEvent:Control)
	super:DateTimeSelectionChanged(oDateTimeSelectionEvent)
	//Put your changes here 
	if oControl:NameSym=#Afsldag
		if self:oDCAfsldag:SelectedDate < Today()
			self:oDCTransactionext:Show()
			self:oDCMaxTransId:Show()
			oSel:=SqlSelect{'select max(transid) as maxtr from transaction where dat<="'+SQLdate( self:oDCAfsldag:SelectedDate)+'" and gc<>""',oConn}
			if oSel:RecCount>0
				self:oDCMaxTransId:Value :=ConI(oSel:maxtr)
			endif
		endif 
		
	endif
	
	return NIL


METHOD HTMLConv(tekst) CLASS PMISsend
	// Converting text to html appriate text
	tekst:=StrTran(tekst,"&","&amp;")
	tekst:=StrTran(tekst,'"',"&quot;")
	tekst:=StrTran(tekst,"<","&lt;")
	tekst:=StrTran(tekst,">","&gt;")
	// tekst:=StrTran(tekst,"!","&iexcl;")

	RETURN tekst
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS PMISsend 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"PMISsend",_GetInst()},iCtlID)

oCCOKButton := PushButton{SELF,ResourceID{PMISSEND_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{PMISSEND_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCBalanceText := FixedText{SELF,ResourceID{PMISSEND_BALANCETEXT,_GetInst()}}
oDCBalanceText:HyperLabel := HyperLabel{#BalanceText,"Fixed Text",NULL_STRING,NULL_STRING}

oDCAfsldagtext := FixedText{SELF,ResourceID{PMISSEND_AFSLDAGTEXT,_GetInst()}}
oDCAfsldagtext:HyperLabel := HyperLabel{#Afsldagtext,"Up to day:",NULL_STRING,NULL_STRING}

oDCAfsldag := DateStandard{SELF,ResourceID{PMISSEND_AFSLDAG,_GetInst()}}
oDCAfsldag:FieldSpec := Subscription_P04{}
oDCAfsldag:HyperLabel := HyperLabel{#Afsldag,NULL_STRING,"Transactions up to this date will be send",NULL_STRING}
oDCAfsldag:UseHLforToolTip := True

oDCMaxTransId := mySingleEdit{SELF,ResourceID{PMISSEND_MAXTRANSID,_GetInst()}}
oDCMaxTransId:TooltipText := "Maximum transaction# up till which sould be sent to PMC"
oDCMaxTransId:Picture := "99999999999"
oDCMaxTransId:HyperLabel := HyperLabel{#MaxTransId,NULL_STRING,NULL_STRING,NULL_STRING}

oDCTransactionext := FixedText{SELF,ResourceID{PMISSEND_TRANSACTIONEXT,_GetInst()}}
oDCTransactionext:HyperLabel := HyperLabel{#Transactionext,"Up till transaction#",NULL_STRING,NULL_STRING}

SELF:Caption := "Sending Transactions to PMC"
SELF:HyperLabel := HyperLabel{#PMISsend,"Sending Transactions to PMC",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS MaxTransId() CLASS PMISsend
RETURN SELF:FieldGet(#MaxTransId)

ASSIGN MaxTransId(uValue) CLASS PMISsend
SELF:FieldPut(#MaxTransId, uValue)
RETURN uValue

METHOD OKButton( ) CLASS PMISsend
	LOCAL oWarn as warningbox, lSuc as LOGIC 
	local oAcc as SQLSelect
	
	self:closingDate := oDCAfsldag:Value 
	if !Empty(self:oSys:PMISLSTSND) .and. self:closingDate>self:oSys:PMISLSTSND
// 		self:AssPeriod:="("+DToC(self:oSys:PMISLSTSND)+" - "+DToC(self:closingDate)+")"
		self:AssPeriod:=DToC(self:oSys:pmislstsnd)+" - "+DToC(self:closingDate)
	else
// 		self:AssPeriod:="( - "+DToC(self:closingDate)+")"
		self:AssPeriod:=" - "+DToC(self:closingDate)
	endif
	self:nMaxTransid:=ConI(self:MaxTransId)
	* check if there are non earmarked gifts: 
	if !Empty(SPROJ).and.SQLSelect{"select transid from transaction where accid='"+SPROJ+"' and BFM='O' and dat <='"+SQLdate(self:closingDate)+"'",oConn}:Reccount>0
		oWarn := WarningBox{self:Owner,self:oLan:WGet("Partner Monetary Interchange System"),;
			self:oLan:WGet('Do you wish to allot non-designated gifts first')}
		oWarn:Type := BOXICONQUESTIONMARK + BUTTONYESNO
		IF (oWarn:Show() = BOXREPLYYES)
			SELF:EndWindow()
			RETURN TRUE
		ENDIF
	ENDIF
	IF Empty(sam).or. Empty(shb)
		(ErrorBox{self:Owner,self:oLan:WGet('Add first account for PMC/AM result to system data')}):Show()
		SELF:EndWindow()
		RETURN TRUE
	ENDIF
	IF Empty(SEntity)
		(ErrorBox{self:Owner,self:oLan:WGet('First specify PMC Participant Code in System parameter, tab PMC')}):Show()
		SELF:EndWindow()
		RETURN TRUE
	ENDIF
	IF self:sAssmntField=0.00 .or.self:sAssmntOffc=0.00 .or. self:sPercAssInt=0.00
		(ErrorBox{self:Owner,self:oLan:WGet('First specify all assesment percentages in System parameter, tab PMC')}):Show()
		SELF:EndWindow()
		RETURN TRUE
	ENDIF
	IF Empty(sCURR) .or. Empty(sCURRNAME)
		(ErrorBox{self:Owner,self:oLan:WGet('First specify the currency in System parameters')}):Show()
		SELF:EndWindow()
		RETURN TRUE
	ENDIF

	* Check for presence of hb en am: 
	oAcc:=SqlSelect{"select currency from account where accid="+shb,oConn}
	if oAcc:reccount<1 
			(ErrorBox{self:Owner,self:oLan:WGet('Add first account for PMC Clearance')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF
	self:cPMCCurr:=iif(Empty(oAcc:Currency),sCurr,oAcc:Currency)

	*Verzamelpost AM
	oAcc:=SqlSelect{"select currency from account where accid="+sam,oConn}
	if oAcc:reccount<1 
		(ErrorBox{self:OWNER,self:oLan:WGet('Add first account for AssessMents')}):Show()
		SELF:EndWindow()
		RETURN TRUE
	ENDIF

	self:PrintReport()
// 	self:PrintReportNew()
	self:EndWindow()
	RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS PMISsend
	//Put your PostInit additions here 
	local aBalPrv:={}, aBalNow:={} as array
self:SetTexts()                                   
	SaveUse(self)
self:oSys := SQLSelect{"select assmntfield,assmntoffc,withldoffl,withldoffm,withldoffh,assmntint,"+;
"exchrate,cast(pmislstsnd as date) as pmislstsnd,cast(datlstafl as date) as datlstafl,pmcupld,pmcmancln,iesmailacc,ownmailacc from sysparms",oConn}
IF self:oSys:Reccount <1
	self:ENDWindow()
ENDIF

self:sAssmntField := self:oSys:assmntfield
self:sAssmntOffc := self:oSys:assmntOffc
self:sWithldOffl := self:oSys:withldoffl
self:sWithldOffM := self:oSys:withldoffM
self:sWithldOffH := self:oSys:withldoffH
self:sPercAssInt := self:oSys:assmntint
self:mxrate := oSys:EXCHRATE
self:oDCAfsldag:DateRange:=DateRange{mindate,Today()}
if !Empty(self:oSys:PMISLSTSND)
	aBalPrv:=GetBalYear(Year(self:oSys:PMISLSTSND),Month(self:oSys:PMISLSTSND))
	aBalNow:=GetBalYear(Year(Today()),Month(Today())) 
	if !aBalPrv==aBalNow
		self:oDCAfsldag:SelectedDate := SToD(Str(aBalPrv[3],4,0)+StrZero(aBalPrv[4],2,0)+StrZero(MonthEnd(aBalPrv[4],aBalPrv[3]),2,0))
	endif
endif
self:closingDate := self:oDCAfsldag:SelectedDate

self:oDCBalanceText:TextValue :='Sending of member transactions to PMC. Last send on: '+DToC(iif(Empty(self:oSys:PMISLSTSND),null_date,self:oSys:PMISLSTSND))

RETURN nil
METHOD PrintReport() CLASS PMISsend
	LOCAL DecSep as int
	local nAnswer as int 
	LOCAL CurMonth:=Year(self:closingDate)*100+Month(self:closingDate) as int
	local nTransLock as Dword,nTransSample as int
	local nRow, nPage as int
	LOCAL i,j,k,nMbr,nMbrAss,nMbrRPP,nMbrBal,nAccmbr,nTrans,nTransnrDT,a_tel, batchcount, directcount, iDest, iType,nSeqnr,nSeqnrDT,nRowCnt,CurrentMbrID as int
	LOCAL AssInt,AssOffice,AssOfficeProj,AssOfficeOFR,AssField,AssFldInt,AssFldIntHome,me_balance,me_balanceF,OfficeRate,TotAssrate as FLOAT
	local AssInc,AssIncHome as float  // to be reversed assement income totals
	LOCAL mbrint,mbrfield,mbroffice,mbrofficeProj,mbrofficeOFR as FLOAT
	local fExChRate as float
	LOCAL DestAmnt as FLOAT
	local time1,time0 as float
	LOCAL AmntTrans,remainingAmnt,AmntFromRPP,me_amount,availableAmnt,me_asshome,me_amounttot,me_assblAmount, amntlimited,AmntCorrection,fDiff as FLOAT
	LOCAL mo_tot,mo_totF, AmountDue,mo_direct, BalanceSend,BalanceSendEoM  as FLOAT
	local separatorline as STRING
	LOCAL cFilename, datestr as STRING
	Local cAccCng as string
	local cErrMsg as string 
	LOCAL cPMISMail as STRING 
	LOCAL cDestAcc,cNoteText,cError,cErrorLog,cStmsg,cAccs,cCurAcc as STRING 
	local cDistr as string
	local cFatalError as string 
	local Country as string 
	local cStmnt,cClosingdate,cDueDate as string 
	local cTransStmnt,cTransDTStmnt,cBankStmnt as string  
	local cMbrSelect,cMbrSelectArr as string
	LOCAL me_accid,currentaccid,me_mbrid, me_gc,PMCco,  me_stat, me_co, me_type, me_accnbr, me_pers,me_homePP,me_desc,destAcc,me_rate as STRING
	LOCAL cTransnr,cTransnrDT,mHomeAcc, cDestPersonId,me_householdid, me_destAcc,me_destPP,me_currency,cSeqnr,cToday,cPeriodBegin,cPeriodEnd as STRING
	LOCAL me_has as LOGIC
	LOCAL lSent as LOGIC
	LOCAL PrvYearNotClosed as LOGIC
	local lStop:=true,PMCUpload as logic
	LOCAL datelstafl as date
	LOCAL uRet as USUAL
	local heading as ARRAY
	local oCurr as CURRENCY
	local aAcc:={} as array 
	LOCAL aMemberTrans:={} as ARRAY
	LOCAL destinstr:={} as ARRAY 
	local aDistr:={} as array 
	local aRecip:={} as array // {{name,email,persid},...}
	local aDisLock:={},aYearStartEnd as array                        
	local aMbr:={} as array   // array with all data of all members   :
	// {{mbrid,description,homepp,homeacc,housholdid,co,has,grade,offcrate,accid,accnumber,currency,type,accidinc,accnumberinc,descriptioninc,currencyinc,accidexp,accnumberexp,descriptionexp,currencyexp,accidnet,accnumbernet,descriptionnet,currencynet,homeppname,distr},...}
	//     1       2         3       4        5       6  7     8      9      10       11     12     13       14          15        16             17           18         19         20            21           22        23          24           25          26        27
	// with cDistr: {{desttyp,destamt,destpp,destacc,lstdate,seqnbr,descrptn,currency,amntsnd, singleuse,ppname},...
	//                   1       2       3      4        5      6      7         8      9         10       11
	local aAccidMbr:={} as array  // array with accids of all members : {accid,mbrid,category},... 
	local aBalMbr:={} as array  // array with balance per member; {{mbrid,balance},...
	local aAccidRPP:={} as array  // array with accids of all members with remaining RPP distrbution instruction: {accid,mbrid},...  
	local aAccidMbrF:={} as array  // array with accids of all foreign members : {accid,mbrid},...
	local aPersDest:={} as array // array with destination persons of distribution instructions: {{bankaccntname,persid,fullname},...}
	local aDBBalValue:={} as array
	local aAssTot:={} as array   // array with total assessable amount per accid  {{accid,asstot},... 
	local aAssMbr:={} as array   // array with total assessable amounts+assessments per membrid {{mbrid,calcdate,assessmnttotal,periodbegin,periodend,amountassessed,amountofficeassmnt,amountintassmnt,percofficeassmnt,percintassmnt},...  
	//                                                                  1      2         3             4           5             6              7                  8             9                10
	local aAccRPP:={} as array   // array with total RPP amount per accid    {{accid,rpptot},...}
	local aRPPMbr:={} as array   // array with total RPP amount per mbrid    {{mbrid,rpptot},...}
	local aTransF:={} as array  // array with transactions of all non-own members not yet sent to PMC:  accid,transid,seqnr,persid,description,deb,cre,gc,reference,dat,givername,fromRPP  
	local aAccDestOwn:={} as array  // array with destination accounts within own system: {{accid,accnumber},...}
	local aTransMT:={} as array  // array with values to be inserted into table transaction for PMC transactions
	local aTransDT:={} as array  // array with values to be inserted into table transaction for direct transactions
	//aTransMT: accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
	//            1    2     3      4      5      6            7      8   9  10   11         12    13     14      15  
	local aBankOrder:={} as array  // 
	LOCAL ptrHandle 
	local oReport as PrintDialog
	LOCAL oWindow as OBJECT
	LOCAL oMapi as MAPISession
	LOCAL oRecip,oRecip2 as MAPIRecip
	local oSendMail as SendEmailsDirect
	// 	LOCAL CurMonth:=Year(Today())*100+Month(Today()) as int
	// 	LOCAL noIES as LOGIC
	LOCAL oAfl as UpdateHouseHoldID
	local oAsk as AskSend 
	local oAskUp as AskUpld 
	local oTrans,oMbr,oAccD,oPers,oPersB,oBal, oAccBal,oSel as SQLSelect	 
	local oMBal as Balances
	local oStmnt,oStmntDistr as SQLStatement
	local oGetDep as GetDepAccount


	oWindow:=GetParentWindow(self) 
	// Import first account change list 
	oWindow:Pointer := Pointer{POINTERHOURGLASS}
	oAfl:=UpdateHouseHoldID{}
	oAfl:Importaffiliated_person_account_list()

	oWindow:Pointer := Pointer{POINTERARROW}

	// 	oReport := PrintDialog{self,self:oLan:RGet("Sending transactions to PMC"),,160,DMORIENT_LANDSCAPE}
	// 	oReport:Show()
	// 	IF .not.oReport:lPrintOk
	// 		RETURN FALSE
	// 	ENDIF
	oCurr:=Currency{"Sending to PMC"}
	fExChRate:=Round(oCurr:GetROE("USD",Today(),true,true,1.65),8)   // limit to 8 digits because that is sent to PMC 
	if oCurr:lStopped
		Return
	endif 
	Country:=SqlSelect{"select countryown from sysparms",oConn}:FIELDGET(1)

	PMCUpload:= iif(ConI(self:oSys:PMCUPLD)=1,true,false)
	// fExChRate:=self:mxrate 

	store 0 to AssInt,AssOffice,AssOfficeProj,AssOfficeOFR,AssField,AssInc,AssIncHome,AssFldInt,AssFldIntHome
	cClosingdate:=SQLdate(self:closingDate)
	cDueDate:=SQLdate(Today())

	if Empty(self:oSys:PMCMANCLN) 
		(ErrorBox{oWindow,self:oLan:WGet("Enter first within the system parameters")+" "+self:oLan:WGet("PMC Manager who should approve the PMC file")}):Show()
		// 		self:ENDWindow()
		self:Pointer := Pointer{POINTERARROW}
		return
	else
		oPers:=SqlSelect{"select persid,email,"+SQLFullName()+" as fullname from person where persid="+Str(self:oSys:PMCMANCLN,-1),oConn}
		if oPers:Reccount<1
			(ErrorBox{oWindow,self:oLan:WGet("Enter first within the system parameters")+" "+self:oLan:WGet("PMC Manager who should approve the PMC file")}):Show()
			// 			self:ENDWindow()
			self:Pointer := Pointer{POINTERARROW}
			SetDecimalSep(Asc('.'))
			return
		elseif Empty(oPers:email)
			(ErrorBox{oWindow,self:oLan:WGet("Enter first email address for PMC manager")+" "+oPers:fullname+' '+self:oLan:WGet("who should approve the PMC file")}):Show()
			// 			self:ENDWindow()
			self:Pointer := Pointer{POINTERARROW}
			return
			
		endif
	endif  
	self:Pointer := Pointer{POINTERHOURGLASS}

	self:oSys:EXCHRATE := fExChRate 

	// Select member data:
	cMbrSelect:="select m.mbrid,m.homepp,m.homeacc,m.householdid,m.co,m.has,m.grade,m.offcrate,"+;
		"ad.accid,ad.accnumber,"+SQLFullName(0,"p")+" as description,ad.currency,b.category as type,"+;
		"ai.accid as accidinc,ai.accnumber as accnumberinc,ai.description as descriptioninc,ai.currency as currencyinc,"+;
		"ae.accid as accidexp,ae.accnumber as accnumberexp,ae.description as descriptionexp,ae.currency as currencyexp,"+;
		"an.accid as accidnet,an.accnumber as accnumbernet,an.description as descriptionnet,an.currency as currencynet,"+;
		"pp.ppname as homeppname,"+;
		"group_concat(cast(d.desttyp as char),'##',cast(d.destamt as char),'##',d.destpp,'##',d.destacc,'##',cast(d.lstdate as char),'##',cast(d.seqnbr as char),'##',"+;
		"d.descrptn,'##',d.currency,'##',cast(d.amntsnd as char),'##',cast(d.singleuse as char),'##',pd.ppname separator '#;#') as distr,if(isnull(m.depid),'0',cast(m.depid as char)) as depid " +;
		" from member m left join ppcodes pp on (pp.ppcode=m.homepp) "+;
		" left join distributioninstruction d on (d.mbrid=m.mbrid and d.disabled=0) left join ppcodes pd on (d.destpp=pd.ppcode) "+;
		" left join account ad on (ad.accid=m.accid) left join balanceitem b on (b.balitemid=ad.balitemid) left join department dm on (dm.depid=m.depid) left join account ai on (ai.accid=dm.incomeacc) "+;
		" left join account ae on (ae.accid=dm.expenseacc) left join account an on (an.accid=dm.netasset),person p "+;   
	" where m.persid=p.persid group by m.mbrid order by m.mbrid"
	cMbrSelectArr:="select group_concat(cast(mbrid as char),'#$#',description,'#$#',homepp,'#$#',homeacc,'#$#',householdid,'#$#',co,'#$#',cast(has as char),'#$#',grade,'#$#',offcrate,'#$#',"+;
		"if(isnull(accid),'#$##$##$##$#',concat(cast(accid as char),'#$#',accnumber,'#$#',currency,'#$#',cast(type as char),'#$#')),"+;
		"if(isnull(accidinc),'#$##$##$##$#',concat(cast(accidinc as char),'#$#',accnumberinc,'#$#',descriptioninc,'#$#',currencyinc,'#$#')),"+;
		"if(isnull(accidexp),'#$##$##$##$#',concat(cast(accidexp as char),'#$#',accnumberexp,'#$#',descriptionexp,'#$#',currencyexp,'#$#')),"+;
		"if(isnull(accidnet),'#$##$##$##$#',concat(cast(accidnet as char),'#$#',accnumbernet,'#$#',descriptionnet,'#$#',currencynet,'#$#')),"+;
		"coalesce(homeppname,''),'#$#',coalesce(distr,''),'#$#',depid order by mbrid separator '#%#') as grMbr"+;
		" from ("+cMbrSelect+") as y group by 1=1" 
	oMbr:=SqlSelect{cMbrSelectArr,oConn}
	if oMbr:Reccount<1 .or. Empty(oMbr:grMbr)
		LogEvent(self,oMbr:SQLString,"logerrors") 
		WarningBox{oWindow,self:oLan:WGet("Send to PMC"),self:oLan:WGet("No members specified")}:Show()
		return
	endif
	// add to aMbr:
	// {{mbrid,description,homepp,homeacc,housholdid,co,has,grade,offcrate,accid,accnumber,currency,type,accidinc,accnumberinc,descriptioninc,currencyinc,accidexp,accnumberexp,descriptionexp,currencyexp,accidnet,accnumbernet,descriptionnet,currencynet,homeppname,distr,depid},...}
	//     1       2         3       4        5       6  7     8      9      10       11     12     13       14          15        16             17           18         19         20            21           22        23          24           25          26        27    28
	// with cDistr: {{desttyp,destamt,destpp,destacc,lstdate,seqnbr,descrptn,currency,amntsnd, singleuse,ppname},...
	//                   1       2       3      4        5      6      7         8      9         10       11
	aMbr:=AEvalA(Split(oMbr:grMbr,'#%#',,true),{|x|x:=Split(x,'#$#',,true) })
	// expand distribution instructions:
	for i:=1 to Len(aMbr)
		if !Empty(aMbr[i,27]) 
			aMbr[i,27]:=AEvalA(Split(aMbr[i,27],"#;#"),{|x|x:=Split(x,'##')})
			// collect own destination accounts: 
			for j:=1 to Len(aMbr[i,27])
				if aMbr[i,27,j,3]=SEntity .and. !Empty(aMbr[i,27,j,4])  // destination is account within own system? 
					if AScan(aAccDestOwn,{|x|x[2]==aMbr[i,27,j,4]})=0
						AAdd(aAccDestOwn,{'',aMbr[i,27,j,4]})       // {accid,accnumer}
					endif
				endif
			next
		else
			aMbr[i,27]:={}
		endif
	next
	// check distribution instructions:
	oSel:=SqlSelect{"select cast(mbrid as char) as mbrid,destacc from distributioninstruction d where destpp='AAA' and not exists (select 1 from personbank where banknumber= d.destacc)",oConn}
	if oSel:Reccount>0
		cError:=self:oLan:WGet("Following members contain an illegal distribution instruction")+':'
		do while !oSel:EOF
			i:=AScan(aMbr,{|x|x[1]==oSel:mbrid})
			IF i>0
				cError+=CRLF+aMbr[i,2]+' '+self:oLan:WGet("not found banknbr")+' '+oSel:destAcc
			endif
			oSel:skip()
		enddo
		ErrorBox{self,cError}:Show()   
		return
	endif 
	// collect destination persons:
	oSel:=SqlSelect{"select group_concat(d.destacc,'#$#',cast(b.persid as char),'#$#',"+SQLFullName(0,'p')+" separator '#%#') as grpers from distributioninstruction d, personbank b, person p where d.destpp='AAA' and d.destacc=b.banknumber and b.persid=p.persid group by 1=1",oConn}
	if oSel:Reccount>0
		aPersDest:=AEvalA(Split(oSel:grpers,"#%#",,true),{|x|x:=Split(x,'#$#',,true)}) 
	endif  
	// Check member data:
	i:=AScan(aMbr,{|x|Empty(x[26])})  // scan for empty homeppname
	if i>0
		cError:=self:oLan:WGet("Member")+' '+aMbr[i,2]+' '+self:oLan:WGet("contains an illegal Primary Finance entity")+':'+aMbr[i,3]	
		(ErrorBox{self,cError}):Show()
		return
	endif 
	// scan for: HOMEPP # SEntity .and. !Empty(accid) .and. (!TYPE==LIABILITY.and. !TYPE== asset )
	i:=AScan(aMbr,{|x|!x[3]==SEntity .and. !Empty(x[10]) .and.(!x[13]==LIABILITY .and. !x[13]==asset)})
	if i>0
		cError:=oLan:WGet("Non-own")+" "+ self:oLan:WGet("member")+' '+aMbr[i,2]+' '+self:oLan:WGet("should have a liability/funds or asset account")
		(ErrorBox{self,cError}):Show()
		return
	endif
	if Len(aAccDestOwn)>0
		// collect own destination accounts
		oSel:=SqlSelect{"select group_concat(cast(accid as char),'#$#',accnumber separator '#%#') as owndest from account where accnumber in ("+Implode(aAccDestOwn,'","',,,2)+") and active=1",oConn}
		if oSel:Reccount>0 .and. !Empty(oSel:owndest)
			aAccDestOwn:=AEvalA(Split(oSel:owndest,'#%#',,true),{|x|x:=Split(x,'#$#',,true)})
		else
			aAccDestOwn:={}
		endif
	endif
	// make array of all accids:
	oGetDep :=GetDepAccount{}   // get structure of departments for determinining expense accounts in hierarchy
	for i:=1 to Len(aMbr)
		if !Empty(aMbr[i,10])     // account member
			AAdd(aAccidMbr,{aMbr[i,10],aMbr[i,1],aMbr[i,13]}) 
			if !aMbr[i,3]==SEntity
				// add to accids foreign members:
				AAdd(aAccidMbrF,{aMbr[i,10],aMbr[i,1]})
			elseif AScan(aMbr[i,27],{|x|x[1]=='3'})>0 
				// add to accids members with remaining RPP instruction:
				AAdd(aAccidRPP,{aMbr[i,10],aMbr[i,1]})				
			endif 
		else  // department member
// 			if Empty(aMbr[i,18])
// 				aAcc:=oGetDep:GetAccount(aMbr[i,28],expense)
// 				if Len(aAcc)>=3
// 					aMbr[i,18]:= aAcc[1]
// 					aMbr[i,19]:= aAcc[2]
// 					aMbr[i,20]:= aAcc[3]
// 				endif
// 			endif						
// 			if Empty(aMbr[i,22])
// 				aAcc:=oGetDep:GetAccount(aMbr[i,28],liability)
// 				if Len(aAcc)>=3
// 					aMbr[i,22]:= aAcc[1]
// 					aMbr[i,23]:= aAcc[2]
// 					aMbr[i,24]:= aAcc[3]
// 				endif
// 			endif						
			AAdd(aAccidMbr,{aMbr[i,14],aMbr[i,1],income})
			AAdd(aAccidMbr,{aMbr[i,18],aMbr[i,1],expense})
			AAdd(aAccidMbr,{aMbr[i,22],aMbr[i,1],liability})
			if !aMbr[i,3]==SEntity
				// add to accids foreign members:
				AAdd(aAccidMbrF,{aMbr[i,14],aMbr[i,1]})
				AAdd(aAccidMbrF,{aMbr[i,18],aMbr[i,1]})
				AAdd(aAccidMbrF,{aMbr[i,22],aMbr[i,1]})
			elseif AScan(aMbr[i,27],{|x|x[1]=='3'})>0 
				// add to accids members with remaining RPP instruction:
				AAdd(aAccidRPP,{aMbr[i,14],aMbr[i,1]})				
				AAdd(aAccidRPP,{aMbr[i,18],aMbr[i,1]})				
				AAdd(aAccidRPP,{aMbr[i,22],aMbr[i,1]})				
			endif
		endif
	next 

	// Check if nobody else is busy with sending to PMC: 
	// 	(time1:=Seconds())   
	oTrans:=SqlSelect{'select transid from transaction t '+;
		" where t.bfm='' and t.dat<='"+SQLdate(self:closingDate)+"' and t.gc>'' and "+iif(Empty(self:nMaxTransid),"","t.transid<="+Str(self:nMaxTransId,-1)+" and ")+;
		" t.lock_id<>0 and t.lock_id<>"+MYEMPID+" and t.lock_time > subdate(now(),interval 120 minute)",oConn}
	if oTrans:Reccount>0
		ErrorBox{self,self:oLan:WGet("somebody else busy with sending to PMC")}:Show()
		return
	endif 
	// Check consistency data
	self:STATUSMESSAGE(self:oLan:WGet("Checking data, please wait")+"...")
	if !CheckConsistency(self,true,false,@cFatalError) 
		if !Empty(cFatalError)
			ErrorBox{self,cFatalError}:Show()
			// 		self:ENDWindow()
			self:Pointer := Pointer{POINTERARROW}
			return
		endif 
	endif
	oReport := PrintDialog{self,self:oLan:RGet("Sending transactions to PMC"),,160,DMORIENT_LANDSCAPE}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	time0:=time1 
	self:STATUSMESSAGE(self:oLan:WGet('locking member transactions for update')+'...')

	oStmnt:=SQLStatement{"set autocommit=0",oConn}
	oStmnt:Execute()
	oStmnt:=SQLStatement{'lock tables `transaction` write',oConn} 
	oStmnt:Execute()
	oStmnt:=SQLStatement{'update transaction set lock_id="'+MYEMPID+'",lock_time=now() where '+;
		" bfm='' and dat<='"+SQLdate(self:closingDate)+"' and gc>''"+iif(Empty(self:nMaxTransid),""," and transid<="+Str(self:nMaxTransId,-1))+iif(Posting," and poststatus>1",""),oConn}
	oStmnt:Execute() 
	if !Empty(oStmnt:Status)
		ErrorBox{self,self:oLan:WGet("could not select transactions")+Space(1)+' ('+oStmnt:Status:description+')'}:Show()
		SQLStatement{"rollback",oConn}:Execute() 
		SQLStatement{"unlock tables",oConn}:Execute()
		SetDecimalSep(Asc('.'))
		return
	endif
	nTransLock:=oStmnt:NumSuccessfulRows
	SQLStatement{"commit",oConn}:Execute()	
	SQLStatement{"unlock tables",oConn}:Execute()
	oSel:=SqlSelect{"select transid from transaction where lock_id='"+MYEMPID+"' and  bfm='' and dat<='"+SQLdate(self:closingDate)+"' and gc>''"+;
		+iif(Empty(self:nMaxTransid),""," and transid<="+Str(self:nMaxTransid,-1))+" limit 1",oConn} 
	nTransSample:=ConI(oSel:transid)  // save sample transid for checking purposes later


	cStmsg:=self:oLan:WGet("Collecting data for the sending, please wait")+"..."
	self:STATUSMESSAGE(cStmsg)
	oMBal:=Balances{}
	separatorline:= '--------------------|-----------|'+Replicate('-',126)+'|'
	nRow:=0
	nPage:=0
	store 0 to a_tel
	nRowCnt :=0 
	time0:=time1 
	// determine if previous year is closed for balances:
	aYearStartEnd := GetBalYear(Year(self:closingDate),Month(self:closingDate))   // determine start of fiscal year                           
	PrvYearNotClosed:=((aYearStartEnd[1]*12+aYearStartEnd[2])>(Year(LstYearClosed)*12+Month(LstYearClosed)))
	aYearStartEnd:=null_array
	// read balance of all members:
	oMBal:cAccSelection:="a.accid in ("+Implode(aAccidMbr,',',,,1)+")"	
	oMBal:cTransSelection:="t.accid in ("+Implode(aAccidMbr,',',,,1)+")"	
	oAccBal:=SqlSelect{oMBal:SQLGetBalanceDate(self:closingDate),oConn}      // maximum balance is balance at closing date
	oAccBal:Execute()
	if	oAccBal:Reccount>0 
		aDBBalValue:=AEvalA(Split(oAccBal:Balances,'#'),{|x|x:=Split(x,',') })
		for i:=1 to Len(aDBBalValue)
			
			if	(k:=AScan(aAccidMbr,{|x|x[1]==aDBBalValue[i,1]}))>0
				me_balance:=	Round(Val(aDBBalValue[i,3])- Val(aDBBalValue[i,2]),2) 
				if PrvYearNotClosed .and. (aAccidMbr[k,3]==INCOME .or.aAccidMbr[k,3]==expense)
					me_balance:=Round(me_balance+Val(aDBBalValue[i,7])-Val(aDBBalValue[i,6]),2)   // add balance previous year because not in this account
				endif
				if (j:=AScan(aBalMbr,{|x|x[1]==aAccidMbr[k,2]}))>0     // balance found for this member?
					aBalMbr[j,2]:=Round(aBalMbr[j,2]+me_balance,2)
				else
					AAdd(aBalMbr,{aAccidMbr[k,2],me_balance})   // otherwise add new balance
				endif
			endif
		next
		ASort(aBalMbr,,,{|x,y|x[1]<=y[1]})
	endif
	//
	//	For all members non-staff: sum of all assessable transactions not yet sent to PMC:
	// 
	//	Sum off all assessable transactions with Empty BFM up till closing date:
	if Len(aAccidMbr)>0
		oSel:=SqlSelect{'select group_concat(cast(y.accid as char),",",cast(y.asstot as char) order by y.accid separator "#") as grasssum from (select t.accid,sum(t.cre-t.deb) as asstot from transaction t where t.fromrpp=0 and t.bfm="" and t.gc="AG" and t.dat <="'+SQLdate(closingDate)+'" '+; 
		+iif(Empty(self:nMaxTransid),""," and t.transid<="+Str(self:nMaxTransid,-1)) +;
			" and "+oMBal:cTransSelection+" and t.lock_id="+MYEMPID+" and t.lock_time > subdate(now(),interval 10 minute) group by t.accid) as y group by 1=1",oConn} 
		if oSel:Reccount>0
			aAssTot:=AEvalA(Split(oSel:grasssum,'#'),{|x|x:=Split(x,',') })  // make array of sums of assessable amounts per account
			// add to total assessable amount per member:
			// aAssmbr: {{mbrid,calcdate,periodbegin,periodend,amountassessed,amountofficeassmnt,amountintassmnt,percofficeassmnt,percintassmnt},...  
			//              1      2         3             4           5             6              7                  8               9 
			cToday:=SQLdate(Today()) 
			cPeriodBegin:=SQLdate(self:oSys:pmislstsnd)
			cPeriodEnd:=SQLdate(self:closingDate)
			for i:=1 to Len(aAssTot)
				if (j:=AScan(aAccidMbr,{|x|x[1]==aAssTot[i,1]}))>0
					if (k:=AScan(aAssMbr,{|x|x[1]==aAccidMbr[j,2]}))>0
						aAssMbr[k,2]:=Round(aAssMbr[k,5]+Val(aAssTot[i,2]),2)
					else
						AAdd(aAssMbr,{aAccidMbr[j,2],cToday,cPeriodBegin,cPeriodEnd,Val(aAssTot[i,2]),0.00,0.00,0.0,0.0})
					endif
				endif
			next
			ASort(aAssMbr,,,{|x,y|x[1]<=y[1]})
		endif
		if Len(aAccidMbrF)>0
			// For foreign members: all transactions not yet sent to PMC with assmntcode <> ‘’
			oSel:=SqlSelect{"select group_concat(cast(accid as char),'&&',cast(transid as char),'&&',cast(seqnr as char),'&&',coalesce(cast(t.persid as char),''),'&&',description,'&&',cast(deb as char),'&&',cast(cre as char),'&&',gc,'&&',"+;
				"reference,'&&',cast(dat as char),'&&',ifnull("+SQLFullNAC(0,sLand,'p')+",''),'&&',cast(fromrpp as char) order by accid,transid,seqnr separator '##') as grtrans from transaction t left join person p on (p.persid=t.persid) "+;
				"where t.accid in ("+Implode(aAccidMbrF,',',,,1)+') and bfm="" and dat<="'+SQLdate(closingDate)+'" and gc>""'+;
				iif(Empty(self:nMaxTransid),""," and t.transid<="+Str(self:nMaxTransid,-1))+;
				" and t.lock_id="+MYEMPID+" and t.lock_time > subdate(now(),interval 10 minute) group by 1=1",oConn}  
			if oSel:Reccount>0
				aTransF:=AEvalA(Split(oSel:grtrans,'##'),{|x|x:=Split(x,'&&')})
			endif 
		endif
		
		if Len(aAccidRPP)>0
			//	For all own members with remaining RPP distribution instruction: sum of all transactions fromRPP not yet sent to PMC
			oSel:=SqlSelect{'select group_concat(cast(y.accid as char),",",cast(y.rpptot as char) order by y.accid separator "#") as grrppsum from (select t.accid,sum(t.cre-t.deb) as rpptot from transaction t where t.fromrpp=1 and t.bfm="" and t.gc>"" and t.dat <="'+SQLdate(closingDate)+'" '+; 
			+iif(Empty(self:nMaxTransid),""," and t.transid<="+Str(self:nMaxTransId,-1))+;
				" and t.accid in ("+Implode(aAccidRPP,',',,,1)+") and t.lock_id="+MYEMPID+" and t.lock_time > subdate(now(),interval 10 minute) group by t.accid) as y group by 1=1",oConn}
			if oSel:Reccount>0
				aAccRPP:=AEvalA(Split(oSel:grrppsum,'#'),{|x|x:=Split(x,',') })  // make array of sums of rpp amounts per account  
				// add to RPP total per member:
				for i:=1	to	Len(aAccRPP)
					if	(j:=AScan(aAccidMbr,{|x|x[1]==aAccRPP[i,1]}))>0
						if	(k:=AScan(aRPPMbr,{|x|x[1]==aAccidMbr[j,2]}))>0
							aRPPMbr[k,2]:=Round(aRPPMbr[k,2]+Val(aAccRPP[i,2]),2)
						else
							AAdd(aRPPMbr,{aAccidMbr[j,2],Val(aAccRPP[i,2])})
						endif
					endif
				next
				ASort(aRPPMbr,,,{|x,y|x[1]<=y[1]})
			endif
		endif
	endif
	// reset arrays:
	aAccidRPP:=null_array
	aDBBalValue:=null_array
	aAssTot:=null_array 
	aAccRPP:=null_array
	
	// collect distribution instructions:	
	nMbrAss:=1
	nMbrRPP:=1
	nMbrBal:=1
	// Process members:
	for nMbr:=1 to Len(aMbr)
		// aMbr:
	// {{mbrid,description,homepp,homeacc,housholdid,co,has,grade,offcrate,accid,accnumber,currency,type,accidinc,accnumberinc,descriptioninc,currencyinc,accidexp,accnumberexp,descriptionexp,currencyexp,accidnet,accnumbernet,descriptionnet,currencynet,homeppname,distr,depid},...}
	//     1       2         3       4        5       6  7     8      9      10       11     12     13       14          15        16             17           18         19         20            21           22        23          24           25          26        27    28
		me_mbrid:=aMbr[nMbr,1]
		me_co:=aMbr[nMbr,6]   // co
		me_rate:=Upper(aMbr[nMbr,9])
		me_accid:= iif(Empty(aMbr[nMbr,10]),aMbr[nMbr,18],aMbr[nMbr,10])       // accid or accidexp
		if !me_accid>'0'
			me_accid:=oGetDep:GetAccount(aMbr[nMbr,28],expense)
		endif
		me_accnbr:=iif(Empty(aMbr[nMbr,10]),aMbr[nMbr,19],aMbr[nMbr,11])       // accnumberexp or ACCNUMBER
		me_currency:=iif(Empty(aMbr[nMbr,10]),aMbr[nMbr,21],aMbr[nMbr,12])       // currencyexp or currency
		me_type:=iif(Empty(aMbr[nMbr,10]),EXPENSE,aMbr[nMbr,13])    // expense or type  
		me_pers:=StrTran(StrTran(aMbr[nMbr,2],","," "),"-"," ")        // description 
		me_stat:=aMbr[nMbr,8]  // Grade 
		me_has:=iif(ConI(aMbr[nMbr,7])=1,true,false)   // has 
		
		// compile distribution instructions:
		destinstr:={}
		aDistr:={} 
		mHomeAcc:=aMbr[nMbr,4]  //HOMEACC
		if !Empty(aMbr[nMbr,27]) // distribution instructions?
			aDistr:=aMbr[nMbr,27] 
			// check distribution instructions of this member:
			for i:=1 to Len(aDistr)
				// aDistr: {{desttyp,destamt,destpp,destacc,lstdate,seqnbr,descrptn,currency,amntsnd, singleuse,destppname},...
				//              1       2       3      4        5      6      7         8      9         10       11
				cDestPersonId:=""
				IF aDistr[i,3]=="ACH"  //destpp
					cDestAcc:=AllTrim(aDistr[i,4]) 			
					if !Empty(cDestAcc) .and.!(cDestAcc=='1'.or.cDestAcc=='2')
						cError:=self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")
						exit
					endif				
					cDestAcc:=aMbr[nMbr,5]+iif(Empty(cDestAcc),"",+'#'+cDestAcc)  // household code is sufficient from 2011-04-03: householdid+seqnr in destacc
				ELSE
					if !aMbr[nMbr,3]== SEntity .and. (aDistr[i,3] # SEntity .and.aDistr[i,3] # "AAA") .and. me_co == "M"            // HOMEPP <> SEntity ?
						cError:=self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")
						exit
					endif
					cDestAcc:=AllTrim(aDistr[i,4]) 			
					// check legal ppcode: 
					if Empty(aDistr[i,11])
						cError:=self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")
						exit
					endif
					if aDistr[i,3] == "AAA"
						k:=AScan(aPersDest,{|x|x[1]==cDestAcc})
						if k>0
							cDestPersonId:=aPersDest[k,2]
						else
							cError:=self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")+", not found banknbr:"+cDestAcc
							exit					
						endif
						if !sepaenabled .and.CountryCode=="31".and.Len(cDestAcc)>7
							if !IsDutchBanknbr(cDestAcc)
								cError:=self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")+",no dutch banknbr:"+cDestAcc
								exit
							endif
						endif
					endif
				ENDIF
				// destinstr: {destpp,destacc,desttype,destamnt,lstdate,seqnbr,description,currency,amntsend,destperson,singleuse},...
				//               1       2       3        4         5      6       7           8        9        10          11
				AAdd(destinstr,{AllTrim(aDistr[i,3]),cDestAcc,Val(aDistr[i,1]),Val(aDistr[i,2]),SQLDate2Date(aDistr[i,5]),aDistr[i,6],aDistr[i,7],iif(aDistr[i,8]='1',true,false),Val(aDistr[i,9]),cDestPersonId, iif(aDistr[i,10]='1',true,false)})
			Next
			ASort(destinstr,,,{|x,y| x[3]<=y[3].or.y[3]>0.and.x[3]=3})   // sort in processing priority  (remaining RPP immeditialy after fixed
		endif
		if !Empty(cError)
			exit
		endif
		DO CASE
		CASE Empty(me_rate)
			OfficeRate:=self:sAssmntOffc
		CASE me_rate="L"
			OfficeRate:=self:sWithldOffl
		CASE me_rate="H"
			OfficeRate:=self:sWithldOffH
		CASE me_rate="M"
			OfficeRate:=self:sWithldOffM
		OTHERWISE
			OfficeRate:=self:sAssmntOffc
		ENDCASE		
		IF me_co="M"
			me_householdid:=aMbr[nMbr,5] 
		ELSE
			me_householdid:=""
		ENDIF
		// aMbr:
		// {{mbrid,description,homepp,homeacc,housholdid,co,has,grade,offcrate,accid,accnumber,currency,type,accidinc,accnumberinc,descriptioninc,currencyinc,accidexp,accnumberexp,descriptionexp,currencyexp,accidnet,accnumbernet,descriptionnet,currencynet,homeppname,distr},...}
		//     1       2         3       4        5       6  7     8      9      10       11     12     13       14          15        16             17           18         19         20            21           22        23          24           25          26        27
		me_homePP:=aMbr[nMbr,3]   // homepp
		store 0 to AmntTrans
		mbrfield:= 0
		mbrint:= 0
		mbroffice:= 0
		mbrofficeProj:=0.00
		mbrofficeOFR:=0.00 		 
		AmntFromRPP:=0.00
		me_asshome:=0.00 
		me_assblAmount:=0.00
		// find assessable amount of this member:
		do while nMbrAss<Len(aAssMbr) .and.aAssMbr[nMbrAss,1]<me_mbrid  
			nMbrAss++
		enddo
		// calculate assessments:
		// aAssmbr: {{mbrid,calcdate,periodbegin,periodend,amountassessed,amountofficeassmnt,amountintassmnt,percofficeassmnt,percintassmnt},...  
		//              1      2         3             4           5             6              7                  8                9

// 		IF nMbrAss<=Len(aAssMbr) .and. aAssMbr[nMbrAss,1]==me_mbrid .and.me_stat!="Staf" 
		IF nMbrAss<=Len(aAssMbr) .and. aAssMbr[nMbrAss,1]==me_mbrid 
			me_assblAmount:=aAssMbr[nMbrAss,5]
			me_asshome:=Round((me_assblAmount*OfficeRate)/100,DecAantal)
			mbrint:=Round((me_assblAmount*(self:sPercAssInt+self:sAssmntField))/100,DecAantal) 
			aAssMbr[nMbrAss,6]:= me_asshome
			aAssMbr[nMbrAss,7]:= mbrint
			aAssMbr[nMbrAss,8]:= OfficeRate
			aAssMbr[nMbrAss,9]:= self:sPercAssInt+self:sAssmntField
		ENDIF
		
		// find RPP amount of this member:
		do while nMbrRPP<Len(aRPPMbr) .and. aRPPMbr[nMbrRPP,1]<me_mbrid 
			nMbrRPP++
		enddo
		// calculate RPP amount:
		IF nMbrRPP<=Len(aRPPMbr) .and. aRPPMbr[nMbrRPP,1]==me_mbrid 
			AmntFromRPP:=aRPPMbr[nMbrRPP,2]
		ENDIF

		IF me_homePP!=SEntity
			// process transaction to be sent to PMC
			// aTransF:  accid,transid,seqnr,persid,description,deb,cre,gc,reference,dat,givernac,fromRPP
			//              1     2      3      4       5         6  7   8     9     10    11        12
			TotAssrate:=Round(100.00 - Round(OfficeRate+self:sPercAssInt+self:sAssmntField,DecAantal),DecAantal)
			me_amounttot:=round(me_asshome+mbrint,decaantal)
			nAccmbr:=1 
			do while nAccmbr>0 .and. nAccmbr<=Len(aAccidMbrF)
				nAccmbr:=AScan(aAccidMbrF,{|x|x[2]==me_mbrid},nAccmbr)
				if nAccmbr=0
					exit
				endif
				currentaccid:= aAccidMbrF[nAccmbr,1]
				if (nTrans:=AScan(aTransF,{|x|x[1]==currentaccid}))>0
					// process transactions:
					do while nTrans<=Len(aTransF) .and. aTransF[nTrans,1]==currentaccid 
						if Len(aTransF[nTrans])>10
							me_amount:=Round(Val(aTransF[nTrans,7])-Val(aTransF[nTrans,6]),DecAantal)
							me_desc:=sCurrName+iif(Len(sCURRNAME)>1," ","")+Str(me_amount,-1) +"("+aTransF[nTrans,10]+")" 
							me_gc:=aTransF[nTrans,8]
							PMCco:=iif(me_gc=='AG','CN',iif(me_gc=='MG','MM','PC')) 
							if !Empty(aTransF[nTrans,4]) .and.(me_gc=='AG'.or. me_gc=='MG')  // gift?
								me_desc:=iif(Empty(me_desc),"",me_desc+" ")+"from "+aTransF[nTrans,4]+Space(1)+aTransF[nTrans,11]
							endif
// 							if me_gc=='AG' .and.aTransF[nTrans,12]=='0' .and. me_stat!="Staf" 
							if me_gc=='AG' .and.aTransF[nTrans,12]=='0'  
								me_amount:=Round((me_amount*TotAssrate)/100,DecAantal) // subtract assessment 
								me_amounttot:=Round(me_amounttot+me_amount,DecAantal)
							endif
							me_desc+=iif(Empty(me_desc),"","; ")+aTransF[nTrans,5]
							AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,me_amount,PMCco,{iif(Empty(aTransF[nTrans,9]).and.me_co="S",mHomeAcc,aTransF[nTrans,9]),me_homePP,me_householdid,,,me_co},,me_desc,,me_currency,Val(aTransF[nTrans,2]),me_mbrid})				
							AmntTrans:=Round(me_amount+AmntTrans,DecAantal)
						endif
						nTrans++
					enddo
				endif
				nAccmbr++
			ENDDO
			// correct assessment for rounding differences: 
			fDiff:=Round(me_assblAmount-me_amounttot,DecAantal)
			if fDiff<>0.00
				me_asshome:=Round(me_asshome+fDiff,DecAantal)
				aAssMbr[nMbrAss,6]:= me_asshome  
			endif	
		endif			

		AssInt:=Round(AssInt+mbrint,DecAantal)
		IF me_co="S"
			if me_stat='OFR'
				mbrofficeOFR:=me_asshome
				AssOfficeOFR:= Round(AssOfficeOFR+me_asshome,DecAantal)
			else 
				mbrofficeProj:=me_asshome
				AssOfficeProj:=Round(AssOfficeProj+me_asshome,DecAantal)
			endif 
		ELSE 
			mbroffice:=me_asshome
			AssOffice:=Round(AssOffice+me_asshome,DecAantal)
		endif
		// 		AssOffice:=Round(AssOffice+mbroffice,DecAantal)
		// 		AssOfficeProj:=Round(AssOfficeProj+mbrofficeProj,DecAantal) 
		// calculate reversal for ministry income: 
		if !Empty(SINC).and. me_type==LIABILITY 
			if !me_has
				AssInc:=Round(AssInc+mbroffice+mbrofficeProj+mbrofficeOFR,DecAantal)
				if !Empty(samFld)
					AssFldInt:=Round(AssFldInt+mbrfield+mbrint,DecAantal)
				endif
			else
				AssIncHome:=Round(AssIncHome+mbroffice+mbrofficeProj+mbrofficeOFR,DecAantal)
				if !Empty(samFld)
					AssFldIntHome:=Round(AssFldIntHome+mbrfield+mbrint,DecAantal)
				endif
			endif
		endif
		
		* Save: accid,accnbr,mbrname, type transactie, amount, PMCcode, destination{destacc,destPP,household code,destnbr,destaccID,assmcode},homeassamnt, description,cDestPersonId,currency, transid,mbrid 
		//        1       2      3          4            5        6         7          7,1    7,2      7,3         7,4      7,5         7,6      8            9              10        11        12      13
		// 1: assessment int+field:
		IF mbrint # 0
			AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, AG,mbrint,"",{me_accnbr,if(me_co="M","",me_homePP),if(me_co="M",me_householdid,""),,,iif(me_stat='OFR',me_stat,me_co)},iif(me_co="M",mbroffice,iif(me_stat='OFR',mbrofficeOFR,mbrofficeProj)),,,me_currency,0,me_mbrid})  
			//                      1      2        3      4    5     6      7,1          7,2                          7,3                                     7,6                       8                                                              9 10    11     12
		ENDIF

		// Transfer balance conform distribution instructions:
		if me_homePP!=SEntity  .or. (me_homePP==SEntity .or. me_co="M").and.Len(destinstr)>0
			// determine limit for sending money:
			// find balance amount of this member: 
			BalanceSend:=0.00
			do while nMbrBal<Len(aBalMbr) .and. aBalMbr[nMbrBal,1]<me_mbrid
				nMbrBal++
			enddo
			// calculate remaining amount: 
			
			IF nMbrBal<=Len(aBalMbr) .and. aBalMbr[nMbrBal,1]==me_mbrid 
				BalanceSend:=aBalMbr[nMbrBal,2]
			ENDIF
			
			remainingAmnt:=Round(BalanceSend-mbroffice-mbrofficeProj-mbrofficeOFR-mbrint,DecAantal)
			IF me_homePP!=SEntity .and.self:closingDate= Today() 
				// for transactions to be send to homepp:
				AmntCorrection:=Round(remainingAmnt-AmntTrans,DecAantal)
			endif
			availableAmnt:=remainingAmnt
			// 2: In case of member from own homePP or non-entity send distribution instructions:
			IF me_homePP==SEntity .or. me_co="M"
				// 3: according to distribution instructions:
				// destinstr: {destpp,destacc,desttype,destamnt,lstdate,seqnbr,description,currency,amntsend,destperson,singleuse},...
				//               1       2       3        4         5      6       7           8        9        10          11
				FOR iDest:=1 to Len(destinstr)
					destAcc:=""
					iType:=GT
					cDestPersonId:=""
					IF destinstr[iDest,1]==SEntity .and. !Empty(destinstr[iDest,2])
						// transaction own account: 
						if (k:=AScan(aAccDestOwn,{|x|x[2]==destinstr[iDest,2]}))>0
							// 						oAccD:=SqlSelect{"select accid from account where accnumber='"+destinstr[iDest,2]+"'",oConn}
							// 						if oAccD:Reccount>0
							iType:=DT
							// 							destAcc:=Str(oAccD:accid,-1)
							destAcc:=aAccDestOwn[k,1]
						ENDIF
					elseIF AllTrim(destinstr[iDest,1])=="AAA" .and. !Empty(AllTrim(destinstr[iDest,2]))
						// transaction to local bank:
						if Empty(sCRE)
							self:ResetLocks()
							(ErrorBox{self,self:oLan:WGet("Account payable not defined in System Parameters")+"!"}):Show()
							SetDecimalSep(Asc('.'))
							return false
						endif
						iType:=DT
						destAcc:=sCRE
						cDestPersonId:=destinstr[iDest,10]
					endif
					IF destinstr[iDest,3]=0 // fixed amount
						// enough balance and not yet sent within this month?:
						IF Year(destinstr[iDest,5])*100+Month(destinstr[iDest,5])<CurMonth
							//  enough balance ?
							DestAmnt:=destinstr[iDest,4]
							IF destinstr[iDest,8]
								// convert from UD dollar:
								DestAmnt:=Round(destinstr[iDest,4]*fExChRate,DecAantal)
							ENDIF
							IF remainingAmnt>=DestAmnt
								AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, iType,DestAmnt,"",{destinstr[iDest,2],destinstr[iDest,1],me_householdid,destinstr[iDest,6],destAcc,iif(me_stat='OFR',me_stat,me_co)},,destinstr[iDest,7],cDestPersonId,me_currency,0,me_mbrid})  
								// aDisLock: {{mbrid,seqnr,amountsent,singleuse,lastdate},...}
								AAdd(aDisLock,{me_mbrid,destinstr[iDest,6],DestAmnt,iif(destinstr[iDest,11],'1','0'),cClosingdate})
								IF me_homePP!=SEntity
									AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-DestAmnt,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,iif(me_stat='OFR',me_stat,me_co)},,destinstr[iDest,7],cDestPersonId,me_currency,0,me_mbrid})				
								endif
								remainingAmnt:=Round(remainingAmnt-DestAmnt,DecAantal)
							ELSE
								// wait untill enough balance
								exit
							ENDIF
						ENDIF
					ELSEIF destinstr[iDest,3]=1 // proportional amount
						me_amount:=Min(Round((destinstr[iDest,4]*availableAmnt)/100,DecAantal),remainingAmnt)
						IF me_amount>0
							AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, iType,me_amount,"",{destinstr[iDest,2],destinstr[iDest,1],me_householdid,,destAcc,iif(me_stat='OFR',me_stat,me_co)},,destinstr[iDest,7],cDestPersonId,me_currency,0,me_mbrid})
							remainingAmnt:=Round(remainingAmnt-me_amount,DecAantal)
							IF me_homePP!=SEntity
								AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-me_amount,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,iif(me_stat='OFR',me_stat,me_co)},,destinstr[iDest,7],cDestPersonId,me_currency,0,me_mbrid})				
							endif
							if destinstr[iDest,11]														//lock distribution record:
								AAdd(aDisLock,{me_mbrid,destinstr[iDest,6],me_amount,iif(destinstr[iDest,11],'1','0'),cClosingdate})
							endif
						ENDIF
					ELSEIF remainingAmnt>0 // remaining amount:
						//============ include check cumulative amount (destinstr[iDest,9]) < limit (destinstr[iDest,4])
						IF destinstr[iDest,4] > 0
							// limit case:
							IF Year(destinstr[iDest,5])*100+Month(destinstr[iDest,5])<CurMonth
								// first time this month:
								destinstr[iDest,9]:=0
							ENDIF
							DestAmnt:=destinstr[iDest,4]
							IF destinstr[iDest,8]
								// convert from USD dollar:
								DestAmnt:=Round(destinstr[iDest,4]*fExChRate,DecAantal)
							ENDIF

							IF destinstr[iDest,9] < DestAmnt
								if destinstr[iDest,3]=3  // remaining from RPP
									amntlimited:=Min(AmntFromRPP,remainingAmnt)
								else
									amntlimited:=remainingAmnt
								endif
								amntlimited:=Min(amntlimited, Round(DestAmnt-destinstr[iDest,9],DecAantal))
								if amntlimited>0.00  
									AAdd(aDisLock,{me_mbrid,destinstr[iDest,6],Round(destinstr[iDest,9]+amntlimited,DecAantal),iif(destinstr[iDest,11],'1','0'),cClosingdate})
									AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, iType,amntlimited,"",{destinstr[iDest,2],destinstr[iDest,1],me_householdid,,destAcc,iif(me_stat='OFR',me_stat,me_co)},,destinstr[iDest,7],cDestPersonId,me_currency,0,me_mbrid})
									IF me_homePP!=SEntity
										AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-amntlimited,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,iif(me_stat='OFR',me_stat,me_co)},,destinstr[iDest,7],cDestPersonId,me_currency,0,me_mbrid})				
									endif
								endif
							ENDIF
						ELSE  // no limit
							if destinstr[iDest,3]=3  // remaining from RPP
								amntlimited:=Min(AmntFromRPP,remainingAmnt)
							else
								amntlimited:=remainingAmnt
							endif 
							if amntlimited>0.00  
								AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, iType,amntlimited,"",{destinstr[iDest,2],destinstr[iDest,1],me_householdid,,destAcc,iif(me_stat='OFR',me_stat,me_co)},,destinstr[iDest,7],cDestPersonId,me_currency,0,me_mbrid})
								IF me_homePP!=SEntity
									AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-amntlimited,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,iif(me_stat='OFR',me_stat,me_co)},,destinstr[iDest,7],cDestPersonId,me_currency,0,me_mbrid})				
								endif
								AAdd(aDisLock,{me_mbrid,destinstr[iDest,6],amntlimited,iif(destinstr[iDest,11],'1','0'),cClosingdate})
								remainingAmnt:=Round(remainingAmnt-amntlimited,DecAantal)
							endif
						ENDIF
					ENDIF
				NEXT
			ENDIF
			// 2: In case of member from other homePP seperate transactions for CN,MM and PC:
			IF me_homePP!=SEntity .and.self:closingDate=Today()
				IF !AmntCorrection=0.00
					// send if applicable remaining balance to PMC
					AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,AmntCorrection,"PC",{"",me_homePP,me_householdid,,,iif(me_stat='OFR',me_stat,me_co)},,"Transfer of remaining balance to home office",cDestPersonId,me_currency,0,me_mbrid})
				ENDIF
			ENDIF
		endif
	Next 
	// Reset arrays:
	destinstr:=null_array
	aDistr:=null_array 
	aMbr:=null_array
	aBalMbr:=null_array
	aAccidMbrF:=null_array 
	aPersDest:=null_array 
	aRPPMbr:=null_array
	aTransF:=null_array
	aAccDestOwn:=null_array 
	
	if !Empty(cError)
		(ErrorBox{self,cError}):Show()
		self:ResetLocks()
		return
	endif
	// 	if !Empty(cErrMsg)
	// 		WarningBox{,"Send to PMC","The following members have been skipped because of not posted transactions:"+CRLF+cErrMsg}:Show()
	// 	endif
	batchcount:=Len(aMemberTrans)
	directcount:=0
	mo_tot:=0
	mo_direct:=0
	IF batchcount=0
		(InfoBox{self,self:oLan:WGet("Partner Monetary Clearinghouse"),self:oLan:WGet("Nothing needs to be send")+"!"}):Show()
		self:Pointer := Pointer{POINTERARROW}
		self:ResetLocks()
		RETURN
	ENDIF 
	self:STATUSMESSAGE(self:oLan:WGet('Producing report')+'...')
	// aMemberTrans: accid,accnbr,mbrname, type transactie, amount, PMCcode, destination{destacc,destPP,household code,destnbr,destaccID,assmcode},homeassamnt, description,cDestPersonId,currency, transid, mbrid 
	//                1       2      3          4            5        6         7          7,1    7,2      7,3         7,4      7,5         7,6      8            9              10        11        12         13

	ASort(aMemberTrans,,,{|x,y| x[3]<y[3] .or.x[3]==y[3].and.x[12]<=y[12]})  // sort on name member  and transid
	FOR i=1 to batchcount
		IF aMemberTrans[i,4]==DT    // transactions to own PP not send to PMC
			mo_direct:=Round(mo_direct+aMemberTrans[i,5],DecAantal)
			directcount++
		ELSE
			mo_tot:=Round(mo_tot+aMemberTrans[i,5],DecAantal)
		ENDIF
	NEXT
	AmountDue:= mo_tot
	// 	AmountDueTxt:='Amount due to '+AllTrim(if(AmountDue>0,'SIL',sland))+' '+;
	// 		IF(AmountDue#0,AllTrim(Getal_inv(AmountDue,11))+' (Local currency: '+sCurr+')',;
	// 			'***NIHIL***' )

	heading:={;
		'                            Partner Monetary Clearinghouse',;
		'                                    Transactions to be send',' ',;
		'ORGANIZATION:  '+sLand+Space(33)+'EXCHANGE RATE U.S. $1 = '+Str(fExChRate,-1,8),;
		'PARTNERCODE :  '+SEntity,;
		'currency    :  '+sCurr+'  '+Pad(sCurrName,27)+Space(81)+'PERIOD ' +iif(!Empty(self:oSys:pmislstsnd).and. self:closingDate>self:oSys:pmislstsnd,DToC(self:oSys:pmislstsnd),"")+ ' TO ' + DToC(self:closingDate),;
		' ',;
		Pad('MEMBER',20,' ')+PadL('AMOUNT',12,' ')+' DESCRIPTION',separatorline}
	FOR a_tel=1 to batchcount
		* Print member data:
		* aMemberTrans[reknr,accnbr, accname, type transaction, transaction amount,assmntcode, destination{destacc,destPP,housecode,destnbr,destaccID,mbrtype},homeassamnt,tr.description,Dest.Persid,membercurrency,transid.mbrid]:
		*                1      2        3           4                 5                  6           7         ,1    ,2      ,3        ,4       ,5       ,6        8           9            10             11          12     13
		me_accid:=aMemberTrans[a_tel,1]
		me_balance:=aMemberTrans[a_tel,5]
		* Omschrijving:
		me_desc:=""
		IF !Empty(aMemberTrans[a_tel,9])
			me_desc:=aMemberTrans[a_tel,9]
		ENDIF
		IF aMemberTrans[a_tel,4]=AG
			me_desc:="Assessment Int+Field of gifts from "+Country+' '+self:AssPeriod
		ELSE
			IF aMemberTrans[a_tel,4]=MT
				me_desc:=if(Empty(me_desc),"",me_desc+"; ")+"Transfer OF "+AllTrim(aMemberTrans[a_tel,6])+" TO home:"+aMemberTrans[a_tel,7][2]+iif(Empty(aMemberTrans[a_tel,7][1]),"",", "+aMemberTrans[a_tel,7][1] )
			ELSE
				me_desc:=if(Empty(me_desc),"",me_desc+"; ")+"Transfer TO:"+AllTrim(aMemberTrans[a_tel,7][2])+", "+aMemberTrans[a_tel,7][1]
			ENDIF
		ENDIF
		oReport:PrintLine(@nRow,@nPage,;
			Pad(aMemberTrans[a_tel,3],20)+Str(me_balance,12,2)+' '+Pad(me_desc,127),heading,3-nRowCnt)
		IF Len(heading)>6  && kop aanpassen voor nPage >=2
			FOR i=1 to 4
				ADel(heading,3)
			NEXT
			ASize(heading,3)
		ENDIF
	NEXT
	oReport:PrintLine(@nRow,@nPage,Replicate('-',80),heading,3)
	oReport:PrintLine(@nRow,@nPage,;
		Pad('Subtotal:',20)+" "+Str(mo_tot+mo_direct,11,2)+"  ("+AllTrim(Str(batchcount,-1,0))+" "+oLan:RGet("lines")+")",heading,3-nRowCnt)
	oReport:PrintLine(@nRow,@nPage,Replicate('-',80),heading,4)
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad('Total Assessment intern.+field',40)+Str(AssInt+AssField,11,2),null_array,0)
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad('Total Assessment WO standard',40)+Str(AssOffice,11,2),null_array,0)
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad('Total Assessment WO Projects',40)+Str(AssOfficeProj,11,2),null_array,0)
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad('Total Assessment WO Funds Raising',40)+Str(AssOfficeOFR,11,2),null_array,0)
	oReport:PrintLine(@nRow,@nPage,Replicate('-',80),heading,4)
	IF mo_direct#0
		oReport:PrintLine(@nRow,@nPage,Space(10)+Pad('Amount to be recorded direct to '+SEntity,40)+Str(mo_direct,11,2)+"  ("+AllTrim(Str(directcount,-1,0))+" "+oLan:RGet("lines")+")",heading,0)
	ENDIF
	oReport:PrintLine(@nRow,@nPage,Space(10)+Pad('Amount to be send to PMC (US DOLLARS) $',40)+Str(mo_tot/fExChRate,11,2),heading)
	oReport:PrintLine(@nRow,@nPage,Replicate('-',80),heading,4)
	self:Pointer := Pointer{POINTERARROW}
	uRet:=nil
	uRet:=oReport:prstart(false)

	oReport:prstop()
	oWindow:Pointer := Pointer{POINTERARROW}
	time0:=time1

	*After printing request confirmation for continuing: 
	lStop:=true
	cFilename := curPath + "\"+AllTrim(SEntity)+Str(Year(self:closingDate),4,0)+StrZero(Month(self:closingDate),2)+StrZero(Day(self:closingDate),2)+Str(Round(Seconds(),0),-1)+'PMC.XML'
	if PMCUpload
		if TextBox{self,self:oLan:WGet("Sending to PMC"),self:oLan:WGet("Is printing of PMC transactions OK")+CRLF+;
				self:oLan:WGet("and can their file")+Space(1)+cFilename+CRLF+self:oLan:WGet("be uploaded to Insite")+"?",;
				BOXICONQUESTIONMARK + BUTTONYESNO}:Show()==BOXREPLYYES
			lStop:=false 
		endif
	else
		oAsk:=AskSend{self}
		oAsk:Show() 
		if oAsk:Result==1
			lStop:=false
		endif
	endif 
	if !lStop .and. !self:RefreshLocks(nTransSample,nTransLock)
		TextBox{self,self:oLan:WGet("Sending to PMC"),self:oLan:WGet("someone else has manipulated transactions to be sent to PMC"),BOXICONEXCLAMATION}:Show()
		lStop:=true
	endif

	DecSep:=SetDecimalSep(Asc("."))
	if !lStop 
		// refresh locks
		* Produce first Datafile: 
		self:STATUSMESSAGE(self:oLan:WGet('Producing PMC file')+'...')
		ptrHandle := MakeFile(cFilename,self:oLan:WGet("Creating PMC-file"))
		IF !ptrHandle = F_ERROR .and. !ptrHandle==nil
			* header record:
			//		FWriteLineUni(ptrHandle,'<?xml version="1.0" encoding="ISO-8859-1" ?>')
			//		FWriteLineUni(ptrHandle,'<?xml version="1.0" encoding="UNICODE" ?>')
			FWriteLineUni(ptrHandle,'<?xml version="1.0" encoding="UTF-8" ?>')
			FWriteLineUni(ptrHandle,"<PMISBatch>")
			FWriteLineUni(ptrHandle,"<Header>")
			FWriteLineUni(ptrHandle,"<BatchCount>"+AllTrim(Str(batchcount-directcount))+"</BatchCount>")
			FWriteLineUni(ptrHandle,"<BatchTotal>"+Str(-AmountDue,-1,DecAantal)+"</BatchTotal>")
			FWriteLineUni(ptrHandle,"<Originating_PP>"+SEntity+"</Originating_PP>")
			FWriteLineUni(ptrHandle,"<Exchange_Rate>"+AllTrim(Str(fExChRate,,8))+"</Exchange_Rate>")
			FWriteLineUni(ptrHandle,"</Header>")
			
			* detail records:
		* aMemberTrans[reknr,accnbr, accname, type transaction, transaction amount,assmntcode, destination{destacc,destPP,housecode,destnbr,destaccID,mbrtype},homeassamnt,tr.description,Dest.Persid,membercurrency]:
		*                1      2        3           4                 5                  6           7         ,1    ,2      ,3        ,4       ,5       ,6        8           9            10             11
			datestr:=Str(Year(self:closingDate),4)+"-"+StrZero(Month(self:closingDate),2)+"-"+StrZero(Day(self:closingDate),2)
			FOR a_tel=1 to batchcount
				* Write member data:
				* reknr,accnbr, accname, type transactie, bedrag,assmntcode, destination{destacc,destPP,housecode,distrseqnbr,destAcc,CO},homeassamnt,description:"
				IF !aMemberTrans[a_tel,4]==DT
					me_accnbr:=aMemberTrans[a_tel,2]
					me_balance:=aMemberTrans[a_tel,5]
					me_householdid:=AllTrim(aMemberTrans[a_tel,7][3])
					IF !Empty(aMemberTrans[a_tel,9])
						me_pers:=aMemberTrans[a_tel,9]
						IF !Empty(aMemberTrans[a_tel,3])
							me_pers+=" ("+AllTrim(aMemberTrans[a_tel,3])+")"
						ENDIF
					ELSE
						me_pers:=AllTrim(aMemberTrans[a_tel,3])
					ENDIF
					me_destAcc:=aMemberTrans[a_tel,7][1]
					me_destPP:=aMemberTrans[a_tel,7][2]
					self:WritePMCTrans(ptrHandle,aMemberTrans[a_tel,4],me_accnbr,me_balance,me_pers,me_householdid,datestr,aMemberTrans[a_tel,6],me_destAcc,me_destPP)
				ENDIF
			NEXT
			FWriteLineUni(ptrHandle,"</PMISBatch>")
			* closing record:
			FClose(ptrHandle)
			if PMCUpload
				lStop:=true
				FileStart(WorkDir()+"InsitePMCUpload.html",self)
				if TextBox{,self:oLan:WGet("Sending to PMC"),self:oLan:WGet("Has file with transactions successfully been uploaded without errors into Insite")+'?'+;
						CRLF+self:oLan:WGet("This is irrevocable",,'@!')+'!',BUTTONYESNO+BOXICONQUESTIONMARK}:Show()==BOXREPLYYES
					// 				oAskUp:=AskUpld{self,,,cFilename}
					// 				oAskUp:Show() 
					// 				if oAskUp:Result==1
					if !self:RefreshLocks(nTransSample,nTransLock)
						TextBox{self,self:oLan:WGet("Sending to PMC"),self:oLan:WGet("someone else has manipulated transactions to be sent to PMC"),BOXICONEXCLAMATION}:Show()
					else
						lStop:=false
					endif
				endif
				if lStop
					// remove datafile:
					if !FileSpec{cFilename}:DELETE()
						FErase(cFilename)
					endif
					TextBox{self,self:oLan:WGet("Sending to PMC"),self:oLan:WGet("Nothing recorded as sent to PMC")+CRLF+CRLF+self:oLan:WGet("Remove from Insite file") +;
						': '+SEntity+'_'+FileSpec{cFilename}:Filename+'.xml',BOXICONHAND}:Show()
				endif
			endif
		endif
	endif
	if lStop 
		self:ResetLocks()
		return
	else
		IF Empty(self:oSys:PMISLSTSND) .or.self:oSys:PMISLSTSND<Today()-400
			// still IES:
			IF (TextBox{oWindow,self:oLan:WGet("Partner Monetary Clearinghouse"),;
					self:oLan:WGet('Did you really get confirmation from Dallas that your WO is PMC enabled')+'?',BOXICONQUESTIONMARK + BUTTONYESNO}):Show() = BOXREPLYNO
				self:ResetLocks()
				RETURN
			ENDIF
		ENDIF 
		
		if !maildirect		
			oMapi := MAPISession{}
		endif
		self:Pointer := Pointer{POINTERHOURGLASS}
		cStmsg:=self:oLan:WGet("Recording transactions, please wait")+"..." 
		self:STATUSMESSAGE(cStmsg)  
		// determine mbalance accounts to be locked for update 
		cAccs:=sam+','+shb
		if !Empty(samProj)
			cAccs+=','+samProj
		endif
		if !Empty(SINCHOME)
			cAccs+=','+SINCHOME+","+SEXPHOME
		endif
		if !Empty(SINC)
			cAccs+=','+SINC+","+SEXP
		endif
		if !Empty(samFld)
			cAccs+=','+samFld
		endif
		for a_tel:=1 to batchcount
			if !cCurAcc==aMemberTrans[a_tel,1]
				cCurAcc:=aMemberTrans[a_tel,1]
				cAccs+=','+cCurAcc
			endif 
			IF aMemberTrans[a_tel,4]==DT
				if At(','+aMemberTrans[a_tel,7][5]+',',cAccs)=0
					cAccs+=","+aMemberTrans[a_tel,7][5]
				endif
			endif
		next
		// check transactions are still locked:

		// Prepare transactions:
		nSeqnr:=0
		nSeqnrDT:=0
		//aTransM/DT: accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
		//             1    2     3      4      5      6            7      8   9  10    11        12    13     14     15  
		FOR a_tel = 1 to batchcount
			* aMemberTrans[reknr,accnbr, accname, type transaction, transaction amount,assmntcode, destination{destacc,destPP,housecode,destnbr,destaccID,mbrtype},homeassamnt,tr.description,Dest.Persid,membercurrency,transid,mbrid]:
			*               1      2        3           4                 5                  6           7         ,1    ,2      ,3        ,4       ,5       ,6        8           9            10             11          12      13
			me_accid:=aMemberTrans[a_tel,1]
			me_balance:=aMemberTrans[a_tel,5]
			me_pers:=aMemberTrans[a_tel,3]
			me_co:=aMemberTrans[a_tel,7][6] 
			nMbrAss:=0
			nMbr:=0
			me_mbrid:=''
			* Record transactions for decreasing balance of member:
			// aAssmbr: {{mbrid,calcdate,periodbegin,periodend,amountassessed,amountofficeassmnt,amountintassmnt,percofficeassmnt,percintassmnt},...  
			//              1      2         3             4           5             6              7                  8                9
			IF aMemberTrans[a_tel,4]=AG
// 				nMbr:=AScan(aAccidMbr,{|x|x[1]==me_accid})
// 				if nMbr>0
// 					me_mbrid:=aAccidMbr[nMbr,2] 
				me_mbrid:=aMemberTrans[a_tel,13]
				nMbrAss:=AScan(aAssMbr,{|x|x[1]==me_mbrid})
				me_desc:=self:oLan:RGet("Assessment Intern+Field of gifts from")+Space(1)+Country+' '+self:AssPeriod + ' ('+Str(self:sPercAssInt+self:sAssmntField,-1)+'%'+Space(1)+self:oLan:RGet('of total gift amount')+' '+;
					iif(nMbrAss>0,Str(aAssMbr[nMbrAss,5],-1),'0')+iif(me_co='OFR',' '+self:oLan:RGet("for")+' '+me_pers,'')+')'
			ELSE
				me_desc:=aMemberTrans[a_tel,9]
				IF aMemberTrans[a_tel,4]=MT
					me_desc+=iif(Empty(me_desc),"",'; ')+"Transfer of "+AllTrim(aMemberTrans[a_tel,6])+" to home:"+aMemberTrans[a_tel,7][2]
				ELSE
					me_desc+=iif(Empty(me_desc),"",'; ')+"Transfer to:"+AllTrim(aMemberTrans[a_tel,7][2])+", "+aMemberTrans[a_tel,7][1]
				ENDIF 
				if !aMemberTrans[a_tel,4]==DT
					me_desc+=" (Exchange rate US $1="+Str(fExChRate,-1,8)+' '+sCurrName+")" 
				endif
			ENDIF
			me_balanceF:=me_balance
			if !aMemberTrans[a_tel,11]==sCurr
				self:mxrate:=oCurr:GetROE(aMemberTrans[a_tel,11],Today())
				if self:mxrate>0
					me_balanceF:=Round(me_balance/self:mxrate,DecAantal)
				endif 
			endif
			cError:=""
			me_desc:=SubStr(AddSlashes(me_desc),1,511) // limit to fit into description 
			if aMemberTrans[a_tel,4]==DT
				// 					nSeqnrDT++
				// 					cSeqnr:=Str(nSeqnrDT)
				AAdd(aTransDT,{me_accid,Str(me_balance,-1),Str(me_balanceF,-1),'0','0',aMemberTrans[a_tel,11],me_desc,cClosingdate,'H','CH',LOGON_EMP_ID,'2','','PMC',''})
			else
				nSeqnr++
				AAdd(aTransMT,{me_accid,Str(me_balance,-1),Str(me_balanceF,-1),'0','0',aMemberTrans[a_tel,11],me_desc,cClosingdate,'H','CH',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
			endif 
			oMBal:ChgBalance(me_accid, self:closingDate, me_balance,0, me_balanceF,0,aMemberTrans[a_tel,11],2) 
			IF aMemberTrans[a_tel,4]==DT
				if aMemberTrans[a_tel,7][5]==sCRE .and.aMemberTrans[a_tel,7][2]=="AAA" .and.me_balance>0.00 
					// to account payable and local bank: make BankOrder: 
					// accntfrom,amount,description,banknbrcre,datedue,idfrom
					AAdd(aBankOrder,{sCRE,Str(me_balance,-1),AddSlashes(iif(Empty(aMemberTrans[a_tel,9]),me_desc,aMemberTrans[a_tel,9])),AddSlashes(aMemberTrans[a_tel,7][1]),cDueDate,me_accid}) 
				endif
				// 					nSeqnrDT++
				// 					cSeqnr:=Str(nSeqnrDT)
				me_desc:=SubStr(AddSlashes(aMemberTrans[a_tel,9]+iif(Empty(aMemberTrans[a_tel,9]),"",'; ')+oLan:RGet("From")+Space(1)+aMemberTrans[a_tel,3]),1,511)
				// add second line for direct transactions:
				AAdd(aTransDT,{aMemberTrans[a_tel,7][5],'0','0',Str(me_balance,-1),Str(me_balanceF,-1),aMemberTrans[a_tel,11],me_desc,;
					cClosingdate,'H','',LOGON_EMP_ID,'2','','PMC',''})
				oMBal:ChgBalance(aMemberTrans[a_tel,7][5], self:closingDate, 0, me_balance, 0, me_balanceF,'',2) 
			endif
		* aMemberTrans[reknr,accnbr, accname, type transaction, transaction amount,assmntcode, destination{destacc,destPP,housecode,destnbr,destaccID,mbrtype},homeassamnt,tr.description,Dest.Persid,membercurrency]:
		*                1      2        3           4                 5                  6           7         ,1    ,2      ,3        ,4       ,5       ,6        8           9            10             11
			// Also transaction for Office assessment:
			IF aMemberTrans[a_tel,4]=AG .and.aMemberTrans[a_tel,8]#0
				IF aMemberTrans[a_tel,7][6]="M"
					me_desc:=self:oLan:RGet("Assessment office of gifts from")+Space(1)+Country +' '+self:AssPeriod
				elseif aMemberTrans[a_tel,7][6]="OFR" 
					me_desc:=self:oLan:RGet("Assessment office own funds raising of gifts from")+Space(1)+Country+' '+self:AssPeriod
				ELSE
					me_desc:=self:oLan:RGet("Assessment office projects of gifts from")+Space(1)+Country+' '+self:AssPeriod
				ENDIF
				if !Empty(nMbrAss)
					// aAssmbr: {{mbrid,calcdate,periodbegin,periodend,amountassessed,amountofficeassmnt,amountintassmnt,percofficeassmnt,percintassmnt},...  
					//              1      2         3             4           5             6              7                  8                9
					me_desc+= ' ('+iif(nMbrAss>0,Str(aAssMbr[nMbrAss,8],-1),'0')+'%'+Space(1)+self:oLan:RGet('of total gift amount')+' '+iif(nMbrAss>0,Str(aAssMbr[nMbrAss,5],-1),'0')+')'
				ENDIF
				nSeqnr++
				// 					cSeqnr:=Str(nSeqnr)
				me_balance:=aMemberTrans[a_tel,8]
				me_balanceF:=me_balance
				if !aMemberTrans[a_tel,11]==sCurr
					self:mxrate:=oCurr:GetROE(aMemberTrans[a_tel,11],Today())
					if self:mxrate>0
						me_balanceF:=Round(me_balance/self:mxrate,DecAantal)
					endif 
				endif
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
				AAdd(aTransMT,{me_accid,Str(me_balance,-1),Str(me_balanceF,-1),'0','0',aMemberTrans[a_tel,11],me_desc,cClosingdate,'H','CH',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
				oMBal:ChgBalance(me_accid, self:closingDate, me_balance,0, me_balanceF,0,aMemberTrans[a_tel,11],2)
			ENDIF
		NEXT
		*Record Total amount AM:
		IF !Empty(samProj)
			IF !AssOfficeProj==0.00
				nSeqnr++
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
				AAdd(aTransMT,{samProj,'0','0',Str(AssOfficeProj,-1),Str(AssOfficeProj,-1),sCurr,self:oLan:RGet("AM Office Projects Total"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
				oMBal:ChgBalance(samProj, self:closingDate, 0, AssOfficeProj, 0, AssOfficeProj,sCURR,2)
			ENDIF
		ELSE
			AssOffice:=Round(AssOffice+AssOfficeProj,DecAantal)
		ENDIF
		IF !Empty(samOFR)
			IF !AssOfficeOFR==0.00
				nSeqnr++
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
				AAdd(aTransMT,{samOFR,'0','0',Str(AssOfficeOFR,-1),Str(AssOfficeOFR,-1),sCurr,self:oLan:RGet("AM Office Own Funds Raising Total"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
				oMBal:ChgBalance(samOFR, self:closingDate, 0, AssOfficeOFR, 0, AssOfficeOFR,sCurr,2)
			ENDIF
		ELSE
			AssOffice:=Round(AssOffice+AssOfficeOFR,DecAantal)
		ENDIF
		IF AssOffice#0
			nSeqnr++
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
			AAdd(aTransMT,{sam,'0','0',Str(AssOffice,-1),Str(AssOffice,-1),sCurr,self:oLan:RGet("AM Office Total"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
			oMBal:ChgBalance(sam,	self:closingDate,	0,	AssOffice, 0, AssOffice,sCURR,2)
		ENDIF 
		// reverse add to income: 
		if !Empty(AssIncHome) 
			nSeqnr++
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
			AAdd(aTransMT,{SINCHOME,Str(AssIncHome,-1),Str(AssIncHome,-1),'0','0',sCurr,self:oLan:RGet("Reversal income for office assessment home assigned"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
			oMBal:ChgBalance(SINCHOME, self:closingDate, AssIncHome, 0, AssIncHome,0,sCURR,2)
			nSeqnr++
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
			AAdd(aTransMT,{SEXPHOME,'0','0',Str(AssIncHome,-1),Str(AssIncHome,-1),sCurr,self:oLan:RGet("Reversal income for office assessment home assigned"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
			oMBal:ChgBalance(SEXPHOME, self:closingDate,0, AssIncHome, 0, AssIncHome,sCURR,2)
		endif
		if !Empty(AssInc) 
			nSeqnr++
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
			AAdd(aTransMT,{SINC,Str(AssInc,-1),Str(AssInc,-1),'0','0',sCurr,self:oLan:RGet("Reversal income for office assessment assigned"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
			oMBal:ChgBalance(SINC, self:closingDate, AssInc, 0, AssInc,0,sCURR,2)
			nSeqnr++
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
			AAdd(aTransMT,{SEXP,'0','0',Str(AssInc,-1),Str(AssInc,-1),sCurr,self:oLan:RGet("Reversal income for office assessment assigned"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
			oMBal:ChgBalance(SEXP, self:closingDate,0, AssInc, 0, AssInc,sCURR,2) 
		endif
		// add to expense assessment field + int: 
		if!Empty(AssFldInt)
			nSeqnr++
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
			AAdd(aTransMT,{samFld,Str(AssFldInt,-1),Str(AssFldInt,-1),'0','0',sCurr,self:oLan:RGet("Expense for assessment field&int"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
			oMBal:ChgBalance(samFld, self:closingDate, AssFldInt, 0, AssFldInt,0,sCURR,2)
			nSeqnr++
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
			AAdd(aTransMT,{SEXP,'0','0',Str(AssFldInt,-1),Str(AssFldInt,-1),sCurr,self:oLan:RGet("Expense for assessment field&int"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
			oMBal:ChgBalance(SEXP, self:closingDate,0, AssFldInt, 0, AssFldInt,sCURR,2)
		endif
		if !Empty(AssFldIntHome)
			nSeqnr++
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
			AAdd(aTransMT,{samFld,Str(AssFldIntHome,-1),Str(AssFldIntHome,-1),'0','0',sCurr,self:oLan:RGet("Expense for assessment field&int for home assigned members"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
			oMBal:ChgBalance(samFld, self:closingDate, AssFldIntHome, 0, AssFldIntHome,0,sCURR,2)
			nSeqnr++
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
			AAdd(aTransMT,{SEXPHOME,'0','0',Str(AssFldIntHome,-1),Str(AssFldIntHome,-1),sCurr,self:oLan:RGet("Expense for assessment field&int for home assigned members"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
			oMBal:ChgBalance(SEXPHOME, self:closingDate,0, AssFldIntHome, 0, AssFldIntHome,sCURR,2)
		endif

		// 		Record total amount to PMC 
		IF mo_tot # 0
			nSeqnr++
			if !self:cPMCCurr==sCurr .and. fExChRate>0
				mo_totF:=Round(mo_tot/fExChRate,DecAantal)
			else
				mo_totF:=mo_tot
			endif
			//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
			AAdd(aTransMT,{shb,'0','0',Str(mo_tot,-1),Str(mo_totF,-1),self:cPMCCurr,self:oLan:RGet("PMC Total"),cClosingdate,'H','',LOGON_EMP_ID,'2',Str(nSeqnr,-1),'PMC',''})
			oMBal:ChgBalance(shb,	self:closingDate,	0,	mo_tot, 0, mo_totF,self:cPMCCurr,2)
		ENDIF
		
		
		// 		(time1:=Seconds())
		oStmnt:=SQLStatement{"set autocommit=0",oConn}
		oStmnt:Execute()
		oStmnt:=SQLStatement{'lock tables `assessmnttotal` write,`bankorder` write,`distributioninstruction` write,`log` write,`mbalance` write,`sysparms` write,`transaction` write ',oConn}     // alphabetic order
		oStmnt:Execute()
		if !Empty(oStmnt:Status)
			cError:=self:oLan:WGet('PMC transactions could not be recorded')+":"+oStmnt:ErrInfo:errormessage
			cErrorLog:=cError+': '+oStmnt:SQLString+CRLF+"Error:"+oStmnt:ErrInfo:errormessage
		endif
		if Empty(cError) .and. Len(aAssMbr)>0 
			// Record data of assessed amounts:
			// aAssmbr: {{mbrid,calcdate,periodbegin,periodend,amountassessed,amountofficeassmnt,amountintassmnt,percofficeassmnt,percintassmnt},...  
			//              1      2         3             4           5             6              7                  8                9
			oStmnt:=SQLStatement{"insert into assessmnttotal (`mbrid`,`calcdate`,`periodbegin`,`periodend`,`amountassessed`,`amountofficeassmnt`,`amountintassmnt`,`percofficeassmnt`,`percintassmnt`) values "+;
				Implode(aAssMbr,'","'),oConn} 
			oStmnt:Execute()
			if !Empty(oStmnt:Status)
				cError:=self:oLan:WGet('PMC transactions could not be recorded')+":"+oStmnt:ErrInfo:errormessage
				cErrorLog:=cError+': '+oStmnt:SQLString+CRLF+"Error:"+oStmnt:ErrInfo:errormessage
			endif
		endif
		if Empty(cError)
			IF Empty(self:oSys:IESMAILACC).or. Lower(SubStr(AllTrim(self:oSys:IESMAILACC),1,10))="ie_dallas@".or.Lower(SubStr(AllTrim(self:oSys:IESMAILACC),1,16))="data_ie_orlando@"
				SQLStatement{"update sysparms set iesmailacc='PMC-Files_Intl@sil.org'",oConn}:Execute()
			ENDIF
		endif 
		if Empty(cError) .and.nTransLock>0 
			*	Change status of transactions to "Send to PMC": bfm='H':  
			oStmnt:=SQLStatement{"update transaction set	bfm='H' where bfm='' and dat<='"+cClosingdate+"' and gc>'' and "+;
				" lock_id="+MYEMPID+" and lock_time > subdate(now(),interval 120 minute)",oConn}
			// 			oStmnt:=SQLStatement{"update transaction set	bfm='H' where concat(cast(transid as char),';',cast(seqnr as char)) in ("+cTransLock+")",oConn}
			oStmnt:Execute()
			if	!Empty(oStmnt:Status)
				cError:=self:oLan:WGet("could not mark transactions as sent to PMC")
				cErrorLog:=cError+': '+oStmnt:ErrInfo:errormessage+CRLF+"Statement:"+oStmnt:SQLString
			ENDIF
			if !oStmnt:NumSuccessfulRows=nTransLock 
				cError:=self:oLan:WGet("someone else has manipulated transactions to be sent to PMC")
				cErrorLog:=cError
			endif
		endif
		if Empty(cError) .and. Len(aDisLock)>0
			*	Record month within fixed/limited remaining amount distribution instructions: 
			// aDisLock: {{mbrid,seqnr,amountsent,singleuse,lastdate},...}
			cStmnt:="insert into distributioninstruction (`mbrid`,`seqnbr`,`amntsnd`,`disabled`,`lstdate`) values "+Implode(aDisLock,'","')+;
				" ON DUPLICATE KEY UPDATE lstdate=values(lstdate),amntsnd=values(amntsnd),disabled=values(disabled)"
			oStmntDistr:=SQLStatement{cStmnt,oConn} 
			oStmntDistr:Execute()
			if !Empty(oStmntDistr:Status)
				cError:=self:oLan:WGet("could not update distribution instruction for members")
				cErrorLog:=cError+': '+oStmntDistr:ErrInfo:errormessage+CRLF+"Statement:"+oStmntDistr:SQLString
			endif
		endif
		// reset arrays:
		aDisLock:=null_array
		cTransStmnt:=''
		aAccidMbr:=null_array
		aAssMbr:=null_array
		
		if Empty(cError)
			cTransnr:=''
			cTransnrDT:=''
			//aTransM/DT: accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid,transid 
			//             1    2     3      4      5      6            7      8   9  10    11        12    13     14     15  
			if !Empty(aTransMT)
				// add first PMC transaction line: 
				oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,seqnr,docid) values ("+Implode(aTransMT[1],'","',1,14)+")",oConn}
				oStmnt:Execute()
				if	oStmnt:NumSuccessfulRows<1
					cError:=self:oLan:WGet("could	no	record transaction for member")+Space(1)+aMemberTrans[a_tel,3]
					cErrorLog:=cError+': '+oStmnt:ErrInfo:errormessage+CRLF+"Statement:"+oStmnt:SQLString
				endif
				if Empty(cError)
					cTransnr:=ConS(SqlSelect{"select	LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
					// update aTransMT with cTransnr:
					// 					AEvalA(aTransMT,{|x|x[15]:=cTransnr})
					for i:=1 to Len(aTransMT)
						aTransMT[i,15]:=cTransnr
					next
					if !Empty(aTransDT)
						nTransnrDT:=Val(cTransnr)
						for i:=1 to Len(aTransDT)
							nTransnrDT++
							aTransDT[i,13]:='1'
							aTransDT[i,15]:=Str(nTransnrDT,-1)
							i++
							aTransDT[i,13]:='2'
							aTransDT[i,15]:=Str(nTransnrDT,-1)
						next
					endif
					oStmnt:=SQLStatement{'insert into transaction (`accid`,`deb`,`debforgn`,`cre`,`creforgn`,`currency`,`description`,`dat`,`bfm`,`gc`,`userid`,'+;
						'`poststatus`,`seqnr`,`docid`,`transid`) values '+Implode(aTransMT,'","',2)+iif(Empty(aTransDT),"",','+Implode(aTransDT,'","')),oConn}
					oStmnt:Execute()
					if	oStmnt:NumSuccessfulRows<1
						cError:=self:oLan:WGet('Could	not record transactions for the members')+' ('+oStmnt:Status:description+')'
						cErrorLog:=cError+': '+oStmnt:ErrInfo:errormessage+CRLF+"Statement:"+oStmnt:SQLString
					endif
				endif
			endif


		endif 
		// Reset arrays:
		aMemberTrans:=null_array
		aTransMT:=null_array
		aTransDT:=null_array 
		
		if Empty(cError)
			if !oMBal:ChgBalanceExecute()
				cError:=oMBal:cError
			endif
		endif 
		if Empty(cError) .and. Len(aBankOrder)>0 
			// aBankOrder: accntfrom,amount,description,banknbrcre,datedue,idfrom
			oStmnt:=SQLStatement{'insert into bankorder (`accntfrom`,`amount`,`description`,`banknbrcre`,`datedue`,`idfrom`) values '+Implode(aBankOrder,'","'),oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				cError:=self:oLan:WGet('could not record bankorder for members')
				cErrorLog:=cError+': '+oStmnt:ErrInfo:errormessage+CRLF+"Statement:"+oStmnt:SQLString
			ENDIF
		endif 
		// Reset arrays:
		aBankOrder:=null_array

		if Empty(cError)
			oStmnt:=SQLStatement{"update sysparms set pmislstsnd='"+SQLdate(self:closingDate)+"',exchrate='"+Str(fExChRate,-1)+"'",oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:Status)
				cError:=self:oLan:WGet("could	no	update sysparms")+'	('+oStmnt:Status:description+')'
				cErrorLog:=cError+': '+oStmnt:ErrInfo:errormessage+CRLF+"Statement:"+oStmnt:SQLString
			endif
		endif

		time0:=time1
		self:STATUSMESSAGE(Space(80) )
		if Empty(cError)
			if	PMCUpload
				LogEvent(self,self:oLan:WGet('Uploaded file')+Space(1)+cFilename+Space(1)+self:oLan:WGet("via Insite to PMC")+'; '+self:oLan:WGet('total amount')+": "+Str(mo_totF,-1)+' USD ( '+Str(mo_tot,-1)+' '+sCurr+'); '+Str(batchcount-directcount,-1)+	Space(1)+self:oLan:WGet("transactions")+'; '+self:oLan:WGet('Exchange rate')+': 1 USD='+Str(fExChRate,-1,8)+sCURR	)
			endif
			self:STATUSMESSAGE(self:oLan:WGet('unlocking member transactions')+'...')
			oStmnt:=SQLStatement{"update transaction set lock_id=0,lock_time='0000-00-00' where lock_id="+MYEMPID,oConn}
			oStmnt:Execute()
			SQLStatement{"commit",oConn}:Execute()
		else
			SQLStatement{"rollback",oConn}:Execute()
			LogEvent(self,cErrorLog,"logerrors")
			self:ResetLocks()
			ErrorBox{self,cError+"; "+self:oLan:WGet("nothing recorded; withdraw file sent to PMC")}:Show() 
			return
		ENDIF
		SQLStatement{"unlock tables",oConn}:Execute()

		// sending by email:
		cPMISMail:=AllTrim(self:oSys:IESMAILACC)
		cPMISMail:=StrTran(cPMISMail,";"+AllTrim(self:oSys:OWNMAILACC))
		cPMISMail:=StrTran(cPMISMail,AllTrim(self:oSys:OWNMAILACC))
		* Send file by email:
		IF maildirect .or. IsMAPIAvailable()
			IF maildirect .or.oMapi:Open( "" , "" )
				* Resolve IESname 
				// aRecip: {{name,email,persid},...}
				if !PMCUpload
					IF maildirect
						aRecip:={{"Partner Monetary Interchange System",cPMISMail,0}}
					else
						oRecip := oMapi:ResolveMailName( "Partner Monetary Interchange System",@cPMISMail,"Partner Monetary Interchange System")
					endif
				endif
				oPers:=SqlSelect{"select persid,lastname,firstname,email,"+SQLFullName(3)+" as fullname from person where persid='"+Str(self:oSys:PMCMANCLN,-1)+"'",oConn} 
				if oPers:Reccount>0
					IF maildirect
						AAdd(aRecip,{oPers:fullname,oPers:email,oPers:persid})
					else
						if PMCUpload
							oRecip := oMapi:ResolveName( oPers:lastname,oPers:persid,oPers:fullname,oPers:email)
						else
							oRecip2 := oMapi:ResolveName( oPers:lastname,oPers:persid,oPers:fullname,oPers:email)
						endif
					endif
				endif
				IF (oRecip != null_object.or.!Empty(aRecip)) .and.(PMCUpload .or.(!oRecip2==null_object.or.Len(aRecip)>1))
					cNoteText:="Dear "+oPers:fullname+","+CRLF+;
						iif(PMCUpload,;
						self:oLan:RGet("Will you please approve the uploaded OPP file")+Space(1)+FileSpec{cFilename}:Filename+Space(1)+;
						self:oLan:RGet("by going to Insite")+Space(1)+"https://www.pmc.insitehome.org/InSitePMC.aspx , tab OPP Upload.";
						,;
						"I send you attached a OPP file and would be grateful if you would approve the file by means of a reply all.")+;
						CRLF+LOGON_EMP_ID 
					if maildirect
						oSendMail:=SendEmailsDirect{self}
						if oSendMail:lError
							ErrorBox{self,self:oLan:WGet("Couldn't send PMC report by email")}:Show()
						else
							oSendMail:AddEmail("PMC Transactions "+FileSpec{cFilename}:Filename+" of "+sLand,cNoteText,aRecip,iif(PMCUpload,{},{cFilename}))
							oSendMail:SendEmails()
							oSendMail:Close() 
							if oSendMail:lError
								ErrorBox{self,self:oLan:WGet("Couldn't send PMC report by email")}:Show()
							else
								lSent:=true
							endif
						endif
						
					else
						IF oMapi:SendDocument( iif(PMCUpload,null_object,FileSpec{cFilename}) ,oRecip,oRecip2,"PMC Transactions "+FileSpec{cFilename}:Filename+" of "+sLand,cNoteText)
							(InfoBox{self:OWNER,"Partner Monetary Interchange System",;                                                                  
							self:oLan:WGet("Placed one mail message in the outbox of")+" "+EmailClient+" "+iif(PMCUpload,self:oLan:WGet("for approving of"),self:oLan:WGet("with attached the file"))+": "+cFilename}):Show()
							IF !PMCUpload
								LogEvent(self,self:oLan:WGet("Placed one PMC mail message in the outbox of")+" "+EmailClient+" "+self:oLan:WGet("with attached the file")+": "+cFilename,"Log")
							endif
							lSent:=true
						ENDIF
					endif
				ENDIF
				//oMapi:Close()
			ENDIF 
			IF	!lSent
				(InfoBox{self:OWNER,self:oLan:WGet("Partner Monetary Interchange System"),self:oLan:WGet("Generated one file")+":	"+cFilename+" ("+;
					iif(PMCUpload,self:oLan:WGet('Let PMCManager approve this file via Insite'),self:oLan:WGet('mail to PMC mail address')+" "+;
					AllTrim(self:oSys:IESMAILACC)+")")}):Show()
				if !PMCUpload	
					LogEvent(self,self:oLan:WGet("Generated one file")+":	"+cFilename+'; '+self:oLan:WGet("total amount")+": "+Str(mo_totF,-1)+' USD ( '+Str(mo_tot,-1)+' '+sCurr+'); '+Str(batchcount-directcount,-1)+ Space(1)+self:oLan:WGet("transactions")+'; '+self:oLan:WGet('Exchange rate')+': 1 USD='+Str(fExChRate,-1,8)+sCurr +;
						" ("+iif(PMCUpload,self:oLan:WGet('Let PMCManager approve this file via Insite'),self:oLan:WGet("mail to PMC mail address")+" "+;
						AllTrim(self:oSys:IESMAILACC)+")"))
				ENDIF
			ENDIF
		endif
	ENDIF
	SetDecimalSep(Asc('.') )
	aRecip:=null_array
	if !PMCUpload .and.!lStop .and.!maildirect
		oMapi:Close()
	endif

	self:Pointer := Pointer{POINTERARROW}
	RETURN
method RefreshLocks(TransIdsample as int,nTransLock as Dword) as logic class PMISsend 
	// refresh locks of PMC-transactions so they are long enough locked to complete PMC processing
	// TransIdsample: transid of a locked record to check remaining lock time
	// nTransLock: number of locked transactions to check if they ar all still available
	//
	// returns false if something wrong with locks
	//
	local oSel as SQLSelect 
	local oStmnt as SQLStatement
	if nTransLock>0
		oSel:=SqlSelect{"select TIMESTAMPDIFF(MINUTE,`lock_time`,CURRENT_TIMESTAMP()) as timeshift from transaction where transid="+Str(TransIdsample,-1)+" and lock_id="+MYEMPID,oConn}
		if oSel:Reccount<1 
			LogEvent(self,"lock not more available:"+oSel:SQLString+CRLF+oSel:ErrInfo:errormessage,"logerrors")
			return false
		endif
		if ConI(oSel:timeshift)>=110
			// refresh locks otherwise only 10 minutess left of 2 hour lock:
			oStmnt:=SQLStatement{"update transaction set lock_time=CURRENT_TIMESTAMP() where lock_id="+MYEMPID,oConn}
			oStmnt:Execute()
			if !oStmnt:NumSuccessfulRows=nTransLock
				LogEvent(self,"can't refresh locks:"+oStmnt:SQLString+CRLF+"Qty:"+Str(oStmnt:NumSuccessfulRows,-1)+'; error:'+oStmnt:ErrInfo:errormessage,"logerrors")
				return false
			endif
		endif
	endif
	return true
	
Method ResetLocks() class PMISsend
	// reset software lock:
	local oTrans as SQLSelect
	local oStmnt as SQLStatement 
	self:STATUSMESSAGE(self:oLan:WGet('unlocking member transactions')+'...')

	SQLStatement{"start transaction",oConn}:Execute()    // to unlock all transactions and distribution instructions read
	// select the transaction data
	oStmnt:=SQLStatement{"update transaction set lock_id=0,lock_time='0000-00-00' where lock_id="+MYEMPID,oConn}
	oStmnt:Execute()
	SQLStatement{"commit",oConn}:Execute() 
	SetDecimalSep(Asc('.'))
	return
METHOD WritePMCTrans(ptrHandle,me_kind,me_acc,me_amnt,me_oms,me_percd,me_date,me_type,me_destAcc,me_destPP) CLASS PMISsend
	LOCAL transcode AS STRING
	Default(@me_destAcc,"")
	Default(@me_destPP,"")
	Default(@me_percd,"")
	Default(@me_oms,"")
	IF me_kind==AG
		transcode:="AT"
	ELSE
		transcode:="GT"
	ENDIF
	FWriteLineUni(ptrHandle,"<PMISTran>")
	FWriteLineUni(ptrHandle,"<TranType>"+transcode+"</TranType>")
	FWriteLineUni(ptrHandle,"<OPP_Transaction_Amount>"+Str(-me_amnt,-1,DecAantal)+"</OPP_Transaction_Amount>")
	FWriteLineUni(ptrHandle,"<OPP_Transaction_Date>"+me_date+"</OPP_Transaction_Date>")
	IF (me_kind=MT .or. me_kind=AG) .and. !Empty(AllTrim(me_percd))
		FWriteLineUni(ptrHandle,"<Household_Code>"+AllTrim(me_percd)+"</Household_Code>")
	ELSE
		FWriteLineUni(ptrHandle,"<RPP>"+AllTrim(me_destPP)+"</RPP>")
	ENDIF
	IF me_kind!=AG
		FWriteLineUni(ptrHandle,"<RPP_Destination_String>"+self:HTMLConv(Compress(me_destAcc))+"</RPP_Destination_String>")
	ENDIF
	IF me_kind=MT
		FWriteLineUni(ptrHandle,"<RPP_Trans_Type_Code>"+self:HTMLConv(AllTrim(me_type))+"</RPP_Trans_Type_Code>")
	ENDIF
	IF !Empty(me_oms)
		FWriteLineUni(ptrHandle,"<Transaction_Description>"+self:HTMLConv(Compress(me_oms))+"</Transaction_Description>")
	ENDIF	
	FWriteLineUni(ptrHandle,"<OPP_Transaction_Ref>"+self:HTMLConv(Compress(me_acc))+"</OPP_Transaction_Ref>")
	//	FWriteLineUni(ptrHandle,"<Originating_Person>"+SELF:HTMLConv(me_pers)+"</Originating_Person>")
	FWriteLineUni(ptrHandle,"</PMISTran>")
	RETURN
STATIC DEFINE PMISSEND_AFSLDAG := 104 
STATIC DEFINE PMISSEND_AFSLDAGTEXT := 103 
STATIC DEFINE PMISSEND_BALANCETEXT := 102 
STATIC DEFINE PMISSEND_CANCELBUTTON := 101 
STATIC DEFINE PMISSEND_MAXTRANSID := 105 
STATIC DEFINE PMISSEND_OKBUTTON := 100 
STATIC DEFINE PMISSEND_TRANSACTIONEXT := 106 
