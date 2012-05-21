STATIC DEFINE AREAREPORT_AFSLDAG := 104 
STATIC DEFINE AREAREPORT_AFSLDAGTEXT := 103 
STATIC DEFINE AREAREPORT_BALANCETEXT := 102 
STATIC DEFINE AREAREPORT_CANCELBUTTON := 101 
STATIC DEFINE AREAREPORT_OKBUTTON := 100 
RESOURCE AskSend DIALOGEX  4, 3, 265, 83
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"&No", ASKSEND_CANCELBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 132, 56, 53, 12
	CONTROL	"&Yes", ASKSEND_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 194, 55, 53, 12
	CONTROL	"Do you want the printed transactions to be sent to PMC?", ASKSEND_FIXEDTEXT1, "Static", WS_CHILD, 4, 7, 244, 12
	CONTROL	"(this is IRREVOCABLE)", ASKSEND_FIXEDTEXT2, "Static", WS_CHILD, 4, 25, 236, 13
END

CLASS AskSend INHERIT DataDialogMine 

	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  export Result as shortint
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
RESOURCE AskUpld DIALOGEX  4, 3, 212, 86
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"&No", ASKUPLD_CANCELBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 84, 70, 53, 12
	CONTROL	"&Yes", ASKUPLD_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 144, 70, 53, 12
	CONTROL	"Has file with transactions successfully been uploaded without errors into Insite?", ASKUPLD_TEXTQESTION, "Static", WS_CHILD, 4, 7, 196, 29
	CONTROL	"(this is IRREVOCABLE)", ASKUPLD_FIXEDTEXT2, "Static", WS_CHILD, 4, 40, 196, 12
END

CLASS AskUpld INHERIT DataDialogMine 

	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCTextQestion AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  export Result as shortint
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
CLASS PMISsend INHERIT DataWindowExtra 

	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCBalanceText AS FIXEDTEXT
	PROTECT oDCAfsldagtext AS FIXEDTEXT
	PROTECT oDCAfsldag AS DATESTANDARD

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
	
	declare method ResetLocks,RefreshLocks
RESOURCE PMISsend DIALOGEX  13, 12, 319, 143
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"OK", PMISSEND_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 250, 16, 53, 12
	CONTROL	"Cancel", PMISSEND_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 250, 33, 53, 12
	CONTROL	"Fixed Text", PMISSEND_BALANCETEXT, "Static", WS_CHILD, 12, 19, 221, 29
	CONTROL	"Up to day:", PMISSEND_AFSLDAGTEXT, "Static", WS_CHILD, 23, 67, 39, 13
	CONTROL	"donderdag 14 oktober 2010", PMISSEND_AFSLDAG, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 80, 65, 118, 14
END

METHOD CancelButton( ) CLASS PMISsend
 	SELF:EndWindow()
	RETURN TRUE
METHOD Close(oEvent) CLASS PMISsend
	SUPER:Close(oEvent)
	//Put your changes here
	SELF:Destroy()
	RETURN
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

