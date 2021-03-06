FUNCTION CtoN(cKey as string) as int
* Translate a code of nLen printable characters to a sequence number nNbr, which is returned
*
LOCAL i,nPos,nNbr as int
nNbr:=0
FOR i:=1 to Len(cKey)
	nPos:=Asc(SubStr(cKey,i,1))
	IF nPos>=123         // skip lower case
		nPos-=66
	ELSE
		nPos-=40
	ENDIF
	nNbr :=nNbr*61 +nPos
NEXT
IF nNbr<0
	nNbr:=0
ENDIF
RETURN nNbr
CLASS EditMailCd INHERIT DataWindowExtra 

	PROTECT oDCSC_OMS AS FIXEDTEXT
	PROTECT oDCmOMS AS SINGLELINEEDIT
	PROTECT oDCmAbbrvtn AS SINGLELINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
PROTECT  nCurRec AS INT
EXPORT oCaller AS OBJECT
PROTECT mCod AS STRING
RESOURCE EditMailCd DIALOGEX  13, 12, 288, 57
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Description:", EDITMAILCD_SC_OMS, "Static", WS_CHILD, 13, 14, 39, 13
	CONTROL	"Description:", EDITMAILCD_MOMS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 63, 14, 146, 13, WS_EX_CLIENTEDGE
	CONTROL	"Abbrevation", EDITMAILCD_MABBRVTN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 64, 33, 37, 12, WS_EX_CLIENTEDGE
	CONTROL	"OK", EDITMAILCD_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 225, 7, 53, 12
	CONTROL	"Cancel", EDITMAILCD_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 225, 27, 53, 12
	CONTROL	"Abbreviation:", EDITMAILCD_FIXEDTEXT1, "Static", WS_CHILD, 13, 35, 47, 12
END

METHOD CancelButton( ) CLASS EditMailCd
	SELF:EndWindow()
	RETURN
METHOD Close(oEvent) CLASS EditMailCd
	SUPER:Close(oEvent)
	//Put your changes here
	SELF:destroy()
	RETURN NIL
Method GetNextKey() as string class EditMailCd
// determine next free key for mailingcode
local oSel as SQLSelect
local nKey as int
	oSel := SqlSelect{"select pers_code from perscod order by pers_code desc limit 1",oConn}
	if oSel:RecCount<1
		return NtoC(1,2)
	endif
	nKey:=CtoN(oSel:pers_code)+1
	return NtoC(nKey,2)

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditMailCd 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditMailCd",_GetInst()},iCtlID)

