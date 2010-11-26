CLASS _Class_Registry

    DECLARE ACCESS Working_SubKey
    DECLARE ASSIGN Working_SubKey

    DECLARE ACCESS hKey
    DECLARE ASSIGN hKey

    DECLARE ACCESS LastError
    DECLARE ASSIGN LastError

    DECLARE METHOD Build_Full_SubKey

    DECLARE METHOD GetString
    DECLARE METHOD GetInt

	DECLARE METHOD CreateKey
	DECLARE METHOD CreateSubKey
    DECLARE METHOD WriteString
    DECLARE METHOD WriteInt

    DECLARE METHOD Get_SubKey_ValueNames

    DECLARE METHOD DeleteValue
    DECLARE METHOD DeleteValueName
    DECLARE METHOD DeleteSubKey

    DECLARE METHOD Flush

    PROTECT Working_SubKey    AS STRING
    PROTECT s_Class           AS STRING
    PROTECT LastError         AS LONG
    PROTECT hKey              AS PTR

METHOD Build_Full_SubKey( s_SubKey AS STRING ) AS STRING STRICT CLASS _Class_Registry
	 // For internal use (should be PROTECTED)

    LOCAL s_Key    := AllTrim(s_SubKey) AS STRING
    LOCAL s_return AS STRING

    // Strip trailing slashes "\":
    DO WHILE Right(s_Key,1) == "\" .AND. SLen(s_Key) > 1
        s_Key := Left( s_Key, SLen(s_Key)-1 )
    ENDDO

    // Strip leading slashes "\":
    DO WHILE Left(s_Key,1) == "\" .AND. SLen(s_Key) > 1
        s_Key := SubStr( s_Key, 2 )
    ENDDO

    IF SLen(s_Key) == 1 .AND. s_Key == "\"
        s_Key := NULL_STRING
    ENDIF

    // Prepend any default "working" subkey:
    DO CASE
    CASE Empty(s_Key)
        s_Return := SELF:Working_SubKey
    CASE Empty(SELF:Working_SubKey)
        s_Return := AllTrim(s_Key)
    OTHERWISE
        s_Return := SELF:Working_SubKey + "\" + AllTrim(s_Key)
    ENDCASE

    RETURN s_Return

METHOD CreateKey( s_SubKey AS STRING ) AS LONG STRICT CLASS _Class_Registry
    // Creates a subkey
    //  -- does not create any value names or values (use WriteString())
    LOCAL li_Error        := 0 AS LONG
    LOCAL dw_KeyHandle    := 0 AS DWORD
    LOCAL dw_Disposition  := 0 AS DWORD
    LOCAL s_Full_SubKey   := NULL_STRING AS STRING

    s_Full_SubKey := SELF:Build_Full_SubKey( s_SubKey )

    li_Error := RegCreateKeyEx(                         ;
                    SELF:hKey,                          ;  //  hKey AS PTR
                    String2Psz( s_Full_SubKey ),        ;  //  lpSubKey AS PSZ
                    0,                                  ;  //  Reserved AS DWORD
                    String2Psz( SELF:s_Class ),         ;  //  lpClass AS PSZ
                    REG_OPTION_NON_VOLATILE,            ;  //  dwOptions AS DWORD
                    KEY_SET_VALUE + KEY_CREATE_SUB_KEY, ;  //  samDesired AS DWORD
                    0,                                  ;  //  lpSecurityAttributes AS _winSECURITY_ATTRIBUTES
                    @dw_KeyHandle,                      ;  //  phkResult AS PTR
                    @dw_Disposition                     ;  //  lpdwDisposition AS DWORD PTR
                    )                                      //  AS LONG PASCAL:ADVAPI32.RegCreateKeyExA#130

    SELF:LastError := li_Error

    RETURN li_Error

METHOD CreateSubKey( s_SubKey AS STRING ) AS LONG STRICT CLASS _Class_Registry
	// Same as CreateKey()
	RETURN SELF:CreateKey( s_SubKey )
