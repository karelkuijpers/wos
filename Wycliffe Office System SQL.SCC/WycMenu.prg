GLOBAL aMenu AS ARRAY
RESOURCE AWOMENU ACCELERATORS
BEGIN
	VK_F4, WOMENU_File_Exit_ID, ALT, VIRTKEY
	88, WOMENU_Edit_Cut_ID, CONTROL, VIRTKEY
	67, WOMENU_Edit_Copy_ID, CONTROL, VIRTKEY
	86, WOMENU_Edit_Paste_ID, CONTROL, VIRTKEY
	VK_HOME, WOMENU_Edit_Go_To_Top_ID, CONTROL, VIRTKEY
	VK_END, WOMENU_Edit_Go_To_Bottom_ID, CONTROL, VIRTKEY
	VK_F1, WOMENU_Help_Index_ID, VIRTKEY
END
DEFINE AWOMENU := "WOmenu"
CLASS BalListViewMenu INHERIT Menu
 
METHOD Init(oOwner) CLASS BalListViewMenu

	SUPER:Init(ResourceID{IDM_BalListViewMenu, _GetInst( )})

	SELF:RegisterItem(IDM_BalListViewMenu_X_ID,	;
		HyperLabel{#_X,	;
			"X",	;
			,	;
			,},SELF:Handle( ),0)
	SELF:RegisterItem(IDM_BalListViewMenu_X_Edit_this_record_ID,	;
		HyperLabel{#Editbutton,	;
			"&Edit this record",	;
			,	;
			,})
	SELF:RegisterItem(IDM_BalListViewMenu_X_Insert_a_record_ID,	;
		HyperLabel{#Append,	;
			"&Insert a record",	;
			,	;
			,},GetSubMenu(SELF:Handle( ),0),1)
	SELF:RegisterItem(IDM_BalListViewMenu_X_Insert_a_record_Balance__Item_ID,	;
		HyperLabel{#Append,	;
			"Balance  Item",	;
			,	;
			,})
   	IF AScan(aMenu,{|x| x[4]=="AccountEdit"})>0	
		SELF:RegisterItem(IDM_BalListViewMenu_X_Insert_a_record_Account_ID,	;
			HyperLabel{#AppendAccount,	;
			"Account",	;
			,	;
			,})
	ENDIF
	SELF:RegisterItem(IDM_BalListViewMenu_X_Delete_this_record_ID,	;
		HyperLabel{#Delete,	;
			"&Delete this record",	;
			,	;
			,})
	SELF:RegisterItem(IDM_BalListViewMenu_X_Refresh_ID,	;
		HyperLabel{#Refresh,	;
			"&Refresh",	;
			,	;
			,})

	RETURN SELF
CLASS DepartmentListViewMenu INHERIT Menu
 
METHOD Init(oOwner) CLASS DepartmentListViewMenu

	SUPER:Init(ResourceID{IDM_DepartmentListViewMenu, _GetInst( )})

	SELF:RegisterItem(IDM_DepartmentListViewMenu_X_ID,	;
		HyperLabel{#_X,	;
			"X",	;
			,	;
			,},SELF:Handle( ),0)
	SELF:RegisterItem(IDM_DepartmentListViewMenu_X_Edit_this_record_ID,	;
		HyperLabel{#Editbutton,	;
			"&Edit this record",	;
			,	;
			,})
	SELF:RegisterItem(IDM_DepartmentListViewMenu_X_Insert_a_record_ID,	;
		HyperLabel{#Append,	;
			"&Insert a record",	;
			,	;
			,},GetSubMenu(SELF:Handle( ),0),1)
	SELF:RegisterItem(IDM_DepartmentListViewMenu_X_Insert_a_record_Department__ID,	;
		HyperLabel{#Append,	;
			"Department ",	;
			,	;
			,})
   	IF AScan(aMenu,{|x| x[4]=="AccountEdit"})>0
		SELF:RegisterItem(IDM_DepartmentListViewMenu_X_Insert_a_record_Account_ID,	;
		HyperLabel{#AppendAccount,	;
			"Account",	;
			,	;
			,})
	ENDIF
	SELF:RegisterItem(IDM_DepartmentListViewMenu_X_Delete_this_record_ID,	;
		HyperLabel{#Delete,	;
			"&Delete this record",	;
			,	;
			,})
	SELF:RegisterItem(IDM_DepartmentListViewMenu_X_Refresh_ID,	;
		HyperLabel{#Refresh,	;
			"&Refresh",	;
			,	;
			,})

	RETURN SELF
Define IDA_BalListViewMenu := "BalListViewMenu"
 
Define IDA_DepartmentListViewMenu := "DepartmentListViewMenu"
 
RESOURCE IDM_BalListViewMenu MENU
Begin
	POPUP "X"
	BEGIN
		MENUITEM "&Edit this record", IDM_BalListViewMenu_X_Edit_this_record_ID
		POPUP "&Insert a record"
		BEGIN
			MENUITEM "Balance  Item", IDM_BalListViewMenu_X_Insert_a_record_Balance__Item_ID
			MENUITEM "Account", IDM_BalListViewMenu_X_Insert_a_record_Account_ID
		END
		MENUITEM "&Delete this record", IDM_BalListViewMenu_X_Delete_this_record_ID
		MENUITEM SEPARATOR
		MENUITEM "&Refresh", IDM_BalListViewMenu_X_Refresh_ID
	END
End
 
Define IDM_BalListViewMenu := "BalListViewMenu"
 
Define IDM_BalListViewMenu_X_Delete_this_record_ID := 9216
 
Define IDM_BalListViewMenu_X_Edit_this_record_ID := 9212
 
