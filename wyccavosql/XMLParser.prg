CLASS XMLAttribute

EXPORT Name						as SYMBOL
EXPORT Value					as STRING
CLASS XMLElement

	EXPORT Name						as SYMBOL
	PROTECT Value					as STRING
	PROTECT SubElements as ARRAY
	PROTECT Attributes as ARRAY

	~"ONLYEARLY+"
	DECLARE METHOD FillElementFromString
	DECLARE METHOD FillAttributes
	DECLARE METHOD FillSubElements

	DECLARE METHOD GetElementOnName 
	DECLARE METHOD GetElementOnPosition
	DECLARE METHOD GetAttributeOnName
	DECLARE METHOD GetAttributeOnPosition

	DECLARE METHOD SaveFile

	DECLARE METHOD AddElement
	DECLARE METHOD AddAttribute

	DECLARE ACCESS NbrOfSubElements
	DECLARE ACCESS NbrOfAttributes

	DECLARE ACCESS STRINGValue
	DECLARE ASSIGN STRINGValue
	DECLARE METHOD Save2String 
	
	DECLARE METHOD ScanElement
	DECLARE METHOD XMLScan
	~"ONLYEARLY-"
METHOD AddAttribute ( oXMLAttribute as XMLAttribute ) as void STRICT CLASS XMLElement
~"ONLYEARLY+"
if self:Attributes==null_array
	self:Attributes := {oXMLAttribute }
else 	
	AAdd ( self:Attributes , oXMLAttribute  )
endif
RETURN
~"ONLYEARLY-"
METHOD AddElement ( oXMLElement AS XMLElement ) AS VOID STRICT CLASS XMLElement
~"ONLYEARLY+" 
if self:SubElements==null_array
	self:SubElements:={ oXMLElement }
else
	AAdd ( self:SubElements , oXMLElement  )
endif
RETURN
~"ONLYEARLY-"

METHOD FillAttributes ( strTotalStartTag as STRING ) as void STRICT CLASS XMLElement

LOCAL dwEqualPos 							AS DWORD

LOCAL dwAttributeNameStartPos as DWORD
LOCAL dwAttributeValueEndPos	as DWORD
LOCAL oXMLAttribute						as XMLAttribute
~"ONLYEARLY+"
// Ga op zoek naar het eerste '=' teken.
DO WHILE TRUE
	dwEqualPos := At2 ( '=' , strTotalStartTag )
	IF dwEqualPos == 0
		// Er zitten geen Attributes meer in.
		EXIT
	ELSE
		// Zoek naar het begin van de Attributenaam.
	  dwAttributeNameStartPos := RAt2 ( ' ' , SubStr ( strTotalStartTag , 1 , dwEqualPos ) )
	  // Zoek naar het eind van de Attributevalue
	  dwAttributeValueEndPos	:= At3 ( ' ' , strTotalStartTag , dwEqualPos )
	  IF dwAttributeValueEndPos == 0
	  	dwAttributeValueEndPos := SLen ( strTotalStartTag )
	  ENDIF	
		
		oXMLAttribute := XMLAttribute{}
		oXMLAttribute:Name 	:= String2Symbol ( SubStr3 ( strTotalStartTag , dwAttributeNameStartPos , dwEqualPos - dwAttributeNameStartPos ) )
		oXMLAttribute:Value := SubStr3 ( strTotalStartTag , dwEqualPos + 2 , dwAttributeValueEndPos - dwEqualPos - 3 )
		
		self:AddAttribute(oXMLAttribute)
		strTotalStartTag := SubStr2 ( strTotalStartTag , dwAttributeValueEndPos )
	ENDIF

ENDDO

RETURN
~"ONLYEARLY-"
METHOD FillElementFromString ( strXMLString AS STRING , dwStartInterval AS DWORD , dwEndInterval AS DWORD ) AS STRING STRICT CLASS XMLElement

LOCAL dwStartTagStartPos  AS DWORD
LOCAL dwStartTagEndPos    AS DWORD
LOCAL dwEndTagStartPos    AS DWORD
LOCAL dwEndTagLenght      AS DWORD
LOCAL dwTagNameEndPos			AS DWORD
LOCAL	dwNextTagStart      AS DWORD

LOCAL strTotalStartTag			AS STRING
LOCAL strTagName          	AS STRING
LOCAL strValue              AS STRING

