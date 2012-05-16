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

SELF:Caption := "Monitor balance of suspense and bank accounts"
SELF:HyperLabel := HyperLabel{#CheckSuspense,"Monitor balance of suspense and bank accounts",NULL_STRING,NULL_STRING}

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
	local i,j,nBalPtr,CurMonth,CurYear,nBeginMonth,nBeginAccount as int
	LOCAL oReport as PrintDialog
	LOCAL cTab:=CHR(9),cSep:=Space(2) as STRING 
	local aHeading:={} as array
	local aSuspense:={} as array // array with suspense accounts: { accid, accnumber, description,type},...       type=a:acceptgiro,p:payments,C:cross bank,n:non-designated
	local aBal:={} as array // array with {accid,{{date,balance},...}},...  
	local cAccAccept as string
	local cType as string
	local	oBalncs as Balances 
	local fBal,fTotMonth,fTotPeriod as Float

	Begindate:=self:oDCFromdate:SelectedDate
	Endingdate:=self:oDCTodate:SelectedDate
	if Endingdate<Begindate
		IntDate:=Endingdate
		Endingdate:=Begindate
		Begindate:=IntDate
	endif
	oReport := PrintDialog{self,oLan:RGet("Suspense accounts"),,72,DMORIENT_PORTRAIT,"xls"}

	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	self:Pointer := Pointer{POINTERHOURGLASS}
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
	if !Empty(SPROJ)
		oSel:=SqlSelect{"select accid,accnumber,description from account where accid="+SPROJ ,oConn}   //accid=101099
		if oSel:RecCount>0
			AAdd(aSuspense,{oSel:accid,oSel:accnumber,oSel:description,'n'})
		endif
	endif
	if !Empty(SDEB)
		oSel:=SqlSelect{"select accid,accnumber,description from account where accid="+sdeb ,oConn}   //accid=101099
		if oSel:RecCount>0
			AAdd(aSuspense,{oSel:accid,oSel:accnumber,oSel:description,'n'})
		endif
	endif
	if !Empty(sCRE)
		oSel:=SqlSelect{"select accid,accnumber,description from account where accid="+sCRE ,oConn}   //accid=101099
		if oSel:RecCount>0
			AAdd(aSuspense,{oSel:accid,oSel:accnumber,oSel:description,'n'})
		endif
	endif
	// add accounts to be monitored:
	oSel:=SqlSelect{"select accid,accnumber,description from account where monitor=1 and accid not in ("+Implode(aSuspense,',',,,1)+')' ,oConn}   
	if oSel:RecCount>0 
		do while !oSel:EOF
			AAdd(aSuspense,{oSel:accid,oSel:accnumber,oSel:description,'m'})
			oSel:skip()
		enddo
	endif
	ASort(aSuspense,,,{|x,y|x[2]<=y[2]})
	if Lower(oReport:Extension) #"xls"
		cTab:=Space(1)
		cSep:=''
	ENDIF
	oBalncs:=Balances{}
	aHeading :={oLan:RGet('Suspense accounts',,"@!")+'  '+DToC(Begindate)+' - '+dtoc(Endingdate),' '}

	AAdd(aHeading, ;
		oLan:RGet("Accnumber",15,"!")+cTab+oLan:RGet("Name",30,"!")+cTab+oLan:RGet("Balance",12,"!",'R'))
	AAdd(aHeading,' ')
	nRow := 0
	nPage := 0
	SetDecimalSep(Asc(DecSeparator))
	if Len(aSuspense)=0
		oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("No suspense accounts"),aHeading)
	else 
		for i:=1 to Len(aSuspense)
			oBalncs:GetBalance(ConS(aSuspense[i,1]),,Endingdate) 
			fBal:=Round(oBalncs:per_cre-oBalncs:per_deb,DecAantal)		
			oReport:PrintLine(@nRow,@nPage,Pad(aSuspense[i,2],15)+cTab+Pad(aSuspense[i,3],30)+cTab+Str(fBal,12,2),aHeading)
		next
		oReport:PrintLine(@nRow,@nPage,' ') 
		oReport:PrintLine(@nRow,@nPage,' ') 
		
		i:=AScan(aSuspense,{|x|x[4]=='a'})
		if i>0
			cAccAccept:=ConS(aSuspense[i,1])
			
			aHeading :={oLan:RGet('Suspense account',,"@!")+': '+aSuspense[i,2]+' '+aSuspense[i,3],' '}

			AAdd(aHeading, ;
				oLan:RGet("DATE",10,'@!')+cTab+oLan:RGet("DIFFERENCE",10,'@!','R')+cTab+oLan:RGet("MISSING",8,'@!','R')+cTab+oLan:RGet("SPECIFICATION",,'@!'))
			if Lower(oReport:Extension) #"xls"
				AAdd(aHeading,Replicate('-',72))
			ENDIF
			nRow := 0
			// 	nPage := 0 
			oSel:=SqlSelect{UnionTrans("select `dat` as datedif,sum(totdaykind) as diffval,sum(if(docid='ACC',-qtykind,qtybgc) ) as diffqty,"+;
				"cast(group_concat(gr.docid,':€',lpad(cast(totdaykind as char),9,' '),lpad(concat(' (',if(docid='ACC',cast(qtykind as char),cast(qtybgc as char)),')'),6,' ') order by docid separator ' ') as char) as specification"+;
				" from (SELECT `dat`,SubStr(`docid`,1,3) as docid,sum(cre-deb) as totdaykind,count(*) as qtykind,"+;
				"sum(cast(SubStr(description,24,locate('ACCEPTGIRO',description,24)-24) as unsigned)) as qtybgc "+;  
			"from `transaction` t WHERE t.docid<>'' and t.dat>='"+SQLdate(Begindate)+"' and t.dat<='"+SQLdate(Endingdate)+"' and t.`accid`="+cAccAccept+; 
			" group by t.`dat`,SubStr(t.`docid`,1,3)) as gr group by gr.dat having diffval<>0.00")+" order by datedif",oConn}
			oSel:Execute() 
			if oSel:RecCount<1
				oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("No differences"),aHeading)
			else	
				do WHILE .not. oSel:EOF
					oReport:PrintLine(@nRow,@nPage,DToC(oSel:datedif)+cTab+Str(oSel:diffval,10,2)+cTab+Str(oSel:diffqty,6,0)+cSep+cTab+iif(AtC('ACC',oSel:specification)=0,Space(21),'')+oSel:specification,aHeading)
					oSel:skip()
				ENDDO
			endif
			oReport:PrintLine(@nRow,@nPage,Space(1),aHeading,3)
		ENDIF
		// analysis per account
		aHeading :={oLan:RGet('Analysis per account',,"@!")+'  '+DToC(Begindate)+' - '+DToC(Endingdate),' '}

		AAdd(aHeading, ;
			oLan:RGet("DATE",10,'@!')+cTab+oLan:RGet("DIFFERENCE",14,'@!','R')+cTab+oLan:RGet("BALANCE",14,'@!','R'))
		if Lower(oReport:Extension) #"xls"
			AAdd(aHeading,Replicate('-',42))
		ENDIF
		nRow := 0
		// get transaction balances per account per day:
		oSel:=SqlSelect{UnionTrans("select gr.accid,group_concat(cast(gr.dat as char),',',cast(gr.daytot as char) order by gr.dat separator '#' ) as daytots "+;
			"from (select t.accid,t.dat,sum(cre-deb) as daytot from transaction t where  t.accid in ("+Implode(aSuspense,',',,,1)+") and t.dat>='"+SQLdate(Begindate+1)+;
			"' and t.dat<='"+SQLdate(Endingdate)+"' "+"group by t.accid,dat having daytot<>0.00  order by t.accid,t.dat ) as gr group by gr.accid")+" order by accid,daytots",oConn} 
		oSel:Execute()
		do WHILE !oSel:EOF
			AAdd(aBal,{oSel:accid,AEvalA(Split(oSel:daytots,'#'),{|x|x:=Split(x,',')})})   // aBal: {{date,value},...
			i:=Len(aBal)
			// convert dates and values
			AEvalA(aBal[i,2],{|x|x:={SQLDate2Date(x[1]),Val(x[2])}})
			oSel:skip()
		enddo 
		// print pe account per day difference, balance + total per month  

		for i:=1 to Len(aSuspense)
			// calculate begin balances:
			oBalncs:GetBalance(ConS(aSuspense[i,1]),,Begindate) 
			fBal:=Round(oBalncs:per_cre-oBalncs:per_deb,DecAantal) 
			nBalPtr:=AScan(aBal,{|x|x[1]==aSuspense[i,1]})
			oReport:PrintLine(@nRow,@nPage,Upper(aSuspense[i,2]+' '+aSuspense[i,3]),aHeading,10)
			nBeginMonth:=Len(oReport:oPrintJob:aFiFo)
			nBeginAccount:=nBeginMonth 
			if nBalPtr>0
				CurYear:=Year(aBal[nBalPtr,2][1,1])
				CurMonth:= Month(aBal[nBalPtr,2][1,1]) 
				fTotMonth:=0.00
				fTotPeriod:=0.00
				for j:=1 to Len(aBal[nBalPtr,2])
					if CurMonth<>Month(aBal[nBalPtr,2][j,1]) .or.CurYear<>Year(aBal[nBalPtr,2][j,1]) 
						// close previous month: 
						if fTotMonth=0.00
							//skip this month:
							ASize(oReport:oPrintJob:aFiFo,nBeginMonth)
						else
							oReport:PrintLine(@nRow,@nPage,Space(10)+cTab+Replicate('_',14)+cTab+Replicate('_',14),aHeading,2)
							oReport:PrintLine(@nRow,@nPage,Pad(maand[CurMonth],10)+cTab+Str(fTotMonth,14,2)+cTab+Str(fBal,14,2),aHeading)												
							oReport:PrintLine(@nRow,@nPage,Space(1),aHeading,6) 
							fTotPeriod:=Round(fTotPeriod+fTotMonth,DecAantal)
						endif
						CurMonth:=Month(aBal[nBalPtr,2][j,1])
						CurYear:=Year(aBal[nBalPtr,2][j,1]) 
						fTotMonth:=0.00
						nBeginMonth:=Len(oReport:oPrintJob:aFiFo) 
					endif
					fBal:=Round(fBal+aBal[nBalPtr,2][j,2],DecAantal) 
					fTotMonth:=Round(fTotMonth+aBal[nBalPtr,2][j,2],DecAantal)
					oReport:PrintLine(@nRow,@nPage,DToC(aBal[nBalPtr,2][j,1])+cTab+Str(aBal[nBalPtr,2][j,2],14,2)+cTab+Str(fBal,14,2),aHeading)												
				next
				// print account closing: 
				if fTotMonth=0.00
					//skip this month:
					ASize(oReport:oPrintJob:aFiFo,nBeginMonth)
				else
					oReport:PrintLine(@nRow,@nPage,Space(10)+cTab+Replicate('_',14)+cTab+Replicate('_',14),aHeading,2)
					oReport:PrintLine(@nRow,@nPage,Pad(maand[CurMonth],10)+cTab+Str(fTotMonth,14,2)+cTab+Str(fBal,14,2),aHeading)												
					oReport:PrintLine(@nRow,@nPage,Space(1),aHeading,3)
					fTotPeriod:=Round(fTotPeriod+fTotMonth,DecAantal)
				endif
				if Len(oReport:oPrintJob:aFiFo)>nBeginAccount 
					oReport:PrintLine(@nRow,@nPage,Space(10)+cTab+Replicate('=',14)+cTab+Replicate('=',14),aHeading,2)
					oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("PERIOD",10,'@!')+cTab+Str(fTotPeriod,14,2)+cTab+Str(fBal,14,2),aHeading)												
					oReport:PrintLine(@nRow,@nPage,Space(1),aHeading,3)
				endif
			endif
			if Len(oReport:oPrintJob:aFiFo)==nBeginAccount
				oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("No differences"),aHeading)												
				oReport:PrintLine(@nRow,@nPage,Space(1),aHeading,3)				
			ENDIF
		next
	ENDIF
	SetDecimalSep(Asc('.'))
	oReport:prstart()
	oReport:prstop()
	self:Pointer := Pointer{POINTERARROW}
	self:EndWindow()

	RETURN nil
