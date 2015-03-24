CLASS bankaccount_BANKNUMMER INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_BANKNUMMER
super:Init(HyperLabel{"banknumber","banknumber","","bankaccount_BANKNUMMER"},"C",25,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS bankaccount_COMALL INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_COMALL
super:Init(HyperLabel{"COMALL","Comall","","bankaccount_COMALL"},"N",3,0)

RETURN SELF
CLASS bankaccount_COMFL INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_COMFL
super:Init(HyperLabel{"COMFL","Comfl","","bankaccount_COMFL"},"N",3,0)

RETURN SELF
CLASS bankaccount_FGMLCODES INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_FGMLCODES
super:Init(HyperLabel{"FGMLCODES","Fgmlcodes","","bankaccount_FGMLCODES"},"C",30,0)

RETURN SELF
CLASS bankaccount_GIFTENIND INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_GIFTENIND
super:Init(HyperLabel{"usedforgifts","usedforgifts","","bankaccount_GIFTENIND"},"N",3,0)

RETURN SELF
CLASS bankaccount_GIFTSALL INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_GIFTSALL
super:Init(HyperLabel{"GIFTSALL","Giftsall","","bankaccount_GIFTSALL"},"N",3,0)

RETURN SELF
CLASS bankaccount_OPENAC INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_OPENAC
super:Init(HyperLabel{"OPENAC","Openac","","bankaccount_OPENAC"},"N",3,0)

RETURN SELF
CLASS bankaccount_OPENALL INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_OPENALL
super:Init(HyperLabel{"OPENALL","Openall","","bankaccount_OPENALL"},"N",3,0)

RETURN SELF
CLASS bankaccount_PAYAHEAD INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_PAYAHEAD
super:Init(HyperLabel{"PAYAHEAD","Payahead","","bankaccount_PAYAHEAD"},"N",11,0)

RETURN SELF
CLASS bankaccount_PO INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_PO
super:Init(HyperLabel{"PO","Po","","bankaccount_PO"},"N",3,0)

RETURN SELF
CLASS bankaccount_REK INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_REK
super:Init(HyperLabel{"accid","accid","","bankaccount_REK"},"N",11,0)

RETURN SELF
CLASS bankaccount_SINGLEDST INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_SINGLEDST
super:Init(HyperLabel{"SINGLEDST","Singledst","","bankaccount_SINGLEDST"},"N",11,0)

RETURN SELF
CLASS bankaccount_SYSCODOVER INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_SYSCODOVER
super:Init(HyperLabel{"SYSCODOVER","Syscodover","","bankaccount_SYSCODOVER"},"C",1,0)

RETURN SELF
CLASS bankaccount_TELEBANKNG INHERIT FIELDSPEC


METHOD Init() CLASS bankaccount_TELEBANKNG
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TELEBANKNG, "Telebankng", "", "bankaccount_TELEBANKNG" },  "L", 1, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS bankaccount_TELEDATDIR INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_TELEDATDIR
super:Init(HyperLabel{"TELEDATDIR","Teledatdir","","bankaccount_TELEDATDIR"},"C",40,0)

RETURN SELF
CLASS bankorder_ACCNTFROM INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_ACCNTFROM
super:Init(HyperLabel{"ACCNTFROM","Accntfrom","","bankorder_ACCNTFROM"},"N",11,0)

RETURN SELF
CLASS bankorder_AMOUNT INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_AMOUNT
super:Init(HyperLabel{"AMOUNT","Amount","","bankorder_AMOUNT"},"N",15,2)

RETURN SELF
CLASS bankorder_BANKNBRCRE INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_BANKNBRCRE
super:Init(HyperLabel{"BANKNBRCRE","Banknbrcre","","bankorder_BANKNBRCRE"},"C",25,0)

RETURN SELF
CLASS bankorder_DATEDUE INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_DATEDUE
super:Init(HyperLabel{"DATEDUE","Datedue","","bankorder_DATEDUE"},"D",10,0)

RETURN SELF
CLASS bankorder_DATEPAYED INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_DATEPAYED
super:Init(HyperLabel{"DATEPAYED","Datepayed","","bankorder_DATEPAYED"},"D",10,0)

RETURN SELF
CLASS bankorder_DESCRPTION INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_DESCRPTION
super:Init(HyperLabel{"DESCRPTION","Descrption","","bankorder_DESCRPTION"},"C",32,0)

RETURN SELF
CLASS bankorder_ID INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_ID
super:Init(HyperLabel{"ID","Id","","bankorder_ID"},"N",11,0)

RETURN SELF
CLASS bankorder_IDFROM INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_IDFROM
super:Init(HyperLabel{"IDFROM","Idfrom","","bankorder_IDFROM"},"N",11,0)

RETURN SELF
CLASS bankorder_STORDRID INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_STORDRID
super:Init(HyperLabel{"STORDRID","Stordrid","","bankorder_STORDRID"},"N",11,0)

RETURN SELF
Define IDM_BANKACCOUNT_NAME := "BankAccount"
Define IDM_BankAccount_USERID := "parouÿÐHgwÐ€Tv"
Define IDM_BANKORDER_NAME := "bankorder"
Define IDM_bankorder_USERID := "parouÿÐHávÐ€tu"
