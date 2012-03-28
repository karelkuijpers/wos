Define IDM_PERIODICREC_NAME := "PeriodicRec"
Define IDM_PeriodicRec_USERID := "parouÿÐHXwÐ€âv"
Define IDM_STANDINGORDERLINE_NAME := "standingorderline"
Define IDM_standingorderline_USERID := "parouÿÐHXwÐ€âv"
CLASS periodicrec_CLN INHERIT FIELDSPEC
METHOD Init() CLASS periodicrec_CLN
super:Init(HyperLabel{"persid","persid","","periodicrec_CLN"},"N",11,0)

RETURN SELF
CLASS periodicrec_CURRENCY INHERIT FIELDSPEC
METHOD Init() CLASS periodicrec_CURRENCY
super:Init(HyperLabel{"CURRENCY","Currency","","periodicrec_CURRENCY"},"C",3,0)

RETURN SELF
CLASS periodicrec_EDAT INHERIT FIELDSPEC
METHOD Init() CLASS periodicrec_EDAT
super:Init(HyperLabel{"EDAT","Edat","","periodicrec_EDAT"},"D",10,0)

RETURN SELF
CLASS PeriodicRec_GC INHERIT FIELDSPEC
CLASS periodicrec_IDAT INHERIT FIELDSPEC
METHOD Init() CLASS periodicrec_IDAT
super:Init(HyperLabel{"IDAT","Idat","","periodicrec_IDAT"},"D",10,0)

