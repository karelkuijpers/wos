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
		IF mtype == "D" .or.mtype=="A"
			cInvoice:=PadL(mcln,6,"0")+PadL(mAccNumber,6,"0")
			self:mInvoiceID:=cInvoice+Mod10(cInvoice)
		ENDIF
	else
		cStartDate:=SubStr(DTOS(if(Empty(oDCmbegindate:SelectedDate),Today(),oDCmbegindate:SelectedDate)),3,4)
		cInvoice:=mcln+cStartDate+PadL(mAccNumber,5,"0")
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
		SELF:mAccNumber:=Str(Val(AllTrim(oAcc:ACCNUMBER)),-1)
		oDCmamount:Enable()
		IF oAcc:accid==Val(SDON)
			IF Empty(mterm)
				mterm   := 12
			ENDIF
		ELSEIF oAcc:subscriptionprice>0
			mtype := "A"
			oDCTypeText:Value:="Subscription"
			mamount   := oAcc:subscriptionprice
			oDCmamount:Disable()
			mterm   := 12
		ELSE
			//mtype := "G"
			//oDCTypeText:Value:="Periodic Gift"
			mterm   := 1
		ENDIF
		IF mtype=="A"
			oDCmamount:Disable()
		ELSE
			oDCmamount:Enable()
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
	IF mtype == "D" .or.mtype=="A"
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


