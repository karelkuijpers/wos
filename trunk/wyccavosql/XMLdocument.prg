CLASS XMLDocument
	PROTECT buffer AS STRING
	PROTECT currentParentName,currentChildName,currentChildContent as STRING
	PROTECT currentParentPtr,currentchildPtr,NextParentPtr,NextChildPtr,currentParentoffset as int
	Protect CP as int // 0:=ansi; 1:UTF8; 2:=Unicode
	declare method Init, UpdateContentCurrentElement, AddElement,GetElement,DeleteItem,GetBuffer,GetChild,GetContentCurrentElement,;
	GetFirstChild,GetNextChild,GetNextSibbling, SearchTag
Method AddElement(cNewname as string,cNewValue as string, cParentname as string) class XMLDocument
// add new element to given parent
LOCAL offset as int
if Empty(cParentname) .and.Empty(currentParentPtr)
	return false
endif
if !cParentname==currentParentName .or. Empty(currentParentPtr)
	self:GetElement(cParentname)
endif
IF currentParentPtr>0
	offset:=currentParentPtr+Len(currentParentName)+2
	buffer:=Stuff(buffer,offset,0,"<"+AllTrim(cNewname)+">"+AllTrim(cNewValue)+"</"+AllTrim(cNewname)+">")
	if NextParentPtr>0 
		NextParentPtr+=Len(AllTrim(cNewname))*2+Len(AllTrim(cNewValue))+5	
	ENDIF
	return true
ENDIF
RETURN false
ACCESS ChildContent() CLASS XMLDocument
	RETURN currentChildContent
ACCESS ChildName() CLASS XMLDocument
	RETURN currentChildName
ACCESS CodePage() CLASS XMLDocument
	RETURN CP

Assign CodePage(uValue)  CLASS XMLDocument

    RETURN self:CP:=uValue
METHOD DeleteItem() as string pascal  CLASS XMLDocument
	// delete current item from buffer
	IF currentParentPtr>0
		SELF:buffer:=SubStr(buffer,1,currentParentPtr-1)+SubStr(buffer,NextParentPtr+Len(currentParentName)+3)
		NextParentPtr:=currentParentPtr
	ENDIF
RETURN buffer	
Method GetBuffer() as string pascal  Class XMLDocument
return AllTrim(Buffer) 
METHOD GetChild(offset as int) as logic CLASS XMLDocument
	LOCAL startEnd, endPtr as int
	IF offset<NextParentPtr
		currentchildPtr:=At3("<",buffer,offset-1)
		IF currentchildPtr>0 .and.currentchildPtr<NextParentPtr
			startEnd:=At3(">",buffer,currentchildPtr+1)
			// check if empty content:
			IF SubStr(buffer,startEnd-1,2)=="/>"
				currentChildName:=SubStr(buffer,currentchildPtr+1,startEnd-currentchildPtr-2)
				endPtr:=startEnd
				currentChildContent:=""
				NextChildPtr:=startEnd+1
			ELSE	
				currentChildName:=(Split(SubStr(Buffer,currentchildPtr+1,startEnd-currentchildPtr-1)))[1]
			/*	SpacePtr:=AtC(" ",currentChildName)
				IF !Empty(SpacePtr)
					currentChildName:=SubStr(currentChildName,1,SpacePtr-1)
				ENDIF */
				endPtr:=At3("</"+currentChildName+">",buffer,startEnd)
				IF endPtr>0
					currentChildContent:= AllTrim(SubStr(buffer,startEnd+1,endPtr-startEnd-1))
					NextChildPtr:=At3(">",Buffer,endPTR+Len(currentChildName))+1
				ELSE
					currentChildContent:=""
					NextChildPtr:=0
				ENDIF
			ENDIF
			RETURN TRUE
		ENDIF
	ENDIF
RETURN FALSE	
METHOD GetContentCurrentElement() as string pascal CLASS XMLDocument
	LOCAL offset AS INT
	IF currentParentPtr>0
		offset:=currentParentPtr+Len(currentParentName)+2
		IF NextParentPtr>0
			RETURN AllTrim(SubStr(buffer,offset,NextParentPtr-offset))
		ENDIF
	ENDIF
	RETURN ""
METHOD GetElement(tagname as string) as logic CLASS XMLDocument
	// search first element with given tagname
	LOCAL aRes:={} as array
   
   aRes:=self:SearchTag(tagname)
   if Empty(aRes)
   	return false
   endif
	currentParentoffset:=aRes[2]
	NextParentPtr:=At3("</"+tagname+">",Buffer,currentParentoffset-1)
	currentParentName:=tagname
	currentParentPtr:=aRes[1] 
	if Empty( NextParentPtr)    // no closing tag? corrupted file
		return false
	else
		RETURN true
	endif