LOCAL strXMLString2Process  AS STRING
LOCAL strXMLStringLeft 			AS STRING
LOCAL strEndTag             AS STRING
~"ONLYEARLY+"
// Zoek eerst de TagName uit.
// Daarvoor zoeken we naar de eerste '<'.
dwStartTagStartPos := At2('<',strXMLString )
IF dwStartTagStartPos > 0
	// Zoek nu naar de eerste '>' na dwTag
	dwStartTagEndPos			:= At3('>',strXMLString , dwStartTagStartPos )
	
	// Lees nu de complete TAG uit de XMLString.
	strTotalStartTag := SubStr3(strXMLString,dwStartTagStartPos,dwStartTagEndPos)
	// Haal de tagname uit strTotalStartTag.
	// Zoek daarvoor naar de eerste spatie in strTotalStartTag
	dwTagNameEndPos := At2 ( ' ' , strTotalStartTag )
	IF dwTagNameEndPos == 0
		// Blijkbaar is de TagName omsloten door de < en > tekens.
		// We hoeven dan alleen het eerste en het laatste teken eraf te halen.
		strTagName := SubStr3 ( strTotalStartTag , 2 , dwStartTagEndPos - 2 )
	ELSE
		strTagName := SubStr3 ( strTotalStartTag , 2 , dwTagNameEndPos - 2 )
	ENDIF	
	
	// Ga nu op zoek naar de sluitingsTAG.
	// Denk er aan dat we met een niet omsloten TAG te maken kunnen hebben.
	IF SubStr2 ( strTotalStartTag , dwStartTagEndPos - 1 ) == '/>'
		// We hebben te maken met een TAG waarin geen SubElements vastliggen.
		// Alles wat achter de sluiting van dit element ligt wordt NIET
		// door dit element ontsloten en kan dus worden doorgeschoven naar een
		// ander verwerkingsniveau.
		strXMLString2Process  := ""
//		strXMLStringLeft 			:= SubStr2 ( strXMLString , dwStartTagEndPos + 1 )
	ELSE
		strEndTag := '</' + strTagName + '>'
		dwEndTagStartPos 	:= RAt(strEndTag , strXMLString)
		dwEndTagLenght 		:= SLen ( strEndTag )
		// Haal de string binnen de TAG's uit strXMLString.
		strXMLString2Process 	:= SubStr3 ( strXMLString , dwStartTagEndPos + 1 , dwEndTagStartPos - dwStartTagEndPos - 1 )
//		strXMLStringLeft 			:= SubStr2 ( strXMLString , dwEndTagStartPos + dwEndTagLenght )
	ENDIF
	
	// We kunnen nu de Naam van de TAG invullen.
	SELF:Name := String2Symbol ( strTagName )
	
	// We kunnen de Value heel makkelijk uit strXMLString2Process halen.
	dwNextTagStart := At2 ( '<' , strXMLString2Process )
	IF dwNextTagStart == 0
		// Er zitten geen TAG's meer in deze XMLString.
		strValue := strXMLString2Process
		
	ELSE	
    // Er zitten nog wel SubTags in deze XMLString.
		strValue := SubStr ( strXMLString2Process , 1 , dwNextTagStart - 1 )
	ENDIF	
	SELF:Value := strValue
	
	// We kunnen de Attributes voor deze TAG gaan invullen.
	self:FillAttributes ( strTotalStartTag )

  // We kunnen de SubElements voor deze Tag gaan aanmaken.
	self:FillSubElements ( strXMLString2Process )
	
	// Verwerk nu de te verwerken XMLString
	
ENDIF	

// Zorg dat buiten de TAG liggende elementen ergens anders weer verwerkt worden.		
RETURN strXMLStringLeft
~"ONLYEARLY-"
METHOD FillSubElements ( strXMLString as STRING ) as void STRICT CLASS XMLElement

LOCAL dwStartTagStartPos  AS DWORD
LOCAL dwStartTagEndPos    AS DWORD
LOCAL dwEndTagStartPos    AS DWORD
LOCAL dwEndTagLenght      AS DWORD
LOCAL dwTagNameEndPos			AS DWORD

LOCAL strTotalStartTag			AS STRING
LOCAL strTagName          	AS STRING

LOCAL strXMLString2Process  AS STRING
LOCAL strXMLStringLeft 			AS STRING
LOCAL strEndTag             AS STRING

LOCAL oXMLElement 					AS XMLElement
~"ONLYEARLY+"
// Ga weer op zoek naar de eerste TAG die er gevonden kan worden.

