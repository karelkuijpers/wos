CLASS Bank INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Bank
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#banknumber, "Bank accounts", "Number of bankaccount", "" },  "C", 25, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




Define IDM_PERSON_NAME := "Person"
Define IDM_Person_USERID := "parous…ew@™=w"
Define IDM_PERSONBANK_NAME := "PersonBank"
Define IDM_PersonBank_USERID := "parous…ºw@™Ðw"
CLASS Person INHERIT SQLTable
	//USER CODE STARTS HERE (do NOT remove this line)
	EXPORT m51_initials, m51_lastname, m51_firstname, m51_title, m51_prefix, m51_pos, m51_ad1,m51_city, m56_banknumber, m51_cln, m51_exid, m51_country, m51_gender, m51_type as STRING
	EXPORT oLan as Language
	EXPORT md_address1, md_address2, md_address3, md_address4 as STRING
	EXPORT oMcd as PersCod
	EXPORT oPrsBnk as PersonBank 
	declare method SkipExact 
ACCESS accid CLASS Person
 RETURN self:FieldGet(21)
ASSIGN accid(uValue) CLASS Person
 RETURN self:FieldPut(21, uValue)
METHOD ADDMLCodes(NewCodes) CLASS Person
LOCAL aPCod,aNCod as ARRAY, iStart as int
if Empty(NewCodes)
	return
endif
	aPCod:=Split(AllTrim(self:cod)," ")
	aNCod:=Split(AllTrim(NewCodes)," ")
	iStart:=Len(aPCod)
 
	ASize(aPCod,iStart+Len(aNCod))
	ACopy(aNCod,aPCod,1,Len(aNCod),iStart+1) 
	self:cod:=MakeCod(aPCod)	
ACCESS address CLASS Person
 RETURN self:FieldGet(4)
ASSIGN address(uValue) CLASS Person
 RETURN self:FieldPut(4, uValue)
ACCESS attention CLASS Person
 RETURN self:FieldGet(5)
ASSIGN attention(uValue) CLASS Person
 RETURN self:FieldPut(5, uValue)
