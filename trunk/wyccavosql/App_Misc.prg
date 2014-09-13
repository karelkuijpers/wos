Function AddSubBal(a_bal as array,ParentNum as int, nCurrentRec as int,aBalIncl ref array) as int
	* Find subdepartments and add to arrays with balance items
	local nSubRec as int
	local lFirst:=true as logic
	// reposition the customer server to the searched record
	nCurrentRec:=AScan(a_bal,{|x|x[2]==ParentNum},nCurrentRec+1)
	IF Empty(nCurrentRec)
		return nCurrentRec
	ENDIF
	AAdd(aBalIncl,a_bal[nCurrentRec,1])
	do WHILE nSubRec > 0 .or. lFirst
		lFirst:=false
		nSubRec:=AddSubBal(a_bal,a_bal[nCurrentRec,1],nSubRec,@aBalIncl)
	ENDDO	
	RETURN nCurrentRec
Function AddSubDep(d_dep as array,ParentNum as int, nCurrentRec as int,aDepIncl ref array) as int
	* Find subdepartments and add to arrays with departments
	local nSubRec as int
	local lFirst:=true as logic
	// reposition the customer server to the searched record
	nCurrentRec:=AScan(d_dep,{|x|x[2]==ParentNum},nCurrentRec+1)
	IF Empty(nCurrentRec)
		return nCurrentRec
	ENDIF
	AAdd(aDepIncl,d_dep[nCurrentRec,1])
	do WHILE nSubRec > 0 .or. lFirst
		lFirst:=false
		nSubRec:=AddSubDep(d_dep,d_dep[nCurrentRec,1],nSubRec,@aDepIncl)
	ENDDO	
	RETURN nCurrentRec
METHOD Close(oEvent)  CLASS DataDialogMine
	// force garbage collection
	self:Destroy()
	RETURN SUPER:Close(oEvent)
METHOD Close(oEvent)  CLASS DataWindowMine
	self:Destroy() 
	if DynInfoFree() <  134217728 // 128MB
		// force garbage collection
		CollectForced()
		IF !_DynCheck()
			(ErrorBox{,"memory error:"+Str(DynCheckError())+" in window:"+self:Caption}):show()
		ENDIF
	endif
	RETURN SUPER:Close(oEvent)

CLASS DBServerExtra INHERIT DBSERVER
	EXPORT lRecreateIndex as LOGIC  // In case of restructuring of the database recreation of the indexes is needed 
	protect aSelRelation:={} as array  // list of relations: {ptr in aRelationChildren} 
	protect lRetry as logic 
	
	declare method CreateDbf
method appendSDF(oMyFileSpec,cSource, aoDFFieldID, cForCondition, cbWhileCondition, nRecords) CLASS DBServerExtra
local aStruct:=self:DBStruct as array , cBuffer as string , i,off,totlen as int
local ptrHandle as MyFile
  	
// ptrHandle := FOpen2(oMyFileSpec:FullPath,FO_READ + FO_SHARED)
ptrHandle:=MyFile{oMyFileSpec}
IF FError() >0
	(ErrorBox{,"Could not open file "+alltrim(oMyFileSpec:Fullpath)+":"+DOSErrString(FError())}):show()
	RETURN FALSE
ENDIF
cBuffer:=ptrHandle:FReadLine()
IF Empty(cBuffer)
	(ErrorBox{,"Could not read file: "+oMyFileSpec:Fullpath+"; Error:"+DosErrString(FError())}):Show()
	RETURN FALSE
ENDIF
totlen:=asum(aStruct,,,DBS_LEN)
do while !Empty(cBuffer)  
	if Len(cBuffer)>0
		off:=1
		self:Append()
		for i:=1 to Len(aStruct)
			self:FIELDPUT(i,SubStr(cBuffer,off,aStruct[ i,DBS_LEN]) )
			off+=aStruct[ i,DBS_LEN]
		next
	endif
	cBuffer:=ptrHandle:FReadLine()
