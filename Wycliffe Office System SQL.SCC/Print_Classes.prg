RESOURCE _PrintDialog DIALOGEX  16, 31, 346, 133
STYLE	DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Report"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", _PRINTDIALOG_PRINTERTEXT, "Static", WS_CHILD, 70, 19, 190, 21
	CONTROL	"Destination", _PRINTDIALOG_DESTINATION, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 16, 11, 256, 61
	CONTROL	"&Printer", _PRINTDIALOG_PRINTERRADIOBUTTON, "Button", BS_RADIOBUTTON|WS_TABSTOP|WS_CHILD, 20, 19, 40, 11
	CONTROL	"&Screen", _PRINTDIALOG_SCREENRADIOBUTTON, "Button", BS_RADIOBUTTON|WS_TABSTOP|WS_CHILD, 20, 36, 43, 12
	CONTROL	"&File", _PRINTDIALOG_TOFILERADIOBUTTON, "Button", BS_RADIOBUTTON|WS_TABSTOP|WS_CHILD, 20, 53, 30, 11
	CONTROL	"File type", _PRINTDIALOG_FILETYPE, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|NOT WS_VISIBLE, 70, 44, 104, 22
	CONTROL	"Text file", _PRINTDIALOG_FILETYPE1, "Button", BS_RADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 76, 53, 40, 11
	CONTROL	"Spreadsheet", _PRINTDIALOG_FILETYPE2, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 120, 53, 53, 11
	CONTROL	"Page Range", _PRINTDIALOG_PAGERANGE, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 16, 77, 148, 49
	CONTROL	"All", _PRINTDIALOG_ALLBUTTON, "Button", BS_RADIOBUTTON|WS_TABSTOP|WS_CHILD, 25, 88, 80, 11
	CONTROL	"Selection", _PRINTDIALOG_SELECTIONBUTTON, "Button", BS_RADIOBUTTON|WS_TABSTOP|WS_CHILD, 25, 106, 48, 11
	CONTROL	"", _PRINTDIALOG_FROMPAGE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 78, 105, 28, 12
	CONTROL	"", _PRINTDIALOG_TOPAGE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 124, 105, 28, 12
	CONTROL	"O&K", _PRINTDIALOG_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 284, 16, 54, 13
	CONTROL	"Can&cel", _PRINTDIALOG_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 284, 35, 54, 14
	CONTROL	"Set&up", _PRINTDIALOG_SETUPBUTTON, "Button", WS_TABSTOP|WS_CHILD, 284, 55, 54, 13
	CONTROL	"__", _PRINTDIALOG_FIXEDTEXT1, "Static", WS_CHILD, 110, 103, 10, 12
	CONTROL	"Choose Font", _PRINTDIALOG_FONTDIALOGBUTTON, "Button", WS_TABSTOP|WS_CHILD, 284, 77, 54, 12
END

CLASS _PrintDialog INHERIT DialogWinDowExtra 

	PROTECT oDCPrinterText as FIXEDTEXT
	PROTECT oDCDestination as RADIOBUTTONGROUP
	PROTECT oCCPrinterRadioButton as RADIOBUTTON
	PROTECT oCCScreenRadioButton as RADIOBUTTON
	PROTECT oCCToFileRadioButton as RADIOBUTTON
	PROTECT oDCFileType as RADIOBUTTONGROUP
	PROTECT oCCfiletype1 as RADIOBUTTON
	PROTECT oCCfiletype2 as RADIOBUTTON
	PROTECT oDCPageRange as RADIOBUTTONGROUP
	PROTECT oCCAllButton as RADIOBUTTON
	PROTECT oCCSelectionButton as RADIOBUTTON
	PROTECT oDCFromPage as SINGLELINEEDIT
	PROTECT oDCToPage as SINGLELINEEDIT
	PROTECT oCCOkButton as PUSHBUTTON
	PROTECT oCCCancelButton as PUSHBUTTON
	PROTECT oCCSetupButton as PUSHBUTTON
	PROTECT oDCFixedText1 as FIXEDTEXT
	PROTECT oCCFontDialogButton as PUSHBUTTON

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	PROTECT oDialFont as myDialFontDialog
	EXPORT lPrintOk as LOGIC
	EXPORT MaxWidth := 79 as int
	EXPORT ToFileFS as FileSpec
	EXPORT oPrinter	as PrintingDevice
	EXPORT oPrintJob as PrintJob
	EXPORT Heading as STRING
	EXPORT Label as LOGIC
	EXPORT Destination as STRING
	EXPORT oRange, oOrigRange as Range
	EXPORT Pagetext as STRING
	PROTECT _Beginreport:=FALSE as LOGIC
	PROTECT row:=0 as int
	Protect Page:=0 as int
	EXPORT Extension as STRING 
	Protect ptrHandle
	Protect LanguageDefault as string
	Protect LanguageRus as string
	Protect LanguageJap as string
	Protect LanguageCZ as string
	Protect LanguageTHD as string
	Protect cRTFHeader as STRING
	Protect RTFFormat as string
	Export lRTF,lXls,lSuspend as logic 
	Protect saveRow:=0 as int
	Protect savePage:=0 as int 
	Protect saveBeginReport as logic
	protect FiFoPtr:=0 as int
METHOD ButtonClick(oControlEvent) CLASS _PrintDialog
	LOCAL oControl AS Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:NameSym == #SelectionButton
		oDCFromPage:Show()
		oDCToPage:Show()
		oDCFixedText1:Show()
	ELSEIF oControl:NameSym == #AllButton
		oDCFromPage:Hide()
		oDCToPage:Hide()
		oDCFixedText1:Hide()
	ELSEIF oControl:NameSym == #ScreenRadioButton
		oCCFontDialogButton:Show()
		self:ShowFileType()
	ELSEIF oControl:NameSym == #PrinterRadioButton
		oCCFontDialogButton:Hide()
		self:ShowFileType()
	ELSEIF oControl:NameSym == #ToFileRadioButton
		oCCFontDialogButton:Hide() 
		self:ShowFileType()		
	ENDIF
	
	RETURN NIL
METHOD Close(oEvent) CLASS _PrintDialog
	SUPER:Close(oEvent)
	//Put your changes here
	SetDecimalSep(Asc('.'))
SELF:Destroy()
	RETURN NIL

METHOD FontDialogbutton( ) CLASS _PrintDialog
LOCAL nRet AS INT	
	(nRet:=oDialFont:Show())
	IF nRet=0
		SELF:lPrintOk := FALSE
	ELSE
	 	oDialFont:Font:PitchFixed := TRUE
	ENDIF
RETURN NIL
METHOD Init(oParent,uExtra) CLASS _PrintDialog 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"_PrintDialog",_GetInst()},TRUE)

