STATIC DEFINE ASKCURRENCY_CURRENCY := 100 
STATIC DEFINE ASKCURRENCY_OKBUTTON := 102 
STATIC DEFINE ASKCURRENCY_SC_SMUNT := 101 
CLASS CurRateBrowser INHERIT DatabrowserExtra
method ColumnFocusChange(oColumn, lHasFocus)   CLASS CurRateBrowser
	LOCAL oCurRt:=self:OWNER:Server as SQLSelect
	LOCAL ThisRec, nErr as int 
	Local myValue as float
	LOCAL myColumn:=oColumn as DataColumn
	SUPER:ColumnFocusChange(oColumn, lHasFocus)
	IF self:OWNER:lFilling  && ingore change column during filling screen
		RETURN
	ENDIF
	ThisRec:=oCurRt:RecNo
	IF myColumn:NameSym == #AED 
		IF !AllTrim(myColumn:VALUE) == AllTrim(Transform(oCurRt:AED,""))
			myColumn:TextValue:= myColumn:VALUE
			oCurRt:AED:=myColumn:VALUE
		endif
	ELSEIF myColumn:NameSym == #AEDUNIT
		IF !AllTrim(myColumn:VALUE) == AllTrim(Transform(oCurRt:AEDUNIT,""))
			myColumn:TextValue:= myColumn:VALUE
			oCurRt:AEDUNIT:=myColumn:VALUE
		endif
	ENDIF
	RETURN nil 
METHOD GetCurCell CLASS CurRateBrowser
	LOCAL oSingle as JapSingleEdit
	LOCAL NwValue as USUAL
	oSingle:=self:oCellEdit
	IF oSingle==null_object
		RETURN {}
	ELSE
		IF IsNumeric(oSingle:VALUE)
			NwValue:=Val(oSingle:CurrentText)
		ELSE
			NwValue:=AllTrim(oSingle:CurrentText)
		ENDIF
		RETURN {NwValue,oSingle:VALUE,Upper(oSingle:Fieldspec:HyperLabel:Name)}
	ENDIF
METHOD Init(oWindow) CLASS CurRateBrowser
	SUPER:Init(oWindow)
	self:ChangeBackground(Brush{Color{255,255,255}},gblHiText)
	self:ChangeTextColor(ColorBlue,gblHiText)
RETURN self
METHOD SetColumnFocus(ColumnSym)  CLASS CurRateBrowser
	// set browser to requird column
	LOCAL oColumn as JapDataColumn
	IF IsSymbol(ColumnSym)
		oColumn := self:GetColumn(ColumnSym)
		RETURN SUPER:SetColumnFocus(oColumn)
	ELSE	
		RETURN SUPER:SetColumnFocus(ColumnSym)
	ENDIF