DO WHILE TRUE
	dwStartTagStartPos := At2('<',strXMLString )
	IF dwStartTagStartPos > 0
		// Zoek nu naar de eerste '>' na dwTag
		dwStartTagEndPos			:= At3('>',strXMLString , dwStartTagStartPos )
		
		// Lees nu de complete TAG uit de XMLString.
		strTotalStartTag := SubStr3(strXMLString,dwStartTagStartPos,dwStartTagEndPos-dwStartTagStartPos+1)
		// Haal de tagname uit strTotalStartTag.
		// Zoek daarvoor naar de eerste spatie in strTotalStartTag
		dwTagNameEndPos := At2 ( ' ' , strTotalStartTag )
		IF dwTagNameEndPos == 0
			// Blijkbaar is de TagName omsloten door de < en > tekens.
			// We hoeven dan alleen het eerste en het laatste teken eraf te halen.
			strTagName := SubStr3 ( strTotalStartTag , 2 , SLen ( strTotalStartTag ) - 2 )
		ELSE
			strTagName := SubStr3 ( strTotalStartTag , 2 , dwTagNameEndPos - 2 )
		ENDIF	
		
		// Ga nu op zoek naar de sluitingsTAG.
		// Denk er aan dat we met een niet omsloten TAG te maken kunnen hebben.
		IF SubStr2 ( strTotalStartTag , dwStartTagEndPos - 1 ) == '/>'
			// We hebben te maken met een TAG waarin geen SubElements vastliggen.
			// Alles wat achter de sluiting van dit element ligt wordt NIET
			// door dit element ontsloten en kan dus worden doorgeschoven naar een
			// ander verwerkingsniveau.
			strXMLString2Process  := strTotalStartTag
			strXMLStringLeft 			:= SubStr2 ( strXMLString , dwStartTagEndPos + 1 )
		ELSE
			strEndTag := '</' + strTagName + '>'
			dwEndTagStartPos 	:= RAt(strEndTag , strXMLString)
			dwEndTagLenght 		:= SLen ( strEndTag )
			// Haal de string INCLUSIEF de TAG's uit strXMLString.
			strXMLString2Process 	:= SubStr3 ( strXMLString , dwStartTagStartPos , dwEndTagStartPos + dwEndTagLenght - dwStartTagStartPos )
			strXMLStringLeft 			:= SubStr2 ( strXMLString , dwEndTagStartPos + dwEndTagLenght )
		ENDIF
		
		oXMLElement := XMLElement{}
		oXMLElement:FillElementFromString ( strXMLString2Process , 1 , 1 )
		self:AddElement ( oXMLElement )
	ELSE
		EXIT		
	ENDIF	
	strXMLString := strXMLStringLeft
ENDDO	

RETURN
~"ONLYEARLY-"		

METHOD GetAttributeOnName ( symAttributeName as SYMBOL ) as XMLAttribute STRICT CLASS XMLElement

	LOCAL dwPos           	AS DWORD
	LOCAL oXMLAttribute 		as XMLAttribute
	~"ONLYEARLY+" 
	if !self:Attributes==null_array
		dwPos := AScan ( self:Attributes , {|x| x:Name==symAttributeName } )
		IF dwPos > 0
			oXMLAttribute := self:Attributes [ dwPos  ]
		ENDIF
	endif
	RETURN oXMLAttribute
	~"ONLYEARLY-"

METHOD GetAttributeOnPosition ( dwPosition as DWORD ) as XMLAttribute STRICT CLASS XMLElement
~"ONLYEARLY+"
RETURN self:Attributes [ dwPosition ]
~"ONLYEARLY-"

METHOD GetElementOnName ( symElementName as SYMBOL ) as XMLElement STRICT CLASS XMLElement

	LOCAL dwPos           as DWORD 
	LOCAL oXMLElement 		AS XMLElement
	~"ONLYEARLY+" 
	if !self:SubElements==null_array
		dwPos := AScan ( self:SubElements , {|x| x:Name==symElementName } )
		IF dwPos > 0
			oXMLElement := self:SubElements [ dwPos  ] 
		ENDIF
	endif
	RETURN oXMLElement	
	~"ONLYEARLY-"
METHOD GetElementOnPosition ( dwPosition as DWORD ) as XMLElement STRICT CLASS XMLElement
~"ONLYEARLY+"
RETURN self:SubElements [ dwPosition  ]
~"ONLYEARLY-"

ACCESS NbrOfAttributes() as DWORD STRICT CLASS XMLElement
~"ONLYEARLY+"
RETURN ALen ( self:Attributes )
~"ONLYEARLY-"

ACCESS NbrOfSubElements() as DWORD STRICT CLASS XMLElement
~"ONLYEARLY+"
RETURN ALen(self:SubElements)
~"ONLYEARLY-"

METHOD Save2String() AS STRING STRICT CLASS XMLElement

LOCAL strRetValue			AS STRING

LOCAL oAttribute      		as XMLAttribute

LOCAL dwI                 		AS DWORD
LOCAL dwNbrOfAttributes			as DWORD
LOCAL dwNbrOfSubElements   	as DWORD

LOCAL strValue                AS STRING

~"ONLYEARLY+"
// Ga beginnen met het maken van een openingstag.
// Schrijf eerst de naam van het element weg.
strRetValue := strRetValue + "<" + Symbol2String(SELF:Name)

