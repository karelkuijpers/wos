METHOD RegAccount(oAcc,ItemName) CLASS DueAmountBrowser
	IF Empty(oAcc)
		SELF:mRek :=  ""
		SELF:oDCmAccount:TEXTValue := ""
		SELF:cAccountName := ""
	ELSE		
		self:mRek :=  Str(oAcc:accid,-1)
		self:oDCmAccount:TEXTValue := AllTrim(oAcc:Description)
		self:cAccountName := AllTrim(oAcc:Description)
	ENDIF
	self:cWhere:="p.persid=s.personid and a.accid=s.accid and amountinvoice >amountrecvd and d.subscribid=s.subscribid"
	if !Empty(self:mCLN)
		self:cWhere+=" and p.persid="+self:mCLN
		self:cOrder:="a.description"
	endif
	if !empty(self:mREK)
		self:cWhere+=" and s.accid="+self:mRek
		self:cOrder:="personname"
	endif
	self:oDue:SQLString:="select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+" order by "+self:cOrder
	self:oDue:Execute()
	self:oSFDueAmountBrowser_DETAIL:Browser:Refresh()
	self:GoTop() 
	self:oDCFound:TEXTValue:=Str(self:oDue:RecCount,-1)

RETURN TRUE
METHOD RegPerson(oCLN) CLASS DueAmountBrowser
	IF Empty(oCln)
		&& emptied?
		SELF:mCLN :=  ""
		SELF:cPersonName := ""
		SELF:oDCmPerson:TEXTValue := ""
	ELSE
		self:mCLN :=  Str(oCLN:persid,-1)
		self:cPersonName := GetFullName(self:mCLN)
		SELF:oDCmPerson:TEXTValue := SELF:cPersonName
    ENDIF
	self:cWhere:="p.persid=s.personid and a.accid=s.accid and amountinvoice >amountrecvd and d.subscribid=s.subscribid"
	if !empty(self:mREK)
		self:cWhere+=" and s.accid="+self:mRek
		self:cOrder:="personname"
	endif
	if !Empty(self:mCLN)
		self:cWhere+=" and p.persid="+self:mCLN
		self:cOrder:="a.description"
	endif
	self:oDue:SQLString:="select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+" order by "+self:cOrder 
	self:oDue:Execute()
	if IsObject(self:oSFDueAmountBrowser_DETAIL:Browser) .and.!Empty(self:oSFDueAmountBrowser_DETAIL:Browser) 
		self:oSFDueAmountBrowser_DETAIL:Browser:Refresh()
		self:GoTop()
		self:oDCFound:TEXTValue:=Str(self:oDue:RecCount,-1)
	endif

RETURN TRUE
