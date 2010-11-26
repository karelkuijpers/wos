CLASS BalanceItem INHERIT SQLTable 
declare method ValidateBalanceTransition,FindBal
ACCESS balitemid CLASS BalanceItem
 RETURN self:FieldGet(1)
ASSIGN balitemid(uValue) CLASS BalanceItem
 RETURN self:FieldPut(1, uValue)
ACCESS balitemidparent CLASS BalanceItem
 RETURN self:FieldGet(5)
ASSIGN balitemidparent(uValue) CLASS BalanceItem
 RETURN self:FieldPut(5, uValue)
ACCESS category CLASS BalanceItem
 RETURN self:FieldGet(6)
ASSIGN category(uValue) CLASS BalanceItem
 RETURN self:FieldPut(6, uValue)
ACCESS Footer CLASS BalanceItem
 RETURN self:FieldGet(3)
ASSIGN Footer(uValue) CLASS BalanceItem
 RETURN self:FieldPut(3, uValue)
ACCESS Heading CLASS BalanceItem
 RETURN self:FieldGet(2)
ASSIGN Heading(uValue) CLASS BalanceItem
 RETURN self:FieldPut(2, uValue)
ACCESS INDHFDRBR CLASS BalanceItem
 RETURN self:FieldGet(4)
ASSIGN INDHFDRBR(uValue) CLASS BalanceItem
 RETURN self:FieldPut(4, uValue)
METHOD Init( cTable, oConn ) CLASS BalanceItem
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`balanceitem`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_BalanceItem_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`balitemid`] , ;
   [`Heading`] , ;
   [`Footer`] , ;
   [`INDHFDRBR`] , ;
   [`balitemidparent`] , ;
   [`category`] , ;
   [`NUMBER`]   }, oConn )

oHyperLabel := HyperLabel{IDM_BALANCEITEM_NAME,  ;
   "BalanceItem",  ;
   ,  ;
   "BalanceItem" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=BalanceItem_NUM{}
    self:SetDataField(1,DataField{[balitemid] ,oFS})
    oFS:=BalanceItem_KOPTEKST{}
    self:SetDataField(2,DataField{[Heading] ,oFS})
    oFS:=BalanceItem_VOETTEKST{}
    self:SetDataField(3,DataField{[Footer] ,oFS})
    oFS:=BalanceItem_INDHFDRBR{}
    self:SetDataField(4,DataField{[INDHFDRBR] ,oFS})
    oFS:=BalanceItem_HFDRBRNUM{}
    self:SetDataField(5,DataField{[balitemidparent] ,oFS})
    oFS:=BalanceItem_SOORT{}
    self:SetDataField(6,DataField{[category] ,oFS})
    oFS:=BalanceItem_NUMBER{}
    self:SetDataField(7,DataField{[NUMBER] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS NUMBER CLASS BalanceItem
 RETURN self:FieldGet(7)
ASSIGN NUMBER(uValue) CLASS BalanceItem
 RETURN self:FieldPut(7, uValue)
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