Define IDM_BalListViewMenu_X_ID := 9211
 
Define IDM_BalListViewMenu_X_Insert_a_record_Account_ID := 9215
 
Define IDM_BalListViewMenu_X_Insert_a_record_Balance__Item_ID := 9214
 
Define IDM_BalListViewMenu_X_Insert_a_record_ID := 9213
 
Define IDM_BalListViewMenu_X_Refresh_ID := 9218
 
RESOURCE IDM_DepartmentListViewMenu MENU
Begin
	POPUP "X"
	BEGIN
		MENUITEM "&Edit this record", IDM_DepartmentListViewMenu_X_Edit_this_record_ID
		POPUP "&Insert a record"
		BEGIN
			MENUITEM "Department ", IDM_DepartmentListViewMenu_X_Insert_a_record_Department__ID
			MENUITEM "Account", IDM_DepartmentListViewMenu_X_Insert_a_record_Account_ID
		END
		MENUITEM "&Delete this record", IDM_DepartmentListViewMenu_X_Delete_this_record_ID
		MENUITEM SEPARATOR
		MENUITEM "&Refresh", IDM_DepartmentListViewMenu_X_Refresh_ID
	END
End
 
Define IDM_DepartmentListViewMenu := "DepartmentListViewMenu"
 
Define IDM_DepartmentListViewMenu_X_Delete_this_record_ID := 9178
 
Define IDM_DepartmentListViewMenu_X_Edit_this_record_ID := 9174
 
Define IDM_DepartmentListViewMenu_X_ID := 9173
 
Define IDM_DepartmentListViewMenu_X_Insert_a_record_Account_ID := 9177
 
Define IDM_DepartmentListViewMenu_X_Insert_a_record_Department__ID := 9176
 
Define IDM_DepartmentListViewMenu_X_Insert_a_record_ID := 9175
 
Define IDM_DepartmentListViewMenu_X_Refresh_ID := 9180
 
FUNCTION InitMenu(EmployeeId as int,myType:=null_string as string) as array
	* return array with menustructure, to Initialize global array aMenu for user EmployeeId of type myType with the menuitems:
	* (nParentId, nItemID, cItemText, EventName, cDescriptiontext,  TBIconId, nAccelertorkey,cType)
	* ParentId: empty: top of hiÙracrchy
	* nItenId: sequence within nParentId determines sequence within menu and toolbar
	* cItemText: shown as menu item; empty: separator
	* EventName: if empty: submenu
	* cDescriptiontext: used as description and as tiptext
	* TBIconId: identification of used icon within toolbar: IDT_OPEN, etc.
	* nAccelertorkey: absolute identification of menuitem, to be used for acccellerator key
	*  cType: A, F or P: authorisation level
	*
	LOCAL oAuthF as SQLSelect
	LOCAL aMenu:={},aMenuAct as ARRAY
	LOCAL i,j, nFunc as int 
	local aFunc:={} as array
	LOCAL lSystemAdmin:=FALSE as LOGIC
	LOCAL oLan as Language
	// 	Default(@myType,NULL_STRING)
	IF myType=="A"
		lSystemAdmin:=true
	ELSEIF !Empty(EmployeeId)
		oAuthF := SqlSelect{"select cast("+Crypt_Emp(false,"funcname")+" as char) as mfuncname from authfunc where empid="+Str(EmployeeId,-1),oConn}
		oAuthF:GoTop()
		IF oAuthF:Reccount=0
			IF Empty(myType)
				lSystemAdmin:=true
			ENDIF
		ENDIF
	ENDIF
	oLan:=Language{}
	
	aMenu:={{99,0,"Overall Menu","","",0,0}}  // dummy overall menu
	AAdd(aMenu,{0,1, oLan:MGet("&File"),"","",0,0,"PFM"})
	AAdd(aMenu,{1,1, oLan:MGet("&Person")+"...","PersonBrowser","",0,34,"PFM"})
	IF Admin=="WO".or.Admin=="GI"
		AAdd(aMenu,{1,2, oLan:MGet("&Member+PPs")+"...","MemberBrowser","",0,59,"PFM"})
	ENDIF
	IF !Admin=="HO"
		AAdd(aMenu,{1,3, oLan:MGet("&Account")+"...","AccountBrowser","",0,21,"PFM"}) 
		if !Admin=="WA"
			AAdd(aMenu,{1,4, oLan:MGet("&Subscription")+"...","Subscriptions","",0,12,"PFM"})
			IF Admin=="WO".or.Admin=="GI"
				AAdd(aMenu,{1,5, oLan:MGet("&Donations")+"...","Donations","",0,13,"PFM"})
			ENDIF
			// 			AAdd(aMenu,{1,6, oLan:MGet("Arti&cle")+"...","ArticleBrowser","",0,47,"PFM"})
		endif
	ENDIF
	AAdd(aMenu,{1,7,,,,,})           // separator
	AAdd(aMenu,{1,8, oLan:MGet("&Import")+"...","ImportMapping","",0,32,"PFM"})
	if CountryCode='31' .and. SqlSelect{"show databases like 'parousia_typo3'",oConn}:Reccount>0
		AAdd(aMenu,{1,9, oLan:MGet("&Synchronize")+"...","Synchronize","",0,30,"A"})
	endif	
	AAdd(aMenu,{1,10,,,,,})           // separator
	AAdd(aMenu,{1,11, oLan:MGet("&Backup now")+"...","BackupNow","",0,37,"PFM"})
	AAdd(aMenu,{1,12, oLan:MGet("&Restore database")+"...","Restore","",0,38,"A"})
	
	AAdd(aMenu,{0,2, oLan:MGet("&Journal"),,"Entering records and gifts",0,0,"F"})
	IF !Admin=="GE" .and.!Admin=="WA"
		AAdd(aMenu,{2,1,   oLan:MGet("&Gifts/Payments entering")+"...","PaymentJournal","",0,35,"F"})
		AAdd(aMenu,{2,2,   oLan:MGet("&Standard Gifts Pattern Inquiry/Update")+"..." ,"PeriodicGift","",0,56,"F"})
	ELSE
		AAdd(aMenu,{2,1,   oLan:MGet("&Payments entering")+"...","PaymentJournal","",0,35,"F"})
	ENDIF
	AAdd(aMenu,{2,3,,,,,})           // separator
	IF Admin=="HO"
		AAdd(aMenu,{2,4,   oLan:MGet("&Gift report & member statement")+"...","GiftReport","",0,69,"FM"})
	ELSE
		AAdd(aMenu,{2,4,    oLan:MGet("&Journal general")+"..." ,"General_Journal","",0,74,"FM"})
		//	AAdd(aMenu,{2,4,    oLan:MGet("&Journal generalJap..." ,"General_JournalJap","",0,74,"F"})
		IF TeleBanking
			AAdd(aMenu,{2,5,   oLan:MGet("&Telebank Pattern")+"..." ,"TelePatternBrowser","",0,9,"F"})
		ENDIF
		if ConI(SqlSelect{"select cast(count(*) as unsigned) as tot from importpattern",oConn}:tot)>0 
			AAdd(aMenu,{2,6,   oLan:MGet("&Import Pattern")+"..." ,"ImportPatternBrowser","",0,17,"F"})
		endif
		AAdd(aMenu,{2,7,   oLan:MGet("Standing &Orders")+"..." ,"StandingOrderBrowser","",0,36,"F"})
	ENDIF
