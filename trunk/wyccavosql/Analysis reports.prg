CLASS DonorFollowingReport INHERIT DataWindowMine 

	PROTECT oDCProjectsBox AS CHECKBOX
	PROTECT oDCHomeBox AS CHECKBOX
	PROTECT oDCNonHomeBox AS CHECKBOX
	PROTECT oDCFromAccount AS SINGLELINEEDIT
	PROTECT oCCFromAccButton AS PUSHBUTTON
	PROTECT oDCToAccount AS SINGLELINEEDIT
	PROTECT oCCToAccButton AS PUSHBUTTON
	PROTECT oDCFromBal AS SINGLELINEEDIT
	PROTECT oCCFromBalButton AS PUSHBUTTON
	PROTECT oDCFromDep AS SINGLELINEEDIT
	PROTECT oCCFromDepButton AS PUSHBUTTON
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
	PROTECT oDCPerAccountBox AS CHECKBOX
	PROTECT oDCSC_DEP AS FIXEDTEXT
	PROTECT oDCSC_BAL AS FIXEDTEXT
	PROTECT oDCfound AS FIXEDTEXT
	PROTECT oDCFixedText14 AS FIXEDTEXT
	PROTECT oDCStatBox8 AS CHECKBOX

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
	INSTANCE PerAccountBox
	PROTECT MaxJaar,MinJaar, StartJaar as int
	PROTECT aPropEx:={} as ARRAY
	EXPORT cFromAccName as STRING
	EXPORT cToAccName as STRING
	PROTECT FromYear,FromMonth,ToYear,ToMonth as int
	export oSelpers as Selpers 
	export aSelectedClasses as arraY
   export cCurBal,WhatFrom,WhoFrom,cCurDep as STRING 


   
   	
RESOURCE DonorFollowingReport DIALOGEX  33, 9, 425, 437
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Projects", DONORFOLLOWINGREPORT_PROJECTSBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 13, 40, 80, 11
	CONTROL	"Members of", DONORFOLLOWINGREPORT_HOMEBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 13, 51, 131, 11
	CONTROL	"Members not of", DONORFOLLOWINGREPORT_NONHOMEBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 13, 62, 131, 11
	CONTROL	"", DONORFOLLOWINGREPORT_FROMACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 32, 107, 78, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", DONORFOLLOWINGREPORT_FROMACCBUTTON, "Button", WS_CHILD, 110, 107, 15, 12
	CONTROL	"", DONORFOLLOWINGREPORT_TOACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 152, 107, 78, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", DONORFOLLOWINGREPORT_TOACCBUTTON, "Button", WS_CHILD, 229, 107, 16, 12
	CONTROL	"", DONORFOLLOWINGREPORT_FROMBAL, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 88, 73, 105, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", DONORFOLLOWINGREPORT_FROMBALBUTTON, "Button", WS_CHILD, 192, 73, 13, 13
	CONTROL	"", DONORFOLLOWINGREPORT_FROMDEP, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 88, 88, 105, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", DONORFOLLOWINGREPORT_FROMDEPBUTTON, "Button", WS_CHILD|NOT WS_VISIBLE, 192, 88, 13, 12
	CONTROL	"Sub period length:", DONORFOLLOWINGREPORT_FIXEDTEXT2, "Static", WS_CHILD, 13, 187, 72, 13
	CONTROL	"", DONORFOLLOWINGREPORT_SUBPERLEN, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 111, 187, 71, 72
	CONTROL	"Divide givers into classes according to their property:", DONORFOLLOWINGREPORT_PROPERTIESBOX, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 206, 231, 69
	CONTROL	"Gender", DONORFOLLOWINGREPORT_GENDER, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 217, 80, 11
	CONTROL	"Age", DONORFOLLOWINGREPORT_AGE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 231, 32, 11
	CONTROL	"10 years", DONORFOLLOWINGREPORT_RANGE10, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 64, 231, 41, 11
	CONTROL	"20 years", DONORFOLLOWINGREPORT_RANGE20, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 114, 231, 40, 11
	CONTROL	"Type of Person", DONORFOLLOWINGREPORT_TYPE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 244, 80, 12
	CONTROL	"Frequency of giving", DONORFOLLOWINGREPORT_FREQUENCY, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 258, 80, 11
	CONTROL	"Ranges", DONORFOLLOWINGREPORT_RANGES, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|NOT WS_VISIBLE, 59, 223, 99, 20
	CONTROL	"Required statistical data", DONORFOLLOWINGREPORT_STATISTICSBOX, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 11, 280, 304, 115
	CONTROL	"amount given per class of givers", DONORFOLLOWINGREPORT_STATBOX1, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 291, 251, 11
	CONTROL	"percentage of total amount given, a certain class of givers has contributed", DONORFOLLOWINGREPORT_STATBOX2, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 19, 302, 253, 11
	CONTROL	"number of givers per class of givers", DONORFOLLOWINGREPORT_STATBOX3, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 315, 251, 11
	CONTROL	"percentage of total number of givers, a certain class of givers has contributed", DONORFOLLOWINGREPORT_STATBOX4, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 19, 327, 255, 11
	CONTROL	"average amount given per class of givers", DONORFOLLOWINGREPORT_STATBOX5, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 339, 153, 11
	CONTROL	"median amount given per class of givers", DONORFOLLOWINGREPORT_STATBOX6, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 352, 155, 11
	CONTROL	"spread over ranges of amounts given per class of givers ", DONORFOLLOWINGREPORT_STATBOX7, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 19, 365, 191, 11
	CONTROL	"", DONORFOLLOWINGREPORT_NUMBERRANGES, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 291, 365, 17, 12, WS_EX_CLIENTEDGE
	CONTROL	"Number of ranges:", DONORFOLLOWINGREPORT_FIXEDTEXTRANGES, "Static", WS_CHILD|NOT WS_VISIBLE, 227, 365, 63, 12
	CONTROL	"Members/funds", DONORFOLLOWINGREPORT_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|WS_CLIPSIBLINGS, 8, 29, 412, 103
	CONTROL	"From:", DONORFOLLOWINGREPORT_FIXEDTEXT1, "Static", WS_CHILD, 12, 107, 20, 9
	CONTROL	"To:", DONORFOLLOWINGREPORT_FIXEDTEXT3, "Static", WS_CHILD, 136, 107, 15, 9
	CONTROL	"", DONORFOLLOWINGREPORT_TEXTFROM, "Static", WS_CHILD, 16, 118, 111, 12
	CONTROL	"", DONORFOLLOWINGREPORT_TEXTTILL, "Static", WS_CHILD, 138, 118, 107, 12
	CONTROL	"Subset:", DONORFOLLOWINGREPORT_FIXEDTEXT7, "Static", WS_CHILD, 248, 36, 42, 10
	CONTROL	"OK", DONORFOLLOWINGREPORT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 364, 413, 53, 12
	CONTROL	"", DONORFOLLOWINGREPORT_SUBSET, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 248, 48, 168, 225, WS_EX_CLIENTEDGE
	CONTROL	"Cancel", DONORFOLLOWINGREPORT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 364, 398, 53, 13
	CONTROL	"Show differences with the previous period", DONORFOLLOWINGREPORT_DIFFBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 12, 416, 172, 11
	CONTROL	"maandag 17 oktober 2011", DONORFOLLOWINGREPORT_FROMDATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 62, 149, 120, 14
	CONTROL	"maandag 17 oktober 2011", DONORFOLLOWINGREPORT_TODATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 62, 168, 120, 14
	CONTROL	"From Date:", DONORFOLLOWINGREPORT_FIXEDTEXT6, "Static", WS_CHILD, 13, 149, 46, 12
	CONTROL	"Till Date:", DONORFOLLOWINGREPORT_FIXEDTEXT8, "Static", WS_CHILD, 13, 168, 41, 12
	CONTROL	"Report Period", DONORFOLLOWINGREPORT_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 136, 232, 68
	CONTROL	"Give insight in the effects of e.g. a mailing on the donor behaviour:", DONORFOLLOWINGREPORT_FIXEDTEXT9, "Static", WS_CHILD, 7, 4, 376, 12
	CONTROL	"which part of the different groups of givers have given during a certain period of time and how much have they given", DONORFOLLOWINGREPORT_FIXEDTEXT10, "Static", WS_CHILD, 7, 17, 371, 12
	CONTROL	"Show data per account", DONORFOLLOWINGREPORT_PERACCOUNTBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 12, 403, 172, 11
	CONTROL	"Department from:", DONORFOLLOWINGREPORT_SC_DEP, "Static", WS_CHILD|NOT WS_VISIBLE, 12, 88, 67, 12
	CONTROL	"Balance item from:", DONORFOLLOWINGREPORT_SC_BAL, "Static", WS_CHILD, 12, 75, 72, 13
	CONTROL	"", DONORFOLLOWINGREPORT_FOUND, "Static", SS_RIGHT|SS_CENTERIMAGE|WS_CHILD, 344, 36, 23, 10
	CONTROL	"accounts", DONORFOLLOWINGREPORT_FIXEDTEXT14, "Static", SS_CENTERIMAGE|WS_CHILD, 372, 36, 44, 10
	CONTROL	"respons per class of givers", DONORFOLLOWINGREPORT_STATBOX8, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 20, 380, 154, 11
END

