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
	INSTANCE TYPE
	INSTANCE Frequency
	INSTANCE Ranges
	INSTANCE StatBox1
	INSTANCE StatBox2
	INSTANCE StatBox3
	INSTANCE StatBox4
	INSTANCE StatBox5
	INSTANCE StatBox6
	INSTANCE StatBox7
	INSTANCE NumberRanges
	INSTANCE SubSet
	INSTANCE DiffBox
	PROTECT MaxJaar,MinJaar, StartJaar as int
	PROTECT aPropEx:={} as ARRAY
	EXPORT cFromAccName as STRING
	EXPORT cToAccName as STRING
	PROTECT FromYear,FromMonth,ToYear,ToMonth as int
	export oSelpers as Selpers 
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
	CONTROL	"Required statistical data", DONORFOLLOWINGREPORT_STATISTICSBOX, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 11, 257, 304, 104
	CONTROL	"amount given per class of givers", DONORFOLLOWINGREPORT_STATBOX1, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 267, 251, 11
	CONTROL	"percentage of total amount given, a certain class of givers has contributed", DONORFOLLOWINGREPORT_STATBOX2, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 279, 253, 11
	CONTROL	"number of givers per class of givers", DONORFOLLOWINGREPORT_STATBOX3, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 291, 251, 11
	CONTROL	"percentage of total number of givers, a certain class of givers has contributed", DONORFOLLOWINGREPORT_STATBOX4, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 304, 255, 11
	CONTROL	"average amount given per class of givers", DONORFOLLOWINGREPORT_STATBOX5, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 316, 153, 11
	CONTROL	"median amount given per class of givers", DONORFOLLOWINGREPORT_STATBOX6, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 329, 155, 11
	CONTROL	"spread over ranges of amounts given per class of givers ", DONORFOLLOWINGREPORT_STATBOX7, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 342, 191, 11
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
	CONTROL	"21. januar 2011", DONORFOLLOWINGREPORT_FROMDATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 62, 126, 120, 13
	CONTROL	"21. januar 2011", DONORFOLLOWINGREPORT_TODATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 62, 145, 120, 13
	CONTROL	"From Date:", DONORFOLLOWINGREPORT_FIXEDTEXT6, "Static", WS_CHILD, 13, 126, 46, 12
	CONTROL	"Till Date:", DONORFOLLOWINGREPORT_FIXEDTEXT8, "Static", WS_CHILD, 13, 145, 41, 12
	CONTROL	"Report Period", DONORFOLLOWINGREPORT_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 113, 232, 68
	CONTROL	"Give insight in the effects of e.g. a mailing on the donor behaviour:", DONORFOLLOWINGREPORT_FIXEDTEXT9, "Static", WS_CHILD, 7, 4, 376, 12
	CONTROL	"which part of the different groups of givers have given during a certain period of time and how much have they given", DONORFOLLOWINGREPORT_FIXEDTEXT10, "Static", WS_CHILD, 7, 17, 371, 12
END

METHOD AccFil() CLASS DonorFollowingReport
	LOCAL i as int
	LOCAL SubLen as int
	self:FromAccount:="0"
	self:ToAccount:="zzzzzzzzz"
	self:oDCSubSet:FillUsing(self:oDCSubSet:GetAccnts())
	* Select all:
	SubLen:=self:oDCSubSet:ItemCount
	FOR i = 1 to SubLen
    	self:oDCSubSet:SelectItem(i)
	NEXT
	self:FromAccount:= LTrimZero(self:oDCSubSet:GetItem(1,LENACCNBR))
	self:oDCFromAccount:TEXTValue := FromAccount
	self:cFromAccName := FromAccount
	self:oDCTextfrom:Caption := AllTrim(SubStr(self:oDCSubSet:GetItem(1),LENACCNBR+1))
	self:ToAccount:= LTrimZero(self:oDCSubSet:GetItem(SubLen,LENACCNBR))
	self:oDCToAccount:TEXTValue := ToAccount
	self:cToAccName := ToAccount
	self:oDCTextTill:Caption := AllTrim(SubStr(self:oDCSubSet:GetItem(SubLen),LENACCNBR+1))
RETURN


METHOD AddClass(aClassTuples,line,level,maxlevel,aClassList) CLASS DonorFollowingReport
	// Add Class combinations recursively to aClassTuples
	LOCAL i as int
	LOCAL sep:="," as STRING
	IF Empty(line)
		sep:=""
	ENDIF
	FOR i:=aClassList[level,2] to aClassList[level,3]
		IF level<maxlevel
			self:AddClass(aClassTuples,line+sep+Str(i,-1),level+1,maxlevel,aClassList)
		ELSE
			AAdd(aClassTuples,line+sep+Str(i,-1))
		ENDIF
	NEXT
RETURN
		
		
ACCESS Age() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#Age)

