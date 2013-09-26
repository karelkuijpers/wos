CLASS EditImportPattern INHERIT DataDialogMine 

	PROTECT oDCmOrigin AS SINGLELINEEDIT
	PROTECT oDCmAssmntcd AS SINGLELINEEDIT
	PROTECT oDCSC_Assmntcd AS FIXEDTEXT
	PROTECT oDCSC_Origin AS FIXEDTEXT
	PROTECT oDCSC_description AS FIXEDTEXT
	PROTECT oDCmDescriptn AS SINGLELINEEDIT
	PROTECT oDCmDebCre AS RADIOBUTTONGROUP
	PROTECT oCCRadioButton1 AS RADIOBUTTON
	PROTECT oCCRadioButton2 AS RADIOBUTTON
	PROTECT oCCRadioButton3 AS RADIOBUTTON
	PROTECT oDCmAutomatic AS CHECKBOX
	PROTECT oDCmRecdate AS SINGLELINEEDIT
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oCCSaveButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCAccButton AS PUSHBUTTON
	PROTECT oDCmAccount AS SINGLELINEEDIT
	PROTECT oDCSC_REK AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  protect oImpB as ImportBatch 
  protect oBrowse as SQLSelect 
  protect CurImpPatId as string 
  protect lNew as logic
  export maccid as string 
  protect oOwner as object
RESOURCE EditImportPattern DIALOGEX  4, 3, 318, 169
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", EDITIMPORTPATTERN_MORIGIN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_DISABLED|WS_BORDER, 72, 28, 80, 13, WS_EX_CLIENTEDGE
	CONTROL	"", EDITIMPORTPATTERN_MASSMNTCD, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_DISABLED|WS_BORDER, 72, 11, 69, 12, WS_EX_CLIENTEDGE
	CONTROL	"Assessment code:", EDITIMPORTPATTERN_SC_ASSMNTCD, "Static", WS_CHILD, 13, 12, 59, 13
	CONTROL	"Origin:", EDITIMPORTPATTERN_SC_ORIGIN, "Static", WS_CHILD, 13, 30, 54, 13
	CONTROL	"Description:", EDITIMPORTPATTERN_SC_DESCRIPTION, "Static", WS_CHILD, 12, 48, 45, 12
	CONTROL	"", EDITIMPORTPATTERN_MDESCRIPTN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 48, 216, 12, WS_EX_CLIENTEDGE
	CONTROL	"Debit/Credit", EDITIMPORTPATTERN_MDEBCRE, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 72, 88, 56, 46
	CONTROL	"Debit", EDITIMPORTPATTERN_RADIOBUTTON1, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 78, 98, 38, 11
	CONTROL	"Credit", EDITIMPORTPATTERN_RADIOBUTTON2, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 78, 110, 42, 11
	CONTROL	"Both", EDITIMPORTPATTERN_RADIOBUTTON3, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 78, 121, 40, 11
	CONTROL	"Automatic processing of recognised records?", EDITIMPORTPATTERN_MAUTOMATIC, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 136, 91, 156, 11
	CONTROL	"", EDITIMPORTPATTERN_MRECDATE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_DISABLED|WS_BORDER, 220, 12, 80, 12, WS_EX_CLIENTEDGE
	CONTROL	"Date changed:", EDITIMPORTPATTERN_FIXEDTEXT5, "Static", WS_CHILD, 170, 12, 50, 13
	CONTROL	"", EDITIMPORTPATTERN_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 3, 301, 141
	CONTROL	"OK", EDITIMPORTPATTERN_SAVEBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 258, 147, 54, 13
	CONTROL	"Cancel", EDITIMPORTPATTERN_CANCELBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 200, 147, 53, 13
	CONTROL	"v", EDITIMPORTPATTERN_ACCBUTTON, "Button", WS_CHILD|NOT WS_VISIBLE, 152, 66, 14, 12
	CONTROL	"Account:", EDITIMPORTPATTERN_MACCOUNT, "Edit", ES_AUTOHSCROLL|WS_CHILD|WS_DISABLED|WS_BORDER, 72, 66, 82, 12, WS_EX_CLIENTEDGE
	CONTROL	"Account:", EDITIMPORTPATTERN_SC_REK, "Static", WS_CHILD, 12, 66, 30, 12
END

METHOD AccButton( ) CLASS EditImportPattern 

RETURN NIL
METHOD CancelButton( ) CLASS EditImportPattern 
self:EndWindow()
RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditImportPattern 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditImportPattern",_GetInst()},iCtlID)

