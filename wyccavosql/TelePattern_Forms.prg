RESOURCE EditTeleBankPattern DIALOGEX  4, 3, 319, 162
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Account:", EDITTELEBANKPATTERN_MACCOUNT, "Edit", ES_AUTOHSCROLL|WS_CHILD|WS_DISABLED|WS_BORDER, 68, 51, 82, 13, WS_EX_CLIENTEDGE
	CONTROL	"Bank/Giro:", EDITTELEBANKPATTERN_MCONTRA_BANKACCNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 68, 30, 80, 13, WS_EX_CLIENTEDGE
	CONTROL	"Naam Tegnr:", EDITTELEBANKPATTERN_MCONTRA_NAME, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 180, 30, 120, 13, WS_EX_CLIENTEDGE
	CONTROL	"", EDITTELEBANKPATTERN_MKIND, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 68, 12, 68, 13, WS_EX_CLIENTEDGE
	CONTROL	"Type:", EDITTELEBANKPATTERN_SC_KIND, "Static", WS_CHILD, 13, 12, 31, 13
	CONTROL	"Bank account#:", EDITTELEBANKPATTERN_SC_CONTRA_BANKACCNT, "Static", WS_CHILD, 13, 30, 54, 13
	CONTROL	"Name:", EDITTELEBANKPATTERN_SC_CONTRA_NAME, "Static", WS_CHILD, 154, 30, 24, 13
	CONTROL	"Description:", EDITTELEBANKPATTERN_SC_DESCRIPTION, "Static", WS_CHILD, 13, 73, 45, 13
	CONTROL	"Account:", EDITTELEBANKPATTERN_SC_REK, "Static", WS_CHILD, 13, 52, 31, 13
	CONTROL	"Oms:", EDITTELEBANKPATTERN_MDESCRIPTION, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 67, 73, 217, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITTELEBANKPATTERN_ACCBUTTON, "Button", WS_CHILD|NOT WS_VISIBLE, 148, 51, 14, 13
	CONTROL	"Debit/Credit", EDITTELEBANKPATTERN_MADDSUB, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 67, 91, 57, 46
	CONTROL	"Debit", EDITTELEBANKPATTERN_RADIOBUTTON1, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 73, 101, 39, 11
	CONTROL	"Credit", EDITTELEBANKPATTERN_RADIOBUTTON2, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 73, 113, 41, 11
	CONTROL	"Both", EDITTELEBANKPATTERN_RADIOBUTTON3, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 73, 124, 40, 12
	CONTROL	"Automatic processing of recognised records?", EDITTELEBANKPATTERN_MIND_AUTMUT, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 136, 94, 156, 11
	CONTROL	"", EDITTELEBANKPATTERN_RECDATE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 220, 12, 80, 12, WS_EX_CLIENTEDGE
	CONTROL	"Date changed:", EDITTELEBANKPATTERN_FIXEDTEXT5, "Static", WS_CHILD, 170, 12, 50, 13
	CONTROL	"", EDITTELEBANKPATTERN_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 7, 1, 301, 141
	CONTROL	"OK", EDITTELEBANKPATTERN_SAVEBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 254, 144, 54, 12
	CONTROL	"Cancel", EDITTELEBANKPATTERN_CANCELBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 196, 144, 53, 12
END

CLASS EditTeleBankPattern INHERIT DataDialogMine 

	PROTECT oDCmAccount AS SINGLELINEEDIT
	PROTECT oDCmContra_Bankaccnt AS SINGLELINEEDIT
	PROTECT oDCmcontra_name AS SINGLELINEEDIT
	PROTECT oDCmKind AS SINGLELINEEDIT
	PROTECT oDCSC_KIND AS FIXEDTEXT
	PROTECT oDCSC_contra_bankaccnt AS FIXEDTEXT
	PROTECT oDCSC_contra_name AS FIXEDTEXT
	PROTECT oDCSC_description AS FIXEDTEXT
	PROTECT oDCSC_REK AS FIXEDTEXT
	PROTECT oDCmdescription AS SINGLELINEEDIT
	PROTECT oCCAccButton AS PUSHBUTTON
	PROTECT oDCmAddSub AS RADIOBUTTONGROUP
	PROTECT oCCRadioButton1 AS RADIOBUTTON
	PROTECT oCCRadioButton2 AS RADIOBUTTON
	PROTECT oCCRadioButton3 AS RADIOBUTTON
	PROTECT oDCmIND_AUTMUT AS CHECKBOX
	PROTECT oDCRecdate AS SINGLELINEEDIT
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCGroupBox1 AS GROUPBOX
	PROTECT oCCSaveButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
	instance mTegenGiro 
	instance mcontra_name 
	instance mAccount 
	instance mdescription 
	instance mAddSub 
	instance mInd_AutMut 
	instance Recdate 
	instance mkind
	PROTECT lNew := FALSE as LOGIC
	PROTECT oTele as Telemut
	PROTECT cAccountName as STRING
	EXPORT maccid,CurTelPatId as STRING
	PROTECT oBrowse as SQLSelect 
	protect oOwner as DataWindow