// 	if SuperUser
	AAdd(aMenu,{2,8,,,,,})           // separator
		AAdd(aMenu,{2,9,   oLan:MGet("&Monitor Suspense")+"...","CheckSuspense","",0,16,"F"})
	if TeleBanking .and.ConI(SQLSelect{"select cast(count(*) as unsigned) as tot from bankbalance",oConn}:tot)>0 
		AAdd(aMenu,{2,10,   oLan:MGet("&Monitor Bank Balance")+"...","CheckBankBalance","",0,15,"F"})
	endif 
		
// 	endif
	AAdd(aMenu,{2,10,,,,,})           // separator
	AAdd(aMenu,{2,11,    oLan:MGet("&Account statements per month")+"..." ,"TransactionMonth","",0,14,"FM"})
	AAdd(aMenu,{2,12,    oLan:MGet("Journal Records &Inquiry/Update")+"..." ,"TransInquiry","",0,75,"FM"})
	AAdd(aMenu,{0,3, oLan:MGet("&Balance"),,,,,})
	IF Admin=="WO"
		AAdd(aMenu,{3,2,   oLan:MGet("&Sending to PMC")+"...","PMISsend","",0,87,"F"}) 
		AAdd(aMenu,{3,3,   oLan:MGet("&IPC Report")+"...","IPCReport","",0,89,"F"}) 
	elseif Admin="WA"
		AAdd(aMenu,{3,2,   oLan:MGet("&Sending to AccPac")+"...","AreaReport","",0,87,"F"}) 
	ENDIF
	IF !Admin=="GE".and.!Admin=="HO".and.!Admin=="WA"
		AAdd(aMenu,{3,4,   oLan:MGet("&Gift report & member statement")+"...","GiftReport","",0,69,"FM"})
		IF Departments
			AAdd(aMenu,{3,5,   oLan:MGet("&Department statement")+"...","DeptReport","",0,70,"FM"})
		ENDIF
	ENDIF
	IF !Admin=="HO"
		AAdd(aMenu,{3,6,,,,,})           // separator
		AAdd(aMenu,{3,7,   oLan:MGet("&Trial balance")+"...","TrialBalance","",0,31,"FM"})
		AAdd(aMenu,{3,8,   oLan:MGet("Balance sheet printing")+"...","BalanceReport","",0,72,"FM"})
	ENDIF
	AAdd(aMenu,{3,8,,,,,})           // separator
	IF CountryCode=="47"
		AAdd(aMenu,{3,9,   oLan:MGet("&Tax Report")+"...","TaxReport","",0,6,"F"})
	ENDIF
	AAdd(aMenu,{3,10,   oLan:MGet("&Month closing")+"...","MonthClose",oLan:MGet("Restricting journaling to certain period"),0,7,"A"}) 
	AAdd(aMenu,{3,10,   oLan:MGet("&Year balancing and closing")+"...","YearClosing","",0,5,"A"}) 
	if !Admin="WA"
		AAdd(aMenu,{0,4, oLan:MGet("&Mail/Invoice"),,,,,})
		IF !Admin=="HO"
			// 			AAdd(aMenu,{4,1, oLan:MGet("&Invoicing")+"...","Invoicing","Producing bills",0,26,"PF"})