enddo
ptrHandle:Close() 
return true
METHOD CreateDbf(oFileSp as FILESPEC,xDriver:='' as STRING) as LOGIC CLASS DBServerExtra
* Create a Dbf-file during pre-init dbserver when dbf-file not yet exists
    LOCAL aFieldDesc  as ARRAY
    LOCAL oMyFileSpec   as FILESPEC, oDBFileSpec as DBFileSpec
	LOCAL aStruct as ARRAY
    LOCAL i,nFields   as int
    LOCAL lSuccess := true as LOGIC
    LOCAL cFileName as STRING
    LOCAL toSym as SYMBOL

    oMyFileSpec      := oFileSp
    cFilename:=oFileSp:FileName
	* Determine structure of required database:
   	nFields := ALen(aFieldDesc := self:FieldDesc)
   	aStruct := {}
   	FOR i:=1 upto nFields
			AAdd(aStruct,{aFieldDesc[i][DBC_NAME],;
			aFieldDesc[i][DBC_FIELDSPEC]:ValType,;
			aFieldDesc[i][DBC_FIELDSPEC]:Length,;
			aFieldDesc[i][DBC_FIELDSPEC]:Decimals})
   	NEXT
	IF Empty(oMyFileSpec:Extension)
   		oMyFileSpec:Extension:=".dbf"
   	ENDIF

    IF !oMyFileSpec:Find()
		// create a DBF/DBV file
		lSuccess	:=	(DbFileSpec{}):Create( oMyFileSpec:Fullpath,aStruct,xDriver,true)
		if !lSuccess 
			LogEvent(self,"Could not create: "+oMyFileSpec:Fullpath,"logerrors")
			(ErrorBox{,"You have no write permission for "+AllTrim(oMyFileSpec:Path)}):Show()
			return false
		endif
    ELSE  && in case of init of program: check structure 
    	if !lInitial
    		return true
    	endif
		* Check if structure has been altered? 
     	lSuccess := DBUSEAREA(true, xDriver, oMyFileSpec:Fullpath,,FALSE,true)
     	IF !lSuccess
			RETURN FALSE    // apparently in exclusive use 
     	else
     		DBCLOSEAREA()
		ENDIF
		oDBFileSpec:=DbFileSpec{oMyFileSpec:Fullpath,xDriver}
		IF .not. Comparr(oDBFileSpec:DBStruct,aStruct)
			*create new structure:
			oMyFileSpec:Filename:="hlpdbfst"
			oMyFileSpec:DELETE() // delete to be save
			lSuccess := (DbFileSpec{}):Create( oMyFileSpec:Fullpath,aStruct,xDriver,true)
	      IF !lSuccess
				RETURN FALSE
			ENDIF
      	lSuccess := DBUSEAREA(true, xDriver, oMyFileSpec:Fullpath,"hlpdbfst",FALSE,FALSE)
	     	IF !lSuccess
				RETURN FALSE
			ENDIF
			* append current dbffile
			DbZap()
			oMyFileSpec:Filename:=cFileName
			toSym:=Alias0Sym()
			lSuccess := self:DbfApp(oMyFileSpec:FullPath,toSym,(DbFileSpec{oMyFileSpec:FullPath,xDriver}):DBStruct,aStruct,xDriver)
	      IF !lSuccess
				RETURN FALSE
			ENDIF
			(toSym)->DBCOMMIT()
			(toSym)->DBCLOSEAREA()
            * Remove old file 
			(DbFileSpec{oMyFileSpec:Fullpath,xDriver}):DELETE()
			DO WHILE oMyFileSpec:Find()
				Tone(30000,1) // wait 1/18 sec
			ENDDO
			* Rename new file
			oMyFileSpec:Filename:="hlpdbfst"
			lSuccess := (DbFileSpec{oMyFileSpec:Fullpath,xDriver}):Rename( cFileName) 
			oMyFileSpec:Extension:=".fpt"
			if oMyFileSpec:Find()            // error in rename
				oMyFileSpec:Rename(cFileName+".fpt")
			endif
			oMyFileSpec:Filename:=cFileName
			oMyFileSpec:Extension:=".dbf"
			* reindex:
*			SELF:oFileSpec:=oMyFileSpec
*			CrIndexes(SELF,,TRUE)
			self:lRecreateIndex:=true
		ENDIF

    ENDIF	
    RETURN lSuccess