Class Currency
protect CurTable as array
protect cBaseCur as string  // base currency, normally system currency sCurr 
export mxrate as float 
protect cCurCaption:="Get exchange rate" as string 
export lStopped as logic 
declare method GetROE
Method GetROE(CodeROE as string, DateROE as date, lConfirm:=false as logic, lAsk:=true as logic,nUp:=0 as float) as float class Currency
	// CodeRoe: 3 character currency code
	// date Roe: date aplicable for roe of exchange
	// nUp: optionally percentage to increase rate read from internet (decrease if negative); if <>0 get always rate from internet
	// returns rate of exchange: 1 unit CurCode = ROE base currency
	//
	LOCAL oHttp			as cHttp
	LOCAL cPage			as STRING
	LOCAL cPostData	as STRING
	Local iSt,iEnd as int
	local table as string
	LOCAL oXMLDoc as XMLDocument, lRow,lFound as logic, cAED as string
	LOCAL oExch as GetExchRate 
	local cStatement,RateId as string
	local oStmnt as SQLStatement 
	local lnew as logic
	local oROE as SQLSelect
	
	// check if ROE allready in currency rates:
	if Empty(CodeROE) .or. CodeROE==self:cBaseCur
		return 1
	endif
	if !nUp==0.00
		lnew:=true
	endif
	oROE:=SQLSelect{"select roe,rateid,cast(daterate as date) as daterate from currencyrate where aed='"+CodeROE+"' and daterate='"+SQLdate(DateROE)+"' and aedunit='"+self:cBaseCur+"'",oConn} 
	if oROE:RecCount>0
		RateId:=Str(oROE:RateId,-1) 
		if !Empty(oROE:ROE).and.!lConfirm
			return oROE:ROE
		endif
		self:mxrate:=oROE:ROE
	else
		lnew:=true
		// look for most recent rate:
		oROE:=SQLSelect{"select roe,rateid,cast(daterate as date) as daterate from currencyrate where aed='"+CodeROE+"' and aedunit='"+self:cBaseCur+"' and daterate<='"+SQLdate(DateROE)+"' order by daterate desc limit 1",oConn} 
		if oROE:RecCount>0
			self:mxrate:=oROE:ROE 		
			RateId:=Str(oROE:RateId,-1) 
		else
			// 	search last of currency:
			oROE:=SQLSelect{"select roe,rateid,cast(daterate as date) as daterate from currencyrate where aed='"+CodeROE+"' and aedunit='"+self:cBaseCur+"' order by daterate desc",oConn} 
			if oROE:RecCount>0
				self:mxrate:=oROE:ROE 		
				RateId:=Str(oROE:RateId,-1) 
			endif
		endif
		if	LstCurRate .and.!Empty(self:mxrate)
			if	lConfirm
				lnew:=false
			else
				return self:mxrate
			endif
		endif
	endif
	if lnew
		// try to read from internet 
		oHttp 	:= CHttp{"Wyccavo"}
		cPostData	:= "from="+self:cBaseCur+"&date="+SQLdate(DateROE) 

		cPage 	:= oHttp:GetDocumentByGetOrPost( "www.xe.com",;
			"/currencytables/",;
			cPostData,;
			/*cHeader*/,;
			"POST",;
			/*INTERNET_DEFAULT_HTTPS_PORT*/,;
			/*INTERNET_FLAG_SECURE*/)
		iSt:=At3('xetrade/?utm_source',cPage,10050)
		if iSt>0
			cPage:=SubStr(cPage,iSt) 
			iSt:=At3('<tbody>',cPage,28)+7 			
			iEnd:=At3("</table>",cPage,iSt)+8
			if iEnd>8 
				table:="<table>"+SubStr(cPage,iSt,iEnd-iSt) 
				iEnd:=2
				do while true
					iSt:=At3('<!--',table,2)
					if iSt==0
						exit
					endif 
					iEnd:=At3('-->',table,iSt+5)+3
					if iEnd>3
						table:=Stuff(table,iSt,iEnd-iSt,'') 
					endif
// 					iEnd:=iSt+1
				enddo 
				table:=StrTran(table,CHR(10) +CHR(10),CHR(10))
				table:=Compress(table) 
				oXMLDoc:=XMLDocument{table}
				lRow:=oXMLDoc:GetElement("tr")
				do while lRow
					if oXMLDoc:GetFirstChild()
						cAED:= AllTrim(oXMLDoc:ChildContent)
						if AtC('>'+CodeROE+'<',cAED)>0 
							oXMLDoc:GetNextChild()  // name
							oXMLDoc:GetNextChild()  // inverse rate
							if oXMLDoc:GetNextChild()  // rate
								self:mxrate:=Val( AllTrim(oXMLDoc:ChildContent))*((100.00+nUp)/100.00) 
								lFound:=true
							endif
							exit
						endif
					endif
					lRow:=oXMLDoc:GetNextSibbling()
				enddo 
			endif
		endif
		if !lFound
			LogEvent(self,"exchange rate can't be fetched from www.xe.com","logerrors")
		endif
	endif
	if !lAsk
		return self:mxrate
	endif
	// ask for rate:
	oExch:=GetExchRate{oMainWindow,,,{self:cBaseCur+" ("+DToC(DateROE)+")",CodeROE,self:cCurCaption,self}}
	oExch:Show()  && mxrate will be filled in by oExch
	if oExch:lStopped
		self:lStopped:=true
		return self:mxrate
	endif
	
	IF Empty(self:mxrate)
		self:mxrate:=1
	ENDIF
	if LstCurRate .and.!lnew
		if self:mxrate = oROE:ROE
			return self:mxrate
		elseif DateROE # oROE:DATERATE
			lnew:=true
		endif
	endif
	cStatement:=iif(lnew,"insert into","update")+" currencyrate set "+;
		"aed='"+CodeROE+"',"+;
		"daterate='"+SQLdate(DateROE)+"',"+;
		"roe="+Str(self:mxrate,-1)+;
		",aedunit='"+sCURR+"'"+;
		iif(lnew,""," where rateid="+RateId) 
	oStmnt:=SQLStatement{cStatement,oConn}
	oStmnt:Execute()
	return self:mxrate