oDCPrinterText := FixedText{SELF,ResourceID{_PRINTDIALOG_PRINTERTEXT,_GetInst()}}
oDCPrinterText:HyperLabel := HyperLabel{#PrinterText,NULL_STRING,NULL_STRING,NULL_STRING}

oCCPrinterRadioButton := RadioButton{SELF,ResourceID{_PRINTDIALOG_PRINTERRADIOBUTTON,_GetInst()}}
oCCPrinterRadioButton:HyperLabel := HyperLabel{#PrinterRadioButton,_chr(38)+"Printer",NULL_STRING,NULL_STRING}

oCCScreenRadioButton := RadioButton{SELF,ResourceID{_PRINTDIALOG_SCREENRADIOBUTTON,_GetInst()}}
oCCScreenRadioButton:HyperLabel := HyperLabel{#ScreenRadioButton,_chr(38)+"Screen",NULL_STRING,NULL_STRING}

oCCToFileRadioButton := RadioButton{SELF,ResourceID{_PRINTDIALOG_TOFILERADIOBUTTON,_GetInst()}}
oCCToFileRadioButton:HyperLabel := HyperLabel{#ToFileRadioButton,_chr(38)+"File",NULL_STRING,NULL_STRING}

oCCfiletype1 := RadioButton{SELF,ResourceID{_PRINTDIALOG_FILETYPE1,_GetInst()}}
oCCfiletype1:HyperLabel := HyperLabel{#filetype1,"Text file",NULL_STRING,NULL_STRING}

oCCfiletype2 := RadioButton{SELF,ResourceID{_PRINTDIALOG_FILETYPE2,_GetInst()}}
oCCfiletype2:HyperLabel := HyperLabel{#filetype2,"Spreadsheet",NULL_STRING,NULL_STRING}

oCCAllButton := RadioButton{SELF,ResourceID{_PRINTDIALOG_ALLBUTTON,_GetInst()}}
oCCAllButton:HyperLabel := HyperLabel{#AllButton,"All",NULL_STRING,NULL_STRING}

oCCSelectionButton := RadioButton{SELF,ResourceID{_PRINTDIALOG_SELECTIONBUTTON,_GetInst()}}
oCCSelectionButton:HyperLabel := HyperLabel{#SelectionButton,"Selection",NULL_STRING,NULL_STRING}

oDCFromPage := SingleLineEdit{SELF,ResourceID{_PRINTDIALOG_FROMPAGE,_GetInst()}}
oDCFromPage:Picture := "9999"
oDCFromPage:HyperLabel := HyperLabel{#FromPage,NULL_STRING,NULL_STRING,NULL_STRING}

oDCToPage := SingleLineEdit{SELF,ResourceID{_PRINTDIALOG_TOPAGE,_GetInst()}}
oDCToPage:Picture := "9999"
oDCToPage:HyperLabel := HyperLabel{#ToPage,NULL_STRING,NULL_STRING,NULL_STRING}

oCCOkButton := PushButton{SELF,ResourceID{_PRINTDIALOG_OKBUTTON,_GetInst()}}
oCCOkButton:HyperLabel := HyperLabel{#OkButton,"O"+_chr(38)+"K",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{_PRINTDIALOG_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Can"+_chr(38)+"cel",NULL_STRING,NULL_STRING}

oCCSetupButton := PushButton{SELF,ResourceID{_PRINTDIALOG_SETUPBUTTON,_GetInst()}}
oCCSetupButton:HyperLabel := HyperLabel{#SetupButton,"Set"+_chr(38)+"up",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{_PRINTDIALOG_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"__",NULL_STRING,NULL_STRING}

oCCFontDialogButton := PushButton{SELF,ResourceID{_PRINTDIALOG_FONTDIALOGBUTTON,_GetInst()}}
oCCFontDialogButton:HyperLabel := HyperLabel{#FontDialogButton,"Choose Font",NULL_STRING,NULL_STRING}

oDCDestination := RadioButtonGroup{SELF,ResourceID{_PRINTDIALOG_DESTINATION,_GetInst()}}
oDCDestination:FillUsing({ ;
							{oCCPrinterRadioButton,"Printer"}, ;
							{oCCScreenRadioButton,"Screen"}, ;
							{oCCToFileRadioButton,"File"}, ;
							{oCCfiletype1,"txt"}, ;
							{oCCfiletype2,"xls"} ;
							})
oDCDestination:HyperLabel := HyperLabel{#Destination,"Destination",NULL_STRING,NULL_STRING}

oDCFileType := RadioButtonGroup{SELF,ResourceID{_PRINTDIALOG_FILETYPE,_GetInst()}}
oDCFileType:FillUsing({ ;
						{oCCfiletype1,"txt"}, ;
						{oCCfiletype2,"xls"} ;
						})
oDCFileType:HyperLabel := HyperLabel{#FileType,"File type",NULL_STRING,NULL_STRING}

oDCPageRange := RadioButtonGroup{SELF,ResourceID{_PRINTDIALOG_PAGERANGE,_GetInst()}}
oDCPageRange:FillUsing({ ;
							{oCCAllButton,"All"}, ;
							{oCCSelectionButton,"Selection"} ;
							})
oDCPageRange:HyperLabel := HyperLabel{#PageRange,"Page Range",NULL_STRING,NULL_STRING}

SELF:Caption := "Report"
SELF:HyperLabel := HyperLabel{#_PrintDialog,"Report",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OkButton( ) CLASS _PrintDialog 
METHOD PostInit() CLASS _PrintDialog
	//Put your PostInit additions here
	LOCAL scrFont as myFont 
	self:SetTexts()
	/*	if self:Label
	oDCDestination:Value := "Printer"
	else		
	oDCDestination:Value := "Screen"
	endif  */
	self:oCCScreenRadioButton:Value:=true
	oDCPageRange:Value := "All"
	oDCFromPage:Hide()
	oDCToPage:Hide()
	oDCFixedText1:Hide()
	oDialFont:=myDialFontDialog{SELF}
	oDialFont:EnableFixedPitch(TRUE)
	//scrFont:=myFont{,10}
	scrFont:=myFont{FONTMODERN,10,"Courier New"}
	//scrFont:SetPointSize(Round((80/SELF:MaxWidth)*10,0))
	scrFont:SetCharSet(1)
	//scrFont:Bold:=TRUE
	scrFont:PitchFixed := TRUE
	oDialFont:SetFont(scrFont)
	self:oDCFileType:FillUsing({{self:oCCfiletype1,"txt"},{self:oCCfiletype2,"xls"}}) 
	self:oDCDestination:FillUsing({{self:oCCPrinterRadioButton,"Printer"},{self:oCCScreenRadioButton,"Screen"},{self:oCCToFileRadioButton,"File"}}) 

	RETURN NIL
method PreInit(oParent,uExtra) class _PrintDialog
	//Put your PreInit additions here 
	self:LanguageDefault:="{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fswiss\fprq2\fcharset0 Arial;}{\f1\fmodern\fprq1\fcharset0 Courier New;}}"
	self:LanguageRus:="{\rtf1\ansi\ansicpg1251\deff0\deflang1049{\fonttbl{\f0\fmodern\fprq1\fcharset0 Courier New;}{\f1\fmodern\fprq1\fcharset204{\*\fname Courier New;}Courier New CYR;}}"
	self:LanguageJap:="{\rtf1\ansi\ansicpg932\deff0\deflang1033\deflangfe1041{\fonttbl{\f0\fmodern\fprq1\fcharset0 Courier New;}{\f1\fmodern\fprq1\fcharset128 \'82\'6c\'82\'72 \'83\'53\'83\'56\'83\'62\'83\'4e;}}"
	self:LanguageCZ:="{\rtf1\ansi\deff0{\fonttbl{\f1\fnil\fcharset238{\*\fname Courier New;}Courier New CE;}}"
	self:LanguageTHD:="{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fprq2\fcharset0 Courier New;}{\f1\fmodern\fprq1\fcharset222 Courier New;}}"
	self:RTFFormat:= "{\colortbl ;\red255\green0\blue0;\red255\green255\blue0;\red0\green255\blue0;\red175\green238\blue238;}\widowctrl\viewkind1\viewzk1\uc1\pard\paperw16838\paperh11906\lndscpsxn\margl1400\margr1200\margt600\margb600\f1\fs"
	
	return nil

STATIC DEFINE _PRINTDIALOG_ALLBUTTON := 109 
STATIC DEFINE _PRINTDIALOG_CANCELBUTTON := 114 
STATIC DEFINE _PRINTDIALOG_DESTINATION := 101 
STATIC DEFINE _PRINTDIALOG_FILETYPE := 105 
STATIC DEFINE _PRINTDIALOG_FILETYPE1 := 106 
STATIC DEFINE _PRINTDIALOG_FILETYPE2 := 107 
STATIC DEFINE _PRINTDIALOG_FIXEDTEXT1 := 116 
STATIC DEFINE _PRINTDIALOG_FONTDIALOGBUTTON := 117 
STATIC DEFINE _PRINTDIALOG_FROMPAGE := 111 
STATIC DEFINE _PRINTDIALOG_OKBUTTON := 113 
STATIC DEFINE _PRINTDIALOG_PAGERANGE := 108 
STATIC DEFINE _PRINTDIALOG_PRINTERRADIOBUTTON := 102 
STATIC DEFINE _PRINTDIALOG_PRINTERTEXT := 100 
STATIC DEFINE _PRINTDIALOG_SCREENRADIOBUTTON := 103 
STATIC DEFINE _PRINTDIALOG_SELECTIONBUTTON := 110 
STATIC DEFINE _PRINTDIALOG_SETUPBUTTON := 115 
STATIC DEFINE _PRINTDIALOG_TOFILERADIOBUTTON := 104 
STATIC DEFINE _PRINTDIALOG_TOPAGE := 112 
STATIC DEFINE _PRINTERDIALOG_CANCELBUTTON := 105 
STATIC DEFINE _PRINTERDIALOG_CURRENTPRINTERTEXT := 101 
STATIC DEFINE _PRINTERDIALOG_OKBUTTON := 104 
STATIC DEFINE _PRINTERDIALOG_PRINTERLISTBOX := 103 
STATIC DEFINE _PRINTERDIALOG_SETUPBUTTON := 106 
STATIC DEFINE _PRINTERDIALOG_THEFIXEDTEXT1 := 100
STATIC DEFINE _PRINTERDIALOG_THEGROUPBOX1 := 102 
DEFINE ACCEPT_START := "#22#"
RESOURCE AcceptFormat DIALOGEX  8, 7, 269, 107
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"New", ACCEPTFORMAT_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 129, 11, 53, 13
	CONTROL	"Edit", ACCEPTFORMAT_EDITBUTTON, "Button", WS_TABSTOP|WS_CHILD, 128, 30, 54, 13
	CONTROL	"Specifation text", ACCEPTFORMAT_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 1, 190, 53
	CONTROL	"OK", ACCEPTFORMAT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 205, 65, 53, 12
	CONTROL	"Cancel", ACCEPTFORMAT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 205, 82, 53, 12
	CONTROL	"", ACCEPTFORMAT_BRIEVEN, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 13, 12, 107, 72
	CONTROL	"Contents", ACCEPTFORMAT_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 64, 190, 30
	CONTROL	"Amount on OLA", ACCEPTFORMAT_M12_BD, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 12, 75, 80, 11
END

class AcceptFormat inherit DataDialogMine 

	protect oCCNewButton as PUSHBUTTON
	protect oCCEditButton as PUSHBUTTON
	protect oDCGroupBox3 as GROUPBOX
	protect oCCOKButton as PUSHBUTTON
	protect oCCCancelButton as PUSHBUTTON
	protect oDCBrieven as COMBOBOX
	protect oDCGroupBox1 as GROUPBOX
	protect oDCm12_bd as CHECKBOX
	instance Brieven 
	instance m12_bd 

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT lCancel AS LOGIC
  EXPORT brief AS STRING
  EXPORT Lettername AS STRING
access Brieven() class AcceptFormat
return self:FieldGet(#Brieven)

assign Brieven(uValue) class AcceptFormat
self:FieldPut(#Brieven, uValue)
return Brieven := uValue

METHOD CancelButton( ) CLASS AcceptFormat
	SELF:EndWindow()
	lCancel := TRUE
	RETURN SELF
METHOD EditButton( ) CLASS AcceptFormat
LOCAL oMark AS MarkupLetter
oMark:= MarkupLetter{SELF,brieven}
oMark:Show()
	
RETURN
method Init(oWindow,iCtlID,oServer,uExtra) class AcceptFormat 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

super:Init(oWindow,ResourceID{"AcceptFormat",_GetInst()},iCtlID)

oCCNewButton := PushButton{self,ResourceID{ACCEPTFORMAT_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}
oCCNewButton:TooltipText := "Add new text"

oCCEditButton := PushButton{self,ResourceID{ACCEPTFORMAT_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:TooltipText := "Edit a letter"

oDCGroupBox3 := GroupBox{self,ResourceID{ACCEPTFORMAT_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"Specifation text",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{self,ResourceID{ACCEPTFORMAT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{self,ResourceID{ACCEPTFORMAT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCBrieven := combobox{self,ResourceID{ACCEPTFORMAT_BRIEVEN,_GetInst()}}
oDCBrieven:HyperLabel := HyperLabel{#Brieven,NULL_STRING,NULL_STRING,NULL_STRING}
oDCBrieven:FillUsing(Self:ListFiles( ))

oDCGroupBox1 := GroupBox{self,ResourceID{ACCEPTFORMAT_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Contents",NULL_STRING,NULL_STRING}

oDCm12_bd := CheckBox{self,ResourceID{ACCEPTFORMAT_M12_BD,_GetInst()}}
oDCm12_bd:HyperLabel := HyperLabel{#m12_bd,"Amount on OLA",NULL_STRING,NULL_STRING}

self:Caption := "Specification of acceptgiro"
self:HyperLabel := HyperLabel{#AcceptFormat,"Specification of acceptgiro",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	self:Use(oServer)
endif

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListFiles(mExt) CLASS AcceptFormat
LOCAL brieven:={} AS ARRAY
Default(@mExt,"acc")
AEval(Directory(CurPath+"\*."+mExt),{|x| AAdd(brieven,{SubStr(x[F_NAME],1,RAt(".",x[F_NAME])-1),x[F_NAME]})})

RETURN brieven
access m12_bd() class AcceptFormat
return self:FieldGet(#m12_bd)

assign m12_bd(uValue) class AcceptFormat
self:FieldPut(#m12_bd, uValue)
return m12_bd := uValue

METHOD NewButton( ) CLASS AcceptFormat
LOCAL oMark AS MarkupLetter
oMark:= MarkupLetter{SELF,".acc"}
oMark:Show()

oDCBrieven:FillUsing(SELF:ListFiles("acc"))
SELF:oDCBrieven:Value:=SELF:LetterName
RETURN
METHOD OKButton( ) CLASS AcceptFormat
	LOCAL cRoot := "WYC\Runtime" AS STRING
	LOCAL m96_regels AS INT
	LOCAL brief_breedte:= 35 AS INT
	IF !Empty(oDCBrieven:TextValue)

		brief:=MemoRead(brieven)
		m96_regels:=MLCount(brief,brief_breedte)
		IF m96_regels > 3
   			(errorbox{SELF,'Too many lines in message text'}):show()
			RETURN
		ENDIF
	ELSE
		brief:=NULL_STRING
	ENDIF
	* save stettings in the registry:
	SetRTRegInt( cRoot, "AccAmount", if(m12_bd,1,0) )
	SetRTRegString( cRoot, "AccBrief", oDCBrieven:Value )
	SELF:EndWindow()
RETURN NIL
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS AcceptFormat
	//Put your PostInit additions here
*    SELF:oDCBrieven:ListFiles("*.brf")
	self:SetTexts()
	SaveUse(self)
	m12_bd := if(WycIniFS:GetInt( "Runtime", "AccAmount" )==1,true,FALSE)
	Brieven := WycIniFS:Getstring("Runtime", "AccBrief" )
	IF Empty(Brieven)
	    SELF:oDCBrieven:CurrentItemNo:=1
	ELSE
	    SELF:oDCBrieven:value:=Brieven
		IF SELF:oDCBrieven:CurrentItemNo==0
		    SELF:oDCBrieven:CurrentItemNo:=1
		ENDIF
	ENDIF
	RETURN NIL
STATIC DEFINE ACCEPTFORMAT_BRIEVEN := 105 
STATIC DEFINE ACCEPTFORMAT_CANCELBUTTON := 104 
STATIC DEFINE ACCEPTFORMAT_EDITBUTTON := 101 
STATIC DEFINE ACCEPTFORMAT_GROUPBOX1 := 106 
STATIC DEFINE ACCEPTFORMAT_GROUPBOX3 := 102 
STATIC DEFINE ACCEPTFORMAT_M12_BD := 107 
STATIC DEFINE ACCEPTFORMAT_NEWBUTTON := 100 
STATIC DEFINE ACCEPTFORMAT_OKBUTTON := 103 
class AskLetterName inherit DialogWinDowExtra 

	protect oDCLettername as SINGLELINEEDIT
	protect oDCFixedText1 as FIXEDTEXT
	protect oCCOKButton as PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT cName AS STRING
  PROTECT cExt AS STRING
RESOURCE AskLetterName DIALOGEX  19, 50, 263, 33
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Give name of textformat to save"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", ASKLETTERNAME_LETTERNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 56, 11, 132, 13, WS_EX_CLIENTEDGE
	CONTROL	"Format name:", ASKLETTERNAME_FIXEDTEXT1, "Static", WS_CHILD, 7, 12, 45, 12
	CONTROL	"OK", ASKLETTERNAME_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 206, 11, 53, 13
END

METHOD Close(oEvent) CLASS AskLetterName
	SUPER:Close(oEvent)
	//Put your changes here
SELF:Destroy()
	RETURN NIL

method Init(oParent,uExtra) class AskLetterName 

self:PreInit(oParent,uExtra)

super:Init(oParent,ResourceID{"AskLetterName",_GetInst()},TRUE)

oDCLettername := SingleLineEdit{self,ResourceID{ASKLETTERNAME_LETTERNAME,_GetInst()}}
oDCLettername:HyperLabel := HyperLabel{#Lettername,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{self,ResourceID{ASKLETTERNAME_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Format name:",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{self,ResourceID{ASKLETTERNAME_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

self:Caption := "Give name of textformat to save"
self:HyperLabel := HyperLabel{#AskLetterName,"Give name of textformat to save",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS AskLetterName
	IF Empty(oDCLettername:TEXTValue)
		(Errorbox{SELF,"Name of letter is mandatory!"}):Show()
		RETURN
	ENDIF
	cName:=StrTran(AllTrim(oDCLettername:TEXTValue)," ","_")
	
	IF At(".",cName)>0
		cName:=SubStr(cName,1,At(".",cName)-1)
	ENDIF
	cName:=cName+"."+self:cExt
	SELF:EndDialog()
METHOD PostInit(oParent,uExtra) CLASS AskLetterName
	//Put your PostInit additions here
	self:SetTexts()
	Default(@uExtra,"brf")
	cExt:=uExtra
	RETURN NIL
STATIC DEFINE ASKLETTERNAME_FIXEDTEXT1 := 101 
STATIC DEFINE ASKLETTERNAME_LETTERNAME := 100 
STATIC DEFINE ASKLETTERNAME_OKBUTTON := 102 
CLASS brfrega INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS brfrega

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL   
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL  

    symHlName   := #brfrega 

    cPict       := ""
    cTypeDiag   := "" 
    cTypeHelp   := "" 
    cLenDiag    := "" 
    cLenHelp    := "" 
    cMinLenDiag := "" 
    cMinLenHelp := "" 
    cRangeDiag  := "City and date should start on a line between 1 and 50" 
    cRangeHelp  := "" 
    cValidDiag  := "" 
    cValidHelp  := "" 
    cReqDiag    := "" 
    cReqHelp    := "" 

    nMinLen     := -1
    nMinRange   := 1
    nMaxRange   := 50
    xValidation := NIL              
    lRequired   := .F.   


    SUPER:Init( HyperLabel{symHlName, "", "", "" },  "N", 12, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




CLASS brfregn INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS brfregn

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL   
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL  

    symHlName   := #brfregn 

    cPict       := ""
    cTypeDiag   := "" 
    cTypeHelp   := "" 
    cLenDiag    := "" 
    cLenHelp    := "" 
    cMinLenDiag := "" 
    cMinLenHelp := "" 
    cRangeDiag  := "Name and address should start on a line between 1 and 50" 
    cRangeHelp  := "" 
    cValidDiag  := "" 
    cValidHelp  := "" 
    cReqDiag    := "" 
    cReqHelp    := "" 

    nMinLen     := -1
    nMinRange   := 1
    nMaxRange   := 50
    xValidation := NIL              
    lRequired   := .F.   


    SUPER:Init( HyperLabel{symHlName, "", "", "" },  "N", 12, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




CLASS brfWidth INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS brfWidth

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL   
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL  

    symHlName   := #brfWidth 

    cPict       := "999"
    cTypeDiag   := "" 
    cTypeHelp   := "" 
    cLenDiag    := "" 
    cLenHelp    := "" 
    cMinLenDiag := "" 
    cMinLenHelp := "" 
    cRangeDiag  := "Width of letter should be in range 10 - 200" 
    cRangeHelp  := "" 
    cValidDiag  := "" 
    cValidHelp  := "" 
    cReqDiag    := "" 
    cReqHelp    := "" 

    nMinLen     := -1
    nMinRange   := 10
    nMaxRange   := 200
    xValidation := NIL              
    lRequired   := .F.   


    SUPER:Init( HyperLabel{symHlName, "", "", "" },  "N", 12, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




DEFINE CRLF := _Chr(ASC_CR) + _Chr(ASC_LF)
CLASS eMailFormat INHERIT DataDialogMine 

	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCGroupBox AS GROUPBOX
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oDCTemplates AS COMBOBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
    EXPORT lCancel:=true as LOGIC
    EXPORT Template as STRING
    EXPORT Templatename as STRING
RESOURCE eMailFormat DIALOGEX  8, 7, 265, 88
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Cancel", EMAILFORMAT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 204, 28, 53, 12
	CONTROL	"OK", EMAILFORMAT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 204, 11, 53, 12
	CONTROL	"eMail Content text", EMAILFORMAT_GROUPBOX, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 1, 184, 53
	CONTROL	"New", EMAILFORMAT_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 124, 11, 53, 12
	CONTROL	"Edit", EMAILFORMAT_EDITBUTTON, "Button", WS_TABSTOP|WS_CHILD, 124, 30, 53, 13
	CONTROL	"", EMAILFORMAT_TEMPLATES, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 16, 11, 100, 72
END

ACCESS Brieven() CLASS eMailFormat
RETURN SELF:FieldGet(#Brieven)

ASSIGN Brieven(uValue) CLASS eMailFormat
SELF:FieldPut(#Brieven, uValue)
RETURN uValue

METHOD CancelButton( ) CLASS eMailFormat
	SELF:EndWindow()
	lCancel := TRUE
	RETURN SELF

METHOD EditButton( ) CLASS eMailFormat
	LOCAL oMark AS MarkupLetter
	oMark:= MarkupLetter{self,self:Templates}
	oMark:Show()
	
	RETURN
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS eMailFormat 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"eMailFormat",_GetInst()},iCtlID)

oCCCancelButton := PushButton{SELF,ResourceID{EMAILFORMAT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{EMAILFORMAT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oDCGroupBox := GroupBox{SELF,ResourceID{EMAILFORMAT_GROUPBOX,_GetInst()}}
oDCGroupBox:HyperLabel := HyperLabel{#GroupBox,"eMail Content text",NULL_STRING,NULL_STRING}

oCCNewButton := PushButton{SELF,ResourceID{EMAILFORMAT_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}
oCCNewButton:TooltipText := "Add new text"

oCCEditButton := PushButton{SELF,ResourceID{EMAILFORMAT_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:TooltipText := "Edit a letter"

oDCTemplates := combobox{SELF,ResourceID{EMAILFORMAT_TEMPLATES,_GetInst()}}
oDCTemplates:HyperLabel := HyperLabel{#Templates,NULL_STRING,NULL_STRING,NULL_STRING}
oDCTemplates:FillUsing(Self:ListFiles( ))

SELF:Caption := "eMail Template"
SELF:HyperLabel := HyperLabel{#eMailFormat,"eMail Template",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListFiles(mExt) CLASS eMailFormat
	LOCAL brieven:={{"<None>", ""}} AS ARRAY
	Default(@mExt,"eMl")
	AEval(Directory(CurPath+"\*."+mExt),{|x| AAdd(brieven,{SubStr(x[F_NAME],1,RAt(".",x[F_NAME])-1),x[F_NAME]})})
	if CountryCode=='47' // debug for Oddrun in Norway
		LogEvent(self,"email directory:"+CurPath+"\*."+mExt+CRLF+Implode(brieven,",",,,,")"+CRLF+"("),"loginfo")
	endif
	
	RETURN brieven
METHOD NewButton( ) CLASS eMailFormat
LOCAL oMark AS MarkupLetter
oMark:= MarkupLetter{SELF,".eMl"}
oMark:Show()

self:oDCTemplates:FillUsing(self:ListFiles("eMl"))
self:oDCTemplates:Value:=self:Templatename
RETURN

METHOD OKButton( ) CLASS eMailFormat
	LOCAL cRoot := "WYC\Runtime" AS STRING
	LOCAL LineCount as int
	LOCAL templateWidth:= 60 as int
	IF !Empty(self:oDCTemplates:VALUE)

		self:Template:=MemoRead(CURPATH+"\"+self:oDCTemplates:VALUE)
		LineCount:=MLCount(self:Template,templateWidth)
	ELSE
		self:Template:=null_string
	ENDIF
	* save stettings in the registry:
	SetRTRegString( cRoot, "eMlContent", self:oDCTemplates:TextValue)
	lCancel:=false
	SELF:EndWindow()
RETURN NIL
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS eMailFormat
	//Put your PostInit additions here
	*    SELF:oDCBrieven:ListFiles("*.eMl")
	self:SetTexts()
	SaveUse(self)
	self:Templates := WycIniFS:Getstring("Runtime", "eMlContent" ) 
	if CountryCode=='47' // debug for Oddrun in Norway
		LogEvent(self,"email template:"+self:Templates,"loginfo")
	endif

	IF Empty(self:Templates)
		self:oDCTemplates:CurrentItemNo:=1
	ELSE
		self:oDCTemplates:TextValue:=self:Templates
		IF self:oDCTemplates:CurrentItemNo==0
			self:oDCTemplates:CurrentItemNo:=1
		ENDIF
	ENDIF

	RETURN NIL
ACCESS Templates() CLASS eMailFormat
RETURN SELF:FieldGet(#Templates)

ASSIGN Templates(uValue) CLASS eMailFormat
SELF:FieldPut(#Templates, uValue)
RETURN uValue

STATIC DEFINE EMAILFORMAT_CANCELBUTTON := 100 
STATIC DEFINE EMAILFORMAT_EDITBUTTON := 104 
STATIC DEFINE EMAILFORMAT_GROUPBOX := 102 
STATIC DEFINE EMAILFORMAT_NEWBUTTON := 103 
STATIC DEFINE EMAILFORMAT_OKBUTTON := 101 
STATIC DEFINE EMAILFORMAT_TEMPLATES := 105 
CLASS LabelBottom INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS LabelBottom

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #LabelBottom

    cPict       := ""
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := ""
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "LabelBottom", "", "" },  "N", 5, 2 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




CLASS LabelColCnt INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS LabelColCnt

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #LabelColCnt

    cPict       := "9"
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := "Enter a value between 1 and 9"
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := 1
    nMaxRange   := 9
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Number of columns", "", "" },  "N", 1, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




CLASS LabelFormat INHERIT DataDialogMine 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCstckr_height AS SINGLELINEEDIT
	PROTECT oDCstckr_width AS SINGLELINEEDIT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCstckr_TopMargin AS SINGLELINEEDIT
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCstckr_LeftMargin AS SINGLELINEEDIT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCstckr_PointSize AS COMBOBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oDCFixedText9 AS FIXEDTEXT
	PROTECT oDCFixedText10 AS FIXEDTEXT
	PROTECT oDCFixedText12 AS FIXEDTEXT
	PROTECT oDCFixedText13 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT Pretesting AS LOGIC
  EXPORT lCancel AS LOGIC
RESOURCE LabelFormat DIALOGEX  6, 6, 238, 165
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Label format:", LABELFORMAT_FIXEDTEXT1, "Static", WS_CHILD, 20, 4, 100, 12
	CONTROL	"Height:", LABELFORMAT_STCKR_HEIGHT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 100, 22, 40, 12, WS_EX_CLIENTEDGE
	CONTROL	"", LABELFORMAT_STCKR_WIDTH, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 102, 42, 40, 12, WS_EX_CLIENTEDGE
	CONTROL	"Height label:", LABELFORMAT_FIXEDTEXT2, "Static", WS_CHILD, 10, 21, 56, 12
	CONTROL	"Width label:", LABELFORMAT_FIXEDTEXT3, "Static", WS_CHILD, 10, 42, 57, 12
	CONTROL	"", LABELFORMAT_STCKR_TOPMARGIN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 102, 64, 40, 12, WS_EX_CLIENTEDGE
	CONTROL	"Top margin page:", LABELFORMAT_FIXEDTEXT6, "Static", WS_CHILD, 10, 63, 72, 12
	CONTROL	"", LABELFORMAT_STCKR_LEFTMARGIN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 102, 83, 40, 13, WS_EX_CLIENTEDGE
	CONTROL	"Left margin page:", LABELFORMAT_FIXEDTEXT7, "Static", WS_CHILD, 10, 83, 58, 13
	CONTROL	"", LABELFORMAT_STCKR_POINTSIZE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 102, 105, 54, 47
	CONTROL	"OK", LABELFORMAT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 177, 20, 53, 13
	CONTROL	"Cancel", LABELFORMAT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 177, 39, 53, 12
	CONTROL	"Font pointsize", LABELFORMAT_FIXEDTEXT8, "Static", WS_CHILD, 10, 104, 54, 12
	CONTROL	"mm", LABELFORMAT_FIXEDTEXT9, "Static", WS_CHILD, 152, 22, 16, 13
	CONTROL	"mm", LABELFORMAT_FIXEDTEXT10, "Static", WS_CHILD, 152, 43, 16, 13
	CONTROL	"mm", LABELFORMAT_FIXEDTEXT12, "Static", WS_CHILD, 152, 65, 16, 12
	CONTROL	"mm", LABELFORMAT_FIXEDTEXT13, "Static", WS_CHILD, 152, 84, 16, 12
END

METHOD CancelButton( ) CLASS LabelFormat
	SELF:EndWindow()
	lCancel := TRUE
	RETURN SELF
METHOD Close(oEvent) CLASS LabelFormat
	SUPER:Close(oEvent)
	//Put your changes here
SELF:Destroy()
	RETURN NIL

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS LabelFormat 
LOCAL DIM aFonts[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"LabelFormat",_GetInst()},iCtlID)

aFonts[1] := Font{,12,"MS Sans Serif"}
aFonts[1]:Bold := TRUE

oDCFixedText1 := FixedText{SELF,ResourceID{LABELFORMAT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Label format:",NULL_STRING,NULL_STRING}
oDCFixedText1:Font(aFonts[1], FALSE)

oDCstckr_height := SingleLineEdit{SELF,ResourceID{LABELFORMAT_STCKR_HEIGHT,_GetInst()}}
oDCstckr_height:HyperLabel := HyperLabel{#stckr_height,"Height:",NULL_STRING,NULL_STRING}
oDCstckr_height:FieldSpec := LabelHeight{}

oDCstckr_width := SingleLineEdit{SELF,ResourceID{LABELFORMAT_STCKR_WIDTH,_GetInst()}}
oDCstckr_width:FieldSpec := LABELWIDTH{}
oDCstckr_width:HyperLabel := HyperLabel{#stckr_width,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{LABELFORMAT_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Height label:",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{LABELFORMAT_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Width label:",NULL_STRING,NULL_STRING}

oDCstckr_TopMargin := SingleLineEdit{SELF,ResourceID{LABELFORMAT_STCKR_TOPMARGIN,_GetInst()}}
oDCstckr_TopMargin:FieldSpec := SYSPARMS_TOPMARGIN{}
oDCstckr_TopMargin:HyperLabel := HyperLabel{#stckr_TopMargin,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText6 := FixedText{SELF,ResourceID{LABELFORMAT_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"Top margin page:",NULL_STRING,NULL_STRING}

oDCstckr_LeftMargin := SingleLineEdit{SELF,ResourceID{LABELFORMAT_STCKR_LEFTMARGIN,_GetInst()}}
oDCstckr_LeftMargin:FieldSpec := SYSPARMS_LEFTMARGIN{}
oDCstckr_LeftMargin:HyperLabel := HyperLabel{#stckr_LeftMargin,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{LABELFORMAT_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Left margin page:",NULL_STRING,NULL_STRING}

oDCstckr_PointSize := combobox{SELF,ResourceID{LABELFORMAT_STCKR_POINTSIZE,_GetInst()}}
oDCstckr_PointSize:FillUsing(Self:PointSizes( ))
oDCstckr_PointSize:HyperLabel := HyperLabel{#stckr_PointSize,NULL_STRING,NULL_STRING,NULL_STRING}
oDCstckr_PointSize:FieldSpec := PointSize{}

oCCOKButton := PushButton{SELF,ResourceID{LABELFORMAT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{LABELFORMAT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCFixedText8 := FixedText{SELF,ResourceID{LABELFORMAT_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"Font pointsize",NULL_STRING,NULL_STRING}

oDCFixedText9 := FixedText{SELF,ResourceID{LABELFORMAT_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"mm",NULL_STRING,NULL_STRING}

oDCFixedText10 := FixedText{SELF,ResourceID{LABELFORMAT_FIXEDTEXT10,_GetInst()}}
oDCFixedText10:HyperLabel := HyperLabel{#FixedText10,"mm",NULL_STRING,NULL_STRING}

oDCFixedText12 := FixedText{SELF,ResourceID{LABELFORMAT_FIXEDTEXT12,_GetInst()}}
oDCFixedText12:HyperLabel := HyperLabel{#FixedText12,"mm",NULL_STRING,NULL_STRING}

oDCFixedText13 := FixedText{SELF,ResourceID{LABELFORMAT_FIXEDTEXT13,_GetInst()}}
oDCFixedText13:HyperLabel := HyperLabel{#FixedText13,"mm",NULL_STRING,NULL_STRING}

SELF:Caption := "Label format"
SELF:HyperLabel := HyperLabel{#LabelFormat,"Label format",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS LabelFormat
	LOCAL nPoint:= 254/10 AS FLOAT
	LOCAL cRoot := "WYC\Runtime" as STRING
	local cError as string
	LOCAL lError AS LOGIC
	IF IsNil(self:stckr_PointSize).or.Empty(self:stckr_PointSize).or.!IsNumeric(self:stckr_PointSize)
		(ErrorBox{self,self:oLan:Wget("Pointsize is mandatory")+"!"}):show()
		RETURN TRUE
	ENDIF
	if self:stckr_height <10 	
		cError:="height to small"
		lError:=true
	elseif self:stckr_height >200 	
		cError:="height to large"
		lError:=true
	elseif self:stckr_width<20 
		cError:="Width too small"
		lError:=true
	elseif self:stckr_width>120
		cError:="width to large"
		lError:=true
	else	
		* Check if number	of	rows below minimum (4 of 3	+KIXcode-row):
		IF	CountryCode="31"
			IF	Integer((self:stckr_height	- 7 )	/ ( self:stckr_PointSize *	nPoint /	72)) < 3
				* error
				cError:="Too less	lines	per label"
				lError := true
			ENDIF
		ELSE
			IF	Integer(self:stckr_height	/ ( self:stckr_PointSize *	nPoint /	72)) < 4
				* error
				cError:="Too less	lines	per label"
				lError := true
			ENDIF
		ENDIF
	endif
	IF lError
		(ErrorBox{self,cError}):show()
	ELSE
		SetRTRegInt( cRoot, "stckr_height", self:stckr_height )
		SetRTRegInt( cRoot, "stckr_width", self:stckr_width)
		SetRTRegInt( cRoot, "stckr_TopMargin", self:stckr_TopMargin )
		SetRTRegInt( cRoot, "stckr_LeftMargin", self:stckr_LeftMargin )
		SetRTRegInt( cRoot, "stckr_PointSize", self:stckr_PointSize )
		self:EndWindow()
	ENDIF

	RETURN true
	


METHOD PointSizes() CLASS LabelFormat
RETURN {8,9,10,11,12}
METHOD PostInit() CLASS LabelFormat
	//Put your PostInit additions here
	self:SetTexts()
	SaveUse(self)
	self:stckr_height := WycIniFS:GetInt( "Runtime", "stckr_height" )
	self:stckr_width := WycIniFS:GetInt( "Runtime", "stckr_width" )
	self:stckr_TopMargin := WycIniFS:GetInt( "Runtime", "stckr_TopMargin" )
	self:stckr_LeftMargin  := WycIniFS:GetInt( "Runtime", "stckr_LeftMargin" )
	self:stckr_PointSize := WycIniFS:GetInt( "Runtime", "stckr_PointSize" )
	IF Empty(self:stckr_height).or.IsNil(self:stckr_height)
		self:stckr_height:=36
		self:stckr_width:=70
		self:stckr_TopMargin := 0
		self:stckr_LeftMargin := 0
	ENDIF	
	IF Empty(self:stckr_PointSize).or.IsNil(self:stckr_PointSize)
		self:stckr_PointSize := 11
	ENDIF

	RETURN NIL
ACCESS stckr_height() CLASS LabelFormat
RETURN SELF:FieldGet(#stckr_height)

ASSIGN stckr_height(uValue) CLASS LabelFormat
SELF:FieldPut(#stckr_height, uValue)
RETURN uValue

ACCESS stckr_LeftMargin() CLASS LabelFormat
RETURN SELF:FieldGet(#stckr_LeftMargin)

ASSIGN stckr_LeftMargin(uValue) CLASS LabelFormat
SELF:FieldPut(#stckr_LeftMargin, uValue)
RETURN uValue

ACCESS stckr_PointSize() CLASS LabelFormat
RETURN SELF:FieldGet(#stckr_PointSize)

ASSIGN stckr_PointSize(uValue) CLASS LabelFormat
SELF:FieldPut(#stckr_PointSize, uValue)
RETURN uValue

ACCESS stckr_TopMargin() CLASS LabelFormat
RETURN SELF:FieldGet(#stckr_TopMargin)

ASSIGN stckr_TopMargin(uValue) CLASS LabelFormat
SELF:FieldPut(#stckr_TopMargin, uValue)
RETURN uValue

ACCESS stckr_width() CLASS LabelFormat
RETURN SELF:FieldGet(#stckr_width)

ASSIGN stckr_width(uValue) CLASS LabelFormat
SELF:FieldPut(#stckr_width, uValue)
RETURN uValue

STATIC DEFINE LABELFORMAT_CANCELBUTTON := 111 
STATIC DEFINE LABELFORMAT_FIXEDTEXT1 := 100 
STATIC DEFINE LABELFORMAT_FIXEDTEXT10 := 114 
STATIC DEFINE LABELFORMAT_FIXEDTEXT12 := 115 
STATIC DEFINE LABELFORMAT_FIXEDTEXT13 := 116 
STATIC DEFINE LABELFORMAT_FIXEDTEXT2 := 103 
STATIC DEFINE LABELFORMAT_FIXEDTEXT3 := 104 
STATIC DEFINE LABELFORMAT_FIXEDTEXT6 := 106 
STATIC DEFINE LABELFORMAT_FIXEDTEXT7 := 108 
STATIC DEFINE LABELFORMAT_FIXEDTEXT8 := 112 
STATIC DEFINE LABELFORMAT_FIXEDTEXT9 := 113 
STATIC DEFINE LABELFORMAT_OKBUTTON := 110 
STATIC DEFINE LABELFORMAT_STCKR_HEIGHT := 101 
STATIC DEFINE LABELFORMAT_STCKR_HOOGTE := 101 
STATIC DEFINE LABELFORMAT_STCKR_LEFTMARGIN := 107 
STATIC DEFINE LABELFORMAT_STCKR_POINTSIZE := 109 
STATIC DEFINE LABELFORMAT_STCKR_TOPMARGIN := 105 
STATIC DEFINE LABELFORMAT_STCKR_WIDTH := 102 
CLASS LabelHeight INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS LabelHeight

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #LabelHeight

    cPict       := "999.99"
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := "Enter a value between 6 and 150"
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := 6
    nMaxRange   := 150
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "LabelHeight", "Height of a Label", "" },  "N", 5, 2 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




CLASS LabelMargin INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS LabelMargin

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #LabelMargin

    cPict       := "99.99"
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := "Enter a value between 0 and 20"
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := 0
    nMaxRange   := 20
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Left Margin within label", "", "" },  "N", 4, 2 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




CLASS LabelWidth INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS LabelWidth

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #LabelWidth

    cPict       := "999.99"
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := "Enter a value between 20 and 250"
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := 20
    nMaxRange   := 250
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "LabelWidth", "", "" },  "N", 5, 2 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




RESOURCE LetterFormat DIALOGEX  10, 9, 247, 251
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", LETTERFORMAT_TEMPLATES, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 13, 12, 81, 72
	CONTROL	"Name/address on top", LETTERFORMAT_BRFNAW, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 13, 73, 92, 11
	CONTROL	"City and date", LETTERFORMAT_BRFDAT, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 14, 92, 80, 11
	CONTROL	"Heading", LETTERFORMAT_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 60, 164, 53
	CONTROL	"Width of letter:", LETTERFORMAT_FIXEDTEXT2, "Static", WS_CHILD, 12, 131, 53, 13
	CONTROL	"Name/address starts at column:", LETTERFORMAT_FIXEDTEXT3, "Static", WS_CHILD, 12, 148, 102, 13
	CONTROL	"Text starts at column:", LETTERFORMAT_FIXEDTEXT4, "Static", WS_CHILD, 12, 182, 82, 13
	CONTROL	"City and date starts at column:", LETTERFORMAT_FIXEDTEXT5, "Static", WS_CHILD, 12, 199, 104, 12
	CONTROL	"City and date starts at row:", LETTERFORMAT_FIXEDTEXT6, "Static", WS_CHILD, 12, 216, 95, 12
	CONTROL	"", LETTERFORMAT_BRFWIDTH, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 116, 131, 37, 13, WS_EX_CLIENTEDGE
	CONTROL	"", LETTERFORMAT_BRFCOL, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 116, 148, 37, 12, WS_EX_CLIENTEDGE
	CONTROL	"", LETTERFORMAT_BRFREGN, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 116, 166, 37, 12, WS_EX_CLIENTEDGE
	CONTROL	"", LETTERFORMAT_BRFCOLT, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 116, 182, 37, 13, WS_EX_CLIENTEDGE
	CONTROL	"", LETTERFORMAT_BRFCOLA, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 116, 199, 37, 12, WS_EX_CLIENTEDGE
	CONTROL	"", LETTERFORMAT_BRFREGA, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 116, 216, 37, 12, WS_EX_CLIENTEDGE
	CONTROL	"Name/address starts at row:", LETTERFORMAT_FIXEDTEXT7, "Static", WS_CHILD, 12, 166, 104, 12
	CONTROL	"Positions", LETTERFORMAT_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 120, 164, 119
	CONTROL	"OK", LETTERFORMAT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 180, 208, 54, 12
	CONTROL	"Cancel", LETTERFORMAT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 180, 227, 54, 12
	CONTROL	"New", LETTERFORMAT_NEWBUTTON, "Button", WS_TABSTOP|WS_CHILD, 104, 12, 54, 12
	CONTROL	"Edit", LETTERFORMAT_EDITBUTTON, "Button", WS_TABSTOP|WS_CHILD, 104, 31, 53, 12
	CONTROL	"Letter", LETTERFORMAT_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 4, 0, 164, 53
END

CLASS LetterFormat INHERIT DataDialogMine 

	PROTECT oDCTemplates AS COMBOBOX
	PROTECT oDCbrfNAW AS CHECKBOX
	PROTECT oDCbrfDAT AS CHECKBOX
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCbrfWidth AS SINGLELINEEDIT
	PROTECT oDCbrfCol AS SINGLELINEEDIT
	PROTECT oDCbrfregn AS SINGLELINEEDIT
	PROTECT oDCbrfColt AS SINGLELINEEDIT
	PROTECT oDCbrfCola AS SINGLELINEEDIT
	PROTECT oDCbrfrega AS SINGLELINEEDIT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCNewButton AS PUSHBUTTON
	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oDCGroupBox3 AS GROUPBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT lCancel AS LOGIC
  EXPORT brief AS STRING
  EXPORT Lettername AS STRING
  EXPORT lAcceptNorway AS LOGIC
  EXPORT Templatename as STRING
ACCESS brfCol() CLASS LetterFormat
RETURN SELF:FieldGet(#brfCol)

ASSIGN brfCol(uValue) CLASS LetterFormat
SELF:FieldPut(#brfCol, uValue)
RETURN uValue

ACCESS brfCola() CLASS LetterFormat
RETURN SELF:FieldGet(#brfCola)

ASSIGN brfCola(uValue) CLASS LetterFormat
SELF:FieldPut(#brfCola, uValue)
RETURN uValue

ACCESS brfColt() CLASS LetterFormat
RETURN SELF:FieldGet(#brfColt)

ASSIGN brfColt(uValue) CLASS LetterFormat
SELF:FieldPut(#brfColt, uValue)
RETURN uValue

ACCESS brfDAT() CLASS LetterFormat
RETURN SELF:FieldGet(#brfDAT)

ASSIGN brfDAT(uValue) CLASS LetterFormat
SELF:FieldPut(#brfDAT, uValue)
RETURN uValue

ACCESS brfNAW() CLASS LetterFormat
RETURN SELF:FieldGet(#brfNAW)

ASSIGN brfNAW(uValue) CLASS LetterFormat
SELF:FieldPut(#brfNAW, uValue)
RETURN uValue

ACCESS brfrega() CLASS LetterFormat
RETURN SELF:FieldGet(#brfrega)

ASSIGN brfrega(uValue) CLASS LetterFormat
SELF:FieldPut(#brfrega, uValue)
RETURN uValue

ACCESS brfregn() CLASS LetterFormat
RETURN SELF:FieldGet(#brfregn)

ASSIGN brfregn(uValue) CLASS LetterFormat
SELF:FieldPut(#brfregn, uValue)
RETURN uValue

ACCESS brfWidth() CLASS LetterFormat
RETURN SELF:FieldGet(#brfWidth)

ASSIGN brfWidth(uValue) CLASS LetterFormat
SELF:FieldPut(#brfWidth, uValue)
RETURN uValue

access Brieven() class LetterFormat
return self:FieldGet(#Brieven)

METHOD ButtonClick(oControlEvent) CLASS LetterFormat
	LOCAL oControl AS Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:NameSym == #brfNAW
		IF self:brfNAW
			self:oDCbrfCol:Enable()
			self:oDCbrfregn:Enable()
		ELSE
			self:oDCbrfCol:Disable()
			self:oDCbrfregn:Disable()
		ENDIF
	ENDIF

	IF oControl:NameSym == #brfDAT
		IF self:brfDAT
			self:oDCbrfCola:Enable()
			self:oDCbrfrega:Enable()
		ELSE
			self:oDCbrfCola:Disable()
			self:oDCbrfrega:Disable()
		ENDIF
	ENDIF
	
	RETURN NIL

METHOD CancelButton( ) CLASS LetterFormat
	SELF:EndWindow()
	lCancel := TRUE
	RETURN SELF
METHOD Close(oEvent) CLASS LetterFormat
	SUPER:Close(oEvent)
	//Put your changes here
SELF:destroy()
	RETURN NIL

METHOD EditButton( ) CLASS LetterFormat
LOCAL oMark AS MarkupLetter
oMark:= MarkupLetter{self,self:Templates}
oMark:Show()
	
	RETURN
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS LetterFormat 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"LetterFormat",_GetInst()},iCtlID)

oDCTemplates := combobox{SELF,ResourceID{LETTERFORMAT_TEMPLATES,_GetInst()}}
oDCTemplates:HyperLabel := HyperLabel{#Templates,NULL_STRING,NULL_STRING,NULL_STRING}
oDCTemplates:FillUsing(Self:ListFiles( ))

oDCbrfNAW := CheckBox{SELF,ResourceID{LETTERFORMAT_BRFNAW,_GetInst()}}
oDCbrfNAW:HyperLabel := HyperLabel{#brfNAW,"Name/address on top",NULL_STRING,NULL_STRING}

oDCbrfDAT := CheckBox{SELF,ResourceID{LETTERFORMAT_BRFDAT,_GetInst()}}
oDCbrfDAT:HyperLabel := HyperLabel{#brfDAT,"City and date",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{LETTERFORMAT_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Heading",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{LETTERFORMAT_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Width of letter:",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{LETTERFORMAT_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Name/address starts at column:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{LETTERFORMAT_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Text starts at column:",NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{LETTERFORMAT_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"City and date starts at column:",NULL_STRING,NULL_STRING}

oDCFixedText6 := FixedText{SELF,ResourceID{LETTERFORMAT_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"City and date starts at row:",NULL_STRING,NULL_STRING}

oDCbrfWidth := SingleLineEdit{SELF,ResourceID{LETTERFORMAT_BRFWIDTH,_GetInst()}}
oDCbrfWidth:Picture := "999"
oDCbrfWidth:HyperLabel := HyperLabel{#brfWidth,NULL_STRING,NULL_STRING,NULL_STRING}
oDCbrfWidth:FieldSpec := BRFWIDTH{}

oDCbrfCol := SingleLineEdit{SELF,ResourceID{LETTERFORMAT_BRFCOL,_GetInst()}}
oDCbrfCol:Picture := "99"
oDCbrfCol:HyperLabel := HyperLabel{#brfCol,NULL_STRING,NULL_STRING,NULL_STRING}

oDCbrfregn := SingleLineEdit{SELF,ResourceID{LETTERFORMAT_BRFREGN,_GetInst()}}
oDCbrfregn:Picture := "99"
oDCbrfregn:UseHLforToolTip := False
oDCbrfregn:HyperLabel := HyperLabel{#brfregn,NULL_STRING,NULL_STRING,NULL_STRING}

oDCbrfColt := SingleLineEdit{SELF,ResourceID{LETTERFORMAT_BRFCOLT,_GetInst()}}
oDCbrfColt:Picture := "99"
oDCbrfColt:UseHLforToolTip := False
oDCbrfColt:HyperLabel := HyperLabel{#brfColt,NULL_STRING,NULL_STRING,NULL_STRING}

oDCbrfCola := SingleLineEdit{SELF,ResourceID{LETTERFORMAT_BRFCOLA,_GetInst()}}
oDCbrfCola:Picture := "99"
oDCbrfCola:HyperLabel := HyperLabel{#brfCola,NULL_STRING,NULL_STRING,NULL_STRING}

oDCbrfrega := SingleLineEdit{SELF,ResourceID{LETTERFORMAT_BRFREGA,_GetInst()}}
oDCbrfrega:Picture := "99"
oDCbrfrega:HyperLabel := HyperLabel{#brfrega,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{LETTERFORMAT_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Name/address starts at row:",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{LETTERFORMAT_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Positions",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{LETTERFORMAT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{LETTERFORMAT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oCCNewButton := PushButton{SELF,ResourceID{LETTERFORMAT_NEWBUTTON,_GetInst()}}
oCCNewButton:HyperLabel := HyperLabel{#NewButton,"New",NULL_STRING,NULL_STRING}
oCCNewButton:TooltipText := "Add new letter"

oCCEditButton := PushButton{SELF,ResourceID{LETTERFORMAT_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:TooltipText := "Edit a letter"

oDCGroupBox3 := GroupBox{SELF,ResourceID{LETTERFORMAT_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"Letter",NULL_STRING,NULL_STRING}

SELF:Caption := "Specification of Letter format"
SELF:HyperLabel := HyperLabel{#LetterFormat,"Specification of Letter format",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListFiles(mExt) CLASS LetterFormat
LOCAL brieven:={} AS ARRAY
Default(@mExt,"brf")
AEval(Directory(CurPath+"\*."+mExt),{|x| AAdd(brieven,{SubStr(x[F_NAME],1,RAt(".",x[F_NAME])-1),x[F_NAME]})})

RETURN brieven
METHOD NewButton( ) CLASS LetterFormat
LOCAL oMark AS MarkupLetter
oMark:= MarkupLetter{SELF,".brf"}
oMark:Show()
self:oDCTemplates:FillUsing(self:ListFiles( ))
self:oDCTemplates:Value:=self:TemplateName
RETURN
METHOD OKButton( ) CLASS LetterFormat
	LOCAL m96_regels AS INT
	LOCAL cRoot := "WYC\Runtime" AS STRING
	IF Empty(self:oDCTemplates:TextValue)
		(errorbox{SELF,"No letter selected"}):show()
		RETURN
	ENDIF

	IF self:brfNAW .and.(self:brfCol < 1 .or. self:brfCol > self:brfWidth)
		(errorbox{SELF,"Name/address start column must be within range of letter"}):show()
		RETURN
	ENDIF	
	IF self:brfColt < 1 .or. self:brfColt > self:brfWidth-10
		(errorbox{SELF,"Text start column must be within range of lettermargins"}):show()
		RETURN
	ENDIF	
	IF self:brfDAT.and.(self:brfCola < 1 .or. self:brfCola > self:brfWidth-10)
		(errorbox{SELF,"City and date start column must be within range of lettermargins"}):show()
		RETURN
	ENDIF	
	IF self:brfDAT.and.self:brfNAW.and.self:brfCola==self:brfCol.and.self:brfregn==self:brfrega
		(errorbox{SELF,"Name and City and date cannot be on the same position"}):show()
		RETURN
	ENDIF
	self:brief:=null_string		
	* save stettings in the registry:
	SetRTRegInt( cRoot, "brfNAW", if(self:brfNAW,1,0) )
	SetRTRegInt( cRoot, "brfDAT", if(self:brfDAT,1,0))
	SetRTRegInt( cRoot, "brfWidth", self:brfWidth )
	SetRTRegInt( cRoot, "brfCol", self:brfCol )
	SetRTRegInt( cRoot, "brfregn", self:brfregn )
	SetRTRegInt( cRoot, "brfrega", self:brfrega )
	SetRTRegInt( cRoot, "brfCola", self:brfCola )
	SetRTRegInt( cRoot, "brfColt", self:brfColt )
	brief:=MemoRead(CurPath+"\"+self:oDCTemplates:VALUE)
	SetRTRegString( cRoot, "LetterName", self:oDCTemplates:TextValue)

	SELF:EndWindow()

	RETURN TRUE
	


METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS LetterFormat
	//Put your PostInit additions here
	self:SetTexts()
	SaveUse(self)
	self:brfNAW := if(WycIniFS:GetInt( "Runtime", "brfNAW" )==1,true,FALSE)
	self:brfDAT := if(WycIniFS:GetInt( "Runtime", "brfDAT" )==1,true,FALSE)
	self:brfWidth := WycIniFS:GetInt( "Runtime", "brfWidth" )
	self:brfCol := WycIniFS:GetInt( "Runtime", "brfCol" )
	self:brfregn := WycIniFS:GetInt( "Runtime", "brfregn" )
	self:brfrega := WycIniFS:GetInt( "Runtime", "brfrega" )
	self:brfCola := WycIniFS:GetInt( "Runtime", "brfCola" )
	self:brfColt := WycIniFS:GetInt( "Runtime", "brfColt" )
	IF IsLogic(uExtra)
		lAcceptNorway:=uExtra
	ENDIF
	IF lAcceptNorway
		self:Caption:=self:oLan:WGet("Specification of Accept GIRO format")
	ENDIF
	* Set default values:
	IF Empty( self:brfWidth)
		self:brfWidth:=80
	ENDIF
	IF Empty( self:brfCol)
		self:brfCol:=1
	ENDIF
	IF Empty( self:brfregn)
		self:brfregn:=1
	ENDIF
	IF Empty( self:brfColt)
		self:brfColt:=8
	ENDIF
	IF Empty( self:brfCola)
		self:brfCola:= 50
	ENDIF
	IF Empty( self:brfrega)
		self:brfrega:=6
	ENDIF
	
	IF self:brfNAW
		self:oDCbrfCol:Enable()
		self:oDCbrfregn:Enable()
	ELSE
		self:oDCbrfCol:Disable()
		self:oDCbrfregn:Disable()
	ENDIF

	IF self:brfDAT
		self:oDCbrfCola:Enable()
		self:oDCbrfrega:Enable()
	ELSE
		self:oDCbrfCola:Disable()
		self:oDCbrfrega:Disable()
	ENDIF

*    SELF:oDCBrieven:ListFiles("*.brf")
	self:Templates := WycIniFS:Getstring("Runtime", "LetterName" )
	IF Empty(self:Templates)
	    self:oDCTemplates:CurrentItemNo:=1
	ELSE
	    self:oDCTemplates:TextValue:=self:Templates
		IF self:oDCTemplates:CurrentItemNo==0
		    self:oDCTemplates:CurrentItemNo:=1
		ENDIF
	ENDIF

	RETURN NIL
ACCESS Templates() CLASS LetterFormat
RETURN SELF:FieldGet(#Templates)

ASSIGN Templates(uValue) CLASS LetterFormat
SELF:FieldPut(#Templates, uValue)
RETURN uValue

STATIC DEFINE LETTERFORMAT_BRFCOL := 110 
STATIC DEFINE LETTERFORMAT_BRFCOLA := 113 
STATIC DEFINE LETTERFORMAT_BRFCOLT := 112 
STATIC DEFINE LETTERFORMAT_BRFDAT := 102 
STATIC DEFINE LETTERFORMAT_BRFNAW := 101 
STATIC DEFINE LETTERFORMAT_BRFREGA := 114 
STATIC DEFINE LETTERFORMAT_BRFREGN := 111 
STATIC DEFINE LETTERFORMAT_BRFWIDTH := 109 
STATIC DEFINE LETTERFORMAT_BRIEVEN := 100 
STATIC DEFINE LETTERFORMAT_CANCELBUTTON := 118 
STATIC DEFINE LETTERFORMAT_EDITBUTTON := 120 
STATIC DEFINE LETTERFORMAT_FIXEDTEXT2 := 104 
STATIC DEFINE LETTERFORMAT_FIXEDTEXT3 := 105 
STATIC DEFINE LETTERFORMAT_FIXEDTEXT4 := 106 
STATIC DEFINE LETTERFORMAT_FIXEDTEXT5 := 107 
STATIC DEFINE LETTERFORMAT_FIXEDTEXT6 := 108 
STATIC DEFINE LETTERFORMAT_FIXEDTEXT7 := 115 
STATIC DEFINE LETTERFORMAT_GROUPBOX1 := 103 
STATIC DEFINE LETTERFORMAT_GROUPBOX2 := 116 
STATIC DEFINE LETTERFORMAT_GROUPBOX3 := 121 
STATIC DEFINE LETTERFORMAT_NEWBUTTON := 119 
STATIC DEFINE LETTERFORMAT_OKBUTTON := 117 
STATIC DEFINE LETTERFORMAT_TEMPLATES := 100 
CLASS MarkupGiftsGroup INHERIT DialogWinDowExtra 

	PROTECT oDCEditLetter AS MULTILINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCKeyword AS COMBOBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  protect oCaller as OBJECT
RESOURCE MarkupGiftsGroup DIALOGEX  5, 17, 372, 79
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Markup Gifts Group"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", MARKUPGIFTSGROUP_EDITLETTER, "Edit", ES_WANTRETURN|ES_AUTOHSCROLL|ES_AUTOVSCROLL|ES_MULTILINE|WS_TABSTOP|WS_CHILD|WS_BORDER, 6, 22, 355, 40, WS_EX_CLIENTEDGE
	CONTROL	"OK", MARKUPGIFTSGROUP_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 306, 3, 54, 14
	CONTROL	"", MARKUPGIFTSGROUP_KEYWORD, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 8, 4, 147, 210
END

method EditFocusChange(oEditFocusChangeEvent) class MarkupGiftsGroup
	local oControl as Control
	local lGotFocus as logic
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	super:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "KEYWORD".and.!Empty(oControl:VALUE)
			self:oDCEditLetter:paste(AllTrim(oControl:VALUE))
		ENDIF
	ENDIF
	return nil
METHOD GenKeywords() CLASS MarkupGiftsGroup 
return {{"Amount gift","%AMOUNTGIFT"},{"Date gift","%DATEGIFT"},{"Reference Gift","%REFERENCEGIFT"},{"Document ID","%DOCUMENTID"},{"Destination", "%DESTINATION"}} 
METHOD Init(oParent,uExtra) CLASS MarkupGiftsGroup 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"MarkupGiftsGroup",_GetInst()},TRUE)

oDCEditLetter := MultiLineEdit{SELF,ResourceID{MARKUPGIFTSGROUP_EDITLETTER,_GetInst()}}
oDCEditLetter:HyperLabel := HyperLabel{#EditLetter,NULL_STRING,NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{MARKUPGIFTSGROUP_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oDCKeyword := combobox{SELF,ResourceID{MARKUPGIFTSGROUP_KEYWORD,_GetInst()}}
oDCKeyword:TooltipText := "Insert a keyword into the gifts group text"
oDCKeyword:HyperLabel := HyperLabel{#Keyword,NULL_STRING,NULL_STRING,NULL_STRING}
oDCKeyword:FillUsing(Self:GenKeywords( ))

SELF:Caption := "Markup Gifts Group"
SELF:HyperLabel := HyperLabel{#MarkupGiftsGroup,"Markup Gifts Group",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS MarkupGiftsGroup 
LOCAL ptrhandle as USUAL
SetPath(CurPath)
ptrhandle := FCreate(CurPath+"\GiftsGroup.grp")
if Right(self:oDCEditLetter:Currenttext,2)<>CRLF
	self:oDCEditLetter:Currenttext+=CRLF
endif
FWrite(ptrhandle, self:oDCEditLetter:Currenttext )
FClose(ptrhandle) 
self:oCaller:GrpFormat:=StrTran(self:oDCEditLetter:Currenttext,CRLF,LF) 
self:EndDialog()
RETURN NIL
method PostInit(oWindow,iCtlID,oServer,uExtra) class MarkupGiftsGroup
	//Put your PostInit additions here
	LOCAL Ptrhandle as USUAL, cContents as STRING
	self:SetTexts()
	SaveUse(self)
	Ptrhandle:=FOpen(CurPath+"\GiftsGroup.grp")
	FRead(Ptrhandle,@cContents,32768)
	FClose(ptrhandle) 
	self:oCaller:=oWindow
	if Empty(cContents)
		cContents:="%DATEGIFT "+sCurrname+"%AMOUNTGIFT: %DESTINATION"
	endif
	oDCEditLetter:Value:=cContents
	oDCEditLetter:SetFocus()
return nil
STATIC DEFINE MARKUPGIFTSGROUP_EDITLETTER := 100 
STATIC DEFINE MARKUPGIFTSGROUP_KEYWORD := 102 
STATIC DEFINE MARKUPGIFTSGROUP_OKBUTTON := 101 
STATIC DEFINE MARKUPGIFTSGROUPOLD_EDITLETTER := 100 
STATIC DEFINE MARKUPGIFTSGROUPOLD_KEYWORD := 102 
STATIC DEFINE MARKUPGIFTSGROUPOLD_SAVEBUTTON := 101 
RESOURCE MarkupLetter DIALOGEX  13, 25, 366, 226
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Markup Letter"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", MARKUPLETTER_EDITLETTER, "Edit", ES_WANTRETURN|ES_AUTOHSCROLL|ES_AUTOVSCROLL|ES_MULTILINE|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL|WS_HSCROLL, 6, 22, 355, 199, WS_EX_CLIENTEDGE
	CONTROL	"Save", MARKUPLETTER_SAVEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 308, 3, 53, 13
	CONTROL	"", MARKUPLETTER_KEYWORD, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 8, 3, 144, 209
	CONTROL	"Repeating group", MARKUPLETTER_REPEATBUTTON, "Button", WS_TABSTOP|WS_CHILD, 164, 3, 61, 13
END

CLASS MarkupLetter INHERIT DialogWinDowExtra 

	PROTECT oDCEditLetter AS MULTILINEEDIT
	PROTECT oCCSaveButton AS PUSHBUTTON
	PROTECT oDCKeyword AS COMBOBOX
	PROTECT oCCRepeatButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  	PROTECT LetterName as STRING
  	PROTECT cExt as STRING

METHOD Close(oEvent) CLASS MarkupLetter
	SUPER:Close(oEvent)
	//Put your changes here
SELF:Destroy()
	RETURN NIL

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS MarkupLetter
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "KEYWORD".and.!Empty(oControl:Value)
			SELF:oDCEditLetter:paste(AllTrim(oControl:Value))
		ENDIF
	ENDIF

	RETURN NIL
METHOD GenKeywords() CLASS MarkupLetter
RETURN AEvalA(GenKeyword(),{|x| {x[1],x[2]}})
METHOD Init(oParent,uExtra) CLASS MarkupLetter 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"MarkupLetter",_GetInst()},TRUE)

oDCEditLetter := MultiLineEdit{SELF,ResourceID{MARKUPLETTER_EDITLETTER,_GetInst()}}
oDCEditLetter:HyperLabel := HyperLabel{#EditLetter,NULL_STRING,NULL_STRING,NULL_STRING}

oCCSaveButton := PushButton{SELF,ResourceID{MARKUPLETTER_SAVEBUTTON,_GetInst()}}
oCCSaveButton:HyperLabel := HyperLabel{#SaveButton,"Save",NULL_STRING,NULL_STRING}

oDCKeyword := combobox{SELF,ResourceID{MARKUPLETTER_KEYWORD,_GetInst()}}
oDCKeyword:TooltipText := "Insert a keyword into the letter text"
oDCKeyword:HyperLabel := HyperLabel{#Keyword,NULL_STRING,NULL_STRING,NULL_STRING}
oDCKeyword:FillUsing(Self:GenKeywords( ))

oCCRepeatButton := PushButton{SELF,ResourceID{MARKUPLETTER_REPEATBUTTON,_GetInst()}}
oCCRepeatButton:HyperLabel := HyperLabel{#RepeatButton,"Repeating group",NULL_STRING,NULL_STRING}
oCCRepeatButton:TooltipText := "Mark selected text as repeating group, e.g. gift in a period"

SELF:Caption := "Markup Letter"
SELF:HyperLabel := HyperLabel{#MarkupLetter,"Markup Letter",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD PostInit(oParent,uExtra) CLASS MarkupLetter
	//Put your PostInit additions here
	LOCAL Ptrhandle AS USUAL, cContents AS STRING
	LOCAL cType AS STRING
	self:SetTexts()
	SaveUse(self)
	if !Empty(uExtra)
		IF uExtra="."
			* Only extension for new letter:
			cExt:=SubStr(uExtra,2)
			cType := cExt
		ELSE
			LetterName:=uExtra
			cType := Split(LetterName,".")[1]
			Ptrhandle:=FOpen(CurPath+"\"+LetterName)
			FRead(ptrHandle,@cContents,32768)
			FClose(PTRhandle)
			oDCEditLetter:Value:=cContents
			oDCEditLetter:SetFocus()
		ENDIF
	ENDIF
	IF !Empty(cType).and. !cType=="brf"
		self:Caption:=self:oLan:WGet("Markup " + iif(cType="acc","AcceptGiro remarks","eMail content") )
	END IF
	RETURN NIL
METHOD RepeatButton( ) CLASS MarkupLetter
SELF:oDCEditLetter:Paste("["+SELF:oDCEditLetter:SelectedText+"]")
RETURN NIL
METHOD SaveButton( ) CLASS MarkupLetter
LOCAL oAskname AS AskLetterName
LOCAL ptrhandle AS USUAL
IF Empty(self:LetterName)
	* Ask for name for Letter:
	(oAskname := AskLetterName{SELF,cExt}):Show()
	self:LetterName:=oAskname:cName
ENDIF
SetPath(CurPath)
ptrhandle := FCreate(CurPath+"\"+self:LetterName)
FWrite(ptrHandle, SELF:oDCEditLetter:Currenttext)
FClose(ptrHandle)
self:Owner:Templatename:=self:LetterName 
self:Owner:Templates:=self:LetterName
SELF:EndDialog()
RETURN
STATIC DEFINE MARKUPLETTER_EDITLETTER := 100 
STATIC DEFINE MARKUPLETTER_KEYWORD := 102 
STATIC DEFINE MARKUPLETTER_REPEATBUTTON := 103 
STATIC DEFINE MARKUPLETTER_SAVEBUTTON := 101 
STATIC DEFINE MARKUPLETTERRICH_EDITLETTER := 103 
STATIC DEFINE MARKUPLETTERRICH_KEYWORD := 102 
STATIC DEFINE MARKUPLETTERRICH_REPEATBUTTON := 101 
STATIC DEFINE MARKUPLETTERRICH_SAVEBUTTON := 100 
DEFINE MEMBER_START := "#22#"
	CLASS myDialFontDialog INHERIT StandardFontDialog
METHOD SetFont(prFont) CLASS myDialFontDialog
	SELF:Font:=prFont
RETURN

CLASS MyFont INHERIT Font
METHOD GetHeight() CLASS MyFont
	RETURN SELF:LFHeight
METHOD GetPointSize() CLASS MyFONT
	RETURN iPointSize
METHOD SetCharSet(iCh) CLASS MyFont
	SELF:LFCharSet:=iCh
	RETURN
METHOD SetHeight(iHt) CLASS MyFont
	SELF:LFHeight:=iHt
	RETURN
METHOD SetPointSize(nPnt) CLASS MyFONT
	SELF:iPointSize:=nPnt
	SELF:SetHeight(Round(-(nPnt*96)/72,0))
	RETURN
DEFINE PAGE_END := "#20#"
CLASS PointSize INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS PointSize

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #PonitSize

    cPict       := ""
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := ""
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Size of a point", "", "" },  "N", 12, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




CLASS PointsSize INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS PointsSize

    LOCAL   oHlTemp                 AS OBJECT
    LOCAL   cPict                   AS STRING
    LOCAL   nMinLen                 AS INT
    LOCAL   lRequired               AS LOGIC
    LOCAL   symHlName               AS SYMBOL
    LOCAL   cTypeDiag               AS STRING
    LOCAL   cTypeHelp               AS STRING
    LOCAL   cLenDiag                AS STRING
    LOCAL   cLenHelp                AS STRING
    LOCAL   cMinLenDiag             AS STRING
    LOCAL   cMinLenHelp             AS STRING
    LOCAL   cRangeDiag              AS STRING
    LOCAL   cRangeHelp              AS STRING
    LOCAL   cReqDiag                AS STRING
    LOCAL   cReqHelp                AS STRING
    LOCAL   cValidDiag              AS STRING
    LOCAL   cValidHelp              AS STRING
    LOCAL   nMinRange               AS USUAL
    LOCAL   nMaxRange               AS USUAL
    LOCAL   xValidation             AS USUAL

    symHlName   := #PoitnSize

    cPict       := ""
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := ""
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := -1
    nMinRange   := NIL
    nMaxRange   := NIL
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Size of a point", "", "" },  "N", 12, 0 )


    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF


    IF SLen(cTypeDiag) > 0 .OR. SLen(cTypeHelp) > 0
        SELF:oHLType := HyperLabel{symHlName,, cTypeDiag, cTypeHelp }
    ENDIF


    IF SLen(cLenDiag) > 0 .OR. SLen(cLenHelp) > 0
        SELF:oHLLength := HyperLabel{symHlName,, cLenDiag, cLenHelp }
    ENDIF


    IF nMinLen != -1
        IF SLen(cMinLenDiag) > 0 .OR. SLen(cMinLenHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cMinLenDiag, cMinLenHelp }

            SELF:SetMinLength(nMinLen, oHlTemp)
        ELSE
            SELF:SetMinLength(nMinLen)
        ENDIF
    ENDIF


    IF !IsNIL(nMinRange) .OR. !IsNIL(nMaxRange)
        IF SLen(cRangeDiag) > 0 .OR. SLen(cRangeHelp) > 0
            oHlTemp := HyperLabel{symHlName,, cRangeDiag, cRangeHelp }
            SELF:SetRange(nMinRange, nMaxRange, oHlTemp)
        ELSE
            SELF:SetRange(nMinRange, nMaxRange)
        ENDIF
    ENDIF


    IF !IsNIL(xValidation)
        IF SLen(cValidDiag) > 0 .OR. SLen(cValidHelp) > 0
            SELF:oHLValidation:= HyperLabel{symHlName,, cValidDiag, cValidHelp }

            SELF:SetValidation(xValidation, SELF:oHLValidation)
        ELSE
            SELF:SetValidation(xValidation)
        ENDIF
    ENDIF


    IF lRequired
        IF SLen(cReqDiag) > 0 .OR. SLen(cReqHelp) > 0
            oHLTemp := HyperLabel{symHlName,, cReqDiag, cReqHelp }

            SELF:SetRequired(lRequired, oHLTemp)
        ELSE
            SELF:SetRequired(lRequired)
        ENDIF
    ENDIF


    RETURN SELF




DEFINE PRINT_END := "#21#"
CLASS PrintDialog INHERIT _PrintDialog
	
	declare method prstart,ReInitPrint,RemovePrFile,PrintLine,RollBack
ACCESS Beginreport() CLASS PrintDialog
RETURN SELF:FIELDGET(#_Beginreport)

ASSIGN Beginreport(uValue) CLASS PrintDialog
RETURN _Beginreport := uValue


METHOD CancelButton() CLASS PrintDialog

	SELF:lPrintOk := FALSE
	SELF:EndDialog()
	
	RETURN SELF
METHOD CopyPers(oPerson) CLASS PrintDialog
	* Copy of array with record-id in database Person (oPers)
	LOCAL i AS INT
	self:oPrintJob:oPers := oPerson
	RETURN TRUE

Method Flush() Class PrintDialog
	// Flushes print buffer to output device and record new save point 
	local i as int
	// print prepared lines
	if self:Destination == "File" 
		for i:=1 to Len(self:oPrintJob:aFIFO)
			FWriteLine(self:ptrHandle, self:oPrintJob:aFIFO[i]+iif(self:lRTF.and.AtC('\trowd',self:oPrintJob:aFIFO[i])=0,"\par",'')) 
		next
		self:oPrintJob:aFIFO:={} // reset buffer 
		self:lSuspend:=true
	endif
	self:savePage:=self:Page
	self:saveRow:=self:row
	self:FiFoPtr:=Len(self:oPrintJob:aFIFO)
	self:saveBeginReport:=self:_Beginreport 
	return
METHOD INIT( oOwner, cCaption, lLabel, nMaxWidth,nOrientation,cExtension ) CLASS PrintDialog
	* lLabel: true: printing of labels
	* nMaxWidth: maximum width of a line in the report (not applicable for labels)
	Default(@nOrientation,0)
	Default(@lLabel,FALSE)
	Default(@nMaxWidth,0)
	Default(@cExtension,"txt")

	SUPER:INIT( oOwner )

	// Allow for a window title	
	IF cCaption != NIL
		SELF:Heading := cCaption
		SELF:Caption := "Print " + cCaption
	ENDIF
	self:Extension:=cExtension 
	self:oDCFileType:Value:=cExtension
	SELF:Label := lLabel
	SELF:MaxWidth := nMaxWidth
	SELF:lPrintOk := FALSE
	SELF:ToFileFS := FileSpec{}

	self:oPrinter	:= PrintingDevice{}
	IF Empty(nOrientation)
		nOrientation := WycIniFS:GetInt("Runtime", "PrintOrientation" )
	ENDIF
	IF !Empty(nOrientation)
		self:oPrinter:Orientation:=nOrientation
	ELSE	
		self:oPrinter:Orientation:= DMORIENT_PORTRAIT  // default portrait
	ENDIF

	self:oDCPrinterText:Value := "Default Printer - ( " + AllTrim( self:oPrinter:Device ) + ;
		" on " + AllTrim( self:oPrinter:Port ) + " )"
	SetPath(CurPath)
	IF Label
		self:oDCPrinterText:Hide()
		self:oCCPrinterRadioButton:Hide()
		self:oCCScreenRadioButton:Hide()
		self:oCCToFileRadioButton:Hide()
		self:oDCDestination:Hide() 
		self:oDCDestination:Value := "Printer"
		self:oPrintJob := PrintJob{self:cCaption,self:oPrinter,self:Label,self:MaxWidth,self:Destination}
	else 	
		self:oDCDestination:Value := "Screen"
	ENDIF
	IF self:MaxWidth > 0
		self:oDialFont:Font:SetPointSize(Min(10,Round((900*WinScale)/self:MaxWidth,0)))
	ENDIF
	
	RETURN self 
METHOD InitRange(mRange) CLASS PrintDialog
	IF !Empty(mRange)
		oDCPageRange:Value := "Selection"
		oDCFromPage:Value := mRange:Min
		oDCToPage:Value := mRange:Max
		oOrigRange:=mRange
		oDCFixedText1:Show()
		oDCFromPage:Show()
		oDCToPage:Show()
	ENDIF
	
	RETURN NIL

METHOD OkButton(cDest) CLASS PrintDialog

	LOCAL nMax, nMin,nRet AS INT
	Local cDefFolder as string 
	local lError as logic 
	
   self:lRTF:=false
	IF IsNil(cDest)
		self:Destination := self:oDCDestination:Value
	ELSE
		self:Destination:=cDest
	ENDIF
	if self:Destination # "File"
		self:Extension:=""
	elseif self:Extension="xls"
		if self:oDCFileType:Value="txt"
			self:Extension:="txt"
		endif
	endif
	self:oPrintJob := PrintJob{self:cCaption,self:oPrinter,self:Label,self:MaxWidth,self:Destination,self:Extension}
	IF self:oDCPageRange:Value == "Selection"
		nMin := Integer(Val(self:oDCFromPage:TextValue))
		nMax := Integer(Val(self:oDCToPage:TextValue))
		IF Empty(nMax)
			nMax := 99999
		ENDIF
		self:oRange := Range{nMin,nMax }
	ELSE
		IF !Empty(self:oOrigRange)
			self:oRange := Range{1,self:oOrigRange:Max}
		ENDIF
	ENDIF

	SELF:lPrintOk := TRUE
// 	self:lRTF:=false

	IF self:Destination == "File" 
		self:ToFileFS:=AskFileName(self,self:Heading,"Print to file","*."+self:Extension,self:Extension)
		
		IF self:ToFileFS==null_object
			self:lPrintOk := FALSE
			return false 
		ENDIF
		IF self:Extension=="xls" .and. self:Destination="File"
			self:lXls:=true
		ENDIF
		if	self:Extension=='doc'
			self:lRTF:=true
			IF sEntity=="RUS" 
				self:cRTFHeader:=self:LanguageRus+self:RTFFormat
			ELSEIF sEntity=="JPN"
				self:cRTFHeader:=self:LanguageJap+self:RTFFormat
			ELSEIF sEntity=="CZR" .or. sEntity=="POL" .or. sEntity=="SKD"
				self:cRTFHeader:=self:LanguageCZ+self:RTFFormat
			ELSEIF sEntity=="THD"
				self:cRTFHeader:=self:LanguageTHD+self:RTFFormat
			ELSE
				self:cRTFHeader:=self:LanguageDefault+self:RTFFormat
			ENDIF
		endif		
	endif
	if self:Label
		* Check if number of rows below minimum (4 of 3 +KIXcode-row):
		IF CountryCode="31"
			IF self:oPrintJob:nLblLines < 3
				lError := true
			ENDIF
		ELSE
			IF self:oPrintJob:nLblLines < 4
				lError := true
			ENDIF
		ENDIF
		IF lError
			(ErrorBox{self,"Too less lines per label"}):Show()
			self:lPrintOk := FALSE 
			return false
		endif

	endif
	IF Empty(self:Pagetext)
		self:Pagetext:=self:oLan:RGet('Page',,"!")
	ENDIF
	if self:lPrintOk
	  	SetDecimalSep(Asc(DecSeparator))   // set decimal separator to local value
	endif

	
	SELF:EndDialog()
	
	RETURN
METHOD PrintLine (LineNbr ref int,PageNbr ref int,LineContent:='' as string,HeadingLines:={} as array,skipcount:=0 as int) as logic CLASS PrintDialog
	* Output to printer or window of LineContent
	*
	* Calling: PrintLine(@LineNbr,@PageNbr,LineContent,{heading1,heading2,...},skipcount)
	* Parameters:
	* LineNbr: new value returned; reset to zero causes page skip 
	*          equal to last linenbr means: add content at the end of last line content
	* PageNbr : idem
	* LineContent  : Content of to be outputted line; when nil, only test page skip
	* HeadingLines: Array with HeadingLines; 1st less than 60 because of needed space for date and page number
	* skipcount: Optional to force page skip if not enough space for this line content + skipcount lines
	* Beginreport: optionele indication of report start which forces printing of the heading lines independent of a page skip; 
	*				Setting of this values: PrintDialog:Beginreport:=true 
	* Used export variabels:
	* - self:PaperHeight 
	* - lSuspend: if true write to file will be suspended untill end of printing or lSuspend = false
	*

	LOCAL i as int,kopdate as STRING
	LOCAL skippage:=FALSE as LOGIC 
	local lSuspend:=self:lSuspend as logic
	LOCAL Widthpage:=self:oPrintJob:PaperWidth as int
	LOCAL cFileName as STRING
	IF Destination == "File" .and.Empty(self:ptrHandle)
		cFileName:= self:ToFileFS:FullPath
		self:ptrHandle:=MakeFile(@cFileName,"Printing to file")
		IF Empty(self:ptrHandle)
			RETURN FALSE
		ELSEIF self:ptrHandle = F_ERROR
			RETURN true
		endif
		if self:lRTF
			AAdd(self:oPrintJob:aFIFO,self:cRTFHeader+AllTrim(Str(self:oPrintJob:iPointSize*2))+" ")
		endif
	endif
	
	if !Empty(LineNbr).and.LineNbr==(self:row-1)
		self:oPrintJob:aFIFO[Len(self:oPrintJob:aFIFO)]+=LineContent 
		LineNbr++
		return true
	elseif self:Destination == "File" .and.Len(self:oPrintJob:aFIFO)>0 .and.!lSuspend 
		// print prepared lines
		for i:=1 to Len(self:oPrintJob:aFIFO)
			FWriteLine(self:ptrHandle, self:oPrintJob:aFIFO[i]+iif(self:lRTF.and.AtC('\trowd',self:oPrintJob:aFIFO[i])=0,"\par",'')) 
		next
		self:oPrintJob:aFIFO:={} // reset fifo 
	endif
	IF self:_Beginreport
		IF !self:lXls .and. (PageNbr>0.or.LineNbr>0).and. self:row +Max(skipcount,4)> Integer(self:oPrintJob:PaperHeight)
			// When not first page and more than half of the page printed:
			skippage:=true
			IF self:Destination == "Printer"
				AAdd(self:oPrintJob:aFIFO,PAGE_ENd)
			elseif self:Destination == "File"
				AAdd(self:oPrintJob:aFIFO,iif(self:lRTF,"\page",CHR(ASC_FF )))
			ENDIF
		ENDIF
		LineNbr:=self:row // reset to original value
	ELSEIF (Empty(PageNbr) .or. ((self:row+skipcount+1) > self:oPrintJob:PaperHeight .or. Empty(LineNbr)).and.!self:lXls)
		skippage:=true
		IF (PageNbr>0.or.LineNbr>0)
			if self:Destination == "Printer"
				AAdd(self:oPrintJob:aFIFO,PAGE_ENd)
			elseif self:Destination == "File"
				AAdd(self:oPrintJob:aFIFO,iif(self:lRTF,"\page",CHR(ASC_FF )))
			endif
		ENDIF
	ENDIF
	IF skippage .or. self:_Beginreport.or.PageNbr=0 .or. self:lXls.and.Empty(LineNbr)
		IF skippage.or.PageNbr=0
			++PageNbr
			self:Page:=PageNbr
			LineNbr := 0
		ELSEIF LineNbr>0
			// add two space lines:
			if self:Destination == "File"
				AAdd(self:oPrintJob:aFIFO,iif(self:lRTF,'\par',''))
				AAdd(self:oPrintJob:aFIFO,iif(self:lRTF,'\par',''))
			else
				AAdd(self:oPrintJob:aFIFO," ")
				AAdd(self:oPrintJob:aFIFO," ")
			endif
			LineNbr+=2
		ENDIF
		IF .not.Empty(HeadingLines)
			FOR i = 1 to Len(HeadingLines)
				IF self:lXls
					AAdd(self:oPrintJob:aFIFO,HeadingLines[i])
				ELSE
					IF LineNbr=0
						kopdate:="  "+DToC(date())+' '+PageText+' '+;
							LTrim(Str(PageNbr,4))
						if self:Destination=="File"
							AAdd(self:oPrintJob:aFIFO,Pad(HeadingLines[1],Widthpage-Len(kopdate))+kopdate+iif(self:lRTF,"\par",''))
						else
							AAdd(self:oPrintJob:aFIFO,Pad(HeadingLines[1],Widthpage-Len(kopdate))+kopdate)
						endif
					ELSE
						if self:Destination=="File"
							AAdd(self:oPrintJob:aFIFO,HeadingLines[i]+iif(self:lRTF.and.(!i=Len(HeadingLines).or.AtC('\trowd',HeadingLines[i])=0),"\par",''))
						else
							AAdd(self:oPrintJob:aFIFO,SubStr(HeadingLines[i],1,Widthpage))
						endif	
					ENDIF
				ENDIF
				++LineNbr
			NEXT
		ENDIF
	ENDIF
	self:_Beginreport:=FALSE
	IF Len(LineContent)>0
		AAdd(self:oPrintJob:aFIFO,LineContent)
		++LineNbr
	ENDIF
	self:row:=LineNbr
	RETURN true
METHOD prstart(lModeless:=true as logic) as usual CLASS PrintDialog
	* self:lRTF:		true: a RTF-format is generated, i.e. at end of each line: /par and: at end }}
	* cRTFHeading: start rtf-text for specifying format
	LOCAL oPrintShow as Window
	LOCAL i as int
	LOCAL MyFileName, RetFileName,cFileName as STRING
	local aFIFO:=self:oPrintJob:aFIFO as array
	LOCAL scrFont as myFont
	local mySize as dimension 
	/*	LOCAL cRTFHeader:= "{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fmodern\fprq1\fcharset0 Courier New;}}"+;
	"{\colortbl ;\red0\green0\blue0;}\viewkind4\uc1\pard\cf1\lang1043\viewkind1\paperw16838\paperh11906"+;
	"\lndscpsxn\margl1400\margr1200\margt600\margb600\f0\fs"   */
	/*	LOCAL cRTFHeader:= "{\rtf1\ansi\ansicpg1251\deff0\deflang1049{\fonttbl{\f0\fmodern\fprq1\fcharset0 Courier New;}"+;
	"{\f1\fmodern\fprq1\fcharset204{\*\fname Courier New;}Courier New CYR;}}"+;
	"{\colortbl ;\red0\green0\blue0;}\viewkind4\uc1\pard\viewkind1\paperw16838\paperh11906\lndscpsxn\margl1400\margr1200\margt600\margb600\f1\fs" */

	self:Pointer := Pointer{POINTERHOURGLASS} 
	* Starten van printer
	IF self:Destination == "Printer"
		self:oPrintJob:oWaitPrint := Wait_for_printer{self}
		self:oPrintJob:oWaitPrint:Caption := self:Caption
		self:oPrintJob:oWaitPrint:Show()
		self:oPrintJob:Idle()
		self:oPrintJob:Start(self:oRange)
		self:Pointer := Pointer{POINTERARROW}
		
		RetFileName:= "1"
	ELSEIF self:Destination == "Screen" 

		if lModeless
			oPrintShow:= PrintShow2{oMainWindow,{self:oDialFont:Font,lModeless,self}}
		else
			oPrintShow := PRINTSHOW{oMainWindow,{self:oDialFont:Font,lModeless,self}} 
		endif
		self:Pointer := Pointer{POINTERARROW}
		mySize:=oPrintShow:Size
		mySize:Width:=oMainWindow:Size:width
		mySize:Height:=0.8*oMainWindow:Size:Height
		oPrintShow:Size:=mySize
		oPrintShow:Show(SHOWCENTERED)
		// 		oPrintShow:Show(SHOWZOOMED)
		
		RetFileName:= "2"
		self:oPrintJob:lLblFinish:=true
		RETURN oPrintShow
	ELSE
		*		write to file
		if !Empty(self:ptrHandle)
			IF Len(aFIFO)>0
				// print last lines: 
				for i:=1 to Len(aFIFO)
					FWriteLine(self:ptrHandle, aFIFO[i]+iif(self:lRTF.and.AtC('\trowd',aFIFO[i])=0,"\par",'')) 
				next
				self:oPrintJob:aFIFO:={} // reset fifo
			endif
			if self:lRTF
				FWriteLine(self:ptrHandle,"\par }")   // extra eol
			endif
			FClose(self:ptrHandle) 
			self:ptrHandle:=null_ptr
		endif
	ENDIF
	self:oPrintJob:lLblFinish:=true
	self:Pointer := Pointer{POINTERARROW} 
	SetDecimalSep(Asc('.'))      //back to .
   if IsObject(self:ToFileFS) .and. !Empty(self:ToFileFS)
		RETURN(self:ToFileFS:FullPath)
   else
   	return ''
   endif
METHOD prstop(Noskip) CLASS PrintDialog

IF IsObject(oPrintJob)
	IF !OprintJob==NULL_OBJECT
		oPrintJob:Destroy()
	ENDIF
ENDIF
RETURN TRUE


METHOD ReInitPrint(dummy:=nil as logic) as void pascal CLASS PrintDialog
SELF:oPrintJob:= NULL_OBJECT
self:oPrintJob := PrintJob{cCaption,self:oPrinter,self:Label,self:MaxWidth,,self:Extension}
RETURN 
METHOD RemovePrFile(lModeless:=true as logic) as logic CLASS PrintDialog 
// remove a produced print file
IF self:Destination == "File"
	if !Empty(self:ptrHandle)
		FClose(self:ptrHandle) 
		self:ptrHandle:=null_ptr
	endif
	self:ToFileFS:DELETE()
endif	 
return true
Method RollBack(LineNbr ref int,PageNbr ref int) as void Pascal class PrintDialog
	// rolls back printed lines to save point set by latest Flush
	ASize(self:oPrintJob:aFIFO,self:FiFoPtr)
	self:row:=self:saveRow
	self:Page:=self:savePage
	LineNbr:=self:row
	PageNbr:=self:Page
	self:_Beginreport:=self:saveBeginReport
	return 

METHOD SetupButton( ) CLASS PrintDialog
LOCAL structDevMode AS _WINDevMode
	IF self:oPrinter:IsValid()
		self:oPrinter:Setup()
		WycIniFS:WriteInt( "Runtime", "PrintOrientation", self:oPrinter:Orientation)
	ENDIF
	self:oDCPrinterText:Value := "Default Printer - ( " + AllTrim( self:oPrinter:Device ) + ;
	" on " + AllTrim( self:oPrinter:Port ) + " )"

	RETURN 
method ShowFileType() class PrintDialog
	if self:oCCToFileRadioButton:Value==true .and. self:Extension="xls"
			self:oCCfiletype1:Show()
			self:oCCfiletype2:Show()
			self:oDCFileType:Show()
	else
		self:oCCfiletype1:Hide()
		self:oCCfiletype2:Hide()
		self:oDCFileType:Hide()
		
	endif 
return	
METHOD GetResolution() CLASS PrintingDevice
LOCAL structDevMode	AS _WINDEVMODE
LOCAL nResolution AS USUAL

structDevMode := SELF:GetDevMode()	
nResolution:=structDevMode.dmPrintQuality
IF IsNumeric(nResolution)
	IF nResolution>8
		RETURN nResolution
	ENDIF
ENDIF
nResolution:=structDevMode.dmyResolution
IF IsNumeric(nResolution)
	IF nResolution>8
		RETURN nResolution
	ENDIF
ENDIF
RETURN 0


CLASS Printjob INHERIT Printer
	EXPORT PaperHeight AS INT
	EXPORT PaperWidth AS INT
	EXPORT LineHeight AS INT
	EXPORT nLeft AS INT
	EXPORT nTop AS INT
	EXPORT nBottom AS INT
	EXPORT iPointSize := 12 as int  // character size in points (1/120 inch)
	EXPORT Resolution as int // resolution in dots per inch (default 600)
 	EXPORT aFIFO := {}
 	EXPORT nFifoPntr := 1 AS INT
	EXPORT oKixFont AS Font
	EXPORT oRange AS Range
	EXPORT nCurPage AS INT
	EXPORT Label AS LOGIC
	EXPORT Extension as string
	EXPORT lLblFinish AS LOGIC
	EXPORT oPers as SQLSelect
	EXPORT oWaitPrint AS wait_for_printer
	EXPORT nLblHeight as int // height label in canvascordinates
	EXPORT nLblWidth as int  // width label in canvascordinates
	EXPORT nLblBottom as int  // bottom margin label in canvascordinates
	EXPORT nLblMargin as int  // left margin label in canvascordinates
	EXPORT nLblLines as int // nbr of lines per label
	EXPORT nLblChars as int  // nbr of characters per label-line
	EXPORT nLblColCnt as int // nbr of columns of labels
	EXPORT nLblVertical as int // nbr of labels vertically on a page
	EXPORT nLblKIXHeight as int // height TXkode line in canvascordinates  
	
	declare method Stckrprt

METHOD GetFont()  CLASS Printjob
RETURN SELF:Font
METHOD INIT(cJobname, oPrintingDev, lLabel, nMaxWidth,cDestination,Extension) CLASS Printjob
	LOCAL oSize AS Dimension
	LOCAL oKixSize AS Dimension
	LOCAL nTopM, nRightM,nHeight,nWidth, nHelpW,nHelpH AS INT
	LOCAL nResolution:=600 // dots per inch
	Default(@Extension,null_string)
	iPointSize:=12
   self:Extension:=Extension
	SUPER:INIT(cJobname,oPrintingDev)
	self:Label := lLabel

	IF !Empty(SELF:Font)
		 SELF:Font := NULL_OBJECT
	ENDIF
*	Bepaal resolutie:
	IF !oPrintingDev==NULL_OBJECT
		IF oPrintingDev:ISValid()
			nResolution:= oPrintingDev:GetResolution()
		ENDIF
	ENDIF
	self:Font := Font{FONTMODERN,12,"Courier New"}
	self:iPointSize:=12
// 	self:Font := Font{,12,"Courier New"}
// 	self:Font := Font{,12,"Cordia New"}
	self:Font:PitchFixed := true
	oSize := SELF:SizeText("X")
	IF Empty(nResolution)
		nResolution := oSize:Width*10
	ENDIF
	SELF:Resolution:=nResolution  // save in object

	* Bepaal dimensie voor default font (12 point)
	* Bepaal margins: 
	self:Initialize(nMaxWidth)

	RETURN SELF
	
METHOD Initialize( nMaxWidth) CLASS Printjob
	LOCAL oSize:=self:SizeText("X") as Dimension
	local iPointSizeOrg:=self:iPointSize as int
	LOCAL oKixSize as Dimension
	LOCAL oSys as SQLSelect
	LOCAL nTopM, nRightM,nHeight,nWidth, nHelpW,nHelpH as int
	LOCAL nResolution:=self:Resolution as int // dots per inch 
	
	IF self:Label
		nTopM:=Round((WycIniFS:GetInt( "Runtime", "stckr_TopMargin")*nResolution)/25.4,0)
		nLeft:=Round((WycIniFS:GetInt( "Runtime", "stckr_LeftMargin")*nResolution)/25.4,0)
		iPointSize := WycIniFS:GetInt( "Runtime", "stckr_PointSize")
		* Establish height of line woth KIXkode in canvas coordinates:
		IF CountryCode="31"
			* Fot The Netherlands determine Kix Barkode font (5 mm Height, 6 chars/inch):
			oKixSize := Dimension{Round(oSize:Width*20/12,0),;
			Round((5*nResolution)/25.4,0)}
			self:oKixFont := Font{,oKixSize,"KIX Barcode"}
			* reserve 2 mm extra above barcode:
			self:nLblKIXHeight := oKixSize:Height+Round((2*nResolution)/25.4,0)
		ENDIF
	ELSE
		IF self:Extension=='doc' .or. self:CanvasArea==null_object .or.Empty(self:CanvasArea:Height)
			// Fixed A4-size landscape when sending print by e-mail:
			// In Twips (rtf): paperw16838\paperh11906margl1400\margr1200\margt600\margb600
			// twips=1/20 pt, 1pt=1/1440 inch=2,54/1440cm
			// \fsN : font size in half-points
			nTopM:=Round((600*nResolution)/1440,0)
			nLeft:=Round((1400*nResolution)/1440,0)
			nRightM:=Round((1200*nResolution)/1440,0)
			nBottom:=nTopM
			nWidth:=Round((16838*nResolution)/1440,0)
			nHeight:=Round((11906*nResolution)/1440,0)
		ELSE
			oSys := SQLSelect{"select topmargin,leftmargin,rightmargn,bottommarg from sysparms",oConn}
			IF oSys:RecCount>0
				nTopM := Round((oSys:TopMargin*nResolution)/25.4,0)
				nLeft := Round((oSys:LeftMargin*nResolution)/25.4,0)
				nRightM := Round((oSys:RightMargn*nResolution)/25.4,0)
				nBottom := Round((oSys:BottomMarg*nResolution)/25.4,0)
				oSys:Close()
			ENDIF
			nWidth:=self:CanvasArea:Width
			nHeight:=self:CanvasArea:Height
		ENDIF
		* Adjust pointsize to MaxWidth:
			* width in characters:
			* (width in dots - marges left and right) / character width :
		nHelpW:=oSize:Width
		IF Empty(nHelpW)
			nHelpW:=20
		ENDIF
		self:PaperWidth:=Integer((nWidth-nLeft-nRightM)/nHelpW)
		IF nMaxWidth > self:PaperWidth
			self:iPointSize := Integer((self:PaperWidth  * iPointSizeOrg) / nMaxWidth)
		ENDIF
	ENDIF

	* Calculate new dimension corresponding with PointSize:
	oSize:Height := Round((self:iPointSize*oSize:Height/iPointSizeOrg)*1.07,0)
	oSize:Width := Round(self:iPointSize*oSize:Width/iPointSizeOrg,0) 
	if Empty(oSize:Height)
		oSize:Height:=105
	endif
	if Empty(oSize:Width)
		oSize:Width:=55
	endif
	* Adjust font to new Pointsize:
	self:Font := null_object
	self:Font := Font{FONTMODERN,self:iPointSize,"Courier New"}
	self:Font:PitchFixed := true
	
	* Calculate final dimension:
	* calculate row height in dots:
	nHelpH:=oSize:Height
	IF Empty(nHelpH)
		nHelpH:=36
	ENDIF
	self:LineHeight := nHelpH
	* Determine printing top in dots:
	IF self:Label
		nTop := self:CanvasArea:Height - nTopM
		* calculate  Height,width and margin label in canvas coordinates:
		nLblHeight := Max(Round((WycIniFS:GetInt( "Runtime", "stckr_height" )*nResolution)/25.4,0),1)
		nLblWidth  := Max(Round((WycIniFS:GetInt( "Runtime", "stckr_width" )*nResolution)/25.4,0),1)
		* Calculate number of rows and columns:
	    nLblVertical := Max(Round((self:CanvasArea:Height-nTopM)/nLblHeight,0),1)
	    nLblColCnt := Max(Round((self:CanvasArea:Width-nLeft)/nLblWidth,0),1)
	    * calculate margins within label:
	    nLblBottom := Round((nLblVertical*nLblHeight)-(self:CanvasArea:Height-nTopM),0)
	    nLblBottom := Max(nLblBottom,nResolution/25.4) && minimaal 1 mm ondermarge
	    nLblMargin := Round((nLblColCnt*nLblWidth)-(self:CanvasArea:Width-nLeft),0)
	    nLblMargin := Max(nLblMargin,nResolution/25.4) && minimaal 1 mm rechtermarge
		* calculate Height labels in lines en width in chars:
		nLblLines := Min(Integer((nLblHeight-nLblKIXHeight-nLblBottom) / self:LineHeight),6)
		nLblChars := Integer((nLblWidth-nLblMargin) / oSize:Width)
	ELSE
		//nTop := SELF:CanvasArea:Height - nTopM
		nTop := nHeight - nTopM
		* Height in rows: (Height in dots - upper and lower margin)/line Height :

		self:PaperHeight := Integer((nHeight-nTopM-nBottom)/self:LineHeight)
		* width in chars:
		* (width in dots - left and Right Margn) / charactar width :
		IF !Empty(nMaxWidth)
			self:PaperWidth := nMaxWidth
		ELSE
			self:PaperWidth  := Integer((nWidth-nLeft-nRightM) /oSize:Width)
		ENDIF
	ENDIF 

return
METHOD PrinterExpose(oExposeEvent) CLASS PrintJob
	* Printing of buffer self:aFiFo with address-record-ids
	* self:aFiFo can has two kinds of contents
	*	-	flat text lines to be printed as fifo-buffer,
	*	-	record-id pointing to persons of which addresslabels has to be printed
	*
	LOCAL iX AS INT, iY AS INT
	LOCAL i, j as longint

	iX := nLeft
	iY := Min(self:nTop,oExposeEvent:ExposedArea:Top)

	IF SELF:Label
		FOR i = self:nFifoPntr to self:oPers:RECCOUNT step self:nLblColCnt
			IF iY >= self:nLblHeight-self:nLblBottom // Sufficient space for one row of labels left?
				IF Empty(self:oRange).or.(self:nCurPage >= self:oRange:Min .and. self:nCurPage <= self:oRange:Max)
					self:Stckrprt(i,iY)
				ENDIF
				iY := iY - self:nLblHeight
			ELSE
				self:nFifoPntr := i
				++self:nCurPage
				IF Empty(self:oRange)
					RETURN TRUE
				ENDIF
				IF self:nCurPage > self:oRange:Max
					self:lLblFinish := FALSE  // All lables have not been printed yet
					EXIT
				ELSEIF self:nCurPage > self:oRange:Min
					RETURN TRUE
				ENDIF
				* pages skipped, try next page:
				iY := Min(self:nTop,oExposeEvent:ExposedArea:Top)
				i := i - self:nLblColCnt // reset i 
			ENDIF
			IF i + self:nLblColCnt > self:oPers:RECCOUNT
				++self:nCurPage
				self:nFifoPntr := i+self:nLblColCnt
				RETURN TRUE // forces last pageskip
			ENDIF
		NEXT
		IF i > self:oPers:RECCOUNT
			self:lLblFinish := true // All labels have been printed
		ENDIF
	ELSE
		FOR i = self:nFifoPntr to Len(self:aFiFo)
			IF self:aFiFo[i] == ACCEPT_START
				IF CountryCode=="47"
					// position on 5/6 inch above bottom,
					iY:=Round((5*SELF:Resolution)/6,0) // in dots
				ENDIF
				LOOP
			ENDIF
			IF self:aFiFo[i] == PAGE_END
				++self:nCurPage
				self:nFifoPntr := i+1
				IF Empty(self:oRange)
					RETURN TRUE
				ELSEIF self:nCurPage > self:oRange:Max
					self:lLblFinish := true  // All pages have not been printed yet
					EXIT
				ELSEIF self:nCurPage > self:oRange:Min
					RETURN TRUE
				ELSE
					* pagina's overgeslagen, volgende opnieuw proberen:
					iY := Min(self:nTop,oExposeEvent:ExposedArea:Top)
					LOOP
				ENDIF
			ENDIF
			iY := iY - SELF:LineHeight
			IF iY > self:nBottom
				IF Empty(self:oRange).or.(self:nCurPage >= self:oRange:Min .and. self:nCurPage <= self:oRange:Max)
					self:TEXTprint(self:aFiFo[i],Point{iX,iY})
				ENDIF
			ENDIF
			IF i == Len(self:aFiFo)
				++self:nCurPage
				self:nFifoPntr := i+1
*				RETURN TRUE // forces last pageskip
			ENDIF
		NEXT
		IF i > Len(self:aFiFo)
			self:lLblFinish := true // All pages have been printed
		ENDIF
	ENDIF
	SELF:oWaitPrint:EndDialog()
	RETURN FALSE
		
METHOD Start(oRangeV,oFont) CLASS Printjob
	IF !Empty(oRangeV)
		self:oRange := oRangeV
	ENDIF
	self:nCurPage := 1
	self:nFifoPntr := 1
	SUPER:Start()
	RETURN TRUE
METHOD Stckrprt(nDisp as int,iY as int) as void pascal CLASS PrintJob
*****************************************************************************)
*  Name      : STCKRPRT.PRG
*              Printing of a row labels
*  Author    : K. Kuijpers
*  Date      : 01-01-1991
******************************************************************************


************** PARAMETERS  ***********************
*             with  displacement nDisp in array
* iY	      : current Y-coordinate
LOCAL m_rectel:=0
LOCAL m_adressen := {}
LOCAL oPrintFont := SELF:font AS font
LOCAL oSize AS Dimension
LOCAL i,j as int
LOCAL iX AS INT
if self:oPers:RECCOUNT<1
	return
endif
FOR m_rectel = nDisp to Min(nDisp+self:nLblColCnt-1,self:oPers:RECCOUNT)
	if self:oPers:EoF
		exit
	endif
   AAdd(m_adressen,MarkUpAddress(self:oPers,,self:nLblChars,self:nLblLines))
   self:oPers:Skip()
NEXT
FOR j =1 TO nLblLines
	iY := iY - SELF:LineHeight
	FOR i = 1 to Min(self:nLblColCnt,Len(m_adressen))
		iX := nLeft+(i-1)*self:nLblWidth
		SELF:TEXTprint(m_adressen[i,j],Point{iX,iY})
	NEXT
NEXT
IF sEntity == "NED"
	SELF:Font := NULL_OBJECT
	SELF:Font := SELF:oKixFont
	iY := iY - SELF:nLblKIXHeight
	FOR i = 1 to Min(self:nLblColCnt,Len(m_adressen))
		iX := self:nLeft+(i-1)*self:nLblWidth
		SELF:TEXTprint(m_adressen[i,j],Point{iX,iY})
	NEXT
	SELF:Font := NULL_OBJECT
	SELF:Font := oPrintFont
ENDIF
RETURN

STATIC DEFINE PRINTSCREEN_LISTPRINT := 100 
RESOURCE PRINTSHOW DIALOGEX  14, 22, 528, 350
STYLE	DS_3DLOOK|WS_POPUP|WS_CAPTION|WS_SYSMENU|WS_THICKFRAME
CAPTION	"Preview Print"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Preview Print", PRINTSHOW_LISTPRINT, "ListBox", LBS_NOTIFY|WS_CHILD|WS_BORDER|WS_VSCROLL|WS_HSCROLL, 0, 0, 538, 345
END

CLASS PRINTSHOW INHERIT DIALOGWINDOW 

	PROTECT oDCListPrint AS LISTBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  protect oOwner as Window
RESOURCE PrintShow2 DIALOGEX  4, 3, 537, 373
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Preview Print", PRINTSHOW2_LISTPRINT, "ListBox", LBS_NOTIFY|WS_CHILD|WS_BORDER|WS_VSCROLL|WS_HSCROLL, 0, 11, 538, 345
END

CLASS PrintShow2 INHERIT DATAWINDOW 

	PROTECT oDCListPrint AS LISTBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  protect oOwner as Window
METHOD Close(oEvent) CLASS PRINTSHOW2
	SUPER:Close(oEvent)
	//Put your changes here
// 	CollectForced()
self:Destroy()
	RETURN nil

METHOD FillPrint() CLASS PRINTSHOW2
	RETURN self:oOwner:oPrintJob:aFIFO
 method GoBottom() class PrintShow2
 self:oDCListPrint:CurrentItemNo:=self:oDCListPrint:ItemCount 
 return true
 method GoTop() class PrintShow2
 self:oDCListPrint:CurrentItemNo:=1 
 return true
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS PrintShow2 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"PrintShow2",_GetInst()},iCtlID)

oDCListPrint := ListBox{SELF,ResourceID{PRINTSHOW2_LISTPRINT,_GetInst()}}
oDCListPrint:FillUsing(Self:FillPrint( ))
oDCListPrint:HyperLabel := HyperLabel{#ListPrint,"Preview Print",NULL_STRING,NULL_STRING}
oDCListPrint:OwnerAlignment := OA_FULL_SIZE

SELF:Caption := "Preview Print"
SELF:HyperLabel := HyperLabel{#PrintShow2,"Preview Print",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS ListPrint() CLASS PrintShow2
RETURN SELF:FieldGet(#ListPrint)

ASSIGN ListPrint(uValue) CLASS PrintShow2
SELF:FieldPut(#ListPrint, uValue)
RETURN uValue

METHOD PostInit(oParent,uExtra) CLASS PRINTSHOW2
	//Put your PostInit additions here
	self:Caption := self:oParent:Caption
	oDCListPrint:Font(uExtra[1],FALSE)
	oDCListPrint:Font:PitchFixed := true 
	SendMessage( oDCListPrint:Handle(),LB_SETHORIZONTALEXTENT,oMainWindow:Size:Width,0L )
	RETURN nil
method PreInit(oParent,uExtra) class PRINTSHOW2
	//Put your PreInit additions here 
	self:oOwner:=uExtra[3]
	return nil

STATIC DEFINE PRINTSHOW2_LISTPRINT := 100 
METHOD Close(oEvent) CLASS PRINTSHOW
	SUPER:Close(oEvent)
	//Put your changes here
// 	CollectForced()
	
	self:Destroy()
	RETURN 

METHOD FillPrint() CLASS PrintShow
	RETURN self:oOwner:oPrintJob:aFIFO
METHOD Init(oParent,uExtra) CLASS PRINTSHOW 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"PRINTSHOW",_GetInst()},FALSE)

oDCListPrint := ListBox{SELF,ResourceID{PRINTSHOW_LISTPRINT,_GetInst()}}
oDCListPrint:FillUsing(Self:FillPrint( ))
oDCListPrint:HyperLabel := HyperLabel{#ListPrint,"Preview Print",NULL_STRING,NULL_STRING}
oDCListPrint:OwnerAlignment := OA_FULL_SIZE

SELF:Caption := "Preview Print"
SELF:HyperLabel := HyperLabel{#PRINTSHOW,"Preview Print","Preview Print",NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD PostInit(oParent,uExtra) CLASS PRINTSHOW
	//Put your PostInit additions here
	self:Caption := self:oParent:Caption
*	oDCListPrint:Font:=NULL_OBJECT
	oDCListPrint:Font(uExtra[1],FALSE)
	oDCListPrint:Font:PitchFixed := true 
	SendMessage( oDCListPrint:Handle(),LB_SETHORIZONTALEXTENT,oMainWindow:Size:Width,0L )
	self:bModal:=uExtra[2]
	RETURN NIL
method PreInit(oParent,uExtra) class PRINTSHOW
	//Put your PreInit additions here 
	self:oOwner:=uExtra[3]
	return NIL

STATIC DEFINE PRINTSHOW_LISTPRINT := 100 
STATIC DEFINE SHOWPRINT_LISTPRINT := 100 
FUNCTION StringdmOrientation(nO as int) as STRING
IF nO = DMORIENT_LANDSCAPE
	RETURN "Landscape"
ELSEIF nO = DMORIENT_PORTRAIT
	RETURN "Portrait"
ELSE
	RETURN "Unknown"
ENDIF

RESOURCE Wait_for_printer DIALOGEX  38, 28, 262, 39
STYLE	DS_3DLOOK|WS_POPUP|WS_CAPTION
CAPTION	"Printing"
FONT	8, "MS Sans Serif"
BEGIN
	CONTROL	"Cancel", WAIT_FOR_PRINTER_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 104, 12, 54, 13
END

class Wait_for_printer inherit DialogWinDowExtra 

	protect oCCCancelButton as PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
METHOD CancelButton( ) CLASS Wait_for_printer
	SELF:owner:oPrintjob:Abort()
	ASize(SELF:owner:oPrintjob:aFiFO,0)
	SELF:EndDialog()
	RETURN SELF
METHOD Close(oEvent) CLASS Wait_for_printer
	SUPER:Close(oEvent)
	//Put your changes here
	SELF:Destroy()
	RETURN NIL

method Init(oParent,uExtra) class Wait_for_printer 

self:PreInit(oParent,uExtra)

super:Init(oParent,ResourceID{"Wait_for_printer",_GetInst()},FALSE)

oCCCancelButton := PushButton{self,ResourceID{WAIT_FOR_PRINTER_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

self:Caption := "Printing"
self:HyperLabel := HyperLabel{#Wait_for_printer,"Printing",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

STATIC DEFINE WAIT_FOR_PRINTER_CANCELBUTTON := 100 
