METHOD ACCOUNTProc(cAccValue) CLASS EditStandingOrder
	AccountSelect(self,AllTrim(cAccValue),"Account",true,"a.active=1")
	RETURN nil 
METHOD append() CLASS EditStandingOrder
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
	// {{ [1]deb,[2[]cre, [3]category, [4]gc, [5]accountid, [6]recno, [7]account#,[8]creditor,[9]bankacct,[10]persid,[11]INCEXPFD},[12]depid}
	AAdd(oStOrdLH:Amirror,{oStOrdLH:Deb,oStOrdLH:Cre,' ',' ',0,oStOrdLH:Recno,"","","","","",0})    
	oStOrdLH:DESCRIPTN:=cDesc
	RETURN FALSE
Method CreditorProc(cPersValue) class EditStandingOrder
	PersonSelect(self,AllTrim(cPersValue),true,,"Creditor")
METHOD DELETE() CLASS EditStandingOrder
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
METHOD RegAccount(omAcc, cItemname) CLASS EditStandingOrder
	LOCAL oStOrdLH:=self:oSFStOrderLines:server as StOrdLineHelp
	LOCAL oAccount as sqlselect
	LOCAL ThisRec:=oStOrdLH:RecNo,recnr as int
	LOCAL CurGC as STRING
	if oStOrdLH==null_object
		return nil
	endif
	IF Empty(omAcc).or.omAcc==null_object .or.omAcc:EOF
		oStOrdLH:ACCOUNTID:=0
		oStOrdLH:ACCOUNTNAM := ""
		oStOrdLH:gc := ""
		oStOrdLH:ACCOUNTNBR:="" 
		oStOrdLH:DEPID:=0
	ELSE
		oAccount:=omAcc
		// aMirror: {{ [1]deb,[2[]cre, [3]category, [4]gc, [5]accountid, [6]recno, [7]account#,[8]creditor,[9]bankacct,[10]persid, [11]INCEXPFD}
		oStOrdLH:ACCOUNTID :=  ConI(oAccount:accid)
		oStOrdLH:ACCOUNTNAM := oAccount:Description
		oStOrdLH:ACCOUNTNbr:=oAccount:ACCNUMBER
		oStOrdLH:category:=Upper(oAccount:accounttype)
		oStOrdLH:INCEXPFD:=oAccount:INCEXPFD
		oStOrdLH:DEPID:=ConI(oAccount:department) 

		if !Empty(oAccount:persid) .and.(oStOrdLH:category=="M" .or.oStOrdLH:category='K') 
			oStOrdLH:aMirror[ThisRec,10]:=oAccount:persid				
			if (oStOrdLH:cre-oStOrdLH:Deb)<0 .or.Empty(self:mCLNFrom).and.(oStOrdLH:cre-oStOrdLH:Deb)=0
				self:mCLNFrom:=Str(oAccount:persid,-1)
			endif
		endif

		if !(oAccount:accounttype=="M" .or.oAccount:accounttype=='K')
			if oStOrdLH:gc=="CH"
				// replace MG if needed: 
				recnr := 0
				do WHILE (recnr:=AScan(oStOrdLH:aMirror,{|x| x[4] =='MG'},recnr+1))>0
					oStOrdLH:Goto(recnr)
					oStOrdLH:gc := 'AG'
					oStOrdLH:aMirror[recnr,4]:=oStOrdLH:gc  && save in mirror
				ENDDO
				oStOrdLH:Goto(ThisRec)
			endif
			oStOrdLH:gc:=" "
		ENDIF
	endif
	// save in Mirror:
	oStOrdLH:aMirror[ThisRec,3]:=oStOrdLH:category
	oStOrdLH:aMirror[ThisRec,4]:=oStOrdLH:gc
	oStOrdLH:aMirror[ThisRec,5]:=oStOrdLH:ACCOUNTID
	oStOrdLH:aMirror[ThisRec,7]:=oStOrdLH:ACCOUNTNBR
	oStOrdLH:aMirror[ThisRec,11]:=AllTrim(oStOrdLH:INCEXPFD)
	oStOrdLH:aMirror[ThisRec,12]:=oStOrdLH:DEPID
	

	IF !Empty(oStOrdLH:ACCOUNTID)
		self:oSFStOrderLines:DebCreProc()
		self:oSFStOrderLines:Browser:SetColumnFocus(#ACCOUNTNAM)
	ENDIF
	RETURN nil
METHOD RegPerson(oCLN,ItemName) CLASS EditStandingOrder 
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
method ShowAssGift() class EditStandingOrder 
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
METHOD Totalise(lDelete) CLASS EditStandingOrder
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
METHOD UpdateStOrd(lChanged ref logic) as logic CLASS EditStandingOrder
	* Update order lines of an existing Standing Order with the modified data in StOrdLineHelp: 
	// lChanged returned : true if something has been changed in the database
	LOCAL oOrig,oNew:=self:oSFStOrderLines:server as StOrdLineHelp

	LOCAL  NewMut,OrigSpec as FileSpec, NewIndex, OrigMut, OrigIndex as string
	LOCAL cSavFilter, cSavOrder as STRING, nSavRec as int, lSucc, lUpdated:=FALSE, lDeleted:=FALSE as LOGIC
	LOCAL pFilter as _CODEBLOCK
	LOCAL pnt as int 
	Local lNewPers,lError  as logic
	local oStmnt as SQLStatement

	NewIndex:=oNew:FileSpec:Drive+oNew:FileSpec:Path+oNew:FileSpec:FileName 
	NewMut:=FileSpec{NewIndex}
// 	NewMut:Extension:="NTX"
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
// 	OrigSpec:Extension:="NTX"
	lSucc:=oOrig:CreateIndex(OrigSpec,"Strzero(RECNBR,8)+str(ACCOUNTID,-1)")
	oOrig:SetOrder(OrigSpec)
	oOrig:GoTop()                 
	IF !lSucc
		(ErrorBox{self:Owner,"Not able to make indexfile "+OrigSpec:FullPath+" for updates "}):show()
		RETURN FALSE
	ENDIF

	do WHILE !oOrig:EOF .or. !oNew:EOF
		do CASE
		CASE !oNew:EOF .and. !oOrig:EOF .and. oOrig:RecNbr== oNew:RecNbr .and. !oNew:Deb==oNew:cre
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
		CASE !oNew:EOF .and. !oOrig:EOF .and.oOrig:RecNbr == oNew:RecNbr .and. oNew:Deb==oNew:cre
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
		CASE oNew:EOF.or. !oOrig:EOF  .and.(oOrig:RecNbr < oNew:RecNbr .or. ;
				(oOrig:RecNbr == oNew:RecNbr .and. oNew:Deb==oNew:cre))
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
		if lUpdated .or. lDeleted
			lChanged:=true
		endif
		RETURN true
	endif
	
Method UpdStOrdLn(oNew as StOrdLineHelp, oOrig as StOrdLineHelp) as Logic class EditStandingOrder 
local cStatement as string, oStmnt as SQLStatement
cStatement:=iif(Empty(oNew:RecNbr),"insert into","update")+" standingorderline set "+;
"accountid="+Str(oNew:ACCOUNTID,-1)+;
",deb="+Str(oNew:Deb,-1)+;
",cre="+Str(oNew:cre,-1)+;
",gc='"+oNew:GC+"'"+;
",stordrid="+self:curStordid+; 
",seqnr="+Str(oNew:Recno,-1)+;
",reference='"+AddSlashes(AllTrim(oNew:REFERENCE))+"'"+;
",descriptn='"+AddSlashes(alltrim(oNew:DESCRIPTN))+"'"+; 
iif(Str(oNew:ACCOUNTID,-1) == sCre,",creditor="+Str(oNew:CREDITOR,-1)+",bankacct='"+oNew:BANKACCT+"'",",creditor=0,bankacct=''")+;
iif(Empty(oNew:RecNbr),""," where stordrid="+self:curStordid+" and seqnr="+Str(oNew:SEQNR,-1)) 
oStmnt:=SQLStatement{cStatement,oConn}
oStmnt:Execute()
if Empty(oStmnt:status)
	return true
else
	return false
endif
METHOD ValidateBooking( oStOrdLH as StOrdLineHelp) as logic CLASS EditStandingOrder
	LOCAL lValid := true as LOGIC
	LOCAL cError as STRING      
	LOCAL oTBQuestion as TextBox
	Local dNextBookDate as date      
	LOCAL oPer:=self:oStOrdr as sqlselect
         
	LOCAL fTotalcredit as float   
	        
	
	dNextBookDate := Getvaliddate(self:mday,Month(oDCmIDAT:SelectedDate),Year(oDCmIDAT:SelectedDate))
	//If there where earlier bookings, find out when the next booking is
	IF !IsNil(oPer) 
		IF IsObject(oPer) .and. IsDate(oPer:lstrecording)
			dNextBookDate := Getvaliddate(self:mday,Month(oPer:lstrecording)+self:mperiod,Year(oPer:lstrecording)) 
		ENDIF
	ENDIF  	             
	
	
	// check startdate < today, enddate in the future and latestbooking longer then one period ago
		IF  oDCmIDAT:SelectedDate< Today().and.odcmEdat:SelectedDate > Today().and.Today()  > dNextBookDate   
		  
	   lValid := FALSE 
	      
	   oStOrdLH:GoTop()
	   
	 	do	while	!oStOrdLH:EoF 
	 		if oStOrdLH:DEB <> oStOrdLH:CRE       
	 			 fTotalcredit +=  iif(Empty(oStOrdLH:CRE),0,oStOrdLH:CRE)     
	 			
	 		endif
		
		oStOrdLH:Skip()
	 	enddo	   		                     
	 	
	 	dNextBookDate :=  Max(dNextBookDate,Getvaliddate(self:mday,Month(MinDate),Year(MinDate)))
		
		cError :="Will you really record every " +Str(self:mperiod,-1)+ " month[s] from begin date " + DToC(dNextBookDate)+ " till today " +self:mCurrency+" "+ Str(iif(Empty(fTotalcredit),0,fTotalcredit),-1) + "? (Otherwise change begin date)"
	
	ENDIF
                        
 	if !lValid
 		oTBQuestion := TextBox{self, "WARNING", cError}
  	   oTBQuestion:TYPE :=  BOXICONQUESTIONMARK + BUTTONYESNO

   	IF (oTBQuestion:Show() = BOXREPLYYES)
     	 RETURN lValid := true
  	 	ELSE
   	  RETURN lValid := FALSE
   	ENDIF
 	ENDIF
 	
RETURN lValid
method ValidateHelpLine(lNoMessage:=false as logic,ErrorLine ref int) as logic class EditStandingOrder 
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
			ELSE
				if oStOrdLH:Amirror[i,3] = "K"   // member department account, not income
					if oStOrdLH:Amirror[i,11]='E' .and. !oStOrdLH:Amirror[i,4] == 'CH'
						lValid := FALSE
						cError := self:oLan:WGet("Only assessment code CH allowed for expense account")
						exit
					elseif oStOrdLH:Amirror[i,11]='F' .and. !oStOrdLH:Amirror[i,4] == 'PF'
						lValid := FALSE
						cError := self:oLan:WGet("Only assessment code PF allowed for fund account")
					endif
				elseIF !Empty(oStOrdLH:Amirror[i,4]).and.!oStOrdLH:Amirror[i,4]=="OT" //GC
					lValid := FALSE
					cError := self:oLan:WGet("Assessment code exclusively for member")
				endif
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
	
METHOD ValidatePeriodic() CLASS EditStandingOrder
	LOCAL lValid := true as LOGIC
	LOCAL cError as STRING
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
 	ELSEIF Empty(self:oDCmIDAT:SelectedDate)
		lValid := FALSE
		cError :=  "You must enter a Start date"
		self:oDCmIdat:SetFocus()		
   	ELSEIF !Empty(self:odcmEdat:SelectedDate).and.self:odcmIdat:SelectedDate>self:odcmEdat:SelectedDate
		lValid := FALSE
		cError :=  "Enter a Enddate after the startdate"                        
		self:oDCmIdat:SetFocus()
// 	ELSEIF !lNew.and..not.Empty(oPer:LstRecording).and.(self:odcmIdat:SelectedDate<oPer:LstRecording .or.self:odcmIdat:SelectedDate< MinDate)
// 		lValid := FALSE
// 		cError :=  "Standing Order already recorded, do not shift back Startdate"
// 		SELF:oDCmIdat:SetFocus()
	ELSEIF !lNew.and.!Empty(oPer:LstRecording).and.!Empty(self:odcmEdat:SelectedDate).and.;
		self:odcmEdat:SelectedDate<oPer:LstRecording
		lValid := FALSE
		cError :=  "Enddate should be after last transaction date "+DToC(oPer:LstRecording)
		self:oDCmEdat:SetFocus()
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
	elseIF AScan(oStOrdLH:Amirror,{|x| x[4]=="AG".or.x[4]=="MG" .or.x[3]=='G'})>0
		i:= AScan(oStOrdLH:aMirror,{|x| x[4]=="CH".and.x[2]<x[1]})
		IF i > 0
			self:mCLNFrom:=Transform(oStOrdLH:Amirror[i,10],"")
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
					cError += GetFullName(Transform(oStOrdLH:Amirror[i,10],""))+"; "
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
	if lValid
		// check no empty descriptions:
// 		oStOrdLH:SuspendNotification()
		oStOrdLH:GoTop()
		if oStOrdLH:Locate({||Empty( oStOrdLH:DESCRIPTN)})
// 			oStOrdLH:ResetNotification()
			self:GoTo(oStOrdLH:RECNO) 
			cError:=self:oLan:WGet("description should not be empty")
			lValid:=false
		endif
	endif

 	IF ! lValid
		(ErrorBox{,cError}):Show()
	ENDIF

	RETURN lValid
METHOD RegAccount(omAcc,ItemName) CLASS StandingOrderBrowser
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
CLASS StandingOrderJournal 
	protect oCurr as Currency 
	export mxrate as float
	protect oLan as Language
	PROTECT oPro as ProgressPer
	protect aTrans:={} as array    //array with transactions to record: 
	//	{{1:accid,2:dat,3:description,4:docid,5:deb,6:cre,7:debforgn,8:creforgn,9:currency,10:gc,11:persid,12:mBank,13:reference,14:StOrdrid,15:seqnr,16:userid,17:transid},...}
	protect aBank:={} as ARRAY  //{index in aTrans,banknumber,stordrid },...
	protect aStOrd:={} as array // {stordrid,date}
	declare method journal,recordstorders 
Method Init() class StandingOrderJournal
	// self:oLan:=SQLSelect{"select * from language",oConn}
	return self
method journal(datum as date, oStOrdL as sqlselect,nTrans ref DWORD) as logic  class StandingOrderJournal
	*****************************************************************
	* Recording of standing order as transaction
	*
	* Returns: .t. : correct
	*          .f. : no transaction made
	*****************************************************************
	// LOCAL deb_ind AS LOGIC
	local Deb,cre, DEBFORGN,CREFORGN,total as float
	local i as int
	local nDep as int
	local CurStOrdrid,nTransLenOrg:=Len(self:aTrans),nBankLenOrg:=Len(self:aBank) as int
	LOCAL soortvan, soortnaar, PrsnVan, PrsnNaar, cTrans, mBank,CurrFrom, CurrTo,TransCurr as STRING
	local MultiFrom, lError as logic
	local lPosted:=true as logic 
	local oPersBank,oBal as sqlselect 
	// 	local oTrans,oBord,oStmnt as SQLStatement
	*Check validity of standing order:
	CurStOrdrid:=oStOrdL:stordrid
	IF !Empty(dat_controle(datum,true))
		// 		lError:=true
		return true  // skip to next date
	elseIF !((Empty(oStOrdL:edat).or.datum <=oStOrdL:edat) .and.datum <=Today())
		lError:=true
	endif

	do while !oStOrdL:EOF .and. oStOrdL:stordrid==CurStOrdrid
		if !lError
			if Empty(oStOrdL:ACCNUMBER)
				* Check account: 
				LogEvent(self,Str(oStOrdL:ACCOUNTID,-1)+": "+self:oLan:WGet("unknown account, skipped")+" in standing order: "+Str(CurStOrdrid,-1))
				(WarningBox{,self:oLan:WGet("Periodic Records"),Str(oStOrdL:ACCOUNTID,-1)+": "+self:oLan:WGet("unknown account, skipped")+" in standing order: "+Str(CurStOrdrid,-1)}):Show()
				lError:=true
			elseif Empty(oStOrdL:active)
				* Check account:
				LogEvent(self,Str(oStOrdL:ACCNUMBER,-1)+": "+self:oLan:WGet("inactive account, skipped")+" in standing order: "+Str(CurStOrdrid,-1))
				(WarningBox{,self:oLan:WGet("Periodic Records"),Str(oStOrdL:ACCNUMBER,-1)+": "+self:oLan:WGet("inactive account, skipped")+" in standing order: "+Str(CurStOrdrid,-1)}):Show()
				lError :=true
			endif 
		endif
		If !lError
			mBank:=""
			if empty(nDep) .and. !empty(oStOrdL:department)
				nDep:=oStOrdL:department
			endif
			if Str(oStOrdL:ACCOUNTID,-1)== sCRE .and. !Empty(oStOrdL:CREDITOR)
				// payment to creditor
				if CountryCode="31"
					if !Empty(oStOrdL:BANKACCT) .and. !Empty(!Empty(oStOrdL:BANKACCT)) .and. oStOrdL:BANKACCT==oStOrdL:banknumber
						mBank:=oStOrdL:BANKACCT 
					else 
						if Empty(oStOrdL:banknumber)
							LogEvent(self,"Bank account "+oStOrdL:BANKACCT+" does not belang to person "+Str(oStOrdL:CREDITOR,-1)+" in standing order: "+Str(CurStOrdrid,-1)+" (skipped)")
							(WarningBox{,self:oLan:WGet("Periodic Records"),"Bank account "+oStOrdL:BANKACCT+" does not belang to person "+Str(oStOrdL:CREDITOR,-1)+" in standing order: "+Str(CurStOrdrid,-1)+" (skipped)"}):Show()
							
							lError:=true
						else
							oPersBank:=SqlSelect{"select banknumber,persid from personbank where persid='"+Str(oStOrdL:CREDITOR,-1)+"'",oConn}
							if oPersBank:reccount>0
								mBank:=oPersBank:banknumber 
							endif
						endif
						if !lError .and.Empty(mBank)
							LogEvent(self,"No bank account for person "+Str(oStOrdL:CREDITOR,-1)+" in standing order: "+Str(CurStOrdrid,-1)+" (skipped)")
							(WarningBox{,self:oLan:WGet("Periodic Records"),"No bank account for person "+Str(oStOrdL:CREDITOR,-1)+" in standing order: "+Str(CurStOrdrid,-1)+" (skipped)"}):Show()
							lError:=true
						endif
					endif
				endif
			elseif Empty(oStOrdL:gc) .or.(nDep>0 .and. !oStOrdL:department==nDep)
				lPosted:=false
			endif
		ENDIF
		if !lError
			MultiFrom:=iif(ConI(oStOrdL:MULTCURR)=1,true,false)
			CurrFrom:=oStOrdL:CurrFrom
			* make new transaction: 
			deb:=oStOrdL:deb 
			cre:=oStOrdL:cre
			if !Empty(oStOrdL:Currency) .and. !oStOrdL:Currency==sCurr
				Deb:=Round((oCurr:GetROE(oStOrdL:Currency,datum))*Deb,DecAantal)	
				cre:=Round((oCurr:GetROE(oStOrdL:Currency,datum))*cre,DecAantal)	
			endif
			total:=round(total+cre-deb,decaantal)
			TransCurr:=sCurr
			if MultiFrom .or. CurrFrom == oStOrdL:Currency
				TransCurr:=oStOrdL:Currency 
				DEBFORGN:=Deb
				CREFORGN:=cre
			elseif !CurrFrom==sCurr
				// recalculate to foreign currency:
				DEBFORGN:=Round(Deb/(self:oCurr:GetROE(CurrFrom,datum)),DecAantal)
				CREFORGN:=Round(cre/(self:oCurr:GetROE(CurrFrom,datum)),DecAantal)
				TransCurr:=CurrFrom
			endif	
			// save in aTrans: 
			//	{{1:accid,2:dat,3:description,4:docid,5:deb,6:cre,7:debforgn,8:creforgn,9:currency,10:gc,11:persid,12:reference,13:seqnr,14:userid,15:poststatus,16:transid},...}
			AAdd(self:aTrans,{Str(oStOrdL:ACCOUNTID,-1),SQLdate(datum),AddSlashes(oStOrdL:DESCRIPTN),AddSlashes(oStOrdL:DOCID),Deb,cre,DEBFORGN,CREFORGN,;
				TransCurr,oStOrdL:gc,;
				iif(ConI(oStOrdL:GIFTALWD)==1.and.!Empty(oStOrdL:persid).and.cre>Deb.and.!Str(oStOrdL:ACCOUNTID,-1)==sCRE,oStOrdL:persid,iif(Str(oStOrdL:ACCOUNTID,-1)==sCRE,oStOrdL:CREDITOR,0)),;
				AddSlashes(oStOrdL:REFERENCE),Str(oStOrdL:seqnr,-1),iif(Empty(oStOrdL:userid),LOGON_EMP_ID,oStOrdL:userid),1,nTrans} ) 
			// 				AddSlashes(oStOrdL:REFERENCE),Str(oStOrdL:seqnr,-1),LOGON_EMP_ID,iif(Empty(mBank),1,2),nTrans} ) 
			if !Empty(mBank)
				// save banknumber
				AAdd(self:aBank,{Len(self:aTrans),mBank,Str(CurStOrdrid,-1)})
			endif 
		endif
		oStOrdL:skip()
	enddo
	if !total==0.00
		lError:=true
		LogEvent(self,"Standing order: "+Str(CurStOrdrid,-1)+" not balanced (skipped)")
		(WarningBox{,self:oLan:WGet("Standing orders"),"Standing order: "+Str(CurStOrdrid,-1)+" not balanced (skipped)"}):Show()
	endif		
	if !lError
		nTrans++
		if lPosted
			// set poststatus to 2 because check is done when sending to bank:
			for i:=(nTransLenOrg+1) to Len(aTrans)
				aTrans[i,15]:=2
			next
		endif
	else
		// discard added entries:
		ASize(self:aTrans,nTransLenOrg)
		ASize(self:aBank,nBankLenOrg)
	endif



	return !lError
METHOD recordstorders(dummy:=nil as logic) as logic CLASS StandingOrderJournal
	* Daily execution of Standing Orders
	LOCAL nwdat, checkdate,idat,edat,curdat as date, tel:=0 as int, first:=true,lError as LOGIC
	LOCAL iPeriod,nCurRec,nAdv,nDay,i,j,CurStOrdrid as int
	local nTrans as DWord 
	local oStOrdL as sqlselect
	// 	local CurStOrdrid:='',cTrans as string 
	local oBal as balances 
	local cValuesBankOrd,cValuesStOrd,cValuesTrans as string 
	local oTrans,oBord,oStmnt as SQLStatement   
	local cError as string
	self:aTrans:={}

	if self:oCurr==null_object
		self:oCurr:=Currency{"Recording standing orders"}
	endif
	oStOrdL:=SqlSelect{"select s.stordrid,s.day,s.period,s.docid,s.currency,cast(s.idat as date) as idat,"+;
		"cast(s.edat as date) as edat,cast(s.lstrecording as date) as lstrecording,s.persid,s.userid,"+;
		"l.accountid,l.deb,l.cre,l.descriptn,l.gc,l.creditor,l.bankacct,b.banknumber,l.reference,l.seqnr,"+; 
	"a.currency as currfrom,a.multcurr,a.giftalwd,a.accnumber,a.active,a.department"+;
		" from standingorder s,standingorderline l left join account a on (a.accid=l.accountid) "+; 
	"left join personbank b on (b.persid=l.creditor and b.banknumber=l.bankacct) "+;
		"where l.stordrid=s.stordrid and "+;
		"(edat is null or edat>=CurDate()) and "+;
		"(lstrecording is null or (DATE_ADD(lstrecording,INTERVAL period MONTH)<=curdate() and "+;
		"(edat is null or DATE_ADD(lstrecording,INTERVAL period MONTH)<=edat))) and idat<=CurDate()"+;
		" order by s.stordrid,l.seqnr",oConn} 
	if oStOrdL:reccount <1 
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
		oMainWindow:STATUSMESSAGE("Busy with standing orders:")
		nCurRec:=oStOrdL:RecNo 
		curdat:=null_date
		CurStOrdrid:=oStOrdL:stordrid
		do while self:journal(nwdat,oStOrdL,@nTrans)
			curdat:=nwdat  
			nwdat:=Getvaliddate(nDay,Month(nwdat)+iPeriod,Year(nwdat)) 
			IF (Empty(edat).or.nwdat <=edat) .and.nwdat <=checkdate // more transactions to made?
				oStOrdL:Goto(nCurRec) // reset orderlines
			else
				AAdd(self:aStOrd,{Str(CurStOrdrid,-1),SQLdate(curdat) })
				exit
			endif
		enddo
	ENDDO
	// perform recording if transactions (when everything is OK:
	if Len(self:aTrans)>1 
		oBal:=Balances{}     
	//	{{1:accid,2:dat,3:description,4:docid,5:deb,6:cre,7:debforgn,8:creforgn,9:currency,10:gc,11:persid,12:reference,13:seqnr,14:userid,15:poststatus,16:transid},...}

// 		SQLStatement{"start transaction",oConn}:execute()  
		oStmnt:=SQLStatement{"set autocommit=0",oConn}
		oStmnt:execute()
		oStmnt:=SQLStatement{'lock tables `bankorder` write,`mbalance` write,`standingorder` write,`transaction` write',oConn}       // alphabatic order
		oStmnt:execute()
		
		oTrans:=SQLStatement{"insert into transaction (accid,dat,description,docid,deb,cre,debforgn,creforgn,currency,gc,persid,userid,seqnr,reference,poststatus"+;
			") values ('"+self:aTrans[1,1]+"','"+self:aTrans[1,2]+"','"+self:aTrans[1,3]+"','"+self:aTrans[1,4]+;
			"','"+Str(self:aTrans[1,5],-1)+"','"+Str(self:aTrans[1,6],-1)+;
			"','"+Str(self:aTrans[1,7],-1)+"','"+Str(self:aTrans[1,8],-1)+;
			"','"+self:aTrans[1,9]+"','"+self:aTrans[1,10]+"','"+Str(self:aTrans[1,11],-1)+"','"+self:aTrans[1,14]+"','"+self:aTrans[1,13]+"','"+AllTrim(self:aTrans[1,12])+"',"+ConS(aTrans[1,15])+")",oConn}
		oTrans:execute()
		if oTrans:NumSuccessfulRows<1
			cError:= "stmnt:"+oTrans:SQLString+CRLF+"error:"+oTrans:status:Description
			lError:=true
		else
			nTrans:=ConI(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
			for i:=1 to Len(self:aTrans)
				// fill transid
				aTrans[i,16]+=nTrans
			next
			cValuesTrans:=Implode(aTrans,'","',2)
			//	{{1:accid,2:dat,3:description,4:docid,5:deb,6:cre,7:debforgn,8:creforgn,9:currency,10:gc,11:persid,12:reference,13:seqnr,14:userid,15:poststatus,16:transid},...}
			oTrans:=SQLStatement{"insert into transaction (accid,dat,description,docid,deb,cre,debforgn,creforgn,currency,gc,persid,reference,seqnr,userid,poststatus,transId) "+;
				"values "+cValuesTrans,oConn}                                                                                                              
			oTrans:execute()
			if !Empty(oTrans:status) 
				cError:="stmnt:"+oTrans:SQLString+CRLF+"error:"+oTrans:errinfo:errormessage
				lError:=true
			endif
		endif
		if !lError
			for i:=1 to Len(self:aTrans)
				oBal:ChgBalance(self:aTrans[i,1], SQLDate2Date(self:aTrans[i,2]), self:aTrans[i,5], self:aTrans[i,6], self:aTrans[i,7], self:aTrans[i,8],self:aTrans[i,9],self:aTrans[i,15])
			next 
			if !oBal:ChgBalanceExecute()
				lError:=true
				cError:=oBal:cError
			endif
		endif
		if !lError
			if !Empty(self:aBank) 
				// payment to creditor
				// make bankorder:
				for i:=1	to	Len(self:aBank)
					j:=self:aBank[i,1] 
					cValuesBankOrd+=",('"+sCRE+"','"+;
						Str(Round(self:aTrans[j,6]-self:aTrans[j,5],DecAantal),-1)+"','"+self:aTrans[j,3]+"','"+self:aBank[i,2]+"','"+self:aTrans[j,2]+"','"+self:aBank[i,3]+"')"
				next

				oBord:=SQLStatement{"insert into bankorder (accntfrom,amount,description,banknbrcre,datedue,stordrid) values "+SubStr(cValuesBankOrd,2),oConn}
				oBord:execute()
				if !Empty(oBord:status) .or. oBord:NumSuccessfulRows<1 
					cError:="stmnt:"+oBord:SQLString+CRLF+"error:"+oBord:errinfo:errormessage				
					lError:=true						
				endif
			endif
			if !lError .and. !Empty(self:aStOrd)
				cValuesStOrd+=Implode(self:aStOrd,'","')
				&&skip to next month
				oStmnt:=SQLStatement{"insert into standingorder (stordrid,lstrecording) values "+cValuesStOrd+;
					" ON DUPLICATE KEY UPDATE lstrecording=values(lstrecording) ",oConn}
				oStmnt:execute()
				if!Empty(oStmnt:status)
					lError:=true
					cError:="stmnt:"+oStmnt:SQLString+CRLF+"error:"+oStmnt:errinfo:errormessage				
				endif
			endif
		endif

		// 		endif
		if !lError
			SQLStatement{"commit",oConn}:execute()
			SQLStatement{"unlock tables",oConn}:execute()
			SQLStatement{"set autocommit=1",oConn}:execute()
		else
			SQLStatement{"rollback",oConn}:execute()
			SQLStatement{"unlock tables",oConn}:execute()
			SQLStatement{"set autocommit=1",oConn}:execute()
			LogEvent(self,self:oLan:WGet("standingorders could not be executed:"+cError),"LogErrors")
			ErrorBox{,self:oLan:WGet("standingorders could not be executed")}:Show()
		endif	
	endif
	oMainWindow:STATUSMESSAGE(Space(80))
	RETURN true
ACCESS AccNbrCol() CLASS StOrderLines
RETURN self:oDBACCOUNTNBR:NameSym

	
METHOD DebCreProc() CLASS StOrderLines
	LOCAL recnr as int
	LOCAL oStOrdLH:=self:server as StOrdLineHelp
	LOCAL lFound as LOGIC
	LOCAL i as int
	LOCAL nCurRec, curRec, ThisRec as int
	LOCAL nAccId,nDepId as int

	CurRec := oStOrdLH:Recno
	//CurRec:=AScan(oStOrdLH:aMirror,{|x|x[6]==nCurRec}) 
	// {{ [1]deb,[2[]cre, [3]category, [4]gc, [5]accountid, [6]recno, [7]account#,[8]creditor,[9]bankacct,[10]persid,[11]INCEXPFD},[12]depid}
	oStOrdLH:Amirror[CurRec,1]:=oStOrdLH:deb
	oStOrdLH:aMirror[CurRec,2]:=oStOrdLH:cre
	oStOrdLH:Amirror[CurRec,3]:=oStOrdLH:CATEGORY
	oStOrdLH:aMirror[curRec,5]:=oStOrdLH:ACCOUNTID 
	oStOrdLH:Amirror[CurRec,6]:=oStOrdLH:Recno 
	oStOrdLH:aMirror[curRec,7]:=oStOrdLH:ACCOUNTNBR
	oStOrdLH:aMirror[CurRec,12]:=oStOrdLH:DEPID 
	
	self:Browser:SuspendUpdate()
	IF oStOrdLH:category == 'M'		
		IF oStOrdLH:Deb > oStOrdLH:cre
			oStOrdLH:gc := 'CH' 
		ELSEIF oStOrdLH:Deb = oStOrdLH:cre
			oStOrdLH:gc := '  '
		ELSE
			IF !oStOrdLH:gc == 'PF' 
				oStOrdLH:gc := 'AG'
			endif
		ENDIF
	elseif oStOrdLH:category == 'K'   //member department
		if oStOrdLH:INCEXPFD='F'
			oStOrdLH:gc := 'PF'
		ELSEIF oStOrdLH:INCEXPFD='E'
			oStOrdLH:gc := 'CH'
		elseif  oStOrdLH:INCEXPFD='I'
			oStOrdLH:gc := 'AG'
		ENDIF
	else
		if oStOrdLH:gc == 'CH' .and.!self:Owner:lMemberGiver
			recnr := 0
			do WHILE (recnr:=AScan(oStOrdLH:aMirror,{|x| x[4] =='MG'},recnr+1))>0
				oStOrdLH:Goto(recnr)
				oStOrdLH:gc := 'AG'
				oStOrdLH:aMirror[recnr,4]:=oStOrdLH:gc  && save in mirror
			ENDDO
			oStOrdLH:Goto(curRec)
		ENDIF
		oStOrdLH:gc := '  ' 
	ENDIF
	oStOrdLH:aMirror[curRec,4]:=oStOrdLH:gc  && save in mirror
	IF oStOrdLH:CATEGORY == 'M' .or.oStOrdLH:CATEGORY == 'K'   //member (department)
		nAccId:=oStOrdLH:ACCOUNTID
		nDepId:=oStOrdLH:DEPID
		if	oStOrdLH:gc == 'CH'
			//	change AG to MG if needed:
			recnr	:=	0
			do	WHILE	(recnr:=AScan(oStOrdLH:aMirror,{|x|	x[4] =='AG'.and.!(x[5]==nAccId.and.!nAccId=0.or.x[12]==nDepId.and.!nDepId=0)},recnr+1))>0
				oStOrdLH:Goto(recnr)
				oStOrdLH:gc	:=	'MG'
				oStOrdLH:aMirror[recnr,4]:=oStOrdLH:gc	 && save	in	mirror
			ENDDO
			//	change MG to AG if needed:
			recnr	:=	0
			do	WHILE	(recnr:=AScan(oStOrdLH:aMirror,{|x|	x[4] =='MG'.and.(x[5]==nAccId.and.!nAccId=0.or.x[12]==nDepId.and.!nDepId=0)},recnr+1))>0
				oStOrdLH:Goto(recnr)
				oStOrdLH:gc	:=	'AG'
				oStOrdLH:aMirror[recnr,4]:=oStOrdLH:gc	 && save	in	mirror
			ENDDO
			oStOrdLH:Goto(curRec)
		elseif	oStOrdLH:gc == 'AG' 
			// change to MG if needed
			IF self:Owner:lMemberGiver .or.AScan(oStOrdLH:aMirror,{|x|x[4]=="CH".and.x[2]<x[1].and.!(x[5]==nAccId.and.!nAccId=0.or.x[12]==nDepId.and.!nDepId=0)})>0
				oStOrdLH:gc := 'MG'
				oStOrdLH:aMirror[CurRec,4]:=oStOrdLH:gc  && save in mirror
			ENDIF
		endif
	endif		
	self:Owner:ShowAssGift()
	self:AddCredtr()
	self:Owner:Totalise()
	self:Browser:RestoreUpdate()
	RETURN
CLASS StOrdLnBrowser INHERIT DatabrowserExtra
method ColumnFocusChange(oColumn, lHasFocus)   CLASS StOrdLnBrowser
	LOCAL oStOrdLH:=self:Owner:server as StOrdLineHelp
	LOCAL ThisRec, nErr as int 
	Local myValue as float
	LOCAL myColumn:=oColumn as DataColumn
	SUPER:ColumnFocusChange(oColumn, lHasFocus)
	IF  Empty(oStOrdLH:aMirror)  && still empty ?   ingore change column during filling screen
		RETURN
	ENDIF
	ThisRec:=oStOrdLH:RecNo
	IF myColumn:NameSym == #ACCOUNTNBR
		IF Len(oStOrdLH:aMirror[ThisRec])>=7 .and.!AllTrim(myColumn:TEXTValue) == ;
				AllTrim(oStOrdLH:aMirror[ThisRec,7]) && value changed?
			oStOrdLH:aMirror[ThisRec,7]:= AllTrim(myColumn:TEXTValue) 
			self:Owner:Owner:ACCOUNTProc(myColumn:VALUE)
		ENDIF
	ELSEIF myColumn:NameSym == #DEB
		IF Len(oStOrdLH:aMirror[ThisRec])>=1 .and.!Round(myColumn:VALUE,2) == Round(oStOrdLH:aMirror[ThisRec,1],2)
			self:Owner:DebCreProc()
			self:Owner:Owner:Totalise()
		ENDIF
	ELSEIF myColumn:NameSym == #CRE 
		IF Len(oStOrdLH:aMirror[ThisRec])>=2 .and.!Round(myColumn:VALUE,2) == Round(oStOrdLH:aMirror[ThisRec,2],2)
			self:Owner:DebCreProc()
			self:Owner:Owner:Totalise()
		ENDIF
	ELSEIF myColumn:NameSym == #GC
		IF Len(oStOrdLH:aMirror[ThisRec])>=4 .and.!AllTrim(myColumn:VALUE) == AllTrim(oStOrdLH:aMirror[ThisRec,4])
			oStOrdLH:aMirror[ThisRec,4]:=AllTrim(myColumn:VALUE)
			myColumn:TEXTValue:= myColumn:Value
			oStOrdLH:gc:=myColumn:Value
			oStOrdLH:aMirror[ThisRec,4]:=oStOrdLH:gc  && save in mirror
			self:Owner:Owner:ValidateHelpLine(false,@nErr)
		ENDIF
	ELSEIF myColumn:NameSym== #ACCOUNTNAM .and. lHasFocus
		self:SetColumnFocus(#DESCRIPTN)
	ELSEif myColumn:NameSym == #CREDTRNAM 
		IF Len(oStOrdLH:aMirror[ThisRec])>=8 .and.oStOrdLH:aMirror[ThisRec,5]==Val(sCRE) .and. !AllTrim(myColumn:TEXTValue) == ;
				AllTrim(oStOrdLH:aMirror[ThisRec,8]) && value changed?
			oStOrdLH:aMirror[ThisRec,8]:= AllTrim(myColumn:TEXTValue) 
			self:Owner:Owner:CreditorProc(myColumn:VALUE)
		ENDIF
	ELSEIF myColumn:NameSym == #BANKACCT
		IF Len(oStOrdLH:aMirror[ThisRec])>=9 .and.!AllTrim(myColumn:VALUE) == AllTrim(oStOrdLH:aMirror[ThisRec,9])
			oStOrdLH:aMirror[ThisRec,9]:=AllTrim(myColumn:VALUE)
			myColumn:TextValue:= myColumn:VALUE
			oStOrdLH:BANKACCT:=myColumn:Value
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
