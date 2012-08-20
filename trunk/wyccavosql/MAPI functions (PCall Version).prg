STATIC FUNCTION _MAPIExit() AS VOID PASCAL
	IF hLib != NULL_PTR
		MemSet( @sMAPI , 0 , _sizeof( SimpleMAPIVtbl ) )
		FreeLibrary( hLib )
	ENDIF
	
STATIC FUNCTION _MAPIInit() AS LOGIC PASCAL

	LOCAL lResult := FALSE AS LOGIC

	
	IF hLib == NULL_PTR
// 		IF File("\Program Files\Common Files\SYSTEM\MAPI\1043\95\MAPI32.DLL")
// 			hLib := LoadLibrary( PSZ( _CAST , "\Program Files\Common Files\SYSTEM\MAPI\1043\95\MAPI32.DLL" ) )
// 		ELSE
			hLib := LoadLibrary( PSZ( _CAST , "MAPI32.DLL" ) )
// 		ENDIF
		IF hLib != NULL_PTR
			_RegisterExit( @_MAPIExit() )
			lResult := TRUE
			sMAPI.pFreeBuffer    := GetProcAddress( hLib , PSZ( _CAST , "MAPIFreeBuffer" ) )
			sMAPI.pLogoff        := GetProcAddress( hLib , PSZ( _CAST , "MAPILogoff" ) )
			sMAPI.pLogon         := GetProcAddress( hLib , PSZ( _CAST , "MAPILogon" ) )
			sMAPI.pDeleteMail    := GetProcAddress( hLib , PSZ( _CAST , "MAPIDeleteMail" ) )
			sMAPI.pFindNext      := GetProcAddress( hLib , PSZ( _CAST , "MAPIFindNext" ) )
			sMAPI.pSendMail      := GetProcAddress( hLib , PSZ( _CAST , "MAPISendMail" ) )
			sMAPI.pReadMail      := GetProcAddress( hLib , PSZ( _CAST , "MAPIReadMail" ) )
			sMAPI.pResolveName   := GetProcAddress( hLib , PSZ( _CAST , "MAPIResolveName" ) )
			sMAPI.pSendDocuments := GetProcAddress( hLib , PSZ( _CAST , "MAPISendDocuments" ) )
			sMAPI.pSaveMail      := GetProcAddress( hLib , PSZ( _CAST , "MAPISaveMail" ) )
			sMAPI.pAddress       := GetProcAddress( hLib , PSZ( _CAST , "MAPIAddress" ) )
			sMAPI.pDetails       := GetProcAddress( hLib , PSZ( _CAST , "MAPIDetails" ) )
		ENDIF	
	ELSE
		lResult := TRUE	
	ENDIF
	RETURN lResult
