Define IDM_LANGUAGE_NAME := "Language"
Define IDM_Language_USERID := "parous…ºw@™Ðw"
CLASS Language 
declare method RGet,MGet,WGet,MarkUpLanItem
METHOD Init( ) CLASS Language
local olanT as SQLSelect 

if Empty(aLanM)
	olanT:=SQLSelect{"select sentenceen,sentencemy from language where `location`='M'",oConn}
	if olanT:RecCount>0
		aLanM:=olanT:getLookuptable(olanT:RECCOUNT)
	endif
endif
if Empty(aLanW)
	olanT:=SQLSelect{"select sentenceen,sentencemy from language where `location`='W'",oConn}
	if olanT:RecCount>0
		aLanW:=olanT:getLookuptable(olanT:RECCOUNT)
	endif
endif
if Empty(aLanR)
	olanT:=SQLSelect{"select sentenceen,sentencemy from language where `location`='R'",oConn}
	if olanT:RecCount>0
		aLanR:=olanT:getLookuptable(olanT:RECCOUNT)
	endif
endif
RETURN SELF
 
ACCESS LENGTH CLASS Language
 RETURN self:FieldGet(3)
ASSIGN LENGTH(uValue) CLASS Language
 RETURN self:FieldPut(3, uValue)
ACCESS LOCATION CLASS Language
 RETURN self:FieldGet(4)
ASSIGN LOCATION(uValue) CLASS Language
 RETURN self:FieldPut(4, uValue)
method MarkUpLanItem(cText,cPicture as string,cPad as string,nLength as int) class Language
IF !Empty(cPicture)
	IF cPicture=="!"  && first letter uppercase?
		cText:=Upper(SubStr(cText,1,1))+Lower(SubStr(cText,2))
	ELSE
		cText:=Transform(Lower(cText),cPicture)
	ENDIF
ENDIF
IF !Empty(nLength)
	IF Empty(cPad).or.cPad=="L"
		cText:=PadR(cText,nLength)
	ELSEIF cPad=="R"
		cText:=PadL(cText,nLength)
	ELSEIF cPad=="C"
		cText:=PadC(cText,nLength)
	ENDIF
ELSE
	cText:=AllTrim(cText)
ENDIF

RETURN cText
METHOD MGet(cSentenceEnglish as string,nLength:=0 as int,cPicture:="" as string,cPad:='' as string) as string  CLASS Language
*	Get menu text in english or my language:
*	cSentenceEnglish:	English text to be translated (or not)
* 	nLength:			Length of text to be returned (default length as it is)
*	cPicture:			Pictureformat in which the text must be returned (default as it is)
*						"!"=first letter uppercase
*	cPad:				R:Adjust right, L: left, C: center; default left

LOCAL cText as STRING
local iPos as int 
// local oLan as SQLSelect
local oStmnt as SQLStatement                                                                                                                                       
IF Empty(cSentenceEnglish)
	RETURN ""
ENDIF
cText:=AllTrim(cSentenceEnglish)
IF !Alg_taal="E" 

	if (iPos:=AScan(aLanM,{|x|x[1]==cText}))>0
		IF !Empty(aLanM[iPos,2])
			cText:=aLanM[iPos,2]
		ENDIF
	ELSE
		SQLStatement{"insert into language set location='M',sentenceen='"+cText+"',length="+Str(Min(nLength,80),-1),oConn}:execute()
		AAdd(aLanM,{cText,''})
	ENDIF
ENDIF 
return self:MarkUpLanItem(cText,cPicture,cPad,nLength)
METHOD RGet(cSentenceEnglish as string,nLength:=0 as int,cPicture:="" as string,cPad:='' as string) as string  CLASS Language
*	Get report text in english or my language:
*	cSentenceEnglish:	English text to be translated (or not)
* 	nLength:			Length of text to be returned (default length as it is)
*	cPicture:			Pictureformat in which the text must be returned (default as it is)
*						"!"=first letter uppercase
*	cPad:				R:Adjust right, L: left, C: center; default left

LOCAL cText as STRING
local iPos as int 
// local oLan as SQLSelect
local oStmnt as SQLStatement                                                                                                                                       
IF Empty(cSentenceEnglish)
	RETURN ""
