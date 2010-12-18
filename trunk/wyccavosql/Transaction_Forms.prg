CLASS BedragStr INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS BedragStr

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

    symHlName   := #BedragStr

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


    SUPER:Init( HyperLabel{symHlName, "", "Amount", "" },  "C", 13, 0 )


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
CLASS General_Journal INHERIT DataWindowExtra 

	PROTECT oDBMBST as DataColumn
	PROTECT oDBMPERSON as DataColumn
	PROTECT oDBMTRANSAKTNR as DataColumn
	PROTECT oDCmBST AS SINGLELINEEDIT
	PROTECT oDCmDat AS DATESTANDARD
	PROTECT oDCmPostStatus AS COMBOBOX
	PROTECT oDCmPerson AS SINGLELINEEDIT
	PROTECT oCCSaveButton AS PUSHBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCPostButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCDebitCreditText AS FIXEDTEXT
	PROTECT oCCTeleBankButton AS PUSHBUTTON
	PROTECT oDCSC_CLN AS FIXEDTEXT
	PROTECT oCCPersonButton AS PUSHBUTTON
	PROTECT oDCmTRANSAKTNR AS SINGLELINEEDIT
	PROTECT oDCSC_Total AS FIXEDTEXT
	PROTECT oDCSC_BST AS FIXEDTEXT
	PROTECT oDCSC_TRANSAKTNR2 AS FIXEDTEXT
	PROTECT oDCSC_DAT AS FIXEDTEXT
	PROTECT oDCSC_TRANSAKTNR1 AS FIXEDTEXT
	PROTECT oDCGiroText AS FIXEDTEXT
	PROTECT oDCUserdIdTxt AS FIXEDTEXT
	PROTECT oDCRecoderdByText AS FIXEDTEXT
	PROTECT oCCImportButton AS PUSHBUTTON
	PROTECT oDCBankText AS FIXEDTEXT
	PROTECT oDCBankBalance AS SINGLELINEEDIT
	PROTECT oDCGroupBoxFind AS GROUPBOX
	PROTECT oDCFindText AS SINGLELINEEDIT
	PROTECT oCCFindNext AS PUSHBUTTON
	PROTECT oCCFindPrevious AS PUSHBUTTON
	PROTECT oCCFindClose AS PUSHBUTTON
	PROTECT oSFGeneralJournal1 AS GeneralJournal1

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	instance mBST 
	instance mPerson 
	instance mTRANSAKTNR 
	instance BankBalance 
  	PROTECT oTmt as TeleMut
  	PROTECT fTotal as FLOAT
  	PROTECT mCLNGiver as STRING
  	Protect cGiverName, cOrigName as STRING
  	PROTECT lInqUpd as LOGIC
  	EXPORT lTeleBank as LOGIC
  	EXPORT lMemberGiver as LOGIC
  	PROTECT OrigBst, OrigPerson as STRING, OrigDat as date
  	PROTECT oInqBrowse as OBJECT && Calling Browser (inquiry/update)
	PROTECT oFocusControl as Control
	PROTECT oOwner as TransInquiry
	EXPORT cAccFilter:="" as STRING
	PROTECT lSave as LOGIC
	PROTECT oImpB as ImportBatch
	PROTECT CurBankAcc as STRING  // id of currently shown bank account 
	Export CurDate as date 
	export lStop as logic
	export oHlpMut as TempTrans
	protect mPayahead as string  // account used for direct debit 
	
	declare method FindNext, FindPrevious
// EXPORT pFilter as _CODEBLOCK
	protect oCurr as Currency 
	export nLstSeqNr as int
//   	export ticks1,ticks2 as DWORD 
  	
  	declare method Totalise,ValidateTempTrans,FillTeleBanking, FillRecord, ShowBankBalance, ValStore, ;
  	UpdateLine,FillBatch,RegAccount,FindNext,FindPrevious,ChgDueAmnts,UpdateTrans
RESOURCE General_Journal DIALOGEX  62, 55, 466, 315
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Bst:", GENERAL_JOURNAL_MBST, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 52, 1, 41, 13
	CONTROL	"vrijdag 24 september 2010", GENERAL_JOURNAL_MDAT, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 140, 1, 132, 13
	CONTROL	"", GENERAL_JOURNAL_MPOSTSTATUS, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_VSCROLL, 276, 1, 72, 50
	CONTROL	"", GENERAL_JOURNAL_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 312, 18, 132, 12, WS_EX_CLIENTEDGE
	CONTROL	"OK&&Remember", GENERAL_JOURNAL_SAVEBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 400, 284, 53, 12
	CONTROL	"OK", GENERAL_JOURNAL_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 400, 297, 52, 13
	CONTROL	"Post Batch", GENERAL_JOURNAL_POSTBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 396, 297, 56, 11
	CONTROL	"Cancel", GENERAL_JOURNAL_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 340, 299, 53, 12
	CONTROL	"", GENERAL_JOURNAL_GENERALJOURNAL1, "static", WS_TABSTOP|WS_CHILD|WS_BORDER, 4, 55, 456, 221
	CONTROL	"", GENERAL_JOURNAL_DEBITCREDITTEXT, "Static", WS_CHILD|WS_BORDER, 48, 296, 82, 12, WS_EX_CLIENTEDGE
	CONTROL	"Telebanking...", GENERAL_JOURNAL_TELEBANKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 340, 283, 54, 12
	CONTROL	"Person:", GENERAL_JOURNAL_SC_CLN, "Static", WS_CHILD, 284, 18, 27, 12
	CONTROL	"v", GENERAL_JOURNAL_PERSONBUTTON, "Button", WS_CHILD, 444, 18, 13, 12
	CONTROL	"Transaktnr:", GENERAL_JOURNAL_MTRANSAKTNR, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_BORDER, 416, 1, 40, 12
	CONTROL	"Total:", GENERAL_JOURNAL_SC_TOTAL, "Static", WS_CHILD, 4, 296, 22, 12
	CONTROL	"Document id:", GENERAL_JOURNAL_SC_BST, "Static", WS_CHILD, 8, 1, 43, 13
	CONTROL	"transaction:", GENERAL_JOURNAL_SC_TRANSAKTNR2, "Static", WS_CHILD, 374, 0, 38, 12
	CONTROL	"Record date:", GENERAL_JOURNAL_SC_DAT, "Static", WS_CHILD, 100, 1, 44, 13
	CONTROL	"Prior", GENERAL_JOURNAL_SC_TRANSAKTNR1, "Static", WS_CHILD, 356, 0, 14, 14
	CONTROL	"", GENERAL_JOURNAL_GIROTEXT, "Static", WS_CHILD, 4, 33, 454, 18
	CONTROL	"", GENERAL_JOURNAL_USERDIDTXT, "Static", WS_CHILD, 48, 280, 70, 12
	CONTROL	"Recorded by:", GENERAL_JOURNAL_RECODERDBYTEXT, "Static", WS_CHILD, 4, 280, 43, 12
	CONTROL	"Import Batch...", GENERAL_JOURNAL_IMPORTBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 284, 283, 54, 12
	CONTROL	"Bank Account xxxxxxxxxxxxx balance:", GENERAL_JOURNAL_BANKTEXT, "Static", SS_RIGHT|WS_CHILD|NOT WS_VISIBLE, 6, 19, 178, 12
	CONTROL	"", GENERAL_JOURNAL_BANKBALANCE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 188, 18, 64, 12, WS_EX_CLIENTEDGE
	CONTROL	"Find", GENERAL_JOURNAL_GROUPBOXFIND, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|NOT WS_VISIBLE, 208, 30, 252, 25
	CONTROL	"", GENERAL_JOURNAL_FINDTEXT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 220, 40, 133, 12, WS_EX_CLIENTEDGE
	CONTROL	"Find", GENERAL_JOURNAL_FINDNEXT, "Button", BS_DEFPUSHBUTTON|WS_CHILD|NOT WS_VISIBLE, 353, 40, 39, 12
	CONTROL	"Previous", GENERAL_JOURNAL_FINDPREVIOUS, "Button", WS_CHILD|NOT WS_VISIBLE, 393, 40, 39, 12
	CONTROL	"x", GENERAL_JOURNAL_FINDCLOSE, "Button", WS_CHILD|NOT WS_VISIBLE, 440, 40, 13, 12
END