METHOD DbfApp(Filename,toSym,FromStruc,ToStruc,xDriver)  CLASS DBServerExtra
	// Append file Filename to current workarea FToSym with conversion of equal named fields
	// FromStruc: DBStruc of Filename
	// ToStruc: DBstruc of workarea
	LOCAL i,j,ToLen,f as int, p as DWORD
	LOCAL cFieldName,cField as STRING
	LOCAL aGetFld:={} as ARRAY // fieldnumbers to get
	LOCAL aSetFld:={} as ARRAY // fieldnumbers to set
	LOCAL aTrans:={} as ARRAY // translate from to set: 0= copy, 1: val, 2: str, 3:stom, 4:mtoc
	LOCAL sTO, sFrom as SYMBOL //workarea alias

	sTO:=toSym	
	// Determine match and conversion
	FOR i=1 to Len(ToStruc)
		cFieldName:=ToStruc[i,DBS_NAME]
		p:=AScan(FromStruc,{|x|x[DBS_NAME]==cFieldName})
		IF p>0
			IF FromStruc[p,DBS_TYPE]=ToStruc[i,DBS_TYPE] .or.  FromStruc[p,DBS_TYPE]="C" .and.ToStruc[i,DBS_TYPE]="M" .or.FromStruc[p,DBS_TYPE]="M" .and.ToStruc[i,DBS_TYPE]="C"
				AAdd(aSetFld,i)
				AAdd(aGetFld,p)
				AAdd(aTrans,0)
	/*		ELSEIF FromStruc[p,DBS_TYPE]="C" .and.ToStruc[i,DBS_TYPE]="M"
				AAdd(aSetFld,i)
				AAdd(aGetFld,p)
				AAdd(aTrans,3)
			ELSEIF FromStruc[p,DBS_TYPE]="M" .and.ToStruc[i,DBS_TYPE]="C"
				AAdd(aSetFld,i)
				AAdd(aGetFld,p)
				AAdd(aTrans,4)  */
			ELSEIF FromStruc[p,DBS_TYPE]="N" .and.ToStruc[i,DBS_TYPE]="C"
				AAdd(aSetFld,i)
				AAdd(aGetFld,p)
				AAdd(aTrans,2)
			ELSEIF FromStruc[p,DBS_TYPE]="C" .and.ToStruc[i,DBS_TYPE]="N"
				AAdd(aSetFld,i)
				AAdd(aGetFld,p)
				AAdd(aTrans,1)
			ENDIF
		ENDIF
	NEXT
	// append file:
	IF DBUSEAREA(true, xDriver, Filename,"From",FALSE,FALSE)
		ToLen:=Len(aSetFld)
		sFrom:=Alias0Sym()
		SELECT(sTO)
		DO WHILE !((sFrom)->EOF())
			(sTO)->DBAPPEND()
			FOR i:=1 to ToLen
				f:=aTrans[i]
				p:=aSetFld[i]
				j:=aGetFld[i]
				DO CASE
					CASE f==0
						(sTO)->FIELDPUT(p,(sFrom)->FIELDGET(j))
					CASE f==1
						(sTO)->FIELDPUT(p,Val((sFrom)->FIELDGET(j)))
					CASE f==2
						IF !Empty((sFrom)->FIELDGET(j))
							(sTO)->FIELDPUT(p,Str((sFrom)->FIELDGET(j),-1))
						ENDIF
				ENDCASE
			NEXT
			(sFrom)->DBSKIP()
		ENDDO
		(sFrom)->DBCLOSEAREA()
	ENDIF

	
RETURN true
METHOD Error(oError,SymMethod) CLASS DBServerExtra
self:lRetry:=	MyError(oError,SymMethod)
	
	RETURN

METHOD INIT(oFileSpec, lSharedMode, lReadOnlyMode , xDriver ) CLASS DBServerExtra
	Default(@xDriver,null_string)
	IF lInitial.or.!Empty(oFileSpec:Path)  // File has to be created:
		IF Empty(oFileSpec:Path)
			oFileSpec:Path := CurPath
		ENDIF
		self:CreateDbf(oFileSpec, xDriver)
	ELSE
		IF Empty(oFileSpec:Path)
			oFileSpec:Path := CurPath
		ENDIF
	ENDIF
SUPER:INIT(oFileSpec, lSharedMode, lReadOnlyMode , xDriver ) 
if !NoErrorMsg .and.!self:Used .and. self:lRetry
	do while !self:Used .and. self:lRetry
		SUPER:INIT(oFileSpec, lSharedMode, lReadOnlyMode , xDriver ) 		
	enddo
endif
RETURN self
METHOD Close(oEvent)  CLASS DialogWinDowExtra
	// force garbage collection
	self:Destroy()
	RETURN SUPER:Close(oEvent)
