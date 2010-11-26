FUNCTION CtoN(cKey)
* Translate a code of nLen printable characters to a sequence number nNbr, which is returned
*
LOCAL i,nPos,nNbr AS INT
nNbr:=0
FOR i:=1 TO Len(cKey)
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
CLASS MailCdKey INHERIT SystemKey
METHOD Init() CLASS MailCdKey

	SUPER:Init( "MAILCD", 2 )
	
	RETURN SELF
FUNCTION NtoC(nNbr,nLen)
* Translate a sequence number nNbr to code of nLen printable characters, which is returned
* E.g. three printable characters is sufficient for a sequence number up to 61*61*61=226981
*
LOCAL i,nIntrm,nPos AS INT
LOCAL cKey AS STRING
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
CLASS SystemKey
	PROTECT key
METHOD INIT( sKeyType, nLen ) CLASS SystemKey

	LOCAL oSysKey AS Syskey
	LOCAL i AS INT
	LOCAL cKeyId:=sKeyType AS STRING
	LOCAL oMcd AS PersCod
	
	oSysKey := SysKey{}
	IF oSyskey:used	
		IF ! oSysKey:Locate({||AllTrim(oSysKey:SYSKEY_ID)==cKeyId} )
			oSysKey:append()
			oSysKey:SysKey_Id:=sKeyType
			oSysKey:VALUE := Str( 1,10,0)
		ENDIF
		IF oSysKey:RLock()
			i:= Val(oSysKey:VALUE)
			IF sKeyType=="MAILCD"
				* Translate sequencenumber to three printable characters:
				* (max 61*61*61=226981, sufficient FOR all accounts)
				key:=NtoC(i,nLen)
				IF sKeyType=="MAILCD"
					* Search unique key:
					oMcd:=PersCod{,TRUE,TRUE}
					DO WHILE i<3720.and.(oMcd:Seek(key).or.key=="FI".or.key=="EO".or.key=="EG".or.key=="MW")
						++i
						key:=NtoC(i,nLen)
					ENDDO
					oMcd:Close()
					oMcd:=NULL_OBJECT
    			ENDIF
			ELSE
				IF i<Val("1"+Replicate("0",nLen-1)) .and. (sKeyType=="ACCOUNT".or.sKeyType=="BALITEM".or.sKeyType=="DEPARTMENT".or.sKeyType=="EMPLOYEE")
					// initialise special:
					i:=Val("1"+Replicate("0",nLen-1))
				ENDIF					
				key := StrZero(i,nLen,0)
			ENDIF
			oSysKey:VALUE := Str( i + 1,10,0)
			oSysKey:commit()
			oSysKey:UnLock()
		ENDIF
	
		oSysKey:Close()
	ENDIF
	oSysKey:=NULL_OBJECT
	
	RETURN SELF
ACCESS KeyValue CLASS SystemKey
	RETURN self:key
METHOD Reset (sKeyType) CLASS SystemKey
	LOCAL oSysKey AS Syskey
	LOCAL cKeyId:=sKeyType AS STRING
	oSysKey := SysKey{}
	IF oSyskey:used	
		IF oSysKey:Locate({||AllTrim(oSysKey:SYSKEY_ID)==cKeyId} )
			oSysKey:RLOCK()
			oSysKey:Delete()
			oSysKey:Commit()
		ENDIF
		oSyskey:Close()
	ENDIF
	oSysKey:=NULL_OBJECT
	RETURN
	
CLASS TransKey INHERIT SystemKey
METHOD INIT() CLASS TransKey

	SUPER:INIT( "TRANS", 10 )
	
	RETURN SELF
