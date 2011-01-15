Define IDM_SUBSCRIPTION_NAME := "Subscription"
Define IDM_Subscription_USERID := "parous…ºw@™Ðw"
CLASS Subscription_BANKACCNT INHERIT FIELDSPEC
METHOD Init() CLASS Subscription_BANKACCNT
super:Init(HyperLabel{"BANKACCNT","Bankaccnt","","subscription_BANKACCNT"},"C",25,0)

RETURN SELF
CLASS Subscription_duedate INHERIT FIELDSPEC
METHOD Init() CLASS Subscription_duedate
super:Init(HyperLabel{"duedate","duedate","","subscription_duedate"},"D",10,0)

RETURN SELF
CLASS Subscription_GC INHERIT FIELDSPEC
METHOD Init() CLASS Subscription_GC
super:Init(HyperLabel{"GC","Gc","","subscription_GC"},"C",2,0)

RETURN SELF
CLASS Subscription_INVOICEID INHERIT FIELDSPEC
METHOD Init() CLASS Subscription_INVOICEID
super:Init(HyperLabel{"INVOICEID","Invoiceid","","subscription_INVOICEID"},"C",20,0)

RETURN SELF
CLASS Subscription_P01N INHERIT FIELDSPEC
METHOD Init() CLASS Subscription_P01N
super:Init(HyperLabel{"P01N","P01n","","subscription_P01N"},"N",11,0)

RETURN SELF
CLASS Subscription_P04 INHERIT FIELDSPEC
METHOD Init() CLASS Subscription_P04
super:Init(HyperLabel{"P04","P04","","subscription_P04"},"D",10,0)

RETURN SELF
CLASS Subscription_P08 INHERIT FIELDSPEC
METHOD Init() CLASS Subscription_P08
super:Init(HyperLabel{"P08","P08","","subscription_P08"},"N",10,2)

RETURN SELF
CLASS Subscription_P13 INHERIT FIELDSPEC
METHOD Init() CLASS Subscription_P13
super:Init(HyperLabel{"P13","P13","","subscription_P13"},"D",10,0)

RETURN SELF
CLASS Subscription_PAYMETHOD INHERIT FIELDSPEC
METHOD Init() CLASS Subscription_PAYMETHOD
super:Init(HyperLabel{"PAYMETHOD","Paymethod","","subscription_PAYMETHOD"},"C",1,0)

RETURN SELF
CLASS Subscription_personid INHERIT FIELDSPEC
METHOD Init() CLASS Subscription_personid
super:Init(HyperLabel{"personid","personid","","subscription_personid"},"N",11,0)

RETURN SELF
CLASS Subscription_SOORT INHERIT FIELDSPEC
METHOD Init() CLASS Subscription_SOORT
super:Init(HyperLabel{"category","category","","subscription_SOORT"},"C",1,0)

RETURN SELF
CLASS subscription_term INHERIT FIELDSPEC


METHOD Init() CLASS subscription_term
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#term, "term", "term in months of a donation/subscription", "" },  "N", 4, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




