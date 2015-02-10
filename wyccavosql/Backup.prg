class BackupDatabase
	// backup of database to file 
	protect mysqldPath as string
	protect backupfilename as string
	export backupfilenameLocal as string
	protect backuppath as string 
 
	protect nPeriod:=1 as int // period in days for making backup  
	declare method MakeBackupToLocal
method Init(oWindow,cBackupPath) class BackupDatabase
	// look for local mysql
	local i as int 
	local nTimeSep:=GetTimeSep() as dword
	local lAmPM as logic
	local oFileSpec as FileSpec 
	Local aDir as array
	Default(@cBackupPath,SqlSelect{"select backuppath from sysparms",oConn}:backuppath )
//	if SEntity =='HUN' .and. (servername=="localhost" .or. servername=="127.0.0.1") 
		oFileSpec:=FileSpec{}
		oFileSpec:FileName:="mysqldump"
		oFileSpec:Extension:="exe" 
		if Empty(self:mysqldPath)
			// In wossql?
			oFileSpec:Path:=WorkDir()	
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
			if Admin=="WO" .and. !sEntity=="NED" .and. (servername=="localhost" .or. servername=="127.0.0.1") .and. !Superuser
// 			if Admin=="WO" .and. (servername=="localhost" .or. servername=="127.0.0.1") 
				GetHelpDir()
				self:backupfilename:=HelpDir+'\'+dbname+'_'+Str(Year(Today()),4)+'_'+StrZero(Month(Today()),2)+'_'+StrZero(Day(Today()),2)+'_'+SubStr(Time(),1,5)+'.sql.gz'
			endif
			// make backupfilename for backup to local: 
			self:backuppath:=cBackupPath
			if Empty(self:backuppath)
				self:backuppath:=WorkDir()+'\backup\'
			endif
			self:backupfilenameLocal:=self:backuppath+'\'+dbname+'_'+Str(Year(Today()),4)+'_'+StrZero(Month(Today()),2)+'_'+StrZero(Day(Today()),2)+'_'+SubStr(Time(),1,5)+'.sql'
			
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
	ptrHandleCmd := MakeFile(@cCmdfile,"Creating cmd file for backup")
	IF ptrHandleCmd = F_ERROR .or. Empty(ptrHandleCmd)
		return false 
	ENDIF
	ptrHandleBatch := MakeFile(@cbatchfile,"Creating batch file for backup")
	IF ptrHandleBatch = F_ERROR .or. Empty(ptrHandleBatch)
		return false 
	ENDIF
	ptrHandleFtp := MakeFile(@cFtpfile,"Creating ftp text file for backup")
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
Method MakeBackupToLocal(lWait:=true as logic) as logic class BackupDatabase
	// make batch file for backup to local PC and starting it 
	local i as int
	local cbatchfile,cCmdfile,cFtpfile,cCloseFile,cLogFile as string  
	loca aBackup:={} as array
	local ptrHandleBatch,ptrHandleCmd,ptrHandleFtp,ptrHandleClose as ptr
	local oFilespecB,oFileSpec as FileSpec
	local oTCPIP as TCPIP 
	
	if Empty(self:backupfilenameLocal)
		return false
	endif

	// make batchfile
	GetHelpDir()
	cbatchfile:=HelpDir+'\'+"batchbackuplocal.vbs"  
	cCmdfile:=HelpDir+'\'+"cmdbackuplocal.cmd"
	ptrHandleCmd := MakeFile(@cCmdfile,"Creating cmd file for backup to local")
	IF ptrHandleCmd = F_ERROR .or. Empty(ptrHandleCmd)
		return false 
	ENDIF
	ptrHandleBatch := MakeFile(@cbatchfile,"Creating batch file for backup to local")
	IF ptrHandleBatch = F_ERROR .or. Empty(ptrHandleBatch)
		return false 
	ENDIF
	//create local backup folder:
	IF Len(Directory(self:backuppath))==0
		DirMake(self:backuppath)
	endif	
	aBackup:=GetbackupSite()

	// make cmd file	
	FWriteLine(ptrHandleCmd,'"'+self:mysqldPath+'" -u %1 -p%2 -h '+servername+' "'+dbname+'" > "'+self:backupfilenameLocal+'"')
	FWriteLine(ptrHandleCmd,'"'+WorkDir()+'gzip.exe" < "'+self:backupfilenameLocal+'" > "'+self:backupfilenameLocal+'.gz"' )
	FWriteLine(ptrHandleCmd,'del "'+self:backupfilenameLocal+'"')
 	FWriteLine(ptrHandleCmd,'exit')   
	FClose(ptrHandleCmd) 

	oFilespecB:=FileSpec{cCmdfile} 
	if oFilespecB:Find()             
		// make batch file:
		FWriteLine(ptrHandleBatch,'Set WshShell = CreateObject("WScript.Shell")')
		FWriteLine(ptrHandleBatch,'cmd = "cmd.exe /K ""'+cCmdfile+' " & WScript.Arguments.Item(0) & " " & WScript.Arguments.Item(1) & " " & WScript.Arguments.Item(2) & " " & WScript.Arguments.Item(3) & " " & WScript.Arguments.Item(4) & " " & WScript.Arguments.Item(5) & """"')
		FWriteLine(ptrHandleBatch,'return = WshShell.Run(cmd,0,'+iif(lWait,'true','false')+')')
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
		oMainWindow:STATUSMESSAGE("Making backup of database...")
		FileStart(cbatchfile,oMainWindow,sqluid+' '+sqlpwd+ ' wos-notify_weu@wycliffe.net '+GetWosmasterPwd()+' karel_kuijpers@wycliffe.net '+aBackup[1]) 
		LogEvent(self,"backup of "+self:backupfilenameLocal)
		oMainWindow:STATUSMESSAGE(Space(80))

	else
		return false
	endif		
	return true

