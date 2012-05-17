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
protect lv_imported,lv_processed as int
protect aMessages:={} as array  // messages about successfully imported files  
protect aValues:={} as array   // array with values to be inserted into importrans
	//avalues: transdate,docid,transactnr,descriptn,giver,debitamnt,creditamnt,accname,accountnr,assmntcd,externid,origin,processed

declare method GetNextBatch,LockBatch,CloseBatch,ImportPMC,ImportBatch,ImportAustria,SkipBatch,ImportCzech,SaveImport,AddImport 
Method AddImport(FromAcc as string,ToAcc as string,Amount as float,Description as string,impDat as date,ExtId as string,Name as string,FromDesc as string,ToDescr as string,;
		docid as string, cOrigin as string,cTransnr as string,aMbrAcc as Array,nCnt ref int,lCheckDuplicates:=false as logic) as void pascal class ImportBatch 
	// 	local FromAcc, ToAcc, Description, ExtId, Firma,FromDesc,ToDescr, AsmtCode1:="",AsmtCode2:="AG", cOrigin, cTransnr, docid as string, Amount as float, impDat as date
	local AsmtCode1:="",AsmtCode2:="AG" as string
	local oImpTr as SQLSelect
	local cImpDat as string
	local oStmnt as SQLStatement
	local nImptrid as int 
	AsmtCode1:=""
	if AScanExact(aMbrAcc,ToAcc) >0
		AsmtCode2:="AG"
	endif
	if AScanExact(aMbrAcc,FromAcc) >0
		if FromAcc <> ToAcc 
			AsmtCode1:="CH"
			AsmtCode2:="MG"
		endif
	endif
	cImpDat:=SQLdate(impDat) 
	if lCheckDuplicates
		// Check if transaction already present:

		// Search for two lines (debit and credit) equal to transaction to be imported:
		oImpTr:=SqlSelect{"select imptrid from importtrans where origin='"+AllTrim(cOrigin)+"' and "+; 
		"externid='"+ExtId+"' and transdate='"+cImpDat+"' and descriptn='"+Description+"' and "+;
			"(accountnr='"+FromAcc+"' and debitamnt="+Str(Amount,-1)+" or accountnr='"+ToAcc+"' and creditamnt="+Str(Amount,-1)+")"+;
			" order by imptrid",oConn}
		if oImpTr:RecCount=2				
			return  // skip if allready present
		elseif oImpTr:RecCount>2 
			// check if consecutive:
			do while !oImpTr:EOF
				if Empty(nImptrid)
					nImptrid:=oImpTr:imptrid
				else
					if oImpTr:imptrid-nImptrid=1
						return // apparently two consecutive lines found
					endif
					nImptrid:=oImpTr:imptrid  // restart searching
				endif
				oImpTr:Skip()			
			enddo
		endif
	endif
	// add to avalues:
	// first transaction line
	// transdate,docid,transactnr,descriptn,giver,debitamnt,creditamnt,accname,accountnr,assmntcd,externid,origin,processed
	AAdd(self:aValues,{cImpDat,docid,cTransnr,Description,;
		Name,Str(Amount,-1),'0.00',FromDesc,FromAcc,AsmtCode1,ExtId,cOrigin,0})
	// second transaction line
	AAdd(self:aValues,{cImpDat,docid,cTransnr,Description,;
		Name,'0.00',Str(Amount,-1),ToDescr,ToAcc,AsmtCode2,ExtId,cOrigin,0})
	nCnt++
	return
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
self:aImportFiles:=Directory(CurPath+"\*.csv")
aTxt:=Directory(CurPath+"\*.txt")
IF Len(aTxt)>0
	nlen:=Len(self:aImportFiles)
	ASize(self:aImportFiles,nlen+Len(aTxt))
	ACopy(aTxt,self:aImportFiles,,,nlen+1)
ENDIF
FOR nf:=1 to Len(self:aImportFiles)
	cFileName:=Upper(self:aImportFiles[nf,F_NAME]) 
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
		elseif cFileName="AUSTRIADONATIONS.TXT"
			if self:ImportAustria(FileSpec{cFileName},dBatchDate,PadR(cFileName,11),true)   // test if correct fileformat
				loop
			endif		
		ENDIF
	ENDIF
		
	ADel(self:aImportFiles,nf)
	ASize(self:aImportFiles,Len(self:aImportFiles)-1)
	nf--
NEXT
// Import also import files from Czech WinDuo:
aTxt:=Directory(CurPath+"\DENIK*.dbf")
if Len(aTxt)<1
	aTxt:=Directory(CurPath+"\deník*.dbf")
endif	
IF Len(aTxt)>0
	nlen:=Len(self:aImportFiles)
	ASize(self:aImportFiles,nlen+Len(aTxt))
	ACopy(aTxt,self:aImportFiles,,,nlen+1)
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
	nlen:=Len(self:aImportFiles)
	ASize(self:aImportFiles,nlen+Len(aPMIS))
	ACopy(aPMIS,self:aImportFiles,,,nlen+1)
ENDIF
IF Len(self:aImportFiles)>0
	RETURN TRUE
ELSE
	RETURN FALSE