oDCmOrigin := SingleLineEdit{SELF,ResourceID{EDITIMPORTPATTERN_MORIGIN,_GetInst()}}
oDCmOrigin:HyperLabel := HyperLabel{#mOrigin,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmOrigin:TooltipText := "Origin of imported transaction"

oDCmAssmntcd := SingleLineEdit{SELF,ResourceID{EDITIMPORTPATTERN_MASSMNTCD,_GetInst()}}
oDCmAssmntcd:FieldSpec := TeleBankPatterns_Kind{}
oDCmAssmntcd:HyperLabel := HyperLabel{#mAssmntcd,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmAssmntcd:TooltipText := "assessement code of imported transaction"

oDCSC_Assmntcd := FixedText{SELF,ResourceID{EDITIMPORTPATTERN_SC_ASSMNTCD,_GetInst()}}
oDCSC_Assmntcd:HyperLabel := HyperLabel{#SC_Assmntcd,"Assessment code:",NULL_STRING,NULL_STRING}

oDCSC_Origin := FixedText{SELF,ResourceID{EDITIMPORTPATTERN_SC_ORIGIN,_GetInst()}}
oDCSC_Origin:HyperLabel := HyperLabel{#SC_Origin,"Origin:",NULL_STRING,NULL_STRING}

oDCSC_description := FixedText{SELF,ResourceID{EDITIMPORTPATTERN_SC_DESCRIPTION,_GetInst()}}
oDCSC_description:HyperLabel := HyperLabel{#SC_description,"Description:",NULL_STRING,NULL_STRING}

oDCmDescriptn := SingleLineEdit{SELF,ResourceID{EDITIMPORTPATTERN_MDESCRIPTN,_GetInst()}}
oDCmDescriptn:HyperLabel := HyperLabel{#mDescriptn,NULL_STRING,NULL_STRING,"TeleBankPatterns_description"}
oDCmDescriptn:TooltipText := "enter one or more keywords from imported transaction description"

oCCRadioButton1 := RadioButton{SELF,ResourceID{EDITIMPORTPATTERN_RADIOBUTTON1,_GetInst()}}
oCCRadioButton1:HyperLabel := HyperLabel{#RadioButton1,"Debit",NULL_STRING,NULL_STRING}

oCCRadioButton2 := RadioButton{SELF,ResourceID{EDITIMPORTPATTERN_RADIOBUTTON2,_GetInst()}}
oCCRadioButton2:HyperLabel := HyperLabel{#RadioButton2,"Credit",NULL_STRING,NULL_STRING}

oCCRadioButton3 := RadioButton{SELF,ResourceID{EDITIMPORTPATTERN_RADIOBUTTON3,_GetInst()}}
oCCRadioButton3:HyperLabel := HyperLabel{#RadioButton3,"Both",NULL_STRING,NULL_STRING}

oDCmAutomatic := CheckBox{SELF,ResourceID{EDITIMPORTPATTERN_MAUTOMATIC,_GetInst()}}
oDCmAutomatic:HyperLabel := HyperLabel{#mAutomatic,"Automatic processing of recognised records?",NULL_STRING,NULL_STRING}
oDCmAutomatic:TooltipText := "Can recognised transaction be processed automatically?"

oDCmRecdate := SingleLineEdit{SELF,ResourceID{EDITIMPORTPATTERN_MRECDATE,_GetInst()}}
oDCmRecdate:HyperLabel := HyperLabel{#mRecdate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{EDITIMPORTPATTERN_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Date changed:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{EDITIMPORTPATTERN_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,NULL_STRING,NULL_STRING,NULL_STRING}

oCCSaveButton := PushButton{SELF,ResourceID{EDITIMPORTPATTERN_SAVEBUTTON,_GetInst()}}
oCCSaveButton:HyperLabel := HyperLabel{#SaveButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITIMPORTPATTERN_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oCCAccButton := PushButton{SELF,ResourceID{EDITIMPORTPATTERN_ACCBUTTON,_GetInst()}}
oCCAccButton:HyperLabel := HyperLabel{#AccButton,"v","Browse in accounts",NULL_STRING}
oCCAccButton:TooltipText := "Browse in accounts"

oDCmAccount := SingleLineEdit{SELF,ResourceID{EDITIMPORTPATTERN_MACCOUNT,_GetInst()}}
oDCmAccount:HyperLabel := HyperLabel{#mAccount,"Account:","Number of  Account",NULL_STRING}
oDCmAccount:TooltipText := "account of destination"

oDCSC_REK := FixedText{SELF,ResourceID{EDITIMPORTPATTERN_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,"Account:",NULL_STRING,NULL_STRING}

oDCmDebCre := RadioButtonGroup{SELF,ResourceID{EDITIMPORTPATTERN_MDEBCRE,_GetInst()}}
oDCmDebCre:FillUsing({ ;
						{oCCRadioButton1,"D"}, ;
						{oCCRadioButton2,"C"}, ;
						{oCCRadioButton3,"B"} ;
						})
oDCmDebCre:HyperLabel := HyperLabel{#mDebCre,"Debit/Credit",NULL_STRING,NULL_STRING}
oDCmDebCre:TooltipText := "should it a debit or credit transaction or don't care"

SELF:Caption := "Editing import pattern"
SELF:HyperLabel := HyperLabel{#EditImportPattern,"Editing import pattern",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mAccount() CLASS EditImportPattern
RETURN SELF:FieldGet(#mAccount)

ASSIGN mAccount(uValue) CLASS EditImportPattern
SELF:FieldPut(#mAccount, uValue)
RETURN uValue

ACCESS mAssmntcd() CLASS EditImportPattern
RETURN SELF:FieldGet(#mAssmntcd)

ASSIGN mAssmntcd(uValue) CLASS EditImportPattern
SELF:FieldPut(#mAssmntcd, uValue)
RETURN uValue

ACCESS mAutomatic() CLASS EditImportPattern
RETURN SELF:FieldGet(#mAutomatic)

ASSIGN mAutomatic(uValue) CLASS EditImportPattern
SELF:FieldPut(#mAutomatic, uValue)
RETURN uValue

ACCESS mDebCre() CLASS EditImportPattern
RETURN SELF:FieldGet(#mDebCre)

ASSIGN mDebCre(uValue) CLASS EditImportPattern
SELF:FieldPut(#mDebCre, uValue)
RETURN uValue

ACCESS mDescriptn() CLASS EditImportPattern
RETURN SELF:FieldGet(#mDescriptn)

ASSIGN mDescriptn(uValue) CLASS EditImportPattern
SELF:FieldPut(#mDescriptn, uValue)
RETURN uValue

ACCESS mOrigin() CLASS EditImportPattern
RETURN SELF:FieldGet(#mOrigin)

ASSIGN mOrigin(uValue) CLASS EditImportPattern
SELF:FieldPut(#mOrigin, uValue)
RETURN uValue

ACCESS mRecdate() CLASS EditImportPattern
RETURN SELF:FieldGet(#mRecdate)

ASSIGN mRecdate(uValue) CLASS EditImportPattern
SELF:FieldPut(#mRecdate, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class EditImportPattern
	//Put your PostInit additions here
	self:SetTexts()
	IF ClassName(uExtra)==#ImportBatch
		self:lNew := true
// 		self:oDCmOrigin:Disable()
// 		self:oDCmAccount:Disable()
		self:recdate:=Today()
		self:oImpB:=uExtra
	ELSE  // ImportPatternBrowser_DETAIL
		self:lNew := FALSE
		self:oBrowse:=self:Server
		self:mDescriptn := self:Server:descriptn
		self:mAssmntcd := self:Server:Assmntcd
		self:mDebCre := self:Server:DebCre 
		self:mOrigin := self:Server:origin
		self:mAutomatic := ConL(self:Server:Automatic)
		self:CurImpPatId:=ConS(self:Server:imppattrnid)
		self:mrecdate:=dtoc(self:Server:Recdate) 
		self:maccid := Transform(self:Server:accid,"") 
		self:mAccount := self:Server:accountname
	ENDIF
	self:oOwner:=uExtra
	RETURN nil

ACCESS Recdate() CLASS EditImportPattern
RETURN SELF:FieldGet(#Recdate)

ASSIGN Recdate(uValue) CLASS EditImportPattern
SELF:FieldPut(#Recdate, uValue)
RETURN uValue

METHOD SaveButton( ) CLASS EditImportPattern  
	local oStmnt as SQLStatement
	local nCurRec as int
	if !lNew .and.!Empty(self:oOwner)
		nCurRec:=self:oOwner:Server:recno
	endif

	oStmnt:=SQLStatement{iif( self:lNew,"insert into","update")+" importpattern set origin='"+AllTrim(self:mOrigin)+"',descriptn='"+ AddSlashes(AllTrim(self:mDescriptn))+"',assmntcd='"+;
		AllTrim(self:mAssmntcd)+"',automatic="+iif(self:mAutomatic,'1','0')+",debcre='"+self:mDebCre+"',accid="+self:maccid+iif(self:lNew,",recdate=curdate()","")+;
		iif(self:lNew,""," where imppattrnid="+self:CurImpPatId),oConn}
	oStmnt:execute()
	if !Empty(oStmnt:Status)
		LogEvent(self,self:olan:WGet("could not save import pattern")+': '+oStmnt:ErrInfo:errormessage+CRLF+oStmnt:SQLString,"LogErrors") 
		errorbox{self,self:olan:WGet("could not save import pattern")+': '+oStmnt:ErrInfo:errormessage}:show() 
	else
		if lNew
			AAdd(self:oOwner:aImpPattern,{self:mOrigin,AllTrim(self:mAssmntcd),Split(AllTrim(self:mDescriptn),Space(1)),self:mDebCre,self:mAutomatic,self:maccid})
		endif
	endif 
	self:EndWindow() 
	if !lNew .and.!Empty(self:oOwner)
		self:oOwner:Server:execute()
		self:oOwner:goto(nCurRec)
	endif

	RETURN NIL
STATIC DEFINE EDITIMPORTPATTERN_ACCBUTTON := 116 
STATIC DEFINE EDITIMPORTPATTERN_CANCELBUTTON := 115 
STATIC DEFINE EDITIMPORTPATTERN_FIXEDTEXT5 := 112 
STATIC DEFINE EDITIMPORTPATTERN_GROUPBOX1 := 113 
STATIC DEFINE EDITIMPORTPATTERN_MACCOUNT := 117 
STATIC DEFINE EDITIMPORTPATTERN_MASSMNTCD := 101 
STATIC DEFINE EDITIMPORTPATTERN_MAUTOMATIC := 110 
STATIC DEFINE EDITIMPORTPATTERN_MDEBCRE := 106 
STATIC DEFINE EDITIMPORTPATTERN_MDESCRIPTN := 105 
STATIC DEFINE EDITIMPORTPATTERN_MORIGIN := 100 
STATIC DEFINE EDITIMPORTPATTERN_MRECDATE := 111 
STATIC DEFINE EDITIMPORTPATTERN_RADIOBUTTON1 := 107 
STATIC DEFINE EDITIMPORTPATTERN_RADIOBUTTON2 := 108 
STATIC DEFINE EDITIMPORTPATTERN_RADIOBUTTON3 := 109 
STATIC DEFINE EDITIMPORTPATTERN_SAVEBUTTON := 114 
STATIC DEFINE EDITIMPORTPATTERN_SC_ASSMNTCD := 102 
STATIC DEFINE EDITIMPORTPATTERN_SC_DESCRIPTION := 104 
STATIC DEFINE EDITIMPORTPATTERN_SC_ORIGIN := 103 
STATIC DEFINE EDITIMPORTPATTERN_SC_REK := 118 
CLASS ImportBatch
PROTECT oImpB as SQLSelect
PROTECT oParent AS General_Journal
PROTECT oHM as TempTrans
PROTECT oAcc as SQLSelect
PROTECT cCurBatchNbr,cCurOrigin AS STRING, dCurDate AS DATE
EXPORT lOK AS LOGIC
PROTECT aImportFiles:={} as ARRAY
export mxrate as float
export oLan as Language
protect curimpid as int 
protect lv_imported,lv_processed as int
protect m56_description,m56_assmntcd,m56_origin as string 
export m56_recognised as logic
export aImpPattern:={} as array  // array with import pattern: {{origin,Assmntcd,Descriptn,DebCre,Automatic},...}
protect aMessages:={} as array  // messages about successfully imported files  
protect aValues:={} as array   // array with values to be inserted into importrans
	//avalues: transdate,docid,transactnr,descriptn,giver,debitamnt,creditamnt,accname,accountnr,assmntcd,externid,origin,processed

declare method GetNextBatch,LockBatch,CloseBatch,ImportPMC,ImportBatch,ImportAustria,SkipBatch,ImportCzech,SaveImport,AddImport,AddImportCzech,CheckPattern
Method AddImport(FromAcc as string,ToAcc as string,Amount as float,Description as string,impDat as date,ExtId as string,Name as string,FromDesc as string,ToDescr as string,;
		docid as string, cOrigin as string,cTransnr as string,aMbrAcc as Array,nCnt ref int,lCheckDuplicates:=false as logic) as void pascal class ImportBatch 
	// 	local FromAcc, ToAcc, Description, ExtId, Firma,FromDesc,ToDescr, AsmtCode1:="",AsmtCode2:="AG", cOrigin, cTransnr, docid as string, Amount as float, impDat as date
	local AsmtCode1:="",AsmtCode2:="AG" as string
	local oImpTr as SQLSelect
	local cImpDat as string
	local oStmnt as SQLStatement
	local nImptrid as int
	AsmtCode1:=""
	if AScanExact(aMbrAcc,ToAcc) >0
		AsmtCode2:="AG"
	endif
	if AScanExact(aMbrAcc,FromAcc) >0
		if FromAcc <> ToAcc 
			AsmtCode1:="CH"
			AsmtCode2:="MG"
		endif
	endif
	cImpDat:=SQLdate(impDat) 
	if impDat< mindate
		return
	endif
	if lCheckDuplicates
		// Check if transaction already present:

		// Search for two lines (debit and credit) equal to transaction to be imported:
		oImpTr:=SqlSelect{"select imptrid from importtrans where fromrpp=0 and origin='"+AllTrim(cOrigin)+"' and "+; 
		"externid='"+ExtId+"' and transdate='"+cImpDat+"' and descriptn='"+Description+"' and "+;
			"(accountnr='"+FromAcc+"' and debitamnt="+Str(Amount,-1)+" or accountnr='"+ToAcc+"' and creditamnt="+Str(Amount,-1)+")"+;
			" order by imptrid",oConn}
		if oImpTr:RecCount=2				
			return  // skip if allready present
		elseif oImpTr:RecCount>2 
			// check if consecutive:
			do while !oImpTr:EOF
				if Empty(nImptrid)
					nImptrid:=oImpTr:imptrid
				else
					if oImpTr:imptrid-nImptrid=1
						return // apparently two consecutive lines found
					endif
					nImptrid:=oImpTr:imptrid  // restart searching
				endif
				oImpTr:Skip()			
			enddo
		endif
	endif
	// add to avalues:
	// first transaction line
	// transdate,docid,transactnr,descriptn,giver,debitamnt,creditamnt,accname,accountnr,assmntcd,externid,origin,processed
	AAdd(self:aValues,{cImpDat,docid,cTransnr,Description,;
		Name,Str(Amount,-1),'0.00',FromDesc,FromAcc,AsmtCode1,ExtId,cOrigin,0})
	// second transaction line
	AAdd(self:aValues,{cImpDat,docid,cTransnr,Description,;
		Name,'0.00',Str(Amount,-1),ToDescr,ToAcc,AsmtCode2,ExtId,cOrigin,0})
	nCnt++
	return
Method AddImportCzech(FromAcc as string,ToAcc as string,Amount as float,Description as string,impDat as date,ExtId as string,Name as string,FromDesc as string,ToDescr as string,;
		docid as string, cOrigin as string,cTransnr as string,aMbrAcc as Array,nCnt ref int,lCheckDuplicates:=false as logic) as void pascal class ImportBatch 
	// 	local FromAcc, ToAcc, Description, ExtId, Firma,FromDesc,ToDescr, AsmtCode1:="",AsmtCode2:="AG", cOrigin, cTransnr, docid as string, Amount as float, impDat as date
	local AsmtCode1:="",AsmtCode2:="AG" as string
	local oImpTr as SQLSelect
	local cImpDat as string
	local oStmnt as SQLStatement
	local nImptrid,nPos as int
	local cSearchDesc as string
	AsmtCode1:=""
	if AScanExact(aMbrAcc,ToAcc) >0
		AsmtCode2:="AG"
	endif
	if AScanExact(aMbrAcc,FromAcc) >0
		if FromAcc <> ToAcc 
			AsmtCode1:="CH"
			AsmtCode2:="MG"
		endif
	endif
	cImpDat:=SQLdate(impDat) 
	if lCheckDuplicates
		// Check if transaction already present:

		// Search for two lines (debit and credit) equal to transaction to be imported: 
		if Val(ExtId)=0
			nPos:=AtC('dar',Description)
			if nPos>0
				cSearchDesc:=" and descriptn like '%"+SubStr(Description,nPos+3)+"'"
			else
				cSearchDesc:=" and descriptn='"+Description+"'"
			endif
		endif
		oImpTr:=SqlSelect{"select imptrid from importtrans where fromrpp=0 and origin='"+AllTrim(cOrigin)+"' and "+; 
		"externid='"+ExtId+"' and transdate='"+cImpDat+"'"+cSearchDesc+" and "+;
			"(accountnr='"+FromAcc+"' and debitamnt="+Str(Amount,-1)+" or accountnr='"+ToAcc+"' and creditamnt="+Str(Amount,-1)+")"+;
			" order by imptrid",oConn}
		if oImpTr:RecCount=2				
			return  // skip if allready present
		elseif oImpTr:RecCount>2 
			// check if consecutive:
			do while !oImpTr:EOF
				if Empty(nImptrid)
					nImptrid:=oImpTr:imptrid
				else
					if oImpTr:imptrid-nImptrid=1
						return // apparently two consecutive lines found
					endif
					nImptrid:=oImpTr:imptrid  // restart searching
				endif
				oImpTr:Skip()			
			enddo
		endif
	endif
	// add to avalues:
	// first transaction line
	// transdate,docid,transactnr,descriptn,giver,debitamnt,creditamnt,accname,accountnr,assmntcd,externid,origin,processed
	AAdd(self:aValues,{cImpDat,docid,cTransnr,Description,;
		Name,Str(Amount,-1),'0.00',FromDesc,FromAcc,AsmtCode1,ExtId,cOrigin,0})
	// second transaction line
	AAdd(self:aValues,{cImpDat,docid,cTransnr,Description,;
		Name,'0.00',Str(Amount,-1),ToDescr,ToAcc,AsmtCode2,ExtId,cOrigin,0})
	nCnt++
	return

METHOD CheckPattern(origin as string,assmntcd as string,debitamnt as float,creditamnt as float,Description as string) as array  CLASS ImportBatch  
// check if imported transaction conform a pattern
// returns array {accid,Automatic} when recognised otherwise empty array
LOCAL i as int
local debcre as string
debcre:=iif(creditamnt-debitamnt>0.00,'C','D')
// aImpPattern: array with import pattern: {{origin,Assmntcd,Descriptn,DebCre,Automatic,accid},...}
i := AScan(self:aImpPattern,{|x| (Empty(x[1]) .or. ;
					origin	== x[1])	.and.;
					assmntcd	== x[2]	.and.;
					(debcre	== x[4] .or. x[4]=='B')	.and.;
					CompareKeyString(x[3],Description)})
IF i>0
	Return {self:aImpPattern[i,6],self:aImpPattern[i,5]}
else
	return {}
endif
             
METHOD Close() CLASS ImportBatch
* Closing of class-occurrence
// SetAnsi(true)   ????? 
SQLStatement{"update importtrans set lock_id=0 where transactnr='"+self:cCurBatchNbr+;
"' and origin='"+self:cCurOrigin+"' and transdate='"+SQLdate(self:dCurDate)+"'",oConn}:execute()



RETURN true
METHOD CloseBatch(lSave:=false as logic,oCaller:=nil as object) as void pascal CLASS ImportBatch
	* Closing of batch as being processes
	local i as int
	local oEditImpb as EditImportPattern
// 	SQLStatement{"update importtrans set processed=1,lock_id=0 where transactnr='"+self:cCurBatchNbr+;
// 		"' and origin='"+self:cCurOrigin+"' and transdate='"+SQLdate(self:dCurDate)+"'",oConn}:execute()
// 	SQLStatement{"commit",oConn}:execute()
	IF lSave 
		i:=Len(self:oHM:aMirror)
		oEditImpb := EditImportPattern{ oCaller,,,self}
		// aMirror: {accID,deb,cre,gc,category,recno,Trans:RecNbr,accnumber,AccDesc,balitemid,curr,multicur,debforgn,creforgn,PPDEST, description,persid,type, incexpfd,depid}
		//             1    2   3  4    5       6        7           8        9        10     11      12      13        14     15      16          17     18      19       20
		oEditImpb:maccid := self:oHM:aMirror[i,1]
		oEditImpb:mAccount:=self:oHM:aMirror[i,9] 
		oEditImpb:mdescriptn := self:m56_description
		oEditImpb:massmntcd := self:m56_assmntcd
		oEditImpb:mDebCre := iif(self:oHM:aMirror[i,3]>=self:oHM:aMirror[i,2]'C','D') 
		oEditImpb:mOrigin := self:m56_origin 
		oEditImpb:mAutomatic := true

		oEditImpb:Show()
	ENDIF
	RETURN 
ACCESS Count CLASS ImportBatch
	RETURN SELF:oImpB:Count()
ACCESS CurBatchNbr() CLASS ImportBatch
RETURN self:cCurBatchNbr  
ACCESS CurDate() CLASS ImportBatch
RETURN self:dCurDate  


ACCESS CurOrigin() CLASS ImportBatch
RETURN self:cCurOrigin  
ACCESS EoF CLASS ImportBatch
return (SQLSelect{"select imptrid from importtrans where processed=0 "+;
	+"and (lock_id=0 or lock_id="+MYEMPID+" or lock_time < addtime(now(),'00-20-00'))",oConn}:reccount<1)
METHOD GetImportFiles()  CLASS ImportBatch
	LOCAL nf, nlen AS INT
	LOCAL cFileName AS STRING
	LOCAL nImportDate AS STRING, dBatchDate AS DATE
	LOCAL aPMIS, aTxt AS ARRAY
	SetPath(CurPath)
	SetDefault(CurPath)
	self:aImportFiles:=Directory(CurPath+"\*.csv")
	aTxt:=Directory(CurPath+"\*.txt")
	IF Len(aTxt)>0
		nlen:=Len(self:aImportFiles)
		ASize(self:aImportFiles,nlen+Len(aTxt))
		ACopy(aTxt,self:aImportFiles,,,nlen+1)
	ENDIF
	FOR nf:=1 to Len(self:aImportFiles)
		cFileName:=Upper(self:aImportFiles[nf,F_NAME]) 
		IF Len(cFileName)>=13 .and.!Upper(SubStr(cFileName,1,13))="EXPORTPERSONS" .and.!Upper(SubStr(cFileName,1,14))="EXPORT PERSONS"
			if SubStr(cFileName,1,16)="AUSTRIADONATIONS"
				if self:ImportAustria(FileSpec{cFileName},dBatchDate,PadR(cFileName,11),true)   // test if correct fileformat
					loop
				endif		
			else
				nImportDate:=SubStr(cFileName,Len(cFileName)-11,8)
				IF IsDigit(nImportDate)
					dBatchDate:=SToD(nImportDate)
					IF !dBatchDate==NULL_DATE
						IF !(dBatchDate<Today()-365 .or. dBatchdate>Today()+31)
							if self:ImportBatch(FileSpec{cFileName},dBatchDate,PadR(cFileName,11),true)   // test if correct fileformat
								loop
							endif
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		endif
		
		ADel(self:aImportFiles,nf)
		ASize(self:aImportFiles,Len(self:aImportFiles)-1)
		nf--
	NEXT
	// Import also import files from Czech WinDuo:
	aTxt:=Directory(CurPath+"\DENIK*.dbf")
	if Len(aTxt)<1
		aTxt:=Directory(CurPath+"\deník*.dbf")
	endif	
	IF Len(aTxt)>0
		nlen:=Len(self:aImportFiles)
		ASize(self:aImportFiles,nlen+Len(aTxt))
		ACopy(aTxt,self:aImportFiles,,,nlen+1)
	ENDIF

	// Import also xml-files from PMIS
	aPMIS:=Directory(CurPath+"\"+sEntity+"_*.xml")
	FOR nf:=1 TO Len(aPMIS)
		cFileName:=aPMIS[nf,F_NAME]
		IF Len(cFileName)>=19
			nImportDate:=SubStr(cFileName,5,8)
			IF IsDigit(nImportDate)
				dBatchDate:=SToD(nImportDate)
				IF !dBatchDate==NULL_DATE
					IF !(dBatchDate<Today()-365 .or. dBatchdate>Today()+31)
						LOOP
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		ADel(aPMIS,nf)
		ASize(aPMIS,Len(aPMIS)-1)
		nf--
	NEXT
	IF Len(aPMIS)>0
		nlen:=Len(self:aImportFiles)
		ASize(self:aImportFiles,nlen+Len(aPMIS))
		ACopy(aPMIS,self:aImportFiles,,,nlen+1)
	ENDIF
	IF Len(self:aImportFiles)>0
		RETURN TRUE
	ELSE
		RETURN FALSE
	ENDIF
METHOD GetNextBatch(dummy:=nil as logic) as logic CLASS ImportBatch
	* Give next import batch with transaction from ImportTrans
	LOCAL OrigBst, CurBatchNbr,CurDocid, cGiverName as STRING
	LOCAL CurDate as date, CurOrigin as STRING
	LOCAL cDescription, cExId,cType as STRING
	local MultiCur:=false as logic 
	local nPostStatus as int 
	local oImpB,oImpTr1,oImpTr2,oSel as SQLSelect
	local oLockSt as SQLStatement
	local aPrn:={} as array  // {accid,automatic} 
	self:m56_recognised:=false
	SQLStatement{"start transaction",oConn}:execute() 
	oImpTr1:=SQLSelect{"select transactnr,origin,transdate,docid from importtrans "+;
		"where processed=0 "+;
		+"and (lock_id=0 or lock_id="+MYEMPID+" or lock_time < subdate(now(),interval 20 minute))"+;
		iif(Empty(self:curimpid),''," and imptrid>"+Str(self:curimpid,-1))+;
		" order by imptrid limit 1 for update",oConn}
	if oImpTr1:reccount<1
		self:lOK:=False
		return false
	endif
	CurBatchNbr:=oImpTr1:transactnr
	CurOrigin:=oImpTr1:Origin
	CurDate:=oImpTr1:transdate
	CurDocid:=oImpTr1:docid
	
	//lock rest of same transaction:
	oImpTr2:=SQLSelect{"select imptrid from importtrans "+;
		"where processed=0 and transactnr='"+CurBatchNbr+"' and origin='"+CurOrigin+"' and docid='"+CurDocid+"' and transdate='"+SQLdate(CurDate)+"' order by imptrid for update",oConn}
	// software lock importrans rows:
	oLockSt:=SQLStatement{"update importtrans set lock_id="+MYEMPID+",lock_time=Now() where transactnr='"+CurBatchNbr+"' and origin='"+CurOrigin+;
		"' and docid='"+CurDocid+"' and transdate='"+SQLdate(CurDate)+"'",oConn}
	oLockSt:execute()		
	if oLockSt:NumSuccessfulRows < 1
		SQLStatement{"rollback",oConn}:execute()
		loop
	else
		SQLStatement{"commit",oConn}:execute()
	endif                                                 
	oImpB:=SQLSelect{"select a.description as accountname,a.accid,a.currency as acccurrency,a.multcurr,a.accnumber,a.department,b.category as type,m.co,m.persid as persid,"+SQLAccType()+" as accounttype,i.*"+;
		" from importtrans i left join (balanceitem as b,account as a left join member m on (m.accid=a.accid or m.depid=a.department) left join department d on (d.depid=a.department)) on (i.accountnr<>'' and a.accnumber=i.accountnr and b.balitemid=a.balitemid)"+;
		"where processed=0 and i.transactnr='"+CurBatchNbr+"' and i.origin='"+CurOrigin+;
		"' and docid='"+CurDocid+"' and transdate='"+SQLdate(CurDate)+"' order by imptrid",oConn}
	if oImpB:reccount<1
		LogEvent(self,oImpB:SQLString+"; error:"+oImpB:status:Description,"LogErrors")
		self:lOK:=false
		return false
	endif
	self:lOK:=true
	CurDate:=oImpB:transdate
	OrigBst:=oImpB:docid
	nPostStatus:=oImpB:POSTSTATUS
	IF !self:oHM:Used
		RETURN FALSE
	ENDIF
	* Fill rows of TempTrans with transaction:
	oParent:Reset()
	self:oHM:SuspendNotification()
	DO WHILE !oImpB:EoF
		self:oHM:append()
		self:oHM:descriptn := oImpB:descriptn
		self:oHM:AccNumber:=Space(11)
		self:oHM:accdesc:=oImpB:accname
		self:oHM:accid:=Space(11)
		self:oHM:kind := " "
		self:oHM:Gc := ""
		self:oHM:currency := iif(Empty(oImpB:currency),sCurr,oImpB:currency) 
		self:oHM:DepID:=ConI(oImpB:department)
		cType:=Transform(oImpB:TYPE,"")
		MultiCur:=false
		self:oHM:Gc:=oImpB:assmntcd
		IF !Empty(oImpB:accountnr)
			self:oHM:AccNumber := LTrimZero(oImpB:accountnr)
			IF !Empty(oImpB:AccNumber)
				self:oHM:accid := Str(oImpB:accid,-1)
				self:oHM:accdesc:=oImpB:accountname
				self:oHM:kind:=Upper(oImpB:accounttype)
				if Empty(oImpB:Currency).and.!Empty(oImpB:AccCurrency) 
					self:oHM:currency:=oImpB:AccCurrency
				endif 
				MultiCur:=iif(ConI(oImpB:MULTCURR)=1,true,false) 
				if ConI(oImpB:FROMRPP)=1
					self:lOK:=false    // no automatic processing of PMC import
				endif
			ELSE
				self:lOK:=FALSE
			ENDIF
		ELSE
			// try to find a import pattern:
			aPrn:=self:CheckPattern(oImpB:Origin,oImpB:assmntcd,oImpB:debitamnt,oImpB:creditamnt,oImpB:descriptn) 
			if Empty(aPrn)
				self:lOK:=FALSE
			else
				oSel:=sqlselect{"select accnumber,a.description,a.currency,a.department,b.category as type,"+SQLAccType()+" as accounttype "+;
					" from account as a left join member m on (m.accid=a.accid or m.depid=a.department) left join department d on (d.depid=m.depid),balanceitem as b  "+ ;
					" where a.balitemid=b.balitemid and a.accid="+aPrn[1],oConn}
				if oSel:reccount>0
					self:oHM:accid:=aPrn[1]
					self:oHM:accdesc := oSel:Description
					self:oHM:AccNumber := oSel:AccNumber
					self:oHM:kind:=Upper(oSel:accounttype)	
					self:oHM:currency:= iif(Empty(oSel:currency),sCurr,oSel:currency) 				 
					self:oHM:DepID:=ConI(oSel:department)
					cType:=oSel:TYPE
					self:lOK:=aPrn[2] 					
				else
					self:lOK:=false
				endif
			endif
		ENDIF
		self:oHM:deb := oImpB:debitamnt
		self:oHM:cre := oImpB:creditamnt
		self:oHM:debforgn := iif(self:oHM:currency==sCurr,oImpB:debitamnt,oImpB:debforgn)
		self:oHM:creforgn := iif(self:oHM:currency==sCurr,oImpB:creditamnt,oImpB:creforgn)
		self:oHM:BFM:= " "
		self:oHM:FROMRPP:=iif(ConI(oImpB:FROMRPP)=1,true,false)
		self:oHM:lFromRPP:=iif(ConI(oImpB:FROMRPP)=1,true,false)
		self:oHM:OPP:=oImpB:Origin
		self:oHM:PPDEST:= oImpB:PPDEST 
		self:oHM:REFERENCE:=oImpB:REFERENCE 
		self:oHM:POSTSTATUS:=oImpB:POSTSTATUS

		IF !Empty(oImpB:GIVER)
			cGiverName:=AllTrim(oImpB:GIVER)
			if cGiverName==","
				cGiverName:=""
			endif
		ENDIF
		IF !Empty(oImpB:EXTERNID)
			// Search person with external id:
			cExId:=oImpB:EXTERNID
		endif
		* Add TO mirror: 
		// aMirror: {accID,deb,cre,gc,category,recno,Trans:RecNbr,accnumber,AccDesc,balitemid,curr,multicur,debforgn,creforgn,PPDEST, description,persid,type, incexpfd,depid}
		//            1      2   3  4     5      6          7         8        9        10     11     12      13        14      15       16          17   18      19      20
		
		AAdd(self:oHM:aMirror,{self:oHM:accid,self:oHM:deb,self:oHM:cre,self:oHM:Gc,self:oHM:kind,self:oHM:RecNo,,self:oHM:AccNumber,'','',self:oHM:currency,MultiCur,self:oHM:debforgn,self:oHM:creforgn,self:oHM:REFERENCE,self:oHM:descriptn,ConS(oImpB:persid),cType,'',oHM:DepID})
		cDescription:=oImpB:descriptn
		self:m56_description:=cDescription 
		self:m56_assmntcd:=oImpB:assmntcd
		self:m56_origin := oImpB:origin
		self:curimpid:=oImpB:imptrid 
		oImpB:Skip()
	ENDDO
	* Save current Id of Batch:
	self:cCurBatchNbr:=CurBatchNbr
	self:cCurOrigin:=CurOrigin
	self:dCurDate:=CurDate
	self:oHM:Commit() 
	if self:oHM:reccount>0
		*	self:oHM:ResetNotification()
		oParent:FillBatch(OrigBst,CurDate,cGiverName,cDescription, cExId, nPostStatus)
		oParent:AddCur()
		self:oHM:ResetNotification()
		self:oHM:GoTop()
		self:oHM:Skip()
	endif
	RETURN true
METHOD Import() CLASS ImportBatch
	* Import of batches of  transaction data into ImportTrans.dbf
	LOCAL oBF AS FileSpec
	LOCAL nf,lv_aant_toe:=0,lv_imported_tot:=0,  lv_aant_vrw:=0,i as int
	LOCAL cFileName, cOrigin AS STRING
	LOCAL nImportDate AS STRING, dBatchDate AS DATE
	LOCAL oWarn as warningbox
	local oStmnt as SQLStatement
	Local oLock as SQLSelect
	local aFiles:={} as array // files to be deleted 
	// force only one person is importing: 
	// Check if nobody else is busy with importing batch: 
	oLock:=SqlSelect{'select 1 from importlock where importfile="batchlock" and '+;
		" lock_id>0 and lock_id<>"+MYEMPID+" and lock_time > subdate(now(),interval 5 minute)",oConn}
	if oLock:Reccount>0 
		ErrorBox{,self:oLan:WGet("somebody else busy with importing batch transactions")}:Show()
		return
	endif 
	SQLStatement{"start transaction",oConn}:Execute()
	oLock:=SqlSelect{"select importfile from importlock where importfile='batchlock' for update",oConn}
	oLock:Execute() 
	if !Empty(oLock:Status)
		ErrorBox{,self:oLan:WGet("could not select importlock")+Space(1)+' ('+oLock:Status:description+')'}:Show()
		SQLStatement{"rollback",oConn}:Execute() 
		return
	endif
	// set software lock:
	oStmnt:=SQLStatement{"update importlock set lock_id="+MYEMPID+",lock_time=now() where importfile='batchlock'",oConn}
	oStmnt:Execute()
	if !Empty(oStmnt:Status)
		ErrorBox{,self:oLan:WGet("could not lock required transactions")}:Show()
		SQLStatement{"rollback",oConn}:Execute() 
		return
	endif
	SQLStatement{"commit",oConn}:Execute()  // save locks 

	self:GetImportFiles()
	InitGlobals()  // sometimes globals disappear 
	FOR nf:=1 to Len(aImportFiles)
		cFileName:=aImportFiles[nf,F_NAME]
		oBF := FileSpec{cFileName}
		IF Upper(oBF:Extension)==".CSV" .or. Upper(oBF:Extension)==".TXT"
			// import file in csv-format:
			IF SubStr(cFilename,1,3)==sEntity
				oWarn := WarningBox{,self:oLan:WGet("Import from file"),;
					self:oLan:WGet('Do you really want to import from file')+' '+AllTrim(cFileName)+'?'}
				oWarn:Type := BOXICONQUESTIONMARK + BUTTONYESNO
				oWarn:Beep:=TRUE
				IF (oWarn:Show() = BOXREPLYNO)
					LOOP
				ENDIF
			ENDIF
			cOrigin:=PadR(cFileName,11)
			if Upper(cOrigin)=="AUSTRIADONA" 
				if self:ImportAustria(oBF,dBatchDate,cOrigin)
					++lv_aant_toe
					AAdd(aFiles,oBF)
				else
					SQLStatement{"rollback",oConn}:Execute()
// 					return
				ENDIF
			else 
// 				SQLStatement{"start transaction",oConn}:Execute()
				if self:ImportBatch(oBF,dBatchDate,cOrigin)
					++lv_aant_toe
					AAdd(aFiles,oBF)
					SQLStatement{"commit",oConn}:Execute()  
// 				else
// 					SQLStatement{"rollback",oConn}:Execute()
// 					return
				ENDIF
			endif 
		ELSEIF Upper(oBF:Extension)==".XML"
			// import file in PMIS-XML-format:
// 			if self:ImportPMC(oBF,dBatchDate)
			if self:ImportPMC(oBF,dBatchDate)
				++lv_aant_toe
				AAdd(aFiles,oBF)
			ENDIF
		ELSEIF Upper(oBF:Extension)==".DBF"
			// import file in WinDUO Denik-export-format:
// 			SQLStatement{"start transaction",oConn}:Execute()
// 			if self:ImportBatchCZR(oBF,dBatchDate) 
			if self:ImportCzech(oBF,dBatchDate,'CZR') 
				++lv_aant_toe
				AAdd(aFiles,oBF)
// 				SQLStatement{"commit",oConn}:Execute()  
// 			else
// 				SQLStatement{"rollback",oConn}:Execute()
// 				return
			ENDIF
		ENDIF
	NEXT
	IF lv_aant_toe>0
		* Clear old batches: 
		oStmnt:=SQLStatement{"delete from importtrans where processed=1 and transdate<'"+SQLdate(Today()-440)+"'",oConn}
		oStmnt:Execute()
		// delete files:
		for nf:=1 to Len(aFiles)
			IF	!aFiles[nf]:DELETE()
				if	!FErase(aFiles[nf]:FullPath)
					(WarningBox{,self:oLan:WGet("Import	of	batch	transactions"),self:oLan:WGet("Could not delete	file")+"	"+aFiles[nf]:FullPath}):Show()
				endif
			ENDIF
		next
	endif
	// unlock software lock:
	SQLStatement{"start transaction",oConn}:Execute()
	oLock:=SqlSelect{"select importfile from importlock where importfile='batchlock' for update",oConn}
	oLock:Execute() 
	if !Empty(oLock:Status)
		ErrorBox{self,self:oLan:WGet("could not select importlock")+Space(1)+' ('+oLock:Status:description+')'}:Show()
		SQLStatement{"rollback",oConn}:Execute() 
		return
	endif
	oStmnt:=SQLStatement{"update importlock set lock_id='0',lock_time='0000-00-00' where importfile='batchlock'",oConn}
	oStmnt:Execute()
	if !Empty(oStmnt:Status)
		ErrorBox{self,self:oLan:WGet("could not unlock required transactions")}:Show()
		SQLStatement{"rollback",oConn}:Execute() 
		return
	endif
	SQLStatement{"commit",oConn}:Execute()  // save locks 

	IF Len(self:aMessages)>0
		(InfoBox{,self:oLan:WGet("Import of batches"),AllTrim(Str(lv_aant_toe,4))+" "+self:oLan:WGet("batch file")+if(lv_aant_toe>1,"s","")+" "+;
		self:oLan:WGet("with")+" "+Str(lv_imported,-1)+" "+self:oLan:WGet("transactions imported")+' ('+Str(self:lv_processed,-1)+Space(1)+;
		self:oLan:WGet("automaticaly processed")+')'}):show()
		for i:=1 to Len(self:aMessages)
			LogEvent(self,self:aMessages[i],"Log")
		next 
	ENDIF


	RETURN
METHOD ImportAustria(oFr as FileSpec,dBatchDate as date,cOrigin as string,Testformat:=false as logic) as logic CLASS ImportBatch
	* Import of one batchfile with  transaction data into ImportTrans.dbf 
	* Testformat: only test if this a file to be imported
	LOCAL cSep as STRING
	LOCAL cDelim:=Listseparator as STRING
	LOCAL lv_loaded as LOGIC
	LOCAL CurTransNbr:="" as STRING
	LOCAL ptrHandle as MyFile
	LOCAL cBuffer as STRING
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	LOCAL ptDate, ptDoc, ptTrans, ptDesc, ptCre, ptAccName, ptPers as int
	LOCAL aPt:={} as ARRAY, maxPt , nCnt:=0,nProc:=0,nTot,nAcc,nPers,i,nTransId,nLastGift as int
	LOCAL cBank,cBankName,cBankaccId as string 
	local aDat as array, impDat as date, cAcc,cAccNumber,cAccName,cAssmnt,cAccId,cdat as string , lUnique as logic
	local oStmnt as SQLStatement
	local oSel,oImpTr,oAcc as SQLSelect
	local cStatement,cError,cAmount,cDecDelim,cThousandDelim as string 
	local lError,lSuccess as logic
	local Amount as float 
	local aValues:=self:aValues as array   // array with values to be inserted into importrans 
	// 	local aValuesTrans:={} as array   // array with values to be automatically inserted into transaction 
	// 	local aValuesPers:={} as array   // array with person values to be automatically updated {{persid,datelastgift},{..},...} 
	local aAccDest:={} as array  // array with destination accounts: {{accnumber,accid},{..},..} 
	local aMbrAcc:={} as array  // array with member accounts
	local aPers:={}  as array // array with giver data: {{externid,persid},{..}...} 
	local aPersExt:={} as array // array with import externids
	local oMBal as Balances 
	//    Default(@Testformat,False)
	
	ptrHandle:=MyFile{oFr}
	IF FError() >0
		(ErrorBox{,self:oLan:WGet("Could not open file")+": "+oFr:FullPath+"; "+self:oLan:WGet("Error")+":"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine()
	IF Empty(cBuffer)
		(ErrorBox{,self:oLan:WGet("Could not read file")+": "+oFr:FullPath+"; "+self:oLan:WGet("Error")+":"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	if !GetDelimiter(cBuffer,@aStruct,@cDelim,8,10)
		(ErrorBox{,self:oLan:WGet("Wrong fileformat of importfile")+": "+oFr:FullPath}):show() 
		ptrHandle:Close()
		RETURN FALSE 
	endif

	ptDate:=AScan(aStruct,{|x| "SPENDENDATUM" $ x})
	ptDoc:=AScan(aStruct,{|x| "LISTNAME" $ x})
	ptTrans:=AScan(aStruct,{|x| "SPNR" $ x})
	ptDesc:=AScan(aStruct,{|x| "SPDTEXT" $ x})
	ptCre:=AScan(aStruct,{|x| "BETRAG" $ x})
	ptAccName:=AScan(aStruct,{|x| "SPDKTONAME" $ x})
	ptPers:=AScan(aStruct,{|x| "SPENDER" $ x})
	IF ptDate==0 .or. ptTrans==0 .or. ptAccName==0 .or. ptDesc==0 .or. ptCre==0 .or.ptPers==0.or.ptDoc==0
		(ErrorBox{,self:oLan:WGet("Wrong fileformat of importfile")+": "+oFr:FullPath}):show() 
		ptrHandle:Close()
		RETURN FALSE 
	elseif Testformat
		ptrHandle:Close()
		return true
	ENDIF
	SetDecimalSep(Asc('.'))  // to guarante it is correct
	oSel:=SqlSelect{"select a.accnumber,a.description,a.accid from bankaccount b,account a where a.accid=b.accid",oConn}
	if oSel:RecCount<1
		(ErrorBox{,self:oLan:WGet("Specify first a bank account with its general ledger account")}):show() 
		ptrHandle:Close()
		return false
	else
		cBank:=oSel:ACCNUMBER
		cBankName:=oSel:Description 
		cBankaccid:=Str(oSel:accid,-1)
	endif

	// determine max fieldnumber:
	aPt:={ptDate,ptTrans,ptAccName,ptDesc,ptCre,ptPers,ptDoc}
	ASort(aPt)
	maxPt=aPt[Len(aPt)] 
	cBuffer:=ptrHandle:FReadLine()
	aFields:=Split(cBuffer,cDelim,true)
	oParent:Pointer := Pointer{POINTERHOURGLASS} 

	DO WHILE Len(AFields)>1
		cStatement:=""
		impDat:=null_date
		if ptDate<= Len(AFields) 
			cdat:=AllTrim(AFields[ptDate]) 
			if Len(cdat)=10
				impDat:=SToD(SubStr(cdat,7,4)+SubStr(cdat,4,2)+SubStr(cdat,1,2))
			else
				impDat:=CToD(cdat)
			endif
			if impDat==null_date
				(ErrorBox{,"Wrong date format in "+oFr:FullPath+"; should be: dd.mm.yyyy"}):show() 
				ptrHandle:Close() 
				lError:=true
				exit
			endif
		endif
		if ptAccName>0 .and. ptAccName<=Len(AFields) 
			cAccName:=AllTrim(AFields[ptAccName])
			nAcc:=AScan(aAccDest,{|x|x[1]==cAccName})
			cAccNumber:="" 
			cAccId:=''
			if nAcc=0
				cAcc:=Split(cAccName," ",true)[1] 
				if IsDigit(cAcc)
					cAcc:= LTrimZero(cAcc)
					oAcc:=SqlSelect{"select a.accnumber,a.accid,m.mbrid from account a left join member m on (m.accid=a.accid or m.depid=a.department) where a.accnumber='"+cAcc+"'",oConn}
					if oAcc:RecCount=1
						cAccNumber:=oAcc:ACCNUMBER							
					endif
				else
					oAcc:=SqlSelect{"select a.accnumber,a.accid,m.mbrid from account a left join member m on (m.accid=a.accid or m.depid=a.department) where a.description like '"+cAcc+"%'",oConn}
					if oAcc:RecCount=1
						cAccNumber:=oAcc:ACCNUMBER
					elseif oAcc:RecCount>0  
						oAcc:=SqlSelect{"select a.accnumber,a.accid,m.mbrid from account a left join member m on (m.accid=a.accid or m.depid=a.department) where a.description like '%"+StrTran(cAccName,' ','%')+"%'",oConn}
						if oAcc:RecCount=1
							cAccNumber:=oAcc:ACCNUMBER
						endif
					endif
				endif
				cAssmnt:=""
				if !Empty(cAccNumber)
					cAccId:=Str(oAcc:accid,-1)
					if !Empty(oAcc:mbrid) 
						AAdd(aMbrAcc,cAccId)
						cAssmnt:="AG"
					endif
				endif
				AAdd(aAccDest,{cAccName,cAccNumber,cAssmnt,cAccId})
				nAcc:=Len(aAccDest)
			endif
		ENDIF
		if Empty(cDecDelim)
			// establish used decimal separator: 
			cDecDelim:=SubStr(AFields[ptCre],-3,1)
			if cDecDelim=='.'
				cThousandDelim:=','
			elseif cDecDelim==','
				cThousandDelim:='.'
			else
				cDecDelim:=''
			endif
		endif
		if !Empty(cDecDelim)
			cAmount:= StrTran(StrTran(AFields[ptCre],cThousandDelim,''),cDecDelim,".") 
		else
			cAmount:=AFields[ptCre]
		endif
		Amount:=Val(cAmount)
		if Amount>=1000.00
			LogEvent(self,"amount:"+AFields[ptCre]+'-> '+cAmount+' -> '+Str(amount,-1),"logsql")  // signal large amounts
		endif
		self:AddImport(cBank,aAccDest[nAcc,2],Amount,self:oLan:RGet("Gift") +iif(ptDesc<= Len(AFields)," "+AFields[ptDesc],""),impDat,AFields[ptPers],;
			AFields[ptDoc],cBankName,cAccName,'Import',cOrigin,AFields[ptTrans],aMbrAcc,@nCnt)
		oMainWindow:STATUSMESSAGE("imported "+Str(nCnt,-1))		
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim,true)
	ENDDO
	ptrHandle:Close()
	if nCnt>0
		// check if loaded: 
		oSel:=SqlSelect{"select count(*) as tot from importtrans where `origin`='"+cOrigin+"' and `transactnr` in ("+Implode(aValues,',',,,3)+")",oConn}
		
		if oSel:RecCount<1 .or. oSel:tot=0 
			// not yet loaded 
			lSuccess:=self:SaveImport(@nCnt,@nProc)
			if !lSuccess
				lError:=true
			endif
		endif
	endif
	self:oParent:Pointer := Pointer{POINTERARROW} 
	if lError
		return false
	endif
	AAdd(self:aMessages, "Imported Austria file:"+oFr:FileName+" "+Str(nCnt,-1)+" transactions imported ("+Str(nProc,-1)+" automaticaly processed)")

	RETURN true

METHOD ImportBatch(oFr as FileSpec,dBatchDate as date,cOrigin as string,Testformat:=false as logic) as logic CLASS ImportBatch
	* Import of one batchfile with  transaction data into ImportTrans.dbf 
	* Testformat: only test if this a file to be imported
	LOCAL aPt:={} as ARRAY, maxPt , linenr:=0, nCnt:=0 as int
	LOCAL ptDate, ptDoc, ptTrans, ptAcc, ptDesc, ptDeb, ptCre, ptDebF, ptCreF,ptCur, ptAss,ptAccName, ptPers,ptPPD, ptRef,ptSeq, ptPost as int
	local deb,cre,debf,cref as float
	LOCAL cSep as STRING
	local CCurrency as string
	LOCAL cDelim:=Listseparator AS STRING
	LOCAL lv_geladen AS LOGIC
	LOCAL CurTransNbr:="" AS STRING
	LOCAL ptrHandle as MyFile
	LOCAL cBuffer as STRING
	local cStatement as string
	LOCAL aStruct:={} as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	local osel as SQLSelect 
	local oStmnt as SQLStatement
	
	ptrHandle:=MyFile{oFr}
	IF FError() >0
		(ErrorBox{,"Could not open file: "+oFr:FullPath+"; Error:"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=ptrHandle:FReadLine()
	IF Empty(cBuffer)
		(ErrorBox{,"Could not read file: "+oFr:FullPath+"; Error:"+DosErrString(FError())}):show()
		ptrHandle:Close()
		RETURN FALSE
	ENDIF
	if !GetDelimiter(cBuffer,@aStruct,@cDelim,8,17)
		ptrHandle:Close()
		RETURN FALSE 
	endif
	ptDate:=AScan(aStruct,{|x| "DATE" $ x})
	ptDoc:=AScan(aStruct,{|x| "DOC" $ x})
	ptTrans:=AScan(aStruct,{|x| "TRANSACT" $ x})
	ptAcc:=AScan(aStruct,{|x| "ACC" $ x})
	ptDesc:=AScan(aStruct,{|x| "DESCR" $ x})
	ptDebF:=AScan(aStruct,{|x| "DEBITF" $ x})
	ptCreF:=AScan(aStruct,{|x| "CREDITF" $ x})
	ptCur:=AScan(aStruct,{|x| "CUR" $ x})
	ptDeb:=AScan(aStruct,{|x| "DEB" $ x})
	ptCre:=AScan(aStruct,{|x| "CRE" $ x})
	ptAss:=AScan(aStruct,{|x| "ASS" $ x})
	ptAccName:=AScan(aStruct,{|x| "ACCNAME" $ x})
	ptPers:=AScan(aStruct,{|x| "GIVER" $ x})
	ptRef:=AScan(aStruct,{|x| "REFERENCE" $ x})
	ptPPD:=AScan(aStruct,{|x| "PPDEST" $ x})
	ptSeq:=AScan(aStruct,{|x| "SEQNR" $ x})
	ptPost:=AScan(aStruct,{|x| "POST" $ x})
	IF ptDate==0 .or. ptTrans==0 .or. ptAcc==0 .or. ptDesc==0 .or. ptDeb==0 .or. ptCre==0 .or. ptAss==0 .or.ptDoc==0
		ptrHandle:Close()
		RETURN FALSE 
	elseif Testformat
		ptrHandle:Close()
		return true
	ENDIF 
	cBuffer:=ptrHandle:FReadLine()
	aFields:=Split(cBuffer,cDelim,true)
	linenr=1 
	cSep:=DecSeparator    // default decimal separator of Windows 
	// check if different separator used:
	if ptDeb<= Len(AFields)
		if At(AFields[ptDeb],cSep)=0
  			if At(AFields[ptCre],',')>0
  				cSep:=','
  			elseif At(AFields[ptCre],'.')>0
  				cSep:='.'
  			endif
		endif
	endif 
	SQLStatement{"start transaction",oConn}:Execute()

	DO WHILE Len(AFields)>1
		linenr++  

		IF !aFields[ptTrans]==CurTransNbr // new transaction?
			CurTransNbr:=aFields[ptTrans]
			* Check if batchtransaction not yet loaded:
			if SQLSelect{"select imptrid from importtrans where origin='"+cOrigin+"' and transactnr='"+AllTrim(AFields[ptTrans ])+"'",oConn}:RecCount<1 
				// 			IF !oImpTr:Seek(Pad(cOrigin,11)+AFields[ptTrans ])
				lv_geladen:=FALSE
			ELSE
				lv_geladen:=true 
			ENDIF
		ENDIF
		IF !lv_geladen .and.SToD(AFields[ptDate])>=mindate 
			deb:=0.00
			cre:=0.00
			debf:=0.00
			cref:=0.00
			if ptCur>0 .and.ptCur<= Len(AFields)
				CCurrency:=AllTrim(AFields[ptCur])
			else
				CCurrency:=sCURR
			endif
			if ptDeb<= Len(AFields)
				deb:= Val(AFields[ptDeb])
				if CCurrency==sCURR
					debf:=deb
				endif
			endif
			if ptCre<= Len(AFields)
				cre:=Val(AFields[ptCre])
				if CCurrency==sCURR
					cref:=cre
				endif
			endif
			if !CCurrency==sCURR
				if ptDebF>0 .and.ptDebF<= Len(AFields)
					debf:=Val(AFields[ptDebF])
				endif
				if ptCreF>0 .and.ptCreF<= Len(AFields)
					cref:=Val(AFields[ptCreF])
				endif
			endif	
			cStatement:=;
				iif(ptDate<= Len(AFields),",transdate='"+SQLdate(SToD(AFields[ptDate]))+"'","")+;
				iif(ptDoc<= Len(AFields),",docid='"+AFields[ptDoc]+"'","")+; 
			iif(ptTrans<= Len(AFields),",transactnr='"+AFields[ptTrans]+"'","")+;
				",accountnr='"+AFields[ptAcc]+"'"+;
				iif(ptDesc<= Len(AFields),",descriptn='"+AddSlashes(AFields[ptDesc])+"'","") +;
				",debitamnt='"+Str(deb,-1)+"'"+",creditamnt='"+Str(cre,-1)+"'"+; 
				",debforgn='"+Str(debf,-1)+"'"+",creforgn='"+Str(cref,-1)+"'"+;
				",currency='"+iif(ptCur>0 .and.ptCur<= Len(AFields),AFields[ptCur],sCURR)+"'"+;
				iif(ptAss<= Len(AFields),",assmntcd='"+AFields[ptAss]+"'","")+;
				iif(ptAccName>0 .and. ptAccName<=Len(AFields),",accname='"+AddSlashes(AFields[ptAccName])+"'","")+;
				iif(ptPers>0 .and. ptPers<=Len(AFields),iif(AllTrim(AFields[ptPers])==",","",",giver='"+AllTrim(AFields[ptPers])+"'"),"")+;
				iif(ptPPD>0 .and. ptPPD<=Len(AFields),",ppdest='"+AFields[ptPPD]+"'","")+;
				iif(ptRef>0 .and. ptRef<=Len(AFields),",reference='"+AddSlashes(AFields[ptRef])+"'","")+;
				iif(ptSeq>0 .and. ptSeq<=Len(AFields)  .and. !IsNil(AFields[ptSeq]),",seqnr='"+iif(Empty(AFields[ptSeq]),'0',AFields[ptSeq]),"")+"'"+;
				",poststatus='"+iif(ptPost>0 .and. ptPost<=Len(AFields).and. !IsNil(AFields[ptPost]),AFields[ptPost],"1")+"'"+;
				",origin='"+cOrigin+"'" 
			oStmnt:=SQLStatement{"insert into importtrans set "+SubStr(cStatement,2),oConn}
			oStmnt:Execute()
			IF oStmnt:NumSuccessfulRows<1
				SQLStatement{"rollback",oConn}:Execute()
				ptrHandle:Close()
				LogEvent(self,"error: "+oStmnt:ErrInfo:errormessage+CRLF+oStmnt:SQLString,"LogErrors")
				ErrorBox{,self:oLan:WGet('Transaction could not be stored')+":"+oStmnt:status:Description}:show()
				return false
			endif
			self:lv_imported++ 
			nCnt++
		ENDIF
		cBuffer:=ptrHandle:FReadLine()
		aFields:=Split(cBuffer,cDelim,true)
	ENDDO 
	SQLStatement{"commit",oConn}:Execute()  

	AAdd(self:amessages,"Imported batch file:"+oFr:FileName+" "+Str(nCnt,-1)+" imported of "+Str(linenr,-1)+" transactions")

	RETURN true
METHOD ImportCzech(oFr as FileSpec,dBatchDate as date,cOrigin as string,Testformat:=false as logic) as logic CLASS ImportBatch
	* Import of one batchfile with  transaction data into ImportTrans.dbf 
	* Testformat: only test if this a file to be imported
	LOCAL oImpCZR as DBFILESPEC
	LOCAL nCnt:=0,nProc:=0,nTot,i,nTransId,nLastGift, nPos as int
	LOCAL SamAcc,PMCAcc as string 
	local oSel,oImpTr,oAcc,oMbr as SQLSelect
	local lSuccess as logic 
	local LastDate as date
	local aMbrAcc:={} as array // array with member accounts 
// 	local aValues:={} as array   // array with values to be inserted into importrans 
	Local aMissingFld:={},aNeededFld:={"ICO","POPIS","CASTKA","CASTKAM","DAU","FIRMA","MD_UCET","D_UCET","DOKLAD"} as array
	local FromAcc, ToAcc, Description, ExtId, Firma,FromDesc,ToDescr, AsmtCode1:="",AsmtCode2:="AG", cOrigin, cTransnr, docid as string, Amount as float, impDat as date 
	local cSearchDesc as string  // how to check duplicates with description
	
	oImpCZR:=DbFileSpec{oFr:FullPath,"DBFCDX"}
	oImpCZR:Path:=CurPath
	oImpTr:=oImpB
	self:aValues:={}
	IF oImpCZR:Find() 
		for i:=1 to Len(aNeededFld)
			if AScan(oImpCZR:DbStruct,{|x|x[DBS_NAME]=aNeededFld[i]})=0
				AAdd(aMissingFld,aNeededFld[i])
			endif
		next 
		if !Empty(aMissingFld)
			(ErrorBox{,"The following columns are missing in file "+oImpCZR:FullPath+":"+CRLF+Implode(aMissingFld,", ")}):show()
			return false
		endif 
		
		// import:
		DbSetRestoreWorkarea (true)
		SetAnsi(oImpCZR:IsAnsi)
		IF DBUSEAREA(true,"DBFCDX",oImpCZR:FullPath,"CZR",FALSE,FALSE)

			oParent:Pointer := Pointer{POINTERHOURGLASS} 
			// determine member accounts:
			oMbr:=SqlSelect{"select a.accnumber from account a, member m where m.accid=a.accid or m.depid=a.department",oConn}
			aeval(oMbr:GetLookupTable(3000,#accnumber,#accnumber),{|x|aadd(aMbrAcc,x[1])})
			if Empty(sam)
				(ErrorBox{self,"No account defined for assessments in system parameters!"}):show()
				CZR->DBCLOSEAREA()
				DbSetRestoreWorkarea (false)
				return false
			endif 
			oSel:=SqlSelect{"select accnumber,accid from account where `accid`="+sam,oConn}
			IF oSel:RecCount<1
				(errorbox{self:OWNER,self:oLan:WGet('Account for assemments not found')}):Show()
				CZR->DBCLOSEAREA()
				DbSetRestoreWorkarea (false)
				return false
			ENDIF
			SamAcc:=oSel:ACCNUMBER
			oSel:=SqlSelect{"select accnumber,accid from account where `accid`="+SHB,oConn}
			IF oSel:RecCount<1
				(ErrorBox{self:OWNER,self:oLan:WGet('Account for sending to PMC not found')}):show()
				CZR->DBCLOSEAREA()
				DbSetRestoreWorkarea (false)
				return false
			ENDIF
			PMCAcc:=oSel:ACCNUMBER
			// Search latest transdate in Imptr: 
			oImpTr:=SqlSelect{"select max(transdate) as transdate from importtrans where fromrpp=0",oConn}
			if Empty(oImpTr:status) .and. oImpTr:RecCount>0 .and.!Empty(oImpTr:transdate)
				LastDate:=oImpTr:transdate 
			else
				LastDate:=Today()
			endif				
			LastDate:=LastDate-(Day(LastDate)-1)  // place at start of month
			CZR->DbSetFilter({||CZR->DATUM > LastDate})
			CZR->DbGotop() 
			do while !CZR->EOF() 
				ToAcc:=StrZero(CZR->FieldGetSym(#DSU),3,0)+StrZero(CZR->FieldGetSym(#DAU),3,0)
				FromAcc:=StrZero(CZR->FieldGetSym(#MDSU),3,0)+StrZero(CZR->FieldGetSym(#MDAU),3,0)
				Amount:=CZR->FieldGetSym(#CASTKA)
				Description:=AllTrim(CZR->FieldGetSym(#POPIS))
				impDat:=CZR->FieldGetSym(#DATUM) 
				ExtId:=Str(CZR->FieldGetSym(#ICO),-1)
				Firma:=AllTrim(CZR->FieldGetSym(#FIRMA))
				FromDesc:=AllTrim(CZR->FieldGetSym(#MD_UCET))
				ToDescr:=AllTrim(CZR->FieldGetSym(#D_UCET))
				docid:=AllTrim(CZR->FieldGetSym(#DOKLAD))
				cOrigin:="WD"+Pad(docid,9)
				cTransnr:=StrZero(CZR->ICO,10,0) 
				nTot++
				if AScan(aMbrAcc,{|x|x==ToAcc}) > 0      // skip non member transaction
					if !(FromAcc==SamAcc .or. FromAcc==PMCAcc)   // skip assessment and PMC transactions 
// 						self:AddImport(FromAcc,ToAcc,Amount,Description,impDat,ExtId,Firma,FromDesc,ToDescr,docid,cOrigin,cTransnr,aMbrAcc,@nCnt,true)
						self:AddImportCzech(FromAcc,ToAcc,Amount,Description,impDat,ExtId,Firma,FromDesc,ToDescr,docid,cOrigin,cTransnr,aMbrAcc,@nCnt,true)
					endif
				endif
				CZR->DBSKIP()
			enddo
			CZR->DBCLOSEAREA()
			DbSetRestoreWorkarea (false)
			if nCnt>0
				lSuccess:=self:SaveImport(@nCnt,@nProc)
			endif
			self:oParent:Pointer := Pointer{POINTERARROW} 
			if !lSuccess
				return false
			endif
// 			AAdd(self:aMessages,"Imported CZ file:"+oFr:FileName+" "+Str(nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions ("+Str(nProc,-1)+" automaticaly processed)")
			AAdd(self:aMessages,"Imported CZ file:"+oFr:FileName+" "+Str(nCnt,-1)+" transactions imported ("+Str(nProc,-1)+" automaticaly processed)")
			return true
		ENDIF
	endif

	RETURN true
METHOD ImportPMC(oFr as FileSpec,dBatchDate as date) as logic CLASS ImportBatch
	* Import of one RPPfile with  transaction data from PMC into ImportTrans.dbf
	LOCAL cBuffer as STRING
	LOCAL ChildName as STRING
	Local cExId as string
	LOCAL transdescription,description,oppdescr, docid, accnbr,accnbrdest,acciddest,origin,transtype,housecode,samnbr,shbnbr, reference as STRING
	Local oInST as Insite, cAccCng,cDescription,cMsg,cError as string
	local cStatement,cTrans as string
	lOCAL cPmisCurrency as string
	LOCAL nAnswer, nCnt,nTot,nMbr,nAcc,nPtr,i,nProc,nCnt,nSeqnbr,nPers,nLastGift,nCntTooOld as int
	local nTransId as Dword 
	LOCAL amount, USamountAbs, USDAmount, oppAmount,TotAmount,TotUSDAmount as FLOAT
	local time1,time0 as float
	LOCAL childfound, recordfound as LOGIC
	local lUSD as logic
	local lPayable as logic 
	LOCAL transdate, oppdate,rppdate,cmsdate as date
	LOCAL datelstafl as date
	local aValues:={} as array   // array with values to be inserted into importrans 
	local aValuesTrans:={} as array   // array with values to be automatically inserted into transaction 
	local aAccMbr:={} as array   // array with accounts of members: {{housecode,accinc,accexp,netasset,accidinc,accidexp,accidnetasset,accpayable,accidpayable},{...}... } 
	local aAccDest:={} as array  // array with destination accounts: {{accnumber,accid,payable=true/false},{..},..}
	local aPers:={}  // array with giver data: {{externid,persid},{..}...}
	local aValuesPers:={} as array   // array with person values to be automatically updated {{persid,datelastgift},{..},...} 
	local aAccNbr:={} as array  // array with import accountnbrs
	local aPersExt:={} as array // array with externids
	local aTransIncExp:={} as array // array like aTrans for ministry income/expense transactions 
	LOCAL ptrHandle
	local oCurr as CURRENCY 
	local RPP_date as date
	LOCAL oAfl as UpdateHouseHoldID
	LOCAL oExch as GetExchRate
	local osel as SQLSelect 
	local oMBal as Balances
	local oStmnt as SQLStatement 
	LOCAL PMISDocument as XMLDocument
	
	local oAddInc as AddToIncExp 
	if Empty(SEntity)
		(ErrorBox{self:OWNER,self:oLan:WGet('First specify PMC Participant Code in System parameter, tab PMC')}):show()
		RETURN false
	ENDIF
	IF Empty(SHB)
		(ErrorBox{self:Owner,self:oLan:WGet('Add first account for Clearance PMC to system data')}):Show()
		self:EndWindow()
		RETURN true
	ENDIF

	ptrHandle:=FOpen(oFr:FullPath)
	IF ptrHandle = F_ERROR
		(ErrorBox{,self:oLan:WGet("Could not open file")+": "+oFr:FullPath+"; "+self:oLan:WGet("Error")+":"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF
	cBuffer:=FReadStr(ptrHandle,4096000) 
	cBuffer:=(UTF2String{cBuffer}):Outbuf
	cBuffer:=HtmlDecode(cBuffer)
	IF ptrHandle = F_ERROR
		(ErrorBox{,self:oLan:WGet("Could not read file")+": "+oFr:FullPath+"; "+self:oLan:WGet("Error")+":"+DosErrString(FError())}):show()
		RETURN FALSE
	ENDIF 
	self:oParent:Pointer := Pointer{POINTERHOURGLASS} 
	oAfl:=UpdateHouseHoldID{}
	oAfl:Importaffiliated_person_account_list()

	// 	datelstafl:=SQLSelect{"select datlstafl from sysparms",oConn}:DATLSTAFL 
	// 	if datelstafl<Today()  
	// 		self:oParent:STATUSMESSAGE(self:oLan:WGet('Processing account changes report')+'...')
	// 		oAfl:=UpdateHouseHoldID{}
	// 		IF !oAfl:Importaffiliated_person_account_list()
	// 			IF datelstafl<(Today()-31) 
	// 				nAnswer:= (TextBox{,self:oLan:WGet("Import RPP"),;
	// 					self:oLan:WGet('Your last import of the Account Changes Report from Insite is of')+' '+DToC(datelstafl)+'.'+LF+self:oLan:WGet('If you stop now you can first download that report from Insite into folder')+' '+curPath+' '+self:oLan:WGet('before the send to PMC')+CRLF+CRLF+self:oLan:WGet('Do you want to stop now?'),BOXICONQUESTIONMARK + BUTTONYESNO}):show()
	// 				IF nAnswer == BOXREPLYYES 
	// 					FClose(ptrHandle)
	// 					RETURN FALSE
	// 				ENDIF
	// 			ENDIF
	// 		ENDIF
	// 	ENDIF
	self:oParent:Pointer := Pointer{POINTERARROW} 

	IF Empty(sCURR)
		(ErrorBox{,self:oLan:WGet('First specify the currency in System parameters')}):show()
		FClose(ptrHandle)
		RETURN false
	ENDIF

	oCurr:=Currency{self:oLan:WGet("Importing RPP")} 
	RPP_date:=SToD(SubStr(oFr:FileName,5,8))
	mxrate:=SqlSelect{"select exchrate from sysparms",oConn}:EXCHRATE
	mxrate:=oCurr:GetROE("USD", RPP_date,true,true,-0.5) 
	if oCurr:lStopped
		FClose(ptrHandle)
		return false
	endif

	// Proces records:
	PMISDocument:=XMLDocument{cBuffer}
	// first check intehrity of document:
	If !PMISDocument:GetElement("RPP_Records") 
		If PMISDocument:GetElement("Message") 
			FClose(ptrHandle)
			return true
		else
			(ErrorBox{,self:oLan:WGet('No correct RPP file')+' '+AllTrim(oFr:FileName)}):show()
			FClose(ptrHandle)
			RETURN false
		endif
	ENDIF
	
	recordfound:= PMISDocument:GetElement("Record")
	osel:=SQLSelect{"select accnumber,currency from account where accid="+sam,oConn}
	IF osel:RecCount<1
		(errorbox{self:OWNER,self:oLan:WGet('Account for assemments not found')}):Show()
		FClose(ptrHandle)
		return false
	ENDIF
	samnbr:=osel:ACCNUMBER
	AAdd(aAccDest,{samnbr,sam,false})
	osel:=SQLSelect{"select accnumber,currency from account where accid="+SHB,oConn}
	IF osel:RecCount<1
		(errorbox{self:OWNER,self:oLan:WGet('Account for sending to PMC not found')}):Show()
		FClose(ptrHandle)
		return false
	ENDIF
	shbnbr:=osel:ACCNUMBER
	cPmisCurrency:=osel:CURRENCY 
	AAdd(aAccDest,{shbnbr,SHB,false})
	if cPmisCurrency=="USD"
		lUSD:=true
	elseif Empty(cPmisCurrency)
		cPmisCurrency:=sCURR
	endif
	self:oParent:Pointer := Pointer{POINTERHOURGLASS} 
	cMsg:=self:oLan:WGet('Importing RPP transactions')+'...'
	self:oParent:STATUSMESSAGE(cMsg)
	// 	(time1:=Seconds()) 
	if !Empty(SINCHOME) .or.!Empty(SINC)
		// add transactions for ministry income/expense:
		oAddInc:=AddToIncExp{}
	endif

	DO WHILE recordfound
		childfound:=PMISDocument:GetFirstChild()
		docid:=""
		origin:=""
		transdescription:=""
		description:=""
		amount:=0.00
		USamountAbs:=0.00 
		USDAmount:=0.00
		oppAmount:=0.00
		transdate:=Today()
		oppdate:=null_date
		rppdate:=null_date
		cmsdate:=null_date
		accnbr:=""
		oppdescr:=""
		housecode:="" 
		reference:=""
		transtype:="GT" 
		acciddest:=''
		accnbrdest:=""
		nTot++
		DO WHILE childfound
			ChildName:=PMISDocument:ChildName
			DO CASE
			CASE ChildName=="RPP_Transaction_Amount"
				amount:=Val(PMISDocument:ChildContent)
			CASE ChildName=="OPP_Transaction_Ref"
				description+=PMISDocument:ChildContent+" "
				reference:= PMISDocument:ChildContent
			CASE ChildName="Transaction_Description"
				transdescription:=PMISDocument:ChildContent
			CASE ChildName=="PMIS_Received_Date_Time"
				rppdate:=SToD(StrTran(SubStr(PMISDocument:ChildContent,1,10),"-"))
			CASE ChildName=="OPP_Transaction_Date"
				oppdate:=SToD(StrTran(SubStr(PMISDocument:ChildContent,1,10),"-"))
			CASE ChildName=="OPP_Transaction_Amount"
				oppAmount:=AbsFloat(Val(PMISDocument:ChildContent))
			CASE ChildName=="CMS_Processed_Date_Time"
				cmsdate:=SToD(StrTran(SubStr(PMISDocument:ChildContent,1,10),"-"))
			CASE ChildName="Originating_PP_Code"
				origin:=AllTrim(PMISDocument:ChildContent)
			CASE ChildName="General_Transaction_Id"
				docid:=PMISDocument:ChildContent
			CASE ChildName="RPP_Destination_String"
				accnbr:=AllTrim(PMISDocument:ChildContent)
			CASE ChildName="RPP_Household_Code"
				housecode:=PMISDocument:ChildContent
			CASE ChildName="RPP_Trans_Type_Code"
				IF !Empty(PMISDocument:ChildContent)
					transtype:=PMISDocument:ChildContent
				ENDIF
			CASE ChildName="Assessment_Transaction_Id"
				IF Val(PMISDocument:ChildContent)>0
					transtype:="AT"
				ENDIF
			CASE ChildName="USD_Amount"
				USDAmount:=Val(PMISDocument:ChildContent)
				USamountAbs:=AbsFloat(USDAmount)
			ENDCASE
			childfound:=PMISDocument:GetNextChild()			
		ENDDO
		IF !Empty(rppdate)
			transdate:= rppdate
		ELSEIF !Empty(cmsdate)
			transdate:=cmsdate
		ELSEIF !Empty(oppdate)
			transdate:=oppdate
		ENDIF
		// first transaction roW 
		// in case of BTA and gift form USA look up donor:
		cExId:=""
		// 		if sEntity == "NTL" .or.sEntity=="BTA" .and.Origin=="USA".and.transtype=="CN"
		if transtype=="CN"
			if origin=="USA"
				cExId:=Str(Val(Right(Split(transdescription," ",true)[1],10)),-1)
				if cExId=='0'
					cExId:=""
				else
					cExId:=origin+cExId
				endif
			elseif origin=='UKD'
				cExId:=Str(Val(Right(Split(transdescription," ")[2],10)),-1)
				if cExId=='0'
					cExId:=""
				else
					cExId:=origin+cExId
				endif
			elseif origin=='NED' .or.origin=='SWE' .or. origin=='SAF' .or. origin=='NOR' .or. origin=='ASD' .or. origin=='CZR' .or. origin=='FRN' .or. origin=='ROM' .or. origin=='SPN' .or. origin=='SKD' .or. origin=='THD'
				nPtr:=AtC(' from ',transdescription)
				if nPtr>0
					cExId:=Str(Val(Split(AllTrim(SubStr(transdescription,nPtr+6))," ")[1]),-1)
					if cExId=='0'
						cExId:=""
					else
						cExId:=origin+cExId
					endif
				endif
			endif
		endif
		self:oParent:STATUSMESSAGE(cMsg+Str(nCnt,-1))
		if transdate < mindate
			nCntTooOld++
			recordfound:=PMISDocument:GetNextSibbling()
			loop
		endif
		nCnt++
			
		if !Empty(mxrate)
			amount:=Round(mxrate*USDAmount,DecAantal)
		endif
		IF !Empty(oppAmount).and.oppAmount#USamountAbs.and. oppAmount#amount
			oppdescr:="("+origin+" amount:"+Str(oppAmount,-1)+iif(Empty(oppdate),"",", date:"+DToC(oppdate))+") "
		ELSEIF !Empty(USamountAbs)
			if origin=='USA'
				oppdescr:="("+origin+" amount:"+Str(USamountAbs,-1)+iif(Empty(oppdate),"",", date:"+DToC(oppdate))+") "
			else
				oppdescr:="(USD amount:"+Str(USamountAbs,-1,2)+iif(Empty(oppdate),"",", "+origin+" date:"+DToC(oppdate))+") "
			endif
		ELSEIF !Empty(oppdate) 
			oppdescr+="("+origin+" Date:"+DToC(oppdate)+") "
		ENDIF
		oppdescr+=" (Exch rate US $1="+ZeroRTrim(Str(mxrate,-1,8))+' '+sCURR+") "
		cDescription:=StrTran(transdescription+" "+description,"&amp;","&")+oppdescr
		// determine destination account for second line: 
		IF !Empty(accnbr)
			nAcc:=AScan(aAccDest,{|x|x[1]==accnbr})
			if nAcc=0
				osel:=SQLSelect{"select accnumber,accid from account where accnumber='"+accnbr+"'",oConn}
				IF osel:RecCount>0
					AAdd(aAccDest,{osel:ACCNUMBER,Str(osel:accid,-1),false})
					nAcc:=Len(aAccDest)
				ENDIF
			endif
			if nAcc>0
				accnbrdest:=aAccDest[nAcc,1] 
				acciddest:=aAccDest[nAcc,2] 
			ELSE
				IF transtype="AT"
					accnbrdest:=samnbr
					acciddest:=sam
				ENDIF
			endif
		ELSEIF transtype="AT"
			accnbrdest:=samnbr
			acciddest:=sam
		ENDIF
		lPayable:=false
		IF !Empty(housecode) .and.Empty(accnbrdest) 
			// search corresponding member:
			nMbr:=AScan(aAccMbr,{|x|x[1]==housecode})
			if nMbr=0
				osel:=SqlSelect{"select ad.accnumber as accdirect,ai.accnumber as accincome,ae.accnumber as accexpense,an.accnumber as accnetasset,ap.accnumber as accpayable,"+;
					"m.accid as acciddirect,d.incomeacc,d.expenseacc,d.netasset,d.payableacc "+;
					"from member m left join account ad on (ad.accid=m.accid) left join department d on (m.depid=d.depid) "+;
					"left join account ai on (ai.accid=d.incomeacc) "+;
					"left join account ae on (ae.accid=d.expenseacc) "+;
					"left join account an on (an.accid=d.netasset) "+;
					"left join account ap on (ap.accid=d.payableacc) "+;
					"where m.householdid='"+housecode+"'",oConn}
				if osel:RecCount>0
					//				aAccMbr: {{housecode,accinc,accexp,netasset,accidinc,accidexp,accidnetasset,accpayable,accidpayable},{...}... }
					//                        1         2      3       4       5        6          7            8            9
					AAdd(aAccMbr,;
					iif(Empty(osel:accdirect),;
						iif(Empty(osel:accpayable),;
							{housecode,osel:accincome,osel:accexpense,osel:accnetasset,Str(osel:incomeacc,-1),Str(osel:expenseacc,-1),Str(osel:netasset,-1),osel:accexpense,Str(osel:expenseacc,-1)};
						,;
							{housecode,osel:accincome,osel:accexpense,osel:accnetasset,Str(osel:incomeacc,-1),Str(osel:expenseacc,-1),Str(osel:netasset,-1),osel:accpayable,Str(osel:payableacc,-1)};
						);
					,;
						{housecode,osel:accdirect,osel:accdirect,osel:accdirect,Str(osel:acciddirect,-1),Str(osel:acciddirect,-1),Str(osel:acciddirect,-1),osel:accdirect,Str(osel:acciddirect,-1)};
					))
					nMbr:=Len(aAccMbr)
					if !Empty(osel:accpayable)
						lPayable:=true
					endif					
				endif
			endif
			if nMbr>0
				if transtype="CN" .or. transtype="CP".or.transtype="MM"
					accnbrdest:=aAccMbr[nMbr,2]   //accincome 
					acciddest:=aAccMbr[nMbr,5]
				elseif transtype="PC" .and. amount<0
					accnbrdest:=aAccMbr[nMbr,4]   //netasset
					acciddest:=aAccMbr[nMbr,7]
				else							
					accnbrdest:=aAccMbr[nMbr,8]   //accpayable/accexpense
					acciddest:=aAccMbr[nMbr,9]
				endif
			ENDIF
		ENDIF
		if !Empty(acciddest) 
			AAdd(aAccDest,{accnbrdest,acciddest,lPayable})
		endif		
		//     1       2       3         4           5       6       7       8        9         10        11      12      13         14        15          16       17
		// transdate,docid,transactnr,accountnr,assmntcd,externid,origin,fromrpp,creditamnt,debitamnt,creforgn,debforgn,currency,descriptn,poststatus,reference,processed
		AAdd(aValues,{SQLdate(transdate),docid,docid,shbnbr,'','',origin,'1',;
			iif(USDAmount<0,0.00,amount),;  //creditamnt
		iif(USDAmount<0,-amount,0.00),; //debitamnt
		iif(USDAmount<0,0.00,USDAmount),; //creforgn
		iif(USDAmount<0,-USDAmount,0.00),; //debgorgn
		cPmisCurrency,AddSlashes(cDescription),iif((transtype="PC" .or. transtype="AT") .and.!Empty(accnbrdest),"2","1"),'','0'})
		// totalize transactions 
		TotAmount:=Round(TotAmount+amount,DecAantal)
		TotUSDAmount:=Round(TotUSDAmount+USDAmount,DecAantal)
		nPtr:=Len(aValues)
		// second transaction row 

		if Empty(accnbrdest) .and.!Empty(accnbr)
			cDescription+=" "+accnbr				
		endif		
		IF transtype="CN" .or. transtype="CP".or.transtype="MM"
			cDescription:="Gift "+cDescription
		endif 
		// transdate,docid,transactnr,accountnr,assmntcd,externid,origin,fromrpp,creditamnt,debitamnt,creforgn,debforgn,currency,descriptn,poststatus,reference,processed
		//    1         2      3         4          5       6        7       8         9         10        11     12        13       14        15         16        17
		AAdd(aValues,{SQLdate(transdate),docid,docid,Transform(accnbrdest,""),;
			iif(transtype="CN" .or. transtype="CP",;
			'AG';
			,;
			iif(transtype="MM","MG",;
			iif(transtype="PC",;
			iif(amount<0,"PF","CH");
			,;
			"";
			);
			);
			),;
			iif(transtype="CN" .or. transtype="CP",cExId,''),;
			origin,'1',;
			iif(amount<0,-amount,0.00),; //creditamnt
		iif(amount<0,0.00,amount),; //debitamnt
		iif(amount<0,-amount,0.00),; //creforgn
		iif(amount<0,0.00,amount),; //debforgn
		sCURR,AddSlashes(cDescription),iif(transtype="PC" .and.!Empty(accnbrdest),"2","1"),reference,'0'})
		nPtr++ 
		recordfound:=PMISDocument:GetNextSibbling()
	ENDDO
	FClose(ptrHandle)
	// Perform inserts:
	if !Empty(aValues)
		// check record allready loaded (first and last sufficient check): 
		osel:=SqlSelect{"select imptrid from importtrans where origin='"+aValues[1,7]+"' and transactnr='"+aValues[1,3]+"'"+;
				iif(Len(aValues)>2," or origin='"+aValues[Len(aValues),7]+"' and transactnr='"+aValues[Len(aValues),3]+"'",''),oConn}
		if osel:RecCount<1 
			// not yet loaded
			// compose corresponding transactions which can be processed automatically: 
			// aValues; transdate,docid,transactnr,accountnr,assmntcd,externid,origin,fromrpp,creditamnt,debitamnt,creforgn,debforgn,currency,descriptn,poststatus,reference,processed
			//             1         2      3         4          5       6        7       8         9         10        11     12        13       14        15         16        17
			for i:=1 to Len(aValues) step 2
				if !Empty(aValues[i+1,6])   // externid filled
					if (nPers:=AScanExact(aPersExt,AllTrim(aValues[i+1,6])))=0
						AAdd(aPersExt,AllTrim(aValues[i+1,6]))
					endif
				endif
			next
			if Len(aPersExt)>0
				ASort(aPersExt)
				osel:=SqlSelect{"select group_concat(externid,';',persid separator '##') as grpers from (select externid,cast(persid as char) as persid from person where externid in ("+Implode(aPersExt,"','")+') order by externid) as gr group by 1=1',oConn}
				if osel:RecCount>0 
					aPers:=AEvalA(Split(osel:grpers,'##'),{|x|x:=Split(x,';')})  //{externid,persid},... 
				endif
			endif
			for nPtr:=1	to	Len(aValues) step 2 
				if	!Empty(aValues[nPtr+1,4])  // account destination filled
					nPers:=0
					if !Empty(aValues[nPtr+1,6])
						nPers:=AScan(aPers,{|x|x[1]==aValues[nPtr+1,6]})  // person found?
					endif
					nAcc:=AScan(aAccDest,{|x| x[1]==aValues[nPtr+1,4]})     // aAccDest: {{accnumber,accid},{..},..}
					if	nAcc>0    // destination account found:
						// check if charge from account payable:
						if aValues[nPtr+1,5]=='CH' .and. aAccDest[nAcc,3]==true
							loop
						endif
						acciddest:=aAccDest[nAcc,2] 
						//	first	from shb account:
						//aValuesTrans: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
						//                1     2     3     4     5         6        7        8   9    10     11        12    13     14       15      16    17    18
						AAdd(aValuesTrans,{SHB,aValues[nPtr,10],aValues[nPtr,12],aValues[nPtr,9],aValues[nPtr,11],aValues[nPtr,13],aValues[nPtr,14],aValues[nPtr,1],;
							aValues[nPtr,5],LOGON_EMP_ID,'2','1',aValues[nPtr,2],aValues[nPtr,16],'0','1',aValues[nPtr,7],''})
						aValues[nPtr,17]:=1	//	set importrans	to	processed 
						aValues[nPtr+1,17]:=1	//	set importrans	to	processed 
						//	second transaction line	to	destination
						nPtr++
						nProc++
						AAdd(aValuesTrans,{acciddest,avalues[nPtr,10],avalues[nPtr,12],avalues[nPtr,9],avalues[nPtr,11],avalues[nPtr,13],avalues[nPtr,14],avalues[nPtr,1],;
							aValues[nPtr,5],LOGON_EMP_ID,'2','2',aValues[nPtr,2],aValues[nPtr,16],iif(nPers>0,aPers[nPers,2],'0'),'1',aValues[nPtr,7],''})
						// add to income expense if needed: 
						if !Empty(SINCHOME) .or.!Empty(SINC)
							// add transactions for ministry income/expense:
							nSeqnbr:=2 
							aTransIncExp:=oAddInc:AddToIncome(aValues[nPtr,5],true,acciddest,aValues[nPtr,9],aValues[nPtr,10],aValues[nPtr,12],aValues[nPtr,11],;
								aValues[nPtr,13],aValues[nPtr,14],'',aValues[nPtr,1],aValues[nPtr,2],@nSeqnbr,aValues[nPtr,15])
							if Len(aTransIncExp)=2
								// aTransIncExp:
								//  1    2      3     4     5        6          7       8   9   10        11      12    13      14       15    16     17   18
								//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
								aTransIncExp[1,11]:='2'  // poststatus -> posted
								aTransIncExp[2,11]:='2'  // poststatus -> posted
								AAdd(aValuesTrans,aTransIncExp[1])
								AAdd(aValuesTrans,aTransIncExp[2]) 
							endif
						endif 
						if	nPers>0 
							if (nLastGift:=AScan(aValuesPers,{|x|x[1]=aPers[nPers,2]}))>0
								if	aValuesPers[nLastGift,2]<aValues[nPtr,1]
									aValuesPers[nLastGift,2]:=aValues[nPtr,1]
								endif
							else
								AAdd(aValuesPers,{aPers[nPers,2],aValues[nPtr,1]})
							endif
						endif
						nPtr--
					endif
				endif
			next

			cStatement:=Implode(aValues,"','")                                            
			
			// prepare adapting mbalance values:
			oMBal:=Balances{}
			for i:=1 to Len(aValuesTrans) 
				//  1    2      3     4     5        6          7       8   9   10        11      12    13      14       15    16     17   18
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
				oMBal:ChgBalance(aValuesTrans[i,1],SQLDate2Date(aValuesTrans[i,8]),aValuesTrans[i,2],aValuesTrans[i,4],aValuesTrans[i,3],;
					aValuesTrans[i,5],aValuesTrans[i,6])
			next
			oStmnt:=SQLStatement{"set autocommit=0",oConn}
			oStmnt:Execute()
			oStmnt:=SQLStatement{'lock tables `importtrans` write,`mbalance` write,'+iif(Len(aValuesPers)>0,'`person` write,','')+'`transaction` write',oConn}     // alphabetic order 
			oStmnt:Execute()
			oStmnt:=SQLStatement{'insert into importtrans '+;
				'(`transdate`,`docid`,`transactnr`,`accountnr`,`assmntcd`,`externid`,`origin`,`fromrpp`,`creditamnt`,`debitamnt`,`creforgn`,`debforgn`,`currency`,`descriptn`,`poststatus`,`reference`,`processed`)'+;
				' values '+cStatement,oConn} 
			oStmnt:Execute()                                                            
			if oStmnt:NumSuccessfulRows<1
				SQLStatement{"rollback",oConn}:Execute()
				SQLStatement{"unlock tables",oConn}:Execute()
				LogEvent(self,"error:"+cStatement,"LogErrors")
				ErrorBox{,self:oLan:WGet('Transactions could not be imported')+":"+oStmnt:status:Description}:show()
				return false 
			else 
				nCnt:=oStmnt:NumSuccessfulRows/2
			endif
			if !Empty(aValuesTrans) 
				// insert first line:
				oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp) "+;
					" values ("+Implode(aValuesTrans[1],"','",1,16)+')',oConn}
				oStmnt:Execute()
				nTransId:=ConI(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
				aValuesTrans[2,18]:=nTransId
				for i:=3 to Len(aValuesTrans) step 2
					// next line income/expense?
					if aValuesTrans[i,12]=='3'
						aValuesTrans[i,18]:=nTransId
						aValuesTrans[i+1,18]:=nTransId
						i+=2
					endif		
					nTransId++
					if i<Len(aValuesTrans)
						aValuesTrans[i,18]:=nTransId
						aValuesTrans[i+1,18]:=nTransId
					endif
				next
				oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid) "+;
					" values "+Implode(aValuesTrans,"','",2),oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows<1
					SQLStatement{"rollback",oConn}:Execute() 
					SQLStatement{"unlock tables",oConn}:Execute()
					LogEvent(self,"error:"+cStatement,"LogErrors")
					ErrorBox{,self:oLan:WGet('Transactions could not be inserted')+":"+oStmnt:status:Description}:show()
					return false
				endif 
				// 				nProc:=(oStmnt:NumSuccessfulRows+1)/2

				// adapt mbalance values:
				if !oMBal:ChgBalanceExecute()
					SQLStatement{"rollback",oConn}:Execute() 
					SQLStatement{"unlock tables",oConn}:Execute()
					LogEvent(self,"error:"+oMBal:cError,"LogErrors")
					ErrorBox{,self:oLan:WGet('Month balances could not be updated')+":"+cError}:show()
					return false 
				endif
				// update persons:
				if !Empty(aValuesPers)
					ASort(aValuesPers,1,,{|x,y|x[1]<=y[1]},)
					oStmnt:=SQLStatement{"insert into person (persid,datelastgift) values "+Implode(aValuesPers,"','")+" on duplicate key update mailingcodes="+;
						"if(datelastgift='0000-00-00',concat(mailingcodes,' ','FI'),mailingcodes),datelastgift=if(datelastgift<values(datelastgift),values(datelastgift),datelastgift)",oConn} 
					oStmnt:Execute()
				endif
				
			endif
			SQLStatement{"commit",oConn}:Execute()
			SQLStatement{"unlock tables",oConn}:Execute() 
			self:lv_imported:=self:lv_imported+nCnt
			self:lv_processed+=nProc
		else
			nCnt:=0
			nProc:=0
			TotAmount:=0.00 
		endif
	endif
	time0:=time1
	// 	LogEvent(self,"import RPP:"+Str((time1:=Seconds())-time0,-1)+"sec","logtime")
	oParent:Pointer := Pointer{POINTERARROW} 
	AAdd(self:aMessages,"Imported RPP file:"+oFr:FileName+" "+Str(nCnt,-1)+" imported of "+Str(nTot,-1)+" transactions; total amount:"+Str(-TotAmount,-1,DecAantal)+sCURR+' (Exchange rate: 1 USD='+Str(mxrate,-1)+sCURR+')'+'; '+Str(nProc,-1)+' automatic processed')
	if nCntTooOld>0
		AAdd(self:aMessages,"Imported RPP file:"+oFr:FileName+" "+Str(nCntTooOld,-1)+' '+ self:olan:WGet("transactions skipped because in closed year or month"))
		ErrorBox{,Str(nCntTooOld,-1)+' '+ self:oLan:WGet("transactions skipped because in closed year or month")}:show()	
	endif

	RETURN true
METHOD INIT(oOwner,oHulpMut,Share,ReadOnly) CLASS ImportBatch 
	local oSel as SQLSelect
	SetPath(CurPath)
	SetDefault(CurPath)
	Default(@ReadOnly,FALSE)
	Default(@Share,FALSE)
	self:oLan:=Language{}
	oParent:=oOwner
	//self:Import()
	self:oHM:=oHulpMut
	oSel:=SqlSelect{"select origin,assmntcd,descriptn,debcre,automatic,accid from importpattern",oConn} 
	if oSel:reccount>0
		do while !oSel:EoF
			AAdd(self:aImpPattern,{oSel:origin,oSel:assmntcd,Split(oSel:descriptn,Space(1),true),oSel:debcre,ConL(oSel:Automatic),cons(oSel:accid)})	
			oSel:Skip()
		enddo
	endif
	RETURN SELF
	
METHOD LockBatch(dummy:=nil as logic) as logic CLASS ImportBatch
* Locking of current batch records
local oMyImp as SQLSelect
oMyImp:=SQLSelect{"select imptrid from importtrans where transactnr='"+self:cCurBatchNbr+;
"' and origin='"+self:cCurOrigin+"' and processed=0 and lock_id="+MYEMPID+" for update",oConn}
oMyImp:execute()
if oMyImp:reccount<1
	ErrorBox{self:oParent,self:oLan:WGet("This import transaction has already been processed by someone else, thus skipped")}:show()
	SQLStatement{"rollback",oConn}:execute()
	return false
endif
return true
METHOD SaveImport(nCnt ref int,nProc ref int) as logic CLASS ImportBatch
	// store ImportTrans into database from array aValues 
	//
	local aPers:={}  // array with giver data: {{externid,persid},{..}...}
	local aValuesTrans:={} as array   // array with values to be automatically inserted into transaction
	local aValuesPers:={} as array   // array with person values to be automatically updated {{persid,datelastgift},{..},...} 
	local aAcc:={} as array  // array with accounts
	local aAccNbr:={} as array  // array with import accountnbrs
	local aPersExt:={} as array // array with externids
	local aValues:=self:aValues as array 
	local oMBal as Balances
	local oSel as SQLSelect
	local oStmnt as SQLStatement
	local i,nPers,nAcc,nLastGift,nTransId as int
	local cBankaccId as string
	nCnt:=0 
	if Len(aValues)>0
		// compose corresponding transactions which can be processed automatically: 
		for i:=1 to Len(aValues)
			if !Empty(aValues[i,9]) .and.AScanExact(aAccNbr,AllTrim(aValues[i,9]))=0
				AAdd(aAccNbr,AllTrim(aValues[i,9]))
			endif
		next
		//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,transid,fromrpp 
		oSel:=SqlSelect{"select group_concat(gr.accid,';',gr.accnumber separator '##') as graccs from (select cast(accid as char) as accid,accnumber from account where accnumber in ("+Implode(aAccNbr,',')+")) as gr group by 1=1",oConn}
		if oSel:RecCount>0
			AEval(Split(oSel:graccs,'##'),{|x|AAdd(aAcc,Split(x,';'))})  //{accid,accnumber},...
		endif  
		
		// avalues: transdate,docid,transactnr,descriptn,giver,debitamnt,creditamnt,accname,accountnr,assmntcd,externid,origin,processed
		//              1        2      3            4      5      6          7        8         9       10      11       12       13
		for i:=1 to Len(aValues) step 2
			if !Empty(aValues[i,11])   // externid filled
				if (nPers:=AScanExact(aPersExt,AllTrim(aValues[i,11])))=0
					AAdd(aPersExt,AllTrim(aValues[i,11]))
				endif
			endif
		next
		//		oSel:=SqlSelect{"select group_concat(gr.grpersid) as grpersids from (select cast(persid as char) as grpersid from person where persid in ("+cPersids+") and deleted=0) as gr group by 1=1",oConn}
   	ASort(aPersExt)
		oSel:=SqlSelect{"select group_concat(externid,';',persid separator '##') as grpers from (select externid,cast(persid as char) as persid from person where externid in ("+Implode(aPersExt,',')+') order by externid) as gr group by 1=1',oConn}
		if oSel:RecCount>0 
			// persons found, so transactions can be processed automatically: 
			AEval(Split(oSel:grpers,'##'),{|x|AAdd(aPers,Split(x,';'))})  //{externid,persid},...
			for i:=1	to	Len(aValues) step	2
				if	!Empty(aValues[i,9])	.and.!Empty(aValues[i,11])	  // account and externid giver filled
					if	(nPers:=AScan(aPers,{|x|x[1]==aValues[i,11]}))>0
						//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid
						nAcc:=AScan(aAcc,{|x| x[2]==aValues[i,9]})
						if	nAcc>0
							cBankaccId:=aAcc[nAcc,1] 
							nAcc:=AScan(aAcc,{|x| x[2]==aValues[i+1,9]})
							if	nAcc>0 
								//	first	from bank account:
								AAdd(aValuesTrans,{cBankaccId,aValues[i,6],aValues[i,6],aValues[i,7],aValues[i,7],sCURR,aValues[i,4],;
									aValues[i,1],aValues[i,10],LOGON_EMP_ID,'2','1',aValues[i,2],aValues[i,3],'0',0})
								aValues[i,13]:=1	//	set importrans	to	processed 
								//	second transaction line	to	destination
								i++
								AAdd(aValuesTrans,{aAcc[nAcc,1],aValues[i,6],aValues[i,6],aValues[i,7],aValues[i,7],sCURR,aValues[i,4],;
									aValues[i,1],aValues[i,10],LOGON_EMP_ID,'2','2',aValues[i,2],aValues[i,3],aPers[nPers,2],0})	
								if	(nLastGift:=AScan(aValuesPers,{|x|x[1]=aPers[nPers,2]}))>0
									if	aValuesPers[nLastGift,2]<aValues[i,1]
										aValuesPers[nLastGift,2]:=aValues[i,1]
									endif
								else
									AAdd(aValuesPers,{aPers[nPers,2],aValues[i,1]})
								endif
								aValues[i,13]:=1	//	set importrans	to	processed
								i-- 
							endif
						endif
					endif
				endif
			next
			// prepare adapting mbalance values:
			oMBal:=Balances{}
			for i:=1 to Len(aValuesTrans) 
				//  1    2      3     4     5        6          7       8   9   10        11      12    13      14       15     16
				//accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid 
				oMBal:ChgBalance(aValuesTrans[i,1],SQLDate2Date(aValuesTrans[i,8]),Val(aValuesTrans[i,2]),Val(aValuesTrans[i,4]),Val(aValuesTrans[i,3]),;
					Val(aValuesTrans[i,5]),aValuesTrans[i,6])
			next
		endif

		// start storing into database:
		
		oStmnt:=SQLStatement{"set autocommit=0",oConn}
		oStmnt:Execute()
		oStmnt:=SQLStatement{'lock tables `importtrans` write,`mbalance` write'+iif(Len(aValuesPers)>0,',`person` write','')+',`transaction` write',oConn}      // alphabetic order
		oStmnt:Execute()

		oStmnt:=SQLStatement{"insert into importtrans ("+;
			"transdate,docid,transactnr,descriptn,giver,debitamnt,creditamnt,accname,accountnr,assmntcd,externid,origin,processed) values "+Implode(aValues,"','"),oConn}
		oStmnt:Execute() 
		if oStmnt:NumSuccessfulRows<1
			SQLStatement{"rollback",oConn}:Execute()
			SQLStatement{"unlock tables",oConn}:Execute()
			LogEvent(self,"error:"+oStmnt:SQLString,"LogErrors")
			ErrorBox{,self:oLan:WGet('Transactions could not be imported')+":"+oStmnt:status:Description}:show()
			return false 
		else
			nCnt:=oStmnt:NumSuccessfulRows/2
		endif
		if !Empty(aValuesTrans) 
			// insert first line:
			oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference) "+;
				" values ("+Implode(aValuesTrans[1],"','",1,14)+')',oConn}
			oStmnt:Execute()
			nTransId:=ConI(SqlSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
			aValuesTrans[2,16]:=nTransId
			for i:=3 to Len(aValuesTrans) step 2
				nTransId++
				aValuesTrans[i,16]:=nTransId
				aValuesTrans[i+1,16]:=nTransId
			next
			oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,transid) "+;
				" values "+Implode(aValuesTrans,"','",2),oConn}
			oStmnt:Execute()
			if oStmnt:NumSuccessfulRows<1
				SQLStatement{"rollback",oConn}:Execute() 
				SQLStatement{"unlock tables",oConn}:Execute()
				LogEvent(self,"error:"+oStmnt:SQLString,"LogErrors")
				ErrorBox{,self:oLan:WGet('Transactions could not be inserted')+":"+oStmnt:status:Description}:show()
				return false
			else
				nProc:=(oStmnt:NumSuccessfulRows+1)/2
			endif
			if !oMBal:ChgBalanceExecute()
				SQLStatement{"rollback",oConn}:Execute() 
				SQLStatement{"unlock tables",oConn}:Execute()
				LogEvent(self,"error:"+oMBal:cError,"LogErrors")
				ErrorBox{,self:oLan:WGet('Month balances could not be updated')+":"+oMBal:cError}:show()
				return false 
			endif
			// update persons:
			if !Empty(aValuesPers)
				ASort(aValuesPers,1,,{|x,y|x[1]<=y[1]},)
				oStmnt:=SQLStatement{"insert into person (persid,datelastgift) values "+Implode(aValuesPers,"','")+" on duplicate key update mailingcodes="+;
					"if(datelastgift='0000-00-00',concat(mailingcodes,' ','FI'),mailingcodes),datelastgift=if(datelastgift<values(datelastgift),values(datelastgift),datelastgift)",oConn} 
				oStmnt:Execute()
			endif
		endif
		SQLStatement{"commit",oConn}:Execute()
		SQLStatement{"unlock tables",oConn}:Execute()
		self:lv_imported:=self:lv_imported+nCnt
		self:lv_processed+=nProc 
	else
		// allready loaded
		nCnt:=0
	endif
	return true
METHOD SkipBatch(dummy:=nil as logic) as void pascal CLASS ImportBatch
* Unlock batch 
SQLStatement{"update importtrans set lock_id=0 where transactnr='"+self:cCurBatchNbr+;
"' and origin='"+self:cCurOrigin+"' and transdate='"+SQLdate(self:dCurDate)+"'",oConn}:execute()
SQLStatement{"commit",oConn}:execute()
RETURN 
RESOURCE ImportPatternBrowser DIALOGEX  4, 3, 534, 279
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", IMPORTPATTERNBROWSER_IMPORTPATTERNBROWSER_DETAIL, "static", WS_CHILD|WS_BORDER, 4, 25, 473, 235
	CONTROL	"Edit", IMPORTPATTERNBROWSER_EDITBUTTON, "Button", WS_TABSTOP|WS_CHILD, 486, 42, 40, 12
	CONTROL	"Delete", IMPORTPATTERNBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 486, 155, 40, 13
	CONTROL	"", IMPORTPATTERNBROWSER_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 324, 7, 47, 12
	CONTROL	"Found:", IMPORTPATTERNBROWSER_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 288, 8, 27, 12
	CONTROL	"Find", IMPORTPATTERNBROWSER_FINDBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 196, 7, 53, 12
	CONTROL	"", IMPORTPATTERNBROWSER_SEARCHUNI, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 7, 116, 12
	CONTROL	"Search like google:", IMPORTPATTERNBROWSER_FIXEDTEXT4, "Static", WS_CHILD, 12, 7, 64, 12
END

CLASS ImportPatternBrowser INHERIT DataWindowExtra 

	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oCCFindButton AS PUSHBUTTON
	PROTECT oDCSearchUni AS SINGLELINEEDIT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oSFImportPatternBrowser_DETAIL AS ImportPatternBrowser_DETAIL

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  	export oImpPat as SqlSelect 
  	export cWhereBase,cWhereSpec,cFields,cOrder,cFrom as string
METHOD DeleteButton( ) CLASS ImportPatternBrowser 
local oStmnt as SQLStatement
	IF self:Server:EOF.or.self:Server:reccount<1
		(ErrorBox{,"Select a pattern first"}):Show()
		RETURN nil
	ENDIF
	IF TextBox{ self, "Delete Import Pattern",;
		"Delete import pattern "+Compress(AllTrim(self:Server:origin)+": "+self:Server:descriptn)+' '+self:Server:assmntcd,BUTTONYESNO + BOXICONQUESTIONMARK }:Show() == BOXREPLYYES 
		oStmnt:=SQLStatement{"delete from importpattern where imppattrnid="+Str(self:Server:imppattrnid,-1),oConn}
		oStmnt:execute()
		if oStmnt:NumSuccessfulRows>0
			self:Server:execute()
			self:oSFImportPatternBrowser_DETAIL:Browser:REFresh()
			self:oSFImportPatternBrowser_DETAIL:GoTop()
		endif

	ENDIF

RETURN NIL
METHOD EditButton( ) CLASS ImportPatternBrowser 
	LOCAL oEdit as  EditImportPattern
	IF self:Server:EOF.or.self:Server:reccount<1
		(ErrorBox{,"Select a pattern first"}):Show()
		RETURN nil
	ENDIF
	oEdit:= EditImportPattern{self:owner,,self:Server,self:oSFImportPatternBrowser_DETAIL}
	oEdit:Show()

RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS ImportPatternBrowser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"ImportPatternBrowser",_GetInst()},iCtlID)

oCCEditButton := PushButton{SELF,ResourceID{IMPORTPATTERNBROWSER_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:OwnerAlignment := OA_PX

oCCDeleteButton := PushButton{SELF,ResourceID{IMPORTPATTERNBROWSER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PX

oDCFound := FixedText{SELF,ResourceID{IMPORTPATTERNBROWSER_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{IMPORTPATTERNBROWSER_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

oCCFindButton := PushButton{SELF,ResourceID{IMPORTPATTERNBROWSER_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Find",NULL_STRING,NULL_STRING}

oDCSearchUni := SingleLineEdit{SELF,ResourceID{IMPORTPATTERNBROWSER_SEARCHUNI,_GetInst()}}
oDCSearchUni:HyperLabel := HyperLabel{#SearchUni,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchUni:FocusSelect := FSEL_TRIM
oDCSearchUni:TooltipText := "Enter one or more (part of) key values "
oDCSearchUni:UseHLforToolTip := True

oDCFixedText4 := FixedText{SELF,ResourceID{IMPORTPATTERNBROWSER_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Search like google:",NULL_STRING,NULL_STRING}

SELF:Caption := "Import Pattern Browser"
SELF:HyperLabel := HyperLabel{#ImportPatternBrowser,"Import Pattern Browser",NULL_STRING,NULL_STRING}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFImportPatternBrowser_DETAIL := ImportPatternBrowser_DETAIL{SELF,IMPORTPATTERNBROWSER_IMPORTPATTERNBROWSER_DETAIL}
oSFImportPatternBrowser_DETAIL:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method PostInit(oWindow,iCtlID,oServer,uExtra) class ImportPatternBrowser
	//Put your PostInit additions here
	self:SetTexts()
  	self:oDCFound:TextValue :=Str(self:oImpPat:Reccount,-1)
	return nil

method PreInit(oWindow,iCtlID,oServer,uExtra) class ImportPatternBrowser
	//Put your PreInit additions here
	self:cFields:="t.imppattrnid,t.origin,t.assmntcd,t.debcre,t.descriptn,t.accid,t.automatic,cast(t.recdate as date) as recdate,"+;
	"a.accnumber,a.description as accountname"
	self:cFrom:="importpattern t left join account a on (a.accid=t.accid)"
	self:cWhereBase:=""
	self:cWhereSpec:=""
	self:cOrder:="accnumber"

	self:oImpPat:=SqlSelect{"select "+self:cFields+" from "+self:cFrom+" where "+iif(Empty(self:cWhereSpec),"1",self:cWhereSpec)+" order by "+self:cOrder,oConn}
	return nil

ACCESS SearchUni() CLASS ImportPatternBrowser
RETURN SELF:FieldGet(#SearchUni)

ASSIGN SearchUni(uValue) CLASS ImportPatternBrowser
SELF:FieldPut(#SearchUni, uValue)
RETURN uValue

STATIC DEFINE IMPORTPATTERNBROWSER_DELETEBUTTON := 102 
RESOURCE ImportPatternBrowser_DETAIL DIALOGEX  2, 2, 472, 234
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

CLASS ImportPatternBrowser_DETAIL INHERIT DataWindowMine 

	PROTECT oDBACCNUMBER as DataColumn
	PROTECT oDBACCOUNTNAME as DataColumn
	PROTECT oDBORIGIN as DataColumn
	PROTECT oDBDESCRIPTN as DataColumn
	PROTECT oDBDEBCRE as DataColumn
	PROTECT oDBRECDATE as DataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  protect oOwner as ImportPatternBrowser
ACCESS Accnumber() CLASS ImportPatternBrowser_DETAIL
RETURN SELF:FieldGet(#Accnumber)

ASSIGN Accnumber(uValue) CLASS ImportPatternBrowser_DETAIL
SELF:FieldPut(#Accnumber, uValue)
RETURN uValue

ACCESS accountname() CLASS ImportPatternBrowser_DETAIL
RETURN SELF:FieldGet(#accountname)

ASSIGN accountname(uValue) CLASS ImportPatternBrowser_DETAIL
SELF:FieldPut(#accountname, uValue)
RETURN uValue

ACCESS debcre() CLASS ImportPatternBrowser_DETAIL
RETURN SELF:FieldGet(#debcre)

ASSIGN debcre(uValue) CLASS ImportPatternBrowser_DETAIL
SELF:FieldPut(#debcre, uValue)
RETURN uValue

ACCESS descriptn() CLASS ImportPatternBrowser_DETAIL
RETURN SELF:FieldGet(#descriptn)

ASSIGN descriptn(uValue) CLASS ImportPatternBrowser_DETAIL
SELF:FieldPut(#descriptn, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS ImportPatternBrowser_DETAIL 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"ImportPatternBrowser_DETAIL",_GetInst()},iCtlID)

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#ImportPatternBrowser_DETAIL,"DataWindow Caption",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:OwnerAlignment := OA_PWIDTH_PHEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBACCNUMBER := DataColumn{account_ACCNUMBER{}}
oDBACCNUMBER:Width := 13
oDBACCNUMBER:HyperLabel := HyperLabel{#Accnumber,"Account","Number of account",NULL_STRING} 
oDBACCNUMBER:Caption := "Account"
self:Browser:AddColumn(oDBACCNUMBER)

oDBACCOUNTNAME := DataColumn{17}
oDBACCOUNTNAME:Width := 17
oDBACCOUNTNAME:HyperLabel := HyperLabel{#accountname,"Account Name",NULL_STRING,NULL_STRING} 
oDBACCOUNTNAME:Caption := "Account Name"
self:Browser:AddColumn(oDBACCOUNTNAME)

oDBORIGIN := DataColumn{10}
oDBORIGIN:Width := 10
oDBORIGIN:HyperLabel := HyperLabel{#origin,"Origin",NULL_STRING,NULL_STRING} 
oDBORIGIN:Caption := "Origin"
self:Browser:AddColumn(oDBORIGIN)

oDBDESCRIPTN := DataColumn{ImportTrans_Descrptn{}}
oDBDESCRIPTN:Width := 47
oDBDESCRIPTN:HyperLabel := HyperLabel{#descriptn,"Description",NULL_STRING,NULL_STRING} 
oDBDESCRIPTN:Caption := "Description"
self:Browser:AddColumn(oDBDESCRIPTN)

oDBDEBCRE := DataColumn{12}
oDBDEBCRE:Width := 12
oDBDEBCRE:HyperLabel := HyperLabel{#debcre,"Debit/Credit",NULL_STRING,NULL_STRING} 
oDBDEBCRE:Caption := "Debit/Credit"
self:Browser:AddColumn(oDBDEBCRE)

oDBRECDATE := DataColumn{17}
oDBRECDATE:Width := 17
oDBRECDATE:HyperLabel := HyperLabel{#recdate,"Date Changed",NULL_STRING,NULL_STRING} 
oDBRECDATE:Caption := "Date Changed"
self:Browser:AddColumn(oDBRECDATE)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS origin() CLASS ImportPatternBrowser_DETAIL
RETURN self:FieldGet(#origin)
ASSIGN origin(uValue) CLASS ImportPatternBrowser_DETAIL
SELF:FieldPut(#origin, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class ImportPatternBrowser_DETAIL
	//Put your PostInit additions here
	self:SetTexts()
	self:Browser:SetStandardStyle(gbsReadOnly) 
	self:GoTop()
	return nil

method PreInit(oWindow,iCtlID,oServer,uExtra) class ImportPatternBrowser_DETAIL
	//Put your PreInit additions here
	self:oOwner:=oWindow
	oWindow:use(oWindow:oImpPat)
	return nil

ACCESS recdate() CLASS ImportPatternBrowser_DETAIL
RETURN SELF:FieldGet(#recdate)

ASSIGN recdate(uValue) CLASS ImportPatternBrowser_DETAIL
SELF:FieldPut(#recdate, uValue)
RETURN uValue

STATIC DEFINE IMPORTPATTERNBROWSER_DETAIL_ACCNUMBER := 100 
STATIC DEFINE IMPORTPATTERNBROWSER_DETAIL_ACCOUNTNAME := 101 
STATIC DEFINE IMPORTPATTERNBROWSER_DETAIL_DEBCRE := 104 
STATIC DEFINE IMPORTPATTERNBROWSER_DETAIL_DESCRIPTN := 103 
STATIC DEFINE IMPORTPATTERNBROWSER_DETAIL_ORIGIN := 102 
STATIC DEFINE IMPORTPATTERNBROWSER_DETAIL_RECDATE := 105 
STATIC DEFINE IMPORTPATTERNBROWSER_EDITBUTTON := 101 
STATIC DEFINE IMPORTPATTERNBROWSER_FINDBUTTON := 105 
STATIC DEFINE IMPORTPATTERNBROWSER_FIXEDTEXT4 := 107 
STATIC DEFINE IMPORTPATTERNBROWSER_FOUND := 103 
STATIC DEFINE IMPORTPATTERNBROWSER_FOUNDTEXT := 104 
STATIC DEFINE IMPORTPATTERNBROWSER_IMPORTPATTERNBROWSER_DETAIL := 100 
STATIC DEFINE IMPORTPATTERNBROWSER_SEARCHUNI := 106 