// 			AAdd(aMenu,{4,2, oLan:MGet("&Reminders mailing"),"Reminders","",0,63,"PF"})
			AAdd(aMenu,{4,3, oLan:MGet("&Due Amount Inquiry/Delete")+"...","DueAmountBrowser","",0,39,"PF"})
			AAdd(aMenu,{4,4,,,,,})           // separator
			//AAdd(aMenu,{4,5, oLan:MGet("&Prolongate Donations/Subscriptions"),"Prolongation","",0,48,"PFM"})
			IF !Admin=="GE"
				AAdd(aMenu,{4,6, oLan:MGet("Sending Payment Requests &Donation"),"DonationsMail","",0,18,"F"})
			ENDIF
			AAdd(aMenu,{4,7, oLan:MGet("Sending Payment Requests &Subscription"),"SubScriptionsMail","",0,58,"F"})
			IF CountryCode="31"
				AAdd(aMenu,{4,8, oLan:MGet("Sending Bank Orders"),"SelBankOrder","",0,88,"F"})
			endif
			AAdd(aMenu,{4,9,,,,,})           // separator
		endif
	ENDIF
	IF !Admin="WA"
		IF !Admin=="GE"
			AAdd(aMenu,{4,9, oLan:MGet("&Thank You Letters mailing"),"ThankYouLetters","",0,68,"F"})
			AAdd(aMenu,{4,10, oLan:MGet("&First Givers Letters mailing"),"FirstGivers","",0,78,"PF"})
			IF !Admin=="HO"
				AAdd(aMenu,{4,11, oLan:MGet("First &non-designated Givers Letters mailing"),"FirstNonEarmarked","",0,33,"PF"})
			ENDIF
			// 			AAdd(aMenu,{4,12, oLan:MGet("Regular Gi&vers mailing"),"StandardGiversMail","",0,11,"F"})
			AAdd(aMenu,{4,13,,,,,})           // separator
		ENDIF
		AAdd(aMenu,{4,14, oLan:MGet("Mail Selection via &Person parameters"),"MailViaCode","",0,66,"PFM"})
		// 		IF Admin=="WO".or.Admin=="GI"
		// 			AAdd(aMenu,{4,15, oLan:MGet("Mail to &General Selection of Persons"),"Selpers","",0,55,"FM"})
		// 		ENDIF
		AAdd(aMenu,{4,16,,,,,})           // separator
		AAdd(aMenu,{4,17, oLan:MGet("&Add/Remove Mailing Codes of Selection of Persons"),"ChangeMailCode","",0,79,"P"})
		IF Admin=="WO".or.Admin=="GI".or.Admin=="HO"
			// Donor Analysis
			AAdd(aMenu,{0,5,oLan:MGet("&Analysis"),,,,,})
			AAdd(aMenu,{5,1, oLan:MGet("&Donor Analysis")+"...","DonorProject",,0,23,"FM"})
			AAdd(aMenu,{5,2, oLan:MGet("&Donor Following Report")+"...","DonorFollowingReport",,0,73,"FM"})
			IF Admin=="WO".or.Admin=="HO".or.Admin=="GI"
				AAdd(aMenu,{5,3, oLan:MGet("&Totals Members")+"...","TotalsMembers",,0,25,"FM"})
			ENDIF
		endif
	ENDIF
	// Options:
	AAdd(aMenu,{0,6, oLan:MGet("&Options"),,,,,})
	if SuperUser
		AAdd(aMenu,{6,7, oLan:MGet("&Check consistency financial data"),"CheckFinancialData","",0,44,"F"})
	endif
	AAdd(aMenu,{6,8, oLan:MGet("Show &log"),"LogReport","",0,46,"AF"})
	AAdd(aMenu,{6,8,,,,,})           // separator
	AAdd(aMenu,{6,9, oLan:MGet("Change &Password")+"...","NewPasswordDialog",,0,49,"Z"})
	AAdd(aMenu,{6,9, oLan:MGet("My &Email preferences")+"...","MyEmailClient",,0,53,"Z"})