METHOD DeleteSubKey( s_SubKey AS STRING ) AS LONG STRICT CLASS _Class_Registry

    LOCAL s_Full_SubKey:= NULL_STRING AS STRING

    s_Full_SubKey := SELF:Build_Full_SubKey( s_SubKey )

    SELF:LastError := RegDeleteKey(                 ;
                        SELF:hKey,                  ;  //  hKey AS PTR
                        String2Psz( s_Full_SubKey ) ;  //  lpSubKey AS PSZ
                        )                              //  AS LONG PASCAL:ADVAPI32.RegDeleteKeyA#133

    RETURN SELF:LastError

METHOD DeleteValue( s_SubKey AS STRING, s_ValueName AS STRING ) AS LONG STRICT CLASS _Class_Registry
	// Deletes both value name and its value
    LOCAL li_Error      := 0 AS LONG
    LOCAL dw_KeyHandle  := 0 AS DWORD
    LOCAL s_Full_SubKey := NULL_STRING AS STRING

    s_Full_SubKey := SELF:Build_Full_SubKey( s_SubKey )

    li_Error := RegOpenKeyEx(                           ;
                    SELF:hKey,                          ;  //  hKey AS PTR
                    String2Psz( s_Full_SubKey ),        ;  //  lpSubKey AS PSZ
                    0,                                  ;  //  ulOPtions AS DWORD
                    KEY_SET_VALUE + KEY_CREATE_SUB_KEY, ;  //  samDesired AS DWORD
                    @dw_KeyHandle                       ;  //  phkResult AS PTR
                    )                                      //  AS LONG PASCAL:ADVAPI32.RegOpenKeyExA#149

    IF ( li_Error == ERROR_SUCCESS )

       li_Error := RegDeleteValue(              ;
                    dw_KeyHandle,               ;  //  hKey AS PTR
                    String2Psz( s_ValueName )   ;  //  lpValueName AS PSZ
                    )                              //  AS LONG PASCAL:ADVAPI32.RegDeleteValueA#135

       RegCloseKey( dw_KeyHandle )

    ENDIF

    SELF:LastError := li_Error

    RETURN li_Error

METHOD DeleteValueName( s_SubKey AS STRING, s_ValueName AS STRING ) AS LONG STRICT CLASS _Class_Registry
	// Same as DeleteValue()
	//	-- deletes both value name and its value
    RETURN SELF:DeleteValue( s_SubKey, s_ValueName )

METHOD Flush() AS LONG STRICT CLASS _Class_Registry
	// Flushes changes to a key and its subkeys to disk.
	LOCAL li_Error
	li_Error := RegFlushKey(hkey)
    SELF:LastError := li_Error
	RETURN li_Error
