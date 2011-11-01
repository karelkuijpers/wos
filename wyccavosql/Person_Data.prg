CLASS Bank INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Bank
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#banknumber, "Bank accounts", "Number of bankaccount", "" },  "C", 25, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




Define IDM_PERSON_NAME := "Person"
Define IDM_Person_USERID := "parous…ew@™=w"
Define IDM_PERSONBANK_NAME := "PersonBank"
Define IDM_PersonBank_USERID := "parous…ºw@™Ðw"
CLASS Person_AD1 INHERIT FIELDSPEC


METHOD Init() CLASS Person_AD1
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#AD1, "Ad1", "", "person_AD1" },  "M", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Person_BDAT INHERIT FIELDSPEC
METHOD Init() CLASS Person_BDAT
super:Init(HyperLabel{"BDAT","Bdat","","person_BDAT"},"D",10,0)

RETURN SELF
CLASS Person_BIRTHDAT INHERIT FIELDSPEC
METHOD Init() CLASS Person_BIRTHDAT
super:Init(HyperLabel{"BIRTHDAT","Birthdat","","person_BIRTHDAT"},"D",10,0)

RETURN SELF
CLASS Person_CLN INHERIT FIELDSPEC
METHOD Init() CLASS Person_CLN
super:Init(HyperLabel{"persid","persid","","person_CLN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Person_COD INHERIT FIELDSPEC
METHOD Init() CLASS Person_COD
super:Init(HyperLabel{"COD","Cod","","person_COD"},"C",30,0)

RETURN SELF
CLASS Person_DLG INHERIT FIELDSPEC
METHOD Init() CLASS Person_DLG
super:Init(HyperLabel{"DLG","Dlg","","person_DLG"},"D",10,0)

RETURN SELF
CLASS Person_EMAIL INHERIT FIELDSPEC
METHOD Init() CLASS Person_EMAIL
super:Init(HyperLabel{"EMAIL","Email","","person_EMAIL"},"C",64,0)

RETURN SELF
CLASS Person_EXTERNID INHERIT FIELDSPEC


METHOD Init() CLASS Person_EXTERNID
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#EXTERNID, "Externid", "External ID", "person_EXTERNID" },  "C", 24, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Person_FAX INHERIT FIELDSPEC
METHOD Init() CLASS Person_FAX
super:Init(HyperLabel{"FAX","Fax","","person_FAX"},"C",18,0)

RETURN SELF
CLASS Person_GENDER INHERIT FIELDSPEC
METHOD Init() CLASS Person_GENDER
super:Init(HyperLabel{"GENDER","Gender","","person_GENDER"},"N",6,0)

RETURN SELF
CLASS Person_HISN INHERIT FIELDSPEC
METHOD Init() CLASS Person_HISN
super:Init(HyperLabel{"prefix","prefix","","person_HISN"},"C",8,0)

RETURN SELF
CLASS Person_LAN INHERIT FIELDSPEC
METHOD Init() CLASS Person_LAN
super:Init(HyperLabel{"country","country","","person_LAN"},"C",20,0)

RETURN SELF
CLASS Person_MOBILE INHERIT FIELDSPEC
METHOD Init() CLASS Person_MOBILE
super:Init(HyperLabel{"MOBILE","Mobile","","person_MOBILE"},"C",18,0)

RETURN SELF
CLASS Person_MUTD INHERIT FIELDSPEC
METHOD Init() CLASS Person_MUTD
super:Init(HyperLabel{"MUTD","Mutd","","person_MUTD"},"D",10,0)

RETURN SELF
CLASS Person_NA1 INHERIT FIELDSPEC
METHOD Init() CLASS Person_NA1
super:Init(HyperLabel{"lastname","lastname","","person_NA1"},"C",28,0)

RETURN SELF
CLASS Person_NA2 INHERIT FIELDSPEC
METHOD Init() CLASS Person_NA2
super:Init(HyperLabel{"initials","initials","","person_NA2"},"C",10,0)

RETURN SELF
CLASS Person_NA3 INHERIT FIELDSPEC
METHOD Init() CLASS Person_NA3
super:Init(HyperLabel{"nameext","nameext","","person_NA3"},"C",28,0)

RETURN SELF
CLASS Person_OPC INHERIT FIELDSPEC
METHOD Init() CLASS Person_OPC
super:Init(HyperLabel{"OPC","Opc","","person_OPC"},"C",10,0)

RETURN SELF
CLASS Person_OPM INHERIT FIELDSPEC
METHOD Init() CLASS Person_OPM
super:Init(HyperLabel{"remarks","remarks","","person_OPM"},"M",10,0)

RETURN SELF
CLASS Person_PLA INHERIT FIELDSPEC
METHOD Init() CLASS Person_PLA
super:Init(HyperLabel{"city","city","","person_PLA"},"C",35,0)

RETURN SELF
CLASS Person_POS INHERIT FIELDSPEC
METHOD Init() CLASS Person_POS
super:Init(HyperLabel{"POS","Pos","","person_POS"},"C",14,0)

RETURN SELF
CLASS Person_PROPEXTR INHERIT FIELDSPEC
METHOD Init() CLASS Person_PROPEXTR
super:Init(HyperLabel{"PROPEXTR","Propextr","","person_PROPEXTR"},"M",10,0)

RETURN SELF
CLASS Person_REK INHERIT FIELDSPEC
METHOD Init() CLASS Person_REK
super:Init(HyperLabel{"accid","accid","","person_REK"},"N",11,0)

RETURN SELF
CLASS Person_salutation INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Person_salutation
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Salutation, "Salutation", "Salutation of a person", "" },  "C", 20, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Person_TAV INHERIT FIELDSPEC
METHOD Init() CLASS Person_TAV
super:Init(HyperLabel{"attention","attention","","person_TAV"},"C",28,0)

RETURN SELF
CLASS Person_TEL1 INHERIT FIELDSPEC
METHOD Init() CLASS Person_TEL1
super:Init(HyperLabel{"TEL1","Tel1","","person_TEL1"},"C",18,0)

RETURN SELF
CLASS Person_TEL2 INHERIT FIELDSPEC
METHOD Init() CLASS Person_TEL2
super:Init(HyperLabel{"TEL2","Tel2","","person_TEL2"},"C",18,0)

RETURN SELF
CLASS Person_TITLE INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Person_TITLE
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TITLE, "Tit", "", "person_TIT" },  "C", 3, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Person_TYPE INHERIT FIELDSPEC
METHOD Init() CLASS Person_TYPE
super:Init(HyperLabel{"TYPE","Type","","person_TYPE"},"N",6,0)

RETURN SELF
CLASS Person_VRN INHERIT FIELDSPEC
METHOD Init() CLASS Person_VRN
super:Init(HyperLabel{"firstname","firstname","","person_VRN"},"C",20,0)

RETURN SELF
CLASS PersonBank_CLN INHERIT FIELDSPEC
METHOD Init() CLASS PersonBank_CLN
super:Init(HyperLabel{"persid","persid","","personbank_CLN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS PersonBank_GIRONR INHERIT FIELDSPEC
METHOD Init() CLASS PersonBank_GIRONR
super:Init(HyperLabel{"banknumber","banknumber","","personbank_GIRONR"},"C",25,0)
self:SetRequired(.T.,)

RETURN SELF
ACCESS  titlele  CLASS SQLSelectPerson
	// Return titlele of a person:
	LOCAL ctitle:=self:title, ntitle as int
	LOCAL ctitlele as STRING
	ntitle:=AScan(pers_titles,{|x|x[2]==ctitle})
	IF ntitle>0 
		ctitlele:= pers_titles[ntitle,1]
	ENDIF
return ctitlele
