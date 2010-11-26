TEXTBLOCK _ReadMe

/*  According  to the great Paul DiLascia:
      If this code works, it was written by Frank Seidel.
      If not, I don't know who wrote it.

    This little class encapsulates the MultiByteToWideChar() API Func,
    to make the conversion between VO strings and Unicode string easier.

    Simply instantiate an object of this class with a VO string as the
    only parameter and access the Unicode string via the BSTR ACCESS:

    	u := unicode{"{530E3D92-1E9B-11D3-8B44-0090270750C4}"}
      hr := CLSIDFromString(u:BSTR, @ClassGUID)
      ? "Length of u:", u:Len


    The allocated memory to hold the Unicode string will automatically
    be freed as the object will be thrown away by the GC.

*/
CLASS Unicode
	PROTECT pWChar,pWUTF8Char as ptr
	PROTECT pWCharCount AS DWORD
	PROTECT lError AS LOGIC
METHOD Axit() CLASS Unicode
  SELF:Destroy()
ACCESS BSTR CLASS Unicode
//RETURN self:pWChar
RETURN self:pWUTF8Char
METHOD Destroy() CLASS Unicode
  IF !InCollect()
    UnRegisterAxit(SELF)
  ENDIF
  MemFree(self:pWChar) 
  MemFree(self:pWUTF8Char)

ACCESS Error CLASS Unicode
RETURN SELF:lError
METHOD Init(cAnsi) CLASS Unicode
	LOCAL pszAnsi as psz
	LOCAL dwChars, nUniLen as DWORD
	Local nResult1,nError as DWord

	RegisterAxit(self)
	pszAnsi := String2Psz(cAnsi)
	dwChars := SLen(cAnsi)
	BEGIN SEQUENCE
		IF (self:pWChar := MemAlloc(dwChars * 2+2)) = null_ptr
			BREAK
		ENDIF
	  self:pWCharCount := dwChars * 2 
	  // Convert from internal AnSI to Unicode
		IF (nResult1:=MultiByteToWideChar(CP_ACP, 0, pszAnsi, dwChars,self:pWChar, dwChars)) = 0
			BREAK
		ENDIF
		nUniLen:=nResult1*2+6
		IF (self:pWUTF8Char := MemAlloc(nUniLen)) = null_ptr
			BREAK
		ENDIF 
		// Convert from UniCode to UTF8
		IF (pWCharCount:=WideCharToMultiByte( CP_UTF8,0,self:pWChar,nResult1,pWUTF8Char,nUniLen,null_psz,0)) =0
			BREAK
		ENDIF
	RECOVER
		self:lError := true 
		nError := GetLastError()	// Get the error code

	END SEQUENCE

ACCESS Len CLASS Unicode
RETURN self:pWCharCount