Function FillMailClient() as array
// return array with possible mail clients
return {{"Windows Mail/ Outlook Express",0},{"Microsoft Outlook",1},{"Mozilla Thunderbird",2},{"Windows Live Mail",3},{"Mapi2Xml",4}}
	Function FindKeyString(aKeyW as array, cValue as string ) as logic  
	// compare if one or more given keywords in aKey is contained in string cValue
	Local i, lK  as int
	local lKeyFound as logic
	  
	lKeyFound:=false
	lK:=Len(aKeyW)
	for i:=1 to lK 
		if AtC(aKeyW[i],cValue)>0
			lKeyFound:=true
		endif
	next    
	if !lKeyFound
		return false
	endif
	return true
	
FUNCTION GenKeyword()
* Soort(3e elemetnt:
* n: NAW
* c: Compleet NAW
* g: gift
* b: Bestemming (=g,d)
* o: Openpost 
* d: department
* 
/*
{"Bank account","%BANKACCOUNT","o"},;
{"Amount due","%AMOUNTDUE","o"},;
{"Date amount due","%DUEDATE","o"},;
{"Identifier amount due","%DUEIDENTIFIER","o"},;
{"Invoice id/KID","%INVOICEID","o"},;
{"Firstname member destination","%FRSTNAMEDESTINATION","g"},;
{"Lastname member destination","%LSTNAMEDESTINATION","g"},;
{"Salutation member destination","%SALUTDESTINATION","g"},;
{"Department name","%DEPRMNTNAME","d"},;

*/

RETURN {;
{"Salutation","%SALUTATION","n"},;
{"Title","%TITLE","n"},;
{"Initials","%INITIALS","n"},;
{"Prefix","%PREFIX","n"},;
{"Lastname","%LASTNAME","n"},;
{"Firstnames","%FIRSTNAME","n"},;
{"Name extension","%NAMEEXTENSION","n"},;
{"Address","%ADDRESS","n"},;
{"Zipcode","%ZIPCODE","n"},;
{"City","%CITYNAME","n"},;
{"Country","%COUNTRY","n"},;
{"Attention","%ATTENTION","n"},;
{"Date last gift","%DATELSTGIFT","g"},;
{"Date gift","%DATEGIFT","g"},;
{"Transaction ID","%TRANSID","g"},;
{"Document ID","%DOCID","b"},;
{"Reference","%REFERENCE","b"},;
{"Amount gift","%AMOUNTGIFT","g"},;
{"Total gift/payments","%TOTALAMOUNT","b"},;
{"Destination gift/ due amounts","%DESTINATION","b"},;
{"Complete name and address (6 lines)","%NAMEADDRESS","c"},; 
{"Report month","%REPORTMONTH","b"},;
{"Page skip","%PAGESKIP","b"}}

FUNCTION MyError(oError as Error,SymMethod as symbol)
LOCAL cMessage as STRING
// 	IF oError:Canretry .and.oError:Subcode==1101
	IF oError:Subcode==1101
		IF !NoErrorMsg .and.oError:Canretry  
			if (TextBox{,oError:SubCodeText,oError:Filename+" in use by another window or user",BUTTONRETRYCANCEL+BOXICONEXCLAMATION}):Show()==BOXREPLYRETRY
				return true
			else
				Break
			endif
		elseif NoErrorMsg
			Return false
		else
			(TextBox{,oError:SubCodeText,oError:Filename+" in use by another window or user",BOXICONEXCLAMATION}):Show()
			Break			
		ENDIF
	ELSE
		cMessage:="Error: "+ErrString(oError:GenCode)
		IF !Empty(oError:Subcode)
			cMessage += DosErrString(oError:Subcode)
		ENDIF
		IF oError:ArgTypeReq <> 0 .and. oError:ArgTypeReq <> oError:ArgType
	        cMessage += ", Variabletype: "+TypeString(oError:ArgType)+ " requested type:" +TypeString(oError:ArgTypeReq)
	    ENDIF
        IF !oError:Operation == ""
			cMessage += ", Operation:"+oError:Operation
		ENDIF
		cMessage += ", Function:"+Symbol2String(oError:FuncSym)+;
        ", Calling function: "+Symbol2String(oError:CallFuncSym)

		IF oError:ArgNum> 0 .and. oError:ArgNum <= ALen(oError:Args)
			cMessage += ", Argument nbr:"+Str(oError:ArgNum)+" ="+AsString(oError:Args[oError:ArgNum])
		ENDIF
        IF !oError:Description == ""
			cMessage += ", error:" + oError:Description
		ENDIF
		IF oError:MethodSelf <> null_object
			cMessage += ", OBJECT: "+AsString(oError:MethodSelf)
		ENDIF
		(ErrorBox{,CMessage}):Show()
	ENDIF
	IF oError:Severity==ES_CATASTROPHIC	
		_Break(oError)
	ENDIF
RETURN FALSE
function SpecialMessage(message_tele as string,Destname:='' as string,cSpecialmessage:='' ref string) as logic 
	// returns special message cSpecialmessage within message_tele from telebank message 
	// returns true if manually processing needed
	local nMsgPos,nEndToEnd,nSpace as int 
	local cSpecMessage as string
	local lSpecmessage,lManually as logic
	local aNospecmess:={'donatie','steun','bijdr','maand','mnd','kw','algeme','werk','onderh','comit','komit','com.','onderst','wycliff','betalingskenm',;
	'support','gave','period','spons','fam','overb','eur','behoev','hgr','woord','nodig','vriend','zegen','transactiedatum'}  as array
	local aSpecmess:={'pensioen','lijfrente','nalaten','extra','jubil','collecte','kollekte','opbr','cadeau','kado','contant','eenmalig','project'} as array 
	// determine extra messsage in description of transaction: 
	nMsgPos:=At('%%',message_tele)
	nMsgPos:=iif(nMsgPos>0,nMsgPos+2,1)
// 	if nMsgPos>0 
		cSpecMessage:=AllTrim(StrTran(StrTran(Lower(SubStr(message_tele,nMsgPos)),'giften'),'gift'))
		if (nEndToEnd:=AtC('endtoend:',cSpecMessage))>0
			nSpace:=At3(Space(1),cSpecMessage,nEndToEnd+9)
			if nSpace=0
				nSpace:=Len(cSpecMessage)
			endif
			cSpecMessage:=Stuff(cSpecMessage,nEndToEnd,nSpace+1-nEndToEnd,'') 
		endif
		if !Empty(cSpecMessage) 
			lSpecmessage:=false 
			AEval(aSpecmess,{|x|lSpecmessage:=iif(AtC(x,cSpecMessage)>0,true,lSpecmessage)})
			if !lSpecmessage
				lSpecmessage:=true
				if !Empty(Destname)
					if AtC(Destname,SubStr(message_tele,nMsgPos))>0      // skip with name of destination
						lSpecmessage:=false 
					endif
				endif
				if lSpecmessage
					AEval(aNospecmess,{|x|lSpecmessage:=iif(AtC(x,cSpecMessage)>0,false,lSpecmessage)})
				endif
				if lSpecmessage
					// check month name in message:
					AEval(Maand,{|x|lSpecmessage:=iif(AtC(SubStr(x,1,4),cSpecMessage)>0,false,lSpecmessage)})    // skip with month name
				endif
			else 
				lManually:=true
			endif
		endif
// 	endif
	if lSpecmessage
		cSpecialmessage:=cSpecMessage
	else
		cSpecialmessage:=null_string
	endif
	return lManually
function SQLIncExpFd() as string
// compose sql code for determining type of account of member department: of department d, account a:
	return "upper(if(d.netasset=a.accid,'F',if(d.incomeacc=a.accid,'I',if(d.expenseacc=a.accid,'E',''))))"
	
Function Title(nTit as int) as string 
	// Return Title of a person:
	LOCAL nPtr as int
	if nTit>0
		nPtr:=AScan(pers_titles,{|x|x[2]==nTit})
		if nPtr >0 
			return pers_titles[nPtr,1]
		endif
	endif
	return null_string
function UnionTrans(cStatement as string) as string
	// combine select statemenst on transaction with unions on historic trnsaction tables
	* 
	* cStatement should be in terms of Transaction table as t  
	* date conditions should be specified as: t.dat>='yyy-mm-dd' or t.dat<='yyy-mm-dd' or t.dat='yyyy-mm-dd'
	*
	Local nDat1, nDat2,i as int
	Local BegDat, EndDat, Maxdat as date
	local cDat, cCompStmnt as String
	*/  

	// determine required dates in cStatement: 
	cStatement:=Lower(cStatement) 
	if At("transaction",cStatement)=0
		return cStatement
	endif
	// nWhere:=At("where",cStatement) 

	// if nWhere>0
	cDat:=GetDateFormat()
	SetDateFormat("YYYY-MM-DD")
	StrTran(StrTran(StrTran(cStatement,'t.dat <','t.dat<'),'t.dat >','t.dat>'),'t.dat =','t.dat=')    // remove spaces
	nDat1:=At3("t.dat=",cStatement,5)
	if nDat1>0
		BegDat:=CToD(SubStr(cStatement,nDat1+7,10))
		EndDat:=BegDat	
	else
		nDat1:=At3("t.dat>=",cStatement,5)
		if nDat1>0
			BegDat:=CToD(SubStr(cStatement,nDat1+8,10))
		endif	
		nDat2:=At3("t.dat<=",cStatement,5) 
		if nDat2>0 
			EndDat:=CToD(SubStr(cStatement,nDat2+8,10))	
		endif
	endif
	SetDateFormat(cDat)
	
	// endif	
	Maxdat:=Today()+60
	if Empty(EndDat)
		EndDat:=Maxdat
	endif

// 	if Empty(BegDat) .and. EndDat>=LstYearClosed .or.BegDat>=LstYearClosed    
	if BegDat>=LstYearClosed .or. Empty(GlBalYears)    
		return cStatement
	else
		// compose Statement: 
		// actual period:
		If (Empty(BegDat) .or. BegDat<=Maxdat).and.EndDat>=LstYearClosed
			cCompStmnt:="("+cStatement+")"
		endif
		if Empty(BegDat)
			BegDat:=GlBalYears[Len(GlBalYears),1] // oldest date
		endif
// 		FillBalYears()
		for i:=2 to Len(GlBalYears)
			if BegDat<GlBalYears[i-1,1].and.EndDat>=GlBalYears[i,1]
				cCompStmnt+=iif(Empty(cCompStmnt),""," union ")+"("+StrTran(cStatement,"transaction",GlBalYears[i,2])+")"               
			endif
		next
	endif 
	return cCompStmnt
	
function UnionTrans2(cStatement as string, BegDat:=null_date as date, EndDat:=null_date as date) as string
// combine select statemenst on transaction with unions on historic trnsaction tables
* 
* cStatement should be in terms of Transaction table as t  
*
Local i as int
Local Maxdat as date
local cCompStmnt as String

// determine required dates in cStatement: 
cStatement:=Lower(cStatement) 
if At("transaction",cStatement)=0
	return cStatement
endif


Maxdat:=Today()+60
if Empty(EndDat)
	EndDat:=Maxdat
endif

if Empty(BegDat) .and. EndDat>=LstYearClosed .or.BegDat>=LstYearClosed    
	return cStatement
else
	// compose Statement: 
	// actual period:
	If (Empty(BegDat) .or. BegDat<=Maxdat).and.EndDat>=LstYearClosed
		cCompStmnt:="("+cStatement+")"
	endif
	if Empty(BegDat)
		BegDat:=GlBalYears[Len(GlBalYears),1] // oldest date
	endif
	for i:=2 to Len(GlBalYears)
		if BegDat<GlBalYears[i-1,1].and.EndDat>=GlBalYears[i,1]
			cCompStmnt+=iif(Empty(cCompStmnt),""," union ")+"("+StrTran(cStatement,"transaction",GlBalYears[i,2])+")"               
		endif
	next
endif 
return cCompStmnt
 
Function	UpdatemandateId(mAccNumber	as	string,mcln	as	string,msubid:='' as string) as string
	// Check if mandate based on mAccNumber and mcln already exists and in that case returns new one with sequence number added 
	// parameters:
	// mAccNumber: account number destination of donation
	// mcln: internal id of person who is the giver
	// msubid: in case of existing donation fill it with the subscribid of the corresponding subscription
	//         if you want to force the system to generate a mandate id with a next sequence number: leave it empty
	//
	// return the mandate id
	   
	LOCAL cInvoice as STRING, cStartDate as String
	local aMndt:={} as array 
	local oSel as SqlSelect
	
	cInvoice:='WDD-A-'+mAccNumber+'-P-'+mcln
	// check if already present:
	oSel:=SqlSelect{"select subscribid,invoiceid from subscription where personid="+mcln+;
		' and substr(invoiceid,1,'+Str(Len(cInvoice),-1)+')="'+cInvoice+'"'+iif(Empty(msubid),'',' and subscribid<>'+msubid)+' order by invoiceid desc limit 1',oConn}
	if oSel:RecCount=1
		aMndt:=Split(oSel:invoiceid,'-P-')
		if Len(aMndt)=2
			aMndt:=Split(aMndt[2],'-')
			if Len(aMndt)=1
				cInvoice+='-2'
			else
				cInvoice+='-'+Str(Val(aMndt[2])+1,-1) 
			endif
		else
			cInvoice+='-1'
		ENDIF
	endif
	return cInvoice