// 	if maildirect .and. SqlSelect{'select empid from mailaccount where empid='+MyEmpID,oConn}:Reccount>0
// 		AAdd(aMenu,{6,9, oLan:MGet("Change &mail account")+"...","EditEmailAccount",,0,50,"Z"})
// 	endif
	IF lSystemAdmin
		AAdd(aMenu,{6,10, oLan:MGet("&User_ids and passwords")+"...","EmployeeBrowser",,0,45,"A"})
	ENDIF
	AAdd(aMenu,{6,11,,,,,})           // separator
	AAdd(aMenu,{6,12, oLan:MGet("System Da&ta"),,,,,})
	AAdd(aMenu,{12,1, oLan:MGet("System p&arameters")+"...","TabSysparms","",0,62,"AM"})
	IF !Admin="WA"
		AAdd(aMenu,{12,2, oLan:MGet("P&erson parameters")+"...","PersonParms",oLan:MGet("Registration of person parameters"),0,52,"PFM"})
	endif
	AAdd(aMenu,{12,4, oLan:MGet("Ban&kaccount registration")+"...","BankBrowser","",0,42,"A"})
	IF !Admin=="HO"
		AAdd(aMenu,{12,5, oLan:MGet("&Balance Item Registration")+"...","BalanceItemExplorer","",0,4,"A"})
		AAdd(aMenu,{12,6, oLan:MGet("&Department Registration")+"...","DepartmentExplorer","",0,76,"A"})
	ENDIF
	AAdd(aMenu,{6,13,,,,,})           // separator
	AAdd(aMenu,{6,14, oLan:MGet("&Currency rates")+"...","CurrRateEditor","",0,43,"AF"})
	AAdd(aMenu,{6,15, oLan:MGet("&Language Translation tables"),,,,,})
	AAdd(aMenu,{6,14, oLan:MGet("&Language Translation tables"),,,,,})
	AAdd(aMenu,{14,1, oLan:MGet("&Menus translation")+"...","LanguageMenu","",0,51,"A"})
	AAdd(aMenu,{14,1, oLan:MGet("&Reports translation")+"...","LanguageReport","",0,67,"A"})
	AAdd(aMenu,{14,1, oLan:MGet("&Windows translation")+"...","LanguageScreen","",0,99,"A"})

	// add extra invisible items for extra permissions:
	AAdd(aMenu,{-1,101,"Account Edit","AccountEdit","",0,101,"F"})
	AAdd(aMenu,{-1,102,"Person Edit","PersonEdit","",0,102,"PFM"})
	AAdd(aMenu,{-1,103,"Foreign currency account reevaluation","Reevaluation","",0,103,"A"})
	AAdd(aMenu,{-1,104,"Transaction Edit","TransactionEdit","",0,104,"F"}) 
	AAdd(aMenu,{-1,104,"Member Edit","MemberEdit","",0,106,"F"}) 
	if Posting
		AAdd(aMenu,{-1,105,"Posting Batch","PostingBatch","",0,105,"M"})
	endif

	// Check correct batch poster
	if	Posting .and.!Empty(EmployeeId)
		if	(i:=AScan(aMenu,{|x|x[4]=="PostingBatch"}))>0
			if (j:=AScan( aMenu,{|x|x[4]=="TransactionEdit"}))>0
				AAdd(aFunc,j) 
			endif
			if (j:=AScan( aMenu,{|x|x[4]=="StandingOrderBrowser"}))>0
				AAdd(aFunc,j)
			endif
			if (j:=AScan( aMenu,{|x|x[4]=="MemberEdit"}))>0
				AAdd(aFunc,j)
			endif
			if !Empty(aFunc)
				if myType=="M"
					ASort(aFunc,,,{|x,y| x>=y})
					for j:=1 to Len(aFunc) 
						ADel(aMenu,aFunc[j])   // not transaction change allowed for batch poster
						ASize(aMenu,Len(aMenu)-1)
					next
				else
					ADel(aMenu,i)   // not posting allowed for transaction changer
					ASize(aMenu,Len(aMenu)-1)
				endif
			endif
		endif
	endif
	IF !Empty(EmployeeId) .and.!myType=="A"
		IF !lSystemAdmin 
			// Lookup alle allowed menu items of the employee:
			* Determine allowed subset of menu items for this employee: 
			aMenuAct:=ArrayCreate(Len(aMenu)) 
			Do while !oAuthF:EoF 
				if !IsNil(oAuthF:mFUNCNAME)
					nFunc:=Val(oAuthF:mFUNCNAME) 
					if (i:=AScan(aMenu,{|x|x[MACCEL]==nFunc}))>0
						aMenuAct[i]:=1 
					endif 
				endif
				oAuthF:Skip()
			enddo
			FOR i:= Len(aMenuAct) DOWNTO 1
				IF !Empty(aMenu[i,MEVENT]).and. IsNil(aMenuAct[i]) .and.!aMenu[i,MAUTH]="Z"
					ADel(aMenu,i)
					ASize(aMenu,Len(aMenu)-1)
				endif
			NEXT
		ENDIF
		oAuthF:Close()
		oAuthF:=null_object
	ENDIF 
	* Remove empty submenu's and separators:
	i:=SubMenu(aMenu,99)
	IF Empty(i)
		RETURN {} //empty array
	ENDIF
	* remove dummy overall menu:
	ADel(aMenu,1)
	ASize(aMenu,Len(aMenu)-1)
	
	* Remove deleted items:
	FOR i:= Len(aMenu) DOWNTO 1
		IF aMenu[i,MPARENTID]==9999
			ADel(aMenu,i)
			ASize(aMenu,Len(aMenu)-1)
		ENDIF
	NEXT

	RETURN aMenu
FUNCTION InitSystemMenu() as array
* Initialise table wth standard system menus
*
LOCAL nMax:=0 as int
LOCAL nFirst, nSub as int
LOCAL oLan as Language
	oLan:=Language{}

* Add print and exit functions to first menu:
* Look for first submenu:
nFirst:=AScan(aMenu,{|x|!Empty(x[MITEMTEXT]).and.Empty(x[MEVENT])})
IF nFirst=0
*	no submenu found, add one:
	AAdd(aMenu,{0,1, "&File","","",0,0,"P"})
	nSub:=1
ELSE
	nSub:=aMenu[nFirst,MITEMID]
	nSub:=Min(1,nSub)
