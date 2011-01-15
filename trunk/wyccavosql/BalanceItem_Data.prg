CLASS BalanceItem_HFDRBRNUM INHERIT FIELDSPEC
METHOD Init() CLASS BalanceItem_HFDRBRNUM
super:Init(HyperLabel{"balitemidparent","balitemidparent","","balanceitem_HFDRBRNUM"},"N",11,0)

RETURN SELF
CLASS BalanceItem_INDHFDRBR INHERIT FIELDSPEC
METHOD Init() CLASS BalanceItem_INDHFDRBR
super:Init(HyperLabel{"INDHFDRBR","Indhfdrbr","","balanceitem_INDHFDRBR"},"N",3,0)

RETURN SELF
CLASS BalanceItem_KOPTEKST INHERIT FIELDSPEC
METHOD Init() CLASS BalanceItem_KOPTEKST
super:Init(HyperLabel{"Heading","Heading","","balanceitem_KOPTEKST"},"C",25,0)

RETURN SELF
CLASS BalanceItem_NUM INHERIT FIELDSPEC
METHOD Init() CLASS BalanceItem_NUM
super:Init(HyperLabel{"balitemid","balitemid","","balanceitem_NUM"},"N",11,0)

RETURN SELF
CLASS BalanceItem_NUMBER INHERIT FIELDSPEC
METHOD Init() CLASS BalanceItem_NUMBER
super:Init(HyperLabel{"NUMBER","Number","","balanceitem_NUMBER"},"C",6,0)

RETURN SELF
CLASS BalanceItem_SOORT INHERIT FIELDSPEC
METHOD Init() CLASS BalanceItem_SOORT
super:Init(HyperLabel{"category","category","","balanceitem_SOORT"},"C",2,0)

RETURN SELF
CLASS BalanceItem_VOETTEKST INHERIT FIELDSPEC
METHOD Init() CLASS BalanceItem_VOETTEKST
super:Init(HyperLabel{"Footer","Footer","","balanceitem_VOETTEKST"},"C",25,0)

RETURN SELF
Define IDM_BALANCEITEM_NAME := "BalanceItem"
Define IDM_BalanceItem_USERID := "parous…ºw@™Ðw"