// oAttributes := self:Attributes
dwNbrOfAttributes := self:NbrOfAttributes
FOR dwI := 1 upto dwNbrOfAttributes
	oAttribute := self:GetAttributeOnPosition ( dwI )
	strRetValue := strRetValue + " " + Symbol2String(oAttribute:Name) + '="' + oAttribute:Value + '"'
NEXT

// Sluit de openingstag.
strRetValue := strRetValue + ">"

// Ga de waarde van het element omschrijven zodat bepaalde gekke tekens er niet meer in voorkomen.
strValue := AllTrim(SELF:Value)
strValue := StrTran( strValue , "<" , "&lt;" )
strValue := StrTran( strValue , ">" , "&gt;" )

// Schrijf nu de data weg.
strRetValue := strRetValue + strValue

// Schrijf eventuele SubElements weg.
// oSubElements := self:SubElements
dwNbrOfSubElements := self:NbrOfSubElements
FOR dwI := 1 upto dwNbrOfSubElements
	self:GetElementOnPosition ( dwI ):Save2String ()
NEXT

// Schrijf nu de sluitingstag weg.
strRetValue := strRetValue + "</" + Symbol2String(SELF:Name) + ">"

RETURN strRetValue
~"ONLYEARLY-"
METHOD SaveFile ( ptrFileHandle AS PTR ) AS VOID STRICT CLASS XMLElement

LOCAL oAttribute      		as XMLAttribute

LOCAL dwI                 		AS DWORD
LOCAL dwNbrOfAttributes			as DWORD
LOCAL dwNbrOfSubElements   	as DWORD

LOCAL strValue                AS STRING
~"ONLYEARLY+"
// Ga beginnen met het maken van een openingstag.
// Schrijf eerst de naam van het element weg.
FWrite ( ptrFileHandle , "<" + Symbol2String(SELF:Name) )

// oAttributes := self:Attributes
dwNbrOfAttributes := self:NbrOfAttributes
FOR dwI := 1 upto dwNbrOfAttributes
	oAttribute := self:GetAttributeOnPosition ( dwI )
	FWrite ( ptrFileHandle , " " + Symbol2String(oAttribute:Name) + '="' + oAttribute:Value + '"' )
NEXT

// Sluit de openingstag.
FWrite ( ptrFileHandle , ">" )

// Ga de waarde van het element omschrijven zodat bepaalde gekke tekens er niet meer in voorkomen.
strValue := AllTrim(SELF:Value)
strValue := StrTran( strValue , "<" , "&lt;" )
strValue := StrTran( strValue , ">" , "&gt;" )

// Schrijf nu de data weg.
FWrite ( ptrFileHandle , strValue)

// Schrijf eventuele SubElements weg.
// oSubbElements := self:SubElements
dwNbrOfSubElements := self:NbrOfSubElements
FOR dwI := 1 upto dwNbrOfSubElements
	self:GetElementOnPosition ( dwI ):SaveFile ( ptrFileHandle )
NEXT

// Schrijf nu de sluitingstag weg.
FWrite ( ptrFileHandle ,  "</" + Symbol2String(SELF:Name) + ">" )

RETURN
~"ONLYEARLY-"
METHOD ScanElement ( symElementName as SYMBOL,Position:=1 ref DWORD ) as XMLElement STRICT CLASS XMLElement
// get next element with name symElementName  after position  Position
// new position is returned

	LOCAL dwPos:=Position           as DWORD 
	local curPos			as DWORD
	LOCAL oXMLElement 		as XMLElement
	~"ONLYEARLY+" 
	if !self:SubElements==null_array .and. dwPos<Len(self:SubElements)
		dwPos := AScan ( self:SubElements , {|x| x:Name==symElementName },dwPos+1 )
		IF dwPos > 0
			oXMLElement := self:SubElements [ dwPos  ] 
		ENDIF
		Position:=dwPos
	endif
	RETURN oXMLElement	
	~"ONLYEARLY-"
ACCESS STRINGValue() AS STRING STRICT CLASS XMLElement
~"ONLYEARLY+"
RETURN SELF:Value
~"ONLYEARLY-"

ASSIGN STRINGValue( strNewValue AS STRING ) AS STRING STRICT CLASS XMLElement
~"ONLYEARLY+"
SELF:Value := strNewValue
RETURN strNewValue
~"ONLYEARLY-"


