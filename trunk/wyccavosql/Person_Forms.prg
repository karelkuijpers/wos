STATIC DEFINE _EDITPERSONWINDOW_AD1 := 129 
STATIC DEFINE _EDITPERSONWINDOW_BDAT := 146 
STATIC DEFINE _EDITPERSONWINDOW_CANCELBUTTON := 149 
STATIC DEFINE _EDITPERSONWINDOW_CLN := 126 
STATIC DEFINE _EDITPERSONWINDOW_COD := 138 
STATIC DEFINE _EDITPERSONWINDOW_DLG := 150 
STATIC DEFINE _EDITPERSONWINDOW_EMAIL := 137 
STATIC DEFINE _EDITPERSONWINDOW_FAX := 135 
STATIC DEFINE _EDITPERSONWINDOW_FIXEDTEXT21 := 153 
STATIC DEFINE _EDITPERSONWINDOW_GIRONR := 136 
STATIC DEFINE _EDITPERSONWINDOW_GROUPBOX1 := 152 
STATIC DEFINE _EDITPERSONWINDOW_HISN := 124 
STATIC DEFINE _EDITPERSONWINDOW_LAN := 132 
STATIC DEFINE _EDITPERSONWINDOW_MCOD1 := 139 
STATIC DEFINE _EDITPERSONWINDOW_MCOD2 := 140 
STATIC DEFINE _EDITPERSONWINDOW_MCOD3 := 141 
STATIC DEFINE _EDITPERSONWINDOW_MCOD4 := 142 
STATIC DEFINE _EDITPERSONWINDOW_MCOD5 := 143 
STATIC DEFINE _EDITPERSONWINDOW_MCOD6 := 144 
STATIC DEFINE _EDITPERSONWINDOW_MUTD := 147 
STATIC DEFINE _EDITPERSONWINDOW_NA1 := 121 
STATIC DEFINE _EDITPERSONWINDOW_NA2 := 123 
STATIC DEFINE _EDITPERSONWINDOW_NA3 := 127 
STATIC DEFINE _EDITPERSONWINDOW_OKBUTTON := 148 
STATIC DEFINE _EDITPERSONWINDOW_OPC := 151 
STATIC DEFINE _EDITPERSONWINDOW_OPM := 145 
STATIC DEFINE _EDITPERSONWINDOW_PLA := 131 
STATIC DEFINE _EDITPERSONWINDOW_POS := 130 
STATIC DEFINE _EDITPERSONWINDOW_SC_AD1 := 103 
STATIC DEFINE _EDITPERSONWINDOW_SC_BDAT := 115 
STATIC DEFINE _EDITPERSONWINDOW_SC_CLN := 100 
STATIC DEFINE _EDITPERSONWINDOW_SC_DLG := 117 
STATIC DEFINE _EDITPERSONWINDOW_SC_FAX := 113 
STATIC DEFINE _EDITPERSONWINDOW_SC_HISN := 114 
STATIC DEFINE _EDITPERSONWINDOW_SC_LAN := 110 
STATIC DEFINE _EDITPERSONWINDOW_SC_MUTD := 116 
STATIC DEFINE _EDITPERSONWINDOW_SC_NA1 := 102 
STATIC DEFINE _EDITPERSONWINDOW_SC_NA2 := 105 
STATIC DEFINE _EDITPERSONWINDOW_SC_NA3 := 106 
STATIC DEFINE _EDITPERSONWINDOW_SC_OPC := 118 
STATIC DEFINE _EDITPERSONWINDOW_SC_OPM := 120 
STATIC DEFINE _EDITPERSONWINDOW_SC_PLA := 109 
STATIC DEFINE _EDITPERSONWINDOW_SC_POS := 108 
STATIC DEFINE _EDITPERSONWINDOW_SC_TAV := 104 
STATIC DEFINE _EDITPERSONWINDOW_SC_TEL1 := 111 
STATIC DEFINE _EDITPERSONWINDOW_SC_TEL2 := 112 
STATIC DEFINE _EDITPERSONWINDOW_SC_TIT := 101 
STATIC DEFINE _EDITPERSONWINDOW_SC_VRN := 107 
STATIC DEFINE _EDITPERSONWINDOW_TAV := 128 
STATIC DEFINE _EDITPERSONWINDOW_TEL1 := 133 
STATIC DEFINE _EDITPERSONWINDOW_TEL2 := 134 
STATIC DEFINE _EDITPERSONWINDOW_TIT := 122 
STATIC DEFINE _EDITPERSONWINDOW_VRN := 125 
STATIC DEFINE EDITPERSONWINDOW_mAddress := 123 
STATIC DEFINE EDITPERSONWINDOW_mCity := 125 
STATIC DEFINE EDITPERSONWINDOW_MCOD := 130 
STATIC DEFINE EDITPERSONWINDOW_mCountry := 126 
STATIC DEFINE EDITPERSONWINDOW_MFAX := 129 
STATIC DEFINE EDITPERSONWINDOW_mFirstname := 120 
STATIC DEFINE EDITPERSONWINDOW_MHISN := 117 
STATIC DEFINE EDITPERSONWINDOW_mInitials := 119 
STATIC DEFINE EDITPERSONWINDOW_mLastname := 116 
STATIC DEFINE EDITPERSONWINDOW_MNA3 := 121 
STATIC DEFINE EDITPERSONWINDOW_MOPM := 131 
STATIC DEFINE EDITPERSONWINDOW_MPOS := 124 
STATIC DEFINE EDITPERSONWINDOW_MTAV := 122 
STATIC DEFINE EDITPERSONWINDOW_MTEL1 := 127 
STATIC DEFINE EDITPERSONWINDOW_MTEL2 := 128 
STATIC DEFINE EDITPERSONWINDOW_MTIT := 118 
Function GetBankSeqNbr(cDescr as string) as int
return Val(ATail(Split(Split(cDescr,":")[1])))
CLASS ListboxPayments INHERIT ListBoxExtra
STATIC DEFINE MARKUPLETTER_EDITLETTER := 100 
STATIC DEFINE MARKUPLETTER_KEYWORD := 102 
STATIC DEFINE MARKUPLETTER_SAVEBUTTON := 101 
CLASS memberaccount INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS memberaccount
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#MemberAccount, "", "The Account which the member owns", "" },  "C", 40, 0 )
    cPict       := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




RESOURCE NewPersonWindow DIALOGEX  125, 102, 501, 614
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Lastname:", NEWPERSONWINDOW_SC_NA1, "Static", WS_CHILD, 11, 9, 35, 13
	CONTROL	"Prefix:", NEWPERSONWINDOW_SC_HISN, "Static", WS_CHILD, 211, 9, 42, 13
	CONTROL	"First (&&middle) name(s):", NEWPERSONWINDOW_SC_VRN, "Static", WS_CHILD, 11, 19, 51, 17
	CONTROL	"Initials:", NEWPERSONWINDOW_SC_NA2, "Static", WS_CHILD, 211, 23, 23, 12
	CONTROL	"Name extension:", NEWPERSONWINDOW_SC_NA3, "Static", WS_CHILD, 10, 36, 54, 12
	CONTROL	"Title:", NEWPERSONWINDOW_SC_TIT, "Static", WS_CHILD, 211, 36, 35, 13
	CONTROL	"Street+number:", NEWPERSONWINDOW_SC_AD1, "Static", WS_CHILD, 11, 66, 48, 12
	CONTROL	"Zip code:", NEWPERSONWINDOW_SC_POS, "Static", WS_CHILD, 11, 80, 32, 12
	CONTROL	"City:", NEWPERSONWINDOW_SC_PLA, "Static", WS_CHILD, 104, 80, 16, 12
	CONTROL	"Attention:", NEWPERSONWINDOW_SC_TAV, "Static", WS_CHILD, 211, 66, 32, 12
	CONTROL	"Country:", NEWPERSONWINDOW_SC_LAN, "Static", WS_CHILD, 211, 79, 28, 12
	CONTROL	"Business:", NEWPERSONWINDOW_SC_TEL1, "Static", WS_CHILD, 10, 110, 35, 13
	CONTROL	"Home:", NEWPERSONWINDOW_SC_TEL2, "Static", WS_CHILD, 211, 110, 23, 12
	CONTROL	"Fax:", NEWPERSONWINDOW_SC_FAX, "Static", WS_CHILD, 11, 123, 16, 12
	CONTROL	"Remarks:", NEWPERSONWINDOW_SC_OPM, "Static", WS_CHILD, 211, 177, 32, 12
	CONTROL	"", NEWPERSONWINDOW_MLASTNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 65, 9, 143, 13
	CONTROL	"", NEWPERSONWINDOW_MPREFIX, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 252, 7, 133, 12
	CONTROL	"", NEWPERSONWINDOW_MFIRSTNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 65, 23, 143, 12
	CONTROL	"", NEWPERSONWINDOW_MINITIALS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 252, 22, 133, 12
	CONTROL	"", NEWPERSONWINDOW_MNAMEEXT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 65, 36, 143, 13
	CONTROL	"Salutation", NEWPERSONWINDOW_MTITLE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 252, 36, 133, 72
	CONTROL	"", NEWPERSONWINDOW_MADDRESS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 65, 66, 143, 12
	CONTROL	"", NEWPERSONWINDOW_MPOSTALCODE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 64, 80, 37, 12
	CONTROL	"", NEWPERSONWINDOW_MCITY, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 120, 80, 88, 12
	CONTROL	"", NEWPERSONWINDOW_MATTENTION, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 252, 66, 133, 12
	CONTROL	"", NEWPERSONWINDOW_MCOUNTRY, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 252, 81, 133, 12
	CONTROL	"", NEWPERSONWINDOW_MTELBUSINESS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 65, 109, 143, 12
	CONTROL	"", NEWPERSONWINDOW_MTELHOME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 252, 110, 133, 13
	CONTROL	"", NEWPERSONWINDOW_MFAX, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 65, 123, 143, 12
	CONTROL	"", NEWPERSONWINDOW_MMOBILE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 252, 125, 133, 12
	CONTROL	"", NEWPERSONWINDOW_MBANKNUMBER, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 65, 146, 130, 12
	CONTROL	"v", NEWPERSONWINDOW_BANKBUTTON, "Button", WS_CHILD, 195, 146, 13, 12
	CONTROL	"", NEWPERSONWINDOW_BANKBOX, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 64, 158, 144, 73, WS_EX_CLIENTEDGE
	CONTROL	"", NEWPERSONWINDOW_MEMAIL, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 252, 147, 133, 13, WS_EX_CLIENTEDGE
	CONTROL	"", NEWPERSONWINDOW_MREMARKS, "Edit", ES_WANTRETURN|ES_AUTOHSCROLL|ES_AUTOVSCROLL|ES_MULTILINE|WS_TABSTOP|WS_CHILD|WS_BORDER, 252, 177, 230, 54
	CONTROL	"", NEWPERSONWINDOW_MTYPE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 101, 240, 143, 160
	CONTROL	"", NEWPERSONWINDOW_MBIRTHDATE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_CLIPSIBLINGS|WS_BORDER, 101, 256, 143, 12
	CONTROL	"", NEWPERSONWINDOW_MGENDER, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 340, 240, 142, 63
	CONTROL	"", NEWPERSONWINDOW_MCOD1, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 410, 51, 73, 72
	CONTROL	"", NEWPERSONWINDOW_MCOD2, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 410, 63, 73, 72
	CONTROL	"", NEWPERSONWINDOW_MCOD3, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 410, 75, 73, 72
	CONTROL	"", NEWPERSONWINDOW_MCOD4, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 410, 86, 73, 72
	CONTROL	"", NEWPERSONWINDOW_MCOD5, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 410, 98, 73, 72
	CONTROL	"", NEWPERSONWINDOW_MCOD6, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 410, 110, 73, 72
	CONTROL	"", NEWPERSONWINDOW_MCOD7, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 410, 121, 73, 72
	CONTROL	"", NEWPERSONWINDOW_MCOD8, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 410, 133, 73, 72
	CONTROL	"", NEWPERSONWINDOW_MCOD9, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 410, 145, 73, 72
	CONTROL	"", NEWPERSONWINDOW_MCOD10, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 410, 156, 73, 72
	CONTROL	"OK", NEWPERSONWINDOW_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 440, 7, 46, 12
	CONTROL	"Cancel", NEWPERSONWINDOW_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 389, 7, 47, 12
	CONTROL	"", NEWPERSONWINDOW_MCREATIONDATE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_CLIPSIBLINGS|WS_BORDER, 65, 286, 143, 13
	CONTROL	"Email:", NEWPERSONWINDOW_FIXEDTEXT21, "Static", WS_CHILD, 211, 147, 22, 12
	CONTROL	"Bank/Giro:", NEWPERSONWINDOW_SC_BANKNUMBER, "Static", WS_CHILD, 11, 147, 53, 23
	CONTROL	"Intern ID:", NEWPERSONWINDOW_SC_CLN, "Static", WS_CHILD, 400, 288, 30, 12
	CONTROL	"Mailing codes", NEWPERSONWINDOW_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 404, 40, 86, 134
	CONTROL	"PersonNbr:", NEWPERSONWINDOW_MPERSID, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_BORDER, 433, 288, 43, 12, WS_EX_TRANSPARENT
	CONTROL	"Creation:", NEWPERSONWINDOW_SC_BDAT, "Static", WS_CHILD, 11, 288, 31, 13
	CONTROL	"Altered:", NEWPERSONWINDOW_SC_MUTD, "Static", WS_CHILD, 11, 301, 30, 12
	CONTROL	"Last gift:", NEWPERSONWINDOW_SC_DLG, "Static", WS_CHILD, 211, 288, 33, 12
	CONTROL	"By:", NEWPERSONWINDOW_SC_OPC, "Static", WS_CHILD, 211, 301, 18, 12
	CONTROL	"", NEWPERSONWINDOW_MALTERDATE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_CLIPSIBLINGS|WS_BORDER, 65, 300, 143, 13, WS_EX_TRANSPARENT
	CONTROL	"", NEWPERSONWINDOW_MDATELASTGIFT, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 252, 288, 133, 12
	CONTROL	"", NEWPERSONWINDOW_MOPC, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 252, 299, 133, 12
	CONTROL	"Name:", NEWPERSONWINDOW_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 6, 1, 383, 53
	CONTROL	"Address:", NEWPERSONWINDOW_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 6, 57, 383, 40
	CONTROL	"Telephone:", NEWPERSONWINDOW_GROUPBOX4, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 6, 100, 383, 40
	CONTROL	"System:", NEWPERSONWINDOW_GROUPBOXSYSTEM, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 6, 278, 478, 38
	CONTROL	"Mobile:", NEWPERSONWINDOW_SC_TEL3, "Static", WS_CHILD, 211, 125, 23, 12
	CONTROL	"Personal:", NEWPERSONWINDOW_GROUPBOXPERSONAL, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 6, 232, 480, 43, WS_EX_TRANSPARENT
	CONTROL	"Birthdate:", NEWPERSONWINDOW_SC_BDAT1, "Static", WS_CHILD, 11, 256, 53, 13
	CONTROL	"Type:", NEWPERSONWINDOW_SC_BDAT2, "Static", WS_CHILD, 11, 240, 87, 14
	CONTROL	"Gender:", NEWPERSONWINDOW_SC_TEL4, "Static", WS_CHILD, 250, 240, 90, 12
	CONTROL	"", NEWPERSONWINDOW_MPROPEXTR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 264, 256, 54, 12, WS_EX_CLIENTEDGE
	CONTROL	"Extern ID:", NEWPERSONWINDOW_SC_EXTERNID, "Static", WS_CHILD, 400, 302, 33, 13
	CONTROL	"ExternID", NEWPERSONWINDOW_MEXTERNID, "Edit", ES_AUTOHSCROLL|WS_CHILD|WS_BORDER, 433, 300, 43, 13
	CONTROL	"Gifts", NEWPERSONWINDOW_GIFTSBUTTON, "Button", WS_TABSTOP|WS_CHILD, 440, 22, 46, 12
	CONTROL	"Donations", NEWPERSONWINDOW_DONATIONSBUTTON, "Button", WS_TABSTOP|WS_CHILD, 389, 22, 47, 13
END

CLASS NewPersonWindow INHERIT DataWindowExtra 

	PROTECT oDCSC_NA1 AS FIXEDTEXT
	PROTECT oDCSC_HISN AS FIXEDTEXT
	PROTECT oDCSC_VRN AS FIXEDTEXT
	PROTECT oDCSC_NA2 AS FIXEDTEXT
	PROTECT oDCSC_NA3 AS FIXEDTEXT
	PROTECT oDCSC_TIT AS FIXEDTEXT
	PROTECT oDCSC_AD1 AS FIXEDTEXT
	PROTECT oDCSC_POS AS FIXEDTEXT
	PROTECT oDCSC_PLA AS FIXEDTEXT
	PROTECT oDCSC_TAV AS FIXEDTEXT
	PROTECT oDCSC_LAN AS FIXEDTEXT
	PROTECT oDCSC_TEL1 AS FIXEDTEXT
	PROTECT oDCSC_TEL2 AS FIXEDTEXT
	PROTECT oDCSC_FAX AS FIXEDTEXT
	PROTECT oDCSC_OPM AS FIXEDTEXT
	PROTECT oDCmLastName AS SINGLELINEEDIT
	PROTECT oDCmPrefix AS SINGLELINEEDIT
	PROTECT oDCmFirstName AS SINGLELINEEDIT
	PROTECT oDCmInitials AS SINGLELINEEDIT
	PROTECT oDCmNameExt AS SINGLELINEEDIT
	PROTECT oDCmTitle AS COMBOBOX
	PROTECT oDCmAddress AS SINGLELINEEDIT
	PROTECT oDCmPostalcode AS SINGLELINEEDIT
	PROTECT oDCmCity AS SINGLELINEEDIT
	PROTECT oDCmAttention AS SINGLELINEEDIT
	PROTECT oDCmCountry AS SINGLELINEEDIT
	PROTECT oDCmTelbusiness AS SINGLELINEEDIT
	PROTECT oDCmTelhome AS SINGLELINEEDIT
	PROTECT oDCmFAX AS SINGLELINEEDIT
	PROTECT oDCmMobile AS SINGLELINEEDIT
	PROTECT oDCmBankNumber AS SINGLELINEEDIT
	PROTECT oCCBankButton AS PUSHBUTTON
	PROTECT oDCBankBox AS LISTBOX
	PROTECT oDCmEmail AS SINGLELINEEDIT
	PROTECT oDCmRemarks AS MULTILINEEDIT
	PROTECT oDCmType AS COMBOBOX
	PROTECT oDCmBirthDate AS SINGLELINEEDIT
	PROTECT oDCmGender AS COMBOBOX
	PROTECT oDCmCod1 AS COMBOBOX
	PROTECT oDCmCod2 AS COMBOBOX
	PROTECT oDCmCod3 AS COMBOBOX
	PROTECT oDCmCod4 AS COMBOBOX
	PROTECT oDCmCod5 AS COMBOBOX
	PROTECT oDCmCod6 AS COMBOBOX
	PROTECT oDCmCod7 AS COMBOBOX
	PROTECT oDCmCod8 AS COMBOBOX
	PROTECT oDCmCod9 AS COMBOBOX
	PROTECT oDCmCod10 AS COMBOBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCmcreationdate AS SINGLELINEEDIT
	PROTECT oDCFixedText21 AS FIXEDTEXT
	PROTECT oDCSC_BankNumber AS FIXEDTEXT
	PROTECT oDCSC_CLN AS FIXEDTEXT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCmPersid AS SINGLELINEEDIT
	PROTECT oDCSC_BDAT AS FIXEDTEXT
	PROTECT oDCSC_MUTD AS FIXEDTEXT
	PROTECT oDCSC_DLG AS FIXEDTEXT
	PROTECT oDCSC_OPC AS FIXEDTEXT
	PROTECT oDCmalterdate AS SINGLELINEEDIT
	PROTECT oDCmdatelastgift AS SINGLELINEEDIT
	PROTECT oDCmOPC AS SINGLELINEEDIT
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCGroupBox3 AS GROUPBOX
	PROTECT oDCGroupBox4 AS GROUPBOX
	PROTECT oDCGroupBoxSystem AS GROUPBOX
	PROTECT oDCSC_TEL3 AS FIXEDTEXT
	PROTECT oDCGroupBoxPersonal AS GROUPBOX
	PROTECT oDCSC_BDAT1 AS FIXEDTEXT
	PROTECT oDCSC_BDAT2 AS FIXEDTEXT
	PROTECT oDCSC_TEL4 AS FIXEDTEXT
	PROTECT oDCmPropExtr AS SINGLELINEEDIT
	PROTECT oDCSC_Externid AS FIXEDTEXT
	PROTECT oDCmExternid AS SINGLELINEEDIT
	PROTECT oCCGiftsButton AS PUSHBUTTON
	PROTECT oCCDonationsButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
//   INSTANCE 	mLastName
// 	INSTANCE mPrefix
// 	INSTANCE mFirstName
// 	INSTANCE mInitials
// 	INSTANCE mNameExt
// 	INSTANCE mTitle
// 	INSTANCE mAddress
// 	INSTANCE mPostalcode
// 	INSTANCE mCity
// 	INSTANCE mAttention
// 	INSTANCE mCountry
// 	INSTANCE mTelbusiness
// 	INSTANCE mTelhome
// 	INSTANCE mFAX
// 	INSTANCE mMobile
// 	INSTANCE mBankNumber
// 	INSTANCE mEmail
// 	INSTANCE mRemarks
// 	INSTANCE mType
// 	INSTANCE mBirthDate
// 	INSTANCE mGender
// 	INSTANCE mExternid
 
  PROTECT lAddressChanged as LOGIC
  PROTECT oCaller AS OBJECT
  EXPORT mrek as int
  Protect mCodInt as STRING
  PROTECT nCurRec AS INT
  PROTECT aBankAcc:={}, OrigaBank:={} as ARRAY 
  protect oPerson as SQLSelect
  EXPORT lInitials,lSalutation,lMiddleName, lLastName, lFirstName, lAddress, lCity, lZipCode,lExID as LOGIC 
  Export ReplaceDuplicates, lExtraInitialised as logic 
  protect curmAddress, curmPos,curmCity,Curlastname,CurNa2,CurHisn as string

  EXPORT aPropEx:={} as ARRAY 
  export oPersCnt as PersonContainer
  
  
Method AddBankAcc(cBankAcc) Class NewPersonWindow
// add a bank account to person:
LOCAL cDescr:="Bank# " 
cBankAcc:=StrTran(StrTran(AllTrim(cBankAcc),".")," ") 
IF AScan(aBankAcc,{|x|x[2]==cBankAcc})==0
	AAdd(aBankAcc,{cDescr+" "+Str(Len(aBankAcc)+1,-1)+": "+AllTrim(cBankAcc),cBankAcc})
	if Len(aBankAcc)==1
		self:oDCSC_BankNumber:TextValue:=cDescr+" 1:" 
		self:oDCmBanknumber:VALUE:=cBankAcc
	endif		