STATIC GLOBAL hLib AS PTR
FUNCTION IsMAPIAvailable() as logic pascal

	LOCAL nResult as LONG
	LOCAL phkResult,mailResult as ptr
	LOCAL lVista as LOGIC
	LOCAL lpData, cRequired, cCurrent,cCurrentVersion as psz
	LOCAL cbData as DWORD                                                                          

	local MyClient:=requiredemailclient as int
	local cError as string, lFatal as logic
	nResult := RegOpenKeyEx( HKEY_LOCAL_MACHINE , ;
		String2Psz('SOFTWARE\Microsoft\Windows Messaging Subsystem') ,0,KEY_QUERY_VALUE, @phkResult )
	IF nResult == ERROR_SUCCESS
		lpData  := Space(256)
		cbData  := 256			
		nResult := RegQueryValueEx( phkResult , ;
			String2Psz("MAPI") , ;
			null_ptr , ;
			null_ptr , ;
			lpData , ;
			@cbData ) 

		IF ( nResult == ERROR_SUCCESS ) .and. ( lpData = "1" )
			// Determine OS: Vista or higher:
			nResult := RegOpenKeyEx( HKEY_LOCAL_MACHINE , String2Psz('SOFTWARE\Microsoft\Windows NT\CurrentVersion') ,;
				0,KEY_QUERY_VALUE, @mailResult )
			IF ( !nResult == ERROR_SUCCESS )
				LogEvent(," No currentversion:"+Str(nResult,-1),"MailError") 
			else
				cCurrentVersion  := Space(256)
				cbData  := 256			
				nResult := RegQueryValueEx( mailResult , ;
					String2Psz("ProductName") , ;
					null_ptr , ;
					null_ptr , ;
					cCurrentVersion , ;
					@cbData )
				IF !nResult == ERROR_SUCCESS
					LogEvent(,"Currentversion:("+Str(nResult,-1)+") "+lpData,"MailError")
				else
					lVista:=iif(AtC('XP',cCurrentVersion)>0,false,true)
				endif
			endif
			                                                                      
			// Determine required client and available client	in cRequired 
			if MyClient == 4   // Determine if Mapi2Xml present (tool to interface to webclients like Gmail):
				nResult := RegOpenKeyEx( HKEY_LOCAL_MACHINE , String2Psz('SOFTWARE\Clients\Mail\Mapi2Xml') ,;
				0,KEY_QUERY_VALUE, @mailResult )
				IF ( nResult == ERROR_SUCCESS )
					cRequired:="Mapi2Xml"
				else
					MyClient:=-1  // switch to current client					
					LogEvent(,"Mapi2Xml-1:"+Str(nResult,-1),"MailError")
				endif				
			endif 
			if MyClient == 3   // Determine if Windows Live Mail present:
				nResult := RegOpenKeyEx( HKEY_LOCAL_MACHINE , String2Psz('SOFTWARE\Clients\Mail\Windows Live Mail') ,;
				0,KEY_QUERY_VALUE, @mailResult )
				IF ( nResult == ERROR_SUCCESS )
					cRequired:="Windows Live Mail"
				else
					MyClient:=-1  // switch to current client					
					LogEvent(," Live Mail-2:"+Str(nResult,-1),"MailError")
				endif				
			endif 
			if MyClient == 2   // Determine if Thunderbird present:
				nResult := RegOpenKeyEx( HKEY_LOCAL_MACHINE , ;
					String2Psz('SOFTWARE\Clients\Mail\Mozilla Thunderbird') ,0,KEY_QUERY_VALUE, @phkResult )
				IF ( nResult == ERROR_SUCCESS )
					cRequired:="Mozilla Thunderbird"
				else
					MyClient:=-1  // switch to current client					
					LogEvent(,"Thunderbird-3:"+Str(nResult,-1),"MailError")
				endif				
			endif 

			if MyClient == 1 
				// is Microsoft Outlook available?
				nResult := RegOpenKeyEx( HKEY_LOCAL_MACHINE , String2Psz('SOFTWARE\Clients\Mail\Microsoft Outlook') ,;
					0,KEY_QUERY_VALUE, @mailResult )
				IF ( nResult == ERROR_SUCCESS )
					cRequired:="Microsoft Outlook" 