SELF:Caption := "Sending Transactions to PMC"
SELF:HyperLabel := HyperLabel{#PMISsend,"Sending Transactions to PMC",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS PMISsend
	LOCAL oWarn as warningbox, lSuc as LOGIC 
	local oAcc as SQLSelect
	
	self:closingDate := oDCAfsldag:Value 
	if !Empty(self:oSys:PMISLSTSND) .and. self:closingDate>self:oSys:PMISLSTSND
		self:AssPeriod:="("+DToC(self:oSys:PMISLSTSND)+" - "+DToC(self:closingDate)+")"
	else
		self:AssPeriod:="( - "+DToC(self:closingDate)+")"
	endif
	self:STATUSMESSAGE(self:oLan:WGet("Checking data, please wait")+"...")
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
	SELF:EndWindow()
	RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS PMISsend
	//Put your PostInit additions here 
	local aBalPrv:={}, aBalNow:={} as array
self:SetTexts()                                   
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
	LOCAL AssInt,AssOffice,AssOfficeProj,AssField,AssFldInt,AssFldIntHome,me_saldo,me_saldoF,OfficeRate as FLOAT
	local AssInc,AssIncHome as float  // to be reversed assement income totals
	local separatorline as STRING
	local heading as ARRAY
	local oCurr as CURRENCY 
	LOCAL aMemberTrans:={} as ARRAY
	LOCAL destinstr:={} as ARRAY 
	local aDistr:={} as array 
	local oReport as PrintDialog
	LOCAL i, a_tel, batchcount, directcount, iDest, iType,nSeqnr,nSeqnrDT,nRowCnt,CurrentMbrID as int
	LOCAL mo_tot,mo_totF, AmountDue,mo_direct, BalanceSend,BalanceSendEoM  as FLOAT
	LOCAL AmntAssessable,AmntMG,AmntCharges,remainingAmnt,AmntFromRPP,me_amount,availableAmnt,me_asshome,me_assint, amntlimited,AmntCorrection as FLOAT
	LOCAL mbrint,mbrfield,mbroffice,mbrofficeProj as FLOAT
	LOCAL me_has as LOGIC
	LOCAL me_accid,me_mbrid, me_gc,  me_stat, me_co, me_type, me_accnbr, me_pers,me_homePP,me_desc,destAcc,me_rate as STRING
	LOCAL cTransnr,cTransnrDT,mHomeAcc, cDestPersonId,me_householdid, me_destAcc,me_destPP,me_currency as STRING
	LOCAL ptrHandle
	LOCAL cFilename, datestr as STRING
	LOCAL DecSep as int
	LOCAL oMapi as MAPISession
	LOCAL oRecip,oRecip2 as MAPIRecip
	LOCAL cPMISMail as STRING
	LOCAL lSent as LOGIC
	LOCAL uRet as USUAL
	LOCAL oWindow as OBJECT
// 	LOCAL CurMonth:=Year(Today())*100+Month(Today()) as int
	LOCAL CurMonth:=Year(self:closingDate)*100+Month(self:closingDate) as int
	// 	LOCAL noIES as LOGIC
	LOCAL DestAmnt as FLOAT
	LOCAL oAfl as UpdateHouseHoldID
	LOCAL datelstafl as date
	LOCAL cDestAcc,cNoteText,cError,cStmsg,cAccs,cCurAcc as STRING 
	local nStep as int
	local nRow, nPage as int
	Local cAccCng as string,  nAnswer as int 
	local oAsk as AskSend 
	local oAskUp as AskUpld 
	local cErrMsg as string,lSkipMbr as logic
	LOCAL PrvYearNotClosed as LOGIC
	local fExChRate as float
	local lStop:=true,PMCUpload as logic
	local oTrans,oMbr,oAccD,oPers,oPersB,oBal, oAccBal as SQLSelect	 
	local oMBal as Balances
	local oStmnt,oStmntDistr as SQLStatement
	local aTransLock:={},aDisLock:={},aYearStartEnd as array 
	local nTransLock as Dword,nTransSample as int
	local cDistr as string
	local time1,time0 as float
	local cFatalError as string 
	local Country as string 
	local cStmnt,cDate as string 
	local cTransStmnt,cTransDTStmnt,cBankStmnt as string 


	oWindow:=GetParentWindow(self) 
	// Import first account change list 
	oWindow:Pointer := Pointer{POINTERHOURGLASS}
	oAfl:=UpdateHouseHoldID{}
	oAfl:Importaffiliated_person_account_list()

	// 	datelstafl:=self:oSys:DATLSTAFL 
	// 	if datelstafl<Today() 
	// 		/*	oInST:=Insite{}
	// 		cAccCng:=oInST:GetAccountChangeReport(datelstafl) 
	// 		oInST:Close()   */

	// 		oAfl:=UpdateHouseHoldID{}
	// 		if !oAfl:Processaffiliated_person_account_list(cAccCng)
	// 			IF !oAfl:Importaffiliated_person_account_list()
	// 				IF datelstafl<(Today()-31) 
	// 					nAnswer:= (TextBox{oWindow,self:oLan:WGet("Import RPP"),;
	// 						self:oLan:WGet('Your last import of the Account Changes Report from Insite is of')+' '+DToC(datelstafl)+'.'+LF+self:oLan:WGet('If you stop now you can first download that report from Insite into folder')+' '+curPath+' '+self:oLan:WGet('before the send to PMC')+CRLF+CRLF+self:oLan:WGet('Do you want to stop now?'),BOXICONQUESTIONMARK + BUTTONYESNO}):Show()
	// 					IF nAnswer == BOXREPLYYES 
	// 						oWindow:Pointer := Pointer{POINTERARROW} 
	// 						FileStart(WorkDir()+"Insite.html",self)
	// 						RETURN FALSE
	// 					ENDIF
	// 				ENDIF
	// 			ENDIF
	// 		ENDIF
	// 	ENDIF
	oWindow:Pointer := Pointer{POINTERARROW}

	oReport := PrintDialog{self,self:oLan:RGet("Sending transactions to PMC"),,160,DMORIENT_LANDSCAPE}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	oCurr:=Currency{"Sending to PMC"}
	fExChRate:=oCurr:GetROE("USD",Today(),true,true,1.65) 
	if oCurr:lStopped
		Return
	endif 
	Country:=SqlSelect{"select countryown from sysparms",oConn}:FIELDGET(1)

	PMCUpload:= iif(ConI(self:oSys:PMCUPLD)=1,true,false)
	// fExChRate:=self:mxrate 

	store 0 to AssInt,AssOffice,AssOfficeProj,AssField,AssInc,AssIncHome,AssFldInt,AssFldIntHome

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
	// Check consistency data
	if !CheckConsistency(self,true,false,@cFatalError)
		ErrorBox{self,cFatalError}:Show()
		// 		self:ENDWindow()
		self:Pointer := Pointer{POINTERARROW}
		return 
	endif
	oMBal:=Balances{}
	separatorline:= '--------------------|-----------|'+Replicate('-',126)+'|'
	nRow:=0
	nPage:=0
	store 0 to a_tel
	+nRowCnt :=0 
	self:STATUSMESSAGE(self:oLan:WGet('locking member transactions for update')+'...')

	// Check if nobody else is busy with sending to PMC: 
	// 	(time1:=Seconds())   

	oTrans:=SQLSelect{'select transid from transaction t '+;
		" where t.bfm='' and t.dat<='"+SQLdate(self:closingDate)+"' and t.gc>'' and "+;
		" t.lock_id<>0 and t.lock_id<>"+MYEMPID+" and t.lock_time > subdate(now(),interval 120 minute)",oConn}
	// 		" and t.accid in (select m.accid from member m) and "+;
	if oTrans:Reccount>0
		ErrorBox{self,self:oLan:WGet("somebody else busy with sending to PMC")}:Show()
		return
	endif 
	time0:=time1
	// 	LogEvent(self,"check busy:"+Str((time1:=Seconds())-time0,-1)+"sec","logtime")  
	oStmnt:=SQLStatement{"set autocommit=0",oConn}
	oStmnt:Execute()
	oStmnt:=SQLStatement{'lock tables `transaction` write',oConn} 
	oStmnt:Execute()
	oStmnt:=SQLStatement{'update transaction set lock_id="'+MYEMPID+'",lock_time=now() where '+;
		" bfm='' and dat<='"+SQLdate(self:closingDate)+"' and gc>''",oConn}
	oStmnt:Execute() 
	if !Empty(oStmnt:Status)
		ErrorBox{self,self:oLan:WGet("could not select transactions")+Space(1)+' ('+oStmnt:Status:description+')'}:Show()
		SQLStatement{"rollback",oConn}:Execute() 
		SQLStatement{"unlock tables",oConn}:Execute()
		return
	endif
	nTransLock:=oStmnt:NumSuccessfulRows
 	SQLStatement{"commit",oConn}:Execute()	
	SQLStatement{"unlock tables",oConn}:Execute()

// 	SQLStatement{"start transaction",oConn}:Execute()    // te lock all transactions and distribution instructions read
// 	oTrans:=SQLSelect{'select transid,seqnr from transaction t '+;
// 		" where t.bfm='' and t.dat<='"+SQLdate(self:closingDate)+"' and t.gc>''  order by t.transid,t.seqnr  for update",oConn}
// 	oTrans:Execute() 
// 	if !Empty(oTrans:Status)
// 		ErrorBox{self,self:oLan:WGet("could not select transactions")+Space(1)+' ('+oTrans:Status:description+')'}:Show()
// 		SQLStatement{"rollback",oConn}:Execute() 
// 		return
// 	endif 
// 	
// 	time0:=time1
// 	// 	LogEvent(self,"sel trans for update:"+Str((time1:=Seconds())-time0,-1)+"sec","logtime")
// 	
// 	// set software lock:
// 	AEval(oTrans:GetLookupTable(80000,#transid,#seqnr),{|x|AAdd(aTransLock,Str(x[1],-1)+';'+Str(x[2],-1))}) 
// 	cTransLock:=Implode(aTransLock,"','")
// 	time0:=time1
// 	// 	LogEvent(self,"get lookup table:"+Str((time1:=Seconds())-time0,-1)+"sec","logtime")

// 	oStmnt:=SQLStatement{"update transaction set lock_id="+MYEMPID+",lock_time=now() where concat(cast(transid as char),';',cast(seqnr as char)) in ("+cTransLock+")",oConn}
// 	oStmnt:Execute()
// 	if !Empty(oStmnt:Status)
// 		ErrorBox{self,self:oLan:WGet("could not lock required transactions")}:Show()
// 		SQLStatement{"rollback",oConn}:Execute() 
// 		return
// 	endif
// 	time0:=time1
// 	// 	LogEvent(self,"set locks:"+Str((time1:=Seconds())-time0,-1)+"sec","logtime")
// 	SQLStatement{"commit",oConn}:Execute()  // save locks 
	cStmsg:=self:oLan:WGet("Collecting data for the sending, please wait")+"..."
	// select the member data
// 	SQLStatement{"SET group_concat_max_len := @@max_allowed_packet",oConn}:Execute()

	oMbr:=SqlSelect{"select m.mbrid,m.accid,m.homepp,m.homeacc,m.householdid,m.co,m.has,m.grade,m.offcrate,"+;
		"ad.accid,ad.accnumber,"+SQLFullName(0,"p")+" as description,ad.currency,b.category as type,"+;
		"ai.accid as accidinc,ai.accnumber as accnumberinc,ai.description as descriptioninc,ai.currency as currencyinc,"+;
		"ae.accid as accidexp,ae.accnumber as accnumberexp,ae.description as descriptionexp,ae.currency as currencyexp,"+;
		"an.accid as accidnet,an.accnumber as accnumbernet,an.description as descriptionnet,an.currency as currencynet,"+;
		"pp.ppname as homeppname,"+;
		"group_concat(cast(d.desttyp as char),'#;#',cast(d.destamt as char),'#;#',d.destpp,'#;#',d.destacc,'#;#',cast(d.lstdate as char),'#;#',cast(d.seqnbr as char),'#;#',"+;
		"d.descrptn,'#;#',d.currency,'#;#',cast(d.amntsnd as char),'#;#',cast(d.singleuse as char),'#;#',dfir,'#;#',dfia,'#;#',checksave,'#;#',pd.ppname separator '#%#') as distr" +;
		" from member m left join ppcodes pp on (pp.ppcode=m.homepp) "+;
		" left join distributioninstruction d on (d.mbrid=m.mbrid and d.disabled=0) left join ppcodes pd on (d.destpp=pd.ppcode) "+;
		" left join account ad on (ad.accid=m.accid) left join balanceitem b on (b.balitemid=ad.balitemid) left join department dm on (dm.depid=m.depid) left join account ai on (ai.accid=dm.incomeacc) "+;
		" left join account ae on (ae.accid=dm.expenseacc) left join account an on (an.accid=dm.netasset),person p "+;   
	" where m.persid=p.persid group by m.mbrid order by m.mbrid",oConn}
	if oMbr:Reccount<1
		LogEvent(self,oMbr:SQLString,"logerrors") 
		self:ResetLocks(MYEMPID)
		WarningBox{oWindow,self:oLan:WGet("Send to PMC"),self:oLan:WGet("No members specified")}:Show()
		return
	endif
	time0:=time1
	// 	LogEvent(self,"sel mbr:"+Str((time1:=Seconds())-time0,-1)+"sec","logtime")
	oTrans:=SqlSelect{"select t.transid,t.seqnr,t.accid,t.persid,t.cre,t.deb,t.description,t.reference,t.gc,cast(t.poststatus as signed) as poststatus,"+;
		"t.fromrpp,cast(t.dat as date) as dat,m.mbrid "+;
		"from transaction t, account a left join member m on (m.accid=a.accid or m.depid=a.department) "+;
		" where t.bfm='' and t.dat<='"+SQLdate(self:closingDate)+"' and t.gc>'' and lock_id="+MYEMPID+" and t.lock_time > subdate(now(),interval 10 minute) and a.accid=t.accid order by mbrid,transid,seqnr",oConn}
	oTrans:Execute()
	time0:=time1
	// 	LogEvent(self,"sel trans:"+Str((time1:=Seconds())-time0,-1)+"sec","logtime")
	nTransSample:=ConI(oTrans:transid)  // save sample transid for checking purposes later
	// determine if previous year is closed for balances:
	aYearStartEnd := GetBalYear(Year(self:closingDate),Month(self:closingDate))   // determine start of fiscal year                           
	PrvYearNotClosed:=((aYearStartEnd[1]*12+aYearStartEnd[2])>(Year(LstYearClosed)*12+Month(LstYearClosed)))

	// collect distribution instructions:	
	nStep:=Max(Ceil(oMbr:Reccount/20.00),1)
	self:STATUSMESSAGE(cStmsg)
	DO WHILE .not.oMbr:EOF
		CurrentMbrID:=oMbr:mbrid
		if oMbr:Recno%nStep=0
			self:STATUSMESSAGE(cStmsg+' ('+Str((oMbr:Recno*5)/nStep,3,0)+'% )')
		endif
		me_mbrid:=Str(CurrentMbrID,-1)
		me_accid:= iif(Empty(oMbr:accid),Str(oMbr:accidexp,-1),Str(oMbr:accid,-1))
		me_accnbr:=iif(Empty(oMbr:accid),oMbr:accnumberexp,oMbr:ACCNUMBER)
		me_currency:=iif(Empty(oMbr:accid),oMbr:currencyexp,oMbr:Currency)
		me_type:=iif(Empty(oMbr:accid),EXPENSE,oMbr:TYPE)  
		me_pers:=StrTran(StrTran(oMbr:description,","," "),"-"," ") 
		
		if Empty(oMbr:homeppname)
			cError:=self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal Primary Finance entity")+":"+oMbr:HOMEPP
			exit
		endif
		if oMbr:HOMEPP # SEntity .and. !Empty(oMbr:accid) .and. (!oMbr:TYPE==LIABILITY.and. !oMbr:TYPE== asset )
			cError:=oLan:WGet("Not own")+" "+ self:oLan:WGet("member")+" "+me_pers+" "+self:oLan:WGet("should have a liability/funds or asset account")
			exit
		endif
		
		lSkipMbr:=false
		// compile destination instructions:
		destinstr:={}
		aDistr:={}
		mHomeAcc:=oMbr:HOMEACC
		if !Empty(oMbr:distr)
			cDistr:=UTF2String{Hex2Str(oMbr:distr)}:outbuf
			aDistr:=AEvalA(Split(cDistr ,"#%#"),{|x|Split(x,'#;#')})
			for i:=1 to Len(aDistr)
				//desttyp,destamt,destpp,DESTACC,lstdate,seqnbr,descrptn,currency,amntsnd,singleuse,dfir,dfia,checksave,destppname
				//   1       2      3      4       5       6      7          8      9        10      11   12     13         14
				cDestPersonId:=""
				IF aDistr[i,3]=="ACH"  //destpp
					// 					if Empty(aDistr[i,11]).or. Empty(aDistr[i,12]) .or.Empty(aDistr[i,13])
					// 						cError:=self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")
					// 						exit
					// 					endif				
					// 					cDestAcc:="#"+AllTrim(aDistr[i,11])+"#"+aDistr[i,13]+"#"+AllTrim(aDistr[i,12])+"#"+SubStr(me_pers,1,22)+"#"+AllTrim(oMbr:householdid)+"#"
					cDestAcc:=AllTrim(aDistr[i,4]) 			
					if !Empty(cDestAcc) .and.(!cDestAcc=='1'.or.cDestAcc=='2')
						cError:=self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")
						exit
					endif				
					cDestAcc:=AllTrim(oMbr:householdid)+iif(Empty(cDestAcc),"",+'#'+cDestAcc)  // household code is sufficient from 2011-04-03
				ELSE
					if oMbr:HOMEPP # SEntity .and. (aDistr[i,3] # SEntity .and.aDistr[i,3] # "AAA") .and. oMbr:co == "M"
						cError:=self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")
						exit
					endif
					cDestAcc:=AllTrim(aDistr[i,4]) 			
					// check legal ppcode: 
					if Empty(aDistr[i,14])
						cError:=self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")
						exit
					endif
					if aDistr[i,3] == "AAA"
						oPersB:=SQLSelect{"select persid from personbank where banknumber='"+cDestAcc+"'",oConn}
						if oPersB:Reccount>0
							cDestPersonId:=Str(oPersB:persid,-1)
						else
							cError:=self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")+", not found banknbr:"+cDestAcc
							exit					
						endif
						if CountryCode=="31".and.Len(cDestAcc)>7
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
			ASort(destinstr,,,{|x,y| x[3]<=y[3].or.y[3]>0.and.x[3]=3})   // sort in processing priority  (remaining RPP immeditialy aftre fixed
		endif
		if !Empty(cError)
			exit
		endif
		me_stat:=oMbr:Grade 
		me_has:=iif(ConI(oMbr:has)=1,true,false) 
		me_co:=oMbr:co 
		me_rate:=Upper(oMbr:OFFCRATE)
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
			me_householdid:=oMbr:householdid 
		ELSE
			me_householdid:=""
		ENDIF
		me_homePP:=oMbr:HOMEPP 
		store 0 to AmntAssessable,AmntMG,AmntCharges
		mbrfield:= 0
		mbrint:= 0
		mbroffice:= 0
		mbrofficeProj:=0 
		AmntFromRPP:=0.00
		// 		oTrans:=SQLSelect{"select * from transaction where bfm='' and accid="+me_accid+" and dat<='"+SQLdate(self:closingDate)+"' for update",oConn} 
		// 		oTrans:Execute()
		DO WHILE .not.oTrans:EOF .and. (Empty(oTrans:mbrid) .or.oTrans:mbrid <= CurrentMbrID)
			if oTrans:mbrid == CurrentMbrID
				me_gc:=oTrans:gc					  
				me_asshome:=0
				me_assint:=0
				if Posting
					if oTrans:poststatus<2
						// skip this member:
						lSkipMbr:=true
						cErrMsg+=AllTrim(oMbr:Description)+CRLF
						exit
					endif
				endif 
				if !Empty(me_gc) .and. oTrans:FROMRPP=='1' 
					AmntFromRpp:=Round(AmntFromRpp+oTrans:cre-oTrans:deb,DecAantal)
					// 					LogEvent(self,oMbr:description+": trans "+Str(oTrans:transid,-1)+', fromrpp:'+ConS(oTrans:FROMRPP)+', cre-deb:'+Str(oTrans:cre-oTrans:deb,-1,2)+'(total:'+Str(AmntFromRpp,-1,2)+')',"logsql") 
				endif
				do CASE
					* aMemberTrans[reknr,accnbr, accname, type transaction, transaction amount,assmntcode, destination{destacc,destPP,housecode,destnbr,destaccID,mbrtype},homeassamnt,tr.description,Dest.Persid,membercurrency]:
					*                1      2        3           4                 5                  6            7           ,1    ,2      ,3        ,4       ,5       ,6        8           9            10             11
				CASE me_gc='AG' .or. me_gc='OT'
					// calculate assessments:
					IF me_stat!="Staf" .and. ConI(oTrans:FROMRPP)==0
						me_asshome:=Round(((oTrans:cre-oTrans:deb)*OfficeRate)/100,DecAantal)
						me_assint:=Round(((oTrans:cre-oTrans:deb)*(self:sPercAssInt+self:sAssmntField))/100,DecAantal)
						IF me_co="S"
							mbrofficeProj:=Round(mbrofficeProj+me_asshome,DecAantal)
						ELSE
							mbroffice:=Round(mbroffice+me_asshome,DecAantal)
						ENDIF
						mbrint:=Round(mbrint+me_assint,DecAantal)
					ENDIF
					IF me_homePP!=SEntity
						me_amount:=Round(Round(oTrans:cre-oTrans:deb,decaantal)-round(me_asshome+me_assint,decaantal),decaantal)
						me_desc:=sCurrName+iif(Len(sCURRNAME)>1," ","")+Str(Round(oTrans:cre-oTrans:deb,DecAantal),-1) +"("+DToC(oTrans:dat)+")"
						IF !Empty(oTrans:persid)
							me_desc:=if(Empty(me_desc),"",me_desc+" ")+"from "+GetFullNAW(Str(oTrans:persid,-1),sLand,0)
						ENDIF
						me_desc+=iif(Empty(me_desc),"","; ")+oTrans:description
						AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,me_amount,"CN",{iif(Empty(oTrans:REFERENCE).and.me_co="S",mHomeAcc,oTrans:REFERENCE),me_homePP,me_householdid,,,me_co},,me_desc,,me_currency})				
						AmntAssessable:=Round(me_amount+AmntAssessable,DecAantal)
					ELSE
						//    AmntAssessable:=Round(AmntAssessable+ oTrans:cre-oTrans:deb,DecAantal)
					ENDIF
				CASE me_gc='MG'
					IF me_homePP!=SEntity
						me_desc:=sCurrName+iif(Len(sCURRNAME)>1," ","")+Str(Round(oTrans:cre-oTrans:deb,DecAantal),-1)+"("+DToC(oTrans:dat)+")"
						IF !Empty(oTrans:persid)
							me_desc:=if(Empty(me_desc),"",me_desc+" ")+"from "+GetFullNAW(Str(oTrans:persid,-1),sLand,0)
						ENDIF
						me_desc+=iif(Empty(me_desc),"","; ")+oTrans:description
						AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(oTrans:cre-oTrans:deb,DecAantal),"MM",{iif(Empty(oTrans:REFERENCE).and.me_co="S",mHomeAcc,oTrans:REFERENCE),me_homePP,me_householdid,,,me_co},,me_desc,,me_currency})
					ENDIF
					AmntMG:=Round(oTrans:cre-oTrans:deb+AmntMG,DecAantal)
				OTHER   // CH and PF
					IF me_homePP!=SEntity
						AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(oTrans:cre-oTrans:deb,DecAantal),"PC",{iif(Empty(oTrans:REFERENCE).and.me_co="S",mHomeAcc,oTrans:REFERENCE),me_homePP,me_householdid,,,me_co},,AllTrim(oTrans:Description),,me_currency})				
					ENDIF
					AmntCharges:=Round(oTrans:cre-oTrans:deb+AmntCharges,DecAantal)
				ENDCASE
			endif
			oTrans:skip()
		ENDDO 

		if !lSkipMbr	
			AssInt:=Round(AssInt+mbrint,DecAantal)
			AssField:=Round(AssField+mbrfield,DecAantal)
			AssOffice:=Round(AssOffice+mbroffice,DecAantal)
			AssOfficeProj:=Round(AssOfficeProj+mbrofficeProj,DecAantal) 
			// calculate reversal for ministry income: 
			if !Empty(SINC).and. me_type==LIABILITY 
				if !me_has
					AssInc:=Round(AssInc+mbroffice+mbrofficeProj,DecAantal)
					if !Empty(samFld)
						AssFldInt:=Round(AssFldInt+mbrfield+mbrint,DecAantal)
					endif
				else
					AssIncHome:=Round(AssIncHome+mbroffice+mbrofficeProj,DecAantal)
					if !Empty(samFld)
						AssFldIntHome:=Round(AssFldIntHome+mbrfield+mbrint,DecAantal)
					endif
				endif
			endif
			
			* Save: accid,accnbr,accname, type transactie, bedrag, assmntcode, destination{destacc,destPP,household code,destnbr,destaccID},homeassamnt, description
			// 1: assessment int+field:
			IF mbrint # 0
				AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, AG,mbrint,"",{me_accnbr,if(me_co="M","",me_homePP),if(me_co="M",me_householdid,""),,,me_co},if(me_co="M",mbroffice,mbrofficeProj),,,me_currency})
			ENDIF 

			// Transfer balance conform distribution instructions:
