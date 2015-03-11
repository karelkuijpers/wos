STATIC DEFINE FILEOPENDIALOG_ACCOUNTRADIOBUTTON := 102 
STATIC DEFINE FILEOPENDIALOG_ARTICLERADIOBUTTON := 105 
STATIC DEFINE FILEOPENDIALOG_CANCELBUTTON := 107 
STATIC DEFINE FILEOPENDIALOG_DUEAMOUNTBUTTON := 109 
STATIC DEFINE FILEOPENDIALOG_FILETYPE := 108 
STATIC DEFINE FILEOPENDIALOG_MEMBERRADIOBUTTON := 101 
STATIC DEFINE FILEOPENDIALOG_OKBUTTON := 106 
STATIC DEFINE FILEOPENDIALOG_PERIODICRADIOBUTTON := 103 
STATIC DEFINE FILEOPENDIALOG_PERSONRADIOBUTTON := 100 
STATIC DEFINE FILEOPENDIALOG_SUBSCRITIONRADIOBUTTON := 104 
STATIC DEFINE FILEOPENDIALOG_TELEBANKRADIOBUTTON := 110 
STATIC DEFINE HELPABOUT_PUSHBUTTON1 := 104 
STATIC DEFINE HELPABOUT_THEFIXEDICON1 := 100 
STATIC DEFINE HELPABOUT_THEFIXEDTEXT1 := 101 
STATIC DEFINE HELPABOUT_THEFIXEDTEXT2 := 102 
STATIC DEFINE HELPABOUT_THEFIXEDTEXT3 := 103 
DEFINE IDI_STANDARDICON := 101
DEFINE IDS_ERROR := 65520
DEFINE IDS_EXCHANGE_NOT_INSTALLED := 65521
DEFINE IDS_SAVE := 65522
STATIC DEFINE MAILDLG_PBCANCEL := 101 
STATIC DEFINE MAILDLG_PBSEND := 102 
STATIC DEFINE MAILDLG_RICHEDIT1 := 100 
CLASS StandardWycWindow INHERIT SHELLWINDOW 


  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
 Protect oPrinter as PrintingDevice 
METHOD ChangeMailCode() CLASS StandardWycWindow
	(SelPers{self,"CHANGEMAILINGCODE"}):Show()
	RETURN
Method CheckFinancialData() CLASS StandardWycWindow
	* Check correspondence between transactions and monthvalues in MonthBalance 
	local cFatalError as string
	CheckConsistency(self,false,true,@cFatalError) 
return
method CheckNewVersion() class StandardWycWindow
local startfile, cWorkDir as string
local  lStop as logic
local oUpg as CheckUPGRADE
local oSel as SqlSelect
cWorkDir:=WorkDir()
// Check if nody else is online:
oSel:=SqlSelect{"select empid from employee where online=1 and empid<>"+MYEMPID,oConn}
if oSel:reccount>0
	ErrorBox{self,"Others are still logged in, so new version can't be installed"}:show()
	return
endif
oUpg:=CheckUPGRADE{}
lStop:=oUpg:LoadInstallerUpgrade(@startfile,cWorkDir)
if lStop .and.!Empty(startfile)					
	if	myApp:Run(startfile)<33
		(ErrorBox{,"Could not start installation program "+startfile}):Show()
		lStop:=False
	endif
else
	(TextBox{,"Check new version","No new version found"}):Show()
endif
if lStop
   SQLStatement{"update employee set online='0' where empid='"+MYEMPID+"'",oConn}:Execute()
	myApp:Quit()
endif 
return
	
METHOD Close(oCloseEvent) CLASS StandardWycWindow

	myApp:Quit()
	SUPER:Close(oCloseEvent)
METHOD CloseAll() CLASS StandardWycWindow
	
	DO WHILE ALen(self:aChildWindows) > 0
		IF IsObject( self:aChildWindows[1]).and.! self:aChildWindows[1]==null_object
			self:aChildWindows[1]:Close()
			CollectForced()
		ELSE
			ADel(self:aChildWindows,1)
		ENDIF
	ENDDO
METHOD Donations() CLASS StandardWycWindow
	(SubscriptionBrowser{self,,,"DONATIONS"}):Show()
	RETURN
METHOD DonationsMail() CLASS StandardWycWindow
	// first see if there are new donations which should generate a dueamount:
	do while ProlongateAll(oMainWindow)
	enddo		
	SaveUse("DonationsMail")
	(Selpers{self,"DONATIONS"}):Show()
	RETURN
METHOD FileExit() CLASS StandardWycWindow

	self:EndWindow()
	
METHOD FilePrint() CLASS StandardWycWindow
	SELF:Print()
	RETURN
