CLASS IniFileSpec
    INSTANCE    cSubKey


METHOD Create           ()                              CLASS IniFileSpec

    // Obsolate

    RETURN SELF



METHOD DeleteEntry      ( sSection, sEntry )            CLASS IniFileSpec

    SELF:WriteString( sSection, sEntry, "" )

    RETURN SELF


METHOD DeleteSection    ( sSection )                    CLASS IniFileSpec

    // SELF:WriteString( sSection, "", "" )

    DeleteRTRegKey(SELF:GetSubKey(sSection))

    RETURN SELF



METHOD GetInt           ( sSection, sEntry )            CLASS IniFileSpec

    RETURN QueryRTRegInt( SELF:GetSubKey(sSection), sEntry )



METHOD GetSection       ( sSection )                    CLASS IniFileSpec

    RETURN QueryRTRegArray( SELF:GetSubKey(sSection) )


METHOD GetString        ( sSection, sEntry )            CLASS IniFileSpec

    LOCAL   cRet        AS STRING

    cRet := QueryRTRegString( SELF:GetSubKey(sSection), sEntry )

    RETURN Trim(cRet)



METHOD GetStringUpper   ( sSection, sEntry )            CLASS IniFileSpec

    RETURN Upper( SELF:GetString( sSection, sEntry ) )



METHOD GetSubKey        ( sSection )                    CLASS IniFileSpec

    LOCAL   cRet        AS STRING

    IF sSection == NULL_STRING
        cRet := SELF:cSubKey
    ELSE
        cRet := SELF:cSubKey + "\" + sSection
    ENDIF

    RETURN cRet


// -------------------------------------------------------------------------
//
//  WinIniFileSpec
//

METHOD INIT             ( cFullPath )                   CLASS IniFileSpec

    cSubKey := cFullPath

    RETURN SELF



METHOD WriteInt         ( sSection, sEntry, nInt )      CLASS IniFileSpec

    SetRTRegInt( SELF:GetSubKey(sSection), sEntry, nInt)

    RETURN SELF



METHOD WriteString      ( sSection, sEntry, sString )   CLASS IniFileSpec

    SetRTRegString( SELF:GetSubKey(sSection), sEntry, sString)

    RETURN SELF



FUNC    InitRegistry    ()	AS LOGIC PASCAL

    LOCAL cRoot     AS STRING
    LOCAL cVal      AS STRING
	
	cRoot := "WYC\Directories"
   	cVal := QueryRTRegString( cRoot, "RTFDirectory" )
    IF cVal == NULL_STRING
        cRoot := "WYC\Directories"
        cVal  := WorkDir()
        SetRTRegString( cRoot, "RTFDirectory", cVal )
    ENDIF

	cRoot := "WYC\Setup"
   	cVal := QueryRTRegString( cRoot, "Maximized" )
	IF cVal == NULL_STRING	
        SetRTRegInt( cRoot, "Maximized", 0 )
    ENDIF
/*   	cVal := QueryRTRegString( cRoot, "mainheight" )
	IF cVal == NULL_STRING	
        SetRTRegInt( cRoot, "mainheight", 800 )
    ENDIF
   	cVal := QueryRTRegString( cRoot, "mainwidth" )
	IF cVal == NULL_STRING	
        SetRTRegInt( cRoot, "mainwidth", 600 )
    ENDIF   */

	cRoot := "WYC\Runtime"
   	cVal := QueryRTRegString( cRoot, "DecAantal" )
	IF cVal == NULL_STRING	
        SetRTRegInt( cRoot, "DecAantal", 2 )
    ENDIF

    RETURN TRUE




// -------------------------------------------------------------------------
//
//  IniFileSpec
//

CLASS WinIniFileSpec INHERIT IniFileSpec

METHOD Init             ()                              CLASS WinIniFileSpec

    SUPER:Init("")

    RETURN SELF
