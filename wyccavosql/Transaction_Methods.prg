CLASS AccountStatements
	// Printing OF account statements per month
// 	EXPORT nFromAccount  AS STRING
// 	EXPORT cFromAccName AS STRING
// 	EXPORT nToAccount  AS STRING
// 	EXPORT cToAccName AS STRING
// 	*	EXPORT nFromYear  AS INT
// 	EXPORT cFromMonth AS INT
// 	EXPORT nToYear  AS INT
// 	EXPORT cToMonth AS INT
	EXPORT oBal as Balances
	EXPORT oTrans as SQLSelect

	EXPORT oReport AS PrintDialog
	PROTECT cFileTrans AS STRING
	EXPORT BeginReport:=FALSE as LOGIC
	export SkipInactive as logic
	EXPORT SendingMethod AS STRING
	PROTECT DescrWidth:=40 as int 
	protect m58_debF, m58_creF, mnd_debF, mnd_creF,m57_giftbedF as float 
	Protect lForgnC as logic // foreign currency account?
	export lMinimalInfo as logic  // minimal balance info
	Protect BoldOn, BoldOff, YellowOn, YellowOff, GreenOn, GreenOff, RedOn,RedOff,RedCharOn,RedCharOff as STRING
	protect cTab:=' ' as string
	protect cAccCurrency, CurAcc as string  

	declare method MonthPrint,slot_mnd
METHOD Init(DescrpWidth, MinimalInfo) CLASS AccountStatements
	Default(@DescrpWidth,40)
	Default(@MinimalInfo,true)
	self:lMinimalInfo:=MinimalInfo
	self:DescrWidth:=DescrpWidth
	self:oBal:=Balances{}
	RETURN SELF
