CLASS DonorFollowingReport INHERIT DataWindowMine 

	PROTECT oDCProjectsBox AS CHECKBOX
	PROTECT oDCHomeBox AS CHECKBOX
	PROTECT oDCNonHomeBox AS CHECKBOX
	PROTECT oDCFromAccount AS SINGLELINEEDIT
	PROTECT oCCFromAccButton AS PUSHBUTTON
	PROTECT oDCToAccount AS SINGLELINEEDIT
	PROTECT oCCToAccButton AS PUSHBUTTON
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCSubPerLen AS COMBOBOX
	PROTECT oDCPropertiesBox AS GROUPBOX
	PROTECT oDCGender AS CHECKBOX
	PROTECT oDCAge AS CHECKBOX
	PROTECT oCCRange10 AS RADIOBUTTON
	PROTECT oCCRange20 AS RADIOBUTTON
	PROTECT oDCType AS CHECKBOX
	PROTECT oDCFrequency AS CHECKBOX
	PROTECT oDCRanges AS RADIOBUTTONGROUP
	PROTECT oDCStatisticsBox AS GROUPBOX
	PROTECT oDCStatBox1 AS CHECKBOX
	PROTECT oDCStatBox2 AS CHECKBOX
	PROTECT oDCStatBox3 AS CHECKBOX
	PROTECT oDCStatBox4 AS CHECKBOX
	PROTECT oDCStatBox5 AS CHECKBOX
	PROTECT oDCStatBox6 AS CHECKBOX
	PROTECT oDCStatBox7 AS CHECKBOX
	PROTECT oDCStatBox8 AS CHECKBOX
	PROTECT oDCNumberRanges AS SINGLELINEEDIT
	PROTECT oDCFixedTextRanges AS FIXEDTEXT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCTextfrom AS FIXEDTEXT
	PROTECT oDCTextTill AS FIXEDTEXT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCSubSet AS LISTBOXDONORREPORT
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCDiffBox AS CHECKBOX
	PROTECT oDCFromdate AS DATESTANDARD
	PROTECT oDCTodate AS DATESTANDARD
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oDCGroupBox3 AS GROUPBOX
	PROTECT oDCFixedText9 AS FIXEDTEXT
	PROTECT oDCFixedText10 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	INSTANCE ProjectsBox
	INSTANCE HomeBox
	INSTANCE NonHomeBox
	INSTANCE FromAccount
	INSTANCE ToAccount
	INSTANCE SubPerLen
	INSTANCE Gender
	INSTANCE Age
	INSTANCE Type
	INSTANCE Frequency
	INSTANCE Ranges
	INSTANCE StatBox1
	INSTANCE StatBox2
	INSTANCE StatBox3
	INSTANCE StatBox4
	INSTANCE StatBox5
	INSTANCE StatBox6
	INSTANCE StatBox7
	INSTANCE StatBox8
	INSTANCE NumberRanges
	INSTANCE SubSet
	INSTANCE DiffBox
	PROTECT MaxJaar,MinJaar, StartJaar as int
    PROTECT aPropEx:={} AS ARRAY
	EXPORT cFromAccName AS STRING
	EXPORT cToAccName AS STRING
	PROTECT FromYear,FromMonth,ToYear,ToMonth AS INT
	export oSelPers as SelPers 
	export aSelectedClasses as arraY
RESOURCE DonorFollowingReport DIALOGEX  33, 9, 391, 400
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Projects", DONORFOLLOWINGREPORT_PROJECTSBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 13, 40, 80, 11
	CONTROL	"Members of", DONORFOLLOWINGREPORT_HOMEBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 13, 51, 211, 11
	CONTROL	"Members not of", DONORFOLLOWINGREPORT_NONHOMEBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 13, 62, 215, 11
	CONTROL	"", DONORFOLLOWINGREPORT_FROMACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 13, 86, 79, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", DONORFOLLOWINGREPORT_FROMACCBUTTON, "Button", WS_CHILD, 91, 86, 15, 12
	CONTROL	"", DONORFOLLOWINGREPORT_TOACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 136, 85, 78, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", DONORFOLLOWINGREPORT_TOACCBUTTON, "Button", WS_CHILD, 214, 85, 16, 12
	CONTROL	"Sub period length:", DONORFOLLOWINGREPORT_FIXEDTEXT2, "Static", WS_CHILD, 13, 164, 72, 12
	CONTROL	"", DONORFOLLOWINGREPORT_SUBPERLEN, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 111, 163, 71, 72
	CONTROL	"Divide givers into classes according to their property:", DONORFOLLOWINGREPORT_PROPERTIESBOX, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 182, 231, 70
	CONTROL	"Gender", DONORFOLLOWINGREPORT_GENDER, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 194, 80, 11
	CONTROL	"Age", DONORFOLLOWINGREPORT_AGE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 208, 32, 11
	CONTROL	"10 years", DONORFOLLOWINGREPORT_RANGE10, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 64, 208, 41, 11
	CONTROL	"20 years", DONORFOLLOWINGREPORT_RANGE20, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 114, 208, 40, 11
	CONTROL	"Type of Person", DONORFOLLOWINGREPORT_TYPE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 221, 80, 11
	CONTROL	"Frequency of giving", DONORFOLLOWINGREPORT_FREQUENCY, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 235, 80, 11
	CONTROL	"Ranges", DONORFOLLOWINGREPORT_RANGES, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|NOT WS_VISIBLE, 59, 200, 99, 20
	CONTROL	"Required statistical data", DONORFOLLOWINGREPORT_STATISTICSBOX, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 11, 257, 304, 112
	CONTROL	"amount given per class of givers", DONORFOLLOWINGREPORT_STATBOX1, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 267, 251, 11
	CONTROL	"percentage of total amount given, a certain class of givers has contributed", DONORFOLLOWINGREPORT_STATBOX2, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 279, 253, 11
	CONTROL	"number of givers per class of givers", DONORFOLLOWINGREPORT_STATBOX3, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 291, 251, 11
	CONTROL	"percentage of total number of givers, a certain class of givers has contributed", DONORFOLLOWINGREPORT_STATBOX4, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 304, 255, 11
	CONTROL	"average amount given per class of givers", DONORFOLLOWINGREPORT_STATBOX5, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 316, 153, 11
	CONTROL	"median amount given per class of givers", DONORFOLLOWINGREPORT_STATBOX6, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 329, 155, 11
	CONTROL	"spread over ranges of amounts given per class of givers ", DONORFOLLOWINGREPORT_STATBOX7, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 342, 191, 11
	CONTROL	"export givers per class", DONORFOLLOWINGREPORT_STATBOX8, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 355, 155, 11
	CONTROL	"", DONORFOLLOWINGREPORT_NUMBERRANGES, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 291, 342, 17, 12, WS_EX_CLIENTEDGE
	CONTROL	"Number of ranges:", DONORFOLLOWINGREPORT_FIXEDTEXTRANGES, "Static", WS_CHILD|NOT WS_VISIBLE, 227, 342, 63, 12
	CONTROL	"Members/funds", DONORFOLLOWINGREPORT_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|WS_CLIPSIBLINGS, 8, 30, 377, 82
	CONTROL	"From:", DONORFOLLOWINGREPORT_FIXEDTEXT1, "Static", WS_CHILD, 14, 75, 52, 10
	CONTROL	"To:", DONORFOLLOWINGREPORT_FIXEDTEXT3, "Static", WS_CHILD, 136, 75, 56, 10
	CONTROL	"Fixed Text", DONORFOLLOWINGREPORT_TEXTFROM, "Static", WS_CHILD, 13, 98, 111, 12
	CONTROL	"Fixed Text", DONORFOLLOWINGREPORT_TEXTTILL, "Static", WS_CHILD, 136, 98, 111, 12
	CONTROL	"Subset:", DONORFOLLOWINGREPORT_FIXEDTEXT7, "Static", WS_CHILD, 250, 40, 53, 9
	CONTROL	"OK", DONORFOLLOWINGREPORT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 324, 380, 53, 12
	CONTROL	"", DONORFOLLOWINGREPORT_SUBSET, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 250, 50, 125, 201, WS_EX_CLIENTEDGE
	CONTROL	"Cancel", DONORFOLLOWINGREPORT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 324, 365, 53, 12
	CONTROL	"Show differences with the previous period", DONORFOLLOWINGREPORT_DIFFBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 12, 382, 172, 11
	CONTROL	"zaterdag 3 mei 2008", DONORFOLLOWINGREPORT_FROMDATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 62, 126, 120, 13, WS_EX_CLIENTEDGE
	CONTROL	"zaterdag 3 mei 2008", DONORFOLLOWINGREPORT_TODATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 62, 145, 120, 13, WS_EX_CLIENTEDGE
	CONTROL	"From Date:", DONORFOLLOWINGREPORT_FIXEDTEXT6, "Static", WS_CHILD, 13, 126, 46, 12
	CONTROL	"Till Date:", DONORFOLLOWINGREPORT_FIXEDTEXT8, "Static", WS_CHILD, 13, 145, 41, 12
	CONTROL	"Report Period", DONORFOLLOWINGREPORT_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 113, 232, 68
	CONTROL	"Give insight in the effects of e.g. a mailing on the donor behaviour:", DONORFOLLOWINGREPORT_FIXEDTEXT9, "Static", WS_CHILD, 7, 4, 376, 12
	CONTROL	"which part of the different groups of givers have given during a certain period of time and how much have they given", DONORFOLLOWINGREPORT_FIXEDTEXT10, "Static", WS_CHILD, 7, 17, 371, 12
END

METHOD AccFil() CLASS DonorFollowingReport
	LOCAL i AS INT
	LOCAL SubLen AS INT
	SELF:FromAccount:="0"
	SELF:ToAccount:="zzzzzzzzz"
	SELF:oDCSubSet:FillUsing(SELF:oDCSubSet:GetAccnts())
	* Select all:
	SubLen:=SELF:oDCSubSet:ItemCount
	FOR i = 1 TO SubLen
    	SELF:oDCSubSet:SelectItem(i)
	NEXT
	SELF:FromAccount:= LTrimZero(SELF:oDCSubSet:GetItem(1,LENACCNBR))
	SELF:oDCFromAccount:TEXTValue := FromAccount
	SELF:cFromAccName := FromAccount
	SELF:oDCTextfrom:caption := AllTrim(SubStr(SELF:oDCSubSet:GetItem(1),LENACCNBR+1))
	SELF:ToAccount:= LTrimZero(SELF:oDCSubSet:GetItem(SubLen,LENACCNBR))
	SELF:oDCToAccount:TEXTValue := ToAccount
	SELF:cToAccName := ToAccount
	SELF:oDCTextTill:caption := AllTrim(SubStr(SELF:oDCSubSet:GetItem(SubLen),LENACCNBR+1))
RETURN


METHOD AddClass(aValues,line,level,maxlevel,aClassList) CLASS DonorFollowingReport
	// add Class combinations recurrent to aValues
	LOCAL i AS INT
	LOCAL sep:="," AS STRING
	IF Empty(line)
		sep:=""
	ENDIF
	FOR i:=aClassList[level,2] TO aClassList[level,3]
		IF level<maxlevel
			SELF:AddClass(aValues,line+sep+AllTrim(Str(i)),level+1,maxlevel,aClassList)
		ELSE
			AAdd(aValues,{line+sep+AllTrim(Str(i))})
		ENDIF
	NEXT
RETURN
		
		
ACCESS Age() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#Age)

