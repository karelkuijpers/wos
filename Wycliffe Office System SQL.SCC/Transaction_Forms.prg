CLASS BedragStr INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS BedragStr
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#BedragStr, "", "Amount", "" },  "C", 13, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
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
	PROTECT oCCReturnButton AS PUSHBUTTON
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
	PROTECT oDCFoundtext AS FIXEDTEXT
	PROTECT oDCFound AS FIXEDTEXT
	PROTECT oSFGeneralJournal1 AS GeneralJournal1

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	instance mBST 
	instance mPerson 
	instance mTRANSAKTNR 
	instance BankBalance 
  	PROTECT oTmt as TeleMut
  	PROTECT fTotal as FLOAT
  	Export mCLNGiver as STRING
  	Protect cGiverName, cOrigName as STRING
  	PROTECT lInqUpd as LOGIC
  	EXPORT lTeleBank as LOGIC
  	EXPORT lMemberGiver as LOGIC
  	export lDirectIncome as logic
  	PROTECT OrigBst, OrigPerson as STRING, OrigDat as date
  	PROTECT oInqBrowse as OBJECT && Calling Browser (inquiry/update)
	PROTECT oFocusControl as Control
	Export oOwner as TransInquiry
	EXPORT cAccFilter:="" as STRING
	PROTECT lSave as LOGIC
	PROTECT oImpB as ImportBatch
	PROTECT CurBankAcc as STRING  // id of currently shown bank account 
	Export CurDate as date 
	export lStop as logic
	export oHlpMut as TempTrans
	protect mPayahead as string  // account used for direct debit 
	
// EXPORT pFilter as _CODEBLOCK
	protect oCurr as Currency 
	export nLstSeqNr as int 
	protect cOrgAccs as string
//   	export ticks1,ticks2 as DWORD
	export lwaitingForExchrate as logic
	protect aBankAcc:={} as array
	protect aPayahead:={} as array 
	export oAddInEx as AddToIncExp
  	
	declare method FindNext, FindPrevious
  	declare method Totalise,ValidateTempTrans,FillTeleBanking, FillRecord, ShowBankBalance, ValStore, ;
  	UpdateLine,FillBatch,RegAccount,FindNext,FindPrevious,ChgDueAmnts,UpdateTrans
RESOURCE General_Journal DIALOGEX  62, 55, 466, 315
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", GENERAL_JOURNAL_MBST, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 52, 1, 41, 13
	CONTROL	"dinsdag 9 december 2014", GENERAL_JOURNAL_MDAT, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 140, 1, 132, 13
	CONTROL	"", GENERAL_JOURNAL_MPOSTSTATUS, "ComboBox", CBS_DISABLENOSCROLL|CBS_DROPDOWNLIST|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_VSCROLL, 276, 1, 72, 50
	CONTROL	"", GENERAL_JOURNAL_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 312, 18, 132, 12, WS_EX_CLIENTEDGE
	CONTROL	"OK&&Remember", GENERAL_JOURNAL_SAVEBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 400, 284, 52, 12
	CONTROL	"OK", GENERAL_JOURNAL_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 400, 299, 52, 12
	CONTROL	"Post Batch", GENERAL_JOURNAL_POSTBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 396, 299, 53, 12
	CONTROL	"Cancel", GENERAL_JOURNAL_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 340, 299, 53, 12
	CONTROL	"", GENERAL_JOURNAL_GENERALJOURNAL1, "static", WS_TABSTOP|WS_CHILD|WS_BORDER, 4, 55, 456, 221
	CONTROL	"", GENERAL_JOURNAL_DEBITCREDITTEXT, "Static", WS_CHILD|WS_BORDER, 48, 296, 82, 12, WS_EX_CLIENTEDGE
	CONTROL	"Telebanking...", GENERAL_JOURNAL_TELEBANKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 340, 283, 54, 12
	CONTROL	"Person:", GENERAL_JOURNAL_SC_CLN, "Static", WS_CHILD, 284, 18, 27, 12
	CONTROL	"Return Batch", GENERAL_JOURNAL_RETURNBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 396, 284, 53, 12
	CONTROL	"v", GENERAL_JOURNAL_PERSONBUTTON, "Button", WS_CHILD, 444, 18, 13, 12
	CONTROL	"", GENERAL_JOURNAL_MTRANSAKTNR, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_BORDER, 416, 1, 40, 12
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
	CONTROL	"Found:", GENERAL_JOURNAL_FOUNDTEXT, "Static", SS_CENTERIMAGE|WS_CHILD, 140, 295, 28, 12
	CONTROL	"lines", GENERAL_JOURNAL_FOUND, "Static", SS_CENTERIMAGE|WS_CHILD, 168, 295, 36, 12
END

method AddCur() class General_Journal
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
					// self:oImpB:CloseBatch() // allready in Valstore
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
   IPCITEMNOTFOUND
	IF !self:oHlpMut==null_object .and. IsObject(self:oHlpMut)
		oServer:=FileSpec{self:oHlpMut:FileSpec:FullPath} 
		if oServer:Find()
			IF self:oHlpMut:Used
				self:oHlpMut:Close()
			ENDIF
			//FErase(cServer)
			if !oServer:DELETE()
				FErase(oServer:FullPath)
			ENDIF
// 			oServer:Extension:="fpt"
// 			IF oServer:Find()
// 				if !oServer:DELETE() 
// 					FErase(oServer:FullPath)
// 				endif
// 			ENDIF
		endif
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

	RETURN SUPER:Close(oEvent)
method DateTimeSelectionChanged(oDateTimeSelectionEvent) class General_Journal
local i as int 
local lError as logic

Local oHm as TempTrans
	super:DateTimeSelectionChanged(oDateTimeSelectionEvent)
	//Put your changes here
	IF IsObject(self:oSFGeneralJournal1:Browser).and.!self:oSFGeneralJournal1:Browser==null_object.and.!self:mDat == self:CurDate 
		oHm:= self:server
		self:oSFGeneralJournal1:Browser:SuspendUpdate()

		FOR i=1 to Len(oHm:aMirror)
			if oHm:aMirror[i,12]#sCurr
				oHm:Goto(oHm:aMirror[i,6])
				if !self:oSFGeneralJournal1:DebCreProc(nil)
					lError:=true
					exit
				endif 
			endif
		next
		if lError
			self:mDat:=self:CurDate
// 			self:oDCmDat:SelectedDate:=self:CurDate
		else
			self:CurDate := oDCmDat:SelectedDate
			self:oSFGeneralJournal1:Browser:RestoreUpdate()
		endif
	endif

	return nil	


METHOD EditFocusChange(oEditFocusChangeEvent) CLASS General_Journal
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus.and.!IsNil(oControl:Value)
		IF oControl:Name == "MPERSON".and.!AllTrim(oControl:Value)==AllTrim(cGiverName)
			IF Empty(oControl:VALUE) && emptied?
				self:RegPerson(' ')
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
	self:lTeleBank:=FALSE
	self:oTmt:Close()
	self:oDCGiroText:TextValue:= ""
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
	LOCAL oHm:=self:Server as TempTrans
	IF Empty(self:oImpB)
		self:oImpB:=ImportBatch{self,self:Server}
	ENDIF
	self:oImpB:Import()
	IF self:oImpB:GetNextBatch()
		IF self:oImpB:lOK
			self:OKButton()
		ENDIF
	ELSE
		SELF:lImport := FALSE
		oHm:OPP:=''
		oHm:cOpp:=''
		oHm:FROMRPP:=false
		self:oImpB:Close()
		self:oImpB:=null_object
		(WarningBox{self,"Journaling Records","No more Import batches found"}):Show()
	ENDIF
RETURN NIL
	
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS General_Journal 
LOCAL DIM aBrushes[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"General_Journal",_GetInst()},iCtlID)

aBrushes[1] := Brush{Color{COLORWHITE}}

