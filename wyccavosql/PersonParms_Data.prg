Define IDM_PERSCOD_NAME := "Perscod"
Define IDM_Perscod_USERID := "parous…ºw@™Ðw"
Define IDM_PERSON_PROPERTIES_NAME := "Person_Properties"
Define IDM_Person_Properties_USERID := "parous…ºw@™Ðw"
Define IDM_PERSONTYPE_NAME := "PersonType"
Define IDM_PersonType_USERID := "parous…ºw@™Ðw"
Define IDM_TITLES_NAME := "Titles"
Define IDM_Titles_USERID := "parous…ºw@™Ðw"
CLASS Perscod INHERIT SQLTable
ACCESS ABBRVTN CLASS Perscod
 RETURN self:FieldGet(3)
ASSIGN ABBRVTN(uValue) CLASS Perscod
 RETURN self:FieldPut(3, uValue)
ACCESS description CLASS Perscod
 RETURN self:FieldGet(2)
ASSIGN Description(uValue) CLASS Perscod
 RETURN self:FieldPut(2, uValue)
METHOD Init( cTable, oConn ) CLASS Perscod
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`perscod`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_Perscod_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`PERS_CODE`] , ;
   [`description`] , ;
   [`ABBRVTN`]   }, oConn )

oHyperLabel := HyperLabel{IDM_PERSCOD_NAME,  ;
   "Perscod",  ;
   ,  ;
   "Perscod" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=Perscod_PERS_CODE{}
    self:SetDataField(1,DataField{[PERS_CODE] ,oFS})
    oFS:=Perscod_OMS{}
    self:SetDataField(2,DataField{[description] ,oFS})
    oFS:=Perscod_ABBRVTN{}
    self:SetDataField(3,DataField{[ABBRVTN] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS PERS_CODE CLASS Perscod
 RETURN self:FieldGet(1)
ASSIGN PERS_CODE(uValue) CLASS Perscod
 RETURN self:FieldPut(1, uValue)
CLASS Perscod_ABBRVTN INHERIT FIELDSPEC
METHOD Init() CLASS Perscod_ABBRVTN
super:Init(HyperLabel{"ABBRVTN","Abbrvtn","","perscod_ABBRVTN"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Perscod_OMS INHERIT FIELDSPEC
METHOD Init() CLASS Perscod_OMS
super:Init(HyperLabel{"description","description","","perscod_OMS"},"C",20,0)

RETURN SELF
CLASS Perscod_PERS_CODE INHERIT FIELDSPEC
METHOD Init() CLASS Perscod_PERS_CODE
super:Init(HyperLabel{"PERS_CODE","Pers Code","","perscod_PERS_CODE"},"C",2,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Person_Properties INHERIT SQLTable
ACCESS ID CLASS Person_Properties
 RETURN self:FieldGet(1)
ASSIGN ID(uValue) CLASS Person_Properties
 RETURN self:FieldPut(1, uValue)
METHOD Init( cTable, oConn ) CLASS Person_Properties
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`person_properties`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_Person_Properties_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`ID`] , ;
   [`NAME`] , ;
   [`TYPE`] , ;
   [`VALUES`]   }, oConn )

oHyperLabel := HyperLabel{IDM_PERSON_PROPERTIES_NAME,  ;
   "Person_Properties",  ;
   ,  ;
   "Person_Properties" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=Person_Properties_ID{}
    self:SetDataField(1,DataField{[ID] ,oFS})
    oFS:=Person_Properties_NAME{}
    self:SetDataField(2,DataField{[NAME] ,oFS})
    oFS:=Person_Properties_TYPE{}
    self:SetDataField(3,DataField{[TYPE] ,oFS})
    oFS:=Person_Properties_VALUES{}
    self:SetDataField(4,DataField{[VALUES] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS NAME CLASS Person_Properties
 RETURN self:FieldGet(2)
ASSIGN NAME(uValue) CLASS Person_Properties
 RETURN self:FieldPut(2, uValue)
ACCESS TYPE CLASS Person_Properties
 RETURN self:FieldGet(3)
ASSIGN TYPE(uValue) CLASS Person_Properties
 RETURN self:FieldPut(3, uValue)
ACCESS VALUES CLASS Person_Properties
 RETURN self:FieldGet(4)
ASSIGN VALUES(uValue) CLASS Person_Properties
 RETURN self:FieldPut(4, uValue)
CLASS Person_Properties_ID INHERIT FIELDSPEC
METHOD Init() CLASS Person_Properties_ID
super:Init(HyperLabel{"ID","Id","","person_properties_ID"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Person_Properties_NAME INHERIT FIELDSPEC
METHOD Init() CLASS Person_Properties_NAME
super:Init(HyperLabel{"NAME","Name","","person_properties_NAME"},"C",30,0)

RETURN SELF
CLASS Person_Properties_TYPE INHERIT FIELDSPEC
METHOD Init() CLASS Person_Properties_TYPE
super:Init(HyperLabel{"TYPE","Type","","person_properties_TYPE"},"N",11,0)

RETURN SELF
CLASS Person_Properties_VALUES INHERIT FIELDSPEC
METHOD Init() CLASS Person_Properties_VALUES
super:Init(HyperLabel{"VALUES","Values","","person_properties_VALUES"},"M",10,0)

RETURN SELF
CLASS PersonType INHERIT SQLTable
ACCESS ABBRVTN CLASS PersonType
 RETURN self:FieldGet(3)
ASSIGN ABBRVTN(uValue) CLASS PersonType
 RETURN self:FieldPut(3, uValue)
ACCESS DESCRPTN CLASS PersonType
 RETURN self:FieldGet(2)
ASSIGN DESCRPTN(uValue) CLASS PersonType
 RETURN self:FieldPut(2, uValue)
ACCESS ID CLASS PersonType
 RETURN self:FieldGet(1)
ASSIGN ID(uValue) CLASS PersonType
 RETURN self:FieldPut(1, uValue)
METHOD Init( cTable, oConn ) CLASS PersonType
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`persontype`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_PersonType_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`ID`] , ;
   [`DESCRPTN`] , ;
   [`ABBRVTN`]   }, oConn )

oHyperLabel := HyperLabel{IDM_PERSONTYPE_NAME,  ;
   "PersonType",  ;
   ,  ;
   "PersonType" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=PersonType_ID{}
    self:SetDataField(1,DataField{[ID] ,oFS})
    oFS:=PersonType_DESCRPTN{}
    self:SetDataField(2,DataField{[DESCRPTN] ,oFS})
    oFS:=PersonType_ABBRVTN{}
    self:SetDataField(3,DataField{[ABBRVTN] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
CLASS PersonType_ABBRVTN INHERIT FIELDSPEC
METHOD Init() CLASS PersonType_ABBRVTN
super:Init(HyperLabel{"ABBRVTN","Abbrvtn","","persontype_ABBRVTN"},"C",3,0)

RETURN SELF
CLASS PersonType_DESCRPTN INHERIT FIELDSPEC
METHOD Init() CLASS PersonType_DESCRPTN
super:Init(HyperLabel{"DESCRPTN","Descrptn","","persontype_DESCRPTN"},"C",30,0)

RETURN SELF
CLASS PersonType_ID INHERIT FIELDSPEC
METHOD Init() CLASS PersonType_ID
super:Init(HyperLabel{"ID","Id","","persontype_ID"},"N",6,0)

RETURN SELF
CLASS Titles INHERIT SQLTable
ACCESS DESCRPTN CLASS Titles
 RETURN self:FieldGet(2)
ASSIGN DESCRPTN(uValue) CLASS Titles
 RETURN self:FieldPut(2, uValue)
ACCESS ID CLASS Titles
 RETURN self:FieldGet(1)
ASSIGN ID(uValue) CLASS Titles
 RETURN self:FieldPut(1, uValue)
METHOD Init( cTable, oConn ) CLASS Titles
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`titles`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_Titles_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`ID`] , ;
   [`DESCRPTN`]   }, oConn )

oHyperLabel := HyperLabel{IDM_TITLES_NAME,  ;
   "Titles",  ;
   ,  ;
   "Titles" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=Titles_ID{}
    self:SetDataField(1,DataField{[ID] ,oFS})
    oFS:=Titles_DESCRPTN{}
    self:SetDataField(2,DataField{[DESCRPTN] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
CLASS Titles_DESCRPTN INHERIT FIELDSPEC
METHOD Init() CLASS Titles_DESCRPTN
super:Init(HyperLabel{"DESCRPTN","Descrptn","","titles_DESCRPTN"},"C",12,0)

RETURN SELF
CLASS Titles_ID INHERIT FIELDSPEC
METHOD Init() CLASS Titles_ID
super:Init(HyperLabel{"ID","Id","","titles_ID"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
