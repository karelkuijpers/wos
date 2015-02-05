DEFINE MAPI_AB_NOMODIFY						:= 0x00000400
DEFINE MAPI_ALLOW_OTHERS					:= 0x00000008
DEFINE MAPI_BCC								:= 3
DEFINE MAPI_BODY_AS_FILE					:= 0x00000200
DEFINE MAPI_CC								:= 2
DEFINE MAPI_DIALOG							:= 0x00000008
DEFINE MAPI_E_ACCESS_DENIED					:= 6
DEFINE MAPI_E_AMBIG_RECIP					:= 21
DEFINE MAPI_E_AMBIGUOUS_RECIPIENT			:= 21
DEFINE MAPI_E_ATTACHMENT_NOT_FOUND			:= 11
DEFINE MAPI_E_ATTACHMENT_OPEN_FAILURE		:= 12
DEFINE MAPI_E_ATTACHMENT_WRITE_FAILURE		:= 13
DEFINE MAPI_E_BAD_RECIPTYPE					:= 15
DEFINE MAPI_E_DISK_FULL						:= 4
DEFINE MAPI_E_FAILURE						:= 2
DEFINE MAPI_E_INSUFFICIENT_MEMORY			:= 5
DEFINE MAPI_E_INVALID_EDITFIELDS			:= 24
DEFINE MAPI_E_INVALID_MESSAGE				:= 17
DEFINE MAPI_E_INVALID_RECIPS				:= 25
DEFINE MAPI_E_INVALID_SESSION				:= 19
DEFINE MAPI_E_LOGIN_FAILURE					:= 3
DEFINE MAPI_E_LOGON_FAILURE					:= 3
DEFINE MAPI_E_MESSAGE_IN_USE				:= 22
DEFINE MAPI_E_NETWORK_FAILURE				:= 23
DEFINE MAPI_E_NO_MESSAGES					:= 16
DEFINE MAPI_E_NOT_SUPPORTED					:= 26
DEFINE MAPI_E_TEXT_TOO_LARGE				:= 18
DEFINE MAPI_E_TOO_MANY_FILES				:= 9
DEFINE MAPI_E_TOO_MANY_RECIPIENTS			:= 10
DEFINE MAPI_E_TOO_MANY_SESSIONS				:= 8
DEFINE MAPI_E_TYPE_NOT_SUPPORTED			:= 20
DEFINE MAPI_E_UNKNOWN_RECIPIENT				:= 14
DEFINE MAPI_E_USER_ABORT					:= 1
DEFINE MAPI_ENVELOPE_ONLY					:= 0x00000040
DEFINE MAPI_EXPLICIT_PROFILE				:= 0x00000010
DEFINE MAPI_EXTENDED						:= 0x00000020
DEFINE MAPI_FORCE_DOWNLOAD					:= 0x00001000
DEFINE MAPI_GUARANTEE_FIFO					:= 0x00000100
DEFINE MAPI_LOGOFF_SHARED					:= 0x00000001
DEFINE MAPI_LOGOFF_UI						:= 0x00000002
DEFINE MAPI_LOGON_UI						:= 0x00000001
DEFINE MAPI_LONG_MSGID						:= 0x00004000
DEFINE MAPI_NEW_SESSION						:= 0x00000002
DEFINE MAPI_OLE								:= 0x00000001
DEFINE MAPI_OLE_STATIC						:= 0x00000002
DEFINE MAPI_ORIG							:= 0
DEFINE MAPI_PASSWORD_UI             		:= 0x00020000
DEFINE MAPI_PEEK							:= 0x00000080
DEFINE MAPI_RECEIPT_REQUESTED				:= 0x00000002
DEFINE MAPI_SENT							:= 0x00000004
DEFINE MAPI_SIMPLE_DEFAULT					:= MAPI_LOGON_UI + MAPI_FORCE_DOWNLOAD + MAPI_ALLOW_OTHERS
DEFINE MAPI_SIMPLE_EXPLICIT					:= MAPI_NEW_SESSION + MAPI_FORCE_DOWNLOAD + MAPI_EXPLICIT_PROFILE
DEFINE MAPI_SUPPRESS_ATTACH					:= 0x00000800
DEFINE MAPI_TO								:= 1
DEFINE MAPI_UNREAD							:= 0x00000001
DEFINE MAPI_UNREAD_ONLY						:= 0x00000020
DEFINE MAPI_USE_DEFAULT						:= 0x00000040
DEFINE MAPI_USER_ABORT						:= 1
CLASS MAPISession

	PROTECT hSession AS DWORD
	PROTECT pszMessageID AS PSZ
	PROTECT pszSeed AS PSZ
	PROTECT oMessage AS MAPIMsg
	PROTECT oClick AS CLICKYES

	DECLARE METHOD SendDocument, Resolvename,ResolveNameOld