CLASS BackupNow INHERIT DialogWinDowExtra 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oCCBackupFolderButton AS PUSHBUTTON
	PROTECT oDCBackupFolder AS SINGLELINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCcancelButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
   protect busy as logic
RESOURCE BackupNow DIALOGEX  5, 19, 279, 80
STYLE	DS_3DLOOK|WS_POPUP|WS_CAPTION|WS_SYSMENU|WS_THICKFRAME
CAPTION	"Backupdatabase to local area"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Folder for saving backup:", BACKUPNOW_FIXEDTEXT1, "Static", WS_CHILD, 8, 15, 103, 12
	CONTROL	"v", BACKUPNOW_BACKUPFOLDERBUTTON, "Button", WS_TABSTOP|WS_CHILD, 246, 15, 13, 12
	CONTROL	"", BACKUPNOW_BACKUPFOLDER, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_BORDER, 115, 14, 131, 13, WS_EX_CLIENTEDGE
	CONTROL	"OK", BACKUPNOW_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 208, 51, 53, 13
	CONTROL	"Cancel", BACKUPNOW_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 152, 51, 53, 13
END

METHOD BackupFolderButton( ) CLASS BackupNow 
 	LOCAL oFileDialog as SaveAsDialog
	oFileDialog := SaveAsDialog{self,dbname+'.sql'}
	oFileDialog:Caption:="Select required folder for backup files"
	oFileDialog:SetFilter("*.gz","gzip") 
	if !Empty(self:oDCBackupFolder:TextValue)
		oFileDialog:InitialDirectory:=AllTrim(self:oDCBackupFolder:TextValue)
	endif
	oFileDialog:SetStyle(OFN_HIDEREADONLY+OFN_LONGNAMES+OFN_EXPLORER)
	IF !oFileDialog:Show()
		RETURN FALSE
	ENDIF
	IF !Empty( oFileDialog:FileName )	
		// Set the instance var...for later use...if Ok
		self:oDCBackupFolder:Value:= substr(oFileDialog:FileName,1,rat('\',oFileDialog:FileName))
		SetDefault(CurPath)
		SetPath(CurPath)
	ELSE	
		RETURN FALSE
	ENDIF
RETURN true

METHOD cancelButton( ) CLASS BackupNow
if self:busy
	WarningBox{self,self:oLan:WGet("Backup of database"),self:oLan:WGet("still busy with backup of database")}:show()
	return false
endif
	self:EndDialog()
RETURN NIL
METHOD Init(oParent,uExtra) CLASS BackupNow 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"BackupNow",_GetInst()},TRUE)

