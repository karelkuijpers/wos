CLASS HelpAbout INHERIT DialogWinDowExtra 

	PROTECT oDCtheFixedIcon1 AS FIXEDICON
	PROTECT oDCtheFixedText1 AS FIXEDTEXT
	PROTECT oDCVersionText AS FIXEDTEXT
	PROTECT oDCtheFixedText3 AS FIXEDTEXT
	PROTECT oCCPushButton1 AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
RESOURCE HelpAbout DIALOGEX  86, 131, 247, 84
STYLE	DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"About Wycliffe Office System"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"#101", HELPABOUT_THEFIXEDICON1, "Static", SS_ICON|WS_CHILD, 10, 11, 27, 24, WS_EX_STATICEDGE
	CONTROL	"Wycliffe Office System", HELPABOUT_THEFIXEDTEXT1, "Static", SS_NOPREFIX|SS_LEFTNOWORDWRAP|WS_CHILD, 52, 11, 184, 12
	CONTROL	"Version 2.5.0 dd 2008-03-28", HELPABOUT_VERSIONTEXT, "Static", SS_NOPREFIX|SS_LEFTNOWORDWRAP|WS_CHILD, 49, 22, 143, 13
	CONTROL	"© 1987-2013 Wycliffe Global Alliance", HELPABOUT_THEFIXEDTEXT3, "Static", SS_NOPREFIX|SS_LEFTNOWORDWRAP|WS_CHILD, 51, 41, 150, 15
	CONTROL	"OK", HELPABOUT_PUSHBUTTON1, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 98, 62, 53, 15
END

METHOD Init(oParent,uExtra) CLASS HelpAbout 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"HelpAbout",_GetInst()},TRUE)

oDCtheFixedIcon1 := FIXEDICON{SELF,ResourceID{HELPABOUT_THEFIXEDICON1,_GetInst()}}
oDCtheFixedIcon1:HyperLabel := HyperLabel{#theFixedIcon1,"#101",NULL_STRING,NULL_STRING}

oDCtheFixedText1 := FixedText{SELF,ResourceID{HELPABOUT_THEFIXEDTEXT1,_GetInst()}}
oDCtheFixedText1:HyperLabel := HyperLabel{#theFixedText1,"Wycliffe Office System",NULL_STRING,NULL_STRING}

oDCVersionText := FixedText{SELF,ResourceID{HELPABOUT_VERSIONTEXT,_GetInst()}}
oDCVersionText:HyperLabel := HyperLabel{#VersionText,"Version 2.5.0 dd 2008-03-28",NULL_STRING,NULL_STRING}

oDCtheFixedText3 := FixedText{SELF,ResourceID{HELPABOUT_THEFIXEDTEXT3,_GetInst()}}
oDCtheFixedText3:HyperLabel := HyperLabel{#theFixedText3,"© 1987-2013 Wycliffe Global Alliance",NULL_STRING,NULL_STRING}

oCCPushButton1 := PushButton{SELF,ResourceID{HELPABOUT_PUSHBUTTON1,_GetInst()}}
oCCPushButton1:HyperLabel := HyperLabel{#PushButton1,"OK",NULL_STRING,NULL_STRING}

SELF:Caption := "About Wycliffe Office System"
SELF:HyperLabel := HyperLabel{#HelpAbout,"About Wycliffe Office System",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

method PostInit(oParent,uExtra) class HelpAbout
	//Put your PostInit additions here 
	self:SetTexts()
// 	self:oDCVersionText:TextValue:="Version: "+Version+" d.d. "+DToC(SToD(Versiondate))
	self:oDCVersionText:TextValue:="Version: "+Version+" d.d. "+DToC(SToD(SubStr(Versiondate,1,8)))+SubStr(Versiondate,9)
	
	return NIL
method PushButton1() class HelpAbout

	self:EndDialog()
	
STATIC DEFINE HELPABOUT_PUSHBUTTON1 := 104 
STATIC DEFINE HELPABOUT_THEFIXEDICON1 := 100 
STATIC DEFINE HELPABOUT_THEFIXEDTEXT1 := 101 
STATIC DEFINE HELPABOUT_THEFIXEDTEXT3 := 103 
STATIC DEFINE HELPABOUT_VERSIONTEXT := 102 
resource IDI_STANDARDICON icon c:\CAVO28\wins.ico
STATIC DEFINE MAILDLG_PBCANCEL := 101 
STATIC DEFINE MAILDLG_PBSEND := 102 
STATIC DEFINE MAILDLG_RICHEDIT1 := 100 
