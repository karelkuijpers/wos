STATIC function ImpCZR(aMbrAcc as Array, SamAcc as String, PMCAcc as String, nCnt ref int) as void pascal
	local FromAcc, ToAcc, Description, ExtId, Firma,FromDesc,ToDescr, AsmtCode1:="",AsmtCode2:="AG", cOrigin, cTransnr, docid as string, Amount as float, DATUM as date
	local oImpTr as SQLSelect
	local cStatement as string
	local oStmnt as SQLStatement
	local nImptrid as int 
	ToAcc:=StrZero(CZR->FieldGetSym(#DSU),3,0)+StrZero(CZR->FieldGetSym(#DAU),3,0)
	if AScan(aMbrAcc,{|x|x==ToAcc}) = 0
		return   // skip non member transaction
	endif
	FromAcc:=StrZero(CZR->FieldGetSym(#MDSU),3,0)+StrZero(CZR->FieldGetSym(#MDAU),3,0)
	if FromAcc==SamAcc .or. FromAcc==PMCAcc
		return  // skip assessment and PMC transactions
	endif
	AsmtCode1:=""
	AsmtCode2:="AG"
	if AScanExact(aMbrAcc,FromAcc) >0
		if FromAcc <> ToAcc 
			AsmtCode1:="CH"
			AsmtCode2:="MG"
		endif
	endif

	Amount:=CZR->FieldGetSym(#CASTKA)
	Description:=alltrim(CZR->FieldGetSym(#POPIS))
	Datum:=CZR->FieldGetSym(#DATUM) 
	ExtId:=Str(CZR->FieldGetSym(#ICO),-1)
	Firma:=alltrim(CZR->FieldGetSym(#FIRMA))
	FromDesc:=alltrim(CZR->FieldGetSym(#MD_UCET))
	ToDescr:=AllTrim(CZR->FieldGetSym(#D_UCET))
	docid:=AllTrim(CZR->FieldGetSym(#DOKLAD))
	// Check if transaction already present:
	cOrigin:="WD"+Pad(docid,9)
	cTransnr:=StrZero(CZR->ICO,10,0) 

// Search for two lines (debit and credit) equal to transaction to be imported:
	oImpTr:=SQLSelect{"select imptrid from importtrans where origin='"+cOrigin+"' and transactnr='"+cTransnr+"' and "+; 
	"externid='"+ExtId+"' and transdate='"+SQLdate(DATUM)+"' and descriptn='"+Description+"' and "+;
	"(accountnr='"+FromAcc+"' and debitamnt="+Str(Amount,-1)+" or accountnr='"+ToAcc+"' and creditamnt="+Str(Amount,-1)+")"+;
	" order by imptrid",oConn}
	if oImpTr:RecCount=2				
		return  // skip if allready present
	elseif oImpTr:RecCount>2
		// check if consecutive:
		do while !oImpTr:EOF
			if Empty(nImptrid)
				nImptrid=oImpTr:imptrid
			else
				if oImpTr:imptrid-nImptrid=1
					return // apparently two consecutive lines found
				endif
				nImptrid:=oImpTr:imptrid  // restart searching
			endif
			oImpTr:Skip()			
		enddo
	endif
	// add transaction to imported transactions: 
	cStatement:="insert into importtrans set "+; 
	",docid='"+docid +"'"+;
		",origin='"+cOrigin+"'"+;
		",transactnr='"+cTransnr +"'"+;
		",accountnr='"+FromAcc+"'"+;
		",accname='"+FromDesc+"'"+;
		",debitamnt="+Str(Amount,-1)+;
		",externid='"+ExtId+"'"+; 
	",giver='"+Firma+"'"+;
		",descriptn='"+Description+"'"+;
		",transdate='"+SQLdate(DATUM)+"'"+;
		",assmntcd='"+AsmtCode1+"'"+; 
	",poststatus=1"
	oStmnt:=SQLStatement{cStatement,oConn}
	oStmnt:Execute()
	if oStmnt:NumSuccessfulRows>0
		cStatement:="insert into importtrans set "+; 
		",docid='"+docid +"'"+;
			",origin='"+cOrigin+"'"+;
			",transactnr='"+cTransnr +"'"+;
			",accountnr='"+ToAcc+"'"+;
			",accname='"+ToDescr+"'"+;
			",creditamnt="+Str(Amount,-1)+;
			",externid='"+ExtId+"'"+; 
		",giver='"+Firma+"'"+;
			",descriptn='"+Description+"'"+;
			",transdate='"+SQLdate(DATUM)+"'"+;
			",assmntcd='"+AsmtCode1+"'"+; 
		",poststatus=1"
		oStmnt:=SQLStatement{cStatement,oConn}
		oStmnt:Execute()
		if oStmnt:NumSuccessfulRows>0
			nCnt++
		endif
	endif
	return
CLASS ImportBatch
PROTECT oImpB as SQLSelect
PROTECT oParent AS General_Journal
PROTECT oHM as TempTrans
PROTECT oAcc as SQLSelect
PROTECT cCurBatchNbr,cCurOrigin AS STRING, dCurDate AS DATE
EXPORT lOK AS LOGIC
PROTECT aImportFiles:={} as ARRAY
export mxrate as float
export oLan as Language
protect curimpid as int 
protect lv_imported as int

declare method GetNextBatch,LockBatch,CloseBatch,ImportPMC,ImportBatch,ImportAustria,ImportBatchCZR,SkipBatch 
METHOD Close() CLASS ImportBatch
* Closing of class-occurrence
// SetAnsi(true)   ?????
SQLStatement{"update importtrans set lock_id=0 where transactnr='"+self:cCurBatchNbr+;
"' and origin='"+self:cCurOrigin+"' and transdate='"+SQLdate(self:dCurDate)+"'",oConn}:execute()
RETURN true
METHOD CloseBatch(dummy:=nil as logic) as void pascal CLASS ImportBatch
* Closing of batch as being processes
SQLStatement{"update importtrans set processed=1,lock_id=0 where transactnr='"+self:cCurBatchNbr+;
"' and origin='"+self:cCurOrigin+"' and transdate='"+SQLdate(self:dCurDate)+"'",oConn}:execute()
SQLStatement{"commit",oConn}:execute()
RETURN 
ACCESS Count CLASS ImportBatch
	RETURN SELF:oImpB:Count()
ACCESS EoF CLASS ImportBatch
return (SQLSelect{"select imptrid from importtrans where processed=0 "+;
	+"and (lock_id=0 or lock_id="+MYEMPID+" or lock_time < addtime(now(),'00-20-00'))",oConn}:reccount<1)
METHOD GetImportFiles()  CLASS ImportBatch
LOCAL nf, nlen AS INT
LOCAL cFileName AS STRING
LOCAL nImportDate AS STRING, dBatchDate AS DATE
LOCAL aPMIS, aTxt AS ARRAY
SetPath(CurPath)
SetDefault(CurPath)
aImportFiles:=Directory(CurPath+"\*.csv")
aTxt:=Directory(CurPath+"\*.txt")
IF Len(aTxt)>0
	nlen:=Len(aImportFiles)
	ASize(aImportFiles,nlen+Len(aTxt))
	ACopy(aTxt,aImportFiles,,,nlen+1)
ENDIF
FOR nf:=1 TO Len(aImportFiles)
	cFileName:=Upper(aImportFiles[nf,F_NAME]) 
	IF Len(cFileName)>=13 .and.!Upper(SubStr(cFileName,1,13))="EXPORTPERSONS" .and.!Upper(SubStr(cFileName,1,14))="EXPORT PERSONS"
		nImportDate:=SubStr(cFileName,Len(cFileName)-11,8)
		IF IsDigit(nImportDate)
			dBatchDate:=SToD(nImportDate)
			IF !dBatchDate==NULL_DATE
				IF !(dBatchDate<Today()-365 .or. dBatchdate>Today()+31)
					if self:ImportBatch(FileSpec{cFileName},dBatchDate,PadR(cFileName,11),true)   // test if correct fileformat
						loop
					endif
				ENDIF
			ENDIF
		elseif cFileName="AUSTRIADONATIONS"
			if self:ImportAustria(FileSpec{cFileName},dBatchDate,PadR(cFileName,11),true)   // test if correct fileformat
				loop
			endif		
		ENDIF
	ENDIF
		
	ADel(aImportFiles,nf)
	ASize(aImportFiles,Len(aImportFiles)-1)
	nf--
NEXT
// Import also import files from Czech WinDuo:
aTxt:=Directory(CurPath+"\DENIK*.dbf")
IF Len(aTxt)>0
	nlen:=Len(aImportFiles)
	ASize(aImportFiles,nlen+Len(aTxt))
	ACopy(aTxt,aImportFiles,,,nlen+1)
ENDIF

// Import also xml-files from PMIS
aPMIS:=Directory(CurPath+"\"+sEntity+"_*.xml")
FOR nf:=1 TO Len(aPMIS)
	cFileName:=aPMIS[nf,F_NAME]
	IF Len(cFileName)>=19
		nImportDate:=SubStr(cFileName,5,8)
		IF IsDigit(nImportDate)
			dBatchDate:=SToD(nImportDate)
			IF !dBatchDate==NULL_DATE
				IF !(dBatchDate<Today()-365 .or. dBatchdate>Today()+31)
					LOOP
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	ADel(aPMIS,nf)
	ASize(aPMIS,Len(aPMIS)-1)
	nf--
NEXT
IF Len(aPMIS)>0
	nlen:=Len(aImportFiles)
	ASize(aImportFiles,nlen+Len(aPMIS))
	ACopy(aPMIS,aImportFiles,,,nlen+1)
ENDIF
IF Len(SELF:aImportFiles)>0
	RETURN TRUE
ELSE
	RETURN FALSE
ENDIF
METHOD GetNextBatch(dummy:=nil as logic) as logic CLASS ImportBatch
	* Give next import batch with transaction from ImportTrans
	LOCAL OrigBst, CurBatchNbr, cGiverName AS STRING
	LOCAL CurDate AS DATE, CurOrigin AS STRING
	LOCAL cOms, cExId as STRING
	local MultiCur:=false as logic 
	local nPostStatus as int 
	local oImpB,oImpTr1,oImpTr2 as SQLSelect
	local oLockSt as SQLStatement 

	SQLStatement{"start transaction",oConn}:execute() 
	oImpTr1:=SQLSelect{"select transactnr,origin from importtrans "+;
	"where processed=0 "+;
	+"and (lock_id=0 or lock_id="+MYEMPID+" or lock_time < addtime(now(),'00-20-00'))"+;
	iif(Empty(self:curimpid),''," and imptrid>"+Str(self:curimpid,-1))+;
	" order by imptrid limit 1 for update",oConn}
	if oImpTr1:reccount<1
		lOK:=False
		return false
	endif
	CurBatchNbr:=oImpTr1:transactnr
	CurOrigin:=oImpTr1:Origin
	
	//lock rest of same transaction:
	oImpTr2:=SQLSelect{"select imptrid from importtrans "+;
	"where transactnr='"+CurBatchNbr+"' and origin='"+CurOrigin+"' order by imptrid for update",oConn}
	// software lock importrans rows:
	oLockSt:=SQLStatement{"update importtrans set lock_id="+MYEMPID+",lock_time=Now() where transactnr='"+CurBatchNbr+"' and origin='"+CurOrigin+"'",oConn}
	oLockSt:execute()		
	if oLockSt:NumSuccessfulRows < 1
		SQLStatement{"rollback",oConn}:execute()
		loop
	else
		SQLStatement{"commit",oConn}:execute()
	endif
	oImpB:=SQLSelect{"select a.description as accountname,a.accid,a.currency as acccurrency,a.multcurr,a.accnumber,b.category as type,m.co,m.persid as persid,"+SQLAccType()+" as accounttype,i.*"+;
	" from importtrans i left join (balanceitem as b,account as a left join member m on (m.accid=a.accid)) on (i.accountnr<>'' and a.accnumber=i.accountnr and b.balitemid=a.balitemid)"+;
	"where i.transactnr='"+CurBatchNbr+"' and i.origin='"+CurOrigin+"' order by imptrid",oConn}
	if oImpB:reccount<1
	   LogEvent(,oImpB:SQLString+"; error:"+oImpB:status:Description,"LogErrors")
	   lOK:=false
	  	return false
	endif
	lOK:=true
	CurDate:=oImpB:transdate
	OrigBst:=oImpB:docid
   nPostStatus:=oImpB:POSTSTATUS
	IF !self:oHM:Used
		RETURN FALSE
	ENDIF
	* Fill rows of TempTrans with transaction:
	oParent:Reset()
	self:oHM:SuspendNotification()
	DO WHILE !oImpB:EoF
		self:oHM:append()
		self:oHM:descriptn := oImpB:descriptn
		self:oHM:AccNumber:=Space(11)
		self:oHM:accdesc:=oImpB:accname
		self:oHM:accid:=Space(11)
     	self:oHM:kind := " "
      self:oHM:Gc := ""
		self:oHM:currency := iif(Empty(oImpB:currency),sCurr,oImpB:currency)
		MultiCur:=false
		IF !Empty(oImpB:accountnr)
			self:oHM:AccNumber := LTrimZero(oImpB:accountnr)
			IF !Empty(oImpB:AccNumber)
				self:oHM:accid := Str(oImpB:accid,-1)
				self:oHM:accdesc:=oImpB:accountname
				self:oHM:kind:=oImpB:accounttype
				if Empty(oImpB:Currency).and.!Empty(oImpB:AccCurrency) 
					self:oHM:CURRENCY:=oImpB:AccCurrency
				endif 
				MultiCur:=iif(oImpB:MULTCURR=1,true,false)
			ELSE
				lOK:=FALSE
			ENDIF
		ELSE
			self:lOK:=FALSE
		ENDIF
		self:oHM:deb := oImpB:debitamnt
		self:oHM:cre := oImpB:creditamnt
		self:oHM:debforgn := iif(self:oHM:CURRENCY==sCurr,oImpB:debitamnt,oImpB:debforgn)
		self:oHM:creforgn := iif(self:oHM:CURRENCY==sCurr,oImpB:creditamnt,oImpB:creforgn)
		self:oHM:BFM:= " "
		self:oHM:FROMRPP:=iif(oImpB:FROMRPP=1,true,false)
		self:oHM:lFromRPP:=iif(oImpB:FROMRPP=1,true,false)
		self:oHM:OPP:=oImpB:Origin
		self:oHM:PPDEST:= oImpB:PPDEST 
		self:oHM:REFERENCE:=oImpB:REFERENCE 
		self:oHM:POSTSTATUS:=oImpB:POSTSTATUS

		self:oHM:Gc:=oImpB:assmntcd
		IF !Empty(oImpB:GIVER)
			cGiverName:=AllTrim(oImpB:GIVER)
			if cGiverName==","
				cGiverName:=""
			endif
		ENDIF
		IF !Empty(oImpB:EXTERNID)
			// Search person with external id:
			cExId:=oImpB:EXTERNID
		endif
		* Add TO mirror:
		AAdd(self:oHM:aMirror,{self:oHM:accid,self:oHM:deb,self:oHM:cre,self:oHM:Gc,self:oHM:kind,self:oHM:RecNo,,self:oHM:AccNumber,'','',self:oHM:CURRENCY,MultiCur,self:oHM:debforgn,self:oHM:creforgn,self:oHM:REFERENCE,self:oHM:descriptn,oImpB:persid,oImpB:TYPE})
		cOms:=oImpB:descriptn 
		self:curimpid:=oImpB:imptrid 
		oImpB:Skip()
	ENDDO
	* Save current Id of Batch:
	self:cCurBatchNbr:=CurBatchNbr
	self:cCurOrigin:=CurOrigin
	self:dCurDate:=CurDate
	self:oHM:Commit()
*	self:oHM:ResetNotification()
	oParent:FillBatch(OrigBst,CurDate,cGiverName,cOms, cExId, nPostStatus)
	self:oHM:ResetNotification()
	self:oHM:GoTop()
	self:oHM:Skip()
RETURN TRUE
METHOD Import() CLASS ImportBatch
	* Import of batches of  transaction data into ImportTrans.dbf
	LOCAL oBF AS FileSpec
	LOCAL nf,lv_aant_toe:=0,lv_imported_tot:=0,  lv_aant_vrw:=0 as int
	LOCAL cFileName, cOrigin AS STRING
	LOCAL nImportDate AS STRING, dBatchDate AS DATE
	LOCAL oWarn as warningbox
	local oStmnt as SQLStatement
	Local oLock as SQLSelect
	local aFiles:={} as array // files to be deleted
	// force only one person is importing: 
	SQLStatement{"start transaction",oConn}:Execute()
	oLock:=SQLSelect{"select importfile from ImportLock where importfile='telelock' for update",oConn}

	self:GetImportFiles() 
	FOR nf:=1 to Len(aImportFiles)
		cFileName:=aImportFiles[nf,F_NAME]
		oBF := FileSpec{cFileName}
		IF Upper(oBF:Extension)==".CSV" .or. Upper(oBF:Extension)==".TXT"
			// import file in csv-format:
			IF SubStr(cFilename,1,3)==sEntity
				oWarn := WarningBox{,self:oLan:WGet("Import from file"),;
					self:oLan:WGet('Do you really want to import from file')+' '+AllTrim(cFileName)+'?'}
				oWarn:Type := BOXICONQUESTIONMARK + BUTTONYESNO
				oWarn:Beep:=TRUE
				IF (oWarn:Show() = BOXREPLYNO)
					LOOP
				ENDIF
			ENDIF
			cOrigin:=PadR(cFileName,11)
			if Upper(cOrigin)=="AUSTRIADONA" 
				if self:ImportAustria(oBF,dBatchDate,cOrigin)
					++lv_aant_toe
					AAdd(aFiles,oBF)
				else
					SQLStatement{"rollback",oConn}:Execute()
					return
				ENDIF
			else
				if self:ImportBatch(oBF,dBatchDate,cOrigin)
					++lv_aant_toe
					AAdd(aFiles,oBF)
				else
					SQLStatement{"rollback",oConn}:Execute()
					return
				ENDIF
			endif 
		ELSEIF Upper(oBF:Extension)==".XML"
			// import file in PMIS-XML-format:
			if self:ImportPMC(oBF,dBatchDate)
				++lv_aant_toe
				AAdd(aFiles,oBF)
			else
				SQLStatement{"rollback",oConn}:Execute()
				return
			ENDIF
		ELSEIF Upper(oBF:Extension)==".DBF"
			// import file in WinDUO Denik-export-format:
			if self:ImportBatchCZR(oBF,dBatchDate) 
				++lv_aant_toe
				AAdd(aFiles,oBF)
			else
				SQLStatement{"rollback",oConn}:Execute()
				return
			ENDIF
		ENDIF
	NEXT
	IF lv_aant_toe>0
		* Clear old batches: 
		oStmnt:=SQLStatement{"delete from importtrans where processed='X' and transdate<'"+SQLdate(Today()-300)+"'",oConn}
		oStmnt:Execute()
		// delete files:
		for nf:=1 to Len(aFiles)
			IF	!aFiles[nf]:DELETE()
				if	!FErase(aFiles[nf]:FullPath)
					(WarningBox{,self:oLan:WGet("Import	of	batch	transactions"),self:oLan:WGet("Could not delete	file")+"	"+aFiles[nf]:FullPath}):Show()
				endif
			ENDIF
		next
	endif
	SQLStatement{"commit",oConn}:Execute()  // release lock
	IF lv_aant_toe>0
		(InfoBox{,self:oLan:WGet("Import of batches"),AllTrim(Str(lv_aant_toe,4))+" "+self:oLan:WGet("batch file")+if(lv_aant_toe>1,"s","")+" "+self:oLan:WGet("with")+" "+Str(lv_imported,-1)+" "+self:oLan:WGet("transactions imported")}):Show()
	ENDIF


	RETURN
METHOD ImportAustria(oFr as FileSpec,dBatchDate as date,cOrigin as string,Testformat:=false as logic) as logic CLASS ImportBatch
	* Import of one batchfile with  transaction data into ImportTrans.dbf 
	* Testformat: only test if this a file to be imported
	LOCAL cSep as STRING
	LOCAL cDelim:=Listseparator as STRING
	LOCAL lv_loaded as LOGIC
	LOCAL CurTransNbr:="" as STRING
	LOCAL ptrHandle as MyFile
	LOCAL cBuffer as STRING
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate, ptDoc, ptTrans, ptDesc, ptCre, ptAccName, ptPers as int
	LOCAL aPt:={} as ARRAY, maxPt , linenr:=0, nCnt:=0 as int
	LOCAL cBank as string 
	local aDat as array, impDat as date, cAcc,cAccNumber,cAssmnt, cdat as string , lUnique as logic 
	local oStmnt as SQLStatement
	local oSel,oImpTr,oAcc as SQLSelect
	local cStatement as string
//    Default(@Testformat,False)
   
cSep:=CHR(SetDecimalSep())
ptrHandle:=MyFile{oFr}
IF FError() >0
	(ErrorBox{,self:oLan:WGet("Could not open file")+": "+oFr:FullPath+"; "+self:oLan:WGet("Error")+":"+DosErrString(FError())}):show()
	RETURN FALSE
ENDIF
cBuffer:=ptrHandle:FReadLine()
IF Empty(cBuffer)
	(ErrorBox{,self:oLan:WGet("Could not read file")+": "+oFr:FullPath+"; "+self:oLan:WGet("Error")+":"+DosErrString(FError())}):show()
	RETURN FALSE
ENDIF
if !GetDelimiter(cBuffer,@aStruct,@cDelim,8,10)
	(ErrorBox{,self:oLan:WGet("Wrong fileformat of importfile")+": "+oFr:FullPath}):show() 
	ptrHandle:Close()
	RETURN FALSE 
endif

ptDate:=AScan(aStruct,{|x| "SPENDENDATUM" $ x})
ptDoc:=AScan(aStruct,{|x| "LISTNAME" $ x})
ptTrans:=AScan(aStruct,{|x| "SPNR" $ x})
ptDesc:=AScan(aStruct,{|x| "SPDTEXT" $ x})
ptCre:=AScan(aStruct,{|x| "BETRAG" $ x})
ptAccName:=AScan(aStruct,{|x| "SPDKTONAME" $ x})
ptPers:=AScan(aStruct,{|x| "SPENDER" $ x})
IF ptDate==0 .or. ptTrans==0 .or. ptAccName==0 .or. ptDesc==0 .or. ptCre==0 .or.ptPers==0.or.ptDoc==0
	(ErrorBox{,self:oLan:WGet("Wrong fileformat of importfile")+": "+oFr:FullPath}):show() 
	ptrHandle:Close()
	RETURN FALSE 
elseif Testformat
	ptrHandle:Close()
	return true
ENDIF

osel:=SQLSelect{"select a.accnumber from bankAccount b,account a where a.accid=b.accid",oConn}
if oSel:RecCount<1
	(ErrorBox{,self:oLan:WGet("Specify first a bank account with its general ledger account")}):show() 
	ptrHandle:Close()
	return false
else
	cBank:=oSel:ACCNUMBER
endif

oAcc:SetOrder("REKOMS")
oAcc:SetFilter("GIFTALWD=TRUE") 
// determine max fieldnumber:
aPt:={ptDate,ptTrans,ptAccName,ptDesc,ptCre,ptPers,ptDoc}
ASort(aPt)
maxPt=aPt[Len(aPt)] 
cBuffer:=ptrHandle:FReadLine()
aFields:=Split(cBuffer,cDelim)
linenr=1 
oImpTr:=SQLSelect{"select imptrid from ImportTrans where origin='"+cOrigin+"' and transactnr=?",oConn} 
DO WHILE Len(AFields)>1
	linenr++  

	IF !AFields[ptTrans]==CurTransNbr // new transaction?
		CurTransNbr:=AFields[ptTrans]
		* Check if batchtransaction not yet loaded: 
		oImpTr:execute(AllTrim(AFields[ptTrans ]))
		if oImpTr:RecCount>0
			lv_loaded:=FALSE
		ELSE
			lv_loaded:=true 
		ENDIF
	ENDIF 
	cStatement:=""
	impDat:=null_date
	IF !lv_loaded
		if ptDate<= Len(AFields) 
			cdat:=AllTrim(AFields[ptDate]) 
			if Len(cdat)=10
				impDat:=SToD(SubStr(cdat,7,4)+SubStr(cdat,4,2)+SubStr(cdat,1,2))
			else
				impDat:=CToD(cdat)
			endif
			if impDat==null_date
				(ErrorBox{,"Wrong date format in "+oFr:FullPath+"; should be: dd.mm.yyyy"}):show() 
				ptrHandle:Close()
				return false
			endif
		endif
		if ptAccName>0 .and. ptAccName<=Len(AFields)
			cAcc:=Split(AllTrim(AFields[ptAccName])," ")[1]
			oAcc:=SQLSelect{"select accnumber,accid from account where "+iif(IsDigit(cAcc)," accnumber like '"+LTrimZero(cAcc)+"'%","description like '"+cAcc+"%'"),oConn}
			if oAcc:RecCount=1
				cAccNumber:=oAcc:ACCNUMBER
			elseif oAcc:RecCount>0  
				cAcc:=AllTrim(AFields[ptAccName])
				oAcc:=SQLSelect{"select accnumber,accid from account where "+iif(IsDigit(cAcc)," accnumber like '"+LTrimZero(cAcc)+"'%","description like '"+cAcc+"%'"),oConn}
				if oAcc:RecCount=1
					cAccNumber:=oAcc:ACCNUMBER 
				endif
			else
				cAccNumber:=""
			endif
			cAssmnt:=""
			if !Empty(cAccNumber)
				if SQLSelect{"select mbrid from member where accid="+oAcc:accid,oConn}:reccount>0
					cAssmnt:="AG"
				endif
			endif
		ENDIF
		cStatement:=iif(Empty(impDat),"",",transdate='"+SQLdate(impDat) +"'")+;
		",docid='Import'"+; 
		iif(ptTrans<= Len(AFields),",transactnr='"+AFields[ptTrans]+"'","")+;
		",descriptn='"+self:oLan:RGet("Gift") +iif(ptDesc<= Len(AFields)," "+AFields[ptDesc],"")+"'"+;
		iif(ptDoc<= Len(AFields),",giver='"+AFields[ptDoc]+"'","")+;
		iif(ptCre<= Len(AFields),",creditamnt="+StrTran(AFields[ptCre],"."),"")+;
		iif(ptAccName>0 .and. ptAccName<=Len(AFields),",accname='"+AFields[ptAccName]+"'"+iif(Empty(cAccNumber),"",",accountnr='"+cAccNumber+"'")+iif(Empty(cAssmnt),"",",assmntcd='AG'"),"")+;
		iif(ptPers>0 .and. ptPers<=Len(AFields),",externid='"+AFields[ptPers]+"'","")+;
		",origin='"+cOrigin+"'"
		oStmnt:=SQLStatement{"insert into importtrans set "+SubStr(cStatement,2),oConn}
		oStmnt:execute() 
		if oStmnt:NumSuccessfulRows<1
			LogEvent(,"error:"+oStmnt:SQLString,"LogErrors")
			ErrorBox{,self:oLan:WGet('Transaction could not be stored')+"("+AFields[ptTrans]+"):"+oStmnt:status:Description}:show()
			return false
		endif
		cStatement:=iif(Empty(impDat),"",",transdate='"+SQLdate(impDat) +"'")+;
		",docid='Import'"+; 
		iif(ptTrans<= Len(AFields),",transactnr='"+AFields[ptTrans]+"'","")+;
		",descriptn='"+self:oLan:RGet("Gift") +iif(ptDesc<= Len(AFields)," "+AFields[ptDesc],"")+"'"+;
		iif(ptDoc<= Len(AFields),",giver='"+AFields[ptDoc]+"'","")+;
		iif(ptCre<= Len(AFields),",debitamnt="+StrTran(AFields[ptCre],"."),"")+;
		",accountnr='"+cBank+"'"+;
		iif(ptPers>0 .and. ptPers<=Len(AFields),",externid='"+AFields[ptPers]+"'","")+;
		",origin='"+cOrigin+"'"
		oStmnt:=SQLStatement{"insert into importtrans set "+SubStr(cStatement,2),oConn}
		oStmnt:execute() 
		if oStmnt:NumSuccessfulRows<1
			LogEvent(,"error:"+oStmnt:SQLString,"LogErrors")
			ErrorBox{,self:oLan:WGet('Transaction could not be stored')+"("+AFields[ptTrans]+"):"+oStmnt:status:Description}:show()
			return false
		endif
		self:lv_imported++		
	ENDIF
	cBuffer:=ptrHandle:FReadLine()
	aFields:=Split(cBuffer,cDelim)
ENDDO
ptrHandle:Close()

RETURN true
METHOD ImportBatch(oFr as FileSpec,dBatchDate as date,cOrigin as string,Testformat:=false as logic) as logic CLASS ImportBatch
	* Import of one batchfile with  transaction data into ImportTrans.dbf 
	* Testformat: only test if this a file to be imported
	LOCAL cSep AS STRING
	LOCAL cDelim:=Listseparator AS STRING
	LOCAL lv_geladen AS LOGIC
	LOCAL CurTransNbr:="" AS STRING
	LOCAL ptrHandle as MyFile
	LOCAL cBuffer as STRING
	LOCAL aStruct:={} AS ARRAY // array with fieldnames
	LOCAL aFields:={} AS ARRAY // array with fieldvalues
	LOCAL ptDate, ptDoc, ptTrans, ptAcc, ptDesc, ptDeb, ptCre, ptDebF, ptCreF,ptCur, ptAss,ptAccName, ptPers,ptPPD, ptRef,ptSeq, ptPost as int
	LOCAL aPt:={} as ARRAY, maxPt , linenr:=0 as int
	local osel as SQLSelect 
	local cStatement as string
	local oStmnt as SQLStatement
	
	cSep:=CHR(SetDecimalSep())
	ptrHandle:=MyFile{oFr}
	IF FError() >0
		(ErrorBox{,"Could not open file: "+oFr:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine()
	IF Empty(cBuffer)
		(ErrorBox{,"Could not read file: "+oFr:FullPath+"; Error:"+DosErrString(FError())}):show()
		ptrHandle:Close()
		RETURN FALSE
	ENDIF
	if !GetDelimiter(cBuffer,@aStruct,@cDelim,8,19)
		ptrHandle:Close()
		RETURN FALSE 
	endif
	ptDate:=AScan(aStruct,{|x| "DATE" $ x})
	ptDoc:=AScan(aStruct,{|x| "DOC" $ x})
	ptTrans:=AScan(aStruct,{|x| "TRANSACT" $ x})
	ptAcc:=AScan(aStruct,{|x| "ACC" $ x})
	ptDesc:=AScan(aStruct,{|x| "DESCR" $ x})
	ptDebF:=AScan(aStruct,{|x| "DEBITF" $ x})
	ptCreF:=AScan(aStruct,{|x| "CREDITF" $ x})
	ptCur:=AScan(aStruct,{|x| "CUR" $ x})
	ptDeb:=AScan(aStruct,{|x| "DEB" $ x})
	ptCre:=AScan(aStruct,{|x| "CRE" $ x})
	ptAss:=AScan(aStruct,{|x| "ASS" $ x})
	ptAccName:=AScan(aStruct,{|x| "ACCNAME" $ x})
	ptPers:=AScan(aStruct,{|x| "GIVER" $ x})
	ptRef:=AScan(aStruct,{|x| "REFERENCE" $ x})
	ptPPD:=AScan(aStruct,{|x| "PPDEST" $ x})
	ptSeq:=AScan(aStruct,{|x| "SEQNR" $ x})
	ptPost:=AScan(aStruct,{|x| "POST" $ x})
	IF ptDate==0 .or. ptTrans==0 .or. ptAcc==0 .or. ptDesc==0 .or. ptDeb==0 .or. ptCre==0 .or. ptAss==0 .or.ptDoc==0
		ptrHandle:Close()
		RETURN FALSE 
	elseif Testformat
		ptrHandle:Close()
		return true
	ENDIF 
	cBuffer:=ptrHandle:FReadLine()
	aFields:=Split(cBuffer,cDelim)
	linenr=1
	DO WHILE Len(aFields)>1
		linenr++  

		IF !aFields[ptTrans]==CurTransNbr // new transaction?
			CurTransNbr:=aFields[ptTrans]
			* Check if batchtransaction not yet loaded:
			if SQLSelect{"select imptrid from importtrans where origin='"+cOrigin+"' and transactnr='"+AllTrim(AFields[ptTrans ])+"'",oConn}:RecCount<1 
				// 			IF !oImpTr:Seek(Pad(cOrigin,11)+AFields[ptTrans ])
				lv_geladen:=FALSE
			ELSE
				lv_geladen:=true 
			ENDIF
		ENDIF
		IF !lv_geladen
			cStatement:=;
				iif(ptDate<= Len(AFields),",transdate='"+SQLdate(SToD(AFields[ptDate]))+"'","")+;
				iif(ptDoc<= Len(AFields),",docid='"+AFields[ptDoc]+"'","")+; 
			iif(ptTrans<= Len(AFields),",transactnr='"+AFields[ptTrans]+"'","")+;
				",accountnr='"+AFields[ptAcc]+"'"+;
				iif(ptDesc<= Len(AFields),",descriptn='"+AddSlashes(AFields[ptDesc])+"'","") +;
				iif(ptDeb<= Len(AFields),",debitamnt="+AFields[ptDeb],"")+;
				iif(ptCre<= Len(AFields),",creditamnt="+AFields[ptCre],"")+; 
			",debforgn="+iif(ptDebF>0 .and.ptDebF<= Len(AFields),+AFields[ptDebF],AFields[ptDeb])+;
				",creforgn="+iif( ptCreF>0 .and. ptCreF<= Len(AFields),AFields[ptCre],AFields[ptCre])+;
				",currency='"+iif(ptCur>0 .and.ptCur<= Len(AFields),AFields[ptCur],sCURR)+"'"+;
				iif(ptAss<= Len(AFields),",assmntcd='"+AFields[ptAss]+"'","")+;
				iif(ptAccName>0 .and. ptAccName<=Len(AFields),",accname='"+AFields[ptAccName]+"'","")+;
				iif(ptPers>0 .and. ptPers<=Len(AFields),iif(AllTrim(AFields[ptPers])==",","",",giver='"+AllTrim(AFields[ptPers])+"'"),"")+;
				iif(ptPPD>0 .and. ptPPD<=Len(AFields),",ppdest='"+AFields[ptPPD]+"'","")+;
				iif(ptRef>0 .and. ptRef<=Len(AFields),",reference='"+AddSlashes(AFields[ptRef])+"'","")+;
				iif(ptSeq>0 .and. ptSeq<=Len(AFields)  .and. !IsNil(AFields[ptSeq]),",seqnr="+AFields[ptSeq],"")+;
				",poststatus="+iif(ptPost>0 .and. ptPost<=Len(AFields).and. !IsNil(AFields[ptPost]),AFields[ptPost],"1")+;
				",origin='"+cOrigin+"'" 
			oStmnt:=SQLStatement{"insert into importtrans set "+SubStr(cStatement,2),oConn}
			oStmnt:Execute()
			IF oStmnt:NumSuccessfulRows<1
				LogEvent(,"error: "+oStmnt:SQLString,"LogErrors")
				ErrorBox{,self:oLan:WGet('Transaction could not be stored')+":"+oStmnt:status:Description}:show()
				return false
			endif
			self:lv_imported++
		ENDIF
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()

	RETURN true
method ImportBatchCZR(oFr as FileSpec,dBatchDate as date) as logic CLASS ImportBatch
	* Import of one batch dbf file with  transaction data into ImportTrans.dbf
	LOCAL lv_geladen as LOGIC
	LOCAL oImpTr , oMbr, oAcc,osel as SQLSelect
	LOCAL CurTransNbr:="", SamAcc, PMCAcc as STRING
	LOCAL oImpCZR as DBFILESPEC
	LOCAL cBuffer as STRING
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate, ptDoc, ptTrans, ptAcc, ptDesc, ptDeb, ptCre, ptAss,ptAccName, ptPers as int
	LOCAL aPt:={} as ARRAY, maxPt , linenr:=0 as int
	Local aMbrAcc:={} as array 
	Local i, nCnt:=0 as int, LastDate:=Today()-200 as date 
	Local aMissingFld:={},aNeededFld:={"ICO","POPIS","CASTKA","CASTKAM","DAU","FIRMA","MD_UCET","D_UCET","DOKLAD"} as array
	
	oImpCZR:=DbFileSpec{oFr:FullPath,"DBFCDX"}
	oImpCZR:Path:=CurPath
	oImpTr:=oImpB
	IF oImpCZR:Find() 
		for i:=1 to Len(aNeededFld)
			if AScan(oImpCZR:DbStruct,{|x|x[DBS_NAME]=aNeededFld[i]})=0
				AAdd(aMissingFld,aNeededFld[i])
			endif
		next 
		if !Empty(aMissingFld)
			(ErrorBox{,"The following columns are missing in file "+oImpCZR:FullPath+":"+CRLF+Implode(aMissingFld,", ")}):show()
			return false
		endif 
		
		// import:
		DbSetRestoreWorkarea (true)
		SetAnsi(oImpCZR:IsAnsi)
		IF DBUSEAREA(true,"DBFCDX",oImpCZR:FullPath,"CZR",FALSE,FALSE)
			// determine member accounts:
			oMbr:=SQLSelect{"select a.accnumber from member m, account a where m.accid=a.accid",oConn}
			aeval(oMbr:GetLookupTable(3000,#accnumber,#accnumber),{|x|aadd(aMbrAcc,x[1])})
			if Empty(sam)
				(ErrorBox{self,"No account defined for assessments in system parameters!"}):show()
				CZR->DBCLOSEAREA()
				DbSetRestoreWorkarea (false)
				return false
			endif 
			osel:=SQLSelect{"select accnumber from account where accid=?",oConn}
			osel:Execute(sam) 
			IF osel:RecCount<1
				(errorbox{self:OWNER,self:oLan:WGet('Account for assemments not found')}):Show()
				CZR->DBCLOSEAREA()
				DbSetRestoreWorkarea (false)
				return false
			ENDIF
			SamAcc:=osel:ACCNUMBER
			osel:Execute(SHB)
			IF osel:RecCount<1
				(errorbox{self:OWNER,self:oLan:WGet('Account for sending to PMC not found')}):Show()
				CZR->DBCLOSEAREA()
				DbSetRestoreWorkarea (false)
				return false
			ENDIF
			PMCAcc:=osel:ACCNUMBER

			// Search latest transdate in Imptr: 
			oImpTr:=SQLSelect{"select transdate from importtrans where origin='WD' order by transdate desc limit 1",oConn}
			if oImpTr:RecCount>0
				LastDate:=oImpTr:transdate
			endif				
			Lastdate-=31
			CZR->DbSetFilter({||CZR->DATUM > LastDate})
			CZR->DbGotop()
			CZR->DbEval({|| ImpCZR(aMbrAcc,SamAcc,PMCAcc,@nCnt)})
			CZR->DBCLOSEAREA()
			DbSetRestoreWorkarea (false)
			self:lv_imported+=nCnt

			return true
		endif
	ENDIF
	return true
METHOD ImportPMC(oFr as FileSpec,dBatchDate as date) as logic CLASS ImportBatch
	* Import of one RPPfile with  transaction data from PMC into ImportTrans.dbf
	LOCAL cBuffer AS STRING
	LOCAL ptrHandle
	LOCAL PMISDocument AS XMLDocument
	LOCAL childfound, recordfound AS LOGIC
	LOCAL ChildName AS STRING
	LOCAL amount, USamountAbs, USDAmount, oppAmount as FLOAT
	LOCAL transdescription,description,oppdescr, docid, accnbr,accnbrdest,origin,transtype,housecode,samnbr,shbnbr, reference as STRING
	LOCAL transdate, oppdate,rppdate,cmsdate as date
	LOCAL oAfl AS UpdateHouseHoldID
	LOCAL datelstafl AS DATE
	LOCAL nAnswer, nCnt as int 
	lOCAL cPmisCurrency as string, lUSD as logic 
	local oCurr as CURRENCY 
	local RPP_date as date
	LOCAL oExch as GetExchRate
	Local oInST as Insite, cAccCng,cDescription as string
	Local cExId as string
	local osel as SQLSelect 
	local cStatement as string
	local oStmnt as SQLStatement
	IF Empty(SEntity)
		(ErrorBox{self:OWNER,self:oLan:WGet('First specify PMC Participant Code in System parameter, tab PMC')}):show()
		RETURN false
	ENDIF
	IF Empty(SHB)
		(ErrorBox{self:Owner,self:oLan:WGet('Add first account for Clearance PMC to system data')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF

	ptrHandle:=FOpen(oFr:FullPath)
	IF ptrHandle = F_ERROR
		(ErrorBox{,self:oLan:WGet("Could not open file")+": "+oFr:FullPath+"; "+self:oLan:WGet("Error")+":"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=FReadStr(ptrHandle,4096000)
	cBuffer:=HtmlDecode(cBuffer)
	IF ptrHandle = F_ERROR
		(ErrorBox{,self:oLan:WGet("Could not read file")+": "+oFr:FullPath+"; "+self:oLan:WGet("Error")+":"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF 

	datelstafl:=SQLSelect{"select datlstafl from sysparms",oConn}:DATLSTAFL 
	if datelstafl<Today()  
		/*	oInST:=Insite{}
		cAccCng:=oInST:GetAccountChangeReport(datelstafl) 
		oInST:Close()   */

		oAfl:=UpdateHouseHoldID{}
		if !oAfl:Processaffiliated_person_account_list(cAccCng)
			IF !oAfl:Importaffiliated_person_account_list()
				IF datelstafl<(Today()-31) 
					nAnswer:= (TextBox{,self:oLan:WGet("Import RPP"),;
						self:oLan:WGet('Your last import of the Account Changes Report from Insite is of')+' '+DToC(datelstafl)+'.'+LF+self:oLan:WGet('If you stop now you can first download that report from Insite into folder')+' '+curPath+' '+self:oLan:WGet('before the send to PMC')+CRLF+CRLF+self:oLan:WGet('Do you want to stop now?'),BOXICONQUESTIONMARK + BUTTONYESNO}):show()
					IF nAnswer == BOXREPLYYES 
						FClose(ptrHandle)
						RETURN FALSE
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	IF Empty(sCURR)
		(ErrorBox{,self:oLan:WGet('First specify the currency in System parameters')}):show()
		FClose(ptrHandle)
		RETURN false
	ENDIF

	oCurr:=Currency{self:oLan:WGet("Importing RPP")} 
	RPP_date:=SToD(SubStr(oFr:FileName,5,8))
	mxrate:=SQLSelect{"select exchrate from sysparms",oConn}:EXCHRATE
	mxrate:=oCurr:GetROE("USD", RPP_date,true) 
	if oCurr:lStopped
		FClose(ptrHandle)
		return false
	endif

	// Proces records:
	PMISDocument:=XMLDocument{cBuffer}
	// first check intehrity of document:
	If !PMISDocument:GetElement("RPP_Records")
		(ErrorBox{,self:oLan:WGet('No correct RPP file')+' '+AllTrim(oFr:FileName)}):show()
		FClose(ptrHandle)
		RETURN false
	ENDIF
	
	recordfound:= PMISDocument:GetElement("Record")
	osel:=SQLSelect{"select accnumber,currency from account where accid=?",oConn}
	osel:Execute(sam) 
	IF osel:RecCount<1
		(errorbox{self:OWNER,self:oLan:WGet('Account for assemments not found')}):Show()
		FClose(ptrHandle)
		return false
	ENDIF
	samnbr:=osel:ACCNUMBER
	osel:Execute(SHB)
	IF osel:RecCount<1
		(errorbox{self:OWNER,self:oLan:WGet('Account for sending to PMC not found')}):Show()
		FClose(ptrHandle)
		return false
	ENDIF
	shbnbr:=osel:ACCNUMBER
	cPmisCurrency:=osel:CURRENCY
	if cPmisCurrency=="USD"
		lUSD:=true
	endif
	DO WHILE recordfound
		childfound:=PMISDocument:GetFirstChild()
		docid:=""
		origin:=""
		transdescription:=""
		description:=""
		amount:=0.00
		USamountAbs:=0.00 
		USDAmount:=0.00
		oppAmount:=0.00
		transdate:=Today()
		oppdate:=NULL_DATE
		rppdate:=NULL_DATE
		cmsdate:=NULL_DATE
		accnbr:=""
		oppdescr:=""
		housecode:="" 
		REFERENCE:=""
		transtype:="GT"
		DO WHILE childfound
			ChildName:=PMISDocument:ChildName
			DO CASE
			CASE ChildName=="RPP_Transaction_Amount"
				amount:=Val(PMISDocument:ChildContent)
			CASE ChildName=="OPP_Transaction_Ref"
				description+=PMISDocument:ChildContent+" "
				reference:= PMISDocument:ChildContent
			CASE ChildName="Transaction_Description"
				transdescription:=PMISDocument:ChildContent
			CASE ChildName=="PMIS_Received_Date_Time"
				rppdate:=SToD(StrTran(SubStr(PMISDocument:ChildContent,1,10),"-"))
			CASE ChildName=="OPP_Transaction_Date"
				oppdate:=SToD(StrTran(SubStr(PMISDocument:ChildContent,1,10),"-"))
			CASE ChildName=="OPP_Transaction_Amount"
				oppAmount:=AbsFloat(Val(PMISDocument:ChildContent))
			CASE ChildName=="CMS_Processed_Date_Time"
				cmsdate:=SToD(StrTran(SubStr(PMISDocument:ChildContent,1,10),"-"))
			CASE ChildName="Originating_PP_Code"
				origin:=AllTrim(PMISDocument:ChildContent)
			CASE ChildName="General_Transaction_Id"
				docid:=PMISDocument:ChildContent
			CASE ChildName="RPP_Destination_String"
				accnbr:=AllTrim(PMISDocument:ChildContent)
			CASE ChildName="RPP_Household_Code"
				housecode:=PMISDocument:ChildContent
			CASE ChildName="RPP_Trans_Type_Code"
				IF !Empty(PMISDocument:ChildContent)
					transtype:=PMISDocument:ChildContent
				ENDIF
			CASE ChildName="Assessment_Transaction_Id"
				IF Val(PMISDocument:ChildContent)>0
					transtype:="AT"
				ENDIF
			CASE ChildName="USD_Amount"
				USDAmount:=Val(PMISDocument:ChildContent)
				USamountAbs:=AbsFloat(USDAmount)
			ENDCASE
			childfound:=PMISDocument:GetNextChild()			
		ENDDO
		IF !Empty(rppdate)
			transdate:= rppdate
		ELSEIF !Empty(cmsdate)
			transdate:=cmsdate
		ELSEIF !Empty(oppdate)
			transdate:=oppdate
		ENDIF
		// check record allready loaded: 
		if SQLSelect{"select imptrid from importtrans where origin='"+origin+"' and transactnr='"+docid+"'",oConn}:RecCount<1 
			// not yet loaded:
			// first transaction roW 
			// in case of BTA and gift form USA look up donor:
			cExId:=""
			if sEntity == "NTL" .or.sEntity=="BTA" .and.Origin=="USA".and.transtype=="CN"
				cExId:=PadL(Split(transdescription," ")[1],10,"0")
				if Empty(Val(cExId))
					cExId:=""
				endif
			endif
			nCnt++
			if !Empty(mxrate)
				amount:=Round(mxrate*USDAmount,DecAantal)
			endif
			accnbrdest:=""
			IF !Empty(oppAmount).and.oppAmount#USamountAbs.and. oppAmount#amount
				oppdescr:="("+origin+" amount:"+Str(oppAmount,-1)+iif(Empty(oppdate),"",", date:"+DToC(oppdate))+") "
			ELSEIF !Empty(USamountAbs)
				oppdescr:="(USD:"+Str(USamountAbs,-1,2)+iif(Empty(oppdate),"",", "+origin+" date:"+DToC(oppdate))+") "
			ELSEIF !Empty(oppdate)
				oppdescr+="("+origin+" Date:"+DToC(oppdate)+") "
			ENDIF
			oppdescr+=" (Exch rate US $1="+ZeroRTrim(Str(mxrate,-1,8))+' '+sCURR+") "
			cDescription:=StrTran(transdescription+" "+description,"&amp;","&")+oppdescr
			// determine destination account for second line: 
			IF !Empty(accnbr)
				osel:=SQLSelect{"select accnumber from account where accnumber='"+accnbr+"'",oConn}
				IF osel:RecCount>0
					accnbrdest:=osel:ACCNUMBER
				ELSE
					IF transtype="AT"
						accnbrdest:=samnbr
					ENDIF
				endif
			ELSEIF transtype="AT"
				accnbrdest:=samnbr
			ENDIF
			IF !Empty(housecode) .and.Empty(accnbrdest)
				// search corresponding member:
				osel:=SQLSelect{"select a.accnumber from account a,member m where m.householdid='"+housecode+"' and a.accid=m.accid",oConn}
				if osel:RecCount>0 
					accnbrdest:=osel:ACCNUMBER
				ENDIF
			ENDIF

			cStatement:="insert into importtrans set "+;
				"transdate='"+SQLdate(transdate)+"'"+;
				",docid='"+docid+"'"+;
				",transactnr='"+docid +"'"+;
				",accountnr='"+shbnbr+"'"+;
				",assmntcd=''"+;
				",origin='"+origin +"'"+;
				",processed=0"+;
				",fromrpp=1"+; 
			iif(USDAmount<0,",creditamnt=0.00,debitamnt="+str(-amount,-1)+iif(lUSD,",debforgn="+str(-USDAmount,-1),''),;
				",creditamnt="+Str(amount,-1)+",debitamnt=0.00"+iif(lUSD,",creforgn="+Str( USDAmount,-1),''))+;
				iif(lUSD,",currency='USD'","")+;
				",descriptn='"+AddSlashes(cDescription)+"'"+;
				","+iif((transtype="PC" .or. transtype="AT") .and.!Empty(accnbrdest),"POSTSTATUS=2","POSTSTATUS=1")
			oStmnt:=SQLStatement{cStatement,oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				LogEvent(,"error:"+cStatement,"LogErrors")
				ErrorBox{,self:oLan:WGet('Transaction could not be stored')+":"+oStmnt:status:Description}:show()
				return false
			endif
			// second transaction row 

			if Empty(accnbrdest) .and.!Empty(accnbr)
				cDescription+=" "+accnbr				
			endif		
			IF transtype="CN" .or. transtype="CP".or.transtype="MM"
				cDescription:="Gift "+cDescription
			endif 
			cStatement:="insert into importtrans set "+;
				"transdate='"+SQLdate(transdate)+"'"+;
				",docid='"+docid+"'"+;
				",transactnr='"+docid +"'"+;
				",origin='"+origin +"'"+;
				iif(!Empty(accnbrdest),",accountnr='"+accnbrdest+"'","")+;					
			iif(amount<0,",debitamnt=0.00,creditamnt="+str(-amount,-1),",debitamnt="+str(amount,-1)+",creditamnt=0.00")+;
				",processed=0"+;
				",fromrpp=1"+; 
			",descriptn='"+AddSlashes(cDescription)+"'"+;
				",reference='"+reference+"'"+;			 
			",poststatus="+iif(transtype="PC" .and.!Empty(accnbrdest),"2","1")+;
				iif(transtype="CN" .or. transtype="CP",;
				",assmntcd='AG',externid='"+cExId+"'";
				,;
				",assmntcd='"+;
				iif(transtype="MM","MG",;
				iif(transtype="PC",;
				iif(amount<0,"PF","CH");
				,;
				"";
				);
				);
				+"'";
				)

			oStmnt:=SQLStatement{cStatement,oConn}
			oStmnt:Execute()
			IF oStmnt:NumSuccessfulRows<1
				LogEvent(,"error:"+cStatement,"LogErrors")
				ErrorBox{,self:oLan:WGet('Transaction could not be stored')+":"+oStmnt:status:Description}:show()
				return false
			endif
			self:lv_imported++
		ENDIF
		recordfound:=PMISDocument:GetNextSibbling()
	ENDDO
	FClose(ptrHandle)
	RETURN true
METHOD INIT(oOwner,oHulpMut,Share,ReadOnly) CLASS ImportBatch
SetPath(CurPath)
SetDefault(CurPath)
Default(@ReadOnly,FALSE)
Default(@Share,FALSE)
self:oLan:=Language{}
oParent:=oOwner
//self:Import()
self:oHM:=oHulpMut

RETURN SELF
METHOD LockBatch(dummy:=nil as logic) as logic CLASS ImportBatch
* Locking of current batch records
local oMyImp as SQLSelect
oMyImp:=SQLSelect{"select imptrid from importtrans where transactnr='"+self:cCurBatchNbr+;
"' and origin='"+self:cCurOrigin+"' and processed=0 and lock_id="+MYEMPID+" for update",oConn}
oMyImp:execute()
if oMyImp:reccount<1
	ErrorBox{self:oParent,self:oLan:WGet("This import transaction has already been processed by someone else, thus skipped")}:show()
	SQLStatement{"rollback",oConn}:execute()
	return false
endif
return true
METHOD SkipBatch(dummy:=nil as logic) as void pascal CLASS ImportBatch
* Unlock batch 
SQLStatement{"update importtrans set lock_id=0 where transactnr='"+self:cCurBatchNbr+;
"' and origin='"+self:cCurOrigin+"' and transdate='"+SQLdate(self:dCurDate)+"'",oConn}:execute()
SQLStatement{"commit",oConn}:execute()
RETURN 
