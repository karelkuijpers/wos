global aAsmt as array
GLOBAL aBalType:={} as ARRAY 
GLOBAL ADMIN as STRING
global aLanM:={} as array    // language table of menu items
global aLanR:={} as array    // language table of report items
global aLanW:={} as array    // language table of window items
GLOBAL Alg_Taal as STRING
GLOBAL AutoGiro as LOGIC
GLOBAL BankAccs:={} as ARRAY
GLOBAL BANKNBRCRE as STRING
GLOBAL BANKNBRDEB as STRING
GLOBAL BICNBRCRE as STRING
GLOBAL BICNBRDEB as STRING
global cAccAlwd as string
GLOBAL cdate  as STRING
global cDepmntIncl as string
global cDepmntXtr as string 
Global CITYUPC as logic
GLOBAL ClosingMonth as int
Global Collate as string // can be used for order by to conform local alphabet order 
GLOBAL CountryCode as string
GLOBAL CurPath as STRING
global dbname as string
GLOBAL DecAantal:= 2 as SHORT
global DecSeparator as string

GLOBAL Departments as LOGIC
GLOBAL DistributionTypes:={'fixed amount','proportional amount','remaining','remaining RPP'}
global emailclient as string 
 
GLOBAL EXCEL as STRING
global FirstLogin as logic  // first login user this day?
global GlBalYears:={} as Array
GLOBAL HelpDir:="C:" as STRING
global iban_registry as array
GLOBAL KeyWords as ARRAY
GLOBAL LENACCNBR:=12 as int
GLOBAL LENBANKNBR as int
Global LENEXTID as int
GLOBAL LENPRSID as int
GLOBAL lInitial as LOGIC
GLOBAL Listseparator as STRING
global LocalDateFormat as string
GLOBAL LOGON_EMP_ID  as STRING

global lRecreateIndex as logic
global LstCurRate as logic
Global LSTNUPC as logic
global LstYearClosed as date      // before this date years are closed, i.e. start of current year
GLOBAL maand := ;
{'January','February','March','April','May','June','July','August',;
'September','October','November','December'} as ARRAY
global mail_abrv as array
GLOBAL mdw as STRING
GLOBAL MemberStates := {'MIT','STA','JM','SM','Entity','Entity 19999','Staf'} as ARRAY
GLOBAL MinDate as date
GLOBAL  mmj as STRING
GLOBAL MonthEn := ;
{'January','February','March','April','May','June','July','August',;
'September','October','November','December'} as ARRAY
GLOBAL MultiDest as LOGIC
GLOBAL myApp as App
GLOBAL MYEMPID as STRING 
GLOBAL NoErrorMsg as LOGIC
global oConn as SQLConnection 

GLOBAL oMainWindow as StandardWycWindow
GLOBAL OwnCountryNames as ARRAY
GLOBAL PaymentDescription:={} as ARRAY
GLOBAL pers_codes as ARRAY
GLOBAL pers_gender as ARRAY 
GLOBAL pers_propextra as ARRAY
global pers_salut as array
GLOBAL pers_titles as ARRAY
GLOBAL pers_types as ARRAY
GLOBAL pers_types_abrv as ARRAY
global Posting as logic
GLOBAL prop_types as ARRAY
global requiredemailclient as int
GLOBAL sam as STRING
GLOBAL samFld as STRING
GLOBAL samProj as STRING
GLOBAL SCLC as STRING
GLOBAL sCRE as string   // account payable
GLOBAL sCURR as STRING
GLOBAL sCURRNAME as STRING
GLOBAL SDEB as STRING   //account receivable 
GLOBAL SDON as STRING
GLOBAL SEntity as STRING
global SepaEnabled as logic
GLOBAL SEXP as STRING
GLOBAL SEXPHOME as STRING
global SFGC as string
GLOBAL sFirstNmInAdr as LOGIC
GLOBAL SHB as STRING
global sIdentChar as string
global sIDORG as string
GLOBAL SINC as STRING
GLOBAL SINCHOME as STRING
global sInhdField as float
global sInhdKntr as float
global sInhdKntrH as float
global sInhdKntrL as float
global sInhdKntrM as float
GLOBAL SKAP as STRING
GLOBAL SKAS as STRING
GLOBAL SKruis as STRING
	
GLOBAL SLAND as STRING
GLOBAL SPOSTZ as STRING
GLOBAL SPROJ as STRING
GLOBAL sSalutation as LOGIC
GLOBAL sSTRZIPCITY as int
GLOBAL sSurnameFirst as LOGIC
Global sToPP as string
Global SuperUser:=false as logic
GLOBAL TeleBanking as LOGIC 
Global TITELINADR as logic
GLOBAL UserType as STRING
Global USRTypes as array
global Version:="3.0.0.162" as string
global Versiondate:= __date__ as string
GLOBAL WinIniFS as WinIniFileSpec
GLOBAL WinScale as FLOAT
GLOBAL WycIniFS as IniFileSpec
