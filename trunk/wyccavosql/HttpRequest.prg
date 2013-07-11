METHOD GetDocumentByGetOrPost(cIP, cDocument, cData, cHeader, cMethod, nP, nFlags) CLASS cHttp
	***************************************
	//	GET or POST - that's the question
	//	Norbert Kolb, 11/17/03, 12/02/04, 09/02/04 02/25/05
	//	UG Bodensee (A, CH, D, FL)
	***************************************
	//	First the InternetOpen function is called to initialize the
	//	remaining functions. Then the InternetConnect function is called
	//	to identify the type of service being requested. This is necessary
	//	as the same set of functions can be used to interact with a number
	//	of different servers.
	***************************************
	LOCAL nDataLen		as DWORD
	Local lResult		as Logic 
	Local cRet			as string

	Default(@cDocument,	"")
	Default(@cData,		"")
	Default(@cMethod,		"GET")
	Default(@nP,			self:nPort)
	Default(@nFlags,		0)
	
	IF _and(DWORD(nFlags), INTERNET_FLAG_SECURE) = INTERNET_FLAG_SECURE
		nP := INTERNET_DEFAULT_HTTPS_PORT
		self:nPort := nP
	ENDIF
		
	IF self:hSession == null_ptr
        lResult := self:Open(nil, self:cProxy)
    ELSE
		lResult := .T.
    ENDIF

	IF lResult
		// Identify the type of service that is being accessed
		IF self:hConnect == null_ptr .or. self:cHostAddress <> cIP
			self:cHostAddress := cIP
			self:hConnect := InternetConnect(self:hSession, ;
			    String2Psz(self:cHostAddress), ;
			    nP, ;
			    String2Psz(self:cUserName), ;
                String2Psz(self:cPassword), ;
			    INTERNET_SERVICE_HTTP, ;
			    nFlags, ;
			    0)
		ENDIF

		IF self:hConnect <> null_ptr
	      self:__SetStatusObject()
			//	Once we've identified the service, we need to indicate the
			//	page to which the data will be posted. In this example, it will
			//	be "/getorpost.php"
			self:hRequest := HttpOpenRequest(self:hConnect, ;   // hConnect
				    String2Psz(cMethod), ; 		// lpszVerb
				    String2Psz(cDocument), ;    // pszObjectName
				    String2Psz("HTTP/1.1"), ;   // pszVersion
				    null_psz, ;                 // pszReferer
				    null_psz, ;                 // pszAcceptTypes
				    nFlags, ;	     			// dwFlags
				    self:__GetStatusContext())  // dwContext
		
			IF self:hRequest <> null_ptr
	            self:__SetStatus(self:hRequest)                                          
				//	We need to add a header to notify the web server that the
				//	incoming data is form encoded and then send the request.
				IF cMethod == "POST"
					IF Empty(cHeader)
// 						cHeader := "Content-Type: application/x-www-form-urlencoded" + CRLF + HEADER_ACCEPT +  "User-Agent: Mozilla/5.0 (Windows NT 6.2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36"+CRLF
// 						cHeader := "Content-Type: application/x-www-form-urlencoded" + CRLF +  "User-Agent: Mozilla/5.0 (Windows NT 6.2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36"+CRLF+;
						cHeader := "Content-Type: application/x-www-form-urlencoded" + CRLF +  "User-Agent: Mozilla/5.0 (Windows NT 6.2; rv:17.0) Gecko/20100101 Firefox/17.0"+CRLF+;
						'Accept-Language: en-us,en;q=0.5'+CRLF +;   
						'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'+CRLF +;
						'Connection: keep-alive'+CRLF 
						'Cache-Control: no-cache'+CRLF
// 						cHeader := "Content-Type: application/x-www-form-urlencoded" + CRLF + ; 
// 						'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'+CRLF+;
// 					  'Accept-Language: en-us,en;q=0.8,nl;q=0.6'+CRLF+;
// 					  'Accept-Encoding: gzip,deflate,sdch'+CRLF+;
// 						"User-Agent: Mozilla/5.0 (Windows NT 6.2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36"+CRLF +;
// 						'Connection: keep-alive'+CRLF
					ENDIF
				ELSE
					IF Empty(cHeader)
						cHeader := HEADER_ACCEPT + "User-Agent: Mozilla/5.0 (Windows NT 6.2; rv:17.0) Gecko/20100101 Firefox/17.0"+CRLF
					ENDIF
				ENDIF

				IF HttpAddRequestHeaders(self:hRequest, ;
					   String2Psz(cHeader), ;
						SLen(cHeader), ;
						HTTP_ADDREQ_FLAG_ADD)
/*
					// Sometimes you have to set SECURITY_FLAGS
					InternetQueryOption(SELF:hRequest, INTERNET_OPTION_SECURITY_FLAGS, @nBuffer, @nBufferLen)
				    nBuffer := _or(nBuffer, SECURITY_FLAG_IGNORE_UNKNOWN_CA)
					InternetSetOption(SELF:hRequest, INTERNET_OPTION_SECURITY_FLAGS, @nBuffer, nBufferLen)
*/
					nDataLen := SLen(cData)

					IF HttpSendRequest(self:hRequest, ;
							null, ;
							0, ;
						   ptr(_cast, cData), ;
						   nDataLen)
			
						//	Finally, we need to collect our reward for all this effort
			         self:GetResponseHeader()
						cRet := self:GetResponse()

					ENDIF	// SendRequest
	
					self:CloseRequest()

				END	// AddRequestHeaders			

			ENDIF
		
	        self:__DelStatusObject()

		ENDIF

	ENDIF

	RETURN cRet	
