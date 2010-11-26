CLASS DueAmount INHERIT SQLTable
ACCESS accid CLASS DueAmount
 RETURN self:FieldGet(6)
ASSIGN accid(uValue) CLASS DueAmount
 RETURN self:FieldPut(6, uValue)
ACCESS AmountRecvd CLASS DueAmount
 RETURN self:FieldGet(5)
ASSIGN AmountRecvd(uValue) CLASS DueAmount
 RETURN self:FieldPut(5, uValue)
ACCESS BEDRAGFAKT CLASS DueAmount
 RETURN self:FieldGet(4)
ASSIGN BEDRAGFAKT(uValue) CLASS DueAmount
 RETURN self:FieldPut(4, uValue)
ACCESS category CLASS DueAmount
 RETURN self:FieldGet(10)
ASSIGN category(uValue) CLASS DueAmount
 RETURN self:FieldPut(10, uValue)
ACCESS datelstreminder CLASS DueAmount
 RETURN self:FieldGet(7)
ASSIGN datelstreminder(uValue) CLASS DueAmount
 RETURN self:FieldPut(7, uValue)
METHOD Init( cTable, oConn ) CLASS DueAmount
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`dueamount`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_DueAmount_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`persid`] , ;
   [`invoicedate`] , ;
   [`seqnr`] , ;
   [`BEDRAGFAKT`] , ;
   [`AmountRecvd`] , ;
   [`accid`] , ;
   [`datelstreminder`] , ;
   [`ReminderCnt`] , ;
   [`PAYMETHOD`] , ;
   [`category`]   }, oConn )

oHyperLabel := HyperLabel{IDM_DUEAMOUNT_NAME,  ;
   "DueAmount",  ;
   ,  ;
   "DueAmount" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    self:SetPrimaryKey(2)
    self:SetPrimaryKey(3)
    oFS:=DueAmount_CLN{}
    self:SetDataField(1,DataField{[persid] ,oFS})
    oFS:=DueAmount_FAKTDAT{}
    self:SetDataField(2,DataField{[invoicedate] ,oFS})
    oFS:=DueAmount_VOLGNR{}
    self:SetDataField(3,DataField{[seqnr] ,oFS})
    oFS:=DueAmount_BEDRAGFAKT{}
    self:SetDataField(4,DataField{[BEDRAGFAKT] ,oFS})
    oFS:=DueAmount_BEDRAGONTV{}
    self:SetDataField(5,DataField{[AmountRecvd] ,oFS})
    oFS:=DueAmount_REK{}
    self:SetDataField(6,DataField{[accid] ,oFS})
    oFS:=DueAmount_DATLTSAANM{}
    self:SetDataField(7,DataField{[datelstreminder] ,oFS})
    oFS:=DueAmount_AANTRAPPEL{}
    self:SetDataField(8,DataField{[ReminderCnt] ,oFS})
    oFS:=DueAmount_PAYMETHOD{}
    self:SetDataField(9,DataField{[PAYMETHOD] ,oFS})
    oFS:=DueAmount_SOORT{}
    self:SetDataField(10,DataField{[category] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS invoicedate CLASS DueAmount
 RETURN self:FieldGet(2)
ASSIGN invoicedate(uValue) CLASS DueAmount
 RETURN self:FieldPut(2, uValue)
ACCESS PAYMETHOD CLASS DueAmount
 RETURN self:FieldGet(9)
ASSIGN PAYMETHOD(uValue) CLASS DueAmount
 RETURN self:FieldPut(9, uValue)
ACCESS persid CLASS DueAmount
 RETURN self:FieldGet(1)
ASSIGN persid(uValue) CLASS DueAmount
 RETURN self:FieldPut(1, uValue)
ACCESS ReminderCnt CLASS DueAmount
 RETURN self:FieldGet(8)
ASSIGN ReminderCnt(uValue) CLASS DueAmount
 RETURN self:FieldPut(8, uValue)
ACCESS seqnr CLASS DueAmount
 RETURN self:FieldGet(3)
ASSIGN seqnr(uValue) CLASS DueAmount
 RETURN self:FieldPut(3, uValue)
CLASS DueAmount_AANTRAPPEL INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_AANTRAPPEL
super:Init(HyperLabel{"ReminderCnt","ReminderCnt","","dueamnt_AANTRAPPEL"},"N",11,0)

RETURN SELF
CLASS DueAmount_BEDRAGFAKT INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_BEDRAGFAKT
super:Init(HyperLabel{"BEDRAGFAKT","Bedragfakt","","dueamnt_BEDRAGFAKT"},"N",13,2)

RETURN SELF
CLASS DueAmount_BEDRAGONTV INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_BEDRAGONTV
super:Init(HyperLabel{"AmountRecvd","AmountRecvd","","dueamnt_BEDRAGONTV"},"N",13,2)

RETURN SELF
CLASS DueAmount_CLN INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_CLN
super:Init(HyperLabel{"persid","persid","","dueamnt_CLN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS DueAmount_DATLTSAANM INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_DATLTSAANM
super:Init(HyperLabel{"datelstreminder","datelstreminder","","dueamnt_DATLTSAANM"},"D",10,0)

RETURN SELF
CLASS DueAmount_FAKTDAT INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_FAKTDAT
super:Init(HyperLabel{"invoicedate","invoicedate","","dueamnt_FAKTDAT"},"D",10,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS DueAmount_PAYMETHOD INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_PAYMETHOD
super:Init(HyperLabel{"PAYMETHOD","Paymethod","","dueamnt_PAYMETHOD"},"C",1,0)

RETURN SELF
CLASS DueAmount_REK INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_REK
super:Init(HyperLabel{"accid","accid","","dueamnt_REK"},"N",11,0)

RETURN SELF
CLASS DueAmount_SOORT INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_SOORT
super:Init(HyperLabel{"category","category","","dueamnt_SOORT"},"C",1,0)

RETURN SELF
CLASS DueAmount_VOLGNR INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_VOLGNR
super:Init(HyperLabel{"seqnr","seqnr","","dueamnt_VOLGNR"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
Define IDM_DUEAMOUNT_NAME := "DueAmount"
Define IDM_DueAmount_USERID := "parous…ºw@™Ðw"