METHOD Get_SubKey_ValueNames( s_SubKey AS STRING ) AS ARRAY STRICT CLASS _Class_Registry

    // Returns an array of all ValueNames under a subkey

    LOCAL li_Error      := 0        AS LONG
    LOCAL dw_index      := 0        AS DWORD
    LOCAL dw_lpNameLen  := 0        AS DWORD
    LOCAL dw_NameLen    := 0        AS DWORD
    LOCAL dw_KeyHandle  := 0        AS DWORD
    LOCAL psz_ValueName := NULL_PSZ AS PSZ
    LOCAL a_ValueNames  := { }      AS ARRAY
    LOCAL s_Full_SubKey := NULL_STRING AS STRING
    LOCAL stru_LastWriteTime IS _WINFILETIME

    s_Full_SubKey := SELF:Build_Full_SubKey( s_SubKey )

    li_Error := RegOpenKeyEx(                   ;
                    SELF:hKey,                  ;  //  hKey AS PTR
                    String2Psz(  s_Full_SubKey),;  //  lpSubKey AS PSZ
                    0,                          ;  //  ulOPtions AS DWORD
                    KEY_ENUMERATE_SUB_KEYS,     ;  //  samDesired AS DWORD
                    @dw_KeyHandle               ;  //  phkResult AS PTR
                    )                              //  AS LONG PASCAL:ADVAPI32.RegOpenKeyExA#149

    IF ( li_Error == ERROR_SUCCESS  )

       psz_ValueName   := StringAlloc( Space( 2048 ) )
       dw_NameLen := PszLen( psz_ValueName )

       DO WHILE ( li_Error == ERROR_SUCCESS .OR. ;
                   li_Error == ERROR_MORE_DATA )

           dw_lpNameLen := dw_NameLen
      		li_Error := RegEnumKeyEx( ;
						dw_KeyHandle,;  //  hKey AS PTR
						dw_index++,;    //  dwIndex AS DWORD
						psz_ValueName,; //  lpName AS PSZ
						@dw_lpNameLen,; //  lpcbName AS DWORD PTR
						0,;             //  lpReserved AS DWORD PTR
						NULL_PSZ,;      //  lpClasss AS PSZ
						0,;	            //  lpcbClass AS DWORD PTR
						@stru_LastWriteTime ; //	 lpftLastWriteTime AS _winFILETIME
						)               //   AS LONG PASCAL:ADVAPI32.RegEnumKeyExA#138

           IF ( li_Error == ERROR_SUCCESS .OR. ;
                 li_Error == ERROR_MORE_DATA )

               AAdd( a_ValueNames, Psz2String( psz_ValueName ) )

           ELSE
               EXIT

           ENDIF
       ENDDO

       IF ( li_Error == ERROR_NO_MORE_ITEMS )
           li_Error := ERROR_SUCCESS
       ENDIF

       RegCloseKey( dw_KeyHandle )
       MemFree( psz_ValueName )

    ENDIF

    SELF:LastError := li_Error

    RETURN a_ValueNames

METHOD GetInt( s_SubKey AS STRING, s_ValueName AS STRING ) AS LONG STRICT CLASS _Class_Registry

    // Returns value as a LONG INTEGER
    //  if value was stored as REG_DWORD (32 bit)
    //  otherwise returns ZERO

    LOCAL li_Error      := 0                AS LONG
    LOCAL dw_KeyHandle  := 0                AS DWORD
    LOCAL dw_ValueType  := 0                AS DWORD
    LOCAL dw_Value      := 0                AS DWORD
    LOCAL dw_ValueLen   := _SizeOf( DWORD ) AS DWORD
    LOCAL s_Full_SubKey := NULL_STRING AS STRING

    s_Full_SubKey := SELF:Build_Full_SubKey( s_SubKey )

    li_Error  := RegOpenKeyEx(                  ;
                    SELF:hKey,                  ;  //  hKey AS PTR
                    String2Psz( s_Full_SubKey ),;  //  lpSubKey AS PSZ
                    0,                          ;  //  ulOPtions AS DWORD
                    KEY_QUERY_VALUE,            ;  //  samDesired AS DWORD
                    @dw_KeyHandle               ;  //  phkResult AS PTR
                    )                              //  AS LONG PASCAL:ADVAPI32.RegOpenKeyExA#149

    IF ( li_Error == ERROR_SUCCESS )

       li_Error := RegQueryValueEx(             ;
                    dw_KeyHandle,               ;  //  hKey AS PTR
                    String2Psz( s_ValueName ),  ;  //  lpValueName AS PSZ
                    0,                          ;  //  lpReserved AS  DWORD PTR
                    @dw_ValueType,              ;  //  lpType AS DWORD PTR
                    @dw_Value,                  ;  //  lpData AS BYTE PTR
                    @dw_ValueLen                ;  //  lpcbData AS DWORD PTR
                    )                              //  AS LONG PASCAL:ADVAPI32.RegQueryValueExA#157

       RegCloseKey( dw_KeyHandle )

       IF ( dw_ValueType != REG_DWORD )

           dw_Value := 0

       ENDIF

    ENDIF

    SELF:LastError := li_Error

    RETURN LONG( _CAST, dw_Value )