method Axit() class MAPISession
	MemFree( self:pszMessageID )
	MemFree( self:pszSeed )
	
METHOD Close() CLASS MAPISession

	LOCAL nResult AS DWORD
	myApp:Run("ClickYes.exe -stop")
	nResult := MAPILogoff( SELF:hSession , 0 , 0 , 0 )
	
	IF nResult == SUCCESS_SUCCESS
		SELF:hSession := 0	
	ENDIF
	
	RETURN ( nResult == SUCCESS_SUCCESS )
	
METHOD Delete( cMessageID ) CLASS MAPISession

	LOCAL nResult AS DWORD

	IF IsString( cMessageID )
		MemSet( SELF:pszMessageID , 0 , 128 )
		MemCopy( SELF:pszMessageID , String2Psz( AllTrim( cMessageID ) ) , SLen( cMessageID ) )
	ENDIF

	nResult := MAPIDeleteMail( SELF:hSession , ;
						0 , ;
						SELF:pszMessageID , ;
						0 , ;
						0 )
						
	RETURN ( nResult == SUCCESS_SUCCESS )

method FindFirst() class MAPISession

	local lResult as logic

	MemSet( self:pszSeed , 0 , 128 )
	lResult	:= self:FindNext()
	
	return lResult
	
METHOD FindNext() CLASS MAPISession

	LOCAL nResult AS DWORD
	MemSet( SELF:pszMessageID , 32 , 128 )
	nResult := MAPIFindNext( SELF:hSession , ;
							0 , ;
							PSZ( _CAST , "" ) , ;
							SELF:pszSeed , ;
							MAPI_GUARANTEE_FIFO , ;
							0 , ;
							SELF:pszMessageID )

	MemMove( SELF:pszSeed , SELF:pszMessageID , pszLen( SELF:pszMessageID ) )
	
	RETURN ( nResult == SUCCESS_SUCCESS )

METHOD Init() CLASS MAPISession
	SELF:hSession := 0
	SELF:pszMessageID := MemAlloc( 128 )
	SELF:pszSeed      := MemAlloc( 128 )	
	//RegisterKid( PTR( _CAST , SELF ) , 1 , FALSE )
	RegisterAxit( SELF )
	// launch click-yes:
	myApp:Run("ClickYes.exe -activate")
	
	oClick:=CLICKYES{}
	RETURN SELF

access IsOpen() class MAPISession
	return ( self:hSession <> 0 )
	
access Message() class MAPISession
	return self:oMessage

assign Message( oMessage ) class MAPISession
	return self:oMessage := oMessage
	