oDCSC_OMS := FixedText{SELF,ResourceID{EDITMAILCD_SC_OMS,_GetInst()}}
oDCSC_OMS:HyperLabel := HyperLabel{#SC_OMS,"Description:",NULL_STRING,NULL_STRING}

oDCmOMS := SingleLineEdit{SELF,ResourceID{EDITMAILCD_MOMS,_GetInst()}}
oDCmOMS:FieldSpec := Perscod_OMS{}
oDCmOMS:HyperLabel := HyperLabel{#mOMS,"Description:","Description of group of persons","Perscod_OMS"}

oDCmAbbrvtn := SingleLineEdit{SELF,ResourceID{EDITMAILCD_MABBRVTN,_GetInst()}}
oDCmAbbrvtn:HyperLabel := HyperLabel{#mAbbrvtn,"Abbrevation",NULL_STRING,NULL_STRING}
oDCmAbbrvtn:FieldSpec := Perscod_Abbrvtn{}

oCCOKButton := PushButton{SELF,ResourceID{EDITMAILCD_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITMAILCD_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{EDITMAILCD_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Abbreviation:",NULL_STRING,NULL_STRING}

SELF:Caption := "Edit of a Mailing Code"
SELF:HyperLabel := HyperLabel{#EditMailCd,"Edit of a Mailing Code",NULL_STRING,NULL_STRING}
SELF:AllowServerClose := False

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mAbbrvtn() CLASS EditMailCd
RETURN SELF:FieldGet(#mAbbrvtn)

ASSIGN mAbbrvtn(uValue) CLASS EditMailCd
SELF:FieldPut(#mAbbrvtn, uValue)
RETURN uValue

ACCESS mOMS() CLASS EditMailCd
RETURN SELF:FieldGet(#mOMS)

ASSIGN mOMS(uValue) CLASS EditMailCd
SELF:FieldPut(#mOMS, uValue)
RETURN uValue

METHOD OKButton( ) CLASS EditMailCd
	LOCAL oMcd, oMcdCheck as SQLSelect 
	local oStmnt as SQLStatement
	oMcd:=self:Server
	IF !self:lnew
		IF Empty(self:mCod)
		* empty line
			self:EndWindow()
			RETURN
		ENDIF
	ENDIF
		*Check obliged fields:
		IF Empty(self:mOms)
			(ErrorBox{,self:oLan:WGet("Description obliged") }):Show()
            RETURN nil
		ENDIF
		IF Empty(self:mAbbrvtn)
			(ErrorBox{,self:oLan:WGet("Abbreviation obliged") }):Show()
            RETURN nil
		ENDIF
		
		* check if mailcd allready exists:
	    IF (lnew.or.AllTrim(oMcd:Description) # AllTrim(self:mOms).or.AllTrim(oMcd:abbrvtn) # AllTrim(self:mAbbrvtn))
			IF lnew .or. AllTrim(oMcd:Description) # AllTrim(self:mOms)
				if SQLSelect{"select description from perscod where description='"+AddSlashes(AllTrim(self:mOms))+"' and pers_code<>'"+addslashes(self:mCod)+"'",oConn}:RecCount>0
					(ErrorBox{,'Mailcode description '+ AllTrim(self:mOms) +' already exists' }):Show()
					RETURN nil
				ENDIF
			ENDIF
			IF lnew .or. AllTrim(oMcd:abbrvtn) # AllTrim(self:mAbbrvtn).and.!Empty(self:mAbbrvtn)
				if SqlSelect{"select description from perscod where abbrvtn='"+AllTrim(self:mAbbrvtn)+"' and pers_code<>'"+addslashes(self:mCod)+"'",oConn}:RecCount>0
					(ErrorBox{,'Mailcode abbreviation '+ AllTrim(self:mAbbrvtn) +' already exists' }):Show()
					RETURN nil
				ENDIF
			ENDIF
	    ENDIF
	    oStmnt:=SQLStatement{iif(self:lnew,"insert into","update")+" perscod set description='"+AddSlashes(self:mOms)+"',abbrvtn='"+Upper(self:mAbbrvtn)+"'"+;
	    iif(self:lnew,",pers_code='"+addslashes(self:GetNextKey())+"'"," where pers_code='"+addslashes(self:mCod)+"'"),oConn}
	    oStmnt:Execute()
	    if Empty(oStmnt:status) .and.oStmnt:NumSuccessfulRows>0 
			self:oCaller:refresh()
			FillPersCode()
	    endif   
		self:EndWindow()
RETURN nil
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditMailCd
	//Put your PostInit additions here
	LOCAL oMcd:=self:server as SQLSelect
	self:SetTexts()
	SaveUse(self)
	oCaller:=oWindow
	IF Empty(uExtra)
		lNew :=FALSE
	ELSE
		lNew:=TRUE
	ENDIF
	IF !lNew
		self:mOms := oMcd:description
		self:mCod := oMcd:pers_code
		self:mAbbrvtn := oMcd:abbrvtn
	ELSE
		self:mCod:="  "
    ENDIF

	RETURN NIL
STATIC DEFINE EDITMAILCD_CANCELBUTTON := 104 
STATIC DEFINE EDITMAILCD_FIXEDTEXT1 := 105 
STATIC DEFINE EDITMAILCD_MABBRVTN := 102 
STATIC DEFINE EDITMAILCD_MOMS := 101 
STATIC DEFINE EDITMAILCD_OKBUTTON := 103 
STATIC DEFINE EDITMAILCD_SC_OMS := 100 
RESOURCE EditPersProp DIALOGEX  13, 12, 333, 170
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Property name:", EDITPERSPROP_FIXEDTEXT1, "Static", WS_CHILD, 16, 11, 53, 13
	CONTROL	"", EDITPERSPROP_MPROPNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 83, 11, 102, 12, WS_EX_CLIENTEDGE
	CONTROL	"Property type:", EDITPERSPROP_FIXEDTEXT2, "Static", WS_CHILD, 16, 28, 53, 13
	CONTROL	"", EDITPERSPROP_MTYPE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 83, 25, 102, 61
	CONTROL	"Drop Down Values:", EDITPERSPROP_FIXEDTEXT3, "Static", WS_CHILD|NOT WS_VISIBLE, 16, 45, 63, 12
	CONTROL	"", EDITPERSPROP_MVALUES, "Edit", ES_WANTRETURN|ES_AUTOHSCROLL|ES_AUTOVSCROLL|ES_MULTILINE|ES_RIGHT|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER|WS_VSCROLL|WS_HSCROLL, 83, 44, 241, 111, WS_EX_CLIENTEDGE
	CONTROL	"(seperated by comma)", EDITPERSPROP_FIXEDTEXT4, "Static", WS_CHILD|NOT WS_VISIBLE, 15, 54, 53, 21
	CONTROL	"Cancel", EDITPERSPROP_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 268, 27, 54, 12
	CONTROL	"OK", EDITPERSPROP_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 268, 6, 54, 13
END

CLASS EditPersProp INHERIT DataWindowExtra 

	PROTECT oDBMPROPNAME as DataColumn
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCmPropName AS SINGLELINEEDIT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCmType AS COMBOBOX
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCmValues AS MULTILINEEDIT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT oCaller AS OBJECT
  PROTECT mID as int 
  export CurDropVal as array

METHOD CancelButton( ) CLASS EditPersProp
	SELF:EndWindow()
RETURN NIL
METHOD Close(oEvent) CLASS EditPersProp
	SUPER:Close(oEvent)
	//Put your changes here
	SELF:destroy()
	RETURN NIL

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditPersProp 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditPersProp",_GetInst()},iCtlID)

oDCFixedText1 := FixedText{SELF,ResourceID{EDITPERSPROP_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Property name:",NULL_STRING,NULL_STRING}

oDCmPropName := SingleLineEdit{SELF,ResourceID{EDITPERSPROP_MPROPNAME,_GetInst()}}
oDCmPropName:HyperLabel := HyperLabel{#mPropName,NULL_STRING,"Name to be shown op Person Window",NULL_STRING}
oDCmPropName:UseHLforToolTip := True

oDCFixedText2 := FixedText{SELF,ResourceID{EDITPERSPROP_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Property type:",NULL_STRING,NULL_STRING}

oDCmType := combobox{SELF,ResourceID{EDITPERSPROP_MTYPE,_GetInst()}}
oDCmType:HyperLabel := HyperLabel{#mType,NULL_STRING,"Field type",NULL_STRING}
oDCmType:FillUsing(prop_types)

oDCFixedText3 := FixedText{SELF,ResourceID{EDITPERSPROP_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Drop Down Values:",NULL_STRING,NULL_STRING}

oDCmValues := MultiLineEdit{SELF,ResourceID{EDITPERSPROP_MVALUES,_GetInst()}}
oDCmValues:HyperLabel := HyperLabel{#mValues,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{EDITPERSPROP_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"(seperated by comma)",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITPERSPROP_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{EDITPERSPROP_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

SELF:Caption := "Edit Self Defined Property"
SELF:HyperLabel := HyperLabel{#EditPersProp,"Edit Self Defined Property",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
self:Browser := DataBrowser{self}

oDBMPROPNAME := DataColumn{11}
oDBMPROPNAME:Width := 11
oDBMPROPNAME:HyperLabel := oDCMPROPNAME:HyperLabel 
oDBMPROPNAME:Caption := ""
self:Browser:AddColumn(oDBMPROPNAME)


SELF:ViewAs(#FormView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListBoxSelect(oControlEvent) CLASS EditPersProp
	LOCAL oControl AS Control  , uValue AS USUAL
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControlEvent:NameSym==#mType
		uValue:=oControlEvent:Control:Value
		IF uValue==DROPDOWN
			SELF:oDCmValues:Show()
			SELF:oDCFixedText3:Show()
			SELF:oDCFixedText4:Show()
		ELSE
			SELF:oDCmValues:Hide()
			SELF:oDCFixedText3:Hide()
			SELF:oDCFixedText4:Hide()
		ENDIF
    ENDIF
	RETURN NIL

ACCESS mPropName() CLASS EditPersProp
RETURN SELF:FieldGet(#mPropName)

ASSIGN mPropName(uValue) CLASS EditPersProp
SELF:FieldPut(#mPropName, uValue)
RETURN uValue

ACCESS mType() CLASS EditPersProp
RETURN SELF:FieldGet(#mType)

ASSIGN mType(uValue) CLASS EditPersProp
SELF:FieldPut(#mType, uValue)
RETURN uValue

ACCESS mValues() CLASS EditPersProp
RETURN SELF:FieldGet(#mValues)

ASSIGN mValues(uValue) CLASS EditPersProp
SELF:FieldPut(#mValues, uValue)
RETURN uValue

METHOD OKButton( ) CLASS EditPersProp
	LOCAL oProp as SQLSelect 
	local cStatement,CurValue as string
	local oStmnt as SQLStatement 
	local aNewDropValues:={} as array
	local i as int
	local cRemoved,cRemoveCond,cTotal as string 
	oProp:=self:server
	IF !self:lnew
		IF Empty(self:mId)
			* empty line
			self:EndWindow()
			RETURN
		ENDIF
	ENDIF
	*Check obliged fields:
	IF Empty(self:MPROPNAME)
		(ErrorBox{,"Name obliged" }):Show()
		RETURN nil
	ENDIF
	IF self:mType==DROPDOWN .and. Empty(self:mValues)
		(ErrorBox{,self:oLan:WGet("Enter at least one value") }):Show()
		RETURN nil
	ENDIF
	* check if Property allready exists:
	IF self:lnew .or. AllTrim(oProp:FIELDGET(#NAME)) # AllTrim(self:MPROPNAME)
		if SQLSelect{"select name from person_properties where name='"+AddSlashes(AllTrim(self:MPROPNAME))+"' and id<>"+Str(self:mId,-1),oConn}:RecCount>0
			(ErrorBox{,'Property Name '+ AllTrim(self:mPropName) +' already exists' }):Show()
			RETURN nil
		ENDIF
	ENDIF 
	// check if dropdown value changed/removed:
	if !self:lnew .and. self:mType==DROPDOWN
		aNewDropValues:=Split(self:mValues,",")
		for i:=1 to Len(self:CurDropVal)
			CurValue:=AllTrim(StrTran(StrTran(CurDropVal[i],CRLF,''),LF,''))
			if !Empty(CurValue) .and.AScan(aNewDropValues,{|x|StrTran(x,LF,'')==CurValue})=0  
				oProp:=SQLSelect{"select count(*) as total from person where deleted=0 and instr(propextr,'<V"+Str(self:mId,-1)+">"+CurValue+"</v"+Str(self:mId,-1)+">')>0",oConn}
				if oProp:RecCount>0
					cTotal:=ConS(oProp:total)
				else
					cTotal:="0"
				endif
				cRemoveCond+=iif(Empty(cRemoveCond),""," or ")+"instr(propextr,'<V"+Str(self:mId,-1)+">"+CurValue+"</v"+Str(self:mId,-1)+">')>0"
				cRemoved+=CurValue+Space(1)+self:oLan:WGet("used in")+Space(1)+cTotal+Space(1)+self:oLan:WGet("persons")+CRLF
			endif 
		next
		IF !Empty(cRemoved)
			IF (TextBox{ self, self:oLan:WGet("Update Property"),;
			self:oLan:WGet("Do you want to remove the following values")+"?"+CRLF+cRemoved,BUTTONYESNO + BOXICONQUESTIONMARK }):Show()== BOXREPLYNO
				return nil
			endif
		endif
	endif
	cStatement:=iif(self:lnew,"insert into ","update ")+"person_properties set name='"+AddSlashes(AllTrim(self:MPROPNAME))+"',type="+Str(self:mType,-1)+",`values`='"+AllTrim(Lower(StrTran(StrTran(StrTran(StrTran(AllTrim(Compress(self:mValues)),LF,''),", ",",")," ,",","),"'","\'")))+"'"+;
	iif(self:lnew,""," where id="+Str(self:mId,-1)) 
	oStmnt:=SQLStatement{cStatement,oConn}
	oStmnt:Execute()
	if oStmnt:NumSuccessfulRows>0
		FillPersProp()
		if !Empty(cRemoveCond)
			// remove propertu from persons:
			oStmnt:=SQLStatement{"update person set propextr=concat(substring(propextr,1,instr(propextr,'<V"+Str(self:mId,-1)+">')-1)"+;
			",substring(propextr,instr(propextr,'</V"+Str(self:mId,-1)+">')+"+Str(Len(Str(self:mId,-1))+4,-1)+"))"+;
			" where ("+cRemoveCond+")",oConn}
			oStmnt:Execute() 
			TextBox{,self:oLan:WGet("Removal property values"),Str(oStmnt:NumSuccessfulRows,-1)+" "+self:oLan:WGet("persons updated")}:Show()
		endif
		FillPersProp()
		self:oCaller:oProp:Execute()
		self:oCaller:gotop()
	endif
	self:EndWindow()
	RETURN nil
	
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditPersProp
	//Put your PostInit additions here
	LOCAL oProp as SQLSelect
	self:SetTexts()
	SaveUse(self)
	oProp:=self:Server
	oCaller:=oWindow
	IF Empty(uExtra)
		SELF:lNew :=FALSE
	ELSE
		SELF:lNew:=TRUE
	ENDIF
	IF !lNew
		self:MPROPNAME := oProp:FIELDGET(2)  //name
		self:mId := oProp:id
		self:oDCmType:TextValue := oProp:typedescr
		self:mValues:=oProp:VALUES
		IF self:mType==DROPDOWN
			self:oDCmValues:Show()
			self:CurDropVal:=Split(self:oDCmValues:TextValue,",")
			self:oDCFixedText3:Show()
			SELF:oDCFixedText4:Show()
		ENDIF
	ELSE
		self:mId:=0
		self:mType:=DROPDOWN
		SELF:oDCmValues:Show()
		SELF:oDCFixedText3:Show()
		SELF:oDCFixedText4:Show()
    ENDIF
	RETURN NIL
STATIC DEFINE EDITPERSPROP_CANCELBUTTON := 107 
STATIC DEFINE EDITPERSPROP_FIXEDTEXT1 := 100 
STATIC DEFINE EDITPERSPROP_FIXEDTEXT2 := 102 
STATIC DEFINE EDITPERSPROP_FIXEDTEXT3 := 104 
STATIC DEFINE EDITPERSPROP_FIXEDTEXT4 := 106 
STATIC DEFINE EDITPERSPROP_MPROPNAME := 101 
STATIC DEFINE EDITPERSPROP_MTYPE := 103 
STATIC DEFINE EDITPERSPROP_MVALUES := 105 
STATIC DEFINE EDITPERSPROP_OKBUTTON := 108 
CLASS EditPersTitle INHERIT DataWindowMine

	PROTECT oDCSC_OMS AS FIXEDTEXT
	PROTECT oDCmDescrptn AS SINGLELINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	INSTANCE mDescrptn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
    PROTECT  nCurRec AS INT
EXPORT oCaller AS OBJECT
PROTECT mId AS INT
PROTECT lNew AS LOGIC
RESOURCE EditPersTitle DIALOGEX  6, 6, 294, 56
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Description:", EDITPERSTITLE_SC_OMS, "Static", WS_CHILD, 13, 14, 39, 13
	CONTROL	"Description:", EDITPERSTITLE_MDESCRPTN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 63, 14, 146, 13, WS_EX_CLIENTEDGE
	CONTROL	"OK", EDITPERSTITLE_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 225, 7, 53, 12
	CONTROL	"Cancel", EDITPERSTITLE_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 225, 27, 53, 12
END

METHOD CancelButton( ) CLASS EditPersTitle
		SELF:EndWindow()
RETURN
method Init(oWindow,iCtlID,oServer,uExtra) class EditPersTitle 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

super:Init(oWindow,ResourceID{"EditPersTitle",_GetInst()},iCtlID)

oDCSC_OMS := FixedText{self,ResourceID{EDITPERSTITLE_SC_OMS,_GetInst()}}
oDCSC_OMS:HyperLabel := HyperLabel{#SC_OMS,"Description:",NULL_STRING,NULL_STRING}

oDCmDescrptn := SingleLineEdit{self,ResourceID{EDITPERSTITLE_MDESCRPTN,_GetInst()}}
oDCmDescrptn:FieldSpec := Titles_Descrptn{}
oDCmDescrptn:HyperLabel := HyperLabel{#mDescrptn,"Description:","Description of  title",NULL_STRING}
oDCmDescrptn:UseHLforToolTip := True

oCCOKButton := PushButton{self,ResourceID{EDITPERSTITLE_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{self,ResourceID{EDITPERSTITLE_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

self:Caption := "Edit Title"
self:HyperLabel := HyperLabel{#EditPersTitle,"Edit Title",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	self:Use(oServer)
endif

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

access mDescrptn() class EditPersTitle
return self:FieldGet(#mDescrptn)

assign mDescrptn(uValue) class EditPersTitle
self:FieldPut(#mDescrptn, uValue)
return mDescrptn := uValue

METHOD OKButton( ) CLASS EditPersTitle
	LOCAL oTit as SQLSelect
	local oStmnt as SQLStatement
	oTit:=self:Server
	IF !self:lnew
		IF Empty(mId)
		* empty line
			self:EndWindow()
			RETURN
		ENDIF
	ENDIF
		*Check obliged fields:
		IF Empty(self:mDescrptn)
			(ErrorBox{,"Description obliged" }):Show()
            RETURN nil
		ENDIF
		
		* check if Title allready exists:
		IF self:lnew .or. AllTrim(oTit:DESCRPTN) # AllTrim(mDescrptn)
			if SQLSelect{"select id from titles where descrptn='"+AllTrim(mDescrptn)+"' and id<>"+Str(self:mId,-1),oConn}:RecCount>0 
				(ErrorBox{,'Title description '+ AllTrim(mDescrptn) +' already exists' }):Show()
				RETURN nil
			ENDIF
		ENDIF 
		oStmnt:=SQLStatement{iif(self:lnew,"insert into","update")+" titles set descrptn='"+self:mDescrptn+"'"+;
	    iif(self:lnew,""," where id='"+Str(self:mId,-1)+"'"),oConn}
	    oStmnt:Execute()
	    if Empty(oStmnt:status) .and.oStmnt:NumSuccessfulRows>0 
			self:oCaller:refresh()
			FillPersTitle()
	    endif   

		self:EndWindow()
RETURN nil
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditPersTitle
	//Put your PostInit additions here
	LOCAL oTit as SQLSelect
	self:SetTexts()
	SaveUse(self)
	oTit:=self:Server
	oCaller:=oWindow
	IF Empty(uExtra)
		SELF:lNew :=FALSE
	ELSE
		SELF:lNew:=TRUE
	ENDIF
	IF !lNew
		self:mDescrptn := oTit:DESCRPTN
		mId := oTit:id
	ELSE
		mId:=0
    ENDIF

	RETURN NIL
STATIC DEFINE EDITPERSTITLE_CANCELBUTTON := 103 
STATIC DEFINE EDITPERSTITLE_MDESCRPTN := 101 
STATIC DEFINE EDITPERSTITLE_OKBUTTON := 102 
STATIC DEFINE EDITPERSTITLE_SC_OMS := 100 
RESOURCE EditPersType DIALOGEX  8, 7, 291, 63
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Description:", EDITPERSTYPE_SC_OMS, "Static", WS_CHILD, 13, 14, 39, 13
	CONTROL	"Description:", EDITPERSTYPE_MDESCRPTN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 63, 14, 146, 13, WS_EX_CLIENTEDGE
	CONTROL	"Abbrevation", EDITPERSTYPE_MABBRVTN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 63, 36, 37, 13, WS_EX_CLIENTEDGE
	CONTROL	"OK", EDITPERSTYPE_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 225, 7, 53, 12
	CONTROL	"Cancel", EDITPERSTYPE_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 225, 27, 53, 12
	CONTROL	"Abbreviation:", EDITPERSTYPE_FIXEDTEXT1, "Static", WS_CHILD, 13, 38, 47, 13
END

class EditPersType inherit DataWindowExtra 

	protect oDCSC_OMS as FIXEDTEXT
	protect oDCmDescrptn as SINGLELINEEDIT
	protect oDCmAbbrvtn as SINGLELINEEDIT
	protect oCCOKButton as PUSHBUTTON
	protect oCCCancelButton as PUSHBUTTON
	protect oDCFixedText1 as FIXEDTEXT
	instance mDescrptn 
	instance mAbbrvtn 

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
EXPORT oCaller AS OBJECT
PROTECT mId AS INT

METHOD CancelButton( ) CLASS EditPersType
	SELF:EndWindow()
RETURN
method Init(oWindow,iCtlID,oServer,uExtra) class EditPersType 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

super:Init(oWindow,ResourceID{"EditPersType",_GetInst()},iCtlID)

oDCSC_OMS := FixedText{self,ResourceID{EDITPERSTYPE_SC_OMS,_GetInst()}}
oDCSC_OMS:HyperLabel := HyperLabel{#SC_OMS,"Description:",NULL_STRING,NULL_STRING}

oDCmDescrptn := SingleLineEdit{self,ResourceID{EDITPERSTYPE_MDESCRPTN,_GetInst()}}
oDCmDescrptn:FieldSpec := Persontype_descrptn{}
oDCmDescrptn:HyperLabel := HyperLabel{#mDescrptn,"Description:","Description of  persontype: individual, company, ...",null_string}
oDCmDescrptn:UseHLforToolTip := True

oDCmAbbrvtn := SingleLineEdit{self,ResourceID{EDITPERSTYPE_MABBRVTN,_GetInst()}}
oDCmAbbrvtn:HyperLabel := HyperLabel{#mAbbrvtn,"Abbrevation",NULL_STRING,NULL_STRING}
oDCmAbbrvtn:FieldSpec := Persontype_ABBRVTN{}

oCCOKButton := PushButton{self,ResourceID{EDITPERSTYPE_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{self,ResourceID{EDITPERSTYPE_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{self,ResourceID{EDITPERSTYPE_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Abbreviation:",NULL_STRING,NULL_STRING}

self:Caption := "Edit Person Type"
self:HyperLabel := HyperLabel{#EditPersType,"Edit Person Type",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	self:Use(oServer)
endif

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

access mAbbrvtn() class EditPersType
return self:FieldGet(#mAbbrvtn)

assign mAbbrvtn(uValue) class EditPersType
self:FieldPut(#mAbbrvtn, uValue)
return mAbbrvtn := uValue

access mDescrptn() class EditPersType
return self:FieldGet(#mDescrptn)

assign mDescrptn(uValue) class EditPersType
self:FieldPut(#mDescrptn, uValue)
return mDescrptn := uValue

METHOD OKButton(lnew ) CLASS EditPersType
	LOCAL oPtp as SQLSelect
	local oStmnt as SQLStatement
	local  Abr:=AllTrim(self:mAbbrvtn),Desc:=AllTrim(self:mDescrptn) as string 
	oPtp:=self:Server
	IF !self:lnew
		IF Empty(mId)
		* empty line
			self:EndWindow()
			RETURN
		ENDIF
	ENDIF
		*Check obliged fields:
		IF Empty(self:mDescrptn)
			(ErrorBox{,self:oLan:WGet("Description obliged") }):Show()
            RETURN nil
		ENDIF
		IF Empty(self:mAbbrvtn)
			(ErrorBox{,self:oLan:WGet("Abbreviation obliged") }):Show()
            RETURN nil
		ENDIF
		
		* check if person type allready exists:
	    IF (self:lnew.or.AllTrim(oPtp:DESCRPTN)#AllTrim(mDescrptn).or.AllTrim(oPtp:abbrvtn)#AllTrim(mAbbrvtn)) 
			if SQLSelect{"select id from persontype where (abbrvtn='"+AllTrim(mAbbrvtn)+"' or descrptn='"+AllTrim(mDescrptn)+"') and id<>"+Str(self:mId,-1),oConn}:RecCount>0  
				(ErrorBox{,self:oLan:WGet('Person type description or abbrevation already exists') }):Show()
				RETURN nil
			endif
		ENDIF
		oStmnt:=SQLStatement{iif(self:lnew,"insert into","update")+" persontype set descrptn='"+self:mDescrptn+"',abbrvtn='"+Upper(self:mAbbrvtn)+"'"+;
	    iif(self:lnew,""," where id='"+Str(self:mId,-1)+"'"),oConn}
	    oStmnt:Execute()
	    if Empty(oStmnt:status) .and.oStmnt:NumSuccessfulRows>0 
			self:oCaller:refresh()
			FillPersType()
	    endif   
		self:EndWindow()
RETURN nil
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditPersType
	//Put your PostInit additions here
	LOCAL oPtp as SQLSelect 
	self:SetTexts()
	SaveUse(self)
	oPtp:=self:Server
	oCaller:=oWindow
	IF Empty(uExtra)
		SELF:lNew :=FALSE
	ELSE
		SELF:lNew:=TRUE
	ENDIF
	IF !lNew
		self:mDescrptn := oPtp:DESCRPTN
		self:mId := oPtp:id
		self:mAbbrvtn := oPtp:abbrvtn
		IF self:mAbbrvtn=="IND" .or. self:mAbbrvtn=="MBR" .or.self:mAbbrvtn=="ENT"
			SELF:oDCmAbbrvtn:Disable()
		ENDIF
	ELSE
		self:mId:=0
    ENDIF

	RETURN NIL
STATIC DEFINE EDITPERSTYPE_CANCELBUTTON := 104 
STATIC DEFINE EDITPERSTYPE_FIXEDTEXT1 := 105 
STATIC DEFINE EDITPERSTYPE_MABBRVTN := 102 
STATIC DEFINE EDITPERSTYPE_MDESCRPTN := 101 
STATIC DEFINE EDITPERSTYPE_OKBUTTON := 103 
STATIC DEFINE EDITPERSTYPE_SC_OMS := 100 
STATIC DEFINE MAILCDREG_DELETEBUTTON := 103 
STATIC DEFINE MAILCDREG_EDITBUTTON := 101 
STATIC DEFINE MAILCDREG_NEWBUTTON := 102 
STATIC DEFINE MAILCDREG_SUB_MAILCDREG := 100 
STATIC DEFINE MAILCDREGOUD_OKBUTTON := 104 
STATIC DEFINE MAILCDREGOUD_OMS := 103 
STATIC DEFINE MAILCDREGOUD_PERS_CODE := 102 
STATIC DEFINE MAILCDREGOUD_SC_OMS := 101 
STATIC DEFINE MAILCDREGOUD_SC_PERS_CODE := 100 
FUNCTION NtoC(nNbr as int,nLen as int) as string
* Translate a sequence number nNbr to code of nLen printable characters, which is returned
* E.g. three printable characters is sufficient for a sequence number up to 61*61*61=226981
*
LOCAL i,nIntrm,nPos as int
LOCAL cKey as STRING
nIntrm:=nNbr
FOR i:=nLen DOWNTO 1
	nPos:=nIntrm%61
	IF nPos>=57         // skip lower case
		nPos+=66
	ELSE
		nPos+=40
	ENDIF
	cKey:=CHR(nPos)+cKey
	nIntrm/=61
NEXT
RETURN cKey

RESOURCE PersonParms DIALOGEX  12, 11, 387, 269
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Mailcodes", PERSONPARMS_TABMAIL, "SysTabControl32", WS_CHILD, 4, 22, 379, 239
	CONTROL	"Person Parameters", PERSONPARMS_PERSON_PARAMETERS, "Static", SS_CENTER|WS_CHILD, 8, 4, 321, 13
END

CLASS PersonParms INHERIT DataWindowExtra 

	PROTECT oDCTabMail AS TABCONTROL
	protect oTPTABMAIL_PAGE as TABMAIL_PAGE
	protect oTPTABTITLE_PAGE as TABTITLE_PAGE
	protect oTPTABTYPE_PAGE as TABTYPE_PAGE
	protect oTPTABPROP_PAGE as TABPROP_PAGE
	PROTECT oDCPerson_Parameters AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS PersonParms 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"PersonParms",_GetInst()},iCtlID)

aFonts[1] := Font{,12,"Microsoft Sans Serif"}
aFonts[1]:Bold := TRUE

oDCTabMail := TabControl{SELF,ResourceID{PERSONPARMS_TABMAIL,_GetInst()}}
oDCTabMail:HyperLabel := HyperLabel{#TabMail,"Mailcodes","Mail Codes",NULL_STRING}
oDCTabMail:OwnerAlignment := OA_HEIGHT

oDCPerson_Parameters := FixedText{SELF,ResourceID{PERSONPARMS_PERSON_PARAMETERS,_GetInst()}}
oDCPerson_Parameters:HyperLabel := HyperLabel{#Person_Parameters,"Person Parameters",NULL_STRING,NULL_STRING}
oDCPerson_Parameters:Font(aFonts[1], FALSE)

SELF:Caption := "Person parameters"
SELF:HyperLabel := HyperLabel{#PersonParms,"Person parameters",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
oTPTABMAIL_PAGE := TABMAIL_PAGE{SELF, 0}
oDCTabMail:AppendTab(#TABMAIL_PAGE,"Mail Codes",oTPTABMAIL_PAGE,0)
oTPTABTITLE_PAGE := TABTITLE_PAGE{SELF, 0}
oDCTabMail:AppendTab(#TABTITLE_PAGE,"Titles",oTPTABTITLE_PAGE,0)
oTPTABTYPE_PAGE := TABTYPE_PAGE{SELF, 0}
oDCTabMail:AppendTab(#TABTYPE_PAGE,"Types",oTPTABTYPE_PAGE,0)
oTPTABPROP_PAGE := TABPROP_PAGE{SELF, 0}
oDCTabMail:AppendTab(#TABPROP_PAGE,"Extra properties",oTPTABPROP_PAGE,0)
oDCTabMail:SelectTab(#TABMAIL_PAGE)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

STATIC DEFINE PERSONPARMS_PERSON_PARAMETERS := 101 
STATIC DEFINE PERSONPARMS_TABMAIL := 100 
STATIC DEFINE PERSTITLEREG_DELETEBUTTON := 103 
STATIC DEFINE PERSTITLEREG_EDITBUTTON := 101 
STATIC DEFINE PERSTITLEREG_NEWBUTTON := 102 
STATIC DEFINE PERSTITLEREG_SUB_PERSTITLEREG := 100 
STATIC DEFINE PERSTYPEREG_DELETEBUTTON := 103 
STATIC DEFINE PERSTYPEREG_EDITBUTTON := 101 
STATIC DEFINE PERSTYPEREG_NEWBUTTON := 102 
STATIC DEFINE PERSTYPEREG_SUB_PERSTYPEREG := 100 
RESOURCE Sub_MailCdReg DIALOGEX  16, 14, 226, 187
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

CLASS Sub_MailCdReg INHERIT DataWindowMine 

	PROTECT oDBDESCRIPTION as DataColumn
	PROTECT oDBABBRVTN as DataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS Sub_MailCdReg 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"Sub_MailCdReg",_GetInst()},iCtlID)

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#Sub_MailCdReg,"DataWindow Caption",NULL_STRING,NULL_STRING}
SELF:OwnerAlignment := OA_PWIDTH_HEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBDESCRIPTION := DataColumn{Perscod_OMS{}}
oDBDESCRIPTION:Width := 38
oDBDESCRIPTION:HyperLabel := HyperLabel{#description,"Mail code description","Mail code description",NULL_STRING} 
oDBDESCRIPTION:Caption := "Mail code description"
self:Browser:AddColumn(oDBDESCRIPTION)

oDBABBRVTN := DataColumn{Perscod_Abbrvtn{}}
oDBABBRVTN:Width := 17
oDBABBRVTN:HyperLabel := HyperLabel{#Abbrvtn,"Abbreviation",NULL_STRING,NULL_STRING} 
oDBABBRVTN:Caption := "Abbreviation"
self:Browser:AddColumn(oDBABBRVTN)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS Sub_MailCdReg
	//Put your PostInit additions here
	self:SetTexts()
	self:Browser:SetStandardStyle(gbsReadOnly)
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS Sub_MailCdReg
	//Put your PreInit additions here 
	oWindow:use(oWindow:oPerscd)
	RETURN NIL
STATIC DEFINE SUB_MAILCDREG_ABBRVTN := 101 
STATIC DEFINE SUB_MAILCDREG_DESCRIPTION := 100 
STATIC DEFINE SUB_MAILCDREG_OMS := 100 
CLASS Sub_PersPropReg INHERIT DataWindowMine 

	PROTECT oDBNAME as DataColumn
	PROTECT oDBTYPEDESCR as DataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
RESOURCE Sub_PersPropReg DIALOGEX  12, 11, 226, 186
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS Sub_PersPropReg 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"Sub_PersPropReg",_GetInst()},iCtlID)

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#Sub_PersPropReg,"DataWindow Caption",NULL_STRING,NULL_STRING}
SELF:OwnerAlignment := OA_PWIDTH_HEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBNAME := DataColumn{Person_Properties_NAME{}}
oDBNAME:Width := 26
oDBNAME:HyperLabel := HyperLabel{#Name,"Name",NULL_STRING,NULL_STRING} 
oDBNAME:Caption := "Name"
self:Browser:AddColumn(oDBNAME)

oDBTYPEDESCR := DataColumn{28}
oDBTYPEDESCR:Width := 28
oDBTYPEDESCR:HyperLabel := HyperLabel{#TypeDescr,"Type",NULL_STRING,NULL_STRING} 
oDBTYPEDESCR:Caption := "Type"
self:Browser:AddColumn(oDBTYPEDESCR)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS Name() CLASS Sub_PersPropReg
RETURN SELF:FieldGet(#Name)

ASSIGN Name(uValue) CLASS Sub_PersPropReg
SELF:FieldPut(#Name, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS Sub_PersPropReg
	//Put your PostInit additions here
	self:SetTexts()
	self:Browser:SetStandardStyle(gbsReadOnly)
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS Sub_PersPropReg
	//Put your PreInit additions here
	oWindow:use(oWindow:oProp)
	RETURN NIL

ACCESS TypeDescr() CLASS Sub_PersPropReg
RETURN SELF:FieldGet(#TypeDescr)

ASSIGN TypeDescr(uValue) CLASS Sub_PersPropReg
SELF:FieldPut(#TypeDescr, uValue)
RETURN uValue

STATIC DEFINE SUB_PERSPROPREG_NAME := 100 
STATIC DEFINE SUB_PERSPROPREG_TYPEDESCR := 101 
RESOURCE Sub_PersTitleReg DIALOGEX  8, 7, 226, 186
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

class Sub_PersTitleReg inherit DataWindowMine 

	PROTECT oDBDESCRPTN as DataColumn
	instance DESCRPTN 

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
access DESCRPTN() class Sub_PersTitleReg
return self:FieldGet(#DESCRPTN)

assign DESCRPTN(uValue) class Sub_PersTitleReg
self:FieldPut(#DESCRPTN, uValue)
return DESCRPTN := uValue

method Init(oWindow,iCtlID,oServer,uExtra) class Sub_PersTitleReg 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

super:Init(oWindow,ResourceID{"Sub_PersTitleReg",_GetInst()},iCtlID)

self:Caption := "DataWindow Caption"
self:HyperLabel := HyperLabel{#Sub_PersTitleReg,"DataWindow Caption",NULL_STRING,NULL_STRING}
self:OwnerAlignment := OA_HEIGHT

if !IsNil(oServer)
	self:Use(oServer)
else
	self:Use(self:Owner:Server)
endif
self:Browser := EditBrowser{self}

oDBDESCRPTN := DataColumn{Titles_Descrptn{}}
oDBDESCRPTN:Width := 53
oDBDESCRPTN:HyperLabel := HyperLabel{#DESCRPTN,"Title","Description of title",NULL_STRING} 
oDBDESCRPTN:Caption := "Title"
self:Browser:AddColumn(oDBDESCRPTN)


self:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS Sub_PersTitleReg
	//Put your PostInit additions here
	self:SetTexts()
	self:Browser:SetStandardStyle(gbsReadOnly)
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS Sub_PersTitleReg
	//Put your PreInit additions here
oWindow:use(oWindow:oTit)

	RETURN nil
STATIC DEFINE SUB_PERSTITLEREG_DESCRPTN := 100 
RESOURCE Sub_PersTypeReg DIALOGEX  13, 12, 226, 186
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

class Sub_PersTypeReg inherit DataWindowMine 

	PROTECT oDBDESCRPTN as DataColumn
	PROTECT oDBABBRVTN as DataColumn
	instance DESCRPTN 
	instance abbrvtn 

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
access abbrvtn() class Sub_PersTypeReg
return self:FieldGet(#Abbrvtn)

assign abbrvtn(uValue) class Sub_PersTypeReg
self:FieldPut(#Abbrvtn, uValue)
return abbrvtn := uValue

access DESCRPTN() class Sub_PersTypeReg
return self:FieldGet(#Descrptn)

assign DESCRPTN(uValue) class Sub_PersTypeReg
self:FieldPut(#Descrptn, uValue)
return DESCRPTN := uValue

method Init(oWindow,iCtlID,oServer,uExtra) class Sub_PersTypeReg 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

super:Init(oWindow,ResourceID{"Sub_PersTypeReg",_GetInst()},iCtlID)

self:Caption := "DataWindow Caption"
self:HyperLabel := HyperLabel{#Sub_PersTypeReg,"DataWindow Caption",NULL_STRING,NULL_STRING}
self:OwnerAlignment := OA_HEIGHT

if !IsNil(oServer)
	self:Use(oServer)
else
	self:Use(self:Owner:Server)
endif
self:Browser := EditBrowser{self}

oDBDESCRPTN := DataColumn{Persontype_descrptn{}}
oDBDESCRPTN:Width := 40
oDBDESCRPTN:HyperLabel := HyperLabel{#Descrptn,"Description","Description of person type",NULL_STRING} 
oDBDESCRPTN:Caption := "Description"
self:Browser:AddColumn(oDBDESCRPTN)

oDBABBRVTN := DataColumn{Persontype_ABBRVTN{}}
oDBABBRVTN:Width := 13
oDBABBRVTN:HyperLabel := HyperLabel{#Abbrvtn,"Abbrevation",NULL_STRING,NULL_STRING} 
oDBABBRVTN:Caption := "Abbrevation"
self:Browser:AddColumn(oDBABBRVTN)


self:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS Sub_PersTypeReg
	//Put your PostInit additions here
	self:SetTexts()
	self:Browser:SetStandardStyle(gbsReadOnly)
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS Sub_PersTypeReg
	//Put your PreInit additions here
oWindow:use(oWindow:oType)
	RETURN nil

STATIC DEFINE SUB_PERSTYPEREG_ABBRVTN := 101 
STATIC DEFINE SUB_PERSTYPEREG_DESCRPTN := 100 
RESOURCE TABMAIL_PAGE DIALOGEX  17, 16, 373, 222
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TABMAIL_PAGE_SUB_MAILCDREG, "static", WS_CHILD|WS_BORDER, 14, 27, 240, 187
	CONTROL	"Edit", TABMAIL_PAGE_EDITBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 289, 68, 53, 13
	CONTROL	"New", TABMAIL_PAGE_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 289, 107, 53, 13
	CONTROL	"Delete", TABMAIL_PAGE_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 289, 145, 53, 13
	CONTROL	"Mailing Codes can be used to select people for mailing, printing lists, address labels, mail merge, thank-you letters, etc.", TABMAIL_PAGE_FIXEDTEXT1, "Static", WS_CHILD, 14, 3, 352, 20
END

CLASS TABMAIL_PAGE INHERIT DataWindowExtra 

	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oSFSub_MailCdReg AS Sub_MailCdReg

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT oCaller as OBJECT 
  export oPerscd as SQLSelect
METHOD DeleteButton( ) CLASS TABMAIL_PAGE
	LOCAL mCod,mOms as STRING 
	local oStmnt as SQLStatement
	LOCAL oMcd:=self:Server, oSel as SQLSelect
	IF oMcd:EOF.or.oMcd:BOF .or. oMcd:RecCount<1
		(ErrorBox{,self:oLan:WGet("Select a mailing code first")}):Show()
		RETURN
	ENDIF
	mOms:=AllTrim(oMcd:Description)
	if Empty(oMcd:Pers_Code) .or. oMcd:Pers_Code="FI" .or.oMcd:Pers_Code="MW".or.oMcd:Pers_Code="EG"
		Errorbox{,self:oLan:WGet("this code can't be removed")}:show()
		return nil
	endif  
   oSel:=SQLSelect{"select count(*) as total from person where deleted=0 and instr(mailingcodes,'"+oMcd:Pers_Code+"')>0",oConn}
	IF (TextBox{ self, self:oLan:WGet("Delete mailing code"),;
		self:oLan:WGet("Delete mailing code")+Space(1)+mOms+", "+self:oLan:WGet("used in")+Space(1)+AllTrim(Transform(oSel:total,""))+Space(1)+self:oLan:WGet("persons")+"?",BUTTONYESNO + BOXICONQUESTIONMARK }):Show()== BOXREPLYYES
		mCod:=oMcd:Pers_Code
		oSFSub_MailCdReg:DELETE()
		FillPersCode()
		oSFSub_MailCdReg:Browser:REFresh()
		self:StatusMessage(self:oLan:WGet("Removing")+space(1)+mOms+space(1)+self:oLan:WGet("from all persons, moment please"))
		self:Pointer := Pointer{POINTERHOURGLASS}
		oStmnt:=SQLStatement{"update person set mailingcodes=replace(replace(mailingcodes,'"+addslashes(mCod)+" ',''),'"+addslashes(mCod)+"','') where instr(mailingcodes,'"+addslashes(mCod)+"')>0",oConn}
		oStmnt:execute()
		self:Pointer := Pointer{POINTERARROW} 
		TextBox{,self:oLan:WGet("Removal mailing code"),Str(oStmnt:NumSuccessfulRows,-1)+" "+self:oLan:WGet("persons updated")}:Show()
	ENDIF		


	RETURN nil
METHOD EditButton(lNew ) CLASS TABMAIL_PAGE
	LOCAL oEditMailCdWindow AS EditMailCd
	Default(@lNew,FALSE)
	IF !lNew.and.(SELF:Server:EOF.or.SELF:Server:BOF)
		(Errorbox{,"Select a Mailing Code first"}):Show()
		RETURN
	ENDIF
	
	oEditMailCdWindow := EditMailCd{ SELF:Owner:Owner,,SELF:Server,lNew  }
	oEditMailCdWindow:oCaller:=SELF
	oEditMailCdWindow:Show()

   	RETURN

METHOD FilePrint CLASS TABMAIL_PAGE
LOCAL oDB as SQLSelect
LOCAL kopregels AS ARRAY
LOCAL nRow as int
LOCAL nPage as int
LOCAL oReport AS PrintDialog

oReport := PrintDialog{SELF,"Mailing codes"}
oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
oDB := SQLSelect{"select abbrvtn,description from perscod order by abbrvtn",oConn}
oDB:GoTop()
kopregels := {oLan:RGet("Mailing codes",,"!"),oLan:RGet("ABBREVATION",12,"@!")+' '+;
oLan:RGet("DESCRIPTION",20,"@!"),' '}
nRow := 0
nPage := 0
DO WHILE .not. oDB:EOF
   oReport:PrintLine(@nRow,@nPage,PadC(Transform(oDB:abbrvtn,'xxx'),12)+' '+;
   Transform(oDB:description,'xxxxxxxxxxxxxxxxxxxx'),kopregels)
   oDB:skip()
ENDDO
oReport:prstart()
oReport:prstop()
RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TABMAIL_PAGE 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TABMAIL_PAGE",_GetInst()},iCtlID)

aFonts[1] := Font{,9,"Microsoft Sans Serif"}

oCCEditButton := PushButton{SELF,ResourceID{TABMAIL_PAGE_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:OwnerAlignment := OA_PY

oCCNewButton := PushButton{SELF,ResourceID{TABMAIL_PAGE_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}
oCCNewButton:OwnerAlignment := OA_PY

oCCDeleteButton := PushButton{SELF,ResourceID{TABMAIL_PAGE_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PY

oDCFixedText1 := FixedText{SELF,ResourceID{TABMAIL_PAGE_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Mailing Codes can be used to select people for mailing, printing lists, address labels, mail merge, thank-you letters, etc.",NULL_STRING,NULL_STRING}
oDCFixedText1:Font(aFonts[1], FALSE)

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#TABMAIL_PAGE,"DataWindow Caption",NULL_STRING,NULL_STRING}
SELF:AllowServerClose := True
SELF:OwnerAlignment := OA_PWIDTH_HEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFSub_MailCdReg := Sub_MailCdReg{SELF,TABMAIL_PAGE_SUB_MAILCDREG}
oSFSub_MailCdReg:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD NewButton( ) CLASS TABMAIL_PAGE
		SELF:EditButton(TRUE)
RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TABMAIL_PAGE
	//Put your PostInit additions here
	self:SetTexts()
	self:oSFSub_MailCdReg:Browser:SetStandardStyle( gbsReadOnly )
	SELF:GoTop()
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS TABMAIL_PAGE
	//Put your PreInit additions here
	self:oCaller := uExtra
	self:oPerscd:=SqlSelect{"select pers_code,description,abbrvtn from perscod order by description",oConn}
	RETURN nil

METHOD refresh() CLASS TABMAIL_PAGE
	self:Server:Execute()
	self:oSFSub_MailCdReg:Browser:refresh()
RETURN nil
STATIC DEFINE TABMAIL_PAGE_DELETEBUTTON := 103 
STATIC DEFINE TABMAIL_PAGE_EDITBUTTON := 101 
STATIC DEFINE TABMAIL_PAGE_FIXEDTEXT1 := 104 
STATIC DEFINE TABMAIL_PAGE_NEWBUTTON := 102 
STATIC DEFINE TABMAIL_PAGE_SUB_MAILCDREG := 100 
CLASS TabProp_Page INHERIT DataWindowExtra 

	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oSFSub_PersPropReg AS Sub_PersPropReg

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
        PROTECT oCaller as OBJECT 
   export oProp as SQLSelect 
RESOURCE TabProp_Page DIALOGEX  16, 14, 372, 222
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TABPROP_PAGE_SUB_PERSPROPREG, "static", WS_CHILD|WS_BORDER, 14, 27, 240, 187
	CONTROL	"Edit", TABPROP_PAGE_EDITBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 289, 68, 53, 13
	CONTROL	"New", TABPROP_PAGE_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 289, 107, 53, 13
	CONTROL	"Delete", TABPROP_PAGE_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 289, 145, 53, 13
	CONTROL	"Self defined properties like 'recruited by', 'recruitement occasion', etc for analysing purposes.", TABPROP_PAGE_FIXEDTEXT1, "Static", WS_CHILD, 15, 5, 351, 14
END

METHOD AddButton( ) CLASS TabProp_Page 
METHOD DeleteButton( ) CLASS TABPROP_PAGE
	LOCAL  mOms as STRING
	LOCAL mCod,mId as STRING
	LOCAL oProp,oSel,oPers as SQLSelect
	LOCAL oXML as XMLDocument
	LOCAL lTagFound as LOGIC
	local oStmnt as SQLStatement 
	local nUpd as int
	oProp:=self:Server
	IF oProp:EOF.or.oProp:BOF
		(ErrorBox{,self:oLan:WGet("Select a property first")}):Show()
		RETURN
	ENDIF
	mOms:=oProp:FIELDGET(#NAME)
	mId:=Str(oProp:id,-1)
	mCod:="V"+mId 
	oSel:=SQLSelect{"select count(*) as total from person where deleted=0 and instr(propextr,'<V"+mId+">')>0",oConn}
	
	IF (TextBox{ self, self:oLan:WGet("Delete Property"),;
			self:oLan:WGet("Delete Property")+Space(1)+mOms+", "+self:oLan:WGet("used in")+Space(1)+ConS(oSel:total)+Space(1)+self:oLan:WGet("persons")+"?",BUTTONYESNO + BOXICONQUESTIONMARK }):Show()== BOXREPLYYES
		SQLStatement{"delete from person_properties where id="+mId,oConn}:execute()
// 		self:DELETE()
// 		oProp:Commit() 
		self:oProp:execute()
		oSFSub_PersPropReg:Browser:REFresh()
		if ConI(oSel:total)>0
			self:STATUSMESSAGE("Removing "+mOms+" from all persons, moment please")
			self:Pointer := Pointer{POINTERHOURGLASS} 
			oStmnt:=SQLStatement{"update person set propextr=concat(substring(propextr,1,instr(propextr,'<V"+mId+">')-1)"+;
			",substring(propextr,instr(propextr,'</V"+mId+">')+"+Str(Len(mId)+4,-1)+"))"+;
			" where instr(propextr,'<V"+mId+">')>0",oConn}
			oStmnt:execute() 
			nUpd:= oStmnt:NumSuccessfulRows
		endif
		self:Pointer := Pointer{POINTERARROW}
		FillPersProp()
		TextBox{,self:oLan:WGet("Removal property"),Str(nUpd,-1)+" "+self:oLan:WGet("persons updated")}:Show()

	ENDIF		


	RETURN nil
	
METHOD EditButton(lNew ) CLASS TabProp_Page
	LOCAL oEditPersPropWindow AS EditPersProp
	Default(@lNew,FALSE)
	IF !lNew.and.(SELF:Server:EOF.or.SELF:Server:BOF)
		(Errorbox{,"Select a property first"}):Show()
		RETURN
	ENDIF
	
	oEditPersPropWindow := EditPersProp{ SELF:Owner:Owner,,SELF:Server,lNew  }
	oEditPersPropWindow:oCaller:=SELF
	oEditPersPropWindow:Show()

   	RETURN

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TabProp_Page 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TabProp_Page",_GetInst()},iCtlID)

aFonts[1] := Font{,9,"Microsoft Sans Serif"}

oCCEditButton := PushButton{SELF,ResourceID{TABPROP_PAGE_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:OwnerAlignment := OA_PY

oCCNewButton := PushButton{SELF,ResourceID{TABPROP_PAGE_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}
oCCNewButton:OwnerAlignment := OA_PY

oCCDeleteButton := PushButton{SELF,ResourceID{TABPROP_PAGE_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PY

oDCFixedText1 := FixedText{SELF,ResourceID{TABPROP_PAGE_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Self defined properties like 'recruited by', 'recruitement occasion', etc for analysing purposes.",NULL_STRING,NULL_STRING}
oDCFixedText1:Font(aFonts[1], FALSE)

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#TabProp_Page,"DataWindow Caption",NULL_STRING,NULL_STRING}
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
SELF:ViewAs(#FormView)

oSFSub_PersPropReg := Sub_PersPropReg{SELF,TABPROP_PAGE_SUB_PERSPROPREG}
oSFSub_PersPropReg:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD NewButton( ) CLASS TABPROP_PAGE
		SELF:EditButton(TRUE)
RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TABPROP_PAGE
	//Put your PostInit additions here
	self:SetTexts()
	self:oSFSub_PersPropReg:Browser:SetStandardStyle( gbsReadOnly )
	SELF:GoTop()
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS TABPROP_PAGE
	//Put your PreInit additions here 
	local cPropTypes as string
	cPropTypes:="case type"
	AEval(prop_types,{|x| cPropTypes+=" when "+Str(x[2],-1)+" then '"+x[1]+"'"})
	cPropTypes+=" end as typedescr"
	self:oCaller := uExtra 
	self:oProp:=SQLSelect{"select id,name,`values`,"+cPropTypes+" from person_properties order by name",oConn}
	RETURN nil

METHOD RemoveButton( ) CLASS TabProp_Page 
STATIC DEFINE TABPROP_PAGE_DELETEBUTTON := 103 
STATIC DEFINE TABPROP_PAGE_EDITBUTTON := 101 
STATIC DEFINE TABPROP_PAGE_FIXEDTEXT1 := 104 
STATIC DEFINE TABPROP_PAGE_NEWBUTTON := 102 
STATIC DEFINE TABPROP_PAGE_SUB_PERSPROPREG := 100 
CLASS TABTITLE_PAGE INHERIT DataWindowExtra 

	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oSFSub_PersTitleReg AS Sub_PersTitleReg

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
      PROTECT oCaller as OBJECT 
      export oTit as SQLSelect
RESOURCE TABTITLE_PAGE DIALOGEX  14, 13, 373, 222
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TABTITLE_PAGE_SUB_PERSTITLEREG, "static", WS_CHILD|WS_BORDER, 14, 27, 240, 187
	CONTROL	"Edit", TABTITLE_PAGE_EDITBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 288, 68, 54, 13
	CONTROL	"New", TABTITLE_PAGE_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 289, 107, 53, 13
	CONTROL	"Delete", TABTITLE_PAGE_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 289, 145, 53, 13
	CONTROL	"Special title of person like  Rev., Prof., etc.", TABTITLE_PAGE_FIXEDTEXT1, "Static", WS_CHILD, 14, 3, 350, 13
END

METHOD DeleteButton( ) CLASS TABTITLE_PAGE
	LOCAL  mOms as STRING
	LOCAL mCod as STRING
	LOCAL oTit, oSel as SQLSelect
	local oStmnt as SQLStatement
	oTit:=self:Server
	IF oTit:EOF.or.oTit:BOF
		(ErrorBox{,self:oLan:WGet("Select a title first")}):Show()
		RETURN
	ENDIF
	mOms:=AllTrim(oTit:DESCRPTN)
	oSel:=SqlSelect{"select count(*) as total from person where deleted=0 and  title="+Str(self:oTit:id,-1),oConn}
	IF (TextBox{ self, self:oLan:WGet("Delete title"),;                                           
			self:oLan:WGet("Delete title")+Space(1)+mOms+", "+self:oLan:WGet("used in")+Space(1)+ConS(oSel:total)+Space(1)+self:oLan:WGet("persons")+"?",BUTTONYESNO + BOXICONQUESTIONMARK }):Show()== BOXREPLYYES
		mCod:=Str(oTit:id,-1)
		self:oSFSub_PersTitleReg:DELETE()
		oSFSub_PersTitleReg:Browser:REFresh()
		self:StatusMessage(self:oLan:WGet("Removing")+space(1)+mOms+space(1)+self:oLan:WGet("from all persons, moment please"))
		self:Pointer := Pointer{POINTERHOURGLASS} 
		if ConI(oSel:total)>0
			oStmnt:=SQLStatement{"update person set title=1 where title="+mCod,oConn}
			oStmnt:execute()
			self:Pointer := Pointer{POINTERARROW} 
			TextBox{,self:oLan:WGet("Removal title"),Str(oStmnt:NumSuccessfulRows,-1)+" "+self:oLan:WGet("persons updated")}:Show()
		endif
		FillPersTitle()
	ENDIF		


	RETURN nil
METHOD EditButton(lNew ) CLASS TABTITLE_PAGE
	LOCAL oEditPersTitleWindow AS EditPersTitle
	Default(@lNew,FALSE)
	IF !lNew.and.(SELF:Server:EOF.or.SELF:Server:BOF)
		(Errorbox{,"Select a title first"}):Show()
		RETURN
	ENDIF
	
	oEditPersTitleWindow := EditPersTitle{ SELF:Owner:Owner,,SELF:Server,lNew  }
	oEditPersTitleWindow:oCaller:=SELF
	oEditPersTitleWindow:Show()

   	RETURN
	
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TABTITLE_PAGE 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TABTITLE_PAGE",_GetInst()},iCtlID)

aFonts[1] := Font{,9,"Microsoft Sans Serif"}

oCCEditButton := PushButton{SELF,ResourceID{TABTITLE_PAGE_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:OwnerAlignment := OA_PY

oCCNewButton := PushButton{SELF,ResourceID{TABTITLE_PAGE_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}
oCCNewButton:OwnerAlignment := OA_PY

oCCDeleteButton := PushButton{SELF,ResourceID{TABTITLE_PAGE_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PY

oDCFixedText1 := FixedText{SELF,ResourceID{TABTITLE_PAGE_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Special title of person like  Rev., Prof., etc.",NULL_STRING,NULL_STRING}
oDCFixedText1:Font(aFonts[1], FALSE)

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#TABTITLE_PAGE,"DataWindow Caption",NULL_STRING,NULL_STRING}
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFSub_PersTitleReg := Sub_PersTitleReg{SELF,TABTITLE_PAGE_SUB_PERSTITLEREG}
oSFSub_PersTitleReg:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD NewButton( ) CLASS TABTITLE_PAGE
		SELF:EditButton(TRUE)
RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TABTITLE_PAGE
	//Put your PostInit additions here
	self:SetTexts()
	self:oSFSub_PersTitleReg:Browser:SetStandardStyle( gbsReadOnly )
	SELF:GoTop()
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS TABTITLE_PAGE
	//Put your PreInit additions here
	self:oCaller := uExtra
	self:oTit:=SQLSelect{"select id,descrptn from titles order by descrptn",oConn}
	RETURN nil
METHOD refresh() CLASS TABTITLE_PAGE
	self:Server:Execute()
	self:oSFSub_PersTitleReg:Browser:refresh()
RETURN nil
STATIC DEFINE TABTITLE_PAGE_DELETEBUTTON := 103 
STATIC DEFINE TABTITLE_PAGE_EDITBUTTON := 101 
STATIC DEFINE TABTITLE_PAGE_FIXEDTEXT1 := 104 
STATIC DEFINE TABTITLE_PAGE_NEWBUTTON := 102 
STATIC DEFINE TABTITLE_PAGE_SUB_PERSTITLEREG := 100 
RESOURCE TABTYPE_PAGE DIALOGEX  14, 13, 373, 222
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TABTYPE_PAGE_SUB_PERSTYPEREG, "static", WS_CHILD|WS_BORDER, 14, 27, 240, 187
	CONTROL	"Edit", TABTYPE_PAGE_EDITBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 289, 68, 53, 13
	CONTROL	"New", TABTYPE_PAGE_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 289, 107, 53, 13
	CONTROL	"Delete", TABTYPE_PAGE_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 289, 145, 53, 13
	CONTROL	"Type of person: individual, company, member, direct income, ...", TABTYPE_PAGE_FIXEDTEXT1, "Static", WS_CHILD, 14, 3, 338, 13
END

CLASS TABTYPE_PAGE INHERIT DataWindowExtra 

	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oSFSub_PersTypeReg AS Sub_PersTypeReg

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT oCaller as OBJECT 
  export oType as SQLSelect
  METHOD DeleteButton( ) CLASS TABTYPE_PAGE
	LOCAL oPers as SQLSelect
	LOCAL  mOms as STRING
	LOCAL mCod as int
	LOCAL oPtp as SQLSelect
	oPtp:=self:Server
	IF oPtp:EOF.or.oPtp:BOF
		(ErrorBox{,self:oLan:WGet("Select a person type first")}):Show()
		RETURN
	ENDIF
	mOms:=AllTrim(oPtp:DESCRPTN)
	mCod:=oPtp:id
	if oPtp:abbrvtn="ENT" .or.oPtp:abbrvtn="MBR" .or.oPtp:abbrvtn="IND".or.oPtp:abbrvtn="CRE".or.oPtp:abbrvtn="COM"
		Errorbox{,self:oLan:WGet("this type can't be removed")}:show()
		return nil
	endif
	oPers:=SqlSelect{"select count(*) as total from person where deleted=0 and type="+Str(mCod,-1),oConn}
	if ConI(oPers:total)>0
		Errorbox{,self:oLan:WGet("this type is still used in")+space(1)+ConS(oPers:total)+space(1)+self:olan:WGet("persons")+";"+self:olan:WGet("thus can't be removed")}:show() 
		return nil
	endif		
	IF (TextBox{ self, self:oLan:WGet("Delete person type"),;
		self:oLan:WGet("Delete person type")+Space(1)+mOms,BUTTONYESNO + BOXICONQUESTIONMARK }):Show()== BOXREPLYYES
		self:oSFSub_PersTypeReg:DELETE()
		FillPersType()
		oSFSub_PersTypeReg:Browser:REFresh()
		self:Pointer := Pointer{POINTERARROW}
	ENDIF		


	RETURN nil
METHOD EditButton(lNew ) CLASS TABTYPE_PAGE
	LOCAL oEditPersTypeWindow AS EditPersType
	Default(@lNew,FALSE)
	IF !lNew.and.(SELF:Server:EOF.or.SELF:Server:BOF)
		(Errorbox{,"Select a Person type first"}):Show()
		RETURN
	ENDIF
	
	oEditPersTypeWindow := EditPersType{ SELF:Owner:Owner,,SELF:Server,lNew  }
	oEditPersTypeWindow:oCaller:=SELF
	oEditPersTypeWindow:Show()

   	RETURN
	
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TABTYPE_PAGE 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TABTYPE_PAGE",_GetInst()},iCtlID)

aFonts[1] := Font{,9,"Microsoft Sans Serif"}

oCCEditButton := PushButton{SELF,ResourceID{TABTYPE_PAGE_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:OwnerAlignment := OA_PY

oCCNewButton := PushButton{SELF,ResourceID{TABTYPE_PAGE_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}
oCCNewButton:OwnerAlignment := OA_PY

oCCDeleteButton := PushButton{SELF,ResourceID{TABTYPE_PAGE_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PY

oDCFixedText1 := FixedText{SELF,ResourceID{TABTYPE_PAGE_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Type of person: individual, company, member, direct income, ...",NULL_STRING,NULL_STRING}
oDCFixedText1:Font(aFonts[1], FALSE)

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#TABTYPE_PAGE,"DataWindow Caption",NULL_STRING,NULL_STRING}
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFSub_PersTypeReg := Sub_PersTypeReg{SELF,TABTYPE_PAGE_SUB_PERSTYPEREG}
oSFSub_PersTypeReg:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD NewButton( ) CLASS TABTYPE_PAGE
		SELF:EditButton(TRUE)
RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TABTYPE_PAGE
	//Put your PostInit additions here
	self:SetTexts()
	self:oSFSub_PersTypeReg:Browser:SetStandardStyle( gbsReadOnly )
	SELF:GoTop()
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS TABTYPE_PAGE
	//Put your PreInit additions here
	self:oCaller := uExtra 
	self:oType:=SqlSelect{"select id,descrptn,abbrvtn from persontype order by descrptn",oConn}
	RETURN nil

METHOD refresh() CLASS TABTYPE_PAGE
	self:Server:Execute()
	self:oSFSub_PersTypeReg:Browser:refresh()
RETURN nil

STATIC DEFINE TABTYPE_PAGE_DELETEBUTTON := 103 
STATIC DEFINE TABTYPE_PAGE_EDITBUTTON := 101 
STATIC DEFINE TABTYPE_PAGE_FIXEDTEXT1 := 104 
STATIC DEFINE TABTYPE_PAGE_NEWBUTTON := 102 
STATIC DEFINE TABTYPE_PAGE_SUB_PERSTYPEREG := 100 
