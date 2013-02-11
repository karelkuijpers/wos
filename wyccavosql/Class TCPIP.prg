_dll FUNC IcmpCloseHandle(hFile as ptr) as LOGIC PASCAL:ICMP.IcmpCloseHandle
_dll FUNC IcmpCreateFile() as ptr PASCAL:ICMP.IcmpCreateFile
STRUCTURE IcmpEchoReply
	MEMBER     Address			as LONG             	// Replying address
	MEMBER     Status			as LONG                	// IP status value
	MEMBER     RoundTripTime	as LONG               	// Round Trip Time in milliseconds
	MEMBER     DataSize 		as word                 // Reply data size
	MEMBER     Reserved			as word                 // Reserved
	MEMBER     Data				as ptr      			// Pointer to reply data buffer
	MEMBER     Options			is IPOptionInformation 	// Reply options
						

_dll FUNC IcmpSendEcho(hICMP as ptr,DestAddress as DWORD,					;
						RequestData as psz,RequestSize as word,			;
						pRequestOptns as IPOptionInformation,				;
						pReplyBuffer as ptr,ReplySize as DWORD,				;
						timeOut as DWORD) as word PASCAL:ICMP.IcmpSendEcho

STRUCTURE IPOptionInformation
	MEMBER     TTL					as byte      		// Time To Live (used for traceroute)
	MEMBER     TOS					as byte      		// Type Of Service (usually 0)
	MEMBER     Flags				as byte      		// IP header flags (usually 0)
	MEMBER     OptionsSize			as byte      		// Size of options data (usually 0, max 40)
	MEMBER     OptionsData			as byte ptr   			// Options data buffer
CLASS TCPIP
	PROTECT cLastError	AS STRING			// Last Error Message
	PROTECT cResponse	AS STRING			// formatted string
	PROTECT nErrCode	AS LONG				// Error Code
	PROTECT hFile		AS PTR				// Handle to the ICMP socket
	PROTECT nSize		AS LONG				// Packet size (default to 56)
	PROTECT nTimeOut	AS DWORD			// packet timeout
	PROTECT nRoundTrip	AS DWORD			// Roundtrip time in ms for packet
	PROTECT nTimeToLive	AS DWORD			// TTL
	
	DECLARE METHOD getLocalMachineName
	DECLARE METHOD getLocalIP
	DECLARE METHOD Startwinsock
	DECLARE METHOD ping
	
	DECLARE ACCESS Errorcode
	DECLARE ACCESS LastError
	DECLARE ACCESS timeout
	DECLARE ACCESS RoundTripTime
	DECLARE ACCESS Response
	DECLARE ASSIGN timeout
ACCESS ErrorCode() AS LONG PASCAL CLASS TCPIP
	RETURN SELF:nErrCode
METHOD getLocalIP(cHostName AS STRING,cIP REF STRING) AS LONG PASCAL CLASS tcpip
	LOCAL cTemp    AS STRING
	LOCAL hResult  AS LONG
	BEGIN SEQUENC
	   hResult  := S_FALSE
		cTemp    := GetIPAddress(cHostName)
		cIP	   := cTemp
		hResult  := S_OK
	END SEQUENCE
	RETURN hResult
METHOD getLocalMachineName(cName REF STRING) AS LONG PASCAL CLASS tcpip
	LOCAL cTemp    AS STRING
	LOCAL hResult  AS LONG
	BEGIN SEQUENCE
      hResult  := S_FALSE
		cTemp 	:= HostName()		
		cName	:= Trim(cTemp)
		hResult  := S_OK
	END SEQUENCE
   RETURN hResult
METHOD init CLASS TCPIP	
	try
		SELF:cLastError		:= ""		// no errormsg to start
		SELF:nErrCode		:= 0		// no error to start
	    SELF:nTimeout 		:= 2000   	// time IN miliseconds
	    SELF:nSize			:= 56		// default packet size
	    SELF:nTimeToLive	:= 64		// default TTL
	
		affirm(SELF:Startwinsock())
		SetLastError(0)
			
		SELF:hFile		:= IcmpCreateFile()
		IF  SELF:hFile == INVALID_HANDLE_VALUE	
			SELF:nErrCode		:= GetLastError()	// see if we had an error
	        SELF:cLastError 	:= "Unable to Create File Handle"
	    ENDIF
	endtrynoreturncatch
	RETURN SELF