METHOD XMLScan ( symElementName as SYMBOL,Position:=0 as DWORD ) as DWORD STRICT CLASS XMLElement
// get next element with name symElementName  after position  Position
// new position is returned

	LOCAL dwPos:=Position           as DWORD 
	local curPos			as DWORD
	LOCAL oXMLElement 		as XMLElement
	~"ONLYEARLY+" 
	if !self:SubElements==null_array .and. dwPos<Len(self:SubElements)
		dwPos := AScan ( self:SubElements , {|x| x:Name==symElementName },dwPos+1 ) 
	else
		dwPos:=0
	endif 
	RETURN dwPos	
	~"ONLYEARLY-"
CLASS XMLParser

EXPORT FileName	      AS STRING
EXPORT RootElement		AS XMLElement
EXPORT XSLTFileName   AS STRING

~"ONLYEARLY+"
DECLARE METHOD LoadFile
DECLARE METHOD CreateElementFromString
DECLARE METHOD SaveFile
DECLARE METHOD XMLString 
declare method CreateElementFromFile
declare method LoadFileLines
// LET OP : XML_Parser is NIET! Case-sensitive voor namen van Attributes en elementen!!!!
~"ONLYEARLY-"

METHOD CreateElementFromFile ( oMf as MyFile ) as XMLElement STRICT CLASS XMLParser

	//#p oMf			-> File with XML

	LOCAL oXMLElement					as XMLElement
	LOCAL oSubXMLElement      as XMLElement

	LOCAL oXMLAttribute				as XMLAttribute

	LOCAL dwStartTagStartPos 	as DWORD
	LOCAL dwStartTagEndPos 		as DWORD
	LOCAL dwSpacePos          as DWORD

	LOCAL strStartTag					as STRING
	LOCAL dwNewTagStartPos 		as DWORD

	LOCAL dwQuotePos          as DWORD
	LOCAL dwEqualPos          as DWORD
	LOCAL strAttributeName    as STRING
	LOCAL strAttributeValue   as STRINg 
	local strXMLString			as string

	~"ONLYEARLY+"
	// read next line with tags
	strXMLString := oMf:FReadLine() 
	if oMf:FEof
		return oXMLElement
	endif
	
	do while Left(strXMLString,2)=='<?' 
		// skip information tags
		strXMLString := oMf:FReadLine()
	enddo
	if (dwStartTagStartPos := At2 ( '<' , strXMLString  )+1)=1 
		return oXMLElement
	endif
	// Look for end of tag:
	if (dwStartTagEndPos := At3 ( '>' , strXMLString , dwStartTagStartPos ))==0
		return oXMLElement
	ENDIF
	
	// Retrieve StartTag out of XMLString. 
	strStartTag := SubStr3 ( strXMLString , dwStartTagStartPos , dwStartTagEndPos - dwStartTagStartPos ) 
	if Left(strStartTag,1)=='/'
		// end tag
		return oXMLElement
	endif
		
	// Create new element:
	oXMLElement := XMLElement{} 
	
	// Determine first space in StartTag 
	// It is an indication of an attribute
	if (dwSpacePos := At2 ( ' ' , strStartTag ))>0
		oXMLElement:Name:=String2Symbol(SubStr3(strStartTag,1,dwSpacePos - 1 ))
		DO WHILE true
			// Look for '=' character.
			dwEqualPos := At3 ( '=' , strStartTag , dwSpacePos )
			IF dwEqualPos > 0
				strAttributeName := SubStr3 ( strStartTag , dwSpacePos , dwEqualPos - dwSpacePos )
				dwQuotePos := At3 ( '"' , strStartTag , dwEqualPos + 1 )
				IF dwQuotePos > 0
					strAttributeValue := SubStr ( strStartTag , dwEqualPos + 2 , dwQuotePos - dwEqualPos - 2 )
				ELSE
					// error situation
					exit	
				ENDIF
				
				oXMLAttribute := XMLAttribute{}
				oXMLAttribute:Name 	:= String2Symbol(AllTrim(strAttributeName))
				oXMLAttribute:Value	:= strAttributeValue
				
				oXMLElement:AddAttribute ( oXMLAttribute)
				
				// A next attribute after last '"'
				dwSpacePos := dwQuotePos + 1
			ELSE
				exit
			ENDIF
		ENDDO 
	elseif Right( strStartTag , 1 ) == '/' 
		// Tag is endtag
		oXMLElement:Name:=String2Symbol(SubStr3 ( strStartTag, 1 , Len(strStartTag) - 1 ))
	else
		// normal situation
		oXMLElement:Name:=String2Symbol(strStartTag)		
	endif
	
	// Look for end tag, then at lowest level
	dwNewTagStartPos := At3 ( '</' , strXMLString , dwStartTagEndPos )

	IF dwNewTagStartPos > 0
		// lowest level with value:
		oXMLElement:STRINGValue := AllTrim( SubStr3 ( strXMLString , dwStartTagEndPos + 1 , dwNewTagStartPos - dwStartTagEndPos - 1 ) )
	ELSE
		// look for lower level:
		do while !(oSubXMLElement := self:CreateElementFromFile (oMf))=null_object		
			oXMLElement:AddElement ( oSubXMLElement )
		ENDDO
	ENDIF	

	RETURN oXMLElement
	~"ONLYEARLY-"