RETURN SELF
CLASS PeriodicRec_OMS INHERIT FIELDSPEC
CLASS periodicrec_STORDRID INHERIT FIELDSPEC
METHOD Init() CLASS periodicrec_STORDRID
super:Init(HyperLabel{"STORDRID","Stordrid","","periodicrec_STORDRID"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS standingorder_DAY INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS standingorder_DAY
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#DAY, "Day", "", "standingorder_Day" },  "N", 11, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS standingorder_docid INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS standingorder_docid
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#DOCID, "docid", "", "standingorder_docid" },  "C", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS standingorder_lstrecording INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS standingorder_lstrecording
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#LSTRECORDING, "Last recording", "", "standingorder_lstrecording" },  "D", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS standingorder_period INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS standingorder_period
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#PERIOD, "Period", "", "" },  "N", 11, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS standingorderline_ACCOUNTID INHERIT FIELDSPEC
METHOD Init() CLASS standingorderline_ACCOUNTID
super:Init(HyperLabel{"ACCOUNTID","Accountid","","standingorderline_ACCOUNTID"},"N",11,0)

RETURN SELF
CLASS standingorderline_BANKACCT INHERIT FIELDSPEC
METHOD Init() CLASS standingorderline_BANKACCT
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#BANKACCT, "Bankacct", "", "standingorderline_BANKACCT" },  "C", 25, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS standingorderline_CRE INHERIT FIELDSPEC
METHOD Init() CLASS standingorderline_CRE
super:Init(HyperLabel{"CRE","Cre","","standingorderline_CRE"},"N",19,2)

RETURN SELF
CLASS standingorderline_CREDITOR INHERIT FIELDSPEC
METHOD Init() CLASS standingorderline_CREDITOR
super:Init(HyperLabel{"CREDITOR","Creditor","","standingorderline_CREDITOR"},"N",11,0)

RETURN SELF
CLASS standingorderline_DEB INHERIT FIELDSPEC
METHOD Init() CLASS standingorderline_DEB
super:Init(HyperLabel{"DEB","Deb","","standingorderline_DEB"},"N",19,2)

RETURN SELF
CLASS standingorderline_DESCRIPTN INHERIT FIELDSPEC
METHOD Init() CLASS standingorderline_DESCRIPTN
super:Init(HyperLabel{"DESCRIPTN","Descriptn","","standingorderline_DESCRIPTN"},"C",511,0)

RETURN SELF
CLASS standingorderline_GC INHERIT FIELDSPEC
METHOD Init() CLASS standingorderline_GC
super:Init(HyperLabel{"GC","Gc","","standingorderline_GC"},"C",2,0)

RETURN SELF
CLASS standingorderline_REFERENCE INHERIT FIELDSPEC
METHOD Init() CLASS standingorderline_REFERENCE
super:Init(HyperLabel{"REFERENCE","Reference","","standingorderline_REFERENCE"},"C",127,0)

RETURN SELF
CLASS StandingOrderLine_SEQNR INHERIT FIELDSPEC
METHOD Init() CLASS StandingOrderLine_SEQNR
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#SEQNR, "Seqnr", "", "standingorderline_SEQNR" },  "N", 6, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS standingorderline_STORDRID INHERIT FIELDSPEC
METHOD Init() CLASS standingorderline_STORDRID
super:Init(HyperLabel{"STORDRID","Stordrid","","standingorderline_STORDRID"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS StOrdLineHelp INHERIT DBSERVEREXTRA
	INSTANCE cDBFPath	  := "" as STRING
	INSTANCE cName		  := "stOrLHlp.dbf" as STRING
	INSTANCE xDriver	  := "DBFNTX"		 as USUAL
	INSTANCE lReadOnlyMode:= .F.		 as LOGIC
	INSTANCE lSharedMode  := nil	 as USUAL
	INSTANCE nOrder 	  := 0	 as int
	//USER CODE STARTS HERE (do NOT remove this line)  
	export aMirror:={} as array  // {{ [1]deb,[2[]cre, [3]category, [4]gc, [5]accountid, [6]recno, [7]account#,[8]creditor,[9]bankacct,[10]persid,[11]INCEXPFD},[12]depid}
ACCESS  ACCOUNTID  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#ACCOUNTID)
ASSIGN  ACCOUNTID(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#ACCOUNTID, uValue)

ACCESS  ACCOUNTNAM  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#ACCOUNTNAM)
ASSIGN  ACCOUNTNAM(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#ACCOUNTNAM, uValue)

ACCESS  ACCOUNTNBR  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#ACCOUNTNBR)
ASSIGN  ACCOUNTNBR(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#ACCOUNTNBR, uValue)

ACCESS  BANKACCT  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#BANKACCT)
ASSIGN  BANKACCT(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#BANKACCT, uValue)

ACCESS  CATEGORY  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#CATEGORY)
ASSIGN  CATEGORY(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#CATEGORY, uValue)

ACCESS  CRE  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#CRE)
ASSIGN  CRE(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#CRE, uValue)

ACCESS  CREDITOR  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#CREDITOR)
ASSIGN  CREDITOR(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#CREDITOR, uValue)

ACCESS  CREDTRNAM  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#CREDTRNAM)
ASSIGN  CREDTRNAM(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#CREDTRNAM, uValue)

ACCESS  DEB  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#DEB)
ASSIGN  DEB(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#DEB, uValue)

ACCESS  DEPID  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#DEPID)
ASSIGN  DEPID(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#DEPID, uValue)

ACCESS  DESCRIPTN  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#DESCRIPTN)
ASSIGN  DESCRIPTN(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#DESCRIPTN, uValue)

ACCESS FieldDesc CLASS StOrdLineHelp
	//
	//	Describes all fields selected by DBServer-Editor
	//
	LOCAL aRet		AS ARRAY
	LOCAL nFields	AS DWORD

	nFields := 16

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
		
		aRet[1] := { #ACCOUNTNBR, "ACCOUNTNBR",  StOrdLineHelp_AccNumber{}}
		aRet[2] := { #ACCOUNTNAM, "ACCOUNTNAM",  StOrdLineHelp_ACCOUNTNAM{}}
		aRet[3] := { #DEB, "DEB",  StOrdLineHelp_DEB{}}
		aRet[4] := { #CRE, "CRE",  StOrdLineHelp_CRE{}}
		aRet[5] := { #DESCRIPTN, "DESCRIPTN",  StOrdLineHelp_Descriptn{}}
		aRet[6] := { #ACCOUNTID, "ACCOUNTID",  StOrdLineHelp_ACCOUNTID{}}
		aRet[7] := { #GC, "GC",  StOrdLineHelp_GC{}}
		aRet[8] := { #CATEGORY, "CATEGORY",  StOrdLineHelp_Category{}}
		aRet[9] := { #SEQNR, "SEQNR",  StandingOrderLine_SEQNR{}}
		aRet[10] := { #RECNBR, "RECNBR",  StOrdLineHelp_RECNBR{}}
		aRet[11] := { #REFERENCE, "REFERENCE",  Transaction_REFERENCE{}}
		aRet[12] := { #CREDITOR, "CREDITOR",  account_CLN{}}
		aRet[13] := { #BANKACCT, "BANKACCT",  standingorderline_BANKACCT{}}
		aRet[14] := { #CREDTRNAM, "CREDTRNAM",  StOrdLineHelp_CREDTRNAM{}}
		aRet[15] := { #INCEXPFD, "INCEXPFD",  TempTrans_INCEXPFD{}}
		aRet[16] := { #DEPID, "DEPID",  StOrdLineHelp_DEPID{}}

	ELSE
		aRet := {}
	ENDIF


	RETURN aRet
ACCESS  GC  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#GC)
ASSIGN  GC(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#GC, uValue)

ACCESS  INCEXPFD  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#INCEXPFD)
ASSIGN  INCEXPFD(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#INCEXPFD, uValue)

ACCESS IndexList CLASS StOrdLineHelp
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
METHOD Init(cDBF, lShare, lRO, xRdd) CLASS StOrdLineHelp
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

	oHyperLabel := HyperLabel{#StOrdLineHelp, "StOrdLineHelp", "", "StOrdLineHelp"}

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
ACCESS  RECNBR  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#RECNBR)
ASSIGN  RECNBR(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#RECNBR, uValue)

ACCESS  REFERENCE  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#REFERENCE)
ASSIGN  REFERENCE(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#REFERENCE, uValue)

ACCESS  SEQNR  CLASS StOrdLineHelp

    RETURN SELF:FieldGet(#SEQNR)
ASSIGN  SEQNR(uValue)  CLASS StOrdLineHelp

    RETURN SELF:FieldPut(#SEQNR, uValue)

CLASS StOrdLineHelp_AccNumber INHERIT ACCOUNT_ACCNUMBER
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS StOrdLineHelp_AccNumber
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#AccNumber, "Account#", "Number of the account", "Account_AccNumber" },  "C", 12, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS StOrdLineHelp_ACCOUNTID INHERIT ACCOUNT_REK
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS StOrdLineHelp_ACCOUNTID
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#ACCOUNTID, "Accountid", "", "StOrdLineHelp_ACCOUNTID" },  "N", 11, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS StOrdLineHelp_ACCOUNTNAM INHERIT ACCOUNT_OMS
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS StOrdLineHelp_ACCOUNTNAM
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Oms, "Description", "Name of the account", "Rek_OMS" },  "C", 40, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS StOrdLineHelp_Category INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS StOrdLineHelp_Category
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Category, "Category", "Category of the transaction: donation, member gift, etc.", "StOrdLineHelp_Category" },  "C", 1, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS StOrdLineHelp_CRE INHERIT TRANSACTION_CRE
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS StOrdLineHelp_CRE
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#CRE, "Credit", "", "Transaction_CRE" },  "N", 15, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS StOrdLineHelp_CREDTRNAM INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS StOrdLineHelp_CREDTRNAM
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#CREDTRNAM, "Creditor", "", "StOrdLineHelp_CREDTRNAM" },  "C", 40, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS StOrdLineHelp_DEB INHERIT TRANSACTION_DEB
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS StOrdLineHelp_DEB
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#DEB, "Debit", "", "Transaction_DEB" },  "N", 15, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS StOrdLineHelp_DEPID INHERIT department_DEPID
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS StOrdLineHelp_DEPID
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#DEPID, "Depid", "", "StOrdLineHelp_DEPID" },  "N", 11, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS StOrdLineHelp_Descriptn INHERIT STANDINGORDERLINE_DESCRIPTN
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS StOrdLineHelp_Descriptn
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Descriptn, "Descriptn", "", "" },  "C", 64, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS StOrdLineHelp_GC INHERIT TRANSACTION_GC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS StOrdLineHelp_GC
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#GC, "Gc", "", "StOrdLineHelp_GC" },  "C", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS StOrdLineHelp_RECNBR INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS StOrdLineHelp_RECNBR
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#RECNBR, "Recnbr", "", "StOrdLineHelp_RECNBR" },  "N", 8, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