METHOD MonthPrint(nFromAcc as string,nToAcc as,nFromYear as int,nFromMonth as int,nToYear as int,nToMonth as int,nRow ref int,nPage ref int,addheading:="" as string, oLan as Language) as logic CLASS AccountStatements
	LOCAL Heading:={} as ARRAY
	LOCAL nCurMonth, nMonthStart, nMonthEnd, nThisMonth as int
	LOCAL m58_rek, me_oms, me_AccNbr, me_type,cDesc, cOms as STRING
	LOCAL m57_giftbed, m58_deb, m58_cre, mnd_deb, mnd_cre as FLOAT
	LOCAL mnd_cur,  jr_cur,  VorigJaar, VorigMnd,nMem as int
	LOCAL startdate,enddate as date
	LOCAL beginreport:=FALSE, lXls as LOGIC
	LOCAL skipaant:=4 as int
	local cStatement as string
	// LOCAL BoldOn, BoldOff,RedON,RedOff as STRING 
	local BalDeb:=0.00, BalCre:=0.00 as float
	local nBeginmember as int  // position of start account statement in aFifo of a current account 
	local lTransFound as logic // is account active?
	IF self:SendingMethod="SeperateFile"
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
		endif
	ENDIF
	self:cAccCurrency:=""
	self:CurAcc:=""
	startdate:=SToD(Str(nFromYear,4)+StrZero(nFromMonth,2)+"01")
	enddate:=SToD(Str(nToYear,4)+StrZero(nToMonth,2)+StrZero(MonthEnd(nToMonth,nToYear),2))
	cStatement:=UnionTrans("select a.accnumber,a.accid,a.description as accname,a.currency as acccurrency,b.category as acctype,"+;
	"t.persid,t.description,t.docid,t.dat,t.deb,t.cre,t.debforgn,t.creforgn,t.gc,t.fromrpp,t.TransId "+;
	"from balanceitem b, account a "+;
	"left join transaction t on (a.accid=t.accid and t.dat>='"+SQLdate(startdate)+"' and t.dat<='"+SQLdate(enddate)+"') where a.balitemid=b.balitemid and "+;
	iif(nToAcc==nFromAcc,"a.accnumber='"+nFromAcc+"'","a.accnumber<='"+nToAcc+"' and a.accnumber>='"+nFromAcc+"'"))+;
	" order by accnumber,dat" 
	self:oTrans:=SQLSelect{cStatement,oConn}
	nMonthEnd:=nToYear*12+nToMonth-1
	nMonthStart:=nFromYear*12+nFromMonth-1
	IF self:oTrans:RecCount<1
		return true
	endif
	do WHILE true
		IF oTrans:EOF .or. !self:oTrans:ACCNUMBER==self:CurAcc
			IF !Empty(self:CurAcc)
				// process previous account:
				IF .not.Empty(mnd_cur)
					self:slot_mnd(Heading,oBal,Round(m57_giftbed,DecAantal),@nRow,@nPage,oLan,mnd_cur,mnd_deb,mnd_cre,m58_rek,me_type,jr_cur,oReport)
				endif
				skipaant:=4
				IF Val(Str(m58_deb))<>0 .and.Val(Str(m58_cre))<>0
					skipaant++
				endif
				self:oBal:GetBalance(m58_rek,,EndOfMonth(Today()+31),self:cAccCurrency)
				IF lForgnC
					BalDeb:=self:oBal:Per_DebF
					BalCre:=self:oBal:Per_CreF	
				endif
     			oReport:beginreport:=self:beginreport

				// 			self:oBal:GetBalance(oAcc:accid,oAcc:balitemid)
				IF Val(Str(self:oBal:Per_Deb))<>0.and.Val(Str(self:oBal:Per_Cre))<>0
					skipaant++
				endif
				IF !self:lMinimalInfo
					oReport:PrintLine(@nRow,@nPage,;
						Space(20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+'------------'+self:cTab+'------------'+iif(lForgnC,Space(8)+self:cTab+self:cTab+'------------'+self:cTab+'------------',""),Heading,skipaant)
					IF Val(Str(m58_deb))<>0 .or.Val(Str(m58_cre))<>0 .and.nMonthStart<nMonthEnd 
						oReport:PrintLine(@nRow,@nPage,;
							Pad(oLan:RGet('Balance',,"!")+Space(1)+oLan:RGet('transactions')+Space(1)+oLan:RGet(MonthEn[nFromMonth],,"!")+Space(1)+Str(nFromYear,4)+Space(1)+oLan:RGet("to")+Space(1)+;
							oLan:RGet(MonthEn[nToMonth],,"!")+Space(1)+Str(nToYear,4),20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+;
							iif(lForgnC,if(m58_debF-m58_creF<0,Space(12)+self:cTab+Str(m58_creF-m58_debF,12,DecAantal),Str(m58_debF-m58_creF,12,DecAantal)+self:cTab+Space(12))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
							IF(m58_deb-m58_cre<=0,Space(12)+self:cTab+Str(m58_cre-m58_deb,12,DecAantal),;
							Str(m58_deb-m58_cre,12,DecAantal)),Heading,0)
					endif

					oReport:PrintLine(@nRow,@nPage,BoldOn+;
						Pad(self:CurAcc+Space(1)+oLan:RGet('Account balance',,,"!")+Space(1)+DToC(EndOfMonth(Today()+31)),20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+;
						iif(lForgnC,if(BalDeb-BalCre<=0,Space(12)+self:cTab+Str(BalCre-BalDeb,12,DecAantal),;
						RedCharOn+Str(BalDeb-BalCre,12,DecAantal)+RedCharOff+Space(13))+self:cTab+BoldOff+PadC(self:cAccCurrency,8)+self:cTab,"") +;
						IF(self:oBal:Per_Deb > self:oBal:Per_Cre,RedOn+Str(self:oBal:Per_Deb-self:oBal:Per_Cre,12,DecAantal)+RedCharOff,;
						Space(12)+self:cTab+Str(self:oBal:Per_Cre-self:oBal:Per_Deb,12,DecAantal))+BoldOff,Heading,0)
				endif
				IF self:SkipInactive .and. !lTransFound   // regarde liabilities and assets always as active
					*  Skip accounts without a transaction:
					* remove added member lines:
					ASize(self:oReport:oPrintJob:aFIFO,nBeginmember)
				endif

				IF !self:beginreport .and.!self:oTrans:EOF
					nPage:=0 //reset page for next account
				endif
			endif
			if self:oTrans:EOF
				exit
			endif
			self:cAccCurrency:=self:oTrans:AccCurrency
			self:CurAcc:=self:oTrans:ACCNUMBER
			IF IsAccess(self,#Owner)
				self:Owner:STATUSMESSAGE("Printing account statement of :"+self:CurAcc+": regel:"+Str(Len(oReport:oPrintJob:aFIFO)))
			ENDIF
			lForgnC:=(!self:cAccCurrency==sCURR)
			if oReport:MaxWidth<57+self:DescrWidth+35 .and. lForgnC
				oReport:MaxWidth:=57+self:DescrWidth+35
				oReport:oPrintJob:Initialize(oReport:MaxWidth)
			elseif oReport:MaxWidth>=57+self:DescrWidth+35 .and. !lForgnC
				oReport:MaxWidth:=57+self:DescrWidth
				oReport:oPrintJob:Initialize(oReport:MaxWidth)
			endif
			oReport:beginreport:=self:beginreport
			me_AccNbr := Pad(self:CurAcc,12)
			m58_rek:=Str(self:oTrans:AccID,-1)
			me_oms:=self:oTrans:accname
			me_type:=self:oTrans:acctype
			IF Lower(self:oReport:Extension) # "xls"
				Heading:={if(Empty(addheading),"",addheading+Space(1))+oLan:RGet("ACCOUNT STATEMENTS",,"@!")+":"+;
					oLan:RGet(MonthEn[nFromMonth],,"!")+Space(1)+Str(nFromYear,4)+Space(1)+oLan:RGet("to")+Space(1)+;
					oLan:RGet(MonthEn[nToMonth],,"!")+Space(1)+Str(nToYear,4),;
					YellowOn+me_AccNbr+'   '+me_oms+YellowOff, Space(1)} 
				self:cTab:=Space(1)
			ELSE
				self:cTab:=CHR(9)
			endif
			AAdd(Heading,;
				oLan:RGet("Doc-id",10,"!")+self:cTab+oLan:RGet("Date",10,"!")+self:cTab+;
				oLan:RGet("Description",self:DescrWidth,"!")+self:cTab+oLan:RGet("Debit",12,"!","R")+self:cTab+oLan:RGet("Credit",12,"!","R")+self:cTab;
				+iif(lForgnC,oLan:RGet("Currency",8,"!","C")+self:cTab+oLan:RGet("Debit",9,"!","R")+sCURR+self:cTab+oLan:RGet("Credit",9,"!","R")+sCURR+self:cTab,"");
				+oLan:RGet("Transnbr",8,"!","R"))
			IF Lower(self:oReport:Extension) == "xls"
				AAdd(Heading,if(Empty(addheading),"",addheading+Space(1))+oLan:RGet("ACCOUNT STATEMENTS",,"@!")+":"+;
					oLan:RGet(MonthEn[nFromMonth],,"!")+Space(1)+Str(nFromYear,4)+Space(1)+oLan:RGet("to")+Space(1)+;
					oLan:RGet(MonthEn[nToMonth],,"!")+Space(1)+Str(nToYear,4))
				AAdd(Heading,YellowOn+me_AccNbr+'   '+me_oms+YellowOff)
				AAdd(Heading,Space(1))
			else
				AAdd(Heading,Replicate('-',oReport:MaxWidth))
			endif
			jr_cur:=0
			mnd_cur:=0
			nCurMonth:=0
			store 0 to m58_deb,m58_cre,m57_giftbed,mnd_deb,mnd_cre
			store 0 to m58_debF,m58_creF,m57_giftbedF,mnd_debF,mnd_creF
			nBeginmember:=Len(oReport:oPrintJob:aFIFO)
			lTransFound:=false
		endif
		if !Empty(oTrans:dat)
			lTransFound:=true
			nThisMonth:=Integer(Year(self:oTrans:dat)*12)+Month(self:oTrans:dat)-1
			IF nThisMonth<>nCurMonth
				IF.not.Empty(mnd_cur)
					self:slot_mnd(Heading,oBal,Round(m57_giftbed,DecAantal),@nRow,@nPage,oLan,mnd_cur,mnd_deb,mnd_cre,m58_rek,me_type,jr_cur,oReport)
				ENDIF
				mnd_deb:=0
				mnd_cre:=0
				mnd_debF:=0
				mnd_creF:=0
				m57_giftbed:=0
				m57_giftbedF:=0
				oReport:PrintLine(@nRow,@nPage,Space(1)+oLan:RGet(MonthEn[Month(self:oTrans:dat)],,"@!")+' '+;
					Str(Year(self:oTrans:dat),4),Heading,9)
				IF Empty(mnd_cur)  && eerste maand:
					jr_cur:=Year(self:oTrans:dat)
					mnd_cur:=Month(self:oTrans:dat)
					self:oBal:GetBalance(m58_rek,jr_cur*100+mnd_cur,jr_cur*100+mnd_cur,self:cAccCurrency)
					if lForgnC
						oReport:PrintLine(@nRow,@nPage,;
							Pad(oLan:RGet('Beginning account balance',,"!")+Space(1)+oLan:RGet(MonthEn[mnd_cur],,"!")+Space(1)+Str(jr_cur,4),20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+; 
						IF(self:oBal:Begin_DebF-self:oBal:Begin_CreF<0,Space(12)+self:cTab+;
							Str(self:oBal:Begin_CreF-self:oBal:Begin_DebF,12,DecAantal),;
							Str(self:oBal:Begin_DebF-self:oBal:Begin_CreF,12,DecAantal)+self:cTab+Space(12))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,Heading,0) 
						nRow--
					endif
					// 							oBal:GetBalance(m58_rek,me_num,jr_cur*100+mnd_cur,jr_cur*100+mnd_cur) 
					oReport:PrintLine(@nRow,@nPage,;
						iif(lForgnC,"",Pad(oLan:RGet('Beginning account balance',,"!")+Space(1)+oLan:RGet(MonthEn[mnd_cur],,"!")+Space(1)+Str(jr_cur,4),20+self:DescrWidth)+self:cTab+self:cTab+self:cTab)+; 
					iif(self:oBal:Begin_Deb-self:oBal:Begin_Cre<0,Space(12)+self:cTab+;
						Str(self:oBal:Begin_Cre-self:oBal:Begin_Deb,12,DecAantal),;
						Str(self:oBal:Begin_Deb-self:oBal:Begin_Cre,12,DecAantal)),Heading,0)
				ENDIF
				if self:oBal:Begin_Deb # self:oBal:Begin_Cre
					lTransFound:=true   // beginning balance: regard as active
				endif
				jr_cur:=Year(self:oTrans:dat)
				mnd_cur:=Month(self:oTrans:dat)
				nCurMonth:=nThisMonth
			ENDIF
			mnd_deb:=mnd_deb+self:oTrans:deb
			mnd_cre:=mnd_cre+self:oTrans:cre
			m58_deb:=m58_deb+self:oTrans:deb
			m58_cre:=m58_cre+self:oTrans:cre
			mnd_debF:=mnd_debF+self:oTrans:DEBFORGN
			mnd_creF:=mnd_creF+self:oTrans:CREFORGN
			m58_debF:=m58_debF+self:oTrans:DEBFORGN
			m58_creF:=m58_creF+self:oTrans:CREFORGN
			* member and personal gift:
			// 				IF !Empty(Val(oAcc:persid)).and. !Empty(self:oTrans:persid) .and. self:oTrans:deb<>self:oTrans:cre .and.!self:oTrans:FROMRPP .and. !self:oTrans:GC="CH"
			IF !Empty(self:oTrans:persid) .and. self:oTrans:Deb<>self:oTrans:cre .and.self:oTrans:FROMRPP=0 .and. !self:oTrans:GC="CH"
				m57_giftbed:=m57_giftbed+self:oTrans:cre-self:oTrans:deb
				m57_giftbedF:=m57_giftbedF+self:oTrans:CREFORGN-self:oTrans:DEBFORGN
			ELSE
				IF self:SendingMethod="SeperateFile"
					cOms:=StrTran(StrTran(StrTran(self:oTrans:Description,"\","\\"),"{","\{"),"}","\}")
				else
					cOms:=self:oTrans:Description
				endif
				oReport:PrintLine(@nRow,@nPage,;
					PadR(self:oTrans:docid,10)+self:cTab+DToC(self:oTrans:dat)+self:cTab+iif(lXls,cOms,MemoLine(cOms,self:DescrWidth,1))+self:cTab+;
					iif(lForgnC,Str(self:oTrans:DEBFORGN,12,DecAantal)+self:cTab+Str(self:oTrans:CREFORGN,12,DecAantal)+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
					Str(self:oTrans:deb,12,decaantal)+self:cTab+Str(self:oTrans:cre,12,decaantal)+;
					self:cTab+PadL(Str(self:oTrans:TransId,-1),8),Heading,0)
				if !lXls
					nMem:=2
					do	WHILE	!Empty(cDesc:=MemoLine(cOms,self:DescrWidth,nMem))
						oReport:PrintLine(@nRow,@nPage,Space(20)+self:cTab+self:cTab+cDesc,Heading,0)
						nMem++
					ENDDO
				endif
			ENDIF
		endif
		self:oTrans:Skip()
	ENDDO

	RETURN true
METHOD slot_mnd(Heading as array,oMyBal as balances,m57_giftbed as float,nRow ref int,nPage ref int,oLan as Language,mnd_cur as int,mnd_deb as float,mnd_cre as float,m58_rek as string,me_type as string,jr_cur as int,oReport as PrintDialog) CLASS AccountStatements
LOCAL skipaant:=5 as int
local BalDeb:=0.00, BalCre:=0.00 as float 
IF Integer(m57_giftbed*100)/100#0
	oReport:PrintLine(@nRow,@nPage,iif(self:cTab==CHR(9),self:cTab+self:cTab,Space(22))+;
	Pad(oLan:RGet("Total gifts/own funds",,"!"),self:DescrWidth)+self:cTab+;
	iif(lForgnC,Str(m57_giftbedF,12,DecAantal)+Space(13)+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
	+Space(12)+self:cTab+Str(m57_giftbed,12,DecAantal),Heading,6)
ENDIF
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
oReport:PrintLine(@nRow,@nPage,;
Space(20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+'------------'+self:cTab+'------------'+iif(lForgnC,Space(8)+self:cTab+self:cTab+'------------'+self:cTab+'------------',""),Heading,skipaant)
IF Val(Str(mnd_deb))<>0 .and.Val(Str(mnd_cre))<>0  .and.!self:lMinimalInfo
	oReport:PrintLine(@nRow,@nPage,Pad(oLan:RGet('Subtotal',,"!")+;
	Space(1)+oLan:RGet(MonthEn[mnd_cur],,"!"),20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+; 
	iif(lForgnC,Str(mnd_debF,12,DecAantal)+self:cTab+Str(mnd_creF,12,DecAantal)+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
	Str(mnd_deb,12,DecAantal)+self:cTab+Str(mnd_cre,12,DecAantal),Heading)
ENDIF
oReport:PrintLine(@nRow,@nPage,;
Pad(iif(self:lMinimalInfo,oLan:RGet('Subtotal',,"!"),oLan:RGet('Balance',,"!")+Space(1)+oLan:RGet('transactions'))+Space(1)+oLan:RGet(MonthEn[mnd_cur],,"!"),20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+;
iif(lForgnC,if(mnd_debF-mnd_creF<0,Space(12)+self:cTab+Str(mnd_creF-mnd_debF,12,DecAantal),;
Str(mnd_debF-mnd_creF,12,DecAantal)+self:cTab+Space(12))+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;
IF(mnd_deb-mnd_cre<0,Space(12)+self:cTab+Str(mnd_cre-mnd_deb,12,DecAantal),;
Str(mnd_deb-mnd_cre,12,DecAantal)),Heading)
IF Val(Str(self:oBal:per_deb))<>0 .and.Val(Str(self:oBal:per_cre))<>0 .and.!self:lMinimalInfo
	oReport:PrintLine(@nRow,@nPage,Pad(oLan:RGet('Account level',,"!")+Space(1)+;
	+oLan:RGet(MonthEn[mnd_cur],,"!"),20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+;
	iif(lForgnC,Str(BalDeb,12,DecAantal)+self:cTab+Str(BalCre,12,DecAantal)+self:cTab+PadC(self:cAccCurrency,8)+self:cTab,"")+;	
	Str(self:oBal:Per_Deb,12,DecAantal)+self:cTab+Str(self:oBal:Per_Cre,12,DecAantal),Heading)
ENDIF
oReport:PrintLine(@nRow,@nPage,BoldOn+Pad(AllTrim(self:CurAcc)+Space(1)+oLan:RGet('Account ending balance',,"!")+Space(1)+;
oLan:RGet(MonthEn[mnd_cur],,"!")+Space(1)+Str(jr_cur,4),20+self:DescrWidth)+self:cTab+self:cTab+self:cTab+; 
iif(lForgnC,if(BalDeb-BalCre<=0,Space(12)+self:cTab+Str(BalCre-BalDeb,12,DecAantal),;
RedCharOn+Str(BalDeb-BalCre,12,DecAantal)+RedCharOff+self:cTab+Space(12))+self:cTab+BoldOff+PadC(self:cAccCurrency,8)+self:cTab,"") +;
IF(self:oBal:Per_Deb-self:oBal:Per_Cre<=0,Space(12)+self:cTab+Str(self:oBal:Per_Cre-self:oBal:Per_Deb,12,DecAantal),;
RedCharOn+Str(self:oBal:Per_Deb-self:oBal:Per_Cre,12,DecAantal)+RedCharOff)+BoldOff,Heading) 
// empty space line:
oReport:PrintLine(@nRow,@nPage," ",Heading)

RETURN
function AddToIncome(gc:="" as string,FROMRPP:=false as logic,accid as string,cre as float,deb as float,debforgn as float,creforgn as float,;
Currency as string,DESCRIPTN as string,cType as string,cPersId as string,mDAT as date,mDocId as string,cTransnr as string,nSeqnbr ref int) as logic
	// Add current record to Gifts Income/Expense in case of assessable gift to liability member
	LOCAL mOms as STRING
	LOCAL nCre,nCreF as FLOAT
	Local lHas as logic
	LOCAL OfficeRate as FLOAT, me_rate,me_stat as STRING 
	local oMbr as SQLSelect
	local cStatement as string
	local oStmnt as SQLStatement 
	local lError as logic
	IF Empty(SINC) .and.Empty(SINCHOME)
		RETURN true
	ENDIF
	IF (!Empty(cPersId).or. FromRpp) .and.gc=="AG" 
		IF cType=="PA"  //liability?
			// add to gifts income:
			if !Empty(SINCHOME) .or.!Empty(SINC)
				oMbr:=SQLSelect{"select has,grade,offcrate from member where accid="+accid,oConn}
				if oMbr:RecCount>0 
					lHas:= if(oMbr:HAS>0,true,false) 
				else
					Return true
				endif
				if Empty(SINC).and.!lHas
					RETURN true
				endif
				nCre:=Round(Cre-Deb,DecAantal)
				nCreF:=Round(CREFORGN-DEBFORGN,DecAantal)
				me_stat:=AllTrim(oMbr:Grade)
/*				if gc=="AG" .and.!FROMRPP .and. me_stat!="Staf"
					me_rate:=oMbr:OFFCRATE
					DO CASE
					CASE Empty(me_rate)
						OfficeRate:=sInhdKntr
					CASE me_rate="L"
						OfficeRate:=sInhdKntrL
					CASE me_rate="H"
						OfficeRate:=sInhdKntrH
					CASE me_rate="M"
						OfficeRate:=sInhdKntrM
					OTHERWISE
						OfficeRate:=sInhdKntr
					ENDCASE
					if lHas
						OfficeRate:=OfficeRate+sInhdField        // add field assessment in cas eof home assigned
					endif 
					nCre:=Round(nCre*(100-OfficeRate)/100,DecAantal)
					nCreF:=Round(nCreF*(100-OfficeRate)/100,DecAantal)
				endif  */
				mOms:=DESCRIPTN
				if nCre <>0
					nSeqnbr++
					cStatement:="insert into transaction set transid="+cTransnr+",accid="+iif(lHas,SINCHOME,SINC)+",dat='"+SQLdate(mDAT)+;
						"',docid='"+mDocId+"',description='"+mOms+;
						"',cre="+Str(nCre,-1)+",creforgn="+Str(nCreF,-1)+",seqnr="+Str(nSeqnbr,-1)+",userid='"+LOGON_EMP_ID+"',currency='"+Currency+"'"
					oStmnt:=SQLStatement{cStatement,oConn}
					oStmnt:Execute()
					if oStmnt:NumSuccessfulRows>0 
						if ChgBalance(iif(lHas,SINCHOME,SINC),mDAT,0.00,nCre,0.00,nCreF,sCURR)
							nSeqnbr++
							oStmnt:SQLString:="insert into transaction set transid="+cTransnr+",accid="+iif(lHas,SEXPHOME,SEXP)+",dat='"+SQLdate(mDAT)+;
								"',docid='"+mDocId+"',description='"+mOms+;
								"',deb="+Str(nCre,-1)+",debforgn="+Str(nCreF,-1)+",seqnr="+Str(nSeqnbr,-1)+",userid='"+LOGON_EMP_ID+"',currency='"+Currency+"'" 
							oStmnt:Execute()
							if oStmnt:NumSuccessfulRows>0
								if !ChgBalance(iif(lHas,SEXPHOME,SEXP),mDAT,nCre,0.00,nCreF,0.00,sCURR)
									lError:=true
								endif
							else
								LogEvent(,"error:"+oStmnt:Status:Description+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
								lError:=true
							endif
						else
							lError:=true
						endif
					else
						lError:=true
						LogEvent(,"error:"+oStmnt:Status:Description+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
					endif
				ENDIF
			ENDIF
		ENDIF
	endif
	RETURN !lError
	

	
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
      	* niks doen
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
METHOD AccntProc(cAccValue) CLASS General_Journal
	LOCAL oHm as TempTrans
	local cFilter as string
	oHm:=self:Server
	if !oHm:lFilling
		self:lStop:=false 
	endif
	IF !oHm:lFilling    && in case of update existing transaction skip
		IF !oHm:CheckUpdates()
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
	LOCAL oHm as TempTrans
	oHm:=SELF:Server	
	IF !SELF:Server:eof
		oHm:GoBottom()
		cOms:=oHm:DESCRIPTN
		cOPP:=oHm:OPP
	ENDIF
		
	SUPER:append()
	IF oHm:Recno==2
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
	&& add empty row to mirror:
	AAdd(oHm:aMirror,{'           ',oHm:deb,oHm:cre,'  ',' ',oHm:Recno,0,' ','','',sCurr,false,oHm:DEBFORGN,oHm:CREFORGN,"",oHm:DESCRIPTN,"",""})
	oHm:DESCRIPTN:=cOms
RETURN true
METHOD ChgDueAmnts(action as string,oOrig as TempTrans,oNew as TempTrans) as logic CLASS General_Journal
* Update of corresponding due amounts:
* Action W : update of account/person
*        WB: update amount only
*        T : add of transaction line
*        D : delete of transaction line
*
IF (oOrig:KIND=="D".or.oOrig:KIND=="A".or.oOrig:KIND=="F".or.oOrig:KIND=="M".or.oOrig:KIND=="G");
.and..not.Empty(self:OrigPerson)
   IF action=="WB"
      * Update amount received of due amount:
      return ChgDueAmnt(self:OrigPerson,oNew:AccID,oNew:deb - oOrig:deb,;
      oNew:cre - oOrig:cre)
   ELSEIF action=="W".or.action=="D"
      * Reverse amount received:
      if !ChgDueAmnt(self:OrigPerson,oOrig:AccID,-oOrig:deb,-oOrig:cre)
      	return false
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

RETURN TRUE
 METHOD Delete() CLASS General_Journal
 * delete record of TempTrans:
LOCAL ThisRec, CurRec AS INT
LOCAL oHm as TempTrans
LOCAL Success AS LOGIC

oHm := SELF:server
CurRec:=oHm:RecNo

IF Empty(oHm:aMirror)  && nothing to delete?
	RETURN FALSE
ENDIF
IF !oHm:CheckUpdates()
	RETURN FALSE
ENDIF
IF (self:lTeleBank .or. oHm:FROMRPP) .and. oHm:Recno==1
 	(ErrorBox{,'Modification of ' + iif(self:lTeleBank,'telebanking account','RPP transaction') + ' not allowed'}):show()
    RETURN FALSE
ENDIF		

//ThisRec:=AScan(oHm:aMirror, {|x| x[6]==CurRec})
IF !Empty(CurRec) .and.!(oHm:Eof.and.oHm:Bof)
	ADel(oHm:aMirror,CurRec)  && remove row from mirror
	ASize(oHm:aMirror,Len(oHm:aMirror)-1)
	SUPER:Delete(TRUE)
	Success:=oHm:Pack()
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
LOCAL aHeader as ARRAY
LOCAL oReport as PrintDialog 
local multicurr as logic
if AScan( oHm:aMirror,{|x|!Empty(x[11]).and.x[11] # sCURR})>0
	multicurr:=true
	nWidth+=30
endif
oReport := PrintDialog{self,"Financial Records",,nWidth,DMORIENT_LANDSCAPE}
oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
aHeader:= {oLan:RGet("Financial Record",,"!"),' ',' '}
nCurRec:=oHm:RecNo
oHm:SuspendNotification()
oHm:Gotop()
nRow:=0
nPage:=0
oReport:PrintLine(@nRow,@nPage,;
Pad(oLan:RGet("transaction number",,"!")+":",20)+Str(self:mTRANSAKTNR,-1)+if(lInqUpd,"","(prior)"),aHeader)
oReport:PrintLine(@nRow,@nPage," ",aHeader)  //Regel overslaan
oReport:PrintLine(@nRow,@nPage,;
Pad(oLan:RGet("date",,"!")+":",20)+DToC(self:mDAT),aHeader)
oReport:PrintLine(@nRow,@nPage," ")  //Regel overslaan
oReport:PrintLine(@nRow,@nPage,;
Pad(oLan:RGet("document id",,"!")+":",20)+mBst,aHeader)
oReport:PrintLine(@nRow,@nPage," ")  //Regel overslaan
IF !Empty(mCLNGiver)
// 	oPers:Seek(AllTrim(mCLNGiver))
    oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("Person",,"!")+":",aHeader)
//    	oReport:PrintLine(@nRow,@nPage,oPers:GetFullNAW(),aHeader)
   	oReport:PrintLine(@nRow,@nPage,self:cGiverName,aHeader)
	oReport:PrintLine(@nRow,@nPage," ",aHeader)  //Regel overslaan
ENDIF

oReport:PrintLine(@nRow,@nPage,self:oLan:RGet("Transaction lines",nWidth,"@!","C"),aHeader)
oReport:PrintLine(@nRow,@nPage,;
self:oLan:RGet("Account",52,"@!")+' '+self:oLan:RGet("Reference",12,"@!")+' '+self:oLan:RGet("Description",40,"@!")+' '+self:oLan:RGet("Debit",12,"@!","R");
+" "+self:oLan:RGet("Credit",12,"@!","R")+iif(multicurr,' '+self:oLan:RGet("Cur",3,"@!")+;
' '+PadL(self:oLan:RGet("Debit",,"@!")+"-"+sCurr,12);
+" "+PadL(self:oLan:RGet("Credit",,"@!")+"-"+sCurr,12),"") +' '+self:oLan:RGet("Ass",3,"@!"),aHeader)
oReport:PrintLine(@nRow,@nPage,Replicate('-',nWidth),aHeader)

DO WHILE !oHm:EOF
/*	oReport:PrintLine(@nRow,@nPage,;
    SubStr(oHm:accnumber,1,11)+' '+PadR(oHm:AccDesc,40)+' '+;
    PadR(oHm:DESCRIPTN,40)+' '+Str(oHm:deb,12,decaantal)+' '+Str(oHm:cre,12,decaantal)+;
    ' '+PadC(oHm:gc,3),aHeader) */

    oReport:PrintLine(@nRow,@nPage,;
    SubStr(oHm:ACCNUMBER,1,11)+' '+PadR(oHm:AccDesc,40)+' '+; 
    PadR( oHm:REFERENCE,12)+' '+;
	+MemoLine(oHm:DESCRIPTN,40,1)+' '+;
	iif(multicurr,Str(oHm:DEBFORGN,12,DecAantal)+' '+Str(oHm:CREFORGN,12,DecAantal)+' '+oHm:CURRENCY+' ',"")+;	
	Str(oHm:deb,12,decaantal)+' '+Str(oHm:cre,12,decaantal)+;
    ' '+PadC(oHm:gc,3),aHeader)
	nMem:=2
	DO WHILE !Empty(cDesc:=MemoLine(oHm:DESCRIPTN,40,nMem))
		oReport:PrintLine(@nRow,@nPage,Space(53)+cDesc,aHeader)
		nMem++
	ENDDO
	oHm:Skip()
ENDDO
oHm:RecNo:=nCurRec
oHm:ResetNotification()
oReport:prstart()
oReport:prstop()
RETURN NIL
METHOD FillBatch(pBst as string,pDat as date,cGiver as string,cOms as string, cExId as string, nPostStatus:=0 as int) CLASS General_Journal
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
	oDCGiroText:TEXTValue:=AllTrim(cOms) 
	self:mPostStatus:=nPostStatus
	
//	SELF:Server:GOTOP() 
	self:Totalise(false,false)
*	DO WHILE !SELF:server:EoF
*		SELF:oSFGeneralJournal1:DebCreProc()
*		SELF:Server:Skip()
*	ENDDO
*	SELF:Server:GoTop()
RETURN
METHOD FillRecord(cTransnr as string,oBrowse as JournalBrowser,mOrigPers as string,mOrigDat as date,mOrigBst as string,cOrigUser as string,nOrigPost as int,oCaller as General_Journal) CLASS General_Journal
	* Filling of windowfields with existing transaction for inquiry/update
	LOCAL oHm as TempTrans
	local oPersCnt as PersonContainer 
// 	Default(@nOrigPost,0)
*	LOCAL oPers AS Person
	oHm := SELF:Server
	//oTransH:=oBrowse:Owner:Server
	self:oOwner:=oCaller
	mBst := mOrigBst
	self:mDat:=mOrigDat
	self:CurDate:=mOrigDat
	OrigDat := mOrigDat
	OrigBst := mBst
	SELF:oDCUserdIdTxt:TextValue:=cOrigUser
	lInqUpd := TRUE
	oHm:lInqUpd := TRUE
	oHm:oDat := OrigDat
	oInqBrowse:= oBrowse
	self:oDCmTRANSAKTNR:TextValue:=cTransnr
	self:oDCSC_TRANSAKTNR1:TEXTValue:=""
	self:mPostStatus:=nOrigPost
   oHm:lFilling:=true
	OrigPerson := mOrigPers
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
	IF !Empty(OrigPerson)
		oPersCnt:=PersonContainer{}
		oPersCnt:persid:=OrigPerson
		self:RegPerson(oPersCnt)
*		oPers:Close()
	ENDIF
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
local cFrom:="balanceitem as b,account as a left join member m on (m.accid=a.accid)" 
local cFields:="a.*,b.category as type,m.co,m.persid as persid,"+SQLAccType()+" as accounttype"
	IF self:Server:Lastrec > 0
		SELF:Reset()
	ENDIF
	oHm := SELF:Server
	SELF:append()
	self:mCLNGiver := self:oTmt:m56_persid
	self:cGiverName := ""
	self:mPerson := ""
	self:mDAT:=self:oTmt:m56_bookingdate
	self:mBst:=self:oTmt:m56_kind+Str(self:oTmt:m56_seqnr,-1,0)
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
// 	if self:oTmt:m56_kind="CLL" .and. self:oTmt:m56_addsub ="A"    // storno
// 		oHm:AccID:=self:oTmt:m56_payahead
// 	endif

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
		self:oSFGeneralJournal1:DebCreProc(false)
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
local cFrom:="balanceitem as b,account as a left join member m on (m.accid=a.accid)" 
local cFields:="a.*,b.category as type,m.co,m.persid as persid,"+SQLAccType()+" as accounttype"
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
	LOCAL ThisRec AS INT
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
	ELSE
		oAccount:=omAcc
		crek := Str(oAccount:AccID,-1)
		oHm:AccDesc := oAccount:Description
		oHm:ACCNUMBER:=oAccount:ACCNUMBER
		oHm:KIND:=oAccount:accounttype
		if !oHm:KIND=="M"
			oHm:gc:=" "
		else
			cPersId:=Str(oAccount:persid,-1)
		endif
		//       cNum:=oAccount:balitemid
		oHm:CURRENCY:= oAccount:CURRENCY 
		cNum:=Str(oAccount:balitemid,-1)
		MultiCur:=iif(oAccount:MULTCURR=1,true,false)
		cType:=oAccount:type
	ENDIF
	oHm:AccID :=  crek
	IF Empty(cRek)
		oHm:KIND := " "
		oHm:AccDesc := ""
		oHm:Gc := ""
		oHm:AccNumber:=cRek
	ENDIF
	IF oHm:FROMRPP .and. !Empty(CurGC)
		// in case of import from RPP keep old GC code
		oHm:GC:=CurGC
	ENDIF
	* save in mirror-array
	//	ThisRec:= AScan(oHm:aMirror,{|x|x[6]==oHm:Recno})
	ThisRec:=oHm:RecNo
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
	self:oSFGeneralJournal1:AddCurr()
	IF !oHm:lFilling.and.!Empty(cRek)
		//		oHm:SuspendNotification() 
		fDebSav:=oHm:aMirror[oHm:RecNo,2]
		fCreSav:=oHm:aMirror[oHm:RecNo,3]
		self:oSFGeneralJournal1:DebCreProc(false)
		if oHm:aMirror[ThisRec,11] # sCurr .and. fCreSav # fDebSav
			// 	if foreign currency recalculate debforeign, creforeign 
			if self:oCurr==null_object
				self:oCurr:=Currency{}
			endif
			ROE:=self:oCurr:GetROE(oHm:CURRENCY,self:mDat)
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
	IF !Empty(oCLN)
		self:mCLNGiver :=  iif(IsNumeric(oCLN:persid),Str(oCLN:persid,-1),oCLN:persid)
		self:cGiverName := GetFullName(self:mCLNGiver)
		self:oDCmPerson:TEXTValue := self:cGiverName 
		self:cOrigName:=self:cGiverName
		IF SQLSelect{"select mbrid from member where persid="+self:mCLNGiver,oConn}:Reccount>0
			self:lMemberGiver := true
		ELSE
			SELF:lMemberGiver := FALSE
		ENDIF
		// 	oCLN:ResetNAW()
	ELSE
		//	self:mCLNGiver :=  null_string
		//	SELF:cGiverName := NULL_STRING
		self:oDCmPerson:Value := self:cOrigName	
		//	self:lMemberGiver := FALSE  
	ENDIF
	if !self:Server:lFilling
		self:lStop:=false
	endif

	RETURN NIL
METHOD ReSet() CLASS General_Journal
*	LOCAL cServer AS STRING

//	SELF:Server:DeleteAll()
//	SELF:Server:Pack()
	SELF:Server:Zap()
	SELF:Server:aMirror:={}
	SELF:Server:lFromRPP:=FALSE
	fTotal:=0 
	self:lStop:=true
	oDCDebitCreditText:Caption := Str(fTotal)
	SELF:lMemberGiver:=FALSE
	RETURN
				
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
	local aCre:={} as array	
	
	oHm := SELF:server
	nCurRec := oHm:RECNO

	AEval(oHm:aMirror,{|x| AAdd(aCre,Round(x[2]-x[3],DecAantal))})
	fTot:=asum(aCre) 

	self:fTotal:=fTot
	self:oDCDebitCreditText:Caption := Str(fTotal,-1,DecAantal)
	
	// Append eventually a new record:
// 	Default(@ldelete,FALSE)
	IF !fTotal == 0 // totaal ongelijk nul?
		IF !ldelete.and.AScan(oHm:aMirror,{|x| x[2]==0.and.x[3]==0})=0   // Geen lege transact en geen delete?
		// Append new record:
			self:Append()
			self:Commit()
			self:oSFGeneralJournal1:Browser:refresh()
			self:oSFGeneralJournal1:GoTo(nCurRec)
			//SELF:oSFGeneralJournal1:Browser:bNeglectSkip:=TRUE
			RETURN TRUE
		ENDIF
	ELSE
		IF oHm:Lastrec>1 .and. self:ValidateTempTrans(true,@i)
			SELF:oCCOKButton:SetFocus()
			IF self:lTeleBank
				IF !self:oTmt:m56_recognised
					self:oCCSaveButton:Show()
					self:oCCSaveButton:SetFocus()
				ENDIF
			ENDIF
		ENDIF
	ENDIF
 	self:oDCFoundtext:TextValue:=Str(oHm:RecCount,-1)

RETURN TRUE
METHOD UpdateLine(oMutNew as TempTrans, oOrigMut as TempTrans,lGiver ref logic) as logic CLASS General_Journal
* Wijzigen van velden van mutatie a.h.v. waarden in oMutNew
local cStatement as string
local oStmnt as SQLStatement 
lGiver:=(oMutNew:GC='PF'.or.oMutNew:GC = 'AG' .or. oMutNew:GC = 'MG';
.or. oMutNew:category= 'G'.or. oMutNew:category= 'D';
.or. oMutNew:category= 'A' .or. oMutNew:category = 'F' .or. oMutNew:category = 'C') 
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
",docid='"+self:mBST+"'"+;
",dat='"+SQLdate(self:mDAT)+"'"+;
",gc='"+oMutNew:GC+"'"+;
",fromrpp="+ iif(oMutNew:FROMRPP,'1','0')+;
",userid='"+LOGON_EMP_ID+"'"+; 
",ppdest='"+oMutNew:PPDEST+"'"+;
",persid="+iif(lGiver,self:mCLNGiver,"0")+;
",transid="+Str(self:mTRANSAKTNR,-1)+; 
",seqnr="+Str(iif(empty(oMutNew:SEQNR),self:nLstSEqNr,oMutNew:Recno),-1)+;
",description='"+AllTrim(oMutNew:DESCRIPTN)+"'"+;
",reference='"+oMutNew:REFERENCE+"'"+;
iif(Posting,",poststatus="+ self:mPostStatus,"")+;
iif(sproj=oMutNew:AccID .and.(oMutNew:cre-oMutNew:Deb)>0 .and..not.Empty(self:mCLNGiver),",bfm='O'",;
iif(!Empty(oMutNew:SEQNR).and. sproj= oOrigMut:AccID,",bfm=' '",""))+;  // change from earmarked gift to non-earmarked 
iif(Empty(oMutNew:SEQNR),""," where transid="+Str(self:mTRANSAKTNR,-1)+" and seqnr="+Str(oMutNew:SEQNR,-1)

oStmnt:=SQLStatement{cStatement,oConn}
oStmnt:Execute()
if Empty(oStmnt:Status)
	return true
else
	return false
endif
METHOD UpdateTrans(dummy:=nil as logic) as Logic CLASS General_Journal
	* Update of an existing transaction with the modified data in TempTrans:
	LOCAL NewIndex, OrigIndex, OrigMut, AktiePost AS STRING, NewMut AS Filespec
	LOCAL oOrig, oNew as TempTrans
	LOCAL cSavFilter, cSavOrder as STRING, nSavRec as int, lSucc as LOGIC
	LOCAL pFilter AS _CODEBLOCK
	LOCAL pnt as int 
	Local lNewPers,lGiver  as logic 
	local oTransH:=self:oOwner:oMyTrans as SQLSelect
	local oStmnt as SQLStatement

	oNew:=SELF:server
	NewIndex:=oNew:FileSpec:Drive+oNew:FileSpec:Path+oNew:FileSpec:FileName
	lSucc:=oNew:CreateIndex(FileSpec{NewIndex},"StrZero(SEQNR,6)+ACCID",{||StrZero(oNew:SEQNR,6)+oNew:AccID})
	IF !lSucc
		(errorbox{SELF:owner,'Not able to make indexfile for updates'}):show()
		RETURN FALSE
	ENDIF
	oNew:SetOrder(FileSpec{NewIndex})
	oNew:GoTop()
   GetHelpDir()
	OrigMut:=HelpDir+"\OR"+StrTran(Time(),":")
	oOrig:=TempTrans{OrigMut+'.dbf'}
	IF !oOrig:Used.or.!oNew:Used.or.!lSucc
		(errorbox{SELF:owner,'Not able to make helpfile for updates'}):show()
		RETURN FALSE
	ENDIF

	nSavRec:=oInqBrowse:Owner:Server:Recno
	
	oOrig:lInqUpd:=true
	oTransH:GoTop()
	self:nLstSeqNr:=0 
	DO WHILE !oTransH:EOF
		oOrig:append()
		oOrig:AccID := Str(oTransH:AccID,-1)
		oOrig:AccDesc:=oTransH:AccDesc
		oOrig:DESCRIPTN := AllTrim(oTransH:Description)
		oOrig:ACCNUMBER := oTransH:ACCNUMBER
		oOrig:Deb := oTransH:Deb
		oOrig:cre :=  oTransH:cre
		if Empty( oTransH:Currency)
			oOrig:CURRENCY:=sCurr
		else 
			oOrig:CURRENCY:= oTransH:CURRENCY
		endif
		if oOrig:CURRENCY==sCurr
			oOrig:debforgn := oTransH:Deb
			oOrig:CREFORGN :=  oTransH:cre
		else
			oOrig:DEBFORGN := oTransH:DEBFORGN
			oOrig:CREFORGN :=  oTransH:CREFORGN
		endif
		oOrig:GC := oTransH:GC
		oOrig:BFM:= oTransH:BFM
		oOrig:FROMRPP:=iif(oTransH:FROMRPP==1,true,false)
		oOrig:lFromRPP:=iif(oTransH:FROMRPP==1,true,false)
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
		oOrig:POSTSTATUS:=oTransH:POSTSTATUS
		* After getting locks check again if all conditions are satisfied (could e.g be changed in the meanwhile by
		* allotting non-earmarked gift):
		IF (pnt:=AScan(oNew:aMIRROR,{|x|x[7]==oOrig:SEQNR}))==0 .or.; // deleted?
			!AllTrim(oNew:aMirror[pnt,1])==AllTrim(oOrig:AccID).or.; //account changed?
			!(oNew:aMIRROR[pnt,2]-oNew:aMIRROR[pnt,3])==(oOrig:DEB-oOrig:CRE) .or.; //amount changed?
			!AllTrim(oNew:aMIRROR[pnt,4])==AllTrim(oOrig:GC) .or.; //ass.code changed? 
			!oNew:CURRENCY == oOrig:CURRENCY  // currency changed?
			IF !oOrig:CheckUpdates()
				oOrig:Close()
				oOrig:=NULL_OBJECT
				FErase (Origmut+".dbf")
				FErase (Origmut+".fpt")
// 				oTransH:Unlock()
				oNew:ClearIndex(NewIndex)
				NewIndex:= NewIndex+oNew:INdexExt
				FErase(NewIndex)
				RETURN FALSE
			ENDIF
		ENDIF
		oTransH:Skip()
	ENDDO

	lSucc:=oOrig:CreateIndex(FileSpec{OrigMut},"StrZero(SEQNR,6)+ACCID")
	oOrig:SetOrder(FileSpec{origmut})
	oOrig:GoTop()
	IF !lSucc
		(errorbox{SELF:owner,'Not able to make indexfile for updates'}):show()
		RETURN FALSE
	ENDIF

	DO WHILE !oOrig:EOF
		DO CASE
		CASE oOrig:SEQNR== oNew:SEQNR .and. !oNew:Deb==oNew:cre
			* Transaction line updates??:
			IF mCLNGiver#OrigPerson
				aktiePost:="W"
			ELSE
				aktiePost:=""
			ENDIF
			* When accid changed reverse old account record and add record for new account:
			IF oOrig:AccID # oNew:AccID
				aktiePost:="W"
			ENDIF
			* When amounts changed update balances:
			IF oOrig:DEB # oNew:DEB .or.oOrig:CRE # oNew:CRE
				IF Empty(aktiePost)
					aktiePost:="WB"     &&aleen bedrag gewijzigd
				ENDIF
			ENDIF
			* When date, accid or amounts have been updated change rerecord to new:
			IF self:mDAT # OrigDat.or.;
					oOrig:AccID # oNew:AccID .or.;
					oOrig:deb # oNew:deb .or.;
					oOrig:cre # oNew:cre
				* Reverse balances on old date:
				if !ChgBalance(oOrig:AccID,OrigDat,-oOrig:Deb,-oOrig:cre,-oOrig:debforgn,-oOrig:CREFORGN,oOrig:Currency)
					return false
				endif
				* Update balances on new date:
				if !ChgBalance(oNew:AccID,self:mDAT,oNew:Deb,oNew:cre,oNew:debforgn,oNew:CREFORGN,oNew:Currency)
					return false
				endif
				* Update fields of the transaction line:
				if !self:UpdateLine(oNew,oOrig,@lGiver)
					return false
				endif
			ELSE
				* Update fields of the transaction line:
				IF	OrigBst # mBst .or.;
						oOrig:gc # oNew:gc.or.;
						oOrig:DESCRIPTN # oNew:DESCRIPTN.or.;
						oOrig:REFERENCE # oNew:REFERENCE.or.;
						oOrig:KIND # oNew:KIND.or.;
						oOrig:CURRENCY # oNew:CURRENCY.or.;
						mCLNGiver # OrigPerson .or. ;
						oOrig:PPDEST # oNew:PPDEST .or.;
						(Posting .and.oOrig:POSTSTATUS # self:mPostStatus)
					if !self:UpdateLine(oNew,oOrig,@lGiver)
						return false
					endif
					if lGiver
						lNewPers := true
					endif
				ENDIF
			ENDIF
			IF.not.Empty(AktiePost)
				if !self:ChgDueAmnts(AktiePost,oOrig,oNew)
					return false
				endif
			ENDIF
			oNew:skip()
			oOrig:skip()
		CASE oOrig:SEQNR == oNew:SEQNR .and. oNew:Deb==oNew:cre
			* Remove dummy transaction line:
			* Delete line corresponding with origmut:
			oStmnt:=SQLStatement{"delete from transaction where transid="+self:mTRANSAKTNR+" and seqnr="+Str(oOrig:SEQNR,-1),oConn}
			oStmnt:execute()
			if !Empty(oStmnt:Status)
				return false
			endif
			lDeleted:=TRUE
			* Update balance:
			if !ChgBalance(oOrig:AccID,OrigDat,-oOrig:Deb,-oOrig:cre,-oOrig:debforgn,-oOrig:CREFORGN,oOrig:Currency)
				return false
			endif
			if !self:ChgDueAmnts("D",oOrig, oNew)
				return false
			endif
			oNew:skip()
			oOrig:skip()
			*    CASE Val(SubStr(Str(oOrig:RecNbr,9,0),3,7)) < Val(SubStr(Str(oNew:RecNbr,9,0),3,7)) .or. oNew:EOF.or.;
		CASE oNew:EOF.or.oOrig:SEQNR < oNew:SEQNR .or. ;
				(oOrig:SEQNR == oNew:SEQNR .and. oNew:Deb==oNew:cre)
			* Line removed:
			* Delete line corresponding with origmut:
			oStmnt:=SQLStatement{"delete from transaction where transid="+Str(self:mTRANSAKTNR,-1)+" and seqnr="+Str(oOrig:SEQNR,-1),oConn}
			oStmnt:execute()
			if !Empty(oStmnt:Status)
				return false
			endif
			* Update balance:
			if !ChgBalance(oOrig:AccID,OrigDat,-oOrig:Deb,-oOrig:cre,-oOrig:debforgn,-oOrig:CREFORGN,oOrig:Currency)
				return false
			endif
			if !self:ChgDueAmnts("D",oOrig, oNew)
				return false
			endif
			oOrig:skip()
		CASE oNew:SEQNR = 0
			* Transaction line added:
			IF !oNew:Deb==oNew:Cre // Ignore dummy transaction line
				* Append line from TempTrans
				if !self:UpdateLine(oNew,oOrig,@lGiver)
					return false
				endif
				* Update balance:
				if !ChgBalance(oNew:AccID,self:mDat,oNew:deb,oNew:cre,oNew:DEBFORGN,oNew:CREFORGN,oNew:Currency)
					return false
				endif
				if !self:ChgDueAmnts("T", oOrig, oNew)
					return false
				endif
			ENDIF
			oNew:Skip()
		ENDCASE
	ENDDO
	if mCLNGiver # OrigPerson .and. !lNewPers
		(WarningBox{,"Saving Transaction","Person not updated because no applicable transaction line"}):show()
	endif

	oNew:ClearIndex(NewIndex)
	Newmut:=FileSpec{NewIndex}
	NewMut:Extension:=oNew:INdexExt
	oNew:Close()
	oNew:=NULL_OBJECT
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
	oOrig:=NULL_OBJECT
	FErase(OrigIndex)
	FErase (Origmut+".dbf")
	FErase (Origmut+".fpt")
	if self:oOwner:lShowFind
		self:oOwner:FindButton()
	else
		self:oOwner:ShowSelection()
	endif
	oInqBrowse:Owner:GoTo(nSavRec)
	RETURN true
METHOD ValidateTempTrans(lNoMessage:=false as logic,ErrorLine:=0 ref int) as logic CLASS General_Journal
	* lNoMessage: True: Do not show error message
	LOCAL lValid := TRUE AS LOGIC
	LOCAL cError AS STRING
	LOCAL oHm as TempTrans
	LOCAL mRek AS STRING
	LOCAL i:=0 AS INT
	oHm := SELF:Server
// 	Default(@lNoMessage,FALSE)
oHm:SuspendNotification()
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
		   ENDIF
		ELSEIF !Empty(oHm:aMirror[i,4]).and.!oHm:aMirror[i,4]=="OT" //GC
			lValid := FALSE
			cError := self:oLan:WGet("Assessment code exclusively for member")
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
RETURN lValid
METHOD ValStore(lSave:=false as logic ) as logic CLASS General_Journal
	LOCAL nErrRec AS INT
	LOCAL cTransnr, m54_pers_sta:="N", mbrRek as STRING
	LOCAL oBox AS WarningBox
	LOCAL oHm as TempTrans
	LOCAL lError,lOK as LOGIC
	LOCAL curRec AS INT
	LOCAL i,j,nSeqnbr as int
	LOCAL CurValue AS ARRAY   // 1: nw value, 2: old value, 3: name of columnfield
	LOCAL ThisRec AS INT
	LOCAL cError AS STRING, ErrorLine:=1 AS INT
	LOCAL mCLNGiverMbr, OmsMbr, cCod, cCodNew as STRING 
	local cStatement as string
	local oStmnt as SQLStatement 
	local oPers,oMyTele,oMyImp,oAccFld as SQLSelect
	// 	Default(@lSave,FALSE)
	oHm := SELF:Server
	IF !SELF:fTotal==0
		(ErrorBox{self,self:oLan:WGet("Sum of transactions not equal zero")}):show()
		lError := TRUE
	ELSEIF Len(oHm:AMirror)< 2.and.!lInqUpd
		(ErrorBox{self,self:oLan:WGet("Transactions not complete")}):show()
		lError := TRUE
	ELSEIF 	!self:ValidateTempTrans(FALSE,@ErrorLine)
		lError := TRUE
		*		RETURN NIL
	ELSE
		*		Check only one membergiver:
		IF ADMIN=="WO" .and. !oHm:lFromRPP .and. (AScan(oHm:AMirror,{|x| x[4]=="AG".or.x[4]=="MG"})>0)
			i:= AScan(oHm:AMirror,{|x| x[4]=="CH".and.x[3]<x[2]})
			IF i > 0
				curRec:=oHm:AMirror[i,6]  // RECNO
				* Check if giver is a member:
				mbrRek:=oHm:AMirror[i,1]
				mCLNGiverMbr := oHm:AMirror[i,17]
				//	check	if	direct gift	report:
				if	AScan(oHm:AMirror,{|x| AllTrim(x[1])==mbrRek	.and.	x[4]="AG"})>0
					IF	Empty(mCLNGiver).or.	mCLNGiverMbr==self:mCLNGiver
						(ErrorBox{self,self:oLan:WGet("You should	specify a giver")+"!"}):show()
						RETURN FALSE
					else
						lOK:=true
					endif
					
				endif						 
				IF !lOK
					if !Empty(self:mCLNGiver).and. !mCLNGiverMbr==self:mCLNGiver
						cError := self:cGiverName+";  "
						lError := true
					ELSE
						self:mCLNGiver:=mCLNGiverMbr
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
						i:= AScan(oHm:AMirror,{|x| x[4]=="CH".and.x[3]<x[2].and.!x[6]==curRec},i+1)
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
			m54_pers_sta:= checkpayer( oHm:AMirror )
			IF Empty(self:mCLNGiver)
				IF SELF:lImport .and.!Empty(AllTrim(SELF:cGiverName)).and.(m54_pers_sta='V' .or.m54_pers_sta=='W')
					// busy with searching person
					RETURN FALSE
				ENDIF
				IF m54_pers_sta='V'
					(ErrorBox{self,self:oLan:WGet('Giver must be a person')}):show()
					lError := TRUE
					RETURN FALSE
				elseIF m54_pers_sta='C'
					(ErrorBox{self,self:oLan:WGet('Creditor must be a person')}):show()
					lError := true
					RETURN FALSE
				ELSEIF m54_pers_sta=='W'
					oBox := WarningBox{self, self:oLan:WGet("Input of Transactions"), ;
						self:oLan:WGet("Don't you need to specify a giver/payer")+"?"}
					oBox:Type := BUTTONYESNO
					IF (oBox:Show() = BOXREPLYYES)
						SELF:oDCmperson:SetFocus()
						RETURN FALSE
					ENDIF
				ENDIF
			ELSE
				IF m54_pers_sta='N'
					(ErrorBox{self,self:oLan:WGet('No person allowed in this case')}):show()
					SELF:oDCmperson:SetFocus()
					RETURN FALSE
				ELSEIF m54_pers_sta=='O'
					oBox := WarningBox{self, self:oLan:WGet("Input of Transactions"),self:oLan:WGet('Payer really a person')+'?'}
					oBox:Type := BUTTONYESNO
					IF (oBox:Show() = BOXREPLYNO)
						SELF:oDCmperson:SetFocus()
						RETURN FALSE
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		
		SQLStatement{"start transaction",oConn}:Execute()

		IF lInqUpd
			* Update transaction
			oHm:SuspendNotification()	
			lError:=!(SELF:UpdateTrans())
		ELSE
			* add new transaction:
			self:Owner:STATUSMESSAGE( self:oLan:WGet("Recording transaction")+" "+cTransnr)
			oHm:SuspendNotification()
			if self:lTeleBank
				// lock teletrans record:
				oMyTele:=SQLSelect{"select processed,lock_id,lock_time from teletrans where teletrid="+Str(self:oTmt:oTelTr:teletrid,-1)+;
					" and processed='' and lock_id="+MYEMPID+" for update",oConn}
				oMyTele:Execute()
				if oMyTele:RecCount<1
					ErrorBox{self,self:oLan:WGet("This telebank transaction has already been processed by someone else, thus skipped")}:show()
					SQLStatement{"rollback",oConn}:Execute()
					return true
				endif
			elseif self:lImport
				// lock importrans records
				if !self:oImpB:LockBatch()
					return true
				endif				
			endif	
			// 			oHm:gotop()
			// 			DO WHILE ! oHm:EOF
			For i:=1 to Len(oHm:AMirror)
				oHm:RecNo:=oHm:AMirror[i,6]  // recno
				if !oHm:Cre==oHm:Deb // skip dummy lines
					nSeqNbr++ 
					cStatement:="insert into transaction set "+;
						iif(Empty(cTransnr),'',"transid="+cTransnr+",")+;
						iif(oHm:gc='PF'.or.oHm:gc = 'AG' .or. oHm:gc = 'MG';
						.or. (oHm:KIND= 'G').or. oHm:KIND= 'D';
						.or. oHm:KIND= 'A' .or. oHm:KIND = 'F'.or. oHm:KIND="C","persid='"+self:mCLNGiver+"',","")+;
						"dat='"+SQLdate(self:mDAT)+"'"+;
						",docid='"+self:mBST+"'"+;
						",description='"+AddSlashes(AllTrim(oHm:DESCRIPTN))+"'"+; 
					",reference='"+AddSlashes(AllTrim(oHm:REFERENCE))+"'"+;
						",accid='"+AllTrim(oHm:AccID)+"'"+;
						",deb="+Str(oHm:Deb,-1)+;
						",cre="+Str(oHm:Cre,-1)+;
						",gc='"+oHm:gc+"'"+;
						",userid='"+LOGON_EMP_ID +"'"+;
						",fromrpp="+iif(oHm:FROMRPP,"1","0")+;
						",opp='"+oHm:OPP+"'"+;
						",ppdest='"+AllTrim(oHm:PPDEST)+"'"+; 
					",currency='"+AllTrim(oHm:Currency) +"'"+;
						",debforgn="+Str(oHm:DEBFORGN,-1)+;
						",creforgn="+Str(oHm:CREFORGN,-1)+;
						",seqnr="+Str(nSeqnbr,-1)+;
						iif(IsNil(self:mPostStatus),iif(lImport,",poststatus=2",""),; 
					",poststatus="+iif(IsString(self:mPostStatus),self:mPostStatus,Str(self:mPostStatus,-1))) +;
						iif(SPROJ == oHm:AccID.and..not.Empty(self:mCLNGiver).and.oHm:Cre>oHm:Deb,",bfm='O'","")
					oStmnt:=SQLStatement{cStatement,oConn}
					oStmnt:Execute()
					if oStmnt:NumSuccessfulRows>0
						if Empty(cTransnr)
							cTransnr:=SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)
						endif
						*	Update monthbalance value of corresponding account:
						if ChgBalance(oHm:AccID,self:mDAT,oHm:Deb,oHm:Cre,oHm:DEBFORGN,oHm:CREFORGN,oHm:Currency) //accid,deb,cre
							lError:=!AddToIncome(oHm:gc,oHm:FROMRPP,oHm:AccID,oHm:Cre,oHm:Deb,oHm:DEBFORGN,oHm:CREFORGN,oHm:Currency,oHm:DESCRIPTN,oHm:AMirror[i,18], self:mCLNGiver,self:mDAT,self:mBST,cTransnr,@nSeqnbr)
							if !lError
								if oHm:FROMRPP  .and.!Empty( samFld ) .and.!Empty( SEXP )
									// correct rabat assessment if needed: 
									if Empty(oHm:gc) .and. oHm:OPP== sEntity .and. !Empty(oHm:REFERENCE) 
										oAccFld:=SQLSelect{"select b.category from account a, balanceitem b where a.balitemid=b.balitemid and a.accnumber='"+;
										AllTrim(oHm:REFERENCE)+"'",oConn}
										if oAccFld:category==LIABILITY
											if ChgBalance(SEXP, self:mDAT,Round(oHm:Cre - oHm:Deb,DecAantal),0,Round(oHm:Cre - oHm:Deb,DecAantal),0,sCURR)
												nSeqnbr++ 
												cStatement:="insert into transaction set "+;
												"transid="+cTransnr+;
												",dat='"+SQLdate(self:mDAT)+"'"+;
												",docid='"+self:mBST+"'"+;
												",description='"+AddSlashes(AllTrim(self:oLan:RGet('Reversal Expense for assessment field&int')))+"'"+; 
												",reference='"+AddSlashes(AllTrim(oHm:REFERENCE))+"'"+;
												",accid='"+SEXP+"'"+;
												",deb="+Str(oHm:Cre	- oHm:Deb,-1)+;
												",userid='"+LOGON_EMP_ID +"'"+;
												",debforgn="+Str(oHm:Cre	- oHm:Deb,-1)+;
												",seqnr="+Str(nSeqnbr,-1)+;
												",poststatus=2" 
												oStmnt:=SQLStatement{cStatement,oConn}
												oStmnt:Execute()
												if oStmnt:NumSuccessfulRows>0
													if ChgBalance(samFld,self:mDAT,0,Round(oHm:Cre	- oHm:Deb,DecAantal), 0	,Round(oHm:Cre	- oHm:Deb,DecAantal),sCURR)
														nSeqnbr++ 
														cStatement:="insert into transaction set "+;
														"transid="+cTransnr+;
														",dat='"+SQLdate(self:mDAT)+"'"+;
														",docid='"+self:mBST+"'"+;
														",description='"+AddSlashes(AllTrim(self:oLan:RGet('Reversal Expense	for assessment	field&int')))+"'"+; 
														",reference='"+AddSlashes(AllTrim(oHm:REFERENCE))+"'"+;
														",accid='"+samFld+"'"+;
														",cre="+Str(oHm:Cre	- oHm:Deb,-1)+;
														",userid='"+LOGON_EMP_ID +"'"+;
														",creforgn="+Str(oHm:Cre	- oHm:Deb,-1)+;
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
						lError:=true
					endif
				endif
				if !lError
					//	Update balances of subscriptions/due amounts/ donations:
						IF	!Empty(self:mCLNGiver)
							IF	(oHm:KIND= 'D'	.or. oHm:KIND=	'A' .or.	oHm:KIND	= 'F'	.or.(oHm:deb >	oHm:cre .and.oHm:gc<>'CH' ))			 // storno also
								if	!ChgDueAmnt(self:mCLNGiver,AllTrim(oHm:AccID),oHm:deb,oHm:cre)
									lError:=true
									exit
								endif
							ENDIF
						endif
				endif
				if lError
					LogEvent(,"Error:"+cStatement,"LogErrors")
					ErrorBox{self,"transaction could not be stored:"+oStmnt:ErrInfo:errormessage}:show()
					SQLStatement{"rollback",oConn}:Execute()
					Break
					return true
				endif
			next
			IF self:lTeleBank
				self:oTmt:CloseMut(oHm,lSave,self:Owner)   // includes commit
			elseif self:lImport
				self:oImpB:CloseBatch()  // includes commit
			ENDIF
			lSave:=FALSE
			oHm:ResetNotification()	
		ENDIF
		if !lError
			SQLStatement{"commit",oConn}:Execute()
			IF !Empty(self:mCLNGiver)
				*  update data of giver:
				i:= AScan(oHm:AMirror,{|x| (x[3]-x[2])>0.and.(x[5]=="G" .or.x[5]=="M" .or.x[5]=="D")})
				IF i>0 
					oPers:=SQLSelect{"select mailingcodes,datelastgift from person where persid="+self:mCLNGiver,oConn}
					cCodNew:=oPers:mailingcodes
					DO WHILE i>0
						PersonGiftdata(oHm:AMirror[i,5],@cCodNew,oPers:datelastgift,oHm:AMirror[i,4],null_string,false)
						i:= AScan(oHm:AMirror,{|x| (x[3]-x[2])>0.and.(x[5]=="G" .or.x[5]=="M" .or.x[5]=="D")},i+1)
					ENDDO
					if !AllTrim(cCodNew)==oPers:mailingcodes .or. oPers:datelastgift<self:mDAT
						&& fill date last gift:
						oStmnt:=SQLStatement{"update person set datelastgift='"+SQLdate(self:mDAT)+"',mailingcodes='"+cCodNew+"' where persid="+self:mCLNGiver,oConn}
						oStmnt:Execute()
					endif 
				ENDIF
			ENDIF
			self:mTRANSAKTNR := cTransnr
		ENDIF
	ENDIF
	IF lError
		SELF:oSFGeneralJournal1:Browser:SetFocus()
		oHm:GoTop()
		SELF:oSFGeneralJournal1:Browser:Refresh()
		oHm:GoTo(ErrorLine,6)
		RETURN FALSE
	ELSEIF lInqUpd
		self:lStop:=true
		self:EndWindow()
	ENDIF
	
	
	RETURN TRUE		
	
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
METHOD DebCreProc(lNil:=false as logic) as void pascal CLASS GeneralJournal1
	LOCAL recnr AS INT
	LOCAL oHm as TempTrans
	LOCAL lFound AS LOGIC
	LOCAL i AS INT
	LOCAL nCurRec, CurRec, ThisRec AS INT
	LOCAL mRek as STRING
	Local ROE:=1 as float
	oHm := self:Server
	if oHm:CURRENCY # sCurr
		if Round(oHm:CREFORGN- oHm:DEBFORGN,DecAantal)<>0
			ROE:=oCurr:GetROE(oHm:CURRENCY,self:Owner:mDat)
			if oCurr:lStopped
				self:Owner:EndWindow()
				return
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
		RETURN
	ENDIF
	IF !oHm:CheckUpdates()
		* recover old values
		oHm:deb:=oHm:aMirror[oHm:Recno,2]
		oHm:cre:=oHm:aMirror[oHm:Recno,3]
		oHm:DEBFORGN:=oHm:aMirror[oHm:Recno,13]
		oHm:CREFORGN:=oHm:aMirror[oHm:Recno,14]
		self:Owner:Totalise(false,false)
		RETURN
	ENDIF
*	save new values into aMirror: 
	if !self:Server:lFilling
		self:Owner:lStop:=false  // give warning when cancel
	endif

	CurRec := oHm:RecNo
	oHm:aMirror[CurRec,2]:=oHm:deb
	oHm:aMirror[CurRec,3]:=oHm:cre
	oHm:aMirror[CurRec,13]:=oHm:DEBFORGN
	oHm:aMirror[CurRec,14]:=oHm:CREFORGN
	IF oHm:KIND == 'M'		
		mRek:=AllTrim(oHm:AccID)
		IF oHm:Deb > oHm:Cre  .and. !self:oParent:mBST="COL"     // inverse direct debit
			oHm:gc := 'CH'
			oHm:aMirror[CurRec,4]:=oHm:gc  && save in mirror
			* Convert present AG's into MG's:
			recnr := oHm:RecNo
			FOR i=1 TO Len(oHm:aMirror)
				IF !oHm:aMirror[i,6]==recnr
					IF (oHm:aMirror[i,4]=='AG'.or.Empty(oHm:aMirror[i,4])).and.oHm:aMirror[i,5]=='M' .and. !oHm:aMIRROR[i,1]==mRek
						oHm:Goto(oHm:aMirror[i,6])
						oHM:GC := 'MG'
						oHm:aMirror[i,4]:=oHm:gc  && save in mirror
					ENDIF
				ENDIF
			NEXT
		ELSEIF oHm:deb = oHm:cre
			oHm:gc := '  '
			oHm:aMirror[CurRec,4]:=oHm:gc  && save in mirror
		ELSE
			IF !oHm:gc == 'PF' .and. !(oHm:FROMRPP .and. !Empty(oHm:GC))
				oHm:gc := 'AG'
				IF SELF:Owner:lMemberGiver
					oHm:gc := 'MG'
				ENDIF
				FOR i:=1 TO Len(oHm:aMirror)
					IF i!=recnr .and. oHm:aMirror[i,4]=='CH'
						IF !oHm:aMIRROR[i,1]==mRek
							oHm:gc := 'MG'
						ELSE
							oHM:GC:= 'AG'
						ENDIF
						EXIT
					ENDIF
				NEXT
				oHm:aMirror[CurRec,4]:=oHm:gc  && save in mirror
			ENDIF
		ENDIF
	ELSE
		IF oHm:GC == 'CH'
			* Reset present MG:
			recnr := oHm:RecNo
			oHm:GoTop()
			DO WHILE oHm:locate(,{|| oHm:gc =='MG'})
				oHm:GC := 'AG'
				oHm:aMirror[oHm:Recno,4]:=oHm:gc  && save in mirror
			ENDDO
		ENDIF
		oHm:gc := '  '
		oHm:aMirror[CurRec,4]:=oHm:gc  && save in mirror
	ENDIF
	oHm:SuspendNotification()
	self:Owner:Totalise(false,false)
	oHm:ResetNotification() 

	self:Browser:Refresh()
RETURN
METHOD RegAccount(oRek,ItemName) CLASS InquirySelection
	LOCAL oAccount as SQLSelect
	LOCAL crek AS STRING
	oAccount:=oRek
	IF ItemName == "AccountFrom"
		IF	Empty(oRek).or.oRek==null_object .or. oRek:reccount < 1
			self:nAccount :=	Space(5)
			self:oDCmAccount:TEXTValue	:=	""
			self:cAccNumber:=""
			self:cAccName := ""
			self:cDep:=""
// 			self:cBal:=""
			self:cSoort:=""
			self:cCurr:=""
			RETURN
		ENDIF
		self:nAccount :=  str(oAccount:accid,-1)
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
			self:cAccNumberTo:=""
			self:cAccNameTo := ""
			self:cDepTo:=""
			self:cSoortTo:=""
			self:cCurrTo:=""
			RETURN
		ENDIF
		self:nAccountTo :=  Str(oAccount:AccID,-1)
		self:cAccNumberTo:= oAccount:ACCNUMBER
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
	IF Empty(oCLN).or. oCLN==null_object .or. oCLN:Reccount<1
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
	IF  Empty(oHm:aMirror).or.;  && nog leeg ?
		oHm:lExisting.or.; && tijdens opzetten bestaande file niets dien
		oHm:lOnlyRead && geen wijziging toegestaan?
		RETURN
	ENDIF
	myColumn:= oColumn
	ThisRec:=oHm:RecNo
	IF myColumn:NameSym == #AccNumber
		IF !AllTrim(myColumn:TextValue) == ;
		AllTrim(oHm:aMirror[ThisRec,8]) && waarde veranderd?
			oHm:aMirror[ThisRec,8]:= AllTrim(myColumn:TextValue) 
			myOwnerOwner:AccntProc(myColumn:VALUE)
		ENDIF
// 	ELSEIF myColumn:NameSym == #DEBFORGN .or. myColumn:NameSym == #DEB
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
			IF !oHm:CheckUpdates()
				* oude waarden terugzetten
				oHm:gc:=oHm:aMirror[ThisRec,4]  && zet oude waarde terug
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
			myColumn:TextValue:= myColumn:VALUE
			oHm:gc:=myColumn:VALUE
			IF !oHm:CheckUpdates()
				* Reset to previuos values
				oHm:gc:=oHm:aMirror[ThisRec,4]  && reset
				RETURN
			ELSE
				oHm:aMirror[ThisRec,4]:=oHm:gc  && save in mirror
				myOwnerOwner:ValidateTempGift()
			ENDIF
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
			IF !oHm:gc == 'PF'
				IF SELF:Owner:lMemberGiver
					oHm:gc := 'MG'
				ELSE
					oHm:gc := 'AG'
				ENDIF
			ENDIF
		ENDIF
	ELSE
		oHm:gc := '  '
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
		//{accid,orig,cre,gc,category,recno,accid,accnumber,creforgn,currency,multcur,dueid,acctype,description}
		//   1    2    3   4    5      6      7      8        9        10      11      12      13      14

		AAdd(self:Server:aMirror,{'           ',0,0,'  ',' ',self:Server:Recno,"   "," ",0,sCurr,false,"","",""})
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
				oHm:KIND := if(Empty(self:defGc),"G","M")
				oHm:Original := self:mDebAmnt
				oHm:CURRENCY := self:DefCur
				m51_agift :=1
				if !Empty(self:mDebAmnt)
					IF self:mDebAmnt>0
						oHm:GC := iif(oHm:KIND='M' .and.self:lMemberGiver,'MG',defGc)
						oHm:DESCRIPTN := 'Gift'
						IF self:GiftsAutomatic
							self:AutoRec:=true
						ENDIF
					ELSE
						oHm:GC:="CH"
						if lTeleBank
							oHm:DESCRIPTN:=oTmt:m56_naam_tegnr
						endif
						IF self:DueAutomatic
							self:AutoRec:=true
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
				{oHm:AccID,oHm:Original,oHm:cre,oHm:GC,oHm:KIND,oHm:RECNO,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY, self:DefMulti,0,self:deftype,oHm:DESCRIPTN}
		ENDIF
		RETURN  // Nothing to assign
	ENDIF

	nCurRec := oHm:Recno

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
			If self:GiftsAutomatic 
				self:AutoRec:=true
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
				oHm:DESCRIPTN := 'Gift'
			endif  		
		endif
      self:SpecialMessage()
		* Save in Mirror:
		oHm:aMirror[oHm:RECNO,3]:=oHm:cre  && save in mirror
		oHm:aMirror[oHm:RECNO,9]:=oHm:CREFORGN  && save in mirror
		oHm:aMirror[oHm:RECNO,4]:=oHm:GC  && save in mirror
		* In case of one possible destination and matching amount, assign it to that:
		IF self:m51_agift =1 .and. (!MultiDest.or.oHm:Original==oHm:cre).and.self:GiftsAutomatic
			self:AutoRec:=true
		ENDIF
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
			oHm:Skip()
		ENDDO
		m51_totcre := self:mDebAmnt
		IF self:GiftsAutomatic
			self:AutoRec:=true
		ELSEIF cGiverName = "Comit" .or. cGiverName="Komit".or. cGiverName="Com."
			* Assign to Home Front directly:
			self:AutoRec:=true
		ELSEIF !MultiDest.and.self:GiftsAutomatic
			* In case of Home Front System assign directly:
			self:AutoRec:=true
		ELSEIF Len(aApplied) = 1 // one unique destination
			cSoort:=oHm:aMirror[aApplied[1],5]
			IF cSoort == "M" .or. cSoort == "G"  //Gift
				IF self:GiftsAutomatic
					self:AutoRec:=true
				ENDIF
			ELSE // open post
				IF self:DueAutomatic
					self:AutoRec:=true
				ENDIF
			ENDIF
		ENDIF
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
					      self:SpecialMessage()
							* Save in Mirror:
							oHm:aMirror[oHm:RECNO,3]:=oHm:cre  && save in mirror
							oHm:aMirror[oHm:RECNO,9]:=oHm:CREFORGN  && save in mirror
							self:AutoRec:=true
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
					cMess:=AllTrim(StrTran(Lower(SubStr(self:oTmt:m56_description,nMsgPos+2)),'gift'))
					if !Empty(cMess) 
						oHm:GoTop()
						do WHILE !oHm:EOF
							Destname:=GetTokens(alltrim(strtran(lower(oHm:AccDesc),'ink.')))[1,1]
							if AtC(Destname,cMess)>0
								oHm:cre:=self:mDebAmnt
								if oHm:CURRENCY==sCurr
									oHm:CREFORGN:=oHm:cre 
								else
									oHm:CREFORGN:=Round( oHm:cre/self:oCurr:GetRoe(oHm:CURRENCY,self:mDAT),DecAantal)
								endif
								m51_totcre := self:mDebAmnt
					      	self:SpecialMessage()
								* Save in Mirror:
								oHm:aMirror[oHm:RECNO,3]:=oHm:cre  && save in mirror
								oHm:aMirror[oHm:RECNO,9]:=oHm:CREFORGN  && save in mirror
// 							self:AutoRec:=true
							endif
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
		IF oHm:aMirror[nCurRec,5]="G".or.oHm:aMirror[nCurRec,5]="M"
			--SELF:m51_agift
		ELSE
			IF !Empty(oHm:aMirror[nCurRec,5])
				--SELF:m51_apost
			ENDIF
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
oReport:prstart()
oReport:prstop()
RETURN NIL
METHOD FillTeleBanking(lNil:=nil as logic) as logic CLASS PaymentJournal
	* Filling of windowfields := giroteltransaction-values
	LOCAL oHm:=self:server as TempGift
	LOCAL lSuccess, lNameCheck as LOGIC
	LOCAL oEditPersonWindow as NewPersonWindow
	local CurRate as float
	local oPersCnt as PersonContainer
	local myAcc as SQLSelect
	local oPersBank,oSel as SQLSelect
	local oPers as SQLSelectPerson 

	self:Reset()
	AutoCollect:=FALSE 
	Acceptgiro:=False 
	* In case of automatic collection (CLIEOP03-file) and Acceptgiro via BGC look for pay ahead account:
	IF (oTmt:m56_kind="COL" .or.oTmt:m56_kind="KID" .or.oTmt:m56_kind="ACC")  .and.oTmt:m56_addsub ="B"
		IF Empty(oTmt:m56_payahead)
			(ErrorBox{self:owner,"No account for Payments en route specified for banknbr "+AllTrim(oTmt:m56_bankaccntnbr)}):show()
			self:EndWindow()
			RETURN FALSE
		ELSE
			oTmt:m56_sgir:=oTmt:m56_payahead
		ENDIF
		IF oTmt:m56_kind="COL" .or.oTmt:m56_kind="KID"
			AutoCollect:=true
		else
			Acceptgiro:=true
		endif
	ENDIF
	IF (myAcc:=SQLSelect{"select accid,currency,accnumber,description from account where accid="+AllTrim(oTmt:m56_sgir),oConn}):RecCount<1
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
	if !self:DebAccId== oTmt:m56_sgir 
		self:DebAccId:=oTmt:m56_sgir
		self:bankanalyze()
	endif	
	self:ShowDebbal()
	self:mDAT := oTmt:m56_bookingdate
	self:mBst := AllTrim(oTmt:m56_kind)+AllTrim(Str(oTmt:m56_seqnr,-1,0)) 
	self:oDCmBST:Value:=self:mBst
	if !self:DebCurrency==sCurr
		if self:oCurr==null_object
			self:oCurr:=Currency{}
		endif
		CurRate:= self:oCurr:GetROE(self:DebCurrency,self:mDAT) 
	endif
	//Acceptgiro:=FALSE  ???
	IF oTmt:m56_addsub ="B"
		self:mDebAmntF:= oTmt:m56_amount
		//	IF (Trim(oTmt:m56_kind)="AC" .or.(SubStr(oTmt:m56_description,17,2)="AC")).and. (!Empty(oTmt:m56_persid).or.isnum(Pad(SubStr(oTmt:m56_description,1,16),16,"A")))
		IF (Trim(oTmt:m56_kind)="AC" .or.(SubStr(oTmt:m56_description,17,2)=="AC").and.isnum(SubStr(oTmt:m56_description,1,16)))
			Acceptgiro:=true
			*   		SELF:mCLNGiver := SubStr(oTmt:m56_description,2,5)   // juiste formaat door fout verkeerd om
			IF !Empty(oTmt:m56_persid)
				self:mCLNGiver := oTmt:m56_persid
			ELSEif isnum(Pad(SubStr(oTmt:m56_description,1,16),16,"A"))
				self:mCLNGiver := SubStr(oTmt:m56_description,12,5)
				if !isnum(self:mCLNGiver) .or.Val( mCLNGiver)=0
					self:mCLNGiver:=""
				endif
			ENDIF
		ELSEIF Trim(oTmt:m56_kind)="KID"  .and. !Empty(oTmt:m56_persid)
			Acceptgiro:=true
			self:mCLNGiver := oTmt:m56_persid    // import KID file (Norway)
		ELSEIF Trim(oTmt:m56_kind)="PGA"
			self:mCLNGiver := oTmt:m56_persid    // import PG Autogiro file (Swedisch)	
			Acceptgiro:=true
		ENDIF			
	ELSE
		self:mDebAmntF:=-oTmt:m56_amount
	ENDIF
	self:oDCmDebAmntF:Value:= self:mDebAmntF
	if self:DebCurrency==sCurr
		self:mDebAmnt :=self:mDebAmntF
	else
		self:mDebAmnt:=Round(CurRate*self:mDebAmntF,DecAantal)
	endif
	lNameCheck:=true 
	* Analyse name and address from Bank: 
	oPersCnt:=PersonContainer{}
	oPersCnt:m51_lastname:=AllTrim(oTmt:m56_contra_name)
	oPersCnt:m51_pos:=oTmt:m56_zip
	oPersCnt:m51_ad1:=oTmt:m56_address
	oPersCnt:m51_city:=oTmt:m56_town
	oPersCnt:m51_country:=oTmt:m56_country
	oPersCnt:m56_banknumber:= oTmt:m56_contra_bankaccnt
	oPersCnt:m51_type:="individual"
	oPersCnt:m51_gender:="unknown"
	if Empty(oPersCnt:m51_ad1) .and. Empty(oPersCnt:m51_pos) .and. Empty(oPersCnt:m51_city)
		oPersCnt:m51_ad1:=AllTrim(oTmt:m56_description) 
		oPersCnt:Naw_Analyse()
	else
		oPersCnt:Naw_Analyse(,,,!Empty(oPersCnt:m51_pos),!Empty(oPersCnt:m51_city),!Empty(oPersCnt:m51_ad1))
	endif

	//IF Empty(oTmt:m56_contra_bankaccnt).or.oTmt:m56_addsub =="A".or.(Acceptgiro.and.!Empty(Val(mCLNGiver))).or.;
	//	(ADMIN="HO".and.(oTmt:m56_kind="VZ".or.oTmt:m56_kind="DV".or.oTmt:m56_kind="FL"))
	IF oTmt:m56_addsub =="A".or.(self:Acceptgiro.and.!Empty(Val(self:mCLNGiver))).or.;
			(oTmt:m56_kind="VZ".or.oTmt:m56_kind="DV".or.oTmt:m56_kind="FL")
		lNameCheck:=FALSE
		self:InitGifts()
		//oHm:=SELF:Server
		*	IF (oTmt:m56_kind="VZ".or.oTmt:m56_kind="DV".or.oTmt:m56_kind="FL").and.oTmt:m56_addsub ="B"
		IF (oTmt:m56_kind="VZ".or.oTmt:m56_kind="DV".or.oTmt:m56_kind="FL").or.ADMIN="HO"
			IF oHm:Lastrec=0
				self:append()
				oHm:cre := self:oTmt:m56_amount
			ENDIF	
			oHm:DESCRIPTN:=oTmt:m56_contra_name
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
				{oHm:ACCNUMBER,oHm:Original,oHm:cre,oHm:gc,oHm:KIND,oHm:RECNO,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,oHm:Multiple,0,'',oHm:DESCRIPTN}	
			//ELSEIF Acceptgiro 
		ELSEIF !empty(self:mCLNGiver)
			self:PersonButton(true,,true,oPersCnt)
			// 				m51_assrec:=self:oPers:Recno
			if Acceptgiro
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
		Recognised:=FALSE
		
		IF !Empty(oTmt:m56_contra_bankaccnt) 
			oPers:=SQLSelectPerson{"Select p.* from person p, personbank pb where p.persid=pb.persid and banknumber='"+oTmt:m56_contra_bankaccnt+"'",oConn}
			if oPers:RecCount>0
				Recognised:=true
				// 					m51_assrec:=self:oPers:Recno
				IF AllTrim(oPersCnt:m51_pos)#alltrim(oPers:postalcode) .and. Len(AllTrim(oPersCnt:m51_pos))>=7
					* address changed: 
					oPersCnt:persid:=Str(oPers:persid,-1)
					oEditPersonWindow := NewPersonWindow{ self:owner,,oPers,{lNew,true,self,oPersCnt }}
					oEditPersonWindow:Caption:="Address changed of: "+AllTrim( GetFullNAW(oPersCnt:persid))
					oEditPersonWindow:Show()
				ELSE
					self:Regperson(oPers)
				ENDIF
				self:oDCmPerson:Disable()
				self:oCCPersonButton:Disable()
			ENDIF
		ENDIF
		IF !Recognised
			IF !Acceptgiro
				self:InitGifts()
			ENDIF
			* In case of automatic collection (CLIEOP03-file) no name known:
			IF AutoCollect
				cOrigName:=AllTrim(oTmt:m56_contra_bankaccnt)
				self:oDCmPerson:TEXTValue := cOrigName
			ELSE
				cOrigName:=AllTrim(oPersCnt:m51_lastname)
				IF Empty(cOrigName)
					cOrigName:=mCLNGiver
				ENDIF
				mCLNGiver:=""
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
	self:oDCcGirotelText:Caption:=AllTrim(oTmt:m56_contra_name)+iif(Empty(AllTrim(oTmt:m56_contra_bankaccnt)),'','('+AllTrim(oTmt:m56_contra_bankaccnt)+')')+' '+;
		iif(Empty(self:oTmt:m56_description).or.!Empty(self:oTmt:m56_address).and.!self:oTmt:m56_address $ self:oTmt:m56_description,; 
	Compress(self:oTmt:m56_description+" "+self:oTmt:m56_address+", "+self:oTmt:m56_zip+" "+self:oTmt:m56_town+" "+self:oTmt:m56_country),self:oTmt:m56_description)
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
	mCLNGiver:=AllTrim(mCLNGiver)
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
				ELSEIF self:Acceptgiro
					*				oHm:ACCNUMBER := LTrimZero(SubStr(self:oTmt:m56_description,7,10))  / juiste formaat
					oHm:ACCNUMBER := LTrimZero(SubStr(self:oTmt:m56_description,2,5))
				ENDIF
				oHm:Original := self:oTmt:m56_amount
				oHM:GC := "AG"
				// 				oHm:GetCategory("G",cExtraText)
				oHm:GetCategory(,cExtraText)
				IF !Empty(oHm:AccID)
					++self:m51_agift
					oHm:cre := self:oTmt:m56_amount
					self:AutoRec:=true
				ENDIF
				if oHm:CURRENCY==sCurr
					oHm:CREFORGN:=oHm:cre 
				else
					oHm:CREFORGN:=Round( oHm:cre/self:oCurr:GetROE(oHm:CURRENCY,self:mDAT),DecAantal)
				endif
				self:oSFPaymentDetails:DebCreProc(true)
				* save in mirror-array
				oHm:aMirror[oHm:Recno]:=;
					{oHm:ACCNUMBER,oHm:Original,oHm:cre,oHm:gc,oHm:KIND,oHm:RECNO,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,oHm:Multiple,0,'',oHm:DESCRIPTN}    
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
					* save in mirror-array
					oHm:aMirror[oHm:Recno]:=;
						{oHm:ACCNUMBER,oHm:Original,oHm:Cre,oHm:GC,oHm:KIND,oHm:Recno,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,oHm:Multiple,0,oSub:acctype,oHm:DESCRIPTN} 
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
			oDue:=SQLSelect{"select dueid,s.personid as persid,round(amountinvoice - amountrecvd,2) as cre,s.accid,invoicedate,d.seqnr,b.category as acctype "+;
				"from dueamount d,account a, balanceitem b,subscription s "+;
				"where amountinvoice>amountrecvd and d.subscribid=s.subscribid and a.accid=s.accid and a.active=1 and  b.balitemid=a.balitemid and s.personid="+self:mCLNGiver,oConn}
			oDue:Execute()
			if oDue:Reccount>0
				DO WHILE !oDue:EOF 
					self:Append()
					oHm:cre := oDue:cre
					IF .not.self:lTeleBank.and.!self:lEarmarking
						self:mDebAmnt := self:mDebAmnt + oHm:cre
						&& credit-bedragen worden
						** opgeteld als default voor debet
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
					* save in mirror-array
					oHm:aMirror[oHm:Recno]:=;
						{oHm:ACCNUMBER,oHm:Original,oHm:cre,oHm:GC,oHm:KIND,oHm:Recno,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,oHm:Multiple,Str(oDue:dueid,-1),oDue:acctype,oHm:DESCRIPTN}
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
		SELF:DebAccNbr := oAccount:ACCNUMBER
		self:DebAccId:=cAcc
		self:DebCln := Str(oAccount:persid,-1)
		self:oDCDebitAccount:TEXTValue := AllTrim(oAccount:Description) 
		self:DebCurrency:=oAccount:CURRENCY 
		if !Empty(self:mDebAmntF) .and. !self:DebCurrency==sCurr
			self:mDebAmnt:=Round(mDebAmntF*oCurr:GetROE(DebCurrency,self:mDat),DecAantal) 
			self:AssignTo()
		endif			
		SELF:ShowDebBal()
		*    	SELF:lMemberGiver := FALSE
		IF !Empty(self:DebCln)
			oPers:=PersonContainer{}
			oPers:persid:=self:DebCln
			SELF:RegPerson(oPers)
			SELF:lMemberGiver := TRUE
		ELSE
			oBank:=SQLSelect{"select giftsall,openall from bankaccount where accid="+cAcc,oConn}
			IF oBank:Reccount>0
				self:GiftsAutomatic:=iif(oBank:GIFTSALL=1,true,false)
				self:DueAutomatic:=iif(oBank:OPENALL=1,true,false)
			ENDIF
		ENDIF
	ELSEIF ItemName == "Destination"
		*		cAcc := oAccount:accid
		IF !Empty(cAcc)
			oHm:AccID:=cAcc
			oHm:AccDesc := oAccount:Description
			oHm:AccNumber := oAccount:AccNumber
			oHm:CURRENCY:= oAccount:CURRENCY
			MultiCur:=iif(oAccount:MULTCURR=1,true,false)
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
					{oHm:ACCNUMBER,oHm:Original,oHm:cre,oHm:GC,oHm:KIND,oHm:RECNO,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,oHm:Multiple,0,oAccount:type,oHm:DESCRIPTN}
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
					{oHm:ACCNUMBER,oHm:Original,oHm:cre,oHm:GC,oHm:KIND,oHm:RECNO,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,oHm:Multiple,0,oAccount:type,oHm:DESCRIPTN}
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
			oHm:aMirror[oHm:RECNO]:=;
				{oHm:ACCNUMBER,oHm:Original,oHm:cre,oHm:GC,oHm:KIND,oHm:RECNO,oHm:AccID,oHm:ACCNUMBER,oHm:CREFORGN,oHm:CURRENCY,oHm:Multiple,0,'',oHm:DESCRIPTN}
		ENDIF 
		self:oSFPaymentDetails:AddCurr()
		self:Totalise(false,false)

		self:oSFPaymentDetails:Browser:SetColumnFocus(#AccDesc)

	ENDIF
	
	RETURN TRUE
METHOD RegPerson(oCLN,cItemname,lOK,oPersBr) CLASS PaymentJournal
	* cItemname: use for extra text for gift
	
	LOCAL lNewGift:= TRUE AS LOGIC
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

*	fServer:=SELF:Server:FileSpec
/*	SELF:Server:DeleteAll()
	SELF:Server:Pack()   */
	oHm:Zap()
	oHm:Amirror:={}
// 	self:oPers:m51_lastname:=""
// 	self:oPers:m51_initials:=""
// 	self:oPers:m51_firstname:=""
// 	self:oPers:m51_title:=""
// 	self:oPers:m51_prefix:=""
// 	self:oPers:m51_pos:=""
// 	self:oPers:m51_ad1:=""
// 	self:oPers:m51_city:=""
// 	self:oPers:m56_banknumber:=""
// 	self:oPers:m51_country:=""
//    self:oPers:persid:=""
//    self:oPers:m51_exid:=""
//    self:oPers:m51_type:="" 
//    self:oPers:m51_gender:=""
	self:AutoRec:=FALSE
	RETURN
Method SpecialMessage() class PaymentJournal
	LOCAL oHm:=self:server as TempGift
	local nMsgPos as int 
	local Destname, cSpecMessage as string
	local lSpecmessage as logic
	local aNospecmess:={'donatie','steun','bijdrage','maand','mnd','kwartaal','algeme','werk','onderh','onderst','wycliffe','betalingskenm'}  as array
	local aSpecmess:={'project','pensioen','lijfrente'} as array 
	// determine extra messsage in description of transaction: 
	if !self:Acceptgiro .and.  !Empty(oHm:AccDesc)
		nMsgPos:=At('%%',self:oTmt:m56_description)
		if nMsgPos>0 
			Destname:=GetTokens(oHm:AccDesc)[1,1]
			cSpecMessage:=AllTrim(StrTran(Lower(SubStr(self:oTmt:m56_description,nMsgPos+2)),'gift'))
			if !Empty(cSpecMessage) 
				lSpecmessage:=false 
				AEval(aSpecmess,{|x|lSpecmessage:=iif(AtC(x,cSpecMessage)>0,true,lSpecmessage)})
				if !lSpecmessage
					lSpecmessage:=true
					AEval(aNospecmess,{|x|lSpecmessage:=iif(AtC(x,cSpecMessage)>0,false,lSpecmessage)})
					if lSpecmessage
						if AtC(Destname,SubStr(self:oTmt:m56_description,nMsgPos+2))>0
							lSpecmessage:=false 
						endif
					endif
				endif
				if lSpecmessage 
					oHm:DESCRIPTN+=" "+cSpecMessage
				endif
			endif
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
					ENDIF
				ELSEIF !Empty(oHm:aMirror[i,4]) //GC, Cre
					lValid := FALSE
					cError := self:oLan:WGet("Assessment code exclusively for member")
					EXIT
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
	LOCAL cTransnr, m54_pers_sta:="N" AS STRING
	LOCAL oBox AS WarningBox
	LOCAL oHm:= self:server as TempGift
	LOCAL oDet:=self:oSFPaymentDetails as PaymentDetails
	LOCAL lError, recordfound as LOGIC
	local cError as string
	LOCAL curPntr:=1, i,nSeqnbr as int
	LOCAL fCreTot AS FLOAT
	LOCAL oXMLDocAcc,oXMLDocPrs as XMLDocument 
	local ChildName, cValue, cExtra,cCod as string 
	local BDAT,dlg as date
	local oSel,oPers,oSub,oAcc as SQLSelect
	local oStmnt as SQLStatement 	
	

	IF !oHm:EOF
		curPntr := oHm:Recno
	ENDIF 
	AEval(oHm:Amirror,{|x| fCreTot += x[3]})
	fCreTot:=Round(fCreTot,DecAantal)
	IF !self:fTotal == 0
		(errorbox{SELF:owner,"Sum of transactions not equal zero"}):show()
		lError := TRUE
	ELSEIF oHm:reccount < 1 .or. fCreTot = 0
		(errorbox{SELF:owner,"Transactions not complete"}):show()
		lError := TRUE
	ELSE
		IF Empty(self:DebAccId)
			(errorbox{SELF:owner,"Debit Account is obliged!"}):show()
			SELF:oDCDebitAccount:SetFocus()
			RETURN FALSE
		ELSEIF 	!self:ValidateTempGift()
			curPntr := oHm:Recno
			lError := TRUE
		ELSEIF ValidateControls( SELF, SELF:AControls )
			* Check giver:
			IF !Recognised
				m54_pers_sta:=oHm:m54w_rek_pers()
				IF Empty(self:mCLNGiver)
					IF m54_pers_sta='V'
						(errorbox{SELF:owner,'Specify a person as payer'}):show()
						SELF:oDCmPerson:SetFocus()
						RETURN FALSE
					ELSEIF m54_pers_sta=='W'
						oBox := Warningbox{SELF:owner, "Input of Payments/Gifts", ;
							"Don't you need to specify a giver/payer?"}
						oBox:Type := BUTTONYESNO
						IF (oBox:Show() = BOXREPLYYES)
							SELF:oDCmperson:SetFocus()
							RETURN FALSE
						ENDIF
					ENDIF
				ELSE
					IF m54_pers_sta='N'
						(errorbox{SELF:owner,'No person allowed in this case'}):show()
						SELF:oDCmperson:SetFocus()
						RETURN FALSE
					ELSEIF m54_pers_sta=='O'
						oBox := Warningbox{SELF:owner, "Input of oDCmPerson",'Payer really a person?'}
						oBox:Type := BUTTONYESNO
						IF (oBox:Show() = BOXREPLYNO)
							SELF:oDCmperson:SetFocus()
							RETURN FALSE
						ENDIF
					ENDIF
				ENDIF
			ENDIF
			oHm:SuspendNotification()	
			* add transaction:
			oHm:ClearFilter()
			oHm:SetFilter({||!Empty(oHm:Cre)},"!Empty(Cre)") //skip non-assigned rows
			SELF:Owner:StatusMessage( "Recording transaction "+cTransnr)
			oHm:gotop()
			SQLStatement{"start transaction",oConn}:Execute()
			nSeqnbr:=1 
			if self:lEarmarking
				// check if current non-earmarked transaction still not yet assigned
				oSel:=SQLSelect{"select bfm,userid from transaction where transid="+Str(self:nEarmarkTrans,-1)+" and seqnr="+Str(self:nEarmarkSeqnr,-1)+" for update",oConn}
				if oSel:reccount>0
					if !oSel:bfm=="O"
						ErrorBox{self:owner,self:oLan:wget("current non-earmarked gift allready assigned by")+Space(1)+oSel:userid}:show()
						SQLStatement{"rollback",oConn}:Execute()
						return false
					endif
				else 
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
				",description='"+AddSlashes( AllTrim(oHm:DESCRIPTN)) +"'"+;
				",accid="+self:DebAccId+;
				",deb="+Str(self:mDebAmnt,-1)+;
				",debforgn="+Str(self:mDebAmntF,-1)+;
				",currency='"+self:DebCurrency+"'"+;
				",userid='"+AddSlashes(LOGON_EMP_ID)+"'"+; 
			",seqnr="+Str(nSeqnbr,-1)+;
				iif(self:lMemberGiver.and.!Empty(Val(self:DebCln)),",gc='CH'",iif(self:lEarmarking,",bfm='T'","")),oConn} // member giver from member account
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows>0
				cTransnr:=SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)
				if ChgBalance(self:DebAccId,self:mDAT,self:mDebAmnt,0,self:mDebAmntF,0,self:DebCurrency)
					DO	WHILE	! oHm:EOF 
						nSeqnbr++ 
						oStmnt:=SQLStatement{"insert into transaction set "+;
							"transid="+cTransnr+;
							",seqnr="+Str(nSeqnbr,-1)+;
							",persid='"+self:mCLNGiver+"'"+;
							",dat='"+SQLdate(self:mDAT)+"'"+;
							",docid='"+self:oDCmBST:Value+"'"+;
							",reference='"+AddSlashes(AllTrim(oHm:REFERENCE))+"'"+;
							",description='"+AddSlashes(AllTrim(oHm:DESCRIPTN)) +"'"+;
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
								if !oHm:Cre==0
									if !AddToIncome(oHm:GC,false,oHm:AccID,oHm:cre,oHm:DEB,oHm:DEBFORGN,oHm:CREFORGN,oHm:Currency,oHm:DESCRIPTN,oHm:Amirror[oHm:Recno,13], self:mCLNGiver,self:mDAT,self:oDCmBST:TextValue,cTransnr,@nSeqnbr)
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
							LogEvent(,"error:"+oStmnt:ErrInfo:Errormessage+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
							exit
						endif
						oHm:skip()
					ENDDO
					if self:lEarmarking
						oStmnt:=SQLStatement{"update transaction set bfm='T',userid='"+AddSlashes(LOGON_EMP_ID)+"' where transid="+Str(self:nEarmarkTrans,-1)+" and accid="+SPROJ,oConn}
						oStmnt:Execute()
						if oStmnt:NumSuccessfulRows<1
							lError:=true
							LogEvent(,"error:"+oStmnt:ErrInfo:Errormessage+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
						endif
					endif
				else
					lError:=true
				endif
			else
				lError:=true
			endif
			if lError
				ErrorBox{self,"transaction could not be stored:"+AllTrim(oStmnt:ErrInfo:Errormessage)}:show()
				SQLStatement{"rollback",oConn}:Execute()
				Break
				return true
			else
				SQLStatement{"commit",oConn}:execute()
			endif
			self:ShowDebBal()
			IF !Empty(self:mCLNGiver)
				oPers:=SQLSelect{"select mailingcodes,propextr,creationdate,datelastgift from person where persid="+self:mCLNGiver,oConn}
				if oPers:reccount>0
					cCod:=oPers:mailingcodes
					cExtra:=oPers:PROPEXTR 
					BDAT:=oPers:creationdate 
					dlg:=oPers:datelastgift
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
					IF !Empty(oHm:aMirror[i,12]) 
						** update due amount
						oStmnt:= SQLStatement{"update dueamount set amountrecvd=round(amountrecvd+"+Str(oHm:Amirror[i,3],-1)+",2) "+;
							"where dueid="+oHm:Amirror[i,12],oConn}
						oStmnt:execute()
					ENDIF
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
						" where persid="+self:mCLNGiver,oConn}
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
			self:mTRANSAKTNR := cTransnr
			self:mDebAmntF := 0
			self:mDebAmnt:=0
			self:fTotal := 0
			self:AutoRec := FALSE
			self:m51_agift:= 0
			self:m51_apost := 0
		ELSE
			lError := true
		ENDIF
	ENDIF
	IF lError
		oHm:Recno := curPntr
		oDet:Browser:Refresh()
		RETURN FALSE
	ELSE 
		if !self:lTeleBank
			self:mCLNGiver:=""
			self:cGiverName:=""
			self:oDCmPerson:Value:=""
			self:oDCmDebAmntF:TEXTValue:=""
			self:mDebAmntF:=""
			self:oDCmPerson:SetFocus()
			oDet:Browser:Refresh()
		endif
	ENDIF
	
	RETURN true
FUNCTION PersonGiftdata(cType as string,cCod ref string,dlg as date,cAssmnt as string,DefMlcd:="" as string, DefOvrd:=false as logic,AccMlCod:="" as string) as void pascal
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
METHOD CheckUpdates() CLASS TempGift
RETURN TRUE
METHOD GetCategory(cType:='' as string,cExtraText:='' as string) as void pascal CLASS TempGift
	*	cType:	F: Open post
	*			G: Standard Gift
	*	cExtratext: text to be added to description of a gift(optional)
	*
	local oAcct as SQLSelect
// 	Default(@cType,null_string)
// 	Default(@cExtraText,null_string) 
	IF Empty(self:AccID).and.Empty(self:ACCNUMBER)
		return
	endif

	oAcct:=SQLSelect{"select a.accid, a.accnumber,a.description,a.currency,a.multcurr,"+SQLAccType()+" as accounttype "+;
	"from account a left join member m on (a.accid=m.accid) "+;
	"where "+iif(Empty(self:AccID),"a.accnumber='"+AllTrim(self:ACCNUMBER)+"'","a.accid="+self:AccID),oConn}
	oAcct:Execute()
	if oAcct:Reccount>0
		self:ACCNUMBER:=AllTrim(oAcct:ACCNUMBER)
		self:accid:=str(oAcct:accid,-1)
		self:ACCDESC:=oAcct:Description
		self:KIND:=oAcct:accounttype 
		self:CURRENCY:=oAcct:CURRENCY
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
			ELSE
				self:DESCRIPTN := ""
			ENDIF
		ENDIF
		if !Empty(cExtraText)
			self:DESCRIPTN +="; "+AllTrim(cExtraText)
		endif
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
METHOD CheckUpdates(lNil:=nil as logic) as logic CLASS TempTrans
   * Check if it is allowed to update or delete a transaction (accid,DEB,CRE,GC)
   LOCAL ThisRec as int
	IF !self:lInqUpd  && no update?
		RETURN TRUE
	ENDIF
   IF self:EOF.or.Empty(self:SEQNR)  && apparently new transaction
      RETURN TRUE
   ENDIF
	IF SELF:BFM=="H"
		(Errorbox{,"Transaction already sent to PMC"}):Show()
   	RETURN FALSE
	ENDIF
	ThisRec:=self:RecNo
   if !Empty(AMirror)
		if Empty(aMIRROR[ThisRec,13]).and.Empty(aMIRROR[ThisRec,14]).and.!(Empty(aMIRROR[ThisRec,2]).and.Empty(aMIRROR[ThisRec,3]))
   		 	(ErrorBox{,'Modification of reevaluation record not allowed'}):show()
    		RETURN FALSE
		ENDIF
   endif
	IF self:BFM=="C"
		(ErrorBox{,"Transaction already sent to AccPac/RIA"}):show()
   	RETURN FALSE
	ENDIF
	IF self:BFM=="T"
		(Errorbox{,"Gift without destination already allotted"}):Show()
		RETURN FALSE
	ENDIF
	IF SELF:CheckTeleAccount()
   	 (ErrorBox{,'Modification of telebanking account not allowed'}):show()
    	RETURN FALSE
	ENDIF 
				
RETURN TRUE
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
		cTab+self:oLan:RGet("ASS",3,"@!")+iif(lXls,Tab+self:oLan:RGet("Giver",,"@!"),"")
	AAdd(koparr,cColumns)
	m54_deb:=0.00
	m54_cre:=0.00
	oTrans:SuspendNotification()
	oTrans:Gotop()
	DO WHILE !oTrans:EOF
		oReport:PrintLine(@nRow,@nPage,;
			DToC(oTrans:dat)+cTab+Pad(oTrans:docid,10)+cTab+Pad(Str(oTrans:TransId,-1),10)+cTab+Pad(oTrans:accnumber,12)+cTab+;
			iif(lXls,oTrans:description,PadR(oTrans:description,40))+cTab+Str(oTrans:deb,14,decaantal)+cTab+Str(oTrans:cre,14,decaantal);
			+cTab+oTrans:gc+iif(lXls,cTab+iif(Empty(oTrans:personname),'',oTrans:personname),''),koparr,1)
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
		self:cTransferAccName := AllTrim(omAcc:Description)
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
	self:PersIdSelected:=AllTrim(self:PersIdSelected)
	self:DocIdSelected:=AllTrim(self:DocIdSelected)
	IF oPsbw==null_object
		(ErrorBox{,"You have already closed the inquiry browser window"}):Show()
		RETURN
	ENDIF
	self:Pointer := Pointer{POINTERHOURGLASS}

	self:m54_selectTxt:="" 
	self:cWhereSpec:="" 
	self:cOrder:="dat,accnumber"

	cDepmntXtr:=""
	if !Empty(self:DepIdSelected)
		cDepmntXtr:=SetDepFilter(Val(self:DepIdSelected))
		if !Empty(cDepmntXtr)
			cFilter+=iif(Empty(cFilter),''," and")+"a.department in ("+cDepmntXtr+")" 
		endif
	endif
	self:oCCTransferButton:Hide()

	IF !Empty(self:FromAccId) 
		if self:ToAccNbr==self:FromAccNbr
			cFilter:=iif(Empty(cFilter),'',cFilter+' and ')+'t.accid="'+self:FromAccId+'"'
			self:m54_selectTxt:="Account="+self:FromAccNbr
			IF Empty(self:StartDate).or.self:StartDate>=LstYearClosed
				IF !self:NoUpdate .and. AScan(self:aTeleAcc, Val(self:FromAccId))=0 
					oCCTransferButton:Show()
					lTransferShown:=true
				ENDIF
			ENDIF
		else
			// Add to filter 
			cFilter+=iif(Empty(cFilter),'',' and ')+"a.accnumber>='"+self:FromAccNbr+"' and a.accnumber<='"+self:ToAccNbr+"'"
			self:m54_selectTxt:="Account>="+self:FromAccNbr+" - "+self:ToAccNbr
		endif
	ELSEif Empty(self:DepIdSelected)
		oCCTransferButton:Hide()
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
		self:cOrder:="transid desc" 
	ENDIF
	IF !Empty(self:EndTransNbr)
		cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.transid<="'+self:EndTransNbr+'"'
		self:m54_selectTxt:=self:m54_selectTxt+" Transaction<="+self:EndTransNbr
		self:cOrder:="transid desc" 
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
		IF !Empty(self:StartAmount)
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'abs(t.cre-t.deb)>='+self:StartAmount
			self:m54_selectTxt:=self:m54_selectTxt+" Amount>="+self:StartAmount
		ENDIF
		IF !Empty(self:ToAmount)
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'abs(t.cre-t.deb)<='+self:ToAmount
			self:m54_selectTxt:=self:m54_selectTxt+" Amount<="+self:ToAmount
		ENDIF
	ELSEIF self:TransTypeSelected=="D" // debit amounts
		self:m54_selectTxt:=self:m54_selectTxt+" Debit amount>="+self:StartAmount
		IF !Empty(self:StartAmount)
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.deb>='+self:StartAmount
		ELSE
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'!Empty(deb)'
		ENDIF
		IF !Empty(self:ToAmount)
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.deb<='+self:ToAmount
			self:m54_selectTxt:=self:m54_selectTxt+" Debit amount<="+self:ToAmount
		ENDIF
	ELSEIF self:TransTypeSelected=="C" // credit amounts
		self:m54_selectTxt:=self:m54_selectTxt+" Credit amount>="+self:StartAmount
		IF !Empty(self:StartAmount)
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.cre>='+self:StartAmount
		ELSE
			cFilter:=if(Empty(cFilter),'',cFilter+' and ')+'t.cre<>0'
		ENDIF
		IF !Empty(self:ToAmount)
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
	self:cSelectStmnt:="select "+self:cFields+" from "+cFrom+" where "+self:cWhereBase+" and "+self:cWhereSpec  
	self:cSelectStmnt:=UnionTrans(self:cSelectStmnt) +" order by "+self:cOrder
	self:oTrans:SQLString:=self:cSelectStmnt 
// 	fSecStart:=Seconds()
	self:oTrans:Execute()
// 	LogEvent(self,Str(Seconds()-fSecStart,-1)+" sec for "+Str(self:oTrans:Reccount,-1)+" records with:"+self:oTrans:SQLString+CRLF+"explain:"+CRLF+GetExplain(self:oTrans:SQLString),"LogSql")
	self:GoTop()
	if self:oTrans:Reccount<1
		self:oSFTransInquiry_DETAIL:Browser:refresh()
	endif

	self:oSFTransInquiry_DETAIL:GoTop()
	self:Pointer := Pointer{POINTERARROW}
	self:oDCFound:TextValue :=Str(self:oTrans:Reccount,-1)


	RETURN
function UnionTrans(cStatement as string) as string
	// combine select statemenst on transaction with unions on historic trnsaction tables
	* 
	* cStatement should be in terms of Transaction table as t  
	* date conditions should be specified as: t.dat>='yyy-mm-dd' or t.dat<='yyy-mm-dd' or t.dat='yyyy-mm-dd'
	*
	Local nWhere, nDat1, nDat2,i as int
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
	nDat1:=At3("t.dat=",cStatement,nWhere+5)
	if nDat1>0
		BegDat:=CToD(SubStr(cStatement,nDat1+7,10))
		EndDat:=BegDat	
	else
		nDat1:=At3("t.dat>=",cStatement,nWhere+5)
		if nDat1>0
			BegDat:=CToD(SubStr(cStatement,nDat1+8,10))
		endif	
		nDat2:=At3("t.dat<=",cStatement,nWhere+5) 
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
	
function UnionTrans2(cStatement as string, BegDat as date, EndDat as date) as string
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
 