ACCESS  banknumber  CLASS Person
	if self:oPrsBnk==null_object
		self:oPrsBnk:=PersonBank{}
	endif
	IF self:oPrsBnk:Seek(#persid,self:persid) 
		// return first bankaccount of person
		RETURN self:oPrsBnk:banknumber
	ELSE
		RETURN null_string
	ENDIF
ACCESS BDAT CLASS Person
 RETURN self:FieldGet(17)
ASSIGN BDAT(uValue) CLASS Person
 RETURN self:FieldPut(17, uValue)
ACCESS BIRTHDAT CLASS Person
 RETURN self:FieldGet(26)
ASSIGN BIRTHDAT(uValue) CLASS Person
 RETURN self:FieldPut(26, uValue)
ACCESS city CLASS Person
 RETURN self:FieldGet(10)
ASSIGN city(uValue) CLASS Person
 RETURN self:FieldPut(10, uValue)
ACCESS COD CLASS Person
 RETURN self:FieldGet(16)
ASSIGN COD(uValue) CLASS Person
 RETURN self:FieldPut(16, uValue)
ACCESS country CLASS Person
 RETURN self:FieldGet(11)
ASSIGN country(uValue) CLASS Person
 RETURN self:FieldPut(11, uValue)
ACCESS DLG CLASS Person
 RETURN self:FieldGet(19)
ASSIGN DLG(uValue) CLASS Person
 RETURN self:FieldPut(19, uValue)
ACCESS EMAIL CLASS Person
 RETURN self:FieldGet(23)
ASSIGN EMAIL(uValue) CLASS Person
 RETURN self:FieldPut(23, uValue)
ACCESS EXTERNID CLASS Person
 RETURN self:FieldGet(29)
ASSIGN EXTERNID(uValue) CLASS Person
 RETURN self:FieldPut(29, uValue)
ACCESS FAX CLASS Person
 RETURN self:FieldGet(14)
ASSIGN FAX(uValue) CLASS Person
 RETURN self:FieldPut(14, uValue)
ACCESS firstname CLASS Person
 RETURN self:FieldGet(8)
ASSIGN firstname(uValue) CLASS Person
 RETURN self:FieldPut(8, uValue)
ACCESS GENDER CLASS Person
 RETURN self:FieldGet(27)
ASSIGN GENDER(uValue) CLASS Person
 RETURN self:FieldPut(27, uValue)
ACCESS  GENDERDSCR  CLASS Person
	// Return Gender description of a person:
	LOCAL cGnd:=self:GENDER as int
	RETURN pers_gender[AScan(pers_gender,{|x|x[2]==cGnd}),1]
METHOD Init( cTable, oConn ) CLASS Person
	LOCAL oFS,oHL AS OBJECT

	IF IsNil(cTable)
		cTable := [`person`]
	ENDIF

	IF IsNil(oConn)
		oConn := SQLGetMyConnection( "", IDM_Person_USERID, "" )
	ENDIF

	super:Init( cTable, ;
		{ ;
		[`persid`] , ;
		[`title`] , ;
		[`lastname`] , ;
		[`address`] , ;
		[`attention`] , ;
		[`initials`] , ;
		[`nameext`] , ;
		[`firstname`] , ;
		[`POS`] , ;
		[`city`] , ;
		[`country`] , ;
		[`TEL1`] , ;
		[`TEL2`] , ;
		[`FAX`] , ;
		[`prefix`] , ;
		[`COD`] , ;
		[`BDAT`] , ;
		[`MUTD`] , ;
		[`DLG`] , ;
		[`OPC`] , ;
		[`accid`] , ;
		[`remarks`] , ;
		[`EMAIL`] , ;
		[`MOBILE`] , ;
		[`TYPE`] , ;
		[`BIRTHDAT`] , ;
		[`GENDER`] , ;
		[`PROPEXTR`] , ;
		[`EXTERNID`]   }, oConn )

	oHyperLabel := HyperLabel{IDM_PERSON_NAME,  ;
		"Person",  ;
		,  ;
		"Person" }
	IF oHLStatus = NIL
		self:Seek()
		self:SetPrimaryKey(1)
		self:ScrollUpdateType := SQL_SC_UPD_KEY
		oFS:=Person_CLN{}
		self:SetDataField(1,DataField{[persid] ,oFS})
		oFS:=Person_title{}
		self:SetDataField(2,DataField{[title] ,oFS})
		oFS:=Person_NA1{}
		self:SetDataField(3,DataField{[lastname] ,oFS})
		oFS:=Person_AD1{}
		self:SetDataField(4,DataField{[address] ,oFS})
		oFS:=Person_TAV{}
		self:SetDataField(5,DataField{[attention] ,oFS})
		oFS:=Person_NA2{}
		self:SetDataField(6,DataField{[initials] ,oFS})
		oFS:=Person_NA3{}
		self:SetDataField(7,DataField{[nameext] ,oFS})
		oFS:=Person_VRN{}
		self:SetDataField(8,DataField{[firstname] ,oFS})
		oFS:=Person_POS{}
		self:SetDataField(9,DataField{[POS] ,oFS})
		oFS:=Person_PLA{}
		self:SetDataField(10,DataField{[city] ,oFS})
		oFS:=Person_LAN{}
		self:SetDataField(11,DataField{[country] ,oFS})
		oFS:=Person_TEL1{}
		self:SetDataField(12,DataField{[TEL1] ,oFS})
		oFS:=Person_TEL2{}
		self:SetDataField(13,DataField{[TEL2] ,oFS})
		oFS:=Person_FAX{}
		self:SetDataField(14,DataField{[FAX] ,oFS})
		oFS:=Person_HISN{}
		self:SetDataField(15,DataField{[prefix] ,oFS})
		oFS:=Person_COD{}
		self:SetDataField(16,DataField{[COD] ,oFS})
		oFS:=Person_BDAT{}
		self:SetDataField(17,DataField{[BDAT] ,oFS})
		oFS:=Person_MUTD{}
		self:SetDataField(18,DataField{[MUTD] ,oFS})
		oFS:=Person_DLG{}
		self:SetDataField(19,DataField{[DLG] ,oFS})
		oFS:=Person_OPC{}
		self:SetDataField(20,DataField{[OPC] ,oFS})
		oFS:=Person_REK{}
		self:SetDataField(21,DataField{[accid] ,oFS})
		oFS:=Person_OPM{}
		self:SetDataField(22,DataField{[remarks] ,oFS})
		oFS:=Person_EMAIL{}
		self:SetDataField(23,DataField{[EMAIL] ,oFS})
		oFS:=Person_MOBILE{}
		self:SetDataField(24,DataField{[MOBILE] ,oFS})
		oFS:=Person_TYPE{}
		self:SetDataField(25,DataField{[TYPE] ,oFS})
		oFS:=Person_BIRTHDAT{}
		self:SetDataField(26,DataField{[BIRTHDAT] ,oFS})
		oFS:=Person_GENDER{}
		self:SetDataField(27,DataField{[GENDER] ,oFS})
		oFS:=Person_PROPEXTR{}
		self:SetDataField(28,DataField{[PROPEXTR] ,oFS})
		oFS:=Person_EXTERNID{}
		self:SetDataField(29,DataField{[EXTERNID] ,oFS})
		oHL := NULL_OBJECT
	ENDIF
	
	RETURN SELF
	
ACCESS initials CLASS Person
 RETURN self:FieldGet(6)
ASSIGN initials(uValue) CLASS Person
 RETURN self:FieldPut(6, uValue)
ACCESS lastname CLASS Person
 RETURN self:FieldGet(3)
ASSIGN lastname(uValue) CLASS Person
 RETURN self:FieldPut(3, uValue)
ACCESS MOBILE CLASS Person
 RETURN self:FieldGet(24)
ASSIGN MOBILE(uValue) CLASS Person
 RETURN self:FieldPut(24, uValue)
ACCESS MUTD CLASS Person
 RETURN self:FieldGet(18)
ASSIGN MUTD(uValue) CLASS Person
 RETURN self:FieldPut(18, uValue)
ACCESS nameext CLASS Person
 RETURN self:FieldGet(7)
ASSIGN nameext(uValue) CLASS Person
 RETURN self:FieldPut(7, uValue)
ACCESS OPC CLASS Person
 RETURN self:FieldGet(20)
ASSIGN OPC(uValue) CLASS Person
 RETURN self:FieldPut(20, uValue)
ACCESS persid CLASS Person
 RETURN self:FieldGet(1)
ASSIGN persid(uValue) CLASS Person
 RETURN self:FieldPut(1, uValue)
ACCESS POS CLASS Person
 RETURN self:FieldGet(9)
ASSIGN POS(uValue) CLASS Person
 RETURN self:FieldPut(9, uValue)
ACCESS prefix CLASS Person
 RETURN self:FieldGet(15)
ASSIGN prefix(uValue) CLASS Person
 RETURN self:FieldPut(15, uValue)
ACCESS PROPEXTR CLASS Person
 RETURN self:FieldGet(28)
ASSIGN PROPEXTR(uValue) CLASS Person
 RETURN self:FieldPut(28, uValue)
ACCESS remarks CLASS Person
 RETURN self:FieldGet(22)
ASSIGN remarks(uValue) CLASS Person
 RETURN self:FieldPut(22, uValue)
ACCESS  Salutation  CLASS Person
	// Return salutation of a person:	
 LOCAL cSalut as STRING 
if oLan==null_object
	oLan:=Language{}
endif
DO CASE
	CASE self:GENDER==COUPLE
		cSalut:= oLan:Get("Mr&Mrs")
	CASE self:GENDER==MASCULIN
		cSalut:= oLan:Get("Mr",,"!")
	CASE self:GENDER==FEMALE
		cSalut:= oLan:Get("Mrs",,"!")
ENDCASE
RETURN Trim(cSalut)
ACCESS TEL1 CLASS Person
 RETURN self:FieldGet(12)
ASSIGN TEL1(uValue) CLASS Person
 RETURN self:FieldPut(12, uValue)
ACCESS TEL2 CLASS Person
 RETURN self:FieldGet(13)
ASSIGN TEL2(uValue) CLASS Person
 RETURN self:FieldPut(13, uValue)
ACCESS Title CLASS Person
 RETURN self:FieldGet(2)
ASSIGN Title(uValue) CLASS Person
 RETURN self:FieldPut(2, uValue)
ACCESS  titlele  CLASS Person
	// Return titlele of a person:
	LOCAL ctitle:=self:title, ntitle as int
	LOCAL ctitlele as STRING
	ntitle:=AScan(pers_titles,{|x|x[2]==ctitle})
	IF ntitle>0 
		ctitlele:= pers_titles[ntitle,1]
	ENDIF
return ctitlele
ACCESS TYPE CLASS Person
 RETURN self:FieldGet(25)
ASSIGN TYPE(uValue) CLASS Person
 RETURN self:FieldPut(25, uValue)
ACCESS  TYPEDSCR  CLASS Person
	// Return Gender description of a person:
	LOCAL nTp:=self:TYPE as int
	RETURN pers_types[AScan(pers_types,{|x|x[2]==nTp}),1]
CLASS Person_AD1 INHERIT FIELDSPEC
METHOD Init() CLASS Person_AD1
super:Init(HyperLabel{"address","address","","person_AD1"},"C",40,0)

RETURN SELF
CLASS Person_BDAT INHERIT FIELDSPEC
METHOD Init() CLASS Person_BDAT
super:Init(HyperLabel{"BDAT","Bdat","","person_BDAT"},"D",10,0)

RETURN SELF
CLASS Person_BIRTHDAT INHERIT FIELDSPEC
METHOD Init() CLASS Person_BIRTHDAT
super:Init(HyperLabel{"BIRTHDAT","Birthdat","","person_BIRTHDAT"},"D",10,0)

RETURN SELF
CLASS Person_CLN INHERIT FIELDSPEC
METHOD Init() CLASS Person_CLN
super:Init(HyperLabel{"persid","persid","","person_CLN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Person_COD INHERIT FIELDSPEC
METHOD Init() CLASS Person_COD
super:Init(HyperLabel{"COD","Cod","","person_COD"},"C",30,0)

RETURN SELF
CLASS Person_DLG INHERIT FIELDSPEC
METHOD Init() CLASS Person_DLG
super:Init(HyperLabel{"DLG","Dlg","","person_DLG"},"D",10,0)

RETURN SELF
CLASS Person_EMAIL INHERIT FIELDSPEC
METHOD Init() CLASS Person_EMAIL
super:Init(HyperLabel{"EMAIL","Email","","person_EMAIL"},"C",64,0)

RETURN SELF
CLASS Person_EXTERNID INHERIT FIELDSPEC


METHOD Init() CLASS Person_EXTERNID
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#EXTERNID, "Externid", "", "person_EXTERNID" },  "C", 24, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Person_FAX INHERIT FIELDSPEC
METHOD Init() CLASS Person_FAX
super:Init(HyperLabel{"FAX","Fax","","person_FAX"},"C",18,0)

RETURN SELF
CLASS Person_GENDER INHERIT FIELDSPEC
METHOD Init() CLASS Person_GENDER
super:Init(HyperLabel{"GENDER","Gender","","person_GENDER"},"N",6,0)

RETURN SELF
CLASS Person_HISN INHERIT FIELDSPEC
METHOD Init() CLASS Person_HISN
super:Init(HyperLabel{"prefix","prefix","","person_HISN"},"C",8,0)

RETURN SELF
CLASS Person_LAN INHERIT FIELDSPEC
METHOD Init() CLASS Person_LAN
super:Init(HyperLabel{"country","country","","person_LAN"},"C",20,0)

RETURN SELF
CLASS Person_MOBILE INHERIT FIELDSPEC
METHOD Init() CLASS Person_MOBILE
super:Init(HyperLabel{"MOBILE","Mobile","","person_MOBILE"},"C",18,0)

RETURN SELF
CLASS Person_MUTD INHERIT FIELDSPEC
METHOD Init() CLASS Person_MUTD
super:Init(HyperLabel{"MUTD","Mutd","","person_MUTD"},"D",10,0)

RETURN SELF
CLASS Person_NA1 INHERIT FIELDSPEC
METHOD Init() CLASS Person_NA1
super:Init(HyperLabel{"lastname","lastname","","person_NA1"},"C",28,0)

RETURN SELF
CLASS Person_NA2 INHERIT FIELDSPEC
METHOD Init() CLASS Person_NA2
super:Init(HyperLabel{"initials","initials","","person_NA2"},"C",10,0)

RETURN SELF
CLASS Person_NA3 INHERIT FIELDSPEC
METHOD Init() CLASS Person_NA3
super:Init(HyperLabel{"nameext","nameext","","person_NA3"},"C",28,0)

RETURN SELF
CLASS Person_OPC INHERIT FIELDSPEC
METHOD Init() CLASS Person_OPC
super:Init(HyperLabel{"OPC","Opc","","person_OPC"},"C",10,0)

RETURN SELF
CLASS Person_OPM INHERIT FIELDSPEC
METHOD Init() CLASS Person_OPM
super:Init(HyperLabel{"remarks","remarks","","person_OPM"},"M",10,0)

RETURN SELF
CLASS Person_PLA INHERIT FIELDSPEC
METHOD Init() CLASS Person_PLA
super:Init(HyperLabel{"city","city","","person_PLA"},"C",35,0)

RETURN SELF
CLASS Person_POS INHERIT FIELDSPEC
METHOD Init() CLASS Person_POS
super:Init(HyperLabel{"POS","Pos","","person_POS"},"C",14,0)

RETURN SELF
CLASS Person_PROPEXTR INHERIT FIELDSPEC
METHOD Init() CLASS Person_PROPEXTR
super:Init(HyperLabel{"PROPEXTR","Propextr","","person_PROPEXTR"},"M",10,0)

RETURN SELF
CLASS Person_REK INHERIT FIELDSPEC
METHOD Init() CLASS Person_REK
super:Init(HyperLabel{"accid","accid","","person_REK"},"N",11,0)

RETURN SELF
CLASS Person_salutation INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Person_salutation
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Salutation, "Salutation", "Salutation of a person", "" },  "C", 20, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Person_TAV INHERIT FIELDSPEC
METHOD Init() CLASS Person_TAV
super:Init(HyperLabel{"attention","attention","","person_TAV"},"C",28,0)

RETURN SELF
CLASS Person_TEL1 INHERIT FIELDSPEC
METHOD Init() CLASS Person_TEL1
super:Init(HyperLabel{"TEL1","Tel1","","person_TEL1"},"C",18,0)

RETURN SELF
CLASS Person_TEL2 INHERIT FIELDSPEC
METHOD Init() CLASS Person_TEL2
super:Init(HyperLabel{"TEL2","Tel2","","person_TEL2"},"C",18,0)

RETURN SELF
CLASS Person_TITLE INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Person_TITLE
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#TITLE, "Tit", "", "person_TIT" },  "C", 3, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Person_TYPE INHERIT FIELDSPEC
METHOD Init() CLASS Person_TYPE
super:Init(HyperLabel{"TYPE","Type","","person_TYPE"},"N",6,0)

RETURN SELF
CLASS Person_VRN INHERIT FIELDSPEC
METHOD Init() CLASS Person_VRN
super:Init(HyperLabel{"firstname","firstname","","person_VRN"},"C",20,0)

RETURN SELF
CLASS PersonBank INHERIT SQLTable
ACCESS banknumber CLASS PersonBank
 RETURN self:FieldGet(2)
ASSIGN banknumber(uValue) CLASS PersonBank
 RETURN self:FieldPut(2, uValue)
METHOD Init( cTable, oConn ) CLASS PersonBank
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`personbank`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_PersonBank_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`persid`] , ;
   [`banknumber`]   }, oConn )

