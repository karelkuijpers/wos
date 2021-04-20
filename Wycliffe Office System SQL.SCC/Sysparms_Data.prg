Define IDM_IPCACCOUNTS_NAME := "IPCAccounts"
Define IDM_IPCAccounts_USERID := "parouÿÐHÍwÐ€‡v"
Define IDM_PPCODES_NAME := "PPCodes"
Define IDM_PPCodes_USERID := "parouÿ…ºw@™Ðw"
Define IDM_SYSPARMS_NAME := "Sysparms"
Define IDM_Sysparms_USERID := "parouÿÐHwÐ€v"
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
CLASS sysparms_PMCCURRENCY INHERIT sysparms_PMCUPLD


METHOD Init() CLASS sysparms_PMCCURRENCY
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#PMCCURRENCY, "", "", "sysparms_PMCCURRENCY" },  "N", 12, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

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
