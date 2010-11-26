CLASS BankAccount INHERIT SQLTable
ACCESS accid CLASS BankAccount
 RETURN self:FieldGet(2)
ASSIGN accid(uValue) CLASS BankAccount
 RETURN self:FieldPut(2, uValue)
ACCESS banknumber CLASS BankAccount
 RETURN self:FieldGet(1)
ASSIGN banknumber(uValue) CLASS BankAccount
 RETURN self:FieldPut(1, uValue)
ACCESS COMALL CLASS BankAccount
 RETURN self:FieldGet(7)
ASSIGN COMALL(uValue) CLASS BankAccount
 RETURN self:FieldPut(7, uValue)
ACCESS COMFL CLASS BankAccount
 RETURN self:FieldGet(6)
ASSIGN COMFL(uValue) CLASS BankAccount
 RETURN self:FieldPut(6, uValue)
ACCESS FGMLCODES CLASS BankAccount
 RETURN self:FieldGet(14)
ASSIGN FGMLCODES(uValue) CLASS BankAccount
 RETURN self:FieldPut(14, uValue)
ACCESS GIFTSALL CLASS BankAccount
 RETURN self:FieldGet(9)
ASSIGN GIFTSALL(uValue) CLASS BankAccount
 RETURN self:FieldPut(9, uValue)
METHOD Init( cTable, oConn ) CLASS BankAccount
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`bankaccount`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_BankAccount_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`banknumber`] , ;
   [`accid`] , ;
   [`usedforgifts`] , ;
   [`TELEBANKNG`] , ;
   [`TELEDATDIR`] , ;
   [`COMFL`] , ;
   [`COMALL`] , ;
   [`PO`] , ;
   [`GIFTSALL`] , ;
   [`OPENAC`] , ;
   [`OPENALL`] , ;
   [`PAYAHEAD`] , ;
   [`SINGLEDST`] , ;
   [`FGMLCODES`] , ;
   [`SYSCODOVER`]   }, oConn )

