CLASS CheckSuspense INHERIT DataWindowExtra 

	PROTECT oDCTodate AS DATESTANDARD
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oDCFromdate AS DATESTANDARD
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCGroupBox3 AS GROUPBOX
	PROTECT oDCFixedText9 AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
RESOURCE CheckSuspense DIALOGEX  4, 3, 288, 92
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"donderdag 10 mei 2012", CHECKSUSPENSE_TODATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 60, 52, 120, 13
	CONTROL	"Till Date:", CHECKSUSPENSE_FIXEDTEXT8, "Static", WS_CHILD, 12, 52, 40, 12
	CONTROL	"donderdag 10 mei 2012", CHECKSUSPENSE_FROMDATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 60, 33, 120, 13
	CONTROL	"From Date:", CHECKSUSPENSE_FIXEDTEXT6, "Static", WS_CHILD, 12, 33, 46, 12
	CONTROL	"Report Period", CHECKSUSPENSE_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 22, 200, 59
	CONTROL	"Check suspense accounts", CHECKSUSPENSE_FIXEDTEXT9, "Static", WS_CHILD, 4, 7, 152, 12
	CONTROL	"OK", CHECKSUSPENSE_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 216, 25, 53, 13
	CONTROL	"Cancel", CHECKSUSPENSE_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 216, 7, 53, 12
END

METHOD CancelButton( ) CLASS CheckSuspense 
self:EndWindow()
RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS CheckSuspense 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"CheckSuspense",_GetInst()},iCtlID)

aFonts[1] := Font{,10,"Microsoft Sans Serif"}
aFonts[1]:Bold := TRUE

