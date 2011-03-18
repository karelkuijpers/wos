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
	

	// cbError := ErrorBlock( {|e|_Break(e)} )

	BEGIN SEQUENCE
		Enable3dControls() 
		SetMaxDynSize(67108864)   //64MB max dynamic memory
		SetWipeDynSpace(false)
		SetKidStackSize(524288)
		SetMaxRegisteredKids(60000)
		SetMaxThreadDynSize(33554432)  //32 MB Tread memory 
		SetMaxRegisteredAxitMethods(32000)
		SetExclusive( FALSE )
		CurPath:= iif(Empty(CurDrive()),CurDir(CurDrive()),CurDrive()+":"+if(Empty(CurDir(CurDrive())),"","\"+CurDir(CurDrive())))
		SetDefault(CurPath)
		SetPath(CurPath)
		myApp:=self 
		oUpg:=CheckUPGRADE{} 
		cWorkdir:=WorkDir()
		oInit:=Initialize{} 
		lStop:=oUpg:LoadUpgrade(@startfile,cWorkdir,oInit:FirstOfDay)
		if lStop
			if oConn:Connected
				oConn:Disconnect()
			endif					
			if	self:Run(startfile)<33
				(ErrorBox{,"Could not start installation program "+startfile+"("+DosErrString(DosError())}):Show()
				lStop:=False
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
			oInit:Initialize()
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
			* Process standing orders:
			IF FirstOfDay
				oMainWindow:Pointer := Pointer{POINTERHOURGLASS} 
				oStJournal:=StandingOrderJournal{}
				oStJournal:recordstorders()
				oStJournal:=null_object
				// Idem for prolongations of subscriptions (donations): 
				do while ProlongateAll(oMainWindow)
				enddo		
				oMainWindow:Pointer := Pointer{POINTERARROW} 
			ENDIF
			// Idem for reevaluation: 
			IF AScan(aMenu,{|x| x[4]=="Reevaluation"})>0	
				Reevaluation{oMainWindow}:ReEvaluate()
			ENDIF 
			
			self:Exec()
			// RECOVER USING oError	 
			//   	GetError(self, "Error in Wycliffe Office System")
			//   	ShowError( oError )
		endif
	end SEQUENCE

	// ErrorBlock(cbError)
	