Method Init(cCaption, cBase) class Currency
Default(@cCaption,"Get exchange rate") 
Default(@cBase,sCURR)
self:cCurCaption:=cCaption 
self:cBaseCur:=cBase
return self
RESOURCE CurrencySpec DIALOGEX  4, 3, 282, 26
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", CURRENCYSPEC_CURRENCY, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 76, 7, 134, 185
	CONTROL	"System Currency:", CURRENCYSPEC_SC_SMUNT, "Static", WS_CHILD, 4, 7, 66, 12
	CONTROL	"OK", CURRENCYSPEC_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 220, 7, 53, 12
END

CLASS CurrencySpec INHERIT DataDialogMine 

	PROTECT oDCCurrency AS COMBOBOX
	PROTECT oDCSC_SMUNT AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  instance CURRENCY as string 
  
ACCESS Currency() CLASS CurrencySpec
RETURN SELF:FieldGet(#Currency)

ASSIGN Currency(uValue) CLASS CurrencySpec
SELF:FieldPut(#Currency, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS CurrencySpec 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"CurrencySpec",_GetInst()},iCtlID)

oDCCurrency := combobox{SELF,ResourceID{CURRENCYSPEC_CURRENCY,_GetInst()}}
oDCCurrency:HyperLabel := HyperLabel{#Currency,NULL_STRING,"Default currency for this organisation","Currency_Smunt"}
oDCCurrency:FillUsing(SQLSelect{"select united_ara,aed from currencylist",oConn}:getLookupTable(300,#UNITED_ARA,#AED))

oDCSC_SMUNT := FixedText{SELF,ResourceID{CURRENCYSPEC_SC_SMUNT,_GetInst()}}
oDCSC_SMUNT:HyperLabel := HyperLabel{#SC_SMUNT,"System Currency:",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{CURRENCYSPEC_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

SELF:Caption := "Specify currency for your system:"
SELF:HyperLabel := HyperLabel{#CurrencySpec,"Specify currency for your system:",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS CurrencySpec
if Empty(self:oDCCurrency:CurrentItemNo)
	(ErrorBox{,self:oLan:WGet("Select a currency")}):Show()
	return
endif
sCurr:=self:oDCCurrency:GetItemValue(self:oDCCurrency:CurrentItemNo)
self:EndWindow() 
RETURN NIL
method PostInit(oWindow,iCtlID,oServer,uExtra) class CurrencySpec
	//Put your PostInit additions here 
	local oSys as SQLSElect
self:SetTexts() 
if IsString(uExtra)
	self:Currency:=uExtra
else
	oSys:=SQLSelect{"select currency from sysparms limit 1", oConn}
	if oSys:RecCount>0
		if !Empty(oSys:Currency)
			self:Currency :=oSys:Currency
		endif
	endif
endif

	return nil
STATIC DEFINE CURRENCYSPEC_CURRENCY := 100 
STATIC DEFINE CURRENCYSPEC_OKBUTTON := 102 
STATIC DEFINE CURRENCYSPEC_SC_SMUNT := 101 
CLASS CurrRateEditor INHERIT DataWindowMine 

	PROTECT oDCCurrencySelect AS COMBOBOX
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCLastCurRate AS RADIOBUTTONGROUP
	PROTECT oCCRadioButtonDaily AS RADIOBUTTON
	PROTECT oCCRadioButtonRecent AS RADIOBUTTON
	PROTECT oSFSub_Rates AS Sub_Rates

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)  
  export oRoe as SQLSelect
  
RESOURCE CurrRateEditor DIALOGEX  4, 12, 303, 268
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", CURRRATEEDITOR_SUB_RATES, "static", WS_CHILD|WS_BORDER, 4, 59, 284, 199
	CONTROL	"", CURRRATEEDITOR_CURRENCYSELECT, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 48, 36, 111, 167
	CONTROL	"Currency:", CURRRATEEDITOR_FIXEDTEXT1, "Static", WS_CHILD, 4, 36, 40, 13
	CONTROL	"Use this table in calculations as follows", CURRRATEEDITOR_LASTCURRATE, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 0, 260, 33
	CONTROL	"Ask for daily rate", CURRRATEEDITOR_RADIOBUTTONDAILY, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 12, 7, 80, 11
	CONTROL	"Use most recent date before required date", CURRRATEEDITOR_RADIOBUTTONRECENT, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 12, 18, 188, 11
END

METHOD append() CLASS CurrRateEditor
	LOCAL cCurr,cUnit as STRING
	Local fRate as Float
	LOCAL oCurRt:=self:Server as SQLSelect
	local oStmnt as SQLStatement 
	local oCurr as Currency
// 	IF !oCurRt:Reccount<1
// 		oCurRt:GoTop()
// 		cCurr:=oCurRt:AED 
// 		cUnit:=oCurRt:AEDUNIT
// 		oCurr:=Currency{'',cUnit}
// 		fRate:=oCurr:GetROE(cCurr,Today(),false,false) 
// 		// 		fRate:=oCurRt:ROE 
// 		// 		if Empty(fRate)
// 		// 			fRate:=1.00
// 		// 		endif
// 		oCurRt:GoBottom()
// 	ENDIF
// 	oStmnt:=SQLStatement{"insert into currencyrate set aed='"+cCurr+"',AEDUNIT='"+cUnit+"',DATERATE='"+SQLdate(Today())+"',roe="+Str(fRate,19,10),oConn}
// 	oStmnt:Execute()
// 	if oStmnt:NumSuccessfulRows>0
// 		oCurRt:Execute()
// 		self:oSFSub_Rates:Browser:refresh()
// 		// 	self:oSFSub_Rates:append()
// 		//  	self:oSFSub_Rates:GoTop()
// 		// 	self:oSFSub_Rates:AED:=cCurr
// 		// 	self:oSFSub_Rates:AEDUNIT:=cUnit
// 		// 	self:oSFSub_Rates:DATERATE:=Today()
// 		// 	self:oSFSub_Rates:ROE:=fRate
// 		// 	oCurRt:AED:=cCurr
// 		// 	oCurRt:AEDUNIT:=cUnit
// 		// 	oCurRt:DATERATE:=SQLdate(Today())
// 		// 	oCurRt:ROE:=fRate
// 		// 	self:oSFSub_Rates:GoTop()
// 	else
		self:oSFSub_Rates:GoBottom()
		self:oSFSub_Rates:append()
		self:oSFSub_Rates:GoBottom()
// 	endif
	RETURN FALSE
method ButtonClick(oControlEvent) class CurrRateEditor
	local oControl as Control 
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:ButtonClick(oControlEvent)
	//Put your changes here 
	IF oControl:Name=="RADIOBUTTONDAILY" .or.oControl:Name=="RADIOBUTTONRECENT"
		if oControl:Name=="RADIOBUTTONDAILY" .and. LstCurRate .or. oControl:Name=="RADIOBUTTONRECENT" .and.!LstCurRate
			LstCurRate:=!LstCurRate  
			SQLStatement{"update sysparms set LSTCURRT="+iif(LstCurRate,'1','0'),oConn}:execute()
		endif
	endif
			

	return NIL
ACCESS CurrencySelect() CLASS CurrRateEditor
RETURN SELF:FieldGet(#CurrencySelect)

ASSIGN CurrencySelect(uValue) CLASS CurrRateEditor
SELF:FieldPut(#CurrencySelect, uValue)
RETURN uValue

METHOD DELETE() CLASS CurrRateEditor
	* delete record of TempTrans:
	LOCAL ThisRec, CurRec as int
	LOCAL oCurRt:=self:Server as SQLSelect
	LOCAL Success as LOGIC 
	local oStmnt as SQLStatement

	CurRec:=oCurRt:Recno
	if oCurRt:RecCount<1  && nothing to delete?
		return
	endif

	IF !Empty(CurRec)
		oStmnt:=SQLStatement{"delete from currencyrate where rateid="+str(oCurRt:rateid,-1),Oconn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows>0
			oCurRt:Execute()  
			// 	self:DELETE()
			// 	self:GoBottom()
			// 	self:GoTop()
			// 	IF oCurRt:eof
			// 		oCurRt:GoTop()
			// 	ENDIF 
			self:oSFSub_Rates:Browser:refresh()
			if CurRec>oCurRt:Reccount
				CurRec--
			endif
			self:GoTo(CurRec) 
		endif
	ENDIF
	RETURN true
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS CurrRateEditor 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"CurrRateEditor",_GetInst()},iCtlID)

oDCCurrencySelect := combobox{SELF,ResourceID{CURRRATEEDITOR_CURRENCYSELECT,_GetInst()}}
oDCCurrencySelect:TooltipText := "Select required currency of which rates should be shown"
oDCCurrencySelect:HyperLabel := HyperLabel{#CurrencySelect,NULL_STRING,NULL_STRING,NULL_STRING}
oDCCurrencySelect:FillUsing(SQLSelect{"select united_ara,aed from currencylist",oConn}:getLookupTable(300,#UNITED_ARA,#AED))

oDCFixedText1 := FixedText{SELF,ResourceID{CURRRATEEDITOR_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Currency:",NULL_STRING,NULL_STRING}

oCCRadioButtonDaily := RadioButton{SELF,ResourceID{CURRRATEEDITOR_RADIOBUTTONDAILY,_GetInst()}}
oCCRadioButtonDaily:HyperLabel := HyperLabel{#RadioButtonDaily,"Ask for daily rate",NULL_STRING,NULL_STRING}

oCCRadioButtonRecent := RadioButton{SELF,ResourceID{CURRRATEEDITOR_RADIOBUTTONRECENT,_GetInst()}}
oCCRadioButtonRecent:HyperLabel := HyperLabel{#RadioButtonRecent,"Use most recent date before required date",NULL_STRING,NULL_STRING}

oDCLastCurRate := RadioButtonGroup{SELF,ResourceID{CURRRATEEDITOR_LASTCURRATE,_GetInst()}}
oDCLastCurRate:FillUsing({ ;
							{oCCRadioButtonDaily,".F."}, ;
							{oCCRadioButtonRecent,".T."} ;
							})
oDCLastCurRate:HyperLabel := HyperLabel{#LastCurRate,"Use this table in calculations as follows",NULL_STRING,NULL_STRING}

SELF:Caption := "Currency Browser"
SELF:HyperLabel := HyperLabel{#CurrRateEditor,"Currency Browser",NULL_STRING,NULL_STRING}
SELF:Menu := WOBrowserMENU{}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
SELF:ViewAs(#FormView)

oSFSub_Rates := Sub_Rates{SELF,CURRRATEEDITOR_SUB_RATES}
oSFSub_Rates:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS LastCurRate() CLASS CurrRateEditor
RETURN SELF:FieldGet(#LastCurRate)

ASSIGN LastCurRate(uValue) CLASS CurrRateEditor
SELF:FieldPut(#LastCurRate, uValue)
RETURN uValue

method ListBoxSelect(oControlEvent) class CurrRateEditor
	local oControl as Control
	local oCr:=self:oSFSub_Rates:Server as SQLSelect
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	super:ListBoxSelect(oControlEvent)
	//Put your changes here 
	IF oControl:NameSym==#CurrencySelect
	   self:oROE:SQLString:="select rateid,aed,cast(daterate as date) as daterate,roe,aedunit from currencyrate where aed='"+oControl:Value+"' and daterate<=Now() order by aed asc,aedunit asc, daterate desc"
		self:oROE:Execute()
		self:GoTop()
		self:oSFSub_Rates:Browser:refresh()
	endif
	return nil
method PostInit(oWindow,iCtlID,oServer,uExtra) class CurrRateEditor
	//Put your PostInit additions here 
// 	self:Server:aMirror:={{" "," ",0.00}}
	self:oSFSub_Rates:lFilling:=false
	self:LastCurRate:=LstCurRate 
	self:SetTexts()
	
	return NIL
method PreInit(oWindow,iCtlID,oServer,uExtra) class CurrRateEditor
	//Put your PreInit additions here 
	self:oROE:=SQLSelect{"select rateid,aed,cast(daterate as date) as daterate,roe,aedunit from currencyrate order by aed asc,aedunit asc, daterate desc",oConn}
	return nil
STATIC DEFINE CURRRATEEDITOR_CURRENCYSELECT := 101 
STATIC DEFINE CURRRATEEDITOR_FIXEDTEXT1 := 102 
STATIC DEFINE CURRRATEEDITOR_LASTCURRATE := 103 
STATIC DEFINE CURRRATEEDITOR_RADIOBUTTONDAILY := 104 
STATIC DEFINE CURRRATEEDITOR_RADIOBUTTONRECENT := 105 
STATIC DEFINE CURRRATEEDITOR_SUB_RATES := 100 
CLASS ExchangeRate INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExchangeRate
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#ExchangeRate, "International dollar exchange rate", "", "" },  "N", 18, 10 )
    cPict       := "9999999.9999999999"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




RESOURCE GetExchRate DIALOGEX  14, 11, 256, 50
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", GETEXCHRATE_MEXCHRATE, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 7, 64, 12, WS_EX_CLIENTEDGE
	CONTROL	"Exchange rate: 1 ", GETEXCHRATE_ROETEXT1, "Static", WS_CHILD, 8, 7, 57, 12
	CONTROL	"OK", GETEXCHRATE_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 190, 32, 54, 12
	CONTROL	"", GETEXCHRATE_CURNAME, "Static", WS_CHILD, 160, 7, 88, 12
	CONTROL	"USD = ", GETEXCHRATE_ROETEXT2, "Static", WS_CHILD, 64, 7, 28, 13
END

CLASS GetExchRate INHERIT DataDialogMine 

	PROTECT oDCmExchRate AS MYSINGLEEDIT
	PROTECT oDCROEText1 AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCCurName AS FIXEDTEXT
	PROTECT oDCROEText2 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  	instance mExchRate
  	protect oOwner as OBJECT
  	Export lStopped:=true as logic 
method Close(oEvent) class GetExchRate
	super:Close(oEvent)
	//Put your changes here 
	IF Empty(mExchRate)
		self:OWNER:mxrate:=0
	endif
	return 
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS GetExchRate 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"GetExchRate",_GetInst()},iCtlID)

oDCmExchRate := mySingleEdit{SELF,ResourceID{GETEXCHRATE_MEXCHRATE,_GetInst()}}
oDCmExchRate:TooltipText := "Give dollar exchange rate"
oDCmExchRate:HyperLabel := HyperLabel{#mExchRate,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmExchRate:FieldSpec := EXCHANGERATE{}
oDCmExchRate:Picture := "9999999.9999999999"

oDCROEText1 := FixedText{SELF,ResourceID{GETEXCHRATE_ROETEXT1,_GetInst()}}
oDCROEText1:HyperLabel := HyperLabel{#ROEText1,"Exchange rate: 1 ",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{GETEXCHRATE_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oDCCurName := FixedText{SELF,ResourceID{GETEXCHRATE_CURNAME,_GetInst()}}
oDCCurName:HyperLabel := HyperLabel{#CurName,NULL_STRING,NULL_STRING,NULL_STRING}

oDCROEText2 := FixedText{SELF,ResourceID{GETEXCHRATE_ROETEXT2,_GetInst()}}
oDCROEText2:HyperLabel := HyperLabel{#ROEText2,"USD = ",NULL_STRING,NULL_STRING}

SELF:Caption := "Sending To PMC"
SELF:HyperLabel := HyperLabel{#GetExchRate,"Sending To PMC",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mExchRate() CLASS GetExchRate
RETURN SELF:FieldGet(#mExchRate)

ASSIGN mExchRate(uValue) CLASS GetExchRate
SELF:FieldPut(#mExchRate, uValue)
RETURN uValue

METHOD OKButton( ) CLASS GetExchRate
	IF Empty(mExchRate)
		(ErrorBox{self:OWNER,self:oLan:WGet("Zero value not allowed")}):Show()
		RETURN
	ENDIF
self:oOwner:mxrate:=mExchRate 
self:lStopped:=false
SELF:EndWindow()
RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS GetExchRate
	//Put your PostInit additions here
	self:SetTexts()
	self:Pointer := Pointer{POINTERARROW}
   oDCCurName:TextValue:=uExtra[1]
   if Len(uExtra)>1
    	self:oDCROEText2:TextValue:=AllTrim(uExtra[2])+" =" 
   endif
   if Len(uExtra)>2
	   self:Caption:=AllTrim(uExtra[3])
   endif
   if Len(uExtra)>3
   	oOwner:=uExtra[4]
   else
   	oOwner:=self:owner
   endif
	mExchRate:=	self:oOwner:mxrate
   
	RETURN NIL
STATIC DEFINE GETEXCHRATE_CURNAME := 103 
STATIC DEFINE GETEXCHRATE_MEXCHRATE := 100 
STATIC DEFINE GETEXCHRATE_OKBUTTON := 102 
STATIC DEFINE GETEXCHRATE_ROETEXT1 := 101 
STATIC DEFINE GETEXCHRATE_ROETEXT2 := 104 
Class Reevaluation
	Protect oCall as Object
	Export mxrate as Float
Method Close() Class Reevaluation
self:oCall:Pointer := Pointer{POINTERARROW}
Method Init(oWindow) class Reevaluation
self:oCall:=oWindow
return self
Method ReEvaluate() Class Reevaluation
	local UltimoMonth,UltimoYear as date
	local oAccnt,oSys,oBal as SQLSelect, oMBal as Balances, oTrans as SQLStatement
	Local oCurr as Currency 
	Local CurRate,mDiff, mDiff1, mDiff2 as float, TransId, cStatement as string 
	LOCAL first:=true as LOGIC
	Local aROE:={} as Array
	local aBalYr:={} as array 
	Local cCur as string, nCurPntr as int 
	local lError as logic
	Local cSm:="Busy with reevaluation foreign currency accounts" as string
	local cFatalError as string
	
	oSys:=SQLSelect{"select cast(lstreeval as date) as lstreeval from sysparms where DATE_ADD(lstreeval,INTERVAL 38 DAY)<curdate()",oConn} 
	if oSys:RecCount<1
		self:Close()
		Return
	endif
	UltimoMonth:=SToD(SubStr(DToS(Today()),1,6)+"01")-1 
	aBalYr:=GetBalYear(Year(Today())-1,Month(Today()))
	UltimoYear:=stod(str(aBalYr[3],4,0)+strzero(aBalYr[4],2)+strzero(MonthEnd(aBalYr[3],aBalYr[4]),2))	
	if oSys:lstreeval < UltimoYear .and. UltimoMonth> UltimoYear
		UltimoMonth:=UltimoYear
	endif
	oCurr:=Currency{"Reevaluation"}
	self:oCall:Pointer := Pointer{POINTERHOURGLASS}
	oAccnt:=SQLSelect{"select a.accid,a.accnumber,a.currency,a.gainlsacc,b.category as type from account a, balanceitem b "+;
	"where reevaluate=1 and gainlsacc>0 and b.balitemid=a.balitemid",oConn} 
	if oAccnt:RecCount>0
		if ((TextBox{oCall,"Reevaluation of foreign currency accounts","Do you want to reevaluate up till date "+DToC(UltimoMonth),BUTTONYESNO+BOXICONQUESTIONMARK}):Show() == BOXREPLYNO)
			self:Close() 
			return
		endif
		oCall:STATUSMESSAGE(cSm)
	ENDIF
	// Check first consistency data
	CheckConsistency(oMainWindow,true,false,@cFatalError)

	oMBal:=Balances{}
	do while !oAccnt:EoF 
		cCur:= oAccnt:Currency
		// determine balance in foreign currency:
		oMBal:GetBalance(Str(oAccnt:accid,-1),,UltimoMonth,cCur)
		if oMBal:per_debF # 0 .or. oMBal:per_creF # 0
			// calculate new balance in local currency: 
			if (nCurPntr:=AScan(aROE,{|x|x[1]== cCur}))>0
				CurRate:=aROE[nCurPntr,2]
			else
				mxrate:=oCurr:GetROE(cCur,UltimoMonth,true) 
				CurRate:=mxrate
				AAdd(aROE,{cCur,CurRate})
			endif
			if CurRate > 0
				lError:=true
				mDiff1:=Round((oMBal:per_creF - oMBal:per_debF)*CurRate,DecAantal)
				// determine old balance in local currency:
				mDiff2:=Round(oMBal:per_cre - oMBal:per_deb,DecAantal)
				mDiff:=Round(mDiff1 - mDiff2,DecAantal) 
				if mDiff <> 0
					SQLStatement{"start transaction",oConn}:Execute()
					oBal:=SQLSelect{"select mbalid from mbalance where accid in ("+Str(oAccnt:GAINLSACC,-1)+','+Str(oAccnt:accid,-1)+")"+;
					" and	year="+Str(Year(UltimoMonth),-1)+;
					" and	month="+Str(Month(UltimoMonth),-1)+" order by mbalid for update",oConn}
					if	!Empty(oBal:status)
						ErrorBox{self,self:oLan:WGet("balance records locked by someone else")}:Show()
						SQLStatement{"rollback",oConn}:Execute()
						return 
					endif	  

					cStatement:="insert into transaction set "+;
						"accid='"+Str(oAccnt:GAINLSACC,-1)+"'"+;
						",dat='"+SQLdate(UltimoMonth)+"'"+;
						",deb='"+Str(mDiff,-1)+"'"+;
						",currency='"+sCURR+"'"+;
						",description='Reevaluation with ROE "+Str(CurRate,-1)+"'"+;
						",seqnr=1"+;
						",bfm='C'"   // regard as allready sent to CMS/AccPac
					oTrans:=SQLStatement{cStatement,oConn}
					oTrans:Execute()
					if oTrans:NumSuccessfulRows>0
						TransId:=ConS(SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
						cStatement:="insert into transaction set "+;
							"accid='"+Str(oAccnt:accid,-1)+"'"+;
							",seqnr=2"+;
							",dat='"+SQLdate(UltimoMonth)+"'"+;
							",transid='"+TransId+"'"+; 
							",cre='"+Str(mDiff,-1)+"'"+;
							",currency='"+cCur+"'"+;
							",description='Reevaluation with ROE "+Str(CurRate,-1)+"'"+;
							",bfm='C'"   // regard as allready sent to CMS/AccPac
						oTrans:=SQLStatement{cStatement,oConn}
						oTrans:Execute()
						if oTrans:NumSuccessfulRows>0
							if ChgBalance(Str(oAccnt:GAINLSACC,-1),UltimoMonth,mDiff,0,0,0,sCURR)
								if ChgBalance(Str(oAccnt:accid,-1),UltimoMonth,0,mDiff,0,0,cCur)
									SQLStatement{"commit",oConn}:Execute()
									lError:=false
								endif
							endif
						endif
					endif
               if lError
     					LogEvent(self,"Error:"+oTrans:SQLString,"LogErrors")
						ErrorBox{self:oCall,"reevaluation transaction for account "+oAccnt:accnumber+"could not be stored"}:Show()
						SQLStatement{"rollback",oConn}:Execute()
						return
               endif
				endif						
			endif
		endif
		oCall:STATUSMESSAGE(cSm+=".")

		oAccnt:Skip()
	enddo 
	SQLStatement{"update sysparms set lstreeval='"+SQLdate(UltimoMonth)+"'",oConn}:Execute()
	self:Close() 


	return 
RESOURCE Sub_Rates DIALOGEX  2, 2, 277, 183
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

CLASS Sub_Rates INHERIT DataWindowMine 

	PROTECT oDBAED as JapDataColumn
	PROTECT oDBDATERATE as JapDataColumn
	PROTECT oDBROE as JapDataColumn
	PROTECT oDBAEDUNIT as JapDataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  export lFilling:=true as logic 
ACCESS AED() CLASS Sub_Rates
RETURN SELF:FieldGet(#AED)

ASSIGN AED(uValue) CLASS Sub_Rates
SELF:FieldPut(#AED, uValue)
RETURN uValue

ACCESS AEDUNIT() CLASS Sub_Rates
RETURN SELF:FieldGet(#AEDUNIT)

ASSIGN AEDUNIT(uValue) CLASS Sub_Rates
SELF:FieldPut(#AEDUNIT, uValue)
RETURN uValue

ACCESS DATERATE() CLASS Sub_Rates
RETURN SELF:FieldGet(#DATERATE)

ASSIGN DATERATE(uValue) CLASS Sub_Rates
SELF:FieldPut(#DATERATE, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS Sub_Rates 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"Sub_Rates",_GetInst()},iCtlID)

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#Sub_Rates,"DataWindow Caption",NULL_STRING,NULL_STRING}
SELF:OwnerAlignment := OA_PWIDTH_PHEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := CurRateBrowser{self}

oDBAED := JapDataColumn{17}
oDBAED:Width := 17
oDBAED:HyperLabel := HyperLabel{#AED,"Currency",NULL_STRING,NULL_STRING} 
oDBAED:Caption := "Currency"
self:Browser:AddColumn(oDBAED)

oDBDATERATE := JapDataColumn{CurrencyRate_DATERATE{}}
oDBDATERATE:Width := 17
oDBDATERATE:HyperLabel := HyperLabel{#DATERATE,"Date",NULL_STRING,NULL_STRING} 
oDBDATERATE:Caption := "Date"
self:Browser:AddColumn(oDBDATERATE)

oDBROE := JapDataColumn{ExchangeRate{}}
oDBROE:Width := 17
oDBROE:HyperLabel := HyperLabel{#ROE,"Rate",NULL_STRING,NULL_STRING} 
oDBROE:Caption := "Rate"
self:Browser:AddColumn(oDBROE)

oDBAEDUNIT := JapDataColumn{15}
oDBAEDUNIT:Width := 15
oDBAEDUNIT:HyperLabel := HyperLabel{#AEDUNIT,"Unit",NULL_STRING,NULL_STRING} 
oDBAEDUNIT:Caption := "Unit"
self:Browser:AddColumn(oDBAEDUNIT)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method PostInit(oWindow,iCtlID,oServer,uExtra) class Sub_Rates
	//Put your PostInit additions here
	self:GoTop()
	return nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class Sub_Rates
	//Put your PreInit additions here 
	oWindow:Use(oWindow:oRoe)
	return nil
ACCESS ROE() CLASS Sub_Rates
RETURN SELF:FieldGet(#ROE)

ASSIGN ROE(uValue) CLASS Sub_Rates
SELF:FieldPut(#ROE, uValue)
RETURN uValue

STATIC DEFINE SUB_RATES_AED := 100 
STATIC DEFINE SUB_RATES_AEDUNIT := 103 
STATIC DEFINE SUB_RATES_DATERATE := 101 
STATIC DEFINE SUB_RATES_ROE := 102 