// 			if (Empty(self:oSys:PMISLSTSND) .or.self:closingDate> self:oSys:PMISLSTSND) .and. ;
// 					((me_homePP!=SEntity .and.self:closingDate=Today()) .or. ((me_homePP==SEntity .or. me_co="M").and.Len(destinstr)>0))
			if me_homePP!=SEntity  .or. (me_homePP==SEntity .or. me_co="M").and.Len(destinstr)>0
				
				// determine limit for sending money:
				if !Empty(oMbr:accid)
					// only one direct account:
					oMBal:cAccSelection:=" a.accid='"+me_accid+"'" 
					oAccBal:=SqlSelect{oMBal:SQLGetBalance(, CurMonth),oConn}      // maximum balance is balance at closing date
					oAccBal:Execute()
					BalanceSend:=Round(oAccBal:per_cre-oAccBal:per_deb,2)
					if PrvYearNotClosed .and. (oMbr:type=INCOME .or.oMBR:TYPE=EXPENSE)
						BalanceSend:=Round(BalanceSend+oAccBal:prvyr_cre-oAccBal:prvyr_deb,2)   // add balance previous year because not in this account
					endif						
// 					oMBal:GetBalance(me_accid,,self:closingDate)      // maximum balance is balance at closing date
// 					BalanceSend:=Round(oMBal:per_cre-oMBal:per_deb,2)  // take smallest balance
				else
					// department member:
					oMBal:cAccSelection:=" a.accid='"+Str(oMbr:accidinc,-1)+"'" 
					oAccBal:=SqlSelect{oMBal:SQLGetBalance(, CurMonth),oConn}      // maximum balance is balance at closing date
					oAccBal:Execute()
					BalanceSend:=Round(oAccBal:per_cre-oAccBal:per_deb,2)
					if PrvYearNotClosed
						BalanceSend:=Round(BalanceSend+oAccBal:prvyr_cre-oAccBal:prvyr_deb,2)   // add balance previous year because not yet in netasset
					endif						
					oMBal:cAccSelection:=" a.accid='"+Str(oMbr:accidexp,-1)+"'" 
					oAccBal:=SqlSelect{oMBal:SQLGetBalance(, CurMonth),oConn}      // maximum balance is balance at closing date
					oAccBal:Execute()
					BalanceSend:=Round(BalanceSend+oAccBal:per_cre-oAccBal:per_deb,2)
					if PrvYearNotClosed
						BalanceSend:=Round(BalanceSend+oAccBal:prvyr_cre-oAccBal:prvyr_deb,2)   // add balance previous year because not yet in netasset
					endif						
					oMBal:cAccSelection:=" a.accid='"+Str(oMbr:accidnet,-1)+"'" 
					oAccBal:=SqlSelect{oMBal:SQLGetBalance(, CurMonth),oConn}      // maximum balance is balance at closing date
					oAccBal:Execute()
					BalanceSend:=Round(BalanceSend+oAccBal:per_cre-oAccBal:per_deb,2)
