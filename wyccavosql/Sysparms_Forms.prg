RESOURCE EditLog DIALOGEX  4, 3, 420, 281
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Source:", EDITLOG_FIXEDTEXT1, "Static", WS_CHILD, 12, 11, 32, 13
	CONTROL	"", EDITLOG_SOURCE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 44, 11, 112, 12, WS_EX_CLIENTEDGE
	CONTROL	"Date & Time:", EDITLOG_FIXEDTEXT2, "Static", WS_CHILD, 276, 11, 40, 12
	CONTROL	"", EDITLOG_LOGTIME, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 316, 11, 95, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITLOG_MMESSAGE, "Edit", ES_WANTRETURN|ES_READONLY|ES_AUTOHSCROLL|ES_AUTOVSCROLL|ES_MULTILINE|WS_TABSTOP|WS_GROUP|WS_CHILD|WS_BORDER|WS_VSCROLL|WS_HSCROLL, 12, 30, 400, 243, WS_EX_CLIENTEDGE
	CONTROL	"User:", EDITLOG_FIXEDTEXT3, "Static", WS_CHILD, 164, 11, 28, 13
	CONTROL	"", EDITLOG_USERID, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 192, 11, 76, 12, WS_EX_CLIENTEDGE
END

CLASS EditLog INHERIT DATAWINDOW 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCSource AS SINGLELINEEDIT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDClogtime AS SINGLELINEEDIT
	PROTECT oDCmMessage AS MULTILINEEDIT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCuserid AS SINGLELINEEDIT

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
	protect nLineLength:=100 as int
	protect cMessage as string 
method FillText() class EditLog
	// distrubute text over lines in Multiline Edit
	local n,nLines as int
	self:nLineLength:= Ceil(self:Size:width/6.5)
	nLines := MLCount(self:cMessage, self:nLineLength)
	self:mMessage:=''
	FOR n := 1 upto nLines
		self:oDCmMessage:currenttext+= MemoLine(self:cMessage, nLineLength, n) + CRLF
	NEXT
	return
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditLog 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditLog",_GetInst()},iCtlID)

