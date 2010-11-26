CLASS Department INHERIT SQLTable
ACCESS ASSACC1 CLASS Department
 RETURN self:FieldGet(8)
ASSIGN ASSACC1(uValue) CLASS Department
 RETURN self:FieldPut(8, uValue)
ACCESS ASSACC2 CLASS Department
 RETURN self:FieldGet(9)
ASSIGN ASSACC2(uValue) CLASS Department
 RETURN self:FieldPut(9, uValue)
ACCESS ASSACC3 CLASS Department
 RETURN self:FieldGet(10)
ASSIGN ASSACC3(uValue) CLASS Department
 RETURN self:FieldPut(10, uValue)
ACCESS DEPID CLASS Department
 RETURN self:FieldGet(1)
ASSIGN DEPID(uValue) CLASS Department
 RETURN self:FieldPut(1, uValue)
ACCESS DEPTMNTNBR CLASS Department
 RETURN self:FieldGet(3)
ASSIGN DEPTMNTNBR(uValue) CLASS Department
 RETURN self:FieldPut(3, uValue)
ACCESS DESCRIPTN CLASS Department
 RETURN self:FieldGet(2)
ASSIGN DESCRIPTN(uValue) CLASS Department
 RETURN self:FieldPut(2, uValue)
METHOD Init( cTable, oConn ) CLASS Department
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`department`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_Department_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`DEPID`] , ;
   [`DESCRIPTN`] , ;
   [`DEPTMNTNBR`] , ;
   [`NETASSET`] , ;
   [`PARENTDEP`] , ;
   [`persid`] , ;
   [`persid2`] , ;
   [`ASSACC1`] , ;
   [`ASSACC2`] , ;
   [`ASSACC3`] , ;
   [`IPCPROJECT`]   }, oConn )

oHyperLabel := HyperLabel{IDM_DEPARTMENT_NAME,  ;
   "Department",  ;
   ,  ;
   "Department" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=department_DEPID{}
    self:SetDataField(1,DataField{[DEPID] ,oFS})
    oFS:=department_DESCRIPTN{}
    self:SetDataField(2,DataField{[DESCRIPTN] ,oFS})
    oFS:=department_DEPTMNTNBR{}
    self:SetDataField(3,DataField{[DEPTMNTNBR] ,oFS})
    oFS:=department_NETASSET{}
    self:SetDataField(4,DataField{[NETASSET] ,oFS})
    oFS:=department_PARENTDEP{}
    self:SetDataField(5,DataField{[PARENTDEP] ,oFS})
    oFS:=department_CLN{}
    self:SetDataField(6,DataField{[persid] ,oFS})
    oFS:=department_CLN2{}
    self:SetDataField(7,DataField{[persid2] ,oFS})
    oFS:=department_ASSACC1{}
    self:SetDataField(8,DataField{[ASSACC1] ,oFS})
    oFS:=department_ASSACC2{}
    self:SetDataField(9,DataField{[ASSACC2] ,oFS})
    oFS:=department_ASSACC3{}
    self:SetDataField(10,DataField{[ASSACC3] ,oFS})
    oFS:=department_IPCPROJECT{}
    self:SetDataField(11,DataField{[IPCPROJECT] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS IPCPROJECT CLASS Department
 RETURN self:FieldGet(11)
ASSIGN IPCPROJECT(uValue) CLASS Department
 RETURN self:FieldPut(11, uValue)
ACCESS NETASSET CLASS Department
 RETURN self:FieldGet(4)
ASSIGN NETASSET(uValue) CLASS Department
 RETURN self:FieldPut(4, uValue)
ACCESS PARENTDEP CLASS Department
 RETURN self:FieldGet(5)
ASSIGN PARENTDEP(uValue) CLASS Department
 RETURN self:FieldPut(5, uValue)
ACCESS persid2 CLASS Department
 RETURN self:FieldGet(7)
ASSIGN persid2(uValue) CLASS Department
 RETURN self:FieldPut(7, uValue)
ACCESS persid CLASS Department
 RETURN self:FieldGet(6)
ASSIGN persid(uValue) CLASS Department
 RETURN self:FieldPut(6, uValue)
CLASS department_ASSACC1 INHERIT FIELDSPEC
METHOD Init() CLASS department_ASSACC1
super:Init(HyperLabel{"ASSACC1","Assacc1","","department_ASSACC1"},"N",11,0)

RETURN SELF
CLASS department_ASSACC2 INHERIT FIELDSPEC
METHOD Init() CLASS department_ASSACC2
super:Init(HyperLabel{"ASSACC2","Assacc2","","department_ASSACC2"},"N",11,0)

RETURN SELF
CLASS department_ASSACC3 INHERIT FIELDSPEC
METHOD Init() CLASS department_ASSACC3
super:Init(HyperLabel{"ASSACC3","Assacc3","","department_ASSACC3"},"N",11,0)

RETURN SELF
CLASS department_CLN INHERIT FIELDSPEC
CLASS department_CLN2 INHERIT FIELDSPEC
METHOD Init() CLASS department_CLN2
super:Init(HyperLabel{"persid2","persid2","","department_CLN2"},"N",11,0)

RETURN SELF
METHOD Init() CLASS department_CLN
super:Init(HyperLabel{"persid","persid","","department_CLN"},"N",11,0)

RETURN SELF
CLASS department_DEPID INHERIT FIELDSPEC
METHOD Init() CLASS department_DEPID
super:Init(HyperLabel{"DEPID","Depid","","department_DEPID"},"N",11,0)

RETURN SELF
CLASS department_DEPTMNTNBR INHERIT FIELDSPEC
METHOD Init() CLASS department_DEPTMNTNBR
super:Init(HyperLabel{"DEPTMNTNBR","Deptmntnbr","","department_DEPTMNTNBR"},"C",6,0)

RETURN SELF
CLASS department_DESCRIPTN INHERIT FIELDSPEC
METHOD Init() CLASS department_DESCRIPTN
super:Init(HyperLabel{"DESCRIPTN","Descriptn","","department_DESCRIPTN"},"C",40,0)

RETURN SELF
CLASS department_IPCPROJECT INHERIT FIELDSPEC
METHOD Init() CLASS department_IPCPROJECT
super:Init(HyperLabel{"IPCPROJECT","Ipcproject","","department_IPCPROJECT"},"N",11,0)

RETURN SELF
CLASS department_NETASSET INHERIT FIELDSPEC
METHOD Init() CLASS department_NETASSET
super:Init(HyperLabel{"NETASSET","Netasset","","department_NETASSET"},"N",11,0)

RETURN SELF
CLASS department_PARENTDEP INHERIT FIELDSPEC
METHOD Init() CLASS department_PARENTDEP
super:Init(HyperLabel{"PARENTDEP","Parentdep","","department_PARENTDEP"},"N",11,0)

RETURN SELF
Define IDM_DEPARTMENT_NAME := "Department"
Define IDM_Department_USERID := "parouÿÐHgwÐ€Tv"