ENDIF
AAdd(aMenu,{nSub,95,,,,,})           // separator
AAdd(aMenu,{nSub,96, oLan:MGet("P&rint Setup"),"FilePrinterSetup",oLan:MGet("Setup printer option"),0,0,"P"})
AAdd(aMenu,{nSub,97, oLan:MGet("&Print..."),"FilePrint",oLan:MGet("Print the active window"),IDT_PRINT,109,"P"})
AAdd(aMenu,{nSub,98,,,,,})           // separator
AAdd(aMenu,{nSub,99,  oLan:MGet("E&xit	Alt+F4"),"FileExit",oLan:MGet("End of application"),0,WOMENU_File_Exit_ID,"P"})
* Add System functions to end:
AEval(aMenu,{|x| nMax:=Max(x[1],nMax)})
++nMax
AAdd(aMenu,{0,nMax, oLan:MGet("&Edit"),,,,,})
AAdd(aMenu,{nMax,1, oLan:MGet("Cu&t	Ctrl+X"),"Cut",oLan:MGet("Cut"),IDT_CUT, WOMENU_Edit_Cut_ID})
AAdd(aMenu,{nMax,2, oLan:MGet("&Copy	Ctrl+C"),"Copy",oLan:MGet("Copy"),IDT_COPY, WOMENU_Edit_Copy_ID})
AAdd(aMenu,{nMax,3, oLan:MGet("&Paste	Ctrl+V"),"Paste",oLan:MGet("Paste"),IDT_PASTE, WOMENU_Edit_Paste_ID})
AAdd(aMenu,{nMax,4,,,,,})           // separator
AAdd(aMenu,{nMax,5, oLan:MGet("G&o To Top	Ctrl+Home"),"GoTop",oLan:MGet("Go to first record"),IDT_STARTREC,WOMENU_Edit_Go_To_Top_ID})
AAdd(aMenu,{nMax,6, oLan:MGet("Go To &Bottom	Ctrl+End"),"GoBottom",oLan:MGet("Go to last record"),IDT_ENDREC,WOMENU_Edit_Go_To_Bottom_ID})
++nMax
AAdd(aMenu,{0,nMax, oLan:MGet("&Window"),,,,,})
AAdd(aMenu,{nMax,1, oLan:MGet("&Cascade"),"WindowCascade",oLan:MGet("Arrange child windows in a cascade"),0,0})
AAdd(aMenu,{nMax,2, oLan:MGet("&Tile"),"WindowTile",oLan:MGet("Arrange child windows tiled"),0,0})
++nMax
AAdd(aMenu,{0,nMax, oLan:MGet("Help"),,,,,})
AAdd(aMenu,{nMax,1, oLan:MGet("Check for &updates"),"CheckNewVersion",oLan:MGet("Check New Version"),0,WOMENU_CheckNew_ID})
AAdd(aMenu,{nMax,3,,,,,})           // separator
AAdd(aMenu,{nMax,1, oLan:MGet("&What is New"),"WhatIsNew",oLan:MGet("What Is New"),0,WOMENU_WhatNew_ID})
AAdd(aMenu,{nMax,1, oLan:MGet("&Content"),"HelpContents",oLan:MGet("Contents"),0,0})
AAdd(aMenu,{nMax,2, oLan:MGet("&Index	F1"),"HelpIndex",oLan:MGet("Index"),0,WOMENU_Help_Index_ID})
AAdd(aMenu,{nMax,3,,,,,})           // separator
AAdd(aMenu,{nMax,4, oLan:MGet("&About"),"HelpAboutDialog",,0,0})
RETURN aMenu
DEFINE MACCEL:=7
DEFINE MAUTH:=8
DEFINE MEVENT:=4
DEFINE MICON:=6
DEFINE MITEMID:=2
DEFINE MITEMTEXT:=3
DEFINE MPARENTID:=1
DEFINE MTIP:=5
FUNCTION SubMenu(aMenu,myParent, nCurPos)
*	Clean submenu's from empty submenu's or superfluous separators
*	returns:	9999: eof
*			    >0: item found
*				0: nothing found
	LOCAL p, i, nLen, p1,  nTot AS INT
	LOCAL aMyItems:={} AS ARRAY // array with items of submenu of myParent
Default(@nCurPos,0)
*IF Empty(nCurPos).or.!aMenu[nCurPos,MPARENTID]==myParent
*		nCurPos:=AScan(aMenu,{|x|x[MPARENTID]==myParent })
*ELSE
	*++nCurPos
*ENDIF		
nCurPos:=AScan(aMenu,{|x|x[MPARENTID]==myParent },nCurPos+1)

IF Empty(nCurPos)
	RETURN 9999
ENDIF
IF Empty(aMenu[nCurpos,MEVENT]).and.!Empty(aMenu[nCurPos,MITEMTEXT]) // submenu?
	* determine all child items:
	p:=SubMenu(aMenu,aMenu[nCurPos,MITEMID])
	p1:=p
	DO WHILE p<9999
		IF !Empty(p)
			AAdd(aMyItems,p)
			p1:=p
		ENDIF
		p:=SubMenu(aMenu,aMenu[nCurPos,MITEMID],p1)
	ENDDO
	* remove superfluous separators:
	nLen:=Len(aMyItems)
	nTot:=nLen
	FOR i:=nLen DOWNTO 1
		p1:=aMyItems[i]
		IF Empty(aMenu[p1,MITEMTEXT])  // separator?
			IF i>1
				IF Empty(aMenu[aMyItems[i-1],MITEMTEXT])  // previous separator too?
					* remove separator:
					aMenu[p1,MPARENTID]:=9999
					--nTot
				ELSE
					IF i==nTot  // at end
						* remove separator:
						aMenu[p1,MPARENTID]:=9999
						--nTot
					ENDIF
				ENDIF
			ELSE
				* separator at begin, remove it:
				aMenu[p1,MPARENTID]:=9999
				--nTot
			ENDIF
		ENDIF
	NEXT
	IF nTot==0
		* remove submenu item:
		aMenu[nCurpos,MPARENTID]:=9999
		RETURN 0
	ENDIF
ENDIF
RETURN nCurPos
CLASS WOBalanceSubMenu INHERIT WOBrowserMenu
METHOD Init(oOwner) CLASS  WOBalanceSubMenu
LOCAL oTB AS ToolBar
LOCAL oSub AS  WycMenu
SUPER:Init(oOwner)
	oSub:=WycMenu{}
	oSub:AppendItem(WOBalanceSubmenu_Balance_Item_ID,	;
		HyperLabel{#Append,	;
			"&Balance Item",	;
			,	;
			,})
   	IF AScan(aMenu,{|x| x[4]=="AccountEdit"})>0
		oSub:AppendItem(WOBalanceSubmenu_Account_ID,	;
		HyperLabel{#AppendAccount,	;
			"&Account",	;
			,	;
			,})
	ENDIF
	SELF:InsertItem(oSub,"Insert Record",WOMENU_Insert_Record_ID)
	SELF:DeleteItem(WOMENU_Insert_Record_ID)

	oTB := SELF:ToolBar

	oTB:DeleteItem(WOMENU_Insert_Record_ID)

