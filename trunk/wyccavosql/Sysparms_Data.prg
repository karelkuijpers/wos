Define IDM_IPCACCOUNTS_NAME := "IPCAccounts"
Define IDM_IPCAccounts_USERID := "parouÿÐHÍwÐ€‡v"
Define IDM_PPCODES_NAME := "PPCodes"
Define IDM_PPCodes_USERID := "parouÿ…ºw@™Ðw"
Define IDM_SYSPARMS_NAME := "Sysparms"
Define IDM_Sysparms_USERID := "parouÿÐHwÐ€v"
CLASS IPCAccounts INHERIT SQLTABLE
ACCESS DESCRIPTN CLASS IPCAccounts
 RETURN self:FieldGet(2)
ASSIGN DESCRIPTN(uValue) CLASS IPCAccounts
 RETURN self:FieldPut(2, uValue)
METHOD Init( cTable, oConn ) CLASS IPCAccounts
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`ipcaccounts`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_IPCAccounts_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`IPCACCOUNT`] , ;
   [`DESCRIPTN`]   }, oConn )

oHyperLabel := HyperLabel{IDM_IPCACCOUNTS_NAME,  ;
   "IPCAccounts",  ;
   "IPCAccounts",  ;
   "IPCAccounts" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=ipcaccounts_IPCACCOUNT{}
    self:SetDataField(1,DataField{[IPCACCOUNT] ,oFS})
    oFS:=ipcaccounts_DESCRIPTN{}
    self:SetDataField(2,DataField{[DESCRIPTN] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS IPCACCOUNT CLASS IPCAccounts
 RETURN self:FieldGet(1)
ASSIGN IPCACCOUNT(uValue) CLASS IPCAccounts
 RETURN self:FieldPut(1, uValue)
CLASS ipcaccounts_DESCRIPTN INHERIT FIELDSPEC
METHOD Init() CLASS ipcaccounts_DESCRIPTN
super:Init(HyperLabel{"DESCRIPTN","Descriptn","","ipcaccounts_DESCRIPTN"},"C",50,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS ipcaccounts_IPCACCOUNT INHERIT FIELDSPEC
METHOD Init() CLASS ipcaccounts_IPCACCOUNT
super:Init(HyperLabel{"IPCACCOUNT","Ipcaccount","","ipcaccounts_IPCACCOUNT"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS PPCodes INHERIT SQLTable
METHOD Init( cTable, oConn ) CLASS PPCodes
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`ppcodes`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_PPCodes_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`PPCODE`] , ;
   [`PPNAME`] , ;
   [`OLDCODE`]   }, oConn )

oHyperLabel := HyperLabel{IDM_PPCODES_NAME,  ;
   "PPCodes",  ;
   ,  ;
   "PPCodes" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    oFS:=PPCodes_PPCODE{}
    self:SetDataField(1,DataField{[PPCODE] ,oFS})
    oFS:=PPCodes_PPNAME{}
    self:SetDataField(2,DataField{[PPNAME] ,oFS})
    oFS:=PPCodes_OLDCODE{}
    self:SetDataField(3,DataField{[OLDCODE] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS OLDCODE CLASS PPCodes
 RETURN self:FieldGet(3)
ASSIGN OLDCODE(uValue) CLASS PPCodes
 RETURN self:FieldPut(3, uValue)
ACCESS PPCODE CLASS PPCodes
 RETURN self:FieldGet(1)
ASSIGN PPCODE(uValue) CLASS PPCodes
 RETURN self:FieldPut(1, uValue)
ACCESS PPNAME CLASS PPCodes
 RETURN self:FieldGet(2)
ASSIGN PPNAME(uValue) CLASS PPCodes
 RETURN self:FieldPut(2, uValue)
CLASS PPCodes_OLDCODE INHERIT FIELDSPEC
METHOD Init() CLASS PPCodes_OLDCODE
super:Init(HyperLabel{"OLDCODE","Oldcode","","ppcodes_OLDCODE"},"C",6,0)

RETURN SELF
CLASS PPCodes_PPCODE INHERIT FIELDSPEC
METHOD Init() CLASS PPCodes_PPCODE
super:Init(HyperLabel{"PPCODE","Ppcode","","ppcodes_PPCODE"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS PPCodes_PPNAME INHERIT FIELDSPEC
METHOD Init() CLASS PPCodes_PPNAME
super:Init(HyperLabel{"PPNAME","Ppname","","ppcodes_PPNAME"},"C",40,0)

RETURN SELF
CLASS Sysparms INHERIT SQLTable
ACCESS ACCPACLS CLASS Sysparms
 RETURN self:FieldGet(78)
ASSIGN ACCPACLS(uValue) CLASS Sysparms
 RETURN self:FieldPut(78, uValue)
ACCESS ADMINTYPE CLASS Sysparms
 RETURN self:FieldGet(34)
ASSIGN ADMINTYPE(uValue) CLASS Sysparms
 RETURN self:FieldPut(34, uValue)
ACCESS AM CLASS Sysparms
 RETURN self:FieldGet(11)
ASSIGN AM(uValue) CLASS Sysparms
 RETURN self:FieldPut(11, uValue)
ACCESS assmnthas CLASS Sysparms
 RETURN self:FieldGet(12)
ASSIGN assmnthas(uValue) CLASS Sysparms
 RETURN self:FieldPut(12, uValue)
ACCESS assmntoffc CLASS Sysparms
 RETURN self:FieldGet(13)
ASSIGN assmntoffc(uValue) CLASS Sysparms
 RETURN self:FieldPut(13, uValue)
ACCESS ASSPROJA CLASS Sysparms
 RETURN self:FieldGet(47)
ASSIGN ASSPROJA(uValue) CLASS Sysparms
 RETURN self:FieldPut(47, uValue)
ACCESS BANKNBRCOL CLASS Sysparms
 RETURN self:FieldGet(52)
ASSIGN BANKNBRCOL(uValue) CLASS Sysparms
 RETURN self:FieldPut(52, uValue)
ACCESS BANKNBRCRE CLASS Sysparms
 RETURN self:FieldGet(64)
ASSIGN BANKNBRCRE(uValue) CLASS Sysparms
 RETURN self:FieldPut(64, uValue)
ACCESS BOTTOMMARG CLASS Sysparms
 RETURN self:FieldGet(27)
ASSIGN BOTTOMMARG(uValue) CLASS Sysparms
 RETURN self:FieldPut(27, uValue)
ACCESS CAPITAL CLASS Sysparms
 RETURN self:FieldGet(8)
ASSIGN CAPITAL(uValue) CLASS Sysparms
 RETURN self:FieldPut(8, uValue)
ACCESS CASH CLASS Sysparms
 RETURN self:FieldGet(7)
ASSIGN CASH(uValue) CLASS Sysparms
 RETURN self:FieldPut(7, uValue)
ACCESS CHECKEMP CLASS Sysparms
 RETURN self:FieldGet(72)
ASSIGN CHECKEMP(uValue) CLASS Sysparms
 RETURN self:FieldPut(72, uValue)
ACCESS CITYLETTER CLASS Sysparms
 RETURN self:FieldGet(28)
ASSIGN CITYLETTER(uValue) CLASS Sysparms
 RETURN self:FieldPut(28, uValue)
ACCESS CITYNMUPC CLASS Sysparms
 RETURN self:FieldGet(66)
ASSIGN CITYNMUPC(uValue) CLASS Sysparms
 RETURN self:FieldPut(66, uValue)
ACCESS CLOSEMONTH CLASS Sysparms
 RETURN self:FieldGet(33)
ASSIGN CLOSEMONTH(uValue) CLASS Sysparms
 RETURN self:FieldPut(33, uValue)
ACCESS CNTRNRCOLL CLASS Sysparms
 RETURN self:FieldGet(51)
ASSIGN CNTRNRCOLL(uValue) CLASS Sysparms
 RETURN self:FieldPut(51, uValue)
ACCESS COUNTRYCOD CLASS Sysparms
 RETURN self:FieldGet(63)
ASSIGN COUNTRYCOD(uValue) CLASS Sysparms
 RETURN self:FieldPut(63, uValue)
ACCESS countryown CLASS Sysparms
 RETURN self:FieldGet(18)
ASSIGN countryown(uValue) CLASS Sysparms
 RETURN self:FieldPut(18, uValue)
ACCESS CREDITORS CLASS Sysparms
 RETURN self:FieldGet(62)
ASSIGN CREDITORS(uValue) CLASS Sysparms
 RETURN self:FieldPut(62, uValue)
ACCESS crlanguage CLASS Sysparms
 RETURN self:FieldGet(22)
ASSIGN crlanguage(uValue) CLASS Sysparms
 RETURN self:FieldPut(22, uValue)
ACCESS crossaccnt CLASS Sysparms
 RETURN self:FieldGet(9)
ASSIGN crossaccnt(uValue) CLASS Sysparms
 RETURN self:FieldPut(9, uValue)
ACCESS currency CLASS Sysparms
 RETURN self:FieldGet(19)
ASSIGN currency(uValue) CLASS Sysparms
 RETURN self:FieldPut(19, uValue)
ACCESS currname CLASS Sysparms
 RETURN self:FieldGet(20)
ASSIGN currname(uValue) CLASS Sysparms
 RETURN self:FieldPut(20, uValue)
ACCESS DATLSTAFL CLASS Sysparms
 RETURN self:FieldGet(55)
ASSIGN DATLSTAFL(uValue) CLASS Sysparms
 RETURN self:FieldPut(55, uValue)
ACCESS DEBTORS CLASS Sysparms
 RETURN self:FieldGet(5)
ASSIGN DEBTORS(uValue) CLASS Sysparms
 RETURN self:FieldPut(5, uValue)
ACCESS DECMGIFT CLASS Sysparms
 RETURN self:FieldGet(38)
ASSIGN DECMGIFT(uValue) CLASS Sysparms
 RETURN self:FieldPut(38, uValue)
ACCESS defaultcod CLASS Sysparms
 RETURN self:FieldGet(23)
ASSIGN defaultcod(uValue) CLASS Sysparms
 RETURN self:FieldPut(23, uValue)
ACCESS DESTGRPS CLASS Sysparms
 RETURN self:FieldGet(42)
ASSIGN DESTGRPS(uValue) CLASS Sysparms
 RETURN self:FieldPut(42, uValue)
ACCESS DOCPATH CLASS Sysparms
 RETURN self:FieldGet(71)
ASSIGN DOCPATH(uValue) CLASS Sysparms
 RETURN self:FieldPut(71, uValue)
ACCESS DONORS CLASS Sysparms
 RETURN self:FieldGet(6)
ASSIGN DONORS(uValue) CLASS Sysparms
 RETURN self:FieldPut(6, uValue)
ACCESS ENTITY CLASS Sysparms
 RETURN self:FieldGet(14)
ASSIGN ENTITY(uValue) CLASS Sysparms
 RETURN self:FieldPut(14, uValue)
ACCESS EXCHRATE CLASS Sysparms
 RETURN self:FieldGet(32)
ASSIGN EXCHRATE(uValue) CLASS Sysparms
 RETURN self:FieldPut(32, uValue)
ACCESS EXPMAILACC CLASS Sysparms
 RETURN self:FieldGet(39)
ASSIGN EXPMAILACC(uValue) CLASS Sysparms
 RETURN self:FieldPut(39, uValue)
ACCESS FGMLCODES CLASS Sysparms
 RETURN self:FieldGet(61)
ASSIGN FGMLCODES(uValue) CLASS Sysparms
 RETURN self:FieldPut(61, uValue)
ACCESS firstname CLASS Sysparms
 RETURN self:FieldGet(21)
ASSIGN firstname(uValue) CLASS Sysparms
 RETURN self:FieldPut(21, uValue)
ACCESS GIFTEXPAC CLASS Sysparms
 RETURN self:FieldGet(50)
ASSIGN GIFTEXPAC(uValue) CLASS Sysparms
 RETURN self:FieldPut(50, uValue)
ACCESS GIFTINCAC CLASS Sysparms
 RETURN self:FieldGet(49)
ASSIGN GIFTINCAC(uValue) CLASS Sysparms
 RETURN self:FieldPut(49, uValue)
ACCESS HB CLASS Sysparms
 RETURN self:FieldGet(10)
ASSIGN HB(uValue) CLASS Sysparms
 RETURN self:FieldPut(10, uValue)
ACCESS HOMEEXPAC CLASS Sysparms
 RETURN self:FieldGet(60)
ASSIGN HOMEEXPAC(uValue) CLASS Sysparms
 RETURN self:FieldPut(60, uValue)
ACCESS HOMEINCAC CLASS Sysparms
 RETURN self:FieldGet(59)
ASSIGN HOMEINCAC(uValue) CLASS Sysparms
 RETURN self:FieldPut(59, uValue)
ACCESS IDCONTACT CLASS Sysparms
 RETURN self:FieldGet(54)
ASSIGN IDCONTACT(uValue) CLASS Sysparms
 RETURN self:FieldPut(54, uValue)
ACCESS IDORG CLASS Sysparms
 RETURN self:FieldGet(53)
ASSIGN IDORG(uValue) CLASS Sysparms
 RETURN self:FieldPut(53, uValue)
ACCESS IESMAILACC CLASS Sysparms
 RETURN self:FieldGet(31)
ASSIGN IESMAILACC(uValue) CLASS Sysparms
 RETURN self:FieldPut(31, uValue)
ACCESS INHDINT CLASS Sysparms
 RETURN self:FieldGet(41)
ASSIGN INHDINT(uValue) CLASS Sysparms
 RETURN self:FieldPut(41, uValue)
ACCESS INHKNTRH CLASS Sysparms
 RETURN self:FieldGet(46)
ASSIGN INHKNTRH(uValue) CLASS Sysparms
 RETURN self:FieldPut(46, uValue)
ACCESS INHKNTRL CLASS Sysparms
 RETURN self:FieldGet(44)
ASSIGN INHKNTRL(uValue) CLASS Sysparms
 RETURN self:FieldPut(44, uValue)
ACCESS INHKNTRM CLASS Sysparms
 RETURN self:FieldGet(45)
ASSIGN INHKNTRM(uValue) CLASS Sysparms
 RETURN self:FieldPut(45, uValue)
METHOD Init( cTable, oConn ) CLASS Sysparms
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`sysparms`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_Sysparms_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`yearclosed`] , ;
   [`lstreportmonth`] , ;
   [`MINDATE`] , ;
   [`PROJECTS`] , ;
   [`DEBTORS`] , ;
   [`DONORS`] , ;
   [`CASH`] , ;
   [`CAPITAL`] , ;
   [`crossaccnt`] , ;
   [`HB`] , ;
   [`AM`] , ;
   [`assmnthas`] , ;
   [`assmntoffc`] , ;
   [`ENTITY`] , ;
   [`STOCKNBR`] , ;
   [`postage`] , ;
   [`purchase`] , ;
   [`countryown`] , ;
   [`currency`] , ;
   [`currname`] , ;
   [`firstname`] , ;
   [`crlanguage`] , ;
   [`defaultcod`] , ;
   [`TOPMARGIN`] , ;
   [`LEFTMARGIN`] , ;
   [`RIGHTMARGN`] , ;
   [`BOTTOMMARG`] , ;
   [`CITYLETTER`] , ;
   [`OWNMAILACC`] , ;
   [`SMTPSERVER`] , ;
   [`IESMAILACC`] , ;
   [`EXCHRATE`] , ;
   [`CLOSEMONTH`] , ;
   [`ADMINTYPE`] , ;
   [`PSWRDLEN`] , ;
   [`PSWALNUM`] , ;
   [`PSWDURA`] , ;
   [`DECMGIFT`] , ;
   [`EXPMAILACC`] , ;
   [`PMISLSTSND`] , ;
   [`INHDINT`] , ;
   [`DESTGRPS`] , ;
   [`NOSALUT`] , ;
   [`INHKNTRL`] , ;
   [`INHKNTRM`] , ;
   [`INHKNTRH`] , ;
   [`ASSPROJA`] , ;
   [`OWNCNTRY`] , ;
   [`GIFTINCAC`] , ;
   [`GIFTEXPAC`] , ;
   [`CNTRNRCOLL`] , ;
   [`BANKNBRCOL`] , ;
   [`IDORG`] , ;
   [`IDCONTACT`] , ;
   [`DATLSTAFL`] , ;
   [`SURNMFIRST`] , ;
   [`STRZIPCITY`] , ;
   [`SYSNAME`] , ;
   [`HOMEINCAC`] , ;
   [`HOMEEXPAC`] , ;
   [`FGMLCODES`] , ;
   [`CREDITORS`] , ;
   [`COUNTRYCOD`] , ;
   [`BANKNBRCRE`] , ;
   [`LSTREEVAL`] , ;
   [`CITYNMUPC`] , ;
   [`PMCMANCLN`] , ;
   [`VERSION`] , ;
   [`LSTNMUPC`] , ;
   [`TITINADR`] , ;
   [`DOCPATH`] , ;
   [`CHECKEMP`] , ;
   [`MAILCLIENT`] , ;
   [`POSTING`] , ;
   [`TOPPACCT`] , ;
   [`LSTCURRT`] , ;
   [`PMCUPLD`] , ;
   [`ACCPACLS`]   }, oConn )

oHyperLabel := HyperLabel{IDM_SYSPARMS_NAME,  ;
   "Sysparms",  ;
   ,  ;
   "Sysparms" }
IF oHLStatus = NIL
    self:Seek()
    oFS:=sysparms_yearclosed{}
    self:SetDataField(1,DataField{[yearclosed] ,oFS})
    oFS:=sysparms_lstreportmonth{}
    self:SetDataField(2,DataField{[lstreportmonth] ,oFS})
    oFS:=sysparms_MINDATE{}
    self:SetDataField(3,DataField{[MINDATE] ,oFS})
    oFS:=sysparms_PROJECTS{}
    self:SetDataField(4,DataField{[PROJECTS] ,oFS})
    oFS:=sysparms_DEBTORS{}
    self:SetDataField(5,DataField{[DEBTORS] ,oFS})
    oFS:=sysparms_DONORS{}
    self:SetDataField(6,DataField{[DONORS] ,oFS})
    oFS:=sysparms_CASH{}
    self:SetDataField(7,DataField{[CASH] ,oFS})
    oFS:=sysparms_CAPITAL{}
    self:SetDataField(8,DataField{[CAPITAL] ,oFS})
    oFS:=sysparms_crossaccnt{}
    self:SetDataField(9,DataField{[crossaccnt] ,oFS})
    oFS:=sysparms_HB{}
    self:SetDataField(10,DataField{[HB] ,oFS})
    oFS:=sysparms_AM{}
    self:SetDataField(11,DataField{[AM] ,oFS})
    oFS:=sysparms_assmnthas{}
    self:SetDataField(12,DataField{[assmnthas] ,oFS})
    oFS:=sysparms_assmntoffc{}
    self:SetDataField(13,DataField{[assmntoffc] ,oFS})
    oFS:=sysparms_ENTITY{}
    self:SetDataField(14,DataField{[ENTITY] ,oFS})
    oFS:=sysparms_STOCKNBR{}
    self:SetDataField(15,DataField{[STOCKNBR] ,oFS})
    oFS:=sysparms_postage{}
    self:SetDataField(16,DataField{[postage] ,oFS})
    oFS:=sysparms_purchase{}
    self:SetDataField(17,DataField{[purchase] ,oFS})
    oFS:=sysparms_countryown{}
    self:SetDataField(18,DataField{[countryown] ,oFS})
    oFS:=sysparms_currency{}
    self:SetDataField(19,DataField{[currency] ,oFS})
    oFS:=sysparms_currname{}
    self:SetDataField(20,DataField{[currname] ,oFS})
    oFS:=sysparms_firstname{}
    self:SetDataField(21,DataField{[firstname] ,oFS})
    oFS:=sysparms_crlanguage{}
    self:SetDataField(22,DataField{[crlanguage] ,oFS})
    oFS:=sysparms_defaultcod{}
    self:SetDataField(23,DataField{[defaultcod] ,oFS})
    oFS:=sysparms_TOPMARGIN{}
    self:SetDataField(24,DataField{[TOPMARGIN] ,oFS})
    oFS:=sysparms_LEFTMARGIN{}
    self:SetDataField(25,DataField{[LEFTMARGIN] ,oFS})
    oFS:=sysparms_RIGHTMARGN{}
    self:SetDataField(26,DataField{[RIGHTMARGN] ,oFS})
    oFS:=sysparms_BOTTOMMARG{}
    self:SetDataField(27,DataField{[BOTTOMMARG] ,oFS})
    oFS:=sysparms_CITYLETTER{}
    self:SetDataField(28,DataField{[CITYLETTER] ,oFS})
    oFS:=sysparms_OWNMAILACC{}
    self:SetDataField(29,DataField{[OWNMAILACC] ,oFS})
    oFS:=sysparms_SMTPSERVER{}
    self:SetDataField(30,DataField{[SMTPSERVER] ,oFS})
    oFS:=sysparms_IESMAILACC{}
    self:SetDataField(31,DataField{[IESMAILACC] ,oFS})
    oFS:=sysparms_EXCHRATE{}
    self:SetDataField(32,DataField{[EXCHRATE] ,oFS})
    oFS:=sysparms_CLOSEMONTH{}
    self:SetDataField(33,DataField{[CLOSEMONTH] ,oFS})
    oFS:=sysparms_ADMINTYPE{}
    self:SetDataField(34,DataField{[ADMINTYPE] ,oFS})
    oFS:=sysparms_PSWRDLEN{}
    self:SetDataField(35,DataField{[PSWRDLEN] ,oFS})
    oFS:=sysparms_PSWALNUM{}
    self:SetDataField(36,DataField{[PSWALNUM] ,oFS})
    oFS:=sysparms_PSWDURA{}
    self:SetDataField(37,DataField{[PSWDURA] ,oFS})
    oFS:=sysparms_DECMGIFT{}
    self:SetDataField(38,DataField{[DECMGIFT] ,oFS})
    oFS:=sysparms_EXPMAILACC{}
    self:SetDataField(39,DataField{[EXPMAILACC] ,oFS})
    oFS:=sysparms_PMISLSTSND{}
    self:SetDataField(40,DataField{[PMISLSTSND] ,oFS})
    oFS:=sysparms_INHDINT{}
    self:SetDataField(41,DataField{[INHDINT] ,oFS})
    oFS:=sysparms_DESTGRPS{}
    self:SetDataField(42,DataField{[DESTGRPS] ,oFS})
    oFS:=sysparms_NOSALUT{}
    self:SetDataField(43,DataField{[NOSALUT] ,oFS})
    oFS:=sysparms_INHKNTRL{}
    self:SetDataField(44,DataField{[INHKNTRL] ,oFS})
    oFS:=sysparms_INHKNTRM{}
    self:SetDataField(45,DataField{[INHKNTRM] ,oFS})
    oFS:=sysparms_INHKNTRH{}
    self:SetDataField(46,DataField{[INHKNTRH] ,oFS})
    oFS:=sysparms_ASSPROJA{}
    self:SetDataField(47,DataField{[ASSPROJA] ,oFS})
    oFS:=sysparms_OWNCNTRY{}
    self:SetDataField(48,DataField{[OWNCNTRY] ,oFS})
    oFS:=sysparms_GIFTINCAC{}
    self:SetDataField(49,DataField{[GIFTINCAC] ,oFS})
    oFS:=sysparms_GIFTEXPAC{}
    self:SetDataField(50,DataField{[GIFTEXPAC] ,oFS})
    oFS:=sysparms_CNTRNRCOLL{}
    self:SetDataField(51,DataField{[CNTRNRCOLL] ,oFS})
    oFS:=sysparms_BANKNBRCOL{}
    self:SetDataField(52,DataField{[BANKNBRCOL] ,oFS})
    oFS:=sysparms_IDORG{}
    self:SetDataField(53,DataField{[IDORG] ,oFS})
    oFS:=sysparms_IDCONTACT{}
    self:SetDataField(54,DataField{[IDCONTACT] ,oFS})
    oFS:=sysparms_DATLSTAFL{}
    self:SetDataField(55,DataField{[DATLSTAFL] ,oFS})
    oFS:=sysparms_SURNMFIRST{}
    self:SetDataField(56,DataField{[SURNMFIRST] ,oFS})
    oFS:=sysparms_STRZIPCITY{}
    self:SetDataField(57,DataField{[STRZIPCITY] ,oFS})
    oFS:=sysparms_SYSNAME{}
    self:SetDataField(58,DataField{[SYSNAME] ,oFS})
    oFS:=sysparms_HOMEINCAC{}
    self:SetDataField(59,DataField{[HOMEINCAC] ,oFS})
    oFS:=sysparms_HOMEEXPAC{}
    self:SetDataField(60,DataField{[HOMEEXPAC] ,oFS})
    oFS:=sysparms_FGMLCODES{}
    self:SetDataField(61,DataField{[FGMLCODES] ,oFS})
    oFS:=sysparms_CREDITORS{}
    self:SetDataField(62,DataField{[CREDITORS] ,oFS})
    oFS:=sysparms_COUNTRYCOD{}
    self:SetDataField(63,DataField{[COUNTRYCOD] ,oFS})
    oFS:=sysparms_BANKNBRCRE{}
    self:SetDataField(64,DataField{[BANKNBRCRE] ,oFS})
    oFS:=sysparms_LSTREEVAL{}
    self:SetDataField(65,DataField{[LSTREEVAL] ,oFS})
    oFS:=sysparms_CITYNMUPC{}
    self:SetDataField(66,DataField{[CITYNMUPC] ,oFS})
    oFS:=sysparms_PMCMANCLN{}
    self:SetDataField(67,DataField{[PMCMANCLN] ,oFS})
    oFS:=sysparms_VERSION{}
    self:SetDataField(68,DataField{[VERSION] ,oFS})
    oFS:=sysparms_LSTNMUPC{}
    self:SetDataField(69,DataField{[LSTNMUPC] ,oFS})
    oFS:=sysparms_TITINADR{}
    self:SetDataField(70,DataField{[TITINADR] ,oFS})
    oFS:=sysparms_DOCPATH{}
    self:SetDataField(71,DataField{[DOCPATH] ,oFS})
    oFS:=sysparms_CHECKEMP{}
    self:SetDataField(72,DataField{[CHECKEMP] ,oFS})
    oFS:=sysparms_MAILCLIENT{}
    self:SetDataField(73,DataField{[MAILCLIENT] ,oFS})
    oFS:=sysparms_POSTING{}
    self:SetDataField(74,DataField{[POSTING] ,oFS})
    oFS:=sysparms_TOPPACCT{}
    self:SetDataField(75,DataField{[TOPPACCT] ,oFS})
    oFS:=sysparms_LSTCURRT{}
    self:SetDataField(76,DataField{[LSTCURRT] ,oFS})
    oFS:=sysparms_PMCUPLD{}
    self:SetDataField(77,DataField{[PMCUPLD] ,oFS})
    oFS:=sysparms_ACCPACLS{}
    self:SetDataField(78,DataField{[ACCPACLS] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS LEFTMARGIN CLASS Sysparms
 RETURN self:FieldGet(25)
ASSIGN LEFTMARGIN(uValue) CLASS Sysparms
 RETURN self:FieldPut(25, uValue)
ACCESS LSTCURRT CLASS Sysparms
 RETURN self:FieldGet(76)
ASSIGN LSTCURRT(uValue) CLASS Sysparms
 RETURN self:FieldPut(76, uValue)
ACCESS LSTNMUPC CLASS Sysparms
 RETURN self:FieldGet(69)
ASSIGN LSTNMUPC(uValue) CLASS Sysparms
 RETURN self:FieldPut(69, uValue)
ACCESS LSTREEVAL CLASS Sysparms
 RETURN self:FieldGet(65)
ASSIGN LSTREEVAL(uValue) CLASS Sysparms
 RETURN self:FieldPut(65, uValue)
ACCESS lstreportmonth CLASS Sysparms
 RETURN self:FieldGet(2)
ASSIGN lstreportmonth(uValue) CLASS Sysparms
 RETURN self:FieldPut(2, uValue)
ACCESS MAANDAFSL CLASS Sysparms
 RETURN self:FieldGet(3)
ASSIGN MAANDAFSL(uValue) CLASS Sysparms
 RETURN self:FieldPut(3, uValue)
ACCESS MAILCLIENT CLASS Sysparms
 RETURN self:FieldGet(73)
ASSIGN MAILCLIENT(uValue) CLASS Sysparms
 RETURN self:FieldPut(73, uValue)
ACCESS MINDATE CLASS Sysparms
 RETURN self:FieldGet(3)
ASSIGN MINDATE(uValue) CLASS Sysparms
 RETURN self:FieldPut(3, uValue)
ACCESS NOSALUT CLASS Sysparms
 RETURN self:FieldGet(43)
ASSIGN NOSALUT(uValue) CLASS Sysparms
 RETURN self:FieldPut(43, uValue)
ACCESS OWNCNTRY CLASS Sysparms
 RETURN self:FieldGet(48)
ASSIGN OWNCNTRY(uValue) CLASS Sysparms
 RETURN self:FieldPut(48, uValue)
ACCESS OWNMAILACC CLASS Sysparms
 RETURN self:FieldGet(29)
ASSIGN OWNMAILACC(uValue) CLASS Sysparms
 RETURN self:FieldPut(29, uValue)
ACCESS PMCMANCLN CLASS Sysparms
 RETURN self:FieldGet(67)
ASSIGN PMCMANCLN(uValue) CLASS Sysparms
 RETURN self:FieldPut(67, uValue)
ACCESS PMCUPLD CLASS Sysparms
 RETURN self:FieldGet(77)
ASSIGN PMCUPLD(uValue) CLASS Sysparms
 RETURN self:FieldPut(77, uValue)
ACCESS PMISLSTSND CLASS Sysparms
 RETURN self:FieldGet(40)
ASSIGN PMISLSTSND(uValue) CLASS Sysparms
 RETURN self:FieldPut(40, uValue)
ACCESS postage CLASS Sysparms
 RETURN self:FieldGet(16)
ASSIGN postage(uValue) CLASS Sysparms
 RETURN self:FieldPut(16, uValue)
ACCESS POSTING CLASS Sysparms
 RETURN self:FieldGet(74)
ASSIGN POSTING(uValue) CLASS Sysparms
 RETURN self:FieldPut(74, uValue)
ACCESS PROJECTS CLASS Sysparms
 RETURN self:FieldGet(4)
ASSIGN PROJECTS(uValue) CLASS Sysparms
 RETURN self:FieldPut(4, uValue)
ACCESS PSWALNUM CLASS Sysparms
 RETURN self:FieldGet(36)
ASSIGN PSWALNUM(uValue) CLASS Sysparms
 RETURN self:FieldPut(36, uValue)
ACCESS PSWDURA CLASS Sysparms
 RETURN self:FieldGet(37)
ASSIGN PSWDURA(uValue) CLASS Sysparms
 RETURN self:FieldPut(37, uValue)
ACCESS PSWRDLEN CLASS Sysparms
 RETURN self:FieldGet(35)
ASSIGN PSWRDLEN(uValue) CLASS Sysparms
 RETURN self:FieldPut(35, uValue)
ACCESS purchase CLASS Sysparms
 RETURN self:FieldGet(17)
ASSIGN purchase(uValue) CLASS Sysparms
 RETURN self:FieldPut(17, uValue)
ACCESS RIGHTMARGN CLASS Sysparms
 RETURN self:FieldGet(26)
ASSIGN RIGHTMARGN(uValue) CLASS Sysparms
 RETURN self:FieldPut(26, uValue)
ACCESS SMTPSERVER CLASS Sysparms
 RETURN self:FieldGet(30)
ASSIGN SMTPSERVER(uValue) CLASS Sysparms
 RETURN self:FieldPut(30, uValue)
ACCESS STOCKNBR CLASS Sysparms
 RETURN self:FieldGet(15)
ASSIGN STOCKNBR(uValue) CLASS Sysparms
 RETURN self:FieldPut(15, uValue)
ACCESS STRZIPCITY CLASS Sysparms
 RETURN self:FieldGet(57)
ASSIGN STRZIPCITY(uValue) CLASS Sysparms
 RETURN self:FieldPut(57, uValue)
ACCESS SURNMFIRST CLASS Sysparms
 RETURN self:FieldGet(56)
ASSIGN SURNMFIRST(uValue) CLASS Sysparms
 RETURN self:FieldPut(56, uValue)
ACCESS SYSNAME CLASS Sysparms
 RETURN self:FieldGet(58)
ASSIGN SYSNAME(uValue) CLASS Sysparms
 RETURN self:FieldPut(58, uValue)
ACCESS TITINADR CLASS Sysparms
 RETURN self:FieldGet(70)
ASSIGN TITINADR(uValue) CLASS Sysparms
 RETURN self:FieldPut(70, uValue)
ACCESS TOPMARGIN CLASS Sysparms
 RETURN self:FieldGet(24)
ASSIGN TOPMARGIN(uValue) CLASS Sysparms
 RETURN self:FieldPut(24, uValue)
ACCESS TOPPACCT CLASS Sysparms
 RETURN self:FieldGet(75)
ASSIGN TOPPACCT(uValue) CLASS Sysparms
 RETURN self:FieldPut(75, uValue)
ACCESS VERSION CLASS Sysparms
 RETURN self:FieldGet(68)
ASSIGN VERSION(uValue) CLASS Sysparms
 RETURN self:FieldPut(68, uValue)
ACCESS yearclosed CLASS Sysparms
 RETURN self:FieldGet(1)
ASSIGN yearclosed(uValue) CLASS Sysparms
 RETURN self:FieldPut(1, uValue)
CLASS sysparms_ACCPACLS INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_ACCPACLS
super:Init(HyperLabel{"ACCPACLS","Accpacls","","sysparms_ACCPACLS"},"D",10,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_ADMINTYPE INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_ADMINTYPE
super:Init(HyperLabel{"ADMINTYPE","Admintype","","sysparms_ADMINTYPE"},"C",2,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_AM INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_AM
super:Init(HyperLabel{"AM","Am","","sysparms_AM"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_assmnthas INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_assmnthas
super:Init(HyperLabel{"assmnthas","Assmnthas","","sysparms_assmnthas"},"N",5,2)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_assmntoffc INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_assmntoffc
super:Init(HyperLabel{"assmntoffc","Assmntoffc","","sysparms_assmntoffc"},"N",5,2)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_ASSPROJA INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_ASSPROJA
super:Init(HyperLabel{"ASSPROJA","Assproja","","sysparms_ASSPROJA"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_BANKNBRCOL INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_BANKNBRCOL
super:Init(HyperLabel{"BANKNBRCOL","Banknbrcol","","sysparms_BANKNBRCOL"},"C",25,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_BANKNBRCRE INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_BANKNBRCRE
super:Init(HyperLabel{"BANKNBRCRE","Banknbrcre","","sysparms_BANKNBRCRE"},"C",25,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_BOTTOMMARG INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_BOTTOMMARG
super:Init(HyperLabel{"BOTTOMMARG","Bottommarg","","sysparms_BOTTOMMARG"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_CAPITAL INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_CAPITAL
super:Init(HyperLabel{"CAPITAL","Capital","","sysparms_CAPITAL"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_CASH INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_CASH
super:Init(HyperLabel{"CASH","Cash","","sysparms_CASH"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_CHECKEMP INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_CHECKEMP
super:Init(HyperLabel{"CHECKEMP","Checkemp","","sysparms_CHECKEMP"},"C",32,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_CITYLETTER INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_CITYLETTER
super:Init(HyperLabel{"CITYLETTER","Cityletter","","sysparms_CITYLETTER"},"C",18,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_CITYNMUPC INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_CITYNMUPC
super:Init(HyperLabel{"CITYNMUPC","Citynmupc","","sysparms_CITYNMUPC"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_CLOSEMONTH INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_CLOSEMONTH
super:Init(HyperLabel{"CLOSEMONTH","Closemonth","","sysparms_CLOSEMONTH"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_CNTRNRCOLL INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_CNTRNRCOLL
super:Init(HyperLabel{"CNTRNRCOLL","Cntrnrcoll","","sysparms_CNTRNRCOLL"},"C",10,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_COUNTRYCOD INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_COUNTRYCOD
super:Init(HyperLabel{"COUNTRYCOD","Countrycod","","sysparms_COUNTRYCOD"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_countryown INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_countryown
super:Init(HyperLabel{"countryown","Countryown","","sysparms_countryown"},"C",20,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_CREDITORS INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_CREDITORS
super:Init(HyperLabel{"CREDITORS","Creditors","","sysparms_CREDITORS"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_crlanguage INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_crlanguage
super:Init(HyperLabel{"crlanguage","Crlanguage","","sysparms_crlanguage"},"C",1,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_crossaccnt INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_crossaccnt
super:Init(HyperLabel{"crossaccnt","Crossaccnt","","sysparms_crossaccnt"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_currency INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_currency
super:Init(HyperLabel{"currency","Currency","","sysparms_currency"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_currname INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_currname
super:Init(HyperLabel{"currname","Currname","","sysparms_currname"},"C",25,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_DATLSTAFL INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_DATLSTAFL
super:Init(HyperLabel{"DATLSTAFL","Datlstafl","","sysparms_DATLSTAFL"},"D",10,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_DEBTORS INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_DEBTORS
super:Init(HyperLabel{"DEBTORS","Debtors","","sysparms_DEBTORS"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_DECMGIFT INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_DECMGIFT
super:Init(HyperLabel{"DECMGIFT","Decmgift","","sysparms_DECMGIFT"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_defaultcod INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_defaultcod
super:Init(HyperLabel{"defaultcod","Defaultcod","","sysparms_defaultcod"},"C",30,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_DESTGRPS INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_DESTGRPS
super:Init(HyperLabel{"DESTGRPS","Destgrps","","sysparms_DESTGRPS"},"C",65535,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_DOCPATH INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_DOCPATH
super:Init(HyperLabel{"DOCPATH","Docpath","","sysparms_DOCPATH"},"C",65535,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_DONORS INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_DONORS
super:Init(HyperLabel{"DONORS","Donors","","sysparms_DONORS"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_ENTITY INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_ENTITY
super:Init(HyperLabel{"ENTITY","Entity","","sysparms_ENTITY"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_EXCHRATE INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_EXCHRATE
super:Init(HyperLabel{"EXCHRATE","Exchrate","","sysparms_EXCHRATE"},"N",12,8)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_EXPMAILACC INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_EXPMAILACC
super:Init(HyperLabel{"EXPMAILACC","Expmailacc","","sysparms_EXPMAILACC"},"C",100,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_FGMLCODES INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_FGMLCODES
super:Init(HyperLabel{"FGMLCODES","Fgmlcodes","","sysparms_FGMLCODES"},"C",30,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_firstname INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_firstname
super:Init(HyperLabel{"firstname","Firstname","","sysparms_firstname"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_GIFTEXPAC INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_GIFTEXPAC
super:Init(HyperLabel{"GIFTEXPAC","Giftexpac","","sysparms_GIFTEXPAC"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_GIFTINCAC INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_GIFTINCAC
super:Init(HyperLabel{"GIFTINCAC","Giftincac","","sysparms_GIFTINCAC"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_HB INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_HB
super:Init(HyperLabel{"HB","Hb","","sysparms_HB"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_HB_LTS_MND INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_HB_LTS_MND
super:Init(HyperLabel{"LstReportMonth","Hb Lts Mnd","","sysparms_HB_LTS_MND"},"N",11,0)

RETURN SELF
CLASS sysparms_HBLAND INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_HBLAND
super:Init(HyperLabel{"CountryOwn","CountryOwn","","sysparms_HBLAND"},"C",20,0)

RETURN SELF
CLASS sysparms_HOMEEXPAC INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_HOMEEXPAC
super:Init(HyperLabel{"HOMEEXPAC","Homeexpac","","sysparms_HOMEEXPAC"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_HOMEINCAC INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_HOMEINCAC
super:Init(HyperLabel{"HOMEINCAC","Homeincac","","sysparms_HOMEINCAC"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_IDCONTACT INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_IDCONTACT
super:Init(HyperLabel{"IDCONTACT","Idcontact","","sysparms_IDCONTACT"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_IDORG INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_IDORG
super:Init(HyperLabel{"IDORG","Idorg","","sysparms_IDORG"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_IESMAILACC INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_IESMAILACC
super:Init(HyperLabel{"IESMAILACC","Iesmailacc","","sysparms_IESMAILACC"},"C",100,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_INHDHAS INHERIT FIELDSPEC


METHOD Init() CLASS sysparms_INHDHAS
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#INHDHAS, "Assmnthas", "", "sysparms_INHDHAS" },  "N", 5, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS sysparms_INHDINT INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_INHDINT
super:Init(HyperLabel{"INHDINT","Inhdint","","sysparms_INHDINT"},"N",5,2)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_INHDKNTR INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_INHDKNTR
super:Init(HyperLabel{"assmntOffc","assmntOffc","","sysparms_INHDKNTR"},"N",5,2)

RETURN SELF
CLASS sysparms_INHKNTRH INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_INHKNTRH
super:Init(HyperLabel{"INHKNTRH","Inhkntrh","","sysparms_INHKNTRH"},"N",5,2)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_INHKNTRL INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_INHKNTRL
super:Init(HyperLabel{"INHKNTRL","Inhkntrl","","sysparms_INHKNTRL"},"N",5,2)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_INHKNTRM INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_INHKNTRM
super:Init(HyperLabel{"INHKNTRM","Inhkntrm","","sysparms_INHKNTRM"},"N",5,2)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_JAARAFSL INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_JAARAFSL
super:Init(HyperLabel{"yearclosed","yearclosed","","sysparms_JAARAFSL"},"N",11,0)

RETURN SELF
CLASS sysparms_KRUISPSTN INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_KRUISPSTN
super:Init(HyperLabel{"CrossAccnt","CrossAccnt","","sysparms_KRUISPSTN"},"N",11,0)

RETURN SELF
CLASS sysparms_LEFTMARGIN INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_LEFTMARGIN
super:Init(HyperLabel{"LEFTMARGIN","Leftmargin","","sysparms_LEFTMARGIN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_LSTCURRT INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_LSTCURRT
super:Init(HyperLabel{"LSTCURRT","Lstcurrt","","sysparms_LSTCURRT"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_LSTNMUPC INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_LSTNMUPC
super:Init(HyperLabel{"LSTNMUPC","Lstnmupc","","sysparms_LSTNMUPC"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_LSTREEVAL INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_LSTREEVAL
super:Init(HyperLabel{"LSTREEVAL","Lstreeval","","sysparms_LSTREEVAL"},"D",10,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_lstreportmonth INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_lstreportmonth
super:Init(HyperLabel{"lstreportmonth","Lstreportmonth","","sysparms_lstreportmonth"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_MAILCLIENT INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_MAILCLIENT
super:Init(HyperLabel{"MAILCLIENT","Mailclient","","sysparms_MAILCLIENT"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_MINDATE INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_MINDATE
super:Init(HyperLabel{"MINDATE","Mindate","","sysparms_MINDATE"},"D",10,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_NOSALUT INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_NOSALUT
super:Init(HyperLabel{"NOSALUT","Nosalut","","sysparms_NOSALUT"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_OWNCNTRY INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_OWNCNTRY
super:Init(HyperLabel{"OWNCNTRY","Owncntry","","sysparms_OWNCNTRY"},"C",65535,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_OWNMAILACC INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_OWNMAILACC
super:Init(HyperLabel{"OWNMAILACC","Ownmailacc","","sysparms_OWNMAILACC"},"C",100,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_PMCMANCLN INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_PMCMANCLN
super:Init(HyperLabel{"PMCMANCLN","Pmcmancln","","sysparms_PMCMANCLN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_PMCUPLD INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_PMCUPLD
super:Init(HyperLabel{"PMCUPLD","Pmcupld","","sysparms_PMCUPLD"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_PMISLSTSND INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_PMISLSTSND
super:Init(HyperLabel{"PMISLSTSND","Pmislstsnd","","sysparms_PMISLSTSND"},"D",10,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_postage INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_postage
super:Init(HyperLabel{"postage","Postage","","sysparms_postage"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_POSTING INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_POSTING
super:Init(HyperLabel{"POSTING","Posting","","sysparms_POSTING"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_PROJECTS INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_PROJECTS
super:Init(HyperLabel{"PROJECTS","Projects","","sysparms_PROJECTS"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_PSWALNUM INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_PSWALNUM
super:Init(HyperLabel{"PSWALNUM","Pswalnum","","sysparms_PSWALNUM"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_PSWDURA INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_PSWDURA
super:Init(HyperLabel{"PSWDURA","Pswdura","","sysparms_PSWDURA"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_PSWRDLEN INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_PSWRDLEN
super:Init(HyperLabel{"PSWRDLEN","Pswrdlen","","sysparms_PSWRDLEN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_purchase INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_purchase
super:Init(HyperLabel{"purchase","Purchase","","sysparms_purchase"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_RIGHTMARGN INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_RIGHTMARGN
super:Init(HyperLabel{"RIGHTMARGN","Rightmargn","","sysparms_RIGHTMARGN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Sysparms_SINHDHAS INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Sysparms_SINHDHAS
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#SINHDHAS, "Assessment field/home assigned", "Assessment field/home assigned", "Sysparms_SINHDHAS" },  "N", 5, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Sysparms_SINHDKNTR INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Sysparms_SINHDKNTR
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#SINHDKNTR, "Assessment office standard", "", "Sysparms_SINHDKNTR" },  "N", 5, 2 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Sysparms_SINK INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Sysparms_SINK
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#SINK, "Account number Purchase", "", "Sysparms_SINK" },  "C", 2, 0 )
    cPict       := "99"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Sysparms_SLAND INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Sysparms_SLAND
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#SLAND, "Country for H.B", "Country for H.B", "Sysparms_SLAND" },  "C", 20, 0 )
    cPict       := "!XXXXXXXXXXXXXXXXXXX"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Sysparms_SMED INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Sysparms_SMED
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#SMED, "Number members", "", "Sysparms_SMED" },  "C", 2, 0 )
    cPict       := "99"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS sysparms_SMTPSERVER INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_SMTPSERVER
super:Init(HyperLabel{"SMTPSERVER","Smtpserver","","sysparms_SMTPSERVER"},"C",30,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Sysparms_SMUNT INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Sysparms_SMUNT
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#SMUNT, "Currency", "Default currency", "Sysparms_SMUNT" },  "C", 3, 0 )
    cPict       := "!!!"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Sysparms_SMUNTNAAM INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Sysparms_SMUNTNAAM
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#SMUNTNAAM, "Currency name", "Currency name", "Sysparms_SMUNTNAAM" },  "C", 25, 0 )
    cPict       := "!!!!!!!!!!!!!!!!!!!!!!!!!"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS sysparms_STOCKNBR INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_STOCKNBR
super:Init(HyperLabel{"STOCKNBR","Stocknbr","","sysparms_STOCKNBR"},"C",2,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_STRZIPCITY INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_STRZIPCITY
super:Init(HyperLabel{"STRZIPCITY","Strzipcity","","sysparms_STRZIPCITY"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_SURNMFIRST INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_SURNMFIRST
super:Init(HyperLabel{"SURNMFIRST","Surnmfirst","","sysparms_SURNMFIRST"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Sysparms_SVOO INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
CLASS Sysparms_SVOORNAAM INHERIT FIELDSPEC
	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Sysparms_SVOORNAAM
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#SVOORNAAM, "Firstname in address", "Firstname in address", "Sysparms_SVOORNAAM" },  "L", 1, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS sysparms_SYSNAME INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_SYSNAME
super:Init(HyperLabel{"SYSNAME","Sysname","","sysparms_SYSNAME"},"C",50,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_TITINADR INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_TITINADR
super:Init(HyperLabel{"TITINADR","Titinadr","","sysparms_TITINADR"},"N",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_TOPMARGIN INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_TOPMARGIN
super:Init(HyperLabel{"TOPMARGIN","Topmargin","","sysparms_TOPMARGIN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_TOPPACCT INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_TOPPACCT
super:Init(HyperLabel{"TOPPACCT","Toppacct","","sysparms_TOPPACCT"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_VERSION INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_VERSION
super:Init(HyperLabel{"VERSION","Version","","sysparms_VERSION"},"C",10,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS sysparms_yearclosed INHERIT FIELDSPEC
METHOD Init() CLASS sysparms_yearclosed
super:Init(HyperLabel{"yearclosed","Yearclosed","","sysparms_yearclosed"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