// 					oMBal:GetBalance(Str(oMbr:accidinc,-1),,self:closingDate)      // maximum balance is balance at closing date
// 					BalanceSend:=Round(oMBal:per_cre-oMBal:per_deb,2)
// 					if PrvYearNotClosed
// 						BalanceSend:=Round(BalanceSend+oMBal:vjr_cre-oMBal:vjr_deb,2)   // add balance previous year because not yet in netasset
// 					endif						
// 					oMBal:GetBalance(Str(oMbr:accidexp,-1),,self:closingDate)      // maximum balance is balance at closing date
// 					BalanceSend:=Round(BalanceSend+oMBal:per_cre-oMBal:per_deb,2)
// 					if PrvYearNotClosed
// 						BalanceSend:=Round(BalanceSend+oMBal:vjr_cre-oMBal:vjr_deb,2)   // add balance previous year because not yet in netasset
// 					endif						
// 					oMBal:GetBalance(Str(oMbr:accidnet,-1),,self:closingDate)      // maximum balance is balance at closing date
// 					BalanceSend:=Round(BalanceSend+oMBal:per_cre-oMBal:per_deb,2) 
				endif
				
				remainingAmnt:=Round(BalanceSend-mbroffice-mbrofficeProj-mbrint,DecAantal)
				IF me_homePP!=SEntity .and.self:closingDate= Today() 
					// for transactions to be send to homepp:
					AmntCorrection:=Round(remainingAmnt-AmntAssessable-AmntMG-AmntCharges,DecAantal)
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
						IF AllTrim(destinstr[iDest,1])==SEntity .and. !Empty(AllTrim(destinstr[iDest,2]))
							// transaction own account:
							oAccD:=SQLSelect{"select accid from account where accnumber='"+destinstr[iDest,2]+"'",oConn}
							if oAccD:Reccount>0
								iType:=DT
								destAcc:=Str(oAccD:accid,-1)
							ENDIF
						elseIF AllTrim(destinstr[iDest,1])=="AAA" .and. !Empty(AllTrim(destinstr[iDest,2]))
							// transaction to local bank:
							if Empty(sCRE)
								SQLStatement{"rollback",oConn}:Execute() 
								(ErrorBox{self,self:oLan:WGet("Account payable not defined in System Parameters")+"!"}):Show()
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
									AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, iType,DestAmnt,"",{destinstr[iDest,2],destinstr[iDest,1],me_householdid,destinstr[iDest,6],destAcc,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})
									AAdd(aDisLock,{me_mbrid,destinstr[iDest,6],DestAmnt,destinstr[iDest,11]})
									//update prelimenary distribution record:
									// 									oStmnt:=SQLStatement{"update distributioninstruction set lstdate='"+SQLdate(self:closingDate)+;
									// 										"',amntsnd='"+Str(DestAmnt,-1)+"'"+iif(destinstr[iDest,11],",disabled=1",'')+" where  mbrid="+me_mbrid+" and seqnbr="+destinstr[iDest,6],oConn}
									// 									oStmnt:Execute()
									// 									if !Empty(oStmnt:Status)
									// 										SQLStatement{"rollback",oConn}:Execute()
									// 										ErrorBox{self,self:oLan:WGet("could not update distribution instruction for member")+Space(1)+me_desc}:Show()
									// 										return
									// 									endif  
									IF me_homePP!=SEntity
										AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-DestAmnt,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})				
										AmntCharges:=Round(-DestAmnt+AmntCharges,DecAantal)
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
								AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, iType,me_amount,"",{destinstr[iDest,2],destinstr[iDest,1],me_householdid,,destAcc,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})
								remainingAmnt:=Round(remainingAmnt-me_amount,DecAantal)
								IF me_homePP!=SEntity
									AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-me_amount,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})				
									AmntCharges:=Round(-me_amount+AmntCharges,DecAantal)
								endif
								if destinstr[iDest,11]														//lock distribution record:
									AAdd(aDisLock,{me_mbrid,destinstr[iDest,6],me_amount,destinstr[iDest,11]})
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
										amntlimited:=Min(AmntFromRpp,remainingAmnt)
									else
										amntlimited:=remainingAmnt
									endif
									amntlimited:=Min(amntlimited, Round(DestAmnt-destinstr[iDest,9],DecAantal))
									if amntlimited>0.00  
										AAdd(aDisLock,{me_mbrid,destinstr[iDest,6],round(destinstr[iDest,9]+amntlimited,decaantal),destinstr[iDest,11]})
										AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, iType,amntlimited,"",{destinstr[iDest,2],destinstr[iDest,1],me_householdid,,destAcc,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})
										IF me_homePP!=SEntity
											AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-amntlimited,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})				
											AmntCharges:=Round(-amntlimited+AmntCharges,DecAantal)
										endif
									endif
								ENDIF
							ELSE  // no limit
								if destinstr[iDest,3]=3  // remaining from RPP
									amntlimited:=Min(AmntFromRpp,remainingAmnt)
								else
									amntlimited:=remainingAmnt
								endif 
								if amntlimited>0.00  
									AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, iType,amntlimited,"",{destinstr[iDest,2],destinstr[iDest,1],me_householdid,,destAcc,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})
									IF me_homePP!=SEntity
										AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-amntlimited,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})				
										AmntCharges:=Round(-amntlimited+AmntCharges,DecAantal)
									endif
									AAdd(aDisLock,{me_mbrid,destinstr[iDest,6],amntlimited,destinstr[iDest,11]})
									remainingAmnt:=Round(remainingAmnt-amntlimited,DecAantal)
								endif
							ENDIF
						ENDIF
					NEXT
				ENDIF
				// 2: In case of member from other homePP seperate transactions for CN,MM and PC:
				IF me_homePP!=SEntity .and.self:closingDate=Today()
					IF !AmntCorrection=0.00
						// send if applicable remaining balance to PMIS
						AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,AmntCorrection,"CN",{"",me_homePP,me_householdid,,,me_co},,"Transfer of remaining balance to home office",cDestPersonId,me_currency})
					ENDIF
				ENDIF
			endif
		endif
		oMbr:skip()
	ENDDO 
	if !Empty(cError)
		(ErrorBox{self,cError}):Show()
		self:ResetLocks(MYEMPID)
		return
	endif
	if !Empty(cErrMsg)
		WarningBox{,"Send to PMC","The following members have been skipped because of not posted transactions:"+CRLF+cErrMsg}:Show()
	endif
	batchcount:=Len(aMemberTrans)
	directcount:=0
	mo_tot:=0
	mo_direct:=0
	IF batchcount=0
		(InfoBox{self,self:oLan:WGet("Partner Monetary Clearinghouse"),self:oLan:WGet("Nothing needs to be send")+"!"}):Show()
		self:Pointer := Pointer{POINTERARROW}
		RETURN
	ENDIF 
	self:STATUSMESSAGE(self:oLan:WGet('Producing report')+'...')

	ASort(aMemberTrans,,,{|x,y| x[3]<=y[3]})  // sort on name member
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
		'currency    :  '+sCurr+'  '+Pad(sCurrName,27)+Space(81)+'PERIOD ' +iif(!empty(self:oSys:pmislstsnd).and. self:closingDate>self:oSys:pmislstsnd,DToC(self:oSys:pmislstsnd),"")+ ' TO ' + DToC(self:closingDate),;
		' ',;
		Pad('MEMBER',20,' ')+PadL('AMOUNT',12,' ')+' DESCRIPTION',separatorline}
	FOR a_tel=1 to batchcount
		* Print member data:
		* aMemberTrans[reknr,accnbr, accname, type transaction, transaction amount,assmntcode, destination{destacc,destPP,housecode,destnbr,destaccID,mbrtype},homeassamnt,tr.description,Dest.Persid,membercurrency]:
		*                1      2        3           4                 5                  6           7         ,1    ,2      ,3        ,4       ,5       ,6        8           9            10             11
		me_accid:=aMemberTrans[a_tel,1]
		me_saldo:=aMemberTrans[a_tel,5]
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
			Pad(aMemberTrans[a_tel,3],20)+Str(me_saldo,12,2)+' '+Pad(me_desc,127),heading,3-nRowCnt)
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
	// 	LogEvent(self,"print report:"+Str((time1:=Seconds())-time0,-1)+"sec","logtime")

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

	if !lStop 
		// refresh locks
		* Produce first Datafile: 
		self:STATUSMESSAGE(self:oLan:WGet('Producing PMC file')+'...')
		DecSep:=SetDecimalSep(Asc("."))
		ptrHandle := MakeFile(self,cFilename,self:oLan:WGet("Creating PMC-file"))
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
			datestr:=Str(Year(self:closingDate),4)+"-"+StrZero(Month(self:closingDate),2)+"-"+StrZero(Day(self:closingDate),2)
			FOR a_tel=1 to batchcount
				* Write member data:
				* reknr,accnbr, accname, type transactie, bedrag,assmntcode, destination{destacc,destPP,housecode,distrseqnbr,destAcc,CO},homeassamnt,description:"
				IF !aMemberTrans[a_tel,4]==DT
					me_accnbr:=aMemberTrans[a_tel,2]
					me_saldo:=aMemberTrans[a_tel,5]
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
					self:WritePMCTrans(ptrHandle,aMemberTrans[a_tel,4],me_accnbr,me_saldo,me_pers,me_householdid,datestr,aMemberTrans[a_tel,6],me_destAcc,me_destPP)
				ENDIF
			NEXT
			FWriteLineUni(ptrHandle,"</PMISBatch>")
			* closing record:
			FClose(ptrHandle)
			if PMCUpload
				lStop:=true
				FileStart(WorkDir()+"InsitePMCUpload.html",self)
				oAskUp:=AskUpld{self,,,cFilename}
				oAskUp:Show() 
				if oAskUp:Result==1
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
				endif
			endif
		endif
	endif
	if lStop 
		self:ResetLocks(MYEMPID)
		return
	else
		IF Empty(self:oSys:PMISLSTSND) .or.self:oSys:PMISLSTSND<ToDay()-400
			// still IES:
			IF (TextBox{oWindow,self:oLan:WGet("Partner Monetary Clearinghouse"),;
					self:oLan:WGet('Did you really get confirmation from Dallas that your WO is PMC enabled')+'?',BOXICONQUESTIONMARK + BUTTONYESNO}):Show() = BOXREPLYNO
				self:ResetLocks(MYEMPID)
				RETURN
			ENDIF
		ENDIF
		oMapi := MAPISession{}
		self:Pointer := Pointer{POINTERHOURGLASS}
		cStmsg:=self:oLan:WGet("Recording transactions, please wait")+"..." 
		self:STATUSMESSAGE(cStmsg)  
		nStep:=Ceil(batchcount/10.00)
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
		
