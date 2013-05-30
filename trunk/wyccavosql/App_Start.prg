METHOD GetUser() CLASS App
* Determine Logon Name of current user
*
* returns username
*
LOCAL lpzUserName:=psz(_cast,Space(33)) as psz
LOCAL UserName as STRING
LOCAL nLen:=32 as DWORD 
IF GetUserName(lpzUserName,@nLen)
	UserName:=AllTrim(Psz2String(lpzUserName))
ENDIF
RETURN UserName

method Start() class App
	LOCAL aDir as ARRAY
	local cUser  as string
	LOCAL lFirstuser as LOGIC
	LOCAL mainsize as Dimension
	LOCAL oInit as Initialize 
	Local oLogonDialog as LogonDialog
	local oNew as NewPasswordDialog 
	LOCAL oError      as USUAL
	LOCAL cbError     as CODEBLOCK
	local FirstOfDay as logic
	local oStJournal as StandingOrderJournal
	local startfile,cWorkdir as STRING
	local oUpg as CheckUPGRADE
	local lStop as logic
	local nErr as Dword 
	local cFatalError as string

	// cbError := ErrorBlock( {|e|_Break(e)} )
	BEGIN SEQUENCE
		Enable3dControls() 
		SetMaxDynSize(268435456)   //256MB max dynamic memory
		SetWipeDynSpace(false)
		SetKidStackSize(1048576)
		SetMaxRegisteredKids(131072)
		SetMaxThreadDynSize(67108864)  //64 MB Thread memory 
		SetMaxRegisteredAxitMethods(65536)
		SetExclusive( FALSE )
		CurPath:= iif(Empty(CurDrive()),CurDir(CurDrive()),CurDrive()+":"+if(Empty(CurDir(CurDrive())),"","\"+CurDir(CurDrive())))
		SetDefault(CurPath)
		SetPath(CurPath)
		myApp:=self
		IF Len(aDir:=Directory("C:\WINDOWS\TEMP",FA_DIRECTORY))>0
			HelpDir:='C:\Windows\Temp'
		elseif Len(aDir:=Directory("C:\Users\"+myApp:GetUser()+"\AppData\Local\Temp",FA_DIRECTORY))>0 
			HelpDir:="C:\Users\"+myApp:GetUser()+"\AppData\Local\Temp"
		ELSEIF Len(aDir:=Directory("C:\TEMP",FA_DIRECTORY))>0
			HelpDir:="C:\TEMP"
		ELSE
			HelpDir:="C:"
		ENDIF
		
		cWorkdir:=WorkDir() 
		LOGON_EMP_ID:=self:GetUser()   // prelimninary
		oInit:=Initialize{}  // make connection with mysql and database
		oUpg:=CheckUPGRADE{}
		if !oInit:lNewDB .and. (oInit:FirstOfDay .or. oUpg:DBVers>oUpg:PrgVers) 
			// 			lStop:=oUpg:LoadUpgrade(@startfile,cWorkdir,oInit:FirstOfDay)
			lStop:=oUpg:LoadInstallerUpgrade(@startfile,cWorkdir)
		endif 
		if lStop .and.!Empty(startfile)
			if Empty(startfile)
				lStop:=false
			else
				if oConn:Connected
					oConn:Disconnect()
				endif					
				if	(nErr:=self:Run(startfile))<33
					(ErrorBox{,"Could not start installation program "+startfile+" (error:"+Str(nErr,-1)+"; "+DosErrString(nErr)+")"}):Show()
					lStop:=False
				endif
			endif
		endif
		if !lStop
			// Open main shell window

			WycIniFS := IniFileSpec{ "WYC" }
			if oMainWindow==null_object
				oMainWindow := StandardWycWindow{self}
			endif
			oMainWindow:Show( SHOWZOOMED )
			mainsize:=oMainWindow:Size
			WinScale:=mainsize:Width/808.00
			IF (WycIniFS:GetInt( "Runtime", "Maximized" ) # 1 )
				oMainWindow:Show(SHOWCENTERED)
				mainsize:=Dimension{WycIniFS:GetInt( "Runtime", "Maximized" )}
			ENDIF
			oInit:Initialize(oUpg:DBVers,oUpg:PrgVers)
			FirstOfDay:=oInit:FirstOfDay
			oInit:=null_object
			SetDeleted( true )
			
			#IFNDEF __debug__
				// 		(SplashScreen{self}):Show()
			#ENDIF		 

			If IsFirstUse( (cUser:=self:GetUser()))
				( FirstUser{ oMainWindow ,,, cUser } ):Show()
				IF Empty(LOGON_EMP_ID)
					// Exit program
					self:Quit() 
					break
				ENDIF
			endif
			IF !GetUserMenu((cUser:=self:GetUser()))
				( oLogonDialog := LogonDialog{ oMainWindow, cUser } ):Show()
				IF oLogonDialog:logonOk
					LOGON_EMP_ID := AllTrim(oLogonDialog:logonID)
					IF oLogonDialog:ChangePsw
						oNew:=NewPasswordDialog{oMainWindow}
						oNew:Show()
						IF !oNew:ChangePsw
							// Exit program
							self:Quit()
						ENDIF
						oNew:=null_object
					ENDIF
				ELSE
					( ErrorBox{ nil, "Sorry, logon attempt failed!" } ):Show()

					// Exit program
					self:Quit() 
					break
				ENDIF
			ENDIF
			
			* reinit and reassign menu:
			oMainWindow:Menu:=WOMenu{}
			oMainWindow:Menu:ToolBar:Hide()
			// Run program
			IF FirstOfDay
				oMainWindow:Pointer := Pointer{POINTERARROW}
				* Process standing orders:
				oStJournal:=StandingOrderJournal{}
				oStJournal:recordstorders()
				oStJournal:=null_object 
				// Process prolongations of subscriptions (donations): 
				do while ProlongateAll(oMainWindow)
				enddo		
				// Check consistency data
				oMainWindow:STATUSMESSAGE("Checking data")
				CheckConsistency(oMainWindow,true,false,@cFatalError) 
				oMainWindow:STATUSMESSAGE(Space(80))
				oMainWindow:Pointer := Pointer{POINTERARROW}
			endif
			// Idem for reevaluation: 
			IF AScan(aMenu,{|x| x[4]=="Reevaluation"})>0
				Reevaluation{oMainWindow}:ReEvaluate()				
			ENDIF 
			// Idem for alert: 
			IF AScan(aMenu,{|x| x[4]=="CheckSuspense"})>0
				AlertSuspense{}:Alert()				
			ENDIF 
			IF FirstLogin.and.AScan(aMenu,{|x| x[4]=="CheckBankBalance"})>0
				AlertBankbalance{}:Alert()				
			ENDIF
			if FirstLogin
				AlertNew{}:ShowNew()
			endif
			oMainWindow:Pointer := Pointer{POINTERARROW}
			
			self:Exec()
			// RECOVER USING oError	 
			//   	GetError(self, "Error in Wycliffe Office System")
			//   	ShowError( oError )
		endif
	end SEQUENCE

	// ErrorBlock(cbError)
	

