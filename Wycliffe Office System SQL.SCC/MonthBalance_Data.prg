CLASS AccountBalanceYear_CURRENCY INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_CURRENCY
super:Init(HyperLabel{"CURRENCY","Currency","","accountbalanceyear_CURRENCY"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS AccountBalanceYear_MONTHSTART INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_MONTHSTART
super:Init(HyperLabel{"MONTHSTART","Monthstart","","accountbalanceyear_MONTHSTART"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS AccountBalanceYear_REK INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_REK
super:Init(HyperLabel{"accid","accid","","accountbalanceyear_REK"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS AccountBalanceYear_SVJC INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_SVJC
super:Init(HyperLabel{"SVJC","Svjc","","accountbalanceyear_SVJC"},"N",20,2)

RETURN SELF
CLASS AccountBalanceYear_SVJD INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_SVJD
super:Init(HyperLabel{"SVJD","Svjd","","accountbalanceyear_SVJD"},"N",20,2)

RETURN SELF
CLASS AccountBalanceYear_YEARSTART INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_YEARSTART
super:Init(HyperLabel{"YEARSTART","Yearstart","","accountbalanceyear_YEARSTART"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS balanceyear_MONTHSTART INHERIT FIELDSPEC
METHOD Init() CLASS balanceyear_MONTHSTART
super:Init(HyperLabel{"MONTHSTART","Monthstart","","balanceyear_MONTHSTART"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS balanceyear_STATE INHERIT FIELDSPEC
METHOD Init() CLASS balanceyear_STATE
super:Init(HyperLabel{"STATE","State","","balanceyear_STATE"},"C",1,0)

RETURN SELF
CLASS balanceyear_test INHERIT FIELDSPEC
METHOD Init() CLASS balanceyear_test
super:Init(HyperLabel{"test","Test","","balanceyear_test"},"N",20,2)
self:SetRequired(.T.,)

RETURN SELF
CLASS balanceyear_YEARLENGTH INHERIT FIELDSPEC
METHOD Init() CLASS balanceyear_YEARLENGTH
super:Init(HyperLabel{"YEARLENGTH","Yearlength","","balanceyear_YEARLENGTH"},"N",6,0)

RETURN SELF
CLASS balanceyear_YEARSTART INHERIT FIELDSPEC
METHOD Init() CLASS balanceyear_YEARSTART
super:Init(HyperLabel{"YEARSTART","Yearstart","","balanceyear_YEARSTART"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
Define IDM_ACCOUNTBALANCEYEAR_NAME := "AccountBalanceYear"
Define IDM_AccountBalanceYear_USERID := "parous…ºw@™Ðw"
Define IDM_BALANCEYEAR_NAME := "BalanceYear"
Define IDM_BalanceYear_USERID := "parouÿ…ºw@™Ðw"
Define IDM_MBALANCE_NAME := "MBalance"
Define IDM_MBalance_USERID := "parous…ºw@™Ðw"
CLASS MBalance_CRE INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_CRE
super:Init(HyperLabel{"CRE","Cre","","mbalance_CRE"},"N",20,2)

RETURN SELF
CLASS MBalance_CURRENCY INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_CURRENCY
super:Init(HyperLabel{"CURRENCY","Currency","","mbalance_CURRENCY"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS MBalance_DEB INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_DEB
super:Init(HyperLabel{"DEB","Deb","","mbalance_DEB"},"N",20,2)

RETURN SELF
CLASS MBalance_MONTH INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_MONTH
super:Init(HyperLabel{"MONTH","Month","","mbalance_MONTH"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS MBalance_REK INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_REK
super:Init(HyperLabel{"accid","accid","","mbalance_REK"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS MBalance_YEAR INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_YEAR
super:Init(HyperLabel{"YEAR","Year","","mbalance_YEAR"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