METHOD NewSendCustom( cMsgType , oMessage ) CLASS MAPISession

	LOCAL nResult AS DWORD
	
	LOCAL sMessage AS MAPIMessage
	LOCAL pszSubject AS PSZ
	LOCAL pszNoteText AS PSZ
	LOCAL pszMessageType AS PSZ
	//LOCAL aRecip AS DWORD PTR
	LOCAL DIM aRecip[ 65 ] AS MAPIRecipDesc
	LOCAL sRecip AS MAPIRecipDesc
	
	LOCAL i AS DWORD

	cMsgType 		:= "IPM." + cMsgType
	sMessage		:= MemAlloc( _sizeof( MAPIMessage ) )

	MemSet( sMessage , 0 , _sizeof( MAPIMessage ) )	

	pszSubject     := StringAlloc( oMessage:Subject )
	pszNoteText    := StringAlloc( oMessage:NoteText )
	pszMessageType := StringAlloc( cMsgType )
	
	sMessage.ulReserved			:= 0
	sMessage.lpszSubject		:= pszSubject
	sMessage.lpszNoteText		:= pszNoteText
	sMessage.lpszMessageType	:= pszMessageType
	
	sMessage.lpszDateReceived	:= ""
	sMessage.lpszConversationID	:= ""
	sMessage.flFlags			:= 0

	aRecip := PTR( DWORD , MemAlloc( ALen( oMessage:RecipList ) * _sizeof( DWORD ) ) )
	
	FOR i := 1 TO ALen( oMessage:RecipList )
		aRecip[i]			:= DWORD( _CAST , MemAlloc( _sizeof( MAPIRecipDesc ) ) )
		sRecip 				:= PTR( _CAST , aRecip[i] )
		sRecip.ulReserved	:= 0
		sRecip.ulRecipClass	:= MAPI_TO
		sRecip.lpszName		:= StringAlloc( oMessage:RecipList[i]:Name )
		sRecip.lpszAddress	:= StringAlloc( oMessage:RecipList[i]:Address )
		sRecip.ulEIDSize	:= 0
		sRecip.lpEntryID	:= NULL_PTR
	NEXT
	
	sMessage.lpRecips		:= aRecip
	sMessage.nRecipCount	:= oMessage:RecipCount
	sMessage.lpOriginator	:= NULL_PTR
	sMessage.nFileCount		:= 0
	sMessage.lpFiles		:= NULL_PTR

	nResult := MAPISendMail( ;
					SELF:hSession , ;
					0 , ;
					sMessage , ;
					0 , ;
					0 )

	MemFree( sMessage )
	MemFree( pszSubject )
	MemFree( pszNoteText )
	MemFree( pszMessageType )

	FOR i := 1 TO Len( oMessage:RecipList )
		sRecip := PTR( _CAST , aRecip[i] )
		MemFree( sRecip.lpszName )
		MemFree( sRecip.lpszAddress )
		MemFree( aRecip[i] )
	NEXT

	IF nResult == SUCCESS_SUCCESS
		MessageBox( 0 , "SUCCESS" , "" , MB_OK )
	ENDIF
	
	RETURN ( nResult == SUCCESS_SUCCESS )

method Open( cUser , cPassword ) class MAPISession

	local nResult as dword
	local nSession as dword	
	local nFlags as dword

	// Parameter checking
	default( @cUser     , "" )
	default( @cPassword , "" )

	if empty( cUser ) .or. empty( cPassword )
		nFlags := MAPI_LOGON_UI
	endif

	nResult := MAPILogon( 	0 , ;
							cUser , ;
							cPassword , ;
							nFlags , ;
							0 , ;
							@nSession )
	
	if nResult == SUCCESS_SUCCESS
		self:hSession := nSession
	endif

	return ( nResult == SUCCESS_SUCCESS )

 method Read( cMessageID ) class MAPISession

	local nResult as dword
	local sMessage as MAPIMessage

	if IsString( cMessageID )
		MemSet( self:pszMessageID , 0 , 128 )
		MemCopy( self:pszMessageID , String2PSZ( alltrim( cMessageID ) ) , SLen( cMessageID ) )
	endif
	
	nResult := MAPIReadMail( self:hSession , ;
							0 , ;
							self:pszMessageID , ;
							0 , ;
							0 , ;
							@sMessage )

	if nResult == SUCCESS_SUCCESS
		self:oMessage := MAPIMsg{}
		MemCopy( self:oMessage:pszMsgID , self:pszMessageID , 128 )
		self:oMessage:Struc2Obj( sMessage )
		MAPIFreeBuffer( sMessage )
	endif
	
	return ( nResult == SUCCESS_SUCCESS )
	
	METHOD ResolveMailName( cLastName, cMailaddress, cFullName ) CLASS MAPISession

	LOCAL sRecip AS MAPIRecipDesc
	LOCAL nResult AS DWORD
	LOCAL oRecip AS MAPIRecip

	* first attempt with familyname and without dialog:
	nResult := MAPIResolveName( SELF:hSession , ;
						0 , ;
						String2Psz( cLastName ) , 0 , ;
						0 , ;
						@sRecip )

	IF !nResult == SUCCESS_SUCCESS
		IF !Empty(cMailaddress)
			* Use email address:
			nResult := MAPIResolveName( SELF:hSession , ;
						0 , ;
						String2Psz(AllTrim(cMailaddress) ) , ;
						MAPI_DIALOG , ;
						0 , ;
						@sRecip )
		ELSE
			* second attempt with dialog and fullname:
			(TEXTBox{,"Resolve name for email address of:",cFullName}):Show()
			nResult := MAPIResolveName( SELF:hSession , ;
						0 , ;
						String2Psz( cLastName ) , ;
						MAPI_DIALOG , ;
						0 , ;
						@sRecip )
		ENDIF
	ENDIF
	IF nResult == SUCCESS_SUCCESS
		oRecip := MAPIRecip{ sRecip }
		MAPIFreeBuffer( sRecip )
		cMailaddress:=AllTrim(SubStr(oRecip:Address,RAt(":",oRecip:Address)+1))
		RETURN oRecip
	ENDIF
	RETURN NULL_OBJECT

