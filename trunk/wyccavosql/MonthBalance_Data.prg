CLASS AccountBalanceYear INHERIT SQLTable
ACCESS accid CLASS AccountBalanceYear
 RETURN self:FieldGet(1)
ASSIGN accid(uValue) CLASS AccountBalanceYear
 RETURN self:FieldPut(1, uValue)
ACCESS CURRENCY CLASS AccountBalanceYear
 RETURN self:FieldGet(6)
ASSIGN CURRENCY(uValue) CLASS AccountBalanceYear
 RETURN self:FieldPut(6, uValue)
METHOD Init( cTable, oConn ) CLASS AccountBalanceYear
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`accountbalanceyear`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_AccountBalanceYear_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`accid`] , ;
   [`YEARSTART`] , ;
   [`MONTHSTART`] , ;
   [`SVJD`] , ;
   [`SVJC`] , ;
   [`CURRENCY`]   }, oConn )

oHyperLabel := HyperLabel{IDM_ACCOUNTBALANCEYEAR_NAME,  ;
   "AccountBalanceYear",  ;
   ,  ;
   "AccountBalanceYear" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    self:SetPrimaryKey(2)
    self:SetPrimaryKey(3)
    self:SetPrimaryKey(6)
    oFS:=AccountBalanceYear_REK{}
    self:SetDataField(1,DataField{[accid] ,oFS})
    oFS:=AccountBalanceYear_YEARSTART{}
    self:SetDataField(2,DataField{[YEARSTART] ,oFS})
    oFS:=AccountBalanceYear_MONTHSTART{}
    self:SetDataField(3,DataField{[MONTHSTART] ,oFS})
    oFS:=AccountBalanceYear_SVJD{}
    self:SetDataField(4,DataField{[SVJD] ,oFS})
    oFS:=AccountBalanceYear_SVJC{}
    self:SetDataField(5,DataField{[SVJC] ,oFS})
    oFS:=AccountBalanceYear_CURRENCY{}
    self:SetDataField(6,DataField{[CURRENCY] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS MONTHSTART CLASS AccountBalanceYear
 RETURN self:FieldGet(3)
ASSIGN MONTHSTART(uValue) CLASS AccountBalanceYear
 RETURN self:FieldPut(3, uValue)
ACCESS SVJC CLASS AccountBalanceYear
 RETURN self:FieldGet(5)
ASSIGN SVJC(uValue) CLASS AccountBalanceYear
 RETURN self:FieldPut(5, uValue)
ACCESS SVJD CLASS AccountBalanceYear
 RETURN self:FieldGet(4)
ASSIGN SVJD(uValue) CLASS AccountBalanceYear
 RETURN self:FieldPut(4, uValue)
ACCESS YEARSTART CLASS AccountBalanceYear
 RETURN self:FieldGet(2)
ASSIGN YEARSTART(uValue) CLASS AccountBalanceYear
 RETURN self:FieldPut(2, uValue)
CLASS AccountBalanceYear_CURRENCY INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_CURRENCY
super:Init(HyperLabel{"CURRENCY","Currency","","accountbalanceyear_CURRENCY"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS AccountBalanceYear_MONTHSTART INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_MONTHSTART
super:Init(HyperLabel{"MONTHSTART","Monthstart","","accountbalanceyear_MONTHSTART"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS AccountBalanceYear_REK INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_REK
super:Init(HyperLabel{"accid","accid","","accountbalanceyear_REK"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS AccountBalanceYear_SVJC INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_SVJC
super:Init(HyperLabel{"SVJC","Svjc","","accountbalanceyear_SVJC"},"N",20,2)

RETURN SELF
CLASS AccountBalanceYear_SVJD INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_SVJD
super:Init(HyperLabel{"SVJD","Svjd","","accountbalanceyear_SVJD"},"N",20,2)

RETURN SELF
CLASS AccountBalanceYear_YEARSTART INHERIT FIELDSPEC
METHOD Init() CLASS AccountBalanceYear_YEARSTART
super:Init(HyperLabel{"YEARSTART","Yearstart","","accountbalanceyear_YEARSTART"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS BalanceYear INHERIT SQLTable
METHOD Init( cTable, oConn ) CLASS BalanceYear
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`balanceyear`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_BalanceYear_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`YEARSTART`] , ;
   [`MONTHSTART`] , ;
   [`YEARLENGTH`] , ;
   [`STATE`]   }, oConn )

oHyperLabel := HyperLabel{IDM_BALANCEYEAR_NAME,  ;
   "BalanceYear",  ;
   ,  ;
   "BalanceYear" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    self:SetPrimaryKey(2)
    oFS:=balanceyear_YEARSTART{}
    self:SetDataField(1,DataField{[YEARSTART] ,oFS})
    oFS:=balanceyear_MONTHSTART{}
    self:SetDataField(2,DataField{[MONTHSTART] ,oFS})
    oFS:=balanceyear_YEARLENGTH{}
    self:SetDataField(3,DataField{[YEARLENGTH] ,oFS})
    oFS:=balanceyear_STATE{}
    self:SetDataField(4,DataField{[STATE] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS MONTHSTART CLASS BalanceYear
 RETURN self:FieldGet(2)
ASSIGN MONTHSTART(uValue) CLASS BalanceYear
 RETURN self:FieldPut(2, uValue)
ACCESS STATE CLASS BalanceYear
 RETURN self:FieldGet(4)
ASSIGN STATE(uValue) CLASS BalanceYear
 RETURN self:FieldPut(4, uValue)
ACCESS test CLASS BalanceYear
 RETURN self:FieldGet(5)
ASSIGN test(uValue) CLASS BalanceYear
 RETURN self:FieldPut(5, uValue)
ACCESS YEARLENGTH CLASS BalanceYear
 RETURN self:FieldGet(3)
ASSIGN YEARLENGTH(uValue) CLASS BalanceYear
 RETURN self:FieldPut(3, uValue)
ACCESS YEARSTART CLASS BalanceYear
 RETURN self:FieldGet(1)
ASSIGN YEARSTART(uValue) CLASS BalanceYear
 RETURN self:FieldPut(1, uValue)
CLASS balanceyear_MONTHSTART INHERIT FIELDSPEC
METHOD Init() CLASS balanceyear_MONTHSTART
super:Init(HyperLabel{"MONTHSTART","Monthstart","","balanceyear_MONTHSTART"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS balanceyear_STATE INHERIT FIELDSPEC
METHOD Init() CLASS balanceyear_STATE
super:Init(HyperLabel{"STATE","State","","balanceyear_STATE"},"C",1,0)

RETURN SELF
CLASS balanceyear_test INHERIT FIELDSPEC
METHOD Init() CLASS balanceyear_test
super:Init(HyperLabel{"test","Test","","balanceyear_test"},"N",20,2)
self:SetRequired(.T.,)

RETURN SELF
CLASS balanceyear_YEARLENGTH INHERIT FIELDSPEC
METHOD Init() CLASS balanceyear_YEARLENGTH
super:Init(HyperLabel{"YEARLENGTH","Yearlength","","balanceyear_YEARLENGTH"},"N",6,0)

RETURN SELF
CLASS balanceyear_YEARSTART INHERIT FIELDSPEC
METHOD Init() CLASS balanceyear_YEARSTART
super:Init(HyperLabel{"YEARSTART","Yearstart","","balanceyear_YEARSTART"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
Define IDM_ACCOUNTBALANCEYEAR_NAME := "AccountBalanceYear"
Define IDM_AccountBalanceYear_USERID := "parous…ºw@™Ðw"
Define IDM_BALANCEYEAR_NAME := "BalanceYear"
Define IDM_BalanceYear_USERID := "parouÿ…ºw@™Ðw"
Define IDM_MBALANCE_NAME := "MBalance"
Define IDM_MBalance_USERID := "parous…ºw@™Ðw"
CLASS MBalance INHERIT SQLTable
	//USER CODE STARTS HERE (do NOT remove this line) 
	PROTECT oRubr as BalanceItem
	EXPORT oTrans as TransHistory
	PROTECT oBalanceYear as BalanceYear
	PROTECT oAccBalYear as AccountBalanceYear 
	protect oAcc as Account
	protect oMBal as MBalance
	* results of GetBalYear:
	EXPORT YEARSTART, MONTHSTART, YEAREND, MONTHEND as int  // start and end of corresponding balance year
	* Result from GetBalance are returned here
	EXPORT per_deb as FLOAT  //berekende debet saldo over periode
	EXPORT per_cre as FLOAT   //berekende credit saldo over periode
	EXPORT begin_deb as FLOAT  //berekende begin debet saldo
	EXPORT begin_cre as FLOAT   //berekende begin credit saldo
	EXPORT vorig_deb as FLOAT //berekende debet saldo voorgaande periode in beginjaar
	EXPORT vorig_cre as FLOAT //berekende credit saldo voorgaande periode in beginjaar
	EXPORT vjr_deb as FLOAT   //berekende debet saldo voorgaande jaar
	EXPORT vjr_cre  as FLOAT  //berekende credit saldo vooorgaand jaar
	EXPORT cRubrSoort as STRING // Classification of corresponding balance item
	PROTECT cFileTrans as STRING 
	
	declare method ChgBalance, GetCategory
ACCESS accid CLASS MBalance
 RETURN self:FieldGet(1)
ASSIGN accid(uValue) CLASS MBalance
 RETURN self:FieldPut(1, uValue)
ACCESS CRE CLASS MBalance
 RETURN self:FieldGet(6)
ASSIGN CRE(uValue) CLASS MBalance
 RETURN self:FieldPut(6, uValue)
ACCESS CURRENCY CLASS MBalance
 RETURN self:FieldGet(4)
ASSIGN CURRENCY(uValue) CLASS MBalance
 RETURN self:FieldPut(4, uValue)
ACCESS DEB CLASS MBalance
 RETURN self:FieldGet(5)
ASSIGN DEB(uValue) CLASS MBalance
 RETURN self:FieldPut(5, uValue)
METHOD Init( cTable, oConn ) CLASS MBalance
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`mbalance`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_MBalance_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`accid`] , ;
   [`YEAR`] , ;
   [`MONTH`] , ;
   [`CURRENCY`] , ;
   [`DEB`] , ;
   [`CRE`]   }, oConn )

oHyperLabel := HyperLabel{IDM_MBALANCE_NAME,  ;
   "MBalance",  ;
   ,  ;
   "MBalance" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    self:SetPrimaryKey(2)
    self:SetPrimaryKey(3)
    self:SetPrimaryKey(4)
    oFS:=MBalance_REK{}
    self:SetDataField(1,DataField{[accid] ,oFS})
    oFS:=MBalance_YEAR{}
    self:SetDataField(2,DataField{[YEAR] ,oFS})
    oFS:=MBalance_MONTH{}
    self:SetDataField(3,DataField{[MONTH] ,oFS})
    oFS:=MBalance_CURRENCY{}
    self:SetDataField(4,DataField{[CURRENCY] ,oFS})
    oFS:=MBalance_DEB{}
    self:SetDataField(5,DataField{[DEB] ,oFS})
    oFS:=MBalance_CRE{}
    self:SetDataField(6,DataField{[CRE] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS MONTH CLASS MBalance
 RETURN self:FieldGet(3)
ASSIGN MONTH(uValue) CLASS MBalance
 RETURN self:FieldPut(3, uValue)
ACCESS YEAR CLASS MBalance
 RETURN self:FieldGet(2)
ASSIGN YEAR(uValue) CLASS MBalance
 RETURN self:FieldPut(2, uValue)
CLASS MBalance_CRE INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_CRE
super:Init(HyperLabel{"CRE","Cre","","mbalance_CRE"},"N",20,2)

RETURN SELF
CLASS MBalance_CURRENCY INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_CURRENCY
super:Init(HyperLabel{"CURRENCY","Currency","","mbalance_CURRENCY"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS MBalance_DEB INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_DEB
super:Init(HyperLabel{"DEB","Deb","","mbalance_DEB"},"N",20,2)

RETURN SELF
CLASS MBalance_MONTH INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_MONTH
super:Init(HyperLabel{"MONTH","Month","","mbalance_MONTH"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS MBalance_REK INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_REK
super:Init(HyperLabel{"accid","accid","","mbalance_REK"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS MBalance_YEAR INHERIT FIELDSPEC
METHOD Init() CLASS MBalance_YEAR
super:Init(HyperLabel{"YEAR","Year","","mbalance_YEAR"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
