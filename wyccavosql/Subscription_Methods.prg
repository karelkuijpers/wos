METHOD GenerateInvoiceID() CLASS EditSubscription
	// Generate a invoice id (KID) number:
	// zero+person#+accountnumer (first 6 numbers)+modulo 10 check digit
	LOCAL cInvoice as STRING, cStartDate as String
	IF !Empty(SELF:oDCmInvoiceID:TextValue)
		RETURN
	ENDIF
	IF Empty(SELF:mcln) .or. Empty(SELF:mAccNumber)
		RETURN
	ENDIF
	IF !AutoGiro
		IF self:mtype == "D" .or.self:mtype=="A"
			if self:mPayMethod='C' .and. sepaenabled // direct debit
				cInvoice:='WDDA'+self:mAccNumber+'P'+self:mcln
				self:mInvoiceID:=cInvoice
				self:oDCmInvoiceID:Show() 
				self:oDCInvoiceText:Show()	
			else
				cInvoice:=PadL(self:mcln,6,"0")+PadL(self:mAccNumber,6,"0")
				self:mInvoiceID:=cInvoice+Mod10(cInvoice)
			endif
		ENDIF
	else
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
			//mtype := "G"
			//oDCTypeText:Value:="Periodic Gift"
			self:mterm   := 1
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
		self:oDCmBankAccnt:FillUsing(GetBankAccnts(self:mCLN)) 
		self:oDCmBankAccnt:CurrentItemNo:=1
	endif	

ENDIF
RETURN TRUE
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
self:gotop()
// self:oSFSubscriptionBrowser_DETAIL:Browser:refresh()
self:oDCFound:TEXTValue:=Str(self:oSub:RecCount,-1)
                
RETURN TRUE


