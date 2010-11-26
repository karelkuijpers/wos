CLASS AccDesc INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS AccDesc
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#AccDesc, "Description", "Name of the account", "AccDesc" },  "C", 40, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulp_OMS INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulp_OMS
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#OMS, "Description", "", "" },  "M", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS HulpDeb INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpDeb

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

    symHlName   := #Deb

    cPict       := "9999999999.99"
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


    SUPER:Init( HyperLabel{symHlName, "Debit amount", "", "" },  "C", 13, 2 )


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




CLASS HulpGift_ID INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpGift_ID
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#ID, "Id", "", "HulpGift_ID" },  "C", 16, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS HulpGift_Rek INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS HulpGift_Rek
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Rek, "Rek", "", "HulpGift_Rek" },  "C", 8, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulpmut_ACCID INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpmut_ACCID
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#ACCID, "Account", "Account of transaction", "" },  "C", 11, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulpmut_FROMRPP INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpmut_FROMRPP
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#FROMRPP, "Fromrpp", "", "Hulpmut_FROMRPP" },  "L", 1, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS Hulpmut_RECNBR INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpmut_RECNBR
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#RECNBR, "Recnbr", "", "Hulpmut_RECNBR" },  "N", 9, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
METHOD Init() CLASS Hulpmut_REK
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#REK, "Account", "Account of transaction", "" },  "C", 8, 0 )
    cPict       := "!!!!!!!!"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Hulpmut_Soort INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Hulpmut_Soort
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Soort, "Soort", "", "Hulpmut_Soort" },  "C", 1, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
Define IDM_TRANSACTION_NAME := "Transaction"
Define IDM_Transaction_USERID := "parouÿÐHgwÐ€Tv"
CLASS TempGift INHERIT DBSERVEREXTRA
	INSTANCE cDBFPath	  := "" AS STRING
	INSTANCE cName		  := "c:/GiftHulpMut.dbf" AS STRING
	INSTANCE xDriver	  := "DBFCDX"		 AS USUAL
	INSTANCE lReadOnlyMode:= .F.		 AS LOGIC
	INSTANCE lSharedMode  := NIL	 AS USUAL
	INSTANCE nOrder 	  := 0	 AS INT
	//USER CODE STARTS HERE (do NOT remove this line)
// 	EXPORT oAcc, oAccT as Account
	EXPORT oLan as Language
	EXPORT lInqUpd,lFilling,lOnlyRead,lExisting as LOGIC
	EXPORT bFilter as _CodeBlock
	EXPORT oBrowse as Databrowser
	EXPORT lFromRPP as LOGIC  // for compatibility with general journal and calc forms
	EXPORT aMIRROR:={} as ARRAY  //Image of TempGift with for each row: {accid,orig,cre,gc,category,recno,accid,accnumber,creforgn,currency,multcur,dueid,acctype,description}
	//                                                                     1    2    3   4    5      6      7      8        9        10      11      12      13      14
	Export Multiple as Logic 
	
	declare method GetCategory