endif
return
ACCESS BankBox() CLASS NewPersonWindow
RETURN SELF:FieldGet(#BankBox)

ASSIGN BankBox(uValue) CLASS NewPersonWindow
SELF:FieldPut(#BankBox, uValue)
RETURN uValue

METHOD BankButton( ) CLASS NewPersonWindow
	LOCAL cBank, cDescr:="Bank# " AS STRING, nBpos AS INT
	IF !Empty(SELF:aBankAcc)
		IF CountryCode=="47"
			cDescr:="Bank/KID "
		ENDIF
		
		IF !Empty(aBankAcc[Len(aBankAcc),2])
			AAdd(aBankAcc,{cDescr+Str(Len(aBankAcc)+1,-1)+": ",""})
		ENDIF
		oDCBankBox:FillUsing(aBankAcc)
		oDCBankBox:Show()
		cBank:=ZeroTrim(StrTran(StrTran(oDCmBanknumber:Value,".",""),",",'')) 
		nBpos:=AScan(aBankAcc,{|x| x[2]==cBank})
		IF nBpos>0
			oDCBankBox:CurrentItemNo:=nBpos
		ENDIF
		oDCBankBox:SetFocus()
	ENDIF
	RETURN NIL
METHOD CancelButton() CLASS NewPersonWindow
	IF lAddressChanged
       	IF IsObject(oCaller)
       		IF IsMethod(oCaller,#Regperson)
       			oCaller:Regperson(SELF:Server)
       		ENDIF
       	ENDIF
	ENDIF
	IF SELF:lImport
		//SELF:NextImport(SELF)
		self:oImport:NextImport(self,false)
		RETURN
	ENDIF

	SELF:EndWindow()
	
	RETURN
Method ClearBankAccs() class NewPersonWindow
// clear bank accounts 
self:aBankAcc:={}
self:oDCmBankNumber:Value:=""
self:OrigaBank:={}
METHOD DonationsButton( ) CLASS NewPersonWindow 
// inquiry of donations of this person
local oSubBrws as SubscriptionBrowser
oSubBrws:=SubscriptionBrowser{self:owner,,,"p.persid="+self:mPersid+" and category='D'"}
oSubBrws:cType:="DONATIONS"
oSubBrws:Show()
RETURN NIL
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS NewPersonWindow
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	LOCAL cDescr:="Bank# " as STRING
	LOCAL aToken:={} as ARRAY 

	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF CountryCode=="47"
		cDescr:="Bank/KID "
	ENDIF
	IF !lGotFocus
		IF oControl:NameSym == #mBanknumber 
			self:UpdBankAcc(oControl:TextValue)
		ELSEif CountryCode=="31" .and.Empty(AllTrim(self:oDCmCountry:TextValue))
			if oControl:NameSym == #mAddress.and. !AllTrim(oControl:TextValue)==self:curmAddress 
				self:curmAddress:=AllTrim(oControl:TextValue)
				aToken:=ExtractPostCode(self:curmCity,self:curmAddress,self:curmPos)
				self:oDCmPostalcode:Value:=aToken[1]
				self:curmPos:=aToken[1] 
				self:oDCmCity:VALUE:=aToken[3] 
				self:curmCity:=aToken[3]
				self:oDCmAddress:VALUE:=aToken[2]
				self:curmAddress:=aToken[2]
			elseif oControl:NameSym == #mCity.and. !AllTrim(oControl:TextValue)==self:curmCity 
				self:curmCity:=AllTrim(oControl:TextValue)
				aToken:=ExtractPostCode(self:curmCity,self:curmAddress,self:curmPos)
				self:oDCmPostalcode:Value:=aToken[1] 
				self:curmPos:=aToken[1] 
				self:oDCmCity:VALUE:=aToken[3] 
				self:curmCity:=aToken[3]
				self:oDCmAddress:VALUE:=aToken[2]
				self:curmAddress:=aToken[2]
			elseif oControl:NameSym == #mPostalcode.and. !AllTrim(oControl:TextValue)==self:curmPos
				self:curmPos:=AllTrim(oControl:TextValue)
				aToken:=ExtractPostCode(self:curmCity,self:curmAddress,self:curmPos)
				self:oDCmPostalcode:Value:=aToken[1] 
				self:curmPos:=aToken[1] 
				self:oDCmCity:VALUE:=aToken[3] 
				self:curmCity:=aToken[3]
				self:oDCmAddress:VALUE:=aToken[2]
				self:curmAddress:=aToken[2]
			endif
		ENDIF
	ELSE
		IF !oControl:NameSym == #BankBox .and. !oControl:NameSym == #BankButton
			oDCBankBox:Hide()
		ENDIF
	ENDIF

	RETURN NIL
METHOD GiftsButton( ) CLASS NewPersonWindow 
// inquiry of transactions of this person 
local oTransInq as TransInquiry 
oTransInq:=TransInquiry{self:Owner,,,"p.persid="+self:mPersid+" and t.dat>='"+SQLdate(Today()-365)+"'"} 
oTransInq:Show()
RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS NewPersonWindow 
LOCAL DIM aBrushes[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"NewPersonWindow",_GetInst()},iCtlID)

aBrushes[1] := Brush{Color{215,217,217}}

oDCSC_NA1 := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_NA1,_GetInst()}}
oDCSC_NA1:HyperLabel := HyperLabel{#SC_NA1,"Lastname:",NULL_STRING,NULL_STRING}

oDCSC_HISN := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_HISN,_GetInst()}}
oDCSC_HISN:HyperLabel := HyperLabel{#SC_HISN,"Prefix:",NULL_STRING,NULL_STRING}

oDCSC_VRN := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_VRN,_GetInst()}}
oDCSC_VRN:HyperLabel := HyperLabel{#SC_VRN,"First ("+_chr(38)+_chr(38)+"middle) name(s):",NULL_STRING,NULL_STRING}

oDCSC_NA2 := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_NA2,_GetInst()}}
oDCSC_NA2:HyperLabel := HyperLabel{#SC_NA2,"Initials:",NULL_STRING,NULL_STRING}

oDCSC_NA3 := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_NA3,_GetInst()}}
oDCSC_NA3:HyperLabel := HyperLabel{#SC_NA3,"Name extension:","Name extension",NULL_STRING}

oDCSC_TIT := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_TIT,_GetInst()}}
oDCSC_TIT:HyperLabel := HyperLabel{#SC_TIT,"Title:",NULL_STRING,NULL_STRING}

oDCSC_AD1 := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_AD1,_GetInst()}}
oDCSC_AD1:HyperLabel := HyperLabel{#SC_AD1,"Street+number:",NULL_STRING,NULL_STRING}

oDCSC_POS := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_POS,_GetInst()}}
oDCSC_POS:HyperLabel := HyperLabel{#SC_POS,"Zip code:",NULL_STRING,NULL_STRING}

oDCSC_PLA := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_PLA,_GetInst()}}
oDCSC_PLA:HyperLabel := HyperLabel{#SC_PLA,"City:",NULL_STRING,NULL_STRING}

oDCSC_TAV := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_TAV,_GetInst()}}
oDCSC_TAV:HyperLabel := HyperLabel{#SC_TAV,"Attention:",NULL_STRING,NULL_STRING}

oDCSC_LAN := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_LAN,_GetInst()}}
oDCSC_LAN:HyperLabel := HyperLabel{#SC_LAN,"Country:",NULL_STRING,NULL_STRING}

oDCSC_TEL1 := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_TEL1,_GetInst()}}
oDCSC_TEL1:HyperLabel := HyperLabel{#SC_TEL1,"Business:",NULL_STRING,NULL_STRING}

oDCSC_TEL2 := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_TEL2,_GetInst()}}
oDCSC_TEL2:HyperLabel := HyperLabel{#SC_TEL2,"Home:",NULL_STRING,NULL_STRING}

oDCSC_FAX := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_FAX,_GetInst()}}
oDCSC_FAX:HyperLabel := HyperLabel{#SC_FAX,"Fax:",NULL_STRING,NULL_STRING}

oDCSC_OPM := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_OPM,_GetInst()}}
oDCSC_OPM:HyperLabel := HyperLabel{#SC_OPM,"Remarks:",NULL_STRING,NULL_STRING}

oDCmLastName := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MLASTNAME,_GetInst()}}
oDCmLastName:HyperLabel := HyperLabel{#mLastName,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmLastName:FocusSelect := FSEL_HOME
oDCmLastName:FieldSpec := Person_NA1{}

oDCmPrefix := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MPREFIX,_GetInst()}}
oDCmPrefix:HyperLabel := HyperLabel{#mPrefix,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmPrefix:FocusSelect := FSEL_HOME
oDCmPrefix:FieldSpec := Person_VRN{}

oDCmFirstName := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MFIRSTNAME,_GetInst()}}
oDCmFirstName:FieldSpec := Person_VRN{}
oDCmFirstName:HyperLabel := HyperLabel{#mFirstName,NULL_STRING,NULL_STRING,"Person_VRN"}
oDCmFirstName:FocusSelect := FSEL_HOME

oDCmInitials := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MINITIALS,_GetInst()}}
oDCmInitials:FieldSpec := Person_NA2{}
oDCmInitials:HyperLabel := HyperLabel{#mInitials,NULL_STRING,NULL_STRING,"Person_NA2"}
oDCmInitials:FocusSelect := FSEL_HOME
oDCmInitials:Picture := "@!"

oDCmNameExt := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MNAMEEXT,_GetInst()}}
oDCmNameExt:FieldSpec := Person_NA3{}
oDCmNameExt:HyperLabel := HyperLabel{#mNameExt,NULL_STRING,"Name extension","Person_NA3"}
oDCmNameExt:FocusSelect := FSEL_HOME

oDCmTitle := combobox{SELF,ResourceID{NEWPERSONWINDOW_MTITLE,_GetInst()}}
oDCmTitle:HyperLabel := HyperLabel{#mTitle,"Salutation",NULL_STRING,NULL_STRING}
oDCmTitle:FillUsing(pers_titles)

oDCmAddress := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MADDRESS,_GetInst()}}
oDCmAddress:HyperLabel := HyperLabel{#mAddress,NULL_STRING,NULL_STRING,"Person_AD1"}
oDCmAddress:FocusSelect := FSEL_HOME
oDCmAddress:FieldSpec := Person_AD1{}

oDCmPostalcode := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MPOSTALCODE,_GetInst()}}
oDCmPostalcode:FieldSpec := Person_POS{}
oDCmPostalcode:HyperLabel := HyperLabel{#mPostalcode,NULL_STRING,NULL_STRING,"Person_POS"}
oDCmPostalcode:FocusSelect := FSEL_HOME
oDCmPostalcode:OverWrite := OVERWRITE_ONKEY

oDCmCity := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MCITY,_GetInst()}}
oDCmCity:FieldSpec := Person_PLA{}
oDCmCity:HyperLabel := HyperLabel{#mCity,NULL_STRING,NULL_STRING,"Person_PLA"}
oDCmCity:FocusSelect := FSEL_HOME
oDCmCity:OverWrite := OVERWRITE_ONKEY

oDCmAttention := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MATTENTION,_GetInst()}}
oDCmAttention:FieldSpec := Person_TAV{}
oDCmAttention:HyperLabel := HyperLabel{#mAttention,NULL_STRING,NULL_STRING,"Person_TAV"}
oDCmAttention:FocusSelect := FSEL_HOME

oDCmCountry := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MCOUNTRY,_GetInst()}}
oDCmCountry:FieldSpec := Person_LAN{}
oDCmCountry:HyperLabel := HyperLabel{#mCountry,NULL_STRING,NULL_STRING,"Person_LAN"}
oDCmCountry:FocusSelect := FSEL_TRIM

oDCmTelbusiness := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MTELBUSINESS,_GetInst()}}
oDCmTelbusiness:HyperLabel := HyperLabel{#mTelbusiness,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmTelbusiness:FocusSelect := FSEL_HOME
oDCmTelbusiness:FieldSpec := Person_TEL1{}

oDCmTelhome := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MTELHOME,_GetInst()}}
oDCmTelhome:FieldSpec := Person_TEL2{}
oDCmTelhome:HyperLabel := HyperLabel{#mTelhome,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmTelhome:FocusSelect := FSEL_HOME

oDCmFAX := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MFAX,_GetInst()}}
oDCmFAX:FieldSpec := Person_FAX{}
oDCmFAX:HyperLabel := HyperLabel{#mFAX,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmFAX:FocusSelect := FSEL_HOME

oDCmMobile := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MMOBILE,_GetInst()}}
oDCmMobile:FieldSpec := Person_Mobile{}
oDCmMobile:HyperLabel := HyperLabel{#mMobile,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmMobile:FocusSelect := FSEL_HOME

oDCmBankNumber := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MBANKNUMBER,_GetInst()}}
oDCmBankNumber:HyperLabel := HyperLabel{#mBankNumber,NULL_STRING,"Number of bankaccount",NULL_STRING}
oDCmBankNumber:FocusSelect := FSEL_HOME
oDCmBankNumber:FieldSpec := BANK{}

oCCBankButton := PushButton{SELF,ResourceID{NEWPERSONWINDOW_BANKBUTTON,_GetInst()}}
oCCBankButton:HyperLabel := HyperLabel{#BankButton,"v","Browse in Bank accounts",NULL_STRING}
oCCBankButton:TooltipText := "Browse in Bankaccounts"

oDCBankBox := ListBox{SELF,ResourceID{NEWPERSONWINDOW_BANKBOX,_GetInst()}}
oDCBankBox:TooltipText := "Select required bank account"
oDCBankBox:BackGround := aBrushes[1]
oDCBankBox:HyperLabel := HyperLabel{#BankBox,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmEmail := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MEMAIL,_GetInst()}}
oDCmEmail:HyperLabel := HyperLabel{#mEmail,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmEmail:FocusSelect := FSEL_HOME
oDCmEmail:FieldSpec := Person_EMAIL{}

oDCmRemarks := MultiLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MREMARKS,_GetInst()}}
oDCmRemarks:FieldSpec := Person_OPM{}
oDCmRemarks:HyperLabel := HyperLabel{#mRemarks,NULL_STRING,NULL_STRING,"Person_OPM"}

oDCmType := combobox{SELF,ResourceID{NEWPERSONWINDOW_MTYPE,_GetInst()}}
oDCmType:HyperLabel := HyperLabel{#mType,NULL_STRING,"Type of person: individual, company, ..",NULL_STRING}
oDCmType:UseHLforToolTip := True
oDCmType:FillUsing(pers_types)

oDCmBirthDate := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MBIRTHDATE,_GetInst()}}
oDCmBirthDate:FieldSpec := Person_BIRTHDAT{}
oDCmBirthDate:HyperLabel := HyperLabel{#mBirthDate,NULL_STRING,"Date of\birth",NULL_STRING}
oDCmBirthDate:FocusSelect := FSEL_HOME
oDCmBirthDate:Picture := "99-99-9999"

oDCmGender := combobox{SELF,ResourceID{NEWPERSONWINDOW_MGENDER,_GetInst()}}
oDCmGender:HyperLabel := HyperLabel{#mGender,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmGender:FillUsing(pers_gender)

oDCmCod1 := combobox{SELF,ResourceID{NEWPERSONWINDOW_MCOD1,_GetInst()}}
oDCmCod1:HyperLabel := HyperLabel{#mCod1,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod1:FillUsing(pers_codes)

oDCmCod2 := combobox{SELF,ResourceID{NEWPERSONWINDOW_MCOD2,_GetInst()}}
oDCmCod2:HyperLabel := HyperLabel{#mCod2,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod2:FillUsing(pers_codes)

oDCmCod3 := combobox{SELF,ResourceID{NEWPERSONWINDOW_MCOD3,_GetInst()}}
oDCmCod3:HyperLabel := HyperLabel{#mCod3,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod3:FillUsing(pers_codes)

oDCmCod4 := combobox{SELF,ResourceID{NEWPERSONWINDOW_MCOD4,_GetInst()}}
oDCmCod4:HyperLabel := HyperLabel{#mCod4,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod4:FillUsing(pers_codes)

oDCmCod5 := combobox{SELF,ResourceID{NEWPERSONWINDOW_MCOD5,_GetInst()}}
oDCmCod5:HyperLabel := HyperLabel{#mCod5,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod5:FillUsing(pers_codes)

oDCmCod6 := combobox{SELF,ResourceID{NEWPERSONWINDOW_MCOD6,_GetInst()}}
oDCmCod6:HyperLabel := HyperLabel{#mCod6,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod6:FillUsing(pers_codes)

oDCmCod7 := combobox{SELF,ResourceID{NEWPERSONWINDOW_MCOD7,_GetInst()}}
oDCmCod7:HyperLabel := HyperLabel{#mCod7,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod7:FillUsing(pers_codes)

oDCmCod8 := combobox{SELF,ResourceID{NEWPERSONWINDOW_MCOD8,_GetInst()}}
oDCmCod8:HyperLabel := HyperLabel{#mCod8,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod8:FillUsing(pers_codes)

oDCmCod9 := combobox{SELF,ResourceID{NEWPERSONWINDOW_MCOD9,_GetInst()}}
oDCmCod9:HyperLabel := HyperLabel{#mCod9,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod9:FillUsing(pers_codes)

oDCmCod10 := combobox{SELF,ResourceID{NEWPERSONWINDOW_MCOD10,_GetInst()}}
oDCmCod10:HyperLabel := HyperLabel{#mCod10,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod10:FillUsing(pers_codes)

oCCOKButton := PushButton{SELF,ResourceID{NEWPERSONWINDOW_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{NEWPERSONWINDOW_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCmcreationdate := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MCREATIONDATE,_GetInst()}}
oDCmcreationdate:FieldSpec := Person_BDAT{}
oDCmcreationdate:HyperLabel := HyperLabel{#mcreationdate,NULL_STRING,"Date of first registration","Person_BDAT"}

oDCFixedText21 := FixedText{SELF,ResourceID{NEWPERSONWINDOW_FIXEDTEXT21,_GetInst()}}
oDCFixedText21:HyperLabel := HyperLabel{#FixedText21,"Email:",NULL_STRING,NULL_STRING}

oDCSC_BankNumber := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_BANKNUMBER,_GetInst()}}
oDCSC_BankNumber:HyperLabel := HyperLabel{#SC_BankNumber,"Bank/Giro:",NULL_STRING,NULL_STRING}

oDCSC_CLN := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_CLN,_GetInst()}}
oDCSC_CLN:HyperLabel := HyperLabel{#SC_CLN,"Intern ID:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{NEWPERSONWINDOW_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Mailing codes",NULL_STRING,NULL_STRING}

oDCmPersid := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MPERSID,_GetInst()}}
oDCmPersid:HyperLabel := HyperLabel{#mPersid,"PersonNbr:","Number of person",NULL_STRING}

oDCSC_BDAT := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_BDAT,_GetInst()}}
oDCSC_BDAT:HyperLabel := HyperLabel{#SC_BDAT,"Creation:",NULL_STRING,NULL_STRING}

oDCSC_MUTD := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_MUTD,_GetInst()}}
oDCSC_MUTD:HyperLabel := HyperLabel{#SC_MUTD,"Altered:",NULL_STRING,NULL_STRING}

oDCSC_DLG := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_DLG,_GetInst()}}
oDCSC_DLG:HyperLabel := HyperLabel{#SC_DLG,"Last gift:",NULL_STRING,NULL_STRING}

oDCSC_OPC := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_OPC,_GetInst()}}
oDCSC_OPC:HyperLabel := HyperLabel{#SC_OPC,"By:",NULL_STRING,NULL_STRING}

oDCmalterdate := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MALTERDATE,_GetInst()}}
oDCmalterdate:FieldSpec := Person_MUTD{}
oDCmalterdate:HyperLabel := HyperLabel{#malterdate,NULL_STRING,NULL_STRING,"Person_MUTD"}

oDCmdatelastgift := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MDATELASTGIFT,_GetInst()}}
oDCmdatelastgift:FieldSpec := Person_DLG{}
oDCmdatelastgift:HyperLabel := HyperLabel{#mdatelastgift,NULL_STRING,NULL_STRING,"Person_DLG"}

oDCmOPC := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MOPC,_GetInst()}}
oDCmOPC:FieldSpec := Person_OPC{}
oDCmOPC:HyperLabel := HyperLabel{#mOPC,NULL_STRING,NULL_STRING,"Person_OPC"}

oDCGroupBox2 := GroupBox{SELF,ResourceID{NEWPERSONWINDOW_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Name:",NULL_STRING,NULL_STRING}

oDCGroupBox3 := GroupBox{SELF,ResourceID{NEWPERSONWINDOW_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"Address:",NULL_STRING,NULL_STRING}

oDCGroupBox4 := GroupBox{SELF,ResourceID{NEWPERSONWINDOW_GROUPBOX4,_GetInst()}}
oDCGroupBox4:HyperLabel := HyperLabel{#GroupBox4,"Telephone:",NULL_STRING,NULL_STRING}

oDCGroupBoxSystem := GroupBox{SELF,ResourceID{NEWPERSONWINDOW_GROUPBOXSYSTEM,_GetInst()}}
oDCGroupBoxSystem:HyperLabel := HyperLabel{#GroupBoxSystem,"System:",NULL_STRING,NULL_STRING}

oDCSC_TEL3 := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_TEL3,_GetInst()}}
oDCSC_TEL3:HyperLabel := HyperLabel{#SC_TEL3,"Mobile:",NULL_STRING,NULL_STRING}

oDCGroupBoxPersonal := GroupBox{SELF,ResourceID{NEWPERSONWINDOW_GROUPBOXPERSONAL,_GetInst()}}
oDCGroupBoxPersonal:HyperLabel := HyperLabel{#GroupBoxPersonal,"Personal:",NULL_STRING,NULL_STRING}

oDCSC_BDAT1 := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_BDAT1,_GetInst()}}
oDCSC_BDAT1:HyperLabel := HyperLabel{#SC_BDAT1,"Birthdate:",NULL_STRING,NULL_STRING}

oDCSC_BDAT2 := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_BDAT2,_GetInst()}}
oDCSC_BDAT2:HyperLabel := HyperLabel{#SC_BDAT2,"Type:",NULL_STRING,NULL_STRING}

oDCSC_TEL4 := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_TEL4,_GetInst()}}
oDCSC_TEL4:HyperLabel := HyperLabel{#SC_TEL4,"Gender:",NULL_STRING,NULL_STRING}

oDCmPropExtr := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MPROPEXTR,_GetInst()}}
oDCmPropExtr:HyperLabel := HyperLabel{#mPropExtr,NULL_STRING,NULL_STRING,NULL_STRING}

oDCSC_Externid := FixedText{SELF,ResourceID{NEWPERSONWINDOW_SC_EXTERNID,_GetInst()}}
oDCSC_Externid:HyperLabel := HyperLabel{#SC_Externid,"Extern ID:",NULL_STRING,NULL_STRING}

oDCmExternid := SingleLineEdit{SELF,ResourceID{NEWPERSONWINDOW_MEXTERNID,_GetInst()}}
oDCmExternid:HyperLabel := HyperLabel{#mExternid,"ExternID","External identification of person",NULL_STRING}
oDCmExternid:FocusSelect := FSEL_HOME
oDCmExternid:FieldSpec := Person_EXTERNID{}

oCCGiftsButton := PushButton{SELF,ResourceID{NEWPERSONWINDOW_GIFTSBUTTON,_GetInst()}}
oCCGiftsButton:HyperLabel := HyperLabel{#GiftsButton,"Gifts",NULL_STRING,NULL_STRING}

oCCDonationsButton := PushButton{SELF,ResourceID{NEWPERSONWINDOW_DONATIONSBUTTON,_GetInst()}}
oCCDonationsButton:HyperLabel := HyperLabel{#DonationsButton,"Donations",NULL_STRING,NULL_STRING}

SELF:Caption := "Edit Person"
SELF:HyperLabel := HyperLabel{#NewPersonWindow,"Edit Person",NULL_STRING,NULL_STRING}
SELF:Icon := ACUSTOMERICON{}
SELF:HelpDisplay := HelpDisplay{"Wyc.hlp"}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := False

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
SELF:ViewAs(#FormView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListBoxSelect(oControlEvent) CLASS NewPersonWindow
	LOCAL oControl AS Control
	LOCAL cBank, cDescr:="Bank# " AS STRING
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControl:NameSym==#BankBox
		self:oDCmBankNumber:Value:=if(Empty(oControl:VALUE),"",ZeroTrim(strtran(strtran(oControl:VALUE,".",""),",",'')))
		cBank:=self:oDCmBankNumber:Value
		IF CountryCode=="47"
			cDescr:="Bank/KID "
		ENDIF

		self:oDCSC_BankNumber:TextValue:=cDescr+Str(AScan(aBankAcc,{|x|x[2]==cBank}),-1)
		SELF:oDCBankBox:Hide()
	ENDIF
	RETURN NIL

ACCESS mAddress() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mAddress)

ASSIGN mAddress(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mAddress, uValue)
RETURN uValue

ACCESS malterdate() CLASS NewPersonWindow
RETURN SELF:FieldGet(#malterdate)

ASSIGN malterdate(uValue) CLASS NewPersonWindow
SELF:FieldPut(#malterdate, uValue)
RETURN uValue

ACCESS mAttention() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mAttention)

ASSIGN mAttention(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mAttention, uValue)
RETURN uValue

ACCESS mBankNumber() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mBankNumber)

ASSIGN mBankNumber(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mBankNumber, uValue)
RETURN uValue

ACCESS mBirthDate() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mBirthDate)

ASSIGN mBirthDate(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mBirthDate, uValue)
RETURN uValue

ACCESS mCity() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCity)

ASSIGN mCity(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCity, uValue)
RETURN uValue

ACCESS mCod10() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCod10)

ASSIGN mCod10(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCod10, uValue)
RETURN uValue

ACCESS mCod1() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCod1)

ASSIGN mCod1(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCod1, uValue)
RETURN uValue

ACCESS mCod2() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCod2)

ASSIGN mCod2(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCod2, uValue)
RETURN uValue

ACCESS mCod3() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCod3)

ASSIGN mCod3(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCod3, uValue)
RETURN uValue

ACCESS mCod4() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCod4)

ASSIGN mCod4(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCod4, uValue)
RETURN uValue

ACCESS mCod5() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCod5)

ASSIGN mCod5(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCod5, uValue)
RETURN uValue

ACCESS mCod6() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCod6)

ASSIGN mCod6(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCod6, uValue)
RETURN uValue

ACCESS mCod7() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCod7)

ASSIGN mCod7(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCod7, uValue)
RETURN uValue

ACCESS mCod8() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCod8)

ASSIGN mCod8(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCod8, uValue)
RETURN uValue

ACCESS mCod9() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCod9)

ASSIGN mCod9(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCod9, uValue)
RETURN uValue

ACCESS mCod() CLASS NewPersonWindow
RETURN mCodInt                             
ASSIGN mCod(uValue) CLASS NewPersonWindow
mCodInt:= uValue
RETURN uValue
ACCESS mCountry() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mCountry)

ASSIGN mCountry(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mCountry, uValue)
RETURN uValue

ACCESS mcreationdate() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mcreationdate)

ASSIGN mcreationdate(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mcreationdate, uValue)
RETURN uValue

ACCESS mdatelastgift() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mdatelastgift)

ASSIGN mdatelastgift(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mdatelastgift, uValue)
RETURN uValue

ACCESS mEmail() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mEmail)

ASSIGN mEmail(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mEmail, uValue)
RETURN uValue

ACCESS mExternid() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mExternid)

ASSIGN mExternid(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mExternid, uValue)
RETURN uValue

ACCESS mFAX() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mFAX)

ASSIGN mFAX(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mFAX, uValue)
RETURN uValue

ACCESS mFirstName() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mFirstName)

ASSIGN mFirstName(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mFirstName, uValue)
RETURN uValue

ACCESS mGender() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mGender)