ASSIGN Age(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#Age, uValue)
RETURN uValue

METHOD ButtonClick(oControlEvent) CLASS DonorFollowingReport
	LOCAL oControl AS Control
	LOCAL i AS INT
	LOCAL SubLen AS INT
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:Name=="STATBOX7"
		IF SELF:oDCStatBox7:Checked
			SELF:oDCNumberRanges:Show()
			SELF:oDCFixedTextRanges:Show()
		ELSE
			SELF:oDCNumberRanges:Hide()
			SELF:oDCFixedTextRanges:Hide()
		ENDIF
	ELSEIF oControl:Name=="AGE"
		IF SELF:oDCAge:Checked
			SELF:oDCRanges:show()
			SELF:oCCRange10:Show()
			SELF:oCCRange20:Show()
		ELSE
			SELF:oDCRanges:Hide()
			SELF:oCCRange10:Hide()
			SELF:oCCRange20:Hide()
		ENDIF
	ELSEIF oControl:NameSym=#HomeBox .or. oControl:NameSym=#NonHomeBox .or. oControl:NameSym=#ProjectsBox
		SELF:AccFil()
	ENDIF
	RETURN NIL
METHOD CancelButton( ) CLASS DonorFollowingReport
	SELF:EndWindow()
	RETURN NIL
METHOD Close(oEvent) CLASS DonorFollowingReport
	SUPER:Close(oEvent)
	//Put your changes here
	SELF:EndWindow()
	RETURN NIL
METHOD DetermineFrequency(oTransF, aPersons, aFPer,aFreq,aPrvFreq,pPtr) CLASS DonorFollowingReport
	// determine frequency of giving of person
	LOCAL cntr:=0,i,curFreq AS INT
	LOCAL oTrans:=oTransF AS TransHistory
	LOCAL lDiff:=!Empty(aPrvFreq) AS LOGIC
	LOCAL tDat:=oTrans:DAT as date, PersId:=oTrans:PersId as STRING
	
	IF pPtr=0
		pPtr:=AScanBinExact(aPersons,PersId)
		IF pPtr==0	
			RETURN
		ENDIF
	ENDIF

	// determine period:
	IF lDiff
		// actual period:
		IF (curFreq:=aFreq[pPtr])<5
			IF tDat<aFPer[3,1]
				IF curFreq=1
					aFreq[pPtr]:=2 // not given last two years
				ENDIF
			ELSEIF tDat<aFPer[4,1]
				IF curFreq<3
					aFreq[pPtr]:=3 // not given last year
				ENDIF
			ELSE
				IF curFreq<4
					aFreq[pPtr]:=4 // given last year
				ELSE
					aFreq[pPtr]:=5 // given >=2 times last year
				ENDIF
			ENDIF
		ENDIF
		// previous period:
		IF (curFreq:=aPrvFreq[pPtr])<5
			IF tDat<aFPer[1,1]
				IF curFreq=1
					aPrvFreq[pPtr]:=2 // not given last two years
				ENDIF
			ELSEIF tDat<aFPer[2,1]
				IF curFreq<3
					aPrvFreq[pPtr]:=3 // not given last year
				ENDIF
			ELSEIF tDat<=aFPer[2,2]
				IF curFreq<4
					aPrvFreq[pPtr]:=4 // given last year
				ELSE
					aPrvFreq[pPtr]:=5 // given >=2 times last year
				ENDIF
			ENDIF
		ENDIF
	ELSE
		// only actual period:
		IF (curFreq:=aFreq[pPtr])<5
			IF tDat<aFPer[1,1]
				IF curFreq=1
					aFreq[pPtr]:=2 // not given last two years
				ENDIF
			ELSEIF tDat<aFPer[2,1]
				IF curFreq<3
					aFreq[pPtr]:=3 // not given last year
				ENDIF
			ELSE
				IF curFreq<4
					aFreq[pPtr]:=4 // given last year
				ELSE
					aFreq[pPtr]:=5 // given >=2 times last year
				ENDIF
			ENDIF
		ENDIF
	ENDIF
RETURN
ACCESS DiffBox() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#DiffBox)

ASSIGN DiffBox(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#DiffBox, uValue)
RETURN uValue

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS DonorFollowingReport
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "FROMACCOUNT"
			IF !Upper(AllTrim(oControl:Value))==Upper(AllTrim(cFromAccName))
				cFromAccName:=AllTrim(oControl:Value)
				SELF:FromAccButton(TRUE)
			ENDIF
		ELSEIF oControl:Name == "TOACCOUNT"
			IF !Upper(AllTrim(oControl:Value))==Upper(AllTrim(cToAccName))
				cToAccName:=AllTrim(oControl:Value)
				SELF:ToAccButton(TRUE)
			ENDIF
		ENDIF
	ENDIF
	RETURN

ACCESS Frequency() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#Frequency)

ASSIGN Frequency(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#Frequency, uValue)
RETURN uValue

METHOD FromAccButton(lUnique ) CLASS DonorFollowingReport
	Default(@lUnique,FALSE)
	AccountSelect(SELF,AllTrim(oDCFromAccount:TEXTValue ),"From Account",lUnique,"GiftAlwd",,)
ACCESS FromAccount() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#FromAccount)

ASSIGN FromAccount(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#FromAccount, uValue)
RETURN uValue

ACCESS Gender() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#Gender)

ASSIGN Gender(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#Gender, uValue)
RETURN uValue

ACCESS HomeBox() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#HomeBox)

ASSIGN HomeBox(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#HomeBox, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS DonorFollowingReport 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"DonorFollowingReport",_GetInst()},iCtlID)

aFonts[1] := Font{,10,"Microsoft Sans Serif"}
aFonts[1]:Bold := TRUE

oDCProjectsBox := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_PROJECTSBOX,_GetInst()}}
oDCProjectsBox:HyperLabel := HyperLabel{#ProjectsBox,"Projects",NULL_STRING,NULL_STRING}

oDCHomeBox := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_HOMEBOX,_GetInst()}}
oDCHomeBox:HyperLabel := HyperLabel{#HomeBox,"Members of",NULL_STRING,NULL_STRING}

oDCNonHomeBox := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_NONHOMEBOX,_GetInst()}}
oDCNonHomeBox:HyperLabel := HyperLabel{#NonHomeBox,"Members not of",NULL_STRING,NULL_STRING}

oDCFromAccount := SingleLineEdit{SELF,ResourceID{DONORFOLLOWINGREPORT_FROMACCOUNT,_GetInst()}}
oDCFromAccount:HyperLabel := HyperLabel{#FromAccount,NULL_STRING,NULL_STRING,NULL_STRING}
oDCFromAccount:FieldSpec := Account_AccNumber{}

oCCFromAccButton := PushButton{SELF,ResourceID{DONORFOLLOWINGREPORT_FROMACCBUTTON,_GetInst()}}
oCCFromAccButton:HyperLabel := HyperLabel{#FromAccButton,"v","Browse in accounts",NULL_STRING}
oCCFromAccButton:TooltipText := "Browse in accounts"

oDCToAccount := SingleLineEdit{SELF,ResourceID{DONORFOLLOWINGREPORT_TOACCOUNT,_GetInst()}}
oDCToAccount:HyperLabel := HyperLabel{#ToAccount,NULL_STRING,NULL_STRING,NULL_STRING}
oDCToAccount:FieldSpec := Account_AccNumber{}

oCCToAccButton := PushButton{SELF,ResourceID{DONORFOLLOWINGREPORT_TOACCBUTTON,_GetInst()}}
oCCToAccButton:HyperLabel := HyperLabel{#ToAccButton,"v",NULL_STRING,NULL_STRING}
oCCToAccButton:TooltipText := "Browse in Accounts"

oDCFixedText2 := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Sub period length:",NULL_STRING,NULL_STRING}

oDCSubPerLen := combobox{SELF,ResourceID{DONORFOLLOWINGREPORT_SUBPERLEN,_GetInst()}}
oDCSubPerLen:FillUsing({{"No subdivision",0},{"1 month",1},{"2 months",2},{"3 months",3},{"4 months",4},{"6 months",6},{"12 months",12},{"24 months",24}})
oDCSubPerLen:HyperLabel := HyperLabel{#SubPerLen,NULL_STRING,NULL_STRING,NULL_STRING}

oDCPropertiesBox := GroupBox{SELF,ResourceID{DONORFOLLOWINGREPORT_PROPERTIESBOX,_GetInst()}}
oDCPropertiesBox:HyperLabel := HyperLabel{#PropertiesBox,"Divide givers into classes according to their property:",NULL_STRING,NULL_STRING}

oDCGender := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_GENDER,_GetInst()}}
oDCGender:HyperLabel := HyperLabel{#Gender,"Gender",NULL_STRING,NULL_STRING}

oDCAge := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_AGE,_GetInst()}}
oDCAge:HyperLabel := HyperLabel{#Age,"Age",NULL_STRING,NULL_STRING}

oCCRange10 := RadioButton{SELF,ResourceID{DONORFOLLOWINGREPORT_RANGE10,_GetInst()}}
oCCRange10:HyperLabel := HyperLabel{#Range10,"10 years",NULL_STRING,NULL_STRING}

oCCRange20 := RadioButton{SELF,ResourceID{DONORFOLLOWINGREPORT_RANGE20,_GetInst()}}
oCCRange20:HyperLabel := HyperLabel{#Range20,"20 years",NULL_STRING,NULL_STRING}

oDCType := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_TYPE,_GetInst()}}
oDCType:HyperLabel := HyperLabel{#Type,"Type of Person",NULL_STRING,NULL_STRING}

oDCFrequency := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_FREQUENCY,_GetInst()}}
oDCFrequency:HyperLabel := HyperLabel{#Frequency,"Frequency of giving",NULL_STRING,NULL_STRING}

oDCStatisticsBox := GroupBox{SELF,ResourceID{DONORFOLLOWINGREPORT_STATISTICSBOX,_GetInst()}}
oDCStatisticsBox:HyperLabel := HyperLabel{#StatisticsBox,"Required statistical data",NULL_STRING,NULL_STRING}

oDCStatBox1 := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_STATBOX1,_GetInst()}}
oDCStatBox1:HyperLabel := HyperLabel{#StatBox1,"amount given per class of givers",NULL_STRING,NULL_STRING}

oDCStatBox2 := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_STATBOX2,_GetInst()}}
oDCStatBox2:HyperLabel := HyperLabel{#StatBox2,"percentage of total amount given, a certain class of givers has contributed",NULL_STRING,NULL_STRING}

oDCStatBox3 := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_STATBOX3,_GetInst()}}
oDCStatBox3:HyperLabel := HyperLabel{#StatBox3,"number of givers per class of givers",NULL_STRING,NULL_STRING}

oDCStatBox4 := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_STATBOX4,_GetInst()}}
oDCStatBox4:HyperLabel := HyperLabel{#StatBox4,"percentage of total number of givers, a certain class of givers has contributed",NULL_STRING,NULL_STRING}

oDCStatBox5 := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_STATBOX5,_GetInst()}}
oDCStatBox5:HyperLabel := HyperLabel{#StatBox5,"average amount given per class of givers",NULL_STRING,NULL_STRING}

oDCStatBox6 := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_STATBOX6,_GetInst()}}
oDCStatBox6:HyperLabel := HyperLabel{#StatBox6,"median amount given per class of givers",NULL_STRING,NULL_STRING}

oDCStatBox7 := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_STATBOX7,_GetInst()}}
oDCStatBox7:HyperLabel := HyperLabel{#StatBox7,"spread over ranges of amounts given per class of givers ",NULL_STRING,NULL_STRING}

oDCStatBox8 := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_STATBOX8,_GetInst()}}
oDCStatBox8:HyperLabel := HyperLabel{#StatBox8,"export givers per class",NULL_STRING,NULL_STRING}

oDCNumberRanges := SingleLineEdit{SELF,ResourceID{DONORFOLLOWINGREPORT_NUMBERRANGES,_GetInst()}}
oDCNumberRanges:Picture := "99"
oDCNumberRanges:HyperLabel := HyperLabel{#NumberRanges,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedTextRanges := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_FIXEDTEXTRANGES,_GetInst()}}
oDCFixedTextRanges:HyperLabel := HyperLabel{#FixedTextRanges,"Number of ranges:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{DONORFOLLOWINGREPORT_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Members/funds",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"From:",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"To:",NULL_STRING,NULL_STRING}

oDCTextfrom := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_TEXTFROM,_GetInst()}}
oDCTextfrom:HyperLabel := HyperLabel{#Textfrom,"Fixed Text",NULL_STRING,NULL_STRING}

oDCTextTill := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_TEXTTILL,_GetInst()}}
oDCTextTill:HyperLabel := HyperLabel{#TextTill,"Fixed Text",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Subset:",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{DONORFOLLOWINGREPORT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}
oCCOKButton:UseHLforToolTip := False

oDCSubSet := ListboxDonorReport{SELF,ResourceID{DONORFOLLOWINGREPORT_SUBSET,_GetInst()}}
oDCSubSet:TooltipText := "Select subset of given range of member/funds"
oDCSubSet:HyperLabel := HyperLabel{#SubSet,NULL_STRING,NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{DONORFOLLOWINGREPORT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCDiffBox := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_DIFFBOX,_GetInst()}}
oDCDiffBox:HyperLabel := HyperLabel{#DiffBox,"Show differences with the previous period",NULL_STRING,NULL_STRING}

oDCFromdate := DateStandard{SELF,ResourceID{DONORFOLLOWINGREPORT_FROMDATE,_GetInst()}}
oDCFromdate:FieldSpec := Transaction_DAT{}
oDCFromdate:HyperLabel := HyperLabel{#Fromdate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCTodate := DateStandard{SELF,ResourceID{DONORFOLLOWINGREPORT_TODATE,_GetInst()}}
oDCTodate:FieldSpec := Transaction_DAT{}
oDCTodate:HyperLabel := HyperLabel{#Todate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText6 := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"From Date:",NULL_STRING,NULL_STRING}

oDCFixedText8 := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"Till Date:",NULL_STRING,NULL_STRING}

oDCGroupBox3 := GroupBox{SELF,ResourceID{DONORFOLLOWINGREPORT_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"Report Period",NULL_STRING,NULL_STRING}

oDCFixedText9 := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"Give insight in the effects of e.g. a mailing on the donor behaviour:",NULL_STRING,NULL_STRING}
oDCFixedText9:Font(aFonts[1], FALSE)

oDCFixedText10 := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_FIXEDTEXT10,_GetInst()}}
oDCFixedText10:HyperLabel := HyperLabel{#FixedText10,"which part of the different groups of givers have given during a certain period of time and how much have they given",NULL_STRING,NULL_STRING}

oDCRanges := RadioButtonGroup{SELF,ResourceID{DONORFOLLOWINGREPORT_RANGES,_GetInst()}}
oDCRanges:FillUsing({ ;
						{oCCRange10,"10"}, ;
						{oCCRange20,"20"} ;
						})
oDCRanges:HyperLabel := HyperLabel{#Ranges,"Ranges",NULL_STRING,NULL_STRING}

SELF:Caption := "Donor Following Report"
SELF:HyperLabel := HyperLabel{#DonorFollowingReport,"Donor Following Report",NULL_STRING,NULL_STRING}
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD MarkupMatrix(ptrHandle,aMatrix,cHeading,PeriodCount,maxcols,maxlines) CLASS DonorFollowingReport
// fill excel matrix with data
LOCAL i,j,m as int, line as STRING
LOCAL diff AS FLOAT
	* header record:
	FWriteLine(ptrHandle,"<tr><td style='font-weight: bold;italic; color:blue;text-align : center;'  colspan='"+Str(maxcols-PeriodCount,-1)+"'>"+oLan:Get(cHeading)+"</td></tr>")
	FOR j:=1 TO maxlines
		line:="<tr>"
       	FOR i:=1 TO maxcols
       		IF IsNumeric(aMatrix[i,j])
       			// determine difference with previous period:
       			IF i>PeriodCount .and. SELF:DiffBox
       				IF IsNumeric(aMatrix[i-PeriodCount,j]) .and. aMatrix[i-PeriodCount,j]>0
		       			diff:=(aMatrix[i,j]*100)/aMatrix[i-PeriodCount,j]-100
		       			line+="<td>"+Str(aMatrix[i,j],-1)+" ("+iif(diff<0,"","+")+Str(diff,-1,0)+"%)"+"</td>"
		       		ELSE
						line+="<td>"+iif(aMatrix[i,j]>0,Str(aMatrix[i,j],-1)+" (new)","")+"</td>"
					ENDIF					
	       		ELSE
					line+="<td>"+Str(aMatrix[i,j],-1)+"</td>"
				ENDIF
			ELSEIF IsString(aMatrix[i,j])
				line+="<td "+iif(i=1,"style='background-color:#AFEEEE;'",iif(j=1,"style='background-color:lightblue;'",""))+">"+aMatrix[i,j]+"</td>"
			ELSEIF IsArray(aMatrix[i,j])
       			line+="<td><table style='border-collapse:collapse;' border='1'><tr>"
       			FOR m:=1 TO Len(aMatrix[i,j])
       				IF j=2
						line+="<td style='background-color:#F0E68C;text-align:center;'>"+iif(m=NumberRanges,">"+Str(aMatrix[i,j,m-1],-1),"<="+Str(aMatrix[i,j,m],-1))+"</td>"
					ELSE	
						line+="<td>"+Str(aMatrix[i,j,m],-1)+"</td>"
					ENDIF
				NEXT
				line+="</tr></table></td>"
       		ELSE
				line+="<td></td>"
			ENDIF
			IF i=1
				i:=PeriodCount+1 // skip previous period
			ENDIF
		NEXT
		FWriteLine(ptrHandle,line+"</tr>")
	NEXT
	FWriteLine(ptrHandle,"<tr><td colspan='"+Str(maxcols-PeriodCount,-1)+"'>&nbsp;<br></td></tr>")
	RETURN NIL
method MouseButtonDown(oMouseEvent) class DonorFollowingReport
	local nButtonID as int
	nButtonID := IIf(oMouseEvent == NULL_OBJECT, 0, oMouseEvent:ButtonID)
	super:MouseButtonDown(oMouseEvent)
	//Put your changes here
	return NIL

ACCESS NonHomeBox() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#NonHomeBox)

ASSIGN NonHomeBox(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#NonHomeBox, uValue)
RETURN uValue

ACCESS NumberRanges() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#NumberRanges)

ASSIGN NumberRanges(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#NumberRanges, uValue)
RETURN uValue

METHOD OKButton( ) CLASS DonorFollowingReport 
	local nP as int
	FromYear:=Year(SELF:oDCFromdate:SelectedDate)
	FromMonth:=Month(SELF:oDCFromdate:SelectedDate)
	ToYear:=Year(SELF:oDCTodate:SelectedDate)
	ToMonth:=Month(SELF:oDCTodate:SelectedDate)
	IF SELF:oDCSubSet:SelectedCount<1
		(ErrorBox{self,self:oLan:Wget("Select at least one Fund/Member!")}):show()
		SELF:oDCFromAccount:SetFocus()
		RETURN
	ENDIF
	IF FromYear<1980 .or.FromYear>Year(Today())+1
		(ErrorBox{self,self:oLan:Wget("Non valid from month!")}):show()
		SELF:oDCFromYear:SetFocus()
		RETURN
	ENDIF
	IF ToYear<1980 .or.ToYear>Year(Today())+1
		(ErrorBox{self,self:oLan:Wget("Non valid To month!")}):show()
		SELF:oDCToYear:SetFocus()
		RETURN
	ENDIF
	IF SELF:oDCFromdate:SelectedDate > SELF:oDCTodate:SelectedDate
		(ErrorBox{self,self:oLan:Wget("To Date must be behind From Date")}):show()
		SELF:oDCFromYear:SetFocus()
		RETURN
	ENDIF
	IF StatBox7 .and. NumberRanges<2
		(ErrorBox{self,self:oLan:Wget("Number of ranges must be at least 2")}):show()
		SELF:oDCNumberRanges:SetFocus()
		RETURN
	ENDIF
	IF !(StatBox1.or.StatBox2.or.StatBox3.or.StatBox4.or.StatBox5.or.StatBox6.or.StatBox7)
		(ErrorBox{self,self:oLan:Wget("Select at least one type of statistical data!")}):show()
		SELF:oDCStatBox1:SetFocus()
		RETURN
	ENDIF
// 	if !self:odcAge:Checked .and.!self:oDCGender:Checked .and. !self:oDCFrequency:Checked .and.!self:oDCType:Checked
// 		if Empty(self:aPropEx) .or. AScan(self:aPropEx,{|x|x:Checked})==0
// 			(ErrorBox{self,self:oLan:Wget("Specify at least one person property")}):show()
// 			RETURN
// 		endif
// 	endif

	if StatBox8
		oSelpers:=SelPers{self,"MAILINGCODE"}
		(SelPersMailCd{self,{oSelpers,"","Additional specifications of persons to be exported"}}):show() 
	endif
	SELF:Pointer := Pointer{POINTERHOURGLASS}
	SELF:PrintReport()
	SELF:Pointer := Pointer{POINTERARROW}
	RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS DonorFollowingReport
	//Put your PostInit additions here
	LOCAL count AS INT
	LOCAL EndDate,FromDate AS DATE
	LOCAL oTrans AS TransHistory
	LOCAL StartDate AS DATE
	self:SetTexts()

	self:oDCHomeBox:Caption:=(Language{}):WGet("Members of")+" "+sLand
	self:oDCNonHomeBox:Caption:=(Language{}):WGet("Members not of")+" "+sLand
	SELF:ProjectsBox:=TRUE
	SELF:AccFil()
	oTrans:=TransHistory{}
	StartDate:=SToD(Str(oTrans:OldestYear,6)+"01")
	oDCFromdate:DateRange:=DATERange{StartDate,Today()+31}
	oDCTodate:DateRange:=DATERange{StartDate,Today()+31}
	oTrans:Close()
	oTrans:=NULL_OBJECT

	SELF:oDCFromdate:Value:=Today()-360
	SELF:oDCFromdate:Value:=SELF:oDCFromdate:Value - Day(SELF:oDCFromdate:Value)+1
	SELF:oDCTodate:Value:=Today() - Day(Today())

	SELF:SubPerLen:=0
	SELF:Ranges:="20"
	SELF:NumberRanges:=5
	//SELF:oCCRange10:Pressed:=TRUE
	FOR count:=1 TO Len(pers_propextra) STEP 1
		SELF:SetPropExtra(count)
	NEXT
	StatBox1:=TRUE
StatBox2:=TRUE
StatBox3:=TRUE
StatBox4:=TRUE
StatBox5:=TRUE
StatBox6:=TRUE
StatBox7:=TRUE
SELF:oDCFixedTextRanges:show()
SELF:oDCNumberRanges:show()
DiffBox:=TRUE
RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS DonorFollowingReport
	//Put your PreInit additions here
	self:FillMbrProjArray()
	RETURN NIL
METHOD PrintReport() CLASS DonorFollowingReport
	// printing of donor versus project report
	LOCAL oAcc as Account
	LOCAL oTrans as TransHistory
	LOCAL oPers as Person
	LOCAL oTransFreq as TransHistory
	LOCAL aPers:={} as ARRAY // of each giver its CLN  
	local aPersExp:={} as Array // {pos.recno.exportable} of each person from aPers: if it is exportable conform selpersmailcode   
	LOCAL aPersPrvFreq,aPersFreq as ARRAY // of each person from aPers: frequency of giving: 1: first giver, 2: not last 2 years, 3: not last year, 4:last year once, 5: more than once last year
	LOCAL i,j,k,m,nRange,nCSt,maxlevel as int
	LOCAL cName as STRING
	LOCAL nFromYear:=FromYear,nFromMonth:=FromMonth,nToYear:=ToYear,nToMonth:=ToMonth as int
	LOCAL StartDate,EndDate,PerStart,PerEnd,FrequencyEnd,FrequencyStart as date
	LOCAL cFileName as USUAL, oFileSpec as FileSpec
	LOCAL ptrHandle
	LOCAL aAcc:={} as ARRAY
	LOCAL aClass:={} as ARRAY // person classes: {symname,fieldname, value[,value]}
	LOCAL aClassIndex:={} as ARRAY // list with overview of classes: fieldname, startnbr, endnbr,type (type:0 normal field, 1: age range,2:giving frequency, 3: extra property dropdn, 4: extra property checkbx
	LOCAL aExportClass:={} as Array // contains list of possible classes to be exported: {{name,index}, ...}
	LOCAL aPersValuePtrPrv,aPersValuePtr as ARRAY
	LOCAL aPeriod:={} as ARRAY // subperiods: {startdate,enddate}
	LOCAL PrevPeriodCount as int
	LOCAL aValues:={} as ARRAY // values per period and class: {classid,{perid,{values}}}
	LOCAL aDropValues as ARRAY
	LOCAL oCheck as CheckBox
	LOCAL cSearch,cSearchOrg,cSep,cClassName,cValueName,line as STRING
	LOCAL uFieldValue as USUAL, nFreq as int
	LOCAL nClassPtr,nClassPtr1,nClassPtr2,nCount,nAge,nValuePtr,nSubPeriod,nPersPtr as int
	LOCAL dTransDat as date
	LOCAL lSuccess as LOGIC
	LOCAL aClassPtr as ARRAY // ptrs to rows in aClass
	LOCAL aMatrix1,aMatrix2,aMatrix3,aMatrix4,aMatrix5,aMatrix6,aMatrix7 as ARRAY // matrix to fill with calculated values Stat1,Stat2, ...
	LOCAL SubSum as ARRAY
	LOCAL oXMLDoc as XMLDocument
	LOCAL fType as int //(0: normal FIELD,1: birthdate, 2: extra property checkbx,3:  extra property dropdown
	LOCAL SubTotal as FLOAT, PerTotal,PerCount as ARRAY
	LOCAL cFileName as USUAL, oFileSpec as FileSpec
	LOCAL ptrHandle
	LOCAL median1,median2,TrCnt,HelpDate,UltDay,EndDay,StartDay as int
	LOCAL aRangeVal as ARRAY  // values ranges per period
	LOCAL maxVal, minVal,rangeVal  // max and min value per period and value per range per period
	LOCAL sMes:="Collecting data for the report" as STRING
	LOCAL pMes:="Determining class per giver" as STRING
	LOCAL fMes:="Determining frequency of givers" as STRING
	LOCAL repMes:="" as STRING
	LOCAL Frequency_types:={{"First giver",1},{"Not given last 2 years",2},{"Not given last year",3},{"Given last year",4},{"Regular giver",5}}
	LOCAL aFrequency_periods:={{},{}} // periods for determing frequency of giving
	LOCAL time1 as STRING
	LOCAL pPtr as DWORD, prvCLN as STRING
	LOCAL lDiff:=self:DiffBox, lUltEnd, lUltStart as LOGIC
	local pKondp as _CODEBLOCK 
	LOCAL aTitle := {'Compact Person report','Extended Person report','Labels',;
		'Letters','Giro accepts','Export persons','Add/Remove Mailing Codes'} as array

	//SELF:Statusmessage(sMes)

	oAcc:=Account{,DBSHARED,DBREADONLY}
	IF !oAcc:Used
		RETURN nil
	ENDIF
	oAcc:SetOrder("REK")
	oAcc:SetFilter({||oAcc:GIFTALWD==true .or. !Empty(oAcc:CLN)})
	oPers:=Person{,DBSHARED,DBREADONLY}
	IF !oPers:Used
		RETURN nil
	ENDIF
	oPers:SetOrder("ASSRE")
	aAcc:=self:oDCSubSet:GetSelectedItems()
	ASort(aAcc)

	// Determine periods:
	StartDate:=self:oDCFromdate:SelectedDate
	EndDate:=self:oDCTodate:SelectedDate
	lUltEnd:= (Day(EndDate)== MonthEnd(nToMonth,nToYear))
	lUltStart:= (Day(StartDate)== MonthEnd(nFromMonth,nFromYear))
	IF self:SubPerLen=0
		AAdd(aPeriod,{StartDate,EndDate})
	ELSE
		PerStart:=StartDate
		PerEnd:=PerStart
		EndDay:=Day(EndDate)
		DO WHILE PerStart < EndDate
			HelpDate:=Year(PerEnd)*12+Month(PerEnd)-1+SubPerLen
			PerEnd:=SToD(Str(HelpDate/12,4)+StrZero(HelpDate%12+1,2)+"01")
			UltDay:=MonthEnd(Month(PerEnd),Year(PerEnd))
			IF lUltEnd .or. EndDay>UltDay
				PerEnd+=UltDay-1
			ELSE
				PerEnd+=EndDay-1
			ENDIF			
			IF PerEnd<=EndDate
				AAdd(aPeriod,{PerStart,PerEnd})	
			ENDIF
			PerStart:=PerEnd+1				
		ENDDO
		EndDate:=aPeriod[Len(aPeriod),2]
	ENDIF
	IF lDiff
		// also for the previous period:
		PrevPeriodCount:=Len(aPeriod)
		PerEnd:=aPeriod[1,1]-1
		PerStart:=PerEnd
		ASize(aPeriod,2*PrevPeriodCount)
		IF SubPerLen=0
			PerStart:=PerEnd-(EndDate-StartDate)
			AIns(aPeriod,1)	
			aPeriod[1]:={PerStart,PerEnd}
		ELSE
			EndDay:=Day(StartDate)
			FOR i:=1 to PrevPeriodCount
				HelpDate:=Year(PerStart)*12+Month(PerStart)-1-SubPerLen
				PerStart:=SToD(Str(HelpDate/12,4)+StrZero(HelpDate%12+1,2)+"01")
				UltDay:=MonthEnd(Month(PerStart),Year(PerStart))
				IF lUltStart .or. EndDay>UltDay
					PerStart+=UltDay-1
				ELSE
					PerStart+=EndDay-1
				ENDIF			
				AIns(aPeriod,1)	
				aPeriod[1]:={PerStart,PerEnd}
				PerEnd:=PerStart-1				
			NEXT
		ENDIF
	ENDIF

	oTrans:=TransHistory{Year(aPeriod[1,1]),Month(aPeriod[1,1]),"NUM",DBREADONLY,nToYear,nToMonth,aAcc[1]+Str(Year(aPeriod[1,1]),4,0)+StrZero(Month(aPeriod[1,1]),2,0),"rek<='"+aAcc[Len(aAcc)]+"'"}
	IF !oTrans:Used
		RETURN nil
	ENDIF 
	lSuccess:=oTrans:SetFilter(,"!Empty(CLN).and.!GC=='PF'.and.!GC=='CH'.and.DTOS(DAT)>='"+DToS(aPeriod[1,1])+"'.and.DTOS(DAT)<='"+DToS(EndDate)+"'.and.CRE>DEB")
	// Determine first CLN's of givers:
	time1:=Time()
	oTrans:GoTop()
	DO WHILE !oTrans:EoF
		if AScanBinExact(aAcc,oTrans:REK)=0
			oTrans:Skip()
			loop
		endif
		IF AScan(aPers,oTrans:CLN)=0
			AAdd(aPers,oTrans:CLN)
		ENDIF
		TrCnt++
		IF TrCnt>1000
			repMes+="."
			self:STATUSMESSAGE(sMes+"("+ElapTime(time1,Time())+")"+repMes)
			IF Len(repMes)>84
				repMes:=""
			ENDIF
			TrCnt:=0
		ENDIF
		oTrans:Skip()
	ENDDO
	//LogEvent(SELF,"determine clns:"+ElapTime(time1,Time()))	

	TrCnt:=0
	ASort(aPers)
	IF self:Frequency
		// determine frequency periods:
		repMes+="."
		self:STATUSMESSAGE(fMes+repMes)
		PerStart:=StartDate-360
		PerStart:=SToD(Str(Year(PerStart),4,0)+StrZero(Month(PerStart),2,0)+"01")
		PerEnd:=StartDate-1
		aFrequency_periods[2]:={PerStart,PerEnd}
		FrequencyEnd:=PerEnd
		PerEnd:=PerStart-1
		PerStart:=PerStart-360
		PerStart:=SToD(Str(Year(PerStart),4,0)+StrZero(Month(PerStart),2,0)+"01")
		aFrequency_periods[1]:={PerStart,PerEnd}
		// determine previous frequency periods:
		IF lDiff
			ASize(aFrequency_periods,4)
			AIns(aFrequency_periods,1)
			AIns(aFrequency_periods,1)
			PerStart:=aPeriod[1,1]-360
			PerStart:=SToD(Str(Year(PerStart),4,0)+StrZero(Month(PerStart),2,0)+"01")
			PerEnd:=aPeriod[1,1]-1
			aFrequency_periods[2]:={PerStart,PerEnd}
			PerEnd:=PerStart-1
			PerStart:=PerStart-360
			PerStart:=SToD(Str(Year(PerStart),4,0)+StrZero(Month(PerStart),2,0)+"01")
			aFrequency_periods[1]:={PerStart,PerEnd}	
		ENDIF
		FrequencyStart:=aFrequency_periods[1,1]
		// create and fill frequencies:
		aPersFreq:=AReplicate(1,Len(aPers))   // initialize as new givers
		IF lDiff
			aPersPrvFreq:=AReplicate(1,Len(aPers))    // initialize as new givers
		ENDIF
		oTransFreq:=TransHistory{Round(oTrans:OldestYear/100,0),oTrans:OldestYear%100,"MUT",DBREADONLY,Year(FrequencyEnd),Month(FrequencyEnd),aPers[1],"CLN>='"+aPers[Len(aPers)]+"'"}
		IF !oTransFreq:Used
			RETURN nil
		ENDIF
		lSuccess:=oTransFreq:SetFilter(,"!Empty(CLN).and.!GC=='PF'.and.!GC=='CH'.and.DTOS(DAT)>='"+DToS(FrequencyStart)+"'.and.DTOS(DAT)<='"+DToS(FrequencyEnd)+"'.and.CRE>DEB")
		pPtr:=0
		DO WHILE !oTransFreq:EoF
			IF prvCLN==oTransFreq:CLN
				IF Empty(pPtr)
					oTransFreq:Skip()
					loop
				ELSE
					IF oTransFreq:DAT<FrequencyStart
						oTransFreq:Skip()
						loop
					ENDIF
				ENDIF
			elseif AScanBinExact(aAcc,oTransFreq:REK)=0
				oTransFreq:Skip()
				loop
			ELSE
				pPtr:=0
				prvCLN:=oTransFreq:CLN
			ENDIF
			self:DetermineFrequency(oTransFreq,aPers,aFrequency_periods,aPersFreq,aPersPrvFreq,@pPtr)
			oTransFreq:Skip()
			TrCnt++
			IF TrCnt>600
				repMes+="."
				self:STATUSMESSAGE(fMes+"("+ElapTime(time1,Time())+")"+repMes)
				IF Len(repMes)>84
					repMes:=""
				ENDIF
				TrCnt:=0
			ENDIF
		ENDDO
		//LogEvent(SELF,"determine time:"+ElapTime(time1,Time()))	
	ENDIF
	repMes:="."
	self:STATUSMESSAGE(sMes+"("+ElapTime(time1,Time())+")"+repMes)
	// Determine Person classes:
	IF self:Age
		j:=0
		nRange:=Val(self:Ranges)
		nCSt:=Len(aClass)+1
		AAdd(aClass,{"BIRTHDAT","Age",0,0})  // unknown
		FOR i:=20 to 80 step nRange
			AAdd(aClass,{"BIRTHDAT","Age",j,i})
			j:=i
		NEXT
		AAdd(aClass,{"BIRTHDAT","Age",80,120}) //fieldname, name, range1, range2
		AAdd(aClassIndex,{"BIRTHDAT",nCSt,Len(aClass),1}) // add to overview
	ENDIF
	IF self:Gender
		nCSt:=Len(aClass)+1
		FOR i:=1 to Len(pers_gender)
			AAdd(aClass,{"GENDER","Gender",pers_gender[i,2],pers_gender[i,1]})  // fieldname, name, value, value name
		NEXT
		AAdd(aClassIndex,{"GENDER",nCSt,Len(aClass),0}) // add to overview
	ENDIF
	IF self:Type
		nCSt:=Len(aClass)+1
		FOR i:=1 to Len(pers_types)
			AAdd(aClass,{"TYPE","Type",pers_types[i,2],pers_types[i,1]})  // fieldname, name, value, value name
		NEXT	
		AAdd(aClassIndex,{"TYPE",nCSt,Len(aClass),0}) // add to overview
	ENDIF
	IF self:Frequency
		nCSt:=Len(aClass)+1
		FOR i:=1 to Len(Frequency_types)
			AAdd(aClass,{"FREQUENCY","Frequency",Frequency_types[i,2],Frequency_types[i,1]})  // fieldname, name, value, value name
		NEXT	
		AAdd(aClassIndex,{"FREQUENCY",nCSt,Len(aClass),2}) // add to overview
	ENDIF
	FOR i:=1 to Len(self:aPropEx)
		oCheck:=aPropEx[i]
		IF oCheck:Checked
			cName:=oCheck:HyperLabel:Caption
			nCSt:=Len(aClass)+1
			j:=AScan(pers_propextra,{|x|x[1]==cName})
			cName:=oCheck:HyperLabel:Description
			IF pers_propextra[j,3]==DROPDOWN
				aDropValues:=Split(pers_propextra[j,4],",")
				FOR k:=1 to Len(aDropValues)				
					AAdd(aClass,{cName,oCheck:Caption,aDropValues[k],aDropValues[k]}) /* fieldname, name, value, value name  */
				NEXT
				AAdd(aClassIndex,{cName,nCSt,Len(aClass),1+pers_propextra[j,3]}) /* add to overview   */
			ELSE
				IF pers_propextra[j,3]==CHECKBX
					AAdd(aClass,{cName,oCheck:Caption,true,"true"})
					AAdd(aClass,{cName,oCheck:Caption,FALSE,"false"})
					AAdd(aClassIndex,{cName,nCSt,Len(aClass),1+pers_propextra[j,4]})   /* add to overview */
				ENDIF
			ENDIF
			//AAdd(aClassIndex,{cName,nCSt,Len(aClass),1+pers_propextra[j,3]}) // add to overview
		ENDIF
	NEXT

	// Make all combinations of classes from overview in aValues with initializes values per period:
	maxlevel:=Len(aClassIndex)
	IF maxlevel<1
		// default class all
		AAdd(aClassIndex,{"ALL",1,1,0}) // add to overview 
		AAdd(aClass,{"ALL","All",0,"all"})
		maxlevel:=1
	ENDIF
	self:AddClass(aValues,"",1,maxlevel,aClassIndex)
	// Determine classes per person:
	aPersValuePtr:=AReplicate(0,Len(aPers))
	IF lDiff
		aPersValuePtrPrv:=AReplicate(0,Len(aPers))   // separate array for previous period
	ENDIF
	aPersExp:=ArrayCreate(Len(aPers))
	IF self:StatBox8
		IF .not.Empty(oSelPers:selx_kondp)
			pKondp := &("{||"+ oSelPers:selx_kondp+"}")
		ENDIF
	endif
	FOR k:=1 to Len(aPers)
		cSearch:=""
		cSep:=""
		if maxlevel>1  .or.!aClassIndex[1,1]=="ALL".or.self:StatBox8
			IF !oPers:Seek(aPers[k])
				aPersExp[k]:={"",0,false}
				loop
			ENDIF
		endif
		IF self:StatBox8 
			aPersExp[k]:={oPers:POS,oPers:RecNo,(oPers:Eval(pKondp,,,1).and.oSelPers:EvalExtraProp(oPers))}
		ENDIF
		nClassPtr2:=0
		nClassPtr1:=0
		FOR i:=1 to maxlevel
			cName:=aClassIndex[i,1]
			nCount:=aClassIndex[i,3]+1-aClassIndex[i,2]
			fType:=aClassIndex[i,4]
			IF ftype=3 .or. ftype=4
				oXMLDoc:=XMLDocument{oPers:PROPEXTR}
				IF oXMLDoc:GetElement(cName)
					uFieldValue:=oXMLDoc:GetContentCurrentElement()
				ELSE
					IF fType=4
						uFieldValue:=FALSE
					ELSE
						uFieldValue:=null_string
					ENDIF
				ENDIF
			ELSEIF ftype=2
				nFreq:=aPersFreq[k]
				nClassPtr2:=AScan(aClass,{|x| nFreq==x[3]},aClassIndex[i,2],nCount)
				IF lDiff
					nFreq:=aPersPrvFreq[k]
					nClassPtr1:=AScan(aClass,{|x| nFreq==x[3]},aClassIndex[i,2],nCount)
				ENDIF
			ELSEIF !cName=="ALL"
				uFieldValue:=oPers:FIELDGET(cName)
			ENDIF
			IF cName=="BIRTHDAT"
				// convert birthdate to age:
				IF Empty(uFieldValue)
					nAge:=0
					nClassPtr:=aClassIndex[i,2]
				ELSE
					nAge:=(Integer(Year(Today())*12+Month(Today()) - Year(uFieldValue)*12*Month(uFieldValue)+ iif(Day(Today())<Day(uFieldValue),-1,0))/12)
					// search nAge in aClass:
					nClassPtr:=AScan(aClass,{|x|nAge>=x[3] .and.nAge<x[4]},aClassIndex[i,2],nCount)
				ENDIF
			ELSEIF cName=="ALL"
				nClassPtr:=1
			ELSEIF ftype#2
				// search value in aClass:
				nClassPtr:=AScan(aClass,{|x| uFieldValue==x[3]},aClassIndex[i,2],nCount)
			ENDIF
			IF ftype=2
				cSearch+=cSep+"%FR%"
			ELSE		
				cSearch+=cSep+AllTrim(Str(nClassPtr))
			ENDIF
			cSep:=","
		NEXT
		IF !Empty(cSearch)
			IF !Empty(nClassPtr2)
				cSearchOrg:=cSearch
				cSearch:=StrTran(cSearch,"%FR%",AllTrim(Str(nClassPtr2)))
			ENDIF
			nValuePtr:=AScan(aValues,{|x|x[1]==cSearch})
			aPersValuePtr[k]:=nValuePtr
			IF lDiff
				IF !Empty(nClassPtr1)
					cSearch:=StrTran(cSearchOrg,"%FR%",AllTrim(Str(nClassPtr1)))
					nValuePtr:=AScan(aValues,{|x|x[1]==cSearch})
				ENDIF
				aPersValuePtrPrv[k]:=nValuePtr
			ENDIF
		ENDIF
		TrCnt++
		IF TrCnt>400
			repMes+="."
			self:Statusmessage(pMes+"("+ElapTime(time1,Time())+")"+repMes)
			IF Len(repMes)>80
				repMes:=""
			ENDIF
			TrCnt:=0
		ENDIF	
	NEXT
	repMes:="."
	self:Statusmessage(sMes+"("+ElapTime(time1,Time())+")"+repMes)
	TrCnt:=1
	
	// Collect values per subperiod and class:
	oTrans:GoTop()

	DO WHILE !oTrans:EoF
		// Determine corresponding combination of classes:
		cSearch:=""
		cSep:=""
		// determine subperiod:
		dTransDat:=oTrans:DAT
		nSubPeriod:=AScan(aPeriod,{|x| dTransDat >= x[1] .and. dTransDat <= x[2]})
		IF nSubPeriod>0
			// in required period:		
			// determine search string to search classes
			IF Empty(oTrans:CLN) .or.AScanBinExact(aAcc,oTrans:REK)=0
				oTrans:Skip()
				loop
			endif
			pPtr:=AScanBinExact(aPers,oTrans:cln)
			IF pPtr==0
				oTrans:Skip()
				loop
			ENDIF
			IF nSubPeriod<=PrevPeriodCount
				nValuePtr:=aPersValuePtrPrv[pPtr]
			ELSE
				nValuePtr:=aPersValuePtr[pPtr]
			ENDIF
			IF nValuePtr>0
				IF nValuePtr=1 .and. nSubPeriod=1
					nSubPeriod:=nSubPeriod
				ENDIF
				IF Len(aValues[nValuePtr])=1
					// first value for combination:
					AAdd(aValues[nValuePtr],ArrayNew(Len(aPeriod)))
				ENDIF
				IF Empty(aValues[nValuePtr,2,nSubPeriod])
					// first value in subperiod:
					aValues[nValuePtr,2][nSubPeriod]:={{oTrans:CLN,oTrans:CRE-oTrans:DEB}}
				ELSE
					// search if allready gift of person recorded in sub period:
					nPersPtr:=AScan(aValues[nValuePtr,2][nSubPeriod],{|x|x[1]==oTrans:Cln})
					IF nPersPtr=0
						AAdd(aValues[nValuePtr,2][nSubPeriod],{oTrans:CLN,oTrans:CRE-oTrans:DEB})
					ELSE
						aValues[nValuePtr,2][nSubPeriod][nPersPtr][2]+=oTrans:CRE-oTrans:DEB
					ENDIF					
					//	ENDIF
				ENDIF
			ENDIF	
		ENDIF
		oTrans:Skip()
		TrCnt++
		IF TrCnt>200
			repMes+="."
			self:Statusmessage(sMes+"("+ElapTime(time1,Time())+")"+repMes)
			IF Len(repMes)>80
				repMes:=""
			ENDIF
			TrCnt:=0
		ENDIF

	ENDDO
	// compress empty lines:
	FOR i:=Len(aValues) to 1 step -1
		IF Len(aValues[i])=1
			ADel(aValues,i)
			ASize(aValues,Len(aValues)-1)
		ENDIF		
	NEXT

	// percentage of total number of givers a certain class of givers has contributed
	aMatrix1:=ArrayNew(Len(aPeriod)+1,Len(aValues)+1)// col,rows
	aMatrix2:=ArrayNew(Len(aPeriod)+1,Len(aValues)+1)// col,rows
	aMatrix3:=ArrayNew(Len(aPeriod)+1,Len(aValues)+1)// col,rows
	aMatrix4:=ArrayNew(Len(aPeriod)+1,Len(aValues)+1)// col,rows
	aMatrix5:=ArrayNew(Len(aPeriod)+1,Len(aValues)+1)// col,rows
	aMatrix6:=ArrayNew(Len(aPeriod)+1,Len(aValues)+1)// col,rows
	aMatrix7:=ArrayNew(Len(aPeriod)+1,Len(aValues)+2)// col,rows
	FOR i:=1 to Len(aValues)
		aClassPtr:=Split(aValues[i,1],",")
		cClassName:=""
		FOR j:=1 to Len(aClassPtr)
			k:=Val(aClassPtr[j])
			IF aClass[k,1]="BIRTHDAT"
				IF aClass[k,3]=0
					cClassName+=oLan:Get(aClass[k,2])+" is unknown "
				ELSE
					cClassName+=oLan:Get(aClass[k,2])+"="+AllTrim(Str(aClass[k,3]))+" - "+AllTrim(Str(aClass[k,4]))+" "
				ENDIF
			ELSEIF aClass[k,1]="TYPE" .or. aClass[k,1]="GENDER" .or. aClass[k,1]="FREQUENCY"
				cClassName+=oLan:Get(aClass[k,4])+" "
			ELSE
				cClassName+=oLan:Get(aClass[k,2])+"="+oLan:Get(aClass[k,4])+" "
			ENDIF
		NEXT
		aMatrix1[1,i+1]:=cClassName
		aMatrix2[1,i+1]:=cClassName
		aMatrix3[1,i+1]:=cClassName
		aMatrix4[1,i+1]:=cClassName
		aMatrix5[1,i+1]:=cClassName
		aMatrix6[1,i+1]:=cClassName
		aMatrix7[1,i+2]:=cClassName
	NEXT
	FOR i:=1 to Len(aPeriod)
		aMatrix1[i+1,1]:=DToC(aPeriod[i,1])+" - "+DToC(aPeriod[i,2])
		aMatrix2[i+1,1]:=DToC(aPeriod[i,1])+" - "+DToC(aPeriod[i,2])
		aMatrix3[i+1,1]:=DToC(aPeriod[i,1])+" - "+DToC(aPeriod[i,2])
		aMatrix4[i+1,1]:=DToC(aPeriod[i,1])+" - "+DToC(aPeriod[i,2])
		aMatrix5[i+1,1]:=DToC(aPeriod[i,1])+" - "+DToC(aPeriod[i,2])
		aMatrix6[i+1,1]:=DToC(aPeriod[i,1])+" - "+DToC(aPeriod[i,2])
		aMatrix7[i+1,1]:=DToC(aPeriod[i,1])+" - "+DToC(aPeriod[i,2])
	NEXT
	// determine subtotals per period:
	PerTotal:=AReplicate(0.00,Len(aPeriod))
	PerCount:=AReplicate(0,Len(aPeriod))
	FOR i:=1 to Len(aPeriod)
		maxVal:=-9999999.00
		FOR j:=1 to Len(aValues)
			SubTotal:=0
			nCount:=0
			IF !Empty(aValues[j,2,i])
				FOR m:=1 to Len(aValues[j,2,i])
					SubTotal+=aValues[j,2,i,m,2]
					maxVal:=Max(maxVal,aValues[j,2,i,m,2])
				NEXT
				nCount:=Len(aValues[j,2,i])
				PerCount[i]+=nCount		
				PerTotal[i]+=SubTotal
			ENDIF
			aMatrix3[i+1,j+1]:=nCount
			aMatrix1[i+1,j+1]:=SubTotal
		NEXT
		// determine ranges from average per period:
		IF i>PrevPeriodCount.and.PerCount[i]>0
			rangeVal:=Round(((PerTotal[i])/(NumberRanges*PerCount[i])),0)
			IF rangeVal >0
				aMatrix7[i+1,2]:=ArrayNew(NumberRanges)
				FOR m:=1 to self:NumberRanges-1
					aMatrix7[i+1,2,m]:=Round(m*rangeVal,0)
				NEXT
				aMatrix7[i+1,2,NumberRanges]:=maxVal
			ENDIF			
		ENDIF
	NEXT
	repMes+="."
	self:Statusmessage(sMes+"("+ElapTime(time1,Time())+")"+repMes)
	IF Len(repMes)>80
		repMes:=""
	ENDIF
	TrCnt:=0
	
	// Fill	Matrices:
	i:=i
	FOR i:=1 to Len(aPeriod)
		FOR j:=1 to Len(aValues)
			IF PerTotal[i]>0
				aMatrix2[i+1,j+1]:=Round((aMatrix1[i+1,j+1]*100)/PerTotal[i],2)
			ENDIF
			IF PerCount[i]>0
				aMatrix4[i+1,j+1]:=Round((aMatrix3[i+1,j+1]*100)/PerCount[i],2)
			ENDIF
			IF aMatrix3[i+1,j+1]>0
				aMatrix5[i+1,j+1]:=Round(aMatrix1[i+1,j+1]/aMatrix3[i+1,j+1],2)
			ENDIF
			IF StatBox7 .and.i>PrevPeriodCount
				aMatrix7[i+1,j+2]:=AReplicate(0,NumberRanges)
				IF !Empty(aValues[j,2,i])
					FOR m:=1 to Len(aValues[j,2,i])
						k:=AScan(aMatrix7[i+1,2],{|x|aValues[j,2,i,m,2]<=x})
						IF k>0
							aMatrix7[i+1,j+2,k]++
						ENDIF
					NEXT
				ENDIF
			ENDIF
			TrCnt++
			IF TrCnt>200
				repMes+="."
				self:Statusmessage(sMes+"("+ElapTime(time1,Time())+")"+repMes)
				IF Len(repMes)>80
					repMes:=""
				ENDIF
				TrCnt:=0
			ENDIF
		NEXT
	NEXT
	IF StatBox6
		// Median calculation:
		// Sort each aValue per period:
		FOR i:=1 to Len(aPeriod)
			FOR j:=1 to Len(aValues)
				IF !Empty(aValues[j,2,i])
					ASort(aValues[j,2,i],,,{|x,y| x[2]<=y[2]})
					median1:=Len(aValues[j,2,i])
					median2:=Max(Round(median1/2.0,0),1)
					IF median1%2=1
						// odd:
						aMatrix6[i+1,j+1]:=aValues[j,2,i,median2,2]
					ELSE
						aMatrix6[i+1,j+1]:=Round((aValues[j,2,i,median2,2]+aValues[j,2,i,median2+1,2])/2,2)
					ENDIF
				ENDIF
			NEXT
			repMes+="."
			self:Statusmessage(sMes+"("+ElapTime(time1,Time())+")"+repMes)
			IF Len(repMes)>80
				repMes:=""
			ENDIF
		NEXT
	ENDIF
	IF self:StatBox8
		// let user select required classes to export:
		FOR i:=1 to Len(aValues)   // classes
			nCount:=0 
			FOR j:=1 to Len(aPeriod)
				nCount+=aMatrix3[j+1,i+1]
			NEXT
			AAdd(aExportClass,{aMatrix3[1,i+1]+"("+Str(nCount,-1)+" persons)",i})
		NEXT
		(DonorFolwngSelClasses{self,{self,aExportClass}}):show()
		// make export files:
		FOR m:=1 to Len(self:aSelectedClasses)
			i:=self:aSelectedClasses[m]
			oSelPers:aNN:={}
			FOR j:=1 to Len(aValues[i,2])    //periods 
				IF !IsNil(aValues[i,2][j])
					FOR k:=1 to Len(aValues[i,2][j])  //persons
						nPersPtr:=AScan(aPers,aValues[i,2][j][k,1])
						IF nPersPtr>0
							IF !IsNil(aPersExp[nPersPtr]) .and. aPersExp[nPersPtr,3]
								IF AScan(oSelPers:aNN,{|x|x[2]=aPersExp[nPersPtr,2]})==0
									AAdd(oSelPers:aNN,{aPersExp[nPersPtr,1],aPersExp[nPersPtr,2]})
								ENDIF
							ENDIF
						ENDIF					
					NEXT
				ENDIF
			NEXT
			cClassName:=aMatrix1[1,i+1]
			IF Len(oSelPers:aNN)>0
				oSelPers:PrintToOutput(aTitle," - "+cClassName)
			ENDIF
		NEXT
	ENDIF


	// markup report from matrix:
	// oFileSpec:=FileSpec{CurPath + "\DonorFollowing"+DToS(StartDate)+"_"+DToS(ENDDate)+'.XLS'}
	oFileSpec:=AskFileName(self,"DonorFollowing"+DToS(StartDate)+"_"+DToS(EndDate),"Creating Donor Following-report",'*.XLS',"Excel Spreadsheet") 
	IF oFileSpec==null_object
		return
	ENDIF
	cFileName:=oFileSpec:FullPath
	ptrHandle := MakeFile(self,@cFileName,"Creating DonorFollowing-report")

	IF !ptrHandle = F_ERROR .and. !ptrHandle==nil
		oFileSpec:FullPath:=cFileName
		* header record:
		FWriteLine(ptrHandle,"<html><body><table style='font-family: Arial;' border='2'><tr style='font-weight: bold; color:navy;'>"+;
			"<td style='text-align : center;' colspan='"+Str(Len(aPeriod)-PrevPeriodCount+1,-1)+"'>"+oLan:Get("Donor Following Report")+"  "+;
			oLan:Get("period")+": "+DToC(StartDate)+" - "+DToC(ENDDate)+"</td></tr>")
		FWriteLine(ptrHandle,"<tr><td colspan='"+Str(Len(aPeriod)-PrevPeriodCount+1,-1)+"'>"+oLan:Get("Destinations")+":<br><ol>")
		FOR i:=1 to Len(aAcc)
			IF oAcc:Seek(aAcc[i])
				FWriteLine(ptrHandle,"<li>"+AllTrim(oAcc:OMS)+"</li>")
			ENDIF
		NEXT
		FWriteLine(ptrHandle,"</ol></td></tr>")
		IF StatBox1
			self:MarkupMatrix(ptrHandle,aMatrix1,"amount given per class of givers",PrevPeriodCount,Len(aPeriod)+1,Len(aValues)+1)
		ENDIF
		IF StatBox2
			self:MarkupMatrix(ptrHandle,aMatrix2,"percentage of total amount given, a certain class of givers has contributed",PrevPeriodCount,Len(aPeriod)+1,Len(aValues)+1)
		ENDIF
		IF StatBox3
			self:MarkupMatrix(ptrHandle,aMatrix3,"number of givers per class of givers",PrevPeriodCount,Len(aPeriod)+1,Len(aValues)+1)
		ENDIF
		IF StatBox4
			self:MarkupMatrix(ptrHandle,aMatrix4,"percentage of total number of givers, a certain class of givers has contributed",PrevPeriodCount,Len(aPeriod)+1,Len(aValues)+1)
		ENDIF
		IF StatBox5
			self:MarkupMatrix(ptrHandle,aMatrix5,"average amount given per class of givers",PrevPeriodCount,Len(aPeriod)+1,Len(aValues)+1)
		ENDIF
		IF StatBox6
			self:MarkupMatrix(ptrHandle,aMatrix6,"median amount given per class of givers",PrevPeriodCount,Len(aPeriod)+1,Len(aValues)+1)
		ENDIF
		IF StatBox7
			self:MarkupMatrix(ptrHandle,aMatrix7,"spread over ranges of amounts given per class of givers ",PrevPeriodCount,Len(aPeriod)+1,Len(aValues)+2)
		ENDIF
		* closing record:
		FWriteLine(ptrHandle,"<table></body></html>")
		FClose(ptrHandle)
		repMes+="."
		self:Statusmessage(sMes+"("+ElapTime(time1,Time())+")"+repMes)
		self:Pointer := Pointer{POINTERARROW}
		// show with excel:
		j:=	myApp:Run(EXCEL+'"'+oFileSpec:FullPath+'"')

		IF j=2
			(errorbox{self,"Excel not found in:"+EXCEL+"; could not open report file "+oFileSpec:FullPath}):Show()
		ENDIF
	ENDIF
	//LogEvent(SELF,"total time:"+ElapTime(time1,Time()))	

	oAcc:Close()
	oAcc:=null_object
	oTrans:Close()
	oTrans:=null_object
	IF !Empty(oTransFreq )
		IF oTransFreq:Used
			oTransFreq:Close()
			oTransFreq:=null_object
		ENDIF
	ENDIF
	oPers:Close()
	oPers:=null_object


	RETURN nil
ACCESS ProjectsBox() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#ProjectsBox)

ASSIGN ProjectsBox(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#ProjectsBox, uValue)
RETURN uValue

ACCESS Ranges() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#Ranges)

ASSIGN Ranges(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#Ranges, uValue)
RETURN uValue

METHOD RegAccount(omAcc,ItemName) CLASS DonorFollowingReport
	LOCAL oAccount AS Account
	IF Empty(omAcc).or.omAcc==NULL_OBJECT
		RETURN
	ENDIF
	oAccount:=omAcc
	IF ItemName == "From Account"
		SELF:FromAccount:= LTrimZero(oAccount:AccNumber)
		SELF:oDCFromAccount:TEXTValue := FromAccount
		SELF:cFromAccName := FromAccount
		self:oDCTextfrom:Caption := AllTrim(oAccount:Description)
		SELF:oDCSubSet:AccNbrStart:=SELF:FromAccount
	ELSEIF ItemName == "Till Account"
		SELF:ToAccount:= LTrimZero(oAccount:ACCNUMBER)
		SELF:oDCToAccount:TEXTValue := ToAccount
		SELF:cToAccName := ToAccount
		self:oDCTextTill:Caption := AllTrim(oAccount:Description)
		SELF:oDCSubSet:AccNbrEnd:=ToAccount
	ENDIF
		
RETURN TRUE
METHOD SetPropExtra( Count) CLASS DonorFollowingReport
	LOCAL oCheck AS CheckBox
	LOCAL oDCGroupBoxExtra	AS GroupBox
	LOCAL Name AS STRING,Type, ID AS INT, Values AS STRING
	LOCAL myDim AS Dimension
	LOCAL myOrg AS Point
	LOCAL aValues AS ARRAY
	LOCAL NewY:=SELF:oDCFrequency:Origin:Y AS INT
	IF pers_propextra[Count,3]==TEXTBX
		// skip textboxes
		RETURN
	ENDIF
	Name:=pers_propextra[Count,1]
	ID := pers_propextra[Count,2]
	//
	// enlarge window
	myDim:=SELF:Size
	myDim:Height+=25
	SELF:Size:=myDim
	myOrg:=SELF:Origin
	myOrg:y-=25
	SELF:Origin:=myOrg
	//
	// shift statistical group down
	myOrg:=SELF:oDCStatisticsBox:Origin
	myOrg:y-=25
	SELF:oDCStatisticsBox:Origin:=myOrg
	myOrg:=SELF:oDCStatBox1:Origin
	myOrg:y-=25
	SELF:oDCStatBox1:Origin:=myOrg
	myOrg:=SELF:oDCStatBox2:Origin
	myOrg:y-=25
	SELF:oDCStatBox2:Origin:=myOrg
	myOrg:=SELF:oDCStatBox3:Origin
	myOrg:y-=25
	SELF:oDCStatBox3:Origin:=myOrg
	myOrg:=SELF:oDCStatBox4:Origin
	myOrg:y-=25
	SELF:oDCStatBox4:Origin:=myOrg
	myOrg:=SELF:oDCStatBox5:Origin
	myOrg:y-=25
	SELF:oDCStatBox5:Origin:=myOrg
	myOrg:=SELF:oDCStatBox6:Origin
	myOrg:y-=25
	SELF:oDCStatBox6:Origin:=myOrg
	myOrg:=SELF:oDCStatBox7:Origin
	myOrg:y-=25
	SELF:oDCStatBox7:Origin:=myOrg
	myOrg:=SELF:oDCNumberRanges:Origin
	myOrg:y-=25
	SELF:oDCNumberRanges:Origin:=myOrg
	myOrg:=SELF:oDCFixedTextRanges:Origin
	myOrg:y-=25
	SELF:oDCFixedTextRanges:Origin:=myOrg
	myOrg:=self:oDCStatBox8:Origin
	myOrg:Y-=25
	self:oDCStatBox8:Origin:=myOrg
	myOrg:=self:oDCDiffBox:Origin
	myOrg:y-=25
	SELF:oDCDiffBox:Origin:=myOrg
	
	// enlarge PropertiesBox group:
	myDim:=SELF:oDCPropertiesBox:Size
	myDim:Height+=25
	SELF:oDCPropertiesBox:Size:=myDim
	myOrg:=SELF:oDCPropertiesBox:Origin
	myOrg:y-=25
	SELF:oDCPropertiesBox:Origin:=myOrg
	//
//	insert extra properties as checkboxes in group PropertiesBox:	
	oCheck:=CheckBox{SELF,Count,Point{29,NewY},Dimension{215,20},Name}
	oCheck:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name,"V"+AllTrim(Str(ID,-1))}
	AAdd(self:aPropEx,oCheck)
	oCheck:Show()
RETURN NIL
	
		


ACCESS StatBox1() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#StatBox1)

ASSIGN StatBox1(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#StatBox1, uValue)
RETURN uValue

ACCESS StatBox2() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#StatBox2)

ASSIGN StatBox2(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#StatBox2, uValue)
RETURN uValue

ACCESS StatBox3() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#StatBox3)

ASSIGN StatBox3(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#StatBox3, uValue)
RETURN uValue

ACCESS StatBox4() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#StatBox4)

ASSIGN StatBox4(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#StatBox4, uValue)
RETURN uValue

ACCESS StatBox5() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#StatBox5)

ASSIGN StatBox5(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#StatBox5, uValue)
RETURN uValue

ACCESS StatBox6() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#StatBox6)

ASSIGN StatBox6(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#StatBox6, uValue)
RETURN uValue

ACCESS StatBox7() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#StatBox7)

ASSIGN StatBox7(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#StatBox7, uValue)
RETURN uValue

ACCESS StatBox8() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#StatBox8)

ASSIGN StatBox8(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#StatBox8, uValue)
RETURN uValue

ACCESS SubPerLen() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#SubPerLen)

ASSIGN SubPerLen(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#SubPerLen, uValue)
RETURN uValue

ACCESS SubSet() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#SubSet)

ASSIGN SubSet(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#SubSet, uValue)
RETURN uValue

METHOD ToAccButton(lUnique ) CLASS DonorFollowingReport
	Default(@lUnique,FALSE)
	AccountSelect(SELF,AllTrim(oDCToAccount:TEXTValue ),"Till Account",lUnique,"GiftAlwd",,)

ACCESS ToAccount() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#ToAccount)

ASSIGN ToAccount(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#ToAccount, uValue)
RETURN uValue

ACCESS Type() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#Type)

ASSIGN Type(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#Type, uValue)
RETURN uValue

STATIC DEFINE DONORFOLLOWINGREPORT_AGE := 111 
STATIC DEFINE DONORFOLLOWINGREPORT_CANCELBUTTON := 136 
STATIC DEFINE DONORFOLLOWINGREPORT_DIFFBOX := 137 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT1 := 129 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT10 := 144 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT2 := 107 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT3 := 130 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT6 := 140 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT7 := 133 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT8 := 141 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT9 := 143 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXTRANGES := 127 
STATIC DEFINE DONORFOLLOWINGREPORT_FREQUENCY := 115 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMACCBUTTON := 104 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMACCOUNT := 103 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMDATE := 138 
STATIC DEFINE DONORFOLLOWINGREPORT_GENDER := 110 
STATIC DEFINE DONORFOLLOWINGREPORT_GROUPBOX1 := 128 
STATIC DEFINE DONORFOLLOWINGREPORT_GROUPBOX3 := 142 
STATIC DEFINE DONORFOLLOWINGREPORT_HOMEBOX := 101 
STATIC DEFINE DONORFOLLOWINGREPORT_NONHOMEBOX := 102 
STATIC DEFINE DONORFOLLOWINGREPORT_NUMBERRANGES := 126 
STATIC DEFINE DONORFOLLOWINGREPORT_OKBUTTON := 134 
STATIC DEFINE DONORFOLLOWINGREPORT_PROJECTSBOX := 100 
STATIC DEFINE DONORFOLLOWINGREPORT_PROPERTIESBOX := 109 
STATIC DEFINE DONORFOLLOWINGREPORT_RANGE10 := 112 
STATIC DEFINE DONORFOLLOWINGREPORT_RANGE20 := 113 
STATIC DEFINE DONORFOLLOWINGREPORT_RANGES := 116 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX1 := 118 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX2 := 119 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX3 := 120 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX4 := 121 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX5 := 122 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX6 := 123 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX7 := 124 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX8 := 125 
STATIC DEFINE DONORFOLLOWINGREPORT_STATISTICSBOX := 117 
STATIC DEFINE DONORFOLLOWINGREPORT_SUBPERLEN := 108 
STATIC DEFINE DONORFOLLOWINGREPORT_SUBSET := 135 
STATIC DEFINE DONORFOLLOWINGREPORT_TEXTFROM := 131 
STATIC DEFINE DONORFOLLOWINGREPORT_TEXTTILL := 132 
STATIC DEFINE DONORFOLLOWINGREPORT_TOACCBUTTON := 106 
STATIC DEFINE DONORFOLLOWINGREPORT_TOACCOUNT := 105 
STATIC DEFINE DONORFOLLOWINGREPORT_TODATE := 139 
STATIC DEFINE DONORFOLLOWINGREPORT_TYPE := 114 
CLASS DonorFolwngSelClasses INHERIT DialogWinDowExtra 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCClassesBox AS LISTBOX
	PROTECT oCCOKButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  Protect oCaller as Object
RESOURCE DonorFolwngSelClasses DIALOGEX  5, 20, 271, 125
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Donor following Report - export classes of persons"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Select one or more classes of persons to be exported", DONORFOLWNGSELCLASSES_FIXEDTEXT1, "Static", WS_CHILD, 4, 7, 200, 12
	CONTROL	"", DONORFOLWNGSELCLASSES_CLASSESBOX, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 4, 22, 204, 96, WS_EX_CLIENTEDGE
	CONTROL	"OK", DONORFOLWNGSELCLASSES_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 212, 22, 55, 11
END

METHOD Init(oParent,uExtra) CLASS DonorFolwngSelClasses 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"DonorFolwngSelClasses",_GetInst()},TRUE)

aFonts[1] := Font{,9,"Microsoft Sans Serif"}

oDCFixedText1 := FixedText{SELF,ResourceID{DONORFOLWNGSELCLASSES_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Select one or more classes of persons to be exported",NULL_STRING,NULL_STRING}
oDCFixedText1:Font(aFonts[1], FALSE)

oDCClassesBox := ListBox{SELF,ResourceID{DONORFOLWNGSELCLASSES_CLASSESBOX,_GetInst()}}
oDCClassesBox:HyperLabel := HyperLabel{#ClassesBox,NULL_STRING,"Click on a row to (de)select",NULL_STRING}
oDCClassesBox:UseHLforToolTip := True

oCCOKButton := PushButton{SELF,ResourceID{DONORFOLWNGSELCLASSES_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

SELF:Caption := "Donor following Report - export classes of persons"
SELF:HyperLabel := HyperLabel{#DonorFolwngSelClasses,"Donor following Report - export classes of persons",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS DonorFolwngSelClasses
LOCAL NpOS as int
oCaller:aSelectedClasses:={}
NpOS:=oDCClassesBox:FirstSelected()
do WHILE NpOS>0
	aadd(oCaller:aSelectedClasses,oDCClassesBox:GetItemValue(nPos))
	NpOS:=oDCClassesBox:NextSelected()
ENDDO
self:EndDialog() 

RETURN NIL
method PostInit(oParent,uExtra) class DonorFolwngSelClasses
	//Put your PostInit additions here 
	// fill selectbox:
	self:SetTexts()
	if IsArray(uExtra)
		oCaller:=uExtra[1]
		oDCClassesBox:FillUsing(uExtra[2])
	endif
	return NIL

STATIC DEFINE DONORFOLWNGSELCLASSES_CLASSESBOX := 101 
STATIC DEFINE DONORFOLWNGSELCLASSES_FIXEDTEXT1 := 100 
STATIC DEFINE DONORFOLWNGSELCLASSES_OKBUTTON := 102 
CLASS DonorProject INHERIT DataWindowExtra 

	EXPORT oDCFromdate AS DATESTANDARD
	EXPORT oDCTodate AS DATESTANDARD
	EXPORT oDCDestinations AS GROUPBOX
	EXPORT oDCFixedText3 AS FIXEDTEXT
	EXPORT oCCOKButton AS PUSHBUTTON
	EXPORT oCCCancelButton AS PUSHBUTTON
	EXPORT oDCFixedText6 AS FIXEDTEXT
	EXPORT oDCFixedText7 AS FIXEDTEXT
	EXPORT oDCFixedText5 AS FIXEDTEXT

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	PROTECT aDestGrp:={} as ARRAY // {name,{acc1,acc2,...}
	PROTECT aGiftAcc:={} as ARRAY // accountIds+name for projects ( non-member accounts with gift allowed and home member entities)
	PROTECT aGiftAccHomeMbr:={} as ARRAY // accountIds+name for home members (non entity)
	PROTECT aGiftAccForeignMbr:={} as ARRAY // accountIds+name for non home members
	PROTECT aDestAccSet:={} as ARRAY // array with listbox controls
	PROTECT aDestName:={} as ARRAY // array with singlelineedit controls
	PROTECT nID as int
	PROTECT pwvs as WindowVerticalScrollBar     

RESOURCE DonorProject DIALOGEX  34, 31, 442, 1308
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"woensdag 24 november 2010", DONORPROJECT_FROMDATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 48, 21, 120, 14
	CONTROL	"woensdag 24 november 2010", DONORPROJECT_TODATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 194, 21, 120, 14
	CONTROL	"Compose groups of projects", DONORPROJECT_DESTINATIONS, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 7, 40, 417, 24, WS_EX_TRANSPARENT
	CONTROL	"Click to (de)select corresponding accounts:", DONORPROJECT_FIXEDTEXT3, "Static", WS_CHILD, 200, 48, 165, 12
	CONTROL	"OK", DONORPROJECT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 380, 7, 53, 12
	CONTROL	"Cancel", DONORPROJECT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 380, 22, 53, 12
	CONTROL	"From Date:", DONORPROJECT_FIXEDTEXT6, "Static", WS_CHILD, 7, 21, 38, 12
	CONTROL	"Till:", DONORPROJECT_FIXEDTEXT7, "Static", WS_CHILD, 175, 21, 16, 12
	CONTROL	"Give insight who has given to which destination during a certain period of time", DONORPROJECT_FIXEDTEXT5, "Static", WS_CHILD, 8, 6, 361, 13
END

METHOD CancelButton( ) CLASS DonorProject
	SELF:EndWindow()
	RETURN NIL
METHOD Close(oEvent) CLASS DonorProject
	SUPER:Close(oEvent)
	//Put your changes here
	SELF:EndWindow()
	RETURN NIL

METHOD DeselectAccount(nCur,nPos) CLASS DonorProject
	// remove deselected account form group
	LOCAL myDim AS Dimension
	LOCAL myOrg AS Point
	LOCAL i AS INT
	LOCAL oControl AS Control
	// remove from own accounts:
	ADel(SELF:aDestGrp[nCur,2],nPos)
	ASize(SELF:aDestGrp[nCur,2],Len(SELF:aDestGrp[nCur,2])-1)
	IF nCur>3 .and.Len(SELF:aDestGrp[nCur,2])=0
	// empty group, remove it:
		ADel(SELF:aDestGrp,nCur)
		ASize(SELF:aDestGrp,Len(SELF:aDestGrp)-1)
		(SELF:aDestName[nCur-2]):Destroy()
		(SELF:aDestAccSet[nCur-2]):Destroy()
		ADel(SELF:aDestName,nCur-2)
		ASize(SELF:aDestName,Len(SELF:aDestName)-1)
		ADel(SELF:aDestAccSet,nCur-2)
		ASize(SELF:aDestAccSet,Len(SELF:aDestAccSet)-1)
		// shift groups below up
		FOR i:=nCur-2 TO Len(SELF:aDestAccSet)
			oControl:=SELF:aDestAccSet[i]
			myOrg:=oControl:Origin
			myOrg:y+=115
			oControl:Origin:=myOrg
			oControl:=SELF:aDestName[i]
			myOrg:=oControl:Origin
			myOrg:y+=115
			oControl:Origin:=myOrg
		NEXT
		// shortens groupbox
		myDim:=SELF:oDCDestinations:Size
		myDim:Height-=115
		SELF:oDCDestinations:Size:=myDim
		myOrg:=SELF:oDCDestinations:Origin
		myOrg:y+=115
		SELF:oDCDestinations:Origin:=myOrg	
		// shortens window
		myDim:=SELF:Size
		myDim:Height-=115
		SELF:Size:=myDim
		myOrg:=SELF:Origin
		myOrg:y+=115
		SELF:Origin:=myOrg		
		nCur:=0
	ENDIF						
	

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS DonorProject 
LOCAL DIM aFonts[2] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"DonorProject",_GetInst()},iCtlID)

aFonts[1] := Font{,8,"Microsoft Sans Serif"}
aFonts[1]:Bold := TRUE
aFonts[2] := Font{,10,"Microsoft Sans Serif"}
aFonts[2]:Bold := TRUE

oDCFromdate := DateStandard{SELF,ResourceID{DONORPROJECT_FROMDATE,_GetInst()},Point{73, 2070},Dimension{180, 22}}
oDCFromdate:FieldSpec := Transaction_DAT{}
oDCFromdate:HyperLabel := HyperLabel{#Fromdate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCTodate := DateStandard{SELF,ResourceID{DONORPROJECT_TODATE,_GetInst()},Point{292, 2070},Dimension{180, 22}}
oDCTodate:FieldSpec := Transaction_DAT{}
oDCTodate:HyperLabel := HyperLabel{#Todate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCDestinations := GroupBox{SELF,ResourceID{DONORPROJECT_DESTINATIONS,_GetInst()},Point{12, 2022},Dimension{625, 40}}
oDCDestinations:HyperLabel := HyperLabel{#Destinations,"Compose groups of projects",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{DONORPROJECT_FIXEDTEXT3,_GetInst()},Point{301, 2029},Dimension{248, 20}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Click to (de)select corresponding accounts:",NULL_STRING,NULL_STRING}
oDCFixedText3:Font(aFonts[1], FALSE)
oDCFixedText3:TextColor := Color{128,64,64}

oCCOKButton := PushButton{SELF,ResourceID{DONORPROJECT_OKBUTTON,_GetInst()},Point{571, 2095},Dimension{80, 20}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}
oCCOKButton:UseHLforToolTip := False
oCCOKButton:OwnerAlignment := OA_PX

oCCCancelButton := PushButton{SELF,ResourceID{DONORPROJECT_CANCELBUTTON,_GetInst()},Point{571, 2071},Dimension{80, 20}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}
oCCCancelButton:OwnerAlignment := OA_PX

oDCFixedText6 := FixedText{SELF,ResourceID{DONORPROJECT_FIXEDTEXT6,_GetInst()},Point{12, 2072},Dimension{57, 20}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"From Date:",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{DONORPROJECT_FIXEDTEXT7,_GetInst()},Point{264, 2072},Dimension{24, 20}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Till:",NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{DONORPROJECT_FIXEDTEXT5,_GetInst()},Point{13, 2095},Dimension{542, 22}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Give insight who has given to which destination during a certain period of time",NULL_STRING,NULL_STRING}
oDCFixedText5:Font(aFonts[2], FALSE)

SELF:Caption := "Donor versus Project Report"
SELF:HyperLabel := HyperLabel{#DonorProject,"Donor versus Project Report",NULL_STRING,NULL_STRING}
SELF:OwnerAlignment := OA_TOP_AUTOSIZE
SELF:PreventAutoLayout := False

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListBoxSelect(oControlEvent) CLASS DonorProject
	LOCAL oControl AS Control, uValue AS USUAL
	LOCAL lSelected AS LOGIC
	LOCAL nItem,i,j,k,nCur,nSel AS INT
	LOCAL oList AS ListBox

	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	// select or deselect account
	// adapt arrays
	// resfresh screen
	IF Upper(oControl:Name)="SUBACCSET"
		nCur:=AScan(SELF:aDestAccSet,{|oList|oList:Name==oControl:Name})+2
		oList:=SELF:aDestAccSet[nCur-2]
		
		IF oList:SelectedCount>Len(SELF:aDestGrp[nCur,2])
			// more selected than before
			// determine new item:
			k:=oList:FirstSelected()
			nSel:=0
			DO WHILE k>0
				IF (AScan(SELF:aDestGrp[nCur,2],oList:GetItemValue(k)))=0
					EXIT
				ENDIF
				k:=oList:NextSelected()
			ENDDO
			// new item selected:
			uValue:=oList:GetItemValue(k)
			oList:SetTop(k)
			// add to own accounts:
			AAdd(SELF:aDestGrp[nCur,2],uValue)					
			// remove from other groups:
			FOR i:=3 TO Len(SELF:aDestGrp)
				IF i#nCur
					IF (j:=AScan(SELF:aDestGrp[i,2],uValue))>0
						// deselect item:
						oList:=SELF:aDestAccSet[i-2]
						k:=oList:FirstSelected()
						DO WHILE k>0
							IF uValue==oList:GetItemValue(k)
								oList:DeselectItem(k)
								//ADel(SELF:aDestGrp[i,2],j)
								//ASize(SELF:aDestGrp[i,2],Len(SELF:aDestGrp[i,2])-1)
								SELF:DeselectAccount(i,j)
								EXIT
							ENDIF
							k:=oList:NextSelected()
						ENDDO
						// make first selected current:
						k:=oList:FirstSelected()
						IF k>0
							oList:SetTop(k)
						ENDIF
						EXIT
					ENDIF
				ENDIF
			NEXT
		ELSE
			// deselect
			// determine item:
			oList:=oControl
			nSel:=0
			FOR i:=1 TO Len(SELF:aDestGrp[nCur,2])
				k:=oList:FirstSelected()
				nSel:=0
				DO WHILE k>0
					IF SELF:aDestGrp[nCur,2,i]==oList:GetItemValue(k)
						nSel:=i
						EXIT
					ENDIF
					k:=oList:NextSelected()
				ENDDO
				IF nSel==0
					// found:
					uValue:=SELF:aDestGrp[nCur,2,i]
					// remove from own accounts:
					SELF:DeselectAccount(@nCur,i)						
					// make it current again:
					FOR j:=1 TO oList:ItemCount
						IF uValue==oList:GetItemValue(j)
							oList:SetTop(j)
							EXIT
						ENDIF
					NEXT
					// add to last group:
					IF nCur=Len(SELF:aDestGrp)
						// add new group:
						AAdd(SELF:aDestGrp,{"Other projects"+Str(nCur-1,-1),{uValue}})
						SELF:SetDestGrp(nCur+1)
					ELSE
						AAdd(SELF:aDestGrp[Len(SELF:aDestGrp),2],uValue)
					ENDIF
					SELF:SetSelected(Len(SELF:aDestGrp))
					EXIT
				ENDIF
			NEXT
		ENDIF
	ENDIF
	RETURN NIL
METHOD OKButton( ) CLASS DonorProject
	// fill oSys:DestGrps with selected accounts per group:
	LOCAL i, j AS INT
	LOCAL oSys as SQLSelect
	LOCAL cXMLDoc:="<groups>",cName AS STRING
	LOCAL myBox AS BoundingBox
	LOCAL myArea AS BoundingBox
	LOCAL myDim AS Dimension

	myDim:=SELF:Size
	myBox:=SELF:CanvasArea
	myArea:=SELF:WindowArea

	oSys:=SQLSelect{"select destgrps from sysparms",oConn}
	IF oSys:RecCount>0
		FOR i:=3 to Len(aDestGrp)
			cName:=AllTrim((self:aDestName[i-2]):CurrentText)
			IF Empty(cName)
				(errorbox{SELF,"Group name must not be empty!"}):Show()
				(SELF:aDestName[i-2]):SetFocus()
				RETURN NIL
			ENDIF
			self:aDestGrp[i,1]:=cName			
			cXMLDoc+="<group><name>"+cName+"</name>"
			IF i>2
				// save only selected accounts of projects:
				FOR j:=1 TO Len(aDestGrp[i,2])
					cXMLDoc+="<account>"+Str(aDestGrp[i,2,j],-1)+"</account>"
				NEXT
			ENDIF
			cXMLDoc+="</group>"
		NEXT
		cXMLDoc+="</groups>"
		
		SQLStatement{"start transaction",oConn}:Execute()
		SQLStatement{"update sysparms set DESTGRPS='"+cXMLDoc+"'",oConn}:Execute()
		SQLStatement{"commit",oConn}:Execute()
		oSys:Close()          	
	ENDIF
	oSys:=NULL_OBJECT

	IF SELF:oDCTodate:SelectedDate < SELF:oDCFromdate:SelectedDate
		(errorbox{SELF,"To Date must be behind From Date"}):show()
	ELSE
		SELF:Pointer := Pointer{POINTERHOURGLASS}
		SELF:Statusmessage("Collecting data for the report, please wait...")
		SELF:PrintReport()
		SELF:Close()
		SELF:Pointer := Pointer{POINTERARROW}
	ENDIF
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS DonorProject
	//Put your PostInit additions here
	LOCAL h as int
	LOCAL myDim as Dimension
	LOCAL myOrg as Point
	local OldestYear as date  
	LOCAL StartDate as date
	
	self:SetTexts()
	myDim:=self:Size
	myDim:Height-=2000
	SELF:Size:=myDim
	myOrg:=SELF:Origin
	myOrg:y+=2000
	SELF:Origin:=myOrg
   	
	// generate controls and preselect required items per group
	FOR h:=3 TO Len(aDestGrp)
		SELF:SetDestGrp(h)
		SELF:SetSelected(h)
	NEXT
                      
	if !Empty(GlBalYears)
		OldestYear:=GlBalYears[Len(GlBalYears),1] 
	else
		OldestYear:=MinDate
	endif                      
                      
	StartDate:=OldestYear
	oDCFromdate:DateRange:=DateRange{StartDate,Today()+31}
	oDCTodate:DateRange:=DateRange{StartDate,Today()+31}

	SELF:oDCFromdate:Value:=Today()-360
	SELF:oDCFromdate:Value:=SELF:oDCFromdate:Value - Day(SELF:oDCFromdate:Value)+1
	SELF:oDCTodate:Value:=Today() - Day(Today())
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS DonorProject
	//Put your PreInit additions here
	LOCAL oSys as SQLSelect
	LOCAL oAcc as SQLSelect
	LOCAL oXMLDoc AS XMLDocument
	LOCAL childfound, recordfound AS LOGIC
	LOCAL ChildName AS STRING
	LOCAL Pntr:=0 AS INT
	LOCAL i,j AS INT
	LOCAL cAcc as int

	AAdd(aDestGrp,{"Members of "+sLand,{}})
	AAdd(aDestGrp,{"Members not of "+sLand,{}})

	// initialize array with gift accounts (non member)
	oAcc:=SQLSelect{"select account.accid,CO,description,accnumber,homepp FROM account";
		+ " left join member on member.accid=account.accid";
		+ " where giftalwd=1 and active=1 order by account.accid",oConn}
	if oAcc:RecCount<1
		oAcc:=null_object
		RETURN nil
	ENDIF

	//oAcc:SetRelation(oMem,#REK)

	do WHILE !oAcc:EoF
		IF Empty(oAcc:CO) .or. oAcc:CO!='M'
			// projects:
			AAdd(self:aGiftAcc,{"("+AllTrim(oAcc:accnumber)+")"+AllTrim(oAcc:Description),oAcc:accid})	
		ELSEIF oAcc:HOMEPP==sEntity .and. oAcc:CO=='M'
			// own members (non entity): group 1
			AAdd(aDestGrp[1,2],oAcc:accid)
			AAdd(aGiftAccHomeMbr,"("+AllTrim(oAcc:accnumber)+")"+AllTrim(oAcc:Description))
		ELSE
			// foreign members: group 2
			AAdd(aDestGrp[2,2],oAcc:accid)
			AAdd(aGiftAccForeignMbr,"("+AllTrim(oAcc:accnumber)+")"+AllTrim(oAcc:Description))
		ENDIF
		oAcc:Skip()
	ENDDO

	// Initialize aDestGrp:                      
	oSys:=SQLSelect{"select destgrps from sysparms",oConn}
	IF oSys:RecCount>0
		// Compose aDstGrp from XML document in oSys:DestGrps
		// <root>
		oXMLDoc:=XMLDocument{oSys:DESTGRPS}
		recordfound:=oXMLDoc:GetElement("group")
		Pntr:=0
		do WHILE recordfound
			Pntr++
			AAdd(aDestGrp,{,{}})
			childfound:=oXMLDoc:GetFirstChild()
			do WHILE childfound
				ChildName:=oXMLDoc:ChildName
				do CASE
				CASE ChildName=="name"
					aDestGrp[Pntr+2,1]:=oXMLDoc:ChildContent
				CASE ChildName=="account"
					cAcc:=Val(oXMLDoc:ChildContent)
					IF AScan(self:aGiftAcc,{|x| x[2]==cAcc})>0
						// only existing gift accounts:
						AAdd(aDestGrp[Pntr+2,2],cAcc)
					ENDIF
				ENDCASE
				childfound:=oXMLDoc:GetNextChild()			
			ENDDO
			IF Pntr>1 .and. ChildName=="name"
				// apparently no accounts:
				Pntr--
				ASize(aDestGrp,Pntr+2)
			ENDIF
			recordfound:=oXMLDoc:GetNextSibbling()
		ENDDO
	ENDIF
	IF Len(aDestGrp)=2
		AAdd(aDestGrp,{"Office "+sLand,{}})
		AAdd(aDestGrp,{"Other projects",{}})	
	ENDIF
	// add new accounts to last group:
	FOR i:=1 to Len(self:aGiftAcc)
		cAcc:=self:aGiftAcc[i,2]
		IF AScan(self:aDestGrp,{|x|AScan(x[2],cAcc)>0})=0
			AAdd(aDestGrp[Len(self:aDestGrp),2],cAcc)
		ENDIF
	NEXT
	RETURN nil
METHOD PrintReport() CLASS DonorProject
	// printing of donor versus project report
	LOCAL oTrans as SQLSelect
	LOCAL aMatrix:=ArrayNew(Len(self:aDestGrp),Len(pers_types)) as ARRAY // matrix to fill with calculated values
	LOCAL grp,acc,i,j as int
	LOCAL cAcc as int
	LOCAL nFromYear:=Year(self:oDCFromdate:SelectedDate),nFromMonth:=Month(self:oDCFromdate:SelectedDate),nToYear:=Year(self:oDCTodate:SelectedDate),nToMonth:=Month(self:oDCTodate:SelectedDate) as int
	LOCAL cFileName as USUAL, oFileSpec as FileSpec
	LOCAL ptrHandle
	LOCAL TotTotal:=0,RowTotal:=0 as FLOAT
	LOCAL ColTotal:=ArrayNew(Len(pers_types)) as ARRAY
	LOCAL aGiftProj:=self:aGiftAcc as ARRAY
	LOCAL aDestGrp:=self:aDestGrp as ARRAY
	local sqlStr as STRING

	sqlStr:=UnionTrans("select t.transid,t.accid,p.type,sum(t.cre-t.deb) as summa from transaction as t left join person as p on t.persid=p.persid ";
		+ "where p.type is not null and t.GC<>'PF' and t.GC<>'CH' and ";
		+ "t.dat>='" +  Str(nFromYear,4) + "-" + StrZero(nFromMonth,2) + "-01' and " ;
		+ "t.dat<='" + Str(nToYear,4) + "-" + StrZero(nToMonth,2) + "-" + StrZero(MonthEnd(nToMonth,nToYear),2) + "' and ";
		+ "t.CRE>t.DEB group by t.accid,p.type") // t.transid is required to ensure uniqueness when UnionTrans is performed 
	oTrans:=SQLSelect{sqlStr,oConn} 
	
	AEvalA(aMatrix,{|x|AFill(x,0.00)})

	DO WHILE !oTrans:EoF
		i:=AScan(pers_types,{|x|x[2]==oTrans:TYPE})
		IF i>0		
			FOR grp:=1 to Len(aDestGrp)
				if AScan(aDestGrp[grp,2],{|x| x=oTrans:accid})>0                                  
					aMatrix[grp,i]+=oTrans:summa
				endif
			next
		ENDIF    
		oTrans:Skip()
	ENDDO               
	oTrans:Close()
	oTrans:=null_object

	// markup report from matrix:
	oFileSpec:=AskFileName(self,"DonorProject"+Str(nFromYear,4,0)+StrZero(nFromMonth,2)+"_"+Str(nToYear,4,0)+StrZero(nToMonth,2)+'.xls',,{"*.xls;"},{"spreadsheet"})
	IF oFileSpec==null_object
		RETURN FALSE
	ENDIF
	cFileName:=oFileSpec:FullPath
	ptrHandle := MakeFile(self,@cFileName,"Creating DonorProject-report")
	AEvalA(ColTotal,{||0.00})

	IF !ptrHandle = F_ERROR .and. !ptrHandle==nil
		oFileSpec:FullPath:=cFileName
		* header record:
		FWriteLine(ptrHandle,"<html><body><table border=1><tr><td align='center' colspan='"+Str(Len(self:aDestGrp)+2,-1)+"'>"+oLan:Get("Donor versus Project Report")+"  "+oLan:Get("period")+": "+DToC(self:oDCFromdate:SelectedDate)+" - "+DToC(self:oDCTodate:SelectedDate)+"</td></tr>")
		FWriteLine(ptrHandle,"<tr><td></td>")
		FOR i:=1 to Len(aDestGrp)
			FWriteLine(ptrHandle,"<td align='right'><b>"+oLan:Get(aDestGrp[i,1])+"</b></td>")	
		NEXT
		FWriteLine(ptrHandle,"<td>"+oLan:Get("TOTAL")+"</td>")
		* detail records:
		FOR i = 1 to Len(pers_types)
			FWriteLine(ptrHandle,"</tr><tr><td>"+oLan:Get(pers_types[i,1])+"</td>")
			RowTotal:=0
			FOR j:=1 to Len(aDestGrp)
				FWriteLine(ptrHandle,"<td>"+AllTrim(Str(aMatrix[j,i],,0))+"</td>")
				RowTotal+=aMatrix[j,i]
				ColTotal[j]+=aMatrix[j,i]
			NEXT
			TotTotal+=RowTotal
			FWriteLine(ptrHandle,"<td>"+AllTrim(Str(RowTotal,,0))+"</td>")
		NEXT
		FWriteLine(ptrHandle,"</tr><tr><td>TOTAL</td>")
		FOR i:=1 to Len(aDestGrp)
			FWriteLine(ptrHandle,"<td>"+AllTrim(Str(ColTotal[i],,0))+"</td>")		
		NEXT
		FWriteLine(ptrHandle,"<td>"+AllTrim(Str(TotTotal,,0))+"</td></tr>")	
		// show accounts per group:
		FWriteLine(ptrHandle,"<tr><td colspan='"+Str(Len(self:aDestGrp)+2,-1)+"'<p><br></td></tr>")
		FWriteLine(ptrHandle,"<tr><td></td>")
		FOR i:=1 to Len(aDestGrp)
			FWriteLine(ptrHandle,"<td><b>"+aDestGrp[i,1]+"</b></td>")	
		NEXT
		FWriteLine(ptrHandle,"<tr><td valign='top'>"+oLan:Get("Accounts")+"</td>")
		FOR i:=1 to Len(aDestGrp)
			DO CASE
			CASE i==1
				FWriteLine(ptrHandle,"<td>")
				FOR j:=1 TO Len(aGiftAccHomeMbr)
					FWriteLine(ptrHandle,aGiftAccHomeMbr[j]+"<br>")
				NEXT				
				FWriteLine(ptrHandle,"</td>")
			CASE i==2
				FWriteLine(ptrHandle,"<td>")
				FOR j:=1 TO Len(aGiftAccForeignMbr)
					FWriteLine(ptrHandle,aGiftAccForeignMbr[j]+"<br>")
				NEXT				
				FWriteLine(ptrHandle,"</td>")
			CASE i>2
				FWriteLine(ptrHandle,"<td>")
				FOR j:=1 TO Len(aDestGrp[i,2])
					acc:=AScan(aGiftProj,{|x|x[2]==aDestGrp[i,2,j]})
					IF acc>0
						FWriteLine(ptrHandle,aGiftProj[acc,1]+"<br>")
					ENDIF
				NEXT				
				FWriteLine(ptrHandle,"</td>")
			ENDCASE
		NEXT
		FWriteLine(ptrHandle,"</tr>")

		* closing record:
		FWriteLine(ptrHandle,"</table></body></html>")
		FClose(ptrHandle)
		self:Pointer := Pointer{POINTERARROW}
		// show with excel:
		FileStart(oFileSpec:FullPath,self)
	ENDIF
	
	RETURN nil
  METHOD SetDestGrp( Count) CLASS DonorProject
  	// initialize controls for a destination group
	LOCAL oSingle AS SingleLineEdit
	LOCAL oList AS ListBox
	LOCAL oDCGroupBoxDest AS GroupBox
	LOCAL Name , ID , Values AS STRING
	LOCAL myDim AS Dimension
	LOCAL myOrg AS Point
	LOCAL aValues AS ARRAY
	LOCAL pwvs AS WindowVerticalScrollBar
	LOCAL oEvent AS ResizeEvent
	Name:=aDestGrp[Count,1]
	nID++
	ID:=Str(nID,-1)
	//
	// enlarge window
	myDim:=SELF:Size
	myDim:Height+=115
	SELF:Size:=myDim
	myOrg:=SELF:Origin
	myOrg:y-=115
	SELF:Origin:=myOrg
	//
	// enlarge destinations group:
	myDim:=SELF:oDCDestinations:Size
	myDim:Height+=115
	SELF:oDCDestinations:Size:=myDim
	myOrg:=SELF:oDCDestinations:Origin
	myOrg:y-=115
	SELF:oDCDestinations:Origin:=myOrg
	//
	//	insert controls in destinations group:	
	// listbox:
	myOrg:y+=13
	myOrg:x:=256
	oList:=ListBox{self,Count+100,myOrg,Dimension{288,103},LBOXMULTIPLESEL+LBOXSORT+LBOXDISABLENOSCROLL}
	oList:HyperLabel := HyperLabel{String2Symbol("SubAccSet"+ID),"SubAccSet"+ID,null_string,null_string} 
	oList:OwnerAlignment:=OA_WIDTH
	oList:FillUsing(self:aGiftAcc)
	AAdd(self:aDestAccSet,oList)
	oList:Show()
	// name
	myOrg:x:=22
	myOrg:y+=83
	oSingle:=SingleLineEdit{SELF,Count+200,myOrg,Dimension{230,20},EDITAUTOHSCROLL	}
	oSingle:HyperLabel := HyperLabel{String2Symbol("DestName"+ID),"DestName"+ID,NULL_STRING,NULL_STRING}
	oSingle:FocusSelect := FSEL_HOME
	AAdd(SELF:aControls,oSingle)
	oSingle:Show()
	oSingle:Value:=Name
	AAdd(SELF:aDestName,oSingle)

RETURN NIL
METHOD SetSelected(count) CLASS DonorProject
	// set corresponding accounts as selected in Listbox of a destination group
	LOCAL h,i,j,k,grp AS INT
	LOCAL oList AS ListBox
	LOCAL aAcc:= aDestGrp[count,2] AS ARRAY
	LOCAL search as int
	oList:=SELF:aDestAccSet[count-2]
	// select required items:
	FOR j:=1 TO oList:ItemCount
		search:=oList:GetItemValue(j)
		IF AScan(aAcc,search)>0
			// select all preselected items:
			oList:SelectItem(j)
		ENDIF
		// make first selected current:
		k:=oList:FirstSelected()
		IF k>0
			oList:SetTop(k)
		ENDIF
	NEXT
RETURN NIL	
STATIC DEFINE DONORPROJECT_CANCELBUTTON := 105 
STATIC DEFINE DONORPROJECT_DESTINATIONS := 102 
STATIC DEFINE DONORPROJECT_FIXEDTEXT3 := 103 
STATIC DEFINE DONORPROJECT_FIXEDTEXT5 := 108 
STATIC DEFINE DONORPROJECT_FIXEDTEXT6 := 106 
STATIC DEFINE DONORPROJECT_FIXEDTEXT7 := 107 
STATIC DEFINE DONORPROJECT_FROMDATE := 100 
STATIC DEFINE DONORPROJECT_OKBUTTON := 104 
STATIC DEFINE DONORPROJECT_TODATE := 101 
CLASS ListboxDonorReport INHERIT ListBoxExtra 
declare method GetAccnts
METHOD GetAccnts(dummy:=nil as string) as array CLASS ListboxDonorReport
	// get accounts for subset of listbox
LOCAL aAcc:={} AS ARRAY
LOCAL cExchAcc, cStart, cEnd AS STRING
LOCAL oParent:=SELF:Owner AS DonorFollowingReport
LOCAL aMemHome:=oParent:aMemHome AS ARRAY
LOCAL aMemNonHome:=oParent:aMemNonHome AS ARRAY
LOCAL aProjects:=oParent:aProjects AS ARRAY
LOCAL lHome:=oParent:HomeBox,lNonHome:=oParent:NonHomeBox,lProjects:=oParent:ProjectsBox AS LOGIC
* Enforce correct sequence:
cStart:=LTrimZero(oParent:FromAccount)
cEnd:=LTrimZero(oParent:ToAccount)
IF Empty(cStart).and.Empty(cEnd)
	RETURN {}
ENDIF
IF !Empty(cEnd).and. cStart>cEnd
	cExchAcc := cEnd
	cEnd:=cStart
	cStart:=cExchAcc
ENDIF
IF lHome
	AEval(aMemHome,{|x| FilterAcc(aAcc,x,cStart,cEnd)})
ENDIF
IF lNonHome
	AEval(aMemNonHome,{|x| FilterAcc(aAcc,x,cStart,cEnd)})
ENDIF
IF lProjects
	AEval(aProjects,{|x| FilterAcc(aAcc,x,cStart,cEnd)})
ENDIF
RETURN aAcc
RESOURCE TotalsMembers DIALOGEX  12, 11, 225, 99
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"OK", TOTALSMEMBERS_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 160, 77, 54, 12
	CONTROL	"Cancel", TOTALSMEMBERS_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 96, 77, 54, 12
	CONTROL	"From month:", TOTALSMEMBERS_FIXEDTEXT3, "Static", WS_CHILD, 12, 40, 54, 12
	CONTROL	"Till month:", TOTALSMEMBERS_FIXEDTEXT5, "Static", WS_CHILD, 12, 59, 54, 12
	CONTROL	"", TOTALSMEMBERS_FROMYEAR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 36, 34, 11, WS_EX_CLIENTEDGE
	CONTROL	"", TOTALSMEMBERS_FROMMONTH, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 134, 37, 19, 12, WS_EX_CLIENTEDGE
	CONTROL	"", TOTALSMEMBERS_TOYEAR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 92, 56, 34, 12, WS_EX_CLIENTEDGE
	CONTROL	"", TOTALSMEMBERS_TOMONTH, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 136, 55, 19, 12, WS_EX_CLIENTEDGE
	CONTROL	"Give the total amounts of assessable gifts, personal funds and charges", TOTALSMEMBERS_FIXEDTEXT2, "Static", WS_CHILD, 7, 4, 212, 22
END

CLASS TotalsMembers INHERIT DataWindowMine 

	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCFromYear AS SINGLELINEEDIT
	PROTECT oDCFromMonth AS SINGLELINEEDIT
	PROTECT oDCToYear AS SINGLELINEEDIT
	PROTECT oDCToMonth AS SINGLELINEEDIT
	PROTECT oDCFixedText2 AS FIXEDTEXT

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	PROTECT oReport AS PrintDialog
	
METHOD CancelButton( ) CLASS TotalsMembers
		SELF:endWindow()
RETURN NIL
METHOD Close(oEvent) CLASS TotalsMembers
	SUPER:Close(oEvent)
	//Put your changes here
	IF !oLan==null_object
		IF oLan:Used
			oLan:Close()
		ENDIF
		oLan:=NULL_OBJECT
	ENDIF
	self:Destroy()
	RETURN NIL

ACCESS FromMonth() CLASS TotalsMembers
RETURN SELF:FieldGet(#FromMonth)

ASSIGN FromMonth(uValue) CLASS TotalsMembers
SELF:FieldPut(#FromMonth, uValue)
RETURN uValue

ACCESS FromYear() CLASS TotalsMembers
RETURN SELF:FieldGet(#FromYear)

ASSIGN FromYear(uValue) CLASS TotalsMembers
SELF:FieldPut(#FromYear, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TotalsMembers 
	LOCAL DIM aFonts[1] AS OBJECT

	self:PreInit(oWindow,iCtlID,oServer,uExtra)

	SUPER:Init(oWindow,ResourceID{"TotalsMembers",_GetInst()},iCtlID)

	aFonts[1] := Font{,10,"Microsoft Sans Serif"}
	aFonts[1]:Bold := TRUE

	oCCOKButton := PushButton{SELF,ResourceID{TOTALSMEMBERS_OKBUTTON,_GetInst()}}
	oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

	oCCCancelButton := PushButton{SELF,ResourceID{TOTALSMEMBERS_CANCELBUTTON,_GetInst()}}
	oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

	oDCFixedText3 := FixedText{SELF,ResourceID{TOTALSMEMBERS_FIXEDTEXT3,_GetInst()}}
	oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"From month:",NULL_STRING,NULL_STRING}

	oDCFixedText5 := FixedText{SELF,ResourceID{TOTALSMEMBERS_FIXEDTEXT5,_GetInst()}}
	oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Till month:",NULL_STRING,NULL_STRING}

	oDCFromYear := SingleLineEdit{SELF,ResourceID{TOTALSMEMBERS_FROMYEAR,_GetInst()}}
	oDCFromYear:HyperLabel := HyperLabel{#FromYear,NULL_STRING,NULL_STRING,NULL_STRING}
	oDCFromYear:FieldSpec := YEARW{}
	oDCFromYear:Picture := "9999"

	oDCFromMonth := SingleLineEdit{SELF,ResourceID{TOTALSMEMBERS_FROMMONTH,_GetInst()}}
	oDCFromMonth:Picture := "99"
	oDCFromMonth:FieldSpec := MONTHW{}
	oDCFromMonth:HyperLabel := HyperLabel{#FromMonth,NULL_STRING,NULL_STRING,NULL_STRING}

	oDCToYear := SingleLineEdit{SELF,ResourceID{TOTALSMEMBERS_TOYEAR,_GetInst()}}
	oDCToYear:HyperLabel := HyperLabel{#ToYear,NULL_STRING,NULL_STRING,NULL_STRING}
	oDCToYear:FieldSpec := YEARW{}
	oDCToYear:Picture := "9999"

	oDCToMonth := SingleLineEdit{SELF,ResourceID{TOTALSMEMBERS_TOMONTH,_GetInst()}}
	oDCToMonth:Picture := "99"
	oDCToMonth:FieldSpec := MONTHW{}
	oDCToMonth:HyperLabel := HyperLabel{#ToMonth,NULL_STRING,NULL_STRING,NULL_STRING}

	oDCFixedText2 := FixedText{SELF,ResourceID{TOTALSMEMBERS_FIXEDTEXT2,_GetInst()}}
	oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Give the total amounts of assessable gifts, personal funds and charges",NULL_STRING,NULL_STRING}
	oDCFixedText2:Font(aFonts[1], FALSE)

	SELF:Caption := "Totals Members during Balance Year"
	SELF:HyperLabel := HyperLabel{#TotalsMembers,"Totals Members during Balance Year",NULL_STRING,NULL_STRING}

	if !IsNil(oServer)
		SELF:Use(oServer)
	ENDIF

	self:PostInit(oWindow,iCtlID,oServer,uExtra)

	return self

METHOD OKButton( ) CLASS TotalsMembers
	LOCAL nRow, nPage as int
	LOCAL headingtext:={} as ARRAY, ad_banmsg  as STRING
	LOCAL oTransH as SQLSelect
	local aTotM:={} as array  // {{memberid,category 1=home,2:projekts home,3: projects home sep.department,4:nonHome,5:unknown member,6:unknown account,totAg, totAGFromRpp, TotMG, totPF, TotCH,TotAssOff,TotAssInt, membername},...} 
	Local aSubTot:={0,0,0,0,0,0,0}, aTotTot:={0,0,0,0,0,0,0} as array
	Local iPos,i,j as int, MemberId as string, CurCat as int 
	local oAcc as SQLSelect 
	local oMem as Members
	LOCAL cTab:=CHR(9) as STRING
	local nNameLen:=30 as int 
	local aGroupName as array
	local MainDeP as int
	local nUnknown as int
	local sqlStr as string
	

	* Check values:
	* Check input data:
	IF !ValidateControls( self, self:AControls )
		RETURN
	END
	// self:FromYear:=oDCFromYear:Value
	// self:FromMonth:=oDCFromMonth:Value
	// ToYear:=oDCToYear:Value
	// ToMonth:=oDCToMonth:Value
	IF self:FromYear*100+self:FromMonth > self:ToYear*100+self:ToMonth
		(ErrorBox{self,self:oLan:WGet("To Month must be behind From month")}):show()
		RETURN
	ENDIF
	ad_banmsg:= self:oLan:RGet('Totals of Members',,"!")+"_"+self:oLan:RGet('Period',,"!")+' '+Str(self:FromYear,4)+' '+StrZero(self:FromMonth,2)+' - '+Str(self:ToYear,4)+' '+StrZero(self:ToMonth,2)

	oReport := PrintDialog{oParent,ad_banmsg,,91+nNameLen,,"xls"}
	oReport:show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	self:Pointer := Pointer{POINTERHOURGLASS}
	self:STATUSMESSAGE("Collecting data, moment please") 

	// Determine main department:

	IF Departments
		if !Empty(SKAP)
			oAcc:=SQLSelect{"select department from account where accid=" + SKAP,oConn}
			if oAcc:RecCount>0
				MainDeP:=oAcc:Department
			endif
		endif
	endif

	* Stel kop samen:
	IF oReport:Destination#"File"
		cTab:=Space(1)
		headingtext:={ad_banmsg}
	else 
		nNameLen:=40
	ENDIF
	AAdd(headingtext,PadR(self:oLan:RGet("Name"),nNameLen) + cTab + self:oLan:RGet("Assble Gifts",12,,"R") + cTab + self:oLan:RGet("Gifts PP's",12,,"R") +;
		cTab +self:oLan:RGet("Member Gifts",12,,"R")+cTab +self:oLan:RGet("Persnl Funds",12,,"R") + cTab +;
		self:oLan:RGet("Charges",12,,"R")+cTab +self:oLan:RGet("Assmnt Off",12,,"R")+cTab +self:oLan:RGet("Assmnt Int/F",12,,"R"))

	sqlStr:=UnionTrans("select ";
		+ "t.transid,t.SEQNR,t.dat,t.cre,t.deb,t.FROMRPP,t.description as tdesc,t.GC,t.accid as taccid,";
		+ "a.Department,a.description as adesc,a.accid as aaccid,";
		+ "m.CO,m.HOMEPP,m.mbrid ";
		+ "from transaction as t ";
		+ "left join account as a on a.accid=t.accid ";
		+ "left join member as m on m.accid=t.accid ";
		+ "where t.dat>='" +  Str(self:FromYear,4) + "-" + StrZero(self:FromMonth,2) + "-01' and " ;
		+ "t.dat<='" + Str(self:ToYear,4) + "-" + StrZero(self:ToMonth,2) + "-" + StrZero(MonthEnd(self:ToMonth,self:ToYear),2) + "' and t.GC>''") //;
		//		+ " order by taccid"
	oTransH:=SQLSelect{sqlStr, oConn}

	do WHILE !oTransH:EoF
		MemberId:=Str(oTransH:taccid,-1)
		iPos:=AScan(aTotM,{|x|x[1]==MemberId})
		if Empty(iPos) 
			if !Empty(oTransH:aaccid)
				if !Empty(oTransH:mbrid)
					AAdd(aTotM,{MemberId,iif(oTransH:HOMEPP==sEntity,iif(oTransH:CO="M",1,iif(oTransH:Department==MainDeP,2,3)),4),0,0,0,0,0,0,0,AllTrim(oTransH:adesc)})
				else
					// add as unknown member:
					AAdd(aTotM,{MemberId,5,0,0,0,0,0,0,0,AllTrim(oTransH:adesc)})
				endif
			else
				// add as totally unknown member: 
				nUnknown++
				AAdd(aTotM,{MemberId,6,0,0,0,0,0,0,0,"unknown"+Str(nUnknown,-1)})
			endif
			iPos:=Len(aTotM)
		endif   
		do CASE
		CASE oTransH:GC=="AG".and. oTransH:FROMRPP=0
			aTotM[iPos,3]:=Round(aTotM[iPos,3]+oTransH:cre-oTransH:DEB,DecAantal)
		CASE oTransH:GC=="AG".and. oTransH:FROMRPP=1
			aTotM[iPos,4]:=Round(aTotM[iPos,4]+oTransH:cre-oTransH:DEB,DecAantal)
		CASE oTransH:GC=="MG"
			aTotM[iPos,5]:=Round(aTotM[iPos,5]+oTransH:cre-oTransH:DEB,DecAantal)
		CASE oTransH:GC=="PF"
			aTotM[iPos,6]:=Round(aTotM[iPos,6]+oTransH:cre-oTransH:DEB,DecAantal)
		CASE oTransH:GC=="CH" .and. oTransH:tdesc # "Assessment"
			aTotM[iPos,7]:=Round(aTotM[iPos,7]+oTransH:cre-oTransH:DEB,DecAantal)
		CASE oTransH:GC=="CH" .and. oTransH:tdesc = "Assessment office"
			aTotM[iPos,8]:=Round(aTotM[iPos,8]+oTransH:cre-oTransH:DEB,DecAantal)
		CASE oTransH:GC=="CH" .and. oTransH:tdesc = "Assessment Int"
			aTotM[iPos,9]:=Round(aTotM[iPos,9]+oTransH:cre-oTransH:DEB,DecAantal)
		ENDCASE       
		oTransH:Skip()	
	ENDDO
	ASort(aTotM,,,{|x,y|x[2]<y[2] .or.(x[2]==y[2].and.x[8]<y[8])})
	// print totals:
	oReport:PrintLine(@nRow,@nPage,' ',headingtext,1)
	CurCat:=aTotM[1,2]
	aGroupName:={self:oLan:RGet("Members",,"@!")+" "+sEntity,self:oLan:RGet("Projects",,"@!")+" "+sEntity,;
		self:oLan:RGet("Projects",,"@!")+" "+sEntity+" "+oLan:RGet("separate department",,"@!"),;
		self:oLan:RGet("Members",,"@!")+" "+self:oLan:RGet("not",,"@!")+" "+sEntity,self:oLan:RGet("Unknown Members",,"@!"),self:oLan:RGet("Unknown Account",,"@!")}      
	oReport:PrintLine(@nRow,@nPage,aGroupName[CurCat],headingtext,5)
	for i:=1	to	Len(aTotM)
		if !CurCat==aTotM[i,2]  
			// print subtotals:
			oReport:PrintLine(@nRow,@nPage,Space(nNameLen)+Replicate(cTab+Replicate('-',12),7),null_array,0)
			oReport:PrintLine(@nRow,@nPage,PadR(aGroupName[CurCat],nNameLen) +cTab + Str(aSubTot[1],12,DecAantal)+cTab+Str(aSubTot[2],12,DecAantal)+;
				cTab+Str(aSubTot[3],12,DecAantal) +cTab+Str(aSubTot[4],12,DecAantal)+cTab+Str(aSubTot[5],12,DecAantal);
				+cTab+Str(aSubTot[6],12,DecAantal)+cTab+Str(aSubTot[7],12,DecAantal),null_array,0)
			oReport:PrintLine(@nRow,@nPage,Space(nNameLen)+Replicate(cTab+Replicate('-',12),7),null_array,0)
			for j:=1 to Len(aSubTot)
				aTotTot[j]:=Round(aTotTot[j]+aSubTot[j],DecAantal) 
				aSubTot[j]:=0
			next
			CurCat:=aTotM[i,2] 
			oReport:PrintLine(@nRow,@nPage,aGroupName[CurCat],headingtext,5)
		endif
		oReport:PrintLine(@nRow,@nPage,PadR(aTotM[i,10],nNameLen) +cTab+ Str(aTotM[i,3],12,DecAantal)	+cTab+	Str(aTotM[i,4],12,DecAantal) +cTab+ Str(aTotM[i,5],12,DecAantal) +cTab+ Str(aTotM[i,6],12,DecAantal)+cTab+ Str(aTotM[i,7],12,DecAantal)+cTab+ Str(aTotM[i,8],12,DecAantal)+cTab+ Str(aTotM[i,9],12,DecAantal),null_array,0)
		for j:=1 to Len(aSubTot)
			aSubTot[j]:=Round(aSubTot[j]+aTotM[i,j+2],DecAantal)
		next

	next	 
	// print subtotals:
	oReport:PrintLine(@nRow,@nPage,Space(nNameLen)+Replicate(cTab+Replicate('-',12),7),null_array,0)
	oReport:PrintLine(@nRow,@nPage,PadR(aGroupName[CurCat],nNameLen) +cTab + Str(aSubTot[1],12,DecAantal)+cTab+Str(aSubTot[2],12,DecAantal)+;
		cTab+Str(aSubTot[3],12,DecAantal) +cTab+Str(aSubTot[4],12,DecAantal)+cTab+Str(aSubTot[5],12,DecAantal);
		+cTab+Str(aSubTot[6],12,DecAantal)+cTab+Str(aSubTot[7],12,DecAantal),null_array,0)
	oReport:PrintLine(@nRow,@nPage,Space(nNameLen)+Replicate(cTab+Replicate('-',12),7),null_array,0)
	for j:=1 to Len(aSubTot)
		aTotTot[j]:=Round(aTotTot[j]+aSubTot[j],DecAantal) 
	next
	// print grand total:
	oReport:PrintLine(@nRow,@nPage,Space(nNameLen)+Replicate(cTab+Replicate('=',12),7),null_array,0)
	oReport:PrintLine(@nRow,@nPage,PadR(self:oLan:RGet("Total",,"@!"),nNameLen) +cTab +  Str(aTotTot[1],12,DecAantal)+cTab+Str(aTotTot[2],12,DecAantal)+;
		cTab+Str(aTotTot[3],12,DecAantal) +cTab+ Str(aTotTot[4],12,DecAantal)+cTab+Str(aTotTot[5],12,DecAantal)+;
		+cTab+ Str(aTotTot[6],12,DecAantal)+cTab+Str(aTotTot[7],12,DecAantal),null_array,0)
	oReport:PrintLine(@nRow,@nPage,Space(nNameLen)+Replicate(cTab+Replicate('=',12),7),null_array,0)
	self:Pointer := Pointer{POINTERARROW}
	oReport:prstart()
	oReport:prstop()
	RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TotalsMembers
	//Put your PostInit additions here
	LOCAL oSys AS Sysparms
	self:SetTexts()
	IF Month(Today()) <=9
		SELF:FromYear:=Year(Today())-2
		SELF:ToYear:=Year(Today())-1
	ELSE
		SELF:FromYear:=Year(Today())-1
		SELF:ToYear:=Year(Today())
	ENDIF
	SELF:FromMonth:=10
	SELF:ToMonth:=9
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS TotalsMembers
	//Put your PreInit additions here
	RETURN NIL
ACCESS ToMonth() CLASS TotalsMembers
RETURN SELF:FieldGet(#ToMonth)

ASSIGN ToMonth(uValue) CLASS TotalsMembers
SELF:FieldPut(#ToMonth, uValue)
RETURN uValue

ACCESS ToYear() CLASS TotalsMembers
RETURN SELF:FieldGet(#ToYear)

ASSIGN ToYear(uValue) CLASS TotalsMembers
SELF:FieldPut(#ToYear, uValue)
RETURN uValue

STATIC DEFINE TOTALSMEMBERS_CANCELBUTTON := 101 
STATIC DEFINE TOTALSMEMBERS_FIXEDTEXT2 := 108 
STATIC DEFINE TOTALSMEMBERS_FIXEDTEXT3 := 102 
STATIC DEFINE TOTALSMEMBERS_FIXEDTEXT5 := 103 
STATIC DEFINE TOTALSMEMBERS_FROMMONTH := 105 
STATIC DEFINE TOTALSMEMBERS_FROMYEAR := 104 
STATIC DEFINE TOTALSMEMBERS_OKBUTTON := 100 
STATIC DEFINE TOTALSMEMBERS_TOMONTH := 107 
STATIC DEFINE TOTALSMEMBERS_TOYEAR := 106 