ENDIF
METHOD GetNextBatch(dummy:=nil as logic) as logic CLASS ImportBatch
	* Give next import batch with transaction from ImportTrans
	LOCAL OrigBst, CurBatchNbr, cGiverName as STRING
	LOCAL CurDate as date, CurOrigin as STRING
	LOCAL cOms, cExId as STRING
	local MultiCur:=false as logic 
	local nPostStatus as int 
	local oImpB,oImpTr1,oImpTr2 as SQLSelect
	local oLockSt as SQLStatement 

	SQLStatement{"start transaction",oConn}:execute() 
	oImpTr1:=SQLSelect{"select transactnr,origin from importtrans "+;
	"where processed=0 "+;
	+"and (lock_id=0 or lock_id="+MYEMPID+" or lock_time < subdate(now(),interval 20 minute))"+;
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
	oImpB:=SQLSelect{"select a.description as accountname,a.accid,a.currency as acccurrency,a.multcurr,a.accnumber,a.department,b.category as type,m.co,m.persid as persid,"+SQLAccType()+" as accounttype,i.*"+;
	" from importtrans i left join (balanceitem as b,account as a left join member m on (m.accid=a.accid or m.depid=a.department) left join department d on (d.depid=a.department)) on (i.accountnr<>'' and a.accnumber=i.accountnr and b.balitemid=a.balitemid)"+;
	"where i.transactnr='"+CurBatchNbr+"' and i.origin='"+CurOrigin+"' order by imptrid",oConn}
	if oImpB:reccount<1
	   LogEvent(self,oImpB:SQLString+"; error:"+oImpB:status:Description,"LogErrors")
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
		self:oHM:DepID:=ConI(oImpB:department)
		MultiCur:=false
		IF !Empty(oImpB:accountnr)
			self:oHM:AccNumber := LTrimZero(oImpB:accountnr)
			IF !Empty(oImpB:AccNumber)
				self:oHM:accid := Str(oImpB:accid,-1)
				self:oHM:accdesc:=oImpB:accountname
				self:oHM:kind:=Upper(oImpB:accounttype)
				if Empty(oImpB:Currency).and.!Empty(oImpB:AccCurrency) 
					self:oHM:currency:=oImpB:AccCurrency
				endif 
				MultiCur:=iif(ConI(oImpB:MULTCURR)=1,true,false)
			ELSE
				lOK:=FALSE
			ENDIF
		ELSE
			self:lOK:=FALSE
		ENDIF
		self:oHM:deb := oImpB:debitamnt
		self:oHM:cre := oImpB:creditamnt
		self:oHM:debforgn := iif(self:oHM:currency==sCurr,oImpB:debitamnt,oImpB:debforgn)
		self:oHM:creforgn := iif(self:oHM:currency==sCurr,oImpB:creditamnt,oImpB:creforgn)
		self:oHM:BFM:= " "
		self:oHM:FROMRPP:=iif(ConI(oImpB:FROMRPP)=1,true,false)
		self:oHM:lFromRPP:=iif(ConI(oImpB:FROMRPP)=1,true,false)
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
// aMirror: {accID,deb,cre,gc,category,recno,Trans:RecNbr,accnumber,AccDesc,balitemid,curr,multicur,debforgn,creforgn,PPDEST, description,persid,type, incexpfd,depid}
//            1      2   3  4     5      6          7         8        9        10     11     12      13        14      15       16          17   18      19      20
		
		AAdd(self:oHM:aMirror,{self:oHM:accid,self:oHM:deb,self:oHM:cre,self:oHM:Gc,self:oHM:kind,self:oHM:RecNo,,self:oHM:AccNumber,'','',self:oHM:currency,MultiCur,self:oHM:debforgn,self:oHM:creforgn,self:oHM:REFERENCE,self:oHM:descriptn,oImpB:persid,oImpB:TYPE,'',oHM:DepID})
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
	oParent:AddCur()
	self:oHM:ResetNotification()
	self:oHM:GoTop()
	self:oHM:Skip()
RETURN true
METHOD Import() CLASS ImportBatch
	* Import of batches of  transaction data into ImportTrans.dbf
	LOCAL oBF AS FileSpec
	LOCAL nf,lv_aant_toe:=0,lv_imported_tot:=0,  lv_aant_vrw:=0,i as int
	LOCAL cFileName, cOrigin AS STRING
	LOCAL nImportDate AS STRING, dBatchDate AS DATE
	LOCAL oWarn as warningbox
	local oStmnt as SQLStatement
	Local oLock as SQLSelect
	local aFiles:={} as array // files to be deleted 
	// force only one person is importing: 
	// Check if nobody else is busy with importing batch: 
	oLock:=SqlSelect{'select 1 from importlock where importfile="batchlock" and '+;
		" lock_id>0 and lock_id<>"+MYEMPID+" and lock_time > subdate(now(),interval 5 minute)",oConn}
	if oLock:Reccount>0 
		ErrorBox{,self:oLan:WGet("somebody else busy with importing batch transactions")}:Show()
		return
	endif 
	SQLStatement{"start transaction",oConn}:Execute()
	oLock:=SqlSelect{"select importfile from importlock where importfile='batchlock' for update",oConn}
	oLock:Execute() 
	if !Empty(oLock:Status)
		ErrorBox{,self:oLan:WGet("could not select importlock")+Space(1)+' ('+oLock:Status:description+')'}:Show()
		SQLStatement{"rollback",oConn}:Execute() 
		return
	endif
	// set software lock:
	oStmnt:=SQLStatement{"update importlock set lock_id="+MYEMPID+",lock_time=now() where importfile='batchlock'",oConn}
	oStmnt:Execute()
	if !Empty(oStmnt:Status)
		ErrorBox{,self:oLan:WGet("could not lock required transactions")}:Show()
		SQLStatement{"rollback",oConn}:Execute() 
		return
	endif
	SQLStatement{"commit",oConn}:Execute()  // save locks 

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
// 					return
				ENDIF
			else 
				SQLStatement{"start transaction",oConn}:Execute()
				if self:ImportBatch(oBF,dBatchDate,cOrigin)
					++lv_aant_toe
					AAdd(aFiles,oBF)
					SQLStatement{"commit",oConn}:Execute()  
				else
					SQLStatement{"rollback",oConn}:Execute()
// 					return
				ENDIF
			endif 
		ELSEIF Upper(oBF:Extension)==".XML"
			// import file in PMIS-XML-format:
			if self:ImportPMC(oBF,dBatchDate)
				++lv_aant_toe
				AAdd(aFiles,oBF)
			ENDIF
		ELSEIF Upper(oBF:Extension)==".DBF"
			// import file in WinDUO Denik-export-format:
// 			SQLStatement{"start transaction",oConn}:Execute()
// 			if self:ImportBatchCZR(oBF,dBatchDate) 
			if self:ImportCzech(oBF,dBatchDate,'CZR') 
				++lv_aant_toe
				AAdd(aFiles,oBF)
// 				SQLStatement{"commit",oConn}:Execute()  
// 			else
// 				SQLStatement{"rollback",oConn}:Execute()
// 				return
			ENDIF
		ENDIF
	NEXT
	IF lv_aant_toe>0
		* Clear old batches: 
		oStmnt:=SQLStatement{"delete from importtrans where processed=1 and transdate<'"+SQLdate(Today()-440)+"'",oConn}
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
	// unlock software lock:
	SQLStatement{"start transaction",oConn}:Execute()
	oLock:=SqlSelect{"select importfile from importlock where importfile='batchlock' for update",oConn}
	oLock:Execute() 
	if !Empty(oLock:Status)
		ErrorBox{self,self:oLan:WGet("could not select importlock")+Space(1)+' ('+oLock:Status:description+')'}:Show()
		SQLStatement{"rollback",oConn}:Execute() 
		return
	endif
	oStmnt:=SQLStatement{"update importlock set lock_id='',lock_time='0000-00-00' where importfile='batchlock'",oConn}
	oStmnt:Execute()
	if !Empty(oStmnt:Status)
		ErrorBox{self,self:oLan:WGet("could not unlock required transactions")}:Show()
		SQLStatement{"rollback",oConn}:Execute() 
		return
	endif
	SQLStatement{"commit",oConn}:Execute()  // save locks 

	IF Len(self:aMessages)>0
		(InfoBox{,self:oLan:WGet("Import of batches"),AllTrim(Str(lv_aant_toe,4))+" "+self:oLan:WGet("batch file")+if(lv_aant_toe>1,"s","")+" "+;
		self:oLan:WGet("with")+" "+Str(lv_imported,-1)+" "+self:oLan:WGet("transactions imported")+' ('+Str(self:lv_processed,-1)+Space(1)+;
		self:oLan:WGet("automaticaly processed")+')'}):show()
		for i:=1 to Len(self:aMessages)
			LogEvent(self,self:aMessages[i],"Log")
		next 
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
	LOCAL aPt:={} as ARRAY, maxPt , nCnt:=0,nProc:=0,nTot,nAcc,nPers,i,nTransId,nLastGift as int
	LOCAL cBank,cBankName,cBankaccId as string 
	local aDat as array, impDat as date, cAcc,cAccNumber,cAccName,cAssmnt,cAccId,cdat as string , lUnique as logic
	local oStmnt as SQLStatement
	local oSel,oImpTr,oAcc as SQLSelect
	local cStatement,cError as string 
	local lError,lSuccess as logic
	local Amount as float 
	local aValues:=self:aValues as array   // array with values to be inserted into importrans 
// 	local aValuesTrans:={} as array   // array with values to be automatically inserted into transaction 
// 	local aValuesPers:={} as array   // array with person values to be automatically updated {{persid,datelastgift},{..},...} 
	local aAccDest:={} as array  // array with destination accounts: {{accnumber,accid},{..},..} 
	local aMbrAcc:={} as array  // array with member accounts
	local aPers:={}  as array // array with giver data: {{externid,persid},{..}...} 
	local aPersExt:={} as array // array with import externids
	local oMBal as Balances 
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

	oSel:=SqlSelect{"select a.accnumber,a.description,a.accid from bankaccount b,account a where a.accid=b.accid",oConn}
	if oSel:RecCount<1
		(ErrorBox{,self:oLan:WGet("Specify first a bank account with its general ledger account")}):show() 
		ptrHandle:Close()
		return false
	else
		cBank:=oSel:ACCNUMBER
		cBankName:=oSel:Description 
		cBankaccid:=Str(oSel:accid,-1)
	endif

	// determine max fieldnumber:
	aPt:={ptDate,ptTrans,ptAccName,ptDesc,ptCre,ptPers,ptDoc}
	ASort(aPt)
	maxPt=aPt[Len(aPt)] 
	cBuffer:=ptrHandle:FReadLine()
	aFields:=Split(cBuffer,cDelim)
	oParent:Pointer := Pointer{POINTERHOURGLASS} 

	DO WHILE Len(AFields)>1
		cStatement:=""
		impDat:=null_date
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
				lError:=true
				exit
			endif
		endif
		if ptAccName>0 .and. ptAccName<=Len(AFields) 
			cAccName:=AllTrim(AFields[ptAccName])
			nAcc:=AScan(aAccDest,{|x|x[1]==cAccName})
			cAccNumber:="" 
			cAccId:=''
			if nAcc=0
				cAcc:=Split(cAccName," ")[1] 
				if IsDigit(cAcc)
					cAcc:= LTrimZero(cAcc)
					oAcc:=SqlSelect{"select a.accnumber,a.accid,m.mbrid from account a left join member m on (m.accid=a.accid or m.depid=a.department) where a.accnumber='"+cAcc+"'",oConn}
					if oAcc:RecCount=1
						cAccNumber:=oAcc:ACCNUMBER							
					endif
				else
					oAcc:=SqlSelect{"select a.accnumber,a.accid,m.mbrid from account a left join member m on (m.accid=a.accid or m.depid=a.department) where a.description like '"+cAcc+"%'",oConn}
					if oAcc:RecCount=1
						cAccNumber:=oAcc:ACCNUMBER
					elseif oAcc:RecCount>0  
						oAcc:=SqlSelect{"select a.accnumber,a.accid,m.mbrid from account a left join member m on (m.accid=a.accid or m.depid=a.department) where a.description like '%"+StrTran(cAccName,' ','%')+"%'",oConn}
						if oAcc:RecCount=1
							cAccNumber:=oAcc:ACCNUMBER
						endif
					endif
				endif
				cAssmnt:=""
				if !Empty(cAccNumber)
					cAccId:=Str(oAcc:accid,-1)
					if !Empty(oAcc:mbrid) 
						AAdd(aMbrAcc,cAccId)
						cAssmnt:="AG"
					endif
				endif
				AAdd(aAccDest,{cAccName,cAccNumber,cAssmnt,cAccId})
				nAcc:=Len(aAccDest)
			endif
		ENDIF
		Amount:=Val(StrTran(StrTran(AFields[ptCre],".",''),",","."))
		self:AddImport(cBank,aAccDest[nAcc,2],Amount,self:oLan:RGet("Gift") +iif(ptDesc<= Len(AFields)," "+AFields[ptDesc],""),impDat,AFields[ptPers],;
		AFields[ptDoc],cBankName,cAccName,'Import',cOrigin,AFields[ptTrans],aMbrAcc,@nCnt)
		oMainWindow:STATUSMESSAGE("imported "+Str(nCnt,-1))		
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim)
	ENDDO
	ptrHandle:Close()
	if nCnt>0
		// check if loaded: 
		oSel:=SqlSelect{"select count(*) as tot from importtrans where `origin`='"+cOrigin+"' and `transactnr` in ("+Implode(aValues,',',,,3)+")",oConn}
		
		if oSel:RecCount<1 .or. oSel:tot=0 
			// not yet loaded 
			lSuccess:=self:SaveImport(@nCnt,@nProc)
			if !lSuccess
				lError:=true
			endif
		endif
	endif
	self:oParent:Pointer := Pointer{POINTERARROW} 
	if lError
		return false
	endif
	AAdd(self:aMessages, "Imported Austria file:"+oFr:FileName+" "+Str(nCnt,-1)+" transactions imported ("+Str(nProc,-1)+" automaticaly processed)")

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
	LOCAL aPt:={} as ARRAY, maxPt , linenr:=0, nCnt:=0 as int
	local osel as SQLSelect 
	local cStatement as string
	local oStmnt as SQLStatement
	
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
	if !GetDelimiter(cBuffer,@aStruct,@cDelim,8,17)
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
	cSep:=DecSeparator    // default decimal separator of Windows 
	// check if different separator used:
	if ptDeb<= Len(AFields)
		if At(AFields[ptDeb],cSep)=0
  			if At(AFields[ptCre],',')>0
  				cSep:=','
  			elseif At(AFields[ptCre],'.')>0
  				cSep:='.'
  			endif
		endif
	endif
	DO WHILE Len(AFields)>1
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
			",debforgn="+iif(ptDebF>0 .and.ptDebF<= Len(AFields),AFields[ptDebF],AFields[ptDeb])+;
				",creforgn="+iif( ptCreF>0 .and. ptCreF<= Len(AFields),AFields[ptCreF],AFields[ptCre])+;
				",currency='"+iif(ptCur>0 .and.ptCur<= Len(AFields),AFields[ptCur],sCURR)+"'"+;
				iif(ptAss<= Len(AFields),",assmntcd='"+AFields[ptAss]+"'","")+;
				iif(ptAccName>0 .and. ptAccName<=Len(AFields),",accname='"+AddSlashes(AFields[ptAccName])+"'","")+;
				iif(ptPers>0 .and. ptPers<=Len(AFields),iif(AllTrim(AFields[ptPers])==",","",",giver='"+AllTrim(AFields[ptPers])+"'"),"")+;
				iif(ptPPD>0 .and. ptPPD<=Len(AFields),",ppdest='"+AFields[ptPPD]+"'","")+;
				iif(ptRef>0 .and. ptRef<=Len(AFields),",reference='"+AddSlashes(AFields[ptRef])+"'","")+;
				iif(ptSeq>0 .and. ptSeq<=Len(AFields)  .and. !IsNil(AFields[ptSeq]),",seqnr="+AFields[ptSeq],"")+;
				",poststatus="+iif(ptPost>0 .and. ptPost<=Len(AFields).and. !IsNil(AFields[ptPost]),AFields[ptPost],"1")+;
				",origin='"+cOrigin+"'" 
			oStmnt:=SQLStatement{"insert into importtrans set "+SubStr(cStatement,2),oConn}
			oStmnt:Execute()
			IF oStmnt:NumSuccessfulRows<1
				ptrHandle:Close()
				LogEvent(self,"error: "+oStmnt:SQLString,"LogErrors")
				ErrorBox{,self:oLan:WGet('Transaction could not be stored')+":"+oStmnt:status:Description}:show()
				return false
			endif
			self:lv_imported++ 
			nCnt++
		ENDIF
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim)
	ENDDO 

	AAdd(self:amessages,"Imported batch file:"+oFr:FileName+" "+Str(nCnt,-1)+" imported of "+Str(linenr,-1)+" transactions")

	RETURN true
