resource CARDFILE Icon C:\CAVO28\CRDFLE07.ICO
CLASS CARDFILE INHERIT Icon
METHOD Init() CLASS CARDFILE
   super:init(ResourceID{"CARDFILE", _GetInst()})
METHOD AssignExtraProp(ID,myProp) CLASS DataWindowExtra
LOCAL j,lenTgt AS INT
LOCAL cTargetStr as STRING
LOCAL myCombo AS COMBOBOX
	
j:=AScan(SELF:aPropEx,{|x|x:Name==ID})	
IF j>0
	IF ClassName(myProp)=#COMBOBOX
		myCombo:=myProp
		cTargetStr:=Lower(cTargetStr)
		lenTgt:=Len(cTargetStr)
		FOR j:=1 TO myCombo:ItemCount
			IF SubStr(myCombo:GetItemValue(j),1,lenTgt)=cTargetStr
				myCombo:SelectItem(j)
				EXIT
			ENDIF
		NEXT
		//SELF:aPropEx[j]:TextValue:=Lower(cTargetStr)
	ELSE
		myProp:Value:=cTargetStr
	ENDIF
ENDIF
RETURN
DEFINE F_BLOCK := 256

resource FOLDERCLOSE Icon C:\CAVO28\FOLDRS01.ICO
CLASS FOLDERCLOSE INHERIT Icon
METHOD Init() CLASS FOLDERCLOSE
   super:init(ResourceID{"FOLDERCLOSE", _GetInst()})
CLASS FOLDEROPEN INHERIT Icon
resource FOLDEROPEN Icon C:\CAVO28\FOLDRS02.ICO
METHOD Init() CLASS FOLDEROPEN
   super:init(ResourceID{"FOLDEROPEN", _GetInst()})
STATIC GLOBAL hEdit AS PTR
STATIC GLOBAL hTree AS PTR

STATIC DEFINE IMID_CARDFILE    := 3

STATIC DEFINE IMID_FOLDERCLOSE := 1
STATIC DEFINE IMID_FOLDEROPEN  := 2 
CLASS ImportMapping INHERIT DataWindowExtra 

	PROTECT oDCSourceFile AS SINGLELINEEDIT
	PROTECT oCCImportFileButton AS PUSHBUTTON
	PROTECT oDCTargetDB AS COMBOBOX
	PROTECT oDCTreeView1 AS TREEVIEW
	PROTECT oDCTreeView2 AS TREEVIEW
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCExplainText AS FIXEDTEXT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCmCod1 AS COMBOBOX
	PROTECT oDCmCod2 AS COMBOBOX
	PROTECT oDCmCod3 AS COMBOBOX
	PROTECT oDCCodeBox AS GROUPBOX
	PROTECT oDCConfirmBox AS CHECKBOX
	PROTECT oDCReplaceDuplicates AS CHECKBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCmCod4 AS COMBOBOX
	PROTECT oDCmCod5 AS COMBOBOX
	PROTECT oDCmCod6 AS COMBOBOX
	PROTECT oDCAcceptProposed AS CHECKBOX
	PROTECT oDCImportCount AS FIXEDTEXT

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
	Instance ReplaceDuplicates as logic
	PROTECT oTVItemDrag AS TreeViewItem
	PROTECT oTVItemDrop AS TreeViewItem
	PROTECT lDragging AS LOGIC
	PROTECT hImageList AS PTR
	PROTECT SourceFile, TargetDB, cDelim, cBuffer, DefaultCOD AS STRING
	PROTECT aTargetDB:={} as array //{itemname,type,extra},...
	PROTECT SourceFSpec AS filespec
	PROTECT lDbf, lTAB, lCSV,lImportFile,lIdentical,lExists:=false, lOverwrite:=true as LOGIC
	PROTECT NbrCol,ImportCount,ErrCount,ExistCount,InsertCount,PersidPtr as int
	PROTECT ptrHandle
	PROTECT aMapping:={} AS ARRAY // mapping info (Target Fieldnbr, {Source fieldsnbr1, Source field Nbr 2, ...}}
	EXPORT lImportAutomatic:=true,lExtra as LOGIC // In case of General Import: no asking for confirmation per record
	PROTECT oEdit as DataWindowExtra 
	protect cSelectStatement as string // selection of existing person 
	protect aValues:={} as array   // array with new values to be applied to existing persons
	protect aPers:={} as array  // array with {{persid,externid},{..},...}  
	protect aFields:={} as array   // array with the fields of a person to be updated 
	protect avaluesbank:={} as array  // array with bankaccounts to be stored {{persi,bankaccount,bic},{..},...}  
	protect lMailingCode,lDlg,lBdat,lMdat as logic
	// 	protect oPersExist as SQLSelect
	
	declare method CongruenceScore , SplitSurName,SyncPerson,NextImport,MapItems,SearchCorrespondingPersons,Import,ComposeImportName,UpdateBatch
RESOURCE ImportMapping DIALOGEX  9, 8, 439, 419
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", IMPORTMAPPING_SOURCEFILE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_BORDER, 67, 22, 131, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", IMPORTMAPPING_IMPORTFILEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 198, 22, 13, 13
	CONTROL	"", IMPORTMAPPING_TARGETDB, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 289, 22, 132, 36
	CONTROL	"", IMPORTMAPPING_TREEVIEW1, "SysTreeView32", WS_CHILD|WS_BORDER, 16, 44, 196, 305
	CONTROL	"", IMPORTMAPPING_TREEVIEW2, "SysTreeView32", WS_CHILD|WS_BORDER, 226, 44, 196, 305
	CONTROL	"File to import:", IMPORTMAPPING_FIXEDTEXT1, "Static", WS_CHILD, 16, 22, 48, 13
	CONTROL	"Target database:", IMPORTMAPPING_FIXEDTEXT2, "Static", WS_CHILD, 224, 22, 60, 13
	CONTROL	"Drag source fields from left to corresponding target field right", IMPORTMAPPING_EXPLAINTEXT, "Static", SS_CENTER|WS_CHILD|NOT WS_VISIBLE, 16, 3, 404, 10
	CONTROL	"Source", IMPORTMAPPING_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 9, 12, 206, 340
	CONTROL	"Target", IMPORTMAPPING_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 219, 12, 206, 340
	CONTROL	"", IMPORTMAPPING_MCOD1, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 17, 364, 61, 149
	CONTROL	"", IMPORTMAPPING_MCOD2, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 86, 364, 60, 149
	CONTROL	"", IMPORTMAPPING_MCOD3, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 154, 364, 61, 149
	CONTROL	"Default mailing codes for imported records:", IMPORTMAPPING_CODEBOX, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 12, 354, 414, 31
	CONTROL	"Confirm every import record", IMPORTMAPPING_CONFIRMBOX, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 208, 387, 132, 11
	CONTROL	"Replace duplicates with imported values", IMPORTMAPPING_REPLACEDUPLICATES, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 16, 387, 180, 11
	CONTROL	"Show example", IMPORTMAPPING_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 364, 395, 64, 14
	CONTROL	"", IMPORTMAPPING_MCOD4, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 223, 364, 61, 149
	CONTROL	"", IMPORTMAPPING_MCOD5, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 291, 364, 61, 149
	CONTROL	"", IMPORTMAPPING_MCOD6, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 359, 364, 61, 148
	CONTROL	"Accept by system selected corresponding person", IMPORTMAPPING_ACCEPTPROPOSED, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 16, 398, 204, 11
	CONTROL	"", IMPORTMAPPING_IMPORTCOUNT, "Static", SS_CENTERIMAGE|WS_CHILD, 16, 32, 56, 12
END