METHOD GetString( s_SubKey AS STRING, s_ValueName AS STRING ) AS STRING STRICT CLASS _Class_Registry

    // Returns a value as a STRING
    //  -- regardless of the TYPE of the data
    //  -- maximum string length is 2047 characters
    // If s_ValueName is a NULL_STRING (or "") then the "Default"
    //  data for the subkey is returned.

    LOCAL li_Error        := 0        AS LONG
    LOCAL s_Return        := ""       AS STRING
    LOCAL psz_Value       := NULL_PSZ AS PSZ
    LOCAL dw_KeyHandle    := 0        AS DWORD
    LOCAL dw_ValueType    := 0        AS DWORD
    LOCAL dw_ValueLen     := 0        AS DWORD
    LOCAL s_Full_SubKey   := NULL_STRING AS STRING

    s_Full_SubKey := SELF:Build_Full_SubKey( s_SubKey )

    li_Error := RegOpenKeyEx(                   ;
                    SELF:hKey,                  ;  //  hKey AS PTR
                    String2Psz( s_Full_SubKey ),;  //  lpSubKey AS PSZ
                    0,                          ;  //  ulOPtions AS DWORD
                    KEY_QUERY_VALUE,            ;  //  samDesired AS DWORD
                    @dw_KeyHandle               ;  //  phkResult AS PTR
                    )                              //  AS LONG PASCAL:ADVAPI32.RegOpenKeyExA#149

    IF ( li_Error == ERROR_SUCCESS )

       psz_Value   := StringAlloc( Space( 2048 ) )
       dw_ValueLen := PszLen( psz_Value )

       li_Error := RegQueryValueEx(             ;
                    dw_KeyHandle,               ;  //  hKey AS PTR
                    String2Psz( s_ValueName ),  ;  //  lpValueName AS PSZ
                    0,                          ;  //  lpReserved AS  DWORD PTR
                    @dw_ValueType,              ;  //  lpType AS DWORD PTR
                    psz_Value,                  ;  //  lpData AS BYTE PTR
                    @dw_ValueLen                ;  //  lpcbData AS DWORD PTR
                    )                              //  AS LONG PASCAL:ADVAPI32.RegQueryValueExA#157

       RegCloseKey( dw_KeyHandle )

       IF ( dw_ValueType == REG_SZ )

           s_Return := Psz2String( psz_Value )

       ENDIF

       MemFree( psz_Value )

    ENDIF

    SELF:LastError := li_Error

    RETURN Trim( s_Return )

ACCESS hKey STRICT CLASS _Class_Registry
    RETURN SELF:hKey
ASSIGN hKey( ptr_hKey AS PTR ) AS PTR STRICT CLASS _Class_Registry

    IF ( ptr_hKey == HKEY_CLASSES_ROOT   .OR. ;
         ptr_hKey == HKEY_CURRENT_USER   .OR. ;
         ptr_hKey == HKEY_LOCAL_MACHINE  .OR. ;
         ptr_hKey == HKEY_USERS          .OR. ;
         ptr_hKey == HKEY_CURRENT_CONFIG .OR. ;
         ptr_hKey == HKEY_DYN_DATA            ;
         )

        SELF:hKey := ptr_hKey

    ELSE
        // Default standard key:
        SELF:hKey := HKEY_LOCAL_MACHINE
    ENDIF

    RETURN SELF:hKey

METHOD Init()  CLASS _Class_Registry

    SELF:Working_SubKey := NULL_STRING
    SELF:s_Class        := NULL_STRING      // Option: SELF:sClass := "CA-VO 2"
    SELF:LastError      := ERROR_SUCCESS
    SELF:hKey           := HKEY_LOCAL_MACHINE   // Default standard key

    RETURN SELF

