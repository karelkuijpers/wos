CLASS ImportTrans INHERIT DBSERVEREXTRA
	INSTANCE cDBFPath	  := "" AS STRING
	INSTANCE cName		  := "IMPRTTRS.DBF" AS STRING
	INSTANCE xDriver	  := "DBFCDX"		 AS USUAL
	INSTANCE lReadOnlyMode:= .F.		 AS LOGIC
	INSTANCE lSharedMode  := NIL	 AS USUAL
	INSTANCE nOrder 	  := 1	 AS INT
	//USER CODE STARTS HERE (do NOT remove this line)
ACCESS  ACCNAME  CLASS ImportTrans

    RETURN SELF:FieldGet(#ACCNAME)
ASSIGN  ACCNAME(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#ACCNAME, uValue)

ACCESS  ACCOUNTNR  CLASS ImportTrans

    RETURN SELF:FieldGet(#ACCOUNTNR)
ASSIGN  ACCOUNTNR(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#ACCOUNTNR, uValue)

ACCESS  ASSMNTCD  CLASS ImportTrans

    RETURN SELF:FieldGet(#ASSMNTCD)
ASSIGN  ASSMNTCD(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#ASSMNTCD, uValue)

ACCESS  CREDITAMNT  CLASS ImportTrans

    RETURN SELF:FieldGet(#CREDITAMNT)
ASSIGN  CREDITAMNT(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#CREDITAMNT, uValue)

ACCESS  CREFORGN  CLASS ImportTrans

    RETURN SELF:FieldGet(#CREFORGN)
ASSIGN  CREFORGN(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#CREFORGN, uValue)

ACCESS  CURRENCY  CLASS ImportTrans

    RETURN SELF:FieldGet(#CURRENCY)
ASSIGN  CURRENCY(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#CURRENCY, uValue)

ACCESS  DEBFORGN  CLASS ImportTrans

    RETURN SELF:FieldGet(#DEBFORGN)
ASSIGN  DEBFORGN(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#DEBFORGN, uValue)

ACCESS  DEBITAMNT  CLASS ImportTrans

    RETURN SELF:FieldGet(#DEBITAMNT)
ASSIGN  DEBITAMNT(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#DEBITAMNT, uValue)

ACCESS  DESCRIPTN  CLASS ImportTrans

    RETURN SELF:FieldGet(#DESCRIPTN)
ASSIGN  DESCRIPTN(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#DESCRIPTN, uValue)

ACCESS  DOCID  CLASS ImportTrans

    RETURN SELF:FieldGet(#DOCID)
ASSIGN  DOCID(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#DOCID, uValue)

ACCESS  EXTERNID  CLASS ImportTrans

    RETURN SELF:FieldGet(#EXTERNID)
ASSIGN  EXTERNID(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#EXTERNID, uValue)

ACCESS FieldDesc CLASS ImportTrans
	//
	//	Describes all fields selected by DBServer-Editor
	//
	LOCAL aRet		AS ARRAY
	LOCAL nFields	AS DWORD

	nFields := 22

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
		
		aRet[1] := { #TRANSDATE, "TRANSDATE",  ImportTrans_TRANSDATE{}}
		aRet[2] := { #DOCID, "DOCID",  ImportTrans_DOCID{}}
		aRet[3] := { #TRANSACTNR, "TRANSACTNR",  ImportTrans_TRANSACTNR{}}
		aRet[4] := { #ACCOUNTNR, "ACCOUNTNR",  Account_AccNumber{}}
		aRet[5] := { #DESCRIPTN, "DESCRIPTN",  ImportTrans_DESCRIPTN{}}
		aRet[6] := { #DEBITAMNT, "DEBITAMNT",  ImportTrans_DEBITAMNT{}}
		aRet[7] := { #CREDITAMNT, "CREDITAMNT",  ImportTrans_CREDITAMNT{}}
		aRet[8] := { #ASSMNTCD, "ASSMNTCD",  ImportTrans_ASSMNTCD{}}
		aRet[9] := { #INDVERW, "processed",  ImportTrans_IndVerw{}}
		aRet[10] := { #ORIGIN, "ORIGIN",  ImportTrans_ORIGIN{}}
		aRet[11] := { #ACCNAME, "ACCNAME",  ImportTrans_ACCNAME{}}
		aRet[12] := { #GIVER, "GIVER",  ImportTrans_GIVER{}}
		aRet[13] := { #TRANSTYP, "TRANSTYP",  ImportTrans_TRANSTYP{}}
		aRet[14] := { #FROMRPP, "FROMRPP",  ImportTrans_FROMRPP{}}
		aRet[15] := { #EXTERNID, "EXTERNID",  ImportTrans_EXTERNID{}}
		aRet[16] := { #DEBFORGN, "DEBFORGN",  ImportTrans_DEBFORGN{}}
		aRet[17] := { #CREFORGN, "CREFORGN",  ImportTrans_CREFORGN{}}
		aRet[18] := { #CURRENCY, "CURRENCY",  ImportTrans_CURRENCY{}}
		aRet[19] := { #REFERENCE, "REFERENCE",  Transaction_REFERENCE{}}
		aRet[20] := { #SEQNR, "SEQNR",  Transaction_SEQNR{}}
		aRet[21] := { #POSTSTATUS, "POSTSTATUS",  Transaction_POSTSTATUS{}}
		aRet[22] := { #PPDEST, "PPDEST",  PPCodes_PPCode{}}

	ELSE
		aRet := {}
	ENDIF


	RETURN aRet
ACCESS  FROMRPP  CLASS ImportTrans

    RETURN SELF:FieldGet(#FROMRPP)
ASSIGN  FROMRPP(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#FROMRPP, uValue)

ACCESS  GIVER  CLASS ImportTrans

    RETURN SELF:FieldGet(#GIVER)
ASSIGN  GIVER(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#GIVER, uValue)

ACCESS IndexList CLASS ImportTrans
	//
	//	Describes all index files created or selected
	//	by DBServer-Editor
	//
	LOCAL aRet			AS ARRAY
	LOCAL nIndexCount	AS DWORD

	nIndexCount := 1

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
		
		aRet[1] := { "IMPID.CDX", "",; 
 					{{ "ImpId", .T., .T., [Origin+TRANSACTNR+Dtos(Transdate)+SEQNR], [] } } }

	ELSE
		aRet := {}
	ENDIF

	RETURN aRet
METHOD Init(cDBF, lShare, lRO, xRdd) CLASS ImportTrans
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

	oHyperLabel := HyperLabel{#ImportTrans, "ImportTrans", "Imported batches of charge transactions", "ImportTrans"}

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
ACCESS  ORIGIN  CLASS ImportTrans

    RETURN SELF:FieldGet(#ORIGIN)
ASSIGN  ORIGIN(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#ORIGIN, uValue)

ACCESS  POSTSTATUS  CLASS ImportTrans

    RETURN SELF:FieldGet(#POSTSTATUS)
ASSIGN  POSTSTATUS(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#POSTSTATUS, uValue)

ACCESS  PPDEST  CLASS ImportTrans

    RETURN SELF:FieldGet(#PPDEST)
ASSIGN  PPDEST(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#PPDEST, uValue)

ACCESS  processed  CLASS ImportTrans

    RETURN SELF:FieldGet(#INDVERW)
ASSIGN  processed(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#INDVERW, uValue)

ACCESS  REFERENCE  CLASS ImportTrans

    RETURN SELF:FieldGet(#REFERENCE)
ASSIGN  REFERENCE(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#REFERENCE, uValue)

ACCESS  SEQNR  CLASS ImportTrans

    RETURN SELF:FieldGet(#SEQNR)
ASSIGN  SEQNR(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#SEQNR, uValue)

ACCESS  TRANSACTNR  CLASS ImportTrans

    RETURN SELF:FieldGet(#TRANSACTNR)
ASSIGN  TRANSACTNR(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#TRANSACTNR, uValue)

ACCESS  TRANSDATE  CLASS ImportTrans

    RETURN SELF:FieldGet(#TRANSDATE)
ASSIGN  TRANSDATE(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#TRANSDATE, uValue)

ACCESS  TRANSTYP  CLASS ImportTrans

    RETURN SELF:FieldGet(#TRANSTYP)
ASSIGN  TRANSTYP(uValue)  CLASS ImportTrans

    RETURN SELF:FieldPut(#TRANSTYP, uValue)

CLASS ImportTrans_ACCNAME INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_ACCNAME
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#AccName, "Accname", "", "ImportTrans_AccName" },  "C", 25, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_ACCOUNTNR INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_ACCOUNTNR
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#ACCOUNTNR, "Accountnr", "", "ImportTrans_ACCOUNTNR" },  "C", 12, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_ASSMNTCD INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_ASSMNTCD
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#ASSMNTCD, "Assmntcd", "", "ImportTrans_ASSMNTCD" },  "C", 2, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_CREDITAMNT INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_CREDITAMNT
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#CREDITAMNT, "Creditamnt", "", "ImportTrans_CREDITAMNT" },  "N", 15, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_CREFORGN INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_CREFORGN
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#CREFORGN, "Creforgn", "", "ImportTrans_CREFORGN" },  "N", 15, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_CURRENCY INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_CURRENCY
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#CURRENCY, "Currency", "", "ImportTrans_CURRENCY" },  "C", 3, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_DEBFORGN INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_DEBFORGN
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#DEBFORGN, "Debforgn", "", "ImportTrans_DEBFORGN" },  "N", 15, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_DEBITAMNT INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_DEBITAMNT
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#DEBITAMNT, "Debitamnt", "", "ImportTrans_DEBITAMNT" },  "N", 15, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_DESCRIPTN INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_DESCRIPTN
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#DESCRIPTN, "Descriptn", "", "ImportTrans_DESCRIPTN" },  "M", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_Descrptn INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_Descrptn

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

    symHlName   := #DESCRIPTN

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


    SUPER:Init( HyperLabel{symHlName, "Descrptn", "", "ImportTrans_Descrptn" },  "C", 30, 0 )


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
CLASS ImportTrans_DOCID INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_DOCID
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#DOCID, "Docid", "", "ImportTrans_DOCID" },  "C", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_EXTERNID INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_EXTERNID
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#EXTERNID, "Externid", "", "ImportTrans_EXTERNID" },  "C", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_FROMRPP INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_FROMRPP
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#FROMRPP, "Fromrpp", "", "ImportTrans_FROMRPP" },  "L", 1, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_GIVER INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_GIVER
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#GIVER, "Giver", "", "ImportTrans_GIVER" },  "C", 28, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_INDVERW INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_INDVERW
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#IndVerw, "processed", "", "ImportTrans_IndVerw" },  "L", 1, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_ORIGIN INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_ORIGIN
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Origin, "Origin", "", "ImportTrans_Origin" },  "C", 11, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_TRANSACTNR INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_TRANSACTNR
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TRANSACTNR, "Transactnr", "", "" },  "C", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_TRANSDATE INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_TRANSDATE
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TransDate, "Transdate", "", "ImportTrans_TransDate" },  "D", 8, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ImportTrans_TRANSTYP INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ImportTrans_TRANSTYP
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TransTyp, "Transtyp", "", "ImportTrans_TransTyp" },  "C", 2, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
