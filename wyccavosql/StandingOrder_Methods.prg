METHOD ACCOUNTProc(cAccValue) CLASS EditPeriodic
	AccountSelect(self,AllTrim(cAccValue),"Account",true,"a.active=1")
	RETURN nil 
METHOD append() CLASS EditPeriodic
	LOCAL cDesc,cOpp as STRING
	LOCAL oStOrdLH:=self:oSFStOrderLines:Server as StOrdLineHelp
	IF !oStOrdLH:eof
		oStOrdLH:GoBottom()
		cDesc:=oStOrdLH:DESCRIPTN
	ENDIF
	
	self:oSFStOrderLines:append()
// 	IF oStOrdLH:Recno==2
		IF	fTotal>0
			oStOrdLH:Deb:=fTotal
		ELSE
			oStOrdLH:Cre:=Abs(fTotal)
		ENDIF
// 	ENDIF
	&& add empty row to mirror: 
	// {{ [1]deb,[2[]cre, [3]category, [4]gc, [5]accountid, [6]recno, [7]account#,[8]creditor,[9]bankacct,[10]persid}}
	AAdd(oStOrdLH:Amirror,{oStOrdLH:deb,oStOrdLH:cre,' ',' ',0,oStOrdLH:Recno,"","","",""})    
	oStOrdLH:DESCRIPTN:=cDesc
	RETURN FALSE
Method CreditorProc(cPersValue) class EditPeriodic
	PersonSelect(self,AllTrim(cPersValue),true,,"Creditor")
METHOD DELETE() CLASS EditPeriodic
 * delete record of TempTrans:
LOCAL ThisRec, CurRec as int
LOCAL oStOrdLH:=self:oSFStOrderLines:Server as StOrdLineHelp
LOCAL Success as LOGIC

CurRec:=oStOrdLH:Recno

IF Empty(oStOrdLH:Amirror)  && nothing to delete?
	RETURN FALSE
ENDIF

IF !Empty(CurRec) .and.!(oStOrdLH:eof.and.oStOrdLH:BOF)
	ADel(oStOrdLH:Amirror,CurRec)  && remove row from mirror
	ASize(oStOrdLH:Amirror,Len(oStOrdLH:Amirror)-1)
	self:oSFStOrderLines:DELETE(true)
	Success:=oStOrdLH:Pack()
	self:Totalise(true)
	IF oStOrdLH:eof
		oStOrdLH:GoTop()
	ENDIF 
	self:oSFStOrderLines:AddCredtr()
	self:oSFStOrderLines:Browser:REFresh()