METHOD Resolvename( cLastName as string, persid as int, cFullName as string,cEmail as string) as MAPIRecip CLASS MAPISession

	LOCAL sRecip as MAPIRecipDesc
	LOCAL nResult as DWORD
	LOCAL oRecip as MAPIRecip
	LOCAL oMyPers as SQLSelect
	LOCAL cMailAdress as STRING
	* first attempt with familyname and without dialog:
	If !Empty(cEmail) .and. At('@',cEmail)>0 // valid email address given?
		// use that address
		sRecip := MemAlloc( _sizeof( MapiMessage ) )
		MemSet( sRecip , 0 , _sizeof( MapiMessage ) )
		sRecip.lpszAddress:=String2Psz('SMTP:'+CEmail)
		sRecip.lpszName:=String2Psz(cFullName)
		oRecip:=MAPIRecip{sRecip} 
		Return oRecip
	endif
	// Otherwise try to fetch email address:
	self:oClick:Resume() 
	nResult := MAPIResolveName( self:hSession , ;
		0 , ;
		String2Psz( AllTrim(cLastName) ) , 0 , ;
		0 , ;
		@sRecip )


	IF nResult == SUCCESS_SUCCESS
		oRecip := MAPIRecip{ sRecip } 
		cMailAdress:=AllTrim(SubStr(oRecip:Address,RAt(":",oRecip:Address)+1)) 
		if !At('@',cMailAdress)>0
			cMailAdress:=''
		endif
	ENDIF
	IF Empty(cMailAdress)
		*	Not found:
		* second attempt with dialog and fullname:
		(TextBox{,"Resolve name for email address of:",cFullName}):Show()
		nResult := MAPIResolveName( self:hSession , ;
			0 , ;
			String2Psz( AllTrim(cFullName) ) , ;
			MAPI_DIALOG , ;
			0 , ;
			@sRecip )
		IF nResult == SUCCESS_SUCCESS
			oRecip := MAPIRecip{ sRecip } 
			cMailAdress:=AllTrim(SubStr(oRecip:Address,RAt(":",oRecip:Address)+1)) 
			if !At('@',cMailAdress)>0
				cMailAdress:=''
			endif
		ENDIF

	ENDIF
	self:oClick:Suspend()
	IF Empty(cMailAdress)
		IF !cEmail==cMailAdress 
			* save email address for send time:
			SQLStatement{"update person set email='"+cMailAdress+"' where persid='"+Str(persid,-1)+"'",oConn}:execute()
		endif 
		RETURN oRecip
	ENDIF
	IF nResult==MAPI_E_FAILURE
		(ErrorBox{,"Could not get correct eMail address of:"+cFullName}):Show()
	ENDIF
	RETURN null_object

