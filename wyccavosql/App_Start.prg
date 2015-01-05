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
	local nErr as Dword 
	local cUser  as string
	local startfile,cWorkdir as STRING
	local cFatalError as string
	LOCAL lFirstuser as LOGIC
	local lStop as logic
	local FirstOfDay as logic
	LOCAL aDir as ARRAY
	LOCAL oError      as USUAL
	LOCAL cbError     as CODEBLOCK
	LOCAL mainsize as Dimension
	LOCAL oInit as Initialize 
	Local oLogonDialog as LogonDialog
	local oNew as NewPasswordDialog 
	local oStJournal as StandingOrderJournal
	local oUpg as CheckUPGRADE
	local oYrCl as YearClosing

	cbError := ErrorBlock( {|oError|MyDefError(oError)} )
	BEGIN SEQUENCE
		Enable3dControls()
		DynSize(256) // (not more possible = 16MB)
		SetMaxDynSize(268435456)   //256MB max dynamic memory  
		SetWipeDynSpace(false)
		SetKidStackSize(134217728)    // 128 mb
		SetMaxRegisteredKids(131072)
		SetMaxThreadDynSize(268435456)  //256 MB Thread memory 
		SetMaxRegisteredAxitMethods(131072)  
		SetExclusive( FALSE )
		CurPath:= iif(Empty(CurDrive()),CurDir(CurDrive()),CurDrive()+":"+if(Empty(CurDir(CurDrive())),"","\"+CurDir(CurDrive())))
		SetDefault(CurPath)
		SetPath(CurPath)
		myApp:=self 
		HelpDir:=GetEnv("Temp")
		
		cWorkdir:=WorkDir() 
		oMainWindow := StandardWycWindow{self}
		oMainWindow:Show(SHOWZOOMED )
		LOGON_EMP_ID:=self:GetUser()   // prelimninary
		oInit:=Initialize{}  // make connection with mysql and database   
		oUpg:=CheckUPGRADE{}
		oMainWindow:Pointer := Pointer{POINTERHOURGLASS}
		oUpg:LoadNewTables(cWorkdir,oInit:FirstOfDay)
		if !oInit:lNewDB .and. (oInit:FirstOfDay .or. oUpg:DBVers>oUpg:PrgVers .or. oUpg:DBVersDate>oUpg:PrgVersDate) 
			// 			lStop:=oUpg:LoadUpgrade(@startfile,cWorkdir,oInit:FirstOfDay)
			lStop:=oUpg:LoadInstallerUpgrade(@startfile,cWorkdir,oInit:FirstOfDay)
		endif

		if lStop .and.!Empty(startfile)
			if Empty(startfile)
				lStop:=false
			else
				oMainWindow:STATUSMESSAGE("installing new version")
				if oConn:Connected
					oConn:Disconnect()
				endif
				if	(nErr:=self:Run(startfile))<33
					(ErrorBox{,"Could not start installation program "+startfile+" (error:"+Str(nErr,-1)+"; "+DosErrString(nErr)+")"}):Show()
					lStop:=False
				endif
			endif
		endif
		if lStop
			// Exit program
			self:Quit() 
			break
		else
			// Open main shell window

			WycIniFS := IniFileSpec{ "WYC" }
			mainsize:=oMainWindow:Size
			WinScale:=mainsize:Width/808.00
			// 			IF (WycIniFS:GetInt( "Runtime", "Maximized" ) # 1 )
			// 				oMainWindow:Show(SHOWCENTERED)
			// 				mainsize:=Dimension{WycIniFS:GetInt( "Runtime", "Maximized" )}
			// 			ENDIF
			oInit:Initialize(oUpg:DBVers,oUpg:PrgVers,oUpg:DBVersDate,oUpg:PrgVersDate) 
			oUpg:=null_object
			FirstOfDay:=oInit:FirstOfDay 
			oInit:=null_object 
			SetDeleted( true )
			
			#IFNDEF __debug__
				// 		(SplashScreen{self}):Show()
			#ENDIF		 
			oMainWindow:Pointer := Pointer{POINTERARROW}

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
						(oNew:=NewPasswordDialog{oMainWindow}):show()
						IF !oNew:ChangePsw
							// Exit program
							self:Quit() 
							break
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
				// Backup if needed:
				BackupDatabase{oMainWindow}:MakeBackup() 
				if BackupToLocal
					BackupDatabase{oMainWindow}:MakeBackupToLocal(false) 
				endif
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
			IF FirstLogin .or. FirstOfDay
				IF	AScan(aMenu,{|x| x[4]=="CheckSuspense"})>0
					AlertSuspense{}:Alert()				
				ENDIF 
				if AScan(aMenu,{|x| x[4]=="CheckBankBalance"})>0
					AlertBankbalance{}:Alert()
				endif				
				AlertNew{}:ShowNew()
				//	Idem for	year closing:
				IF AScan(aMenu,{|x| x[4]=="YearClosing"})>0
					oYrCl:=YearClosing{oMainWindow}
					if oYrCl:CheckYearClosing(oMainWindow)
						oYrCl:Show()
					endif				
				ENDIF 
			endif
			oMainWindow:Pointer := Pointer{POINTERARROW}
			self:Exec()
		endif
	RECOVER USING oError	 
// 		GetError(self, "Error in Wycliffe Office System")
// 		ShowError( oError )
		Eval(ErrorBlock(),oError)
	end SEQUENCE
	self:Quit()
