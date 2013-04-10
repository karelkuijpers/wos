CLASS EditEmailAccount INHERIT DataDialogMine 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCemailaddress AS SINGLELINEEDIT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCusername AS SINGLELINEEDIT
	PROTECT oDCpassword AS SINGLELINEEDIT
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCoutgoingserver AS SINGLELINEEDIT
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCport AS SINGLELINEEDIT
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCprotocol AS COMBOBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oCCTestButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  protect lNew as logic
  export lSuccess as logic
RESOURCE EditEmailAccount DIALOGEX  4, 3, 412, 181
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Email address:", EDITEMAILACCOUNT_FIXEDTEXT1, "Static", WS_CHILD, 12, 11, 54, 13
	CONTROL	"", EDITEMAILACCOUNT_EMAILADDRESS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 88, 11, 160, 13, WS_EX_CLIENTEDGE
	CONTROL	"User name:", EDITEMAILACCOUNT_FIXEDTEXT3, "Static", WS_CHILD, 12, 48, 53, 12
	CONTROL	"Logon Information mail server:", EDITEMAILACCOUNT_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 30, 252, 54
	CONTROL	"Password:", EDITEMAILACCOUNT_FIXEDTEXT2, "Static", WS_CHILD, 12, 62, 53, 13
	CONTROL	"", EDITEMAILACCOUNT_USERNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 88, 44, 160, 13, WS_EX_CLIENTEDGE
	CONTROL	"", EDITEMAILACCOUNT_PASSWORD, "Edit", ES_AUTOHSCROLL|ES_PASSWORD|WS_TABSTOP|WS_CHILD|WS_BORDER, 88, 59, 160, 13, WS_EX_CLIENTEDGE
	CONTROL	"Outgoing server:", EDITEMAILACCOUNT_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 92, 252, 66
	CONTROL	"Server address:", EDITEMAILACCOUNT_FIXEDTEXT4, "Static", WS_CHILD, 12, 107, 64, 13
	CONTROL	"", EDITEMAILACCOUNT_OUTGOINGSERVER, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 88, 103, 159, 12, WS_EX_CLIENTEDGE
	CONTROL	"Port number:", EDITEMAILACCOUNT_FIXEDTEXT5, "Static", WS_CHILD, 12, 122, 54, 12
	CONTROL	"", EDITEMAILACCOUNT_PORT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 88, 118, 54, 13, WS_EX_CLIENTEDGE
	CONTROL	"Protocol:", EDITEMAILACCOUNT_FIXEDTEXT6, "Static", WS_CHILD, 12, 137, 54, 12
	CONTROL	"", EDITEMAILACCOUNT_PROTOCOL, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 88, 133, 54, 33
	CONTROL	"OK", EDITEMAILACCOUNT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 340, 114, 53, 12
	CONTROL	"Cancel", EDITEMAILACCOUNT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 340, 132, 53, 13
	CONTROL	"Test account settings", EDITEMAILACCOUNT_FIXEDTEXT7, "Static", WS_CHILD, 276, 7, 115, 12
	CONTROL	"It is recommended to test your account by clicking the button below. (required internet connection)", EDITEMAILACCOUNT_FIXEDTEXT8, "Static", WS_CHILD, 276, 25, 127, 30
	CONTROL	"Test Account Settings...", EDITEMAILACCOUNT_TESTBUTTON, "Button", WS_TABSTOP|WS_CHILD, 272, 55, 91, 12
END

METHOD CancelButton( ) CLASS EditEmailAccount 
	self:lSuccess:=false 
	self:EndWindow()