ASSIGN mGender(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mGender, uValue)
RETURN uValue

ACCESS mInitials() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mInitials)

ASSIGN mInitials(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mInitials, uValue)
RETURN uValue

ACCESS mLastName() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mLastName)

ASSIGN mLastName(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mLastName, uValue)
RETURN uValue

ACCESS mMobile() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mMobile)

ASSIGN mMobile(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mMobile, uValue)
RETURN uValue

ACCESS mNameExt() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mNameExt)

ASSIGN mNameExt(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mNameExt, uValue)
RETURN uValue

ACCESS mOPC() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mOPC)

ASSIGN mOPC(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mOPC, uValue)
RETURN uValue

ACCESS mPersid() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mPersid)

ASSIGN mPersid(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mPersid, uValue)
RETURN uValue

ACCESS mPostalcode() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mPostalcode)

ASSIGN mPostalcode(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mPostalcode, uValue)
RETURN uValue

ACCESS mPrefix() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mPrefix)

ASSIGN mPrefix(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mPrefix, uValue)
RETURN uValue

ACCESS mPropExtr() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mPropExtr)

ASSIGN mPropExtr(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mPropExtr, uValue)
RETURN uValue

ACCESS mRemarks() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mRemarks)

ASSIGN mRemarks(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mRemarks, uValue)
RETURN uValue

ACCESS mTelbusiness() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mTelbusiness)

ASSIGN mTelbusiness(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mTelbusiness, uValue)
RETURN uValue

ACCESS mTelhome() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mTelhome)

ASSIGN mTelhome(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mTelhome, uValue)
RETURN uValue

ACCESS mTitle() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mTitle)

ASSIGN mTitle(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mTitle, uValue)
RETURN uValue

