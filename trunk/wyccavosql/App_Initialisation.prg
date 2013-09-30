STATIC FUNC __RaiseFTPError (oFTP as CFtp) as int PASCAL
LOCAL cError    as STRING
LOCAL nRet      as int

nRet := oFTP:Error
IF nRet > 0
	cError := oFTP:ErrorMsg
	IF SLen(cError) > 0
		MessageBox(0, cError, "FTP Error", MB_OK)
	ENDIF
ENDIF
RETURN nRet
class CheckUPGRADE
	export DBVers, PrgVers as float  
	declare method LoadInstallerUpgrade 
	method Init() class CheckUPGRADE
	local oSys as SqlSelect
	local DBVers, PrgVers as float
	// determine program version as float:
	AEval(AEvalA(Split(Version,"."),{|x|Val(x)}),{|x|PrgVers:=1000*PrgVers+x})
	self:PrgVers:=PrgVers
	// determine database version as float: 
	if SqlSelect{"show tables like 'sysparms'",oConn}:RecCount>0
		oSys:=SqlSelect{"select `version` from sysparms",oConn}
		if oSys:RecCount>0
			AEval(AEvalA(Split(oSys:Version,"."),{|x|Val(x)}),{|x|DBVers:=1000*DBVers+x})
		endif
	endif
	self:DBVers:=DBVers
	return self

Method LoadInstallerUpgrade(startfile ref string,cWorkdir as string) as logic class CheckUPGRADE
	// check if there is a new wosupgradeinstaller.exe
	local i,j as int 
	local cDirname as string 
	local LocalTime,Remotetime as string 
	local LocalDate, RemoteDate as date
	local lSuc as logic 
	local lAMPM as logic
	local aCurvers as array
	Local aInsRem as Array
	local aDir,aSubDir as array 
	Local oFs as FileSpec
 	LOCAL oFTP  as cFtp

	oFTP := CFtp{"WycOffSy FTP Agent"} 
	
	if oFTP:Open()                                                              
// 		lSuc:=oFTP:ConnectRemote('weu-web.dyndns.org','anonymous',"any")
		lSuc:=oFTP:ConnectRemote('ftp.eu.wycliffe.net','anonymous',"any")
	endif
	if !lSuc
		// try again:
		if oFTP:Open()
			lSuc:=oFTP:ConnectRemote('ftp.eu.wycliffe.net','anonymous',"any")
			// 				lSuc:=oFTP:ConnectRemote('eu.wycliffe.net','anonymous',"any")
		endif
	endif
	if lSuc
		// remove old version if still present:
		oFs:=FileSpec{cWorkdir+"WosSQLOld.EXE"}
		if oFs:Find()
			FErase(oFs:FullPath)
			oFs:Find()
		endif
		// check newer tables, etc: 
		aInsRem:=oFTP:Directory("variable/*.*")
		for i:=1 to Len(aInsRem)
			oFs:=FileSpec{cWorkdir+aInsRem[i,F_NAME]}
			if !oFs:Find() .or. (oFs:DateChanged <aInsRem[i,F_DATE] .or.oFs:DateChanged =aInsRem[i,F_DATE] .and.oFs:TimeChanged<aInsRem[i,F_TIME] )  // newer?
				lSuc:=oFTP:GetFile("variable/"+aInsRem[i,F_NAME],cWorkdir+aInsRem[i,F_NAME],false,INTERNET_FLAG_DONT_CACHE + INTERNET_FLAG_RELOAD+ ;
				INTERNET_FLAG_RESYNCHRONIZE+INTERNET_FLAG_NO_CACHE_WRITE )
				if lSuc
					SetFDateTime(cWorkdir+aInsRem[i,F_NAME],aInsRem[i,F_DATE] ,aInsRem[i,F_TIME] ) 
				endif
			endif					 
		next
		lAMPM:=SetAmPm(false) 
		oFs:=FileSpec{cWorkdir+"wosupgradeinstaller.exe"}
		if oFs:Find()
			LocalDate:=oFs:DateChanged
			LocalTime:=oFs:TimeChanged  
		endif
		aInsRem:=oFTP:Directory("wosupgradeinstaller.exe")
		if Len(aInsRem)>0
			RemoteDate:=aInsRem[1,F_DATE]
			Remotetime:=aInsRem[1,F_TIME]
			if LocalDate < RemoteDate .or. (LocalDate = RemoteDate .and. LocalTime<Remotetime )
// 			if LocalDate < RemoteDate .or. (LocalDate = RemoteDate .and. LocalTime<Remotetime .and. self:DBVers>self:PrgVers)
// 			if LocalDate < RemoteDate .or. self:DBVers>self:PrgVers
				// apparently new version:
				LogEvent(self,"Installing new version: local date:"+DToC(LocalDate)+' '+LocalTime+" remote date:"+DToC(RemoteDate)+' '+Remotetime,"loginfo")
				(TextBox{,"New version of Wycliffe Office System available!","It will be installed now"}):Show()  
				// clear cache:
				cDirname:="C:\Users\"+myApp:GetUser()+"\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\*.*" 
				aDir:=Directory(cDirname,FA_DIRECTORY+FC_HIDDEN+FC_SYSTEM+FA_VOLUME)
				for i:=1 to Len(ADir)
					if !Empty(ADir[i,F_NAME]) .and. !ADir[i,F_NAME]='.' 
						cDirname:="C:\Users\"+myApp:GetUser()+"\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\"+ADir[i,F_NAME]+"\wosupgradeinstaller*.exe" 
						aSubDir:=Directory(cDirname,FA_DIRECTORY+FC_HIDDEN+FC_SYSTEM+FA_VOLUME)
						if Len(aSubDir)>0
							for j:=1 to Len(aSubDir)
								if aSubDir[j,F_NAME]="wosupgradeinstaller"									
									cDirname:="C:\Users\"+myApp:GetUser()+"\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\"+ADir[i,F_NAME]+"\"+aSubDir[j,F_NAME]
									lSuc:=FErase(cDirname)
									if File(cDirname) .or. !lSuc
										FileSpec{cDirname}:DELETE()
									endif
								endif
							next
						endif
					endif
				next         

// 				if File("C:\Users\"+myApp:GetUser()+"\AppData\Local\Microsoft\windows\Temporary Internet Files\wosupgradeinstaller.exe") 
// 					FErase("C:\Users\"+myApp:GetUser()+"\AppData\Local\Microsoft|windows\Temporary Internet Files\wosupgradeinstaller.exe")
// 				endif
				// load first latest version of install program: 
// 				FileSpec{oFs:FullPath}:Rename("wosupgradeinstallerold.exe")
				IF !oFTP:GetFile("wosupgradeinstaller.exe",cWorkdir+"wosupgradeinstaller.exe",false,INTERNET_FLAG_DONT_CACHE + INTERNET_FLAG_RELOAD + ;
					INTERNET_FLAG_NO_CACHE_WRITE )
					WarningBox{,"Download upgrades","Problems with downloading new version of WOS. Maybe it timed out."}:Show()
					// 							__RaiseFTPError(oFTP) 
				else
					oFs:Find()
					CollectForced()  // to force some wait
					if oFs:Find()
						// change date to remote date: 
						SetFDateTime(cWorkdir+'wosupgradeinstaller.exe',RemoteDate,Remotetime )
						startfile:=cWorkdir+'wosupgradeinstaller.exe /STARTUP="'+CurPath+'"' 
// 						FileSpec{cWorkdir+"wosupgradeinstallerold.exe"}}:DELETE()
					endif
					*/
					oFTP:CloseRemote() 
					SetAmPm(lAMPM)
					return true 
				ENDIF
			endif
		endif
		SetAmPm(lAMPM)
		oFs:=null_object
		oFTP:CloseRemote() 
	else
		// 			__RaiseFTPError(oFTP) 
		LogEvent(self,"No internet connection available to check for upgrades","logerrors")
		WarningBox{,"Check upgrades","No internet connection available to check for upgrades"}:Show()
	endif
	return false


class Initialize
// initialise system
protect sIdentChar as string 
export lNewDb:=false as logic
protect aCurTable:={} as array
export FirstOfDay as logic
 
declare method create_table, ConvertDBFSQL, ConVertOneTable, InitializeDB,RenameField,Initialize,SyncColumns,Matchunequalgaps

Method ConvertDBFSQL(aColumn as array,aIndex as array) as void pascal class Initialize 
local aC:={;            // dbasename, keyname, sqlname
{"sysparms","",""},;
{"imprtTrs","","importtrans"},;
{"employee","",""},; 
{"emplAcc","",""},; 
{"currencylist","curcode",""},;
{"currrate","rateaed","currencyrate"},;
{"persbank","giropers","personbank"},;
{"account","rek",""},;
{"person","ASSRE",""},;
{"budget","BUDGET",""},;
{"accBalYr","AccBalYr","accountbalanceyear"},;  
{"mbalance","MBALACC",""},;  
{"balitem","BALNUM","balanceitem"},;  
{"balYear","BalYear","balanceyear"},;  
{"departmt","DEPID","department"},;  
{"transact","TRANSNR","transaction"},;
{"article","art",""},;
{"authfunc","authemp",""},;
{"bankacc","banknbr","bankaccount"},;
{"bankorder","bankid",""},;
{"distrins","distrid","distributioninstruction"},;
{"subscrpt","pol","subscription"},;
{"dueamnt","openpost","dueamount"},;
{"language","language",""},;
{"mailcd","perscode","perscod"},;
{"member","mbrrek",""},;
{"mutgiro","mutgiro","teletrans"},;
{"periorec","periodic","standingorder"},;
{"persprop","persprop","person_properties"},;
{"perstitl","titleid","titles"},;
{"perstype","","persontype"},;
{"ppcodes","ppcode",""},;
{"storderl","STORDRID","standingorderline"},;
{"teleptrn","teleacc","telebankpatterns"},;
{"ipcaccounts","",""};
} as array
local i,TblCnt:=Len(aC) as int
local cCreate as string, aFileDB as array, oDF as FileSpec, oDbsvr as DBServer
local dbasename,keyname,sqlname,Indbestand as string 
local lConversion,lSucc as logic
 
for i:=1 to TblCnt
	dbasename:=aC[i,1]
	keyname:=aC[i,2]
	sqlname:=aC[i,3]
	if self:ConVertOneTable(dbasename,keyname,sqlname,CurPath,aColumn)
		lConversion:=true
	endif
next
// convert archive files: 
aFileDB:=Directory(CurPath+"\tr??????.dbf")

for i:=1 to Len(aFileDB)
	oDF:=FileSpec{aFileDB[i,F_NAME]} 
	if Upper(oDF:FileName)="TRAN"
		loop
	endif
	if AScan(self:aCurTable,{|x|Upper(x[1])==Upper(AllTrim(oDF:FileName))})=0
		self:create_table("transaction",Lower(AllTrim(oDF:FileName)),,,aColumn,aIndex)
		Indbestand:="TRANSNR"+SubStr(oDF:FileName,3,6)
		IF !(FileSpec{Indbestand+'.cdx'}):Find()
			oDbsvr:=DbServer{oDF:FullPath,true,true,"DBFCDX"}
			lSucc:=oDbsvr:CreateIndex(Indbestand,"Transaktnr+seqnr")
			FileSpec{Indbestand+'.cdx'}:Find()
		endif
		if self:ConVertOneTable(Lower(oDF:FileName),Indbestand,"",CurPath,aColumn)
			lConversion:=true
		endif
	endif
next	
if lConversion
	TextBox{oMainWindow,"Conversion from DBF","Conversion completed"}:Show()
