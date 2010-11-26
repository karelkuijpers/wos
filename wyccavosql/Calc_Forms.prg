RESOURCE Calculator DIALOGEX  33, 46, 153, 153
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"Calculator"
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", CALCULATOR_RESULT, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 10, 120, 132, 12, WS_EX_CLIENTEDGE
	CONTROL	"OK", CALCULATOR_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 88, 139, 54, 12
	CONTROL	"", CALCULATOR_LISTRESULT, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_NOTIFY|WS_CHILD|WS_BORDER|WS_VSCROLL, 10, 7, 132, 100, WS_EX_CLIENTEDGE
END

CLASS Calculator INHERIT DIALOGWINDOW

	EXPORT oDCResult AS SINGLELINEEDIT
	EXPORT oCCOKButton AS PUSHBUTTON
	EXPORT oDCListResult AS LISTBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
  	PROTECT fMemory AS FLOAT
	PROTECT cFunction AS STRING
	PROTECT lClear AS LOGIC
	PROTECT oEdit AS SingleLineEdit
	PROTECT nDec AS INT
	PROTECT oBrowser as OBJECT 
	PROTECT fieldSym as symbol

METHOD EditChange(oControlEvent) CLASS Calculator
	LOCAL oControl AS Control
	LOCAL fValue AS FLOAT
	LOCAL LstChar AS STRING
	LOCAL rPos AS selection
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:EditChange(oControlEvent)
	//Put your changes here
	IF AllTrim(SELF:oDCResult:TEXTValue)==AllTrim(Str(fMemory)) //Dummy call?
		RETURN NIL
	ENDIF
	rPos:=SELF:oDCResult:Selection
	LstChar:=SubStr(oDCResult:TextValue,rPos:Start,1)
	IF LstChar $ "/+-*="
		IF lClear.and.!cFunction=="="
			fValue:=0
		ELSE
			fValue:=Val(SubStr(oDCResult:TextValue,1,rPos:Start-1))
			--rPos:Start
		/*	oDCResult:Selection:= rPos
			oDCResult:Clear()   */
			oDCResult:TextValue:=""
		ENDIF
		lClear:=TRUE
		IF Empty(cFunction)
			fMemory:=fValue
			oDCListResult:Additem(Str(fMemory)+" "+LstChar)
		ELSE
			oDCListResult:Additem(Str(fValue)+"  ")
			IF cFunction="+"
				fMemory:=fMemory+fValue
			ELSEIF cFunction="-"
				fMemory:=fMemory-fValue
			ELSEIF cFunction="*"
				fMemory:=fMemory*fValue
			ELSEIF cFunction="/"
				fMemory:=fMemory/fValue
			ENDIF
			oDCListResult:Additem(Replicate("=",20))
			oDCListResult:Additem(Str(fMemory)+" "+LstChar)
			rPos:Start:=0
			//oDCResult:Selection:=rPos
			//oDCResult:Paste(Str(fMemory))
			oDCResult:TextValue:=AllTrim(Str(fMemory))
			oDCListResult:CurrentItemNo := oDCListResult:ItemCount
		ENDIF
		cFunction:=LstChar
	ELSE
		IF lClear
			lClear:=FALSE
			rPos:Start:=0
			rPos:Finish:=20
/*			ODCResult:Selection:Start:=0
			ODCResult:Selection:Finish:=20*/
			oDCResult:TextValue:=""
			oDCResult:Paste(LstChar)
			//oDCResult:TextValue:=LstChar
		ENDIF
		IF cFunction=="="
			cFunction:=""
		ENDIF
	ENDIF
	RETURN NIL


method Init(oParent,uExtra) class Calculator 

self:PreInit(oParent,uExtra)

super:Init(oParent,ResourceID{"Calculator",_GetInst()},TRUE)