METHOD CreateElementFromString ( strXMLString as STRING, dwIntervalStartPos as DWORD , dwEindPositie ref DWORD ) as XMLElement STRICT CLASS XMLParser

	//#p strXMLString					-> De String waarin we moeten zoeken.
	//#p dwIntervalStartPos   -> StartPositie van het interval binnen strXMLString dat we mogen gebruiken.
	//#p dwIntervalEndPos			-> EindPositie van het interval binnen strXMLString dat we mogen gebruiken.

	LOCAL oXMLElement					AS XMLElement
	LOCAL oSubXMLElement      AS XMLElement

	LOCAL oXMLAttribute				as XMLAttribute

	LOCAL dwStartTagStartPos 	AS DWORD
	LOCAL dwStartTagEndPos 		AS DWORD
	LOCAL dwSpacePos          AS DWORD

	LOCAL strStartTag					AS STRING
	LOCAL strTagName          AS STRING

	LOCAL strElementData 			AS STRING
	LOCAL dwNewTagStartPos 		AS DWORD
	LOCAL dwEndTagEndPos 			AS DWORD
	LOCAL dwNieuweEindPositie AS DWORD

	LOCAL dwQuotePos          AS DWORD
	LOCAL dwEqualPos          AS DWORD
	LOCAL strAttributeNaam    as STRING
	LOCAL strAttributeValue   as STRING

	~"ONLYEARLY+"
	// Ga op zoek naar de start van de eerste openingsTAG in de XMLString.
	dwStartTagStartPos := At3 ( '<' , strXMLString , dwIntervalStartPos - 1 )
	IF dwStartTagStartPos == 0
		// We kunnen geen startTAG vinden in de string.
		// We stoppen er dus maar mee.
	ELSE
		// Nu we zeker weten dat we een TAG binnen de string hebben gaan we op zoek naar de
		// sluiting van die TAG.
		dwStartTagEndPos := At3 ( '>' , strXMLString , dwStartTagStartPos )
		#IFDEF __DEBUG__
			IF dwStartTagEndPos == 0
				// Dit mag nooit voorkomen. Er zit nu immers een halve TAG in XMLString.
				//? "Er zit iets helemaal mis."
			ENDIF
		#ENDIF
		
		// Haal de StartTag uit de XMLString.
		// Laat de laatste '>' voor wat die is.
		strStartTag := SubStr3 ( strXMLString , dwStartTagStartPos , dwStartTagEndPos - dwStartTagStartPos )
		
		// Bepaal waar de eerste spatie in de StartTag ligt.
		// Dat gegeven hebben we straks op meerdere plaatsen nodig.
		dwSpacePos := At2 ( ' ' , strStartTag )

		// Bepaal de naam van het Element.
		/*  Revisie 03-05-2001 OCh inlezen van combinatie open en gesloten tags gaat fout : de slash moet worden verwijderd.
		IF dwSpacePos == 0
		// Er zit geen spatie in de TAG.
		// Er zitten dus geen Attributes in.
		// De Tag heeft dus de vorm <TAG>
		strTagName := SubStr2(strStartTag,2)
		ELSE	
		strTagName := SubStr3(strStartTag,2,dwSpacePos - 2 )
		ENDIF
		*/
		DO CASE
		CASE dwSpacePos > 0
			// er zit een spatie in de TAG
			// er zitten dus Attributes in, die moeten we niet meenemen in de naam.
			strTagName := SubStr3(strStartTag,2,dwSpacePos - 2 )
		CASE SubStr3 ( strStartTag , dwStartTagEndPos - dwStartTagStartPos , 1 ) == '/'
			// we hebben te maken met een tag die toevallig ook een eindtag is.
			// De laatste slash moeten we niet meenemen bij het bepalen van de naam.
			strTagName := SubStr3 ( strStartTag, 2 , dwStartTagEndPos - dwStartTagStartPos - 2 )
		OTHERWISE
			// normale situatie
			strTagName := SubStr2(strStartTag,2)
		ENDCASE



		// Maak nu het element aan.
		oXMLElement := XMLElement{} 
		oXMLElement:Name:=String2Symbol(strTagName)

		// Bepaal of de TAG geen eindtag heeft.
		// Als dat zo is is het laatste teken van de TAG een '/'
		IF SubStr3 ( strStartTag , dwStartTagEndPos - dwStartTagStartPos , 1 ) == '/'
			// We hebben geen EndTag voor dit element.
			// We hoeven dus niet verder meer te zoeken voor deze TAG.

			// Wel moeten we nog even de EindPositie opschuiven. Anders komen we in een oneindige lus.
			dwEindPositie := At3 ( '>' , strXMLString , dwStartTagEndPos - 1 )
			IF dwEindPositie > 0
				dwEindPositie 	:= dwEindPositie		+ 1
			ELSE
				// Deze situatie mag nooit voorkomen.
				AltD()
			ENDIF	
			

		ELSE	
			// Ga nu op zoek naar het volgende '<' teken.
			// Alle gegevens vanaf het einde van de starttag tot aan dat punt bevatte in ieder geval data.
			dwNewTagStartPos := At3 ( '<' , strXMLString , dwStartTagEndPos )

			IF dwNewTagStartPos > 0
				// We hebben de EndTag van bovenstaande sluitingstag te pakken.
				strElementData := SubStr3 ( strXMLString , dwStartTagEndPos + 1 , dwNewTagStartPos - dwStartTagEndPos - 1 )
			ELSE
				strElementData := NULL_STRING
			ENDIF
			//   	strElementData 					:= StrTran( strElementData , "&lt;" , "<" )
			// 		strElementData 					:= StrTran( strElementData , "&gt;" , ">" )

			// OCh : 08-01-2001 spaties verwijderen, ook voorloop spaties!
			oXMLElement:STRINGValue := AllTrim( strElementData )
			
			IF dwNewTagStartPos > 0
				// Kijk nu of het begin van de volgende TAG dat we gevonden hebben
				// Het einde van dit Element is of dat we nog SubElements moeten inlezen.
				DO WHILE TRUE
					IF SubStr ( strXMLString , dwNewTagStartPos + 1 , 1 ) == '/'
						// We zitten aan het einde.
						// Zoek naar het sluitende deel van deze sluitingsTAG
						dwEndTagEndPos 	:= At3 ( '>' , strXMLString , dwNewTagStartPos )
						IF dwEndTagEndPos > 0
							dwEindPositie 	:= dwEndTagEndPos		+ 1
						ELSE
							dwEindPositie 	:= dwNewTagStartPos + 1
						ENDIF	
						EXIT
					ELSE
						// We hebben een openingstag voor een nieuw XMLElement te pakken.
						dwNieuweEindPositie := dwNewTagStartPos
						oSubXMLElement := SELF:CreateElementFromString ( strXMLString , dwNewTagStartPos , @dwNieuweEindPositie )
						
						// Voeg het gemaakte oSubXMLElement toe aan de verzameling met SubElements.
						IF oXMLElement != NULL_OBJECT
							oXMLElement:AddElement ( oSubXMLElement )
						ENDIF
						
						// De cursor staat nu op het eerste teken NA het hierboven aangemaakte oSubXMLElement.
						// We moeten echter nog evendoorzoeken naar de eerstvolgende opening van een TAG.
						dwNewTagStartPos := At3 ( '<' , strXMLString , dwNieuweEindPositie - 1)
						
						IF dwNewTagStartPos == 0
							// Kan eigenlijk niet. Fout schrijven in log. // NOG NIET AF!!
						ENDIF	
					ENDIF
				ENDDO
			ENDIF	
		ENDIF	
		
		// We zijn nog niet helemaal klaar want we moeten de parameters nog
		// uit de starttag halen.
		// Er zitten alleen een Attribute in de StartTag als dwSpacePos groter dan nul is.
		IF dwSpacePos > 0
			DO WHILE TRUE
				// Ga vanaf de positie van de eerste spatie op zoek naar een '=' teken.
				dwEqualPos := At3 ( '=' , strStartTag , dwSpacePos )
				IF dwEqualPos > 0
					strAttributeNaam := SubStr3 ( strStartTag , dwSpacePos , dwEqualPos - dwSpacePos )
					// Het einde van de waarde van het Attribute zit bij in het stukje vanaf dwEqualPos
					// tot de tweede dubbele quote. Als we er van uit gaan dat de eerste quote
					// direct achter de = (dus in de vorm ="value") staat dan kunnen we zoeken vanaf dwEqualPos + 1
					dwQuotePos := At3 ( '"' , strStartTag , dwEqualPos + 1 )
					IF dwQuotePos > 0
						strAttributeValue := SubStr ( strStartTag , dwEqualPos + 2 , dwQuotePos - dwEqualPos - 2 )
					ELSE
						// Hier zouden we nooit mogen komen
						#IFDEF __DEBUG__
							// 	    			? "Gekke fout in XMLParser"
						#ENDIF	
						EXIT	
					ENDIF
					
					oXMLAttribute := XMLAttribute{}
					oXMLAttribute:Name 	:= String2Symbol(AllTrim(strAttributeNaam))
					oXMLAttribute:Value	:= strAttributeValue
					
					oXMLElement:AddAttribute ( oXMLAttribute)
					
					// Als het goed is start het eventuele volgende met een spatie achter de laatste '"'
					dwSpacePos := dwQuotePos + 1
					
				ELSE
					EXIT
				ENDIF
			ENDDO
		ENDIF
	ENDIF

	RETURN oXMLElement
	~"ONLYEARLY-"

