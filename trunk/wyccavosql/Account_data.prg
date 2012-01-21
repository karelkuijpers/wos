CLASS account_ABP INHERIT FIELDSPEC


METHOD Init() CLASS account_ABP
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#ABP, "subscriptionprice", "", "account_ABP" },  "N", 11, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS account_ACCNUMBER INHERIT FIELDSPEC
METHOD Init() CLASS account_ACCNUMBER
super:Init(HyperLabel{"ACCNUMBER","Accnumber","","account_ACCNUMBER"},"C",12,0)

RETURN SELF
CLASS account_CLC INHERIT FIELDSPEC
METHOD Init() CLASS account_CLC
super:Init(HyperLabel{"CLC","Clc","","account_CLC"},"C",8,0)

RETURN SELF
CLASS account_CLN INHERIT FIELDSPEC
METHOD Init() CLASS account_CLN
super:Init(HyperLabel{"persid","persid","","account_CLN"},"N",11,0)

RETURN SELF
CLASS account_CURRENCY INHERIT FIELDSPEC
METHOD Init() CLASS account_CURRENCY
super:Init(HyperLabel{"CURRENCY","Currency","","account_CURRENCY"},"C",3,0)

RETURN SELF
CLASS account_DEPARTMENT INHERIT FIELDSPEC
METHOD Init() CLASS account_DEPARTMENT
super:Init(HyperLabel{"DEPARTMENT","Department","","account_DEPARTMENT"},"N",11,0)

RETURN SELF
CLASS account_GAINLSACC INHERIT FIELDSPEC
METHOD Init() CLASS account_GAINLSACC
super:Init(HyperLabel{"GAINLSACC","Gainlsacc","","account_GAINLSACC"},"N",11,0)

