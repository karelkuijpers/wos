function ChgDueAmnt(p_cln as string,p_rek as string,p_deb as float,p_cre as float) as logic
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
		RETURN true  && apparently no due amount
	ENDIF
	p_amount:=round(p_cre - p_deb,decaantal)
	if p_amount>0
		*  Look for due amounts:
		oDue:=SQLSelect{"select d.dueid from dueamount d, subscription s where s.subscribid=d.subscribid and s.personid="+p_cln+" and s.accid="+p_rek+" and amountrecvd<amountinvoice order by invoicedate,seqnr for update",oConn}
		IF oDue:RecCount>1
			do WHILE !oDue:EOF 
				open_amount:=Round(oDue:AmountInvoice-oDue:AmountRecvd,2)
				* When not completely assigned, rest in latest due amount:
				oStmnt:=SQLStatement{"update dueamount set amountrecvd="+Str(Round(oDue:AmountRecvd+iif(oDue:RECNO<oDue:RecCount,Min(p_amount,open_amount),p_amount),DecAantal),-1)+;
					" where subscribid="+Str(oDue:subscribid,-1),oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows>0
					p_amount:=Round(p_amount-Min(p_amount,open_amount),DecAantal)
				elseif !Empty(oStmnt:Status)
					return false					
				endif
				if p_amount<=0
					exit
				endif
				oDue:skip()
			ENDDO
		ENDIF
	ELSE
		*  Look for last assigned due amount to reverse assignment of received amounts:
		oDue:=SQLSelect{"select d.dueid,d.amountrecvd from dueamount d, subscription s where s.subscribid=d.subscribid and s.personid="+p_cln+" and s.accid="+p_rek+" and amountrecvd>0 order by d.invoicedate desc,d.seqnr desc for update",oConn}
		IF oDue:RecCount>0
			p_amount:=-p_amount
			do WHILE !oDue:EOF.and.p_amount>0
				payed_amount:=oDue:AmountRecvd
				oStmnt:=SQLStatement{"update dueamount set amountrecvd="+Str( Max(0,oDue:AmountRecvd-p_amount),-1)+" where d.dueid="+Str(oDue:dueid,-1),oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows>0
					p_amount:=p_amount-Min(payed_amount,p_amount)
				elseif !Empty(oStmnt:Status)
					return false					
				endif
				oDue:skip()
			ENDDO
		endif
		IF p_amount>0
			* Create new due amount:
			oSub:=SQLSelect{"select subscribid from subscription where personid="+p_cln+" and s.accid="+p_rek,oConn}
			if oSub:RecCount>0   
				oStmnt:=SQLStatement{"insert into dueamount (subscribid,invoicedate,seqnr,amountrecvd) values ("+Str(oSub:subscribid,-1)+",Now(),1,"+Str(p_amount,-1)+")",oConn}
				oStmnt:Execute()
				if !Empty(oStmnt:Status)
					return false					
				endif
			endif
		ENDIF
	ENDIF
	RETURN true

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
		self:cWhere+=" and d.accid="+self:mRek
		self:cOrder:="personname"
	endif
	if !Empty(self:mCLN)
		self:cWhere+=" and d.persid="+self:mCLN
		self:cOrder:="a.description"
	endif
	self:oDue:SQLString:="select "+self:cFields+" from "+self:cFrom+" where "+self:cWhere+" order by "+self:cOrder 
	self:oDue:Execute() 
	self:oSFDueAmountBrowser_DETAIL:Browser:Refresh()
	self:GoTop()
	self:oDCFound:TEXTValue:=Str(self:oDue:RecCount,-1)

RETURN TRUE
