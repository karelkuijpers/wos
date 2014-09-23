function ADDMLCodes(NewCodes as string, cCod ref string) as string pascal
	// add new mailing NewCodes to current string of mailing codes cCod
	LOCAL aPCod,aNCod as ARRAY, iStart as int
	if Empty(NewCodes)
		return cCod
	endif
	aPCod:=Split(AllTrim(cCod)," ")
	aNCod:=Split(AllTrim(NewCodes)," ")
	iStart:=Len(aPCod)
	
	ASize(aPCod,iStart+Len(aNCod))
	ACopy(aNCod,aPCod,1,Len(aNCod),iStart+1) 
	cCod:=MakeCod(aPCod)
	return cCod
	
Function AddSlashes(cString as string) as string
// add backslashes for special characters ',",\,%,_
return StrTran(StrTran(StrTran(cString,'\','\\'),"'","\'"),'"','\"')
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
Function aDiff(aArr1 as array,aArr2 as Array) as string
// determine difference between two arrays
Local i,j, L1:=Len(aArr1), L2:=Len(aArr2) as int 
Local cDif as string
if !L1==L2
	return "different size"
endif
for i:=1 to L1
	if !aArr1[i]==aArr2[i]
		cDif+=Str(i,-1)+": " 
		for j:=1 to Len(aArr1[i]) step 4
			if SubStr(aArr1[i],j,4)#SubStr(aArr2[i],j,4)
				cDif+= "pos "+Str(int(j/4+1),-1)+": "+Str2Hex(SubStr(aArr1[i],j,4))+" # "+Str2Hex(SubStr(aArr2[i],j,4))+"; "
			endif 
		next
		exit
	endif
next
return cDif
FUNCTION AskFileName(oWindow, pFileName,cMessage,aFilter, aFilterDesc,appendPossible )
// ask for filename and return Filespec with fullpath (or null_object)
// and appendPossible=false if not append
// appendPossible must be passed by reference (@)
//
local cDefFolder as string
local cFileName as string 
LOCAL lAppend as LOGIC
LOCAL oFileDialog as SaveAsDialog
LOCAL ToFileFS as Filespec
LOCAL oWarn as warningbox
Default(@aFilter,"*.*")
Default(@aFilterDesc,"All files")
Default(@cMessage,"Report to file")
IF !IsLogic(appendPossible)
	appendPossible:=FALSE
ENDIF
cFileName:=CleanFileName(StrTran(pFileName,'.',' '))  // make correct file name
DO WHILE true
	// Send up file dialog
	oFileDialog := SaveAsDialog{ oWindow, cFileName  }
	oFileDialog:SetStyle(OFN_HIDEREADONLY+OFN_LONGNAMES+OFN_EXPLORER)
	oFileDialog:SetFilter(aFilter, aFilterDesc,1)
	cDefFolder:=SQLSelect{"select docpath from sysparms",oConn}:DOCPATH
   if Empty(cDefFolder)
     	cDefFolder:=CurPath
   endif

	oFileDialog:InitialDirectory:=cDefFolder
	IF !oFileDialog:Show()
		exit
	ENDIF
	IF !Empty( oFileDialog:FileName )
		// Set the instance var...for later use...if Ok
		ToFileFS:=FileSpec{CleanFileName(oFileDialog:FileName)}
		cFileName:=ToFileFS:FullPath
		oFileDialog:Destroy()
		oFileDialog:=null_object
		if !cDefFolder==ToFileFS:Drive+ ToFileFS:Path
			if ToFileFS:Drive == SubStr(WorkDir(),1,2) .or.ToFileFS:Drive == CurDrive()+":"
				// save current location: 
				SQLStatement{"update sysparms set docpath='"+ ToFileFS:Drive+ ToFileFS:Path +"'",oConn}:execute()
			endif
		endif
	
		IF ToFileFS:Find()
			IF appendPossible
				oWarn := WarningBox{oWindow,cMessage,;
				'File'+AllTrim(cFileName)+' already exists; Append to it?'}
				oWarn:type := BOXICONQUESTIONMARK + BUTTONYESNO
				oWarn:Beep:=true
				IF (oWarn:Show() = BOXREPLYYES)
					lAppend:=true
					exit
				ELSE
					lAppend:=FALSE
				ENDIF
				oWarn:Message:="Overwrite " + AllTrim(cFileName + " ?")
				IF (oWarn:Show() = BOXREPLYYES) 
					FErase(ToFileFS:FullPath)
					//ToFileFS:Delete()
					exit
				ENDIF
			ELSE
				oWarn := WarningBox{oWindow,cMessage,;
				'File'+AllTrim(cFileName)+' already exists; Overwrite it?'}
				oWarn:type := BOXICONQUESTIONMARK + BUTTONYESNO
				oWarn:Beep:=true
				IF (oWarn:Show() = BOXREPLYYES)
					FErase(ToFileFS:FullPath)
					IF !ToFileFS:Find()			
						exit
					ENDIF
				ENDIF
			ENDIF
		ELSE
			exit
		ENDIF
	ELSE	
		exit
	ENDIF
ENDDO
IF appendPossible
	appendPossible:=lAppend
ENDIF
RETURN ToFileFS
FUNCTION asum(fu_array as array, fu_start:=1 as int, fu_end:=0 as int, fu_col:=0 as int ) as real8
*      Summing of an array array 
*
* fu_start: optional start element
* fu_end  : optional end element, default length of fu_array
* fu_col  : optional column number to sum in case of two dimensional array
*
LOCAL m_count as int ,m_sum as REAL8
// Default(@fu_start,1)
// Default(@fu_end,ALen(fu_array)) 
// Default(@fu_col,0)
if Empty(fu_end)
	fu_end:=ALen(fu_array)
endif
m_count:=fu_end-fu_start+1
if Empty(fu_col)
	AEval(fu_array,{|x|m_sum:=Round(m_sum+x,DecAantal)},fu_start,m_count)
else
	AEval(fu_array,{|x|m_sum:=Round(m_sum+x[fu_col],DecAantal)},fu_start,m_count)
endif
RETURN(Round(m_sum,DecAantal))
Function BeginOfMonth(DateInMonth as date) as date
// get date at begin of month given by DateInMonth
return Getvaliddate(1,Month(DateInMonth),Year(DateInMonth)) 
DEFINE CHECKBX:=1
function CheckConsistency(oWindow as object,lCorrect:=false as logic,lShow:=false as logic,cFatalError:='' ref string) as logic 
	local nFromYear,i as dword
	local oStmnt as SQLStatement
	local oSel as SQLSelect
	local cError as string
	local lTrMError,lFatal as logic
	local aMBal:={},aMBalF:={} as array   // array with corrections of Mbalance {{accid,year,month,deb,cre},...}
	local time1,time0 as float
	nFromYear:=Year(LstYearClosed)*12+Month(LstYearClosed)  
	if lShow
		oMainWindow:Pointer := Pointer{POINTERHOURGLASS} 
	endif
// 	oMainWindow:STATUSMESSAGE("Checking consistency financial data"+'...')

	*	Select only monthbalances in years after last balance year for standard currency: 
	time0:=Seconds()
	oStmnt:=SQLStatement{"drop temporary table if exists transsum",oConn}
	oStmnt:Execute()
	oSel:=SQLSelect{"create temporary table transsum as select accid,year(dat) as year,month(dat) as month,round(sum(deb),2) as debtot,round(sum(cre),2) as cretot from transaction group by accid,year(dat),month(dat) order by accid,dat",oConn}
	oSel:Execute()
//       time1:=time0
//       LogEvent(,"transsum:"+Str((time0:=Seconds())-time1,-1),"logsql")
	oSel:=SQLSelect{"alter table transsum add unique (accid,year,month)",oConn}
	oSel:Execute()                                                                                    
//       time1:=time0
//       LogEvent(,"transsum index:"+Str((time0:=Seconds())-time1,-1),"logsql")
	oSel:=SqlSelect{"select m.accid,m.deb,m.cre,m.month,m.year,t.debtot,t.cretot,a.accnumber from mbalance m left join transsum t on (m.accid=t.accid and m.year=t.year and m.month=t.month) left join account a on (a.accid=m.accid) where (t.debtot IS NULL and t.cretot IS NULL and (m.deb<>0 or m.cre<>0) or (m.deb<>t.debtot or m.cre<>t.cretot)) and (m.year*12+m.month)>="+Str(nFromYear,-1)+" and m.currency='"+sCurr+"'",oConn}
	oSel:Execute()
	if oSel:RECCOUNT>0
		cError:="No correspondence between transactions and month balances per account"+CRLF
		lTrMError:=true
		do while !oSel:EoF
			cError+=Space(4)+"Account:"+Transform(oSel:accnumber,"")+"("+sCurr+") month:"+Str(oSel:Year,-1)+StrZero(oSel:Month,2)+" Tr.deb:"+Transform(oSel:debtot,"")+" cre:"+Transform(oSel:cretot,"")+"; mbal deb:"+Transform(oSel:deb,"")+" cre:"+Transform(oSel:cre,"")+CRLF
			aadd(aMBal,{oSel:accid,oSel:year,oSel:month,iif(empty(oSel:debtot),0.00,oSel:debtot),iif(empty(oSel:cretot),0.00,oSel:cretot)}) 
			oSel:Skip()
		enddo 
	endif
//       time1:=time0
//       LogEvent(,"transsum <->mbalance:"+Str((time0:=Seconds())-time1,-1),"logsql")
	oSel:=SqlSelect{"select t.accid,m.deb,m.cre,t.year,t.month,t.debtot,t.cretot,a.accnumber from transsum t left join mbalance m  on (m.accid=t.accid and m.year=t.year and m.month=t.month and m.currency='"+sCurr+"') left join account a on (a.accid=t.accid) where (m.deb IS NULL and m.cre IS NULL and (t.debtot<>0 or t.cretot<>0)) and (t.year*12+t.month)>="+Str(nFromYear,-1),oConn}
	if oSel:RECCOUNT>0
		if Empty(cError)
			cError:="No correspondence between transactions and month balances per account"+CRLF
		endif
		lTrMError:=true
		do while !oSel:EoF
			cError+=Space(4)+"Account:"+Transform(oSel:accnumber,"")+"("+sCurr+") month:"+Str(oSel:Year,-1)+StrZero(oSel:Month,2)+" Tr.deb:"+Transform(oSel:debtot,"")+" cre:"+Transform(oSel:cretot,"")+"; mbal deb:"+Transform(oSel:deb,"")+" cre:"+Transform(oSel:cre,"")+CRLF 
			aadd(aMBal,{oSel:accid,oSel:year,oSel:month,oSel:debtot,oSel:cretot}) 
			oSel:Skip()
		enddo
	endif
//       time1:=time0
//       LogEvent(,"transsum <->mbalance2:"+Str((time0:=Seconds())-time1,-1),"logsql")
	
	// Idem for foreign currencies:
	*	Select only monthbalances in years after last balance year for foreign currency:
	oStmnt:=SQLStatement{"drop temporary table if exists transsumf",oConn}
	oStmnt:Execute()
	oSel:=SQLSelect{"create temporary table transsumf as select accid,year(dat) as year,month(dat) as month,round(sum(debforgn),2) as debtot,round(sum(creforgn),2) as cretot from transaction where currency<>'"+sCurr+"' group by accid,year(dat),month(dat) order by accid,dat",oConn}
	oSel:Execute()
//       time1:=time0
//       LogEvent(,"transsumf:"+Str((time0:=Seconds())-time1,-1),"logsql")
	oSel:=SQLSelect{"alter table transsumf add unique (accid,year,month)",oConn}
	oSel:Execute()                                                                                    
//       time1:=time0
//       LogEvent(,"transsumf index:"+Str((time0:=Seconds())-time1,-1),"logsql")
	oSel:=SqlSelect{"select m.accid,m.deb,m.cre,m.year,m.month,m.year,cast(m.`currency` as char) as currency,t.debtot,t.cretot,a.accnumber from mbalance m left join transsumf t on (m.accid=t.accid and m.year=t.year and m.month=t.month) left join account a on (a.accid=m.accid) where (t.debtot IS NULL and t.cretot IS NULL and (m.deb<>0 or m.cre<>0) or (m.deb<>t.debtot or m.cre<>t.cretot)) and (m.year*12+m.month)>="+Str(nFromYear,-1)+" and m.currency<>'"+sCurr+"'",oConn}
	oSel:Execute()
	if oSel:RECCOUNT>0
		if Empty(cError)
			cError:="No correspondence between transactions and month balances per account"+CRLF
		endif
		lTrMError:=true
		do while !oSel:EoF
			cError+=Space(4)+"Account:"+oSel:accnumber+"("+oSel:currency+") month:"+Str(oSel:Year,-1)+StrZero(oSel:Month,2)+" Tr.deb:"+Transform(oSel:debtot,"")+" cre:"+Transform(oSel:cretot,"")+"; mbal deb:"+Transform(oSel:deb,"")+" cre:"+Transform(oSel:cre,"")+CRLF
			AAdd(aMBalF,{oSel:accid,oSel:Year,oSel:Month,iif(Empty(oSel:debtot),0.00,oSel:debtot),iif(Empty(oSel:cretot),0.00,oSel:cretot),oSel:Currency}) 
			oSel:Skip()
		enddo
	endif
//       time1:=time0
//       LogEvent(,"transsum <->mbalance3:"+Str((time0:=Seconds())-time1,-1),"logsql")
	oSel:=SqlSelect{"select a.accid,m.deb,m.cre,t.year,t.month,t.debtot,t.cretot,a.accnumber,a.`currency` from account a,transsumf t left join mbalance m  on (m.year=t.year and m.month=t.month and m.accid=t.accid and m.currency<>'"+sCurr+"') where a.accid=t.accid and a.currency<>'"+sCurr+"' and a.multcurr=0 and (m.deb IS NULL and m.cre IS NULL and (t.debtot<>0 or t.cretot<>0)) and (t.year*12+t.month)>="+Str(nFromYear,-1),oConn}
	if oSel:RECCOUNT>0
		if Empty(cError)
			cError:="No correspondence between transactions and month balances per account"+CRLF
		endif
		lTrMError:=true
		do while !oSel:EoF
			cError+=Space(4)+"Account:"+oSel:accnumber+"("+oSel:currency+") month:"+Str(oSel:Year,-1)+StrZero(oSel:Month,2)+" Tr.deb:"+Str(oSel:debtot,-1)+" cre:"+Str(oSel:cretot,-1)+"; mbal deb:"+Transform(oSel:deb,"")+" cre:"+Transform(oSel:cre,"")+CRLF 
			AAdd(aMBalF,{oSel:accid,oSel:Year,oSel:Month,oSel:debtot,oSel:cretot,oSel:Currency}) 
			oSel:Skip()
		enddo
	endif
//       time1:=time0
//       LogEvent(,"transsum <->mbalance4:"+Str((time0:=Seconds())-time1,-1),"logsql")
	
	oSel:=SQLSelect{"select sum(cre-deb) as totdebcre from transaction",oConn}
	oSel:Execute()
//       time1:=time0
//       LogEvent(,"Transactions not balanced:"+Str((time0:=Seconds())-time1,-1),"logsql")
// 	if !oSel:totdebcre==0.00
	if !Empty(oSel:totdebcre)
		cError+="Transactions not balanced for "+sCurr+":"+Str(oSel:totdebcre,-1)+CRLF 
		cFatalError+="Transactions not balanced for "+sCurr+":"+Str(oSel:totdebcre,-1)+CRLF 
	endif
	oSel:=SqlSelect{"select sum(cre-deb) as totdebcre from mbalance where currency='"+sCurr+"' and (year*12+month)>="+Str(nFromYear,-1),oConn}
	oSel:Execute()
//       time1:=time0
//       LogEvent(,"Montbalances not balanced:"+Str((time0:=Seconds())-time1,-1),"logsql")
// 	if !oSel:totdebcre==0.00
	if !Empty(oSel:totdebcre)
		cError+="Month balances not balanced for "+sCurr+":"+Str(oSel:totdebcre,-1)+CRLF
		lTrMError:=true
	endif
	oSel:=SQLSelect{"select transid,dat from transaction group by transid having sum(cre-deb)<>0 order by transid",oConn}
	oSel:Execute()
	if oSel:RECCOUNT>0
		cError+="Not all transactions are balanced for "+sCurr+":"+CRLF
		cFatalError+="Not all transactions are balanced for "+sCurr+":"+CRLF
		do while !oSel:EoF
			cError+=Space(4)+"Transaction:"+Str(oSel:transid,-1)+" date:"+DToC(oSel:dat)+CRLF 
			cFatalError+=Space(4)+"Transaction:"+Str(oSel:transid,-1)+" date:"+DToC(oSel:dat)+CRLF 
			lFatal:=true
			oSel:Skip()
		enddo
	endif
//       time1:=time0
//       LogEvent(,"Check concistency:"+Str((time0:=Seconds())-time1,-1),"logsql")
	if lShow
		oMainWindow:Pointer := Pointer{POINTERARROW} 
	endif
	if Empty(cError) 
		oMainWindow:STATUSMESSAGE(Space(100))
		if lShow
			TextBox{,"Checking consistency financial data","all data are correct"}:Show()
		endif
		return true
	else
		LogEvent(oWindow,cError,"LogErrors")
		if lShow
			TextBox{,"Checking consistency financial data: correspondence transactions and month balances, each transaction balanced",SubStr(cError,1,3000)}:Show()
			lCorrect:=false
			if lTrMError
				lCorrect:=(TextBox{,"Checking consistency financial data",'Should balances be corrected?',BUTTONYESNO}:Show()=BOXREPLYYES) 
			endif
		endif
		if	lTrMError .and.lCorrect
			if lShow
				oMainWindow:Pointer := Pointer{POINTERHOURGLASS} 
			endif
			for i:=1 to Len(aMBal)
				oStmnt:=SQLStatement{"update mbalance set deb="+Str(aMBal[i,4],-1)+",cre="+Str(aMBal[i,5],-1)+;
					" where accid="+Str(aMBal[i,1],-1)+" and year="+Str(aMBal[i,2],-1)+" and month="+Str(aMBal[i,3],-1),oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows<1
					// insert new one
					oStmnt:=SQLStatement{"insert into mbalance set accid="+Str(aMBal[i,1],-1)+",year="+Str(aMBal[i,2],-1)+",month="+Str(aMBal[i,3],-1)+",currency='"+;
						sCurr+"',deb="+Str(aMBal[i,4],-1)+",cre="+Str(aMBal[i,5],-1),oConn}
					oStmnt:Execute()
				endif				
			next
			for i:=1 to Len(aMBalF)
				oStmnt:=SQLStatement{"update mbalance set deb="+Str(aMBalF[i,4],-1)+",cre="+Str(aMBalF[i,5],-1)+;
					" where accid="+Str(aMBalF[i,1],-1)+" and year="+Str(aMBalF[i,2],-1)+" and month="+Str(aMBalF[i,3],-1)+" and currency='"+aMBalF[i,6]+"'",oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows<1
					// insert new one
					oStmnt:=SQLStatement{"insert into mbalance set accid="+Str(aMBalF[i,1],-1)+",year="+Str(aMBalF[i,2],-1)+",month="+Str(aMBalF[i,3],-1)+",currency='"+;
						aMBalF[i,6]+"',deb="+Str(aMBalF[i,4],-1)+",cre="+Str(aMBalF[i,5],-1),oConn}
					oStmnt:Execute()
				endif				
			next
			if lShow
				oMainWindow:Pointer := Pointer{POINTERARROW} 
			endif
// 			if !lFatal
// 				return true    // after correction correct
// 			endif
		endif
		oMainWindow:STATUSMESSAGE(Space(100))
	endif
	return false
Function ChgBalance(pAccount as string,pRecordDate as date,pDebAmnt as float,pCreAmnt as float,pDebFORGN as float,pCreFORGN as float,Currency as string)  as logic
	******************************************************************************
	*              Update of month balance values per account
	*					Should be used between Start transaction and commit and  
	*              record to be changed should be locked for update beforehand                                        
	*  Auteur    : K. Kuijpers
	*  Date      : 21-09-2011
	******************************************************************************
	*
	local cValues as string 
	local oStmnt as SQLStatement
	local oMBal,oAcc as SQLSelect
	local lError as logic 
	IF !Empty(pDebAmnt).or.!Empty(pCreAmnt)
		// insert new one/update existing 
		if !Currency==sCurr
			if Empty(currency) .or. len(currency)<>3 
				Currency:=sCurr
			else
				SEval(Currency,{|c|lError:=iif(c<65 .or. c>90,true,lError)})
				if lError
					Currency:=sCurr
				endif
			endif
		endif
		if !(pDebAmnt==0.00.and.pCreAmnt==0.00)
			cValues:="("+pAccount+","+Str(Year(pRecordDate),-1)+","+Str(Month(pRecordDate),-1)+",'"+sCurr+"',"+Str(pDebAmnt,-1)+","+Str(pCreAmnt,-1)+")"
		endif 
		if !Currency==sCurr
			if !(pDebFORGN==pDebAmnt.and. pCreFORGN==pCreAmnt)
				if !(pDebFORGN==0.00.and.pCreFORGN=0.00)
					cValues+=iif(Empty(cValues),'',",")+"("+pAccount+","+Str(Year(pRecordDate),-1)+","+Str(Month(pRecordDate),-1)+",'"+Currency+"',"+Str(pDebFORGN,-1)+","+Str(pCreFORGN,-1)+")"
				endif
			endif
		endif
		if !Empty(cValues)
			oStmnt:=SQLStatement{"INSERT INTO mbalance (`accid`,`year`,`month`,`currency`,`deb`,`cre`) VALUES "+cValues+;
				" ON DUPLICATE KEY UPDATE deb=round(deb+values(deb),2),cre=round(cre+values(cre),2)",oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:status)
				LogEvent(,"ChgBalance error:"+oStmnt:Status:description+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
				return false
			endif
		endif
	endif
	RETURN true
Function CleanFileName(cFileName as string) as string
// removes illegal characters from cFileName to return a for Windows acceptable file name:
LOCAL oFileSpec as Filespec
oFileSpec:=FileSpec{cFileName}
oFileSpec:FileName:=AllTrim(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(oFileSpec:FileName,'"',''),'/',' '),'\',' '),'?',' '),':',''),'*',''),'<',''),'>',''))
if (!empty(oFileSpec:Extension) .and.oFileSpec:Extension $ cFileName) .or. (!empty(oFileSpec:Path) .and.oFileSpec:Path $ cFileName)
	return oFileSpec:FullPath
else
	return oFileSpec:FileName
endif
			
Function CompareKeyString(aKeyW as array, cValue as string ) as logic  
	// compare if each of given keywords in aKey is contained in string cValue
	Local i, lK  as int
	local lKeyFound as logic
	lK:=Len(aKeyW)
	for i:=1 to lK 
		if !Empty(aKeyW[i]) .and.AtC(aKeyW[i],cValue)=0
			return false
		endif
	next
	return true      
FUNCTION Comparr(aStruct1 as array,aStruct2 as array) as logic
	// compare equality of two arrays
	LOCAL nLen2:=ALen(aStruct2),nLen1:=ALen(aStruct1),i as int
	IF nLen2==nLen1
		FOR i=1 to nLen1
			if IsArray(aStruct1[i])
				if IsArray(aStruct2[i])
					if !Comparr(aStruct1[i],aStruct2[i])
						return false
					endif
				else
					return false
				endif
			else
				if !aStruct1[i]==aStruct2[i]
					return false
				endif
			endif
		NEXT
	ELSE
		return false
	ENDIF
	RETURN true
FUNCTION Compress(f_tekst as string) as string
** Compress redundant spaces
****
IF Empty(f_tekst)
	RETURN null_string
ENDIF
f_tekst:=AllTrim(StrTran(f_tekst,CHR(160),Space(1)))         // replace non-breaking space with normal space
DO WHILE At("  ",f_tekst)>0
   f_tekst:=StrTran(f_tekst,"  "," ")
ENDDO
RETURN AllTrim(f_tekst)
function ConI(uValue as usual) as int
// convert usual to int
return iif(Empty(uValue),0,iif(IsNumeric(uValue),int(uValue),iif(IsLogic(uValue),1, Val(uValue))) )
function ConL(uValue as usual) as logic
// convert usual to logic
if IsLogic(uValue)
	return uValue
endif
return iif(uValue==iif(IsNumeric(uValue),1,'1'),true,false)
function ConS(uValue as usual) as string
	// convert usual to string 
	local cRet as string
	if !IsNil(uValue) .and.!IsArray(uValue) .and.!IsObject(uValue) .and. !IsCodeBlock(uValue)
		cRet:= AllTrim(Transform(uValue,""))
		if SubStr(cRet,-3)=='.00'
			cRet:=substr(cRet,1,len(cRet)-3)    // make integer
		endif
	endif
	return cRet
Function Correspondence(Str1 as string, Str2 as string) as int
// determine percentage correspondence of Str2 to Str1 
Local i, Len1, Len2, MinL, Score, Divdr as int
Str1:=Lower(AllTrim(Str1))
Str2:=Lower(AllTrim(Str2))
Len1:=Len(Str1)
Len2:=Len(Str2)
Divdr:=Max(Len1,Len2)
if Divdr=0
	return 0  // apparently both empty
endif
MinL:=Min(Len1,Len2)
for i:=1 to MinL
	if !SubStr(Str2,i,1)==SubStr(Str1,i,1) 
		exit
	endif
	Score++
next
Score:=(Score*100)/Divdr
return Score
DEFINE COUPLE := 3
DEFINE CR                   := _chr(12) 
FUNCTION dat_controle(m_date as date, m_no_message:=false as logic)
* This functie check if give date  is valid
* m_no_message: true: no error message shown but returned returned
*               false: error message shown and true/false returned
LOCAL dat_message:="" as STRING
IF m_date < MinDate
    dat_message := 'Entering of records in closed year not allowed'
ELSEIF m_date > Today() + 31
    dat_message := 'Date more than 1 month from now not allowed'
ENDIF
IF .not.Empty(dat_message)
   IF Empty(m_no_message)
		(ErrorBox{,dat_message}):show()
      RETURN FALSE
   ELSE
      RETURN dat_message
   ENDIF
ELSE
   IF Empty(m_no_message)
      RETURN true
   ELSE
      RETURN ""
   ENDIF
ENDIF
CLASS DataBrowserExtra INHERIT Databrowser
CLASS DataDialogMine inherit DataDialog
	EXPORT aMemHome:={} as ARRAY
	EXPORT aMemNonHome:={} as ARRAY
	EXPORT aProjects:={} as ARRAY
	Export oLan as Language 
	
// 	declare method FillMbrProjArray
METHOD Close(oEvent)  CLASS DataDialogMine
	// force garbage collection
	self:Destroy()
	RETURN SUPER:Close(oEvent)
METHOD FillMbrProjArray() CLASS DataDialogMine 
// Fill 3 arrays: home members, non home members, projects
FillMbrProjArray(self:aProjects,self:aMemHome,self:aMemNonHome)
return
method IsSelectButton() class datawindow 
// check if select button in datawindow is available
	LOCAL oErr 		as USUAL
	LOCAL bOldErr 	as CODEBLOCK
	bOldErr := ErrorBlock({|oErr|_Break(oErr)})
	begin sequence
		if self:oCCOKButton:isvisible()
			if self:oCCOKButton:IsEnabled()
				return true
			endif
		endif
		return false
	end sequence 
	ErrorBlock(bOldErr)
	return false


CLASS DataWindowExtra INHERIT DataWindow
*	PROTECT uControlValue AS USUAL
*	PROTECT cControlName AS STRING
EXPORT lImport,lExists as LOGIC
PROTECT lNew as LOGIC
PROTECT lImportAutomatic:=true as LOGIC // In case of General Import: no asking for confirmation per record
EXPORT lImportFile as LOGIC
Export oLan as Language
protect nFindRec as int, aKeyW as array 
protect cFindText as string
declare method CompareKeyWords
                         
METHOD Close(oEvent)  CLASS DataWindowExtra
	IF self:lImport
		IF Used()
			DBCLOSEAREA()
		ENDIF
		self:lImport:=FALSE
		self:Pointer := Pointer{POINTERARROW}
	ENDIF
	self:Destroy()
	if DynInfoFree() <  134217728 // 128 MB
		// force garbage collection
		CollectForced()
		IF !_DynCheck()
			(errorbox{,"memory error:"+Str(DynCheckError())+" in window:"+SELF:Caption}):show()
		ENDIF   
	endif
	RETURN SUPER:Close(oEvent)
method CompareKeyWords(aValue as array) as logic class DataWindowExtra 
// compare if each of given keywords in aKeyW is contained in array aValue
Local i,j, lK:=Len(self:aKeyW), lV:=Len(aValue) as int
Local lKeyFound as logic
for i:=1 to lK
	lKeyFound:=false
	for j:=1 to lV
		if AtC(self:aKeyW[i,1],aValue[j])>0
			lKeyFound:=true
		endif
	next
	if !lKeyFound
		return false
	endif
next
return true
method EditChange(oControlEvent) class DataWindowExtra
	local oControl as Control
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	super:EditChange(oControlEvent)
	//Put your changes here 
	if !IsNil(oControl:TextValue)
		if oControl:Name=="FINDTEXT" .and. !oControl:TextValue== self:cFindText
			self:oCCFindNext:Caption:="Find" 
			self:oCCFindNext:Show()
			self:oCCFindPrevious:hide()
			self:cFindText:=oControl:TextValue
			self:nFindRec:=0
			self:STATUSMESSAGE("",MESSAGEPERMANENT)
		endif
	endif
	return nil

method Find() class DataWindowExtra 
self:oDCGroupBoxFind:show()
self:oDCFindText:show() 
self:oDCFindText:ToolTipText:="Enter one or more keywords the record searched for should contain" 
self:oDCFindText:value:=""
self:oCCFindClose:show()
self:oCCFindNext:show()
self:oCCFindNext:Caption:="Find"
self:oCCFindPrevious:hide()
self:oDCFindText:value:=""
self:nFindRec:=0
self:oDCFindText:SetFocus()
return 
METHOD FindClose( ) CLASS DataWindowExtra 
self:oDCGroupBoxFind:Hide()
self:oDCFindText:Hide()
self:oCCFindClose:Hide()
self:oCCFindNext:Hide()
self:oCCFindPrevious:Hide()

RETURN nil 
method SetWidth(w) class DataWindowExtra
LOCAL myDim as Dimension
	myDim:=self:Size
	myDim:Width:=w
	self:Size:=myDim
 return
CLASS DataWindowMine INHERIT DataWindow
	EXPORT aMemHome:={} as ARRAY
	EXPORT aMemNonHome:={} as ARRAY
	EXPORT aProjects:={} as ARRAY
	Export oLan as Language 
	
// 	declare method FillMbrProjArray
// CLASS DataDialogMine INHERIT DataDialog
// 	EXPORT aMemHome:={} as ARRAY
// 	EXPORT aMemNonHome:={} as ARRAY
// 	EXPORT aProjects:={} as ARRAY
// 	Export oLan as Language 
// 	declare method FillMbrProjArray
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

METHOD FillMbrProjArray() CLASS DataWindowMine  
// Fill 3 arrays: home members, non home members, projects
FillMbrProjArray(self:aProjects,self:aMemHome,self:aMemNonHome)
return
DEFINE DATEFIELD:=3
CLASS DateStandard INHERIT DATETIMEPICKER
	* Standard date for normal use
METHOD INIT(oOwner, nResourceID) CLASS DATEStandard
local currdate:=Today() as date, cY,cM as int
	SUPER:INIT(oOwner, nResourceID)
	cY:=Year(currdate)
	cM:=Month(currdate) +1
	if cM>12
		cY++
		cM:=1
	endif
	currdate:=SToD(Str(cY,4)+StrZero(cM,2)+Str(MonthEnd(cM,cY),2)) // ultimo next month
	
	self:DateRange:=DateRange{MinDate,currdate}
	self:SelectedDate:=Today()

	RETURN self
ACCESS Value CLASS DateStandard
	RETURN  self:SelectedDate
ASSIGN VALUE(uValue) CLASS DateStandard
	RETURN  self:SelectedDate:= uValue
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
CLASS Description INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD INIT() CLASS Description
    LOCAL   cPict                   as STRING

    SUPER:INIT( HyperLabel{#Description, "Description", "", "" },  "C", 256, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        self:Picture := cPict
    ENDIF

    RETURN self
Class DialogWinDowExtra inherit DialogWindow 
Export oLan as Language
METHOD Close(oEvent)  CLASS DialogWinDowExtra
	// force garbage collection
	self:Destroy()
	RETURN SUPER:Close(oEvent)
method SetWidth(w) class DialogWinDowExtra
LOCAL myDim as Dimension
	myDim:=self:Size
	myDim:Width:=w
	self:Size:=myDim
return
DEFINE DROPDOWN:=2
METHOD Dispatch(oEvent) CLASS Edit
	// Deze wordt later uitgevoerd
	IF oEvent:Message==CN_KILLFOCUS
		self:EditSELECT()
	ENDIF
	RETURN SUPER:Dispatch(oEvent)
METHOD EditSELECT() CLASS Edit

	IF !IsNil(self:VALUE)
		IF IsNumeric(self:VALUE)
			// Selecteer het hele veld
			self:Selection	:= Selection{0,Len(self:CurrentText)}

		ELSEIF IsString(self:VALUE) .and. Empty(self:currenttext)
			// Alleen als niet gevuld is
			self:Selection	:= Selection{0,0}

		ELSEIF IsDate(self:VALUE) .and. Empty(CToD(self:currenttext))
			// Alleen als niet gevuld is
			self:Selection	:= Selection{0,0}
		ENDIF
	ELSE
		self:Selection	:= Selection{0,0}
	ENDIF
CLASS EditBrowser INHERIT DataBrowser
METHOD CellDoubleClick() CLASS EditBrowser
	if self:Owner:Owner:IsSelectButton() 
		self:Owner:Owner:OKButton()
		return nil
	endif
	self:Owner:Owner:EditButton(FALSE)
	RETURN nil
Function EndOfMonth(DateInMonth as date) as date
// get date of end of month given a certain date
return SToD(Str(Year(DateInMonth),4,0)+StrZero(Month(DateInMonth),2,0)+StrZero(MonthEnd(Month(DateInMonth),Year(DateInMonth)),2,0))
DEFINE FEMALE := 1
function FileStart(cFilename as string, OwnerWindow as Window, cParameters:='' as string ) as dword
	// start application for processing given filename, e.g word document 
	LOCAL lpShellInfo is _winShellExecuteInfo
	LOCAL hProc as ptr
	LOCAL lpExitCode as DWORD
	LOCAL lRunning as LOGIC

	lpShellInfo.cbSize := _sizeof( _winSHELLEXECUTEINFO )
	lpShellInfo.hwnd := OwnerWindow:Handle()
	lpShellInfo.lpVerb := String2Psz("open")
	lpShellInfo.lpFile := String2Psz( cFilename )
	lpShellInfo.lpParameters := String2Psz( cParameters )
	lpShellInfo.nShow := SW_ShowNormal
	lpShellInfo.fMask := SEE_MASK_NOCLOSEPROCESS
	
	IF ShellExecuteEx( @lpShellInfo )
		hProc := lpShellInfo.hProcess
		GetExitCodeProcess( hProc, @lpExitCode )
		lRunning := ( lpExitCode == STILL_ACTIVE )
		WHILE lRunning
			GetExitCodeProcess( hProc, @lpExitCode )
			lRunning := ( lpExitCode == STILL_ACTIVE )
			Yield()
		END
	END				

	RETURN lpExitCode
Function FillBalYears() 
// Returns available balance years:
local oSel as SQLSelect
local cYearMonth as string 
GlBalYears:={} 
AAdd(GlBalYears,{LstYearClosed,"transaction"})
oSel:=SQLSelect{"select yearstart,monthstart from balanceyear order by yearstart desc,monthstart desc",oConn}
if oSel:RecCount>0
	do while !oSel:EOF
		cYearMonth:=Str(oSel:YEARSTART,4,0)+StrZero(oSel:MONTHSTART,2,0)
		AAdd(GlBalYears,{SToD(cYearMonth+"01"),'tr'+cYearMonth})
		oSel:Skip()
	enddo
endif
GlBalYears:=DynToOldSpaceArray(GlBalYears)  // to avoid that they are moved around in dynamic memory and reduce use of dymamic memory

return
Function FillCountryNames() 
local oLan:=Language{} as Language
CountryNames:={{"AT",oLan:wget("Austria")},;
{"PT",oLan:wget("Azores")},;
{"BE",oLan:wget("Belgium")},;
{"BG",oLan:wget("Bulgaria")},;
{"ES",oLan:wget("Canary Islands")},;
{"CY",oLan:wget("Cyprus")},;
{"CZ",oLan:wget("Czech Republic")},;
{"DK",oLan:wget("Denmark")},;
{"EE",oLan:wget("Estonia")},;
{"FI",oLan:wget("Finland")},;
{"FR",oLan:wget("France")},;
{"GF",oLan:wget("French Guiana")},;
{"DE",oLan:wget("Germany")},;
{"GI",oLan:wget("Gibraltar")},;
{"GR",oLan:wget("Greece")},;
{"GP",oLan:wget("Guadeloupe")},;
{"HU",oLan:wget("Hungary")},;
{"is",oLan:wget("Iceland")},;
{"IE",oLan:wget("Ireland")},;
{"IT",oLan:wget("Italy")},;
{"LV",oLan:wget("Latvia")},;
{"LI",oLan:wget("Liechtenstein")},;
{"LT",oLan:wget("Lithuania")},;
{"LU",oLan:wget("Luxembourg")},;
{"PT",oLan:wget("Madeira")},;
{"MT",oLan:wget("Malta")},;
{"MQ",oLan:wget("Martinique")},;
{"YT",oLan:wget("Mayotte")},;
{"MC",oLan:wget("Monaco")},;
{"NL",oLan:wget("Netherlands")},;
{"NO",oLan:wget("Norway")},;
{"PL",oLan:wget("Poland")},;
{"PT",oLan:wget("Portugal")},;
{"RE",oLan:wget("R‚union")},;
{"RO",oLan:wget("Romania")},;
{"BL",oLan:wget("Saint Barth‚lemy")},;
{"MF",oLan:wget("Saint Martin (French part)")},;
{"PM",oLan:wget("Saint Pierre and Miquelon")},;
{"SK",oLan:wget("Slovakia")}} 
CountryNames:=DynToOldSpaceArray(CountryNames)  // to avoid that they are moved around in dynamic memory and reduce use of dymamic memory


 


function FillIbanregistry()
// fill Iban-registry with {countrycode, iban-templatem iban length, sepa?},...
	iban_registry:= {{"AL","AL2!n8!n16!c",28,0},;
		{"AD","AD2!n4!n4!n12!c",24,0},;
		{"AT","AT2!n5!n11!n",20,1},;
		{"AZ","AZ2!n4!a20!c",28,0},;
		{"BH","BH2!n4!a14!c",22,0},;
		{"BE","BE2!n3!n7!n2!n",16,1},;
		{"BA","BA2!n3!n3!n8!n2!n",20,0},;
		{"BG","BG2!n4!a4!n2!n8!c",22,1},;
		{"CR","CR2!n3!n14!n",21,0},;
		{"HR","HR2!n7!n10!n",21,0},;
		{"CY","CY2!n3!n5!n16!c",28,1},;
		{"CZ","CZ2!n4!n6!n10!n",24,1},;
		{"DK","DK2!n4!n9!n1!n",18,1},;
		{"GL","DK2!n4!n9!n1!n",18,1},;
		{"FO","DK2!n4!n9!n1!n",18,1},;
		{"DO","DO2!n4!c20!n",28,0},;
		{"EE","EE2!n2!n2!n11!n1!n ",20,1},;
		{"FI","FI2!n6!n7!n1!n",18,1},;
		{"FR","FR2!n5!n5!n11!c2!n",27,1},;
		{"GE","GE2!n2!a16!n",22,0},;
		{"DE","DE2!n8!n10!n ",22,1},;
		{"GI","GI2!n4!a15!c: ",23,1},;
		{"GR","GR2!n3!n4!n16!c ",27,1},;
		{"GT","GT2!n4!c20!c ",28,0},;
		{"HU","HU2!n3!n4!n1!n15!n1!n ",28,1},;
		{"IS","IS2!n4!n2!n6!n10!n ",26,1},;
		{"IE","IE2!n4!a6!n8!n ",22,1},;
		{"IL","IL2!n3!n3!n13!n ",23,0},;
		{"IT","IT2!n1!a5!n5!n12!c",27,1},;
		{"KZ","KZ2!n3!n13!c",20,0},;
		{"KW","KW2!n4!a22!",30,0},;
		{"LV","LV2!n4!a13!c",21,1},;
		{"LB","LB2!n4!n20!c",28,0},;
		{"LI","LI2!n5!n12!c",21,1},;
		{"LT","LT2!n5!n11!n",20,1},;
		{"LU","LU2!n3!n13!c",20,1},;
		{"MK","MK2!n3!n10!c2!n",19,0},;
		{"MT","MT2!n4!a5!n18!c",31,1},;
		{"MR","MR135!n5!n11!n2!n",27,0},;
		{"MU","MU2!n4!a2!n2!n12!n3!n3!a",30,0},;
		{"MD","MD2!n2!a18!n",24,0},;
		{"MC","MC2!n5!n5!n11!c2!n",27,1},;
		{"ME","ME2!n3!n13!n2!n ",22,0},;
		{"NL","NL2!n4!a10!n",18,1},;
		{"NO","NO2!n4!n6!n1!n",15,1},;
		{"PK","PK2!n4!a16!c",24,0},;
		{"PL","PL2!n8!n16n",28,1},;
		{"PT","PT2!n4!n4!n11!n2!n",25,1},;
		{"RO","RO2!n4!a16!c",24,1},;
		{"SM","SM2!n1!a5!n5!n12!c",27,0},;
		{"SA","SA2!n2!n18!c",24,0},;
		{"RS","RS2!n3!n13!n2!n",22,0},;
		{"SK","SK2!n4!n6!n10!n",24,1},;
		{"SI","SI2!n5!n8!n2!n",19,0},;
		{"ES","ES2!n4!n4!n1!n1!n10!n",24,1},;
		{"SE","SE2!n3!n16!n1!n",24,1},;
		{"CH","CH2!n5!n12!c",21,1},;
		{"TN","TN592!n3!n13!n2!n",24,0},;
		{"TR","TR2!n5!n1!c16!c",26,0},;
		{"AE","AE2!n19!n",23,0},;  
	{"GB","GB2!n4!a6!n8!n",22,1},;
		{"VG","VG2!n4!a16!n",24,0} }
	iban_registry:=DynToOldSpaceArray(iban_registry)  // to avoid that they are moved around in dynamic memory and reduce use of dymamic memory
 
Function FillMailClient() as array
// return array with possible mail clients
return {{"Windows Mail/ Outlook Express",0},{"Microsoft Outlook",1},{"Mozilla Thunderbird",2},{"Windows Live Mail",3},{"Mapi2Xml",4}}
Function FillMbrProjArray(aProjects as array,aMemHome as array,aMemNonHome as array) as void pascal
LOCAL oSQL as SQLSelect

// Fill 3 arrays: home members, non home members, projects

// select projects:
oSQL:=SQLSelect{"select a.accnumber, a.description, a.accid,a.balitemid,a.department from account as a where a.active=1 and (a.giftalwd=1"+iif(Empty(SDON),""," or a.accid="+SDON)+;
iif(Empty(SPROJ),""," or a.accid="+SPROJ)+") and not exists (select m.mbrid from member m where m.accid=a.accid or m.depid=a.department) ",oConn}  
oSQL:Execute()

DO WHILE !oSQL:EOF
	AAdd(aProjects,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid,oSQL:balitemid,oSQL:department})
	oSQL:Skip()
ENDDO                                                                                               
// select home members: 
oSQL:=SqlSelect{"select ifnull(m.co,'') as co,a.accnumber, a.description, a.accid,a.balitemid,a.department from member as m left join department d ON (m.depid=d.depid) left join account as a ON (a.active=1 and (m.accid=a.accid or a.accid=d.incomeacc)) where m.homepp='"+SEntity+"' and a.accid is not null",oConn}
oSQL:Execute()
DO WHILE !oSQL:EOF
	IF oSQL:CO=="M"
		AAdd(aMemHome,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid,oSQL:balitemid,oSQL:department})
	ELSE
		// entities of own WO are regarded as projects:
		AAdd(aProjects,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid,oSQL:balitemid,oSQL:department})
	ENDIF
	oSQL:Skip()
ENDDO
//select nonhome members: 
oSQL:=SqlSelect{"select ifnull(m.co,'') as co,a.accnumber, a.description, a.accid,a.balitemid,a.department from member as m left join department d ON (m.depid=d.depid) left join account as a ON (a.active=1 and (m.accid=a.accid or a.accid=d.incomeacc)) where m.homepp<>'"+SEntity+"' and a.accid is not null",oConn}
oSQL:Execute()
DO WHILE !oSQL:EOF
	IF oSQL:CO=="M"
		AAdd(aMemNonHome,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid,oSQL:balitemid,oSQL:department})
	ELSE
		// entities of other WO are also regarded as projects:
		AAdd(aProjects,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid,oSQL:balitemid,oSQL:department})
	ENDIF
	oSQL:Skip()
ENDDO
return

FUNCTION FillPersCode ()
* Fill Array with description + code + abrv of Pers-codes
// LOCAL aPersCd := {}
LOCAL oMailCd as SQLSelect
pers_codes:={}
mail_abrv:={}
oMailCd := SQLSelect{"select pers_code,description,abbrvtn from perscod",oConn}
pers_codes:=oMailCd:GetLookupTable(500,#description,#PERS_CODE)
ASize(pers_codes,Len(pers_codes)+1)
AIns(pers_codes,1) 
pers_codes[1]:={' ',''}
oMailCd:GoTop()
mail_abrv:=oMailCd:GetLookupTable(500,#ABBRVTN,#PERS_CODE) 
ASize(mail_abrv,Len(mail_abrv)+1)
AIns(mail_abrv,1) 
mail_abrv[1]:={' ',''}
pers_codes:=DynToOldSpaceArray(pers_codes)  // to avoid that they are moved around in dynamic memory and reduce use of dymamic memory
mail_abrv:=DynToOldSpaceArray(mail_abrv)  // to avoid that they are moved around in dynamic memory and reduce use of dymamic memory

RETURN 
FUNCTION FillPersGender() as void pascal
* Fill global Arrays with gendertypes and salutations of a person 
local oLan as Language
oLan:=Language{}
pers_gender:=  {{oLan:WGet("female"),FEMALE},{oLan:WGet("male"),MASCULIN},{oLan:WGet("couple"),COUPLE},{oLan:WGet("non-person"),ORGANISATION},{oLan:WGet("unknown"),0}}
pers_salut:={;
{oLan:RGet("Mrs",,"!"),FEMALE},;
{oLan:RGet("Mr",,"!"),MASCULIN},;
{oLan:RGet("Mr&Mrs"),COUPLE},;
{"",ORGANISATION},;
{oLan:RGet("Mr/Mrs"),5}}
return
FUNCTION FillPersProp ()
	* Fill global Array pers_propextra with description + id of extra person properties
	LOCAL oPersProp as SQLSelect
	pers_propextra:={}
	oPersProp := SQLSelect{"SELECT `id`,`name`,`type`,`values` FROM `person_properties` order by `id`",oConn} 
	if oPersProp:RecCount>0
		DO WHILE !oPersProp:EOF
			AAdd(pers_propextra,{oPersProp:name, oPersProp:ID,oPersProp:type,Lower(oPersProp:VALUES)})
			oPersProp:Skip()
		ENDDO 
		pers_propextra:=DynToOldSpaceArray(pers_propextra)  // to avoid that they are moved around in dynamic memory and reduce use of dymamic memory

	endif
	RETURN 

FUNCTION FillPersTitle ()
	* Fill global Array pers_titles with description + id of Titles
	pers_titles:= SQLSelect{"select descrptn,id from titles",oConn}:GetLookupTable(100)
	RETURN 
FUNCTION FillPersType ()
* Fill global Array with description + id  and abbriviation, id
LOCAL oPersTp as SQLSelect
oPersTp:=SQLSelect{"select lower(descrptn) as descrptn,abbrvtn,id from persontype",oConn} 
Pers_Types:= oPersTp:GetLookupTable(500,#DESCRPTN,#ID) 
oPersTp:GoTop()
pers_types_abrv:=oPersTp:GetLookupTable(500,#ABBRVTN,#ID)
return
function FillPP(lDistribution:=false as logic) as array
	local oPP as SQLSelect
	local aPP:={} as array
oPP:=SqlSelect{"select group_concat(concat(ppname,if(ppcode='','',concat(' (',ppcode,')'))),'#%#',ppcode separator '#$#') as ppgroup from ppcodes "+iif(lDistribution,""," where ppcode<>'AAA' and ppcode<>'ACH'"),oConn}
if oPP:RecCount>0
	AEval(Split(oPP:ppgroup,'#$#'),{|x|AAdd(aPP,Split(x,'#%#'))})
endif
return aPP
FUNCTION FillPropTypes()
* Fill Array with person property types
prop_types:= {{"Text",TEXTBX},{"CheckBox",CHECKBX},{"DropDownList",DROPDOWN},{"Date",DATEFIELD} } 
prop_types:=DynToOldSpaceArray(prop_types)  // to avoid that they are moved around in dynamic memory and reduce use of dymamic memory

return
FUNCTION FilterAcc(aAcc as array ,accarr as array,cStart as string,cEnd as string,aBalIncl:=null_array as array,aDepIncl:=null_array as array) as void
	// add conditinally accstr to aAcc
	LOCAL accstr:=LTrimZero(SubStr(accarr[1],1,LENACCNBR)) as STRING
	IF accstr>=cStart .and. accstr<=cEnd
		if (Empty(aBalIncl) .or. AScanExact(aBalIncl,Str(accarr[3],-1))>0) .and. (Empty(aDepIncl) .or. AScanExact(aDepIncl,Str(accarr[4],-1))>0) 
			AAdd(aAcc,{accarr[1],accarr[2]})
		endif
	ENDIF
	RETURN
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
	
FUNCTION FullName( cFirstName as STRING, cLastName as STRING ) as STRING
// show full name from given first and lastname
	LOCAL cFullName as STRING
	
	cFullName := AllTrim( cFirstName ) + " " + AllTrim( cLastName )
	
	RETURN cFullName
FUNCTION FWriteLineUni(pFile as ptr, c as string) as int
// write line c to pFile converted to Unicode
LOCAL oUni as Unicode
//local Start:=_chr(0xFF)+_chr(0xFE) as psz 
local Start:=psz(_cast,_chr(0xEF)+_chr(0xBB)+_chr(0xBF)) as psz
oUni:=Unicode{c+CRLF}
if oUni:Error
	Return 0
ELSE
	if FTell(pFile)==0
		FWrite(pFile,Start,3) // start of unicode
	endif
	Return FWrite(pFile,Mem2String(oUni:BSTR,oUni:Len))
endif
//Return FWriteLine(pFile,c) 
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

FUNCTION GetBalType(cCode as string) as string
* Translate baltype code to text
RETURN aBalType[AScan(aBalType,{|x| x[1]==cCode}),2]
Function GetBalYear(pStartYear as int,pStartMonth as int) as array 
	/* Give parameters of balance year, in which given year and month occurs
	Returns array with the values:
	-YEARSTART: 	Start Year of found balance year
	-MonthStart:	Start Month of found balance year
	-YEAREND: 		End Year of found balance year
	-MONTHEND:		End Month of found balance year
	*/
	LOCAL nDateMonth, nMinStart, nSecondStart, nNewStart, nEnd,i as int
	Local Startdate:=SToD(Str(pStartYear,4,0)+StrZero(pStartMonth,2,0)+"01"),enddate as date 
	local YEARSTART,MONTHSTART,YEAREND,MonthEnd as int
	
	nDateMonth:=Round(pStartYear*12+pStartMonth,0)
	nMinStart:=Round(Year(LstYearClosed)*12+Month(LstYearClosed),0)
	IF nDateMonth >=nMinStart
		* In Non closed year
		* Calculate start of next balance year:
		IF Month(LstYearClosed) < ClosingMonth
			nSecondStart:=Round(Year(LstYearClosed)*12+ClosingMonth+1,0)
		ELSE
			nSecondStart:=Round(Year(LstYearClosed)*12+ClosingMonth+13,0)
		ENDIF
		
		IF nDateMonth < nSecondStart // before second balance year?
			YEARSTART:=Year(LstYearClosed)
			MONTHSTART:=Month(LstYearClosed)
			YEAREND:=Integer((nSecondStart-2)/12)
		ELSE
			nNewStart:=nSecondStart+Integer(((nDateMonth - nSecondStart)/12)*12)
			YEARSTART:=Integer(nNewStart/12)
			MONTHSTART:=nNewStart%12
			YEAREND:=Integer((nNewStart+10)/12)
		ENDIF
		MonthEnd:=ClosingMonth
		RETURN {YEARSTART,MONTHSTART,YEAREND,MonthEnd}
	ENDIF
	IF Empty(GlBalYears)
		* empty closed balanceyears:
		RETURN {YEARSTART,MONTHSTART,YEAREND,MonthEnd}
	ENDIF
	for i:=1 to Len(GlBalYears)
		IF GlBalYears[i,1]<=Startdate // start before given date?
			YEARSTART:=Year(GlBalYears[i,1])
			MONTHSTART:=Month(GlBalYears[i,1])
			if i==1 
				enddate:=SToD(Str(YEARSTART+1,4)+StrZero(MONTHSTART,2)+"01")-1
			else
				enddate:=GlBalYears[i-1,1]-1
			endif
			YEAREND:=Year(enddate)
			MonthEnd:=Month(enddate)
			RETURN {YEARSTART,MONTHSTART,YEAREND,MonthEnd}
		ENDIF
	Next
	* per default oldest year:
	i--
	YEARSTART:=Year(GlBalYears[i,1])
	MONTHSTART:=Month(GlBalYears[i,1])
	if	i==1 
		enddate:=SToD(Str(YEARSTART+1,4)+StrZero(MONTHSTART,2)+"01")-1
	else
		enddate:=GlBalYears[i,1]-1
	endif
	YEAREND:=Year(enddate)
	MonthEnd:=Month(enddate)
	RETURN {YEARSTART,MONTHSTART,YEAREND,MonthEnd}
function GetBalYears(NbrFutureYears:=0 as int) as array
	// get array with balance years
	LOCAL aMyYear:={} as ARRAY  // {text of balance year, jjjjmm of start of balance year}
	LOCAL oBalY as SQLSelect
	LOCAL nEnd,MONTHEND,YEAREND as int 
	local aYearStartEnd:={} as array

	
	oBalY:=SQLSelect{"select yearstart,monthstart,yearlength from balanceyear order by yearstart desc,monthstart desc",oConn}
	oBalY:Execute()	                       
	
	DO WHILE !oBalY:EoF
		IF !Empty(oBalY:YEARSTART)
			nEnd:=Round(oBalY:YEARSTART*12+oBalY:MONTHSTART+oBalY:YEARLENGTH-2,0)
			MONTHEND:=nEnd%12+1
			YEAREND:=Integer(nEnd/12)
			AAdd(aMyYear,{Str(oBalY:YEARSTART,4,0)+":"+StrZero(oBalY:MONTHSTART,2,0)+" - "+;
				Str(YEAREND,4,0)+":"+StrZero(MONTHEND,2,0),Str(oBalY:YEARSTART,4,0)+StrZero(oBalY:MONTHSTART,2,0)})
		ENDIF
		oBalY:Skip()
	ENDDO
	*	Add non closed years:

	
// 	aYearStartEnd:=GetBalYear(Year(LstYearClosed),ClosingMonth)
	aYearStartEnd:=GetBalYear(Year(LstYearClosed),Month(LstYearClosed))
	AAdd(aMyYear,{Str(aYearStartEnd[1],4,0)+":"+StrZero(aYearStartEnd[2],2,0)+" - "+;
	Str(aYearStartEnd[3],4,0)+":"+StrZero(aYearStartEnd[4],2,0),Str(aYearStartEnd[1],4,0)+StrZero(aYearStartEnd[2],2,0)})
	MONTHEND:=aYearStartEnd[4]
	YEAREND:=aYearStartEnd[3]
	DO WHILE true
		++MONTHEND
		IF MONTHEND>12
			MONTHEND:=1
			++YEAREND
		ENDIF
		IF Round(YEAREND*12+MONTHEND,0)>Round(Year(Today())*12+Month(Today())+NbrFutureYears*12,0)
			*	last year determined:
			exit
		ENDIF
		aYearStartEnd:=GetBalYear(YEAREND,MonthEnd)
		AAdd(aMyYear,{Str(aYearStartEnd[1],4,0)+":"+StrZero(aYearStartEnd[2],2,0)+" - "+;
			Str(aYearStartEnd[3],4,0)+":"+StrZero(aYearStartEnd[4],2,0),Str(aYearStartEnd[1],4,0)+StrZero(aYearStartEnd[2],2,0)})
		MONTHEND:=aYearStartEnd[4]
		YEAREND:=aYearStartEnd[3]
	ENDDO
	ASort(aMyYear,,,{|x,y| x[2]>=y[2]})
	RETURN aMyYear

function GetBankAccnts(mPersid as string) as array 
// Get the bank accounts of person with id mPersonId
local aBankaccs:={} as array
local oSel as SQLSelect 
	* Fill aBankAcc: 
oSel:=SqlSelect{"select group_concat(banknumber,'#%#',bic separator ',') as bankaccs from personbank where persid="+mPersid+" group by persid" ,oConn}
if oSel:RecCount>0
	AEval(Split(oSel:bankaccs,','),{|x|AAdd(aBankaccs,Split(x,'#%#'))})
endif
return aBankaccs
Function GetBIC(cIBAN as string, cBIC:='' as string) as string
	// determine BIC from IBAN if possible:
	// cIBAN: bankaccount nummber
	// cBIC: current value of corresponding BIC 
	local oSel as SQLSelect 
	if IsIban(cIBAN)
		oSel:=SQLSelect{"select `bic` from `bic` where substr(`bic`,1,6)='"+SubStr(cIBAN,5,4)+SubStr(cIBAN,1,2)+"'",oConn}
		if oSel:RecCount>0	
			cBIC:=oSel:BIC
		endif
	endif
	return cBIC



Function GetCountryName(CntrCd as string) as string
local i as int
if (i:=AScan(CountryNames,{|x|x[1]==CntrCd}))>0
	return CountryNames[i,2]
endif
return CntrCd
Function GetDelimiter(cBuffer as string, aStruct ref array, cLim:="" ref string, nMin as int, nMax as int) as logic
	/* determine delimiter and column names of input file with spreadsheet:
	Input: cBuffer with content of first line of file
	nMin: minimal number of columns  
	nMax: maximum number of columns

	Returns:
	False: if no columns could be determined
	aStruct: array with names of columns
	cLim: used delimiter 
	*/ 
	if Len(cLim)=0
		cLim:=Listseparator
	endif
	aStruct:=Split(Upper(cBuffer),cLim,true)
	IF Len(aStruct)<nMin .or.Len(aStruct)>nMax
		cLim:=','
		aStruct:=Split(Upper(cBuffer),cLim,true)
		IF Len(aStruct)<nMin .or.Len(aStruct)>nMax                             
			cLim:=";"
			aStruct:=Split(Upper(cBuffer),cLim,true)
			IF Len(aStruct)<nMin .or.Len(aStruct)>nMax
				cLim:=CHR(9)
				aStruct:=Split(Upper(cBuffer),cLim,true)
				IF Len(aStruct)<nMin .or.Len(aStruct)>nMax
					return false
				endif 
			endif
		endif
	endif 
	return true
FUNCTION GetError    (oSELF as OBJECT, cDescription as STRING)  as ERROR     PASCAL
    LOCAL oError as ERROR

	oError := ErrorNew()
	oError:Subsystem   := "ODBC"
	oError:FuncSym     := AsSymbol( ProcName(1) )
	oError:CallFuncSym := AsSymbol( ProcName(2) )
    oError:Description := cDescription 
    oError:MethodSelf  := oSELF

    RETURN oError
function GetExplain(SqlString as string) as string
// get explain text from given sqlstring
local oSel as SQLSelect
local cText as string
local Tab:=CHR(9) as string
local i as int
oSel:=SQLSelect{"explain "+SqlString,oConn}
for i:=1 to oSel:FCount 
	cText+=oSel:SQLColumns[i]:colname+Tab
next
cText+=CRLF

do while !oSel:Eof
	for i:=1 to oSel:FCount 
		cText+=Transform(oSel:Getdata(i),"")+iif(i<oSel:FCount,Tab,"")
	next
	cText+=CRLF
	oSel:Skip()
enddo 
return cText
Function GetFullName(PersNbr:="" as string ,Purpose:=0 as int) as string 
// composition of full name of a person
// PersNbr: Optional ID of person 
// Purpose: optional indicator that the name is used for:
// 	0: addresslist: with surname "," firstname prefix (without salutation) 
//		1: fullname conform address specification
//		2: name for identification: lastname, firstname prefix 
//		3: like 1 but always with firstname 
LOCAL frstnm,naam1, Title,prefix as STRING
local oPers as SQLSelect
if Empty(PersNbr)
	return ""
endif
oPers:=SQLSelect{"select lastname,prefix,title,firstname,initials,gender from person where persid="+PersNbr,oConn}

IF !oPers:RecCount==1
	RETURN ""
ENDIF
IF sSalutation .and.(Purpose==1.or.Purpose==3) 
	Title := Salutation(oPers:GENDER)
	IF !Empty(Title)
		Title+=" "
	ENDIF
ENDIF
IF TITELINADR.and.!Empty(Title(oPers:Title)) .and.(Purpose==1.or.Purpose==3) 
	Title += Title(oPers:Title)+' '
ENDIF
IF .not. Empty(oPers:FIELDGET(#prefix))
   prefix :=AllTrim(oPers:FIELDGET(#prefix)) +" "
ENDIF
IF .not. Empty(oPers:FIELDGET(#lastname))
   naam1 := AllTrim(oPers:FIELDGET(#lastname))+" "
ENDIF
IF sFirstNmInAdr .or. (Purpose==2.or.Purpose==3)
	IF !Empty(oPers:FIELDGET(#firstname) )
		frstnm += AllTrim(oPers:FIELDGET(#firstname))+' '
	ELSEIF .not. Empty(oPers:FIELDGET(#initials))  && use otherwise initials
		frstnm += AllTrim(oPers:FIELDGET(#initials))+' '
	ENDIF
ELSEIF .not. Empty(oPers:FIELDGET(#initials))  && use otherwise initials
	frstnm += AllTrim(oPers:FIELDGET(#initials))+' '
ENDIF
do CASE
CASE Purpose==0
	//addresslist:
	naam1:=AllTrim(naam1)+iif(!sSurnameFirst.and.!(Empty(frstnm).and.Empty(prefix)),", "," ")+frstnm+prefix
CASE Purpose==1.or.Purpose==3
	// address conform address specifications:
	IF sSurnameFirst
   	naam1 := naam1+Title+frstnm + prefix
	else
		naam1:=Title+frstnm+prefix+naam1
	ENDIF	
CASE Purpose==2
	// identification:
	naam1:=AllTrim(naam1)+iif(!sSurnameFirst.and.!(Empty(frstnm).and.Empty(prefix)),", "," ")+frstnm+prefix
endcase
naam1:=AllTrim(naam1)
return StrTran(naam1,',','',len(naam1),1)
Function GetFullNAW(PersNbr as string,country:="" as string,Purpose:=1 as int) as string 
* Compose name and address
* country: default country (optional)
LOCAL f_row:="" as STRING
local oPers as SQLSelect

IF Empty(PersNbr) 
	return null_string
ENDIF
f_row:=GetFullName(PersNbr,Purpose)
oPers:=SQLSelect{"select address,postalcode,city,country from person where persid="+PersNbr,oConn} 
if oPers:RecCount<1
	return null_string
endif

f_row:=f_row+', '
IF .not.Empty(oPers:address)
   f_row+=AllTrim(oPers:address)+" "
ENDIF
IF .not.Empty(oPers:postalcode)
   f_row+=Trim(oPers:postalcode)+" "
ENDIF
IF .not.Empty(oPers:city)
   f_row+=Trim(oPers:city)+" "
ENDIF
IF .not.Empty(oPers:country) 
   f_row+=Trim(oPers:country) 
ELSEIF .not.Empty(country)
   f_row+=country
ENDIF
RETURN AllTrim(f_row)
function GetHelpDir()

	if Len(Directory("C:\Users\"+myApp:GetUser()+"\AppData\Local\Temp",FA_DIRECTORY))>0
		//if nLen>0 
		HelpDir:="C:\Users\"+myApp:GetUser()+"\AppData\Local\Temp"
	elseIF Len(Directory("C:\WINDOWS\TEMP",FA_DIRECTORY))>0
		HelpDir:="C:\Windows\Temp"
	ELSEIF Len(Directory("C:\TEMP",FA_DIRECTORY))>0
		HelpDir:="C:\TEMP"
	ELSE 
		DirMake("C:\TEMP")
		HelpDir:="C:\TEMP"
	ENDIF
	if IsOldSpace(HelpDir)
		OldSpaceFree(HelpDir)
	endif
	HelpDir:=DynToOldSpaceString(HelpDir)  // to avoid that they are moved around in dynamic memory and reduce use of dymamic memory
	return
Function GetMailAbrv(cCode as string) as string
	* Return abbrevation corresponding with given pers_code
	LOCAL nPtr as int
	nPtr:=AScan(mail_abrv,{|x|x[2]==cCode})
	if nPtr>0
		return mail_abrv[nPtr,2]
	else
		return ""
	endif
Function GetMailDesc(cCode as string) as string
	* Return description corresponding with given pers_code
	LOCAL nPtr as int
	nPtr:=AScan(pers_codes,{|x|x[2]==cCode})
	if nPtr>0
		return pers_codes[nPtr,1]
	else
		return ""
	endi
FUNCTION GetParentWindow(oSelf)
LOCAL oWindow as OBJECT
oWindow:=oSelf
DO WHILE true
	IF IsAccess(oWindow,#Owner)
		IF IsInstanceOf(oWindow:Owner,#Window).or.IsInstanceOf(oWindow:owner,#DataBrowser)
			oWindow:=oWindow:Owner
		ELSE
			exit
		ENDIF
	ENDIF
ENDDO
IF !IsInstanceOf(oWindow,#Window)
	oWindow:=null_object
ENDIF

RETURN oWindow
function GetServername(fullpathname as string) as string 
	// get server name from a path
	local cSearch,cServerName:="localhost" as string
	local nPosbackslash as int
	fullpathname:=AllTrim(fullpathname)
	if Len(fullpathname)>1
		if !SubStr(fullpathname,1,2)=='\\'
			fullpathname:=NetGetConnection(fullpathname)
		endif
		if Len(fullpathname)>2
			cServerName:=SubStr(fullpathname,3,At3('\',fullpathname,3)-3)
		endif
	endif
	return cServerName
Function GetStreetHousnbr(Address as string) as array
	* return array {streetname, housnbr} from input Address
	LOCAL aWord as ARRAY
	LOCAL l,j as int
	LOCAL nEnd, nNumPosition as int
	LOCAL StreetName:=null_string, Housenbr:=" " as STRING

	IF !Empty(Address)
		aWord:=GetTokens(Address)
		nEnd := Len(aWord)
		if nEnd==1 .and. IsDigit(aWord[1,1])
			return {"",aWord[1,1]}
		endif
		* Search streetname:
		* Search backwards till housenbr:
		FOR l:=nEnd to 1 step -1
			//		IF IsDigit(aWord[l,1]).and.l>1
			IF IsDigit(aWord[l,1])
				* Housenbr found:
				nNumPosition:=l
				IF l > 1
					* two numbers?
					IF IsDigit(aWord[l-1,1])
						nNumPosition:=l - 1
					ELSEIF l>3 .and.Len(aWord[l-1,1])< 4 .and.IsDigit(aWord[l-2,1])
						* number, short alpha, number?			
						nNumPosition:=l - 2
					ENDIF
				ENDIF
				if nNumPosition=1
					// number at begin
					Housenbr := aWord[1,1] + aWord[1,2]
					FOR j=2 to nEnd
						StreetName:=StreetName+aWord[j,1]+aWord[j,2]
					NEXT
				else
					FOR j=1 to nNumPosition-1
						StreetName:=StreetName+aWord[j,1]+aWord[j,2]
					NEXT
					FOR j = nNumPosition to nEnd
						Housenbr := Housenbr +aWord[j,1] + aWord[j,2]
					NEXT 
				endif
				IF Len(AllTrim(Housenbr)) > 9
					* Large deviation: all in streetname:
					StreetName := Address
					Housenbr := ""
				ENDIF
				exit
			ENDIF
		NEXT
		IF Empty(nNumPosition) // no house# found?
			StreetName:= Address
		ENDIF
	ENDIF
	RETURN {AllTrim(StreetName), AllTrim(Housenbr)}
FUNCTION GetTokens(cText as string,aSep:=null_array as array,AlphaDigitSep:=true as logic) as array
	*	Determine Tokens in a string of text
	*	aSep: optionaly array with separators 
	*	AlphaDigitSep: true: separate between alphabetic and digital characters (default)
	*	Returns array with Tokens {{Token,Seperator},...}

	LOCAL Tokens:={} as ARRAY, chText, Token, cSep, cSepPrev:=null_string, cChar as STRING, nLength,i as int,EndOfWord as LOGIC 
	if Empty(aSep)
		aSep:= {" ",",",".","&","/","-"}
	endif
	// Default(@aSep,{" ",",",".","&","/","-"})

	chText:=Compress(cText)
	nLength:=Len(chText)
	FOR i:=1 to nLength
		* Find next Tokens:
		Token:=""
		cSep:=""
		EndOfWord:=FALSE
		DO WHILE !EndOfWord .and.i<=nLength
			cChar:=SubStr(chText,i,1)
			IF AScanExact(aSep,cChar)>0
				IF Empty(Token)
					IF !Empty(cChar).and.i>1.and.!cChar==cSepPrev
						* only non blank seperator:
						EndOfWord:=true
						cSep:=cChar
						exit
					ENDIF				
				ELSE
					EndOfWord:=true
					cSep:=cChar
					exit
				ENDIF
			ELSE
				IF AlphaDigitSep .and.!Empty(Token) .and. (IsDigit(psz(_cast,cChar)) .and. IsAlpha(psz(_cast,Token)) .or. IsDigit(psz(_cast,Token)) .and.IsAlpha(psz(_cast,cChar)))
					* regard transition from alpha to numeric or numeric to alpha as separate word
					EndOfWord:=true
					cSep:=" "
					--i
					exit
				ELSE				
					Token:=Token+cChar
				ENDIF
			ENDIF
			++i
		ENDDO
		IF !Empty(Token).or.!Empty(cSep)
			AAdd(Tokens,{Token,cSep})
			cSepPrev:=cSep
		ENDIF
	NEXT
	RETURN Tokens
FUNCTION GetTokensEx(cText as string,aSep as array,MinLenSep:=1 as int,lCompress:=false as logic) as array
	*	Extended Determination of Tokens in a string of text
	*	aSep: array with strings of separators
	*  minLenSep: minimum length of all separator strings within aSep (optional) to speed up processing 
	*  if lCompress=true then ctext is compressed before processing
	*	Returns array with Tokens {{Token,Seperator},...}

	LOCAL Tokens:={} as ARRAY, Token, cSep, cSepPrev:=null_string, cChar as STRING
	local cSepPrv as string 
	local nLength,i,j as int
	local nTokenStart as int 
	// Default(@aSep,{" ",",",".","&","/","-"})

	if lCompress
		cText:=Compress(cText)
	endif
	nLength:=Len(cText)+1-MinLenSep
	Token:=""
	cSep:=""
	nTokenStart:=0
	FOR i:=1 to nLength
		DO WHILE i<=nLength
			cChar:=SubStr(cText,i,MinLenSep)
			j:=1
			do while (j:=AScan(aSep,{|x|SubStr(x,1,MinLenSep)==cChar},j))>0
				if SubStr(cText,i,Len(aSep[j]))==aSep[j] 
					if nTokenStart>0 
						Token:=SubStr(cText,nTokenStart,i-nTokenStart)
						AAdd(Tokens,{Token,cSep})
					endif
					cSep:=aSep[j]
					nTokenStart:=i+Len(cSep)
					i:=nTokenStart-1
					exit
				ENDIF
				j++
				IF j>Len(aSep)
					exit
				endif
			ENDDO
			++i
		ENDDO
		IF !Empty(nTokenStart).and.!Empty(cSep)
			Token:=SubStr(cText,nTokenStart)
			AAdd(Tokens,{Token,cSep})
		ENDIF
	NEXT
	RETURN Tokens
FUNCTION Getvaliddate (pDay as int,pMonth as int,pYear as int) as date
* Determination of valid date (if not valid return next valid date)
LOCAL nwdat as date, i as int
IF pDay > 31
   pDay:=31
ENDIF
IF pMonth > 12
   pYear:=pYear+Integer(pMonth/12)
   pMonth := pMonth%12
ELSEIF pMonth<=0
	pYear:=pYear+Round((pMonth-12)/12,0)
	pMonth:=Mod(pMonth-1,12)+1
ENDIF
FOR i=0 to 3  && correct shorted month
    nwdat:=SToD(Str(pYear,4,0)+StrZero(pMonth,2,0)+StrZero(pDay-i,2,0))
    IF .not.Empty(nwdat)
       exit
    ENDIF
NEXT
RETURN(nwdat)
Function Hex2Str(cText as string) as string 
	// convert hexadecimal string dump to ascii string
	local i,l:=Len(cText),nAsc as int
	local cRet,cChar as string
	if Mod(l,2)=1
		return cText
	endif
	for i:=1  to l step 2
		cChar:=SubStr(cText,i,1)
		if !IsXDigit(cChar)
			return cText
		endif
		if cChar <'A'
			nAsc:=Val(cChar) *16
		else
			nAsc:=(Asc(cChar)-55)*16
		endif 
		cChar:=SubStr(cText,i+1,1)
		if !IsXDigit(cChar)
			return cText
		endif
		if cChar <'A'
			nAsc+=Val(cChar) 
		else
			nAsc+=(Asc(cChar)-55)
		endif 
		cChar:=CHR(nAsc)
		cRet+=cChar
	next
	return cRet

function HtmlDecode(cText as string) as string
	/*
	Decode html encoded characters:
	'&' (ampersand) becomes '&amp;'
	'"' (double quote) becomes '&quot;' when ENT_NOQUOTES is not set.
	''' (single quote) becomes '&#039;' only when ENT_QUOTES is set.
	'<' (less than) becomes '&lt;'
	'>' (greater than) becomes '&gt;'
	*/
	Local aKey:={'&amp;','&quot;', '&#039;', '&lt;', '&gt;'} as array
	Local aRepl:={'&','"',"'",'<','>'} 
	local i as int
	for i:=1 to 5
		cText:=StrTran(cText,aKey[i],aRepl[i])
	next
	Return cText  
function HtmlEncode(cText as string) as string
	/*
	Encode html encoded characters:
	'&' (ampersand) becomes '&amp;'
	'"' (double quote) becomes '&quot;' when ENT_NOQUOTES is not set.
	''' (single quote) becomes '&#039;' only when ENT_QUOTES is set.
	'<' (less than) becomes '&lt;'
	'>' (greater than) becomes '&gt;'
	*/
	Local aKey:={'&amp;','&quot;', '&#039;', '&lt;', '&gt;'} as array
	Local aRepl:={'&','"',"'",'<','>'} 
	local i as int
	for i:=1 to 5
		cText:=StrTran(cText,aRepl[i],aKey[i])
	next
	Return cText  
	Function IbanChecksum(Iban as string) as int
	local IBanTemp as string
	local nChecksum as int 
		// move First 4 chars (countrycode and checksum) to the end of the string
	Iban:=SubStr(Iban, 5)+SubStr(Iban, 1, 4)
	// substitute chars 
	IBanTemp:=''
	SEval(Iban,{|c|IBanTemp+=iif(IsAlpha(CHR(c)),Str(c-55,-1),CHR(c))})
	// mod97-10  

	nChecksum:=Val(SubStr(IBanTemp,1,1)) 
	SEval(IBanTemp,{|c|nChecksum:=(nChecksum*10+Val(CHR(c))) % 97},2) 
	return 98-nChecksum




CLASS IbanConv
PROTECT  IbanChar:={{"À", "A"}, {"Á", "A"},{"Â", "A"},{"Ã", "A"},{"Ä", "A"},{"Å", "A"},{"Æ", "A"},{"Ç", "C"},{"È", "E"},{"É", "E"},{"Ê", "E"},{"Ë", "E"},{"Ì", "I"},{"Í", "I"},{"Î", "I"},{"Ï", "I"},{"Ð", "D"},{"Ñ", "N"},{"Ò", "O"},{"Ó", "O"},{"Ô", "O"},{"Õ", "O"},{"Ö", "O"},{"Ø", "O"},{"Ù", "U"},{"Ú", "U"},{"Û", "U"},{"Ü", "U"},{"Ý", "Y"},{"Þ", "T"},{"ß", "s"},{"à", "a"},{"á", "a"},{"â", "a"},{"ã", "a"},{"ä", "a"},{"å", "a"},{"æ", "a"},{"ç", "c"},{"è", "e"},{"é", "e"},{"ê", "e"},{"ë", "e"},{"ì", "i"},{"í", "i"},{"î", "i"},{"ï", "i"},{"ð", "d"},{"ñ", "n"},{"ò", "o"},{"ó", "o"},{"ô", "o"},{"õ", "o"},{"ö", "o"},{"ø", "o"},{"ù", "u"},{"ú", "u"},{"û", "u"},{"ü", "u"},{"ý", "y"},{"þ", "t"},{"ÿ", "y"},{"A", "A"},{"a", "a"},{"A", "A"},{"a", "a"},{"A", "A"},{"a", "a"},{"C", "C"},{"c", "c"},{"C", "C"},{"c", "c"},{"C", "C"},{"c", "c"},{"C", "C"},{"c", "c"},{"D", "D"},{"d", "d"},{"Ð", "D"},{"d", "d"},{"E", "E"},{"e", "e"},{"E", "E"},{"e", "e"},{"E", "E"},{"e", "e"},{"E", "E"},{"e", "e"},{"E", "E"},{"e", "e"},{"G", "G"},{"g", "g"},{"G", "G"},{"g", "g"},{"G", "G"},{"g", "g"},{"G", "G"},{"g", "g"},{"H", "H"},{"h", "h"},{"H", "H"},{"h", "h"},{"I", "I"},{"i", "i"},{"I", "I"},{"i", "i"},{"I", "I"},{"i", "i"},{"I", "I"},{"i", "i"},{"I", "I"},{"i", "i"},{"?", "I"},{"?", "i"},{"J", "J"},{"j", "j"},{"K", "K"},{"k", "k"},{"L", "L"},{"l", "l"},{"L", "L"},{"l", "l"},{"?", "L"},{"?", "l"},{"L", "L"},{"l", "l"},{"N", "N"},{"n", "n"},{"N", "N"},{"n", "n"},{"N", "N"},{"n", "n"},{"O", "O"},{"o", "o"},{"Œ", "O"},{"œ", "o"},{"R", "R"},{"r", "r"},{"R", "R"},{"r", "r"},{"R", "R"},{"r", "r"},{"S", "S"},{"s", "s"},{"S", "S"},{"s", "s"},{"S", "S"},{"s", "s"},{"Š", "S"},{"š", "s"},{"T", "T"},{"t", "t"},{"T", "T"},{"t", "t"},{"U", "U"},{"u", "u"},{"U", "U"},{"u", "u"},{"U", "U"},{"u", "u"},{"U", "U"},{"u", "u"},{"U", "U"},{"u", "u"},{"U", "U"},{"u", "u"},{"W", "W"},{"w", "w"},{"Y", "Y"},{"y", "y"},{"Ÿ", "Y"},{"Z", "Z"},{"z", "z"},{"Z", "Z"},{"z", "z"},{"Ž", "Z"},{"ž", "z"},{"&","+"},{"@","(at)"},{"_","-"}};
 as array
DECLARE Method FindIbanChar,IbanFormatText           

METHOD FindIbanChar (cValue as string, nValue as int) as string  CLASS IbanConv    

	local i as int
	local aIbanChar:=self:IbanChar as array	
   if nValue>=97 .and. nValue<=122 .or. nValue=32 .or. nValue>=65 .and. nValue<=90 .or. nValue>=39 .and. nValue<=58 .or. nValue=59  // allowed characters
   	return cValue
   endif 
	i:= AScan(aIbanChar,{|x|x[1]==cValue})
	if i>0
 		return aIbanChar[i,2]
	else
 		 return ' ' // space if not allowed and not convertable
	endif 
 
Method IbanFormatText(Iban as string) class IbanConv
	// Convert a string to SEPA accepted characters
	local IBanTemp as string                     
	local oIban:=self as IbanConv 
    	
   SEval(Iban,{|c|IBanTemp+= oIban:FindIbanChar(CHR(c),c)}) 

return IBanTemp

Method INIT() CLASS Ibanconv
Return self

Function IbanFormat(Iban ref string) 
	// standardize fromat of a Iban Bank account number
	local IBanTemp as string
	// Uppercase and trim spaces from left  
	Iban := AllTrim(Upper(Iban))
	// remove Iban from start of string, if present 
	if SubStr(Iban,1,4)=='IBAN'
		Iban := SubStr(Iban,5,)
	endif
	// remove all non basic roman letter / digit characters
	SEval(Iban,{|c|IBanTemp+=iif(IsDigit(CHR(c)).or.IsAlpha(CHR(c)),CHR(c),null_string)})
	Iban:=IBanTemp    // machine format
	return
FUNCTION Implode(aText as array,cSep:=" " as string,nStart:=1 as int,nCount:=0 as int,nCol:=0 as int,cSepRow:='' as string,Filter:=nil as usual ) as string
	// Implode array aText to string seperated by cSep 
	// Optionaly you can indicate a column to implode in case of 2-dimenional array 
	// Optionally in case of a 2-dimenional array you can specify separator between rows (default: '),(' but none when empty nCol ) 
	// Optionally you can specify a codeblock Filter to select certain rows from aText
	LOCAL i, l:=Len(aText) as int 
	local cQuote as STRING    // string quote text around separators (CSV)
	local cLine  as STRING    // one line of concatinated text 
	// to reduce exponential increase of processing time for large strings:
	local cPartLv1  as STRING // first level of intermediate 1000 bytes of concatinated text to reduce manipulation of large strings 
	local cPartLv2  as STRING // second level of intermediate 10000 bytes of concatinated text to reduce manipulation of large strings
	local cPartLv3  as STRING // third level of intermediate 100000 bytes of concatinated text to reduce manipulation of large strings
	local cPartLv4  as STRING // fourth level of all concatinated text to return to caller
	local lMulti,lStart:=true as logic 
	if Len(cSep)>2
		// test if surrounded by quotes:
		cQuote:= Left(cSep,1)
		if cQuote==Right(cSep,1)
			if !(cQuote=="'" .or. cQuote=='"')
				cQuote:=null_string
			endif
		endif
	endif
	if l>0
		if Empty(nCount)
			nCount:=l-nStart+1 
		endif
		nCount:=Min(nCount,l-nStart+1)
		IF nCount>0 
			FOR i:=1 to nCount 
				if IsCodeBlock(Filter)  
					i:=AScan(aText,Filter,i)
					if i=0
						exit
					endif
				endif
				if IsArray(aText[nStart+i-1])
					if Empty(nCol) .or.!Empty(cSepRow)
						lMulti:=true 
						if Empty(cSepRow)
							cSepRow:='),('  // default row seperator
						endif	
						cPartLv1+=iif(i==1,Right(cSepRow,1),cSepRow)+Implode(aText[nStart+i-1],cSep,,,nCol)+iif(i==nCount,Left(cSepRow,1),'')
					else
						if IsString(aText[nStart+i-1][nCol])
							cLine:=AllTrim(aText[nStart+i-1][nCol])
						else
							cLine:=AllTrim(Transform(aText[nStart+i-1][nCol],""))
						endif
						if !Empty(cLine)
							if lStart
								lStart:=false
							else
								cLine:=cSep+cLine
							endif
							cPartLv1+=cLine
						endif
					endif
				elseif Empty(nCol) .or. nCol==i
					if IsString(aText[nStart+i-1])
						cLine:=aText[nStart+i-1]
					else
						cLine:=AllTrim(Transform(aText[nStart+i-1],""))
					endif
					cPartLv1+=iif(i=1,"",cSep)+cLine
				else
					loop
				endif
				if Len(cPartLv1)>1000
					cPartLv2+=cPartLv1
					cPartLv1:=''
					if Len(cPartLv2)>10000
						cPartLv3+=cPartLv2
						cPartLv2:=''
						if Len(cPartLv3)>100000
							cPartLv4+=cPartLv3
							cPartLv3:=''
						endif
					endif
				endif
			NEXT
			cPartLv2+=cPartLv1
			cPartLv3+=cPartLv2
			cPartLv4+=cPartLv3
		ENDIF 
	endif
	RETURN iif(lMulti,cPartLv4,cQuote+cPartLv4+cQuote)
Function ImportCSV(SourceFile as string,Desttable as string,nNbrCol:=2 as int,aStructReq:={} as array) as logic 
	// import of a CSV or tab-seperated file SourceFile into table Desttable with first nNbrCol columns
	local NbrCol as int 
	local cDelim as string 
	local cBuffer as string 
	local aStruct as array
	local aFields as array 
	local aSubFields as array
	local avalues:={} as array // array with values to be stored 
	LOCAL ptrHandle as MyFile 
	local oFs as FileSpec
	local oStmnt as sqlstatement 
	oFs:=FileSpec{SourceFile}
	ptrHandle:=MyFile{oFs}
	if FError() >0
		(ErrorBox{,"Could not open file: "+oFs:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	endif
	cBuffer:=ptrHandle:FReadLine()
	if Upper(oFs:Extension)=".TXT"
		cDelim:=CHR(9)
	ELSE
		cDelim:=Listseparator
	endif 
	if !GetDelimiter(cBuffer,@aStruct,@cDelim,nNbrCol,20)
		return false
	endif
	NbrCol:=Len(aStruct)
	if !Empty(aStructReq) .and.Len(aStructReq)==nNbrCol
		aStruct:=AClone(aStructReq)
	endif
	// replace space in name by underscore:
	cBuffer:=ptrHandle:FReadLine()
	do WHILE Len(aFields:=Split(cBuffer,cDelim,true))=NbrCol 
		if Len(avalues)>68
			cBuffer:=cBuffer
		endif
		if Len(AFields)>nNbrCol 
			aSubFields:=ArrayCreate(nNbrCol)
			ACopy(aFields,aSubFields,1,nNbrCol,1)
			AAdd(avalues,aSubFields)
		else
			AAdd(avalues,aFields)
		endif 
		cBuffer:=ptrHandle:FReadLine()
	enddo
	oStmnt:=SQLStatement{"insert ignore into `"+Desttable+"` ("+Implode(aStruct,',',1,nNbrCol)+') values '+Implode(avalues,'","'),oConn}
	oStmnt:Execute()
	ptrHandle:Close()
	return Empty((oStmnt:Status))
function InitGlobals(lRefreshAllowed:=true as logic) 
	LOCAL oLan as Language
	// 	Local oPP as PPCodes
	LOCAL nMindate as int
	LOCAL lRefreshMenu as LOGIC
	LOCAL oReg as CLASS_HKLM
	LOCAL excelpath as STRING 
	LOCAL aBalYearFile:={} as ARRAY
	Local ind as int
	local oSel,oSys as SQLSelect
	local oStmnt as SQLStatement 

	oReg:=Class_HKLM{}
	excelpath:=oReg:GetString("SOFTWARE\Microsoft\Office\12.0\Excel\InstallRoot","Path")  // installroot excel
	IF Empty(AllTrim(excelpath))
		excelpath:=oReg:GetString("SOFTWARE\Microsoft\Office\11.0\Excel\InstallRoot","Path")  // installroot excel
	ENDIF	
	IF Empty(AllTrim(excelpath))
		excelpath:=oReg:GetString("SOFTWARE\Microsoft\Office\9.0\Excel\InstallRoot","Path")  // installroot excel
	ENDIF	
	EXCEL:= excelpath +"Excel.exe "
	oReg:=null_object
	oSys:=SQLSelect{"select `am`,`assproja`,`assfldac`,`defaultcod`,`fgmlcodes`,`capital`,`cash`,`donors`,`donors`,`creditors`,`projects`,`giftincac`,"+;
	"`giftexpac`,`homeincac`,`homeexpac`,`assmntoffc`,`withldoffl`,`withldoffm`,`withldoffh`,`assmntfield`,`citynmupc`,`lstnmupc`,`entity`,`hb`,"+;
	"`crossaccnt`,`postage`,`toppacct`,`currname`,`posting`,`lstcurrt`,`banknbrcol`,`banknbrcre`,`idorg`,`admintype`,`mailclient`,`firstname`,"+;
	"`countryown`,`owncntry`,`surnmfirst`,`nosalut`,`nosalut`,`titinadr`,`strzipcity`,`closemonth`,`crlanguage`,`mindate`,`countrycod`,"+;
	"`yearclosed`,`debtors`,`currency`,`sysname`,`sepaenabled`,`maildirect`,`localbackup` from sysparms",oConn}
	IF oSys:RecCount>0
		oSel:=SQLSelect{"select yearstart,yearlength,monthstart from balanceyear order by yearstart desc, monthstart desc limit 1",oConn}
		IF oSel:RecCount>0
			nMindate:=oSel:YEARSTART*12+oSel:YEARLENGTH+oSel:MONTHSTART 
			LstYearClosed:=SToD(Str(Integer(nMindate/12),4)+StrZero(nMindate%12,2)+"01")
			if oSys:Mindate < LstYearClosed
				oSys:Mindate:=LstYearClosed
			endif
			if oSys:yearclosed < oSel:YEARSTART
				oSys:yearclosed:= oSel:YEARSTART
			endif
		ENDIF

		sam		:= iif(Empty(oSys:AM),'',Str(oSys:AM,-1))
		samProj	:= iif(Empty(oSys:ASSPROJA),'',Str(oSys:ASSPROJA,-1))
		samFld	:= iif(Empty(oSys:ASSFLDAC),'',Str(oSys:ASSFLDAC,-1))
		SCLC	:= AllTrim(iif(IsNil(oSys:DEFAULTCOD),'',oSys:DEFAULTCOD))
		SFGC	:= AllTrim(iif(IsNil(oSys:FGMLCODES),'',oSys:FGMLCODES))
		SKAP	:= iif(Empty(oSys:Capital),'',Str(oSys:Capital,-1))
		SKAS	:= iif(Empty(oSys:Cash),'',Str(oSys:Cash,-1))
		SDON	:= iif(Empty(oSys:Donors),'',Str(oSys:Donors,-1))
		SDEB	:= iif(Empty(oSys:Debtors),'',Str(oSys:Debtors,-1))
		SCRE	:= iif(Empty(oSys:CREDITORS),'',Str(oSys:CREDITORS,-1))
		SPROJ	:= iif(Empty(oSys:Projects),'',Str(oSys:Projects,-1))
		SINC	:= iif(Empty(oSys:GIFTINCAC),'',Str(oSys:GIFTINCAC,-1))
		SEXP	:= iif(Empty(oSys:GIFTEXPAC),'',Str(oSys:GIFTEXPAC,-1))
		SINCHOME	:= iif(Empty(oSys:HOMEINCAC),SINC,Str(oSys:HOMEINCAC,-1) )
		SEXPHOME	:= iif(Empty(oSys:HOMEEXPAC),SEXP,Str(oSys:HOMEEXPAC,-1)  )
		sInhdKntr := oSys:assmntOffc
		sInhdKntrL := oSys:withldoffl
		sInhdKntrM := oSys:withldoffm
		sInhdKntrH := oSys:withldoffh
		sInhdField := oSys:assmntfield 
// 		CITYUPC := iif(oSys:CITYNMUPC==iif(IsNumeric(oSys:CITYNMUPC),1,'1'),true,false)
// 		LSTNUPC := iif(oSys:LSTNMUPC==iif(IsNumeric(oSys:LSTNMUPC),1,'1'),true,false)
		CITYUPC := ConL(oSys:CITYNMUPC)
		LSTNUPC := ConL(oSys:LSTNMUPC)
		
		SEntity	:= AllTrim(oSys:Entity)
		SHB		:= iif(Empty(oSys:HB),'',Str(oSys:HB,-1))
		SKruis	:= iif(Empty(oSys:CrossAccnt),'',Str(oSys:CrossAccnt,-1))
		SPOSTZ	:= iif(Empty(oSys:Postage),'',Str(oSys:Postage,-1))
		STOPP		:= iif(Empty(oSys:ToPPAcct),'',Str(oSys:ToPPAcct,-1) )
		sCURRNAME:= AllTrim(oSys:CURRNAME) 
		Posting:=iif(ConI(oSys:Posting)=1,true,false)
		LstCurRate := ConL(oSys:LSTCURRT)
		SepaEnabled:=ConL(oSys:SepaEnabled)
		oSel:= SQLSelect{'select `aed` from `currencylist` where `aed`="'+AllTrim(oSys:Currency)+'"',oConn}
		if oSel:RecCount>0
			sCURR   :=  oSel:AED
		endif
		BANKNBRDEB:=iif(Empty(oSys:BANKNBRCOL),'',ConS(SqlSelect{"select banknumber from bankaccount where bankid="+ConS(oSys:BANKNBRCOL),oConn}:banknumber)) 
		BANKNBRCRE:=iif(Empty(oSys:BANKNBRCRE),'',ConS(SqlSelect{"select banknumber from bankaccount where bankid="+ConS(oSys:BANKNBRCRE),oConn}:banknumber)) 
		BICNBRDEB:=iif(Empty(oSys:BANKNBRCOL),'',ConS(SqlSelect{"select bic from bankaccount where bankid="+ConS(oSys:BANKNBRCOL),oConn}:bic)) 
		BICNBRCRE:=iif(Empty(oSys:BANKNBRCRE),'',ConS(SqlSelect{"select bic from bankaccount where bankid="+ConS(oSys:BANKNBRCRE),oConn}:bic)) 
		sIDORG := iif(Empty(oSys:IDORG),'',Str(oSys:IDORG,-1))
		if !Empty(oSys:ADMINTYPE)
			if !Admin==oSys:ADMINTYPE
				lRefreshMenu:=true
			ENDIF
			Admin:=oSys:ADMINTYPE
		ENDIF
		sFirstNmInAdr := ConL(oSys:FirstName)
		sLand	:= AllTrim(oSys:CountryOwn)
		OwnCountryNames:=Split(AllTrim(oSys:OWNCNTRY),",")
		sFirstNmInAdr := ConL(oSys:FirstName)
		sSurnameFirst := ConL(oSys:SURNMFIRST)
		sSalutation := !ConL(oSys:NOSALUT)
		TITELINADR := ConL(oSys:TITINADR)
		sSTRZIPCITY := ConI(oSys:STRZIPCITY)
		ClosingMonth:=oSys:CLOSEMONTH
		Alg_Taal := oSys:CrLanguage
		Alg_Taal := DynToOldSpaceString(Alg_Taal)  // save in static memory outside garbage collector
		Mindate:=oSys:Mindate 
		if Empty(LstYearClosed)
			LstYearClosed:=Mindate
		endif

		CountryCode:=AllTrim(oSys:COUNTRYCOD)
  		CountryCode:=DynToOldSpaceString(CountryCode)  // save in static memory outside garbage collector
 		requiredemailclient:=ConI(oSys:MAILCLIENT)
		maildirect:=ConL(oSys:maildirect)
		BackupToLocal:=ConL(oSys:localbackup)
		if !Empty(MYEMPID)
			// check if email specified per employee:
			oSel:=SqlSelect{"select maildirect,mailclient from employee where empid="+MYEMPID,oConn}
			if oSel:RecCount=1
				if	!IsNil(oSel:maildirect)	 // not null thus	specified seperately	per employee                 
					maildirect:=ConL(oSel:maildirect)
					if	Empty(maildirect).and.!IsNil(oSel:MAILCLIENT)
						requiredemailclient:=ConI(oSel:MAILCLIENT)
					endif
				endif
			endif                                  
		endif
		if !Empty(BANKNBRCRE) .and. SEntity="NED"
			// add to PPcodes as destination for distribution instructions for outgooing payments to bank: 
			oSel:=SQLSelect{"select ppname from ppcodes where ppcode='AAA'",oConn}
			if oSel:RecCount=0
				SQLStatement{"insert into ppcodes set ppcode='AAA',ppname='Bank:"+BANKNBRCRE+"'",oConn}:execute()
			elseif !AllTrim(oSel:PPNAME)=="Bank:"+BANKNBRCRE
				SQLStatement{"update ppcodes set ppname='Bank:"+BANKNBRCRE+"' where ppcode='AAA'",oConn}:execute()
			endif
		endif 
		oSel:=SQLSelect{"select ppcode from ppcodes where ppcode='ACH'",oConn}
		if oSel:RecCount=0
			SQLStatement{"insert into ppcodes set ppcode='ACH',ppname='ACH for member bank deposits'",oConn}:execute()
		endif
	ENDIF 
	// determine available balance years: 
	FillBalYears() 
	// determine local date format for retrieval with mysql:
	LocalDateFormat:=StrTran(StrTran(StrTran(DToC(SToD("19991230")),"1999","%Y"),"30","%d"),"12","%m")

	aBalType:={{ASSET,"Assets"},{INCOME,"Income"},{EXPENSE,"Expense"},{LIABILITY,"Liabilities"}}
	USRTypes:={{"System Administrator","A"},{"Financial Administrator","F"},{"Person Administrator","P"}}
	if Admin="WA"
		AAdd(USRTypes,{"Declarer expenses","D"})
	endif 
	if Posting
		AAdd(USRTypes,{"Financial Manager","M"})
	endif

	oLan:=Language{}
	Maand := {	oLan:RGet('January',,"!"),oLan:RGet('February',,"!"),oLan:RGet('March',,"!"),;
		oLan:RGet('April',,"!"),oLan:RGet('May',,"!"),oLan:RGet('June',,"!"),;
		oLan:RGet('July',,"!"),oLan:RGet('August',,"!"),oLan:RGet('September',,"!"),;
		oLan:RGet('October',,"!"),oLan:RGet('November',,"!"),oLan:RGet('December',,"!")}
	PaymentDescription:={;
		oLan:RGet("Donation",,"!"),oLan:RGet("Gift",,"!"),oLan:RGet("Invoice",,"!"),;
		oLan:RGet("subscription",,"!")}
	TeleBanking := FALSE 
	AutoGiro:= FALSE
	
	oSel:=SQLSelect{"select accid from bankaccount where accid>0",oConn}
	IF oSel:RecCount>0
		// fill global array with bank accounts
		BankAccs:={}
		DO WHILE !oSel:EOF
			AAdd(BankAccs,Str(oSel:accid,-1))
			oSel:Skip()
		ENDDO 
		BankAccs:=DynToOldSpaceArray(BankAccs)  // to avoid that they are moved around in dynamic memory and reduce use of dymamic memory

		oSel:=SQLSelect{"select count(*) from bankaccount where telebankng>0 and accid",oConn}
		IF oSel:RecCount>0
			TeleBanking:=true
		else
			TeleBanking:=false
		ENDIF
		LENBANKNBR:=25
		IF TeleBanking
			lRefreshMenu:=true
		ENDIF

	ENDIF
	FillPersCode()
	FillPersType()
	FillPersGender()
	FillPersTitle()
	FillPropTypes()
	FillPersProp()
	FillIbanregistry() 
	FillCountryNames()
	SetCollate()
	aAsmt:={{"assessable","AG"},{"charge","CH"},{"membergift","MG"},{"pers.fund","PF"}}
	LENPRSID:=11
	LENEXTID:=11
	if !ConI(SQLSelect{"select count(*) as total from department",oConn}:total)==0
		Departments:=true
	endif

	IF lRefreshAllowed .and. lRefreshMenu .and. !Empty(MYEMPID)  // reason to refresh menu and already logged in?
		oMainWindow:RefreshMenu()
		oMainWindow:SetCaption(oSys:sysname)
	ENDIF
	RETURN nil
	
FUNCTION IsAlphabetic(m_str as string) as logic
* Check if string m-str is alphabetic
LOCAL p_str as STRING,p_num_tel as int 
IF Empty(m_str)
   RETURN FALSE
ENDIF
p_str:=AllTrim(m_str) 
FOR p_num_tel:=1 to Len(p_str)
    IF IsDigit(psz(_cast,SubStr(p_str,p_num_tel,1)))
       RETURN FALSE
    ENDIF
NEXT
RETURN true
FUNCTION IsDutchBanknbr(cGetal)
	* check if bankaccount# of a ducth bank is "11-proef"
	LOCAL nL,i, nCheck as int
	cGetal:=Str(Val(StrTran(cGetal,".","")),-1)
	nL:=Len(cGetal)
	if nL<9 .or. nL>10
		return false
	endif
	if nL==9
		FOR i:=1 to nL
			nCheck+=Val(SubStr(cGetal,i,1))*(10-i)
		NEXT
		return (Mod(nCheck,11)==0)
	else
		return true
	endif
Function IsIban(Iban as string) as logic
	
	// Verify an Iban number.  Returns true or false.
	//  NOTE: Input can be printed 'IBAN xx xx xx...' or machine 'xxxxx' format. 
	// So convert if before with IbanFormat

	local IBanTemp,country,regex as string
	local nPos,nChecksum,i,qty,nDisp as int 
	local aReg:={} as array


	// Format should be standdardized with IbanFormat()
	
	// Get country of Iban
	country:=SubStr(Iban,1,2)

	// Test length of Iban 
	if (nPos:=AScan(iban_registry,{|x|x[1]==country}))>0
		if !Len(Iban)==iban_registry[nPos,3] 
			return false
		endif
	else
		return false
	endif

	// Get country-specific Iban format regex 
	regex:=SubStr(iban_registry[nPos,2],3) 
	aReg:=Split(regex,'!') 
	nDisp:=3      // skip first 2 positions with country code 
	// Check regex
	qty:=Val(aReg[1])
	for i:=2 to Len(aReg) 
		if SubStr(aReg[i],1,1)=='n'
			if !isnum(SubStr(Iban,nDisp,qty))
				return false
			endif
		elseif SubStr(aReg[i],1,1)=='a'
			if !IsAlphabetic(SubStr(Iban,nDisp,qty))
				return false
			endif
		endif
		nDisp+=qty
		qty:=Val(SubStr(aReg[i],2))
	next

	// verify checksum:
	
	nChecksum:=IbanChecksum(Iban)
	// checkvalue of 97 indicates correct Iban checksum
	if (nChecksum != 97)
		return false
	endif

	// Otherwise it 'could' exist
	return true
FUNCTION IsMod10(cAmount as string) as logic
// test if cAmount (string of a mod10 number) satisfies mod10 criteria (Luhn algoritme)
LOCAL sum,i,length:=Len(cAmount),temp as int
LOCAL alt:=FALSE as LOGIC

	FOR i:=length DOWNTO 1 step 1
		IF alt
			temp := Val(SubStr(cAmount,i,1))*2
			IF temp > 9
				temp:= temp - 9
			ENDIF
		ELSE
			temp:=Val(SubStr(cAmount,i,1))
		ENDIF
		sum += temp
		alt := !alt
	NEXT
	RETURN ((sum % 10) == 0)
Function IsMod11(cAmount as string) as logic
local nL:=Len(cAmount) as int
// check if cAmount is  modulo 11 for dutch betalingskenmerk
if nL=7       // 7 is fixed length without check digit
	return true
endif
if nL<7
	return false
endif
if nL=8 .or.nL>=16
	return (cAmount==Mod11(SubStr(cAmount,2))) 
else
	return (cAmount==Mod11(SubStr(cAmount,2))) 	
endif

	
Function IsModulus11(cNumber as string) as logic
local lres as usual
lres:=Modulus11(SubStr(cNumber,1,Len(cNumber)-2))
if IsLogic(lres)
	return false
else
	return (lres==SubStr(cNumber,Len(cNumber)-1,2))
endif

FUNCTION isnum (m_str as string ) as logic
* Check if string m-str is numeric
LOCAL p_str as STRING,p_num_tel as int
IF Empty(m_str)
   RETURN FALSE
ENDIF
p_str:=RTrim(m_str)
FOR p_num_tel:=1 to Len(p_str)
    IF IsAlpha(psz(_cast,SubStr(p_str,p_num_tel,1))) .or.Empty(SubStr(p_str,p_num_tel,1))
       RETURN FALSE
    ENDIF
NEXT
RETURN true
FUNCTION IsPunctuationMark(m_str as string) as logic
* Check if string m-str contains punctuation marks
LOCAL p_str as STRING,p_num_tel as int
local mchar as psz 
IF Empty(m_str)
   RETURN false
ENDIF
p_str:=AllTrim(m_str) 
FOR p_num_tel:=1 to Len(p_str)
	mchar:= psz(_cast,SubStr(p_str,p_num_tel,1))
    IF !Empty(mchar) .and. !IsAlpha(mchar) .and. !IsDigit(mchar)	
       RETURN true
    ENDIF
NEXT
RETURN false
Function IsSEPA(Iban as string) as logic
	// check if a banknumber is a valid sepa banknumber
	local country as string
// 	local sepacountries:={"FI","AT","BE","BG","CY","CZ","DK","FI","FR","DE","GI","GR","FR","HU",;
// 		"IS","IE","IT","LI","LT","LU","MT","MC","NL","NO","PL","PT","RO","SK","SI","ES","SE","CH","GB"} as  array
	country:=SubStr(Iban,1,2)
	if AScanExact(iban_registry,{|x|x[4]=1.and.x[1]==country})=0
		return false
	endif
	return IsIban(Iban)
DEFINE LF                   := _chr(10)
CLASS ListboxBal INHERIT ListBox
* Special version of listbox to support multiple selection of Departments
PROTECT cDepStart, cDepStartName as STRING  // range of Departmentnumbers
PROTECT cCurStart as STRING // Current values used in list
protect aItem:={} as array  // container for departments 
declare method AddSubDep
// ACCESS Server CLASS ListBoxBal
// RETURN oDepartment
// ASSIGN Server(oDep) CLASS ListboxBal
// oDepartment:=null_object
// oDepartment:=oDep
// RETURN oDepartment
METHOD AddSubDep(aDep as array,ParentNum:=0 as int, nCurrentRec:=0 as int) as int  CLASS ListBoxBal
	* Find subdepartments and add to arrays with departments
	LOCAL nChildRec			as int
	LOCAL nCurNum			as int

	IF !Empty(nCurrentRec).and.!aItem[nCurrentRec,2]==ParentNum
		nCurrentRec:=0
	endif
	nCurrentRec:=AScan(aItem,{|x|x[2]==ParentNum},nCurrentRec+1)
	IF Empty(nCurrentRec)
		return 0
	endif
	nCurNum:= aItem[nCurrentRec,1]
	if aItem[nCurrentRec,5]>0 // accounts under it? 
		AAdd(aDep,{aItem[nCurrentRec,4]+Space(1)+aItem[nCurrentRec,3],nCurNum})
	endif
	
	// add all child departments:
	DO WHILE true
		nChildRec:=self:AddSubDep(aDep,nCurNum, nChildRec)
		IF Empty(nChildRec)
			exit
		ENDIF
	ENDDO
	RETURN nCurrentRec
ACCESS DepNameStart CLASS ListBoxBal
RETURN cDepStartname
ASSIGN DepNameStart(cValue) CLASS ListBoxBal
cDepStartname:=cValue
RETURN cValue
ACCESS DepNbrStart CLASS ListBoxBal
RETURN cDepStart
ASSIGN DepNbrStart(cValue) CLASS ListBoxBal
cDepStart:=cValue
self:Refill()
RETURN cValue
METHOD GetDepnts() CLASS ListBoxBal
	LOCAL oDep as SQLSelect
	LOCAL aDep:={} as ARRAY
	LOCAL nStart as int, nCurRec as int 
	LOCAL oDep as SQLSelect
	// fill array with departments
	if Empty(aItem)
		// select all departments with accounts:
		oDep:=SQLSelect{"SELECT d.depid,d.parentdep,d.descriptn,d.deptmntnbr,count(a.accid) as acccnt "+;
			"FROM `department` d left join `account` a on(a.department=d.depid) where d.active=1 group by d.depid order by parentdep,deptmntnbr",oConn}
		if oDep:RecCount>0
			do while !oDep:EoF
				AAdd(aItem,{oDep:DepId,oDep:parentdep,oDep:descriptn,oDep:deptmntnbr,ConI(oDep:acccnt)})
				//          		 1         2           3              4                  5
				oDep:Skip()
			enddo
		else
			return {}
		endif
	endif

	* Enforce correct sequence:
	nStart:=Val(self:cDepStart)


	* Check and fill requested Departments:
	IF Empty(nStart)
		* Top department is WO Office:
		aDep:={{cDepStartName,0}}
	else
		nCurRec:=AScan(aItem,{|x|x[1]==nStart.and.x[5]>0})
		if nCurRec>0 
			aDep:={{aItem[nCurRec,4]+Space(1)+aItem[nCurRec,3],aItem[nCurRec,1]}}
		endif
		nCurRec:=0
	ENDIF

	* Add all subdepartments down from WhoFrom:
	DO WHILE true
		nCurRec:=self:AddSubDep(aDep,nStart,nCurRec)
		IF Empty(nCurrec)
			exit
		ENDIF
	ENDDO

	RETURN aDep
METHOD GetRetValues () CLASS ListBoxBal
	RETURN self:aRetValues
METHOD GetSelectedItems () CLASS ListBoxBal
LOCAL aDep:={} as ARRAY
LOCAL nPos as int
* Check if listbox has been activated since last rnage change:
// IF !self:cDepStart==self:cCurStart
// 	* RETURN all Departments within range:
// 	RETURN (AEvalA(self:GetDepnts(),{|x| x[2]}))
// ENDIF
nPos :=self:FirstSelected()
DO WHILE nPos>0
	AAdd(aDep,self:getItemValue(nPos))
	nPos:=self:NextSelected()
ENDDO
RETURN aDep
METHOD Refill() CLASS ListBoxBal
LOCAL i as int
IF !cDepStart==cCurStart
	* Range has been changed, thus new selection:
	self:FillUsing( self:GetDepnts())
	cCurStart:=cDepStart
	* Select all:
    FOR i = 1 to self:ItemCount
    	self:SelectItem(i)
    NEXT

ENDIF
RETURN nil
CLASS ListBoxExtra INHERIT ListBox
	* Special version of listbox to support multiple selection of accounts
	export cAccStart, cAccEnd as STRING  // range of accountnumbers
	export cCurStart,cCurEnd as STRING // Current values used in list 
	PROTECT oAccount as SQLSelect  
	export aBalIncl,aDepIncl as array 
	EXPORT cDepIncl,cBalIncl as STRING

	declare method GetAccnts,GetAccounts,GetSelectedItems
ACCESS AccNbrEnd CLASS ListBoxExtra
	RETURN cAccEnd
ASSIGN AccNbrEnd(cValue) CLASS ListBoxExtra
	cAccEnd:=cValue
	self:Refill()
	RETURN cValue
ACCESS AccNbrStart CLASS ListBoxExtra
	RETURN self:cAccStart
ASSIGN AccNbrStart(cValue) CLASS ListBoxExtra
	self:cAccStart:=cValue
	self:Refill()
	RETURN cValue
METHOD GetAccnts(dummy:=nil as string) as array CLASS ListBoxExtra
	// LOCAL oAcc as account 
	Local oSQL as SQLSelect
	LOCAL aAcc:={} as ARRAY
	LOCAL cExchAcc, cStart, cEnd, cWhere as STRING
	LOCAL lSuc as LOGIC
	local cBalIncl,cDepIncl as string
	* Enforce correct sequence:
	cStart:=LTrimZero(self:cAccStart)
	cEnd:=LTrimZero(self:cAccEnd)
	IF Empty(cStart).and.Empty(cEnd)
		RETURN {}
	ENDIF
	IF !Empty(cEnd).and. cStart>cEnd
		cExchAcc := cEnd
		cEnd:=cStart
		cStart:=cExchAcc
	ENDIF
	
	if !Empty(cStart).and.!Empty(cEnd)
		cWhere:="accnumber between '"+cStart+"' and '"+cEnd+"'"
	elseif !Empty(cStart)
		cWhere:="accnumber>='"+cStart+"'"
	else
		cWhere:="accnumber<='"+cStart+"'"
	endif
	if !Empty(self:cDepIncl)
		cWhere+=iif(Empty(cWhere),""," and ")+" department in ("+cDepIncl+")" 
	endif
	if !Empty(cBalIncl)
		cWhere+=iif(Empty(cWhere),""," and ")+" balitemid in ("+cBalIncl+")" 
	endif

	oSQL:=SQLSelect{"select accnumber,description,accid,department,balitemid from account where giftalwd=1 and "+cWhere ,oConn}
	oSQL:Execute()
	DO WHILE !oSQL:EoF
		AAdd(aAcc,{Pad(oSQL:accnumber,LENACCNBR)+" "+oSQL:description,oSQL:accid})
		oSQL:Skip()
	ENDDO
	RETURN aAcc
METHOD GetAccounts(dummy:=nil as string) as array CLASS ListBoxExtra
	// get accounts for subset of listbox
	LOCAL aAcc:={} as ARRAY
	LOCAL cExchAcc, cStart, cEnd as STRING
	LOCAL oParent:=self:Owner as DataWindow
	LOCAL aMemHome:=oParent:aMemHome as ARRAY
	LOCAL aMemNonHome:=oParent:aMemNonHome as ARRAY
	LOCAL aProjects:=oParent:aProjects as ARRAY
	LOCAL lHome:=oParent:HomeBox,lNonHome:=oParent:NonHomeBox,lProjects:=oParent:ProjectsBox as LOGIC
	* Enforce correct sequence:
	cStart:=LTrimZero(oParent:selx_rek)
	cEnd:=LTrimZero(oParent:selx_rekend)
	IF Empty(cStart).and.Empty(cEnd)
		RETURN {}
	ENDIF
	IF !Empty(cEnd).and. cStart>cEnd
		cExchAcc := cEnd
		cEnd:=cStart
		cStart:=cExchAcc
	ENDIF
	IF lHome
		AEval(aMemHome,{|x| FilterAcc(aAcc,x,cStart,cEnd,{},{})})
	ENDIF
	IF lNonHome
		AEval(aMemNonHome,{|x| FilterAcc(aAcc,x,cStart,cEnd,,)})
	ENDIF
	IF lProjects
		AEval(aProjects,{|x| FilterAcc(aAcc,x,cStart,cEnd,,)})
	ENDIF
	RETURN aAcc   
METHOD GetRetValues () CLASS ListBoxExtra
	RETURN self:aRetValues
METHOD GetSelectedItems (dummy:=nil as logic) as array CLASS ListBoxExtra
LOCAL aAcc:={} as ARRAY
LOCAL nPos as int
* Check if listbox has been activated since last range change:
// IF !self:cAccStart==self:cCurStart.or.!self:cAccEnd==self:cCurEnd
// 	* RETURN all accounts within range:
// 	RETURN (AEvalA(self:GetAccnts(null_string),{|x| x[2]}))
// ENDIF
nPos :=self:FirstSelected()
DO WHILE nPos>0
	AAdd(aAcc,self:getItemValue(nPos))
	nPos:=self:NextSelected()
ENDDO
RETURN aAcc

		

	
METHOD Refill() CLASS ListBoxExtra
	LOCAL i as int
	// IF !cAccStart==cCurStart.or.!cAccEnd==cCurEnd
	* Range has been changed, thus new selection:
	self:FillUsing( self:GetAccnts(null_string))
	cCurStart:=cAccStart
	cCurEnd:=cAccEnd
	* Select all:
	FOR i = 1 to self:ItemCount
		self:SelectItem(i)
	NEXT

	// ENDIF
	RETURN nil
ACCESS Server CLASS ListBoxExtra
RETURN oAccount
ASSIGN Server(oAcc) CLASS ListBoxExtra
oAccount:=null_object
oAccount:=oAcc
RETURN oAccount
ASSIGN WhatFrom(cValue) CLASS ListBoxExtra 
	self:aBalIncl:={}
	if !Empty(cValue)
		self:cBalIncl:= SetAccFilter(Val(cValue))
		self:aBalIncl:=Split(self:cBalIncl,",")
	endif

	self:Refill()
	RETURN cValue
ASSIGN WhoFrom(cValue) CLASS ListBoxExtra 
	self:aDepIncl:={}
	if !Empty(cValue)
		self:cDepIncl:= SetDepFilter(Val(cValue))
		self:aDepIncl:=Split(self:cDepIncl,',')
	endif

	self:Refill()
	RETURN cValue
Access MyImageIndex() class ListViewItem
RETURN self:nImageIndex
FUNCTION LogEvent(oWindow:=null_object as Window,strText as string, Logname:="Log" as string) as logic
	*	Logging of info to file <Logname>.txt
	LOCAL ToFileFS as FileSpec
	LOCAL cFileName, selftext as STRING
	LOCAL ptrHandle 
	local oStmnt as SQLStatement
	local lDBError, lFile as logic 
	local oMl as sendemailsdirect

	*	Logging of info to table log 
	if AtC("Access denied for user",strText)>0
		ErrorBox{,"Access denied to database"+':'+dbname+CRLF+strText}:Show()
		return true
	endif 
// 	if oConn=null_object
// 		lDBError:=true
// 	elseif SqlSelect{"show tables like 'log'",oConn}:RecCount<1 
	if SqlSelect{"show tables like 'log'",oConn}:RecCount<1
		lDBError:=true
	elseif Logname=='LogFile'
		lFile:=true  // forced to log to File
	else
		oStmnt:=SQLStatement{"insert into log set `collection`='"+Lower(Logname)+"',logtime=now(),`source`='"+;
		iif(IsObject(oWindow),Symbol2String(ClassName(oWindow)),"")+"',`message`='"+AddSlashes(strText)+"',`userid`='" +LOGON_EMP_ID+"'",oConn}
		oStmnt:execute()
		If !Empty(oStmnt:status)
			lDBError:=true
		endif
	endif
	if lDBError .or. lFile
		// write to file
		ToFileFS:=FileSpec{Logname}
		ToFileFS:Extension:="TXT"
		ToFileFS:Path:=CurPath
		cFileName:=ToFileFS:FullPath
		IF	ToFileFS:Find()
			ptrHandle := FOpen(ToFileFS:FullPath,FO_READWRITE+FO_DENYNONE)
		ELSE
			ptrHandle := FCreate(ToFileFS:FullPath)
		ENDIF	
		IF	ptrHandle==nil	.or.ptrHandle = F_ERROR
			RETURN FALSE
		ENDIF
		* position file at end:
		FSeek(ptrHandle, 0, FS_END)
		selftext:=DToS(Today())+" "+Time()+" -	"+strText
		IF	IsObject(oWindow)
			selftext:=Symbol2String(ClassName(oWindow))+": "+selftext
		ENDIF
		FWriteLine(ptrHandle,selftext)
		FClose(ptrHandle) 
	endif
	if lDBError.or.(Lower(Logname)=="logerrors" .and. AtC("MySQL server has gone away",strText) >0)
		ErrorBox{,"MySQL server has gone away:"+CRLF+strText}:Show()
// 		if !Empty(oStmnt:status) 
			break
// 		endif
	endif
	if Lower(Logname)=="logerrors"
		// email error to system administrator:
		oMl:=SendEmailsDirect{oMainWindow,true} 
		oMl:AddEmail("Wos error "+sEntity+' - '+dbname+' - '+servername,;
		iif(IsObject(oWindow),Symbol2String(ClassName(oWindow)),"")+",userid=" +LOGON_EMP_ID+",server="+servername+",database="+dbname+",message="+strText,{{'',"karel_kuijpers@wycliffe.net",''}},{})
		oMl:SendEmails()
		
	endif
	RETURN true
FUNCTION LTrimZero(cString as STRING) as STRING
* Left trim leading zeroes in string
RETURN ZeroTrim(cString)		
FUNCTION MakeAbrvCod(cCodes as STRING) as array
* Translates string with mailing code abbravations (separated by space)  to array of mailing code identifiers
LOCAL aAbCodes as ARRAY
LOCAL i,j as int
LOCAL aCode:={} as ARRAY
aAbCodes:=Split(Upper(Compress(cCodes))," ")
FOR i=1 to Len(aAbCodes)
	if (j:=AScan(mail_abrv,{|x|x[1]== aAbCodes[i]}))>0
		AAdd(aCode,mail_abrv[j,2])
	ENDIF
NEXT
RETURN aCode
FUNCTION MakeCod(mCodes as ARRAY) as string
	* Compose mailingcodes from array with fields mCod1 .. mCodn
	LOCAL aCode := {}
	LOCAL i as int
	LOCAL cCod := "" as STRING
	
	FOR i = 1 to Len(mCodes)
		IF !IsNil(mCodes[i])
			IF Len(AllTrim(mCodes[i]))=2
				IF AScan(aCode,mCodes[i])=0
					AAdd(aCode,mCodes[i])
				ENDIF
			ENDIF
		ENDIF
	NEXT
	return Implode(aCode," ")
FUNCTION MakeCodes(Codes as ARRAY)
* Compose clean array from array with code-objects
	LOCAL aCod as ARRAY
	LOCAL i as int
	aCod := {}
	FOR i = 1 to Len(Codes)
		IF !Empty(Codes[i])
			IF AScan(aCod,Codes[i])=0
				AAdd(aCod,Trim(Codes[i]))
			ENDIF
		ENDIF
	NEXT
RETURN aCod
FUNCTION MakeFile(oOwner:=null_object as window,cFileName ref string,cDescription as string) as ptr
* Create a file Filename and return handler; in case of error return doserror, in case of cancel returns nil
LOCAL ptrHandle as ptr
LOCAL oFileSpec as Filespec
LOCAL MyFileName,MyPath as STRING, nReturn as int
LOCAL oTextBox as TextBox, oFileDialog as SaveAsDialog 
local fileerror as string 

// cFileName:=CleanFileName(cFileName)
oFileSpec:=FileSpec{cFileName}
cFileName:= oFileSpec:FullPath
DO WHILE true
	ptrHandle := FCreate(cFileName)
	IF ptrHandle = F_ERROR 
		fileerror:=DosErrString(FError() )
		oFileSpec:=FileSpec{cFileName}
		MyFileName:=oFileSpec:FileName+oFileSpec:Extension
		MyPath:=StrTran(oFileSpec:FullPath,MyFileName,'')
		oTextBox:=TextBox{oOwner,cDescription,"Could not create file "+MyFileName+" at "+MyPath+CRLF+"; Error:"+fileerror,;
		BUTTONRETRYCANCEL}
		nReturn:=oTextBox:Show()
		IF nReturn== BOXREPLYRETRY	
			oFileDialog := SaveAsDialog{ oOwner, cFileName  }
			oFileDialog:SetStyle(OFN_HIDEREADONLY)
			IF oFileDialog:Show()
				cFileName:=oFileDialog:FileName
				loop
			ELSE
				exit
			ENDIF
		ELSEIF nReturn==BOXREPLYCANCEL
			RETURN null_ptr
		ENDIF
	ELSE
		exit
	ENDIF
ENDDO
RETURN ptrHandle
Function MakeFilter(aAccIncl:=null_array as array,aTypeAllwd:=null_array as array,IsMember:="B" as string,giftalwd:=2 as int,;
SubscriptionAllowed:=false as logic,aAccExcl:=null_array as array) as string
// make filter condition for account
// aTypeAllwd: arrays with allowed balance catagories: Income, expense, asset, liability
// IsMember: M: member, N: not member, B: both (default), E: entity member(project)
// giftalwd: 1=true / 0=false/2: don't care
// SubscriptionAllowed: true/false
// aAccIncl: accounts to be included (id as string)
// aAccExcl: extra accounts to be excluded (id as string) 
// returns array with filter expression text
LOCAL cFilter, cType, cAcc, cIncl as STRING, i,j as int
// LOCAL bFilter as _CODEBLOCK
LOCAL aType:={"AK","PA","BA","KO"} as ARRAY
LOCAL aTypeAcc:={{SDEB,SKAS,SKruis},{SHB,SKAP,SPROJ},{SAM,SAMProj,SDON,SINC,SPROJ},{SEXP,SPOSTZ}} as ARRAY 
// if Empty(aTypeAllwd)
// 	aTypeAllwd:={"AK","PA","BA","KO"}
// endif
IF !Empty(aTypeAllwd)
	FOR i:=1 to Len(aTypeAllwd)
		j:=AScan(aType,aTypeAllwd[i])
		IF j>0 
			cType+=' or b.category="'+aType[j]+'"'        // function rejected in VO28
			AEval(aTypeAcc[j],{|x|cFilter+=iif(Val(x)=0,'',iif(AScan(aAccIncl,x)>0,'',' and a.accid<>'+x))})
		ENDIF
	NEXT
	IF !Empty(cType)
		cFilter+=' and ('+SubStr(cType,5)+')'
//		self:ForBlock:=SubStr(cType,5)
	ENDIF
// ELSE
// 	AEval(aAccExcl,{|x|cFilter+=iif(Val(x)=0,'',iif(AScan(aAccIncl,x)>0,'',' and a.accid<>'+x))})
ENDIF
AEval(aAccExcl,{|x|cAcc+=iif(Val(x)=0,'',iif(AScanExact(aAccIncl,x)>0,'',','+x))})
IF !Empty(cAcc)
	cFilter+=iif(Empty(cFilter),'',' and ')+"a.accid not in ("+SubStr(cAcc,2)+")"
ENDIF

IF !Empty(aAccIncl)
	AEval(aAccIncl,{|x|cIncl+=iif(Val(x)=0,'',iif(Empty(cIncl),"",' or ')+'a.accid='+x)})
ENDIF	
IF IsMember=="M"
	cFilter+=' and (a.accid in (select accid from member where accid IS NOT NULL) or a.department in (select depid from member where depid IS NOT NULL))'
ELSEIF IsMember=="N"
	cFilter+=' and a.accid not in (select accid from member where accid IS NOT NULL) and a.department not in (select depid from member where depid IS NOT NULL)'
ENDIF
IF giftalwd=0
	cFilter+=' and a.giftalwd<>1'
elseif giftalwd=1	
	cFilter+=' and a.giftalwd=1'
ENDIF
IF !SubscriptionAllowed
	cFilter+=' and a.subscriptionprice=0'
ENDIF	
IF SubStr(cFilter,1,5)==' and '
	cFilter:=SubStr(cFilter,6)
ENDIF
IF !Empty(cIncl)
	cFilter+=' or '+cIncl 
ENDIF
if !Empty(cFilter) 
	Return "("+cFilter +")"
else
	Return ''
endif
FUNCTION MarkUpAddress(oPers as SQLSelect,p_recnr:=0 as int,p_width:=0 as int,p_lines:=0 as int) as array
******************************************************************************
*  Name      : MarkUpAddress
*              Composition of full name and address of a person
*  Author    : K. Kuijpers
*  Date      : 01-01-1991
******************************************************************************

************** PARAMETERS and DECLARATION OF VARIABELES ***********************
* p_recnr    : recordnumber recipient in Person; default current
*              person-record
* p_width    : width address lines, default as long as needed for the data
* p_lines	 : required number of lines, default 6
* Global variable sFirstNmInAdr, determined in system parameters:
*            : .t.=use first name within address lines
*              .f.=use initials in address lines (default)
* Global variable sSalutation, specified in systemparams:
*            : .t.=show salutation in Address (default)
*              .f.=no salutation in address 
* Global variable sSTRZIPCITY, specified in system params:
*				0: address, zip, city, country  
*				1: postalcode,city, address, country 
*				2: country, postalcode city, address,  (Russia)
*				3: address, city, zip, country   (USA, Canada)
* Global CITYUPC: true: City name in uppercase, false: only first character uppercase 
* Global LSTNUPC: true: last name in uppercase, false: only first character uppercase 
* Returns: ARRAY met adressen + IN nederland 1 extra row met Kixkode
LOCAL arraynr:=0 as int,naam1:='',titel:='',naam2:='', lstnm as STRING
LOCAL i,j,aant as int
LOCAL m_AdressLines := {} as ARRAY
LOCAL stoppen := true
LOCAL regel as STRING
LOCAL cKixcd := "" as STRING
LOCAL cHuisnr:="",cToev as STRING
LOCAL nToevPos as int
LOCAL cCity as STRING
LOCAL frstnm as STRING 
// Local oPers:= oMyPers as SQLSelectPerson
local nSTRZIPCITY:=sSTRZIPCITY as int
local cAD1 as string, nLFPos as int, aAd1, aAd2 as array 
IF .not.Empty(p_recnr)
	oPers:Goto(p_recnr)
ENDIF
IF oPers:EOF
	RETURN nil
ENDIF
IF Empty(p_width)
	p_width := 99
ENDIF
IF Empty(p_lines)
	p_lines := 6
ENDIF
arraynr :=  p_lines + if(CountryCode="31",1,0)
ASize(m_AdressLines, arraynr)
AFill(m_AdressLines," ")
if .not. Empty(oPers:country)
	IF Upper(oPers:country)="USA" .or.Upper(oPers:country)="UNITED STATES".or.Upper(oPers:country)="CANADA".or.Upper(oPers:country)="U.S.A."
		nSTRZIPCITY:=3
	ELSEIF Upper(oPers:country)="RUSSIA"
		nSTRZIPCITY:=2
	ENDIF
endif
/* Filling address lines in following sequence:
1: Kixkode in extra line (for dutch addresses)
2: Country in last line (optional)
3: Zip code and City in previous line
4: Street and housenbr in previous lines
5: Attention in previous line
6: Last name and name extenion in first lines
*/
* Determine Kix Barkode:
IF CountryCode="31"
	IF Empty(oPers:country) .or. Upper(oPers:country) == "NEDERLAND"
		* Determine housenbr:
		nLFPos:=At(CRLF,oPers:address)
		if nLFPos>0
			cAD1:=AllTrim(SubStr(oPers:address,1,nLFPos-1))
		else
			cAD1:=oPers:address
		endif
		FOR i = Len(cAD1) to 2 step -1
			IF IsDigit(psz(_cast,SubStr(cAD1,i,1)))
				IF Empty(cHuisnr)
					nToevPos := i+1
				ENDIF
				cHuisnr := SubStr(cAD1,i,1)+cHuisnr
			ELSE
				IF !Empty(cHuisnr)
					exit
				ENDIF
			ENDIF
		NEXT
		IF nToevPos >0 .and. nToevPos <= Len(cAD1)
			cToev := SubStr(cAD1,nToevPos,6)
		ENDIF
		cKixcd := oPers:postalcode+ cHuisnr+if(!Empty(cToev),"X"+cToev,"")
	ENDIF
	m_AdressLines[arraynr] := cKixcd
	--arraynr
ENDIF
IF .not. Empty(oPers:country).and. nSTRZIPCITY#2 .and.arraynr>0
	IF AScan(OwnCountryNames,{|x| Upper(AllTrim(x))=Upper(AllTrim(oPers:country))})=0
		m_AdressLines[arraynr] := SubStr(AllTrim(oPers:country),1,p_width)
	   --arraynr
	ENDIF
ENDIF
cCity := oPers:city
if CITYUPC
	cCity:=Upper(cCity)
endif
IF nSTRZIPCITY==3
	cCity:= AllTrim(cCity+ " "+oPers:postalcode)
ELSE
	cCity := AllTrim(oPers:postalcode+' '+cCity)
ENDIF

IF .not. Empty(cCity).and. nSTRZIPCITY#2.and.nSTRZIPCITY#1 .and.arraynr>0
   m_AdressLines[arraynr] := SubStr(AllTrim(cCity),1,p_width)
   --arraynr
ENDIF
aAd2:={}
IF .not. Empty(oPers:address) .and.arraynr>1
	// fill intermediate array aAd2
	aAd1:=Split(oPers:address,CRLF)
	For j:=1 to Len(aAd1)
   	FOR i=1 to MLCount(aAd1[j],p_width)
			regel	:=	MemoLine(aAd1[j],p_width,i)
			IF	Empty(regel) 
				loop
			ENDIF
			AAdd(aAd2,regel)
   	Next
	NEXT
	if Len(aAd2) >= arraynr.and. arraynr>1
		ASize(aAd2,arraynr-1)
	endif
	for i:=Len(aAd2) to 1 step -1
		m_AdressLines[arraynr] := AllTrim(aAd2[i])
		--arraynr
	next
ENDIF
IF  (nSTRZIPCITY==2 .or. nSTRZIPCITY==1) .and.!Empty(cCity) .and.arraynr>0
   m_AdressLines[arraynr] := SubStr(AllTrim(cCity),1,p_width)
   --arraynr
ENDIF
IF .not. Empty(oPers:country).and. nSTRZIPCITY==2 .and.arraynr>0
	IF AScan(OwnCountryNames,{|x| Upper(AllTrim(x))=Upper(oPers:country)})=0
		m_AdressLines[arraynr] := SubStr(oPers:country,1,p_width)
	   --arraynr
	ENDIF
ENDIF


IF .not. Empty(oPers:attention).and. arraynr >0
	m_AdressLines[arraynr] := oPers:attention
   --arraynr
ENDIF
IF arraynr > 0
	aant := arraynr
	IF sSalutation
		titel := Salutation(oPers:gender)
	ENDIF
	IF.not.Empty(titel)
	   titel := titel+' '
	ENDIF
	IF TITELINADR .and.!Empty( oPers:Title )
		titel += Title(oPers:Title)+' '
	ENDIF
	IF .not. Empty(oPers:prefix)
	   naam1 += oPers:prefix+' '
	ENDIF
	IF .not. Empty(oPers:lastname)
		lstnm:=oPers:lastname
		if LSTNUPC
			lstnm:=Upper(lstnm)
// 		else
// 			lstnm:=Upper(SubStr(lstnm,1,1))+Lower(SubStr(lstnm,2))
		endif
	   naam1 += lstnm+' '
	ENDIF

	IF sFirstNmInAdr
		IF !Empty(oPers:firstname)
  			frstnm += oPers:firstname+' '
		ELSEIF .not. Empty(oPers:initials)  && anders voorletters gebruiken
  			frstnm += oPers:initials+' '
		ENDIF
	ELSEIF .not. Empty(oPers:initials)  && anders voorletters gebruiken
  		frstnm += oPers:initials+' '
	ENDIF		
	IF sSurnameFirst
    	naam1 += frstnm
    ELSE
    	naam1 := frstnm+naam1
    ENDIF
	naam2 := oPers:nameext
	IF .not.Empty(titel)
	   IF Len(titel)+Len(naam1)+Len(naam2) > p_width
    	  IF aant == 1.or.p_width<25
	      *  Bij weinig ruimte titel verkorten:
    	     titel := AllTrim(SubStr(titel,1,4))+' '
	      ENDIF
	   ENDIF
	ENDIF
	naam1 := titel+naam1
	IF aant == 1
	   * Nog maar 1 regel beschikbaar: samenvoegen en afkappen:
	   naam1 := SubStr(AllTrim(naam1)+' '+naam2,1,p_width)
	   naam2 := ''
	ELSE  && meer regels:
	   IF Len(naam2)>p_width.or.Len(naam1)>p_width
    	  * problemen met breedte, ook samenvoegen:
	      naam1 := naam1+if(Empty(naam2),'',' '+naam2)
    	  naam2 := ''
	   ENDIF
	ENDIF
*	arraynr := 0  && naam aan het begin
	stoppen := FALSE
	IF MLCount(naam1,p_width) < aant .and. !Empty(naam2)
		 m_AdressLines[arraynr] := AllTrim(naam2)
		 --arraynr
	ENDIF
	FOR i=Min(aant,MLCount(naam1,p_width)) to 1 step -1
	   regel := MemoLine(naam1,p_width,i) && verdelen over meerdere regels
    	m_AdressLines[arraynr] := AllTrim(regel)
    	--arraynr
	NEXT
ENDIF
RETURN m_AdressLines
DEFINE MASCULIN := 2
Function MergeMLCodes(CurCodes as string,NewCodes as string) as string
// Merge mailing codes in string NewCodes into string CurCodes
	LOCAL aPCod,aNCod as ARRAY, iStart as int
	if Empty(NewCodes)
		return CurCodes
	endif
	aPCod:=Split(AllTrim(CurCodes)," ")
	aNCod:=Split(AllTrim(NewCodes)," ")
	iStart:=Len(aPCod)
	
	ASize(aPCod,iStart+Len(aNCod))
	ACopy(aNCod,aPCod,1,Len(aNCod),iStart+1) 
	return MakeCod(aPCod)	
Function MLine4(cBuffer as string, ptrN ref DWORD ) as string
/******************************************************************************
// Extract a line of text from a string, specifying a required offset argument. 
// Identical to MLine3 except that LF is sufficient to separate lines
/******************************************************************************/
Local cLine as string 
Local iEnd as int
iEnd:=At3(LF,cBuffer,ptrN+1)
if Empty(iEnd)
	ptrN:=0
else
	ptrN++
	cLine:= SubStr(cBuffer,ptrN,iEnd-ptrN)
	ptrN:=iEnd
endif	
return cLine 
FUNCTION Mod10(cGetal as string) as string
// Calculate modulo 10 (Luhn algoritme) check digit for cGetal and return it
LOCAL alt:=true as LOGIC
LOCAL i, length:=Len(cGetal),modulo,sum,temp as int

	FOR i:=length DOWNTO 1 step 1
		IF alt
			temp := Val(SubStr(cGetal,i,1))*2
			IF temp > 9
				temp:= temp - 9
			ENDIF
			sum += temp
		ELSE
			sum += Val(SubStr(cGetal,i,1))
		ENDIF
		alt := !alt
	NEXT
    modulo := sum % 10
	IF(modulo > 0)
		RETURN Str(10 - modulo,1,0)
	ELSE
		RETURN "0"
	ENDIF
FUNCTION Mod11(cGetal as string) as string
* Calculates modulo check digit for a number (e.g.Betalingskenmerk):
LOCAL aGew:={10,5,8,4,2,1,6,3,7,9}
LOCAL nL,i, nCheck as int
nL:=Len(cGetal)
if nL<7
	return cGetal // it should be fixed 7 without check digit and length but we assume 7+checkdigit
endif
if nL>7 .and.nL<13
	cGetal:=Str(Mod(nL,10),1)+cGetal       // add length digit
	nL++
endif
FOR i:=1 to nL
	nCheck:=nCheck+Val(SubStr(cGetal,i,1))*aGew[Mod(i-1,10)+1]
NEXT
nCheck:=11-Mod(nCheck,11)
if nCheck==10
	nCheck:=1
elseif nCheck==11
	nCheck:=0
endif
RETURN Str(nCheck,1)+cGetal
FUNCTION Modulus11(cGetal)
* Calculates modulo 11 check digit for Norwegian Social Security Number:
/*
The Norwegian eleven digit birth number is assigned at birth or registration with the National Population Register. 
It is composed of the date of birth (DDMMYY), a three digit individual number, and two check digits. 
The individual number and the check digits are collectively known as the personal number. 
The first check digit is calculated as follows: 
	11 minus the weighted sum modulo 11 of the nine first digits. if the result is 10, the number is invalid and is discarded. 
	if the result is 11, 0 is taken to be the check digit. 
	The last check digit is calculated in a similar manner: 11 minus the weighted sum modulo 11 of the ten first digits 
	(including the first check digit). 
	The weights for the first check digit are 3, 7, 6, 1, 8, 9, 4, 5, 2, 
	the weights for the second check digit are 5, 4, 3, 2, 7, 6, 5, 4, 3, 2.
*/
LOCAL aGew1:={3, 7, 6, 1, 8, 9, 4, 5, 2}, aGew2:={5, 4, 3, 2, 7, 6} as array
LOCAL nL,i, nCheck1, nCheck2 as int
nL:=Len(cGetal)
FOR i:=1 to nL
	nCheck1+=Val(SubStr(cGetal,i,1))*aGew1[Mod(i-1,9)+1]
	nCheck2+=Val(SubStr(cGetal,i,1))*aGew2[Mod(i-1,6)+1]
NEXT
nCheck1:=11-Mod(nCheck1,11)
IF nCheck1=10
	RETURN false
elseIF nCheck1=11
	nCheck1:=0
ENDIF
nCheck2+=nCheck1*aGew2[Mod(i-1,6)+1]
nCheck2:=11-Mod(nCheck2,11)
IF nCheck2=10
	RETURN false
elseIF nCheck2=11
	nCheck2:=0
ENDIF
return Str(nCheck1,1)+Str(nCheck2,1)

FUNCTION MonthEnd (f_month as int, f_year as int) as int
* get last day of given month 
LOCAL f_day := 31 as int
IF f_month == 4 .or. f_month == 6 .or. f_month == 9 .or. f_month == 11
   f_day := 30
ENDIF
IF f_month == 2
   IF (f_year % 4) == 0
      f_day := 29
   ELSE
      f_day := 28
   ENDIF
ENDIF
RETURN f_day
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
CLASS MyFile
PROTECT cBuffer as STRING
// Protect cDelim as STRING
// PROTECT nStart:=0, nIncr:=0 as int
PROTECT nStart:=0 as int
PROTECT ptrHandle as ptr
protect Eof as logic 
protect CP as int 
declare method FReadLine,Close 
METHOD Close(dummy:=nil as logic) as void pascal CLASS MyFile
	FClose(self:ptrHandle)
	self:ptrHandle:=null_ptr
	self:cBuffer:=null_string
RETURN
Access FEof() class MyFile
return self:Eof
METHOD FReadLine(dummy:=nil as logic) as string CLASS MyFile
	LOCAL nSt,nLen,nPos:=0 as int
	LOCAL cLine:="" as STRING
	nPos:=At3(LF, self:cBuffer,self:nStart)
	IF nPos==0
		* read next buffer:
		cLine:=SubStr(self:cBuffer,self:nStart+1) 
		if self:CP>0
			self:cBuffer:=UTF2String{FReadStr(ptrHandle,4096)}:Outbuf
		else
			self:cBuffer:=FReadStr(ptrHandle,65536)
		endif
		IF Empty(self:cBuffer)
			if FEof(self:ptrHandle) .and. Empty(cLine)
				self:Eof:=true
			endif
		ENDIF
		self:nStart:=0
		self:cBuffer:=cLine+self:cBuffer
// 		nPos:=At3(self:cDelim, self:cBuffer,self:nStart)  
		nPos:=At3(LF, self:cBuffer,self:nStart)  
		if nPos=0
			nPos:=Len(self:cBuffer)+1                 // end of file
		endif
	ENDIF
	nSt:=self:nStart+1
	nLen:=nPos-self:nStart-1
	if nPos>1 .and. Asc(SubStr(self:cBuffer,nPos-1,1))==13
		nLen--
	endif
	self:nStart:=nPos
	RETURN SubStr(self:cBuffer,nSt,nLen) 
	
METHOD Init(oFr) CLASS MyFile
	LOCAL UTF8:=_chr(0xEF)+_chr(0xBB)+_chr(0xBF), UTF16:=_chr(0xFF)+_chr(0xFE) as string
	local bufferPtr as string  
	self:ptrHandle:=FOpen2(oFr:FullPath,FO_READ + FO_SHARED)
	IF self:ptrHandle = F_ERROR
		(ErrorBox{,"Could not open file: "+oFr:FullPath+"; Error:("+Str(FError(),-1)+")"+DosErrString(FError())+iif(NetErr(),"; used by someone else","")}):Show()
		self:Eof:=true
		RETURN self
	ENDIF
	bufferPtr:= FReadStr(self:ptrHandle,4096)
	if SubStr(bufferPtr,1,3) == UTF8
		self:CP:=1
		self:cBuffer:=(UTF2String{SubStr(bufferPtr,4)}):Outbuf
	elseif SubStr(bufferPtr,1,2)==UTF16
		self:CP:=2
		self:cBuffer:=(UTF2String{SubStr(bufferPtr,4)}):Outbuf
	else
		self:cBuffer:=bufferPtr
	endif
	IF self:ptrHandle = F_ERROR.or.(self:cBuffer==null_string .and.FEof(self:ptrHandle))
		(ErrorBox{,"Could not read file: "+oFr:FullPath+"; Error:("+Str(FError(),-1)+")"+DosErrString(FError())+iif(NetErr(),"; used by someone else","")}):Show()
		self:Eof:=true
		RETURN self
	ENDIF
// 	IF At(CHR(13)+CHR(10),self:cBuffer)>0
// 		self:cDelim:=CHR(13)+CHR(10)
// 		nIncr:=1
// 	ELSE
// 		self:cDelim:=CHR(10)
// 	ENDIF
	RETURN self
CLASS MyFileSpec INHERIT Filespec
	PROTECT ptrHandle as ptr
METHOD DELETE() CLASS MyFileSpec
	LOCAL nwSize as USUAL
nwSize := FChSize(ptrHandle, 0)
IF nwSize != F_ERROR
	IF FClose(ptrHandle)
		RETURN SUPER:DELETE()
	ENDIF
ENDIF
RETURN FALSE
	
METHOD FileLock() CLASS MyFileSpec
	* Lock the file specified by the filespec exclusive
	ptrHandle := FOpen2(self:FullPath,FO_READ + FO_SHARED)
	IF ptrHandle = F_ERROR
		RETURN FALSE
	ENDIF
	IF !FFLock(ptrHandle,self:Size+6153,1)  // guaranteed two blocks further
		FClose(ptrHandle)
		ptrHandle:=null_ptr
		RETURN FALSE
	ENDIF
    RETURN true
function NetGetConnection(fullpathname as string) as string  
	// get the UNC from mapped path
	LOCAL lpzUNCName:=Space(129) as psz
	LOCAL UNCName as STRING
	LOCAL nLen:=128 as DWORD
	local nError,nPosColon as int
	nPosColon:=At(":",fullpathname) 
	if nPosColon>0
		IF (nError:=WNetGetConnection(SubStr(fullpathname,1,nPosColon),lpzUNCName,@nLen))==NO_ERROR
			UNCName:=AllTrim(Psz2String(lpzUNCName))
		ENDIF
	endif
	RETURN UNCName
	
DEFINE ORGANISATION := 4
FUNCTION PersonGetByExID(oCaller as Object,cValue as string,cItemname as String) as logic
// Find a person by means of its external id
	LOCAL oPers as SQLSelect
	if Empty(cValue)
		return false
	endif
	oPers:=SQLSelect{"select persid from person where deleted=0 and externid='"+cValue+"'",oConn}
	if oPers:RecCount>0 
		IF IsMethod(oCaller, #RegPerson)
			oCaller:RegPerson(oPers,cItemname)
		ENDIF	
	ENDIF
	RETURN (oPers:RecCount>0)
function PersonUnion(id1 as string, id2 as string)
	/* unify two persons id1 and id2 to one id1
	this means:
	1. transfer all transactions of id2 to id1
	2. transfer all subscriptions from id2 to id1
	3. transfer all due amounts from id2 to id1 
	4. transfer all givers/creditors in standing orders from id2 to id1
	5. members?? not allowed 
	*/ 
	Local oPers1,oPers2,oTrans,oSel as SQLSelect
	LOCAL oXMLDocPrs2,oXMLDocPrs1 as XMLDocument 
	local ChildName, cValue as string, recordfound, lSuccess as logic 	
	local oStmt as SQLStatement 
	local cAccId as string
	local cStatement as string 
	local cError as string 
	local aTrTable:={} as array
	local i,nTrans as int
   if !Val(id1)>0 .or. !Val(id2)>0
   	return false
   endif

	// transactions:
	// 	cStatement:=UnionTrans("select persid,transid,seqnr from transaction t where t.dat>='"+SQLdate(Today()+80)+"' and persid="+id2)
	// 	oTrans:=SQLSelect{cStatement,oConn}
	// 	if oTrans:RecCount>0  
	// 		do while !oTrans:EOF 
	// 			oTrans:persid:=id1 
	// 			oTrans:Skip()
	// 		enddo
	// 	endif 
	SQLStatement{"start transaction",oConn}:Execute()
	oStmt:=SQLStatement{'',oConn}
	// Unify persons self:
	oPers1:=SqlSelect{"select p.gender,firstname,initials,title,telbusiness,telhome,mobile,fax,email,cast(birthdate as date) as birthdate,"+;
	"cast(remarks as char) as remarks,mailingcodes,cast(creationdate as date) as creationdate,cast(alterdate as date) as alterdate,cast(datelastgift as date) as datelastgift,"+;
	"address,city,postalcode,country,attention,propextr"+;
	",m.mbrid,m.accid,m.depid"+;
	" from person p left join member m on (m.persid=p.persid) where p.persid="+id1,oConn}
	oPers2:=SQLSelect{"select p.gender,firstname,m.mbrid,initials,title,telbusiness,telhome,mobile,fax,email,cast(birthdate as date) as birthdate,"+;
	"cast(remarks as char) as remarks,mailingcodes,cast(creationdate as date) as creationdate,cast(alterdate as date) as alterdate,cast(datelastgift as date) as datelastgift,"+;
	"address,city,postalcode,country,attention,propextr"+;
	" from person p left join member m on (m.persid=p.persid) where p.persid="+id2,oConn}

	if oPers1:RecCount<1 .or. oPers2:RecCount<1
		return false
	endif
	if !Empty( oPers1:mbrid) .and. !Empty( oPers2:mbrid)
		(ErrorBox{,"Not possible to unify two members"}):Show()
		return false
	endif
	oSel:=SQLSelect{"SELECT TABLE_NAME FROM information_schema.TABLES "+;
		"WHERE TABLE_SCHEMA = '"+dbname+"' and TABLE_NAME like 'tr%' order by TABLE_NAME",oConn}
	aTrTable:=oSel:GetLookupTable(50, #table_name, #table_name) 
	for i:=1 to Len(aTrTable)
		oStmt:SQLString:="update "+aTrTable[i,1]+" set persid='"+id1+"' where persid="+id2
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
			exit
		elseif oSel:NumSuccessfulRows>0 
			nTrans+=oSel:NumSuccessfulRows
		endif
	next
	if Empty(cError)
		oStmt:SQLString:='update personbank set persid="'+id1+'" where persid="'+id2+'"'
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
		endif
	endif
	if Empty(cError)
		// givers/creditors within standing order:
		oStmt:SQLString:='UPDATE standingorder SET persid="'+id1+'" where persid="'+id2+'"'
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
		endif
	endif
	if Empty(cError)
		oStmt:SQLString:='UPDATE standingorderline SET creditor="'+id1+'" where creditor="'+id2+'"'
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
		endif
	endif
	if Empty(cError)
		oStmt:SQLString:='update subscription set personid="'+id1+'" where personid="'+id2+'"'
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
		endif
	endif
	if Empty(cError)
		// creditor within bankorders:
		oStmt:SQLString:='UPDATE bankorder SET idfrom="'+id1+'" where idfrom="'+id2+'"'
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
		endif
	endif

	if Empty(cError)
		cStatement:=""
		if (oPers1:gender==1.or.oPers1:gender==0) .and.oPers2:gender==2 .or.(oPers1:gender==2.or.oPers1:gender==0) .and.oPers2:gender==1 .or.oPers2:gender==3
			cStatement+=",gender=3" //couple
			if oPers1:gender==2
				if !Empty(oPers1:firstname) .and.!Empty(oPers2:firstname)
					cStatement+=",firstname='"+AddSlashes(oPers1:firstname)+"&"+AddSlashes(oPers2:firstname)+"'"
				endif
			elseif !Empty(oPers1:firstname) .and.!Empty(oPers2:firstname) .and.AllTrim(oPers1:firstname)<>AllTrim(oPers2:firstname)
				cStatement+=",firstname='"+AddSlashes(oPers1:firstname)+"&"+AddSlashes(oPers2:firstname)+"'" 
			elseif Empty(oPers1:firstname)
				cStatement+=",firstname='"+AddSlashes(oPers2:firstname)+"'"
			endif
		else
			if Empty(oPers1:firstname)
				cStatement+=",firstname='"+AddSlashes(oPers2:firstname)+"'"
			endif
		endif
		if Empty(oPers1:initials)
			cStatement+=",initials='"+oPers2:initials+"'"
		endif
		if Empty( oPers1:Title)
			cStatement+=",title="+Str(oPers2:Title,-1)
		endif
		if Empty( oPers1:telbusiness)
			cStatement+=",telbusiness='"+ oPers2:telbusiness+"'"            
		endif
		if Empty( oPers1:telhome)
			cStatement+=",telhome='"+ oPers2:telhome+"'"
		endif
		if Empty( oPers1:MOBILE)
			cStatement+=",mobile='"+ oPers2:MOBILE+"'"
		endif
		if Empty( oPers1:FAX)
			cStatement+=",fax='"+ oPers2:FAX+"'"
		endif
		if Empty( oPers1:EMAIL)
			cStatement+=",email='"+ AddSlashes(oPers2:EMAIL)+"'"
		endif
		if Empty( oPers1:birthdate)
			cStatement+=",birthdate='"+ SQLdate(iif(Empty(oPers2:birthdate),null_date,oPers2:birthdate))+"'"
		endif
		if !Empty(oPers2:remarks)
			cStatement+=",remarks=concat(remarks,' ','"+AddSlashes(oPers2:remarks)+"')"
		endif
		cStatement+=",mailingcodes='"+AddSlashes(MakeCod(Split(oPers1:mailingcodes+" "+oPers2:mailingcodes)))+"'"
		if Empty(oPers1:creationdate) .or.(!Empty(oPers2:creationdate) .and.oPers1:creationdate>oPers2:creationdate)
			cStatement+=",creationdate='"+SQLdate(iif(Empty(oPers2:creationdate),null_date,oPers2:creationdate))+"'"
		endif
		if !Empty(oPers2:alterdate) .and.(Empty(oPers1:alterdate) .or.oPers1:alterdate< oPers2:alterdate)
			cStatement+=",alterdate='"+SQLdate(iif(Empty(oPers2:alterdate),null_date,oPers2:alterdate))+"'"
		endif
		if !Empty(oPers2:datelastgift) .and. (Empty(oPers1:datelastgift) .or.oPers1:datelastgift< oPers2:datelastgift)
			cStatement+=",datelastgift='"+SQLdate(iif(Empty(oPers2:datelastgift),null_date,oPers2:datelastgift))+"'"
		endif
		if Empty(oPers1:address) .and. Empty(oPers1:city)
			cStatement+=",address='"+AddSlashes(oPers2:address) +"'"
			cStatement+=",postalcode='"+oPers2:postalcode+"'"
			cStatement+=",city='"+AddSlashes(oPers2:city)  +"'"
			cStatement+=",country='"+ AddSlashes(oPers2:country)+"'" 
			cStatement+=",attention='"+AddSlashes(oPers2:attention) +"'"
		endif
		// extra properties:
		oXMLDocPrs2:=XMLDocument{oPers2:PROPEXTR}
		oXMLDocPrs1:=XMLDocument{oPers1:PROPEXTR} 
		if oXMLDocPrs2:GetElement("velden")
			recordfound:=oXMLDocPrs2:GetFirstChild()
			do while recordfound
				ChildName:=oXMLDocPrs2:ChildName
				cValue:=oXMLDocPrs2:ChildContent
				if oXMLDocPrs1:GetElement(ChildName)
					if Empty(oXMLDocPrs1:GetContentCurrentElement())
						oXMLDocPrs1:UpdateContentCurrentElement(cValue)
					endif
				else
					oXMLDocPrs1:AddElement(ChildName,cValue,"velden")
				endif
				recordfound:=oXMLDocPrs2:GetNextChild()			
			ENDDO
			cStatement+=",propextr='"+ AddSlashes(oXMLDocPrs1:GetBuffer()) +"'"
		endif
		if !Empty(oPers2:mbrid)
			// connect member to Id1:
			cStatement+=",type="+Str(oPers2:type,-1)
		endif
		oStmt:=SQLStatement{"update person set "+SubStr(cStatement,2)+" where persid='"+id1+"'",oConn}
		oStmt:Execute()
		if !Empty(oStmt:status)
			cError:=oStmt:ErrInfo:ErrorMessage
			LogEvent(,"could not merge persons:"+oStmt:ErrInfo:ErrorMessage+CRLF+oStmt:SQLString,"logerrors") 
		endif
		if Empty(cError)
			if !Empty(oPers2:mbrid) 
				oStmt:=SQLStatement{"update member set persid="+id1+" where persid="+id2,oConn}:Execute()
				if oStmt:NumSuccessfulRows>0
					if !Empty(oPers2:accid) 
						oStmt:=SQLStatement{"update account set description='"+GetFullName(id1)+" where accid="+Str(oPers2:accid,-1),oConn}:Execute()
					elseif !Empty(oPers2:depid)
						oStmt:=SQLStatement{"update department set description='"+GetFullName(id1)+" where depid="+Str(oPers2:depid,-1),oConn}:Execute()
					endif	
				endif
			endif 
			
			// update employee if applicable
			SQLStatement{"update employee set persid='"+Crypt_Emp(true,"persid",id1)+"' where persid='"+Crypt_Emp(true,"persid",id2)+"'",oConn}:Execute()
			// delete person id2:
			SQLStatement{"delete from person where persid="+id2,oConn}:Execute() 
			SQLStatement{"commit",oConn}:Execute()
		endif
	endif
	if !Empty(cError)
		SQLStatement{"rollback",oConn}:Execute() 
		ErrorBox{,"could not merge persons: "+cError}:Show()
		return false
	endif
   TextBox{,"Person merge","Person merged"}:Show()
	return true
Function PersTypeValue(abrv as string) as string
// get id of person type with abbriviation abrv
local iPtr as int
iPtr:=AScan(pers_types_abrv,{|x|x[1]=abrv})
if iPtr>0
	return Str(pers_types_abrv[iPtr,2],-1)
else
	return "1"
endif
CLASS ProgressPer INHERIT DIALOGWINDOW 

	PROTECT oDCProgressBar AS PROGRESSBAR

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
   PROTECT oServer as OBJECT
RESOURCE ProgressPer DIALOGEX  5, 17, 263, 34
STYLE	DS_3DLOOK|WS_POPUP|WS_CAPTION|WS_SYSMENU
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	" ", PROGRESSPER_PROGRESSBAR, "msctls_progress32", PBS_SMOOTH|WS_CHILD, 44, 11, 190, 12
END

METHOD AdvancePro(iAdv) CLASS ProgressPer
	ApplicationExec( EXECWHILEEVENT ) 	// This is add to allow closing of the dialogwindow
										// while processing.
	 self:oDCProgressBar:Advance(iAdv)
	RETURN true
METHOD Close(oEvent) CLASS ProgressPer
	SUPER:Close(oEvent)
	//Put your changes here
	RETURN nil
METHOD Init(oParent,uExtra) CLASS ProgressPer 
LOCAL DIM aBrushes[1] AS OBJECT

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"ProgressPer",_GetInst()},FALSE)

aBrushes[1] := Brush{Color{COLORWHITE}}

oDCProgressBar := ProgressBar{SELF,ResourceID{PROGRESSPER_PROGRESSBAR,_GetInst()}}
oDCProgressBar:Range := Range{1,}
oDCProgressBar:HyperLabel := HyperLabel{#ProgressBar,NULL_STRING,NULL_STRING,NULL_STRING}
oDCProgressBar:BackgroundColor := Color{COLORWHITE}

SELF:Caption := ""
SELF:BackGround := aBrushes[1]
SELF:HyperLabel := HyperLabel{#ProgressPer,NULL_STRING,NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD PostInit(oParent,uExtra) CLASS ProgressPer
	//Put your PostInit additions here
	oServer:=uExtra
	RETURN nil
METHOD SetRange(nMin,nMax) CLASS ProgressPer
self:oDCProgressBar:Range:=Range{nMin,nMax}
RETURN true
METHOD SetUnit(nUnit) CLASS ProgressPer
self:oDCProgressBar:UnitSize:=1
RETURN true
STATIC DEFINE PROGRESSPER_PROGRESSBAR := 100 
function Salutation(GENDER as int) as string
	// Return salutation corresponding with the given Gender of person:	
	return pers_salut[iif(Empty(GENDER),5,GENDER),1]

function SaveUse(functionid:=null_object as usual)
// save use of a function into statistical data 
local oStmnt as SQLStatement
oStmnt:=SQLStatement{"insert into functionusage (functionid,userid,usedate,frequency) values ('"+iif(IsObject(functionid),Symbol2String(ClassName(functionid)),iif(IsString(functionid),functionid,""))+"','"+ LOGON_EMP_ID + "',current_date,1)"+;
" on duplicate key update frequency=frequency+1",oConn}
oStmnt:Execute()
return
function SetAccFilter(WhatFrom as int) as string 
	// compose filter for balance items branch from given WhatFrom balitemid 
	LOCAL i,j			as int
	local a_bal:={},aBalIncl:={} as array
	local oBal as SQLSelect
	
	IF !Empty(WhatFrom)
		oBal:=SQLSelect{"select balitemid,balitemidparent from balanceitem order by balitemidparent,balitemid",oConn}
		if oBal:RecCount>0
			aBalIncl:={WhatFrom} 
			a_bal:=oBal:getlookuptable(1000) 
			do WHILE (i:=AddSubBal(a_bal,WhatFrom,i,@aBalIncl))>0
			ENDDO 
		endif
	endif
	return Implode(aBalIncl,",")
Function SetCollate() 
	if CountryCode='41'
		Collate:=" COLLATE utf8_danish_ci"
	elseif CountryCode='46'
		Collate:=" COLLATE utf8_swedish_ci" 
	else
		Collate:=''
	endif
	return
	if IsOldSpace(Collate)
		OldSpaceFree(Collate)
	endif
	Collate:=DynToOldSpaceString(Collate)  // to avoid that they are moved around in dynamic memory and reduce use of dymamic memory   
	return
function SetDepFilter(WhoFrom as int) as string 
	// compose filter for department branch from given WhoFrom depid 
	LOCAL i,j			as int
	local d_dep:={},aDepIncl:={} as array
	local oDep as SQLSelect
	
	IF !Empty(WhoFrom)
		oDep:=SQLSelect{"select depid,parentdep from department order by parentdep,depid",oConn}
		if oDep:RecCount>0
			aDepIncl:={WhoFrom} 
			d_dep:=oDep:getlookuptable(1000) 
			do WHILE (i:=AddSubDep(d_dep,WhoFrom,i,@aDepIncl))>0
			ENDDO 
		endif
	endif
	return Implode(aDepIncl,",")
FUNCTION ShowError( oSQLErrorInfo as USUAL)    as void PASCAL

	LOCAL cMsg as STRING

    IF oSQLErrorInfo != nil

  	  IF IsInstanceOf( oSQLErrorInfo, #SQLErrorInfo )
	     MessageBox( 0, oSQLErrorInfo:ErrorMessage,	       ;
		 	  	  oSQLErrorInfo:SQLState, MB_ICONINFORMATION)
	  ELSE
		cMsg := "Subsys: " + AsString(oSQLErrorInfo:Subsystem) +  CRLF
        cMsg += "MethodSelf: " + AsString(oSQLErrorInfo:MethodSelf) + CRLF
        cMsg += "FuncSym: " + AsString(oSQLErrorInfo:FuncSym) + CRLF
		cMsg += "CallFuncSym: " + AsString(oSQLErrorInfo:CallFuncSym) + CRLF
		MessageBox( 0, String2Psz(cMsg), String2Psz(oSQLErrorInfo:Description), MB_ICONINFORMATION)
	  ENDIF
    ENDIF

RETURN
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
FUNCTION Split(cTarget:="" as string,cSep:=' ' as string,lCompress:=false as logic,lIgnoreQuote:=false as logic) as array
	* Split string cTarget into array, seperated by cSep 
	* Optionally the result is compressed 
	* lIgnoreQuote: you can optionally ignore quotes around fields, eg. when seperator is: #$#
	LOCAL nIncr as int
	LOCAL aToken:={} as ARRAY
	LOCAL cSearch,cQuote as STRING
	LOCAL nStart, nPos, nEnd as int
	if !Empty(cTarget)
		nEnd:=Len(cTarget)
		nStart:=0
		cSearch:=cSep
		DO WHILE nStart<=nEnd
			IF !lIgnoreQuote .and.SubStr(cTarget,nStart+1,1)=='"'
				cQuote:='"'
				cSearch:=cQuote+cSep
				nStart++
			else
				cQuote:=''
				cSearch:=cSep
			endif
			nIncr:=Len(cSearch)
			nIncr:=iif(nIncr>0,nIncr-1,0)
			IF (nPos:=At3(cSearch, cTarget,nStart))==0
				if Empty(cQuote)
					nPos:=nEnd +1 
				else
					nPos:=nEnd 
				endif
			ENDIF
			if lCompress
				AAdd(aToken,Compress(StrTran(SubStr(cTarget,nStart+1,nPos-nStart-1),CHR(160),Space(1))))      // replace non-breaking space by space
			else
				AAdd(aToken,SubStr(cTarget,nStart+1,nPos-nStart-1))
			endif
			nStart:=nPos+nIncr
		ENDDO
	endif
	RETURN aToken
function SQLAccType() as string
// compose sql code for determining account type: of account a, member m:
// A=subscription
// F=invoice
// C=bankorder
// M=member
// G=project
// D=donation
// K=member department
	return ;
		"upper(if(a.subscriptionprice>0,'A',"+;                          // subscribtion
			"if(a.accid='"+SDEB+"','F',"+;              //invoice
				"if(a.accid='"+scre+"','C',"+;           // bankorder
					"if(a.giftalwd=1 and m.depid IS NULL,"+;
						"if(m.co IS NOT NULL and m.co<>'','M','G')"+;        // member, else project
					","+; // else
						"if(a.accid='"+SDON+"','D'"+;  // donation, 
						","+;		//else 
							"if(m.depid=a.department,if(d.incomeacc=a.accid,'M',if(d.expenseacc=a.accid or d.netasset=a.accid,'K','')),'')"+;  // income account: member, else member department
						")"+;
					")"+;
				")"+;
			")"+;
		"))"

Function SQLAddress(country:="" as string,alias:="" as string,cSep:=',' as string) as string 
// composition of SQL code for getting address of a person
// -	country: default country (optional) 
// -	alias  : table alias used for table person: e.g. " p."  (optional)
// -	cSep	 :	separator text between address lines; e.g. for html: "<br>"
//				
// Global variable sSTRZIPCITY, specified in system params:
//				0: address, zip, city, country  
//				1: postalcode,city, address, country 
//				2: country, postalcode city, address,  (Russia)
//				3: address, city, zip, country    (USA, Canada)
// Global CITYUPC: true: City name in uppercase, false: only first character uppercase
// 
LOCAL fRow:="" as string 
local mAlias:=iif(Empty(ALIAS),"",alias+".") as string
local cAddress:="if("+mAlias+'address<>"" and ' +mAlias+'address<>"X",'+mAlias+'address,"")' as string
local cZip:='if(' +mAlias+'postalcode<>"" and ' +mAlias+'postalcode<>"X",'+mAlias+'postalcode,"")'  as string
local cCity:='if(' +mAlias+'city<>"" and ' +mAlias+'city<>"X" and ' +mAlias+'city<>"??",'+if(CITYUPC,'upper(','')+mAlias+'city'+if(CITYUPC,')','')+',"")' as string
local ccountry:='if('+mAlias+'country<>""'+iif(Empty(OwnCountryNames),'',' and not '+mAlias+'country in('+Implode(OwnCountryNames,'","')+')')+','+mAlias+'country,'+iif(Empty(country),'""','"'+country+'"')+')' as string
local cUSA:='if('+mAlias+'country="USA" or '+mAlias+'country="UNITED STATES" or '+mAlias+'country="CANADA" or '+mAlias+'country="U.S.A.",'
local cCityZip as string
local mySep:=',"'+cSep+' ",' as string


cCityZip:=iif(sSTRZIPCITY==3,'concat('+cCity+'," ",'+cZip+')',cUSA+'concat('+cCity+'," ",'+cZip+'),concat('+cZip+'," ",'+cCity+'))')  
if sSTRZIPCITY==0.or. sSTRZIPCITY==3
	fRow:=cAddress+mySep+cCityZip+",if("+ccountry+'<>"",concat("'+cSep+' ",' +ccountry+'),"")'
elseif sSTRZIPCITY==1
	fRow:=cCityZip+mySep+cAddress+",if("+ccountry+'<>"",concat("'+cSep+' ",' +ccountry+'),"")'
elseif sSTRZIPCITY==2
	fRow:=cCountry+mySep+cUSA+'concat('+cAddress+mySep+cCity+'," ",'+cZip+'),concat('+cZip+'," ",'+cCity+mySep+cAddress+'))'
endif	

RETURN 'concat('+fRow+')'
function SQLdate(dat as date) as string
// convert date to sql string format:
local Rdat:=DToS(dat) as string 
if Empty(dat)
	return '0000-00-00'
endif
return substr(Rdat,1,4)+"-"+substr(Rdat,5,2)+"-"+substr(Rdat,7,2)
function SQLDate2Date(sqldat as string) as date
// convert mysql date to VO-date
return SToD(StrTran(sqldat,"-",""))
Function SQLFullNAC(Purpose:=1 as int,country:="" as string,alias:="" as string) as string 
// composition of SQL code for getting full name and address of a person
// Purpose: see SQLFullName
// country: default country (optional)
LOCAL f_row as STRING

f_row:=SQLFullName(Purpose,ALIAS)

f_row:=SubStr(f_row,1,Len(f_row)-2)+',", ",'+;   // eliminate ) for trim and concat
SQLAddress(country,ALIAS)+"))"  // add  )) for trim and concat
RETURN AllTrim(f_row)
Function SQLFullName(Purpose:=0 as int,aliasp:="" as string) as string 
// composition of SQL code for getting full name of a person
// Purpose: optional indicator that the name is used for:
// 	0: addresslist: with surname "," firstname prefix (without salutation) 
//		1: fullname conform address specification
//		2: name for identification: lastname, firstname prefix 
//		3: like 1 but always with firstname 
// Global LSTNUPC: true: last name in uppercase, false: only first character uppercase 
//
LOCAL frstnm,fullname, title,prefix,mAlias as STRING 
local i as int
mAlias:=ConS(aliasp) 
if !Empty(mAlias)
	mAlias:=mAlias+"."
endif

IF sSalutation .and.(Purpose==1.or.Purpose==3) 
	title:="case "
	for i:=1 to 3
		 title+=" when "+mAlias+"gender="+Str(pers_salut[i,2],-1)+" then '"+pers_salut[i,1]+"'" 
	next
	title+="ELSE '' END"
ENDIF
IF titelINADR.and.!Empty(pers_titles) .and.(Purpose==1.or.Purpose==3)
	if !Empty(Title) 
		title := "concat(("+title+"),"
	endif	
	title+="(case"
	for i:=1 to Len(pers_titles)
		title+=" when "+mAlias+"title="+Str(pers_titles[i,2],-1)+" then '"+pers_titles[i,1]+"'" 
	next
	title+=" END)"+iif(sSalutation .and.(Purpose==1.or.Purpose==3),")","")
ENDIF
prefix :="if("+mAlias+'prefix<>"",concat('+mAlias+'prefix," "),"")'
fullname :=iif(LSTNUPC,'upper(','')+ mAlias+"lastname"+iif(LSTNUPC,')','')
IF sFirstNmInAdr .or. (Purpose==2.or.Purpose==3)
	frstnm := 'if('+mAlias+'firstname<>"",concat('+iif(Purpose==2.or.Purpose=0,iif(sSurnameFirst,'" "','", "')+',','')+mAlias+'firstname," "),if('+mAlias+'initials<>"",concat('+iif(Purpose==2.or.Purpose=0,'", ",','')+mAlias+'initials," "),""))'+iif(Purpose==0.or.Purpose=2,",if("+mAlias+'prefix<>"",",","")',"")
ELSE
	frstnm := 'if('+mAlias+'initials<>"",concat('+iif(Purpose==0.or.Purpose=2,'", ",','')+mAlias+'initials," ")'+iif(Purpose==0.or.Purpose=2,",if("+mAlias+'prefix<>"",",",""))',"")
ENDIF
do CASE
CASE Purpose==0
	//addresslist:
	fullname:='concat('+fullname+','+frstnm+','+prefix+')'
CASE Purpose==1.or.Purpose==3
	// address conform address specifications:
	IF sSurnameFirst
   	fullname := 'concat('+fullname+'," ",'+iif(!Empty(Title),title+'," ",',"")+frstnm+',' + prefix +')'
	else
// 		fullname:='concat('+title+'," ",'+frstnm+','+prefix+','+fullname+')'
		fullname:='concat('+iif(!Empty(title),title+'," ",',"")+frstnm+','+prefix+','+fullname+')'
	ENDIF	
CASE Purpose==2
	// identification:
// 	fullname:='trim(concat('+fullname+','+iif(sSurnameFirst,'" "','", "')+','+frstnm+','+prefix+'))'
	fullname:='concat('+fullname+','+frstnm+','+prefix+')'
endcase
return 'trim('+fullname +')'  
function SQLIncExpFd() as string
// compose sql code for determining type of account of member department: of department d, account a:
	return "upper(if(d.netasset=a.accid,'F',if(d.incomeacc=a.accid,'I',if(d.expenseacc=a.accid,'E',''))))"
	
Class SQLSelectPagination inherit SQLSelect
	// sqlselect with pagination for browsing through data in a datawindow
	protect pRecno as dword
	protect nOffset as dword
	protect nLastRec as dword
	protect nPageLen:=100 as dword   // length of a page fetched in one go from the database
	protect cStatement as string // contains sqlstatement without limits
	protect lpBof,lpEof as logic
	access BoF class SQLSelectPagination
	return self:lpBof
	access Eof class SQLSelectPagination
	return self:lpEof
	  
method Execute() class SQLSelectPagination
self:SqlString:=self:cStatement
return true	
Method GoBottom() class SQLSelectPagination 
	self:ReadNextBuffer(self:nLastRec)
// 	LogEvent(self,"gobottom")
	return true
Method GoTo(nRecordNumber) class SQLSelectPagination 
	local lRes:=true as logic
	if nRecordNumber<=0 
		self:lpBof:=true
		self:pRecno:=1
	elseif nRecordNumber>self:nLastRec
		self:lpEof:=true
		self:pRecno:=self:nLastRec
	else
		self:lpBof:=false
		self:lpEof:=false
		if nRecordNumber>self:nOffset 
         lRes:=self:ReadNextBuffer(nRecordNumber)
		elseif nRecordNumber<= self:nOffset
         lRes:=self:ReadNextBuffer(nRecordNumber)
		endif
		self:pRecno:=nRecordNumber 
	endif
// 	LogEvent(self,"goto ("+Str(nRecordNumber,-1)+") : id="+ConS(self:FIELDGET(1))+", offset="+Str(self:nOffset,-1)+", precno="+Str(self:pRecno,-1)+",nLastrec="+Str(self:nLastRec,-1),"loginfo")
	return lRes
Method GoTop() class SQLSelectPagination
// 	LogEvent(self,"gotop")
return self:ReadNextBuffer(1)

method Init(cStatement, oSQLConnection) class SQLSelectPagination
	super:Init(, oSQLConnection)
	self:SqlString:=cStatement
	return self
ACCESS PageLength CLASS SQLSelectPagination
	RETURN self:nPageLen
ASSIGN PageLength(uValue) CLASS SQLSelectPagination
self:nPageLen:=uValue
	RETURN uValue

Method ReadNextBuffer(nRecordNumber) class SQLSelectPagination
	// check if next buffer should be read:
	local lRes:=true as logic
// 	local time0,time1 as float
	if nRecordNumber<=0 
		self:lpBof:=true
		self:pRecno:=1
	elseif nRecordNumber>self:nLastRec
		self:lpEof:=true
		self:pRecno:=self:nLastRec
	else
		if nRecordNumber>self:nOffset+self:nPageLen .or.nRecordNumber<= self:nOffset
			// read corresponding page:
			if nRecordNumber<= self:nOffset
				self:nOffset:=Floor((nRecordNumber-1)/self:nPageLen)*self:nPageLen
			else	 
				self:nOffset:=Min(Floor(nRecordNumber/self:nPageLen)*self:nPageLen,self:nLastRec)
			endif
			self:aClients[1]:Pointer := Pointer{POINTERHOURGLASS}
// 			time0:=Seconds() 
			super:SqlString:=self:cStatement+" limit "+str(self:nOffset,-1)+","+str(self:nPageLen,-1)
			super:Execute()
// 			time1:=time0
// 			LogEvent(self,"read buffer ("+Str(nRecordNumber,-1)+") :"+Str((time0:=Seconds())-time1,-1),"loginfo")
			self:aClients[1]:Pointer := Pointer{POINTERARROW}
		endif
		self:pRecno:=nRecordNumber 
		lRes:=super:GoTo(nRecordNumber-self:nOffset)
		self:lpBof:=false
		self:lpEof:=false
	endif
// 	LogEvent(self,"ReadNextBuffer ("+Str(nRecordNumber,-1)+") : id="+ConS(self:FIELDGET(1))+", offset="+Str(self:nOffset,-1)+", precno="+Str(self:pRecno,-1)+",nLastrec="+Str(self:nLastRec,-1),"loginfo")
	return lRes
		

	ACCESS RecCount class SQLSelectPagination
	return self:nLastRec 
ACCESS RecNo CLASS SQLSelectPagination
	return self:pRecno
ASSIGN RECNO(uValue) CLASS SQLSelectPagination
	RETURN self:GoTo(uValue)
Method Skip(nLines) class SQLSelectPagination
	local lRes as logic
	Default(@nLines,1) 
	return self:ReadNextBuffer(self:pRecno+nLines) 

ACCESS SqlString CLASS SQLSelectPagination
	RETURN self:cStatement
ASSIGN SqlString(uValue) CLASS SQLSelectPagination
	Local nOrder as int
	local cCount as string
	local oSel as SqlSelect
	self:cStatement:=uValue
	self:nOffset:=0
	self:lpEof:=false
	self:lpBof:=false
	if !Empty(uValue) .and. IsString(uValue)  
		// determine max rec:
		cCount:= "select count(*) as nlastrec"+Lower(SubStr(uValue,AtC(' from ',uValue))) 
		nOrder:=RAt(" order ",cCount)
		if nOrder>1
			cCount:=SubStr(cCount,1,nOrder-1)
		endif
		oSel:=SqlSelect{cCount,self:Connection}
		oSel:Execute()
		if oSel:RecCount>0 
			self:nLastRec:=ConI(oSel:nLastRec)
		endif
		super:SqlString:=uValue+" limit 0,"+Str(self:nPageLen,-1)
		super:Execute()
		self:pRecno:=1
	endif
	RETURN uValue
Function StandardZip(ZipCode:="" as string) as string 
	* Standardise Ducth Zip-code format: 9999 XX 
	local myZipCode:=ZipCode as string
	if Empty(myZipCode) 
		return null_string
	endif
	myZipCode:=Upper(AllTrim(myZipCode))
	IF Len(myZipCode)==6
		IF isnum(SubStr(myZipCode,1,4)) .and. !isnum(SubStr(myZipCode,5,2)) .and. !IsPunctuationMark(SubStr(myZipCode,5,2))
			RETURN SubStr(myZipCode,1,4)+" "+SubStr(myZipCode,5,2)
		ENDIF
	elseif Len(myZipCode)==5
		IF countrycode='46' .and. isnum(myZipCode)  
			RETURN SubStr(myZipCode,1,3)+" "+SubStr(myZipCode,4,2)
		ENDIF
	ENDIF
RETURN myZipCode
DEFINE TEXTBX:=0
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
Function ValidateAccTransfer (cParentId as string,mAccId as string) as string 
	* Check if transfer of current account mAccId to another balance item with identifciation cParentid is allowed
	* Returns Error text if not allowed

	LOCAL oRB as SQLSelect
	LOCAL cNewClass, cError  as STRING
	LOCAL lValid:=true,lSucc as LOGIC
	LOCAL oAcc as SQLSelect, oMbr as SQLSelect  
	local oAccB as SQLSelect
	local oLan as Language 
	IF Empty(cParentId)
		oLan:=Language{}
		RETURN oLan:WGet("Root not allowed as parent of an account")
	ENDIF	

	* Member account .or. transactions for this account:
	* No change of balancegroupclassification allowed
	oRB:=SQLSelect{"select category from balanceitem where balitemid='"+cParentId+"'",oConn} 
	if oRB:RecCount=1	
		cNewClass:= oRB:category 
		oAcc:=SQLSelect{"select accnumber,b.balitemid,co,homepp,b.category from balanceitem as b, account as a left join member as m on (a.accid=m.accid) where a.accid='"+mAccId+"' and b.balitemid=a.balitemid",oConn}
		if oAcc:RecCount=1	
			IF	!oAcc:category== cNewClass
				IF	!(cNewClass	$ expense+income	.and.	oAcc:category $ expense+income .or. cNewClass $ asset+liability .and. oAcc:category $ asset+liability)
					oAccB:=SQLSelect{"select accid from accountbalanceyear where accid='"+mAccId+"' and (svjc-svjd)<>0.00",oConn}
					IF oAccB:RecCount>0
						if oLan==null_object 
							oLan:=Language{}
						endif
						cError:=oLan:WGet("Balancegroup of account")+" "+AllTrim(oAcc:ACCNUMBER)+" "+oLan:WGet('cannot be changed to different category after year closing')
						lValid:=FALSE
					ENDIF 
				ENDIF
			ENDIF
			IF	lValid .and.!Empty(oAcc:CO)	//	Member?
				cError:=ValidateMemberType( oAcc:CO,oAcc:HOMEPP,cNewClass)
				IF	!Empty(cError)
					lValid:=FALSE 
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	// ENDIF
	RETURN cError
Function ValidateDepTransfer (cDepartment as string,mAccId as string,mGIFTALWD:=2 as int,lActive ref logic) as string 
	* Check if transfer of current account mAccId to another department with identification cDepartment is allowed
	* Returns Error text if not allowed

	LOCAL cError  as STRING
	LOCAL oAcc,oSel as SQLSelect  
	local oLan as Language 

	oAcc:=SqlSelect{"select d.deptmntnbr,d.depid,d.descriptn,d.netasset,d.incomeacc,d.expenseacc from department d where d.incomeacc="+mAccId+" or d.expenseacc="+mAccId+" or d.netasset="+mAccId,oConn}
	if oAcc:Reccount>0 .and. Str(oAcc:depid,-1)<>cDepartment
		oLan:=Language{}
		cError:=oLan:WGet("Account is assigned to department")+': '+oAcc:deptmntnbr+' '+oAcc:descriptn+' '+oLan:WGet("as")+' '+iif(AllTrim(Transform(oAcc:netasset,""))==mAccId,;
			oLan:WGet("netasset account"),iif(AllTrim(Transform(oAcc:incomeacc,""))==mAccId,oLan:WGet("income account"),oLan:WGet("expense account"))) 
	endif
	if Empty(cError)
		// check if account belongs to single-account member:
		if (oSel:=SqlSelect{"select m.`mbrid` from member m where m.accid="+mAccId,oConn}):Reccount>0
			if (oAcc:=SqlSelect{"select mbrid from member where depid="+cDepartment,oConn}):Reccount>0
				// not allowed change of member:
				oLan:=Language{}
				cError:=oLan:WGet("account can not be assigned to another member")
			endif 
		endif
	endif
	if Empty(cError) .and. !Empty(Val(cDepartment))
		// check if only Income account is Gifts receivable:  
		oAcc:=SqlSelect{"SELECT `accid` FROM `member` WHERE `accid` is null and `depid`=" +cDepartment,oConn} 
		if oAcc:Reccount >0 
			
			if mGIFTALWD==2 
				oAcc:=SqlSelect{"select giftalwd from account where accid="+mAccId,oConn}
				if oAcc:Reccount>0 
					mGIFTALWD:= ConI(oAcc:giftalwd)
				endif
			endif
			if mGIFTALWD=1
				oSel:=SqlSelect{"SELECT `incomeacc`,descriptn FROM `department` WHERE `depid`=" +cDepartment,oConn}
				if oSel:Reccount>0 
					IF !ConS(oSel:incomeacc) == mAccId 
						oLan:=Language{}
						cError:=oLan:WGet("Only 1 account gift receivable allowed for deparment")+': '+oSel:descriptn
					endif 
				endif
			endif
		endif
	endif
   // check if department is not active:
	if Empty(cError) .and. !Empty(Val(cDepartment))
	   if lActive
	   	oSel:=SqlSelect{"select active from department where depid='"+cDepartment+"'",oConn}
	   	if oSel:Reccount>0
	   		if !ConL(oSel:active)
	   			lActive:=false
	   		endif
	   	endif
	   endif	
   endif
	return cError
function ValidateMemberType(CO as string,HomePP as string, Type as string ) as string
	// check if member has account with correct type
	// returns errormesage if not correct
	local cError as string
	if CO=="M"  // member
		IF HomePP # Sentity .and. Type #"PA"
			cError := "Type of corresponding account of this not own member should be liability/fund"
		elseif Type #"PA" .and.Type #"BA"
			cError := "Type of corresponding account of this (non project)member should be liability/fund or income"
		endif
	else    // PP
		if !HomePP == Sentity .and.(Type #"PA" .and.Type #"AK") 
			cError := "Type of corresponding account of this not own entity should be liability/fund or asset"
		elseif HomePP = Sentity 
			// everything allowed
		endif
	endif
return cError
Method Reset() class Window 
	Local aChilds as array, i as int, cName as symbol , oContr as Control, cCaption as string
	aChilds:=self:GetAllChildren() 
	for i:=1 to Len(aChilds)
		cName:=ClassName(aChilds[i])
		if cName==#SINGLELINEEDIT .or. cName==#COMBOBOX .or. cName==#MULTILINEEDIT .or. cName==#LISTBOX
			oContr:=aChilds[i] 
			oContr:TextValue:=null_string
		endif
	next
	return
Method SetTexts() class Window 
	Local aChilds as array, i as int, cName as symbol , oContr as Control, cCaption as string,oColumn as DataColumn
	local oWLan as Language
	if self:oLan==null_object
		self:oLan:=Language{}
	endif 
	oWLan:=self:oLan
	aChilds:=self:GetAllChildren() 
	for i:=1 to Len(aChilds)
		cName:=ClassName(aChilds[i]) 
		if cName==#FIXEDTEXT .or. cName==#PUSHBUTTON .or. cName==#GROUPBOX  .or. cName=#RADIOBUTTON .or. cName=#RADIOBUTTONGROUP.or. cName=#CHECKBOX 
			oContr:=aChilds[i] 
			cCaption:=oContr:Caption
			if Len(cCaption)>1
				if Right(cCaption,1)==":"
					oContr:Caption:=oWLan:WGet(SubStr(cCaption,1,Len(cCaption)-1))+":"
				else
					oContr:Caption:=oWLan:WGet(cCaption)
				endif								
			endif 
		endif
	next
	if IsAccess(self,#browser) .and.!Empty(self:browser)
		for i:=1 to self:browser:ColumnCount
			oColumn:=self:browser:GetColumn(i)
			cCaption:=oColumn:Caption
			if Len(cCaption)>1
				if Right(cCaption,1)==":"
					oColumn:Caption:=oWLan:WGet(SubStr(cCaption,1,Len(cCaption)-1))+":"
				else
					oColumn:Caption:=oWLan:WGet(cCaption)
				endif								
			endif 			
		next
	endif
	self:Caption:=oWLan:WGet(self:Caption)
	return
CLASS WorkDayDate inherit DateStandard
 Method ParentNotify(nNotifyCode, lParam) class WorkDayDate
		if DoW(self:SelectedDate)=1       // not on sunday
			self:SelectedDate++
		elseif DoW(self:SelectedDate)=7   // not on saturday
			self:SelectedDate+=2
		endif
 return 1
 FUNCTION Yield() as LOGIC

	ApplicationExec(EXECWHILEEVENT)
	
RETURN true	




FUNCTION ZeroRTrim(m_str as string) as string
// right trim zeroes from a decimal string
Local commaPos,length as int, DecSep as string 
m_str:=AllTrim(m_str)
DecSep:=CHR(SetDecimalSep())

commaPos:=At(DecSep,m_str)
if commaPos>0
	length:=Len(m_str)
	do WHILE SubStr(m_str,length,1)=="0"
		length-- 
	ENDDO
   m_str:=SubStr(m_str,1,Max(commaPos+1,length))
endif
RETURN m_str
FUNCTION ZeroTrim(m_str as string) as string
// left trim leading zeroes from a string
local nNonZero:=1,i as int 
m_str:=AllTrim(m_str)
for i:=1 to Len(m_str)
	if SubStr(m_str,i,1)=='0'
		nNonZero++
	else
		exit
	endif
next
RETURN SubStr(m_str,nNonZero)