// 					LogEvent(,"3:"+Str(nResult,-1),"MailError")
				else
					MyClient:=-1  // switch to current client
					LogEvent(,"Outlook_4:"+Str(nResult,-1),"MailError")
				endif
			endif
			If MyClient==0
				if lVista
					nResult := RegOpenKeyEx( HKEY_LOCAL_MACHINE , String2Psz('SOFTWARE\Clients\Mail\Windows Live Mail') ,;
					0,KEY_QUERY_VALUE, @mailResult )
					IF ( nResult == ERROR_SUCCESS )
						cRequired:="Windows Live Mail"
					else
						cRequired:="Windows Mail"
					endif
				else
					cRequired:="Outlook Express"
				endif
			endif
			// Read current email client:
			If lVista 
				// read HKCU 
				nResult:=RegCreateKeyEx(HKEY_CURRENT_USER,String2Psz('SOFTWARE\Clients\Mail'),0,"",REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,0,@phkResult,@cbData)
				IF nResult == ERROR_SUCCESS
					lpData  := Space(256)
					cbData  := 256			
					nResult := RegQueryValueEx( phkResult , ;
						"" , ;
						null_ptr , ;
						null_ptr , ;
						lpData , ;
						@cbData )
					cCurrent:=lpData
					IF !nResult == ERROR_SUCCESS
						LogEvent(,"HKCU_6:("+Str(nResult,-1)+") "+lpData,"MailError")
					endif
				else
					LogEvent(,"HKCU_5:("+Str(nResult,-1)+") "+cRequired,"MailError")					
				endif
			endif
			if Empty(cCurrent)
				// read HKLM:
				nResult:=RegCreateKeyEx(HKEY_LOCAL_MACHINE,String2Psz('SOFTWARE\Clients\Mail'),0,"",REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,0,@phkResult,@cbData)
				IF nResult == ERROR_SUCCESS
					cCurrent  := Space(256)
					cbData  := 256			
					nResult := RegQueryValueEx( phkResult , ;
						"" , ;
						null_ptr , ;
						null_ptr , ;
						cCurrent , ;
						@cbData )
					IF !nResult == ERROR_SUCCESS
						LogEvent(,"HKLM-7:("+Str(nResult,-1)+") "+lpData,"MailError")
					endif
				else
					LogEvent(,"8:("+Str(nResult,-1)+") "+cCurrent,"MailError")
				endif				
			endif
         if MyClient<0
         	// switch to current client:
         	cRequired:=cCurrent
				cError:="the default email client "+cCurrent+" will be used."
         endif
			// compare required with current:
			if !cRequired==cCurrent		 
				if lVista 	
					// Write required client to HKCU
					nResult := RegOpenKeyEx( HKEY_CURRENT_USER , String2Psz('SOFTWARE\Clients\Mail') ,0,KEY_ALL_ACCESS, @phkResult )
					IF nResult == ERROR_SUCCESS
						// set key:
						nResult:=RegSetValueEx(phkResult, ;
							"", ;
							0,	;
							REG_SZ, ;
							ptr(_cast,cRequired)	, ;
							DWORD(_cast,Len(cRequired)+1 ))
						IF nResult == ERROR_SUCCESS
							cCurrent:=cRequired
						else
							LogEvent(,"9 "+cRequired+" not set:("+Str(nResult,-1)+") "+cCurrent,"MailError")							
						endif
					endif
				else
					// write required client to HKLM 
					nResult := RegOpenKeyEx( HKEY_LOCAL_MACHINE , String2Psz('SOFTWARE\Clients\Mail') ,0,KEY_ALL_ACCESS, @phkResult )
					IF nResult == ERROR_SUCCESS
						// set key:
						nResult:=RegSetValueEx(phkResult, ;
							"", ;
							0,	;
							REG_SZ, ;
							ptr(_cast,cRequired)	, ;
							DWORD(_cast,Len(cRequired)+1 ))
						IF nResult == ERROR_SUCCESS
							cCurrent:=cRequired
// 							LogEvent(,"10:("+Str(nResult,-1)+") "+cCurrent,"MailError") 
						else
							LogEvent(,"11:"+Str(nResult,-1),"MailError") 							
						endif
					endif
				endif
			endif
		else
			// 			ErrorBox{,"There is no interface to your email client on your computer"}:Show() 
			cError:="There is no interface to your email client on your computer; you have to send manually." 
			lFatal:=true
		endif
	else 
		LogEvent(,"Windows Messaging Subsystem-12:"+Str(nResult,-1),"MailError") 							
		cError:=  "You have no permission to read register for mail parameters: "+DosErrString(nResult)+";"+CRLF+"the default email client will be used."
		// 		ErrorBox{,"You have no permission to read register for mail parameters: "+Str(nResult,-1)}:Show() 
		
	endif
	if !cCurrent==cRequired
		if !Empty(cCurrent)
			cError:="You have no permission to change email client to "+cRequired+"; it remains "+cCurrent
		else
			cError:="You have no permission to change email client to "+cRequired+";"+CRLF+"the default email client will be used."
		endif
	endif
	if !Empty(cError)
		LogEvent(,cError,"MailError") 							
		WarningBox{,"Sending by email",cError}:Show()
	endif
	EmailClient:=cCurrent
	RegCloseKey(HKEY_LOCAL_MACHINE)
	RegCloseKey(HKEY_CURRENT_USER) 
	// 	LogEvent(,"12 end:"+cCurrent,"MailError") 
	//    if Empty(emailclient)
	//    	return false
	//    endif
	RETURN true
