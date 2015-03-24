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