METHOD FilePrinterSetup() CLASS StandardWycWindow 
	if Empty(self:oPrinter)
		self:oPrinter	:= PrintingDevice{}
	endif
	self:oPrinter:Setup()
	
METHOD FirstGivers() CLASS StandardWycWindow
	SaveUse("FIRSTGIVERS")
	(Selpers{self,"FIRSTGIVERS"}):Show()
	RETURN
METHOD FirstNonEarmarked() CLASS StandardWycWindow
	(SelPers{self,"FIRSTNONEAR"}):Show()
	RETURN
METHOD HelpAboutDialog() CLASS StandardWycWindow
	LOCAL oOD AS HelpAbout
	
	(oOD := HelpAbout{SELF}):Show()
	
METHOD HelpContents CLASS StandardWycWindow
	LOCAL nResult AS DWORD
	GetHelpDir()
	nResult := HTMLHelp(;
		SELF:Handle(),;
		psz(_cast,HelpDir+"/" + "WOSHlp.chm::/Introduction.htm"), ;
		HH_DISPLAY_TOPIC,;
		0)


	RETURN
METHOD HelpIndex CLASS StandardWycWindow
	LOCAL nResult AS DWORD
	GetHelpDir()
	nResult := HTMLHelp(;
		SELF:Handle(),;
		psz(_cast,HelpDir+"/"+ "WOSHlp.chm::/Introduction.htm"), ;
		HH_DISPLAY_INDEX,;
		0)



	RETURN SELF
METHOD Init(oParent,uExtra) CLASS StandardWycWindow 

self:PreInit(oParent,uExtra)

super:Init(oParent,uExtra)