oDCResult := SingleLineEdit{self,ResourceID{CALCULATOR_RESULT,_GetInst()}}
oDCResult:HyperLabel := HyperLabel{#Result,NULL_STRING,NULL_STRING,NULL_STRING}
oDCResult:FocusSelect := FSEL_HOME

oCCOKButton := PushButton{self,ResourceID{CALCULATOR_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oDCListResult := ListBox{self,ResourceID{CALCULATOR_LISTRESULT,_GetInst()}}
oDCListResult:HyperLabel := HyperLabel{#ListResult,NULL_STRING,NULL_STRING,NULL_STRING}

self:Caption := "Calculator"
self:HyperLabel := HyperLabel{#Calculator,"Calculator",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD OKButton( ) CLASS Calculator
	LOCAL fValue AS FLOAT
	LOCAL myServer AS OBJECT
	LOCAL myOwner AS Window
	IF IsObject(oEdit)
		IF lClear
			fValue:=0
		ELSE
			fValue:=Val(oDCResult:TextValue)
		ENDIF
		IF cFunction="+"
			fMemory:=fMemory+fValue
		ELSEIF cFunction="-"
			fMemory:=fMemory-fValue
		ELSEIF cFunction="*"
			fMemory:=fMemory*fValue
		ELSEIF cFunction="/"
			fMemory:=fMemory/fValue
		ELSE
			fMemory:=fValue
		ENDIF
		* Next line gives Kicking limit exceed in case of update of an amount and a later TAB or right/ left arrow:
*		oEdit:value:=Round(fMemory,2)
*		oEdit:CurrentText:=Str(Round(fMemory,2))  // same as next tow lines?
		***************************************
/*		oEdit:Selection:=Selection{0,-1)
		oEdit:Paste(Str(Round(fMemory,2)))*/
		SELF:oEdit:CalcActive:=FALSE
		oEdit:TextValue:=(Str(Round(fMemory,2)))
		IF !oBrowser==NULL_OBJECT
			*SELF:oColumn:SetValue(Str(Round(fMemory,2)))
			myOwner:=oBrowser:owner
			myServer:=myOwner:Server
			myServer:FIELDPUT(self:fieldSym,Round(fMemory,2))
			IF !myOwner:owner==NULL_OBJECT
				IF IsMethod(myOwner,#DebCreProc)
					myOwner:DebCreProc()
				ENDIF
				IF IsMethod(myOwner:owner,#Totalise)
					myOwner:Owner:Totalise()
				ENDIF
			else
				IF IsMethod(myOwner,#DebCreProc)
					myOwner:DebCreProc()
				ENDIF
				IF IsMethod(myOwner:owner,#Totalise)
					myOwner:owner:Totalise()
				ENDIF
			ENDIF
		else
			myOwner:=self:oEdit:oOwner
			IF IsMethod(myOwner,#DebCreProc)
				myOwner:DebCreProc()
			ENDIF
			IF IsMethod(myOwner,#Totalise)
				myOwner:Totalise()
			ENDIF
		ENDIF
	ENDIF
SetDecimal(nDec)
SELF:EndDialog()
*SELF:EndWindow()
METHOD PostInit(oParent,uExtra) CLASS Calculator
	//Put your PostInit additions here
	IF IsArray(uExtra)
		oEdit:=uExtra[1]
		oDCResult:Value:=AllTrim(oEdit:CurrentText)
		fMemory:= Val(oDCResult:TextValue)
		cFunction:=uExtra[2]
		oDCListResult:Additem(Str(fMemory)+" "+cFunction)
		IF Len(uExtra)>2
			SELF:oBrowser:=uExtra[3]
		ENDIF
		IF Len(uExtra)>3
			self:fieldSym:=uExtra[4]
		ENDIF
		lClear:=true
		nDec:=SetDecimal(32)
		oDCResult:SetFocus()

	ENDIF
	RETURN NIL
STATIC DEFINE CALCULATOR_LISTRESULT := 102 
STATIC DEFINE CALCULATOR_OKBUTTON := 101 
STATIC DEFINE CALCULATOR_RESULT := 100 
Class japComboBox Inherit ComboBox
	EXPORT oColumn as DataColumn	
	EXPORT oBrowser as DataBrowser
method Dispatch(oEvent) class japComboBox 
	IF oEvent:Message==8.or. oEvent:Message==14
		IF self:CurrentItemNo>0
			self:oColumn:Value:=self:GetItemValue(self:CurrentItemNo) 
			IF IsMethod(self:Owner,#ColumnFocusChange).and.!self:Owner:Owner:Server==null_object .and. self:Owner:Owner:Server:used
				self:Owner:ColumnFocusChange(self:oColumn, true)
			ENDIF
		ENDIF 
	ENDIF 
	RETURN SUPER:Dispatch(oEvent)
CLASS JapDataColumn INHERIT DataColumn
	EXPORT oColumn AS DataColumn
	export usingarr:={} as array  // array for fillusing combobox
METHOD GetEditObject(oOwner, iID, oPoint, oDim) CLASS JapDataColumn
    LOCAL oControl AS Control
	LOCAL ThisRec as int
local myDim:=oDim as Dimension, myPoint:=oPoint as Point 
LOCAL oHm as dataserver
Local cCLN as string


*    VTrace VMethod 
	oHm:=self:Owner:Owner:Server
	ThisRec:=oHm:recno

	IF ClassName(self:Owner:Owner:Owner)==#General_Journal .and. (self:Owner:Owner:Owner:lTeleBank .or.self:Server:lFromRPP).and.!self:symDataField==#DESCRIPTN .and. ThisRec=1
		// row 1 may not be changed
		// -> The input is not permitted
		SELF:Modified:=FALSE
		RETURN NULL_OBJECT
	ENDIF
//    IF self:symDataField==#AccDesc .or. self:symDataField==#ORIGINAL .or. self:symDataField==#DESC .or. self:symDataField==#AMOUNT .or. self:symDataField==#SELLPR// rekoms,original is not updatable
   IF self:symDataField==#AccDesc .or. self:symDataField==#ORIGINAL .or. self:symDataField==#AMOUNT .or. self:symDataField==#SELLPR// rekoms,original is not updatable
      RETURN null_object
   ENDIF
	if self:symDataField==#Currency
	   if oHm:aMirror[ThisRec,12]    // multi currency?
			myDim:Height+=160
			myPoint:Y-=160 
			oControl:=japComboBox{oOwner, iID, oPoint, myDim,BOXDROPDOWNLIST}		
			oControl:FillUsing(SQLSelect{"select UNITED_ARA,AED from CurrencyList",oConn}:getLookUptable(300,#UNITED_ARA,#AED))
			oControl:LinkDf(oHm,oHm:FieldPos(#Currency))
		   oControl:Value := RTrim(self:VALUE)
	   else
  			self:Modified:=FALSE
			RETURN null_object
	   endif  
	elseif self:symDataField==#GC
		myDim:Height+=60
		myPoint:Y-=60 
		oControl:=japComboBox{oOwner, iID, oPoint, myDim,BOXDROPDOWNLIST}		
		oControl:FillUsing(aAsmt) 
		oControl:LinkDf(oHm,oHm:FieldPos(#GC))
		oControl:Value := RTrim(self:VALUE) 
	elseif self:symDataField==#AED .or. self:symDataField==#AEDUNIT
		myDim:Height+=160
		myPoint:Y-=160	
		oControl:=japComboBox{oOwner,	iID, oPoint, myDim,BOXDROPDOWNLIST,CBS_SORT}		
		oControl:FillUsing(SQLSelect{"select UNITED_ARA,AED from CurrencyList",oConn}:getLookUptable(300,#UNITED_ARA,#AED))
		oControl:LinkDf(oHm,oHm:FieldPos( self:symDataField))
		oControl:Value	:=	AllTrim(self:VALUE)
	elseif self:symDataField==#BANKACCT
		myDim:Height+=60
		myPoint:Y-=60 
		oControl:=japComboBox{oOwner, iID, oPoint, myDim,BOXDROPDOWNLIST}
		cCLN:=Str(oHm:FIELDGET(#CREDITOR),-1)
		oControl:FillUsing(SQLSelect{"select banknumber from personbank where persid="+cCLN,oConn}:getLookUptable(100,#banknumber,#banknumber)) 

	else  
		oControl := JapSingleEdit{oOwner, iID, oPoint, oDim, ES_AUTOHSCROLL} 
		IF !oFieldSpec==null_object
        oControl:FieldSpec := oFieldSpec
    	ENDIF
    	// Here activation of overwrite 
   	IVarPut(oControl, #Overwrite, OVERWRITE_NEVER)
    	oControl:SetExStyle(WS_EX_CLIENTEDGE, true)
   	oControl:Font(oOwner:EditFont, FALSE)
    	oControl:TextValue := RTrim(self:TextValue)
    	SendMessage(oControl:Handle(), EM_SETSEL, 0, -1)
	endif
	oControl:oColumn:=self


    RETURN oControl
METHOD Init(oFieldSpec)   CLASS JapDataColumn
	SUPER:Init(oFieldSpec)
RETURN SELF
CLASS JapSingleEdit INHERIT SingleLineEdit
	EXPORT CalcActive AS LOGIC
	EXPORT oColumn AS DataColumn	
	EXPORT oBrowser as DataBrowser 
METHOD Init(oOwner, xID, oPoint, oDimension, kStyle) CLASS JapSingleEdit
	SUPER:Init(oOwner, xID, oPoint, oDimension, kStyle)
	IF CheckInstanceOf(oOwner,#DataBrowser)
		SELF:oBrowser:=oOwner
	ENDIF
	SELF:SetStyle(EDITLEFT,TRUE)
	RETURN SELF
METHOD KeyUp(oEvent) CLASS JapSingleEdit
//METHOD Dispatch(oEvent) CLASS JapSingleEdit
LOCAL uRet as USUAL
LOCAL cOperator AS STRING
LOCAL oWindow AS OBJECT
*LOCAL lUpdate AS LOGIC
LOCAL myValue AS STRING
uRet:=SUPER:KeyUp(oEvent)
IF ClassName(oEvent)==#KeyEvent
	IF CHR(oEvent:AsciiChar) $ "+-*/".and.!CalcActive.and.self:Fieldspec:Valtype=="N"
		cOperator:=CHR(oEvent:AsciiChar) 
		IF !Empty(Val(SELF:TEXTvalue)).or.!Empty(SELF:Value)
				
			CalcActive:=TRUE
			IF Empty(Val(SELF:TEXTvalue))
				myValue:=Str(SELF:Value)
				SELF:value:=0
				SELF:TextValue:=myValue
			ENDIF
*			lUpdate:= Empty(Val(SELF:TEXTvalue))
*			IF !lUpdate
				IF IsAccess(SELF:Owner:Owner,#Server)
					SELF:LinkDf(SELF:Owner:Owner:Server,;
					SELF:Owner:Owner:Server:FieldPos(SELF:FieldSpec:HyperLabel:NameSym))
				ENDIF
*			ENDIF
			oWindow:=GetParentWindow(SELF)
			(Calculator{oWindow,{self,cOperator,self:oBrowser,self:oColumn:NameSym}}):Show()
			IF IsAccess(SELF:Owner:Owner,#Server)
				SELF:oColumn:Value:=SELF:Value
*				IF !lUpdate.and.IsMethod(SELF:owner,#ColumnFocusChange)
				IF IsMethod(SELF:owner,#ColumnFocusChange)
					SELF:owner:ColumnFocusChange(SELF:oColumn, TRUE)
				ENDIF
				SELF:Owner:SetColumnFocus(SELF:Owner:GetColumn(SELF:owner:ColPos()+1))
			ENDIF
			CalcActive:=FALSE
		ENDIF
	ENDIF
ENDIF
RETURN uRet
CLASS mySingleEdit INHERIT SingleLineEdit
	EXPORT CalcActive AS LOGIC
	EXPORT oBrowser AS DataBrowser
	export oOwner as OBJECT
METHOD Init(oOwner, xID, oPoint, oDimension, kStyle) CLASS mySingleEdit
	SUPER:Init(oOwner, xID, oPoint, oDimension, kStyle)
	//self:oBrowser:=oOwner
	self:SetStyle(EDITLEFT,true)
	RETURN self
METHOD KeyUp(oEvent) CLASS mySingleEdit
LOCAL uRet AS USUAL
LOCAL cOperator AS STRING
LOCAL oWindow AS OBJECT
uRet:=SUPER:KeyUp(oEvent)
//IF ClassName(oEvent)==#KeyEvent
	IF CHR(oEvent:AsciiChar) $ "+-*/".and.SELF:Fieldspec:Valtype=="N"
		cOperator:=CHR(oEvent:AsciiChar)
		IF !Empty(Val(self:TEXTvalue)).or.!Empty(self:VALUE)
			IF Empty(Val(self:TEXTvalue))
				self:TEXTvalue:=Str(self:VALUE)
			ENDIF
			oWindow:=GetParentWindow(self) 
			self:oOwner:=self:oParent
			(Calculator{oWindow,{self,cOperator,self:oBrowser,self:NameSym}}):Show()
		ENDIF
	ENDIF
//ENDIF
RETURN uRet
