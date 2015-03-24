textblock _ReadMe

/*  According  to the great Paul DiLascia:
      If this code works, it was written by Frank Seidel.
      If not, I don't know who wrote it.

    This little class encapsulates the MultiByteToWideChar() API Func,
    to make the conversion between VO strings and UTF2String string easier.

    Simply instantiate an object of this class with a VO string as the
    only parameter and access the UTF2String string via the BSTR ACCESS:

    	u := UTF2String{"{530E3D92-1E9B-11D3-8B44-0090270750C4}"}
      hr := CLSIDFromString(u:BSTR, @ClassGUID)
      ? "Length of u:", u:Len


    The allocated memory to hold the UTF2String string will automatically
    be freed as the object will be thrown away by the GC.

*/
CLASS UTF2String
	PROTECT pWChar,pWUTF8Char as ptr
	PROTECT pWCharCount as DWORD
	PROTECT lError as LOGIC
METHOD Axit() CLASS UTF2String
  self:Destroy()
ACCESS BSTR CLASS UTF2String
RETURN self:pWUTF8Char
METHOD Destroy() CLASS UTF2String
  IF !InCollect()
    UnRegisterAxit(self)
  ENDIF
  MemFree(self:pWChar)

ACCESS Error CLASS UTF2String
RETURN self:lError
METHOD Init(cUTF8) CLASS UTF2String
	LOCAL pszUTF8 as psz
	LOCAL dwChars, nUniLen as DWORD
	Local nResult1,nError as DWord

	RegisterAxit(self)
	pszUTF8 := String2Psz(cUTF8)
	dwChars := SLen(cUTF8)
	BEGIN SEQUENCE
		IF (self:pWChar := MemAlloc(dwChars * 2+2)) = null_ptr
			BREAK
		ENDIF
	  self:pWCharCount := dwChars
	  // Convert from UTF8 to UTF-16 (Unicode)
//		IF (nResult1:=MultiByteToWideChar(CP_ACP, 0, pszUTF8, dwChars,self:pWChar, dwChars)) = 0
		IF (nResult1:=MultiByteToWideChar(CP_UTF8, 0, pszUTF8, dwChars,self:pWChar, dwChars)) = 0
			BREAK
		ENDIF
		nUniLen:=nResult1+6
		IF (self:pWUTF8Char := MemAlloc(nUniLen)) = null_ptr
			BREAK
		ENDIF
		IF (pWCharCount:=WideCharToMultiByte( CP_ACP,0,self:pWChar,nResult1,pWUTF8Char,nUniLen,null_psz,0)) =0
			BREAK
		ENDIF
	RECOVER
		self:lError := true 
		nError := GetLastError()	// Get the error code

	END SEQUENCE


ACCESS Len CLASS UTF2String
RETURN self:pWCharCount
ACCESS OutBuf CLASS UTF2String
return Mem2String(pWUTF8Char,pWCharCount)
Function UTFSQL2Str(prtValue as ptr,ptrLength ref dword) as string 
	LOCAL pszUTF8 as psz
	LOCAL dwChars, nUniLen as DWORD
	Local nResult1,nError as DWord
	local pWChar,pWUTF8Char as ptr
	local pWCharCount as DWORD

	BEGIN SEQUENCE
		IF (pWChar := MemAlloc(ptrLength * 2+2)) = null_ptr
			BREAK
		ENDIF
	  pWCharCount := ptrLength
	  // Convert from UTF8 to UTF-16 (Unicode)
		IF (nResult1:=MultiByteToWideChar(CP_UTF8, 0, prtValue, ptrLength,pWChar, ptrLength)) = 0
			BREAK
		ENDIF
		nUniLen:=nResult1+6
		IF (pWUTF8Char := MemAlloc(nUniLen)) = null_ptr
			BREAK
		ENDIF
		IF (pWCharCount:=WideCharToMultiByte( CP_ACP,0,pWChar,nResult1,pWUTF8Char,nUniLen,null_psz,0)) =0
			BREAK
		ENDIF
	RECOVER
		nError := GetLastError()	// Get the error code

	END SEQUENCE
   return Mem2String(pWUTF8Char,pWCharCount) 

