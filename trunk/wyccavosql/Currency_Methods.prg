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
		IF !AllTrim(myColumn:VALUE) == AllTrim(oCurRt:AED)
			myColumn:TextValue:= myColumn:VALUE
			oCurRt:AED:=myColumn:VALUE
		endif
	ELSEIF myColumn:NameSym == #AEDUNIT
		IF !AllTrim(myColumn:VALUE) == AllTrim(oCurRt:AEDUNIT)
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
Method GetROE(CodeROE as string, DateROE as date, lConfirm:=false as logic) as float class Currency
	// CodeRoe: 3 character currency code
	// date Roe: date aplicable for roe of exchange
	// returns rate of exchange: 1 unit CurCode = ROE base currency
	//
	LOCAL oHttp			as cHttp
	LOCAL cPage			as STRING
	LOCAL cPostData	as STRING
	Local iSt,iEnd as int
	local table as string
	LOCAL oXMLDoc as XMLDocument, lRow as logic, cAED as string
	LOCAL oExch as GetExchRate 
	local cStatement,RateId as string
	local oStmnt as SQLStatement 
	local lnew as logic
	local oROE as SQLSelect
	
	// check if ROE allready in currency rates:
	if Empty(CodeROE)
		return 1
	endif
	oROE:=SQLSelect{"select * from CurrencyRate where aed='"+CodeROE+"' and daterate='"+SQLdate(DateROE)+"' and aedunit='"+self:cBaseCur+"'",oConn} 
	if oROE:RecCount>0
		RateId:=Str(oROE:RateId,-1) 
		if !Empty(oROE:ROE).and.!lConfirm
			return oROE:ROE
		endif
		self:mxrate:=oROE:ROE
	else
		lnew:=true
		// look for most recent rate:
		oROE:=SQLSelect{"select * from CurrencyRate where aed='"+CodeROE+"' and aedunit='"+self:cBaseCur+"' and daterate<='"+SQLdate(DateROE)+"' order by DATERATE desc limit 1",oConn} 
		if oROE:RecCount>0
			self:mxrate:=oROE:ROE 		
			RateId:=Str(oROE:RateId,-1) 
		else
			// 	search last of currency:
			oROE:=SQLSelect{"select * from CurrencyRate where aed='"+CodeROE+"' and aedunit='"+self:cBaseCur+"' order by DATERATE desc",oConn} 
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
		cPostData	:= "basecur="+self:cBaseCur+"&historical=true&month="+Str(Month(DateROE),-1)+"&day="+Str(Day(DateROE),-1)+"&year="+Str(Year(DateROE),-1)+"&sort_by=code&image=Submit" 

		cPage 	:= oHttp:GetDocumentByGetOrPost( "www.xe.com",;
			"/ict/",;
			cPostData,;
			/*cHeader*/,;
			"POST",;
			/*INTERNET_DEFAULT_HTTPS_PORT*/,;
			/*INTERNET_FLAG_SECURE*/)

		iSt:=At3(cBaseCur+' per Unit<hr /></td></tr>',cPage,1200)+28 
		iEnd:=At3("</table>",cPage,iSt)+8 
		table:="<table>"+SubStr(cPage,iSt,iEnd-iSt) 
		iEnd:=2
		do while true
			iSt:=At3('<!--',table,iEnd)
			if iSt==0
				exit
			endif 
			iEnd:=At3('-->',table,iSt+5)+3
			if iEnd>0
				table:=Stuff(table,iSt,iEnd-iSt,'')
			endif
			iEnd:=iSt+1
		enddo 
		table:=StrTran(table,CHR(10) +CHR(10),CHR(10))
		table:=Compress(table)
		oXMLDoc:=XMLDocument{table}
		lRow:=oXMLDoc:GetElement("tr")
		do while lRow
			if oXMLDoc:GetFirstChild()
				cAED:= AllTrim(oXMLDoc:ChildContent)
				if cAED == CodeROE
					oXMLDoc:GetNextChild()  // name
					oXMLDoc:GetNextChild()  // inverse rate
					if oXMLDoc:GetNextChild()  // rate
						self:mxrate:=Val( AllTrim(oXMLDoc:ChildContent)) 
					endif
					exit
				endif
			endif
			lRow:=oXMLDoc:GetNextSibbling()
		enddo
	endif
	// ask for rate:
	oExch:=GetExchRate{,,,{self:cBaseCur+" ("+DToC(DateROE)+")",CodeROE,self:cCurCaption,self}}
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
	cStatement:=iif(lnew,"Insert into","update")+" CurrencyRate set "+;
		"AED='"+CodeROE+"',"+;
		"DATERATE='"+SQLdate(DateROE)+"',"+;
		"ROE="+Str(self:mxrate,-1)+;
		",AEDUNIT='"+sCURR+"'"+;
		iif(lnew,""," where RateId="+RateId) 
	oStmnt:=SQLStatement{cStatement,oConn}
	oStmnt:Execute()
	return self:mxrate