oHyperLabel := HyperLabel{IDM_BANKACCOUNT_NAME,  ;
   "BankAccount",  ;
   ,  ;
   "BankAccount" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=bankaccount_BANKNUMMER{}
    self:SetDataField(1,DataField{[banknumber] ,oFS})
    oFS:=bankaccount_REK{}
    self:SetDataField(2,DataField{[accid] ,oFS})
    oFS:=bankaccount_GIFTENIND{}
    self:SetDataField(3,DataField{[usedforgifts] ,oFS})
    oFS:=bankaccount_TELEBANKNG{}
    self:SetDataField(4,DataField{[TELEBANKNG] ,oFS})
    oFS:=bankaccount_TELEDATDIR{}
    self:SetDataField(5,DataField{[TELEDATDIR] ,oFS})
    oFS:=bankaccount_COMFL{}
    self:SetDataField(6,DataField{[COMFL] ,oFS})
    oFS:=bankaccount_COMALL{}
    self:SetDataField(7,DataField{[COMALL] ,oFS})
    oFS:=bankaccount_PO{}
    self:SetDataField(8,DataField{[PO] ,oFS})
    oFS:=bankaccount_GIFTSALL{}
    self:SetDataField(9,DataField{[GIFTSALL] ,oFS})
    oFS:=bankaccount_OPENAC{}
    self:SetDataField(10,DataField{[OPENAC] ,oFS})
    oFS:=bankaccount_OPENALL{}
    self:SetDataField(11,DataField{[OPENALL] ,oFS})
    oFS:=bankaccount_PAYAHEAD{}
    self:SetDataField(12,DataField{[PAYAHEAD] ,oFS})
    oFS:=bankaccount_SINGLEDST{}
    self:SetDataField(13,DataField{[SINGLEDST] ,oFS})
    oFS:=bankaccount_FGMLCODES{}
    self:SetDataField(14,DataField{[FGMLCODES] ,oFS})
    oFS:=bankaccount_SYSCODOVER{}
    self:SetDataField(15,DataField{[SYSCODOVER] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS OPENAC CLASS BankAccount
 RETURN self:FieldGet(10)
ASSIGN OPENAC(uValue) CLASS BankAccount
 RETURN self:FieldPut(10, uValue)
ACCESS OPENALL CLASS BankAccount
 RETURN self:FieldGet(11)
ASSIGN OPENALL(uValue) CLASS BankAccount
 RETURN self:FieldPut(11, uValue)
ACCESS PAYAHEAD CLASS BankAccount
 RETURN self:FieldGet(12)
ASSIGN PAYAHEAD(uValue) CLASS BankAccount
 RETURN self:FieldPut(12, uValue)
ACCESS PO CLASS BankAccount
 RETURN self:FieldGet(8)
ASSIGN PO(uValue) CLASS BankAccount
 RETURN self:FieldPut(8, uValue)
ACCESS SINGLEDST CLASS BankAccount
 RETURN self:FieldGet(13)
ASSIGN SINGLEDST(uValue) CLASS BankAccount
 RETURN self:FieldPut(13, uValue)
ACCESS SYSCODOVER CLASS BankAccount
 RETURN self:FieldGet(15)
ASSIGN SYSCODOVER(uValue) CLASS BankAccount
 RETURN self:FieldPut(15, uValue)
ACCESS TELEBANKNG CLASS BankAccount
 RETURN self:FieldGet(4)
ASSIGN TELEBANKNG(uValue) CLASS BankAccount
 RETURN self:FieldPut(4, uValue)
ACCESS TELEDATDIR CLASS BankAccount
 RETURN self:FieldGet(5)
ASSIGN TELEDATDIR(uValue) CLASS BankAccount
 RETURN self:FieldPut(5, uValue)
ACCESS usedforgifts CLASS BankAccount
 RETURN self:FieldGet(3)
ASSIGN usedforgifts(uValue) CLASS BankAccount
 RETURN self:FieldPut(3, uValue)
CLASS bankaccount_BANKNUMMER INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_BANKNUMMER
super:Init(HyperLabel{"banknumber","banknumber","","bankaccount_BANKNUMMER"},"C",25,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS bankaccount_COMALL INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_COMALL
super:Init(HyperLabel{"COMALL","Comall","","bankaccount_COMALL"},"N",3,0)

RETURN SELF
CLASS bankaccount_COMFL INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_COMFL
super:Init(HyperLabel{"COMFL","Comfl","","bankaccount_COMFL"},"N",3,0)

RETURN SELF
CLASS bankaccount_FGMLCODES INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_FGMLCODES
super:Init(HyperLabel{"FGMLCODES","Fgmlcodes","","bankaccount_FGMLCODES"},"C",30,0)

RETURN SELF
CLASS bankaccount_GIFTENIND INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_GIFTENIND
super:Init(HyperLabel{"usedforgifts","usedforgifts","","bankaccount_GIFTENIND"},"N",3,0)

RETURN SELF
CLASS bankaccount_GIFTSALL INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_GIFTSALL
super:Init(HyperLabel{"GIFTSALL","Giftsall","","bankaccount_GIFTSALL"},"N",3,0)

RETURN SELF
CLASS bankaccount_OPENAC INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_OPENAC
super:Init(HyperLabel{"OPENAC","Openac","","bankaccount_OPENAC"},"N",3,0)

RETURN SELF
CLASS bankaccount_OPENALL INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_OPENALL
super:Init(HyperLabel{"OPENALL","Openall","","bankaccount_OPENALL"},"N",3,0)

RETURN SELF
CLASS bankaccount_PAYAHEAD INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_PAYAHEAD
super:Init(HyperLabel{"PAYAHEAD","Payahead","","bankaccount_PAYAHEAD"},"N",11,0)

RETURN SELF
CLASS bankaccount_PO INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_PO
super:Init(HyperLabel{"PO","Po","","bankaccount_PO"},"N",3,0)

RETURN SELF
CLASS bankaccount_REK INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_REK
super:Init(HyperLabel{"accid","accid","","bankaccount_REK"},"N",11,0)

RETURN SELF
CLASS bankaccount_SINGLEDST INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_SINGLEDST
super:Init(HyperLabel{"SINGLEDST","Singledst","","bankaccount_SINGLEDST"},"N",11,0)

RETURN SELF
CLASS bankaccount_SYSCODOVER INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_SYSCODOVER
super:Init(HyperLabel{"SYSCODOVER","Syscodover","","bankaccount_SYSCODOVER"},"C",1,0)

RETURN SELF
CLASS bankaccount_TELEBANKNG INHERIT FIELDSPEC


METHOD Init() CLASS bankaccount_TELEBANKNG
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TELEBANKNG, "Telebankng", "", "bankaccount_TELEBANKNG" },  "L", 1, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS bankaccount_TELEDATDIR INHERIT FIELDSPEC
METHOD Init() CLASS bankaccount_TELEDATDIR
super:Init(HyperLabel{"TELEDATDIR","Teledatdir","","bankaccount_TELEDATDIR"},"C",40,0)

RETURN SELF
CLASS bankorder INHERIT SQLTable
ACCESS ACCNTFROM CLASS bankorder
 RETURN self:FieldGet(2)
ASSIGN ACCNTFROM(uValue) CLASS bankorder
 RETURN self:FieldPut(2, uValue)
ACCESS AMOUNT CLASS bankorder
 RETURN self:FieldGet(4)
ASSIGN AMOUNT(uValue) CLASS bankorder
 RETURN self:FieldPut(4, uValue)
ACCESS BANKNBRCRE CLASS bankorder
 RETURN self:FieldGet(3)
ASSIGN BANKNBRCRE(uValue) CLASS bankorder
 RETURN self:FieldPut(3, uValue)
ACCESS DATEDUE CLASS bankorder
 RETURN self:FieldGet(5)
ASSIGN DATEDUE(uValue) CLASS bankorder
 RETURN self:FieldPut(5, uValue)
ACCESS DATEPAYED CLASS bankorder
 RETURN self:FieldGet(6)
ASSIGN DATEPAYED(uValue) CLASS bankorder
 RETURN self:FieldPut(6, uValue)
ACCESS DESCRPTION CLASS bankorder
 RETURN self:FieldGet(7)
ASSIGN DESCRPTION(uValue) CLASS bankorder
 RETURN self:FieldPut(7, uValue)
ACCESS ID CLASS bankorder
 RETURN self:FieldGet(1)
ASSIGN ID(uValue) CLASS bankorder
 RETURN self:FieldPut(1, uValue)
ACCESS IDFROM CLASS bankorder
 RETURN self:FieldGet(8)
ASSIGN IDFROM(uValue) CLASS bankorder
 RETURN self:FieldPut(8, uValue)
METHOD Init( cTable, oConn ) CLASS bankorder
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`bankorder`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_bankorder_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`ID`] , ;
   [`ACCNTFROM`] , ;
   [`BANKNBRCRE`] , ;
   [`AMOUNT`] , ;
   [`DATEDUE`] , ;
   [`DATEPAYED`] , ;
   [`DESCRPTION`] , ;
   [`IDFROM`] , ;
   [`STORDRID`]   }, oConn )