RETURN SELF
CLASS account_GIFTALWD INHERIT FIELDSPEC
METHOD Init() CLASS account_GIFTALWD
super:Init(HyperLabel{"GIFTALWD","Giftalwd","","account_GIFTALWD"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS account_IPCACCOUNT INHERIT FIELDSPEC
METHOD Init() CLASS account_IPCACCOUNT
super:Init(HyperLabel{"IPCACCOUNT","Ipcaccount","","account_IPCACCOUNT"},"N",11,0)

RETURN SELF
CLASS account_MULTCURR INHERIT FIELDSPEC
METHOD Init() CLASS account_MULTCURR
super:Init(HyperLabel{"MULTCURR","Multcurr","","account_MULTCURR"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS account_NUM INHERIT FIELDSPEC
METHOD Init() CLASS account_NUM
super:Init(HyperLabel{"balitemid","balitemid","","account_NUM"},"N",11,0)

RETURN SELF
CLASS account_OMS INHERIT FIELDSPEC
METHOD Init() CLASS account_OMS
super:Init(HyperLabel{"description","description","","account_OMS"},"C",40,0)

RETURN SELF
CLASS account_PROPXTRA INHERIT FIELDSPEC
METHOD Init() CLASS account_PROPXTRA
super:Init(HyperLabel{"PROPXTRA","Propxtra","","account_PROPXTRA"},"M",10,0)

RETURN SELF
CLASS Account_qtymailing INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Account_qtymailing
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Account_qtymailing, "", "Nbt of persons receiving the mailing corresponding with this account", "" },  "N", 10, 0 )
    cPict       := "9999999999"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS account_REEVALUATE INHERIT FIELDSPEC
METHOD Init() CLASS account_REEVALUATE
super:Init(HyperLabel{"REEVALUATE","Reevaluate","","account_REEVALUATE"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS account_REIMB INHERIT FIELDSPEC
METHOD Init() CLASS account_REIMB
super:Init(HyperLabel{"REIMB","Reimb","","account_REIMB"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS account_REK INHERIT FIELDSPEC
METHOD Init() CLASS account_REK
super:Init(HyperLabel{"accid","accid","","account_REK"},"N",11,0)

RETURN SELF
CLASS Budget_AMOUNT INHERIT FIELDSPEC
METHOD Init() CLASS Budget_AMOUNT
super:Init(HyperLabel{"AMOUNT","Amount","","budget_AMOUNT"},"N",18,2)
CLASS Budget_MONTH INHERIT FIELDSPEC
METHOD Init() CLASS Budget_MONTH
super:Init(HyperLabel{"MONTH","Month","","budget_MONTH"},"C",2,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Budget_REK INHERIT FIELDSPEC
METHOD Init() CLASS Budget_REK
super:Init(HyperLabel{"accid","accid","","budget_REK"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Budget_YEAR INHERIT FIELDSPEC
METHOD Init() CLASS Budget_YEAR
super:Init(HyperLabel{"YEAR","Year","","budget_YEAR"},"C",4,0)
self:SetRequired(.T.,)

RETURN SELF
function dummy()
// CLASS Account INHERIT SQLTABLEDEPFLTR
// 	//USER CODE STARTS HERE (do NOT remove this line)
// 	EXPORT MemberBal, MEMBERDep as STRING  // Id of balance item and department of member accounts
// // 	PROTECT oBud as Budget
// 	EXPORT aExclAcc:={} as ARRAY    // to be used in filter expression 
// 	protect oDep as Department
// 	protect d_Dep as array
// 	export cDepIncl:=cDepmntIncl, cTypeIncl as string  // to be used in filter on departments 
// 	declare method AddSubDep,SetDepFilter
// ACCESS AccId CLASS Account
//  RETURN self:FIELDGET(1)
// ASSIGN AccId(uValue) CLASS Account
//  RETURN self:FIELDPUT(1, uValue)
// ACCESS ACCNUMBER CLASS Account
//  RETURN self:FIELDGET(8)
// ASSIGN ACCNUMBER(uValue) CLASS Account
//  RETURN self:FIELDPUT(8, uValue)
// ACCESS balitemid CLASS Account
//  RETURN self:FIELDGET(2)
// ASSIGN balitemid(uValue) CLASS Account
//  RETURN self:FIELDPUT(2, uValue)
// ACCESS CLC CLASS Account
//  RETURN self:FIELDGET(6)
// ASSIGN CLC(uValue) CLASS Account
//  RETURN self:FIELDPUT(6, uValue)
// METHOD Close() CLASS Account
// 	RETURN SUPER:Close()
// ACCESS CURRENCY CLASS Account
//  RETURN self:FIELDGET(11)
// ASSIGN Currency(uValue) CLASS Account
//  RETURN self:FIELDPUT(11, uValue)
// ACCESS Department CLASS Account
//  RETURN self:FIELDGET(9)
// ASSIGN Department(uValue) CLASS Account
//  RETURN self:FIELDPUT(9, uValue)
// ACCESS description CLASS Account
//  RETURN self:FIELDGET(3)
// ASSIGN Description(uValue) CLASS Account
//  RETURN self:FIELDPUT(3, uValue)
// ACCESS GAINLSACC CLASS Account
//  RETURN self:FIELDGET(14)
// ASSIGN GAINLSACC(uValue) CLASS Account
//  RETURN self:FIELDPUT(14, uValue)
// ACCESS GIFTALWD CLASS Account
//  RETURN self:FIELDGET(5)
// ASSIGN GIFTALWD(uValue) CLASS Account
//  RETURN self:FIELDPUT(5, uValue)
// METHOD Init( cTable, oConn ) CLASS Account
// LOCAL oFS,oHL as OBJECT

// IF IsNil(cTable)
//    cTable := [`account`]
// ENDIF

// IF IsNil(oConn)
//    oConn := SQLGetMyConnection( "", IDM_Account_USERID, "" )
// ENDIF

// super:Init( cTable, ;
//   { ;
//    [`accid`] , ;
//    [`balitemid`] , ;
//    [`description`] , ;
//    [`subscriptionprice`] , ;
//    [`GIFTALWD`] , ;
//    [`CLC`] , ;
//    [`persid`] , ;
//    [`ACCNUMBER`] , ;
//    [`DEPARTMENT`] , ;
//    [`PROPXTRA`] , ;
//    [`CURRENCY`] , ;
//    [`MULTCURR`] , ;
//    [`REEVALUATE`] , ;
//    [`GAINLSACC`] , ;
//    [`IPCACCOUNT`] , ;
//    [`REIMB`]   }, oConn )

// oHyperLabel := HyperLabel{IDM_ACCOUNT_NAME,  ;
//    "Account",  ;
//    "Account",  ;
//    "Account" }
// IF oHLStatus = nil
//     self:Seek()
//     self:SetPrimaryKey(1)
//     oFS:=account_REK{}
//     self:SetDataField(1,DataField{[accid] ,oFS})
//     oFS:=account_NUM{}
//     self:SetDataField(2,DataField{[balitemid] ,oFS})
//     oFS:=account_OMS{}
//     self:SetDataField(3,DataField{[description] ,oFS})
//     oFS:=account_ABP{}
//     self:SetDataField(4,DataField{[subscriptionprice] ,oFS})
//     oFS:=account_GIFTALWD{}
//     self:SetDataField(5,DataField{[GIFTALWD] ,oFS})
//     oFS:=account_CLC{}
//     self:SetDataField(6,DataField{[CLC] ,oFS})
//     oFS:=account_CLN{}
//     self:SetDataField(7,DataField{[persid] ,oFS})
//     oFS:=account_ACCNUMBER{}
//     self:SetDataField(8,DataField{[ACCNUMBER] ,oFS})
//     oFS:=account_DEPARTMENT{}
//     self:SetDataField(9,DataField{[DEPARTMENT] ,oFS})
//     oFS:=account_PROPXTRA{}
//     self:SetDataField(10,DataField{[PROPXTRA] ,oFS})
//     oFS:=account_CURRENCY{}
//     self:SetDataField(11,DataField{[CURRENCY] ,oFS})
//     oFS:=account_MULTCURR{}
//     self:SetDataField(12,DataField{[MULTCURR] ,oFS})
//     oFS:=account_REEVALUATE{}
//     self:SetDataField(13,DataField{[REEVALUATE] ,oFS})
//     oFS:=account_GAINLSACC{}
//     self:SetDataField(14,DataField{[GAINLSACC] ,oFS})
//     oFS:=account_IPCACCOUNT{}
//     self:SetDataField(15,DataField{[IPCACCOUNT] ,oFS})
//     oFS:=account_REIMB{}
//     self:SetDataField(16,DataField{[REIMB] ,oFS})
//     oHL := null_object
// ENDIF
//  
// RETURN self
//  
// ACCESS IPCACCOUNT CLASS Account
//  RETURN self:FIELDGET(15)
// ASSIGN IPCACCOUNT(uValue) CLASS Account
//  RETURN self:FIELDPUT(15, uValue)
// ACCESS MULTCURR CLASS Account
//  RETURN self:FIELDGET(12)
// ASSIGN MULTCURR(uValue) CLASS Account
//  RETURN self:FIELDPUT(12, uValue)
// ACCESS persid CLASS Account
//  RETURN self:FIELDGET(7)
// ASSIGN persid(uValue) CLASS Account
//  RETURN self:FIELDPUT(7, uValue)
// ACCESS PROPXTRA CLASS Account
//  RETURN self:FIELDGET(10)
// ASSIGN PROPXTRA(uValue) CLASS Account
//  RETURN self:FIELDPUT(10, uValue)
// ACCESS REEVALUATE CLASS Account
//  RETURN self:FIELDGET(13)
// ASSIGN REEVALUATE(uValue) CLASS Account
//  RETURN self:FIELDPUT(13, uValue)
// ACCESS REIMB CLASS Account
//  RETURN self:FIELDGET(16)
// ASSIGN REIMB(uValue) CLASS Account
//  RETURN self:FIELDPUT(16, uValue)
// ACCESS subscriptionprice CLASS Account
//  RETURN self:FIELDGET(4)
// ASSIGN subscriptionprice(uValue) CLASS Account
//  RETURN self:FIELDPUT(4, uValue)
// ACCESS  TYPE  CLASS Account

//     RETURN ACSRT(self:balitemid) 
// RETURN self
// CLASS Budget INHERIT SQLTable
// ACCESS AccId CLASS Budget
//  RETURN self:FieldGet(1)
// ASSIGN AccId(uValue) CLASS Budget
//  RETURN self:FieldPut(1, uValue)
// ACCESS AMOUNT CLASS Budget
//  RETURN self:FieldGet(4)
// ASSIGN AMOUNT(uValue) CLASS Budget
//  RETURN self:FieldPut(4, uValue)
// METHOD Init( cTable, oConn ) CLASS Budget
// LOCAL oFS,oHL AS OBJECT

// IF IsNil(cTable)
//    cTable := [`budget`]
// ENDIF

// IF IsNil(oConn)
//    oConn := SQLGetMyConnection( "", IDM_Budget_USERID, "" )
// ENDIF

// super:Init( cTable, ;
//   { ;
//    [`accid`] , ;
//    [`YEAR`] , ;
//    [`MONTH`] , ;
//    [`AMOUNT`]   }, oConn )

// oHyperLabel := HyperLabel{IDM_BUDGET_NAME,  ;
//    "Budget",  ;
//    ,  ;
//    "Budget" }
// IF oHLStatus = NIL
//     self:Seek()
//     self:SetPrimaryKey(1)
//     self:SetPrimaryKey(2)
//     self:SetPrimaryKey(3)
//     oFS:=Budget_REK{}
//     self:SetDataField(1,DataField{[accid] ,oFS})
//     oFS:=Budget_YEAR{}
//     self:SetDataField(2,DataField{[YEAR] ,oFS})
//     oFS:=Budget_MONTH{}
//     self:SetDataField(3,DataField{[MONTH] ,oFS})
//     oFS:=Budget_AMOUNT{}
//     self:SetDataField(4,DataField{[AMOUNT] ,oFS})
//     oHL := NULL_OBJECT
// ENDIF
//  
// RETURN SELF
//  
// ACCESS MONTH CLASS Budget
//  RETURN self:FieldGet(3)
// ASSIGN MONTH(uValue) CLASS Budget
//  RETURN self:FieldPut(3, uValue)
// ACCESS YEAR CLASS Budget
//  RETURN self:FieldGet(2)
// ASSIGN YEAR(uValue) CLASS Budget
//  RETURN self:FieldPut(2, uValue)
return
Define IDM_ACCOUNT_NAME := "Account"
Define IDM_Account_ORDERBY := [ACCNUMBER]
Define IDM_Account_PSWD := "7o4JDp07iyHx"
Define IDM_Account_SOURCE := "ParousiaLocal"
Define IDM_Account_USERID := "parouÿÐHbwÐ€vw"
Define IDM_BUDGET_NAME := "Budget"
Define IDM_Budget_USERID := "parous…ew@™=w"