Method Init(cCaption, cBase) class Currency
Default(@cCaption,"Get exchange rate") 
Default(@cBase,sCURR)
self:cCurCaption:=cCaption 
self:cBaseCur:=cBase
return self
CLASS CurrencySpec INHERIT DataDialogMine 

	PROTECT oDCCurrency AS COMBOBOX
	PROTECT oDCSC_SMUNT AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  instance CURRENCY as string
  
  declare method GetCurrencies
RESOURCE CurrencySpec DIALOGEX  4, 3, 282, 25
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", CURRENCYSPEC_CURRENCY, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 76, 0, 134, 118
	CONTROL	"System Currency:", CURRENCYSPEC_SC_SMUNT, "Static", WS_CHILD, 4, 7, 66, 12
	CONTROL	"OK", CURRENCYSPEC_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 222, 3, 53, 12
END

ACCESS Currency() CLASS CurrencySpec
RETURN SELF:FieldGet(#Currency)

ASSIGN Currency(uValue) CLASS CurrencySpec
SELF:FieldPut(#Currency, uValue)
RETURN uValue
method GetCurrencies(dummy:=nil as logic) class CurrencySpec
local oCur as SQLSelect
oCur:=SQLSelect{"select united_ara,aed from currencylist",oConn}
if oCur:RecCount>0
	return oCur:GetLookupTable(300,#UNITED_ARA,#AED)
else
	return {}
endif
// return SQLSelect{"select UNITED_ARA,AED from CurrencyList",oConn}:getLookupTable(300,#UNITED_ARA,#AED)
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS CurrencySpec 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"CurrencySpec",_GetInst()},iCtlID)

oDCCurrency := combobox{SELF,ResourceID{CURRENCYSPEC_CURRENCY,_GetInst()}}
oDCCurrency:HyperLabel := HyperLabel{#Currency,NULL_STRING,"Default currency for this organisation","Currency_Smunt"}
oDCCurrency:FillUsing(Self:GetCurrencies( ))

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
CLASS CurrRateEditor INHERIT DATAWINDOW 

	PROTECT oDCCurrencySelect AS COMBOBOX
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCLastCurRate AS RADIOBUTTONGROUP
	PROTECT oCCRadioButtonDaily AS RADIOBUTTON
	PROTECT oCCRadioButtonRecent AS RADIOBUTTON
	PROTECT oSFSub_Rates AS Sub_Rates

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)  
  export oRoe as SQLSelect
  
  declare method GetCurrencies
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
	IF !oCurRt:eof
		oCurRt:GoTop()
		cCurr:=oCurRt:AED 
		cUnit:=oCurRt:AEDUNIT 
		fRate:=oCurRt:ROE 
		if Empty(fRate)
			fRate:=1.00
		endif
		oCurRt:GoBottom()
	ENDIF
	
	self:oSFSub_Rates:append()
	oCurRt:AED:=cCurr
	oCurRt:AEDUNIT:=cUnit
	oCurRt:DATERATE:=Today()
	oCurRt:ROE:=fRate	
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

CurRec:=oCurRt:Recno
if oCurRt:RecCount<1  && nothing to delete?
	return
endif

IF !Empty(CurRec) 
	self:oSFSub_Rates:DELETE(true)
	IF oCurRt:eof
		oCurRt:GoTop()
	ENDIF 
	self:oSFSub_Rates:Browser:REFresh()
ENDIF
RETURN true
method GetCurrencies(dummy:=nil as logic) class CurrRateEditor
return SQLSelect{"select UNITED_ARA,AED from CurrencyList",oConn}:getLookupTable(300,#UNITED_ARA,#AED)
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS CurrRateEditor 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"CurrRateEditor",_GetInst()},iCtlID)

