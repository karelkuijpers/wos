define __APPWIZ__MODSPLASHSCREEN := true
class SplashScreen inherit DIALOGWINDOW 

	protect oDCSplashText as FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
RESOURCE SplashScreen DIALOGEX  28, 14, 262, 229
STYLE	DS_3DLOOK|DS_CENTER|WS_POPUP
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"WycSplash", SPLASHSCREEN_WYCSPLASH, "Static", SS_LEFTNOWORDWRAP|SS_RIGHT|WS_CHILD, 0, 0, 264, 219
	CONTROL	"Wycliffe Office System", SPLASHSCREEN_SPLASHTEXT, "Static", SS_CENTER|WS_CHILD, 0, 219, 261, 11, WS_EX_STATICEDGE
END

method Init(oParent,uExtra) class SplashScreen 
local dim aFonts[1] AS OBJECT

self:PreInit(oParent,uExtra)

super:Init(oParent,ResourceID{"SplashScreen",_GetInst()},FALSE)

aFonts[1] := Font{,10,"MS Sans Serif"}
aFonts[1]:Bold := TRUE

oDCSplashText := FixedText{self,ResourceID{SPLASHSCREEN_SPLASHTEXT,_GetInst()}}
oDCSplashText:HyperLabel := HyperLabel{#SplashText,"Wycliffe Office System",NULL_STRING,NULL_STRING}
oDCSplashText:Font(aFonts[1], FALSE)

self:Caption := "Dialog Caption"
self:HyperLabel := HyperLabel{#SplashScreen,"Dialog Caption",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD Show(kShowState) CLASS SplashScreen
	SUPER:show(kShowState)
	// Make window topmost
	SetWindowPos(SELF:handle(), HWND_TOPMOST, 0, 0, 0, 0, _Or(SWP_NOSIZE, SWP_NOMOVE))
	// Register Timer
	SELF:RegisterTimer(3, TRUE)
	// Remove the following two lines if you don't want to show the Splashscreen separatly
	GetAppObject():Exec(EXECWHILEEVENT)
	Sleep(1000)
	RETURN NIL

method Timer() class SplashScreen
	self:Destroy()
STATIC DEFINE SPLASHSCREEN_SPLASHTEXT := 101 
STATIC DEFINE SPLASHSCREEN_WYCSPLASH := 100 
resource WYCSPLASH bitmap C:\cavo28\WYCSPLASH.bmp