oDCFixedText1 := FixedText{SELF,ResourceID{EDITLOG_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Source:",NULL_STRING,NULL_STRING}

oDCSource := SingleLineEdit{SELF,ResourceID{EDITLOG_SOURCE,_GetInst()}}
oDCSource:HyperLabel := HyperLabel{#Source,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{EDITLOG_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Date "+_chr(38)+" Time:",NULL_STRING,NULL_STRING}

oDClogtime := SingleLineEdit{SELF,ResourceID{EDITLOG_LOGTIME,_GetInst()}}
oDClogtime:HyperLabel := HyperLabel{#logtime,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmMessage := MultiLineEdit{SELF,ResourceID{EDITLOG_MMESSAGE,_GetInst()}}
oDCmMessage:OwnerAlignment := OA_PWIDTH_PHEIGHT
oDCmMessage:HyperLabel := HyperLabel{#mMessage,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{EDITLOG_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"User:",NULL_STRING,NULL_STRING}

oDCuserid := SingleLineEdit{SELF,ResourceID{EDITLOG_USERID,_GetInst()}}
oDCuserid:HyperLabel := HyperLabel{#userid,NULL_STRING,NULL_STRING,NULL_STRING}
oDCuserid:FieldSpec := transaction_USERID{}

SELF:Caption := "Log Details"
SELF:HyperLabel := HyperLabel{#EditLog,"Log Details",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS logtime() CLASS EditLog
RETURN SELF:FieldGet(#logtime)

ASSIGN logtime(uValue) CLASS EditLog
SELF:FieldPut(#logtime, uValue)
RETURN uValue

ACCESS mMessage() CLASS EditLog
RETURN SELF:FieldGet(#mMessage)

ASSIGN mMessage(uValue) CLASS EditLog
	SELF:FieldPut(#mMessage, uValue)
	RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class EditLog
	//Put your PostInit additions here 
	local oLog as SqlSelect 
	
	local cFields:= "`logid`,"+sIdentChar+"source"+sIdentChar+",cast("+sIdentChar+"logtime"+sIdentChar+" as datetime) as logtime,"+sIdentChar+"message"+sIdentChar+","+sIdentChar+"userid"+sIdentChar as string
	AdoDateTimeAsDate ( false )
	oLog:=SqlSelect{"select "+cFields+" from log where logid="+uExtra,oConn}
	if oLog:Reccount>0
		self:Source:=oLog:source
		self:logtime:=oLog:logtime:AsString()
		self:userid:=oLog:userid
		self:cMessage:=oLog:message
		self:FillText()
	endif
	AdoDateTimeAsDate ( true )
	return nil
method Resize(oResizeEvent) class EditLog
	super:Resize(oResizeEvent)
	//Put your changes here 
	self:FillText()
	
	return NIL

ACCESS Source() CLASS EditLog
RETURN SELF:FieldGet(#Source)

ASSIGN Source(uValue) CLASS EditLog
SELF:FieldPut(#Source, uValue)
RETURN uValue

ACCESS userid() CLASS EditLog
RETURN SELF:FieldGet(#userid)

ASSIGN userid(uValue) CLASS EditLog
SELF:FieldPut(#userid, uValue)
RETURN uValue

STATIC DEFINE EDITLOG_FIXEDTEXT1 := 100 
STATIC DEFINE EDITLOG_FIXEDTEXT2 := 102 
STATIC DEFINE EDITLOG_FIXEDTEXT3 := 105 
STATIC DEFINE EDITLOG_LOGTIME := 103 
STATIC DEFINE EDITLOG_MMESSAGE := 104 
STATIC DEFINE EDITLOG_SOURCE := 101 
STATIC DEFINE EDITLOG_USERID := 106 
STATIC DEFINE EDITSYSPARMS_AM := 122 
STATIC DEFINE EDITSYSPARMS_CANCELBUTTON := 141 
STATIC DEFINE EDITSYSPARMS_CAPITAL := 118 
STATIC DEFINE EDITSYSPARMS_CASH := 119 
STATIC DEFINE EDITSYSPARMS_CURRENCY := 125 
STATIC DEFINE EDITSYSPARMS_CURRNAME := 126 
STATIC DEFINE EDITSYSPARMS_DEBTORS := 142 
STATIC DEFINE EDITSYSPARMS_DONORS := 132 
STATIC DEFINE EDITSYSPARMS_ENTITY := 128 
STATIC DEFINE EDITSYSPARMS_FIRSTNAME := 135 
STATIC DEFINE EDITSYSPARMS_GROUPBOX1 := 136 
STATIC DEFINE EDITSYSPARMS_GROUPBOX2 := 137 
STATIC DEFINE EDITSYSPARMS_GROUPBOX3 := 138 
STATIC DEFINE EDITSYSPARMS_GROUPBOX4 := 139 
STATIC DEFINE EDITSYSPARMS_HB := 121 
STATIC DEFINE EDITSYSPARMS_HBLAND := 127 
STATIC DEFINE EDITSYSPARMS_INHDHAS := 123 
STATIC DEFINE EDITSYSPARMS_INHDKNTR := 124 
STATIC DEFINE EDITSYSPARMS_KRUISPSTN := 120 
STATIC DEFINE EDITSYSPARMS_MEMBERNBR := 134 
STATIC DEFINE EDITSYSPARMS_OKBUTTON := 140 
STATIC DEFINE EDITSYSPARMS_POSTAGE := 130 
STATIC DEFINE EDITSYSPARMS_PROJECTS := 133 
STATIC DEFINE EDITSYSPARMS_PURCHASE := 131 
STATIC DEFINE EDITSYSPARMS_SC_ENTITY := 111 
STATIC DEFINE EDITSYSPARMS_SC_SAM := 107 
STATIC DEFINE EDITSYSPARMS_SC_SDEB := 101 
STATIC DEFINE EDITSYSPARMS_SC_SDON := 102 
STATIC DEFINE EDITSYSPARMS_SC_SHB := 106 
STATIC DEFINE EDITSYSPARMS_SC_SINHDHAS := 108 
STATIC DEFINE EDITSYSPARMS_SC_SINHDKNTR := 109 
STATIC DEFINE EDITSYSPARMS_SC_SINK := 114 
STATIC DEFINE EDITSYSPARMS_SC_SKAP := 104 
STATIC DEFINE EDITSYSPARMS_SC_SKAS := 103 
STATIC DEFINE EDITSYSPARMS_SC_SKRUIS := 105 
STATIC DEFINE EDITSYSPARMS_SC_SLAND := 115 
STATIC DEFINE EDITSYSPARMS_SC_SMED := 110 
STATIC DEFINE EDITSYSPARMS_SC_SMUNT := 116 
STATIC DEFINE EDITSYSPARMS_SC_SMUNTNAAM := 117 
STATIC DEFINE EDITSYSPARMS_SC_SPOSTZ := 113 
STATIC DEFINE EDITSYSPARMS_SC_SPROJ := 100 
STATIC DEFINE EDITSYSPARMS_SC_SVOO := 112 
STATIC DEFINE EDITSYSPARMS_STOCKNBR := 129 
STATIC DEFINE EMAIL_IESMAILACC := 105 
STATIC DEFINE EMAIL_OWNMAILACC := 103 
STATIC DEFINE EMAIL_SC_IESMAILACC := 102 
STATIC DEFINE EMAIL_SC_OWNMAILACC := 100 
STATIC DEFINE EMAIL_SC_SMTPSERVER := 101 
STATIC DEFINE EMAIL_SMTPSERVER := 104 
CLASS LogReport INHERIT DataWindowExtra 

	PROTECT oDCDateTimeFrom AS DATESTANDARD
	PROTECT oDCDateTimeTo AS DATESTANDARD
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCCollectionBox AS COMBOBOX
	PROTECT oDCCollectionText AS FIXEDTEXT
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oCCFindButton AS PUSHBUTTON
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oDCSearchUni AS SINGLELINEEDIT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oSFSub_LogReport AS Sub_LogReport

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
	export oLog as SQLSelect
	export cWhere,cWhereExtra,cFields,cOrder as string  
RESOURCE LogReport DIALOGEX  4, 3, 386, 329
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"6-5-2011", LOGREPORT_DATETIMEFROM, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 43, 25, 57, 14
	CONTROL	"6-5-2011", LOGREPORT_DATETIMETO, "SysDateTimePick32", WS_TABSTOP|WS_CHILD, 119, 25, 57, 14
	CONTROL	"From", LOGREPORT_FIXEDTEXT1, "Static", WS_CHILD, 12, 26, 27, 12
	CONTROL	"till", LOGREPORT_FIXEDTEXT2, "Static", WS_CHILD, 104, 26, 19, 12
	CONTROL	"", LOGREPORT_COLLECTIONBOX, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 299, 25, 79, 41
	CONTROL	"Collection:", LOGREPORT_COLLECTIONTEXT, "Static", WS_CHILD, 256, 26, 39, 12
	CONTROL	"", LOGREPORT_SUB_LOGREPORT, "static", WS_CHILD|WS_BORDER, 4, 41, 376, 280
	CONTROL	"", LOGREPORT_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 344, 7, 36, 12
	CONTROL	"Find", LOGREPORT_FINDBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 160, 7, 40, 12
	CONTROL	"Found:", LOGREPORT_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 308, 8, 27, 12
	CONTROL	"", LOGREPORT_SEARCHUNI, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 44, 7, 116, 12
	CONTROL	"Search:", LOGREPORT_FIXEDTEXT4, "Static", WS_CHILD, 12, 7, 32, 12
END

ACCESS CollectionBox() CLASS LogReport
RETURN SELF:FieldGet(#CollectionBox)

ASSIGN CollectionBox(uValue) CLASS LogReport
SELF:FieldPut(#CollectionBox, uValue)
RETURN uValue

method DateTimeSelectionChanged(oDateTimeSelectionEvent) class LogReport
	local oControl as Control
	oControl := iif(oDateTimeSelectionEvent == null_object, null_object, oDateTimeSelectionEvent:Control)
	super:DateTimeSelectionChanged(oDateTimeSelectionEvent)
	//Put your changes here

	if oControl:NameSym=#DateTimeFrom .or. oControl:NameSym=#DateTimeTo	
		self:GetLog()
		self:GoTop()
		self:oSFSub_LogReport:Browser:refresh()
	endif
	return nil


	method EditButton() class LogReport
	if (self:Server:EOF.or.self:Server:BOF)
		(ErrorBox{,self:oLan:WGet("Select a log line first")}):Show()
		RETURN
	endif
	(EditLog{self:Owner,,,Str(ConI(self:oLog:logid),-1)}):Show()


method FilePrint class LogReport
	return
	
METHOD FindButton( ) CLASS LogReport 
	local aKeyw:={} as array
	local aFields:={"message","source","userid"} as array
	local i,j as int
	self:cWhereExtra:=""
	if !Empty(self:SearchUni)
		self:SearchUni:=Lower(AllTrim(self:SearchUni)) 
		aKeyw:=GetTokens(self:SearchUni)
		for i:=1 to Len(aKeyw)
			self:cWhereExtra+=" and ("
			for j:=1 to Len(AFields)
				self:cWhereExtra+=iif(j=1,""," or ")+AFields[j]+" like '%"+aKeyw[i,1]+"%'"
			next
			self:cWhereExtra+=") "
		next
	endif
	self:GetLog()
	self:GoTop()
	self:oSFSub_LogReport:Browser:refresh()
	RETURN nil
Method GetLog()  class LogReport
 
	self:oLog:SQLString:="select "+self:cFields+" from log "+;
		"where "+sIdentChar+"collection"+sIdentChar+"='"+self:CollectionBox+"' and "+sIdentChar+"logtime"+sIdentChar+" between '"+SQLdate(self:oDCDateTimeFrom:SelectedDate)+;
		"' and '"+SQLdate(self:oDCDateTimeTo:SelectedDate+1)+"' "+self:cWhereExtra+self:cOrder
	self:oLog:Execute()
	self:oDCFound:TextValue :=Str(self:oLog:Reccount,-1)
	return 

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS LogReport 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"LogReport",_GetInst()},iCtlID)

oDCDateTimeFrom := DateStandard{SELF,ResourceID{LOGREPORT_DATETIMEFROM,_GetInst()}}
oDCDateTimeFrom:HyperLabel := HyperLabel{#DateTimeFrom,NULL_STRING,NULL_STRING,NULL_STRING}

oDCDateTimeTo := DateStandard{SELF,ResourceID{LOGREPORT_DATETIMETO,_GetInst()}}
oDCDateTimeTo:HyperLabel := HyperLabel{#DateTimeTo,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{LOGREPORT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"From",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{LOGREPORT_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"till",NULL_STRING,NULL_STRING}

oDCCollectionBox := combobox{SELF,ResourceID{LOGREPORT_COLLECTIONBOX,_GetInst()}}
oDCCollectionBox:HyperLabel := HyperLabel{#CollectionBox,NULL_STRING,NULL_STRING,NULL_STRING}

oDCCollectionText := FixedText{SELF,ResourceID{LOGREPORT_COLLECTIONTEXT,_GetInst()}}
oDCCollectionText:HyperLabel := HyperLabel{#CollectionText,"Collection:",NULL_STRING,NULL_STRING}

oDCFound := FixedText{SELF,ResourceID{LOGREPORT_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oCCFindButton := PushButton{SELF,ResourceID{LOGREPORT_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Find",NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{LOGREPORT_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

oDCSearchUni := SingleLineEdit{SELF,ResourceID{LOGREPORT_SEARCHUNI,_GetInst()}}
oDCSearchUni:HyperLabel := HyperLabel{#SearchUni,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchUni:FocusSelect := FSEL_TRIM
oDCSearchUni:TooltipText := "Enter one or more (part of) key values "
oDCSearchUni:UseHLforToolTip := True

oDCFixedText4 := FixedText{SELF,ResourceID{LOGREPORT_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Search:",NULL_STRING,NULL_STRING}

SELF:Caption := "Show log"
SELF:HyperLabel := HyperLabel{#LogReport,"Show log",NULL_STRING,NULL_STRING}
SELF:Menu := WOBrowserMENUShort{}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFSub_LogReport := Sub_LogReport{SELF,LOGREPORT_SUB_LOGREPORT}
oSFSub_LogReport:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method InitParms() class LogReport
	//Put your PostInit additions here  
	local OldestYear as date
	if !Empty(GlBalYears)
		OldestYear:=GlBalYears[Len(GlBalYears),1] 
	else
		OldestYear:=MinDate
	endif
	self:oDCDateTimeFrom:DateRange:=DateRange{OldestYear,Today()}
	self:oDCDateTimeTo:DateRange:=DateRange{OldestYear,Today()+1}
 	self:oDCDateTimeFrom:SelectedDate:=MinDate

	self:oDCCollectionBox:FillUsing({{"standard report","log"},{"error report","logerrors"}})
	self:oDCCollectionBox:Value:="log"
	if !SuperUser
		self:oDCCollectionText:Hide()
		self:oDCCollectionBox:Hide()
	endif 
	return nil 
method ListBoxSelect(oControlEvent) class LogReport
	local oControl as Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:ListBoxSelect(oControlEvent)
	//Put your changes here 
	if oControl:NameSym=#CollectionBox 
		self:GetLog()
		self:GoTop()
		self:oSFSub_LogReport:Browser:refresh()
	endif
	return NIL

method PostInit(oWindow,iCtlID,oServer,uExtra) class LogReport
	//Put your PostInit additions here  
	self:SetTexts()
	return NIL
method PreInit(oWindow,iCtlID,oServer,uExtra) class LogReport
	//Put your PreInit additions here 
	self:cFields:= "`logid`,"+sIdentChar+"source"+sIdentChar+",cast("+sIdentChar+"logtime"+sIdentChar+" as datetime) as logtime,"+sIdentChar+"message"+sIdentChar+","+sIdentChar+"userid"+sIdentChar
	self:cOrder:="order by logtime desc,logid desc"
	return nil

ACCESS SearchUni() CLASS LogReport
RETURN SELF:FieldGet(#SearchUni)

ASSIGN SearchUni(uValue) CLASS LogReport
SELF:FieldPut(#SearchUni, uValue)
RETURN uValue

STATIC DEFINE LOGREPORT_COLLECTIONBOX := 104 
STATIC DEFINE LOGREPORT_COLLECTIONTEXT := 105 
STATIC DEFINE LOGREPORT_DATETIMEFROM := 100 
STATIC DEFINE LOGREPORT_DATETIMETO := 101 
STATIC DEFINE LOGREPORT_FINDBUTTON := 108 
STATIC DEFINE LOGREPORT_FIXEDTEXT1 := 102 
STATIC DEFINE LOGREPORT_FIXEDTEXT2 := 103 
STATIC DEFINE LOGREPORT_FIXEDTEXT4 := 111 
STATIC DEFINE LOGREPORT_FOUND := 107 
STATIC DEFINE LOGREPORT_FOUNDTEXT := 109 
STATIC DEFINE LOGREPORT_SEARCHUNI := 110 
STATIC DEFINE LOGREPORT_SUB_LOGREPORT := 106 
STATIC DEFINE SELBANKACC_LISTBOX1 := 100 
CLASS Sub_LogReport INHERIT DataWindowMine 

	PROTECT oDBSOURCE as DataColumn
	PROTECT oDBLOGTIME as DataColumn
	PROTECT oDBUSERID as DataColumn
	PROTECT oDBMESSAGE as DataColumn

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 

RESOURCE Sub_LogReport DIALOGEX  2, 2, 372, 279
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

method ButtonDoubleClick(oControlEvent) class Sub_LogReport
	local oControl as Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:ButtonDoubleClick(oControlEvent)
	//Put your changes here
	return NIL

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS Sub_LogReport 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"Sub_LogReport",_GetInst()},iCtlID)

SELF:Caption := ""
SELF:HyperLabel := HyperLabel{#Sub_LogReport,NULL_STRING,NULL_STRING,NULL_STRING}
SELF:OwnerAlignment := OA_PWIDTH_PHEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBSOURCE := DataColumn{AccDesc{}}
oDBSOURCE:Width := 17
oDBSOURCE:HyperLabel := HyperLabel{#source,"Source",NULL_STRING,NULL_STRING} 
oDBSOURCE:Caption := "Source"
self:Browser:AddColumn(oDBSOURCE)

oDBLOGTIME := DataColumn{AccDesc{}}
oDBLOGTIME:Width := 13
oDBLOGTIME:HyperLabel := HyperLabel{#logtime,"Date",NULL_STRING,NULL_STRING} 
oDBLOGTIME:Caption := "Date"
self:Browser:AddColumn(oDBLOGTIME)

oDBUSERID := DataColumn{7}
oDBUSERID:Width := 7
oDBUSERID:HyperLabel := HyperLabel{#userid,"user",NULL_STRING,NULL_STRING} 
oDBUSERID:Caption := "user"
self:Browser:AddColumn(oDBUSERID)

oDBMESSAGE := DataColumn{Description{}}
oDBMESSAGE:Width := 54
oDBMESSAGE:HyperLabel := HyperLabel{#message,"Message",NULL_STRING,NULL_STRING} 
oDBMESSAGE:Caption := "Message"
self:Browser:AddColumn(oDBMESSAGE)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS logtime() CLASS Sub_LogReport
RETURN SELF:FieldGet(#logtime)

ASSIGN logtime(uValue) CLASS Sub_LogReport
SELF:FieldPut(#logtime, uValue)
RETURN uValue

ACCESS message() CLASS Sub_LogReport
RETURN SELF:FieldGet(#message)

ASSIGN message(uValue) CLASS Sub_LogReport
SELF:FieldPut(#message, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class Sub_LogReport
	//Put your PostInit additions here
	self:SetTexts()
	self:Browser:SetStandardStyle(gbsReadOnly)
	self:oDBSOURCE:SetStandardStyle(gbsReadOnly) 
	self:oDBLOGTIME:SetStandardStyle(gbsReadOnly) 
	self:oDBMESSAGE:SetStandardStyle(gbsReadOnly) 

	return nil

method PreInit(oWindow,iCtlID,oServer,uExtra) class Sub_LogReport
	//Put your PreInit additions here
	local oLogRep:=oWindow as LogReport 
	local lSucc as logic
	oLogRep:InitParms()
// 	oLogRep:oLog:=SQLSelect{"select "+oLogRep:cFields+" from log "+oLogRep:cOrder,oConn} 
	oLogRep:oLog:=SqlSelect{"",oConn} 
	oLogRep:GetLog()
	lSucc:=oLogRep:use(oLogRep:oLog)
	return NIL

ACCESS source() CLASS Sub_LogReport
RETURN SELF:FieldGet(#source)

ASSIGN source(uValue) CLASS Sub_LogReport
SELF:FieldPut(#source, uValue)
RETURN uValue

ACCESS userid() CLASS Sub_LogReport
RETURN SELF:FieldGet(#userid)

ASSIGN userid(uValue) CLASS Sub_LogReport
SELF:FieldPut(#userid, uValue)
RETURN uValue

STATIC DEFINE SUB_LOGREPORT_LOGTIME := 101 
STATIC DEFINE SUB_LOGREPORT_MESSAGE := 102 
STATIC DEFINE SUB_LOGREPORT_SOURCE := 100 
STATIC DEFINE SUB_LOGREPORT_USERID := 103 
CLASS TAB_PARM1 INHERIT DataWindowMine 

	PROTECT oDCmCASH AS SINGLELINEEDIT
	PROTECT oDCmCAPITAL AS SINGLELINEEDIT
	PROTECT oDCmKRUISPSTN AS SINGLELINEEDIT
	PROTECT oDCCloseMonth AS COMBOBOX
	PROTECT oDCSC_SKAS AS FIXEDTEXT
	PROTECT oDCSC_SKAP AS FIXEDTEXT
	PROTECT oDCSC_SKRUIS AS FIXEDTEXT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oCCCashButton AS PUSHBUTTON
	PROTECT oCCCAPButton AS PUSHBUTTON
	PROTECT oCCCROSSButton AS PUSHBUTTON
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCmAdminType AS COMBOBOX
	PROTECT oDCSYSNAME AS SINGLELINEEDIT
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCmPersonOwn AS SINGLELINEEDIT
	PROTECT oCCPersonButtonOrg AS PUSHBUTTON
	PROTECT oDCmPersonContact AS SINGLELINEEDIT
	PROTECT oCCPersonButtonContact AS PUSHBUTTON
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCAcroFixed AS FIXEDTEXT
	PROTECT oDCEntity AS SINGLELINEEDIT
	PROTECT oDCCurrency AS COMBOBOX
	PROTECT oDCCURRNAME AS SINGLELINEEDIT
	PROTECT oDCHBLAND AS SINGLELINEEDIT
	PROTECT oDCSC_SLAND AS FIXEDTEXT
	PROTECT oDCSC_SMUNT AS FIXEDTEXT
	PROTECT oDCSC_SMUNTNAAM AS FIXEDTEXT
	PROTECT oDCFixedText11 AS FIXEDTEXT
	PROTECT oDCPosting AS CHECKBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  EXPORT cCASHName, cCAPITALName, cCROSSName as STRING
  EXPORT NbrCASH, NbrCAPITAL, NbrCROSS as STRING
  EXPORT cSoortCash, cSoortCAPITAL, cSoortCROSS as STRING
  EXPORT mCLNOrg,mCLNContact,cOrgName,cContactName as STRING 
  protect oSys as SQLSelect
RESOURCE TAB_PARM1 DIALOGEX  54, 48, 262, 240
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TAB_PARM1_MCASH, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 11, 103, 12, WS_EX_CLIENTEDGE
	CONTROL	"", TAB_PARM1_MCAPITAL, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 25, 103, 13, WS_EX_CLIENTEDGE
	CONTROL	"", TAB_PARM1_MKRUISPSTN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 44, 103, 12, WS_EX_CLIENTEDGE
	CONTROL	"", TAB_PARM1_CLOSEMONTH, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 112, 59, 120, 121
	CONTROL	"Account cash:", TAB_PARM1_SC_SKAS, "Static", WS_CHILD, 4, 11, 73, 12
	CONTROL	"Account Net Assets:", TAB_PARM1_SC_SKAP, "Static", WS_CHILD, 4, 25, 79, 13
	CONTROL	"Account internal bank transfers:", TAB_PARM1_SC_SKRUIS, "Static", WS_CHILD, 4, 44, 106, 12
	CONTROL	"End of Balance Year:", TAB_PARM1_FIXEDTEXT4, "Static", WS_CHILD, 4, 59, 94, 12
	CONTROL	"v", TAB_PARM1_CASHBUTTON, "Button", WS_CHILD, 212, 11, 15, 12
	CONTROL	"v", TAB_PARM1_CAPBUTTON, "Button", WS_CHILD, 212, 25, 15, 13
	CONTROL	"v", TAB_PARM1_CROSSBUTTON, "Button", WS_CHILD, 212, 44, 15, 12
	CONTROL	"Type of Administration:", TAB_PARM1_FIXEDTEXT5, "Static", WS_CHILD, 4, 77, 86, 12
	CONTROL	"", TAB_PARM1_MADMINTYPE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 112, 77, 120, 62
	CONTROL	"", TAB_PARM1_SYSNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 107, 134, 12, WS_EX_CLIENTEDGE
	CONTROL	"Own Organisation:", TAB_PARM1_FIXEDTEXT6, "Static", WS_CHILD, 4, 129, 90, 12
	CONTROL	"", TAB_PARM1_MPERSONOWN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 128, 108, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM1_PERSONBUTTONORG, "Button", WS_CHILD, 218, 128, 14, 12
	CONTROL	"", TAB_PARM1_MPERSONCONTACT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 150, 108, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM1_PERSONBUTTONCONTACT, "Button", WS_CHILD, 218, 150, 14, 12
	CONTROL	"Financial contact person:", TAB_PARM1_FIXEDTEXT7, "Static", WS_CHILD, 4, 151, 90, 12
	CONTROL	"Organisation Acronym:", TAB_PARM1_ACROFIXED, "Static", WS_CHILD, 4, 171, 92, 13
	CONTROL	"", TAB_PARM1_ENTITY, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 171, 53, 12, WS_EX_CLIENTEDGE
	CONTROL	"", TAB_PARM1_CURRENCY, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 112, 188, 134, 119
	CONTROL	"Currency name:", TAB_PARM1_CURRNAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 205, 134, 12
	CONTROL	"Country for I.E.:", TAB_PARM1_HBLAND, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 222, 134, 12
	CONTROL	"Country :", TAB_PARM1_SC_SLAND, "Static", WS_CHILD, 4, 222, 81, 12
	CONTROL	"System Currency:", TAB_PARM1_SC_SMUNT, "Static", WS_CHILD, 4, 189, 66, 12
	CONTROL	"Currency description:", TAB_PARM1_SC_SMUNTNAAM, "Static", WS_CHILD, 4, 206, 88, 12
	CONTROL	"System name:", TAB_PARM1_FIXEDTEXT11, "Static", WS_CHILD, 4, 107, 54, 12
	CONTROL	"Posting batch required?", TAB_PARM1_POSTING, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 112, 92, 87, 11
END

METHOD CAPButton( lUnique) CLASS TAB_PARM1
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrCAPITAL},{"PA"},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmCAPITAL:TEXTValue ),"Net Asset",lUnique,cfilter)
	RETURN nil
METHOD CashButton(lUnique ) CLASS TAB_PARM1
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrCASH},{"AK"},"N",0,false,BankAccs)
	AccountSelect(self:Owner,AllTrim(oDCmCASH:TEXTValue ),"Cash",lUnique,cfilter)
	RETURN nil
ACCESS CloseMonth() CLASS TAB_PARM1
RETURN SELF:FieldGet(#CloseMonth)

ASSIGN CloseMonth(uValue) CLASS TAB_PARM1
SELF:FieldPut(#CloseMonth, uValue)
RETURN uValue

ACCESS CountryOwn() CLASS TAB_PARM1
RETURN self:FIELDGET(#CountryOwn)

ASSIGN CountryOwn(uValue) CLASS TAB_PARM1
self:FIELDPUT(#CountryOwn, uValue)
RETURN uValue

METHOD CROSSButton(lUnique ) CLASS TAB_PARM1
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrCROSS},{"AK"},"N",0,false,BankAccs)
	AccountSelect(self:Owner,AllTrim(oDCmKRUISPSTN:TEXTValue ),"Internal bank transfer",lUnique,cfilter)
	RETURN nil
ACCESS Currency() CLASS TAB_PARM1
RETURN SELF:FieldGet(#Currency)

ASSIGN Currency(uValue) CLASS TAB_PARM1
SELF:FieldPut(#Currency, uValue)
RETURN uValue

ACCESS CURRNAME() CLASS TAB_PARM1
RETURN SELF:FieldGet(#CURRNAME)

ASSIGN CURRNAME(uValue) CLASS TAB_PARM1
SELF:FieldPut(#CURRNAME, uValue)
RETURN uValue

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS TAB_PARM1
	LOCAL oControl as Control
	LOCAL lGotFocus as LOGIC
	oControl := iif(oEditFocusChangeEvent == null_object, null_object, oEditFocusChangeEvent:Control)
	lGotFocus := iif(oEditFocusChangeEvent == null_object, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "MCASH".and.!AllTrim(oControl:VALUE)==AllTrim(cCASHName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrCASH:="  "
				self:cCASHName := ""
				self:oDCmCASH:TEXTValue := ""
            ELSE
				cCASHName:=AllTrim(oControl:VALUE)
				self:CASHButton(true)
			ENDIF
		ELSEIF oControl:Name == "MCAPITAL".and.!AllTrim(oControl:VALUE)==AllTrim(cCAPITALName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrCAPITAL:="  "
				self:cCAPITALName := ""
				self:oDCmCAPITAL:TEXTValue := ""
            ELSE
				cCAPITALName:=AllTrim(oControl:VALUE)
				self:CAPButton(true)
			ENDIF
		ELSEIF oControl:Name == "MKRUISPSTN".and.!AllTrim(oControl:VALUE)==AllTrim(cCROSSName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrCROSS:="  "
				self:cCROSSName := ""
				self:oDCmKRUISPSTN:TEXTValue := ""
            ELSE
				cCROSSName:=AllTrim(oControl:VALUE)
				self:CROSSButton(true)
			ENDIF
		ELSEIF oControl:Name == "MPERSONCONTACT".and.!AllTrim(oControl:VALUE)==AllTrim(self:cContactName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:mCLNContact:="  "
				self:cContactName := ""
				self:oDCmPersonContact:TEXTValue := ""
            ELSE
				cContactName:=AllTrim(oControl:VALUE)
				self:PersonButtonContact(true)
			ENDIF
		ELSEIF oControl:Name == "MPERSONOWN".and.!AllTrim(oControl:VALUE)==AllTrim(self:cOrgName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:mCLNOrg:="  "
				self:cOrgName := ""
				self:oDCmPersonOwn:TEXTValue := ""
            ELSE
				cOrgName:=AllTrim(oControl:VALUE)
				self:PersonButtonOrg(true)
			ENDIF
		ENDIF
	ENDIF
	RETURN nil
ACCESS Entity() CLASS TAB_PARM1
RETURN SELF:FieldGet(#Entity)

ASSIGN Entity(uValue) CLASS TAB_PARM1
SELF:FieldPut(#Entity, uValue)
RETURN uValue

METHOD FillMonth CLASS TAB_PARM1
	LOCAL aM:={} as ARRAY, i as int
	FOR i:=1 to 12
		AAdd(aM,{maand[i],i})
	NEXT
	RETURN aM
ACCESS HBLAND() CLASS TAB_PARM1
RETURN SELF:FieldGet(#HBLAND)

ASSIGN HBLAND(uValue) CLASS TAB_PARM1
SELF:FieldPut(#HBLAND, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TAB_PARM1 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TAB_PARM1",_GetInst()},iCtlID)

oDCmCASH := SingleLineEdit{SELF,ResourceID{TAB_PARM1_MCASH,_GetInst()}}
oDCmCASH:HyperLabel := HyperLabel{#mCASH,NULL_STRING,"Accountnumber for cash",NULL_STRING}
oDCmCASH:FieldSpec := MEMBERACCOUNT{}

oDCmCAPITAL := SingleLineEdit{SELF,ResourceID{TAB_PARM1_MCAPITAL,_GetInst()}}
oDCmCAPITAL:HyperLabel := HyperLabel{#mCAPITAL,NULL_STRING,"Accountnumber for capital",NULL_STRING}
oDCmCAPITAL:FieldSpec := MEMBERACCOUNT{}

oDCmKRUISPSTN := SingleLineEdit{SELF,ResourceID{TAB_PARM1_MKRUISPSTN,_GetInst()}}
oDCmKRUISPSTN:HyperLabel := HyperLabel{#mKRUISPSTN,NULL_STRING,"Accountnumber for clearing own Bank accounts",NULL_STRING}
oDCmKRUISPSTN:FieldSpec := MEMBERACCOUNT{}
oDCmKRUISPSTN:UseHLforToolTip := True

oDCCloseMonth := combobox{SELF,ResourceID{TAB_PARM1_CLOSEMONTH,_GetInst()}}
oDCCloseMonth:FillUsing(Self:FillMonth( ))
oDCCloseMonth:HyperLabel := HyperLabel{#CloseMonth,NULL_STRING,NULL_STRING,NULL_STRING}
oDCCloseMonth:FieldSpec := MonthW{}

oDCSC_SKAS := FixedText{SELF,ResourceID{TAB_PARM1_SC_SKAS,_GetInst()}}
oDCSC_SKAS:HyperLabel := HyperLabel{#SC_SKAS,"Account cash:",NULL_STRING,NULL_STRING}

oDCSC_SKAP := FixedText{SELF,ResourceID{TAB_PARM1_SC_SKAP,_GetInst()}}
oDCSC_SKAP:HyperLabel := HyperLabel{#SC_SKAP,"Account Net Assets:",NULL_STRING,NULL_STRING}

oDCSC_SKRUIS := FixedText{SELF,ResourceID{TAB_PARM1_SC_SKRUIS,_GetInst()}}
oDCSC_SKRUIS:HyperLabel := HyperLabel{#SC_SKRUIS,"Account internal bank transfers:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{TAB_PARM1_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"End of Balance Year:",NULL_STRING,NULL_STRING}

oCCCashButton := PushButton{SELF,ResourceID{TAB_PARM1_CASHBUTTON,_GetInst()}}
oCCCashButton:HyperLabel := HyperLabel{#CashButton,"v","Browse in accounts",NULL_STRING}
oCCCashButton:TooltipText := "Browse in accounts"

oCCCAPButton := PushButton{SELF,ResourceID{TAB_PARM1_CAPBUTTON,_GetInst()}}
oCCCAPButton:HyperLabel := HyperLabel{#CAPButton,"v","Browse in accounts",NULL_STRING}
oCCCAPButton:TooltipText := "Browse in accounts"

oCCCROSSButton := PushButton{SELF,ResourceID{TAB_PARM1_CROSSBUTTON,_GetInst()}}
oCCCROSSButton:HyperLabel := HyperLabel{#CROSSButton,"v","Browse in accounts",NULL_STRING}
oCCCROSSButton:TooltipText := "Browse in accounts"

oDCFixedText5 := FixedText{SELF,ResourceID{TAB_PARM1_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Type of Administration:",NULL_STRING,NULL_STRING}

oDCmAdminType := combobox{SELF,ResourceID{TAB_PARM1_MADMINTYPE,_GetInst()}}
oDCmAdminType:TooltipText := "Type of administration determining shown menu choices"
oDCmAdminType:HyperLabel := HyperLabel{#mAdminType,NULL_STRING,NULL_STRING,NULL_STRING}

oDCSYSNAME := SingleLineEdit{SELF,ResourceID{TAB_PARM1_SYSNAME,_GetInst()}}
oDCSYSNAME:HyperLabel := HyperLabel{#SYSNAME,NULL_STRING,NULL_STRING,"Name to be used for "}

oDCFixedText6 := FixedText{SELF,ResourceID{TAB_PARM1_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"Own Organisation:",NULL_STRING,NULL_STRING}

oDCmPersonOwn := SingleLineEdit{SELF,ResourceID{TAB_PARM1_MPERSONOWN,_GetInst()}}
oDCmPersonOwn:HyperLabel := HyperLabel{#mPersonOwn,NULL_STRING,"name own organisation","HELP_CLN"}
oDCmPersonOwn:FocusSelect := FSEL_HOME
oDCmPersonOwn:FieldSpec := Person_NA1{}
oDCmPersonOwn:UseHLforToolTip := True

oCCPersonButtonOrg := PushButton{SELF,ResourceID{TAB_PARM1_PERSONBUTTONORG,_GetInst()}}
oCCPersonButtonOrg:HyperLabel := HyperLabel{#PersonButtonOrg,"v","Browse in persons",NULL_STRING}
oCCPersonButtonOrg:TooltipText := "Browse in Persons"

oDCmPersonContact := SingleLineEdit{SELF,ResourceID{TAB_PARM1_MPERSONCONTACT,_GetInst()}}
oDCmPersonContact:HyperLabel := HyperLabel{#mPersonContact,NULL_STRING,"name financial contact person","HELP_CLN"}
oDCmPersonContact:FocusSelect := FSEL_HOME
oDCmPersonContact:FieldSpec := Person_NA1{}
oDCmPersonContact:UseHLforToolTip := True

oCCPersonButtonContact := PushButton{SELF,ResourceID{TAB_PARM1_PERSONBUTTONCONTACT,_GetInst()}}
oCCPersonButtonContact:HyperLabel := HyperLabel{#PersonButtonContact,"v","Browse in persons",NULL_STRING}
oCCPersonButtonContact:TooltipText := "Browse in Persons"

oDCFixedText7 := FixedText{SELF,ResourceID{TAB_PARM1_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Financial contact person:",NULL_STRING,NULL_STRING}

oDCAcroFixed := FixedText{SELF,ResourceID{TAB_PARM1_ACROFIXED,_GetInst()}}
oDCAcroFixed:HyperLabel := HyperLabel{#AcroFixed,"Organisation Acronym:",NULL_STRING,NULL_STRING}

oDCEntity := SingleLineEdit{SELF,ResourceID{TAB_PARM1_ENTITY,_GetInst()}}
oDCEntity:Picture := "@!XXX"
oDCEntity:HyperLabel := HyperLabel{#Entity,NULL_STRING,"three character acronym used for filenames",NULL_STRING}
oDCEntity:UseHLforToolTip := True

oDCCurrency := combobox{SELF,ResourceID{TAB_PARM1_CURRENCY,_GetInst()}}
oDCCurrency:HyperLabel := HyperLabel{#Currency,NULL_STRING,"Default currency for this organisation","Currency_Smunt"}
oDCCurrency:FillUsing(SQLSelect{"select united_ara,aed from currencylist",oConn}:getLookupTable(300,#UNITED_ARA,#AED))

oDCCURRNAME := SingleLineEdit{SELF,ResourceID{TAB_PARM1_CURRNAME,_GetInst()}}
oDCCURRNAME:FieldSpec := Sysparms_SMUNTNAAM{}
oDCCURRNAME:HyperLabel := HyperLabel{#CURRNAME,"Currency name:","Currency name","Sysparms_SMUNTNAAM"}
oDCCURRNAME:AutoFocusChange := True

oDCHBLAND := SingleLineEdit{SELF,ResourceID{TAB_PARM1_HBLAND,_GetInst()}}
oDCHBLAND:FieldSpec := Sysparms_SLAND{}
oDCHBLAND:HyperLabel := HyperLabel{#HBLAND,"Country for I.E.:","Country for PMC","Sysparms_SLAND"}
oDCHBLAND:UseHLforToolTip := True

oDCSC_SLAND := FixedText{SELF,ResourceID{TAB_PARM1_SC_SLAND,_GetInst()}}
oDCSC_SLAND:HyperLabel := HyperLabel{#SC_SLAND,"Country :",NULL_STRING,NULL_STRING}

oDCSC_SMUNT := FixedText{SELF,ResourceID{TAB_PARM1_SC_SMUNT,_GetInst()}}
oDCSC_SMUNT:HyperLabel := HyperLabel{#SC_SMUNT,"System Currency:",NULL_STRING,NULL_STRING}

oDCSC_SMUNTNAAM := FixedText{SELF,ResourceID{TAB_PARM1_SC_SMUNTNAAM,_GetInst()}}
oDCSC_SMUNTNAAM:HyperLabel := HyperLabel{#SC_SMUNTNAAM,"Currency description:",NULL_STRING,NULL_STRING}

oDCFixedText11 := FixedText{SELF,ResourceID{TAB_PARM1_FIXEDTEXT11,_GetInst()}}
oDCFixedText11:HyperLabel := HyperLabel{#FixedText11,"System name:",NULL_STRING,NULL_STRING}

oDCPosting := CheckBox{SELF,ResourceID{TAB_PARM1_POSTING,_GetInst()}}
oDCPosting:HyperLabel := HyperLabel{#Posting,"Posting batch required?",NULL_STRING,NULL_STRING}

SELF:Caption := ""
SELF:HyperLabel := HyperLabel{#TAB_PARM1,NULL_STRING,NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListBoxSelect(oControlEvent) CLASS TAB_PARM1
	LOCAL oControl as Control
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControl:NameSym==#mAdminType
		self:oParent:checktabs(AllTrim(oControl:VALUE))
		IF oControl:Value="WO"
			self:oDCEntity:Disable()
		ELSE
			self:oDCEntity:Enable()
		ENDIF
	ENDIF
	
	RETURN nil

ACCESS mAdminType() CLASS TAB_PARM1
RETURN SELF:FieldGet(#mAdminType)

ASSIGN mAdminType(uValue) CLASS TAB_PARM1
SELF:FieldPut(#mAdminType, uValue)
RETURN uValue

ACCESS mCAPITAL() CLASS TAB_PARM1
RETURN SELF:FieldGet(#mCAPITAL)

ASSIGN mCAPITAL(uValue) CLASS TAB_PARM1
SELF:FieldPut(#mCAPITAL, uValue)
RETURN uValue

ACCESS mCASH() CLASS TAB_PARM1
RETURN SELF:FieldGet(#mCASH)

ASSIGN mCASH(uValue) CLASS TAB_PARM1
SELF:FieldPut(#mCASH, uValue)
RETURN uValue

ACCESS mKRUISPSTN() CLASS TAB_PARM1
RETURN SELF:FieldGet(#mKRUISPSTN)

ASSIGN mKRUISPSTN(uValue) CLASS TAB_PARM1
SELF:FieldPut(#mKRUISPSTN, uValue)
RETURN uValue

ACCESS mPersonContact() CLASS TAB_PARM1
RETURN SELF:FieldGet(#mPersonContact)

ASSIGN mPersonContact(uValue) CLASS TAB_PARM1
SELF:FieldPut(#mPersonContact, uValue)
RETURN uValue

ACCESS mPersonOwn() CLASS TAB_PARM1
RETURN SELF:FieldGet(#mPersonOwn)

ASSIGN mPersonOwn(uValue) CLASS TAB_PARM1
SELF:FieldPut(#mPersonOwn, uValue)
RETURN uValue

METHOD PersonButtonContact(lUnique) CLASS TAB_PARM1
	LOCAL cValue := AllTrim(self:oDCmPersonContact:TEXTValue ) as STRING
	Default(@lUnique,FALSE)
	PersonSelect(self:Owner,cValue,lUnique,,"Contact Person Financial")
METHOD PersonButtonOrg( lUnique) CLASS TAB_PARM1
	LOCAL cValue := AllTrim(self:oDCmPersonOwn:TEXTValue ) as STRING
	Default(@lUnique,FALSE)
	PersonSelect(self:Owner,cValue,lUnique,,"Own Organisation")
ACCESS Posting() CLASS TAB_PARM1
RETURN SELF:FieldGet(#Posting)

ASSIGN Posting(uValue) CLASS TAB_PARM1
SELF:FieldPut(#Posting, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TAB_PARM1
	//Put your PostInit additions here
	LOCAL oAcc,oSel as SQLSelect
	self:SetTexts()
	oAcc:=SqlSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:cash,-1),oConn}
	IF !Empty(self:oSys:cash)
		oAcc:=SqlSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:cash,-1),oConn}
		IF oAcc:RecCount>0
			self:NbrCASH :=  Str( oAcc:accid,-1)
			self:oDCmCASH:TEXTValue := AllTrim(oAcc:Description)
			self:cCASHName := AllTrim(oAcc:Description)
			self:cSoortCash:=oAcc:TYPE
		ENDIF		
	ENDIF
	IF !Empty(self:oSys:capital)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:capital,-1),oConn}
		IF oAcc:RecCount>0
			self:NbrCAPITAL :=  Str(oAcc:accid,-1)
			self:oDCmCAPITAL:TEXTValue := AllTrim(oAcc:Description)
			self:cCAPITALName := AllTrim(oAcc:Description)
			self:cSoortCAPITAL:=oAcc:TYPE
		ENDIF		
	ENDIF
	IF !Empty(self:oSys:crossaccnt)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:crossaccnt,-1),oConn}
		IF oAcc:RecCount>0
			self:NbrCROSS :=  Str(oAcc:accid,-1)
			self:oDCmKRUISPSTN:TEXTValue := AllTrim(oAcc:Description)
			self:cCROSSName := AllTrim(oAcc:Description)
			self:cSoortCROSS:=oAcc:TYPE
		ENDIF		
	ENDIF
	IF !Empty(SHB).and.!Empty(sam)
		self:oDCmAdminType:Disable()
	ELSE
		oSel:=SQLSelect{"select mbrid from member limit 2", oConn}
		IF oSel:RecCount=0 // empty database
			self:oDCmAdminType:FillUsing({{"Wycliffe Office","WO"},{"Home Front of one Member","HO"},;
				{"General Gifts Administration","GI"},{"General Accounting","GE"},{"Wycliffe Area","WA"}})
		ELSE
			IF oSel:RecCount=1  // 1 member?
				self:oDCmAdminType:FillUsing({{"Wycliffe Office","WO"},{"Home Front of one Member","HO"},{"General Gifts Administration","GI"}})
			ELSE
				self:oDCmAdminType:FillUsing({{"Wycliffe Office","WO"},{"General Gifts Administration","GI"}})
			ENDIF
		ENDIF
	ENDIF	
	self:oDCmAdminType:Value:=self:oSys:ADMINTYPE
	IF self:oSys:ADMINTYPE="WO"
		self:oDCEntity:Disable()
	ENDIF
	self:mCLNContact:=Str(self:oSys:idcontact,-1)
	self:mCLNOrg:=Str(self:oSys:idorg,-1)
	IF !Empty(self:oSys:idcontact)
		self:cContactName:=GetFullName(mCLNContact)
		self:oDCmPersonContact:TEXTValue:=cContactName
	ENDIF
	IF !Empty(self:oSys:idorg)
		self:cOrgName:=GetFullName(mCLNOrg)
		self:oDCmPersonOwn:TEXTValue:=cOrgName
	ENDIF
	IF !Empty(self:oSys:Currency) .and. SqlSelect{"select transid from transaction limit 2",oConn}:RecCount>0
		self:oDCCurrency:Disable()
	endif
	self:closemonth:=ConI(self:oSys:closemonth) 
	self:Entity:=self:oSys:Entity
	self:Currency:=self:oSys:Currency 
	self:HBLAND :=self:oSys:CountryOwn 
	self:CURRNAME:=self:oSys:CURRNAME 
	self:SYSNAME:=self:oSys:SYSNAME 
	self:posting:=ConL(self:oSys:Posting) 
	
	RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class TAB_PARM1
	//Put your PreInit additions here
// 	oWindow:Use(oWindow:oSys) 
	self:oSys:=oWindow:oSys
	return nil

ACCESS SYSNAME() CLASS TAB_PARM1
RETURN SELF:FieldGet(#SYSNAME)

ASSIGN SYSNAME(uValue) CLASS TAB_PARM1
SELF:FieldPut(#SYSNAME, uValue)
RETURN uValue

STATIC DEFINE TAB_PARM1_ACROFIXED := 120 
STATIC DEFINE TAB_PARM1_CAPBUTTON := 109 
STATIC DEFINE TAB_PARM1_CASHBUTTON := 108 
STATIC DEFINE TAB_PARM1_CLOSEMONTH := 103 
STATIC DEFINE TAB_PARM1_CROSSBUTTON := 110 
STATIC DEFINE TAB_PARM1_CURRENCY := 122 
STATIC DEFINE TAB_PARM1_CURRNAME := 123 
STATIC DEFINE TAB_PARM1_ENTITY := 121 
STATIC DEFINE TAB_PARM1_FIXEDTEXT11 := 128 
STATIC DEFINE TAB_PARM1_FIXEDTEXT4 := 107 
STATIC DEFINE TAB_PARM1_FIXEDTEXT5 := 111 
STATIC DEFINE TAB_PARM1_FIXEDTEXT6 := 114 
STATIC DEFINE TAB_PARM1_FIXEDTEXT7 := 119 
STATIC DEFINE TAB_PARM1_HBLAND := 124 
STATIC DEFINE TAB_PARM1_MADMINTYPE := 112 
STATIC DEFINE TAB_PARM1_MCAPITAL := 101 
STATIC DEFINE TAB_PARM1_MCASH := 100 
STATIC DEFINE TAB_PARM1_MKRUISPSTN := 102 
STATIC DEFINE TAB_PARM1_MPERSONCONTACT := 117 
STATIC DEFINE TAB_PARM1_MPERSONOWN := 115 
STATIC DEFINE TAB_PARM1_PERSONBUTTONCONTACT := 118 
STATIC DEFINE TAB_PARM1_PERSONBUTTONORG := 116 
STATIC DEFINE TAB_PARM1_POSTING := 129 
STATIC DEFINE TAB_PARM1_SC_SKAP := 105 
STATIC DEFINE TAB_PARM1_SC_SKAS := 104 
STATIC DEFINE TAB_PARM1_SC_SKRUIS := 106 
STATIC DEFINE TAB_PARM1_SC_SLAND := 125 
STATIC DEFINE TAB_PARM1_SC_SMUNT := 126 
STATIC DEFINE TAB_PARM1_SC_SMUNTNAAM := 127 
STATIC DEFINE TAB_PARM1_SYSNAME := 113 
RESOURCE Tab_Parm2 DIALOGEX  44, 36, 261, 264
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"PP Codes", TAB_PARM2_ENTITY, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 112, 3, 134, 217
	CONTROL	"", TAB_PARM2_MHB, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 18, 121, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM2_HBBUTTON, "Button", WS_CHILD, 232, 18, 15, 12
	CONTROL	"", TAB_PARM2_MAM, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 33, 121, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM2_AMBUTTON, "Button", WS_CHILD, 232, 33, 15, 12
	CONTROL	"", TAB_PARM2_MAMPROJ, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 48, 121, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM2_AMPROJBUTTON, "Button", WS_CHILD, 232, 48, 15, 12
	CONTROL	"", TAB_PARM2_MGIFTINCAC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 96, 121, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM2_INCBUTTON, "Button", WS_CHILD, 232, 96, 15, 12
	CONTROL	"", TAB_PARM2_MGIFTEXPAC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 110, 121, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM2_EXPBUTTON, "Button", WS_CHILD, 232, 110, 15, 13
	CONTROL	"", TAB_PARM2_MHOMEINCAC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 112, 129, 121, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM2_INCBUTTONHOME, "Button", WS_CHILD|NOT WS_VISIBLE, 232, 129, 16, 12
	CONTROL	"", TAB_PARM2_MHOMEEXPAC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 112, 144, 121, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM2_EXPBUTTONHOME, "Button", WS_CHILD|NOT WS_VISIBLE, 232, 144, 15, 12
	CONTROL	"Assessment home assigned:", TAB_PARM2_ASSMNTFIELD, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 166, 20, 12
	CONTROL	"Assessment international", TAB_PARM2_ASSMNTINT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 158, 166, 20, 12
	CONTROL	"Assessment office:", TAB_PARM2_WITHLDOFFL, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 116, 193, 21, 12
	CONTROL	"Assessment office:", TAB_PARM2_ASSMNTOFFC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 152, 193, 22, 12
	CONTROL	"Assessment office:", TAB_PARM2_WITHLDOFFM, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 190, 193, 22, 12
	CONTROL	"Assessment office:", TAB_PARM2_WITHLDOFFH, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 226, 193, 22, 12
	CONTROL	"Sending to PMC via Insite upload", TAB_PARM2_PMCUPLD, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 116, 214, 127, 11
	CONTROL	"", TAB_PARM2_MPERSONPMCMAN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 228, 125, 13, WS_EX_CLIENTEDGE
	CONTROL	"Email account of IES:", TAB_PARM2_IESMAILACC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 243, 136, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM2_PERSONBUTTONCONTACT, "Button", WS_CHILD, 236, 228, 13, 12
	CONTROL	"Account PMC clearance:", TAB_PARM2_SC_SHB, "Static", WS_CHILD, 4, 18, 90, 12
	CONTROL	"Account Assessments standard:", TAB_PARM2_SC_SAM, "Static", WS_CHILD, 4, 33, 105, 12
	CONTROL	"Assessment:", TAB_PARM2_SC_SINHDHAS, "Static", WS_CHILD, 4, 166, 44, 12
	CONTROL	"office:", TAB_PARM2_SC_SINHDKNTR, "Static", WS_CHILD, 92, 193, 20, 13
	CONTROL	"PMC Participant code:", TAB_PARM2_SC_ENTITY, "Static", WS_CHILD, 4, 3, 87, 13
	CONTROL	"%", TAB_PARM2_FIXEDTEXT8, "Static", WS_CHILD, 136, 166, 8, 12
	CONTROL	"%", TAB_PARM2_FIXEDTEXT9, "Static", WS_CHILD, 138, 193, 8, 12
	CONTROL	"Email address of PMC:", TAB_PARM2_SC_IESMAILACC, "Static", WS_CHILD, 4, 245, 83, 12
	CONTROL	"field:", TAB_PARM2_SC_SINHDHAS1, "Static", WS_CHILD, 92, 166, 18, 12
	CONTROL	"int:", TAB_PARM2_SC_SINHDKNTR1, "Static", WS_CHILD, 145, 166, 13, 12
	CONTROL	"%", TAB_PARM2_FIXEDTEXT10, "Static", WS_CHILD, 179, 166, 9, 12
	CONTROL	"low", TAB_PARM2_FIXEDTEXT14, "Static", WS_CHILD, 114, 183, 19, 10
	CONTROL	"standard", TAB_PARM2_FIXEDTEXT15, "Static", WS_CHILD, 151, 182, 29, 10
	CONTROL	"%", TAB_PARM2_FIXEDTEXT11, "Static", WS_CHILD, 174, 193, 9, 12
	CONTROL	"%", TAB_PARM2_FIXEDTEXT12, "Static", WS_CHILD, 212, 193, 9, 12
	CONTROL	"middle", TAB_PARM2_FIXEDTEXT16, "Static", WS_CHILD, 189, 182, 29, 10
	CONTROL	"high", TAB_PARM2_FIXEDTEXT17, "Static", WS_CHILD, 226, 182, 30, 10
	CONTROL	"%", TAB_PARM2_FIXEDTEXT13, "Static", WS_CHILD, 249, 193, 9, 12
	CONTROL	"Account Project Assessments", TAB_PARM2_SC_SAM1, "Static", WS_CHILD, 4, 48, 99, 12
	CONTROL	"Accounts to record assessable gifts to measure activity", TAB_PARM2_GROUPBOXINCOME, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 0, 84, 253, 79
	CONTROL	"Account Gifts Expense:", TAB_PARM2_SC_SAM2, "Static", WS_CHILD, 4, 110, 99, 13
	CONTROL	"Account Gifts Income:", TAB_PARM2_SC_SAM3, "Static", WS_CHILD, 4, 96, 99, 12
	CONTROL	"Account Home Gifts Expense:", TAB_PARM2_SC_SAM4, "Static", WS_CHILD|NOT WS_VISIBLE, 4, 144, 99, 12
	CONTROL	"Account Home Gifts Income:", TAB_PARM2_SC_SAM5, "Static", WS_CHILD|NOT WS_VISIBLE, 4, 129, 99, 13
	CONTROL	"PMC Manager:", TAB_PARM2_FIXEDTEXT24, "Static", WS_CHILD, 4, 228, 103, 13
	CONTROL	"", TAB_PARM2_MASSFLDAC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 112, 62, 121, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM2_ASSFLDACBUTTON, "Button", WS_CHILD|NOT WS_VISIBLE, 232, 62, 16, 13
	CONTROL	"Account Assessment Field+Int", TAB_PARM2_SC_SAMFLD, "Static", WS_CHILD|NOT WS_VISIBLE, 4, 62, 99, 13
END

CLASS Tab_Parm2 INHERIT DataWindowMine 

	PROTECT oDCEntity AS COMBOBOX
	PROTECT oDCmHB AS SINGLELINEEDIT
	PROTECT oCCHBButton AS PUSHBUTTON
	PROTECT oDCmAM AS SINGLELINEEDIT
	PROTECT oCCAMButton AS PUSHBUTTON
	PROTECT oDCmAMProj AS SINGLELINEEDIT
	PROTECT oCCAMProjButton AS PUSHBUTTON
	PROTECT oDCmGiftIncAc AS SINGLELINEEDIT
	PROTECT oCCIncButton AS PUSHBUTTON
	PROTECT oDCmGiftExpAc AS SINGLELINEEDIT
	PROTECT oCCExpButton AS PUSHBUTTON
	PROTECT oDCmHomeIncAc AS SINGLELINEEDIT
	PROTECT oCCIncButtonHome AS PUSHBUTTON
	PROTECT oDCmHomeExpAc AS SINGLELINEEDIT
	PROTECT oCCExpButtonHome AS PUSHBUTTON
	PROTECT oDCassmntfield AS SINGLELINEEDIT
	PROTECT oDCassmntint AS SINGLELINEEDIT
	PROTECT oDCwithldoffl AS SINGLELINEEDIT
	PROTECT oDCassmntOffc AS SINGLELINEEDIT
	PROTECT oDCwithldoffm AS SINGLELINEEDIT
	PROTECT oDCwithldoffh AS SINGLELINEEDIT
	PROTECT oDCpmcupld AS CHECKBOX
	PROTECT oDCmPersonPMCMan AS SINGLELINEEDIT
	PROTECT oDCIESMAILACC AS SINGLELINEEDIT
	PROTECT oCCPersonButtonContact AS PUSHBUTTON
	PROTECT oDCSC_SHB AS FIXEDTEXT
	PROTECT oDCSC_SAM AS FIXEDTEXT
	PROTECT oDCSC_SINHDHAS AS FIXEDTEXT
	PROTECT oDCSC_SINHDKNTR AS FIXEDTEXT
	PROTECT oDCSC_ENTITY AS FIXEDTEXT
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oDCFixedText9 AS FIXEDTEXT
	PROTECT oDCSC_IESMAILACC AS FIXEDTEXT
	PROTECT oDCSC_SINHDHAS1 AS FIXEDTEXT
	PROTECT oDCSC_SINHDKNTR1 AS FIXEDTEXT
	PROTECT oDCFixedText10 AS FIXEDTEXT
	PROTECT oDCFixedText14 AS FIXEDTEXT
	PROTECT oDCFixedText15 AS FIXEDTEXT
	PROTECT oDCFixedText11 AS FIXEDTEXT
	PROTECT oDCFixedText12 AS FIXEDTEXT
	PROTECT oDCFixedText16 AS FIXEDTEXT
	PROTECT oDCFixedText17 AS FIXEDTEXT
	PROTECT oDCFixedText13 AS FIXEDTEXT
	PROTECT oDCSC_SAM1 AS FIXEDTEXT
	PROTECT oDCGroupBoxIncome AS GROUPBOX
	PROTECT oDCSC_SAM2 AS FIXEDTEXT
	PROTECT oDCSC_SAM3 AS FIXEDTEXT
	PROTECT oDCSC_SAM4 AS FIXEDTEXT
	PROTECT oDCSC_SAM5 AS FIXEDTEXT
	PROTECT oDCFixedText24 AS FIXEDTEXT
	PROTECT oDCmAssFldAc AS SINGLELINEEDIT
	PROTECT oCCAssFldAcButton AS PUSHBUTTON
	PROTECT oDCSC_SAMFld AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
//   	instance mHB 
// 	instance mAM 
// 	instance assmntfield 
// 	instance withldoffl 
// 	instance IESMAILACC 
// 	instance assmntint 
// 	instance Entity 
// 	instance assmntOffc 
// 	instance withldoffM 
// 	instance withldoffH 
// 	instance mAMProj 
// 	instance mGiftExpAc 
// 	instance mGiftIncAc 
// 	instance mHomeExpAc 
// 	instance mHomeIncAc 

    EXPORT cHBName, cAMName, cAMNameProj,cAssFldAccName,cGIFTINCACName,cGIFTEXPACName,cHomeINCACName,cHOMEEXPACName as STRING
  	EXPORT NbrHB, NbrAM, NbrAMProj,NbrAssFldAc, NbrInc, NbrExp, NbrIncHome, NBREXPHOME as STRING
  	EXPORT cSoortHB, cSoortAM, cSoortAMProj,cSoortAssFldAc,cSoortGIFTINCAC,cSoortGIFTEXPAC,cSoortHOMEINCAC,cSoortHomeEXPAC as STRING
   Export mCLNPMCMan,cPMCManName as string 
   protect oSys as SQLSelect
METHOD AMButton( lUnique) CLASS Tab_Parm2
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrAM},{"BA"},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmAM:TEXTValue ),"Assessments",lUnique,cfilter)
	RETURN nil
	
METHOD AMProjButton(lUnique ) CLASS Tab_Parm2
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrAMProj,NbrAM},{income},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmAMProj:TEXTValue ),"Project Assessments",lUnique,cfilter)
	RETURN nil
METHOD AssFldAcButton(lUnique ) CLASS Tab_Parm2 
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({self:NbrAssFldAc},{expense},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmAssFldAc:TEXTValue ),"Assessment Field and Int",lUnique,cfilter)
	RETURN nil
ACCESS assmntfield() CLASS Tab_Parm2
RETURN SELF:FieldGet(#assmntfield)

ASSIGN assmntfield(uValue) CLASS Tab_Parm2
SELF:FieldPut(#assmntfield, uValue)
RETURN uValue

ACCESS assmntint() CLASS Tab_Parm2
RETURN SELF:FieldGet(#assmntint)

ASSIGN assmntint(uValue) CLASS Tab_Parm2
SELF:FieldPut(#assmntint, uValue)
RETURN uValue

ACCESS assmntOffc() CLASS Tab_Parm2
RETURN SELF:FieldGet(#assmntOffc)

ASSIGN assmntOffc(uValue) CLASS Tab_Parm2
SELF:FieldPut(#assmntOffc, uValue)
RETURN uValue

method ButtonClick(oControlEvent) class Tab_Parm2
	local oControl as Control
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	super:ButtonClick(oControlEvent)
	//Put your changes here 
	IF oControl:Name=="PMCUPLD" 
		IF self:oDCpmcupld:Checked
			self:oDCSC_IESMAILACC:Hide()
			self:oDCIESMAILACC:Hide()
		else
			self:oDCSC_IESMAILACC:Show()
			self:oDCIESMAILACC:Show()
		endif
	endif
	return nil

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS Tab_Parm2
	LOCAL oControl as Control
	LOCAL lGotFocus as LOGIC
	oControl := iif(oEditFocusChangeEvent == null_object, null_object, oEditFocusChangeEvent:Control)
	lGotFocus := iif(oEditFocusChangeEvent == null_object, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "MHB".and.!AllTrim(oControl:VALUE)==AllTrim(cHBName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrHB := "  "
				self:cHBName := ""
				self:oDCmHB:TEXTValue := ""
			ELSE
				cHBName:=AllTrim(oControl:VALUE)
				self:HBButton(true)
			ENDIF
		ELSEIF oControl:Name == "MAM".and.!AllTrim(oControl:VALUE)==AllTrim(cAMName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrAM := "  "
				self:cAMName := ""
				self:oDCmAM:TEXTValue := ""
			ELSE
				cAMName:=AllTrim(oControl:VALUE)
				self:AMButton(true)
			ENDIF
		ELSEIF oControl:Name == "MAMPROJ".and.!AllTrim(oControl:VALUE)==AllTrim(cAMNameProj)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrAMProj := "  "
				self:cAMNameProj := ""
				self:oDCmAMProj:TEXTValue := ""
			ELSE
				cAMNameProj:=AllTrim(oControl:VALUE)
				self:AMProjButton(true)
			ENDIF
		ELSEIF oControl:Name == "MASSFLDAC".and.!AllTrim(oControl:VALUE)==AllTrim(self:cAssFldAccName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrAssFldAc := "  "
				self:cAssFldAccName := ""
				self:oDCmAssFldAc:TEXTValue := ""
			ELSE
				self:cAssFldAccName:=AllTrim(oControl:VALUE)
				self:AssFldAcButton(true)
			ENDIF
		ELSEIF oControl:Name == "MGIFTINCAC".and.!AllTrim(oControl:VALUE)==AllTrim(cGIFTINCACName)
			IF Empty(alltrim(oControl:Value)) && leeg gemaakt?
				self:NbrInc := ''
				self:cGIFTINCACName := ""
				self:oDCmGIFTINCAC:TEXTValue := ""
				self:ShowAssAcc()
			ELSE
				cGIFTINCACName:=AllTrim(oControl:VALUE)
				self:IncButton(true)
			ENDIF
		ELSEIF oControl:Name == "MGIFTEXPAC".and.!AllTrim(oControl:VALUE)==AllTrim(cGIFTEXPACName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrExp := "  "
				self:cGIFTEXPACName := ""
				self:oDCmGIFTEXPAC:TEXTValue := ""
			ELSE
				cGIFTEXPACName:=AllTrim(oControl:VALUE)
				self:ExpButton(true)
			ENDIF
		ELSEIF oControl:Name == "MHOMEINCAC".and.!AllTrim(oControl:VALUE)==AllTrim(cHOMEINCACName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrIncHome := "  "
				self:cHOMEINCACName := ""
				self:oDCmHOMEINCAC:TEXTValue := ""
			ELSE
				cHOMEINCACName:=AllTrim(oControl:VALUE)
				self:IncButtonHome(true)
			ENDIF
		ELSEIF oControl:Name == "MPERSONPMCMAN".and.!AllTrim(oControl:VALUE)==AllTrim(self:cPMCManName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:mCLNPMCMan:="  "
				self:cPMCManName := ""
				self:oDCmPersonPMCMan :TEXTValue := ""
			ELSE
				cPMCManName:=AllTrim(oControl:VALUE)
				self:PersonButtonContact(true)
			ENDIF

		ELSEIF oControl:Name == "MHOMEEXPAC".and.!AllTrim(oControl:VALUE)==AllTrim(cHOMEEXPACName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NBREXPHOME := "  "
				self:cHOMEEXPACName := ""
				self:oDCmHOMEEXPAC:TEXTValue := ""
			ELSE
				cHOMEEXPACName:=AllTrim(oControl:VALUE)
				self:ExpButtonHome(true)
			ENDIF
		ENDIF
	ENDIF
	RETURN nil
ACCESS Entity() CLASS Tab_Parm2
RETURN SELF:FieldGet(#Entity)

ASSIGN Entity(uValue) CLASS Tab_Parm2
SELF:FieldPut(#Entity, uValue)
RETURN uValue

access EntitySelected() class TAB_PARM2
return self:oDCEntity:CurrentItemNo


METHOD ExpButton( lUnique) CLASS Tab_Parm2
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrExp},{"KO"},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmGiftExpAc:TEXTValue ),"Gifts Expense",lUnique,cfilter)
	RETURN nil
METHOD ExpButtonHome(lUnique ) CLASS Tab_Parm2 
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NBREXPHOME},{"KO"},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmHomeExpAc:TEXTValue ),"Gifts Home Expense",lUnique,cfilter)
	RETURN nil

RETURN nil
   method FillPPCodes class Tab_Parm2
   return FillPP() 
				
METHOD HBButton(lUnique ) CLASS Tab_Parm2
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrHB},{"AK","PA"},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmHB:TEXTValue ),"Account PMC clearance",lUnique,cfilter)
	RETURN nil
ACCESS IESMAILACC() CLASS Tab_Parm2
RETURN SELF:FieldGet(#IESMAILACC)

ASSIGN IESMAILACC(uValue) CLASS Tab_Parm2
SELF:FieldPut(#IESMAILACC, uValue)
RETURN uValue

METHOD IncButton(lUnique ) CLASS Tab_Parm2
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrInc},{income},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmGiftIncAc:TEXTValue ),"Gifts Income",lUnique,cfilter)
	RETURN nil
METHOD IncButtonHome(lUnique ) CLASS Tab_Parm2 
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrIncHome},{"BA"},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmHomeIncAc:TEXTValue ),"Gifts Home Income",lUnique,cfilter)
	RETURN nil

RETURN nil
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS Tab_Parm2 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"Tab_Parm2",_GetInst()},iCtlID)

oDCEntity := combobox{SELF,ResourceID{TAB_PARM2_ENTITY,_GetInst()}}
oDCEntity:HyperLabel := HyperLabel{#Entity,"PP Codes","PP code of office",NULL_STRING}
oDCEntity:UseHLforToolTip := True
oDCEntity:FillUsing(Self:FillPPCodes( ))

oDCmHB := SingleLineEdit{SELF,ResourceID{TAB_PARM2_MHB,_GetInst()}}
oDCmHB:HyperLabel := HyperLabel{#mHB,NULL_STRING,"Accountnumber for CMS account",NULL_STRING}
oDCmHB:FieldSpec := MEMBERACCOUNT{}
oDCmHB:UseHLforToolTip := True

oCCHBButton := PushButton{SELF,ResourceID{TAB_PARM2_HBBUTTON,_GetInst()}}
oCCHBButton:HyperLabel := HyperLabel{#HBButton,"v","Browse in accounts",NULL_STRING}
oCCHBButton:TooltipText := "Browse in accounts"
oCCHBButton:UseHLforToolTip := True

oDCmAM := SingleLineEdit{SELF,ResourceID{TAB_PARM2_MAM,_GetInst()}}
oDCmAM:HyperLabel := HyperLabel{#mAM,NULL_STRING,"Accountnumber for assessments",NULL_STRING}
oDCmAM:FieldSpec := MEMBERACCOUNT{}
oDCmAM:UseHLforToolTip := True

oCCAMButton := PushButton{SELF,ResourceID{TAB_PARM2_AMBUTTON,_GetInst()}}
oCCAMButton:HyperLabel := HyperLabel{#AMButton,"v","Browse in accounts",NULL_STRING}
oCCAMButton:TooltipText := "Browse in accounts"
oCCAMButton:UseHLforToolTip := True

oDCmAMProj := SingleLineEdit{SELF,ResourceID{TAB_PARM2_MAMPROJ,_GetInst()}}
oDCmAMProj:HyperLabel := HyperLabel{#mAMProj,NULL_STRING,"Accountnumber for project assessments",NULL_STRING}
oDCmAMProj:FieldSpec := MEMBERACCOUNT{}
oDCmAMProj:UseHLforToolTip := True

oCCAMProjButton := PushButton{SELF,ResourceID{TAB_PARM2_AMPROJBUTTON,_GetInst()}}
oCCAMProjButton:HyperLabel := HyperLabel{#AMProjButton,"v","Browse in accounts",NULL_STRING}
oCCAMProjButton:TooltipText := "Browse in accounts"
oCCAMProjButton:UseHLforToolTip := True

oDCmGiftIncAc := SingleLineEdit{SELF,ResourceID{TAB_PARM2_MGIFTINCAC,_GetInst()}}
oDCmGiftIncAc:HyperLabel := HyperLabel{#mGiftIncAc,NULL_STRING,"Account to record assessable gifts as income",NULL_STRING}
oDCmGiftIncAc:FieldSpec := MEMBERACCOUNT{}
oDCmGiftIncAc:UseHLforToolTip := True

oCCIncButton := PushButton{SELF,ResourceID{TAB_PARM2_INCBUTTON,_GetInst()}}
oCCIncButton:HyperLabel := HyperLabel{#IncButton,"v","Browse in accounts",NULL_STRING}
oCCIncButton:TooltipText := "Browse in accounts"
oCCIncButton:UseHLforToolTip := True

oDCmGiftExpAc := SingleLineEdit{SELF,ResourceID{TAB_PARM2_MGIFTEXPAC,_GetInst()}}
oDCmGiftExpAc:HyperLabel := HyperLabel{#mGiftExpAc,NULL_STRING,"Account to record assessable gifts as expense",NULL_STRING}
oDCmGiftExpAc:FieldSpec := MEMBERACCOUNT{}
oDCmGiftExpAc:UseHLforToolTip := True

oCCExpButton := PushButton{SELF,ResourceID{TAB_PARM2_EXPBUTTON,_GetInst()}}
oCCExpButton:HyperLabel := HyperLabel{#ExpButton,"v","Browse in accounts",NULL_STRING}
oCCExpButton:TooltipText := "Browse in accounts"
oCCExpButton:UseHLforToolTip := True

oDCmHomeIncAc := SingleLineEdit{SELF,ResourceID{TAB_PARM2_MHOMEINCAC,_GetInst()}}
oDCmHomeIncAc:HyperLabel := HyperLabel{#mHomeIncAc,NULL_STRING,"Account to record assessable gifts to home assigned members as income",NULL_STRING}
oDCmHomeIncAc:FieldSpec := MEMBERACCOUNT{}
oDCmHomeIncAc:UseHLforToolTip := True

oCCIncButtonHome := PushButton{SELF,ResourceID{TAB_PARM2_INCBUTTONHOME,_GetInst()}}
oCCIncButtonHome:HyperLabel := HyperLabel{#IncButtonHome,"v","Browse in accounts",NULL_STRING}
oCCIncButtonHome:TooltipText := "Browse in accounts"
oCCIncButtonHome:UseHLforToolTip := True

oDCmHomeExpAc := SingleLineEdit{SELF,ResourceID{TAB_PARM2_MHOMEEXPAC,_GetInst()}}
oDCmHomeExpAc:HyperLabel := HyperLabel{#mHomeExpAc,NULL_STRING,"Account to record assessable gifts to home assigned members as expense",NULL_STRING}
oDCmHomeExpAc:FieldSpec := MEMBERACCOUNT{}
oDCmHomeExpAc:UseHLforToolTip := True

oCCExpButtonHome := PushButton{SELF,ResourceID{TAB_PARM2_EXPBUTTONHOME,_GetInst()}}
oCCExpButtonHome:HyperLabel := HyperLabel{#ExpButtonHome,"v","Browse in accounts",NULL_STRING}
oCCExpButtonHome:TooltipText := "Browse in accounts"
oCCExpButtonHome:UseHLforToolTip := True

oDCassmntfield := SingleLineEdit{SELF,ResourceID{TAB_PARM2_ASSMNTFIELD,_GetInst()}}
oDCassmntfield:FieldSpec := Sysparms_SINHDHAS{}
oDCassmntfield:HyperLabel := HyperLabel{#assmntfield,"Assessment home assigned:","Assessment field","Sysparms_SINHDHAS"}
oDCassmntfield:UseHLforToolTip := True

oDCassmntint := SingleLineEdit{SELF,ResourceID{TAB_PARM2_ASSMNTINT,_GetInst()}}
oDCassmntint:FieldSpec := Sysparms_INHDINT{}
oDCassmntint:HyperLabel := HyperLabel{#assmntint,"Assessment international","Assessment international",NULL_STRING}
oDCassmntint:UseHLforToolTip := True

oDCwithldoffl := SingleLineEdit{SELF,ResourceID{TAB_PARM2_WITHLDOFFL,_GetInst()}}
oDCwithldoffl:FieldSpec := Sysparms_SINHDKNTR{}
oDCwithldoffl:HyperLabel := HyperLabel{#withldoffl,"Assessment office:","Assessment office low","Sysparms_SINHDKNTR"}
oDCwithldoffl:UseHLforToolTip := True

oDCassmntOffc := SingleLineEdit{SELF,ResourceID{TAB_PARM2_ASSMNTOFFC,_GetInst()}}
oDCassmntOffc:FieldSpec := Sysparms_SINHDKNTR{}
oDCassmntOffc:HyperLabel := HyperLabel{#assmntOffc,"Assessment office:","Assessment office standard","Sysparms_SINHDKNTR"}

oDCwithldoffm := SingleLineEdit{SELF,ResourceID{TAB_PARM2_WITHLDOFFM,_GetInst()}}
oDCwithldoffm:FieldSpec := Sysparms_SINHDKNTR{}
oDCwithldoffm:HyperLabel := HyperLabel{#withldoffm,"Assessment office:","Assessment office","Sysparms_SINHDKNTR"}

oDCwithldoffh := SingleLineEdit{SELF,ResourceID{TAB_PARM2_WITHLDOFFH,_GetInst()}}
oDCwithldoffh:FieldSpec := Sysparms_SINHDKNTR{}
oDCwithldoffh:HyperLabel := HyperLabel{#withldoffh,"Assessment office:","Assessment office","Sysparms_SINHDKNTR"}

oDCpmcupld := CheckBox{SELF,ResourceID{TAB_PARM2_PMCUPLD,_GetInst()}}
oDCpmcupld:HyperLabel := HyperLabel{#pmcupld,"Sending to PMC via Insite upload",NULL_STRING,NULL_STRING}

oDCmPersonPMCMan := SingleLineEdit{SELF,ResourceID{TAB_PARM2_MPERSONPMCMAN,_GetInst()}}
oDCmPersonPMCMan:HyperLabel := HyperLabel{#mPersonPMCMan,NULL_STRING,NULL_STRING,"name PMC manager who should approve OPP file"}
oDCmPersonPMCMan:FocusSelect := FSEL_HOME
oDCmPersonPMCMan:FieldSpec := Person_NA1{}
oDCmPersonPMCMan:UseHLforToolTip := True

oDCIESMAILACC := SingleLineEdit{SELF,ResourceID{TAB_PARM2_IESMAILACC,_GetInst()}}
oDCIESMAILACC:FieldSpec := Sysparms_IESMailAcc{}
oDCIESMAILACC:HyperLabel := HyperLabel{#IESMAILACC,"Email account of IES:",NULL_STRING,"Sysparms_IESMailAcc"}
oDCIESMAILACC:TooltipText := "used to email OPP file to PMC"

oCCPersonButtonContact := PushButton{SELF,ResourceID{TAB_PARM2_PERSONBUTTONCONTACT,_GetInst()}}
oCCPersonButtonContact:HyperLabel := HyperLabel{#PersonButtonContact,"v","Browse in persons",NULL_STRING}
oCCPersonButtonContact:TooltipText := "Browse in Persons"

oDCSC_SHB := FixedText{SELF,ResourceID{TAB_PARM2_SC_SHB,_GetInst()}}
oDCSC_SHB:HyperLabel := HyperLabel{#SC_SHB,"Account PMC clearance:",NULL_STRING,NULL_STRING}

oDCSC_SAM := FixedText{SELF,ResourceID{TAB_PARM2_SC_SAM,_GetInst()}}
oDCSC_SAM:HyperLabel := HyperLabel{#SC_SAM,"Account Assessments standard:",NULL_STRING,NULL_STRING}

oDCSC_SINHDHAS := FixedText{SELF,ResourceID{TAB_PARM2_SC_SINHDHAS,_GetInst()}}
oDCSC_SINHDHAS:HyperLabel := HyperLabel{#SC_SINHDHAS,"Assessment:",NULL_STRING,NULL_STRING}

oDCSC_SINHDKNTR := FixedText{SELF,ResourceID{TAB_PARM2_SC_SINHDKNTR,_GetInst()}}
oDCSC_SINHDKNTR:HyperLabel := HyperLabel{#SC_SINHDKNTR,"office:",NULL_STRING,NULL_STRING}

oDCSC_ENTITY := FixedText{SELF,ResourceID{TAB_PARM2_SC_ENTITY,_GetInst()}}
oDCSC_ENTITY:HyperLabel := HyperLabel{#SC_ENTITY,"PMC Participant code:",NULL_STRING,NULL_STRING}

oDCFixedText8 := FixedText{SELF,ResourceID{TAB_PARM2_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"%",NULL_STRING,NULL_STRING}

oDCFixedText9 := FixedText{SELF,ResourceID{TAB_PARM2_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"%",NULL_STRING,NULL_STRING}

oDCSC_IESMAILACC := FixedText{SELF,ResourceID{TAB_PARM2_SC_IESMAILACC,_GetInst()}}
oDCSC_IESMAILACC:HyperLabel := HyperLabel{#SC_IESMAILACC,"Email address of PMC:",NULL_STRING,NULL_STRING}

oDCSC_SINHDHAS1 := FixedText{SELF,ResourceID{TAB_PARM2_SC_SINHDHAS1,_GetInst()}}
oDCSC_SINHDHAS1:HyperLabel := HyperLabel{#SC_SINHDHAS1,"field:",NULL_STRING,NULL_STRING}

oDCSC_SINHDKNTR1 := FixedText{SELF,ResourceID{TAB_PARM2_SC_SINHDKNTR1,_GetInst()}}
oDCSC_SINHDKNTR1:HyperLabel := HyperLabel{#SC_SINHDKNTR1,"int:",NULL_STRING,NULL_STRING}

oDCFixedText10 := FixedText{SELF,ResourceID{TAB_PARM2_FIXEDTEXT10,_GetInst()}}
oDCFixedText10:HyperLabel := HyperLabel{#FixedText10,"%",NULL_STRING,NULL_STRING}

oDCFixedText14 := FixedText{SELF,ResourceID{TAB_PARM2_FIXEDTEXT14,_GetInst()}}
oDCFixedText14:HyperLabel := HyperLabel{#FixedText14,"low",NULL_STRING,NULL_STRING}

oDCFixedText15 := FixedText{SELF,ResourceID{TAB_PARM2_FIXEDTEXT15,_GetInst()}}
oDCFixedText15:HyperLabel := HyperLabel{#FixedText15,"standard",NULL_STRING,NULL_STRING}

oDCFixedText11 := FixedText{SELF,ResourceID{TAB_PARM2_FIXEDTEXT11,_GetInst()}}
oDCFixedText11:HyperLabel := HyperLabel{#FixedText11,"%",NULL_STRING,NULL_STRING}

oDCFixedText12 := FixedText{SELF,ResourceID{TAB_PARM2_FIXEDTEXT12,_GetInst()}}
oDCFixedText12:HyperLabel := HyperLabel{#FixedText12,"%",NULL_STRING,NULL_STRING}

oDCFixedText16 := FixedText{SELF,ResourceID{TAB_PARM2_FIXEDTEXT16,_GetInst()}}
oDCFixedText16:HyperLabel := HyperLabel{#FixedText16,"middle",NULL_STRING,NULL_STRING}

oDCFixedText17 := FixedText{SELF,ResourceID{TAB_PARM2_FIXEDTEXT17,_GetInst()}}
oDCFixedText17:HyperLabel := HyperLabel{#FixedText17,"high",NULL_STRING,NULL_STRING}

oDCFixedText13 := FixedText{SELF,ResourceID{TAB_PARM2_FIXEDTEXT13,_GetInst()}}
oDCFixedText13:HyperLabel := HyperLabel{#FixedText13,"%",NULL_STRING,NULL_STRING}

oDCSC_SAM1 := FixedText{SELF,ResourceID{TAB_PARM2_SC_SAM1,_GetInst()}}
oDCSC_SAM1:HyperLabel := HyperLabel{#SC_SAM1,"Account Project Assessments",NULL_STRING,NULL_STRING}

oDCGroupBoxIncome := GroupBox{SELF,ResourceID{TAB_PARM2_GROUPBOXINCOME,_GetInst()}}
oDCGroupBoxIncome:HyperLabel := HyperLabel{#GroupBoxIncome,"Accounts to record assessable gifts to measure activity",NULL_STRING,NULL_STRING}

oDCSC_SAM2 := FixedText{SELF,ResourceID{TAB_PARM2_SC_SAM2,_GetInst()}}
oDCSC_SAM2:HyperLabel := HyperLabel{#SC_SAM2,"Account Gifts Expense:",NULL_STRING,NULL_STRING}

oDCSC_SAM3 := FixedText{SELF,ResourceID{TAB_PARM2_SC_SAM3,_GetInst()}}
oDCSC_SAM3:HyperLabel := HyperLabel{#SC_SAM3,"Account Gifts Income:",NULL_STRING,NULL_STRING}

oDCSC_SAM4 := FixedText{SELF,ResourceID{TAB_PARM2_SC_SAM4,_GetInst()}}
oDCSC_SAM4:HyperLabel := HyperLabel{#SC_SAM4,"Account Home Gifts Expense:",NULL_STRING,NULL_STRING}

oDCSC_SAM5 := FixedText{SELF,ResourceID{TAB_PARM2_SC_SAM5,_GetInst()}}
oDCSC_SAM5:HyperLabel := HyperLabel{#SC_SAM5,"Account Home Gifts Income:",NULL_STRING,NULL_STRING}

oDCFixedText24 := FixedText{SELF,ResourceID{TAB_PARM2_FIXEDTEXT24,_GetInst()}}
oDCFixedText24:HyperLabel := HyperLabel{#FixedText24,"PMC Manager:",NULL_STRING,NULL_STRING}

oDCmAssFldAc := SingleLineEdit{SELF,ResourceID{TAB_PARM2_MASSFLDAC,_GetInst()}}
oDCmAssFldAc:HyperLabel := HyperLabel{#mAssFldAc,NULL_STRING,"Accountnumber for field+int.assessments",NULL_STRING}
oDCmAssFldAc:FieldSpec := MEMBERACCOUNT{}
oDCmAssFldAc:TooltipText := "account to record how much the expense for field and international assessment is"

oCCAssFldAcButton := PushButton{SELF,ResourceID{TAB_PARM2_ASSFLDACBUTTON,_GetInst()}}
oCCAssFldAcButton:HyperLabel := HyperLabel{#AssFldAcButton,"v","Browse in accounts",NULL_STRING}
oCCAssFldAcButton:TooltipText := "Browse in accounts"
oCCAssFldAcButton:UseHLforToolTip := True

oDCSC_SAMFld := FixedText{SELF,ResourceID{TAB_PARM2_SC_SAMFLD,_GetInst()}}
oDCSC_SAMFld:HyperLabel := HyperLabel{#SC_SAMFld,"Account Assessment Field+Int",NULL_STRING,NULL_STRING}

SELF:Caption := "Account Gifts Expense:"
SELF:HyperLabel := HyperLabel{#Tab_Parm2,"Account Gifts Expense:",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:Automated := False

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mAM() CLASS Tab_Parm2
RETURN SELF:FieldGet(#mAM)

ASSIGN mAM(uValue) CLASS Tab_Parm2
SELF:FieldPut(#mAM, uValue)
RETURN uValue

ACCESS mAMProj() CLASS Tab_Parm2
RETURN SELF:FieldGet(#mAMProj)

ASSIGN mAMProj(uValue) CLASS Tab_Parm2
SELF:FieldPut(#mAMProj, uValue)
RETURN uValue

ACCESS mAssFldAc() CLASS Tab_Parm2
RETURN SELF:FieldGet(#mAssFldAc)

ASSIGN mAssFldAc(uValue) CLASS Tab_Parm2
SELF:FieldPut(#mAssFldAc, uValue)
RETURN uValue

ACCESS mGiftExpAc() CLASS Tab_Parm2
RETURN SELF:FieldGet(#mGiftExpAc)

ASSIGN mGiftExpAc(uValue) CLASS Tab_Parm2
SELF:FieldPut(#mGiftExpAc, uValue)
RETURN uValue

ACCESS mGiftIncAc() CLASS Tab_Parm2
RETURN SELF:FieldGet(#mGiftIncAc)

ASSIGN mGiftIncAc(uValue) CLASS Tab_Parm2
SELF:FieldPut(#mGiftIncAc, uValue)
RETURN uValue

ACCESS mHB() CLASS Tab_Parm2
RETURN SELF:FieldGet(#mHB)

ASSIGN mHB(uValue) CLASS Tab_Parm2
SELF:FieldPut(#mHB, uValue)
RETURN uValue

ACCESS mHomeExpAc() CLASS Tab_Parm2
RETURN SELF:FieldGet(#mHomeExpAc)

ASSIGN mHomeExpAc(uValue) CLASS Tab_Parm2
SELF:FieldPut(#mHomeExpAc, uValue)
RETURN uValue

ACCESS mHomeIncAc() CLASS Tab_Parm2
RETURN SELF:FieldGet(#mHomeIncAc)

ASSIGN mHomeIncAc(uValue) CLASS Tab_Parm2
SELF:FieldPut(#mHomeIncAc, uValue)
RETURN uValue

ACCESS mPersonPMCMan() CLASS Tab_Parm2
RETURN SELF:FieldGet(#mPersonPMCMan)

ASSIGN mPersonPMCMan(uValue) CLASS Tab_Parm2
SELF:FieldPut(#mPersonPMCMan, uValue)
RETURN uValue

METHOD PersonButtonContact(lUnique,WithCln ) CLASS Tab_Parm2 
	LOCAL cValue := AllTrim(self:oDCmPersonPMCMan:TEXTValue ) as STRING
	local oPers as PersonContainer
	Default(@lUnique,FALSE)
// 	PersonSelect(self:Owner,cValue,lUnique,,"PMC Manager")
	Default(@lUnique,FALSE) 
	Default(@WithCln,true) 
	oPers:=PersonContainer{}
	IF !Empty(self:mCLNPMCMan).and.WithCln .and. !Val(self:mCLNPMCMan)=0
		oPers:persid:=self:mCLNPMCMan
	else
		oPers:persid:=""
	endif
	IF self:lImport
		PersonSelect(self:Owner,cValue,lUnique,,"PMC Manager",oPers)
	else
		PersonSelect(self:Owner,cValue,lUnique,,"PMC Manager",oPers)
	endif

RETURN nil
ACCESS pmcupld() CLASS Tab_Parm2
RETURN SELF:FieldGet(#pmcupld)

ASSIGN pmcupld(uValue) CLASS Tab_Parm2
SELF:FieldPut(#pmcupld, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS Tab_Parm2
	//Put your PostInit additions here
	LOCAL oAcc as SQLSelect
	self:SetTexts()
	IF !Empty(self:oSys:AM)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:AM,-1),oConn}
		IF oAcc:RecCount>0
			self:NbrAM :=  Str(oAcc:accid,-1)
			self:oDCmAM:TEXTValue := oAcc:Description
			self:cAMName := AllTrim(oAcc:Description)
			self:cSoortAM:=oAcc:TYPE
		ENDIF		
		IF !Empty(self:oSys:AssProjA)
			oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:AssProjA,-1),oConn}
			IF oAcc:RecCount>0
				self:NbrAMProj :=  Str(oAcc:accid,-1)
				self:oDCmAMProj:TEXTValue := oAcc:Description
				self:cAMNameProj := AllTrim(oAcc:Description)
				self:cSoortAMProj:=oAcc:TYPE
			ENDIF		
		ENDIF
		IF !Empty(self:oSys:AssFldAc)
			oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:AssFldAc,-1),oConn}
			IF oAcc:RecCount>0
				self:NbrAssFldAc :=  Str(oAcc:accid,-1)
				self:oDCmAssFldAc:TEXTValue := oAcc:Description
				self:cAssFldAccName := oAcc:Description
				self:cSoortAssFldAc:=oAcc:TYPE
			ENDIF		
		ENDIF
	endif
	IF	!Empty(self:oSys:HB)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:HB,-1),oConn}
		IF	oAcc:RecCount>0
			self:NbrHB :=	Str(oAcc:accid,-1)
			self:oDCmHB:TEXTValue := oAcc:Description
			self:cHBName := oAcc:Description
			self:cSoortHB:=oAcc:TYPE
		ENDIF		
	ENDIF	
	IF !Empty(self:oSys:GIFTEXPAC)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:GIFTEXPAC,-1),oConn}
		IF oAcc:RecCount>0
			self:NbrExp :=  Str(oAcc:accid,-1)
			self:oDCmGIFTEXPAC:TEXTValue := AllTrim(oAcc:Description)
			self:cGIFTEXPACName := oAcc:Description
			self:cSoortGIFTEXPAC:=oAcc:TYPE
		ENDIF		
	ENDIF
	IF !Empty(self:oSys:GIFTINCAC)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:GIFTINCAC,-1),oConn}
		IF oAcc:RecCount>0
			self:NbrInc :=  Str(oAcc:accid,-1)
			self:oDCmGIFTINCAC:TEXTValue := oAcc:Description
			self:cGIFTINCACName := oAcc:Description
			self:cSoortGIFTINCAC:=oAcc:TYPE
		ENDIF		
	ENDIF
	self:ShowAssAcc()

	IF !Empty(self:oSys:HOMEEXPAC)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:HOMEEXPAC,-1),oConn}
		IF oAcc:RecCount>0
			self:NBREXPHOME :=  Str(oAcc:accid,-1)
			self:oDCmHOMEEXPAC:TEXTValue := oAcc:Description
			self:cHomeEXPACName := oAcc:Description
			self:cSoortHomeEXPAC:=oAcc:TYPE
		ENDIF		
	ENDIF
	IF !Empty(self:oSys:HOMEINCAC)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:HOMEINCAC,-1),oConn}
		IF oAcc:RecCount>0
			self:NbrIncHome :=  Str(oAcc:accid,-1)
			self:oDCmHOMEINCAC:TEXTValue := oAcc:Description
			self:cHOMEINCACName := oAcc:Description
			self:cSoortHomeINCAC:=oAcc:TYPE
		ENDIF		
	ENDIF
	self:assmntfield:=self:oSys:assmntfield
	self:withldoffl:=self:oSys:withldoffl	
	self:IESMAILACC:=self:oSys:IESMAILACC 
	self:assmntint:=self:oSys:assmntint 
	self:assmntOffc:=self:oSys:assmntOffc 
	self:withldoffM:=self:oSys:withldoffM	
	self:withldoffH:=self:oSys:withldoffH	
	self:pmcupld:=ConL(ConI(self:oSys:pmcupld)) 

	IF self:oDCpmcupld:Checked
		self:oDCSC_IESMAILACC:Hide()
		self:oDCIESMAILACC:Hide()
	else
		self:oDCSC_IESMAILACC:Show()
		self:oDCIESMAILACC:Show()
	endif
               
	self:mCLNPMCMan:=Str(self:oSys:PMCMANCLN,-1)
	self:cPMCManName:=GetFullName(self:mCLNPMCMan)
	self:oDCmPersonPMCMan:TEXTValue:=cPMCManName
	self:oDCENTITY:Value:=self:oSys:Entity
	RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class Tab_Parm2
	//Put your PreInit additions here 
	self:oSys:=oWindow:oSys
	return NIL

method ShowAssAcc() class Tab_Parm2
// show or hide fields for income/cost ministry 
	IF	!Empty(self:NbrInc)
		self:oDCmHomeIncAc:Show()
		self:oDCSC_SAM5:Show()
		self:oCCIncButtonHome:Show() 
		self:oDCmHomeExpAc:Show()
		self:oDCSC_SAM4:Show()
		self:oCCExpButtonHome:Show()
		self:oDCmAssFldAc:Show()
		self:oDCSC_SAMFld:Show()
		self:oCCAssFldAcButton:Show()
	else
		self:oDCmHomeIncAc:Hide()
		self:oDCSC_SAM5:Hide()
		self:oCCIncButtonHome:Hide()
		self:oDCmHomeExpAc:Hide()
		self:oDCSC_SAM4:Hide()
		self:oCCExpButtonHome:Hide()
		self:oDCmAssFldAc:Hide()
		self:oDCSC_SAMFld:Hide()		
		self:oCCAssFldAcButton:Hide()
	endif	


ACCESS withldoff() CLASS Tab_Parm2
RETURN self:FIELDGET(#INHDHAS)

ASSIGN withldoff(uValue) CLASS Tab_Parm2
self:FIELDPUT(#INHDHAS, uValue)
RETURN uValue

ACCESS withldoffh() CLASS Tab_Parm2
RETURN SELF:FieldGet(#withldoffh)

ASSIGN withldoffh(uValue) CLASS Tab_Parm2
SELF:FieldPut(#withldoffh, uValue)
RETURN uValue

ACCESS withldoffl() CLASS Tab_Parm2
RETURN SELF:FieldGet(#withldoffl)

ASSIGN withldoffl(uValue) CLASS Tab_Parm2
SELF:FieldPut(#withldoffl, uValue)
RETURN uValue

ACCESS withldoffm() CLASS Tab_Parm2
RETURN SELF:FieldGet(#withldoffm)

ASSIGN withldoffm(uValue) CLASS Tab_Parm2
SELF:FieldPut(#withldoffm, uValue)
RETURN uValue

STATIC DEFINE TAB_PARM2_AMBUTTON := 104 
STATIC DEFINE TAB_PARM2_AMPROJBUTTON := 106 
STATIC DEFINE TAB_PARM2_ASSFLDACBUTTON := 151 
STATIC DEFINE TAB_PARM2_ASSMNTFIELD := 115 
STATIC DEFINE TAB_PARM2_ASSMNTINT := 116 
STATIC DEFINE TAB_PARM2_ASSMNTOFFC := 118 
STATIC DEFINE TAB_PARM2_ENTITY := 100 
STATIC DEFINE TAB_PARM2_EXPBUTTON := 110 
STATIC DEFINE TAB_PARM2_EXPBUTTONHOME := 114 
STATIC DEFINE TAB_PARM2_FIXEDTEXT10 := 135 
STATIC DEFINE TAB_PARM2_FIXEDTEXT11 := 138 
STATIC DEFINE TAB_PARM2_FIXEDTEXT12 := 139 
STATIC DEFINE TAB_PARM2_FIXEDTEXT13 := 142 
STATIC DEFINE TAB_PARM2_FIXEDTEXT14 := 136 
STATIC DEFINE TAB_PARM2_FIXEDTEXT15 := 137 
STATIC DEFINE TAB_PARM2_FIXEDTEXT16 := 140 
STATIC DEFINE TAB_PARM2_FIXEDTEXT17 := 141 
STATIC DEFINE TAB_PARM2_FIXEDTEXT24 := 149 
STATIC DEFINE TAB_PARM2_FIXEDTEXT8 := 130 
STATIC DEFINE TAB_PARM2_FIXEDTEXT9 := 131 
STATIC DEFINE TAB_PARM2_GROUPBOXINCOME := 144 
STATIC DEFINE TAB_PARM2_HBBUTTON := 102 
STATIC DEFINE TAB_PARM2_IESMAILACC := 123 
STATIC DEFINE TAB_PARM2_INCBUTTON := 108 
STATIC DEFINE TAB_PARM2_INCBUTTONHOME := 112 
STATIC DEFINE TAB_PARM2_MAM := 103 
STATIC DEFINE TAB_PARM2_MAMPROJ := 105 
STATIC DEFINE TAB_PARM2_MASSFLDAC := 150 
STATIC DEFINE TAB_PARM2_MGIFTEXPAC := 109 
STATIC DEFINE TAB_PARM2_MGIFTINCAC := 107 
STATIC DEFINE TAB_PARM2_MHB := 101 
STATIC DEFINE TAB_PARM2_MHOMEEXPAC := 113 
STATIC DEFINE TAB_PARM2_MHOMEINCAC := 111 
STATIC DEFINE TAB_PARM2_MPERSONPMCMAN := 122 
STATIC DEFINE TAB_PARM2_PERSONBUTTONCONTACT := 124 
STATIC DEFINE TAB_PARM2_PMCUPLD := 121 
STATIC DEFINE TAB_PARM2_SC_ENTITY := 129 
STATIC DEFINE TAB_PARM2_SC_IESMAILACC := 132 
STATIC DEFINE TAB_PARM2_SC_SAM := 126 
STATIC DEFINE TAB_PARM2_SC_SAM1 := 143 
STATIC DEFINE TAB_PARM2_SC_SAM2 := 145 
STATIC DEFINE TAB_PARM2_SC_SAM3 := 146 
STATIC DEFINE TAB_PARM2_SC_SAM4 := 147 
STATIC DEFINE TAB_PARM2_SC_SAM5 := 148 
STATIC DEFINE TAB_PARM2_SC_SAMFLD := 152 
STATIC DEFINE TAB_PARM2_SC_SHB := 125 
STATIC DEFINE TAB_PARM2_SC_SINHDHAS := 127 
STATIC DEFINE TAB_PARM2_SC_SINHDHAS1 := 133 
STATIC DEFINE TAB_PARM2_SC_SINHDKNTR := 128 
STATIC DEFINE TAB_PARM2_SC_SINHDKNTR1 := 134 
STATIC DEFINE TAB_PARM2_WITHLDOFFH := 120 
STATIC DEFINE TAB_PARM2_WITHLDOFFL := 117 
STATIC DEFINE TAB_PARM2_WITHLDOFFM := 119 
CLASS Tab_Parm3 INHERIT DataWindowMine 

	PROTECT oDBMPOSTAGE as DataColumn
	PROTECT oDBMDEBTORS as DataColumn
	PROTECT oDBCNTRNRCOLL as DataColumn
	PROTECT oDCmPOSTAGE AS SINGLELINEEDIT
	PROTECT oCCPostageButton AS PUSHBUTTON
	PROTECT oDCSC_SPOSTZ AS FIXEDTEXT
	PROTECT oDCGroupBox3 AS GROUPBOX
	PROTECT oDCmDEBTORS AS SINGLELINEEDIT
	PROTECT oCCDebButton AS PUSHBUTTON
	PROTECT oDCmCREDITORS AS SINGLELINEEDIT
	PROTECT oCCCreButton AS PUSHBUTTON
	PROTECT oDCSC_SDEB AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCCNTRNRCOLL AS SINGLELINEEDIT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCBANKNBRCOL AS COMBOBOX
	PROTECT oDCSC_SCRE AS FIXEDTEXT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCBANKNBRCRE AS COMBOBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
    EXPORT cPostageName, cDEBTORSName, cCREDITORSName as STRING
  	EXPORT NbrPostage, NbrDEBTORS, NbrCREDITORS as STRING
  	EXPORT cSoortPostage, cSoortDEBTORS, cSoortCREDITORS as STRING
   protect oSys as SQLSelect

RESOURCE Tab_Parm3 DIALOGEX  26, 29, 254, 240
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TAB_PARM3_MPOSTAGE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 100, 18, 122, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM3_POSTAGEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 220, 18, 15, 12
	CONTROL	"Account Postage:", TAB_PARM3_SC_SPOSTZ, "Static", WS_CHILD, 12, 22, 64, 12
	CONTROL	"Receiving/sending Bills", TAB_PARM3_GROUPBOX3, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 7, 232, 129
	CONTROL	"", TAB_PARM3_MDEBTORS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 100, 36, 122, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM3_DEBBUTTON, "Button", WS_CHILD, 220, 36, 15, 13
	CONTROL	"", TAB_PARM3_MCREDITORS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 100, 55, 122, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TAB_PARM3_CREBUTTON, "Button", WS_CHILD, 220, 55, 15, 12
	CONTROL	"Account Receivable", TAB_PARM3_SC_SDEB, "Static", WS_CHILD, 12, 36, 68, 13
	CONTROL	"Contract number direct debit:", TAB_PARM3_FIXEDTEXT2, "Static", WS_CHILD, 12, 73, 84, 19
	CONTROL	"", TAB_PARM3_CNTRNRCOLL, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 100, 73, 135, 13, WS_EX_CLIENTEDGE
	CONTROL	"Bank account direct debit:", TAB_PARM3_FIXEDTEXT3, "Static", WS_CHILD, 12, 92, 88, 18
	CONTROL	"", TAB_PARM3_BANKNBRCOL, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 100, 92, 135, 140
	CONTROL	"Account Payable", TAB_PARM3_SC_SCRE, "Static", WS_CHILD, 12, 55, 68, 12
	CONTROL	"Bank account payments:", TAB_PARM3_FIXEDTEXT4, "Static", WS_CHILD, 12, 110, 82, 18
	CONTROL	"", TAB_PARM3_BANKNBRCRE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 100, 110, 135, 118
END

ACCESS BANKNBRCOL() CLASS Tab_Parm3
RETURN SELF:FieldGet(#BANKNBRCOL)

ASSIGN BANKNBRCOL(uValue) CLASS Tab_Parm3
SELF:FieldPut(#BANKNBRCOL, uValue)
RETURN uValue

ACCESS BANKNBRCRE() CLASS Tab_Parm3
RETURN SELF:FieldGet(#BANKNBRCRE)

ASSIGN BANKNBRCRE(uValue) CLASS Tab_Parm3
SELF:FieldPut(#BANKNBRCRE, uValue)
RETURN uValue

ACCESS CNTRNRCOLL() CLASS Tab_Parm3
RETURN SELF:FieldGet(#CNTRNRCOLL)

ASSIGN CNTRNRCOLL(uValue) CLASS Tab_Parm3
SELF:FieldPut(#CNTRNRCOLL, uValue)
RETURN uValue

METHOD CreButton(lUnique ) CLASS TAB_PARM3 
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrCreditors},{"PA"},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmCREDITORS:TEXTValue ),"Payable",lUnique,cfilter)
	RETURN nil
METHOD DebButton(lUnique ) CLASS TAB_PARM3
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrDEBTORS},{"AK"},"N",0,false,BankAccs)
	AccountSelect(self:Owner,AllTrim(oDCmDEBTORS:TEXTValue ),"Receivable",lUnique,cfilter)
	RETURN nil

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS Tab_Parm3
	LOCAL oControl as Control
	LOCAL lGotFocus as LOGIC
	oControl := iif(oEditFocusChangeEvent == null_object, null_object, oEditFocusChangeEvent:Control)
	lGotFocus := iif(oEditFocusChangeEvent == null_object, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "MPOSTAGE".and.!AllTrim(oControl:VALUE)==AllTrim(cPostageName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrPostage := "  "
				self:cPostageName := ""
				self:oDCmPostage:TEXTValue := ""
            ELSE
				cPostageName:=AllTrim(oControl:VALUE)
				self:PostageButton(true)
			ENDIF
		ELSEIF oControl:Name == "MDEBTORS".and.!AllTrim(oControl:VALUE)==AllTrim(cDEBTORSName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrDEBTORS:="  "
				self:cDEBTORSName := ""
				self:oDCmDEBTORS:TEXTValue := ""
            ELSE
				cDEBTORSName:=AllTrim(oControl:VALUE)
				self:DEBButton(true)
			ENDIF
		ELSEIF oControl:Name == "MCREDITORS".and.!AllTrim(oControl:VALUE)==AllTrim(cCREDITORSName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrCreditors:="  "
				self:cCREDITORSName := ""
				self:oDCmCREDITORS:TEXTValue := ""
            ELSE
				cCREDITORSName:=AllTrim(oControl:VALUE)
				self:CreButton(true)
			ENDIF
		ENDIF
	ENDIF
	RETURN nil

METHOD FillBank() CLASS Tab_Parm3
	RETURN FillBankAccount("b.Telebankng")

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS Tab_Parm3 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"Tab_Parm3",_GetInst()},iCtlID)

oDCmPOSTAGE := SingleLineEdit{SELF,ResourceID{TAB_PARM3_MPOSTAGE,_GetInst()}}
oDCmPOSTAGE:HyperLabel := HyperLabel{#mPOSTAGE,NULL_STRING,"Accountnumber for postage",NULL_STRING}
oDCmPOSTAGE:FieldSpec := MEMBERACCOUNT{}

oCCPostageButton := PushButton{SELF,ResourceID{TAB_PARM3_POSTAGEBUTTON,_GetInst()}}
oCCPostageButton:HyperLabel := HyperLabel{#PostageButton,"v","Browse in accounts",NULL_STRING}
oCCPostageButton:TooltipText := "Browse in accounts"

oDCSC_SPOSTZ := FixedText{SELF,ResourceID{TAB_PARM3_SC_SPOSTZ,_GetInst()}}
oDCSC_SPOSTZ:HyperLabel := HyperLabel{#SC_SPOSTZ,"Account Postage:",NULL_STRING,NULL_STRING}

oDCGroupBox3 := GroupBox{SELF,ResourceID{TAB_PARM3_GROUPBOX3,_GetInst()}}
oDCGroupBox3:HyperLabel := HyperLabel{#GroupBox3,"Receiving/sending Bills",NULL_STRING,NULL_STRING}

oDCmDEBTORS := SingleLineEdit{SELF,ResourceID{TAB_PARM3_MDEBTORS,_GetInst()}}
oDCmDEBTORS:HyperLabel := HyperLabel{#mDEBTORS,NULL_STRING,"Accountnumber Debtors",NULL_STRING}
oDCmDEBTORS:FieldSpec := MEMBERACCOUNT{}
oDCmDEBTORS:UseHLforToolTip := True

oCCDebButton := PushButton{SELF,ResourceID{TAB_PARM3_DEBBUTTON,_GetInst()}}
oCCDebButton:HyperLabel := HyperLabel{#DebButton,"v","Browse in accounts",NULL_STRING}
oCCDebButton:TooltipText := "Browse in accounts"

oDCmCREDITORS := SingleLineEdit{SELF,ResourceID{TAB_PARM3_MCREDITORS,_GetInst()}}
oDCmCREDITORS:HyperLabel := HyperLabel{#mCREDITORS,NULL_STRING,"Accountnumber Creditors",NULL_STRING}
oDCmCREDITORS:FieldSpec := MEMBERACCOUNT{}
oDCmCREDITORS:UseHLforToolTip := True

oCCCreButton := PushButton{SELF,ResourceID{TAB_PARM3_CREBUTTON,_GetInst()}}
oCCCreButton:HyperLabel := HyperLabel{#CreButton,"v","Browse in accounts",NULL_STRING}
oCCCreButton:TooltipText := "Browse in accounts"

oDCSC_SDEB := FixedText{SELF,ResourceID{TAB_PARM3_SC_SDEB,_GetInst()}}
oDCSC_SDEB:HyperLabel := HyperLabel{#SC_SDEB,"Account Receivable",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{TAB_PARM3_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Contract number direct debit:",NULL_STRING,NULL_STRING}

oDCCNTRNRCOLL := SingleLineEdit{SELF,ResourceID{TAB_PARM3_CNTRNRCOLL,_GetInst()}}
oDCCNTRNRCOLL:HyperLabel := HyperLabel{#CNTRNRCOLL,NULL_STRING,"Contract number automatic collection (KID files)",NULL_STRING}
oDCCNTRNRCOLL:UseHLforToolTip := True

oDCFixedText3 := FixedText{SELF,ResourceID{TAB_PARM3_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Bank account direct debit:",NULL_STRING,NULL_STRING}

oDCBANKNBRCOL := combobox{SELF,ResourceID{TAB_PARM3_BANKNBRCOL,_GetInst()}}
oDCBANKNBRCOL:FillUsing(Self:FillBank( ))
oDCBANKNBRCOL:HyperLabel := HyperLabel{#BANKNBRCOL,NULL_STRING,"Own telebanking bank account used to credit invoices and automatic collection",NULL_STRING}
oDCBANKNBRCOL:UseHLforToolTip := True

oDCSC_SCRE := FixedText{SELF,ResourceID{TAB_PARM3_SC_SCRE,_GetInst()}}
oDCSC_SCRE:HyperLabel := HyperLabel{#SC_SCRE,"Account Payable",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{TAB_PARM3_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Bank account payments:",NULL_STRING,NULL_STRING}

oDCBANKNBRCRE := combobox{SELF,ResourceID{TAB_PARM3_BANKNBRCRE,_GetInst()}}
oDCBANKNBRCRE:FillUsing(Self:FillBank( ))
oDCBANKNBRCRE:HyperLabel := HyperLabel{#BANKNBRCRE,NULL_STRING,"Own telebanking bank account used to send payments to creditor",NULL_STRING}
oDCBANKNBRCRE:UseHLforToolTip := True

SELF:Caption := ""
SELF:HyperLabel := HyperLabel{#Tab_Parm3,NULL_STRING,NULL_STRING,NULL_STRING}
SELF:EnableStatusBar(True)
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := DataBrowser{self}

oDBMPOSTAGE := DataColumn{MEMBERACCOUNT{}}
oDBMPOSTAGE:Width := 10
oDBMPOSTAGE:HyperLabel := oDCMPOSTAGE:HyperLabel 
oDBMPOSTAGE:Caption := ""
self:Browser:AddColumn(oDBMPOSTAGE)

oDBMDEBTORS := DataColumn{MEMBERACCOUNT{}}
oDBMDEBTORS:Width := 10
oDBMDEBTORS:HyperLabel := oDCMDEBTORS:HyperLabel 
oDBMDEBTORS:Caption := ""
self:Browser:AddColumn(oDBMDEBTORS)

oDBCNTRNRCOLL := DataColumn{12}
oDBCNTRNRCOLL:Width := 12
oDBCNTRNRCOLL:HyperLabel := oDCCNTRNRCOLL:HyperLabel 
oDBCNTRNRCOLL:Caption := ""
self:Browser:AddColumn(oDBCNTRNRCOLL)


SELF:ViewAs(#FormView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mCREDITORS() CLASS Tab_Parm3
RETURN SELF:FieldGet(#mCREDITORS)

ASSIGN mCREDITORS(uValue) CLASS Tab_Parm3
SELF:FieldPut(#mCREDITORS, uValue)
RETURN uValue

ACCESS mDEBTORS() CLASS Tab_Parm3
RETURN SELF:FieldGet(#mDEBTORS)

ASSIGN mDEBTORS(uValue) CLASS Tab_Parm3
SELF:FieldPut(#mDEBTORS, uValue)
RETURN uValue

ACCESS mPOSTAGE() CLASS Tab_Parm3
RETURN SELF:FieldGet(#mPOSTAGE)

ASSIGN mPOSTAGE(uValue) CLASS Tab_Parm3
SELF:FieldPut(#mPOSTAGE, uValue)
RETURN uValue

METHOD PostageButton( lUnique) CLASS Tab_Parm3
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrPostage},{"KO"},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmPostage:TEXTValue ),"Postage",lUnique,cfilter)
	RETURN nil
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS Tab_Parm3
	//Put your PostInit additions here
	LOCAL oAcc as SQLSelect
	self:SetTexts()
	IF !Empty(self:oSys:Postage)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:Postage,-1),oConn}
		IF oAcc:RecCount>0
			self:NbrPostage :=  Str(oAcc:accid,-1)
			self:oDCmPostage:TEXTValue := AllTrim(oAcc:Description)
			self:cPostageName := AllTrim(oAcc:Description)
			self:cSoortPostage:=oAcc:TYPE
		ENDIF		
	ENDIF
	IF !Empty(self:oSys:DEBTORS)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:DEBTORS,-1),oConn}
		IF oAcc:RecCount>0
			self:NbrDEBTORS :=  Str(oAcc:accid,-1)
			self:oDCmDEBTORS:TEXTValue := AllTrim(oAcc:Description)
			self:cDEBTORSName := AllTrim(oAcc:Description)
			self:cSoortDEBTORS:=oAcc:TYPE
		ENDIF		
	ENDIF
	IF !Empty(self:oSys:CREDITORS)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:CREDITORS,-1),oConn}
		IF oAcc:RecCount>0
			self:NbrCreditors :=  Str(oAcc:accid,-1)
			self:oDCmCREDITORS:TEXTValue := AllTrim(oAcc:Description)
			self:cCREDITORSName := AllTrim(oAcc:Description)
			self:cSoortCREDITORS:=oAcc:TYPE
		ENDIF		
	ENDIF 
	self:CNTRNRCOLL:=self:oSys:CNTRNRCOLL
	self:BANKNBRCOL:=self:oSys:BANKNBRCOL
	self:BANKNBRCRE:=self:oSys:BANKNBRCRE

	RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class Tab_Parm3
	//Put your PreInit additions here
	self:oSys:=oWindow:oSys
	return nil

STATIC DEFINE TAB_PARM3_BANKNBRCOL := 112 
STATIC DEFINE TAB_PARM3_BANKNBRCRE := 115 
STATIC DEFINE TAB_PARM3_CNTRNRCOLL := 110 
STATIC DEFINE TAB_PARM3_CREBUTTON := 107 
STATIC DEFINE TAB_PARM3_DEBBUTTON := 105 
STATIC DEFINE TAB_PARM3_FIXEDTEXT2 := 109 
STATIC DEFINE TAB_PARM3_FIXEDTEXT3 := 111 
STATIC DEFINE TAB_PARM3_FIXEDTEXT4 := 114 
STATIC DEFINE TAB_PARM3_GROUPBOX3 := 103 
STATIC DEFINE TAB_PARM3_MCREDITORS := 106 
STATIC DEFINE TAB_PARM3_MDEBTORS := 104 
STATIC DEFINE TAB_PARM3_MPOSTAGE := 100 
STATIC DEFINE TAB_PARM3_POSTAGEBUTTON := 101 
STATIC DEFINE TAB_PARM3_SC_SCRE := 113 
STATIC DEFINE TAB_PARM3_SC_SDEB := 108 
STATIC DEFINE TAB_PARM3_SC_SPOSTZ := 102 
RESOURCE Tab_Parm4 DIALOGEX  16, 14, 212, 141
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TAB_PARM4_MDONORS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 108, 19, 83, 12, WS_EX_CLIENTEDGE
	CONTROL	"", TAB_PARM4_MPROJECTS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 108, 32, 83, 12, WS_EX_CLIENTEDGE
	CONTROL	"Acc nbr non-designated gifts:", TAB_PARM4_SC_SPROJ, "Static", WS_CHILD, 12, 33, 96, 12
	CONTROL	"Account number Donors:", TAB_PARM4_SC_SDON, "Static", WS_CHILD, 12, 19, 81, 12
	CONTROL	"Gifts", TAB_PARM4_GROUPBOX4, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 6, 10, 202, 119
	CONTROL	"v", TAB_PARM4_PROJECTSBUTTON, "Button", WS_TABSTOP|WS_CHILD, 189, 32, 15, 12
	CONTROL	"v", TAB_PARM4_DONORSBUTTON, "Button", WS_CHILD, 189, 18, 15, 12
	CONTROL	"Length of decimal fraction:", TAB_PARM4_FIXEDTEXT2, "Static", WS_CHILD, 13, 49, 87, 13
	CONTROL	"", TAB_PARM4_MDECIMALGIFTREPORT, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 108, 48, 83, 12, WS_EX_CLIENTEDGE
END

CLASS Tab_Parm4 INHERIT DataWindowMine 

	PROTECT oDCmDONORS AS SINGLELINEEDIT
	PROTECT oDCmPROJECTS AS SINGLELINEEDIT
	PROTECT oDCSC_SPROJ AS FIXEDTEXT
	PROTECT oDCSC_SDON AS FIXEDTEXT
	PROTECT oDCGroupBox4 AS GROUPBOX
	PROTECT oCCProjectsButton AS PUSHBUTTON
	PROTECT oCCDonorsButton AS PUSHBUTTON
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCmDecimalGiftreport AS SINGLELINEEDIT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
    EXPORT cPROJECTSName, cDONORSName as STRING
  	EXPORT NbrPROJECTS, NbrDONORS as STRING
  	EXPORT cSoortPROJECTS, cSoortDONORS as STRING
   protect oSys as SQLSelect
METHOD DonorsButton(lUnique ) CLASS Tab_Parm4
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrDONORS},{INCOME,liability},"B",1)
	AccountSelect(self:Owner,AllTrim(oDCmDONORS:TEXTValue ),"Donors",lUnique,cfilter)

	RETURN nil
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS Tab_Parm4
	LOCAL oControl as Control
	LOCAL lGotFocus as LOGIC
	oControl := iif(oEditFocusChangeEvent == null_object, null_object, oEditFocusChangeEvent:Control)
	lGotFocus := iif(oEditFocusChangeEvent == null_object, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "MDONORS".and.!AllTrim(oControl:VALUE)==AllTrim(cDONORSName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrDONORS := "  "
				self:cDONORSName := ""
				self:oDCmDONORS:TEXTValue := ""
            ELSE
				cDONORSName:=AllTrim(oControl:VALUE)
				self:DONORSButton(true)
			ENDIF
		ELSEIF oControl:Name == "MPROJECTS".and.!AllTrim(oControl:VALUE)==AllTrim(cPROJECTSName)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrPROJECTS := "  "
				self:cPROJECTSName := ""
				self:oDCmPROJECTS:TEXTValue := ""
            ELSE
				cPROJECTSName:=AllTrim(oControl:VALUE)
				self:PROJECTSButton(true)
			ENDIF
		ENDIF
	ENDIF
	RETURN nil

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS Tab_Parm4 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"Tab_Parm4",_GetInst()},iCtlID)

oDCmDONORS := SingleLineEdit{SELF,ResourceID{TAB_PARM4_MDONORS,_GetInst()}}
oDCmDONORS:HyperLabel := HyperLabel{#mDONORS,NULL_STRING,"Accountnumber for donors",NULL_STRING}
oDCmDONORS:FieldSpec := MEMBERACCOUNT{}

oDCmPROJECTS := SingleLineEdit{SELF,ResourceID{TAB_PARM4_MPROJECTS,_GetInst()}}
oDCmPROJECTS:HyperLabel := HyperLabel{#mPROJECTS,NULL_STRING,"Accountnumer for non-earmarked gifts",NULL_STRING}
oDCmPROJECTS:FieldSpec := MEMBERACCOUNT{}

oDCSC_SPROJ := FixedText{SELF,ResourceID{TAB_PARM4_SC_SPROJ,_GetInst()}}
oDCSC_SPROJ:HyperLabel := HyperLabel{#SC_SPROJ,"Acc nbr non-designated gifts:",NULL_STRING,NULL_STRING}

oDCSC_SDON := FixedText{SELF,ResourceID{TAB_PARM4_SC_SDON,_GetInst()}}
oDCSC_SDON:HyperLabel := HyperLabel{#SC_SDON,"Account number Donors:",NULL_STRING,NULL_STRING}

oDCGroupBox4 := GroupBox{SELF,ResourceID{TAB_PARM4_GROUPBOX4,_GetInst()}}
oDCGroupBox4:HyperLabel := HyperLabel{#GroupBox4,"Gifts",NULL_STRING,NULL_STRING}

oCCProjectsButton := PushButton{SELF,ResourceID{TAB_PARM4_PROJECTSBUTTON,_GetInst()}}
oCCProjectsButton:HyperLabel := HyperLabel{#ProjectsButton,"v","Browse in accounts",NULL_STRING}
oCCProjectsButton:TooltipText := "Browse in accounts"

oCCDonorsButton := PushButton{SELF,ResourceID{TAB_PARM4_DONORSBUTTON,_GetInst()}}
oCCDonorsButton:HyperLabel := HyperLabel{#DonorsButton,"v","Browse in accounts",NULL_STRING}
oCCDonorsButton:TooltipText := "Browse in accounts"

oDCFixedText2 := FixedText{SELF,ResourceID{TAB_PARM4_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Length of decimal fraction:",NULL_STRING,NULL_STRING}

oDCmDecimalGiftreport := SingleLineEdit{SELF,ResourceID{TAB_PARM4_MDECIMALGIFTREPORT,_GetInst()}}
oDCmDecimalGiftreport:HyperLabel := HyperLabel{#mDecimalGiftreport,NULL_STRING,"Length decimal fraction",NULL_STRING}
oDCmDecimalGiftreport:TooltipText := "Number of position behind decimal point on Gifts report"
oDCmDecimalGiftreport:Picture := "9"

SELF:Caption := "Gifts"
SELF:HyperLabel := HyperLabel{#Tab_Parm4,"Gifts",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mDecimalGiftreport() CLASS Tab_Parm4
RETURN SELF:FieldGet(#mDecimalGiftreport)

ASSIGN mDecimalGiftreport(uValue) CLASS Tab_Parm4
SELF:FieldPut(#mDecimalGiftreport, uValue)
RETURN uValue

ACCESS mDONORS() CLASS Tab_Parm4
RETURN SELF:FieldGet(#mDONORS)

ASSIGN mDONORS(uValue) CLASS Tab_Parm4
SELF:FieldPut(#mDONORS, uValue)
RETURN uValue

ACCESS mPROJECTS() CLASS Tab_Parm4
RETURN SELF:FieldGet(#mPROJECTS)

ASSIGN mPROJECTS(uValue) CLASS Tab_Parm4
SELF:FieldPut(#mPROJECTS, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS Tab_Parm4
	//Put your PostInit additions here
	LOCAL oAcc as SQLSelect
self:SetTexts()
IF !Empty(self:oSys:DONORS)
	oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:DONORS,-1),oConn}
	IF oAcc:RecCount>0
		self:NbrDONORS :=  Str(oAcc:accid,-1)
		self:oDCmDONORS:TEXTValue := AllTrim(oAcc:Description)
		self:cDONORSName := AllTrim(oAcc:Description)
		self:cSoortDONORS:=oAcc:TYPE
	ENDIF		
ENDIF
IF !Empty(self:oSys:PROJECTS)
	oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid="+Str(self:oSys:PROJECTS,-1),oConn}
	IF oAcc:RecCount>0
		self:NbrPROJECTS :=  Str(oAcc:accid,-1)
		self:oDCmPROJECTS:TEXTValue := AllTrim(oAcc:Description)
		self:cPROJECTSName := AllTrim(oAcc:Description)
		self:cSoortPROJECTS:=oAcc:TYPE
	ENDIF		
ENDIF
self:mDecimalGiftreport:=self:oSys:DECMGIFT
RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class Tab_Parm4
	//Put your PreInit additions here
	self:oSys:=oWindow:oSys
	return nil

METHOD ProjectsButton(lUnique ) CLASS Tab_Parm4
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrPROJECTS},{INCOME,liability},"N",1)
	AccountSelect(self:Owner,AllTrim(self:oDCmPROJECTS:TEXTValue ),"Non earmarked Gifts",lUnique,cfilter)
	RETURN nil
STATIC DEFINE TAB_PARM4_DONORSBUTTON := 106 
STATIC DEFINE TAB_PARM4_FIXEDTEXT2 := 107 
STATIC DEFINE TAB_PARM4_GROUPBOX4 := 104 
STATIC DEFINE TAB_PARM4_MDECIMALGIFTREPORT := 108 
STATIC DEFINE TAB_PARM4_MDONORS := 100 
STATIC DEFINE TAB_PARM4_MPROJECTS := 101 
STATIC DEFINE TAB_PARM4_PROJECTSBUTTON := 105 
STATIC DEFINE TAB_PARM4_SC_SDON := 103 
STATIC DEFINE TAB_PARM4_SC_SPROJ := 102 
RESOURCE Tab_Parm5 DIALOGEX  20, 18, 259, 235
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Firstname in address", TAB_PARM5_FIRSTNAME, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 16, 11, 79, 12
	CONTROL	"", TAB_PARM5_CITYLETTER, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 77, 108, 12, WS_EX_CLIENTEDGE
	CONTROL	"", TAB_PARM5_MCOD1, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 21, 140, 61, 72
	CONTROL	"", TAB_PARM5_MCOD2, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 85, 140, 61, 72
	CONTROL	"", TAB_PARM5_MCOD3, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 149, 140, 61, 72
	CONTROL	"Default mailing codes for new persons", TAB_PARM5_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 16, 129, 205, 31
	CONTROL	"City name in heading letters:", TAB_PARM5_FIXEDTEXT1, "Static", WS_CHILD, 16, 77, 96, 12
	CONTROL	"Salutation in address", TAB_PARM5_SALUTADDR, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 16, 24, 80, 12
	CONTROL	"Names used for your own country (seperated by ,)", TAB_PARM5_FIXEDTEXT2, "Static", WS_CHILD, 16, 94, 94, 20
	CONTROL	"", TAB_PARM5_MOWNCNTRY, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 111, 97, 109, 12, WS_EX_CLIENTEDGE
	CONTROL	"Starting with surname in address", TAB_PARM5_SURNMFIRST, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 112, 9, 111, 11
	CONTROL	"", TAB_PARM5_STRZIPCITY, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 111, 59, 109, 51
	CONTROL	"Sequence within address:", TAB_PARM5_FIXEDTEXT3, "Static", WS_CHILD, 16, 59, 92, 12
	CONTROL	"", TAB_PARM5_MFGCOD3, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 148, 173, 61, 72
	CONTROL	"", TAB_PARM5_MFGCOD2, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 84, 173, 61, 72
	CONTROL	"", TAB_PARM5_MFGCOD1, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 20, 173, 61, 72
	CONTROL	"Mailing codes for first givers", TAB_PARM5_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 16, 162, 204, 31
	CONTROL	"City name in uppercase characters", TAB_PARM5_CITYNMUPC, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 112, 25, 124, 11
	CONTROL	"Last name in uppercase characters", TAB_PARM5_LSTNMUPC, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 112, 40, 124, 11
	CONTROL	"Title in address", TAB_PARM5_TITINADR, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 16, 40, 79, 12
	CONTROL	"Email Client:", TAB_PARM5_FIXEDTEXT4, "Static", WS_CHILD, 16, 115, 54, 12
	CONTROL	"", TAB_PARM5_MAILCLIENT, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 112, 111, 108, 72
END

CLASS Tab_Parm5 INHERIT DataWindowMine 

	PROTECT oDCFIRSTNAME AS CHECKBOX
	PROTECT oDCCITYLETTER AS SINGLELINEEDIT
	PROTECT oDCmCod1 AS COMBOBOX
	PROTECT oDCmCod2 AS COMBOBOX
	PROTECT oDCmCod3 AS COMBOBOX
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCSALUTADDR AS CHECKBOX
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCmOwnCntry AS SINGLELINEEDIT
	PROTECT oDCSURNMFIRST AS CHECKBOX
	PROTECT oDCSTRZIPCITY AS COMBOBOX
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCmFGCod3 AS COMBOBOX
	PROTECT oDCmFGCod2 AS COMBOBOX
	PROTECT oDCmFGCod1 AS COMBOBOX
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCCITYNMUPC AS CHECKBOX
	PROTECT oDCLSTNMUPC AS CHECKBOX
	PROTECT oDCTITINADR AS CHECKBOX
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCMailClient AS COMBOBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
//   	
  	EXPORT INSTANCE mCod4 := ""
	EXPORT INSTANCE mCod5 := ""
	EXPORT INSTANCE mCod6 := ""
   protect oSys as SQLSelect
ACCESS CITYLETTER() CLASS Tab_Parm5
RETURN SELF:FieldGet(#CITYLETTER)

ASSIGN CITYLETTER(uValue) CLASS Tab_Parm5
SELF:FieldPut(#CITYLETTER, uValue)
RETURN uValue

ACCESS CITYNMUPC() CLASS Tab_Parm5
RETURN SELF:FieldGet(#CITYNMUPC)

ASSIGN CITYNMUPC(uValue) CLASS Tab_Parm5
SELF:FieldPut(#CITYNMUPC, uValue)
RETURN uValue

METHOD FillAddrTypes() CLASS Tab_Parm5
	RETURN {{"address, zip, city, country", 0},{"zip,city, address, country",1},{"country, zip city, address",2},{"address, city, zip, country",3}}
	

ACCESS FIRSTNAME() CLASS Tab_Parm5
RETURN SELF:FieldGet(#FIRSTNAME)

ASSIGN FIRSTNAME(uValue) CLASS Tab_Parm5
SELF:FieldPut(#FIRSTNAME, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS Tab_Parm5 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"Tab_Parm5",_GetInst()},iCtlID)

oDCFIRSTNAME := CheckBox{SELF,ResourceID{TAB_PARM5_FIRSTNAME,_GetInst()}}
oDCFIRSTNAME:HyperLabel := HyperLabel{#FIRSTNAME,"Firstname in address","Firstname in address","Sysparms_SVOORNAAM"}

oDCCITYLETTER := SingleLineEdit{SELF,ResourceID{TAB_PARM5_CITYLETTER,_GetInst()}}
oDCCITYLETTER:HyperLabel := HyperLabel{#CITYLETTER,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmCod1 := combobox{SELF,ResourceID{TAB_PARM5_MCOD1,_GetInst()}}
oDCmCod1:HyperLabel := HyperLabel{#mCod1,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod1:FillUsing(pers_codes)

oDCmCod2 := combobox{SELF,ResourceID{TAB_PARM5_MCOD2,_GetInst()}}
oDCmCod2:HyperLabel := HyperLabel{#mCod2,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod2:FillUsing(pers_codes)

oDCmCod3 := combobox{SELF,ResourceID{TAB_PARM5_MCOD3,_GetInst()}}
oDCmCod3:HyperLabel := HyperLabel{#mCod3,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod3:FillUsing(pers_codes)

oDCGroupBox1 := GroupBox{SELF,ResourceID{TAB_PARM5_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Default mailing codes for new persons",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{TAB_PARM5_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"City name in heading letters:",NULL_STRING,NULL_STRING}

oDCSALUTADDR := CheckBox{SELF,ResourceID{TAB_PARM5_SALUTADDR,_GetInst()}}
oDCSALUTADDR:HyperLabel := HyperLabel{#SALUTADDR,"Salutation in address","Salutation in address",NULL_STRING}
oDCSALUTADDR:TooltipText := "Should salutation and titles be shown in addresses (e.g. lables)"

oDCFixedText2 := FixedText{SELF,ResourceID{TAB_PARM5_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Names used for your own country (seperated by ,)",NULL_STRING,NULL_STRING}

oDCmOwnCntry := SingleLineEdit{SELF,ResourceID{TAB_PARM5_MOWNCNTRY,_GetInst()}}
oDCmOwnCntry:HyperLabel := HyperLabel{#mOwnCntry,NULL_STRING,"Used for suppressing printing of own country names within addresses",NULL_STRING}
oDCmOwnCntry:UseHLforToolTip := True

oDCSURNMFIRST := CheckBox{SELF,ResourceID{TAB_PARM5_SURNMFIRST,_GetInst()}}
oDCSURNMFIRST:HyperLabel := HyperLabel{#SURNMFIRST,"Starting with surname in address","Starting with surname in address followed by firstname",NULL_STRING}
oDCSURNMFIRST:UseHLforToolTip := True

oDCSTRZIPCITY := combobox{SELF,ResourceID{TAB_PARM5_STRZIPCITY,_GetInst()}}
oDCSTRZIPCITY:HyperLabel := HyperLabel{#STRZIPCITY,NULL_STRING,"Configuration of address",NULL_STRING}
oDCSTRZIPCITY:UseHLforToolTip := True
oDCSTRZIPCITY:FillUsing(Self:FillAddrTypes( ))

oDCFixedText3 := FixedText{SELF,ResourceID{TAB_PARM5_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Sequence within address:",NULL_STRING,NULL_STRING}

oDCmFGCod3 := combobox{SELF,ResourceID{TAB_PARM5_MFGCOD3,_GetInst()}}
oDCmFGCod3:HyperLabel := HyperLabel{#mFGCod3,NULL_STRING,"Mailing code",NULL_STRING}
oDCmFGCod3:FillUsing(pers_codes)

oDCmFGCod2 := combobox{SELF,ResourceID{TAB_PARM5_MFGCOD2,_GetInst()}}
oDCmFGCod2:HyperLabel := HyperLabel{#mFGCod2,NULL_STRING,"Mailing code",NULL_STRING}
oDCmFGCod2:FillUsing(pers_codes)

oDCmFGCod1 := combobox{SELF,ResourceID{TAB_PARM5_MFGCOD1,_GetInst()}}
oDCmFGCod1:HyperLabel := HyperLabel{#mFGCod1,NULL_STRING,"Mailing code",NULL_STRING}
oDCmFGCod1:FillUsing(pers_codes)

oDCGroupBox2 := GroupBox{SELF,ResourceID{TAB_PARM5_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Mailing codes for first givers","These codes will be assigned to a person at his first gift",NULL_STRING}
oDCGroupBox2:UseHLforToolTip := True

oDCCITYNMUPC := CheckBox{SELF,ResourceID{TAB_PARM5_CITYNMUPC,_GetInst()}}
oDCCITYNMUPC:HyperLabel := HyperLabel{#CITYNMUPC,"City name in uppercase characters",NULL_STRING,NULL_STRING}

oDCLSTNMUPC := CheckBox{SELF,ResourceID{TAB_PARM5_LSTNMUPC,_GetInst()}}
oDCLSTNMUPC:HyperLabel := HyperLabel{#LSTNMUPC,"Last name in uppercase characters",NULL_STRING,NULL_STRING}

oDCTITINADR := CheckBox{SELF,ResourceID{TAB_PARM5_TITINADR,_GetInst()}}
oDCTITINADR:HyperLabel := HyperLabel{#TITINADR,"Title in address","Title in address",NULL_STRING}
oDCTITINADR:TooltipText := "Should titles be shown in addresses (e.g. lables)"

oDCFixedText4 := FixedText{SELF,ResourceID{TAB_PARM5_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Email Client:",NULL_STRING,NULL_STRING}

oDCMailClient := combobox{SELF,ResourceID{TAB_PARM5_MAILCLIENT,_GetInst()}}
oDCMailClient:TooltipText := "Email program used for emailing PMC file or Gift reports, etc."
oDCMailClient:FillUsing({{"Windows Mail/ Outlook Express",0},{"Microsoft Outlook",1},{"Mozilla Thunderbird",2},{"Windows Live Mail",3},{"Mapi2Xml",4}})
oDCMailClient:HyperLabel := HyperLabel{#MailClient,NULL_STRING,NULL_STRING,NULL_STRING}

SELF:Caption := "Mailing"
SELF:HyperLabel := HyperLabel{#Tab_Parm5,"Mailing",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
SELF:ViewAs(#FormView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS LSTNMUPC() CLASS Tab_Parm5
RETURN SELF:FieldGet(#LSTNMUPC)

ASSIGN LSTNMUPC(uValue) CLASS Tab_Parm5
SELF:FieldPut(#LSTNMUPC, uValue)
RETURN uValue

ACCESS MailClient() CLASS Tab_Parm5
RETURN SELF:FieldGet(#MailClient)

ASSIGN MailClient(uValue) CLASS Tab_Parm5
SELF:FieldPut(#MailClient, uValue)
RETURN uValue

ACCESS mCod1() CLASS Tab_Parm5
RETURN SELF:FieldGet(#mCod1)

ASSIGN mCod1(uValue) CLASS Tab_Parm5
SELF:FieldPut(#mCod1, uValue)
RETURN uValue

ACCESS mCod2() CLASS Tab_Parm5
RETURN SELF:FieldGet(#mCod2)

ASSIGN mCod2(uValue) CLASS Tab_Parm5
SELF:FieldPut(#mCod2, uValue)
RETURN uValue

ACCESS mCod3() CLASS Tab_Parm5
RETURN SELF:FieldGet(#mCod3)

ASSIGN mCod3(uValue) CLASS Tab_Parm5
SELF:FieldPut(#mCod3, uValue)
RETURN uValue

ACCESS mFGCod1() CLASS Tab_Parm5
RETURN SELF:FieldGet(#mFGCod1)

ASSIGN mFGCod1(uValue) CLASS Tab_Parm5
SELF:FieldPut(#mFGCod1, uValue)
RETURN uValue

ACCESS mFGCod2() CLASS Tab_Parm5
RETURN SELF:FieldGet(#mFGCod2)

ASSIGN mFGCod2(uValue) CLASS Tab_Parm5
SELF:FieldPut(#mFGCod2, uValue)
RETURN uValue

ACCESS mFGCod3() CLASS Tab_Parm5
RETURN SELF:FieldGet(#mFGCod3)

ASSIGN mFGCod3(uValue) CLASS Tab_Parm5
SELF:FieldPut(#mFGCod3, uValue)
RETURN uValue

ACCESS mOwnCntry() CLASS Tab_Parm5
RETURN SELF:FieldGet(#mOwnCntry)

ASSIGN mOwnCntry(uValue) CLASS Tab_Parm5
SELF:FieldPut(#mOwnCntry, uValue)
RETURN uValue

METHOD PostInit() CLASS Tab_Parm5
	//Put your PostInit additions here
self:SetTexts()
	IF!Empty(self:oSys:DefaultCOD)
		self:mCOD1  := if(Empty(SubStr(self:oSys:DefaultCOD,1,2)),nil,SubStr(self:oSys:DefaultCOD,1,2))
		self:mCOD2  := if(Empty(SubStr(self:oSys:DefaultCOD,4,2)),nil,SubStr(self:oSys:DefaultCOD,4,2))
		self:mCOD3  := if(Empty(SubStr(self:oSys:DefaultCOD,7,2)),nil,SubStr(self:oSys:DefaultCOD,7,2))
	ENDIF
	IF!Empty(self:oSys:FGMLCODES)
		self:mFGCod1  := if(Empty(SubStr(self:oSys:FGMLCODES,1,2)),nil,SubStr(self:oSys:FGMLCODES,1,2))
		self:mFGCod2  := if(Empty(SubStr(self:oSys:FGMLCODES,4,2)),nil,SubStr(self:oSys:FGMLCODES,4,2))
		self:mFGCod3  := if(Empty(SubStr(self:oSys:FGMLCODES,7,2)),nil,SubStr(self:oSys:FGMLCODES,7,2))
	ENDIF
	self:SALUTADDR:=!ConL(ConI(self:oSys:NOSALUT))
	self:mOwnCntry :=self:oSys:OwnCntry
	self:FIRSTNAME:=ConL(self:oSys:FIRSTNAME) 
	self:CITYLETTER:=self:oSys:CITYLETTER 
	self:SURNMFIRST:=ConL(self:oSys:SURNMFIRST) 
	self:STRZIPCITY:=ConI(self:oSys:STRZIPCITY)
	self:CITYNMUPC:=ConL(self:oSys:CITYNMUPC)
	self:LSTNMUPC:=ConL(self:oSys:LSTNMUPC) 
	self:TITINADR:=ConL(self:oSys:TITINADR) 
	self:MailClient:=ConI(self:oSys:MailClient)
RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class Tab_Parm5
	//Put your PreInit additions here
	self:oSys:=oWindow:oSys
	RETURN nil

ACCESS SALUTADDR() CLASS Tab_Parm5
RETURN SELF:FieldGet(#SALUTADDR)

ASSIGN SALUTADDR(uValue) CLASS Tab_Parm5
SELF:FieldPut(#SALUTADDR, uValue)
RETURN uValue

ACCESS STRZIPCITY() CLASS Tab_Parm5
RETURN SELF:FieldGet(#STRZIPCITY)

ASSIGN STRZIPCITY(uValue) CLASS Tab_Parm5
SELF:FieldPut(#STRZIPCITY, uValue)
RETURN uValue

ACCESS SURNMFIRST() CLASS Tab_Parm5
RETURN SELF:FieldGet(#SURNMFIRST)

ASSIGN SURNMFIRST(uValue) CLASS Tab_Parm5
SELF:FieldPut(#SURNMFIRST, uValue)
RETURN uValue

ACCESS TITINADR() CLASS Tab_Parm5
RETURN SELF:FieldGet(#TITINADR)

ASSIGN TITINADR(uValue) CLASS Tab_Parm5
SELF:FieldPut(#TITINADR, uValue)
RETURN uValue

STATIC DEFINE TAB_PARM5_CITYLETTER := 101 
STATIC DEFINE TAB_PARM5_CITYNMUPC := 117 
STATIC DEFINE TAB_PARM5_FIRSTNAME := 100 
STATIC DEFINE TAB_PARM5_FIXEDTEXT1 := 106 
STATIC DEFINE TAB_PARM5_FIXEDTEXT2 := 108 
STATIC DEFINE TAB_PARM5_FIXEDTEXT3 := 112 
STATIC DEFINE TAB_PARM5_FIXEDTEXT4 := 120 
STATIC DEFINE TAB_PARM5_GROUPBOX1 := 105 
STATIC DEFINE TAB_PARM5_GROUPBOX2 := 116 
STATIC DEFINE TAB_PARM5_LSTNMUPC := 118 
STATIC DEFINE TAB_PARM5_MAILCLIENT := 121 
STATIC DEFINE TAB_PARM5_MCOD1 := 102 
STATIC DEFINE TAB_PARM5_MCOD2 := 103 
STATIC DEFINE TAB_PARM5_MCOD3 := 104 
STATIC DEFINE TAB_PARM5_MFGCOD1 := 115 
STATIC DEFINE TAB_PARM5_MFGCOD2 := 114 
STATIC DEFINE TAB_PARM5_MFGCOD3 := 113 
STATIC DEFINE TAB_PARM5_MOWNCNTRY := 109 
STATIC DEFINE TAB_PARM5_SALUTADDR := 107 
STATIC DEFINE TAB_PARM5_STRZIPCITY := 111 
STATIC DEFINE TAB_PARM5_SURNMFIRST := 110 
STATIC DEFINE TAB_PARM5_TITINADR := 119 
CLASS TAB_PARM6 INHERIT DataWindowMine 

	PROTECT oDCSC_TOPMARGIN AS FIXEDTEXT
	PROTECT oDCSC_LEFTMARGIN AS FIXEDTEXT
	PROTECT oDCSC_RIGHTMARGN AS FIXEDTEXT
	PROTECT oDCSC_BOTTOMMARG AS FIXEDTEXT
	PROTECT oDCTOPMARGIN AS SINGLELINEEDIT
	PROTECT oDCLEFTMARGIN AS SINGLELINEEDIT
	PROTECT oDCRIGHTMARGN AS SINGLELINEEDIT
	PROTECT oDCBOTTOMMARG AS SINGLELINEEDIT
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCFixedText8 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
   protect oSys as SQLSelect
RESOURCE TAB_PARM6 DIALOGEX  4, 4, 185, 105
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Top Margin:", TAB_PARM6_SC_TOPMARGIN, "Static", WS_CHILD, 13, 30, 40, 13
	CONTROL	"Left Margin:", TAB_PARM6_SC_LEFTMARGIN, "Static", WS_CHILD, 13, 46, 39, 12
	CONTROL	"Right Margin:", TAB_PARM6_SC_RIGHTMARGN, "Static", WS_CHILD, 13, 61, 44, 12
	CONTROL	"Bottom Margin:", TAB_PARM6_SC_BOTTOMMARG, "Static", WS_CHILD, 13, 76, 49, 13
	CONTROL	"Top Margin:", TAB_PARM6_TOPMARGIN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 93, 30, 29, 12
	CONTROL	"Left Margin:", TAB_PARM6_LEFTMARGIN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 93, 45, 29, 12
	CONTROL	"Right Margin:", TAB_PARM6_RIGHTMARGN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 93, 60, 29, 13
	CONTROL	"Bottom Margin:", TAB_PARM6_BOTTOMMARG, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 93, 76, 29, 12
	CONTROL	"mm", TAB_PARM6_FIXEDTEXT5, "Static", WS_CHILD, 134, 30, 54, 13
	CONTROL	"mm", TAB_PARM6_FIXEDTEXT6, "Static", WS_CHILD, 134, 46, 20, 12
	CONTROL	"mm", TAB_PARM6_FIXEDTEXT7, "Static", WS_CHILD, 134, 61, 20, 12
	CONTROL	"mm", TAB_PARM6_FIXEDTEXT8, "Static", WS_CHILD, 134, 76, 20, 13
END

ACCESS BOTTOMMARG() CLASS TAB_PARM6
RETURN SELF:FieldGet(#BOTTOMMARG)

ASSIGN BOTTOMMARG(uValue) CLASS TAB_PARM6
SELF:FieldPut(#BOTTOMMARG, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TAB_PARM6 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TAB_PARM6",_GetInst()},iCtlID)

oDCSC_TOPMARGIN := FixedText{SELF,ResourceID{TAB_PARM6_SC_TOPMARGIN,_GetInst()}}
oDCSC_TOPMARGIN:HyperLabel := HyperLabel{#SC_TOPMARGIN,"Top Margin:",NULL_STRING,NULL_STRING}

oDCSC_LEFTMARGIN := FixedText{SELF,ResourceID{TAB_PARM6_SC_LEFTMARGIN,_GetInst()}}
oDCSC_LEFTMARGIN:HyperLabel := HyperLabel{#SC_LEFTMARGIN,"Left Margin:",NULL_STRING,NULL_STRING}

oDCSC_RIGHTMARGN := FixedText{SELF,ResourceID{TAB_PARM6_SC_RIGHTMARGN,_GetInst()}}
oDCSC_RIGHTMARGN:HyperLabel := HyperLabel{#SC_RIGHTMARGN,"Right Margin:",NULL_STRING,NULL_STRING}

oDCSC_BOTTOMMARG := FixedText{SELF,ResourceID{TAB_PARM6_SC_BOTTOMMARG,_GetInst()}}
oDCSC_BOTTOMMARG:HyperLabel := HyperLabel{#SC_BOTTOMMARG,"Bottom Margin:",NULL_STRING,NULL_STRING}

oDCTOPMARGIN := SingleLineEdit{SELF,ResourceID{TAB_PARM6_TOPMARGIN,_GetInst()}}
oDCTOPMARGIN:FieldSpec := Sysparms_TopMargin{}
oDCTOPMARGIN:HyperLabel := HyperLabel{#TOPMARGIN,"Top Margin:","Top margin of a report in mm","Sysparms_TopMargin"}

oDCLEFTMARGIN := SingleLineEdit{SELF,ResourceID{TAB_PARM6_LEFTMARGIN,_GetInst()}}
oDCLEFTMARGIN:FieldSpec := Sysparms_LeftMargin{}
oDCLEFTMARGIN:HyperLabel := HyperLabel{#LEFTMARGIN,"Left Margin:","Left margin of a repprt in mm","Sysparms_LeftMargin"}

oDCRIGHTMARGN := SingleLineEdit{SELF,ResourceID{TAB_PARM6_RIGHTMARGN,_GetInst()}}
oDCRIGHTMARGN:FieldSpec := Sysparms_RightMargn{}
oDCRIGHTMARGN:HyperLabel := HyperLabel{#RIGHTMARGN,"Right Margin:","Right margin of a report in mm","Sysparms_RightMargn"}

oDCBOTTOMMARG := SingleLineEdit{SELF,ResourceID{TAB_PARM6_BOTTOMMARG,_GetInst()}}
oDCBOTTOMMARG:FieldSpec := Sysparms_BottomMarg{}
oDCBOTTOMMARG:HyperLabel := HyperLabel{#BOTTOMMARG,"Bottom Margin:","Bottom margin of a report in mm","Sysparms_BottomMarg"}

oDCFixedText5 := FixedText{SELF,ResourceID{TAB_PARM6_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"mm",NULL_STRING,NULL_STRING}

oDCFixedText6 := FixedText{SELF,ResourceID{TAB_PARM6_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"mm",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{TAB_PARM6_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"mm",NULL_STRING,NULL_STRING}

oDCFixedText8 := FixedText{SELF,ResourceID{TAB_PARM6_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"mm",NULL_STRING,NULL_STRING}

SELF:Caption := ""
SELF:HyperLabel := HyperLabel{#TAB_PARM6,NULL_STRING,NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS LEFTMARGIN() CLASS TAB_PARM6
RETURN SELF:FieldGet(#LEFTMARGIN)

ASSIGN LEFTMARGIN(uValue) CLASS TAB_PARM6
SELF:FieldPut(#LEFTMARGIN, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class TAB_PARM6
	//Put your PostInit additions here
	self:TOPMARGIN:=ConI(self:oSys:TOPMARGIN)
	self:leftmargin:=ConI(self:oSys:leftmargin)           
	self:rightmargn:=ConI(self:oSys:rightmargn)
	self:bottommarg:=ConI(self:oSys:bottommarg)	
	return nil

method PreInit(oWindow,iCtlID,oServer,uExtra) class TAB_PARM6
	//Put your PreInit additions here
	self:oSys:=oWindow:oSys
	return nil

ACCESS RIGHTMARGN() CLASS TAB_PARM6
RETURN SELF:FieldGet(#RIGHTMARGN)

ASSIGN RIGHTMARGN(uValue) CLASS TAB_PARM6
SELF:FieldPut(#RIGHTMARGN, uValue)
RETURN uValue

ACCESS TOPMARGIN() CLASS TAB_PARM6
RETURN SELF:FieldGet(#TOPMARGIN)

ASSIGN TOPMARGIN(uValue) CLASS TAB_PARM6
SELF:FieldPut(#TOPMARGIN, uValue)
RETURN uValue

STATIC DEFINE TAB_PARM6_BOTTOMMARG := 107 
STATIC DEFINE TAB_PARM6_FIXEDTEXT5 := 108 
STATIC DEFINE TAB_PARM6_FIXEDTEXT6 := 109 
STATIC DEFINE TAB_PARM6_FIXEDTEXT7 := 110 
STATIC DEFINE TAB_PARM6_FIXEDTEXT8 := 111 
STATIC DEFINE TAB_PARM6_LEFTMARGIN := 105 
STATIC DEFINE TAB_PARM6_RIGHTMARGN := 106 
STATIC DEFINE TAB_PARM6_SC_BOTTOMMARG := 103 
STATIC DEFINE TAB_PARM6_SC_LEFTMARGIN := 101 
STATIC DEFINE TAB_PARM6_SC_RIGHTMARGN := 102 
STATIC DEFINE TAB_PARM6_SC_TOPMARGIN := 100 
STATIC DEFINE TAB_PARM6_TOPMARGIN := 104 
STATIC DEFINE TAB_PARM7_OWNMAILACC := 102 
STATIC DEFINE TAB_PARM7_SC_OWNMAILACC := 100 
STATIC DEFINE TAB_PARM7_SC_SMTPSERVER := 101 
STATIC DEFINE TAB_PARM7_SMTPSERVER := 103 
RESOURCE TABPARM_PAGE7 DIALOGEX  12, 11, 254, 135
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Maximum duration:", TABPARM_PAGE7_FIXEDTEXT1, "Static", WS_CHILD, 10, 33, 71, 12
	CONTROL	"", TABPARM_PAGE7_MPSWDURA, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 84, 33, 53, 12, WS_EX_CLIENTEDGE
	CONTROL	"days", TABPARM_PAGE7_FIXEDTEXT2, "Static", WS_CHILD, 147, 33, 22, 13
	CONTROL	"Minimum length:", TABPARM_PAGE7_FIXEDTEXT3, "Static", WS_CHILD, 10, 51, 54, 12
	CONTROL	"", TABPARM_PAGE7_MPSWRDLEN, "Edit", ES_AUTOHSCROLL|ES_NUMBER|WS_TABSTOP|WS_CHILD|WS_BORDER, 84, 48, 53, 12, WS_EX_CLIENTEDGE
	CONTROL	"Mixture of alphabetic and numerics", TABPARM_PAGE7_MPSWALNUM, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 84, 66, 144, 11
	CONTROL	"Password properties:", TABPARM_PAGE7_FIXEDTEXT4, "Static", SS_CENTER|WS_CHILD, 10, 9, 210, 13
END

CLASS TABPARM_PAGE7 INHERIT DataWindowMine 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCmPSWDURA AS SINGLELINEEDIT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCmPSWRDLEN AS SINGLELINEEDIT
	PROTECT oDCmPSWALNUM AS CHECKBOX
	PROTECT oDCFixedText4 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
   protect oSys as SQLSelect
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TABPARM_PAGE7 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TABPARM_PAGE7",_GetInst()},iCtlID)

oDCFixedText1 := FixedText{SELF,ResourceID{TABPARM_PAGE7_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Maximum duration:",NULL_STRING,NULL_STRING}

oDCmPSWDURA := SingleLineEdit{SELF,ResourceID{TABPARM_PAGE7_MPSWDURA,_GetInst()}}
oDCmPSWDURA:TooltipText := "Maximum time in days before a password must be changed"
oDCmPSWDURA:HyperLabel := HyperLabel{#mPSWDURA,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmPSWDURA:FieldSpec := Sysparms_PSWDURA{}
oDCmPSWDURA:Picture := "999"

oDCFixedText2 := FixedText{SELF,ResourceID{TABPARM_PAGE7_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"days",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{TABPARM_PAGE7_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Minimum length:",NULL_STRING,NULL_STRING}

oDCmPSWRDLEN := SingleLineEdit{SELF,ResourceID{TABPARM_PAGE7_MPSWRDLEN,_GetInst()}}
oDCmPSWRDLEN:TooltipText := "Minimum length of a  password"
oDCmPSWRDLEN:HyperLabel := HyperLabel{#mPSWRDLEN,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmPSWRDLEN:FieldSpec := Sysparms_PSWRDLEN{}
oDCmPSWRDLEN:Picture := "99"

oDCmPSWALNUM := CheckBox{SELF,ResourceID{TABPARM_PAGE7_MPSWALNUM,_GetInst()}}
oDCmPSWALNUM:HyperLabel := HyperLabel{#mPSWALNUM,"Mixture of alphabetic and numerics",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{TABPARM_PAGE7_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Password properties:",NULL_STRING,NULL_STRING}

SELF:Caption := "Password security"
SELF:HyperLabel := HyperLabel{#TABPARM_PAGE7,"Password security",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mPSWALNUM() CLASS TABPARM_PAGE7
RETURN SELF:FieldGet(#mPSWALNUM)

ASSIGN mPSWALNUM(uValue) CLASS TABPARM_PAGE7
SELF:FieldPut(#mPSWALNUM, uValue)
RETURN uValue

ACCESS mPSWDURA() CLASS TABPARM_PAGE7
RETURN SELF:FieldGet(#mPSWDURA)

ASSIGN mPSWDURA(uValue) CLASS TABPARM_PAGE7
SELF:FieldPut(#mPSWDURA, uValue)
RETURN uValue

ACCESS mPSWRDLEN() CLASS TABPARM_PAGE7
RETURN SELF:FieldGet(#mPSWRDLEN)

ASSIGN mPSWRDLEN(uValue) CLASS TABPARM_PAGE7
SELF:FieldPut(#mPSWRDLEN, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TABPARM_PAGE7
	//Put your PostInit additions here
self:SetTexts()
	self:mPSWDURA:=self:oSys:PSWDURA
	IF Empty(self:mPSWDURA)
		self:mPSWDURA:=9999
	ENDIF
	self:mPSWRDLEN:=self:oSys:PSWRDLEN
	IF Empty(self:mPSWRDLEN)
		self:mPSWRDLEN:=8
	ENDIF
	self:mPSWALNUM:=ConL(self:oSys:PSWALNUM)
	self:oDCmPSWALNUM:Hide()
	RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class TABPARM_PAGE7
	//Put your PreInit additions here
	self:oSys:=oWindow:oSys
	return nil

STATIC DEFINE TABPARM_PAGE7_FIXEDTEXT1 := 100 
STATIC DEFINE TABPARM_PAGE7_FIXEDTEXT2 := 102 
STATIC DEFINE TABPARM_PAGE7_FIXEDTEXT3 := 103 
STATIC DEFINE TABPARM_PAGE7_FIXEDTEXT4 := 106 
STATIC DEFINE TABPARM_PAGE7_MPSWALNUM := 105 
STATIC DEFINE TABPARM_PAGE7_MPSWDURA := 101 
STATIC DEFINE TABPARM_PAGE7_MPSWRDLEN := 104 
RESOURCE TabParm_Page8 DIALOGEX  8, 7, 272, 148
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Language used", TABPARM_PAGE8_CRLANGUAGE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 79, 24, 75, 33
	CONTROL	"Language used:", TABPARM_PAGE8_SC_LANGUAGE, "Static", WS_CHILD, 8, 27, 70, 12
	CONTROL	"(See Lan.Translation tables)", TABPARM_PAGE8_TR_TEXT, "Static", WS_CHILD, 168, 23, 100, 18
END

CLASS TabParm_Page8 INHERIT DataWindowMine 

	PROTECT oDCCRLANGUAGE AS COMBOBOX
	PROTECT oDCSC_LANGUAGE AS FIXEDTEXT
	PROTECT oDCtr_text AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
   protect oSys as SQLSelect
ACCESS CRLANGUAGE() CLASS TabParm_Page8
RETURN SELF:FieldGet(#CRLANGUAGE)

ASSIGN CRLANGUAGE(uValue) CLASS TabParm_Page8
SELF:FieldPut(#CRLANGUAGE, uValue)
RETURN uValue

METHOD FillLanguage() CLASS TabParm_Page8
	RETURN {{"English","E"},{"My Language","N"}}
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TabParm_Page8 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TabParm_Page8",_GetInst()},iCtlID)

oDCCRLANGUAGE := combobox{SELF,ResourceID{TABPARM_PAGE8_CRLANGUAGE,_GetInst()}}
oDCCRLANGUAGE:HyperLabel := HyperLabel{#CRLANGUAGE,"Language used",NULL_STRING,"Sysparms_LANGUAGE"}
oDCCRLANGUAGE:FillUsing(Self:FillLanguage( ))
oDCCRLANGUAGE:FieldSpec := sysparms_CRLANGUAGE{}

oDCSC_LANGUAGE := FixedText{SELF,ResourceID{TABPARM_PAGE8_SC_LANGUAGE,_GetInst()}}
oDCSC_LANGUAGE:HyperLabel := HyperLabel{#SC_LANGUAGE,"Language used:",NULL_STRING,NULL_STRING}

oDCtr_text := FixedText{SELF,ResourceID{TABPARM_PAGE8_TR_TEXT,_GetInst()}}
oDCtr_text:HyperLabel := HyperLabel{#tr_text,"(See Lan.Translation tables)",NULL_STRING,NULL_STRING}

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#TabParm_Page8,"DataWindow Caption",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method PostInit(oWindow,iCtlID,oServer,uExtra) class TabParm_Page8
	//Put your PostInit additions here
	self:CRLANGUAGE:=self:oSys:CRLANGUAGE
	return nil

method PreInit(oWindow,iCtlID,oServer,uExtra) class TabParm_Page8
	//Put your PreInit additions here
	self:oSys:=oWindow:oSys
	return nil

STATIC DEFINE TABPARM_PAGE8_CRLANGUAGE := 100 
STATIC DEFINE TABPARM_PAGE8_SC_LANGUAGE := 101 
STATIC DEFINE TABPARM_PAGE8_TR_TEXT := 102 
CLASS TabParm_Page9 INHERIT DataWindowMine 

	PROTECT oDCmToPPAcct AS SINGLELINEEDIT
	PROTECT oCCToPPButton AS PUSHBUTTON
	PROTECT oDCSC_ToPP AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
   EXPORT cToPPname as STRING
  	EXPORT NbrToPP as STRING
  	EXPORT cSoortToPP as STRING
   protect oSys as SQLSelect

RESOURCE TabParm_Page9 DIALOGEX  2, 2, 287, 241
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Account Sending to other PPs:", TABPARM_PAGE9_MTOPPACCT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 112, 11, 121, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TABPARM_PAGE9_TOPPBUTTON, "Button", WS_CHILD, 232, 11, 15, 12
	CONTROL	"Account Sending to other PPs:", TABPARM_PAGE9_SC_TOPP, "Static", WS_CHILD, 4, 11, 104, 12
END

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS TabParm_Page9
	LOCAL oControl as Control
	LOCAL lGotFocus as LOGIC
	oControl := iif(oEditFocusChangeEvent == null_object, null_object, oEditFocusChangeEvent:Control)
	lGotFocus := iif(oEditFocusChangeEvent == null_object, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "MTOPPACCT".and.!AllTrim(oControl:VALUE)==AllTrim(cToPPname)
			IF Empty(oControl:VALUE) && leeg gemaakt?
				self:NbrToPP := "  "
				self:cToPPname := ""
				self:oDCmToPPAcct:TEXTValue := ""
			ELSE
				cToPPName:=AllTrim(oControl:VALUE)
				self:ToPPButton(true)
			ENDIF
		endif
	endif
	return nil
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TabParm_Page9 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TabParm_Page9",_GetInst()},iCtlID)

oDCmToPPAcct := SingleLineEdit{SELF,ResourceID{TABPARM_PAGE9_MTOPPACCT,_GetInst()}}
oDCmToPPAcct:HyperLabel := HyperLabel{#mToPPAcct,"Account Sending to other PPs:","Accountnumber for to othher PPs account",NULL_STRING}
oDCmToPPAcct:FieldSpec := MEMBERACCOUNT{}
oDCmToPPAcct:UseHLforToolTip := True

oCCToPPButton := PushButton{SELF,ResourceID{TABPARM_PAGE9_TOPPBUTTON,_GetInst()}}
oCCToPPButton:HyperLabel := HyperLabel{#ToPPButton,"v","Browse in accounts",NULL_STRING}
oCCToPPButton:TooltipText := "Browse in accounts"
oCCToPPButton:UseHLforToolTip := True

oDCSC_ToPP := FixedText{SELF,ResourceID{TABPARM_PAGE9_SC_TOPP,_GetInst()}}
oDCSC_ToPP:HyperLabel := HyperLabel{#SC_ToPP,"Account Sending to other PPs:",NULL_STRING,NULL_STRING}

SELF:Caption := "Wycliffe Area Parameters"
SELF:HyperLabel := HyperLabel{#TabParm_Page9,"Wycliffe Area Parameters",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mToPPAcct() CLASS TabParm_Page9
RETURN SELF:FieldGet(#mToPPAcct)

ASSIGN mToPPAcct(uValue) CLASS TabParm_Page9
SELF:FieldPut(#mToPPAcct, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class TabParm_Page9
	//Put your PostInit additions here
	LOCAL oAcc as SQLSelect
self:SetTexts()
	IF !Empty(self:oSys:ToPPAcct)
		oAcc:=SQLSelect{"select a.accid,a.description,b.category as type from account a, balanceitem b where a.balitemid=b.balitemid and a.accid='"+self:oSys:ToPPAcct+"'",oConn}
		IF oAcc:RecCount>0
			self:NbrToPP :=  Str(oAcc:accid,-1)
			self:oDCmToPPAcct:TEXTValue := AllTrim(oAcc:Description)
			self:cToPPname := AllTrim(oAcc:Description)
			self:cSoortToPP:=oAcc:TYPE
		ENDIF		
	ENDIF
	return nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class TabParm_Page9
	//Put your PreInit additions here
	self:oSys:=oWindow:oSys
	return nil

METHOD ToPPButton(lUnique ) CLASS TabParm_Page9 
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({NbrToPP},{"AK","PA"},"N",0)
	AccountSelect(self:Owner,AllTrim(oDCmToPPAcct:TEXTValue ),"Account Sending to other PPs",lUnique,cfilter)
	RETURN nil

RETURN nil
STATIC DEFINE TABPARM_PAGE9_MTOPPACCT := 100 
STATIC DEFINE TABPARM_PAGE9_SC_TOPP := 102 
STATIC DEFINE TABPARM_PAGE9_TOPPBUTTON := 101 
CLASS TabSysParms INHERIT DataWindowMine 

	PROTECT oDCTabParm AS TABCONTROL
	protect oTPTAB_PARM1 as TAB_PARM1
	protect oTPTAB_PARM2 as TAB_PARM2
	protect oTPTAB_PARM3 as TAB_PARM3
	protect oTPTAB_PARM4 as TAB_PARM4
	protect oTPTAB_PARM5 as TAB_PARM5
	protect oTPTAB_PARM6 as TAB_PARM6
	protect oTPTABPARM_PAGE7 as TABPARM_PAGE7
	protect oTPTABPARM_PAGE8 as TABPARM_PAGE8
	protect oTPTABPARM_PAGE9 as TABPARM_PAGE9
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  PROTECT nOrigCloseMonth as int
	export oSys as SQLSelect
RESOURCE TabSysParms DIALOGEX  38, 35, 304, 303
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TABSYSPARMS_TABPARM, "SysTabControl32", WS_CHILD, 4, 7, 293, 277
	CONTROL	"OK", TABSYSPARMS_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 176, 288, 53, 12
	CONTROL	"Cancel", TABSYSPARMS_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 241, 288, 53, 12
END

METHOD CancelButton( ) CLASS TabSysParms
// 	oTPTAB_PARM1:UndoAll()
// 	IF !oTPTAB_PARM2==null_object
// 		oTPTAB_PARM2:UndoAll()
// 	endif
// 	IF !oTPTAB_PARM3==null_object
// 		oTPTAB_PARM3:UndoAll()
// 	endif
// 	IF !oTPTAB_PARM4==null_object
// 		oTPTAB_PARM4:UndoAll()
// 	endif
// 	oTPTAB_PARM5:UndoAll()
// 	IF !oTPTABPARM_PAGE7==null_object
// 		oTPTABPARM_PAGE7:UndoAll()
// 	endif
	self:EndWindow()
	RETURN nil
method checktabs(admintype)  CLASS TabSysParms
* remove non applicable Tabs in case of non Wycliffe Office:

IF !admintype=="WO".and.!admintype=="WA" 
	IF !oTPTAB_PARM2==null_object
		oDCTabParm:DeleteTab(#TAB_PARM2)
		oTPTAB_PARM2:Destroy()
		oTPTAB_PARM2:=null_object
	endif		
	IF admintype=="HO"
		IF !oTPTAB_PARM3==null_object
			oDCTabParm:DeleteTab(#TAB_PARM3)
			oTPTAB_PARM3:Destroy()
			oTPTAB_PARM3:=null_object
		endif		
		IF !oTPTAB_PARM4==null_object
			oDCTabParm:DeleteTab(#TAB_PARM4)
			oTPTAB_PARM4:Destroy()
			oTPTAB_PARM4:=null_object		
		ENDIF
	endif
ENDIF

IF admintype="WO".and.!ADMIN=="WO"
	IF oDCTabParm:GetTabPage(#TAB_PARM2)==null_object 
		ASize(self:aSubForms,Len(self:aSubForms)+1)
		AIns(aSubForms,2)
		oTPTAB_PARM2 := Tab_Parm2{self, 0}
		aSubForms[2]:= oTPTAB_PARM2
		oDCTabParm:InsertTab(2,#TAB_PARM2,"  PMC  ",self:oTPTAB_PARM2,0) 
		//AAdd(self:aSubForms,oTPTAB_PARM2)
	endif
endif
IF !admintype=="HO" .and. ADMIN=="HO"
	IF oDCTabParm:GetTabPage(#TAB_PARM3)==null_object 
		ASize(self:aSubForms,Len(self:aSubForms)+1)
		AIns(aSubForms,3)
		oTPTAB_PARM3 := Tab_Parm3{self, 0}
		aSubForms[3]:= oTPTAB_PARM3
		oDCTabParm:InsertTab(3,#TAB_PARM3,"Invoices",self:oTPTAB_PARM3,0) 
	endif	
	IF oDCTabParm:GetTabPage(#TAB_PARM4)==null_object 
		ASize(self:aSubForms,Len(self:aSubForms)+1)
		AIns(aSubForms,4)
		oTPTAB_PARM4 := Tab_Parm4{self, 0}
		aSubForms[4]:= oTPTAB_PARM4
		oDCTabParm:InsertTab(4,#TAB_PARM4," Gifts  ",self:oTPTAB_PARM4,0) 
	endif	
endif

method Close(oEvent) class TabSysParms
self:EndWindow() 
// return self:CancelButton()
return nil

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TabSysParms 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TabSysParms",_GetInst()},iCtlID)

oDCTabParm := TabControl{SELF,ResourceID{TABSYSPARMS_TABPARM,_GetInst()}}
oDCTabParm:HyperLabel := HyperLabel{#TabParm,NULL_STRING,NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{TABSYSPARMS_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{TABSYSPARMS_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

SELF:Caption := "System Parameter"
SELF:HyperLabel := HyperLabel{#TabSysParms,"System Parameter",NULL_STRING,NULL_STRING}
SELF:EnableStatusBar(False)
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
oTPTAB_PARM1 := TAB_PARM1{SELF, 0}
oDCTabParm:AppendTab(#TAB_PARM1,"General ",oTPTAB_PARM1,0)
oTPTAB_PARM2 := TAB_PARM2{SELF, 0}
oDCTabParm:AppendTab(#TAB_PARM2,"PMC",oTPTAB_PARM2,0)
oTPTAB_PARM3 := TAB_PARM3{SELF, 0}
oDCTabParm:AppendTab(#TAB_PARM3,"Invoices",oTPTAB_PARM3,0)
oTPTAB_PARM4 := TAB_PARM4{SELF, 0}
oDCTabParm:AppendTab(#TAB_PARM4,"Gifts",oTPTAB_PARM4,0)
oTPTAB_PARM5 := TAB_PARM5{SELF, 0}
oDCTabParm:AppendTab(#TAB_PARM5," Mailing",oTPTAB_PARM5,0)
oTPTAB_PARM6 := TAB_PARM6{SELF, 0}
oDCTabParm:AppendTab(#TAB_PARM6,"Reports",oTPTAB_PARM6,0)
oTPTABPARM_PAGE7 := TABPARM_PAGE7{SELF, 0}
oDCTabParm:AppendTab(#TABPARM_PAGE7,"Security",oTPTABPARM_PAGE7,0)
oTPTABPARM_PAGE8 := TABPARM_PAGE8{SELF, 0}
oDCTabParm:AppendTab(#TABPARM_PAGE8,"Language",oTPTABPARM_PAGE8,0)
oTPTABPARM_PAGE9 := TABPARM_PAGE9{SELF, 0}
oDCTabParm:AppendTab(#TABPARM_PAGE9,"Area",oTPTABPARM_PAGE9,0)
oDCTabParm:SelectTab(#TAB_PARM1)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS TabSysParms
	LOCAL oSys:=self:oSys as SQLSelect
	LOCAL nNewStart as int
	local oBalY,oStmnt as SQLStatement
	local cStatement as string	
	* Check values:
	IF !self:oTPTAB_PARM1:cSoortCASH=="AK".and.!Empty(self:oTPTAB_PARM1:NbrCASH)
		(ErrorBox{,"Account for Cash should be Assets"}):Show()
		RETURN
	ENDIF
	IF !self:oTPTAB_PARM1:cSoortCAPITAL=="PA".and.!Empty(self:oTPTAB_PARM1:NbrCAPITAL)
		(ErrorBox{,"Account for Net Assets should be Liabilities&Funds"}):Show()
		RETURN
	ENDIF
	IF !self:oTPTAB_PARM1:cSoortCROSS=="AK".and.!Empty(self:oTPTAB_PARM1:NbrCROSS)
		(ErrorBox{,"Account for Internal Bank Transfer should be Assets"}):Show()
		RETURN
	ENDIF
	if !self:oTPTAB_PARM2==null_object
		IF !self:oTPTAB_PARM2:cSoortAM=="BA".and.!Empty(self:oTPTAB_PARM2:NbrAM)
			(ErrorBox{,"Account for Assessments should be Income"}):Show()
			RETURN
		ENDIF
		IF !self:oTPTAB_PARM2:cSoortAMProj=="BA".and.!Empty(self:oTPTAB_PARM2:NbrAMProj)
			(ErrorBox{,"Account for Assessments Projects should be Income"}):Show()
			RETURN
		ENDIF
		IF !self:oTPTAB_PARM2:cSoortGIFTINCAC=="BA".and.!Empty(self:oTPTAB_PARM2:NbrInc)
			(ErrorBox{,"Account for Gifts Income should be Income"}):Show()
			RETURN
		ENDIF
		IF !self:oTPTAB_PARM2:cSoortGIFTEXPAC=="KO".and.!Empty(self:oTPTAB_PARM2:NbrExp)
			(ErrorBox{,"Account for Gifts Expense should be Expenses"}):Show()
			RETURN
		ENDIF
		IF !self:oTPTAB_PARM2:cSoortHOMEINCAC=="BA".and.!Empty(self:oTPTAB_PARM2:NbrIncHome)
			(ErrorBox{,"Account for Gifts HOME Income should be Income"}):Show()
			RETURN
		ENDIF
		IF !self:oTPTAB_PARM2:cSoortHOMEEXPAC=="KO".and.!Empty(self:oTPTAB_PARM2:NBREXPHOME)
			(ErrorBox{,"Account for Gifts Home Expense should be Expenses"}):Show()
			RETURN
		endif
		IF !(self:oTPTAB_PARM2:cSoortHB=="PA".or.self:oTPTAB_PARM2:cSoortHB=="AK").and.!Empty(self:oTPTAB_PARM2:NbrHB)
			(ErrorBox{,"Account for PMC clearance should be Liabilities&Funds or Assets"}):Show()
			RETURN
		ENDIF
		IF !Empty(self:oTPTAB_PARM2:NbrIncHome) .and. Empty(self:oTPTAB_PARM2:NbrExpHome) .or. Empty(self:oTPTAB_PARM2:NbrIncHome) .and. !Empty(self:oTPTAB_PARM2:NbrExpHome)
			(ErrorBox{,"Gifts Home Income and Gifts Home Expenses should be both specified or both empty"}):Show()
			RETURN
		ENDIF
		IF Empty(self:oTPTAB_PARM2:EntitySelected) .or. Empty(self:oTPTAB_PARM2:Entity)
			(ErrorBox{,"Select a PMC Participant code (tab PMC)"}):Show()
			RETURN
		ENDIF
		IF !Empty(self:oTPTAB_PARM2:NbrInc) .and. Empty(self:oTPTAB_PARM2:NbrExp) .or. Empty(self:oTPTAB_PARM2:NbrInc) .and. !Empty(self:oTPTAB_PARM2:NbrExp)
			(ErrorBox{,"Gifts Income and Gifts Expenses should be both specified or both empty"}):Show()
			RETURN
		ENDIF
	ENDIF
	if !self:oTPTAB_PARM3==null_object
		IF !self:oTPTAB_PARM3:cSoortPostage=="KO".and.!Empty(self:oTPTAB_PARM3:NbrPostage)
			(ErrorBox{,"Account for Postage should be Expenses"}):Show()
			RETURN
		ENDIF
		IF !self:oTPTAB_PARM3:cSoortDEBTORS=="AK".and.!Empty(self:oTPTAB_PARM3:NbrDEBTORS)
			(ErrorBox{,"Account Receivable should be Assets"}):Show()
			RETURN
		ENDIF
		IF !self:oTPTAB_PARM3:cSoortCREDITORS=="PA".and.!Empty(self:oTPTAB_PARM3:NbrCREDITORS)
			(ErrorBox{,"Account Payable should be Liability"}):Show()
			RETURN
		ENDIF
	endif
	// 	if !self:oTPTAB_PARM4==null_object
	// 		IF !self:oTPTAB_PARM4:cSoortDONORS=="BA".and.!Empty(self:oTPTAB_PARM4:NbrDONORS)
	// 			(ErrorBox{,"Account for DONORS should be Income"}):Show()
	// 			RETURN
	// 		ENDIF
	// 		IF !(self:oTPTAB_PARM4:cSoortPROJECTS=="PA".or.self:oTPTAB_PARM4:cSoortPROJECTS=="BA").and.!Empty(self:oTPTAB_PARM4:NbrPROJECTS)
	// 			(ErrorBox{,"Account for PROJECTS should be Income or Liabilities&Funds"}):Show()
	// 			RETURN
	// 		ENDIF
	// 	endif
	if !self:oTPTABPARM_PAGE7==null_object
		IF Empty(self:oTPTABPARM_PAGE7:mPSWRDLEN)
			(ErrorBox{,"Fill minimum length of a Password"}):Show()
			RETURN
		ENDIF
		IF self:oTPTABPARM_PAGE7:mPSWRDLEN < 8
			(ErrorBox{,"minimum length of a Password must be > 7"}):Show()
			RETURN
		ENDIF
		IF self:oTPTABPARM_PAGE7:mPSWDURA >365
			(ErrorBox{,"Maximum duration of a password is 365 days"}):Show()
			RETURN
		ENDIF
	endif 
	SQLStatement{"start transaction",oConn}:Execute()
	cStatement:="update sysparms set "+;	
	"cash='"+self:oTPTAB_PARM1:NbrCASH+"'" +;
		",crossaccnt='"+self:oTPTAB_PARM1:NbrCROSS+"'" +;
		",capital='"+self:oTPTAB_PARM1:NbrCAPITAL+"'"+;
		",idorg='"+self:oTPTAB_PARM1:mCLNOrg+"'"+;
		",idcontact='"+self:oTPTAB_PARM1:mCLNContact+"'"+;
		",closemonth='"+Transform(self:oTPTAB_PARM1:closemonth,"")+"'"+; 
	",entity='"+iif( self:oTPTAB_PARM1:mAdminType="WO".and.!IsNil(self:oTPTAB_PARM2:Entity),self:oTPTAB_PARM2:Entity,self:oTPTAB_PARM1:Entity)+"'"+;
		",currency='"+self:oTPTAB_PARM1:Currency+"'"+; 
	",countryown='"+ConS(self:oTPTAB_PARM1:HBLAND)+"'"+; 
	",currname='"+ConS(self:oTPTAB_PARM1:CURRNAME)+"'"+; 
	",sysname='"+ConS(self:oTPTAB_PARM1:SYSNAME)+"'"+; 
	",admintype='"+self:oTPTAB_PARM1:mAdminType+"'"+;
		",posting="+iif(self:oTPTAB_PARM1:posting,'1','0')+; 
	iif( self:oTPTAB_PARM2==null_object,'',;  
	",pmcmancln='"+self:oTPTAB_PARM2:mCLNPMCMan+"'"+;
		",hb='"+self:oTPTAB_PARM2:NbrHB+"'"+;
		",am='"+self:oTPTAB_PARM2:NbrAM+"'"+;
		",assproja='"+self:oTPTAB_PARM2:NbrAMProj+"'"+;
		",giftincac='"+self:oTPTAB_PARM2:NbrInc+"'"+;  
		",giftexpac='"+self:oTPTAB_PARM2:NbrExp+"'"+;
		iif(Empty(self:oTPTAB_PARM2:NbrInc),",homeincac='',homeexpac='',assfldac=''",+;
		",homeincac='"+ConS(self:oTPTAB_PARM2:NbrIncHome)+"'"+;
		",homeexpac='"+self:oTPTAB_PARM2:NBREXPHOME+"'" +;  
	",assfldac='"+self:oTPTAB_PARM2:NbrAssFldAc+"'") +;  
	",assmntfield='"+AllTrim(Transform(self:oTPTAB_PARM2:assmntfield,""))+"'" +;
		",withldoffl='"+AllTrim(Transform(self:oTPTAB_PARM2:withldoffl,""))+"'"	+;	
	",iesmailacc='"+AllTrim(Transform(self:oTPTAB_PARM2:IESMAILACC,""))+"'" +; 
	",assmntint="+AllTrim(Transform(self:oTPTAB_PARM2:assmntint,"")) +; 
	",assmntoffc='"+AllTrim(Transform(self:oTPTAB_PARM2:assmntOffc,""))+"'" +; 
	",withldoffm='"+AllTrim(Transform(self:oTPTAB_PARM2:withldoffM,""))+"'"	+;	
	",withldoffh='"+AllTrim(Transform(self:oTPTAB_PARM2:withldoffH,""))+"'" +;	
	",pmcupld="+iif(self:oTPTAB_PARM2:pmcupld,'1','0'))+; 
	iif(self:oTPTAB_PARM3==null_object,'',;
		",postage='"+self:oTPTAB_PARM3:NbrPostage+"'"+;
		",debtors='"+self:oTPTAB_PARM3:NbrDEBTORS+"'"+;
		",creditors='"+self:oTPTAB_PARM3:NbrCreditors+"'"+;
		",cntrnrcoll='"+self:oTPTAB_PARM3:CNTRNRCOLL+"'" +;
		",banknbrcol='"+self:oTPTAB_PARM3:BANKNBRCOL+"'" + ;
		",banknbrcre='"+self:oTPTAB_PARM3:BANKNBRCRE+"'")+;
		iif(self:oTPTAB_PARM4==null_object,'',;
		",donors='"+self:oTPTAB_PARM4:NbrDONORS+"'"+;
		",projects='"+self:oTPTAB_PARM4:NbrPROJECTS+"'"+;
		iif(IsNil(self:oTPTAB_PARM4:mDecimalGiftreport),'',;
		",decmgift="+Str(Min(self:oTPTAB_PARM4:mDecimalGiftreport,2),-1)))+;
		",defaultcod='"+ MakeCod({self:oTPTAB_PARM5:mCOD1,self:oTPTAB_PARM5:mCOD2,self:oTPTAB_PARM5:mCOD3})+"'"+; 
	",fgmlcodes='"+MakeCod({self:oTPTAB_PARM5:mFGCod1,self:oTPTAB_PARM5:mFGCod2,self:oTPTAB_PARM5:mFGCod3})+"'"+; 
	",firstname="+iif(self:oTPTAB_PARM5:FIRSTNAME,'1','0')+; 
	",nosalut="+iif(self:oTPTAB_PARM5:SALUTADDR,'0','1') +;
		",cityletter='"+self:oTPTAB_PARM5:CITYLETTER+"'"+; 
	",owncntry='"+AllTrim(self:oTPTAB_PARM5:mOwnCntry)+"'"+; 
	",surnmfirst="+iif(self:oTPTAB_PARM5:SURNMFIRST,'1','0')+; 
	",strzipcity="+Str(self:oTPTAB_PARM5:STRZIPCITY,-1)+;
		",citynmupc="+iif(self:oTPTAB_PARM5:CITYNMUPC,'1','0')+;
		",lstnmupc="+iif(self:oTPTAB_PARM5:LSTNMUPC,'1','0')+; 
	",titinadr="+iif(self:oTPTAB_PARM5:TITINADR,'1','0')+; 
	",mailclient='"+Str(self:oTPTAB_PARM5:MailClient,-1)+"'"+;
		",topmargin='"+AllTrim(Transform(self:oTPTAB_PARM6:TOPMARGIN,""))+"'"+;
		",leftmargin='"+AllTrim(Transform(self:oTPTAB_PARM6:leftMARGIN,""))+"'"+;           
	",rightmargn='"+AllTrim(Transform(self:oTPTAB_PARM6:leftMARGIN,""))+"'"+;
		",bottommarg='"+AllTrim(Transform(self:oTPTAB_PARM6:BOTTOMMARG,""))+"'"+;	
	iif(self:oTPTABPARM_PAGE7==null_object,'',;
		",pswrdlen="+Str(Min(self:oTPTABPARM_PAGE7:mPSWRDLEN,10),-1)+;
		",pswdura="+iif(Empty(self:oTPTABPARM_PAGE7:mPSWDURA),"9999",AllTrim(Transform(self:oTPTABPARM_PAGE7:mPSWDURA,""))+;
		",pswalnum="+iif(self:oTPTABPARM_PAGE7:mPSWALNUM,'1','0')) +;
		",crlanguage='"+self:oTPTabParm_Page8:CRLANGUAGE+"'")+;
		iif(self:oTPTABPARM_PAGE9==null_object,'',;      
	",toppacct='"+iif(IsNil(self:oTPTABParm_Page9:NbrToPP),"",self:oTPTABParm_Page9:NbrToPP)+"'")
	oStmnt:=SQLStatement{cStatement,oConn}
	oStmnt:Execute()
	IF empty(oStmnt:status)
		SQLStatement{"commit",oConn}:Execute() 
		IF oStmnt:NumSuccessfulRows>0
			IF !ClosingMonth==ConI(self:oTPTAB_PARM1:closemonth)
				*	Closingmonth has been changed:
				ClosingMonth:=ConI(self:oTPTAB_PARM1:closemonth)
				// 		nNewStart:=if(ClosingMonth==12,1,ClosingMonth+1)
				// 		*	Correct existing AccountBalanceyear not yet closed:
				// 		oBalY:=SQLStatement{"update AccountBalanceYear set MONTHSTART="+Str(nNewStart,-1)+" where (YEARSTART*12+MonthStart)>"+Str(Year(LstYearClosed)*12+Month(LstYearClosed),5),oConn}
				// 		oBalY:Execute()
			ENDIF
			InitGlobals()
			self:Owner:SetCaption(AllTrim(self:oTPTAB_PARM1:SYSNAME))
			
			// reinitailise menu's with myLanguae
			GetUserMenu(LOGON_EMP_ID)
			oMainWindow:Menu:=WOMenu{}
			oMainWindow:Menu:ToolBar:Hide()
		ENDIF 
	else
		SQLStatement{"rollback",oConn}:Execute()
		LogEvent(self,"error:"+oStmnt:SQLString,"LogErrors")
	ENDIF
	self:EndWindow()
	RETURN nil
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TabSysParms
	//Put your PostInit additions here
	local oTabPage as Window
	self:SetTexts() 
	nOrigCloseMonth:=self:oSys:closemonth

	/*	self:oTPTAB_PARM1:NbrCASH:=self:oSys:self:oSys:cash
	self:oTPTAB_PARM1:NbrCROSS:=self:oSys:self:oSys:crossaccnt
	self:oTPTAB_PARM1:NbrCAPITAL:=self:oSys:self:oSys:capital
	self:oTPTAB_PARM1:mCLNOrg:=self:oSys:idorg
	self:oTPTAB_PARM1:mCLNContact:=self:oSys:idcontact
	self:oTPTAB_PARM1:closemonth=self:oSys:closemonth 
	self:oTPTAB_PARM1:Entity):=self:oSys:Entity
	self:oTPTAB_PARM1:CURRENCY:=self:oSys:CURRENCY 
	self:oTPTAB_PARM1:CountryOwn:=self:oSys:CountryOwn 
	self:oTPTAB_PARM1:CURRNAME:=self:oSys:CURRNAME 
	self:oTPTAB_PARM1:SYSNAME:=self:oSys:SYSNAME 
	self:oTPTAB_PARM1:mAdminType:=self:oSys:admintype
	self:oTPTAB_PARM1:posting:=self:oSys:posting 
	self:oTPTAB_PARM2:mCLNPMCMan:=self:oSys:pmcmancln
	self:oTPTAB_PARM2:NbrHB:=self:oSys:hb
	self:oTPTAB_PARM2:NbrAM:=self:oSys:am
	self:oTPTAB_PARM2:NbrAMProj:=self:oSys:assproja
	self:oTPTAB_PARM2:NbrInc:=self:oSys:giftincac
	self:oTPTAB_PARM2:NbrExp:=self:oSys:giftexpac
	self:oTPTAB_PARM2:NbrIncHome:=self:oSys:homeincac
	self:oTPTAB_PARM2:NBREXPHOME:=self:oSys:homeexpac  
	self:oTPTAB_PARM2:NbrAssFldAc:=self:oSys:assfldac  
	self:oTPTAB_PARM2:assmntfield:=self:oSys:assmntfield
	self:oTPTAB_PARM2:withldoffl:=self:oSys:withldoffl	
	self:oTPTAB_PARM2:IESMAILACC:=self:oSys:IESMAILACC 
	self:oTPTAB_PARM2:assmntint:=self:oSys:assmntint 
	self:oTPTAB_PARM2:assmntOffc:=self:oSys:assmntOffc 
	self:oTPTAB_PARM2:withldoffM:=self:oSys:withldoffM	
	self:oTPTAB_PARM2:withldoffH:=self:oSys:withldoffH	
	self:oTPTAB_PARM2:pmcupld:=ConL(pmcupld) 
	self:oTPTAB_PARM3:NbrPostage:=self:oSys:postage
	self:oTPTAB_PARM3:NbrDEBTORS:=self:oSys:debtors
	creditorsself:oTPTAB_PARM3:NbrCreditors:=self:oSys:
	self:oTPTAB_PARM3:CNTRNRCOLL:=CNTRNRCOLL
	self:oTPTAB_PARM3:BANKNBRCOL:=self:oSys:BANKNBRCOL
	self:oTPTAB_PARM3:BANKNBRCRE:=self:oSys:BANKNBRCRE
	self:oTPTAB_PARM4:NbrDONORS:=self:oSys:donors
	self:oTPTAB_PARM4:NbrPROJECTS:=self:oSys:projects
	self:oTPTAB_PARM4:mDecimalGiftreport:=self:oSys:decmgift
	self:oTPTAB_PARM5:SALUTADDR:=ConL(self:oSys:nosalut)
	self:oTPTAB_PARM5:mCOD1,self:oTPTAB_PARM5:mCOD2,self:oTPTAB_PARM5:mCOD3:=self:oSys:defaultcod 
	self:oTPTAB_PARM5:mFGCod1,self:oTPTAB_PARM5:mFGCod2,self:oTPTAB_PARM5:mFGCod3:=self:oSys:fgmlcodes 
	self:oTPTAB_PARM5:FIRSTNAME:=ConL(self:oSys:FIRSTNAME) 
	self:oTPTAB_PARM5:CITYLETTER:=self:oSys:CITYLETTER 
	self:oTPTAB_PARM5:mOwnCntry:=self:oSys:owncntry 
	self:oTPTAB_PARM5:SURNMFIRST:=ConL(self:oSys:SURNMFIRST) 
	self:oTPTAB_PARM5:STRZIPCITY:=self:oSys:STRZIPCITY
	self:oTPTAB_PARM5:CITYNMUPC:=ConL(self:oSys:CITYNMUPC)
	self:oTPTAB_PARM5:LSTNMUPC:=ConL(self:oSys:LSTNMUPC) 
	self:oTPTAB_PARM5:TITINADR:=ConL(self:oSys:TITINADR) 
	self:oTPTAB_PARM5:MailClient:=self:oSys:MailClient
	self:oTPTAB_PARM6:TOPMARGIN:=self:oSys:TOPMARGIN
	self:oTPTAB_PARM6:TOPMARGIN:=self:oSys:leftmargin           
	self:oTPTAB_PARM6:TOPMARGIN:=self:oSys:rightmargn
	self:oTPTAB_PARM6:TOPMARGIN:=self:oSys:bottommarg	
	self:oTPTABPARM_PAGE7:mPSWRDLEN:=self:oSys:pswrdlen
	self:oTPTABPARM_PAGE7:mPSWDURA:=self:oSys:pswdura
	self:oTPTABPARM_PAGE7:mPSWALNUM:=ConL(self:oSys:pswalnum)
	self:oTPTabParm_Page8:CRLANGUAGE:=self:oSys:CRLANGUAGE
	self:oTPTABPARM_PAGE9:NbrToPP:=self:oSys:toppacct	      */
	
	// remove non applicable Tabs in case of non Wycliffe Office:

	self:checktabs(self:oTPTAB_PARM1:mAdminType) 
	IF !(UserType=="A".or.Empty(UserType))
		* surpress security type if no system administrator:
		oDCTabParm:DeleteTab(#TABPARM_PAGE7)
		oTPTABPARM_PAGE7:Destroy()
		oTPTABPARM_PAGE7:=null_object		
	ENDIF 
	IF !ADMIN=="WA" 
		oDCTabParm:DeleteTab(#TABPARM_PAGE9)
		self:oTPTABPARM_PAGE9:Destroy()
		oTPTABPARM_PAGE9:=null_object		
	endif

	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS TabSysParms
	//Put your PreInit additions here 
	self:oSys:=SqlSelect{"select yearclosed,lstreportmonth,cast(mindate as date) as mindate,projects,debtors,donors,cash,capital,crossaccnt,hb,am,"+;
		"assmntfield,assmntoffc,entity,stocknbr,postage,purchase,countryown,currency,currname,cast(firstname as unsigned) as firstname,crlanguage,defaultcod,topmargin,leftmargin,rightmargn,"+;
		"bottommarg,cityletter,ownmailacc,smtpserver,iesmailacc,exchrate,closemonth,admintype,pswrdlen,cast(pswalnum as unsigned) as pswalnum,pswdura,cast(decmgift as unsigned) as decmgift,expmailacc,cast(pmislstsnd as date) as pmislstsnd,"+;
		"assmntint,cast(destgrps as char) as destgrps,cast(nosalut as unsigned) as nosalut,withldoffl,withldoffm,withldoffh,assproja,cast(owncntry as char) as owncntry,giftincac,giftexpac,cntrnrcoll,banknbrcol,idorg,idcontact,"+;
		"cast(datlstafl as date) as datlstafl,cast(surnmfirst as unsigned) as surnmfirst,cast(strzipcity as unsigned) as strzipcity,sysname,homeincac,homeexpac,fgmlcodes,creditors,countrycod,banknbrcre,"+;
		"cast(lstreeval as date) as lstreeval,cast(citynmupc as unsigned) as citynmupc,pmcmancln,version,cast(lstnmupc as unsigned) as lstnmupc,cast(titinadr as unsigned) as titinadr,cast(docpath as char) as docpath,checkemp,cast(mailclient as unsigned) as mailclient,posting,toppacct,cast(lstcurrt as unsigned) as lstcurrt,"+;
		"cast(pmcupld as unsigned) as pmcupld,cast(accpacls as date) as accpacls,assfldac from sysparms",oConn}
		
	self:oSys:Execute()
	RETURN nil
METHOD RegAccount(oRek,ItemName) CLASS TabSysParms
	IF Empty(oRek).or. oRek:reccount<1
		RETURN
	ENDIF
	IF ItemName=="Receivable"
		oTPTAB_PARM3:NbrDEBTORS :=  Str(oRek:accid,-1)
		oTPTAB_PARM3:mDEBTORS:= oRek:Description
		oTPTAB_PARM3:cDEBTORSName := oRek:Description
		oTPTAB_PARM3:cSoortDEBTORS:=oRek:TYPE
	ELSEIF ItemName=="Payable"
		oTPTAB_PARM3:NbrCreditors :=  Str(oRek:accid,-1)
		oTPTAB_PARM3:mCREDITORS:= oRek:Description
		oTPTAB_PARM3:cCREDITORSName := oRek:Description
		oTPTAB_PARM3:cSoortCREDITORS:=oRek:TYPE
	ELSEIF ItemName=="Cash"
		oTPTAB_PARM1:NbrCASH :=  Str(oRek:accid,-1)
		oTPTAB_PARM1:mCASH := oRek:Description
		oTPTAB_PARM1:cCASHName := oRek:Description
		oTPTAB_PARM1:cSoortCash:=oRek:TYPE
	ELSEIF ItemName=="Net Asset"
		oTPTAB_PARM1:NbrCAPITAL :=  Str(oRek:accid,-1)
		oTPTAB_PARM1:mCAPITAL := oRek:Description
		oTPTAB_PARM1:cCAPITALName := oRek:Description
		oTPTAB_PARM1:cSoortCAPITAL:=oRek:TYPE
	ELSEIF ItemName=="Internal bank transfer"
		oTPTAB_PARM1:NbrCROSS :=  Str(oRek:accid,-1)
		oTPTAB_PARM1:mKRUISPSTN := oRek:Description
		oTPTAB_PARM1:cCROSSName := oRek:Description
		oTPTAB_PARM1:cSoortCROSS:=oRek:TYPE
	ELSEIF ItemName=="Assessments"
		oTPTAB_PARM2:NbrAM :=  Str(oRek:accid,-1)
		oTPTAB_PARM2:mAM := oRek:Description
		oTPTAB_PARM2:cAMName := oRek:Description
		oTPTAB_PARM2:cSoortAM:=oRek:TYPE
	ELSEIF ItemName=="Project Assessments"
		oTPTAB_PARM2:NbrAMProj :=  Str(oRek:accid,-1)
		oTPTAB_PARM2:mAMProj := oRek:Description
		oTPTAB_PARM2:cAMNameProj := oRek:Description
		oTPTAB_PARM2:cSoortAMProj:=oRek:TYPE
	ELSEIF ItemName=="Assessment Field and Int"
		oTPTAB_PARM2:NbrAssFldAc :=  Str(oRek:accid,-1)
		oTPTAB_PARM2:mAssFldAc := oRek:Description
		oTPTAB_PARM2:cAssFldAccName := oRek:Description
		oTPTAB_PARM2:cSoortAssFldAc:=oRek:TYPE 
	ELSEIF ItemName=="Account PMC clearance"
		oTPTAB_PARM2:NbrHB :=  Str(oRek:accid,-1)
		oTPTAB_PARM2:mHB := oRek:Description
		oTPTAB_PARM2:cHBName := oRek:Description
		oTPTAB_PARM2:cSoortHB:=oRek:TYPE
	ELSEIF ItemName=="Postage"
		oTPTAB_PARM3:NbrPostage :=  Str(oRek:accid,-1)
		oTPTAB_PARM3:mPostage := oRek:Description
		oTPTAB_PARM3:cPostageName := oRek:Description
		oTPTAB_PARM3:cSoortPostage:=oRek:TYPE
	ELSEIF ItemName=="Donors"
		oTPTAB_PARM4:NbrDONORS :=  Str(oRek:accid,-1)
		oTPTAB_PARM4:mDONORS := oRek:Description
		oTPTAB_PARM4:cDONORSName := oRek:Description
		oTPTAB_PARM4:cSoortDONORS:=oRek:TYPE
	ELSEIF ItemName=="Non earmarked Gifts"
		oTPTAB_PARM4:NbrPROJECTS :=  Str(oRek:accid,-1)
		oTPTAB_PARM4:mPROJECTS := oRek:Description
		oTPTAB_PARM4:cPROJECTSName := oRek:Description
		oTPTAB_PARM4:cSoortPROJECTS:=oRek:TYPE
	ELSEIF ItemName=="Gifts Income"
		oTPTAB_PARM2:NbrInc :=  Str(oRek:accid,-1)
		oTPTAB_PARM2:mGiftIncAc := oRek:Description
		oTPTAB_PARM2:cGIFTINCACName := oRek:Description
		oTPTAB_PARM2:cSoortGIFTINCAC:=oRek:TYPE
	ELSEIF ItemName=="Gifts Expense"
		oTPTAB_PARM2:NbrExp :=  Str(oRek:accid,-1)
		oTPTAB_PARM2:mGiftEXPAc := oRek:Description
		oTPTAB_PARM2:cGIFTEXPACName := oRek:Description
		oTPTAB_PARM2:cSoortGIFTEXPAC:=oRek:TYPE
	ELSEIF ItemName=="Gifts Home Income"
		oTPTAB_PARM2:NbrIncHome :=  Str(oRek:accid,-1)
		oTPTAB_PARM2:mHomeIncAc := oRek:Description
		oTPTAB_PARM2:cHOMEINCACName := oRek:Description
		oTPTAB_PARM2:cSoortHomeINCAC:=oRek:TYPE
	ELSEIF ItemName=="Gifts Home Expense"
		oTPTAB_PARM2:NBREXPHOME :=  Str(oRek:accid,-1)
		oTPTAB_PARM2:mHomeEXPAc := oRek:Description
		oTPTAB_PARM2:cHomeEXPACName := oRek:Description
		oTPTAB_PARM2:cSoortHomeEXPAC:=oRek:TYPE
	ELSEIF ItemName=="Account Sending to other PPs"
		self:oTPTabParm_Page9:NbrToPP :=  Str(oRek:accid,-1)
		self:oTPTabParm_Page9:mToPPAccT := oRek:Description
		self:oTPTabParm_Page9:cToPPName := oRek:Description
		self:oTPTabParm_Page9:cSoortToPP:=oRek:TYPE
	ENDIF
	
RETURN true
METHOD RegPerson(oCLN,ItemName) CLASS TabSysParms
IF !Empty(oCLN) .and. !IsNil(oCLN).and.!oCLN:EoF
	IF ItemName=="Own Organisation"
		oTPTAB_PARM1:mCLNOrg :=  Str(oCLN:persid,-1)
		oTPTAB_PARM1:cOrgName := GetFullName(oTPTAB_PARM1:mCLNOrg,2)
		oTPTAB_PARM1:mPersonOwn := oTPTAB_PARM1:cOrgName
	ELSEif ItemName=="Contact Person Financial"
		oTPTAB_PARM1:mCLNContact :=  Str(oCLN:persid,-1)
		oTPTAB_PARM1:cContactName := GetFullName(oTPTAB_PARM1:mCLNContact,2)
		oTPTAB_PARM1:mPersonContact := oTPTAB_PARM1:cContactName
	ELSEif ItemName=="PMC Manager"
		// check if PMC manager contains email address
		
		oTPTAB_PARM2:mCLNPMCMan :=  Str(oCLN:persid,-1)
		oTPTAB_PARM2:cPMCManName := GetFullName(oTPTAB_PARM2:mCLNPMCMan,2)
		oTPTAB_PARM2:mPersonPMCMan := oTPTAB_PARM2:cPMCManName
	ENDIF
ENDIF
RETURN true
STATIC DEFINE TABSYSPARMS_CANCELBUTTON := 102 
STATIC DEFINE TABSYSPARMS_OKBUTTON := 101 
STATIC DEFINE TABSYSPARMS_TABPARM := 100 
