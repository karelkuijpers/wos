Define IDM_LANGUAGE_NAME := "Language"
Define IDM_Language_USERID := "parous…ºw@™Ðw"
CLASS Language 
declare method Get,RGet,MGet,WGet,MarkUpLanItem
METHOD Get(cSentenceEnglish as string,nLength:=80 as int,cPicture:='' as string,cPad:='' as string,cLocation:='R' as string) as string CLASS Language
return self:RGet(cSentenceEnglish,nLength,cPicture,cPad)
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
