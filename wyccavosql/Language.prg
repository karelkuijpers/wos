Define IDM_LANGUAGE_NAME := "Language"
Define IDM_Language_USERID := "parous…ºw@™Ðw"
CLASS Language INHERIT SQLTable
METHOD Get(cSentenceEnglish,nLength,cPicture,cPad,cLocation) CLASS Language
*	Get text in english or my language:
*	cSentenceEnglish:	English text to be translated (or not)
* 	nLength:			Length of text to be returned (default length as it is)
*	cPicture:			Pictureformat in which the text must be returned (default as it is)
*						"!"=first letter uppercase
*	cPad:				R:Adjust right, L: left, C: center; default left
* 	cLocation:			M:menu, W: Windows, R(or empty): Reports

LOCAL cText, cZoek as STRING
IF Empty(cSentenceEnglish)
	RETURN ""
ENDIF
Default(@cLocation,"R")
//cText:=AllTrim(Lower(cSentenceEnglish))
cText:=AllTrim(cSentenceEnglish)
cZoek:=Lower(Pad(cText,80))
IF !Alg_taal="E"
	if self:Seek({#LOCATION,#SENTENCEEN},{cLocation,cZoek})
		IF !Empty(self:SentenceMy)
			cText:=AllTrim(self:SentenceMy)
		ENDIF
	ELSE
		self:Append()
		IF !Empty(nLength).and.!IsNil(nLength)
			self:Length:=Min(nLength,80)
		ELSE
			self:Length:=80
		ENDIF
		self:LOCATION:=cLocation
		self:SentenceEn:=cText
	ENDIF
ENDIF
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
METHOD Init( cTable, oConn ) CLASS Language
LOCAL oFS,oHL AS OBJECT

IF IsNil(cTable)
   cTable := [`language`]
ENDIF

IF IsNil(oConn)
   oConn := SQLGetMyConnection( "", IDM_Language_USERID, "" )
ENDIF

super:Init( cTable, ;
  { ;
   [`SENTENCEEN`] , ;
   [`SENTENCEMY`] , ;
   [`LENGTH`] , ;
   [`LOCATION`]   }, oConn )

oHyperLabel := HyperLabel{IDM_LANGUAGE_NAME,  ;
   "Language",  ;
   ,  ;
   "Language" }
IF oHLStatus = NIL
    self:Seek()
    self:SetPrimaryKey(1)
    self:SetPrimaryKey(4)
    oFS:=language_SENTENCEEN{}
    self:SetDataField(1,DataField{[SENTENCEEN] ,oFS})
    oFS:=language_SENTENCEMY{}
    self:SetDataField(2,DataField{[SENTENCEMY] ,oFS})
    oFS:=language_LENGTH{}
    self:SetDataField(3,DataField{[LENGTH] ,oFS})
    oFS:=language_LOCATION{}
    self:SetDataField(4,DataField{[LOCATION] ,oFS})
    oHL := NULL_OBJECT
ENDIF
 
RETURN SELF
 
ACCESS LENGTH CLASS Language
 RETURN self:FieldGet(3)
ASSIGN LENGTH(uValue) CLASS Language
 RETURN self:FieldPut(3, uValue)
ACCESS LOCATION CLASS Language
 RETURN self:FieldGet(4)
ASSIGN LOCATION(uValue) CLASS Language
 RETURN self:FieldPut(4, uValue)
METHOD MGet(cSentenceEnglish,nLength,cPicture,cPad)  CLASS Language
	RETURN self:Get(cSentenceEnglish,nLength,cPicture,cPad,"M")
METHOD RGet(cSentenceEnglish,nLength,cPicture,cPad)  CLASS Language
	RETURN self:Get(cSentenceEnglish,nLength,cPicture,cPad,"R")
ACCESS SENTENCEEN CLASS Language
 RETURN self:FieldGet(1)
ASSIGN SENTENCEEN(uValue) CLASS Language
 RETURN self:FieldPut(1, uValue)
ACCESS SENTENCEMY CLASS Language
 RETURN self:FieldGet(2)
ASSIGN SENTENCEMY(uValue) CLASS Language
 RETURN self:FieldPut(2, uValue)
METHOD WGet(cSentenceEnglish,nLength,cPicture,cPad)  CLASS Language
	RETURN self:Get(cSentenceEnglish,nLength,cPicture,cPad,"W")

CLASS language_LENGTH INHERIT FIELDSPEC
METHOD Init() CLASS language_LENGTH
super:Init(HyperLabel{"LENGTH","Length","","language_LENGTH"},"N",11,0)

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