oHyperLabel := HyperLabel{IDM_BANKORDER_NAME,  ;
   "bankorder",  ;
   ,  ;
   "bankorder" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=bankorder_ID{}
    self:SetDataField(1,DataField{[ID] ,oFS})
    oFS:=bankorder_ACCNTFROM{}
    self:SetDataField(2,DataField{[ACCNTFROM] ,oFS})
    oFS:=bankorder_BANKNBRCRE{}
    self:SetDataField(3,DataField{[BANKNBRCRE] ,oFS})
    oFS:=bankorder_AMOUNT{}
    self:SetDataField(4,DataField{[AMOUNT] ,oFS})
    oFS:=bankorder_DATEDUE{}
    self:SetDataField(5,DataField{[DATEDUE] ,oFS})
    oFS:=bankorder_DATEPAYED{}
    self:SetDataField(6,DataField{[DATEPAYED] ,oFS})
    oFS:=bankorder_DESCRPTION{}
    self:SetDataField(7,DataField{[DESCRPTION] ,oFS})
    oFS:=bankorder_IDFROM{}
    self:SetDataField(8,DataField{[IDFROM] ,oFS})
    oFS:=bankorder_STORDRID{}
    self:SetDataField(9,DataField{[STORDRID] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS STORDRID CLASS bankorder
 RETURN self:FieldGet(9)
ASSIGN STORDRID(uValue) CLASS bankorder
 RETURN self:FieldPut(9, uValue)
CLASS bankorder_ACCNTFROM INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_ACCNTFROM
super:Init(HyperLabel{"ACCNTFROM","Accntfrom","","bankorder_ACCNTFROM"},"N",11,0)

RETURN SELF
CLASS bankorder_AMOUNT INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_AMOUNT
super:Init(HyperLabel{"AMOUNT","Amount","","bankorder_AMOUNT"},"N",15,2)

RETURN SELF
CLASS bankorder_BANKNBRCRE INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_BANKNBRCRE
super:Init(HyperLabel{"BANKNBRCRE","Banknbrcre","","bankorder_BANKNBRCRE"},"C",25,0)

RETURN SELF
CLASS bankorder_DATEDUE INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_DATEDUE
super:Init(HyperLabel{"DATEDUE","Datedue","","bankorder_DATEDUE"},"D",10,0)

RETURN SELF
CLASS bankorder_DATEPAYED INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_DATEPAYED
super:Init(HyperLabel{"DATEPAYED","Datepayed","","bankorder_DATEPAYED"},"D",10,0)

RETURN SELF
CLASS bankorder_DESCRPTION INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_DESCRPTION
super:Init(HyperLabel{"DESCRPTION","Descrption","","bankorder_DESCRPTION"},"C",32,0)

RETURN SELF
CLASS bankorder_ID INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_ID
super:Init(HyperLabel{"ID","Id","","bankorder_ID"},"N",11,0)

RETURN SELF
CLASS bankorder_IDFROM INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_IDFROM
super:Init(HyperLabel{"IDFROM","Idfrom","","bankorder_IDFROM"},"N",11,0)

RETURN SELF
CLASS bankorder_STORDRID INHERIT FIELDSPEC
METHOD Init() CLASS bankorder_STORDRID
super:Init(HyperLabel{"STORDRID","Stordrid","","bankorder_STORDRID"},"N",11,0)

RETURN SELF
Define IDM_BANKACCOUNT_NAME := "BankAccount"
Define IDM_BankAccount_USERID := "parou��HgwЀTv"
Define IDM_BANKORDER_NAME := "bankorder"
Define IDM_bankorder_USERID := "parou��H�vЀtu"