METHOD GetFirstChild() as logic pascal CLASS XMLDocument
	IF currentParentPtr>0
		RETURN SELF:GetChild(currentParentoffset)
	ENDIF
	RETURN FALSE
METHOD GetNextChild() as logic pascal CLASS XMLDocument
	IF NextChildPtr>0
		RETURN SELF:GetChild(NextChildPtr)
	ENDIF
RETURN FALSE
		
METHOD GetNextSibbling() as logic pascal CLASS XMLDocument
	LOCAL aRes:={} as array
	IF NextParentPtr>0
		aRes:=self:SearchTag(currentParentName,NextParentPtr+Len(currentParentName)+2)
		if Empty(aRes)
			return false
		endif 
		currentParentPtr:=aRes[1]
		currentParentoffset:=aRes[2]
		NextParentPtr:=At3("</"+currentParentName+">",Buffer,currentParentoffset)
		RETURN true
	ENDIF
/*		IF currentParentPtr>0
			TestStr:= SubStr(buffer,currentParentPtr+Len(currentParentName)+1,1)
			DO WHILE TestStr#" " .and. TestStr#">"
				currentParentPtr:=At3("<"+currentParentName,buffer,currentParentPtr+3)
				TestStr:= SubStr(buffer,currentParentPtr+Len(currentParentName)+1,1)
			ENDDO		
			IF TestStr=">"
				currentParentoffset:=currentParentPtr+Len(currentParentName)+2
			ELSE
				currentParentoffset:=At3(">",buffer,currentParentPtr+Len(currentParentName)+2)+1
			ENDIF
			NextParentPtr:=At3("</"+currentParentName+">",buffer,currentParentoffset)
			RETURN TRUE
		ENDIF
	ENDIF    */
RETURN FALSE
METHOD Init(bufferPtr as string) CLASS XMLDocument
LOCAL UTF8:=_chr(0xEF)+_chr(0xBB)+_chr(0xBF), UTF16:=_chr(0xFF)+_chr(0xFE) as string 

// buffer should be ptr to area with XML-data (by reference) 
if SubStr(bufferPtr,1,3) == UTF8
	self:CP:=1
	buffer:=(UTF2String{SubStr(bufferPtr,4)}):OutBuf
elseif SubStr(bufferPtr,1,2)==UTF16
	self:CP:=2
	buffer:=(UTF2String{SubStr(bufferPtr,4)}):OutBuf
else
	buffer:=bufferPtr
endif
return self
Method SearchTag(mytagname as string,offset:=0 as int) as array class XMLDocument
LOCAL endPTR, myParenPtr as int
LOCAL TestStr,tagname as STRING
//Default(@offset,0) 
myParenPtr:=AtC("<"+mytagname,Buffer)
IF myParenPtr>0
	tagname:=SubStr(Buffer,myParenPtr+1,Len(mytagname))
else
	return {}
endif
if offset>0
	myParenPtr:=At3("<"+mytagname,Buffer,offset)
endif	
do while myParenPtr>0
	endPTR:=myParenPtr+Len(tagname)+1
	TestStr:= SubStr(Buffer,endPTR,1) 
	if TestStr==">"
		endPTR++
		exit
	elseif TestStr=" "
		// search end of tag:
		endPTR:=At3(">",Buffer,endPTR)+1
		if endPTR>myParenPtr
			exit
		endif
	endif
	myParenPtr:=At3("<"+mytagname,Buffer,endPTR)
enddo
if myParenPtr==0 .or. endPTR==0
	return {}
endif
return {myParenPtr, endPTR}
METHOD UpdateContentCurrentElement(cNewValue as string) as logic CLASS XMLDocument
	LOCAL offset, LenDiff as int
	Local cCurValue as string
	IF currentParentPtr>0
		offset:=currentParentPtr+Len(currentParentName)+2
		IF NextParentPtr>0
			cCurValue:= AllTrim(SubStr(buffer,offset,NextParentPtr-offset))
			buffer:=Stuff(buffer,offset,Len(cCurValue),cNewValue) 
			LenDiff:=Len(cNewValue)
			LenDiff-=Len(cCurValue) 
			NextParentPtr+=LenDiff
			return true
		ENDIF
	ENDIF
	RETURN false