RETURN NIL
ACCESS emailaddress() CLASS EditEmailAccount
RETURN SELF:FieldGet(#emailaddress)

ASSIGN emailaddress(uValue) CLASS EditEmailAccount
SELF:FieldPut(#emailaddress, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditEmailAccount 
LOCAL DIM aFonts[2] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditEmailAccount",_GetInst()},iCtlID)

aFonts[1] := Font{,9,"Microsoft Sans Serif"}
aFonts[1]:Italic := TRUE
aFonts[2] := Font{,9,"Microsoft Sans Serif"}
aFonts[2]:Bold := TRUE

oDCFixedText1 := FixedText{SELF,ResourceID{EDITEMAILACCOUNT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Email address:",NULL_STRING,NULL_STRING}

oDCemailaddress := SingleLineEdit{SELF,ResourceID{EDITEMAILACCOUNT_EMAILADDRESS,_GetInst()}}
oDCemailaddress:TooltipText := "Your email address used  for sending email"
oDCemailaddress:HyperLabel := HyperLabel{#emailaddress,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{EDITEMAILACCOUNT_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"User name:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{EDITEMAILACCOUNT_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Logon Information mail server:",NULL_STRING,NULL_STRING}
oDCGroupBox1:Font(aFonts[1], FALSE)

oDCFixedText2 := FixedText{SELF,ResourceID{EDITEMAILACCOUNT_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Password:",NULL_STRING,NULL_STRING}

oDCusername := SingleLineEdit{SELF,ResourceID{EDITEMAILACCOUNT_USERNAME,_GetInst()}}
oDCusername:HyperLabel := HyperLabel{#username,NULL_STRING,NULL_STRING,NULL_STRING}

oDCpassword := SingleLineEdit{SELF,ResourceID{EDITEMAILACCOUNT_PASSWORD,_GetInst()}}
oDCpassword:HyperLabel := HyperLabel{#password,NULL_STRING,NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{EDITEMAILACCOUNT_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Outgoing server:",NULL_STRING,NULL_STRING}
oDCGroupBox2:Font(aFonts[1], FALSE)

oDCFixedText4 := FixedText{SELF,ResourceID{EDITEMAILACCOUNT_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Server address:",NULL_STRING,NULL_STRING}

oDCoutgoingserver := SingleLineEdit{SELF,ResourceID{EDITEMAILACCOUNT_OUTGOINGSERVER,_GetInst()}}
oDCoutgoingserver:HyperLabel := HyperLabel{#outgoingserver,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{EDITEMAILACCOUNT_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Port number:",NULL_STRING,NULL_STRING}

oDCport := SingleLineEdit{SELF,ResourceID{EDITEMAILACCOUNT_PORT,_GetInst()}}
oDCport:Picture := "99999"
oDCport:HyperLabel := HyperLabel{#port,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText6 := FixedText{SELF,ResourceID{EDITEMAILACCOUNT_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"Protocol:",NULL_STRING,NULL_STRING}

oDCprotocol := combobox{SELF,ResourceID{EDITEMAILACCOUNT_PROTOCOL,_GetInst()}}
oDCprotocol:FillUsing({{"none",""},{"ssl","ssl"}})
oDCprotocol:HyperLabel := HyperLabel{#protocol,NULL_STRING,NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{EDITEMAILACCOUNT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITEMAILACCOUNT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{EDITEMAILACCOUNT_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Test account settings",NULL_STRING,NULL_STRING}
oDCFixedText7:Font(aFonts[2], FALSE)

oDCFixedText8 := FixedText{SELF,ResourceID{EDITEMAILACCOUNT_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"It is recommended to test your account by clicking the button below. (required internet connection)",NULL_STRING,NULL_STRING}

oCCTestButton := PushButton{SELF,ResourceID{EDITEMAILACCOUNT_TESTBUTTON,_GetInst()}}
oCCTestButton:HyperLabel := HyperLabel{#TestButton,"Test Account Settings...",NULL_STRING,NULL_STRING}

SELF:Caption := "My email account"
SELF:HyperLabel := HyperLabel{#EditEmailAccount,"My email account",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS EditEmailAccount
local nPos as int
local lError as logic
local oStmnt as SQLStatement 
// check valid data:
	if (nPos:=At('@',self:emailaddress))>0
		if At3('.',self:emailaddress,nPos+1)<0
			lError:=true
		endif
	else
		lError:=true
	endif
	if lError
		ErrorBox{self,self:oLan:wget("wrong mail adress")}:Show()
		self:oDCemailaddress:SetFocus()
		return
	endif
	if Occurs('.',self:outgoingserver)<2
		ErrorBox{self,self:oLan:wget("wrong outgoing server")}:Show()
		self:oDCoutgoingserver:SetFocus()
		return
	endif
	if (nPos:=At('@',self:username))>0
		if At3('.',self:username,nPos+1)<0
			lError:=true
		endif
	else
		lError:=true
	endif
	if lError
		ErrorBox{self,self:oLan:wget("wrong username")}:Show()
		self:oDCusername:SetFocus()
		return
	endif
	if Empty(self:password)
		ErrorBox{self,self:oLan:wget("fill password")}:Show()
		self:oDCpassword:SetFocus()
		return
	endif
	if ConI(self:port)<1 .or. ConI(self:port)>65535
		ErrorBox{self,self:oLan:wget("wrong port number")}:Show()
		self:oDCport:SetFocus()
		return
	endif
	// save mailaccount record:
	oStmnt:=SQLStatement{iif(self:lNew,"insert into","update")+" mailaccount set "+iif(self:lNew,"empid="+MyEmpID+',','')+'emailaddress="'+AllTrim(self:emailaddress)+;
	'",username="'+AllTrim(self:username)+'",password='+Crypt_Emp(true,"password",AllTrim(self:password))+',outgoingserver="'+AllTrim(self:outgoingserver)+'",port='+ConS(self:port)+;
	',protocol="'+self:protocol+'"'+iif(self:lNew,'',' where empid='+MYEMPID),oConn}
	oStmnt:Execute()
	if !Empty(oStmnt:status)
		errorbox{self,self:olan:wget("cold not save mail account")+': '+oStmnt:ErrInfo:errormessage}:show()
		return nil
	endif
	self:lSuccess:=true
	self:EndWindow()
			 
RETURN NIL
ACCESS outgoingserver() CLASS EditEmailAccount
RETURN SELF:FieldGet(#outgoingserver)

ASSIGN outgoingserver(uValue) CLASS EditEmailAccount
SELF:FieldPut(#outgoingserver, uValue)
RETURN uValue

ACCESS password() CLASS EditEmailAccount
RETURN SELF:FieldGet(#password)

ASSIGN password(uValue) CLASS EditEmailAccount
SELF:FieldPut(#password, uValue)
RETURN uValue

ACCESS port() CLASS EditEmailAccount
RETURN SELF:FieldGet(#port)

ASSIGN port(uValue) CLASS EditEmailAccount
SELF:FieldPut(#port, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class EditEmailAccount
	//Put your PostInit additions here
	local oSel as SQLSelect                                         
	local nPos as int
	local cMailaddress as string 
	self:SetTexts() 
	oSel:=SqlSelect{'select emailaddress,username,cast('+Crypt_Emp(false,"password")+' as char) as password,protocol,outgoingserver,port from mailaccount where empid='+MyEmpID,oConn}
	if oSel:RecCount>0
		// existing mail account:
		// fill fields: 
		self:emailaddress:= oSel:emailaddress
		self:username:=oSel:username
		self:password:=oSel:password
		self:outgoingserver:=oSel:outgoingserver
		self:port:=oSel:port
		self:protocol:=oSel:protocol
	else
		// not yet an mail account: 
		self:lNew:=true
		// Select employee and person:
		oSel:=SqlSelect{"select cast("+Crypt_Emp(false,"e.type") +" as char) as type, p.email";
			+' from employee as e left join person as p on (p.persid='+Crypt_Emp(false,"e.persid")+ ") where empid="+MyEmpID,oConn}
		if oSel:RecCount>0
			// prefill fields:
			cMailaddress:= oSel:email
			self:emailaddress:= cMailaddress
			self:username:=StrTran(cMailaddress,'@wycliffe.net','@wycliffe.org')
			if AtC('@wycliffe.',cMailaddress)>0 .or.AtC(cMailaddress,'@sil.')>0 
				self:outgoingserver:='mail.jaars.org'
				self:port:=587
				self:protocol:='ssl'
			elseif AtC('@gmail.',cMailaddress)>0 
				self:outgoingserver:='smtp.gmail.com'
				self:port:=587
				self:protocol:='ssl'
			elseif AtC('@hotmail.',cMailaddress)>0 
				self:outgoingserver:='smtp.live.com'
				self:port:=25
				self:protocol:='ssl'
			elseif AtC('@aol.',cMailaddress)>0 
				self:outgoingserver:='smtp.aol.com'
				self:port:=587
				self:protocol:='ssl'
			else
				self:outgoingserver:='smtp.'+SubStr(cMailaddress,At(cMailaddress,'@')+1,)
				self:port:=25
				self:protocol:='none'			
			endif
		endif
	endif
	return NIL

ACCESS protocol() CLASS EditEmailAccount
RETURN SELF:FieldGet(#protocol)

ASSIGN protocol(uValue) CLASS EditEmailAccount
SELF:FieldPut(#protocol, uValue)
RETURN uValue

METHOD TestButton( ) CLASS EditEmailAccount 
	local nRet,i as int
	local cbatchfile as string 
	local clogfile as string
	local logtext as string
	local cRun as string 
	local lError as logic
	local oFilespecB as FileSpec
	local ptrLog as ptr
	local oMf
	local oTCPIP as TCPIP  

	// test internet available:
	oTCPIP:=TCPIP{}
	oTCPIP:timeout:=2000
	oTCPIP:Ping('www.google.com')
	if AtC("timeout",oTCPIP:Response)>0
		ErrorBox{self,self:oLan:WGet("No internet connection")}:show()
		return false
	endif
	GetHelpDir()
	cbatchfile:=HelpDir+'\'+"batchtest"+Str(GetTickCountLow(),-1)+".bat"
	clogfile:=HelpDir+'\'+"logtest"+Str(GetTickCountLow(),-1)+".txt"
	cRun:= 'cmd.exe /c '+HelpDir+'\senditquiet.exe -s '+self:outgoingserver+' -port '+ConS(self:port)+' -u '+self:username+iif(Empty(self:protocol),'',' -protocol '+self:protocol)+;
		' -p '+self:password+' -f '+self:emailaddress+' -t '+self:emailaddress+' -subject "test WOS email" -body "Hi<br><strong>This is a  test email</strong>.<br>Thanks." >"';
		+clogfile+'"'
	self:Pointer := Pointer{POINTERHOURGLASS}
	Run(cRun) 
	//	FileStart(cbatchfile,self) 
	oFilespecB:=FileSpec{clogfile} 
	for i:=1 to 90
		Tone(30000,2)
		ptrLog:=FOpen(clogfile,FO_READ+FO_EXCLUSIVE) 
		if !ptrLog==F_ERROR
			exit
		endif
	next
	self:Pointer := Pointer{POINTERARROW}
	if oFilespecB:Find()
		logtext:=FReadStr(ptrLog,1024) 
		FClose(ptrLog) 
		oFilespecB:DELETE()
		if AtC('done',logtext)>0 
			TextBox{self,self:oLan:WGet("Testing Account settings"),self:oLan:WGet("Account settings correct")}:show()
		else
			ErrorBox{self,self:oLan:WGet("Error sending email with this account settings")}:show()
			return false 
		endif
	else
		ErrorBox{self,self:oLan:WGet("Error sending email with this account settings")}:show()
		return false 
	endif

	RETURN true
ACCESS username() CLASS EditEmailAccount
RETURN SELF:FieldGet(#username)

ASSIGN username(uValue) CLASS EditEmailAccount
SELF:FieldPut(#username, uValue)
RETURN uValue

STATIC DEFINE EDITEMAILACCOUNT_CANCELBUTTON := 115 
STATIC DEFINE EDITEMAILACCOUNT_EMAILADDRESS := 101 
STATIC DEFINE EDITEMAILACCOUNT_FIXEDTEXT1 := 100 
STATIC DEFINE EDITEMAILACCOUNT_FIXEDTEXT2 := 104 
STATIC DEFINE EDITEMAILACCOUNT_FIXEDTEXT3 := 102 
STATIC DEFINE EDITEMAILACCOUNT_FIXEDTEXT4 := 108 
STATIC DEFINE EDITEMAILACCOUNT_FIXEDTEXT5 := 110 
STATIC DEFINE EDITEMAILACCOUNT_FIXEDTEXT6 := 112 
STATIC DEFINE EDITEMAILACCOUNT_FIXEDTEXT7 := 116 
STATIC DEFINE EDITEMAILACCOUNT_FIXEDTEXT8 := 117 
STATIC DEFINE EDITEMAILACCOUNT_GROUPBOX1 := 103 
STATIC DEFINE EDITEMAILACCOUNT_GROUPBOX2 := 107 
STATIC DEFINE EDITEMAILACCOUNT_OKBUTTON := 114 
STATIC DEFINE EDITEMAILACCOUNT_OUTGOINGSERVER := 109 
STATIC DEFINE EDITEMAILACCOUNT_PASSWORD := 106 
STATIC DEFINE EDITEMAILACCOUNT_PORT := 111 
STATIC DEFINE EDITEMAILACCOUNT_PROTOCOL := 113 
STATIC DEFINE EDITEMAILACCOUNT_TESTBUTTON := 118 
STATIC DEFINE EDITEMAILACCOUNT_USERNAME := 105 
RESOURCE EmailConfirm DIALOGEX  8, 20, 391, 312
STYLE	DS_3DLOOK|WS_POPUP|WS_CAPTION|WS_SYSMENU|WS_THICKFRAME
CAPTION	"Sending emails"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Should all these emails be send? (uncheck the ones you want to skip)?", EMAILCONFIRM_FIXEDTEXT1, "Static", WS_CHILD, 6, 4, 306, 25
	CONTROL	"OK", EMAILCONFIRM_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 332, 3, 53, 13
	CONTROL	"Cancel", EMAILCONFIRM_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 332, 18, 53, 12
	CONTROL	"", EMAILCONFIRM_EMAILLISTVIEW, "SysListView32", LVS_REPORT|LVS_SORTASCENDING|LVS_EDITLABELS|WS_CHILD|WS_BORDER, 4, 36, 378, 270
END

CLASS EmailConfirm INHERIT DialogWinDowExtra 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCEmailListView AS LISTVIEW

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  protect oCaller as SendEmailsDirect
protect sTo,sDesc as symbol 
export lSend as logic
METHOD CancelButton( ) CLASS EmailConfirm 
	self:EndDialog(false) 
RETURN NIL
method Close(oEvent) class EmailConfirm
	super:Close(oEvent)
	//Put your changes here 
	return NIL

METHOD Init(oParent,uExtra) CLASS EmailConfirm 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"EmailConfirm",_GetInst()},TRUE)

aFonts[1] := Font{,9,"Microsoft Sans Serif"}
aFonts[1]:Bold := TRUE

oDCFixedText1 := FixedText{SELF,ResourceID{EMAILCONFIRM_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Should all these emails be send? (uncheck the ones you want to skip)?",NULL_STRING,NULL_STRING}
oDCFixedText1:Font(aFonts[1], FALSE)

oCCOKButton := PushButton{SELF,ResourceID{EMAILCONFIRM_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}
oCCOKButton:OwnerAlignment := OA_X

oCCCancelButton := PushButton{SELF,ResourceID{EMAILCONFIRM_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}
oCCCancelButton:OwnerAlignment := OA_X

oDCEmailListView := ListView{SELF,ResourceID{EMAILCONFIRM_EMAILLISTVIEW,_GetInst()}}
oDCEmailListView:OwnerAlignment := OA_PWIDTH_PHEIGHT
oDCEmailListView:HyperLabel := HyperLabel{#EmailListView,NULL_STRING,NULL_STRING,NULL_STRING}
oDCEmailListView:CheckBoxes := True

SELF:Caption := "Sending emails"
SELF:HyperLabel := HyperLabel{#EmailConfirm,"Sending emails",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS EmailConfirm 
	local i,nPos,m as int 
	local aItem:={} as array 
	local oListviewItem as ListViewItem
	aItem:=self:oDCEmailListView:GetAllItems()
	for i:=1 to Len(aItem)
		oListviewItem:=aItem[i]
		m:=oListviewItem:GetValue(self:sTo)
		if m>0 .and. !oListviewItem:Checked
			nPos:=AScan(self:oCaller:aEmail,{|x|x[5]==m})
			if nPos>0
				ADel(self:oCaller:aEmail,nPos) 
				ASize(self:oCaller:aEmail,Len(self:oCaller:aEmail)-1)
			endif
		endif
	next
	self:lSend:=true
	self:EndDialog(true) 
	RETURN nil
method PostInit(oParent,uExtra) class EmailConfirm
	//Put your PostInit additions here 
	local i,n as int
	local lSuccess as logic
	local aItem:={} as array 
	local oListViewItem as ListViewItem 
	local oListView:=self:oDCEmailListView as listview
	self:SetTexts()
	oListView:DeleteAllColumns() 
	oListView:AddColumn(ListViewColumn{30,self:oLan:WGet("Subject")})  
	oListView:AddColumn(ListViewColumn{30,self:oLan:WGet("To")})
	sTo:=String2Symbol(self:oLan:WGet("To"))
	sDesc:=String2Symbol(self:oLan:WGet("Subject")) 
		
	// fill columns: 
	// emails: {{to,subject,mailbody,attachements,seqnr},...}
	//            1     2      3           4        5
	for i:=1 to Len(self:oCaller:aEmail)
		oListViewItem := ListViewItem{}	
		//	for each	field, set the	value	in	the item 
		oListViewItem:SetText(self:oCaller:aEmail[i,1],self:sTo)  
		oListViewItem:SetValue(ConI(self:oCaller:aEmail[i,5]),self:sTo)   
		oListViewItem:SetText(self:oCaller:aEmail[i,2],self:sDesc)
		oListViewItem:Checked:=true   
		lSuccess:=oListView:AddItem(oListViewItem) 
		n:=oListView:ItemCount
	next 

	return nil

method PreInit(oParent,uExtra) class EmailConfirm
	//Put your PreInit additions here 
	self:oCaller:=uExtra
	return NIL

STATIC DEFINE EMAILCONFIRM_CANCELBUTTON := 102 
STATIC DEFINE EMAILCONFIRM_EMAILLISTVIEW := 103 
STATIC DEFINE EMAILCONFIRM_FIXEDTEXT1 := 100 
STATIC DEFINE EMAILCONFIRM_OKBUTTON := 101 
RESOURCE ResolveName DIALOGEX  4, 3, 322, 51
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Of person: ", RESOLVENAME_NAMETEXT, "Static", WS_CHILD, 6, 8, 246, 12
	CONTROL	"", RESOLVENAME_EMAILADDRESS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 6, 27, 242, 12, WS_EX_CLIENTEDGE
	CONTROL	"OK", RESOLVENAME_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 259, 3, 53, 13
	CONTROL	"Cancel", RESOLVENAME_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 259, 22, 53, 12
END

CLASS ResolveName INHERIT DataDialogMine 

	PROTECT oDCNameText AS FIXEDTEXT
	PROTECT oDCemailaddress AS SINGLELINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  export recipemail as string
STATIC DEFINE RESOLVENAME1_CANCELBUTTON := 103 
STATIC DEFINE RESOLVENAME1_EMAILADDRESS := 101 
STATIC DEFINE RESOLVENAME1_NAMETEXT := 100 
STATIC DEFINE RESOLVENAME1_OKBUTTON := 102 
METHOD CancelButton( ) CLASS ResolveName 
	self:EndWindow(false)
RETURN NIL
method Close(oEvent) class ResolveName
	super:Close(oEvent)
	//Put your changes here
	return NIL

ACCESS emailaddress() CLASS ResolveName
RETURN SELF:FieldGet(#emailaddress)

ASSIGN emailaddress(uValue) CLASS ResolveName
SELF:FieldPut(#emailaddress, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS ResolveName 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"ResolveName",_GetInst()},iCtlID)

oDCNameText := FixedText{SELF,ResourceID{RESOLVENAME_NAMETEXT,_GetInst()}}
oDCNameText:HyperLabel := HyperLabel{#NameText,"Of person: ",NULL_STRING,NULL_STRING}

oDCemailaddress := SingleLineEdit{SELF,ResourceID{RESOLVENAME_EMAILADDRESS,_GetInst()}}
oDCemailaddress:HyperLabel := HyperLabel{#emailaddress,NULL_STRING,NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{RESOLVENAME_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{RESOLVENAME_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

SELF:Caption := "Specify email address"
SELF:HyperLabel := HyperLabel{#ResolveName,"Specify email address",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS ResolveName 
local nPos as int
local lError as logic
// check valid data:
	if (nPos:=At('@',self:oDCemailaddress:TextValue))>0
		if At3('.',self:oDCemailaddress:TextValue,nPos+1)<0
			lError:=true
		endif
	else
		lError:=true
	endif
	if lError
		ErrorBox{self,self:oLan:wget("wrong mail adress")}:Show()
		self:oDCemailaddress:SetFocus()
		return
	endif
   self:recipemail:=AllTrim(self:oDCemailaddress:TextValue)
   self:EndWindow(true)
RETURN NIL
method PostInit(oParent,uExtra) class ResolveName
	//Put your PostInit additions here 
	// uExtra: recipients name 
	self:SetTexts()
	self:oDCNameText:TextValue:=self:oLan:Wget("Of person")+': '+AllTrim(uExtra) 
	return NIL

STATIC DEFINE RESOLVENAME_CANCELBUTTON := 103 
STATIC DEFINE RESOLVENAME_EMAILADDRESS := 101 
STATIC DEFINE RESOLVENAME_NAMETEXT := 100 
STATIC DEFINE RESOLVENAME_OKBUTTON := 102 
class SendEmailsDirect
	// sending of emails directly via senditquite.exe  
	// check cError to see if Init was successful
	protect emailaddress as string
	protect username as string
	protect password as string
	protect outgoingserver as string
	protect port as string
	protect protocol as string 
	export lError as logic
	export cError as string 
	export aEmail:={} as array // array with emails to be send  {{to,subject,mailbody,attachements,seqnr},...}
	protect cMailBasic as string   // string with information needed to send email  
	protect cFileContentBase as string // beginning of name of bodyfile 
	protect cbatchfile as string   // file with emails to send  
	protect oOwner as Window
	protect oLan as Language 
	protect IsSystem as logic

	
	declare method AddEmail,SendEmails

method AddEmail(subject as string,mailbody as string,aRecip as array,aFiles:={} as array) as logic class SendEmailsDirect
	// add email to he to be send emails
	// aRecip: // {{name,email,persid},...} 
	local i as int
	local cRecip as string
	local oResName as ResolveName 
	for i:=1 to Len(aRecip)
		if Empty(aRecip[i,2])
			oResName:=ResolveName{self:oOwner,aRecip[i,1]}
			oResName:Show()
			if Empty(oResName:recipemail)
				loop
			endif
			aRecip[i,2]:=oResName:recipemail
			if !Empty(aRecip[i,3]) // person known in database? 
				// update database:
				SQLStatement{'update person set email="'+oResName:recipemail+'" where persid='+ConS(aRecip[i,3]),oConn}:execute()
			endif
		endif
		cRecip+=iif(Empty(cRecip),'',',')+AllTrim(aRecip[i,2])
	next
	aadd(self:aEmail,{cRecip,subject,mailbody,implode(aFiles,','),len(self:aEmail)+1})
	return true
method Close() class SendEmailsDirect
	local i as int 
	if self:lError
		ErrorBox{,"Could not send emails"+iif(Empty(self:cError),'',': '+self:cError)}:Show() 
	else
		i:=Len(self:aEmail)
		TextBox{self:oOwner,"Sending of emails",Str(i,-1)+' '+"email"+iif(i>1,'s have',' has')+" been sent"}:Show()
	endif
/*	// remove batch file:
	if !Empty(self:cbatchfile)
		FileSpec{self:cbatchfile}:DELETE()
	endif 
	//	remove body	content files	
	for i:=1 to Len(self:aEmail)
		FileSpec{self:cFileContentBase+Str(i,-1)+'.html'}:DELETE()
	next  */
	

	return 

Method Init(oWindow,lSystem) class SendEmailsDirect 
	// initialize direct emailing
	// lSystem: true: system message to system administrator
	//          false: normal email from user
	local oSel as SQLSelect
	local oEditAccount as EditEmailAccount 
	Default(@lSystem,false)
	self:oLan:=Language{} 
	self:oOwner:=oWindow 
	self:IsSystem:=lSystem
	if lSystem
		self:emailaddress:= "wycliffeofficesystem@gmail.com"
		self:username:="wycliffeofficesystem@gmail.com"
		self:password:=GetWosmasterPwd()
		self:outgoingserver:="smtp.gmail.com"
		self:port:="587"
		self:protocol:="ssl" 
	else		
		oSel:=SqlSelect{'select emailaddress,username,cast('+Crypt_Emp(false,"password")+' as char) as password,protocol,outgoingserver,port from mailaccount where empid='+MyEmpID,oConn}
		if oSel:RecCount<1
			// let user specify his mailaccount data:
			oEditAccount:=EditEmailAccount{} 
			oEditAccount:Show()
			if !oEditAccount:lSuccess 
				self:cError:=self:oLan:WGet("No email account settings available")
				self:lError:=true
				return self
			endif			
			oSel:Execute()
			if oSel:RecCount<1
				self:lError:=true
				self:cError:=self:oLan:WGet("No email account settings available")
				return self
			endif 
		endif
		// existing mail account:
		// fill fields: 
		self:emailaddress:= oSel:emailaddress
		self:username:=oSel:username
		self:password:=oSel:password
		self:outgoingserver:=oSel:outgoingserver
		self:port:=ConS(oSel:port)
		self:protocol:=oSel:protocol 
	endif
	GetHelpDir()
	self:cMailBasic:='"'+HelpDir+'\senditquiet.exe" -s '+self:outgoingserver+" -port "+self:port+" -u "+self:username+iif(Empty(self:protocol),""," -protocol "+self:protocol)+" -p "+self:password+" -f "+self:emailaddress
	return self 
method SendEmails(lConfirm:=false as logic) as logic class SendEmailsDirect 
	// The actually sending of the emails to the outgoing server
	// Option: lConfirm=true: show emails to the user with the options to cancel all, to remove some
	local i,m,nRet as int
	local cFileContent as string
	local cbatchfile as string 
	local oFilespecB as FileSpec
	local ptrHandleBatch,ptrHandleBody as ptr
	local oConfirm as EmailConfirm
	local oTCPIP as TCPIP  

	if lConfirm
		oConfirm:=EmailConfirm{,self}
		oConfirm:Show()
		if oConfirm:lSend=false
			self:lError:=true
			self:cError:=self:oLan:WGet("Email cancelled")
			return false
		endif
	endif

	// send emails
	if Len(self:aEmail)=0 
		self:lError:=true
		self:cError:=self:oLan:WGet("Nothing to send")
		return true
	endif
	GetHelpDir()
	cbatchfile:=HelpDir+'\'+"batchmail.vbs"
	self:cFileContentBase:=HelpDir+'\'+"mailbody"
	// remove previous batch file:
	if FileSpec{cbatchfile}:Find()
		FErase(cbatchfile)
	endif
	// remove mailbody files:
	AEval(Directory(HelpDir+"\mailbody*.html"), {|aFile|FErase(HelpDir+"\"+aFile[F_NAME])})
	//
	ptrHandleBatch := MakeFile(self,@cbatchfile,"Creating batch file for mailing")
	IF ptrHandleBatch = F_ERROR .or. Empty(ptrHandleBatch)
		self:cError:=self:oLan:WGet("Couldn't compose email")
		self:lError:=true
		return false 
	ENDIF
	self:cbatchfile:=cbatchfile
	FWriteLine(ptrHandleBatch,'Set WshShell = CreateObject("WScript.Shell")')
	// aEmail:  {{to,subject,mailbody,attachements},...}
	//             1    2       3           4
	for i:=1 to Len(self:aEmail)
		cFileContent:=self:cFileContentBase+Str(i,-1)+".html"
		ptrHandleBody := MakeFile(self,@cFileContent,"Creating mailbody file")
		IF ptrHandleBody = F_ERROR .or. Empty(ptrHandleBody)
			self:lError:=true
			self:cError:=self:oLan:WGet("Couldn't compose email")
			return false 
		endif
		m:= FWriteLineUni(ptrHandleBody,StrTran(self:aEmail[i,3],CRLF,'<br>'))
		FClose(ptrHandleBody) 
		oFilespecB:=FileSpec{cFileContent} 
		if oFilespecB:Find()             
			FWriteLine(ptrHandleBatch,'return = WshShell.Run("'+StrTran(self:cMailBasic+' -t '+self:aEmail[i,1]+' -subject "'+self:aEmail[i,2]+'" -bodyfile "'+cFileContent+'" '+;
				iif(Empty(self:aEmail[i,4]),"",' -files "'+self:aEmail[i,4]+'" '),'"','""')+'",0)')
			// 				iif(Empty(self:aEmail[i,4]),"",'" -files "'+self:aEmail[i,4]+'"'),'"','""')+'",0'+iif(i=1,',true','')+')')
		else
			self:lError:=true
			self:cError:=self:oLan:WGet("Couldn't compose email")
			return false
		endif
	next
	FWriteLine(ptrHandleBatch,'Set WshShell = Nothing')
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
	// test internet available:
	oTCPIP:=TCPIP{}
	oTCPIP:timeout:=2000
	oTCPIP:Ping('www.google.com')
	if AtC("timeout",oTCPIP:Response)>0
		self:lError:=true
		self:cError:=self:oLan:WGet("No internet connection")
		return false
	endif
	// 	if	FileSpec{self:cbatchfile}:Find()	
	nRet:=FileStart(self:cbatchfile,self:oOwner)
	if nRet>0 .and. nRet<33
		self:lError:=true 
		self:cError:=self:oLan:WGet("Email send failed")+': '+Str(nRet,-1)			
		return false
	endif					
	// 	endif

	return true