endif 
return  
method ConVertOneTable(dbasename as string,keyname as string,sqlname as string,CurPath as string, aColumn as array) as logic class Initialize
	// convert one dbf table to SQL
	Local oDbF as dbfilespec 
	local xDriver:="DBFCDX" as string
	local aDBStruct as array
	local i,j, k as int
	local fieldname, sSQLname as symbol
	local cDBValue,cMemAssAcc,cRek,cCod as string 
	local CurTransnr,Transnr as string,CurSeqnr as int
	local fDeb,fCre as float
	local cIM as string
	local oPro as ProgressPer
	LOCAL oError      as USUAL
	LOCAL cbError     as CODEBLOCK
	LOCAL oStmt,oMemAssAcc 	as SQLStatement 
	local oSel as SQLSelect
	LOCAL cStatement,cStatementBase, cAssAcc	as STRING
	local cTransaktnr as string, nSeqnr as int 
	Local mEmpid, mCLN, mCLNn, mCLNORG, mLoginName,mLoginNameN,mType, mTypeN, mDepID, mDepIDn,mLastUPD, mLstReimb, mlstLogin, mFuncName as string 
	local oAES as AES128 
	local lConverted,lSuccess,lSkip as logic
	local oDbsvr as DBServer
	local pszDBValue as psz
	local aSkip:={{"bankacc","COMFL"},{"bankacc","COMALL"},{"bankacc","PO"},{"bankacc","OPENAC"},{"balitem","INDHFDRBR"},{"person","REK"},;
	{"account","CLN"},{"ppcodes","OLDCODE"},{"member",'REK1'},{"dueamnt",'CLN'},{"dueamnt",'REK'},{"dueamnt",'PAYMETHOD'},{"dueamnt",'SOORT'}} as array
	local aNull as array
	local cFieldName as string
	
	// cbError := ErrorBlock( {|e|_Break(e)} )
	if Empty(sqlname)
		sqlname:=Lower(dbasename)
	endif

	// BEGIN SEQUENCE

	oDbF:=DbFileSpec{CurPath+"\"+dbasename,xDriver}
	if oDbF:Find()
		// convert dbase file: 
		oDbsvr:=DbServer{oDbF:FullPath,true,true,xDriver}
		if oDbsvr:Used
			sSQLname:=String2Symbol(sqlname)
			aDBStruct:=oDbsvr:DbStruct
			oSel:=SqlSelect{"select count(*) as qty from "+sIdentChar+sqlname+sIdentChar,oConn} 
			oSel:Execute()
			if IsNil(oSel:Status) .and. oSel:qty ==0.and. !EOF()
				if !Empty(keyname) 
					IF !(FileSpec{keyname+'.cdx'}):Find()
						if keyname=="curcode"
							oDbsvr:CreateIndex(keyname,"AED")
							FileSpec{keyname+'.cdx'}:Find()
							lSuccess:=DbSetIndex(keyname)
						endif
					else
						lSuccess:=DbSetIndex(keyname)
					endif 
				endif
				DbGotop()
				lConverted:=true
				if dbasename=="employee" .or. dbasename=="authfunc"
					oAES:=AES128{} 
				endif
				if dbasename="tr"
					// determine system currency:
					sCURR:=SQLSelect{"select currency from sysparms",oConn}:Currency
				endif
				cIM:="Converting table "+dbasename+"..."
				oPro:=ProgressPer{,self}
				oPro:Caption:=cIM
				oPro:SetRange(1,RECCOUNT())
				oPro:SetUnit(1)
				oPro:Show()
				// start transaction: 
				SQLStatement{"start transaction",oConn}:Execute()
				oStmt := SQLStatement{ cStatement, oConn }			 
				// determine insert statement:
				cStatementBase:=""
				aNull:={}
				for i:=1 to Len(aDBStruct) 
					cFieldName:=self:RenameField(dbasename,aDBStruct[i,DBS_NAME])
					if AScan(aColumn,{|x|x[1]==sqlname .and.x[2]==cFieldName .and. x[5]=="NULL"})>0
						AAdd(aNull,true)
					else
						AAdd(aNull,false)
					endif
					if AScan(aSkip,{|x|x[1]==dbasename.and.x[2]==aDBStruct[i,DBS_NAME]})=0
						cStatementBase+=iif(Empty(cStatementBase),"",",")+sIdentChar+ cFieldName+sIdentChar
					endif
				next
				if dbasename=='dueamnt'
					cStatementBase+=","+sIdentChar+"subscribid"+sIdentChar       // new identifier to corresponding subscription
				endif
				cStatementBase:="insert into "+sIdentChar+sqlname +sIdentChar+" (" +iif(dbasename=='member',sIdentChar+"mbrid"+sIdentChar+",","")+;
				cStatementBase+") values("
				do while !EOF()
					j++
					cStatement:=""
					lSkip:=false
					// Special treatement of Employee table: 
					if dbasename=="employee"
						mEmpid:= oDbsvr:FIELDGET(#EMPID)
						mCLN:=Crypt(oDbsvr:FIELDGET(#CLN),mEmpid+'er45pofDOIoiijodsoi*)mxcd eDFP456^)_fghj=') 
						mCLNORG:=ZeroTrim(mCLN)
						// add first insert to save encrypted persid in database, to be used in other encryptions
						cStatement:="insert into "+sIdentChar+sqlname +sIdentChar+" (empid,persid) values("+mEmpid+","+; 
						Crypt_Emp(true,"persid",mCLNORG,Val(mEmpid))+") "
						oStmt:= SQLStatement{cStatement,oConn} 
						oStmt:Execute()
						if IsNil(oStmt:Status)
							SQLStatement{"commit",oConn}:Execute() 
							cStatement:="update "+sIdentChar+sqlname +sIdentChar+" set " 

							mCLN:=oDbsvr:FIELDGET(#CLN)
							mLoginName:=oAES:decrypt("1Lp6%*mBA"+mCLN+"190(>?dg9W5~c"+mEmpid+"HLKAmUq&aspd[",AllTrim(oDbsvr:FIELDGET(#LOGINNAME)))

							mDepID:=ZeroTrim(oAES:decrypt("H:8$v#PW4(M"+mEmpid+"7€0(<?!dg9W5Ic"+mCLN+"]}\|7(@hlbz",AllTrim(oDbsvr:FIELDGET(#DEPID))))
							mType:=oAES:decrypt("W0éLp6%*mBA"+mEmpid+"5€0(>!dg9W5~c"+mCLN+"Hg'LKAeTq&aspd[",AllTrim(oDbsvr:FIELDGET(#TYPE)))
							mLastUPD:=DToS(oDbsvr:FIELDGET(#LSTUPDPW))
							mLastUPD:=SubStr(mLastUPD,1,4)+"-"+SubStr(mLastUPD,5,2)+"-"+SubStr(mLastUPD,7,2) 
							mLstReimb:=DToS(oDbsvr:FIELDGET(#LSTREIMB))
							mLstReimb:=SubStr(mLstReimb,1,4)+"-"+SubStr(mLstReimb,5,2)+"-"+SubStr(mLstReimb,7,2) 
							mlstLogin:=SQLdate(oDbsvr:FIELDGET(#LSTLOGIN))
							cStatement+="loginname="+Crypt_Emp(true,"loginname",mLoginName)+;
								',password="'+oDbsvr:FIELDGET(#PASSWORD)+'",type='+Crypt_Emp(true,"type",mType)+',LSTUPDPW="'+mLastUPD+;
								'",PSWPRV1="'+oDbsvr:FIELDGET(#PSWPRV1)+'",PSWPRV2="'+oDbsvr:FIELDGET(#PSWPRV2)+'",PSWPRV1="'+oDbsvr:FIELDGET(#PSWPRV3)+'",depid='+;
								Crypt_Emp(true,"depid",mDepID)+',INSITEUID="'+oDbsvr:FIELDGET(#INSITEUID)+'",LSTREIMB="'+mLstReimb+'",LSTLOGIN="'+mlstLogin+'",online="0"'+;
								" where empid="+mEmpid
						endif
					elseif dbasename=="authfunc"
						mEmpid:= oDbsvr:FIELDGET(#EMPID) 
						mFuncName:=oAES:decrypt("7€0(<?!dg9W5Ic]}\|7(@hlbz"+mEmpid+"H:8$v#PW4(M",AllTrim(oDbsvr:FIELDGET(#FUNCNAME)))
						cStatement:=cStatementBase+mEmpid+ ","+Crypt_Emp(true,"funcname",mFuncName,Val(mEmpid))+") "  
					else
						for i:=1	to	Len(aDBStruct)
							fieldname:=String2Symbol( aDBStruct[i,DBS_NAME]	)
							if AScan(aSkip,{|x|x[1]==dbasename.and.x[2]==aDBStruct[i,DBS_NAME]})>0 .and.!(dbasename=="member" .and. fieldname==#REK1)
								loop
							endif 
							if	aDBStruct[i,DBS_TYPE]="L"
								cDBValue:=iif(oDbsvr:FIELDGET(FieldName),"1","0")
							elseif aDBStruct[i,DBS_TYPE]="N"
								cDBValue:=Str(oDbsvr:FIELDGET(FieldName))
							elseif aDBStruct[i,DBS_TYPE]="D"
								cDBValue:=DToS(oDbsvr:FIELDGET(FieldName))
								if cDBValue=="00000000"
									cDBValue:=""
								else
									cDBValue:=SubStr(cDBValue,1,4)+"-"+SubStr(cDBValue,5,2)+"-"+SubStr(cDBValue,7,2)
								endif
							else
								pszDBValue:=oDbsvr:FIELDGET(FieldName)          // to read until ETX (end of text)
// 								cDBValue:=LTrimZero(AllTrim(Psz2String(pszDBValue) ))
								cDBValue:=AllTrim(Psz2String(pszDBValue) )
							endif
							// special conversion of associative accounts member:
							if dbasename=="member" .and. fieldname==#REK1
								if !Empty(cDBValue)
									cRek:=oDbsvr:FIELDGET(#REK)
									FOR k:=1 to Len(cDBValue)-1 step 6
										cMemAssAcc:=AllTrim( SubStr(cDBValue,k,6))
										if !Empty(cMemAssAcc)
						 					oMemAssAcc:=SQLStatement{"insert into memberassacc (Mbrid,accid) values("+cRek+","+cMemAssAcc+")",oConn}
											oMemAssAcc:Execute()
										endif
									NEXT
								endif
								loop
							elseif dbasename=="person" .and. (fieldname==#TYPE .or.fieldname==#TIT)
								// convert empty type to first value individual
								if Val(cDBValue)==0 .or.fieldname==#TIT
									cDBValue:=Str(Val(cDBValue)+1,-1)
								endif
							elseif dbasename=="person" .and. fieldname==#EXTERNID
								cDBValue:=ZeroTrim(cDBValue)
							elseif dbasename=="person" .and. fieldname==#COD 
								cDBValue:=MakeCod(Split(cDBValue," ",true))
							elseif dbasename=="perstitl" .and.fieldname==#ID
								cDBValue:=Str(Val(cDBValue)+1,-1)
							elseif dbasename=="bankacc" .and. fieldname==#TELEBANKNG
								cDBValue:=iif(Empty(cDBValue),"0","1")
							elseif dbasename=="periorec" .and. fieldname==#periode
								cDBValue:=iif(Empty(cDBValue),"1",cDBValue)
							elseif dbasename=="persbank" .and. fieldname==#gironr
								cDBValue:=ZeroTrim(cDBValue)
							elseif dbasename=="subscrpt" .and. fieldname==#bankaccnt
								cDBValue:=ZeroTrim(cDBValue)
							elseif dbasename="tr" .and. fieldname==#SEQNR
								Transnr:=AllTrim(oDbsvr:FIELDGET(#TRANSAKTNR))
								if !Transnr==CurTransnr
									CurTransnr:=Transnr
									CurSeqnr:=0
								endif
								CurSeqnr++
								cDBValue:=Str(CurSeqnr,-1)
							elseif dbasename="tr" .and. fieldname==#DEBFORGN
								if Val(cDBValue)=0 .and. Empty(oDbsvr:FIELDGET(#CURRENCY))
									fDeb:=oDbsvr:FIELDGET(#DEB)
									if !Empty(fDeb)
										cDBValue:=Str(fDeb,-1)    // default debforgn to deb
									endif
								endif
							elseif dbasename="tr" .and. fieldname==#CREFORGN
								if Val(cDBValue)=0 .and. Empty(oDbsvr:FIELDGET(#CURRENCY) )
									fCre:=oDbsvr:FIELDGET(#CRE)
									if !Empty(fCre)
										cDBValue:=Str(fCre,-1)   // default creforgn to cre
									endif
								endif
							elseif dbasename="tr" .and. fieldname==#CURRENCY
								if Empty(cDBValue)
									cDBValue:=sCurr
								endif
							elseif dbasename="tr" .and. fieldname==#TRANSAKTNR
								if Empty(cDBValue) 
									// skip this Empty line
									lSkip:=true
									exit
								endif
							elseif dbasename="budget" .and. fieldname==#REK
								if Empty(cDBValue) 
									// skip this Empty line
									lSkip:=true
									exit
								endif
							elseif dbasename="mbalance"
								if Empty(oDbsvr:FIELDGET(#REK)) .or.(Empty(oDbsvr:FIELDGET(#CRE)) .and. Empty(oDbsvr:FIELDGET(#DEB)))
									// skip this Empty line
									lSkip:=true
									exit
								endif
							endif
							cDBValue:=StrTran(StrTran(cDBValue,"\","\\"),'"','\"')
							cStatement+=iif(Empty(cStatement),"",",")+ iif(Empty(cDBValue).and.aNull[i]=true,"NULL",'"'+cDBValue+'"'+iif(dbasename=="member".and.fieldname==#REK,',"'+cDBValue+'"',"")) // mbrid = accid
						next
						if dbasename='dueamnt'
							// add subscribid from subscription
							oSel:=SQLSelect{'select subscribid from subscription where accid='+oDbsvr:rek+' and personid='+oDbsvr:cln+;
							" and paymethod='"+oDbsvr:PayMethod+"' and category='"+oDbsvr:soort+"'",oConn}
							if oSel:RecCount>0
								cStatement+=","+Str(oSel:subscribid,-1)
							else
								lSkip:=true
							endif
						ENDIF
						cStatement:=cStatementBase+cStatement+")"
					endif
					if !lSkip
						oStmt:= SQLStatement{cStatement,oConn} 
						oStmt:Execute()
						IF !IsNil( oStmt:Status )
							LogEvent(self,"Fout:"+oStmt:ErrInfo:ErrorMessage+"(Statement:"+cStatement+")","loginfo")
							// 					ShowError( oStmt:ERRINFO )
// 							oStmt:FreeStmt(SQL_CLOSE)
						endif
						oStmt:FreeStmt(SQL_DROP)
					endif
					oPro:AdvancePro()
					oDbsvr:Skip()
				enddo 
				SQLStatement{"commit",oConn}:Execute() 
				if dbasename=="employee"
					SaveCheckDigit()
				endif
				oPro:EndDialog()
				oPro:Close()
				DBCLEARINDEX()
			endif
			// 		DBCLOSEAREA()
			oDbsvr:Close()
		ENDIF	
	ENDIF 
	// RECOVER USING oError	 
	//   	GetError(self, "Error converting Table " + sqlname)
	//   	ShowError( oError )
	// 	oPro:EndDialog()
	// 	oPro:Close()
	// end SEQUENCE

	// ErrorBlock(cbError)

	return lConverted
method create_table(table_name as string, instance_name as string,engine:="MyIsam" as string,collate:="utf8_unicode_ci" as string,aColumn as array,aIndex as array) class Initialize
// create a table with itest indexes 
local cCreate, cIndex,cReqname as string
local i as int 
local oStmt as SQLStatement
LOCAL oError      as USUAL
LOCAL cbError     as CODEBLOCK
local aColName:={} as array 
if Empty(instance_name)
	instance_name:=table_name
endif
// compose create statement:
// cCreate:="CREATE TABLE "+sIdentChar+table_name+sIdentChar+ " ( " 
// aColumn: Table name, Field,Type,Null,Default,Extra
// aIndex:  Table,Non_unique,Key_name,Seq_in_index,Column_name,Collation,Cardinality,Sub_part,Packed,Null,Index_type,Comment 
do while (i:=AScan(aColumn,{|x|x[1]==table_name},i+1))>0
	cCreate+=iif(Empty(cCreate),"CREATE TABLE "+sIdentChar+instance_name+sIdentChar+ " ( ",","+CRLF)+" "+sIdentChar+aColumn[i,2]+sIdentChar+" "+;
	aColumn[i,3]+;
	iif(aColumn[i,4]=="NO"," NOT NULL","")+;
	iif(aColumn[i,5]=="NULL",iif(aColumn[i,4]=="NO",""," DEFAULT NULL"),iif(AtC("text",aColumn[i,3])>0,""," DEFAULT '"+aColumn[i,5]+"'"))+;
	+" "+aColumn[i,6] 
enddo
cIndex:=" "
i:=0 
if table_name=='teletrans'
	table_name:=table_name
endif
do while (i:=AScan(aIndex,{|x|x[1]==table_name},i+1))>0 
	if Val(aIndex[i,4])=1
		if !Empty(cIndex)
			cCreate+=", "+CRLF+cIndex+") "
			cIndex:=" "
		endif
		if aIndex[i,3]=="PRIMARY"
			cIndex+= "PRIMARY "
		else
			if aIndex[i,2]="0"
				cIndex+="UNIQUE "
			endif
		endif
		aColName:=Split(aIndex[i,5],'(',true)  // split in name and key length 
		cIndex+="KEY "+iif(aIndex[i,3]=="PRIMARY","",sIdentChar+aIndex[i,3]+sIdentChar+" ")+"("+sIdentChar+AllTrim(aColName[1])+sIdentChar  +iif(Len(aColName)>1,'('+aColName[2],'')
	else
		aColName:=Split(aIndex[i,5],'(',true)  // split in name and key length 
		cIndex+=","+sIdentChar+AllTrim(aColName[1])+sIdentChar +iif(Len(aColName)>1,'('+aColName[2],'')
	endif
enddo
if !Empty(cIndex)
	cCreate+=","+CRLF+cIndex+")" 
endif
cCreate+=" )  ENGINE="+engine+" COLLATE "+collate+";"
cbError := ErrorBlock( {|e|_Break(e)} )
BEGIN SEQUENCE
	oStmt:=SQLStatement{cCreate,oConn}
	oStmt:Execute(true)
	IF !IsNil( oStmt:Status )
		LogEvent(self,"Error:"+oStmt:ErrInfo:ErrorMessage+"(Statement:"+cCreate+")","LogErrors")
		ShowError( oStmt:ERRINFO )
		oStmt:FreeStmt(SQL_CLOSE)
		Break
	endif

// 	oStmt:Commit()
// 	oStmt:FreeStmt(SQL_DROP)
RECOVER USING oError
	 
  	GetError(self, "Error creating Table " + table_name)
  	ShowError( oError )
end SEQUENCE

ErrorBlock(cbError)
return
 
method GetLocaleInfo() as array class Initialize
// get local telephoe country code, country name and currency code
LOCAL oReg as CLASS_HKCU
LOCAL oRegLM as CLASS_HKLM
local COUNTRYCOD, CountryName, CurrencyCode,cCurrSym,PPCode, PPNAME  as string 
// Local EuroCountries:={"Andorra","Austria","Belgium","Cyprus","Finland","France","Germany","Greece","Ireland","Italy","Kosovo","Luxembourg","Malta","Monaco","Montenegro","Netherlands","Portugal","San Marino","Slovakia","Slovenia"} as array
Local oCurr as SQLSelect
Local oPP as SQLSelect
	oReg:=Class_HKCU{}
	COUNTRYCOD:=oReg:GetString("Control Panel\International","iCountry")   // telephone area
	CountryName:=oReg:GetString("Control Panel\International","sCountry") 
	cCurrSym:=oReg:GetString("Control Panel\International","sCurrency") 
	if cCurrSym=='€'
// 	if AScan(EuroCountries,CountryName) > 0
		CurrencyCode:="EUR"
	else
		oCurr:=SqlSelect{"select aed from currencylist where united_ara like '%"+CountryName+"%'",oConn}
		if oCurr:RecCount>0
			CurrencyCode:=oCurr:AED
		endif 
	endif
	oPP:=SQLSelect{"select ppcode,ppname from ppcodes where ppname like '%"+CountryName+"%'",oConn}
	if oPP:RecCount>0
		PPCode:=oPP:PPCode
		PPNAME:=oPP:PPNAME
		oPP:Skip()
		do while !oPP:EoF .and. "SIL" $ PPNAME
			PPCode:=oPP:PPCode
			PPNAME:=AllTrim(oPP:PPNAME)
			oPP:Skip()
		enddo
	endif
		
		
return {COUNTRYCOD, CountryName,PPCode,PPNAME, CurrencyCode,cCurrSym}
method init() class Initialize
	local oSel as SQLSelect
	local oStmt as SQLStatement
	local aDB:={} as array 
	local cUIDPW as string
	local cWosIni as MyFileSpec
	local	ptrHandle as MyFile

	local cLine as string
	local aWord:={} as array
	local i,j as int
	local aIniKey:={'database','password','server','username'} as array
	local dim akeyval[4] as string
	local lConnected as logic
	local time0,time1 as float
	local oTCPIP as TCPIP
	

	// make connection 
	CurPath:= iif(Empty(CurDrive()),CurDir(CurDrive()),CurDrive()+":"+if(Empty(CurDir(CurDrive())),"","\"+CurDir(CurDrive())))
	SetDefault(CurPath)
	SetPath(CurPath) 

	// read and interprete wos.ini file
	cWosIni:=MyFileSpec{CurPath+"\Wos.ini"}
	if cWosIni:Find()
		ptrHandle:=MyFile{cWosIni}
		IF FError() =0
			cLine:=AllTrim(ptrHandle:FReadLine())
			do WHILE !ptrHandle:FEof
				if !Empty(cLine) .and.!SubStr(cLine,1,1)=='#'   // skip comment lines
					aWord:=Split(cLine,"=",true)
					for i:=1 to Len(aIniKey) 
						j:=AScan(aWord,{|x|Lower(AllTrim(x))==aIniKey[i]})
						if j>0 .and.j<Len(aWord)
							akeyval[i]:=AllTrim(aWord[2])
							exit
						endif
					next
				endif
				cLine:=AllTrim(ptrHandle:FReadLine())
			ENDDO
		ENDIF
		ptrHandle:Close()
	endif
	if Empty(akeyval[3])
		servername:=GetServername(CurPath)
	else
		servername:=Lower(akeyval[3])
	endif
	if Empty(akeyval[1])
		// Determine database:
		dbname:=CurDir(CurDrive())
		if RAt('\',dbname)>0
			dbname:=SubStr(dbname,RAt('\',dbname)+1)
		endif
	else
		dbname:=akeyval[1]
	endif
	dbname:=Lower(dbname)
	if Empty(akeyval[4]) .or.Empty(akeyval[2])
		cUIDPW:=GetSQLUIDPW()
	else
		cUIDPW:=';UID='+Lower(akeyval[4])+';PWD='+akeyval[2]
	endif 
	SQLConnectErrorMsg(FALSE) 
	// 	do while !oConn:DriverConnect(self,SQL_DRIVER_NOPROMPT,"DRIVER=MySQL ODBC 5.1 Driver;SERVER="+servername+cUIDPW) 
	do while !lConnected
		oConn:=SQLConnection{} 
		if IsClass(#ADOCONNECTION)
			lConnected:=oConn:connect("DRIVER=MySQL ODBC 5.1 Driver;SERVER="+servername+cUIDPW)
		else
			lConnected:=oConn:DriverConnect(self,SQL_DRIVER_NOPROMPT,"DRIVER=MySQL ODBC 5.1 Driver;SERVER="+servername+cUIDPW) 
		endif
		if !lConnected
			// No ODBC: [Microsoft][ODBC Driver Manager] Data source name not found and no default driver specified
			// 			if AtC("[Microsoft][ODBC",oConn:ERRINFO:errormessage)>0
			if AtC("Microsoft",oConn:ERRINFO:errormessage)>0 .and. AtC("ODBC",oConn:ERRINFO:errormessage)>0
				ErrorBox{,"You have first to install the MYSQL ODBC connector"+CRLF+"Click OK and it will be downloaded"+CRLF+"Run it and accept all defaults"}:Show() 
				if oMainWindow==null_object
					oMainWindow := StandardWycWindow{self}
				endif
				FileStart(WorkDir()+iif(Empty(GetEnv('ProgramFiles(x86)')),"ODBCInstall.html","ODBCInstall64.html"),oMainWindow)
				if TextBox{oMainWindow,"Installation ODBC Connector","Did you install the Mysql ODBC Connector successfully?",BOXICONQUESTIONMARK + BUTTONYESNO}:Show()=BOXREPLYYES
					loop
				endif
				break
			endif
			// MySQL inactive: [MySQL][ODBC 5.1 Driver]Can't connect to MySQL server on 'localhost' (10061)
			if AtC("Can't connect to MySQL server",oConn:ERRINFO:errormessage)>0 
				if Lower(servername)=='localhost' .or. servername=='127.0.0.1'
					// local Mysql:
					ErrorBox{,"You have first to install MYSQL"}:Show() 
				else
					oTCPIP:=TCPIP{}
					oTCPIP:timeout:=2000
					oTCPIP:Ping(servername)
					if AtC("timeout",oTCPIP:Response)>0
						if servername=="192.168.16.2"
							// try VPN server:
							oTCPIP:Ping("192.168.16.8")
							if	AtC("timeout",oTCPIP:Response)>0
								ErrorBox{,"You have first to make a (VPN)-connection with "+servername}:Show() 
								break
							endif
						else
							ErrorBox{,"You have first to make a (VPN)-connection with "+servername}:Show() 
							break							
						endif
					endif 
					ErrorBox{,"There is something wrong with the database manager on "+servername+" or your connection is to slow"}:Show()
				endif
				break
			endif
			
			// Wrong userid/pw: [MySQL][ODBC 5.1 Driver]Access denied for user 'parousia_typ32'@'localhost' (using password: YES)
			if AtC("Access denied for user",oConn:ERRINFO:errormessage)>0 
				ErrorBox{,"Your wos.ini contains a wrong userid/password for accessing the WOS database "+dbname+" in MYSQL"}:Show()
				break
			endif
			ShowError(oConn:ERRINFO)
			Break
		endif
	enddo
	// 	oStmt:=SQLStatement{"SET character_set_results =  ascii",oConn}
	// 	oStmt:Execute()   // set interface with client to local charset 

	oSel:=SqlSelect{"show databases like '"+dbname+"'",oConn}
	oSel:Execute()
	if !Empty(oSel:Status)
		ErrorBox{self,"Error:"+oSel:ERRINFO:errormessage}:Show()
		break
	endif 
	sIdentChar:='`'
	if oSel:RecCount<1
		// database does not yet exist:
		self:lNewDb:=true
		self:FirstOfDay:=true 
		//create database: 
		oStmt:=SQLStatement{'Create Database '+sIdentChar+dbname+sIdentChar+' default character set utf8 collate utf8_unicode_ci',oConn}
		oStmt:Execute()
		if !Empty(oStmt:Status)
			ErrorBox{,"Could not create database "+dbname+"; error:"+oStmt:ERRINFO:errormessage}:Show()
			break
		endif 
	else
		dbname:=oSel:FIELDGET(1)
	endif
	oStmt:=SQLStatement{'Use `'+dbname+"`",oConn}
	oStmt:Execute() 
	if !Empty(oStmt:Status)
		ErrorBox{,"Could not connect to database "+dbname+"; error:"+oStmt:ERRINFO:errormessage}:Show()
		Break
	endif
	if !self:lNewDb
		// check if empty database:
		if SqlSelect{"show tables like 'employee'",oConn}:RecCount>0
			oSel:=SqlSelect{"select cast(lstlogin as date) as lstlogin from employee where lstlogin >= curdate()",oConn}
			if Empty(oSel:Status).and. oSel:RecCount>0
				self:FirstOfDay:=FALSE
			else	
				self:FirstOfDay:=true
				if !Empty(oSel:Status)
					self:lNewDb:=true    // apparently partly new database which need to be converted
				endif
			endif
		else
			self:FirstOfDay:=true
			self:lNewDb:=true    // apparently partly new database which need to be converted			
		endif
		if !lNewDb
			// check if programversion is newer than db
			if !SqlSelect{"show tables like 'sysparms'",oConn}:RecCount>0
				self:lNewDb:=true
			endif
		endif
	ENDIF
	// 	cLine:=SqlSelect{"select cast(sha1('dd kle 123 k mmmmmm wwwwww lllllll dddddd') as char) as hash",oConn }:hash
	return self
Method Initialize(DBVers:=0.00 as float, PrgVers:=0.00 as float) as void Pascal class Initialize
	// initialise constants: 
	LOCAL i, NwHb as int
	LOCAL nLastPers := 1 as int
	LOCAL nLastTrans as FLOAT
	Local CurVersion as string 
	local cStatement as string
	LOCAL cWorkdir := WorkDir() as STRING 
	local mindate as date
	LOCAL uMaandafsl as USUAL
	LOCAL lCopyPP,lCopyIPC,lCopyCur,lCopyBIC as LOGIC
	Local aDir,aLocal as array
	local oSel as SQLSelect
	LOCAL oSys as SQLSelect
	LOCAL oTrans as SQLSelect
	local oStmnt as SQLStatement
	LOCAL oMyFileSpec1,oMyFileSpec2,oDBFileSpec1 as FileSpec
	LOCAL oReg as CLASS_HKCU

	SetDecimalSep(Asc('.')) //  set decimal separator to . to enforce interoperability
	AdoDateTimeAsDate(true)
	SET OPTIMIZE ON

	// determine first login this day:
	oMainWindow:Pointer := Pointer{POINTERHOURGLASS}
	SQLStatement{"SET group_concat_max_len := @@max_allowed_packet",oConn}:Execute()
	// turn off strict mode:
	//	SQLStatement{"SET @@global.sql_mode= '';",oConn}:execute()
	if !self:lNewDb
		if self:FirstOfDay .and.SqlSelect{"show tables like 'employee'",oConn}:RecCount>0 
			// check if not some else has logged in parallel
			oSel:=SqlSelect{"select cast(lstlogin as date) as lstlogin from employee where lstlogin >= curdate()",oConn}
			if Empty(oSel:status).and. oSel:RecCount>0
				self:FirstOfDay:=FALSE
			endif
		endif
	endif
	/*	if !self:lNewDb
	if SqlSelect{"show tables like 'employee'",oConn}:RecCount>0
	oSel:=SqlSelect{"select cast(lstlogin as date) as lstlogin from employee where lstlogin >= curdate()",oConn}
	if Empty(oSel:status).and. oSel:RecCount>0
	self:FirstOfDay:=FALSE
	else	
	self:FirstOfDay:=true
	if !Empty(oSel:status)
	self:lNewDb:=true    // apparently partly new database which need to be converted
	endif
	endif
	else
	self:lNewDb:=true    // apparently partly new database which need to be converted			
	endif
	if !self:lNewDb .and.SqlSelect{"show tables like 'sysparms'",oConn}:RecCount<1
	self:lNewDb:=true
	endif
	ENDIF */
	cWorkdir:=SubStr(cWorkdir,1,Len(cWorkdir)-1) 
	RddSetDefault("DBFCDX") 
	// get LOCAL separator:
	oReg:=Class_HKCU{}
	Listseparator:=oReg:GetString("Control Panel\International","sList")   // delimiter for CSV
	Decseparator:=oReg:GetString("Control Panel\International","sDecimal")   // delimiter for decimals
	oReg:=null_object 

	if DBVers > PrgVers
		(ErrorBox{,"Version of Wycliffe Office System is older than version of the database."+CRLF+;
			"Make sure you have the correct version of WycOffSy.exe"}):Show()
		myApp:Quit()
		break 
	elseif !self:FirstOfDay .and.!self:lNewDb .and. PrgVers>DBVers
		// check nobody online:
		if SqlSelect{"select empid from employee where online=1 and lstlogin >=curdate()",oConn}:RecCount>0
			(ErrorBox{,"Version of Wycliffe Office System is newer than version of the database."+CRLF+;
				"Wait till other users are logged off"}):Show()
			myApp:Quit()
			break 
		endif	
	endif
	if self:FirstOfDay
		// reset employee online:
		oStmnt:=SQLStatement{"update employee set online=0 where lstlogin < curdate()",oConn}
		oStmnt:Execute()
	endif  

	if self:FirstOfDay.or.self:lNewDb .or. (!Empty(PrgVers).and. PrgVers>DBVers)       // first logged in or program newer than database?
		// check if new ppcodes, ipcaccounts or currencylist should be imported:
		oDBFileSpec1:=FileSpec{cWorkdir+"\ppcodes.csv"}
		lCopyPP:=false
		IF oDBFileSpec1:Find()
			IF oDBFileSpec1:Size>20  // not empty? 
				oSel:=SqlSelect{"show table status like 'ppcodes'",oConn}
				if oSel:RecCount=1
					if ConI(oSel:rows) > 2
						if iif(IsDate(oSel:Create_time),oSel:Create_time,SToD(StrTran(oSel:Create_time,"-",""))) < oDBFileSpec1:DateChanged
							lCopyPP:=true
						endif					
					else
						lCopyPP:=true
					endif
					if	lCopyPP
						SQLStatement{"drop table ppcodes",oConn}:Execute()
					endif
				else
					lCopyPP:=true
				endif
			endif
		endif 
		oDBFileSpec1:=FileSpec{cWorkdir+"\currencylist.csv"}
		lCopyCur:=false
		IF oDBFileSpec1:Find()
			IF oDBFileSpec1:Size>20  // not empty? 
				oSel:=SqlSelect{"show table status like 'currencylist'",oConn}
				if oSel:RecCount=1
					if ConI(oSel:rows) > 2
						if  iif(IsDate(oSel:Create_time),oSel:Create_time,SToD(StrTran(oSel:Create_time,"-",""))) < oDBFileSpec1:DateChanged
							lCopyCur:=true
						endif					
					else
						lCopyCur:=true
					endif
					if lCopyCur
						SQLStatement{"drop table currencylist",oConn}:Execute()
					endif
				else
					lCopyCur:=true
				endif
			endif
		endif
		oDBFileSpec1:=FileSpec{cWorkdir+"\ipcaccounts.csv"}
		lCopyIPC:=false
		IF oDBFileSpec1:Find()
			IF oDBFileSpec1:Size>20  // not empty? 
				oSel:=SqlSelect{"show table status like 'ipcaccounts'",oConn}
				if oSel:RecCount=1
					if ConI(oSel:rows) > 0
						if  iif(IsDate(oSel:Create_time),oSel:Create_time,SToD(StrTran(oSel:Create_time,"-",""))) < oDBFileSpec1:DateChanged
							lCopyIPC:=true
						endif					
					else
						lCopyIPC:=true
					endif
					if lCopyIPC
						SQLStatement{"drop table ipcaccounts",oConn}:Execute()
					endif
				else
					lCopyIPC:=true
				endif
			endif
		endif
		oMyFileSpec1:=FileSpec{cWorkdir+"\bic.csv"}
		lCopyBIC:=false
		IF oMyFileSpec1:Find()
			IF oMyFileSpec1:Size>10  // not empty? 
				oSel:=SqlSelect{"show table status like 'bic'",oConn}
				if oSel:RecCount=1
					if ConI(oSel:rows) > 0
						if  iif(IsDate(oSel:Create_time),oSel:Create_time,SToD(StrTran(oSel:Create_time,"-",""))) < oMyFileSpec1:DateChanged
							lCopyBIC:=true
						endif					
					else
						lCopyBIC:=true
					endif
					if	lCopyBIC
						SQLStatement{"drop table `bic`",oConn}:Execute()
					endif
				else
					lCopyBIC:=true
				endif
			endif
		endif
	endif
	if self:FirstOfDay.or.self:lNewDb .or. (!Empty(PrgVers).and. PrgVers>DBVers)       // first logged in or program newer than database? 
		if !self:lNewDb
			LogEvent(self,"Initialize DB:"+iif(self:FirstOfDay,'FirstOfDay ','')+iif(self:lNewDb,'New DB','')+iif(PrgVers>DBVers,'Prg '+Str(PrgVers,-1)+'> DB '+Str(DBVers,-1),'')+'; Prg date:'+versiondate,"loginfo")
		endif
		self:InitializeDB()
		// fill eventually dropped tables with new values:
		if lCopyPP 
			// 			self:ConVertOneTable("ppcodes","ppcode","ppcodes",cWorkdir,{})
			ImportCSV(cWorkdir+"\ppcodes.csv","ppcodes",2) 
		endif
		if lCopyCur
			ImportCSV(cWorkdir+"\currencylist.csv","currencylist",2) 
			// 			self:ConVertOneTable("currencylist","curcode","currencylist",cWorkdir,{})
		endif 
		if lCopyIPC
			ImportCSV(cWorkdir+"\ipcaccounts.csv","ipcaccounts",2) 
			// 			self:ConVertOneTable("ipcaccounts","","ipcaccounts",cWorkdir,{})			
		endif
		// load bic table
		if lCopyBIC
			// 			FillBIC()
			ImportCSV(cWorkdir+"\bic.csv","bic",1)
		endif

		// 		if self:FirstOfDay
		// 			// reset employee online:
		// 			oStmnt:=SQLStatement{"update employee set online=0 where lstlogin < curdate()",oConn}
		// 			oStmnt:Execute()
		// 		endif  
	endif

	// copy helpfile to c because it cannot read from a server: 
	GetHelpDir()
	oMyFileSpec1:=FileSpec{cWorkdir+"\WOSHlp.chm"}
	IF oMyFileSpec1:Find()
		oMyFileSpec2:=FileSpec{HelpDir+"\WOSHlp.chm"}
		IF oMyFileSpec2:Find()
			IF oMyFileSpec2:DateChanged<oMyFileSpec1:DateChanged .or.;
					(oMyFileSpec2:DateChanged=oMyFileSpec1:DateChanged .and. oMyFileSpec2:TimeChanged<oMyFileSpec1:TimeChanged)
				oMyFileSpec1:Copy(oMyFileSpec2)
			ENDIF
		ELSE
			oMyFileSpec1:Copy(oMyFileSpec2)
		ENDIF
	ENDIF	
	// copy WhatIsNewfile to c because it cannot read from a server:
	oMyFileSpec1:=FileSpec{cWorkdir+"\WosSQLNew.chm"}
	IF oMyFileSpec1:Find()
		oMyFileSpec2:=FileSpec{HelpDir+"\WosSQLNew.chm"}
		IF oMyFileSpec2:Find()
			IF oMyFileSpec2:DateChanged<oMyFileSpec1:DateChanged .or.;
					(oMyFileSpec2:DateChanged=oMyFileSpec1:DateChanged .and. oMyFileSpec2:TimeChanged<oMyFileSpec1:TimeChanged)
				oMyFileSpec1:Copy(oMyFileSpec2)
			ENDIF
		ELSE
			oMyFileSpec1:Copy(oMyFileSpec2)
		ENDIF
	ENDIF 
	// copy senditquit to c because it it asks permission when executed from a server:
	oMyFileSpec1:=FileSpec{cWorkdir+"\senditquiet.exe"}
	IF oMyFileSpec1:Find()
		oMyFileSpec2:=FileSpec{HelpDir+"\senditquiet.exe"}
		IF oMyFileSpec2:Find()
			IF oMyFileSpec2:DateChanged<oMyFileSpec1:DateChanged .or.;
					(oMyFileSpec2:DateChanged=oMyFileSpec1:DateChanged .and. oMyFileSpec2:TimeChanged<oMyFileSpec1:TimeChanged)
				oMyFileSpec1:Copy(oMyFileSpec2)
			ENDIF
		ELSE
			oMyFileSpec1:Copy(oMyFileSpec2)
		ENDIF
	ENDIF 
	
	if DBVers > PrgVers
		(ErrorBox{,"version of Wycliffe Office System is older than version of the database."+CRLF+;
			"Make sure you have the correct version of WycOffSy.exe"}):Show()
		myApp:Quit()
		break 
	elseif DBVers < PrgVers 			
		SQLStatement{"update sysparms set version='"+Version+"'",oConn}:Execute()
		// 			if !FirstOfDay
		// 				if (TextBox{,"New version","Your program version is newer than of the database. Is this correct?",BUTTONYESNO}):Show()==BOXREPLYNO
		// 					myApp:Quit() 
		// 					break
		// 				endif
		// 				SQLStatement{"update sysparms set version='"+Version+"'",oConn}:Execute()
		// 			endif
	endif
	SetDigit(18)



	mmj := CMonth(Today())
	mdw := CDoW(Today())
	cdate := AllTrim(Str(Day(Today())))+' '+mmj+' '+Str(Year(Today()),4)

	oSys := SQLSelect{"select `version`,`hb`,`lstreportmonth`,`pswrdlen`,`pswdura`,`assmntint`,`admintype`,`closemonth`,`mindate`,`yearclosed`,`countrycod`,`sysname` from sysparms",oConn}

	oSys:Execute()

	cStatement:=""
	IF self:FirstOfDay .or.self:lNewDb

		// 		endif
		// Initialize sysparms:
		IF oSys:RecCount=0
			if SqlSelect{"select united_ara,aed from currencylist",oConn}:RecCount<1
				ErrorBox{,"No currencies available, wrong installation"}:Show()
				break
			endif 
			aLocal:=self:GetLocaleInfo() 
			(CurrencySpec{,,,aLocal[5]}):Show() 
			if Empty(sCURR)  // nothing chosen
				break
			endif
			mindate:=SToD(Str(Year(Today())-1,4,0)+"0101")
			oTrans := SQLSelect{"select cast(min(dat) as date) as mindate from transaction",oConn}
			IF oTrans:RecCount>0
				if !Empty(oTrans:MinDate)
					IF (Year(oTrans:mindate)*12+Month(oTrans:mindate)-1) < mindate
						mindate := SToD(Str(Year(oTrans:MinDate),4,0)+"0101") && This date not yet closed
					ENDIF
				ENDIF		
			ENDIF
			cStatement:="insert into sysparms set "+;
				"assmntint='1'"+;
				",assmntfield='4'"+;
				",assmntoffc='5.0'"+;
				",crlanguage='E'"+;
				",topmargin='10'"+;
				",leftmargin='10'"+;
				",rightmargn='10'"+;
				",bottommarg='10'"+;
				",Closemonth='12'"+;
				",decmgift='0'"+;
				",withldoffl='5.0'"+;
				",withldoffm='5.0'"+;
				",withldoffh='5.0'"+;
				",version='"+Version+"'"+;
				iif(!Empty(aLocal),;
				",entity='"+aLocal[3]+"'"+;
				",countrycod='"+aLocal[1]+"'"+;
				",countryown='"+aLocal[2]+"'"+;
				",currname='"+aLocal[6]+"'","")+;
				",currency='"+sCURR+"'"+;
				",mindate='"+SQLdate(MinDate)+"'"+; // the previous year 
			",yearclosed='"+Str(Year(MinDate)-1,4,0)+"'" // december last year
			oStmnt:=SQLStatement{cStatement,oConn}
			oStmnt:Execute() 
			oSys:Execute()  // refersh oSys
		ENDIF
		if self:lNewDb 
			// Initialize Mailingcodes:
			oStmnt:=SQLStatement{"insert into perscod (pers_code,abbrvtn,description) values ('  ','  ','  '),('FI','FI','Financial Giver'),"+;
				"('EG','FG','First gift received'),('MW','MB','Member')",oConn} 
			oStmnt:Execute()
			// Initialize Person types: 
			oStmnt:=SQLStatement{"insert into persontype (id,abbrvtn,descrptn) values (1,'IND','Individual')",oConn}  // hard to one for default VALUE
			oStmnt:Execute()
			oStmnt:=SQLStatement{"insert into persontype (abbrvtn,descrptn) values ('MBR','Member'),('ENT','Wycliffe Entity').('GOV','Governement')"+;
				"('COM','Companies'),('DIR','Direct Income'),('CHU','Sending Church'),('OTH','Other Organization'),('CRE','Creditor')",oConn}
			oStmnt:Execute()
			// Initialize titles:
			oStmnt:=SQLStatement{"insert into titles (id,descrptn) values (1,'')",oConn}  // hard to one for default VALUE
		endif
		* remove remaining help-files:
		AEval(Directory(HelpDir+"\HU*.DBF"),{|x| FErase(HelpDir+"\"+x[F_NAME])})
		AEval(Directory(HelpDir+"\HU*.cdx"),{|x| FErase(HelpDir+"\"+x[F_NAME])})
		AEval(Directory(HelpDir+"\HP*.DBF"),{|x| FErase(HelpDir+"\"+x[F_NAME])})
		AEval(Directory(HelpDir+"\OR*.DBF"),{|x| FErase(HelpDir+"\"+x[F_NAME])})
		AEval(Directory(HelpDir+"\IN*.DBF"),{|x| FErase(HelpDir+"\"+x[F_NAME])})
		// remove mailbody files:
		AEval(Directory(HelpDir+"\mailbody*.html"), {|aFile|FErase(HelpDir+"\"+aFile[F_NAME])})
		IF .not.Empty(oSys:HB)
			oTrans := SqlSelect{"select cast(max(dat) as date) as datmax from transaction where accid="+Str(oSys:HB,-1)+" and bfm='H'",oConn}
			IF oTrans:RecCount>0 .and. !Empty(oTrans:DATmax)
				NwHb:= Year(oTrans:DATmax)*100+Month(oTrans:DATmax)
				IF NwHb > oSys:LstReportMonth 
					* to far in the past: replace:
					cStatement+=",lstreportmonth="+Str(NwHb,-1)
				ELSEIF NwHb < oSys:LstReportMonth
					IF oSys:LstReportMonth > Year(Today())*100+Month(Today())
						* in future: replace:
						cStatement+=",lstreportmonth="+Str(NwHb,-1)
					endif
				endif
			endif
		endif
	endif

	IF Empty(oSys:pswrdlen) .or. oSys:pswrdlen<8 
		cStatement+=",pswalnum=1,pswrdlen=8"
	ENDIF
	IF Empty(oSys:pswdura) .or.oSys:pswdura>365
		cStatement+=",pswdura=365"
	ENDIF
	IF Empty(oSys:assmntint)
		cStatement+=",assmntint=1"
	ENDIF
	IF Empty(oSys:ADMINTYPE)
		cStatement+=",admintype='WO'"
		ADMIN:="WO"
	endif
	* Bepaal maand afsluiting HB:
	IF Empty(oSys:CLOSEMONTH)
		cStatement+=",closemonth=12"
	endif

	IF Empty(oSys:MinDate)
		&&defaultwaarde zetten:
		cStatement+=",mindate='"+SQLdate(SToD(Str(Year(Today())-1,4,0)+"0101"))+"'" // the previous year
	ENDIF
	IF Empty(oSys:yearclosed)
		cStatement+=",yearclosed="+Str(Year(oSys:MinDate),-1)
	endif
	if Empty(oSys:LstReportMonth)
		cStatement+=",lstreportmonth="+Str(Year(Today()-70)*12+Month(Today()-70),-1)
	endif
	IF Empty(oSys:COUNTRYCOD)
		oReg:=Class_HKCU{}
		cStatement+=",countrycod='"+oReg:GetString("Control Panel\International","iCountry")+"'"   // telephone area
		oReg:=null_object
	endif
	IF Empty(oSys:SYSNAME)
		cStatement+=",sysname='"+oMainWindow:Caption+"'"
	endif
	if !oSys:Version==Version
		cStatement+=",version='"+Version+"'"
	endif
	if !Empty(cStatement)
		oStmnt:=SQLStatement{"update sysparms set "+SubStr(cStatement,2),oConn} 
		oStmnt:Execute()
	endif

	oSel:=SqlSelect{"select accid from account where giftalwd=1 limit 2",oConn} 
	if oSel:RecCount=2
		MultiDest:=true
	else
		MultiDest:=FALSE
	endif	

	// 	Set up registry settings
	InitRegistry()
	// Set up globals
	WinIniFS := WinIniFileSpec{}
	// Set default orientation to portrait:
	WycIniFS:WriteInt( "Runtime", "PrintOrientation",DMORIENT_PORTRAIT)
	oMainWindow:Pointer := Pointer{POINTERARROW}
	if self:FirstOfDay 
		// check again if not someone else has logged in in the mean time:
		oSel:=SqlSelect{"select cast(lstlogin as date) as lstlogin from employee where lstlogin >= curdate()",oConn}
		if Empty(oSel:status).and. oSel:RecCount>0
			self:FirstOfDay:=FALSE
		endif
	endif
	InitGlobals() 

	return
method InitializeDB() as void Pascal  class Initialize
	local aCurColumn:={}, aCurIndex:={} as array
	local oSel as SQLSelect
	local oStmnt as SQLStatement 
	local i,j,nTargetPos,nSourceStart,nSourceEnd,nTrCount,nLenTable as int, cRow, cTable,cTableCol as string
	local aRequiredCol,aCurrentCol,aRequiredIndex,aCurrentIndex as array
	// 	local cCollation:='ascii_general_ci' as string
	local cCollation:='utf8_unicode_ci' as string 
	LOCAL nTbl as int
	local cTableCollation as string 
	local currentSQLMode as string

	
	local aTable:={;
		{"log","InnoDB",cCollation},;	
	{"account","InnoDB",cCollation},;
		{"accountbalanceyear","InnoDB",cCollation},;
		{"article","InnoDB",cCollation},; 
	{"assessmnttotal","InnoDB",cCollation},;
		{"authfunc","InnoDB","latin1_swedish_ci"},;
		{"balanceitem","InnoDB",cCollation},;
		{"balanceyear","InnoDB",cCollation},;
		{"bankaccount","InnoDB",cCollation},;
		{"bankbalance","InnoDB",cCollation},;
		{"bankorder","InnoDB",cCollation},;
		{"bic","InnoDB",cCollation},;
		{"budget","InnoDB",cCollation},;
		{"currencylist","InnoDB",cCollation},;
		{"currencyrate","InnoDB",cCollation},;
		{"department","InnoDB",cCollation},;
		{"distributioninstruction","InnoDB",cCollation},;
		{"dueamount","InnoDB",cCollation},;
		{"emplacc","InnoDB",cCollation},; 
	{"employee","InnoDB","latin1_swedish_ci"},; 
	{"importlock","InnoDB",cCollation},;
		{"importpattern","InnoDB",cCollation},;
		{"importtrans","InnoDB",cCollation},;
		{"ipcaccounts","InnoDB",cCollation},;  
	{"language","InnoDB",cCollation},;
		{"mailaccount","InnoDB",cCollation},;
		{"mbalance","InnoDB",cCollation},;
		{"member","InnoDB",cCollation},;
		{"memberassacc","InnoDB",cCollation},;
		{"standingorder","InnoDB",cCollation},;
		{"standingorderline","InnoDB",cCollation},;
		{"perscod","InnoDB",cCollation},;
		{"person","InnoDB",cCollation},;
		{"person_properties","InnoDB",cCollation},;
		{"personbank","InnoDB",cCollation},;
		{"persontype","InnoDB",cCollation},;
		{"ppcodes","InnoDB",cCollation},;
		{"subscription","InnoDB",cCollation},;
		{"sysparms","InnoDB",cCollation},;
		{"telebankpatterns","InnoDB",cCollation},;
		{"teletrans","InnoDB",cCollation},;
		{"titles","InnoDB",cCollation},;
		{"transaction","InnoDB",cCollation}} as array

	// required tables structure:

	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  WARNING  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	// Be very cautious with combinations of changes within one table: add, drop, rename columns. Don't change the ordinal 
	// position. Columns can disappear if you make it for the system impossible to recognize what you want.   
	// 
	// A save way to implement changes within a table is:
	// 1. Add new columns add the end of the table
	// 2. Either change the type of a column either rename a column. Both at the same time can lead to a drop of the column.
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	// Table name, Field,Type,Null,Default,Extra 
	//		{"dueamount","persid","int(11)","NO","NULL",""},;
	//		{"dueamount","accid","int(11)","YES","NULL",""},;
	// 	{"dueamount","paymethod","char(1)","NO","",""},;
	// 	{"dueamount","category","char(1)","NO","",""},;

	// Table name, Field,Type,Null,Default,Extra 

	local aColumn:={;
		{"account","accid","int(11)","NO","NULL","auto_increment"},;
		{"account","balitemid","int(11)","YES","NULL",""},;
		{"account","description","char(40)","YES","NULL",""},;
		{"account","subscriptionprice","decimal(12,2)","NO","0",""},;
		{"account","giftalwd","tinyint(1)","NO","0",""},;
		{"account","clc","char(8)","NO","",""},;
		{"account","accnumber","char(12)","YES","NULL",""},;
		{"account","department","int(11)","NO","0",""},;
		{"account","propxtra","mediumtext","YES","NULL",""},;
		{"account","currency","char(3)","NO","",""},;
		{"account","multcurr","tinyint(1)","NO","0",""},;
		{"account","reevaluate","tinyint(1)","NO","0",""},;
		{"account","gainlsacc","int(11)","NO","0",""},;
		{"account","ipcaccount","int(7)","NO","0",""},;
		{"account","reimb","tinyint(1)","NO","0",""},;
		{"account","active","tinyint(1)","NO","1",""},;
		{"account","qtymailing","int(10) unsigned","NO","0",""},;
		{"account","monitor","tinyint(1)","NO","0",""},;
		{"account","altertime","timestamp","NO","0000-00-00","ON UPDATE CURRENT_TIMESTAMP"},; 
	{"accountbalanceyear","accid","int(11)","NO","NULL",""},;
		{"accountbalanceyear","yearstart","smallint(6)","NO","0",""},;
		{"accountbalanceyear","monthstart","smallint(6)","NO","0",""},;
		{"accountbalanceyear","svjd","decimal(20,2)","NO","0",""},;
		{"accountbalanceyear","svjc","decimal(20,2)","NO","0",""},;
		{"accountbalanceyear","currency","char(3)","NO","",""},;
		{"article","articleid","int(11)","NO","NULL","auto_increment"},;
		{"article","description","char(30)","YES","NULL",""},;
		{"article","purchaseqty","int(7)","NO","0",""},;
		{"article","purchaseprice","decimal(12,2)","NO","0",""},;
		{"article","soldqty","int(7)","NO","0",""},;
		{"article","sellingprice","decimal(12,2)","NO","0",""},;
		{"article","datelastsold","date","NO","0000-00-00",""},;
		{"article","soldamount","decimal(15,2)","NO","0",""},;
		{"article","accountyield","int(11)","NO","0",""},;
		{"article","supplier","char(30)","NO","",""},;
		{"article","accountstock","int(11)","NO","0",""},;
		{"article","accountpurchase","int(11)","NO","0",""},;   
	{"assessmnttotal","assid","int(11)","NO","NULL","auto_increment"},;
		{"assessmnttotal","mbrid","int(11)","NO","NULL",""},;
		{"assessmnttotal","calcdate","date","NO","0000-00-00",""},;
		{"assessmnttotal","periodbegin","date","NO","0000-00-00",""},;
		{"assessmnttotal","periodend","date","NO","0000-00-00",""},;
		{"assessmnttotal","amountassessed","decimal(15,2)","NO","0",""},;
		{"assessmnttotal","amountofficeassmnt","decimal(12,2)","NO","0",""},;
		{"assessmnttotal","amountintassmnt","decimal(12,2)","NO","0",""},;
		{"assessmnttotal","percofficeassmnt","decimal(4,1)","NO","0",""},;
		{"assessmnttotal","percintassmnt","decimal(4,1)","NO","0",""},;
		{"authfunc","empid","int(11)","NO","NULL",""},;
		{"authfunc","funcname","char(32)","NO","",""},;
		{"balanceitem","balitemid","int(11)","NO","NULL","auto_increment"},;
		{"balanceitem","heading","char(25)","NO","",""},;
		{"balanceitem","footer","char(25)","NO","",""},;
		{"balanceitem","balitemidparent","int(11)","NO","0",""},;
		{"balanceitem","category","char(2)","NO","",""},;
		{"balanceitem","number","varchar(20)","YES","NULL",""},;
		{"balanceyear","yearstart","smallint(6)","NO","0",""},;
		{"balanceyear","monthstart","smallint(6)","NO","0",""},;
		{"balanceyear","yearlength","smallint(6)","NO","0",""},;
		{"balanceyear","state","char(1)","NO","",""},;
		{"bankaccount","bankid","int(11)","NO","NULL","auto_increment"},;
		{"bankaccount","banknumber","varchar(64)","NO","NULL",""},;
		{"bankaccount","accid","int(11)","YES","NULL",""},;
		{"bankaccount","usedforgifts","tinyint(1)","NO","0",""},;
		{"bankaccount","telebankng","tinyint(1)","NO","0",""},;
		{"bankaccount","teledatdir","char(40)","NO","",""},;
		{"bankaccount","giftsall","tinyint(1)","NO","0",""},;
		{"bankaccount","openall","tinyint(1)","NO","0",""},;
		{"bankaccount","payahead","int(11)","NO","0",""},;
		{"bankaccount","singledst","int(11)","NO","0",""},;
		{"bankaccount","fgmlcodes","char(30)","NO","",""},;
		{"bankaccount","bic","varchar(11)","NO","",""},;
		{"bankaccount","syscodover","char(1)","NO","",""},;
		{"bankbalance","accid","int(11)","NO","NULL",""},;
		{"bankbalance","datebalance","date","NO","0000-00-00",""},;
		{"bankbalance","balance","decimal(15,2)","NO","0",""},;
		{"bankorder","id","int(11)","NO","NULL","auto_increment"},;
		{"bankorder","accntfrom","int(11)","YES","NULL",""},;
		{"bankorder","banknbrcre","varchar(64)","NO","",""},;
		{"bankorder","amount","decimal(15,2)","NO","0",""},;
		{"bankorder","datedue","date","NO","0000-00-00",""},;
		{"bankorder","datepayed","date","NO","0000-00-00",""},;
		{"bankorder","description","varchar(511)","NO","",""},;
		{"bankorder","idfrom","int(11)","NO","0",""},;
		{"bankorder","stordrid","int(11)","NO","0",""},;
		{"bic","bic","char(8)","NO","",""},;
		{"budget","accid","int(11)","NO","NULL",""},;
		{"budget","year","smallint(4)","NO","0",""},;
		{"budget","month","tinyint(2)","NO","0",""},;
		{"budget","amount","decimal(18,2)","NO","0",""},;
		{"currencylist","aed","char(3)","NO","",""},;
		{"currencylist","united_ara","varchar(59)","NO","",""},;
		{"currencyrate","rateid","int(11)","NO","NULL","auto_increment"},;           
	{"currencyrate","aed","char(3)","NO","NULL",""},;
		{"currencyrate","daterate","date","NO","0000-00-00",""},;
		{"currencyrate","roe","decimal(16,10)","NO","0",""},;
		{"currencyrate","aedunit","char(3)","NO","",""},;
		{"department","depid","int(11)","NO","NULL","auto_increment"},;
		{"department","descriptn","char(40)","YES","NULL",""},;
		{"department","deptmntnbr","varchar(20)","YES","NULL",""},;
		{"department","netasset","int(11)","NO","0",""},;
		{"department","parentdep","int(11)","NO","0",""},;
		{"department","persid","int(11)","NO","0",""},;
		{"department","persid2","int(11)","NO","0",""},;
		{"department","assacc1","int(11)","NO","0",""},;
		{"department","assacc2","int(11)","NO","0",""},;
		{"department","assacc3","int(11)","NO","0",""},;
		{"department","ipcproject","int(5)","NO","0",""},;
		{"department","incomeacc","int(11)","NO","0",""},;
		{"department","expenseacc","int(11)","NO","0",""},;
		{"department","payableacc","int(11)","NO","0",""},;
		{"department","receivableacc","int(11)","NO","0",""},;
		{"distributioninstruction","mbrid","int(11)","NO","NULL",""},;
		{"distributioninstruction","seqnbr","int(3)","NO","0",""},;
		{"distributioninstruction","destacc","varchar(70)","NO","",""},;
		{"distributioninstruction","destpp","char(3)","NO","",""},;
		{"distributioninstruction","desttyp","int(1)","NO","0",""},;
		{"distributioninstruction","destamt","decimal(12,2)","NO","0",""},;
		{"distributioninstruction","lstdate","date","NO","0000-00-00",""},;
		{"distributioninstruction","descrptn","varchar(70)","NO","",""},;
		{"distributioninstruction","currency","tinyint(1)","NO","0",""},;
		{"distributioninstruction","disabled","tinyint(1)","NO","0",""},;
		{"distributioninstruction","amntsnd","decimal(12,2)","NO","0",""},;
		{"distributioninstruction","dfir","char(9)","NO","",""},;
		{"distributioninstruction","dfia","char(17)","NO","",""},;
		{"distributioninstruction","checksave","char(1)","NO","",""},; 
	{"distributioninstruction","singleuse","tinyint(1)","NO","0",""},; 
	{"dueamount","dueid","int(11)","NO","NULL","auto_increment"},;
		{"dueamount","invoicedate","date","NO","0000-00-00",""},;
		{"dueamount","seqnr","int(2)","NO","0",""},;
		{"dueamount","amountinvoice","decimal(13,2)","NO","0",""},;
		{"dueamount","amountrecvd","decimal(13,2)","NO","0",""},;
		{"dueamount","datelstreminder","date","NO","0000-00-00",""},;
		{"dueamount","remindercnt","int(1)","NO","0",""},;
		{"dueamount","subscribid","int(11)","NO","NULL",""},;
		{"dueamount","seqtype","char(4)","NO","",""},;
		{"employee","empid","int(11)","NO","NULL","auto_increment"},;
		{"employee","loginname","varbinary(64)","NO","",""},;
		{"employee","password","varchar(64)","NO","",""},;
		{"employee","persid","varchar(32)","NO","",""},;
		{"employee","type","varbinary(32)","NO","",""},;
		{"employee","lstupdpw","date","NO","0000-00-00",""},;
		{"employee","pswprv1","varchar(64)","NO","",""},;
		{"employee","pswprv2","varchar(64)","NO","",""},;
		{"employee","pswprv3","varchar(64)","NO","",""},;
		{"employee","depid","varbinary(32)","NO","",""},;
		{"employee","insiteuid","char(40)","NO","",""},; 
	{"employee","lstreimb","date","NO","0000-00-00",""},;
		{"employee","lstlogin","datetime","YES","0000-00-00 00:00:00",""},;
		{"employee","online","tinyint(1)","NO","0",""},;
		{"employee","lstnews","date","NO","0000-00-00",""},;
		{"emplacc","empid","int(11)","NO","NULL",""},;
		{"emplacc","accid","int(11)","NO","NULL",""},;
		{"emplacc","type","tinyint(1)","NO","0",""},;
		{"importlock","importfile","char(40)","NO","NULL",""},;
		{"importlock","lock_id","int(11)","NO","0",""},;
		{"importlock","lock_time","timestamp","NO","0000-00-00",""},; 
	{"importpattern","imppattrnid","int(11)","NO","NULL","auto_increment"},;
		{"importpattern","descriptn","varchar(511)","NO","",""},;
		{"importpattern","origin","char(11)","NO","",""},;
		{"importpattern","assmntcd","char(2)","NO","",""},;
		{"importpattern","debcre","char(1)","NO","",""},;
		{"importpattern","accid","int(11)","NO","0",""},;
		{"importpattern","recdate","date","NO","0000-00-00",""},;
		{"importpattern","automatic","tinyint(1)","NO","0",""},;
		{"importtrans","imptrid","int(11)","NO","NULL","auto_increment"},;
		{"importtrans","transdate","date","NO","0000-00-00",""},;
		{"importtrans","docid","varchar(31)","NO","",""},;
		{"importtrans","transactnr","varchar(31)","NO","",""},;
		{"importtrans","accountnr","varchar(20)","NO","",""},;
		{"importtrans","descriptn","varchar(511)","NO","",""},;
		{"importtrans","debitamnt","decimal(15,2)","NO","0",""},;
		{"importtrans","creditamnt","decimal(15,2)","NO","0",""},;
		{"importtrans","assmntcd","char(2)","NO","",""},;
		{"importtrans","processed","tinyint(1)","NO","0",""},;
		{"importtrans","origin","char(11)","NO","",""},;
		{"importtrans","accname","char(25)","NO","",""},;
		{"importtrans","giver","varchar(127)","NO","",""},;
		{"importtrans","transtyp","char(2)","NO","",""},;
		{"importtrans","fromrpp","tinyint(1)","NO","0",""},;
		{"importtrans","externid","varchar(24)","NO","",""},;
		{"importtrans","debforgn","decimal(15,2)","NO","0",""},;
		{"importtrans","creforgn","decimal(15,2)","NO","0",""},;
		{"importtrans","currency","char(3)","NO","",""},;
		{"importtrans","reference","varchar(127)","NO","",""},;
		{"importtrans","seqnr","int(4)","NO","0",""},; 
	{"importtrans","poststatus","int(1)","NO","0",""},; 
	{"importtrans","ppdest","char(3)","NO","",""},; 
	{"importtrans","lock_id","int(11)","NO","0",""},;
		{"importtrans","lock_time","timestamp","NO","0000-00-00",""},;
		{"ipcaccounts","ipcaccount","int(7)","NO","NULL",""},;
		{"ipcaccounts","descriptn","varchar(50)","NO","",""},;
		{"language","sentenceen","varchar(512)","NO","",""},;
		{"language","sentencemy","varchar(512)","NO","",""},;
		{"language","length","int(3)","NO","80",""},;
		{"language","location","char(1)","NO","",""},;
		{"log","logid","int(11)","NO","NULL","auto_increment"},;
		{"log","collection","varchar(20)","NO","log",""},;
		{"log","source","varchar(40)","NO","",""},;
		{"log","logtime","datetime","NO","0000-00-00",""},;
		{"log","message","mediumtext","NO","",""},;
		{"log","userid","varchar(64)","NO","",""},;
		{"mailaccount","empid","int(11)","NO","0",""},;
		{"mailaccount","emailaddress","varchar(64)","NO","",""},;
		{"mailaccount","username","varchar(64)","NO","",""},;
		{"mailaccount","password","varbinary(64)","NO","",""},;
		{"mailaccount","outgoingserver","varchar(64)","NO","",""},;
		{"mailaccount","port","int(5)","NO","587",""},;
		{"mailaccount","protocol","char(3)","NO","",""},;
		{"mbalance","mbalid","int(11)","NO","NULL","auto_increment"},;
		{"mbalance","accid","int(11)","NO","0",""},;
		{"mbalance","year","smallint(6)","NO","0",""},;
		{"mbalance","month","smallint(6)","NO","0",""},;
		{"mbalance","currency","char(3)","NO","",""},;
		{"mbalance","deb","decimal(20,2)","NO","0",""},;
		{"mbalance","cre","decimal(20,2)","NO","0",""},;
		{"member","mbrid","int(11)","NO","NULL","auto_increment"},;
		{"member","accid","int(11)","YES","NULL",""},;
		{"member","persid","int(11)","NO","NULL",""},;
		{"member","householdid","char(20)","NO","",""},;
		{"member","has","tinyint(1)","NO","0",""},;
		{"member","aow","decimal(8,2)","NO","0",""},;
		{"member","zkv","decimal(8,2)","NO","0",""},;
		{"member","co","char(1)","NO","m",""},;
		{"member","grade","char(6)","NO","sm",""},;
		{"member","homepp","char(3)","NO","",""},;
		{"member","homeacc","varchar(70)","NO","",""},;
		{"member","offcrate","char(1)","NO","m",""},;
		{"member","contact","int(11)","NO","0",""},;
		{"member","rptdest","int(2)","NO","0",""},; 
	{"member","depid","int(11)","YES","NULL",""},;
		{"member","contact2","int(11)","NO","0",""},;
		{"member","contact3","int(11)","NO","0",""},;
		{"memberassacc","mbrid","int(11)","NO","NULL",""},;
		{"memberassacc","accid","int(11)","NO","NULL",""},;
		{"perscod","pers_code","char(2)","NO","","collate ascii_bin"},;
		{"perscod","description","char(20)","YES","NULL",""},;
		{"perscod","abbrvtn","char(3)","NO","NULL",""};
		} as array
	// additional required tables structure:
	// Table name, Field,Type,Null,Default,Extra 
	local aColumn2:={;
		{"person","persid","int(11)","NO","NULL","auto_increment"},;
		{"person","title","smallint(6)","NO","0",""},;
		{"person","lastname","char(28)","NO","",""},;
		{"person","address","varchar(240)","NO","",""},;
		{"person","attention","char(28)","NO","",""},;
		{"person","initials","char(10)","NO","",""},;
		{"person","nameext","char(28)","NO","",""},;
		{"person","firstname","char(20)","NO","",""},;
		{"person","postalcode","char(14)","NO","",""},;
		{"person","city","char(35)","NO","",""},;
		{"person","country","char(20)","NO","",""},;
		{"person","telbusiness","char(18)","NO","",""},;
		{"person","telhome","char(18)","NO","",""},;
		{"person","fax","char(18)","NO","",""},;
		{"person","prefix","char(8)","NO","",""},;
		{"person","mailingcodes","varchar(100)","NO","",""},;
		{"person","creationdate","date","NO","0000-00-00",""},;
		{"person","alterdate","date","NO","0000-00-00",""},;
		{"person","datelastgift","date","NO","0000-00-00",""},;
		{"person","opc","char(10)","NO","",""},;
		{"person","remarks","mediumtext","YES","NULL",""},;
		{"person","email","varchar(64)","NO","",""},;
		{"person","mobile","char(18)","NO","",""},;
		{"person","type","smallint(6)","NO","1",""},;
		{"person","birthdate","date","NO","0000-00-00",""},;
		{"person","gender","smallint(6)","NO","0",""},;
		{"person","propextr","mediumtext","YES","NULL",""},;
		{"person","externid","char(10)","NO","",""},; 
	{"person","deleted","tinyint(1)","NO","0",""},; 
	{"person_properties","id","int(3)","NO","NULL","auto_increment"},;
		{"person_properties","name","char(30)","YES","NULL",""},;
		{"person_properties","type","int(1)","NO","0",""},;
		{"person_properties","values","mediumtext","NO","",""},;
		{"personbank","persid","int(11)","NO","0",""},;
		{"personbank","banknumber","varchar(64)","NO","",""},;
		{"personbank","bic","varchar(11)","NO","",""},;
		{"persontype","id","smallint(6)","NO","NULL","auto_increment"},;
		{"persontype","descrptn","char(30)","YES","NULL",""},;
		{"persontype","abbrvtn","char(3)","YES","NULL",""},;
		{"ppcodes","ppcode","char(3)","NO","",""},;
		{"ppcodes","ppname","char(40)","NO","",""},;
		{"standingorder","stordrid","int(11)","NO","NULL","auto_increment"},;
		{"standingorder","idat","date","NO","0000-00-00",""},;
		{"standingorder","edat","date","NO","0000-00-00",""},;
		{"standingorder","day","int(3)","NO","1",""},;
		{"standingorder","lstrecording","date","NO","0000-00-00",""},;
		{"standingorder","period","int(2)","NO","1",""},;
		{"standingorder","persid","int(11)","NO","0",""},;
		{"standingorder","currency","char(3)","NO","",""},;
		{"standingorder","docid","char(10)","NO","",""},; 
	{"standingorderline","stordrid","int(11)","NO","0",""},;
		{"standingorderline","seqnr","smallint(4)","NO","0",""},;
		{"standingorderline","accountid","int(11)","NO","0",""},;
		{"standingorderline","deb","decimal(19,2)","NO","0",""},;
		{"standingorderline","cre","decimal(19,2)","NO","0",""},;
		{"standingorderline","descriptn","varchar(511)","NO","",""},;
		{"standingorderline","gc","char(2)","NO","",""},;
		{"standingorderline","reference","varchar(127)","NO","",""},;
		{"standingorderline","bankacct","varchar(64)","NO","",""},;
		{"standingorderline","creditor","int(11)","NO","0",""},;
		{"subscription","SUBSCRIBID","int(11)","NO","NULL","auto_increment"},;
		{"subscription","personid","int(11)","YES","NULL",""},;
		{"subscription","accid","int(11)","YES","NULL",""},;
		{"subscription","begindate","date","NO","0000-00-00",""},;
		{"subscription","enddate","date","NO","0000-00-00",""},;
		{"subscription","duedate","date","NO","0000-00-00",""},;
		{"subscription","term","int(4)","NO","0",""},;
		{"subscription","amount","decimal(10,2)","NO","0",""},;
		{"subscription","lstchange","date","NO","0000-00-00",""},;
		{"subscription","category","char(1)","NO","",""},;
		{"subscription","gc","char(2)","NO","",""},;
		{"subscription","paymethod","char(1)","NO","",""},;
		{"subscription","invoiceid","varchar(35)","NO","",""},;
		{"subscription","bankaccnt","varchar(64)","NO","",""},;
		{"subscription","reference","varchar(127)","NO","",""},;
		{"subscription","firstinvoicedate","date","NO","0000-00-00",""},;
		{"subscription","bic","varchar(11)","NO","",""},;
		{"sysparms","yearclosed","int(4)","NO","0",""},;
		{"sysparms","lstreportmonth","int(6)","NO","0",""},;
		{"sysparms","mindate","date","NO","0000-00-00",""},;
		{"sysparms","projects","int(11)","NO","0",""},;
		{"sysparms","debtors","int(11)","NO","0",""},;
		{"sysparms","donors","int(11)","NO","0",""},;
		{"sysparms","cash","int(11)","NO","0",""},;
		{"sysparms","capital","int(11)","NO","0",""},;
		{"sysparms","crossaccnt","int(11)","NO","0",""},;
		{"sysparms","hb","int(11)","NO","0",""},;
		{"sysparms","am","int(11)","NO","0",""},;
		{"sysparms","assmntfield","decimal(5,2)","NO","0",""},;
		{"sysparms","assmntoffc","decimal(5,2)","NO","0",""},;
		{"sysparms","entity","char(3)","NO","",""},;
		{"sysparms","stocknbr","char(2)","NO","",""},;
		{"sysparms","postage","int(11)","NO","0",""},;
		{"sysparms","purchase","int(11)","NO","0",""},;
		{"sysparms","countryown","char(20)","NO","",""},;
		{"sysparms","currency","char(3)","NO","",""},;
		{"sysparms","currname","char(25)","NO","",""},;
		{"sysparms","firstname","tinyint(1)","NO","0",""},;
		{"sysparms","crlanguage","char(1)","NO","",""},;
		{"sysparms","defaultcod","char(30)","NO","",""},;
		{"sysparms","topmargin","int(2)","NO","0",""},;
		{"sysparms","leftmargin","int(2)","NO","0",""},;
		{"sysparms","rightmargn","int(2)","NO","0",""},;
		{"sysparms","bottommarg","int(2)","NO","0",""},;
		{"sysparms","cityletter","char(18)","NO","",""},;
		{"sysparms","ownmailacc","varchar(100)","NO","",""},;
		{"sysparms","smtpserver","char(30)","NO","",""},;
		{"sysparms","iesmailacc","varchar(100)","NO","",""},;
		{"sysparms","exchrate","decimal(12,8)","NO","0",""},;
		{"sysparms","closemonth","int(2)","NO","0",""},;
		{"sysparms","admintype","char(2)","NO","",""},;
		{"sysparms","pswrdlen","int(2)","NO","8",""},;
		{"sysparms","pswalnum","tinyint(1)","NO","0",""},;
		{"sysparms","pswdura","int(4)","NO","0",""},;
		{"sysparms","decmgift","tinyint(1)","NO","0",""},;
		{"sysparms","expmailacc","varchar(100)","NO","",""},;
		{"sysparms","pmislstsnd","date","NO","0000-00-00",""},;
		{"sysparms","assmntint","decimal(5,2)","NO","0",""},;
		{"sysparms","destgrps","mediumtext","NO","",""},;
		{"sysparms","nosalut","tinyint(1)","NO","0",""},;
		{"sysparms","withldoffl","decimal(5,2)","NO","0",""},;
		{"sysparms","withldoffm","decimal(5,2)","NO","0",""},;
		{"sysparms","withldoffh","decimal(5,2)","NO","0",""},;
		{"sysparms","assproja","int(11)","NO","0",""},;
		{"sysparms","owncntry","mediumtext","NO","",""},;
		{"sysparms","giftincac","int(11)","NO","0",""},;
		{"sysparms","giftexpac","int(11)","NO","0",""},;
		{"sysparms","cntrnrcoll","varchar(32)","NO","",""},;
		{"sysparms","banknbrcol","int(11)","NO","0",""},;
		{"sysparms","idorg","int(11)","NO","0",""},;
		{"sysparms","idcontact","int(11)","NO","0",""},;
		{"sysparms","datlstafl","date","NO","0000-00-00",""},;
		{"sysparms","surnmfirst","tinyint(1)","NO","0",""},;
		{"sysparms","strzipcity","tinyint(1)","NO","0",""},;
		{"sysparms","sysname","varchar(150)","NO","",""},;
		{"sysparms","homeincac","int(11)","NO","0",""},;
		{"sysparms","homeexpac","int(11)","NO","0",""},;
		{"sysparms","fgmlcodes","char(30)","NO","",""},;
		{"sysparms","creditors","int(11)","NO","0",""},;
		{"sysparms","countrycod","char(3)","NO","",""},;
		{"sysparms","banknbrcre","int(11)","NO","0",""},;
		{"sysparms","lstreeval","date","NO","0000-00-00",""},;
		{"sysparms","citynmupc","tinyint(1)","NO","0",""},;
		{"sysparms","pmcmancln","int(11)","NO","0",""},;
		{"sysparms","version","char(10)","NO","",""},;
		{"sysparms","lstnmupc","tinyint(1)","NO","0",""},;
		{"sysparms","titinadr","tinyint(1)","NO","0",""},;
		{"sysparms","docpath","mediumtext","NO","",""},;
		{"sysparms","checkemp","char(32)","NO","",""},;
		{"sysparms","mailclient","tinyint(1)","NO","0",""},;
		{"sysparms","posting","tinyint(1)","NO","0",""},; 
	{"sysparms","toppacct","int(11)","NO","0",""},;
		{"sysparms","lstcurrt","tinyint(1)","NO","0",""},; 
	{"sysparms","pmcupld","tinyint(1)","NO","0",""},; 
	{"sysparms","accpacls","date","NO","0000-00-00",""},; 
	{"sysparms","assfldac","int(11)","NO","0",""},;
		{"sysparms","sepaenabled","tinyint(1)","NO","0",""},; 
	{"sysparms","ddmaxindvdl","decimal(10,2)","NO","0",""},;
		{"sysparms","ddmaxbatch","decimal(12,2)","NO","0",""},;
		{"sysparms","maildirect","tinyint(1)","NO","0",""},; 
	{"telebankpatterns","telpatid","int(11)","NO","NULL","auto_increment"},;
		{"telebankpatterns","kind","char(6)","NO","",""},;
		{"telebankpatterns","contra_bankaccnt","varchar(64)","NO","",""},;
		{"telebankpatterns","contra_name","char(32)","NO","",""},;
		{"telebankpatterns","addsub","char(1)","NO","",""},;
		{"telebankpatterns","description","varchar(128)","NO","",""},;
		{"telebankpatterns","accid","int(11)","NO","0",""},;
		{"telebankpatterns","ind_autmut","tinyint(1)","NO","0",""},;
		{"telebankpatterns","recdate","date","NO","0000-00-00",""},;
		{"teletrans","teletrid","int(11)","NO","NULL","auto_increment"},;
		{"teletrans","bankaccntnbr","varchar(64)","NO","",""},;
		{"teletrans","bookingdate","date","NO","0000-00-00",""},;
		{"teletrans","seqnr","int(10)","NO","0",""},;
		{"teletrans","contra_bankaccnt","varchar(64)","NO","",""},;
		{"teletrans","kind","char(6)","NO","",""},;
		{"teletrans","contra_name","varchar(64)","NO","",""},;
		{"teletrans","budgetcd","char(20)","NO","",""},;
		{"teletrans","amount","decimal(15,2)","NO","0",""},;
		{"teletrans","addsub","char(1)","NO","",""},;
		{"teletrans","code_mut_r","char(1)","NO","",""},;
		{"teletrans","description","mediumtext","NO","",""},;
		{"teletrans","processed","char(1)","NO","",""},;
		{"teletrans","persid","int(11)","NO","0",""},;
		{"teletrans","lock_id","int(11)","NO","0",""},;
		{"teletrans","lock_time","timestamp","NO","0000-00-00",""},;
		{"teletrans","bic","varchar(11)","NO","",""},;
		{"teletrans","country","char(2)","NO","",""},;
		{"teletrans","adrline","varchar(70)","NO","",""},;
		{"titles","id","smallint(6)","NO","NULL","auto_increment"},;
		{"titles","descrptn","char(12)","NO","",""},;
		{"transaction","persid","int(11)","YES","NULL",""},;
		{"transaction","accid","int(11)","NO","NULL",""},;
		{"transaction","docid","varchar(31)","NO","",""},;
		{"transaction","dat","date","NO","0000-00-00",""},;
		{"transaction","description","varchar(511)","YES","",""},;
		{"transaction","deb","decimal(19,2)","NO","0",""},;
		{"transaction","cre","decimal(19,2)","NO","0",""},;
		{"transaction","gc","char(2)","NO","",""},;
		{"transaction","bfm","char(1)","NO","",""},;
		{"transaction","transid","int(11)","NO","NULL","auto_increment"},;
		{"transaction","userid","varchar(32)","NO","",""},;
		{"transaction","fromrpp","tinyint(1)","NO","0",""},;
		{"transaction","opp","char(3)","NO","",""},;
		{"transaction","debforgn","decimal(19,2)","NO","0",""},;
		{"transaction","creforgn","decimal(19,2)","NO","0",""},;
		{"transaction","currency","char(3)","NO","",""},; 
	{"transaction","reference","varchar(127)","NO","",""},;
		{"transaction","seqnr","smallint(4)","NO","NULL",""},;
		{"transaction","poststatus","tinyint(1)","NO","0",""},;
		{"transaction","ppdest","char(3)","NO","",""},;
		{"transaction","lock_id","int(11)","NO","0",""},;
		{"transaction","lock_time","timestamp","NO","0000-00-00",""};
		} as array  
	
	// specify indexes per table:
	// Table,Non_unique,Key_name,Seq_in_index,Column_name
	local aIndex:={;
		{"account","0","PRIMARY","1","accid"},;
		{"account","0","description","1","description"},;
		{"account","0","accnumber","1","accnumber"},;
		{"account","1","balitemid","1","balitemid"},;
		{"account","1","department","1","department"},;
		{"accountbalanceyear","0","PRIMARY","1","accid"},;
		{"accountbalanceyear","0","PRIMARY","2","yearstart"},;
		{"accountbalanceyear","0","PRIMARY","3","monthstart"},;
		{"accountbalanceyear","0","PRIMARY","4","currency"},;
		{"article","0","PRIMARY","1","articleid"},;
		{"article","0","description","1","description"},;              
	{"assessmnttotal","0","PRIMARY","1","assid"},;
		{"assessmnttotal","1","membrid","1","mbrid"},;
		{"assessmnttotal","1","membrid","2","calcdate"},;
		{"authfunc","0","PRIMARY","1","empid"},;
		{"authfunc","0","PRIMARY","2","funcname"},;
		{"balanceitem","0","PRIMARY","1","balitemid"},;
		{"balanceitem","0","NUMBER","1","NUMBER"},;
		{"balanceitem","1","balitemidparent","1","balitemidparent"},;
		{"balanceitem","1","balitemidparent","2","number"},;
		{"balanceitem","1","Heading","1","Heading"},;
		{"balanceyear","0","PRIMARY","1","yearstart"},;
		{"balanceyear","0","PRIMARY","2","monthstart"},;
		{"bankaccount","0","PRIMARY","1","bankid"},;
		{"bankaccount","0","banknumber","1","banknumber"},;
		{"bankaccount","1","accid","1","accid"},;
		{"bankbalance","0","PRIMARY","1","accid"},;
		{"bankbalance","0","PRIMARY","2","datebalance"},;
		{"bankorder","0","PRIMARY","1","id"},;
		{"bankorder","1","accntfrom","1","accntfrom"},;
		{"bic","0","PRIMARY","1","bic"},;
		{"budget","0","PRIMARY","1","accid"},;
		{"budget","0","PRIMARY","2","year"},;
		{"budget","0","PRIMARY","3","month"},;
		{"currencylist","0","PRIMARY","1","aed"},;
		{"currencyrate","0","PRIMARY","1","rateid"},;
		{"currencyrate","0","aeddate","1","aed"},;
		{"currencyrate","0","aeddate","2","daterate"},;
		{"currencyrate","0","aeddate","3","aedunit"},;
		{"department","0","PRIMARY","1","depid"},;
		{"department","0","deptmntnbr_2","1","deptmntnbr"},;
		{"department","0","descriptn","1","descriptn"},;
		{"department","1","deptmntnbr_3","1","parentdep"},;
		{"department","1","deptmntnbr_3","2","deptmntnbr"},;
		{"distributioninstruction","0","PRIMARY","1","mbrid"},;
		{"distributioninstruction","0","PRIMARY","2","seqnbr"},;
		{"dueamount","0","PRIMARY","1","dueid"},;
		{"dueamount","0","subscrdue","1","subscribid"},;
		{"dueamount","0","subscrdue","2","invoicedate"},;
		{"dueamount","0","subscrdue","3","seqnr"},;
		{"employee","0","PRIMARY","1","empid"},; 
	{"emplacc","0","PRIMARY","1","empid"},; 
	{"emplacc","0","PRIMARY","2","accid"},; 
	{"importlock","0","IMPORTLOCK","1","importfile"},;
		{"importpattern","0","PRIMARY","1","imppattrnid"},;
		{"importtrans","0","PRIMARY","1","imptrid"},;
		{"importtrans","1","transactnr","1","origin"},;
		{"importtrans","1","transactnr","2","transactnr"},;
		{"ipcaccounts","0","PRIMARY","1","ipcaccount"},;
		{"language","0","PRIMARY","1","location"},;
		{"language","0","PRIMARY","2","sentenceen (240)"},;
		{"log","0","PRIMARY","1","logid"},;
		{"log","1","coltime","1","collection"},;
		{"log","1","coltime","2","logtime"},;
		{"mbalance","0","PRIMARY","1","mbalid"},;
		{"mbalance","0","accmonth","1","accid"},;
		{"mbalance","0","accmonth","2","year"},;
		{"mbalance","0","accmonth","3","month"},;
		{"mbalance","0","accmonth","4","currency"},;
		{"member","0","PRIMARY","1","mbrid"},;
		{"member","0","accid","1","accid"},;
		{"member","0","depid","1","depid"},;
		{"member","0","persid","1","persid"},;
		{"member","1","householdid","1","householdid"},;
		{"memberassacc","0","PRIMARY","1","mbrid"},;	
	{"memberassacc","0","PRIMARY","2","accid"},;	
	{"teletrans","0","PRIMARY","1","teletrID"},;
		{"teletrans","0","telecontent","1","bankaccntnbr"},;
		{"teletrans","0","telecontent","2","bookingdate"},;
		{"teletrans","0","telecontent","3","addsub"},;
		{"teletrans","0","telecontent","4","amount"},;
		{"teletrans","0","telecontent","5","contra_bankaccnt"},;
		{"teletrans","0","telecontent","6","contra_name"},;
		{"teletrans","0","telecontent","7","seqnr"},;
		{"teletrans","0","telecontent","8","description (120)"},;
		{"teletrans","1","bankaccntnbr","1","processed"},;
		{"teletrans","1","bankaccntnbr","2","bankaccntnbr"},;
		{"teletrans","1","bankaccntnbr","3","bookingdate"},;
		{"teletrans","1","bankaccntnbr","4","lock_id"},;
		{"teletrans","1","bankaccntnbr","5","lock_time"},;
		{"standingorder","0","PRIMARY","1","stordrid"},;
		{"standingorderline","0","PRIMARY","1","stordrid"},;
		{"standingorderline","0","PRIMARY","2","seqnr"},;
		{"standingorderline","1","STORDLAC","1","accountid"},;
		{"perscod","0","PRIMARY","1","pers_code"},;
		{"perscod","0","ABBRVTN","1","abbrvtn"},;
		{"perscod","1","description","1","description"},;
		{"person","0","PRIMARY","1","persid"},;
		{"person","1","lastname","1","lastname"},;
		{"person","1","lastname","2","firstname"},;
		{"person","1","postalcode","1","postalcode"},;
		{"person","1","EXTERNID_2","1","externid"},;
		{"person_properties","0","PRIMARY","1","id"},;
		{"person_properties","0","NAME","1","name"},;
		{"personbank","0","PRIMARY","1","banknumber"},;
		{"personbank","1","persid","1","persid"},;
		{"persontype","0","PRIMARY","1","id"},;
		{"persontype","0","ABBRVTN","1","abbrvtn"},;
		{"ppcodes","0","PRIMARY","1","ppcode"},;
		{"ppcodes","0","PPNAME","1","ppname"},;
		{"subscription","0","PRIMARY","1","subscribid"},;
		{"subscription","1","personid","1","personid"},;
		{"subscription","1","personid","2","accid"},;
		{"subscription","1","accid","1","accid"},;
		{"subscription","1","INVOICEID","1","invoiceid"},;
		{"telebankpatterns","0","PRIMARY","1","telpatID"},;
		{"telebankpatterns","1","contra_bankaccnt","1","accid"},;
		{"telebankpatterns","1","contra_bankaccnt","2","contra_name"},;
		{"telebankpatterns","1","contra_bankaccnt","3","recdate"},;
		{"titles","0","PRIMARY","1","ID"},;
		{"transaction","0","PRIMARY","1","transid"},;
		{"transaction","0","PRIMARY","2","seqnr"},;
		{"transaction","1","accid","1","accid"},;
		{"transaction","1","accid","2","bfm"},;
		{"transaction","1","accid","3","dat"},;
		{"transaction","1","docid","1","docid"},;
		{"transaction","1","reference","1","reference"},;
		{"transaction","1","transdate","1","dat"},;
		{"transaction","1","transdate","2","transid"},;
		{"transaction","1","person","1","persid"};
		} as array


	// 		{"transaction","1","amountdeb","1","deb"},;
	// 		{"transaction","1","amountcre","1","cre"},;
	// 		{"transaction","1","description","1","description"},;
	
	//  		{"teletrans","0","telecontent","1","bankaccntnbr"},;
	// 		{"teletrans","0","telecontent","2","bookingdate"},;
	// 		{"teletrans","0","telecontent","3","addsub"},;
	// 		{"teletrans","0","telecontent","4","amount"},;
	// 		{"teletrans","0","telecontent","5","kind"},;
	// 		{"teletrans","0","telecontent","6","contra_bankaccnt"},;
	// 		{"teletrans","0","telecontent","7","contra_name"},;
	// 		{"teletrans","0","telecontent","8","budgetcd"},;
	// 		{"teletrans","0","telecontent","9","seqnr"},;
	// 		{"teletrans","0","telecontent","10","description (120)"},;
	local aMyCurTable:=self:aCurTable as array


	
	// add to total collection of columns:
	nTargetPos:=Len(aColumn)+1 
	ASize(aColumn,Len(aColumn)+Len(aColumn2))
	ACopy(aColumn2,aColumn,,,nTargetPos)

	// check database 
	// read current database structure:
	dbname:=AddSlashes(dbname) 
	oSel:=SqlSelect{"SELECT group_concat(lower(TABLE_NAME),',', upper(ENGINE),',', lower(TABLE_COLLATION) SEPARATOR '##') as tablegroup FROM (select TABLE_NAME, ENGINE, TABLE_COLLATION FROM information_schema.TABLES "+;
		"WHERE TABLE_SCHEMA = '"+dbname+"' order by table_name) as gr group by 1=1",oConn}
	if !Empty(oSel:status)
		ErrorBox{self,"Error:"+oSel:ERRINFO:errormessage}:Show()
		break
	endif 
	if oSel:RecCount>0	
		AEval(Split(oSel:tablegroup,'##',true),{|x|AAdd(aMyCurTable,Split(x,','))}) 
	endif
	//read current columns:
	oSel:=SqlSelect{"SELECT group_concat(TABLE_NAME,';', COLUMN_NAME,';', COLUMN_TYPE,';', IS_NULLABLE,';', COLUMN_DEFAULT,';', ExTRA,';', lower(COLLATION_NAME) separator '##') as columngroup "+;
		"from (SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE,  if(COLUMN_DEFAULT IS NULL,'NULL',cast(COLUMN_DEFAULT as char)) as COLUMN_DEFAULT, ExTRA,"+;
		" if(COLLATION_NAME IS NULL,'',COLLATION_NAME) as COLLATION_NAME FROM information_schema.COLUMNS "+;
		"WHERE TABLE_SCHEMA = '"+dbname+"' order by TABLE_NAME,ORDINAL_POSITION) as gr group by 1=1",oConn}
	if !Empty(oSel:status)
		ErrorBox{self,"Error:"+oSel:ERRINFO:errormessage}:Show()
		break
	endif 
	if oSel:RecCount>0 
		AEval(Split(oSel:columngroup,'##',true),{|x|AAdd(aCurColumn,Split(x,';',true))})
		// adapt aCurColumn: 
		//                   1          2          3            4            5           6
		// aCurColumn: {table_name,COLUMN_NAME,COLUMN_TYPE,IS_NULLABLE,COLUMN_DEFAULT,extra,collation_name},...  
		j:=1
		for i:=1 to Len(aCurTable)
			cTableCollation:=aCurTable[i,3] 
			cTable:=aCurTable[i,1]
			j:=AScan(aCurColumn,{|x|x[1]==cTable})
			do while j>0 .and. j<Len(aCurColumn) .and.aCurColumn[j,1]==cTable
				if Empty(aCurColumn[j,6])
					if !Empty(aCurColumn[j,7]).and. !aCurColumn[j,7]==cTableCollation
						aCurColumn[j,6]:='collate '+aCurColumn[j,7]
					endif
				endif
				ASize(aCurColumn[j],6)  // remove collation column
				j++
			enddo							
		next
	endif
	// read current indexes:
	oSel:=SqlSelect{"SELECT group_concat(TABLE_NAME,',',NON_UNIQUE,',',INDEX_NAME,',',SEQ_IN_INDEX,',',COLUMN_NAME separator '##' ) as indexgroup "+;
		"from (select TABLE_NAME,cast(NON_UNIQUE as char) as NON_UNIQUE,INDEX_NAME,cast(SEQ_IN_INDEX as char) as SEQ_IN_INDEX,concat(COLUMN_NAME,if(SUB_PART is null,'',concat(' (',cast(SUB_PART as char),')'))) as COLUMN_NAME "+;
		"from information_schema.statistics where TABLE_SCHEMA='"+dbname+"') as gr group by 1=1",oConn}
	if !Empty(oSel:status)
		ErrorBox{self,"Error:"+oSel:ERRINFO:errormessage}:Show()
		break
	endif
	
	if oSel:RecCount>0
		AEval(Split(oSel:indexgroup,'##',true),{|x|AAdd(aCurIndex,Split(x,',',true))})
	endif
	// add archive files to aTable: 
	nTbl:=AScan(aTable,{|x|x[1]=='transaction'})
	nSourceStart:=1
	do while nSourceStart>0
		nSourceStart:=AScan(aCurTable,{|x|Lower(x[1])='tr'.and.Len(Lower(x[1]))=8.and. isnum(SubStr(Lower(x[1]),3))},nSourceStart)
		if nSourceStart>0
			AAdd(aTable,{aCurTable[nSourceStart,1],aTable[nTbl,2],aTable[nTbl,3]})
			nSourceStart++
		else
			exit
		endif
	enddo

	// compare  current with required structure: 
	for i:=1 to Len(aTable)
		cTable:=Lower(aTable[i,1])
		
		if (j:=AScan(aCurTable,{|x|Lower(x[1])==cTable}))==0 
			self:create_table(cTable,"",aTable[i,2],aTable[i,3],aColumn,aIndex)
		else
			// compare current db engine and collation with required: 
			if Upper(aTable[i,2])<>aCurTable[j,2] .or. aTable[i,3]<>aCurTable[j,3]
				// alter statement
				SQLStatement{"ALTER TABLE "+aTable[i,1]+iif(Upper(aTable[i,2])==aCurTable[j,2],""," ENGINE = "+aTable[i,2])+iif(aTable[i,3]==aCurTable[j,3],""," collate="+aTable[i,3]),oConn}:Execute()
			endif
			//compare current columns with required columns
			// and compare current indexes with required:
			aRequiredCol:={}
			aCurrentCol:={}
			aRequiredIndex:={} 
			aCurrentIndex:={}
			cTableCol:=cTable
			if Lower(cTable)='tr'.and.len(cTable)=8.and. isnum(substr(ctable,3))
				cTableCol:='transaction'
			endif

			// place required columns and current columns of cTAble in arrays
			nSourceStart:=AScan(aColumn,{|x|x[1]==cTableCol})
			if nSourceStart>0
				nSourceEnd:=AScan(aColumn,{|x|!x[1] == cTableCol},nSourceStart)
				if nSourceEnd=0
					nSourceEnd:=Len(aColumn)
				else
					nSourceEnd--
				endif
				ASize(aRequiredCol,nSourceEnd+1-nSourceStart)
				ACopy(aColumn,aRequiredCol,nSourceStart,nSourceEnd+1-nSourceStart)
			endif
			nSourceStart:=AScan(aCurColumn,{|x|x[1]==cTable})
			if nSourceStart>0
				nSourceEnd:=AScan(aCurColumn,{|x|!x[1] == cTable},nSourceStart)
				if nSourceEnd=0
					nSourceEnd:=Len(aCurColumn)
				else
					nSourceEnd--
				endif
				ASize(aCurrentCol,nSourceEnd+1-nSourceStart)
				ACopy(aCurColumn,aCurrentCol,nSourceStart,nSourceEnd+1-nSourceStart)
			endif
			// place required indexes and current indexes of cTAble in arrays
			nSourceStart:=AScan(aIndex,{|x|x[1]==cTableCol})
			if nSourceStart>0
				nSourceEnd:=AScan(aIndex,{|x|!x[1] == cTableCol},nSourceStart)
				if nSourceEnd=0
					nSourceEnd:=Len(aIndex)
				else
					nSourceEnd--
				endif
				ASize(aRequiredIndex,nSourceEnd+1-nSourceStart)
				ACopy(aIndex,aRequiredIndex,nSourceStart,nSourceEnd+1-nSourceStart)
			endif
			nSourceStart:=AScan(aCurIndex,{|x|x[1]==cTable})
			if nSourceStart>0
				nSourceEnd:=AScan(aCurIndex,{|x|!x[1] == cTable},nSourceStart)
				if nSourceEnd=0
					nSourceEnd:=Len(aCurIndex)
				else
					nSourceEnd--
				endif
				ASize(aCurrentIndex,nSourceEnd+1-nSourceStart)
				ACopy(aCurIndex,aCurrentIndex,nSourceStart,nSourceEnd+1-nSourceStart)
			endif

			self:SyncColumns(aRequiredCol,aCurrentCol,cTable,aRequiredIndex,aCurrentIndex)
		endif 	
	next                                               

	// ensure ImportLock has required record:
	if SqlSelect{"select importfile from importlock where `importfile`='telelock'",oConn}:RecCount<1
		SQLStatement{"insert into importlock set importfile='telelock'",oConn}:Execute()
	endif
	if SqlSelect{"select importfile from importlock where importfile='batchlock'",oConn}:RecCount<1
		SQLStatement{"insert into importlock set importfile='batchlock'",oConn}:Execute()
	endif 
	// fill tables from old database: 
	if self:lNewDb
		// reset strict mode for conversion:
		oSel:=SqlSelect{"SELECT @@SESSION.sql_mode as currsqlmode",oConn}
		if oSel:RecCount>0
			currentSQLMode:=oSel:currsqlmode
		endif
		oStmnt:=SQLStatement{"SET SESSION sql_mode='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'",oConn}
		oStmnt:Execute() 
		// convert:
		self:ConvertDBFSQL(aColumn,aIndex)
		oStmnt:=SQLStatement{"SET SESSION sql_mode='"+currentSQLMode+"'",oConn}
		oStmnt:Execute()
	endif
	return
Method Matchunequalgaps(aStatReq as array,aStatCur as array,aReqColumn as array,aCurColumn as array,nStartCurrent as int,nEndCurrent as int,nStartRequired as int,nEndRequired as int) as int class Initialize
	// score each possible mapping of columns within required gap on columns of current gap and map column with highest score
	local aScore:={} as array  //{req col,cur col,score value},... 
	local iReq,iCurr,nScore,nPosHookReq,nPosHookCurr,nDisposition,i as int
	if nStartRequired<1
		nStartRequired:=1
	endif
	if nEndRequired<1
		nEndRequired:=Len(aStatReq)
	endif
	if nStartCurrent<1
		nStartCurrent:=1
	endif
	// if Empty(nEndCurrent)
	// 	nEndCurrent:=Len(aStatCur)
	// endif

	nDisposition:=nStartRequired-nStartCurrent
	if nEndCurrent>=nStartCurrent      // gap in current columns
		// Table name, Field,Type,Null,Default,Extra
		for iReq:=nStartRequired to nEndRequired
			for iCurr:=nStartCurrent to nEndCurrent
				nScore:=0
				if aReqColumn[iReq,3]== aCurColumn[iCurr,3]     // type
					nScore+=50
				else
					nPosHookReq:=At('(',aReqColumn[iReq,3])
					nPosHookCurr:=At('(',aCurColumn[iCurr,3])
					if nPosHookReq>0 .and.nPosHookCurr>0
						// compare type without length  
						if SubStr(aReqColumn[iReq,3],1,nPosHookReq)==SubStr( aCurColumn[iCurr,3],1,nPosHookCurr)
							nScore+=30
						else
						// compare type without length  and independent of 'var'
							if StrTran(SubStr(aReqColumn[iReq,3],1,nPosHookReq),'var','',1,1)==StrTran(SubStr( aCurColumn[iCurr,3],1,nPosHookCurr),'var','',1,1)
								nScore+=25
							endif
						endif
					endif
				endif
				if nScore>0
					// compare other specifications:
					if aReqColumn[iReq,4]== aCurColumn[iCurr,4]  //NULL
						nScore+=10
					endif
					if aReqColumn[iReq,5]== aCurColumn[iCurr,5]  //default
						nScore+=10
					endif
					if aReqColumn[iReq,6]== aCurColumn[iCurr,6]  //extra (auto_increment
						nScore+=20
					endif
					if iReq==iCurr+nDisposition  //same ordinal position?
						nScore+=10
					endif
					AAdd(aScore,{iReq,iCurr,nScore})
				endif
			next
		next
		ASort(aScore,,,{|x,y|x[3]>=y[3]})   // sort in descending score value order
		// column mappings with highest ranking are the best:
		for i:=1 to Len(aScore)
			if Empty(aStatCur[aScore[i,2]]) .and.Empty(aStatReq[aScore[i,1],1])
				aStatReq[aScore[i,1]]:={'r',aScore[i,2]}
				aStatCur[aScore[i,2]]:='x'
			endif
		next 
	endif
	// Rest of required apparently added:
	for iReq:=nStartRequired to nEndRequired
		if Empty(aStatReq[iReq,1])
			aStatReq[iReq]:={'a',0}
		endif
	next
	return nEndRequired

method RenameField(dbasename as string,fieldname as string) as string class Initialize 
// convert fieldname
local cOldname:=Upper(FieldName),cDbName:=Lower(dbasename) as string 
local nPos as int
local aTransl:={;   //dbasename, dbasecolumn,new columnname
{"accbalyr","REK","accid"},;
{"account","REK","accid"},;
{"account","OMS","description"},;
{"account","NUM","balitemid"},; 
{"account","ABP","subscriptionprice"},; 
{"article","AR1","articleid"},;
{"article","OMS","description"},; 
{"article","ANTI","purchaseqty"},;
{"article","INKP","purchaseprice"},;
{"article","ANT","soldqty"},;
{"article","VERP","sellingprice"},;
{"article","LVD","datelastsold"},;
{"article","TOTV","soldamount"},;
{"article","REKOPBR","accountyield"},;
{"article","LEV","supplier"},;
{"article","REKVOORR","accountstock"},;
{"article","REKINKP","accountpurchase"},;
{"balitem","NUM","balitemid"},;
{"balitem","KOPTEKST","heading"},;
{"balitem","VOETTEKST","footer"},;
{"balitem","HFDRBRNUM","balitemidparent"},;
{"balitem","SOORT","category"},; 
{"bankacc","REK","accid"},;
{"bankacc","GIFTENIND","usedforgifts"},;
{"bankacc","BANKNUMMER","banknumber"},; 
{"bankorder","DESCRPTION","description"},;
{"budget","REK","accid"},;
{"departmt","CLN","persid"},;
{"departmt","CLN2","persid2"},;
{'distrins',"REK","mbrid"},;
{"dueamnt","REK","accid"},;
{"dueamnt","SOORT","category"},;
{"dueamnt","CLN","persid"},;
{"dueamnt","FAKTDAT","invoicedate"},;
{"dueamnt","VOLGNR","seqnr"},;
{"dueamnt","BEDRAGFAKT","amountinvoice"},;
{"dueamnt","BEDRAGONTV","amountrecvd"},;
{"dueamnt","DATLTSAANM","datelstreminder"},;
{"dueamnt","AANTRAPPEL","remindercnt"},;
{"employee","CLN","persid"},;
{"imprttrs","INDVERW","processed"},;
{"imprttrs","BST","docid"},;
{"mailcd","OMS","description"},;
{"mbalance","REK","accid"},;
{"member","CLN","persid"},;
{"member","REK","accid"},; 
{"member","HBN","householdid"},; 
{"mutgiro","GIRONUMMER","bankaccntnbr"},;
{"mutgiro","BOEKDATUM","bookingdate"},;
{"mutgiro","VOLGNUMMER","seqnr"},;
{"mutgiro","TEGENGIRO","contra_bankaccnt"},;
{"mutgiro","MUTSOORT","kind"},;
{"mutgiro","NAAM_TEGNR","contra_name"},;
{"mutgiro","BEDRAG","amount"},;
{"mutgiro","CODE_AF_BY","addsub"},;
{"mutgiro","OMS","description"},;
{"mutgiro","IND_VERW","processed"},;
{"mutgiro","CLN","persid"},;
{"periorec","BOEKDAG","day"},;
{"periorec","DATLTSBOEK","lstrecording"},;
{"periorec","BST","docid"},;
{"periorec","PERIODE","period"},;
{"periorec","CLN","persid"},;
{"person","CLN","persid"},;
{"person","TAV","attention"},; 
{"person","TIT","title"},;  
{"person","TEL1","telbusiness"},;  
{"person","TEL2","telhome"},;  
{"person","VRN","firstname"},; 
{"person","NA1","lastname"},; 
{"person","NA2","initials"},; 
{"person","NA3","nameext"},; 
{"person","POS","postalcode"},; 
{"person","PLA","city"},; 
{"person","AD1","address"},; 
{"person","LAN","country"},; 
{"person","HISN","prefix"},; 
{"person","OPM","remarks"},; 
{"person","COD","mailingcodes"},; 
{"person","BDAT","creationdate"},; 
{"person","MUTD","alterdate"},; 
{"person","DLG","datelastgift"},; 
{"person","BIRTHDAT","birthdate"},; 
{"persbank","CLN","persid"},;
{"persbank","GIRONR","banknumber"},;
{"persbank","GIRONR","banknumber"},;
{"subscrpt","P04","begindate"},;
{"subscrpt","P06","duedate"},;
{"subscrpt","P07","term"},;
{"subscrpt","RLN","personid"},;
{"subscrpt","P01N","accid"},;
{"subscrpt","P08","amount"},;
{"subscrpt","P13","lstchange"},;
{"subscrpt","SOORT","category"},;
{"sysparms","JAARAFSL","yearclosed"},;
{"sysparms","HB_LTS_MND","lstreportmonth"},;
{"sysparms","KRUISPSTN","crossaccnt"},;
{"sysparms","INHDHAS","assmntfield"},;
{"sysparms","INHDINT","assmntint"},;
{"sysparms","INHDKNTR","assmntoffc"},;
{"sysparms","INHKNTRL","withldoffl"},;  
{"sysparms","INHKNTRM","withldoffm"},;
{"sysparms","INHKNTRH","withldoffh"},;
{"sysparms","HBLAND","countryown"},;
{"sysparms","TRANSAKTNR","transid"},;
{"teleptrn","TEGENGIRO","contra_bankaccnt"},;
{"teleptrn","MUTSOORT","kind"},;
{"teleptrn","NAAM_TEGNR","contra_name"},;
{"teleptrn","OMS","description"},;
{"teleptrn","BEDRAG","amount"},;
{"teleptrn","CODE_AF_BY","addsub"},;
{"teleptrn","REK","accid"},;
{"tr","REK","accid"},;
{"tr","OMS","description"},;
{"tr","CLN","persid"},;
{"tr","BST","docid"},;
{"tr","TRANSAKTNR","transid"};
} as array
nPos:=AScan(aTransl,{|x|cDbName=x[1].and.x[2]==cOldname})
if nPos>0
	return aTransl[nPos,3]
else
	return cOldname
endif

method SyncColumns(aReqColumn as array, aCurColumn as array,cTableName as string,aReqIndex as array,aCurIndex as array) as void pascal class Initialize
	// compare required columns of a table with current ones and alter atble if needed
	// aReqColumn: required columns
	// aCurColumn: current columns
	// cTableName: name of the table
	local lSkip,lError as logic
	local nPosReq,nPosCur,i,j,nLenReq,nLenCur as int
	local aStatReq,aStatCur as array      // to keep track of comparisons; 
	//													aStatReq: {{status (c:changed spec/ r:renamed/=: equal), ordinal position in current table}, ...}
	//													aStatCur: { status (x: processed), ..}  
	local nPosCurbefore as int // position of corresponding current item before this required one
	local nPosCurAfter  as int // position of corresponding current item after this required one
	local cReqname,cIndex as string 
	local cStatement,cDropIndex,cAddIndex,c,Sp:=Space(1),cvalues as string 
	local aColName:={} as array
	local oStmnt as SQLStatement
	local oSel as SQLSelect                 // for correcting teletrans
	local CurDate as date, CurSeqnr,SubSeqnr as int  // for correcting teletrans
	local avalues:={} as array  // array for converting values : {{fieldname,new value},...}
	nLenReq:=ALen(aReqColumn)
	nLenCur:=ALen(aCurColumn)
	aStatReq:=AReplicate({'',0},nLenReq)
	aStatCur:=AReplicate('',nLenCur) 
	// first search for columns with changed specifications:  

	for nPosReq:=1 to nLenReq
		cReqname:=Lower(aReqColumn[nPosReq,2])       // first position is table name, second column name
		nPosCur:=AScan(aCurColumn,{|x|Lower(x[2])==cReqname})
		if nPosCur>0    // required column exists in current table?
			// compare specifications between required and current:
			for i:=3 to 6
				if !Lower(aReqColumn[nPosReq,i])==Lower(aCurColumn[nPosCur,i])
					if i=5       // default value
						if IsDigit(aReqColumn[nPosReq,5]).and.IsDigit(aCurColumn[nPosCur,5])
							if Val(aReqColumn[nPosReq,5])=Val(aCurColumn[nPosCur,5])
								// ignore zeroes behind decimal point 
								loop
							endif
						else
							if Upper(aReqColumn[nPosReq,4])=='NO' .and.Empty(aReqColumn[nPosReq,5]).and.Upper(aCurColumn[nPosCur,5])=='NULL'
								// ignore empty and null 
								loop
							endif
						endif
					endif
					aStatReq[nPosReq]:={"c",nPosCur} // specifications changed
					exit
				endif
			next
			if Empty(aStatReq[nPosReq,1])
				aStatReq[nPosReq]:={"=",nPosCur}   // equal to current
			endif
			aStatCur[nPosCur]:="x"  // compared 
		else
			// not found: either new or renamed
		endif
	next 
	// check remaining required columns if they have been renamed or added:
	nPosCurbefore:=0
	nPosCurAfter:=0
	if cTableName=="sysparms"
		cTableName:=cTableName
	endif
	for nPosReq :=1 to nLenReq
		if !Empty(aStatReq[nPosReq,1])
			// allready recognised:
			nPosCurbefore:=aStatReq[nPosReq,2]
			loop
		endif
		nPosCurAfter:=0
		i:=0
		// search position of next recognised required column:
		i:=AScan(aStatReq,{|x|x[2]>0},nPosReq)
		if i>0
			nPosCurAfter:=aStatReq[i,2]
		else
			nPosCurAfter:=nLenCur+1
		endif
		nPosReq:=self:Matchunequalgaps(aStatReq,aStatCur,aReqColumn,aCurColumn,nPosCurbefore+1,nPosCurAfter-1,nPosReq,i-1)
	next
	nPosCur:=0
	do while nPosCur < nLenCur
		// check remaining current deleted:
		nPosCur:=ascan(aStatCur,{|x|empty(x)},nPosCur+1)
		if nPosCur=0
			exit
		endif
		cStatement+=iif(Empty(cStatement),'',', ')+"drop column "+sIdentChar+aCurColumn[nPosCur,2]+sIdentChar
	enddo
	// compose other changes: 
	for nPosReq:=1 to nLenReq
		if aStatReq[nPosReq,1]="r"
			// renamed:
			cStatement+=iif(Empty(cStatement),'',', ')+"change "+sIdentChar+aCurColumn[aStatReq[nPosReq,2],2]+sIdentChar+' '
		elseif aStatReq[nPosReq,1]="="
			loop
		elseif aStatReq[nPosReq,1]="a"
			// added:
			cStatement+=iif(Empty(cStatement),'',', ')+"add "
		elseif aStatReq[nPosReq,1]="c"
			// modified:
			cStatement+=iif(Empty(cStatement),'',', ')+"modify "
		else
			loop
		endif
		// Table name, Field,Type,Null,Default,Extra 
		cStatement+=sIdentChar+aReqColumn[nPosReq,2]+sIdentChar+' '+aReqColumn[nPosReq,3]+' '+iif(Upper(aReqColumn[nPosReq,4])=="NO","NOT NULL","NULL")+;
			iif(AtC('text',aReqColumn[nPosReq,3])>0,'',iif(Upper(aReqColumn[nPosReq,5])=="NULL",iif(Upper(aReqColumn[nPosReq,4])=="NO",""," DEFAULT NULL")," DEFAULT '"+aReqColumn[nPosReq,5]+"'"))+;
			" "+aReqColumn[nPosReq,6]+;
			iif(aStatReq[nPosReq,1]="a"," "+iif(nPosReq=1,"FIRST","AFTER "+aReqColumn[nPosReq-1,2]),"")
	next
	//
	//====================================  indexes  ===================================
	//
	// Check if indexes contain new names: 
	nLenReq:=ALen(aReqIndex)
	nLenCur:=ALen(aCurIndex)
	aStatReq:=AReplicate({'',0},nLenReq)
	aStatCur:=AReplicate('',nLenCur) 
	for nPosReq:=1 to nLenReq   
		// Table,Non_unique,Key_name,Seq_in_index,Column_name
		cReqname:=Lower(aReqIndex[nPosReq,5])       // first position is table name, fith column name
		cReqname:=Split(cReqname,'(',true)[1]  // not key length 
		if ascan(aReqColumn,{|x|lower(x[2])==cReqname})=0
			ErrorBox{,"Index '"+aReqIndex[nPosReq,3]+"' of table '"+cTableName+"' contains unknown column name '"+cReqname+"'"}:show()
			break
			return
		endif
	next
	// compare required indexes with current indexes:
	for nPosReq:=1 to nLenReq   
		// 		cIndex:=Lower(aReqIndex[nPosReq,3])
		// 		cReqname:=Lower(aReqIndex[nPosReq,5])
		nPosCur:=AScan(aCurIndex,{|x|Lower(x[3])==Lower(aReqIndex[nPosReq,3]).and.Lower(x[5])==Lower(aReqIndex[nPosReq,5])})
		if nPosCur>0
			// compare other specifications:
			if Lower(aReqIndex[nPosReq,2])==Lower(aCurIndex[nPosCur,2]) .and.;
					lower(aReqIndex[nPosReq,4])==lower(aCurIndex[nPosCur,4])
				aStatReq[nPosReq]:={"=",nPosCur}
				aStatCur[nPosCur]:="x"
			endif
		endif
	next
	// drop old indexes if changed: 
	nPosCur:=1
	nPosCur:=AScan(aStatCur,{|x|Empty(x)},nPosCur)
	cIndex:=""
	cDropIndex:="" 
	cAddIndex:=""
	// first missing curindex lines:
	do while nPosCur>0
		if !aCurIndex[nPosCur,3]==cIndex 
			cIndex:=aCurIndex[nPosCur,3]
			if AtC(cIndex,cDropIndex)=0     // not yet dropped?
				cDropIndex+=iif(Empty(cDropIndex),'',', ')+"drop"+Sp+iif(cIndex=="PRIMARY","PRIMARY KEY",'INDEX '+sIdentChar+cIndex+sIdentChar)
				if (nPosReq:=AScan(aReqIndex,{|x|x[3]==cIndex}))>0 .and. AtC(cIndex,cAddIndex)=0
					aStatCur[nPosCur]:='x'  // processed
					// add to indexes to be added:
					aColName:=Split(aReqIndex[nPosReq,5],'(',true)
					cAddIndex+=iif(Empty(cAddIndex),'',', ')+"add"+Sp+iif(cIndex=="PRIMARY","PRIMARY"+Sp,iif(aReqIndex[nPosReq,2]="0","UNIQUE"+Sp,""))+;
						"KEY"+Sp+iif(cIndex=="PRIMARY","",sIdentChar+aReqIndex[nPosReq,3]+sIdentChar+Sp)+"("+sIdentChar+AllTrim(aColName[1])+sIdentChar  +iif(Len(aColName)>1,'('+aColName[2],'') 
					aStatReq[nPosCur,1]='c'  // changed
					nPosReq++		
					do	while	nPosReq<=nLenReq .and. aReqIndex[nPosReq,3]==cIndex 
						aStatReq[nPosCur,1]:='c'  // changed
						aColName:=Split(aReqIndex[nPosReq,5],'(',true)
						cAddIndex+="," +sIdentChar+AllTrim(aColName[1])+sIdentChar +iif(Len(aColName)>1,'('+aColName[2],'')
						nPosReq++
					enddo
					cAddIndex+=")"+Sp
				endif
			endif
		endif
		if nPosCur< nLenCur
			nPosCur:=AScan(aStatCur,{|x|Empty(x)},nPosCur+1)
		else
			exit
		endif
	enddo 

	// add new or changed indexes:
	nPosReq:=1
	nPosReq:=AScan(aStatReq,{|x|Empty(x[1])},nPosReq)
	cIndex:=""
	do while nPosReq>0 .and. nPosReq<=nLenReq
		cIndex:=aReqIndex[nPosReq,3] 
		//	process all	lines	of	this index
// 		nPosReq:=AScan(aReqIndex,{|x|x[3]==cIndex})
// 		if nPosReq=0
// 			exit
// 		endif
		if AtC(cIndex,cAddIndex)=0 
			if (nPosCur:=AScan(aCurIndex,{|x|x[3]==cIndex}))>0 .and. AtC(cIndex,cDropIndex)=0
				// add to drop index
				cDropIndex+=iif(Empty(cDropIndex),'',', ')+"drop"+Sp+iif(cIndex=="PRIMARY","PRIMARY KEY",'INDEX '+sIdentChar+cIndex+sIdentChar)
				aStatCur[nPosCur]:='x'  // processed
			endif
			aColName:=Split(aReqIndex[nPosReq,5],'(',true)
			cAddIndex+=iif(Empty(cAddIndex),'',', ')+"add"+Sp+iif(cIndex=="PRIMARY","PRIMARY"+Sp,iif(aReqIndex[nPosReq,2]="0","UNIQUE"+Sp,""))+;
				"KEY"+Sp+iif(cIndex=="PRIMARY","",sIdentChar+aReqIndex[nPosReq,3]+sIdentChar+Sp)+"("+sIdentChar+AllTrim(aColName[1])+sIdentChar  +iif(Len(aColName)>1,'('+aColName[2],'')
			nPosReq++		
			do	while	nPosReq<=nLenReq .and. aReqIndex[nPosReq,3]==cIndex
				aStatReq[nPosReq,1]='c'  // changed
				aColName:=Split(aReqIndex[nPosReq,5],'(',true)
				cAddIndex+="," +sIdentChar+AllTrim(aColName[1])+sIdentChar  +iif(Len(aColName)>1,'('+aColName[2],'')
				nPosReq++
			enddo
			cAddIndex+=")"+Sp 
		endif
		nPosReq:=AScan(aStatReq,{|x|Empty(x[1])},nPosReq+1)
	enddo
	if !Empty(cDropIndex)
		cStatement+=iif(Empty(cStatement),'',', ')+ cDropIndex
	endif
	if !Empty(cAddIndex)
		cStatement+=iif(Empty(cStatement),'',', ')+ cAddIndex
	endif
 
	if !Empty(cStatement) 
		oMainWindow:STATUSMESSAGE("Reformating table "+cTableName+", moment please...")
// 		if cIndex=='telecontent'
// 			// make each line in teletrans unique:
// 			oSel:=SqlSelect{'select teletrid,cast(bookingdate as date) as bookingdate,seqnr from teletrans order by bankaccntnbr,seqnr,bookingdate,teletrid',oConn}
// 			if oSel:RecCount>0
// 				do while !oSel:EoF
// 					if !oSel:bookingdate=CurDate .or.!oSel:seqnr=CurSeqnr
// 						CurDate:=oSel:bookingdate
// 						CurSeqnr:=oSel:seqnr
// 						SubSeqnr:=0
// 					endif
// 					SubSeqnr++
// 					if SubSeqnr>1
// 						AAdd(avalues,{Str(oSel:teletrid,-1),Str(CurSeqnr,-1)+Str(SubSeqnr,-1)})
// 					endif      
// 					oSel:Skip()
// 				enddo
// 			endif
// 		endif
// 		if cTableName=='sysparms'
// 			// Table name, Field,Type,Null,Default,Extra 
// 			if AScan(aCurColumn,{|x|x[2]=='banknbrcol'.and. !Left(x[3],3)=='int'})>0 .and.AScan(aReqColumn,{|x|x[2]=='banknbrcol'.and. Left(x[3],3)='int'})>0
// 				// select old values and new values for banknbrcol:
// 				oSel:=SqlSelect{'select cast(bankid as char) as bankid from sysparms s,bankaccount b where s.banknbrcol>"" and b.banknumber=s.banknbrcol',oConn}
// 				if oSel:RecCount>0
// 					AAdd(avalues,{'banknbrcol',oSel:bankid}) 
// 				else
// 					AAdd(avalues,{'banknbrcol','0'}) 					
// 				endif
// 			else
// 				AAdd(avalues,{'banknbrcol','0'}) 					
// 			endif
// 			if AScan(aCurColumn,{|x|x[2]=='banknbrcre'.and. !Left(x[3],3)=='int'})>0 .and.AScan(aReqColumn,{|x|x[2]=='banknbrcre'.and. Left(x[3],3)=='int'})>0
// 				// select od values and new values for banknbrcol:
// 				oSel:=SqlSelect{'select cast(bankid as char) as bankid from sysparms s,bankaccount b where banknbrcre>"" and b.banknumber=s.banknbrcre',oConn}
// 				if oSel:RecCount>0
// 					AAdd(avalues,{'banknbrcre',oSel:bankid})
// 				else
// 					AAdd(avalues,{'banknbrcre','0'}) 					
// 				endif
// 			else
// 				AAdd(avalues,{'banknbrcre','0'}) 					
// 			endif
// 		endif
		SQLStatement{"start transaction",oConn}:Execute() 
		lError:=false 
// 		if cTableName=='sysparms' .and. Len(avalues)>0
// 			// fill new values: 
// 			cvalues:="set "
// 			for i:=1 to Len(avalues)
// 				cvalues+=avalues[i,1]+'="'+avalues[i,2]+'"'+iif(i<Len(avalues),',','')
// 			next
// 			oStmnt:=SQLStatement{'update sysparms '+cvalues,oConn}
// 			oStmnt:Execute()
// 			if!Empty(oStmnt:Status)
// 				SQLStatement{"rollback",oConn}:execute()
// 				LogEvent(self,"Could not reformat table "+cTableName+CRLF+"statement:"+oStmnt:SQLString+CRLF+"error:"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
// 				lError:=true
// 			endif
// 		endif 
// 		if cIndex=='telecontent' .and. Len(avalues)>0
// 			// correct teletrans to make each line unique	
// 			oStmnt:=SQLStatement{'insert into teletrans (teletrid,seqnr) values '+Implode(avalues,'","')+;
// 				" ON DUPLICATE KEY UPDATE seqnr=values(seqnr) ",oConn}
// 			oStmnt:execute()
// 			if!Empty(oStmnt:Status)
// 				SQLStatement{"rollback",oConn}:execute()
// 				LogEvent(self,"Could not reformat table "+cTableName+CRLF+"statement:"+oStmnt:SQLString+CRLF+"error:"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
// 				lError:=true
// 			endif
// 		endif
		if !lError
			oStmnt:=SQLStatement{'alter table'+Sp+cTableName+'	'+cStatement,oConn} 
			oStmnt:execute() 
			if	!Empty(oStmnt:Status)
				SQLStatement{"rollback",oConn}:execute()
				LogEvent(self,"Could	not reformat table "+cTableName+CRLF+"statement:"+oStmnt:SQLString+CRLF+"error:"+oStmnt:ErrInfo:ErrorMessage,"LogErrors")
			else
				SQLStatement{"commit",oConn}:execute()
				LogEvent(self,'Table '+cTableName+"	reformated with:"+oStmnt:SQLString,"loginfo")
			endif	
		endif
		oMainWindow:STATUSMESSAGE(Space(80))
		
	endif			

	return
	
function unpersonalize() 
// tool to unpersonalize a database with single account member
	local aPersid,aPersidOrg,aAddr as array // array with persids of non-member persons
	local oSel as SQLSelect
	local oStmnt as SQLStatement
	local i as int 
	oMainWindow:Pointer :=Pointer{POINTERHOURGLASS}
	// find all addresses of non-member persons in some strange order: 
	SQLStatement{"set autocommit=0",oConn}:Execute()
	SQLStatement{'lock tables `account` write,`member` read,`person` write',oConn}:Execute()     // alphabetic order
	
	oSel:=SqlSelect{"select persid,address from person where not exists (select persid from member where member.persid=person.persid) order by attention,lastname desc,title",oConn}
	oSel:Execute()
	aAddr:=oSel:GetLookupTable(5000,#persid,#address) 
	// find all datelastgift from non-member persons in another strange order
	oSel:=SqlSelect{"select persid,cast(datelastgift as date) as datelastgift from person where not exists (select persid from member where member.persid=person.persid) order by alterdate,address desc,initials",oConn}
	oSel:Execute()
	if oSel:reccount>0
		aPersid:=oSel:GetLookupTable(5000,#persid,#datelastgift) 
		AEvalA(aPersid,{|x|x:={x[1],iif(Empty(x[2]),null_date,x[2])}})
		aPersidOrg:=AClone(aPersid) 
		AEvalA(aPersidOrg,{|x|x:=x[1]-10000})
		ASort(aPersidOrg)                                 
		// reassign persids:
		oStmnt:=SQLStatement{"update person set persid=persid-10000 where persid in ("+Implode(aPersid,',',,,1)+")",oConn}
		oStmnt:Execute() 
		if oStmnt:NumSuccessfulRows<>Len(aPersid)
			ErrorBox{,oStmnt:errinfo:errormessage+CRLF+oStmnt:sqlstring}:show()
			SQLStatement{"Rollback",oConn}
			SQLStatement{"set autocommit=1",oConn}:Execute()
			SQLStatement{'unlock tables',oConn}:Execute()
			return
		endif
		
		for i:=1 to Len(aPersidOrg)
			oStmnt:=SQLStatement{"update person set persid="+Str(aPersid[i,1],-1)+",datelastgift='"+SQLdate(aPersid[i,2])+;
				"',address='"+AddSlashes(aAddr[i,2])+"' where persid="+Str(aPersidOrg[i],-1),oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				ErrorBox{,oStmnt:errinfo:errormessage+CRLF+oStmnt:sqlstring}:show()
				SQLStatement{"Rollback",oConn}
				SQLStatement{"set autocommit=1",oConn}:Execute()
				SQLStatement{'unlock tables',oConn}:Execute()
				return
			endif
			oMainWindow:STATUSMESSAGE("updating persons "+Str(i,-1))
		next 
	endif
	
	// find all addresses of own member persons in some strange order: 
	aPersid:={}
	aPersidOrg:={}
	aAddr:={}  
	oSel:=SqlSelect{"select persid,address from person where exists (select persid from member where member.persid=person.persid and homepp='"+sEntity+"' and co='M' ) order by attention,lastname desc,title",oConn}
	oSel:Execute()
	aAddr:=oSel:GetLookupTable(5000,#persid,#address) 
	// find all datelastgift from SAF member persons in another strange order
	oSel:=SqlSelect{"select persid,cast(datelastgift as date) as datelastgift from person where exists (select persid from member where member.persid=person.persid and homepp='"+sEntity+"' and co='M') order by alterdate,address desc,initials",oConn}
	oSel:Execute()
	if oSel:reccount>0
		aPersid:=oSel:GetLookupTable(5000,#persid,#datelastgift)
		AEvalA(aPersid,{|x|x:={x[1],iif(Empty(x[2]),null_date,x[2])}})
		aPersidOrg:=AClone(aPersid) 
		AEvalA(aPersidOrg,{|x|x:=x[1]-10000})
		ASort(aPersidOrg)
		// reassign persids:
		SQLStatement{"update person set persid=persid-10000 where persid in ("+Implode(aPersid,',',,,1)+")",oConn}:Execute()
		for i:=1 to Len(aPersidOrg)
			oStmnt:=SQLStatement{"update person set persid="+Str(aPersid[i,1],-1)+",datelastgift='"+SQLdate(aPersid[i,2])+;
				"',address='"+AddSlashes(aAddr[i,2])+"' where persid="+Str(aPersidOrg[i],-1),oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				ErrorBox{,oStmnt:errinfo:errormessage+CRLF+oStmnt:sqlstring}:show()
				SQLStatement{"rollback",oConn}
				SQLStatement{"set autocommit=1",oConn}:Execute()
				SQLStatement{'unlock tables',oConn}:Execute()
				return
			endif
			oMainWindow:STATUSMESSAGE("updating persons "+Str(i,-1))
		next 
	endif 
	
	// find all addresses of non-own-member persons in some strange order:   
	aPersid:={}
	aPersidOrg:={}
	aAddr:={}  
	oSel:=SqlSelect{"select persid,address from person where exists (select persid from member where member.persid=person.persid and homepp<>'"+sEntity+"' and co='M' ) order by attention,lastname desc,title",oConn}
	oSel:Execute()
	aAddr:=oSel:GetLookupTable(5000,#persid,#address) 
	// find all datelastgift from non-SAF-member persons in another strange order
	oSel:=SqlSelect{"select persid,cast(datelastgift as date) as datelastgift from person where exists (select persid from member where member.persid=person.persid and homepp<>'"+sEntity+"' and co='M') order by alterdate,address desc,initials",oConn}
	oSel:Execute()
	if oSel:reccount>0
		aPersid:=oSel:GetLookupTable(5000,#persid,#datelastgift)
		AEvalA(aPersid,{|x|x:={x[1],iif(Empty(x[2]),null_date,x[2])}})
		aPersidOrg:=AClone(aPersid) 
		AEvalA(aPersidOrg,{|x|x:=x[1]-10000})
		ASort(aPersidOrg)
		// reassign persids:
		SQLStatement{"update person set persid=persid-10000 where persid in ("+Implode(aPersid,',',,,1)+")",oConn}:Execute()
		for i:=1 to Len(aPersidOrg)
			oStmnt:=SQLStatement{"update person set persid="+Str(aPersid[i,1],-1)+",datelastgift='"+SQLdate(aPersid[i,2])+;
				"',address='"+AddSlashes(aAddr[i,2])+"' where persid="+Str(aPersidOrg[i],-1),oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				ErrorBox{,oStmnt:errinfo:errormessage+CRLF+oStmnt:sqlstring}:show()
				SQLStatement{"rollback",oConn}
				SQLStatement{"set autocommit=1",oConn}:Execute()
				SQLStatement{'unlock tables',oConn}:Execute()
				return
			endif
			oMainWindow:STATUSMESSAGE("updating persons "+Str(i,-1))
		next 
	endif 

	// update account names members: firts make them unique
	oStmnt:=SQLStatement{"update account set description= cast(accid as char) where accid in (select accid from member where member.accid=account.accid and member='M'"}
	oStmnt:Execute() 
	if oStmnt:NumSuccessfulRows<1
		ErrorBox{,oStmnt:errinfo:errormessage+CRLF+oStmnt:sqlstring}:show()
		SQLStatement{"rollback",oConn}
		SQLStatement{"set autocommit=1",oConn}:Execute()
		SQLStatement{'unlock tables',oConn}:Execute()
		return 
	endif    
	
	// replace them by member names
	oStmnt:=SQLStatement{"update ignore account set description= (select "+SQLFullName(0)+" as membername from person, member where person.persid=member.persid and member.accid=account.accid) where accid in (select accid from member where member.accid=account.accid and co='M' )"}
	oStmnt:Execute() 
	if oStmnt:NumSuccessfulRows<1
		ErrorBox{,oStmnt:errinfo:errormessage+CRLF+oStmnt:sqlstring}:show()
		SQLStatement{"rollback",oConn}
		SQLStatement{"set autocommit=1",oConn}:Execute()
		SQLStatement{'unlock tables',oConn}:Execute()
		return
	endif 
	

	SQLStatement{"commit",oConn}:Execute() 
	SQLStatement{"set autocommit=1",oConn}:Execute()
	SQLStatement{'unlock tables',oConn}:Execute()
	oMainWindow:Pointer := Pointer{POINTERARROW}
	return
