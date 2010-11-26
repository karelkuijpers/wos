CLASS AreaReport INHERIT DataWindowExtra 

	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCBalanceText AS FIXEDTEXT
	PROTECT oDCAfsldagtext AS FIXEDTEXT
	PROTECT oDCAfsldag AS DATESTANDARD

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)  
//   	instance Afsldag 
  	PROTECT oAcc as Account
  	PROTECT oTrans as Transaction
  	PROTECT oSys as Sysparms
  	PROTECT oMbr as Members
  	PROTECT oMBal as MBalance
  	PROTECT BalYear, BalMonth, regeltel as int
	PROTECT BalMonthStart, BalMonthEnd as date
	PROTECT closingDate as date

	PROTECT me_hbn, me_oms, sLand, sMunt, sMuntNaam, rmaand as STRING
	EXPORT oReport as PrintDialog
	EXPORT Rij, Blad as int
	EXPORT scheiding as STRING
	EXPORT kopregels as ARRAY
	EXPORT sAssmntOffc as FLOAT
	EXPORT sAssmntField as FLOAT
	EXPORT mxrate as FLOAT
resource AreaReport DIALOGEX  4, 3, 306, 81
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"OK", AREAREPORT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 240, 18, 54, 12
	CONTROL	"Cancel", AREAREPORT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 240, 35, 53, 12
	CONTROL	"", AREAREPORT_BALANCETEXT, "Static", WS_CHILD, 12, 19, 221, 29
	CONTROL	"Up to day:", AREAREPORT_AFSLDAGTEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 24, 55, 38, 13
	CONTROL	"vrijdag 22 januari 2010", AREAREPORT_AFSLDAG, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 64, 55, 118, 13
END