METHOD ResolvenameOld( cLastName as string, persid as int, cFullName as string,cEmail as string) as MAPIRecip CLASS MAPISession

	LOCAL sRecip as MAPIRecipDesc
	LOCAL nResult as DWORD
	LOCAL oRecip as MAPIRecip
	LOCAL oMyPers as SQLSelect
	LOCAL cMailAdress as STRING
	* first attempt with familyname and without dialog:
	self:oClick:Resume()
	nResult := MAPIResolveName( self:hSession , ;
		0 , ;
		String2Psz( AllTrim(cLastName) ) , 0 , ;
		0 , ;
		@sRecip )


	IF nResult == SUCCESS_SUCCESS
		oRecip := MAPIRecip{ sRecip } 
		cMailAdress:=AllTrim(SubStr(oRecip:Address,RAt(":",oRecip:Address)+1)) 
		if !At('@',cMailAdress)>0
			cMailAdress:=''
		endif
	ENDIF
	IF !nResult == SUCCESS_SUCCESS   .or.;
			(!Empty(CEmail).and.!cEmail==cMailAdress)
		*	Not found or different from current e-mail address:
		IF !Empty(CEmail).and.Empty(cMailAdress)
			* Not found, but current e-mail address known:
			* Use email address:
			nResult := MAPIResolveName( self:hSession , ;
				0 , ;
				String2Psz(CEmail ) , ;
				MAPI_DIALOG , ;
				0 , ;
				@sRecip )
			IF !nResult == SUCCESS_SUCCESS    // thunderbird
				// use current address
				sRecip := MemAlloc( _sizeof( MapiMessage ) )
				MemSet( sRecip , 0 , _sizeof( MapiMessage ) )
				sRecip.lpszAddress:=String2Psz('SMTP:'+CEmail)
				sRecip.lpszName:=String2Psz(cFullName)
				oRecip:=MAPIRecip{sRecip} 
				Return oRecip
			endif
		ELSE
			* Current e-mail address different from found address or nothing found:
			* second attempt with dialog and fullname:
			(TextBox{,"Resolve name for email address of:",cFullName}):Show()
			IF nResult==MAPI_E_FAILURE .or.;
					(!Empty(CEmail).and.!cEmail==cMailAdress)
				* If address found without an email account, use full name:
				cLastName:=cFullName
			ENDIF
			nResult := MAPIResolveName( self:hSession , ;
				0 , ;
				String2Psz( AllTrim(cLastName) ) , ;
				MAPI_DIALOG , ;
				0 , ;
				@sRecip )
		ENDIF
	ENDIF
	self:oClick:Suspend()
	IF nResult == SUCCESS_SUCCESS
		oRecip := MAPIRecip{ sRecip }
		MAPIFreeBuffer( sRecip )
		cMailAdress:=AllTrim(SubStr(oRecip:Address,RAt(":",oRecip:Address)+1))
		if At('@',cMailAdress)>0
			IF !cEmail==cMailAdress 
				* save email address for send time:
				SQLStatement{"update person set email='"+cMailAdress+"' where persid='"+Str(persid,-1)+"'",oConn}:execute()
			endif 
		else 
			sRecip := MemAlloc( _sizeof( MapiMessage ) )
			MemSet( sRecip , 0 , _sizeof( MapiMessage ) )
			sRecip.lpszAddress:=String2Psz('SMTP:'+CEmail)
			sRecip.lpszName:=String2Psz(cFullName)
			oRecip:=MAPIRecip{sRecip} 
		ENDIF
		RETURN oRecip
	ENDIF
	IF nResult==MAPI_E_FAILURE
		(ErrorBox{,"Could not get correct eMail address of:"+cFullName}):Show()
	ENDIF
	RETURN null_object

assign Seed( cValue ) class MAPISession
	local pszValue as psz
	pszValue := String2PSZ( alltrim( cValue ) )
	MemSet( self:pszSeed , 0 , 128 )	
	MemMove( self:pszSeed , pszValue , pszLen( pszValue ) )
	
method Send() class MAPISession

	local sMessage is MAPIMessage
	local nResult as dword
	
	nResult := MAPISendMail( self:hSession , ;
					0 , ;
					@sMessage , ;
					MAPI_DIALOG , ;
					0 )

	return ( nResult == SUCCESS_SUCCESS )