ACCESS LastError AS LONG STRICT CLASS _Class_Registry
    RETURN SELF:LastError
ASSIGN LastError( li_Error AS LONG ) AS LONG STRICT CLASS _Class_Registry
    SELF:LastError := li_Error
    RETURN SELF:LastError

ACCESS Working_SubKey AS STRING STRICT CLASS _Class_Registry
    RETURN SELF:Working_SubKey
ASSIGN Working_SubKey( s_Set_Working_SubKey AS STRING ) AS STRING STRICT CLASS _Class_Registry

	LOCAL s_Key := AllTrim(s_Set_Working_SubKey) AS STRING
	
    // Strip trailing slashes "\":
    DO WHILE Right(s_Key,1) == "\" .AND. SLen(s_Key) > 1
        s_Key := Left( s_Key, SLen(s_Key)-1 )
    ENDDO

    // Strip leading slashes "\":
    DO WHILE Left(s_Key,1) == "\" .AND. SLen(s_Key) > 1
        s_Key := SubStr( s_Key, 2 )
    ENDDO
	
    SELF:Working_SubKey := s_Key

    RETURN SELF:Working_SubKey
METHOD WriteInt( s_SubKey AS STRING, s_ValueName AS STRING, li_Value AS LONG ) AS LONG STRICT CLASS _Class_Registry

    // Write a LONG INTEGER as a DWORD
    //	-- returns error code

    LOCAL li_Error        := 0 AS LONG
    LOCAL dw_KeyHandle    := 0 AS DWORD
    LOCAL dw_Disposition  := 0 AS DWORD
    LOCAL dw_Value        := 0 AS DWORD
    LOCAL s_Full_SubKey   := NULL_STRING AS STRING

    s_Full_SubKey := SELF:Build_Full_SubKey( s_SubKey )

    dw_Value  := DWORD( _CAST, li_Value )

    li_Error := RegCreateKeyEx(                         ;
                    SELF:hKey,                          ;  //  hKey AS PTR
                    String2Psz( s_Full_SubKey ),        ;  //  lpSubKey AS PSZ
                    0,                                  ;  //  Reserved AS DWORD
                    String2Psz( SELF:s_Class ),         ;  //  lpClass AS PSZ
                    REG_OPTION_NON_VOLATILE,            ;  //  dwOptions AS DWORD
                    KEY_SET_VALUE + KEY_CREATE_SUB_KEY, ;  //  samDesired AS DWORD
                    0,                                  ;  //  lpSecurityAttributes AS _winSECURITY_ATTRIBUTES
                    @dw_KeyHandle,                      ;  //  phkResult AS PTR
                    @dw_Disposition                     ;  //  lpdwDisposition AS DWORD PTR
                    )                                      //  AS LONG PASCAL:ADVAPI32.RegCreateKeyExA#130

    IF ( li_Error == ERROR_SUCCESS )

       li_Error := RegSetValueEx(               ;
                    dw_KeyHandle,               ;  //  hKey AS PTR
                    String2Psz( s_ValueName ),  ;  //  lpValueName AS PSZ
                    0,                          ;  //  ReservED AS DWORD
                    REG_DWORD,                  ;  //  dwType AS DWORD
                    @dw_Value,                  ;  //  lpData AS BYTE PTR
                    _SizeOf( DWORD )            ;  //  cdData AS DWORD
                    )                              //  AS LONG PASCAL:ADVAPI32.RegSetValueExA#169

       RegCloseKey( dw_KeyHandle )

    ENDIF

    SELF:LastError := li_Error

    RETURN li_Error

