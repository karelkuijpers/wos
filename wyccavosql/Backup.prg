class BackupDatabase
	// backup of database to file 
	protect mysqldPath as string
	protect backupfilename as string
	protect backupfilenameLocal as string
	protect backuppath as string 
 
	protect nPeriod:=1 as int // period in days for making backup
method Init(oWindow,cWorkdir) class BackupDatabase
	// look for local mysql
	local i as int 
	local nTimeSep:=GetTimeSep() as dword
	local lAmPM as logic
	local oFileSpec as FileSpec 
	Local aDir as array
//	if SEntity =='HUN' .and. (servername=="localhost" .or. servername=="127.0.0.1") 
		oFileSpec:=FileSpec{}
		oFileSpec:FileName:="mysqldump"
		oFileSpec:Extension:="exe" 
		if Empty(self:mysqldPath)
			// In wossql?
			oFileSpec:Path:=cWorkdir	
			if oFileSpec:Find()
				self:mysqldPath:=oFileSpec:fullpath
			endif
		endif
		
		if Empty(self:mysqldPath)
			// in program files? 
			aDir:=Directory("C:\Program Files\Mysql\Mysql*","D")
			if Len(ADir)>0
				for i:=1 to Len(ADir)
					oFileSpec:Path:="C:\Program Files\Mysql\"+ADir[1][F_NAME]		
					if oFileSpec:Find()
						self:mysqldPath:=oFileSpec:fullpath
						exit
					else
						oFileSpec:Path+='bin'		
						if oFileSpec:Find()
							self:mysqldPath:=oFileSpec:fullpath
							exit
						endif
					endif
				next
			endif
		endif
		if Empty(self:mysqldPath)
			if !Empty(GetEnv('ProgramFiles(x86)'))
				// 64 bits
				aDir:=Directory("C:\ProgramFiles(x86)\Mysql\Mysql*","D")
				if Len(ADir)>0
					for i:=1 to Len(ADir)
						oFileSpec:Path:="C:\ProgramFiles(x86)\Mysql\"+ADir[1][F_NAME]		
						if oFileSpec:Find()
							self:mysqldPath:=oFileSpec:fullpath
							exit
						else
							oFileSpec:Path+='bin'		
							if oFileSpec:Find()
								self:mysqldPath:=oFileSpec:fullpath
								exit
							endif
						endif
					next
				endif
			endif
		endif
		if Empty(self:mysqldPath)
			// xampp?
			oFileSpec:Path:="C:\xampp\mysql\bin"	
			if oFileSpec:Find()
				self:mysqldPath:=oFileSpec:fullpath
			endif
		endif  */
		
		if !Empty(self:mysqldPath)
			// remove old backup files: 
			AEval(Directory(HelpDir+'\'+dbname+'*.gz'), {|aFile| FErase(HelpDir+'\'+aFile[F_NAME])}) 
			// determine backfilename 
			nTimeSep:=SetTimeSep(Asc('_'))
			lAmPM:=SetAmPm(false) 
			if SEntity =='HUN' .and. (servername=="localhost" .or. servername=="127.0.0.1") 
				GetHelpDir()
				self:backupfilename:=HelpDir+'\'+dbname+'_'+Str(Year(Today()),4)+'_'+StrZero(Month(Today()),2)+'_'+StrZero(Day(Today()),2)+'_'+SubStr(Time(),1,5)+'.sql.gz'
			endif
			// make backupfilename for backup to local: 
			self:backuppath:=SqlSelect{"select backuppath from sysparms",oConn}:backuppath
			if Empty(self:backuppath)
				self:backuppath:=WorkDir()+'\backup\'
			endif
			self:backupfilenameLocal:=self:backuppath+dbname+'_'+Str(Year(Today()),4)+'_'+StrZero(Month(Today()),2)+'_'+StrZero(Day(Today()),2)+'_'+SubStr(Time(),1,5)+'.sql'
			
			SetTimeSep(nTimeSep)
			SetAmPm(lAmPM)
		else
			LogEvent(self,"no mysqldump found in :"+oFileSpec:fullpath,"logerrors")
		endif 
//	endif
	return self
Method MakeBackup() class BackupDatabase
	// make batch file for backup and starting it 
	local i as int
	local cbatchfile,cCmdfile,cFtpfile,cCloseFile,cLogFile as string  
	loca aBackup:={} as array
	local ptrHandleBatch,ptrHandleCmd,ptrHandleFtp,ptrHandleClose as ptr
	local oFilespecB,oFileSpec as FileSpec
	local oTCPIP as TCPIP 
	
	if Empty(self:backupfilename)
		return
	endif
	// test backup site available:
	oTCPIP:=TCPIP{}
	oTCPIP:timeout:=2000
//	oTCPIP:Ping('www.google.com')
	oTCPIP:Ping('www.mdvit.net')
	if AtC("timeout",oTCPIP:Response)>0
		return false
	endif
	// make batchfile
	GetHelpDir()
	cbatchfile:=HelpDir+'\'+"batchbackup.vbs"  
	cCmdfile:=HelpDir+'\'+"cmdbackup.cmd"
	cFtpfile:=HelpDir+'\'+"ftpput.txt"
	ptrHandleCmd := MakeFile(self,@cCmdfile,"Creating cmd file for backup")
	IF ptrHandleCmd = F_ERROR .or. Empty(ptrHandleCmd)
		return false 
	ENDIF
	ptrHandleBatch := MakeFile(self,@cbatchfile,"Creating batch file for backup")
	IF ptrHandleBatch = F_ERROR .or. Empty(ptrHandleBatch)
		return false 
	ENDIF
	ptrHandleFtp := MakeFile(self,@cFtpfile,"Creating ftp text file for backup")
	IF ptrHandleFtp = F_ERROR .or. Empty(ptrHandleFtp)
		return false 
	ENDIF
	// make Fptput file: 
	aBackup:=GetbackupSite()
	FWriteLine(ptrHandleFtp,aBackup[2])
	FWriteLine(ptrHandleFtp,aBackup[3])
	FWriteLine(ptrHandleFtp,"cd weu")
	FWriteLine(ptrHandleFtp,"delete "+dbname+'_'+Str(Year(Today()),4)+'_'+StrZero(Month(Today()),2)+'_'+StrZero(Day(Today()),2)+'_05_00.sql.gz')    // backed up by mysqldumper) this morning
	FWriteLine(ptrHandleFtp,"type binary")
	FWriteLine(ptrHandleFtp,"put "+self:backupfilename)
	FWriteLine(ptrHandleFtp,"quit")
	FClose(ptrHandleFtp) 
	
	FWriteLine(ptrHandleCmd,'"'+mysqldPath+'" -u %1 -p%2 "'+dbname+'" | "'+WorkDir()+'gzip.exe" > "'+self:backupfilename+'"')
	FWriteLine(ptrHandleCmd,'ftp -s:'+cFtpfile+' %6')   
	FWriteLine(ptrHandleCmd,'del "'+cFtpfile+'"')
	FWriteLine(ptrHandleCmd,'del "'+self:backupfilename+'"')
 	FWriteLine(ptrHandleCmd,'exit')   
	
	FClose(ptrHandleCmd) 
	oFilespecB:=FileSpec{cCmdfile} 
	if oFilespecB:Find()             
		// make batch file:
		FWriteLine(ptrHandleBatch,'Set WshShell = CreateObject("WScript.Shell")')
		FWriteLine(ptrHandleBatch,'cmd = "cmd.exe /K ""'+cCmdfile+' " & WScript.Arguments.Item(0) & " " & WScript.Arguments.Item(1) & " " & WScript.Arguments.Item(2) & " " & WScript.Arguments.Item(3) & " " & WScript.Arguments.Item(4) & " " & WScript.Arguments.Item(5) & """"')
		FWriteLine(ptrHandleBatch,'return = WshShell.Run(cmd,0,false)')
		FWriteLine(ptrHandleBatch,'Set WshShell = Nothing')
		FWriteLine(ptrHandleBatch,'WScript.Quit()')
		FClose(ptrHandleBatch) 
		// test if written to disk: 
		for i:=1 to 90
			Tone(30000,1)
			ptrHandleBatch:=FOpen(cbatchfile,FO_READ+FO_EXCLUSIVE) 
			if !ptrHandleBatch==F_ERROR
				exit
			endif
		next
		FClose(ptrHandleBatch) 
		FileStart(cbatchfile,oMainWindow,sqluid+' '+sqlpwd+ ' wos-notify_weu@wycliffe.net '+GetWosmasterPwd()+' karel_kuijpers@wycliffe.net '+aBackup[1]) 
	else
		return false
	endif		
	return true
Method MakeBackupToLocal() class BackupDatabase
	// make batch file for backup to local PC and starting it 
	local i as int
	local cbatchfile,cCmdfile,cFtpfile,cCloseFile,cLogFile as string  
	loca aBackup:={} as array
	local ptrHandleBatch,ptrHandleCmd,ptrHandleFtp,ptrHandleClose as ptr
	local oFilespecB,oFileSpec as FileSpec
	local oTCPIP as TCPIP 
	
	if Empty(self:backupfilenameLocal)
		return
	endif

	// make batchfile
	GetHelpDir()
	cbatchfile:=HelpDir+'\'+"batchbackuplocal.vbs"  
	cCmdfile:=HelpDir+'\'+"cmdbackuplocal.cmd"
	ptrHandleCmd := MakeFile(self,@cCmdfile,"Creating cmd file for backup to local")
	IF ptrHandleCmd = F_ERROR .or. Empty(ptrHandleCmd)
		return false 
	ENDIF
	ptrHandleBatch := MakeFile(self,@cbatchfile,"Creating batch file for backup to local")
	IF ptrHandleBatch = F_ERROR .or. Empty(ptrHandleBatch)
		return false 
	ENDIF
	//create local backup folder:
	IF Len(Directory(self:backuppath))==0
		DirMake(self:backuppath)
	endif	
	aBackup:=GetbackupSite()

	// make cmd file	
	FWriteLine(ptrHandleCmd,'"'+mysqldPath+'" -u %1 -p%2 -h '+servername+' "'+dbname+'" > "'+self:backupfilenameLocal+'"')
	FWriteLine(ptrHandleCmd,'"'+WorkDir()+'gzip.exe" < "'+self:backupfilenameLocal+'" > "'+self:backupfilenameLocal+'.gz"' )
	FWriteLine(ptrHandleCmd,'del "'+self:backupfilenameLocal+'"')
 	FWriteLine(ptrHandleCmd,'exit')   
	FClose(ptrHandleCmd) 

	oFilespecB:=FileSpec{cCmdfile} 
	if oFilespecB:Find()             
		// make batch file:
		FWriteLine(ptrHandleBatch,'Set WshShell = CreateObject("WScript.Shell")')
		FWriteLine(ptrHandleBatch,'cmd = "cmd.exe /K ""'+cCmdfile+' " & WScript.Arguments.Item(0) & " " & WScript.Arguments.Item(1) & " " & WScript.Arguments.Item(2) & " " & WScript.Arguments.Item(3) & " " & WScript.Arguments.Item(4) & " " & WScript.Arguments.Item(5) & """"')
		FWriteLine(ptrHandleBatch,'return = WshShell.Run(cmd,0,false)')
		FWriteLine(ptrHandleBatch,'Set WshShell = Nothing')
		FWriteLine(ptrHandleBatch,'WScript.Quit()')
		FClose(ptrHandleBatch) 
		// test if written to disk: 
		for i:=1 to 90
			Tone(30000,1)
			ptrHandleBatch:=FOpen(cbatchfile,FO_READ+FO_EXCLUSIVE) 
			if !ptrHandleBatch==F_ERROR
				exit
			endif
		next
		FClose(ptrHandleBatch) 
		FileStart(cbatchfile,oMainWindow,sqluid+' '+sqlpwd+ ' wos-notify_weu@wycliffe.net '+GetWosmasterPwd()+' karel_kuijpers@wycliffe.net '+aBackup[1]) 
	else
		return false
	endif		
	return true