ACCESS  ACCDESC  CLASS TempGift

    RETURN SELF:FieldGet(#ACCDESC)
ASSIGN  ACCDESC(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#ACCDESC, uValue)

ACCESS  ACCID  CLASS TempGift

    RETURN SELF:FieldGet(#ACCID)
ASSIGN  ACCID(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#ACCID, uValue)

ACCESS  ACCNUMBER  CLASS TempGift

    RETURN SELF:FieldGet(#ACCNUMBER)
ASSIGN  ACCNUMBER(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#ACCNUMBER, uValue)

ACCESS  CRE  CLASS TempGift

    RETURN SELF:FieldGet(#CRE)
ASSIGN  CRE(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#CRE, uValue)

ACCESS  CREFORGN  CLASS TempGift

    RETURN SELF:FieldGet(#CREFORGN)
ASSIGN  CREFORGN(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#CREFORGN, uValue)

ACCESS  CURRENCY  CLASS TempGift

    RETURN SELF:FieldGet(#CURRENCY)
ASSIGN  CURRENCY(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#CURRENCY, uValue)

ACCESS  DEB  CLASS TempGift

    RETURN SELF:FieldGet(#DEB)
ASSIGN  DEB(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#DEB, uValue)

ACCESS  DEBFORGN  CLASS TempGift

    RETURN SELF:FieldGet(#DEBFORGN)
ASSIGN  DEBFORGN(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#DEBFORGN, uValue)

ACCESS  DESCRIPTN  CLASS TempGift

    RETURN SELF:FieldGet(#DESCRIPTN)
ASSIGN  DESCRIPTN(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#DESCRIPTN, uValue)

ACCESS FieldDesc CLASS TempGift
	//
	//	Describes all fields selected by DBServer-Editor
	//
	LOCAL aRet		AS ARRAY
	LOCAL nFields	AS DWORD

	nFields := 14

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
		
		aRet[1] := { #ACCID, "ACCID",  HulpGift_Rek{}}
		aRet[2] := { #DESCRIPTN, "DESCRIPTN",  Hulp_OMS{}}
		aRet[3] := { #ORIGINAL, "ORIGINAL",  Transaction_CRE{}}
		aRet[4] := { #CRE, "CRE",  Transaction_CRE{}}
		aRet[5] := { #GC, "GC",  Transaction_GC{}}
		aRet[6] := { #ACCDESC, "ACCDESC",  AccDesc{}}
		aRet[7] := { #ID, "ID",  HulpGift_ID{}}
		aRet[8] := { #ACCNUMBER, "ACCNUMBER",  Account_AccNumber{}}
		aRet[9] := { #KIND, "KIND",  Hulpmut_Soort{}}
		aRet[10] := { #CREFORGN, "CREFORGN",  Transaction_CRE{}}
		aRet[11] := { #CURRENCY, "CURRENCY",  Sysparms_SMUNT{}}
		aRet[12] := { #REFERENCE, "REFERENCE",  Transaction_REFERENCE{}}
		aRet[13] := { #DEB, "DEB",  transaction_DEB{}}
		aRet[14] := { #DEBFORGN, "DEBFORGN",  transaction_DEB{}}

	ELSE
		aRet := {}
	ENDIF


	RETURN aRet
ACCESS  GC  CLASS TempGift

    RETURN SELF:FieldGet(#GC)
ASSIGN  GC(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#GC, uValue)

ACCESS  ID  CLASS TempGift

    RETURN SELF:FieldGet(#ID)
ASSIGN  ID(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#ID, uValue)

ACCESS IndexList CLASS TempGift
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
METHOD Init(cDBF, lShare, lRO, xRdd) CLASS TempGift
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

	oHyperLabel := HyperLabel{#TempGift, "HulpGift", "Hulpdb for gifts recording", "HulpGift"}

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
ACCESS  KIND  CLASS TempGift

    RETURN SELF:FieldGet(#KIND)
ASSIGN  KIND(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#KIND, uValue)

ACCESS  ORIGINAL  CLASS TempGift

    RETURN SELF:FieldGet(#ORIGINAL)
ASSIGN  ORIGINAL(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#ORIGINAL, uValue)

METHOD PostInit() class TempGift
	//Put your PostInit additions here
	RETURN NIL
ACCESS  REFERENCE  CLASS TempGift

    RETURN SELF:FieldGet(#REFERENCE)
ASSIGN  REFERENCE(uValue)  CLASS TempGift

    RETURN SELF:FieldPut(#REFERENCE, uValue)

CLASS TempGift_ID INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS TempGift_ID
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#ID, "Id", "", "TempGift_ID" },  "C", 16, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS TempGift_Rek INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS TempGift_Rek
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#REK, "accid", "", "TempGift_Rek" },  "C", 8, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS TempTrans INHERIT DBSERVEREXTRA
	INSTANCE cDBFPath	  := "" AS STRING
	INSTANCE cName		  := "C:/HulpGenM.dbf" AS STRING
	INSTANCE xDriver	  := "DBFCDX"		 AS USUAL
	INSTANCE lReadOnlyMode:= .F.		 AS LOGIC
	INSTANCE lSharedMode  := .F.	 AS USUAL
	INSTANCE nOrder 	  := 0	 AS INT
	//USER CODE STARTS HERE (do NOT remove this line)    
	EXPORT oBrowse as Databrowser
	EXPORT lInqUpd,lFilling,lExisting,lOnlyRead,lFromRPP as LOGIC
	EXPORT aTeleAcc as ARRAY
	EXPORT oDat as date
	EXPORT aMIRROR:={} as ARRAY && mirror-array of TempTrans with values {accID,deb,cre,gc,category,recno,Trans:RecNbr,accnumber,AccDesc,balitemid,curr,multicur,debforgn,creforgn,PPDEST, description,persid,type}
   
   declare method CheckUpdates

ACCESS  ACCDESC  CLASS TempTrans

    RETURN SELF:FieldGet(#ACCDESC)
ASSIGN  ACCDESC(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#ACCDESC, uValue)

ACCESS  ACCID  CLASS TempTrans

    RETURN SELF:FieldGet(#ACCID)
ASSIGN  ACCID(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#ACCID, uValue)

ACCESS  ACCNUMBER  CLASS TempTrans

    RETURN SELF:FieldGet(#ACCNUMBER)
ASSIGN  ACCNUMBER(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#ACCNUMBER, uValue)

ACCESS  BFM  CLASS TempTrans

    RETURN SELF:FieldGet(#BFM)
ASSIGN  BFM(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#BFM, uValue)

ACCESS  CRE  CLASS TempTrans

    RETURN SELF:FieldGet(#CRE)
ASSIGN  CRE(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#CRE, uValue)

ACCESS  CREFORGN  CLASS TempTrans

    RETURN SELF:FieldGet(#CREFORGN)
ASSIGN  CREFORGN(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#CREFORGN, uValue)

ACCESS  CURRENCY  CLASS TempTrans

    RETURN SELF:FieldGet(#CURRENCY)
ASSIGN  CURRENCY(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#CURRENCY, uValue)

ACCESS  DEB  CLASS TempTrans

    RETURN SELF:FieldGet(#DEB)
ASSIGN  DEB(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#DEB, uValue)

ACCESS  DEBFORGN  CLASS TempTrans

    RETURN SELF:FieldGet(#DEBFORGN)
ASSIGN  DEBFORGN(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#DEBFORGN, uValue)

ACCESS  DESCRIPTN  CLASS TempTrans

    RETURN SELF:FieldGet(#DESCRIPTN)
ASSIGN  DESCRIPTN(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#DESCRIPTN, uValue)

ACCESS FieldDesc CLASS TempTrans
	//
	//	Describes all fields selected by DBServer-Editor
	//
	LOCAL aRet		AS ARRAY
	LOCAL nFields	AS DWORD

	nFields := 19

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
		
		aRet[1] := { #ACCID, "ACCID",  Hulpmut_ACCID{}}
		aRet[2] := { #DESCRIPTN, "DESCRIPTN",  Hulp_OMS{}}
		aRet[3] := { #DEB, "DEB",  Transaction_DEB{}}
		aRet[4] := { #CRE, "CRE",  Transaction_CRE{}}
		aRet[5] := { #GC, "GC",  Transaction_GC{}}
		aRet[6] := { #KIND, "KIND",  Hulpmut_Soort{}}
		aRet[7] := { #ACCDESC, "ACCDESC",  AccDesc{}}
		aRet[8] := { #RECNBR, "RECNBR",  Hulpmut_RECNBR{}}
		aRet[9] := { #BFM, "BFM",  Transaction_BFM{}}
		aRet[10] := { #ACCNUMBER, "ACCNUMBER",  Account_AccNumber{}}
		aRet[11] := { #FROMRPP, "FROMRPP",  Hulpmut_FROMRPP{}}
		aRet[12] := { #OPP, "OPP",  PPCodes_PPCode{}}
		aRet[13] := { #DEBFORGN, "DEBFORGN",  Transaction_DEB{}}
		aRet[14] := { #CREFORGN, "CREFORGN",  Transaction_CRE{}}
		aRet[15] := { #CURRENCY, "CURRENCY",  Sysparms_SMUNT{}}
		aRet[16] := { #REFERENCE, "REFERENCE",  Transaction_REFERENCE{}}
		aRet[17] := { #SEQNR, "SEQNR",  Transaction_SEQNR{}}
		aRet[18] := { #POSTSTATUS, "POSTSTATUS",  Transaction_POSTSTATUS{}}
		aRet[19] := { #PPDEST, "PPDEST",  PPCodes_PPCode{}}

	ELSE
		aRet := {}
	ENDIF


	RETURN aRet
ACCESS  FROMRPP  CLASS TempTrans

    RETURN SELF:FieldGet(#FROMRPP)
ASSIGN  FROMRPP(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#FROMRPP, uValue)

ACCESS  GC  CLASS TempTrans

    RETURN SELF:FieldGet(#GC)
ASSIGN  GC(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#GC, uValue)

ACCESS IndexList CLASS TempTrans
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
METHOD Init(cDBF, lShare, lRO, xRdd) CLASS TempTrans
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

	oHyperLabel := HyperLabel{#TempTrans, "TempTrans", "Temporary file for transactions", "TempTrans"}

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
ACCESS  KIND  CLASS TempTrans

    RETURN SELF:FieldGet(#KIND)
ASSIGN  KIND(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#KIND, uValue)

ACCESS  OPP  CLASS TempTrans

    RETURN SELF:FieldGet(#OPP)
ASSIGN  OPP(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#OPP, uValue)

ACCESS  POSTSTATUS  CLASS TempTrans

    RETURN SELF:FieldGet(#POSTSTATUS)
ASSIGN  POSTSTATUS(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#POSTSTATUS, uValue)

ACCESS  PPDEST  CLASS TempTrans

    RETURN SELF:FieldGet(#PPDEST)
ASSIGN  PPDEST(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#PPDEST, uValue)

ACCESS  RECNBR  CLASS TempTrans

    RETURN SELF:FieldGet(#RECNBR)
ASSIGN  RECNBR(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#RECNBR, uValue)

ACCESS  REFERENCE  CLASS TempTrans

    RETURN SELF:FieldGet(#REFERENCE)
ASSIGN  REFERENCE(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#REFERENCE, uValue)

ACCESS  SEQNR  CLASS TempTrans

    RETURN SELF:FieldGet(#SEQNR)
ASSIGN  SEQNR(uValue)  CLASS TempTrans

    RETURN SELF:FieldPut(#SEQNR, uValue)

CLASS Transaction INHERIT SQLTable
protect oAcct as Account
protect oMbr as Members
declare method AddToIncome
 
ACCESS accid CLASS Transaction
 RETURN self:FieldGet(2)
ASSIGN accid(uValue) CLASS Transaction
 RETURN self:FieldPut(2, uValue)
METHOD AddToIncome(oMBal as MBalance) CLASS Transaction
// Add current record to Gifts Income/Expense in case of assessable gift to liability member
LOCAL oAcc:=self:oAcct as Account
LOCAL oTrans:=self as Transaction
LOCAL nRec as DWORD
LOCAL cTransnr:=self:TransId as STRING
LOCAL mDat as date, mBst, mOms as STRING
LOCAL nCre as FLOAT
Local lHas as logic
LOCAL OfficeRate as FLOAT, me_rate,me_stat as STRING 
IF Empty(SINC) .and.Empty(SINCHOME)
	RETURN
ENDIF
IF !Empty(oTrans:persid).and.(oTrans:GC=="AG" .or. oTrans:GC=="OT" .or. oTrans:GC=="MG".and. oTrans:FROMRPP)
	IF oAcc==null_object .or. !oAcc:Used
		self:oAcct:=Account{,DBSHARED,DBREADONLY}
		IF !oAcct:Used
			RETURN
		ENDIF
		oAcc:=self:oAcct
		oAcc:SetOrder("accid")
	ENDIF
	IF oAcc:Seek(oTrans:accid)
		IF oAcc:Type=="PA"  //liability?
			// add to gifts income:
			if !Empty(SINCHOME) .or.!Empty(SINC)
				if self:oMbr==null_object .or. !self:oMbr:Used
					self:oMbr:=Members{,DBSHARED,DBREADONLY}
					self:oMbr:SetOrder("MBRREK")
				endif
				if self:oMbr:Seek(oTrans:accid)
					lHas:= self:oMbr:HAS
				endif
			endif
			if Empty(SINC).and.!lHas
				RETURN
			endif
			nCre:=Round(self:CRE-self:DEB,DecAantal)
			me_stat:=AllTrim(oMbr:Grade)
			if oTrans:GC=="AG" .and.!oTrans:FROMRPP .and. me_stat!="Staf"
				me_rate:=oMbr:OFFCRATE
				DO CASE
				CASE Empty(me_rate)
					OfficeRate:=sInhdKntr
				CASE me_rate="L"
					OfficeRate:=sInhdKntrL
				CASE me_rate="H"
					OfficeRate:=sInhdKntrH
				CASE me_rate="M"
					OfficeRate:=sInhdKntrM
				OTHERWISE
					OfficeRate:=sInhdKntr
				ENDCASE
				if lHas
					OfficeRate:=OfficeRate+sInhdField        // add field assessment in cas eof home assigned
				endif 
            nCre:=Round(nCre*(100-OfficeRate)/100,DecAantal)
			endif
			nRec:=oTrans:RecNo
			mDat:= self:DAT
			mBst:=self:docid
			mOms:=self:description
			oTrans:Append(FALSE)
			oTrans:TransId := cTransnr
			if lHas
				oTrans:accid:=SINCHOME
			else
				oTrans:accid:=SINC
			endif
			oTrans:DAT := mDat
			oTrans:docid := mBst
			oTrans:description := mOms
			oTrans:Cre := nCre
			oTrans:USERID := LOGON_EMP_ID
			*	Update monthbalance value of corresponding account:
			oMBal:ChgBalance(oTrans:accid,oTrans:DAT,oTrans:DEB,oTrans:CRE,oTrans:DEB,oTrans:CRE) //accid,deb,cre
			oTrans:Append(FALSE)
			oTrans:TransId := cTransnr
			oTrans:DAT := mDAT
			oTrans:docid := mBst
			oTrans:description := mOms
			if lHas
				oTrans:accid:=SEXPHOME
			else
				oTrans:accid:=SEXP
			endif
			oTrans:DEB := nCre
			oTrans:USERID := LOGON_EMP_ID
			*	Update monthbalance value of corresponding account:
			oMBal:ChgBalance(oTrans:accid,oTrans:DAT,oTrans:DEB,oTrans:CRE,oTrans:DEB,oTrans:CRE) //accid,deb,cre
			oTrans:GoTo(nRec)
		ENDIF
	ENDIF
ENDIF
RETURN
			

			
ACCESS BFM CLASS Transaction
 RETURN self:FieldGet(9)
ASSIGN BFM(uValue) CLASS Transaction
 RETURN self:FieldPut(9, uValue)
ACCESS CRE CLASS Transaction
 RETURN self:FieldGet(7)
ASSIGN CRE(uValue) CLASS Transaction
 RETURN self:FieldPut(7, uValue)
ACCESS CREFORGN CLASS Transaction
 RETURN self:FieldGet(15)
ASSIGN CREFORGN(uValue) CLASS Transaction
 RETURN self:FieldPut(15, uValue)
ACCESS CURRENCY CLASS Transaction
 RETURN self:FieldGet(16)
ASSIGN CURRENCY(uValue) CLASS Transaction
 RETURN self:FieldPut(16, uValue)
ACCESS DAT CLASS Transaction
 RETURN self:FieldGet(4)
ASSIGN DAT(uValue) CLASS Transaction
 RETURN self:FieldPut(4, uValue)
ACCESS DEB CLASS Transaction
 RETURN self:FieldGet(6)
ASSIGN DEB(uValue) CLASS Transaction
 RETURN self:FieldPut(6, uValue)
ACCESS DEBFORGN CLASS Transaction
 RETURN self:FieldGet(14)
ASSIGN DEBFORGN(uValue) CLASS Transaction
 RETURN self:FieldPut(14, uValue)
ACCESS description CLASS Transaction
 RETURN self:FieldGet(5)
ASSIGN Description(uValue) CLASS Transaction
 RETURN self:FieldPut(5, uValue)
ACCESS docid CLASS Transaction
 RETURN self:FieldGet(3)
ASSIGN DOCID(uValue) CLASS Transaction
 RETURN self:FieldPut(3, uValue)
ACCESS FROMRPP CLASS Transaction
 RETURN self:FieldGet(12)
ASSIGN FROMRPP(uValue) CLASS Transaction
 RETURN self:FieldPut(12, uValue)
ACCESS GC CLASS Transaction
 RETURN self:FieldGet(8)
ASSIGN GC(uValue) CLASS Transaction
 RETURN self:FieldPut(8, uValue)
METHOD Init( cTable, oConn ) CLASS Transaction
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`transaction`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_Transaction_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`persid`] , ;
   [`accid`] , ;
   [`docid`] , ;
   [`DAT`] , ;
   [`description`] , ;
   [`DEB`] , ;
   [`CRE`] , ;
   [`GC`] , ;
   [`BFM`] , ;
   [`TransId`] , ;
   [`USERID`] , ;
   [`FROMRPP`] , ;
   [`OPP`] , ;
   [`DEBFORGN`] , ;
   [`CREFORGN`] , ;
   [`CURRENCY`] , ;
   [`REFERENCE`] , ;
   [`SEQNR`] , ;
   [`POSTSTATUS`] , ;
   [`PPDEST`]   }, oConn )

oHyperLabel := HyperLabel{IDM_TRANSACTION_NAME,  ;
   "Transaction",  ;
   ,  ;
   "Transaction" }
IF oHLStatus = NIL
    self:Seek()
    oFS:=transaction_CLN{}
    self:SetDataField(1,DataField{[persid] ,oFS})
    oFS:=transaction_REK{}
    self:SetDataField(2,DataField{[accid] ,oFS})
    oFS:=transaction_BST{}
    self:SetDataField(3,DataField{[docid] ,oFS})
    oFS:=transaction_DAT{}
    self:SetDataField(4,DataField{[DAT] ,oFS})
    oFS:=transaction_OMS{}
    self:SetDataField(5,DataField{[description] ,oFS})
    oFS:=transaction_DEB{}
    self:SetDataField(6,DataField{[DEB] ,oFS})
    oFS:=transaction_CRE{}
    self:SetDataField(7,DataField{[CRE] ,oFS})
    oFS:=transaction_GC{}
    self:SetDataField(8,DataField{[GC] ,oFS})
    oFS:=transaction_BFM{}
    self:SetDataField(9,DataField{[BFM] ,oFS})
    oFS:=transaction_TRANSAKTNR{}
    self:SetDataField(10,DataField{[TransId] ,oFS})
    oFS:=transaction_USERID{}
    self:SetDataField(11,DataField{[USERID] ,oFS})
    oFS:=transaction_FROMRPP{}
    self:SetDataField(12,DataField{[FROMRPP] ,oFS})
    oFS:=transaction_OPP{}
    self:SetDataField(13,DataField{[OPP] ,oFS})
    oFS:=transaction_DEBFORGN{}
    self:SetDataField(14,DataField{[DEBFORGN] ,oFS})
    oFS:=transaction_CREFORGN{}
    self:SetDataField(15,DataField{[CREFORGN] ,oFS})
    oFS:=transaction_CURRENCY{}
    self:SetDataField(16,DataField{[CURRENCY] ,oFS})
    oFS:=transaction_REFERENCE{}
    self:SetDataField(17,DataField{[REFERENCE] ,oFS})
    oFS:=transaction_SEQNR{}
    self:SetDataField(18,DataField{[SEQNR] ,oFS})
    oFS:=transaction_POSTSTATUS{}
    self:SetDataField(19,DataField{[POSTSTATUS] ,oFS})
    oFS:=transaction_PPDEST{}
    self:SetDataField(20,DataField{[PPDEST] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS OPP CLASS Transaction
 RETURN self:FieldGet(13)
ASSIGN OPP(uValue) CLASS Transaction
 RETURN self:FieldPut(13, uValue)
ACCESS persid CLASS Transaction
 RETURN self:FieldGet(1)
ASSIGN persid(uValue) CLASS Transaction
 RETURN self:FieldPut(1, uValue)
ACCESS POSTSTATUS CLASS Transaction
 RETURN self:FieldGet(19)
ASSIGN POSTSTATUS(uValue) CLASS Transaction
 RETURN self:FieldPut(19, uValue)
ACCESS PPDEST CLASS Transaction
 RETURN self:FieldGet(20)
ASSIGN PPDEST(uValue) CLASS Transaction
 RETURN self:FieldPut(20, uValue)
ACCESS REFERENCE CLASS Transaction
 RETURN self:FieldGet(17)
ASSIGN REFERENCE(uValue) CLASS Transaction
 RETURN self:FieldPut(17, uValue)
ACCESS SEQNR CLASS Transaction
 RETURN self:FieldGet(18)
ASSIGN SEQNR(uValue) CLASS Transaction
 RETURN self:FieldPut(18, uValue)
ACCESS TransId CLASS Transaction
 RETURN self:FieldGet(10)
ASSIGN TransId(uValue) CLASS Transaction
 RETURN self:FieldPut(10, uValue)
ACCESS USERID CLASS Transaction
 RETURN self:FieldGet(11)
ASSIGN USERID(uValue) CLASS Transaction
 RETURN self:FieldPut(11, uValue)
CLASS Transaction_BFM INHERIT FIELDSPEC
METHOD Init() CLASS Transaction_BFM
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#BFM, "Bfm", "", "transaction_BFM" },  "C", 1, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS transaction_BST INHERIT FIELDSPEC
METHOD Init() CLASS transaction_BST
super:Init(HyperLabel{"docid","docid","","transaction_BST"},"C",10,0)

RETURN SELF
CLASS transaction_CLN INHERIT FIELDSPEC
METHOD Init() CLASS transaction_CLN
super:Init(HyperLabel{"persid","persid","","transaction_CLN"},"N",11,0)

RETURN SELF
CLASS Transaction_CRE INHERIT FIELDSPEC
METHOD Init() CLASS Transaction_CRE
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#CRE, "Cre", "", "transaction_CRE" },  "N", 19, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS transaction_CREFORGN INHERIT FIELDSPEC
METHOD Init() CLASS transaction_CREFORGN
super:Init(HyperLabel{"CREFORGN","Creforgn","","transaction_CREFORGN"},"N",19,2)

RETURN SELF
CLASS transaction_CURRENCY INHERIT FIELDSPEC
METHOD Init() CLASS transaction_CURRENCY
super:Init(HyperLabel{"CURRENCY","Currency","","transaction_CURRENCY"},"C",3,0)

RETURN SELF
CLASS transaction_DAT INHERIT FIELDSPEC
METHOD Init() CLASS transaction_DAT
super:Init(HyperLabel{"DAT","Dat","","transaction_DAT"},"D",10,0)

RETURN SELF
CLASS transaction_DEB INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS transaction_DEB
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#DEB, "Deb", "", "transaction_DEB" },  "N", 19, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS transaction_DEBFORGN INHERIT FIELDSPEC
METHOD Init() CLASS transaction_DEBFORGN
super:Init(HyperLabel{"DEBFORGN","Debforgn","","transaction_DEBFORGN"},"N",19,2)

RETURN SELF
CLASS transaction_FROMRPP INHERIT FIELDSPEC
METHOD Init() CLASS transaction_FROMRPP
super:Init(HyperLabel{"FROMRPP","Fromrpp","","transaction_FROMRPP"},"N",3,0)

RETURN SELF
CLASS Transaction_GC INHERIT FIELDSPEC
METHOD Init() CLASS Transaction_GC
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#GC, "Gc", "", "transaction_GC" },  "C", 2, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS transaction_OMS INHERIT FIELDSPEC
METHOD Init() CLASS transaction_OMS
super:Init(HyperLabel{"description","description","","transaction_OMS"},"C",511,0)

RETURN SELF
CLASS transaction_OPP INHERIT FIELDSPEC
METHOD Init() CLASS transaction_OPP
super:Init(HyperLabel{"OPP","Opp","","transaction_OPP"},"C",3,0)

RETURN SELF
CLASS Transaction_POSTSTATUS INHERIT FIELDSPEC
METHOD Init() CLASS Transaction_POSTSTATUS
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#POSTSTATUS, "Poststatus", "", "transaction_POSTSTATUS" },  "N", 3, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS transaction_PPDEST INHERIT FIELDSPEC
METHOD Init() CLASS transaction_PPDEST
super:Init(HyperLabel{"PPDEST","Ppdest","","transaction_PPDEST"},"C",3,0)

RETURN SELF
CLASS Transaction_REFERENCE INHERIT FIELDSPEC
METHOD Init() CLASS Transaction_REFERENCE
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#REFERENCE, "Reference", "", "transaction_REFERENCE" },  "C", 127, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS transaction_REK INHERIT FIELDSPEC
METHOD Init() CLASS transaction_REK
super:Init(HyperLabel{"accid","accid","","transaction_REK"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Transaction_SEQNR INHERIT FIELDSPEC
METHOD Init() CLASS Transaction_SEQNR
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#SEQNR, "Seqnr", "", "transaction_SEQNR" },  "N", 6, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS transaction_TRANSAKTNR INHERIT FIELDSPEC
METHOD Init() CLASS transaction_TRANSAKTNR
super:Init(HyperLabel{"TransId","TransId","","transaction_TRANSAKTNR"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS transaction_USERID INHERIT FIELDSPEC
METHOD Init() CLASS transaction_USERID
super:Init(HyperLabel{"USERID","Userid","","transaction_USERID"},"C",32,0)

RETURN SELF
