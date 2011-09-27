RESOURCE IPCReport DIALOGEX  4, 3, 278, 85
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Generate Report file for IPC projects to be imported into the International Project Center system", IPCREPORT_FIXEDTEXT1, "Static", WS_CHILD, 4, 7, 267, 25
	CONTROL	"Year:", IPCREPORT_FIXEDTEXT3, "Static", WS_CHILD, 14, 57, 28, 13
	CONTROL	"", IPCREPORT_PERIODYEAR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 46, 57, 32, 13, WS_EX_CLIENTEDGE
	CONTROL	"Month:", IPCREPORT_FIXEDTEXT2, "Static", WS_CHILD, 87, 58, 29, 12
	CONTROL	"", IPCREPORT_PERIODMONTH, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 115, 58, 31, 12, WS_EX_CLIENTEDGE
	CONTROL	"OK", IPCREPORT_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 210, 54, 54, 12
	CONTROL	"Report period", IPCREPORT_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 40, 159, 40
END

CLASS IPCReport INHERIT DataWindowMine 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCPeriodYear AS SINGLELINEEDIT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCPeriodMonth AS SINGLELINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCGroupBox2 AS GROUPBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS IPCReport 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"IPCReport",_GetInst()},iCtlID)

aFonts[1] := Font{,10,"Microsoft Sans Serif"}
aFonts[1]:Bold := TRUE