METHOD SendCustom( cMsgType , oMessage ) CLASS MAPISession

	LOCAL nResult AS DWORD
	
	LOCAL sMessage AS MAPIMessage
	LOCAL pszSubject AS PSZ
	LOCAL pszNoteText AS PSZ
	LOCAL pszMessageType AS PSZ
	LOCAL DIM aRecip[ 65 ] AS MAPIRecipDesc

	LOCAL i AS DWORD

	cMsgType 		:= "IPM." + cMsgType
	sMessage		:= MemAlloc( _sizeof( MAPIMessage ) )

	MemSet( sMessage , 0 , _sizeof( MAPIMessage ) )	

	pszSubject     := StringAlloc( oMessage:Subject )
	pszNoteText    := StringAlloc( oMessage:NoteText )
	pszMessageType := StringAlloc( cMsgType )
	
	sMessage.ulReserved			:= 0
	sMessage.lpszSubject		:= pszSubject
	sMessage.lpszNoteText		:= pszNoteText
	sMessage.lpszMessageType	:= pszMessageType
	
	sMessage.lpszDateReceived	:= ""
	sMessage.lpszConversationID	:= ""
	sMessage.flFlags			:= 0

	FOR i := 1 TO ALen( oMessage:RecipList )
		aRecip[i]				:= MemAlloc( _sizeof( MAPIRecipDesc ) )
		aRecip[i].ulReserved	:= 0
		aRecip[i].ulRecipClass	:= MAPI_TO
		aRecip[i].lpszName		:= StringAlloc( oMessage:RecipList[i]:Name )
		aRecip[i].lpszAddress	:= StringAlloc( oMessage:RecipList[i]:Address )
		aRecip[i].ulEIDSize		:= 0
		aRecip[i].lpEntryID		:= NULL_PTR
	NEXT
	
	sMessage.lpRecips		:= aRecip
	sMessage.nRecipCount	:= oMessage:RecipCount
	sMessage.lpOriginator	:= NULL_PTR
	sMessage.nFileCount		:= 0
	sMessage.lpFiles		:= NULL_PTR

	nResult := MAPISendMail( ;
					SELF:hSession , ;
					0 , ;
					sMessage , ;
					0 , ;
					0 )

	MemFree( sMessage )
	MemFree( pszSubject )
	MemFree( pszNoteText )
	MemFree( pszMessageType )

	FOR i := 1 TO Len( oMessage:RecipList )
		MemFree( aRecip[i].lpszName )
		MemFree( aRecip[i].lpszAddress )		
		MemFree( aRecip[i] )
	NEXT
	RETURN ( nResult == SUCCESS_SUCCESS )