*	oTB:AppendItem(IDT_ARROW,WOBalanceSubmenu_Balance_Item_ID)
*	oTB:AddTipText(IDT_ARROW,WOBalanceSubmenu_Balance_Item_ID,"Insert a Balance Item")
 *
*	oTB:AppendItem(IDT_INDENT,WOBalanceSubmenu_Account_ID)
*	oTB:AddTipText(IDT_INDENT,WOBalanceSubmenu_Account_ID,"Insert Account")

	oTB:AppendItem(IDT_INDENT,WOBalanceSubmenu_Balance_Item_ID)
	oTB:AddTipText(IDT_INDENT,WOBalanceSubmenu_Balance_Item_ID,"Insert a Balance Item")
   	IF AScan(aMenu,{|x| x[4]=="AccountEdit"})>0
		oTB:AppendItem(IDT_ARROW,WOBalanceSubmenu_Account_ID)
		oTB:AddTipText(IDT_ARROW,WOBalanceSubmenu_Account_ID,"Insert Account")
   	ENDIF

	SELF:ToolBar := oTB

	RETURN SELF
DEFINE WOBalanceSubmenu_Account_ID := 9096
Define WOBalanceSubmenu_Balance_Item_ID := 9095
CLASS WOBrowserMENU INHERIT WOMENU
METHOD Init(oOwner) CLASS WOBrowserMENU
LOCAL oTB AS ToolBar
SUPER:Init(oOwner)
SELF:InsertItem(WOMENU_Edit_Record_ID,;
		HyperLabel{#Editbutton,	;
			"&Edit Record",	;
			,	;
			,}, WOMENU_Edit_Go_To_Top_ID)
SELF:InsertItem(WOMENU_Insert_Record_ID,	;
		HyperLabel{#Append,	;
			"&Insert Record",	;
			"Insert a record",	;
			,}, WOMENU_Edit_Go_To_Top_ID)
SELF:InsertItem(WOMENU_Delete_Record_ID,	;
		HyperLabel{#Delete,	;
			"&Delete Record",	;
			"Delete a record",	;
			,}, WOMENU_Edit_Go_To_Top_ID)
	SELF:RegisterItem(WOMENU_Edit_Record_ID,	;
		HyperLabel{#Editbutton,	;
			"&Edit Record",	;
			,	;
			,})
	SELF:RegisterItem(WOMENU_Insert_Record_ID,	;
		HyperLabel{#Append,	;
			"&Insert Record",	;
			"Insert a record",	;
			,})
	SELF:RegisterItem(WOMENU_Delete_Record_ID,	;
		HyperLabel{#Delete,	;
			"&Delete Record",	;
			"Delete a record",	;
			,})
SELF:InsertItem(MENUSEPARATOR,,WOMENU_Edit_Go_To_Top_ID)
oTB := SELF:ToolBar

oTB:AppendItem(IDT_SEPARATOR)

	oTB:AppendItem(IDT_OPEN,WOMENU_Edit_Record_ID)
	oTB:AddTipText(IDT_OPEN,WOMENU_Edit_Record_ID,"Edit Record")

	oTB:AppendItem(IDT_UNINDENT,WOMENU_Delete_Record_ID)
	oTB:AddTipText(IDT_UNINDENT,WOMENU_Delete_Record_ID,"Delete this record")

	oTB:AppendItem(IDT_INDENT,WOMENU_Insert_Record_ID)
	oTB:AddTipText(IDT_INDENT,WOMENU_Insert_Record_ID,"Insert a record")

SELF:ToolBar:=oTB
RETURN SELF
CLASS WOBrowserMENUFIND INHERIT WOBrowserMENU
METHOD Init(oOwner) CLASS WOBrowserMENUFIND
SUPER:Init(oOwner)
self:AddFind()
RETURN self
CLASS WOBrowserMENUShort INHERIT WOMENU
METHOD Init(oOwner) CLASS WOBrowserMENUShort
LOCAL oTB as ToolBar
SUPER:Init(oOwner)
self:DeleteItem(WOMENU_Edit_Cut_ID)
self:DeleteItem(WOMENU_Edit_Copy_ID)
self:DeleteItem(WOMENU_Edit_Paste_ID)
RETURN self
CLASS WODepartmentSubMenu INHERIT WOBrowserMenu
METHOD Init(oOwner) CLASS  WODepartmentSubMenu
LOCAL oTB AS ToolBar
LOCAL oSub AS  WycMenu
SUPER:Init(oOwner)
	oSub:=WycMenu{}
	oSub:AppendItem(WODepartmentSubmenu_Department_ID,	;
		HyperLabel{#Append,	;
			"&Department",	;
			,	;
			,})
   	IF AScan(aMenu,{|x| x[4]=="AccountEdit"})>0
		oSub:AppendItem(WODepartmentSubmenu_Account_ID,	;
		HyperLabel{#AppendAccount,	;
			"&Account",	;
			,	;
			,})
	ENDIF
	SELF:InsertItem(oSub,"Insert Record",WOMENU_Insert_Record_ID)
	SELF:DeleteItem(WOMENU_Insert_Record_ID)

	oTB := SELF:ToolBar

	oTB:DeleteItem(WOMENU_Insert_Record_ID)

	oTB:AppendItem(IDT_INDENT,WODepartmentSubmenu_Department_ID)
	oTB:AddTipText(IDT_INDENT,WODepartmentSubmenu_Department_ID,"Insert a Department")
   	IF AScan(aMenu,{|x| x[4]=="AccountEdit"})>0
		oTB:AppendItem(IDT_ARROW,WODepartmentSubmenu_Account_ID)
		oTB:AddTipText(IDT_ARROW,WODepartmentSubmenu_Account_ID,"Insert Account")
    ENDIF
	SELF:ToolBar := oTB

	RETURN SELF