ENDIF
cText:=AllTrim(cSentenceEnglish)
IF !Alg_taal="E" 
	if (iPos:=AScan(aLanR,{|x|x[1]==cText}))>0
		IF !Empty(aLanR[iPos,2])
			cText:=aLanR[iPos,2]
		ENDIF
	ELSE
		SQLStatement{"insert into language set location='R',sentenceen='"+cText+"',length="+Str(Min(nLength,80),-1),oConn}:execute()
		AAdd(aLanR,{cText,''})
	ENDIF
ENDIF 
return self:MarkUpLanItem(cText,cPicture,cPad,nLength)
ACCESS SENTENCEEN CLASS Language
 RETURN self:FieldGet(1)
ASSIGN SENTENCEEN(uValue) CLASS Language
 RETURN self:FieldPut(1, uValue)
ACCESS SENTENCEMY CLASS Language
 RETURN self:FieldGet(2)
ASSIGN SENTENCEMY(uValue) CLASS Language
 RETURN self:FieldPut(2, uValue)
METHOD WGet(cSentenceEnglish as string,nLength:=0 as int,cPicture:="" as string,cPad:='' as string) as string  CLASS Language
*	Get window text in english or my language:
*	cSentenceEnglish:	English text to be translated (or not)
* 	nLength:			Length of text to be returned (default length as it is)
*	cPicture:			Pictureformat in which the text must be returned (default as it is)
*						"!"=first letter uppercase
*	cPad:				R:Adjust right, L: left, C: center; default left

LOCAL cText as STRING
local iPos as int 
// local oLan as SQLSelect
local oStmnt as SQLStatement                                                                                                                                       
IF Empty(cSentenceEnglish)
	RETURN ""
ENDIF
cText:=AllTrim(cSentenceEnglish)
IF !Alg_taal="E" 
	if (iPos:=AScan(aLanW,{|x|x[1]==cText}))>0
		IF !Empty(aLanW[iPos,2])
			cText:=aLanW[iPos,2]
		ENDIF
	ELSE
		SQLStatement{"insert into language set location='W',sentenceen='"+cText+"',length="+Str(Min(nLength,80),-1),oConn}:execute()
		AAdd(aLanW,{cText,''})
	ENDIF
ENDIF 
return self:MarkUpLanItem(cText,cPicture,cPad,nLength)

CLASS language_LENGTH INHERIT FIELDSPEC


METHOD Init() CLASS language_LENGTH
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#LENGTH, "Length", "", "language_LENGTH" },  "N", 2, 0 )
    cPict       := "99"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS language_LOCATION INHERIT FIELDSPEC
METHOD Init() CLASS language_LOCATION
super:Init(HyperLabel{"LOCATION","Location","","language_LOCATION"},"C",1,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS language_SENTENCEEN INHERIT FIELDSPEC
METHOD Init() CLASS language_SENTENCEEN
super:Init(HyperLabel{"SENTENCEEN","Sentenceen","","language_SENTENCEEN"},"C",80,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS language_SENTENCEMY INHERIT FIELDSPEC
METHOD Init() CLASS language_SENTENCEMY
super:Init(HyperLabel{"SENTENCEMY","Sentencemy","","language_SENTENCEMY"},"C",80,0)

RETURN SELF
 CLASS LanguageMenu INHERIT LanguageWindow
 	EXPORT cLocation:="M" as STRING
 CLASS LanguageReport INHERIT LanguageWindow
 	EXPORT cLocation:="R" as STRING
 CLASS LanguageScreen INHERIT LanguageWindow
 	EXPORT cLocation:="W" as STRING
CLASS LanguageSubWindow INHERIT DATAWINDOW 

	PROTECT oDBSENTENCEEN as DataColumn
	PROTECT oDBLENGTH as DataColumn
	PROTECT oDBSENTENCEMY as DataColumn
	PROTECT oDCSC_SENTENCEEN AS FIXEDTEXT
	PROTECT oDCSC_SENTENCEMY AS FIXEDTEXT
	PROTECT oDCSENTENCEEN AS SINGLELINEEDIT
	PROTECT oDCSENTENCEMY AS SINGLELINEEDIT
	PROTECT oDClength AS SINGLELINEEDIT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
   PROTECT oLanguage as Language
RESOURCE LanguageSubWindow DIALOGEX  33, 30, 507, 262
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"English part of a sentence:", LANGUAGESUBWINDOW_SC_SENTENCEEN, "Static", WS_CHILD, 13, 14, 86, 13
	CONTROL	"Sentence My Language:", LANGUAGESUBWINDOW_SC_SENTENCEMY, "Static", WS_CHILD, 13, 29, 80, 12
	CONTROL	"English part of a sentence:", LANGUAGESUBWINDOW_SENTENCEEN, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 110, 14, 241, 13, WS_EX_CLIENTEDGE
	CONTROL	"Part of a Sentence in My Language:", LANGUAGESUBWINDOW_SENTENCEMY, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 110, 29, 241, 12, WS_EX_CLIENTEDGE
	CONTROL	"Length", LANGUAGESUBWINDOW_LENGTH, "Edit", ES_READONLY|ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 388, 14, 16, 13, WS_EX_CLIENTEDGE
	CONTROL	"Length:", LANGUAGESUBWINDOW_FIXEDTEXT2, "Static", WS_CHILD, 360, 15, 24, 12
	CONTROL	"OK", LANGUAGESUBWINDOW_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 338, 60, 54, 12
END

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS LanguageSubWindow 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"LanguageSubWindow",_GetInst()},iCtlID)

