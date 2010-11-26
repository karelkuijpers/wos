CLASS DOCID INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS DOCID
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#DOCID, "Document id", "Document id", "Transaction_BST" },  "C", 10, 0 )
    cPict       := "!XXXXXXXXX"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_AD1 INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_AD1
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#address, "Address", "Streetname and house#", "Person_AD1" },  "M", 10, 0 )
    cPict       := "!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_BDAT INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_BDAT
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#bdat, "Creation date", "Date of first registration", "Person_BDAT" },  "D", 8, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_BIRTHDAT INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_BIRTHDAT
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#BIRTHDAT, "Birthdate", "Birthdate of a person", "Person_BIRTHDAT" },  "D", 8, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_CLN INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_CLN
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#persid, "InternalID", "Internal ID of a person", "" },  "C", 5, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_DLG INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_DLG
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#DLG, "Date last gift", "Date of last gift", "Person_DLG" },  "D", 8, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_EMAIL INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_EMAIL
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#EMAIL, "Email address", "E-mail address of the person", "Person_EMAIL" },  "C", 50, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ExportPerson_EXTRAPR INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_EXTRAPR
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#EXTRAPR, "Extrapr", "", "ExportPerson_EXTRAPR" },  "C", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ExportPerson_FAX INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_FAX
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#FAX, "Fax.nbr", "Fax telephone#", "Person_FAX" },  "C", 18, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_GENDER INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_GENDER
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#GENDERDescr, "Gender", "Gender of a person", "ExportPerson_GENDER" },  "C", 20, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_HOUSNBR INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_HOUSNBR
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#HOUSENBR, "House#", "House Number", "ExportPerson_HOUSNBR" },  "C", 15, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ExportPerson_LAN INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_LAN
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#COUNTRY, "Country", "Country where the person lives", "Person_LAN" },  "C", 20, 0 )
    cPict       := "!XXXXXXXXXXXXXXXXXXX"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_MAILABBR INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_MAILABBR
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#MAILABBR, "Mailcodes abbreviated", "Mailcodes abbreviation", "ExportPerson_MAILABBR" },  "C", 40, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ExportPerson_MAILCODE INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_MAILCODE
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#MAILCODE, "Mailcodes long", "Mailcodes description", "ExportPerson_MAILCODE" },  "C", 200, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ExportPerson_Mobile INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_Mobile
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Mobile, "Mobile", "Mobile telephone#", "Person_Mobile" },  "C", 18, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_MUTD INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_MUTD
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#MUTD, "Date altered", "Date of last update", "Person_MUTD" },  "D", 8, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_NA1 INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_NA1
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#LastName, "Lastname", "Last name", "Person_lastName" },  "C", 28, 0 )
    cPict       := "!XXXXXXXXXXXXXXXXXXXXXXXXXXX"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_NA2 INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_NA2
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Initials, "Initials", "Initials of the person", "Person_NA2" },  "C", 10, 0 )
    cPict       := "!XXXXXXXXX"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_NA3 INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_NA3
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Nameext, "Name extention", "Extention of the name", "Person_NA3" },  "C", 28, 0 )
    cPict       := "!XXXXXXXXXXXXXXXXXXXXXXXXXXX"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_OPM INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_OPM
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#REMARKS, "Remarks", "Remarks concerning a person", "Person_OPM" },  "C", 60, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_PLA INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_PLA
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#CITY, "City", "City name", "Person_PLA" },  "C", 35, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_POS INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_POS
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#POS, "Zip code", "Postal code", "Person_POS" },  "C", 14, 0 )
    cPict       := "@!"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_Street INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_Street
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#STREET, "Street Name", "Street name", "" },  "C", 30, 0 )
    cPict       := "!XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ExportPerson_TAV INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_TAV
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#ATTENTION, "Attention", "Attention person", "Person_TAV" },  "C", 28, 0 )
    cPict       := "!XXXXXXXXXXXXXXXXXXXXXXXX"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_TEL1 INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_TEL1
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TEL1, "Tel.business", "Telephone# business", "Person_TEL1" },  "C", 18, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_TEL2 INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_TEL2
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TEL2, "Tel.home", "Telephone# at home", "Person_TEL2" },  "C", 18, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_TITLE INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_TITLE
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TITLE, "Title", "Title of a person", "ExportPerson_TITLE" },  "C", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF
CLASS ExportPerson_TYPE INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_TYPE
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TYPEPerson, "Type", "Type of person/organisation", "ExportPerson_TYPE" },  "C", 30, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_VRN INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_VRN
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#FIRSTNAME, "First name", "First name of the person", "Person_VRN" },  "C", 20, 0 )
    cPict       := "!XXXXXXXXXXXXXXXXXXX"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS ExportPerson_Vrvgsl INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS ExportPerson_Vrvgsl
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#prefix, "Prefix name", "Name prefix of the person", "Person_HISN" },  "C", 8, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS REFERENCE INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS REFERENCE
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#REFERENCE, "Reference", "Reference Gift", "Transaction_REFERENCE" },  "M", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Total_Amount INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Total_Amount
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TOTAMNT, "Total Amount", "Total Amount", "" },  "N", 12, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




