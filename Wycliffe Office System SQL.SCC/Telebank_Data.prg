CLASS HLPMT940 INHERIT DBSERVEREXTRA
	INSTANCE cDBFPath	  := "c:\" AS STRING
	INSTANCE cName		  := "HLPMT940.dbf" AS STRING
	INSTANCE xDriver	  := "DBFCDX"		 AS USUAL
	INSTANCE lReadOnlyMode:= .F.		 AS LOGIC
	INSTANCE lSharedMode  := .F.	 AS USUAL
	INSTANCE nOrder 	  := 0	 AS INT
	//USER CODE STARTS HERE (do NOT remove this line)
ACCESS FieldDesc CLASS HLPMT940
	//
	//	Describes all fields selected by DBServer-Editor
	//
	LOCAL aRet		AS ARRAY
	LOCAL nFields	AS DWORD

	nFields := 1

	IF nFields > 0
		aRet := ArrayCreate(nFields)

		//
		//	The following code creates an array of field
		//	descriptors with these items for each
		//	selected field:
		//
		//	{ <symFieldName>, <cFieldName>, <oFieldSpec> }
		//
		//	Use following predefined constants to access
		//	each subarray:
		//
		//	DBC_SYMBOL
		//	DBC_NAME
		//	DBC_FIELDSPEC
		//
		
		aRet[1] := {#MTLINE, "MTLINE", HLPMT940_MTLINE{} }

	ELSE
		aRet := {}
	ENDIF


	RETURN aRet
ACCESS IndexList CLASS HLPMT940
	//
	//	Describes all index files created or selected
	//	by DBServer-Editor
	//
	LOCAL aRet			AS ARRAY
	LOCAL nIndexCount	AS DWORD

	nIndexCount := 0

	IF nIndexCount > 0
		aRet := ArrayCreate(nIndexCount)

		//
		//	The following code creates an array of index
		//	file descriptors with these items for each
		//	selected index file:
		//
		//	{ <cFileName>, <cPathName>, <aOrders> }
		//
		//	Use following predefined constants to access
		//	each subarray:
		//
		//	DBC_INDEXNAME
		//	DBC_INDEXPATH
		//	DBC_ORDERS
		//
		//	Array <aOrders> contains an array of
		//	order descriptors with these items for each
		//	order:
		//
		//	{ <cOrder>, <lDuplicates>, <lAscending>, <cKey>, <cFor> }
		//
		//	Use following predefined constants to access
		//	aOrder subarrays:
		//
		//	DBC_TAGNAME
		//	DBC_DUPLICATE
		//	DBC_ASCENDING
		//	DBC_KEYEXP
		//	DBC_FOREXP
		//
		  

	ELSE
		aRet := {}
	ENDIF

	RETURN aRet
METHOD Init(cDBF, lShare, lRO, xRdd) CLASS HLPMT940
	LOCAL oFS		  AS FILESPEC
	LOCAL i 		  AS DWORD
	LOCAL nFields	  AS DWORD
	LOCAL aFieldDesc  AS ARRAY
	LOCAL aIndex	  AS ARRAY
	LOCAL nIndexCount AS DWORD
	LOCAL oFSIndex	  AS FILESPEC
	LOCAL nPos		  AS DWORD
	LOCAL lTemp 	  AS LOGIC
	LOCAL oFSTemp	  AS FILESPEC


	IF IsLogic(lShare)
		SELF:lSharedMode := lShare
	ELSE
		IF !IsLogic(SELF:lSharedMode)
			SELF:lSharedMode := !SetExclusive()
		ENDIF
	ENDIF

	IF IsLogic(lRO)
		SELF:lReadOnlyMode := lRO
	ENDIF

	IF IsString(xRdd) .OR. IsArray(xRdd)
		SELF:xDriver := xRdd
	ENDIF

	SELF:PreInit()

	IF IsString(cDBF)
		//	UH 01/18/2000
		oFSTemp := FileSpec{SELF:cDBFPath + SELF:cName}
		oFS 	:= FileSpec{cDBF}

		IF SLen(oFS:Drive) = 0
			oFS:Drive := CurDrive()
		ENDIF
		IF SLen(oFS:Path) = 0
			oFS:Path  := "\" + CurDir()
		ENDIF

		IF SLen(oFS:FileName) = 0
			oFS:Filename := SELF:cName
		ENDIF

		IF oFS:FullPath == oFSTemp:Fullpath
			lTemp := .T.
		ELSE
			SELF:cDBFPath := oFS:Drive + oFS:Path
			SELF:cName	  := oFS:FileName + oFS:Extension
			oFS := FileSpec{SELF:cDBFPath + SELF:cName}
		ENDIF
	ELSE
		oFS 	 := FileSpec{SELF:cName}
		oFS:Path := SELF:cDBFPath
	ENDIF


	SUPER:Init(oFS, SELF:lSharedMode, SELF:lReadOnlyMode , SELF:xDriver )

	oHyperLabel := HyperLabel{#HLPMT940, "HLPMT940", "Help file to import Swift MT940 files for telebanking", "HLPMT940"}

	IF oHLStatus = NIL
		nFields := ALen(aFieldDesc := SELF:FieldDesc)
		FOR i:=1 UPTO nFields
			nPos := SELF:FieldPos( aFieldDesc[i][DBC_NAME] )

			SELF:SetDataField( nPos,;
				DataField{aFieldDesc[i][DBC_SYMBOL],aFieldDesc[i][DBC_FIELDSPEC]} )

			IF String2Symbol(aFieldDesc[i][DBC_NAME]) != aFieldDesc[i][DBC_SYMBOL]
				SELF:FieldInfo(DBS_ALIAS, nPos, Symbol2String(aFieldDesc[i][DBC_SYMBOL]) )
			ENDIF
		NEXT

		nIndexCount := ALen(aIndex:=SELF:IndexList)

		FOR i:=1 UPTO nIndexCount
			oFSIndex := FileSpec{ aIndex[i][DBC_INDEXNAME] }
			oFSIndex:Path := SELF:cDBFPath

			IF lTemp .AND. !Empty( aIndex[i][DBC_INDEXPATH] )
				oFSIndex:Path := aIndex[i][DBC_INDEXPATH]
			ENDIF

			IF oFSIndex:Find()
				lTemp := SELF:SetIndex( oFSIndex )
			ENDIF
		NEXT

		//	UH 01/18/2000
		//	SELF:nOrder > 0
		IF lTemp .AND. SELF:nOrder > 0
			SELF:SetOrder(SELF:nOrder)
		ENDIF

		SELF:GoTop()
	ENDIF

	SELF:PostInit()

	RETURN SELF
ACCESS  MTLINE  CLASS HLPMT940

    RETURN SELF:FieldGet(#MTLINE)
ASSIGN  MTLINE(uValue)  CLASS HLPMT940

    RETURN SELF:FieldPut(#MTLINE, uValue)
CLASS HLPMT940_MTLINE INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HLPMT940_MTLINE

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #MTLINE

    cPict       := ""
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := ""
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Mtline", "", "HLPMT940_MTLINE" },  "C", 133, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF
CLASS HulpCliop INHERIT DBSERVEREXTRA
	INSTANCE cDBFPath	  := "C:\" AS STRING
	INSTANCE cName		  := "HulpCliop.dbf" AS STRING
	INSTANCE xDriver	  := "DBFCDX"		 AS USUAL
	INSTANCE lReadOnlyMode:= .F.		 AS LOGIC
	INSTANCE lSharedMode  := .F.	 AS USUAL
	INSTANCE nOrder 	  := 0	 AS INT
	//USER CODE STARTS HERE (do NOT remove this line)
ACCESS  BEDRAG  CLASS HulpCliop

    RETURN SELF:FieldGet(#BEDRAG)
ASSIGN  BEDRAG(uValue)  CLASS HulpCliop

    RETURN SELF:FieldPut(#BEDRAG, uValue)
ACCESS FieldDesc CLASS HulpCliop
	//
	//	Describes all fields selected by DBServer-Editor
	//
	LOCAL aRet		AS ARRAY
	LOCAL nFields	AS DWORD

	nFields := 6

	IF nFields > 0
		aRet := ArrayCreate(nFields)

		//
		//	The following code creates an array of field
		//	descriptors with these items for each
		//	selected field:
		//
		//	{ <symFieldName>, <cFieldName>, <oFieldSpec> }
		//
		//	Use following predefined constants to access
		//	each subarray:
		//
		//	DBC_SYMBOL
		//	DBC_NAME
		//	DBC_FIELDSPEC
		//
		
		aRet[1] := {#INFOCODE, "INFOCODE", HulpCliop_Infocode{} }
		aRet[2] := {#VARIANTCOD, "VARIANTCOD", HulpCliop_Variantcod{} }
		aRet[3] := {#TRANSSOORT, "TRANSSOORT", HulpCliop_TransSoort{} }
		aRet[4] := {#BEDRAG, "BEDRAG", HulpCliop_Bedrag{} }
		aRet[5] := {#ReknrBet, "ReknrBet", HulpCliop_ReknrBet{} }
		aRet[6] := {#REKNRONTV, "REKNRONTV", HulpCliop_ReknrOntv{} }

	ELSE
		aRet := {}
	ENDIF


	RETURN aRet
ACCESS IndexList CLASS HulpCliop
	//
	//	Describes all index files created or selected
	//	by DBServer-Editor
	//
	LOCAL aRet			AS ARRAY
	LOCAL nIndexCount	AS DWORD

	nIndexCount := 0

	IF nIndexCount > 0
		aRet := ArrayCreate(nIndexCount)

		//
		//	The following code creates an array of index
		//	file descriptors with these items for each
		//	selected index file:
		//
		//	{ <cFileName>, <cPathName>, <aOrders> }
		//
		//	Use following predefined constants to access
		//	each subarray:
		//
		//	DBC_INDEXNAME
		//	DBC_INDEXPATH
		//	DBC_ORDERS
		//
		//	Array <aOrders> contains an array of
		//	order descriptors with these items for each
		//	order:
		//
		//	{ <cOrder>, <lDuplicates>, <lAscending>, <cKey>, <cFor> }
		//
		//	Use following predefined constants to access
		//	aOrder subarrays:
		//
		//	DBC_TAGNAME
		//	DBC_DUPLICATE
		//	DBC_ASCENDING
		//	DBC_KEYEXP
		//	DBC_FOREXP
		//
		  

	ELSE
		aRet := {}
	ENDIF

	RETURN aRet
ACCESS  INFOCODE  CLASS HulpCliop

    RETURN SELF:FieldGet(#INFOCODE)
ASSIGN  INFOCODE(uValue)  CLASS HulpCliop

    RETURN SELF:FieldPut(#INFOCODE, uValue)
METHOD Init(cDBF, lShare, lRO, xRdd) CLASS HulpCliop
	LOCAL oFS		  AS FILESPEC
	LOCAL i 		  AS DWORD
	LOCAL nFields	  AS DWORD
	LOCAL aFieldDesc  AS ARRAY
	LOCAL aIndex	  AS ARRAY
	LOCAL nIndexCount AS DWORD
	LOCAL oFSIndex	  AS FILESPEC
	LOCAL nPos		  AS DWORD
	LOCAL lTemp 	  AS LOGIC
	LOCAL oFSTemp	  AS FILESPEC


	IF IsLogic(lShare)
		SELF:lSharedMode := lShare
	ELSE
		IF !IsLogic(SELF:lSharedMode)
			SELF:lSharedMode := !SetExclusive()
		ENDIF
	ENDIF

	IF IsLogic(lRO)
		SELF:lReadOnlyMode := lRO
	ENDIF

	IF IsString(xRdd) .OR. IsArray(xRdd)
		SELF:xDriver := xRdd
	ENDIF

	SELF:PreInit()

	IF IsString(cDBF)
		//	UH 01/18/2000
		oFSTemp := FileSpec{SELF:cDBFPath + SELF:cName}
		oFS 	:= FileSpec{cDBF}

		IF SLen(oFS:Drive) = 0
			oFS:Drive := CurDrive()
		ENDIF
		IF SLen(oFS:Path) = 0
			oFS:Path  := "\" + CurDir()
		ENDIF

		IF SLen(oFS:FileName) = 0
			oFS:Filename := SELF:cName
		ENDIF

		IF oFS:FullPath == oFSTemp:Fullpath
			lTemp := .T.
		ELSE
			SELF:cDBFPath := oFS:Drive + oFS:Path
			SELF:cName	  := oFS:FileName + oFS:Extension
			oFS := FileSpec{SELF:cDBFPath + SELF:cName}
		ENDIF
	ELSE
		oFS 	 := FileSpec{SELF:cName}
		oFS:Path := SELF:cDBFPath
	ENDIF


	SUPER:Init(oFS, SELF:lSharedMode, SELF:lReadOnlyMode , SELF:xDriver )

	oHyperLabel := HyperLabel{#HulpCliop, "Help Cliep03", "Helpfile to convert Cleip03 data from aut.collection from GTZ", "HulpCliop"}

	IF oHLStatus = NIL
		nFields := ALen(aFieldDesc := SELF:FieldDesc)
		FOR i:=1 UPTO nFields
			nPos := SELF:FieldPos( aFieldDesc[i][DBC_NAME] )

			SELF:SetDataField( nPos,;
				DataField{aFieldDesc[i][DBC_SYMBOL],aFieldDesc[i][DBC_FIELDSPEC]} )

			IF String2Symbol(aFieldDesc[i][DBC_NAME]) != aFieldDesc[i][DBC_SYMBOL]
				SELF:FieldInfo(DBS_ALIAS, nPos, Symbol2String(aFieldDesc[i][DBC_SYMBOL]) )
			ENDIF
		NEXT

		nIndexCount := ALen(aIndex:=SELF:IndexList)

		FOR i:=1 UPTO nIndexCount
			oFSIndex := FileSpec{ aIndex[i][DBC_INDEXNAME] }
			oFSIndex:Path := SELF:cDBFPath

			IF lTemp .AND. !Empty( aIndex[i][DBC_INDEXPATH] )
				oFSIndex:Path := aIndex[i][DBC_INDEXPATH]
			ENDIF

			IF oFSIndex:Find()
				lTemp := SELF:SetIndex( oFSIndex )
			ENDIF
		NEXT

		//	UH 01/18/2000
		//	SELF:nOrder > 0
		IF lTemp .AND. SELF:nOrder > 0
			SELF:SetOrder(SELF:nOrder)
		ENDIF

		SELF:GoTop()
	ENDIF

	SELF:PostInit()

	RETURN SELF
ACCESS  ReknrBet  CLASS HulpCliop

    RETURN SELF:FieldGet(#ReknrBet)
ASSIGN  ReknrBet(uValue)  CLASS HulpCliop

    RETURN SELF:FieldPut(#ReknrBet, uValue)
ACCESS  REKNRONTV  CLASS HulpCliop

    RETURN SELF:FieldGet(#REKNRONTV)
ASSIGN  REKNRONTV(uValue)  CLASS HulpCliop

    RETURN SELF:FieldPut(#REKNRONTV, uValue)
ACCESS  TRANSSOORT  CLASS HulpCliop

    RETURN SELF:FieldGet(#TRANSSOORT)
ASSIGN  TRANSSOORT(uValue)  CLASS HulpCliop

    RETURN SELF:FieldPut(#TRANSSOORT, uValue)
ACCESS  VARIANTCOD  CLASS HulpCliop

    RETURN SELF:FieldGet(#VARIANTCOD)
ASSIGN  VARIANTCOD(uValue)  CLASS HulpCliop

    RETURN SELF:FieldPut(#VARIANTCOD, uValue)
CLASS HulpCliop_Bedrag INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpCliop_Bedrag

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #BEDRAG

    cPict       := ""
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := ""
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Bedrag", "", "HulpCliop_Bedrag" },  "C", 12, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF
CLASS HulpCliop_Infocode INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpCliop_Infocode

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #INFOCODE

    cPict       := ""
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := ""
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Infocode", "", "HulpCliop_Infocode" },  "C", 4, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF
CLASS HulpCliop_ReknrBet INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpCliop_ReknrBet

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #ReknrBet

    cPict       := ""
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := ""
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Reknrbet", "", "HulpCliop_ReknrBet" },  "C", 10, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF
CLASS HulpCliop_ReknrOntv INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpCliop_ReknrOntv

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #REKNRONTV

    cPict       := ""
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := ""
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Reknrontv", "", "HulpCliop_ReknrOntv" },  "C", 10, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF
CLASS HulpCliop_TransSoort INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpCliop_TransSoort

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #TRANSSOORT

    cPict       := ""
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := ""
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Transsoort", "", "HulpCliop_TransSoort" },  "C", 4, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF
CLASS HulpCliop_Variantcod INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpCliop_Variantcod

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #VARIANTCOD

    cPict       := ""
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := ""
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Variantcod", "", "HulpCliop_Variantcod" },  "C", 1, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF
CLASS Hulpgiro INHERIT DBSERVEREXTRA
	INSTANCE cDBFPath	  := "C:\" AS STRING
	INSTANCE cName		  := "HULPGIRO.DBF" AS STRING
	INSTANCE xDriver	  := "DBFCDX"		 AS USUAL
	INSTANCE lReadOnlyMode:= .F.		 AS LOGIC
	INSTANCE lSharedMode  := .F.	 AS USUAL
	INSTANCE nOrder 	  := 0	 AS INT
	//USER CODE STARTS HERE (do NOT remove this line)
ACCESS FieldDesc CLASS Hulpgiro
	//
	//	Describes all fields selected by DBServer-Editor
	//
	LOCAL aRet		AS ARRAY
	LOCAL nFields	AS DWORD

	nFields := 9

	IF nFields > 0
		aRet := ArrayCreate(nFields)

		//
		//	The following code creates an array of field
		//	descriptors with these items for each
		//	selected field:
		//
		//	{ <symFieldName>, <cFieldName>, <oFieldSpec> }
		//
		//	Use following predefined constants to access
		//	each subarray:
		//
		//	DBC_SYMBOL
		//	DBC_NAME
		//	DBC_FIELDSPEC
		//
		
		aRet[1] := { #HL_GIRONUM, "HL_GIRONUM",  Hulpgiro_HL_GIRONUM{}}
		aRet[2] := { #HL_BOEKDAT, "HL_BOEKDAT",  Hulpgiro_HL_BOEKDAT{}}
		aRet[3] := { #HL_MUTSOOR, "HL_MUTSOOR",  Hulpgiro_HL_MUTSOOR{}}
		aRet[4] := { #HL_VOLGNUM, "HL_VOLGNUM",  Hulpgiro_HL_VOLGNUM{}}
		aRet[5] := { #HL_TEGENGI, "HL_TEGENGI",  Hulpgiro_HL_TEGENGI{}}
		aRet[6] := { #HL_TEG_NAA, "HL_TEG_NAA",  Hulpgiro_HL_TEG_NAA{}}
		aRet[7] := { #HL_BUDGET, "HL_BUDGET",  Hulpgiro_HL_BUDGET{}}
		aRet[8] := { #HL_BEDRAG, "HL_BEDRAG",  Hulpgiro_HL_BEDRAG{}}
		aRet[9] := { #HL_OMS, "HL_OMS",  Hulpgiro_HL_OMS{}}

	ELSE
		aRet := {}
	ENDIF


	RETURN aRet
ACCESS  HL_BEDRAG  CLASS Hulpgiro

    RETURN SELF:FieldGet(#HL_BEDRAG)
ASSIGN  HL_BEDRAG(uValue)  CLASS Hulpgiro

    RETURN SELF:FieldPut(#HL_BEDRAG, uValue)

ACCESS  HL_BOEKDAT  CLASS Hulpgiro

    RETURN SELF:FieldGet(#HL_BOEKDAT)
ASSIGN  HL_BOEKDAT(uValue)  CLASS Hulpgiro

    RETURN SELF:FieldPut(#HL_BOEKDAT, uValue)

ACCESS  HL_BUDGET  CLASS Hulpgiro

    RETURN SELF:FieldGet(#HL_BUDGET)
ASSIGN  HL_BUDGET(uValue)  CLASS Hulpgiro

    RETURN SELF:FieldPut(#HL_BUDGET, uValue)

ACCESS  HL_GIRONUM  CLASS Hulpgiro

    RETURN SELF:FieldGet(#HL_GIRONUM)
ASSIGN  HL_GIRONUM(uValue)  CLASS Hulpgiro

    RETURN SELF:FieldPut(#HL_GIRONUM, uValue)

ACCESS  HL_MUTSOOR  CLASS Hulpgiro

    RETURN SELF:FieldGet(#HL_MUTSOOR)
ASSIGN  HL_MUTSOOR(uValue)  CLASS Hulpgiro

    RETURN SELF:FieldPut(#HL_MUTSOOR, uValue)

ACCESS  HL_OMS  CLASS Hulpgiro

    RETURN SELF:FieldGet(#HL_OMS)
ASSIGN  HL_OMS(uValue)  CLASS Hulpgiro

    RETURN SELF:FieldPut(#HL_OMS, uValue)

ACCESS  HL_TEG_NAA  CLASS Hulpgiro

    RETURN SELF:FieldGet(#HL_TEG_NAA)
ASSIGN  HL_TEG_NAA(uValue)  CLASS Hulpgiro

    RETURN SELF:FieldPut(#HL_TEG_NAA, uValue)

ACCESS  HL_TEGENGI  CLASS Hulpgiro

    RETURN SELF:FieldGet(#HL_TEGENGI)
ASSIGN  HL_TEGENGI(uValue)  CLASS Hulpgiro

    RETURN SELF:FieldPut(#HL_TEGENGI, uValue)

ACCESS  HL_VOLGNUM  CLASS Hulpgiro

    RETURN SELF:FieldGet(#HL_VOLGNUM)
ASSIGN  HL_VOLGNUM(uValue)  CLASS Hulpgiro

    RETURN SELF:FieldPut(#HL_VOLGNUM, uValue)

ACCESS IndexList CLASS Hulpgiro
	//
	//	Describes all index files created or selected
	//	by DBServer-Editor
	//
	LOCAL aRet			AS ARRAY
	LOCAL nIndexCount	AS DWORD

	nIndexCount := 0

	IF nIndexCount > 0
		aRet := ArrayCreate(nIndexCount)

		//
		//	The following code creates an array of index
		//	file descriptors with these items for each
		//	selected index file:
		//
		//	{ <cFileName>, <cPathName>, <aOrders> }
		//
		//	Use following predefined constants to access
		//	each subarray:
		//
		//	DBC_INDEXNAME
		//	DBC_INDEXPATH
		//	DBC_ORDERS
		//
		//	Array <aOrders> contains an array of
		//	order descriptors with these items for each
		//	order:
		//
		//	{ <cOrder>, <lDuplicates>, <lAscending>, <cKey>, <cFor> }
		//
		//	Use following predefined constants to access
		//	aOrder subarrays:
		//
		//	DBC_TAGNAME
		//	DBC_DUPLICATE
		//	DBC_ASCENDING
		//	DBC_KEYEXP
		//	DBC_FOREXP
		//
		  

	ELSE
		aRet := {}
	ENDIF

	RETURN aRet
METHOD Init(cDBF, lShare, lRO, xRdd) CLASS Hulpgiro
	LOCAL oFS		  AS FILESPEC
	LOCAL i 		  AS DWORD
	LOCAL nFields	  AS DWORD
	LOCAL aFieldDesc  AS ARRAY
	LOCAL aIndex	  AS ARRAY
	LOCAL nIndexCount AS DWORD
	LOCAL oFSIndex	  AS FILESPEC
	LOCAL nPos		  AS DWORD
	LOCAL lTemp 	  AS LOGIC
	LOCAL oFSTemp	  AS FILESPEC


	IF IsLogic(lShare)
		SELF:lSharedMode := lShare
	ELSE
		IF !IsLogic(SELF:lSharedMode)
			SELF:lSharedMode := !SetExclusive()
		ENDIF
	ENDIF

	IF IsLogic(lRO)
		SELF:lReadOnlyMode := lRO
	ENDIF

	IF IsString(xRdd) .OR. IsArray(xRdd)
		SELF:xDriver := xRdd
	ENDIF

	SELF:PreInit()

	IF IsString(cDBF)
		//	UH 01/18/2000
		oFSTemp := FileSpec{SELF:cDBFPath + SELF:cName}
		oFS 	:= FileSpec{cDBF}

		IF SLen(oFS:Drive) = 0
			oFS:Drive := CurDrive()
		ENDIF
		IF SLen(oFS:Path) = 0
			oFS:Path  := "\" + CurDir()
		ENDIF

		IF SLen(oFS:FileName) = 0
			oFS:Filename := SELF:cName
		ENDIF

		IF oFS:FullPath == oFSTemp:Fullpath
			lTemp := .T.
		ELSE
		   IF Left(cDBF, 2) =='\\'  // Unc path, for example \\Server\Share\FileName.DBF
				SELF:cDBFPath := oFS:Path
		   ELSE
				SELF:cDBFPath := oFS:Drive + oFS:Path    
		   ENDIF
				SELF:cName := oFS:FileName + oFS:Extension
				oFS := FileSpec{SELF:cDBFPath + SELF:cName}
		ENDIF
	ELSE
		oFS 	 := FileSpec{SELF:cName}
		oFS:Path := SELF:cDBFPath
	ENDIF


	SUPER:Init(oFS, SELF:lSharedMode, SELF:lReadOnlyMode , SELF:xDriver )

	oHyperLabel := HyperLabel{#Hulpgiro, "Hulpgiro", "Hulpgiro", "Hulpgiro"}

	IF oHLStatus = NIL
		nFields := ALen(aFieldDesc := SELF:FieldDesc)
		FOR i:=1 UPTO nFields
			nPos := SELF:FieldPos( aFieldDesc[i][DBC_NAME] )

			SELF:SetDataField( nPos,;
				DataField{aFieldDesc[i][DBC_SYMBOL],aFieldDesc[i][DBC_FIELDSPEC]} )

			IF String2Symbol(aFieldDesc[i][DBC_NAME]) != aFieldDesc[i][DBC_SYMBOL]
				SELF:FieldInfo(DBS_ALIAS, nPos, Symbol2String(aFieldDesc[i][DBC_SYMBOL]) )
			ENDIF
		NEXT

		nIndexCount := ALen(aIndex:=SELF:IndexList)

		FOR i:=1 UPTO nIndexCount
			oFSIndex := FileSpec{ aIndex[i][DBC_INDEXNAME] }
			oFSIndex:Path := SELF:cDBFPath

			IF lTemp .AND. !Empty( aIndex[i][DBC_INDEXPATH] )
				oFSIndex:Path := aIndex[i][DBC_INDEXPATH]
			ENDIF

			IF oFSIndex:Find()
				lTemp := SELF:SetIndex( oFSIndex )
			ENDIF
		NEXT

		//	UH 01/18/2000
		//	SELF:nOrder > 0
		IF lTemp .AND. SELF:nOrder > 0
			SELF:SetOrder(SELF:nOrder)
		ENDIF

		SELF:GoTop()
	ENDIF

	SELF:PostInit()

	RETURN SELF
CLASS Hulpgiro_HL_BEDRAG INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpgiro_HL_BEDRAG
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_BEDRAG, "Hl Bedrag", "", "Hulpgiro_HL_BEDRAG" },  "C", 12, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulpgiro_HL_BOEKDAT INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpgiro_HL_BOEKDAT
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_BOEKDAT, "Hl Boekdat", "", "Hulpgiro_HL_BOEKDAT" },  "C", 8, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulpgiro_HL_BUDGET INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpgiro_HL_BUDGET
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_BUDGET, "Hl Budget", "", "Hulpgiro_HL_BUDGET" },  "C", 20, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulpgiro_HL_GIRONUM INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpgiro_HL_GIRONUM
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_GIRONUM, "bankaccntnbr", "", "Hulpgiro_HL_GIRONUM" },  "C", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulpgiro_HL_GIRONUMMER INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpgiro_HL_GIRONUMMER

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL   
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL  

    symHlName   := #HL_bankaccntnbr 

    cPict       := ""
    cTypeDiag   := "" 
    cTypeHelp   := "" 
    cLenDiag    := "" 
    cLenHelp    := "" 
    cMinLenDiag := "" 
    cMinLenHelp := "" 
    cRangeDiag  := "" 
    cRangeHelp  := "" 
    cValidDiag  := "" 
    cValidHelp  := "" 
    cReqDiag    := "" 
    cReqHelp    := "" 

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL              
    lRequired   := .F.   


    SUPER:Init( HyperLabel{symHlName, "bankaccntnbr", "", "Hulpgiro_HL_GIRONUM" },  "C", 10, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




CLASS Hulpgiro_HL_MUTSOOR INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpgiro_HL_MUTSOOR
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_MUTSOOR, "Hl Mutsoor", "", "Hulpgiro_HL_MUTSOOR" },  "C", 3, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulpgiro_HL_OMS INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpgiro_HL_OMS
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_OMS, "Hl Oms", "", "Hulpgiro_HL_OMS" },  "C", 133, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulpgiro_HL_TEG_NAA INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpgiro_HL_TEG_NAA
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_TEG_NAA, "Hl Teg Naa", "", "Hulpgiro_HL_TEG_NAA" },  "C", 32, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulpgiro_HL_TEGENGI INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpgiro_HL_TEGENGI
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_TEGENGI, "Hl Tegengi", "", "Hulpgiro_HL_TEGENGI" },  "C", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulpgiro_HL_VOLGNUM INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpgiro_HL_VOLGNUM
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_VOLGNUM, "Hl Volgnum", "", "Hulpgiro_HL_VOLGNUM" },  "C", 3, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS HulpSA INHERIT DBSERVEREXTRA
	INSTANCE cDBFPath	  := "C:\" AS STRING
	INSTANCE cName		  := "HulpSA.dbf" AS STRING
	INSTANCE xDriver	  := "DBFCDX"		 AS USUAL
	INSTANCE lReadOnlyMode:= .F.		 AS LOGIC
	INSTANCE lSharedMode  := NIL	 AS USUAL
	INSTANCE nOrder 	  := 0	 AS INT
	//USER CODE STARTS HERE (do NOT remove this line)
ACCESS FieldDesc CLASS HulpSA
	//
	//	Describes all fields selected by DBServer-Editor
	//
	LOCAL aRet		AS ARRAY
	LOCAL nFields	AS DWORD

	nFields := 4

	IF nFields > 0
		aRet := ArrayCreate(nFields)

		//
		//	The following code creates an array of field
		//	descriptors with these items for each
		//	selected field:
		//
		//	{ <symFieldName>, <cFieldName>, <oFieldSpec> }
		//
		//	Use following predefined constants to access
		//	each subarray:
		//
		//	DBC_SYMBOL
		//	DBC_NAME
		//	DBC_FIELDSPEC
		//
		
		aRet[1] := { #HL_BOEKDAT, "HL_BOEKDAT",  HulpSA_HL_BOEKDAT{}}
		aRet[2] := { #HL_OMS, "HL_OMS",  HulpSA_HL_OMS{}}
		aRet[3] := { #HL_DEB, "HL_DEB",  HulpSA_HL_DEB{}}
		aRet[4] := { #HL_CRE, "HL_CRE",  HulpSA_HL_CRE{}}

	ELSE
		aRet := {}
	ENDIF


	RETURN aRet
ACCESS  HL_BOEKDAT  CLASS HulpSA

    RETURN SELF:FieldGet(#HL_BOEKDAT)
ASSIGN  HL_BOEKDAT(uValue)  CLASS HulpSA

    RETURN SELF:FieldPut(#HL_BOEKDAT, uValue)

ACCESS  HL_CRE  CLASS HulpSA

    RETURN SELF:FieldGet(#HL_CRE)
ASSIGN  HL_CRE(uValue)  CLASS HulpSA

    RETURN SELF:FieldPut(#HL_CRE, uValue)

ACCESS  HL_DEB  CLASS HulpSA

    RETURN SELF:FieldGet(#HL_DEB)
ASSIGN  HL_DEB(uValue)  CLASS HulpSA

    RETURN SELF:FieldPut(#HL_DEB, uValue)

ACCESS  HL_OMS  CLASS HulpSA

    RETURN SELF:FieldGet(#HL_OMS)
ASSIGN  HL_OMS(uValue)  CLASS HulpSA

    RETURN SELF:FieldPut(#HL_OMS, uValue)

ACCESS IndexList CLASS HulpSA
	//
	//	Describes all index files created or selected
	//	by DBServer-Editor
	//
	LOCAL aRet			AS ARRAY
	LOCAL nIndexCount	AS DWORD

	nIndexCount := 0

	IF nIndexCount > 0
		aRet := ArrayCreate(nIndexCount)

		//
		//	The following code creates an array of index
		//	file descriptors with these items for each
		//	selected index file:
		//
		//	{ <cFileName>, <cPathName>, <aOrders> }
		//
		//	Use following predefined constants to access
		//	each subarray:
		//
		//	DBC_INDEXNAME
		//	DBC_INDEXPATH
		//	DBC_ORDERS
		//
		//	Array <aOrders> contains an array of
		//	order descriptors with these items for each
		//	order:
		//
		//	{ <cOrder>, <lDuplicates>, <lAscending>, <cKey>, <cFor> }
		//
		//	Use following predefined constants to access
		//	aOrder subarrays:
		//
		//	DBC_TAGNAME
		//	DBC_DUPLICATE
		//	DBC_ASCENDING
		//	DBC_KEYEXP
		//	DBC_FOREXP
		//
		  

	ELSE
		aRet := {}
	ENDIF

	RETURN aRet
METHOD Init(cDBF, lShare, lRO, xRdd) CLASS HulpSA
	LOCAL oFS		  AS FILESPEC
	LOCAL i 		  AS DWORD
	LOCAL nFields	  AS DWORD
	LOCAL aFieldDesc  AS ARRAY
	LOCAL aIndex	  AS ARRAY
	LOCAL nIndexCount AS DWORD
	LOCAL oFSIndex	  AS FILESPEC
	LOCAL nPos		  AS DWORD
	LOCAL lTemp 	  AS LOGIC
	LOCAL oFSTemp	  AS FILESPEC


	IF IsLogic(lShare)
		SELF:lSharedMode := lShare
	ELSE
		IF !IsLogic(SELF:lSharedMode)
			SELF:lSharedMode := !SetExclusive()
		ENDIF
	ENDIF

	IF IsLogic(lRO)
		SELF:lReadOnlyMode := lRO
	ENDIF

	IF IsString(xRdd) .OR. IsArray(xRdd)
		SELF:xDriver := xRdd
	ENDIF

	SELF:PreInit()

	IF IsString(cDBF)
		//	UH 01/18/2000
		oFSTemp := FileSpec{SELF:cDBFPath + SELF:cName}
		oFS 	:= FileSpec{cDBF}

		IF SLen(oFS:Drive) = 0
			oFS:Drive := CurDrive()
		ENDIF
		IF SLen(oFS:Path) = 0
			oFS:Path  := "\" + CurDir()
		ENDIF

		IF SLen(oFS:FileName) = 0
			oFS:Filename := SELF:cName
		ENDIF

		IF oFS:FullPath == oFSTemp:Fullpath
			lTemp := .T.
		ELSE
		   IF Left(cDBF, 2) =='\\'  // Unc path, for example \\Server\Share\FileName.DBF
				SELF:cDBFPath := oFS:Path
		   ELSE
				SELF:cDBFPath := oFS:Drive + oFS:Path    
		   ENDIF
				SELF:cName := oFS:FileName + oFS:Extension
				oFS := FileSpec{SELF:cDBFPath + SELF:cName}
		ENDIF
	ELSE
		oFS 	 := FileSpec{SELF:cName}
		oFS:Path := SELF:cDBFPath
	ENDIF


	SUPER:Init(oFS, SELF:lSharedMode, SELF:lReadOnlyMode , SELF:xDriver )

	oHyperLabel := HyperLabel{#HulpSA, "HulpSA", "", "HulpSA"}

	IF oHLStatus = NIL
		nFields := ALen(aFieldDesc := SELF:FieldDesc)
		FOR i:=1 UPTO nFields
			nPos := SELF:FieldPos( aFieldDesc[i][DBC_NAME] )

			SELF:SetDataField( nPos,;
				DataField{aFieldDesc[i][DBC_SYMBOL],aFieldDesc[i][DBC_FIELDSPEC]} )

			IF String2Symbol(aFieldDesc[i][DBC_NAME]) != aFieldDesc[i][DBC_SYMBOL]
				SELF:FieldInfo(DBS_ALIAS, nPos, Symbol2String(aFieldDesc[i][DBC_SYMBOL]) )
			ENDIF
		NEXT

		nIndexCount := ALen(aIndex:=SELF:IndexList)

		FOR i:=1 UPTO nIndexCount
			oFSIndex := FileSpec{ aIndex[i][DBC_INDEXNAME] }
			oFSIndex:Path := SELF:cDBFPath

			IF lTemp .AND. !Empty( aIndex[i][DBC_INDEXPATH] )
				oFSIndex:Path := aIndex[i][DBC_INDEXPATH]
			ENDIF

			IF oFSIndex:Find()
				lTemp := SELF:SetIndex( oFSIndex )
			ENDIF
		NEXT

		//	UH 01/18/2000
		//	SELF:nOrder > 0
		IF lTemp .AND. SELF:nOrder > 0
			SELF:SetOrder(SELF:nOrder)
		ENDIF

		SELF:GoTop()
	ENDIF

	SELF:PostInit()

	RETURN SELF
CLASS HulpSA_HL_BOEKDAT INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpSA_HL_BOEKDAT
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_BOEKDAT, "Hl Boekdat", "", "HulpSA_HL_BOEKDAT" },  "C", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS HulpSA_HL_CRE INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpSA_HL_CRE
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_CRE, "Hl Cre", "", "HulpSA_HL_CRE" },  "C", 12, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS HulpSA_HL_DEB INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpSA_HL_DEB
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_DEB, "Hl Deb", "", "HulpSA_HL_DEB" },  "C", 12, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS HulpSA_HL_OMS INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpSA_HL_OMS
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HL_OMS, "Hl Oms", "", "HulpSA_HL_OMS" },  "C", 120, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
Define IDM_teletrans_NAME := "teletrans"
Define IDM_teletrans_USERID := "parous…ºw@™Ðw"