oDCTodate := DateStandard{SELF,ResourceID{CHECKSUSPENSE_TODATE,_GetInst()}}
oDCTodate:FieldSpec := Transaction_DAT{}
oDCTodate:HyperLabel := HyperLabel{#Todate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText8 := FixedText{SELF,ResourceID{CHECKSUSPENSE_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"Till Date:",NULL_STRING,NULL_STRING}

oDCFromdate := DateStandard{SELF,ResourceID{CHECKSUSPENSE_FROMDATE,_GetInst()}}
oDCFromdate:FieldSpec := Transaction_DAT{}
oDCFromdate:HyperLabel := HyperLabel{#Fromdate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText6 := FixedText{SELF,ResourceID{CHECKSUSPENSE_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"From Date:",NULL_STRING,NULL_STRING}

oDCGroupBox3 := GroupBox{SELF,ResourceID{CHECKSUSPENSE_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"Report Period",NULL_STRING,NULL_STRING}

oDCFixedText9 := FixedText{SELF,ResourceID{CHECKSUSPENSE_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"Check suspense accounts",NULL_STRING,NULL_STRING}
oDCFixedText9:Font(aFonts[1], FALSE)

oCCOKButton := PushButton{SELF,ResourceID{CHECKSUSPENSE_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}
oCCOKButton:UseHLforToolTip := False

oCCCancelButton := PushButton{SELF,ResourceID{CHECKSUSPENSE_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#CheckSuspense,"DataWindow Caption",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS CheckSuspense 
	// perform checks: 
	local oSel as SQLSelect
	local Begindate, Endingdate,IntDate as date
	LOCAL nRow as int
	LOCAL nPage as int 
	local i as int
	LOCAL oReport as PrintDialog
	LOCAL cTab:=CHR(9) as STRING 
	local aHeading:={} as array
	local aSuspense:={} as array // array with suspense accounts: { aacid, accnumber, description,type},...       type=a:acceptgiro,p:payments,C:cross bank  
	local cAccAccept as string
	local cType as string
   local	oBalncs as Balances 
   local fBal as Float

	Begindate:=self:oDCFromdate:SelectedDate
	Endingdate:=self:oDCTodate:SelectedDate
	if Endingdate<Begindate
		IntDate:=Endingdate
		Endingdate:=Begindate
		Begindate:=IntDate
	endif
	oReport := PrintDialog{self,oLan:RGet("Suspense accounts"),,70,DMORIENT_PORTRAIT,"xls"}

	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	oSel:=SqlSelect{"select distinct a.accid,a.accnumber,a.description from account a, bankaccount b where a.accid=b.payahead " ,oConn}   //accid=101099
	oSel:Execute()
	do while !oSel:EOF
		cType:=iif(AtC('accept',oSel:description)>0,'a',iif(atc('betaling',oSel:description)>0.or.atc('pay',oSel:description)>0,'p',''))
		AAdd(aSuspense,{oSel:accid,oSel:accnumber,oSel:description,cType})
		oSel:skip()
	enddo
	if !Empty(SKruis)
		oSel:=SqlSelect{"select accid,accnumber,description from account where accid="+SKruis ,oConn}   //accid=101099
		if oSel:RecCount>0
			AAdd(aSuspense,{oSel:accid,oSel:accnumber,oSel:description,'C'})
		endif
	endif
	if Lower(oReport:Extension) #"xls"
		cTab:=Space(1)
	ENDIF
	if Len(aSuspense)=0
		oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("No suspense accounts"),aHeading)
		return nil
	endif
	oBalncs:=Balances{}
	aHeading :={oLan:RGet('Suspense accounts',,"@!")+'  '+DToC(Begindate)+' - '+dtoc(Endingdate),' '}

	AAdd(aHeading, ;
		oLan:RGet("Accnumber",15,"!")+cTab+oLan:RGet("Name",30,"!")+cTab+oLan:RGet("Balance",12,"!",'R'))
	AAdd(aHeading,' ')
	nRow := 0
	nPage := 0 
	for i:=1 to Len(aSuspense)
		oBalncs:GetBalance(ConS(aSuspense[i,1]),,Endingdate) 
		fBal:=Round(oBalncs:per_cre-oBalncs:per_deb,DecAantal)		
		oReport:PrintLine(@nRow,@nPage,Pad(aSuspense[i,2],15)+cTab+Pad(aSuspense[i,3],30)+cTab+Str(fBal,12,2),aHeading)
	next
 	oReport:PrintLine(@nRow,@nPage,' ') 
 	
	i:=AScan(aSuspense,{|x|x[4]=='a'})
	if i=0
		return nil
	endif
	cAccAccept:=ConS(aSuspense[i,1])
		
	aHeading :={oLan:RGet('Suspense account',,"@!")+': '+aSuspense[i,2]+' '+aSuspense[i,3],' '}

	AAdd(aHeading, ;
		oLan:RGet("Date",10,"!")+cTab+oLan:RGet("Difference",10,"!",'R')+cTab+oLan:RGet("More",4,"!",'R')+cTab+oLan:RGet("Specification",40,"!"))
	IF oReport:Destination#"File"
		AAdd(aHeading,' ')
	ENDIF
	nRow := 0
// 	nPage := 0 
	oSel:=SqlSelect{"select `dat` as datedif,sum(totdaykind) as diffval,sum(if(docid='ACC',-qtykind,qtybgc) ) as diffqty,"+;
		"group_concat(gr.docid,':€',cast(totdaykind as char),' (',if(docid='ACC',cast(qtykind as char),cast(qtybgc as char)),')' order by docid separator ' ') as specification"+;
		" from (SELECT `dat`,SubStr(`docid`,1,3) as docid,sum(cre-deb) as totdaykind,count(*) as qtykind,"+;
		"sum(cast(SubStr(description,24,locate('ACCEPTGIRO',description,24)-24) as unsigned)) as qtybgc "+;  
	"from `transaction` WHERE docid<>'' and dat between '"+SQLDate(Begindate)+"' and '"+sqldate(Endingdate)+"' and `accid`="+cAccAccept+; 
	" group by `dat`,SubStr(`docid`,1,3)) as gr group by gr.dat having diffval<>0.00",oConn}
	oSel:Execute() 
	if oSel:RecCount<1
		oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("No differences"),aHeading)
	else	
		do WHILE .not. oSel:EOF
			oReport:PrintLine(@nRow,@nPage,DToC(oSel:datedif)+cTab+Str(oSel:diffval,10,2)+cTab+Str(oSel:diffqty,4,0)+cTab+oSel:specification,aHeading)
			oSel:skip()
		ENDDO
	endif
	oReport:prstart()
	oReport:prstop()


	RETURN nil
method PostInit(oWindow,iCtlID,oServer,uExtra) class CheckSuspense
	//Put your PostInit additions here
	self:SetTexts()
	
	self:oDCFromdate:DateRange:=DateRange{MinDate,Today()}
	self:oDCTodate:DateRange:=DateRange{MinDate,Today()}

	self:oDCTodate:Value:=Today()-1
	self:oDCFromdate:Value:=Max(MinDate,Today()-91)
	return nil

STATIC DEFINE CHECKSUSPENSE_CANCELBUTTON := 107 
STATIC DEFINE CHECKSUSPENSE_FIXEDTEXT6 := 103 
STATIC DEFINE CHECKSUSPENSE_FIXEDTEXT8 := 101 
STATIC DEFINE CHECKSUSPENSE_FIXEDTEXT9 := 105 
STATIC DEFINE CHECKSUSPENSE_FROMDATE := 102 
STATIC DEFINE CHECKSUSPENSE_GROUPBOX3 := 104 
STATIC DEFINE CHECKSUSPENSE_OKBUTTON := 106 
STATIC DEFINE CHECKSUSPENSE_TODATE := 100 