oDCSC_SENTENCEEN := FixedText{SELF,ResourceID{LANGUAGESUBWINDOW_SC_SENTENCEEN,_GetInst()}}
oDCSC_SENTENCEEN:HyperLabel := HyperLabel{#SC_SENTENCEEN,"English part of a sentence:",NULL_STRING,NULL_STRING}

oDCSC_SENTENCEMY := FixedText{SELF,ResourceID{LANGUAGESUBWINDOW_SC_SENTENCEMY,_GetInst()}}
oDCSC_SENTENCEMY:HyperLabel := HyperLabel{#SC_SENTENCEMY,"Sentence My Language:",NULL_STRING,NULL_STRING}

oDCSENTENCEEN := SingleLineEdit{SELF,ResourceID{LANGUAGESUBWINDOW_SENTENCEEN,_GetInst()}}
oDCSENTENCEEN:FieldSpec := Language_SentenceEn{}
oDCSENTENCEEN:HyperLabel := HyperLabel{#SENTENCEEN,"English part of a sentence:","English part of a sentence","Language_SentenceEn"}

oDCSENTENCEMY := SingleLineEdit{SELF,ResourceID{LANGUAGESUBWINDOW_SENTENCEMY,_GetInst()}}
oDCSENTENCEMY:FieldSpec := Language_SentenceMy{}
oDCSENTENCEMY:HyperLabel := HyperLabel{#SENTENCEMY,"Part of a Sentence in My Language:","Part of a sentence in my language","Language_SentenceMy"}
oDCSENTENCEMY:ScrollMode := SCRMODE_FULL

oDClength := SingleLineEdit{SELF,ResourceID{LANGUAGESUBWINDOW_LENGTH,_GetInst()}}
oDClength:HyperLabel := HyperLabel{#length,"Length","Length",NULL_STRING}
oDClength:Picture := "99"
oDClength:FieldSpec := language_LENGTH{}

oDCFixedText2 := FixedText{SELF,ResourceID{LANGUAGESUBWINDOW_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Length:",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{LANGUAGESUBWINDOW_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

SELF:Caption := "Translation table from English to my language:"
SELF:HyperLabel := HyperLabel{#LanguageSubWindow,"Translation table from English to my language:","Translation for text in reports",NULL_STRING}
SELF:PreventAutoLayout := True
SELF:OwnerAlignment := OA_PWIDTH_PHEIGHT
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := DataBrowser{self}

oDBSENTENCEEN := DataColumn{Language_SentenceEn{}}
oDBSENTENCEEN:Width := 52
oDBSENTENCEEN:HyperLabel := oDCSENTENCEEN:HyperLabel 
oDBSENTENCEEN:Caption := "English part of a sentence:"
self:Browser:AddColumn(oDBSENTENCEEN)

oDBLENGTH := DataColumn{language_LENGTH{}}
oDBLENGTH:Width := 7
oDBLENGTH:HyperLabel := oDCLENGTH:HyperLabel 
oDBLENGTH:Caption := "Length"
self:Browser:AddColumn(oDBLENGTH)

oDBSENTENCEMY := DataColumn{Language_SentenceMy{}}
oDBSENTENCEMY:Width := 64
oDBSENTENCEMY:HyperLabel := oDCSENTENCEMY:HyperLabel 
oDBSENTENCEMY:Caption := "Part of a Sentence in My Language:"
self:Browser:AddColumn(oDBSENTENCEMY)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS length() CLASS LanguageSubWindow
RETURN SELF:FieldGet(#length)

ASSIGN length(uValue) CLASS LanguageSubWindow
SELF:FieldPut(#length, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class LanguageSubWindow
	//Put your PostInit additions here 

	self:oDBSENTENCEEN:setstandardstyle(gbsReadOnly)	
	self:oDBLENGTH:setstandardstyle(gbsReadOnly)
   self:oLanguage := Language{}   
	return NIL
method PreInit(oWindow,iCtlID,oServer,uExtra) class LanguageSubWindow
	//Put your PreInit additions here
	oWindow:Use(oWindow:oLanguage)
	return nil

ACCESS SENTENCEEN() CLASS LanguageSubWindow
RETURN SELF:FieldGet(#SENTENCEEN)

ASSIGN SENTENCEEN(uValue) CLASS LanguageSubWindow
SELF:FieldPut(#SENTENCEEN, uValue)
RETURN uValue

ACCESS SENTENCEMY() CLASS LanguageSubWindow
RETURN SELF:FieldGet(#SENTENCEMY)

ASSIGN SENTENCEMY(uValue) CLASS LanguageSubWindow
SELF:FieldPut(#SENTENCEMY, uValue)
RETURN uValue

METHOD ValidateRecord() CLASS LanguageSubWindow
LOCAL oLan as SQLSelect
oLan:=SELF:Server

IF !Empty(oLan:SentenceMy) 
	IF Len(AllTrim(oLan:SentenceMy))>oLan:Length
		IF !Empty(oLan:Length)
			(ErrorBox{,self:oLanguage:WGet("Length may not be longer than")+Str(oLan:Length)}):Show()
			RETURN FALSE           
		ENDIF                  
	ENDIF
ENDIF
RETURN TRUE
STATIC DEFINE LANGUAGESUBWINDOW_FIXEDTEXT2 := 105 
STATIC DEFINE LANGUAGESUBWINDOW_LENGTH := 104 
STATIC DEFINE LANGUAGESUBWINDOW_OKBUTTON := 106 
STATIC DEFINE LANGUAGESUBWINDOW_SC_SENTENCEEN := 100 
STATIC DEFINE LANGUAGESUBWINDOW_SC_SENTENCEMY := 101 
STATIC DEFINE LANGUAGESUBWINDOW_SENTENCEEN := 102 
STATIC DEFINE LANGUAGESUBWINDOW_SENTENCEMY := 103 

STATIC DEFINE LANGUAGETABLE_LANGUAGEWINDOW := 100 
CLASS LanguageWindow INHERIT DataWindowExtra 

	PROTECT oCCFindPrevious AS PUSHBUTTON
	PROTECT oCCFindNext AS PUSHBUTTON
	PROTECT oDCFindText AS SINGLELINEEDIT
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oSFLanguageSubWindow AS LanguageSubWindow

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)   
  	declare method FindNext, FindPrevious
   EXPORT oLanguage as SQLSelect 

RESOURCE LanguageWindow DIALOGEX  4, 3, 534, 289
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", LANGUAGEWINDOW_LANGUAGESUBWINDOW, "static", WS_CHILD|WS_BORDER, 0, 18, 523, 263
	CONTROL	"Previous", LANGUAGEWINDOW_FINDPREVIOUS, "Button", WS_CHILD|NOT WS_VISIBLE, 208, 3, 38, 13
	CONTROL	"Find", LANGUAGEWINDOW_FINDNEXT, "Button", BS_DEFPUSHBUTTON|WS_CHILD, 168, 3, 38, 13
	CONTROL	"", LANGUAGEWINDOW_FINDTEXT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 36, 3, 133, 13, WS_EX_CLIENTEDGE
	CONTROL	"Find:", LANGUAGEWINDOW_FIXEDTEXT1, "Static", WS_CHILD, 4, 4, 32, 12
END

METHOD Close(oEvent) CLASS LanguageWindow
	//GetUserMenu(LOGON_EMP_ID)
	//SELF:Server:refreshclients()
	SUPER:Close(oEvent)
	aLanM := {}
	aLanW := {}
	aLanR := {}
	GetUserMenu(LOGON_EMP_ID)
	oMainWindow:Menu:=WOMenu{}
	oMainWindow:Menu:ToolBar:Hide()

	//Put your changes here
	SELF:Destroy()

	RETURN NIL

method EditChange(oControlEvent) class LanguageWindow
	local oControl as Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:EditChange(oControlEvent)
	//Put your changes here
	return NIL


METHOD FilePrint CLASS LanguageWindow
LOCAL oDB AS Language
LOCAL kopregels AS ARRAY
LOCAL nRij AS INT
LOCAL nBlad AS INT
LOCAL oReport AS PrintDialog
oDB := Language{}
IF !oDB:Used
	RETURN FALSE
ENDIF

oReport := PrintDialog{SELF,"Language translation table",,105}
oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
oDB:GoTop()
kopregels := {;
"Language translation table",;
'English                                             My Language',' '}
nRij := 0
nBlad := 0
DO WHILE .not. oDB:EOF
   oReport:PrintLine(@nRij,@nBlad,oDB:SentenceEn+' '+oDB:sentenceMy,kopregels)
   oDB:skip()
ENDDO
oDB:Close()
oReport:prstart()
oReport:prstop()
RETURN NIL
METHOD FindNext( ) as void pascal CLASS LanguageWindow 
local oLan:=self:Server as SQLSelect
local oMyAB:=self as LanguageWindow 

oLan:SuspendNotification()

IF (self:oCCFindNext:Caption == "Find")
	oLan:GoTop()
	self:aKeyW:=GetTokens(AllTrim(self:FindText))
   self:cFindText := AllTrim(self:FindText)
ELSE
	oLan:Skip()
ENDIF
	
do while (!oLan:EOF)
	if (oMyAB:CompareKeyWords({AllTrim(oLan:SENTENCEEN),oLan:SENTENCEMY}))
		oLan:ResetNotification()
		self:GoTo(oLan:RECNO)
      self:oCCFindNext:Caption := "Next"
      self:oCCFindPrevious:Show()
		exit
	ENDIF  
	oLan:Skip()
ENDDO

IF (oLan:EOF .or. oLan:RECNO = oLan:RECCOUNT)
	IF (oLan:EOF)
		oLan:ResetNotification()
	   IF (self:oCCFindNext:Caption == "Find")
			self:STATUSMESSAGE("Not found", MESSAGEPERMANENT)
   	ELSE
   		self:STATUSMESSAGE("No more found", MESSAGEPERMANENT)
	   ENDIF
	ELSE
		// NEXT button disabled
		self:oCCFindNext:Disable()
	ENDIF
ENDIF

RETURN 
METHOD FindPrevious( ) as void pascal CLASS LanguageWindow 
local oLan:=self:Server as SQLSelect
local oMyAB:=self as LanguageWindow

self:oCCFindNext:Enable()
oLan:SuspendNotification()
oLan:Skip(-1)
DO WHILE (!oLan:BOF)
	if (oMyAB:CompareKeyWords({AllTrim(oLan:SENTENCEEN),oLan:SENTENCEMY}))
		oLan:ResetNotification()
		self:GoTo(oLan:RECNO)
		exit
	ENDIF  
	oLan:Skip(-1)
ENDDO

IF (oLan:BOF .or. oLan:RECNO = 1)
	IF (oLan:BOF)
		oLan:ResetNotification()
		self:STATUSMESSAGE("No more found", MESSAGEPERMANENT)
	ELSE
		self:oCCFindPrevious:Hide()
	ENDIF  
ENDIF

RETURN 

ACCESS FindText() CLASS LanguageWindow
RETURN SELF:FieldGet(#FindText)

ASSIGN FindText(uValue) CLASS LanguageWindow
SELF:FieldPut(#FindText, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS LanguageWindow 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"LanguageWindow",_GetInst()},iCtlID)

oCCFindPrevious := PushButton{SELF,ResourceID{LANGUAGEWINDOW_FINDPREVIOUS,_GetInst()}}
oCCFindPrevious:HyperLabel := HyperLabel{#FindPrevious,"Previous",NULL_STRING,"Find previous record"}
oCCFindPrevious:TooltipText := "Find previous record"
oCCFindPrevious:UseHLforToolTip := True

oCCFindNext := PushButton{SELF,ResourceID{LANGUAGEWINDOW_FINDNEXT,_GetInst()}}
oCCFindNext:HyperLabel := HyperLabel{#FindNext,"Find",NULL_STRING,"Find next record"}
oCCFindNext:TooltipText := "Find next record"
oCCFindNext:UseHLforToolTip := True

oDCFindText := SingleLineEdit{SELF,ResourceID{LANGUAGEWINDOW_FINDTEXT,_GetInst()}}
oDCFindText:HyperLabel := HyperLabel{#FindText,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{LANGUAGEWINDOW_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Find:",NULL_STRING,NULL_STRING}

SELF:Caption := "Translation table from English to my language:"
SELF:HyperLabel := HyperLabel{#LanguageWindow,"Translation table from English to my language:","Translation for text in reports",NULL_STRING}
SELF:Menu := WOBrowserMENUShort{}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFLanguageSubWindow := LanguageSubWindow{SELF,LANGUAGEWINDOW_LANGUAGESUBWINDOW}
oSFLanguageSubWindow:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS Length() CLASS LanguageWindow
RETURN SELF:FieldGet(#Length)

ASSIGN Length(uValue) CLASS LanguageWindow
SELF:FieldPut(#Length, uValue)
RETURN uValue

METHOD OKButton( ) CLASS LanguageWindow
	SELF:ViewTable()
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS LanguageWindow
	//Put your PostInit additions here
	LOCAL oLan:=Language{} as Language
	LOCAL cFilter:=self:cLocation as STRING
	local lSuccess as logic 
//	self:SetTexts()
	self:Caption:=oLan:WGet(self:Caption) 
	If self:cLocation=="M"
		self:Caption+=oLan:WGet("Menus")
	elseif self:cLocation=="R"
		self:Caption+=oLan:WGet("Reports")
	elseif self:cLocation=="W"
		self:Caption+=oLan:WGet("Windows")
	endif
//	oLanguage := SQLSelect{"Select * from Language where Location = " + cFilter, oConn}
//	lSuccess:=self:Server:SetFilter('LOCATION=="'+cFilter+'"') 
// This fails for SQLServer. Should use Where clause instead	
	RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class LanguageWindow

	oLanguage := SQLSelect{"Select sentenceen, sentencemy, `length`, location from language where location = '" + self:cLocation + "'", oConn}
	//Put your PreInit additions here
	return NIL

STATIC DEFINE LANGUAGEWINDOW_FINDNEXT := 102 
STATIC DEFINE LANGUAGEWINDOW_FINDPREVIOUS := 101 
STATIC DEFINE LANGUAGEWINDOW_FINDTEXT := 103 
STATIC DEFINE LANGUAGEWINDOW_FIXEDTEXT1 := 104 
STATIC DEFINE LANGUAGEWINDOW_FIXEDTEXT2 := 105 
STATIC DEFINE LANGUAGEWINDOW_LANGUAGESUBWINDOW := 100 
STATIC DEFINE LANGUAGEWINDOW_LENGTH := 104 
STATIC DEFINE LANGUAGEWINDOW_OKBUTTON := 106 
STATIC DEFINE LANGUAGEWINDOW_SC_SENTENCEEN := 100 
STATIC DEFINE LANGUAGEWINDOW_SC_SENTENCEMY := 101 
STATIC DEFINE LANGUAGEWINDOW_SENTENCEEN := 102 
STATIC DEFINE LANGUAGEWINDOW_SENTENCEMY := 103 