METHOD LoadFile ( strFileName AS STRING ) AS LOGIC STRICT CLASS XMLParser

	LOCAL ptrFile   		as ptr
	LOCAL strXMLString  AS STRING

	LOCAL liLenght 			AS LONGINT
	LOCAL dwStartPos		AS DWORD
	LOCAL dwEndPos  		AS DWORD

	LOCAL dwDummy       AS DWORD

	LOCAL oXMLElement		as XMLElement 
	

	~"ONLYEARLY+"
	// Laad de file in.
	#IFDEF __DEBUG__
		IF ! File ( strFileName )
// 			? "File " + strFileName + " niet gevonden in de XMLParser!!!!"
		ENDIF
	#ENDIF	

	ptrFile := FOpen2(strFileName, FO_READ)
	IF ptrFile != F_ERROR
		// Bepaal de lengte van de file.
		liLenght := FSeek ( ptrFile , 0 , FS_END )
		// Zet de filepointer weer aan het begin van de file.
		FSeek( ptrFile , 0 )
		// Lees de inhoud van de file in.
		strXMLString := FReadStr ( ptrFile , liLenght )
		// Haal eventuele CRLF Tekens uit de XML file.


		strXMLString := StrTran( strXmlString , CRLF   ,NULL_STRING)
// 		strXMLString:=HtmlDecode(strXMLString)
		
		// Zorg dat de string in Static Memory komt te staan.