ACCESS mType() CLASS NewPersonWindow
RETURN SELF:FieldGet(#mType)

ASSIGN mType(uValue) CLASS NewPersonWindow
SELF:FieldPut(#mType, uValue)
RETURN uValue

METHOD OkButton CLASS NewPersonWindow
	LOCAL oTextBox as TextBox
	LOCAL oPers,oStmnt as SQLStatement
	LOCAL i, nCLN, nCurRec as int
	LOCAL cExtra, cTit as STRING, contvalue as usual
	LOCAL oContr as Control
	LOCAL myCombo as COMBOBOX
	local lSuccess as logic
	local cStmnt as string
	local oPersCnt as PersonContainer 

	self:mCodInt := MakeCod({self:mCod1,self:mCod2,self:mCod3,self:mCod4,self:mCod5,self:mCod6,self:mCod7,self:mCod8,self:mCod9,self:mCod10})
	//	IF ValidateControls( SELF, SELF:AControls ) .and. ;
	IF self:ValidatePerson()
		IF self:lNew 
			cStmnt:="insert into person set "
			IF Empty(self:mCreationDate)
				IF Empty(self:mAlterDate).and.Empty(self:mDateLastGift) 
					self:mCreationDate := Today()
				ELSEIF Empty(self:mAlterDate).or.Empty(self:mDateLastGift)
					self:mCreationDate:=Max(self:mDateLastGift,self:mAlterDate)
				ELSE
					self:mCreationDate:=Min(self:mDateLastGift,self:mAlterDate)
				ENDIF
			ENDIF
		ELSE
			cStmnt:="update person set "
		ENDIF
		IF !self:lImport.or.Empty(self:mAlterDate)
			self:mAlterDate := Today()
		ENDIF
		// fill extra properties:
		cExtra:="<velden>"
		FOR i:=1 to Len(aPropEx) step 1
			oContr:=aPropEx[i]
			contvalue:=""
			IF ClassName(oContr)=#COMBOBOX
				myCombo:=oContr
				IF myCombo:CurrentItemNo>0
					contvalue:=myCombo:GetItemValue(myCombo:CurrentItemNo)
				ENDIF
				//			ELSEif ClassName(oContr)=#CHECKBOX
			ELSE
				IF !IsNil(oContr:VALUE)
					if IsDate(oContr:VALUE)
						contvalue:=DToS(oContr:VALUE)
					else 
						contvalue:=oContr:Value
					endif
				endif
			ENDIF
			if !Empty(oContr:VALUE)
				cExtra+="<"+oContr:Name+">"+Transform(contvalue,"@B")+"</"+oContr:Name+">"
			endif
		NEXT
		cExtra+="</velden>"

		IF Empty(self:mTitle)
			cTit:="1"  
		ELSEIF IsNumeric(self:mTitle)
			cTit:=Str(self:mTitle,-1)  
		ELSE
			IF self:oDCmTitle:CurrentItemNo>0
				cTit:=Str(self:oDCmTitle:GetItemValue(self:oDCmTitle:CurrentItemNo),-1)  
			ENDIF
		ENDIF
		cStmnt+=iif(LSTNUPC,"lastname='"+Upper(AddSlashes(self:oDCmlastname:VALUE))+"',nameext='"+Upper(AddSlashes(self:oDCmNameExt:VALUE))+"'",;
			"lastname='"+AddSlashes(self:oDCmlastname:TextValue)+"',nameext='"+AddSlashes(self:oDCmNameExt:TextValue))+"'"+;
			",initials='"+AddSlashes(self:oDCmInitials:TextValue)+"'"+;
			",title='"+AddSlashes(cTit)+"'"+;
			",attention='"+AddSlashes(self:oDCmAttention:TextValue)+"'"+;
			",prefix='"+AddSlashes(self:oDCmPrefix:TextValue)+"'"+;
			",firstname='"+AddSlashes(self:oDCmFirstName:TextValue)+"'"+;
			",address='"+AddSlashes(self:oDCmAddress:TextValue)+"'"+;
			",country='"+AddSlashes(self:oDCmCountry:TextValue)+"'"+;
			",postalcode='"+AddSlashes(self:mPostalcode)+"'"+;
			",mailingcodes='"+AllTrim(self:mCod)+"'"+;
			",externid='"+ZeroTrim(self:mExternid)+"'"+;
			",telbusiness='"+AllTrim(self:mtelbusiness)+"'"+;
			",telhome='"+AllTrim(self:mTelhome)+"'"+;
			",fax='"+AllTrim(self:mFAX)+"'"+;
			",mobile='"+AllTrim(self:mMobile)+"'"+;
			",city='"+AddSlashes(iif(CITYUPC,Upper(AllTrim(self:mCity)),AllTrim(self:mCity)))+"'"+;
			",email='"+AddSlashes(AllTrim(self:mEmail))+"'"+;
			iif(!self:lNew.or.!Empty(self:mRemarks),",remarks='"+AddSlashes(self:mRemarks)+"'","")+;
			",opc='"+LOGON_EMP_ID+"'"+;
			",creationdate='"+SQLdate(self:mCreationDate)+"'"+;
			iif(self:oDCmType:CurrentItemNo>0,",type='"+Str(self:oDCmType:GetItemValue(self:oDCmType:CurrentItemNo),-1)+"'","")+;
			",birthdate='"+SQLdate(self:mBirthDate)+"'"+;
			iif(self:oDCmGENDER:CurrentItemNo>0,",gender='"+Str(self:oDCmGENDER:GetItemValue(self:oDCmGENDER:CurrentItemNo),-1)+"'","")+; 
		",propextr='"+StrTran(cExtra,"'","\'")+"'"+;
			",alterdate='"+SQLdate(self:mAlterDate)+"'"+;
			",datelastgift ='"+SQLdate(self:mDateLastGift)+"'"+;
			iif(self:lNew,''," where persid='"+self:mPersId+"'")
		oPers:=SQLStatement{cStmnt,oConn}
		oPers:Execute() 
		if !IsNil(oPers:Status)
			LogEvent(,'Add/update person Error:'+oPers:Status:Description+"; statement:"+oPers:SQLString,"LogErrors")
			(ErrorBox{self,'Add/update person Error:'+oPers:Status:Description}):Show()
		endif
		if self:lNew
			self:mPersId:=SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGet(1)
		elseif !(alltrim(self:curlastname)==alltrim(self:mlastname).and.alltrim(self:curNa2)==alltrim(self:mInitials).and.alltrim(self:curHisn)==alltrim(self:mPrefix))
			// in case of member update name of corresponding account:
			oStmnt:=SQLStatement{"update account set description='"+StrTran(GetFullName(self:mPersId),"'","\'")+"' where accid in (select m.accid from member as m where m.persid="+self:mPersId+")",oConn}
			oStmnt:Execute()
		ENDIF
		// 		ENDIF
		FOR i=1 to Len(self:aBankAcc)
			IF i<=Len(OrigaBank)
				IF !self:aBankAcc[i,2] ==OrigaBank[i] // change of value? 
					IF Empty(self:aBankAcc[i,2]).or.Empty(self:aBankAcc[i,2])  // removed?
						oStmnt:=SQLStatement{"delete from personbank where banknumber='"+self:OrigaBank[i]+"'",oConn}
					else   // changed
						oStmnt:=SQLStatement{"update personbank set persid='"+self:mPersId+"',banknumber='"+self:aBankAcc[i,2]+"' where banknumber='"+self:OrigaBank[i]+"'",oConn}
					endif
					oStmnt:Execute()
				ENDIF
			ELSEIF Len(self:aBankAcc[i,2])>1 
				oStmnt:=SQLStatement{"Insert into personbank set persid="+self:mPersId+",banknumber='"+self:aBankAcc[i,2]+"'",oConn}
				oStmnt:Execute() 
			ENDIF
		NEXT
		self:ClearBankAccs()
		IF lAddressChanged
			IF IsObject(oCaller)
				IF IsMethod(oCaller,#Regperson)
					oPersCnt:=PersonContainer{}    
					oPersCnt:persid:=self:mPersId
					oCaller:Regperson(oPersCnt,self:oLan:RGet("Address changed!"))
				endif
			ENDIF
		ENDIF
		IF self:lImport
			self:oImport:NextImport(self,true)
			RETURN nil
		ENDIF
		self:EndWindow()
		// refresh owner: 
		if !Empty(self:oCaller) .and. IsInstanceOf(self:oCaller,#PersonBrowser)
			self:oCaller:SearchCLN:=self:mPersId
			self:oCaller:ReFind()
			if self:oCaller:oPers:Reccount==1 .and. !self:oCaller:oCaller==null_object
				self:oCaller:SELECT()   // go direct to
			endif 
		endif
		self:Close()
	ENDIF

	
	RETURN true
METHOD PostInit(oWindow,iCtlID,oServer,aExtra) CLASS NewPersonWindow
	*	aExtra: {New,AddressChanged,oCaller} or just: New
	//Put your PostInit additions here
	LOCAL pos as int
	LOCAL myDim as Dimension
	LOCAL myOrg as Point 
	local aNAW:={} as array
	LOCAL aMasc:={"DHR","HR","MR","HEER","MR","MON","MNR"} as ARRAY
	LOCAL aFem:={"MW","MEJ","MRS","MVR","MEVR","MS","MME","MAD","MIS"} as ARRAY
	LOCAL aCpl:={"DHR EN MW","DHR E/O MW","FAM","HR/MW","MW/HR"} as ARRAY 
	local title,cTit as string 
	local titPtr as int 
	self:SetTexts()
	self:oPersCnt:=PersonContainer{}
	self:aBankAcc:={}
	IF IsNil(aExtra)
		self:lNew:=FALSE
		self:lAddressChanged:=FALSE
	ELSEIF !IsArray(aExtra)
		Default(@aExtra,FALSE)
		self:lNew:=aExtra
	ELSE
		self:lNew:=aExtra[1]
		self:lAddressChanged:=aExtra[2]
		oCaller:=aExtra[3] 
		if Len(aExtra)>3
			self:oPersCnt:=aExtra[4]
		endif
	ENDIF
	IF CountryCode=="47"
		self:oDCSC_BankNumber:TextValue:="Bank/Giro/KID"
	ENDIF
	//if !self:lExists
	self:InitExtraProperties()
	//endif
	self:oDCmType:FillUsing(pers_types) 
	if CITYUPC
		self:oDCmCity:Picture:="@!"
	else
		self:oDCmCity:Picture:="!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	endif 
	if LSTNUPC
		self:oDCmlastname:Picture:="@!" 
		self:oDCmNameExt:Picture:="@!"
	else
		self:oDCmlastname:Picture:="!XXXXXXXXXXXXXXXXXXXXXXXXXXX"
		self:oDCmNameExt:Picture:="!XXXXXXXXXXXXXXXXXXXXXXXXXXX"
	endif
	IF self:lNew
		IF!Empty(SCLC)
			self:oDCmCOD1:Value  := if(Empty(SubStr(SCLC,1,2)),nil,SubStr(SCLC,1,2))
			self:oDCmCOD2:Value  := if(Empty(SubStr(SCLC,4,2)),nil,SubStr(SCLC,4,2))
			self:oDCmCOD3:Value  := if(Empty(SubStr(SCLC,7,2)),nil,SubStr(SCLC,7,2))
		ENDIF
		self:oDCmPersid:TextValue:="       "
		IF !Empty(self:oPersCnt:m51_lastname)
			self:oDCmLastName:TextValue := Lower(self:oPersCnt:m51_lastname)
		ENDIF
		IF !Empty(self:oPersCnt:m51_initials)
			self:oDCmInitials:TextValue := self:oPersCnt:m51_initials
		ENDIF
		if !Empty(self:oPersCnt:m51_title) 
			cTit:= Lower(self:oPersCnt:m51_title)
			titPtr:=AScan(Pers_Titles,{|x|x[1]==cTit})
			IF titPtr>0
				self:oDCmTitle:TextValue := pers_titles[titPtr,2]
			endif
		endif
		IF !Empty(self:oPersCnt:m51_prefix)
			self:oDCmPrefix:TextValue := self:oPersCnt:m51_prefix
		ENDIF
		IF !Empty(self:oPersCnt:m51_pos)
			self:oDCmPostalcode:TextValue := StandardZip(self:oPersCnt:m51_pos)
		ENDIF
		IF !Empty(self:oPersCnt:m51_ad1)
			self:oDCmAddress:TextValue := self:oPersCnt:m51_ad1
		ENDIF
		IF !Empty(self:oPersCnt:m51_city)
			self:oDCmCity:TextValue := self:oPersCnt:m51_city
		ENDIF
		IF !Empty(self:oPersCnt:m51_country)
			self:oDCmCountry:TextValue := self:oPersCnt:m51_country
		ENDIF
		IF !Empty(self:oPersCnt:m56_banknumber)
			//mBankNumber := self:oPersCnt:m56_banknumber 
			pos:=1
			pos:=self:FillBankNbr(self:oPersCnt:m56_banknumber,self:oDCSC_BankNumber:TextValue,pos)
			// clear aOrigbank:
			self:OrigaBank:={}
		ENDIF
		IF !Empty(self:oPersCnt:m51_exid)
			self:oDCmExternid:TextValue := self:oPersCnt:m51_exid
		else
			self:oDCmExternid:TextValue:="       "
		ENDIF
		IF !Empty(self:oPersCnt:m51_firstname)
			self:oDCmFirstName:TextValue := self:oPersCnt:m51_firstname
		ENDIF
		if !Empty(self:oPersCnt:m51_title)
			title:=Upper(AllTrim(self:oPersCnt:m51_title) )
			if AScanExact(aCpl,title)>0
				self:oPersCnt:m51_gender:="couple"
			elseif (pos:=AScan(aMasc,{|x| title=x}))>0
				self:oPersCnt:m51_gender:="male"
				self:oPersCnt:m51_title:=Lower(AllTrim(StrTran(title,aMasc[pos],"")))
			elseif (pos:=AScan(aFem,{|x| title=x}))>0
				self:oPersCnt:m51_gender:="female"
				self:oPersCnt:m51_title:=Lower(AllTrim(StrTran(title,aFem[pos],"")))
			elseif " EN " $ Upper(self:oPersCnt:m51_lastname)  .or." EO" $ Upper(self:oPersCnt:m51_lastname) .or." E/O" $ Upper(self:oPersCnt:m51_lastname)
				self:oPersCnt:m51_gender:="couple"			 
			elseif "-" $ Upper(self:oPersCnt:m51_lastname)			
				self:oPersCnt:m51_gender:="female"
			endif
			if !Empty(self:oPersCnt:m51_title)
				cTit:=self:oPersCnt:m51_title
				pos:=AScan(Pers_Titles,{|x|x[1]=cTit})
				if pos>0
					self:oDCmTit:Value:=pers_titles[pos,2]
				endif
			endif
		elseif "-" $ Upper(self:oPersCnt:m51_lastname)			
			self:oPersCnt:m51_gender:="female"
		elseif " EN " $ Upper(self:oPersCnt:m51_lastname)  .or." EO" $ Upper(self:oPersCnt:m51_lastname) .or." E/O" $ Upper(self:oPersCnt:m51_lastname)
			self:oPersCnt:m51_gender:="couple"			 
		endif

		IF !Empty(self:oPersCnt:m51_gender)
			self:oDCmGender:TextValue := self:oPersCnt:m51_gender
		ENDIF
		if CountryCode="31" .and.Empty(self:oDCmCountry:TextValue) .and.!(Empty(self:oDCmCity:TextValue).and.Empty(self:oDCmAddress:TextValue).and.Empty(self:oDCmPostalcode:TextValue))
			aNAW:=ExtractPostCode(self:oDCmCity:TextValue,self:oDCmAddress:TextValue,self:oDCmPostalcode:TextValue)
			self:oDCmPostalcode:TextValue:=aNAW[1]
			self:oDCmCity:TextValue:=aNAW[3]
			self:oDCmAddress:TextValue:=aNAW[2] 
		endif	
		self:oDCmcreationdate:Value := Today()
		self:oDCmOPC:TextValue:=LOGON_EMP_ID
		self:oDCmalterdate:Value:=Today()
		// remove mbr and ent from listbox:
		pos:=SELF:oDCmType:FindItem("Member",TRUE)
		IF pos>0
			self:oDCmType:CurrentItemNo:=pos
			self:oDCmType:DeleteItem()
		ENDIF
		pos:=SELF:oDCmType:FindItem("Wycliffe Entity",TRUE)
		IF pos>0
			self:oDCmType:CurrentItemNo:=pos
			self:oDCmType:DeleteItem()
		ENDIF
		IF !Empty(self:oPersCnt:m51_type)
			self:oDCmType:TextValue := self:oPersCnt:m51_type
		ENDIF
      self:oCCDonationsButton:Hide()
      self:oCCGiftsButton:Hide()
		self:oDCmlastname:SetFocus()
		
	ELSE
		if !Empty(self:oPersCnt:persid)
			self:oDCmPersid:TextValue:=self:oPersCnt:persid 
			self:SetState()
		elseif !Empty(self:oPersCnt:m51_exid)
			self:oDCmExternid:TextValue:=self:oPersCnt:m51_exid 
			self:SetState()
		endif
	ENDIF
	IF AScan(aMenu,{|x| x[4]=="PersonEdit"})=0
		SELF:oCCOKButton:Hide()
	ENDIF
	self:curmAddress:=AllTrim(self:oDCmAddress:TextValue)
	self:curmPos:=AllTrim(self:oDCmPostalcode:TextValue) 
	self:curmCity:=AllTrim(self:oDCmCity:TextValue)
	
	myDim:=self:Size
	myDim:Height-=500
	//SELF:Size:=myDim
	myOrg:=self:Origin
	myOrg:y+=500
	//SELF:Origin:=myOrg

	RETURN NIL
Method UpdBankAcc(cBankAcc) Class NewPersonWindow
// add a bank account to person:
local aToken as Array, i as int , cI as string
LOCAL cDescr:="Bank# " 
aToken:=Split(self:oDCSC_BankNumber:TextValue)
cBankAcc:=ZeroTrim(StrTran(StrTran(AllTrim(cBankAcc),".")," ")) 
cI:=ATail(aToken)
IF isnum(cI)
	i:=Val(cI)
	IF i>0 .and. i<=Len(aBankAcc)
		IF Empty(cBankAcc) .or.AScan(self:aBankAcc,{|x|x[2]==cBankAcc.and.!GetBankSeqNbr(x[1])==i})==0 
			self:aBankAcc[i]:={cDescr+Str(i,-1)+": "+cBankAcc,cBankAcc}
			self:oDCmBanknumber:Value:=cBankAcc
		elseif !Empty(aBankAcc[i,2])
// 		(ErrorBox{self,"Do not specify a bank account twice"}):show()
			self:oDCmBanknumber:Value:=aBankAcc[i,2]
		endif
	else
		AAdd(aBankAcc,{cDescr+" "+Str(Len(aBankAcc)+1,-1)+": "+AllTrim(cBankAcc),cBankAcc})
		self:oDCSC_BankNumber:TextValue:=cDescr+" "+Str(Len(aBankAcc),-1)+":" 
		self:oDCmBanknumber:VALUE:=cBankAcc
	endif
ELSE
	IF AScan(aBankAcc,{|x|x[2]==cBankAcc})==0
		AAdd(aBankAcc,{cDescr+" 1: "+AllTrim(cBankAcc),cBankAcc})
		self:oDCSC_BankNumber:TextValue:=cDescr+" 1:" 
		self:oDCmBanknumber:VALUE:=cBankAcc
	endif
endif
return
STATIC DEFINE NEWPERSONWINDOW_BANKBOX := 132 
STATIC DEFINE NEWPERSONWINDOW_BANKBUTTON := 131 
STATIC DEFINE NEWPERSONWINDOW_CANCELBUTTON := 149 
STATIC DEFINE NEWPERSONWINDOW_DONATIONSBUTTON := 176 
STATIC DEFINE NEWPERSONWINDOW_FIXEDTEXT21 := 151 
STATIC DEFINE NEWPERSONWINDOW_GIFTSBUTTON := 175 
STATIC DEFINE NEWPERSONWINDOW_GROUPBOX1 := 154 
STATIC DEFINE NEWPERSONWINDOW_GROUPBOX2 := 163 
STATIC DEFINE NEWPERSONWINDOW_GROUPBOX3 := 164 
STATIC DEFINE NEWPERSONWINDOW_GROUPBOX4 := 165 
STATIC DEFINE NEWPERSONWINDOW_GROUPBOXPERSONAL := 168 
STATIC DEFINE NEWPERSONWINDOW_GROUPBOXSYSTEM := 166 
STATIC DEFINE NEWPERSONWINDOW_MADDRESS := 121 
STATIC DEFINE NEWPERSONWINDOW_MALTERDATE := 160 
STATIC DEFINE NEWPERSONWINDOW_MATTENTION := 124 
STATIC DEFINE NEWPERSONWINDOW_MBANKNUMBER := 130 
STATIC DEFINE NEWPERSONWINDOW_MBIRTHDATE := 136 
STATIC DEFINE NEWPERSONWINDOW_MCITY := 123 
STATIC DEFINE NEWPERSONWINDOW_MCOD1 := 138 
STATIC DEFINE NEWPERSONWINDOW_MCOD10 := 147 
STATIC DEFINE NEWPERSONWINDOW_MCOD2 := 139 
STATIC DEFINE NEWPERSONWINDOW_MCOD3 := 140 
STATIC DEFINE NEWPERSONWINDOW_MCOD4 := 141 
STATIC DEFINE NEWPERSONWINDOW_MCOD5 := 142 
STATIC DEFINE NEWPERSONWINDOW_MCOD6 := 143 
STATIC DEFINE NEWPERSONWINDOW_MCOD7 := 144 
STATIC DEFINE NEWPERSONWINDOW_MCOD8 := 145 
STATIC DEFINE NEWPERSONWINDOW_MCOD9 := 146 
STATIC DEFINE NEWPERSONWINDOW_MCOUNTRY := 125 
STATIC DEFINE NEWPERSONWINDOW_MCREATIONDATE := 150 
STATIC DEFINE NEWPERSONWINDOW_MDATELASTGIFT := 161 
STATIC DEFINE NEWPERSONWINDOW_MEMAIL := 133 
STATIC DEFINE NEWPERSONWINDOW_MEXTERNID := 174 
STATIC DEFINE NEWPERSONWINDOW_MFAX := 128 
STATIC DEFINE NEWPERSONWINDOW_MFIRSTNAME := 117 
STATIC DEFINE NEWPERSONWINDOW_MGENDER := 137 
STATIC DEFINE NEWPERSONWINDOW_MINITIALS := 118 
STATIC DEFINE NEWPERSONWINDOW_MLASTNAME := 115 
STATIC DEFINE NEWPERSONWINDOW_MMOBILE := 129 
STATIC DEFINE NEWPERSONWINDOW_MNAMEEXT := 119 
STATIC DEFINE NEWPERSONWINDOW_MOPC := 162 
STATIC DEFINE NEWPERSONWINDOW_MPERSID := 155 
STATIC DEFINE NEWPERSONWINDOW_MPOSTALCODE := 122 
STATIC DEFINE NEWPERSONWINDOW_MPREFIX := 116 
STATIC DEFINE NEWPERSONWINDOW_MPROPEXTR := 172 
STATIC DEFINE NEWPERSONWINDOW_MREMARKS := 134 
STATIC DEFINE NEWPERSONWINDOW_MTELBUSINESS := 126 
STATIC DEFINE NEWPERSONWINDOW_MTELHOME := 127 
STATIC DEFINE NEWPERSONWINDOW_MTITLE := 120 
STATIC DEFINE NEWPERSONWINDOW_MTYPE := 135 
STATIC DEFINE NEWPERSONWINDOW_OKBUTTON := 148 
STATIC DEFINE NEWPERSONWINDOW_SC_AD1 := 106 
STATIC DEFINE NEWPERSONWINDOW_SC_BANKNUMBER := 152 
STATIC DEFINE NEWPERSONWINDOW_SC_BDAT := 156 
STATIC DEFINE NEWPERSONWINDOW_SC_BDAT1 := 169 
STATIC DEFINE NEWPERSONWINDOW_SC_BDAT2 := 170 
STATIC DEFINE NEWPERSONWINDOW_SC_CLN := 153 
STATIC DEFINE NEWPERSONWINDOW_SC_DLG := 158 
STATIC DEFINE NEWPERSONWINDOW_SC_EXTERNID := 173 
STATIC DEFINE NEWPERSONWINDOW_SC_FAX := 113 
STATIC DEFINE NEWPERSONWINDOW_SC_HISN := 101 
STATIC DEFINE NEWPERSONWINDOW_SC_LAN := 110 
STATIC DEFINE NEWPERSONWINDOW_SC_MUTD := 157 
STATIC DEFINE NEWPERSONWINDOW_SC_NA1 := 100 
STATIC DEFINE NEWPERSONWINDOW_SC_NA2 := 103 
STATIC DEFINE NEWPERSONWINDOW_SC_NA3 := 104 
STATIC DEFINE NEWPERSONWINDOW_SC_OPC := 159 
STATIC DEFINE NEWPERSONWINDOW_SC_OPM := 114 
STATIC DEFINE NEWPERSONWINDOW_SC_PLA := 108 
STATIC DEFINE NEWPERSONWINDOW_SC_POS := 107 
STATIC DEFINE NEWPERSONWINDOW_SC_TAV := 109 
STATIC DEFINE NEWPERSONWINDOW_SC_TEL1 := 111 
STATIC DEFINE NEWPERSONWINDOW_SC_TEL2 := 112 
STATIC DEFINE NEWPERSONWINDOW_SC_TEL3 := 167 
STATIC DEFINE NEWPERSONWINDOW_SC_TEL4 := 171 
STATIC DEFINE NEWPERSONWINDOW_SC_TIT := 105 
STATIC DEFINE NEWPERSONWINDOW_SC_VRN := 102 
CLASS PersonBrowser INHERIT DataWindowMine 

	PROTECT oDCSearchUni AS SINGLELINEEDIT
	PROTECT oDCSC_NA1 AS FIXEDTEXT
	PROTECT oDCSC_POS AS FIXEDTEXT
	PROTECT oDCSearchSLE AS SINGLELINEEDIT
	PROTECT oDCSearchSZP AS SINGLELINEEDIT
	PROTECT oDCSearchBank AS SINGLELINEEDIT
	PROTECT oDCSearchCLN AS SINGLELINEEDIT
	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oCCUnionButton AS PUSHBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oCCPrintButton AS PUSHBUTTON
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oCCFindButton AS PUSHBUTTON
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oCCReset AS PUSHBUTTON
	PROTECT oSFPersonSubForm AS PersonSubForm

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
 	EXPORT oCaller AS OBJECT
	EXPORT cItemName	AS STRING
	EXPORT oReport AS PrintDialog
	EXPORT lUnique, lFoundUnique AS LOGIC
// 	PROTECT oAcc AS Account
// 	PROTECT oTrans as SQLSelect
// 	PROTECT oTransH as SQLSelect
	EXPORT oPers as SQLSelect
	PROTECT m_namen,m_waarden,Ann,m_adressen AS ARRAY
	PROTECT pKondp, pKondA AS _CODEBLOCK
	PROTECT pKond AS _CODEBLOCK
	PROTECT splaats AS STRING
	PROTECT oExtServer as SQLSelect
	PROTECT oEditPersonWindow AS NewPersonWindow
	PROTECT m12_bd as LOGIC  
	protect cSearch as USUAL
	export cFields, cFrom,cWhere,cOrder, cFilter as string
	export oPersCnt as PersonContainer  
	
	declare method PersonSelect 
RESOURCE PersonBrowser DIALOGEX  16, 17, 516, 300
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", PERSONBROWSER_SEARCHUNI, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 14, 116, 13
	CONTROL	"&Lastname:", PERSONBROWSER_SC_NA1, "Static", WS_CHILD, 16, 33, 36, 12
	CONTROL	"&Zip code:", PERSONBROWSER_SC_POS, "Static", WS_CHILD, 16, 49, 38, 13
	CONTROL	"", PERSONBROWSER_SEARCHSLE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 33, 80, 12
	CONTROL	"", PERSONBROWSER_SEARCHSZP, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 48, 79, 12
	CONTROL	"", PERSONBROWSER_SEARCHBANK, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 62, 79, 13
	CONTROL	"", PERSONBROWSER_SEARCHCLN, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 77, 79, 12
	CONTROL	"", PERSONBROWSER_PERSONSUBFORM, "static", WS_CHILD|WS_BORDER, 16, 109, 431, 164
	CONTROL	"&Edit", PERSONBROWSER_EDITBUTTON, "Button", WS_TABSTOP|WS_CHILD, 452, 107, 53, 12
	CONTROL	"&New", PERSONBROWSER_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 452, 146, 54, 12
	CONTROL	"&Delete", PERSONBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 452, 185, 54, 13
	CONTROL	"Merge to", PERSONBROWSER_UNIONBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 452, 223, 54, 12
	CONTROL	"Select", PERSONBROWSER_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 452, 260, 54, 13
	CONTROL	"&Bankaccount:", PERSONBROWSER_FIXEDTEXT2, "Static", WS_CHILD, 16, 64, 46, 12
	CONTROL	"Select&&Print", PERSONBROWSER_PRINTBUTTON, "Button", WS_TABSTOP|WS_CHILD, 452, 65, 54, 12
	CONTROL	"Persons", PERSONBROWSER_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 96, 500, 184
	CONTROL	"Search person with:", PERSONBROWSER_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 7, 3, 209, 89
	CONTROL	"Intern ID:", PERSONBROWSER_FIXEDTEXT3, "Static", WS_CHILD, 16, 78, 33, 12
	CONTROL	"Universal like google:", PERSONBROWSER_FIXEDTEXT4, "Static", WS_CHILD, 16, 14, 72, 13
	CONTROL	"Find", PERSONBROWSER_FINDBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 224, 14, 53, 13
	CONTROL	"Found:", PERSONBROWSER_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 224, 37, 28, 12
	CONTROL	"", PERSONBROWSER_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 260, 36, 47, 13
	CONTROL	"Reset", PERSONBROWSER_RESET, "Button", WS_TABSTOP|WS_CHILD, 224, 77, 53, 12
END

METHOD EditButton(lNew) CLASS PersonBrowser

	Default(@lNew,FALSE)
	IF !lNew.and.(SELF:Server:EOF.or.SELF:Server:BOF)
		(Errorbox{,"Select a person first"}):Show()
		RETURN
	ENDIF
	if Empty(self:oPersCnt)
		self:oPersCnt:=PersonContainer{}
	endif
	if lNew
		if Empty(self:oPersCnt:m51_lastname)
			self:oPersCnt:m51_lastname:=iif(Empty(self:SearchSLE),self:searchUni,self:SearchSLE)
		endif
		if Empty(self:oPersCnt:m51_POS).and.!Empty(self:SearchSZP)
			self:oPersCnt:m51_POS:=self:SearchSZP
		endif
		if Empty(self:oPersCnt:m56_banknumber) .and.!Empty(self:SearchBank) 
			self:oPersCnt:m56_banknumber:=self:SearchBank
		endif
	else
		self:oPersCnt:persid:=Str(self:Server:persid,-1)
	endif
	oEditPersonWindow := NewPersonWindow{ self:Owner,,self:Server,{lNew,false,self,self:oPersCnt }}
	oEditPersonWindow:Show()

	RETURN NIL
METHOD FindButton( ) CLASS PersonBrowser 
	LOCAL cMyFrom as STRING
	local aKeyw:={} as array
	local i,j as int
	local lStart as logic
	local aFields:={"lastname","firstname","postalcode","address","initials","nameext","prefix","city","attention","email","remarks","telbusiness","telhome","mobile"} as array 
	self:cWhere:=""
	cMyFrom:="person as p"
	if !Empty(self:SearchCLN)
			self:cWhere+=	iif(Empty(self:cWhere),""," and")+" p.persid = '"+AllTrim(self:SearchCLN)+"'"
	elseif !Empty(self:SearchBank)
		self:cWhere+=	iif(Empty(self:cWhere),""," and")+" b.banknumber = '"+AllTrim(self:SearchBank)+"' and p.persid=b.persid " 
		cMyFrom+=",personbank as b"
	else
		if !Empty(self:SearchUni) 
			aKeyw:=GetTokens(AllTrim(self:SearchUni))
			for i:=1 to Len(aKeyw)
				self:cWhere+=iif(i>1," and ("," (") 
				lStart:=false 
				aKeyw[i,1]:=StrTran(aKeyw[i,1],"'","\'")
				for j:=1 to Len(AFields)
					// 				if isnum(aKeyw[i,1]) .and. j<12 .or.j>11 .and.IsAlphabetic(aKeyw[i,1])
					// 					loop
					// 				endif 
					self:cWhere+=iif(lStart," or ","")+AFields[j]+" like '%"+aKeyw[i,1]+"%'" 
					lStart:=true
				next
				if !IsAlphabetic(aKeyw[i,1])
					self:cWhere+=iif(lStart," or ","")+"p.persid in (select b.persid from personbank as b where b.banknumber='"+aKeyw[i,1]+"')"
				endif
				self:cWhere+=")"
			next
		endif
		if !Empty(self:SearchSLE)
			self:cWhere+=	iif(Empty(self:cWhere),""," and")+" p.lastname like '"+StrTran(AllTrim(self:SearchSLE),"'","\'")+"%'"
		endif
		if !Empty(self:SearchSZP)
			self:cWhere+=	iif(Empty(self:cWhere),""," and")+" p.postalcode like '"+StandardZip(self:SearchSZP)+"%'"
		endif 
	endif 
	if !Empty(self:cFilter)
		self:cWhere+=	iif(Empty(self:cWhere),""," and ")+"("+self:cFilter+")"
	endif
	self:oPers:SQLString :="Select "+self:cFields+" from "+cMyFrom+iif(Empty(self:cWhere),""," where "+self:cWhere)+" order by "+self:cOrder
	self:oPers:Execute()

	self:FOUND :=Str(self:oPers:Reccount,-1) 
	if self:oPers:Reccount>0
		self:oCCOKButton:Enable()
	else
		self:oSFPersonSubForm:Browser:refresh()
		self:oCCOKButton:Disable()
	endif
	// 	if self:oPers:Reccount=1  
	// 		self:lFoundUnique := true
	// 	else
	// 		self:lFoundUnique := FALSE
	// 	endif   	

	RETURN nil
ASSIGN FOUND(uValue) CLASS PersonBrowser
self:FIELDPUT(#Found, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS PersonBrowser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"PersonBrowser",_GetInst()},iCtlID)

oDCSearchUni := SingleLineEdit{SELF,ResourceID{PERSONBROWSER_SEARCHUNI,_GetInst()}}
oDCSearchUni:HyperLabel := HyperLabel{#SearchUni,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchUni:FocusSelect := FSEL_TRIM
oDCSearchUni:TooltipText := "Enter one or more (part of) key values"
oDCSearchUni:UseHLforToolTip := True

oDCSC_NA1 := FixedText{SELF,ResourceID{PERSONBROWSER_SC_NA1,_GetInst()}}
oDCSC_NA1:HyperLabel := HyperLabel{#SC_NA1,_chr(38)+"Lastname:",NULL_STRING,NULL_STRING}

oDCSC_POS := FixedText{SELF,ResourceID{PERSONBROWSER_SC_POS,_GetInst()}}
oDCSC_POS:HyperLabel := HyperLabel{#SC_POS,_chr(38)+"Zip code:",NULL_STRING,NULL_STRING}

oDCSearchSLE := SingleLineEdit{SELF,ResourceID{PERSONBROWSER_SEARCHSLE,_GetInst()}}
oDCSearchSLE:HyperLabel := HyperLabel{#SearchSLE,NULL_STRING,NULL_STRING,"Lastname start with this value"}
oDCSearchSLE:UseHLforToolTip := True
oDCSearchSLE:TooltipText := "Enter characters persons last name should start with"

oDCSearchSZP := SingleLineEdit{SELF,ResourceID{PERSONBROWSER_SEARCHSZP,_GetInst()}}
oDCSearchSZP:HyperLabel := HyperLabel{#SearchSZP,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchSZP:UseHLforToolTip := False
oDCSearchSZP:TooltipText := "Enter characters to match pesons ZIP-code"

oDCSearchBank := SingleLineEdit{SELF,ResourceID{PERSONBROWSER_SEARCHBANK,_GetInst()}}
oDCSearchBank:HyperLabel := HyperLabel{#SearchBank,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchBank:UseHLforToolTip := False
oDCSearchBank:TooltipText := "Enter characters to match pesons Bank account"

oDCSearchCLN := SingleLineEdit{SELF,ResourceID{PERSONBROWSER_SEARCHCLN,_GetInst()}}
oDCSearchCLN:HyperLabel := HyperLabel{#SearchCLN,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchCLN:UseHLforToolTip := False
oDCSearchCLN:TooltipText := "Enter characters to match pesons internal ID"
oDCSearchCLN:Picture := "99999"

oCCEditButton := PushButton{SELF,ResourceID{PERSONBROWSER_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,_chr(38)+"Edit","Edit of a record","File_New"}
oCCEditButton:OwnerAlignment := OA_PX

oCCNewButton := PushButton{SELF,ResourceID{PERSONBROWSER_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,_chr(38)+"New",NULL_STRING,NULL_STRING}
oCCNewButton:OwnerAlignment := OA_PX

oCCDeleteButton := PushButton{SELF,ResourceID{PERSONBROWSER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,_chr(38)+"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PX

oCCUnionButton := PushButton{SELF,ResourceID{PERSONBROWSER_UNIONBUTTON,_GetInst()}}
oCCUnionButton:HyperLabel := HyperLabel{#UnionButton,"Merge to","Merge with another person",NULL_STRING}
oCCUnionButton:UseHLforToolTip := True
oCCUnionButton:OwnerAlignment := OA_PX

oCCOKButton := PushButton{SELF,ResourceID{PERSONBROWSER_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"Select","Return highlighted record",NULL_STRING}
oCCOKButton:UseHLforToolTip := True
oCCOKButton:OwnerAlignment := OA_PX

oDCFixedText2 := FixedText{SELF,ResourceID{PERSONBROWSER_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,_chr(38)+"Bankaccount:",NULL_STRING,NULL_STRING}

oCCPrintButton := PushButton{SELF,ResourceID{PERSONBROWSER_PRINTBUTTON,_GetInst()}}
oCCPrintButton:HyperLabel := HyperLabel{#PrintButton,"Select"+_chr(38)+_chr(38)+"Print","Select a certain group of persons and print them in a certain format",NULL_STRING}
oCCPrintButton:UseHLforToolTip := True
oCCPrintButton:OwnerAlignment := OA_PX

oDCGroupBox1 := GroupBox{SELF,ResourceID{PERSONBROWSER_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Persons",NULL_STRING,NULL_STRING}
oDCGroupBox1:OwnerAlignment := OA_PWIDTH_HEIGHT

oDCGroupBox2 := GroupBox{SELF,ResourceID{PERSONBROWSER_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Search person with:",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{PERSONBROWSER_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Intern ID:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{PERSONBROWSER_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Universal like google:",NULL_STRING,NULL_STRING}

oCCFindButton := PushButton{SELF,ResourceID{PERSONBROWSER_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Find",NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{PERSONBROWSER_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

oDCFound := FixedText{SELF,ResourceID{PERSONBROWSER_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oCCReset := PushButton{SELF,ResourceID{PERSONBROWSER_RESET,_GetInst()}}
oCCReset:HyperLabel := HyperLabel{#Reset,"Reset",NULL_STRING,NULL_STRING}

SELF:Caption := "Person Browser"
SELF:HyperLabel := HyperLabel{#PersonBrowser,"Person Browser",NULL_STRING,NULL_STRING}
SELF:DeferUse := False
SELF:AllowServerClose := False
SELF:PreventAutoLayout := True
SELF:Menu := WOMenu{}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFPersonSubForm := PersonSubForm{SELF,PERSONBROWSER_PERSONSUBFORM}
oSFPersonSubForm:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton CLASS PersonBrowser 
	self:SELECT()	
	RETURN NIL
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS PersonBrowser
	//Put your PostInit additions here
self:SetTexts()
	IF !SELF:oCaller==NULL_OBJECT
		oCCOKButton:Show()
	ENDIF
	IF AScan(aMenu,{|x| x[4]=="PersonEdit"})=0
    	SELF:oCCNewButton:Hide()
    	SELF:oCCDeleteButton:Hide()
    	self:oCCUnionButton:Hide()
    ENDIF
//    self:FOUND:=Str(self:oPers:Reccount,-1)
   self:FOUND:=Transform(SQLSelect{"select count(*) as totcount from person",oConn}:totcount,"")
   if self:oPers:Reccount>0
   	self:oCCOKButton:Enable()
   else
   	self:oCCOKButton:Disable()
   endif
   self:SearchSLE:=""
   self:SearchSZP:=""
   self:SearchUni:=""
	self:oDCSearchUni:SetFocus()
	RETURN nil
  
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS PersonBrowser
	//Put your PreInit additions here
// 	SELF:oExtServer:=oServer && save external server 
	self:cFields:= "p.persid,lastname,initials,firstname,prefix,datelastgift,address,postalcode,city,country"
	self:cFrom:="person as p"
	self:cOrder:="lastname" 
	self:oCaller := uExtra 
	if !Empty(oServer)
		self:oPers:=oServer
	else
		self:oPers:=SQLSelect{"select "+self:cFields+" from "+self:cFrom+" order by "+self:cOrder+" limit 100",oConn}
	endif
	self:oPersCnt:=PersonContainer{}
	RETURN NIL
METHOD PrintButton( ) CLASS PersonBrowser
	SELF:FilePrint()
	RETURN
method ReFind() class PersonBrowser
self:FindButton()
return 

ACCESS SearchBank() CLASS PersonBrowser
RETURN SELF:FieldGet(#SearchBank)

ASSIGN SearchBank(uValue) CLASS PersonBrowser
SELF:FieldPut(#SearchBank, uValue)
RETURN uValue

ACCESS SearchCLN() CLASS PersonBrowser
RETURN SELF:FieldGet(#SearchCLN)

ASSIGN SearchCLN(uValue) CLASS PersonBrowser
SELF:FieldPut(#SearchCLN, uValue)
RETURN uValue

ACCESS SearchSLE() CLASS PersonBrowser
RETURN SELF:FieldGet(#SearchSLE)

ASSIGN SearchSLE(uValue) CLASS PersonBrowser
SELF:FieldPut(#SearchSLE, uValue)
RETURN uValue

ACCESS SearchSZP() CLASS PersonBrowser
RETURN SELF:FieldGet(#SearchSZP)

ASSIGN SearchSZP(uValue) CLASS PersonBrowser
SELF:FieldPut(#SearchSZP, uValue)
RETURN uValue

ACCESS SearchUni() CLASS PersonBrowser
RETURN SELF:FieldGet(#SearchUni)

ASSIGN SearchUni(uValue) CLASS PersonBrowser
SELF:FieldPut(#SearchUni, uValue)
RETURN uValue
METHOD SELECT() CLASS PersonBrowser 
	IF !self:oCaller==null_object
	    IF IsMethod(self:oCaller, #Regperson)
    		IF !self:Server==null_object
    			IF self:Server:Reccount>0
					self:Hide()
					self:oCaller:Regperson(self:oPers,self:cItemName,true,self)
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	self:EndWindow()
	
	RETURN nil
METHOD UnionButton( ) CLASS PersonBrowser 
// Merge this person to another person: 
Local oPers:=self:Server as SQLSelect
LOCAL cValue := oPers:lastname as STRING
IF self:Server:EOF.or.self:Server:BOF
	(ErrorBox{,"Select a person first"}):Show()
	RETURN
ENDIF
PersonSelect(self,cValue,false,"persid<>'"+Str(oPers:persid,-1)+"'","person to merge with ")

RETURN NIL
STATIC DEFINE PERSONBROWSER_DELETEBUTTON := 110 
STATIC DEFINE PERSONBROWSER_EDITBUTTON := 108 
STATIC DEFINE PERSONBROWSER_FINDBUTTON := 119 
STATIC DEFINE PERSONBROWSER_FIXEDTEXT2 := 113 
STATIC DEFINE PERSONBROWSER_FIXEDTEXT3 := 117 
STATIC DEFINE PERSONBROWSER_FIXEDTEXT4 := 118 
STATIC DEFINE PERSONBROWSER_FOUND := 121 
STATIC DEFINE PERSONBROWSER_FOUNDTEXT := 120 
STATIC DEFINE PERSONBROWSER_GROUPBOX1 := 115 
STATIC DEFINE PERSONBROWSER_GROUPBOX2 := 116 
STATIC DEFINE PERSONBROWSER_NEWBUTTON := 109 
STATIC DEFINE PERSONBROWSER_OKBUTTON := 112 
STATIC DEFINE PERSONBROWSER_PERSONSUBFORM := 107 
STATIC DEFINE PERSONBROWSER_PRINTBUTTON := 114 
STATIC DEFINE PERSONBROWSER_RESET := 122 
STATIC DEFINE PERSONBROWSER_SC_NA1 := 101 
STATIC DEFINE PERSONBROWSER_SC_POS := 102 
STATIC DEFINE PERSONBROWSER_SEARCHBANK := 105 
STATIC DEFINE PERSONBROWSER_SEARCHCLN := 106 
STATIC DEFINE PERSONBROWSER_SEARCHSLE := 103 
STATIC DEFINE PERSONBROWSER_SEARCHSZP := 104 
STATIC DEFINE PERSONBROWSER_SEARCHUNI := 100 
STATIC DEFINE PERSONBROWSER_UNIONBUTTON := 111 
class PersonContainer
// class to contain person attributes
	EXPORT m51_initials, m51_lastname, m51_firstname, m51_title, m51_prefix, m51_pos, m51_ad1,m51_city, m56_banknumber as STRING
	export persid, m51_exid, m51_country, m51_gender, m51_type as STRING
	EXPORT md_address1, md_address2, md_address3, md_address4 as STRING 
	export current_PersonID as int 
	
	declare method Adres_Analyse

CLASS PersonSubForm INHERIT DataWindowMine 

	PROTECT oDBLASTNAME as JapDataColumn
	PROTECT oDBINITIALS as JapDataColumn
	PROTECT oDBFIRSTNAME as JapDataColumn
	PROTECT oDBPREFIX as JapDataColumn
	PROTECT oDBADDRESS as JapDataColumn
	PROTECT oDBPOSTALCODE as JapDataColumn
	PROTECT oDBDATELASTGIFT as JapDataColumn
	PROTECT oDBCITY as JapDataColumn
	PROTECT oDBCOUNTRY as JapDataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
RESOURCE PersonSubForm DIALOGEX  29, 27, 429, 163
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

ACCESS address() CLASS PersonSubForm
RETURN SELF:FieldGet(#address)

ASSIGN address(uValue) CLASS PersonSubForm
SELF:FieldPut(#address, uValue)
RETURN uValue

ACCESS banknumber() CLASS PersonSubForm
RETURN self:FIELDGET(#banknumber)

ASSIGN banknumber(uValue) CLASS PersonSubForm
self:FIELDPUT(#banknumber, uValue)
RETURN uValue

ACCESS city() CLASS PersonSubForm
RETURN SELF:FieldGet(#city)

ASSIGN city(uValue) CLASS PersonSubForm
SELF:FieldPut(#city, uValue)
RETURN uValue

ACCESS country() CLASS PersonSubForm
RETURN SELF:FieldGet(#country)

ASSIGN country(uValue) CLASS PersonSubForm
SELF:FieldPut(#country, uValue)
RETURN uValue

ACCESS datelastgift() CLASS PersonSubForm
RETURN SELF:FieldGet(#datelastgift)

ASSIGN datelastgift(uValue) CLASS PersonSubForm
SELF:FieldPut(#datelastgift, uValue)
RETURN uValue

ACCESS firstname() CLASS PersonSubForm
RETURN SELF:FieldGet(#firstname)

ASSIGN firstname(uValue) CLASS PersonSubForm
SELF:FieldPut(#firstname, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS PersonSubForm 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"PersonSubForm",_GetInst()},iCtlID)

SELF:Caption := "Browse persons"
SELF:HyperLabel := HyperLabel{#PersonSubForm,"Browse persons",NULL_STRING,NULL_STRING}
SELF:EnableStatusBar(True)
SELF:DeferUse := False
SELF:AllowServerClose := False
SELF:PreventAutoLayout := True
SELF:OwnerAlignment := OA_PWIDTH_HEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBLASTNAME := JapDataColumn{Person_NA1{}}
oDBLASTNAME:Width := 18
oDBLASTNAME:HyperLabel := HyperLabel{#lastname,"Lastname",NULL_STRING,NULL_STRING} 
oDBLASTNAME:Caption := "Lastname"
self:Browser:AddColumn(oDBLASTNAME)

oDBINITIALS := JapDataColumn{Person_NA2{}}
oDBINITIALS:Width := 7
oDBINITIALS:HyperLabel := HyperLabel{#initials,"Initials",NULL_STRING,NULL_STRING} 
oDBINITIALS:Caption := "Initials"
self:Browser:AddColumn(oDBINITIALS)

oDBFIRSTNAME := JapDataColumn{Person_VRN{}}
oDBFIRSTNAME:Width := 11
oDBFIRSTNAME:HyperLabel := HyperLabel{#firstname,"Firstname",NULL_STRING,NULL_STRING} 
oDBFIRSTNAME:Caption := "Firstname"
self:Browser:AddColumn(oDBFIRSTNAME)

oDBPREFIX := JapDataColumn{Person_HISN{}}
oDBPREFIX:Width := 6
oDBPREFIX:HyperLabel := HyperLabel{#prefix,"Prefix",NULL_STRING,"Person_HISN"} 
oDBPREFIX:Caption := "Prefix"
self:Browser:AddColumn(oDBPREFIX)

oDBADDRESS := JapDataColumn{Person_AD1{}}
oDBADDRESS:Width := 21
oDBADDRESS:HyperLabel := HyperLabel{#address,"Address",NULL_STRING,NULL_STRING} 
oDBADDRESS:Caption := "Address"
self:Browser:AddColumn(oDBADDRESS)

oDBPOSTALCODE := JapDataColumn{Person_POS{}}
oDBPOSTALCODE:Width := 8
oDBPOSTALCODE:HyperLabel := HyperLabel{#postalcode,"Zip code",NULL_STRING,"Person_POS"} 
oDBPOSTALCODE:Caption := "Zip code"
self:Browser:AddColumn(oDBPOSTALCODE)

oDBDATELASTGIFT := JapDataColumn{13}
oDBDATELASTGIFT:Width := 13
oDBDATELASTGIFT:HyperLabel := HyperLabel{#datelastgift,"Last Gift","date last gift",NULL_STRING} 
oDBDATELASTGIFT:Caption := "Last Gift"
oDBdatelastgift:BlockOwner := SELF:SERVER
self:Browser:AddColumn(oDBDATELASTGIFT)

oDBCITY := JapDataColumn{Person_PLA{}}
oDBCITY:Width := 13
oDBCITY:HyperLabel := HyperLabel{#city,"City",NULL_STRING,NULL_STRING} 
oDBCITY:Caption := "City"
self:Browser:AddColumn(oDBCITY)

oDBCOUNTRY := JapDataColumn{Person_LAN{}}
oDBCOUNTRY:Width := 8
oDBCOUNTRY:HyperLabel := HyperLabel{#country,"Country",NULL_STRING,"Person_LAN"} 
oDBCOUNTRY:Caption := "Country"
self:Browser:AddColumn(oDBCOUNTRY)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS initials() CLASS PersonSubForm
RETURN SELF:FieldGet(#initials)

ASSIGN initials(uValue) CLASS PersonSubForm
SELF:FieldPut(#initials, uValue)
RETURN uValue

ACCESS lastname() CLASS PersonSubForm
RETURN SELF:FieldGet(#lastname)

ASSIGN lastname(uValue) CLASS PersonSubForm
SELF:FieldPut(#lastname, uValue)
RETURN uValue

ACCESS postalcode() CLASS PersonSubForm
RETURN SELF:FieldGet(#postalcode)

ASSIGN postalcode(uValue) CLASS PersonSubForm
SELF:FieldPut(#postalcode, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS PersonSubForm
	//Put your PostInit additions here
self:SetTexts()
	self:Browser:SetStandardStyle(gbsReadOnly) 
	self:GoTop()
	RETURN nil 
ACCESS prefix() CLASS PersonSubForm
RETURN SELF:FieldGet(#prefix)

ASSIGN prefix(uValue) CLASS PersonSubForm
SELF:FieldPut(#prefix, uValue)
RETURN uValue

method PreInit(oWindow,iCtlID,oServer,uExtra) class PersonSubForm
	//Put your PreInit additions here 
	local oParent:=oWindow as PersonBrowser
 	oParent:Use(oParent:oPers) 
	return nil

STATIC DEFINE PERSONSUBFORM_ADDRESS := 101 
STATIC DEFINE PERSONSUBFORM_CITY := 104 
STATIC DEFINE PERSONSUBFORM_COUNTRY := 105 
STATIC DEFINE PERSONSUBFORM_DATELASTGIFT := 107 
STATIC DEFINE PERSONSUBFORM_FIRSTNAME := 108 
STATIC DEFINE PERSONSUBFORM_GIRONR := 107 
STATIC DEFINE PERSONSUBFORM_INITIALS := 102 
STATIC DEFINE PERSONSUBFORM_LASTNAME := 100 
STATIC DEFINE PERSONSUBFORM_POSTALCODE := 103 
STATIC DEFINE PERSONSUBFORM_PREFIX := 106 
STATIC DEFINE SELPERSABON_CANCELBUTTON := 102 
STATIC DEFINE SELPERSABON_OKBUTTON := 101 
STATIC DEFINE SELPERSABON_SELX_REK := 100 
RESOURCE SelPersChangeMailCodes DIALOGEX  8, 18, 404, 146
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Add/Remove Mailing Codes"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", SELPERSCHANGEMAILCODES_MCODADD5, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 316, 29, 73, 58
	CONTROL	"", SELPERSCHANGEMAILCODES_MCODADD4, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 240, 29, 73, 58
	CONTROL	"", SELPERSCHANGEMAILCODES_MCODADD3, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 164, 29, 73, 58
	CONTROL	"", SELPERSCHANGEMAILCODES_MCODADD2, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 88, 29, 73, 58
	CONTROL	"", SELPERSCHANGEMAILCODES_MCODADD1, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 12, 29, 73, 58
	CONTROL	"Add following mailing codes:", SELPERSCHANGEMAILCODES_CODEBOX, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 18, 389, 30
	CONTROL	"Perform the following actions within the selection of persons:", SELPERSCHANGEMAILCODES_FIXEDTEXT1, "Static", WS_CHILD, 4, 0, 292, 12
	CONTROL	"", SELPERSCHANGEMAILCODES_MCODDEL5, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 316, 73, 73, 58
	CONTROL	"", SELPERSCHANGEMAILCODES_MCODDEL4, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 240, 73, 73, 58
	CONTROL	"", SELPERSCHANGEMAILCODES_MCODDEL3, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 164, 73, 73, 58
	CONTROL	"", SELPERSCHANGEMAILCODES_MCODDEL2, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 88, 73, 73, 58
	CONTROL	"", SELPERSCHANGEMAILCODES_MCODDEL1, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 12, 73, 73, 58
	CONTROL	"Remove following mailing codes:", SELPERSCHANGEMAILCODES_CODEBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 61, 389, 31
	CONTROL	"OK", SELPERSCHANGEMAILCODES_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 339, 116, 53, 12
	CONTROL	"Cancel", SELPERSCHANGEMAILCODES_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 277, 116, 53, 12
END

CLASS SelPersChangeMailCodes INHERIT DialogWinDowExtra 

	PROTECT oDCmCodAdd5 AS COMBOBOX
	PROTECT oDCmCodAdd4 AS COMBOBOX
	PROTECT oDCmCodAdd3 AS COMBOBOX
	PROTECT oDCmCodAdd2 AS COMBOBOX
	PROTECT oDCmCodAdd1 AS COMBOBOX
	PROTECT oDCCodeBox AS GROUPBOX
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCmCodDel5 AS COMBOBOX
	PROTECT oDCmCodDel4 AS COMBOBOX
	PROTECT oDCmCodDel3 AS COMBOBOX
	PROTECT oDCmCodDel2 AS COMBOBOX
	PROTECT oDCmCodDel1 AS COMBOBOX
	PROTECT oDCCodeBox1 AS GROUPBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  PROTECT oCaller AS OBJECT
METHOD CancelButton( ) CLASS SelPersChangeMailCodes
	oCaller:selx_OK := FALSE
	self:EndDialog()
METHOD Init(oParent,uExtra) CLASS SelPersChangeMailCodes 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"SelPersChangeMailCodes",_GetInst()},TRUE)

aFonts[1] := Font{,9,"Microsoft Sans Serif"}

oDCmCodAdd5 := combobox{SELF,ResourceID{SELPERSCHANGEMAILCODES_MCODADD5,_GetInst()}}
oDCmCodAdd5:HyperLabel := HyperLabel{#mCodAdd5,NULL_STRING,"Mailing code",NULL_STRING}

oDCmCodAdd4 := combobox{SELF,ResourceID{SELPERSCHANGEMAILCODES_MCODADD4,_GetInst()}}
oDCmCodAdd4:HyperLabel := HyperLabel{#mCodAdd4,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCodAdd4:FillUsing(pers_codes)

oDCmCodAdd3 := combobox{SELF,ResourceID{SELPERSCHANGEMAILCODES_MCODADD3,_GetInst()}}
oDCmCodAdd3:HyperLabel := HyperLabel{#mCodAdd3,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCodAdd3:FillUsing(pers_codes)

oDCmCodAdd2 := combobox{SELF,ResourceID{SELPERSCHANGEMAILCODES_MCODADD2,_GetInst()}}
oDCmCodAdd2:HyperLabel := HyperLabel{#mCodAdd2,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCodAdd2:FillUsing(pers_codes)

oDCmCodAdd1 := combobox{SELF,ResourceID{SELPERSCHANGEMAILCODES_MCODADD1,_GetInst()}}
oDCmCodAdd1:HyperLabel := HyperLabel{#mCodAdd1,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCodAdd1:FillUsing(pers_codes)

oDCCodeBox := GroupBox{SELF,ResourceID{SELPERSCHANGEMAILCODES_CODEBOX,_GetInst()}}
oDCCodeBox:HyperLabel := HyperLabel{#CodeBox,"Add following mailing codes:",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{SELPERSCHANGEMAILCODES_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Perform the following actions within the selection of persons:",NULL_STRING,NULL_STRING}
oDCFixedText1:Font(aFonts[1], FALSE)

oDCmCodDel5 := combobox{SELF,ResourceID{SELPERSCHANGEMAILCODES_MCODDEL5,_GetInst()}}
oDCmCodDel5:HyperLabel := HyperLabel{#mCodDel5,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCodDel5:FillUsing(pers_codes)

oDCmCodDel4 := combobox{SELF,ResourceID{SELPERSCHANGEMAILCODES_MCODDEL4,_GetInst()}}
oDCmCodDel4:HyperLabel := HyperLabel{#mCodDel4,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCodDel4:FillUsing(pers_codes)

oDCmCodDel3 := combobox{SELF,ResourceID{SELPERSCHANGEMAILCODES_MCODDEL3,_GetInst()}}
oDCmCodDel3:HyperLabel := HyperLabel{#mCodDel3,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCodDel3:FillUsing(pers_codes)

oDCmCodDel2 := combobox{SELF,ResourceID{SELPERSCHANGEMAILCODES_MCODDEL2,_GetInst()}}
oDCmCodDel2:HyperLabel := HyperLabel{#mCodDel2,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCodDel2:FillUsing(pers_codes)

oDCmCodDel1 := combobox{SELF,ResourceID{SELPERSCHANGEMAILCODES_MCODDEL1,_GetInst()}}
oDCmCodDel1:HyperLabel := HyperLabel{#mCodDel1,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCodDel1:FillUsing(pers_codes)

oDCCodeBox1 := GroupBox{SELF,ResourceID{SELPERSCHANGEMAILCODES_CODEBOX1,_GetInst()}}
oDCCodeBox1:HyperLabel := HyperLabel{#CodeBox1,"Remove following mailing codes:",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{SELPERSCHANGEMAILCODES_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{SELPERSCHANGEMAILCODES_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

SELF:Caption := "Add/Remove Mailing Codes"
SELF:HyperLabel := HyperLabel{#SelPersChangeMailCodes,"Add/Remove Mailing Codes",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS SelPersChangeMailCodes
	// save add and del codes in parent arrays
	self:oCaller:AddMailCds:=MakeCodes({self:oDCmCodAdd1:Value,self:oDCmCodAdd2:Value,self:oDCmCodAdd3:Value,self:oDCmCodAdd4:Value,self:oDCmCodAdd5:VALUE})
	self:oCaller:DelMailCds:=MakeCodes({self:oDCmCodDel1:Value,self:oDCmCodDel2:Value,self:oDCmCodDel3:Value,self:oDCmCodDel4:Value,self:oDCmCodDel5:VALUE})
	SELF:EndDialog(0)

	
METHOD PostInit(oParent,uExtra) CLASS SelPersChangeMailCodes
	//Put your PostInit additions here
	self:SetTexts()
	oCaller:=oParent
	RETURN NIL
STATIC DEFINE SELPERSCHANGEMAILCODES_CANCELBUTTON := 114 
STATIC DEFINE SELPERSCHANGEMAILCODES_CODEBOX := 105 
STATIC DEFINE SELPERSCHANGEMAILCODES_CODEBOX1 := 112 
STATIC DEFINE SELPERSCHANGEMAILCODES_FIXEDTEXT1 := 106 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODADD1 := 104 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODADD2 := 103 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODADD3 := 102 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODADD4 := 101 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODADD5 := 100 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODADD6 := 100 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODDEL1 := 111 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODDEL2 := 110 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODDEL3 := 109 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODDEL4 := 108 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODDEL5 := 107 
STATIC DEFINE SELPERSCHANGEMAILCODES_MCODDEL6 := 108 
STATIC DEFINE SELPERSCHANGEMAILCODES_OKBUTTON := 113 
CLASS SelPersExport INHERIT DialogWinDowExtra 

	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCSubSet AS LISTBOX
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCExportFormat AS RADIOBUTTONGROUP
	PROTECT oCCTabButton AS RADIOBUTTON
	PROTECT oCCCSVButton AS RADIOBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  PROTECT MyFields AS ARRAY
  PROTECT myParent AS OBJECT
RESOURCE SelPersExport DIALOGEX  11, 22, 280, 226
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Specify persons to export"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Ok", SELPERSEXPORT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 221, 3, 53, 13
	CONTROL	"Cancel", SELPERSEXPORT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 160, 3, 53, 13
	CONTROL	"", SELPERSEXPORT_SUBSET, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 12, 17, 125, 193, WS_EX_CLIENTEDGE
	CONTROL	"Required fields to export:", SELPERSEXPORT_FIXEDTEXT1, "Static", WS_CHILD, 13, 3, 92, 13
	CONTROL	"Export format:", SELPERSEXPORT_EXPORTFORMAT, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 158, 28, 114, 50
	CONTROL	"Tab separated text (TXT)", SELPERSEXPORT_TABBUTTON, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 166, 40, 102, 11
	CONTROL	"Comma separated file (CSV)", SELPERSEXPORT_CSVBUTTON, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 166, 58, 102, 11
END

METHOD CancelButton( ) CLASS SelPersExport
	SELF:myParent:myFields:={}
SELF:EndDialog(1)
METHOD Init(oParent,uExtra) CLASS SelPersExport 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"SelPersExport",_GetInst()},TRUE)

oCCOKButton := PushButton{SELF,ResourceID{SELPERSEXPORT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"Ok",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{SELPERSEXPORT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCSubSet := ListBox{SELF,ResourceID{SELPERSEXPORT_SUBSET,_GetInst()}}
oDCSubSet:TooltipText := "Select subset of given range"
oDCSubSet:HyperLabel := HyperLabel{#SubSet,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{SELPERSEXPORT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Required fields to export:",NULL_STRING,NULL_STRING}

oCCTabButton := RadioButton{SELF,ResourceID{SELPERSEXPORT_TABBUTTON,_GetInst()}}
oCCTabButton:HyperLabel := HyperLabel{#TabButton,"Tab separated text (TXT)",NULL_STRING,NULL_STRING}

oCCCSVButton := RadioButton{SELF,ResourceID{SELPERSEXPORT_CSVBUTTON,_GetInst()}}
oCCCSVButton:HyperLabel := HyperLabel{#CSVButton,"Comma separated file (CSV)",NULL_STRING,NULL_STRING}

oDCExportFormat := RadioButtonGroup{SELF,ResourceID{SELPERSEXPORT_EXPORTFORMAT,_GetInst()}}
oDCExportFormat:FillUsing({ ;
							{oCCTabButton,"TXT"}, ;
							{oCCCSVButton,"CSV"} ;
							})
oDCExportFormat:HyperLabel := HyperLabel{#ExportFormat,"Export format:",NULL_STRING,NULL_STRING}

SELF:Caption := "Specify persons to export"
SELF:HyperLabel := HyperLabel{#SelPersExport,"Specify persons to export",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS SelPersExport
	LOCAL i as int
	LOCAL cRoot := "WYC\Runtime", cFields as STRING
	
	myParent:myFields:={}
	FOR i = 1 to oDCSubSet:ItemCount	
		IF oDCSubSet:IsSelected(i)
			AAdd(myParent:myFields,self:myFields[i])
			cFields := cFields+ if(Empty(cFields),"",",") + AllTrim(Str(i))
		ENDIF
	NEXT
	SetRTRegString(cRoot,"ExpFields", cFields)
	myParent:ExportFormat:=self:oDCExportFormat:Value		

self:EndDialog(0)
	RETURN	
METHOD PostInit(oParent,uExtra) CLASS SelPersExport
	//Put your PostInit additions here
	LOCAL afill:={} AS ARRAY
	LOCAL cRoot := "WYC\Runtime", cFields AS STRING, aFields AS ARRAY
	LOCAL i AS INT
	self:SetTexts()
	cFields:=QueryRTRegString( cRoot, "ExpFields")
	
	FOR i = 1 TO Len(myFields)
		AAdd(afill,{myFields[i,3]:Hyperlabel:Description})
	NEXT
	SELF:oDCSubSet:FillUsing(aFill)
	IF Empty(cFields)
		FOR i = 1 TO Len(aFill)
			SELF:oDCSubSet:SelectItem(i)		
		NEXT
	ELSE
		aFields := MExec(MCompile("{" + cFields + "}"))
		FOR i =1 TO Len(aFields)
			SELF:oDCSubSet:SelectItem(aFields[i])	
		NEXT
	ENDIF
	IF IsArray(uExtra) .and.Len(uExtra)>1
		self:Caption:=uExtra[2]
	endif
	self:oDCExportFormat:Value:="CSV"
	RETURN NIL
METHOD PreInit(oParent,uExtra) CLASS SelPersExport
	//Put your PreInit additions here
	IF IsArray(uExtra)
		if IsArray(uExtra[1])
			self:MyFields := uExtra[1]
		endif
	ENDIF
	myParent:=oParent
	RETURN NIL

STATIC DEFINE SELPERSEXPORT_CANCELBUTTON := 101 
STATIC DEFINE SELPERSEXPORT_CSVBUTTON := 106 
STATIC DEFINE SELPERSEXPORT_EXPORTFORMAT := 104 
STATIC DEFINE SELPERSEXPORT_FIXEDTEXT1 := 103 
STATIC DEFINE SELPERSEXPORT_OKBUTTON := 100 
STATIC DEFINE SELPERSEXPORT_SUBSET := 102 
STATIC DEFINE SELPERSEXPORT_TABBUTTON := 105 
STATIC DEFINE SELPERSGIFTS_BEGIN_BED := 109 
STATIC DEFINE SELPERSGIFTS_CANCELBUTTON := 111 
STATIC DEFINE SELPERSGIFTS_DONATION := 103 
STATIC DEFINE SELPERSGIFTS_FIXEDTEXT3 := 108 
STATIC DEFINE SELPERSGIFTS_GROUPBOXSOORT := 112 
STATIC DEFINE SELPERSGIFTS_OKBUTTON := 110 
STATIC DEFINE SELPERSGIFTS_PAYMETHOD := 104 
STATIC DEFINE SELPERSGIFTS_RADIOBUTTON1 := 105 
STATIC DEFINE SELPERSGIFTS_RADIOBUTTON2 := 106 
STATIC DEFINE SELPERSGIFTS_RADIOBUTTON3 := 107 
STATIC DEFINE SELPERSGIFTS_SELX_REK := 100 
STATIC DEFINE SELPERSGIFTS_STANDARDG := 101 
STATIC DEFINE SELPERSGIFTS_SUBSCRIPT := 102 
STATIC DEFINE SELPERSINVOICE_BEGIN_VERV := 102 
STATIC DEFINE SELPERSINVOICE_CANCELBUTTON := 105 
STATIC DEFINE SELPERSINVOICE_EIND_VERV := 103 
STATIC DEFINE SELPERSINVOICE_FIXEDTEXT1 := 100 
STATIC DEFINE SELPERSINVOICE_FIXEDTEXT2 := 101 
STATIC DEFINE SELPERSINVOICE_OKBUTTON := 104 
CLASS SelPersMailCd INHERIT DialogWinDowExtra 

	PROTECT oDCDLG_Start AS SINGLELINEEDIT
	PROTECT oDCDLG_End AS SINGLELINEEDIT
	PROTECT oDCBdat_Start AS SINGLELINEEDIT
	PROTECT oDCBdat_End AS SINGLELINEEDIT
	PROTECT oDCMutd_Start AS SINGLELINEEDIT
	PROTECT oDCMutd_End AS SINGLELINEEDIT
	PROTECT oDCeerste AS SINGLELINEEDIT
	PROTECT oDClaatste AS SINGLELINEEDIT
	PROTECT oDCsortorder AS RADIOBUTTONGROUP
	PROTECT oCCSortButton1 AS RADIOBUTTON
	PROTECT oCCSortButton2 AS RADIOBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCGroupBox6 AS GROUPBOX
	PROTECT oDCGroupBox4 AS GROUPBOX
	PROTECT oDCGroupBox3 AS GROUPBOX
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCGroupBox7 AS GROUPBOX
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCGroupBox8 AS GROUPBOX
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oDCAndCod AS LISTBOXEXTRA
	PROTECT oDCOrCod AS LISTBOXEXTRA
	PROTECT oDCNonCod AS LISTBOXEXTRA
	PROTECT oDCFixedText9 AS FIXEDTEXT
	PROTECT oDCTypes AS LISTBOXEXTRA
	PROTECT oDCGroupBox9 AS GROUPBOX
	PROTECT oDCGroupBox10 AS GROUPBOX
	PROTECT oDCGenders AS LISTBOXEXTRA
	PROTECT oDCOutputAction AS RADIOBUTTONGROUP
	PROTECT oCCAction1 AS RADIOBUTTON
	PROTECT oCCAction2 AS RADIOBUTTON
	PROTECT oCCAction3 AS RADIOBUTTON
	PROTECT oCCAction4 AS RADIOBUTTON
	PROTECT oCCAction5 AS RADIOBUTTON
	PROTECT oCCAction6 AS RADIOBUTTON
	PROTECT oCCAction7 AS RADIOBUTTON
	PROTECT oDCGroupBoxPersonal AS GROUPBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  PROTECT oCaller as SelPers
  PROTECT cType AS STRING
  PROTECT aPropEx:={} as ARRAY 
  
  declare method ExtraPropCondition 
RESOURCE SelPersMailCd DIALOGEX  36, 27, 471, 273
STYLE	DS_3DLOOK|WS_POPUP|WS_CAPTION|WS_SYSMENU|WS_THICKFRAME
CAPTION	"Selection of people by person parameters"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", SELPERSMAILCD_DLG_START, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 41, 136, 65, 12, WS_EX_CLIENTEDGE
	CONTROL	"", SELPERSMAILCD_DLG_END, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 41, 150, 65, 13, WS_EX_CLIENTEDGE
	CONTROL	"", SELPERSMAILCD_BDAT_START, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 164, 136, 64, 12, WS_EX_CLIENTEDGE
	CONTROL	"", SELPERSMAILCD_BDAT_END, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 164, 150, 64, 12, WS_EX_CLIENTEDGE
	CONTROL	"", SELPERSMAILCD_MUTD_START, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 287, 136, 65, 12, WS_EX_CLIENTEDGE
	CONTROL	"", SELPERSMAILCD_MUTD_END, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 287, 150, 65, 12, WS_EX_CLIENTEDGE
	CONTROL	"", SELPERSMAILCD_EERSTE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 41, 182, 65, 12
	CONTROL	"", SELPERSMAILCD_LAATSTE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 41, 197, 65, 12
	CONTROL	"Sort on:", SELPERSMAILCD_SORTORDER, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 398, 148, 61, 39
	CONTROL	"Postal code", SELPERSMAILCD_SORTBUTTON1, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 400, 158, 54, 11
	CONTROL	"Name", SELPERSMAILCD_SORTBUTTON2, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 402, 172, 56, 11
	CONTROL	"up to:", SELPERSMAILCD_FIXEDTEXT1, "Static", WS_CHILD, 10, 197, 20, 12
	CONTROL	"From:", SELPERSMAILCD_FIXEDTEXT2, "Static", WS_CHILD, 10, 182, 19, 12
	CONTROL	"None of (exclusion)", SELPERSMAILCD_GROUPBOX6, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 248, 14, 110, 105
	CONTROL	"Postal code selection:", SELPERSMAILCD_GROUPBOX4, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 173, 110, 40
	CONTROL	"one or more of (addition)", SELPERSMAILCD_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 124, 14, 110, 105
	CONTROL	"All of next mail codes (intersection)", SELPERSMAILCD_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 0, 14, 110, 105
	CONTROL	"Between:", SELPERSMAILCD_FIXEDTEXT3, "Static", WS_CHILD, 9, 135, 31, 10
	CONTROL	"and:", SELPERSMAILCD_FIXEDTEXT4, "Static", WS_CHILD, 24, 150, 14, 10
	CONTROL	"Date Last Gift selection:", SELPERSMAILCD_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 126, 110, 40
	CONTROL	"Date Last Altered selection:", SELPERSMAILCD_GROUPBOX7, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 252, 127, 110, 40
	CONTROL	"and:", SELPERSMAILCD_FIXEDTEXT5, "Static", WS_CHILD, 270, 150, 15, 10
	CONTROL	"Between:", SELPERSMAILCD_FIXEDTEXT6, "Static", WS_CHILD, 256, 135, 32, 10
	CONTROL	"OK", SELPERSMAILCD_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 402, 8, 54, 12
	CONTROL	"Cancel", SELPERSMAILCD_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 404, 29, 54, 12
	CONTROL	"Date Creation selection:", SELPERSMAILCD_GROUPBOX8, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 127, 126, 110, 40
	CONTROL	"and:", SELPERSMAILCD_FIXEDTEXT7, "Static", WS_CHILD, 147, 150, 15, 10
	CONTROL	"Between:", SELPERSMAILCD_FIXEDTEXT8, "Static", WS_CHILD, 133, 135, 31, 10
	CONTROL	"", SELPERSMAILCD_ANDCOD, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_USETABSTOPS|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 4, 25, 100, 88, WS_EX_CLIENTEDGE
	CONTROL	"", SELPERSMAILCD_ORCOD, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_USETABSTOPS|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 128, 27, 100, 88, WS_EX_CLIENTEDGE
	CONTROL	"", SELPERSMAILCD_NONCOD, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_USETABSTOPS|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 252, 26, 100, 88, WS_EX_CLIENTEDGE
	CONTROL	"Required persons should contain:", SELPERSMAILCD_FIXEDTEXT9, "Static", WS_CHILD, 4, 0, 169, 12
	CONTROL	"", SELPERSMAILCD_TYPES, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_USETABSTOPS|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 132, 182, 100, 43, WS_EX_CLIENTEDGE
	CONTROL	"Possible types of persons:", SELPERSMAILCD_GROUPBOX9, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 128, 173, 110, 56
	CONTROL	"Possible genders of persons:", SELPERSMAILCD_GROUPBOX10, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 250, 172, 110, 56
	CONTROL	"", SELPERSMAILCD_GENDERS, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_USETABSTOPS|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 254, 182, 100, 42, WS_EX_CLIENTEDGE
	CONTROL	"Required Output/Action:", SELPERSMAILCD_OUTPUTACTION, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 364, 44, 94, 89
	CONTROL	"&Compact Person List", SELPERSMAILCD_ACTION1, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 368, 51, 80, 11
	CONTROL	"&Extended Person List", SELPERSMAILCD_ACTION2, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 368, 62, 80, 11
	CONTROL	"&Labels", SELPERSMAILCD_ACTION3, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 368, 73, 80, 11
	CONTROL	"Le&tters", SELPERSMAILCD_ACTION4, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 368, 84, 80, 12
	CONTROL	"&Giro Accepts", SELPERSMAILCD_ACTION5, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 368, 118, 80, 11
	CONTROL	"&Spreadsheet file (Excel)", SELPERSMAILCD_ACTION6, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 368, 96, 86, 11
	CONTROL	"Change &mailing codes", SELPERSMAILCD_ACTION7, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 368, 107, 80, 11
	CONTROL	"Personal:", SELPERSMAILCD_GROUPBOXPERSONAL, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 236, 460, 15, WS_EX_TRANSPARENT
END

METHOD CancelButton( ) CLASS SelPersMailCd
	self:EndDialog(0)
	
	RETURN NIL
METHOD Close(oEvent) CLASS SelPersMailCd
	SUPER:Close(oEvent)
	//Put your changes here 
	SELF:Destroy()
	RETURN NIL
METHOD Init(oParent,uExtra) CLASS SelPersMailCd 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"SelPersMailCd",_GetInst()},TRUE)

aFonts[1] := Font{,10,"Microsoft Sans Serif"}
aFonts[1]:Bold := TRUE

oDCDLG_Start := SingleLineEdit{SELF,ResourceID{SELPERSMAILCD_DLG_START,_GetInst()}}
oDCDLG_Start:Picture := "@D"
oDCDLG_Start:HyperLabel := HyperLabel{#DLG_Start,NULL_STRING,NULL_STRING,NULL_STRING}
oDCDLG_Start:FieldSpec := Person_DLG{}

oDCDLG_End := SingleLineEdit{SELF,ResourceID{SELPERSMAILCD_DLG_END,_GetInst()}}
oDCDLG_End:Picture := "@D"
oDCDLG_End:HyperLabel := HyperLabel{#DLG_End,NULL_STRING,NULL_STRING,NULL_STRING}
oDCDLG_End:FieldSpec := Person_DLG{}

oDCBdat_Start := SingleLineEdit{SELF,ResourceID{SELPERSMAILCD_BDAT_START,_GetInst()}}
oDCBdat_Start:Picture := "@D"
oDCBdat_Start:HyperLabel := HyperLabel{#Bdat_Start,NULL_STRING,NULL_STRING,NULL_STRING}
oDCBdat_Start:FieldSpec := Person_BDAT{}

oDCBdat_End := SingleLineEdit{SELF,ResourceID{SELPERSMAILCD_BDAT_END,_GetInst()}}
oDCBdat_End:Picture := "@D"
oDCBdat_End:HyperLabel := HyperLabel{#Bdat_End,NULL_STRING,NULL_STRING,NULL_STRING}
oDCBdat_End:FieldSpec := Person_BDAT{}

oDCMutd_Start := SingleLineEdit{SELF,ResourceID{SELPERSMAILCD_MUTD_START,_GetInst()}}
oDCMutd_Start:Picture := "@D"
oDCMutd_Start:HyperLabel := HyperLabel{#Mutd_Start,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMutd_Start:FieldSpec := Person_MUTD{}

oDCMutd_End := SingleLineEdit{SELF,ResourceID{SELPERSMAILCD_MUTD_END,_GetInst()}}
oDCMutd_End:Picture := "@D"
oDCMutd_End:HyperLabel := HyperLabel{#Mutd_End,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMutd_End:FieldSpec := Person_MUTD{}

oDCeerste := SingleLineEdit{SELF,ResourceID{SELPERSMAILCD_EERSTE,_GetInst()}}
oDCeerste:HyperLabel := HyperLabel{#eerste,NULL_STRING,NULL_STRING,NULL_STRING}

oDClaatste := SingleLineEdit{SELF,ResourceID{SELPERSMAILCD_LAATSTE,_GetInst()}}
oDClaatste:HyperLabel := HyperLabel{#laatste,NULL_STRING,NULL_STRING,NULL_STRING}

oCCSortButton1 := RadioButton{SELF,ResourceID{SELPERSMAILCD_SORTBUTTON1,_GetInst()}}
oCCSortButton1:HyperLabel := HyperLabel{#SortButton1,"Postal code",NULL_STRING,NULL_STRING}

oCCSortButton2 := RadioButton{SELF,ResourceID{SELPERSMAILCD_SORTBUTTON2,_GetInst()}}
oCCSortButton2:HyperLabel := HyperLabel{#SortButton2,"Name",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{SELPERSMAILCD_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"up to:",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{SELPERSMAILCD_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"From:",NULL_STRING,NULL_STRING}

oDCGroupBox6 := GroupBox{SELF,ResourceID{SELPERSMAILCD_GROUPBOX6,_GetInst()}}
oDCGroupBox6:HyperLabel := HyperLabel{#GroupBox6,"None of (exclusion)",NULL_STRING,NULL_STRING}

oDCGroupBox4 := GroupBox{SELF,ResourceID{SELPERSMAILCD_GROUPBOX4,_GetInst()}}
oDCGroupBox4:HyperLabel := HyperLabel{#GroupBox4,"Postal code selection:",NULL_STRING,NULL_STRING}

oDCGroupBox3 := GroupBox{SELF,ResourceID{SELPERSMAILCD_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"one or more of (addition)",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{SELPERSMAILCD_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"All of next mail codes (intersection)",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{SELPERSMAILCD_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Between:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{SELPERSMAILCD_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"and:",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{SELPERSMAILCD_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Date Last Gift selection:",NULL_STRING,NULL_STRING}

oDCGroupBox7 := GroupBox{SELF,ResourceID{SELPERSMAILCD_GROUPBOX7,_GetInst()}}
oDCGroupBox7:HyperLabel := HyperLabel{#GroupBox7,"Date Last Altered selection:",NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{SELPERSMAILCD_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"and:",NULL_STRING,NULL_STRING}

oDCFixedText6 := FixedText{SELF,ResourceID{SELPERSMAILCD_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"Between:",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{SELPERSMAILCD_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{SELPERSMAILCD_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCGroupBox8 := GroupBox{SELF,ResourceID{SELPERSMAILCD_GROUPBOX8,_GetInst()}}
oDCGroupBox8:HyperLabel := HyperLabel{#GroupBox8,"Date Creation selection:",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{SELPERSMAILCD_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"and:",NULL_STRING,NULL_STRING}

oDCFixedText8 := FixedText{SELF,ResourceID{SELPERSMAILCD_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"Between:",NULL_STRING,NULL_STRING}

oDCAndCod := ListboxExtra{SELF,ResourceID{SELPERSMAILCD_ANDCOD,_GetInst()}}
oDCAndCod:FillUsing(pers_codes)
oDCAndCod:HyperLabel := HyperLabel{#AndCod,NULL_STRING,NULL_STRING,NULL_STRING}

oDCOrCod := ListboxExtra{SELF,ResourceID{SELPERSMAILCD_ORCOD,_GetInst()}}
oDCOrCod:FillUsing(pers_codes)
oDCOrCod:HyperLabel := HyperLabel{#OrCod,NULL_STRING,NULL_STRING,NULL_STRING}

oDCNonCod := ListboxExtra{SELF,ResourceID{SELPERSMAILCD_NONCOD,_GetInst()}}
oDCNonCod:FillUsing(pers_codes)
oDCNonCod:HyperLabel := HyperLabel{#NonCod,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText9 := FixedText{SELF,ResourceID{SELPERSMAILCD_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"Required persons should contain:",NULL_STRING,NULL_STRING}
oDCFixedText9:Font(aFonts[1], FALSE)

oDCTypes := ListboxExtra{SELF,ResourceID{SELPERSMAILCD_TYPES,_GetInst()}}
oDCTypes:HyperLabel := HyperLabel{#Types,NULL_STRING,"Select one or more types of the required persons",NULL_STRING}
oDCTypes:UseHLforToolTip := True
oDCTypes:FillUsing(pers_types)

oDCGroupBox9 := GroupBox{SELF,ResourceID{SELPERSMAILCD_GROUPBOX9,_GetInst()}}
oDCGroupBox9:HyperLabel := HyperLabel{#GroupBox9,"Possible types of persons:",NULL_STRING,NULL_STRING}

oDCGroupBox10 := GroupBox{SELF,ResourceID{SELPERSMAILCD_GROUPBOX10,_GetInst()}}
oDCGroupBox10:HyperLabel := HyperLabel{#GroupBox10,"Possible genders of persons:",NULL_STRING,NULL_STRING}

oDCGenders := ListboxExtra{SELF,ResourceID{SELPERSMAILCD_GENDERS,_GetInst()}}
oDCGenders:HyperLabel := HyperLabel{#Genders,NULL_STRING,"Select one or more possible genders of the required persons",NULL_STRING}
oDCGenders:UseHLforToolTip := True
oDCGenders:FillUsing(pers_gender)

oCCAction1 := RadioButton{SELF,ResourceID{SELPERSMAILCD_ACTION1,_GetInst()}}
oCCAction1:HyperLabel := HyperLabel{#Action1,_chr(38)+"Compact Person List",NULL_STRING,NULL_STRING}

oCCAction2 := RadioButton{SELF,ResourceID{SELPERSMAILCD_ACTION2,_GetInst()}}
oCCAction2:HyperLabel := HyperLabel{#Action2,_chr(38)+"Extended Person List",NULL_STRING,NULL_STRING}

oCCAction3 := RadioButton{SELF,ResourceID{SELPERSMAILCD_ACTION3,_GetInst()}}
oCCAction3:HyperLabel := HyperLabel{#Action3,_chr(38)+"Labels",NULL_STRING,NULL_STRING}

oCCAction4 := RadioButton{SELF,ResourceID{SELPERSMAILCD_ACTION4,_GetInst()}}
oCCAction4:HyperLabel := HyperLabel{#Action4,"Le"+_chr(38)+"tters",NULL_STRING,NULL_STRING}

oCCAction5 := RadioButton{SELF,ResourceID{SELPERSMAILCD_ACTION5,_GetInst()}}
oCCAction5:HyperLabel := HyperLabel{#Action5,_chr(38)+"Giro Accepts",NULL_STRING,NULL_STRING}

oCCAction6 := RadioButton{SELF,ResourceID{SELPERSMAILCD_ACTION6,_GetInst()}}
oCCAction6:HyperLabel := HyperLabel{#Action6,_chr(38)+"Spreadsheet file (Excel)",NULL_STRING,NULL_STRING}

oCCAction7 := RadioButton{SELF,ResourceID{SELPERSMAILCD_ACTION7,_GetInst()}}
oCCAction7:HyperLabel := HyperLabel{#Action7,"Change "+_chr(38)+"mailing codes",NULL_STRING,NULL_STRING}

oDCGroupBoxPersonal := GroupBox{SELF,ResourceID{SELPERSMAILCD_GROUPBOXPERSONAL,_GetInst()}}
oDCGroupBoxPersonal:HyperLabel := HyperLabel{#GroupBoxPersonal,"Personal:",NULL_STRING,NULL_STRING}

oDCsortorder := RadioButtonGroup{SELF,ResourceID{SELPERSMAILCD_SORTORDER,_GetInst()}}
oDCsortorder:FillUsing({ ;
							{oCCSortButton1,"postalcode"}, ;
							{oCCSortButton2,"lastname"} ;
							})
oDCsortorder:HyperLabel := HyperLabel{#sortorder,"Sort on:",NULL_STRING,NULL_STRING}

oDCOutputAction := RadioButtonGroup{SELF,ResourceID{SELPERSMAILCD_OUTPUTACTION,_GetInst()}}
oDCOutputAction:FillUsing({ ;
							{oCCAction1,"1"}, ;
							{oCCAction2,"2"}, ;
							{oCCAction3,"3"}, ;
							{oCCAction4,"4"}, ;
							{oCCAction5,"5"}, ;
							{oCCAction6,"6"}, ;
							{oCCAction7,"7"} ;
							})
oDCOutputAction:HyperLabel := HyperLabel{#OutputAction,"Required Output/Action:",NULL_STRING,NULL_STRING}

SELF:Caption := "Selection of people by person parameters"
SELF:HyperLabel := HyperLabel{#SelPersMailCd,"Selection of people by person parameters",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS SelPersMailCd
	LOCAL i,nSel as int
 	LOCAL oContr AS Control
 	LOCAL myCombo as Listbox 
 	local aPropExValues:={},aCurVal:={} as array 
 	local cDat,cName as string
	SELF:MakeAndCod()
	SELF:MakeOrCod()
	SELF:MakeNonCod()
	SELF:MakeOrType()
	SELF:MakeOrGender()
	FOR i:=1 to Len(self:aPropEx) step 1
		oContr:=self:aPropEx[i]
		aCurVal:={}
		IF ClassName(oContr)=#LISTBOX
			myCombo:=oContr
			IF myCombo:SelectedCount>0
				nSel:=myCombo:FirstSelected()
				do while nSel>0
					AAdd(aCurVal,AddSlashes(myCombo:GetItemValue(nSel)))
					nSel:=myCombo:NextSelected()
				enddo
				AAdd(aPropExValues,{myCombo:Name,DROPDOWN,aCurVal})
			ENDIF
		ELSEIF ClassName(oContr)= #CHECKBOX
			IF !IsNil(oContr:Value) .and. oContr:value=true
				AAdd(aPropExValues,{oContr:Name,CHECKBX,{iif(oContr:Value,'T','F')}})
			ENDIF
		ELSEIF ClassName(oContr)= #SINGLELINEEDIT
			IF !IsNil(oContr:VALUE)
				if oContr:picture='@D' .and.!empty(oContr:Value)
					cName:=oContr:Name
					if AtC("FROM",oContr:Name) >0
						AAdd(aPropExValues,{SubStr(cName,1,Len(cName)-4),DATEFIELD,{">='"+DToS(oContr:VALUE)+"'"}})
					else      // to
						AAdd(aPropExValues,{SubStr(cName,1,Len(cName)-2),DATEFIELD,{"<='"+DToS(oContr:VALUE)+"'"}})
					endif
				else 
					AAdd(aPropExValues,{oContr:Name,TEXTBX,Split(oContr:TextValue)})
				endif
			ENDIF
		ENDIF
	NEXT
// 	oCaller:aExtraProp:=aPropExValues
	self:ExtraPropCondition(aPropExValues)

	IF !Empty(oDCeerste:TEXTvalue)
		self:oCaller:cWherep := self:oCaller:cWherep+;
		IF(.not.Empty(self:oCaller:cWherep),' and ',"")+'p.postalcode>="';
		+StandardZip(oDCeerste:TEXTvalue)+'%"'
	ENDIF
	IF !Empty(oDClaatste:TEXTvalue)
		self:oCaller:cWherep := self:oCaller:cWherep+;
		iif(.not.Empty(self:oCaller:cWherep),' and ',"")+'p.postalcode<="';
		+StandardZip(oDClaatste:TEXTvalue)+'%"'
	ENDIF
	cDat:=GetDateFormat()
	SetDateFormat("YYYY-MM-DD")
	IF !empty(oDCDLG_Start:Value)
		self:oCaller:cWherep := self:oCaller:cWherep+;
		IF(.not.Empty(self:oCaller:cWherep),' and ',"")+'p.datelastgift>="'+DToC(self:oDCDLG_Start:VALUE)+'"'
	ENDIF
	IF !Empty(oDCDLG_End:VALUE)
		self:oCaller:cWherep := self:oCaller:cWherep+;
		IF(.not.Empty(self:oCaller:cWherep),' and ',"")+'p.datelastgift<="'+DToC(oDCDLG_End:VALUE)+'"'
		IF empty(oDCDLG_Start:Value)
			self:oCaller:cWherep := self:oCaller:cWherep+' and p.datelastgift>"0000-00-00"'
		ENDIF
	ENDIF
// 	IF !oDCBdat_Start:TextValue==DToC(NULL_DATE)
	IF !Empty(self:oDCBdat_Start:VALUE)
		self:oCaller:cWherep := self:oCaller:cWherep+;
		iif(!Empty(self:oCaller:cWherep),' and ',"")+'p.creationdate>="'+DToC(self:oDCBdat_Start:VALUE)+'"'
	ENDIF
	IF !Empty(oDCBdat_End:VALUE)
		self:oCaller:cWherep := self:oCaller:cWherep+;
		IF(.not.Empty(self:oCaller:cWherep),' and ',"")+'p.creationdate<="'+DToC(self:oDCBdat_End:VALUE)+'"'
		IF empty(oDCBdat_Start:Value)
			self:oCaller:cWherep := self:oCaller:cWherep+' and p.creationdate>"0000-00-00"'
		ENDIF
	ENDIF
	IF !empty(oDCMutd_Start:Value)
		self:oCaller:cWherep := self:oCaller:cWherep+;
		IF(.not.Empty(self:oCaller:cWherep),' and ',"")+'p.alterdate>="'+DToC(oDCMutd_Start:VALUE)+'"'
	ENDIF
	IF !Empty(oDCMutd_End:VALUE)
		self:oCaller:cWherep := self:oCaller:cWherep+;
		IF(.not.Empty(self:oCaller:cWherep),' and ',"")+'p.alterdate<="'+DToC(oDCMutd_End:VALUE)+'"'
		IF empty(oDCMutd_Start:Value)
			self:oCaller:cWherep := self:oCaller:cWherep+' and p.creationdate>"0000-00-00"'
		ENDIF
	ENDIF
	SetDateFormat(cDat)
	IF !Empty(oDCeerste:TEXTvalue).or.!Empty(oDClaatste:TEXTvalue)
		self:oCaller:selx_voorw := self:oCaller:selx_voorw + ;
		IF(.not.Empty(self:oCaller:selx_voorw),' and ',"")+'Zip code between '+;
		+AllTrim(oDCeerste:TEXTvalue)+' & '+ AllTrim(oDClaatste:TEXTValue)
	ENDIF
	IF !oDCDLG_Start:TextValue==DToC(NULL_DATE).or.!oDCDLG_End:TextValue==DToC(NULL_DATE)
		self:oCaller:selx_voorw := self:oCaller:selx_voorw + ;
		IF(.not.Empty(self:oCaller:selx_voorw),' and ',"")+'Last Gift between '+;
		+AllTrim(oDCDLG_Start:TEXTvalue)+' & '+ AllTrim(oDCDLG_End:TEXTValue)
	ENDIF
	IF !oDCMutd_Start:TextValue==DToC(NULL_DATE).or.!oDCMutd_End:TextValue==DToC(NULL_DATE)
		self:oCaller:selx_voorw := self:oCaller:selx_voorw + ;
		IF(.not.Empty(self:oCaller:selx_voorw),' and ',"")+'Last Altered between '+;
		+AllTrim(oDCMutd_Start:TEXTvalue)+' and '+ AllTrim(oDCMutd_End:TEXTValue)
	ENDIF
	IF !oDCBdat_Start:TextValue==DToC(NULL_DATE).or.!oDCBdat_End:TextValue==DToC(NULL_DATE)
		self:oCaller:selx_voorw := self:oCaller:selx_voorw + ;
		IF(.not.Empty(self:oCaller:selx_voorw),' and ',"")+'Created between '+;
		+AllTrim(oDCBdat_Start:TEXTvalue)+' and '+ AllTrim(oDCBdat_End:TEXTValue)
	ENDIF
// 	IF oDCReport1:Checked .or.oDCReport2:Checked.or.oDCReport3:Checked;
// 	.or.oDCReport4:Checked.or.oDCReport5:Checked.or.oDCReport6:Checked.or.oDCReport7:Checked
// 		self:oCaller:RepCompact := oDCReport1:Checked
// 		self:oCaller:RepExt := oDCReport2:Checked
// 		self:oCaller:RepLabel := oDCReport3:Checked
// 		self:oCaller:RepLetter := oDCReport4:Checked
// 		self:oCaller:RepGiro := oDCReport5:Checked
// 		self:oCaller:RepExport := oDCReport6:Checked
// 		self:oCaller:RepMailcds := oDCReport7:Checked
	if !Empty(self:oDCOutputAction:VALUE)
// 		self:self:oCaller:ReportAction:= Val(self:oDCOutputAction:TEXTvalue)
		self:oCaller:ReportAction:= Val(self:oDCOutputAction:VALUE)
	ELSE
		(WarningBox{self,'Selecting Persons','Specify at least one report type!'}):Show() 
		self:oCCAction1:SetFocus()
// 		oDCReport1:SetFocus()
		RETURN NIL
	ENDIF
	self:oCaller:SortOrder := oDCSortOrder:Value 
	self:oCaller:selx_OK := true

	SELF:EndDialog()
	
	RETURN NIL
METHOD PostInit(oParent,uExtra) CLASS SelPersMailCd
	//Put your PostInit additions here
	LOCAL rjaar := Year(Today()) as int
	LOCAL rmnd := Month(Today()) as int
self:SetTexts()
	oDCeerste:Value := ""
	oDClaatste:Value := ""
	oCCSortButton1:Value := true
	oDCsortorder:Value := "postalcode"
	IF !IsNil(uExtra)
		IF IsArray(uExtra)
			oCaller:=uExtra[1]
			cType:=uExtra[2]
			if Len(uExtra)>2
				self:Caption:=uExtra[3]
			endif
		ELSE
			oCaller:=uExtra
		ENDIF
	ENDIF
	IF cType=="FIRSTGIVERS"
		oDCAndCod:SelectItem(AScan(self:oDCAndCod:GetRetValues(),"EG"))
// 		oDCReport4:Checked:=TRUE
		self:oDCOutputAction:Value:="4"
	ELSEIF cType=="FIRSTNONEAR"
		oDCAndCod:SelectItem(AScan(self:oDCAndCod:GetRetValues(),"EO"))
		*oDCandCod1:Value:="EO"
// 		oDCReport4:Checked:=TRUE
		self:oDCOutputAction:Value:="4"
	ELSEIF cType=="THANKYOU"
// 		oDCReport4:Checked:=TRUE
		self:oDCOutputAction:Value:="6"
	ELSEIF cType=="CHANGEMAILINGCODE"
// 		oDCReport7:Checked:=TRUE
		self:oDCOutputAction:Value:="7"
	ELSEIF cType=="REMINDERS".or.cType=="DONATIONS".or.cType=="SUBSCRIPTIONS"
// 		oDCReport5:Checked:=TRUE
		self:oDCOutputAction:Value:="5"
	else
		self:oDCOutputAction:Value:='6'
	ENDIF
// 	IF oCaller:selx_keus1 > 1
// 		* Maak sorteervraag onzichtbaar (altijd op postkode)
// 		oDCSortorder:Hide()
// 		oCCSortButton1:Hide()		
// 		oCCSortButton2:Hide()		
// 	ENDIF
	oCaller:selx_OK := FALSE   // in case of close window by user: false: only OK when pressing OK

   self:InitExtraProperties()
	RETURN nil
STATIC DEFINE SELPERSMAILCD_ACTION1 := 137 
STATIC DEFINE SELPERSMAILCD_ACTION2 := 138 
STATIC DEFINE SELPERSMAILCD_ACTION3 := 139 
STATIC DEFINE SELPERSMAILCD_ACTION4 := 140 
STATIC DEFINE SELPERSMAILCD_ACTION5 := 141 
STATIC DEFINE SELPERSMAILCD_ACTION6 := 142 
STATIC DEFINE SELPERSMAILCD_ACTION7 := 143 
STATIC DEFINE SELPERSMAILCD_ANDCOD := 128 
STATIC DEFINE SELPERSMAILCD_BDAT_END := 103 
STATIC DEFINE SELPERSMAILCD_BDAT_START := 102 
STATIC DEFINE SELPERSMAILCD_CANCELBUTTON := 124 
STATIC DEFINE SELPERSMAILCD_DLG_END := 101 
STATIC DEFINE SELPERSMAILCD_DLG_START := 100 
STATIC DEFINE SELPERSMAILCD_EERSTE := 106 
STATIC DEFINE SELPERSMAILCD_FIXEDTEXT1 := 111 
STATIC DEFINE SELPERSMAILCD_FIXEDTEXT2 := 112 
STATIC DEFINE SELPERSMAILCD_FIXEDTEXT3 := 117 
STATIC DEFINE SELPERSMAILCD_FIXEDTEXT4 := 118 
STATIC DEFINE SELPERSMAILCD_FIXEDTEXT5 := 121 
STATIC DEFINE SELPERSMAILCD_FIXEDTEXT6 := 122 
STATIC DEFINE SELPERSMAILCD_FIXEDTEXT7 := 126 
STATIC DEFINE SELPERSMAILCD_FIXEDTEXT8 := 127 
STATIC DEFINE SELPERSMAILCD_FIXEDTEXT9 := 131 
STATIC DEFINE SELPERSMAILCD_GENDERS := 135 
STATIC DEFINE SELPERSMAILCD_GROUPBOX1 := 116 
STATIC DEFINE SELPERSMAILCD_GROUPBOX10 := 134 
STATIC DEFINE SELPERSMAILCD_GROUPBOX2 := 119 
STATIC DEFINE SELPERSMAILCD_GROUPBOX3 := 115 
STATIC DEFINE SELPERSMAILCD_GROUPBOX4 := 114 
STATIC DEFINE SELPERSMAILCD_GROUPBOX6 := 113 
STATIC DEFINE SELPERSMAILCD_GROUPBOX7 := 120 
STATIC DEFINE SELPERSMAILCD_GROUPBOX8 := 125 
STATIC DEFINE SELPERSMAILCD_GROUPBOX9 := 133 
STATIC DEFINE SELPERSMAILCD_GROUPBOXPERSONAL := 144 
STATIC DEFINE SELPERSMAILCD_LAATSTE := 107 
STATIC DEFINE SELPERSMAILCD_MUTD_END := 105 
STATIC DEFINE SELPERSMAILCD_MUTD_START := 104 
STATIC DEFINE SELPERSMAILCD_NONCOD := 130 
STATIC DEFINE SELPERSMAILCD_OKBUTTON := 123 
STATIC DEFINE SELPERSMAILCD_ORCOD := 129 
STATIC DEFINE SELPERSMAILCD_OUTPUTACTION := 136 
STATIC DEFINE SELPERSMAILCD_SORTBUTTON1 := 109 
STATIC DEFINE SELPERSMAILCD_SORTBUTTON2 := 110 
STATIC DEFINE SELPERSMAILCD_SORTORDER := 108 
STATIC DEFINE SELPERSMAILCD_TYPES := 132 
CLASS SelPersOpen INHERIT DialogWinDowExtra 

	PROTECT oDCkeus21 AS RADIOBUTTONGROUP
	PROTECT oDCbegin_verv AS DATESTANDARD
	PROTECT oDCeind_verv AS DATESTANDARD
	PROTECT oCCSelOpenButton2 AS RADIOBUTTON
	PROTECT oDCSelx_rek AS COMBOBOX
	PROTECT oCCSelOpenButton1 AS RADIOBUTTON
	PROTECT oCCSelOpenButton3 AS RADIOBUTTON
	PROTECT oDCmPayMethod AS RADIOBUTTONGROUP
	PROTECT oCCRadioButtonGiro AS RADIOBUTTON
	PROTECT oCCRadioButtonCollection AS RADIOBUTTON
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCAccountText AS FIXEDTEXT
	PROTECT oDCdatedirectdebit AS WORKDAYDATE
	PROTECT oDCDateDirectText AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  PROTECT oCaller AS SelPers
  PROTECT cType as STRING 
  declare method Abon_Con,MakeCliop03File
RESOURCE SelPersOpen DIALOGEX  24, 38, 266, 187
STYLE	DS_3DLOOK|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Select Persons with Unpaid Items"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Wich type", SELPERSOPEN_KEUS21, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 7, 56, 253, 68
	CONTROL	"maandag 15 november 2010", SELPERSOPEN_BEGIN_VERV, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 84, 16, 118, 14
	CONTROL	"maandag 15 november 2010", SELPERSOPEN_EIND_VERV, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 84, 32, 118, 14
	CONTROL	"subscriptions", SELPERSOPEN_SELOPENBUTTON2, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 15, 70, 59, 11
	CONTROL	"", SELPERSOPEN_SELX_REK, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_VSCROLL, 136, 62, 119, 109
	CONTROL	"donors", SELPERSOPEN_SELOPENBUTTON1, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 16, 88, 51, 11
	CONTROL	"invoices", SELPERSOPEN_SELOPENBUTTON3, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 16, 105, 54, 11
	CONTROL	"Payment Method", SELPERSOPEN_MPAYMETHOD, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|NOT WS_VISIBLE, 7, 125, 105, 38
	CONTROL	"Giro Accept Forms", SELPERSOPEN_RADIOBUTTONGIRO, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 16, 134, 82, 11
	CONTROL	"Direct Debit", SELPERSOPEN_RADIOBUTTONCOLLECTION, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 16, 147, 92, 11
	CONTROL	"Up to and including:", SELPERSOPEN_FIXEDTEXT2, "Static", WS_CHILD, 16, 34, 70, 12
	CONTROL	"From:", SELPERSOPEN_FIXEDTEXT1, "Static", WS_CHILD, 16, 17, 50, 12
	CONTROL	"Date of invoice of Due Amount is :", SELPERSOPEN_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 6, 204, 46
	CONTROL	"OK", SELPERSOPEN_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 191, 152, 53, 12
	CONTROL	"Cancel", SELPERSOPEN_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 191, 132, 53, 12
	CONTROL	"Account:", SELPERSOPEN_ACCOUNTTEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 80, 66, 33, 12
	CONTROL	"maandag 15 november 2010", SELPERSOPEN_DATEDIRECTDEBIT, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 136, 88, 119, 14
	CONTROL	"Date direct debit:", SELPERSOPEN_DATEDIRECTTEXT, "Static", WS_CHILD|NOT WS_VISIBLE, 80, 88, 56, 12
END

METHOD ButtonClick(oControlEvent) CLASS SelPersOpen
	LOCAL oControl AS Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:NameSym==#SelOpenButton2 .or.oControl:NameSym==#SelOpenButton1 .or.oControl:NameSym==#SelOpenButton3
		IF oDCkeus21:Value=="2"
			oDCSelx_rek:Show()
		ELSE
			oDCSelx_rek:Hide()
		ENDIF
	elseif oControl:NameSym==#RadioButtonGiro
		self:oDCdatedirectdebit:Hide()
		self:oDCDateDirectText:Hide()
	elseif oControl:NameSym==#RadioButtonCollection		
		self:oDCdatedirectdebit:Show()
		self:oDCDateDirectText:Show()
/*	elseif oControl:NameSym==#DateDirectDebit		
		if DoW(self:oDCdatedirectdebit:SelectedDate)=1       // not on sunday
			self:oDCdatedirectdebit:SelectedDate++
		elseif DoW(self:oDCdatedirectdebit:SelectedDate)=7   // not on saturday
			self:oDCdatedirectdebit:SelectedDate+=2
		endif		*/
	ENDIF
	RETURN nil 
METHOD CancelButton( ) CLASS SelPersOpen
	SELF:EndDialog()
	oCaller:selx_OK := FALSE
	RETURN SELF
METHOD Close(oEvent) CLASS SelPersOpen
	SUPER:Close(oEvent)
	//Put your changes here
	SELF:Destroy()
	RETURN NIL
METHOD Init(oParent,uExtra) CLASS SelPersOpen 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"SelPersOpen",_GetInst()},FALSE)

oDCbegin_verv := DateStandard{SELF,ResourceID{SELPERSOPEN_BEGIN_VERV,_GetInst()}}
oDCbegin_verv:FieldSpec := Transaction_DAT{}
oDCbegin_verv:HyperLabel := HyperLabel{#begin_verv,NULL_STRING,NULL_STRING,NULL_STRING}

oDCeind_verv := DateStandard{SELF,ResourceID{SELPERSOPEN_EIND_VERV,_GetInst()}}
oDCeind_verv:FieldSpec := Transaction_DAT{}
oDCeind_verv:HyperLabel := HyperLabel{#eind_verv,NULL_STRING,NULL_STRING,NULL_STRING}

oCCSelOpenButton2 := RadioButton{SELF,ResourceID{SELPERSOPEN_SELOPENBUTTON2,_GetInst()}}
oCCSelOpenButton2:HyperLabel := HyperLabel{#SelOpenButton2,"subscriptions",NULL_STRING,NULL_STRING}

oDCSelx_rek := combobox{SELF,ResourceID{SELPERSOPEN_SELX_REK,_GetInst()}}
oDCSelx_rek:FillUsing(Self:abon_con( ))
oDCSelx_rek:HyperLabel := HyperLabel{#Selx_rek,NULL_STRING,NULL_STRING,NULL_STRING}

oCCSelOpenButton1 := RadioButton{SELF,ResourceID{SELPERSOPEN_SELOPENBUTTON1,_GetInst()}}
oCCSelOpenButton1:HyperLabel := HyperLabel{#SelOpenButton1,"donors",NULL_STRING,NULL_STRING}

oCCSelOpenButton3 := RadioButton{SELF,ResourceID{SELPERSOPEN_SELOPENBUTTON3,_GetInst()}}
oCCSelOpenButton3:HyperLabel := HyperLabel{#SelOpenButton3,"invoices",NULL_STRING,NULL_STRING}

oCCRadioButtonGiro := RadioButton{SELF,ResourceID{SELPERSOPEN_RADIOBUTTONGIRO,_GetInst()}}
oCCRadioButtonGiro:HyperLabel := HyperLabel{#RadioButtonGiro,"Giro Accept Forms",NULL_STRING,NULL_STRING}

oCCRadioButtonCollection := RadioButton{SELF,ResourceID{SELPERSOPEN_RADIOBUTTONCOLLECTION,_GetInst()}}
oCCRadioButtonCollection:HyperLabel := HyperLabel{#RadioButtonCollection,"Direct Debit",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{SELPERSOPEN_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Up to and including:",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{SELPERSOPEN_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"From:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{SELPERSOPEN_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Date of invoice of Due Amount is :",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{SELPERSOPEN_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{SELPERSOPEN_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCAccountText := FixedText{SELF,ResourceID{SELPERSOPEN_ACCOUNTTEXT,_GetInst()}}
oDCAccountText:HyperLabel := HyperLabel{#AccountText,"Account:",NULL_STRING,NULL_STRING}

oDCdatedirectdebit := WorkDayDate{SELF,ResourceID{SELPERSOPEN_DATEDIRECTDEBIT,_GetInst()}}
oDCdatedirectdebit:FieldSpec := Transaction_DAT{}
oDCdatedirectdebit:HyperLabel := HyperLabel{#datedirectdebit,NULL_STRING,"Date for processing direct debit requests at the bank",NULL_STRING}
oDCdatedirectdebit:UseHLforToolTip := True

oDCDateDirectText := FixedText{SELF,ResourceID{SELPERSOPEN_DATEDIRECTTEXT,_GetInst()}}
oDCDateDirectText:HyperLabel := HyperLabel{#DateDirectText,"Date direct debit:",NULL_STRING,NULL_STRING}

oDCkeus21 := RadioButtonGroup{SELF,ResourceID{SELPERSOPEN_KEUS21,_GetInst()}}
oDCkeus21:FillUsing({ ;
						{oCCSelOpenButton2,"2"}, ;
						{oCCSelOpenButton1,"1"}, ;
						{oCCSelOpenButton3,"3"} ;
						})
oDCkeus21:HyperLabel := HyperLabel{#keus21,"Wich type",NULL_STRING,NULL_STRING}

oDCmPayMethod := RadioButtonGroup{SELF,ResourceID{SELPERSOPEN_MPAYMETHOD,_GetInst()}}
oDCmPayMethod:FillUsing({ ;
							{oCCRadioButtonGiro,"G"}, ;
							{oCCRadioButtonCollection,"C"} ;
							})
oDCmPayMethod:HyperLabel := HyperLabel{#mPayMethod,"Payment Method",NULL_STRING,NULL_STRING}

SELF:Caption := "Select Persons with Unpaid Items"
SELF:HyperLabel := HyperLabel{#SelPersOpen,"Select Persons with Unpaid Items",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS SelPersOpen
	LOCAL keuze := Val(self:oDCkeus21:VALUE)
	LOCAL oAcc as SQLselect
	LOCAL begin_due:=oDCbegin_verv:SelectedDate, end_due:=oDCeind_verv:SelectedDate, process_date:=self:oDCdatedirectdebit:SelectedDate as date
	self:oCaller:cWhereOther := ;
	"and d.invoicedate>='"+Transform(DToS(begin_due),"9999-99-99")+;
	"' and invoicedate<='"+Transform(DToS(end_due),"9999-99-99")+;
	"' and amountrecvd<amountinvoice"+;
	" and s.paymethod='"+AllTrim(self:oDCmPayMethod:VALUE)+"'"
	IF self:keus21=1
		self:oCaller:cWhereOther+='and s.category="D"'
	ELSEIF self:keus21=2
		self:oCaller:cWhereOther+='and s.category="A"'
	ENDIF		
	self:oCaller:selx_voorw := ' and invoicedate between '+;
	DToC(oDCbegin_verv:VALUE)+' and '+DToC(oDCeind_verv:VALUE)
	self:oCaller:selx_rek := if(IsNil(self:oDCselx_rek:VALUE),null_string,Str(self:oDCselx_rek:VALUE,-1))
	//CountryCode:="47"
	IF keuze ==2           && abonnementen
*		(SelPersAbon{self}):Show()
		keuze:=keuze
	ELSEIF keuze == 1    && donateurs
		IF self:oDCmPayMethod:Value="C" // automatic collection?
			//self:oCaller:selx_rek:=NULL_STRING
			self:oCaller:Selx_OK:=FALSE // do not continue with caller 
			if CountryCode="47"
				self:MakeKIDFile(begin_due,end_due,process_date)
			elseif CountryCode="31"
				if !self:MakeCliop03File(begin_due,end_due,process_date,if(IsNil(self:oDCselx_rek:VALUE),0,self:oDCselx_rek:VALUE))
					return
				endif
			endif
			self:EndDialog() 
			RETURN nil
		ENDIF			
	ELSE                  && fakturen
		self:oCaller:selx_rek := SDEB
	ENDIF
	*DueAmount:
	self:oCaller:cWhereOther := 's.accid="'+self:oCaller:selx_rek+" and s.subscribid=t.subscribid "+self:oCaller:cWhereOther

	oAcc:=SQLSelect{"select accnumber from account where accid='"+self:oCaller:selx_rek+"'",oConn}
	if oAcc:RecCount>0
		self:oCaller:selx_voorw := 'accountnbr' + '=' +oAcc:ACCNUMBER+self:oCaller:selx_voorw
	endif
	self:oCaller:Selx_OK:=true
	self:EndDialog() 
  	RETURN nil
METHOD PostInit(oWindow,uExtra) CLASS SelPersOpen
	//Put your PostInit additions here
	LOCAL rjaar := Year(Today()) AS INT
	LOCAL rmnd := Month(Today()) as int 
	self:SetTexts()
   if CountryCode=="47"
   	self:oCCRadioButtonCollection:Caption+="("+self:oLan:WGet("KID file")+")"
   endif
	oDCeind_verv:SelectedDate := SToD(Str(rjaar,4)+StrZero(rmnd,2)+Str(MonthEnd(rmnd,rjaar),2)) 
	rmnd--
	if rmnd<1
		rjaar--
		rmnd:=12
	endif
	oDCbegin_verv:SelectedDate := SToD(Str(rjaar,4)+StrZero(rmnd,2)+'01')

	self:oDCdatedirectdebit:SelectedDate:=Today()+1
	if DoW(self:oDCdatedirectdebit:SelectedDate)=1       // not on sunday
		self:oDCdatedirectdebit:SelectedDate++
	elseif DoW(self:oDCdatedirectdebit:SelectedDate)=7   // not on saturday
		self:oDCdatedirectdebit:SelectedDate+=2
	endif
	IF Empty(cType)
		oDCkeus21:Value := "1"
	ELSEIF cType=="DONATIONS"
		oDCkeus21:Value := "1"
		oDCkeus21:Hide()
		oCCSelOpenButton1:Hide()
		oCCSelOpenButton2:Hide()
		oCCSelOpenButton2:Hide()
		oDCmPayMethod:Show()
		oDCSelx_rek:Show()
		SELF:oDCAccountText:Show()
		oCCRadioButtonGiro:Show()
		oCCRadioButtonCollection:Show()
		oDCmPayMethod:Value:="C"
		self:oDCdatedirectdebit:Show() 
		self:oDCDateDirectText:Show()
		self:Caption:=self:oLan:WGet("Select Persons for Payment Requests Donation Prolongations")
	ELSEIF cType=="SUBSCRIPTIONS"
	oDCkeus21:Value := "2"
		oCCSelOpenButton1:Hide()
		oCCSelOpenButton2:Hide()
		oCCSelOpenButton3:Hide()
		oDCmPayMethod:Show()
		oCCRadioButtonGiro:Show()
		oCCRadioButtonCollection:Show()
		oDCmPayMethod:Value:="C"
		oDCSelx_rek:Show()
		SELF:oDCAccountText:Show()
		self:Caption:=self:oLan:WGet("Select Persons for Invoicing Subscription Prolongations")
	ELSEIF cType=="REMINDERS"
		oCCSelOpenButton1:Hide()
		oDCkeus21:Value := "3"
		rjaar := Year(Today()-60)
		rmnd := Month(Today()-60)
		self:Caption:=self:oLan:WGet("Select Persons for Reminding")
	ENDIF
	self:oDCSelx_rek:CurrentItemNo:=1  
	oCaller:selx_OK := FALSE

	RETURN SELF
METHOD PreInit(oParent,uExtra) CLASS SelPersOpen
	//Put your PreInit additions here
	IF !IsNil(uExtra)
		IF IsArray(uExtra)
			oCaller:=uExtra[1]
			cType:=uExtra[2]
		ELSE
			oCaller:=uExtra
		ENDIF
	ENDIF

	RETURN NIL
STATIC DEFINE SELPERSOPEN_ACCOUNTTEXT := 115 
STATIC DEFINE SELPERSOPEN_BEGIN_VERV := 101 
STATIC DEFINE SELPERSOPEN_CANCELBUTTON := 114 
STATIC DEFINE SELPERSOPEN_DATEDIRECTDEBIT := 116 
STATIC DEFINE SELPERSOPEN_DATEDIRECTTEXT := 117 
STATIC DEFINE SELPERSOPEN_EIND_VERV := 102 
STATIC DEFINE SELPERSOPEN_FIXEDTEXT1 := 111 
STATIC DEFINE SELPERSOPEN_FIXEDTEXT2 := 110 
STATIC DEFINE SELPERSOPEN_GROUPBOX1 := 112 
STATIC DEFINE SELPERSOPEN_KEUS21 := 100 
STATIC DEFINE SELPERSOPEN_MPAYMETHOD := 107 
STATIC DEFINE SELPERSOPEN_OKBUTTON := 113 
STATIC DEFINE SELPERSOPEN_RADIOBUTTONCOLLECTION := 109 
STATIC DEFINE SELPERSOPEN_RADIOBUTTONGIRO := 108 
STATIC DEFINE SELPERSOPEN_SELOPENBUTTON1 := 105 
STATIC DEFINE SELPERSOPEN_SELOPENBUTTON2 := 103 
STATIC DEFINE SELPERSOPEN_SELOPENBUTTON3 := 106 
STATIC DEFINE SELPERSOPEN_SELX_REK := 104 
RESOURCE SelPersPayments DIALOGEX  10, 9, 408, 232
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"From:", SELPERSPAYMENTS_FIXEDTEXT1, "Static", WS_CHILD, 8, 51, 20, 12
	CONTROL	"To:", SELPERSPAYMENTS_FIXEDTEXT2, "Static", WS_CHILD, 130, 51, 10, 12
	CONTROL	"Between:", SELPERSPAYMENTS_FIXEDTEXT3, "Static", WS_CHILD, 7, 118, 33, 10
	CONTROL	"and:", SELPERSPAYMENTS_FIXEDTEXT4, "Static", WS_CHILD, 128, 118, 15, 10
	CONTROL	"", SELPERSPAYMENTS_SELX_REK, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 8, 62, 100, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", SELPERSPAYMENTS_ACCBEGINBUTTON, "Button", WS_CHILD, 107, 62, 15, 13
	CONTROL	"", SELPERSPAYMENTS_SELX_REKEND, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 128, 62, 100, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", SELPERSPAYMENTS_ACCENDBUTTON, "Button", WS_CHILD, 227, 62, 15, 13
	CONTROL	"", SELPERSPAYMENTS_SUBSET, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 260, 19, 134, 195, WS_EX_CLIENTEDGE
	CONTROL	"Range of destinations:", SELPERSPAYMENTS_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|WS_CLIPSIBLINGS, 4, 2, 394, 89
	CONTROL	"Payment date", SELPERSPAYMENTS_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 2, 110, 251, 42
	CONTROL	"dinsdag 1 februari 2011", SELPERSPAYMENTS_SELX_BEGIN, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 8, 129, 118, 13
	CONTROL	"dinsdag 1 februari 2011", SELPERSPAYMENTS_SELX_END, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 129, 129, 118, 13
	CONTROL	"", SELPERSPAYMENTS_MINTOTAL, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 7, 178, 118, 12, WS_EX_CLIENTEDGE
	CONTROL	"", SELPERSPAYMENTS_MAXTOTAL, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 130, 178, 118, 12, WS_EX_CLIENTEDGE
	CONTROL	"Ok", SELPERSPAYMENTS_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 333, 217, 53, 13
	CONTROL	"Cancel", SELPERSPAYMENTS_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 272, 217, 53, 13
	CONTROL	"Total amount within period of person ", SELPERSPAYMENTS_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 2, 157, 251, 38
	CONTROL	"Between:", SELPERSPAYMENTS_FIXEDTEXT5, "Static", WS_CHILD, 7, 168, 28, 10
	CONTROL	"and:", SELPERSPAYMENTS_FIXEDTEXT6, "Static", WS_CHILD, 130, 166, 15, 12
	CONTROL	"Subset:", SELPERSPAYMENTS_FIXEDTEXT7, "Static", WS_CHILD|NOT WS_VISIBLE, 261, 9, 53, 9
	CONTROL	"Members not of", SELPERSPAYMENTS_NONHOMEBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 8, 35, 216, 11
	CONTROL	"Members of", SELPERSPAYMENTS_HOMEBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 8, 24, 211, 11
	CONTROL	"Projects", SELPERSPAYMENTS_PROJECTSBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 8, 13, 80, 11
	CONTROL	"Fixed Text", SELPERSPAYMENTS_TEXTTILL, "Static", WS_CHILD, 130, 75, 112, 12
	CONTROL	"Fixed Text", SELPERSPAYMENTS_TEXTFROM, "Static", WS_CHILD, 8, 75, 111, 12
	CONTROL	"", SELPERSPAYMENTS_MINAMOUNT, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 130, 199, 118, 12, WS_EX_CLIENTEDGE
	CONTROL	"Minimal individual amount:", SELPERSPAYMENTS_FIXEDTEXT9, "Static", WS_CHILD, 8, 199, 107, 12
END

CLASS SelPersPayments INHERIT DataDialogMine 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCselx_rek AS SINGLELINEEDIT
	PROTECT oCCAccBeginButton AS PUSHBUTTON
	PROTECT oDCselx_rekend AS SINGLELINEEDIT
	PROTECT oCCAccEndButton AS PUSHBUTTON
	PROTECT oDCSubSet AS LISTBOXEXTRA
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCselx_begin AS DATETIMEPICKER
	PROTECT oDCselx_end AS DATETIMEPICKER
	PROTECT oDCMinTotal AS SINGLELINEEDIT
	PROTECT oDCMaxTotal AS SINGLELINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCGroupBox3 AS GROUPBOX
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCNonHomeBox AS CHECKBOX
	PROTECT oDCHomeBox AS CHECKBOX
	PROTECT oDCProjectsBox AS CHECKBOX
	PROTECT oDCTextTill AS FIXEDTEXT
	PROTECT oDCTextfrom AS FIXEDTEXT
	PROTECT oDCMinAmount AS SINGLELINEEDIT
	PROTECT oDCFixedText9 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
    PROTECT cAccountBeginName,cAccountEndName AS STRING
	PROTECT mRekSt,mRekId AS STRING
	PROTECT mRekEnd AS STRING
// 	PROTECT oAcc AS Account
	PROTECT oCaller, MyParent as OBJECT 
	export cFilter:="" as STRING
  
	
	declare method RegAccount
METHOD AccBeginButton(lUnique ) CLASS SelPersPayments
LOCAL lHome:=self:HomeBox,lNonHome:=self:NonHomeBox,lProjects:=self:ProjectsBox as LOGIC
local cFilter:="GitfAlwd=1"
	Default(@lUnique,FALSE)

	AccountSelect(self,AllTrim(oDCselx_rek:TEXTValue ),"Account From",lUnique,"GiftAlwd",oCaller:Owner)
METHOD AccEndButton(lUnique ) CLASS SelPersPayments
local lRes as logic
	Default(@lUnique,FALSE)
	lRes:=AccountSelect(self,AllTrim(oDCselx_rekend:TEXTValue ),"Account To",lUnique,"GiftAlwd",oCaller:Owner)
METHOD AccFil() CLASS SelPersPayments
	LOCAL i AS INT
	LOCAL SubLen AS INT
	SELF:selx_rek:="0"
	SELF:selx_rekend:="zzzzzzzzz"
	self:oDCSubSet:FillUsing(self:oDCSubSet:GetAccounts(""))
	* Select all:
	SubLen:=SELF:oDCSubSet:ItemCount
	FOR i = 1 TO SubLen
    	SELF:oDCSubSet:SelectItem(i)
	NEXT
	SELF:selx_rek:= LTrimZero(SELF:oDCSubSet:GetItem(1,LENACCNBR))
	self:oDCselx_rek:TEXTValue := self:selx_rek
	self:cAccountBeginName := self:selx_rek
	SELF:oDCTextfrom:caption := AllTrim(SubStr(SELF:oDCSubSet:GetItem(1),LENACCNBR+1))
	SELF:selx_rekend:= LTrimZero(SELF:oDCSubSet:GetItem(SubLen,LENACCNBR))
	self:oDCselx_rekend:TEXTValue := self:selx_rekend
	self:cAccountEndName := self:selx_rekend
	SELF:oDCTextTill:caption := AllTrim(SubStr(SELF:oDCSubSet:GetItem(SubLen),LENACCNBR+1))
RETURN
METHOD ButtonClick(oControlEvent) CLASS SelPersPayments
	LOCAL oControl AS Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:NameSym=#HomeBox .or. oControl:NameSym=#NonHomeBox .or. oControl:NameSym=#ProjectsBox
		SELF:AccFil()
    ENDIF
	RETURN NIL
METHOD CancelButton( ) CLASS SelPersPayments
	SELF:EndWindow()
	RETURN
METHOD Close(oEvent) CLASS SelPersPayments
	SUPER:Close(oEvent)
	//Put your changes here
SELF:Destroy()
RETURN NIL
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS SelPersPayments
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus.and.!IsNil(oControl:Value)
		IF oControl:Name == "SELX_REK".and.!AllTrim(oControl:Value)==AllTrim(cAccountBeginName)
			cAccountBeginName:=AllTrim(oControl:Value)
			SELF:AccBeginButton(TRUE)
		ELSEIF oControl:Name == "SELX_REKEND".and.!AllTrim(oControl:Value)==AllTrim(cAccountEndName)
			cAccountEndName:=AllTrim(oControl:Value)
			SELF:AccEndButton(TRUE)
		ENDIF
	ENDIF

	RETURN NIL
ACCESS HomeBox() CLASS SelPersPayments
RETURN SELF:FieldGet(#HomeBox)

ASSIGN HomeBox(uValue) CLASS SelPersPayments
SELF:FieldPut(#HomeBox, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS SelPersPayments 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"SelPersPayments",_GetInst()},iCtlID)

oDCFixedText1 := FixedText{SELF,ResourceID{SELPERSPAYMENTS_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"From:",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{SELPERSPAYMENTS_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"To:",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{SELPERSPAYMENTS_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Between:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{SELPERSPAYMENTS_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"and:",NULL_STRING,NULL_STRING}

oDCselx_rek := SingleLineEdit{SELF,ResourceID{SELPERSPAYMENTS_SELX_REK,_GetInst()}}
oDCselx_rek:HyperLabel := HyperLabel{#selx_rek,NULL_STRING,"Number of account member/fund",NULL_STRING}
oDCselx_rek:FocusSelect := FSEL_HOME
oDCselx_rek:OverWrite := OVERWRITE_ALWAYS
oDCselx_rek:FieldSpec := memberaccount{}

oCCAccBeginButton := PushButton{SELF,ResourceID{SELPERSPAYMENTS_ACCBEGINBUTTON,_GetInst()}}
oCCAccBeginButton:HyperLabel := HyperLabel{#AccBeginButton,"v","Browse in accounts",NULL_STRING}
oCCAccBeginButton:TooltipText := "Browse in accounts"

oDCselx_rekend := SingleLineEdit{SELF,ResourceID{SELPERSPAYMENTS_SELX_REKEND,_GetInst()}}
oDCselx_rekend:HyperLabel := HyperLabel{#selx_rekend,NULL_STRING,"Number of account member/fund",NULL_STRING}
oDCselx_rekend:FocusSelect := FSEL_HOME
oDCselx_rekend:OverWrite := OVERWRITE_ALWAYS
oDCselx_rekend:FieldSpec := memberaccount{}

oCCAccEndButton := PushButton{SELF,ResourceID{SELPERSPAYMENTS_ACCENDBUTTON,_GetInst()}}
oCCAccEndButton:HyperLabel := HyperLabel{#AccEndButton,"v","Browse in accounts",NULL_STRING}
oCCAccEndButton:TooltipText := "Browse in accounts"

oDCSubSet := ListboxExtra{SELF,ResourceID{SELPERSPAYMENTS_SUBSET,_GetInst()}}
oDCSubSet:TooltipText := "Select subset of given range"
oDCSubSet:HyperLabel := HyperLabel{#SubSet,NULL_STRING,NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{SELPERSPAYMENTS_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Range of destinations:",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{SELPERSPAYMENTS_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Payment date",NULL_STRING,NULL_STRING}

oDCselx_begin := DateTimePicker{SELF,ResourceID{SELPERSPAYMENTS_SELX_BEGIN,_GetInst()}}
oDCselx_begin:FieldSpec := Transaction_DAT{}
oDCselx_begin:HyperLabel := HyperLabel{#selx_begin,NULL_STRING,NULL_STRING,NULL_STRING}

oDCselx_end := DateTimePicker{SELF,ResourceID{SELPERSPAYMENTS_SELX_END,_GetInst()}}
oDCselx_end:FieldSpec := Transaction_DAT{}
oDCselx_end:HyperLabel := HyperLabel{#selx_end,NULL_STRING,NULL_STRING,NULL_STRING}

oDCMinTotal := SingleLineEdit{SELF,ResourceID{SELPERSPAYMENTS_MINTOTAL,_GetInst()}}
oDCMinTotal:HyperLabel := HyperLabel{#MinTotal,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMinTotal:Picture := "999999"
oDCMinTotal:TextLimit := 2

oDCMaxTotal := SingleLineEdit{SELF,ResourceID{SELPERSPAYMENTS_MAXTOTAL,_GetInst()}}
oDCMaxTotal:HyperLabel := HyperLabel{#MaxTotal,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMaxTotal:Picture := "999999"
oDCMaxTotal:TextLimit := 3

oCCOKButton := PushButton{SELF,ResourceID{SELPERSPAYMENTS_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"Ok",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{SELPERSPAYMENTS_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCGroupBox3 := GroupBox{SELF,ResourceID{SELPERSPAYMENTS_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"Total amount within period of person ",NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{SELPERSPAYMENTS_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Between:",NULL_STRING,NULL_STRING}

oDCFixedText6 := FixedText{SELF,ResourceID{SELPERSPAYMENTS_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"and:",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{SELPERSPAYMENTS_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Subset:",NULL_STRING,NULL_STRING}

oDCNonHomeBox := CheckBox{SELF,ResourceID{SELPERSPAYMENTS_NONHOMEBOX,_GetInst()}}
oDCNonHomeBox:HyperLabel := HyperLabel{#NonHomeBox,"Members not of",NULL_STRING,NULL_STRING}

oDCHomeBox := CheckBox{SELF,ResourceID{SELPERSPAYMENTS_HOMEBOX,_GetInst()}}
oDCHomeBox:HyperLabel := HyperLabel{#HomeBox,"Members of",NULL_STRING,NULL_STRING}

oDCProjectsBox := CheckBox{SELF,ResourceID{SELPERSPAYMENTS_PROJECTSBOX,_GetInst()}}
oDCProjectsBox:HyperLabel := HyperLabel{#ProjectsBox,"Projects",NULL_STRING,NULL_STRING}

oDCTextTill := FixedText{SELF,ResourceID{SELPERSPAYMENTS_TEXTTILL,_GetInst()}}
oDCTextTill:HyperLabel := HyperLabel{#TextTill,"Fixed Text",NULL_STRING,NULL_STRING}

oDCTextfrom := FixedText{SELF,ResourceID{SELPERSPAYMENTS_TEXTFROM,_GetInst()}}
oDCTextfrom:HyperLabel := HyperLabel{#Textfrom,"Fixed Text",NULL_STRING,NULL_STRING}

oDCMinAmount := SingleLineEdit{SELF,ResourceID{SELPERSPAYMENTS_MINAMOUNT,_GetInst()}}
oDCMinAmount:HyperLabel := HyperLabel{#MinAmount,NULL_STRING,NULL_STRING,NULL_STRING}
oDCMinAmount:Picture := "999999"

oDCFixedText9 := FixedText{SELF,ResourceID{SELPERSPAYMENTS_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"Minimal individual amount:",NULL_STRING,NULL_STRING}

SELF:Caption := "Select givers to members/funds"
SELF:HyperLabel := HyperLabel{#SelPersPayments,"Select givers to members/funds",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS MaxTotal() CLASS SelPersPayments
RETURN SELF:FieldGet(#MaxTotal)

ASSIGN MaxTotal(uValue) CLASS SelPersPayments
SELF:FieldPut(#MaxTotal, uValue)
RETURN uValue

ACCESS MinAmount() CLASS SelPersPayments
RETURN SELF:FieldGet(#MinAmount)

ASSIGN MinAmount(uValue) CLASS SelPersPayments
SELF:FieldPut(#MinAmount, uValue)
RETURN uValue

ACCESS MinTotal() CLASS SelPersPayments
RETURN SELF:FieldGet(#MinTotal)

ASSIGN MinTotal(uValue) CLASS SelPersPayments
SELF:FieldPut(#MinTotal, uValue)
RETURN uValue

ACCESS NonHomeBox() CLASS SelPersPayments
RETURN SELF:FieldGet(#NonHomeBox)

ASSIGN NonHomeBox(uValue) CLASS SelPersPayments
SELF:FieldPut(#NonHomeBox, uValue)
RETURN uValue

METHOD OKButton( ) CLASS SelPersPayments
	LOCAL MyBegin, MyEnd, dat_exch  AS DATE
	LOCAL rek_exch AS STRING
	local aWhereOther as array
	self:oCaller:selx_rek := self:mRekId
	self:mRekSt:=self:selx_rek
	self:mRekEnd:=self:selx_rekend 

	* Assure correct order:
	IF self:mRekSt > self:mRekEnd
		rek_exch:= self:mRekSt
		self:mRekSt:=self:mRekEnd
		self:mRekEnd:=self:mRekSt
	ENDIF
	self:oCaller:selx_AccStart := self:mRekSt
	self:oCaller:selx_Accend := self:mRekEnd
	MyBegin := self:oDCSelx_begin:SelectedDate
	MyEnd := self:oDCSelx_end:SelectedDate
	IF MyBegin > MyEnd
		dat_exch:= MyBegin
		MyBegin := MyEnd
		MyEnd:= dat_Exch
	ENDIF
	aWhereOther:=self:oDCSubSet:GetSelectedItems()
	* Transaction:
	self:oCaller:selx_MinAmnt:=Val(self:oDCMinTotal:TextValue)
	self:oCaller:selx_MaxAmnt:=Val(self:oDCMaxTotal:TextValue)
   self:oCaller:selx_MinIndAmnt:=Val(self:oDCMinAmount:TextValue) 

	self:oCaller:cWhereOther:= 't.cre>t.deb'
	IF !Empty(MyBegin)
		 self:oCaller:cWhereOther:=self:oCaller:cWhereOther +" and t.dat>='"+SQLdate(MyBegin)+"'"
	ENDIF
	IF !Empty(MyEnd)
		 self:oCaller:cWhereOther:=self:oCaller:cWhereOther +" and t.dat<='"+SQLdate(MyEnd)+"'"
	ENDIF
	IF !Empty(self:oCaller:selx_AccStart) .and.  self:oCaller:selx_AccStart==self:oCaller:selx_Accend
		self:oCaller:cWhereOther+=" and t.accid='"+self:oCaller:selx_rek+"'"
	elseif !Empty( aWhereOther)
		self:oCaller:cWhereOther+=" and t.accid in ("+Implode(aWhereOther,"','")+")"
	ENDIF

	self:oCaller:selx_dat := DToS(MyBegin)
	self:oCaller:selx_start:=MyBegin
	self:oCaller:selx_End:=MyEnd
	self:oCaller:selx_voorw := 'account' + '=' + self:oCaller:selx_AccStart+ '-';
		+self:oCaller:selx_Accend + ' and given between ' +;
		DToC(MyBegin)+' - '+DToC(MyEnd)+;
		' and total at least '+AllTrim(self:oDCMinTotal:TextValue)+;
		IF(self:oCaller:selx_MaxAmnt>0,' and less than '+AllTrim(self:oDCMaxTotal:TextValue),"")
	self:oCaller:selx_OK := true
	self:EndWindow() 
	self:Close()

RETURN
METHOD PostInit(oParent,iCtlID,oServer,uExtra) CLASS SelPersPayments
	//Put your PostInit additions here
	LOCAL StartDate AS DATE
	self:SetTexts()
	oDCselx_begin:Value := SToD(Str(Year(Today()),4)+"0101")
	oDCselx_end:Value := Today()
	if Len(GlBalYears)<1
		FillBalYears()
	endif

	StartDate:=GlBalYears[Len(GlBalYears),1]
	oDCselx_begin:DateRange:=DATERange{StartDate,Today()+31}
	oDCselx_end:DateRange:=DATERange{StartDate,Today()+31}
	oCaller:=uExtra
	MyParent:=oParent	
  	oCaller:selx_OK := FALSE

	oDCMinTotal:Value:=0
	self:oDCHomeBox:Caption:=self:oLan:WGet("Members of")+" "+sLand
	self:oDCNonHomeBox:Caption:=self:oLan:WGet("Members not of")+" "+sLand
	SELF:ProjectsBox:=TRUE
	SELF:AccFil()

	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS SelPersPayments
	//Put your PreInit additions here
	self:FillMbrProjArray()
	RETURN nil
ACCESS ProjectsBox() CLASS SelPersPayments
RETURN SELF:FieldGet(#ProjectsBox)

ASSIGN ProjectsBox(uValue) CLASS SelPersPayments
SELF:FieldPut(#ProjectsBox, uValue)
RETURN uValue

ACCESS selx_rek() CLASS SelPersPayments
RETURN SELF:FieldGet(#selx_rek)

ASSIGN selx_rek(uValue) CLASS SelPersPayments
SELF:FieldPut(#selx_rek, uValue)
RETURN uValue

ACCESS selx_rekend() CLASS SelPersPayments
RETURN SELF:FieldGet(#selx_rekend)

ASSIGN selx_rekend(uValue) CLASS SelPersPayments
SELF:FieldPut(#selx_rekend, uValue)
RETURN uValue

ACCESS SubSet() CLASS SelPersPayments
RETURN SELF:FieldGet(#SubSet)

ASSIGN SubSet(uValue) CLASS SelPersPayments
SELF:FieldPut(#SubSet, uValue)
RETURN uValue

STATIC DEFINE SELPERSPAYMENTS_ACCBEGINBUTTON := 105 
STATIC DEFINE SELPERSPAYMENTS_ACCENDBUTTON := 107 
STATIC DEFINE SELPERSPAYMENTS_CANCELBUTTON := 116 
STATIC DEFINE SELPERSPAYMENTS_FIXEDTEXT1 := 100 
STATIC DEFINE SELPERSPAYMENTS_FIXEDTEXT2 := 101 
STATIC DEFINE SELPERSPAYMENTS_FIXEDTEXT3 := 102 
STATIC DEFINE SELPERSPAYMENTS_FIXEDTEXT4 := 103 
STATIC DEFINE SELPERSPAYMENTS_FIXEDTEXT5 := 118 
STATIC DEFINE SELPERSPAYMENTS_FIXEDTEXT6 := 119 
STATIC DEFINE SELPERSPAYMENTS_FIXEDTEXT7 := 120 
STATIC DEFINE SELPERSPAYMENTS_FIXEDTEXT9 := 127 
STATIC DEFINE SELPERSPAYMENTS_GROUPBOX1 := 109 
STATIC DEFINE SELPERSPAYMENTS_GROUPBOX2 := 110 
STATIC DEFINE SELPERSPAYMENTS_GROUPBOX3 := 117 
STATIC DEFINE SELPERSPAYMENTS_HOMEBOX := 122 
STATIC DEFINE SELPERSPAYMENTS_MAXTOTAL := 114 
STATIC DEFINE SELPERSPAYMENTS_MINAMOUNT := 126 
STATIC DEFINE SELPERSPAYMENTS_MINTOTAL := 113 
STATIC DEFINE SELPERSPAYMENTS_NONHOMEBOX := 121 
STATIC DEFINE SELPERSPAYMENTS_OKBUTTON := 115 
STATIC DEFINE SELPERSPAYMENTS_PROJECTSBOX := 123 
STATIC DEFINE SELPERSPAYMENTS_SELX_BEGIN := 111 
STATIC DEFINE SELPERSPAYMENTS_SELX_END := 112 
STATIC DEFINE SELPERSPAYMENTS_SELX_REK := 104 
STATIC DEFINE SELPERSPAYMENTS_SELX_REKEND := 106 
STATIC DEFINE SELPERSPAYMENTS_SUBSET := 108 
STATIC DEFINE SELPERSPAYMENTS_TEXTFROM := 125 
STATIC DEFINE SELPERSPAYMENTS_TEXTTILL := 124 
STATIC DEFINE SELPERSPAYMENTSOUD_ACCBEGINBUTTON := 105 
STATIC DEFINE SELPERSPAYMENTSOUD_ACCENDBUTTON := 107 
STATIC DEFINE SELPERSPAYMENTSOUD_CANCELBUTTON := 116 
STATIC DEFINE SELPERSPAYMENTSOUD_FIXEDTEXT1 := 100 
STATIC DEFINE SELPERSPAYMENTSOUD_FIXEDTEXT2 := 101 
STATIC DEFINE SELPERSPAYMENTSOUD_FIXEDTEXT3 := 102 
STATIC DEFINE SELPERSPAYMENTSOUD_FIXEDTEXT4 := 103 
STATIC DEFINE SELPERSPAYMENTSOUD_FIXEDTEXT5 := 118 
STATIC DEFINE SELPERSPAYMENTSOUD_FIXEDTEXT6 := 119 
STATIC DEFINE SELPERSPAYMENTSOUD_FIXEDTEXT7 := 120 
STATIC DEFINE SELPERSPAYMENTSOUD_GROUPBOX1 := 109 
STATIC DEFINE SELPERSPAYMENTSOUD_GROUPBOX2 := 110 
STATIC DEFINE SELPERSPAYMENTSOUD_GROUPBOX3 := 117 
STATIC DEFINE SELPERSPAYMENTSOUD_MAXTOTAL := 114 
STATIC DEFINE SELPERSPAYMENTSOUD_MINTOTAL := 113 
STATIC DEFINE SELPERSPAYMENTSOUD_OKBUTTON := 115 
STATIC DEFINE SELPERSPAYMENTSOUD_SELX_BEGIN := 111 
STATIC DEFINE SELPERSPAYMENTSOUD_SELX_END := 112 
STATIC DEFINE SELPERSPAYMENTSOUD_SELX_REK := 104 
STATIC DEFINE SELPERSPAYMENTSOUD_SELX_REKEND := 106 
STATIC DEFINE SELPERSPAYMENTSOUD_SUBSET := 108 
RESOURCE SelPersPrimary DIALOGEX  15, 22, 324, 123
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Selection items for persons"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Selection on", SELPERSPRIMARY_SELX_KEUZE1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 10, 237, 99
	CONTROL	"person parameters only (e.g. mailing code, gender, ..)", SELPERSPRIMARY_SELPERSPRBUTTON1, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 26, 23, 198, 11
	CONTROL	"unpaid items (in con.with bills, reminders, ...)", SELPERSPRIMARY_SELPERSPRBUTTON2, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 26, 44, 167, 12
	CONTROL	"Regular payers/givers: standard gifts/donations/subscriptions", SELPERSPRIMARY_SELPERSPRBUTTON3, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 26, 65, 214, 11
	CONTROL	"givers/payers in certain period", SELPERSPRIMARY_SELPERSPRBUTTON4, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 26, 86, 156, 11
	CONTROL	"OK", SELPERSPRIMARY_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 259, 14, 53, 12
	CONTROL	"Cancel", SELPERSPRIMARY_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 259, 34, 53, 12
END

CLASS SelPersPrimary INHERIT DialogWinDowExtra 

	PROTECT oDCSelx_keuze1 AS RADIOBUTTONGROUP
	PROTECT oCCSelPersPrButton1 AS RADIOBUTTON
	PROTECT oCCSelPersPrButton2 AS RADIOBUTTON
	PROTECT oCCSelPersPrButton3 AS RADIOBUTTON
	PROTECT oCCSelPersPrButton4 AS RADIOBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
    PROTECT cAccountBeginName,cAccountEndName AS STRING
	PROTECT mRekSt AS STRING
	PROTECT mREKEnd AS STRING
// 	PROTECT oAcc AS Account
	PROTECT oCaller AS OBJECT
METHOD CancelButton( ) CLASS SelPersPrimary
	SELF:EndDialog()
	oCaller:selx_OK := FALSE
	
	RETURN SELF
METHOD Close(oEvent) CLASS SelPersPrimary
	SUPER:Close(oEvent)
	//Put your changes here
	SELF:Destroy()
	RETURN NIL
METHOD Init(oParent,uExtra) CLASS SelPersPrimary 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"SelPersPrimary",_GetInst()},TRUE)

oCCSelPersPrButton1 := RadioButton{SELF,ResourceID{SELPERSPRIMARY_SELPERSPRBUTTON1,_GetInst()}}
oCCSelPersPrButton1:HyperLabel := HyperLabel{#SelPersPrButton1,"person parameters only (e.g. mailing code, gender, ..)",NULL_STRING,NULL_STRING}

oCCSelPersPrButton2 := RadioButton{SELF,ResourceID{SELPERSPRIMARY_SELPERSPRBUTTON2,_GetInst()}}
oCCSelPersPrButton2:HyperLabel := HyperLabel{#SelPersPrButton2,"unpaid items (in con.with bills, reminders, ...)",NULL_STRING,NULL_STRING}

oCCSelPersPrButton3 := RadioButton{SELF,ResourceID{SELPERSPRIMARY_SELPERSPRBUTTON3,_GetInst()}}
oCCSelPersPrButton3:HyperLabel := HyperLabel{#SelPersPrButton3,"Regular payers/givers: standard gifts/donations/subscriptions",NULL_STRING,NULL_STRING}

oCCSelPersPrButton4 := RadioButton{SELF,ResourceID{SELPERSPRIMARY_SELPERSPRBUTTON4,_GetInst()}}
oCCSelPersPrButton4:HyperLabel := HyperLabel{#SelPersPrButton4,"givers/payers in certain period",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{SELPERSPRIMARY_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{SELPERSPRIMARY_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCSelx_keuze1 := RadioButtonGroup{SELF,ResourceID{SELPERSPRIMARY_SELX_KEUZE1,_GetInst()}}
oDCSelx_keuze1:FillUsing({ ;
							{oCCSelPersPrButton1,"1"}, ;
							{oCCSelPersPrButton2,"2"}, ;
							{oCCSelPersPrButton3,"3"}, ;
							{oCCSelPersPrButton4,"4"} ;
							})
oDCSelx_keuze1:HyperLabel := HyperLabel{#Selx_keuze1,"Selection on",NULL_STRING,NULL_STRING}

SELF:Caption := "Selection items for persons"
SELF:HyperLabel := HyperLabel{#SelPersPrimary,"Selection items for persons",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS SelPersPrimary
	IF Empty(oDCSelx_keuze1:TextValue)
		(Errorbox{,"Make a choice!"}):Show()
		RETURN
	ENDIF
	SELF:oCaller:selx_keus1 := Val(oDCSelx_keuze1:Value)
	SELF:EndDialog()

	RETURN SELF
METHOD PostInit(oParent,uExtra) CLASS SelPersPrimary
	//Put your PostInit additions here
self:SetTexts()
	oCaller:=uExtra
	RETURN NIL
STATIC DEFINE SELPERSPRIMARY_CANCELBUTTON := 106 
STATIC DEFINE SELPERSPRIMARY_OKBUTTON := 105 
STATIC DEFINE SELPERSPRIMARY_SELPERSPRBUTTON1 := 101 
STATIC DEFINE SELPERSPRIMARY_SELPERSPRBUTTON2 := 102 
STATIC DEFINE SELPERSPRIMARY_SELPERSPRBUTTON3 := 103 
STATIC DEFINE SELPERSPRIMARY_SELPERSPRBUTTON4 := 104 
STATIC DEFINE SELPERSPRIMARY_SELX_KEUZE1 := 100 
