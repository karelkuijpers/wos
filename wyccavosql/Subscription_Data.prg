Define IDM_SUBSCRIPTION_NAME := "Subscription"
Define IDM_Subscription_USERID := "parous…ºw@™Ðw"
CLASS Subscription INHERIT SQLTable
ACCESS BANKACCNT CLASS Subscription
 RETURN self:FieldGet(12)
ASSIGN BANKACCNT(uValue) CLASS Subscription
 RETURN self:FieldPut(12, uValue)
ACCESS category CLASS Subscription
 RETURN self:FieldGet(8)
ASSIGN category(uValue) CLASS Subscription
 RETURN self:FieldPut(8, uValue)
ACCESS duedate CLASS Subscription
 RETURN self:FieldGet(4)
ASSIGN duedate(uValue) CLASS Subscription
 RETURN self:FieldPut(4, uValue)
ACCESS GC CLASS Subscription
 RETURN self:FieldGet(9)
ASSIGN GC(uValue) CLASS Subscription
 RETURN self:FieldPut(9, uValue)
METHOD Init( cTable, oConn ) CLASS Subscription
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`subscription`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_Subscription_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`personid`] , ;
   [`P01N`] , ;
   [`P04`] , ;
   [`duedate`] , ;
   [`term`] , ;
   [`P08`] , ;
   [`P13`] , ;
   [`category`] , ;
   [`GC`] , ;
   [`PAYMETHOD`] , ;
   [`INVOICEID`] , ;
   [`BANKACCNT`]   }, oConn )

oHyperLabel := HyperLabel{IDM_SUBSCRIPTION_NAME,  ;
   "Subscription",  ;
   ,  ;
   "Subscription" }
IF oHLStatus = NIL
    self:Seek()
    oFS:=Subscription_personid{}
    self:SetDataField(1,DataField{[personid] ,oFS})
    oFS:=Subscription_P01N{}
    self:SetDataField(2,DataField{[P01N] ,oFS})
    oFS:=Subscription_P04{}
    self:SetDataField(3,DataField{[P04] ,oFS})
    oFS:=Subscription_duedate{}
    self:SetDataField(4,DataField{[duedate] ,oFS})
    oFS:=Subscription_term{}
    self:SetDataField(5,DataField{[term] ,oFS})
    oFS:=Subscription_P08{}
    self:SetDataField(6,DataField{[P08] ,oFS})
    oFS:=Subscription_P13{}
    self:SetDataField(7,DataField{[P13] ,oFS})
    oFS:=Subscription_SOORT{}
    self:SetDataField(8,DataField{[category] ,oFS})
    oFS:=Subscription_GC{}
    self:SetDataField(9,DataField{[GC] ,oFS})
    oFS:=Subscription_PAYMETHOD{}
    self:SetDataField(10,DataField{[PAYMETHOD] ,oFS})
    oFS:=Subscription_INVOICEID{}
    self:SetDataField(11,DataField{[INVOICEID] ,oFS})
    oFS:=Subscription_BANKACCNT{}
    self:SetDataField(12,DataField{[BANKACCNT] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS INVOICEID CLASS Subscription
 RETURN self:FieldGet(11)
ASSIGN INVOICEID(uValue) CLASS Subscription
 RETURN self:FieldPut(11, uValue)
ACCESS P01N CLASS Subscription
 RETURN self:FieldGet(2)
ASSIGN P01N(uValue) CLASS Subscription
 RETURN self:FieldPut(2, uValue)
ACCESS P04 CLASS Subscription
 RETURN self:FieldGet(3)
ASSIGN P04(uValue) CLASS Subscription
 RETURN self:FieldPut(3, uValue)
ACCESS P08 CLASS Subscription
 RETURN self:FieldGet(6)
ASSIGN P08(uValue) CLASS Subscription
 RETURN self:FieldPut(6, uValue)
ACCESS P13 CLASS Subscription
 RETURN self:FieldGet(7)
ASSIGN P13(uValue) CLASS Subscription
 RETURN self:FieldPut(7, uValue)
ACCESS PAYMETHOD CLASS Subscription
 RETURN self:FieldGet(10)
ASSIGN PAYMETHOD(uValue) CLASS Subscription
 RETURN self:FieldPut(10, uValue)
ACCESS personid CLASS Subscription
 RETURN self:FieldGet(1)
ASSIGN personid(uValue) CLASS Subscription
 RETURN self:FieldPut(1, uValue)
ACCESS term CLASS Subscription
 RETURN self:FieldGet(5)
ASSIGN term(uValue) CLASS Subscription
 RETURN self:FieldPut(5, uValue)
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