ENDIF
RETURN true
METHOD RegAccount(omAcc, cItemname) CLASS EditPeriodic
	LOCAL oStOrdLH:=self:oSFStOrderLines:server as StOrdLineHelp
	LOCAL oAccount as sqlselect
	LOCAL ThisRec:=oStOrdLH:RecNo as int
	LOCAL CurGC as STRING
	if oStOrdLH==null_object
		return nil
	endif
	IF Empty(omAcc).or.omAcc==null_object .or.omAcc:EOF
		oStOrdLH:ACCOUNTID:=0
		oStOrdLH:ACCOUNTNAM := ""
		oStOrdLH:gc := ""
		oStOrdLH:ACCOUNTNbr:=""
	ELSE
		oAccount:=omAcc
		// aMirror: {{ [1]deb,[2[]cre, [3]category, [4]gc, [5]accountid, [6]recno, [7]account#,[8]creditor,[9]bankacct,[10]persid, [11]category}}
		oStOrdLH:ACCOUNTID :=  oAccount:accid
		oStOrdLH:ACCOUNTNAM := oAccount:Description
		oStOrdLH:ACCOUNTNbr:=oAccount:ACCNUMBER
		oStOrdLH:category:=oAccount:accounttype 
		if !Empty(oAccount:persid) 
			oStOrdLH:aMirror[ThisRec,10]:=oAccount:persid				
			if (oStOrdLH:cre-oStOrdLH:Deb)<0 .or.Empty(self:mCLNFrom).and.(oStOrdLH:cre-oStOrdLH:Deb)=0
				self:mCLNFrom:=Str(oAccount:persid,-1)
			endif
		endif

		if !oAccount:accounttype=="M"
			oStOrdLH:GC:=" "
		endif
	ENDIF
	// save in Mirror:
	oStOrdLH:aMirror[ThisRec,3]:=oStOrdLH:CATEGORY
	oStOrdLH:aMirror[ThisRec,4]:=oStOrdLH:GC
	oStOrdLH:aMirror[ThisRec,5]:=oStOrdLH:ACCOUNTID
	oStOrdLH:aMirror[ThisRec,7]:=oStOrdLH:ACCOUNTNbr

	IF !Empty(oStOrdLH:ACCOUNTID)
		self:oSFStOrderLines:DebCreProc()
		self:oSFStOrderLines:Browser:SetColumnFocus(#ACCOUNTNAM)
	ENDIF
	RETURN nil
METHOD RegPerson(oCLN,ItemName) CLASS EditPeriodic 
local oPers:=oCLN as SQLSelect, oPerB as SQLSelect 
LOCAL oStOrdLH:=self:oSFStOrderLines:Server as StOrdLineHelp
LOCAL ThisRec:=oStOrdLH:RecNo as int 

IF !Empty(oPers) .and. !IsNil(oPers).and.!oPers:EoF
	if  ItemName="Creditor"
		// check bank account available:
		if (oPerB:=SQLSelect{"select banknumber from personbank where persid="+Str(oPers:persid,-1)+" limit 1",oConn}):reccount<1
			(ErrorBox{self,"This creditor does not have a bank account"}):Show()
			return false
		endif
		oStOrdLH:CREDITOR:=oPers:persid
		oStOrdLH:CREDTRNAM:=GetFullName(Str(oPers:persid,-1)) 
	   oStOrdLH:aMirror[ThisRec,8]:=Str(oPers:persid,-1) 
   	oStOrdLH:BANKACCT:=oPerB:banknumber
		oStOrdLH:aMirror[ThisRec,8]:= oStOrdLH:CREDTRNAM 

// 		self:oDCmBankAccnt:FillUsing(oPers:GetBankAccnts()) 
// 		self:oDCmBankAccnt:CurrentItemNo:=1
	elseif ItemName="Giver"
		if Empty(oPers:accid)
			self:lMemberGiver:=false
		else
			self:lMemberGiver:=true
		endif
		self:mCLN :=  Str(oPers:persid,-1)
		self:cGiverName := GetFullName(self:mCLN)
		self:oDCmPerson:TextValue := self:cGiverName
	endif
else
	// nothing selected:
	if ItemName="Giver"
		if Empty(self:cGiverName)
			self:mCLN:=""
			self:lMemberGiver:=false
		endif
	elseif  ItemName="Creditor"
		oStOrdLH:CREDITOR:=0
		oStOrdLH:CREDTRNAM:=""
		oStOrdLH:aMirror[ThisRec,8]:=""
	endif
ENDIF
RETURN true
method ShowAssGift() class EditPeriodic 
	LOCAL oPer:=self:oStOrdr as SQLSelect
	local oOrdLnH:=self:oSFStOrderLines:Server as StOrdLineHelp 
   // aMirror: {{ [1]deb,[2[]cre, [3]category, [4]gc, [5]accountid, [6]recno, [7]account#,[8]creditor,[9]bankacct,[10]persid, [11]category}}
	IF AScan(oOrdLnH:aMirror,{|x|x[4]=="MG".or.x[4]=="AG".or.x[4]=="PF".or.x[3]="G".or.x[3]="D".or.x[3]="A"})>0       // to member?
		if AScan(oOrdLnH:aMirror,{|x|x[4]=="CH".and.x[2]<x[1]})==0
			self:oDCmPerson:Show()
			self:oDCGiverText:Show()
			self:oDCGiverText:TEXTValue:="Giver:"
			self:oCCPersonButton:Show()
			if Empty(self:mCLN).and.lNew
				self:mCLN:=SIDORG
			endif
			if !Empty(self:mCLN)
				self:oDCmPerson:Value:=GetFullName(self:mCLN)
			endif
		else                 // member gift? 
// 			if AScan(oOrdLnH:aMirror,{|x|x[4]=="MG"})>0 
				self:oDCmPerson:Hide()
				self:oDCGiverText:Hide()
				self:oCCPersonButton:Hide() 
				self:mCLN:=""
// 			endif
		endif
	else	
		self:oDCmPerson:Hide()
		self:oDCGiverText:Hide()
		self:oCCPersonButton:Hide()
		self:mCLN:=""
	endif
METHOD Totalise(lDelete) CLASS EditPeriodic
	LOCAL oStOrdLH:=self:oSFStOrderLines:server as StOrdLineHelp
	LOCAL fSum:=0 as FLOAT 
	LOCAL nCurRec,i as int
	Default(@lDelete,FALSE)
	
	nCurRec := oStOrdLH:Recno

	IF oStOrdLH:EOF.and.oStOrdLH:BOF
		fSum:=0
	ELSE
		AEval(oStOrdLH:Amirror,{|x| fSum:=Round(fSum+x[2]-x[1],DecAantal)})
	ENDIF
	self:oDCTotalText:Caption := Str(fSum,-1) 
	self:fTotal:=fSum
	// Append eventually a new record:
	IF !fTotal == 0 // total not zero?
		IF !ldelete.and.AScan(oStOrdLH:aMirror,{|x| x[1]==0.and.x[2]==0})=0 .and. AScan(oStOrdLH:Amirror,{|x|empty(x[5])})=0   // no empty transaction line and not delete?
			// Append new record:
			self:append()
			oStOrdLH:skip(-1)
			RETURN true
		ENDIF
	ELSE
		IF oStOrdLH:lastrec>1 .and. self:ValidateHelpLine(true,@i)
			self:oCCOKButton:SetFocus()
		ENDIF
	ENDIF

	RETURN
METHOD UpdateStOrd(dummy:=nil as logic) as logic CLASS EditPeriodic
	* Update order lines of an existing Standing Order with the modified data in StOrdLineHelp:
	LOCAL oOrig,oNew:=self:oSFStOrderLines:server as StOrdLineHelp

	LOCAL  NewMut,OrigSpec as FileSpec, NewIndex, OrigMut, OrigIndex as string
	LOCAL cSavFilter, cSavOrder as STRING, nSavRec as int, lSucc, lUpdated:=FALSE, lDeleted:=FALSE as LOGIC
	LOCAL pFilter as _CODEBLOCK
	LOCAL pnt as int 
	Local lNewPers,lError  as logic
	local oStmnt as SQLStatement

	NewIndex:=oNew:FileSpec:Drive+oNew:FileSpec:Path+oNew:FileSpec:FileName 
	NewMut:=FileSpec{NewIndex}
	NewMut:Extension:="CDX"
	lSucc:=oNew:CreateIndex(NewMut,"Strzero(RECNBR,8)+str(ACCOUNTID,-1)")
	IF !lSucc
		(ErrorBox{self:Owner,"Not able to make indexfile "+NewMut:FullPath+" for updates"}):show()
		RETURN FALSE
	ENDIF
	//oNew:SetOrder(1)
	oNew:SetOrder(NewMut)
	oNew:GoTop()

	OrigMut:=HelpDir+"\STOR"+StrTran(Time(),":")
	oOrig:=StOrdLineHelp{OrigMut+'.dbf'}
	IF !oOrig:Used.or.!oNew:Used.or.!lSucc
		(ErrorBox{self:owner,'Not able to make helpfile for updates'}):show()
		RETURN FALSE
	ENDIF

	self:oStOrdL:GoTop()
	do WHILE .not.oStOrdL:EOF
		oOrig:append()
		oOrig:ACCOUNTID := oStOrdL:ACCOUNTID
		oOrig:DESCRIPTN := oStOrdL:DESCRIPTN
		oOrig:REFERENCE := oStOrdL:REFERENCE
		oOrig:Deb := oStOrdL:Deb
		oOrig:cre :=  oStOrdL:cre
		oOrig:GC := oStOrdL:GC
		oOrig:SEQNR:=oStOrdL:SEQNR
		oOrig:RecNbr:=oStOrdL:Recno
		oOrig:category:=oStOrdL:accounttype 
		oOrig:CREDITOR:=oStOrdL:CREDITOR
		oOrig:BANKACCT:=oStOrdL:BANKACCT
		oStOrdL:Skip()
	ENDDO
	OrigSpec:=FileSpec{OrigMut}
	OrigSpec:Extension:="CDX"
	lSucc:=oOrig:CreateIndex(OrigSpec,"Strzero(RECNBR,8)+str(ACCOUNTID,-1)")
	oOrig:SetOrder(OrigSpec)
	oOrig:GoTop()                 
	IF !lSucc
		(ErrorBox{self:Owner,"Not able to make indexfile "+OrigSpec:FullPath+" for updates "}):show()
		RETURN FALSE
	ENDIF

	do WHILE !oOrig:EOF
		do CASE
		CASE !oNew:EOF .and. oOrig:RecNbr== oNew:RecNbr .and. !oNew:Deb==oNew:cre
			* Line changed?:

			IF oOrig:AccountId # oNew:AccountId .or.;
					oOrig:Deb # oNew:Deb .or.;
					oOrig:cre # oNew:cre
				* update fields in corresponding line:
				if !self:UpdStOrdLn(oNew,oOrig)
					lError:=true
					exit
				endif 
				lUpdated:=true
			ELSE
				* update fields in corresponding line:
				IF	oOrig:gc # oNew:gc.or.;
						oOrig:REFERENCE # oNew:REFERENCE.or.;
						oOrig:DESCRIPTN # oNew:DESCRIPTN.or.;
						oOrig:SEQNR # oNew:Recno.or.;
						oOrig:CREDITOR # oNew:CREDITOR.or.;
						oOrig:BANKACCT # oNew:BANKACCT
					if !self:UpdStOrdLn(oNew,oOrig)
						lError:=true
						exit
					endif 
					lUpdated:=true
				ENDIF
			ENDIF
			oNew:skip()
			oOrig:skip()
		CASE !oNew:EOF .and.oOrig:RecNbr == oNew:RecNbr .and. oNew:Deb==oNew:cre
			* Remove dummy transaction line:
			* Delete with origmut corresponding line:
			oStmnt:=SQLStatement{"delete from standingorderline where stordrid="+self:curStordid+" and seqnr="+Str(oOrig:SEQNR,-1),oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				lError:=true
				exit
			else
				lDeleted:=true
			endif
			oNew:skip()
			oOrig:skip()
		CASE oNew:EOF.or. oOrig:RecNbr < oNew:RecNbr .or. ;
				(oOrig:RecNbr == oNew:RecNbr .and. oNew:Deb==oNew:Cre)
			* Line removed:
			* Delete line which corresponds with orig:
			* Delete with origmut corresponding line:
			oStmnt:=SQLStatement{"delete from standingorderline where stordrid="+self:curStordid+" and seqnr="+Str(oOrig:SEQNR,-1),oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				lError:=true
				exit
			else
				lDeleted:=true
			endif
			oOrig:Skip()
		CASE !oNew:EOF .and.oNew:RecNbr = 0
			* Mutatie toegevoegd:
			IF !oNew:Deb==oNew:Cre // Ignore dummy transaction line
				* Append line from StOrdLineHelp
				lUpdated:=true
				self:UpdStOrdLn(oNew,oOrig)
			ENDIF
			oNew:Skip()
		ENDCASE
	ENDDO

	oNew:ClearIndex(NewIndex)
	Newmut:=FileSpec{NewIndex}
	NewMut:Extension:=oNew:INdexExt
	oNew:Close()
	// oNew:=null_object
	NewMut:DELETE()
	NewMut:Extension:="dbf"
	NewMut:DELETE()

	OrigIndex:=oOrig:FileSpec:Path+oOrig:FileSpec:FileName
	oOrig:ClearIndex(OrigIndex)
	oOrig:close()
	//oNew:close()
	// oOrig:=null_object
	FErase(OrigIndex)
	FErase (Origmut+".dbf")
	if lError
		return false
	else
		RETURN true
	endif
	
Method UpdStOrdLn(oNew as StOrdLineHelp, oOrig as StOrdLineHelp) as Logic class EditPeriodic 
local cStatement as string, oStmnt as SQLStatement
cStatement:=iif(Empty(oNew:RecNbr),"insert into","update")+" standingorderline set "+;
"accountid="+Str(oNew:ACCOUNTID,-1)+;
",deb="+Str(oNew:Deb,-1)+;
",cre="+Str(oNew:cre,-1)+;
",gc='"+oNew:GC+"'"+;
",stordrid="+self:curStordid+; 
",seqnr="+Str(oNew:Recno,-1)+;
",reference='"+oNew:REFERENCE+"'"+;
",descriptn='"+oNew:DESCRIPTN+"'"+; 
iif(Str(oNew:ACCOUNTID,-1) == sCre,",creditor="+Str(oNew:CREDITOR,-1)+",bankacct='"+oNew:BANKACCT+"'",",creditor=0,bankacct=''")+;
iif(Empty(oNew:RecNbr),""," where stordrid="+self:curStordid+" and seqnr="+Str(oNew:SEQNR,-1)) 
oStmnt:=SQLStatement{cStatement,oConn}
oStmnt:Execute()
if Empty(oStmnt:status)
	return true
else
	return false
endif
method ValidateHelpLine(lNoMessage:=false as logic,ErrorLine ref int) as logic class EditPeriodic 
	* lNoMessage: True: Do not show error message
	LOCAL lValid := true as LOGIC
	LOCAL cError as STRING
	LOCAL oStOrdLH:=self:oSFStOrderLines:Server as StOrdLineHelp
	LOCAL mAccId as int
	LOCAL i:=0 as int

	DO WHILE lValid .and. i < Len(oStOrdLH:Amirror)
		++i
		IF oStOrdLH:Amirror[i,1] == oStOrdLH:Amirror[i,2] //deb=cre: skip empty line
			loop
		ENDIF
		IF Empty(oStOrdLH:Amirror[i,5]) //  deb,cre, category, gc, accountid, recno, account#
			lValid := FALSE
			cError := self:oLan:WGet("Account obliged")+"!"
		ELSEIF (ADMIN=="WO".or. ADMIN="HO") 
			IF oStOrdLH:Amirror[i,3] = "M"
				IF Empty(AScan({'AG','CH','OT','PF','MG'},oStOrdLH:Amirror[i,4])) //GC
					lValid := FALSE
					cError := self:oLan:WGet("Assessment codes are")+": AG CH PF MG"
				ELSEIF oStOrdLH:Amirror[i,4] = 'MG' //GC
					mAccId :=oStOrdLH:Amirror[i,5] //accountId
					IF !self:lMemberGiver .and. AScan(oStOrdLH:aMirror,{|x| x[4]=="CH".and.!x[5]==mAccId.and.x[2]<x[1]}) = 0
						lValid := FALSE
						cError := self:oLan:WGet('Donor no member, thus MG not allowed')
					ENDIF
				ENDIF
			ELSEIF !Empty(oStOrdLH:aMirror[i,4]).and.!oStOrdLH:aMirror[i,4]=="OT" //GC
				lValid := FALSE
				cError := self:oLan:WGet("Assessment code exclusively for member")
			ENDIF
		ENDIF
	ENDDO	
	IF !lValid.and.!lNomessage
		(ErrorBox{,cError}):Show()
		// 	oStOrdLH:RecNo:=oStOrdLH:aMirror[i,6]
		self:oSFStOrderLines:GoTo(i)
		ErrorLine:=i
	ENDIF
	RETURN lValid
	
METHOD ValidatePeriodic() CLASS EditPeriodic
	LOCAL lValid := TRUE AS LOGIC
	LOCAL cError AS STRING
	LOCAL oPer:=self:oStOrdr as sqlselect
	LOCAL oStOrdLH:=self:oSFStOrderLines:Server as StOrdLineHelp  
	local iPtr,i,curRec as int

	*Check obliged fields:
	IF !self:fTotal=0.00
		lValid := FALSE
		cError :=  "Incomplete standing order"
	ELSEIF Empty(mday)
		lValid := FALSE
		cError :=  "You must enter a record day in month"
		self:oDCmday:SetFocus()
	ELSEIF Empty(mperiod)
		lValid := FALSE
		cError :=  "You must enter a period"
		self:oDCmperiod:SetFocus()
 	ELSEIF Empty(SELF:oDCmIDAT:SelectedDate)
		lValid := FALSE
		cError :=  "You must enter a Start date"
		SELF:oDCmIdat:SetFocus()		
   	ELSEIF !Empty(SELF:odcmEdat:SelectedDate).and.SELF:odcmIdat:SelectedDate>SELF:odcmEdat:SelectedDate
		lValid := FALSE
		cError :=  "Enter a Enddate after the startdate"
		SELF:oDCmIdat:SetFocus()
	ELSEIF !lNew.and..not.Empty(oPer:LstRecording).and.self:odcmIdat:SelectedDate<oPer:idat
		lValid := FALSE
		cError :=  "Standing Order already recorded, do not shift back Startdate"
		SELF:oDCmIdat:SetFocus()
	ELSEIF !lNew.and.!Empty(oPer:LstRecording).and.!Empty(self:odcmEdat:SelectedDate).and.;
		self:odcmEdat:SelectedDate<oPer:LstRecording
		lValid := FALSE
		cError :=  "Enddate should be after last transaction date "+DToC(oPer:LstRecording)
		SELF:oDCmEdat:SetFocus()
	elseif (iPtr:=AScan(oStOrdLH:Amirror,{|x|Empty(x[5]).and.x[2]<>x[1]}))>0 
		lValid := FALSE
		cError :=  "Select an account"
		self:oSFStOrderLines:GoTo(iPtr)
// 	elseif AScan(oStOrdLH:Amirror,{|x|x[2]<>x[1]})=0 .and.Len(oStOrdLH:Amirror)>0
// 		lValid := FALSE
// 		cError :=  "Enter debit / credit amount"
	elseif (iPtr:=AScan(oStOrdLH:aMirror,{|x|x[5]==val(sCRE) .and.Empty(x[8]).and.x[2]<>x[1]}))>0 
		lValid := FALSE
		cError :=  "Select a creditor"
		self:oDCmPerson:SetFocus()
	elseIF AScan(oStOrdLH:aMirror,{|x| x[4]=="AG".or.x[4]=="MG"})>0
		i:= AScan(oStOrdLH:aMirror,{|x| x[4]=="CH".and.x[2]<x[1]})
		IF i > 0
			self:mCLNFrom:=oStOrdLH:Amirror[i,10]
         curRec:=i  // RECNO
         if !Empty(self:mCLN).and. !self:mCLNFrom==self:mCLN
           	cError := GetFullName(self:mCLNFrom)+";  " +GetFullName(self:mCLN)
				lValid := FALSE
			ELSE
				self:mCLN:=self:mCLNFrom
        	ENDIF
			do WHILE i>0
				i:=AScan(oStOrdLH:aMirror,{|x| x[4]=="CH".and.x[2]<x[1]},i+1) 
				if i>0
					if Empty(cError)
		           	cError := GetFullName(self:mCLNFrom)+";  "
					endif				
					cError += GetFullName(oStOrdLH:aMirror[i,10])+"; "
					lValid := FALSE
				endif
			ENDDO
      endif
		iF !lValid
			cError:=self:oLan:WGet("Givers")+" "+self:oLan:WGet("are")+" "+cError+"  "+self:oLan:WGet("Only one giver allowed")+"!" 
			self:oSFStOrderLines:GoTo(curRec)
		elseif Empty(self:mCLN)
			lValid := FALSE
			cError :=  "Select a giver"
			self:oDCmPerson:SetFocus() 			
		endif
	endif 
	

 	IF ! lValid
		(ErrorBox{,cError}):Show()
	ENDIF

	RETURN lValid
METHOD RegAccount(omAcc,ItemName) CLASS PeriodicBrowser
	LOCAL oAcc as SQLSelect
	local mRekFrom  as string
	if ItemName="Account from"
		IF Empty(omAcc).or.omAcc==null_object
			self:cAccId:= ""
			self:oDCSearchRek:TEXTValue := ""
			self:cAccountNameFrom := ""
// 			self:cWhere:=""
		ELSE
			oAcc:=omAcc		
			self:cAccId :=  Str(oAcc:accid,-1)
			self:oDCSearchRek:TextValue := AllTrim(oAcc:Description)
			self:cAccountNameFrom := AllTrim(oAcc:Description)
// 			self:cWhere:='ACCOUNTID='+self:cAccId
		ENDIF
// 		self:Refresh()
	endif 
RETURN true
STATIC DEFINE PROGRESSPER_CANCELBUTTON := 100 
STATIC DEFINE PROGRESSPER_PROGRESSBAR := 101 
CLASS StandingOrderJournal 
	protect oCurr as Currency 
	export mxrate as float
	protect oLan as Language
  	PROTECT oPro as ProgressPer 

	declare method journal,recordstorders 
Method Init() class StandingOrderJournal
	// self:oLan:=SQLSelect{"select * from language",oConn}
	return self
method journal(datum as date, oStOrdL as SQLSelect) as logic  class StandingOrderJournal
	*****************************************************************
	* Recording of standing order as transaction
	*
	* Returns: .t. : correct
	*          .f. : no transaction made
	*****************************************************************
	// LOCAL deb_ind AS LOGIC
	LOCAL soortvan, soortnaar, PrsnVan, PrsnNaar, cTrans, mBank,CurrFrom, CurrTo,TransCurr as STRING
	local MultiFrom, lError as logic 
	local deb,cre, DEBFORGN,CREFORGN as float
	local CurStOrdrid as int
	local oPersBank as SQLSelect 
	local oTrans,oBord,oStmnt as SQLStatement
	local i as int
	local aTrans:={} as array  //array with transactions to record: {{1:accid,2:dat,3:description,4:docid,5:deb,6:cre,7:debforgn,8:creforgn,9:currency,10:gc,11:persid,12:mBank,13:STORDRID},...}
	*Check validity of standing order:
	CurStOrdrid:=oStOrdL:stordrid
	IF !((Empty(oStOrdL:edat).or.datum <=oStOrdL:edat) .and.datum <=Today())
		lError:=true
	endif
	if CurStOrdrid=255
		CurStOrdrid:=CurStOrdrid
	endif 

	do while !oStOrdL:EOF .and. oStOrdL:stordrid==CurStOrdrid
		if !lError
			IF !Empty(dat_controle(datum,true))
				lError:=true
			elseif Empty(oStOrdL:ACCNUMBER)
				* Check account:
				(WarningBox{,self:oLan:WGet("Periodic Records"),Str(oStOrdL:ACCOUNTID,-1)+": "+self:oLan:WGet("unknown account, skipped")+" in standing order: "+Str(CurStOrdrid,-1)}):Show()
				lError:=true
			elseif Empty(oStOrdL:active)
				* Check account:
				(WarningBox{,self:oLan:WGet("Periodic Records"),Str(oStOrdL:ACCNUMBER,-1)+": "+self:oLan:WGet("inactive account, skipped")+" in standing order: "+Str(CurStOrdrid,-1)}):Show()
				lError :=true
			endif 
		endif
		If !lError
			mBank:=""
			if Str(oStOrdL:ACCOUNTID,-1)== sCRE .and. !Empty(oStOrdL:CREDITOR)
				// payment to creditor
				if CountryCode="31"
					oPersBank:=SQLSelect{"select banknumber,persid from personbank where banknumber='"+oStOrdL:BANKACCT+"'",oConn}
					if oPersBank:RECCOUNT>0
						if oPersBank:persid=oStOrdL:CREDITOR
							mBank:=oStOrdL:BANKACCT
						else
							(WarningBox{,self:oLan:WGet("Periodic Records"),"Bank account "+oStOrdL:BANKACCT+" does not belang to person "+Str(oStOrdL:CREDITOR,-1)+" in standing order: "+Str(CurStOrdrid,-1)+" (skipped)"}):Show()
							lError:=true
						endif
					else
						oPersBank:=SQLSelect{"select banknumber,persid from personbank where persid='"+Str(oStOrdL:CREDITOR,-1)+"'",oConn}
						if oPersBank:RECCOUNT>0
							mBank:=oPersBank:banknumber 
						endif
					endif
					if !lError .and.Empty(mBank)
						(WarningBox{,self:oLan:WGet("Periodic Records"),"No bank account for person "+Str(oStOrdL:CREDITOR,-1)+" in standing order: "+Str(CurStOrdrid,-1)+" (skipped)"}):Show()
						lError:=true
					endif					
				endif
			endif
		ENDIF
		if !lError
			MultiFrom:=iif(oStOrdL:MULTCURR=1,true,false)
			CurrFrom:=oStOrdL:CurrFrom
			* make new transaction: 
			deb:=oStOrdL:deb 
			cre:=oStOrdL:cre
			if !Empty(oStOrdL:Currency) .and. !oStOrdL:Currency==sCurr
				deb:=Round((oCurr:GetROE(oStOrdL:Currency,datum))*deb,DecAantal)	
				cre:=Round((oCurr:GetROE(oStOrdL:Currency,datum))*cre,DecAantal)	
			endif
			TransCurr:=sCurr
			if MultiFrom .or. CurrFrom == oStOrdL:Currency
				TransCurr:=oStOrdL:Currency 
				DEBFORGN:=deb
				CREFORGN:=cre
			elseif !CurrFrom==sCurr
				// recalculate to foreign currency:
				DEBFORGN:=Round(deb/(self:oCurr:GetROE(CurrFrom,datum)),DecAantal)
				CREFORGN:=Round(cre/(self:oCurr:GetROE(CurrFrom,datum)),DecAantal)
				TransCurr:=CurrFrom
			endif	
			// save in aTrans: {{1:accid,2:dat,3:description,4:docid,5:deb,6:cre,7:debforgn,8:creforgn,9:currency,10:gc,11:persid,12:mBank},...}
			AAdd(aTrans,{Str(oStOrdL:ACCOUNTID,-1),datum,oStOrdL:DESCRIPTN,oStOrdL:docid,deb,cre,DEBFORGN,CREFORGN,TransCurr,oStOrdL:GC,;
				iif(oStOrdL:GIFTALWD==1.and. !Empty(oStOrdL:persid).and. cre > deb  .and. !Str(oStOrdL:ACCOUNTID,-1) == sCRE,oStOrdL:persid,iif(Str(oStOrdL:ACCOUNTID,-1)==sCRE,oStOrdL:CREDITOR,0)),mBank} )
		endif
		oStOrdL:skip()
	enddo
	// perform recording if transactions (when everything is OK:
	if !lError 
		SQLStatement{"start transaction",oConn}:execute()
		cTrans:= ""
		for i:=1 to Len(aTrans) 
			oTrans:=SQLStatement{"insert into transaction (accid,dat,description,docid,deb,cre,debforgn,creforgn,currency,gc,persid,userid,seqnr"+iif(i==1,"",",TransId")+;
				") values ('"+aTrans[i,1]+"','"+SQLdate(aTrans[i,2])+"','"+AddSlashes(aTrans[i,3])+"','"+AddSlashes(aTrans[i,4])+;
				"','"+Str(aTrans[i,5],-1)+"','"+Str(aTrans[i,6],-1)+;
				"','"+Str(aTrans[i,7],-1)+"','"+Str(aTrans[i,8],-1)+;
				"','"+aTrans[i,9]+"','"+aTrans[i,10]+"','"+Str(aTrans[i,11],-1)+"','"+LOGON_EMP_ID+"','"+Str(i,-1)+iif(i==1,"","','"+cTrans)+"')",oConn}
			oTrans:execute()
			if oTrans:NumSuccessfulRows<1 
				LogEvent(,"stmnt:"+oTrans:SQLString+CRLF+"error:"+oTrans:Status:description,"logsql")
				lError:=true
				exit
			endif
			if Empty(cTrans)
				cTrans:=SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)
			endif
			if !ChgBalance(aTrans[i,1], datum, aTrans[i,5], aTrans[i,6], aTrans[i,7], aTrans[i,8],aTrans[i,9])
				lError:=true
				exit
			endif
			if aTrans[i,1]==sCRE .and. !Empty(aTrans[i,12])
				// payment to creditor
				if CountryCode="31"  
					// make bankorder:
					oBord:=SQLStatement{"insert into bankorder (accntfrom,amount,description,banknbrcre,datedue,stordrid) values ('"+sCRE+"','"+;
						Str(Round(aTrans[i,6]-aTrans[i,5],DecAantal),-1)+"','"+AddSlashes(aTrans[i,3])+"','"+aTrans[i,12]+"','"+SQLdate(aTrans[i,2])+"','"+Str(CurStOrdrid,-1)+"')",oConn}
					oBord:execute()
					if oBord:NumSuccessfulRows<1
						lError:=true
						exit
					endif
				endif
			endif
		next
		if !lError
			&&skip to next month
			oStmnt:=SQLStatement{"update standingorder set lstrecording='"+SQLdate(datum)+"' where stordrid="+Str(CurStOrdrid,-1),oConn}
			oStmnt:execute()
			if Empty(oStmnt:Status)
				SQLStatement{"commit",oConn}:execute()
			else
				lError:=true
			endif
		endif
		if lError
			LogEvent(,self:oLan:WGet("standingorder could not be executed")+":ID-"+Str(CurStOrdrid,-1)+" date:"+DToC(datum))
			ErrorBox{,self:oLan:WGet("standingorder could not be executed")+":ID-"+Str(CurStOrdrid,-1)+" date:"+DToC(datum)}:Show()
			SQLStatement{"rollback",oConn}:execute()
		endif
	endif


	return !lError
METHOD recordstorders(dummy:=nil as logic) as logic CLASS StandingOrderJournal
	* Daily execution of Standing Orders
	LOCAL nwdat, checkdate,idat,edat as date, tel:=0 as int, first:=true as LOGIC
	LOCAL iPeriod,nCurRec,nAdv,nDay as int 
	local oStOrdL as SQLSelect
	

	if self:oCurr==null_object
		self:oCurr:=Currency{"Recording standing orders"}
	endif
	oStOrdL:=SQLSelect{"select s.stordrid,s.day,s.period,s.docid,s.currency,s.idat,s.edat,s.lstrecording,s.persid,"+;
	"l.accountid,l.deb,l.cre,l.descriptn,l.gc,l.creditor,l.bankacct,"+; 
	"a.currency as currfrom,a.multcurr,a.giftalwd,a.accnumber,a.active"+;
	" from standingorder s,standingorderline l left join account a on (a.accid=l.accountid) where l.stordrid=s.stordrid and "+;
	"(edat is null or edat>=CurDate()) and "+;
	"(lstrecording is null or (DATE_ADD(lstrecording,INTERVAL period MONTH)<=curdate() and "+;
	"(edat is null or DATE_ADD(lstrecording,INTERVAL period MONTH)<=edat))) and idat<=CurDate()"+;
	" order by s.stordrid,l.seqnr",oConn} 
	if oStOrdL:RECCOUNT <1 
		return false
	endif 
	self:oLan:=Language{}
	DO WHILE !oStOrdL:EOF
		checkdate:=Today()
		iPeriod:=Max(oStOrdL:period,1) 
		nDay:=oStOrdL:day
		idat:=oStOrdL:idat 
		edat:=iif(Empty(oStOrdL:edat),null_date,oStOrdL:edat)
		IF Empty(oStOrdL:LstRecording) .or.oStOrdL:LstRecording < oStOrdL:idat 
			IF oStOrdL:day>=Day(idat)
				nwdat:=Getvaliddate(oStOrdL:day,Month(idat),Year(idat))
			ELSE   && record date before idat
				nwdat:=Getvaliddate(oStOrdL:day,Month(idat)+iPeriod,Year(idat))
			ENDIF
		ELSE  && recorded previously:
			nwdat:=Getvaliddate(oStOrdL:day,Month(oStOrdL:LstRecording)+iPeriod,Year(oStOrdL:LstRecording)) 
		ENDIF

		*Checking validity standing order and executing it:
		IF first
			first:=FALSE
			oMainWindow:STATUSMESSAGE("Busy with standing orders:")
			self:oPro:=ProgressPer{,self}
			self:oPro:Caption:="Recording standing orders"
			self:oPro:SetRange(1,oStOrdL:RECCOUNT)
			self:oPro:SetUnit(1)
			self:oPro:Show()
		ENDIF
		nCurRec:=oStOrdL:Recno
		do while self:journal(nwdat,oStOrdL)  
			nwdat:=Getvaliddate(nDay,Month(nwdat)+iPeriod,Year(nwdat)) 
			IF (Empty(edat).or.nwdat <=edat) .and.nwdat <=checkdate // more transactions to made?
				oStOrdL:GoTo(nCurRec) // reset orderlines
			else
				exit
			endif
		enddo
		IF !First
			nAdv:=Max(1,oStOrdL:Recno-nCurRec)
			self:oPro:AdvancePro(nAdv)
		ENDIF
	ENDDO 

	IF !self:oPro==null_object
		self:oPro:EndDialog()
		self:oPro:Destroy()
	ENDIF
	RETURN true
ACCESS AccNbrCol() CLASS StOrderLines
RETURN self:oDBACCOUNTNBR:NameSym

	
METHOD DebCreProc() CLASS StOrderLines
	LOCAL recnr as int
	LOCAL oStOrdLH:=self:server as StOrdLineHelp
	LOCAL lFound as LOGIC
	LOCAL i as int
	LOCAL nCurRec, CurRec, ThisRec as int
	LOCAL mAccId as string

	CurRec := oStOrdLH:Recno
	//CurRec:=AScan(oStOrdLH:aMirror,{|x|x[6]==nCurRec})
	oStOrdLH:Amirror[CurRec,1]:=oStOrdLH:deb
	oStOrdLH:Amirror[CurRec,2]:=oStOrdLH:cre
	oStOrdLH:Amirror[CurRec,5]:=oStOrdLH:ACCOUNTID 
	oStOrdLH:Amirror[CurRec,6]:=oStOrdLH:Recno 
	oStOrdLH:Amirror[CurRec,7]:=oStOrdLH:ACCOUNTNBR 
	
	self:Browser:SuspendUpdate()
	IF oStOrdLH:CATEGORY == 'M'		
		mAccId:=Str(oStOrdLH:ACCOUNTID,-1)
		IF oStOrdLH:deb > oStOrdLH:cre
			oStOrdLH:gc := 'CH' 
			oStOrdLH:Amirror[oStOrdLH:Recno,4]:=oStOrdLH:gc  && save in mirror

			* Change AG's present to MG's:
			recnr := oStOrdLH:Recno 
			oStOrdLH:GoTop()
			Do while !oStOrdLH:EOF
				IF !oStOrdLH:Recno==recnr
					IF (oStOrdLH:gc=='AG'.or.Empty(oStOrdLH:GC)).and. oStOrdLH:CATEGORY =='M' .and. !alltrim(oStOrdLH:ACCOUNTID)==mAccId
						oStOrdLH:gc := 'MG'
						oStOrdLH:Amirror[oStOrdLH:Recno,4]:=oStOrdLH:gc  && save in mirror
					ENDIF
				ENDIF
				oStOrdLH:Skip()
			enddo
			oStOrdLH:Goto(recnr)
		ELSEIF oStOrdLH:deb = oStOrdLH:cre
			oStOrdLH:gc := '  '
		ELSE
			IF !oStOrdLH:gc == 'PF' 
				oStOrdLH:gc := 'AG'
				IF self:Owner:lMemberGiver .or.AScan(oStOrdLH:aMirror,{|x|x[4]=="CH".and.x[2]<x[1]})>0
					oStOrdLH:gc := 'MG'
				ENDIF
				oStOrdLH:Amirror[oStOrdLH:Recno,4]:=oStOrdLH:gc  && save in mirror
			endif
		ENDIF
	ELSE
		IF oStOrdLH:gc == 'CH'
			* Reset MG present:
			recnr := oStOrdLH:Recno
			oStOrdLH:GoTop()
			DO WHILE oStOrdLH:locate(,{|| oStOrdLH:gc =='MG'})
				oStOrdLH:gc := 'AG'
				oStOrdLH:Amirror[oStOrdLH:Recno,4]:=oStOrdLH:gc  && save in mirror
			ENDDO
			oStOrdLH:Goto(recnr)
		ENDIF
		oStOrdLH:gc := '  ' 
		oStOrdLH:Amirror[oStOrdLH:Recno,4]:=oStOrdLH:gc  && save in mirror
	ENDIF
	self:Owner:ShowAssGift()
	self:AddCredtr()
	self:Owner:Totalise()
	self:Browser:RestoreUpdate()
	RETURN
CLASS StOrdLnBrowser INHERIT DatabrowserExtra
method ColumnFocusChange(oColumn, lHasFocus)   CLASS StOrdLnBrowser
	LOCAL oStOrdLH:=self:Owner:Server as StOrdLineHelp
	LOCAL ThisRec, nErr as int 
	Local myValue as float
	LOCAL myColumn:=oColumn as DataColumn
	SUPER:ColumnFocusChange(oColumn, lHasFocus)
	IF  Empty(oStOrdLH:aMirror)  && still empty ?   ingore change column during filling screen
		RETURN
	ENDIF
	ThisRec:=oStOrdLH:RecNo
	IF myColumn:NameSym == #ACCOUNTNBR
		IF !AllTrim(myColumn:TextValue) == ;
				AllTrim(oStOrdLH:aMirror[ThisRec,7]) && value changed?
			oStOrdLH:aMirror[ThisRec,7]:= AllTrim(myColumn:TextValue) 
			self:Owner:Owner:ACCOUNTProc(myColumn:VALUE)
		ENDIF
	ELSEIF myColumn:NameSym == #DEB
		IF !Round(myColumn:VALUE,2) == Round(oStOrdLH:aMirror[ThisRec,1],2)
			self:Owner:DebCreProc()
			self:Owner:Owner:Totalise()
		ENDIF
	ELSEIF myColumn:NameSym == #CRE 
		IF !Round(myColumn:VALUE,2) == Round(oStOrdLH:aMirror[ThisRec,2],2)
			self:Owner:DebCreProc()
			self:Owner:Owner:Totalise()
		ENDIF
	ELSEIF myColumn:NameSym == #GC
		IF !AllTrim(myColumn:VALUE) == AllTrim(oStOrdLH:aMirror[ThisRec,4])
			oStOrdLH:aMirror[ThisRec,4]:=AllTrim(myColumn:VALUE)
			myColumn:TextValue:= myColumn:Value
			oStOrdLH:gc:=myColumn:VALUE
			oStOrdLH:aMirror[ThisRec,4]:=oStOrdLH:gc  && save in mirror
			self:Owner:Owner:ValidateHelpLine(false,@nErr)
		ENDIF
	ELSEIF myColumn:NameSym== #ACCOUNTNAM .and. lHasFocus
		self:SetColumnFocus(#DESCRIPTN)
	ELSEif myColumn:NameSym == #CREDTRNAM 
		IF oStOrdLH:aMirror[ThisRec,5]==Val(sCRE) .and. !AllTrim(myColumn:TextValue) == ;
				AllTrim(oStOrdLH:aMirror[ThisRec,8]) && value changed?
			oStOrdLH:aMirror[ThisRec,8]:= AllTrim(myColumn:TextValue) 
			self:Owner:Owner:CreditorProc(myColumn:VALUE)
		ENDIF
	ELSEIF myColumn:NameSym == #BANKACCT
		IF !AllTrim(myColumn:VALUE) == AllTrim(oStOrdLH:aMirror[ThisRec,9])
			oStOrdLH:aMirror[ThisRec,9]:=AllTrim(myColumn:VALUE)
			myColumn:TextValue:= myColumn:VALUE
			oStOrdLH:BANKACCT:=myColumn:VALUE
			oStOrdLH:aMirror[ThisRec,9]:=oStOrdLH:BANKACCT  && save in mirror
		ENDIF

	ENDIF
	RETURN nil 
METHOD GetCurCell CLASS StOrdLnBrowser
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
		RETURN {NwValue,oSingle:Value,Upper(oSingle:Fieldspec:HyperLabel:Name)}
	ENDIF
METHOD Init(oWindow) CLASS StOrdLnBrowser
	SUPER:Init(oWindow)
	self:ChangeBackground(Brush{Color{255,255,255}},gblHiText)
	self:ChangeTextColor(ColorBlue,gblHiText)
RETURN self
METHOD SetColumnFocus(ColumnSym)  CLASS StOrdLnBrowser
	// set browser to requird column
	LOCAL oColumn as JapDataColumn
	IF IsSymbol(ColumnSym)
		oColumn := self:GetColumn(ColumnSym)
		RETURN SUPER:SetColumnFocus(oColumn)
	ELSE	
		RETURN SUPER:SetColumnFocus(ColumnSym)
	ENDIF