oDCFixedText1 := FixedText{SELF,ResourceID{BACKUPNOW_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Folder for saving backup:",NULL_STRING,NULL_STRING}

oCCBackupFolderButton := PushButton{SELF,ResourceID{BACKUPNOW_BACKUPFOLDERBUTTON,_GetInst()}}
oCCBackupFolderButton:HyperLabel := HyperLabel{#BackupFolderButton,"v","Browse in folders",NULL_STRING}
oCCBackupFolderButton:TooltipText := "Browse in Files"
oCCBackupFolderButton:OwnerAlignment := OA_X

oDCBackupFolder := SingleLineEdit{SELF,ResourceID{BACKUPNOW_BACKUPFOLDER,_GetInst()}}
oDCBackupFolder:HyperLabel := HyperLabel{#BackupFolder,NULL_STRING,NULL_STRING,NULL_STRING}
oDCBackupFolder:TooltipText := "Folder for backup files"
oDCBackupFolder:OwnerAlignment := OA_WIDTH

oCCOKButton := PushButton{SELF,ResourceID{BACKUPNOW_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCcancelButton := PushButton{SELF,ResourceID{BACKUPNOW_CANCELBUTTON,_GetInst()}}
oCCcancelButton:HyperLabel := HyperLabel{#cancelButton,"Cancel",NULL_STRING,NULL_STRING}

SELF:Caption := "Backupdatabase to local area"
SELF:HyperLabel := HyperLabel{#BackupNow,"Backupdatabase to local area",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS BackupNow
	local oBackDB as BackupDatabase
	if self:busy
		WarningBox{self,self:oLan:WGet("Backup of database"),self:oLan:WGet("still busy with backup of database")}:show()
		return false
	endif
	oBackDB:=  BackupDatabase{oMainWindow,self:oDCBackupFolder:VALUE}
	oMainWindow:Pointer := Pointer{POINTERHOURGLASS} 
	self:Pointer := Pointer{POINTERHOURGLASS} 
 	self:busy:=true
	if !oBackDB:MakeBackupToLocal(true)
		//		TextBox{self,self:oLan:WGet("Backup database"),self:oLan:WGet("Backup started which can take several minutes")+'. '+self:oLan:WGet("Don't switch off you PC too quickly")+'!',BOXICONHAND}:show()
	 	oMainWindow:Pointer := Pointer{POINTERARROW}
	 	self:Pointer := Pointer{POINTERARROW}
	 	self:busy:=false
		return false
	endif
 	oMainWindow:Pointer := Pointer{POINTERARROW}
 	self:Pointer := Pointer{POINTERARROW}
 	self:busy:=false
	TextBox{self,self:oLan:WGet("Backup database"),self:oLan:WGet("Backup of database finished to file ")+': '+ oBackDB:backupfilenameLocal ,BOXICONHAND}:show()
	self:EndDialog()
	RETURN NIL
method PostInit(oWindow,iCtlID,oServer,uExtra) class BackupNow
	//Put your PostInit additions here 
	self:SetTexts()
	SaveUse(self)
	self:oDCBackupFolder:Value:=ConS(SqlSelect{"select backuppath from sysparms",oConn}:backuppath)
	if Empty( self:oDCBackupFolder:VALUE )
		self:oDCBackupFolder:Value:=CurPath+'\Backup\'
	endif
	IF Len(Directory(self:oDCBackupFolder:VALUE))==0
		DirMake(self:oDCBackupFolder:VALUE)
	endif	

	return NIL

method QueryClose(oEvent) class BackupNow
	local lAllowClose as logic
	if self:busy
		WarningBox{self,self:oLan:WGet("Backup of database"),self:oLan:WGet("still busy with backup of database")}:show()
		return false
	endif
	lAllowClose := super:QueryClose(oEvent)
	//Put your changes here
	return lAllowClose

STATIC DEFINE BACKUPNOW_BACKUPFOLDER := 102 
STATIC DEFINE BACKUPNOW_BACKUPFOLDERBUTTON := 101 
STATIC DEFINE BACKUPNOW_CANCELBUTTON := 104 
STATIC DEFINE BACKUPNOW_FIXEDTEXT1 := 100 
STATIC DEFINE BACKUPNOW_OKBUTTON := 103 
STATIC DEFINE BACKUPNOWOLD_BACKUPFOLDER := 102 
STATIC DEFINE BACKUPNOWOLD_BACKUPFOLDERBUTTON := 101 
STATIC DEFINE BACKUPNOWOLD_CANCELBUTTON := 104 
STATIC DEFINE BACKUPNOWOLD_FIXEDTEXT1 := 100 
STATIC DEFINE BACKUPNOWOLD_OKBUTTON := 103 
RESOURCE Restore DIALOGEX  5, 19, 345, 72
STYLE	DS_3DLOOK|WS_POPUP|WS_CAPTION|WS_SYSMENU|WS_THICKFRAME
CAPTION	"Restore database from backup"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Restore database from backup file:", RESTORE_FIXEDTEXT1, "Static", WS_CHILD, 8, 15, 116, 12
	CONTROL	"v", RESTORE_BACKUPFOLDERBUTTON, "Button", WS_TABSTOP|WS_CHILD, 324, 14, 13, 13
	CONTROL	"", RESTORE_BACKUPFOLDER, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 128, 14, 196, 13, WS_EX_CLIENTEDGE
	CONTROL	"OK", RESTORE_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 284, 40, 53, 12
	CONTROL	"Cancel", RESTORE_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 228, 40, 53, 12
END

CLASS Restore INHERIT DialogWinDowExtra 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oCCBackupFolderButton AS PUSHBUTTON
	PROTECT oDCBackupFolder AS SINGLELINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCcancelButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  protect mysqlPath as string 
  protect busy as logic
ACCESS BackupFolder() CLASS Restore
RETURN SELF:FieldGet(#BackupFolder)

ASSIGN BackupFolder(uValue) CLASS Restore
SELF:FieldPut(#BackupFolder, uValue)
RETURN uValue

METHOD BackupFolderButton( ) CLASS Restore 
 	LOCAL oFileDialog as OpenDialog
	oFileDialog := OpenDialog{self,""}
	oFileDialog:Caption:="Select required backup file for restoring database "+dbname+" on server "+servername
 	oFileDialog:SetFilter({"*.gz","*.sql","*.*"},{"gzip files","sql files","all files"},1)
	oFileDialog:InitialDirectory:=self:oDCBackupFolder:Value
	oFileDialog:SetStyle(OFN_HIDEREADONLY+OFN_LONGNAMES+OFN_EXPLORER)
	IF !oFileDialog:Show()
		RETURN FALSE
	ENDIF
	IF !Empty( oFileDialog:FileName )
		// Set the instance var...for later use...if Ok
		self:oDCBackupFolder:Value:= oFileDialog:FileName
		SetDefault(CurPath)
		SetPath(CurPath)
	ELSE	
		RETURN FALSE
	ENDIF

RETURN true
METHOD cancelButton( ) CLASS Restore 
if self:busy
	WarningBox{self,self:oLan:WGet("restore of database"),self:oLan:WGet("still busy with restoring database")}:show()
	return false
endif

	self:EndDialog()

RETURN NIL
METHOD Init(oParent,uExtra) CLASS Restore 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"Restore",_GetInst()},TRUE)

oDCFixedText1 := FixedText{SELF,ResourceID{RESTORE_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Restore database from backup file:",NULL_STRING,NULL_STRING}

oCCBackupFolderButton := PushButton{SELF,ResourceID{RESTORE_BACKUPFOLDERBUTTON,_GetInst()}}
oCCBackupFolderButton:HyperLabel := HyperLabel{#BackupFolderButton,"v","Browse in files",NULL_STRING}
oCCBackupFolderButton:TooltipText := "Browse in Files"
oCCBackupFolderButton:OwnerAlignment := OA_X

oDCBackupFolder := SingleLineEdit{SELF,ResourceID{RESTORE_BACKUPFOLDER,_GetInst()}}
oDCBackupFolder:HyperLabel := HyperLabel{#BackupFolder,NULL_STRING,NULL_STRING,NULL_STRING}
oDCBackupFolder:TooltipText := "File to be imported"
oDCBackupFolder:OwnerAlignment := OA_WIDTH
oDCBackupFolder:FocusSelect := FSEL_HOME

oCCOKButton := PushButton{SELF,ResourceID{RESTORE_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCcancelButton := PushButton{SELF,ResourceID{RESTORE_CANCELBUTTON,_GetInst()}}
oCCcancelButton:HyperLabel := HyperLabel{#cancelButton,"Cancel",NULL_STRING,NULL_STRING}

SELF:Caption := "Restore database from backup"
SELF:HyperLabel := HyperLabel{#Restore,"Restore database from backup",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS Restore 
	local i as int 
	local fMaxSize=0.0 as float
	local cbatchfile,cCmdfile,cFtpfile,cCloseFile,cLogFile,cRestoreFile as string  
	loca aBackup:={} as array
	local ptrHandleBatch,ptrHandleCmd,ptrHandleFtp,ptrHandleClose as ptr
	local oFilespecB,oFileSpec as filespec
	local oBackSpec as filespec
if self:busy
	WarningBox{self,self:oLan:WGet("restore of database"),self:oLan:WGet("still busy with restoring database")}:show()
	return false
endif
oBackSpec:=FileSpec{self:oDCBackupFolder:VALUE}
if Empty(oBackSpec:filename) .or.Empty(oBackSpec:Extension)
	ErrorBox{self,self:oLan:WGet("select a file")}:show()
	return false
endif
if !(Lower(oBackSpec:Extension)=='.gz' .or.Lower(oBackSpec:Extension)=='.sql')
	ErrorBox{self,self:oLan:WGet("Extension of backup file should be: .gz or .sql")}:show()
	return false
endif
if AtC(dbname,oBackSpec:filename)=0
	ErrorBox{self,"Backup filename does not contain database name: "+dbname}:show()
	return false
endif

if !oBackSpec:Find()
	ErrorBox{self,self:oLan:WGet("select an existing file")}:show()
	return false
endif
if oBackSpec:Size<400
	ErrorBox{self,oBackSpec:filename+' '+self:oLan:WGet("is empty file")}:show()
	return false
endif
if (Today()-oBackSpec:DateChanged)>40
	ErrorBox{self,oBackSpec:filename+' '+self:oLan:WGet("is too old")}:show()
	return false
endif
aBackup:=Directory(oBackSpec:Drive+oBackSpec:Path)
// determine max size of backup files:
AEval(aBackup,{|x|fMaxSize:=iif(AtC(dbname,x[F_NAME])>0,Max(fMaxSize,x[F_SIZE]),fMaxSize)})
if oBackSpec:size<0.95*fMaxSize
	ErrorBox{self,oBackSpec:filename+' '+self:oLan:WGet("is probably not a complete file")}:show()
	return false
endif
	
if Empty(self:mysqlPath)
	ErrorBox{self,self:oLan:WGet("mysql.exe not found in")+' '+WorkDir()}:show()
	return false
endif
	
if TextBox{self,self:oLan:WGet("restore of database"),self:oLan:WGet("Do you really want to replace database")+Space(1)+dbname+' '+self:oLan:WGet("on server")+' '+servername+' '+self:oLan:WGet("with file")+;
	' '+self:oDCBackupFolder:VALUE+'?',BUTTONYESNO+BOXICONQUESTIONMARK}:show()== BOXREPLYNO
	return nil
endif
// restore database:
	cbatchfile:=HelpDir+'\'+"batchrestorelocal.vbs"  
	cCmdfile:=HelpDir+'\'+"cmdrestorelocal.cmd"
	ptrHandleCmd := MakeFile(@cCmdfile,"Creating cmd file for restore from local")
	IF ptrHandleCmd = F_ERROR .or. Empty(ptrHandleCmd)
		return false 
	ENDIF
	ptrHandleBatch := MakeFile(@cbatchfile,"Creating batch file for restore from local")
	IF ptrHandleBatch = F_ERROR .or. Empty(ptrHandleBatch)
		return false 
	ENDIF

	// make cmd file
	if oBackSpec:Extension=='.gz'
		cRestoreFile:=oBackSpec:Drive+ oBackSpec:Path+oBackSpec:filename	
		FWriteLine(ptrHandleCmd,'"'+WorkDir()+'gzip.exe" -d < "'+self:oDCBackupFolder:VALUE+'" > "'+cRestoreFile+'"' ) 
	else
		cRestoreFile:=self:oDCBackupFolder:VALUE	
	endif
	FWriteLine(ptrHandleCmd,'"'+self:mysqlPath+'" -u %1 -p%2 -h '+servername+' "'+dbname+'" < "'+cRestoreFile+'"')
	if oBackSpec:Extension=='.gz'
		FWriteLine(ptrHandleCmd,'del "'+cRestoreFile+'"' ) 
	endif
 	FWriteLine(ptrHandleCmd,'exit')   
	FClose(ptrHandleCmd) 

	oFilespecB:=FileSpec{cCmdfile} 
	if oFilespecB:Find()             
		oMainWindow:Pointer := Pointer{POINTERHOURGLASS} 
		self:Pointer := Pointer{POINTERHOURGLASS} 
		// make batch file:
		FWriteLine(ptrHandleBatch,'Set WshShell = CreateObject("WScript.Shell")')
		FWriteLine(ptrHandleBatch,'cmd = "cmd.exe /K ""'+cCmdfile+' " & WScript.Arguments.Item(0) & " " & WScript.Arguments.Item(1) & """"')
		FWriteLine(ptrHandleBatch,'return = WshShell.Run(cmd,0,true)')
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
		self:busy:=true
		FileStart(cbatchfile,oMainWindow,sqluid+' '+sqlpwd) 
		LogEvent(self,"restore of database with "+self:oDCBackupFolder:VALUE)
	 	oMainWindow:Pointer := Pointer{POINTERARROW}
	 	self:Pointer := Pointer{POINTERARROW}
	 	self:busy:=false
	 	TextBox{self,self:oLan:WGet("restore of database"),self:oLan:WGet("Database restored")}:show() 
	else
		return false
	endif		

	
self:EndDialog()
RETURN nil
method PostInit(oWindow,iCtlID,oServer,uExtra) class Restore
	//Put your PostInit additions here
	local oFileSpec as filespec 
	self:SetTexts()
	SaveUse(self)
	self:oDCBackupFolder:Value:=ConS(SqlSelect{"select backuppath from sysparms",oConn}:backuppath)
	if Empty( self:oDCBackupFolder:VALUE )
		self:oDCBackupFolder:Value:=CurPath+'\Backup\'
	endif
		oFileSpec:=FileSpec{}
		oFileSpec:filename:="mysql"
		oFileSpec:Extension:="exe" 
		// In wossql?
		oFileSpec:Path:=WorkDir()	
		if oFileSpec:Find()
			self:mysqlPath:=oFileSpec:fullpath
		endif
	return nil

method QueryClose(oEvent) class Restore
	local lAllowClose as logic
	if self:busy
		WarningBox{self,self:oLan:WGet("restore of database"),self:oLan:WGet("still busy with restoring database")}:show()
		return false
	endif
	lAllowClose := super:QueryClose(oEvent)
	//Put your changes here
	return lAllowClose

STATIC DEFINE RESTORE_BACKUPFOLDER := 102 
STATIC DEFINE RESTORE_BACKUPFOLDERBUTTON := 101 
STATIC DEFINE RESTORE_CANCELBUTTON := 104 
STATIC DEFINE RESTORE_FIXEDTEXT1 := 100 
STATIC DEFINE RESTORE_OKBUTTON := 103 
STATIC DEFINE RESTOREOLD_BACKUPFOLDER := 102 
STATIC DEFINE RESTOREOLD_BACKUPFOLDERBUTTON := 101 
STATIC DEFINE RESTOREOLD_CANCELBUTTON := 104 
STATIC DEFINE RESTOREOLD_FIXEDTEXT1 := 100 
STATIC DEFINE RESTOREOLD_OKBUTTON := 103 