ACCESS AcceptProposed() CLASS ImportMapping
RETURN SELF:FieldGet(#AcceptProposed)

ASSIGN AcceptProposed(uValue) CLASS ImportMapping
SELF:FieldPut(#AcceptProposed, uValue)
RETURN uValue

Method AnalyzeSurName(cTargetStr,lExists,lOverwrite) class ImportMapping
// check if lastname has to be splitted in lastname, firstname, title
Local aWord as array , lenAW, titPtr as int, Name as string 
Default(@lExists,false)
Default(@lOverwrite,false)
if sEntity=="CZR" .and. lExists
	return   // keep name as it is in case of update because of composed name, firstname, title in CZR
endif 
//	if AScan(self:aMapping,{|x|x[1]==#mFirstName})>0 .or.sEntity#"CZR"
	if oEdit:lFirstName .or.sEntity#"CZR"
		IVarPutSelf(self:oEdit:oPersCnt,#m51_lastname,cTargetStr)
		return
	endif
	aWord:=Split(cTargetStr," ",true)
	lenAW:=Len(aWord)
	if lenAW>2 .and. !oEdit:lSalutation
		titPtr:=AScan(pers_titles,{|x| x[1]==Lower(aWord[lenAW])})
		if titPtr>0
			lenAW--
		endif
		if lOverwrite .or.Empty(IVarGetSelf(oEdit,#mTit)) 
			if titPtr>0
				IVarPutSelf(oEdit,#mTit,pers_titles[titPtr,2])
				IVarPutSelf(self:oEdit:oPersCnt,#m51_title,Lower(aWord[lenAW]))			
			else
				IVarPutSelf(oEdit,#mTit,0)
				IVarPutSelf(self:oEdit:oPersCnt,#m51_title,"")
			endif
		endif
	endif
	if lenAW>1
		if lOverwrite .or.Empty(IVarGetSelf(oEdit,#mFirstname)) 
			IVarPutSelf(oEdit,#mFirstname,aWord[lenAW])
			IVarPutSelf(self:oEdit:oPersCnt,#m51_firstname,aWord[lenAW])
		endif
		lenAW--
	endif 
	Name:=Implode(aWord," ",1,lenAW)
	if lOverwrite .or.Empty(IVarGetSelf(oEdit,#mLastname)) 
		IVarPutSelf(oEdit,#mLastname,Name )
	endif
	IVarPutSelf(self:oEdit:oPersCnt,#m51_lastname,Name)				

	return
method Close(oEvent) class ImportMapping
	//Put your changes here 
	SetAnsi(true) 
   if self:lImportFile .and.!Empty(self:ptrHandle)
   	FClose(self:ptrHandle)
   else
   	if Used()
	   	DBCLOSEAREA()
   	endif
   endif
   DbSetRestoreWorkarea (false) 
// 	self:Destroy()
// 	// force garbage collection
// 	CollectForced()

	RETURN SUPER:Close(oEvent)

Method ComposeImportName(cImpFirstname as string,cImpPfx as string,cImpLastname as string,cImpAd1 as string,cImpPos as string,cImpCity as string,cImpCnr as string,cInitials as string) as string class ImportMapping
return AllTrim(cImpLastname+iif(sSurnameFirst,' ',', ')+iif(Empty(cImpFirstname),iif(Empty(cInitials),'',cInitials+' '),cImpFirstname+' ')+;
iif(Empty(cImpPfx),'',cImpPfx+' ')+", "+iif(Empty(cImpAd1),'',cImpAd1+' ')+iif(Empty(cImpPos),'',cImpPos+' ')+iif(Empty(cImpCity),'',cImpCity+' ')+cImpCnr) 
Method ComposeSelect() class ImportMapping
	// compose statement for retrieval of existing person for synchronising with imported person
	LOCAL i, j, titPtr, typPtr as int  
	Local ID as string,IDs as Symbol
	local cFrom:=" from person as p", CFields,cGroup,cWhere:=" where deleted=0 and p.?" as string, lExtra,lBank,lCod as logic 
	local Fieldname as string
	FOR i:=1 to Len(self:aMapping)
		ID:=Symbol2String(self:aMapping[i,1])
		Fieldname:=Lower(SubStr(ID,2))
		IDs:=String2Symbol(SubStr(ID,2))
		IF SubStr(ID,1,1)=="V"     // extra propertY?
			lExtra:=true
		elseif IDs=#banknumber  // banknumber?
			lBank:=true
		elseIF IDs=#Cod
			lCod:=true
		elseif Lower(SubStr(ID,2))<>'persid' 
			// 			CFields+=iif(Empty(CFields),'',',')+'p.'+SubStr(ID,2) 
			j:=AScan(self:aTargetDB,{|x|x[1]==FieldName})
			if j>0 .and. AtC('date',self:aTargetDB[j,2])>0
				CFields+=iif(Empty(CFields),'',',')+'cast('+Fieldname+' as date) as '+Fieldname
			else
				CFields+=iif(Empty(CFields),'',',')+Fieldname
			endif
		endif
	next
	if lExtra
		CFields+=iif(Empty(CFields),'',',')+'propextr'
	endif
	if lCod.or.!Empty(DefaultCod)
		CFields+=iif(Empty(CFields),'',',')+'mailingcodes'
	endif
	if lBank
		CFields+=iif(Empty(CFields),'',',')+"group_concat(b.banknumber separator ',') as bankaccounts"
		cFrom+=" left join personbank b on (p.persid=b.persid)"
		cGroup:=" group by p.persid"
	endif
	if AtC('persid',CFields)=0   // always retrieve identifier persid
		CFields+=iif(Empty(CFields),'',',')+'p.persid'
	endif
	if AtC('datelastgift',CFields)=0   // always retrieve identifier datelastgift
		CFields+=iif(Empty(CFields),'',',')+'cast(datelastgift as date) as datelastgift'
	endif
	if AtC('firstname',CFields)=0   // always retrieve identifier firstname for congruence score
		CFields+=iif(Empty(CFields),'',',')+'firstname'
	endif
	if AtC('initials',CFields)=0   // always retrieve identifier initials for  congruence score
		CFields+=iif(Empty(CFields),'',',')+'initials'
	endif
	if AtC('creationdate',CFields)=0   // always retrieve identifier creationdate
		CFields+=iif(Empty(CFields),'',',')+'cast(creationdate as date) as creationdate' +sIdentchar
	endif
	if AtC('alterdate',CFields)=0   // always retrieve identifier alterdate
		CFields+=iif(Empty(CFields),'',',')+'cast(alterdate as date) as alterdate'
	endif
	self:cSelectStatement:="select "+Lower(CFields)+cFrom+cWhere+cGroup 
	return

ACCESS ConfirmBox() CLASS ImportMapping
RETURN SELF:FieldGet(#ConfirmBox)

ASSIGN ConfirmBox(uValue) CLASS ImportMapping
SELF:FieldPut(#ConfirmBox, uValue)
RETURN uValue

Method CongruenceScore(oPers as SQLSelect,cImpLastname as string,cImpAddress as string,cImpPos as string,cImpHnr as string, cImpFirstName as string,cImpInitials as string) as int class ImportMapping
// determine measure of correspondence of found person with person to import
//					==		=
// lastname		2		1
//	street		2		1
// zip		 	2     0
//	zip&house#	3		

Local score,MinL,MinP,MinI,scoreFnm,ScoreInt as int
local cDBLastName:=Lower(Compress(oPers:lastname)) as string
local cDBAddress:=Lower(Compress(oPers:address)) as string 
score:=Correspondence(cImpLastname,cDBLastName)/3 
if score>0    // there is some correspondence between last names
	scoreFnm:=Correspondence(oPers:firstname,cImpFirstName)/6
	if scoreFnm<7  // not much firstname Correspondence
		ScoreInt:=Correspondence(oPers:initials,cImpInitials)/10
	endif
	score+=Max(scoreFnm,ScoreInt)
endif
score+=Correspondence(cDBAddress,cImpAddress)/4
if upper(compress(oPers:postalcode))==upper(cImpPos) .and.!Empty(cImpPos)
	if Lower(cImpHnr)==GetStreetHousnbr(cDBAddress)[2]
		score+=20
	else
		score+=10
	endif
endif
return score
 
METHOD Dispatch( oEvent ) CLASS ImportMapping

	LOCAL sDispInfo AS _winNM_LISTVIEW

	IF oEvent:Message == WM_MOUSEMOVE
		IF SELF:lDragging
			SELF:TreeViewDragMove( LoWord( oEvent:lParam ) , HiWord( oEvent:lParam ) )
			RETURN 0
		ENDIF
	ENDIF

	IF oEvent:Message == WM_LBUTTONUP
		IF SELF:lDragging
			SELF:TreeViewDragEnd( LoWord( oEvent:lParam ) , HiWord( oEvent:lParam ) )
			RETURN 0
		ENDIF
	ENDIF

	IF oEvent:Message == WM_NOTIFY
		sDispInfo := PTR( _CAST , oEvent:lParam )
		IF sDispInfo != NULL_PTR
//			IF sDispInfo.hdr._code == DWORD(_CAST,TVN_BEGINDRAG)
			IF sDispInfo.hdr._code == DWORD(TVN_BEGINDRAG)
				SELF:TreeViewDragBegin( oEvent )
				RETURN 0
			ENDIF
		ENDIF
	ENDIF

	RETURN SUPER:Dispatch( oEvent )

Method GetImportvalue(aWord,MapPtr) Class ImportMapping
LOCAL i:=MapPtr, j as int
LOCAL uSrcValue as USUAL
LOCAL cTargetStr as STRING

FOR j:=1 to Len(aMapping[i,2])
	IF self:lImportFile .and. Len(aWord)<aMapping[i,2,j]
		loop
	ENDIF
	if !self:lImportFile
		uSrcValue:= FIELDGET(aMapping[i,2,j])
		uSrcValue:=iif(IsNil(uSrcValue),'',iif(IsNumeric(uSrcValue),Str(uSrcValue,-1),iif(IsLogic(uSrcValue),iif(uSrcValue,'.T.','.F.'),iif(IsDate(uSrcValue),DToC(uSrcValue),ZeroTrim(uSrcValue)))))
	endif
	cTargetStr :=cTargetStr+RTrim(iif(Empty(cTargetStr),""," ")+iif(self:lImportFile,aWord[aMapping[i,2,j]],uSrcValue))
NEXT
return AllTrim(cTargetStr)
METHOD Import(oEdit as DataWindow) as void pascal CLASS ImportMapping
* Import sourcefile to TargetDB
IF self:lImportFile
	IF self:ImportCount<2.and. !Empty(self:ptrHandle)
		FClose(self:ptrHandle)
		self:ptrHandle:=null_ptr
	ENDIF
		
	IF Empty(self:ptrHandle)
		self:ptrHandle:=FOpen(SourceFile,FO_READ)
		IF self:ptrHandle = F_ERROR
			(ErrorBox{,"Could not open file; Error:"+DosErrString(FError())}):show()
			RETURN
		ENDIF
		cBuffer:=FReadLine(self:ptrHandle,4096)   // skip title line
	ENDIF
	cBuffer:=FReadLine(self:ptrHandle,4096) // read first/next data line
	if Empty(cBuffer).and.FEof(self:ptrHandle)
		RETURN
	ENDIF
ELSE
	if Used()
		Source->DBSKIP()   // skip to next record
	else
		IF !DBUSEAREA(,"DBFCDX", SourceFile,"Source",DBEXCLUSIVE)
			RETURN
		ENDIF
	endif
	IF (Source->EOF())
		(ErrorBox{,"Empty import file" }):show()
		RETURN
	ENDIF
ENDIF
// SELF:oEditServer:=oServer
oEdit:lImport:=true 
if self:oDCConfirmBox:Checked
	self:lImportAutomatic:=false
else
	self:lImportAutomatic:=true
endif

IF self:MapItems()==2
	oEdit:CancelButton()
ELSE
// 	if self:lExists .and. self:oCCOKButton:TextValue="Continue" 
// 	endif
	oEdit:Show()
ENDIF
self:oCCOKButton:Caption:="Continue"

RETURN
METHOD ImportFileButton( ) CLASS ImportMapping
	LOCAL oFileDialog AS OpenDialog
	oFileDialog := OpenDialog{SELF,""}
	oFileDialog:Caption:="Select required file to import"
	oFileDialog:SetFilter({"*.dbf","*.txt;*.csv"},{"database","spreadsheet"},2)
	oFileDialog:InitialDirectory:=CurPath
	oFileDialog:SetStyle(OFN_HIDEREADONLY+OFN_LONGNAMES+OFN_EXPLORER)
	IF !oFileDialog:Show()
		RETURN FALSE
	ENDIF
	IF !Empty( oFileDialog:FileName )	
		// Set the instance var...for later use...if Ok
		SourceFile:= oFileDialog:FileName
		SourceFSpec:=Filespec{SourceFile}
		SELF:oDCSourceFile:TextValue:=SourceFile
		SetDefault(CurPath)
		SetPath(CurPath)
		SELF:InitTree()	
	ELSE	
		RETURN FALSE
	ENDIF
RETURN TRUE
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS ImportMapping 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"ImportMapping",_GetInst()},iCtlID)

oDCSourceFile := SingleLineEdit{SELF,ResourceID{IMPORTMAPPING_SOURCEFILE,_GetInst()}}
oDCSourceFile:HyperLabel := HyperLabel{#SourceFile,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSourceFile:TooltipText := "File to be imported"

oCCImportFileButton := PushButton{SELF,ResourceID{IMPORTMAPPING_IMPORTFILEBUTTON,_GetInst()}}
oCCImportFileButton:HyperLabel := HyperLabel{#ImportFileButton,"v","Browse in files",NULL_STRING}
oCCImportFileButton:TooltipText := "Browse in Files"

oDCTargetDB := combobox{SELF,ResourceID{IMPORTMAPPING_TARGETDB,_GetInst()}}
oDCTargetDB:TooltipText := "Target class of data"
oDCTargetDB:HyperLabel := HyperLabel{#TargetDB,NULL_STRING,NULL_STRING,NULL_STRING}

oDCTreeView1 := TreeView{SELF,ResourceID{IMPORTMAPPING_TREEVIEW1,_GetInst()}}
oDCTreeView1:HyperLabel := HyperLabel{#TreeView1,NULL_STRING,NULL_STRING,NULL_STRING}

oDCTreeView2 := TreeView{SELF,ResourceID{IMPORTMAPPING_TREEVIEW2,_GetInst()}}
oDCTreeView2:HyperLabel := HyperLabel{#TreeView2,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{IMPORTMAPPING_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"File to import:",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{IMPORTMAPPING_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Target database:",NULL_STRING,NULL_STRING}

oDCExplainText := FixedText{SELF,ResourceID{IMPORTMAPPING_EXPLAINTEXT,_GetInst()}}
oDCExplainText:HyperLabel := HyperLabel{#ExplainText,"Drag source fields from left to corresponding target field right",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{IMPORTMAPPING_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,"Source",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{IMPORTMAPPING_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Target",NULL_STRING,NULL_STRING}

oDCmCod1 := combobox{SELF,ResourceID{IMPORTMAPPING_MCOD1,_GetInst()}}
oDCmCod1:HyperLabel := HyperLabel{#mCod1,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod1:FillUsing(pers_codes)

oDCmCod2 := combobox{SELF,ResourceID{IMPORTMAPPING_MCOD2,_GetInst()}}
oDCmCod2:HyperLabel := HyperLabel{#mCod2,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod2:FillUsing(pers_codes)

oDCmCod3 := combobox{SELF,ResourceID{IMPORTMAPPING_MCOD3,_GetInst()}}
oDCmCod3:HyperLabel := HyperLabel{#mCod3,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod3:FillUsing(pers_codes)

oDCCodeBox := GroupBox{SELF,ResourceID{IMPORTMAPPING_CODEBOX,_GetInst()}}
oDCCodeBox:HyperLabel := HyperLabel{#CodeBox,"Default mailing codes for imported records:",NULL_STRING,NULL_STRING}

oDCConfirmBox := CheckBox{SELF,ResourceID{IMPORTMAPPING_CONFIRMBOX,_GetInst()}}
oDCConfirmBox:HyperLabel := HyperLabel{#ConfirmBox,"Confirm every import record",NULL_STRING,NULL_STRING}

oDCReplaceDuplicates := CheckBox{SELF,ResourceID{IMPORTMAPPING_REPLACEDUPLICATES,_GetInst()}}
oDCReplaceDuplicates:HyperLabel := HyperLabel{#ReplaceDuplicates,"Replace duplicates with imported values",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{IMPORTMAPPING_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"Show example",NULL_STRING,NULL_STRING}

oDCmCod4 := combobox{SELF,ResourceID{IMPORTMAPPING_MCOD4,_GetInst()}}
oDCmCod4:HyperLabel := HyperLabel{#mCod4,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod4:FillUsing(pers_codes)

oDCmCod5 := combobox{SELF,ResourceID{IMPORTMAPPING_MCOD5,_GetInst()}}
oDCmCod5:HyperLabel := HyperLabel{#mCod5,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod5:FillUsing(pers_codes)

oDCmCod6 := combobox{SELF,ResourceID{IMPORTMAPPING_MCOD6,_GetInst()}}
oDCmCod6:HyperLabel := HyperLabel{#mCod6,NULL_STRING,"Mailing code",NULL_STRING}
oDCmCod6:FillUsing(pers_codes)

oDCAcceptProposed := CheckBox{SELF,ResourceID{IMPORTMAPPING_ACCEPTPROPOSED,_GetInst()}}
oDCAcceptProposed:HyperLabel := HyperLabel{#AcceptProposed,"Accept by system selected corresponding person",NULL_STRING,NULL_STRING}

oDCImportCount := FixedText{SELF,ResourceID{IMPORTMAPPING_IMPORTCOUNT,_GetInst()}}
oDCImportCount:HyperLabel := HyperLabel{#ImportCount,NULL_STRING,NULL_STRING,NULL_STRING}

SELF:Caption := "Mapping of import items on database items"
SELF:HyperLabel := HyperLabel{#ImportMapping,"Mapping of import items on database items",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD InitTree() CLASS ImportMapping
LOCAL oTreeView AS TreeView
LOCAL i,count AS INT
LOCAL Fdname, cBuffer AS STRING
LOCAL oTVItem AS TreeViewItem
LOCAL oTargetItem, oSourceItem as TreeViewItem
local oTargetDB as SQLSelect
LOCAL oImageList as ImageList
LOCAL oSource AS DBFileSpec
//LOCAL aMapping:={} AS ARRAY
LOCAL aStruct:={} AS ARRAY // array with fieldnames
LOCAL lDbf, lTAB, lCSV AS LOGIC
LOCAL ptrHandle
LOCAL aNonImport:={"opc","accid","clc","propextr","propxtra"} as ARRAY
local oGironbr as BANK
LOCAL cRoot := "WYC\Runtime", cMapping as STRING, aMappingSav:={} as array 

aMapping:={}
IF Empty(SourceFile)
	RETURN
ENDIF

// oPersBank:= PersonBank{}  // for bankaccounts of persons
IF Upper(self:SourceFSpec:Extension)=".DBF"
	lDbf:=true 
   DbSetRestoreWorkarea (true)
	oSource:=DbFileSpec{SourceFile,"DBFCDX",{"DBFMEMO"}} 
	self:oDCImportCount:TextValue:=Str(oSource:RecCount,-1)+" records"
// 	IF Comparr(oSource:DbStruct,oTargetDB:DbStruct)
// 		IF (TextBox{SELF, "Import File", "Structure of "+AllTrim(oSource:FileName)+;
// 		" identical to that of "+TargetDB+"; import just as it is?",;
// 		BUTTONYESNO+BOXICONQUESTIONMARK}):Show() ==BOXREPLYYES
// 			FOR i:= 1 TO oSource:FCount
// 				AAdd(aMapping,{String2Symbol("m"+oTargetDB:DbStruct[i,DBS_NAME]),{i}})
// 			NEXT
// 			SELF:lIdentical:=TRUE
// 		    SELF:OKButton()
// 			RETURN
// 		ENDIF
// 	ENDIF
	SetAnsi(oSource:IsAnsi)
	aStruct:=AEvalA(oSource:DbStruct,{|x| x[DBS_NAME]})
   self:lImportFile:=false
ELSE  // tab separated text or CSV
	* determine fieldnames
	ptrHandle:=FOpen(self:SourceFile,FO_READ)
	IF ptrHandle = F_ERROR
		(ErrorBox{,"Could not open file; Error:"+DosErrString(FError())}):show()
		RETURN
	ENDIF
	cBuffer:=FReadLine(ptrHandle,4096)
	IF ptrHandle = F_ERROR.or.FEof(ptrHandle)
		(ErrorBox{,"Could not read file; Error:"+DosErrString(FError())}):show()
		RETURN
	ENDIF
	FClose(ptrHandle)
   self:lImportFile:=true
	IF Upper(self:SourceFSpec:Extension)=".TXT"
		cDelim:=CHR(9)
		lTAB:=TRUE
	ELSE
		lCSV:=TRUE
		cDelim:=Listseparator
	ENDIF
	aStruct:=Split(cBuffer,cDelim,true)
	// replace space in name by underscore:
	aStruct:=AEvalA(aStruct,{|x| StrTran(AllTrim(x)," ","_")})
	self:NbrCol:=Len(aStruct) 
	self:oDCImportCount:TextValue:=Str(Ceil((FileSpec{SourceFile}:Size)/Len(cBuffer)),-1)+" records" 
ENDIF

oTreeView:=SELF:oDCTreeView1
    oTreeView:DeleteAll()
	// Create Image Lists
	oImageList := ImageList{ 3 , Dimension{ 12 , 12 } }

	oImageList:Add( FolderOpen{} )
	oImageList:Add( FolderClose{} )
	oImageList:Add( CardFile{} )


	oTreeView:ImageList := oImageList

	//Put your PostInit additions here

	oTVItem := TreeViewItem{ #Source , "Source" }
	oTVItem:ImageIndex := 1
	oTVItem:SelectedImageIndex := 2
	oTreeView:AddItem( #Root , oTVItem )

	// Source
*	Add fields of source SourceFile:
	FOR i :=1 TO Len(aStruct)
		Fdname:=Lower(aStruct[i])
		oTVItem := TreeViewItem{String2Symbol( FdName) ,Fdname, "SOURCE"+StrZero(i,2), IMID_CARDFILE,IMID_CARDFILE }
		oTreeView:AddItem( #Source , oTVItem )
	NEXT
	oTreeView:Expand(#Root)
	oTreeView:Expand(#Source)
	oTreeView:EnableDragDrop( TRUE )
	oTreeView:SelectItem(#Source)


	// Target
	oTreeView:=SELF:oDCTreeView2
    oTreeView:DeleteAll()
	oTreeView:ImageList := oImageList
	oTVItem := TreeViewItem{ #Target , "Target" }
	oTVItem:ImageIndex := 1
	oTVItem:SelectedImageIndex := 2
	oTreeView:AddItem( #Root , oTVItem )

	* Add fields of target: 
	self:aTargetDB:={}
	oTargetDB:=SQLSelect{"SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, ExTRA FROM information_schema.COLUMNS "+;
		"WHERE TABLE_SCHEMA = '"+dbname+"' and TABLE_NAME='"+Lower(TargetDB)+"' order by ORDINAL_POSITION",oConn}
// 	oSel:=SQLSelect{"SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, ExTRA FROM information_schema.COLUMNS "+;
// 		"WHERE TABLE_SCHEMA = '"+dbname+"' order by TABLE_NAME,ORDINAL_POSITION",oConn}
	if oTargetDB:RecCount<1
		return
	endif
	i:=0
	do while !oTargetDB:EoF
		if AScan(aNonImport,oTargetDB:COLUMN_NAME)==0 
			i++
			Fdname:=oTargetDB:COLUMN_NAME+" of "+TargetDB
			oTVItem := TreeViewItem{String2Symbol( Fdname),oTargetDB:COLUMN_NAME , "TARGET"+StrZero(i,2), IMID_CARDFILE,IMID_CARDFILE }
			oTreeView:AddItem( #Target , oTVItem )
			AAdd(self:aTargetDB,{oTargetDB:COLUMN_NAME,oTargetDB:COLUMN_TYPE,oTargetDB:extra})
		ENDIF
		oTargetDB:Skip()
	enddo
	IF TargetDB=="Person"
		FOR count:=1 TO Len(pers_propextra) STEP 1
			Fdname:=pers_propextra[count,1]+" of Person" 
			i++
			oTVItem := TreeViewItem{String2Symbol(Fdname ),pers_propextra[count,1] , "TARGET"+StrZero(i,2)+"V"+Str(pers_propextra[count,2],-1), IMID_CARDFILE,IMID_CARDFILE }
			oTreeView:AddItem( #Target , oTVItem )
			AAdd(self:aTargetDB,{pers_propextra[count,1],"string",''})
			i++
		NEXT
		// Add bank account:
		Fdname:="banknumber of Person" 
		i++
		oTVItem := TreeViewItem{String2Symbol(Fdname ),"banknumber" , "TARGET"+StrZero(i,2)+"X", IMID_CARDFILE,IMID_CARDFILE }
		oTreeView:AddItem( #Target , oTVItem )
		AAdd(self:aTargetDB,{"banknumber","char(25)",''})
	ENDIF

	oTreeView:Expand(#Root)
	oTreeView:Expand(#Target)
	oTreeView:EnableDragDrop( TRUE )
	SELF:lDragging := FALSE
	SELF:oDCExplainText:Show()

	SELF:Override()
	// restore mapping of last time as far as possible:
	cMapping:=QueryRTRegString( cRoot, "Mapping"+self:TargetDB)
	if !Empty(cMapping)
		aMappingSav := MExec(MCompile("{" + cMapping + "}"))
		FOR i =1 to Len(aMappingSav)
			oTargetItem:=self:oDCTreeView2:GetItemAttributes(String2Symbol(aMappingSav[i,1]))
			if !oTargetItem==null_object
				oSourceItem:=self:oDCTreeView1:GetItemAttributes(String2Symbol(aMappingSav[i,2])) 
				if !oSourceItem==null_object
					self:TransferItem( oSourceItem , oTargetItem ) 
					oTargetItem:Expand(true,true)
				endif
			endif								
		NEXT
	endif
METHOD ListBoxSelect(oControlEvent) CLASS ImportMapping
	LOCAL oControl AS Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControl:NameSym=#TARGETDB
		TargetDB:=oControl:Value
		IF TargetDB="Person"
			oDCCodeBox:Show()
			oDCmCod1:Show()
	    	oDCmCod2:Show()
		    oDCmCod3:Show()
			oDCmCod4:Show()
		    oDCmCod5:Show()
	    	oDCmCod6:Show() 
	    	self:oDCAcceptProposed:show()
		ELSE
			oDCCodeBox:Hide()
			oDCmCod1:Hide()
		    oDCmCod2:Hide()
	    	oDCmCod3:Hide()
			oDCmCod4:Hide()
		    oDCmCod5:Hide()
	    	oDCmCod6:Hide()
	    	self:oDCAcceptProposed:Hide()
		ENDIF
		SELF:InitTree()
	ENDIF
	RETURN NIL
METHOD MapItems(dummy:=nil as logic) as int CLASS ImportMapping
	* Map sourcefile items on Target DB-items of self:oEdit 
	// returns: 0: continue with precessing record, 1: stop and show record, 2: cancel record
	LOCAL i, j, titPtr,exidptr, typPtr, AccNumberPtr,AccIDPtr,nPers as int
	LOCAL uSrcValue, ExId, PERSID,ACCID,ACCNUMBER as USUAL
	LOCAL cTargetStr,ID, cCodes, cCorCln,cMlCod, mOPM as STRING, IDs as symbol
	LOCAL aWord:={}, aCod:={},aBank:={} as ARRAY
	LOCAL myBDAT, myMUTD as date 
	local lStop:=false as logic
	// local aCorCln as array
	LOCAL aNonImport:={#persid,#OPC,#accid,#CLC,#PROPEXTR,#PROPXTRA} as ARRAY 
	local oPersCnt as PersonContainer
	local oAccCnt as AccountContainer
	local obal, oDep,oAcc,oSel as SQLSelect 
	local cCurType as string,lMember as logic

	//oTargetDB:=SELF:Server
	self:lExists:=false
	self:lOverwrite:=self:oDCReplaceDuplicates:Checked 
	IF self:lImportFile
		//cBuffer:=StrTran(StrTran(cBuffer,CR," "),LF," ")
		aWord:=Split(cBuffer,cDelim,true)
		IF (Len(aWord)+8)<SELF:NbrCol
			(ErrorBox{SELF,"nbr("+Str(Len(aWord),-1)+" <-> "+Str(SELF:NbrCol,-1)+") of columns wrong at:"+Implode(aWord,",")}):show()
			SELF:ErrCount++
			//SELF:EndWindow()
			RETURN 2
		ENDIF		
	ENDIF
	ExId:=""
	PERSID:=""

	if self:TargetDB == "Person"
		self:oEdit:lExists:=False 
		PERSID:=''
		ExId=''
		// Check if person already exist with given external or internal id: 
		exidptr:=AScan(self:aMapping,{|x|x[1]==#mExternid})
		self:PersidPtr:=AScan(self:aMapping,{|x|x[1]==#mPersId})
		self:lMailingCode:=(AScan(self:aMapping,{|x|x[1]==#mCod})>0)  
		self:lDlg:=(AScan(self:aMapping,{|x|x[1]==#mDlg})>0)  
		self:lBdat:=(AScan(self:aMapping,{|x|x[1]==#mBdat})>0)  
		self:lMdat:=(AScan(self:aMapping,{|x|x[1]==#mMUTD})>0)  
		oPersCnt:=PersonContainer{}
		if exidptr>0 .and.Empty(self:aPers)
			// read table with persid and externid
			oSel:=SqlSelect{"select persid,externid from person where deleted=0 and externid<>''",oConn}
			if oSel:RecCount>0
				aPers:=oSel:GetLookupTable(100000,#persid,#externid)
			endif
		endif
		IF self:PersidPtr > 0
			IF self:lImportFile
				PERSID:=aWord[aMapping[self:PersidPtr,2,1]]
			else 
				PERSID:=Source->FIELDGET(aMapping[self:PersidPtr,2,1]) 
			endif
			if IsNumeric(PERSID)
				PERSID:=Str(PERSID,-1)
			else
				PERSID:=AllTrim(PERSID)
			endif
			if !isnum(PERSID) .or. Len(PERSID)>11 .or.Empty(val(PersID))
				(ErrorBox{self,"Person number:"+PERSID +" is not a correct!"+CRLF+"Import stopped"}):show()
				return 3
			endif
			if SQLSelect{"select persid from person where persid='"+PERSID+"'",oConn}:RecCount>0
				// Person already in database, so update it:
				self:lExists:=true 
				oPersCnt:PERSID:=PERSID 
			else
				self:lExists:=false 				
			endif
		endif
		if !self:lExists .and. exidptr>0
			IF self:lImportFile
				ExId:=aWord[aMapping[exidptr,2,1]]
			else 
				ExId:=Source->FIELDGET(aMapping[exidptr,2,1]) 
			endif
			if IsNumeric(ExId)
				ExId:=Str(ExId,-1)
			else
				ExId:=ZeroTrim(ExId)
			endif
			if !Empty(ExId)
// 				oSel:= SQLSelect{"select persid,externid from "+Lower(self:TargetDB)+" where externid='"+ExId+"'",oConn}
// 				if oSel:reccount>0
				nPers:=AScan(aPers,{|x|x[2]==ExId})
				if nPers>0   
					// Person already in database, so update it:
					self:lExists:=true 
					self:lOverwrite:=self:oDCReplaceDuplicates:Checked 
					oPersCnt:m51_exid:=ExId
// 					oPersCnt:PERSID:=str(oSel:persid,-1) 
					oPersCnt:PERSID:=Str(aPers[nPers,1],-1) 
				else
					self:lExists:=false
				endif
			endif
		endif  
// 		IF !self:lExists .and.empty(ExId) .and.empty(PERSID)
		IF !self:lExists .and.Empty(ExId) 
			// check if there are already persons with given name and address: 
			cCorCln:=self:SearchCorrespondingPersons(aWord,ExId) 
			if !cCorCln=='0' .and.!Empty(cCorCln)
				if !isnum(cCorCln)
					lStop:=true
				else 
					// Person already in database, so update it:
					self:lExists:=true
					self:lOverwrite:=self:oDCReplaceDuplicates:Checked 
					oPersCnt:PERSID:=cCorCln
				endif
			endif
		endif
		if self:lExists .and.self:lImportAutomatic .and. self:lOverwrite
			if self:oCCOKButton:Caption="Continue"
				// directly storing in database
				oMainWindow:Pointer := Pointer{POINTERHOURGLASS}
				if self:SyncPerson(aWord,oPersCnt)
					return 0  // continue record
				endif 
				lStop:=lStop
			endif
		endif                                  
	elseif self:TargetDB=="Account"
		// check if existing account:
		oAccCnt:=AccountContainer{}
		AccIDPtr:=AScan(self:aMapping,{|x|x[1]==#mAccId}) 
		AccNumberPtr:=AScan(self:aMapping,{|x|x[1]==#mAccNumber})
		if AccIDPtr>0 
			IF self:lImportFile
				ACCID:=aWord[aMapping[AccIDPtr,2,1]]
			else 
				ACCID:=Source->FIELDGET(aMapping[AccIDPtr,2,1]) 
			endif
			if IsNumeric(ACCID)
				ACCID:=Str(ACCID,-1)
			else
				ACCID:=AllTrim(ACCID)
			endif
			if !isnum(ACCID) .or. Len(ACCID)>11 .or.Empty(Val(ACCID))
				(ErrorBox{self,"Account id:"+ACCID +" is not a correct!"+CRLF+"Import stopped"}):show()
				return 3
			endif
			if SQLSelect{"select accid from account where accid='"+ACCID+"'",oConn}:RecCount>0  
				// Account allready in the database, so update it:
				self:lExists:=true 
				self:lOverwrite:=self:oDCReplaceDuplicates:Checked 
				oAccCnt:ACCID:=Str(ACCID,-1)
			endif
		endif
		if !self:lExists .and. AccNumberPtr>0
			IF self:lImportFile
				ACCNUMBER:=aWord[aMapping[AccIDPtr,2,1]]
			else 
				ACCNUMBER:=Source->FIELDGET(aMapping[AccNumberPtr,2,1]) 
			endif
			if IsNumeric(ACCNUMBER)
				ACCNUMBER:=Str(accnumber,-1)
			else
				accnumber:=AllTrim(accnumber)
			endif
			oAcc:=SQLSelect{"select accid from account where accnumber='"+ACCNUMBER+"'",oConn}
			if oAcc:RecCount>0
				// Account allready in the database, so update it:
				self:lExists:=true 
				oAccCnt:ACCID:=Str(oAcc:ACCID,-1)
			endif
			
		endif
	endif
	oMainWindow:Pointer := Pointer{POINTERARROW}

	if self:TargetDB=="Person" .or.!self:lExists 
		* Clear all fields:
		self:oEdit:Reset()
		self:oEdit:mCod:=null_string 
// 		FOR i:=1 to Len(self:aTargetDB)
// 			IF AScan(aNonImport,String2Symbol(self:aTargetDB[i,1]))==0
// 				IDs:=String2Symbol("m"+self:aTargetDB[i,1])
// 				if IsAssign(self:oEdit,IDs)
// 					self:oEdit:FIELDPUT(IDs,null_string)
// 				else
// 					IvarPut(self:oEdit,IDS,null_string)
// 				endif
// 			endif
// 		NEXT
		IF self:TargetDB=="Person"
			// clear also extra properties:
			FOR i:=1 to Len(self:oEdit:aPropEx)
				self:oEdit:aPropEx[i]:Value:=""
			NEXT
			self:oEdit:mBankNumber:=""
			self:oEdit:mBic:=""
			self:oEdit:PostInit(self:Owner,,,true)
			self:oEdit:StateExtra()
			self:oEdit:FIELDPUT(#mtype,"individual")
			self:oEdit:FIELDPUT(#mGender,"unknown")
			self:oEdit:ClearBankAccs() 
		ENDIF
		IF self:TargetDB=="Account"
			IVarPutSelf(self:oEdit,#mDep," ")
			IVarPutSelf(self:oEdit,#mDepartment," ")
		ENDIF
	endif
	// 	logevent(self,"kids before postinit "+str(self:ImportCount,-1)+":"+str(Memory(MEMORY_REGISTERKID),-1),"logdebug")
	if self:lExists 
		if self:TargetDB=="Person" 
			// show as example 
			self:oEdit:lExists:=true
			self:oEdit:PostInit(self:Owner,,,{false,false,self,oPersCnt}) 
			cCurType:=Transform(self:oEdit:mType,"")
			if cCurType=='2' .or. cCurType=='3'
				lMember:=true
			endif
		elseif self:TargetDB=="Account"
			// show as example 
			self:oEdit:PostInit(self:Owner,,,{false,self,oAccCnt})			
		endif
	else
		if self:TargetDB=="Account" 
			self:oEdit:PostInit(self:Owner,,,{true,self,oAccCnt}) // tell oedit it is new 
		endif			
	endif
	// 	logevent(self,"kids after postinit "+str(self:ImportCount,-1)+":"+str(Memory(MEMORY_REGISTERKID),-1),"logdebug")
	IF IsMethod(self:oEdit,#StateExtra) .and. ClassName(self:oEdit)=#NewPersonWindow .and. (self:lOverwrite.or.!self:lExists)  // do not add mailing code when not overwrite
		// add default codes even when mCod not mapped:
		cMlCod:=self:oEdit:mCod
		aCod:=Split(AllTrim(cMlCod)+" "+AllTrim(DefaultCod)," ",true)
		cCodes:=MakeCod(aCod)
		self:oEdit:mCod:=cCodes
	endif
	self:ImportCount++

	*	Fill target fields from source via mapping:
	FOR i:=1 TO Len(SELF:aMapping)
		IDs:=aMapping[i,1]
		ID:=Symbol2String(IDs)
		cTargetStr:=self:GetImportvalue(aWord,i)
		if !Empty(cTargetStr)
			IF SubStr(ID,1,1)=="V"
				// extra property
				j:=AScan(self:oEdit:aPropEx,{|x|x:Name==ID})	
				IF j>0
					IF ClassName(self:oEdit:aPropEx[j])=#COMBOBOX
						self:oEdit:aPropEx[j]:TextValue:=Lower(cTargetStr)
					ELSE
						self:oEdit:aPropEx[j]:Value:=cTargetStr
					ENDIF
				ENDIF				
			ELSE
				IF IDs=#mGender 
					if !IsDigit(psz(_cast,cTargetStr))
						// translate male/female codes to digits:
						IF Lower(cTargetStr)="fa" .or.Lower(cTargetStr)="c" .or. Lower(cTargetStr)="e"
							uSrcValue:=3 // couple
						ELSEIF Lower(cTargetStr)="f" .or.Lower(cTargetStr)="v"
							uSrcValue:=1 // female
						ELSEIF Lower(cTargetStr)="m"
							uSrcValue:=2 // male
						ELSEIF Lower(cTargetStr)="or" .or. Lower(cTargetStr)="n"
							uSrcValue:=4 // non-person
						ELSE					
							uSrcValue:=0 // unknown
						ENDIF
					else
						uSrcValue:=Val(cTargetStr)
					endif
					if self:lOverwrite .or. Empty(IVarGetSelf(self:oEdit,IDs))				
						IVarPutSelf(self:oEdit,IDs,uSrcValue)
					endif
				ELSEIF IDs=#mMailingcodes
					cMlCod:=self:oEdit:mCod
					aCod:=Split(AllTrim(cMlCod)+" "+MakeCod(MakeAbrvCod(AllTrim(cTargetStr)))+" "+AllTrim(DefaultCod)," ",true)
					if !lMember     
						// remove member mailing code from
						if AScan(aCod,'MW')>0
						 	ADel(aCod,AScan(aCod,'MW'))
						endif
					endif
					cCodes:=MakeCod(aCod)
					self:oEdit:mCod:=cCodes
				ELSEIF IDs=#mTitle
					if isnum(cTargetStr)
						titPtr:=AScan(pers_titles,{|x|x[2]==Val(cTargetStr)})
					else
						cTargetStr:=Lower(cTargetStr)
						titPtr:=AScan(pers_titles,{|x|x[1]==cTargetStr})
					endif
					IF titPtr>0
						IVarPutSelf(self:oEdit,IDs,pers_titles[titPtr,2])
					ELSE
						IVarPutSelf(self:oEdit,IDs,0)
					ENDIF
				ELSEIF IDs=#mtype
					if isnum(cTargetStr)
						typPtr:=AScan(pers_types,{|x|x[2]==Val(cTargetStr)})
					else
						cTargetStr:=Lower(cTargetStr)
						typPtr:=AScan(pers_types,{|x|x[1]==Lower(cTargetStr)})
					endif
					IF typPtr>3 .or. typPtr=1
						if !lMember   // no overwriting type of member
							IVarPutSelf(self:oEdit,IDs,pers_types[typPtr,1])
						endif
					ENDIF
				ELSEIF IDs=#mLastname
					if self:lOverwrite .or.Empty(self:oEdit:FIELDGET(#mLastname))
// 						IVarPutSelf(self:oEdit,#mLastname,iif(LSTNUPC,Upper(cTargetStr),cTargetStr))
						self:oEdit:mLastName:=iif(LSTNUPC,Upper(cTargetStr),cTargetStr)
					endif
					// 					self:AnalyzeSurName(cTargetStr,self:lExists,self:lOverwrite)
				ELSEIF IDs=#mCity
// 					if self:lOverwrite .or.Empty(IVarGetSelf(self:oEdit,IDs))
					if self:lOverwrite .or.Empty(self:oEdit:mCity)
// 						IVarPutSelf(self:oEdit,#mCity,iif(CITYUPC,Upper(cTargetStr),cTargetStr))
						self:oEdit:mCity:=iif(CITYUPC,Upper(cTargetStr),cTargetStr)
					endif
				ELSEIF IDs=#mRemarks
// 					mOPM:=AllTrim(IVarGetSelf(self:oEdit,IDs))
// 					mOPM:=mOPM+iif(Empty(mOPM),""," "+CRLF)+cTargetStr
// 					IVarPutSelf(self:oEdit,#mRemarks,mOPM)
					mOPM:=iif(Empty(self:oEdit:FIELDGET(#mRemarks)),'',AllTrim(self:oEdit:FIELDGET(#mRemarks)))
					mOPM:=mOPM+iif(Empty(mOPM),""," "+CRLF)+cTargetStr
					self:oEdit:FIELDPUT(#mRemarks,mOPM)
				elseif IDs=#mbalitemid
					// find balance item
					cTargetStr:=ZeroTrim(cTargetStr) 
					obal:=SQLSelect{"select balitemid,heading,number from balanceitem where number='"+cTargetStr+"' or balitemid='"+cTargetStr+"'",oConn}
					if oBal:RecCount>0 
// 						IVarPutSelf(self:oEdit,#mNumSave,Str(obal:balitemid,-1)) 
// 						IVarPutSelf(self:oEdit,#mbalitemid,obal:number+":"+obal:Heading)
						self:oEdit:mNumSave:=Str(obal:balitemid,-1) 
						self:oEdit:mbalitemid:=obal:number+":"+obal:Heading
						self:oEdit:oAccCnt:m51_balid:=Str(obal:balitemid,-1)
					else
						self:oEdit:FIELDPUT(#mNumSave,"")
						self:oEdit:FIELDPUT(#mbalitemid,"")
// 						IVarPutSelf(self:oEdit,#mNumSave,"") 
// 						IVarPutSelf(self:oEdit,#mbalitemid,"")					
					endif					
				elseif IDs=#mDepartment
					// find department
					cTargetStr:=ZeroTrim(cTargetStr) 
					oDep:=SQLSelect{"select depid,deptmntnbr,descriptn from department where deptmntnbr='"+cTargetStr+"' or depid='"+cTargetStr+"'",oConn}
					if oDep:RecCount>0
// 						IVarPutSelf(self:oEdit,#mDepartment,AllTrim(oDep:DEPTMNTNBR)+":"+oDep:DESCRIPTN)
// 						IVarPutSelf(self:oEdit,#mDep,Str(oDep:DepId,-1))
						self:oEdit:mDepartment:=AllTrim(oDep:DEPTMNTNBR)+":"+oDep:DESCRIPTN
						self:oEdit:mDep:=Str(oDep:DepId,-1)
						self:oEdit:oAccCnt:m51_depid:=Str(oDep:DepId,-1) 
					else
// 						IVarPutSelf(self:oEdit,#mDep,"") 
// 						IVarPutSelf(self:oEdit,#mDepartment,"")					
						self:oEdit:mDep:="" 
						self:oEdit:mDepartment:=""					
					endif
				elseif IDs=#mBankNumber
					aBank:=Split(cTargetStr,,true) 
					for j:=1 to Len(aBank)
						self:oEdit:AddBankAcc(aBank[j])
					next
					
				else 
					if self:lOverwrite .or.Empty(self:oEdit:FIELDGET(IDs)) 
						self:oEdit:FIELDPUT(IDs,cTargetStr)                            
					endif 
				ENDIF
			endif
		ENDIF
		IF self:TargetDB=="Person" .and. !Empty(self:oEdit:oPersCnt)
			IF IDs=#mLastname
				IVarPutSelf(self:oEdit:oPersCnt,#m51_lastname,cTargetStr)
			ELSEIF IDs=#mInitials
				IVarPutSelf(self:oEdit:oPersCnt,#m51_initials,cTargetStr)
			ELSEIF IDs=#mPrefix
				IVarPutSelf(self:oEdit:oPersCnt,#m51_prefix,cTargetStr)
			ELSEIF IDs=#mAddress
				IVarPutSelf(self:oEdit:oPersCnt,#m51_AD1,cTargetStr)
			ELSEIF IDs=#mFirstname
				IVarPutSelf(self:oEdit:oPersCnt,#m51_firstname,cTargetStr)
			ELSEIF IDs=#mPOSTALCODE
				IVarPutSelf(self:oEdit:oPersCnt,#m51_POS,StandardZip(cTargetStr))
			ELSEIF IDs=#mCity
				IVarPutSelf(self:oEdit:oPersCnt,#m51_city,cTargetStr) 
			ELSEIF IDs=#mCountry
				IVarPutSelf(self:oEdit:oPersCnt,#m51_country,cTargetStr) 
			ELSEIF IDs=#mBankNumber
				IVarPutSelf(self:oEdit:oPersCnt,#m56_banknumber,cTargetStr) 
			ELSEIF IDs=#mGender
				IVarPutSelf(self:oEdit:oPersCnt,#m51_gender,cTargetStr) 
			ELSEIF IDs=#mtype
				IVarPutSelf(self:oEdit:oPersCnt,#m51_type,cTargetStr) 			
			ELSEIF IDs=#mTitle
				IVarPutSelf(self:oEdit:oPersCnt,#m51_title,Transform( self:oEdit:mTitle,"XXX"))
			ENDIF				
		ENDIF
	NEXT
	IF IsMethod(self:oEdit,#StateExtra) .and. ClassName(self:oEdit)=#NewPersonWindow
		// add default codes even when mCod not mapped:
		self:oEdit:StateExtra(aMapping)
		if "FI"$cCodes .and. Empty(self:oEdit:FIELDGET(#mDateLastGift))
			self:oEdit:mDateLastGift:=Today()-4000
		ENDIF
		myBDAT:=self:oEdit:FIELDGET(#mCreationDate)
		myMUTD:=self:oEdit:FIELDGET(#mAlterDate)
		IF Empty(myBDAT) .and. !Empty(myMUTD)
			self:oEdit:FIELDPUT(#mCreationDate,SToD("19800101") )
		ELSEIF !Empty(myBDAT) .and. Empty(myMUTD)
			self:oEdit:FIELDPUT(#mAlterDate,myBDAT)
		ELSEIF Empty(myBDAT) .and. Empty(myMUTD)
			self:oEdit:FIELDPUT(#mCreationDate,SToD("19800101"))
			self:oEdit:FIELDPUT(#mAlterDate,SToD("19800101"))		
		ENDIF
		
		IF !Empty(cCodes) .and. Empty(self:oEdit:mCity)
			self:oEdit:FIELDPUT(#mCity,"??")
		ENDIF		
	ENDIF
	if lStop
		Return 1
	else
		Return 0
	endif
ACCESS mCod1() CLASS ImportMapping
RETURN SELF:FieldGet(#mCod1)

ASSIGN mCod1(uValue) CLASS ImportMapping
SELF:FieldPut(#mCod1, uValue)
RETURN uValue

ACCESS mCod2() CLASS ImportMapping
RETURN SELF:FieldGet(#mCod2)

ASSIGN mCod2(uValue) CLASS ImportMapping
SELF:FieldPut(#mCod2, uValue)
RETURN uValue

ACCESS mCod3() CLASS ImportMapping
RETURN SELF:FieldGet(#mCod3)

ASSIGN mCod3(uValue) CLASS ImportMapping
SELF:FieldPut(#mCod3, uValue)
RETURN uValue

ACCESS mCod4() CLASS ImportMapping
RETURN SELF:FieldGet(#mCod4)

ASSIGN mCod4(uValue) CLASS ImportMapping
SELF:FieldPut(#mCod4, uValue)
RETURN uValue

ACCESS mCod5() CLASS ImportMapping
RETURN SELF:FieldGet(#mCod5)

ASSIGN mCod5(uValue) CLASS ImportMapping
SELF:FieldPut(#mCod5, uValue)
RETURN uValue

ACCESS mCod6() CLASS ImportMapping
RETURN SELF:FieldGet(#mCod6)

ASSIGN mCod6(uValue) CLASS ImportMapping
SELF:FieldPut(#mCod6, uValue)
RETURN uValue

METHOD NextImport(oEdit as DataWindow, previoussuccess:=true as logic) as void pascal CLASS ImportMapping 
local action as int // 0: continue, 1: stop with show, 2: cancel record, 3: stop import 
local nTotImprt as int
* Get next import record 
self:Hide()
do while action==0
	if previoussuccess
		if self:lExists
			self:ExistCount++
		else
			self:InsertCount++
		endif
	endif
	nTotImprt:=self:ExistCount+self:InsertCount
	if nTotImprt%200=0
	  	oMainWindow:STATUSMESSAGE("importing record  "+Str(nTotImprt,-1))
	endif 
   if nTotImprt%100==99
   	if Used()
   		Commit
   	endif
   	CollectForced()
   endif
	IF self:ImportCount%300=299
		if Used()
			Commit
		endif
		self:oEdit:Close() 
		self:oEdit:EndWindow()  // recreate oEdit to reset Kids stack 
		CollectForced()
		self:oCCOKButton:Caption:="Resume"
		self:OKButton()
		RETURN
	ENDIF
//    AdoServerCallErrorHandler(false)
// 	AdoServerCallClientError(false) 
	IF self:lImportFile
		cBuffer:=FReadLine(self:ptrHandle,4096)
		IF FEof(ptrHandle).and.Empty(cBuffer)
			FClose(ptrHandle)
			// do automatic updates: 
		  	oMainWindow:STATUSMESSAGE("updating "+Str(self:ExistCount,-1)+" existing persons, please wait...")
			self:UpdateBatch()
		  	oMainWindow:STATUSMESSAGE(Space(100))
			self:oEdit:Hide() 
// 		   AdoServerCallErrorHandler(true)
// 			AdoServerCallClientError(true)  
			oMainWindow:Pointer := Pointer{POINTERARROW}
			IF self:ErrCount>0
				(ErrorBox{,Str(self:ErrCount,-1)+" errors found in importfile. See "+CurPath+"Log.txt FOR details"}):Show()
			else
				LogEvent(self,"File "+self:SourceFSpec:FullPath+" imported:"+Str(self:ExistCount,-1)+" persons updated, "+Str(self:InsertCount,-1)+" added")
				(TextBox{,"Import of file","All records imported: "+Str(self:ExistCount,-1)+" updated, "+Str(self:InsertCount,-1)+" added"}):Show()
			ENDIF
			self:oEdit:EndWindow()
// 			self:oEdit:Close()
			self:EndWindow()
// 			self:Close()
			RETURN 
		ENDIF
	ELSE
		Source->DBDELETE()  // not processed next time
		Source->DBSKIP()
		IF Source->EOF()
			// do automatic updates:
		  	oMainWindow:STATUSMESSAGE("updating "+Str(self:ExistCount,-1)+" existing person, please wait...")
			self:UpdateBatch()
		  	oMainWindow:STATUSMESSAGE(Space(100))
			self:oEdit:Hide() 
			oMainWindow:Pointer := Pointer{POINTERARROW}
			IF self:ErrCount>0
				(ErrorBox{,Str(self:ErrCount,-1)+" errors found in importfile. See "+CurPath+"Log.txt FOR details"}):show()
			else
				LogEvent(self,"File "+self:SourceFSpec:FullPath+" imported:"+Str(self:ExistCount,-1)+" persons updated, "+Str(self:InsertCount,-1)+" added")
				(TextBox{,"Import of file","All records imported: "+Str(self:ExistCount,-1)+" updated, "+Str(self:InsertCount,-1)+" added"}):Show()
			ENDIF 
			self:oEdit:EndWindow()
			self:EndWindow() 
// 			self:Close()
			RETURN 
		ENDIF
	ENDIF

	action:=self:MapItems()
	if action==2
		self:oEdit:cancelButton() 
		oMainWindow:Pointer := Pointer{POINTERARROW}
		exit
	elseif action==1
		self:oEdit:Show() 
		oMainWindow:Pointer := Pointer{POINTERARROW}
		exit 
	elseif action==3  // stop import
		self:oEdit:Close()
// 	   AdoServerCallErrorHandler(true)
// 		AdoServerCallClientError(true) 
			self:oEdit:EndWindow()
// 		self:EndWindow()
		self:Close()
		oMainWindow:Pointer := Pointer{POINTERARROW}
		RETURN 
	ELSE
		if self:lExists .and.self:TargetDB == "Person" .and.self:lImportAutomatic .and. self:lOverwrite
			previoussuccess:=true
			loop
		endif
		IF self:lImportAutomatic
			self:oEdit:Pointer := Pointer{POINTERHOURGLASS}
			Send(self:oEdit,#OKButton)
			self:oEdit:Pointer := Pointer{POINTERARROW}
		ELSE
			self:oEdit:Show()
		ENDIF 
		exit
	ENDIF
enddo
RETURN
METHOD OKButton( ) CLASS ImportMapping
* Start import from source to target:
* aMapping: optionally predefined mapping (Target Fieldnbr, {Source fieldsnbr1, Source filed Nbr 2, ...}}
LOCAL oTargetItem, oSourceItem AS TreeViewItem
LOCAL oTreeView AS TreeView
LOCAL nTargetNbr AS INT
LOCAL aSourceF:={} as ARRAY
Local cRoot := "WYC\Runtime", cMapping as String
IF Empty(aMapping)
	lIdentical:=FALSE
	* Determine mapping:
	oTreeView:=self:oDCTreeView2
	oTargetItem:=oTreeView:GetFirstChildItem(#Target)
	DO WHILE !oTargetItem=null_object 
		nTargetNbr:=Val(SubStr(oTargetItem:value,7,2))
		* Get its childs, i.e. mapped source items:
		oSourceItem:=oTargetItem:FirstChild
		aSourceF:={}
		DO WHILE !oSourceItem=NULL_OBJECT
			AAdd(aSourceF,Val(SubStr(oSourceItem:value,7,2))) 
			// save mapping:
			cMapping+=iif(Empty(cMapping),"",",")+"{'"+Symbol2String(oTargetItem:NameSym)+"','"+Symbol2String(oSourceItem:NameSym)+"'}"
			// next mapping on same target:
			oSourceItem:=oSourceItem:NextSibling
		ENDDO
		IF !Empty(aSourceF)
			IF Len(oTargetItem:VALUE)<9  // no extra property
// 				AAdd(aMapping,{String2Symbol("m"+oTargetDB:DbStruct[nTargetNbr,DBS_NAME]),aSourceF})
				AAdd(aMapping,{String2Symbol("m"+oTargetItem:TextValue),aSourceF})
			elseif SubStr(oTargetItem:value,9,1)="X"
				// banknbr:
				AAdd(aMapping,{String2Symbol("mBankNumber"),aSourceF})
			ELSE
				// extra property:
				AAdd(aMapping,{String2Symbol(SubStr(oTargetItem:value,9)),aSourceF})
				self:lExtra:=true
			ENDIF
		ENDIF
		IF !oTargetItem=oTargetItem:NextSibling
			oTargetItem:=oTargetItem:NextSibling
		ELSE
			oTargetItem:=NULL_OBJECT
		ENDIF
	ENDDO
	IF Empty(aMapping)
		(ErrorBox{SELF,"Nothing mapped"}):show()
		RETURN
	ENDIF
	// save mapping into registry:
	SetRTRegString(cRoot,"Mapping"+self:TargetDB, cMapping)
	// save replaceduplicates:
	SetRTRegString(cRoot,"ReplaceDuplicates", Transform(self:oDCReplaceDuplicates:Checked,"@L"))
	
ENDIF
DefaultCOD := MakeCod({SELF:oDCmCod1:Value,SELF:oDCmCod2:Value,SELF:oDCmCod3:Value,SELF:oDCmCod4:Value,SELF:oDCmCod5:Value,SELF:oDCmCod6:Value})

IF TargetDB=="Person"
	self:oEdit:=NewPersonWindow{self:Owner,,,true} 
	self:oEdit:ReplaceDuplicates:=self:ReplaceDuplicates 
	self:aValues:={} 
	self:aPers:={} 
	self:aFields:={} 
	self:avaluesbank:={} 
	self:lMailingCode:=false
	self:ComposeSelect()  // compose select statement for synchronisation
ELSEIF TargetDB=="Account"
	oEdit:=EditAccount{SELF:Owner,,,TRUE}
ENDIF
oEdit:oImport:=SELF
oEdit:Caption+=" Import"
// AdoServerCallErrorHandler(false)
// AdoServerCallClientError(false)
oEdit:Import(aMapping,oDCConfirmBox:Checked)
return
METHOD PostInit(oParent,uExtra) CLASS ImportMapping
LOCAL cRoot := "WYC\Runtime", cRepDup as STRING
self:SetTexts()
self:oDCTargetDB:FillUsing({{"Persons","Person"},{"Accounts","Account"}})
SELF:oDCTargetDB:TextValue:="Person"
self:TargetDB:="Person"
//self:oDCReplaceDuplicates:Checked:=true
self:ReplaceDuplicates:=true 
cRepDup:=QueryRTRegString( cRoot, "ReplaceDuplicates")
if !Empty(cRepDup)
	self:oDCReplaceDuplicates:Checked:=iif(cRepDup="T",true,false)
endif
// oDep:=Department{,,DBREADONLY} 
// oDep:SetOrder("DEPNBR")
// oBal:=BalanceItem{,,DBREADONLY}
// oBal:SetOrder("BALNUMBR")
RETURN
ACCESS ReplaceDuplicates() CLASS ImportMapping
RETURN SELF:FieldGet(#ReplaceDuplicates)

ASSIGN ReplaceDuplicates(uValue) CLASS ImportMapping
SELF:FieldPut(#ReplaceDuplicates, uValue)
RETURN uValue

method SearchCorrespondingPersons(aWord as array, ExId as string)  as string class ImportMapping
// search persons whose name and/or address corresponds with to be imported person
local CorPersid,cImpNAC,cImpNacL as string
local aCorPers:={} as array  //{full name,persid, rate}
LOCAL LastnamePtr, FirstnamePtr,AddressPtr,PosPtr,PfxPtr,CityPtr,CntryPtr,InitialsPtr, MinL,lnm as int 
Local cImpLastname, cImpFirstname,cImpPfx, cImpAddress, cImpPos,cImpCity, cImpCnr,cImpInitials, cImpHnr, cDbHnr, cNameSearch as string
local oCorSelect as SelectCorrespondingPerson
local oPers as SQLSelect  

// determine name and address of the import person: 
PosPtr:=AScan(self:aMapping,{|x|x[1]==#mPOStalcode})
LastnamePtr:=AScan(self:aMapping,{|x|x[1]==#mLastname})
PfxPtr:=AScan(self:aMapping,{|x|x[1]==#mPrefix})
FirstnamePtr:=AScan(self:aMapping,{|x|x[1]==#mFirstname})
InitialsPtr:=AScan(self:aMapping,{|x|x[1]==#mInitials})
AddressPtr:=AScan(self:aMapping,{|x|x[1]==#mAddress})
CityPtr:=AScan(self:aMapping,{|x|x[1]==#mCity}) 
CntryPtr:=AScan(self:aMapping,{|x|x[1]==#mCountry}) 
if PosPtr>0
	cImpPos:=StandardZip(self:GetImportvalue(aWord,PosPtr))
endif
if LastnamePtr>0
	cImpLastname:=self:GetImportvalue(aWord,LastnamePtr)
endif
if PfxPtr>0
	cImpPfx:=self:GetImportvalue(aWord,PfxPtr)
endif
if InitialsPtr>0
	cImpInitials:=self:GetImportvalue(aWord,InitialsPtr)
endif
if FirstnamePtr>0
	cImpFirstname:=self:GetImportvalue(aWord,FirstnamePtr)
endif
if AddressPtr>0
	cImpAddress:=self:GetImportvalue(aWord,AddressPtr)
	cImpHnr:=AllTrim(array(_cast,GetStreetHousnbr(cImpAddress))[2])
endif
if CityPtr>0
	cImpCity:=self:GetImportvalue(aWord,CityPtr)
endif
if CntryPtr>0
	cImpCnr:=self:GetImportvalue(aWord,CntryPtr)
endif 
// compose full name and address line of person to be imported:
cImpNAC:=self:ComposeImportName(cImpFirstname,cImpPfx,cImpLastname,cImpAddress,cImpPos,cImpCity,cImpCnr,cImpInitials)
cImpNacL:=lower(cImpNAC)
// Search in persons for person with same zipcode
if !Empty(cImpPos) .and.Empty(ExId)
	* search ZIP Code 
// 	oPers:=SQLSelect{"select lastname,firstname,postalcode,persid,address,"+SQLFullNAC(2) +" as fullnac from person where postalcode='"+ cImpPos+"' and "+;
// 	"externid='' and country='"+AllTrim(cImpCnr)+"'",oConn}
	oPers:=SQLSelect{"select lastname,firstname,initials,postalcode,persid,address,"+SQLFullNAC(2) +" as fullnac from person where deleted=0 and postalcode='"+ cImpPos+"' and "+;
	"country='"+AllTrim(cImpCnr)+"'",oConn}
	oPers:Execute()
   do while !oPers:EOF   
   	cDbHnr:=AllTrim(GetStreetHousnbr(oPers:address)[2])
  		MinL:=Min(Len(cDbHnr),Len(cImpHnr)) 
  		if MinL=0 .or. Val(cDbHnr)==Val(cImpHnr)  
   		AAdd(aCorPers, {oPers:FullNAC,oPers:PERSID,iif(Lower(oPers:FullNAC)==cImpNacL,90,self:CongruenceScore(oPers,cImpLastname,cImpAddress,cImpPos,cImpHnr,cImpFirstName,cImpInitials))}) 
  		endif
   	oPers:Skip()
   ENDDO
ENDIF
// Search in persons for person with same name
if !Empty(cImpLastname)
	* search ZIP Code
	cNameSearch:=SubStr(GetTokens(cImpLastname)[1,1],1,6)
	lnm:=Len(cNameSearch)
// 	oPers:=SQLSelect{"select lastname,firstname,postalcode,persid,address,"+SQLFullNAC(2) +" as fullnac from person where lastname like '"+ cNameSearch+"%' and "+;
// 	"externid=''"+iif(Empty(cImpCnr),''," and country='"+AllTrim(cImpCnr)+"' or (address='' and postalcode='' and country='')"),oConn}
	oPers:=SQLSelect{"select lastname,firstname,initials,postalcode,persid,address,"+SQLFullNAC(2) +" as fullnac from person where deleted=0 and lastname like '"+ cNameSearch+"%'"+;
	iif(Empty(cImpCnr),''," and (country='"+AllTrim(cImpCnr)+"' or (address='' and postalcode='' and country=''))"),oConn}
	oPers:Execute()
	lnm:=lnm
   do while !oPers:EOF 
  		if AScan(aCorPers,{|x|x[2]==oPers:PERSID})=0  
   		AAdd(aCorPers, {oPers:FullNAC,oPers:PERSID,iif(Lower(oPers:FullNAC)==cImpNacL,90,self:CongruenceScore(oPers,cImpLastname,cImpAddress,cImpPos,cImpHnr,cImpFirstName,cImpInitials))}) 
		endif
   	oPers:Skip()
   ENDDO
ENDIF
   	
// Search persons for same address (no index!)

// Let user select intended person:
if !Empty(aCorPers) 
	// sort array descending score
	aCorPers:=ASort(aCorPers,,,{|x,y|x[3]>=y[3]})
	// reduce size to 20: 
	ASize(aCorPers,Min(20,Len(aCorPers)))
// 	add element for new person:
	ASize(aCorPers,Len(aCorPers)+1)
	AIns(aCorPers,1)
	aCorPers[1]:={"Not an existing person",0,0}
/*	for i:=1 to Len(aCorCln)
		AAdd(aCorPers,{ oPers:GetFullNAW(aCorCln[i],,3),aCorCln[i]})
	next */
	if self:AcceptProposed .and. aCorPers[2,3]>=55 
		CorPersid:=Str(aCorPers[2,2],-1)
	elseif self:AcceptProposed .and. aCorPers[2,3]<34
		CorPersid:='0'    // not existing person
	else		     // doubt
		oCorSelect:= SelectCorrespondingPerson{self,aCorPers} 
		oCorSelect:AddImportPerson(cImpNAC ) 
		oCorSelect:setAcceptproposed(self:AcceptProposed)
		oCorSelect:show()
		CorPersid:=oCorSelect:SelPersid 
	endif 
endif

return CorPersid
ACCESS SourceFile() CLASS ImportMapping
RETURN SELF:FieldGet(#SourceFile)

ASSIGN SourceFile(uValue) CLASS ImportMapping
SELF:FieldPut(#SourceFile, uValue)
RETURN uValue

Method SplitSurName(cTargetStr as string,lOverwrite as logic,cStatement ref string) as string class ImportMapping
// check if lastname has to be splitted in lastname, firstname, title 
// returns lastname
Local aWord as array , titPtr,WordPtr:=1 as int, Name as string 
if sEntity=="CZR" 
	return cTargetStr  // keep name as it is in case of update because of composed name, firstname, title in CZR
endif 
if self:oEdit:lFirstName .and. self:oEdit:lSalutation 
	return cTargetStr
endif
aWord:=Split(cTargetStr," ",true)
if Len(aWord)>=2 .and. !self:oEdit:lSalutation 
	if lOverwrite .or.Empty(self:oPersExist:Title)
		for WordPtr:=1 to Len(aWord) 
			titPtr:=AScan(pers_titles,{|x| x[1]==Lower(aWord[WordPtr])})
			if titPtr>0
				cStatement+=",title="+Str(pers_titles[titPtr,2],-1)
				ADel(aWord,WordPtr)
				ASize(aWord,Len(aWord)-1)
				exit
			endif
		next
		WordPtr:=1
	endif
endif
if	!self:oEdit:lFirstName .and. WordPtr<Len(aWord)
	if	lOverwrite .or.Empty(self:oPersExist:firstname)	
		cStatement+=",firstname='"+aWord[WordPtr]+"'"				
		ADel(aWord,WordPtr)
		ASize(aWord,Len(aWord)-1)
	endif
endif	
Name:=Implode(aWord," ")
return Name
Method SyncPerson(aWord as array,oPersCnt as PersonContainer ) as logic class ImportMapping
	LOCAL i, j, titPtr, typPtr as int
	LOCAL uSrcValue as USUAL
	LOCAL cTargetStr,ID,Fieldname, cFT,cCity,cCod,cPersid as STRING, IDs as symbol, nID as int
	LOCAL aBank,aBankExist,aCod as ARRAY
	LOCAL myBDAT, myMUTD as date 
	local lExists:=false, lOverwrite:=true, lStop:=false as logic
	LOCAL oXMLDoc as XMLDocument
	LOCAL aNonImport:={#CLN,#OPC,#REK,#CLC,#PROPEXTR,#PROPXTRA} as ARRAY 
	local cStatement as String
	local oStmnt as SQLStatement 
	local oPersExist as SQLSelect 
	local lFillFields:=iif(Empty(self:AFields),true,false) as logic
	local aValueRow:={} as array
	// 	pers_propextra:{AllTrim(oPersProp:NAME), oPersProp:ID,oPersProp:TYPE,Lower(oPersProp:VALUES)} 
	// type: 0:textbox,1:checkbox;3:drop down list
	//	In case of extra properties and mailingcodes the existing person has to be retrieved


	if !Empty(oPersCnt:PERSID) .and. (self:lExtra .or. self:lMailingCode )
		// select existing person 
		oPersExist:=SqlSelect{StrTran(self:cSelectStatement,'p.?',"p.persid="+oPersCnt:PERSID),oConn}
		oPersExist:Execute()
		if	!Empty(oPersExist:Status) .or. oPersExist:RecCount<1
			return false
		endif
		// Contains mapping extra property?
		if self:lExtra
			oXMLDoc:=XMLDocument{oPersExist:PROPEXTR}
		endif
	endif 
	cPersid:=oPersCnt:PERSID

	if lFillFields .and. self:PersidPtr=0
		// assemble fieldnames for insert statement after last record read in NextImport
		AAdd(self:aFields,'persid')
	endif 
	if self:PersidPtr=0
		AAdd(aValueRow,cPersid)   	
	endif		
	*	Fill target fields from source via mapping:
	FOR i:=1 to Len(self:aMapping)
		ID:=Symbol2String(aMapping[i,1])
		Fieldname:=Lower(SubStr(ID,2))
		IDs:=String2Symbol(FieldName)	
		cTargetStr:=AddSlashes(self:GetImportvalue(aWord,i))
		if !self:lExtra.and. !self:lMailingCode .or. !Empty(cTargetStr)
			IF SubStr(ID,1,1)=="V" .and.!Empty(cTargetStr)
				nID:=Val(FieldName)
				// extra property Str(pers_propextra[count,2],-1)
				j:=AScan(pers_propextra,{|x|x[2]==nID})	
				IF j>0
					IF !pers_propextra[j,3]=3 .or.AScan(Split(pers_propextra[j,4],","),Lower(cTargetStr))>0  //drop down
						// fill into extra properties:
						if oXMLDoc:GetElement(ID)
							if lOverwrite.or.Empty(oXMLDoc:GetContentCurrentElement()) 
								oXMLDoc:UpdateContentCurrentElement(Lower(cTargetStr))
							endif
						else
							oXMLDoc:AddElement(ID,Lower(cTargetStr),"velden")
						endif
					ENDIF
				ENDIF				
			ELSE
				IF IDs=#Gender 
					if !IsDigit(psz(_cast,cTargetStr))
						// translate male/female codes to digits:
						IF Lower(cTargetStr)="fa" .or.Lower(cTargetStr)="c" .or. Lower(cTargetStr)="e"
							uSrcValue:=3 // couple
						ELSEIF Lower(cTargetStr)="f" .or.Lower(cTargetStr)="v"
							uSrcValue:=1 // female
						ELSEIF Lower(cTargetStr)="m"
							uSrcValue:=2 // male
						ELSEIF Lower(cTargetStr)="or" .or. Lower(cTargetStr)="n"
							uSrcValue:=4 // non-person
						ELSE					
							uSrcValue:=0 // unknown
						ENDIF
					else
						uSrcValue:=Val(cTargetStr)
					endif
					if lFillFields
						AAdd(self:aFields,'gender')
					endif
					AAdd(aValueRow,AllTrim(Transform(uSrcValue,"")))
				ELSEIF IDs=#Cod
					if lFillFields
						AAdd(self:aFields,'mailingcodes')
					endif
					aCod:=MakeAbrvCod(cTargetStr)
					AAdd(aValueRow,MakeCod(Split(iif(Empty(aCod),'',MakeCod(aCod)+' ')+iif(Empty(DefaultCod),'',AllTrim(DefaultCod)),,true)))
				ELSEIF IDs=#Titel
					if lFillFields
						AAdd(self:aFields,'title')
					endif
					titPtr:=1
					if isnum(cTargetStr)
						titPtr:=AScan(pers_titles,{|x|x[2]==Val(cTargetStr)})
					else
						cTargetStr:=Lower(cTargetStr)
						titPtr:=AScan(pers_titles,{|x|x[1]==cTargetStr})
					endif
					AAdd(aValueRow,Str(pers_titles[titPtr,2],-1))
				ELSEIF IDs=#type
					if lFillFields
						AAdd(self:aFields,'type')
					endif
					typPtr:=0
					if isnum(cTargetStr)
						typPtr:=AScan(pers_types,{|x|x[2]==Val(cTargetStr)})
					else
						cTargetStr:=Lower(cTargetStr)
						typPtr:=AScan(pers_types,{|x|x[1]==Lower(cTargetStr)})
					endif
					AAdd(aValueRow,Str(iif(typPtr>0,pers_types[typPtr,2],0),-1))
				ELSEIF IDs=#lastname
					if lFillFields
						AAdd(self:aFields,'lastname')
					endif
					AAdd(aValueRow,iif(LSTNUPC,Upper(cTargetStr),cTargetStr))
				ELSEIF IDs=#city
					if lFillFields
						AAdd(self:aFields,'city')
					endif
					if Empty(cTargetStr) .and. self:lMailingCode 
						cTargetStr:='??'
					endif
					AAdd(aValueRow,iif(CITYUPC,Upper(cTargetStr),cTargetStr))
				ELSEIF IDs=#REMARKS
					if lFillFields
						AAdd(self:aFields,'remarks')
					endif
					AAdd(aValueRow,cTargetStr)
				ELSEIF IDs=#EXTERNID
					if lFillFields
						AAdd(self:aFields,'externid')
					endif
					AAdd(aValueRow,ZeroTrim(cTargetStr))
				ELSEIF IDs=#banknumber 
					aBank:=Split(cTargetStr,,true)
					for j:=1 to Len(aBank)
						AAdd(self:avaluesbank,{cPersid,aBank[j],GetBIC(aBank[j])})
					next
				ELSE 
					if lFillFields
						AAdd(self:aFields,FieldName)
					endif
					j:=AScan(self:aTargetDB,{|x|x[1]==FieldName})
					if j>0
						cFT:=self:aTargetDB[j,2]
						DO CASE
						case AtC('tinyint(1)',cFT)>0
							AAdd(aValueRow,iif(cTargetStr="1".or.Upper(cTargetStr)='.T','1','0'))
						case AtC('int',cFT)>0 .or.AtC('int',cFT)>0
							AAdd(aValueRow,cTargetStr)
						case AtC('date',cFT)>0
							if Val(cTargetStr)>10000000
								AAdd(aValueRow,SQLdate(SToD(cTargetStr)))				
							elseif IsDigit(psz(_cast,cTargetStr))
								AAdd(aValueRow,SQLdate(CToD(cTargetStr)))
							else				
								AAdd(aValueRow,cTargetStr)
							endif
						OTHERWISE  // character
							AAdd(aValueRow,cTargetStr)
						endcase
					endif	
				ENDIF
			endif
		ENDIF
	NEXT

	if	self:lExtra
		if lFillFields
			AAdd(self:aFields,'propextr')
		endif
		AAdd(aValueRow,oXMLDoc:GetBuffer())
	endif
// 	if !self:lMailingCode .and.!Empty(self:DefaultCod)
// 		if lFillFields
// 			AAdd(self:AFields,'mailingcodes')
// 		endif
// 		AAdd(aValueRow,makecod(split(iif(empty(oPersExist:mailingcodes),'',oPersExist:mailingcodes+" ")+self:DefaultCod)))
// 	endif
	AAdd(self:aValues,aValueRow)
	return true
ACCESS TargetDB() CLASS ImportMapping
RETURN SELF:FieldGet(#TargetDB)

ASSIGN TargetDB(uValue) CLASS ImportMapping
SELF:FieldPut(#TargetDB, uValue)
RETURN uValue

METHOD TransferItem( oTVItemDrag , oTVItemDrop ) CLASS ImportMapping
	LOCAL oTVItem AS TreeViewItem
	LOCAL CurItem AS SYMBOL
	LOCAL oTreeView AS TreeView
	LOCAL lSuccess AS LOGIC
	oTreeView:=oTVItemDrop:TreeViewControl

	oTVItemDrag:TreeViewControl:DeleteItem( oTVItemDrag:NameSym )
	IF oTVItemDrop:NameSym=#Source // Repostion back to source?
		* determine previous item:
		 oTVItem:=oTVItemDrop:FirstChild
		IF oTvItem=NULL_OBJECT.or.oTVItem:Value>oTVItemDrag:Value
			oTreeView:InsertItem( oTVItemDrop:NameSym, #First , oTVItemDrag )
		ELSE
			DO WHILE !oTVItem=NULL_OBJECT
				CurItem:=oTVItem:NameSym
		 		oTVItem:=oTVItem:NextSibling
				IF oTvItem=NULL_OBJECT.or.oTVItem:Value>oTVItemDrag:Value
					oTreeView:InsertItem( oTVItemDrop:NameSym, CurItem, oTVItemDrag)
					EXIT
				ENDIF
			ENDDO
		ENDIF
	ELSE
		lSuccess:=oTreeView:AddItem( oTVItemDrop:NameSym , oTVItemDrag )
	ENDIF
RETURN

METHOD TreeViewDragBegin( oEvent ) CLASS ImportMapping

	LOCAL ptAction IS _WINPoint
	LOCAL hTV1 AS PTR
	LOCAL hTV2 AS PTR
	LOCAL sNMTV AS _WINNM_TreeView
	LOCAL hItem AS PTR

	hTV1 := SELF:oDCTreeView1:Handle()
	hTV2 := SELF:oDCTreeView2:Handle()

	sNMTV := PTR( _CAST , oEvent:lParam )
	hItem := sNMTV.itemNew.hItem

	GetCursorPos( @ptAction )

	ScreenToClient( hTV1 , @ptAction )

	SELF:oTVItemDrag := SELF:oDCTreeView1:GetItemAttributes( SELF:oDCTreeView1:__GetSymbolFromHandle( hItem ) )
	IF oTVItemDrag==NULL_OBJECT
		* Targetview drag:
		SELF:oTVItemDrag := SELF:oDCTreeView2:GetItemAttributes( SELF:oDCTreeView2:__GetSymbolFromHandle( hItem ) )
		IF oTVItemDrag==NULL_OBJECT
			RETURN
		ENDIF
		IF SELF:oTVItemDrag:NameSym= #Target.or.SELF:oTVItemDrag:Value="TARGET"
			SELF:oTVItemDrag := NULL_OBJECT
			RETURN
		ENDIF
		SELF:hImageList := TreeView_CreateDragImage( hTV2 , hItem )
	ELSE
		IF SELF:oTVItemDrag:NameSym = #Source
			SELF:oTVItemDrag := NULL_OBJECT
			RETURN
		ENDIF
		SELF:hImageList := TreeView_CreateDragImage( hTV1 , hItem )
	ENDIF
	SELF:lDragging := TRUE

	SELF:oTVItemDrop := NULL_OBJECT

	ImageList_SetDragCursorImage( SELF:hImageList , 0 , 0 , 0 )
	ImageList_BeginDrag( SELF:hImageList , 0 , 0 , 0 )
	ImageList_DragMove( ptAction.X , ptAction.Y )
	ImageList_DragEnter( SELF:Handle() , ptAction.X , ptAction.Y )

	SetCapture( SELF:Handle() )

	RETURN NIL

METHOD TreeViewDragEnd( X , Y ) CLASS ImportMapping

	ImageList_DragLeave( SELF:Handle() )
	ImageList_EndDrag()

	ReleaseCapture()
	SELF:lDragging := FALSE

	IF oTVItemDrop != NULL_OBJECT
		oTVItemDrop:TreeViewControl:SelectItem( #NULL , #DropHighlight , FALSE )
		IF SELF:oTVItemDrag:Value != SELF:oTVItemDrop:Value
			SELF:TransferItem( SELF:oTVItemDrag , SELF:oTVItemDrop )
		ENDIF
		oTVItemDrop:TreeViewControl:SelectItem( SELF:oTVItemDrag:NameSym )
		SELF:oTVItemDrop := NULL_OBJECT
	ENDIF

	SELF:oTVItemDrag := NULL_OBJECT
	RETURN NIL
METHOD TreeViewDragMove( X , Y ) CLASS ImportMapping

	LOCAL hTV AS PTR
	LOCAL oTreeView1 AS TreeView
	LOCAL oTreeView2 AS TreeView
	LOCAL oTVItem AS TreeViewItem
	LOCAL r IS _WINRect
	LOCAL lCanDrop AS LOGIC
	LOCAL nTargetNbr, nExtraNbr,i AS INT
	LOCAL Xorig, Yorig AS INT

	oTreeView1:=SELF:oDCTreeView1
	oTreeView2:=SELF:oDCTreeView2

	// Modify X and Y
	Xorig:=X
	Yorig:=Y
	hTV := oTreeView1:Handle()
	X := X-oTreeView1:Origin:X-2  // Subtract Frame Size
	Y := Y-oTreeView1:Origin:Y+45

	ImageList_DragMove( X , Y )

	GetClientRect( oTreeView1:Handle() , @r )
	IF ( X < 0 .or. Y < 0 .or. X > r.right .or. Y > r.bottom )  // outside source pane?
		* Target pane?
		// Modify X and Y
		X:=Xorig
		Y:=Yorig
		hTV := oTreeView2:Handle()
		X := X-oTreeView2:Origin:X-2  // Subtract Frame Size
		Y := Y-oTreeView2:Origin:Y+45
		oTVItem := oTreeView2:GetItemAtPosition( Point{ X , oTreeView2:Size:Height - Y } )
		GetClientRect( hTV , @r )
	ELSE
*		oTVItem := oTreeView1:GetItemAtPosition( Point{ X , oTreeView1:Size:Height - Y } )
		* back to source is always to top item:
		oTVItem:=  oTreeView1:GetItemAttributes(#Source)
	ENDIF

	IF ( X < 0 .or. Y < 0 .or. X > r.right .or. Y > r.bottom )  // outside any pane?
		lCanDrop := FALSE
	ELSEIF oTVItem = NULL_OBJECT
		lCanDrop := FALSE
	ELSEIF !(oTVItem:NameSym==#Source.or.oTVItem:Value="TARGET")
		* do only drop on source or target-item:
		lCanDrop := FALSE
	ELSE
		lCanDrop := TRUE
		IF oTVItem:Value="TARGET"
			* check if allready items assigned to it and not string:
			nTargetNbr:=Val(SubStr(oTVItem:value,7,2))
			IF Len(oTVItem:value)<9  // no extra property
				IF  AtC('char',self:aTargetDB[nTargetNbr,2])=0 .and.AtC('text',self:aTargetDB[nTargetNbr,2])=0 // no string?
					IF !Empty(oTVItem:FirstChild)
						* allready source item assigned, no more possible:
						lCanDrop := FALSE
					ENDIF
				ENDIF
			ELSEIF SubStr(oTVItem:Value,8,1)=="X"
				// bankaccount:
				IF !Empty(oTVItem:FirstChild)
					* allready source item assigned, no more possible:
					lCanDrop := FALSE
				ENDIF
			ELSE
				// extra property:
				IF !Empty(oTVItem:FirstChild)
					nExtraNbr:=Val(SubStr(oTVItem:value,10))
					IF (i:=AScan(pers_propextra,{|x|x[2]==nExtraNbr}))>0
						IF !pers_propextra[i,3]==TEXTBX
							* allready source item assigned, no more possible:
							lCanDrop := FALSE
						ENDIF
					ENDIF
				ENDIF					
			ENDIF
		ENDIF
	ENDIF

	ImageList_DragLeave(SELF:Handle() )
	IF oTVItem != NULL_OBJECT .and. lCanDrop
		SetCursor( LoadCursor( NULL , IDC_ARROW ) )
		 oTVItem:TreeViewControl:SelectItem( oTVItem:NameSym , #DropHighlight )
		SELF:oTVItemDrop := oTVItem
	ELSE
		SetCursor( LoadCursor( NULL , IDC_NO ) )
		IF !SELF:oTVItemDrop = NULL_OBJECT
			SELF:oTVItemDrop:TreeViewControl:SelectItem( NULL_SYMBOL , #DropHighlight )
			SELF:oTVItemDrop := NULL_OBJECT
		ENDIF
	ENDIF
	ImageList_DragEnter( hTV , X , Y )
*	ImageList_DragEnter(SELF:Handle() , Xorig , Yorig )

	RETURN NIL



method UpdateBatch(dummy:=nil as logic) as logic class ImportMapping
// perform batch update of persons
local oStmnt as SQLStatement
local cUpdateStatement as String
local i,j as int 
local time0,time1 as DWORD
local aCod:={} as array


	if !Empty(self:AFields) .and.!Empty(self:aValues) 
		time0:=Seconds()
		// compose update logic:
		for i:=1 to len(self:aFields)
			do case
			case self:AFields[i]=='persid'
// 			case self:AFields[i]=='mailingcodes'
// 				cUpdateStatement+=',mailingcodes=if(values(mailingcodes)<>"",concat(values(mailingcodes)," ",mailingcodes),mailingcodes)'+iif(AScanExact(self:AFields,'city')=0,',city=if(city="","??",city)','')	
			case self:AFields[i]=='type'
				cUpdateStatement+=',type=if(type=2 or type=3 or values(type)="",type,values(type))'	
			case self:AFields[i]=='remarks'
				cUpdateStatement+=',remarks=if(values(remarks)<>"" and instr(remarks,values(remarks))=0,concat(remarks,char(10),values(remarks)),values(remarks))'
			otherwise
				cUpdateStatement+=','+self:AFields[i]+'=if(values('+self:AFields[i]+')<>"",values('+self:AFields[i]+'),'+self:AFields[i]+')'
			endcase
		NEXT
		if !self:lMailingCode .and.!Empty( self:DefaultCOD)
			// add code for adding default codes
			aCod:=Split(AllTrim(DefaultCod)," ",true)
			cUpdateStatement+=",mailingcodes=concat(concat(mailingcodes,' ')"
			FOR j:=1 to Len(aCod)
				cUpdateStatement+=",if(instr(mailingcodes,'"+aCod[j]+"')>0,'','"+aCod[j]+" ')"	
			next
			cUpdateStatement+=")"
		endif
		oStmnt:=SQLStatement{"INSERT INTO person ("+Implode(self:AFields,',')+") values "+Implode(self:aValues,"','")+;
		" ON DUPLICATE KEY UPDATE "+SubStr(cUpdateStatement,2),oConn}
		oStmnt:Execute()
		if !Empty(oStmnt:Status)
			LogEvent(self,"error:"+oStmnt:Status:description+" in update persons statement"+CRLF+"Stmnt:"+oStmnt:sqlstring,"LogErrors")
			return false
		endif
		time1:=time0 
// 		LogEvent(self,"time batch update:"+Str((time0:=Seconds())-time1,-1)+' sec',"logsql")
	endif
	if !Empty(self:avaluesbank)
		oStmnt:=SQLStatement{'insert ignore into personbank (persid,banknumber,bic) values '+Implode(self:avaluesbank,"','"),oConn}
		oStmnt:Execute()
		if !Empty(oStmnt:Status)
			LogEvent(self,"error:"+oStmnt:Status:description+" in update bank statement","LogErrors")
			return false
		endif
	endif
return true
 
STATIC DEFINE IMPORTMAPPING_ACCEPTPROPOSED := 120 
STATIC DEFINE IMPORTMAPPING_CODEBOX := 113 
STATIC DEFINE IMPORTMAPPING_CONFIRMBOX := 114 
STATIC DEFINE IMPORTMAPPING_EXPLAINTEXT := 107 
STATIC DEFINE IMPORTMAPPING_FIXEDTEXT1 := 105 
STATIC DEFINE IMPORTMAPPING_FIXEDTEXT2 := 106 
STATIC DEFINE IMPORTMAPPING_GROUPBOX1 := 108 
STATIC DEFINE IMPORTMAPPING_GROUPBOX2 := 109 
STATIC DEFINE IMPORTMAPPING_IMPORTCOUNT := 121 
STATIC DEFINE IMPORTMAPPING_IMPORTFILEBUTTON := 101 
STATIC DEFINE IMPORTMAPPING_MCOD1 := 110 
STATIC DEFINE IMPORTMAPPING_MCOD2 := 111 
STATIC DEFINE IMPORTMAPPING_MCOD3 := 112 
STATIC DEFINE IMPORTMAPPING_MCOD4 := 117 
STATIC DEFINE IMPORTMAPPING_MCOD5 := 118 
STATIC DEFINE IMPORTMAPPING_MCOD6 := 119 
STATIC DEFINE IMPORTMAPPING_OKBUTTON := 116 
STATIC DEFINE IMPORTMAPPING_REPLACEDUPLICATES := 115 
STATIC DEFINE IMPORTMAPPING_SOURCEFILE := 100 
STATIC DEFINE IMPORTMAPPING_TARGETDB := 102 
STATIC DEFINE IMPORTMAPPING_TREEVIEW1 := 103 
STATIC DEFINE IMPORTMAPPING_TREEVIEW2 := 104 
STATIC DEFINE IMPORTMAPPINGOLD_CODEBOX := 113 
STATIC DEFINE IMPORTMAPPINGOLD_CONFIRMBOX := 114 
STATIC DEFINE IMPORTMAPPINGOLD_EXPLAINTEXT := 107 
STATIC DEFINE IMPORTMAPPINGOLD_FIXEDTEXT1 := 105 
STATIC DEFINE IMPORTMAPPINGOLD_FIXEDTEXT2 := 106 
STATIC DEFINE IMPORTMAPPINGOLD_GROUPBOX1 := 108 
STATIC DEFINE IMPORTMAPPINGOLD_GROUPBOX2 := 109 
STATIC DEFINE IMPORTMAPPINGOLD_IMPORTFILEBUTTON := 101 
STATIC DEFINE IMPORTMAPPINGOLD_MCOD1 := 110 
STATIC DEFINE IMPORTMAPPINGOLD_MCOD2 := 111 
STATIC DEFINE IMPORTMAPPINGOLD_MCOD3 := 112 
STATIC DEFINE IMPORTMAPPINGOLD_MCOD4 := 116 
STATIC DEFINE IMPORTMAPPINGOLD_MCOD5 := 117 
STATIC DEFINE IMPORTMAPPINGOLD_MCOD6 := 118 
STATIC DEFINE IMPORTMAPPINGOLD_OKBUTTON := 115 
STATIC DEFINE IMPORTMAPPINGOLD_SOURCEFILE := 100 
STATIC DEFINE IMPORTMAPPINGOLD_TARGETDB := 102 
STATIC DEFINE IMPORTMAPPINGOLD_TREEVIEW1 := 103 
STATIC DEFINE IMPORTMAPPINGOLD_TREEVIEW2 := 104 
RESOURCE SelectCorrespondingPerson DIALOGEX  8, 21, 342, 227
STYLE	DS_3DLOOK|WS_POPUP|WS_CAPTION|WS_SYSMENU|WS_THICKFRAME
CAPTION	"Select corresponding person"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Fixed Text", SELECTCORRESPONDINGPERSON_IMPTEXT, "Static", WS_CHILD, 8, 18, 328, 22
	CONTROL	"", SELECTCORRESPONDINGPERSON_CORPERSONS, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 0, 59, 340, 144, WS_EX_CLIENTEDGE
	CONTROL	"Select", SELECTCORRESPONDINGPERSON_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 288, 210, 53, 12
	CONTROL	"Corresponds with the following already existing person (in order of likelihood):", SELECTCORRESPONDINGPERSON_FIXEDTEXT1, "Static", WS_CHILD, 2, 44, 274, 12
	CONTROL	"The person to be imported:", SELECTCORRESPONDINGPERSON_FIXEDTEXT2, "Static", WS_CHILD, 2, 3, 182, 12
	CONTROL	"Accept by system selected corresponding person for all remaining persons", SELECTCORRESPONDINGPERSON_ACCEPTPROPOSED, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 4, 210, 260, 11
END

CLASS SelectCorrespondingPerson INHERIT DialogWinDowExtra 

	PROTECT oDCImpText AS FIXEDTEXT
	PROTECT oDCCorPersons AS LISTBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCAcceptProposed AS CHECKBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  export SelPersid as string
  protect myParent as ImportMapping 
  
  declare method AddImportPerson,SetAcceptproposed
Method AddImportPerson(cImpNAC) as void pascal class SelectCorrespondingPerson
self:oDCImpText:TextValue:= cImpNAC
return
METHOD Init(oParent,uExtra) CLASS SelectCorrespondingPerson 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"SelectCorrespondingPerson",_GetInst()},TRUE)

oDCImpText := FixedText{SELF,ResourceID{SELECTCORRESPONDINGPERSON_IMPTEXT,_GetInst()}}
oDCImpText:HyperLabel := HyperLabel{#ImpText,"Fixed Text",NULL_STRING,NULL_STRING}
oDCImpText:OwnerAlignment := OA_PWIDTH

oDCCorPersons := ListBox{SELF,ResourceID{SELECTCORRESPONDINGPERSON_CORPERSONS,_GetInst()}}
oDCCorPersons:HyperLabel := HyperLabel{#CorPersons,NULL_STRING,"Persons already in the database that correspond with the person to be imported",NULL_STRING}
oDCCorPersons:UseHLforToolTip := True
oDCCorPersons:OwnerAlignment := OA_PWIDTH_PHEIGHT

oCCOKButton := PushButton{SELF,ResourceID{SELECTCORRESPONDINGPERSON_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"Select",NULL_STRING,NULL_STRING}
oCCOKButton:OwnerAlignment := OA_PY

oDCFixedText1 := FixedText{SELF,ResourceID{SELECTCORRESPONDINGPERSON_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Corresponds with the following already existing person (in order of likelihood):",NULL_STRING,NULL_STRING}
oDCFixedText1:TextColor := Color{COLORBLUE}

oDCFixedText2 := FixedText{SELF,ResourceID{SELECTCORRESPONDINGPERSON_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"The person to be imported:",NULL_STRING,NULL_STRING}
oDCFixedText2:TextColor := Color{COLORBLUE}

oDCAcceptProposed := CheckBox{SELF,ResourceID{SELECTCORRESPONDINGPERSON_ACCEPTPROPOSED,_GetInst()}}
oDCAcceptProposed:HyperLabel := HyperLabel{#AcceptProposed,"Accept by system selected corresponding person for all remaining persons",NULL_STRING,NULL_STRING}
oDCAcceptProposed:OwnerAlignment := OA_PY

SELF:Caption := "Select corresponding person"
SELF:HyperLabel := HyperLabel{#SelectCorrespondingPerson,"Select corresponding person",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS SelectCorrespondingPerson 
self:SelPersid:=Str(oDCCorPersons:GetItemValue(oDCCorPersons:CurrentItemNo),-1)
self:myParent:AcceptProposed:=self:oDCAcceptProposed:Checked
self:EndDialog(0)
RETURN NIL
method PostInit(oParent,uExtra) class SelectCorrespondingPerson
	//Put your PostInit additions here 
	local aCorPers:={} as array
	self:SetTexts()
	AEval(uExtra,{|x|AAdd(aCorPers,{x[1]+' ('+Str(x[3],-1)+')',x[2]})})	
// 	AEval(uExtra,{|x|AAdd(aCorPers,{x[1],x[2]})})	
	self:oDCCorPersons:FillUsing(aCorPers) 
	self:oDCCorPersons:CurrentItemNo:=2
	if uExtra[2,3]<44
		self:oDCCorPersons:CurrentItemNo:=1
	endif		 
	self:SelPersid:=Replicate("a",LENPRSID)
	return nil 
method PreInit(oParent,uExtra) class SelectCorrespondingPerson
	//Put your PreInit additions here 
	self:myParent:=oParent
	return NIL

method SetAcceptproposed(lSet as logic) as void pascal class SelectCorrespondingPerson
self:oDCAcceptProposed:Checked:=lSet
return

STATIC DEFINE SELECTCORRESPONDINGPERSON_ACCEPTPROPOSED := 105 
STATIC DEFINE SELECTCORRESPONDINGPERSON_CORPERSONS := 101 
STATIC DEFINE SELECTCORRESPONDINGPERSON_FIXEDTEXT1 := 103 
STATIC DEFINE SELECTCORRESPONDINGPERSON_FIXEDTEXT2 := 104 
STATIC DEFINE SELECTCORRESPONDINGPERSON_IMPTEXT := 100 
STATIC DEFINE SELECTCORRESPONDINGPERSON_OKBUTTON := 102 