SELF:Caption := "Wycliffe Office System"
SELF:HyperLabel := HyperLabel{#StandardWycWindow,"Wycliffe Office System",NULL_STRING,NULL_STRING}
SELF:IconSm := SSAICON{}
SELF:Icon := SSAICON{}
SELF:Origin := Point{13, 447}
SELF:Size := Dimension{743, 597}

self:PostInit(oParent,uExtra)

return self

METHOD MailViaCode() CLASS StandardWycWindow
	(SelPers{self,"MAILINGCODE"}):Show()
	RETURN
method MenuCommand(oMenuCommandEvent )  class StandardWycWindow
	local oMyCommandEvent:=oMenuCommandEvent as MenuCommandEvent
	local oMenu:=oMyCommandEvent:Menu as Menu 
	local cName,cCaption as string
	// 	LogEvent(self,"menu executed"+ oMyCommandEvent:AsString(),"logmenu")
	super:MenuCommand(oMenuCommandEvent)
	//Put your changes here
	cName:=oMyCommandEvent:Menu:Name(oMyCommandEvent:ItemID) 
	cCaption:=oMyCommandEvent:AsString()
	if !Empty(cCaption) 
		LogEvent(self,"menu executed "+cCaption+'; '+oMyCommandEvent:HyperLabel:Name+"; menu name:"+ cName,"logmenu") 
	endif
	return 	
   method MenuSelectOld(oMenuSelectEvent) class StandardWycWindow 
   local oMySelectEvent:=oMenuSelectEvent as MenuSelectEvent 
   local oMenu:=oMySelectEvent:Menu as Menu 
   local cName,cCaption as string 
	super:MenuSelect(oMySelectEvent)
	//Put your changes here \
	cName:=oMySelectEvent:Menu:Name(oMySelectEvent:ItemID) 
	cCaption:=oMySelectEvent:AsString()
	if !Empty(cCaption) 
// 		LogEvent(self,"menu selected "+oMySelectEvent:AsString()+'; '+oMySelectEvent:HyperLabel:Name+"; menu name:"+ cName,"logmenu") 
	endif
	return nil
	// ErrorBlock(cbError)
	



METHOD PeriodicGift() CLASS StandardWycWindow
	(SubscriptionBrowser{self,,,"STANDARD GIFTS"}):Show()
	RETURN
	// METHOD Donations() CLASS StandardWycWindow
	// 	(SubscriptionBrowser{SELF,,,"DONATIONS"}):Show()
	// 	RETURN
	// METHOD RefreshMenu() CLASS StandardWycWindow
	// 	GetUserMenu(LOGON_EMP_ID)
	// 	SELF:Menu:=WOMenu{}
	// 	SELF:Menu:ToolBar:Hide()
	// RETURN
	// METHOD StandardGiversMail() CLASS StandardWycWindow
	// 	(Selpers{SELF,"STANDARD GIVERS"}):Show()
	// 	RETURN
	// METHOD MailViaCode() CLASS StandardWycWindow
	// 	(Selpers{SELF,"MAILINGCODE"}):Show()
	// 	RETURN
ACCESS Printer CLASS StandardWycWindow
	
	return self:oPrinter
METHOD QueryClose( oEvent ) CLASS StandardWycWindow
	LOCAL cRoot := "WYC\Runtime" AS STRING
	SUPER:QueryClose( oEvent)

	if TextBox{, "Quit", "Do you really want to quit?",BOXICONQUESTIONMARK + BUTTONYESNO}:Show()== BOXREPLYYES
	* Save runtime PARAMETERS:
	
    	SetRTRegString( cRoot, "AlgTaal", Alg_Taal )
	   SetRTRegInt( cRoot, "Maximized", if(self:IsZoomed(),1,0) )
		// Stop clickyes to be sure:
		myApp:Run("ClickYes.exe -stop")  
		SQLStatement{"set autocommit=0",oConn}:Execute()
		SQLStatement{'lock tables `employee` write',oConn}:Execute()
      SQLStatement{"update employee set online='0' where empid='"+MYEMPID+"'",oConn}:Execute()
		SQLStatement{"commit",oConn}:Execute()
		SQLStatement{"unlock tables",oConn}:Execute() 
		SQLStatement{"set autocommit=1",oConn}:Execute()
		RETURN TRUE // Quit application.
	ELSE
		RETURN FALSE
		// Don't quit the application.
	ENDif
	
METHOD RefreshMenu() CLASS StandardWycWindow
	GetUserMenu(LOGON_EMP_ID)
	self:Menu:=WOMenu{}
	self:Menu:ToolBar:Hide()
RETURN
METHOD RemoveChild( oChild ) CLASS StandardWycWindow
	LOCAL nChild AS WORD
	
	nChild := AScan( self:aChildWindows, oChild )
	
	IF nChild > 0
		ADel(self:aChildWindows, nChild)
		ASize(self:aChildWindows, ALen(self:aChildWindows) - 1)
	ENDIF
METHOD SetCaption() CLASS StandardWycWindow 
	local sysname as string
	local oSys as SQLSelect
	if IsObject(oConn) .and.!oConn== null_object 
		if oConn:Connected
			if SqlSelect{"show tables like 'sysparms'",oConn}:RecCount>0
				oSys:=SqlSelect{"select sysname from sysparms",oConn}
				if oSys:RecCount>0
					sysname:=oSys:sysname
				endif
			endif
		endif
	endif
	IF !Empty(sysname)
		SELF:Caption:=AllTrim(sysname)
	ELSE
		IF ADMIN=="HO"
			SELF:Caption := "Wycliffe Home Front System"
		ELSEIF ADMIN=="GI"
			SELF:Caption := "Wycliffe Gift Journaling System"
		ELSEIF ADMIN=="GE"
			SELF:Caption := "Wycliffe Journaling and Mailing System"
		ELSE
			SELF:Caption := "Wycliffe Office System"
		ENDIF
	ENDIF 
	if !Empty(LOGON_EMP_ID) 
		self:Caption+=Space(30)+"("+LOGON_EMP_ID+")"
	endif
	RETURN	
METHOD StandardGiversMail() CLASS StandardWycWindow
	(SelPers{self,"STANDARD GIVERS"}):Show()
	RETURN
METHOD SubScriptions() CLASS StandardWycWindow
	(SubscriptionBrowser{self,,,"SUBSCRIPTIONS"}):Show()
	RETURN
METHOD SubScriptionsMail() CLASS StandardWycWindow
	// first see if there are new subscriptions which should generate a dueamount:
	do while ProlongateAll(oMainWindow)
	enddo		
	SaveUse("SubScriptionsMail")
	(Selpers{self,"SUBSCRIPTIONS"}):Show()
	RETURN
METHOD ThankYouLetters() CLASS StandardWycWindow
	SaveUse("THANKYOU")
	(Selpers{self,"THANKYOU"}):Show()
	RETURN
METHOD WhatIsNew CLASS StandardWycWindow
	LOCAL nResult as DWORD  
	GetHelpDir()
	nResult := HTMLHelp(;
		self:Handle(),;
		psz(_cast,HelpDir+"/" + "WosSQLNew.chm::/WhatIsNew3_0.htm"), ;
		HH_DISPLAY_TOPIC,;
		0)


	RETURN
METHOD WindowCascade() CLASS StandardWycWindow

	self:Arrange(ARRANGECASCADE)
METHOD WindowIcon() CLASS StandardWycWindow

	self:Arrange(ARRANGEASICONS)
METHOD WindowTile() CLASS StandardWycWindow

	self:Arrange(ARRANGETILE)