METHOD AccFil() CLASS DonorFollowingReport
	LOCAL i as int
	LOCAL SubLen as int
	self:FromAccount:="0"
	self:ToAccount:="zzzzzzzzz"
	self:oDCSubSet:FillUsing(self:oDCSubSet:GetAccnts(nil))
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
	self:oDCfound:TEXTValue:=Str(self:oDCSubSet:SelectedCount,-1)
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
	if self:oDCAge:Checked .or. self:oDCGender:Checked .or.  self:oDCType:Checked  .or.  self:oDCFrequency:Checked
		self:oDCStatBox2:Show()
		self:oDCStatBox4:Show()
	else
		self:oDCStatBox2:Hide()
		self:oDCStatBox4:Hide()
		self:StatBox2:=false
		self:StatBox4:=false
	endif
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
	LOCAL cCurValue as USUAL
	LOCAL nPntr as int
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
		ELSEIF oControl:NameSym==#FromDep .and.!AllTrim(oControl:TextValue)==self:cCurDep
			cCurValue:=AllTrim(oControl:TextValue)
			self:cCurDep:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindDep(@cCurValue)
				self:RegDepartment(cCurValue,"From Department")
			ELSE
				self:FromDepButton()
			ENDIF
		elseIF oControl:NameSym==#FromBal .and.!AllTrim(oControl:TextValue)==self:cCurBal
			cCurValue:=AllTrim(oControl:TextValue)
			self:cCurBal:=cCurValue
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindBal(@cCurValue)
				self:RegBalance(cCurValue)
			ELSE
				self:FromBalButton()
			ENDIF

		ENDIF
	ENDIF
	return 

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

ACCESS FromBal() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#FromBal)

