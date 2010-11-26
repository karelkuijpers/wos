Define IDM_TELEBANKPATTERNS_NAME := "TeleBankPatterns"
Define IDM_TeleBankPatterns_USERID := "parous…ºw@™Ðw"
CLASS TeleBankPatterns_accid INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS TeleBankPatterns_accid
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#accid, "accid", "", "telebankpatterns_accid" },  "N", 11, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS TeleBankPatterns_AddSub INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS TeleBankPatterns_AddSub
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#AddSub, "Debit/Credit", "a:=substract from bankaccount; b: add to bankaccount", "" },  "C", 1, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS TeleBankPatterns_contra_bankaccnt INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS TeleBankPatterns_contra_bankaccnt
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#contra_bankaccnt, "contra bankaccnt", "", "telebankpatterns_contra_bankaccnt" },  "C", 25, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS TeleBankPatterns_contra_name INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS TeleBankPatterns_contra_name
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#contra_name, "Naam Tegnr", "", "telebankpatterns_contra_name" },  "C", 32, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS TeleBankPatterns_description INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS TeleBankPatterns_description
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#description, "Oms", "", "telebankpatterns_description" },  "C", 32, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS TeleBankPatterns_IND_AUTMUT INHERIT FIELDSPEC
METHOD Init() CLASS TeleBankPatterns_IND_AUTMUT
super:Init(HyperLabel{"IND_AUTMUT","Ind Autmut","","telebankpatterns_IND_AUTMUT"},"N",3,0)

RETURN SELF
CLASS TeleBankPatterns_KIND INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS TeleBankPatterns_KIND
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#KIND, "Kind", "", "telebankpatterns_KIND" },  "C", 4, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS TeleBankPatterns_RECDATE INHERIT FIELDSPEC
METHOD Init() CLASS TeleBankPatterns_RECDATE
super:Init(HyperLabel{"RECDATE","Recdate","","telebankpatterns_RECDATE"},"D",10,0)

RETURN SELF
