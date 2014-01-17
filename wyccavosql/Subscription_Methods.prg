METHOD GenerateInvoiceID() CLASS EditSubscription
	// Generate a invoice id (KID) number:
	// zero+person#+accountnumer (first 6 numbers)+modulo 10 check digit
	LOCAL cInvoice as STRING, cStartDate as String
	local aMndt:={} as array 
	local oSel as SQLSelect
	// 	IF !Empty(SELF:oDCmInvoiceID:TextValue)
	// 		RETURN
	// 	ENDIF
	IF Empty(SELF:mcln) .or. Empty(SELF:mAccNumber)
		RETURN
	ENDIF
	IF !AutoGiro
		IF self:mtype == "D" .or.self:mtype=="A"
			if self:mPayMethod='C' .and. sepaenabled // direct debit 
				if Empty(self:oDCmInvoiceID:TextValue) .or.(Left(self:oDCmInvoiceID:TextValue,6)=='WDD-A-'.and. Right(AllTrim(self:oDCmInvoiceID:TextValue),3+Len(self:mcln))=='-P-'+self:mcln)
					// when new invoiceid (mandateid) .or. generated invoiceid change it in case of other account: 
// 					cInvoice:='WDD-A-'+self:mAccNumber+'-P-'+self:mcln
// 					// check if already present:
// 					oSel:=SqlSelect{"select subscribid,invoiceid from subscription where personid="+self:mcln+;
// 					' and substr(invoiceid,1,'+Str(Len(cInvoice),-1)+')="'+cInvoice+'"'+iif(Empty(self:msubid),'',' and subscribid<>'+self:msubid)+' order by invoiceid desc limit 1',oConn}
// 					if oSel:RecCount=1
// 						aMndt:=Split(oSel:invoiceid,'-P-')
// 						if Len(aMndt)=2
// 							aMndt:=Split(aMndt[2],'-')
// 							if Len(aMndt)=1
// 								cInvoice+='-2'
// 							else
// 								cInvoice+='-'+Str(Val(aMndt[2])+1,-1) 
// 							endif
// 						else
// 							cInvoice+='-1'
// 						ENDIF
// 					endif
					cInvoice:=UpdatemandateId(self:mAccNumber,self:mcln,self:msubid) 
					self:mInvoiceID:=cInvoice
					self:oDCmInvoiceID:Show() 
					self:oDCInvoiceText:Show()
				endif	
			elseif Empty(self:oDCmInvoiceID:TextValue)
				cInvoice:=PadL(self:mcln,6,"0")+PadL(self:mAccNumber,6,"0")
				self:mInvoiceID:=cInvoice+Mod10(cInvoice)
			endif
		endif
	elseif Empty(self:oDCmInvoiceID:TextValue)
		cStartDate:=SubStr(DToS(if(Empty(self:oDCmbegindate:SelectedDate),Today(),self:oDCmbegindate:SelectedDate)),3,4)
		cInvoice:=self:mCLN+cStartDate+PadL(self:mAccNumber,5,"0")
		self:mInvoiceID:=cInvoice
	ENDIF

	RETURN 
METHOD RegAccount(oAcc,ItemName) CLASS EditSubscription
	IF oAcc==NULL_OBJECT
		SELF:mRek:=" "
		SELF:oDCmAccount:TEXTValue := " "
		SELF:cAccountName := " "
		SELF:mAccNumber:=""
	ELSE
		self:mRek :=  Str(oAcc:accid,-1)
		self:oDCmAccount:TEXTValue := AllTrim(oAcc:Description)
		self:cAccountName := AllTrim(oAcc:Description)
		self:mAccNumber:=oAcc:ACCNUMBER
		oDCmamount:Enable()
		IF oAcc:accid==Val(SDON)
			IF Empty(self:mterm)
				self:mterm   := 12
			ENDIF
		ELSEIF oAcc:subscriptionprice>0
			self:mtype := "A"
			self:oDCTypeText:Value:="Subscription"
			self:mamount   := oAcc:subscriptionprice
			self:oDCmamount:Disable()
			self:mterm   := 12
		ELSE
			IF Empty(self:mterm)
				self:mterm   := 1
			ENDIF
		ENDIF
		IF self:mtype=="A"
			self:oDCmamount:Disable()
		ELSE
			self:oDCmamount:Enable()
		ENDIF
		SELF:GenerateInvoiceID()


	ENDIF

	RETURN TRUE
METHOD RegPerson(oCLN) CLASS EditSubscription
	IF !Empty(oCLN)
		self:mCLN :=  Str(oCLN:persid,-1)
		self:cPersonName := GetFullName(self:mCLN)
		SELF:oDCmPerson:TEXTValue := SELF:cPersonName
		// 	SELF:mCod:=oPers:Cod
		self:GenerateInvoiceID()
		IF self:mtype == "D" .or. self:mtype=="A"
			self:aBankaccs:=GetBankAccnts(self:mCLN)
			self:oDCmBankAccnt:FillUsing(Split(Implode(self:aBankaccs,',',,,1),',') )
			self:oDCmBankAccnt:CurrentItemNo:=1
		endif	

	ENDIF
	RETURN true
METHOD RegAccount(omAcc,ItemName) CLASS SubscriptionBrowser
	LOCAL oAcc as SQLSelect
	IF Empty(omAcc).or.omAcc==NULL_OBJECT
		SELF:mRek :=  ""
		SELF:oDCmAccount:TEXTValue := ""
		SELF:cAccountName := ""
		self:cOrder:="accountname"
	ELSE
		oAcc:=omAcc		
		self:mRek :=  Str(oAcc:accid,-1)
		self:oDCmAccount:TEXTValue := AllTrim(oAcc:Description)
		self:cAccountName := AllTrim(oAcc:Description)
		self:cOrder:="personname"
	ENDIF
self:cWhere:="a.accid=s.accid and p.persid=s.personid"+iif(Empty(self:mtype),''," and category='"+self:mtype+"'"+iif(Empty(self:mCLN),''," and personid="+self:mCLN)+iif(Empty(self:mRek),''," and s.accid="+self:mRek) 
self:oSub:SQLString:="select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+" order by "+self:cOrder 
self:oSub:Execute()
self:gotop()
// self:oSFSubscriptionBrowser_DETAIL:Browser:refresh()
self:oDCFound:TEXTValue:=Str(self:oSub:RecCount,-1)

RETURN true
METHOD RegPerson(oCLN) CLASS SubscriptionBrowser 
Local cFilter as string , lSuccess as logic
	IF Empty(oCln)
		&& leeg gemaakt?
		SELF:mCLN :=  ""
		SELF:cPersonName := ""
		SELF:oDCmPerson:TEXTValue := ""
		self:cOrder:="personname"
	ELSE
		self:mCLN :=  Str(oCLN:persid,-1)
		self:cPersonName := GetFullName(self:mCLN)
		SELF:oDCmPerson:TEXTValue := SELF:cPersonName
		self:cOrder:="accountname"
    ENDIF
self:cWhere:="a.accid=s.accid and p.persid=s.personid"+iif(Empty(self:mtype),''," and category='"+self:mtype+"'"+iif(Empty(self:mCLN),''," and personid="+self:mCLN)+iif(Empty(self:mRek),''," and s.accid="+self:mRek) 
self:oSub:SQLString:="select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+" order by "+self:cOrder 
self:oSub:Execute()
self:oSFSubscriptionBrowser_DETAIL:Browser:refresh()
self:gotop()
self:oDCFound:TEXTValue:=Str(self:oSub:RecCount,-1)
                
RETURN TRUE