ACCESS LastError() AS STRING PASCAL	CLASS TCPIP
	RETURN SELF:cLastError

METHOD Ping(cHost AS STRING) AS LONG PASCAL CLASS tcpip
	LOCAL nResult		AS WORD
	LOCAL nIP			AS DWORD
	LOCAL nBufferSize	AS DWORD
	LOCAL cIP			AS STRING
	LOCAL cBuffer		AS PSZ
	LOCAL pOptInfo		IS IPOptionInformation
	LOCAL pEchoReply	AS ICMPEchoReply
	LOCAL hResult     AS LONG
	LOCAL uxError		AS USUAL
	LOCAL bErrBlock 	AS CODEBLOCK
	
	bErrBlock := ErrorBlock({|oErr| _Break(oErr)})

	
	BEGIN SEQUENCE
		cIP := GetIPAddress(cHost)	
		nIP	:= inet_addr(String2Psz(cIP))
		IF nIP == 0
			SELF:cLastError	:= "Error resolving IP"
            SELF:cResponse	:= SELF:cLastError
			SELF:nErrCode	:= -9
			BREAK S_FALSE
		ENDIF
	

        pOptInfo.TTL := SELF:nTimeToLive

        // ******************************************************
        // * Reset our status each time we ping                 *
        // ******************************************************
        SELF:cLastError	:= ""
        SELF:nErrCode	:= 0
        SELF:cResponse	:= ""
		nBufferSize := _sizeof( IcmpEchoReply ) + SELF:nSize
	   	pEchoReply 		:= MemAlloc( nBufferSize )
	
		cBuffer := PSZ(PadR("Ping from Visual Objects 2.7",SELF:nSize))

		nResult := IcmpSendEcho( SELF:hFile, nIP, cBuffer, WORD(SELF:nSize),@pOptInfo,pEchoReply,nBufferSize,SELF:nTimeOut)
 	    IF GetLastError() == 0
            SELF:cResponse	:= "Reply from "
			SELF:cResponse 	+= cIP
			SELF:cresponse	+= ": time =" + NTrim(SELF:nRoundTrip) + " ms"
        ELSE
            SELF:cLastError	:= "Timeout"
            SELF:cResponse	:= SELF:cLastError
            SELF:nErrCode	:= -10
            BREAK S_FALSE
        END IF

        IF pEchoReply.Status = 0
            SELF:nRoundTrip := pEchoReply.RoundTripTime
        ELSE
            SELF:cLastError	:= "Failure ..."
            SELF:nErrCode 	:= -11
            SELF:cResponse	:= SELF:cLastError
            BREAK S_FALSE
        END IF

		// Free other buffers
		MemFree( pEchoReply )

    RECOVER USING uxError
    	IF !IsNumeric(uxError)
            SELF:nErrCode	:= GetLastError()
            IF SELF:nErrCode > 0
				SELF:cLastError := SystemErrorString(SELF:nErrCode,"test")
			ELSE
				SELF:cLastError	:= "Failure ..."
			ENDIF
            SELF:cResponse	:= SELF:cLastError
//    		Eval(uxError)
    	ENDIF
	END SEQUENCE
	ErrorBlock(bErrBlock)		
	RETURN hResult
ACCESS Response() AS STRING PASCAL CLASS tcpip
	RETURN SELF:cresponse
ACCESS RoundTripTime() AS DWORD PASCAL CLASS tcpip
	RETURN SELF:nRoundtrip
METHOD Startwinsock() AS LONG PASCAL CLASS TCPip
   LOCAL hResult  AS LONG
	BEGIN SEQUENCE
		IF WinSockInit()
			hResult := S_OK
		ELSE
			hResult	:= S_FALSE
			SELF:cLastError	:= "Error Starting winsock"
		ENDIF
	END SEQUENCE
   RETURN hResult
ACCESS timeout() AS DWORD PASCAL CLASS TCPIP
	RETURN SELF:nTimeOut	
ASSIGN timeOut(nVar) AS DWORD PASCAL CLASS TCPIP
	IF IsNumeric(nVar)
		IF nVar <= 0
			nVar	:= 5 // default for class
		ENDIF			
	ELSE
		nVar := 5	// default for class anyways
	ENDIF
	SELF:nTimeOut	:= nVar
	RETURN nVar