ACCESS Afsldag() CLASS AreaReport
RETURN SELF:FieldGet(#Afsldag)

ASSIGN Afsldag(uValue) CLASS AreaReport
SELF:FieldPut(#Afsldag, uValue)
RETURN uValue

METHOD CancelButton( ) CLASS AreaReport
	self:EndWindow()
	RETURN true
METHOD Close(oEvent) CLASS AreaReport
	SUPER:Close(oEvent)
	//Put your changes here
IF !oAcc==null_object
	IF oAcc:Used
		oAcc:Close()
	ENDIF
	oAcc:=null_object
ENDIF
IF !oTrans==null_object
	IF oTrans:Used
		oTrans:Close()
	ENDIF
	oTrans:=null_object
ENDIF
IF !oSys==null_object
	IF oSys:Used
		oSys:Close()
	ENDIF
	oSys:=null_object
ENDIF
IF !oMbr==null_object
	IF oMbr:Used
		oMbr:Close()
	ENDIF
	oMbr:=null_object
ENDIF
IF !oMBal==null_object
	IF oMBal:Used
		oMBal:Close()
	ENDIF
	oMBal:=null_object
ENDIF

	self:Destroy()
	RETURN
Method ExportReport() class AreaReport
	// export all transactions to spreadsheet
	// If correct, mark them as sent 
	local oMyTrans:=self:oTrans as Transaction
	Local CloseDay:=self:oDCAfsldag:SelectedDate as date 
	local cFileName1, cFileName2 as string 
	LOCAL cDelim:="," as STRING   // for US
	LOCAL DecSep as int
	LOCAL cTransnr as STRING
	LOCAL oWarn as WarningBox
	LOCAL ToFileFS as FileSpec
	LOCAL ptrHandle
	LOCAL cLine as STRING
	local oCurr as Currency 
	LOCAL oExch as GetExchRate
	Local fXRate,fUSDRate as float, nRptr, CurRec as int, Curname, CurTrans as string 
	Local aXRate:={} as array // array with exchange rates at closing date 
	local fTransAmnt, fCurAmnt as float
	local cFisYr, cFiscper,cSRCETYPE as string 
	local oPP as PPCodes
	local lSkip, lXls,lUSD as logic
	local d_netasset:={} as array
	local cRef as string
	local oDep as Department 
	LOCAL oReport as PrintDialog
	LOCAL nRow, nPage, i, nCurRec,nMem, nWidth:=101 as int, cDesc, cTab:=Space(1) as STRING
	local aHeaders as array 
	local cDateFormat as string
	
	oMyTrans:Clearfilter()
	oMyTrans:setOrder("TRANSNR")
// 	oMyTrans:SetFilter({||!oMyTrans:BFM=="C".and. oMyTrans:DAT<=CloseDay .and.!oMyTrans:FROMRPP},"!BFM=='C'.and.!FromRPP.and.dtos(DAT)<'"+DToS(CloseDay)+"'")
	oMyTrans:SetFilter(,"!BFM=='C'.and.!FromRPP.and.dtos(DAT)<='"+DToS(CloseDay)+"'") 
	oMyTrans:gotop()
	if oMyTrans:EoF
		(WarningBox{self,olan:WGet("Exporting to Accpac"),oLan:WGet("Nothing to be sent")}):Show()
		return false
	endif 
	IF Empty(SKAP)
		(ErrorBox{self:OWNER,self:olan:WGet('Account for net assets not specified in system data')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF
	if oAcc==null_object
		oAcc:=Account{,DBSHARED,DBREADONLY}
	endif
	oAcc:setOrder("accid")
	oAcc:Seek(SKAP)
	IF !oAcc:FOUND
		(ErrorBox{self:OWNER,self:olan:WGet('Account for net assets not found')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF

	oDep:=Department{}
	IF !oDep:Used
		self:EndWindow()
		RETURN
	ENDIF 
	d_netasset:={SKAP}

	DO WHILE !oDep:EoF
		if !Empty(oDep:NETASSET)
			AAdd(d_netasset,oDep:NETASSET)
		endif
		oDep:Skip()
	enddo
	oDep:Close()
	oCurr:=Currency{self:oLan:WGet("Exporting to AccPac"),"USD"} 
	if sCurr=="USD"
		fXRate:=1
	else
		fXRate:=oCurr:GetROE(sCurr, CloseDay,true) 
		if oCurr:lStopped
			return false
		endif
	endif
	DecSep:=SetDecimalSep()    // save decimal seprator 
	if Month(CloseDay)>9
		cFisYr:=Str(Year(CloseDay)+1,4,0)
		cFiscper:=Str(Month(CloseDay)-9,-1)
	else
		cFisYr:=Str(Year(CloseDay),4,0)
		cFiscper:=Str(Month(CloseDay)+3,-1)
	endif
	cSRCETYPE:=SubStr(SEntity,2,2)
	aXRate:={{sCurr,fXRate}}
	// generate header file:
	cFileName1 := "Journal_Headers"
	ToFileFS:=AskFileName(self,cFileName1,olan:WGet("Exporting Journal_Header to Accpac"),"*.csv","comma separated file")
	if Empty(ToFileFS)
		return false
	endif
	ToFileFS:FileName:=cFileName1
	cFileName1:=ToFileFS:FullPath
	ptrHandle:=MakeFile(self,cFileName1,olan:WGet("Exporting Journal_Header to Accpac"))
	IF !ptrHandle = F_ERROR .and. !ptrHandle==nil
		* Write heading TO file:
		FWriteLine(ptrHandle,'"BATCHID"'+cDelim+'"BTCHENTRY"'+cDelim+'"SRCELEDGER"'+cDelim+'"SRCETYPE"'+cDelim+'"FSCSYR"'+cDelim+'"FSCSPERD"'+cDelim+;
			'"JRNLDESC"')
		oPP:=PPCodes{,DBSHARED,DBREADONLY}
		oPP:setOrder("PPCODE")
		oPP:Seek(SEntity) 
		FWriteLine(ptrHandle,'"000000"'+cDelim+'"00001"'+cDelim+'"GL"'+cDelim+'"'+cSRCETYPE+'"'+cDelim+'"'+cFisYr+'"'+cDelim+'"'+cFiscper+'"'+cDelim+;
			'"'+AllTrim(oPP:PPNAME)+" "+maand[Month(CloseDay)]+'"') 
		FClose(ptrHandle)
	else
		return false
	endif

	ToFileFS:FileName:="Journal_Details"

	cFileName2:=ToFileFS:FullPath

	ptrHandle:=MakeFile(self,cFileName2,olan:WGet("Exporting Journal_Details to Accpac"))
	IF !ptrHandle = F_ERROR .and. !ptrHandle==nil
		* Write heading TO file: 
		oReport := PrintDialog{self,olan:RGet("Exporting Transactions to Accpac")+"-"+DToC(CloseDay),,nWidth,DMORIENT_LANDSCAPE,"xls"}
		oReport:Show()
		IF .not.oReport:lPrintOk 
			FClose(ptrHandle)
			RETURN FALSE
		ENDIF
		if Lower(oReport:Extension)=="xls"
			cTab:=CHR(9) 
			lXls:=true
		endif
		aHeaders:={self:olan:RGet("Export of financial transaction to AccPac")+Space(3)+DToC(CloseDay),;
			olan:RGet("Account",30)+cTab+olan:RGet("Date",10)+cTab+olan:RGet("Reference",15)+cTab+olan:RGet("Description",30)+cTab+PadL(olan:RGet("Amount")+"-USD",12)}
		SetDecimalSep(Asc("."))    // for US
		if lXls
			ADel(aHeaders,1)
			asize(aHeaders,len(aHeaders)-1)
		else
			AAdd(aHeaders,Replicate('_',nWidth))
		endif
		FWriteLine(ptrHandle,'"BATCHNBR"'+cDelim+'"JOURNALID"'+cDelim+'"TRANSNBR"'+cDelim+'"ACCTID"'+cDelim+'"TRANSAMT"'+cDelim+'"SCURNAMT"'+cDelim+;
			'"SCURNCODE"'+cDelim+'"TRANSDESC"'+cDelim+'"TRANSREF"'+cDelim+'"TRANSDATE"'+cDelim+'"SRCETYPE"')
		cDateFormat:=GetDateFormat()
		SetDateFormat("MM/DD/YY")
		do while !oMyTrans:EoF
			lSkip:=false
			if CurTrans # oMyTrans:TransId
				// new transaction:
				CurTrans := oMyTrans:TransId
				CurRec := oMyTrans:RecNo
				lUSD:=false
				do while !oMyTrans:EOF .and. oMyTrans:TransId==CurTrans
					if AScan(d_netasset,oMyTrans:accid)>0
						lSkip:=true											
					endif
					if oMyTrans:Currency="USD" 
						fUSDrate:= Round(oMyTrans:DEBFORGN - oMyTrans:CREFORGN,2)/Round(oMyTrans:DEB - oMyTrans:CRE,2) 
						lUSD:=true
						exit
					endif
					oMyTrans:Skip()
				enddo
				if !lSkip
					oMyTrans:GoTo(CurRec)
				endif
			endif
			if !lSkip
				oAcc:seek(oMyTrans:accid)
				fCurAmnt:= Round(oMyTrans:DEB - oMyTrans:CRE,2)
				if oMyTrans:Currency="USD"
					fTransAmnt:=Round(oMyTrans:DEBFORGN - oMyTrans:CREFORGN,2)					 
				elseif lUSD 
					fTransAmnt:=Round(fCurAmnt*fUSDrate,2)
				else
					fTransAmnt:=Round(fCurAmnt*fXRate,2)
				endif
				cRef:=AllTrim(oMyTrans:REFERENCE)
				if oMyTrans:accid== sToPP
					cRef:=AllTrim(oMyTrans:PPDEST+" "+AllTrim(oMyTrans:REFERENCE))
				endif
				if Empty(cRef)
					cRef:=AllTrim(oMyTrans:DOCID)
				endif
				cLine:='"000000"'+cDelim+'"00001"'+cDelim+'"0000000000"'+cDelim+'"'+AllTrim(oAcc:accnumber)+'"'+cDelim+;
					'"'+Str(fTransAmnt,-1)+'"'+cDelim+'"'+Str(fCurAmnt,-1)+'"'+cDelim+'"'+sCurr+'"'+cDelim+'"'+;
					AllTrim(oMyTrans:description)+'"'+cDelim+'"'+cRef+'"'+cDelim+'"'+DToS(oMyTrans:DAT)+'"'+cDelim+'"'+cSRCETYPE+'"'
				FWriteLine(ptrHandle,cLine) 
				oReport:PrintLine(@nRow,@nPage,;
					Pad(AllTrim(oAcc:accnumber)+Space(1)+AllTrim(oAcc:description),30)+cTab+DToC(oMyTrans:DAT)+cTab+Pad(cRef,15)+cTab+;
					iif(lXls,oMyTrans:description,MemoLine(oMyTrans:description,30,1))+cTab+Str(fTransAmnt,12,2);
					,aHeaders)
				if !lXls
					nMem:=2
					DO WHILE !Empty(cDesc:=MemoLine(oMyTrans:description,30,nMem))
						oReport:PrintLine(@nRow,@nPage,Space(30)+cTab+Space(8)+cTab+Space(15)+cTab+cDesc,aHeaders)
						nMem++
					ENDDO
				endif

				oMyTrans:Skip()
			endif
		enddo
		SetDateFormat(cDateFormat)

		FClose(ptrHandle)
		SetDecimalSep(DecSep)
		oReport:prstart()
		oReport:prstop()
		
		
		if ((TextBox{self,"Export of transactions",;
				"Generated two files:"+cFileName1+", "+cFileName2+';'+CRLF+ 'is it O.K. and can transactions be marked as sent(this is irrevocable)?',;
				BOXICONQUESTIONMARK + BUTTONYESNO}):Show()) == BOXREPLYYES
			oMyTrans:gotop()
			do while !oMyTrans:EoF
				oMyTrans:RecLock()
				oMyTrans:BFM:="C"
				oMyTrans:Skip()
			enddo
			oMyTrans:Unlock()
			oMyTrans:Commit()
			oSys:RecLock()
			oSys:ACCPACLS:=CloseDay
			if CloseDay >= BalMonthEnd .and. Today() > BalMonthEnd  
				oSys:LstReportMonth :=Val(SubStr(DToS(BalMonthEnd),1,6)) 
				oSys:MINDATE:=BalMonthEnd+1 
				MINDATE:=oSys:MINDATE
			endif 
			oSys:Commit()
			oSys:Unlock()

		endif		
	else 
		
		return false
	endif
	return true
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS AreaReport 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"AreaReport",_GetInst()},iCtlID)

oCCOKButton := PushButton{SELF,ResourceID{AREAREPORT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{AREAREPORT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCBalanceText := FixedText{SELF,ResourceID{AREAREPORT_BALANCETEXT,_GetInst()}}
oDCBalanceText:HyperLabel := HyperLabel{#BalanceText,NULL_STRING,NULL_STRING,NULL_STRING}

oDCAfsldagtext := FixedText{SELF,ResourceID{AREAREPORT_AFSLDAGTEXT,_GetInst()}}
oDCAfsldagtext:HyperLabel := HyperLabel{#Afsldagtext,"Up to day:",NULL_STRING,NULL_STRING}

oDCAfsldag := DateStandard{SELF,ResourceID{AREAREPORT_AFSLDAG,_GetInst()}}
oDCAfsldag:FieldSpec := Subscription_P04{}
oDCAfsldag:HyperLabel := HyperLabel{#Afsldag,NULL_STRING,"Transactions up to this date will be send",NULL_STRING}
oDCAfsldag:UseHLforToolTip := True

SELF:Caption := "Sending transactions to AccPac"
SELF:HyperLabel := HyperLabel{#AreaReport,"Sending transactions to AccPac",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS AreaReport
LOCAL oWarn as warningbox, lSuc as LOGIC
self:STATUSMESSAGE("Checking data, please wait...")
* check if there are non earmarked gifts:
lSuc:=oTrans:setOrder("balitemid")  // accid+dat+bfm


if self:ExportReport()
	self:EndWindow()
endif
RETURN 
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS AreaReport
	//Put your PostInit additions here
// LOCAL maand := ;
// {'January','February','March','April','May','June','July','August',;
// 'September','October','November','December'} as ARRAY
	self:SetTexts()
oSys := Sysparms{}
IF !oSys:Used
	self:ENDWindow()
ENDIF

oSys:BepaalAf()
rmaand:=maand[Month(oSys:maandultimo)]
BalYear := oSys:rJaar
BalMonth := oSys:rMnd
BalMonthStart := oSys:MaandBegin
BalMonthEnd := 	oSys:maandultimo

sland := oSys:CountryOwn
sMunt := oSys:Currency
sMuntNaam := oSys:Currname
mxrate := oSys:EXCHRATE
oDCAfsldag:DateRange:=DateRange{Today()-365,Today()}

if Today() > BalMonthEnd
	self:closingDate := BalMonthEnd
	self:oDCBalanceText:TextValue :='Processing of '+maand[BalMonth]+' '+Str(BalYear,4)
else
	self:closingDate := Today() 
	self:oDCBalanceText:TextValue :='Sending of transactions to AccPac. Last send on: '+DToC(oSys:ACCPACLS)
endif
oDCAfsldag:SelectedDate:=self:closingDate
// IF Today() <= BalMonthEnd
// 	IF Today() < BalMonthStart
// 		(ErrorBox{self:Owner,maand[Month(Today())]+' already closed'}):show()
//        self:CancelButton()
// 	ELSE
// 		(errorbox{self,maand[Month(BalMonthEnd)]+' is still current month'}):show()
//        self:CancelButton()
//    ENDIF
// // ELSE
// // 	self:Afsldag:=Day(closingDate)
// ENDIF
* Transacties exclusief nemen:
oTrans := Transaction{}
IF !oTrans:Used
	self:ENDWindow()
ENDIF
oAcc := Account{}
IF !oAcc:Used
	self:ENDWindow()
ENDIF

RETURN nil
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
RESOURCE AskUpld DIALOGEX  4, 3, 265, 86
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"&No", ASKUPLD_CANCELBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 132, 70, 53, 13
	CONTROL	"&Yes", ASKUPLD_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 192, 70, 53, 12
	CONTROL	"Has file with transactions successfully been uploaded into Insite?", ASKUPLD_TEXTQESTION, "Static", WS_CHILD, 4, 7, 244, 29
	CONTROL	"(this is IRREVOCABLE)", ASKUPLD_FIXEDTEXT2, "Static", WS_CHILD, 4, 40, 236, 12
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
oDCTextQestion:HyperLabel := HyperLabel{#TextQestion,"Has file with transactions successfully been uploaded into Insite?",NULL_STRING,NULL_STRING}
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
RESOURCE IESReport DIALOGEX  9, 8, 279, 143
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", IESREPORT_AFSLDAG, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 64, 66, 32, 12, WS_EX_CLIENTEDGE
	CONTROL	"OK", IESREPORT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 192, 14, 53, 13
	CONTROL	"Cancel", IESREPORT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 192, 33, 54, 13
	CONTROL	"", IESREPORT_BALANCETEXT, "Static", WS_CHILD, 12, 19, 166, 29
	CONTROL	"Up to day:", IESREPORT_AFSLDAGTEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 23, 67, 39, 13
END

CLASS IESReport INHERIT DataWindowMine 

	PROTECT oDCAfsldag AS SINGLELINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCBalanceText AS FIXEDTEXT
	PROTECT oDCAfsldagtext AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)

	instance Afsldag 
  	PROTECT oAcc as Account
  	PROTECT oTrans AS Transaction
  	PROTECT oSys AS Sysparms
  	PROTECT oMbr AS Members
  	PROTECT oMBal as MBalance
  	PROTECT BalYear, BalMonth, regeltel AS INT
	PROTECT BalMonthStart, BalMonthEnd AS DATE
	PROTECT closingDate as date

	PROTECT me_hbn, me_oms, SLand, SMunt, sMuntNaam, rmaand AS STRING
	EXPORT oReport AS PrintDialog
	EXPORT Rij, Blad AS INT
	EXPORT scheiding AS STRING
	EXPORT kopregels AS ARRAY
	EXPORT sAssmntOffc as FLOAT
	EXPORT sAssmntField as FLOAT
	EXPORT mxrate AS FLOAT
ACCESS Afsldag() CLASS IESReport
RETURN SELF:FieldGet(#Afsldag)

ASSIGN Afsldag(uValue) CLASS IESReport
SELF:FieldPut(#Afsldag, uValue)
RETURN uValue

METHOD CancelButton( ) CLASS IESReport
	SELF:EndWindow()
	RETURN TRUE
METHOD Close(oEvent) CLASS IESReport
	SUPER:Close(oEvent)
	//Put your changes here
IF !oAcc==NULL_OBJECT
	IF oAcc:Used
		oAcc:Close()
	ENDIF
	oAcc:=NULL_OBJECT
ENDIF
IF !oTrans==NULL_OBJECT
	IF oTrans:used
		oTrans:Close()
	ENDIF
	oTrans:=NULL_OBJECT
ENDIF
IF !oSys==NULL_OBJECT
	IF oSys:Used
		oSys:Close()
	ENDIF
	oSys:=NULL_OBJECT
ENDIF
IF !oMbr==NULL_OBJECT
	IF oMbr:Used
		oMbr:Close()
	ENDIF
	oMbr:=NULL_OBJECT
ENDIF
IF !oMBal==NULL_OBJECT
	IF oMBal:Used
		oMBal:Close()
	ENDIF
	oMBal:=NULL_OBJECT
ENDIF

	SELF:Destroy()
	RETURN
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS IESReport 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"IESReport",_GetInst()},iCtlID)

oDCAfsldag := SingleLineEdit{SELF,ResourceID{IESREPORT_AFSLDAG,_GetInst()}}
oDCAfsldag:HyperLabel := HyperLabel{#Afsldag,NULL_STRING,NULL_STRING,NULL_STRING}
oDCAfsldag:TooltipText := "Up to which day in this month gifts have to be reported"
oDCAfsldag:Picture := "99"

oCCOKButton := PushButton{SELF,ResourceID{IESREPORT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{IESREPORT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCBalanceText := FixedText{SELF,ResourceID{IESREPORT_BALANCETEXT,_GetInst()}}
oDCBalanceText:HyperLabel := HyperLabel{#BalanceText,NULL_STRING,NULL_STRING,NULL_STRING}

oDCAfsldagtext := FixedText{SELF,ResourceID{IESREPORT_AFSLDAGTEXT,_GetInst()}}
oDCAfsldagtext:HyperLabel := HyperLabel{#Afsldagtext,"Up to day:",NULL_STRING,NULL_STRING}

SELF:Caption := "International Exchange report"
SELF:HyperLabel := HyperLabel{#IESReport,"International Exchange report",NULL_STRING,NULL_STRING}
SELF:EnableStatusBar(True)

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS IESReport
LOCAL oWarn AS warningbox, lSuc AS LOGIC
*IF Afsldag <12 .or. Afsldag > BalMonthEnd
IF Afsldag <1 .or. Afsldag > BalMonthEnd
   (errorbox{SELF:Owner,'Illegal day in month'}):Show()
   RETURN
ENDIF
	
IF Today() < BalMonthEnd
	self:closingDate := SToD(Str(Year(Today()),4)+StrZero(Month(Today()),2)+StrZero(Val(AllTrim(oDCAfsldag:TEXTvalue)),2))
ENDIF
SELF:Statusmessage("Checking data, please wait...")
* check if there are non earmarked gifts:
lSuc:=oTrans:setOrder("balitemid")  // accid+dat+bfm 
oTrans:Clearfilter()
lSuc:=oTrans:setfilter(,'BFM=="O"')
lSuc:=oTrans:seek(sproj)
IF !oTrans:EOF .and. oTrans:dat <= self:closingDate
	oWarn := WarningBox{SELF:Owner,"Interantional Exchange Report",;
   'Do you wish to allot non-designated gifts first'}
	oWarn:Type := BOXICONQUESTIONMARK + BUTTONYESNO
	IF (oWarn:Show() = BOXREPLYYES)
		SELF:EndWindow()
		RETURN TRUE
	ENDIF
ENDIF
oTrans:Clearfilter()

IF Empty(sam).or. Empty(shb)
   (errorbox{SELF:Owner,'Add first account for IE/AM result to system data'}):Show()
   SELF:EndWindow()
   RETURN TRUE
ENDIF

* Controleren of rekeningen hb en am al bestaan:
oAcc:setOrder("accid")
oAcc:Seek(shb)
IF oAcc:EOF
   (errorbox{SELF:OWNER,'Add first account for IE-result'}):Show()
   SELF:EndWindow()
   RETURN TRUE
ENDIF

*Verzamelpost AM
oAcc:seek(sam)
IF oAcc:EOF
   (errorbox{SELF:OWNER,'Add first account for AssessMents'}):Show()
   SELF:EndWindow()
   RETURN TRUE
ENDIF

SELF:PrintReport()
*SELF:EndWindow()
RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS IESReport
	//Put your PostInit additions here
LOCAL maand := ;
{'January','February','March','April','May','June','July','August',;
'September','October','November','December'} AS ARRAY
	self:SetTexts()
oSys := Sysparms{}
IF !oSys:Used
	SELF:ENDWindow()
ENDIF

oSys:BepaalAf()
rmaand:=maand[Month(oSys:maandultimo)]
BalYear := oSys:rJaar
BalMonth := oSys:rMnd
BalMonthStart := oSys:MaandBegin
BalMonthEnd := 	oSys:MaandUltimo
sAssmntField := oSys:assmntfield
sAssmntOffc := oSys:assmntOffc
sland := oSys:CountryOwn
sMunt := oSys:Currency
sMuntNaam := oSys:Currname
mxrate := oSys:EXCHRATE
self:closingDate := BalMonthEnd
SELF:oDCBalanceText:TextValue :='Processing of '+maand[BalMonth]+' '+Str(BalYear,4)
IF Today() < BalMonthEnd
	IF Today() < BalMonthStart
		(errorbox{SELF:Owner,maand[Month(Today())]+' already closed'}):show()
       SELF:CancelButton()
*	ELSEIF (BalMonthEnd - Today()) > 15
*		(errorbox{SELF,maand[Month(BalMonthEnd)]+' just started'}):show()
*       SELF:CancelButton()
	ELSE
		oDCAfsldag:value :=Day(Today())
		oDCAfsldag:Show()
		oDCAfsldagtext:Show()
   ENDIF
ELSE
	Afsldag:=Day(self:closingDate)
ENDIF
* Transacties exclusief nemen:
oTrans := Transaction{}
IF !oTrans:Used
	SELF:ENDWindow()
ENDIF
oAcc := Account{}
IF !oAcc:Used
	SELF:ENDWindow()
ENDIF

RETURN NIL
METHOD pr_medew (p_co,p_acc,p_bed1,p_bed2,p_bed3,p_bed4,aIE,rij,blad) CLASS IESReport
oReport:PrintLine(@rij,@blad,;
Pad(p_co+Space(3)+p_acc,12)+SubStr(me_hbn,1,8) + SubStr(me_oms,1,19)+;
Getal_inv(p_bed1,11)+Getal_inv(p_bed2,11)+Getal_inv(p_bed3,11)+;
Getal_inv(p_bed4,11),kopregels,3-regeltel)
regeltel:=if(regeltel=2,0,regeltel+1)
IF regeltel = 0
   oReport:PrintLine(@rij,@blad,scheiding,kopregels)
ENDIF
* Vul array voor aanmaak te verzenden data-file:
AAdd(aIE,p_co + if(!Empty(p_acc),p_acc,'00000') + Pad(me_hbn,6) + Pad(me_oms,28)+;
Getal_invf(p_bed1,10,2) + Getal_invf(p_bed2,10,2) +;
Getal_invf(p_bed3,10,2) + Getal_invf(p_bed4,10,2))

RETURN
METHOD PrintReport() CLASS IESReport
	LOCAL m4p,m5p,m4pm,hbdeb,me_hhb,me_saldo,amdeb AS FLOAT
	LOCAL aMember:={}, aIE:={} AS ARRAY
	LOCAL i, a_tel, aant_rek AS INT
	LOCAL mo_tot, AmountDue, tot1, tot2, tot3, tot4 AS FLOAT
	LOCAL bedn0,bedn1,bedn2,bedn3,bedn4,mutdeb,mutcre AS FLOAT
	LOCAL rekhas,rekmit,rekmbr AS FLOAT
*	LOCAL oWarn AS WarningBox
	LOCAL oWarn AS TextBox
	LOCAL me_has, rek_sel AS LOGIC
	LOCAL me_rek, me_gc,  me_stat, me_co, me_num AS STRING
	LOCAL cTransnr AS STRING
	LOCAL ptrHandle
	LOCAL cFilename, cFileNameConf AS STRING
	LOCAL AmountDueTxt AS STRING
	LOCAL oExch AS GetExchRate
	LOCAL aIESLock:={} AS ARRAY
	LOCAL DecSep AS STRING
*	LOCAL oMail AS SendEMail
	LOCAL oMapi AS MAPISession
	LOCAL oRecip,oRecip2 AS MAPIRecip
	LOCAL cIESMail AS STRING
	LOCAL lSent AS LOGIC
	LOCAL uRet AS USUAL
	LOCAL oWindow AS OBJECT
	LOCAL lSuc as LOGIC 
	Local rij:=self:rij,blad:=self:blad as int

oWindow:=GetParentWindow(SELF)
oReport := PrintDialog{oWindow,"International Exchange Report",,88}
oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
SELF:Statusmessage("Collecting data for report, please wait...")
SELF:Pointer := Pointer{POINTERHOURGLASS}

store 0 TO m4p,m5p,m4pm,hbdeb
*lijst maken van Medewerkers en eindemaandstanden van alle rekeningen invullen
* Controleer of rekeningnummers voor hoofdkantoor HB en inhoudingen gedefi-
* nieerd zijn:
* array's definieren voor hb en saldo:

oMbr := Members{}
IF !oMbr:Used
	SELF:ENDWindow()
ENDIF

oMbr:SetOrder("MBRREK")

oMBal := MBalance{}
IF !oMBal:Used
	SELF:ENDWindow()
ENDIF
oTrans:ClearFilter()
lSuc:=oTrans:setfilter("empty(BFM)")
oTrans:setOrder("balitemid")

scheiding:= '---------------------------------------|-----------|-----------|-----------|-----------|'
rij:=0
blad:=0
oMbr:setfilter("!Empty(householdid)")
oAcc:ClearFilter()
oAcc:SetOrder("REKOMS")
oAcc:gotop()
store 0 TO a_tel
store 0.00 TO tot1, tot2, tot3, tot4
+regeltel :=0
DO WHILE .not.oAcc:EOF
	oMbr:seek(oAcc:accid)
	IF Empty(oMbr:householdid).or.!oMbr:Found   && medewerkers zonder HB-account overslaan
		oAcc:skip()
		LOOP
	ENDIF
	store oAcc:accid to me_rek
	store oAcc:description to me_oms
	store oAcc:balitemid to me_num
	store oMbr:householdid to me_hbn
	store oMbr:Grade TO me_stat
	store oMbr:has TO me_has
	store oMbr:co TO me_co
	rek_sel := FALSE
	store 0 TO bedn0,bedn1,bedn2,bedn3,bedn4,mutdeb,mutcre
	rekmit:= 0
	rekhas:= 0
	rekmbr:= 0
	oTrans:seek(me_rek)
	DO WHILE oTrans:accid==me_rek.and.oTrans:dat<=self:closingDate .and..not.oTrans:EOF
		IF !Empty(AllTrim(oTrans:BFM))
			oTrans:Skip()
			LOOP
		ENDIF
		IF oAcc:description="Vincent"
			rekmit:=rekmit
		ENDIF
		oTrans:RecLock(oTrans:Recno)
		AAdd(aIESLock,oTrans:Recno)
		rek_sel:=TRUE
		store oTrans:gc TO me_gc
		mutdeb:=mutdeb+oTrans:deb
		mutcre:=mutcre+oTrans:cre
		DO CASE
		CASE me_gc='AG' .OR. me_gc='OT'
			IF AtC('MIT',me_stat)>0 .or. me_has
				IF me_has
					rekhas:=rekhas+((oTrans:cre-oTrans:deb)*sAssmntField)/100
				ELSE
					rekmit:=rekmit+((oTrans:cre-oTrans:deb)*sAssmntField)/100
				ENDIF
			ENDIF
			*5% belasting wegschrijven in hulpbestand
            rekmbr:=rekmbr+((oTrans:cre-oTrans:deb)*sAssmntOffc)/100
            store bedn1 + (oTrans:cre-oTrans:deb) TO bedn1
		CASE me_gc='PF'
			store bedn2 + (oTrans:cre-oTrans:deb) TO bedn2
		CASE me_gc='MG'
			store bedn3 + (oTrans:cre-oTrans:deb) TO bedn3
		OTHER
			store bedn4 + oTrans:cre-oTrans:deb TO bedn4
		ENDCASE
		oTrans:skip()
	ENDDO
	IF rek_sel
		hbdeb:=hbdeb+mutcre-mutdeb
		rekhas:=Val(Str(rekhas,,DecAantal)) // work around for round(x,decaantal)
		rekmbr:=Val(Str(rekmbr,,DecAantal))
		rekmit:=Val(Str(rekmit,,DecAantal))
		m4p:=m4p+rekhas
		m4pm:=m4pm+rekmit
		m5p:=m5p+rekmbr
		* sla op: reknr, som van mutaties , ingehouden bedrag , bed1, bed2, bed3, bed4
		AAdd(aMember,{me_rek,mutcre-mutdeb,rekhas+rekmbr+rekmit,bedn1,bedn2,bedn3,bedn4,me_co,me_hbn,me_oms})
		tot1 := tot1 + bedn1
		tot2 := tot2 + bedn2
		tot3 := tot3 + bedn3
		tot4 := tot4 + bedn4
	ENDIF
	oAcc:Skip()
ENDDO
aant_rek:=Len(aMember)
oTrans:clearfilter()
mo_tot:=tot1+tot2+tot3+tot4
AmountDue:= mo_tot-m4p-m5p-m4pm
AmountDueTxt:='Amount due to '+AllTrim(if(AmountDue>0,'SIL',sland))+' '+;
IF(AmountDue#0,AllTrim(Getal_inv(AmountDue,11))+' (Local currency: '+smunt+')',;
'***NIHIL***' )

oExch:=GetExchRate{self,,,{oSys:CURRNAME,"USD","Sending to IES"}}
oExch:Show()  && mxrate will be filled in by oExch
IF Empty(mxrate)
	mxrate:=1
ENDIF
oSys:EXCHRATE := mxrate
kopregels:={;
'                            SUMMER INSTITUTE OF LINGUISTICS',;
'                             INTERNATIONAL EXCHANGE SYSTEM',;
'                                    MONTHLY REPORT',' ',;
' ORGANIZATION:  '+sland+'   EXCHANGE RATE U.S. $1 = '+Str(mxrate,,8),;
' ENTITYCODE  :  '+sentity,;
' CURRENCY    :  '+smunt+'  '+Pad(smuntnaam,27)+' PREPARED BY: ....................',;
' ',' IE receipt MONTH & YEAR : ' + rmaand + ' ' + Str(BalYear,4) +;
'              APPROVED BY: ....................',' ',Replicate('-',88),;
'     For Accounting Use',;
'     Rpt approved: __________ D/E __________ Date __________ JE # IE __________' ,;
Replicate('-',88),' ',;
'             FIN/                        ASSESSABLE      MEMBER     MEMBER     MBR MISC',;
'             COST    MEMBER NAME/            INCOME    PERSONAL     TO MBR         & GL' ,;
'COD  ACCT   CENTER  GL DESCRIPTION         MBR/CORP       FUNDS      GIFTS    TRANSACTN' ,;
scheiding}
FOR a_tel=1 TO aant_rek
	* Print member data:
	bedn1:=aMember[a_tel,4]
	bedn2:=aMember[a_tel,5]
	bedn3:=aMember[a_tel,6]
	bedn4:=aMember[a_tel,7]
	me_co:=aMember[a_tel,8]
	me_hbn:=aMember[a_tel,9]
	me_oms:=aMember[a_tel,10]
	IF bedn1#0.or.bedn2#0.or.bedn3#0.or.bedn4#0
		IF me_co='S'
			IF bedn1 #0
				self:pr_medew('S','48310',bedn1,0,0,0,aIE,@rij,@blad)
			ENDIF
			IF bedn2#0.or.bedn3#0.or.bedn4#0
				self:pr_medew('S','28000',0,bedn2,bedn3,bedn4,aIE,@rij,@blad)
			ENDIF
		ELSEIF me_co=='6'
			self:pr_medew('S','19999',bedn1,bedn2,bedn3,bedn4,aIE,@rij,@blad)
		ELSEIF me_co='M'
			self:pr_medew('M','     ',bedn1,bedn2,bedn3,bedn4,aIE,@rij,@blad)
		ELSE
			self:pr_medew(' ','     ',bedn1,bedn2,bedn3,bedn4,aIE,@rij,@blad)
		ENDIF
		IF Len(kopregels)>15  && kop aanpassen voor blad >=2
			FOR i=1 TO 11
				ADel(kopregels,4)
			NEXT
			ASize(kopregels,8)
		ENDIF
	ENDIF
NEXT

IF regeltel > 0
	oReport:PrintLine(@rij,@blad,scheiding,kopregels)
ENDIF

oReport:PrintLine(@rij,@blad,Space(12)+'Subtotals'+Space(18)+;
Getal_inv(tot1,11)+Getal_inv(tot2,11)+Getal_inv(tot3,11)+;
Getal_inv(tot4,11),kopregels,3)
oReport:PrintLine(@rij,@blad,scheiding,kopregels)
oReport:PrintLine(@rij,@blad,Pad(Space(4)+;
'28000   TOTALS '+Upper(rmaand)+' TRANS RPT',39)+Getal_inv(-tot1,11)+;
Getal_inv(-tot2,11)+Getal_inv(-tot3,11)+Getal_inv(-tot4,11),kopregels)
oReport:PrintLine(@rij,@blad,scheiding,kopregels)
ASize(kopregels,4)
oReport:PrintLine(@rij,@blad,' ',kopregels)
oReport:PrintLine(@rij,@blad,' ',kopregels)
oReport:PrintLine(@rij,@blad,Space(20)+'SUMMARY',kopregels,23)
oReport:PrintLine(@rij,@blad,Space(20)+Replicate('-',7),kopregels)
oReport:PrintLine(@rij,@blad,Space(20)+'Assessable income mbr/corp       '+;
Getal_inv(tot1,11),null_array,0)
oReport:PrintLine(@rij,@blad,Space(20)+'Member pers. funds               '+;
Getal_inv(tot2,11),null_array,0)
oReport:PrintLine(@rij,@blad,Space(20)+'Member to mbr gifts              ' +;
Getal_inv(tot3,11),null_array,0)
oReport:PrintLine(@rij,@blad,Space(20)+'Mbr misc & GL transactions       ' +;
Getal_inv(tot4,11),kopregels,0)
oReport:PrintLine(@rij,@blad,' ',kopregels,0)
oReport:PrintLine(@rij,@blad,Space(53)+Replicate('-',15),kopregels,0)
oReport:PrintLine(@rij,@blad,Space(20)+'Monthly report total             ' +;
IF(mo_tot#0,Getal_inv(mo_tot,11),' ***NIHIL***'),kopregels,0)
oReport:PrintLine(@rij,@blad,' ',kopregels)
oReport:PrintLine(@rij,@blad,;
Space(20)+'Less '+Str(sAssmntOffc,4,DecAantal)+'% Members/projects      '+;
Str(m5p,11,decaantal),kopregels)
oReport:PrintLine(@rij,@blad,;
Space(25)+Str(sAssmntField,4,DecAantal)+         '% HA                    '+;
Str(m4p,11,decaantal),kopregels)
oReport:PrintLine(@rij,@blad,;
Space(25)+Str(sAssmntField,4,DecAantal)+         '% MIT                   '+;
Str(m4pm,11,decaantal),kopregels)
oReport:PrintLine(@rij,@blad,Space(53)+Replicate('-',15),kopregels)
oReport:PrintLine(@rij,@blad,;
Space(20)+'Amount due to '+if(AmountDue>0,'SIL',sland)+;
IF(AmountDue#0,Getal_inv(AmountDue,11)+' (Local currency: '+smunt+')',' ***NIHIL***' ),kopregels)
oReport:PrintLine(@rij,@blad,' ',kopregels)
oReport:PrintLine(@rij,@blad,Space(20)+'Divided by exchange rate of : '+Str(mxrate,,8),kopregels)
oReport:PrintLine(@rij,@blad,' ',kopregels)
oReport:PrintLine(@rij,@blad,Space(20)+'Amount due to '+Pad('SIL (US DOLLARS) $',19)+Str(AmountDue/mxrate,,2)+'-',kopregels)
*Replicate('.',11)+'-',kopregels)
oReport:PrintLine(@rij,@blad,Replicate('-',88),kopregels,4)
oReport:PrintLine(@rij,@blad,Space(20)+;
'The amount that will be transferred to our account',kopregels)
oReport:PrintLine(@rij,@blad,' ',kopregels)
oReport:PrintLine(@rij,@blad,;
Pad(Space(20)+'will be (in currency: ..... ):',53)+Replicate('.',11)+'-',kopregels)
oReport:PrintLine(@rij,@blad,Replicate('-',88),kopregels )
SELF:Pointer := Pointer{POINTERARROW}
uRet:=NIL
uRet:=oReport:prstart()

	* Produce also textfile with report for sending to IES:
	cFileNameConf :=CurPath + "\"+AllTrim(sentity)+StrZero(BalMonth,2)+'IES.DOC'
	oReport:ToFileFS:FullPath:= cFileNameConf
	oReport:Destination:="file"
	oReport:prstart()

oReport:prstop()

*If too early in the month no sending of the report:
IF (BalMonthEnd - Today()) > 15
	RETURN
ENDIF

*Na printen vragen om bevestiging of printen is goed gegaan

oWarn:=TEXTbox{oWindow,"International Exchange Report",;
'Printing O.K.? Can reporting period be closed for gifts?',BOXICONQUESTIONMARK + BUTTONYESNO}
IF (oWarn:Show() = BOXREPLYYES)
	SELF:Pointer := Pointer{POINTERHOURGLASS}
	*per medewerker nog AM en HB gedrag wegboeken
	oAcc:clearFilter()
	oAcc:setOrder("accid")
*	Mutaties op gerapporteerd zetten: bfm='H':
	FOR i=1 TO Len(aIESLock)
		oTrans:Goto(aIESLock[i])
		oTrans:bfm:='H'
	NEXT
	cTransnr := TransKey{}:KeyValue
	FOR a_tel = 1 TO Len(aMember)
		me_rek:=aMember[a_tel,1]
		oAcc:seek(me_rek)
		me_hhb:=aMember[a_tel,3]
		me_saldo:=aMember[a_tel,2]
		me_oms:=oAcc:description
       * Mutaties aanmaken voor afboeken saldo per medewerker:
		oTrans:append()
		oTrans:accid := me_rek
		oTrans:deb := me_saldo
		oTrans:description := 'To IE: '+;
		IF(!Empty(aMember[a_tel,4]),'AG:'+AllTrim(Str(aMember[a_tel,4])),'')+;
		IF(!Empty(aMember[a_tel,6]),'+MG:'+AllTrim(Str(aMember[a_tel,6])),'')+;
		IF(!Empty(aMember[a_tel,5]),'+PF:'+AllTrim(Str(aMember[a_tel,5])),'')+;
		IF(!Empty(aMember[a_tel,7]),'-CH:'+AllTrim(Str(aMember[a_tel,7])),'')

		oTrans:dat := self:closingDate
		oTrans:TransId := cTransnr
		oTrans:bfm := 'H'
		oTrans:GC:="CH"
		oTrans:USERID := LOGON_EMP_ID
		oMBal:ChgBalance(me_rek, self:closingDate, me_saldo,0, me_saldo,0)
	NEXT

 	amdeb:=m4p+m4pm+m5p
	hbdeb:=hbdeb-amdeb
	*Verzamelpost HB nog wegboeken EN AANMAKEN
	oMBal:ChgBalance(shb, self:closingDate, 0, hbdeb, 0, hbdeb)
	IF hbdeb#0
		oTrans:append()
		oTrans:accid := shb
		oTrans:dat := self:closingDate
		oTrans:description := 'IE Total'
		oTrans:cre := hbdeb
		oTrans:TransId := cTransnr
		oTrans:USERID := LOGON_EMP_ID
		oTrans:bfm := 'H'
	ENDIF

	*Verzamelpost AM nog wegboeken
	oMBal:ChgBalance(sam, self:closingDate, 0, amdeb, 0, amdeb)
	IF amdeb#0
		oTrans:append()
		oTrans:accid := sam
		oTrans:dat := self:closingDate
		oTrans:description := 'AM Total'
		oTrans:cre := amdeb
		oTrans:USERID := LOGON_EMP_ID
		oTrans:TransId := cTransnr
		oTrans:bfm := 'H'
	ENDIF
	oTrans:Commit()
	oTrans:Unlock()
	*periode invullen
	oSys:goto(1)
	oSys:reclock()
	oSys:LstReportMonth :=Val(SubStr(DToS(BalMonthEnd),1,6))
	oSys:EXCHRATE := mxrate

	   * Datafile aanmaken:
	DecSep:=CHR(SetDecimalSep())
	cFileName := CurPath + "\"+AllTrim(sentity)+StrZero(BalMonth,2)+'IES.TXT'
*	ptrHandle := FCreate(cFilename)
*    IF ptrHandle = F_ERROR
*		(WarningBox{,,"Creating IES-report","Error: "+DosErrString(FError())+" when creating file "+cFilename}):Show()
	ptrHandle := MakeFile(SELF,cFilename,"Creating IES-report")
	IF !ptrHandle = F_ERROR .and. !ptrHandle==NIL
		* header record:
		FWriteLine(ptrHandle,'1'+Pad(sentity,4)+Str(BalYear,4) +StrZero(BalMonth,2)+;
		StrTran(StrZero(mxrate,13,8),DecSep))

		* detail records:
		FOR i = 1 TO Len(aIE)
			FWriteLine(ptrHandle,'2'+Pad(sentity,4)+Str(BalYear,4) +StrZero(BalMonth,2)+aIE[i])
		NEXT

	   * closing record:
		FWriteLine(ptrHandle,'3'+Pad(sentity,4)+Str(BalYear,4) +StrZero(BalMonth,2)+;
		Getal_invf(tot1,12,2)+Getal_invf(tot2,12,2)+;
		Getal_invf(tot3,12,2)+Getal_invf(tot4,12,2)	+StrZero(Len(aIE),5,0))
		FClose(ptrHandle)
		cIESMail:=AllTrim(oSys:IESMAILACC)
		cIESMail:=StrTran(cIESMail,";"+AllTrim(oSys:OWNMAILACC))
		cIESMail:=StrTran(cIESMail,AllTrim(oSys:OWNMAILACC))
		* Send file by email:
		IF IsMAPIAvailable()
			* Resolve IESname
			oMAPI := MAPISession{}	
			IF oMAPI:Open( "" , "" )
				oRecip := oMAPI:ResolveMailName( "International Exchange System",@cIESMail,"International Exchange System")
				IF oRecip != NULL_OBJECT
					oMapi:SendDocument( FileSpec{cFilename} ,oRecip,oRecip2,"IES report of "+oSys:CountryOwn,"")
					oMapi:SendDocument( FileSpec{cFileNameConf},oRecip,oRecip2,"IES report of "+oSys:CountryOwn+" as confirmation","")
					(Infobox{SELF:OWNER,"International Exchange Report",;
					"Placed two mail messages in your outbox with attached the files: ";
					+cFilename+" and "+ cFileNameConf}):Show()
					lSent:=TRUE
					oMapi:Close()
				ENDIF
			ENDIF
		ENDIF
		IF !lSent
*			IF !Empty(cIESMail).and.!Empty(oSys:SMTPSERVER)
*				oMail:=SendEMail{}
*				oMail:SendMail("IES report of "+oSys:CountryOwn,,cIESMail,oSys:OWNMAILACC,cFileName)
*				oMail:SendMail("IES report of "+oSys:CountryOwn+" as confirmation",,cIESMail,oSys:OWNMAILACC,cFileNameConf)
*				oMail:Close()
*				(Infobox{SELF:OWNER,"International Exchange Report","Sent two mail messages with attached the files: "+cFilename+;
*				" and "+ cFileNameConf}):Show()
*		  	ELSE
				(Infobox{SELF:OWNER,"International Exchange Report","Generated two files: 1: "+cFilename+" (mail to IES account "+;
				AllTrim(oSys:IESMAILACC)+")  and 2: "+	cFileNameConf+' (mail as confirmation)'}):Show()
*			ENDIF
		ENDIF
		IF !cIESMail==oSys:IESMAILACC
			oSys:RecLock()
			oSys:IESMAILACC:=cIESMail
			oSys:UnLock()
		ENDIF
	ENDIF
	oSys:commit()
	oSys:Unlock()
	SELF:EndWindow()
ENDIF
SELF:Pointer := Pointer{POINTERARROW}
RETURN
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
	if self:closingDate>self:oSys:PMISLSTSND
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
	oAcc:=SQLSelect{"select Currency from account where accid=?",oConn}
	oAcc:Execute(SHB)
	if oAcc:reccount<1 
			(ErrorBox{self:Owner,self:oLan:WGet('Add first account for PMC Clearance')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF
	self:cPMCCurr:=iif(Empty(oAcc:Currency),sCurr,oAcc:Currency)

	*Verzamelpost AM
	oAcc:Execute(sam)
	if oAcc:reccount<1 
		(ErrorBox{self:OWNER,self:oLan:WGet('Add first account for AssessMents')}):Show()
		SELF:EndWindow()
		RETURN TRUE
	ENDIF

	SELF:PrintReport()
	SELF:EndWindow()
	RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS PMISsend
	//Put your PostInit additions here
self:SetTexts()
self:oSys := SQLSelect{"select assmntfield,assmntOffc,withldoffl,withldoffM,withldoffH,assmntint,"+;
"EXCHRATE,PMISLSTSND,DATLSTAFL,PMCUPLD,PMCMANCLN,IESMAILACC from sysparms",oConn}
IF self:oSys:Reccount <1
	SELF:ENDWindow()
ENDIF

self:sAssmntField := self:oSys:assmntfield
self:sAssmntOffc := self:oSys:assmntOffc
self:sWithldOffl := self:oSys:withldoffl
self:sWithldOffM := self:oSys:withldoffM
self:sWithldOffH := self:oSys:withldoffH
self:sPercAssInt := self:oSys:assmntint
self:mxrate := oSys:EXCHRATE
self:oDCAfsldag:DateRange:=DateRange{Today()-365,Today()}

self:closingDate := Today()
self:oDCBalanceText:TextValue :='Sending of member transactions to PMC. Last send on: '+DToC(self:oSys:PMISLSTSND)

RETURN NIL
METHOD PrintReport() CLASS PMISsend
	LOCAL AssInt,AssOffice,AssOfficeProj,AssField,hbdeb,me_saldo,me_saldoF,OfficeRate as FLOAT
	local separatorline as STRING
	local heading as ARRAY
	local oCurr as CURRENCY 
	LOCAL aMemberTrans:={} as ARRAY
	LOCAL destinstr:={} as ARRAY 
	local aDistr:={} as array 
	local oReport as PrintDialog
	LOCAL i, a_tel, batchcount, directcount, iDest, iType,nSeqnr,nSeqnrDT,nRowCnt,CurrentAccID as int
	LOCAL mo_tot,mo_totF, AmountDue,mo_direct, BalanceSend  as FLOAT
	LOCAL AmntAssessable,AmntMG,AmntCharges,remainingAmnt,me_amount,availableAmnt,me_asshome,me_assint, amntlimited as FLOAT
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
	LOCAL CurMonth:=Year(Today())*100+Month(Today()) as int
	LOCAL noIES as LOGIC
	LOCAL DestAmnt as FLOAT
	LOCAL oAfl as UpdateHouseHoldID
	LOCAL datelstafl as date
	LOCAL cDestAcc,cNoteText,cError as STRING 
	local nRow, nPage as int
	Local cAccCng as string,  nAnswer as int 
	local oAsk as AskSend 
	local oAskUp as AskUpld 
	local cErrMsg as string,lSkipMbr as logic
	local fExChRate as float
	local lStop:=true,PMCUpload as logic
	local oTrans,oMbr,oAccD,oPers,oPersB as SQLSelect	 
	local oMBal as Balances
	local oStmnt as SQLStatement

	oWindow:=GetParentWindow(self) 
	// Import first account change list 
	oWindow:Pointer := Pointer{POINTERHOURGLASS}
	datelstafl:=self:oSys:DATLSTAFL 
	if datelstafl<Today() 
		/*	oInST:=Insite{}
		cAccCng:=oInST:GetAccountChangeReport(datelstafl) 
		oInST:Close()   */

		oAfl:=UpdateHouseHoldID{}
		if !oAfl:Processaffiliated_person_account_list(cAccCng)
			IF !oAfl:Importaffiliated_person_account_list()
				IF datelstafl<(Today()-31) 
					nAnswer:= (TextBox{oWindow,self:oLan:WGet("Import RPP"),;
						self:oLan:WGet('Your last import of the Account Changes Report from Insite is of')+' '+DToC(datelstafl)+'.'+LF+self:oLan:WGet('If you stop now you can first download that report from Insite into folder')+' '+curPath+' '+self:oLan:WGet('before the send to PMC')+CRLF+CRLF+self:oLan:WGet('Do you want to stop now?'),BOXICONQUESTIONMARK + BUTTONYESNO}):Show()
					IF nAnswer == BOXREPLYYES 
						oWindow:Pointer := Pointer{POINTERARROW} 
						FileStart(WorkDir()+"\Insite.html",self)
						RETURN FALSE
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	oWindow:Pointer := Pointer{POINTERARROW}

	oReport := PrintDialog{self,self:oLan:RGet("Sending transactions to PMC"),,160,DMORIENT_LANDSCAPE}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	oCurr:=Currency{"Sending to PMC"}
	fExChRate:=oCurr:GetROE("USD",Today(),true) 
	if oCurr:lStopped
		Return
	endif
	PMCUpload:= iif(self:oSys:PMCUPLD=1,true,false)
	// fExChRate:=self:mxrate
	self:STATUSMESSAGE(self:oLan:WGet("Collecting data for the sending, please wait")+"...")

	store 0 to AssInt,AssOffice,AssOfficeProj,AssField,hbdeb

	if Empty(self:oSys:PMCMANCLN) 
		(ErrorBox{oWindow,self:oLan:WGet("Enter first within the system parameters")+" "+self:oLan:WGet("PMC Manager who should approve the PMC file")}):Show()
		self:ENDWindow()
		self:Pointer := Pointer{POINTERARROW}
		return
	else
		if SQLSelect{"select persid from person where persid="+Str(self:oSys:PMCMANCLN,-1),oConn}:Reccount<1
			(ErrorBox{oWindow,self:oLan:WGet("Enter first within the system parameters")+" "+self:oLan:WGet("PMC Manager who should approve the PMC file")}):Show()
			self:ENDWindow()
			self:Pointer := Pointer{POINTERARROW}
			return		
		endif
	endif  
	self:Pointer := Pointer{POINTERHOURGLASS}

	self:oSys:EXCHRATE := fExChRate
	oMBal:=Balances{}
	separatorline:= '--------------------|-----------|'+Replicate('-',126)+'|'
	nRow:=0
	nPage:=0
	store 0 to a_tel
	+nRowCnt :=0
	SQLStatement{"start transaction",oConn}:Execute()    // te lock all transactions and distribution instructions read
	// select the member data
	oMbr:=SQLSelect{"select a.accid,a.accnumber,a.description,a.currency,b.category as type,m.*,pp.ppname as homeppname,"+;
		"group_concat(cast(d.desttyp as char),'#;#',cast(d.DESTAMT as char),'#;#',d.DESTPP,'#;#',d.DESTACC,'#;#',cast(d.LSTDATE as char),'#;#',cast(d.SEQNBR as char),'#;#',"+;
		"d.DESCRPTN,'#;#',d.CURRENCY,'#;#',cast(d.AMNTSND as char),'#;#',cast(d.SINGLEUSE as char),'#;#',DFIR,'#;#',DFIA,'#;#',CHECKSAVE,'#;#',pd.ppname separator '#%#,') as distr" +;
		" from account a,balanceitem b,member m left join PPCodes pp on (pp.ppcode=m.homepp) "+;
		" left join distributioninstruction d on (d.mbrid=m.mbrid and d.disabled=0) left join PPCodes pd on (d.destpp=pd.ppcode) "+; 
	" where a.accid=m.accid and a.balitemid=b.balitemid group by m.accid order by m.accid",oConn}
	if oMbr:Reccount<1
		WarningBox{oWindow,self:oLan:WGet("Send to PMC"),self:oLan:WGet("No members specified")}:Show()
		return
	endif
	// select the transaction data
	oTrans:=SQLSelect{"select transid,seqnr,accid,persid,cre,deb,description,reference,gc,poststatus,fromrpp from transaction t where t.bfm='' and t.dat<='"+SQLdate(self:closingDate)+"' and t.accid in (select m.accid from member m) order by t.accid for update",oConn} 
// 	oTrans:=SQLSelect{"select t.transid,t.seqnr,t.accid,t.persid,t.cre,t.deb,t.description,t.reference,t.gc,t.poststatus,t.fromrpp "+;
// 	"from member m,transaction t where t.accid=m.accid and t.bfm='' and t.dat<='"+SQLdate(self:closingDate)+"' order by t.accid for update",oConn} 
	oTrans:Execute() 
	if !Empty(oTrans:Status)
		ErrorBox{self,self:oLan:WGet("could not select transactions")+Space(1)+' ('+oTrans:Status:Description+')'}:Show()
		SQLStatement{"rollback",oConn}:Execute() 
		return
	endif
	DO WHILE .not.oMbr:EOF
		CurrentAccID:=oMbr:accid
		me_accid:=Str(CurrentAccID,-1) 
		me_mbrid:=Str(oMbr:mbrid,-1)
		me_accnbr:=oMbr:ACCNUMBER 
		me_currency:=oMbr:CURRENCY
		//store AllTrim(oMbr:description) to me_pers
		me_pers:=StrTran(StrTran(oMbr:Description,","," "),"-"," ")
		me_type:=oMbr:TYPE  
		if Empty(oMbr:homeppname)
			(ErrorBox{self,self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal Primary Finance entity")+":"+oMbr:HOMEPP}):Show()
			return
		endif
		if oMbr:HOMEPP # SEntity .and. (oMbr:TYPE # "PA".and. oMbr:TYPE # "AK")
			(ErrorBox{self,oLan:WGet("Not own")+" "+ self:oLan:WGet("member")+" "+me_pers+" "+self:oLan:WGet("should have a liability/funds or asset account")}):Show()
			return
		endif
		
		lSkipMbr:=false
		// compile destination instructions:
		destinstr:={}
		aDistr:={}
		mHomeAcc:=oMbr:HOMEACC
		if !Empty(oMbr:distr)
			aDistr:=AEvalA(Split(oMbr:distr,"#%#"),{|x|Split(x,'#;#')})
			for i:=1 to Len(aDistr)
				//desttyp,DESTAMT,DESTPP,DESTACC,LSTDATE,SEQNBR,DESCRPTN,CURRENCY,AMNTSND,SINGLEUSE,DFIR,DFIA,CHECKSAVE,destppname
				//   1       2      3      4       5       6      7          8      9        10      11   12     13         14
				cDestPersonId:=""
				IF aDistr[i,3]=="ACH"  //DESTPP
					if Empty(aDistr[i,11]).or. Empty(aDistr[i,12]) .or.Empty(aDistr[i,13])
						(ErrorBox{self,self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")}):Show()
						SQLStatement{"rollback",oConn}:Execute() 
						return
					endif				
					cDestAcc:="#"+AllTrim(aDistr[i,11])+"#"+aDistr[i,13]+"#"+AllTrim(aDistr[i,12])+"#"+SubStr(me_pers,1,22)+"#"+AllTrim(oMbr:householdid)+"#"
				ELSE
					if oMbr:HOMEPP # SEntity .and. (aDistr[i,3] # SEntity .and.aDistr[i,3] # "AAA") .and. oMbr:co == "M"
						(ErrorBox{self,self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")}):Show()
						SQLStatement{"rollback",oConn}:Execute() 
						return
					endif
					cDestAcc:=AllTrim(aDistr[i,4]) 			
					// check legal ppcode: 
					if Empty(aDistr[i,14])
						(ErrorBox{self,self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")}):Show()
						SQLStatement{"rollback",oConn}:Execute() 
						return
					endif
					if aDistr[i,3] == "AAA"
						oPersB:=SQLSelect{"select persid from personbank where banknumber='"+cDestAcc+"'",oConn}
						if oPersB:Reccount>0
							cDestPersonId:=Str(oPersB:persid,-1)
						else
							(ErrorBox{self,self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")}):Show()
							SQLStatement{"rollback",oConn}:Execute() 
							return					
						endif
						if CountryCode=="31".and.Len(cDestAcc)=9
							if !IsDutchBanknbr(cDestAcc)
								(ErrorBox{self,self:oLan:WGet("Member")+" "+me_pers+" "+self:oLan:WGet("contains an illegal distribution instruction")}):Show()
								SQLStatement{"rollback",oConn}:Execute() 
								return
							endif
						endif
					endif
				ENDIF
				// destinstr: {destpp,destacc,desttype,destamnt,lstdate,seqnbr,Description,currency,amntsend,destperson,singleuse},...
				//               1       2       3        4         5      6       7           8        9        10          11
				AAdd(destinstr,{AllTrim(aDistr[i,3]),cDestAcc,Val(aDistr[i,1]),Val(aDistr[i,2]),SQLDate2Date(aDistr[i,5]),aDistr[i,6],aDistr[i,7],iif(aDistr[i,8]='1',true,false),Val(aDistr[i,9]),cDestPersonId, iif(aDistr[i,10]='1',true,false)})
			Next
			ASort(destinstr,,,{|x,y| x[3]<=y[3]})   // sort in processing priority
		endif
		me_stat:=oMbr:Grade 
		me_has:=iif(oMbr:has=1,true,false) 
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
		// 		oTrans:=SQLSelect{"select * from transaction where bfm='' and accid="+me_accid+" and dat<='"+SQLdate(self:closingDate)+"' for update",oConn} 
		// 		oTrans:Execute()
		DO WHILE .not.oTrans:EOF .and.oTrans:accid <= CurrentAccID
			if oTrans:accid == CurrentAccID
				me_gc:=oTrans:gc  
				me_asshome:=0
				me_assint:=0
				if Posting
					if oTrans:POSTSTATUS<2
						// skip this member:
						lSkipMbr:=true
						cErrMsg+=AllTrim(oMbr:Description)+CRLF
						exit
					endif
				endif
				*	Change prelimenary status of transactions to "Send to PMC": bfm='H':
				oStmnt:=SQLStatement{"update transaction set bfm='H' where TransId="+Str(oTrans:TransId,-1)+" and seqnr="+Str(oTrans:seqnr,-1),oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows <1
					ErrorBox{self,self:oLan:WGet("could not update transaction")+Space(1)+Str(oTrans:TransId,-1)}:Show()
					SQLStatement{"rollback",oConn}:Execute() 
					return
				ENDIF  
				do CASE
					* aMemberTrans[reknr,accnbr, accname, type transaction, transaction amount,assmntcode, destination{destacc,destPP,housecode,destnbr,destaccID,mbrtype},homeassamnt,tr.description,Dest.Persid,membercurrency]:
					*          1      2        3           4                 5                  6           7         ,1    ,2      ,3        ,4       ,5       ,6        8           9            10             11
				CASE me_gc='AG' .or. me_gc='OT'
					// calculate assessments:
					IF me_stat!="Staf" .and. oTrans:FROMRPP==0
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
						me_desc:=sCurrName+Str(Round(oTrans:cre-oTrans:deb,DecAantal),-1)
						IF !Empty(oTrans:persid)
							me_desc:=if(Empty(me_desc),"",me_desc+" ")+"from "+GetFullNAW(Str(oTrans:persid,-1),sLand,0)
						ENDIF
						me_desc+=iif(Empty(me_desc),"","; ")+oTrans:Description
						AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,me_amount,"CN",{iif(Empty(oTrans:REFERENCE).and.me_co="S",mHomeAcc,oTrans:REFERENCE),me_homePP,me_householdid,,,me_co},,me_desc,,me_currency})				
						AmntAssessable:=Round(me_amount+AmntAssessable,DecAantal)
					ELSE
						//    AmntAssessable:=Round(AmntAssessable+ oTrans:cre-oTrans:deb,DecAantal)
					ENDIF
				CASE me_gc='MG'
					IF me_homePP!=SEntity
						me_desc:=sCurrName+Str(Round(oTrans:cre-oTrans:deb,DecAantal),-1)
						IF !Empty(oTrans:persid)
							me_desc:=if(Empty(me_desc),"",me_desc+" ")+"from "+GetFullNAW(Str(oTrans:persid,-1),sLand,0)
						ENDIF
						me_desc+=iif(Empty(me_desc),"","; ")+oTrans:Description
						AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(oTrans:cre-oTrans:deb,DecAantal),"MM",{iif(Empty(oTrans:REFERENCE).and.me_co="S",mHomeAcc,oTrans:REFERENCE),me_homePP,me_householdid,,,me_co},,me_desc,,me_currency})
					ENDIF
					AmntMG:=Round(oTrans:cre-oTrans:deb+AmntMG,DecAantal)
				OTHER   // CH and PF
					IF me_homePP!=SEntity
						AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(oTrans:cre-oTrans:deb,DecAantal),"PC",{iif(Empty(oTrans:REFERENCE).and.me_co="S",mHomeAcc,oTrans:REFERENCE),me_homePP,me_householdid,,,me_co},,AllTrim(oTrans:Description),,me_currency})				
					ENDIF
					AmntCharges:=Round(oTrans:cre-oTrans:deb+AmntCharges,DecAantal)
				ENDCASE
				oTrans:skip()
			endif
		ENDDO
		if !lSkipMbr	
			AssInt:=Round(AssInt+mbrint,DecAantal)
			AssField:=Round(AssField+mbrfield,DecAantal)
			AssOffice:=Round(AssOffice+mbroffice,DecAantal)
			AssOfficeProj:=Round(AssOfficeProj+mbrofficeProj,DecAantal)
			* Save: accid,accnbr,accname, type transactie, bedrag, assmntcode, destination{destacc,destPP,household code,destnbr,destaccID},homeassamnt, description
			// 1: assessment int+field:
			IF mbrint # 0
				AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, AG,mbrint,"",{me_accnbr,if(me_co="M","",me_homePP),if(me_co="M",me_householdid,""),,,me_co},if(me_co="M",mbroffice,mbrofficeProj),,,me_currency})
			ENDIF
			// Transfer balance conform distribution instructions:
			if self:closingDate> self:oSys:PMISLSTSND
				oMBal:GetBalance(me_accid,me_type)
				BalanceSend:=Round(oMBal:per_cre-oMBal:per_deb,2)
				if self:closingDate< Today()
					oMBal:GetBalance(me_accid,me_type,,self:closingDate)
					if BalanceSend > Round(oMBal:per_cre-oMBal:per_deb,2)
						BalanceSend:=Round(oMBal:per_cre-oMBal:per_deb,2)
					ENDIF
				ENDIF
				
				remainingAmnt:=Round(BalanceSend-mbroffice-mbrofficeProj-mbrint,DecAantal)
				availableAmnt:=remainingAmnt
				// 2: In case of member from own homePP or non-entity send distribution instructions:
				IF me_homePP==SEntity .or. me_co="M"
					// 3: according to distribution instructions:
					// destinstr: {destpp,destacc,desttype,destamnt,lstdate,seqnbr,Description,currency,amntsend,destperson,singleuse},...
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
									//update prelimenary distribution record:
									oStmnt:=SQLStatement{"update distributioninstruction set LSTDATE='"+SQLdate(self:closingDate)+;
										"',amntsnd='"+Str(DestAmnt,-1)+"'"+iif(destinstr[iDest,11],",DISABLED=1",'')+" where  mbrid="+me_mbrid+" and seqnbr="+destinstr[iDest,6],oConn}
									oStmnt:Execute()
									if !Empty(oStmnt:Status)
										ErrorBox{self,self:oLan:WGet("could not update distribution instruction for member")+Space(1)+me_desc}:Show()
										SQLStatement{"rollback",oConn}:Execute()
										return
									endif  
									IF me_homePP!=SEntity
										AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-DestAmnt,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})				
										AmntCharges:=Round(-DestAmnt+AmntCharges,DecAantal)
									endif
									remainingAmnt:=Round(remainingAmnt-DestAmnt,decaantal)
								ELSE
									// wait untill enough balance
									exit
								ENDIF
							ENDIF
						ELSEIF destinstr[iDest,3]=1 // proportional amount
							me_amount:=Min(Round((destinstr[iDest,4]*availableAmnt)/100,decaantal),remainingAmnt)
							IF me_amount>0
								AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, iType,me_amount,"",{destinstr[iDest,2],destinstr[iDest,1],me_householdid,,destAcc,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})
								remainingAmnt:=Round(remainingAmnt-me_amount,decaantal)
								IF me_homePP!=SEntity
									AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-me_amount,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})				
									AmntCharges:=Round(-me_amount+AmntCharges,DecAantal)
								endif
								if destinstr[iDest,11]														//lock distribution record:
									//update prelimenary distribution record:
									oStmnt:=SQLStatement{"update distributioninstruction set LSTDATE='"+SQLdate(self:closingDate)+;
										"',amntsnd='"+Str(me_amount,-1)+"'"+iif(destinstr[iDest,11],",DISABLED=1",'')+" where  mbrid="+me_mbrid+" and seqnbr="+destinstr[iDest,6],oConn}
									oStmnt:Execute()
									if !Empty(oStmnt:Status)
										ErrorBox{self,self:oLan:WGet("could not update distribution instruction for member")+Space(1)+me_desc}:Show()
										SQLStatement{"rollback",oConn}:Execute()
										return
									endif  
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
									amntlimited:=Min(remainingAmnt, Round(DestAmnt-destinstr[iDest,9],DecAantal))
									//update prelimenary distribution record:
									oStmnt:=SQLStatement{"update distributioninstruction set LSTDATE='"+SQLdate(self:closingDate)+;
										"',amntsnd='"+Str(destinstr[iDest,9]+amntlimited,-1)+"'"+iif(destinstr[iDest,11],",DISABLED=1",'')+" where  mbrid="+me_mbrid+" and seqnbr="+destinstr[iDest,6],oConn}
									oStmnt:Execute()
									if !Empty(oStmnt:Status)
										ErrorBox{self,self:oLan:WGet("could not update distribution instruction for member")+Space(1)+me_desc}:Show()
										SQLStatement{"rollback",oConn}:Execute()
										return
									endif  
									AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, iType,amntlimited,"",{destinstr[iDest,2],destinstr[iDest,1],me_householdid,,destAcc,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})
									IF me_homePP!=SEntity
										AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-amntlimited,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})				
										AmntCharges:=Round(-amntlimited+AmntCharges,DecAantal)
									endif
								ENDIF
							ELSE  // no limit							
								AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, iType,remainingAmnt,"",{destinstr[iDest,2],destinstr[iDest,1],me_householdid,,destAcc,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})
								IF me_homePP!=SEntity
									AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,Round(-remainingAmnt,DecAantal),"PC",{mHomeAcc,me_homePP,me_householdid,,,me_co},,destinstr[iDest,7],cDestPersonId,me_currency})				
									AmntCharges:=Round(-remainingAmnt+AmntCharges,DecAantal)
								endif
								//update prelimenary distribution record:
								oStmnt:=SQLStatement{"update distributioninstruction set LSTDATE='"+SQLdate(self:closingDate)+;
									"',amntsnd='"+Str(remainingAmnt,-1)+"'"+iif(destinstr[iDest,11],",DISABLED=1",'')+" where  mbrid="+me_mbrid+" and seqnbr="+destinstr[iDest,6],oConn}
								oStmnt:Execute()
								if !Empty(oStmnt:Status)
									ErrorBox{self,self:oLan:WGet("could not update distribution instruction for member")+Space(1)+me_desc}:Show()
									SQLStatement{"rollback",oConn}:Execute()
									return
								endif  
								remainingAmnt:=0
							ENDIF
						ENDIF
					NEXT
				ENDIF
				// 2: In case of member from other homePP seperate transactions for CN,MM and PC:
				IF me_homePP!=SEntity
					remainingAmnt:=Round(remainingAmnt-AmntAssessable-AmntMG-AmntCharges,DecAantal)
					// 					IF remainingAmnt>0
					IF !remainingAmnt=0.00
						// send if applicable remaining balance to PMIS
						AAdd(aMemberTrans,{me_accid,me_accnbr,me_pers, MT,remainingAmnt,"CN",{"",me_homePP,me_householdid,,,me_co},,"Transfer of remaining balance to home office",cDestPersonId,me_currency})
					ENDIF
				ENDIF
			endif
		endif
		oMbr:skip()
	ENDDO
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
		'PARTNERCODE :  '+sentity,;
		'CURRENCY    :  '+sCurr+'  '+Pad(sCurrName,27)+Space(81)+'PERIOD ' +iif(self:closingDate>self:oSys:PMISLSTSND,DToC(self:oSys:PMISLSTSND),"")+ ' TO ' + DToC(self:closingDate),;
		' ',;
		Pad('MEMBER',20,' ')+PadL('AMOUNT',12,' ')+' DESCRIPTION',separatorline}
	FOR a_tel=1 to batchcount
		* Print member data:
		* aMemberTrans[reknr,accnbr, accname, type transaction, transaction amount,assmntcode, destination{destacc,destPP,housecode,destnbr,destaccID,mbrtype},homeassamnt,tr.description,Dest.Persid,membercurrency]:
		*          1      2        3           4                 5                  6           7         ,1    ,2      ,3        ,4       ,5       ,6        8           9            10             11
		me_accid:=aMemberTrans[a_tel,1]
		me_saldo:=aMemberTrans[a_tel,5]
		* Omschrijving:
		me_desc:=""
		IF !Empty(aMemberTrans[a_tel,9])
			me_desc:=aMemberTrans[a_tel,9]
		ENDIF
		IF aMemberTrans[a_tel,4]=AG
			me_desc:="Assessment Int+Field"
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
		Pad('Subtotal:',20)+" "+Str(mo_tot+mo_direct,11,2)+"  ("+AllTrim(Str(batchcount,-1,0))+" "+oLan:Get("lines")+")",heading,3-nRowCnt)
	oReport:PrintLine(@nRow,@nPage,Replicate('-',80),heading,4)
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad('Total Assessment intern.+field',40)+Str(AssInt+AssField,11,2),null_array,0)
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad('Total Assessment WO standard',40)+Str(AssOffice,11,2),null_array,0)
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad('Total Assessment WO Projects',40)+Str(AssOfficeProj,11,2),null_array,0)
	oReport:PrintLine(@nRow,@nPage,Replicate('-',80),heading,4)
	IF mo_direct#0
		oReport:PrintLine(@nRow,@nPage,Space(10)+Pad('Amount to be recorded direct to '+SEntity,40)+Str(mo_direct,11,2)+"  ("+AllTrim(Str(directcount,-1,0))+" "+oLan:Get("lines")+")",heading,0)
	ENDIF
	oReport:PrintLine(@nRow,@nPage,Space(10)+Pad('Amount to be send to PMC (US DOLLARS) $',40)+Str(mo_tot/fExChRate,11,2),heading)
	oReport:PrintLine(@nRow,@nPage,Replicate('-',80),heading,4)
	self:Pointer := Pointer{POINTERARROW}
	uRet:=nil
	uRet:=oReport:prstart(false,false)

	oReport:prstop()
	oWindow:Pointer := Pointer{POINTERARROW}

	*After printing request confirmation for continuing: 
	* Produce first Datafile:
	DecSep:=SetDecimalSep(Asc("."))
	cFilename := curPath + "\"+AllTrim(SEntity)+Str(Year(self:closingDate),4,0)+StrZero(Month(self:closingDate),2)+StrZero(Day(self:closingDate),2)+Str(Round(Seconds(),0),-1)+'PMC.XML'
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
		lStop:=true
		if PMCUpload
			if TextBox{self,self:oLan:WGet("Sending to PMC"),self:oLan:WGet("Is printing of PMC transactions OK")+CRLF+;
					self:oLan:WGet("and can their file")+Space(1)+cFilename+CRLF+self:oLan:WGet("be uploaded to Insite")+"?",;
					BOXICONQUESTIONMARK + BUTTONYESNO}:Show()==BOXREPLYYES
				FileStart(WorkDir()+"\InsitePMCUpload.html",self)
				oAskUp:=AskUpld{self,,,cFilename}
				oAskUp:Show() 
				if oAskUp:Result==1
					lStop:=false
				endif
			endif
		else
			oAsk:=AskSend{self}
			oAsk:Show() 
			if oAsk:Result==1
				lStop:=false
			endif
		endif
		if lStop
			SQLStatement{"rollback",oConn}:Execute()  // remove all locks  and updates
			// remove datafile:
			if !FileSpec{cFilename}:DELETE()
				FErase(cFilename)
			endif
		else
			IF self:oSys:PMISLSTSND<Today()-400
				// still IES:
				IF (TextBox{oWindow,self:oLan:WGet("Partner Monetary Clearinghouse"),;
						self:oLan:WGet('Did you really get confirmation from Dallas that your WO is PMC enabled')+'?',BOXICONQUESTIONMARK + BUTTONYESNO}):Show() = BOXREPLYNO
					SQLStatement{"rollback",oConn}:Execute()  //release locks
					RETURN
				ENDIF
			ENDIF
			oMapi := MAPISession{}
			self:Pointer := Pointer{POINTERHOURGLASS} 
			self:STATUSMESSAGE(self:oLan:WGet("Recording transactions, please wait")+"...")
			
			IF Empty(self:oSys:IESMAILACC).or. Lower(SubStr(AllTrim(self:oSys:IESMAILACC),1,10))="ie_dallas@".or.Lower(SubStr(AllTrim(self:oSys:IESMAILACC),1,16))="data_ie_orlando@"
				SQLStatement{"update Sysparms set iesmailacc='PMC-Files_Intl@sil.org'",oConn}:Execute()
			ENDIF
			* record for each member AM HB amounts
			// 				*	Change status of transactions to "Send to PMC": bfm='H':
			// 				FOR i=1 to Len(aTransLock)
			// 					oTrans:goto(aTransLock[i])
			// 					oTrans:bfm:='H'
			// 				NEXT
			*	Record month within fixed amount distribution instructions:
			// 				FOR i=1 to Len(aDisLock)
			// 					oDis:GoTo(aDisLock[i,1])
			// 					oDis:LSTDATE:=self:closingDate
			// 					oDis:AMNTSND:=aDisLock[i,2]
			// 					if aDisLock[i,3]==true
			// 						oDis:DISABLED:=true
			// 					endif		
			// 				NEXT
			// 				oDis:Commit()
			// 				oDis:Unlock()

			cTransnr:=''
			cTransnrDT:=''
			nSeqnr:=0
			nSeqnrDT:=0
			FOR a_tel = 1 to batchcount
				* aMemberTrans[reknr,accnbr, accname, type transaction, transaction amount,assmntcode, destination{destacc,destPP,housecode,destnbr,destaccID,mbrtype},homeassamnt,tr.description,Dest.Persid,membercurrency]:
				*          1      2        3           4                 5                  6           7         ,1    ,2      ,3        ,4       ,5       ,6        8           9            10             11
				me_accid:=aMemberTrans[a_tel,1]
				me_saldo:=aMemberTrans[a_tel,5]
				* Record transactions for decreasing balance of member:
				IF aMemberTrans[a_tel,4]=AG
					me_desc:="Assessment Intern+Field"+self:AssPeriod
				ELSE
					me_desc:=aMemberTrans[a_tel,9]
					IF aMemberTrans[a_tel,4]=MT
						me_desc:=if(Empty(me_desc),"",me_desc+"; ")+"Transfer of "+AllTrim(aMemberTrans[a_tel,6])+" to home:"+aMemberTrans[a_tel,7][2]
					ELSE
						me_desc:=if(Empty(me_desc),"",me_desc+"; ")+"Transfer to:"+AllTrim(aMemberTrans[a_tel,7][2])+", "+aMemberTrans[a_tel,7][1]
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
					nSeqnrDT:=1
					cTransnrDT:=''
				else
					nSeqnr++
				endif
				oStmnt:=SQLStatement{"insert into transaction set accid="+me_accid+",deb='"+Str(me_saldo,-1)+"',DEBFORGN='"+Str(me_saldoF,-1),'0'+;
					",CURRENCY='"+aMemberTrans[a_tel,11],"',Description='"+me_desc+"',dat='"+SQLdate(self:closingDate)+"',bfm='H',GC='CH',userid='"+LOGON_EMP_ID+"'"+;
					",POSTSTATUS=2"+;
					iif(aMemberTrans[a_tel,4]==DT,",seqnr=1",iif(Empty(cTransnr),'',",transid="+cTransnr+",seqnr="+Str(nSeqnr,-1))),oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows<1
					cError:=self:oLan:WGet("could no record transaction for member")+Space(1)+aMemberTrans[a_tel,3]+' ('+oStmnt:Status:Description+')'
					exit
				endif
				IF aMemberTrans[a_tel,4]==DT
					if Empty(cTransnrDT)
						cTransnrDT:=SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)
					endif
				elseif Empty(cTransnr)
					cTransnr:=SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)
				endif
				if !ChgBalance(me_accid, self:closingDate, me_saldo,0, me_saldoF,0,aMemberTrans[a_tel,11]) 
					cError:=self:oLan:WGet("could no update balance for member")+Space(1)+aMemberTrans[a_tel,3]+' ('+oStmnt:Status:Description+')'
					exit
				endif
				// record transactions to own PP/ own account Payable directly
				IF aMemberTrans[a_tel,4]==DT
					nSeqnrDT++
					oStmnt:=SQLStatement{"insert into transaction set accid="+aMemberTrans[a_tel,7][5]+",cre='"+Str(me_saldo,-1)+"',CREFORGN='"+Str(me_saldo,-1),'0'+;
						",CURRENCY='"+aMemberTrans[a_tel,11],"',Description='"+	AllTrim(aMemberTrans[a_tel,9]+"	"+oLan:Get("From")+"	"+AllTrim(aMemberTrans[a_tel,3]))+;
						"',dat='"+SQLdate(self:closingDate)+"',bfm='H',userid='"+LOGON_EMP_ID+"'"+;
						",POSTSTATUS=2,TransId="+cTransnrDT+",seqnr="+Str(nSeqnrDT,-1),oConn}
					oStmnt:Execute()
					if	oStmnt:NumSuccessfulRows<1
						cError:=self:oLan:WGet("could	no	record transaction for member")+Space(1)+aMemberTrans[a_tel,3]+'	('+oStmnt:Status:Description+')'
						exit
					ENDIF						
					if !ChgBalance(aMemberTrans[a_tel,7][5], self:closingDate, 0, me_saldo, 0, me_saldo,aMemberTrans[a_tel,11]) 
						cError:=self:oLan:WGet("could no update balance for member")+Space(1)+aMemberTrans[a_tel,3]+' ('+oStmnt:Status:Description+')'
						exit
					endif
					if aMemberTrans[a_tel,7][5]==sCRE .and.aMemberTrans[a_tel,7][2]=="AAA" 
						// to account payable and local bank: make BankOrder:
						oStmnt:=SQLStatement{"insert into bankorder set "+; 
						"ACCNTFROM='"+sCRE+"'"+;
							",AMOUNT='"+Str(me_saldo,-1)+"'"+;
							",description='"+iif(Empty(aMemberTrans[a_tel,9]),me_desc,aMemberTrans[a_tel,9])+"'"+;
							",BANKNBRCRE='"+AllTrim(aMemberTrans[a_tel,7][1]) +"'"+;
							",DATEDUE=CURRENTDATE()"+; 
						",IDFROM='"+me_accid+"'",oConn}
						oStmnt:Execute()
						if oStmnt:NumSuccessfulRows<1
							cError:=self:oLan:WGet("could	no	record bankorder for member")+Space(1)+aMemberTrans[a_tel,3]+'	('+oStmnt:Status:Description+')'
							exit
						ENDIF						
					endif
				ENDIF
				// Also transaction for Office assessment:
				IF aMemberTrans[a_tel,4]=AG .and.aMemberTrans[a_tel,8]#0
					IF aMemberTrans[a_tel,7][6]="M"
						me_desc:="Assessment office"+self:AssPeriod
					ELSE
						me_desc:="Assessment office projects"+self:AssPeriod
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
					oStmnt:=SQLStatement{"insert into transaction set accid="+me_accid+",deb='"+Str(me_saldo,-1)+"',DEBFORGN='"+Str(me_saldoF,-1),'0'+;
						",CURRENCY='"+aMemberTrans[a_tel,11],"',Description='"+	me_desc+;
						"',dat='"+SQLdate(self:closingDate)+"',bfm='H',gc='CH',userid='"+LOGON_EMP_ID+"'"+;
						",POSTSTATUS=2,TransId="+cTransnr+",seqnr="+Str(nSeqnr,-1),oConn}
					oStmnt:Execute()
					if	oStmnt:NumSuccessfulRows<1
						cError:=self:oLan:WGet("could	no	record assessment for member")+Space(1)+aMemberTrans[a_tel,3]+'	('+oStmnt:Status:Description+')'
						exit
					ENDIF						
					if !ChgBalance(me_accid, self:closingDate, me_saldo,0, me_saldoF,0,aMemberTrans[a_tel,11])
						cError:=self:oLan:WGet("could no update balance for member")+Space(1)+aMemberTrans[a_tel,3]+' ('+oStmnt:Status:Description+')'
						exit
					endif
				ENDIF
			NEXT

			*Record Total amount AM:
			IF Empty(cError).and.!Empty(samProj)
				IF AssOfficeProj#0
					nSeqnr++
					oStmnt:=SQLStatement{"insert into transaction set accid="+samProj+",cre='"+Str(AssOfficeProj,-1)+"',CREFORGN='"+Str(AssOfficeProj,-1),'0'+;
						",CURRENCY='"+sCurr,"',Description='AM Office Projects Total'"+;
						"',dat='"+SQLdate(self:closingDate)+"',bfm='H',userid='"+LOGON_EMP_ID+"'"+;
						",POSTSTATUS=2,TransId="+cTransnr+",seqnr="+Str(nSeqnr,-1),oConn}
					oStmnt:Execute()
					if	oStmnt:NumSuccessfulRows<1
						cError:=self:oLan:WGet("could	no	record assessment projects total")+'	('+oStmnt:Status:Description+')'
					elseif !oMBal:ChgBalance(samProj, self:closingDate, 0, AssOfficeProj, 0, AssOfficeProj,sCURR)
						cError:=self:oLan:WGet("could no update balance for assessment projects")+' ('+oStmnt:Status:Description+')'
					endif
				ENDIF
			ELSE
				AssOffice:=Round(AssOffice+AssOfficeProj,DecAantal)
			ENDIF
			IF Empty(cError).and.AssOffice#0
				nSeqnr++
				oStmnt:=SQLStatement{"insert into transaction set accid="+sam+",cre='"+Str(AssOffice,-1)+"',CREFORGN='"+Str(AssOffice,-1),'0'+;
					",CURRENCY='"+sCurr,"',Description='AM	Office Total'"+;
					"',dat='"+SQLdate(self:closingDate)+"',bfm='H',userid='"+LOGON_EMP_ID+"'"+;
					",POSTSTATUS=2,TransId="+cTransnr+",seqnr="+Str(nSeqnr,-1),oConn}
				oStmnt:Execute()
				if	oStmnt:NumSuccessfulRows<1
					cError:=self:oLan:WGet("could	no	record assessment	total")+'	('+oStmnt:Status:Description+')'
				elseif !oMBal:ChgBalance(sam,	self:closingDate,	0,	AssOffice, 0, AssOffice,sCURR)
					cError:=self:oLan:WGet("could	no	update balance	for assessment")+Space(1)+'	('+oStmnt:Status:Description+')'
				endif
			ENDIF
			*Record total amount to PMC 
			IF Empty(cError).and.mo_tot # 0
				nSeqnr++
				if !self:cPMCCurr==sCurr .and. fExChRate>0
					mo_totF:=Round(mo_tot/fExChRate,DecAantal)
				endif
				oStmnt:=SQLStatement{"insert into transaction set accid="+shb+",cre='"+Str(mo_tot,-1)+"',CREFORGN='"+Str(mo_totF,-1),'0'+;
					",CURRENCY='"+self:cPMCCurr,"',Description='PMC Total'"+;
					"',dat='"+SQLdate(self:closingDate)+"',bfm='H',userid='"+LOGON_EMP_ID+"'"+;
					",POSTSTATUS=2,TransId="+cTransnr+",seqnr="+Str(nSeqnr,-1),oConn}
				oStmnt:Execute()
				if	oStmnt:NumSuccessfulRows<1
					cError:=self:oLan:WGet("could	no	record assessment	total")+'	('+oStmnt:Status:Description+')'
				elseif !oMBal:ChgBalance(shb,	self:closingDate,	0,	mo_tot, 0, mo_totF,self:cPMCCurr)
					cError:=self:oLan:WGet("could	no	update balance	for RIA account")+Space(1)+'	('+oStmnt:Status:Description+')'
				endif
			ENDIF
			if Empty(cError)
				oStmnt:=SQLStatement{"update sysparms set PMISLSTSND=CURRENTDATE(),EXCHRATE='"+Str(fExChRate,-1),oConn}
				oStmnt:Execute()
				if !Empty(oStmnt:Status)
					cError:=self:oLan:WGet("could	no	update sysparms")+'	('+oStmnt:Status:Description+')'
				endif
			endif
			if Empty(cError)
				SQLStatement{"commit",oConn}:Execute()
			else
				SQLStatement{"rollback",oConn}:Execute()
				ErrorBox{self,cError+"; "+self:oLan:WGet("nothing recorded; withdraw file sent to PMC")}:Show()
				return
			ENDIF
			*save period:
			IF self:oSys:PMISLSTSND<Today()-1000
				noIES:=true
			ENDIF

			if PMCUpload
				LogEvent(self,self:oLan:WGet("Uploaded file")+Space(1)+cFilename+Space(1)+self:oLan:WGet("via Insite to PMC")) 
			endif
			// sending by email:
			cPMISMail:=AllTrim(self:oSys:IESMAILACC)
			cPMISMail:=StrTran(cPMISMail,";"+AllTrim(self:oSys:OWNMAILACC))
			cPMISMail:=StrTran(cPMISMail,AllTrim(self:oSys:OWNMAILACC))
			* Send file by email:
			IF IsMAPIAvailable()
				* Resolve IESname
				IF oMapi:Open( "" , "" )
					oPers:=SQLSelect{"select persid,lastname,firstname,email,"+SQLFullName()+" as fullname from person where persid='"+self:oSys:PMCMANCLN+"'",oConn} 
					if oPers:Reccount>0
						if PMCUpload
							oRecip := oMapi:ResolveName( oPers:lastname,oPers:Persid,oPers:fullname,oPers:email)
						else
							oRecip2 := oMapi:ResolveName( oPers:lastname,oPers:Persid,oPers:fullname,oPers:email)
						endif
					endif
					if !PMCUpload
						oRecip := oMapi:ResolveMailName( "Partner Monetary Interchange System",@cPMISMail,"Partner Monetary Interchange System")
					endif
					IF oRecip != null_object .and.(PMCUpload .or.!oRecip2==null_object)
						cNoteText:="Dear "+iif(Empty(oPers:firstname),AllTrim(oPers:lastname),AllTrim(oPers:firstname))+","+CRLF+;
							iif(PMCUpload,;
							self:oLan:RGet("Will you please approve the uploaded OPP file")+Space(1)+FileSpec{cFilename}:Filename+Space(1)+;
							self:oLan:RGet("by going to Insite")+Space(1)+"https://www.pmc.insitehome.org/OPPUpload.aspx";
							,;
							"I send you attached a OPP file and would be grateful if you would approve the file by means of a reply all.")+;
							CRLF+LOGON_EMP_ID
						IF oMapi:SendDocument( iif(PMCUpload,null_object,FileSpec{cFilename}) ,oRecip,oRecip2,"PMC Transactions "+FileSpec{cFilename}:Filename+" of "+sLand,cNoteText)
							(InfoBox{self:OWNER,"Partner Monetary Interchange System",;                                                                  
							self:oLan:WGet("Placed one mail message in the outbox of")+" "+EmailClient+" "+iif(PMCUpload,self:oLan:WGet("for approving of"),self:oLan:WGet("with attached the file"))+": "+cFilename}):Show()
							LogEvent(self,self:oLan:WGet("Placed one PMC mail message in the outbox of")+" "+EmailClient+" "+self:oLan:WGet("with attached the file")+": "+cFilename,"Log")
							lSent:=true
						ENDIF
					ENDIF
					//oMapi:Close()
				ENDIF 
				IF	!lSent
					(InfoBox{self:OWNER,self:oLan:WGet("Partner Monetary Interchange System"),self:oLan:WGet("Generated one file")+":	"+cFilename+" ("+;
						iif(PMCUpload,self:oLan:WGet("Upload this	file via	Insite to PMC"),self:oLan:WGet("mail to PMC mail address")+" "+;
						AllTrim(self:oSys:IESMAILACC)+")")}):Show()	
					LogEvent(self,self:oLan:WGet("Generated one file")+":	"+cFilename+" ("+;
						iif(PMCUpload,self:oLan:WGet("Upload this	file via	Insite to PMC"),self:oLan:WGet("mail to PMC mail address")+" "+;
						AllTrim(self:oSys:IESMAILACC)+")"))
				ENDIF
			endif
		ENDIF
		SetDecimalSep(DecSep)

		IF noIES
			// first time send to PMC, then new menu without IES
			oMainWindow:RefreshMenu()
			oMainWindow:SetCaption()
		ENDIF
		self:EndWindow()
	ENDIF
	if !PMCUpload .and.!lStop
		oMapi:Close()
	endif

	self:Pointer := Pointer{POINTERARROW}
	RETURN
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