oHyperLabel := HyperLabel{IDM_PERSONBANK_NAME,  ;
   "PersonBank",  ;
   ,  ;
   "PersonBank" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    self:SetPrimaryKey(2)
    oFS:=PersonBank_CLN{}
    self:SetDataField(1,DataField{[persid] ,oFS})
    oFS:=PersonBank_GIRONR{}
    self:SetDataField(2,DataField{[banknumber] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS persid CLASS PersonBank
 RETURN self:FieldGet(1)
ASSIGN persid(uValue) CLASS PersonBank
 RETURN self:FieldPut(1, uValue)
CLASS PersonBank_CLN INHERIT FIELDSPEC
METHOD Init() CLASS PersonBank_CLN
super:Init(HyperLabel{"persid","persid","","personbank_CLN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS PersonBank_GIRONR INHERIT FIELDSPEC
METHOD Init() CLASS PersonBank_GIRONR
super:Init(HyperLabel{"banknumber","banknumber","","personbank_GIRONR"},"C",25,0)
self:SetRequired(.T.,)

RETURN SELF
ACCESS  banknumber  CLASS SQLSelectPerson
	if self:oPrsBnk==null_object
		self:oPrsBnk:=PersonBank{}
	endif
	IF self:oPrsBnk:Seek(#persid,self:persid) 
		// return first bankaccount of person
		RETURN self:oPrsBnk:banknumber
	ELSE
		RETURN null_string
	ENDIF
ACCESS  titlele  CLASS SQLSelectPerson
	// Return titlele of a person:
	LOCAL ctitle:=self:title, ntitle as int
	LOCAL ctitlele as STRING
	ntitle:=AScan(pers_titles,{|x|x[2]==ctitle})
	IF ntitle>0 
		ctitlele:= pers_titles[ntitle,1]
	ENDIF
return ctitlele