oDCmBST := SingleLineEdit{SELF,ResourceID{GENERAL_JOURNAL_MBST,_GetInst()}}
oDCmBST:HyperLabel := HyperLabel{#mBST,NULL_STRING,NULL_STRING,"Transaction_BST"}

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
oCCPostButton:TooltipText := "Post transaction as definitely booked"

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

oCCReturnButton := PushButton{SELF,ResourceID{GENERAL_JOURNAL_RETURNBUTTON,_GetInst()}}
oCCReturnButton:HyperLabel := HyperLabel{#ReturnButton,"Return Batch",NULL_STRING,NULL_STRING}
oCCReturnButton:OwnerAlignment := OA_Y
oCCReturnButton:TooltipText := "Send transaction back to bookkeeper to correct it"

oCCPersonButton := PushButton{SELF,ResourceID{GENERAL_JOURNAL_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v",NULL_STRING,"Browse in persons"}
oCCPersonButton:TooltipText := "Browse in Persons"
oCCPersonButton:UseHLforToolTip := True

oDCmTRANSAKTNR := SingleLineEdit{SELF,ResourceID{GENERAL_JOURNAL_MTRANSAKTNR,_GetInst()}}
oDCmTRANSAKTNR:HyperLabel := HyperLabel{#mTRANSAKTNR,NULL_STRING,NULL_STRING,"Transaction_TRANSAKTNR"}

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

oDCFoundtext := FixedText{SELF,ResourceID{GENERAL_JOURNAL_FOUNDTEXT,_GetInst()}}
oDCFoundtext:HyperLabel := HyperLabel{#Foundtext,"Found:",NULL_STRING,NULL_STRING}
oDCFoundtext:OwnerAlignment := OA_Y

oDCFound := FixedText{SELF,ResourceID{GENERAL_JOURNAL_FOUND,_GetInst()}}
oDCFound:HyperLabel := HyperLabel{#Found,"lines",NULL_STRING,NULL_STRING}
oDCFound:OwnerAlignment := OA_Y

SELF:Caption := "Journal General"
SELF:HyperLabel := HyperLabel{#General_Journal,"Journal General",NULL_STRING,NULL_STRING}
SELF:Menu := WOBrowserMENUFIND{}
SELF:PreventAutoLayout := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF
self:Browser := DataBrowser{self}

oDBMBST := DataColumn{6}
oDBMBST:Width := 6
oDBMBST:HyperLabel := oDCMBST:HyperLabel 
oDBMBST:Caption := ""
self:Browser:AddColumn(oDBMBST)

oDBMPERSON := DataColumn{9}
oDBMPERSON:Width := 9
oDBMPERSON:HyperLabel := oDCMPERSON:HyperLabel 
oDBMPERSON:Caption := ""
self:Browser:AddColumn(oDBMPERSON)

oDBMTRANSAKTNR := DataColumn{13}
oDBMTRANSAKTNR:Width := 13
oDBMTRANSAKTNR:HyperLabel := oDCMTRANSAKTNR:HyperLabel 
oDBMTRANSAKTNR:Caption := ""
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
	LOCAL CurValue as ARRAY   // 1: nw value, 2: old value, 3: name of columnfield
	LOCAL ThisRec as int
	LOCAL CurBankSave:=self:CurBankAcc as STRING
	local lSave as logic 
	local oHm:=self:Server as TempTrans
local oAcc as SQLSelect
local cWhere:="a.balitemid=b.balitemid"
local cFrom:="balanceitem as b,account as a left join member m on (m.accid=a.accid or m.depid=a.department) left join department d on (m.depid=d.depid) " 
local cFields:="a.*,b.category as type,m.co,m.persid as persid,"+SQLAccType()+" as accounttype,"+SQLIncExpFd()+" as incexpfd"
	Default(@lMySave,false)
	lSave:=lMySave

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
			self:mCLNGiver := ""
			self:cGiverName := ""
			self:mPerson := ""
			self:mBST:= " "
			IF self:oImpB:GetNextBatch()
				IF !self:oImpB:lOK .or.!self:ValStore()
					RETURN nil
				ENDIF
			ELSE
				self:oDCmBST:Enable()
				self:oDCmDat:Enable()
				self:lImport:=FALSE
				self:oImpB:Close()
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
			self:mCLNGiver := ""
			self:cGiverName := ""
			self:mPerson := ""
			self:mBst:= " " 
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
METHOD PostButton(status ) CLASS General_Journal
	// mark transactions as Posted: 
	local nSavRec as int
	local i as int
	local cError as string
	local lError as logic 
	Local oTrans,oStmnt as SQLStatement
	local oTransH:=self:Server as TempTrans
	local aTrans:=oTransH:aMirror as array
	local oBal as balances 
	Default(@status,2) 
	if IsObject(self:oInqBrowse) .and. IsObject(self:oInqbrowse:owner) .and. IsObject(self:oInqBrowse:Owner:server)
		nSavRec:=self:oInqBrowse:owner:server:RecNo 
	endif

	oStmnt:=SQLStatement{"set autocommit=0",oConn}
	oStmnt:execute()
	oStmnt:=SQLStatement{'lock tables `mbalance` write, `transaction` write',oConn}       // alphabetic order
	oStmnt:execute()

	oTrans:=SQLStatement{"update transaction set poststatus='"+ConS(status)+"',userid='"+LOGON_EMP_ID+"' where transid="+self:mTRANSAKTNR,oConn}
	oTrans:Execute() 
	if !Empty(oTrans:status)
		lError:=true
		cError:=oTrans:ErrInfo:errormessage
	endif
	if !lError .and.status=2
		oBal:=Balances{}     
	// amirror-array {accID,deb,cre,gc,category,recno,Trans:RecNbr,accnumber,AccDesc,balitemid,curr,multicur,debforgn,creforgn,reference,description,persid,type, incexpfd,depid}
	//                  1    2   3  4    5       6        7           8        9        10     11      12      13        14     15         16          17     18      19       20
      for i:=1 to Len(oTransH:aMirror)
			oBal:ChgBalance(ConS(aTrans[i,1]), self:mDAT, aTrans[i,2], aTrans[i,3], aTrans[i,13], aTrans[i,14],aTrans[i,11],2)
      next
		if !oBal:ChgBalanceExecute()
			lError:=true
			cError:=oBal:cError
		endif
	endif
	if !lError
		SQLStatement{"commit",oConn}:execute()
		SQLStatement{"unlock tables",oConn}:execute() 
		SQLStatement{"set autocommit=1",oConn}:execute() 
	else
		SQLStatement{"rollback",oConn}:execute()
		SQLStatement{"unlock tables",oConn}:execute() 
		SQLStatement{"set autocommit=1",oConn}:execute()
		cError:=self:oLan:WGet("transaction could't be posted")+" ("+cError+")" 
		LogEvent(self,cError,"logerrors")
		ErrorBox{,self,cError}:Show()
	endif

	if self:oOwner:lShowFind
		self:oOwner:FindButton()
	else
		self:oOwner:ShowSelection()
	endif
	self:oInqBrowse:owner:Goto(nSavRec)
	self:lStop:=true

// 	self:oInqBrowse:REFresh()
	self:EndWindow()

	RETURN nil
METHOD PostInit() CLASS General_Journal
	//Put your PostInit additions here
	LOCAL oBank as SQLSelect
	LOCAL aTeleAcc:={} AS ARRAY
	local oSel as SQLSelect
	self:SetTexts()
	SaveUse(self)

	IF !SELF:Server:lExisting
		SELF:Server:Zap()
		SELF:append()
	ENDIF
	self:lStop:=true
	IF !TeleBanking
		oCCTeleBankButton:Hide()
	ENDIF		
	oBank := SqlSelect{"select accid from bankaccount where telebankng>0",oConn} 
	if oBank:RecCount>0
		do WHILE !oBank:EOF
			self:cAccFilter+=iif(Empty(self:cAccFilter),"",' and ')+'accid<>"'+Str(oBank:AccID,-1)+'"' 
			AAdd(aTeleAcc,Str(oBank:AccID,-1))
			oBank:Skip()
		ENDDO 
	endif
	self:Server:aTeleAcc:=aTeleAcc
	// save all bankaccounts  
	oBank := SqlSelect{"select accid,payahead from bankaccount",oConn} 
	if oBank:RecCount>0
		do WHILE !oBank:EOF
			AAdd(self:aBankAcc,ConS(oBank:AccID))
			if !empty(oBank:payahead) .and. ascanexact(self:aPayahead,ConS(oBank:payahead))=0
				AAdd(self:aPayahead,ConS(oBank:payahead))
			endif
			oBank:Skip()
		ENDDO 
	endif
	CurDate:=self:oDCmDat:SelectedDate 
	IF USERTYPE=="D"
		self:oCCTeleBankButton:Hide()
	endif
	oAddInEx:=AddToIncExp{}   // initialize add to income expense

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
		IF AScan(aMenu,{|x| x[4]=="TransactionEdit"})=0
			self:oCCOKButton:Hide()
			self:oCCSaveButton:Hide() 
			self:oCCTeleBankButton:Hide()
			self:oCCImportButton:Hide()
		ENDIF 
	endif
	if ADMIN="WA"
		self:oDCmPerson:Hide()
		self:oDCSC_CLN:Hide()
	endif
	oSel:=SQLSelect{"select payahead from bankaccount where banknumber='"+BANKNBRDEB+"'",oConn}
	if oSel:RecCount<1
		if oSel:RecCount>0
			mPayahead:=Str(oSel:PAYAHEAD,-1) 
		endif
	endif 


	RETURN NIL
METHOD PreInit(oWindow,iCtlID,oServer,uExtra) CLASS General_Journal
	//Put your PreInit additions here 
	local lAMPM as logic
IF (oServer = nil)
	GetHelpDir()
	lAMPM:=SetAmPm(false)
	self:oHlpMut:=TempTrans{HelpDir+"\HU"+StrTran(StrTran(Time(),":"),' ','')+".DBF",DBEXCLUSIVE} 
	SetAmPm(lAMPM)
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
METHOD ReturnButton( ) CLASS General_Journal 
	// mark transactions as Not Posted: 
	return self:PostButton(0)
METHOD SaveButton( ) CLASS General_Journal
	SELF:OKButton(TRUE)
	RETURN
METHOD TeleBankButton( ) CLASS General_Journal
	LOCAL oHm:=self:Server as TempTrans
	IF !self:oTmt==null_object
		self:oTmt:Close()
	endif
	self:oTmt:=TeleMut{FALSE,self} 
	if Empty(self:oTmt:m57_BankAcc)
		self:lTeleBank:=false
		return nil
	endif
	IF self:oTmt:NextTeleNonGift()
		oHm:OPP:=''
		oHm:cOpp:=''
		oHm:FROMRPP:=false
		self:oCCTeleBankButton:Hide()
		self:lTeleBank := true
		self:FillTeleBanking()
		IF self:oTmt:m56_autmut   //nog steeds herkend?
			self:OKButton()
		ENDIF
	ELSE
		self:lTeleBank := FALSE
		(WarningBox{self,"Journaling Records","No more Telebanking-data found"}):Show()
	ENDIF
	RETURN nil
STATIC DEFINE GENERAL_JOURNAL_BANKBALANCE := 125 
STATIC DEFINE GENERAL_JOURNAL_BANKTEXT := 124 
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
STATIC DEFINE GENERAL_JOURNAL_FINDCLOSE := 130 
STATIC DEFINE GENERAL_JOURNAL_FINDNEXT := 128 
STATIC DEFINE GENERAL_JOURNAL_FINDPREVIOUS := 129 
STATIC DEFINE GENERAL_JOURNAL_FINDTEXT := 127 
STATIC DEFINE GENERAL_JOURNAL_FOUND := 132 
STATIC DEFINE GENERAL_JOURNAL_FOUNDTEXT := 131 
STATIC DEFINE GENERAL_JOURNAL_GENERALJOURNAL1 := 108 
STATIC DEFINE GENERAL_JOURNAL_GIROTEXT := 120 
STATIC DEFINE GENERAL_JOURNAL_GROUPBOXFIND := 126 
STATIC DEFINE GENERAL_JOURNAL_IMPORTBUTTON := 123 
STATIC DEFINE GENERAL_JOURNAL_MBST := 100 
STATIC DEFINE GENERAL_JOURNAL_MDAT := 101 
STATIC DEFINE GENERAL_JOURNAL_MPERSON := 103 
STATIC DEFINE GENERAL_JOURNAL_MPOSTSTATUS := 102 
STATIC DEFINE GENERAL_JOURNAL_MTRANSAKTNR := 114 
STATIC DEFINE GENERAL_JOURNAL_OKBUTTON := 105 
STATIC DEFINE GENERAL_JOURNAL_PERSONBUTTON := 113 
STATIC DEFINE GENERAL_JOURNAL_POSTBUTTON := 106 
STATIC DEFINE GENERAL_JOURNAL_RECODERDBYTEXT := 122 
STATIC DEFINE GENERAL_JOURNAL_RETURNBUTTON := 112 
STATIC DEFINE GENERAL_JOURNAL_SAVEBUTTON := 104 
STATIC DEFINE GENERAL_JOURNAL_SC_BST := 116 
STATIC DEFINE GENERAL_JOURNAL_SC_CLN := 111 
STATIC DEFINE GENERAL_JOURNAL_SC_DAT := 118 
STATIC DEFINE GENERAL_JOURNAL_SC_TOTAL := 115 
STATIC DEFINE GENERAL_JOURNAL_SC_TRANSAKTNR1 := 119 
STATIC DEFINE GENERAL_JOURNAL_SC_TRANSAKTNR2 := 117 
STATIC DEFINE GENERAL_JOURNAL_TELEBANKBUTTON := 110 
STATIC DEFINE GENERAL_JOURNAL_USERDIDTXT := 121 
METHOD Init(oWindow) CLASS GeneralBrowser
	SUPER:Init(oWindow)
	SELF:ChangeBackground(Brush{Color{255,255,255}},GBLHITEXT)
	SELF:ChangeTextColor(ColorBlue,GBLHITEXT)
RETURN SELF
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
	export oCurr as Currency 
	export mXRate as float 
	export oOwner as General_Journal
	
	declare method DebCreProc
RESOURCE GeneralJournal1 DIALOGEX  78, 72, 620, 280
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Account:", GENERALJOURNAL1_SC_REK, "Static", WS_CHILD, 13, 14, 31, 13
	CONTROL	"Description:", GENERALJOURNAL1_SC_OMS, "Static", WS_CHILD, 13, 29, 39, 12
	CONTROL	"Debit:", GENERALJOURNAL1_SC_DEB, "Static", WS_CHILD, 13, 44, 21, 12
	CONTROL	"Credit:", GENERALJOURNAL1_SC_CRE, "Static", WS_CHILD, 13, 59, 22, 12
	CONTROL	"Assessment:", GENERALJOURNAL1_SC_GC, "Static", WS_CHILD, 13, 73, 41, 13
	CONTROL	"Soort:", GENERALJOURNAL1_SC_SOORT, "Static", WS_CHILD, 13, 88, 21, 12
	CONTROL	"Accountname:", GENERALJOURNAL1_SC_REKOMS, "Static", WS_CHILD, 13, 103, 48, 12
	CONTROL	"Account", GENERALJOURNAL1_ACCNUMBER, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 14, 90, 13, WS_EX_CLIENTEDGE
	CONTROL	"Description", GENERALJOURNAL1_DESCRIPTN, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 29, 431, 12, WS_EX_CLIENTEDGE
	CONTROL	"Debit", GENERALJOURNAL1_DEB, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 72, 44, 116, 12, WS_EX_CLIENTEDGE
	CONTROL	"Credit", GENERALJOURNAL1_CRE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 72, 59, 116, 12, WS_EX_CLIENTEDGE
	CONTROL	"Asmt", GENERALJOURNAL1_GC, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 72, 73, 33, 13, WS_EX_CLIENTEDGE
	CONTROL	"Soort:", GENERALJOURNAL1_SOORT, "Edit", ES_AUTOHSCROLL|WS_CHILD|WS_BORDER, 72, 88, 22, 12, WS_EX_CLIENTEDGE
	CONTROL	"Accountname", GENERALJOURNAL1_ACCDESC, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_DISABLED|WS_BORDER, 72, 103, 271, 12, WS_EX_CLIENTEDGE
END

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
			oBrowse:AddColumn(self:oDBCRE,self:oDBCREFORGN:VisualPos+1) 
			oBrowse:AddColumn(self:oDBDEB,self:oDBCREFORGN:VisualPos+1) 
			oBrowse:AddColumn(self:oDBCURRENCY,self:oDBCREFORGN:VisualPos+1) 
			self:Owner:SetWidth(self:Owner:Size:Width+=8*(self:oDBCREFORGN:Width+self:oDBDEBFORGN:Width+self:oDBCURRENCY:Width))
			if self:oCurr==null_object
				self:oCurr:=Currency{}
			endif                                
		endif
	elseif !lAddC
		oBrowse:RemoveColumn( self:oDBCRE)
		oBrowse:RemoveColumn( self:oDBDEB)
		oBrowse:RemoveColumn( self:oDBCURRENCY)
		self:Owner:SetWidth(self:Owner:Size:Width-=8*(self:oDBCREFORGN:Width+self:oDBDEBFORGN:Width+self:oDBCURRENCY:Width))
		self:Owner:lwaitingForExchrate:=false 
	endif 
	if !Empty(sToPP) .and. ADMIN=="WA"
		AEval(oHm:aMirror,{|x|lAddPP:=iif(x[1]==sToPP,true,lAddPP)})
		if oBrowse:GetColumn(#PPDEST)==nil 
			if lAddPP 
				oBrowse:AddColumn(self:oDBPPDEST,self:oDBREKOMS:VisualPos+1) 
				self:Owner:SetWidth(self:Owner:Size:Width+=8*self:oDBPPDEST:Width)
			endif
		elseif !lAddPP
			oBrowse:RemoveColumn( oDBPPDEST)
			self:Owner:SetWidth(self:Owner:Size:Width-=8*self:oDBPPDEST:Width)
		endif 
	endif
	if lAddC.or.lAddPP 
		oBrowse:Refresh()

// // 		if self:Owner:Size:Width <800
// // 			self:Owner:SetWidth(self:Owner:Size:Width+=164)
// 		if (self:Size:Width+40)> self:Owner:Size:Width
// 			self:Owner:SetWidth(self:Owner:Size:Width:=self:Size:Width+40)
// 			oBrowse:Refresh()
// 		endif
// 	else 
// // 		if self:Owner:Size:Width >=800
// // 			self:Owner:SetWidth(self:Owner:Size:Width-=164)
// 		if (self:Size:Width+40)< self:Owner:Size:Width
// 			self:Owner:SetWidth(self:Owner:Size:Width:=self:Size:Width+40)
// 			oBrowse:Refresh()
// 		endif
	endif
	oHm:RecNo:=nCurRec
	return
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
oDCSC_SOORT:HyperLabel := HyperLabel{#SC_SOORT,"Soort:",NULL_STRING,NULL_STRING}

oDCSC_REKOMS := FixedText{SELF,ResourceID{GENERALJOURNAL1_SC_REKOMS,_GetInst()}}
oDCSC_REKOMS:HyperLabel := HyperLabel{#SC_REKOMS,"Accountname:",NULL_STRING,NULL_STRING}

oDCAccNumber := SingleLineEdit{SELF,ResourceID{GENERALJOURNAL1_ACCNUMBER,_GetInst()}}
oDCAccNumber:FieldSpec := account_OMS{}
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
oDCSOORT:HyperLabel := HyperLabel{#SOORT,"Soort:",NULL_STRING,"Hulpmut_Soort"}

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

oDBACCNUMBER := JapDataColumn{account_OMS{}}
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

oDBDEBFORGN := JapDataColumn{transaction_DEBFORGN{}}
oDBDEBFORGN:Width := 9
oDBDEBFORGN:HyperLabel := HyperLabel{#DEBFORGN,"Debit","Debit amount in specified currency",NULL_STRING} 
oDBDEBFORGN:Caption := "Debit"
self:Browser:AddColumn(oDBDEBFORGN)

oDBCREFORGN := JapDataColumn{transaction_CREFORGN{}}
oDBCREFORGN:Width := 9
oDBCREFORGN:HyperLabel := HyperLabel{#CREFORGN,"Credit","credit amount in specified currency",NULL_STRING} 
oDBCREFORGN:Caption := "Credit"
self:Browser:AddColumn(oDBCREFORGN)

oDBGC := JapDataColumn{11}
oDBGC:Width := 11
oDBGC:HyperLabel := oDCGC:HyperLabel 
oDBGC:Caption := "Asmt"
self:Browser:AddColumn(oDBGC)

oDBCURRENCY := JapDataColumn{transaction_CURRENCY{}}
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
	oBrowse:RemoveColumn(self:oDBCURRENCY)
	oBrowse:RemoveColumn(self:oDBPPDEST)
	oBrowse:RemoveColumn(self:oDBDEB)
	oBrowse:RemoveColumn(self:oDBCRE)
	
	RETURN NIL
ACCESS PPDEST() CLASS GeneralJournal1
RETURN SELF:FieldGet(#PPDEST)

ASSIGN PPDEST(uValue) CLASS GeneralJournal1
SELF:FieldPut(#PPDEST, uValue)
RETURN uValue

method PreInit(oWindow,iCtlID,oServer,uExtra) class GeneralJournal1
	//Put your PreInit additions here 
	self:oOwner:=oWindow
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

ACCESS SOORT() CLASS GeneralJournal1
RETURN SELF:FieldGet(#SOORT)

ASSIGN SOORT(uValue) CLASS GeneralJournal1
SELF:FieldPut(#SOORT, uValue)
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
	PROTECT oDCEmployee AS COMBOBOX
	PROTECT oDCPostingStatus AS RADIOBUTTONGROUP
	PROTECT oCCRadioPost1 AS RADIOBUTTON
	PROTECT oCCRadioPost2 AS RADIOBUTTON
	PROTECT oCCRadioPost3 AS RADIOBUTTON
	PROTECT oCCRadioPost4 AS RADIOBUTTON
	PROTECT oDCSC_DEP AS FIXEDTEXT
	PROTECT oCCFromDepButton AS PUSHBUTTON
	PROTECT oDCFromDep AS SINGLELINEEDIT
	PROTECT oDCmAccnumber AS FIXEDTEXT
	PROTECT oDCmAccnumberTo AS FIXEDTEXT
	PROTECT oDCFixedText15 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
// 	protect oDep as Department
// 	Export oAcc as Account
//   	EXPORT oPers AS Person
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
	CONTROL	"", INQUIRYSELECTION_MTOACCOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 244, 14, 109, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", INQUIRYSELECTION_ACCBUTTONTO, "Button", WS_CHILD, 352, 14, 13, 13
	CONTROL	"maandag 8 mei 2017", INQUIRYSELECTION_FROMDATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 80, 36, 118, 14
	CONTROL	"maandag 8 mei 2017", INQUIRYSELECTION_TODATE, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 244, 38, 120, 14
	CONTROL	"From Date:", INQUIRYSELECTION_FIXEDTEXT3, "Static", WS_CHILD, 12, 36, 53, 13
	CONTROL	"Till:", INQUIRYSELECTION_FIXEDTEXT4, "Static", WS_CHILD, 204, 38, 17, 13
	CONTROL	"", INQUIRYSELECTION_FROMTRANSNR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 59, 66, 12, WS_EX_CLIENTEDGE
	CONTROL	"", INQUIRYSELECTION_TOTRANSNR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 243, 60, 67, 12, WS_EX_CLIENTEDGE
	CONTROL	"Minimal Amount", INQUIRYSELECTION_FROMAMOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 81, 66, 12, WS_EX_CLIENTEDGE
	CONTROL	"Maximum Amount", INQUIRYSELECTION_TOAMOUNT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 244, 81, 66, 12, WS_EX_CLIENTEDGE
	CONTROL	" Type", INQUIRYSELECTION_AMOUNTTYPE, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 324, 66, 40, 38
	CONTROL	"All", INQUIRYSELECTION_RADIOBUTTON1, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 328, 73, 24, 11
	CONTROL	"Debit", INQUIRYSELECTION_RADIOBUTTON2, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 328, 83, 32, 11
	CONTROL	"Credit", INQUIRYSELECTION_RADIOBUTTON3, "Button", BS_AUTORADIOBUTTON|WS_CHILD, 328, 92, 34, 11
	CONTROL	"Doc id:", INQUIRYSELECTION_DOCID, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 107, 66, 12
	CONTROL	"Description", INQUIRYSELECTION_DESCRIPTION, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 244, 107, 120, 12
	CONTROL	"", INQUIRYSELECTION_REFERENCE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 125, 66, 12, WS_EX_CLIENTEDGE
	CONTROL	"", INQUIRYSELECTION_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 80, 144, 105, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", INQUIRYSELECTION_PERSONBUTTON, "Button", WS_CHILD, 184, 144, 13, 12
	CONTROL	"From Transactionnbr:", INQUIRYSELECTION_FIXEDTEXT5, "Static", WS_CHILD, 12, 59, 68, 12
	CONTROL	"Till:", INQUIRYSELECTION_FIXEDTEXT6, "Static", WS_CHILD, 204, 60, 23, 13
	CONTROL	"Person:", INQUIRYSELECTION_FIXEDTEXT7, "Static", WS_CHILD, 12, 144, 53, 12
	CONTROL	"OK", INQUIRYSELECTION_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 316, 180, 53, 13
	CONTROL	"Reset", INQUIRYSELECTION_RESETBUTTON, "Button", WS_TABSTOP|WS_CHILD, 204, 180, 53, 13
	CONTROL	"Cancel", INQUIRYSELECTION_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 260, 180, 53, 13
	CONTROL	"Document id:", INQUIRYSELECTION_SC_BST, "Static", WS_CHILD, 12, 107, 50, 12
	CONTROL	"Amount Minimum:", INQUIRYSELECTION_SC_FROM, "Static", WS_CHILD, 12, 81, 61, 12
	CONTROL	"Maximum:", INQUIRYSELECTION_FIXEDTEXT8, "Static", WS_CHILD, 204, 81, 32, 13
	CONTROL	"Description:", INQUIRYSELECTION_FIXEDTEXT9, "Static", WS_CHILD, 204, 107, 38, 12
	CONTROL	"Reference", INQUIRYSELECTION_SC_REF, "Static", WS_CHILD, 12, 125, 53, 12
	CONTROL	"Till", INQUIRYSELECTION_FIXEDTEXT2, "Static", WS_CHILD, 204, 14, 16, 13
	CONTROL	"", INQUIRYSELECTION_EMPLOYEE, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 244, 122, 60, 72
	CONTROL	"Posting Status", INQUIRYSELECTION_POSTINGSTATUS, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD|NOT WS_VISIBLE, 308, 121, 64, 50
	CONTROL	"All", INQUIRYSELECTION_RADIOPOST1, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 312, 129, 55, 11
	CONTROL	"Ready to Post", INQUIRYSELECTION_RADIOPOST2, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 312, 139, 59, 11
	CONTROL	"Not Posted", INQUIRYSELECTION_RADIOPOST3, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 312, 149, 56, 11
	CONTROL	"Posted", INQUIRYSELECTION_RADIOPOST4, "Button", BS_AUTORADIOBUTTON|WS_CHILD|NOT WS_VISIBLE, 312, 158, 55, 11
	CONTROL	"Department From:", INQUIRYSELECTION_SC_DEP, "Static", WS_CHILD|NOT WS_VISIBLE, 12, 162, 67, 12
	CONTROL	"v", INQUIRYSELECTION_FROMDEPBUTTON, "Button", WS_CHILD|NOT WS_VISIBLE, 184, 162, 13, 12
	CONTROL	"", INQUIRYSELECTION_FROMDEP, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE|WS_BORDER, 80, 162, 105, 12, WS_EX_CLIENTEDGE
	CONTROL	"", INQUIRYSELECTION_MACCNUMBER, "Static", SS_CENTERIMAGE|WS_CHILD, 80, 0, 63, 12
	CONTROL	"", INQUIRYSELECTION_MACCNUMBERTO, "Static", SS_CENTERIMAGE|WS_CHILD, 244, 0, 63, 12
	CONTROL	"Employee:", INQUIRYSELECTION_FIXEDTEXT15, "Static", WS_CHILD, 204, 122, 38, 12
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
		IF oControl:Name == "MPERSON".and.!AllTrim(oControl:VALUE)==AllTrim(self:cGiverName)
			self:cGiverName:=AllTrim(oControl:textVALUE)
			self:PersonButton(true)
		ELSEIF oControl:Name == "MACCOUNT"
			IF !Upper(AllTrim(oControl:textVALUE))==Upper(self:cAccName)
				self:cAccName:=AllTrim(oControl:VALUE)
				SELF:AccButton(TRUE)
			ENDIF
		ELSEIF oControl:Name == "MTOACCOUNT"
			IF !Upper(AllTrim(oControl:textVALUE))==Upper(self:cAccNameTo)
				self:cAccNameTo:=AllTrim(oControl:VALUE)
				self:AccButtonTo(true)
			ENDIF
		elseIF oControl:NameSym==#FromDep .and.!AllTrim(oControl:VALUE)==self:cCurDep
			self:cCurDep:=AllTrim(oControl:VALUE)
			cCurValue:=self:cCurDep
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
ACCESS Employee() CLASS InquirySelection
RETURN SELF:FieldGet(#Employee)

ASSIGN Employee(uValue) CLASS InquirySelection
SELF:FieldPut(#Employee, uValue)
RETURN uValue

Method FillEmployee()  CLASS InquirySelection
return FillOPC()
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
oDCFromdate:HyperLabel := HyperLabel{#Fromdate,NULL_STRING,NULL_STRING,NULL_STRING}
oDCFromdate:FieldSpec := transaction_DAT{}

oDCTodate := DateStandard{SELF,ResourceID{INQUIRYSELECTION_TODATE,_GetInst()}}
oDCTodate:HyperLabel := HyperLabel{#Todate,NULL_STRING,NULL_STRING,NULL_STRING}
oDCTodate:FieldSpec := transaction_DAT{}

oDCFixedText3 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"From Date:",NULL_STRING,NULL_STRING}

oDCFixedText4 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT4,_GetInst()}}
oDCFixedText4:HyperLabel := HyperLabel{#FixedText4,"Till:",NULL_STRING,NULL_STRING}

oDCFromTransnr := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_FROMTRANSNR,_GetInst()}}
oDCFromTransnr:HyperLabel := HyperLabel{#FromTransnr,NULL_STRING,NULL_STRING,NULL_STRING}
oDCFromTransnr:Picture := "99999999999"

oDCToTransnr := SingleLineEdit{SELF,ResourceID{INQUIRYSELECTION_TOTRANSNR,_GetInst()}}
oDCToTransnr:HyperLabel := HyperLabel{#ToTransnr,NULL_STRING,NULL_STRING,NULL_STRING}
oDCToTransnr:Picture := "99999999999"

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
oDCmPerson:Picture := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

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

oDCEmployee := combobox{SELF,ResourceID{INQUIRYSELECTION_EMPLOYEE,_GetInst()}}
oDCEmployee:TooltipText := "Employee who updated transaction"
oDCEmployee:HyperLabel := HyperLabel{#Employee,NULL_STRING,NULL_STRING,NULL_STRING}
oDCEmployee:FillUsing(Self:FillEmployee( ))

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

oDCmAccnumber := FixedText{SELF,ResourceID{INQUIRYSELECTION_MACCNUMBER,_GetInst()}}
oDCmAccnumber:HyperLabel := HyperLabel{#mAccnumber,NULL_STRING,NULL_STRING,NULL_STRING}

oDCmAccnumberTo := FixedText{SELF,ResourceID{INQUIRYSELECTION_MACCNUMBERTO,_GetInst()}}
oDCmAccnumberTo:HyperLabel := HyperLabel{#mAccnumberTo,NULL_STRING,NULL_STRING,NULL_STRING}

oDCFixedText15 := FixedText{SELF,ResourceID{INQUIRYSELECTION_FIXEDTEXT15,_GetInst()}}
oDCFixedText15:HyperLabel := HyperLabel{#FixedText15,"Employee:",NULL_STRING,NULL_STRING}

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

SELF:Caption := "Selection of Financial Transactions"
SELF:HyperLabel := HyperLabel{#InquirySelection,"Selection of Financial Transactions",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True
SELF:QuitOnClose := False

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
 	self:oOwner:Employee:=ConS(self:Employee)
 	self:oOwner:StartDate:=self:oDCFromdate:SelectedDate
	self:oOwner:EndDate:=self:oDCTodate:SelectedDate
 	self:oOwner:StartAmount:=AllTrim(self:oDCFromAmount:TextValue )
 	self:oOwner:ToAmount:=AllTrim(self:oDCToAmount:TextValue)
 	
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
	if !Empty(self:oOwner) .and. !Empty(self:oOwner:ShowSelection())
		self:EndWindow()
	endif
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
	local aBal as array
	self:SetTexts()
	SaveUse(self)
	self:oOwner:=uExtra[1]
	self:odcfromdate:SelectedDate:=MinDate
	if Today()-MinDate > 400
		aBal:=getbalYear(Year(Today()),month(Today()))
		if Len(aBal)>0
			self:odcfromdate:SelectedDate:=SToD(Str(aBal[1],4,0)+StrZero(aBal[2],2,0)+'01')
			if self:odcfromdate:SelectedDate<MinDate
				self:odcfromdate:SelectedDate:=MinDate
			endif
		endif
	endif

	// 	FillBalYears()
	if !Empty(GlBalYears)
		OldestYear:=GlBalYears[Len(GlBalYears),1] 
	else
		OldestYear:=MinDate
	endif
	self:odcfromdate:DateRange:=DateRange{OldestYear,Today()+31}
	self:oDCTodate:SelectedDate:=Today()+30
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
		self:cGiverName := GetFullName(self:mCLNGiver)
		self:oDCmPerson:TextValue := self:cGiverName
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
		self:odcfromdate:SelectedDate:=self:oOwner:StartDate
	ENDIF
	IF !Empty(self:oOwner:EndDate)
		self:oDCTodate:SelectedDate:=self:oOwner:EndDate
	ENDIF
	IF !Empty(Val(self:oOwner:StartAmount))
		self:FromAmount:=self:oOwner:StartAmount
	ENDIF
	IF !Empty(Val(self:oOwner:ToAmount))
		self:ToAmount:=self:oOwner:ToAmount
	ENDIF
	IF !Empty(self:oOwner:DescrpSelected)
		self:oDCDescription:TextValue:=self:oOwner:DescrpSelected
	ENDIF 
	IF !Empty(self:oOwner:ReferenceSelected)
		self:oDCReference:TextValue:=self:oOwner:ReferenceSelected
	ENDIF
	IF !Empty(self:oOwner:ReferenceSelected)
		self:oDCReference:TextValue:=self:oOwner:ReferenceSelected
	ENDIF
	IF !Empty(self:oOwner:Employee)
		self:employee:=self:oOwner:employee
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
STATIC DEFINE INQUIRYSELECTION_EMPLOYEE := 134 
STATIC DEFINE INQUIRYSELECTION_FIXEDTEXT1 := 100 
STATIC DEFINE INQUIRYSELECTION_FIXEDTEXT15 := 145 
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
STATIC DEFINE INQUIRYSELECTION_FROMDEP := 142 
STATIC DEFINE INQUIRYSELECTION_FROMDEPBUTTON := 141 
STATIC DEFINE INQUIRYSELECTION_FROMTRANSNR := 109 
STATIC DEFINE INQUIRYSELECTION_MACCNUMBER := 143 
STATIC DEFINE INQUIRYSELECTION_MACCNUMBERTO := 144 
STATIC DEFINE INQUIRYSELECTION_MACCOUNT := 101 
STATIC DEFINE INQUIRYSELECTION_MPERSON := 120 
STATIC DEFINE INQUIRYSELECTION_MTOACCOUNT := 103 
STATIC DEFINE INQUIRYSELECTION_OKBUTTON := 125 
STATIC DEFINE INQUIRYSELECTION_PERSONBUTTON := 121 
STATIC DEFINE INQUIRYSELECTION_POSTINGSTATUS := 135 
STATIC DEFINE INQUIRYSELECTION_RADIOBUTTON1 := 114 
STATIC DEFINE INQUIRYSELECTION_RADIOBUTTON2 := 115 
STATIC DEFINE INQUIRYSELECTION_RADIOBUTTON3 := 116 
STATIC DEFINE INQUIRYSELECTION_RADIOPOST1 := 136 
STATIC DEFINE INQUIRYSELECTION_RADIOPOST2 := 137 
STATIC DEFINE INQUIRYSELECTION_RADIOPOST3 := 138 
STATIC DEFINE INQUIRYSELECTION_RADIOPOST4 := 139 
STATIC DEFINE INQUIRYSELECTION_REFERENCE := 119 
STATIC DEFINE INQUIRYSELECTION_RESETBUTTON := 126 
STATIC DEFINE INQUIRYSELECTION_SC_BST := 128 
STATIC DEFINE INQUIRYSELECTION_SC_DEP := 140 
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
	AEval(oHm:aMirror,{|x|lAdd:=iif(x[10]==sCurr.or.Empty(x[10]),iif(x[11],true,lAdd),true) })
	if oBrowse:GetColumn(#Currency)==nil 
		if lAdd 
			oBrowse:AddColumn({oDBCURRENCY,oDBCRE},oDBGC) 
			self:Owner:SetWidth(self:Owner:Size:Width+=7*(self:oDBCRE:Width+self:oDBCURRENCY:Width)) 
			if self:oCurr==null_object 
				self:oCurr:=Currency{}
			endif
			oBrowse:Refresh() 
		endif
	elseif !lAdd
		if !oBrowse:RemoveColumn( oDBCRE)==null_object
			oBrowse:RemoveColumn( oDBCURRENCY)
			self:Owner:SetWidth(self:Owner:Size:Width-=7*(self:oDBCRE:Width+self:oDBCURRENCY:Width))
			oBrowse:Refresh()
		endif
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
oDCDescriptn:FieldSpec := transaction_OMS{}
oDCDescriptn:HyperLabel := HyperLabel{#Descriptn,"Description",NULL_STRING,"Transaction_OMS"}
oDCDescriptn:FocusSelect := FSEL_HOME

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

oDBDESCRIPTN := JAPDataColumn{transaction_OMS{}}
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
	LOCAL oBrowse:=self:Browser as PaymentBrowser 
self:SetTexts()
	self:server:oBrowse := oBrowse
	IF !(ADMIN=="WO".or.ADMIN=="HO")
		* remove assessment column:
		SELF:Browser:RemoveColumn(oDBGC)
	ENDIF
	oDBCRE:Caption := "Credit "+sCURR
	oDBCRE:SetStandardStyle(gbsReadOnly) 
	oBrowse:RemoveColumn(self:oDBCURRENCY)
	oBrowse:RemoveColumn(self:oDBCRE)
	RETURN nil
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
RESOURCE PaymentJournal DIALOGEX  48, 44, 458, 337
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Person:", PAYMENTJOURNAL_SC_CLN, "Static", WS_CHILD, 274, 18, 28, 12
	CONTROL	"Document id:", PAYMENTJOURNAL_SC_BST, "Static", WS_CHILD, 5, 3, 47, 12
	CONTROL	"Date:", PAYMENTJOURNAL_SC_DAT, "Static", WS_CHILD, 100, 2, 20, 12
	CONTROL	"Amount left for recording:", PAYMENTJOURNAL_SC_TOTAL, "Static", WS_CHILD, 4, 314, 83, 12
	CONTROL	"with balance:", PAYMENTJOURNAL_FIXEDTEXT8, "Static", WS_CHILD, 6, 36, 44, 12
	CONTROL	"", PAYMENTJOURNAL_CURTEXT1, "Static", WS_CHILD, 124, 35, 18, 13
	CONTROL	"", PAYMENTJOURNAL_CURTEXT2, "Static", WS_CHILD, 399, 36, 17, 12
	CONTROL	"", PAYMENTJOURNAL_DEBBALANCE, "Edit", ES_READONLY|ES_AUTOHSCROLL|WS_CHILD|WS_DISABLED|WS_BORDER, 55, 35, 62, 13, WS_EX_CLIENTEDGE
	CONTROL	"Prior transaction:", PAYMENTJOURNAL_SC_TRANSAKTNR, "Static", WS_CHILD, 336, 3, 56, 13
	CONTROL	"", PAYMENTJOURNAL_MBST, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 56, 2, 39, 12
	CONTROL	"woensdag 6 november 2013", PAYMENTJOURNAL_MDAT, "SysDateTimePick32", DTS_LONGDATEFORMAT|WS_TABSTOP|WS_CHILD, 120, 1, 124, 14
	CONTROL	"", PAYMENTJOURNAL_DEBITACCOUNT, "ComboBox", CBS_DISABLENOSCROLL|CBS_SORT|CBS_DROPDOWN|WS_TABSTOP|WS_CHILD|WS_VSCROLL, 56, 19, 105, 72
	CONTROL	"", PAYMENTJOURNAL_MPERSON, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 306, 19, 119, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", PAYMENTJOURNAL_PERSONBUTTON, "Button", WS_CHILD, 424, 19, 14, 13
	CONTROL	"", PAYMENTJOURNAL_MDEBAMNTF, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 306, 35, 88, 13, WS_EX_CLIENTEDGE
	CONTROL	"", PAYMENTJOURNAL_PAYMENTDETAILS, "static", WS_TABSTOP|WS_CHILD|WS_BORDER, 6, 72, 433, 221
	CONTROL	"OK", PAYMENTJOURNAL_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 382, 315, 60, 13
	CONTROL	"Cancel", PAYMENTJOURNAL_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 316, 315, 60, 13
	CONTROL	"Telebanking...", PAYMENTJOURNAL_TELEBANKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 316, 299, 60, 12
	CONTROL	"No Earmark...", PAYMENTJOURNAL_NONEARMARKED, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 382, 299, 60, 12
	CONTROL	"", PAYMENTJOURNAL_MTRANSAKTNR, "Edit", ES_READONLY|ES_AUTOHSCROLL|ES_NUMBER|WS_CHILD|WS_BORDER, 396, 3, 41, 11
	CONTROL	"", PAYMENTJOURNAL_DEBITCREDITTEXT, "Static", WS_CHILD|WS_BORDER, 86, 314, 73, 12, WS_EX_CLIENTEDGE
	CONTROL	"Debit account:", PAYMENTJOURNAL_FIXEDTEXT6, "Static", WS_CHILD, 5, 20, 49, 12
	CONTROL	"Amount received:", PAYMENTJOURNAL_FIXEDTEXT7, "Static", WS_CHILD, 244, 35, 60, 13
	CONTROL	"", PAYMENTJOURNAL_CGIROTELTEXT, "Static", WS_CHILD, 6, 51, 433, 19
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

	PROTECT oTmt as TeleMut
	EXPORT lTeleBank as LOGIC
	PROTECT lEarmarking as LOGIC

	EXPORT fTotal as FLOAT
	Export mCLNGiver as STRING
	PROTECT cGiverName, cOrigName as STRING
	EXPORT lMemberGiver as LOGIC
	PROTECT DebAccNbr,DebAccId, DebCln, DebCurrency,DebCategory as STRING
	PROTECT DefBest, DefOms, DefGc, DefNbr, DefMlcd, DefCur,DefType,Defincexpfd,Defaccounttype as STRING,DefOvrd, DefMulti as logic
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
	export oAddInEx as AddToIncExp
	declare method FillTeleBanking, InitGifts,AccntProc,AssignTo,Totalise, ValStore,ValidateTempGift
method AddCur() class PaymentJournal
	self:oSFPaymentDetails:AddCurr()
	return
Method bankanalyze() class PaymentJournal
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
	if !Empty(self:DebAccId) 
		oSel:=SqlSelect{"select ba.giftsall,ba.openall,ba.singledst,ba.fgmlcodes,ba.syscodover,b.category,a.description,a.accnumber,a.currency,a.multcurr,m.persid,"+SQLIncExpFd()+" as incexpfd,"+SQLAccType()+" as accounttype "+;
			"from bankaccount ba left join account a on (a.accid=ba.singledst and a.active=1) right join balanceitem b on (b.balitemid=a.balitemid) left join member m on (m.accid=a.accid or m.depid=a.department) left join department d on (d.depid=m.depid) "+;
			"where ba.accid='"+self:DebAccId+"'",oConn}
		if oSel:reccount>0  
			self:GiftsAutomatic:=iif(ConI(oSel:GIFTSALL)=1,true,false)
			self:DueAutomatic:=iif(ConI(oSel:OPENALL)=1,true,false)
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
					self:DefMulti:=iif(ConI(oSel:MULTCURR)=1,true,false) 
					self:DefMlcd:=oSel:FGMLCODES
					self:DefOvrd:=iif(oSel:SYSCODOVER="O",true,false)
					self:DefType:=oSel:category
					self:Defincexpfd:=oSel:incexpfd
					self:Defaccounttype:=oSel:accounttype
				endif
			endif
		ENDIF
	endif


METHOD CancelButton( ) CLASS PaymentJournal
LOCAL oBox AS WarningBox
LOCAL oHm as TempGift

IF SELF:lEarMarking
// 	self:oTrans:GoTo(nEarmarkTrans)
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
	self:oSFPaymentDetails:Close()
	self:EndWindow()

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
	LOCAL aDebAccs := {} as ARRAY
	local oBank,oAcc as SQLSelect
	oBank:=SqlSelect{"select a.currency,a.description,b.accid,a.accnumber from bankaccount b, account a where a.accid=b.accid and b.telebankng=0 and a.active=1 and b.usedforgifts=1 order by a.description", oConn}
	oBank:Execute() 
	do WHILE !oBank:EOF
		AAdd(aDebAccs,{oBank:Description,oBank:AccID})
		IF Empty(cBankPreSet) 
			cBankPreSet := oBank:Description
			self:DebAccNbr:=oBank:Description
			self:DebAccId:=Str(oBank:AccID,-1) 
			self:DebCurrency:=oBank:CURRENCY
			self:ShowDebBal()
		ENDIF                                       
		oBank:Skip()
	ENDDO
	IF Empty(cBankPreSet).and.oBank:reccount>0
		oBank:GoBottom()
		cBankPreSet := oBank:Description
		self:DebAccNbr:=oBank:Description
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
				self:DebAccNbr:= oAcc:Description
				self:DebAccId:=SKAS
				self:DebCurrency:=oAcc:CURRENCY
				self:ShowDebBal()
			ENDIF
		endif
	ENDIF
	AAdd(aDebAccs,{"<Other>",''}) 
	RETURN aDebAccs
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS PaymentJournal
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !IsNil(oControl:Value)
		IF oControl:Name == "MPERSON".and.!AllTrim(oControl:VALUE)==AllTrim(self:cGiverName)
			IF Empty(oControl:Value) && leeg gemaakt?
				SELF:mCLNGiver :=  ""
				SELF:cGiverName := ""
				SELF:oDCmPerson:TEXTValue := ""
			ELSE
				self:cOrigName:=AllTrim(self:cGiverName)
				self:cGiverName:=AllTrim(oControl:VALUE)
				if !self:cGiverName==self:cOrigName
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
			self:oSFPaymentDetails:Browser:Refresh()
		elseif oControl:NameSym==#DebitAccount .and.!AllTrim(oControl:TEXTValue)==self:DebAccNbr
			GiftsAutomatic:=FALSE
			DueAutomatic:=FALSE
			if self:oDCDebitAccount:CurrentItemNo=0
				// nothing seleted:
				self:DebAccId:=''
			elseif Empty(oControl:VALUE)  //other:
				// 			AccountSelect(self,"","DEBITACCOUNT",FALSE,cAccFilter,,oAcc)
				AccountSelect(self,"","DEBITACCOUNT")
				self:ShowDebBal()
				IF MultiDest
					self:DefBest := ""
					self:DefOms := ""
					self:DefNbr:=""
					self:DefGc := "" 
					self:DebCategory:=''
				endif
			else
				self:oDCDebitAccount:SelectItem(self:oDCDebitAccount:CurrentItemNo) 
				self;oDCDebitAccount:TEXTValue:=self:oDCDebitAccount:GetItem(self:oDCDebitAccount:CurrentItemNo)
				self:DebAccId := AllTrim(Transform(self:oDCDebitAccount:GetItemValue(self:oDCDebitAccount:CurrentItemNo),"")) 
				self:DebAccNbr:=self:oDCDebitAccount:TEXTValue
				self:ShowDebBal()
				self:lMemberGiver := FALSE
				self:bankanalyze()
			ENDIF
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
		self:oDCDebitAccount:CurrentItemNo := self:oDCDebitAccount:FindItem(self:cBankPreSet,FALSE)
// 		oDCDebitAccount:FindItem(self:cBankPreSet,FALSE)
		SELF:ShowDebBal()
RETURN
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS PaymentJournal 
LOCAL DIM aBrushes[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"PaymentJournal",_GetInst()},iCtlID)

aBrushes[1] := Brush{Color{COLORWHITE}}

oDCSC_CLN := FixedText{SELF,ResourceID{PAYMENTJOURNAL_SC_CLN,_GetInst()}}
oDCSC_CLN:HyperLabel := HyperLabel{#SC_CLN,"Person:",NULL_STRING,NULL_STRING}
oDCSC_CLN:OwnerAlignment := OA_X

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
oDCCurText2:OwnerAlignment := OA_X

oDCDebbalance := SingleLineEdit{SELF,ResourceID{PAYMENTJOURNAL_DEBBALANCE,_GetInst()}}
oDCDebbalance:HyperLabel := HyperLabel{#Debbalance,NULL_STRING,NULL_STRING,NULL_STRING}
oDCDebbalance:FieldSpec := MBalance_DEB{}

oDCSC_TRANSAKTNR := FixedText{SELF,ResourceID{PAYMENTJOURNAL_SC_TRANSAKTNR,_GetInst()}}
oDCSC_TRANSAKTNR:HyperLabel := HyperLabel{#SC_TRANSAKTNR,"Prior transaction:",NULL_STRING,NULL_STRING}
oDCSC_TRANSAKTNR:OwnerAlignment := OA_X

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
oDCmPerson:OwnerAlignment := OA_X

oCCPersonButton := PushButton{SELF,ResourceID{PAYMENTJOURNAL_PERSONBUTTON,_GetInst()}}
oCCPersonButton:HyperLabel := HyperLabel{#PersonButton,"v","Browse in persons",NULL_STRING}
oCCPersonButton:TooltipText := "Browse in Persons"
oCCPersonButton:OwnerAlignment := OA_X

oDCmDebAmntF := mySingleEdit{SELF,ResourceID{PAYMENTJOURNAL_MDEBAMNTF,_GetInst()}}
oDCmDebAmntF:FieldSpec := TRANSACTION_DEB{}
oDCmDebAmntF:HyperLabel := HyperLabel{#mDebAmntF,NULL_STRING,"Amount received",NULL_STRING}
oDCmDebAmntF:UseHLforToolTip := True
oDCmDebAmntF:OwnerAlignment := OA_X

oCCOKButton := PushButton{SELF,ResourceID{PAYMENTJOURNAL_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}
oCCOKButton:OwnerAlignment := OA_X_Y

oCCCancelButton := PushButton{SELF,ResourceID{PAYMENTJOURNAL_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}
oCCCancelButton:OwnerAlignment := OA_X_Y

oCCTelebankButton := PushButton{SELF,ResourceID{PAYMENTJOURNAL_TELEBANKBUTTON,_GetInst()}}
oCCTelebankButton:HyperLabel := HyperLabel{#TelebankButton,"Telebanking...","Processing of telebanking transactions",NULL_STRING}
oCCTelebankButton:TooltipText := "Proces Telebanking transactions"
oCCTelebankButton:OwnerAlignment := OA_X_Y

oCCNonEarmarked := PushButton{SELF,ResourceID{PAYMENTJOURNAL_NONEARMARKED,_GetInst()}}
oCCNonEarmarked:HyperLabel := HyperLabel{#NonEarmarked,"No Earmark...",NULL_STRING,NULL_STRING}
oCCNonEarmarked:TooltipText := "Allotting of non-earmarked gifts"
oCCNonEarmarked:OwnerAlignment := OA_X_Y

oDCmTRANSAKTNR := SingleLineEdit{SELF,ResourceID{PAYMENTJOURNAL_MTRANSAKTNR,_GetInst()}}
oDCmTRANSAKTNR:HyperLabel := HyperLabel{#mTRANSAKTNR,NULL_STRING,NULL_STRING,"Transaction_TRANSAKTNR"}
oDCmTRANSAKTNR:OwnerAlignment := OA_X

oDCDebitCreditText := FixedText{SELF,ResourceID{PAYMENTJOURNAL_DEBITCREDITTEXT,_GetInst()}}
oDCDebitCreditText:HyperLabel := HyperLabel{#DebitCreditText,NULL_STRING,NULL_STRING,NULL_STRING}
oDCDebitCreditText:TextColor := Color{COLORBLUE}
oDCDebitCreditText:BackGround := aBrushes[1]
oDCDebitCreditText:OwnerAlignment := OA_Y

oDCFixedText6 := FixedText{SELF,ResourceID{PAYMENTJOURNAL_FIXEDTEXT6,_GetInst()}}
oDCFixedText6:HyperLabel := HyperLabel{#FixedText6,"Debit account:",NULL_STRING,NULL_STRING}

oDCFixedText7 := FixedText{SELF,ResourceID{PAYMENTJOURNAL_FIXEDTEXT7,_GetInst()}}
oDCFixedText7:HyperLabel := HyperLabel{#FixedText7,"Amount received:",NULL_STRING,NULL_STRING}
oDCFixedText7:OwnerAlignment := OA_X

oDCcGirotelText := FixedText{SELF,ResourceID{PAYMENTJOURNAL_CGIROTELTEXT,_GetInst()}}
oDCcGirotelText:HyperLabel := HyperLabel{#cGirotelText,NULL_STRING,NULL_STRING,NULL_STRING}
oDCcGirotelText:OwnerAlignment := OA_PWIDTH

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
	IF oControlEvent:Name == "DEBITACCOUNT"  .and. !AllTrim(oControl:TextValue)==self:DebAccNbr
		GiftsAutomatic:=FALSE
		DueAutomatic:=FALSE
		if self:oDCDebitAccount:CurrentItemNo=0
			// nothing seleted:
			self:DebAccId:=''
			self:DebAccNbr:=""
		elseif Empty(oControl:VALUE)  //other:
			// 			AccountSelect(self,"","DEBITACCOUNT",FALSE,cAccFilter,,oAcc) 
			self:DebAccId := '' 
			self:DebAccNbr:=AllTrim(oControl:TextVALUE)
			AccountSelect(self,"","DEBITACCOUNT")
			self:ShowDebBal()
			IF MultiDest
				self:DefBest := ""
				self:DefOms := ""
				self:DefNbr:=""
				self:DefGc := "" 
				self:DebCategory:=''
			endif
		else  
			self:DebAccId := AllTrim(Transform(oControl:VALUE,"")) 
			self:DebAccNbr:=AllTrim(oControl:TextVALUE)
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
		self:nEarmarkTrans:=0 
		self:nEarmarkSeqnr:=0
		oAcc:=SQLSelect{"select a.accnumber,a.description,b.category as debcat from account a, balanceitem b where b.balitemid=a.balitemid and accid="+SPROJ,oConn}
		if oAcc:RecCount>0
			self:DebAccId:=sproj
			self:DebAccNbr:=oAcc:Description
			self:DebCategory:=oAcc:debcat
			self:oDCDebitAccount:CurrentText  := oAcc:Description
			self:ShowDebBal()
		ENDIF
	endif
	* Search for next non-earmarked gift (BFM=O):
	oTransEM:=SQLSelect{"select transid,seqnr,deb,cre,debforgn,creforgn,currency,cast(dat as date) as dat,persid,docid from transaction where accid="+sproj+" and bfm='O' and cre>deb"+;
	iif(Empty(self:nEarmarkTrans),""," and transid*1000+seqnr>"+Str(self:nEarmarkTrans*1000+self:nEarmarkSeqnr,-1))+;
	+" order by transid,seqnr limit 1",oConn}
	IF oTransEM:RecCount<1
		(WarningBox{self,oLan:WGet("Recording Gifts"),self:oLan:WGet("No "+iif(self:lEarmarking,"more ","")+"non-designated gifts found")}):Show()
		if self:lEarmarking
			self:lEarmarking:=FALSE
			self:oDCmBST:Enable()
			self:oDCmDat:Enable()
			self:oDCDebitAccount:Enable()
			self:oDCmDebAmntF:Enable()
			self:oDCmPerson:Enable()
			self:mDAT := Today()
			self:mBst := ""
			self:mDebAmnt := 0
			self:mDebAmntF := 0
			self:nEarmarkTrans:=0 
			self:nEarmarkSeqnr:=0
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
	oHm:DESCRIPTN:=oLan:RGet("Allotted non-designated gift",,"!")
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
	IF self:lEarmarking
		IF !SELF:NonEarmarked()
			SELF:oCCNonEarmarked:Show()
			IF TeleBanking .or. AutoGiro
				oCCTeleBankButton:Show()
			ENDIF
		ENDIF		
	ENDIF
	
	DO WHILE lTeleBank
		oTmt:CloseMut(self:server)
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
		oPersCnt:recognized := self:Recognised
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
	SaveUse(self)
	oCurr:=Currency{}  
	self:Server:oLan:=self:oLan
	self:Server:oBrowse := self:oSFPaymentDetails:Browser
	// 	self:oDCDebitAccount:SetFocus()
	self:oDCDebitAccount:CurrentItemNo := self:oDCDebitAccount:FindItem(self:cBankPreSet,FALSE)
	self:mDebAmntF:=0
	self:mDebAmnt:=0 
	self:oDCmBST:SetFocus()
	oAddInEx:=AddToIncExp{}   // initialize add to income expense
	IF MultiDest
		self:bankanalyze()
	else
		* Check in case of home front system if there is only one destination:
		oSel:=SQLSelect{"select a.accid,a.description,a.accnumber,a.CURRENCY,a.multcurr,b.category as acctype,m.persid from balanceitem b, account a left join member m on (a.accid=m.accid) "+;
			" where a.giftalwd=1 and a.balitemid=b.balitemid and a.active=1",oConn}
		if oSel:reccount=1
			self:DefBest := Str(oSel:AccID,-1)
			self:DefOms := oSel:Description
			self:DefNbr:=oSel:ACCNUMBER
			self:DefCur:=oSel:Currency
			self:DefMulti:=iif(ConI(oSel:MULTCURR)=1,true,false) 
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
	if SQLSelect{"select accid from bankaccount where telebankng=1 and usedforgifts=1",oConn}:reccount>0
		TeleBanking := true 
	else
		TeleBanking := FALSE
		if !AutoGiro
			oCCTeleBankButton:Hide()
		endif
	ENDIF
	
	oSel:=SQLSelect{"select accid from bankaccount where telebankng=1",oConn} 
	oSel:Execute()
	DO WHILE !oSel:EOF
		self:cAccFilter:=if(Empty(self:cAccFilter),"",self:cAccFilter+',')+Str(oSel:AccID,-1)
		oSel:Skip()
	ENDDO
	if !Empty(self:cAccFilter)
		self:cAccFilter:="a.active=1 and a.accid not in ("+self:cAccFilter+")"
	else
		self:cAccFilter:="a.active=1"
	endif
	oSel:=SQLSelect{"select accid from bankaccount",oConn} 
	oSel:Execute()
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
	// 	self:cDestFilter+=" and (a.giftalwd=1"+iif(empty(sdeb),""," or a.accid="+sdeb)+")"
	
	IF !Empty(SPROJ)
		* check if there are non earmarked gifts: 
		if SQLSelect{"select accid from transaction where accid="+SPROJ+" and bfm='O' limit 1",oConn}:reccount>0
			oCCNonEarmarked:Show()
		endif
	endif
	IF AScan(aMenu,{|x| x[4]=="TransactionEdit"})=0
		self:oCCOKButton:Hide() 
		self:oCCTeleBankButton:Hide()
	ENDIF
//    self:AddCur()

	RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class PaymentJournal
	//Put your PreInit additions here
	GetHelpDir()
	self:oHlpMut:=TempGift{HelpDir+"\HG"+StrTran(StrTran(Time(),":"),' ','')+".DBF",DBEXCLUSIVE,DBREADWRITE}
	return nil
METHOD ShowDebBal() CLASS PaymentJournal 
	local lSucc as logic
	local oSel as SQLSelect
	local omBal as Balances
	if Empty(self:DebAccId)
		return
	endif
	oSel:=SqlSelect{"select accnumber,accid,currency,b.category from account a, balanceitem b where accid='"+self:DebAccId+"' and b.balitemid=a.balitemid limit 1",oConn}
	if oSel:reccount>0
// 		self:DebAccNbr:=oSel:ACCNUMBER 
		self:DebCurrency:=oSel:CURRENCY
		self:DebCategory:=oSel:category
	else
		return
	ENDIF
	// if !self:DebCurrency==sCurr .and. self:oCurr==null_object
	// 	self:oCurr:=Currency{}
	// endif
	omBal:=Balances{}
	omBal:GetBalance( self:DebAccId,,,self:DebCurrency)
	if self:DebCurrency==sCurr
		self:DebBalance:=round(omBal:per_deb-omBal:per_cre,decaantal)
	else 
		self:DebBalance:=Round(omBal:per_debF-omBal:per_creF,DecAantal)
	endif 
	self:oDCDebbalance:Value:=self:DebBalance
	self:oDCCurText1:Value :=self:DebCurrency 
	self:oDCCurText2:Value:=self:DebCurrency 
	// determine single destination:

	RETURN
METHOD TeleBankButton( ) CLASS PaymentJournal
	LOCAL lSuccess as LOGIC
	IF !self:oTmt==null_object
		self:oTmt:Close()
	endif
	self:oTmt:=TeleMut{true,self} 
	if Empty(self:oTmt:m57_BankAcc)
		self:lTeleBank:=false
		return nil
	endif

	IF self:oTmt:NextTeleGift()
		self:oCCTeleBankButton:Hide()
		self:oCCNonEarmarked:Hide()
		self:lTeleBank := true
		self:FillTeleBanking()
		IF self:AutoRec
			self:OKButton()
		ENDIF
	ELSE
		self:lTeleBank := FALSE
		(WarningBox{self,"Recording Gifts","No more Telebanking Gifts found"}):Show()
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
RESOURCE TransactionMonth DIALOGEX  13, 12, 258, 161
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
	CONTROL	"Show details of gifts", TRANSACTIONMONTH_GIFTDETAILS, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 96, 144, 80, 11
END

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
	PROTECT oDCGiftDetails AS CHECKBOX

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
	if !self:oAccStm == null_object
		self:oAccStm:=null_object
	endif

	RETURN SUPER:Close(oEvent)
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

ACCESS GiftDetails() CLASS TransactionMonth
RETURN SELF:FieldGet(#GiftDetails)

ASSIGN GiftDetails(uValue) CLASS TransactionMonth
SELF:FieldPut(#GiftDetails, uValue)
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

oDCGiftDetails := CheckBox{SELF,ResourceID{TRANSACTIONMONTH_GIFTDETAILS,_GetInst()}}
oDCGiftDetails:HyperLabel := HyperLabel{#GiftDetails,"Show details of gifts",NULL_STRING,NULL_STRING}
oDCGiftDetails:TooltipText := "Show gifts as separate transactions"

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
	local oAcc,oTrans as SQLSelect 
	local startdate, enddate as date

	self:FromYear:=oDCFromYear:Value
	self:FromMonth:=oDCFromMonth:Value
	self:ToYear:=oDCToYear:Value
	self:ToMonth:=oDCToMonth:Value
	if self:FromMonth<1 .or. self:FromMonth>12
		(ErrorBox{self,self:oLan:WGet("Illegal From month")}):show()
		return
	endif
	if self:ToMonth<1 .or. self:ToMonth>12
		(ErrorBox{self,self:oLan:WGet("Illegal To month")}):show()
		return
	endif
 
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
		oReport := PrintDialog{oParent,self:oLan:RGet("Account statements per month"),,100,,"xls"}
		// 			oReport := PrintDialog{oParent,self:oLan:WGet("Account statements per month"),,97}
		oReport:show()
		IF oReport:lPrintOk
			SetDecimalSep(Asc(DecSeparator))
			IF self:oAccStm==null_object
				self:oAccStm:=AccountStatements{,self:SkipInactive}
			ENDIF
			self:oAccStm:BeginReport:=self:BeginReport
			self:oAccStm:oReport:=oReport 
			self:oAccStm:SkipInactive:=self:SkipInactive
			self:oAccStm:lMinimalInfo:=self:oDCSimpleStmnt:Checked 
			self:oAccStm:GiftDetails:=self:oDCGiftDetails:Checked
			startdate:=SToD(Str(self:FromYear,4,0)+StrZero(self:FromMonth,2,0)+'01') 
			enddate:=SToD(Str(self:ToYear,4,0)+StrZero(self:ToMonth,2,0)+StrZero(MonthEnd(self:ToMonth,self:ToYear),2,0)) 
			oAcc:=SqlSelect{"select a.accid,a.description,a.accnumber,a.currency,b.category,a.giftalwd "+;
				" from balanceitem b,account a where a.balitemid=b.balitemid and a.accnumber between '"+self:nFromAccount+"' and '"+self:nToAccount+"'"+;
				" order by a.accnumber",oConn}
			oAcc:Execute()
			oTrans:=SqlSelect{UnionTrans('select t.docid,t.transid,t.accid,t.persid,t.dat,t.deb,t.cre,t.debforgn,t.creforgn,t.fromrpp,bfm,t.opp,t.gc,t.description,a.accnumber '+;
				" from transaction t,account a where a.accid=t.accid and t.dat>='"+SQLdate(startdate)+"' and t.dat<='"+SQLdate(enddate)+"'"+iif(Posting," and t.poststatus=2","")+;
				" and a.accnumber between '"+self:nFromAccount+"' and '"+self:nToAccount+"'")+" order by accnumber,dat",oConn}
			oTrans:Execute()
			
			do while !oAcc:EoF 
				self:oAccStm:MonthPrint(oAcc,oTrans,self:FromYear,self:FromMonth,self:ToYear,self:ToMonth,@nRow,@nPage,,self:oLan)
				oAcc:Skip()
			enddo				
			SetDecimalSep(Asc('.'))
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
	SaveUse(self)
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
STATIC DEFINE TRANSACTIONMONTH_GIFTDETAILS := 117 
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
RESOURCE TransInquiry DIALOGEX  25, 34, 523, 302
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", TRANSINQUIRY_TRANSINQUIRY_DETAIL, "static", WS_CHILD|WS_BORDER, 4, 22, 509, 262
	CONTROL	"Advanced Find", TRANSINQUIRY_SELECTIONBUTTON, "Button", WS_TABSTOP|WS_CHILD, 448, 3, 65, 13
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
	CONTROL	"Return Batch", TRANSINQUIRY_RETURNBUTTON, "Button", WS_TABSTOP|WS_CHILD|NOT WS_VISIBLE, 348, 288, 53, 12
END

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
	PROTECT oCCReturnButton AS PUSHBUTTON
	PROTECT oSFTransInquiry_DETAIL AS TransInquiry_DETAIL

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	EXPORT oSel AS InquirySelection
	EXPORT FromAccId, PersIdSelected, DocIdSelected, StartTransNbr, EndTransNbr,FromAccNbr,ToAccNbr, DescrpSelected,ReferenceSelected,DepIdSelected  as STRING
	EXPORT StartDate, EndDate as date
	EXPORT StartAmount, ToAmount as STRING
	EXPORT TransTypeSelected:="A" as STRING 
	EXPORT PostStatSelected as string
	EXPORT m54_selectTxt as STRING
	EXPORT employee as string
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
	export oTrans as SQLSelect
	export oMyTrans as SQLSelect
	protect lsttrnr as int
	export lShowFind:=true as logic

METHOD Close(oEvent) CLASS TransInquiry
IF !oHm==NULL_OBJECT
	IF oHm:Used
		oHm:Close()
	ENDIF
	oHm:=NULL_OBJECT
ENDIF
IF !SELF:oGen==NULL_OBJECT
	SELF:oGen:Close()
ENDIF
*SUPER:Close(oEvent)
	//Put your changes here
SELF:oSFTransInquiry_DETAIL:Close()

	RETURN SUPER:Close(oEvent)
*	RETURN NIL
METHOD EditButton( ) CLASS TransInquiry
	LOCAL cTransnr as STRING
	LOCAL OrigPerson,OrigBst, OrigUser as STRING,Origdat as date, OrigPost as int
	LOCAL cSavFilter, cSavOrder as STRING, nSavRec as int
	local lLocked as logic
	local lAMPM as logic 
	IF self:NoUpdate
		RETURN
	ENDIF 
	// 	ticks1:=GetTickCountLow()
	// 	LogEvent(,"t1:"+Str(ticks1,-1))
	*    oTrans:=SELF:Server 
	if self:Server:EOF .or. self:Server:reccount<1
		return
	endif
	cTransnr:=Str(self:Server:TransId,-1)
	OrigBst:=alltrim(self:Server:docid)
	Origdat:=self:Server:Dat
	OrigUser:=AllTrim(self:Server:USERID) 
	OrigPost:=ConI(self:Server:PostStatus)
	GetHelpDir() 
	lAMPM:=SetAmPm(false)
	self:oHm := TempTrans{HelpDir+"\HU"+StrTran(StrTran(Time(),":"),' ','')+".DBF",DBEXCLUSIVE}
	SetAmPm(lAMPM)
	//	self:oHm := TempTrans{}
	IF !self:oHm:Used
		RETURN
	ENDIF
	* Fill rows of TempTrans with transaction:
	// 	self:oMyTrans:=SQLSelect{UnionTrans("select t.*,a.description as accdesc,a.accnumber,a.balitemid,a.multcurr,b.category as type,m.persid as persidmbr,"+;
	// 	SQLAccType()+" as accounttype from balanceitem b,account a left join member m on (m.accid=a.accid)  , transaction t left join person p on (p.persid=t.persid) "+;
	// 	" where a.accid=t.accid and b.balitemid=a.balitemid and t.transid="+cTransnr+" and t.dat='"+SQLdate(Origdat)+"'"),oConn}
	self:oMyTrans:=SqlSelect{UnionTrans2("select t.transid,t.seqnr,cast(t.dat as date) as dat,t.docid,t.reference,t.description,t.deb,t.cre,t.gc,"+;
	"cast(t.poststatus as signed) as poststatus,t.accid,t.currency,t.debforgn,t.creforgn,t.bfm,t.ppdest,t.fromrpp,t.persid,t.opp,"+;
	"if(t.lock_id=0 or t.lock_time < subdate(now(),interval 60 minute),0,1) as locked,a.description as accdesc,a.accnumber,a.balitemid,a.multcurr,b.category as type,m.persid as persidmbr,"+;
		SQLAccType()+" as accounttype,"+SQLIncExpFd()+" as incexpfd,a.department from "+;
		"transaction t use index (primary) left join person p on (p.persid=t.persid),"+;
		"account a left join department d on (d.incomeacc=a.accid or d.expenseacc=a.accid or d.netasset=a.accid) left join member m on (m.accid=a.accid or m.depid=d.depid),"+;
      "balanceitem b"+;
		" where a.accid=t.accid and b.balitemid=a.balitemid and t.transid="+cTransnr+" order by seqnr",Origdat,Origdat),oConn}
   self:oMyTrans:Execute()
	if !Empty(self:oMyTrans:status)
		LogEvent(self,"error:"+self:oMyTrans:errinfo:errormessage,"LogErrors")
	endif 
	self:oHm:aMirror:={} 
	DO WHILE self:oMyTrans:reccount>0 .and.!self:oMyTrans:EOF 
		if self:oMyTrans:locked=1
			lLocked:=true
		endif
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
		self:oHm:INCEXPFD:=self:oMyTrans:INCEXPFD
		self:oHm:FROMRPP:=iif(ConI(self:oMyTrans:FROMRPP)==1,true,false)
		self:oHm:lFromRPP:=iif(ConI(self:oMyTrans:FROMRPP)==1,true,false)
		self:oHm:OPP:=self:oMyTrans:OPP
		self:oHm:PPDEST := Upper(self:oMyTrans:PPDEST)
		self:oHm:REFERENCE:=self:oMyTrans:REFERENCE
		self:oHm:SEQNR := self:oMyTrans:SEQNR
		self:oHm:KIND := Upper(self:oMyTrans:accounttype)
		self:oHm:DEPID:=ConI(self:oMyTrans:department)
		IF !Empty(self:oMyTrans:persid)
			OrigPerson := Str(self:oMyTrans:persid,-1)
		ENDIF 
		self:oHm:PostStatus:=ConI(self:oMyTrans:PostStatus) 
		self:oHm:PoststatusOrig:= self:oHm:PostStatus

		* Add to mirror:
		&& mirror-array of TempTrans with values {accID,deb,cre,gc,category,recno,Trans:SeqNbr,accnumber,Rekoms,balitemid,curr,multicur,debforgn,creforgn,reference,description,persid,type,icexpfd,depid}
		//                                          1    2   3  4    5       6        7           8        9        10     11      12      13        14     15        16          17     18    19      20
		AAdd(self:oHm:aMirror,{AllTrim(self:oHm:AccID),self:oHm:deb,self:oHm:cre,self:oHm:GC,self:oHm:KIND,self:oHm:RecNo,self:oHm:SEQNR,AllTrim(self:oHm:ACCNUMBER),AllTrim(self:oHm:AccDesc),;
		Str(self:oMyTrans:balitemid,-1),self:oHm:Currency,iif(ConI(self:oMyTrans:MULTCURR)=1,true,false),self:oHm:debforgn,self:oHm:creforgn,AllTrim(self:oHm:REFERENCE),AllTrim(self:oHm:DESCRIPTN),;
		iif(Empty(self:oMyTrans:persidmbr),iif(Empty(self:oMyTrans:persid),"",Str(self:oMyTrans:persid,-1)),Str(self:oMyTrans:persidmbr,-1)),self:oMyTrans:TYPE,oHm:INCEXPFD,self:oHm:DEPID})
// 		iif(Empty(self:oMyTrans:persid),iif(Empty(self:oMyTrans:persidmbr),"",Str(self:oMyTrans:persidmbr,-1)),Str(self:oMyTrans:persid,-1)),self:oMyTrans:TYPE,oHm:INCEXPFD,self:oHm:DEPID})
		self:oMyTrans:Skip()
	ENDDO 
	// save aMirror:
	self:oHm:aMirrorOrig :=AClone( self:oHm:aMirror ) 
	
	oGen:= General_Journal{self:Owner,,self:oHm,true}
	oGen:FillRecord(cTransnr,self:oSFTransInquiry_DETAIL:Browser,OrigPerson,Origdat,OrigBst,OrigUser,OrigPost,self,lLocked)
	oGen:AddCur()
	oGen:Show()
	RETURN nil	
METHOD ExportButton( ) CLASS TransInquiry 
	// export select transaction to file and send - when required - that file by email to headquarters
	LOCAL oTrans as SQLSelect
	LOCAL oTrans2 as SQLSelect
	LOCAL oSys as SQLSelect
	LOCAL lSucc as LOGIC
	LOCAL nCurRec as STRING
	LOCAL cFilename as STRING
	LOCAL oMapi as MAPISession
	LOCAL oRecip,oRecip2 as MAPIRecip
	LOCAL cExportMail as STRING
	LOCAL lSent as LOGIC
	LOCAL uRet as USUAL
	LOCAL cTransnr as STRING
	LOCAL oWarn as warningbox
	LOCAL lAppend:=true  as LOGIC
	LOCAL ToFileFS as Filespec
	LOCAL ptrHandle
	LOCAL cLine as STRING
	LOCAL cDelim:=Listseparator as STRING
	LOCAL lMail as LOGIC 
	local aTrans:={} as array 
	local j as int
	local cTrans,cSelectSt as string

	oTrans:=self:Server
	oTrans:GoTop()
	IF oTrans:EoF
		RETURN
	ENDIF
	IF (TextBox{self,"Export of transactions to file/mail","Should all "+Str(oTrans:RecCount,-1)+" selected transactions be exported?",BUTTONOKAYCANCEL+BOXICONQUESTIONMARK}):Show()==BOXREPLYCANCEL
		RETURN
	ENDIF
	IF Empty(SEntity)
		(ErrorBox{self:OWNER,'You have to specify the entitycode in the system parameters with the name of your department'}):Show()
		RETURN
	ENDIF
	IF (TextBox{self:Owner,"Export of transactions to file/mail","Should selected transactions send by mail to the headquarters?",BUTTONYESNO+BOXICONQUESTIONMARK}):Show()==BOXREPLYYES
		lMail:=true
	ENDIF 

	self:STATUSMESSAGE("Exporting data, moment please")
	self:Pointer := Pointer{POINTERHOURGLASS}
	
	* Datafile construction:
	SetDecimalSep(Asc(DecSeparator))
	cFileName := AllTrim(SEntity)+DToS(Today())
	ToFileFS:=AskFileName(self,cFilename,"Export transactions to file","*.CSV","Comma separated file",@lAppend) 
	if !Empty(ToFileFS)
		cFilename:=ToFileFS:FullPath 
		IF lAppend
			ptrHandle := FOpen(cFilename,FO_READWRITE	)
		ELSE
			ptrHandle:=MakeFile(@cFilename,"Exporting to spreadsheet")
		ENDIF
		IF !ptrHandle = F_ERROR .and. !ptrHandle==nil
			IF !lAppend
				* Write heading TO file:
				FWriteLine(ptrHandle,'"TRANSDATE"'+cDelim+'"DOCID"'+cDelim+'"TRANSACTNR"'+cDelim+'"ACCOUNTNR"'+cDelim+'"ACCNAME"'+cDelim+'"DESCRIPTN"'+cDelim;
					+'"DEBITAMNT"'+cDelim+'"CREDITAMNT"'+cDelim+'"DEBITFNAMNT"'+cDelim+'"CREDITFNAMNT"'+cDelim+'"CURRENCY"'+cDelim;
					+'"ASSMNTCD"'+cDelim+'"GIVER"'+cDelim+'"PPDEST"'+cDelim+'"REFERENCE"'+cDelim+'"SEQNR"'+cDelim+'"POSTSTATUS"')
			ELSE
				* position file at end:
				FSeek(ptrHandle, 0, FS_END)
			ENDIF
			* detail records with complete transactions: 
			cSelectSt:=UnionTrans("select "+self:cFields+" from "+self:cFrom+" where "+self:cWhereBase+" and transid in (" +;
			"select distinct t.transid from "+self:cFrom+" where "+self:cWhereBase+" and "+self:cWhereSpec+" order by t.transId) order by transid,seqnr")
			oTrans2:=SqlSelect{cSelectSt,oConn}                     
			if oTrans2:RecCount>0
				do WHILE !oTrans2:EoF
					FWriteLine(ptrHandle,;
						'"'+DToS(oTrans2:Dat)+'"'+cDelim+'"'+oTrans2:docid+'"'+cDelim+'"'+Str(oTrans2:TransId,-1)+'"'+cDelim+'"'+AllTrim(oTrans2:ACCNUMBER)+'"'+cDelim+'"'+;
						AllTrim(oTrans2:accountname)+'"'+cDelim+'"'+StrTran(AllTrim(oTrans2:Description),'"','""')+'"'+cDelim;
						+'"'+Str(oTrans2:deb,-1)+'"'+cDelim+'"'+Str(oTrans2:cre,-1)+'"'+cDelim+;
						+'"'+Str(oTrans2:DEBFORGN,-1)+'"'+cDelim+'"'+Str(oTrans2:CREFORGN,-1)+'"'+cDelim+'"'+oTrans2:CURRENCY+'"'+cDelim+;
						'"'+oTrans2:GC+'"'+cDelim+'"'+Transform(oTrans2:personname,"")+'"'+cDelim+'"'+Transform(oTrans2:PPDEST,"")+'"'+cDelim+'"'+StrTran(AllTrim(oTrans2:REFERENCE),'"','""')+'"'+cDelim+'"'+Str(oTrans2:SEQNR,-1)+'"'+cDelim+'"'+Str(ConI(oTrans2:poststatus),-1)+'"')
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
				oSys:=SqlSelect{"select ownmailacc,expmailacc,countryown from sysparms", oConn}
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
				ENDIF
			else
				(TextBox{self:OWNER,"Export of transactions","Generated one file:"+cFilename}):Show()		
			ENDIF
		ENDIF
	endif
	self:Pointer := Pointer{POINTERARROW}
	SetDecimalSep(Asc('.'))
	
	RETURN
METHOD FindButton( ) CLASS TransInquiry 
local nQty as int
local oSel as SQLSelect
	self:cWhereSpec:="t.transid> "+Str(self:lsttrnr- ConI(self:NbrTrans),-1)+" and t.dat>='"+SQLdate(LstYearClosed)+"'"
	self:cSelectStmnt:="select "+self:cFields+" from "+self:cFrom+" where "+self:cWhereBase+" and "+self:cWhereSpec 
	self:cOrder:="transid desc,seqnr" 
	oSel:=SqlSelect{UnionTrans("select count(*) as qty from "+self:cFrom+" where "+self:cWhereBase+" and "+self:cWhereSpec),oConn}
	oSel:Execute()
	nQty:=ConI(oSel:qty)
	if nQty> 3000
		if TextBox{self,self:oLan:WGet("transaction inquiry"),self:oLan:WGet("Do you really want to retrieve")+Space(1)+ConS(nQty)+Space(1)+self:oLan:WGet("transaction lines"),BUTTONYESNO+BOXICONQUESTIONMARK}:Show()==BOXREPLYNO
			return nil
		endif
	endif
 	self:oTrans:sqlstring:=UnionTrans(self:cSelectStmnt) +" order by "+self:cOrder 
	self:Pointer := Pointer{POINTERHOURGLASS}
	self:oTrans:Execute() 
	if !Empty(self:oTrans:Status)
		LogEvent(self,"Could not find last "+ConS(self:NbrTrans)+" transactions, error:"+self:oTrans:ErrInfo:ErrorMessage,"LogErrors") 
	else
		self:GoTop()
		if self:oTrans:reccount<1 .and. IsObject(self:oSFTransInquiry_DETAIL:Browser) .and.!Empty(self:oSFTransInquiry_DETAIL:Browser)
			self:oSFTransInquiry_DETAIL:Browser:refresh()
		endif 
	endif
	self:oDCFound:TextValue :=Str(self:oTrans:reccount,-1)
	self:Pointer := Pointer{POINTERARROW} 

	RETURN nil
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
oCCReadyButton:TooltipText := "Post all selected transactions as ready for posting"

oCCPostButton := PushButton{SELF,ResourceID{TRANSINQUIRY_POSTBUTTON,_GetInst()}}
oCCPostButton:HyperLabel := HyperLabel{#PostButton,"Post Batch",NULL_STRING,NULL_STRING}
oCCPostButton:OwnerAlignment := OA_Y
oCCPostButton:TooltipText := "Post all selected transactions as definitely booked"

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

oCCReturnButton := PushButton{SELF,ResourceID{TRANSINQUIRY_RETURNBUTTON,_GetInst()}}
oCCReturnButton:HyperLabel := HyperLabel{#ReturnButton,"Return Batch",NULL_STRING,NULL_STRING}
oCCReturnButton:OwnerAlignment := OA_Y
oCCReturnButton:TooltipText := "Return all selected transactions to the bookkeeper to correct them"

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
	local cTransnr as string 
	local cError as string
	local lError as logic 
	local aTransid:={} as array
	local aStatus:={'Returning','Ready','Posting'} as array
	local oTransH:=self:Server as SQLSelect
	local oTrans,oStmnt as SQLStatement
	local oBal as balances 

	self:STATUSMESSAGE(self:oLan:WGet(aStatus[status])+" transactions, moment please")
	self:Pointer := Pointer{POINTERHOURGLASS}

	oTransH:SuspendNotification()
	oTransH:GoTop()
	aTransid:=oTransH:GetLookupTable(100000,#transid,#transid) 
	// 	SQLStatement{"start transaction",oConn}:execute()   
	oStmnt:=SQLStatement{"set autocommit=0",oConn}
	oStmnt:execute()
	oStmnt:=SQLStatement{'lock tables `mbalance` write, `transaction` write',oConn}       // alphabetic order
	oStmnt:execute()
	oTrans:=SQLStatement{"update transaction set poststatus="+Str(status,-1)+",userid='"+LOGON_EMP_ID+"' where transid in ("+ Implode(aTransid,',',,,1)+")",oConn}
	oTrans:execute()
	if !Empty(oTrans:status)
		lError:=true
		cError:=oTrans:ErrInfo:errormessage
	endif
	if !lError .and.status=2
		// change balances
		oBal:=Balances{}     
		oTransH:GoTop()
		Do while !oTransH:EoF
			oBal:ChgBalance(ConS(oTransH:accid), oTransH:dat, oTransH:deb, oTransH:cre, oTransH:debforgn, oTransH:creforgn,oTransH:Currency,2) 
			oTransH:Skip()
		enddo
		if !oBal:ChgBalanceExecute()
			lError:=true
			cError:=oBal:cError
		endif
	endif
	if !lError
		SQLStatement{"commit",oConn}:execute()
		SQLStatement{"unlock tables",oConn}:execute() 
		SQLStatement{"set autocommit=1",oConn}:execute() 
	else
		SQLStatement{"rollback",oConn}:execute()
		SQLStatement{"unlock tables",oConn}:execute() 
		SQLStatement{"set autocommit=1",oConn}:execute()
		cError:=self:oLan:WGet("transactions could't be posted")+" ("+cError+")" 
		LogEvent(self,cError,"logerrors")
		ErrorBox{,self,cError}:Show()
	endif
	oTransH:GoTop()
	oTransH:ResetNotification()
	self:STATUSMESSAGE(Space(40))
	self:Pointer := Pointer{POINTERARROW}
	self:ShowSelection()
	// 	self:oSFTransInquiry_DETAIL:Browser:REFresh()

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
	local aBal:={} as array
	local	oBank as SQLSelect

	self:SetTexts()
	SaveUse(self)
	self:StartDate:=LstYearClosed
	if Today()-LstYearClosed > 400
		aBal:=getbalYear(Year(Today()),month(Today()))
		if Len(aBal)>0
			self:StartDate:=SToD(Str(aBal[1],4,0)+StrZero(aBal[2],2,0)+'01')
			if self:StartDate<LstYearClosed
				self:StartDate:=LstYearClosed
			endif
		endif
	endif
	
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
		oBank	:=	SQLSelect{"select	accid from	bankaccount	where	telebankng>0 and accid",oConn} 
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
		OldestYear:=LstYearClosed
	endif
	self:oDCFound:TextValue :=Str(self:oTrans:RecCount,-1)
	

	RETURN nil
method PreInit(oWindow,iCtlID,oServer,uExtra) class TransInquiry
	//Put your PreInit additions here
	// uExtra can contain a filter for selecting transactions 
	local oSel as SQLSelect
	Default(@uExtra,null_string)
	oSel:= SQLSelect{"select max(transid) as maxtr from transaction",oConn}
	if oSel:reccount>0
		if !Empty(oSel:maxtr)
			self:lsttrnr:=oSel:maxtr
		endif
	endif
	self:cFields:="t.transid,t.seqnr,cast(t.dat as date) as dat,t.docid,t.reference,t.description,t.deb,t.cre,t.gc,t.userid,t.debforgn,t.creforgn,"+;
		"cast(t.poststatus as signed) as poststatus,if(t.poststatus=2,'Posted',if(t.poststatus=1,'Ready','Not posted')) as postingstatus,t.currency,t.ppdest,"+;
		"a.accnumber,a.accid,a.description as accountname,"+SQLFullName(0,"p")+" as personname,p.persid"
	self:cFrom:="account a, transaction t left join person p on (p.persid=t.persid)"
	self:cWhereBase:="a.accid=t.accid"+iif(Empty(cDepmntIncl),''," and a.department in ("+cDepmntIncl+")") 
	if !Empty( cAccAlwd)
		if USERTYPE=="D"
			self:cWhereBase+=" and t.userid='"+LOGON_EMP_ID+"'"
			// 			+iif(MinDate >LstYearClosed,".and.DToS(Dat)>='"+DToS(MinDate)+"'",""))
		else
			self:cWhereBase+=" and (t.accid in("+cAccAlwd+") or t.userid='"+LOGON_EMP_ID+"')"
		endif		
	endif
	if Empty(uExtra)
		cWhereSpec:="transid>"+Str(self:lsttrnr-100,-1)+" and t.dat>='"+SQLdate(LstYearClosed)+"'"
	else
		cWhereSpec:=uExtra
	endif
	self:cOrder:="transid desc,seqnr" 
	self:cSelectStmnt:="select "+self:cFields+" from "+cFrom+" where "+self:cWhereBase+" and "+self:cWhereSpec 
	self:oTrans:=SqlSelect{UnionTrans(self:cSelectStmnt)+" order by "+self:cOrder,oConn} 
	return nil

METHOD ReadyButton( ) CLASS TransInquiry 
if (TextBox{,"Ready Batch","Are you sure you want to mark all selected transactions as 'Ready to Post'?",BOXICONQUESTIONMARK + BUTTONYESNO}):Show()<> BOXREPLYYES
	return
endif
self:Post(1)

RETURN NIL
METHOD ReturnButton( ) CLASS TransInquiry 
	if (TextBox{,"Return Batch","Are you sure you want to Return all selected transactions to the bookkeeper to correct them?",BOXICONQUESTIONMARK + BUTTONYESNO}):Show()<> BOXREPLYYES
		return
	endif
	self:Post(0)

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
LOCAL nCurRec, nNextRec,nRemn as int
local oAccFrom,oAccTo as SQLSelect
local cCurrorg,cCurrDest as string, lMultiOrg, lMultiDest as logic
local cFromText, cToText,cError as string 
local oStmnt as SQLStatement
local dCurrDate:=null_date as date
local oCurr as Currency 
local fExRate as float

oTrans:=self:Server
oTrans:GoTop()
IF oTrans:EOF
	RETURN
ENDIF
IF Empty(self:cTransferAcc)
	RETURN
ENDIF
oAccFrom:=SQLSelect{"select a.multcurr,a.currency,b.category from account a,balanceitem b where a.balitemid=b.balitemid and a.accid="+self:FromAccId,oConn} 
if oAccFrom:reccount<1
	return
endif
cCurrorg:=iif(Empty(oAccFrom:Currency),sCurr,oAccFrom:Currency)
lMultiOrg:=iif(ConI(oAccFrom:MULTCURR)=1,true,false)
oAccTo:=SQLSelect{"select a.multcurr,a.currency,b.category from account a,balanceitem b where a.balitemid=b.balitemid and a.accid="+self:cTransferAcc,oConn} 
if oAccTo:reccount<1
	return
endif
cCurrDest:=iif(Empty(oAccTo:Currency),sCurr,oAccTo:Currency)
lMultiDest:=iif(ConI(oAccTo:MULTCURR)=1,true,false)
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
	IF (TextBox{self,self:oLan:WGet("Transfer of transactions"),;
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
if !cCurrorg==cCurrDest .and. !cCurrDest==sCurr
	// determine latest date:
	oTrans:GoTop()
	do while !oTrans:EOF
		if !oTrans:bfm=='H' .and. oTrans:Dat> dCurrDate
			dCurrDate:=oTrans:Dat
		endif
		oTrans:Skip()
	enddo
	if !Empty(dCurrDate)
	//ask for exchange rate from cCurr to cCurrDest on dCurDate
	oCurr:=Currency{self:oLan:WGet("get exchange rate for transfering transactions"),cCurrDest}
	fExRate:=oCurr:GetROE(sCurr,dCurrDate,true) 
	if oCurr:lStopped
		return
	endif
	endif
else
	fExRate:=1.00
endif 

self:STATUSMESSAGE("Transfering data, moment please")
self:Pointer := Pointer{POINTERHOURGLASS}
oStmnt:=SQLStatement{"set autocommit=0",oConn}
oStmnt:Execute()
oStmnt:=SQLStatement{'lock tables `mbalance` write,`transaction` write',oConn}        // alphabetic order
oStmnt:Execute()

oStmnt:=SQLStatement{"update transaction set accid='"+self:cTransferAcc+"',userid='"+LOGON_EMP_ID+"'"+;
iif(lMultiDest,"",",debforgn=deb*"+Str(fExRate,-1)+",creforgn=cre*"+Str(fExRate,-1)+",currency='"+cCurrDest+"'")+;
" where "+StrTran(self:cWhereSpec,'t.',''),oConn}
//" where "+StrTran(self:cWhereSpec,'t.','')+' and bfm<>"H"',oConn}
oStmnt:Execute()
if oStmnt:NumSuccessfulRows>0 
	oTrans:GoTop()
	DO WHILE !oTrans:EOF
		if ChgBalance(FromAccId,oTrans:Dat,-oTrans:DEB,-oTrans:Cre,-oTrans:DEBFORGN,-oTrans:CREFORGN,cCurrorg,oTrans:poststatus)
			if ChgBalance(cTransferAcc,oTrans:Dat,oTrans:DEB,oTrans:Cre,Round(oTrans:DEB*fExRate,2),Round(oTrans:Cre*fExRate,2),cCurrDest,oTrans:poststatus)
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
elseif !Empty(oStmnt:status)
	lError:=true
	cError:= "error:"+oStmnt:errinfo:errormessage+CRLF+"stmnt:"+oStmnt:sqlstring
endif
if lError
	SQLStatement{"rollback",oConn}:Execute()
	SQLStatement{"unlock tables",oConn}:Execute()
	ErrorBox{self,self:oLan:WGet("Transfer failed")}:Show() 
	LogEvent(self,cError,"LogErrors")
	oTrans:ResetNotification()
	return
else
	SQLStatement{"commit",oConn}:Execute() 
	SQLStatement{"unlock tables",oConn}:Execute()
	nRemn:=self:oTrans:reccount - oStmnt:NumSuccessfulRows 
	TextBox{self,self:oLan:WGet("Transfer of transactions"),Str(oStmnt:NumSuccessfulRows,-1)+' '+self:oLan:WGet("transferred")+;
	iif(nRemn>0,'; '+self:oLan:WGet("remaining allready sent to PMC"),"")}:Show() 
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
// if self:cCurr==sCurr
// 	cFilter+=' and a.currency="'+sCurr+'"'
// else
// 	cFilter+=' and (a.currency="'+self:cCurr+'" or a.currency="'+sCurr+'")'
// endif	
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
		self:Owner:SetWidth(self:Owner:Size:Width+=60)
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
STATIC DEFINE TRANSINQUIRY_RETURNBUTTON := 114 
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
