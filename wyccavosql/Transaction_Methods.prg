CLASS AccountStatements
	// Printing OF account statements per month
	EXPORT oBal as Balances
	EXPORT oTrans as SQLSelect

	EXPORT oReport AS PrintDialog
	PROTECT cFileTrans AS STRING
	EXPORT BeginReport:=FALSE as LOGIC
	export SkipInactive as logic 
	export GiftDetails as logic   // show gift also as transactions
	EXPORT SendingMethod AS STRING
	PROTECT DescrWidth:=40 as int 
	protect m58_debF, m58_creF, mnd_debF, mnd_creF,m57_giftbedF as float 
	Protect lForgnC as logic // foreign currency account?
	export lMinimalInfo as logic  // minimal balance info 
	export lDebCreMerge as logic // only one amount column
	Protect BoldOn, BoldOff, YellowOn, YellowOff, GreenOn, GreenOff, RedOn,RedOff,RedCharOn,RedCharOff as STRING
	protect cTab:=' ' as string
	protect cAccCurrency, CurAcc,cFrom,cSubTotal as string
	protect aPPCode:={},	aTrType:={} as array
	protect m71_chdeb,m71_chcre,m71_chdebF,m71_chcreF as float

	declare method MonthPrint,Month_summary
METHOD Init(DescrpWidth, MinimalInfo) CLASS AccountStatements
	local oPPcd as SQLSelect  
	Default(@DescrpWidth,40)
	Default(@MinimalInfo,true)
	self:lMinimalInfo:=MinimalInfo
	self:DescrWidth:=DescrpWidth
	self:oBal:=Balances{} 
	oPPcd := SqlSelect{"select ppcode,ppname from ppcodes order by ppcode",oConn} 
	self:aPPCode:=oPPcd:GetLookupTable(200,#ppcode,#ppname)

	RETURN SELF
METHOD Month_summary(aHeading as array,oMyBal as balances,m57_giftbed as float,nRow ref int,nPage ref int,oLan as Language,mnd_cur as int,mnd_deb as float,mnd_cre as float,;
mnd_debF as float,mnd_creF as float,m58_rek as string,me_type as string,jr_cur as int,oReport as PrintDialog,aOPP as array) CLASS AccountStatements
	LOCAL skipaant:=5,i,j as int
	local BalDeb:=0.00, BalCre:=0.00 as float
	local cOPP,cTypeOPP,cDescription as string
	local lRtf,lXls as logic
	local nDisp:=self:DescrWidth*100 as int 
	local RowRTF:="\trowd\cellx1060\cellx2100\cellx"+Str(2100+nDisp,-1)+"\cellx"+Str(2100+nDisp+1050,-1)+"\cellx" as string
	local HeadingLineRTF:="\trowd\f1\cellx"+Str(nDisp+2100,-1)+"\cellx"+Str(2100+nDisp+1050,-1) as string  // used for:+"\intbl <text>\cell\row\pard" 
	local SubTotalRTF:="\trowd\cellx"+Str(2100+nDisp,-1)+"\clbrdrt\brdrw10\brdrth\cellx"+Str(2100+nDisp+1050,-1) as string  // use: \intbl Begin saldo Januari 2011\cell\intbl\qr 1882,65\cell\intbl\qr \cell\row\pard
	local SubTotalRTF1:="\trowd\cellx1060\cellx"+Str(2100+nDisp,-1)+"\clbrdrt\brdrw10\brdrth\cellx"+Str(2100+nDisp+1050,-1) as string  // use: \intbl Begin saldo Januari 2011\cell\intbl\qr 1882,65\cell\intbl\qr \cell\row\pard
	IF self:cTab==CHR(9)
		lXls:=true
	elseif self:cTab=="\cell\intbl "
		lRtf:=true
	endif
	IF Integer(m57_giftbed*100)/100#0
		oReport:PrintLine(@nRow,@nPage,iif(lRtf,HeadingLineRTF+;
			'\intbl '+oLan:RGet("Total gifts/own funds (see gifts overview)",,"!")+self:cTab+'\qr '+Str(m57_giftbed,-1,DecAantal)+'\cell\row\pard',;
			iif(lXls,self:cTab+oLan:RGet("Total gifts/own funds (see gifts overview)",,"!")+self:cTab;
			,Space(10)+self:cTab+Pad(oLan:RGet("Total gifts/own funds (see gifts overview)",,"!"),self:DescrWidth)+Space(10)+self:cTab)+self:cTab+;
			iif(lForgnC,Str(self:m57_giftbedF,12,DecAantal)+iif(self:lDebCreMerge,'',Space(13))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
			+iif(self:lDebCreMerge,'',Space(12)+self:cTab)+Str(m57_giftbed,12,DecAantal)),aHeading) 
		self:m71_chcre:=Round(self:m71_chcre+m57_giftbed,DecAantal)
	ENDIF
	*	Print	closing lines account statement:
	IF	Len(aOPP)>0	.and.( self:m71_chdeb # 0.00	.or. self:m71_chcre # 0.00 .or. self:m71_chdebF # 0.00	.or. self:m71_chcreF # 0.00)
		if !lRtf
			oReport:PrintLine(@nRow,@nPage,; 
			Space(20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+'------------'+iif(self:lDebCreMerge,'',self:cTab+'------------')+iif(lForgnC,Space(8)+self:cTab+self:cTab+'------------'+iif(self:lDebCreMerge,'',self:cTab+'------------'),""),aHeading,2)
		endif
		self:oReport:PrintLine(@nRow,@nPage,iif(lRtf,;
			SubTotalRTF1+'\intbl '+self:cTab+self:cSubTotal+self:cTab+'\qr '+Str(self:m71_chcre-self:m71_chdeb,-1,DecAantal)+'\cell\row\pard', ;
			iif(lXls,self:cTab,Space(10)+self:cTab)+Pad(cSubTotal,self:DescrWidth)+iif(lXls,self:cTab,Space(10)+self:cTab)+self:cTab+;
			iif(lForgnC,iif(self:lDebCreMerge,Str(self:m71_chcreF-self:m71_chdebF,12,DecAantal),Str(self:m71_chdebF,12,DecAantal)+self:cTab+Str(self:m71_chcreF,12,DecAantal))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
			iif(self:lDebCreMerge,Str(self:m71_chcre-self:m71_chdeb,12,DecAantal),Str(self:m71_chdeb,12,DecAantal)+self:cTab+Str(self:m71_chcre,12,DecAantal))),aHeading)
	ENDIF
	* Printing of amounts from	OPP's:
	aOPP:=ASort(aOPP,,,{|x,y|x[1]<=y[1]	.and.	x[2]<=y[2]})
	FOR i:=1	to	Len(aOPP)
		cOPP:=aOPP[i,1]
		j:=AScan(self:aPPCode,{|x|x[1]==cOPP})
		IF	j>0
			cOPP:=AllTrim(self:aPPCode[j,2])
		ENDIF
		cTypeOPP:=aOPP[i,2]
		j:=AScan(self:aTrType,{|x|x[1]==cTypeOPP})
		IF	j>0
			cTypeOPP:=self:aTrType[j,2]
		ENDIF 
		cDescription:=self:cFrom+Space(1)+cOPP+': '+cTypeOPP
		self:oReport:PrintLine(@nRow,@nPage,iif(lRtf,HeadingLineRTF+cDescription+'\cell\cell\row\pard',;
			Pad(cDescription,self:DescrWidth)),aHeading,4)
		FOR j:=1	to	Len(aOPP[i,7])
			self:oReport:PrintLine(@nRow,@nPage,aOPP[i,7][j,1],aHeading,aOPP[i,7][j,2])
			if lRtf
				nRow:=nRow+aOPP[i,7][j,2]-1
			endif
		NEXT
		if !lRtf .and. !lXls
			oReport:PrintLine(@nRow,@nPage,;
				Space(20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+'------------'+iif(self:lDebCreMerge,'',self:cTab+'------------')+iif(lForgnC,Space(8)+self:cTab+self:cTab+'------------'+iif(self:lDebCreMerge,'',self:cTab+'------------'),""),aHeading,6)
		endif
		cDescription:=self:cSubTotal+Space(1)+self:cFrom+Space(1)+cOPP+': '+cTypeOPP
		self:oReport:PrintLine(@nRow,@nPage,iif(lRtf,SubTotalRTF1+'\intbl '+self:cTab+cDescription+self:cTab+'\qr '+Str(aOPP[i,4]-aOPP[i,3],-1,DecAantal)+'\cell\row\pard',;
			iif(self:cTab==CHR(9),self:cTab,Space(10)+self:cTab)+Pad(cDescription,self:DescrWidth)+iif(self:cTab==CHR(9),self:cTab,Space(10)+self:cTab)+self:cTab+;
			iif(self:lForgnC,iif(self:lDebCreMerge,self:cTab+Str(aOPP[i,6]-aOPP[i,5],12,DecAantal),Str(aOPP[i,5],12,DecAantal)+self:cTab+Str(aOPP[i,6],12,DecAantal))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
			iif(self:lDebCreMerge,Str(aOPP[i,4]-aOPP[i,3],12,decaantal),Str(aOPP[i,3],12,decaantal)+self:cTab+Str(aOPP[i,4],12,decaantal))),aHeading)				
	NEXT
	self:oBal:GetBalance(m58_rek,,jr_cur*100+mnd_cur,self:cAccCurrency)
	IF lForgnC
		BalDeb:=self:oBal:Per_DebF
		BalCre:=self:oBal:Per_CreF	
	endif
	IF Val(Str(mnd_deb))<>0 .and.Val(Str(mnd_cre))<>0
		skipaant++
	ENDIF
	IF Val(Str(self:oBal:Per_Deb))<>0 .and.Val(Str(self:oBal:Per_Cre))<>0
		skipaant++
	ENDIF 
	if !lRtf
	oReport:PrintLine(@nRow,@nPage,;
		Space(20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+'------------'+iif(self:lDebCreMerge,'',self:cTab+'------------')+iif(lForgnC,Space(8)+self:cTab+self:cTab+'------------'+iif(self:lDebCreMerge,'',self:cTab+'------------'),""),aHeading,skipaant)
	endif
	IF Val(Str(mnd_deb))<>0 .and.Val(Str(mnd_cre))<>0  .and.!self:lMinimalInfo 
		cDescription:=self:cSubTotal+Space(1)+oLan:RGet(MonthEn[mnd_cur],,"!")
		oReport:PrintLine(@nRow,@nPage,iif(lRtf,SubTotalRTF+'\intbl '+cDescription+self:cTab+'\qr '+Str(mnd_cre-mnd_deb,-1,DecAantal),;
		Pad(cDescription,20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+; 
		iif(lForgnC,iif(self:lDebCreMerge,Str(mnd_creF-mnd_debF,12,DecAantal),Str(mnd_debF,12,DecAantal)+self:cTab+Str(mnd_creF,12,DecAantal))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
			iif(self:lDebCreMerge,Str(mnd_cre-mnd_deb,12,DecAantal),Str(mnd_deb,12,DecAantal)+self:cTab+Str(mnd_cre,12,DecAantal))),aHeading)
	ENDIF
	cDescription:=iif(self:lMinimalInfo,self:cSubTotal,oLan:RGet('Balance',,"!")+Space(1)+oLan:RGet('transactions'))+Space(1)+oLan:RGet(MonthEn[mnd_cur],,"!")
	oReport:PrintLine(@nRow,@nPage,iif(lRtf,iif(Val(Str(mnd_deb))<>0 .and.Val(Str(mnd_cre))<>0  .and.!self:lMinimalInfo,HeadingLineRTF,SubTotalRTF)+;
	'\intbl '+cDescription+self:cTab+'\qr '+Str(mnd_cre-mnd_deb,-1,DecAantal)+'\cell\row\pard',;
		Pad(cDescription,20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+;
		iif(lForgnC,iif(mnd_debF-mnd_creF<0,iif(self:lDebCreMerge,'',Space(12)+self:cTab)+Str(mnd_creF-mnd_debF,12,DecAantal),;
		iif(self:lDebCreMerge,Str(mnd_creF-mnd_debF,12,DecAantal),Str(mnd_debF-mnd_creF,12,DecAantal)+self:cTab+Space(12)))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
		IF(mnd_deb-mnd_cre<0,iif(self:lDebCreMerge,'',Space(12)+self:cTab)+Str(mnd_cre-mnd_deb,12,DecAantal),;
		iif(self:lDebCreMerge,Str(mnd_cre-mnd_deb,12,DecAantal),Str(mnd_deb-mnd_cre,12,DecAantal)))),aHeading)
	IF Val(Str(self:oBal:per_deb))<>0 .and.Val(Str(self:oBal:per_cre))<>0 .and.!self:lMinimalInfo 
		cDescription:=oLan:RGet('Account level',,"!")+Space(1)+oLan:RGet(MonthEn[mnd_cur],,"!")
		oReport:PrintLine(@nRow,@nPage,iif(lRtf,HeadingLineRTF+'\intbl '+cDescription+self:cTab+'\qr '+Str(self:oBal:Per_Cre-self:oBal:Per_Deb,-1,DecAantal)+'\cell\row\pard';
		,Pad(cDescription,20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+;
			iif(lForgnC,iif(self:lDebCreMerge,Str(BalCre-BalDeb,12,DecAantal),Str(BalDeb,12,DecAantal)+self:cTab+Str(BalCre,12,DecAantal))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;	
		iif(self:lDebCreMerge,Str(self:oBal:Per_Cre-self:oBal:Per_Deb,12,DecAantal),Str(self:oBal:Per_Deb,12,DecAantal)+self:cTab+Str(self:oBal:Per_Cre,12,DecAantal))),aHeading)
	ENDIF
	cDescription:=AllTrim(self:CurAcc)+Space(1)+oLan:RGet('Account ending balance',,"!")+Space(1)+;
		oLan:RGet(MonthEn[mnd_cur],,"!")+Space(1)+Str(jr_cur,4)
	oReport:PrintLine(@nRow,@nPage,iif(lRtf,HeadingLineRTF+BoldOn+'\intbl '+cDescription+iif(self:oBal:Per_Deb-self:oBal:Per_Cre<=0,'',RedCharOn)+;
	self:cTab+'\qr '+Str(self:oBal:Per_Cre-self:oBal:Per_Deb,-1,DecAantal)+'\cell\row'+RedCharOff+BoldOff+'\pard',;
	BoldOn+Pad(cDescription,20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+; 
	iif(lForgnC,if(BalDeb-BalCre<=0,iif(self:lDebCreMerge,'',Space(12)+self:cTab)+Str(BalCre-BalDeb,12,DecAantal),;
		RedCharOn+iif(self:lDebCreMerge,Str(BalCre-BalDeb,12,DecAantal),Str(BalDeb-BalCre,12,DecAantal))+RedCharOff)+self:cTab+Space(12)+self:cTab+BoldOff+PadC(self:cAccCurrency,8)+self:cTab,"") +;
		iif(self:oBal:Per_Deb-self:oBal:Per_Cre<=0,iif(self:lDebCreMerge,'',Space(12)+self:cTab)+Str(self:oBal:Per_Cre-self:oBal:Per_Deb,12,DecAantal),;
		RedCharOn+iif(self:lDebCreMerge,Str(self:oBal:Per_Cre-self:oBal:Per_Deb,12,DecAantal),Str(self:oBal:Per_Deb-self:oBal:Per_Cre,12,DecAantal))+RedCharOff)+BoldOff),aHeading,2) 
	// empty space line:
	oReport:PrintLine(@nRow,@nPage," ",aHeading)

	RETURN
METHOD MonthPrint(oAcc as SQLSelect,oTrans as SQLSelect,nFromYear as int,nFromMonth as int,nToYear as int,nToMonth as int,nRow ref int,nPage ref int,;
		addheading:="" as string, oLan as Language,aGiversData:=nil as array,aAssmntAmount:=nil as array,cOrder:="accnumber"as string) as logic CLASS AccountStatements 
	// printing of account statement of the current account in oAcc per Month
	//
	//	oAcc: selection of account with: accid, accnumber, description, category
	//	oTrans: selection of transaction with al table fields
	// Period: from nFromYear, nFromMonth till nToYear, nToMonth
	// addheading: extra heading line to be added to heading
	// 
	LOCAL Heading:={} as ARRAY
	LOCAL nCurMonth, nMonthStart, nMonthEnd, nThisMonth,iMonth,AssmntRow as int
	LOCAL m58_rek, me_oms, me_AccNbr, me_type,cDesc, Description as STRING
	LOCAL m57_giftbed, m58_deb, m58_cre, mnd_deb, mnd_cre,fAmnt as FLOAT
	LOCAL mnd_cur,  jr_cur,  VorigJaar, VorigMnd,nMem,CurAccid as int
	LOCAL startdate,enddate as date
	LOCAL beginreport:=FALSE, lXls,lRtf as LOGIC
	LOCAL skipaant:=4 as int
	local cStatement as string
	// LOCAL BoldOn, BoldOff,RedON,RedOff as STRING 
	local BalDeb:=0.00, BalCre:=0.00 as float
	local nBeginmember as int  // position of start account statement in aFifo of a current account 
	local lTransFound as logic // is account active?
	LOCAL aOPP as ARRAY // {OPP,Trans_Type_Code,debit,credit,debforgn,creforgn,{{line,Linecount}}} 
	LOCAL nOPP as int, cOPP, cTypeOPP as STRING
	local nDisp:=self:DescrWidth*100 as int
	local lGiftAlwd as logic 
	// heading for rtf, i.e. with lDebCreMerge:
	local HeadingRTF:="\trowd\clbrdrb\brdrw20\brdrth\cellx1060\clbrdrb\brdrw20\brdrth\cellx2100\"+;
		"clbrdrb\brdrw20\brdrth\cellx"+Str(2100+nDisp,-1)+"\clbrdrb\brdrw20\brdrth\cellx"+Str(2100+nDisp+1050,-1)+"\f0"+;
		"\intbl "+oLan:RGet("Doc-id",,"!")+"\cell\intbl "+oLan:RGet("date",,"!")+"\cell\intbl "+oLan:RGet("Description",,"!")+"\cell"+;
		"\intbl\qr "+oLan:RGet("Amount",,"!","R")+"\cell\row\pard\f1" as string
	// 		oLan:RGet("Doc-id",10,"!")+self:cTab+oLan:RGet("Date",10,"!")+self:cTab+;
	// 		oLan:RGet("Description",self:DescrWidth,"!")+self:cTab+iif(self:lDebCreMerge,oLan:RGet("Amount",12,"!","R"),oLan:RGet("Debit",12,"!","R")+self:cTab+oLan:RGet("Credit",12,"!","R"))+;
	// 		self:cTab +;
	// 		iif(lForgnC,oLan:RGet("Currency",8,"!","C")+self:cTab+;
	// 		iif(self:lDebCreMerge,oLan:RGet("Amount",12,"!","R"),oLan:RGet("Debit",9,"!","R"))+sCURR+;
	// 		iif(self:lDebCreMerge,'',self:cTab+oLan:RGet("Credit",9,"!","R")+sCURR ) ,"" ) +;
	// 		iif(self:lDebCreMerge,'',self:cTab+oLan:RGet("Transnbr",10,"!","R")))
	local RowRTF:="\trowd\cellx1060\cellx2100\cellx"+Str(2100+nDisp,-1)+"\cellx"+Str(2100+nDisp+1050,-1) as string
	local HeadingLineRTF:="\trowd\f1\cellx"+Str(nDisp+2100,-1)+"\cellx"+Str(2100+nDisp+1050,-1) as string  // used for:+"\intbl <text>\cell\row\pard" 
	local SubTotalRTF:="\trowd\cellx1060\cellx"+Str(2100+nDisp,-1)+"\clbrdrt\brdrw10\brdrth\cellx"+Str(2100+nDisp+1050,-1) as string  // use: \intbl Begin saldo Januari 2011\cell\intbl\qr 1882,65\cell\intbl\qr \cell\row\pard

	
	if self:SkipInactive
		IF oTrans:RecCount<1
			return true
		endif
	endif
	// skip to transaction of required account:
	do while !oTrans:EoF .and.;
			(cOrder="accnumber" .and. oTrans:ACCNUMBER<oAcc:ACCNUMBER .or.;
			cOrder="accid".and. oTrans:accid<oAcc:accid) 
		oTrans:Skip()
	enddo
	if self:SkipInactive
		if oTrans:EoF .or. ;
				(cOrder="accnumber" .and. oTrans:ACCNUMBER>oAcc:ACCNUMBER .or.;
				cOrder="accid".and. oTrans:accid>oAcc:accid) 
			// no transactions for this account 
			return true
		endif
	endif
	IF self:SendingMethod="SeperateFile"
		lRtf:=true
		BoldOn:="{\b "
		BoldOff:="}" 
		RedCharOn:="\cf1 "
		RedCharOff:="\cf0 "
		RedOn:= "\highlight1 "
		RedOff:="\highlight0 "
		YellowOn:="\highlight2 "
		YellowOff:="\highlight0 "
		GreenOn:="\highlight3 "
		GreenOff:="\highlight0 "
		self:cTab:="\cell\intbl "
	else
		BoldOn:=""
		BoldOff:="" 
		RedCharOn:=""
		RedCharOff:=""
		RedOn:= ""
		RedOff:=""
		YellowOn:=""
		YellowOff:=""
		GreenOn:=""
		GreenOff:=""
		if Lower(self:oReport:Extension)=="xls"
			self:cTab:=CHR(9) 
			lXls:=true
		else
			self:cTab:=Space(1)
		endif
	ENDIF
	self:cAccCurrency:=""
	self:CurAcc:=""
	aTrType:={{"AG",oLan:RGet("Assessed Gifts",,"!")+' (-10%)'},{"CH",oLan:RGet("Charges",,"!")},{"MG",oLan:RGet("Member Gifts",,"!")},{"PF",oLan:RGet("Personal Funds",,"!")}}
	self:cFrom:=oLan:RGet("from",,"!")
	self:cSubTotal:=oLan:RGet('Subtotal',,"!")
	lGiftAlwd:=ConL(oAcc:giftalwd)
	nMonthEnd:=nToYear*12+nToMonth-1
	nMonthStart:=nFromYear*12+nFromMonth-1
	CurAccid:=oAcc:AccID
	self:CurAcc:= oAcc:ACCNUMBER
	self:cAccCurrency:=oAcc:currency
	IF IsAccess(self,#Owner)
		self:Owner:STATUSMESSAGE("Printing account statement of :"+oAcc:ACCNUMBER+": regel:"+Str(Len(self:oReport:oPrintJob:aFIFO)))
	ENDIF
	lForgnC:=(!self:cAccCurrency==sCURR)
	if self:oReport:MaxWidth<57+self:DescrWidth+38 .and. lForgnC
		self:oReport:MaxWidth:=57+self:DescrWidth+38
		self:oReport:oPrintJob:Initialize(self:oReport:MaxWidth)
	elseif self:oReport:MaxWidth>=57+self:DescrWidth+35 .and. !lForgnC
		self:oReport:MaxWidth:=57+self:DescrWidth
		self:oReport:oPrintJob:Initialize(self:oReport:MaxWidth)
	endif
	self:oReport:beginreport:=self:beginreport
	me_AccNbr := Pad(oAcc:ACCNUMBER,12)
	m58_rek:=Str(oAcc:accid,-1)
	me_oms:=oAcc:Description
	me_type:=oAcc:category
	if lRtf .and.(me_type=liability .or. me_type=income)
		RedCharOn:="\cf1 "
		RedCharOff:="\cf0 "
	else
		RedCharOn:=""
		RedCharOff:=""
	endif
	IF Lower(self:oReport:Extension) # "xls"
		Heading:={if(Empty(addheading),"",addheading+Space(1))+oLan:RGet("ACCOUNT STATEMENTS",,"@!")+":"+;
			oLan:RGet(MonthEn[nFromMonth],,"!")+Space(1)+Str(nFromYear,4)+Space(1)+oLan:RGet("to")+Space(1)+;
			oLan:RGet(MonthEn[nToMonth],,"!")+Space(1)+Str(nToYear,4),;
			YellowOn+me_AccNbr+'   '+me_oms+YellowOff, Space(1)} 
		// 		self:cTab:=Space(1)
	ELSE
		// 		self:cTab:=CHR(9)
	endif
	AAdd(Heading,iif(lRtf,HeadingRTF,;
		oLan:RGet("Doc-id",10,"!")+self:cTab+oLan:RGet("Date",10,"!")+self:cTab+;
		oLan:RGet("Description",self:DescrWidth,"!")+self:cTab+iif(self:lDebCreMerge,oLan:RGet("Amount",12,"!","R"),oLan:RGet("Debit",12,"!","R")+self:cTab+oLan:RGet("Credit",12,"!","R"))+;
		iif(lForgnC,self:cTab +oLan:RGet("Currency",8,"!","C")+self:cTab+;
		iif(self:lDebCreMerge,oLan:RGet("Amount",12,"!","R"),oLan:RGet("Debit",9,"!","R"))+sCURR+;
		iif(self:lDebCreMerge,'',self:cTab+oLan:RGet("Credit",9,"!","R")+sCURR ) ,"" ) +;
		iif(self:lDebCreMerge,'',self:cTab+oLan:RGet("Transnbr",11,"!","R"))) )
	IF Lower(self:oReport:Extension) == "xls"
		AAdd(Heading,if(Empty(addheading),"",addheading+Space(1))+oLan:RGet("ACCOUNT STATEMENTS",,"@!")+":"+;
			oLan:RGet(MonthEn[nFromMonth],,"!")+Space(1)+Str(nFromYear,4)+Space(1)+oLan:RGet("to")+Space(1)+;
			oLan:RGet(MonthEn[nToMonth],,"!")+Space(1)+Str(nToYear,4))
		AAdd(Heading,YellowOn+me_AccNbr+'   '+me_oms+YellowOff)
		AAdd(Heading,Space(1))
	elseif !lRtf
		AAdd(Heading,Replicate('-',self:oReport:MaxWidth))
	endif
	jr_cur:=0
	mnd_cur:=0
	nCurMonth:=0
	store 0 to m58_deb,m58_cre,m57_giftbed,mnd_deb,mnd_cre
	store 0 to m58_debF,m58_creF,m57_giftbedF,mnd_debF,mnd_creF
	nBeginmember:=Len(self:oReport:oPrintJob:aFIFO)
	lTransFound:=false
	startdate:=SToD(Str(nFromYear,4)+StrZero(nFromMonth,2)+"01")
	enddate:=SToD(Str(nToYear,4)+StrZero(nToMonth,2)+StrZero(MonthEnd(nToMonth,nToYear),2)) 
	aOPP:={}
	do WHILE !oTrans:EOF .and. oTrans:AccID==CurAccid
		
		if !Empty(oTrans:dat) .and.oTrans:dat>=startdate .and. oTrans:dat<=enddate
			lTransFound:=true
			nThisMonth:=Integer(Year(oTrans:dat)*12)+Month(oTrans:dat)-1
			IF nThisMonth<>nCurMonth
				IF.not.Empty(mnd_cur)
					self:Month_summary(Heading,oBal,Round(m57_giftbed,DecAantal),@nRow,@nPage,oLan,mnd_cur,mnd_deb,mnd_cre,mnd_debF,mnd_creF,m58_rek,me_type,jr_cur,self:oReport,aOPP)
					aOPP:={}
				ENDIF
				mnd_deb:=0
				mnd_cre:=0
				mnd_debF:=0
				mnd_creF:=0
				m57_giftbed:=0
				m57_giftbedF:=0
				self:m71_chdeb:=0.00
				self:m71_chcre:=0.00
				self:m71_chdebF:=0.00
				self:m71_chcreF:=0.00
				self:oReport:PrintLine(@nRow,@nPage,iif(lRtf,HeadingLineRTF+"\intbl ",'')+oLan:RGet(MonthEn[Month(oTrans:dat)],,"@!")+' '+;
					Str(Year(oTrans:dat),4)+iif(lRtf,"\cell\cell\row\pard",''),Heading,10)
				IF Empty(mnd_cur)  && first month?:
					jr_cur:=Year(oTrans:dat)
					mnd_cur:=Month(oTrans:dat)
					aOPP:={}
					self:oBal:GetBalance(m58_rek,jr_cur*100+mnd_cur,jr_cur*100+mnd_cur,self:cAccCurrency)
					Description:=oLan:RGet('Beginning account balance',,"!")+Space(1)+oLan:RGet(MonthEn[mnd_cur],,"!")+Space(1)+Str(jr_cur,4)
					if lForgnC
						self:oReport:PrintLine(@nRow,@nPage,; 
						iif(lRtf,HeadingLineRTF+"\intbl "+Description, ;
							Pad(Description,20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+; 
						iif(self:lDebCreMerge,Str(self:oBal:Begin_CreF-self:oBal:Begin_DebF,12,DecAantal),;
							iif(self:oBal:Begin_DebF-self:oBal:Begin_CreF<0,Space(12)+self:cTab+Str(self:oBal:Begin_CreF-self:oBal:Begin_DebF,12,DecAantal),;
							Str(self:oBal:Begin_DebF-self:oBal:Begin_CreF,12,DecAantal)+self:cTab+Space(12)));
							+self:cTab+PadC(self:cAccCurrency,8)+self:cTab),Heading,0) 
						nRow--
					endif
					// 							oBal:GetBalance(m58_rek,me_num,jr_cur*100+mnd_cur,jr_cur*100+mnd_cur) 
					self:oReport:PrintLine(@nRow,@nPage,iif(lRtf,HeadingLineRTF+'\intbl ','')+;
						iif(lForgnC,"",iif(lRtf,Description,Pad(Description,20+self:DescrWidth))+self:cTab+iif(lRtf,'\qr ',self:cTab+self:cTab))+; 
					iif(self:lDebCreMerge,Str(self:oBal:Begin_Cre-self:oBal:Begin_Deb,iif(lRtf,-1,12),DecAantal),;
						iif(self:oBal:Begin_Deb-self:oBal:Begin_Cre<0,Space(12)+self:cTab+;
						Str(self:oBal:Begin_Cre-self:oBal:Begin_Deb,12,DecAantal),;
						Str(self:oBal:Begin_Deb-self:oBal:Begin_Cre,12,DecAantal)))+iif(lRtf,'\cell\row\pard',''),Heading,0)						
				ENDIF
				if self:oBal:Begin_Deb # self:oBal:Begin_Cre
					lTransFound:=true   // beginning balance: regard as active
				endif
				jr_cur:=Year(oTrans:dat)
				mnd_cur:=Month(oTrans:dat)
				nCurMonth:=nThisMonth
			ENDIF
			mnd_deb:=Round(mnd_deb+oTrans:deb,DecAantal)
			mnd_cre:=Round(mnd_cre+oTrans:cre,DecAantal)
			m58_deb:=Round(m58_deb+oTrans:deb,DecAantal)
			m58_cre:=Round(m58_cre+oTrans:cre,DecAantal)
			mnd_debF:=Round(mnd_debF+oTrans:DEBFORGN,DecAantal)
			mnd_creF:=Round(mnd_creF+oTrans:CREFORGN,DecAantal)
			m58_debF:=Round(m58_debF+oTrans:DEBFORGN,DecAantal)
			m58_creF:=Round(m58_creF+oTrans:CREFORGN,DecAantal)
			* member and personal gift:
			// 				IF !Empty(Val(oAcc:persid)).and. !Empty(oTrans:persid) .and. oTrans:deb<>oTrans:cre .and.!oTrans:FROMRPP .and. !oTrans:GC="CH"
			IF lGiftAlwd.and.!GiftDetails.and.!Empty(oTrans:persid) .and. oTrans:deb<>oTrans:cre .and.ConI(oTrans:FROMRPP)=0 .and. !oTrans:GC="CH"
				m57_giftbed:=Round(m57_giftbed+oTrans:cre-oTrans:deb,DecAantal)
				m57_giftbedF:=Round(m57_giftbedF+oTrans:CREFORGN-oTrans:DEBFORGN,DecAantal)
			ELSEIF ConI(oTrans:FROMRPP)==1
				//	Processing of transactions	from other PO's:
				cOPP:=AllTrim(oTrans:OPP)
				cTypeOPP:=oTrans:GC
				IF	self:SendingMethod="SeperateFile"
					description:=StrTran(StrTran(StrTran(oTrans:description,"\","\\"),"{","\{"),"}","\}")
				else
					Description:=oTrans:Description
				endif
				nMem:=MLCount(oTrans:Description,self:DescrWidth)
				IF	(nOPP:=AScan(aOPP,{|x|x[1]==cOPP	.and.	x[2]==cTypeOPP}))=0
					//						AAdd(aOPP,{cOPP,cTypeOPP,oTrans:DEB,oTrans:CRE,{oTrans:docid+space(1)+DToC(oTrans:dat)+space(1)+Pad(oTrans:description,80)+;
					AAdd(aOPP,{cOPP,cTypeOPP,oTrans:deb,oTrans:cre,oTrans:DEBFORGN,oTrans:CREFORGN,;
						{{iif(lRtf,RowRTF+"\intbl "+oTrans:docid+self:cTab+DToC(oTrans:dat)+self:cTab+oTrans:Description+self:cTab+'\qr '+Str(oTrans:cre-oTrans:deb,-1,DecAantal)+'\cell\row\pard';
						,Pad(oTrans:docid,10)+self:cTab+DToC(oTrans:dat)+self:cTab+iif(lXls,oTrans:Description,MemoLine(oTrans:Description,self:DescrWidth,1))+self:cTab+;
						iif(self:lForgnC,iif(self:lDebCreMerge,Str(oTrans:CREFORGN-oTrans:DEBFORGN,12,DecAantal),Str(oTrans:DEBFORGN,12,DecAantal)+self:cTab+Str(oTrans:CREFORGN,12,DecAantal))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
						iif(self:lDebCreMerge,Str(oTrans:cre-oTrans:deb,12,DecAantal),Str(oTrans:deb,12,DecAantal)+self:cTab+Str(oTrans:cre,12,DecAantal)+self:cTab+PadL(oTrans:TransId,11))),nMem}}})
					nOPP:=Len(aOPP)
				ELSE
					aOPP[nOPP,3]+=oTrans:deb
					aOPP[nOPP,4]+=oTrans:cre
					aOPP[nOPP,5]+=oTrans:DEBFORGN
					aOPP[nOPP,6]+=oTrans:CREFORGN 
					AAdd(aOPP[nOPP,7],;
						{iif(lRtf,RowRTF+"\intbl "+oTrans:docid+self:cTab+DToC(oTrans:dat)+self:cTab+oTrans:Description+self:cTab+'\qr '+Str(oTrans:cre-oTrans:deb,-1,DecAantal)+'\cell\row\pard';
						,Pad(oTrans:docid,10)+self:cTab+DToC(oTrans:dat)+self:cTab+iif(lXls,oTrans:Description,MemoLine(oTrans:Description,self:DescrWidth,1))+self:cTab+;
						iif(self:lForgnC,iif(self:lDebCreMerge,Str(oTrans:CREFORGN-oTrans:DEBFORGN,12,DecAantal),Str(oTrans:DEBFORGN,12,DecAantal)+self:cTab+Str(oTrans:CREFORGN,12,DecAantal))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
						iif(self:lDebCreMerge,Str(oTrans:cre-oTrans:deb,12,DecAantal),Str(oTrans:deb,12,DecAantal)+self:cTab+Str(oTrans:cre,12,DecAantal)+self:cTab+PadL(oTrans:TransId,11))),nMem})
				ENDIF
				if !lRtf .and.!lXls
					nMem:=2
					DO	WHILE	!Empty(cDesc:=MemoLine(Description,self:DescrWidth,nMem))
						AAdd(aOPP[nOPP,7],{Space(22)+cDesc,1})
						nMem++
					ENDDO
				endif
			ELSE
				IF self:SendingMethod="SeperateFile"
					Description:=StrTran(StrTran(StrTran(oTrans:Description,"\","\\"),"{","\{"),"}","\}")
				else
					Description:=oTrans:Description
				endif
				self:m71_chdeb:=Round(self:m71_chdeb+oTrans:deb,DecAantal)
				self:m71_chcre:=Round(self:m71_chcre+oTrans:cre,DecAantal)
				self:m71_chdebF:=Round(self:m71_chdebF+oTrans:DEBFORGN,DecAantal)
				self:m71_chcreF:=Round(self:m71_chcreF+oTrans:CREFORGN,DecAantal) 
				nMem:=MLCount(Description,self:DescrWidth)
				self:oReport:PrintLine(@nRow,@nPage,;
					iif(lRtf,RowRTF+"\intbl "+oTrans:docid+self:cTab+DToC(oTrans:dat)+self:cTab+oTrans:Description+self:cTab+'\qr '+Str(oTrans:cre-oTrans:deb,-1,DecAantal)+'\cell\row\pard';
					,PadR(oTrans:docid,10)+self:cTab+DToC(oTrans:dat)+self:cTab+iif(lXls,Description,MemoLine(Description,self:DescrWidth,1))+self:cTab+;
					iif(lForgnC,iif(self:lDebCreMerge,Str(oTrans:CREFORGN-oTrans:DEBFORGN,12,DecAantal),Str(oTrans:DEBFORGN,12,DecAantal)+self:cTab+Str(oTrans:CREFORGN,12,DecAantal))+;
					self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
					iif(self:lDebCreMerge,Str(oTrans:cre-oTrans:deb,12,decaantal),Str(oTrans:deb,12,decaantal)+self:cTab+Str(oTrans:cre,12,decaantal)+;
					self:cTab+PadL(Str(oTrans:TransId,-1),11))),Heading,nMem)
				if !lXls .and.!lRtf
					nMem:=2
					do	WHILE	!Empty(cDesc:=MemoLine(Description,self:DescrWidth,nMem))
						self:oReport:PrintLine(@nRow,@nPage,Space(20)+self:cTab+self:cTab+cDesc,Heading,0)
						nMem++
					ENDDO
				elseif lRtf
					nRow:=nRow+nMem-1
				endif
			ENDIF
		endif
		if !IsNil(aAssmntAmount)
			*			processing of gifts:
			IF .not. Empty(oTrans:persid) .and. oTrans:deb#oTrans:cre .and.!oTrans:GC=="CH"
				fAmnt:=  oTrans:cre - oTrans:deb
				iMonth:= Month(oTrans:dat)
				AAdd(aGiversdata,{fAmnt,oTrans:persid,AllTrim(oTrans:Description),;
					IF(ADMIN="WO".or.ADMIN="HO",Upper(oTrans:GC),""),iMonth,;
					"","","","","","",""})
				*				calculate totals assesment percode and month:
				aAssmntAmount[1,iMonth]:=aAssmntAmount[1,iMonth] + fAmnt   && total
				IF Upper(oTrans:GC) = "AG"
					AssmntRow := 2
				ELSEIF Upper(oTrans:GC) = "MG"
					AssmntRow := 4
				ELSE
					AssmntRow := 3         && default = personal fund
				ENDIF
				aAssmntAmount[AssmntRow,iMonth]:=aAssmntAmount[AssmntRow,iMonth]+fAmnt
			ENDIF
		endif
		
		oTrans:Skip()
	ENDDO
	// process summary:
	IF Empty(mnd_cur)
		mnd_cur:=Month(enddate)
		jr_cur:=Year(enddate)
	endif 
	self:Month_summary(Heading,oBal,Round(m57_giftbed,DecAantal),@nRow,@nPage,oLan,mnd_cur,mnd_deb,mnd_cre,mnd_debF,mnd_creF,m58_rek,me_type,jr_cur,self:oReport,aOPP)
	aOPP:={}
	skipaant:=4
	IF Val(Str(m58_deb))<>0 .and.Val(Str(m58_cre))<>0
		skipaant++
	endif
	self:oBal:GetBalance(m58_rek,,EndOfMonth(Today()+31),self:cAccCurrency)
	IF lForgnC
		BalDeb:=self:oBal:Per_DebF
		BalCre:=self:oBal:Per_CreF	
	endif
	self:oReport:beginreport:=self:beginreport

	// 			self:oBal:GetBalance(oAcc:accid,oAcc:balitemid)
	IF Val(Str(self:oBal:Per_Deb))<>0.and.Val(Str(self:oBal:Per_Cre))<>0
		skipaant++
	endif
	IF !self:lMinimalInfo
		self:oReport:PrintLine(@nRow,@nPage,;
			Space(20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+'------------'+iif(self:lDebCreMerge,'',self:cTab+'------------')+iif(lForgnC,Space(8)+self:cTab+self:cTab+'------------'+iif(self:lDebCreMerge,'',self:cTab+'------------'),""),Heading,skipaant)
		IF Val(Str(m58_deb))<>0 .or.Val(Str(m58_cre))<>0 .and.nMonthStart<nMonthEnd 
			self:oReport:PrintLine(@nRow,@nPage,;
				Pad(oLan:RGet('Balance',,"!")+Space(1)+oLan:RGet('transactions')+Space(1)+oLan:RGet(MonthEn[nFromMonth],,"!")+Space(1)+Str(nFromYear,4)+Space(1)+oLan:RGet("to")+Space(1)+;
				oLan:RGet(MonthEn[nToMonth],,"!")+Space(1)+Str(nToYear,4),20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+;
				iif(lForgnC,iif(self:lDebCreMerge,Str(m58_creF-m58_debF,12,DecAantal),;
				iif(m58_debF-m58_creF<0,Space(12)+self:cTab+Str(m58_creF-m58_debF,12,DecAantal),Str(m58_debF-m58_creF,12,DecAantal)+self:cTab+Space(12)))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
				IF(m58_deb-m58_cre<=0,Space(12)+self:cTab+Str(m58_cre-m58_deb,12,DecAantal),;
				Str(m58_deb-m58_cre,12,DecAantal)),Heading,0)
		endif

		self:oReport:PrintLine(@nRow,@nPage,BoldOn+;
			Pad(oAcc:ACCNUMBER+Space(1)+oLan:RGet('Account balance',,"!")+Space(1)+DToC(EndOfMonth(Today()+31)),20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+;
			iif(lForgnC,iif(self:lDebCreMerge,iif(BalCre-BalDeb<0,RedCharOn,'')+Str(BalCre-BalDeb,12,DecAantal)+iif(BalCre-BalDeb<0,RedCharOff,''),;
			iif(BalCre-BalDeb>=0,Space(12)+self:cTab+Str(BalCre-BalDeb,12,DecAantal),;
			RedCharOn+Str(BalDeb-BalCre,12,DecAantal)+RedCharOff+self:cTab+Space(12)))+self:cTab+BoldOff+PadC(self:cAccCurrency,8)+self:cTab,"") +;
			iif(self:oBal:Per_Deb > self:oBal:Per_Cre,RedOn+iif(self:lDebCreMerge,Str(self:oBal:Per_Cre-self:oBal:Per_Deb,12,DecAantal),;
			Str(self:oBal:Per_Deb-self:oBal:Per_Cre,12,DecAantal))+RedCharOff,;
			iif(self:lDebCreMerge,"",Space(12)+self:cTab+Str(self:oBal:Per_Cre-self:oBal:Per_Deb,12,DecAantal)))+BoldOff,Heading,0)
	endif
	IF self:SkipInactive .and. !lTransFound   // regard liabilities and assets always as active
		*  Skip accounts without a transaction:
		* remove added member lines:
		ASize(self:oReport:oPrintJob:aFIFO,nBeginmember)
	endif

	IF !self:beginreport .and.!oTrans:EOF
		nPage:=0 //reset page for next account
	endif
	RETURN true
FUNCTION AmntFit(nStart as int,nEnd as int,fSum as float,nLevel as int,aWork as array,Original ref array,aApplied ref array,mDebAmnt ref float,iTeller ref int) as string
***********************************************************************************
*Check fit of combination of nLevel from nEnd applied subscription amounts equal  *
* to received amount mDebAmnt                                                     *
***********************************************************************************
* nStart:	rowno in TempGift to start search
* nEnd  :	rowno to end search
* fSum  :	sum of found amounts up til now
* nLevel:	nTh amount to find
* aWork	:	work array
* Original:	array with subscription amounts
*
* returnes: F 			:	if found
*           NULL_STRING	:	if not found
*           S			: 	not unique found, stop
*
LOCAL i as int
LOCAL cReturn, myReturn:="" AS STRING
//LOCAL nwSum AS INT
LOCAL nwSum AS FLOAT
++iTeller
/*FOR i:=1 TO Len(aWork)
	sW:=sW+","+Str(awork[i])
NEXT
FOR i:=1 TO Len(aApplied)
	sA:=sA+","+Str(aApplied[i])
NEXT
Logging(Compress("amntfit:"+Str(iTeller)+" nLevel"+Str(nLevel)+" nStart:"+Str(nStart)+" fSum:"+Str(fSum)+" wrk:"+sW+" rec:"+sA)) */
FOR i=nStart TO nEnd
	nwSum:=Round(Original[i]+fSum,DecAantal)
	IF nwSum= mDebAmnt //Original
	* som gelijk aan ontvangen bedrag:
		IF !Empty(aApplied)  // al eerder gevonden?
			RETURN "S"  // niet uniek, eruit springen
			EXIT
		ENDIF
		AAdd(aWork,i)
		aApplied := ACloneShallow(aWork)
		myReturn := "F"
		ASize(aWork,nLevel-1) // gooi resultaat weer weg
	ELSEIF nwSum< mDebAmnt //Original
	* som kleiner dan ontvangen bedrag:
		IF i < nEnd // Nog een volgende?
			AAdd(aWork,i)
    	    * Zoek naar aanvullend bedrag (level +1):
			cRETURN := AmntFit(i+1,nEnd,nwSum,nLevel+1,aWork,@Original,@aApplied,@mDebAmnt,@iTeller) //Original
			IF cReturn = "S"  // Stoppen?
				RETURN "S"
			ELSEIF cReturn=="F"
				myReturn:="F"
			ENDIF
			ASize(aWork,nLevel-1) // gooi resultaat tot nu toe weg
		ELSEIF nLevel==nEnd
			RETURN "S"  // Stoppen, elke andere combinatie ook kleiner
		ENDIF
	ENDIF
NEXT
RETURN myReturn
FUNCTION AmntFitMult(nStart,nEnd,fSum,nLevel,aWork,Original,aApplied,mDebAmnt,nMultiplier,iTeller)
***********************************************************************************
* Check if a multiple of the nLevel from nEnd applied subscription amounts equal  *
* to received amount mDebAmnt                                                     *
***********************************************************************************
* nStart:	rowno in TempGift to start search
* nEnd  :	rowno to end search
* fSum  :	sum of found amounts up til now
* nLevel:	nTh amount to find
* aWork	:	work array
* Original:	array with subscription amounts
* nMultiplier: returned multiplier (call with @...)
*
* returnes: F 			:	if found
*           NULL_STRING	:	if not found
*           S			: 	not unique found, stop
*
LOCAL i as int
LOCAL cReturn, myReturn:="" AS STRING
LOCAL nwSum AS FLOAT
LOCAL aantalkeer AS FLOAT
++iTeller
FOR i=nStart TO nEnd
	nwSum:=Original[i]+fSum
	IF Empty(nwSum)
		return ""
	endif
	aantalkeer:=Round(mDebAmnt/nwSum,0)
	IF mDebAmnt==Round(aantalkeer*nwSum,DecAantal)   // geheel aantal keer?
	* som gelijk aan ontvangen bedrag:
		IF !Empty(aApplied)  // al eerder gevonden?
			RETURN "S"  // niet uniek, eruit springen
		ENDIF
		AAdd(aWork,i)
		aApplied := ACloneShallow(aWork)
		myReturn := "F"
       	nMultiplier:=INT(mDebAmnt/nwSum)
		ASize(aWork,nLevel-1) // gooi resultaat weer weg
	ELSEIF nwSum< mDebAmnt //Original
	* som kleiner dan ontvangen bedrag:
		IF i < nEnd // Nog een volgende?
			AAdd(aWork,i)
    	    * Zoek naar aanvullend bedrag (level +1):
			cRETURN := AmntFitMult(i+1,nEnd,nwSum,nLevel+1,aWork,@Original,@aApplied,@mDebAmnt,@nMultiplier,@iTeller) //Original
			IF cReturn = "S"  // Stoppen?
				RETURN "S"
			ELSEIF cReturn=="F"
				myReturn:="F"
			ENDIF
			ASize(aWork,nLevel-1) // gooi resultaat tot nu toe weg
/*		ELSEIF nLevel==nEnd
			RETURN "S"  // Stoppen, elke andere combinatie ook kleiner */
		ENDIF
	ENDIF
NEXT
RETURN myReturn
function checkpayer(myMirror) 
local payerstat:= '' as string
LOCAL i as int
local aMirror:=myMirror as array
IF Len(aMirror)=0
   RETURN ' '   && no records, always OK
ENDIF
FOR i=1 to Len(aMirror)
	IF !aMirror[i,2]==aMirror[i,3]  // Dummy line ignored: deb=cre
		IF Empty(payerstat)
			payerstat:="O" //default unlikely
		ENDIF
		IF (aMirror[i,4]='AG'.or.aMirror[i,4]='MG'.or.aMirror[i,4]='OT') .and. (Admin="WO".or.Admin="HO") //gc
	     	payerstat:='V' && obligated
   		exit
		elseif AllTrim(aMirror[i,1])==sCRE .and. aMirror[i,3] - aMirror[i,2]>0  // payment to creditor
	     	payerstat:='C' && creditor obligated
	     	exit
   	ELSEIF aMirror[i,4]='PF' .and. (Admin="WO".or.Admin="HO") //gc
      	payerstat:='W'  //likely
   	ELSEIF payerstat=='W'
      	* accept
   	ELSEIF aMirror[i,5]=='G' .or. aMirror[i,5]=='M'
        	IF aMirror[i,3] > aMirror[i,2] .or.aMirror[i,3]#0 //cre,deb,cre
           	payerstat:='W'  && likely
        	ELSE
           	payerstat:='O'  && unlikely
        	ENDIF
     	ELSE
	  		IF aMirror[i,5]== 'D';
			.or. aMirror[i,5]= 'A'.or. aMirror[i,5] = 'F'     // category
        		payerstat:='W'  && likely
        	ENDIF
   	ENDIF
   ENDIF
NEXT
return payerstat
function ChgDueAmnt(p_cln as string,p_rek as string,p_deb as float,p_cre as float) as string
	******************************************************************************
	*  Name      : ChgDueAmnt
	*              Assign received amount to due amounts of a donation or subscription
	*  Author    : K. Kuijpers
	*  Date      : 02-05-1991
	******************************************************************************

	************** PARAMETERS EN DECLARATIE VAN VARIABELEN ***********************
	*
	* p_cln   : pinternal id person
	* p_rek   : account id
	* p_deb   : debet change amount
	* p_cre   : credit change amount
	*
	LOCAL p_amount,open_amount,payed_amount as FLOAT  
	local oDue,oSub as SQLSelect 
	local oStmnt as SQLStatement
	IF Empty(p_cln) 
		RETURN ""  && apparently no due amount
	ENDIF
	p_amount:=round(p_cre - p_deb,decaantal)
	if p_amount>0
		*  Look for due amounts:
// 		oDue:=SqlSelect{"select dueamount.dueid,dueamount.amountinvoice,dueamount.amountrecvd from dueamount, subscription where subscription.subscribid=dueamount.subscribid and subscription.personid="+p_cln+" and subscription.accid="+p_rek+" and amountrecvd<amountinvoice order by dueamount.invoicedate,dueamount.seqnr for update",oConn}
		oDue:=SqlSelect{"select dueamount.dueid,dueamount.amountinvoice,dueamount.amountrecvd from dueamount, subscription "+;
		"where subscription.subscribid=dueamount.subscribid and subscription.personid="+p_cln+" and subscription.accid="+p_rek+" and amountrecvd<amountinvoice order by dueamount.invoicedate,dueamount.seqnr",oConn}
		if !Empty(oDue:Status)
			LogEvent(,"could not lock due amounts, statement:"+oDue:sqlstring+"; error:"+oDue:ErrInfo:errormessage,"log") 
			return oDue:ErrInfo:errormessage					
		elseIF oDue:RecCount>1
			do WHILE !oDue:EOF 
				open_amount:=Round(oDue:AmountInvoice-oDue:AmountRecvd,2)
				payed_amount:=iif(oDue:RECNO<oDue:RecCount,Min(p_amount,open_amount),p_amount) 
				* When not completely assigned, rest in latest due amount:
				oStmnt:=SQLStatement{"update dueamount set amountrecvd="+Str(Round(oDue:AmountRecvd+payed_amount,DecAantal),-1)+;
					" where dueid="+Str(oDue:dueid,-1),oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows>0
					p_amount:=Round(p_amount-payed_amount,DecAantal)
				elseif !Empty(oStmnt:Status)
					return oStmnt:ErrInfo:errormessage					
				endif
				if p_amount<=0
					exit
				endif
				oDue:skip()
			ENDDO
		ENDIF
	ELSE
		*  Look for last assigned due amount to reverse assignment of received amounts:
// 		oDue:=SqlSelect{"select dueamount.dueid,dueamount.amountrecvd from dueamount, subscription where subscription.subscribid=dueamount.subscribid and subscription.personid="+p_cln+" and subscription.accid="+p_rek+" and dueamount.amountrecvd>0 order by dueamount.invoicedate desc,dueamount.seqnr desc for update",oConn}
		oDue:=SqlSelect{"select dueamount.dueid,dueamount.amountrecvd from dueamount, subscription "+;
		"where subscription.subscribid=dueamount.subscribid and subscription.personid="+p_cln+" and subscription.accid="+p_rek+" and dueamount.amountrecvd>0 order by dueamount.invoicedate desc,dueamount.seqnr desc",oConn}
		if !Empty(oDue:Status)
			LogEvent(,"could not lock due amounts, statement:"+oDue:sqlstring+"; error:"+oDue:ErrInfo:errormessage,"log") 
			return oDue:ErrInfo:errormessage					
		elseIF oDue:RecCount>1
			p_amount:=-p_amount
			do WHILE !oDue:EOF.and.p_amount>0
				payed_amount:=oDue:AmountRecvd
				oStmnt:=SQLStatement{"update dueamount set amountrecvd="+Str( Max(0,oDue:AmountRecvd-p_amount),-1)+" where dueid="+Str(oDue:dueid,-1),oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows>0
					p_amount:=p_amount-Min(payed_amount,p_amount)
				elseif !Empty(oStmnt:Status)
					return oStmnt:ErrInfo:errormessage					
				endif
				oDue:skip()
			ENDDO
		endif
		IF p_amount>0
			* Create new due amount:
			oSub:=SqlSelect{"select subscribid from subscription where personid="+p_cln+" and accid="+p_rek,oConn}
			if oSub:RecCount>0   
				oStmnt:=SQLStatement{"insert into dueamount (subscribid,invoicedate,seqnr,amountrecvd) values ("+Str(oSub:subscribid,-1)+",Now(),1,"+Str(p_amount,-1)+")",oConn}
				oStmnt:Execute()
				if !Empty(oStmnt:Status)
					return oStmnt:ErrInfo:errormessage					
				endif
			endif
		ENDIF
	ENDIF
	RETURN ""

METHOD AccntProc(cAccValue) CLASS General_Journal
	LOCAL oHm as TempTrans
	local cFilter as string
	oHm:=self:Server
	if !oHm:lFilling
		self:lStop:=false 
	endif
	IF !oHm:lFilling    && in case of update existing transaction skip
		IF !Empty(oHm:CheckUpdates())
			oHm:AccID:=oHm:aMirror[oHm:Recno,1]  && reset old values
			RETURN FALSE
		ENDIF
	ENDIF
	cFilter:=MakeFilter(,,,,true,oHm:aTeleAcc)
	cFilter+=iif(Empty(cFilter),''," and ")+"a.active=1"		
	AccountSelect(self,AllTrim(cAccValue),"Account",true,cFilter)
	RETURN nil
METHOD append() CLASS General_Journal
	LOCAL cOms,cOpp AS STRING
	LOCAL oHm:=self:server as TempTrans 
	local lSuccess as logic
	IF !oHm:eof
		if !oHm:RECNO==oHm:Reccount
			self:GoBottom()
		endif
		cOms:=oHm:DESCRIPTN
		cOPP:=oHm:OPP
	ENDIF
// 	lSuccess:=self:StatusOK()	
	lSuccess:=SUPER:append()
	
	If Len(oHm:aMirror)=1
		IF	fTotal>0
			oHm:CREFORGN:=fTotal
			oHm:Cre:=fTotal
		ELSE
			oHm:DEBFORGN:=Abs(fTotal)
			oHm:Deb:=Abs(fTotal)
		ENDIF
	ENDIF
	oHm:CURRENCY:=sCurr
	oHm:FROMRPP:=oHm:lFromRPP  // duplicate fromrpp-indication
	oHm:OPP:=cOPP
	oHm:DESCRIPTN:=cOms
	&& add empty row to mirror:
	AAdd(oHm:aMirror,{'           ',oHm:deb,oHm:cre,'  ',' ',oHm:RECNO,0,' ','','',sCurr,false,oHm:DEBFORGN,oHm:CREFORGN,"",oHm:DESCRIPTN,"","",oHm:INCEXPFD,0})
RETURN true
METHOD ChgDueAmnts(action as string,oOrig as TempTrans,oNew as TempTrans) as string CLASS General_Journal
* Update of corresponding due amounts:
* Action W : update of account/person
*        WB: update amount only
*        T : add of transaction line
*        D : delete of transaction line
* 
local cError as string
IF (oOrig:KIND=="D".or.oOrig:KIND=="A".or.oOrig:KIND=="F".or.oOrig:KIND=="M".or.oOrig:KIND=="G");
.and..not.Empty(self:OrigPerson)
   IF action=="WB"
      * Update amount received of due amount:
      return ChgDueAmnt(self:OrigPerson,oNew:AccID,oNew:deb - oOrig:deb,;
      oNew:cre - oOrig:cre)
   ELSEIF action=="W".or.action=="D"
      * Reverse amount received:
      cError:= ChgDueAmnt(self:OrigPerson,oOrig:AccID,-oOrig:Deb,-oOrig:Cre)
      if !Empty(cError)
      	return cError
      endif
   ENDIF
ENDIF

IF action=="W".or.action=="T"
   * record new amount received:
   IF (oNew:KIND=="D".or.oNew:KIND=="A".or.oNew:KIND=="F".or.oNew:KIND=="M".or.oNew:KIND=="G");
   .and..not.Empty(self:mCLNGiver)
      return ChgDueAmnt(self:mCLNGiver,oNew:AccID,oNew:deb,oNew:cre)
   ENDIF
ENDIF

RETURN ""
 METHOD Delete() CLASS General_Journal
 * delete record of TempTrans:
LOCAL ThisRec, CurRec AS INT
LOCAL oHm as TempTrans
LOCAL Success AS LOGIC

oHm:=self:oSFGeneralJournal1:Server	
// CurRec:=oHm:RecNo

IF Empty(oHm:aMirror)  && nothing to delete?
	RETURN FALSE
ENDIF
IF !Empty(oHm:CheckUpdates())
	RETURN FALSE
ENDIF
IF (self:lTeleBank .or. oHm:FROMRPP) .and. oHm:Recno==1
 	(ErrorBox{,'Modification of ' + iif(self:lTeleBank,'telebanking account','RPP transaction') + ' not allowed'}):show()
    RETURN FALSE
ENDIF		

// ThisRec:=AScan(oHm:aMirror, {|x| x[6]==oHm:RECNO})
ThisRec:=oHm:RECNO

IF !Empty(ThisRec) .and.!(oHm:Eof.and.oHm:BOF)
	ADel(oHm:aMirror,ThisRec)  && remove row from mirror
	ASize(oHm:aMirror,Len(oHm:aMirror)-1)
	SUPER:Delete(TRUE)
	Success:=oHm:Pack() 
	self:AddCur()
	self:Totalise(true,false)
	IF oHm:EoF
		oHm:gotop()
	ENDIF
	SELF:oSFGeneralJournal1:Browser:REFresh()
ENDIF
RETURN TRUE
METHOD FilePrint() CLASS General_Journal
	LOCAL oHm:=self:Server as TempTrans
	LOCAL nRow, i, nCurRec,nMem, nWidth:=136 as int, cDesc as STRING
	LOCAL nPage as int
	LOCAL aHeader:={} as ARRAY
	LOCAL oReport as PrintDialog 
	local multicurr as logic
	local cTab:=CHR(9) as string
	local lXls:=true as logic
	local cColumns as string 
	if AScan( oHm:aMirror,{|x|!Empty(x[11]).and.x[11] # sCURR})>0
		multicurr:=true
		nWidth+=30
	endif
	oReport := PrintDialog{self,"Financial Records",,nWidth,DMORIENT_PORTRAIT,"xls"}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	IF Lower(oReport:Extension) #"xls"
		cTab:=Space(1)
		lXls:=false
		aHeader :={self:oLan:RGet("Financial Records",,"!")}
	ENDIF 
	cColumns:=self:oLan:RGet("Account",52,"@!")+cTab+self:oLan:RGet("Reference",12,"@!")+cTab+self:oLan:RGet("Description",40,"@!")+cTab+self:oLan:RGet("Debit",12,"@!","R");
		+cTab+self:oLan:RGet("Credit",12,"@!","R")+iif(multicurr,cTab+self:oLan:RGet("Cur",3,"@!")+;
		cTab+PadL(self:oLan:RGet("Debit",,"@!")+"-"+sCURR,12);
		+cTab+PadL(self:oLan:RGet("Credit",,"@!")+"-"+sCURR,12),"") +cTab+self:oLan:RGet("Ass",3,"@!")
	if lXls
		AAdd(aHeader,cColumns)
	endif
	nCurRec:=oHm:RecNo
	oHm:SuspendNotification()
	oHm:Gotop()
	nRow:=0
	nPage:=0
	SetDecimalSep(Asc(DecSeparator))
	oReport:PrintLine(@nRow,@nPage,;
		Pad(oLan:RGet("transaction number",,"!")+":",20)+AllTrim(transform(self:mTRANSAKTNR,""))+if(lInqUpd,"","(prior)"),aHeader)
	oReport:PrintLine(@nRow,@nPage,;
		Pad(oLan:RGet("date",,"!")+":",20)+DToC(self:mDAT),aHeader)
	oReport:PrintLine(@nRow,@nPage,;
		Pad(oLan:RGet("document id",,"!")+":",20)+mBst,aHeader)
	IF !Empty(mCLNGiver)
		oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("Person",,"!")+":",aHeader)
		oReport:PrintLine(@nRow,@nPage,self:cGiverName,aHeader)
	ENDIF
	oReport:PrintLine(@nRow,@nPage," ")  //empty line

	oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("Transaction lines",nWidth,"@!","C"),aHeader)
	if !lXls
		AAdd(aHeader,cColumns) 
		oReport:PrintLine(@nRow,@nPage,cColumns,aHeader)
		oReport:PrintLine(@nRow,@nPage,Replicate('-',nWidth),aHeader)
	endif

	DO WHILE !oHm:EOF
		oReport:PrintLine(@nRow,@nPage,;
			iif(lXls,AllTrim(oHm:ACCNUMBER),SubStr(oHm:ACCNUMBER,1,11))+Space(1)+iif(lXls,AllTrim(oHm:AccDesc),PadR(oHm:AccDesc,40))+cTab+; 
		PadR( oHm:REFERENCE,12)+cTab+;
			+iif(lXls,oHm:DESCRIPTN,MemoLine(oHm:DESCRIPTN,40,1))+cTab+;
			iif(multicurr,Str(oHm:DEBFORGN,12,DecAantal)+cTab+Str(oHm:CREFORGN,12,DecAantal)+cTab+oHm:CURRENCY+cTab,"")+;	
		Str(oHm:deb,12,decaantal)+cTab+Str(oHm:cre,12,decaantal)+;
			' '+PadC(oHm:gc,3),aHeader)
		nMem:=2
		DO WHILE !Empty(cDesc:=MemoLine(oHm:DESCRIPTN,40,nMem))
			oReport:PrintLine(@nRow,@nPage,Space(66)+cDesc,aHeader)
			nMem++
		ENDDO
		oHm:Skip()
	ENDDO
	oHm:RecNo:=nCurRec
	oHm:ResetNotification() 
	SetDecimalSep(Asc('.'))
	oReport:prstart()
	oReport:prstop()
	RETURN nil
METHOD FillBatch(pBst as string,pDat as date,cGiver as string,cDescription as string, cExId as string, nPostStatus:=0 as int) CLASS General_Journal
Local lFound as logic 
Local aWord as array,lenAW as int
local oPersCnt:=PersonContainer{} as PersonContainer
	mCLNGiver := ""
	cGiverName := ""
	mPerson := cGiver                                              
	self:oDCmPerson:TEXTValue := cGiver
	self:oDCmPerson:Value:= cGiver
	if !Empty(cExId) .and. !cExId=="0000000000"
		oPersCnt:m51_exid:=cExId
		lFound:=PersonGetByExID(self,cExId,"Giver of imported transaction")
		if !lFound
			if sEntity="CZR"
				aWord:=Split(cGiver," ")
				lenAW:=Len(aWord)
				if lenAW>1
					oPersCnt:m51_firstname:=aWord[lenAW]
					lenAW--
					oPersCnt:m51_lastname:=Implode(aWord," ",1,lenAW)
					cGiver:=oPersCnt:m51_lastname
				else
					oPersCnt:m51_lastname:=cGiver
					oPersCnt:m51_firstname:=""
				endif
			endif
		endif
	endif
	IF !Empty(cGiver) .and.!lFound
		SELF:cGiverName:=cGiver
		PersonSelect(self,cGiver,true,,"Giver of imported transaction",oPersCnt)
    ENDIF
	*SELF:oDCmPerson:SetFocus()
  	self:oDCmDat:Value := pDat
	SELF:mBst := pBst
	SELF:oDCmBST:disable()
	SELF:oDCmDat:disable()
	oCCImportButton:Hide()
	SELF:lImport := TRUE
	oDCGiroText:TEXTValue:=AllTrim(cDescription) 
	self:mPostStatus:=nPostStatus
	
//	SELF:Server:GOTOP() 
// 	self:Totalise(false,false)
*	DO WHILE !SELF:server:EoF
		self:oSFGeneralJournal1:DebCreProc()
*		SELF:Server:Skip()
*	ENDDO
*	SELF:Server:GoTop()
RETURN
METHOD FillRecord(cTransnr as string,oBrowse as JournalBrowser,mOrigPers as string,mOrigDat as date,mOrigBst as string,cOrigUser as string,nOrigPost as int,oCaller as General_Journal,lLocked as logic) CLASS General_Journal
	* Filling of windowfields with existing transaction for inquiry/update
	LOCAL oHm as TempTrans
	local oPersCnt as PersonContainer 
	// 	Default(@nOrigPost,0)
	*	LOCAL oPers AS Person
	oHm := SELF:Server
	//oTransH:=oBrowse:Owner:Server
	self:oOwner:=oCaller
	self:mBST := mOrigBst
	self:mDat:=mOrigDat
	self:CurDate:=mOrigDat
	self:OrigDat := mOrigDat
	self:OrigBst := AllTrim(self:mBST)
	SELF:oDCUserdIdTxt:TextValue:=cOrigUser
	self:lInqUpd := true
	oHm:lInqUpd := TRUE
	oHm:oDat := OrigDat
	self:oInqBrowse:= oBrowse
	self:oDCmTRANSAKTNR:TextValue:=cTransnr
	self:oDCSC_TRANSAKTNR1:TEXTValue:=""
	self:mPostStatus:=nOrigPost
	oHm:lFilling:=true
	self:OrigPerson := mOrigPers
	*	IF oHm:Locate({|| oHm:BFM=="H".or.oHm:bfm=="T"}) .or.!Empty(dat_controle(OrigDat,TRUE))
	IF !Empty(mOrigDat).and.!Empty(dat_controle(mOrigDat,TRUE))
		SELF:oSFGeneralJournal1:BlockColumns()
		SELF:oCCOKButton:Hide()
		oHm:lOnlyRead:=TRUE
		SELF:oDCmDat:DateRange:=DATERange{mOrigDat,Today()+31}
	ENDIF
	self:mDAT := mOrigdat
	if oHm:lFromRPP
		self:oDCmDat:Disable()
	endif
	oHm:SuspendNotification()
	oHm:GoTop()
	oHm:lFromRPP:=oHm:FROMRPP
	self:Totalise(false,false)
	oHm:ResetNotification()
	// 	SELF:oSFGeneralJournal1:browser:refresh()
	* Restore filter of TempTrans:account:
	IF !Empty(self:OrigPerson)
		oPersCnt:=PersonContainer{}
		oPersCnt:persid:=self:OrigPerson
		self:RegPerson(oPersCnt)
		*		oPers:Close()
	ENDIF
	if lLocked
		self:oCCOKButton:Hide()
		self:oCCSaveButton:Hide() 
	endif
	if Posting
		if nOrigPost=2
			self:oDCmPostStatus:FillUsing({{"Not Posted",0},{"Ready to Post",1},{"Posted",2}}) 
			self:mPostStatus:=nOrigPost
			self:oCCOKButton:Hide()
			self:oCCSaveButton:Hide() 
		endif
		IF nOrigPost=1 .and. AScan(aMenu,{|x| x[4]=="PostingBatch"})>0
			self:oCCPostButton:Show()
		endif
	endif
	if OrigDat < MinDate
		self:oCCOKButton:Hide()
		self:oCCSaveButton:Hide() 
	endif		

	self:oCCTeleBankButton:Hide()
	oCCImportButton:Hide()
	oHm:lFilling:=false 
	if oHm:RecCount>5
		self:Find()
	endif

	RETURN
METHOD FillTeleBanking() as void pascal CLASS General_Journal
	* Filling of windowfields := giroteltransaction-values
	LOCAL m53_komma, m53_oms1, m53_oms2 AS STRING
	LOCAL m53_maand, m53_dag, m53_jaar as int
	LOCAL oHm as TempTrans
	LOCAL lError as LOGIC
	Local CurRate as Float
local oAcc as SQLSelect
local cWhere:="a.balitemid=b.balitemid"
local cFrom:="balanceitem as b,account as a left join member m on (m.accid=a.accid or m.depid=a.department) left join department d on (d.depid=m.depid)" 
local cFields:="a.*,b.category as type,m.co,m.persid as persid,"+SQLIncExpFd()+" as incexpfd,"+SQLAccType()+" as accounttype"
	if Empty(self:server)
		return     // owner closed
	endif
	self:mCLNGiver:=''
	IF self:server:Lastrec > 0
		SELF:Reset()
	ENDIF
	oHm := SELF:Server
	SELF:append()
	self:mCLNGiver := self:oTmt:m56_persid
	self:cGiverName := ""
	self:mPerson := ""
	self:mDAT:=self:oTmt:m56_bookingdate
	self:mBst:=AllTrim(self:oTmt:m56_kind)+Str(self:oTmt:m56_seqnr,-1)
	oHm:AccID := self:oTmt:m56_sgir
	IF Empty(self:oTmt:m56_contra_name).or.Empty(self:oTmt:m56_description)
		m53_komma:=''
	ELSE
		m53_komma:=','
	ENDIF
	m53_oms1:=AllTrim(self:oTmt:m56_contra_name)+m53_komma+self:oTmt:m56_description
	m53_oms2:=AllTrim(self:oTmt:m56_description)+m53_komma+self:oTmt:m56_contra_name
	if Empty(self:oTmt:m56_contra_name) .and.!Empty(self:oTmt:m56_contra_bankaccnt)
		oDCGiroText:TEXTValue:=AllTrim(self:oTmt:m56_description)+"("+self:oTmt:m56_contra_bankaccnt+")" 
	else
		oDCGiroText:TEXTValue:=AllTrim(self:oTmt:m56_contra_name)+ ": "+AllTrim(self:oTmt:m56_description)
	endif
// 	if self:oTmt:m56_description="NAAM/NUMMER STEMMEN NIET OVEREEN" 
	if self:oTmt:m56_kind="COL" .and. self:oTmt:m56_addsub ="A" .and. AtC("Geweigerd:",self:oTmt:m56_description)>0    // refused order
		oHm:AccID:=self:oTmt:m56_payahead 
		self:oTmt:m56_autmut:=FALSE
	endif

	IF self:oTmt:m56_addsub ="B"
		oHm:deb := self:oTmt:m56_amount
		oHm:debforgn := self:oTmt:m56_amount
	ELSE
		oHm:cre := self:oTmt:m56_amount
		oHm:CREFORGN := self:oTmt:m56_amount
	ENDIF
	oHm:CURRENCY:=sCurr
	IF self:oTmt:m56_kind="GT" .or.self:oTmt:m56_kind="GM".or.self:oTmt:m56_kind="COL"
		oHm:DESCRIPTN := m53_oms1
	ELSE
		oHm:DESCRIPTN := m53_oms2
	ENDIF

	IF !Empty(oHm:AccID)
		cWhere+=" and a.accid = "+ZeroTrim(oHm:AccID) 
		oAcc:=SQLSelect{"Select "+cFields+" from "+cFrom+" where "+cWhere,oConn}
		if oAcc:RecCount>0 
			// Process foreign currency:
			if !oAcc:CURRENCY==sCurr
				if oCurr==null_object
					oCurr:=Currency{"Importing telebanking"}
				endif
				CurRate:=oCurr:GetROE(oAcc:CURRENCY,self:mDAT)
				oHm:deb:=Round(CurRate*oHm:debforgn,DecAantal)
				oHm:cre:=Round(CurRate*oHm:creforgn,DecAantal)
				self:oTmt:m56_amount:=Round(self:oTmt:m56_amount*CurRate,DecAantal)
			endif
			SELF:RegAccount(oAcc)   //This includes an append
		ENDIF
	ENDIF
	
	oHm:GoBottom()
	IF self:oTmt:m56_addsub ="B"
		oHm:cre := self:oTmt:m56_amount
		oHm:CREFORGN := self:oTmt:m56_amount
		oHm:deb := 0.00
	ELSE
		oHm:deb := self:oTmt:m56_amount
		oHm:debforgn := self:oTmt:m56_amount
		oHm:cre := 0.00
	ENDIF 
	oHm:CURRENCY:=sCurr
	IF self:oTmt:m56_kind="GT" .or.self:oTmt:m56_kind="GM".or.self:oTmt:m56_kind="IC"
		oHm:DESCRIPTN := m53_oms2
	ELSE
		oHm:DESCRIPTN := m53_oms1
	ENDIF 
	if self:oTmt:m56_description="NAAM/NUMMER STEMMEN NIET OVEREEN" 
		oHm:AccID:=SCRE
		IF !Empty(oHm:AccID)
			cWhere+=" and a.accid = "+ZeroTrim(oHm:AccID) 
			oAcc:=SQLSelect{"Select "+cFields+" from "+cFrom+" where "+cWhere,oConn}
			if oAcc:RecCount>0 
				self:RegAccount(oAcc)   
			ENDIF
		ENDIF
	endif

	IF self:oTmt:m56_kind="GM"
		self:mDAT:=CToD(SubStr(self:oTmt:m56_description,1,8))
		IF self:mDAT > self:oTmt:m56_boekdatum .or. self:mDAT < (self:oTmt:m56_boekdatum - 20)
			self:mDAT:=self:oTmt:m56_boekdatum
		ENDIF
	ELSEIF self:oTmt:m56_kind="PK"
		m53_maand:=AScan(maand,Lower(SubStr(self:oTmt:m56_description,4,3)))
		m53_dag:=Val(SubStr(self:oTmt:m56_description,1,2))
		IF m53_maand>0
			m53_jaar:=Year(self:oTmt:m56_boekdatum)
			IF m53_maand=12.and.Month(self:oTmt:m56_boekdatum)=1
				m53_jaar:=m53_jaar-1
			ENDIF
			SELF:mDAT:=CToD(Str(m53_dag,2)+'-'+Str(m53_maand,2)+'-'+Str(m53_jaar,4))
			IF self:mDAT > self:oTmt:m56_boekdatum .or. self:mDAT < (self:oTmt:m56_boekdatum - 20)
				self:mDAT:=self:oTmt:m56_boekdatum
			ENDIF
		ENDIF
	ENDIF 
	IF self:oTmt:m56_recognised
		self:ProcRecognised()
		if self:oTmt:m56_description="NAAM/NUMMER STEMMEN NIET OVEREEN" 
     		self:oTmt:m56_recognised:=FALSE
			self:oTmt:m56_autmut:=FALSE
		endif
	ENDIF
	if !Empty(self:mCLNGiver)
		self:PersonButton(true)
	endif
*	IF self:oTmt:m56_recognised
		self:oSFGeneralJournal1:DebCreProc()
*	ENDIF
// 	SELF:oDCmBST:disable()
	SELF:oDCmDat:disable()
	if self:oTmt:m56_description="NAAM/NUMMER STEMMEN NIET OVEREEN" .and.!self:oTmt:m56_mode_aut 
		self:oDCmPerson:TEXTValue:=self:oTmt:m56_contra_bankaccnt
		self:PersonButton(true)
	endif
	oHm:GoBottom()
RETURN	
METHOD ProcRecognised() CLASS General_Journal
LOCAL oHm as TempTrans
LOCAL cSearch as STRING 
Local CurRate as Float 
local oAcc as SQLSelect
local cWhere:="a.balitemid=b.balitemid"
local cFrom:="balanceitem as b,account as a left join member m on (m.accid=a.accid or m.depid=a.department) left join department d on (d.depid=m.depid)" 
local cFields:="a.*,b.category as type,m.co,m.persid as persid,"+SQLIncExpFd()+" as incexpfd,"+SQLAccType()+" as accounttype"
oHm := self:Server
IF !Empty(self:oTmt:m56_accid)
	cWhere+=" and a.accid = "+self:oTmt:m56_accid 
ELSEif !Empty(self:oTmt:m56_accnumber) 
	cWhere+=" and a.accnumber = '"+LTrimZero(self:oTmt:m56_accnumber)+"'" 
ELSE
	self:oTmt:m56_recognised:=FALSE
	self:oTmt:m56_autmut:=FALSE
	return
ENDIF
oAcc:=SQLSelect{"Select "+cFields+" from "+cFrom+" where "+cWhere,oConn}
if oAcc:RecCount>0 
	// Process foreign currency:
	if !oAcc:CURRENCY==sCURR
		if oCurr==null_object
			oCurr:=Currency{"Importing telebanking"}
		endif
		CurRate:=oCurr:GetROE(oAcc:CURRENCY,self:mDAT)
		oHm:DEBFORGN:=Round(oHm:deb/CurRate,DecAantal)
		oHm:CREFORGN:=Round(oHm:cre/CurRate,DecAantal)
	endif
	self:RegAccount(oAcc)
ELSE
	self:oTmt:m56_recognised:=FALSE
	self:oTmt:m56_autmut:=FALSE
ENDIF
RETURN
METHOD RegAccount(omAcc as SQLSelect, cItemname:="" as string) CLASS General_Journal
	LOCAL oHm:=self:Server as TempTrans
	LOCAL oAccount as SQLSelect
	LOCAL crek,cNum,cPersId,cType as STRING
	LOCAL ThisRec:=oHm:RECNO,recnr as int
	LOCAL CurGC as STRING
	local MultiCur:=false as logic
	local fDebSav,fCreSav as float 
	Local ROE:=1 as float
	if oHm==null_object
		return nil
	endif
	if !oHm:lFilling
		self:lStop:=false
	endif
	//"a.accid,a.accnumber,a.description,a.department,a.balitemid,a.currency,a.multcurr,a.active, if(active=0,'NO','') as activedescr,b.category as type,m.co,m.persid as persid,"+SQLAccType()+" as accounttype"
	CurGC:=oHm:GC
	IF Empty(omAcc).or.omAcc==null_object .or.omAcc:Reccount<1
		crek:=Space(11)
		oHm:AccID:=crek
		oHm:AccDesc := ''
		oHm:ACCNUMBER:=''
		oHm:INCEXPFD:=''
		oHm:KIND:=''
		oHm:gc:=''
	ELSE
		oAccount:=omAcc
		crek := ConS(oAccount:AccID)
		oHm:AccID :=  crek
		oHm:AccDesc := oAccount:Description
		oHm:ACCNUMBER:=oAccount:ACCNUMBER
		oHm:incexpfd:=oAccount:incexpfd
		oHm:KIND:=Upper(oAccount:accounttype)
		oHm:DEPID:=ConI(oAccount:department)
		if !Empty(oAccount:persid) .and.(oHm:KIND=="M" .or.(oHm:KIND='K' .and.!Empty(oHm:incexpfd)))
			cPersId:=ConS(oAccount:persid)
// 			if (oHm:cre-oHm:deb)<0 .or.Empty(self:mCLNGiver).and.(oHm:cre-oHm:deb)=0
			if (oHm:cre-oHm:deb)<0 .and.Empty(self:mCLNGiver)
				self:mCLNGiver:=cPersId
			endif
		endif
		oHm:CURRENCY:= oAccount:CURRENCY 
		cNum:=Str(oAccount:balitemid,-1)
		MultiCur:=iif(ConI(oAccount:MULTCURR)=1,true,false)
		cType:=oAccount:type 
		if !(oAccount:accounttype=="M" .or.oAccount:accounttype=='K')
			if CurGC=="CH"
				// replace MG if needed: 
				recnr := 0
				do WHILE (recnr:=AScan(oHm:aMirror,{|x| x[4] =='MG'},recnr+1))>0
					oHm:Goto(recnr)
					oHm:gc := 'AG'
					oHm:aMirror[recnr,4]:=oHm:gc  && save in mirror
				ENDDO
				oHm:Goto(ThisRec)
			endif
			oHm:gc:=" "
		ENDIF

	ENDIF
	IF oHm:FROMRPP .and. !Empty(CurGC) 
		// in case of import from RPP keep old GC code
		oHm:GC:=CurGC
	ENDIF
	* save in mirror-array
	// aMirror: {accID,deb,cre,gc,category,recno,Trans:RecNbr,accnumber,AccDesc,balitemid,curr,multicur,debforgn,creforgn,PPDEST, description,persid,type, incexpfd,depid}
	//            1      2   3  4     5      6          7         8        9        10     11     12      13        14      15       16          17   18      19      20
	oHm:aMirror[ThisRec,1]:=AllTrim(cRek)
	oHm:aMirror[ThisRec,4]:=oHm:Gc
	oHm:aMirror[ThisRec,5]:=oHm:KIND
	oHm:aMirror[ThisRec,8]:=AllTrim(oHm:ACCNUMBER)
	oHm:aMIRROR[ThisRec,9]:=AllTrim(oHm:AccDesc)
	oHm:aMIRROR[ThisRec,10]:=AllTrim(cNum)
	oHm:aMirror[ThisRec,11]:=oHm:CURRENCY
	oHm:aMirror[ThisRec,12]:= MultiCur
	oHm:aMirror[ThisRec,16]:=AllTrim(oHm:DESCRIPTN)
	oHm:aMirror[ThisRec,17]:= cPersId
	oHm:aMirror[ThisRec,18]:= cType
	oHm:aMirror[ThisRec,19]:= oHm:incexpfd
	oHm:aMirror[ThisRec,20]:= oHm:DepID
	self:oSFGeneralJournal1:AddCurr()
	IF !oHm:lFilling.and.!Empty(cRek)
		//		oHm:SuspendNotification() 
		fDebSav:=oHm:aMirror[ThisRec,2]
		fCreSav:=oHm:aMirror[ThisRec,3]
		self:oSFGeneralJournal1:DebCreProc(false)
		if oHm:aMirror[ThisRec,11] # sCurr .and. fCreSav # fDebSav
			// 	if foreign currency recalculate debforeign, creforeign 
			self:lwaitingForExchrate:=true
			if self:oCurr==null_object
				self:oCurr:=Currency{}
			endif
			ROE:=self:oCurr:GetROE(oHm:CURRENCY,self:mDat)
			self:lwaitingForExchrate:=false
			if self:oCurr:lStopped
				self:EndWindow()
				return
			endif
			oHm:DEBFORGN:=Round(fDebSav/ROE,DecAantal)
			oHm:CREFORGN:=Round(fCreSav/ROE,DecAantal)
			oHm:deb:=fDebSav
			oHm:cre:=fCreSav
			self:oSFGeneralJournal1:DebCreProc(false)
		endif

		self:ShowBankBalance()
		self:oSFGeneralJournal1:Browser:SetColumnFocus(#AccDesc)
		//		oHm:ResetNotification()
	ENDIF
	RETURN nil
METHOD RegPerson(oCLN) CLASS General_Journal
	LOCAL oHm:=self:server as TempTrans
	LOCAL ThisRec,recnr,i,Type as int
	local oSel as SQLSelect 
	if self:server==null_object  // apparently owner closed
		return nil
	endif
	ThisRec:=oHm:Recno
	IF !Empty(oCLN)
		self:mCLNGiver :=  iif(IsNumeric(oCLN:persid),Str(oCLN:persid,-1),oCLN:persid) 
		if !Empty(self:mCLNGiver)
			oSel:=SqlSelect{"select "+SQLFullName() +" as fullname,type from person where persid="+self:mCLNGiver,oConn}
			oSel:Execute()
			if oSel:RecCount>0
				self:cGiverName:=oSel:fullname 
				self:lDirectIncome:=false 
				self:lMemberGiver := FALSE
				if (i:=AScan(pers_types_abrv,{|x|x[2]==oSel:TYPE}))>0
					if pers_types_abrv[i,1]=='DIR'
						self:lDirectIncome:=true 
					elseif pers_types_abrv[i,1]=='MBR' .or. pers_types_abrv[i,1]=='ENT' 
						self:lMemberGiver := true
					endif
				endif
				self:oDCmperson:TEXTValue := self:cGiverName 
				self:cOrigName:=self:cGiverName
				// 				IF SqlSelect{"select mbrid from member where persid="+self:mCLNGiver,oConn}:Reccount>0
				// 					self:lMemberGiver := true
				// 				ELSEif AScan(oHm:aMirror,{|x| x[4] =='CH'})=0
				// 					self:lMemberGiver := FALSE
				// 				ENDIF
				if !self:Server:lFilling
					self:lStop:=false
				endif
			else
				// 			self:lMemberGiver := true
				self:oDCmperson:Value:=""
				self:cOrigName:=""
				self:lDirectIncome:=false
				if AScan(oHm:aMirror,{|x| x[4] =='CH'})=0
					self:lMemberGiver := false
				endif
			endif
		else
			self:oDCmperson:Value:=""
			self:cOrigName:=""
			self:lDirectIncome:=false
			if AScan(oHm:aMirror,{|x| x[4] =='CH'})=0
				self:lMemberGiver := false
			endif
		endif
	ELSE
		if IsNil(oCLN)
			self:oDCmperson:Value := self:cOrigName
		else
			if AScan(oHm:aMirror,{|x| x[4] =='CH'})=0
				self:lMemberGiver := false
			endif
			self:lStop:=false
			self:mCLNGiver :=  ""
			self:cGiverName := ""
			self:oDCmperson:TEXTValue := "" 
			self:lDirectIncome:=false
		endif
	ENDIF
	if self:lDirectIncome .and. self:lMemberGiver
		self:lMemberGiver:=false
	endif
	if !self:server:lFilling
		if self:lMemberGiver
			// replace AG with MG if needed
			recnr := 0
			do WHILE (recnr:=AScan(oHm:aMirror,{|x| x[4] =='AG'},recnr+1))>0
				oHm:Goto(recnr)
				oHm:gc := 'MG'
				oHm:aMirror[recnr,4]:=oHm:gc  && save in mirror
				oHm:Goto(ThisRec)
			ENDDO
		else
			if AScan(oHm:aMirror,{|x| x[4] =='CH'})=0
				// replace MG if needed: 
				recnr := 0
				do WHILE (recnr:=AScan(oHm:aMirror,{|x| x[4] =='MG'},recnr+1))>0
					oHm:Goto(recnr)
					oHm:gc := 'AG'
					oHm:aMirror[recnr,4]:=oHm:gc  && save in mirror
				ENDDO
				oHm:Goto(ThisRec)
			endif
		endif 
	endif

	RETURN nil
METHOD ReSet() CLASS General_Journal
	*	LOCAL cServer AS STRING
	LOCAL oHm:=self:Server as TempTrans

	if IsObject(oHm) .and.!oHm==null_object

		oHm:Zap()
		oHm:aMirror:={}
		oHm:lFromRPP:=FALSE
		self:fTotal:=0 
		self:lStop:=true
		self:oDCDebitCreditText:Caption := Str(fTotal)
		self:lMemberGiver:=FALSE 
		self:lwaitingForExchrate:=false
		self:oDCGiroText:TextValue:= ""
		RETURN
	else
		self:EndWindow()
		self:Close()
	endif
	
METHOD ShowBankBalance() as void pascal CLASS General_Journal
	// show balance of first used bank account
	LOCAL i AS INT, cRek,CurBank:=SELF:CurBankAcc AS STRING
    LOCAL oHm:=self:Server as TempTrans 
    local oMBal as Balances
	LOCAL aMir:=oHm:aMirror AS ARRAY
	FOR i:=1 TO Len(aMir)
		cRek:=aMir[i,1]
		IF !Empty(cRek)
			IF cRek==CurBank
				EXIT
			ENDIF
			IF cRek==sHB .or. cRek==sKAS .or. AScanExact(BankAccs,cRek)>0
				oMBal:=Balances{}  
				oMBal:GetBalance(cRek,,,aMir[i,11])
				self:oDCBankBalance:TextValue:=AllTrim(Str(oMBal:Per_Deb - oMBal:per_Cre,,DecAantal))+" "+aMir[i,11]
				self:oDCBankText:TextValue:="Balance of "+aMir[i,9]+":" 
				IF Empty(CurBank)
					SELF:oDCBankText:show()
					self:oDCBankBalance:show()
				ENDIF
				CurBankAcc:=cRek
				EXIT
			ENDIF
		ENDIF					
	NEXT
	IF i>Len(aMir) .and.!Empty(CurBank)
		// no bank account found
		CurBankAcc:=""
		SELF:oDCBankBalance:Hide()
		self:oDCBankText:Hide() 
	ENDIF
RETURN
METHOD Totalise(lDelete:=false as logic,lDummy:=false as logic) as logic CLASS General_Journal
	* Totalise transaction-lines
	* lDelete = True: than called by delete line function
	LOCAL oHm as TempTrans
	LOCAL fTot:=0.00 as real8 
	LOCAL lDel AS LOGIC
	LOCAL nCurRec,i as int 
	
	oHm := SELF:server
	nCurRec := oHm:RECNO

	AEval(oHm:aMirror,{|x| fTot:=Round(fTot+x[2]-x[3],DecAantal)})

	self:fTotal:=fTot
	self:oDCDebitCreditText:Caption := Str(fTotal,-1,DecAantal)
 	self:oDCFoundtext:TextValue:=Str(oHm:RecCount,-1)
	
	// Append eventually a new record:
	IF !fTotal == 0 // totaal ongelijk nul?
		IF !ldelete.and.AScan(oHm:aMirror,{|x| x[2]==0.and.x[3]==0})=0   // Geen lege transact en geen delete?
		// Append new record:
			self:Append()
			self:Commit()
			self:oSFGeneralJournal1:GoTo(nCurRec)
			RETURN TRUE
		ENDIF
	ELSE
		IF oHm:Lastrec>1 .and. self:ValidateTempTrans(true,@i)
			SELF:oCCOKButton:SetFocus()
			IF (self:lTeleBank .and.!self:oTmt:m56_recognised) .or. (self:lImport .and. !self:oImpB:m56_recognised)
// 				IF !self:oTmt:m56_recognised
					self:oCCSaveButton:Show()
					self:oCCSaveButton:SetFocus()
// 				ENDIF
			ENDIF
		ENDIF
	ENDIF

RETURN TRUE
METHOD UpdateLine(oMutNew as TempTrans, oOrigMut as TempTrans,lGiver ref logic) as string CLASS General_Journal
	* Update values of a transaction line using values within oMutNew
	local cStatement as string
	local oStmnt as SQLStatement 
	lGiver:=(oMutNew:GC='PF'.or.oMutNew:GC = 'AG' .or. oMutNew:GC = 'MG';
		.or. oMutNew:KIND= 'G'.or. oMutNew:KIND= 'D';
		.or. oMutNew:KIND= 'A' .or. oMutNew:KIND = 'F' .or. oMutNew:KIND = 'C') 
	if Empty(oMutNew:SEQNR)
		self:nLstSEqNr++
	endif
	cStatement:=iif(Empty(oMutNew:SEQNR),"insert into","update")+" transaction set "+;
		"accid="+oMutNew:AccID+;
		",deb="+Str(oMutNew:Deb,-1)+;
		",cre="+Str(oMutNew:cre,-1)+;
		",debforgn="+Str(oMutNew:debforgn,-1)+;
		",creforgn="+Str(oMutNew:CREFORGN,-1)+;
		",currency='"+oMutNew:Currency+"'"+;
		",docid='"+AddSlashes(AllTrim(self:mBST))+"'"+;
		",dat='"+SQLdate(self:mDAT)+"'"+;
		",gc='"+AllTrim(oMutNew:GC)+"'"+;
		",fromrpp="+ iif(oMutNew:FROMRPP,'1','0')+;
		",userid='"+AddSlashes(LOGON_EMP_ID)+"'"+; 
	",ppdest='"+AllTrim(oMutNew:PPDEST)+"'"+;
		",persid='"+iif(lGiver,AllTrim(self:mCLNGiver),"0")+"'"+;
		iif(Empty(oMutNew:SEQNR),",transid="+AllTrim(Transform(self:mTRANSAKTNR,""))+; 
	",seqnr="+Str(self:nLstSEqNr,-1),'')+;
		",description='"+AddSlashes(AllTrim(oMutNew:DESCRIPTN))+"'"+;
		",reference='"+AddSlashes(AllTrim(oMutNew:REFERENCE))+"'"+; 
	",lock_id=0"+;
		iif(Posting,",poststatus="+ ConS(self:mPostStatus),"")+;
		iif(sproj=oMutNew:AccID .and.(oMutNew:cre-oMutNew:Deb)>0 .and..not.Empty(self:mCLNGiver),",bfm='O'",;
		iif(!Empty(oMutNew:SEQNR).and. sproj= oOrigMut:AccID,",bfm=''",""))+;  // change from earmarked gift to non-earmarked 
	iif(Empty(oMutNew:SEQNR),""," where transid="+AllTrim(Transform(self:mTRANSAKTNR,""))+" and seqnr="+Str(oMutNew:SEQNR,-1))

	oStmnt:=SQLStatement{cStatement,oConn}
	oStmnt:Execute()
	if !Empty(oStmnt:Status)
		return oStmnt:ErrInfo:errormessage
	else
		// update balance:
		if !Empty(oMutNew:SEQNR)
			// update balance with old content:
			IF !ChgBalance(oOrigMut:AccID,self:OrigDat,-oOrigMut:Deb,-oOrigMut:cre,-oOrigMut:debforgn,-oOrigMut:CREFORGN,oOrigMut:Currency)
				return "balance not changed"
			endif
		endif
		if !ChgBalance(oMutNew:AccID,self:mDAT,oMutNew:Deb,oMutNew:cre,oMutNew:debforgn,oMutNew:CREFORGN,oMutNew:Currency)
			return "balance not changed"
		endif
	endif
	return ""
METHOD UpdateTrans(dummy:=nil as logic) as string CLASS General_Journal
	* Update of an existing transaction with the modified data in TempTrans:
	LOCAL NewIndex, OrigIndex, OrigMut, AktiePost as STRING, NewMut as Filespec
	LOCAL oOrig, oNew as TempTrans
	LOCAL cSavFilter, cSavOrder as STRING, nSavRec as int, lSucc as LOGIC
	LOCAL pFilter as _CODEBLOCK
	LOCAL pnt as int 
	Local lNewPers,lGiver  as logic 
	local oTransH:=self:oOwner:oMyTrans as SQLSelect
	local oStmnt as SQLStatement
	local cError as string

	oNew:=self:server
	NewIndex:=oNew:FileSpec:Drive+oNew:FileSpec:Path+oNew:FileSpec:FileName
	lSucc:=oNew:CreateIndex(FileSpec{NewIndex},"StrZero(SEQNR,6)+ACCID",{||StrZero(oNew:SEQNR,6)+oNew:AccID})
	IF !lSucc 
		cError:='Not able to make indexfile for updates'
		(ErrorBox{self:Owner,cError}):show()
		RETURN cError
	ENDIF
	oNew:SetOrder(FileSpec{NewIndex})
	oNew:GoTop()
	GetHelpDir()
	OrigMut:=HelpDir+"\OR"+StrTran(Time(),":")
	oOrig:=TempTrans{OrigMut+'.dbf'}
	IF !oOrig:Used.or.!oNew:Used.or.!lSucc 
		cError:=  'Not able to make helpfile for updates'
		(ErrorBox{self:Owner,cError}):show()
		RETURN cError
	ENDIF

	// 	nSavRec:=self:oInqBrowse:Owner:server:Recno
	
	oOrig:lInqUpd:=true
	oTransH:GoTop()
	self:nLstSeqNr:=0
	self:cOrgAccs:='' 
	DO WHILE !oTransH:EOF
		oOrig:append()
		oOrig:AccID := Str(oTransH:AccID,-1)
		self:cOrgAccs+=iif(empty(self:cOrgAccs),',','')+alltrim(oOrig:ACCID)
		oOrig:AccDesc:=oTransH:AccDesc
		oOrig:DESCRIPTN := AllTrim(oTransH:Description)
		oOrig:ACCNUMBER := oTransH:ACCNUMBER
		oOrig:Deb := oTransH:Deb
		oOrig:cre :=  oTransH:cre
		if Empty( oTransH:Currency)
			oOrig:Currency:=sCurr
		else 
			oOrig:CURRENCY:= oTransH:CURRENCY
		endif
		if oOrig:Currency==sCurr
			oOrig:debforgn := oTransH:Deb
			oOrig:CREFORGN :=  oTransH:cre
		else
			oOrig:DEBFORGN := oTransH:DEBFORGN
			oOrig:CREFORGN :=  oTransH:CREFORGN
		endif
		oOrig:GC := oTransH:GC
		oOrig:BFM:= oTransH:BFM
		oOrig:FROMRPP:=iif(ConI(oTransH:FROMRPP)==1,true,false)
		oOrig:lFromRPP:=iif(ConI(oTransH:FROMRPP)==1,true,false)
		oOrig:OPP:=oTransH:OPP
		oOrig:PPDEST := oTransH:PPDEST
		oOrig:REFERENCE:=oTransH:REFERENCE
		oOrig:SEQNR := oTransH:SEQNR
		if oOrig:SEQNR> self:nLstSeqNr
			self:nLstSeqNr:=oOrig:SEQNR
		endif
		oOrig:KIND := oTransH:accounttype
		IF !Empty(oTransH:persid)
			OrigPerson := Str(oTransH:persid,-1)
		ENDIF
		oOrig:POSTSTATUS:=ConI(oTransH:POSTSTATUS)
		* After getting locks check again if all conditions are satisfied (could e.g be changed in the meanwhile by
		* allotting non-earmarked gift):
		IF (pnt:=AScan(oNew:aMIRROR,{|x|x[7]==oOrig:SEQNR}))==0 .or.; // deleted?
			!AllTrim(oNew:aMIRROR[pnt,1])==AllTrim(oOrig:AccID).or.; //account changed?
			!(oNew:aMIRROR[pnt,2]-oNew:aMIRROR[pnt,3])==(oOrig:DEB-oOrig:CRE) .or.; //amount changed?
			!AllTrim(oNew:aMIRROR[pnt,4])==AllTrim(oOrig:GC)  //ass.code changed? 
			cError:= oOrig:CheckUpdates()
			IF !Empty(cError)
				oOrig:Close()
				oOrig:=null_object
				FErase (OrigMut+".dbf")
				FErase (OrigMut+".fpt")
				// 				oTransH:Unlock()
				oNew:ClearIndex(NewIndex)
				NewIndex:= NewIndex+oNew:INdexExt
				FErase(NewIndex)
				RETURN cError
			ENDIF
		ENDIF
		oTransH:Skip()
	ENDDO

	lSucc:=oOrig:CreateIndex(FileSpec{OrigMut},"StrZero(SEQNR,6)+ACCID")
	oOrig:SetOrder(FileSpec{OrigMut})
	oOrig:GoTop()
	IF !lSucc 
		cError:= 'Not able to make indexfile for updates'
		(ErrorBox{self:Owner,cError}):show()
		RETURN cError
	ENDIF

	DO WHILE !oOrig:EOF 
		DO CASE
		CASE oOrig:SEQNR== oNew:SEQNR .and. !oNew:Deb==oNew:cre
			* Transaction line updates??:
			IF mCLNGiver#OrigPerson
				AktiePost:="W"
			ELSE
				AktiePost:=""
			ENDIF
			* When accid changed reverse old account record and add record for new account:
			IF oOrig:AccID # oNew:AccID
				AktiePost:="W"
			ENDIF
			* When amounts changed update balances:
			IF oOrig:DEB # oNew:DEB .or.oOrig:CRE # oNew:CRE
				IF Empty(AktiePost)
					AktiePost:="WB"     &&aleen bedrag gewijzigd
				ENDIF
			ENDIF
			* When date, accid or amounts have been updated change rerecord to new:
			IF self:mDAT # self:OrigDat.or.;
					oOrig:AccID # oNew:AccID .or.;
					oOrig:deb # oNew:deb .or.;
					oOrig:cre # oNew:cre
				* Update fields of the transaction line:
				cError:=self:UpdateLine(oNew,oOrig,@lGiver)
				if !Empty(cError)
					return cError
				endif
			ELSE
				* Update fields of the transaction line:
				IF	OrigBst # mBst .or.;
						oOrig:GC # oNew:GC.or.;
						oOrig:DESCRIPTN # oNew:DESCRIPTN.or.;
						oOrig:REFERENCE # oNew:REFERENCE.or.;
						oOrig:KIND # oNew:KIND.or.;
						oOrig:Currency # oNew:CURRENCY.or.;
						mCLNGiver # OrigPerson .or. ;
						oOrig:PPDEST # oNew:PPDEST .or.;
						(Posting .and.oOrig:POSTSTATUS # self:mPostStatus)
					cError:= self:UpdateLine(oNew,oOrig,@lGiver)
					if !Empty(cError)
						return cError
					endif
					if lGiver
						lNewPers := true
					endif
				ENDIF
			ENDIF
			IF.not.Empty(AktiePost)
				cError:= self:ChgDueAmnts(AktiePost,oOrig,oNew)
				if !Empty(cError)
					return cError
				endif
			ENDIF
			oNew:Skip()
			oOrig:Skip()
		CASE oOrig:SEQNR == oNew:SEQNR .and. oNew:Deb==oNew:cre
			* Remove dummy transaction line:
			* Delete line corresponding with origmut:
			oStmnt:=SQLStatement{"delete from transaction where transid="+AllTrim(self:oDCmTRANSAKTNR:TextValue)+" and seqnr="+Str(oOrig:SEQNR,-1),oConn}
			oStmnt:execute()
			if !Empty(oStmnt:Status)
				return oStmnt:ErrInfo:errormessage
			endif
			lDeleted:=true
			* Update balance:
			if !ChgBalance(oOrig:AccID,self:OrigDat,-oOrig:Deb,-oOrig:cre,-oOrig:debforgn,-oOrig:CREFORGN,oOrig:Currency)
				return "balance not changed"
			endif
			cError:= self:ChgDueAmnts("D",oOrig, oNew)
			if !Empty(cError)
				return cError
			endif
			oNew:skip()
			oOrig:skip()
			*    CASE Val(SubStr(Str(oOrig:RecNbr,9,0),3,7)) < Val(SubStr(Str(oNew:RecNbr,9,0),3,7)) .or. oNew:EOF.or.;
		CASE oNew:EOF.or.oOrig:SEQNR < oNew:SEQNR .or. ;
				(oOrig:SEQNR == oNew:SEQNR .and. oNew:Deb==oNew:cre)
			* Line removed:
			* Delete line corresponding with origmut:
			oStmnt:=SQLStatement{"delete from transaction where transid="+AllTrim(self:oDCmTRANSAKTNR:TextValue)+" and seqnr="+Str(oOrig:SEQNR,-1),oConn}
			oStmnt:execute()
			if !Empty(oStmnt:Status)
				return oStmnt:ErrInfo:errormessage
			endif
			* Update balance:
			if !ChgBalance(oOrig:AccID,self:OrigDat,-oOrig:Deb,-oOrig:cre,-oOrig:debforgn,-oOrig:CREFORGN,oOrig:Currency)
				return "balance not changed"
			endif
			cError:= self:ChgDueAmnts("D",oOrig, oNew)
			if !Empty(cError)
				return cError
			endif
			oOrig:skip()
		CASE oNew:SEQNR = 0
			* Transaction line added:
			IF !oNew:Deb==oNew:Cre // Ignore dummy transaction line
				* Append line from TempTrans
				cError:= self:UpdateLine(oNew,oOrig,@lGiver)
				if !Empty(cError)
					return cError
				endif
				// 				* Update balance:
				cError:= self:ChgDueAmnts("T", oOrig, oNew)
				if !Empty(cError)
					return cError
				endif
			ENDIF
			oNew:Skip()
		ENDCASE
	ENDDO
	// process new records:
	do while !oNew:EOF
		* Transaction line added:
		IF !oNew:Deb==oNew:cre // Ignore dummy transaction line
			* Append line from TempTrans
			cError:= self:UpdateLine(oNew,oOrig,@lGiver)
			if !Empty(cError)
				return cError
			endif
			cError:= self:ChgDueAmnts("T", oOrig, oNew)
			if !Empty(cError)
				return cError
			endif
		ENDIF
		
		oNew:Skip()
	enddo
	// 	if !mCLNGiver==OrigPerson .and. !lNewPers
	// 		(WarningBox{,"Saving Transaction","Person not updated because no applicable transaction line"}):show()
	// 	endif

	oNew:ClearIndex(NewIndex)
	Newmut:=FileSpec{NewIndex}
	NewMut:Extension:=oNew:INdexExt
	oNew:Close()
	oNew:=null_object
	NewMut:Delete()
	NewMut:Extension:="dbf"
	NewMut:Delete()
	NewMut:Extension:="fpt"
	NewMut:Delete()

	OrigIndex:=oOrig:FileSpec:Path+oOrig:FileSpec:FileName
	oOrig:ClearIndex(OrigIndex)
	OrigIndex:=OrigIndex+oOrig:INdexExt
	oOrig:close()
	//oNew:close()
	oOrig:=null_object
	FErase(OrigIndex)
	FErase (Origmut+".dbf")
	FErase (Origmut+".fpt")
	// 	if self:oOwner:lShowFind
	// 		self:oOwner:FindButton()
	// 	else
	// 		self:oOwner:ShowSelection()
	// 	endif
	// 	oInqBrowse:Owner:GoTo(nSavRec)
	RETURN ""
METHOD ValidateTempTrans(lNoMessage:=false as logic,ErrorLine:=0 ref int) as logic CLASS General_Journal
	* lNoMessage: True: Do not show error message
	LOCAL lValid := TRUE AS LOGIC
	LOCAL cError AS STRING
	LOCAL oHm as TempTrans
	LOCAL mRek AS STRING
	LOCAL i:=0, nCurRec as int
	oHm := SELF:Server
	// 	Default(@lNoMessage,FALSE)
	oHm:SuspendNotification() 
	nCurRec:=oHm:Recno
	DO WHILE lValid .and. i < Len(oHm:aMirror)
		++i
		IF oHm:aMirror[i,2] == oHm:aMirror[i,3] //deb=cre: skip empty line
			LOOP
		ENDIF
		IF Empty(oHm:aMirror[i,1]) //accid,deb,cre
			lValid := FALSE
			cError := self:oLan:WGet("Account obliged")+"!"
		ELSEIF Empty(oHm:AMirror[i,16]) //description
			lValid := FALSE
			cError := self:oLan:WGet("Description obliged")+"!"
		ELSEIF (ADMIN=="WO".or. ADMIN="HO") .and.!oHm:lFromRPP
			IF oHm:aMirror[i,5] = "M"
				IF Empty(AScan({'AG','CH','OT','PF','MG'},oHm:aMirror[i,4])) //GC
					lValid := FALSE
					cError := self:oLan:WGet("Assessment codes are")+": AG CH PF MG"
				ELSEIF oHm:aMirror[i,4] = 'MG' //GC
					mRek := AllTrim(oHm:aMirror[i,1]) //accid
					IF !SELF:lMemberGiver .and. AScan(oHm:AMirror,{|x| x[4]=="CH".and.!x[1]==mRek}) = 0
						lValid := FALSE
						cError := self:oLan:WGet('Donor no member, thus MG not allowed')
					ENDIF
				elseif oHm:aMirror[i,19]='I' 
					oHm:goto(i)
					if Empty( oHm:BFM )
						if !self:lMemberGiver .and.   oHm:aMirror[i,4] = 'CH'
							cError:=self:oLan:WGet('CH not allowed for income account')
							lValid := FALSE
						elseif oHm:aMirror[i,4] = 'PF' 
							cError:=self:oLan:WGet('PF not allowed for income account')
							lValid := FALSE
						endif
					endif
				ENDIF
			ELSE
				if oHm:aMirror[i,5] = "K"   // member department account, not income
					oHm:goto(i)
					if Empty( oHm:BFM )
						if oHm:aMirror[i,19]='E' .and. !oHm:aMirror[i,4] == 'CH'
							lValid := FALSE
							cError := self:oLan:WGet("Only assessment code CH allowed for expense account")
							exit
						elseif oHm:aMirror[i,19]='F' .and. !oHm:aMirror[i,4] == 'PF'
							lValid := FALSE
							cError := self:oLan:WGet("Only assessment code PF allowed for fund account")
						endif
					endif
				elseIF !Empty(oHm:aMirror[i,4]).and.!oHm:aMirror[i,4]=="OT" //GC
					lValid := FALSE
					cError := self:oLan:WGet("Assessment code exclusively for member")
				endif
			ENDIF 
		elseif oHm:aMirror[i,1]==sToPP .and.!Empty(sToPP)
			oHm:GoTo(i)
			if Empty(oHm:AMirror[i,15])
				if Empty(oHm:REFERENCE)
					lValid:=false
					cError := self:oLan:WGet('Fill reference in case of "Sending to other entity"')
				endif
			else
				if Empty(oHm:DESCRIPTN) .and. Empty(oHm:REFERENCE)
					lValid:=false
					cError := self:oLan:WGet('Fill reference and/or description in case of "Sending to other entity"')
				endif
			endif
		ENDIF
	ENDDO 
	oHm:ResetNotification()
	IF !lValid.and.!lNomessage
		(ErrorBox{,cError}):Show()
		oHm:recno:=oHm:aMirror[i,6]
		ErrorLine:=i
	ENDIF
	oHm:GoTo(nCurRec)
	RETURN lValid
METHOD ValStore(lSave:=false as logic ) as logic CLASS General_Journal
	LOCAL nErrRec as int
	LOCAL cTransnr, m54_pers_sta:="N", mbrRek as STRING
	LOCAL oBox as WarningBox
	LOCAL oHm as TempTrans
	LOCAL lError,lOK as LOGIC
	LOCAL curRec as int
	LOCAL i,j,nSeqnbr as int
	LOCAL CurValue as ARRAY   // 1: nw value, 2: old value, 3: name of columnfield
	LOCAL ThisRec,nMir as int
	LOCAL cError as STRING, ErrorLine:=1,nSavRec as int
	LOCAL mCLNGiverMbr, OmsMbr, cCod, cCodNew as STRING 
	local cStatement as string
	local oStmnt as SQLStatement 
	local oPers,oMyTele,oMyImp,oAccFld,oMBal,oDue as SQLSelect
	local cAccs as string   // accounts used in transaction 
	local cDueAccs as string	// accounts for locking dueamounts 
	local aMyBank:=self:abankacc as array
	local aMyPayaHead:=self:aPayaHead as array
	oHm := self:server
	self:mDAT:= self:oDCmDat:SelectedDate
	IF !self:fTotal==0
		(ErrorBox{self,self:oLan:WGet("Sum of transactions not equal zero")}):show()
		lError := true
	ELSEIF Len(oHm:aMIRROR)< 2.and.!lInqUpd
		(ErrorBox{self,self:oLan:WGet("Transactions not complete")}):show()
		lError := true
	ELSEIF 	!self:ValidateTempTrans(FALSE,@ErrorLine)
		lError := true
		*		RETURN NIL
	elseif Empty(self:mDAT)
		(ErrorBox{self,self:oLan:WGet("Select a date")}):show()
		lError := true
	elseif self:lwaitingForExchrate
		(ErrorBox{self,self:oLan:WGet("wait for exchange rate")}):show()
		lError := true
	ELSE
		*		Check only one membergiver:
		IF ADMIN=="WO" .and. !oHm:lFromRPP .and. (AScan(oHm:aMIRROR,{|x| x[4]=="AG".or.x[4]=="MG"})>0)
			i:= AScan(oHm:aMIRROR,{|x| x[4]=="CH".and.x[3]<x[2]})
			IF i > 0
				curRec:=oHm:aMIRROR[i,6]  // RECNO
				* Check if giver is a member:
				mbrRek:=oHm:aMIRROR[i,1]
				mCLNGiverMbr := oHm:aMIRROR[i,17]
				//	check	if	direct gift	report: 
				lOK:=false
				if	AScan(oHm:aMIRROR,{|x| x[4]="AG" .and. (x[1]==mbrRek .or.x[17]==mCLNGiverMbr)	})>0
// 					IF	Empty(self:mCLNGiver).or.	mCLNGiverMbr==self:mCLNGiver
					IF	Empty(self:mCLNGiver).and.	Empty(mCLNGiverMbr)
						(ErrorBox{self,self:oLan:WGet("You should	specify a giver")+"!"}):show()
						RETURN FALSE
					else
						lOK:=true
					endif
					
				endif						 
				IF !lOK .and.!self:lDirectIncome
					if !Empty(self:mCLNGiver).and. !Empty(mCLNGiverMbr).and.!mCLNGiverMbr==self:mCLNGiver
						cError := self:cGiverName+";  "
						lError := true
					ELSE
						self:mCLNGiver:=mCLNGiverMbr 
						lError:=false
					ENDIF
					DO WHILE i>0
						oHm:RecNo:=oHm:AMirror[i,6] // RECNO
						IF Empty(OmsMbr)
							OmsMbr:=AllTrim(oHm:AccDesc)
							cError += OmsMbr+"; "
						ELSE
							IF !OmsMbr==AllTrim(oHm:AccDesc)
								cError += AllTrim(oHm:AccDesc)+"; "
								lError := true
							ENDIF
						ENDIF
						i:= AScan(oHm:aMIRROR,{|x| x[4]=="CH".and.x[3]<x[2].and.!x[6]==curRec},i+1)
					ENDDO
				endif
				IF lError
					(ErrorBox{self,self:oLan:WGet("Givers")+" "+self:oLan:WGet("are")+" "+cError+"  "+self:oLan:WGet("Only one giver allowed")+"!"}):show()
					RETURN FALSE
				ENDIF
			ENDIF
		ENDIF

		IF !oHm:lFromRPP
			m54_pers_sta:='N'  && Not allowed
			m54_pers_sta:= checkpayer( oHm:aMIRROR )
			IF Empty(self:mCLNGiver)
				IF self:lImport .and.!Empty(AllTrim(self:cGiverName)).and.(m54_pers_sta='V' .or.m54_pers_sta=='W')
					// busy with searching person
					RETURN FALSE
				ENDIF
				IF m54_pers_sta='V'
					(ErrorBox{self,self:oLan:WGet('Giver must be a person')}):show()
					lError := true
					RETURN FALSE
				elseIF m54_pers_sta='C'
					(ErrorBox{self,self:oLan:WGet('Creditor must be a person')}):show()
					lError := true
					RETURN FALSE
				ELSEIF m54_pers_sta=='W'
					oBox := WarningBox{self, self:oLan:WGet("Input of Transactions"), ;
						self:oLan:WGet("Don't you need to specify a giver/payer")+"?"}
					oBox:Type := BUTTONYESNO
					IF (oBox:show() = BOXREPLYYES)
						self:oDCmperson:SetFocus()
						RETURN FALSE
					ENDIF
				ENDIF
			ELSE
				IF m54_pers_sta='N'
					(ErrorBox{self,self:oLan:WGet('No person allowed in this case')}):show()
					self:oDCmperson:SetFocus()
					RETURN FALSE
				ELSEIF m54_pers_sta=='O' 
					if Empty(self:mBst) .or.!SubStr(self:mBst,1,3)=='COL' // skip storno's
						if !Empty(self:oDCmPerson:TEXTValue)
							oBox := WarningBox{self, self:oLan:WGet("Input of Transactions"),self:oLan:WGet('Payer really a person')+'?'}
							oBox:Type := BUTTONYESNO
							IF (oBox:show() = BOXREPLYNO)
								self:oDCmperson:SetFocus()
								RETURN FALSE
							ENDIF 
						endif
					endif
				ENDIF
			ENDIF
		ENDIF
		//	determine accounts to be locked for change balance
		cAccs:=Implode(oHm:aMIRROR,",",,,1)+iif(lInqUpd,','+ self:cOrgAccs,'')
		if !lInqUpd 
			//	add income records:
			if	(!Empty(SINCHOME) .or.!Empty(SINC)) .and.(!Empty(self:mCLNGiver).or. oHm:lFromRPP)
				if	AScan(oHm:aMIRROR,{|x|x[4]='AG' .and.x[18]=liability})>0
					IF	!Empty(SINC)
						cAccs+=','+SEXP+','+ SINC
					endif	 			
					IF	!Empty(SINCHOME)
						cAccs+=','+SINCHOME+','+SEXPHOME
					endif	
				endif
			endif
			// add rabat accounts:
			if oHm:lFromRPP  .and.!Empty( samFld ) .and.!Empty( SEXP )
				for nMir:=1 to Len(oHm:aMIRROR)
					IF	(j:=AScan(oHm:aMIRROR,{|x|Empty(x[4]) .and.!Empty(x[15])	},nMir))>0	  // empty(gc)	and !empty(reference)
						oHm:Recno=j	
						IF	oHm:OPP== sEntity
							if	At(cAccs,','+SEXP+',')=0
								cAccs+=','+SEXP
							endif
							cAccs+=','+	samFld
							exit
						endif
						nMir:=j
					endif
				next
			endif
		endif
		// determine accounts for locks for dueamounts:
		IF	!Empty(self:mCLNGiver) .and. !lInqUpd
			for nMir:=1 to Len(oHm:aMIRROR) 
				// search for: KIND= 'D'	.or. KIND=	'A' .or.	KIND	= 'F'	.or.(Deb >	Cre .and.gc<>'CH' )     // storno also
				IF	(j:=AScan(oHm:aMIRROR,{|x|x[5]=='D'.or.x[5]=='A'.or.x[5]=='F'.or.(x[2]>x[3].and.x[4]<>'CH')},nMir))>0	  
					cDueAccs+=iif(Empty(cDueAccs),'',',')+oHm:aMIRROR[nMir,1]	
					nMir:=j
				endif
			next
		endif 
		self:Pointer := Pointer{POINTERHOURGLASS}

		oStmnt:=SQLStatement{"set autocommit=0",oConn}
		oStmnt:execute()
		oStmnt:=SQLStatement{'lock tables `transaction` write,`mbalance` write'+iif(self:lTeleBank,',`teletrans` write','')+iif(self:lImport,',`importtrans` write','')+iif(!Empty(self:mCLNGiver),',`person` write','')+iif(!Empty(cDueAccs).or.lInqUpd,',`dueamount` write,`subscription` read',''),oConn} 
		oStmnt:execute()
		//	lock mbalance records:
		// 		oMBal:=SqlSelect{"select mbalid from mbalance where accid in ("+cAccs+")"+;
		// 			" and	year="+Str(Year(self:mDAT),-1)+;
		// 			" and	month="+Str(Month(self:mDAT),-1)+' order by mbalid for update',oConn}
		// 		if	!Empty(oMBal:Status)
		// 			self:Pointer := Pointer{POINTERARROW}
		// 			ErrorBox{self,self:oLan:WGet("balance records locked by someone else, thus	skipped")}:show()
		// 			SQLStatement{"rollback",oConn}:Execute()
		// 			self:mCLNGiver:=''
		// 			return true
		// 		endif	  

		IF lInqUpd
			* Update transaction
			nSavRec:=oInqBrowse:Owner:server:Recno
			oHm:SuspendNotification()	
			cError:=self:UpdateTrans()
			if !Empty(cError)
				lError:=true
				cError:=''
			else
				lError:=false
			endif
		ELSE
			* add new transaction:
			self:Owner:STATUSMESSAGE( self:oLan:WGet("Recording transaction")+" "+cTransnr)
			oHm:SuspendNotification()
			if self:lTeleBank
				// lock teletrans record:
				oMyTele:=SqlSelect{"select lock_id from teletrans where teletrid="+Str(self:oTmt:CurTelId,-1)+;
					" and processed='' and lock_id="+MYEMPID,oConn}
				oMyTele:Execute()
				if oMyTele:Reccount<1
					SQLStatement{"rollback",oConn}:execute()
					SQLStatement{"unlock tables",oConn}:execute()
					self:mCLNGiver:=''
					self:Pointer := Pointer{POINTERARROW}
					ErrorBox{self,self:oLan:WGet("This telebank transaction has already been processed by someone else, thus skipped")}:show()
					return true
				endif
			elseif self:lImport
				// lock importrans records
				if !self:oImpB:LockBatch()
					SQLStatement{"rollback",oConn}:execute()
					SQLStatement{"unlock tables",oConn}:execute()
					self:mCLNGiver:=''
					return true
				endif				
			endif
			/*			// set locks for dueamounts:
			IF	!Empty(cDueAccs)
			oDue:=SqlSelect{"select d.dueid from dueamount d, subscription s where s.subscribid=d.subscribid and s.personid="+self:mCLNGiver+" and s.accid in ("+cDueAccs+' and amountrecvd<amountinvoice order by invoicedate,seqnr for update',oConn}
			oDue;Execute()
			endif   */
			// add to gifts income: 
			//             1    2   3  4    5       6         7         8          9       10     11      12      13       14      15        16        17    18      19
			// mirror: {accID,deb,cre,gc,category,recno,Trans:RecNbr,accnumber,AccDesc,balitemid,curr,multicur,debforgn,creforgn,PPDEST, description,persid,type, incexpfd}
			For i:=1 to Len(oHm:aMIRROR)
				oHm:GoTo(i)
				if !oHm:aMirror[i,2]==oHm:aMirror[i,3]  // skip dummy lines
					// 				if	!oHm:CRE==oHm:Deb // skip dummy lines
					nSeqNbr++ 
					cStatement:="insert into transaction set "+;
						iif(Empty(cTransnr),'',"transid="+cTransnr+",")+;
						iif(oHm:aMIRROR[i,4]='PF'.or.oHm:aMIRROR[i,4] = 'AG' .or.oHm:aMIRROR[i,4] = 'MG';
						.or. (oHm:aMIRROR[i,5]= 'G').or. oHm:aMirror[i,5]= 'D';
						.or. oHm:aMIRROR[i,5]= 'A' .or. oHm:aMIRROR[i,5] = 'F'.or. oHm:aMIRROR[i,5]="C","persid='"+Str(Val(self:mCLNGiver),-1)+"',","")+;
						"dat='"+SQLdate(self:mDAT)+"'"+;
						",docid='"+Transform(self:mBst,"")+"'"+;
						",description='"+AddSlashes(AllTrim(oHm:aMIRROR[i,16]))+"'"+; 
					",reference='"+AddSlashes(AllTrim(oHm:REFERENCE))+"'"+;
						",accid='"+AllTrim(oHm:aMIRROR[i,1])+"'"+;
						",deb="+Str(oHm:aMIRROR[i,2],-1)+;
						",cre="+Str(oHm:aMIRROR[i,3],-1)+;
						",gc='"+oHm:aMIRROR[i,4]+"'"+;
						",userid='"+LOGON_EMP_ID +"'"+;
						",fromrpp="+iif(oHm:FROMRPP,"1","0")+;
						",opp='"+oHm:OPP+"'"+;
						",ppdest='"+SubStr(AllTrim(oHm:aMIRROR[i,15]),15)+"'"+; 
					",currency='"+AllTrim(oHm:aMIRROR[i,11]) +"'"+;
						",debforgn="+Str(oHm:aMIRROR[i,13],-1)+;
						",creforgn="+Str(oHm:aMIRROR[i,14],-1)+;
						",seqnr="+Str(nSeqnbr,-1)+;
						iif(IsNil(self:mPostStatus),iif(lImport,",poststatus=2",""),; 
					",poststatus="+iif(IsString(self:mPostStatus),self:mPostStatus,Str(self:mPostStatus,-1))) +;
						iif(SPROJ == oHm:AccID.and..not.Empty(self:mCLNGiver).and.oHm:cre>oHm:Deb,",bfm='O'","")
					oStmnt:=SQLStatement{cStatement,oConn}
					oStmnt:Execute()
					if Empty(oStmnt:Status) .and. oStmnt:NumSuccessfulRows>0
						if Empty(cTransnr)
							cTransnr:=ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
						endif
						*	Update monthbalance value of corresponding account:
						if ChgBalance(oHm:aMIRROR[i,1],self:mDAT,oHm:aMIRROR[i,2],oHm:aMIRROR[i,3],oHm:aMIRROR[i,13],oHm:aMIRROR[i,14],oHm:aMIRROR[i,11]) //accid,deb,cre
							if oHm:aMIRROR[i,4]='AG'
								// if from bank account, payahead or pretty cash or accounts receivable:
								j:=AScan(oHm:aMIRROR,{|x|x[2]>x[3] .and.Empty(x[4]).and. (AScanExact(aMyBank,x[1])>0 .or. AScanExact(aMyPayaHead,x[1])>0 .or.x[1]==SPROJ.or.x[1]=SKAS)})
								do while j>0 .and.j=i
									if j=Len(oHm:aMIRROR)
										j:=0
										exit
									endif
									j:=AScan(oHm:aMIRROR,{|x|x[2]>x[3] .and.Empty(x[4]).and. (AScanExact(aMyBank,x[1])>0 .or. AScanExact(aMyPayaHead,x[1])>0 .or.x[1]==SPROJ.or.x[1]=SKAS)},j+1)
								enddo 
								if oHm:FROMRPP .or. j>0 
									// assessable gift not from income or expense account:
									// 									lError:=!AddToIncome(oHm:aMirror[i,4],oHm:FROMRPP,oHm:aMirror[i,1],oHm:aMirror[i,3],oHm:aMirror[i,2],oHm:aMirror[i,13],oHm:aMirror[i,14],oHm:aMirror[i,11],oHm:aMirror[i,16],oHm:aMirror[i,18], self:mCLNGiver,;
									// 										self:mDAT,Transform(self:mBST,""),cTransnr,@nSeqnbr,iif(IsString(self:mPostStatus),Val(self:mPostStatus),self:mPostStatus))
									lError:=!oAddInEx:AddToIncomeExp(oHm:aMIRROR[i,4],oHm:FROMRPP,oHm:aMIRROR[i,1],oHm:aMIRROR[i,3],oHm:aMIRROR[i,2],oHm:aMIRROR[i,13],oHm:aMIRROR[i,14],oHm:aMIRROR[i,11],oHm:aMIRROR[i,16],oHm:aMIRROR[i,18], self:mCLNGiver,;
										self:mDAT,Transform(self:mBst,""),cTransnr,@nSeqnbr,iif(IsString(self:mPostStatus),Val(self:mPostStatus),self:mPostStatus))
								endif
							endif
							if !lError
								if oHm:FROMRPP  .and.!Empty( samFld ) .and.!Empty( SEXP )
									// correct rabat assessment if needed: 
									if Empty(oHm:aMIRROR[i,4]) .and. oHm:OPP== sEntity .and. !Empty(oHm:REFERENCE) 
										oAccFld:=SqlSelect{"select b.category from account a, balanceitem b where a.balitemid=b.balitemid and a.accnumber='"+;
											AllTrim(oHm:REFERENCE)+"'",oConn}
										if oAccFld:category==liability
											if ChgBalance(SEXP, self:mDAT,Round(oHm:aMIRROR[i,3] - oHm:aMIRROR[i,2],DecAantal),0,Round(oHm:aMIRROR[i,3] - oHm:aMIRROR[i,2],DecAantal),0,sCURR)
												nSeqnbr++ 
												cStatement:="insert into transaction set "+;
													"transid="+cTransnr+;
													",dat='"+SQLdate(self:mDAT)+"'"+;
													",docid='"+self:mBst+"'"+;
													",description='"+AddSlashes(AllTrim(self:oLan:RGet('Reversal Expense for assessment field&int')))+"'"+; 
												",reference='"+AddSlashes(AllTrim(oHm:REFERENCE))+"'"+;
													",accid='"+SEXP+"'"+;
													",deb="+Str(oHm:aMirror[i,3]	- oHm:aMirror[i,2],-1)+;
													",userid='"+LOGON_EMP_ID +"'"+;
													",debforgn="+Str(oHm:aMirror[i,3]	- oHm:aMirror[i,2],-1)+;
													",currency='"+sCurr+"'"+;
													",seqnr="+Str(nSeqnbr,-1)+;
													",poststatus=2" 
												oStmnt:=SQLStatement{cStatement,oConn}
												oStmnt:Execute()
												if oStmnt:NumSuccessfulRows>0
													if ChgBalance(samFld,self:mDAT,0,Round(oHm:aMirror[i,3]	- oHm:aMirror[i,2],DecAantal), 0	,Round(oHm:aMirror[i,3]	- oHm:aMirror[i,2],DecAantal),sCURR)
														nSeqnbr++ 
														cStatement:="insert into transaction set "+;
															"transid="+cTransnr+;
															",dat='"+SQLdate(self:mDAT)+"'"+;
															",docid='"+self:mBst+"'"+;
															",description='"+AddSlashes(AllTrim(self:oLan:RGet('Reversal Expense	for assessment	field&int')))+"'"+; 
														",reference='"+AddSlashes(AllTrim(oHm:REFERENCE))+"'"+;
															",accid='"+samFld+"'"+;
															",cre="+Str(oHm:aMIRROR[i,3]	- oHm:aMIRROR[i,2],-1)+;
															",userid='"+LOGON_EMP_ID +"'"+;
															",creforgn="+Str(oHm:aMirror[i,3]	- oHm:aMirror[i,2],-1)+;
															",currency='"+sCurr+"'"+;
															",seqnr="+Str(nSeqnbr,-1)+;
															",poststatus=2" 
														oStmnt:=SQLStatement{cStatement,oConn}
														oStmnt:Execute()
														if	!oStmnt:NumSuccessfulRows>0
															lError:=true
														endif
													else
														lError:=true
													endif
												else
													lError:=true
													cError:=oStmnt:ErrInfo:errormessage
												endif
											else
												lError:=true
											endif
										endif
									endif
								endif
							endif
						ELSE
							lError:=true
						endif
					ELSE
						cError:=oStmnt:ErrInfo:errormessage
						lError:=true
					endif
				endif
				if !lError
					//	Update balances of subscriptions/due amounts/ donations:
					// 					IF	!Empty(self:mCLNGiver)
					IF	!Empty(cDueAccs)
						IF	(oHm:aMIRROR[i,5]= 'D'	.or. oHm:aMIRROR[i,5]=	'A' .or.	oHm:aMIRROR[i,5]	= 'F'	.or.(oHm:aMIRROR[i,2] >	oHm:aMIRROR[i,3] .and.oHm:aMIRROR[i,4]<>'CH' ))			 // storno also
							cError:= ChgDueAmnt(self:mCLNGiver,AllTrim(oHm:aMirror[i,1]),oHm:aMirror[i,2],oHm:aMirror[i,3])
							if !Empty(cError)
								lError:=true
								// 								exit
							endif
						ENDIF
					endif
				endif
				if lError
					SQLStatement{"rollback",oConn}:execute()
					SQLStatement{"unlock tables",oConn}:execute()
					self:Pointer := Pointer{POINTERARROW}
					LogEvent(self,"Error:"+cError+"; stmnt:"+cStatement,"LogErrors")
					ErrorBox{self,"transaction could not be stored:"+cError}:show()
					self:mCLNGiver:=''
					return false
				endif
			next
			// 			self:Pointer := Pointer{POINTERARROW}
			// 			IF self:lTeleBank
			// 				self:oTmt:CloseMut(oHm,lSave,self:Owner)   // includes commit
			// 			elseif self:lImport
			// 				self:oImpB:CloseBatch(lSave,self:Owner)  // includes commit
			// 			ENDIF
			// 			self:oDCGiroText:TextValue:="   "
			// 			lSave:=FALSE
			oHm:ResetNotification()	
		ENDIF
		if !lError
			// 			oStmnt:=SQLStatement{"commit",oConn}
			// 			oStmnt:Execute() 
			// 			if Empty(oStmnt:Status) 
			IF !Empty(self:mCLNGiver)
				*  update data of giver:
				i:= AScan(oHm:aMirror,{|x| (x[3]-x[2])>0.and.(x[5]=="G" .or.x[5]=="M" .or.x[5]=="D")})
				IF i>0 
					oPers:=SqlSelect{"select mailingcodes,cast(datelastgift as date) as datelastgift from person where persid="+self:mCLNGiver,oConn}
					if oPers:Reccount>0
						cCodNew:=oPers:mailingcodes
						DO WHILE i>0
							PersonGiftdata(oHm:AMirror[i,5],@cCodNew,iif(empty(oPers:datelastgift),null_date,oPers:datelastgift),oHm:AMirror[i,4],null_string,false)
							i:= AScan(oHm:aMirror,{|x| (x[3]-x[2])>0.and.(x[5]=="G" .or.x[5]=="M" .or.x[5]=="D")},i+1)
						ENDDO
						if !AllTrim(cCodNew)==oPers:mailingcodes .or. oPers:datelastgift<self:mDAT
							&& fill date last gift:
							oStmnt:=SQLStatement{"update person set datelastgift='"+SQLdate(self:mDAT)+"',mailingcodes='"+cCodNew+"' where persid="+self:mCLNGiver,oConn}
							oStmnt:execute() 
							if !Empty(oStmnt:Status)
								lError:=true 
								cError:=oStmnt:ErrInfo:errorstatus
							endif
						endif
					endif
				ENDIF
			ENDIF 
			if !lError.and. self:lImport
				oStmnt:=SQLStatement{"update importtrans set processed=1,lock_id=0 where transactnr='"+self:oImpB:CurBatchNbr+;
					"' and origin='"+self:oImpB:CurOrigin+"' and transdate='"+SQLdate(self:oImpB:CurDate)+"'",oConn}
				oStmnt:execute()
				if !Empty(oStmnt:Status)
					lError:=true 
					cError:=oStmnt:ErrInfo:errorstatus
				endif 
			endif
			if !lError
				self:oDCmTRANSAKTNR:TEXTValue := cTransnr
			endif
		endif
		// 		ENDIF
	ENDIF
	IF lError
		SQLStatement{"rollback",oConn}:execute()
		SQLStatement{"unlock tables",oConn}:execute()
		SQLStatement{"set autocommit=1",oConn}:execute()
		self:Pointer := Pointer{POINTERARROW}
		if !Empty(cError)
			LogEvent(self,"Error:"+cError+"; stmnt:"+cStatement,"LogErrors")
		endif
		ErrorBox{self,"transaction could not be stored:"+cError}:show()
		self:mCLNGiver:=''
		return false
		self:oSFGeneralJournal1:Browser:SetFocus()
		oHm:GoTop()
		self:oSFGeneralJournal1:Browser:Refresh()
		oHm:GoTo(ErrorLine,6)
		RETURN FALSE
	endif 
	SQLStatement{"commit",oConn}:execute()
	SQLStatement{"unlock tables",oConn}:execute() 
	SQLStatement{"set autocommit=1",oConn}:execute()
	self:Pointer := Pointer{POINTERARROW}
	IF self:lTeleBank 
		self:oTmt:CloseMut(oHm,lSave,self:Owner)   // includes commit
	elseif self:lImport
		self:oImpB:CloseBatch(lSave,self:Owner)  
	ENDIF
	self:oDCGiroText:TEXTValue:="   "
	lSave:=FALSE

	IF lInqUpd
		if self:oOwner:lShowFind
			self:oOwner:FindButton()
		else
			self:oOwner:ShowSelection()
		endif
		self:oInqBrowse:Owner:GoTo(nSavRec)
		self:lStop:=true
		self:EndWindow()
	ENDIF
	self:mCLNGiver:=''
	
	
	RETURN true		
	

CLASS GeneralBrowser INHERIT DatabrowserExtra
METHOD GetCurCell CLASS GeneralBrowser
	LOCAL oSingle AS JapSingleEdit
	LOCAL NwValue AS USUAL
	oSingle:=SELF:oCellEdit
	IF oSingle==NULL_OBJECT
		RETURN {}
	ELSE
		IF IsNumeric(oSingle:Value)
			NwValue:=Val(oSingle:CurrentText)
		ELSE
			NwValue:=AllTrim(oSingle:CurrentText)
		ENDIF
		RETURN {NwValue,oSingle:Value,Upper(oSingle:Fieldspec:HyperLabel:Name)}
	ENDIF
METHOD SetColumnFocus(ColumnSym)  CLASS GeneralBrowser
	// set browser to requird column
	LOCAL oColumn as DataColumn
	IF IsSymbol(ColumnSym)
		oColumn := SELF:GetColumn(ColumnSym)
		RETURN SUPER:SetColumnFocus(oColumn)
	ELSEIF !ColumnSym==null_object	
		RETURN SUPER:SetColumnFocus(ColumnSym)
	ENDIF	
METHOD BlockColumns() CLASS GeneralJournal1
	SELF:oDBACCNUMBER:SetStandardStyle(GBSREADONLY)
	SELF:oDBDEB:SetStandardStyle(GBSREADONLY)
	SELF:oDBCRE:SetStandardStyle(GBSREADONLY)
	self:oDBGC:SetStandardStyle(gbsReadOnly)
	self:oDBACCDESC:SetStandardStyle(gbsReadOnly)
	RETURN NIL
METHOD DebCreProc(lNil:=false as logic) as logic CLASS GeneralJournal1
	LOCAL recnr AS INT
	LOCAL oHm:= self:Server as TempTrans
	LOCAL lFound AS LOGIC
	LOCAL i AS INT
	LOCAL ThisRec:=oHm:RECNO as int
	LOCAL nDepId as int, cAccId,cPersId as string
	Local ROE:=1 as float
	local oTransH as SQLSelect
	if oHm:CURRENCY # sCurr
		if Round(oHm:CREFORGN- oHm:DEBFORGN,DecAantal)<>0
			self:Owner:lwaitingForExchrate:=true 
			ROE:=oCurr:GetROE(oHm:CURRENCY,self:Owner:mDat)
			self:Owner:lwaitingForExchrate:=false 
			if oCurr:lStopped
				self:Owner:EndWindow()
				return false
			endif
			oHm:deb:=Round(oHm:DEBFORGN*ROE,DecAantal)
			oHm:cre:=Round(oHm:CREFORGN*ROE,DecAantal)
		endif
	ELSE		
		oHm:deb:=oHm:DEBFORGN
		oHm:cre:=oHm:CREFORGN
	endif
	IF oHm:lFilling
		self:owner:Totalise(false,false)
		RETURN true
	ENDIF
	if !Empty(self:oOwner:oOwner)
		oTransH:=self:oOwner:oOwner:oMyTrans
	endif
	if !Empty(oHm:CheckUpdates(oTransH))
		* recover old values
		oHm:deb:=oHm:aMirror[ThisRec,2]
		oHm:cre:=oHm:aMirror[ThisRec,3]
		oHm:DEBFORGN:=oHm:aMirror[ThisRec,13]
		oHm:CREFORGN:=oHm:aMirror[ThisRec,14]
		self:Owner:Totalise(false,false)
		RETURN false
	ENDIF
	*	save new values into aMirror: 
	if !oHm:lFilling
		self:Owner:lStop:=false  // give warning when cancel
	endif

	oHm:aMirror[ThisRec,2]:=oHm:deb
	oHm:aMirror[ThisRec,3]:=oHm:cre
	oHm:aMirror[ThisRec,13]:=oHm:DEBFORGN
	oHm:aMirror[ThisRec,14]:=oHm:CREFORGN
	oHm:aMirror[ThisRec,19]:=oHm:INCEXPFD 
	oHm:aMirror[ThisRec,20]:=oHm:DEPID
	IF oHm:KIND == 'M'		
		IF oHm:deb > oHm:cre
			if self:oParent:mBST="COL"     // inverse direct debit
				oHm:gc := 'AG'
			else
				oHm:gc := 'CH'
			endif				
		ELSEIF oHm:deb = oHm:cre
			oHm:gc := '  '
		ELSE
			IF (!oHm:gc == 'PF'.or.oHm:INCEXPFD='I') .and. !(oHm:FROMRPP .and. !Empty(oHm:gc))
				oHm:gc := 'AG'
			ENDIF
		ENDIF
	ELSEif oHm:KIND=='K'  //member department
		if oHm:INCEXPFD='F'
			oHm:gc := 'PF'
		ELSEIF oHm:INCEXPFD='E'
			oHm:gc := 'CH'
		elseif oHm:INCEXPFD='I'
			oHm:gc:='AG'
		ENDIF
	else
		IF oHm:gc == 'CH' .and.!self:Owner:lMemberGiver
			* Reset present MG:
			recnr := 0
			DO WHILE (recnr:=AScan(oHm:aMirror,{|x| x[4] =='MG'},recnr+1))>0
				oHm:Goto(recnr)
				oHm:gc := 'AG'
				self:Owner:mCLNGiver:=''  //??
				oHm:aMirror[recnr,4]:=oHm:gc  && save in mirror
			ENDDO
			oHm:Goto(ThisRec)
		ENDIF
		oHm:gc := '  '
	endif
	oHm:aMirror[ThisRec,4]:=oHm:gc  && save in mirror
	IF oHm:KIND == 'M' .or.oHm:KIND == 'K'   //member (department)
		cAccId:=AllTrim(oHm:AccID)
		nDepId:=oHm:DEPID
		// aMirror: {accID,deb,cre,gc,category,recno,Trans:RecNbr,accnumber,AccDesc,balitemid,curr,multicur,debforgn,creforgn,PPDEST, description,persid,type, incexpfd,depid}
		//            1      2   3  4     5      6          7         8        9        10     11     12      13        14      15       16          17   18      19      20
		if	oHm:gc == 'CH'
			//	change AG to MG if needed:  
			if !self:Owner:lDirectIncome
				recnr	:=	0
				do	WHILE	(recnr:=AScan(oHm:aMirror,{|x|	x[4] =='AG'.and.!(x[1]==cAccId.and.!cAccId=='0'.or.x[20]==nDepId.and.!nDepId=0)},recnr+1))>0
					oHm:Goto(recnr)
					oHm:gc	:=	'MG'
					oHm:aMirror[recnr,4]:=oHm:gc	 && save	in	mirror 
				ENDDO
			endif
		elseif	oHm:gc == 'AG'
			if !self:Owner:lDirectIncome
				// change to MG if needed 
				cPersId:=self:Owner:mCLNGiver 
				// 			i:=AScan(oHm:aMirror,{|x|x[4]=="CH".and.x[3]<x[2].and.!(x[1]==cAccId.or.x[20]==nDepId.or.x[17]==cPersId)})
				i:=AScan(oHm:aMirror,{|x|x[4]=="CH".and.x[3]<x[2].and.!(x[1]==cAccId.and.!cAccId=='0'.or.x[20]==nDepId.and.!nDepId=0) .and.(Empty(cPersid).or.x[17]==cPersId)})
				IF (self:Owner:lMemberGiver.and.!(self:Owner:mCLNGiver==oHm:aMirror[ThisRec,17])) ;
						.or.i>0
					oHm:gc := 'MG'
					oHm:aMirror[ThisRec,4]:=oHm:gc  && save in mirror
				endif
			endif
		elseif AScan(oHm:aMirror,{|x|x[4]=="CH"})=0
			//	change MG to AG if needed: 

			recnr	:=	0
			do	WHILE	(recnr:=AScan(oHm:aMirror,{|x|	x[4] =='MG'.and.(x[1]==cAccId.and.!cAccId=='0'.or.x[20]==nDepId.and.!nDepId=0)},recnr+1))>0
				oHm:Goto(recnr)
				oHm:gc	:=	'AG'
				oHm:aMirror[recnr,4]:=oHm:gc	 && save	in	mirror
			ENDDO
			oHm:Goto(ThisRec)
		endif
	endif		
	self:Owner:Totalise(false,false)

	self:Owner:Goto(ThisRec)
	RETURN true
METHOD RegAccount(oRek,ItemName) CLASS InquirySelection
	LOCAL oAccount as SQLSelect
	LOCAL crek AS STRING
	oAccount:=oRek
	IF ItemName == "AccountFrom"
		IF	Empty(oRek).or.oRek==null_object .or. oRek:reccount < 1
			self:nAccount :=	Space(5)
			self:oDCmAccount:TEXTValue	:=	"" 
			self:oDCmAccnumber:TEXTValue :=''
			self:cAccNumber:=""
			self:cAccName := ""
			self:cDep:=""
// 			self:cBal:=""
			self:cSoort:=""
			self:cCurr:=""
			RETURN
		ENDIF
		self:nAccount :=  str(oAccount:accid,-1)
		self:oDCmAccnumber:TEXTValue := oAccount:ACCNUMBER 
		SELF:cAccNumber:= oAccount:ACCNUMBER
		self:oDCmAccount:TEXTValue := AllTrim(oAccount:Description)
		self:cAccName := AllTrim(oAccount:Description)
		self:cDep:=Str(oAccount:Department,-1)
// 		self:cBal:=Str(oAccount:balitemid,-1)
		self:cSoort:=oAccount:Type
		self:cCurr:=iif(Empty(oAccount:Currency),sCurr,oAccount:Currency)
	ELSEif ItemName == "AccountTo"
		IF	Empty(oRek).or.oRek==null_object .or. oRek:reccount < 1
			self:nAccountTo :=	Space(5)
			self:oDCmToAccount:TEXTValue	:=	"" 
			self:oDCmAccnumberTo:TEXTValue	:=	"" 
			self:cAccNumberTo:=""
			self:cAccNameTo := ""
			self:cDepTo:=""
			self:cSoortTo:=""
			self:cCurrTo:=""
			RETURN
		ENDIF
		self:nAccountTo :=  Str(oAccount:AccID,-1)
		self:cAccNumberTo:= oAccount:ACCNUMBER
		self:oDCmAccnumberTo:TEXTValue := oAccount:ACCNUMBER 
		self:oDCmToAccount:TEXTValue := AllTrim(oAccount:Description)
		self:cAccNameTo := AllTrim(oAccount:Description)
		self:cDepTo:=Str(oAccount:Department,-1)
		self:cSoortTo:=oAccount:Type
		self:cCurrTo:=iif(Empty(oAccount:Currency),sCurr,oAccount:Currency)

	ENDIF
		
RETURN NIL
METHOD RegDepartment(MyNum,ItemName) CLASS InquirySelection
	LOCAL depnr:="", deptxt:=""  as STRING
	local oDep as SQLSelect
	Default(@MyNum,null_string)
	Default(@Itemname,null_string)
	IF Empty(myNum)
		depnr:="0"
		deptxt:=sEntity+" "+sLand
	ELSE
		oDep:=SQLSelect{"select depid,descriptn  from department where depid="+MyNum,oConn}
		if oDep:RecCount>0
			depnr:=Str(oDep:DEPID,-1)
			deptxt:=oDep:DESCRIPTN
		ENDIF
	ENDIF	
	IF ItemName == "From Department"
		self:cFromDepId:= depnr
		self:oDCFromDep:TEXTValue := deptxt
	ENDIF
		
RETURN 
METHOD RegPerson(oCLN) CLASS InquirySelection                    
	IF Empty(oCLN) .or. !Empty(oCLn:Status) .or. oCLN:Reccount<1
		SELF:mCLNGiver :=  Space(5)
		SELF:cGiverName := ""
		SELF:oDCmPerson:TEXTValue := ""
		RETURN
	ENDIF
	self:mCLNGiver :=  Str(oCLN:persid,-1)
	self:cGiverName := GetFullName(self:mCLNGiver)
	SELF:oDCmPerson:TEXTValue := SELF:cGiverName

RETURN NIL
CLASS JournalBrowser INHERIT GeneralBrowser
METHOD ColumnFocusChange(oColumn , lHasFocus )  CLASS JournalBrowser
	LOCAL oHm as TempTrans
	LOCAL ThisRec,j as int 
	Local myValue as float 
	local myOwnerOwner:=self:owner:owner as General_Journal
	local myOwner:=self:owner as GeneralJournal1
	LOCAL myColumn as DataColumn
	SUPER:ColumnFocusChange(oColumn, lHasFocus)
	oHm:=self:owner:Server
	IF  Empty(oHm:aMirror).or.;  && empty ?
		oHm:lExisting.or.; && update existing transaction ?
		oHm:lOnlyRead && no updates allowed?
		RETURN    // skip
	ENDIF
	myColumn:= oColumn
	ThisRec:=oHm:RECNO
	IF myColumn:NameSym == #AccNumber
		IF !AllTrim(myColumn:TextValue) == ;
				AllTrim(oHm:aMirror[ThisRec,8]) && new value?
			oHm:aMirror[ThisRec,8]:= AllTrim(myColumn:TextValue) 
			myOwnerOwner:AccntProc(AllTrim(myColumn:VALUE))
		ENDIF
	ELSEIF myColumn:NameSym == #DEBFORGN 
		IF !Round(myColumn:VALUE,2) == Round(oHm:aMirror[ThisRec,13],2)
			myOwner:DebCreProc(false)
			myOwnerOwner:Totalise(false,false)
		ENDIF
	ELSEIF myColumn:NameSym == #CREFORGN 
		myValue:=Round(oHm:aMirror[ThisRec,14],2)
		IF !Round(myColumn:VALUE,2) == myValue
			myOwner:DebCreProc(false)
			myOwnerOwner:Totalise(false,false)
		ENDIF
	ELSEIF myColumn:NameSym == #CURRENCY
		IF !AllTrim(myColumn:VALUE) == oHm:aMirror[ThisRec,11]
			oHm:aMirror[ThisRec,11]:=AllTrim(myColumn:VALUE)
			myColumn:TextValue:= myColumn:VALUE
			oHm:CURRENCY:=myColumn:VALUE
			myOwner:DebCreProc(false)
		ENDIF
	ELSEIF myColumn:NameSym == #PPDEST .and.oHm:aMirror[ThisRec,1]==sToPP .and.!Empty(sToPP)
		IF !AllTrim(myColumn:VALUE) == AllTrim(oHm:aMirror[ThisRec,15])
			oHm:aMirror[ThisRec,15]:=AllTrim(myColumn:VALUE)
			myColumn:TextValue:= myColumn:VALUE
			oHm:PPDEST:=AllTrim(myColumn:VALUE)
		ENDIF
	ELSEIF myColumn:NameSym == #GC
		IF !AllTrim(myColumn:VALUE) == AllTrim(oHm:aMirror[ThisRec,4])
			oHm:aMirror[ThisRec,4]:=AllTrim(myColumn:VALUE)
			myColumn:TextValue:= myColumn:VALUE
			oHm:gc:=myColumn:VALUE
			IF !Empty(oHm:CheckUpdates())
				* restore old value:
				oHm:gc:=oHm:aMirror[ThisRec,4] 
				RETURN
			ELSE
				oHm:aMirror[ThisRec,4]:=oHm:gc  && save in mirror
				if !oHm:lFilling
					myOwnerOwner:lStop:=false
				endif
				myOwnerOwner:ValidateTempTrans(false,@j)
			ENDIF
		ENDIF
	elseif myColumn:NameSym == #DESCRIPTN
		if !oHm:lFilling
			myOwnerOwner:lStop:=false
		endif
		oHm:aMirror[ThisRec,16]:=alltrim(myColumn:Value)
	ELSEIF myColumn:NameSym== #AccDesc .and. lHasFocus
		self:SetColumnFocus(#DESCRIPTN)
	ENDIF
	RETURN 
CLASS PaymentBrowser INHERIT GeneralBrowser
METHOD ColumnFocusChange(oColumn , lHasFocus )  CLASS PaymentBrowser
	LOCAL oHm as TempGift
	Local myValue as float 
	local myOwnerOwner:=self:owner:owner as PaymentJournal
	local myOwner:=self:owner as PaymentDetails
//	LOCAL myColumn AS JapDataColumn
	LOCAL myColumn as DataColumn
	Local ThisRec as int
	SUPER:ColumnFocusChange(oColumn, lHasFocus)
	oHm:=self:owner:Server
	IF  Empty(oHm:aMirror);  && still empty ?
		.or.oHm:lExisting.or.; && during load of existing transaction, skip
		oHm:lOnlyRead && no updated allowed?
		RETURN
	ENDIF
	myColumn:= oColumn 
	ThisRec:=oHm:RECNO
// 	ThisRec:=AScan(oHm:aMirror, {|x| x[6]==oHm:RECNO})
	IF myColumn:NameSym == #AccNumber
		IF !AllTrim(myColumn:TextValue) == ;
		AllTrim(oHm:aMirror[ThisRec,8]) && waarde veranderd?
			oHm:aMirror[ThisRec,8]:= AllTrim(myColumn:TextValue) 
			myOwnerOwner:AccntProc(myColumn:VALUE)
		ENDIF
	ELSEIF myColumn:NameSym == #DEBFORGN .or. myColumn:NameSym == #DEB
		IF !Round(myColumn:VALUE,2) == Round(oHm:aMirror[ThisRec,13],2)
			myOwner:DebCreProc(false)
			myOwnerOwner:Totalise(false,false)
		ENDIF
	ELSEIF myColumn:NameSym == #CREFORGN 
			myValue:=Round(oHm:aMirror[ThisRec,9],2)
		IF !Round(myColumn:VALUE,2) == myValue
			myOwner:DebCreProc(false)
			myOwnerOwner:Totalise(false,false)
		ENDIF
	ELSEIF myColumn:NameSym == #CURRENCY
		IF !AllTrim(myColumn:VALUE) == oHm:aMirror[ThisRec,11]
			oHm:aMirror[ThisRec,11]:=AllTrim(myColumn:VALUE)
			myColumn:TextValue:= myColumn:VALUE
			oHm:CURRENCY:=myColumn:VALUE
			myOwner:DebCreProc(false)
		ENDIF
	ELSEIF myColumn:NameSym == #GC
		IF !AllTrim(myColumn:VALUE) == AllTrim(oHm:aMirror[ThisRec,4])
			oHm:aMirror[ThisRec,4]:=AllTrim(myColumn:VALUE)
// 			myColumn:TextValue:= myColumn:VALUE
			oHm:gc:=myColumn:VALUE
// 			IF !oHm:CheckUpdates()
// 				* Reset to previuos values
// 				oHm:gc:=oHm:aMirror[ThisRec,4]  && reset
// 				RETURN
// 			ELSE
				oHm:aMirror[ThisRec,4]:=oHm:gc  && save in mirror
				myOwnerOwner:ValidateTempGift()
// 			ENDIF
		ENDIF
 	ELSEIF myColumn:NameSym== #AccDesc .and. lHasFocus
 		self:SetColumnFocus(#Descriptn)
 	ELSEIF myColumn:NameSym== #ORIGINAL .and. lHasFocus
 		self:SetColumnFocus(#CREFORGN)
	elseif myColumn:NameSym == #Descriptn
		oHm:aMirror[ThisRec,14]:=alltrim(myColumn:textValue)
	ENDIF
RETURN 
METHOD DebCreProc(NoConvert:=false as logic) as void pascal CLASS PaymentDetails
	LOCAL oHm as TempGift
	Local ROE:=1 as float 
// 	Default(@NoConvert,false)
	oHm := self:Server
	if !NoConvert 
		if oHm:CURRENCY # sCurr 
			if oCurr==null_object
				oCurr:=Currency{}
			endif
			ROE:=oCurr:GetROE(oHm:CURRENCY,self:Owner:mDat)
			oHm:Cre:=Round(oHm:CREFORGN*ROE,DecAantal)
		ELSE		
			oHm:Cre:=oHm:CREFORGN
		endif
	endif
	oHm:SuspendNotification()
	IF oHm:KIND == 'M'
		IF Empty(oHm:CREFORGN)
			oHm:gc := '  '
		ELSE
			if !oHm:gc == 'PF' 
				if self:Owner:lMemberGiver
					if Val(self:Owner:mCLNGiver)=oHm:persid
						oHm:GC := 'PF'
					else 
						oHm:GC := 'MG'
					endif
				ELSE
					oHm:gc := 'AG'
				ENDIF
			ENDIF
		ENDIF
	ELSEIF oHm:KIND=='K'  //member department
		if oHm:incexpfd='F'
			oHm:gc := 'PF'
		ELSEIF oHm:incexpfd='E'
			oHm:gc := 'CH'
		ENDIF
	else
		oHm:gc:='  '
	ENDIF
	oHm:aMirror[oHm:RecNo,4]:=oHm:GC  && save in mirror
	oHm:aMirror[oHm:RecNo,3]:=oHm:cre  && save in mirror
	oHm:aMirror[oHm:RECNO,9]:=oHm:CREFORGN 
	oHm:ResetNotification()
	SELF:Browser:Refresh()

RETURN
METHOD AccntProc(uValue as string) as logic CLASS PaymentJournal
	LOCAL oHm as TempGift

	oHm:=SELF:Server
	IF oHm:lFilling    && bij vullen bestaande mutatie niets doen
		RETURN FALSE
	ENDIF

	AccountSelect(self,AllTrim(uValue ),"Destination",true,self:cDestFilter)
	RETURN true
	
METHOD append() CLASS PaymentJournal
	LOCAL lSuc AS LOGIC
	lSuc:=SUPER:append()
	IF lSuc
		IF lEarmarking
			self:Server:DESCRIPTN:=oLan:RGet("Allotted non-designated gift",,"!")
		ENDIF 
		self:Server:CURRENCY:=sCurr 
		//{accid,orig,cre,gc,category,recno,accid,accnumber,creforgn,currency,multcur,dueid,acctype,description,incexpfd}
		//   1    2    3   4    5      6      7      8        9        10      11      12      13      14

		AAdd(self:Server:aMirror,{'           ',0,0,'  ',' ',self:Server:Recno,"   "," ",0,sCurr,false,"","","",""})
	ENDIF
RETURN lSuc
METHOD AssignTo() as void pascal CLASS PaymentJournal
	******************************************************************************
	*  Name      : AssignTo.PRG
	*              With this module a received amount can be assigned to 
	*              apossible destinations of a person
	*  Auteur    : K. Kuijpers
	*  Datum     : 22 October 1993
	******************************************************************************
	* Used variables:
	* m51_totcr
	* self:mDebAmnt
	* m51_agift
	* m51_apost
	* cGiverName
	* self:AutoRec
	* MultiDest
	******************************************************************************

	************** DECLARATION OF VARIABLES *************************************
	******************************************************************************
	LOCAL m51_totcre,m51_totorg as FLOAT
	LOCAL nCurRec, m51_abest, m51_mult as int 
	local oHm as TempGift
	LOCAL cSoort as string
	LOCAL iTeller:=0, i as int
	LOCAL Original:={}, Applied:={} as ARRAY
	LOCAL DebAmount:=self:mDebAmnt as FLOAT 
	local cMess,Destname as string
	local nMsgPos as int
	local aWord:={} as array 
	oHm := self:server
	aApplied := {}
	m51_abest := Len(oHm:aMirror) 
	IF (self:m51_agift + self:m51_apost) = 0 .and. m51_abest = 0
		IF !Empty(self:defbest) .or. self:mDebAmntF > 0
			self:append()
			IF !Empty(self:defbest)
				oHm:AccID := self:defbest
				oHm:AccDesc:=self:defOms
				oHm:ACCNUMBER:=self:DefNbr
// 				oHm:KIND := if(Empty(self:defGc),"G","M")
				oHm:KIND := self:Defaccounttype
				oHm:Original := self:mDebAmnt
				oHm:CURRENCY := self:DefCur
				oHm:INCEXPFD := self:Defincexpfd
				m51_agift :=1
				if !Empty(self:mDebAmnt)
					IF self:mDebAmnt>0
						oHm:GC := iif(oHm:KIND='M' .and.self:lMemberGiver,'MG',defGc)
						oHm:DESCRIPTN := self:oLan:WGet('Gift')
						IF self:GiftsAutomatic
							self:autorec:=true
						ENDIF
						self:SpecialMessage()
					ELSE
						oHm:GC:="CH"
						if lTeleBank
							oHm:DESCRIPTN:=oTmt:m56_naam_tegnr
						endif
						IF self:DueAutomatic
							self:autorec:=true
						ENDIF
					ENDIF
				endif
			ENDIF
			oHm:cre := self:mDebAmnt
			if oHm:CURRENCY==sCurr
				oHm:CREFORGN:=oHm:cre 
			else
				oHm:CREFORGN:=Round( oHm:cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDAT),DecAantal)
			endif
			* save in mirror-array 
			oHm:aMirror[oHm:RECNO]:=;
				{oHm:AccID,oHm:Original,oHm:cre,oHm:GC,oHm:KIND,oHm:RECNO,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY, self:DefMulti,0,self:deftype,oHm:DESCRIPTN,oHm:INCEXPFD}
		ENDIF
		RETURN  // Nothing to assign
	ENDIF
	//   	if m51_abest=0
	// 		return
	// 	endif

	nCurRec := oHm:RECNO

	AEval(oHm:aMirror,{|x| m51_totorg += x[2]})
	AEval(oHm:aMirror,{|x| m51_totcre += x[3]})
	m51_totorg := Round(m51_totorg,DecAantal)
	m51_totcre := Round(m51_totcre,DecAantal)
	IF m51_totcre#m51_totorg .and..not.lTeleBank.and.!Empty(m51_totcre)
		RETURN && Already assigned
	ENDIF
	IF cGiverName = "Comit" .or. cGiverName="Komit".or. cGiverName="Com."
		IF self:m51_agift=1 .and. self:m51_apost = 0
			* Home front with one destination: assign directly
			oHm:cre := self:mDebAmnt
			if oHm:CURRENCY==sCurr
				oHm:CREFORGN:=oHm:cre 
			else
				oHm:CREFORGN:=Round( oHm:cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDAT),DecAantal)
			endif
			* Save in Mirror:
			oHm:aMirror[oHm:RECNO,3]:=oHm:cre  && save in mirror 
			oHm:aMirror[oHm:RECNO,9]:=oHm:CREFORGN 
			oHm:aMirror[oHm:RECNO,15]:=oHm:INCEXPFD
			If self:GiftsAutomatic 
				self:autorec:=true
			endif
			RETURN
		ENDIF
	ENDIF
	IF m51_abest = 1 
		*  In case of one destination: assign amount to that
		oHm:cre := self:mDebAmnt
		if oHm:CURRENCY==sCurr
			oHm:CREFORGN:=oHm:cre 
		else
			oHm:CREFORGN:=Round( oHm:cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDAT),DecAantal)
		endif
		IF !Empty(self:defbest) .and.AllTrim(oHm:AccID) == self:defbest
			if Empty(oHm:GC)
				oHm:GC := iif(oHm:KIND='M' .and.self:lMemberGiver,'MG',self:defGc)
			endif
			if Empty(oHm:DESCRIPTN)
				oHm:DESCRIPTN := self:oLan:WGet('Gift')
			endif  		
		endif
		* In case of one possible destination and matching amount, assign it to that:
		IF self:m51_agift =1 .and. (!MultiDest.or.oHm:Original==oHm:cre).and.self:GiftsAutomatic
			self:autorec:=true
		ENDIF
		self:SpecialMessage()
		* Save in Mirror:
		oHm:aMirror[oHm:RECNO,3]:=oHm:cre  && save in mirror
		oHm:aMirror[oHm:RECNO,9]:=oHm:CREFORGN  && save in mirror
		oHm:aMirror[oHm:RECNO,4]:=oHm:GC  && save in mirror
		oHm:aMirror[oHm:RECNO,14]:=oHm:DESCRIPTN  && save in mirror
		oHm:aMirror[oHm:RECNO,15]:=oHm:INCEXPFD
		RETURN
	ENDIF
	oHm:SuspendNotification()


	* Try to find a match with a combination of destinations = received amount:
	FOR i:=1 to Len(oHm:aMirror)
		AAdd(Original,oHm:aMirror[i,2])
	NEXT
	IF AmntFit(1,m51_abest,0,1,{},@Original,@Applied,@DebAmount,@iTeller) == "F"
		* Unique combination found of n from m:
		oHm:GoTop()
		IF self:GiftsAutomatic
			self:autorec:=true
		ELSEIF cGiverName = "Comit" .or. cGiverName="Komit".or. cGiverName="Com."
			* Assign to Home Front directly:
			self:autorec:=true
		ELSEIF !MultiDest.and.self:GiftsAutomatic
			* In case of Home Front System assign directly:
			self:autorec:=true
		ELSEIF Len(aApplied) = 1 // one unique destination
			cSoort:=oHm:aMirror[aApplied[1],5]
			IF cSoort == "M" .or. cSoort == "G"  //Gift
				IF self:GiftsAutomatic
					self:autorec:=true
				ENDIF
			ELSE // open post
				IF self:DueAutomatic
					self:autorec:=true
				ENDIF
			ENDIF
		ENDIF
		DO WHILE !oHm:EOF
			IF AScan(Applied,oHm:RECNO)= 0
				oHm:cre := 0
				oHm:CREFORGN:=0
			ELSE
				oHm:cre := oHm:Original
				if oHm:CURRENCY==sCurr
					oHm:CREFORGN:=oHm:cre 
				else
					oHm:CREFORGN:=Round( oHm:cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDAT),DecAantal)
				endif
			ENDIF
			self:SpecialMessage()
			* Save in Mirror:
			oHm:aMirror[oHm:RECNO,3]:=oHm:cre  && save in mirror
			oHm:aMirror[oHm:RECNO,9]:=oHm:CREFORGN  && save in mirror
			oHm:aMirror[oHm:RECNO,15]:=oHm:INCEXPFD
			oHm:aMirror[oHm:RECNO,14]:=oHm:DESCRIPTN  && save in mirror
			oHm:Skip()
		ENDDO
		m51_totcre := self:mDebAmnt
	ELSE
		iTeller:=0
		IF AmntFitMult(1,self:m51_agift,0,1,{},@Original,@Applied,@DebAmount,@m51_mult,@iTeller) == "F"  // multiple found of gift amount

			*  X times the total amount of the destinations received:
			oHm:GoTop()
			DO WHILE !oHm:EOF
				IF AScan(Applied,oHm:RECNO)= 0
					oHm:cre := 0
					oHm:CREFORGN:=0
				ELSE
					oHm:cre := oHm:Original*m51_mult
					if oHm:CURRENCY==sCurr
						oHm:CREFORGN:=oHm:cre 
					else
						oHm:CREFORGN:=Round( oHm:cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDAT),DecAantal)
					endif
				ENDIF
				self:SpecialMessage()
				* Save in Mirror:
				oHm:aMirror[oHm:RECNO,3]:=oHm:cre  && save in mirror
				oHm:aMirror[oHm:RECNO,9]:=oHm:CREFORGN  && save in mirror
				oHm:aMirror[oHm:RECNO,15]:=oHm:INCEXPFD
				oHm:aMirror[oHm:RECNO,14]:=oHm:DESCRIPTN  && save in mirror
				oHm:Skip()
			ENDDO
			m51_totcre := self:mDebAmnt
		ENDIF

	ENDIF

	IF !m51_totcre == self:mDebAmnt
		* let user assign destinations manually: 
		oHm:replace(0, {#CREFORGN,#CRE},,,DBSCOPEALL)   // bug: no array replace, only first element
		oHm:replace(0, {#CRE,#CREFORGN},,,DBSCOPEALL)
		AEval(oHm:aMirror,{|x| x[9]:=(x[3]:=0)})
		// Last check: if budgetcode corresponds with one destination:
		IF self:lTeleBank
			if !Empty(self:oTmt:m56_budgetcd) 
				oHm:GoTop()
				DO WHILE !oHm:EOF
					IF AllTrim(oHm:ACCNUMBER)==AllTrim(self:oTmt:m56_budgetcd)
						if oHm:Original==self:mDebAmnt
							oHm:cre:=oHm:Original
							if oHm:CURRENCY==sCurr
								oHm:CREFORGN:=oHm:cre 
							else
								oHm:CREFORGN:=Round( oHm:cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDAT),DecAantal)
							endif
							m51_totcre := self:mDebAmnt
							self:autorec:=true
							self:SpecialMessage()
							* Save in Mirror:
							oHm:aMirror[oHm:RECNO,3]:=oHm:cre  && save in mirror
							oHm:aMirror[oHm:RECNO,9]:=oHm:CREFORGN  && save in mirror
							oHm:aMirror[oHm:RECNO,14]:=oHm:DESCRIPTN  && save in mirror
							oHm:aMirror[oHm:RECNO,15]:=oHm:INCEXPFD
							exit
						else
							exit
						endif
					ENDIF
					oHm:Skip()
				ENDDO
			else
				// check if name mentioned in description corresponds with name of account 
				if m51_abest>1
					nMsgPos:=At('%%',self:oTmt:m56_description)
					if nMsgPos=0
						nMsgPos:=-1
					endif 
					cMess:=AllTrim(StrTran(Lower(SubStr(self:oTmt:m56_description,nMsgPos+2)),self:oLan:WGet('gift')))
					if !Empty(cMess) 
						oHm:GoTop()
						do WHILE !oHm:EOF
							aWord:=GetTokens(AllTrim(StrTran(Lower(oHm:AccDesc),'ink.')))
							if Len(aWord)>0
								Destname:=aWord[1,1]
								if AtC(Destname,cMess)>0
									oHm:cre:=self:mDebAmnt
									if oHm:CURRENCY==sCurr
										oHm:CREFORGN:=oHm:cre 
									else
										oHm:CREFORGN:=Round( oHm:cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDAT),DecAantal)
									endif
									m51_totcre := self:mDebAmnt
									self:SpecialMessage()
									* Save in Mirror:
									oHm:aMirror[oHm:RECNO,3]:=oHm:cre  && save in mirror
									oHm:aMirror[oHm:RECNO,9]:=oHm:CREFORGN  && save in mirror
									oHm:aMirror[oHm:RECNO,14]:=oHm:DESCRIPTN  && save in mirror
									oHm:aMirror[oHm:RECNO,15]:=oHm:INCEXPFD
									//		self:AutoRec:=true 
									exit
								endif
							endif 
							self:SpecialMessage()
							oHm:Skip()
						ENDDO
					endif
				endif 
			endif
		ENDIF			
	ENDIF
	oHm:ResetNotification()
	oHm:RECNO := nCurRec

	RETURN
METHOD Delete() CLASS PaymentJournal
 * delete record of TempGift:
LOCAL oHm:= self:server as TempGift
local nCurRec:=oHm:RecNo as int

	IF Empty(oHm:aMirror)  && nothing to delete?
		RETURN FALSE
	ENDIF
		IF oHm:aMirror[nCurRec,5]="G".or.oHm:aMirror[nCurRec,5]="M" .or.Empty(oHm:aMirror[nCurRec,5])
			--SELF:m51_agift
		ELSE
			--self:m51_apost
		ENDIF			
		ADel(oHm:aMirror,nCurRec)  && remove row from mirror
		ASize(oHm:amirror,Len(oHm:aMirror)-1)
		SUPER:Delete(TRUE)
		oHm:Pack()
		if oHm:RecCount>=nCurRec
			oHm:RecNo:=nCurRec
		endif
		SELF:oSFPaymentDetails:Browser:SuspendUpdate()
		//oHm:Delete(TRUE)
		self:AssignTo()
		self:Totalise(true,false)
		SELF:oSFPaymentDetails:Browser:RestoreUpdate()
		SELF:oSFPaymentDetails:Browser:Refresh()
	RETURN TRUE
METHOD FilePrint() CLASS PaymentJournal
LOCAL oHm as TempGift
LOCAL nRow, i, nCurRec as int
LOCAL nPage as int
LOCAL koparr AS ARRAY
LOCAL oReport as PrintDialog 
LOCAL DecSep as DWORD

oReport := PrintDialog{SELF,"Gift/Payment",,107}
oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
koparr:= {oLan:RGet("Gift",,"!")+"/"+oLan:RGet("payment",,"!"),' ',' '}
oHm:=SELF:Server
nCurRec:=oHM:RecNo
oHm:SuspendNotification()
oHm:Gotop()
nRow:=0
nPage:=0
	DecSep:=SetDecimalSep(Asc(DecSeparator))
oReport:PrintLine(@nRow,@nPage,;
Pad(oLan:RGet("transaction number",,"!")+":",20)+Transform(self:mTRANSAKTNR,"")+"(prior)",koparr)
oReport:PrintLine(@nRow,@nPage," ",koparr)  //skip one line
oReport:PrintLine(@nRow,@nPage,;
Pad(oLan:RGet("date",,"!")+":",20)+DToC(self:mDAT),koparr)
oReport:PrintLine(@nRow,@nPage," ")  //skip one line
oReport:PrintLine(@nRow,@nPage,;
Pad(oLan:RGet("document id",,"!")+":",20)+mBst,koparr)
oReport:PrintLine(@nRow,@nPage," ")  //skip one line
IF !Empty(self:mCLNGiver)
*	oPers:Seek(AllTrim(mCLNGiver))
   oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("Person",,"!")+":",koparr)
   oReport:PrintLine(@nRow,@nPage,GetFullNAW(self:mCLNGiver),koparr)
	oReport:PrintLine(@nRow,@nPage," ",koparr)  //skip one line
ENDIF

oReport:PrintLine(@nRow,@nPage,oLan:RGet("Transaction lines",107,"@!","C"),koparr)
oReport:PrintLine(@nRow,@nPage,;
oLan:RGet("Account",36,"@!")+' '+oLan:RGet("Description",40,"@!")+' '+oLan:RGet("Debit",12,"@!","R");
+" "+oLan:RGet("Credit",12,"@!","R")+' '+oLan:RGet("Ass",3,"@!"),koparr)
oReport:PrintLine(@nRow,@nPage,Replicate('-',107),koparr)

oReport:PrintLine(@nRow,@nPage,;
Pad(SubStr(self:DebAccNbr,1,12)+' '+AllTrim(self:oDCDebitAccount:TEXTValue),36)+' '+;
    Space(40)+' '+Str(mDebAmnt,12,decaantal),koparr)

DO WHILE !oHm:EOF
	oReport:PrintLine(@nRow,@nPage,;
    Pad(SubStr(oHm:ACCNUMBER,1,12)+' '+AllTrim(oHm:AccDesc),36)+' '+;
    Pad(oHm:DESCRIPTN,40)+' '+Space(12)+' '+Str(oHm:cre,12,DecAantal)+;
    ' '+PadC(oHm:gc,3),koparr)
	oHm:Skip()
ENDDO
oHm:Recno:=nCurRec
oHm:ResetNotification()
SetDecimalSep(Asc('.'))
oReport:prstart()
oReport:prstop()
RETURN NIL
METHOD FillTeleBanking(lNil:=nil as logic) as logic CLASS PaymentJournal
	* Filling of windowfields := giroteltransaction-values
	LOCAL oHm:=self:server as TempGift
	LOCAL lSuccess, lNameCheck,lAddressChanged as LOGIC
	LOCAL oEditPersonWindow as NewPersonWindow
	local CurRate as float
	local oPersCnt as PersonContainer
	local myAcc as SQLSelect
	local oPersBank,oSel as SQLSelect
	local oPers as SQLSelect
	local cBankDescription as string 

	self:Reset()
	self:AutoCollect:=FALSE 
	self:Acceptgiro:=False
	if !IsObject(self:oTmt) .or.self:oTmt==null_object
		return false
	endif
	* In case of automatic collection (CLIEOP03-file) and Acceptgiro via BGC look for pay ahead account:
	IF (self:oTmt:m56_kind="COL" .or.self:oTmt:m56_kind="KID" .or.self:oTmt:m56_kind="ACC")  .and.self:oTmt:m56_addsub ="B"
		IF Empty(self:oTmt:m56_payahead)
			(ErrorBox{self:owner,"No account for Payments en route specified for banknbr "+AllTrim(self:oTmt:m56_bankaccntnbr)}):show()
			self:EndWindow()
			RETURN FALSE
		ELSE
			myAcc:=SqlSelect{"select a.description,ad.accnumber "+;
				"from	account a,bankaccount b left join account ad on (ad.accid=b.singledst and ad.active=1)  "+;
				"where a.accid=b.accid and a.accid="+AllTrim(self:oTmt:m56_sgir),oConn}
			if	myAcc:reccount>0
				// 				self:oTmt:m56_description+= " from	"+myAcc:description
				cBankDescription:= " from	"+myAcc:description
				if Empty(self:oTmt:m56_budgetcd) .and.self:oTmt:m56_kind="ACC".and.!Empty(myAcc:accnumber)
					self:oTmt:m56_budgetcd:=myAcc:accnumber  
				endif
			endif
			self:oTmt:m56_sgir:=self:oTmt:m56_payahead
		ENDIF
		IF self:oTmt:m56_kind="COL" .or.self:oTmt:m56_kind="KID"
			self:AutoCollect:=true
		else
			self:Acceptgiro:=true
		endif
	ENDIF
	IF (myAcc:=SQLSelect{"select accid,currency,accnumber,description from account where accid="+AllTrim(self:oTmt:m56_sgir),oConn}):RecCount<1
		(errorbox{self:owner,DebAccNbr+":"+" unknown account"}):show()
		self:EndWindow()
		RETURN FALSE
	ENDIF
	
	self:mCLNGiver :=  ""
	self:cGiverName := ""
	self:oDCmPerson:TEXTValue := ""
	self:DebCurrency:=myAcc:CURRENCY
	self:DebAccNbr:=myAcc:ACCNUMBER 
	self:oDCDebitAccount:Value  := myAcc:Description
	if !self:DebAccId== self:oTmt:m56_sgir 
		self:DebAccId:=self:oTmt:m56_sgir
		self:bankanalyze()
	endif	
	self:ShowDebbal()
	self:mDAT := self:oTmt:m56_bookingdate
	self:mBst := AllTrim(self:oTmt:m56_kind)+AllTrim(Str(self:oTmt:m56_seqnr,-1)) 
	self:oDCmBST:Value:=self:mBst
	if !self:DebCurrency==sCurr
		if self:oCurr==null_object
			self:oCurr:=Currency{}
		endif
		CurRate:= self:oCurr:GetROE(self:DebCurrency,self:mDAT) 
	endif
	//Acceptgiro:=FALSE  ???
	IF self:oTmt:m56_addsub ="B"
		self:mDebAmntF:= self:oTmt:m56_amount
		IF CountryCode='31' .and.(Trim(self:oTmt:m56_kind)="AC" .or.SubStr(self:oTmt:m56_description,17,2)=="AC".and.isnum(SubStr(self:oTmt:m56_description,1,16)))
			self:Acceptgiro:=true
			lNameCheck:=true 
			*   		SELF:mCLNGiver := SubStr(self:oTmt:m56_description,2,5)   // juiste formaat door fout verkeerd om
			IF !Empty(self:oTmt:m56_persid)
				self:mCLNGiver := self:oTmt:m56_persid
			ELSEif isnum(Pad(SubStr(self:oTmt:m56_description,1,16),16,"A")) .and.!Trim(self:oTmt:m56_kind)="AC"
				self:mCLNGiver := SubStr(self:oTmt:m56_description,12,5)
				if !isnum(self:mCLNGiver) .or.Val( mCLNGiver)=0
					self:mCLNGiver:=""
				endif
			ENDIF
		ELSEIF Trim(self:oTmt:m56_kind)="KID"  .and. !Empty(self:oTmt:m56_persid)
			self:Acceptgiro:=true
			self:mCLNGiver := self:oTmt:m56_persid    // import KID file (Norway)
		ELSEIF Trim(self:oTmt:m56_kind)="PGA"
			self:mCLNGiver := self:oTmt:m56_persid    // import PG Autogiro file (Swedisch)	
			self:Acceptgiro:=true
		else
			lNameCheck:=true 
		ENDIF			
	ELSE
		self:mDebAmntF:=-self:oTmt:m56_amount
	ENDIF
	self:oDCmDebAmntF:Value:= self:mDebAmntF
	if self:DebCurrency==sCurr
		self:mDebAmnt :=self:mDebAmntF
	else
		self:mDebAmnt:=Round(CurRate*self:mDebAmntF,DecAantal)
	endif
	// 	lNameCheck:=true
	oPersCnt:=PersonContainer{}
	* Analyse name and address from Bank: 
	oPersCnt:m51_lastname:=AllTrim(self:oTmt:m56_contra_name)
	oPersCnt:m51_pos:=self:oTmt:m56_zip
	oPersCnt:m51_ad1:=self:oTmt:m56_address
	oPersCnt:m51_city:=self:oTmt:m56_town
	oPersCnt:m51_country:=self:oTmt:m56_country
	oPersCnt:m56_banknumber:=self:oTmt:m56_contra_bankaccnt
	oPersCnt:m51_bic:=self:oTmt:m56_bic  
	oPersCnt:m51_type:="individual"
	oPersCnt:m51_gender:="unknown"
	if Empty(oPersCnt:m51_ad1) .and. Empty(oPersCnt:m51_pos) .and. Empty(oPersCnt:m51_city)
		oPersCnt:m51_ad1:=AllTrim(self:oTmt:m56_description) 
		oPersCnt:Naw_Analyse()
		if Empty(oPersCnt:m51_lastname)
			oPersCnt:m51_lastname:=AllTrim(self:oTmt:m56_description)
			oPersCnt:NameAnalyse(!Empty(oPersCnt:m51_ad1),!Empty(oPersCnt:m51_initials),!Empty(oPersCnt:m51_gender),!Empty(oPersCnt:m51_prefix),!Empty(oPersCnt:m51_pos),!Empty(oPersCnt:m51_city))
		endif
	else
		oPersCnt:Naw_Analyse(,,,!Empty(oPersCnt:m51_pos),!Empty(oPersCnt:m51_city),!Empty(oPersCnt:m51_ad1))
	endif

	//IF Empty(self:oTmt:m56_contra_bankaccnt).or.self:oTmt:m56_addsub =="A".or.(Acceptgiro.and.!Empty(Val(mCLNGiver))).or.;
	//	(ADMIN="HO".and.(self:oTmt:m56_kind="VZ".or.self:oTmt:m56_kind="DV".or.self:oTmt:m56_kind="FL"))
	IF self:oTmt:m56_addsub =="A".or.(self:Acceptgiro.and.!Empty(Val(self:mCLNGiver))).or.;
			(self:oTmt:m56_kind="VZ".or.self:oTmt:m56_kind="DV".or.self:oTmt:m56_kind="FL")
		self:InitGifts()
		//oHm:=SELF:Server
		*	IF (self:oTmt:m56_kind="VZ".or.self:oTmt:m56_kind="DV".or.self:oTmt:m56_kind="FL").and.self:oTmt:m56_addsub ="B"
		IF (self:oTmt:m56_kind="VZ".or.self:oTmt:m56_kind="DV".or.self:oTmt:m56_kind="FL").or.ADMIN="HO"
			IF oHm:Lastrec=0
				self:append()
				oHm:cre := self:oTmt:m56_amount
			ENDIF	
			oHm:DESCRIPTN:=self:oTmt:m56_contra_name
			oHm:GC:="CH"
			IF ADMIN="HO".and.!Empty(defbest)
				oHm:AccID := self:defbest
				oHm:AccDesc:=self:defOms
				oHm:ACCNUMBER:=self:DefNbr
				oHm:KIND := if(Empty(self:defGc),"G","M")
				self:AutoRec:=true
			ENDIF
			* save in mirror-array
			oHm:aMirror[oHm:Recno]:=;
				{oHm:ACCNUMBER,oHm:Original,oHm:cre,oHm:GC,oHm:KIND,oHm:Recno,alltrim(oHm:AccID),oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,oHm:Multiple,0,'',oHm:DESCRIPTN,oHm:INCEXPFD}	
			//ELSEIF Acceptgiro 
		ELSEIF !Empty(self:mCLNGiver) 
			self:PersonButton(true,,true,oPersCnt)
			// 				m51_assrec:=self:oPers:Recno
			if self:Acceptgiro
				self:oDCmPerson:Disable()
				self:oCCPersonButton:Disable()
			endif
		ELSE
			lNameCheck:=true
			AutoRec:=FALSE
			self:mCLNGiver:=""
			// 				m51_assrec:=0
		ENDIF
	ELSE
		self:oDCmPerson:Enable()
	ENDIF
	IF lNameCheck
		if Empty(self:mCLNGiver)
			self:Recognised:=FALSE
		endif
		
		IF !Empty(self:oTmt:m56_contra_bankaccnt) 
			oPers:=SqlSelect{'select pb.persid,pb.banknumber,p.postalcode,p.address,p.externid from personbank pb, person p where p.persid=pb.persid and p.deleted=0 and '+;
			iif(!sepaenabled.or.IsIban(self:oTmt:m56_contra_bankaccnt),'pb.banknumber','right(pb.banknumber,'+Str(Len(self:oTmt:m56_contra_bankaccnt),-1)+')')+'="'+AllTrim(self:oTmt:m56_contra_bankaccnt)+'"',oConn}
			if oPers:RecCount>0
				self:Recognised:=true 
				lAddressChanged:=false
				self:oTmt:m56_contra_bankaccnt:=oPers:banknumber     // can be different when non-IBan
				oPersCnt:m56_banknumber:= self:oTmt:m56_contra_bankaccnt
				// 					m51_assrec:=self:oPers:Recno
				IF Len(oPersCnt:m51_pos)>=7 
					if !oPersCnt:m51_pos==oPers:postalcode .and.!Empty(oPers:postalcode)
						lAddressChanged:=true
					ENDIF
				elseif (!CountryCode=="31" .or. !Empty(oPersCnt:m51_country)) .and. Len(oPersCnt:m51_ad1)>1 .and.!Lower(oPersCnt:m51_ad1)==Lower(oPers:address)
					lAddressChanged:=true
				endif
				if lAddressChanged					
					* address changed: 
					oPersCnt:persid:=Str(oPers:persid,-1)
					oEditPersonWindow := NewPersonWindow{ self:owner,,oPers,{lNew,true,self,oPersCnt }}
					oEditPersonWindow:Caption:="Address changed of: "+AllTrim( GetFullNAW(oPersCnt:persid))
					oEditPersonWindow:show()
					AutoRec:=FALSE
				ELSE
					self:Regperson(oPers)
				ENDIF
				self:oDCmPerson:Disable()
				self:oCCPersonButton:Disable() 
			ENDIF
		ENDIF
		IF !self:Recognised
			AutoRec:=FALSE
// 			IF !self:Acceptgiro
// 				self:InitGifts()      // ????
// 			ENDIF
			* In case of automatic collection (CLIEOP03-file) or acceptgiro no name known:
			IF self:AutoCollect .or. self:Acceptgiro  .and.Empty(oPersCnt:m51_lastname)
				self:cOrigName:=AllTrim(self:oTmt:m56_contra_bankaccnt)
				self:oDCmPerson:TEXTValue := self:cOrigName
			ELSE
				cOrigName:=AllTrim(oPersCnt:m51_lastname)
				IF Empty(cOrigName)
					self:cOrigName:=mCLNGiver
				ENDIF
				self:mCLNGiver:=""
				self:oDCmPerson:TEXTValue :=cOrigName
			ENDIF
			self:oDCmPerson:Enable()
			self:oCCPersonButton:Enable()
			if !Empty(self:oDCmPerson:TEXTValue)
				self:PersonButton(,"Giver/Payer ",,oPersCnt)  // to prevent to many persons screen open
			endif
		ENDIF
		// determine extra messsage in description of transaction:
		// 		self:SpecialMessage() 
	ENDIF
	if !Empty(cBankDescription)
		self:oTmt:m56_description+cBankDescription
	endif
	self:oDCcGirotelText:Caption:=AllTrim(self:oTmt:m56_contra_name)+iif(Empty(AllTrim(self:oTmt:m56_contra_bankaccnt)).or.Len(AllTrim(self:oTmt:m56_contra_bankaccnt))>60,'',' ('+AllTrim(self:oTmt:m56_contra_bankaccnt)+') ')+' '+;
		iif(Empty(self:oTmt:m56_description).or.!Empty(self:oTmt:m56_address).and.!self:oTmt:m56_address $ self:oTmt:m56_description,; 
	Compress(self:oTmt:m56_description+", "+self:oTmt:m56_address+" "+self:oTmt:m56_zip+" "+self:oTmt:m56_town+" "+self:oTmt:m56_country),self:oTmt:m56_description)
	self:oDCmDat:Disable()
	self:oDCDebitAccount:Disable()
	self:oDCmDebAmntF:Disable()
	RETURN true
METHOD InitGifts(cExtraText:="" as String) as logic CLASS PaymentJournal
	LOCAL oHm:= self:server as TempGift
	local oSub,oDue as SQLSelect
	* Initialiseren van standaardgiften van een gever
	* cExtraText: Optional text to be added to gift description

	// Default(@cExtraText,null_string)
	self:m51_agift:=0
	self:m51_apost:=0
	IF self:lEarmarking
		RETURN false
	ENDIF
	self:mCLNGiver:=AllTrim(mCLNGiver)
	self:oSFPaymentDetails:Browser:SuspendUpdate()
	IF self:Server:Lastrec > 0
		self:Reset()
	ENDIF
	self:fTotal := 0
	* IN CASE OF automatic collection (CLIEOP03-file) no name known:
	IF .not.Empty(self:mCLNGiver)
		IF self:AutoCollect.or. self:Acceptgiro
			IF !Empty(self:oTmt:m56_budgetcd).or.(self:Acceptgiro.and.!AllTrim(self:oTmt:m56_kind)=="PGA")
				self:append()
				IF !Empty(self:oTmt:m56_budgetcd)
					oHm:ACCNUMBER := self:oTmt:m56_budgetcd
// 				ELSEIF self:Acceptgiro
// 					oHm:ACCNUMBER := LTrimZero(SubStr(self:oTmt:m56_description,2,5))
				ENDIF
				oHm:Original := self:oTmt:m56_amount
				oHM:GC := "AG"
				// 				oHm:GetCategory("G",cExtraText)
				oHm:GetCategory(,cExtraText)
				IF !Empty(oHm:AccID)
					++self:m51_agift
					oHm:cre := self:oTmt:m56_amount
// 					if !AllTrim(self:oTmt:m56_kind)=="KID" 
						self:AutoRec:=true
// 					endif
				ENDIF
				if oHm:CURRENCY==sCurr
					oHm:CREFORGN:=oHm:cre 
				else
					oHm:CREFORGN:=Round( oHm:cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDAT),DecAantal)
				endif
				self:oSFPaymentDetails:DebCreProc(true)
// 				* save in mirror-array
				oHm:aMirror[oHm:Recno]:=;
					{oHm:AccID,oHm:Original,oHm:cre,oHm:GC,oHm:KIND,oHm:Recno,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,oHm:Multiple,0,'',oHm:DESCRIPTN,oHm:INCEXPFD}    
			ENDIF
		elseif !Empty(self:DefBest)
			// single destination bank account: 
			if !self:lTeleBank
				// search standard gift with DefBest: 
				oSub:=SQLSelect{"select s.amount from subscription s "+;
					"where personid="+self:mCLNGiver+" and accid="+self:defbest+" limit 1",oConn}
				if oSub:Reccount>0
					self:mDebAmntF := oSub:amount
					self:DebCurrency:=sCurr
				endif
				self:AssignTo()
			endif
		ENDIF
		IF !self:AutoRec  .and.Empty(self:DefBest)
			IF !self:lTeleBank.and.!self:lEarmarking
				self:mDebAmnt :=0
				self:mDebAmntF :=0
				self:CurDebAmnt := 0
			ENDIF
			********** place regular gifts in TempGift *********** 
			oSub:=SQLSelect{"select s.amount,s.accid,s.category,s.reference,invoiceid,b.category as acctype from subscription s, account a, balanceitem b"+;
				" where s.personid="+self:mCLNGiver+" and s.category='G' and a.accid=s.accid and b.balitemid=a.balitemid and a.active=1",oConn}
			oSub:Execute()
			if oSub:Reccount>0
				do WHILE !oSub:EOF 
					self:append()
					oHm:cre := oSub:amount
					IF .not.self:lTeleBank.and.!self:lEarmarking
						self:mDebAmnt += oSub:amount     && sum credit amounts to debamount
					ENDIF
					oHm:AccID := Str(oSub:AccID,-1)
					oHm:Original := oSub:amount
					//oHM:GC := oSub:GC
					oHm:GetCategory(,cExtraText)
					if oHm:CURRENCY==sCurr
						oHm:CREFORGN:=oHm:Cre 
					else
						oHm:CREFORGN:=Round( oHm:Cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDAT),DecAantal)
					endif
					oHm:REFERENCE:=oSub:REFERENCE
					self:oSFPaymentDetails:DebCreProc(true)
// 					* save in mirror-array
					oHm:aMirror[oHm:Recno]:=;
						{oHm:AccID,oHm:Original,oHm:cre,oHm:GC,oHm:KIND,oHm:Recno,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,oHm:Multiple,0,oSub:acctype,oHm:DESCRIPTN,oHm:INCEXPFD} 
					// check if Subscription InvoiceID equal to description of telebanking record in case of autogiro: 
					if self:lTeleBank
						if !Empty(self:oTmt:m56_description) .and.self:oTmt:m56_description==AllTrim(oSub:INVOICEID)
							self:oTmt:m56_budgetcd:=oHm:ACCNUMBER
						endif
					endif
					++self:m51_agift
					oSub:SKIP()
				ENDDO 
			endif
			********** place due amounts into tempgift ***********
			oDue:=SQLSelect{"select dueid,s.personid as persid,round(amountinvoice - amountrecvd,2) as cre,s.accid,cast(invoicedate as date) as invoicedate,d.seqnr,b.category as acctype "+;
				"from dueamount d,account a, balanceitem b,subscription s "+;
				"where amountinvoice>amountrecvd and d.subscribid=s.subscribid and a.accid=s.accid and a.active=1 and  b.balitemid=a.balitemid and s.paymethod<>'C' and s.personid="+self:mCLNGiver,oConn}     // direct debit
			oDue:Execute()
			if oDue:Reccount>0
				DO WHILE !oDue:EOF 
					self:Append()
					oHm:cre := oDue:cre
					IF .not.self:lTeleBank.and.!self:lEarmarking
						self:mDebAmnt := self:mDebAmnt + oHm:cre
						&& sum credit amounts as default for debit
					ENDIF
					oHm:AccID := Str(oDue:AccID,-1)
					//	       oHm:ID:=Mod11(mCLNGiver+DToS(oDue:invoicedate)+StrZero(Val(oDue:seqnr),2,0))
					oHm:ID:=DToS(oDue:invoicedate)+Str(oDue:seqnr,-1) 
					if oHm:CURRENCY==sCurr
						oHm:CREFORGN:=oHm:Cre 
					else
						oHm:CREFORGN:=Round( oHm:Cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDAT),DecAantal)
					endif
					oHm:GetCategory("F",cExtraText)
					oHm:DESCRIPTN:=AllTrim(oHm:DESCRIPTN)+' '+oHm:ID
					*			mCLNGiver+"-"+DToC(oDue:invoicedate)+"-"+oDue:seqnr
					oHm:Original := oDue:cre 
					self:oSFPaymentDetails:DebCreProc(true)
// 					* save in mirror-array
					oHm:aMirror[oHm:Recno]:=;
						{oHm:AccID,oHm:Original,oHm:cre,oHm:gc,oHm:KIND,oHm:RECNO,oHm:AccID,oHm:accnumber,oHm:CREFORGN,oHm:CURRENCY,oHm:Multiple,Str(oDue:dueid,-1),oDue:acctype,oHm:DESCRIPTN,oHm:INCEXPFD}
					++self:m51_apost
					oDue:SKIP()
				ENDDO
			endif
		ENDIF
		IF self:lTeleBank
			self:AssignTo()
		ENDIF
		IF .not.self:lTeleBank.and.!self:lEarmarking
			if self:DebCurrency == sCurr
				self:mDebAmntF:=self:mDebAmnt
			else
				self:mDebAmntF:=Round( self:mDebAmnt/self:oCurr:GetROE(self:DebCurrency,self:mDAT),DecAantal)
			endif
		endif
	ELSEIF self:lTeleBank.and.self:mDebAmnt<0
		self:AssignTo()
	ENDIF 
	IF self:m51_agift>0.or.self:m51_apost>0
		oHm:GoTop()
		IF !self:AutoRec
			self:Totalise(false,false)
		ENDIF
	ENDIF
	self:CurDebAmnt := self:mDebAmnt
	self:oDCmDebAmntF:Value:=self:mDebAmntF
	self:oSFPaymentDetails:Browser:RestoreUpdate()
	self:oSFPaymentDetails:Browser:Refresh()
	self:oCCOKButton:SetFocus()
	RETURN true
METHOD RegAccount(oAcc,ItemName) CLASS PaymentJournal
	* registration of debitAccount and destination initiated by AccountBrowser
	LOCAL cAcc as STRING
	LOCAL oAccount:=oAcc,oBank as SQLSelect
	local oPers as PersonContainer
	LOCAL oHm:=self:server as TempGift
	local MultiCur:=false as logic
	if oHm==null_object
		return nil
	endif
	IF Empty(oAcc).or.oAcc==null_object
		cAcc:=Space(11)
	ELSE
		IF oAcc:Eof
			RETURN
		ENDIF
		oAccount:=oAcc
		cAcc := Str(oAccount:AccID,-1)
	ENDIF
	IF ItemName == "DEBITACCOUNT"
		IF Empty(cAcc)
			RETURN
		ENDIF
		self:GiftsAutomatic := FALSE			
		self:DueAutomatic := FALSE			
		self:DebitAccount :=  cAcc
		self:DebAccNbr := oAccount:ACCNUMBER
		self:DebAccId:=cAcc
		self:DefType:=oAcc:Type
		self:DebCln := Transform(oAccount:persid,"")
		self:oDCDebitAccount:TEXTValue := AllTrim(oAccount:Description) 
		self:DebCurrency:=oAccount:CURRENCY 
		if !Empty(self:mDebAmntF) .and. !self:DebCurrency==sCurr
			self:mDebAmnt:=Round(mDebAmntF*oCurr:GetROE(DebCurrency,self:mDat),DecAantal) 
			self:AssignTo()
		endif			
		self:ShowDebBal()
		*    	SELF:lMemberGiver := FALSE
		IF !Empty(Val(self:DebCln)) 
			oPers:=PersonContainer{}
			oPers:persid:=self:DebCln
			self:RegPerson(oPers)
			self:lMemberGiver := true
		ELSE
			oBank:=SQLSelect{"select giftsall,openall from bankaccount where accid="+cAcc,oConn}
			IF oBank:Reccount>0
				self:GiftsAutomatic:=iif(ConI(oBank:GIFTSALL)=1,true,false)
				self:DueAutomatic:=iif(ConI(oBank:OPENALL)=1,true,false)
			ENDIF
		ENDIF
	ELSEIF ItemName == "Destination"
		*		cAcc := oAccount:accid
		IF !Empty(cAcc)
			oHm:AccID:=cAcc
			oHm:AccDesc := oAccount:Description
			oHm:AccNumber := oAccount:AccNumber
			oHm:CURRENCY:= oAccount:CURRENCY
			MultiCur:=iif(ConI(oAccount:MULTCURR)=1,true,false)
			oHm:Multiple:=MultiCur
			oHm:GetCategory()
			* Default applied amount:
			oHm:Original := 0
			IF self:fTotal > 0 .and. Empty(oHm:cre)
				* save in mirror-array
				oHm:cre := self:fTotal 
				if oHm:CURRENCY==sCurr
					oHm:CREFORGN:=oHm:cre 
				else
					oHm:CREFORGN:=Round( oHm:cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDat),DecAantal)
				endif
				oHm:aMirror[oHm:RECNO]:=;
					{oHm:AccID,oHm:Original,oHm:cre,oHm:gc,oHm:KIND,oHm:RECNO,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,MultiCur,0,oAccount:type,oHm:DESCRIPTN,oHm:INCEXPFD}
				self:oSFPaymentDetails:DebCreProc(false)
			ELSE
				if !oHm:CURRENCY==oHm:aMirror[oHm:RECNO,10]
					if oHm:CURRENCY==sCurr
						oHm:CREFORGN:=oHm:Cre 
					else
						oHm:CREFORGN:=Round( oHm:Cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDat),DecAantal)
					endif
				endif	
				//				oHm:aMirror[AScan(oHm:aMirror,{|x|x[6]==oHm:Recno})]:=;
				oHm:aMirror[oHm:RECNO]:=;
					{oHm:AccID,oHm:Original,oHm:cre,oHm:gc,oHm:KIND,oHm:RECNO,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,MultiCur,0,oAccount:type,oHm:DESCRIPTN,oHm:INCEXPFD}
				self:oSFPaymentDetails:DebCreProc(true)
			ENDIF
		ELSE
			oHm:KIND := " "
			oHm:AccDesc := ""
			oHm:Gc := ""
			oHm:Original := 0
			oHm:ACCNUMBER:=cAcc
			oHm:CURRENCY:=sCurr
			oHm:AccID:="" 
			oHm:Multiple:=false 
			oHm:INCEXPFD:=" "
			// {accid,orig,cre,gc,category,recno,accid,accnumber,creforgn,currency,multcur,dueid,acctype,description}
			//    1    2    3   4    5      6      7      8        9        10      11      12      13      14
			oHm:aMirror[oHm:RECNO]:=;
				{oHm:AccID,oHm:Original,oHm:Cre,oHm:GC,oHm:KIND,oHm:Recno,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,false,0,'',oHm:DESCRIPTN,oHm:INCEXPFD}
		ENDIF 
		self:oSFPaymentDetails:AddCurr()
		self:Totalise(false,false)

		self:oSFPaymentDetails:Browser:SetColumnFocus(#AccDesc)

	ENDIF
	
	RETURN true
METHOD RegPerson(oCLN,cItemname,lOK,oPersBr) CLASS PaymentJournal
	* cItemname: use for extra text for gift
	
	LOCAL lNewGift:= true as LOGIC
	local oSel as SQLSelect
	Default(@cItemname,NULL_STRING)
	Default(@lOK,FALSE)
	IF Empty(oCLN) .or. (IsInstanceOf(oCLN,#SQLSELECT) .and. oCLN:RecCount<1)
		//	self:cGiverName:=self:cOrigName
		self:oDCmPerson:Value:=self:cOrigName
		RETURN
	ENDIF
	IF Empty(SELF:mCLNGiver).and.!Empty(SELF:mDebAmnt)
		lNewGift:=FALSE
	ENDIF
	self:mCLNGiver :=  iif(IsNumeric(oCLN:persid),Str(oCLN:persid,-1),oCLN:persid)
	self:cGiverName := GetFullName(self:mCLNGiver) 
	self:cOrigName:=self:cGiverName
	SELF:oDCmPerson:TEXTValue := SELF:cGiverName
	IF SQLSelect{"select mbrid from member where persid="+self:mCLNGiver,oConn}:Reccount>0
		self:lMemberGiver := true
	ELSE
		self:lMemberGiver := FALSE
	ENDIF
	if self:lTeleBank
		if !Empty(self:oTmt:m56_contra_bankaccnt) .and. sepaenabled .and. !IsSEPA( self:oTmt:m56_contra_bankaccnt)
			// check if banknumber converted:
			oSel:=SqlSelect{"select banknumber from personbank where persid="+self:mCLNGiver+" and right(banknumber,"+Str(Len(self:oTmt:m56_contra_bankaccnt),-1) +")="+ self:oTmt:m56_contra_bankaccnt,oConn}
			if oSel:reccount>0
				self:oTmt:m56_contra_bankaccnt:=oSel:banknumber
			endif
		endif
	endif
	if IsObject(oPersBr)
		if IsMethod(oPersBr,#ENDWINDOW)
			oPersBr:EndWindow()
		endif
	endif
	IF lNewGift.or.lTeleBank
		*Reset help-fields:
		//oCln:ResetNaW()
		SELF:AutoRec:=FALSE
		SELF:InitGifts()
		IF lOK
			IF SELF:AutoRec
				SELF:OKButton()
			ENDIF
		ENDIF

	ENDIF

	RETURN TRUE
METHOD ReSet() CLASS PaymentJournal
	LOCAL oHm:=self:server as TempGift
	if IsObject(oHm) .and.!oHm==null_object
		oHm:Zap()
		oHm:aMirror:={}
		self:AutoRec:=FALSE
		RETURN
	else
		self:EndWindow()
		self:Close()
	endif
Method SpecialMessage() class PaymentJournal
	LOCAL oHm:=self:server as TempGift
	local cSpecMessage as string
	local Destname as string
	local lManually as logic 
	// determine extra messsage in description of transaction: 
	if !self:Acceptgiro .and.  !Empty(oHm:AccDesc) .and.!Empty(self:oTmt)
		Destname:=GetTokens(oHm:AccDesc)[1,1]
		lManually:=SpecialMessage(self:oTmt:m56_description,Destname,@cSpecMessage)
		oHm:DESCRIPTN:=iif(Empty(oHm:DESCRIPTN),cSpecMessage,AllTrim(oHm:DESCRIPTN)+" "+cSpecMessage)
		if lManually 
			self:autorec:=false  // stop in case of special message with automatic processing of telebanking records
		endif
	endif
	return
METHOD Totalise(lDelete:=false as logic,lDebAmount:=false as logic) as logic CLASS PaymentJournal
	LOCAL oHm as TempGift
	LOCAL fTot:=0.00 as FLOAT
	oHm := self:server
	fTot:=asum(oHm:aMirror,,,3)
   self:fTotal := Round(self:mDebAmnt - fTot,DecAantal)
	// Append eventually a new record:
	IF self:fTotal >0.and.!lDelete  // nog bedrag toe te wijzen?
		IF AScan(oHm:aMirror,{|x| x[3]==0})=0   // Geen lege transact en geen delete?
		// Append new record:
			self:Append()
			oHm:Cre := self:fTotal
			oHm:CREFORGN := self:fTotal
			oHm:aMirror[Len(oHm:aMirror),3]:= self:fTotal
			oHm:skip(-1)
			self:fTotal := 0
		ENDIF
	ELSEIF self:fTotal < 0
		IF !TeleBanking .and.!lDebAmount
		// Teveel toegewezen:
			self:CurDebAmnt := self:mDebAmnt - self:fTotal
			self:mDebAmnt := self:CurDebAmnt
			if self:DebCurrency == sCurr
				self:mDebAmntF:=self:mDebAmnt
			else
				self:mDebAmntF:=Round( self:oCurr:GetROE(self:DebCurrency,self:mDAT)*self:mDebAmnt,DecAantal)
			endif
			self:fTotal := 0
			oHm:GetCategory()
		ENDIF
	ELSE   &&Total = 0
		IF oHm:lastrec>0
			self:oCCOKButton:SetFocus()
		ENDIF
	ENDIF
	oDCDebitCreditText:Caption := Str(self:fTotal)
	self:oDCmDebAmntF:Value:=self:mDebAmntF
RETURN true
METHOD ValidateTempGift(lNoMessage:=false as logic) as logic CLASS PaymentJournal
	* lNoMessage: True: Do not show error message
	LOCAL lValid := TRUE AS LOGIC
	LOCAL cError AS STRING
	LOCAL oHm as TempGift
	LOCAL i:=0 AS INT
	LOCAL oWarn AS WarningBox
	// Default(@lNoMessage,FALSE)
	oHm := SELF:Server

	DO WHILE lValid
		++i
		if !oHm:aMirror[i,3] == 0 
			IF ADMIN=="WO" .or. ADMIN=="HO"
				IF oHm:aMirror[i,5] = "M" //category, Cre
					IF Empty(AScanExact({'AG','CH','OT','PF','MG'},oHm:aMirror[i,4])) //GC
						lValid := FALSE
						cError := self:oLan:WGet("Assessment codes are")+": AG CH PF MG"
						EXIT
					ELSEIF oHm:aMirror[i,4] = 'MG' //GC
						IF !SELF:lMemberGiver
							lValid := FALSE
							cError := self:oLan:WGet('Donor no member, thus MG not allowed')
							EXIT
						ENDIF
					elseif oHm:aMirror[i,15]='I'
						if !self:lMemberGiver .and.   oHm:aMirror[i,4] = 'CH'
							cError:=self:oLan:WGet('CH not allowed for income account')
							lValid := FALSE
							exit
						elseif oHm:aMirror[i,4] = 'PF' 
							cError:=self:oLan:WGet('PF not allowed for income account')
							lValid := FALSE
							exit
						endif
					ENDIF
				ELSE
					if oHm:aMirror[i,5] = "K"   // member department account, not income
						if oHm:aMirror[i,15]='E' .and. !oHm:aMirror[i,4] =='CH'
							lValid := FALSE
							cError := self:oLan:WGet("Only assessment code CH allowed for expense account")
							exit
						elseif oHm:aMirror[i,15]='F' .and. !oHm:aMirror[i,4] == 'PF'
							lValid := FALSE
							cError := self:oLan:WGet("Only assessment code PF allowed for fund account")
							exit
						endif
					elseIF !Empty(oHm:aMirror[i,4]) //GC, Cre 
						lValid := FALSE
						cError := self:oLan:WGet("Assessment code exclusively for member")
						exit
					endif
				ENDIF
			ENDIF
			IF Empty(oHm:aMirror[i,7]) //accid,cre
				lValid := FALSE
				cError := self:oLan:WGet("Account obliged")+"!"
			ELSEIF Empty(oHm:aMirror[i,14]) //description,cre
				lValid := FALSE
				cError := self:oLan:WGet("Description obliged")+"!"
			ELSEIF .not.Empty(self:mPerson).and.!Empty(oHm:aMirror[i,7])   &&accid
				IF Empty(oHm:aMirror[i,5])                                 && category
					oWarn:= WarningBox{self:owner,self:oLan:WGet("Input OF payments/gifts"),;
						self:oLan:WGet('Do you really want to use this account not intended for gifts')+'?'}
					oWarn:Type := BUTTONYESNO
					IF oWarn:show() == BOXREPLYNO
						lValid := FALSE
						cError := self:oLan:WGet("Choose other Account")
					ENDIF
				ENDIF
			ENDIF
		endif
		IF i>= Len(oHm:aMirror)
			EXIT
		ENDIF
	ENDDO

	IF ! lValid.and.!lNomessage
		//oHm:Recno:=i
		(ErrorBox{,cError}):Show()
		SELF:oSFPaymentDetails:Browser:REFresh()
		*	oHm:oBrowse:SetFocus()
	ENDIF

	RETURN lValid
METHOD ValStore(lNil:=nil as logic) as logic CLASS PaymentJournal
	* Validate transaction and store it
	LOCAL cTransnr, m54_pers_sta:="N" as STRING
	LOCAL oBox as WarningBox
	LOCAL oHm:= self:server as TempGift
	LOCAL oDet:=self:oSFPaymentDetails as PaymentDetails
	LOCAL lError, recordfound as LOGIC
	local cError as string
	LOCAL curPntr:=1, i,nSeqnbr as int
	LOCAL fCreTot as FLOAT
	LOCAL oXMLDocAcc,oXMLDocPrs as XMLDocument 
	local ChildName, cValue, cExtra,cCod as string 
	local cAccs as string   // accounts used in transaction 
	local BDAT,dlg as date
	local oSel,oPers,oSub,oAcc,oMBal as SQLSelect
	local oStmnt as SQLStatement 	
	

	IF !oHm:EOF
		curPntr := oHm:Recno
	ENDIF 
	AEval(oHm:Amirror,{|x| fCreTot += x[3]})
	fCreTot:=Round(fCreTot,DecAantal)
	IF !self:fTotal == 0
		(errorbox{self:owner,self:oLan:WGet("Sum of transactions not equal zero")}):show()
		lError := true
	ELSEIF oHm:reccount < 1 .or. fCreTot = 0
		(errorbox{self:owner,self:oLan:WGet("Transactions not complete")}):show()
		lError := true
	ELSE
		IF Empty(self:DebAccId)
			(errorbox{self:owner,self:oLan:WGet("Debit Account is obliged")}):show()
			self:oDCDebitAccount:SetFocus()
			RETURN FALSE
		ELSEIF 	!self:ValidateTempGift()
			curPntr := oHm:Recno
			lError := true
		ELSE
			if sepaenabled .and. !IsSEPA(self:oTmt:m56_contra_bankaccnt)
				ErrorBox{self:owner, self:oTmt:m56_contra_bankaccnt+': '+self:oLan:WGet("not a sepa bank account; convert it via https://www.ibanbicservice.nl/SingleRequest.aspx")+CRLF+; 
				" or http://www.iban-rechner.de/iban_berechnen_bic.html"+CRLF;
				+self:oLan:wget("and add it to this giver before entering this gift")}:show()
				return false
			endif
			* Check giver:
			IF !Recognised
				m54_pers_sta:=oHm:m54w_rek_pers()
				IF Val(self:mCLNGiver)=0
					IF m54_pers_sta='V'
						(ErrorBox{self:owner,self:oLan:wget('Specify a person as payer')}):show()
						self:oDCmPerson:SetFocus()
						RETURN FALSE
					ELSEIF m54_pers_sta=='W'
						oBox := Warningbox{self:owner, self:oLan:WGet("Input of Payments/Gifts"), ;
							self:oLan:wget("Don't you need to specify a giver/payer")+'?'}
						oBox:Type := BUTTONYESNO
						IF (oBox:Show() = BOXREPLYYES)
							self:oDCmperson:SetFocus()
							RETURN FALSE
						ENDIF
					ENDIF
				ELSE
					IF m54_pers_sta='N'
						(errorbox{self:owner,self:oLan:WGet('No person allowed in this case')}):show()
						self:oDCmperson:SetFocus()
						RETURN FALSE
					ELSEIF m54_pers_sta=='O'
						oBox := WarningBox{self:owner, self:oLan:wget("Input of Payments/Gifts"),self:oLan:wget('Payer really a person')+'?'}
						oBox:Type := BUTTONYESNO
						IF (oBox:Show() = BOXREPLYNO)
							self:oDCmperson:SetFocus()
							RETURN FALSE
						ENDIF
					ENDIF
				ENDIF
			ENDIF
			oHm:SuspendNotification()	
			* add transaction:
			oHm:ClearFilter()
			oHm:SetFilter({||!Empty(oHm:Cre)},"!Empty(Cre)") //skip non-assigned rows
			oHm:gotop()
			//	determine accounts to be locked for change balance
			cAccs:=Implode(oHm:Amirror,",",,,1)
			//	add income records:
			if	(!Empty(SINCHOME) .or.!Empty(SINC)) .and.!Empty(self:mCLNGiver)
				if	AScan(oHm:Amirror,{|x|x[4]='AG' .and.x[13]=liability})>0
					IF	!Empty(SINC)
						cAccs+=','+SEXP+','+ SINC
					endif	 			
					IF	!Empty(SINCHOME)
						cAccs+=','+SINCHOME+','+SEXPHOME
					endif	
				endif
			endif
     		self:Pointer := Pointer{POINTERHOURGLASS}

			SQLStatement{"start transaction",oConn}:Execute()
			nSeqnbr:=1 
			//	lock mbalance records:
			oMBal:=SQLSelect{"select mbalid from mbalance where accid in ("+cAccs+")"+;
				" and	year="+Str(Year(self:mDAT),-1)+;
				" and	Month="+Str(Month(self:mDAT),-1)+" order by mbalid for	update",oConn}
			if	!Empty(oMBal:status)
				self:Pointer := Pointer{POINTERARROW}
				ErrorBox{self,self:oLan:wget("balance records locked by someone else, thus	skipped")}:show()
				SQLStatement{"rollback",oConn}:Execute()
				return true
			endif	  
			if self:lEarmarking
				// check if current non-earmarked transaction still not yet assigned
				oSel:=SQLSelect{"select bfm,userid from transaction where transid="+Str(self:nEarmarkTrans,-1)+" and seqnr="+Str(self:nEarmarkSeqnr,-1)+" order by transid,seqnr for update",oConn}
				if oSel:reccount>0
					if !oSel:bfm=="O"
						self:Pointer := Pointer{POINTERARROW}
						ErrorBox{self:owner,self:oLan:wget("current non-earmarked gift allready assigned by")+Space(1)+oSel:userid}:show()
						SQLStatement{"rollback",oConn}:Execute()
						return false
					endif
				else 
					self:Pointer := Pointer{POINTERARROW}
					ErrorBox{self:owner,self:oLan:wget("current non-earmarked gift allready assigned by someone else")}:show() 
					SQLStatement{"rollback",oConn}:Execute()
					return false
				endif
			endif
			* book contra DebitAccount:
			cTransnr:='' 
			oStmnt:=SQLStatement{"insert into transaction set "+;
				"dat='"+SQLdate(self:mDAT)+"'"+;
				",docid='"+self:oDCmBST:Value+"'"+;
				",description='"+AddSlashes(AllTrim(oHm:DESCRIPTN)+iif(Empty(self:odccGirotelText:TextValue),'',' ('+AllTrim(self:odccGirotelText:TextValue)+')')) +"'"+;
				",accid="+self:DebAccId+;
				",deb="+Str(self:mDebAmnt,-1)+;
				",debforgn="+Str(self:mDebAmntF,-1)+;
				",currency='"+self:DebCurrency+"'"+;
				",userid='"+AddSlashes(LOGON_EMP_ID)+"'"+; 
			",seqnr="+Str(nSeqnbr,-1)+;
				iif(self:lMemberGiver.and.!Empty(Val(self:DebCln)),",gc='CH'",iif(self:lEarmarking,",bfm='T'","")),oConn} // member giver from member account
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows>0
				cTransnr:=ConS(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1))
				self:Owner:STATUSMESSAGE( "Recording transaction "+cTransnr)
				if ChgBalance(self:DebAccId,self:mDAT,self:mDebAmnt,0,self:mDebAmntF,0,self:DebCurrency)
					DO	WHILE	! oHm:EOF 
						nSeqnbr++ 
						oStmnt:=SQLStatement{"insert into transaction set "+;
							"transid="+cTransnr+;
							",seqnr="+Str(nSeqnbr,-1)+;
							",persid='"+Str(Val(self:mCLNGiver),-1)+"'"+;
							",dat='"+SQLdate(self:mDAT)+"'"+;
							",docid='"+self:oDCmBST:Value+"'"+;
							",reference='"+AddSlashes(AllTrim(oHm:REFERENCE))+"'"+;
							",description='"+AddSlashes( AllTrim(oHm:DESCRIPTN)) +"'"+;
							",accid='"+oHm:AccID+"'"+;
							",cre='"+Str(oHm:Cre,-1)+"'"+; 
						",creforgn='"+ Str(oHm:CREFORGN,-1)+"'"+; 
						",currency='"+ oHm:CURRENCY+"'"+;
							",userid='"+AddSlashes(LOGON_EMP_ID)+"'"+;
							iif(SPROJ ==AllTrim(oHm:AccID).and.!Empty(self:mCLNGiver).and.oHm:Cre>0,",bfm='O'","")+;
							",gc='"+oHm:GC+"'",oConn} 
						oStmnt:Execute()
						if	oStmnt:NumSuccessfulRows>0
							if ChgBalance(oHm:AccID,self:mDAT,0,oHm:Cre,0,oHm:CREFORGN,oHm:Currency)
								if !oHm:Cre==0 .and. (self:DebCategory==liability .or. self:DebCategory==asset)
// 									if !AddToIncome(oHm:GC,false,oHm:AccID,oHm:cre,oHm:DEB,oHm:DEBFORGN,oHm:CREFORGN,oHm:Currency,oHm:DESCRIPTN,oHm:Amirror[oHm:Recno,13], self:mCLNGiver,self:mDAT,self:oDCmBST:TextValue,cTransnr,@nSeqnbr,0)
									if !self:oAddInEx:AddToIncomeExp(oHm:GC,false,oHm:AccID,oHm:Cre,oHm:DEB,oHm:DEBFORGN,oHm:CREFORGN,oHm:CURRENCY,oHm:DESCRIPTN,oHm:Amirror[oHm:Recno,13], self:mCLNGiver,self:mDAT,self:oDCmBST:TextValue,cTransnr,@nSeqnbr,0)
										lError:=true
										exit
									endif
								endif 
							else
								lError:=true
								exit
							endif
						else
							lError:=true
							LogEvent(self,"error:"+oStmnt:ErrInfo:Errormessage+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
							exit
						endif
						oHm:skip()
					ENDDO
					if self:lEarmarking
						oStmnt:=SQLStatement{"update transaction set bfm='T',userid='"+AddSlashes(LOGON_EMP_ID)+"' where transid="+Str(self:nEarmarkTrans,-1)+" and accid="+SPROJ,oConn}
						oStmnt:Execute()
						if !Empty(oStmnt:status)
							lError:=true
							LogEvent(self,"error:"+oStmnt:ErrInfo:Errormessage+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
						endif
					endif
				else
					lError:=true
				endif
			else
				lError:=true
			endif
			if !lError
				IF !Empty(self:mCLNGiver)
					FOR i=1 to Len(oHm:Amirror)
						IF	!Empty(oHm:Amirror[i,12]) 
							**	update due amount
							oStmnt:=	SQLStatement{"update	dueamount set amountrecvd=round(amountrecvd+"+Str(oHm:Amirror[i,3],-1)+",2) "+;
								"where dueid="+oHm:Amirror[i,12],oConn}
							oStmnt:Execute() 
							if	!empty(oStmnt:Status)
								lError:=true
								LogEvent(self,"error:"+oStmnt:ErrInfo:Errormessage+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
								exit
							endif
						ENDIF
					next
				endif
			endif
			self:Pointer := Pointer{POINTERARROW}
			if lError
				SQLStatement{"rollback",oConn}:Execute()
				ErrorBox{self,"transaction could not be stored:"+AllTrim(oStmnt:ErrInfo:Errormessage)}:show()
				self:mCLNGiver:=''
// 				Break
				return false
			else
				SQLStatement{"commit",oConn}:execute()
			endif
			self:ShowDebBal()
			IF !Empty(self:mCLNGiver)
				oPers:=SQLSelect{"select mailingcodes,propextr,cast(creationdate as date) as creationdate,cast(datelastgift as date) as datelastgift from person where persid="+self:mCLNGiver,oConn}
				if oPers:reccount>0
					cCod:=oPers:mailingcodes
					cExtra:=oPers:PROPEXTR 
					BDAT:=iif(Empty(oPers:creationdate),null_date,oPers:creationdate) 
					dlg:=iif(Empty(oPers:datelastgift),null_date,oPers:datelastgift)
				else
					cCod:=''
					cExtra:=''
					BDAT:=null_date
					dlg:=null_date
				endif
				FOR i=1 to Len(oHm:Amirror)
					IF oHm:aMirror[i,3]<=0.or.Empty(oHm:aMirror[i,5]) //cre, category
						loop
					ENDIF
					IF oHm:Amirror[1,5]="G".or.oHm:Amirror[1,5]="M" // gift to a project/fund/member     //category
						* Update Mailing code in Person :
						oAcc:=SQLSelect{"select clc,propxtra from account where accid="+oHm:Amirror[i,7],oConn}
						IF oAcc:reccount>0
							if !Empty(oAcc:CLC)
								ADDMLCodes(oAcc:CLC,@cCod)
							endif
							// idem for extra properties for new persons:
							IF !Empty(oAcc:PROPXTRA) .and. BDAT=Today()
								IF Empty(cExtra) .or. cExtra="<velden></velden>"
									cExtra:=oAcc:PROPXTRA
								else
									oXMLDocAcc:=XMLDocument{oAcc:PROPXTRA}
									oXMLDocPrs:=XMLDocument{cExtra} 
									IF oXMLDocAcc:GetElement("velden")
										recordfound:=oXMLDocAcc:GetFirstChild()
										do while recordfound
											ChildName:=oXMLDocAcc:ChildName
											cValue:=oXMLDocAcc:ChildContent
											IF oXMLDocPrs:GetElement(ChildName)
												IF Empty(oXMLDocPrs:GetContentCurrentElement())
													oXMLDocPrs:UpdateContentCurrentElement(cValue)
												endif
											else
												oXMLDocPrs:AddElement(ChildName,cValue,"velden")
											endif
											recordfound:=oXMLDocAcc:GetNextChild()			
										ENDDO
										cExtra:= oXMLDocPrs:GetBuffer()
									endif	
								endif																		
							endif
						endif  
					endif
					// 					IF !Empty(oHm:aMirror[i,12]) 
					// 						** update due amount
					// 						oStmnt:= SQLStatement{"update dueamount set amountrecvd=round(amountrecvd+"+Str(oHm:Amirror[i,3],-1)+",2) "+;
					// 							"where dueid="+oHm:Amirror[i,12],oConn}
					// 						oStmnt:execute()
					// 					ENDIF
				NEXT
				*  Update person info of giver:
				i:= AScan(oHm:Amirror,{|x| x[3]>0.and.(x[5]=="G" .or.x[5]=="M" .or.x[5]=="D")})
				IF i>0
					DO WHILE i>0
						// 						PersonGiftdata(AllTrim(oHm:aMirror[i,7]),oHm:aMirror[i,5],@cCod,dlg,self:lEarmarking,oHm:aMirror[i,4], self:DefMlcd,self:DefOvrd)
						PersonGiftdata(AllTrim(oHm:aMirror[i,5]),@cCod,dlg,oHm:aMirror[i,4], self:DefMlcd,self:DefOvrd)
						i:= AScan(oHm:AMirror,{|x| x[3]>0.and.(x[5]=="G" .or.x[5]=="M" .or.x[5]=="D")},i+1)
					ENDDO
					oStmnt:=SQLStatement{"update person set "+iif(dlg < self:mDAT,"datelastgift='"+SQLdate(self:mDAT)+"',","")+"mailingcodes='"+cCod+"',propextr='"+AddSlashes(cExtra)+"'"+;
						" where persid="+Str(Val(self:mCLNGiver),-1),oConn}
					oStmnt:execute()
				ENDIF
				IF self:lTeleBank
					* save bankaccntnbr:
					IF !Recognised
						oStmnt:=SQLStatement{"insert into personbank set persid="+self:mCLNGiver+",banknumber='"+self:oTmt:m56_contra_bankaccnt+"'",oConn}
						oStmnt:Execute()
					ELSE
						oStmnt:=SQLStatement{"update personbank set persid="+self:mCLNGiver+" where banknumber='"+self:oTmt:m56_contra_bankaccnt+"'",oConn}
					ENDIF
				ENDIF
				// After all updates update regular gifts:
				FOR i=1 to Len(oHm:Amirror)
					IF oHm:Amirror[i,3]<=0 .or.Empty(oHm:Amirror[i,5]) .or. ;  //cre, category
						!Empty(oHm:Amirror[i,12]) ;   //due amount
						.or.AutoRec .or.AllTrim(oHm:Amirror[i,7])==SPROJ // category = G or M//accid
						loop
					ENDIF
					* Update regular gifts:
					* Check if already present within Subscription: 
					oSub:=SQLSelect{"select amount,reference,subscribid from subscription where personid="+self:mCLNGiver+" and accid="+oHm:Amirror[i,7],oConn}
					IF oSub:reccount>0
						if !oSub:amount==oHm:Amirror[i,3].or.!oSub:REFERENCE==AllTrim(oHm:REFERENCE)
							* update regular gift:
							IF (Admin=="WO" .or. Admin=="GI") .and. Empty(self:DefBest)
								oHm:Goto(oHm:Amirror[i,6])
								if TextBox{self:owner, "Input of Payments", ;
										"Apply "+Str(oHm:Amirror[i,3],-1)+;
										" to standard gift pattern for "+AllTrim(oHm:AccDesc),BUTTONYESNO+BOXICONQUESTIONMARK}:show()=BOXREPLYYES 
									oStmnt:=SQLStatement{"update subscription set amount="+Str(oHm:Amirror[i,3],-1)+", reference='"+AddSlashes(AllTrim(oHm:REFERENCE))+"'"+;
										",lstchange='"+SQLdate(self:mDAT)+"' where subscribid="+Str(oSub:Subscribid,-1),oConn}
									oStmnt:Execute()
								ENDIF
							ENDIF
						ENDIF
					ELSE
						* Add new regular gift:
						IF (Admin=="WO" .or. Admin=="GI") .and. Empty(DefBest)
							oHm:Goto(oHm:Amirror[i,6])
							if TextBox{self:owner, "Input of Payments", ;
									"Add "+Str(oHm:Amirror[i,3],-1)+;
									" as standard gift pattern for "+AllTrim(oHm:AccDesc),BUTTONYESNO+BOXICONQUESTIONMARK}:show()==BOXREPLYYES 
								oStmnt:=SQLStatement{"insert into subscription set personid="+self:mCLNGiver+",accid="+oHm:Amirror[i,7]+;
									",lstchange='"+SQLdate(self:mDAT)+"',amount="+Str(oHm:Amirror[i,3],-1)+", reference='"+AddSlashes(AllTrim(oHm:REFERENCE))+"'"+;
									",category='G',begindate='"+SQLdate(self:mDAT)+"',gc='"+oHm:Amirror[i,4]+"'",oConn}
								oStmnt:Execute()
							ENDIF
						ENDIF
					ENDIF
				next
			ENDIF
			oHm:ClearFilter()
			self:ReSet() 
			oHm:=self:server
			oHm:ResetNotification()	
			self:oDCmTRANSAKTNR:TextValue := AllTrim(cTransnr)
			self:mDebAmntF := 0
			self:mDebAmnt:=0
			self:fTotal := 0
			self:AutoRec := FALSE
			self:m51_agift:= 0
			self:m51_apost := 0
// 		ELSE
// 			lError := true
		ENDIF
	ENDIF
	self:mCLNGiver:=''
	IF lError
		oHm:Recno := curPntr
		oDet:Browser:Refresh()
		RETURN FALSE
	ELSE 
			self:mCLNGiver:=""
		if !self:lTeleBank
// 			self:mCLNGiver:=""
			self:cGiverName:=""
			self:oDCmPerson:Value:=""
			self:oDCmDebAmntF:TEXTValue:=""
			self:mDebAmntF:=""
			self:odccGirotelText:TextValue:=" " 
			if countrycode='33'
				self:oDCmDat:SetFocus()
			else
				self:oDCmPerson:SetFocus()
			endif
			oDet:Browser:Refresh()
		endif
	ENDIF
	
	RETURN true
	

	
FUNCTION PersonGiftdata(cType as string,cCod ref string,dlg:=null_date as date,cAssmnt as string,DefMlcd:="" as string, DefOvrd:=false as logic,AccMlCod:="" as string) as void pascal
* Update mailing codes cCod of a person because of receiving a gift or donation
* cType: Type of received amount
* DefMlcd: mailcodes for first giver via current bank account
* DefOvrd: override system defaults for first giver mailcodes with DefMlcd
* AccMlCod: mailing codes of receiving account which should be assigned to giver
*
//Returns in reference field new value of the string with codes  
IF (cType=="G".or.cType=="M").and.!cAssmnt=="MG"
	IF Empty(dlg)
		if	!Empty(SFGC) .and.!DefOvrd 
			ADDMLCodes(SFGC,@cCod)
		endif
		If !Empty(DefMlcd)
			ADDMLCodes(DefMlcd,@cCod)
		endif
	endif  && not first gift?
	* Add FI:
	ADDMLCodes('FI',@cCod)
elseIF  cAssmnt=="MG".or.cType=="D"
	* In case of membergift and donation always mark as Financial giver:
	ADDMLCodes('FI',@cCod)
ENDIF
if !Empty(AccMlCod)
	// add codes of receiving account:
	ADDMLCodes(AccMlCod,@cCod)	
endif
RETURN 
function SQLIncExpFd() as string
// compose sql code for determining type of account of member department: of department d, account a:
	return "upper(if(d.netasset=a.accid,'F',if(d.incomeacc=a.accid,'I',if(d.expenseacc=a.accid,'E',''))))"
	
METHOD CheckUpdates() CLASS TempGift
RETURN TRUE
METHOD GetCategory(cType:='' as string,cExtraText:='' as string) as void pascal CLASS TempGift
	*	cType:	F: Open post
	*			G: Standard Gift
	*	cExtratext: text to be added to description of a gift(optional)
	*
	local oAcct as SQLSelect
	IF Empty(self:AccID).and.Empty(self:ACCNUMBER)
		return
	endif

	oAcct:=SQLSelect{"select a.accid, a.accnumber,a.description,a.currency,a.multcurr,b.category,m.persid,"+SQLIncExpFd()+" as incexpfd,"+SQLAccType()+" as accounttype "+;
	"from account a left join department d on (d.depid=a.department) left join member m on (a.accid=m.accid or m.depid=a.department),balanceitem b "+;
	"where a.balitemid=b.balitemid and "+iif(Empty(self:AccID),"a.accnumber='"+AllTrim(self:accnumber)+"'","a.accid="+self:AccID),oConn}
	oAcct:Execute()
	if oAcct:Reccount>0
		self:ACCNUMBER:=AllTrim(oAcct:ACCNUMBER)
		self:accid:=str(oAcct:accid,-1)
		self:ACCDESC:=oAcct:Description
		self:KIND:=oAcct:accounttype 
		self:CURRENCY:=oAcct:CURRENCY 
		self:incexpfd:=oAcct:incexpfd
// 		self:Multiple:=iif(oAcct:Multcurr=1,true,false)
		IF Empty(self:DESCRIPTN).or.AScan(PaymentDescription,AllTrim(self:DESCRIPTN))>0
			IF self:KIND = "D" 
				self:DESCRIPTN := oLan:RGet("Donation",,"!")
			ELSEIF self:KIND = "A".or.cType=="A"
				self:DESCRIPTN := oLan:RGet("Subscription",,"!")
			ELSEIF self:KIND = "F" .or.cType=="F"
				self:DESCRIPTN := oLan:RGet("Invoice",,"!")
			ELSEIF self:KIND = "G".or.self:KIND = "M" .or.cType=="G"
				self:DESCRIPTN := oLan:RGet("Gift",,"!")
				self:persid:=iif(Empty(oAcct:persid),0,oAcct:persid)
			ELSE
				self:DESCRIPTN := ""
			ENDIF
		ENDIF
		if !Empty(cExtraText)
			self:DESCRIPTN +="; "+AllTrim(cExtraText)
		endif
		//aMirror: {accid,orig,cre,gc,category,recno,accid,accnumber,creforgn,currency,multcur,dueid,acctype,description,incexpfd}
		//            1    2    3   4    5      6      7      8        9        10      11      12      13      14            15

		self:aMirror[self:RECNO]:=;
				{self:accnumber,self:Original,self:Cre,self:GC,self:KIND,self:Recno,self:AccID,self:accnumber,self:CREFORGN,self:CURRENCY,self:Multiple,0,oAcct:category,self:DESCRIPTN,self:INCEXPFD}   
				//        1            2          3        4          5         6          7           8             9            10             11     12       13           14              15
	ENDIF
	RETURN
METHOD m54w_rek_pers() CLASS TempGift
*Controleren of persoon is toegestaan
LOCAL m54_pers_sta:=' ' AS STRING
LOCAL i AS INT
IF Len(SELF:aMirror)=0
   RETURN ' '   && geen records, altijd goed
ENDIF
FOR i=1 TO Len(SELF:aMirror)
	IF !Empty(SELF:aMirror[i,3])  // Dummy line ignored: cre=0
		IF Empty(m54_pers_sta)
			m54_pers_sta:="O" //default Onwaarschijnlijk
		ENDIF
		IF SELF:aMirror[i,4]='AG'.or.SELF:aMirror[i,4]='MG'.or.SELF:aMirror[i,4]='OT'.or.SELF:aMirror[i,1]=sproj //gc
			IF Admin="WO".or.Admin="HO"
		     	m54_pers_sta:='V' && Verplicht
		   ELSE
	      	m54_pers_sta:='W'  //Waarschijnlijk
	      ENDIF
      	exit
   	ELSEIF self:Amirror[i,4]='PF' //gc
      	m54_pers_sta:='W'  //Waarschijnlijk
   	ELSEIF m54_pers_sta=='W'
      	* niks doen
   	ELSEIF self:Amirror[i,5]=='G' .or. self:Amirror[i,5]=='M'
        	m54_pers_sta:='W'  && Waarschijnlijk
		ELSE
   		IF self:Amirror[i,5]== 'D';
			.or. self:aMirror[i,5]= 'A'.or. self:aMirror[i,5] = 'F'     // category
        		m54_pers_sta:='W'  && Waarschijnlijk
        	ENDIF
  		ENDIF
  	ENDIF
NEXT
RETURN m54_pers_sta
METHOD CheckTeleAccount()   CLASS TempTrans
* check if current record is a telebanking account
	IF !Empty(aTeleAcc).and.!Empty(self:AccID)
	  	IF AScan(aTeleAcc,AllTrim(self:AccID))>0
	     	RETURN TRUE
	 	ENDIF
   ENDIF
RETURN FALSE
METHOD CheckUpdates(oTransH:=nil as SQLSelect) as string CLASS TempTrans
	* Check if it is allowed to update or delete a transaction (accid,DEB,CRE,GC)
	// otransH could be original transactions in case of update
	LOCAL ThisRec,mRecno:=self:RECNO as int,amMirror:=self:aMIRROR as array,mSeqnr as int
	local cError as string
	IF !self:lInqUpd  && no update?
		RETURN ""
	ENDIF
	IF self:EOF.or.Empty(self:SEQNR)  && apparently new transaction
		RETURN ""
	ENDIF
	IF self:BFM=="H"
		cError:= "Transaction already sent to PMC"
		(ErrorBox{,cError}):show()
		RETURN cError
	ENDIF
	// 	ThisRec:=AScan(amMirror,{|x|x[6]=mRecno})
	ThisRec:=mRecno
	if !Empty(aMirror) .and. ThisRec>0
		if !Empty(aMirror[ThisRec,7]) .and. !empty(oTransH) //seqnr
			mSeqnr:=aMIRROR[ThisRec,7]
			oTransH:GoTop()
			do while !oTransH:SEQNR==mSeqnr
				oTransH:Skip()
			enddo
			if !oTransH:EOF
				if empty(oTransH:debforgn) .and.empty(oTransH:creforgn) .and.(!empty(oTransH:deb) .or. !empty(oTransH:cre)) 
					cError:= 'Modification of reevaluation record not allowed'
					(ErrorBox{,cError}):show()
					RETURN cError
				endif
			endif
		else
			if Empty(aMIRROR[ThisRec,13]).and.Empty(aMIRROR[ThisRec,14]).and.(!Empty(aMIRROR[ThisRec,2]).or.!Empty(aMIRROR[ThisRec,3]))
				cError:= 'Modification of reevaluation record not allowed'
				(ErrorBox{,cError}):show()
				RETURN cError
			endif
		endif
	endif
	IF self:BFM=="C" 
		cError:= "Transaction already sent to AccPac/RIA"
		(ErrorBox{,cError}):show()
		RETURN cError
	ENDIF
	IF self:BFM=="T" 
		cError:= "Gift without destination already allotted"
		(ErrorBox{,cError}):show()
		RETURN cError
	ENDIF
	IF self:CheckTeleAccount() 
		cError:= 'Modification of telebanking account not allowed'
		(ErrorBox{,cError}):show()
		RETURN cError
	ENDIF 
	
	RETURN ""
METHOD m54w_rek_pers() CLASS TempTrans
*Controleren of persoon is toegestaan
LOCAL m54_pers_sta:=' ' AS STRING
LOCAL i as int
IF Len(SELF:aMirror)=0
   RETURN ' '   && geen records, altijd goed
ENDIF
FOR i=1 TO Len(SELF:aMirror)
	IF !SELF:aMirror[i,2]==SELF:aMirror[i,3]  // Dummy line ignored: deb=cre
		IF Empty(m54_pers_sta)
			m54_pers_sta:="O" //default onwaarschijnlijk
		ENDIF
		IF (SELF:aMirror[i,4]='AG'.or.SELF:aMirror[i,4]='MG'.or.SELF:aMirror[i,4]='OT') .and. (Admin="WO".or.Admin="HO") //gc
	     	m54_pers_sta:='V' && Verplicht
   		exit
		elseif self:aMirror[i,1]==SCRE .and. self:aMirror[i,3] - self:aMirror[i,2]>0  // payment to creditor
	     	m54_pers_sta:='C' && creditor Verplicht
	     	exit
   	ELSEIF self:aMirror[i,4]='PF' .and. (Admin="WO".or.Admin="HO") //gc
      	m54_pers_sta:='W'  //Waarschijnlijk
   	ELSEIF m54_pers_sta=='W'
      	* niks doen
   	ELSEIF self:aMirror[i,5]=='G' .or. self:aMirror[i,5]=='M'
        	IF self:aMirror[i,3] > self:aMirror[i,2] .or.self:aMirror[i,3]#0 //cre,deb,cre
           	m54_pers_sta:='W'  && Waarschijnlijk
        	ELSE
           	m54_pers_sta:='O'  && Onwaarschijnlijk
        	ENDIF
     	ELSE
	  		IF self:aMirror[i,5]== 'D';
			.or. self:aMirror[i,5]= 'A'.or. self:aMirror[i,5] = 'F'     // category
        		m54_pers_sta:='W'  && Waarschijnlijk
        	ENDIF
   	ENDIF
   ENDIF
NEXT
RETURN m54_pers_sta
METHOD RegAccount(omAcc,ItemName) CLASS TransactionMonth
	LOCAL oAccount as SQLSelect
	IF Empty(omAcc).or.omAcc==NULL_OBJECT
		RETURN
	ENDIF
	oAccount:=omAcc
	IF ItemName == "FromAccount"
*		SELF:nFromAccount :=  oAccount:accid
		SELF:nFromAccount :=  AllTrim(oAccount:ACCNUMBER)
		self:oDCFromAccount:TEXTValue := AllTrim(oAccount:Description)
		self:cFromAccName := AllTrim(oAccount:Description)
	ELSEIF ItemName == "ToAccount"
		self:oDCToAccount:TEXTValue := AllTrim(oAccount:Description)
*		SELF:nToAccount :=  oAccount:accid
		SELF:nToAccount :=  AllTrim(oAccount:ACCNUMBER)
		self:cToAccName := AllTrim(oAccount:Description)
	ENDIF
		
RETURN TRUE
METHOD FilePrint CLASS TransInquiry
	LOCAL koparr:={} as ARRAY
	LOCAL nRow as int, nPage as DWORD
	LOCAL i as int
	LOCAL oReport AS PrintDialog
	LOCAL m54_Deb, m54_cre AS FLOAT
	LOCAL oTrans:=self:Server as SQLSelect 
	local cTab:=CHR(9) as string
	local cColumns as string 
	local lXls:=true as logic
	LOCAL DecSep as DWORD

	oReport := PrintDialog{self,"Financial Records",,120,DMORIENT_LANDSCAPE,"xls"}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	IF Lower(oReport:Extension) #"xls"
		cTab:=Space(1)
		lXls:=false
		koparr :={self:oLan:RGet("Financial Records",,"!")}
		FOR i=1 to MLCount(self:m54_selectTxt,106)
			AAdd(koparr,MemoLine(self:m54_selectTxt,119))
		NEXT
	ENDIF

	cColumns:=self:oLan:RGet("DATE",10,"@!")+cTab+self:oLan:RGet("DOCUMENTID",10,"@!")+cTab+self:oLan:RGet("TRANSACT#",10,"@!")+cTab+;
		self:oLan:RGet("ACCOUNT#",12,"@!")+cTab+self:oLan:RGet("DESCRIPTION",40,"@!")+cTab+self:oLan:RGet("DEBIT",14,"@!","R")+cTab+self:oLan:RGet("CREDIT",14,"@!","R")+;
		cTab+self:oLan:RGet("ASS",3,"@!")+iif(lXls,Tab+self:oLan:RGet("Giver",,"@!"),"")+iif(lXls,Tab+self:oLan:RGet("GiverId",,"@!"),"")
	AAdd(koparr,cColumns)
	m54_deb:=0.00
	m54_cre:=0.00
	oTrans:SuspendNotification()
	oTrans:Gotop()
	DecSep:=SetDecimalSep(Asc(DecSeparator))
	DO WHILE !oTrans:EOF
		oReport:PrintLine(@nRow,@nPage,;
			DToC(oTrans:dat)+cTab+Pad(oTrans:docid,10)+cTab+Pad(Str(oTrans:TransId,-1),10)+cTab+Pad(oTrans:accnumber,12)+cTab+;
			iif(lXls,oTrans:description,PadR(oTrans:description,40))+cTab+Str(oTrans:deb,14,decaantal)+cTab+Str(oTrans:cre,14,decaantal);
			+cTab+oTrans:gc+iif(lXls,cTab+iif(Empty(oTrans:personname),'',oTrans:personname+cTab+Str(oTrans:persid,-1)),''),koparr,1)
		IF !lXls.and.!Empty(oTrans:personname)
			oReport:PrintLine(@nRow,@nPage,Space(10)+cTab+Space(10)+cTab+Space(10)+cTab+Space(12)+cTab+SubStr(oTrans:personname,1,40),koparr)
		ENDIF
		m54_deb:=m54_deb+oTrans:deb
		m54_cre:=m54_cre+oTrans:cre
		oTrans:skip()
	ENDDO
	if !lXls
		oReport:PrintLine(@nRow,@nPage,Space(10)+cTab+Space(10)+cTab+Space(10)+cTab+Space(12)+cTab+Space(40)+cTab+replicate('-',14)+cTab+replicate('-',14),koparr,2)
		oReport:PrintLine(@nRow,@nPage,Space(10)+cTab+Space(10)+cTab+Space(10)+cTab+Space(12)+cTab+self:oLan:RGet("Total",40,"!")+cTab;
			+Str(m54_Deb,14,DecAantal)+cTab+Str(m54_cre,14,DecAantal),koparr)
		oReport:PrintLine(@nRow,@nPage,;
			Pad(self:oLan:RGet('Balance',,"!")+cTab+self:oLan:RGet('transactions'),86)+;
			IF(m54_deb-m54_cre<0,Space(16)+Str(m54_cre-m54_deb,14,decaantal),;
			Str(m54_deb-m54_cre,15,decaantal)),koparr)
	endif
	SetDecimalSep(Asc('.'))

	oReport:prstart()
	oReport:prstop()
	oTrans:ResetNotification()

	RETURN
METHOD RegAccount(omAcc,ItemName) CLASS TransInquiry
	* Proces account to transfer to 
	
	IF Empty(omAcc).or.omAcc==null_object.or.omAcc:reccount<1
		RETURN
	ENDIF
	IF ItemName == "Account to transfer to"
		self:cTransferAcc :=  Str(omAcc:AccID,-1)
		self:cTransferAccName := omAcc:accnumber+' '+ AllTrim(omAcc:Description)
// 		self:cBal:=omAcc:balitemid
		self:cDep:=Str(omAcc:Department,-1)
		self:cSoort:=omAcc:Type
		SELF:Transfer()
	ENDIF
		
RETURN true                                            
METHOD ShowSelection() CLASS TransInquiry
	LOCAL oPsbw := self:Server as SQLSelect
	LOCAL lSuccess, lTransferShown as LOGIC
	LOCAL cFilter,cDepFilter, cRek as STRING 
	local aPost:={"Not","Ready","Yes"} as array 
	local aKeyw:={} as array
	local i as int
	local fSecStart as float 
	local oSel as SQLSelect
	self:PersIdSelected:=AllTrim(self:PersIdSelected)
	self:DocIdSelected:=AllTrim(self:DocIdSelected)
	IF oPsbw==null_object
		(ErrorBox{,"You have already closed the inquiry browser window"}):Show()
		self:EndWindow()
		self:Close()
		RETURN
	ENDIF
	self:Pointer := Pointer{POINTERHOURGLASS}

	self:m54_selectTxt:="" 
	self:cWhereSpec:="" 
// 	self:cOrder:="dat,accnumber,transid,seqnr"
	self:cOrder:="dat,transid,seqnr"

	cDepmntXtr:=""
	if !Empty(self:DepIdSelected)
		cDepmntXtr:=SetDepFilter(Val(self:DepIdSelected))
		if !Empty(cDepmntXtr)
			cFilter+=iif(Empty(cFilter),''," and")+"a.department in ("+cDepmntXtr+")" 
		endif
	endif
	self:oCCTransferButton:Hide()
	lTransferShown:=false
	IF !Empty(self:FromAccId) 
		if self:ToAccNbr==self:FromAccNbr
			cFilter:=iif(Empty(cFilter),'',cFilter+' and ')+'t.accid="'+AddSlashes(self:FromAccId)+'"'
			self:m54_selectTxt:="Account="+self:FromAccNbr
			IF Empty(self:StartDate).or.self:StartDate>=LstYearClosed
				IF !self:NoUpdate .and. AScan(self:aTeleAcc, Val(self:FromAccId))=0 
					self:oCCTransferButton:Show()
					lTransferShown:=true
				ENDIF
			ENDIF
		else
			// Add to filter 
			cFilter+=iif(Empty(cFilter),'',' and ')+"a.accnumber>='"+AddSlashes(self:FromAccNbr)+"' and a.accnumber<='"+AddSlashes(self:ToAccNbr)+"'"
			self:m54_selectTxt:="Account>="+self:FromAccNbr+" - "+self:ToAccNbr
		endif
// 	ELSEif Empty(self:DepIdSelected)
// 		self:oCCTransferButton:Hide()
	ENDIF
	IF AScan(aMenu,{|x| x[4]=="TransactionEdit"})=0
		self:oCCTransferButton:Hide() 
		lTransferShown:=false
	ENDIF

	IF !Empty(self:PersIdSelected)
		cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.persid="'+self:PersIdSelected+'"'
		self:m54_selectTxt:=self:m54_selectTxt+" Person="+self:PersIdSelected
	ENDIF
	IF !Empty(self:StartTransNbr)
		cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.transid>="'+self:StartTransNbr+'"'
		self:m54_selectTxt:=self:m54_selectTxt+" Transaction>="+self:StartTransNbr 
		self:cOrder:="transid desc,seqnr" 
	ENDIF
	IF !Empty(self:EndTransNbr)
		cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.transid<="'+self:EndTransNbr+'"'
		self:m54_selectTxt:=self:m54_selectTxt+" Transaction<="+self:EndTransNbr
		self:cOrder:="transid desc,seqnr" 
	ENDIF
	IF !Empty(self:DocIdSelected)
		cFilter:=if(Empty(cFilter),'',cFilter+' and ')+"t.docid like '"+self:DocIdSelected+"%'"
		self:m54_selectTxt:=self:m54_selectTxt+" Doc.id="+self:DocIdSelected
	ENDIF
	IF !Empty(self:ReferenceSelected)
		cFilter:=if(Empty(cFilter),'',cFilter+' and ')+"t.reference like '%"+AddSlashes(self:ReferenceSelected)+"%'"
		self:m54_selectTxt:=self:m54_selectTxt+" Reference="+self:ReferenceSelected
	ENDIF
	IF !Empty(self:DescrpSelected)
		aKeyw:=GetTokens(AllTrim(self:DescrpSelected))
		for i:=1 to Len(aKeyw)
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+"t.description like '%"+AddSlashes(aKeyw[i,1])+"%'"
		next
		self:m54_selectTxt:=self:m54_selectTxt+" Descr="+self:DescrpSelected
	ENDIF
	IF self:TransTypeSelected=="A" // all types
		IF !Empty(Val(self:StartAmount))
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'abs(t.cre-t.deb)>='+self:StartAmount
			self:m54_selectTxt:=self:m54_selectTxt+" Amount>="+self:StartAmount
		ENDIF
		IF !Empty(Val(self:ToAmount)) 
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'abs(t.cre-t.deb)<='+self:ToAmount
			self:m54_selectTxt:=self:m54_selectTxt+" Amount<="+self:ToAmount
		ENDIF
	ELSEIF self:TransTypeSelected=="D" // debit amounts
		self:m54_selectTxt:=self:m54_selectTxt+" Debit amount>="+self:StartAmount
		IF !Empty(Val(self:StartAmount))
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.deb>='+self:StartAmount
		ELSE
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.deb<>0.00'
		ENDIF
		IF !Empty(Val(self:ToAmount)) 
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.deb<='+self:ToAmount
			self:m54_selectTxt:=self:m54_selectTxt+" Debit amount<="+self:ToAmount
		ENDIF
	ELSEIF self:TransTypeSelected=="C" // credit amounts
		self:m54_selectTxt:=self:m54_selectTxt+" Credit amount>="+self:StartAmount
		IF !Empty(Val(self:StartAmount))
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.cre>='+self:StartAmount
		ELSE
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.cre<>0.00'
		ENDIF
		IF !Empty(Val(self:ToAmount)) 
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.cre<='+self:ToAmount
			self:m54_selectTxt:=self:m54_selectTxt+" Credit amount<="+self:ToAmount
		ENDIF
	ENDIF 
	IF !Empty(self:StartDate)
		cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.dat>="'+SQLdate(self:StartDate)+'"'
		self:m54_selectTxt:=self:m54_selectTxt+" Date>="+DToS(self:StartDate)
	ENDIF
	IF !Empty(self:EndDate)
		cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.dat<="'+SQLdate(self:EndDate)+'"'
		self:m54_selectTxt:=self:m54_selectTxt+" Date<="+DToS(self:EndDate)
	ENDIF

	self:oCCPostButton:Hide()
	self:oCCReadyButton:Hide() 
	if Posting
		if	!Empty(self:PostStatSelected)  .and. self:PostStatSelected<"4"
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'poststatus='+self:PostStatSelected
			self:m54_selectTxt:=self:m54_selectTxt+" Post	status="+aPost[Val(self:PostStatSelected)+1]
			IF	self:PostStatSelected="1"  .and. self:StartDate>=LstYearClosed.and. AScan(aMenu,{|x|x[4]=="PostingBatch"})>0 
				// Ready to post selected by financial manager:
				self:oCCPostButton:Show()
			ELSEif	self:PostStatSelected="0" .and.self:StartDate>=LstYearClosed.and. AScan(aMenu,{|x|x[4]=="TransactionEdit"})>0 
				// Not posted selected by financial operator:
				self:oCCReadyButton:Show()
			endif		
		endif
	endif
	self:oDCLstTxt1:Hide()
	self:oDCLstTxt2:Hide()
	self:oDCNbrTrans:Hide()
	self:oCCFindButton:Hide()
	self:lShowFind:=false 

	self:cWhereSpec:=cFilter
	self:cSelectStmnt:="select "+self:cFields+" from "+self:cFrom+" where "+self:cWhereBase+" and "+self:cWhereSpec  
	self:cSelectStmnt:=UnionTrans(self:cSelectStmnt) +" order by "+self:cOrder
	// test nbr lines to be retrieved:
	oSel:=SQLSelect{UnionTrans("select count(*) as qty from "+self:cFrom+" where "+self:cWhereBase+" and "+self:cWhereSpec),oConn}
	oSel:Execute()
	if ConI(oSel:qty)> 3000
		if TextBox{self,self:oLan:WGet("transaction inquiry"),self:oLan:WGet("Do you really want to retrieve")+Space(1)+ConS(ConI(oSel:qty))+Space(1)+self:oLan:WGet("transaction lines"),BUTTONYESNO+BOXICONQUESTIONMARK}:Show()==BOXREPLYNO
			return false
		endif
	endif
// 	self:oTrans:=SqlSelect{self:cSelectStmnt,oConn} 
	self:oTrans:SQLString:= self:cSelectStmnt 
// 	fSecStart:=Seconds() 
	self:Pointer := Pointer{POINTERHOURGLASS}
	self:oTrans:Execute()
	if !Empty(self:oTrans:Status)
		LogEvent(self,"Error:"+self:oTrans:ErrInfo:errormessage+"; statement:"+self:oTrans:SQLString,"LogErrors")
	endif
// 	LogEvent(self,Str(Seconds()-fSecStart,-1)+" sec for "+Str(self:oTrans:Reccount,-1)+" records with:"+self:oTrans:SQLString+CRLF+"explain:"+CRLF+GetExplain(self:oTrans:SQLString),"LogSql")
	self:GoTop()
	self:Pointer := Pointer{POINTERARROW}

	if self:oTrans:Reccount<1
		self:oSFTransInquiry_DETAIL:Browser:refresh()
	endif
	if	lTransferShown
		// check if there is no locked transaction:
		if SQLSelect{"select t.transid from "+cFrom+" where "+self:cWhereBase+" and "+self:cWhereSpec+" and t.lock_id=1 and t.lock_time < subdate(now(),interval 60 minute)",oConn}:Reccount>0
			self:oCCTransferButton:Hide() 
			lTransferShown:=false
		endif
	endif
	self:oSFTransInquiry_DETAIL:GoTop()
	self:Pointer := Pointer{POINTERARROW}
	self:oDCFound:TextValue :=Str(self:oTrans:Reccount,-1)


	RETURN true
function UnionTrans(cStatement as string) as string
	// combine select statemenst on transaction with unions on historic trnsaction tables
	* 
	* cStatement should be in terms of Transaction table as t  
	* date conditions should be specified as: t.dat>='yyy-mm-dd' or t.dat<='yyy-mm-dd' or t.dat='yyyy-mm-dd'
	*
	Local nDat1, nDat2,i as int
	Local BegDat, EndDat, Maxdat as date
	local cDat, cCompStmnt as String
	*/  

	// determine required dates in cStatement: 
	cStatement:=Lower(cStatement) 
	if At("transaction",cStatement)=0
		return cStatement
	endif
	// nWhere:=At("where",cStatement) 

	// if nWhere>0
	cDat:=GetDateFormat()
	SetDateFormat("YYYY-MM-DD")
	StrTran(StrTran(StrTran(cStatement,'t.dat <','t.dat<'),'t.dat >','t.dat>'),'t.dat =','t.dat=')    // remove spaces
	nDat1:=At3("t.dat=",cStatement,5)
	if nDat1>0
		BegDat:=CToD(SubStr(cStatement,nDat1+7,10))
		EndDat:=BegDat	
	else
		nDat1:=At3("t.dat>=",cStatement,5)
		if nDat1>0
			BegDat:=CToD(SubStr(cStatement,nDat1+8,10))
		endif	
		nDat2:=At3("t.dat<=",cStatement,5) 
		if nDat2>0 
			EndDat:=CToD(SubStr(cStatement,nDat2+8,10))	
		endif
	endif
	SetDateFormat(cDat)
	
	// endif	
	Maxdat:=Today()+60
	if Empty(EndDat)
		EndDat:=Maxdat
	endif

// 	if Empty(BegDat) .and. EndDat>=LstYearClosed .or.BegDat>=LstYearClosed    
	if BegDat>=LstYearClosed .or. Empty(GlBalYears)    
		return cStatement
	else
		// compose Statement: 
		// actual period:
		If (Empty(BegDat) .or. BegDat<=Maxdat).and.EndDat>=LstYearClosed
			cCompStmnt:="("+cStatement+")"
		endif
		if Empty(BegDat)
			BegDat:=GlBalYears[Len(GlBalYears),1] // oldest date
		endif
// 		FillBalYears()
		for i:=2 to Len(GlBalYears)
			if BegDat<GlBalYears[i-1,1].and.EndDat>=GlBalYears[i,1]
				cCompStmnt+=iif(Empty(cCompStmnt),""," union ")+"("+StrTran(cStatement,"transaction",GlBalYears[i,2])+")"               
			endif
		next
	endif 
	return cCompStmnt
	
function UnionTrans2(cStatement as string, BegDat:=null_date as date, EndDat:=null_date as date) as string
// combine select statemenst on transaction with unions on historic trnsaction tables
* 
* cStatement should be in terms of Transaction table as t  
*
Local i as int
Local Maxdat as date
local cCompStmnt as String

// determine required dates in cStatement: 
cStatement:=Lower(cStatement) 
if At("transaction",cStatement)=0
	return cStatement
endif


Maxdat:=Today()+60
if Empty(EndDat)
	EndDat:=Maxdat
endif

if Empty(BegDat) .and. EndDat>=LstYearClosed .or.BegDat>=LstYearClosed    
	return cStatement
else
	// compose Statement: 
	// actual period:
	If (Empty(BegDat) .or. BegDat<=Maxdat).and.EndDat>=LstYearClosed
		cCompStmnt:="("+cStatement+")"
	endif
	if Empty(BegDat)
		BegDat:=GlBalYears[Len(GlBalYears),1] // oldest date
	endif
	for i:=2 to Len(GlBalYears)
		if BegDat<GlBalYears[i-1,1].and.EndDat>=GlBalYears[i,1]
			cCompStmnt+=iif(Empty(cCompStmnt),""," union ")+"("+StrTran(cStatement,"transaction",GlBalYears[i,2])+")"               
		endif
	next
endif 
return cCompStmnt
 
