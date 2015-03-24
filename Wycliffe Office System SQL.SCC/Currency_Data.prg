CLASS CurrencyList_AED INHERIT FIELDSPEC
METHOD Init() CLASS CurrencyList_AED
super:Init(HyperLabel{"AED","Aed","","currencylist_AED"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS CurrencyList_UNITED_ARA INHERIT FIELDSPEC
METHOD Init() CLASS CurrencyList_UNITED_ARA
super:Init(HyperLabel{"UNITED_ARA","United Ara","","currencylist_UNITED_ARA"},"C",59,0)

RETURN SELF
CLASS CurrencyRate_AED INHERIT FIELDSPEC
METHOD Init() CLASS CurrencyRate_AED
super:Init(HyperLabel{"AED","Aed","","currencyrate_AED"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS CurrencyRate_AEDUNIT INHERIT FIELDSPEC
METHOD Init() CLASS CurrencyRate_AEDUNIT
super:Init(HyperLabel{"AEDUNIT","Aedunit","","currencyrate_AEDUNIT"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS CurrencyRate_DATERATE INHERIT FIELDSPEC
METHOD Init() CLASS CurrencyRate_DATERATE
super:Init(HyperLabel{"DATERATE","Daterate","","currencyrate_DATERATE"},"D",10,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS CurrencyRate_ROE INHERIT FIELDSPEC
METHOD Init() CLASS CurrencyRate_ROE
super:Init(HyperLabel{"ROE","Roe","","currencyrate_ROE"},"N",16,10)

RETURN SELF
Define IDM_CURRENCYLIST_NAME := "CurrencyList"
Define IDM_CurrencyList_USERID := "parous…ºw@™Ðw"
Define IDM_CURRENCYRATE_NAME := "CurrencyRate"
Define IDM_CurrencyRate_USERID := "parous…ºw@™Ðw"
