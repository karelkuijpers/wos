CLASS Bank INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Bank
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Bank, "Bank account", "Number of bankaccount", "" },  "C", 25, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS DistributionInstruction INHERIT SQLTable
ACCESS accid CLASS DistributionInstruction
 RETURN self:FieldGet(1)
ASSIGN accid(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(1, uValue)
ACCESS AMNTSND CLASS DistributionInstruction
 RETURN self:FieldGet(11)
ASSIGN AMNTSND(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(11, uValue)
ACCESS CHECKSAVE CLASS DistributionInstruction
 RETURN self:FieldGet(14)
ASSIGN CHECKSAVE(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(14, uValue)
ACCESS CURRENCY CLASS DistributionInstruction
 RETURN self:FieldGet(9)
ASSIGN CURRENCY(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(9, uValue)
ACCESS DESCRPTN CLASS DistributionInstruction
 RETURN self:FieldGet(8)
ASSIGN DESCRPTN(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(8, uValue)
ACCESS DESTACC CLASS DistributionInstruction
 RETURN self:FieldGet(3)
ASSIGN DESTACC(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(3, uValue)
ACCESS DESTAMT CLASS DistributionInstruction
 RETURN self:FieldGet(6)
ASSIGN DESTAMT(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(6, uValue)
ACCESS DESTPP CLASS DistributionInstruction
 RETURN self:FieldGet(4)
ASSIGN DESTPP(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(4, uValue)
ACCESS DESTTYP CLASS DistributionInstruction
 RETURN self:FieldGet(5)
ASSIGN DESTTYP(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(5, uValue)
ACCESS DFIA CLASS DistributionInstruction
 RETURN self:FieldGet(13)
ASSIGN DFIA(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(13, uValue)
ACCESS DFIR CLASS DistributionInstruction
 RETURN self:FieldGet(12)
ASSIGN DFIR(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(12, uValue)
ACCESS DISABLED CLASS DistributionInstruction
 RETURN self:FieldGet(10)
ASSIGN DISABLED(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(10, uValue)
METHOD Init( cTable, oConn ) CLASS DistributionInstruction
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`distributioninstruction`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_DistributionInstruction_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`accid`] , ;
   [`SEQNBR`] , ;
   [`DESTACC`] , ;
   [`DESTPP`] , ;
   [`DESTTYP`] , ;
   [`DESTAMT`] , ;
   [`LSTDATE`] , ;
   [`DESCRPTN`] , ;
   [`CURRENCY`] , ;
   [`DISABLED`] , ;
   [`AMNTSND`] , ;
   [`DFIR`] , ;
   [`DFIA`] , ;
   [`CHECKSAVE`]   }, oConn )

oHyperLabel := HyperLabel{IDM_DISTRIBUTIONINSTRUCTION_NAME,  ;
   "DistributionInstruction",  ;
   ,  ;
   "DistributionInstruction" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    self:SetPrimaryKey(2)
    oFS:=DistributionInstruction_REK{}
    self:SetDataField(1,DataField{[accid] ,oFS})
    oFS:=DistributionInstruction_SEQNBR{}
    self:SetDataField(2,DataField{[SEQNBR] ,oFS})
    oFS:=DistributionInstruction_DESTACC{}
    self:SetDataField(3,DataField{[DESTACC] ,oFS})
    oFS:=DistributionInstruction_DESTPP{}
    self:SetDataField(4,DataField{[DESTPP] ,oFS})
    oFS:=DistributionInstruction_DESTTYP{}
    self:SetDataField(5,DataField{[DESTTYP] ,oFS})
    oFS:=DistributionInstruction_DESTAMT{}
    self:SetDataField(6,DataField{[DESTAMT] ,oFS})
    oFS:=DistributionInstruction_LSTDATE{}
    self:SetDataField(7,DataField{[LSTDATE] ,oFS})
    oFS:=DistributionInstruction_DESCRPTN{}
    self:SetDataField(8,DataField{[DESCRPTN] ,oFS})
    oFS:=DistributionInstruction_CURRENCY{}
    self:SetDataField(9,DataField{[CURRENCY] ,oFS})
    oFS:=DistributionInstruction_DISABLED{}
    self:SetDataField(10,DataField{[DISABLED] ,oFS})
    oFS:=DistributionInstruction_AMNTSND{}
    self:SetDataField(11,DataField{[AMNTSND] ,oFS})
    oFS:=DistributionInstruction_DFIR{}
    self:SetDataField(12,DataField{[DFIR] ,oFS})
    oFS:=DistributionInstruction_DFIA{}
    self:SetDataField(13,DataField{[DFIA] ,oFS})
    oFS:=DistributionInstruction_CHECKSAVE{}
    self:SetDataField(14,DataField{[CHECKSAVE] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS LSTDATE CLASS DistributionInstruction
 RETURN self:FieldGet(7)
ASSIGN LSTDATE(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(7, uValue)
ACCESS SEQNBR CLASS DistributionInstruction
 RETURN self:FieldGet(2)
ASSIGN SEQNBR(uValue) CLASS DistributionInstruction
 RETURN self:FieldPut(2, uValue)
CLASS DistributionInstruction_AMNTSND INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_AMNTSND
super:Init(HyperLabel{"AMNTSND","Amntsnd","","distributioninstruction_AMNTSND"},"N",12,2)

RETURN SELF
CLASS DistributionInstruction_CHECKSAVE INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_CHECKSAVE
super:Init(HyperLabel{"CHECKSAVE","Checksave","","distributioninstruction_CHECKSAVE"},"C",1,0)

RETURN SELF
CLASS DistributionInstruction_CURRENCY INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_CURRENCY
super:Init(HyperLabel{"CURRENCY","Currency","","distributioninstruction_CURRENCY"},"N",3,0)

RETURN SELF
CLASS DistributionInstruction_DESCRPTN INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DESCRPTN
super:Init(HyperLabel{"DESCRPTN","Descrptn","","distributioninstruction_DESCRPTN"},"C",70,0)

RETURN SELF
CLASS DistributionInstruction_DESTACC INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DESTACC
super:Init(HyperLabel{"DESTACC","Destacc","","distributioninstruction_DESTACC"},"C",70,0)

RETURN SELF
CLASS DistributionInstruction_DESTAMT INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DESTAMT
super:Init(HyperLabel{"DESTAMT","Destamt","","distributioninstruction_DESTAMT"},"N",12,2)

RETURN SELF
CLASS DistributionInstruction_DESTPP INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DESTPP
super:Init(HyperLabel{"DESTPP","Destpp","","distributioninstruction_DESTPP"},"C",3,0)

RETURN SELF
CLASS DistributionInstruction_DESTTYP INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DESTTYP
super:Init(HyperLabel{"DESTTYP","Desttyp","","distributioninstruction_DESTTYP"},"N",11,0)

RETURN SELF
CLASS DistributionInstruction_DFIA INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DFIA
super:Init(HyperLabel{"DFIA","Dfia","","distributioninstruction_DFIA"},"C",17,0)

RETURN SELF
CLASS DistributionInstruction_DFIR INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DFIR
super:Init(HyperLabel{"DFIR","Dfir","","distributioninstruction_DFIR"},"C",9,0)

RETURN SELF
CLASS DistributionInstruction_DISABLED INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DISABLED
super:Init(HyperLabel{"DISABLED","Disabled","","distributioninstruction_DISABLED"},"N",3,0)

RETURN SELF
CLASS DistributionInstruction_LSTDATE INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_LSTDATE
super:Init(HyperLabel{"LSTDATE","Lstdate","","distributioninstruction_LSTDATE"},"D",10,0)

RETURN SELF
CLASS DistributionInstruction_REK INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_REK
super:Init(HyperLabel{"accid","accid","","distributioninstruction_REK"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS DistributionInstruction_SEQNBR INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_SEQNBR
super:Init(HyperLabel{"SEQNBR","Seqnbr","","distributioninstruction_SEQNBR"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
Define IDM_DISTRIBUTIONINSTRUCTION_NAME := "DistributionInstruction"
Define IDM_DistributionInstruction_USERID := "parouÿ…ºw@™Ðw"
Define IDM_MEMBERS_NAME := "Members"
Define IDM_Members_USERID := "parous…ºw@™Ðw"
CLASS Members INHERIT SQLTable
ACCESS accid CLASS Members
 RETURN self:FieldGet(1)
ASSIGN accid(uValue) CLASS Members
 RETURN self:FieldPut(1, uValue)
ACCESS AOW CLASS Members
 RETURN self:FieldGet(6)
ASSIGN AOW(uValue) CLASS Members
 RETURN self:FieldPut(6, uValue)
ACCESS CO CLASS Members
 RETURN self:FieldGet(8)
ASSIGN CO(uValue) CLASS Members
 RETURN self:FieldPut(8, uValue)
ACCESS CONTACT CLASS Members
 RETURN self:FieldGet(13)
ASSIGN CONTACT(uValue) CLASS Members
 RETURN self:FieldPut(13, uValue)
ACCESS GRADE CLASS Members
 RETURN self:FieldGet(9)
ASSIGN GRADE(uValue) CLASS Members
 RETURN self:FieldPut(9, uValue)
ACCESS HAS CLASS Members
 RETURN self:FieldGet(5)
ASSIGN HAS(uValue) CLASS Members
 RETURN self:FieldPut(5, uValue)
ACCESS HOMEACC CLASS Members
 RETURN self:FieldGet(11)
ASSIGN HOMEACC(uValue) CLASS Members
 RETURN self:FieldPut(11, uValue)
ACCESS HOMEPP CLASS Members
 RETURN self:FieldGet(10)
ASSIGN HOMEPP(uValue) CLASS Members
 RETURN self:FieldPut(10, uValue)
ACCESS householdid CLASS Members
 RETURN self:FieldGet(4)
ASSIGN householdid(uValue) CLASS Members
 RETURN self:FieldPut(4, uValue)
METHOD Init( cTable, oConn ) CLASS Members
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`member`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_Members_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`accid`] , ;
   [`persid`] , ;
   [`REK1`] , ;
   [`householdid`] , ;
   [`HAS`] , ;
   [`AOW`] , ;
   [`ZKV`] , ;
   [`CO`] , ;
   [`GRADE`] , ;
   [`HOMEPP`] , ;
   [`HOMEACC`] , ;
   [`OFFCRATE`] , ;
   [`CONTACT`] , ;
   [`RPTDEST`]   }, oConn )

oHyperLabel := HyperLabel{IDM_MEMBERS_NAME,  ;
   "Members",  ;
   ,  ;
   "Members" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=Members_REK{}
    self:SetDataField(1,DataField{[accid] ,oFS})
    oFS:=Members_CLN{}
    self:SetDataField(2,DataField{[persid] ,oFS})
    oFS:=Members_REK1{}
    self:SetDataField(3,DataField{[REK1] ,oFS})
    oFS:=Members_HBN{}
    self:SetDataField(4,DataField{[householdid] ,oFS})
    oFS:=Members_HAS{}
    self:SetDataField(5,DataField{[HAS] ,oFS})
    oFS:=Members_AOW{}
    self:SetDataField(6,DataField{[AOW] ,oFS})
    oFS:=Members_ZKV{}
    self:SetDataField(7,DataField{[ZKV] ,oFS})
    oFS:=Members_CO{}
    self:SetDataField(8,DataField{[CO] ,oFS})
    oFS:=Members_GRADE{}
    self:SetDataField(9,DataField{[GRADE] ,oFS})
    oFS:=Members_HOMEPP{}
    self:SetDataField(10,DataField{[HOMEPP] ,oFS})
    oFS:=Members_HOMEACC{}
    self:SetDataField(11,DataField{[HOMEACC] ,oFS})
    oFS:=Members_OFFCRATE{}
    self:SetDataField(12,DataField{[OFFCRATE] ,oFS})
    oFS:=Members_CONTACT{}
    self:SetDataField(13,DataField{[CONTACT] ,oFS})
    oFS:=Members_RPTDEST{}
    self:SetDataField(14,DataField{[RPTDEST] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS OFFCRATE CLASS Members
 RETURN self:FieldGet(12)
ASSIGN OFFCRATE(uValue) CLASS Members
 RETURN self:FieldPut(12, uValue)
ACCESS persid CLASS Members
 RETURN self:FieldGet(2)
ASSIGN persid(uValue) CLASS Members
 RETURN self:FieldPut(2, uValue)
ACCESS REK1 CLASS Members
 RETURN self:FieldGet(3)
ASSIGN REK1(uValue) CLASS Members
 RETURN self:FieldPut(3, uValue)
ACCESS RPTDEST CLASS Members
 RETURN self:FieldGet(14)
ASSIGN RPTDEST(uValue) CLASS Members
 RETURN self:FieldPut(14, uValue)
ACCESS ZKV CLASS Members
 RETURN self:FieldGet(7)
ASSIGN ZKV(uValue) CLASS Members
 RETURN self:FieldPut(7, uValue)
CLASS Members_AOW INHERIT FIELDSPEC
METHOD Init() CLASS Members_AOW
super:Init(HyperLabel{"AOW","Aow","","member_AOW"},"N",8,2)

RETURN SELF
CLASS Members_CLN INHERIT FIELDSPEC
METHOD Init() CLASS Members_CLN
super:Init(HyperLabel{"persid","persid","","member_CLN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Members_CO INHERIT FIELDSPEC
METHOD Init() CLASS Members_CO
super:Init(HyperLabel{"CO","Co","","member_CO"},"C",1,0)

RETURN SELF
CLASS Members_CONTACT INHERIT FIELDSPEC
METHOD Init() CLASS Members_CONTACT
super:Init(HyperLabel{"CONTACT","Contact","","member_CONTACT"},"N",11,0)

RETURN SELF
CLASS Members_GRADE INHERIT FIELDSPEC
METHOD Init() CLASS Members_GRADE
super:Init(HyperLabel{"GRADE","Grade","","member_GRADE"},"C",6,0)

RETURN SELF
CLASS Members_HAS INHERIT FIELDSPEC
METHOD Init() CLASS Members_HAS
super:Init(HyperLabel{"HAS","Has","","member_HAS"},"N",3,0)

RETURN SELF
CLASS Members_HBN INHERIT FIELDSPEC
METHOD Init() CLASS Members_HBN
super:Init(HyperLabel{"householdid","householdid","","member_HBN"},"C",20,0)

RETURN SELF
CLASS Members_HOMEACC INHERIT FIELDSPEC
METHOD Init() CLASS Members_HOMEACC
super:Init(HyperLabel{"HOMEACC","Homeacc","","member_HOMEACC"},"C",70,0)

RETURN SELF
CLASS Members_HOMEPP INHERIT FIELDSPEC
METHOD Init() CLASS Members_HOMEPP
super:Init(HyperLabel{"HOMEPP","Homepp","","member_HOMEPP"},"C",3,0)

RETURN SELF
CLASS Members_OFFCRATE INHERIT FIELDSPEC
METHOD Init() CLASS Members_OFFCRATE
super:Init(HyperLabel{"OFFCRATE","Offcrate","","member_OFFCRATE"},"C",1,0)

RETURN SELF
CLASS Members_REK INHERIT FIELDSPEC
CLASS Members_REK1 INHERIT FIELDSPEC
METHOD Init() CLASS Members_REK1
super:Init(HyperLabel{"REK1","Rek1","","member_REK1"},"N",11,0)

RETURN SELF
METHOD Init() CLASS Members_REK
super:Init(HyperLabel{"accid","accid","","member_REK"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Members_RPTDEST INHERIT FIELDSPEC
METHOD Init() CLASS Members_RPTDEST
super:Init(HyperLabel{"RPTDEST","Rptdest","","member_RPTDEST"},"N",11,0)

RETURN SELF
CLASS Members_ZKV INHERIT FIELDSPEC
METHOD Init() CLASS Members_ZKV
super:Init(HyperLabel{"ZKV","Zkv","","member_ZKV"},"N",8,2)

RETURN SELF