Define WODepartmentSubmenu_Account_ID := 9153
Define WODepartmentSubmenu_Department_ID := 9152
CLASS WOMenu INHERIT WycMenu
METHOD AddFind(oOwner) CLASS WOMENU
LOCAL oTB as ToolBar
self:InsertItem(WOMENU_FIND_Record,	;
		HyperLabel{#Find,	;
			"&Find Record	CTRL-F",	;
			"Find a record",	;
			,}, WOMENU_Edit_Go_To_Top_ID)
	self:RegisterItem(WOMENU_FIND_Record,	;
		HyperLabel{#Find,	;
			"&Find Record	CTRL-F",	;
			"Find a record",	;
			,})
oTB := self:ToolBar
oTB:AppendItem(IDT_FIND,WOMENU_FIND_Record)
oTB:AddTipText(IDT_FIND,WOMENU_FIND_Record,"Find a record") 
self:ToolBar:=oTB
RETURN 
METHOD Init(oOwner) CLASS WOMenu
	LOCAL oTB AS ToolBar
	LOCAL i, nSub:=0 AS INT
SUPER:Init(oOwner)
AEval(aMenu,{|x| nSub:=nSub+if(x[MPARENTID]==0,1,0)})

SELF:AddSubItem(0)
* Determine last submenu (Windows) and make it autoupdate:
SELF:SetAutoUpDate( nSub-2 )

* Add Toolbar icons:
oTB := ToolBar{ }
oTB:ButtonStyle := TB_ICONONLY
FOR i:=1 TO Len(aMenu)
	IF Len(aMenu[i])>=MICON
		IF !Empty(aMenu[i,MICON])
			* Toolbar icon:
			oTB:AppendItem(aMenu[i,MICON],aMenu[i,MACCEL])
			oTB:AddTipText(aMenu[i,MICON],aMenu[i,MACCEL],aMenu[i,MTIP])
		ENDIF
	ENDIF
NEXT
SELF:ToolBar:=oTB
SELF:Accelerator := WOMENU_Accelerator{}
RETURN SELF
CLASS WOMENU_Accelerator INHERIT Accelerator
METHOD Init( ) CLASS WOMENU_Accelerator
	SUPER:Init(ResourceID{AWOMENU, _GetInst( )})

	RETURN SELF
DEFINE WOMENU_CheckNew_ID := 26328
DEFINE WOMENU_Delete_Record_ID := 12797
DEFINE WOMENU_Edit_Copy_ID := 26313
DEFINE WOMENU_Edit_Cut_ID := 26312
DEFINE WOMENU_Edit_Go_To_Bottom_ID := 26321
DEFINE WOMENU_Edit_Go_To_Top_ID := 26319
DEFINE WOMENU_Edit_Paste_ID := 26314
DEFINE WOMENU_Edit_Record_ID := 12795
DEFINE WOMENU_File_Exit_ID := 22026
DEFINE WOMENU_FIND_Record := 12798
DEFINE WOMENU_Help_Index_ID := 26327
DEFINE WOMENU_Insert_Record_ID := 12796
DEFINE WOMENU_WhatNew_ID := 26329
CLASS WOMENUFIND INHERIT WOMENU


METHOD Init(oOwner) CLASS WOMENUFIND
SUPER:Init(oOwner)
self:AddFind()
RETURN self
CLASS WycMenu INHERIT Menu
METHOD AddMenuItem(myParentId,myItemId,myEVENT,myITEMTEXT,myTIP,myACCEL) CLASS WycMenu
* Add  menuitem specified by array aMyItem  to ist submenu
*
* Returns submenu object if applicable
*
LOCAL oSubmenu AS WycMenu
LOCAL oHyp AS Hyperlabel
LOCAL nItemId AS INT

IF Empty(myITEMTEXT)
	* separator:
	SELF:AppendItem(MENUSEPARATOR)
ELSEIF Empty(myEVENT)
	* submenu:
	oSubmenu:=WycMenu{}
	SELF:AppendItem(oSubmenu,myITEMTEXT)
ELSE
	oHyp:=Hyperlabel{String2Symbol(myEVENT),myITEMTEXT,myTIP}
	if empty(myACCEL)
		nItemId:=myParentId*100+myItemId
	else
		nItemId:=myACCEL
	endif
	SELF:AppendItem(nItemId,oHyp)
	SELF:RegisterItem(nItemId,oHyp)
ENDIF
RETURN oSubmenu
METHOD AddSubItem (nItem) CLASS WycMenu
* Add  submenuitem nItem with its submenuitems to current submenu
*
LOCAL i:=0, nStart:=1  , ParentId AS INT
LOCAL oSub AS WycMenu

* add item self:
IF nItem>0
	oSub:=(SELF:AddMenuItem(aMenu[nItem,MPARENTID],aMenu[nItem,MITEMID],aMenu[nItem,MEVENT],;
	aMenu[nItem,MITEMTEXT],aMenu[nItem,MTIP],aMenu[nItem,MACCEL]))
ELSE
	oSub:=SELF
ENDIF
IF !oSub==NULL_OBJECT
	IF nItem>0
		ParentId:=aMenu[nItem,MITEMID]
	ENDIF
	DO WHILE i<Len(aMenu)
		i:=AScan(aMenu,{|x| x[MPARENTID]==ParentId},nStart)
		IF i > 0
			oSub:AddSubItem(i)
			nStart:=i+1
		ELSE
			EXIT
		ENDIF
	ENDDO
ENDIF
RETURN