// 		DynToOldSpaceString(strXMLString)
		FClose ( ptrFile )
		// Zorg zorg dat er een XML-structuur wordt aangemaakt.
		// Als eerste halen we eventuele process-instructions '<?....?>' er af.
		DO WHILE TRUE
			dwStartPos := At2('<?' , strXMLString )
			IF dwStartPos > 0
				dwEndPos := At3('?>' , strXMLString , dwStartPos )
				strXMLString := SubStr3 ( strXMLString , 1 , dwStartPos - 1 ) + ;
					SubStr2 ( strXMLString , dwEndPos + 2 )
			ELSE
				EXIT
			ENDIF
		ENDDO
		
		oXMLElement := self:CreateElementFromString ( strXMLString , 1 , @dwDummy )
		
		// Haal de XMLString weer uit Static Memory
// 		OldSpaceFree ( strXMLString ) 
		strXMLString:=null_string // clear
		SELF:RootElement := oXMLElement
		
	ENDIF

	RETURN true

METHOD LoadFileLines ( strFileName as STRING ) as LOGIC STRICT CLASS XMLParser

	local oMf as MyFile
	

	~"ONLYEARLY+"
	// Check file
	#IFDEF __debug__
		IF ! File ( strFileName )
			return false
		ENDIF
	#ENDIF	

	oMf:=MyFile{FileSpec{strFileName}}
	IF !oMf:FEof
		self:RootElement := self:CreateElementFromFile (oMf )		
	ENDIF
   oMf:Close()
   
	RETURN true

METHOD SaveFile ( strFileName AS STRING ) AS LOGIC STRICT CLASS XMLParser

LOCAL ptrFile			AS PTR

~"ONLYEARLY+"
// Maak de nieuwe file aan.
ptrFile := FCreate2(strFileName, FC_NORMAL )
IF ptrFile != F_ERROR

  IF SELF:XSLTFileName != NULL_STRING
  	// Schrijf de naam van de XSLT-file weg.
  	// Dank er aan dat deze parser die XML-file dan niet meer kan inlezen!
  	FWriteLine(ptrFile,'<?xml-stylesheet href= "'+ AllTrim(SELF:XSLTFileName) +'.XSL" type="TEXT/xsl"?>')
  ENDIF	

	SELF:RootElement:SaveFile(ptrFile )
	FClose ( ptrFile )
ELSE
	// NOG NIET AF!!
	// Hier moet nog een foutmeldingsafhandeling komen.
ENDIF

RETURN TRUE
~"ONLYEARLY-"

METHOD XMLString () AS STRING STRICT CLASS XMLParser

LOCAL strXMLString			AS STRING

~"ONLYEARLY+"
strXMLString := SELF:RootElement:Save2String()

RETURN strXMLString
~"ONLYEARLY-"