method AddCur(0 class General_Journal
self:oSFGeneralJournal1:AddCurr()
return
ACCESS BankBalance() CLASS General_Journal
RETURN SELF:FieldGet(#BankBalance)

ASSIGN BankBalance(uValue) CLASS General_Journal
SELF:FieldPut(#BankBalance, uValue)
RETURN uValue

METHOD CancelButton( ) CLASS General_Journal
LOCAL oBox as WarningBox
IF !self:lStop.and.!self:lTeleBank.and.AScanExact(self:Server:Amirror,{|x| !x[3]==0.or.!x[2]==0})>0 ;  // there are amounts filled?
	.and. self:oCCOKButton:IsVisible()
// 	IF !(lInqUpd.and.self:fTotal == 0) .and.!self:lTeleBank.and.AScanExact(self:server:Amirror,{|x| !(x[3]==0 .or.!x[2]==0)})>0   // iets toegewezen?
		oBox := WarningBox{self, "Cancel of Transactions", "Do you really want to discard changes?"}
		oBox:Type := BUTTONYESNO
		IF (oBox:Show() = BOXREPLYYES)
			self:lStop:=true
		ENDIF
	ELSE
		self:lStop:=true
	ENDIF
	IF self:lStop
//	IF !lInqUpd .and.(self:server:RECCOUNT > 1 .or. !self:fTotal == 0)
		IF self:lTeleBank
			// reset lock in teletrans:
			self:oTmt:SkipMut()
			self:lSave:=FALSE
			self:oCCSaveButton:Hide() 
			self:ReSet()
			self:cGiverName:=""
			self:mCLNGiver:=""
			IF self:oTmt:NextTeleNonGift()
				self:FillTeleBanking()
				IF self:oTmt:m56_autmut
					self:OkButton()
				ENDIF
			ELSE
				self:EndGiro()
			ENDIF
		ELSEIF self:lImport
			DO WHILE self:lImport
				self:oImpB:skipbatch()
				self:mCLNGiver := ""
				self:cGiverName := ""
				self:mPerson := ""
				self:mBst:= " "
				IF self:oImpB:GetNextBatch()
					IF !self:oImpB:lOK .or.!self:ValStore()
						RETURN NIL
					ENDIF
					self:oImpB:CloseBatch()
				ELSE
					SELF:oDCmBST:Enable()
					SELF:oDCmDat:Enable()
					self:lImport:=FALSE
					self:oImpB:Close()
					SELF:ReSet()
					SELF:append()
					EXIT
				ENDIF
    		ENDDO
		ELSE
			self:EndWindow()
		ENDIF
	endif
RETURN NIL	
METHOD Close(oEvent) CLASS General_Journal
	LOCAL oServer AS FileSpec

IF !SELF:Server==NULL_OBJECT
	oServer:=Filespec{SELF:Server:FileSpec:FullPath}
	IF SELF:Server:Used
		SELF:Server:Close()
	ENDIF
	//FErase(cServer)
	if !oServer:DELETE()
		FErase(oServer:FullPath)
	ENDIF
	oServer:Extension:="fpt"
	IF oServer:Find()
		if !oServer:DELETE() 
			FErase(oServer:FullPath)
		endif
	ENDIF
ENDIF
IF self:lImport .and.!self:oImpb==null_object
	self:lImport:=FALSE
	self:oImpb:Close()
ENDIF

IF !self:lTeleBank .and.!self:oTmt==null_object
	self:oTmt:Close()
	self;oTmt:=null_object
ENDIF
SELF:oSFGeneralJournal1:Close()
SELF:oSFGeneralJournal1:Destroy()
SELF:Destroy()
	// force garbage collection
	*CollectForced()

	RETURN SUPER:Close(oEvent)
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS General_Journal
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus.and.!IsNil(oControl:Value)
		IF oControl:Name == "MPERSON".and.!AllTrim(oControl:Value)==AllTrim(cGiverName)
			IF Empty(oControl:Value) && leeg gemaakt?
				self:lStop:=false
				self:mCLNGiver :=  ""
				SELF:cGiverName := ""
				SELF:oDCmPerson:TEXTValue := ""
			ELSE
				self:cOrigName:=self:cGiverName
           	cGiverName:=AllTrim(oControl:VALUE)
				if !cGiverName==cOrigName
					self:PersonButton(true,false) 
				else
					self:PersonButton(true)
				endif				 
			ENDIF
		elseif oControl:Name == "MDAT" .or. oControl:Name == "MBST"
			self:lStop:=false
		ENDIF
	ENDIF
	RETURN TRUE
Method EndGiro() Class General_Journal
	self:oDCmBST:Enable()
	self:oDCmDat:Enable()
	lTeleBank:=FALSE
	self:oTmt:Close()
	oDCGiroText:TextValue:= ""
	self:mDat:=Today()
	self:mBst:=" "
	self:oDCmPerson:TextValue :=" "
	self:mCLNGiver :=  " "
	self:cGiverName := " "
	self:oSFGeneralJournal1:Browser:Refresh()
return
METHOD FindNext( ) as void pascal CLASS General_Journal
local oHm:=self:Server as TempTrans
local nPtr as int
local oMyGJ:=self as General_Journal 

if Empty(self:oDCFindText:TextValue) 
	return 
endif

if self:nFindRec=0
	self:aKeyW:=GetTokens(AllTrim(self:oDCFindText:TextValue))
endif
nPtr:=self:nFindRec+1
&& mirror-array of TempTrans with values {accID,deb,cre,gc,category,recno,Trans:RecNbr,accnumber,Rekoms,balitemid,curr,multicur,debforgn,creforgn,PPDEST, description}
nPtr:=AScan(oHm:aMirror,{|x|oMyGJ:CompareKeyWords({Str(x[2],-1),Str(x[3],-1),Str(x[13],-1),Str(x[14],-1),x[8],x[9],x[16]})},nPtr )
if nPtr>0 
	self:nFindRec:=nPtr
	self:GoTo(nPtr)
	if self:oCCFindNext:Caption="Next"
		self:oCCFindPrevious:Show()
	else 
		self:oCCFindNext:Caption:="Next"
	endif
else
	self:STATUSMESSAGE("No more found",MESSAGEPERMANENT)
endif


RETURN 
METHOD FindPrevious( ) as void pascal CLASS General_Journal 
local oHm:=self:Server as TempTrans
local nPtr, nCnt as int
local oMyGJ:=self as General_Journal
nPtr:=self:nFindRec-1
nCnt:=-nPtr
if nPtr=0 
	return 
endif
&& mirror-array of TempTrans with values {accID,deb,cre,gc,category,recno,Trans:RecNbr,accnumber,Rekoms,balitemid,curr,multicur,debforgn,creforgn,PPDEST, description}
nPtr:=AScan(oHm:aMirror,{|x|oMyGJ:CompareKeyWords({Str(x[2],-1),Str(x[3],-1),Str(x[13],-1),Str(x[14],-1),x[8],x[9],x[16]})},nPtr, nCnt )
if nPtr>0 
	self:nFindRec:=nPtr
	self:GoTo(nPtr) 
else
	self:STATUSMESSAGE("No more found",MESSAGEPERMANENT)
endif
if nPtr<=1
	self:oCCFindPrevious:hide()
endif

RETURN 

ACCESS FindText() CLASS General_Journal
RETURN SELF:FieldGet(#FindText)

ASSIGN FindText(uValue) CLASS General_Journal
SELF:FieldPut(#FindText, uValue)
RETURN uValue

Method GirotelContinue() class General_Journal
	// Continue with automatic processing of telebanking records after error:
	DO WHILE oTmt:m56_mode_aut.and.lTeleBank
		IF oTmt:m56_autmut   //nog steeds herkend?
			self:OKButton()
			if !oTmt:m56_autmut // apparently error
				return nil
			endif
		ELSE                  // anders overslaan
			IF oTmt:NextTeleNonGift()
				self:FillTeleBanking()
			ELSE
				self:oDCmBST:Enable()
				self:oDCmDat:Enable()
				lTeleBank:=FALSE
				oDCGiroText:TextValue:= ""
			ENDIF
		ENDIF
	ENDDO
	return nil	
	
METHOD ImportButton( ) CLASS General_Journal
	IF Empty(self:oImpB)
		self:oImpB:=ImportBatch{self,self:Server}
	ENDIF
	self:oImpB:Import()
	IF self:oImpB:GetNextBatch()
		IF self:oImpB:lOK
			SELF:OKButton()
		ENDIF
	ELSE
		SELF:lImport := FALSE
		self:oImpB:Close()
		self:oImpB:=null_object
		(WarningBox{SELF,"Journaling Records","No Import batches found"}):Show()
	ENDIF
RETURN NIL
	
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS General_Journal 
LOCAL DIM aBrushes[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"General_Journal",_GetInst()},iCtlID)

aBrushes[1] := Brush{Color{COLORWHITE}}

oDCmBST := SingleLineEdit{SELF,ResourceID{GENERAL_JOURNAL_MBST,_GetInst()}}
oDCmBST:FieldSpec := Transaction_BST{}
oDCmBST:HyperLabel := HyperLabel{#mBST,"Bst:",NULL_STRING,"Transaction_BST"}

oDCmDat := DateStandard{SELF,ResourceID{GENERAL_JOURNAL_MDAT,_GetInst()}}
oDCmDat:HyperLabel := HyperLabel{#mDat,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmPostStatus := combobox{SELF,ResourceID{GENERAL_JOURNAL_MPOSTSTATUS,_GetInst()}}
oDCmPostStatus:TooltipText := "Status of posting"
oDCmPostStatus:HyperLabel := HyperLabel{#mPostStatus,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmPerson := SingleLineEdit{SELF,ResourceID{GENERAL_JOURNAL_MPERSON,_GetInst()}}
oDCmPerson:HyperLabel := HyperLabel{#mPerson,NULL_STRING,"Person paying the amount (optionally)",NULL_STRING}
oDCmPerson:Picture := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
oDCmPerson:TooltipText := "Name, Zip or Bank# of Person paying the amount (optionally)"
oDCmPerson:UseHLforToolTip := True

oCCSaveButton := PushButton{SELF,ResourceID{GENERAL_JOURNAL_SAVEBUTTON,_GetInst()}}
oCCSaveButton:HyperLabel := HyperLabel{#SaveButton,"OK"+_chr(38)+_chr(38)+"Remember","Proces transaction and save as pattern for recognition of telebanking transactions",NULL_STRING}
oCCSaveButton:TooltipText := "Proces transaction and save as pattern for recognition of telebanking transactions"
oCCSaveButton:OwnerAlignment := OA_Y

oCCOKButton := PushButton{SELF,ResourceID{GENERAL_JOURNAL_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}
oCCOKButton:OwnerAlignment := OA_Y

oCCPostButton := PushButton{SELF,ResourceID{GENERAL_JOURNAL_POSTBUTTON,_GetInst()}}
oCCPostButton:HyperLabel := HyperLabel{#PostButton,"Post Batch",NULL_STRING,NULL_STRING}
oCCPostButton:OwnerAlignment := OA_Y

oCCCancelButton := PushButton{SELF,ResourceID{GENERAL_JOURNAL_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}
oCCCancelButton:OwnerAlignment := OA_Y

oDCDebitCreditText := FixedText{SELF,ResourceID{GENERAL_JOURNAL_DEBITCREDITTEXT,_GetInst()}}
oDCDebitCreditText:HyperLabel := HyperLabel{#DebitCreditText,NULL_STRING,NULL_STRING,NULL_STRING}
oDCDebitCreditText:TextColor := Color{COLORBLUE}
oDCDebitCreditText:BackGround := aBrushes[1]
oDCDebitCreditText:OwnerAlignment := OA_Y

oCCTeleBankButton := PushButton{SELF,ResourceID{GENERAL_JOURNAL_TELEBANKBUTTON,_GetInst()}}
oCCTeleBankButton:HyperLabel := HyperLabel{#TeleBankButton,"Telebanking...","Processing of telebanking transactions",NULL_STRING}
oCCTeleBankButton:TooltipText := "Proces Telebanking transactions"
oCCTeleBankButton:OwnerAlignment := OA_Y

oDCSC_CLN := FixedText{SELF,ResourceID{GENERAL_JOURNAL_SC_CLN,_GetInst()}}
oDCSC_CLN:HyperLabel := HyperLabel{#SC_CLN,"Person:",NULL_STRING,NULL_STRING}

oCCPersonButton := PushButton{SELF,ResourceID{GENERAL_JOURNAL_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v",NULL_STRING,"Browse in persons"}
oCCPersonButton:TooltipText := "Browse in Persons"
oCCPersonButton:UseHLforToolTip := True

oDCmTRANSAKTNR := SingleLineEdit{SELF,ResourceID{GENERAL_JOURNAL_MTRANSAKTNR,_GetInst()}}
oDCmTRANSAKTNR:FieldSpec := Transaction_TRANSAKTNR{}
oDCmTRANSAKTNR:HyperLabel := HyperLabel{#mTRANSAKTNR,"Transaktnr:",NULL_STRING,"Transaction_TRANSAKTNR"}

oDCSC_Total := FixedText{SELF,ResourceID{GENERAL_JOURNAL_SC_TOTAL,_GetInst()}}
oDCSC_Total:HyperLabel := HyperLabel{#SC_Total,"Total:",NULL_STRING,NULL_STRING}
oDCSC_Total:OwnerAlignment := OA_Y

oDCSC_BST := FixedText{SELF,ResourceID{GENERAL_JOURNAL_SC_BST,_GetInst()}}
oDCSC_BST:HyperLabel := HyperLabel{#SC_BST,"Document id:",NULL_STRING,NULL_STRING}

oDCSC_TRANSAKTNR2 := FixedText{SELF,ResourceID{GENERAL_JOURNAL_SC_TRANSAKTNR2,_GetInst()}}
oDCSC_TRANSAKTNR2:HyperLabel := HyperLabel{#SC_TRANSAKTNR2,"transaction:",NULL_STRING,NULL_STRING}

oDCSC_DAT := FixedText{SELF,ResourceID{GENERAL_JOURNAL_SC_DAT,_GetInst()}}
oDCSC_DAT:HyperLabel := HyperLabel{#SC_DAT,"Record date:",NULL_STRING,NULL_STRING}

oDCSC_TRANSAKTNR1 := FixedText{SELF,ResourceID{GENERAL_JOURNAL_SC_TRANSAKTNR1,_GetInst()}}
oDCSC_TRANSAKTNR1:HyperLabel := HyperLabel{#SC_TRANSAKTNR1,"Prior",NULL_STRING,NULL_STRING}

oDCGiroText := FixedText{SELF,ResourceID{GENERAL_JOURNAL_GIROTEXT,_GetInst()}}
oDCGiroText:HyperLabel := HyperLabel{#GiroText,NULL_STRING,NULL_STRING,NULL_STRING}

oDCUserdIdTxt := FixedText{SELF,ResourceID{GENERAL_JOURNAL_USERDIDTXT,_GetInst()}}
oDCUserdIdTxt:HyperLabel := HyperLabel{#UserdIdTxt,NULL_STRING,NULL_STRING,NULL_STRING}
oDCUserdIdTxt:OwnerAlignment := OA_Y

oDCRecoderdByText := FixedText{SELF,ResourceID{GENERAL_JOURNAL_RECODERDBYTEXT,_GetInst()}}
oDCRecoderdByText:HyperLabel := HyperLabel{#RecoderdByText,"Recorded by:",NULL_STRING,NULL_STRING}
oDCRecoderdByText:OwnerAlignment := OA_Y

oCCImportButton := PushButton{SELF,ResourceID{GENERAL_JOURNAL_IMPORTBUTTON,_GetInst()}}
oCCImportButton:HyperLabel := HyperLabel{#ImportButton,"Import Batch...","Processing of batch transactions",NULL_STRING}
oCCImportButton:TooltipText := "Processing of batch transactions"
oCCImportButton:OwnerAlignment := OA_Y

oDCBankText := FixedText{SELF,ResourceID{GENERAL_JOURNAL_BANKTEXT,_GetInst()}}
oDCBankText:HyperLabel := HyperLabel{#BankText,"Bank Account xxxxxxxxxxxxx balance:",NULL_STRING,NULL_STRING}

oDCBankBalance := SingleLineEdit{SELF,ResourceID{GENERAL_JOURNAL_BANKBALANCE,_GetInst()}}
oDCBankBalance:HyperLabel := HyperLabel{#BankBalance,NULL_STRING,NULL_STRING,NULL_STRING}

oDCGroupBoxFind := GroupBox{SELF,ResourceID{GENERAL_JOURNAL_GROUPBOXFIND,_GetInst()}}
oDCGroupBoxFind:HyperLabel := HyperLabel{#GroupBoxFind,"Find",NULL_STRING,NULL_STRING}

oDCFindText := SingleLineEdit{SELF,ResourceID{GENERAL_JOURNAL_FINDTEXT,_GetInst()}}
oDCFindText:HyperLabel := HyperLabel{#FindText,NULL_STRING,NULL_STRING,NULL_STRING}

oCCFindNext := PushButton{SELF,ResourceID{GENERAL_JOURNAL_FINDNEXT,_GetInst()}}
oCCFindNext:HyperLabel := HyperLabel{#FindNext,"Find",NULL_STRING,"Find next record"}
oCCFindNext:TooltipText := "Find next record"
oCCFindNext:UseHLforToolTip := True

oCCFindPrevious := PushButton{SELF,ResourceID{GENERAL_JOURNAL_FINDPREVIOUS,_GetInst()}}
oCCFindPrevious:HyperLabel := HyperLabel{#FindPrevious,"Previous",NULL_STRING,"Find previous record"}
oCCFindPrevious:TooltipText := "Find previous record"
oCCFindPrevious:UseHLforToolTip := True

oCCFindClose := PushButton{SELF,ResourceID{GENERAL_JOURNAL_FINDCLOSE,_GetInst()}}
oCCFindClose:HyperLabel := HyperLabel{#FindClose,"x",NULL_STRING,"Close find bar"}
oCCFindClose:TooltipText := "Close find bar"
oCCFindClose:UseHLforToolTip := True

SELF:Caption := "Journal General"
SELF:HyperLabel := HyperLabel{#General_Journal,"Journal General",NULL_STRING,NULL_STRING}
SELF:Menu := WOBrowserMENUFIND{}
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
self:Browser := DataBrowser{self}

oDBMBST := DataColumn{Transaction_BST{}}
oDBMBST:Width := 6
oDBMBST:HyperLabel := oDCMBST:HyperLabel 
oDBMBST:Caption := "Bst:"
self:Browser:AddColumn(oDBMBST)

oDBMPERSON := DataColumn{9}
oDBMPERSON:Width := 9
oDBMPERSON:HyperLabel := oDCMPERSON:HyperLabel 
oDBMPERSON:Caption := ""
self:Browser:AddColumn(oDBMPERSON)

oDBMTRANSAKTNR := DataColumn{Transaction_TRANSAKTNR{}}
oDBMTRANSAKTNR:Width := 13
oDBMTRANSAKTNR:HyperLabel := oDCMTRANSAKTNR:HyperLabel 
oDBMTRANSAKTNR:Caption := "Transaktnr:"
self:Browser:AddColumn(oDBMTRANSAKTNR)


SELF:ViewAs(#FormView)

oSFGeneralJournal1 := GeneralJournal1{SELF,GENERAL_JOURNAL_GENERALJOURNAL1}
oSFGeneralJournal1:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mBST() CLASS General_Journal
RETURN SELF:FieldGet(#mBST)

ASSIGN mBST(uValue) CLASS General_Journal
SELF:FieldPut(#mBST, uValue)
RETURN uValue

ACCESS mDAT() CLASS General_Journal
RETURN SELF:oDCmDat:SelectedDate
ASSIGN mDAT(uValue) CLASS General_Journal
RETURN SELF:oDCmDat:SelectedDate:=uValue
ACCESS mPerson() CLASS General_Journal
RETURN SELF:FieldGet(#mPerson)

ASSIGN mPerson(uValue) CLASS General_Journal
SELF:FieldPut(#mPerson, uValue)
RETURN uValue

ACCESS mPostStatus() CLASS General_Journal
RETURN SELF:FieldGet(#mPostStatus)

ASSIGN mPostStatus(uValue) CLASS General_Journal
SELF:FieldPut(#mPostStatus, uValue)
RETURN uValue

ACCESS mTRANSAKTNR() CLASS General_Journal
RETURN SELF:FieldGet(#mTRANSAKTNR)

ASSIGN mTRANSAKTNR(uValue) CLASS General_Journal
SELF:FieldPut(#mTRANSAKTNR, uValue)
RETURN uValue

METHOD OKButton(lMySave ) CLASS General_Journal
	LOCAL oHm as TempTrans
	LOCAL CurValue as ARRAY   // 1: nw value, 2: old value, 3: name of columnfield
	LOCAL ThisRec as int
	LOCAL CurBankSave:=self:CurBankAcc as STRING
	local lSave as logic 
local oAcc as SQLSelect
local cWhere:="a.balitemid=b.balitemid"
local cFrom:="balanceitem as b,account as a left join member m on (m.accid=a.accid)" 
local cFields:="a.*,b.category as type,m.co,m.persid as persid,"+SQLAccType()+" as accounttype"
	Default(@lMySave,false)
	lSave:=lMySave

	oHm := self:Server
	IF self:ValStore(lSave)
		self:CurBankAcc:="" 
		DO WHILE lTeleBank
// 			self:oTmt:CloseMut(self:Server)
			IF self:oTmt:NextTeleNonGift()
				self:FillTeleBanking()
				IF self:oTmt:m56_autmut
					IF !self:ValStore()
						RETURN nil
					ENDIF
				ELSE	
					exit
				ENDIF
			ELSE
				self:EndGiro()
			ENDIF
		ENDDO 

		DO WHILE lImport
// 			oImpB:CloseBatch()
			mCLNGiver := ""
			cGiverName := ""
			mPerson := ""
			mBst:= " "
			IF oImpB:GetNextBatch()
				IF !oImpB:lOK .or.!self:ValStore()
					RETURN nil
				ENDIF
			ELSE
				self:oDCmBST:Enable()
				self:oDCmDat:Enable()
				lImport:=FALSE
				oImpB:Close()
				oDCGiroText:TextValue:= ""
				self:ReSet()
				self:append()
				exit
			ENDIF
		ENDDO
		IF !lTeleBank.and.!lInqUpd .and.! lImport
			IF oHm:Lastrec > 0
				self:ReSet()
			ENDIF
			oHm:=self:Server
			self:append()
			mCLNGiver := ""
			cGiverName := ""
			mPerson := ""
			mBst:= " " 
			self:AddCur()
			IF !Empty(CurBankSave)
				// show first line with current bank account:
				cWhere+=" and a.accid = '"+CurBankSave+"'" 
				oAcc:=SQLSelect{"Select "+cFields+" from "+cFrom+" where "+cWhere,oConn}
				if oAcc:RecCount>0 
					self:RegAccount(oAcc) 
				ENDIF
			ENDIF
		ENDIF
	ELSEIF lTeleBank
		self:oTmt:m56_recognised:=FALSE
		self:oTmt:m56_autmut:=FALSE	
	ENDIF
	RETURN
METHOD PersonButton(lUnique,WithCln ) CLASS General_Journal
	LOCAL cValue := AllTrim(oDCmPerson:TEXTValue ) as STRING 
	local oPers as PersonContainer
	Default(@lUnique,FALSE) 
	Default(@WithCln,true) 
	oPers:=PersonContainer{}
	if !Empty(self:mCLNGiver).and.WithCln .and. !Val(self:mCLNGiver)=0
		oPers:persid:=self:mCLNGiver
	else
		oPers:persid:=""
	endif
	if self:lImport
		PersonSelect(self,cValue,lUnique,,"Giver/Payer",oPers)
	else
		PersonSelect(self,cValue,lUnique,,"Giver/Payer",oPers)
	endif
	RETURN NIL
METHOD PostButton( ) CLASS General_Journal
// mark transactions as Posted: 
Local oTrans as Transaction
oTrans:=Transaction{}
IF !oTrans:used
	RETURN 
ENDIF
oTrans:SetOrder( "TRANSNR" )

oTrans:Seek( mTRANSAKTNR)
DO WHILE oTrans:TransId == mTRANSAKTNR.and..not.oTrans:EOF
	oTrans:RecLock(oTrans:RECNO)
   oTrans:POSTSTATUS:=2
	oTrans:USERID:=LOGON_EMP_ID
   oTrans:Skip()
enddo
oTrans:Unlock()
oTrans:Commit() 
oTrans:Close()
self:oInqBrowse:REFresh()
self:EndWindow()

RETURN NIL
METHOD PostInit() CLASS General_Journal
	//Put your PostInit additions here
	LOCAL oBank as SQLSelect
	LOCAL aTeleAcc:={} AS ARRAY
	local oSel as SQLSelect
	self:SetTexts()

	IF !SELF:Server:lExisting
		SELF:Server:Zap()
		SELF:append()
	ENDIF
	self:lStop:=true
	IF !TeleBanking
		oCCTeleBankButton:Hide()
	ENDIF		
	oBank := SQLSelect{"select accid from BankAccount where telebankng>0",oConn} 
	if oBank:RecCount>0
		do WHILE !oBank:EOF
			self:cAccFilter+=iif(Empty(self:cAccFilter),"",' and ')+'accid<>"'+Str(oBank:AccID,-1)+'"' 
			AAdd(aTeleAcc,Str(oBank:AccID,-1))
			oBank:Skip()
		ENDDO 
	endif
	self:Server:aTeleAcc:=aTeleAcc 
	CurDate:=self:oDCmDat:SelectedDate 
	IF USERTYPE=="D"
		self:oCCTeleBankButton:Hide()
	endif

	IF ADMIN=="HO" .or.self:Server:lExisting .or.USERTYPE=="D"
		oCCImportButton:Hide()
	ELSE
		self:oImpB:=ImportBatch{self,self:Server,DBSHARED,DBREADONLY}
		IF oImpB:EoF
			if oImpB:GetImportFiles() 
				oCCImportButton:Show()
			endif
		else
			oCCImportButton:Show()
		ENDIF
		oImpB:Close()
		oImpB:=NULL_OBJECT
	ENDIF
	self:Server:lExisting:=FALSE 
	self:mPostStatus:=0
	if Posting
		self:oDCmPostStatus:FillUsing({{"Not Posted",0},{"Ready to Post",1}}) 
		self:mPostStatus:=0
		self:oDCmPostStatus:Show()
	endif
	IF AScan(aMenu,{|x| x[4]=="TransactionEdit"})=0
		self:oCCOKButton:Hide()
		self:oCCSaveButton:Hide() 
		self:oCCTeleBankButton:Hide()
		self:oCCImportButton:Hide()
	ENDIF 
	if ADMIN="WA"
		self:oDCmPerson:Hide()
		self:oDCSC_CLN:Hide()
	endif
	oSel:=SQLSelect{"select PAYAHEAD from BankAccount where banknumber='"+BANKNBRDEB+"'",oConn}
	if oSel:RecCount<1
		if oSel:RecCount>0
			mPayahead:=Str(oSel:PAYAHEAD,-1) 
		endif
	endif 


	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS General_Journal
	//Put your PreInit additions here
IF (oServer = nil)
	GetHelpDir()
	self:oHlpMut:=TempTrans{HelpDir+"\HU"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
	self:oHlpMut:lExisting:=false 
ELSE
	self:oHlpMut:=oServer
	self:oHlpMut:lExisting:=true
ENDIF


	RETURN NIL
method QueryClose(oEvent) class General_Journal
	local lAllowClose as logic
IF !self:lStop.and.!lTeleBank.and.AScanExact(self:Server:Amirror,{|x| !x[3]==0 .or.!x[2]==0})>0  ; // amounts filled?
	.and. self:oCCOKButton:IsVisible()
	if (TextBox{self, "Cancel of Transactions", "Do you really want to discard changes?",BUTTONYESNO}):Show()==BOXREPLYNO	
		return false
	endif
endif 
return true
// 	lAllowClose := super:QueryClose(oEvent)
	//Put your changes here
// 	return lAllowClose
METHOD SaveButton( ) CLASS General_Journal
	SELF:OKButton(TRUE)
	RETURN
METHOD TeleBankButton( ) CLASS General_Journal
	IF !oTmt==null_object
		oTmt:Close()
	endif
	oTmt:=TeleMut{FALSE,self} 
	if Empty(oTmt:m57_gironr)
		lTeleBank:=false
		return nil
	endif
	IF oTmt:NextTeleNonGift()
		oCCTeleBankButton:Hide()
		self:lTeleBank := true
		self:FillTeleBanking()
		IF oTmt:m56_autmut   //nog steeds herkend?
			self:OKButton()
		ENDIF
	ELSE
		self:lTeleBank := FALSE
		(WarningBox{self,"Journaling Records","No Telebanking-data found"}):Show()
	ENDIF
	RETURN nil
STATIC DEFINE GENERAL_JOURNAL_BANKBALANCE := 124 
STATIC DEFINE GENERAL_JOURNAL_BANKTEXT := 123 
STATIC DEFINE GENERAL_JOURNAL_CANCELBUTTON := 107 
STATIC DEFINE GENERAL_JOURNAL_DEBITCREDITTEXT := 109 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_CRE := 109 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_DEB := 108 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_GC := 110 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_OMS := 107 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_REK := 106 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_SC_CRE := 103 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_SC_DEB := 102 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_SC_GC := 104 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_SC_OMS := 101 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_SC_REK := 100 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_SC_SOORT := 105 
STATIC DEFINE GENERAL_JOURNAL_DETAIL_SOORT := 111 
STATIC DEFINE GENERAL_JOURNAL_FINDCLOSE := 129 
STATIC DEFINE GENERAL_JOURNAL_FINDNEXT := 127 
STATIC DEFINE GENERAL_JOURNAL_FINDPREVIOUS := 128 
STATIC DEFINE GENERAL_JOURNAL_FINDTEXT := 126 
STATIC DEFINE GENERAL_JOURNAL_GENERALJOURNAL1 := 108 
STATIC DEFINE GENERAL_JOURNAL_GIROTEXT := 119 
STATIC DEFINE GENERAL_JOURNAL_GROUPBOXFIND := 125 
STATIC DEFINE GENERAL_JOURNAL_IMPORTBUTTON := 122 
STATIC DEFINE GENERAL_JOURNAL_MBST := 100 
STATIC DEFINE GENERAL_JOURNAL_MDAT := 101 
STATIC DEFINE GENERAL_JOURNAL_MPERSON := 103 
STATIC DEFINE GENERAL_JOURNAL_MPOSTSTATUS := 102 
STATIC DEFINE GENERAL_JOURNAL_MTRANSAKTNR := 113 
STATIC DEFINE GENERAL_JOURNAL_OKBUTTON := 105 
STATIC DEFINE GENERAL_JOURNAL_PERSONBUTTON := 112 
STATIC DEFINE GENERAL_JOURNAL_POSTBUTTON := 106 
STATIC DEFINE GENERAL_JOURNAL_RECODERDBYTEXT := 121 
STATIC DEFINE GENERAL_JOURNAL_SAVEBUTTON := 104 
STATIC DEFINE GENERAL_JOURNAL_SC_BST := 115 
STATIC DEFINE GENERAL_JOURNAL_SC_CLN := 111 
STATIC DEFINE GENERAL_JOURNAL_SC_DAT := 117 
STATIC DEFINE GENERAL_JOURNAL_SC_TOTAL := 114 
STATIC DEFINE GENERAL_JOURNAL_SC_TRANSAKTNR1 := 118 
STATIC DEFINE GENERAL_JOURNAL_SC_TRANSAKTNR2 := 116 
STATIC DEFINE GENERAL_JOURNAL_TELEBANKBUTTON := 110 
STATIC DEFINE GENERAL_JOURNAL_USERDIDTXT := 120 
METHOD Init(oWindow) CLASS GeneralBrowser
	SUPER:Init(oWindow)
	SELF:ChangeBackground(Brush{Color{255,255,255}},GBLHITEXT)
	SELF:ChangeTextColor(ColorBlue,GBLHITEXT)
RETURN SELF
RESOURCE GeneralJournal1 DIALOGEX  78, 72, 620, 280
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Account:", GENERALJOURNAL1_SC_REK, "Static", WS_CHILD, 13, 14, 31, 13
	CONTROL	"Description:", GENERALJOURNAL1_SC_OMS, "Static", WS_CHILD, 13, 29, 39, 12
	CONTROL	"Debit:", GENERALJOURNAL1_SC_DEB, "Static", WS_CHILD, 13, 44, 21, 12
	CONTROL	"Credit:", GENERALJOURNAL1_SC_CRE, "Static", WS_CHILD, 13, 59, 22, 12
	CONTROL	"Assessment:", GENERALJOURNAL1_SC_GC, "Static", WS_CHILD, 13, 73, 41, 13
	CONTROL	"category:", GENERALJOURNAL1_SC_SOORT, "Static", WS_CHILD, 13, 88, 21, 12
	CONTROL	"Accountname:", GENERALJOURNAL1_SC_REKOMS, "Static", WS_CHILD, 13, 103, 48, 12
	CONTROL	"Account", GENERALJOURNAL1_ACCNUMBER, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 14, 90, 13, WS_EX_CLIENTEDGE
	CONTROL	"Description", GENERALJOURNAL1_DESCRIPTN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 29, 431, 12, WS_EX_CLIENTEDGE
	CONTROL	"Debit", GENERALJOURNAL1_DEB, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 72, 44, 116, 12, WS_EX_CLIENTEDGE
	CONTROL	"Credit", GENERALJOURNAL1_CRE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 72, 59, 116, 12, WS_EX_CLIENTEDGE
	CONTROL	"Asmt", GENERALJOURNAL1_GC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 73, 33, 13, WS_EX_CLIENTEDGE
	CONTROL	"category:", GENERALJOURNAL1_SOORT, "Edit", ES_AUTOHSCROLL|WS_CHILD|WS_BORDER, 72, 88, 22, 12, WS_EX_CLIENTEDGE
	CONTROL	"Accountname", GENERALJOURNAL1_ACCDESC, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_DISABLED|WS_BORDER, 72, 103, 271, 12, WS_EX_CLIENTEDGE
END

CLASS GeneralJournal1 INHERIT DataWindowExtra 

	PROTECT oDBACCNUMBER as JapDataColumn
	PROTECT oDBACCDESC as JapDataColumn
	PROTECT oDBPPDEST as JapDataColumn
	PROTECT oDBREFERENCE as JapDataColumn
	PROTECT oDBDESCRIPTN as JapDataColumn
	PROTECT oDBDEBFORGN as JapDataColumn
	PROTECT oDBCREFORGN as JapDataColumn
	PROTECT oDBGC as JapDataColumn
	PROTECT oDBCURRENCY as JapDataColumn
	PROTECT oDBDEB as JapDataColumn
	PROTECT oDBCRE as JapDataColumn
	PROTECT oDCSC_REK AS FIXEDTEXT
	PROTECT oDCSC_OMS AS FIXEDTEXT
	PROTECT oDCSC_DEB AS FIXEDTEXT
	PROTECT oDCSC_CRE AS FIXEDTEXT
	PROTECT oDCSC_GC AS FIXEDTEXT
	PROTECT oDCSC_SOORT AS FIXEDTEXT
	PROTECT oDCSC_REKOMS AS FIXEDTEXT
	PROTECT oDCAccNumber AS SINGLELINEEDIT
	PROTECT oDCDESCRIPTN AS SINGLELINEEDIT
	PROTECT oDCDEB AS SINGLELINEEDIT
	PROTECT oDCCRE AS SINGLELINEEDIT
	PROTECT oDCGC AS SINGLELINEEDIT
	PROTECT oDCSOORT AS SINGLELINEEDIT
	PROTECT oDCAccDesc AS SINGLELINEEDIT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	protect oCurr as Currency 
	export mXRate as float
	
	declare method DebCreProc
ACCESS AccDesc() CLASS GeneralJournal1
RETURN SELF:FieldGet(#AccDesc)

ASSIGN AccDesc(uValue) CLASS GeneralJournal1
SELF:FieldPut(#AccDesc, uValue)
RETURN uValue

ACCESS AccNumber() CLASS GeneralJournal1
RETURN SELF:FieldGet(#AccNumber)

ASSIGN AccNumber(uValue) CLASS GeneralJournal1
SELF:FieldPut(#AccNumber, uValue)
RETURN uValue

method AddCurr() class GeneralJournal1
	// add/remove  columns for multicurrency and OPP:
	LOCAL oBrowse:=self:Browser as GeneralBrowser
	LOCAL oHm:= self:Owner:Server as TempTrans 
	local lAddC, lAddPP as logic 
	local ColPos as int
	local nCurRec:=oHm:RecNo as int
	AEval(oHm:aMirror,{|x|lAddC:=iif(x[11]==sCurr,iif(x[12]==true,true,lAddC),true) } )
	if oBrowse:GetColumn(#Currency)==nil 
		if lAddC
			oBrowse:GetColumn(#CREFORGN)
			oBrowse:AddColumn(oDBCRE,self:oDBCREFORGN:VisualPos+1) 
			oBrowse:AddColumn(oDBDEB,self:oDBCREFORGN:VisualPos+1) 
			oBrowse:AddColumn(oDBCURRENCY,self:oDBCREFORGN:VisualPos+1) 
			if self:oCurr==null_object
				self:oCurr:=Currency{}
			endif
		endif
	elseif !lAddC
		oBrowse:RemoveColumn( oDBCRE)
		oBrowse:RemoveColumn( oDBDEB)
		oBrowse:RemoveColumn( oDBCURRENCY) 
	endif 
	if !Empty(sToPP) .and. ADMIN=="WA"
		AEval(oHm:aMirror,{|x|lAddPP:=iif(x[1]==sToPP,true,lAddPP)})
		if oBrowse:GetColumn(#PPDEST)==nil 
			if lAddPP 
				oBrowse:AddColumn(self:oDBPPDEST,self:oDBREKOMS:VisualPos+1) 
			endif
		elseif !lAddPP
			oBrowse:RemoveColumn( oDBPPDEST)
		endif 
	endif
	if lAddC.or.lAddPP
		if self:Owner:Size:Width <800
			self:Owner:SetWidth(self:Owner:Size:Width+=164)
			oBrowse:Refresh()
		endif
	else 
		if self:Owner:Size:Width >=800
			self:Owner:SetWidth(self:Owner:Size:Width-=164)
			oBrowse:Refresh()
		endif
	endif
	oHm:RecNo:=nCurRec
ACCESS category() CLASS GeneralJournal1
RETURN SELF:FieldGet(#SOORT)

ASSIGN category(uValue) CLASS GeneralJournal1
SELF:FieldPut(#SOORT, uValue)
RETURN uValue

ACCESS CRE() CLASS GeneralJournal1
RETURN SELF:FieldGet(#CRE)

ASSIGN CRE(uValue) CLASS GeneralJournal1
SELF:FieldPut(#CRE, uValue)
RETURN uValue

ACCESS CREFORGN() CLASS GeneralJournal1
RETURN SELF:FieldGet(#CREFORGN)

ASSIGN CREFORGN(uValue) CLASS GeneralJournal1
SELF:FieldPut(#CREFORGN, uValue)
RETURN uValue

ACCESS Currency() CLASS GeneralJournal1
RETURN SELF:FieldGet(#Currency)

ASSIGN Currency(uValue) CLASS GeneralJournal1
SELF:FieldPut(#Currency, uValue)
RETURN uValue

ACCESS DEB() CLASS GeneralJournal1
RETURN SELF:FieldGet(#DEB)

ASSIGN DEB(uValue) CLASS GeneralJournal1
SELF:FieldPut(#DEB, uValue)
RETURN uValue

ACCESS DEBFORGN() CLASS GeneralJournal1
RETURN SELF:FieldGet(#DEBFORGN)

ASSIGN DEBFORGN(uValue) CLASS GeneralJournal1
SELF:FieldPut(#DEBFORGN, uValue)
RETURN uValue

ACCESS Description() CLASS GeneralJournal1
RETURN self:FIELDGET(#description)

ASSIGN Description(uValue) CLASS GeneralJournal1
self:FIELDPUT(#description, uValue)
RETURN uValue

ACCESS DESCRIPTN() CLASS GeneralJournal1
RETURN SELF:FieldGet(#DESCRIPTN)

ASSIGN DESCRIPTN(uValue) CLASS GeneralJournal1
SELF:FieldPut(#DESCRIPTN, uValue)
RETURN uValue

ACCESS GC() CLASS GeneralJournal1
RETURN SELF:FieldGet(#GC)

ASSIGN GC(uValue) CLASS GeneralJournal1
SELF:FieldPut(#GC, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS GeneralJournal1 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"GeneralJournal1",_GetInst()},iCtlID)

oDCSC_REK := FixedText{SELF,ResourceID{GENERALJOURNAL1_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,"Account:",NULL_STRING,NULL_STRING}

oDCSC_OMS := FixedText{SELF,ResourceID{GENERALJOURNAL1_SC_OMS,_GetInst()}}
oDCSC_OMS:HyperLabel := HyperLabel{#SC_OMS,"Description:",NULL_STRING,NULL_STRING}

oDCSC_DEB := FixedText{SELF,ResourceID{GENERALJOURNAL1_SC_DEB,_GetInst()}}
oDCSC_DEB:HyperLabel := HyperLabel{#SC_DEB,"Debit:",NULL_STRING,NULL_STRING}

oDCSC_CRE := FixedText{SELF,ResourceID{GENERALJOURNAL1_SC_CRE,_GetInst()}}
oDCSC_CRE:HyperLabel := HyperLabel{#SC_CRE,"Credit:",NULL_STRING,NULL_STRING}

oDCSC_GC := FixedText{SELF,ResourceID{GENERALJOURNAL1_SC_GC,_GetInst()}}
oDCSC_GC:HyperLabel := HyperLabel{#SC_GC,"Assessment:",NULL_STRING,NULL_STRING}

oDCSC_SOORT := FixedText{SELF,ResourceID{GENERALJOURNAL1_SC_SOORT,_GetInst()}}
oDCSC_SOORT:HyperLabel := HyperLabel{#SC_SOORT,"category:",null_string,null_string}

oDCSC_REKOMS := FixedText{SELF,ResourceID{GENERALJOURNAL1_SC_REKOMS,_GetInst()}}
oDCSC_REKOMS:HyperLabel := HyperLabel{#SC_REKOMS,"Accountname:",NULL_STRING,NULL_STRING}

oDCAccNumber := SingleLineEdit{SELF,ResourceID{GENERALJOURNAL1_ACCNUMBER,_GetInst()}}
oDCAccNumber:FieldSpec := Account_AccNumber{}
oDCAccNumber:HyperLabel := HyperLabel{#AccNumber,"Account","Account of transaction",NULL_STRING}

oDCDESCRIPTN := SingleLineEdit{SELF,ResourceID{GENERALJOURNAL1_DESCRIPTN,_GetInst()}}
oDCDESCRIPTN:HyperLabel := HyperLabel{#DESCRIPTN,"Description",NULL_STRING,NULL_STRING}
oDCDESCRIPTN:ScrollMode := SCRMODE_FULL
oDCDESCRIPTN:FieldSpec := Description{}
oDCDESCRIPTN:Picture := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

oDCDEB := SingleLineEdit{SELF,ResourceID{GENERALJOURNAL1_DEB,_GetInst()}}
oDCDEB:FieldSpec := TRANSACTION_DEB{}
oDCDEB:HyperLabel := HyperLabel{#DEB,"Debit","debit amount in system currency",NULL_STRING}
oDCDEB:OverWrite := OVERWRITE_ALWAYS
oDCDEB:UseHLforToolTip := True

oDCCRE := SingleLineEdit{SELF,ResourceID{GENERALJOURNAL1_CRE,_GetInst()}}
oDCCRE:FieldSpec := Transaction_CRE{}
oDCCRE:HyperLabel := HyperLabel{#CRE,"Credit","credit amount in system currency",NULL_STRING}
oDCCRE:OverWrite := OVERWRITE_ALWAYS
oDCCRE:UseHLforToolTip := True

oDCGC := SingleLineEdit{SELF,ResourceID{GENERALJOURNAL1_GC,_GetInst()}}
oDCGC:HyperLabel := HyperLabel{#GC,"Asmt",NULL_STRING,"Transaction_GC"}
oDCGC:TextLimit := 7

oDCSOORT := SingleLineEdit{SELF,ResourceID{GENERALJOURNAL1_SOORT,_GetInst()}}
oDCSOORT:FieldSpec := Hulpmut_Soort{}
oDCSOORT:HyperLabel := HyperLabel{#SOORT,"category:",null_string,"Hulpmut_Soort"}

oDCAccDesc := SingleLineEdit{SELF,ResourceID{GENERALJOURNAL1_ACCDESC,_GetInst()}}
oDCAccDesc:HyperLabel := HyperLabel{#AccDesc,"Accountname","Description",NULL_STRING}
oDCAccDesc:AutoFocusChange := False
oDCAccDesc:ScrollMode := SCRMODE_FULL
oDCAccDesc:FieldSpec := AccDesc{}

SELF:Caption := "Input of general records"
SELF:HyperLabel := HyperLabel{#GeneralJournal1,"Input of general records",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:OwnerAlignment := OA_PWIDTH_PHEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := JournalBrowser{self}

oDBACCNUMBER := JapDataColumn{Account_AccNumber{}}
oDBACCNUMBER:Width := 11
oDBACCNUMBER:HyperLabel := oDCACCNUMBER:HyperLabel 
oDBACCNUMBER:Caption := "Account"
self:Browser:AddColumn(oDBACCNUMBER)

oDBACCDESC := JapDataColumn{AccDesc{}}
oDBACCDESC:Width := 19
oDBACCDESC:HyperLabel := oDCACCDESC:HyperLabel 
oDBACCDESC:Caption := "Accountname"
self:Browser:AddColumn(oDBACCDESC)

oDBPPDEST := JapDataColumn{PPCodes_PPCode{}}
oDBPPDEST:Width := 16
oDBPPDEST:HyperLabel := HyperLabel{#PPDEST,"Destination PP",NULL_STRING,NULL_STRING} 
oDBPPDEST:Caption := "Destination PP"
self:Browser:AddColumn(oDBPPDEST)

oDBREFERENCE := JapDataColumn{Transaction_REFERENCE{}}
oDBREFERENCE:Width := 10
oDBREFERENCE:HyperLabel := HyperLabel{#Reference,"Reference","for selection or as RPP-destination string",NULL_STRING} 
oDBREFERENCE:Caption := "Reference"
self:Browser:AddColumn(oDBREFERENCE)

oDBDESCRIPTN := JapDataColumn{Description{}}
oDBDESCRIPTN:Width := 41
oDBDESCRIPTN:HyperLabel := oDCDESCRIPTN:HyperLabel 
oDBDESCRIPTN:Caption := "Description"
self:Browser:AddColumn(oDBDESCRIPTN)

oDBDEBFORGN := JapDataColumn{Transaction_DEB{}}
oDBDEBFORGN:Width := 9
oDBDEBFORGN:HyperLabel := HyperLabel{#DEBFORGN,"Debit","Debit amount in specific currency",NULL_STRING} 
oDBDEBFORGN:Caption := "Debit"
self:Browser:AddColumn(oDBDEBFORGN)

oDBCREFORGN := JapDataColumn{Transaction_CRE{}}
oDBCREFORGN:Width := 9
oDBCREFORGN:HyperLabel := HyperLabel{#CREFORGN,"Credit","credit amount in specific currency",NULL_STRING} 
oDBCREFORGN:Caption := "Credit"
self:Browser:AddColumn(oDBCREFORGN)

oDBGC := JapDataColumn{11}
oDBGC:Width := 11
oDBGC:HyperLabel := oDCGC:HyperLabel 
oDBGC:Caption := "Asmt"
self:Browser:AddColumn(oDBGC)

oDBCURRENCY := JapDataColumn{Sysparms_SMUNT{}}
oDBCURRENCY:Width := 8
oDBCURRENCY:HyperLabel := HyperLabel{#Currency,"Currency",NULL_STRING,NULL_STRING} 
oDBCURRENCY:Caption := "Currency"
self:Browser:AddColumn(oDBCURRENCY)

oDBDEB := JapDataColumn{TRANSACTION_DEB{}}
oDBDEB:Width := 9
oDBDEB:HyperLabel := oDCDEB:HyperLabel 
oDBDEB:Caption := "Debit"
self:Browser:AddColumn(oDBDEB)

oDBCRE := JapDataColumn{Transaction_CRE{}}
oDBCRE:Width := 9
oDBCRE:HyperLabel := oDCCRE:HyperLabel 
oDBCRE:Caption := "Credit"
self:Browser:AddColumn(oDBCRE)


SELF:ViewAs(#BrowseView)
oDCGC:TextLimit := 7

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method ListBoxSelect(oControlEvent) class GeneralJournal1
	local oControl as Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	super:ListBoxSelect(oControlEvent)
	//Put your changes here 
	return NIL
ACCESS OPP() CLASS GeneralJournal1
RETURN SELF:FieldGet(#OPP)

ASSIGN OPP(uValue) CLASS GeneralJournal1
SELF:FieldPut(#OPP, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS GeneralJournal1
	//Put your PostInit additions here
	LOCAL oCol as JapDataColumn
	LOCAL oBrowse:=self:Browser as GeneralBrowser 
self:SetTexts()
	self:server:oBrowse := oBrowse
	self:oDBAccDesc:SetStandardStyle(gbsReadOnly)
	IF !(ADMIN=="WO".or.ADMIN=="HO")
		* remove assessment column:
		oBrowse:RemoveColumn(oDBGC)
	ENDIF
	oDBDEB:Caption += " "+sCURR
	oDBDEB:SetStandardStyle(gbsReadOnly) 

	oDBCRE:Caption += " "+sCURR
	oDBCRE:SetStandardStyle(gbsReadOnly) 
	oBrowse:RemoveColumn(oDBCURRENCY)
	oBrowse:RemoveColumn(self:oDBPPDEST)
	oBrowse:RemoveColumn(oDBDEB)
	oBrowse:RemoveColumn(oDBCRE)
	
	RETURN NIL
ACCESS PPDEST() CLASS GeneralJournal1
RETURN SELF:FieldGet(#PPDEST)

ASSIGN PPDEST(uValue) CLASS GeneralJournal1
SELF:FieldPut(#PPDEST, uValue)
RETURN uValue

method PreInit(oWindow,iCtlID,oServer,uExtra) class GeneralJournal1
	//Put your PreInit additions here 
	oWindow:use(oWindow:oHlpMut)
	return NIL

ACCESS Reference() CLASS GeneralJournal1
RETURN SELF:FieldGet(#Reference)

ASSIGN Reference(uValue) CLASS GeneralJournal1
SELF:FieldPut(#Reference, uValue)
RETURN uValue

ACCESS REKOMS() CLASS GeneralJournal1
RETURN SELF:FieldGet(#REKOMS)

ASSIGN REKOMS(uValue) CLASS GeneralJournal1
SELF:FieldPut(#REKOMS, uValue)
RETURN uValue

STATIC DEFINE GENERALJOURNAL1_ACCDESC := 113 
STATIC DEFINE GENERALJOURNAL1_ACCNUMBER := 107 
STATIC DEFINE GENERALJOURNAL1_CRE := 110 
STATIC DEFINE GENERALJOURNAL1_CREFORGN := 115 
STATIC DEFINE GENERALJOURNAL1_CURRENCY := 116 
STATIC DEFINE GENERALJOURNAL1_DEB := 109 
STATIC DEFINE GENERALJOURNAL1_DEBFORGN := 114 
STATIC DEFINE GENERALJOURNAL1_DESCRIPTN := 108 
STATIC DEFINE GENERALJOURNAL1_GC := 111 
STATIC DEFINE GENERALJOURNAL1_OMS := 108 
STATIC DEFINE GENERALJOURNAL1_PPDEST := 118 
STATIC DEFINE GENERALJOURNAL1_REFERENCE := 117 
STATIC DEFINE GENERALJOURNAL1_REKOMS := 113 
STATIC DEFINE GENERALJOURNAL1_SC_CRE := 103 
STATIC DEFINE GENERALJOURNAL1_SC_DEB := 102 
STATIC DEFINE GENERALJOURNAL1_SC_GC := 104 
STATIC DEFINE GENERALJOURNAL1_SC_OMS := 101 
STATIC DEFINE GENERALJOURNAL1_SC_REK := 100 
STATIC DEFINE GENERALJOURNAL1_SC_REKOMS := 106 
STATIC DEFINE GENERALJOURNAL1_SC_SOORT := 105 
STATIC DEFINE GENERALJOURNAL1_SOORT := 112 
STATIC DEFINE GETTRANSFERACCOUD_ACCBUTTON := 100 
STATIC DEFINE GETTRANSFERACCOUD_CANCELBUTTON := 104 
STATIC DEFINE GETTRANSFERACCOUD_FIXEDTEXT := 102 
STATIC DEFINE GETTRANSFERACCOUD_OKBUTTON := 103 
STATIC DEFINE GETTRANSFERACCOUD_TRANSFERACC := 101 
CLASS Hulpmut_REK INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
STATIC DEFINE INQUIRYSELECT_ACCBUTTON := 102 
STATIC DEFINE INQUIRYSELECT_CANCELBUTTON := 108 
STATIC DEFINE INQUIRYSELECT_FIXEDTEXT1 := 100 
STATIC DEFINE INQUIRYSELECT_FIXEDTEXT3 := 103 
STATIC DEFINE INQUIRYSELECT_FIXEDTEXT4 := 104 
STATIC DEFINE INQUIRYSELECT_FIXEDTEXT5 := 111 
STATIC DEFINE INQUIRYSELECT_FIXEDTEXT6 := 112 
STATIC DEFINE INQUIRYSELECT_FIXEDTEXT7 := 113 
STATIC DEFINE INQUIRYSELECT_FROMBST := 117 
STATIC DEFINE INQUIRYSELECT_FROMDATE := 105 
STATIC DEFINE INQUIRYSELECT_FROMTRANSNR := 109 
STATIC DEFINE INQUIRYSELECT_MACCOUNT := 101 
STATIC DEFINE INQUIRYSELECT_MPERSON := 114 
STATIC DEFINE INQUIRYSELECT_OKBUTTON := 107 
STATIC DEFINE INQUIRYSELECT_PERSONBUTTON := 115 
STATIC DEFINE INQUIRYSELECT_SC_BST := 116 
STATIC DEFINE INQUIRYSELECT_SC_BST1 := 119 
STATIC DEFINE INQUIRYSELECT_TOBST := 118 
STATIC DEFINE INQUIRYSELECT_TODATE := 106 
STATIC DEFINE INQUIRYSELECT_TOTRANSNR := 110 
CLASS InquirySelection INHERIT DataWindowExtra 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCmAccount AS SINGLELINEEDIT
	PROTECT oCCAccButton AS PUSHBUTTON
	PROTECT oDCmToAccount AS SINGLELINEEDIT
	PROTECT oCCAccButtonTo AS PUSHBUTTON
	PROTECT oDCFromdate AS DATESTANDARD
	PROTECT oDCTodate AS DATESTANDARD
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oDCFromTransnr AS SINGLELINEEDIT
	PROTECT oDCToTransnr AS SINGLELINEEDIT
	PROTECT oDCFromAmount AS SINGLELINEEDIT
	PROTECT oDCToAmount AS SINGLELINEEDIT
	PROTECT oDCAmountType AS RADIOBUTTONGROUP
	PROTECT oCCRadioButton1 AS RADIOBUTTON
	PROTECT oCCRadioButton2 AS RADIOBUTTON
	PROTECT oCCRadioButton3 AS RADIOBUTTON
	PROTECT oDCDocID AS SINGLELINEEDIT
	PROTECT oDCDescription AS SINGLELINEEDIT
	PROTECT oDCReference AS SINGLELINEEDIT
	PROTECT oDCmPerson AS SINGLELINEEDIT
	PROTECT oCCPersonButton AS PUSHBUTTON
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCResetButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCSC_BST AS FIXEDTEXT
	PROTECT oDCSC_From AS FIXEDTEXT
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oDCFixedText9 AS FIXEDTEXT
	PROTECT oDCSC_REF AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCPostingStatus AS RADIOBUTTONGROUP
	PROTECT oCCRadioPost1 AS RADIOBUTTON
	PROTECT oCCRadioPost2 AS RADIOBUTTON
	PROTECT oCCRadioPost3 AS RADIOBUTTON
	PROTECT oCCRadioPost4 AS RADIOBUTTON
	PROTECT oDCSC_DEP AS FIXEDTEXT
	PROTECT oCCFromDepButton AS PUSHBUTTON
	PROTECT oDCFromDep AS SINGLELINEEDIT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  	INSTANCE mAccount
  	INSTANCE mAccountTo
	INSTANCE FromTransnr
	INSTANCE ToTransnr
	INSTANCE FromAmount
	INSTANCE ToAmount
	INSTANCE DocID
	INSTANCE mPerson
	INSTANCE AmountType
	INSTANCE Description
	protect oDep as Department
	Export oAcc as Account
  	EXPORT oPers AS Person
  	EXPORT nAccount, nAccountTo  as STRING
	EXPORT cAccName, cAccNumber,cAccNameTo, cAccNumberTo as STRING
  	PROTECT mCLNGiver AS STRING
  	PROTECT cGiverName AS STRING

	PROTECT oOwner AS TransInquiry
	PROTECT cDep, cBal,cSoort, cCurr,cFromDepId as STRING
	PROTECT cCurDep as STRING
	PROTECT cDepTo, cSoortTo, cCurrTo as STRING  
	
RESOURCE InquirySelection DIALOGEX  28, 25, 377, 195
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"From Accountnbr:", INQUIRYSELECTION_FIXEDTEXT1, "Static", WS_CHILD, 12, 14, 68, 13
	CONTROL	"", INQUIRYSELECTION_MACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 14, 105, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", INQUIRYSELECTION_ACCBUTTON, "Button", WS_CHILD, 184, 14, 13, 13
	CONTROL	"", INQUIRYSELECTION_MTOACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 248, 14, 109, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", INQUIRYSELECTION_ACCBUTTONTO, "Button", WS_CHILD, 356, 14, 13, 13
	CONTROL	"donderdag 29 juli 2010", INQUIRYSELECTION_FROMDATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 80, 36, 118, 14
	CONTROL	"donderdag 29 juli 2010", INQUIRYSELECTION_TODATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 248, 38, 120, 14
	CONTROL	"From Date:", INQUIRYSELECTION_FIXEDTEXT3, "Static", WS_CHILD, 12, 36, 53, 13
	CONTROL	"Till:", INQUIRYSELECTION_FIXEDTEXT4, "Static", WS_CHILD, 208, 38, 17, 13
	CONTROL	"", INQUIRYSELECTION_FROMTRANSNR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 59, 66, 12, WS_EX_CLIENTEDGE
	CONTROL	"", INQUIRYSELECTION_TOTRANSNR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 247, 60, 67, 12, WS_EX_CLIENTEDGE
	CONTROL	"Minimal Amount", INQUIRYSELECTION_FROMAMOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 81, 66, 12, WS_EX_CLIENTEDGE
	CONTROL	"Maximum Amount", INQUIRYSELECTION_TOAMOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 248, 81, 66, 12, WS_EX_CLIENTEDGE
	CONTROL	" Type", INQUIRYSELECTION_AMOUNTTYPE, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 328, 66, 40, 38
	CONTROL	"All", INQUIRYSELECTION_RADIOBUTTON1, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 332, 73, 24, 11
	CONTROL	"Debit", INQUIRYSELECTION_RADIOBUTTON2, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 332, 83, 32, 11
	CONTROL	"Credit", INQUIRYSELECTION_RADIOBUTTON3, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 332, 92, 34, 11
	CONTROL	"Doc id:", INQUIRYSELECTION_DOCID, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 107, 66, 12
	CONTROL	"Description", INQUIRYSELECTION_DESCRIPTION, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 248, 107, 120, 12
	CONTROL	"", INQUIRYSELECTION_REFERENCE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 125, 66, 12, WS_EX_CLIENTEDGE
	CONTROL	"", INQUIRYSELECTION_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 144, 105, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", INQUIRYSELECTION_PERSONBUTTON, "Button", WS_CHILD, 184, 144, 13, 12
	CONTROL	"From Transactionnbr:", INQUIRYSELECTION_FIXEDTEXT5, "Static", WS_CHILD, 12, 59, 68, 12
	CONTROL	"Till:", INQUIRYSELECTION_FIXEDTEXT6, "Static", WS_CHILD, 208, 60, 23, 13
	CONTROL	"Person:", INQUIRYSELECTION_FIXEDTEXT7, "Static", WS_CHILD, 12, 144, 53, 12
	CONTROL	"OK", INQUIRYSELECTION_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 316, 180, 53, 13
	CONTROL	"Reset", INQUIRYSELECTION_RESETBUTTON, "Button", WS_TABSTOP|WS_CHILD, 204, 180, 53, 13
	CONTROL	"Cancel", INQUIRYSELECTION_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 260, 180, 53, 13
	CONTROL	"Document id:", INQUIRYSELECTION_SC_BST, "Static", WS_CHILD, 12, 107, 50, 12
	CONTROL	"Amount Minimum:", INQUIRYSELECTION_SC_FROM, "Static", WS_CHILD, 12, 81, 61, 12
	CONTROL	"Maximum:", INQUIRYSELECTION_FIXEDTEXT8, "Static", WS_CHILD, 208, 81, 32, 13
	CONTROL	"Description:", INQUIRYSELECTION_FIXEDTEXT9, "Static", WS_CHILD, 208, 107, 38, 12
	CONTROL	"Reference", INQUIRYSELECTION_SC_REF, "Static", WS_CHILD, 12, 125, 53, 12
	CONTROL	"Till", INQUIRYSELECTION_FIXEDTEXT2, "Static", WS_CHILD, 208, 14, 16, 13
	CONTROL	"Posting Status", INQUIRYSELECTION_POSTINGSTATUS, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|NOT WS_VISIBLE, 248, 121, 66, 50
	CONTROL	"All", INQUIRYSELECTION_RADIOPOST1, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 252, 129, 55, 11
	CONTROL	"Ready to Post", INQUIRYSELECTION_RADIOPOST2, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 252, 139, 59, 11
	CONTROL	"Not Posted", INQUIRYSELECTION_RADIOPOST3, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 252, 149, 56, 11
	CONTROL	"Posted", INQUIRYSELECTION_RADIOPOST4, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 252, 158, 55, 11
	CONTROL	"Department From:", INQUIRYSELECTION_SC_DEP, "Static", WS_CHILD|NOT WS_VISIBLE, 12, 162, 67, 12
	CONTROL	"v", INQUIRYSELECTION_FROMDEPBUTTON, "Button", WS_CHILD|NOT WS_VISIBLE, 184, 162, 13, 12
	CONTROL	"", INQUIRYSELECTION_FROMDEP, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 80, 162, 105, 12, WS_EX_CLIENTEDGE
END

METHOD AccButton(lUnique )  CLASS InquirySelection
Default(@lUnique,false)
	AccountSelect(self,AllTrim(oDCmAccount:TEXTValue ),"AccountFrom",lUnique,,,,)
	RETURN 
METHOD AccButtonTo(lUnique )  CLASS InquirySelection
Default(@lUnique,false)
	AccountSelect(self,AllTrim(self:oDCmToAccount:TEXTValue ),"AccountTo",lUnique,,,,)
RETURN 
ACCESS AmountType() CLASS InquirySelection
RETURN SELF:FieldGet(#AmountType)

ASSIGN AmountType(uValue) CLASS InquirySelection
SELF:FieldPut(#AmountType, uValue)
RETURN uValue

METHOD CancelButton( ) CLASS InquirySelection
	SELF:EndWindow()
	RETURN NIL
METHOD Close(oEvent) CLASS InquirySelection
*	SUPER:Close(oEvent)
	//Put your changes here
IF !oAcc==NULL_OBJECT
	IF oAcc:Used
		oAcc:Close()
	ENDIF
	oAcc:=NULL_OBJECT
ENDIF
IF !oPers==NULL_OBJECT
	IF oPers:Used
		oPers:Close()
	ENDIF
	oPers:=NULL_OBJECT
ENDIF
SELF:Destroy()
	// force garbage collection
	*CollectForced()

	RETURN SUPER:Close(oEvent)
*RETURN NIL
ACCESS Description() CLASS InquirySelection
RETURN SELF:FieldGet(#Description)

ASSIGN Description(uValue) CLASS InquirySelection
SELF:FieldPut(#Description, uValue)
RETURN uValue

ACCESS DocID() CLASS InquirySelection
RETURN SELF:FieldGet(#DocID)

ASSIGN DocID(uValue) CLASS InquirySelection
SELF:FieldPut(#DocID, uValue)
RETURN uValue

METHOD EditFocusChange(oEditFocusChangeEvent) CLASS InquirySelection
	LOCAL oControl AS Control
	LOCAL lGotFocus as LOGIC 
	LOCAL cCurValue as USUAL
	local nPntr as int 

	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "MPERSON".and.!AllTrim(oControl:Value)==AllTrim(cGiverName)
           	cGiverName:=AllTrim(oControl:textVALUE)
			self:PersonButton(true)
		ELSEIF oControl:Name == "MACCOUNT"
			IF !Upper(AllTrim(oControl:textVALUE))==Upper(cAccName)
            cAccName:=AllTrim(oControl:VALUE)
				SELF:AccButton(TRUE)
			ENDIF
		ELSEIF oControl:Name == "MTOACCOUNT"
			IF !Upper(AllTrim(oControl:textVALUE))==Upper(self:cAccNameTo)
            cAccNameTo:=AllTrim(oControl:VALUE)
				self:AccButtonTo(true)
			ENDIF
		elseIF oControl:NameSym==#FromDep .and.!AllTrim(oControl:VALUE)==cCurDep
			cCurDep:=AllTrim(oControl:VALUE)
			cCurValue:=cCurDep
			nPntr:=At(":",cCurValue)
			IF nPntr>1
				cCurValue:=SubStr(cCurValue,1,nPntr-1)
			ENDIF
			IF FindDep(@cCurValue)
				self:RegDepartment(cCurValue,"From Department")
			ELSE
				self:FromDepButton()
			ENDIF
		ENDIF
	ENDIF
		
	RETURN NIL
ACCESS FromAmount() CLASS InquirySelection
RETURN SELF:FieldGet(#FromAmount)

ASSIGN FromAmount(uValue) CLASS InquirySelection
SELF:FieldPut(#FromAmount, uValue)
RETURN uValue

ACCESS FromDep() CLASS InquirySelection
RETURN SELF:FieldGet(#FromDep)

ASSIGN FromDep(uValue) CLASS InquirySelection
SELF:FieldPut(#FromDep, uValue)
RETURN uValue

METHOD FromDepButton( ) CLASS InquirySelection 
	LOCAL cCurValue as STRING
	LOCAL nPntr as int

	cCurValue:=AllTrim(self:oDCFromDep:TextValue)
	(DepartmentExplorer{self:Owner,"Department",self:cCurDep,self,cCurValue,"From Department"}):Show()

RETURN NIL
ACCESS FromTransnr() CLASS InquirySelection
RETURN SELF:FieldGet(#FromTransnr)

ASSIGN FromTransnr(uValue) CLASS InquirySelection
SELF:FieldPut(#FromTransnr, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS InquirySelection 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"InquirySelection",_GetInst()},iCtlID)

oDCFixedText1 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"From Accountnbr:",NULL_STRING,NULL_STRING}

oDCmAccount := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_MACCOUNT,_GetInst()}}
oDCmAccount:HyperLabel := HyperLabel{#mAccount,NULL_STRING,NULL_STRING,NULL_STRING}

oCCAccButton := PushButton{SELF,ResourceID{INQUIRYSELECTION_ACCBUTTON,_GetInst()}}
oCCAccButton:HyperLabel := HyperLabel{#AccButton,"v","Browse in accounts",NULL_STRING}
oCCAccButton:TooltipText := "Browse in accounts"

oDCmToAccount := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_MTOACCOUNT,_GetInst()}}
oDCmToAccount:HyperLabel := HyperLabel{#mToAccount,NULL_STRING,NULL_STRING,NULL_STRING}

oCCAccButtonTo := PushButton{SELF,ResourceID{INQUIRYSELECTION_ACCBUTTONTO,_GetInst()}}
oCCAccButtonTo:HyperLabel := HyperLabel{#AccButtonTo,"v","Browse in accounts",NULL_STRING}
oCCAccButtonTo:TooltipText := "Browse in accounts"

oDCFromdate := DateStandard{SELF,ResourceID{INQUIRYSELECTION_FROMDATE,_GetInst()}}
oDCFromdate:FieldSpec := Transaction_DAT{}
oDCFromdate:HyperLabel := HyperLabel{#Fromdate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCTodate := DateStandard{SELF,ResourceID{INQUIRYSELECTION_TODATE,_GetInst()}}
oDCTodate:FieldSpec := Transaction_DAT{}
oDCTodate:HyperLabel := HyperLabel{#Todate,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"From Date:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Till:",NULL_STRING,NULL_STRING}

oDCFromTransnr := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_FROMTRANSNR,_GetInst()}}
oDCFromTransnr:FieldSpec := TRANSACTION_TRANSAKTNR{}
oDCFromTransnr:HyperLabel := HyperLabel{#FromTransnr,NULL_STRING,NULL_STRING,NULL_STRING}

oDCToTransnr := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_TOTRANSNR,_GetInst()}}
oDCToTransnr:FieldSpec := TRANSACTION_TRANSAKTNR{}
oDCToTransnr:HyperLabel := HyperLabel{#ToTransnr,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFromAmount := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_FROMAMOUNT,_GetInst()}}
oDCFromAmount:HyperLabel := HyperLabel{#FromAmount,"Minimal Amount",NULL_STRING,NULL_STRING}
oDCFromAmount:FieldSpec := BedragStr{}

oDCToAmount := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_TOAMOUNT,_GetInst()}}
oDCToAmount:HyperLabel := HyperLabel{#ToAmount,"Maximum Amount",NULL_STRING,NULL_STRING}
oDCToAmount:FieldSpec := BedragStr{}

oCCRadioButton1 := RadioButton{SELF,ResourceID{INQUIRYSELECTION_RADIOBUTTON1,_GetInst()}}
oCCRadioButton1:HyperLabel := HyperLabel{#RadioButton1,"All",NULL_STRING,NULL_STRING}

oCCRadioButton2 := RadioButton{SELF,ResourceID{INQUIRYSELECTION_RADIOBUTTON2,_GetInst()}}
oCCRadioButton2:HyperLabel := HyperLabel{#RadioButton2,"Debit",NULL_STRING,NULL_STRING}

oCCRadioButton3 := RadioButton{SELF,ResourceID{INQUIRYSELECTION_RADIOBUTTON3,_GetInst()}}
oCCRadioButton3:HyperLabel := HyperLabel{#RadioButton3,"Credit",NULL_STRING,NULL_STRING}

oDCDocID := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_DOCID,_GetInst()}}
oDCDocID:FieldSpec := Transaction_BST{}
oDCDocID:HyperLabel := HyperLabel{#DocID,"Doc id:",NULL_STRING,"Transaction_BST"}

oDCDescription := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_DESCRIPTION,_GetInst()}}
oDCDescription:FieldSpec := Description{}
oDCDescription:HyperLabel := HyperLabel{#Description,"Description",NULL_STRING,NULL_STRING}
oDCDescription:TooltipText := "text within desciption of transaction"

oDCReference := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_REFERENCE,_GetInst()}}
oDCReference:HyperLabel := HyperLabel{#Reference,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmPerson := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_MPERSON,_GetInst()}}
oDCmPerson:HyperLabel := HyperLabel{#mPerson,NULL_STRING,"Person from who originates the amount","HELP_CLN"}
oDCmPerson:Picture := "XXXXXXXXXXXXXXXXXXXX"

oCCPersonButton := PushButton{SELF,ResourceID{INQUIRYSELECTION_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v","Browse in persons",NULL_STRING}
oCCPersonButton:TooltipText := "Browse in Persons"

oDCFixedText5 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"From Transactionnbr:",NULL_STRING,NULL_STRING}

oDCFixedText6 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"Till:",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Person:",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{INQUIRYSELECTION_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCResetButton := PushButton{SELF,ResourceID{INQUIRYSELECTION_RESETBUTTON,_GetInst()}}
oCCResetButton:HyperLabel := HyperLabel{#ResetButton,"Reset",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{INQUIRYSELECTION_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCSC_BST := FixedText{SELF,ResourceID{INQUIRYSELECTION_SC_BST,_GetInst()}}
oDCSC_BST:HyperLabel := HyperLabel{#SC_BST,"Document id:",NULL_STRING,NULL_STRING}

oDCSC_From := FixedText{SELF,ResourceID{INQUIRYSELECTION_SC_FROM,_GetInst()}}
oDCSC_From:HyperLabel := HyperLabel{#SC_From,"Amount Minimum:",NULL_STRING,NULL_STRING}

oDCFixedText8 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"Maximum:",NULL_STRING,NULL_STRING}

oDCFixedText9 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT9,_GetInst()}}
oDCFixedText9:HyperLabel := HyperLabel{#FixedText9,"Description:",NULL_STRING,NULL_STRING}

oDCSC_REF := FixedText{SELF,ResourceID{INQUIRYSELECTION_SC_REF,_GetInst()}}
oDCSC_REF:HyperLabel := HyperLabel{#SC_REF,"Reference",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Till",NULL_STRING,NULL_STRING}

oCCRadioPost1 := RadioButton{SELF,ResourceID{INQUIRYSELECTION_RADIOPOST1,_GetInst()}}
oCCRadioPost1:HyperLabel := HyperLabel{#RadioPost1,"All",NULL_STRING,NULL_STRING}

oCCRadioPost2 := RadioButton{SELF,ResourceID{INQUIRYSELECTION_RADIOPOST2,_GetInst()}}
oCCRadioPost2:HyperLabel := HyperLabel{#RadioPost2,"Ready to Post",NULL_STRING,NULL_STRING}

oCCRadioPost3 := RadioButton{SELF,ResourceID{INQUIRYSELECTION_RADIOPOST3,_GetInst()}}
oCCRadioPost3:HyperLabel := HyperLabel{#RadioPost3,"Not Posted",NULL_STRING,NULL_STRING}

oCCRadioPost4 := RadioButton{SELF,ResourceID{INQUIRYSELECTION_RADIOPOST4,_GetInst()}}
oCCRadioPost4:HyperLabel := HyperLabel{#RadioPost4,"Posted",NULL_STRING,NULL_STRING}

oDCSC_DEP := FixedText{SELF,ResourceID{INQUIRYSELECTION_SC_DEP,_GetInst()}}
oDCSC_DEP:HyperLabel := HyperLabel{#SC_DEP,"Department From:",NULL_STRING,NULL_STRING}

oCCFromDepButton := PushButton{SELF,ResourceID{INQUIRYSELECTION_FROMDEPBUTTON,_GetInst()}}
oCCFromDepButton:HyperLabel := HyperLabel{#FromDepButton,"v","Browse in departments",NULL_STRING}
oCCFromDepButton:TooltipText := "Browse in departments"

oDCFromDep := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_FROMDEP,_GetInst()}}
oDCFromDep:HyperLabel := HyperLabel{#FromDep,NULL_STRING,NULL_STRING,NULL_STRING}
oDCFromDep:FieldSpec := Description{}
oDCFromDep:TooltipText := "Enter number or name of required Top of department structure"

oDCAmountType := RadioButtonGroup{SELF,ResourceID{INQUIRYSELECTION_AMOUNTTYPE,_GetInst()}}
oDCAmountType:FillUsing({ ;
							{oCCRadioButton1,"A"}, ;
							{oCCRadioButton2,"D"}, ;
							{oCCRadioButton3,"C"} ;
							})
oDCAmountType:HyperLabel := HyperLabel{#AmountType," Type",NULL_STRING,NULL_STRING}

oDCPostingStatus := RadioButtonGroup{SELF,ResourceID{INQUIRYSELECTION_POSTINGSTATUS,_GetInst()}}
oDCPostingStatus:FillUsing({ ;
								{oCCRadioPost1,"4"}, ;
								{oCCRadioPost2,"1"}, ;
								{oCCRadioPost3,"0"}, ;
								{oCCRadioPost4,"2"} ;
								})
oDCPostingStatus:HyperLabel := HyperLabel{#PostingStatus,"Posting Status",NULL_STRING,NULL_STRING}
oDCPostingStatus:FieldSpec := MonthW{}

SELF:Caption := "Selection of Financial Transactions"
SELF:HyperLabel := HyperLabel{#InquirySelection,"Selection of Financial Transactions",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mAccount() CLASS InquirySelection
RETURN SELF:FieldGet(#mAccount)

ASSIGN mAccount(uValue) CLASS InquirySelection
SELF:FieldPut(#mAccount, uValue)
RETURN uValue

ACCESS mPerson() CLASS InquirySelection
RETURN SELF:FieldGet(#mPerson)

ASSIGN mPerson(uValue) CLASS InquirySelection
SELF:FieldPut(#mPerson, uValue)
RETURN uValue

ACCESS mToAccount() CLASS InquirySelection
RETURN SELF:FieldGet(#mToAccount)

ASSIGN mToAccount(uValue) CLASS InquirySelection
SELF:FieldPut(#mToAccount, uValue)
RETURN uValue

METHOD OKButton( ) CLASS InquirySelection
local nAcc as string
	IF !Empty(self:FromAmount)
		self:FromAmount:=AllTrim(Str(Val(StrTran(self:FromAmount,",","."))))
		self:FromAmount:=StrTran(self:FromAmount,",",".")
	ELSE
		self:FromAmount:=null_string
	ENDIF
	IF !Empty(self:ToAmount)
		self:ToAmount:=AllTrim(Str(Val(StrTran(self:ToAmount,",","."))))
		self:ToAmount:=StrTran(self:ToAmount,",",".")
	ELSE
		self:ToAmount:=null_string
	ENDIF
	IF Empty(self:cAccNumberTo)
		self:cAccNumberTo := self:cAccNumber
	ELSEIF self:cAccNumberTo < self:cAccNumber
		nAcc := self:cAccNumberTo
		cAccNumberTo := cAccNumber
		cAccNumber := nAcc
	ENDIF

	self:oOwner:FromAccId:=if(Empty(self:nAccount),null_string,AllTrim(self:nAccount))
	self:oOwner:FromAccNbr:=if(Empty(self:cAccNumber),null_string,AllTrim(self:cAccNumber))
	self:oOwner:ToAccNbr:=if(Empty(self:cAccNumberTo),null_string,AllTrim(self:cAccNumberTo))
	self:oOwner:DepIdSelected:=if(Empty(self:cFromDepId),null_string,AllTrim(self:cFromDepId))
	self:oOwner:PersIdSelected:=if(Empty(self:mCLNGiver),null_string,AllTrim(self:mCLNGiver))
 	self:oOwner:StartTransNbr:=if(Empty(self:FromTransnr),null_string,AllTrim(Transform(self:FromTransnr,""))) 
 	self:oOwner:EndTransNbr:=if(Empty(self:ToTransnr),null_string,AllTrim(Transform(self:ToTransnr,""))) 
 	self:oOwner:DocIdSelected:=if(Empty(self:DOCID),null_string,AllTrim(self:DOCID))
 	self:oOwner:DescrpSelected:=if(Empty(self:Description),null_string,AllTrim(self:Description))
 	self:oOwner:ReferenceSelected:=if(Empty(self:Reference),null_string,AllTrim(self:Reference))
 	self:oOwner:StartDate:=self:oDCFromdate:SelectedDate
	self:oOwner:EndDate:=self:oDCTodate:SelectedDate
 	self:oOwner:StartAmount:=AllTrim(self:FromAmount )
 	self:oOwner:ToAmount:=AllTrim(self:ToAmount)
   self:oOwner:TransTypeSelected:=self:AmountType
   self:oOwner:cDepOrg:=cDep
//    self:oOwner:cBalOrg:=cBal
   self:oOwner:cSoortOrg:=self:cSoort
   self:oOwner:cCurr:=self:cCurr
   if Posting 
	   self:oOwner:PostStatSelected:=iif(IsString(self:PostingStatus),self:PostingStatus,Str(self:PostingStatus,-1))
   endif
   IF !Empty(self:oOwner:EndTransNbr)
		IF Val(self:oOwner:EndTransNbr)< Val(self:oOwner:StartTransNbr)
			(ErrorBox{,self:oLan:WGet("You specifies an illegal transactionnumber range")}):Show()
			RETURN
		ENDIF
	ENDIF
    IF !Empty(self:oOwner:EndDate)
		IF self:oOwner:EndDate< self:oOwner:StartDate
			(ErrorBox{,self:oLan:WGet("You specifies an illegal date range")}):Show()
			RETURN
		ENDIF
	ENDIF
    IF !Empty(self:oOwner:ToAmount)
		IF Val(self:oOwner:ToAmount)< Val(self:oOwner:StartAmount)
			(ErrorBox{,self:oLan:WGet("You specifies an illegal amount range")}):Show()
			RETURN
		ENDIF
	ENDIF
	self:oOwner:ShowSelection()
	self:EndWindow()
	RETURN
METHOD PersonButton(lUnique)  CLASS InquirySelection
LOCAL cValue := AllTrim(oDCmPerson:TEXTValue ) as STRING 
Default(@lUnique,false)
	PersonSelect(self,cValue,lUnique)
	RETURN 
ACCESS PostingStatus() CLASS InquirySelection
RETURN SELF:FieldGet(#PostingStatus)

ASSIGN PostingStatus(uValue) CLASS InquirySelection
SELF:FieldPut(#PostingStatus, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS InquirySelection
	//Put your PostInit additions here 
	local OldestYear as date
	self:SetTexts()
	SELF:oOwner:=uExtra[1]
	self:odcfromdate:SelectedDate:=MinDate
	if !Empty(GlBalYears)
		OldestYear:=GlBalYears[Len(GlBalYears),1] 
	else
		OldestYear:=MinDate
	endif
	self:odcfromdate:DateRange:=DateRange{OldestYear,Today()+31}
	SELF:oDCTodate:SelectedDate:=Today()+30
	self:oDCTodate:DateRange:=DateRange{OldestYear,Today()+31}
	self:AmountType:= self:oOwner:TransTypeSelected
	if Posting
		self:oDCPostingStatus:Show()
		self:oCCRadioPost1:Show() 
		self:oCCRadioPost2:Show() 
		self:oCCRadioPost3:Show() 
		self:oCCRadioPost4:Show() 
		self:PostingStatus:=4
		if AScan(aMenu,{|x|x[4]=="PostingBatch"})>0
			self:PostingStatus:=1
		endif
	endif
// 	IF oAcc == NULL_OBJECT
// 		oAcc := Account{}
// 		IF !oAcc:Used
// 			oAcc:=NULL_OBJECT
// 			SELF:EndWindow()
// 		ENDIF
// 		if !Empty(oAcc:Filter).and.!Empty(cAccAlwd) 
// 			oAcc:Filter+=".or.EvAlw(accid)"
// 		endif		
// 	ENDIF
// 	self:cCurr:=sCurr
// 	IF !Empty(SELF:oOwner:FromAccId)
// 		SELF:nAccount:=SELF:oOwner:FromAccId
// 		oAcc:SetOrder("accid")
// 		oAcc:Seek(SELF:nAccount)
// 		self:RegAccount(oAcc,"AccountFrom")
// 	ENDIF
	IF !Empty(self:oOwner:FromAccId)
		self:nAccount:=self:oOwner:FromAccId
		self:RegAccount(SQLSelect{"select a.*,b.category as type from account a,balanceitem b where a.balitemid=b.balitemid and a.accid="+self:nAccount,oConn}, "AccountFrom")
	endif
	IF !Empty(self:oOwner:ToAccNbr)
		self:RegAccount(SQLSelect{"select a.*,b.category as type from account a,balanceitem b where a.balitemid=b.balitemid and accnumber='"+self:oOwner:ToAccNbr+"'",oConn}, "AccountTo")
	ENDIF
	IF !Empty(self:oOwner:PersIdSelected)
		self:mCLNGiver:=self:oOwner:PersIdSelected
		self:RegPerson(SQLSelect{"select * from person where persid="+self:mCLNGiver,oConn})
	ENDIF
	IF !Empty(self:oOwner:StartTransNbr)
		self:FromTransnr:=self:oOwner:StartTransNbr
	ENDIF
	IF !Empty(self:oOwner:EndTransNbr)
		self:ToTransnr:=self:oOwner:EndTransNbr
	ENDIF
	IF !Empty(self:oOwner:DocIdSelected)
		self:DOcID:=self:oOwner:DocIdSelected
	ENDIF
	IF !Empty(self:oOwner:StartDate)
		self:oDCFromdate:SelectedDate:=self:oOwner:StartDate
	ENDIF
	IF !Empty(self:oOwner:EndDate)
		self:oDCTodate:SelectedDate:=self:oOwner:EndDate
	ENDIF
	IF !Empty(self:oOwner:StartAmount)
		self:FromAmount:=self:oOwner:StartAmount
	ENDIF
	IF !Empty(self:oOwner:ToAmount)
		self:ToAmount:=self:oOwner:ToAmount
	ENDIF
	IF !Empty(self:oOwner:DescrpSelected)
		self:oDCDescription:TextValue:=self:oOwner:DescrpSelected
	ENDIF 
	IF !Empty(self:oOwner:ReferenceSelected)
		self:oDCReference:TextValue:=self:oOwner:ReferenceSelected
	ENDIF
	IF !Empty(self:oOwner:PostStatSelected)
		self:PostingStatus:=Val(self:oOwner:PostStatSelected)
	ENDIF
	if Departments
		self:oDCSC_DEP:Show()
		self:oDCFromDep:Show()
		self:oCCFromDepButton:Show()
		self:cCurDep:=iif(Empty(cDepmntIncl),"",Split(cDepmntIncl,",")[1])
		if !Empty(self:oOwner:DepIdSelected)
			self:cCurDep:=self:oOwner:DepIdSelected
		endif
		self:RegDepartment(cCurDep,"From Department")
	endif

	RETURN nil
ACCESS Reference() CLASS InquirySelection
RETURN SELF:FieldGet(#Reference)

ASSIGN Reference(uValue) CLASS InquirySelection
SELF:FieldPut(#Reference, uValue)
RETURN uValue

METHOD ResetButton( ) CLASS InquirySelection
	self:odcfromdate:SelectedDate:=LstYearClosed
	self:oDCTodate:SelectedDate:=Today()+30
	self:RegAccount(,"AccountFrom")
	self:RegAccount(,"AccountTo")
	self:RegDepartment(,"From Department")
	self:RegPerson()
 	self:FromTransnr:=""
	self:ToTransnr:=""
	self:DOcID:=""
 	self:FromAmount:=""
	self:ToAmount:=""
	self:AmountType:="A" 
	self:Description:="" 
	self:Reference:=""
	self:PostingStatus:=4
	self:cFromDepId:=""
	self:oDCFromDep:TEXTValue:=""
	RETURN
ACCESS ToAmount() CLASS InquirySelection
RETURN SELF:FieldGet(#ToAmount)

ASSIGN ToAmount(uValue) CLASS InquirySelection
SELF:FieldPut(#ToAmount, uValue)
RETURN uValue

ACCESS ToTransnr() CLASS InquirySelection
RETURN SELF:FieldGet(#ToTransnr)

ASSIGN ToTransnr(uValue) CLASS InquirySelection
SELF:FieldPut(#ToTransnr, uValue)
RETURN uValue

STATIC DEFINE INQUIRYSELECTION_ACCBUTTON := 102 
STATIC DEFINE INQUIRYSELECTION_ACCBUTTONTO := 104 
STATIC DEFINE INQUIRYSELECTION_AMOUNTTYPE := 113 
STATIC DEFINE INQUIRYSELECTION_CANCELBUTTON := 127 
STATIC DEFINE INQUIRYSELECTION_DESCRIPTION := 118 
STATIC DEFINE INQUIRYSELECTION_DOCID := 117 
STATIC DEFINE INQUIRYSELECTION_FIXEDTEXT1 := 100 
STATIC DEFINE INQUIRYSELECTION_FIXEDTEXT2 := 133 
STATIC DEFINE INQUIRYSELECTION_FIXEDTEXT3 := 107 
STATIC DEFINE INQUIRYSELECTION_FIXEDTEXT4 := 108 
STATIC DEFINE INQUIRYSELECTION_FIXEDTEXT5 := 122 
STATIC DEFINE INQUIRYSELECTION_FIXEDTEXT6 := 123 
STATIC DEFINE INQUIRYSELECTION_FIXEDTEXT7 := 124 
STATIC DEFINE INQUIRYSELECTION_FIXEDTEXT8 := 130 
STATIC DEFINE INQUIRYSELECTION_FIXEDTEXT9 := 131 
STATIC DEFINE INQUIRYSELECTION_FROMAMOUNT := 111 
STATIC DEFINE INQUIRYSELECTION_FROMDATE := 105 
STATIC DEFINE INQUIRYSELECTION_FROMDEP := 141 
STATIC DEFINE INQUIRYSELECTION_FROMDEPBUTTON := 140 
STATIC DEFINE INQUIRYSELECTION_FROMTRANSNR := 109 
STATIC DEFINE INQUIRYSELECTION_MACCOUNT := 101 
STATIC DEFINE INQUIRYSELECTION_MPERSON := 120 
STATIC DEFINE INQUIRYSELECTION_MTOACCOUNT := 103 
STATIC DEFINE INQUIRYSELECTION_OKBUTTON := 125 
STATIC DEFINE INQUIRYSELECTION_PERSONBUTTON := 121 
STATIC DEFINE INQUIRYSELECTION_POSTINGSTATUS := 134 
STATIC DEFINE INQUIRYSELECTION_RADIOBUTTON1 := 114 
STATIC DEFINE INQUIRYSELECTION_RADIOBUTTON2 := 115 
STATIC DEFINE INQUIRYSELECTION_RADIOBUTTON3 := 116 
STATIC DEFINE INQUIRYSELECTION_RADIOPOST1 := 135 
STATIC DEFINE INQUIRYSELECTION_RADIOPOST2 := 136 
STATIC DEFINE INQUIRYSELECTION_RADIOPOST3 := 137 
STATIC DEFINE INQUIRYSELECTION_RADIOPOST4 := 138 
STATIC DEFINE INQUIRYSELECTION_REFERENCE := 119 
STATIC DEFINE INQUIRYSELECTION_RESETBUTTON := 126 
STATIC DEFINE INQUIRYSELECTION_SC_BST := 128 
STATIC DEFINE INQUIRYSELECTION_SC_DEP := 139 
STATIC DEFINE INQUIRYSELECTION_SC_FROM := 129 
STATIC DEFINE INQUIRYSELECTION_SC_REF := 132 
STATIC DEFINE INQUIRYSELECTION_TOAMOUNT := 112 
STATIC DEFINE INQUIRYSELECTION_TODATE := 106 
STATIC DEFINE INQUIRYSELECTION_TOTRANSNR := 110 
CLASS MonthW INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS MonthW

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

    symHlName   := #Month

    cPict       := ""
    cTypeDiag   := ""
    cTypeHelp   := ""
    cLenDiag    := ""
    cLenHelp    := ""
    cMinLenDiag := ""
    cMinLenHelp := ""
    cRangeDiag  := "Month must be between 1 and 12"
    cRangeHelp  := ""
    cValidDiag  := ""
    cValidHelp  := ""
    cReqDiag    := ""
    cReqHelp    := ""

    nMinLen     := 1
    nMinRange   := 1
    nMaxRange   := 12
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Month", "", "" },  "N", 2, 0 )


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
CLASS PaymentDetails INHERIT DataWindowExtra 

	PROTECT oDBACCNUMBER as JAPDataColumn
	PROTECT oDBACCDESC as JAPDataColumn
	PROTECT oDBREFERENCE as JAPDataColumn
	PROTECT oDBDESCRIPTN as JAPDataColumn
	PROTECT oDBORIGINAL as JAPDataColumn
	PROTECT oDBCREFORGN as JAPDataColumn
	PROTECT oDBGC as JAPDataColumn
	PROTECT oDBCURRENCY as JAPDataColumn
	PROTECT oDBCRE as JAPDataColumn
	PROTECT oDCSC_REK AS FIXEDTEXT
	PROTECT oDCSC_OMS AS FIXEDTEXT
	PROTECT oDCSC_ORIGINAL AS FIXEDTEXT
	PROTECT oDCSC_CRE AS FIXEDTEXT
	PROTECT oDCSC_GC AS FIXEDTEXT
	PROTECT oDCSC_REKOMS AS FIXEDTEXT
	PROTECT oDCAccNumber AS SINGLELINEEDIT
	PROTECT oDCDescriptn AS SINGLELINEEDIT
	PROTECT oDCORIGINAL AS SINGLELINEEDIT
	PROTECT oDCCREFORGN AS SINGLELINEEDIT
	PROTECT oDCGC AS SINGLELINEEDIT
	PROTECT oDCAccDesc AS SINGLELINEEDIT
	PROTECT oDCCRE AS SINGLELINEEDIT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	protect oCurr as Currency
  	PROTECT oDBCURRENCY as JapDataColumn
	PROTECT oDBCRE as JapDataColumn 
	
	declare method DebCreProc
RESOURCE PaymentDetails DIALOGEX  38, 35, 497, 178
STYLE	DS_CONTROL|WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Account:", PAYMENTDETAILS_SC_REK, "Static", WS_CHILD, 13, 14, 31, 13
	CONTROL	"Description:", PAYMENTDETAILS_SC_OMS, "Static", WS_CHILD, 13, 29, 39, 12
	CONTROL	"Original:", PAYMENTDETAILS_SC_ORIGINAL, "Static", WS_CHILD, 13, 44, 27, 12
	CONTROL	"Applied:", PAYMENTDETAILS_SC_CRE, "Static", WS_CHILD, 13, 59, 27, 12
	CONTROL	"Assessment:", PAYMENTDETAILS_SC_GC, "Static", WS_CHILD, 13, 73, 41, 13
	CONTROL	"Description:", PAYMENTDETAILS_SC_REKOMS, "Static", WS_CHILD, 13, 88, 39, 12
	CONTROL	"Account", PAYMENTDETAILS_ACCNUMBER, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 65, 14, 90, 13, WS_EX_CLIENTEDGE
	CONTROL	"Description", PAYMENTDETAILS_DESCRIPTN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 65, 29, 201, 12, WS_EX_CLIENTEDGE
	CONTROL	"Original", PAYMENTDETAILS_ORIGINAL, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_DISABLED|WS_BORDER, 65, 44, 111, 12, WS_EX_CLIENTEDGE
	CONTROL	"Applied", PAYMENTDETAILS_CREFORGN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 65, 59, 111, 12, WS_EX_CLIENTEDGE
	CONTROL	"Asmt", PAYMENTDETAILS_GC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 65, 73, 29, 13, WS_EX_CLIENTEDGE
	CONTROL	"Accountname", PAYMENTDETAILS_ACCDESC, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_DISABLED|WS_BORDER, 65, 88, 206, 12, WS_EX_CLIENTEDGE
	CONTROL	"Credit def", PAYMENTDETAILS_CRE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 76, 62, 116, 13, WS_EX_CLIENTEDGE
END

ACCESS AccDesc() CLASS PaymentDetails
RETURN SELF:FieldGet(#AccDesc)

ASSIGN AccDesc(uValue) CLASS PaymentDetails
SELF:FieldPut(#AccDesc, uValue)
RETURN uValue

ACCESS AccNumber() CLASS PaymentDetails
RETURN SELF:FieldGet(#AccNumber)

ASSIGN AccNumber(uValue) CLASS PaymentDetails
SELF:FieldPut(#AccNumber, uValue)
RETURN uValue

method AddCurr() class PaymentDetails
// add/remove  columns for multicurrency:
LOCAL oBrowse:=self:Browser as GeneralBrowser
LOCAL oHm:= self:Owner:Server as TempGift 
local lAdd as logic
AEval(oHm:aMirror,{|x|lAdd:=iif(x[10]==sCurr,iif(x[11],true,lAdd),true) })
if oBrowse:GetColumn(#Currency)==nil 
	if lAdd 
		oBrowse:AddColumn({oDBCURRENCY,oDBCRE},oDBGC) 
		if self:Owner:Size:Width <700
			self:Owner:SetWidth(self:Owner:Size:Width+=100)
		endif
		oBrowse:Refresh() 
		if self:oCurr==null_object
			self:oCurr:=Currency{}
		endif
	endif
elseif !lAdd
	oBrowse:RemoveColumn( oDBCRE)
	oBrowse:RemoveColumn( oDBCURRENCY)
	if self:Owner:Size:Width >=700
		self:Owner:SetWidth(self:Owner:Size:Width-=100)
	endif
	oBrowse:Refresh()
endif
ACCESS CRE() CLASS PaymentDetails
RETURN SELF:FieldGet(#CRE)

ASSIGN CRE(uValue) CLASS PaymentDetails
SELF:FieldPut(#CRE, uValue)
RETURN uValue

ACCESS CREFORGN() CLASS PaymentDetails
RETURN SELF:FieldGet(#CREFORGN)

ASSIGN CREFORGN(uValue) CLASS PaymentDetails
SELF:FieldPut(#CREFORGN, uValue)
RETURN uValue

ACCESS Currency() CLASS PaymentDetails
RETURN SELF:FieldGet(#Currency)

ASSIGN Currency(uValue) CLASS PaymentDetails
SELF:FieldPut(#Currency, uValue)
RETURN uValue

ACCESS Description() CLASS PaymentDetails
RETURN self:FIELDGET(#description)

ASSIGN Description(uValue) CLASS PaymentDetails
self:FIELDPUT(#description, uValue)
RETURN uValue

ACCESS Descriptn() CLASS PaymentDetails
RETURN SELF:FieldGet(#Descriptn)

ASSIGN Descriptn(uValue) CLASS PaymentDetails
SELF:FieldPut(#Descriptn, uValue)
RETURN uValue

ACCESS GC() CLASS PaymentDetails
RETURN SELF:FieldGet(#GC)

ASSIGN GC(uValue) CLASS PaymentDetails
SELF:FieldPut(#GC, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS PaymentDetails 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"PaymentDetails",_GetInst()},iCtlID)

oDCSC_REK := FixedText{SELF,ResourceID{PAYMENTDETAILS_SC_REK,_GetInst()}}
oDCSC_REK:HyperLabel := HyperLabel{#SC_REK,"Account:",NULL_STRING,NULL_STRING}

oDCSC_OMS := FixedText{SELF,ResourceID{PAYMENTDETAILS_SC_OMS,_GetInst()}}
oDCSC_OMS:HyperLabel := HyperLabel{#SC_OMS,"Description:",NULL_STRING,NULL_STRING}

oDCSC_ORIGINAL := FixedText{SELF,ResourceID{PAYMENTDETAILS_SC_ORIGINAL,_GetInst()}}
oDCSC_ORIGINAL:HyperLabel := HyperLabel{#SC_ORIGINAL,"Original:",NULL_STRING,NULL_STRING}

oDCSC_CRE := FixedText{SELF,ResourceID{PAYMENTDETAILS_SC_CRE,_GetInst()}}
oDCSC_CRE:HyperLabel := HyperLabel{#SC_CRE,"Applied:",NULL_STRING,NULL_STRING}

oDCSC_GC := FixedText{SELF,ResourceID{PAYMENTDETAILS_SC_GC,_GetInst()}}
oDCSC_GC:HyperLabel := HyperLabel{#SC_GC,"Assessment:",NULL_STRING,NULL_STRING}

oDCSC_REKOMS := FixedText{SELF,ResourceID{PAYMENTDETAILS_SC_REKOMS,_GetInst()}}
oDCSC_REKOMS:HyperLabel := HyperLabel{#SC_REKOMS,"Description:",NULL_STRING,NULL_STRING}

oDCAccNumber := SingleLineEdit{SELF,ResourceID{PAYMENTDETAILS_ACCNUMBER,_GetInst()}}
oDCAccNumber:FieldSpec := Account_AccNumber{}
oDCAccNumber:HyperLabel := HyperLabel{#AccNumber,"Account","Account of transaction",NULL_STRING}

oDCDescriptn := SingleLineEdit{SELF,ResourceID{PAYMENTDETAILS_DESCRIPTN,_GetInst()}}
oDCDescriptn:FieldSpec := Description{}
oDCDescriptn:HyperLabel := HyperLabel{#Descriptn,"Description",NULL_STRING,"Transaction_OMS"}

oDCORIGINAL := SingleLineEdit{SELF,ResourceID{PAYMENTDETAILS_ORIGINAL,_GetInst()}}
oDCORIGINAL:HyperLabel := HyperLabel{#ORIGINAL,"Original","Amount previous registered",NULL_STRING}
oDCORIGINAL:Ime(#OFF)
oDCORIGINAL:FieldSpec := transaction_CRE{}

oDCCREFORGN := SingleLineEdit{SELF,ResourceID{PAYMENTDETAILS_CREFORGN,_GetInst()}}
oDCCREFORGN:FieldSpec := Transaction_CRE{}
oDCCREFORGN:HyperLabel := HyperLabel{#CREFORGN,"Applied","Amount assigned to destination",NULL_STRING}
oDCCREFORGN:OverWrite := OVERWRITE_ALWAYS
oDCCREFORGN:UseHLforToolTip := True

oDCGC := SingleLineEdit{SELF,ResourceID{PAYMENTDETAILS_GC,_GetInst()}}
oDCGC:FieldSpec := Transaction_GC{}
oDCGC:HyperLabel := HyperLabel{#GC,"Asmt","Assementcode for members","Transaction_GC"}
oDCGC:TooltipText := "Assementcode for members"

oDCAccDesc := SingleLineEdit{SELF,ResourceID{PAYMENTDETAILS_ACCDESC,_GetInst()}}
oDCAccDesc:HyperLabel := HyperLabel{#AccDesc,"Accountname","Name of Account",NULL_STRING}
oDCAccDesc:Ime(#OFF)
oDCAccDesc:FieldSpec := AccDesc{}

oDCCRE := SingleLineEdit{SELF,ResourceID{PAYMENTDETAILS_CRE,_GetInst()}}
oDCCRE:FieldSpec := Transaction_CRE{}
oDCCRE:HyperLabel := HyperLabel{#CRE,"Credit def","credit amount in system currency",NULL_STRING}
oDCCRE:OverWrite := OVERWRITE_ALWAYS
oDCCRE:UseHLforToolTip := True

SELF:Caption := "Input of gifts/payments"
SELF:HyperLabel := HyperLabel{#PaymentDetails,"Input of gifts/payments",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:OwnerAlignment := OA_PWIDTH_PHEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := PaymentBrowser{self}

oDBACCNUMBER := JAPDataColumn{Account_AccNumber{}}
oDBACCNUMBER:Width := 11
oDBACCNUMBER:HyperLabel := oDCACCNUMBER:HyperLabel 
oDBACCNUMBER:Caption := "Account"
self:Browser:AddColumn(oDBACCNUMBER)

oDBACCDESC := JAPDataColumn{AccDesc{}}
oDBACCDESC:Width := 21
oDBACCDESC:HyperLabel := oDCACCDESC:HyperLabel 
oDBACCDESC:Caption := "Accountname"
self:Browser:AddColumn(oDBACCDESC)

oDBREFERENCE := JAPDataColumn{Transaction_REFERENCE{}}
oDBREFERENCE:Width := 10
oDBREFERENCE:HyperLabel := HyperLabel{#Reference,"Reference","for selection or as RPP-destination string",NULL_STRING} 
oDBREFERENCE:Caption := "Reference"
self:Browser:AddColumn(oDBREFERENCE)

oDBDESCRIPTN := JAPDataColumn{Description{}}
oDBDESCRIPTN:Width := 31
oDBDESCRIPTN:HyperLabel := oDCDESCRIPTN:HyperLabel 
oDBDESCRIPTN:Caption := "Description"
self:Browser:AddColumn(oDBDESCRIPTN)

oDBORIGINAL := JAPDataColumn{transaction_CRE{}}
oDBORIGINAL:Width := 12
oDBORIGINAL:HyperLabel := oDCORIGINAL:HyperLabel 
oDBORIGINAL:Caption := "Original"
self:Browser:AddColumn(oDBORIGINAL)

oDBCREFORGN := JAPDataColumn{Transaction_CRE{}}
oDBCREFORGN:Width := 13
oDBCREFORGN:HyperLabel := oDCCREFORGN:HyperLabel 
oDBCREFORGN:Caption := "Applied"
self:Browser:AddColumn(oDBCREFORGN)

oDBGC := JAPDataColumn{Transaction_GC{}}
oDBGC:Width := 6
oDBGC:HyperLabel := oDCGC:HyperLabel 
oDBGC:Caption := "Asmt"
self:Browser:AddColumn(oDBGC)

oDBCURRENCY := JAPDataColumn{Sysparms_SMUNT{}}
oDBCURRENCY:Width := 8
oDBCURRENCY:HyperLabel := HyperLabel{#Currency,"Currency",NULL_STRING,NULL_STRING} 
oDBCURRENCY:Caption := "Currency"
self:Browser:AddColumn(oDBCURRENCY)

oDBCRE := JAPDataColumn{Transaction_CRE{}}
oDBCRE:Width := 9
oDBCRE:HyperLabel := oDCCRE:HyperLabel 
oDBCRE:Caption := "Credit def"
self:Browser:AddColumn(oDBCRE)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS ORIGINAL() CLASS PaymentDetails
RETURN SELF:FieldGet(#ORIGINAL)

ASSIGN ORIGINAL(uValue) CLASS PaymentDetails
SELF:FieldPut(#ORIGINAL, uValue)
RETURN uValue

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS PaymentDetails
	//Put your PostInit additions here
	LOCAL oCol as JapDataColumn
	LOCAL oBrowse:=self:Browser as GeneralBrowser 
self:SetTexts()
	self:server:oBrowse := oBrowse
	IF !(ADMIN=="WO".or.ADMIN=="HO")
		* remove assessment column:
		SELF:Browser:RemoveColumn(oDBGC)
	ENDIF
	oDBCRE:Caption := "Credit "+sCURR
	oDBCRE:SetStandardStyle(gbsReadOnly) 
	oBrowse:RemoveColumn(oDBCURRENCY)
	oBrowse:RemoveColumn(oDBCRE)

	RETURN NIL
method PreInit(oWindow,iCtlID,oServer,uExtra) class PaymentDetails
	//Put your PreInit additions here
	oWindow:use(oWindow:oHlpMut)
	return nil

ACCESS Reference() CLASS PaymentDetails
RETURN SELF:FieldGet(#Reference)

ASSIGN Reference(uValue) CLASS PaymentDetails
SELF:FieldPut(#Reference, uValue)
RETURN uValue

ACCESS REKOMS() CLASS PaymentDetails
RETURN SELF:FieldGet(#REKOMS)

ASSIGN REKOMS(uValue) CLASS PaymentDetails
SELF:FieldPut(#REKOMS, uValue)
RETURN uValue

STATIC DEFINE PAYMENTDETAILS_ACCDESC := 111 
STATIC DEFINE PAYMENTDETAILS_ACCNUMBER := 106 
STATIC DEFINE PAYMENTDETAILS_CRE := 113 
STATIC DEFINE PAYMENTDETAILS_CREFORGN := 109 
STATIC DEFINE PAYMENTDETAILS_CURRENCY := 112 
STATIC DEFINE PAYMENTDETAILS_DESCRIPTN := 107 
STATIC DEFINE PAYMENTDETAILS_GC := 110 
STATIC DEFINE PAYMENTDETAILS_OMS := 107 
STATIC DEFINE PAYMENTDETAILS_ORIGINAL := 108 
STATIC DEFINE PAYMENTDETAILS_REFERENCE := 114 
STATIC DEFINE PAYMENTDETAILS_REKOMS := 111 
STATIC DEFINE PAYMENTDETAILS_SC_CRE := 103 
STATIC DEFINE PAYMENTDETAILS_SC_GC := 104 
STATIC DEFINE PAYMENTDETAILS_SC_OMS := 101 
STATIC DEFINE PAYMENTDETAILS_SC_ORIGINAL := 102 
STATIC DEFINE PAYMENTDETAILS_SC_REK := 100 
STATIC DEFINE PAYMENTDETAILS_SC_REKOMS := 105 
RESOURCE PaymentJournal DIALOGEX  48, 44, 439, 285
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Person:", PAYMENTJOURNAL_SC_CLN, "Static", WS_CHILD, 270, 18, 28, 12
	CONTROL	"Document id:", PAYMENTJOURNAL_SC_BST, "Static", WS_CHILD, 5, 3, 47, 12
	CONTROL	"Date:", PAYMENTJOURNAL_SC_DAT, "Static", WS_CHILD, 100, 2, 20, 12
	CONTROL	"Amount left for recording:", PAYMENTJOURNAL_SC_TOTAL, "Static", WS_CHILD, 7, 270, 83, 12
	CONTROL	"with balance:", PAYMENTJOURNAL_FIXEDTEXT8, "Static", WS_CHILD, 6, 36, 44, 12
	CONTROL	"", PAYMENTJOURNAL_CURTEXT1, "Static", WS_CHILD, 124, 35, 18, 13
	CONTROL	"", PAYMENTJOURNAL_CURTEXT2, "Static", WS_CHILD, 395, 36, 17, 12
	CONTROL	"", PAYMENTJOURNAL_DEBBALANCE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_DISABLED|WS_BORDER, 55, 35, 62, 13, WS_EX_CLIENTEDGE
	CONTROL	"Prior transaction:", PAYMENTJOURNAL_SC_TRANSAKTNR, "Static", WS_CHILD, 344, 3, 56, 13
	CONTROL	"", PAYMENTJOURNAL_MBST, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 56, 2, 39, 12
	CONTROL	"vrijdag 24 september 2010", PAYMENTJOURNAL_MDAT, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 120, 1, 124, 14
	CONTROL	"", PAYMENTJOURNAL_DEBITACCOUNT, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 56, 19, 105, 72
	CONTROL	"", PAYMENTJOURNAL_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 302, 19, 119, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", PAYMENTJOURNAL_PERSONBUTTON, "Button", WS_CHILD, 420, 19, 14, 13
	CONTROL	"", PAYMENTJOURNAL_MDEBAMNTF, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 302, 35, 88, 13, WS_EX_CLIENTEDGE
	CONTROL	"", PAYMENTJOURNAL_PAYMENTDETAILS, "static", WS_TABSTOP|WS_CHILD|WS_BORDER, 4, 72, 428, 180
	CONTROL	"OK", PAYMENTJOURNAL_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 380, 268, 53, 13
	CONTROL	"Cancel", PAYMENTJOURNAL_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 316, 268, 53, 13
	CONTROL	"Telebanking...", PAYMENTJOURNAL_TELEBANKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 316, 254, 53, 13
	CONTROL	"No Earmark...", PAYMENTJOURNAL_NONEARMARKED, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 380, 254, 53, 13
	CONTROL	"Transaktnr:", PAYMENTJOURNAL_MTRANSAKTNR, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_BORDER, 400, 3, 33, 13
	CONTROL	"", PAYMENTJOURNAL_DEBITCREDITTEXT, "Static", WS_CHILD|WS_BORDER, 89, 270, 73, 12, WS_EX_CLIENTEDGE
	CONTROL	"Debit account:", PAYMENTJOURNAL_FIXEDTEXT6, "Static", WS_CHILD, 5, 20, 49, 12
	CONTROL	"Amount received:", PAYMENTJOURNAL_FIXEDTEXT7, "Static", WS_CHILD, 240, 35, 60, 13
	CONTROL	"", PAYMENTJOURNAL_CGIROTELTEXT, "Static", WS_CHILD, 6, 51, 426, 19
END

CLASS PaymentJournal INHERIT DataWindowExtra 

	PROTECT oDCSC_CLN AS FIXEDTEXT
	PROTECT oDCSC_BST AS FIXEDTEXT
	PROTECT oDCSC_DAT AS FIXEDTEXT
	PROTECT oDCSC_Total AS FIXEDTEXT
	PROTECT oDCFixedText8 AS FIXEDTEXT
	PROTECT oDCCurText1 AS FIXEDTEXT
	PROTECT oDCCurText2 AS FIXEDTEXT
	PROTECT oDCDebbalance AS SINGLELINEEDIT
	PROTECT oDCSC_TRANSAKTNR AS FIXEDTEXT
	PROTECT oDCmBST AS SINGLELINEEDIT
	PROTECT oDCmDAT AS DATESTANDARD
	PROTECT oDCDebitAccount AS COMBOBOX
	PROTECT oDCmPerson AS SINGLELINEEDIT
	PROTECT oCCPersonButton AS PUSHBUTTON
	PROTECT oDCmDebAmntF AS MYSINGLEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oCCTelebankButton AS PUSHBUTTON
	PROTECT oCCNonEarmarked AS PUSHBUTTON
	PROTECT oDCmTRANSAKTNR AS SINGLELINEEDIT
	PROTECT oDCDebitCreditText AS FIXEDTEXT
	PROTECT oDCFixedText6 AS FIXEDTEXT
	PROTECT oDCFixedText7 AS FIXEDTEXT
	PROTECT oDCcGirotelText AS FIXEDTEXT
	PROTECT oSFPaymentDetails AS PaymentDetails

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)

	instance mBst 
	instance DebitAccount 
	instance mPerson 
	instance mDebAmntF 
	instance mTRANSAKTNR 
	instance DebBalance
	instance CurText1,CurText2 
	PROTECT oTmt as TeleMut
	EXPORT lTeleBank as LOGIC
	PROTECT lEarmarking as LOGIC

	EXPORT fTotal as FLOAT
	PROTECT mCLNGiver as STRING
	PROTECT cGiverName, cOrigName as STRING
	EXPORT lMemberGiver as LOGIC
	PROTECT DebAccNbr,DebAccId, DebCln, DebCurrency as STRING
	PROTECT DefBest, DefOms, DefGc, DefNbr, DefMlcd, DefCur,DefType as STRING,DefOvrd, DefMulti as logic
	EXPORT m51_agift,m51_apost as int
	PROTECT m51_assrec as int
	PROTECT cBankPreSet as STRING  // default debit accountname
	EXPORT GiftsAutomatic,DueAutomatic as LOGIC
	EXPORT CurDebAmnt, mDebAmnt as FLOAT
	EXPORT AutoRec as LOGIC// Automatic recording
	EXPORT Recognised as LOGIC //rekeninghouder bij TeleBanking gevonden
	EXPORT kind as STRING
	EXPORT aApplied as ARRAY // array with applied recnrs of server
	EXPORT cAccFilter,cDestFilter as STRING
	EXPORT pFilter,pDebFilter as _CODEBLOCK
	PROTECT nEarmarkTrans,nEarmarkSeqnr as int
	PROTECT AutoCollect, Acceptgiro as LOGIC 
	protect oCurr as Currency
	protect lStop as LOGIC
	export oHlpMut as TempGift
	declare method FillTeleBanking, InitGifts,AccntProc,AssignTo,Totalise, ValStore,ValidateTempGift
method AddCur(0 class PaymentJournal
self:oSFPaymentDetails:AddCurr()
return
method bankanalyze() class PaymentJournal
	// analyze bankaccount belonging to current debaccount 
	local oSel as SQLSelect
	self:DefBest := ''
	self:DefOms := ""
	self:DefNbr:=""
	self:DefGc := ""
	self:DefMlcd:=""
	self:DefOvrd:=False
	self:DefCur:=sCurr
	self:DefMulti:=false 
	oSel:=SQLSelect{"select giftsall,openall,SINGLEDST,FGMLCODES,SYSCODOVER,i.category as acctype,a.description,a.accnumber,a.CURRENCY,a.multcurr,m.persid "+;
		"from bankaccount b left join account a on (a.accid=b.singledst) right join balanceitem i on (i.balitemid=a.balitemid)  left join member m on (m.accid=a.accid) "+;
		"where b.accid="+self:DebAccId,oConn}
	if oSel:reccount>0  
		self:GiftsAutomatic:=iif(oSel:GIFTSALL=1,true,false)
		self:DueAutomatic:=iif(oSel:OPENALL=1,true,false)
		IF MultiDest
			self:DefBest := iif(Empty(oSel:SINGLEDST),'',Str(oSel:SINGLEDST,-1))
			* Check if it concerns a bank account with a single destination:
			// 	if DefBest # oSel:SINGLEDST
			if !Empty(oSel:Description)
				// 				self:DefBest := Str(oSel:AccID,-1)   
				self:DefOms := oSel:Description
				self:DefNbr:=oSel:ACCNUMBER
				IF !Empty(oSel:persid)
					self:DefGc := "AG"
				ENDIF
				self:DefCur:=oSel:Currency
				self:DefMulti:=iif(oSel:MULTCURR=1,true,false) 
				self:DefMlcd:=oSel:FGMLCODES
				self:DefOvrd:=iif(oSel:SYSCODOVER="O",true,false)
				self:DefType:=oSel:acctype
			endif
		endif
	ENDIF


METHOD CancelButton( ) CLASS PaymentJournal
LOCAL oBox AS WarningBox
LOCAL oHm as TempGift

IF SELF:lEarMarking
	self:oTrans:GoTo(nEarmarkTrans)
	self:ReSet()
	self:cGiverName:=""
	self:mCLNGiver:=""
	IF !SELF:NonEarmarked()
		SELF:oCCNonEarmarked:Show()
		IF TeleBanking .or. AutoGiro
			oCCTeleBankButton:Show()
		ENDIF
	ENDIF		
ELSE		
*	IF (Len(SELF:server:aMirror) > 0 .or. !SELF:fTotal == 0)
	IF !self:lTeleBank.and.AScanExact(self:Server:Amirror,{|x| !x[3]==0})>0   // iets toegewezen?
		oBox := WarningBox{SELF, "Cancel of Transactions", "Do you really want to discard changes?"}
		oBox:Type := BUTTONYESNO
		IF (oBox:Show() = BOXREPLYYES)
			self:lStop:=true
		ENDIF
	ELSE
		self:lStop:=true
	ENDIF
	IF self:lStop
	    IF self:lTeleBank
	    	self:oTmt:SkipMut()
	    	self:lStop:=false
			self:ReSet()
			self:cGiverName:=""
			self:mCLNGiver:=""
			IF self:oTmt:NextTeleGift()
				self:FillTeleBanking()
				IF self:AutoRec
					SELF:OkButton()
				ENDIF
			ELSE
				SELF:EndGiro()
			ENDIF
		ELSE
			SELF:EndWindow()
	   ENDIF
	ENDIF
ENDIF
RETURN
METHOD Close( oEvent ) CLASS PaymentJournal
	LOCAL oServer AS FileSpec

// 	IF !SELF:Owner:oPersbw == NULL_OBJECT
// 		SELF:Owner:oPersbw:EndWindow()
// 	ENDIF
// 	IF !SELF:Owner:oAccbw == NULL_OBJECT
// 		SELF:Owner:oAccBw:EndWindow()
// 	ENDIF

//	cServer:=SELF:Server:FileSpec:FullPath
IF !SELF:Server==NULL_OBJECT
	oServer:=Filespec{SELF:Server:FileSpec:FullPath}
	IF SELF:Server:Used
		SELF:Server:Close()
	ENDIF
	//FErase(cServer)
	oServer:DELETE()
	IF oServer:Find()
		FErase(oServer:FullPath)
	ENDIF
	oServer:Extension:="fpt"
	IF oServer:Find()
		oServer:DELETE() 
		if oServer:Find()
			FErase(oServer:FullPath)
		endif
	ENDIF
ENDIF
IF self:lTeleBank .and. !self:oTmt==null_object
	self:oTmt:Close()
	self:oTmt:=null_object
ENDIF
//Erase(cServer)  */
	SELF:oSFPaymentDetails:Destroy()
  	SELF:Destroy()
	// force garbage collection
	*CollectForced()

	RETURN SUPER:Close(oEvent)
	
ACCESS Debbalance() CLASS PaymentJournal
RETURN SELF:FieldGet(#Debbalance)

ASSIGN Debbalance(uValue) CLASS PaymentJournal
SELF:FieldPut(#Debbalance, uValue)
RETURN uValue

ACCESS DebitAccount() CLASS PaymentJournal
RETURN SELF:FieldGet(#DebitAccount)

ASSIGN DebitAccount(uValue) CLASS PaymentJournal
SELF:FieldPut(#DebitAccount, uValue)
RETURN uValue

METHOD DebSelect() CLASS PaymentJournal
	*	Selection of bank accounts as candidate debitaccount for payments/gifts
	LOCAL aDebAccs := {} AS ARRAY
	local oBank,oAcc as SQLSelect
	oBank:=SQLSelect{"select b.usedforgifts,a.currency,a.description,a.accid,a.accnumber from bankaccount b, account a where a.accid=b.accid and b.telebankng=0 and a.active=1", oConn}
	oBank:Execute() 
	do WHILE !oBank:EOF
		AAdd(aDebAccs,{oBank:Description,oBank:AccID})
		IF Empty(cBankPreSet) .and.oBank:usedforgifts=1
			cBankPreSet := oBank:Description
			self:DebAccNbr:=oBank:ACCNUMBER
			self:DebAccId:=Str(oBank:AccID,-1) 
			self:DebCurrency:=oBank:CURRENCY
			self:ShowDebBal()
		ENDIF                                       
		oBank:Skip()
	ENDDO
	IF Empty(cBankPreSet).and.oBank:reccount>0
		oBank:GoBottom()
		cBankPreSet := oBank:Description
		self:DebAccNbr:=oBank:ACCNUMBER
		self:DebAccId:=Str(oBank:AccID,-1) 
		self:DebCurrency:=oBank:CURRENCY
		self:ShowDebBal()
	ENDIF
	IF !Empty(SKAS) 
		oAcc:=SQLSelect{"select a.currency,a.description,a.accid,a.accnumber from account a where active=1 and accid="+SKAS,oConn}
		if oAcc:reccount>0
			AAdd(aDebAccs,{oAcc:Description,SKAS})
			IF Empty(cBankPreSet)
				cBankPreSet := oAcc:Description
				self:DebAccNbr:= oAcc:ACCNUMBER
				self:DebAccId:=SKAS
				self:DebCurrency:=oAcc:CURRENCY
				self:ShowDebBal()
			ENDIF
		endif
	ENDIF
	AAdd(aDebAccs,{"<Other>","00000"}) 
	RETURN aDebAccs
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS PaymentJournal
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !IsNil(oControl:Value)
		IF oControl:Name == "MPERSON".and.!AllTrim(oControl:Value)==AllTrim(cGiverName)
			IF Empty(oControl:Value) && leeg gemaakt?
				SELF:mCLNGiver :=  ""
				SELF:cGiverName := ""
				SELF:oDCmPerson:TEXTValue := ""
			ELSE
				self:cOrigName:=self:cGiverName
           	cGiverName:=AllTrim(oControl:VALUE)
				if !cGiverName==cOrigName
					self:PersonButton(true,,false,PersonContainer{}) 
				else
					self:PersonButton(true,,,PersonContainer{})
				endif				 
			ENDIF
		ELSEIF oControl:Name == "MDEBAMNTF".and.!Val(oControl:TEXTValue)==self:CurDebAmnt 
			self:mDebAmntF:=oControl:Value
			if self:DebCurrency==sCurr
				self:mDebAmnt := oControl:Value
			else
				self:mDebAmnt:=Round( self:oCurr:GetRoe(self:DebCurrency,self:mDAT)*self:mDebAmntF,DecAantal)
			endif
			self:CurDebAmnt := oControl:Value 
			SELF:oSFPaymentDetails:Browser:SuspendUpdate()
			self:AssignTo()
			self:Totalise(false,true)
			SELF:oSFPaymentDetails:Browser:RestoreUpdate()
			SELF:oSFPaymentDetails:Browser:Refresh()
		ENDIF
	ENDIF
		
	RETURN NIL
METHOD EndGiro() CLASS PaymentJournal
		oTmt:Close()
		SELF:oDCmBST:Enable()
		SELF:oDCmDat:Enable()
		SELF:oDCDebitAccount:Enable()
		self:oDCmDebAmntF:Enable()
		SELF:oDCmPerson:Enable()
		SELF:oCCNonEarmarked:Show()
		lTeleBank:=FALSE
		Autorec:=FALSE
		SELF:mDat:=Today()
		SELF:mBst:=" "
		SELF:mDebAmnt:=0
		self:mDebAmntF:=0
		self:oDCmPerson:TEXTValue :=" "
		SELF:mCLNGiver :=  " "
		SELF:cGiverName := " "
		SELF:oDCcGirotelText:Caption:=" "
		SELF:osfpaymentdetails:Browser:Refresh()
*		SELF:Append()
		oDCDebitAccount:SetFocus()
		oDCDebitAccount:CurrentItemNo := ;
		oDCDebitAccount:FindItem(cBankPreSet,FALSE)
		SELF:ShowDebBal()
RETURN
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS PaymentJournal 
LOCAL DIM aBrushes[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"PaymentJournal",_GetInst()},iCtlID)

aBrushes[1] := Brush{Color{COLORWHITE}}

oDCSC_CLN := FixedText{SELF,ResourceID{PAYMENTJOURNAL_SC_CLN,_GetInst()}}
oDCSC_CLN:HyperLabel := HyperLabel{#SC_CLN,"Person:",NULL_STRING,NULL_STRING}

oDCSC_BST := FixedText{SELF,ResourceID{PAYMENTJOURNAL_SC_BST,_GetInst()}}
oDCSC_BST:HyperLabel := HyperLabel{#SC_BST,"Document id:",NULL_STRING,NULL_STRING}

oDCSC_DAT := FixedText{SELF,ResourceID{PAYMENTJOURNAL_SC_DAT,_GetInst()}}
oDCSC_DAT:HyperLabel := HyperLabel{#SC_DAT,"Date:",NULL_STRING,NULL_STRING}

oDCSC_Total := FixedText{SELF,ResourceID{PAYMENTJOURNAL_SC_TOTAL,_GetInst()}}
oDCSC_Total:HyperLabel := HyperLabel{#SC_Total,"Amount left for recording:",NULL_STRING,NULL_STRING}
oDCSC_Total:OwnerAlignment := OA_Y

oDCFixedText8 := FixedText{SELF,ResourceID{PAYMENTJOURNAL_FIXEDTEXT8,_GetInst()}}
oDCFixedText8:HyperLabel := HyperLabel{#FixedText8,"with balance:",NULL_STRING,NULL_STRING}

oDCCurText1 := FixedText{SELF,ResourceID{PAYMENTJOURNAL_CURTEXT1,_GetInst()}}
oDCCurText1:HyperLabel := HyperLabel{#CurText1,NULL_STRING,NULL_STRING,NULL_STRING}

oDCCurText2 := FixedText{SELF,ResourceID{PAYMENTJOURNAL_CURTEXT2,_GetInst()}}
oDCCurText2:HyperLabel := HyperLabel{#CurText2,NULL_STRING,NULL_STRING,NULL_STRING}

oDCDebbalance := SingleLineEdit{SELF,ResourceID{PAYMENTJOURNAL_DEBBALANCE,_GetInst()}}
oDCDebbalance:HyperLabel := HyperLabel{#Debbalance,NULL_STRING,NULL_STRING,NULL_STRING}
oDCDebbalance:FieldSpec := MBalance_DEB{}

oDCSC_TRANSAKTNR := FixedText{SELF,ResourceID{PAYMENTJOURNAL_SC_TRANSAKTNR,_GetInst()}}
oDCSC_TRANSAKTNR:HyperLabel := HyperLabel{#SC_TRANSAKTNR,"Prior transaction:",NULL_STRING,NULL_STRING}

oDCmBST := SingleLineEdit{SELF,ResourceID{PAYMENTJOURNAL_MBST,_GetInst()}}
oDCmBST:FieldSpec := Transaction_BST{}
oDCmBST:HyperLabel := HyperLabel{#mBST,NULL_STRING,NULL_STRING,"Transaction_BST"}

oDCmDAT := DateStandard{SELF,ResourceID{PAYMENTJOURNAL_MDAT,_GetInst()}}
oDCmDAT:HyperLabel := HyperLabel{#mDAT,NULL_STRING,NULL_STRING,NULL_STRING}

oDCDebitAccount := combobox{SELF,ResourceID{PAYMENTJOURNAL_DEBITACCOUNT,_GetInst()}}
oDCDebitAccount:FillUsing(Self:DebSelect( ))
oDCDebitAccount:HyperLabel := HyperLabel{#DebitAccount,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmPerson := SingleLineEdit{SELF,ResourceID{PAYMENTJOURNAL_MPERSON,_GetInst()}}
oDCmPerson:HyperLabel := HyperLabel{#mPerson,NULL_STRING,"Person paying the amount","HELP_CLN"}
oDCmPerson:Picture := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
oDCmPerson:TooltipText := "Name, Zip or Bank#"

oCCPersonButton := PushButton{SELF,ResourceID{PAYMENTJOURNAL_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v","Browse in persons",NULL_STRING}
oCCPersonButton:TooltipText := "Browse in Persons"

oDCmDebAmntF := mySingleEdit{SELF,ResourceID{PAYMENTJOURNAL_MDEBAMNTF,_GetInst()}}
oDCmDebAmntF:FieldSpec := TRANSACTION_DEB{}
oDCmDebAmntF:HyperLabel := HyperLabel{#mDebAmntF,NULL_STRING,"Amount received",NULL_STRING}
oDCmDebAmntF:UseHLforToolTip := True

oCCOKButton := PushButton{SELF,ResourceID{PAYMENTJOURNAL_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}
oCCOKButton:OwnerAlignment := OA_Y

oCCCancelButton := PushButton{SELF,ResourceID{PAYMENTJOURNAL_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}
oCCCancelButton:OwnerAlignment := OA_Y

oCCTelebankButton := PushButton{SELF,ResourceID{PAYMENTJOURNAL_TELEBANKBUTTON,_GetInst()}}
oCCTelebankButton:HyperLabel := HyperLabel{#TelebankButton,"Telebanking...","Processing of telebanking transactions",NULL_STRING}
oCCTelebankButton:TooltipText := "Proces Telebanking transactions"
oCCTelebankButton:OwnerAlignment := OA_Y

oCCNonEarmarked := PushButton{SELF,ResourceID{PAYMENTJOURNAL_NONEARMARKED,_GetInst()}}
oCCNonEarmarked:HyperLabel := HyperLabel{#NonEarmarked,"No Earmark...",NULL_STRING,NULL_STRING}
oCCNonEarmarked:TooltipText := "Allotting of non-earmarked gifts"
oCCNonEarmarked:OwnerAlignment := OA_Y

oDCmTRANSAKTNR := SingleLineEdit{SELF,ResourceID{PAYMENTJOURNAL_MTRANSAKTNR,_GetInst()}}
oDCmTRANSAKTNR:FieldSpec := Transaction_TRANSAKTNR{}
oDCmTRANSAKTNR:HyperLabel := HyperLabel{#mTRANSAKTNR,"Transaktnr:",NULL_STRING,"Transaction_TRANSAKTNR"}

oDCDebitCreditText := FixedText{SELF,ResourceID{PAYMENTJOURNAL_DEBITCREDITTEXT,_GetInst()}}
oDCDebitCreditText:HyperLabel := HyperLabel{#DebitCreditText,NULL_STRING,NULL_STRING,NULL_STRING}
oDCDebitCreditText:TextColor := Color{COLORBLUE}
oDCDebitCreditText:BackGround := aBrushes[1]
oDCDebitCreditText:OwnerAlignment := OA_Y

oDCFixedText6 := FixedText{SELF,ResourceID{PAYMENTJOURNAL_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"Debit account:",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{PAYMENTJOURNAL_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Amount received:",NULL_STRING,NULL_STRING}

oDCcGirotelText := FixedText{SELF,ResourceID{PAYMENTJOURNAL_CGIROTELTEXT,_GetInst()}}
oDCcGirotelText:HyperLabel := HyperLabel{#cGirotelText,NULL_STRING,NULL_STRING,NULL_STRING}

SELF:Caption := "Gifts/Payments bookkeeping"
SELF:HyperLabel := HyperLabel{#PaymentJournal,"Gifts/Payments bookkeeping",NULL_STRING,NULL_STRING}
SELF:Menu := WOBrowserMENU{}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFPaymentDetails := PaymentDetails{SELF,PAYMENTJOURNAL_PAYMENTDETAILS}
oSFPaymentDetails:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD ListBoxSelect(oControlEvent) CLASS PaymentJournal
	LOCAL oControl as Control
	LOCAL uValue as USUAL
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	SUPER:ListBoxSelect(oControlEvent)
	//Put your changes here
	IF oControlEvent:Name == "DEBITACCOUNT"
		GiftsAutomatic:=FALSE
		DueAutomatic:=FALSE
		IF Empty(oControlEvent:Control:VALUE)
// 			AccountSelect(self,"","DEBITACCOUNT",FALSE,cAccFilter,,oAcc)
			AccountSelect(self,"","DEBITACCOUNT",FALSE,cAccFilter)
			self:ShowDebBal()
			IF MultiDest
				self:DefBest := ""
				self:DefOms := ""
				self:DefNbr:=""
				self:DefGc := ""
			endif
		ELSE
			self:DebAccId := AllTrim(Transform(oControlEvent:Control:value,""))
			self:ShowDebBal()
		   self:lMemberGiver := FALSE
		   self:bankanalyze()
		ENDIF
	ENDIF
	RETURN nil
ACCESS mBST() CLASS PaymentJournal
RETURN SELF:FieldGet(#mBST)

ASSIGN mBST(uValue) CLASS PaymentJournal
SELF:FieldPut(#mBST, uValue)
RETURN uValue

ACCESS mDAT() CLASS PaymentJournal
RETURN SELF:oDCmDat:SelectedDate
ASSIGN mDAT(uValue) CLASS PaymentJournal
RETURN SELF:oDCmDat:SelectedDate:=uValue
ACCESS mDebAmntF() CLASS PaymentJournal
RETURN SELF:FieldGet(#mDebAmntF)

ASSIGN mDebAmntF(uValue) CLASS PaymentJournal
SELF:FieldPut(#mDebAmntF, uValue)
RETURN uValue

ACCESS mPerson() CLASS PaymentJournal
RETURN SELF:FieldGet(#mPerson)

ASSIGN mPerson(uValue) CLASS PaymentJournal
SELF:FieldPut(#mPerson, uValue)
RETURN uValue

ACCESS mTRANSAKTNR() CLASS PaymentJournal
RETURN SELF:FieldGet(#mTRANSAKTNR)

ASSIGN mTRANSAKTNR(uValue) CLASS PaymentJournal
SELF:FieldPut(#mTRANSAKTNR, uValue)
RETURN uValue

METHOD NonEarmarked( ) CLASS PaymentJournal
	LOCAL oHm as TempGift
	LOCAL oTransEM,oAcc as SQLSelect
	local oPersCnt as PersonContainer

	IF !self:lEarmarking
		oAcc:=SQLSelect{"select accnumber,description from account where accid="+sproj,oConn}
		if oAcc:RecCount>0
			self:DebAccId:=sproj
			self:DebAccNbr:=oAcc:ACCNUMBER
			self:oDCDebitAccount:CurrentText  := oAcc:Description
			self:ShowDebBal()
		ENDIF
	endif
	* Search for next non-earmarked gift (BFM=O):
	oTransEM:=SQLSelect{"select t.* from transaction t where accid="+sproj+" and bfm='O' and cre>deb order by transid,seqnr limit 1",oConn}
	IF oTransEM:RecCount<1
		(WarningBox{self,oLan:WGet("Recording Gifts"),self:oLan:WGet("No "+iif(self:lEarmarking,"more ","")+"non-designated gifts found")}):Show()
		if self:lEarmarking
			self:lEarmarking:=false
			self:lEarmarking:=FALSE
			self:oDCmBST:Enable()
			self:oDCmDat:Enable()
			self:oDCDebitAccount:Enable()
			self:oDCmDebAmntF:Enable()
			self:oDCmPerson:Enable()
			self:mDAT := Today()
			mBst := ""
			mDebAmnt := 0
			mDebAmntF := 0
			oDCDebitAccount:CurrentItemNo := ;
				oDCDebitAccount:FindItem(cBankPreSet,FALSE)
			self:mCLNGiver :=  ""
			self:cGiverName := ""
			self:oDCmPerson:TEXTValue := ""
			self:InitGifts() 
		endif
		RETURN FALSE
	ENDIF
	self:lEarmarking:=true
	self:nEarmarkTrans:=oTransEM:TransId 
	self:nEarmarkSeqnr:=oTransEM:Seqnr
	self:oCCNonEarmarked:Hide()
	self:oCCTeleBankButton:Hide()
	self:mDebAmnt :=oTransEM:CRE - oTransEM:DEB

	self:mDebAmntF := oTransEM:CREFORGN - oTransEM:DEBFORGN
	if Empty(self:mDebAmntF)
		self:mDebAmntF:=self:mDebAmnt
	endif
	self:oDCmDebAmntF:Value:= self:mDebAmntF

	self:DebCurrency:=oTransEM:Currency
	if Empty(self:DebCurrency)
		self:DebCurrency:=sCurr
	endif
	oHm := SELF:Server
	*		oHm:zap()
	SELF:append()
	oHm:DESCRIPTN:=oLan:Get("Allotted non-designated gift",,"!")
	oHm:CRE:= mDebAmnt
	oHm:CREFORGN:=mDebAmnt 
	oHm:Currency:=sCurr
// 	oHm:GC:="OT"
	SELF:mDAT := oTransEM:Dat
	self:mBst := oTransEM:docid
	oPersCnt:=PersonContainer{}
	if !Empty(oTransEM:persid)
		self:mCLNGiver:=Str(oTransEM:persid,-1)
	endif
	oPersCnt:persid:=self:mCLNGiver
	self:RegPerson(oPersCnt)
	SELF:oDCmBST:Disable()
	SELF:oDCmDat:Disable()
	SELF:oDCDebitAccount:Disable()
	self:oDCmDebAmntF:Disable()
	SELF:oDCmPerson:Disable()
	RETURN true
	
METHOD OKButton( ) CLASS PaymentJournal
	LOCAL lOk AS LOGIC
	LOCAL oHm as TempGift
	LOCAL ThisRec AS INT
	LOCAL CurValue AS ARRAY   // 1: nw value, 2: old value, 3: name of columnfield

	lOk := SELF:ValStore()
	IF !lOK
		RETURN NIL
	ENDIF	
	IF lEarmarking
		IF !SELF:NonEarmarked()
			SELF:oCCNonEarmarked:Show()
			IF TeleBanking .or. AutoGiro
				oCCTeleBankButton:Show()
			ENDIF
		ENDIF		
	ENDIF
	
	DO WHILE lTeleBank
		oTmt:CloseMut(SELF:server)
		IF oTmt:NextTeleGift()
			self:FillTeleBanking()
			IF AutoRec
				IF !self:ValStore()
					RETURN NIL
				ENDIF
			ELSE	
				EXIT
			ENDIF
		ELSE
			SELF:EndGiro()
		ENDIF
	ENDDO 
	RETURN nil
METHOD PersonButton(lUnique,cHeading, WithCln,oPersCnt) CLASS PaymentJournal
//METHOD PersonButton(lUnique:=false as logic,cHeading:="Giver/Payer " as string, WithCln:=true as logic,oPersCnt as PersonContainer) as void pascal CLASS PaymentJournal
	LOCAL cValue := AllTrim(oDCmPerson:TEXTValue ) as STRING 
	local lRes as logic
	Default(@lUnique,false)
	Default(@cHeading,"Giver/Payer ")
	Default(@WithCln,true)
	Default(@oPersCnt,PersonContainer{})
	if !Empty(self:mCLNGiver).and.WithCln .and. !Val(mCLNGiver)=0
		oPersCnt:persid:=self:mCLNGiver
	else
		oPersCnt:persid:=""
	endif
	PersonSelect(self,cValue,lUnique,,cHeading,oPersCnt)
	RETURN 
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS PaymentJournal
	//Put your PostInit additions here
	LOCAL bRek as STRING
	local oSel as SQLSelect
	self:SetTexts()

	oCurr:=Currency{}  
	self:Server:oLan:=self:oLan
	self:Server:oBrowse := self:oSFPaymentDetails:Browser
	self:oDCDebitAccount:SetFocus()
	self:oDCDebitAccount:CurrentItemNo := self:oDCDebitAccount:FindItem(cBankPreSet,FALSE)
	self:mDebAmntF:=0
	self:mDebAmnt:=0
	IF MultiDest
		self:bankanalyze()
	else
		* Check in case of home front system if there is only one destination:
		oSel:=SQLSelect{"select a.accid,a.description,a.accnumber,a.CURRENCY,a.multcurr,b.category as acctype,m.persid from balanceitem b, account a left join member on (a.accid=m.accid) "+;
			" where a.giftalwd=1 and a.balitemid=b.balitemid",oConn}
		if oSel:reccount=1
			self:DefBest := Str(oSel:AccID,-1)
			self:DefOms := oSel:Description
			self:DefNbr:=oSel:ACCNUMBER
			self:DefCur:=oSel:Currency
			self:DefMulti:=iif(oSel:MULTCURR=1,true,false) 
			self:DefType:=oSel:acctype
			IF !Empty(oSel:persid)
				self:DefGc := "AG"
			ENDIF
		ELSE
			MultiDest:=true
		ENDIF
	endif
	self:cAccFilter:=""
	IF !Empty(SKAP)
		self:cAccFilter:=if(Empty(self:cAccFilter),"",self:cAccFilter+',')+SKAP
	ENDIF
	IF !Empty(sam)
		self:cAccFilter:=if(Empty(self:cAccFilter),"",self:cAccFilter+',')+sam
	ENDIF
	IF !Empty(SHB)
		self:cAccFilter:=if(Empty(self:cAccFilter),"",self:cAccFilter+',')+SHB
	ENDIF
	self:cDestFilter:=self:cAccFilter
	if SQLSelect{"select accid from bankaccount where Telebankng=1 and usedforgifts=1",oConn}:reccount>0
		TeleBanking := true 
	else
		TeleBanking := FALSE
		if !AutoGiro
			oCCTeleBankButton:Hide()
		endif
	ENDIF
	
	oSel:=SQLSelect{"select accid from bankaccount where Telebankng=1",oConn}
	DO WHILE oSel:reccount>0
		self:cAccFilter:=if(Empty(self:cAccFilter),"",self:cAccFilter+',')+Str(oSel:AccID,-1)
		oSel:Skip()
	ENDDO
	if !Empty(self:cAccFilter)
		self:cAccFilter:="a.active=1 and a.accid not in ("+self:cAccFilter+")"
	else
		self:cAccFilter:="a.active=1"
	endif
	oSel:=SQLSelect{"select accid from bankaccount",oConn}
	DO WHILE !oSel:EOF
		self:cDestFilter:=if(Empty(self:cDestFilter),"",self:cDestFilter+',')+Str(oSel:AccID,-1)
		oSel:Skip()
	ENDDO)
	*cDestFilter:=cDestFilter+" .and. GiftAlwd"
	if !Empty(self:cDestFilter)
		self:cDestFilter:="a.active=1 and a.accid not in ("+self:cDestFilter+")" 
	else
		self:cDestFilter:="a.active=1"
	endif
	
	IF !Empty(SPROJ)
		* check if there are non earmarked gifts: 
		if SQLSelect{"select accid from transaction where accid="+sproj+" and bfm='O' limit 1",oConn}:RecCount>0
			oCCNonEarmarked:Show()
		endif
	endif
	IF AScan(aMenu,{|x| x[4]=="TransactionEdit"})=0
		self:oCCOKButton:Hide() 
		self:oCCTeleBankButton:Hide()
	ENDIF


	RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class PaymentJournal
	//Put your PreInit additions here
	GetHelpDir()
	self:oHlpMut:=TempGift{HelpDir+"\HG"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE,DBREADWRITE}
	return nil
METHOD ShowDebBal() CLASS PaymentJournal 
	local lSucc as logic
	local oSel as SQLSelect
	local omBal as Balances
	oSel:=SQLSelect{"select accnumber,accid,currency,b.category from account a, balanceitem b where accid="+self:DebAccId+" and b.balitemid=a.balitemid",oConn}
	if oSel:reccount>0
		self:DebAccNbr:=oSel:ACCNUMBER 
		self:DebCurrency:=oSel:CURRENCY
	ENDIF
	// if !self:DebCurrency==sCurr .and. self:oCurr==null_object
	// 	self:oCurr:=Currency{}
	// endif
	omBal:=Balances{}
	omBal:GetBalance( self:DebAccId,oSel:category,,,self:DebCurrency)

	self:DebBalance:=omBal:per_debF-omBal:per_creF 
	self:oDCDebbalance:Value:=self:DebBalance
	self:oDCCurText1:Value :=self:DebCurrency 
	self:oDCCurText2:Value:=self:DebCurrency 
	// determine single destination:

	RETURN
METHOD TeleBankButton( ) CLASS PaymentJournal
	LOCAL lSuccess AS LOGIC
	IF !oTmt==null_object
		oTmt:Close()
	endif
	oTmt:=TeleMut{true,self} 
	if Empty(oTmt:m57_gironr)
		lTeleBank:=false
		return nil
	endif

// 	IF oPersBank==NULL_OBJECT
// 		oPersBank:=PersonBank{}
// 		lSuccess:=oPersBank:SetOrder("GIROPERS")
// 	ENDIF
// 	IF !oPersBank:Used
// 		oPersBank:=NULL_OBJECT
// 		SELF:EndWindow()
// 	ENDIF

	IF oTmt:NextTeleGift()
		oCCTeleBankButton:Hide()
		oCCNonEarmarked:Hide()
		self:lTeleBank := true
		self:FillTeleBanking()
		IF SELF:AutoRec
			SELF:OKButton()
		ENDIF
	ELSE
		self:lTeleBank := FALSE
		(WarningBox{SELF,"Recording Gifts","No Telebanking Gifts found"}):Show()
	ENDIF
STATIC DEFINE PAYMENTJOURNAL_CANCELBUTTON := 117 
STATIC DEFINE PAYMENTJOURNAL_CGIROTELTEXT := 124 
STATIC DEFINE PAYMENTJOURNAL_CURTEXT1 := 105 
STATIC DEFINE PAYMENTJOURNAL_CURTEXT2 := 106 
STATIC DEFINE PAYMENTJOURNAL_DEBBALANCE := 107 
STATIC DEFINE PAYMENTJOURNAL_DEBITACCOUNT := 111 
STATIC DEFINE PAYMENTJOURNAL_DEBITCREDITTEXT := 121 
STATIC DEFINE PAYMENTJOURNAL_FIXEDTEXT6 := 122 
STATIC DEFINE PAYMENTJOURNAL_FIXEDTEXT7 := 123 
STATIC DEFINE PAYMENTJOURNAL_FIXEDTEXT8 := 104 
STATIC DEFINE PAYMENTJOURNAL_MBST := 109 
STATIC DEFINE PAYMENTJOURNAL_MDAT := 110 
STATIC DEFINE PAYMENTJOURNAL_MDEBAMNTF := 114 
STATIC DEFINE PAYMENTJOURNAL_MPERSON := 112 
STATIC DEFINE PAYMENTJOURNAL_MTRANSAKTNR := 120 
STATIC DEFINE PAYMENTJOURNAL_NONEARMARKED := 119 
STATIC DEFINE PAYMENTJOURNAL_OKBUTTON := 116 
STATIC DEFINE PAYMENTJOURNAL_PAYMENTDETAILS := 115 
STATIC DEFINE PAYMENTJOURNAL_PERSONBUTTON := 113 
STATIC DEFINE PAYMENTJOURNAL_SC_BST := 101 
STATIC DEFINE PAYMENTJOURNAL_SC_CLN := 100 
STATIC DEFINE PAYMENTJOURNAL_SC_DAT := 102 
STATIC DEFINE PAYMENTJOURNAL_SC_TOTAL := 103 
STATIC DEFINE PAYMENTJOURNAL_SC_TRANSAKTNR := 108 
STATIC DEFINE PAYMENTJOURNAL_TELEBANKBUTTON := 118 
STATIC DEFINE PAYMENTJOURNALNW_CANCELBUTTON := 114 
STATIC DEFINE PAYMENTJOURNALNW_CGIROTELTEXT := 102 
STATIC DEFINE PAYMENTJOURNALNW_DEBBALANCE := 122 
STATIC DEFINE PAYMENTJOURNALNW_DEBITACCOUNT := 108 
STATIC DEFINE PAYMENTJOURNALNW_DEBITCREDITTEXT := 118 
STATIC DEFINE PAYMENTJOURNALNW_FIXEDTEXT6 := 119 
STATIC DEFINE PAYMENTJOURNALNW_FIXEDTEXT7 := 120 
STATIC DEFINE PAYMENTJOURNALNW_FIXEDTEXT8 := 121 
STATIC DEFINE PAYMENTJOURNALNW_GIROTELBUTTON := 115 
STATIC DEFINE PAYMENTJOURNALNW_MBST := 101 
STATIC DEFINE PAYMENTJOURNALNW_MDAT := 107 
STATIC DEFINE PAYMENTJOURNALNW_MDEBAMNT := 111 
STATIC DEFINE PAYMENTJOURNALNW_MPERSON := 109 
STATIC DEFINE PAYMENTJOURNALNW_MTRANSAKTNR := 117 
STATIC DEFINE PAYMENTJOURNALNW_NONEARMARKED := 116 
STATIC DEFINE PAYMENTJOURNALNW_OKBUTTON := 113 
STATIC DEFINE PAYMENTJOURNALNW_PAYMENTDETAILS := 112 
STATIC DEFINE PAYMENTJOURNALNW_PERSONBUTTON := 110 
STATIC DEFINE PAYMENTJOURNALNW_SC_BST := 100 
STATIC DEFINE PAYMENTJOURNALNW_SC_CLN := 103 
STATIC DEFINE PAYMENTJOURNALNW_SC_DAT := 104 
STATIC DEFINE PAYMENTJOURNALNW_SC_TOTAL := 105 
STATIC DEFINE PAYMENTJOURNALNW_SC_TRANSAKTNR := 106 
method _PaymentJournal(iCtlID) CLASS StandardWycWindow
local oServer as DBSERVEREXTRA 
oServer:= TempGift{HelpDir+"\HP"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
(PaymentJournal{self,iCtlID,oServer}):show()
return 
 
CLASS TransactionMonth INHERIT DataWindowMine 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCFixedText5 AS FIXEDTEXT
	PROTECT oDCFromAccount AS SINGLELINEEDIT
	PROTECT oCCFromAccButton AS PUSHBUTTON
	PROTECT oDCToAccount AS SINGLELINEEDIT
	PROTECT oCCToAccButton AS PUSHBUTTON
	PROTECT oDCFromYear AS SINGLELINEEDIT
	PROTECT oDCFromMonth AS SINGLELINEEDIT
	PROTECT oDCToYear AS SINGLELINEEDIT
	PROTECT oDCToMonth AS SINGLELINEEDIT
	PROTECT oDCBeginReport AS CHECKBOX
	PROTECT oDCSkipInactive AS CHECKBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCSimpleStmnt AS CHECKBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	EXPORT nFromAccount  AS STRING
	EXPORT cFromAccName AS STRING
	EXPORT nToAccount  AS STRING
	EXPORT cToAccName AS STRING
*	EXPORT nFromYear  AS INT
	EXPORT cFromMonth AS INT
	EXPORT nToYear  AS INT
	EXPORT cToMonth AS INT
	EXPORT oAcc,oBal,oTrans,oSys  as SQLSelect
	PROTECT oAccStm AS AccountStatements

PROTECT cFileTrans AS STRING
RESOURCE TransactionMonth DIALOGEX  13, 12, 255, 150
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"From accountnumber:", TRANSACTIONMONTH_FIXEDTEXT1, "Static", WS_CHILD, 16, 22, 71, 12
	CONTROL	"To accountnumber:", TRANSACTIONMONTH_FIXEDTEXT2, "Static", WS_CHILD, 16, 40, 66, 13
	CONTROL	"From month:", TRANSACTIONMONTH_FIXEDTEXT3, "Static", WS_CHILD, 16, 59, 53, 12
	CONTROL	"Till month:", TRANSACTIONMONTH_FIXEDTEXT5, "Static", WS_CHILD, 16, 77, 53, 12
	CONTROL	"", TRANSACTIONMONTH_FROMACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 96, 22, 58, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TRANSACTIONMONTH_FROMACCBUTTON, "Button", WS_CHILD, 152, 22, 14, 12
	CONTROL	"", TRANSACTIONMONTH_TOACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 96, 40, 58, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", TRANSACTIONMONTH_TOACCBUTTON, "Button", WS_CHILD, 152, 40, 16, 12
	CONTROL	"", TRANSACTIONMONTH_FROMYEAR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 96, 59, 34, 12, WS_EX_CLIENTEDGE
	CONTROL	"", TRANSACTIONMONTH_FROMMONTH, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 136, 59, 19, 12, WS_EX_CLIENTEDGE
	CONTROL	"", TRANSACTIONMONTH_TOYEAR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 96, 77, 34, 12, WS_EX_CLIENTEDGE
	CONTROL	"", TRANSACTIONMONTH_TOMONTH, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 136, 77, 19, 12, WS_EX_CLIENTEDGE
	CONTROL	"Reduced pageskips", TRANSACTIONMONTH_BEGINREPORT, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 96, 99, 80, 11
	CONTROL	"Skip inactive accounts", TRANSACTIONMONTH_SKIPINACTIVE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 96, 114, 92, 11
	CONTROL	"OK", TRANSACTIONMONTH_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 192, 22, 53, 12
	CONTROL	"Cancel", TRANSACTIONMONTH_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 192, 40, 53, 12
	CONTROL	"Simplified report", TRANSACTIONMONTH_SIMPLESTMNT, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 96, 129, 80, 11
END

ACCESS BeginReport() CLASS TransactionMonth
RETURN SELF:FieldGet(#BeginReport)

ASSIGN BeginReport(uValue) CLASS TransactionMonth
SELF:FieldPut(#BeginReport, uValue)
RETURN uValue

METHOD CancelButton( ) CLASS TransactionMonth
	LOCAL a AS INT
	a:=1
	SELF:EndWindow()
	RETURN NIL
METHOD Close(oEvent) CLASS TransactionMonth
*	SUPER:Close(oEvent)
	//Put your changes here
IF !oLan==NULL_OBJECT
	IF oLan:Used
		oLan:Close()
	ENDIF
	oLan:=NULL_OBJECT
ENDIF
IF !oAcc==NULL_OBJECT
	IF oAcc:Used
		oAcc:Close()
	ENDIF
	oAcc:=NULL_OBJECT
ENDIF
IF !oTrans==NULL_OBJECT
	IF oTrans:Used
		oTrans:Close()
	ENDIF
	oTrans:=NULL_OBJECT
ENDIF
IF !oSys==NULL_OBJECT
	IF oSys:Used
		oSys:Close()
	ENDIF
	oSys:=NULL_OBJECT
ENDIF
IF !oBal==NULL_OBJECT
	IF oBal:Used
		oBal:Close()
	ENDIF
	oBal:=NULL_OBJECT
ENDIF
SELF:oAccStm:=NULL_OBJECT
SELF:Destroy()
	// force garbage collection
	*CollectForced()

	RETURN SUPER:Close(oEvent)
*RETURN NIL
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS TransactionMonth
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus
		IF oControl:Name == "FROMACCOUNT"
			IF !Upper(AllTrim(oControl:Value))==Upper(AllTrim(cFromAccName))
				cFromAccName:=AllTrim(oControl:Value)
				SELF:FromAccButton(TRUE)				
*				AccountSelect(SELF,AllTrim(oControl:Value),"FromAccount",TRUE)
			ENDIF
		ELSEIF oControl:Name == "TOACCOUNT"
			IF !Upper(AllTrim(oControl:Value))==Upper(AllTrim(cToAccName))
				cToAccName:=AllTrim(oControl:Value)
				SELF:ToAccButton(TRUE)
*				AccountSelect(SELF,AllTrim(oControl:Value),"ToAccount",TRUE)
			ENDIF

		ENDIF
	ENDIF
	RETURN NIL
METHOD FromAccButton(lUnique ) CLASS TransactionMonth
	Default(@lUnique,FALSE)
// 	AccountSelect(SELF,AllTrim(oDCFromAccount:TEXTValue ),"FromAccount",lUnique,,,oAcc)
	AccountSelect(self,AllTrim(oDCFromAccount:TEXTValue ),"FromAccount",lUnique,,,)
	RETURN true
ACCESS FromAccount() CLASS TransactionMonth
RETURN SELF:FieldGet(#FromAccount)

ASSIGN FromAccount(uValue) CLASS TransactionMonth
SELF:FieldPut(#FromAccount, uValue)
RETURN uValue

ACCESS FromMonth() CLASS TransactionMonth
RETURN SELF:FieldGet(#FromMonth)

ASSIGN FromMonth(uValue) CLASS TransactionMonth
SELF:FieldPut(#FromMonth, uValue)
RETURN uValue

ACCESS FromYear() CLASS TransactionMonth
RETURN SELF:FieldGet(#FromYear)

ASSIGN FromYear(uValue) CLASS TransactionMonth
SELF:FieldPut(#FromYear, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TransactionMonth 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TransactionMonth",_GetInst()},iCtlID)

oDCFixedText1 := FixedText{SELF,ResourceID{TRANSACTIONMONTH_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"From accountnumber:",NULL_STRING,NULL_STRING}

oDCFixedText2 := FixedText{SELF,ResourceID{TRANSACTIONMONTH_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"To accountnumber:",NULL_STRING,NULL_STRING}

oDCFixedText3 := FixedText{SELF,ResourceID{TRANSACTIONMONTH_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"From month:",NULL_STRING,NULL_STRING}

oDCFixedText5 := FixedText{SELF,ResourceID{TRANSACTIONMONTH_FIXEDTEXT5,_GetInst()}}
oDCFixedText5:HyperLabel := HyperLabel{#FixedText5,"Till month:",NULL_STRING,NULL_STRING}

oDCFromAccount := SingleLineEdit{SELF,ResourceID{TRANSACTIONMONTH_FROMACCOUNT,_GetInst()}}
oDCFromAccount:HyperLabel := HyperLabel{#FromAccount,NULL_STRING,NULL_STRING,NULL_STRING}
oDCFromAccount:Picture := "XXXXXXXXXXXXXXXXXXXX"

oCCFromAccButton := PushButton{SELF,ResourceID{TRANSACTIONMONTH_FROMACCBUTTON,_GetInst()}}
oCCFromAccButton:HyperLabel := HyperLabel{#FromAccButton,"v","Browse in accounts",NULL_STRING}
oCCFromAccButton:TooltipText := "Browse in accounts"

oDCToAccount := SingleLineEdit{SELF,ResourceID{TRANSACTIONMONTH_TOACCOUNT,_GetInst()}}
oDCToAccount:Picture := "XXXXXXXXXXXXXXXXXXXX"
oDCToAccount:HyperLabel := HyperLabel{#ToAccount,NULL_STRING,NULL_STRING,NULL_STRING}

oCCToAccButton := PushButton{SELF,ResourceID{TRANSACTIONMONTH_TOACCBUTTON,_GetInst()}}
oCCToAccButton:HyperLabel := HyperLabel{#ToAccButton,"v",NULL_STRING,NULL_STRING}
oCCToAccButton:TooltipText := "Browse in Accounts"

oDCFromYear := SingleLineEdit{SELF,ResourceID{TRANSACTIONMONTH_FROMYEAR,_GetInst()}}
oDCFromYear:HyperLabel := HyperLabel{#FromYear,NULL_STRING,NULL_STRING,NULL_STRING}
oDCFromYear:FieldSpec := YEARW{}
oDCFromYear:Picture := "9999"

oDCFromMonth := SingleLineEdit{SELF,ResourceID{TRANSACTIONMONTH_FROMMONTH,_GetInst()}}
oDCFromMonth:Picture := "99"
oDCFromMonth:FieldSpec := MONTHW{}
oDCFromMonth:HyperLabel := HyperLabel{#FromMonth,NULL_STRING,NULL_STRING,NULL_STRING}

oDCToYear := SingleLineEdit{SELF,ResourceID{TRANSACTIONMONTH_TOYEAR,_GetInst()}}
oDCToYear:HyperLabel := HyperLabel{#ToYear,NULL_STRING,NULL_STRING,NULL_STRING}
oDCToYear:FieldSpec := YEARW{}
oDCToYear:Picture := "9999"

oDCToMonth := SingleLineEdit{SELF,ResourceID{TRANSACTIONMONTH_TOMONTH,_GetInst()}}
oDCToMonth:Picture := "99"
oDCToMonth:FieldSpec := MONTHW{}
oDCToMonth:HyperLabel := HyperLabel{#ToMonth,NULL_STRING,NULL_STRING,NULL_STRING}

oDCBeginReport := CheckBox{SELF,ResourceID{TRANSACTIONMONTH_BEGINREPORT,_GetInst()}}
oDCBeginReport:HyperLabel := HyperLabel{#BeginReport,"Reduced pageskips",NULL_STRING,NULL_STRING}

oDCSkipInactive := CheckBox{SELF,ResourceID{TRANSACTIONMONTH_SKIPINACTIVE,_GetInst()}}
oDCSkipInactive:HyperLabel := HyperLabel{#SkipInactive,"Skip inactive accounts",NULL_STRING,NULL_STRING}
oDCSkipInactive:TooltipText := "Show only income/expense year to date"

oCCOKButton := PushButton{SELF,ResourceID{TRANSACTIONMONTH_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{TRANSACTIONMONTH_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCSimpleStmnt := CheckBox{SELF,ResourceID{TRANSACTIONMONTH_SIMPLESTMNT,_GetInst()}}
oDCSimpleStmnt:HyperLabel := HyperLabel{#SimpleStmnt,"Simplified report",NULL_STRING,NULL_STRING}
oDCSimpleStmnt:TooltipText := "Show only transaction/month balance"

SELF:Caption := "Account statements per month"
SELF:HyperLabel := HyperLabel{#TransactionMonth,"Account statements per month",NULL_STRING,NULL_STRING}
SELF:EnableStatusBar(True)
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD OKButton( ) CLASS TransactionMonth
	LOCAL nAcc as STRING
	LOCAL nRow, nPage as int
	LOCAL oReport as PrintDialog

	// 	IF ValidateControls( SELF, SELF:AControls )
	self:FromYear:=oDCFromYear:Value
	self:FromMonth:=oDCFromMonth:Value
	self:ToYear:=oDCToYear:Value
	self:ToMonth:=oDCToMonth:Value
	IF self:FromYear*100+self:FromMonth > self:ToYear*100+self:ToMonth
		(ErrorBox{self,self:oLan:WGet("To Month must be behind From month")}):show()
	ELSEIF Empty(self:nFromAccount)
		(ErrorBox{self,self:oLan:WGet("Specify From Account")}):show()
	ELSE
		IF Empty(self:nToAccount)
			self:nToAccount := self:nFromAccount
		ELSEIF self:nToAccount < self:nFromAccount
			nAcc := self:nToAccount
			self:nToAccount := self:nFromAccount
			self:nFromAccount := nAcc
		ENDIF
		if self:nFromAccount==self:nToAccount
			self:SkipInactive:=false
		endif
		oReport := PrintDialog{oParent,self:oLan:RGet("Account statements per month"),,97,,"xls"}
		// 			oReport := PrintDialog{oParent,self:oLan:WGet("Account statements per month"),,97}
		oReport:show()
		IF oReport:lPrintOk
			IF oAccStm==null_object
				oAccStm:=AccountStatements{,self:SkipInactive}
			ENDIF
			self:oAccStm:BeginReport:=self:BeginReport
			self:oAccStm:oReport:=oReport 
			self:oAccStm:SkipInactive:=self:SkipInactive
			self:oAccStm:lMinimalInfo:=self:oDCSimpleStmnt:Checked
			self:oAccStm:MonthPrint(self:nFromAccount,self:nToAccount,self:FromYear,self:FromMonth,self:ToYear,self:ToMonth,@nRow,@nPage,,self:oLan)				
			oReport:prstart()
			oReport:prstop()
		ENDIF
		IF Empty(self:ToAccount)
			self:nToAccount:=" "
		ENDIF
	ENDIF
	// 	ENDIF
	RETURN nil
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TransactionMonth
	//Put your PostInit additions here
self:SetTexts()
	self:FromYear := Year(Today()-28)
    self:FromMonth := 1
	self:ToYear := Year(Today())
    self:ToMonth := Month(Today())

	RETURN NIL
ACCESS SimpleStmnt() CLASS TransactionMonth
RETURN SELF:FieldGet(#SimpleStmnt)

ASSIGN SimpleStmnt(uValue) CLASS TransactionMonth
SELF:FieldPut(#SimpleStmnt, uValue)
RETURN uValue

ACCESS SkipInactive() CLASS TransactionMonth
RETURN SELF:FieldGet(#SkipInactive)

ASSIGN SkipInactive(uValue) CLASS TransactionMonth
SELF:FieldPut(#SkipInactive, uValue)
RETURN uValue

METHOD ToAccButton(lUnique ) CLASS TransactionMonth
	Default(@lUnique,FALSE)
// 	AccountSelect(SELF,AllTrim(oDCToAccount:TEXTValue ),"ToAccount",lUnique,,,oAcc)
	AccountSelect(self,AllTrim(oDCToAccount:TEXTValue ),"ToAccount",lUnique,,,)
	RETURN true
ACCESS ToAccount() CLASS TransactionMonth
RETURN SELF:FieldGet(#ToAccount)

ASSIGN ToAccount(uValue) CLASS TransactionMonth
SELF:FieldPut(#ToAccount, uValue)
RETURN uValue

ACCESS ToMonth() CLASS TransactionMonth
RETURN SELF:FieldGet(#ToMonth)

ASSIGN ToMonth(uValue) CLASS TransactionMonth
SELF:FieldPut(#ToMonth, uValue)
RETURN uValue

ACCESS ToYear() CLASS TransactionMonth
RETURN SELF:FieldGet(#ToYear)

ASSIGN ToYear(uValue) CLASS TransactionMonth
SELF:FieldPut(#ToYear, uValue)
RETURN uValue

STATIC DEFINE TRANSACTIONMONTH_BEGINREPORT := 112 
STATIC DEFINE TRANSACTIONMONTH_CANCELBUTTON := 115 
STATIC DEFINE TRANSACTIONMONTH_FIXEDTEXT1 := 100 
STATIC DEFINE TRANSACTIONMONTH_FIXEDTEXT2 := 101 
STATIC DEFINE TRANSACTIONMONTH_FIXEDTEXT3 := 102 
STATIC DEFINE TRANSACTIONMONTH_FIXEDTEXT5 := 103 
STATIC DEFINE TRANSACTIONMONTH_FROMACCBUTTON := 105 
STATIC DEFINE TRANSACTIONMONTH_FROMACCOUNT := 104 
STATIC DEFINE TRANSACTIONMONTH_FROMMONTH := 109 
STATIC DEFINE TRANSACTIONMONTH_FROMYEAR := 108 
STATIC DEFINE TRANSACTIONMONTH_OKBUTTON := 114 
STATIC DEFINE TRANSACTIONMONTH_SIMPLESTMNT := 116 
STATIC DEFINE TRANSACTIONMONTH_SKIPINACTIVE := 113 
STATIC DEFINE TRANSACTIONMONTH_TOACCBUTTON := 107 
STATIC DEFINE TRANSACTIONMONTH_TOACCOUNT := 106 
STATIC DEFINE TRANSACTIONMONTH_TOMONTH := 111 
STATIC DEFINE TRANSACTIONMONTH_TOYEAR := 110 
STATIC DEFINE TRANSACTMONTH_CANCELBUTTON := 110 
STATIC DEFINE TRANSACTMONTH_FIXEDTEXT1 := 100 
STATIC DEFINE TRANSACTMONTH_FIXEDTEXT2 := 101 
STATIC DEFINE TRANSACTMONTH_FIXEDTEXT3 := 102 
STATIC DEFINE TRANSACTMONTH_FIXEDTEXT5 := 103 
STATIC DEFINE TRANSACTMONTH_FROMACCOUNT := 111 
STATIC DEFINE TRANSACTMONTH_FROMMONTH := 107 
STATIC DEFINE TRANSACTMONTH_FROMYEAR := 105 
STATIC DEFINE TRANSACTMONTH_OKBUTTON := 109 
STATIC DEFINE TRANSACTMONTH_TOACCOUNT := 104 
STATIC DEFINE TRANSACTMONTH_TOMONTH := 108 
STATIC DEFINE TRANSACTMONTH_TOYEAR := 106 
CLASS TransInquiry INHERIT DataWindowExtra 

	PROTECT oCCSelectionButton AS PUSHBUTTON
	PROTECT oCCEditButton AS PUSHBUTTON
	PROTECT oCCReadyButton AS PUSHBUTTON
	PROTECT oCCPostButton AS PUSHBUTTON
	PROTECT oCCTransferButton AS PUSHBUTTON
	PROTECT oCCExportButton AS PUSHBUTTON
	PROTECT oDCLstTxt1 AS FIXEDTEXT
	PROTECT oDCNbrTrans AS SINGLELINEEDIT
	PROTECT oCCFindButton AS PUSHBUTTON
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oDCLstTxt2 AS FIXEDTEXT
	PROTECT oDCFixedText4 AS FIXEDTEXT
	PROTECT oSFTransInquiry_DETAIL AS TransInquiry_DETAIL

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	EXPORT oSel AS InquirySelection
	EXPORT FromAccId, PersIdSelected, DocIdSelected, StartTransNbr, EndTransNbr,FromAccNbr,ToAccNbr, DescrpSelected,ReferenceSelected,DepIdSelected  as STRING
	EXPORT StartDate, EndDate as date
 	EXPORT StartAmount, ToAmount as STRING
 	EXPORT TransTypeSelected:="A" as STRING 
 	EXPORT PostStatSelected as string
	EXPORT m54_selectTxt AS STRING
	EXPORT oHm as TempTrans
 	PROTECT oGen AS General_Journal
 	EXPORT cTransferAcc AS STRING
*	Data for GetTransFerAcc:
	EXPORT cTransferAccName, cBal, cDep, cDepOrg, cBalOrg, cSoortOrg,cSoort, cCurr, cOrigAccFltr  as STRING
	EXPORT NoUpdate as LOGIC
	eXPORT aTeleAcc:={} as array 
	EXPORT cAccFilter as string
   declare method Post 
   
   export cWhereBase,cWhereSpec, cFrom,cFields,cOrder,cSelectStmnt as string
   export oTrans,oMyTrans as SQLSelect
   protect lsttrnr as int
   export lShowFind:=true as logic

RESOURCE TransInquiry DIALOGEX  25, 34, 523, 302
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TRANSINQUIRY_TRANSINQUIRY_DETAIL, "static", WS_CHILD|WS_BORDER, 4, 22, 509, 262
	CONTROL	"Advanced Find", TRANSINQUIRY_SELECTIONBUTTON, "Button", WS_TABSTOP|WS_CHILD, 456, 3, 57, 13
	CONTROL	"Details", TRANSINQUIRY_EDITBUTTON, "Button", WS_TABSTOP|WS_CHILD, 462, 288, 54, 12
	CONTROL	"Ready Batch", TRANSINQUIRY_READYBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 400, 288, 53, 12
	CONTROL	"Post Batch", TRANSINQUIRY_POSTBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 400, 288, 53, 12
	CONTROL	"Transfer", TRANSINQUIRY_TRANSFERBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 62, 288, 53, 12
	CONTROL	"Export", TRANSINQUIRY_EXPORTBUTTON, "Button", WS_TABSTOP|WS_CHILD, 6, 288, 54, 12
	CONTROL	"Last ", TRANSINQUIRY_LSTTXT1, "Static", SS_CENTERIMAGE|WS_CHILD, 4, 3, 24, 13
	CONTROL	"", TRANSINQUIRY_NBRTRANS, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 28, 3, 36, 13, WS_EX_CLIENTEDGE
	CONTROL	"Show", TRANSINQUIRY_FINDBUTTON, "Button", WS_TABSTOP|WS_CHILD, 120, 3, 53, 13
	CONTROL	"Found:", TRANSINQUIRY_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 204, 3, 27, 13
	CONTROL	"", TRANSINQUIRY_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 232, 3, 36, 13
	CONTROL	"transactions", TRANSINQUIRY_LSTTXT2, "Static", SS_CENTERIMAGE|WS_CHILD, 68, 3, 53, 13
	CONTROL	"lines", TRANSINQUIRY_FIXEDTEXT4, "Static", SS_CENTERIMAGE|WS_CHILD, 272, 3, 53, 13
END

METHOD Close(oEvent) CLASS TransInquiry
LOCAL cServer AS STRING
LOCAL oServer AS TransHistory
LOCAL oFs AS FileSpec
IF !oHm==NULL_OBJECT
	IF oHm:Used
		oHm:Close()
	ENDIF
	oHm:=NULL_OBJECT
ENDIF
IF !SELF:oGen==NULL_OBJECT
	SELF:oGen:Close()
	SELF:oGen:Destroy()
ENDIF
*SUPER:Close(oEvent)
	//Put your changes here
SELF:oSFTransInquiry_DETAIL:Close()
SELF:oSFTransInquiry_DETAIL:Destroy()
SELF:Destroy()
	// force garbage collection
	*CollectForced()

	RETURN SUPER:Close(oEvent)
*	RETURN NIL
METHOD EditButton( ) CLASS TransInquiry
	LOCAL cTransnr AS STRING
	LOCAL OrigPerson,OrigBst, OrigUser as STRING,Origdat as date, OrigPost as int
	LOCAL cSavFilter, cSavOrder as STRING, nSavRec as int 
	IF SELF:NoUpdate
		RETURN
	ENDIF 
// 	ticks1:=GetTickCountLow()
// 	LogEvent(,"t1:"+Str(ticks1,-1))
*    oTrans:=SELF:Server 
if self:Server:EOF .or. self:Server:RecCount<1
	return
endif
	cTransnr:=Str(self:Server:TransId,-1)
	OrigBst:=self:Server:docid
	Origdat:=SELF:Server:Dat
	OrigUser:=self:Server:USERID 
	OrigPost:=self:Server:PostStatus
   GetHelpDir()
	self:oHm := TempTrans{HelpDir+"\HU"+StrTran(Time(),":")+".DBF",DBEXCLUSIVE}
//	self:oHm := TempTrans{}
	IF !self:oHm:Used
		RETURN
	ENDIF
	* Fill rows of TempTrans with transaction:
	self:oMyTrans:=SQLSelect{"select t.*,a.description as accdesc,a.accnumber,a.balitemid,a.multcurr,b.category as type,m.persid as persidmbr,"+;
	SQLAccType()+" as accounttype from balanceitem b,account a left join member m on (m.accid=a.accid)  , transaction t left join person p on (p.persid=t.persid) "+;
	" where a.accid=t.accid and b.balitemid=a.balitemid and t.TransId="+cTransnr,oConn}
	if self:oMyTrans:RecCount<1
		LogEvent(,self:oMyTrans:sqlstring,"logsql")
	endif 
	self:oHm:aMirror:={}
	DO WHILE self:oMyTrans:RecCount>0 .and.!self:oMyTrans:EOF
		self:oHm:append()
		self:oHm:AccID := Str(self:oMyTrans:AccID,-1)
		self:oHm:AccDesc:=self:oMyTrans:AccDesc
		self:oHm:DESCRIPTN := AllTrim(self:oMyTrans:Description)
		self:oHm:ACCNUMBER := self:oMyTrans:ACCNUMBER
		self:oHm:deb := self:oMyTrans:deb
		self:oHm:cre :=  self:oMyTrans:cre
		if Empty( self:oMyTrans:Currency)
			self:oHm:Currency:=sCurr
		else 
			self:oHm:Currency:= self:oMyTrans:Currency
		endif
		if self:oHm:Currency==sCurr
			self:oHm:debforgn := self:oMyTrans:deb
			self:oHm:creforgn :=  self:oMyTrans:cre
		else
			self:oHm:debforgn := self:oMyTrans:debforgn
			self:oHm:creforgn :=  self:oMyTrans:creforgn
		endif
		self:oHm:GC := self:oMyTrans:GC
		self:oHm:BFM:= self:oMyTrans:BFM
		self:oHm:FROMRPP:=iif(self:oMyTrans:FROMRPP==1,true,false)
		self:oHm:lFromRPP:=iif(self:oMyTrans:FROMRPP==1,true,false)
		self:oHm:OPP:=self:oMyTrans:OPP
		self:oHm:PPDEST := self:oMyTrans:PPDEST
		self:oHm:REFERENCE:=self:oMyTrans:REFERENCE
		self:oHm:SEQNR := self:oMyTrans:SEQNR
		self:oHm:KIND := self:oMyTrans:accounttype
		IF !Empty(self:oMyTrans:persid)
			OrigPerson := Str(self:oMyTrans:persid,-1)
		ENDIF 
		self:oHm:PostStatus:=self:oMyTrans:PostStatus

		* Add to mirror:
		&& mirror-array of TempTrans with values {accID,deb,cre,gc,category,recno,Trans:RecNbr,accnumber,Rekoms,balitemid,curr,multicur,debforgn,creforgn,PPDEST, description,persid,type}
		AAdd(self:oHm:aMirror,{AllTrim(self:oHm:AccID),self:oHm:deb,self:oHm:cre,self:oHm:GC,self:oHm:KIND,self:oHm:RecNo,self:oHm:RECNBR,AllTrim(self:oHm:ACCNUMBER),AllTrim(self:oHm:AccDesc),Str(self:oMyTrans:balitemid,-1),self:oHm:Currency,iif(self:oMyTrans:MULTCURR=1,true,false),self:oHm:debforgn,self:oHm:creforgn,AllTrim(self:oHm:REFERENCE),self:oHm:DESCRIPTN,iif(Empty(self:oMyTrans:persid),iif(Empty(self:oMyTrans:persidmbr),"",Str(self:oMyTrans:persidmbr,-1)),Str(self:oMyTrans:persid,-1)),self:oMyTrans:TYPE})
		self:oMyTrans:Skip()
	ENDDO
	oGen:= General_Journal{self:Owner,,self:oHm,true}
	oGen:FillRecord(cTransnr,self:oSFTransInquiry_DETAIL:Browser,OrigPerson,Origdat,OrigBst,OrigUser,OrigPost,self)
	oGen:AddCur()

	oGen:Show()
RETURN nil	
METHOD ExportButton( ) CLASS TransInquiry 
	// export select transaction to file and send - when required - that file by email to headquarters
	LOCAL oTrans as SQLSelect
	LOCAL oTrans2 as SQLSelect
	LOCAL oSys as SQLSelect
	LOCAL lSucc AS LOGIC
	LOCAL nCurRec AS STRING
	LOCAL cFilename AS STRING
	LOCAL oMapi AS MAPISession
	LOCAL oRecip,oRecip2 AS MAPIRecip
	LOCAL cExportMail AS STRING
	LOCAL lSent AS LOGIC
	LOCAL uRet AS USUAL
	LOCAL DecSep AS STRING
	LOCAL cTransnr AS STRING
	LOCAL oWarn AS warningbox
	LOCAL lAppend:=true  as LOGIC
	LOCAL ToFileFS AS Filespec
	LOCAL ptrHandle
	LOCAL cLine AS STRING
	LOCAL cDelim:=Listseparator AS STRING
	LOCAL lMail as LOGIC 
	local aTrans:={} as array 
	local j as int
	local cTrans,cSelectSt as string

	oTrans:=SELF:Server
	oTrans:GoTop()
	IF oTrans:EoF
		RETURN
	ENDIF
	IF (TextBox{self,"Export of transactions to file/mail","Should all "+Str(oTrans:RecCount,-1)+" selected transactions be exported?",BUTTONOKAYCANCEL+BOXICONQUESTIONMARK}):Show()==BOXREPLYCANCEL
		RETURN
	ENDIF
	IF Empty(sentity)
		(errorbox{SELF:OWNER,'You have to specify the entitycode in the system parameters with the name of your department'}):Show()
		RETURN
	ENDIF
	IF (Textbox{SELF:Owner,"Export of transactions to file/mail","Should selected transactions send by mail to the headquarters?",BUTTONYESNO+BOXICONQUESTIONMARK}):Show()==BOXREPLYYES
		lMail:=TRUE
	ENDIF 

	SELF:StatusMessage("Exporting data, moment please")
	SELF:Pointer := Pointer{POINTERHOURGLASS}
	
	* Datafile construction:
	DecSep:=CHR(SetDecimalSep())
	cFileName := AllTrim(sentity)+DToS(Today())+'.CSV'
	ToFileFS:=AskFileName(self,cFilename,"Export transactions to file","*.CSV","Comma separated file",@lAppend) 
	if !Empty(ToFileFS)
		cFilename:=ToFileFS:FullPath 
		IF lAppend
			ptrHandle := FOpen(cFilename,FO_READWRITE	)
		ELSE
			ptrHandle:=MakeFile(self,@cFilename,"Exporting to spreadsheet")
		ENDIF
		IF !ptrHandle = F_ERROR .and. !ptrHandle==NIL
			IF !lAppend
				* Write heading TO file:
				FWriteLine(ptrHandle,'"TRANSDATE"'+cDelim+'"DOCID"'+cDelim+'"TRANSACTNR"'+cDelim+'"ACCOUNTNR"'+cDelim+'"ACCNAME"'+cDelim+'"DESCRIPTN"'+cDelim;
					+'"DEBITAMNT"'+cDelim+'"CREDITAMNT"'+cDelim+'"DEBITFNAMNT"'+cDelim+'"CREDITFNAMNT"'+cDelim+'"CURRENCY"'+cDelim;
					+'"ASSMNTCD"'+cDelim+'"GIVER"'+cDelim+'"PPDEST"'+cDelim+'"REFERENCE"'+cDelim+'"SEQNR"'+cDelim+'"POST"')
			ELSE
				* position file at end:
				FSeek(ptrHandle, 0, FS_END)
			ENDIF
			* detail records: 
			// Get transactnbrs: 
			oTrans2:=SQLSelect{"select distinct TransId from transaction t where "+self:cWhereSpec+" order by TransId",oConn}
			do while !oTrans2:EoF
				cTrans+=","+Str(oTrans2:TransId,-1)
				oTrans2:Skip()
			enddo
			cSelectSt:="select "+self:cFields+" from "+self:cFrom+" where "+self:cWhereBase+" and TransId in ("+SubStr(cTrans,2)+") order by TransId,seqnr" 
			oTrans2:=SQLSelect{cSelectSt,oConn}
			if oTrans2:RecCount>0
				do WHILE !oTrans2:EoF
					FWriteLine(ptrHandle,;
						'"'+DToS(oTrans2:Dat)+'"'+cDelim+'"'+oTrans2:docid+'"'+cDelim+'"'+Str(oTrans2:TransId,-1)+'"'+cDelim+'"'+AllTrim(oTrans2:ACCNUMBER)+'"'+cDelim+'"'+;
						AllTrim(oTrans2:accountname)+'"'+cDelim+'"'+AllTrim(oTrans2:Description)+'"'+cDelim;
						+'"'+Str(oTrans2:deb,-1)+'"'+cDelim+'"'+Str(oTrans2:cre,-1)+'"'+cDelim+;
						+'"'+Str(oTrans2:DEBFORGN,-1)+'"'+cDelim+'"'+Str(oTrans2:CREFORGN,-1)+'"'+cDelim+'"'+oTrans2:CURRENCY+'"'+cDelim+;
						'"'+oTrans2:GC+'"'+cDelim+'"'+Transform(oTrans2:personname,"")+'"'+cDelim+'"'+Transform(oTrans2:PPDEST,"")+'"'+cDelim+'"'+oTrans2:REFERENCE+'"'+cDelim+'"'+Str(oTrans2:SEQNR,-1)+'"'+cDelim+'"'+Str(oTrans2:PostStatus,-1)+'"')
					oTrans2:Skip()
				ENDDO
			endif
			* closing record:
			FClose(ptrHandle)
			for j:=1 to 20 
				// wait till fill written to disk
				if ToFileFS:Find()
					exit
				endif
			next
			IF lMail 
				oSys:=SQLSelect{"select OWNMAILACC,EXPMAILACC,CountryOwn from sysparms", oConn}
				if oSys:RecCount>0 
					cExportMail:=AllTrim(oSys:EXPMAILACC)
					cExportMail:=StrTran(cExportMail,";"+AllTrim(oSys:OWNMAILACC))
					cExportMail:=StrTran(cExportMail,AllTrim(oSys:OWNMAILACC))
				endif
				* Send file by email:
				IF IsMAPIAvailable()
					* Resolve IESname
					oMapi := MAPISession{}	
					IF oMapi:Open( "" , "" )
						oRecip := oMapi:ResolveMailName( "Headquarters",@cExportMail,"Headquarters financial system")
						IF oRecip != null_object
							oMAPI:SendDocument( FileSpec{cFileName} ,oRecip,oRecip2,"Export of transactions of "+sEntity+"("+oSys:CountryOwn+")","")
							(InfoBox{self:OWNER,"Export of transactions",;
								"Placed one mail messages in your outbox with attached the file: ";
								+cFilename}):Show()
							lSent:=true
						ENDIF
					ENDIF
					oMapi:Close()		
					IF !lSent
						(InfoBox{self:OWNER,"Export of transactions","Generated one file:"+cFilename+" (mail to export account "+;
							AllTrim(oSys:EXPMAILACC)+")"}):Show()
					ELSE
						ToFileFS:DELETE()
					ENDIF
					IF !cExportMail==oSys:EXPMAILACC
						oSys:EXPMAILACC:=cExportMail
					ENDIF
					oSys:commit()
				ENDIF
			else
				(TextBox{self:OWNER,"Export of transactions","Generated one file:"+cFilename}):Show()		
			ENDIF
		ENDIF
	endif
	self:Pointer := Pointer{POINTERARROW}
	
	RETURN
METHOD FindButton( ) CLASS TransInquiry
	self:cWhereSpec:="TransId >= "+Str(self:lsttrnr-Val(self:NbrTrans),-1)+" and t.dat >='"+SQLdate(MinDate)+"'"
	self:cSelectStmnt:="select "+self:cFields+" from "+cFrom+" where "+self:cWhereBase+" and "+self:cWhereSpec 
	self:cOrder:="TransId desc"
	self:oTrans:SQLString:=UnionTrans(self:cSelectStmnt) +" order by "+self:cOrder
	self:oTrans:Execute()
	self:GoTop()
	if self:oTrans:RecCount<1
		self:oSFTransInquiry_DETAIL:Browser:refresh()
	endif
  	self:oDCFound:TextValue :=Str(self:oTrans:RecCount,-1)


RETURN NIL
ACCESS FromTransnr() CLASS TransInquiry
RETURN SELF:FieldGet(#FromTransnr)

ASSIGN FromTransnr(uValue) CLASS TransInquiry
SELF:FieldPut(#FromTransnr, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TransInquiry 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TransInquiry",_GetInst()},iCtlID)

oCCSelectionButton := PushButton{SELF,ResourceID{TRANSINQUIRY_SELECTIONBUTTON,_GetInst()}}
oCCSelectionButton:HyperLabel := HyperLabel{#SelectionButton,"Advanced Find",NULL_STRING,NULL_STRING}
oCCSelectionButton:OwnerAlignment := OA_X

oCCEditButton := PushButton{SELF,ResourceID{TRANSINQUIRY_EDITBUTTON,_GetInst()}}
oCCEditButton:HyperLabel := HyperLabel{#EditButton,"Details",NULL_STRING,NULL_STRING}
oCCEditButton:OwnerAlignment := OA_Y

oCCReadyButton := PushButton{SELF,ResourceID{TRANSINQUIRY_READYBUTTON,_GetInst()}}
oCCReadyButton:HyperLabel := HyperLabel{#ReadyButton,"Ready Batch",NULL_STRING,NULL_STRING}
oCCReadyButton:OwnerAlignment := OA_Y

oCCPostButton := PushButton{SELF,ResourceID{TRANSINQUIRY_POSTBUTTON,_GetInst()}}
oCCPostButton:HyperLabel := HyperLabel{#PostButton,"Post Batch",NULL_STRING,NULL_STRING}
oCCPostButton:OwnerAlignment := OA_Y

oCCTransferButton := PushButton{SELF,ResourceID{TRANSINQUIRY_TRANSFERBUTTON,_GetInst()}}
oCCTransferButton:HyperLabel := HyperLabel{#TransferButton,"Transfer",NULL_STRING,NULL_STRING}
oCCTransferButton:TooltipText := "Transfer all shown transactions to another account of same balance groep and department"
oCCTransferButton:OwnerAlignment := OA_Y

oCCExportButton := PushButton{SELF,ResourceID{TRANSINQUIRY_EXPORTBUTTON,_GetInst()}}
oCCExportButton:HyperLabel := HyperLabel{#ExportButton,"Export",NULL_STRING,NULL_STRING}
oCCExportButton:TooltipText := "Export of all shown transactions to file and email"
oCCExportButton:OwnerAlignment := OA_Y

oDCLstTxt1 := FixedText{SELF,ResourceID{TRANSINQUIRY_LSTTXT1,_GetInst()}}
oDCLstTxt1:HyperLabel := HyperLabel{#LstTxt1,"Last ",NULL_STRING,NULL_STRING}

oDCNbrTrans := SingleLineEdit{SELF,ResourceID{TRANSINQUIRY_NBRTRANS,_GetInst()}}
oDCNbrTrans:Picture := "99999999999"
oDCNbrTrans:HyperLabel := HyperLabel{#NbrTrans,NULL_STRING,NULL_STRING,NULL_STRING}

oCCFindButton := PushButton{SELF,ResourceID{TRANSINQUIRY_FINDBUTTON,_GetInst()}}
oCCFindButton:HyperLabel := HyperLabel{#FindButton,"Show",NULL_STRING,NULL_STRING}

oDCFoundtext := FixedText{SELF,ResourceID{TRANSINQUIRY_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}

oDCFound := FixedText{SELF,ResourceID{TRANSINQUIRY_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,NULL_STRING,NULL_STRING,NULL_STRING}

oDCLstTxt2 := FixedText{SELF,ResourceID{TRANSINQUIRY_LSTTXT2,_GetInst()}}
oDCLstTxt2:HyperLabel := HyperLabel{#LstTxt2,"transactions",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{TRANSINQUIRY_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"lines",NULL_STRING,NULL_STRING}

SELF:Caption := "Inquiry of financial transactions"
SELF:HyperLabel := HyperLabel{#TransInquiry,"Inquiry of financial transactions",NULL_STRING,NULL_STRING}
SELF:Menu := WOMenu{}
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

oSFTransInquiry_DETAIL := TransInquiry_DETAIL{SELF,TRANSINQUIRY_TRANSINQUIRY_DETAIL}
oSFTransInquiry_DETAIL:show()

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS NbrTrans() CLASS TransInquiry
RETURN SELF:FieldGet(#NbrTrans)

ASSIGN NbrTrans(uValue) CLASS TransInquiry
SELF:FieldPut(#NbrTrans, uValue)
RETURN uValue

METHOD Post(status as int ) as void pascal CLASS TransInquiry
// mark transactions with PostStatus status 
local oTransH:=self:Server as TransHistory, oTrans as Transaction 
local cTransnr as string 
oTrans:=Transaction{}
if !oTrans:used
	return
endif

self:STATUSMESSAGE(self:oLan:WGet(iif(status=2,"Posting","Ready")+" transactions, moment please"))
self:Pointer := Pointer{POINTERHOURGLASS}

oTrans:SetOrder("TRANSNR") 
oTrans:SuspendNotification()
oTransH:SuspendNotification()
oTransH:GoTop()
do while !oTransH:EOF 
	cTransnr:=oTransH:TransId
	if oTrans:Seek(cTransnr)
		do while !oTrans:EOF .and. oTrans:TransId== cTransnr
			oTrans:RecLock()
			oTrans:POSTSTATUS:=status
			oTrans:USERID:=LOGON_EMP_ID
			oTrans:Skip()
		enddo
	Endif
	oTransH:Skip()
Enddo
oTrans:Unlock()
oTrans:Commit()
oTrans:Close()
oTransH:GoTop()
oTransH:ResetNotification()
self:STATUSMESSAGE(Space(40))
self:Pointer := Pointer{POINTERARROW}
self:oSFTransInquiry_DETAIL:Browser:REFresh()

RETURN
METHOD PostButton( ) CLASS TransInquiry
if (TextBox{,"Post Batch","Are you sure you want to Post all selected transactions and freeze them?",BOXICONQUESTIONMARK + BUTTONYESNO}):Show()<> BOXREPLYYES
	return
endif
self:Post(2)
	RETURN nil
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TransInquiry
	//Put your PostInit additions here
	local OldestYear as date
	LOCAL i,j as int 
	local	oBank as SQLSelect

self:SetTexts()
	self:StartDate:=MinDate
	self:EndDate:=Today()+31
	self:TransTypeSelected:="A"
	self:NoUpdate:=FALSE	
	IF AScan(aMenu,{|x| x[4]=="General_Journal"})=0
		// no update of transactions allowed:
		SELF:oCCEditButton:Hide()
		SELF:oCCTransferButton:Hide()
		SELF:NoUpdate:=TRUE
	ENDIF
	IF AScan(aMenu,{|x| x[4]=="TransactionEdit"})=0
		self:oCCTransferButton:Hide()
	ELSE
		oBank	:=	SQLSelect{"select	accid from	BankAccount	where	telebankng>0 and accid",oConn} 
		if oBank:RecCount>0
			do WHILE !oBank:EOF
				self:cAccFilter+=iif(Empty(self:cAccFilter),"",' and ')+'accid<>"'+Str(oBank:AccID,-1)+'"' 
				AAdd(self:aTeleAcc,oBank:AccID)
				oBank:Skip()
			ENDDO 
		endif

	ENDIF
	self:NbrTrans:= "100"
	if !Empty(GlBalYears)
		OldestYear:=GlBalYears[Len(GlBalYears),1] 
	else
		OldestYear:=MinDate
	endif
  	self:oDCFound:TextValue :=Str(self:oTrans:RecCount,-1)
 

	RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class TransInquiry
	//Put your PreInit additions here
	self:lsttrnr:=SQLSelect{"select max(TransId) as maxtr from transaction",oConn}:maxtr 
	self:cFields:="t.*,a.accnumber,a.description as accountname,"+SQLFullName(0,"p")+" as personname"
	self:cFrom:="account a, transaction t left join person p on (p.persid=t.persid)"
	self:cWhereBase:="a.accid=t.accid"+iif(Empty(cDepmntIncl),''," and Department in ("+cDepmntIncl+")") 
	if !Empty( cAccAlwd)
		if USERTYPE=="D"
			self:cWhereBase+=" and t.Userid='"+LOGON_EMP_ID+"'"
			// 			+iif(MinDate >LstYearClosed,".and.DToS(Dat)>='"+DToS(MinDate)+"'",""))
		else
			self:cWhereBase+=" and (t.accid in("+cAccAlwd+") or t.Userid='"+LOGON_EMP_ID+"')"
		endif		
	endif
	cWhereSpec:="TransId>"+Str(self:lsttrnr-100,-1)+" and t.dat >='"+SQLdate(MinDate)+"'"
	self:cOrder:="t.TransId desc" 
	self:cSelectStmnt:="select "+self:cFields+" from "+cFrom+" where "+self:cWhereBase+" and "+self:cWhereSpec +" order by "+self:cOrder
	self:oTrans:=SQLSelect{UnionTrans(self:cSelectStmnt),oConn}
	return NIL

METHOD ReadyButton( ) CLASS TransInquiry 
if (TextBox{,"Ready Batch","Are you sure you want to mark all selected transactions as 'Ready to Post'?",BOXICONQUESTIONMARK + BUTTONYESNO}):Show()<> BOXREPLYYES
	return
endif
self:Post(1)

RETURN NIL
METHOD SelectionButton( ) CLASS TransInquiry
	oSel := InquirySelection{self:Owner,,,{self}}
	oSel:Show()
	RETURN
	
		
	
ACCESS ToTransnr() CLASS TransInquiry
RETURN SELF:FieldGet(#ToTransnr)

ASSIGN ToTransnr(uValue) CLASS TransInquiry
SELF:FieldPut(#ToTransnr, uValue)
RETURN uValue

METHOD Transfer( ) CLASS TransInquiry
LOCAL oTrans as SQLSelect
LOCAL lError as LOGIC
LOCAL nCurRec, nNextRec as int
local oAccFrom,oAccTo as SQLSelect
local cCurrorg,cCurrDest as string, lMultiOrg, lMultiDest as logic
local cFromText, cToText as string 
local oStmnt as SQLStatement
oTrans:=self:Server
oTrans:GoTop()
IF oTrans:EOF
	RETURN
ENDIF
IF Empty(self:cTransferAcc)
	RETURN
ENDIF
oAccFrom:=SQLSelect{"select a.multcurr,a.currency,b.category from Account a,balanceitem b where a.balitemid=b.balitemid and a.accid="+self:FromAccId,oConn} 
if oAccFrom:reccount<1
	return
endif
cCurrorg:=iif(Empty(oAccFrom:Currency),sCurr,oAccFrom:Currency)
lMultiOrg:=iif(oAccFrom:MULTCURR=1,true,false)
oAccTo:=SQLSelect{"select a.multcurr,a.currency,b.category from Account a,balanceitem b where a.balitemid=b.balitemid and a.accid="+self:cTransferAcc,oConn} 
if oAccTo:reccount<1
	return
endif
cCurrDest:=iif(Empty(oAccTo:Currency),sCurr,oAccTo:Currency)
lMultiDest:=iif(oAccTo:MULTCURR=1,true,false)
if !lMultiDest
	if cCurrDest<>cCurrorg
		cFromText:=cCurrorg+" "  
		cToText:=cCurrDest+" "  
	elseif lMultiOrg
		cFromText:="Multi Currency "
		cToText:=cCurrDest+" "  
	endif
endif
IF self:cSoortOrg # self:cSoort
	IF (TextBox{self,"Transfer of transactions",;
	"Do you want to transfer these "+cFromText+GetBalType(cSoortOrg)+" transactions to "+cToText+GetBalType(cSoort)+" account: "+;
		AllTrim(self:cTransferAccName)+"?",BUTTONOKAYCANCEL+BOXICONQUESTIONMARK}):Show()==BOXREPLYCANCEL
		RETURN
	ENDIF
ELSE
	IF (TextBox{self,"Transfer of transaction to other account","Should all selected "+cFromText+"transactions be transfered to "+cToText+"account: "+;
		AllTrim(self:cTransferAccName)+"?",BUTTONOKAYCANCEL+BOXICONQUESTIONMARK}):Show()==BOXREPLYCANCEL
		RETURN
	ENDIF
ENDIF	
oTrans:SuspendNotification()
self:STATUSMESSAGE("Transfering data, moment please")
self:Pointer := Pointer{POINTERHOURGLASS}
SQLStatement{"start transaction",oConn}:Execute() 
oStmnt:=SQLStatement{"update transaction t set accid='"+self:cTransferAcc+"',USERID='"+LOGON_EMP_ID+"'"+;
iif(cCurrDest==sCurr .and.!lMultiDest,",DEBFORGN=DEB,CREFORGN=Cre,Currency='"+sCurr+"'","")+;
" where "+self:cWhereSpec,oConn}
LogEvent(self,oStmnt:sqlstring,"logsql") 
oStmnt:Execute()
if oStmnt:NumSuccessfulRows>0
	DO WHILE !oTrans:EOF
		if ChgBalance(FromAccId,oTrans:DAT,-oTrans:DEB,-oTrans:Cre,-oTrans:DEBFORGN,-oTrans:CREFORGN,oTrans:Currency)
			if ChgBalance(cTransferAcc,oTrans:DAT,oTrans:DEB,oTrans:Cre,oTrans:DEBFORGN,oTrans:CREFORGN,oTrans:Currency)
			else
				lError:=true
				exit
			endif
		else
			lError:=true
			exit
		endif
		oTrans:Skip()
	ENDDO
else
	lError:=true
	LogEvent(self,"error:"+oStmnt:status:Description+CRLF+"stmnt:"+oStmnt:SQLString,"LogSQL")
endif
if lError
	SQLStatement{"rollback",oConn}:Execute()
	ErrorBox{self,self:oLan:WGet("Transfer failed")}:Show() 
	oTrans:ResetNotification()
	return
else
	SQLStatement{"commit",oConn}:Execute()
endif
self:Pointer := Pointer{POINTERARROW} 
// refresh screen:
oTrans:Execute()
oTrans:ResetNotification()
oTrans:GoTop()
self:oSFTransInquiry_DETAIL:Browser:Refresh()
self:oSFTransInquiry_DETAIL:GoTop()
self:oCCTransferButton:Hide()

RETURN

	
METHOD TransferButton( ) CLASS TransInquiry 
local cFilter as string 
 
self:cTransferAcc:=""
 
cFilter:= 'a.accid<>"'+self:FromAccId+'"'
if self:cCurr==sCurr
	cFilter+=' and a.Currency="'+sCurr+'"'
else
	cFilter+=' and (a.Currency="'+self:cCurr+'" or a.Currency="'+sCurr+'")'
endif	
AccountSelect(self,"","Account to transfer to",FALSE,cFilter)

RETURN

	
CLASS TransInquiry_DETAIL INHERIT DataWindowExtra 

	PROTECT oDBTRANSID as DataColumn
	PROTECT oDBACCNUMBER as DataColumn
	PROTECT oDBACCOUNTNAME as DataColumn
	PROTECT oDBPERSONNAME as DataColumn
	PROTECT oDBDAT as DataColumn
	PROTECT oDBDOCID as DataColumn
	PROTECT oDBREFERENCE as DataColumn
	PROTECT oDBDESCRIPTION as DataColumn
	PROTECT oDBDEB as DataColumn
	PROTECT oDBCRE as DataColumn
	PROTECT oDBGC as DataColumn
	PROTECT oDBPOSTINGSTATUS as DataColumn

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
 	Export cOrgFilter as string 
RESOURCE TransInquiry_DETAIL DIALOGEX  32, 33, 547, 258
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
END

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS TransInquiry_DETAIL 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"TransInquiry_DETAIL",_GetInst()},iCtlID)

SELF:Caption := ""
SELF:HyperLabel := HyperLabel{#TransInquiry_DETAIL,NULL_STRING,NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := False
SELF:DeferUse := True
SELF:OwnerAlignment := OA_PWIDTH_PHEIGHT

if !IsNil(oServer)
	SELF:Use(oServer)
ELSE
	SELF:Use(SELF:Owner:Server)
ENDIF
self:Browser := EditBrowser{self}

oDBTRANSID := DataColumn{Transaction_TRANSAKTNR{}}
oDBTRANSID:Width := 9
oDBTRANSID:HyperLabel := HyperLabel{#TransID,"Transact#",NULL_STRING,NULL_STRING} 
oDBTRANSID:Caption := "Transact#"
self:Browser:AddColumn(oDBTRANSID)

oDBACCNUMBER := DataColumn{Account_AccNumber{}}
oDBACCNUMBER:Width := 10
oDBACCNUMBER:HyperLabel := HyperLabel{#AccNumber,"Account","Number of an Account",NULL_STRING} 
oDBACCNUMBER:Caption := "Account"
self:Browser:AddColumn(oDBACCNUMBER)

oDBACCOUNTNAME := DataColumn{AccDesc{}}
oDBACCOUNTNAME:Width := 16
oDBACCOUNTNAME:HyperLabel := HyperLabel{#AccountName,"Acc.name",NULL_STRING,NULL_STRING} 
oDBACCOUNTNAME:Caption := "Acc.name"
self:Browser:AddColumn(oDBACCOUNTNAME)

oDBPERSONNAME := DataColumn{Person_OPM{}}
oDBPERSONNAME:Width := 16
oDBPERSONNAME:HyperLabel := HyperLabel{#PersonName,"Person",NULL_STRING,NULL_STRING} 
oDBPERSONNAME:Caption := "Person"
self:Browser:AddColumn(oDBPERSONNAME)

oDBDAT := DataColumn{Transaction_DAT{}}
oDBDAT:Width := 11
oDBDAT:HyperLabel := HyperLabel{#DAT,"Date",NULL_STRING,"Transaction_DAT"} 
oDBDAT:Caption := "Date"
self:Browser:AddColumn(oDBDAT)

oDBDOCID := DataColumn{Transaction_BST{}}
oDBDOCID:Width := 7
oDBDOCID:HyperLabel := HyperLabel{#docid,"Doc id",NULL_STRING,"Transaction_BST"} 
oDBDOCID:Caption := "Doc id"
self:Browser:AddColumn(oDBDOCID)

oDBREFERENCE := DataColumn{8}
oDBREFERENCE:Width := 8
oDBREFERENCE:HyperLabel := HyperLabel{#Reference,"Refer",NULL_STRING,NULL_STRING} 
oDBREFERENCE:Caption := "Refer"
self:Browser:AddColumn(oDBREFERENCE)

oDBDESCRIPTION := DataColumn{Description{}}
oDBDESCRIPTION:Width := 21
oDBDESCRIPTION:HyperLabel := HyperLabel{#description,"Description",NULL_STRING,NULL_STRING} 
oDBDESCRIPTION:Caption := "Description"
self:Browser:AddColumn(oDBDESCRIPTION)

oDBDEB := DataColumn{Transaction_DEB{}}
oDBDEB:Width := 10
oDBDEB:HyperLabel := HyperLabel{#DEB,"Debit",NULL_STRING,"Transaction_DEB"} 
oDBDEB:Caption := "Debit"
self:Browser:AddColumn(oDBDEB)

oDBCRE := DataColumn{Transaction_CRE{}}
oDBCRE:Width := 10
oDBCRE:HyperLabel := HyperLabel{#CRE,"Credit",NULL_STRING,"Transaction_CRE"} 
oDBCRE:Caption := "Credit"
self:Browser:AddColumn(oDBCRE)

oDBGC := DataColumn{Transaction_GC{}}
oDBGC:Width := 6
oDBGC:HyperLabel := HyperLabel{#GC,"Asmnt",NULL_STRING,"Transaction_GC"} 
oDBGC:Caption := "Asmnt"
self:Browser:AddColumn(oDBGC)

oDBPOSTINGSTATUS := DataColumn{9}
oDBPOSTINGSTATUS:Width := 9
oDBPOSTINGSTATUS:HyperLabel := HyperLabel{#POSTINGSTATUS,"Status",NULL_STRING,NULL_STRING} 
oDBPOSTINGSTATUS:Caption := "Status"
oDBPOSTINGSTATUS:Block := {|x|iif(x:Poststatus=2,'Posted',iif(x:Poststatus=1,'Ready','Not posted'))}
oDBPOSTINGSTATUS:BlockOwner := self:owner:server
self:Browser:AddColumn(oDBPOSTINGSTATUS)


SELF:ViewAs(#BrowseView)

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS TransInquiry_DETAIL
	//Put your PostInit additions here
self:SetTexts()
	SELF:Browser:SetStandardStyle(GBSREADONLY)
	SELF:ViewAs(#BrowseView)
	IF !(ADMIN=="WO".or.ADMIN=="HO")
		* remove assessment column:
		SELF:Browser:RemoveColumn(oDBGC)
	ENDIF
	if !Posting
		self:Browser:RemoveColumn(self:oDBPOSTINGSTATUS) 
	else
		self:Owner:SetWidth(self:Owner:Size:Width+=20)
	endif

	RETURN nil
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS TransInquiry_DETAIL
	//Put your PreInit additions here 
	LOCAL lDesc, lSuccess as LOGIC
oWindow:use(oWindow:oTrans)
	RETURN NIL
STATIC DEFINE TRANSINQUIRY_DETAIL_ACCNTNUMBER := 100 
STATIC DEFINE TRANSINQUIRY_DETAIL_ACCNUMBER := 100 
STATIC DEFINE TRANSINQUIRY_DETAIL_ACCOUNTNAME := 109 
STATIC DEFINE TRANSINQUIRY_DETAIL_CRE := 105 
STATIC DEFINE TRANSINQUIRY_DETAIL_DAT := 102 
STATIC DEFINE TRANSINQUIRY_DETAIL_DEB := 104 
STATIC DEFINE TRANSINQUIRY_DETAIL_DESCRIPTION := 103 
STATIC DEFINE TRANSINQUIRY_DETAIL_DOCID := 101 
STATIC DEFINE TRANSINQUIRY_DETAIL_GC := 106 
STATIC DEFINE TRANSINQUIRY_DETAIL_PERSONNAME := 108 
STATIC DEFINE TRANSINQUIRY_DETAIL_POSTINGSTATUS := 110 
STATIC DEFINE TRANSINQUIRY_DETAIL_REFERENCE := 111 
STATIC DEFINE TRANSINQUIRY_DETAIL_TRANSID := 107 
STATIC DEFINE TRANSINQUIRY_EDITBUTTON := 102 
STATIC DEFINE TRANSINQUIRY_EXPORTBUTTON := 106 
STATIC DEFINE TRANSINQUIRY_FINDBUTTON := 109 
STATIC DEFINE TRANSINQUIRY_FIXEDTEXT4 := 113 
STATIC DEFINE TRANSINQUIRY_FOUND := 111 
STATIC DEFINE TRANSINQUIRY_FOUNDTEXT := 110 
STATIC DEFINE TRANSINQUIRY_LSTTXT1 := 107 
STATIC DEFINE TRANSINQUIRY_LSTTXT2 := 112 
STATIC DEFINE TRANSINQUIRY_NBRTRANS := 108 
STATIC DEFINE TRANSINQUIRY_POSTBUTTON := 104 
STATIC DEFINE TRANSINQUIRY_READYBUTTON := 103 
STATIC DEFINE TRANSINQUIRY_SELECTIONBUTTON := 101 
STATIC DEFINE TRANSINQUIRY_TRANSFERBUTTON := 105 
STATIC DEFINE TRANSINQUIRY_TRANSINQUIRY_DETAIL := 100 
CLASS YearW INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS YearW

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

    symHlName   := #Year

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

    nMinLen     := 4
    nMinRange   := 1900
    nMaxRange   := 2100
    xValidation := NIL
    lRequired   := .F.


    SUPER:Init( HyperLabel{symHlName, "Year", "", "" },  "N", 4, 0 )


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