FUNCTION MAPIAddress( lhSession AS DWORD , ;
		ulUIParam AS DWORD , ;
		lpszCaption AS PSZ , ;
		nEditFields AS DWORD , ;
		lpszLabels AS PSZ , ;
		nRecips AS DWORD , ;
		lpRecips AS PTR , ;
		flFlags AS DWORD , ;
		ulReserved AS DWORD , ;
		lpnNewRecips AS DWORD , ;
		lppNewRecips AS PTR ) AS DWORD PASCAL

 	LOCAL nResult AS DWORD

	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pAddress , lhSession , ;
					ulUIParam , ;
					PSZ( _CAST , lpszCaption ) , ;
					nEditFields , ;
					PSZ( _CAST , lpszLabels ) , ;
					nRecips , ;
					lpRecips , ;
					flFlags , ;
					ulReserved , ;
					lpnNewRecips , ;
					lppNewRecips ) )
   	ENDIF

	RETURN nResult	

FUNCTION MAPIDeleteMail( lhSession AS DWORD , ;
		ulUIParam AS DWORD , ;
		lpszMessageID AS PSZ , ;
		flFlags AS DWORD , ;
		ulReserved AS DWORD ) AS DWORD PASCAL

	LOCAL nResult AS DWORD

	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pDeleteMail , lhSession , ;
					ulUIParam , ;
					PSZ( _CAST , lpszMessageID ) , ;
					flFlags , ;
					ulReserved ) )
	ENDIF
	
	RETURN nResult	

FUNCTION MAPIDetails( lhSession AS DWORD , ;
		ulUIParam AS DWORD , ;
		lpRecip AS PTR , ;
		flFlags AS DWORD , ;
		ulReserved AS DWORD ) AS DWORD PASCAL

 	LOCAL nResult AS DWORD

	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pDetails , lhSession , ;
					ulUIParam , ;
					lpRecip , ;
					flFlags , ;
					ulReserved ) )
   	ENDIF

	RETURN nResult	

FUNCTION MAPIFindNext( lhSession AS DWORD , ;
		ulUIParam AS DWORD , ;
		lpszMessageType AS PSZ , ;
		lpszSeedMessageID AS PSZ , ;
		flFlags AS DWORD , ;
		ulReserved AS DWORD , ;
		lpszMessageID AS PSZ ) AS DWORD PASCAL

	LOCAL nResult AS DWORD

	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pFindNext , lhSession , ;
					ulUIParam , ;
					PSZ( _CAST , lpszMessageType ) , ;
					PSZ( _CAST , lpszSeedMessageID ) , ;
					flFlags , ;
					ulReserved , ;
					PSZ( _CAST , lpszMessageID ) ) )
	ENDIF

	RETURN nResult	

FUNCTION MAPIFreeBuffer( lpMemory AS PTR ) AS DWORD PASCAL

	LOCAL nResult AS DWORD

	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pFreeBuffer , lpMemory ) )
	ENDIF

	RETURN nResult

FUNCTION MAPILogoff( lhSession AS DWORD , ;
		ulUIParam AS DWORD , ;
		flFlags AS DWORD , ;
		ulReserved AS DWORD ) AS DWORD PASCAL

	LOCAL nResult AS DWORD

	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pLogoff , ;
					lhSession , ;
					ulUIParam , ;
					flFlags , ;
					ulReserved ) )
	ENDIF
	
	RETURN nResult	