METHOD WriteString( s_SubKey AS STRING, s_ValueName AS STRING, s_String AS STRING ) AS LONG STRICT CLASS _Class_Registry

    // Writes a STRING
    //  -- maximum of 2046 characters (even number for UNICODE's)
    //  -- returns error code

    LOCAL li_Error        := 0 AS LONG
    LOCAL dw_KeyHandle    := 0 AS DWORD
    LOCAL dw_Disposition  := 0 AS DWORD
    LOCAL s_Full_SubKey   := NULL_STRING AS STRING

    s_Full_SubKey := SELF:Build_Full_SubKey( s_SubKey )

    IF ( SLen( s_String ) > 2046 )

       s_String := Left( s_String, 2046 )

    ENDIF

    li_Error := RegCreateKeyEx(                         ;
                    SELF:hKey,                          ;  //  hKey AS PTR
                    String2Psz( s_Full_SubKey ),        ;  //  lpSubKey AS PSZ
                    0,                                  ;  //  Reserved AS DWORD
                    String2Psz( SELF:s_Class ),         ;  //  lpClass AS PSZ
                    REG_OPTION_NON_VOLATILE,            ;  //  dwOptions AS DWORD
                    KEY_SET_VALUE + KEY_CREATE_SUB_KEY, ;  //  samDesired AS DWORD
                    0,                                  ;  //  lpSecurityAttributes AS _winSECURITY_ATTRIBUTES
                    @dw_KeyHandle,                      ;  //  phkResult AS PTR
                    @dw_Disposition                     ;  //  lpdwDisposition AS DWORD PTR
                    )                                      //  AS LONG PASCAL:ADVAPI32.RegCreateKeyExA#130

    IF ( li_Error == ERROR_SUCCESS )

       li_Error := RegSetValueEx(               ;
                    dw_KeyHandle,               ;  //  hKey AS PTR
                    String2Psz( s_ValueName ),  ;  //  lpValueName AS PSZ
                    0,                          ;  //  ReservED AS DWORD
                    REG_SZ,                     ;  //  dwType AS DWORD
                    String2Psz( s_String ),     ;  //  lpData AS BYTE PTR
                    SLen( s_String ) + 1        ;  //  cdData AS DWORD
                    )                              //  AS LONG PASCAL:ADVAPI32.RegSetValueExA#169

       RegCloseKey( dw_KeyHandle )

    ENDIF

    SELF:LastError := li_Error

    RETURN li_Error

DEFINE CAVO_REG_ROOT := "SOFTWARE\ComputerAssociates\CA-Visual Objects Applications\"
CLASS Class_HKCR INHERIT _Class_Registry
	// Subclass for HKEY_CLASSES_ROOT
	DECLARE ASSIGN hKey
ASSIGN hKey() AS PTR STRICT CLASS Class_HKCR
	// Don't permit changes
	// Note: no parameter above to force compiler error
	// 	if assignment is attempted.
	RETURN SELF:hKey	
	
METHOD Init CLASS Class_HKCR
	SUPER:Init()
	SUPER:hKey := HKEY_CLASSES_ROOT
CLASS Class_HKCU INHERIT _Class_Registry
	// Subclass for HKEY_CURRENT_USER
	DECLARE ASSIGN hKey
ASSIGN hKey() AS PTR STRICT CLASS Class_HKCU
	// Don't permit changes
	// Note: no parameter above to force compiler error
	// 	if assignment is attempted.
	RETURN SELF:hKey	
METHOD Init CLASS Class_HKCU
	SUPER:Init()
	SUPER:hKey := HKEY_CURRENT_USER
CLASS Class_HKLM INHERIT _Class_Registry
	// Subclass for KHEY_LOCAL MACHING
	DECLARE ASSIGN hKey
ASSIGN hKey() AS PTR STRICT CLASS Class_HKLM
	// Don't permit changes.
	// Note: no parameter above to force compiler error
	// 	if assignment is attempted.
	RETURN SELF:hKey	
METHOD Init CLASS Class_HKLM
	SUPER:Init()
	SUPER:hKey := HKEY_LOCAL_MACHINE