ASSIGN FromBal(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#FromBal, uValue)
RETURN uValue

METHOD FromBalButton( ) CLASS DonorFollowingReport 
	LOCAL cCurValue as STRING

	cCurValue:=AllTrim(self:oDCFromBal:TextValue)
	(BalanceItemExplorer{self:Owner,"BalanceItem",self:cCurBal,self,cCurValue,"From Balance Item"}):Show()

RETURN nil
ACCESS FromDep() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#FromDep)

ASSIGN FromDep(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#FromDep, uValue)
RETURN uValue

 METHOD FromDepButton( ) CLASS DonorFollowingReport 
	LOCAL cCurValue as STRING
	LOCAL nPntr as int

	cCurValue:=AllTrim(self:oDCFromDep:TextValue)
	(DepartmentExplorer{self:Owner,"Department",self:cCurDep,self,cCurValue,"From Department"}):Show()

RETURN NIL
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

oDCFromBal := SingleLineEdit{SELF,ResourceID{DONORFOLLOWINGREPORT_FROMBAL,_GetInst()}}
oDCFromBal:HyperLabel := HyperLabel{#FromBal,NULL_STRING,"Number of Balancegroup",NULL_STRING}
oDCFromBal:TooltipText := "Enter number or name of required Top of balance structure"

oCCFromBalButton := PushButton{SELF,ResourceID{DONORFOLLOWINGREPORT_FROMBALBUTTON,_GetInst()}}
oCCFromBalButton:HyperLabel := HyperLabel{#FromBalButton,"v","Browse in balance items",NULL_STRING}
oCCFromBalButton:TooltipText := "Browse in balance items"

oDCFromDep := SingleLineEdit{SELF,ResourceID{DONORFOLLOWINGREPORT_FROMDEP,_GetInst()}}
oDCFromDep:HyperLabel := HyperLabel{#FromDep,NULL_STRING,NULL_STRING,NULL_STRING}
oDCFromDep:FieldSpec := Description{}
oDCFromDep:TooltipText := "Enter number or name of required Top of department structure"

oCCFromDepButton := PushButton{SELF,ResourceID{DONORFOLLOWINGREPORT_FROMDEPBUTTON,_GetInst()}}
oCCFromDepButton:HyperLabel := HyperLabel{#FromDepButton,"v","Browse in departments",NULL_STRING}
oCCFromDepButton:TooltipText := "Browse in departments"

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
oDCTextfrom:HyperLabel := HyperLabel{#Textfrom,NULL_STRING,NULL_STRING,NULL_STRING}

oDCTextTill := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_TEXTTILL,_GetInst()}}
oDCTextTill:HyperLabel := HyperLabel{#TextTill,NULL_STRING,NULL_STRING,NULL_STRING}

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

oDCPerAccountBox := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_PERACCOUNTBOX,_GetInst()}}
oDCPerAccountBox:HyperLabel := HyperLabel{#PerAccountBox,"Show data per account",NULL_STRING,NULL_STRING}

oDCSC_DEP := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_SC_DEP,_GetInst()}}
oDCSC_DEP:HyperLabel := HyperLabel{#SC_DEP,"Department from:",NULL_STRING,NULL_STRING}

oDCSC_BAL := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_SC_BAL,_GetInst()}}
oDCSC_BAL:HyperLabel := HyperLabel{#SC_BAL,"Balance item from:",NULL_STRING,NULL_STRING}

oDCfound := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_FOUND,_GetInst()}}
oDCfound:HyperLabel := HyperLabel{#found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText14 := FixedText{SELF,ResourceID{DONORFOLLOWINGREPORT_FIXEDTEXT14,_GetInst()}}
oDCFixedText14:HyperLabel := HyperLabel{#FixedText14,"accounts",NULL_STRING,NULL_STRING}

oDCStatBox8 := CheckBox{SELF,ResourceID{DONORFOLLOWINGREPORT_STATBOX8,_GetInst()}}
oDCStatBox8:HyperLabel := HyperLabel{#StatBox8,"respons per class of givers",NULL_STRING,NULL_STRING}
oDCStatBox8:TooltipText := "Number of givers compared with quantity mailing"

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

method ListBoxSelect(oControlEvent) class DonorFollowingReport
	local oControl as Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:ListBoxSelect(oControlEvent)
	//Put your changes here 
	self:oDCfound:TEXTValue:=Str(self:oDCSubSet:SelectedCount,-1)

	return NIL

METHOD MarkupMatrix(ptrHandle,aMatrix,cHeading,PrevPeriodCount,aRelevantClass,ixOff,aAccQtyM)	CLASS	DonorFollowingReport
	// fill excel matrix with data 
	LOCAL accIx,periodNo,classNo,m as int, line as STRING
	LOCAL diff as FLOAT      
	LOCAL perMin:=2+PrevPeriodCount, perMax:=Len(aMatrix[1]) as int // Min and max middle index into aMatrix[*,*,*]       
	Default(@aAccQtyM,null_array)
	
	// Heading (containing type of statistics)
	FWriteLine(ptrHandle,"<tr><td></td>")
	FWriteLine(ptrHandle,"<td style='font-weight: bold;italic; color:blue;text-align : center;'  colspan='"+Str(perMax-PrevPeriodCount-1,-1)+"'>"+oLan:Rget(cHeading)+;
	iif(Empty(aAccQtyM),'',' ('+Str(aAccQtyM[1],-1,0)+"x)")+"</td>")
	FOR accIx:=2 to Len(aMatrix) 
// 		FWriteLine(ptrHandle,"<td style='font-weight: bold;italic; color:blue;text-align : center;'  colspan='"+Str(perMax-PrevPeriodCount-1,-1)+"'>"+iif(Empty(aAccQtyM),"&nbsp;",Str(aAccQtyM[accIx],-1))+"</td>")
		FWriteLine(ptrHandle,"<td style='color:blue;text-align : center;'  colspan='"+Str(perMax-PrevPeriodCount-1,-1)+"'>"+iif(Empty(aAccQtyM),"&nbsp;",Str(aAccQtyM[accIx],-1,0)+"x")+"</td>")
	NEXT
	FWriteLine(ptrHandle,"</tr>")

	// Date range headings	
	FWriteLine(ptrHandle,"<tr><td></td>")
	FOR periodNo:=perMin to perMax
		FWriteLine(ptrHandle,"<td style='background-color:lightblue;'>"+aMatrix[1,periodNo,1]+"</td>")
	NEXT
	FOR accIx:=2 to Len(aMatrix)
		FOR periodNo:=perMin to perMax
			FWriteLine(ptrHandle,"<td style='background-color:lightblue;'>&nbsp;</td>")
		NEXT
	NEXT
	FWriteLine(ptrHandle,"</tr>")

	// Amount range headings
	IF ixOff=2
		// We are handling aMatrix7
		FWriteLine(ptrHandle,"<tr><td></td>")
		FOR accIx:=1 to Len(aMatrix)
			FOR periodNo:=perMin to perMax
				FWriteLine(ptrHandle,"<td><table style='border-collapse:collapse;' border='1'><tr>")
				FOR m:=1 to Len(aMatrix[accIx,periodNo,2])
					FWriteLine(ptrHandle,"<td style='background-color:#F0E68C;text-align:center;'>"+iif(m=NumberRanges,">"+Str(aMatrix[accIx,periodNo,2,m-1],-1),"<="+Str(aMatrix[accIx,periodNo,2,m],-1))+"</td>")
				NEXT
				FWriteLine(ptrHandle,"</tr></table></td>")
			NEXT
		NEXT
	ENDIF

	FOR classNo:=ixOff+1 to Len(aMatrix[1,1]) 
		IF aRelevantClass[classNo-ixOff]
			line:="<tr>"	 
			// Class name
			line+="<td style='background-color:#AFEEEE;'>"+aMatrix[1,1,classNo]+"</td>"

			FOR accIx:=1 to Len(aMatrix)
				FOR periodNo:=perMin to perMax
					IF IsNumeric(aMatrix[accIx,periodNo,classNo])
						// determine difference with previous period:
						IF self:DiffBox
							IF IsNumeric(aMatrix[accIx,periodNo-prevPeriodCount,classNo]) .and. aMatrix[accIx,periodNo-prevPeriodCount,classNo]>0
								diff:=(aMatrix[accIx,periodNo,classNo]*100)/aMatrix[accIx,periodNo-PrevPeriodCount,classNo]-100
								line+="<td>"+Str(aMatrix[accIx,periodNo,classNo],-1)+" ("+iif(diff<0,"","+")+Str(diff,-1,0)+"%)"+"</td>"
							ELSE
								line+="<td>"+iif(aMatrix[accIx,periodNo,classNo]>0,Str(aMatrix[accIx,periodNo,classNo],-1)+" (new)","")+"</td>"
							ENDIF							
						ELSE
							line+="<td>"+Str(aMatrix[accIx,periodNo,classNo],-1)+"</td>"
						ENDIF
					ELSEIF IsArray(aMatrix[accIx,periodNo,classNo])
						// We are handling aMatrix7
						line+="<td><table style='border-collapse:collapse;' border='1'><tr>"
						FOR m:=1 to Len(aMatrix[accIx,periodNo,classNo])
							line+="<td>"+Str(aMatrix[accIx,periodNo,classNo,m],-1)+"</td>"
						NEXT
						line+="</tr></table></td>"
					ELSE
						line+="<td></td>"
					ENDIF
				NEXT
			NEXT
			FWriteLine(ptrHandle,line+"</tr>")
		ENDIF
	NEXT
	FWriteLine(ptrHandle,"<tr><td colspan='"+Str(Len(aMatrix)*(perMax-PrevPeriodCount-1)+1,-1)+"'>&nbsp;<br></td></tr>")
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
ACCESS PerAccountBox() CLASS DonorFollowingReport
RETURN SELF:FieldGet(#PerAccountBox)

ASSIGN PerAccountBox(uValue) CLASS DonorFollowingReport
SELF:FieldPut(#PerAccountBox, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS DonorFollowingReport
	//Put your PostInit additions here
	LOCAL count as int
	LOCAL EndDate,FromDate as date
	LOCAL StartDate as date
	LOCAL OldestYear as date
	  
	self:SetTexts()

	self:oDCHomeBox:Caption:=self:oLan:WGet("Members of")+" "+sLand
	self:oDCNonHomeBox:Caption:=self:oLan:WGet("Members not of")+" "+sLand
	self:ProjectsBox:=true

	
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
	StatBox2:=false
	StatBox3:=true
	StatBox4:=false
	StatBox5:=true
	StatBox6:=true
	StatBox7:=true
	self:oDCFixedTextRanges:show()
	self:oDCNumberRanges:show()
	DiffBox:=false
	PerAccountBox:=false 
	if Departments
		self:oDCSC_DEP:Show()
		self:oDCFromDep:Show()
		self:oCCFromDepButton:Show()
		self:cCurDep:=iif(Empty(cDepmntIncl),"",Split(cDepmntIncl,",")[1])
		self:RegDepartment(cCurDep,"From Department")
	endif
   self:RegBalance(self:cCurBal)
// 	self:AccFil()

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
	LOCAL aPersFr:={} as ARRAY // of each giver in earlier period its CLN  
	LOCAL aPersPrvFreq,aPersFreq as ARRAY // of each person from aPers: frequency of giving: 1: first giver, 2: not last 2 years, 3: not last year, 4:last year once, 5: more than once last year
	LOCAL periodNo, classNo, i,j,k,m,nRange,nCSt,maxlevel as int
	LOCAL cName as STRING
	LOCAL NextYear, NextMonth, PrevYear, PrevMonth as int
	LOCAL StartDate,EndDate,PerStart,PerEnd,FrequencyEnd, PerStart1, PerStart2 as date
	LOCAL PeriodCount:=0 as int // Number of subperiods in total date range
	LOCAL PrevPeriodCount:=0 as int
	LOCAL cFileName as USUAL, oFileSpec as FileSpec
	LOCAL ptrHandle
	LOCAL aAcc:={} as ARRAY  // Account IDs
	LOCAL aAccNo as ARRAY  // Account numbers
	LOCAL aAccQtyM as ARRAY  // Account qtymailing 
	local TotalQtyM as real8
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
	LOCAL aMatrix1,aMatrix2,aMatrix3,aMatrix4,aMatrix5,aMatrix6,aMatrix7,aMatrix8 as ARRAY // matrix to fill with calculated values Stat1,Stat2, ...
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
	LOCAL time1 as string
	LOCAL lDiff:=self:DiffBox as LOGIC         
	LOCAL perAccount:=self:PerAccountBox as LOGIC
	LOCAL accIx,maxAccIx,colCount as int   
	
	time1:=Time()
	self:STATUSMESSAGE(sMes+" ("+ElapTime(time1,Time())+")")

	// Build accStr to be a comma separated list of account numbers enclosed in parentheses
	aAcc:=self:oDCSubSet:GetSelectedItems()
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


	if perAccount
		// Calculate number of columns
		if StatBox7
			colCount:=(Len(aAcc)+1)*(Len(aPeriod)-1)*NumberRanges+1
		else
			colCount:=(Len(aAcc)+1)*(Len(aPeriod)-1)+1
		endif    
		if colCount>16385
			if (TextBox{self,"Warning","The spreadsheet will contain " + Str(colCount,-1) + " columns. Excel can only handle 16385 columns. (Older versions of Excel can only handle 256 columns.)",;
					BUTTONOKAYCANCEL+BOXICONEXCLAMATION}):Show()=BOXREPLYCANCEL
				return nil
			endif
		elseif colCount>256                              
			if (TextBox{self,"Warning","The spreadsheet will contain " + Str(colCount,-1) + " columns. Older versions of Excel can only handle 256 columns.",;
					BUTTONOKAYCANCEL+BOXICONEXCLAMATION}):Show()=BOXREPLYCANCEL
				return nil
			endif
		endif
	endif
	
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
		for periodNo:=1 to Len(aPeriod)-1
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
	self:STATUSMESSAGE(gMes+" ("+ElapTime(time1,Time())+")")

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
		self:STATUSMESSAGE(fMes+" ("+ElapTime(time1,Time())+")")
		// find persid's of givers with creation date before current period
		oTrans:=SQLSelect{"SELECT p.persid from person p, perslist l where p.persid=l.persid and p.creationdate <'"+SQLdate(aPeriod[1])+"' order by p.persid",oConn}
		aPersFr:={} 
		if oTrans:RECCOUNT>0
			do while !oTrans:EoF
				AAdd(aPersFr,oTrans:persid)
				oTrans:Skip()
			enddo
		endif
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
				+ UnionTrans("SELECT t.transid,t.seqnr,t.persid," + freqStr1 + "," + freqStr2 + " FROM transaction as t";  
			+ " WHERE t.persid in (" + Implode(aPersFr,',') + ") " ;
				+ " AND t.GC<>'PF' AND t.GC<>'CH' AND" ;
				+ " t.dat<'" + SQLdate(FrequencyEnd) + "' AND t.CRE>t.DEB "))        // Begin at a very old date 
			// 			+ UnionTrans2("SELECT t.transid,t.seqnr,t.persid," + freqStr1 + "," + freqStr2 + " FROM transaction as t";  
			// 			+ " WHERE t.accid IN " + accStr + " AND t.persid>=" + Str(aPers[1],-1) + " and t.persid<=" + Str(aPers[Len(aPers)],-1) + " " ;
			// 			+ " AND t.GC<>'PF' AND t.GC<>'CH' AND" ;
			// 			+ " t.dat<'" + SQLdate(FrequencyEnd) + "' AND t.CRE>t.DEB ",ConDate(1950,1,1),FrequencyEnd))        // Begin at a very old date 
			return nil
		endif
		self:STATUSMESSAGE(fMes+" ("+ElapTime(time1,Time())+")")

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
		self:STATUSMESSAGE(fMes+" ("+ElapTime(time1,Time())+")")

		IF oTransFreq:RECCOUNT>0
			DO WHILE !oTransFreq:EoF
				k:=AScanBin(aPers,oTransFreq:persid)
				if k>0 
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
						IF ConI(oTransFreq:xcount)>=2    // Note: xcount is a Bigint, therefore Val() is required
							aPersFreq[k]:=5 // Given >=2 times last year
						ELSE
							aPersFreq[k]:=4 // Given once last year
						ENDIF
					ENDCASE 
				endif
				oTransFreq:Skip()
			ENDDO
		ENDIF
		oTransFreq:Close()

		IF lDiff  
			aPersPrvFreq:=AReplicate(1,Len(aPers))    // initialize as new givers
			
			sqlStr:="SELECT persid,freq2,COUNT(*) xcount FROM freqtrans2 GROUP BY persid,freq2"  
			oTransFreq:=SQLSelect{sqlStr,oConn} 

			IF oTransFreq:RECCOUNT>0
				self:STATUSMESSAGE(fMes+" ("+ElapTime(time1,Time())+")")
				DO WHILE !oTransFreq:EoF
					k:=AScanBin(aPers,oTransFreq:persid)
					if k>0 
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
							IF ConI(oTransFreq:xcount)>=2
								aPersPrvFreq[k]:=5 // Given >=2 times last year
							ELSE
								aPersPrvFreq[k]:=4 // Given once last year
							ENDIF
						ENDCASE 
					endif
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
	self:STATUSMESSAGE(pMes+" ("+ElapTime(time1,Time())+")  0% done")
	
	if self:SqlDoAndTest("CREATE TEMPORARY TABLE persclass (" ;
			+ "persid int(11) NOT NULL," ; 
		+ "classindex int(11) NOT NULL," ;
			+ "prevclassindex int(11) NOT NULL," ;
			+ "PRIMARY KEY (persid)" ;
			+ ") ENGINE=MyISAM")
		return nil
	endif
	self:STATUSMESSAGE(pMes+" ("+ElapTime(time1,Time())+")  2% done")


	TrCnt:=0
	insCount:=0
	insSep:=""
	sqlStr2:=""
	oPers:=SQLSelect{"select persid,cast(birthdate as date) as birthdate,gender,type,propextr from person where persid in ("+Implode(aPers,",")+")",oConn}
	IF oPers:RECCOUNT=0
		(ErrorBox{self,"Database table 'person' is empty"}):Show()
		oPers:Close()
		return nil
	ENDIF
	self:STATUSMESSAGE(pMes+" ("+ElapTime(time1,Time())+")  4% done")
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
			persValuePtr:=Max(1,AScan(aClassTuples,cSearch))
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
			IF insCount>=500
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
			+ "SELECT f.transid,f.seqnr,";
			+ iif(perAccount,"f.accid","0");
			+ " accid,f.subperiod,f.persid,sum(f.amount) amount,if (f.subperiod<=" + Str(PrevPeriodCount,-1) + ",p.prevclassindex,p.classindex) classindex ";
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
			if oTrans:classindex>0
				aRelevantClass[oTrans:classindex]:=.T.
			endif
			oTrans:Skip()
		ENDDO
	ENDIF
	oTrans:Close()
	
	
	// Use of the aMatrix arrays is as follows:
	//     For account a, period p, and class c,
	//         aMatrix1[a+1,p+1,c+1]   is the total amount given
	//         aMatrix2[a+1,p+1,c+1]   is the fraction aMatrix1[p+1,c+1]/aMatrix1[all periods,c+1] (expressed in percent)
	//         aMatrix3[a+1,p+1,c+1]   is the number of givers
	//         aMatrix4[a+1,p+1,c+1]   is the fraction aMatrix3[p+1,c+1]/aMatrix3[all periods,c+1] (expressed in percent)
	//         aMatrix5[a+1,p+1,c+1]   is the average amount per giver
	//         aMatrix6[a+1,p+1,c+1]   is the mean amount per giver
	//         aMatrix7[a+1,p+1,c+2,m] is the number of givers in amount range m
	//         aMatrix7[a+1,p+1,2,m]   is the upper limit for amount range m
	//     For all arrays, setting the first index to 1 gives the total for all accounts
	//
	// Special indices for aMatrix1 to aMatrix6:
	//     aMatrixN[1,1,1]     is nil  
	//     aMatrixN[1,1,c+1]   is the class name for class c
	//     aMatrixN[1,p+1,1]   is the date range for period p
	//     aMatrixN[a+1,p+1,1] is nil
	//
	// Special indices for aMatrix7:
	//     aMatrix7[1,1,1]     is nil  
	//     aMatrix7[1,1,2]     is nil  
	//     aMatrix7[1,1,c+2]   is the class name for class c
	//     aMatrix7[1,p+1,1]   is the date range for period p
	//     aMatrix7[a+1,p+1,1] is nil
	//     aMatrix7[a+1,p+1,2] is nil
	
	maxAccIx:=iif(perAccount,1+Len(aAcc),1)

	aMatrix1:=ArrayNew(maxAccIx)	
	aMatrix2:=ArrayNew(maxAccIx)	
	aMatrix3:=ArrayNew(maxAccIx)	
	aMatrix4:=ArrayNew(maxAccIx)	
	aMatrix5:=ArrayNew(maxAccIx)	
	aMatrix6:=ArrayNew(maxAccIx)	
	aMatrix7:=ArrayNew(maxAccIx)	
	aMatrix8:=ArrayNew(maxAccIx)	

	FOR accIx:=1 to maxAccIx
		// Note: Len(aPeriod) is one greater that the number of periods
		aMatrix1[accIx]:=ArrayNew(Len(aPeriod))
		aMatrix2[accIx]:=ArrayNew(Len(aPeriod))
		aMatrix3[accIx]:=ArrayNew(Len(aPeriod))
		aMatrix4[accIx]:=ArrayNew(Len(aPeriod))
		aMatrix5[accIx]:=ArrayNew(Len(aPeriod))
		aMatrix6[accIx]:=ArrayNew(Len(aPeriod))
		aMatrix7[accIx]:=ArrayNew(Len(aPeriod))    
		aMatrix8[accIx]:=ArrayNew(Len(aPeriod))

		for periodNo:=1 to Len(aPeriod)
			aMatrix1[accIx,periodNo]:=AReplicate(0,Len(aClassTuples)+1)
			aMatrix2[accIx,periodNo]:=AReplicate(0,Len(aClassTuples)+1)
			aMatrix3[accIx,periodNo]:=AReplicate(0,Len(aClassTuples)+1)
			aMatrix4[accIx,periodNo]:=AReplicate(0,Len(aClassTuples)+1)
			aMatrix5[accIx,periodNo]:=AReplicate(0,Len(aClassTuples)+1)
			aMatrix6[accIx,periodNo]:=AReplicate(0,Len(aClassTuples)+1)
			aMatrix7[accIx,periodNo]:=AReplicate(0,Len(aClassTuples)+2)
			aMatrix8[accIx,periodNo]:=AReplicate(0,Len(aClassTuples)+1)

			aMatrix1[accIx,periodNo,1]:=nil
			aMatrix2[accIx,periodNo,1]:=nil
			aMatrix3[accIx,periodNo,1]:=nil
			aMatrix4[accIx,periodNo,1]:=nil
			aMatrix5[accIx,periodNo,1]:=nil
			aMatrix6[accIx,periodNo,1]:=nil
			aMatrix7[accIx,periodNo,1]:=nil
			aMatrix7[accIx,periodNo,2]:=iif(periodNo=1, nil, AReplicate(0,NumberRanges))
			aMatrix8[accIx,periodNo,1]:=nil
		NEXT
	NEXT
	
	FOR classNo:=1 to Len(aClassTuples)
		if aRelevantClass[classNo]
			aClassPtr:=Split(aClassTuples[classNo],",")
			cClassName:=""
			FOR j:=1 to Len(aClassPtr)
				k:=Val(aClassPtr[j])
				IF aClass[k,1]="BIRTHDATE"
					IF aClass[k,3]=0
						cClassName+=oLan:Rget(aClass[k,2])+" is unknown "
					ELSE
						cClassName+=oLan:Rget(aClass[k,2])+"="+AllTrim(Str(aClass[k,3]))+" - "+AllTrim(Str(aClass[k,4]))+" "
					ENDIF
				ELSEIF aClass[k,1]="TYPE" .or. aClass[k,1]="GENDER" .or. aClass[k,1]="FREQUENCY" .or. aClass[k,1]="ALL"
					cClassName+=oLan:Rget(aClass[k,4])+" "
				ELSE
					cClassName+=oLan:RGet(aClass[k,2])+"="+oLan:RGet(aClass[k,4])+" "
				ENDIF
			NEXT
			aMatrix1[1,1,classNo+1]:=cClassName
			aMatrix2[1,1,classNo+1]:=cClassName
			aMatrix3[1,1,classNo+1]:=cClassName
			aMatrix4[1,1,classNo+1]:=cClassName
			aMatrix5[1,1,classNo+1]:=cClassName
			aMatrix6[1,1,classNo+1]:=cClassName
			aMatrix7[1,1,classNo+2]:=cClassName
			aMatrix8[1,1,classNo+1]:=cClassName
		ENDIF
	NEXT
	FOR periodNo:=1 to Len(aPeriod)-1
		aMatrix1[1,periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix2[1,periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix3[1,periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix4[1,periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix5[1,periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix6[1,periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix7[1,periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
		aMatrix8[1,periodNo+1,1]:=DToC(aPeriod[periodNo])+" - "+DToC(aPeriod[periodNo+1]-1)
	NEXT
	
	// determine subtotals per period:    
	PerTotal:=ArrayNew(maxAccIx)
	PerCount:=ArrayNew(maxAccIx)
	FOR accIx:=1 to maxAccIx
		PerTotal[accIx]:=AReplicate(0.00,Len(aPeriod)-1)
		PerCount[accIx]:=AReplicate(0,Len(aPeriod)-1)
	NEXT


	// Get total and count for all accounts by subperiod and classindex
	oTrans:=SQLSelect{"SELECT subperiod,classindex,sum(amount) sumamount,count(*) xcount " ;
		+ "FROM followingtrans2 GROUP BY subperiod,classindex",oConn}

	// Note: oTrans:xcount is a Bigint therefore we need to use Val() on it 
	IF oTrans:RECCOUNT>0
		DO WHILE !oTrans:EoF
			aMatrix1[1, oTrans:subperiod+1, oTrans:classindex+1] := oTrans:sumamount
			aMatrix3[1, oTrans:subperiod+1, oTrans:classindex+1] := ConI(oTrans:xcount)   
			oTrans:Skip()
		ENDDO
	ENDIF
	oTrans:Close()
	
	IF perAccount
		// Get total and count per account by subperiod and classindex
		oTrans:=SQLSelect{"SELECT accid,subperiod,classindex,sum(amount) sumamount,count(*) xcount " ;
			+ "FROM followingtrans2 GROUP BY accid,subperiod,classindex",oConn}
		
		// Note: oTrans:xcount is a Bigint therefore we need to use Val() on it 

		IF oTrans:RECCOUNT>0
			DO WHILE !oTrans:EoF
				accIx:=AScan(aAcc,oTrans:accid) 
				
				aMatrix1[accIx+1, oTrans:subperiod+1, oTrans:classindex+1] := oTrans:sumamount
				aMatrix3[accIx+1, oTrans:subperiod+1, oTrans:classindex+1] := ConI(oTrans:xcount)   
				oTrans:Skip()
			ENDDO
		ENDIF
		oTrans:Close()
	ENDIF
	

	// Get total and count by subperiod 
	oTrans:=SQLSelect{"SELECT subperiod,max(amount) maxamount,sum(amount) sumamount,count(*) xcount " ;
		+ "FROM followingtrans2 GROUP BY subperiod",oConn}

	IF oTrans:RECCOUNT>0
		DO WHILE !oTrans:EoF
			// determine ranges from average per period:
			IF oTrans:subperiod>PrevPeriodCount.and.ConI(oTrans:xcount)>0
				rangeVal:=Round(oTrans:sumamount/(NumberRanges*ConI(oTrans:xcount)), 0)
				IF rangeVal >0
					FOR m:=1 to self:NumberRanges-1
						aMatrix7[1,oTrans:subperiod+1,2,m]:=Round(m*rangeVal,0)
					NEXT
					aMatrix7[1,oTrans:subperiod+1,2,NumberRanges]:=oTrans:maxamount
				ENDIF			
			ENDIF
			PerTotal[1,oTrans:subperiod]:=oTrans:sumamount
			PerCount[1,oTrans:subperiod]:=ConI(oTrans:xcount)
			oTrans:Skip()
		ENDDO
	ENDIF
	oTrans:Close()

	self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")")

	IF perAccount
		// Get total and count per account by subperiod and classindex
		oTrans:=SQLSelect{"SELECT accid,subperiod,max(amount) maxamount,sum(amount) sumamount,count(*) xcount " ;
			+ "FROM followingtrans2 GROUP BY accid,subperiod",oConn}

		IF oTrans:RECCOUNT>0
			DO WHILE !oTrans:EoF
				accIx:=AScan(aAcc,oTrans:accid) 

				// determine ranges from average per period:
				IF oTrans:subperiod>PrevPeriodCount.and.ConI(oTrans:xcount)>0
					rangeVal:=Round(oTrans:sumamount/(NumberRanges*ConI(oTrans:xcount)), 0)
					IF rangeVal >0
						FOR m:=1 to self:NumberRanges-1
							aMatrix7[accIx+1,oTrans:subperiod+1,2,m]:=Round(m*rangeVal,0)
						NEXT
						aMatrix7[accIx+1,oTrans:subperiod+1,2,NumberRanges]:=oTrans:maxamount
					ENDIF			
				ENDIF
				PerTotal[accIx+1,oTrans:subperiod]:=oTrans:sumamount
				PerCount[accIx+1,oTrans:subperiod]:=ConI(oTrans:xcount)
				oTrans:Skip()
			ENDDO
		ENDIF
		oTrans:Close()

		self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")")
	ENDIF
	// Initialize Markup report from matrix:
	oFileSpec:=AskFileName(self,"DonorFollowing"+DToS(StartDate)+"_"+DToS(EndDate-1),"Creating Donor Following-report",'*.XLS',"Excel Spreadsheet") 
	IF oFileSpec==null_object
		return nil
	ENDIF
	cFileName:=oFileSpec:FullPath
	ptrHandle := MakeFile(self,@cFileName,"Creating DonorFollowing-report")

	IF ptrHandle = F_ERROR .or. ptrHandle==nil
		return nil
	ENDIF
	SetDecimalSep(Asc(DecSeparator))
	
	oFileSpec:FullPath:=cFileName
	//	header record:
	FWriteLine(ptrHandle,"<html><body><table style='font-family: Arial;'	border='2'><tr	style='font-weight: bold; color:navy;'>"+;
		"<td style='text-align : center;' colspan='"+Str(maxAccIx*(Len(aPeriod)-PrevPeriodCount-1)+1,-1)+"'>"+oLan:Rget("Donor Following	Report")+"	"+;
		oLan:Rget("period")+": "+DToC(StartDate)+" -	"+DToC(EndDate-1)+"</td></tr>")
	FWriteLine(ptrHandle,"<tr><td	colspan='"+Str(maxAccIx*(Len(aPeriod)-PrevPeriodCount-1)+1,-1)+"'>"+oLan:Rget("Destinations")+":<br><ol>")

	aAccNo:=AReplicate(0,Len(aAcc))
	aAccQtyM:=AReplicate(0,Len(aAcc)+1)
	FOR accIx:=1 to Len(aAcc)
		oAcc:=SqlSelect{"select	description,accnumber,cast(qtymailing as unsigned)	as	qtymailing from account	where	giftalwd	and accid="	+ Str(aAcc[accIx],-1) ,oConn}
		IF	oAcc:RECCOUNT>0
			FWriteLine(ptrHandle,"<li>" +	oAcc:accnumber	+ " "	+ AllTrim(oAcc:Description)+"</li>")
			aAccNo[accIx]:=oAcc:accnumber
			aAccQtyM[accIx+1]:=oAcc:qtymailing
		ENDIF		  
		oAcc:Close()
	NEXT
	TotalQtyM:=asum(aAccQtyM,2)		
	aAccQtyM[1]:=TotalQtyM
	// Fill	Matrices:    
	FOR accIx:=1 to maxAccIx
		FOR periodNo:=1 to Len(aPeriod)-1
			FOR classNo:=1 to Len(aClassTuples)
				IF aRelevantClass[classNo]
					IF PerTotal[accIx,periodNo]>0
						aMatrix2[accIx,periodNo+1,classNo+1]:=Round((aMatrix1[accIx,periodNo+1,classNo+1]*100)/PerTotal[accIx,periodNo],2)
					ENDIF
					IF PerCount[accIx,periodNo]>0
						aMatrix4[accIx,periodNo+1,classNo+1]:=Round((aMatrix3[accIx,periodNo+1,classNo+1]*100)/PerCount[accIx,periodNo],2)
					ENDIF

					// aMatrix3[accIx,periodNo+1,classNo+2] contains the number of donations with subperiod=periodNo and classindex=classNo
					donationsCount:=aMatrix3[accIx,periodNo+1,classNo+1]
					IF donationsCount>0
						// response:
						if aAccQtyM[accIx]>0 .and. aAccQtyM[accIx]>=donationsCount 
							aMatrix8[accIx,periodNo+1,classNo+1]:=Round((donationsCount*100)/aAccQtyM[accIx],2)
						endif
						
						aMatrix5[accIx,periodNo+1,classNo+1]:=Round(aMatrix1[accIx,periodNo+1,classNo+1]/donationsCount,2)

						IF StatBox6
							// Median calculation:
							
							IF accIx=1
								// Looking at all accounts
								sqlStr:="SELECT amount FROM " ;
									+ "(SELECT amount FROM followingtrans2 WHERE subperiod=" + Str(periodNo,-1) + " AND classindex=" + Str(classNo,-1) + " ORDER BY amount) t " ;
									+ "LIMIT " + Str(Floor((donationsCount-1)/2),-1) + ",2"
							ELSE
								// Looking at account aAcc[accIx-1]
								sqlStr:="SELECT amount FROM " ;
									+ "(SELECT amount FROM followingtrans2 WHERE accid=" + Str(aAcc[accIx-1],-1) + " AND subperiod=" + Str(periodNo,-1) + " AND classindex=" + Str(classNo,-1) + " ORDER BY amount) t " ;
									+ "LIMIT " + Str(Floor((donationsCount-1)/2),-1) + ",2"      
							ENDIF

							oTrans:=SQLSelect{sqlStr, oConn}       
							// 						SQLStatement{'INSERT INTO log (txt) VALUES("' + sqlStr + '")',oConn}:Execute() 

							median:=oTrans:amount

							IF donationsCount%2=0
								// We have an even number of entries
								oTrans:Skip()
								median:=(median+oTrans:amount)/2
							ENDIF
							aMatrix6[accIx,periodNo+1,classNo+1]:=median
							oTrans:Close()
						endif
					ENDIF

					aMatrix7[accIx,periodNo+1,classNo+2]:=AReplicate(0,NumberRanges)
				ENDIF
			NEXT


			IF StatBox7.and.periodNo>PrevPeriodCount
				// sqlStr2 is the range classifier
				sqlStr2:="CASE "
				for j:=1 to NumberRanges-1
					sqlStr2+="WHEN amount<=" + Str(aMatrix7[accIx,periodNo+1,2,j],-1) + " THEN " + Str(j) + " "
				next
				sqlStr2+="ELSE " + Str(NumberRanges,-1) + " END"
				
				IF accIx=1
					// Looking at all accounts
					sqlStr:="SELECT " + sqlStr2 + " xrange, classindex, count(*) xcount FROM followingtrans2 " ;
						+ "WHERE subperiod=" + Str(periodNo,-1) + " GROUP BY classindex,xrange"
				ELSE
					// Looking at account aAcc[accIx-1]
					sqlStr:="SELECT " + sqlStr2 + " xrange, classindex, count(*) xcount FROM followingtrans2 " ;
						+ "WHERE accid=" + Str(aAcc[accIx-1],-1) + " AND subperiod=" + Str(periodNo,-1) + " GROUP BY classindex,xrange"
				ENDIF			
				oTrans:=SQLSelect{sqlStr,oConn}				
				// 			SQLStatement{'INSERT INTO log (txt) VALUES("' + sqlStr + '")',oConn}:Execute() 
				
				if oTrans:RECCOUNT<>0 
					DO WHILE !oTrans:EoF
						IF ConI(oTrans:xcount)<>0
							aMatrix7[accIx,periodNo+1,oTrans:classindex+2,oTrans:xrange]:=ConI(oTrans:xcount)
						endif
						oTrans:Skip()
					ENDDO
				ENDIF
				oTrans:Close()
			ENDIF
		NEXT  
		self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")") 
	NEXT

	// Markup report from matrix:
	FWriteLine(ptrHandle,"</ol></td></tr>")

	FWriteLine(ptrHandle,"<tr><td></td>")
	FWriteLine(ptrHandle,"<td style='font-weight: bold;italic; color:blue;text-align : center;'  colspan='"+Str(Len(aPeriod)-PrevPeriodCount-1,-1)+"'>"+oLan:Rget("All accounts")+"</td>")
	FOR accIx:=2 to maxAccIx
		FWriteLine(ptrHandle,"<td style='font-weight: bold;italic; color:blue;text-align : center;'  colspan='"+Str(Len(aPeriod)-PrevPeriodCount-1,-1)+"'>"+aAccNo[accIx-1] + "</td>")
	NEXT
	FWriteLine(ptrHandle,"</tr>")


	self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")") 
	IF self:StatBox1
		self:MarkupMatrix(ptrHandle,aMatrix1,"amount given per class of givers",PrevPeriodCount,aRelevantClass,1)
		self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")") 
	ENDIF
	IF self:StatBox2
		self:MarkupMatrix(ptrHandle,aMatrix2,"percentage of total amount given, a certain class of givers has contributed",PrevPeriodCount,aRelevantClass,1)
		self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")") 
	ENDIF
	IF self:StatBox3
		self:MarkupMatrix(ptrHandle,aMatrix3,"number of givers per class of givers",PrevPeriodCount,aRelevantClass,1)
		self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")") 
	ENDIF
	IF self:StatBox4
		self:MarkupMatrix(ptrHandle,aMatrix4,"percentage of total number of givers, a certain class of givers has contributed",PrevPeriodCount,aRelevantClass,1)
		self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")") 
	ENDIF
	IF self:StatBox8
		self:MarkupMatrix(ptrHandle,aMatrix8,"response per class of givers ",PrevPeriodCount,aRelevantClass,1,aAccQtyM,)
		self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")") 
	ENDIF
	IF self:StatBox5
		self:MarkupMatrix(ptrHandle,aMatrix5,"average amount given per class of givers",PrevPeriodCount,aRelevantClass,1)
		self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")") 
	ENDIF
	IF self:StatBox6
		self:MarkupMatrix(ptrHandle,aMatrix6,"median amount given per class of givers",PrevPeriodCount,aRelevantClass,1)
		self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")") 
	ENDIF
	IF self:StatBox7
		self:MarkupMatrix(ptrHandle,aMatrix7,"spread over ranges of amounts given per class of givers ",PrevPeriodCount,aRelevantClass,2)
		self:STATUSMESSAGE(rMes+" ("+ElapTime(time1,Time())+")") 
	ENDIF
	// closing record:
	FWriteLine(ptrHandle,"<table></body></html>")
	FClose(ptrHandle)
	self:STATUSMESSAGE("")
	self:Pointer := Pointer{POINTERARROW}
	SetDecimalSep(Asc('.'))

	// Show with excel:
	FileStart(oFileSpec:FullPath,self)
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
		self:oDCFromAccount:TextValue := self:FromAccount
		self:cFromAccName := FromAccount
		self:oDCTextfrom:Caption := AllTrim(oAccount:Description)
		self:oDCSubSet:AccNbrStart:=self:FromAccount
		self:oDCfound:TextValue:=Str(self:oDCSubSet:SelectedCount,-1)
	ELSEIF ItemName == "Till Account"
		self:ToAccount:= LTrimZero(oAccount:accnumber)
		self:oDCToAccount:TextValue := self:ToAccount
		self:cToAccName := self:ToAccount
		self:oDCTextTill:Caption := AllTrim(oAccount:Description)
		self:oDCSubSet:AccNbrEnd:=self:ToAccount
		self:oDCfound:TextValue:=Str(self:oDCSubSet:SelectedCount,-1)
	ENDIF
		
RETURN true
METHOD RegBalance(myNum) CLASS DonorFollowingReport
	local oBal as SQLSelect
	Default(@myNum,null_string)
	IF Empty(myNum) .or. myNum='0'
		self:cCurBal:="0:Balance Items"
		self:WhatFrom:=''
	ELSE
		oBal:=SQLSelect{"select number,heading,balitemid from balanceitem where balitemid='"+myNum+"'",oConn} 
		IF oBal:RecCount>0
			self:cCurBal:=AllTrim(oBal:number)+":"+oBal:heading
			self:WhatFrom:=Str(oBal:balitemid,-1)
		ENDIF
	ENDIF
	self:oDCFromBal:TextValue:=self:cCurBal 
	self:oDCSubSet:WhatFrom :=self:WhatFrom 

	self:AccFil()
	RETURN
METHOD RegDepartment(myNum,ItemName) CLASS DonorFollowingReport
	LOCAL depnr:="", deptxt:=""  as STRING
	local oDep as SQLSelect
	Default(@myNum,null_string)
	Default(@Itemname,null_string)
	IF Empty(myNum) .or. myNum='0'
		depnr:="0"
		deptxt:=sEntity+" "+sLand
	ELSE
		oDep:=SQLSelect{"select depid,descriptn  from department where depid="+myNum,oConn}
		if oDep:RecCount>0
			depnr:=Str(oDep:DEPID,-1)
			deptxt:=oDep:DESCRIPTN
		ENDIF
	ENDIF
	IF ItemName == "From Department"
		self:WhoFrom:= depnr
		self:oDCFromDep:TextValue := deptxt
		self:cCurDep:=deptxt
		self:oDCSubSet:WhoFrom :=depnr
	endif
	self:AccFil()
RETURN
METHOD SetPropExtra( Count) CLASS DonorFollowingReport
	LOCAL oCheck as CheckBox
	LOCAL oDCGroupBoxExtra	as GROUPBOX
	LOCAL Name as STRING,Type, ID as int, Values as STRING
	LOCAL myDim as Dimension
	LOCAL myOrg as Point
	LOCAL aValues as ARRAY
	LOCAL NewY as int
	IF pers_propextra[Count,3]==TEXTBX
		// skip textboxes
		RETURN
	ENDIF
	Name:=pers_propextra[Count,1]
	ID := pers_propextra[Count,2]
	NewY:=self:oDCFrequency:Origin:Y
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
	myOrg:=self:oDCStatBox8:Origin
	myOrg:Y-=25
	self:oDCStatBox8:Origin:=myOrg
	myOrg:=self:oDCDiffBox:Origin
	myOrg:y-=25
	self:oDCDiffBox:Origin:=myOrg
	myOrg:=self:oDCPerAccountBox:Origin
	myOrg:Y-=25
	self:oDCPerAccountBox:Origin:=myOrg
	
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


	sqlSt:=SQLStatement{sqlStr,oConn}
	sqlSt:Execute()
// 	LogEvent(self,sqlstr,"logsql")
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

STATIC DEFINE DONORFOLLOWINGREPORT_AGE := 115 
STATIC DEFINE DONORFOLLOWINGREPORT_CANCELBUTTON := 139 
STATIC DEFINE DONORFOLLOWINGREPORT_DIFFBOX := 140 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT1 := 132 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT10 := 147 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT14 := 152 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT2 := 111 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT3 := 133 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT6 := 143 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT7 := 136 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT8 := 144 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXT9 := 146 
STATIC DEFINE DONORFOLLOWINGREPORT_FIXEDTEXTRANGES := 130 
STATIC DEFINE DONORFOLLOWINGREPORT_FOUND := 151 
STATIC DEFINE DONORFOLLOWINGREPORT_FREQUENCY := 119 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMACCBUTTON := 104 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMACCOUNT := 103 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMBAL := 107 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMBALBUTTON := 108 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMDATE := 141 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMDEP := 109 
STATIC DEFINE DONORFOLLOWINGREPORT_FROMDEPBUTTON := 110 
STATIC DEFINE DONORFOLLOWINGREPORT_GENDER := 114 
STATIC DEFINE DONORFOLLOWINGREPORT_GROUPBOX1 := 131 
STATIC DEFINE DONORFOLLOWINGREPORT_GROUPBOX3 := 145 
STATIC DEFINE DONORFOLLOWINGREPORT_HOMEBOX := 101 
STATIC DEFINE DONORFOLLOWINGREPORT_NONHOMEBOX := 102 
STATIC DEFINE DONORFOLLOWINGREPORT_NUMBERRANGES := 129 
STATIC DEFINE DONORFOLLOWINGREPORT_OKBUTTON := 137 
STATIC DEFINE DONORFOLLOWINGREPORT_PERACCOUNTBOX := 148 
STATIC DEFINE DONORFOLLOWINGREPORT_PROJECTSBOX := 100 
STATIC DEFINE DONORFOLLOWINGREPORT_PROPERTIESBOX := 113 
STATIC DEFINE DONORFOLLOWINGREPORT_RANGE10 := 116 
STATIC DEFINE DONORFOLLOWINGREPORT_RANGE20 := 117 
STATIC DEFINE DONORFOLLOWINGREPORT_RANGES := 120 
STATIC DEFINE DONORFOLLOWINGREPORT_SC_BAL := 150 
STATIC DEFINE DONORFOLLOWINGREPORT_SC_DEP := 149 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX1 := 122 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX2 := 123 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX3 := 124 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX4 := 125 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX5 := 126 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX6 := 127 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX7 := 128 
STATIC DEFINE DONORFOLLOWINGREPORT_STATBOX8 := 153 
STATIC DEFINE DONORFOLLOWINGREPORT_STATISTICSBOX := 121 
STATIC DEFINE DONORFOLLOWINGREPORT_SUBPERLEN := 112 
STATIC DEFINE DONORFOLLOWINGREPORT_SUBSET := 138 
STATIC DEFINE DONORFOLLOWINGREPORT_TEXTFROM := 134 
STATIC DEFINE DONORFOLLOWINGREPORT_TEXTTILL := 135 
STATIC DEFINE DONORFOLLOWINGREPORT_TOACCBUTTON := 106 
STATIC DEFINE DONORFOLLOWINGREPORT_TOACCOUNT := 105 
STATIC DEFINE DONORFOLLOWINGREPORT_TODATE := 142 
STATIC DEFINE DONORFOLLOWINGREPORT_TYPE := 118 
resource DonorFolwngSelClasses DIALOGEX  5, 20, 271, 125
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Donor following Report - export classes of persons"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Select one or more classes of persons to be exported", DONORFOLWNGSELCLASSES_FIXEDTEXT1, "Static", WS_CHILD, 4, 7, 200, 12
	CONTROL	"", DONORFOLWNGSELCLASSES_CLASSESBOX, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL|LBS_SORT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 4, 22, 204, 96, WS_EX_CLIENTEDGE
	CONTROL	"OK", DONORFOLWNGSELCLASSES_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 212, 22, 55, 11
END

CLASS DonorFolwngSelClasses INHERIT DialogWinDowExtra 

	PROTECT oDCFixedText1 as FIXEDTEXT
	PROTECT oDCClassesBox as LISTBOX
	PROTECT oCCOKButton as PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  Protect oCaller as Object
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
	declare method SetSelected,DeselectAccount    

RESOURCE DonorProject DIALOGEX  34, 31, 435, 1308
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"dinsdag 18 oktober 2011", DONORPROJECT_FROMDATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 48, 21, 120, 14
	CONTROL	"dinsdag 18 oktober 2011", DONORPROJECT_TODATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 194, 21, 120, 14
	CONTROL	"Compose groups of projects", DONORPROJECT_DESTINATIONS, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 7, 40, 417, 24, WS_EX_TRANSPARENT
	CONTROL	"Click to (de)select corresponding accounts:", DONORPROJECT_FIXEDTEXT3, "Static", WS_CHILD, 200, 48, 165, 12
	CONTROL	"OK", DONORPROJECT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 372, 7, 53, 12
	CONTROL	"Cancel", DONORPROJECT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 372, 22, 53, 12
	CONTROL	"From Date:", DONORPROJECT_FIXEDTEXT6, "Static", WS_CHILD, 7, 21, 38, 12
	CONTROL	"Till:", DONORPROJECT_FIXEDTEXT7, "Static", WS_CHILD, 175, 21, 16, 12
	CONTROL	"Give insight who has given to which destination during a certain period of time", DONORPROJECT_FIXEDTEXT5, "Static", WS_CHILD, 8, 6, 361, 13
END

method ButtonClick(oControlEvent) class DonorProject
	local oControl as Control
	local cID as string
	local nPntr as int
	LOCAL cCurValue as STRING
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	super:ButtonClick(oControlEvent)
	//Put your changes here 
	if oControl:Name="FROMBALBUTTON"
		cID:=AllTrim(StrTran(oControl:Name,"FROMBALBUTTON",''))
		nPntr:=AScan(self:aControls,{|x|x:Name=='BALANCE'+cID} )
		if nPntr>0
			cCurValue:=AllTrim(self:aControls[nPntr]:Textvalue)
			(BalanceItemExplorer{self:Owner,"BalanceItem"+cID,'',self,cCurValue}):Show() 
		endif
	elseif oControl:Name="FROMDEPBUTTON"
		cID:=AllTrim(StrTran(oControl:Name,"FROMDEPBUTTON",''))
		nPntr:=AScan(self:aControls,{|x|x:Name=='DEPARTMENT'+cID} )
		if nPntr>0
			cCurValue:=AllTrim(self:aControls[nPntr]:TextValue)
			(DepartmentExplorer{self:Owner,"Department"+cID,'',self,cCurValue,"Department"+cID}):Show() 
		endif

	endif
	return NIL

METHOD CancelButton( ) CLASS DonorProject
	self:EndWindow()
	RETURN nil
METHOD Close(oEvent) CLASS DonorProject
	SUPER:Close(oEvent)
	//Put your changes here
	self:EndWindow()
	RETURN nil

METHOD DeselectAccount(nCur ref int,nPos as int) as void pascal CLASS DonorProject
	// remove deselected account as nPos from group nCur
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

oCCOKButton := PushButton{SELF,ResourceID{DONORPROJECT_OKBUTTON,_GetInst()},Point{559, 2095},Dimension{80, 20}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}
oCCOKButton:UseHLforToolTip := False
oCCOKButton:OwnerAlignment := OA_PX
oCCOKButton:TooltipText := "Generate report"

oCCCancelButton := PushButton{SELF,ResourceID{DONORPROJECT_CANCELBUTTON,_GetInst()},Point{559, 2071},Dimension{80, 20}}
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
	LOCAL oControl as CONTROL, uValue as USUAL
	LOCAL lSelected as LOGIC
	LOCAL nItem,i,j,k,nCur,nSel,nPos as int
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
				nPos:=i
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
								self:DeselectAccount(@nPos,j)
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
	LOCAL nAcc as int

	AAdd(self:aDestGrp,{"Members of "+sLand,{}})
	AAdd(self:aDestGrp,{"Members not of "+sLand,{}})

	// initialize array with gift accounts (non member)
	oAcc:=SQLSelect{"select account.accid,CO,description,accnumber,homepp FROM account";
		+ " left join member on (member.accid=account.accid or member.depid=account.department)";
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
			AAdd(self:aDestGrp[1,2],oAcc:accid)
			AAdd(aGiftAccHomeMbr,"("+AllTrim(oAcc:accnumber)+")"+AllTrim(oAcc:Description))
		ELSE
			// foreign members: group 2
			AAdd(self:aDestGrp[2,2],oAcc:accid)
			AAdd(aGiftAccForeignMbr,"("+AllTrim(oAcc:accnumber)+")"+AllTrim(oAcc:Description))
		ENDIF
		oAcc:Skip()
	ENDDO

	// Initialize self:aDestGrp:                      
	oSys:=SQLSelect{"select destgrps from sysparms",oConn}
	IF oSys:RecCount>0
		// Compose aDstGrp from XML document in oSys:DestGrps
		// <root>
		oXMLDoc:=XMLDocument{oSys:DESTGRPS}
		recordfound:=oXMLDoc:GetElement("group")
		Pntr:=0
// 		LogEvent(self,oXMLDoc:getbuffer(),"logsql")
		do WHILE recordfound
			Pntr++
			AAdd(self:aDestGrp,{,{}})
			childfound:=oXMLDoc:GetFirstChild()
			do WHILE childfound
				ChildName:=oXMLDoc:ChildName
				do CASE
				CASE ChildName=="name"
					self:aDestGrp[Pntr+2,1]:=oXMLDoc:ChildContent
				CASE ChildName=="account"
					nAcc:=Val(oXMLDoc:ChildContent)
					IF AScan(self:aGiftAcc,{|x| x[2]==nAcc})>0
						// only existing gift accounts:
						AAdd(self:aDestGrp[Pntr+2,2],nAcc)
					ENDIF
				ENDCASE

				childfound:=oXMLDoc:GetNextChild()			
			ENDDO
			IF Pntr>1 .and. ChildName=="name"
				// apparently no accounts:
				Pntr--
				ASize(self:aDestGrp,Pntr+2)
			ENDIF
			recordfound:=oXMLDoc:GetNextSibbling()
		ENDDO
	ENDIF
	IF Len(self:aDestGrp)=2
		AAdd(self:aDestGrp,{"Office "+sLand,{}})
// 		AAdd(self:aDestGrp,{"Other projects",{}})	
	ENDIF
	// add new accounts to last group:
	FOR i:=1 to Len(self:aGiftAcc)
		nAcc:=self:aGiftAcc[i,2]
		IF AScan(self:aDestGrp,{|x|AScan(x[2],nAcc)>0})=0
			AAdd(self:aDestGrp[Len(self:aDestGrp),2],nAcc)
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
	oFileSpec:=AskFileName(self,"DonorProject"+Str(nFromYear,4,0)+StrZero(nFromMonth,2)+"_"+Str(nToYear,4,0)+StrZero(nToMonth,2),,{"*.xls;"},{"spreadsheet"})
	IF oFileSpec==null_object
		RETURN FALSE
	ENDIF
	cFileName:=oFileSpec:FullPath
	ptrHandle := MakeFile(self,@cFileName,"Creating DonorProject-report")
	AEvalA(ColTotal,{||0.00})

	IF !ptrHandle = F_ERROR .and. !ptrHandle==nil
		oFileSpec:FullPath:=cFileName
		* header record:
		FWriteLine(ptrHandle,"<html><body><table border=1><tr><td align='center' colspan='"+Str(Len(self:aDestGrp)+2,-1)+"'>"+oLan:Rget("Donor versus Project Report")+"  "+oLan:Rget("period")+": "+DToC(self:oDCFromdate:SelectedDate)+" - "+DToC(self:oDCTodate:SelectedDate)+"</td></tr>")
		FWriteLine(ptrHandle,"<tr><td></td>")
		FOR i:=1 to Len(aDestGrp)
			FWriteLine(ptrHandle,"<td align='right'><b>"+oLan:Rget(aDestGrp[i,1])+"</b></td>")	
		NEXT
		FWriteLine(ptrHandle,"<td>"+oLan:Rget("TOTAL")+"</td>")
		* detail records:
		FOR i = 1 to Len(pers_types)
			FWriteLine(ptrHandle,"</tr><tr><td>"+oLan:Rget(pers_types[i,1])+"</td>")
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
		FWriteLine(ptrHandle,"<tr><td valign='top'>"+oLan:Rget("Accounts")+"</td>")
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
METHOD RegBalance(myNum,cItemname) CLASS DonorProject
	local oBal,oAcc as SQLSelect
	local nPntr,i as int
	local cID as string
	local nID,nCur,nAccid as int
	local aAccSel:={} as array
	local cBalIncl as string
	Default(@myNum,null_string)
	nID:=Val(SubStr(cItemname,12) )
	nCur:=nID+2
	cID:="BALANCE"+Str(nID,-1) 
	nPntr:=AScan(self:aControls,{|x|x:Name==cID}) 
	if nPntr>0
		IF Empty(myNum) .or. myNum='0'
			self:aControls[nPntr]:Value:="0:Balance Items"
		ELSE
			oBal:=SqlSelect{"select number,heading,balitemid from balanceitem where balitemid='"+myNum+"'",oConn} 
			IF oBal:RecCount>0
				self:aControls[nPntr]:Value:=AllTrim(oBal:number)+":"+oBal:heading 
				self:aDestGrp[nCur,2]:={}
				// select corresponding accounts:
				cBalIncl:=SetAccFilter(Val(myNum))
 
				oAcc:=SqlSelect{"select accid from account where giftalwd=1 and balitemid in ("+cBalIncl+")",oConn}
				if oAcc:RecCount>0
					aAccSel:=oAcc:GetLookupTable(1000,#accid,#accid)
					for i:=1 to Len(aAccSel)
						AAdd(self:aDestGrp[nCur,2],aAccSel[i,1])
					next
				endif
				self:SetSelected(nCur)
			ENDIF
		ENDIF

	endif
	RETURN
METHOD RegDepartment(myNum,cItemname) CLASS DonorProject
	local oDep,oAcc as SQLSelect
	local nPntr,i as int
	local cID as string
	local nID,nCur,nAccid as int
	local aAccSel:={} as array
	local cDepIncl as string
	Default(@myNum,null_string)
	nID:=Val(SubStr(cItemname,11) )
	nCur:=nID+2
	cID:="DEPARTMENT"+Str(nID,-1) 
	nPntr:=AScan(self:aControls,{|x|x:Name==cID}) 
	if nPntr>0
		IF Empty(myNum) .or. myNum='0'
			self:aControls[nPntr]:Value:=sEntity+" "+sLand
		ELSE
		oDep:=SQLSelect{"select depid,descriptn,deptmntnbr  from department where depid="+myNum,oConn}
			IF oDep:RecCount>0
				self:aControls[nPntr]:Value:=AllTrim(oDep:deptmntnbr)+":"+oDep:DESCRIPTN 
				self:aDestGrp[nCur,2]:={}
				// select corresponding accounts:
				cDepIncl:=SetDepFilter(Val(myNum))
 
				oAcc:=SqlSelect{"select accid from account where giftalwd=1 and department in ("+cDepIncl+")",oConn}
				if oAcc:RecCount>0
					aAccSel:=oAcc:GetLookupTable(1000,#accid,#accid)
					for i:=1 to Len(aAccSel)
						AAdd(self:aDestGrp[nCur,2],aAccSel[i,1])
					next
				endif
				self:SetSelected(nCur)
			ENDIF
		ENDIF

	endif
	RETURN
	
METHOD SetDestGrp( Count) CLASS DonorProject
	// initialize controls for a destination group
	LOCAL oSingle1,oSingle2 as SingleLineEdit
	LOCAL oList as ListBox
	LOCAL oDCGroupBoxDest as GROUPBOX
	local oFix as FIXEDTEXT
	local oButton as PUSHBUTTON
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
	// 	myOrg:x:=256
	myOrg:x:=330
	oList:=ListBox{self,Count+100,myOrg,Dimension{288,103},LBOXMULTIPLESEL+LBOXSORT+LBOXDISABLENOSCROLL}
	oList:HyperLabel := HyperLabel{String2Symbol("SubAccSet"+ID),"SubAccSet"+ID,null_string,null_string} 
	oList:OwnerAlignment:=OA_WIDTH
	oList:FillUsing(self:aGiftAcc)
	AAdd(self:aDestAccSet,oList)
	oList:Show() 
	// name
	myOrg:y+=83
	myOrg:x:=22
	oSingle1:=SingleLineEdit{self,Count+200,myOrg,Dimension{250,20},EDITAUTOHSCROLL	}
	oSingle1:HyperLabel := HyperLabel{String2Symbol("DestName"+ID),"DestName"+ID,null_string,null_string}
	oSingle1:FocusSelect := FSEL_HOME
	oSingle1:ToolTipText:=self:oLan:WGet("Tag this destination group with a name")
	oSingle1:Show()
	oSingle1:Value:=Name
	AAdd(self:aControls,oSingle1)
	AAdd(self:aDestName,oSingle1)
	// preselect from balance item:
	myOrg:y-=23
	oFix:=FixedText{self,Count+500,myOrg,Dimension{150,20}, self:oLan:WGet("Preselect accounts from")+":"}
	oFix:Show()
	myOrg:y-=20
	myOrg:x:=28
	FixedText{self,Count+600,myOrg,Dimension{80,20}, self:oLan:WGet("balance item")+":"}:Show()
	myOrg:x:=110
	oSingle2:=SingleLineEdit{self,Count+300,myOrg,Dimension{130,20},EDITAUTOHSCROLL	}
	oSingle2:HyperLabel := HyperLabel{String2Symbol("Balance"+ID),"Balance"+ID,null_string,null_string}
	oSingle2:FocusSelect := FSEL_HOME 
	oSingle2:ToolTipText:=self:oLan:WGet("Enter number or name of required Top of balance structure")
	oSingle2:Show()
	AAdd(self:aControls,oSingle2) 
	oSingle2:Value:='        '
	myOrg:x+=130
	oButton:=PushButton{self,Count+400,myOrg,Dimension{20,20},'v'} 
	oButton:HyperLabel:=HyperLabel{String2Symbol("FromBalButton"+ID),'v'} 
	oButton:ToolTipText:= self:oLan:WGet("Browse in balance items")
	oButton:Show()
	
	myOrg:y-=20
	myOrg:x:=28
	FixedText{self,Count+600,myOrg,Dimension{80,20}, self:oLan:WGet("department")+":"}:Show()
	myOrg:x:=110
	oSingle2:=SingleLineEdit{self,Count+300,myOrg,Dimension{130,20},EDITAUTOHSCROLL	}
	oSingle2:HyperLabel := HyperLabel{String2Symbol("Department"+ID),"Department"+ID,null_string,null_string}
	oSingle2:FocusSelect := FSEL_HOME 
	oSingle2:ToolTipText:=self:oLan:WGet("Enter number or name of required Top of department structure")
	oSingle2:Show()
	AAdd(self:aControls,oSingle2) 
	oSingle2:Value:='        '
	myOrg:x+=130
	oButton:=PushButton{self,Count+400,myOrg,Dimension{20,20},'v'} 
	oButton:HyperLabel:=HyperLabel{String2Symbol("FromDepButton"+ID),'v'} 
	oButton:ToolTipText:= self:oLan:WGet("Browse in departments")
	oButton:Show()
	
	

	RETURN nil
METHOD SetSelected(count as int) as void pascal CLASS DonorProject
	// set corresponding accounts as selected in Listbox of a destination group
	LOCAL h,i,j,k,grp as int
	LOCAL oList as ListBox
	LOCAL aAcc:= self:aDestGrp[Count,2] as ARRAY
	LOCAL search as int
	oList:=self:aDestAccSet[count-2]
	// select required items:
	FOR j:=1 to oList:ItemCount
		search:=oList:GetItemValue(j)
		IF AScan(aAcc,search)>0
			// select all preselected items:
			oList:SelectItem(j) 
		else
			if oList:IsSelected(j)
				oList:DeselectItem(j)
			ENDIF
		ENDIF
		// make first selected current:
		k:=oList:FirstSelected()
		IF k>0
			oList:SetTop(k)
		ENDIF
	NEXT
RETURN 	
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
local aBalIncl:=self:aBalIncl,aDepIncl:=self:aDepIncl as array 
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
	AEval(aMemHome,{|x| FilterAcc(aAcc,x,cStart,cEnd,aBalIncl,aDepIncl)})
ENDIF
IF lNonHome
	AEval(aMemNonHome,{|x| FilterAcc(aAcc,x,cStart,cEnd,aBalIncl,aDepIncl)})
ENDIF
IF lProjects
	AEval(aProjects,{|x| FilterAcc(aAcc,x,cStart,cEnd,aBalIncl,aDepIncl)})
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
	local aTotM:={} as array  // {{AccountId,category 1=home,2:projekts home,3: projects home sep.department,4:nonHome,5:unknown member,6:unknown account,totAg, totAGFromRpp, TotMG, totPF, TotCH,TotAssOff,TotAssInt, membername},...} 
	Local aSubTot:={0,0,0,0,0,0,0}, aTotTot:={0,0,0,0,0,0,0} as array
	Local iPos,i,j as int, AccountId as string, CurCat as int 
	local oAcc as SQLSelect 
	LOCAL cTab:=CHR(9) as STRING
	local nNameLen:=30 as int 
	local aGroupName as array
	local MainDeP as int
	local nUnknown as int
	local sqlStr as string
	

	* Check values:
	* Check input data:
// 	IF !ValidateControls( self, self:AControls )
// 		RETURN
// 	END
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
		+ "t.transid,t.seqnr,t.dat,t.cre,t.deb,t.fromrpp,t.description as tdesc,t.gc,t.accid as taccid,";
		+ "a.department,a.description as adesc,a.accid as aaccid,";
		+ "m.co,m.homepp,m.mbrid ";
		+ "from transaction as t ";
		+ "left join account as a on a.accid=t.accid ";
		+ "left join member as m on (m.accid=t.accid or m.depid=a.department)";
		+ "where t.dat>='" +  Str(self:FromYear,4) + "-" + StrZero(self:FromMonth,2) + "-01' and " ;
		+ "t.dat<='" + Str(self:ToYear,4) + "-" + StrZero(self:ToMonth,2) + "-" + StrZero(MonthEnd(self:ToMonth,self:ToYear),2) + "' and t.gc>''") //;
		//		+ " order by taccid"
	oTransH:=SQLSelect{sqlStr, oConn} 
	oTransH:Execute()

	do WHILE !oTransH:EoF
		AccountId:=Str(oTransH:taccid,-1)
		iPos:=AScan(aTotM,{|x|x[1]==AccountId})
		if Empty(iPos) 
			if !Empty(oTransH:aaccid)
				if !Empty(oTransH:mbrid)
					// category 1=home,2:projekts home,3: projects home sep.department,4:nonHome,5:unknown member,6:unknown account
					AAdd(aTotM,{AccountId,iif(oTransH:HOMEPP==sEntity,iif(oTransH:CO="M",1,iif(oTransH:Department==MainDeP,2,3)),4),0,0,0,0,0,0,0,AllTrim(Transform(oTransH:adesc,""))})
				else
					// add as unknown member:
					AAdd(aTotM,{AccountId,5,0,0,0,0,0,0,0,AllTrim(Transform(oTransH:adesc,""))})
				endif
			else
				// add as totally unknown member: 
				nUnknown++
				AAdd(aTotM,{AccountId,6,0,0,0,0,0,0,0,"unknown"+Str(nUnknown,-1)})
			endif
			iPos:=Len(aTotM)
		endif   
		do CASE
		CASE oTransH:GC=="AG".and. ConI(oTransH:FROMRPP)=0
			aTotM[iPos,3]:=Round(aTotM[iPos,3]+oTransH:cre-oTransH:DEB,DecAantal)
		CASE oTransH:GC=="AG".and. ConI(oTransH:FROMRPP)=1
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
	// {{AccountId,category,totAg, totAGFromRpp, TotMG, totPF, TotCH,TotAssOff,TotAssInt, membername},...} 
	//      1         2       3          4          5     6       7      8          9        10
	ASort(aTotM,,,{|x,y|x[2]<y[2] .or.(x[2]==y[2].and.x[10]<y[10])})
	// print totals:
	oReport:PrintLine(@nRow,@nPage,' ',headingtext,1)
	if Len(aTotM)>0
		CurCat:=aTotM[1,2]
	endif
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
