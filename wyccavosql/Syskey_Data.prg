Define IDM_SYSKEY_NAME := "SysKey"
Define IDM_SysKey_USERID := "parous…ew@™=w"
CLASS SysKey INHERIT SQLTable
METHOD Init( cTable, oConn ) CLASS SysKey
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`syskey`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_SysKey_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`SYSKEY_ID`] , ;
   [`VALUE`]   }, oConn )

oHyperLabel := HyperLabel{IDM_SYSKEY_NAME,  ;
   "SysKey",  ;
   ,  ;
   "SysKey" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=SysKey_SYSKEY_ID{}
    self:SetDataField(1,DataField{[SYSKEY_ID] ,oFS})
    oFS:=SysKey_VALUE{}
    self:SetDataField(2,DataField{[VALUE] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS SYSKEY_ID CLASS SysKey
 RETURN self:FieldGet(1)
ASSIGN SYSKEY_ID(uValue) CLASS SysKey
 RETURN self:FieldPut(1, uValue)
ACCESS VALUE CLASS SysKey
 RETURN self:FieldGet(2)
ASSIGN VALUE(uValue) CLASS SysKey
 RETURN self:FieldPut(2, uValue)
CLASS SysKey_SYSKEY_ID INHERIT FIELDSPEC
METHOD Init() CLASS SysKey_SYSKEY_ID
super:Init(HyperLabel{"SYSKEY_ID","Syskey Id","","syskey_SYSKEY_ID"},"C",10,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS SysKey_VALUE INHERIT FIELDSPEC
METHOD Init() CLASS SysKey_VALUE
super:Init(HyperLabel{"VALUE","Value","","syskey_VALUE"},"C",10,0)

RETURN SELF