CLASS HTTPCommmunication
	PROTECT PMISHttp AS CHttp
	PROTECT Credentials AS STRING
	PROTECT Url AS STRING
	PROTECT cIP as STRING 
	
	DECLARE METHOD PLACEFILE
	
METHOD Connect CLASS HTTPCommmunication
	LOCAL lSuccess AS LOGIC
	LOCAL cUrl:=SELF:Url
	LOCAL cDocument AS STRING
	PMISHttp := CHttp{"PMIS","2580"}
	lSuccess:=PMISHttp:ConnectRemote("172.20.4.224","Basic",'c21pdGg6c21pdGg=')
	cDocument:=PMISHttp:GetDocumentByURL(Url)
	cUrl:=PMISHttp:SetCurDir("/httpdirect/")
/*	// Open the connection
	IF PMISHttp:hSession == NULL_PTR
		PMISHttp:hSession := InternetOpen(String2Psz(PMISHttp:cAgent),;
		INTERNET_OPEN_TYPE_PRECONFIG,;
		NULL_PTR,;
		NULL_PTR,;
	    0 )       // INTERNET_FLAG_SECURE ipv 0 om https te gebruiken
	ENDIF

	IF PMISHttp:hSession <> NULL_PTR
		// Identify the type OF service that IS being accessed
		IF PMISHttp:hConnect == NULL_PTR .or. PMISHttp:cHostAddress <> cIP
			PMISHttp:cHostAddress := cIP
			PMISHttp:hConnect := InternetConnect(PMISHttp:hSession, ;
	    	String2Psz(PMISHttp:cHostAddress), ;
		    2580, ;
    		"Basic", ;
		    'c21pdGg6c21pdGg=', ;
    		INTERNET_SERVICE_HTTP, ;
	    	0, ;
	    	0)
		ENDIF
	ELSE
		lSuccess:=FALSE
	ENDIF

	//
	// Give computer some time (otherwise app could freeze)
	ApplicationExec(EXECWHILEEVENT)

	IF PMISHttp:hConnect <> NULL_PTR
		// Once we've identified the service, we need to indicate the
		// page to which the data will be posted. In this example, it will
		// be "/getorpost.php"
		PMISHttp:hRequest := HttpOpenRequest(PMISHttp:hConnect, ;
    	String2Psz("POST"), ;
	    String2Psz(cDocument), ;
    	String2Psz("HTTP/1.0"), ;
	    NULL_PSZ, ;
    	0, ;
	    INTERNET_FLAG_RELOAD, ;
    	0)
    ELSE
    	lSuccess:=FALSE
    ENDIF             */

RETURN lSuccess	
METHOD Init() CLASS HTTPCommmunication
	// setup connection with PMIS:
	Credentials:="Basic c21pdGg6c21pdGg="
//	Url:= "http://edom.sil.org:2580/httpdirect/"
	Url:= "http://karel:8080/"
	//cIP:= "172.20.4.224"
	//Url:= "http://home.wanadoo.nl/k.kuijpers/"
	//Credentials:="k.kuijpers 92HYia"
	RETURN SELF
METHOD PlaceFile(cFilename AS STRING) CLASS HTTPCommmunication
// placing a file at PMIS
LOCAL cHdr,result AS STRING, lSuccess AS LOGIC
LOCAL ptrHandle
LOCAL oFr AS Filespec
LOCAL cData as STRING
LOCAL pData AS PTR
LOCAL iDataLen AS INT

oFr:=Filespec{cFilename}
ptrHandle:=FOpen2(oFr:FullPath,FO_READ)
IF ptrHandle = F_ERROR
	(ErrorBox{,"Could not open file: "+oFr:FullPath+"; Error:"+DosErrString(FError())}):show()
	RETURN FALSE
ENDIF
iDataLen:=oFr:Size
cData:=FReadStr(ptrHandle,iDataLen)
FClose(ptrHandle)
pData:=@cData
// open request POST:
	lSuccess:=PMISHttp:OpenRequest("POST",SELF:Url)
	cHdr:="POST"+CR+LF+"HTTP/1.0"+CR+LF
	IF !Empty(Credentials)
		cHdr+=Credentials+CR+LF
	ENDIF
	cHdr+="Content-Length: "+AllTrim(Str(oFr:Size,,0))+CR+LF+"Content-Type: TEXT/XML"+CR+LF
/*	lResult := HttpAddRequestHeaders(PMISHttp:hRequest, ;
	cHdr, SLen(cHdr), HTTP_ADDREQ_FLAG_ADD)

	//
	// Give computer some time (otherwise app could freeze)
	ApplicationExec(EXECWHILEEVENT)
	lResult := HttpSendRequest(PMISHttp:hRequest, ;
    NULL_PSZ, ;
	0, ;
    PTR(_CAST, pData), ;
	oFr:Size)

	IF lResult
		// Finally, we need to collect our reward for all this effort
		cRet := PMISHttp:GetResponse()
		PMISHttp:CloseRequest()
		//ToonMelding('VRT-Antwoord op Http request',cRet)
	ELSE
	   cRet := 'FORM_ERROR: Request niet juist verzonden'
	ENDIF   */

	lSuccess:=PMISHttp:SendRequest(cHdr,pData,oFr:Size)
	// Get the result from PMIS...
	result:=PMISHttp:GetResponse()
	(Infobox{,"Partner Monetary Interchange System",;
		"response:"+result}):show()

	PMISHttp:CloseRequest()
	PMISHttp:CloseRemote()
	RETURN lSuccess	
	
DEFINE INTERNET_OPTION_SECURITY_FLAGS := 31
DEFINE SECURITY_FLAG_IGNORE_UNKNOWN_CA := 256