METHOD ImportCzech(oFr as FileSpec,dBatchDate as date,cOrigin as string,Testformat:=false as logic) as logic CLASS ImportBatch
	* Import of one batchfile with  transaction data into ImportTrans.dbf 
	* Testformat: only test if this a file to be imported
	LOCAL oImpCZR as DBFILESPEC
	LOCAL nCnt:=0,nProc:=0,nTot,i,nTransId,nLastGift as int
	LOCAL SamAcc,PMCAcc as string 
	local oSel,oImpTr,oAcc,oMbr as SQLSelect
	local lSuccess as logic 
	local LastDate as date
	local aMbrAcc:={} as array // array with member accounts 
// 	local aValues:={} as array   // array with values to be inserted into importrans 
	Local aMissingFld:={},aNeededFld:={"ICO","POPIS","CASTKA","CASTKAM","DAU","FIRMA","MD_UCET","D_UCET","DOKLAD"} as array
	local FromAcc, ToAcc, Description, ExtId, Firma,FromDesc,ToDescr, AsmtCode1:="",AsmtCode2:="AG", cOrigin, cTransnr, docid as string, Amount as float, impDat as date
	
	oImpCZR:=DbFileSpec{oFr:FullPath,"DBFCDX"}
	oImpCZR:Path:=CurPath
	oImpTr:=oImpB
	self:aValues:={}
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

			oParent:Pointer := Pointer{POINTERHOURGLASS} 
			// determine member accounts:
			oMbr:=SqlSelect{"select a.accnumber from account a, member m where m.accid=a.accid or m.depid=a.department",oConn}
			aeval(oMbr:GetLookupTable(3000,#accnumber,#accnumber),{|x|aadd(aMbrAcc,x[1])})
			if Empty(sam)
				(ErrorBox{self,"No account defined for assessments in system parameters!"}):show()
				CZR->DBCLOSEAREA()
				DbSetRestoreWorkarea (false)
				return false
			endif 
			oSel:=SqlSelect{"select accnumber,accid from account where `accid`="+sam,oConn}
			IF oSel:RecCount<1
				(errorbox{self:OWNER,self:oLan:WGet('Account for assemments not found')}):Show()
				CZR->DBCLOSEAREA()
				DbSetRestoreWorkarea (false)
				return false
			ENDIF
			SamAcc:=oSel:ACCNUMBER
			oSel:=SqlSelect{"select accnumber,accid from account where `accid`="+SHB,oConn}
			IF oSel:RecCount<1
				(ErrorBox{self:OWNER,self:oLan:WGet('Account for sending to PMC not found')}):show()
				CZR->DBCLOSEAREA()
				DbSetRestoreWorkarea (false)
				return false
			ENDIF
			PMCAcc:=oSel:ACCNUMBER
			// Search latest transdate in Imptr: 
			oImpTr:=SqlSelect{"select max(transdate) as transdate from importtrans where origin='CZR'",oConn}
			if Empty(oImpTr:status) .and. oImpTr:RecCount>0
				LastDate:=oImpTr:transdate 
			else
				LastDate:=Today()
			endif				
			LastDate:=LastDate-(Day(LastDate)-1)  // place at start of month
			CZR->DbSetFilter({||CZR->DATUM > LastDate})
			CZR->DbGotop() 
			do while !CZR->EOF() 
				ToAcc:=StrZero(CZR->FieldGetSym(#DSU),3,0)+StrZero(CZR->FieldGetSym(#DAU),3,0)
				FromAcc:=StrZero(CZR->FieldGetSym(#MDSU),3,0)+StrZero(CZR->FieldGetSym(#MDAU),3,0)
				Amount:=CZR->FieldGetSym(#CASTKA)
				Description:=AllTrim(CZR->FieldGetSym(#POPIS))
				impDat:=CZR->FieldGetSym(#DATUM) 
				ExtId:=Str(CZR->FieldGetSym(#ICO),-1)
				Firma:=AllTrim(CZR->FieldGetSym(#FIRMA))
				FromDesc:=AllTrim(CZR->FieldGetSym(#MD_UCET))
				ToDescr:=AllTrim(CZR->FieldGetSym(#D_UCET))
				docid:=AllTrim(CZR->FieldGetSym(#DOKLAD))
				cOrigin:="WD"+Pad(docid,9) 
				nTot++
				if AScan(aMbrAcc,{|x|x==ToAcc}) > 0      // skip non member transaction
					if !(FromAcc==SamAcc .or. FromAcc==PMCAcc)   // skip assessment and PMC transactions
						self:AddImport(FromAcc,ToAcc,Amount,Description,impDat,ExtId,Firma,FromDesc,ToDescr,docid,cOrigin,cTransnr,aMbrAcc,@nCnt,true)
					endif
				endif
				CZR->DBSKIP()
			enddo
			CZR->DBCLOSEAREA()
			DbSetRestoreWorkarea (false)
			if nCnt>0
				lSuccess:=self:SaveImport(@nCnt,@nProc)
			endif
			self:oParent:Pointer := Pointer{POINTERARROW} 
			if !lSuccess
				return false
			endif
// 			AAdd(self:aMessages,"Imported CZ file:"+oFr:FileName+" "+Str(nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions ("+Str(nProc,-1)+" automaticaly processed)")
			AAdd(self:aMessages,"Imported CZ file:"+oFr:FileName+" "+Str(nCnt,-1)+" transactions imported ("+Str(nProc,-1)+" automaticaly processed)")
			return true
		ENDIF
	endif

	RETURN true
METHOD ImportPMC(oFr as FileSpec,dBatchDate as date) as logic CLASS ImportBatch
	* Import of one RPPfile with  transaction data from PMC into ImportTrans.dbf
	LOCAL cBuffer AS STRING
	LOCAL ptrHandle
	LOCAL PMISDocument AS XMLDocument
	LOCAL childfound, recordfound AS LOGIC
	LOCAL ChildName AS STRING
	LOCAL amount, USamountAbs, USDAmount, oppAmount,TotAmount,TotUSDAmount as FLOAT
	LOCAL transdescription,description,oppdescr, docid, accnbr,accnbrdest,acciddest,origin,transtype,housecode,samnbr,shbnbr, reference as STRING
	LOCAL transdate, oppdate,rppdate,cmsdate as date
	LOCAL oAfl AS UpdateHouseHoldID
	LOCAL datelstafl AS DATE
	LOCAL nAnswer, nCnt,nTot,nMbr,nAcc,nPtr,i,nProc,nCnt,nSeqnbr as int
	local nTransId as Dword 
	lOCAL cPmisCurrency as string, lUSD as logic 
	local oCurr as CURRENCY 
	local RPP_date as date
	LOCAL oExch as GetExchRate
	Local oInST as Insite, cAccCng,cDescription,cMsg,cError as string
	Local cExId as string
	local osel as SQLSelect 
	local cStatement,cTrans as string
	local time1,time0 as float
	local oMBal as Balances
	local oStmnt as SQLStatement 
	local aValues:={} as array   // array with values to be inserted into importrans 
	local aValuesTrans:={} as array   // array with values to be automatically inserted into transaction 
	local aAccMbr:={} as array   // array with accounts of members: {{housecode,accinc,accexp,netasset,accidinc,accidexp,accidnetasset},{...}... } 
	local aAccDest:={} as array  // array with destination accounts: {{accnumber,accid},{..},..}
	local aTransIncExp:={} as array // array like aTrans for ministry income/expense transactions   
	local oAddInc as AddToIncExp 
	if Empty(SEntity)
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
	self:oParent:Pointer := Pointer{POINTERHOURGLASS} 
	oAfl:=UpdateHouseHoldID{}
	oAfl:Importaffiliated_person_account_list()

	// 	datelstafl:=SQLSelect{"select datlstafl from sysparms",oConn}:DATLSTAFL 
	// 	if datelstafl<Today()  
	// 		self:oParent:STATUSMESSAGE(self:oLan:WGet('Processing account changes report')+'...')
	// 		oAfl:=UpdateHouseHoldID{}
	// 		IF !oAfl:Importaffiliated_person_account_list()
	// 			IF datelstafl<(Today()-31) 
	// 				nAnswer:= (TextBox{,self:oLan:WGet("Import RPP"),;
	// 					self:oLan:WGet('Your last import of the Account Changes Report from Insite is of')+' '+DToC(datelstafl)+'.'+LF+self:oLan:WGet('If you stop now you can first download that report from Insite into folder')+' '+curPath+' '+self:oLan:WGet('before the send to PMC')+CRLF+CRLF+self:oLan:WGet('Do you want to stop now?'),BOXICONQUESTIONMARK + BUTTONYESNO}):show()
	// 				IF nAnswer == BOXREPLYYES 
	// 					FClose(ptrHandle)
	// 					RETURN FALSE
	// 				ENDIF
	// 			ENDIF
	// 		ENDIF
	// 	ENDIF
	self:oParent:Pointer := Pointer{POINTERARROW} 

	IF Empty(sCURR)
		(ErrorBox{,self:oLan:WGet('First specify the currency in System parameters')}):show()
		FClose(ptrHandle)
		RETURN false
	ENDIF

	oCurr:=Currency{self:oLan:WGet("Importing RPP")} 
	RPP_date:=SToD(SubStr(oFr:FileName,5,8))
	mxrate:=SQLSelect{"select exchrate from sysparms",oConn}:EXCHRATE
	mxrate:=oCurr:GetROE("USD", RPP_date,true,true,-0.5) 
	if oCurr:lStopped
		FClose(ptrHandle)
		return false
	endif

	// Proces records:
	PMISDocument:=XMLDocument{cBuffer}
	// first check intehrity of document:
	If !PMISDocument:GetElement("RPP_Records") 
		If PMISDocument:GetElement("Message") 
			FClose(ptrHandle)
			return true
		else
			(ErrorBox{,self:oLan:WGet('No correct RPP file')+' '+AllTrim(oFr:FileName)}):show()
			FClose(ptrHandle)
			RETURN false
		endif
	ENDIF
	
	recordfound:= PMISDocument:GetElement("Record")
	osel:=SQLSelect{"select accnumber,currency from account where accid="+sam,oConn}
	IF osel:RecCount<1
		(errorbox{self:OWNER,self:oLan:WGet('Account for assemments not found')}):Show()
		FClose(ptrHandle)
		return false
	ENDIF
	samnbr:=osel:ACCNUMBER
	osel:=SQLSelect{"select accnumber,currency from account where accid="+SHB,oConn}
	IF osel:RecCount<1
		(errorbox{self:OWNER,self:oLan:WGet('Account for sending to PMC not found')}):Show()
		FClose(ptrHandle)
		return false
	ENDIF
	shbnbr:=osel:ACCNUMBER
	cPmisCurrency:=osel:CURRENCY
	if cPmisCurrency=="USD"
		lUSD:=true
	elseif Empty(cPmisCurrency)
		cPmisCurrency:=sCURR
	endif
	self:oParent:Pointer := Pointer{POINTERHOURGLASS} 
	cMsg:=self:oLan:WGet('Importing RPP transactions')+'...'
	self:oParent:STATUSMESSAGE(cMsg)
	// 	(time1:=Seconds()) 
	if !Empty(SINCHOME) .or.!Empty(SINC)
		// add transactions for ministry income/expense:
		oAddInc:=AddToIncExp{}
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
		reference:=""
		transtype:="GT" 
		acciddest:=''
		accnbrdest:=""
		nTot++
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
		self:oParent:STATUSMESSAGE(cMsg+Str(nCnt,-1))
		if !Empty(mxrate)
			amount:=Round(mxrate*USDAmount,DecAantal)
		endif
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
			nAcc:=AScan(aAccDest,{|x|x[1]==accnbr})
			if nAcc=0
				osel:=SQLSelect{"select accnumber,accid from account where accnumber='"+accnbr+"'",oConn}
				IF osel:RecCount>0
					AAdd(aAccDest,{osel:ACCNUMBER,Str(osel:accid,-1)})
					nAcc:=Len(aAccDest)
				ENDIF
			endif
			if nAcc>0
				accnbrdest:=aAccDest[nAcc,1] 
				acciddest:=aAccDest[nAcc,2] 
			ELSE
				IF transtype="AT"
					accnbrdest:=samnbr
					acciddest:=sam
				ENDIF
			endif
		ELSEIF transtype="AT"
			accnbrdest:=samnbr
			acciddest:=sam
		ENDIF
		IF !Empty(housecode) .and.Empty(accnbrdest)
			// search corresponding member:
			nMbr:=AScan(aAccMbr,{|x|x[1]==housecode})
			if nMbr=0
				osel:=SqlSelect{"select ad.accnumber as accdirect,ai.accnumber as accincome,ae.accnumber as accexpense,an.accnumber as accnetasset,"+;
					"m.accid as acciddirect,d.incomeacc,d.expenseacc,d.netasset "+;
					"from member m left join account ad on (ad.accid=m.accid) left join department d on (m.depid=d.depid) "+;
					"left join account ai on (ai.accid=d.incomeacc) "+;
					"left join account ae on (ae.accid=d.expenseacc) "+;
					"left join account an on (an.accid=d.netasset) "+;
					"where m.householdid='"+housecode+"'",oConn}
				if osel:RecCount>0
					AAdd(aAccMbr,iif(Empty(osel:accdirect),{housecode,osel:accincome,osel:accexpense,osel:accnetasset,Str(osel:incomeacc,-1),Str(osel:expenseacc,-1),Str(osel:netasset,-1)},;
						{housecode,osel:accdirect,osel:accdirect,osel:accdirect,Str(osel:acciddirect,-1),Str(osel:acciddirect,-1),Str(osel:acciddirect,-1)}))
					nMbr:=Len(aAccMbr)
				endif
			endif
			if nMbr>0
				if transtype="CN" .or. transtype="CP".or.transtype="MM"
					accnbrdest:=aAccMbr[nMbr,2]   //accincome 
					acciddest:=aAccMbr[nMbr,5]
				elseif transtype="PC" .and. amount<0
					accnbrdest:=aAccMbr[nMbr,4]   //netasset
					acciddest:=aAccMbr[nMbr,7]
				else							
					accnbrdest:=aAccMbr[nMbr,3]   //accexpense
					acciddest:=aAccMbr[nMbr,6]
				endif
			ENDIF
		ENDIF
		//     1       2       3         4           5       6       7       8        9         10        11      12      13         14        15          16       17
		// transdate,docid,transactnr,accountnr,assmntcd,externid,origin,fromrpp,creditamnt,debitamnt,creforgn,debforgn,currency,descriptn,poststatus,reference,processed
		AAdd(aValues,{SQLdate(transdate),docid,docid,shbnbr,'','',origin,'1',;
			iif(USDAmount<0,0.00,amount),;  //creditamnt
		iif(USDAmount<0,-amount,0.00),; //debitamnt
		iif(USDAmount<0,0.00,USDAmount),; //creforgn
		iif(USDAmount<0,-USDAmount,0.00),; //debgorgn
		cPmisCurrency,AddSlashes(cDescription),iif((transtype="PC" .or. transtype="AT") .and.!Empty(accnbrdest),"2","1"),'',iif(Empty(acciddest),'0','1')})
		// totalize transactions 
		TotAmount:=Round(TotAmount+amount,DecAantal)
		TotUSDAmount:=Round(TotUSDAmount+USDAmount,DecAantal)
		nPtr:=Len(aValues)
		if !Empty(acciddest) 
			// transaction can be processed automatically:
			//               1       2       3        4          5       6       7       8        9         10        11      12        13       14         15         16       17
			// aValues; transdate,docid,transactnr,accountnr,assmntcd,externid,origin,fromrpp,creditamnt,debitamnt,creforgn,debforgn,currency,descriptn,poststatus,reference,processed 
			//                1     2     3     4     5         6        7        10 11    12     13        14    15     16       17      18    19    20
			//aValuesTrans: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
			AAdd(aValuesTrans,{shb,avalues[nPtr,10],avalues[nPtr,12],avalues[nPtr,9],avalues[nPtr,11],avalues[nPtr,13],avalues[nPtr,14],avalues[nPtr,1],;
				aValues[nPtr,5],LOGON_EMP_ID,'2','1',aValues[nPtr,2],aValues[nPtr,16],'','1',origin,''})
		endif
		// second transaction row 

		if Empty(accnbrdest) .and.!Empty(accnbr)
			cDescription+=" "+accnbr				
		endif		
		IF transtype="CN" .or. transtype="CP".or.transtype="MM"
			cDescription:="Gift "+cDescription
		endif 
		// transdate,docid,transactnr,accountnr,assmntcd,externid,origin,fromrpp,creditamnt,debitamnt,creforgn,debforgn,currency,descriptn,poststatus,reference,processed
		AAdd(aValues,{SQLdate(transdate),docid,docid,Transform(accnbrdest,""),;
			iif(transtype="CN" .or. transtype="CP",;
			'AG';
			,;
			iif(transtype="MM","MG",;
			iif(transtype="PC",;
			iif(amount<0,"PF","CH");
			,;
			"";
			);
			);
			),;
			iif(transtype="CN" .or. transtype="CP",cExId,''),;
			origin,'1',;
			iif(amount<0,-amount,0.00),; //creditamnt
		iif(amount<0,0.00,amount),; //debitamnt
		iif(amount<0,-amount,0.00),; //creforgn
		iif(amount<0,0.00,amount),; //debforgn
		sCURR,AddSlashes(cDescription),iif(transtype="PC" .and.!Empty(accnbrdest),"2","1"),reference,iif(Empty(acciddest),'0','1')})
		nPtr++ 
		if !Empty(acciddest)
			// transaction can be processed automatically: 
			//             1         2      3         4          5       6        7       8         9         10        11     12        13       14        15         16        17
			// aValues; transdate,docid,transactnr,accountnr,assmntcd,externid,origin,fromrpp,creditamnt,debitamnt,creforgn,debforgn,currency,descriptn,poststatus,reference,processed
			//                1     2     3     4     5         6        7        8   9    10     11        12    13     14       15      16    17    18
			//aValuesTrans: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
			nProc++
			AAdd(aValuesTrans,{acciddest,avalues[nPtr,10],avalues[nPtr,12],avalues[nPtr,9],avalues[nPtr,11],avalues[nPtr,13],avalues[nPtr,14],avalues[nPtr,1],;
				aValues[nPtr,5],LOGON_EMP_ID,'2','2',aValues[nPtr,2],aValues[nPtr,16],'','1',origin,''})
			// add to income expense if needed: 
			if !Empty(SINCHOME) .or.!Empty(SINC)
				// add transactions for ministry income/expense:
				nSeqnbr:=2 
				aTransIncExp:=oAddInc:AddToIncome(aValues[nPtr,5],true,acciddest,aValues[nPtr,9],aValues[nPtr,10],aValues[nPtr,12],aValues[nPtr,11],;
				aValues[nPtr,13],aValues[nPtr,14],'',aValues[nPtr,1],aValues[nPtr,2],@nSeqnbr,aValues[nPtr,15])
				if Len(aTransIncExp)=2
				// aTransIncExp:
				//  1    2      3     4     5        6          7       8   9   10        11      12    13      14       15    16     17   18
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
// 					aTransIncExp[1,16]:=1    // replace by fromrpp
// 					aTransIncExp[2,16]:=1 
					aTransIncExp[1,11]:='2'  // poststatus -> posted
					aTransIncExp[2,11]:='2'  // poststatus -> posted
					AAdd(aValuesTrans,aTransIncExp[1])
					AAdd(aValuesTrans,aTransIncExp[2]) 
				endif
			endif
		endif 
		recordfound:=PMISDocument:GetNextSibbling()
	ENDDO
	FClose(ptrHandle)
	// Perform inserts:
	if !Empty(aValues)
		// check record allready loaded: 
		if SqlSelect{"select imptrid from importtrans where origin='"+aValues[1,7]+"' and transactnr='"+aValues[1,3]+"'"+;
				iif(Len(aValues)>2," or origin='"+aValues[Len(aValues),7]+"' and transactnr='"+aValues[Len(aValues),3]+"'",''),oConn}:RecCount<1 
			// not yet loaded (first and last sufficient check):
			cStatement:=Implode(aValues,"','") 
			// 			SQLStatement{"start transaction",oConn}:Execute()
			// prepare adapting mbalance values:
			oMBal:=Balances{}
			for i:=1 to Len(aValuesTrans) 
				//  1    2      3     4     5        6          7       8   9   10        11      12    13      14       15    16     17   18
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
				oMBal:ChgBalance(aValuesTrans[i,1],SQLDate2Date(aValuesTrans[i,8]),aValuesTrans[i,2],aValuesTrans[i,4],aValuesTrans[i,3],;
					aValuesTrans[i,5],aValuesTrans[i,6])
			next
			oStmnt:=SQLStatement{"set autocommit=0",oConn}
			oStmnt:Execute()
			oStmnt:=SQLStatement{'lock tables `transaction` write,`importtrans` write,`mbalance` write',oConn} 
			oStmnt:Execute()
			oStmnt:=SQLStatement{'insert into importtrans '+;
				'(`transdate`,`docid`,`transactnr`,`accountnr`,`assmntcd`,`externid`,`origin`,`fromrpp`,`creditamnt`,`debitamnt`,`creforgn`,`debforgn`,`currency`,`descriptn`,`poststatus`,`reference`,`processed`)'+;
				' values '+cStatement,oConn} 
			oStmnt:Execute()                                                            
			if oStmnt:NumSuccessfulRows<1
				SQLStatement{"rollback",oConn}:Execute()
				SQLStatement{"unlock tables",oConn}:Execute()
				LogEvent(self,"error:"+cStatement,"LogErrors")
				ErrorBox{,self:oLan:WGet('Transactions could not be imported')+":"+oStmnt:status:Description}:show()
				return false 
			else 
				nCnt:=oStmnt:NumSuccessfulRows/2
			endif
			if !Empty(aValuesTrans) 
				// insert first line:
				oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp) "+;
					" values ("+Implode(aValuesTrans[1],"','",1,16)+')',oConn}
				oStmnt:Execute()
				nTransId:=ConI(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
				aValuesTrans[2,18]:=nTransId
				for i:=3 to Len(aValuesTrans) step 2
					// next line income/expense?
					if aValuesTrans[i,12]=='3'
						aValuesTrans[i,18]:=nTransId
						aValuesTrans[i+1,18]:=nTransId
						i+=2
					endif		
					nTransId++
					if i<Len(aValuesTrans)
						aValuesTrans[i,18]:=nTransId
						aValuesTrans[i+1,18]:=nTransId
					endif
				next
				oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid) "+;
					" values "+Implode(aValuesTrans,"','",2),oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows<1
					SQLStatement{"rollback",oConn}:Execute() 
					SQLStatement{"unlock tables",oConn}:Execute()
					LogEvent(self,"error:"+cStatement,"LogErrors")
					ErrorBox{,self:oLan:WGet('Transactions could not be inserted')+":"+oStmnt:status:Description}:show()
					return false
				endif 
// 				nProc:=(oStmnt:NumSuccessfulRows+1)/2

				// adapt mbalance values:
				if !oMBal:ChgBalanceExecute()
					SQLStatement{"rollback",oConn}:Execute() 
					SQLStatement{"unlock tables",oConn}:Execute()
					LogEvent(self,"error:"+oMBal:cError,"LogErrors")
					ErrorBox{,self:oLan:WGet('Month balances could not be updated')+":"+cError}:show()
					return false 
				endif
				
			endif
			SQLStatement{"commit",oConn}:Execute()
			SQLStatement{"unlock tables",oConn}:Execute() 
			self:lv_imported:=self:lv_imported+nCnt
			self:lv_processed+=nProc
		else
			nCnt:=0
			nProc:=0
			TotAmount:=0.00 
		endif
	endif
	time0:=time1
	// 	LogEvent(self,"import RPP:"+Str((time1:=Seconds())-time0,-1)+"sec","logtime")
	oParent:Pointer := Pointer{POINTERARROW}
	AAdd(self:aMessages,"Imported RPP file:"+oFr:FileName+" "+Str(nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions; total amount:"+Str(-TotAmount,-1,DecAantal)+sCURR+'; '+Str(nProc,-1)+' automatic processed')

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
METHOD SaveImport(nCnt ref int,nProc ref int) as logic CLASS ImportBatch
	// store ImportTrans into database from array aValues 
	//
	local aPers:={}  // array with giver data: {{externid,persid},{..}...}
	local aValuesTrans:={} as array   // array with values to be automatically inserted into transaction
	local aValuesPers:={} as array   // array with person values to be automatically updated {{persid,datelastgift},{..},...} 
	local aAcc:={} as array  // array with accounts
	local aAccNbr:={} as array  // array with import accountnbrs
	local aPersExt:={} as array // array with externids
	local aValues:=self:aValues as array 
	local oMBal as Balances
	local oSel as SQLSelect
	local oStmnt as SQLStatement
	local i,nPers,nAcc,nLastGift,nTransId as int
	local cBankaccId as string
	nCnt:=0 
	if Len(aValues)>0
		// compose corresponding transactions which can be processed automatically: 
		for i:=1 to Len(aValues)
			if !Empty(aValues[i,9]) .and.AScanExact(aAccNbr,AllTrim(aValues[i,9]))=0
				AAdd(aAccNbr,AllTrim(aValues[i,9]))
			endif
		next
		//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,transid,fromrpp 
		oSel:=SqlSelect{"select group_concat(gr.accid,';',gr.accnumber separator '##') as graccs from (select cast(accid as char) as accid,accnumber from account where accnumber in ("+Implode(aAccNbr,',')+")) as gr group by 1=1",oConn}
		if oSel:RecCount>0
			AEval(Split(oSel:graccs,'##'),{|x|AAdd(aAcc,Split(x,';'))})  //{accid,accnumber},...
		endif  
		
		// avalues: transdate,docid,transactnr,descriptn,giver,debitamnt,creditamnt,accname,accountnr,assmntcd,externid,origin,processed
		//              1        2      3            4      5      6          7        8         9       10      11       12       13
		for i:=1 to Len(aValues) step 2
			if !Empty(aValues[i,11])   // externid filled
				if (nPers:=AScanExact(aPersExt,AllTrim(aValues[i,11])))=0
					AAdd(aPersExt,AllTrim(aValues[i,11]))
				endif
			endif
		next
		//		oSel:=SqlSelect{"select group_concat(gr.grpersid) as grpersids from (select cast(persid as char) as grpersid from person where persid in ("+cPersids+") and deleted=0) as gr group by 1=1",oConn}
   	ASort(aPersExt)
		oSel:=SqlSelect{"select group_concat(externid,';',persid separator '##') as grpers from (select externid,cast(persid as char) as persid from person where externid in ("+Implode(aPersExt,',')+') order by externid) as gr group by 1=1',oConn}
		if oSel:RecCount>0 
			// persons found, so transactions can be processed automatically: 
			AEval(Split(oSel:grpers,'##'),{|x|AAdd(aPers,Split(x,';'))})  //{externid,persid},...
			for i:=1	to	Len(aValues) step	2
				if	!Empty(aValues[i,9])	.and.!Empty(aValues[i,11])	  // account and externid giver filled
					if	(nPers:=AScan(aPers,{|x|x[1]==aValues[i,11]}))>0
						//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid
						nAcc:=AScan(aAcc,{|x| x[2]==aValues[i,9]})
						if	nAcc>0
							cBankaccId:=aAcc[nAcc,1] 
							nAcc:=AScan(aAcc,{|x| x[2]==aValues[i+1,9]})
							if	nAcc>0 
								//	first	from bank account:
								AAdd(aValuesTrans,{cBankaccId,aValues[i,6],aValues[i,6],aValues[i,7],aValues[i,7],sCURR,aValues[i,4],;
									aValues[i,1],aValues[i,10],LOGON_EMP_ID,'2','1',aValues[i,2],aValues[i,3],'',0})
								aValues[i,13]:=1	//	set importrans	to	processed 
								//	second transaction line	to	destination
								i++
								AAdd(aValuesTrans,{aAcc[nAcc,1],aValues[i,6],aValues[i,6],aValues[i,7],aValues[i,7],sCURR,aValues[i,4],;
									aValues[i,1],aValues[i,10],LOGON_EMP_ID,'2','2',aValues[i,2],aValues[i,3],aPers[nPers,2],0})	
								if	(nLastGift:=AScan(aValuesPers,{|x|x[1]=aPers[nPers,2]}))>0
									if	aValuesPers[nLastGift,2]<aValues[i,1]
										aValuesPers[nLastGift,2]:=aValues[i,1]
									endif
								else
									AAdd(aValuesPers,{aPers[nPers,2],aValues[i,1]})
								endif
								aValues[i,13]:=1	//	set importrans	to	processed
								i-- 
							endif
						endif
					endif
				endif
			next
			// prepare adapting mbalance values:
			oMBal:=Balances{}
			for i:=1 to Len(aValuesTrans) 
				//  1    2      3     4     5        6          7       8   9   10        11      12    13      14       15     16
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid 
				oMBal:ChgBalance(aValuesTrans[i,1],SQLDate2Date(aValuesTrans[i,8]),Val(aValuesTrans[i,2]),Val(aValuesTrans[i,4]),Val(aValuesTrans[i,3]),;
					Val(aValuesTrans[i,5]),aValuesTrans[i,6])
			next
		endif

		// start storing into database:
		
		oStmnt:=SQLStatement{"set autocommit=0",oConn}
		oStmnt:Execute()
		oStmnt:=SQLStatement{'lock tables `transaction` write,`importtrans` write,`mbalance` write'+iif(Len(aValuesPers)>0,',`person` write',''),oConn} 
		oStmnt:Execute()

		oStmnt:=SQLStatement{"insert into importtrans ("+;
			"transdate,docid,transactnr,descriptn,giver,debitamnt,creditamnt,accname,accountnr,assmntcd,externid,origin,processed) values "+Implode(aValues,"','"),oConn}
		oStmnt:Execute() 
		if oStmnt:NumSuccessfulRows<1
			SQLStatement{"rollback",oConn}:Execute()
			SQLStatement{"unlock tables",oConn}:Execute()
			LogEvent(self,"error:"+oStmnt:SQLString,"LogErrors")
			ErrorBox{,self:oLan:WGet('Transactions could not be imported')+":"+oStmnt:status:Description}:show()
			return false 
		else
			nCnt:=oStmnt:NumSuccessfulRows/2
		endif
		if !Empty(aValuesTrans) 
			// insert first line:
			oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference) "+;
				" values ("+Implode(aValuesTrans[1],"','",1,14)+')',oConn}
			oStmnt:Execute()
			nTransId:=ConI(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
			aValuesTrans[2,16]:=nTransId
			for i:=3 to Len(aValuesTrans) step 2
				nTransId++
				aValuesTrans[i,16]:=nTransId
				aValuesTrans[i+1,16]:=nTransId
			next
			oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid) "+;
				" values "+Implode(aValuesTrans,"','",2),oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				SQLStatement{"rollback",oConn}:Execute() 
				SQLStatement{"unlock tables",oConn}:Execute()
				LogEvent(self,"error:"+oStmnt:SQLString,"LogErrors")
				ErrorBox{,self:oLan:WGet('Transactions could not be inserted')+":"+oStmnt:status:Description}:show()
				return false
			else
				nProc:=(oStmnt:NumSuccessfulRows+1)/2
			endif
			if !oMBal:ChgBalanceExecute()
				SQLStatement{"rollback",oConn}:Execute() 
				SQLStatement{"unlock tables",oConn}:Execute()
				LogEvent(self,"error:"+oMBal:cError,"LogErrors")
				ErrorBox{,self:oLan:WGet('Month balances could not be updated')+":"+oMBal:cError}:show()
				return false 
			endif
			// update persons:
			if !Empty(aValuesPers)
				ASort(aValuesPers,1,,{|x,y|x[1]<=y[1]},)
				oStmnt:=SQLStatement{"insert into person (persid,datelastgift) values "+Implode(aValuesPers,"','")+" on duplicate key update mailingcodes="+;
					"if(datelastgift='0000-00-00',concat(mailingcodes,' ','FI'),mailingcodes),datelastgift=if(datelastgift<values(datelastgift),values(datelastgift),datelastgift)",oConn} 
				oStmnt:Execute()
			endif
		endif
		SQLStatement{"commit",oConn}:Execute()
		SQLStatement{"unlock tables",oConn}:Execute()
		self:lv_imported:=self:lv_imported+nCnt
		self:lv_processed+=nProc 
	else
		// allready loaded
		nCnt:=0
	endif
	return true
METHOD SkipBatch(dummy:=nil as logic) as void pascal CLASS ImportBatch
* Unlock batch 
SQLStatement{"update importtrans set lock_id=0 where transactnr='"+self:cCurBatchNbr+;
"' and origin='"+self:cCurOrigin+"' and transdate='"+SQLdate(self:dCurDate)+"'",oConn}:execute()
SQLStatement{"commit",oConn}:execute()
RETURN 
