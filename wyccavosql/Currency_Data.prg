CLASS CurrencyList INHERIT SQLTable
ACCESS AED CLASS CurrencyList
 RETURN self:FieldGet(1)
ASSIGN AED(uValue) CLASS CurrencyList
 RETURN self:FieldPut(1, uValue)
METHOD Init( cTable, oConn ) CLASS CurrencyList
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`currencylist`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_CurrencyList_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`AED`] , ;
   [`UNITED_ARA`]   }, oConn )

oHyperLabel := HyperLabel{IDM_CURRENCYLIST_NAME,  ;
   "CurrencyList",  ;
   ,  ;
   "CurrencyList" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=CurrencyList_AED{}
    self:SetDataField(1,DataField{[AED] ,oFS})
    oFS:=CurrencyList_UNITED_ARA{}
    self:SetDataField(2,DataField{[UNITED_ARA] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS UNITED_ARA CLASS CurrencyList
 RETURN self:FieldGet(2)
ASSIGN UNITED_ARA(uValue) CLASS CurrencyList
 RETURN self:FieldPut(2, uValue)
CLASS CurrencyList_AED INHERIT FIELDSPEC
METHOD Init() CLASS CurrencyList_AED
super:Init(HyperLabel{"AED","Aed","","currencylist_AED"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS CurrencyList_UNITED_ARA INHERIT FIELDSPEC
METHOD Init() CLASS CurrencyList_UNITED_ARA
super:Init(HyperLabel{"UNITED_ARA","United Ara","","currencylist_UNITED_ARA"},"C",59,0)

RETURN SELF
CLASS CurrencyRate INHERIT SQLTable
ACCESS AED CLASS CurrencyRate
 RETURN self:FieldGet(1)
ASSIGN AED(uValue) CLASS CurrencyRate
 RETURN self:FieldPut(1, uValue)
ACCESS AEDUNIT CLASS CurrencyRate
 RETURN self:FieldGet(4)
ASSIGN AEDUNIT(uValue) CLASS CurrencyRate
 RETURN self:FieldPut(4, uValue)
ACCESS DATERATE CLASS CurrencyRate
 RETURN self:FieldGet(2)
ASSIGN DATERATE(uValue) CLASS CurrencyRate
 RETURN self:FieldPut(2, uValue)
METHOD Init( cTable, oConn ) CLASS CurrencyRate
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`currencyrate`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_CurrencyRate_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`AED`] , ;
   [`DATERATE`] , ;
   [`ROE`] , ;
   [`AEDUNIT`]   }, oConn )

oHyperLabel := HyperLabel{IDM_CURRENCYRATE_NAME,  ;
   "CurrencyRate",  ;
   ,  ;
   "CurrencyRate" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    self:SetPrimaryKey(2)
    self:SetPrimaryKey(4)
    oFS:=CurrencyRate_AED{}
    self:SetDataField(1,DataField{[AED] ,oFS})
    oFS:=CurrencyRate_DATERATE{}
    self:SetDataField(2,DataField{[DATERATE] ,oFS})
    oFS:=CurrencyRate_ROE{}
    self:SetDataField(3,DataField{[ROE] ,oFS})
    oFS:=CurrencyRate_AEDUNIT{}
    self:SetDataField(4,DataField{[AEDUNIT] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS ROE CLASS CurrencyRate
 RETURN self:FieldGet(3)
ASSIGN ROE(uValue) CLASS CurrencyRate
 RETURN self:FieldPut(3, uValue)
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