oDCCurrencySelect := combobox{SELF,ResourceID{CURRRATEEDITOR_CURRENCYSELECT,_GetInst()}}
oDCCurrencySelect:TooltipText := "Select required currency of which rates should be shown"
oDCCurrencySelect:HyperLabel := HyperLabel{#CurrencySelect,NULL_STRING,NULL_STRING,NULL_STRING}
oDCCurrencySelect:FillUsing(Self:GetCurrencies( ))

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
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:ListBoxSelect(oControlEvent)
	//Put your changes here 
	IF oControl:NameSym==#CurrencySelect
	   self:oRoe:SQLString:="select * from Currencyrate where aed='"+oControl:Value+"' and DATERATE<=Now() order by aed asc,aedunit asc, daterate desc"
		self:oRoe:Execute()
		self:GoTop()
		self:oSFSub_Rates:Browser:refresh()
	endif
	return NIL
method PostInit(oWindow,iCtlID,oServer,uExtra) class CurrRateEditor
	//Put your PostInit additions here 
// 	self:Server:aMirror:={{" "," ",0.00}}
	self:oSFSub_Rates:lFilling:=false
	self:LastCurRate:=LstCurRate
	
	return NIL
method PreInit(oWindow,iCtlID,oServer,uExtra) class CurrRateEditor
	//Put your PreInit additions here 
   self:oRoe:=SQLSelect{"select * from Currencyrate order by aed asc,aedunit asc, daterate desc",oConn}
	return NIL
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

    SUPER:Init( HyperLabel{#ExchangeRate, "International dollar exchange rate", "", "" },  "N", 12, 8 )
    cPict       := "99999.9999999999"
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

	PROTECT oDCmExchRate AS SINGLELINEEDIT
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

oDCmExchRate := SingleLineEdit{SELF,ResourceID{GETEXCHRATE_MEXCHRATE,_GetInst()}}
oDCmExchRate:TooltipText := "Give dollar exchange rate"
oDCmExchRate:HyperLabel := HyperLabel{#mExchRate,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmExchRate:FieldSpec := EXCHANGERATE{}
oDCmExchRate:Picture := "99999.9999999999"

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
	local UltimoMonth as date
	local oAccnt,oSys as SQLSelect, oMBal as Balances, oTrans as SQLStatement
	Local oCurr as Currency 
	Local CurRate,mDiff, mDiff1, mDiff2 as float, TransId, cStatement as string 
	LOCAL first:=true as LOGIC
	Local aROE:={} as Array 
	Local cCur as string, nCurPntr as int 
	local lError as logic
	Local cSm:="Busy with reevaluation foreign currency accounts" as string

	oSys:=SQLSelect{"select LstReEval from sysparms where DATE_ADD(LstReEval,INTERVAL 38 DAY)<curdate()",oConn} 
	if oSys:Reccount<1
		self:Close()
		Return
	endif
	UltimoMonth:=SToD(SubStr(DToS(Today()),1,6)+"01")-1
	oCurr:=Currency{"Reevaluation"}
	self:oCall:Pointer := Pointer{POINTERHOURGLASS}
	oAccnt:=SQLSelect{"select a.accid,a.accnumber,a.currency,a.GAINLSACC,b.category as type from account a, balanceitem b "+;
	"where ReEvaluate=1 and GAINLSACC>0 and b.balitemid=a.balitemid",oConn} 
	if oAccnt:Reccount>0
		if ((TextBox{oCall,"Reevaluation of foreign currency accounts","Do you want to reevaluate up till date "+DToC(UltimoMonth),BUTTONYESNO+BOXICONQUESTIONMARK}):Show() == BOXREPLYNO)
			self:Close() 
			return
		endif
		oCall:STATUSMESSAGE(cSm)
	ENDIF
	oMBal:=Balances{}
	do while !oAccnt:EoF 
		cCur:= oAccnt:Currency
		// determine balance in foreign currency:
		oMBal:GetBalance(Str(oAccnt:accid,-1),oAccnt:type,,UltimoMonth,cCur)
		if oMBal:per_deb # 0 .or. oMBal:per_cre # 0
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
				mDiff1:=Round((oMBal:per_cre - oMBal:per_deb)*CurRate,DecAantal)
				// determine old balance in local currency:
				oMBal:GetBalance(Str(oAccnt:accid,-1),oAccnt:type,,UltimoMonth,sCURR)
				mDiff2:=Round(oMBal:per_cre - oMBal:per_deb,DecAantal)
				mDiff:=Round(mDiff1 - mDiff2,DecAantal) 
				if mDiff <> 0
					SQLStatement{"start transaction",oConn}:execute()
					cStatement:="insert into transaction set "+;
						"accid='"+Str(oAccnt:GAINLSACC,-1)+"'"+;
						",DAT='"+SQLdate(UltimoMonth)+"'"+;
						",DEB='"+Str(mDiff,-1)+"'"+;
						",currency='"+sCURR+"'"+;
						",description='Reevaluation with ROE "+Str(CurRate,-1)+"'"+;
						",seqnr=1"+;
						",BFM='C'"   // regard as allready sent to CMS/AccPac
					oTrans:=SQLStatement{cStatement,oConn}
					oTrans:execute()
					if oTrans:NumSuccessfulRows>0
						TransId:=SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)
						cStatement:="insert into transaction set "+;
							"accid='"+Str(oAccnt:accid,-1)+"'"+;
							",seqnr=2"+;
							",DAT='"+SQLdate(UltimoMonth)+"'"+;
							",TransId='"+TransId+"'"+; 
							",CRE='"+Str(mDiff,-1)+"'"+;
							",currency='"+cCur+"'"+;
							",description='Reevaluation with ROE "+Str(CurRate,-1)+"'"+;
							",BFM='C'"   // regard as allready sent to CMS/AccPac
						oTrans:=SQLStatement{cStatement,oConn}
						oTrans:execute()
						if oTrans:NumSuccessfulRows>0
							if ChgBalance(Str(oAccnt:GAINLSACC,-1),UltimoMonth,mDiff,0,0,0,sCURR)
								if ChgBalance(Str(oAccnt:accid,-1),UltimoMonth,0,mDiff,0,0,cCur)
									SQLStatement{"commit",oConn}:execute()
									lError:=false
								endif
							endif
						endif
					endif
               if lError
     					LogEvent(self,"Error:"+oTrans:SQLString,"LogSQL")
						ErrorBox{self:oCall,"reevaluation transaction for account "+oAccnt:accnumber+"could not be stored"}:Show()
						SQLStatement{"rollback",oConn}:execute()
						return
               endif
				endif						
			endif
		endif
		oCall:STATUSMESSAGE(cSm+=".")

		oAccnt:Skip()
	enddo 
	SQLStatement{"update sysparms set LstReEval='"+SQLdate(UltimoMonth)+"'",oConn}:execute()
	self:Close() 


	return 
CLASS Sub_Rates INHERIT DATAWINDOW 

	PROTECT oDBAED as JapDataColumn
	PROTECT oDBDATERATE as JapDataColumn
	PROTECT oDBROE as JapDataColumn
	PROTECT oDBAEDUNIT as JapDataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  export lFilling:=true as logic 
RESOURCE Sub_Rates DIALOGEX  2, 2, 277, 183
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

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

oDBDATERATE := JapDataColumn{17}
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