FUNCTION MAPILogon( ulUIParam AS DWORD , ;
		lpszName AS PSZ , ;
		lpszPassword AS PSZ , ;
		flFlags AS DWORD , ;
		ulReserved AS DWORD , ;
		lphSession REF DWORD ) AS DWORD PASCAL

	LOCAL nResult AS DWORD
	
	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pLogon , ;
					ulUIParam , ;
					PSZ( _CAST , lpszName ) , ;
					PSZ( _CAST , lpszPassword ) , ;
					flFlags , ;
					0 , ;
					@lphSession ) )
	ENDIF
	
	RETURN nResult	
FUNCTION MAPIReadMail( lhSession AS DWORD , ;
		ulUIParam AS DWORD , ;
		lpszMessageID AS PSZ , ;
		flFlags AS DWORD , ;
		ulReserved AS DWORD , ;
		lppMessage AS PTR ) AS DWORD PASCAL

	LOCAL nResult AS DWORD

	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pReadMail , lhSession , ;
					ulUIParam , ;
					PSZ( _CAST , lpszMessageID ) , ;
					flFlags , ;
					ulReserved , ;
					lppMessage ) )
	ENDIF

	RETURN nResult	

FUNCTION MAPIResolveName( lhSession AS DWORD , ;
		ulUIParam AS DWORD , ;
		lpszName AS PSZ , ;
		flFlags AS DWORD , ;
		ulReserved AS DWORD , ;
		lppRecip AS PTR ) AS DWORD PASCAL

	LOCAL nResult AS DWORD

	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pResolveName , lhSession , ;
				ulUIParam , ;
				PSZ( _CAST , lpszName ) , ;
				flFlags , ;
				ulReserved , ;
				lppRecip ) )
   	ENDIF

	RETURN nResult	
FUNCTION MAPISaveMail( lhSession AS DWORD , ;
		ulUIParam AS DWORD , ;
		lpMessage AS PTR , ;
		flFlags AS DWORD , ;
		ulReserved AS DWORD , ;
		lpszMessageID AS PSZ ) AS DWORD PASCAL

 	LOCAL nResult AS DWORD

	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pSaveMail , lhSession , ;
					ulUIParam , ;
					lpMessage , ;
					flFlags , ;
					ulReserved , ;
					PSZ( _CAST , lpszMessageID ) ) )
   	ENDIF

	RETURN nResult	

FUNCTION MAPISendDocuments( ulUIParam AS DWORD , ;
		lpszDelimChar AS PSZ , ;
		lpszFilePaths AS PSZ , ;
		lpszFileNames AS PSZ , ;
		ulReserved AS DWORD ) AS DWORD PASCAL

 	LOCAL nResult AS DWORD

	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pSendDocuments , ulUIParam , ;
					PSZ( _CAST , lpszDelimChar ) , ;
					PSZ( _CAST , lpszFilePaths ) , ;
					PSZ( _CAST , lpszFileNames ) , ;
					ulReserved ) )
   	ENDIF

	RETURN nResult	

FUNCTION MAPISendMail( lhSession AS DWORD , ;
		ulUIParam AS DWORD , ;
		lpMessage AS PTR , ;
		flFlags AS DWORD , ;
		ulReserved AS DWORD ) AS DWORD PASCAL

	LOCAL nResult AS DWORD

	IF _MAPIInit()	
		nResult := DWORD( _CAST , PCALL( sMAPI.pSendMail , lhSession , ;
					ulUIParam , ;
					lpMessage , ;
					flFlags , ;
					ulReserved ) )
	ENDIF

	RETURN nResult	

TEXTBLOCK PCALL-VERSION

STRUCTURE SimpleMAPIVtbl
	MEMBER pFreeBuffer AS PTR
	MEMBER pLogoff AS PTR
	MEMBER pLogon AS PTR
	MEMBER pDeleteMail AS PTR
	MEMBER pFindNext AS PTR
	MEMBER pSendMail AS PTR
	MEMBER pReadMail AS PTR
	MEMBER pResolveName AS PTR
	MEMBER pSendDocuments AS PTR
	MEMBER pSaveMail AS PTR
	MEMBER pAddress AS PTR
	MEMBER pDetails AS PTR
	
STATIC GLOBAL sMAPI IS SimpleMAPIVtbl