METHOD SendDocument( oFs as Filespec , oRecip1 as MAPIRecip, oRecip2 as MAPIRecip, cSubject:="", cNoteText:="" ) as LOGIC  CLASS MAPISession
//
// send message with attached file to email client
//
	LOCAL nResult as DWORD
	LOCAL sMessage as MAPIMessage
	LOCAL pszSubject as psz
	LOCAL dim aRecip[ 2 ] as MAPIRecipDesc
	LOCAL dim aFiles[ 1 ] as MAPIFileDesc
	LOCAL sRecip as MAPIRecipDesc
	LOCAL l:=1 as int
	LOCAL oMsg as MapiMsg 
	Local PtrRecip as ptr 

	IF !Empty(oRecip2) .and.! IsNil(oRecip2)
		l:=2
	ENDIF

	sMessage := MemAlloc( _sizeof( MapiMessage ) )
	MemSet( sMessage , 0 , _sizeof( MapiMessage ) )	
	
	pszSubject     := StringAlloc( cSubject )
	sMessage.ulReserved			:= 0
	sMessage.lpszSubject		:= pszSubject
	sMessage.lpszNoteText		:= cNoteText+" "
	*	sMessage.lpszMessageType	:= "IPM.NoteText"
	sMessage.lpszMessageType	:= ""
	sMessage.lpszDateReceived	:= ""
	sMessage.lpszConversationID	:= ""
	sMessage.flFlags			:= 0 

	aRecip := MemAlloc( 2 * _sizeof( MapiRecipDesc ) )
	MemSet( aRecip, 68, 2 * _sizeof( MapiRecipDesc ) )
	MemSet(  aRecip[1],0, _sizeof( MapiRecipDesc ) )
	aRecip[1].ulReserved	:= 0
	aRecip[1].ulRecipClass	:= MAPI_TO
	aRecip[1].lpszName		:= psz( _cast , StringAlloc( oRecip1:Name ) )
	aRecip[1].lpszAddress	:= psz( _cast ,StringAlloc( oRecip1:Address ) )
	aRecip[1].ulEIDSize	:= 0
	aRecip[1].lpEntryID	:= null_ptr

	IF l>1
		PtrRecip := MemByte(aRecip, 68,2*  _sizeof( MapiMessage )) 
		aRecip[2]			:= DWORD( _cast ,PtrRecip)
		MemSet(  aRecip[2],0, _sizeof( MapiRecipDesc ) )
		aRecip[2].ulReserved	:= 0
		aRecip[2].ulRecipClass	:= MAPI_CC
		aRecip[2].lpszName		:= psz( _cast , StringAlloc( oRecip2:Name ) )
		aRecip[2].lpszAddress	:= psz( _cast ,StringAlloc( oRecip2:Address ) )
		aRecip[2].ulEIDSize	:= 0
		aRecip[2].lpEntryID	:= null_ptr
	ENDIF
	sMessage.lpRecips		:=  ptr( _cast ,aRecip)
	sMessage.nRecipCount	:= l
	sMessage.lpOriginator	:= null_ptr
	if Empty(oFs)
		sMessage.nFileCount		:= 0 		
	else
		aFiles[1]				:= MemAlloc( _sizeof( MapiFileDesc ) )
		aFiles[1].ulReserved	:= 0
		aFiles[1].flFlags		:= 0
		aFiles[1].nPosition		:= 0
		aFiles[1].lpszPathName	:= StringAlloc( oFs:FullPath )
		aFiles[1].lpszFileName	:= StringAlloc( oFs:FileName+oFs:Extension)
		aFiles[1].lpFileType	:= null_ptr
		sMessage.nFileCount		:= 1
		sMessage.lpFiles		:= aFiles
	endif	

	self:oClick:Resume()
	if Empty(self:hSession)
		IF !self:Open( "" , "" )  //reinitialize hSession
			LogEvent(self,"MAPI-Services not available, Problem","logerrors")
			MessageBox( 0 , "MAPI-Services not available" , "Problem" , MB_ICONEXCLAMATION )
			RETURN false
		ENDIF		
	endif
	nResult := MAPISendMail( ;
		self:hSession , ;
		0 , ;
		sMessage , ;
		0 , ;
		0 )
	self:oClick:Suspend() 
	if !nResult == SUCCESS_SUCCESS
			LogEvent(self,"Error when emailing, Error:"+Str(nResult,-1)+'- ' +DosErrString(nResult)+"; last error:"+GetSystemMessage(GetLastError()) ,"logerrors")
			MessageBox( 0 , "Error when emailing" , "Error:"+Str(nResult,-1)+'- ' +DosErrString(nResult), MB_ICONEXCLAMATION ) 
			RETURN false
	endif
	MemFree( sMessage )
	MemFree( pszSubject )

	MemFree( aRecip[1].lpszName )	
	MemFree( aRecip[1].lpszAddress )
	MemFree( aRecip[1] )

	IF sMessage.nRecipCount	= 2
		MemFree( aRecip[2].lpszName )	
		MemFree( aRecip[2].lpszAddress )
		MemFree( aRecip[2] )
	ENDIF	
	if !Empty(oFs)
		MemFree( aFiles[1].lpszPathName )
		MemFree( aFiles[1].lpszFileName )
		MemFree( aFiles[1] )
	endif
	RETURN ( nResult == SUCCESS_SUCCESS )
DEFINE SUCCESS_SUCCESS						:= 0