METHOD AccButton(lUnique ) CLASS EditTeleBankPattern 
	Default(@lUnique,false)
	AccountSelect(self,AllTrim(oDCmAccount:TEXTValue ),"Account",lUnique)
	RETURN 

	RETURN NIL
METHOD CancelButton( ) CLASS EditteleBankPattern
	self:EndWindow()
	RETURN nil
method Close(oEvent) class EditTeleBankPattern
self:Destroy()
	RETURN SUPER:Close(oEvent)
	//Put your changes here
	return NIL
method EditFocusChange(oEditFocusChangeEvent) class EditTeleBankPattern
	local oControl as Control
	local lGotFocus as logic
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	super:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus .and.!IsNil(oControl:VALUE)
		IF oControl:Name == "MACCOUNT".and.!AllTrim(oControl:TextVALUE)==AllTrim(cAccountName)
			cAccountName:=AllTrim(oControl:TextVALUE)
			self:AccButton(true)
		ENDIF
	ENDIF
	return nil
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditTeleBankPattern 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditTeleBankPattern",_GetInst()},iCtlID)

oDCmAccount := SingleLineEdit{SELF,ResourceID{EDITTELEBANKPATTERN_MACCOUNT,_GetInst()}}
oDCmAccount:HyperLabel := HyperLabel{#mAccount,"Account:","Number of  Account","Rek_REK"}

oDCmContra_Bankaccnt := SingleLineEdit{SELF,ResourceID{EDITTELEBANKPATTERN_MCONTRA_BANKACCNT,_GetInst()}}
oDCmContra_Bankaccnt:FieldSpec := BANK{}
oDCmContra_Bankaccnt:HyperLabel := HyperLabel{#mContra_Bankaccnt,"Bank/Giro:","Number of bankaccount","BANK"}

oDCmcontra_name := SingleLineEdit{SELF,ResourceID{EDITTELEBANKPATTERN_MCONTRA_NAME,_GetInst()}}
oDCmcontra_name:FieldSpec := TeleBankPatterns_contra_name{}
oDCmcontra_name:HyperLabel := HyperLabel{#mcontra_name,"Naam Tegnr:",NULL_STRING,"TeleBankPatterns_contra_name"}

oDCmKind := SingleLineEdit{SELF,ResourceID{EDITTELEBANKPATTERN_MKIND,_GetInst()}}
oDCmKind:FieldSpec := TeleBankPatterns_Kind{}
oDCmKind:HyperLabel := HyperLabel{#mKind,NULL_STRING,NULL_STRING,NULL_STRING}

oDCSC_KIND := FixedText{SELF,ResourceID{EDITTELEBANKPATTERN_SC_KIND,_GetInst()}}
oDCSC_KIND:HyperLabel := HyperLabel{#SC_KIND,"Type:",NULL_STRING,NULL_STRING}

oDCSC_contra_bankaccnt := FixedText{SELF,ResourceID{EDITTELEBANKPATTERN_SC_CONTRA_BANKACCNT,_GetInst()}}
oDCSC_contra_bankaccnt:HyperLabel := HyperLabel{#SC_contra_bankaccnt,"Bank account#:",NULL_STRING,NULL_STRING}

oDCSC_contra_name := FixedText{SELF,ResourceID{EDITTELEBANKPATTERN_SC_CONTRA_NAME,_GetInst()}}
oDCSC_contra_name:HyperLabel := HyperLabel{#SC_contra_name,"Name:",NULL_STRING,NULL_STRING}

oDCSC_description := FixedText{SELF,ResourceID{EDITTELEBANKPATTERN_SC_DESCRIPTION,_GetInst()}}
oDCSC_description:HyperLabel := HyperLabel{#SC_description,"Description:",NULL_STRING,NULL_STRING}

oDCSC_REK := FixedText{SELF,ResourceID{EDITTELEBANKPATTERN_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,"Account:",NULL_STRING,NULL_STRING}

oDCmdescription := SingleLineEdit{SELF,ResourceID{EDITTELEBANKPATTERN_MDESCRIPTION,_GetInst()}}
oDCmdescription:HyperLabel := HyperLabel{#mdescription,"Oms:",NULL_STRING,"TeleBankPatterns_description"}
oDCmdescription:TooltipText := "enter one or more keywords from transaction description"

oCCAccButton := PushButton{SELF,ResourceID{EDITTELEBANKPATTERN_ACCBUTTON,_GetInst()}}
oCCAccButton:HyperLabel := HyperLabel{#AccButton,"v","Browse in accounts",NULL_STRING}
oCCAccButton:TooltipText := "Browse in accounts"

oCCRadioButton1 := RadioButton{SELF,ResourceID{EDITTELEBANKPATTERN_RADIOBUTTON1,_GetInst()}}
oCCRadioButton1:HyperLabel := HyperLabel{#RadioButton1,"Debit",NULL_STRING,NULL_STRING}

oCCRadioButton2 := RadioButton{SELF,ResourceID{EDITTELEBANKPATTERN_RADIOBUTTON2,_GetInst()}}
oCCRadioButton2:HyperLabel := HyperLabel{#RadioButton2,"Credit",NULL_STRING,NULL_STRING}

oCCRadioButton3 := RadioButton{SELF,ResourceID{EDITTELEBANKPATTERN_RADIOBUTTON3,_GetInst()}}
oCCRadioButton3:HyperLabel := HyperLabel{#RadioButton3,"Both",NULL_STRING,NULL_STRING}

oDCmIND_AUTMUT := CheckBox{SELF,ResourceID{EDITTELEBANKPATTERN_MIND_AUTMUT,_GetInst()}}
oDCmIND_AUTMUT:HyperLabel := HyperLabel{#mIND_AUTMUT,"Automatic processing of recognised records?",NULL_STRING,NULL_STRING}

oDCRecdate := SingleLineEdit{SELF,ResourceID{EDITTELEBANKPATTERN_RECDATE,_GetInst()}}
oDCRecdate:HyperLabel := HyperLabel{#Recdate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{EDITTELEBANKPATTERN_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Date changed:",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{EDITTELEBANKPATTERN_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,NULL_STRING,NULL_STRING,NULL_STRING}

oCCSaveButton := PushButton{SELF,ResourceID{EDITTELEBANKPATTERN_SAVEBUTTON,_GetInst()}}
oCCSaveButton:HyperLabel := HyperLabel{#SaveButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITTELEBANKPATTERN_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCmAddSub := RadioButtonGroup{SELF,ResourceID{EDITTELEBANKPATTERN_MADDSUB,_GetInst()}}
oDCmAddSub:FillUsing({ ;
						{oCCRadioButton1,"A"}, ;
						{oCCRadioButton2,"B"}, ;
						{oCCRadioButton3,"RadioButton3"} ;
						})
oDCmAddSub:HyperLabel := HyperLabel{#mAddSub,"Debit/Credit",NULL_STRING,"TeleBankPatterns_AddSub"}

SELF:Caption := "Pattern for reconciliation of telebanking transactions"
SELF:HyperLabel := HyperLabel{#EditTeleBankPattern,"Pattern for reconciliation of telebanking transactions",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := False

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mAccount() CLASS EditTeleBankPattern
RETURN SELF:FieldGet(#mAccount)

ASSIGN mAccount(uValue) CLASS EditTeleBankPattern
SELF:FieldPut(#mAccount, uValue)
RETURN uValue

ACCESS mAddSub() CLASS EditTeleBankPattern
RETURN SELF:FieldGet(#mAddSub)

ASSIGN mAddSub(uValue) CLASS EditTeleBankPattern
SELF:FieldPut(#mAddSub, uValue)
RETURN uValue

ACCESS mContra_Bankaccnt() CLASS EditTeleBankPattern
RETURN SELF:FieldGet(#mContra_Bankaccnt)

ASSIGN mContra_Bankaccnt(uValue) CLASS EditTeleBankPattern
SELF:FieldPut(#mContra_Bankaccnt, uValue)
RETURN uValue

ACCESS mcontra_name() CLASS EditTeleBankPattern
RETURN SELF:FieldGet(#mcontra_name)

ASSIGN mcontra_name(uValue) CLASS EditTeleBankPattern
SELF:FieldPut(#mcontra_name, uValue)
RETURN uValue

ACCESS mdescription() CLASS EditTeleBankPattern
RETURN SELF:FieldGet(#mdescription)

ASSIGN mdescription(uValue) CLASS EditTeleBankPattern
SELF:FieldPut(#mdescription, uValue)
RETURN uValue

ACCESS mIND_AUTMUT() CLASS EditTeleBankPattern
RETURN SELF:FieldGet(#mIND_AUTMUT)

ASSIGN mIND_AUTMUT(uValue) CLASS EditTeleBankPattern
SELF:FieldPut(#mIND_AUTMUT, uValue)
RETURN uValue

ACCESS mKind() CLASS EditTeleBankPattern
RETURN SELF:FieldGet(#mKind)

ASSIGN mKind(uValue) CLASS EditTeleBankPattern
SELF:FieldPut(#mKind, uValue)
RETURN uValue

ACCESS mTEGENGIRO() CLASS EditTeleBankPattern
RETURN SELF:FieldGet(#mTEGENGIRO)

ASSIGN mTEGENGIRO(uValue) CLASS EditTeleBankPattern
SELF:FieldPut(#mTEGENGIRO, uValue)
RETURN uValue

method PostInit(oWindow,iCtlID,oServer,uExtra) class EditTeleBankPattern
	//Put your PostInit additions here
	self:SetTexts()
	*	IF !Empty(uExtra).and.!IsNil(uExtra).and.!empty[uExtra[1])
	IF ClassName(uExtra)==#TeleMut
		lNew := true
		self:oDCmAccount:Disable()
		oTele:=uExtra
	ELSE  // TelePatternBrowser_DETAIL
		lNew := FALSE
		oBrowse:=self:Server
// 		self:oDCmAccount:Enable() 
// 		self:oCCAccButton:Show()
		self:maccid := Transform(self:Server:accid,"")
		self:mdescription := self:Server:description
		self:mkind := self:Server:kind
		self:mcontra_bankaccnt := self:Server:contra_bankaccnt
		self:mcontra_name := self:Server:contra_name
		self:mAddSub := self:Server:addsub
		self:mInd_AutMut := if(Empty(self:Server:Ind_AutMut),FALSE,true)
		self:CurTelPatId:=str(self:server:telpatid,-1)
		self:oDCmAccount:TextValue := Transform(self:Server:accountname,"")
		self:oOwner:=uExtra
	ENDIF
	RETURN nil
ACCESS Recdate() CLASS EditTeleBankPattern
RETURN SELF:FieldGet(#Recdate)

ASSIGN Recdate(uValue) CLASS EditTeleBankPattern
SELF:FieldPut(#Recdate, uValue)
RETURN uValue

METHOD RegAccount(oAcc,ItemName) CLASS EditTelebankPattern
	IF Empty(oAcc).or.oAcc==null_object
		RETURN
	ENDIF
	self:maccid :=  Str(oAcc:accid,-1)
	self:oDCmAccount:TEXTValue := AllTrim(oAcc:Description)
	self:cAccountName := AllTrim(oAcc:Description)

RETURN true
METHOD SaveButton( ) CLASS EditTelebankPattern
	LOCAL oMyServer as SQLStatement
	local cStatement as string
	local nCurRec as int
	
	IF Empty(maccid)
		(ErrorBox{self,"Account mandatory!"}):Show()
		RETURN
	ENDIF 
	
	if !lNew .and.!Empty(self:oOwner)
		nCurRec:=self:oOwner:Server:recno
	endif
	cStatement:=iif(lNew,"insert into","update")+" telebankpatterns set "+;
		"contra_bankaccnt='"+self:mcontra_bankaccnt+"'"+;
		",accid ="+maccid+;
		",description='"+iif(Empty(self:mdescription),'',self:mdescription)+"'"+;
		",kind ='"+AllTrim(self:mkind)+"'"+;
		",contra_name ='"+self:mcontra_name+"'"+;
		",addsub ='"+self:mAddSub+"'"+;
		",ind_autmut ="+iif(self:mInd_AutMut,'1','0')+;
		",recdate=Now()"+;
		iif(lNew,""," where telpatid="+self:CurTelPatId)
	oMyServer:=SQLStatement{cStatement,oConn}
	oMyServer:Execute()
	if oMyServer:NumSuccessfulRows>0
		IF lNew
			AAdd(self:oTele:teleptrn,{;
				self:mcontra_bankaccnt,;
				AllTrim(self:mkind),;
				SubStr(AllTrim(self:mcontra_name),1,32),;
				self:mAddSub,;
				Split(AllTrim(self:mdescription),Space(1)),;
				maccid,;
				logic(_cast,self:mInd_AutMut)})
			IF !oTele:oTelTr:EOF
				IF oTele:CheckPattern()
					oTele:oParent:ProcRecognised()
				ENDIF
			ENDIF				
		ENDIF 
	endif
	self:EndWindow()
	if !lNew .and.!Empty(self:oOwner)
		self:oOwner:Server:Execute()
		self:oOwner:GoTo(nCurRec)
	endif
	RETURN nil


	


	
STATIC DEFINE EDITTELEBANKPATTERN_ACCBUTTON := 110 
STATIC DEFINE EDITTELEBANKPATTERN_CANCELBUTTON := 120 
STATIC DEFINE EDITTELEBANKPATTERN_FIXEDTEXT5 := 117 
STATIC DEFINE EDITTELEBANKPATTERN_GROUPBOX1 := 118 
STATIC DEFINE EDITTELEBANKPATTERN_MACCOUNT := 100 
STATIC DEFINE EDITTELEBANKPATTERN_MADDSUB := 111 
STATIC DEFINE EDITTELEBANKPATTERN_MCONTRA_BANKACCNT := 101 
STATIC DEFINE EDITTELEBANKPATTERN_MCONTRA_NAME := 102 
STATIC DEFINE EDITTELEBANKPATTERN_MDESCRIPTION := 109 
STATIC DEFINE EDITTELEBANKPATTERN_MIND_AUTMUT := 115 
STATIC DEFINE EDITTELEBANKPATTERN_MKIND := 103 
STATIC DEFINE EDITTELEBANKPATTERN_RADIOBUTTON1 := 112 
STATIC DEFINE EDITTELEBANKPATTERN_RADIOBUTTON2 := 113 
STATIC DEFINE EDITTELEBANKPATTERN_RADIOBUTTON3 := 114 
STATIC DEFINE EDITTELEBANKPATTERN_RECDATE := 116 
STATIC DEFINE EDITTELEBANKPATTERN_SAVEBUTTON := 119 
STATIC DEFINE EDITTELEBANKPATTERN_SC_CONTRA_BANKACCNT := 105 
STATIC DEFINE EDITTELEBANKPATTERN_SC_CONTRA_NAME := 106 
STATIC DEFINE EDITTELEBANKPATTERN_SC_DESCRIPTION := 107 
STATIC DEFINE EDITTELEBANKPATTERN_SC_KIND := 104 
STATIC DEFINE EDITTELEBANKPATTERN_SC_REK := 108 
STATIC DEFINE EDITTELEPATTERN_ACCBUTTON := 110 
STATIC DEFINE EDITTELEPATTERN_CANCELBUTTON := 120 
STATIC DEFINE EDITTELEPATTERN_FIXEDTEXT5 := 117 
STATIC DEFINE EDITTELEPATTERN_GROUPBOX1 := 118 
STATIC DEFINE EDITTELEPATTERN_MACCOUNT := 108 
STATIC DEFINE EDITTELEPATTERN_MCODE_AF_BY := 111 
STATIC DEFINE EDITTELEPATTERN_MIND_AUTMUT := 115 
STATIC DEFINE EDITTELEPATTERN_MMUTSOORT := 105 
STATIC DEFINE EDITTELEPATTERN_MNAAM_TEGNR := 107 
STATIC DEFINE EDITTELEPATTERN_MOMS := 109 
STATIC DEFINE EDITTELEPATTERN_MTEGENGIRO := 106 
STATIC DEFINE EDITTELEPATTERN_RADIOBUTTON1 := 112 
STATIC DEFINE EDITTELEPATTERN_RADIOBUTTON2 := 113 
STATIC DEFINE EDITTELEPATTERN_RADIOBUTTON3 := 114 
STATIC DEFINE EDITTELEPATTERN_RECDATE := 116 
STATIC DEFINE EDITTELEPATTERN_SAVEBUTTON := 119 
STATIC DEFINE EDITTELEPATTERN_SC_MUTSOORT := 100 
STATIC DEFINE EDITTELEPATTERN_SC_NAAM_TEGNR := 102 
STATIC DEFINE EDITTELEPATTERN_SC_OMS := 103 
STATIC DEFINE EDITTELEPATTERN_SC_REK := 104 
STATIC DEFINE EDITTELEPATTERN_SC_TEGENGIRO := 101 
CLASS TelePatternBrowser INHERIT DataWindowExtra 

	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCDeleteButton AS PUSHBUTTON
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oCCFindButton AS PUSHBUTTON
	PROTECT oDCSearchUni AS SINGLELINEEDIT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oSFTelePatternBrowser_DETAIL AS TelePatternBrowser_DETAIL

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  	export oTelPat as SQLSelect 
  	export cWhereBase,cWhereSpec,cFields,cOrder,cFrom as string

RESOURCE TelePatternBrowser DIALOGEX  7, 8, 531, 265
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TELEPATTERNBROWSER_TELEPATTERNBROWSER_DETAIL, "static", WS_CHILD|WS_BORDER, 4, 25, 473, 235
	CONTROL	"Edit", TELEPATTERNBROWSER_EDITBUTTON, "Button", WS_TABSTOP|WS_CHILD, 486, 42, 40, 12
	CONTROL	"Delete", TELEPATTERNBROWSER_DELETEBUTTON, "Button", WS_TABSTOP|WS_CHILD, 486, 155, 40, 13
	CONTROL	"", TELEPATTERNBROWSER_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 324, 7, 47, 12
	CONTROL	"Found:", TELEPATTERNBROWSER_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 288, 8, 27, 12
	CONTROL	"Find", TELEPATTERNBROWSER_FINDBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 196, 7, 53, 12
	CONTROL	"", TELEPATTERNBROWSER_SEARCHUNI, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 7, 116, 12
	CONTROL	"Search like google:", TELEPATTERNBROWSER_FIXEDTEXT4, "Static", WS_CHILD, 12, 7, 64, 12
END

METHOD Close(oEvent) CLASS TelePatternBrowser
*	SUPER:Close(oEvent)
	//Put your changes here
	SELF:oSFTelePatternBrowser_DETAIL:Close()
	SELF:oSFTelePatternBrowser_DETAIL:Destroy()
	SELF:destroy()
	RETURN NIL
METHOD DeleteButton( ) CLASS TelePatternBrowser 
local oStmnt as SQLStatement
	IF self:Server:EOF.or.self:Server:reccount<1
		(Errorbox{,"Select a pattern first"}):Show()
		RETURN NIL
	ENDIF
	IF TextBox{ self, "Delete TelePattern",;
		"Delete TelePattern "+Compress(AllTrim(self:Server:contra_bankaccnt)+":"+self:Server:contra_name+self:Server:Description),BUTTONYESNO + BOXICONQUESTIONMARK }:Show() == BOXREPLYYES 
		oStmnt:=SQLStatement{"delete from telebankpatterns where telpatid="+Str(self:Server:telpatID,-1),oConn}
		oStmnt:execute()
		if oStmnt:NumSuccessfulRows>0
			self:Server:execute()
			self:oSFTelePatternBrowser_DETAIL:GoTop()
			if self:Server:reccount <1
				oSFTelePatternBrowser_DETAIL:Browser:REFresh()
			endif
		endif

	ENDIF

	RETURN NIL
METHOD Editbutton() CLASS TelePatternBrowser
	LOCAL oEdit as  EditteleBankPattern
	IF self:Server:EOF.or.self:Server:reccount<1
		(Errorbox{,"Select a pattern first"}):Show()
		RETURN NIL
	ENDIF
	oEdit:= EditTeleBankPattern{self:owner,,self:Server,self:oSFTelePatternBrowser_DETAIL}
	oEdit:Show()
	RETURN
METHOD FilePrint CLASS TelePatternBrowser
LOCAL oTele as SQLSelect
LOCAL kopregels AS ARRAY
LOCAL nRow as int
LOCAL nPage as int
LOCAL oReport AS PrintDialog

oReport := PrintDialog{self,oLan:RGet("Telebank Patterns"),,119}

oReport:Show()
IF .not.oReport:lPrintOk
	RETURN FALSE
ENDIF
oTele := SELF:Server
oTele:suspendnotification()
oTele:GoTop()
kopregels := {oLan:RGet('Telebank Patterns',,"@!"),' ',;
oLan:RGet("Number",12,"!")+oLan:RGet("Account",21,"!")+oLan:RGet("CounterAcc",15,"!","R")+" "+;
oLan:RGet("Name",26,"!")+oLan:RGet("Description",26,"!")+oLan:RGet("D/C",4,"!")+oLan:RGet("Aut",4,"!")+oLan:RGet('DATE',10,"!")}
nRow := 0
nPage := 0
DO WHILE .not. oTele:EOF
   oReport:PrintLine(@nRow,@nPage,Pad(oTele:ACCNUMBER,12)+Pad(oTele:accountname,20)+" "+Pad(NTrim(oTele:contra_bankaccnt),15)+' '+;
	Pad(oTele:contra_name,25)+" "+Pad(oTele:description,25)+"  "+Pad(oTele:addsub,4)+if(oTele:IND_AUTMUT,"X"," ")+'  '+;
    DToC(oTele:RECDATE),kopregels)
   oTele:skip()
ENDDO
oTele:ResetNotification()
oReport:prstart()
oReport:prstop()
RETURN SELF
METHOD FindButton( ) CLASS TelePatternBrowser 
	local aKeyw:={} as array
	local aFields:={"a.accnumber","a.description","t.contra_bankaccnt","t.contra_name","t.description","t.kind"} as array
	local i,j as int 
	self:cWhereSpec:=""
	if !Empty(self:SearchUni)
		self:SearchUni:=Lower(AllTrim(self:SearchUni)) 
		aKeyw:=GetTokens(self:SearchUni)
		for i:=1 to Len(aKeyw)
			self:cWhereSpec+=iif(i>1," and ","")+"("
			for j:=1 to Len(AFields)
				self:cWhereSpec+=iif(j=1,""," or ")+AFields[j]+" like '%"+aKeyw[i,1]+"%'"
			next
			self:cWhereSpec+=")"
		next
	endif
	self:oTelPat:SQLString:="select "+self:cFields+" from "+self:cFrom+" where "+iif(Empty(self:cWhereSpec),"1",self:cWhereSpec)+" order by "+self:cOrder
   self:oTelPat:Execute() 

	if !Empty(self:oTelPat:status) 
	 	LogEvent(,"findbutton telepattern:"+self:oTelPat:status:description+"( statmnt:"+self:oTelPat:SQLString,"LogErrors")
	endif
   self:oTelPat:GoTop()
   self:GoTop()
  	self:oDCFound:TextValue :=Str(self:oTelPat:Reccount,-1)

RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TelePatternBrowser 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TelePatternBrowser",_GetInst()},iCtlID)

oCCEditButton := PushButton{SELF,ResourceID{TELEPATTERNBROWSER_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Edit",NULL_STRING,NULL_STRING}
oCCEditButton:OwnerAlignment := OA_PX

oCCDeleteButton := PushButton{SELF,ResourceID{TELEPATTERNBROWSER_DELETEBUTTON,_GetInst()}}
oCCDeleteButton:HyperLabel := HyperLabel{#DeleteButton,"Delete",NULL_STRING,NULL_STRING}
oCCDeleteButton:OwnerAlignment := OA_PX

oDCFound := FixedText{SELF,ResourceID{TELEPATTERNBROWSER_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{TELEPATTERNBROWSER_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

oCCFindButton := PushButton{SELF,ResourceID{TELEPATTERNBROWSER_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Find",NULL_STRING,NULL_STRING}

oDCSearchUni := SingleLineEdit{SELF,ResourceID{TELEPATTERNBROWSER_SEARCHUNI,_GetInst()}}
oDCSearchUni:HyperLabel := HyperLabel{#SearchUni,NULL_STRING,NULL_STRING,NULL_STRING}
oDCSearchUni:FocusSelect := FSEL_TRIM
oDCSearchUni:TooltipText := "Enter one or more (part of) key values "
oDCSearchUni:UseHLforToolTip := True

oDCFixedText4 := FixedText{SELF,ResourceID{TELEPATTERNBROWSER_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Search like google:",NULL_STRING,NULL_STRING}

SELF:Caption := "Telebanking patterns"
SELF:HyperLabel := HyperLabel{#TelePatternBrowser,"Telebanking patterns",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True
SELF:Menu := WOMenu{}

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFTelePatternBrowser_DETAIL := TelePatternBrowser_DETAIL{SELF,TELEPATTERNBROWSER_TELEPATTERNBROWSER_DETAIL}
oSFTelePatternBrowser_DETAIL:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method PostInit(oWindow,iCtlID,oServer,uExtra) class TelePatternBrowser
	//Put your PostInit additions here 
	self:SetTexts()
  	self:oDCFound:TextValue :=Str(self:oTelPat:Reccount,-1)
	return nil

method PreInit(oWindow,iCtlID,oServer,uExtra) class TelePatternBrowser
	//Put your PreInit additions here 
	self:cFields:="t.*,a.accnumber,a.description as accountname"
	self:cFrom:="telebankpatterns t left join account a on (a.accid=t.accid)"
	self:cWhereBase:=""
	self:cWhereSpec:=""
	self:cOrder:="accnumber"

	self:oTelPat:=SQLSelect{"select "+self:cFields+" from "+self:cFrom+" where "+iif(Empty(self:cWhereSpec),"1",self:cWhereSpec)+" order by "+self:cOrder,oConn}
	
	return NIL

ACCESS SearchUni() CLASS TelePatternBrowser
RETURN SELF:FieldGet(#SearchUni)

ASSIGN SearchUni(uValue) CLASS TelePatternBrowser
SELF:FieldPut(#SearchUni, uValue)
RETURN uValue

STATIC DEFINE TELEPATTERNBROWSER_DELETEBUTTON := 102 
CLASS TelePatternBrowser_DETAIL INHERIT DataWindowMine 

	PROTECT oDBACCNUMBER as DataColumn
	PROTECT oDBACCOUNTNAME as DataColumn
	PROTECT oDBCONTRA_BANKACCNT as DataColumn
	PROTECT oDBCONTRA_NAME as DataColumn
	PROTECT oDBDESCRIPTION as DataColumn
	PROTECT oDBKIND as DataColumn
	PROTECT oDBADDSUB as DataColumn
	PROTECT oDBRECDATE as DataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)  
  protect oOwner as TelePatternBrowser
RESOURCE TelePatternBrowser_DETAIL DIALOGEX  20, 18, 469, 209
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TelePatternBrowser_DETAIL 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TelePatternBrowser_DETAIL",_GetInst()},iCtlID)

SELF:Caption := "DataWindow Caption"
SELF:HyperLabel := HyperLabel{#TelePatternBrowser_DETAIL,"DataWindow Caption",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:OwnerAlignment := OA_PWIDTH_PHEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBACCNUMBER := DataColumn{Account_AccNumber{}}
oDBACCNUMBER:Width := 8
oDBACCNUMBER:HyperLabel := HyperLabel{#Accnumber,"Account","Number of  Account","Rek_REK"} 
oDBACCNUMBER:Caption := "Account"
self:Browser:AddColumn(oDBACCNUMBER)

oDBACCOUNTNAME := DataColumn{16}
oDBACCOUNTNAME:Width := 16
oDBACCOUNTNAME:HyperLabel := HyperLabel{#accountname,"Account name",NULL_STRING,NULL_STRING} 
oDBACCOUNTNAME:Caption := "Account name"
self:Browser:AddColumn(oDBACCOUNTNAME)

oDBCONTRA_BANKACCNT := DataColumn{BANK{}}
oDBCONTRA_BANKACCNT:Width := 10
oDBCONTRA_BANKACCNT:HyperLabel := HyperLabel{#contra_bankaccnt,"Bank/Giro","Number of bankaccount","BANK"} 
oDBCONTRA_BANKACCNT:Caption := "Bank/Giro"
self:Browser:AddColumn(oDBCONTRA_BANKACCNT)

oDBCONTRA_NAME := DataColumn{TeleBankPatterns_contra_name{}}
oDBCONTRA_NAME:Width := 25
oDBCONTRA_NAME:HyperLabel := HyperLabel{#contra_name,"Name Bank Account",NULL_STRING,"TeleBankPatterns_contra_name"} 
oDBCONTRA_NAME:Caption := "Name Bank Account"
self:Browser:AddColumn(oDBCONTRA_NAME)

oDBDESCRIPTION := DataColumn{TeleBankPatterns_description{}}
oDBDESCRIPTION:Width := 29
oDBDESCRIPTION:HyperLabel := HyperLabel{#description,"Description",NULL_STRING,"TeleBankPatterns_description"} 
oDBDESCRIPTION:Caption := "Description"
self:Browser:AddColumn(oDBDESCRIPTION)

oDBKIND := DataColumn{TeleBankPatterns_KIND{}}
oDBKIND:Width := 7
oDBKIND:HyperLabel := HyperLabel{#KIND,"Type",NULL_STRING,NULL_STRING} 
oDBKIND:Caption := "Type"
self:Browser:AddColumn(oDBKIND)

oDBADDSUB := DataColumn{TeleBankPatterns_AddSub{}}
oDBADDSUB:Width := 9
oDBADDSUB:HyperLabel := HyperLabel{#AddSub,"Deb/credit",NULL_STRING,"TeleBankPatterns_AddSub"} 
oDBADDSUB:Caption := "Deb/credit"
self:Browser:AddColumn(oDBADDSUB)

oDBRECDATE := DataColumn{11}
oDBRECDATE:Width := 11
oDBRECDATE:HyperLabel := HyperLabel{#RecDate,"Date Change",NULL_STRING,NULL_STRING} 
oDBRECDATE:Caption := "Date Change"
self:Browser:AddColumn(oDBRECDATE)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TelePatternBrowser_DETAIL
	//Put your PostInit additions here
	self:SetTexts()
	self:Browser:SetStandardStyle(gbsReadOnly) 
	self:GoTop()
	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS TelePatternBrowser_DETAIL
	//Put your PreInit additions here 
	self:oOwner:=oWindow
	oWindow:use(oWindow:oTelPat)
	RETURN NIL

STATIC DEFINE TELEPATTERNBROWSER_DETAIL_ACCNUMBER := 105 
STATIC DEFINE TELEPATTERNBROWSER_DETAIL_ACCOUNTNAME := 106 
STATIC DEFINE TELEPATTERNBROWSER_DETAIL_ADDSUB := 103 
STATIC DEFINE TELEPATTERNBROWSER_DETAIL_CONTRA_BANKACCNT := 101 
STATIC DEFINE TELEPATTERNBROWSER_DETAIL_CONTRA_NAME := 102 
STATIC DEFINE TELEPATTERNBROWSER_DETAIL_DESCRIPTION := 104 
STATIC DEFINE TELEPATTERNBROWSER_DETAIL_KIND := 100 
STATIC DEFINE TELEPATTERNBROWSER_DETAIL_MUTSOORT := 100 
STATIC DEFINE TELEPATTERNBROWSER_DETAIL_RECDATE := 107 
STATIC DEFINE TELEPATTERNBROWSER_DETAIL_TEGENGIRO := 101 
STATIC DEFINE TELEPATTERNBROWSER_EDITBUTTON := 101 
STATIC DEFINE TELEPATTERNBROWSER_FINDBUTTON := 105 
STATIC DEFINE TELEPATTERNBROWSER_FIXEDTEXT4 := 107 
STATIC DEFINE TELEPATTERNBROWSER_FOUND := 103 
STATIC DEFINE TELEPATTERNBROWSER_FOUNDTEXT := 104 
STATIC DEFINE TELEPATTERNBROWSER_SEARCHUNI := 106 
STATIC DEFINE TELEPATTERNBROWSER_TELEPATTERNBROWSER_DETAIL := 100 