// 		(time1:=Seconds())
		SQLStatement{"start transaction",oConn}:Execute()
		IF Empty(self:oSys:IESMAILACC).or. Lower(SubStr(AllTrim(self:oSys:IESMAILACC),1,10))="ie_dallas@".or.Lower(SubStr(AllTrim(self:oSys:IESMAILACC),1,16))="data_ie_orlando@"
			SQLStatement{"update sysparms set iesmailacc='PMC-Files_Intl@sil.org'",oConn}:Execute()
		ENDIF
		//	lock mbalance records:
		oBal:=SQLSelect{"select mbalid from mbalance where accid in ("+cAccs+")"+;
			" and	year="+Str(Year(self:closingDate),-1)+;
			" and	Month="+Str(Month(self:closingDate),-1)+" order by mbalid for update",oConn}
		if	!Empty(oBal:Status)
			cError:=self:oLan:WGet("balance records locked by someone else, thus	skipped")
			LogEvent(self,cError+':'+oBal:ErrInfo:errormessage+CRLF+"Statement:"+oBal:SQLString,"LogErrors")
		endif	  
// 		if Empty(cError) .and.!Empty(cTransLock)
		if Empty(cError) 
			*	Change status of transactions to "Send to PMC": bfm='H':  
			oStmnt:=SQLStatement{"update transaction set	bfm='H' where bfm='' and dat<='"+SQLdate(self:closingDate)+"' and gc>'' and "+;
			" lock_id="+MYEMPID+" and lock_time > subdate(now(),interval 120 minute)",oConn}