ASSIGN Age(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#Age, uValue)
RETURN uValue

METHOD ButtonClick(oControlEvent) CLASS DonorFollowingReport
	LOCAL oControl as CONTROL
	LOCAL i as int
	LOCAL SubLen as int
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:Name=="STATBOX7"
		IF self:oDCStatBox7:Checked
			self:oDCNumberRanges:Show()
			self:oDCFixedTextRanges:Show()
		ELSE
			self:oDCNumberRanges:Hide()
			self:oDCFixedTextRanges:Hide()
		ENDIF
	ELSEIF oControl:Name=="AGE"
		IF self:oDCAge:Checked
			self:oDCRanges:Show()
			self:oCCRange10:Show()
			self:oCCRange20:Show()
		ELSE
			self:oDCRanges:Hide()
			self:oCCRange10:Hide()
			self:oCCRange20:Hide()
		ENDIF
	ELSEIF oControl:NameSym=#HomeBox .or. oControl:NameSym=#NonHomeBox .or. oControl:NameSym=#ProjectsBox
		self:AccFil()
	ENDIF
	RETURN nil
METHOD CancelButton( ) CLASS DonorFollowingReport
	self:EndWindow()
	RETURN nil
METHOD Close(oEvent) CLASS DonorFollowingReport
	SUPER:Close(oEvent)
	//Put your changes here
	self:EndWindow()
	RETURN nil
ACCESS DiffBox() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#DiffBox)

ASSIGN DiffBox(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#DiffBox, uValue)
RETURN uValue

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS DonorFollowingReport
	LOCAL oControl as CONTROL
	LOCAL lGotFocus as LOGIC
	oControl := iif(oEditFocusChangeEvent == null_object, null_object, oEditFocusChangeEvent:Control)
	lGotFocus := iif(oEditFocusChangeEvent == null_object, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "FROMACCOUNT"
			IF !Upper(AllTrim(oControl:VALUE))==Upper(AllTrim(cFromAccName))
				cFromAccName:=AllTrim(oControl:VALUE)
				self:FromAccButton(true)
			ENDIF
		ELSEIF oControl:Name == "TOACCOUNT"
			IF !Upper(AllTrim(oControl:VALUE))==Upper(AllTrim(cToAccName))
				cToAccName:=AllTrim(oControl:VALUE)
				self:ToAccButton(true)
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
	AccountSelect(self,AllTrim(oDCFromAccount:TEXTValue ),"From Account",lUnique,"GiftAlwd",,)
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

METHOD MarkupMatrix(ptrHandle,aMatrix,cHeading,PeriodCount,aRelevantClass,ixOff)	CLASS	DonorFollowingReport
	// fill excel matrix with data
	LOCAL i,j,m as int, line as STRING
	LOCAL diff as FLOAT
	// header record:
	FWriteLine(ptrHandle,"<tr><td style='font-weight: bold;italic; color:blue;text-align : center;'  colspan='"+Str(Len(aMatrix)-PeriodCount,-1)+"'>"+oLan:Get(cHeading)+"</td></tr>")
	FOR j:=1 to Len(aMatrix[1]) 
		IF j<=ixOff .or. aRelevantClass[j-ixOff]
			line:="<tr>"
			FOR i:=1 to Len(aMatrix)
				IF IsNumeric(aMatrix[i,j])
					// determine difference with previous period:
					IF i>PeriodCount .and. self:DiffBox
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
					FOR m:=1 to Len(aMatrix[i,j])
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
		ENDIF
	NEXT
	FWriteLine(ptrHandle,"<tr><td colspan='"+Str(Len(aMatrix)-PeriodCount,-1)+"'>&nbsp;<br></td></tr>")
	RETURN nil
method MouseButtonDown(oMouseEvent) class DonorFollowingReport
	local nButtonID as int
	nButtonID := iif(oMouseEvent == null_object, 0, oMouseEvent:ButtonID)
	super:MouseButtonDown(oMouseEvent)
	//Put your changes here
	return nil

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
	FromYear:=Year(self:oDCFromdate:SelectedDate)
	FromMonth:=Month(self:oDCFromdate:SelectedDate)
	ToYear:=Year(self:oDCTodate:SelectedDate)
	ToMonth:=Month(self:oDCTodate:SelectedDate)
	IF self:oDCSubSet:SelectedCount<1
		(ErrorBox{self,self:oLan:Wget("Select at least one Fund/Member!")}):Show()
		self:oDCFromAccount:SetFocus()
		RETURN
	ENDIF
	IF FromYear<1980 .or.FromYear>Year(Today())+1
		(ErrorBox{self,self:oLan:Wget("Non valid from month!")}):Show()
		self:oDCFromYear:SetFocus()
		RETURN
	ENDIF
	IF ToYear<1980 .or.ToYear>Year(Today())+1
		(ErrorBox{self,self:oLan:Wget("Non valid To month!")}):Show()
		self:oDCToYear:SetFocus()
		RETURN
	ENDIF
	IF self:oDCFromdate:SelectedDate > self:oDCTodate:SelectedDate
		(ErrorBox{self,self:oLan:Wget("To Date must be behind From Date")}):Show()
		self:oDCFromYear:SetFocus()
		RETURN
	ENDIF
	IF StatBox7 .and. NumberRanges<2
		(ErrorBox{self,self:oLan:Wget("Number of ranges must be at least 2")}):Show()
		self:oDCNumberRanges:SetFocus()
		RETURN
	ENDIF
	IF !(StatBox1.or.StatBox2.or.StatBox3.or.StatBox4.or.StatBox5.or.StatBox6.or.StatBox7)
		(ErrorBox{self,self:oLan:Wget("Select at least one type of statistical data!")}):Show()
		self:oDCStatBox1:SetFocus()
		RETURN
	ENDIF
	self:Pointer := Pointer{POINTERHOURGLASS}
	self:PrintReport()
	self:Pointer := Pointer{POINTERARROW}
	RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS DonorFollowingReport
	//Put your PostInit additions here
	LOCAL count as int
	LOCAL EndDate,FromDate as date
	LOCAL StartDate as date
	LOCAL OldestYear as date
	  
	self:SetTexts()

	self:oDCHomeBox:Caption:=(Language{}):WGet("Members of")+" "+sLand
	self:oDCNonHomeBox:Caption:=(Language{}):WGet("Members not of")+" "+sLand
	self:ProjectsBox:=true
	self:AccFil()

	
	if !Empty(GlBalYears)
		OldestYear:=GlBalYears[Len(GlBalYears),1] 
	else
		OldestYear:=MinDate
	endif                      
	
	StartDate:=OldestYear
	oDCFromdate:DateRange:=DateRange{StartDate,Today()+31}
	oDCTodate:DateRange:=DateRange{StartDate,Today()+31}

	self:oDCFromdate:Value:=Today()-360
	self:oDCFromdate:Value:=self:oDCFromdate:Value - Day(self:oDCFromdate:Value)+1
	self:oDCTodate:Value:=Today() - Day(Today())

	self:SubPerLen:=0
	self:Ranges:="20"
	self:NumberRanges:=5
	//SELF:oCCRange10:Pressed:=TRUE
	FOR count:=1 to Len(pers_propextra) step 1
		self:SetPropExtra(count)
	NEXT
	StatBox1:=true
	StatBox2:=true
	StatBox3:=true
	StatBox4:=true
	StatBox5:=true
	StatBox6:=true
	StatBox7:=true
	self:oDCFixedTextRanges:show()
	self:oDCNumberRanges:show()
	DiffBox:=true
	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS DonorFollowingReport
	//Put your PreInit additions here
	self:FillMbrProjArray()
	RETURN nil
METHOD PrintReport() CLASS DonorFollowingReport
	// printing of donor versus project report
	LOCAL oAcc as SQLSelect
	LOCAL accStr, sqlStr, sqlStr2, freqStr1, freqStr2 as STRING
	LOCAL oTrans as SQLSelect
	LOCAL oPers as SQLSelect
	LOCAL oTransFreq as SQLSelect
	LOCAL aPers:={} as ARRAY // of each giver its CLN  
	LOCAL aPersPrvFreq,aPersFreq as ARRAY // of each person from aPers: frequency of giving: 1: first giver, 2: not last 2 years, 3: not last year, 4:last year once, 5: more than once last year
	LOCAL periodNo, classNo, i,j,k,m,nRange,nCSt,maxlevel as int
	LOCAL cName as STRING
	LOCAL NextYear, NextMonth, PrevYear, PrevMonth as int
	LOCAL StartDate,EndDate,PerStart,PerEnd,FrequencyEnd, PerStart1, PerStart2 as date
	LOCAL PeriodCount:=0 as int // Number of subperiods in total date range
	LOCAL PrevPeriodCount as int
	LOCAL cFileName as USUAL, oFileSpec as FileSpec
	LOCAL ptrHandle
	LOCAL aAcc:={} as ARRAY
	LOCAL aClass:={} as ARRAY // person classes: {symname,fieldname, value[,value]}
	LOCAL aClassIndex:={} as ARRAY // list with overview of classes: fieldname, startnbr, endnbr,type (type:0 normal field, 1: age range,2:giving frequency, 3: extra property dropdn, 4: extra property checkbx
	LOCAL aExportClass:={} as Array // contains list of possible classes to be exported: {{name,index}, ...}
	LOCAL persValuePtrPrv,persValuePtr as int
	LOCAL aPeriod:={} as ARRAY // subperiods' start date
	LOCAL aClassTuples:={} as ARRAY // Each member is a comma separated list of class values. The entire array contains all possible class combinations
	LOCAL aRelevantClass as ARRAY // Each member indicates if the corresponding element in aClassTuples has any donation entries
	LOCAL aDropValues as ARRAY
	LOCAL oCheck as CheckBox
	LOCAL cSearch,cSearchOrg,cSep,insSep,cClassName as STRING
	LOCAL uFieldValue as USUAL, nFreq as int
	LOCAL nClassPtr,nClassPtr1,nClassPtr2,nCount,nAge,nPersPtr as int
	LOCAL aClassPtr as ARRAY // ptrs to rows in aClass
	LOCAL aMatrix1,aMatrix2,aMatrix3,aMatrix4,aMatrix5,aMatrix6,aMatrix7 as ARRAY // matrix to fill with calculated values Stat1,Stat2, ...
	LOCAL oXMLDoc as XMLDocument
	LOCAL fType as int //(0: normal FIELD,1: birthdate, 2: extra property checkbx,3:  extra property dropdown
	LOCAL PerTotal,PerCount as ARRAY
	LOCAL donationsCount,median,TrCnt,insCount as int
	LOCAL rangeVal  // max and min value per period and value per range per period
	LOCAL gMes:="Finding transactions" as STRING
	LOCAL sMes:="Collecting data for the report" as STRING
	LOCAL rMes:="Generating report" as STRING
	LOCAL pMes:="Determining class per giver" as STRING
	LOCAL fMes:="Determining frequency of givers" as STRING
	LOCAL Frequency_types:={{"First giver",1},{"Not given last 2 years",2},{"Not given last year",3},{"Given last year",4},{"Regular giver",5}}
	LOCAL time1 as STRING
	LOCAL lDiff:=self:DiffBox as LOGIC

	time1:=Time()
	self:STATUSMESSAGE(sMes+" ("+ElapTime(time1,Time())+")")

	// Build accStr to be a comma separated list of account numbers enclosed in parentheses
	aAcc:=self:oDCSubSet:GetSelectedItems()
	ASort(aAcc)          
	accStr:="("
	for i:=1 to Len(aAcc)-1
		accStr+=Str(aAcc[i],-1) + ","
	next
	accStr+=Str(aAcc[Len(aAcc)],-1) + ")"
	
	// Build aPeriod to contain the start dates of the periods to examine. Thus if aPeriod contains
	// the dates A, B, C, and D, the interesting periods will be:
	//     A to B-1
	//     B to C-1
	//     C to D-1

	// Determine periods:
	StartDate:=oDCFromdate:SelectedDate
	EndDate:=oDCTodate:SelectedDate+1 // EndDate is the first date after the date range
	IF IsString(SubPerLen)   // SubPerLen is a string if the user typed a non-standard value in the field
		SubPerLen:=0
	ENDIF
	IF SubPerLen=0 
		// There are no subperiods, so we simply use the entire date range
		AAdd(aPeriod,StartDate)
		AAdd(aPeriod,EndDate)
	ELSE
		// Split the date range into SubPerLen ranges			
		PerStart:=StartDate
		DO WHILE PerStart <= EndDate            
			AAdd(aPeriod,PerStart)
			NextYear:=Year(StartDate)
			NextMonth:=Month(StartDate) + SubPerLen * ++PeriodCount
			DO WHILE NextMonth>12
				NextYear++
				NextMonth-=12
			ENDDO              
			// Make PerStart the last day of the period, taking into account that the following month may be short
			PerStart:=ConDate(NextYear, NextMonth, Min(Day(StartDate), MonthEnd(NextMonth,NextYear) ))
		ENDDO

		IF PeriodCount<=1
			// SubPerLen is greater than the total date range. Emulate SubPerLen=0
			SubPerLen:=0
			AAdd(aPeriod,EndDate)
		ELSE
			// Adjust EndDate to be the end of the last range
			EndDate:=aPeriod[Len(aPeriod)]
		ENDIF
	ENDIF   
	
	IF lDiff
		// also for the previous period:
		PrevPeriodCount:=Len(aPeriod)-1
		ASize(aPeriod,2*PrevPeriodCount+1) // Extend aPeriod to hold start dates of previous subperiods
		IF SubPerLen=0   
			// Make previous period as long as current period, measured in days
			AIns(aPeriod,1)	
			aPeriod[1]:=StartDate - (EndDate-StartDate)
		ELSE
			// Make previous periods as long as current periods, measured in months
			FOR periodNo:=1 to PrevPeriodCount
				PrevYear:=Year(StartDate)
				PrevMonth:=Month(StartDate) - SubPerLen * periodNo
				DO WHILE PrevMonth<1
					PrevYear--
					PrevMonth+=12
				ENDDO								
				// Make PerStart the first day of the period, taking into account that the previous month may be short
				PerStart:=ConDate(PrevYear, PrevMonth, Min(Day(StartDate), MonthEnd(PrevMonth,PrevYear) ))
				AIns(aPeriod,1)	
				aPeriod[1]:=PerStart
			NEXT
		ENDIF
	ENDIF

	self:SqlDoAndTest("DROP TABLE IF EXISTS followingtrans")
	self:SqlDoAndTest("DROP TABLE IF EXISTS followingtrans2")
	self:SqlDoAndTest("DROP TABLE IF EXISTS freqtrans")
	self:SqlDoAndTest("DROP TABLE IF EXISTS freqtrans2")
	self:SqlDoAndTest("DROP TABLE IF EXISTS perslist")
	self:SqlDoAndTest("DROP TABLE IF EXISTS persclass")

	// Build sqlStr2 to contain the subperiod classification string
	if Len(aPeriod)>2
		sqlStr2:="case "
		for periodNo:=2 to Len(aPeriod)-1
			sqlStr2+="when dat<'" + SQLdate(aPeriod[periodNo]) + "' THEN " + Str(periodNo-1,-1) + " "
		next
		sqlStr2+="else " + Str(Len(aPeriod)-1,-1) + " end"
	else
		sqlStr2:="1"
	endif


	self:STATUSMESSAGE(gMes+" ("+ElapTime(time1,Time())+")")

	// Make followingtrans contain all the relevant transactions
	if self:SqlDoAndTest("CREATE TEMPORARY TABLE followingtrans (subperiod int) " ;
		+ UnionTrans("SELECT transid,seqnr,persid,accid," + sqlStr2 + " subperiod,cre-deb amount FROM transaction AS t"; 
		+ " WHERE t.accid in " + accStr + " AND t.persid IS NOT NULL AND t.GC<>'PF' AND t.GC<>'CH' AND" ;
		+ " t.dat>='" +  SQLdate(aPeriod[1]) + "' AND" ;
		+ " t.dat<='" + SQLdate(EndDate-1) + "' AND";
		+ " t.CRE>t.DEB"))
		return nil
	endif                     
		
	self:STATUSMESSAGE(gMes+" ("+ElapTime(time1,Time())+")")
	
	
	
	// Find persid's of all givers   
	if self:SqlDoAndTest("CREATE TEMPORARY TABLE perslist (persid INT, PRIMARY KEY (persid)) SELECT DISTINCT persid FROM followingtrans ORDER BY persid")
		return nil
	endif

	oTrans:=SQLSelect{"SELECT persid FROM perslist",oConn} 
	        
	IF oTrans:RECCOUNT=0
		(WarningBox{self,"Warning","No givers match the specified selection"}):Show()
		oTrans:Close()
   	return nil
	ENDIF

	do WHILE !oTrans:EoF
		AAdd(aPers,oTrans:persid)
		oTrans:Skip()
	ENDDO
	ASort(aPers)
	oTrans:Close()

	IF self:Frequency
		// Determine frequency periods:
		// We shall look at 2 or 4 date ranges each one year long. These will be inspected for giver frequency.
		self:STATUSMESSAGE(fMes+" ("+ElapTime(time1,Time())+")")

		// The first two periods to inspect are the last two years before the "current" periods 
		// The periods always start on the first day of a month
		// We use approximate years of 360 days to avoid overshooting a month start

		PerStart1:=StartDate-360
		PerStart1:=ConDate(Year(PerStart1), Month(PerStart1), 1)

		PerStart2:=PerStart1-360
		PerStart2:=ConDate(Year(PerStart2), Month(PerStart2), 1)
		
		freqStr1:="CASE WHEN t.dat<'" + SQLdate(PerStart2) + "' THEN 1 ";
			+ "WHEN t.dat>='" + SQLdate(PerStart2) + "' AND t.dat<'" + SQLdate(PerStart1) + "' THEN 2 ";
			+ "WHEN t.dat>='" + SQLdate(PerStart1) + "' AND t.dat<'" + SQLdate(StartDate) +"' THEN 3 ";
			+ "ELSE 0 END freq1"

		IF lDiff
			// The other two periods to inspect are the last two years before the "previous" periods
			// The periods always start on the first day of a month
			// We use approximate years of 360 days to avoid overshooting a month start

			PerStart1:=aPeriod[1]-360
			PerStart1:=ConDate(Year(PerStart1), Month(PerStart1), 1)
			
			PerStart2:=PerStart1-360
			PerStart2:=ConDate(Year(PerStart2), Month(PerStart2), 1)

			freqStr2:="CASE WHEN t.dat<'" + SQLdate(PerStart2) + "' THEN 1 ";
				+ "WHEN t.dat>='" + SQLdate(PerStart2) + "' AND t.dat<'" + SQLdate(PerStart1) + "' THEN 2 ";
				+ "WHEN t.dat>='" + SQLdate(PerStart1) + "' AND t.dat<'" + SQLdate(aPeriod[1]) +"' THEN 3 ";
				+ "ELSE 0 END freq2"
		ELSE
			freqStr2:="0 freq2"
		ENDIF

		FrequencyEnd:=StartDate   // Day after last interesting date for frequency considerations 

		// create and fill frequencies:
		aPersFreq:=AReplicate(1,Len(aPers))   // initialize as new givers
		IF lDiff
			aPersPrvFreq:=AReplicate(1,Len(aPers))    // initialize as new givers
		ENDIF     

		// freqtrans will contain all transactions in the frequency periods.
		// We use a crude persid check here. A more exact one will follow below.
		if self:SqlDoAndTest("CREATE TEMPORARY TABLE freqtrans (freq1 int, freq2 int) AS " ;
			+ UnionTrans2("SELECT t.transid,t.seqnr,t.persid," + freqStr1 + "," + freqStr2 + " FROM transaction as t";  
			+ " WHERE t.accid IN " + accStr + " AND t.persid>=" + Str(aPers[1],-1) + " and t.persid<=" + Str(aPers[Len(aPers)],-1) + " " ;
			+ " AND t.GC<>'PF' AND t.GC<>'CH' AND" ;
			+ " t.dat<'" + SQLdate(FrequencyEnd) + "' AND t.CRE>t.DEB ",ConDate(1997,1,1),FrequencyEnd))        // Begin at a very old date 
			return nil
		endif

		// Now join with perslist to remove uninteresting persons. We could not do this in the previous statement
		// because UnionTrans may generate multiple SELECT statements and perslist is a temporary table and therefore
		// can only be used once in a statement.
		if self:SqlDoAndTest("CREATE TEMPORARY TABLE freqtrans2 AS SELECT t.persid,freq1,freq2 FROM freqtrans t,perslist WHERE t.persid=perslist.persid")
			return nil
		endif
		
		// create and fill frequencies:
		aPersFreq:=AReplicate(1,Len(aPers))   // initialize as new givers
		
		sqlStr:="SELECT persid,freq1,COUNT(*) xcount FROM freqtrans2 GROUP BY persid,freq1"  
		oTransFreq:=SQLSelect{sqlStr,oConn} 

		IF oTransFreq:RECCOUNT>0
			DO WHILE !oTransFreq:EoF
				k:=AScanBin(aPers,oTransFreq:persid) 
				DO CASE                
				CASE oTransFreq:freq1=1 // Earlier than two years previously
					IF aPersFreq[k]<2
						aPersFreq[k]:=2  // Given earlier than two years previously
					ENDIF						
				CASE oTransFreq:freq1=2 // Two years previously
					IF aPersFreq[k]<3
						aPersFreq[k]:=3 // Given two years previously
					ENDIF
				CASE oTransFreq:freq1=3 // Last year
					IF Val(oTransFreq:xcount)>=2    // Note: xcount is a Bigint, therefore Val() is required
						aPersFreq[k]:=5 // Given >=2 times last year
					ELSE
						aPersFreq[k]:=4 // Given once last year
					ENDIF
				ENDCASE
				oTransFreq:Skip()
			ENDDO
		ENDIF
		oTransFreq:Close()

		IF lDiff  
			aPersPrvFreq:=AReplicate(1,Len(aPers))    // initialize as new givers
			
			sqlStr:="SELECT persid,freq2,COUNT(*) xcount FROM freqtrans2 GROUP BY persid,freq2"  
			oTransFreq:=SQLSelect{sqlStr,oConn} 

			IF oTransFreq:RECCOUNT>0
				DO WHILE !oTransFreq:EoF
					k:=AScanBin(aPers,oTransFreq:persid) 
					DO CASE
					CASE oTransFreq:freq2=1 // Earlier than two years previously
						IF aPersPrvFreq[k]<2
							aPersPrvFreq[k]:=2  // Given earlier than two years previously
						ENDIF						
					CASE oTransFreq:freq2=2 // Two years previously
						IF aPersPrvFreq[k]<3
							aPersPrvFreq[k]:=3 // Given two years previously
						ENDIF
					CASE oTransFreq:freq2=3 // Last year
						IF Val(oTransFreq:xcount)>=2
							aPersPrvFreq[k]:=5 // Given >=2 times last year
						ELSE
							aPersPrvFreq[k]:=4 // Given once last year
						ENDIF
					ENDCASE
					oTransFreq:Skip()
				ENDDO
			ENDIF
			oTransFreq:Close()
		ENDIF		
	ENDIF   // frequency        


	self:STATUSMESSAGE(pMes+" ("+ElapTime(time1,Time())+")  0% done")
	// Determine Person classes:
	IF self:Age
		j:=0
		nRange:=Val(self:Ranges)
		nCSt:=Len(aClass)+1
		AAdd(aClass,{"BIRTHDATE","Age",0,0})  // unknown
		FOR i:=20 to 80 step nRange
			AAdd(aClass,{"BIRTHDATE","Age",j,i})
			j:=i
		NEXT
		AAdd(aClass,{"BIRTHDATE","Age",80,120}) //fieldname, name, range1, range2
		AAdd(aClassIndex,{"BIRTHDATE",nCSt,Len(aClass),1}) // add to overview
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
		ENDIF
	NEXT


	maxlevel:=Len(aClassIndex)
	IF maxlevel<1
		// default class all
		AAdd(aClassIndex,{"ALL",1,1,0}) // add to overview 
		AAdd(aClass,{"ALL","All",0,"All"})
		maxlevel:=1
	ENDIF
	self:AddClass(aClassTuples,"",1,maxlevel,aClassIndex)

	// Determine classes per person:
	
	if self:SqlDoAndTest("CREATE TEMPORARY TABLE persclass (" ;
		+ "persid int(11) NOT NULL," ; 
		+ "classindex int(11) NOT NULL," ;
		+ "prevclassindex int(11) NOT NULL," ;
		+ "PRIMARY KEY (persid)" ;
		+ ") ENGINE=MyISAM")
		return nil
	endif


	TrCnt:=0
	insCount:=0
	insSep:=""
	sqlStr2:=""
	oPers:=SQLSelect{"select * from person",oConn}
	IF oPers:RECCOUNT=0
		(ErrorBox{self,"Database table 'person' is empty"}):Show()
		oPers:Close()
		return nil
	ENDIF
	do WHILE !oPers:EoF
		TrCnt++
		IF TrCnt>=500
			self:STATUSMESSAGE(pMes+" ("+ElapTime(time1,Time())+")   " + Str(oPers:RecNo*100/oPers:RECCOUNT,-1,0) + "% done")
			TrCnt:=0
		ENDIF	

		k:=AScanBin(aPers,oPers:persid)
		if k=0
			oPers:Skip()
			loop
		endif

		cSearch:=""
		cSep:=""

		// In the following code, for most classes nClassPtr will be set to the index of the relevant entry in aClass, but
		// for the FREQUENCY class, nClassPtr2 will be the index of the entry for the current period and nClassPtr1 will be 
		// the index for the entry for the previous period.
		// Also, for most classes cSearch will contain the relevant class value; but for the FREQUENCY class, cSearch will
		// contain the string %FR% which will then later be replaced by the appropriate value, derived from nClassPtr2 or
		// nClassPtr1.

		nClassPtr2:=0
		nClassPtr1:=0
		FOR i:=1 to maxlevel
			cName:=aClassIndex[i,1]
			nCount:=aClassIndex[i,3]+1-aClassIndex[i,2]
			fType:=aClassIndex[i,4]
			IF fType=3 .or. fType=4   // Extra properties
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
			ELSEIF fType=2 // Frequency
				nFreq:=aPersFreq[k]
				nClassPtr2:=AScan(aClass,{|x| nFreq==x[3]},aClassIndex[i,2],nCount)
				IF lDiff
					nFreq:=aPersPrvFreq[k]
					nClassPtr1:=AScan(aClass,{|x| nFreq==x[3]},aClassIndex[i,2],nCount)
				ENDIF
			ELSEIF !cName=="ALL"
				uFieldValue:=oPers:FIELDGET(cName)
			ENDIF
			IF cName=="BIRTHDATE"
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
			IF fType=2 // Frequency
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
			persValuePtr:=AScan(aClassTuples,cSearch)
			IF lDiff
				IF !Empty(nClassPtr1)
					cSearch:=StrTran(cSearchOrg,"%FR%",AllTrim(Str(nClassPtr1)))
					persValuePtrPrv:=AScan(aClassTuples,cSearch)
				ELSE
					persValuePtrPrv:=persValuePtr
				ENDIF
				sqlStr2+=insSep + "(" ;
					+Str(oPers:persid,-1)+"," ;
					+Str(persValuePtr,-1)+"," ;
					+Str(persValuePtrPrv,-1)+")" 
			ELSE
				sqlStr2+=insSep + "(" ;
					+Str(oPers:persid,-1)+"," ;
					+Str(persValuePtr,-1)+"," ;
 					+"0)"
			ENDIF
			insSep:=","  
			
			insCount++
			IF insCount>=200
				if self:SqlDoAndTest("INSERT INTO persclass (persid, classindex, prevclassindex) VALUES " + sqlStr2)
					return nil
				endif
				sqlStr2:=""
				insSep:=""
				insCount:=0
			ENDIF
		ENDIF
		oPers:Skip()
	ENDDO
	oPers:Close()
   IF insCount>=1
		if self:SqlDoAndTest("INSERT INTO persclass (persid, classindex, prevclassindex) VALUES " + sqlStr2)
			return nil
		endif
	ENDIF

	self:STATUSMESSAGE(sMes+" ("+ElapTime(time1,Time())+")")

	// Create consolidated table

	if self:SqlDoAndTest("CREATE TEMPORARY TABLE followingtrans2 as (" ;
		+ "SELECT f.transid,f.seqnr,f.subperiod,f.persid,sum(f.amount) amount,IF (f.subperiod<=" + Str(PrevPeriodCount,-1) + ",p.prevclassindex,p.classindex) classindex ";
		+ "FROM followingtrans f,persclass p WHERE f.persid=p.persid " ;
		+ "GROUP by f.persid,f.subperiod)")
		return nil
	endif

	// Determine which members of aClassTuples are relevant
	aRelevantClass:=AReplicate(.F.,Len(aClassTuples))
	sqlStr:="SELECT classindex FROM followingtrans2 GROUP BY classindex HAVING count(*)>0"
	oTrans:=SQLSelect{sqlStr,oConn}
	IF oTrans:RECCOUNT>0
		DO WHILE !oTrans:EoF
			aRelevantClass[oTrans:classindex]:=.T.
			oTrans:Skip()
		ENDDO
	ENDIF
	oTrans:Close()

	// Note: Len(aPeriod) is one greater that the number of periods
	aMatrix1:=ArrayNew(Len(aPeriod))
	aMatrix2:=ArrayNew(Len(aPeriod))
	aMatrix3:=ArrayNew(Len(aPeriod))
	aMatrix4:=ArrayNew(Len(aPeriod))
	aMatrix5:=ArrayNew(Len(aPeriod))
	aMatrix6:=ArrayNew(Len(aPeriod))
	aMatrix7:=ArrayNew(Len(aPeriod))    

	for periodNo:=1 to Len(aPeriod)
		aMatrix1[periodNo]:=AReplicate(0,Len(aClassTuples)+1)
		aMatrix2[periodNo]:=AReplicate(0,Len(aClassTuples)+1)
		aMatrix3[periodNo]:=AReplicate(0,Len(aClassTuples)+1)
		aMatrix4[periodNo]:=AReplicate(0,Len(aClassTuples)+1)
		aMatrix5[periodNo]:=AReplicate(0,Len(aClassTuples)+1)
		aMatrix6[periodNo]:=AReplicate(0,Len(aClassTuples)+1)
		aMatrix7[periodNo]:=AReplicate(0,Len(aClassTuples)+2)

		aMatrix1[periodNo,1]:=nil
		aMatrix2[periodNo,1]:=nil
		aMatrix3[periodNo,1]:=nil
		aMatrix4[periodNo,1]:=nil
		aMatrix5[periodNo,1]:=nil
		aMatrix6[periodNo,1]:=nil
		aMatrix7[periodNo,1]:=nil
		aMatrix7[periodNo,2]:=iif(periodNo=1, nil, AReplicate(0,NumberRanges))
	NEXT		
	
	FOR classNo:=1 to Len(aClassTuples)
		if aRelevantClass[classNo]
			aClassPtr:=Split(aClassTuples[classNo],",")
			cClassName:=""
			FOR j:=1 to Len(aClassPtr)
				k:=Val(aClassPtr[j])
				IF aClass[k,1]="BIRTHDATE"
					IF aClass[k,3]=0
						cClassName+=oLan:Get(aClass[k,2])+" is unknown "
					ELSE
						cClassName+=oLan:Get(aClass[k,2])+"="+AllTrim(Str(aClass[k,3]))+" - "+AllTrim(Str(aClass[k,4]))+" "
					ENDIF
				ELSEIF aClass[k,1]="TYPE" .or. aClass[k,1]="GENDER" .or. aClass[k,1]="FREQUENCY" .or. aClass[k,1]="ALL"
					cClassName+=oLan:Get(aClass[k,4])+" "
				ELSE
					cClassName+=oLan:Get(aClass[k,2])+"="+oLan:Get(aClass[k,4])+" "
				ENDIF
			NEXT
			aMatrix1[1,classNo+1]:=cClassName
			aMatrix2[1,classNo+1]:=cClassName
			aMatrix3[1,classNo+1]:=cClassName
			aMatrix4[1,classNo+1]:=cClassName
			aMatrix5[1,classNo+1]:=cClassName
			aMatrix6[1,classNo+1]:=cClassName
			aMatrix7[1,classNo+2]:=cClassName
		ENDIF
	NEXT
	FOR periodNo:=1 to Len(aPeriod)-1
		aMatrix1[periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix2[periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix3[periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix4[periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix5[periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix6[periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix7[periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
	NEXT
	// determine subtotals per period:
	PerTotal:=AReplicate(0.00,Len(aPeriod)-1)
	PerCount:=AReplicate(0,Len(aPeriod)-1)

	oTrans:=SQLSelect{"SELECT subperiod,classindex,sum(amount) sumamount,count(*) xcount " ;
		+ "FROM followingtrans2 GROUP BY subperiod,classindex",oConn}

	// Note: oTrans:xcount is a Bigint therefore we need to use Val() on it 

	IF oTrans:RECCOUNT>0
		DO WHILE !oTrans:EoF
			aMatrix1[oTrans:subperiod+1, oTrans:classindex+1] := oTrans:sumamount
			aMatrix3[oTrans:subperiod+1, oTrans:classindex+1] := Val(oTrans:xcount)   
			oTrans:Skip()
		ENDDO
	ENDIF
	oTrans:Close()

	oTrans:=SQLSelect{"SELECT subperiod,max(amount) maxamount,sum(amount) sumamount,count(*) xcount " ;
		+ "FROM followingtrans2 GROUP BY subperiod",oConn}

	IF oTrans:RECCOUNT>0
		DO WHILE !oTrans:EoF
			// determine ranges from average per period:
			IF oTrans:subperiod>PrevPeriodCount.and.Val(oTrans:xcount)>0
				rangeVal:=Round(oTrans:sumamount/(NumberRanges*Val(oTrans:xcount)), 0)
				IF rangeVal >0
					FOR m:=1 to self:NumberRanges-1
						aMatrix7[oTrans:subperiod+1,2,m]:=Round(m*rangeVal,0)
					NEXT
					aMatrix7[oTrans:subperiod+1,2,NumberRanges]:=oTrans:maxamount
				ENDIF			
			ENDIF
			PerTotal[oTrans:subperiod]:=oTrans:sumamount
			PerCount[oTrans:subperiod]:=Val(oTrans:xcount)
			oTrans:Skip()
		ENDDO
	ENDIF
  	oTrans:Close()

	self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")")
	
	// Fill	Matrices:
	FOR periodNo:=1 to Len(aPeriod)-1
		FOR classNo:=1 to Len(aClassTuples)
			IF aRelevantClass[classNo]
				IF PerTotal[periodNo]>0
					aMatrix2[periodNo+1,classNo+1]:=Round((aMatrix1[periodNo+1,classNo+1]*100)/PerTotal[periodNo],2)
				ENDIF
				IF PerCount[periodNo]>0
					aMatrix4[periodNo+1,classNo+1]:=Round((aMatrix3[periodNo+1,classNo+1]*100)/PerCount[periodNo],2)
				ENDIF

				// aMatrix3[periodNo+1,classNo+2] contains the number of donations with subperiod=periodNo and classindex=classNo
				donationsCount:=aMatrix3[periodNo+1,classNo+1]
				IF donationsCount>0
					aMatrix5[periodNo+1,classNo+1]:=Round(aMatrix1[periodNo+1,classNo+1]/donationsCount,2)

					IF StatBox6
						// Median calculation:
						
						sqlStr:="SELECT amount FROM " ;
							+ "(SELECT amount FROM followingtrans2 WHERE subperiod=" + Str(periodNo,-1) + " AND classindex=" + Str(classNo,-1) + " ORDER BY amount) t " ;
							+ "LIMIT " + Str(Floor((donationsCount-1)/2),-1) + ",2"

						oTrans:=SQLSelect{sqlStr, oConn}       
// 						SQLStatement{'INSERT INTO log (txt) VALUES("' + sqlStr + '")',oConn}:Execute() 

						median:=oTrans:amount

						IF donationsCount%2=0
							// We have an even number of entries
							oTrans:Skip()
							median:=(median+oTrans:amount)/2
						ENDIF
						aMatrix6[periodNo+1,classNo+1]:=median
						oTrans:Close()
					endif
				ENDIF

				aMatrix7[periodNo+1,classNo+2]:=AReplicate(0,NumberRanges)
			ENDIF      
		NEXT

		IF StatBox7.and.periodNo>PrevPeriodCount
			// sqlStr2 is the range classifier
			sqlStr2:="CASE "
			for j:=1 to NumberRanges-1
				sqlStr2+="WHEN amount<=" + Str(aMatrix7[periodNo+1,2,j],-1) + " THEN " + Str(j) + " "
			next
			sqlStr2+="ELSE " + Str(NumberRanges,-1) + " END"
			
			sqlStr:="SELECT " + sqlStr2 + " xrange, classindex, count(*) xcount FROM followingtrans2 " ;
				+ "WHERE subperiod=" + Str(periodNo,-1) + " GROUP BY classindex,xrange"
			
			oTrans:=SQLSelect{sqlStr,oConn}				
// 			SQLStatement{'INSERT INTO log (txt) VALUES("' + sqlStr + '")',oConn}:Execute() 
			
			if oTrans:RECCOUNT<>0 
				DO WHILE !oTrans:EoF
					IF oTrans:xcount<>0
						aMatrix7[periodNo+1,oTrans:classindex+2,oTrans:xrange]:=Val(oTrans:xcount)
					endif
					oTrans:Skip()
				ENDDO
			ENDIF
			oTrans:Close()
		ENDIF
	NEXT  
	self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")")

	// Markup report from matrix:
	oFileSpec:=AskFileName(self,"DonorFollowing"+DToS(StartDate)+"_"+DToS(EndDate-1),"Creating Donor Following-report",'*.XLS',"Excel Spreadsheet") 
	IF oFileSpec==null_object
		return nil
	ENDIF
	cFileName:=oFileSpec:FullPath
	ptrHandle := MakeFile(self,@cFileName,"Creating DonorFollowing-report")

	IF !ptrHandle = F_ERROR .and. !ptrHandle==nil
		oFileSpec:FullPath:=cFileName
		// header record:
		FWriteLine(ptrHandle,"<html><body><table style='font-family: Arial;' border='2'><tr style='font-weight: bold; color:navy;'>"+;
			"<td style='text-align : center;' colspan='"+Str(Len(aPeriod)-PrevPeriodCount,-1)+"'>"+oLan:Get("Donor Following Report")+"  "+;
			oLan:Get("period")+": "+DToC(StartDate)+" - "+DToC(EndDate-1)+"</td></tr>")
		FWriteLine(ptrHandle,"<tr><td colspan='"+Str(Len(aPeriod)-PrevPeriodCount,-1)+"'>"+oLan:Get("Destinations")+":<br><ol>")
		FOR i:=1 to Len(aAcc)
			oAcc:=SQLSelect{"select description from account where giftalwd and accid=" + Str(aAcc[i],-1) ,oConn}
			IF oAcc:RECCOUNT>0
				FWriteLine(ptrHandle,"<li>"+AllTrim(oAcc:Description)+"</li>")
			ENDIF      
			oAcc:Close()
		NEXT
		FWriteLine(ptrHandle,"</ol></td></tr>")
		IF StatBox1
			self:MarkupMatrix(ptrHandle,aMatrix1,"amount given per class of givers",PrevPeriodCount,aRelevantClass,1)
		ENDIF
		IF StatBox2
			self:MarkupMatrix(ptrHandle,aMatrix2,"percentage of total amount given, a certain class of givers has contributed",PrevPeriodCount,aRelevantClass,1)
		ENDIF
		IF StatBox3
			self:MarkupMatrix(ptrHandle,aMatrix3,"number of givers per class of givers",PrevPeriodCount,aRelevantClass,1)
		ENDIF
		IF StatBox4
			self:MarkupMatrix(ptrHandle,aMatrix4,"percentage of total number of givers, a certain class of givers has contributed",PrevPeriodCount,aRelevantClass,1)
		ENDIF
		IF StatBox5
			self:MarkupMatrix(ptrHandle,aMatrix5,"average amount given per class of givers",PrevPeriodCount,aRelevantClass,1)
		ENDIF
		IF StatBox6
			self:MarkupMatrix(ptrHandle,aMatrix6,"median amount given per class of givers",PrevPeriodCount,aRelevantClass,1)
		ENDIF
		IF StatBox7
			self:MarkupMatrix(ptrHandle,aMatrix7,"spread over ranges of amounts given per class of givers ",PrevPeriodCount,aRelevantClass,2)
		ENDIF
		// closing record:
		FWriteLine(ptrHandle,"<table></body></html>")
		FClose(ptrHandle)
		self:STATUSMESSAGE("")
		self:Pointer := Pointer{POINTERARROW}

		// Show with excel:
		FileStart(oFileSpec:FullPath,self)
	ENDIF
	//LogEvent(SELF,"total time:"+ElapTime(time1,Time()))	

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
	LOCAL oAccount as SQLSelect     
	IF Empty(omAcc) .or.omAcc:RecCount<1
		RETURN
	ENDIF
	oAccount:=omAcc
	IF ItemName == "From Account"
		self:FromAccount:= LTrimZero(oAccount:accnumber)
		self:oDCFromAccount:TEXTValue := FromAccount
		self:cFromAccName := FromAccount
		self:oDCTextfrom:Caption := AllTrim(oAccount:Description)
		self:oDCSubSet:AccNbrStart:=self:FromAccount
	ELSEIF ItemName == "Till Account"
		self:ToAccount:= LTrimZero(oAccount:accnumber)
		self:oDCToAccount:TEXTValue := ToAccount
		self:cToAccName := ToAccount
		self:oDCTextTill:Caption := AllTrim(oAccount:Description)
		self:oDCSubSet:AccNbrEnd:=ToAccount
	ENDIF
		
RETURN true
METHOD SetPropExtra( Count) CLASS DonorFollowingReport
	LOCAL oCheck as CheckBox
	LOCAL oDCGroupBoxExtra	as GROUPBOX
	LOCAL Name as STRING,Type, ID as int, Values as STRING
	LOCAL myDim as Dimension
	LOCAL myOrg as Point
	LOCAL aValues as ARRAY
	LOCAL NewY:=self:oDCFrequency:Origin:Y as int
	IF pers_propextra[Count,3]==TEXTBX
		// skip textboxes
		RETURN
	ENDIF
	Name:=pers_propextra[Count,1]
	ID := pers_propextra[Count,2]
	//
	// enlarge window
	myDim:=self:Size
	myDim:Height+=25
	self:Size:=myDim
	myOrg:=self:Origin
	myOrg:y-=25
	self:Origin:=myOrg
	//
	// shift statistical group down
	myOrg:=self:oDCStatisticsBox:Origin
	myOrg:y-=25
	self:oDCStatisticsBox:Origin:=myOrg
	myOrg:=self:oDCStatBox1:Origin
	myOrg:y-=25
	self:oDCStatBox1:Origin:=myOrg
	myOrg:=self:oDCStatBox2:Origin
	myOrg:y-=25
	self:oDCStatBox2:Origin:=myOrg
	myOrg:=self:oDCStatBox3:Origin
	myOrg:y-=25
	self:oDCStatBox3:Origin:=myOrg
	myOrg:=self:oDCStatBox4:Origin
	myOrg:y-=25
	self:oDCStatBox4:Origin:=myOrg
	myOrg:=self:oDCStatBox5:Origin
	myOrg:y-=25
	self:oDCStatBox5:Origin:=myOrg
	myOrg:=self:oDCStatBox6:Origin
	myOrg:y-=25
	self:oDCStatBox6:Origin:=myOrg
	myOrg:=self:oDCStatBox7:Origin
	myOrg:y-=25
	self:oDCStatBox7:Origin:=myOrg
	myOrg:=self:oDCNumberRanges:Origin
	myOrg:y-=25
	self:oDCNumberRanges:Origin:=myOrg
	myOrg:=self:oDCFixedTextRanges:Origin
	myOrg:y-=25
	self:oDCFixedTextRanges:Origin:=myOrg
	myOrg:=self:oDCDiffBox:Origin
	myOrg:y-=25
	self:oDCDiffBox:Origin:=myOrg
	
	// enlarge PropertiesBox group:
	myDim:=self:oDCPropertiesBox:Size
	myDim:Height+=25
	self:oDCPropertiesBox:Size:=myDim
	myOrg:=self:oDCPropertiesBox:Origin
	myOrg:y-=25
	self:oDCPropertiesBox:Origin:=myOrg
	//
//	insert extra properties as checkboxes in group PropertiesBox:	
	oCheck:=CheckBox{self,Count,Point{29,NewY},Dimension{215,20},Name}
	oCheck:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name,"V"+AllTrim(Str(ID,-1))}
	AAdd(self:aPropEx,oCheck)
	oCheck:Show()
RETURN nil
	
	
METHOD SqlDoAndTest(sqlStr) CLASS DonorFollowingReport
	// Execute an SQL statement an check for errors
	// Returns .T. if an error occurred, .F. otherwise
	LOCAL sqlSt as SQLStatement
	LOCAL sqlErrinfo as SQLErrorInfo
	LOCAL errStr as STRING

	SQLStatement{'INSERT INTO log (txt) VALUES("' + sqlStr + '")',oConn}:Execute() 

	sqlSt:=SQLStatement{sqlStr,oConn}
	sqlSt:Execute()
 	sqlErrinfo:=sqlSt:ErrInfo
    IF !sqlErrinfo:ErrorFlag
    	sqlSt:FreeStmt(SQL_DROP)
    	RETURN .F.
    ENDIF

 	// An SQL error occured
 	errStr:='SQL Error: "' + sqlErrinfo:ErrorMessage + '" **** In SQL statement: "' 
	IF Len(sqlStr)>1000
		errStr += SubStr(sqlStr,1,1000) + '..."'
	ELSE
		errStr += sqlStr + '"'
	ENDIF
	     	
	(ErrorBox{self,errStr}):Show()
  	sqlSt:FreeStmt(SQL_DROP)

	RETURN .T.
   

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
	AccountSelect(self,AllTrim(oDCToAccount:TEXTValue ),"Till Account",lUnique,"GiftAlwd",,)

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
STATIC DEFINE DONORFOLLOWINGREPORT_CANCELBUTTON := 135 
STATIC DEFINE DONORFOLLOWINGREPORT_DIFFBOX := 136 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT1 := 128 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT10 := 143 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT2 := 107 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT3 := 129 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT6 := 139 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT7 := 132 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT8 := 140 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT9 := 142 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXTRANGES := 126 
STATIC DEFINE DONORFOLLOWINGREPORT_FREQUENCY := 115 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMACCBUTTON := 104 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMACCOUNT := 103 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMDATE := 137 
STATIC DEFINE DONORFOLLOWINGREPORT_GENDER := 110 
STATIC DEFINE DONORFOLLOWINGREPORT_GROUPBOX1 := 127 
STATIC DEFINE DONORFOLLOWINGREPORT_GROUPBOX3 := 141 
STATIC DEFINE DONORFOLLOWINGREPORT_HOMEBOX := 101 
STATIC DEFINE DONORFOLLOWINGREPORT_NONHOMEBOX := 102 
STATIC DEFINE DONORFOLLOWINGREPORT_NUMBERRANGES := 125 
STATIC DEFINE DONORFOLLOWINGREPORT_OKBUTTON := 133 
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
STATIC DEFINE DONORFOLLOWINGREPORT_STATISTICSBOX := 117 
STATIC DEFINE DONORFOLLOWINGREPORT_SUBPERLEN := 108 
STATIC DEFINE DONORFOLLOWINGREPORT_SUBSET := 134 
STATIC DEFINE DONORFOLLOWINGREPORT_TEXTFROM := 130 
STATIC DEFINE DONORFOLLOWINGREPORT_TEXTTILL := 131 
STATIC DEFINE DONORFOLLOWINGREPORT_TOACCBUTTON := 106 
STATIC DEFINE DONORFOLLOWINGREPORT_TOACCOUNT := 105 
STATIC DEFINE DONORFOLLOWINGREPORT_TODATE := 138 
STATIC DEFINE DONORFOLLOWINGREPORT_TYPE := 114 
CLASS DonorFolwngSelClasses INHERIT DialogWinDowExtra 

	PROTECT oDCFixedText1 as FIXEDTEXT
	PROTECT oDCClassesBox as LISTBOX
	PROTECT oCCOKButton as PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  Protect oCaller as Object
resource DonorFolwngSelClasses DIALOGEX  5, 20, 271, 125
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Donor following Report - export classes of persons"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Select one or more classes of persons to be exported", DONORFOLWNGSELCLASSES_FIXEDTEXT1, "Static", WS_CHILD, 4, 7, 200, 12
	CONTROL	"", DONORFOLWNGSELCLASSES_CLASSESBOX, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 4, 22, 204, 96, WS_EX_CLIENTEDGE
	CONTROL	"OK", DONORFOLWNGSELCLASSES_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 212, 22, 55, 11
END

METHOD Init(oParent,uExtra) CLASS DonorFolwngSelClasses 
LOCAL dim aFonts[1] as OBJECT

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"DonorFolwngSelClasses",_GetInst()},true)

aFonts[1] := Font{,9,"Microsoft Sans Serif"}

oDCFixedText1 := FixedText{self,ResourceID{DONORFOLWNGSELCLASSES_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Select one or more classes of persons to be exported",null_string,null_string}
oDCFixedText1:Font(aFonts[1], FALSE)

oDCClassesBox := ListBox{self,ResourceID{DONORFOLWNGSELCLASSES_CLASSESBOX,_GetInst()}}
oDCClassesBox:HyperLabel := HyperLabel{#ClassesBox,null_string,"Click on a row to (de)select",null_string}
oDCClassesBox:UseHLforToolTip := true

oCCOKButton := PushButton{self,ResourceID{DONORFOLWNGSELCLASSES_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",null_string,null_string}

self:Caption := "Donor following Report - export classes of persons"
self:HyperLabel := HyperLabel{#DonorFolwngSelClasses,"Donor following Report - export classes of persons",null_string,null_string}

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

RETURN nil
method PostInit(oParent,uExtra) class DonorFolwngSelClasses
	//Put your PostInit additions here 
	// fill selectbox:
	self:SetTexts()
	if IsArray(uExtra)
		oCaller:=uExtra[1]
		oDCClassesBox:FillUsing(uExtra[2])
	endif
	return nil

STATIC DEFINE DONORFOLWNGSELCLASSES_CLASSESBOX := 101 
STATIC DEFINE DONORFOLWNGSELCLASSES_FIXEDTEXT1 := 100 
STATIC DEFINE DONORFOLWNGSELCLASSES_OKBUTTON := 102 
CLASS DonorProject INHERIT DataWindowExtra 

	EXPORT oDCFromdate as DATESTANDARD
	EXPORT oDCTodate as DATESTANDARD
	EXPORT oDCDestinations as GROUPBOX
	EXPORT oDCFixedText3 as FIXEDTEXT
	EXPORT oCCOKButton as PUSHBUTTON
	EXPORT oCCCancelButton as PUSHBUTTON
	EXPORT oDCFixedText6 as FIXEDTEXT
	EXPORT oDCFixedText7 as FIXEDTEXT
	EXPORT oDCFixedText5 as FIXEDTEXT

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	PROTECT aDestGrp:={} as ARRAY // {name,{acc1,acc2,...}
	PROTECT aGiftAcc:={} as ARRAY // accountIds+name for projects ( non-member accounts with gift allowed and home member entities)
	PROTECT aGiftAccHomeMbr:={} as ARRAY // accountIds+name for home members (non entity)
	PROTECT aGiftAccForeignMbr:={} as ARRAY // accountIds+name for non home members
	PROTECT aDestAccSet:={} as ARRAY // array with listbox controls
	PROTECT aDestName:={} as ARRAY // array with singlelineedit controls
	PROTECT nID as int
	PROTECT pwvs as WindowVerticalScrollBar     

resource DonorProject DIALOGEX  34, 31, 442, 1308
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
	self:EndWindow()
	RETURN nil
METHOD Close(oEvent) CLASS DonorProject
	SUPER:Close(oEvent)
	//Put your changes here
	self:EndWindow()
	RETURN nil

METHOD DeselectAccount(nCur,nPos) CLASS DonorProject
	// remove deselected account form group
	LOCAL myDim as Dimension
	LOCAL myOrg as Point
	LOCAL i as int
	LOCAL oControl as CONTROL
	// remove from own accounts:
	ADel(self:aDestGrp[nCur,2],nPos)
	ASize(self:aDestGrp[nCur,2],Len(self:aDestGrp[nCur,2])-1)
	IF nCur>3 .and.Len(self:aDestGrp[nCur,2])=0
	// empty group, remove it:
		ADel(self:aDestGrp,nCur)
		ASize(self:aDestGrp,Len(self:aDestGrp)-1)
		(self:aDestName[nCur-2]):Destroy()
		(self:aDestAccSet[nCur-2]):Destroy()
		ADel(self:aDestName,nCur-2)
		ASize(self:aDestName,Len(self:aDestName)-1)
		ADel(self:aDestAccSet,nCur-2)
		ASize(self:aDestAccSet,Len(self:aDestAccSet)-1)
		// shift groups below up
		FOR i:=nCur-2 to Len(self:aDestAccSet)
			oControl:=self:aDestAccSet[i]
			myOrg:=oControl:Origin
			myOrg:y+=115
			oControl:Origin:=myOrg
			oControl:=self:aDestName[i]
			myOrg:=oControl:Origin
			myOrg:y+=115
			oControl:Origin:=myOrg
		NEXT
		// shortens groupbox
		myDim:=self:oDCDestinations:Size
		myDim:Height-=115
		self:oDCDestinations:Size:=myDim
		myOrg:=self:oDCDestinations:Origin
		myOrg:y+=115
		self:oDCDestinations:Origin:=myOrg	
		// shortens window
		myDim:=self:Size
		myDim:Height-=115
		self:Size:=myDim
		myOrg:=self:Origin
		myOrg:y+=115
		self:Origin:=myOrg		
		nCur:=0
	ENDIF						
	

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS DonorProject 
LOCAL dim aFonts[2] as OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"DonorProject",_GetInst()},iCtlID)

aFonts[1] := Font{,8,"Microsoft Sans Serif"}
aFonts[1]:Bold := true
aFonts[2] := Font{,10,"Microsoft Sans Serif"}
aFonts[2]:Bold := true

oDCFromdate := DateStandard{self,ResourceID{DONORPROJECT_FROMDATE,_GetInst()},Point{73, 2070},Dimension{180, 22}}
oDCFromdate:FieldSpec := transaction_DAT{}
oDCFromdate:HyperLabel := HyperLabel{#Fromdate,null_string,null_string,null_string}

oDCTodate := DateStandard{self,ResourceID{DONORPROJECT_TODATE,_GetInst()},Point{292, 2070},Dimension{180, 22}}
oDCTodate:FieldSpec := transaction_DAT{}
oDCTodate:HyperLabel := HyperLabel{#Todate,null_string,null_string,null_string}

oDCDestinations := GroupBox{self,ResourceID{DONORPROJECT_DESTINATIONS,_GetInst()},Point{12, 2022},Dimension{625, 40}}
oDCDestinations:HyperLabel := HyperLabel{#Destinations,"Compose groups of projects",null_string,null_string}

oDCFixedText3 := FixedText{self,ResourceID{DONORPROJECT_FIXEDTEXT3,_GetInst()},Point{301, 2029},Dimension{248, 20}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Click to (de)select corresponding accounts:",null_string,null_string}
oDCFixedText3:Font(aFonts[1], FALSE)
oDCFixedText3:TextColor := Color{128,64,64}

oCCOKButton := PushButton{self,ResourceID{DONORPROJECT_OKBUTTON,_GetInst()},Point{571, 2095},Dimension{80, 20}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",null_string,null_string}
oCCOKButton:UseHLforToolTip := False
oCCOKButton:OwnerAlignment := OA_PX

oCCCancelButton := PushButton{self,ResourceID{DONORPROJECT_CANCELBUTTON,_GetInst()},Point{571, 2071},Dimension{80, 20}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",null_string,null_string}
oCCCancelButton:OwnerAlignment := OA_PX

oDCFixedText6 := FixedText{self,ResourceID{DONORPROJECT_FIXEDTEXT6,_GetInst()},Point{12, 2072},Dimension{57, 20}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"From Date:",null_string,null_string}

oDCFixedText7 := FixedText{self,ResourceID{DONORPROJECT_FIXEDTEXT7,_GetInst()},Point{264, 2072},Dimension{24, 20}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Till:",null_string,null_string}

oDCFixedText5 := FixedText{self,ResourceID{DONORPROJECT_FIXEDTEXT5,_GetInst()},Point{13, 2095},Dimension{542, 22}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Give insight who has given to which destination during a certain period of time",null_string,null_string}
oDCFixedText5:Font(aFonts[2], FALSE)

self:Caption := "Donor versus Project Report"
self:HyperLabel := HyperLabel{#DonorProject,"Donor versus Project Report",null_string,null_string}
self:OwnerAlignment := OA_TOP_AUTOSIZE
self:PreventAutoLayout := False

if !IsNil(oServer)
	self:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListBoxSelect(oControlEvent) CLASS DonorProject
	LOCAL oControl as CONTROL, uValue as USUAL
	LOCAL lSelected as LOGIC
	LOCAL nItem,i,j,k,nCur,nSel as int
	LOCAL oList as ListBox

	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	// select or deselect account
	// adapt arrays
	// resfresh screen
	IF Upper(oControl:Name)="SUBACCSET"
		nCur:=AScan(self:aDestAccSet,{|oList|oList:Name==oControl:Name})+2
		oList:=self:aDestAccSet[nCur-2]
		
		IF oList:SelectedCount>Len(self:aDestGrp[nCur,2])
			// more selected than before
			// determine new item:
			k:=oList:FirstSelected()
			nSel:=0
			DO WHILE k>0
				IF (AScan(self:aDestGrp[nCur,2],oList:GetItemValue(k)))=0
					exit
				ENDIF
				k:=oList:NextSelected()
			ENDDO
			// new item selected:
			uValue:=oList:GetItemValue(k)
			oList:SetTop(k)
			// add to own accounts:
			AAdd(self:aDestGrp[nCur,2],uValue)					
			// remove from other groups:
			FOR i:=3 to Len(self:aDestGrp)
				IF i#nCur
					IF (j:=AScan(self:aDestGrp[i,2],uValue))>0
						// deselect item:
						oList:=self:aDestAccSet[i-2]
						k:=oList:FirstSelected()
						DO WHILE k>0
							IF uValue==oList:GetItemValue(k)
								oList:DeselectItem(k)
								//ADel(SELF:aDestGrp[i,2],j)
								//ASize(SELF:aDestGrp[i,2],Len(SELF:aDestGrp[i,2])-1)
								self:DeselectAccount(i,j)
								exit
							ENDIF
							k:=oList:NextSelected()
						ENDDO
						// make first selected current:
						k:=oList:FirstSelected()
						IF k>0
							oList:SetTop(k)
						ENDIF
						exit
					ENDIF
				ENDIF
			NEXT
		ELSE
			// deselect
			// determine item:
			oList:=oControl
			nSel:=0
			FOR i:=1 to Len(self:aDestGrp[nCur,2])
				k:=oList:FirstSelected()
				nSel:=0
				DO WHILE k>0
					IF self:aDestGrp[nCur,2,i]==oList:GetItemValue(k)
						nSel:=i
						exit
					ENDIF
					k:=oList:NextSelected()
				ENDDO
				IF nSel==0
					// found:
					uValue:=self:aDestGrp[nCur,2,i]
					// remove from own accounts:
					self:DeselectAccount(@nCur,i)						
					// make it current again:
					FOR j:=1 to oList:ItemCount
						IF uValue==oList:GetItemValue(j)
							oList:SetTop(j)
							exit
						ENDIF
					NEXT
					// add to last group:
					IF nCur=Len(self:aDestGrp)
						// add new group:
						AAdd(self:aDestGrp,{"Other projects"+Str(nCur-1,-1),{uValue}})
						self:SetDestGrp(nCur+1)
					ELSE
						AAdd(self:aDestGrp[Len(self:aDestGrp),2],uValue)
					ENDIF
					self:SetSelected(Len(self:aDestGrp))
					exit
				ENDIF
			NEXT
		ENDIF
	ENDIF
	RETURN nil
METHOD OKButton( ) CLASS DonorProject
	// fill oSys:DestGrps with selected accounts per group:
	LOCAL i, j as int
	LOCAL oSys as SQLSelect
	LOCAL cXMLDoc:="<groups>",cName as STRING
	LOCAL myBox as BoundingBox
	LOCAL myArea as BoundingBox
	LOCAL myDim as Dimension

	myDim:=self:Size
	myBox:=self:CanvasArea
	myArea:=self:WindowArea

	oSys:=SQLSelect{"select destgrps from sysparms",oConn}
	IF oSys:RecCount>0
		FOR i:=3 to Len(aDestGrp)
			cName:=AllTrim((self:aDestName[i-2]):CurrentText)
			IF Empty(cName)
				(ErrorBox{self,"Group name must not be empty!"}):Show()
				(self:aDestName[i-2]):SetFocus()
				RETURN nil
			ENDIF
			self:aDestGrp[i,1]:=cName			
			cXMLDoc+="<group><name>"+cName+"</name>"
			IF i>2
				// save only selected accounts of projects:
				FOR j:=1 to Len(aDestGrp[i,2])
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
	oSys:=null_object

	IF self:oDCTodate:SelectedDate < self:oDCFromdate:SelectedDate
		(ErrorBox{self,"To Date must be behind From Date"}):show()
	ELSE
		self:Pointer := Pointer{POINTERHOURGLASS}
		self:STATUSMESSAGE("Collecting data for the report, please wait...")
		self:PrintReport()
		self:Close()
		self:Pointer := Pointer{POINTERARROW}
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
	self:Size:=myDim
	myOrg:=self:Origin
	myOrg:y+=2000
	self:Origin:=myOrg
   	
	// generate controls and preselect required items per group
	FOR h:=3 to Len(aDestGrp)
		self:SetDestGrp(h)
		self:SetSelected(h)
	NEXT
                      
	if !Empty(GlBalYears)
		OldestYear:=GlBalYears[Len(GlBalYears),1] 
	else
		OldestYear:=MinDate
	endif                      
                      
	StartDate:=OldestYear
	oDCFromdate:DateRange:=DateRange{StartDate,Today()+31}
	oDCTodate:DateRange:=DateRange{StartDate,Today()+31}

	self:oDCFromdate:Value:=Today()-360
	self:oDCFromdate:Value:=self:oDCFromdate:Value - Day(self:oDCFromdate:Value)+1
	self:oDCTodate:Value:=Today() - Day(Today())
	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS DonorProject
	//Put your PreInit additions here
	LOCAL oSys as SQLSelect
	LOCAL oAcc as SQLSelect
	LOCAL oXMLDoc as XMLDocument
	LOCAL childfound, recordfound as LOGIC
	LOCAL ChildName as STRING
	LOCAL Pntr:=0 as int
	LOCAL i,j as int
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
				FOR j:=1 to Len(aGiftAccHomeMbr)
					FWriteLine(ptrHandle,aGiftAccHomeMbr[j]+"<br>")
				NEXT				
				FWriteLine(ptrHandle,"</td>")
			CASE i==2
				FWriteLine(ptrHandle,"<td>")
				FOR j:=1 to Len(aGiftAccForeignMbr)
					FWriteLine(ptrHandle,aGiftAccForeignMbr[j]+"<br>")
				NEXT				
				FWriteLine(ptrHandle,"</td>")
			CASE i>2
				FWriteLine(ptrHandle,"<td>")
				FOR j:=1 to Len(aDestGrp[i,2])
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
	LOCAL oSingle as SingleLineEdit
	LOCAL oList as ListBox
	LOCAL oDCGroupBoxDest as GROUPBOX
	LOCAL Name , ID , Values as STRING
	LOCAL myDim as Dimension
	LOCAL myOrg as Point
	LOCAL aValues as ARRAY
	LOCAL pwvs as WindowVerticalScrollBar
	LOCAL oEvent as ResizeEvent
	Name:=aDestGrp[Count,1]
	nID++
	ID:=Str(nID,-1)
	//
	// enlarge window
	myDim:=self:Size
	myDim:Height+=115
	self:Size:=myDim
	myOrg:=self:Origin
	myOrg:y-=115
	self:Origin:=myOrg
	//
	// enlarge destinations group:
	myDim:=self:oDCDestinations:Size
	myDim:Height+=115
	self:oDCDestinations:Size:=myDim
	myOrg:=self:oDCDestinations:Origin
	myOrg:y-=115
	self:oDCDestinations:Origin:=myOrg
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
	oSingle:=SingleLineEdit{self,Count+200,myOrg,Dimension{230,20},EDITAUTOHSCROLL	}
	oSingle:HyperLabel := HyperLabel{String2Symbol("DestName"+ID),"DestName"+ID,null_string,null_string}
	oSingle:FocusSelect := FSEL_HOME
	AAdd(self:aControls,oSingle)
	oSingle:Show()
	oSingle:Value:=Name
	AAdd(self:aDestName,oSingle)

RETURN nil
METHOD SetSelected(count) CLASS DonorProject
	// set corresponding accounts as selected in Listbox of a destination group
	LOCAL h,i,j,k,grp as int
	LOCAL oList as ListBox
	LOCAL aAcc:= aDestGrp[count,2] as ARRAY
	LOCAL search as int
	oList:=self:aDestAccSet[count-2]
	// select required items:
	FOR j:=1 to oList:ItemCount
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
RETURN nil	
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
LOCAL aAcc:={} as ARRAY
LOCAL cExchAcc, cStart, cEnd as STRING
LOCAL oParent:=self:Owner as DonorFollowingReport
LOCAL aMemHome:=oParent:aMemHome as ARRAY
LOCAL aMemNonHome:=oParent:aMemNonHome as ARRAY
LOCAL aProjects:=oParent:aProjects as ARRAY
LOCAL lHome:=oParent:HomeBox,lNonHome:=oParent:NonHomeBox,lProjects:=oParent:ProjectsBox as LOGIC
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
CLASS TotalsMembers INHERIT DataWindowMine 

	PROTECT oCCOKButton as PUSHBUTTON
	PROTECT oCCCancelButton as PUSHBUTTON
	PROTECT oDCFixedText3 as FIXEDTEXT
	PROTECT oDCFixedText5 as FIXEDTEXT
	PROTECT oDCFromYear as SINGLELINEEDIT
	PROTECT oDCFromMonth as SINGLELINEEDIT
	PROTECT oDCToYear as SINGLELINEEDIT
	PROTECT oDCToMonth as SINGLELINEEDIT
	PROTECT oDCFixedText2 as FIXEDTEXT

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	PROTECT oReport as PrintDialog
	
resource TotalsMembers DIALOGEX  12, 11, 225, 99
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

METHOD CancelButton( ) CLASS TotalsMembers
		self:EndWindow()
RETURN nil
METHOD Close(oEvent) CLASS TotalsMembers
	SUPER:Close(oEvent)
	//Put your changes here
	self:Destroy()
	RETURN nil

ACCESS FromMonth() CLASS TotalsMembers
RETURN self:FieldGet(#FromMonth)

ASSIGN FromMonth(uValue) CLASS TotalsMembers
self:FieldPut(#FromMonth, uValue)
RETURN uValue

ACCESS FromYear() CLASS TotalsMembers
RETURN self:FieldGet(#FromYear)

ASSIGN FromYear(uValue) CLASS TotalsMembers
self:FieldPut(#FromYear, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TotalsMembers 
	LOCAL dim aFonts[1] as OBJECT

	self:PreInit(oWindow,iCtlID,oServer,uExtra)

	SUPER:Init(oWindow,ResourceID{"TotalsMembers",_GetInst()},iCtlID)

	aFonts[1] := Font{,10,"Microsoft Sans Serif"}
	aFonts[1]:Bold := true

	oCCOKButton := PushButton{self,ResourceID{TOTALSMEMBERS_OKBUTTON,_GetInst()}}
	oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",null_string,null_string}

	oCCCancelButton := PushButton{self,ResourceID{TOTALSMEMBERS_CANCELBUTTON,_GetInst()}}
	oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",null_string,null_string}

	oDCFixedText3 := FixedText{self,ResourceID{TOTALSMEMBERS_FIXEDTEXT3,_GetInst()}}
	oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"From month:",null_string,null_string}

	oDCFixedText5 := FixedText{self,ResourceID{TOTALSMEMBERS_FIXEDTEXT5,_GetInst()}}
	oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Till month:",null_string,null_string}

	oDCFromYear := SingleLineEdit{self,ResourceID{TOTALSMEMBERS_FROMYEAR,_GetInst()}}
	oDCFromYear:HyperLabel := HyperLabel{#FromYear,null_string,null_string,null_string}
	oDCFromYear:FieldSpec := YearW{}
	oDCFromYear:Picture := "9999"

	oDCFromMonth := SingleLineEdit{self,ResourceID{TOTALSMEMBERS_FROMMONTH,_GetInst()}}
	oDCFromMonth:Picture := "99"
	oDCFromMonth:FieldSpec := MonthW{}
	oDCFromMonth:HyperLabel := HyperLabel{#FromMonth,null_string,null_string,null_string}

	oDCToYear := SingleLineEdit{self,ResourceID{TOTALSMEMBERS_TOYEAR,_GetInst()}}
	oDCToYear:HyperLabel := HyperLabel{#ToYear,null_string,null_string,null_string}
	oDCToYear:FieldSpec := YearW{}
	oDCToYear:Picture := "9999"

	oDCToMonth := SingleLineEdit{self,ResourceID{TOTALSMEMBERS_TOMONTH,_GetInst()}}
	oDCToMonth:Picture := "99"
	oDCToMonth:FieldSpec := MonthW{}
	oDCToMonth:HyperLabel := HyperLabel{#ToMonth,null_string,null_string,null_string}

	oDCFixedText2 := FixedText{self,ResourceID{TOTALSMEMBERS_FIXEDTEXT2,_GetInst()}}
	oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Give the total amounts of assessable gifts, personal funds and charges",null_string,null_string}
	oDCFixedText2:Font(aFonts[1], FALSE)

	self:Caption := "Totals Members during Balance Year"
	self:HyperLabel := HyperLabel{#TotalsMembers,"Totals Members during Balance Year",null_string,null_string}

	if !IsNil(oServer)
		self:Use(oServer)
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
	self:SetTexts()
	IF Month(Today()) <=9
		self:FromYear:=Year(Today())-2
		self:ToYear:=Year(Today())-1
	ELSE
		self:FromYear:=Year(Today())-1
		self:ToYear:=Year(Today())
	ENDIF
	self:FromMonth:=10
	self:ToMonth:=9
	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS TotalsMembers
	//Put your PreInit additions here
	RETURN nil
ACCESS ToMonth() CLASS TotalsMembers
RETURN self:FieldGet(#ToMonth)

ASSIGN ToMonth(uValue) CLASS TotalsMembers
self:FieldPut(#ToMonth, uValue)
RETURN uValue

ACCESS ToYear() CLASS TotalsMembers
RETURN self:FieldGet(#ToYear)

ASSIGN ToYear(uValue) CLASS TotalsMembers
self:FieldPut(#ToYear, uValue)
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