oDCFixedText1 := FixedText{SELF,ResourceID{IPCREPORT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Generate Report file for IPC projects to be imported into the International Project Center system",NULL_STRING,NULL_STRING}
oDCFixedText1:Font(aFonts[1], FALSE)

oDCFixedText3 := FixedText{SELF,ResourceID{IPCREPORT_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Year:",NULL_STRING,NULL_STRING}

oDCPeriodYear := SingleLineEdit{SELF,ResourceID{IPCREPORT_PERIODYEAR,_GetInst()}}
oDCPeriodYear:FieldSpec := YearW{}
oDCPeriodYear:Picture := "9999"
oDCPeriodYear:HyperLabel := HyperLabel{#PeriodYear,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{IPCREPORT_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Month:",NULL_STRING,NULL_STRING}

oDCPeriodMonth := SingleLineEdit{SELF,ResourceID{IPCREPORT_PERIODMONTH,_GetInst()}}
oDCPeriodMonth:FieldSpec := MonthW{}
oDCPeriodMonth:Picture := "99"
oDCPeriodMonth:HyperLabel := HyperLabel{#PeriodMonth,NULL_STRING,NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{IPCREPORT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{IPCREPORT_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Report period",NULL_STRING,NULL_STRING}

SELF:Caption := "IPC Report"
SELF:HyperLabel := HyperLabel{#IPCReport,"IPC Report",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS IPCReport 
	Local oDep as SQLSelect
	Local oAcc as SQLSelect
	Local oMBal as Balances
	Local aMIpc:={} as array
	local cError as string 
	local mxrate as float
	local oCurr as Currency
	local PeriodDate as date, Period as string
	Local CurProject, CurAccount as int, CurType as string
	Local CurAmount as float
	Local i as int  
	LOCAL ToFileFS as Filespec
	local cFilename as string 
	local ptrHandle
	local oReport as PrintDialog 
	local cHeading:={} as array 
	Local nRow, nPage as int

	// 	oDep:SetFilter({|!Empty(oDep:IPCPROJECT)})
	// 	oAcc:SetOrder("DEPRTMNT")
	// 	Extract all departments with an IPC project number and their corresponding income/expense accounts. 
	// If an account contains no IPC account, give error message.  
	oDep:=SqlSelect{"select d.ipcproject,a.ipcaccount,a.accid,a.currency,a.accnumber,a.description,b.category as type from account a, department d, balanceitem b "+;
		"where d.ipcproject>0 and d.depid=a.department and b.balitemid=a.balitemid and (b.category='"+INCOME+"' or b.category='"+EXPENSE+"') order by ipcproject,ipcaccount", oConn}
	oDep:Execute() 
	oMBal:=Balances{}
	do while !oDep:EoF
		if Empty(oDep:IPCACCOUNT)
			cError+=oDep:ACCNUMBER+" ("+AllTrim(oDep:Description)+")"+CRLF
		else
			// For each account determine transaction balance in required period
			oMBal:GetBalance(Str(oDep:accid,-1),self:PeriodYear*100+self:PeriodMonth,self:PeriodYear*100+self:PeriodMonth,oDep:Currency)
			AAdd(aMIpc,{oDep:IPCPROJECT,oDep:IPCACCOUNT,iif(oDep:TYPE=INCOME,"R","E"),Round(iif(oDep:TYPE=INCOME,oMBal:per_cre-oMBal:per_deb,oMBal:per_deb-oMBal:per_cre),2)})
		endif
		oDep:Skip()
	enddo
	if !Empty(cError)
		ErrorBox{,self:oLan:WGet("The following accounts have an empty IPC account)")+":"+CRLF+cError}:Show()
	elseif Len(aMIpc)=0
		WarningBox{,self:oLan:WGet("IPC Report"),self:oLan:WGet("Nothing to send")}:Show()
	else
		// Sort this spreadsheet on IPC project#, account#
		// 		aMIpc:=ASort(aMIpc,,,{|x,y|x[1] <y[1] .or.(x[1]=y[1].and. x[2] <= y[2])})

		// Ask for exchange rate from local currency to USD per end of report peri
		oCurr:=Currency{self:oLan:WGet("IPC report")} 
		Period:=str(self:PeriodYear,-1)+strzero(self:PeriodMonth,2)
		PeriodDate:=SToD(Period+StrZero(MonthEnd(self:PeriodMonth,self:PeriodYear),2)) 
		mxrate:=oCurr:GetROE("USD",PeriodDate,true)
		if !oCurr:lStopped
			/* •	Sum balances of all lines with same IPC project# and IPC account#, convert amount to USD and export a line to the report file IPCyyyymm.csv(comma separated): 
			o	IPC project# 99999, 
			o	period: yymm, 
			o	type: E/R, 
			o	amount: -999999.99, 
			o	IPC account#: 9999999 

			*/
			oReport := PrintDialog{self,self:oLan:WGet("IPC Report"),,50}
			oReport:Show()
			IF .not.oReport:lPrintOk
				RETURN FALSE
			endif
			cHeading:={self:oLan:RGet("IPC Report")+" "+self:oLan:RGet("period")+" "+Str(self:PeriodYear,-1)+" - "+Str(self:PeriodMonth,-1),self:oLan:RGet("IPCproject",10)+Space(1)+self:oLan:RGet("IPCAccount",10)+Space(1)+;
				self:oLan:RGet("Type",5)+Space(1)+self:oLan:RGet("Amount",10,,"R")} 
			ToFileFS:=AskFileName(self,"IPC"+Period,self:oLan:WGet("Generating")+" "+self:oLan:WGet("IPC report"),"*.csv","comma separated file")
			if Empty(ToFileFS)
				return
			endif
			cFilename:=ToFileFS:FullPath
			ptrHandle:=MakeFile(,@cFilename,self:oLan:WGet("Generating")+" "+self:oLan:WGet("IPC report"))

			Period:=SubStr(Period,3)
			for i:=1 to Len(aMIpc)
				if !aMIpc[i,1]==CurProject .or. !aMIpc[i,2]==CurAccount
					// new account:
					if !Empty(CurProject) // not first time
						FWriteLine(ptrHandle,'"'+Str(CurProject,-1)+'","'+Period+'","'+CurType+'","'+Str(CurAmount,10,2)+'","'+Str(CurAccount,-1)+'"') 
						oReport:PrintLine(@nRow,@nPage,Str(CurProject,10,0)+Space(1)+Str(CurAccount,10,0)+Space(1)+PadC(CurType,5)+Space(1)+Str(CurAmount,10,2),cHeading)
					endif
					CurAmount:=0
					CurProject:=aMIpc[i,1]
					CurAccount:=aMIpc[i,2]
					CurType:=aMIpc[i,3]
				endif
				CurAmount:=Round(CurAmount+aMIpc[i,4],2)
			next 
			// for last line:
			FWriteLine(ptrHandle,'"'+Str(CurProject,-1)+'","'+Period+'","'+CurType+'","'+Str(CurAmount,10,2)+'","'+Str(CurAccount,-1)+'"') 
			oReport:PrintLine(@nRow,@nPage,Str(CurProject,10,0)+Space(1)+Str(CurAccount,10,0)+Space(1)+PadC(CurType,5)+Space(1)+Str(CurAmount,10,2),cHeading)
			FClose(ptrHandle)
			oReport:prstart(false)
			oReport:prstop()
			// •	Let user confirm report is OK; if not: remove report file
			if (TextBox{self,self:oLan:WGet("IPC Report"),;
					self:oLan:WGet('Printing O.K.? Can shown IPC Report be imported into IPC?'),BOXICONQUESTIONMARK + BUTTONYESNO}):Show() = BOXREPLYNO
				// remove file:
				if !ToFileFS:DELETE()
					FErase(ToFileFS:FullPath)
				endif
				return
			endif
		endif
	endif
	self:EndWindow()
	RETURN nil
ACCESS PeriodMonth() CLASS IPCReport
RETURN SELF:FieldGet(#PeriodMonth)

ASSIGN PeriodMonth(uValue) CLASS IPCReport
SELF:FieldPut(#PeriodMonth, uValue)
RETURN uValue

ACCESS PeriodYear() CLASS IPCReport
RETURN SELF:FieldGet(#PeriodYear)

ASSIGN PeriodYear(uValue) CLASS IPCReport
SELF:FieldPut(#PeriodYear, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class IPCReport
	//Put your PostInit additions here  
	self:SetTexts()
	self:PeriodYear:=Year(Today()-27)
	self:PeriodMonth:=Month(Today()-27)
	return NIL
STATIC DEFINE IPCREPORT_FIXEDTEXT1 := 100 
STATIC DEFINE IPCREPORT_FIXEDTEXT2 := 103 
STATIC DEFINE IPCREPORT_FIXEDTEXT3 := 101 
STATIC DEFINE IPCREPORT_GROUPBOX2 := 106 
STATIC DEFINE IPCREPORT_OKBUTTON := 105 
STATIC DEFINE IPCREPORT_PERIODMONTH := 104 
STATIC DEFINE IPCREPORT_PERIODYEAR := 102 