method PostInit(oWindow,iCtlID,oServer,uExtra) class CheckSuspense
	//Put your PostInit additions here 
	local startdate as date
	self:SetTexts()
	if !Empty(GlBalYears)
		startdate:=GlBalYears[Len(GlBalYears),1] 
	else
		startdate:=MinDate
	endif                      
	
	self:oDCFromdate:DateRange:=DateRange{startdate,Today()}
	self:oDCTodate:DateRange:=DateRange{startdate,Today()}

	self:oDCTodate:Value:=Today()-1
	self:oDCFromdate:Value:=SToD(SubStr(DToS(Max(MinDate,Today()-120)),1,6)+'01')
	return nil

STATIC DEFINE CHECKSUSPENSE_CANCELBUTTON := 107 
STATIC DEFINE CHECKSUSPENSE_FIXEDTEXT6 := 103 
STATIC DEFINE CHECKSUSPENSE_FIXEDTEXT8 := 101 
STATIC DEFINE CHECKSUSPENSE_FIXEDTEXT9 := 105 
STATIC DEFINE CHECKSUSPENSE_FROMDATE := 102 
STATIC DEFINE CHECKSUSPENSE_GROUPBOX3 := 104 
STATIC DEFINE CHECKSUSPENSE_OKBUTTON := 106 
STATIC DEFINE CHECKSUSPENSE_TODATE := 100 
