STRUCT aMapiRecip ALIGN 4
	MEMBER DIM Recip[2] IS MapiRecipDesc

class MAPIFile inherit FileSpec

method Init( sFileDesc ) class MAPIFile

	local sMAPIFile as MAPIFileDesc
	
	sMAPIFile := sFileDesc
	
	self:FullPath := Psz2String( sMAPIFile.lpszPathName )
	self:FileName := Psz2String( sMAPIFile.lpszFileName )
	
	return self

	
STRUCT MapiFileDesc ALIGN 4

	MEMBER ulReserved AS DWORD
	MEMBER flFlags AS DWORD
	MEMBER nPosition AS DWORD
	MEMBER lpszPathName AS PSZ
	MEMBER lpszFileName AS PSZ
	MEMBER lpFileType AS PTR

STRUCT MapiMessage ALIGN 4

	MEMBER ulReserved AS DWORD
	MEMBER lpszSubject AS PSZ
	MEMBER lpszNoteText AS PSZ
	MEMBER lpszMessageType AS PSZ
	MEMBER lpszDateReceived AS PSZ
	MEMBER lpszConversationID AS PSZ
	MEMBER flFlags AS DWORD
	MEMBER lpOriginator AS MapiRecipDesc PTR
	MEMBER nRecipCount AS DWORD
	MEMBER lpRecips AS MapiRecipDesc PTR
	MEMBER nFileCount AS DWORD
	MEMBER lpFiles AS MapiFileDesc PTR

class MAPIMsg

	protect cSubject as string
	protect cNoteText as string
	protect cMessageType as string
	
	protect cDateReceived as string
	protect cConversationID as string
	protect flFlags as dword

	protect pOriginator as ptr
	protect nRecipCount as dword
	protect pRecips as ptr
	protect nFileCount as dword
	protect pFiles as ptr

	export pszMsgID as psz
	
	protect aRecips as array
	protect aFiles as array

	protect oOriginator as MAPIRecip

method AddRecip( oRecip ) class MAPIMsg
	AAdd( self:aRecips , oRecip )
	nRecipCount++
	
method Axit() class MAPIMsg
	MemFree( self:pszMsgID )
	
access ConversationID() class MAPIMsg
	return self:cConversationID

access DateReceived() class MAPIMsg

	local cDate as string

	cDate := self:cDateReceived
	
	cDate := substr( cDate , 1 , 4 ) + ;
			 substr( cDate , 6 , 2 ) + ;	
			 substr( cDate , 9 , 2 )
			
	return stod( cDate )

access FileCount() class MAPIMsg
	return self:nFileCount
	
ACCESS FileList() CLASS MAPIMsg
	RETURN SELF:aFiles
	
access FullDate() class MAPIMsg
	return self:cDateReceived
	
method Init() class MAPIMsg
	self:pszMsgID := MemAlloc( 128 )
	self:aRecips := {}
	self:aFiles := {}	
	RegisterAxit( self )
	
access MsgID() class MAPIMsg
	return psz2String( self:pszMsgID )

access MsgType() class MAPIMsg
	return self:cMessageType
	
access NoteText() class MAPIMsg
	return self:cNoteText
	
assign NoteText( cText ) class MAPIMsg
	return self:cNoteText := cText

access Originator class MAPIMsg
	return self:oOriginator:Name
	
access RecipCount() class MAPIMsg
	return self:nRecipCount

ACCESS RecipList() CLASS MAPIMsg
	RETURN SELF:aRecips

METHOD Struc2Obj( sMsg ) CLASS MAPIMsg

	LOCAL sMessage AS MAPIMessage
	LOCAL sFileDesc AS MAPIFileDesc
	LOCAL sRecipDesc AS MAPIRecipDesc
	LOCAL i AS WORD

	sMessage := sMsg	

	SELF:cSubject 			:= sMessage.lpszSubject
	SELF:cNoteText			:= sMessage.lpszNoteText
	SELF:cMessageType       := sMessage.lpszMessageType
	
	SELF:cDateReceived      := sMessage.lpszDateReceived
	SELF:cConversationID    := sMessage.lpszConversationID
	SELF:flFlags            := sMessage.flFlags
	
	SELF:pOriginator        := sMessage.lpOriginator
	SELF:nRecipCount        := sMessage.nRecipCount
	SELF:pRecips            := sMessage.lpRecips
	SELF:nFileCount         := sMessage.nFileCount
	SELF:pFiles             := sMessage.lpFiles

	// Fill self:oOriginator
	IF !sMessage.lpOriginator=NULL_PTR
		SELF:oOriginator := MapiRecip{ sMessage.lpOriginator }
	ENDIF

	// Fill aFiles from sMessage.lpFiles
	IF SELF:nFileCount > 0
		SELF:aFiles := {}
		FOR i := 1 TO SELF:nFileCount
			sFileDesc := PTR( _CAST , DWORD( _CAST , sMessage.lpFiles ) + (i-1) * ( _sizeof( MAPIFileDesc ) ) )
			AAdd( aFiles , MAPIFile{ sFileDesc } )			
		NEXT
	ENDIF

	// Fill aRecips from sMessage.lpRecips
	IF SELF:nRecipCount > 0
		SELF:aRecips := {}
		FOR i := 1 TO SELF:nRecipCount
			sRecipDesc := PTR( _CAST , DWORD( _CAST , sMessage.lpRecips ) + (i-1) * ( _sizeof( MAPIRecipDesc ) ) )
			AAdd( aRecips , MAPIRecip{ sRecipDesc } )
		NEXT
	ENDIF
	
	return self
	
access Subject() class MAPIMsg
	return self:cSubject

assign Subject( cSubject ) class MAPIMsg
	return self:cSubject := cSubject

ACCESS TimeReceived() CLASS MAPIMsg
	RETURN SubStr( SELF:cDateReceived , 12 , 5 )
class MAPIRecip

	protect cName as string
	protect cAddress as string
	protect nClass as dword

access Address() class MAPIRecip
	return self:cAddress
	
assign Address( cAddress ) class MAPIRecip
	return self:cAddress := cAddress
	
method Init( sRecip ) class MAPIRecip

	local sMAPIRecip as MAPIRecipDesc

	sMAPIRecip := sRecip

	self:cName    := Psz2String( sMAPIRecip.lpszName )
	self:cAddress := Psz2String( sMAPIRecip.lpszAddress )
	self:nClass   := sMAPIRecip.ulRecipClass
	
access Name() class MAPIRecip
	return self:cName

assign Name( cName ) class MAPIRecip
	return self:cName := cName

STRUCT MapiRecipDesc ALIGN 4

	MEMBER ulReserved AS DWORD
	MEMBER ulRecipClass AS DWORD
	MEMBER lpszName AS PSZ
	MEMBER lpszAddress AS PSZ
	MEMBER ulEIDSize AS DWORD
	MEMBER lpEntryID AS PTR
	