// 			oStmnt:=SQLStatement{"update transaction set	bfm='H' where concat(cast(transid as char),';',cast(seqnr as char)) in ("+cTransLock+")",oConn}
			oStmnt:Execute()
			if	oStmnt:NumSuccessfulRows <1
				cError:=self:oLan:WGet("could not mark transactions as sent to PMC")
				LogEvent(self,cError+CRLF+"Statement:"+oStmnt:SQLString,"LogErrors")
			ENDIF
			if !oStmnt:NumSuccessfulRows=nTransLock 
				cError:=self:oLan:WGet("someone else has manipulated transactions to be sent to PMC")
				LogEvent(self,cError,"LogErrors")
			endif
		endif
		if Empty(cError) .and. Len(aDisLock)>0
			*	Record month within fixed/limited remaining amount distribution instructions:
			cDate:=SQLdate(self:closingDate)
			cStmnt:=''
			for i:=1 to Len(aDisLock)      //{me_mbrid.seqnbr,DestAmnt,disabled} 
				cStmnt+=iif(Empty(cStmnt),'',',')+"('"+cDate+"',"+Str(aDisLock[i,3],-1)+","+iif(aDisLock[i,4],'1','0')+","+aDisLock[i,1]+","+aDisLock[i,2]+")"
			next
			cStmnt:="insert into distributioninstruction (`lstdate`,`amntsnd`,`disabled`,`mbrid`,`seqnbr`) values "+cStmnt+;
				" ON DUPLICATE KEY UPDATE lstdate=values(lstdate),amntsnd=values(amntsnd),disabled=values(disabled)"
			oStmntDistr:=SQLStatement{cStmnt,oConn} 
			oStmntDistr:Execute()
			if !Empty(oStmntDistr:Status)
				cError:=self:oLan:WGet("could not update distribution instruction for members")
				LogEvent(self,cError+CRLF+"Statement:"+oStmntDistr:SQLString,"LogErrors")
			endif
		endif
		cTransStmnt:=''
		if Empty(cError)
			cTransnr:=''
			cTransnrDT:=''
			cBankStmnt:=''
			nSeqnr:=0
			nSeqnrDT:=0
			FOR a_tel = 1 to batchcount
				if a_tel%nStep=0
					self:STATUSMESSAGE(cStmsg+' ('+Str((a_tel*10)/nStep,3,0)+'% )')
				endif
				* aMemberTrans[reknr,accnbr, accname, type transaction, transaction amount,assmntcode, destination{destacc,destPP,housecode,destnbr,destaccID,mbrtype},homeassamnt,tr.description,Dest.Persid,membercurrency]:
				*          1      2        3           4                 5                  6           7         ,1    ,2      ,3        ,4       ,5       ,6        8           9            10             11
				me_accid:=aMemberTrans[a_tel,1]
				me_saldo:=aMemberTrans[a_tel,5]
				* Record transactions for decreasing balance of member:
				IF aMemberTrans[a_tel,4]=AG
					me_desc:=self:oLan:RGet("Assessment Intern+Field of gifts from")+Space(1)+Country+' '+self:AssPeriod
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
				me_saldoF:=me_saldo
				if !aMemberTrans[a_tel,11]==sCurr
					self:mxrate:=oCurr:GetROE(aMemberTrans[a_tel,11],Today())
					if self:mxrate>0
						me_saldoF:=Round(me_saldo/self:mxrate,DecAantal)
					endif 
				endif
				cError:=""
				if aMemberTrans[a_tel,4]==DT
					nSeqnrDT++
				else
					nSeqnr++
				endif
				if Empty(cTransnr) .and.!aMemberTrans[a_tel,4]==DT .or. Empty(cTransnrDT) .and.aMemberTrans[a_tel,4]==DT  
					oStmnt:=SQLStatement{"insert into transaction set accid="+me_accid+",deb='"+Str(me_saldo,-1)+"',debforgn='"+Str(me_saldoF,-1)+"'"+;
						",currency='"+aMemberTrans[a_tel,11]+"',description='"+AddSlashes(me_desc)+"',dat='"+SQLdate(self:closingDate)+"',bfm='H',gc='CH',userid='"+LOGON_EMP_ID+"'"+;
						",poststatus=2,seqnr=1",oConn}
					oStmnt:Execute()
					if	oStmnt:NumSuccessfulRows<1
						cError:=self:oLan:WGet("could	no	record transaction for member")+Space(1)+aMemberTrans[a_tel,3]+' ('+oStmnt:Status:description+')'
						LogEvent(self,cError+CRLF+"Statement:"+oStmnt:SQLString,"LogErrors")
						exit
					endif
					IF	aMemberTrans[a_tel,4]==DT
						if	Empty(cTransnrDT)
							cTransnrDT:=ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
						endif
					elseif Empty(cTransnr)
						cTransnr:=ConS(SqlSelect{"select	LAST_INSERT_ID()",oConn}:FIELDGET(1))
					endif
				else         //accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
					cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+me_accid+',"'+Str(me_saldo,-1)+'","'+Str(me_saldoF,-1)+'",0,0,"'+aMemberTrans[a_tel,11]+;
						'","'+AddSlashes(me_desc)+'","'+SQLdate(self:closingDate)+'","H","CH","'+LOGON_EMP_ID+'",2,'+;
						iif(aMemberTrans[a_tel,4]==DT,cTransnrDT+','+Str(nSeqnrDT,-1),cTransnr+','+Str(nSeqnr,-1))+')'
					
				endif
				oMBal:ChgBalance(me_accid, self:closingDate, me_saldo,0, me_saldoF,0,aMemberTrans[a_tel,11]) 
				// record transactions to own PP/ own account Payable directly
				IF aMemberTrans[a_tel,4]==DT
					nSeqnrDT++
					//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
					cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+aMemberTrans[a_tel,7][5]+',0,0,"'+Str(me_saldo,-1)+'","'+Str(me_saldoF,-1)+'","'+aMemberTrans[a_tel,11]+;
						'","'+AddSlashes(aMemberTrans[a_tel,9]+iif(Empty(aMemberTrans[a_tel,9]),"",'; ')+oLan:RGet("From")+Space(1)+AllTrim(aMemberTrans[a_tel,3]))+;
						'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnrDT+','+Str(nSeqnrDT,-1)+')'
					oMBal:ChgBalance(aMemberTrans[a_tel,7][5], self:closingDate, 0, me_saldo, 0, me_saldoF,aMemberTrans[a_tel,11]) 
					if aMemberTrans[a_tel,7][5]==sCRE .and.aMemberTrans[a_tel,7][2]=="AAA" .and.me_saldo>0.00 
						// to account payable and local bank: make BankOrder: 
						// accntfrom,amount,description,banknbrcre,datedue,idfrom 
						cBankStmnt+=iif(Empty(cBankStmnt),'',',')+'('+sCRE+','+Str(me_saldo,-1)+',"'+AddSlashes(iif(Empty(aMemberTrans[a_tel,9]),me_desc,aMemberTrans[a_tel,9]))+'","'+;
						AddSlashes(AllTrim(aMemberTrans[a_tel,7][1])) +'",CURDATE(),'+me_accid+')'
					endif
				ENDIF
				// Also transaction for Office assessment:
				IF aMemberTrans[a_tel,4]=AG .and.aMemberTrans[a_tel,8]#0
					IF aMemberTrans[a_tel,7][6]="M"
						me_desc:=self:oLan:RGet("Assessment office of gifts from")+Space(1)+Country +' '+self:AssPeriod
					ELSE
						me_desc:=self:oLan:RGet("Assessment office projects of gifts from")+Space(1)+Country+' '+self:AssPeriod
					ENDIF
					nSeqnr++
					me_saldo:=aMemberTrans[a_tel,8]
					me_saldoF:=me_saldo
					if !aMemberTrans[a_tel,11]==sCurr
						self:mxrate:=oCurr:GetROE(aMemberTrans[a_tel,11],Today())
						if self:mxrate>0
							me_saldoF:=Round(me_saldo/self:mxrate,DecAantal)
						endif 
					endif
					//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
					cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+me_accid+',"'+Str(me_saldo,-1)+'","'+Str(me_saldoF,-1)+'",0,0,"'+aMemberTrans[a_tel,11]+;
						'","'+AddSlashes(me_desc)+'","'+SQLdate(self:closingDate)+'","H","CH","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
					oMBal:ChgBalance(me_accid, self:closingDate, me_saldo,0, me_saldoF,0,aMemberTrans[a_tel,11])
				ENDIF
			NEXT

			*Record Total amount AM:
			IF Empty(cError).and.!Empty(samProj)
				IF AssOfficeProj#0
					nSeqnr++
					//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
					cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+samProj+',0,0,"'+Str(AssOfficeProj,-1)+'","'+Str(AssOfficeProj,-1)+'","'+sCurr+;
						'","'+self:oLan:RGet("AM Office Projects Total")+'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
					oMBal:ChgBalance(samProj, self:closingDate, 0, AssOfficeProj, 0, AssOfficeProj,sCURR)
				ENDIF
			ELSE
				AssOffice:=Round(AssOffice+AssOfficeProj,DecAantal)
			ENDIF
			IF Empty(cError).and.AssOffice#0
				nSeqnr++
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
				cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+sam+',0,0,"'+Str(AssOffice,-1)+'","'+Str(AssOffice,-1)+'","'+sCurr+;
					'","'+self:oLan:RGet("AM Office Total")+'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
				oMBal:ChgBalance(sam,	self:closingDate,	0,	AssOffice, 0, AssOffice,sCURR)
			ENDIF 
			// reverse add to income: 
			if Empty(cError).and.!Empty(AssIncHome) 
				nSeqnr++
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
				cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+SINCHOME+',"'+Str(AssIncHome,-1)+'","'+Str(AssIncHome,-1)+'",0,0,"'+sCurr+;
					'","'+self:oLan:RGet('Reversal income for office assessment home assigned')+'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
				oMBal:ChgBalance(SINCHOME, self:closingDate, AssIncHome, 0, AssIncHome,0,sCURR)
				if Empty(cError)
					nSeqnr++
					//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
					cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+SEXPHOME+',0,0,"'+Str(AssIncHome,-1)+'","'+Str(AssIncHome,-1)+'","'+sCurr+;
						'","'+self:oLan:RGet('Reversal income for office assessment home assigned')+'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
					oMBal:ChgBalance(SEXPHOME, self:closingDate,0, AssIncHome, 0, AssIncHome,sCURR)
				endif
			endif
			if Empty(cError).and.!Empty(AssInc) 
				nSeqnr++
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
				cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+SINC+',"'+Str(AssInc,-1)+'","'+Str(AssInc,-1)+'",0,0,"'+sCurr+;
					'","'+self:oLan:RGet('Reversal income for office assessment field assigned')+'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
				oMBal:ChgBalance(SINC, self:closingDate, AssInc, 0, AssInc,0,sCURR)
				if Empty(cError)
					nSeqnr++
					//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
					cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+SEXP+',0,0,"'+Str(AssInc,-1)+'","'+Str(AssInc,-1)+'","'+sCurr+;
						'","'+self:oLan:RGet('Reversal income for office assessment field assigned')+'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
					oMBal:ChgBalance(SEXP, self:closingDate,0, AssInc, 0, AssInc,sCURR) 
				endif
			endif

			// add to expense assessment field + int: 
			if Empty(cError).and.!Empty(AssFldInt)
				nSeqnr++
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
				cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+samFld+',"'+Str(AssFldInt,-1)+'","'+Str(AssFldInt,-1)+'",0,0,"'+sCurr+;
					'","'+self:oLan:RGet('Expense for assessment field&int')+'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
				oMBal:ChgBalance(samFld, self:closingDate, AssFldInt, 0, AssFldInt,0,sCURR)
				if Empty(cError)
					nSeqnr++
					//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
					cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+SEXP+',0,0,"'+Str(AssFldInt,-1)+'","'+Str(AssFldInt,-1)+'","'+sCurr+;
						'","'+self:oLan:RGet('Expense for assessment field&int')+'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
					oMBal:ChgBalance(SEXP, self:closingDate,0, AssFldInt, 0, AssFldInt,sCURR)
				endif
			endif
			if Empty(cError).and.!Empty(AssFldIntHome)
				nSeqnr++
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
				cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+samFld+',"'+Str(AssFldIntHome,-1)+'","'+Str(AssFldIntHome,-1)+'",0,0,"'+sCurr+;
					'","'+self:oLan:RGet('Expense for assessment field&int for home assigned members')+'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
				oMBal:ChgBalance(samFld, self:closingDate, AssFldIntHome, 0, AssFldIntHome,0,sCURR)
				if Empty(cError)
					nSeqnr++
					//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
					cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+SEXPHOME+',0,0,"'+Str(AssFldIntHome,-1)+'","'+Str(AssFldIntHome,-1)+'","'+sCurr+;
						'","'+self:oLan:RGet('Expense for assessment field&int for home assigned members')+'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
					oMBal:ChgBalance(SEXPHOME, self:closingDate,0, AssFldIntHome, 0, AssFldIntHome,sCURR)
				endif
			endif

			*Record total amount to PMC 
			IF Empty(cError).and.mo_tot # 0
				nSeqnr++
				if !self:cPMCCurr==sCurr .and. fExChRate>0
					mo_totF:=Round(mo_tot/fExChRate,DecAantal)
				endif
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,bfm,gc,userid,poststatus,transid,seqnr
				cTransStmnt+=iif(Empty(cTransStmnt),'',',')+'('+shb+',0,0,"'+Str(mo_tot,-1)+'","'+Str(mo_totF,-1)+'","'+self:cPMCCurr+;
					'","'+self:oLan:RGet('PMC Total')+'","'+SQLdate(self:closingDate)+'","H","","'+LOGON_EMP_ID+'",2,'+cTransnr+','+Str(nSeqnr,-1)+')'
				oMBal:ChgBalance(shb,	self:closingDate,	0,	mo_tot, 0, mo_totF,self:cPMCCurr)
			ENDIF
			if Empty(cError)
				oStmnt:=SQLStatement{"update sysparms set pmislstsnd=CURDATE(),exchrate='"+Str(fExChRate,-1)+"'",oConn}
				oStmnt:Execute()
				if !Empty(oStmnt:Status)
					cError:=self:oLan:WGet("could	no	update sysparms")+'	('+oStmnt:Status:description+')'
					LogEvent(self,cError+CRLF+"Statement:"+oStmnt:SQLString,"LogErrors")
				endif
			endif
		endif
		if Empty(cError)
			if !Empty(cTransStmnt)
				oStmnt:=SQLStatement{'insert into transaction (`accid`,`deb`,`debforgn`,`cre`,`creforgn`,`currency`,`description`,`dat`,`bfm`,`gc`,`userid`,'+;
					'`poststatus`,`transid`,`seqnr`) values '+cTransStmnt,oConn}
				oStmnt:Execute()
				if	oStmnt:NumSuccessfulRows<1
					cError:=self:oLan:WGet('Could	not record transactions for the members')+' ('+oStmnt:Status:description+')'
					LogEvent(self,cError+CRLF+"Statement:"+oStmnt:SQLString,"LogErrors")
				endif
			endif
		endif
		if Empty(cError)
			if !oMBal:ChgBalanceExecute()
				cError:=oMBal:cError
			endif
		endif 
		if Empty(cError) .and. !Empty(cBankStmnt)
			oStmnt:=SQLStatement{'insert into bankorder (`accntfrom`,`amount`,`description`,`banknbrcre`,`datedue`,`idfrom`) values '+cBankStmnt,oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				cError:=self:oLan:WGet("could	no	record bankorder for members")+' ('+oStmnt:Status:description+')'
				LogEvent(self,cError+CRLF+"Statement:"+oStmnt:SQLString,"LogErrors")
			ENDIF
		endif

		time0:=time1
// 		LogEvent(self,"recording PMC transactions:"+Str((time1:=Seconds())-time0,-1)+"sec","logtime") 
		self:STATUSMESSAGE(Space(80) )
		if Empty(cError)
			SQLStatement{"commit",oConn}:Execute()
			self:ResetLocks(MYEMPID)
		else
			SQLStatement{"rollback",oConn}:Execute()
			self:ResetLocks(MYEMPID)
			ErrorBox{self,cError+"; "+self:oLan:WGet("nothing recorded; withdraw file sent to PMC")}:Show() 
			return
		ENDIF
		// 		*save period:
		// 		IF empty(self:oSys:pmislstsnd) .or.self:oSys:PMISLSTSND<Today()-1000
		// 			noIES:=true
		// 		ENDIF

		if PMCUpload
			LogEvent(self,self:oLan:WGet("Uploaded file")+Space(1)+cFilename+Space(1)+self:oLan:WGet("via Insite to PMC")+'; '+self:oLan:WGet("total amount")+": "+Str(mo_totF,-1)+' USD ( '+Str(mo_tot,-1)+' '+sCurr+'); '+Str(batchcount-directcount,-1)+ Space(1)+self:oLan:WGet("transactions")+'; '+self:oLan:WGet('Exchange rate')+': 1 USD='+Str(fExChRate,-1,8)+sCURR )
		endif
		// sending by email:
		cPMISMail:=AllTrim(self:oSys:IESMAILACC)
		cPMISMail:=StrTran(cPMISMail,";"+AllTrim(self:oSys:OWNMAILACC))
		cPMISMail:=StrTran(cPMISMail,AllTrim(self:oSys:OWNMAILACC))
		* Send file by email:
		IF IsMAPIAvailable()
			* Resolve IESname
			IF oMapi:Open( "" , "" )
				oPers:=SqlSelect{"select persid,lastname,firstname,email,"+SQLFullName(3)+" as fullname from person where persid='"+Str(self:oSys:PMCMANCLN,-1)+"'",oConn} 
				if oPers:Reccount>0
					if PMCUpload
						oRecip := oMapi:ResolveName( oPers:lastname,oPers:persid,oPers:fullname,oPers:email)
					else
						oRecip2 := oMapi:ResolveName( oPers:lastname,oPers:persid,oPers:fullname,oPers:email)
					endif
				endif
				if !PMCUpload
					oRecip := oMapi:ResolveMailName( "Partner Monetary Interchange System",@cPMISMail,"Partner Monetary Interchange System")
				endif
				IF oRecip != null_object .and.(PMCUpload .or.!oRecip2==null_object)
					cNoteText:="Dear "+oPers:fullname+","+CRLF+;
						iif(PMCUpload,;
						self:oLan:RGet("Will you please approve the uploaded OPP file")+Space(1)+FileSpec{cFilename}:Filename+Space(1)+;
						self:oLan:RGet("by going to Insite")+Space(1)+"https://www.pmc.insitehome.org/OPPUpload.aspx";
						,;
						"I send you attached a OPP file and would be grateful if you would approve the file by means of a reply all.")+;
						CRLF+LOGON_EMP_ID
					IF oMapi:SendDocument( iif(PMCUpload,null_object,FileSpec{cFilename}) ,oRecip,oRecip2,"PMC Transactions "+FileSpec{cFilename}:Filename+" of "+sLand,cNoteText)
						(InfoBox{self:OWNER,"Partner Monetary Interchange System",;                                                                  
						self:oLan:WGet("Placed one mail message in the outbox of")+" "+EmailClient+" "+iif(PMCUpload,self:oLan:WGet("for approving of"),self:oLan:WGet("with attached the file"))+": "+cFilename}):Show()
						IF !PMCUpload
							LogEvent(self,self:oLan:WGet("Placed one PMC mail message in the outbox of")+" "+EmailClient+" "+self:oLan:WGet("with attached the file")+": "+cFilename,"Log")
						endi
						lSent:=true
					ENDIF
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
	SetDecimalSep(DecSep)

	if !PMCUpload .and.!lStop
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
	
Method ResetLocks(cEmpId as string) class PMISsend
	// reset software lock:
	local oTrans as SQLSelect
	local oStmnt as SQLStatement 
	self:STATUSMESSAGE(self:oLan:WGet('unlocking member transactions')+'...')

	SQLStatement{"start transaction",oConn}:Execute()    // te lock all transactions and distribution instructions read
	// select the transaction data
// 	oTrans:=SQLSelect{"select transid,seqnr from transaction t where concat(cast(transid as char),';',cast(seqnr as char)) in ("+cTransLock+") order by t.transid,seqnr for update",oConn}
// 	oTrans:Execute() 
// 	if Empty(oTrans:Status)
// 		oStmnt:=SQLStatement{"update transaction set lock_id=0 where concat(cast(transid as char),';',cast(seqnr as char)) in ("+cTransLock+")",oConn}
		oStmnt:=SQLStatement{"update transaction set lock_id=0,lock_time='0000-00-00' where lock_id="+MYEMPID,oConn}
		oStmnt:Execute()
		SQLStatement{"commit",oConn}:Execute()
// 	endif 
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
STATIC DEFINE PMISSEND_OKBUTTON := 100 