CLASS DepartmentExplorer INHERIT CustomExplorer 
declare method BuildListViewItems,PrintSubItem
METHOD BuildListViewItems(ParentNum:=0 as int ) as void pascal CLASS DepartmentExplorer
	LOCAL oListView			AS BalanceListView
	LOCAL oListViewItem		AS ListViewItem
	LOCAL FieldValue		as USUAL
	local nCurrentRec,nCurAcc as int
	local category as string
	// store list view locally for faster access
	oListView := SELF:ListView
	oListView:DeleteAll()
	// position the customer server on the specified value
	// 	oSubItemServer:Seek(#DepId,ParentNum)
	self:ListParent:=ParentNum

	// create child tree view items for all
	// child records that satisfy the relation 
	nCurrentRec:=AScan(self:aItem,{|x|x[2]==ParentNum},1)
	DO	WHILE	nCurrentRec>0
		oListViewItem := ListViewItem{}
		oListViewItem:ImageIndex	:= 1

		// for each field, set the value in the item
		Fieldvalue:="department"
		oListViewItem:SetValue(self:aItem[nCurrentRec,1], #Identifier)  //id
		oListViewItem:SetText(self:aItem[nCurrentRec,4], #Identifier)   // number
		oListViewItem:SetValue(self:aItem[nCurrentRec,3], #Description)
		oListViewItem:SetValue(FieldValue, #Type)
		oListView:AddItem(oListViewItem)

		nCurrentRec:=AScan(self:aItem,{|x|x[2]==ParentNum},nCurrentRec+1)
	ENDDO
	// add accounts:
	nCurAcc:=AScan(self:aAccnts,{|x|x[2]==ParentNum},1)
	DO WHILE nCurAcc>0 
		// add each corresponding account to the tree view
		oListViewItem := ListViewItem{}
		oListViewItem:ImageIndex	:=	3
		//	for each	field, set the	value	in	the item
		oListViewItem:SetValue(self:aAccnts[nCurAcc,1],#Identifier)  // accid
		oListViewItem:SetText(self:aAccnts[nCurAcc,4],	#Identifier)  //AccNumber
		oListViewItem:SetValue(self:aAccnts[nCurAcc,3],#Description)  //  description 
		category:=self:aAccnts[nCurAcc,5]
		IF	category==expense
			FieldValue:="Expense"
		ELSEIF category==income
			FieldValue:="Income"
		ELSEIF category==asset
			FieldValue:="Assets"
		ELSE
			FieldValue:="Liabilities&Funds"
		ENDIF
		oListViewItem:SetValue(FieldValue, #Type)
		oListView:AddItem(oListViewItem)
		nCurAcc:=AScan(self:aAccnts,{|x|x[2]==ParentNum},nCurAcc+1)
	ENDDO


	RETURN 
METHOD EditButton(lNew,lAccount, lListView) CLASS DepartmentExplorer
	LOCAL oEditDepartmentWindow AS EditDepartment
	LOCAL oEditAccountWindow AS EditAccount
	LOCAL aParms:={} AS ARRAY
	local oAccCnt as AccountContainer
	Default(@lAccount,FALSE)
	Default(@lNew,FALSE)
	Default(@lListView,true)
	aParms:=SUPER:EditButton(lNew,@lAccount,lListView)
	IF Empty(aParms)
		RETURN {}
	ENDIF
	IF lAccount 
		oAccCnt:=AccountContainer{}
		oAccCnt:m51_depid:=aParms[1] 
		oAccCnt:ACCID:= aParms[2]
		oEditAccountWindow:= EditAccount{self:Owner,,,{lNew,self,oAccCnt}}
		oEditAccountWindow:Show(SHOWCENTERED)
	ELSE
		oEditDepartmentWindow := EditDepartment{SELF:Owner,,,{lNew,aParms[1],"   ",aParms[2],SELF}  }
		oEditDepartmentWindow :Show(SHOWCENTERED)
	ENDIF
RETURN NIL
METHOD FilePrint CLASS DepartmentExplorer
	LOCAL kopregels AS ARRAY
	LOCAL nRow as int
	LOCAL nPage as int
	LOCAL oReport AS PrintDialog
	LOCAL nCurrRec as int
	LOCAL nLevel:=0 as int 
	local oDep as SQLselect 
	local aDep:={} as array

	oReport := PrintDialog{,"department Hierarchy",,83}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	kopregels := {oLan:get("department Hierarchy",,"!")}
	nRow := 0
	nPage := 0
	oDep:=SQLSelect{"SELECT distinct gr.itemid,gr.parentid,gr.description,gr.number,gr.type from ("+;
	"(SELECT distinct d1.depid as itemid,d1.parentdep as parentid,d1.descriptn as description,d1.deptmntnbr as number,'department' as type "+;
		"FROM `department` d1,department d2 where d1.parentdep=d2.depid or not d2.parentdep ) "+;
	"union "+; 
	"(select a.accid as itemid,a.department as parentid, a.description as description, a.accnumber as number,'account' as type "+;
		"from account a,department d2 where a.department=d2.depid or not a.department)) "+;
		"as gr order by gr.parentid,gr.type desc, gr.number",oConn} 
	oReport:PrintLine(@nRow,@nPage,"0: "+sEntity+" "+sLand,kopregels)
	if oDep:RecCount>0
		do while !oDep:EoF
			AAdd(aDep,{oDep:type,oDep:itemid,oDep:parentid,oDep:description,oDep:number})
			oDep:Skip()
		enddo
		DO WHILE TRUE
			nCurrRec:=self:PrintSubItem(nLevel,@nPage,@nRow,0,aDep,nCurrRec,oReport,kopregels)
			IF Empty(nCurrRec)
				EXIT
			ENDIF
		ENDDO
	endif
	oReport:prstart()
	oReport:prstop()
	RETURN nil
METHOD Init(oOwner, myType,myNum,myCaller,mySearch,myItemname) CLASS DepartmentExplorer
	* myType: in case you want only select a record: Balance Item /department / Account
	* mySearch: idem with searchvalue
	* myItemname: naam of searched item (e.g "from" or "to" (used in RegDepartment)
	Default(@myType,NULL_STRING)
	Default(@myNum,NULL_STRING)
	Default(@mYCaller,NULL_OBJECT)
	Default(@mySearch,NULL_STRING)
	Default(@myItemname,NULL_STRING)
	self:cType:=myType
	self:cNum:=myNum
	self:oCaller:= myCaller
	self:cSearch:=mySearch
	self:cItemName:=myItemname
	self:SelectedItem:=cSearch 

	SUPER:Init(oOwner, #DepartmentTreeView, #BalanceListView)
	// initialize menu and caption
	SELF:Menu:=WODepartmentSubMenu{}

   self:ListView:ContextMenu := DepartmentListViewMenu{}
	IF Empty(self:cType)
		self:Caption := "Exploring department Hierarchy: Of Who is it"
	ELSE
		self:Caption := "Selecting department: Of Who is it"
	ENDIF
RETURN SELF
METHOD InitData() CLASS DepartmentExplorer

	// create, initialize, and set the relation on the data servers
	self:cSubItemServer:="department"
	cRootName:="0:"+sEntity+" "+sLAND
	cRootValue:=0
	*	cRootName:= "0:Departments" 
	self:nMaxLevel:=1 
	self:sColumnmain:=#ParentDep
	self:sColumnSub:=#DEPID

	SUPER:InitData()
	RETURN NIL
METHOD PrintSubItem(nLevel as int,nPage ref int,nRow ref int,ParentNum as int,aDep as array, nCurrentRec:=0 as int, oReport as PrintDialog,kopregels as array) as int  CLASS DepartmentExplorer
	LOCAL nChildRec			as int
	LOCAL cCurNum			as int
	local nCurAcc as int

	IF !Empty(nCurrentRec).and.!aDep[nCurrentRec,3]==ParentNum
		nCurrentRec:=0
	endif
	nCurrentRec:=AScan(aDep,{|x|x[1]=="department".and.x[3]==ParentNum},nCurrentRec+1)
	IF Empty(nCurrentRec)
		* Append corresponding accounts:
		IF self:lShowAccount
			nCurAcc:=AScan(aDep,{|x|x[1]=="account".and.x[3]==ParentNum},1)
			
			DO WHILE nCurAcc>0 
				// print each corresponding account as part of the tree view
 				oReport:PrintLine(@nRow,@nPage,Space(nLevel*3+1)+"Account: "+aDep[nCurAcc,5]+": "+;
				aDep[nCurAcc,4],kopregels)
				nCurAcc:=AScan(aDep,{|x|x[1]=="account".and.x[3]==ParentNum},nCurAcc+1)
			ENDDO
		ENDIF
		RETURN 0
	ENDIF
	cCurNum:= aDep[nCurrentRec,2]
	// create each tree view item from a record in the
	// customer server and print itas part of the tree view
	oReport:PrintLine(@nRow,@nPage,Space(nLevel*3+1)+aDep[nCurrentRec,5]+": "+aDep[nCurrentRec,4],kopregels)

	// create child tree view items for all
	// child records that satisfy the relation
	DO WHILE TRUE
		nChildRec:=self:PrintSubItem(nLevel+1,@nPage,@nRow,cCurNum,aDep, nChildRec, oReport,kopregels)
		IF Empty(nChildRec)
			EXIT
		ENDIF
	ENDDO
RETURN nCurrentRec
METHOD TransferItem(sItemDrag , oItemDrop, lDBUpdate ) CLASS DepartmentExplorer
* Transfer TreeviewItems from MyDraglist  to oItemDrop, with its childs
* if lDBUpfate true: Update corresponding database items
*

	LOCAL nNum AS USUAL
	LOCAL nMain,nParId as STRING
	LOCAL cError AS STRING

	Default(@lDBUpdate,FALSE)

	* determine new main identifier:
	nMain:=SELF:GetIdFromSymbol(oItemDrop:NameSym)

	IF lDBUpdate
		* Update database first:
		* Dragged item identifier:
		nNum:=SELF:GetIdFromSymbol(sItemDrag)

*		IF oItemDrag:ImageIndex==3 //Account?
		IF SELF:IsAccountSymbol(sItemDrag)
			* update account: 
			SQLStatement{"update account set department='"+nMain+"' where accid='"+nNum+"'",oConn}:execute()
		ELSE
			* update department:
			cError:=ValidateTransition(nParId,nMain,nNum)
			IF! Empty(cError)
				(ErrorBox{,cError}):Show()
				RETURN cError
			ENDIF
			SQLStatement{"update department set parentdep='"+nNum+"' where depid='"+nNum+"'",oConn}:execute()
		ENDIF
	ENDIF

	SUPER:TransferItem(sItemDrag,oItemDrop)

RETURN
CLASS DepartmentTreeView inherit BalanceTreeView 
declare method AddSubItem
METHOD AddSubItem(ParentNum:=0 as int,lShowAccount as logic,aItem as array,aAccnts as array, nCurrentRec:=0 as int) as int CLASS DepartmentTreeView
	local oDep as SQLSelect
	local oAcc as SQLSelect
	LOCAL nChildRec			as int
	LOCAL cCurNum			as int
	local nCurAcc as int
	if Empty(aItem)
		oDep:=SQLSelect{"SELECT depid as itemid,parentdep as parentid,descriptn as description,deptmntnbr as number "+;
		"FROM `department` order by parentdep,deptmntnbr",oConn}
		if oDep:RecCount>0
			do while !oDep:EoF
				AAdd(aItem,{oDep:itemid,oDep:parentid,oDep:description,oDep:number})
				//          		 1         2           3              4            
				oDep:Skip()
			enddo
			IF lShowAccount
				// collect accounts:
				oAcc:=SQLSelect{"select a.accid as itemid,a.department as parentid, a.description as description, a.accnumber as number,a.balitemid,"+;
				"b.category,if(b.heading<>'',b.heading,b.footer) as balname "+;
				"from account a, balanceitem b where b.balitemid=a.balitemid order by parentid, number",oConn}
				if oAcc:RecCount>0 
					do while !oAcc:EoF
						AAdd(aAccnts,{oAcc:itemid,oAcc:parentid,oAcc:description,oAcc:number,oAcc:category}) 
						//                    1            2           3              4             5
						oAcc:Skip()
					enddo
				endif
			endif
		else
			return 0
		endif
	endif

	IF !Empty(nCurrentRec).and.!aItem[nCurrentRec,2]==ParentNum
		nCurrentRec:=0
	endif
	nCurrentRec:=AScan(aItem,{|x|x[2]==ParentNum},nCurrentRec+1)
	IF Empty(nCurrentRec)
		* Append corresponding accounts:
		IF lShowAccount
			nCurAcc:=AScan(aAccnts,{|x|x[2]==ParentNum},1)
			DO WHILE nCurAcc>0 
				// add each corresponding account to the tree view
				self:AddTreeItem(ParentNum,aAccnts[nCurAcc,1],"Account:"+aAccnts[nCurAcc,4]+" "+aAccnts[nCurAcc,3],true)
				nCurAcc:=AScan(aAccnts,{|x|x[2]==ParentNum},nCurAcc+1)
			ENDDO
		ENDIF
		RETURN 0
	ENDIF
	// create each tree view item from a record in the
	// customer server and add it to the tree view
	cCurNum:= aItem[nCurrentRec,1]
	self:AddTreeItem(ParentNum,aItem[nCurrentRec,1],aItem[nCurrentRec,4]+":"+aItem[nCurrentRec,3],false) 
	do WHILE true	
		// create child tree view items for all
		// child records that satisfy the relation
		nChildRec:=self:AddSubItem(cCurNum,lShowAccount,aItem,aAccnts,nChildRec)
 		IF Empty(nChildRec)
			exit
		ENDIF
	ENDDO
	
RETURN nCurrentRec
 
CLASS EditDepartment INHERIT DataWindowExtra 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCmDepartmntNbr AS SINGLELINEEDIT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCmDescription AS SINGLELINEEDIT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCmParentDep AS SINGLELINEEDIT
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON
	PROTECT oDCmCAPITAL AS SINGLELINEEDIT
	PROTECT oDCSC_SKAP AS FIXEDTEXT
	PROTECT oCCCAPButton AS PUSHBUTTON
	PROTECT oDCmPerson1 AS SINGLELINEEDIT
	PROTECT oCCPersonButton1 AS PUSHBUTTON
	PROTECT oDCmPerson2 AS SINGLELINEEDIT
	PROTECT oCCPersonButton2 AS PUSHBUTTON
	PROTECT oDCSC_CLN AS FIXEDTEXT
	PROTECT oDCGroupBox2 AS GROUPBOX
	PROTECT oDCmAccount1 AS SINGLELINEEDIT
	PROTECT oCCRek1Button AS PUSHBUTTON
	PROTECT oDCmAccount2 AS SINGLELINEEDIT
	PROTECT oCCRek2Button AS PUSHBUTTON
	PROTECT oDCmAccount3 AS SINGLELINEEDIT
	PROTECT oCCRek3Button AS PUSHBUTTON
	PROTECT oDCSC_CLN1 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	instance mDepartmntNbr 
	instance mDescription 
	instance mParentDep 
	instance mCAPITAL 
	instance mPerson1 
	instance mPerson2 
	instance mAccount1 
	instance mAccount2 
	instance mAccount3 
   PROTECT cCAPITALName as STRING
	PROTECT NbrCAPITAL AS STRING
  	PROTECT lNew AS LOGIC
	PROTECT oCaller AS OBJECT
	PROTECT OrgDescription AS STRING
	PROTECT OrgParent AS STRING
	PROTECT OrgDepNbr AS STRING
	PROTECT nCurRec AS INT
	PROTECT mDepId AS STRING
	PROTECT cContactName1,mCLN1,cContactName2,mCLN2 AS STRING
	PROTECT mAcc1 AS STRING
	PROTECT cAccount1Name AS STRING
	PROTECT mAcc2 AS STRING
	PROTECT cAccount2Name AS STRING
	PROTECT mAcc3 AS STRING
	PROTECT cAccount3Name as STRING 
	protect oDep as SQLSelect
                                 
declare method RekButton                                 
RESOURCE EditDepartment DIALOGEX  24, 22, 320, 204
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Department#:", EDITDEPARTMENT_FIXEDTEXT1, "Static", WS_CHILD, 8, 11, 53, 12
	CONTROL	"", EDITDEPARTMENT_MDEPARTMNTNBR, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 83, 11, 49, 12, WS_EX_CLIENTEDGE
	CONTROL	"Name:", EDITDEPARTMENT_FIXEDTEXT2, "Static", WS_CHILD, 8, 33, 53, 12
	CONTROL	"", EDITDEPARTMENT_MDESCRIPTION, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 84, 33, 174, 12, WS_EX_CLIENTEDGE
	CONTROL	"Parent department#:", EDITDEPARTMENT_FIXEDTEXT3, "Static", WS_CHILD, 8, 56, 67, 12
	CONTROL	"", EDITDEPARTMENT_MPARENTDEP, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 83, 56, 49, 12, WS_EX_CLIENTEDGE
	CONTROL	"OK", EDITDEPARTMENT_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 262, 7, 54, 12
	CONTROL	"Cancel", EDITDEPARTMENT_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 262, 21, 54, 12
	CONTROL	"", EDITDEPARTMENT_MCAPITAL, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 83, 80, 103, 12, WS_EX_CLIENTEDGE
	CONTROL	"Account Net Asset:", EDITDEPARTMENT_SC_SKAP, "Static", WS_CHILD, 8, 80, 63, 12
	CONTROL	"v", EDITDEPARTMENT_CAPBUTTON, "Button", WS_CHILD, 186, 80, 16, 12
	CONTROL	"", EDITDEPARTMENT_MPERSON1, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 82, 104, 104, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITDEPARTMENT_PERSONBUTTON1, "Button", WS_CHILD, 186, 104, 13, 12
	CONTROL	"", EDITDEPARTMENT_MPERSON2, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 82, 127, 104, 12, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITDEPARTMENT_PERSONBUTTON2, "Button", WS_CHILD, 186, 126, 13, 13
	CONTROL	"Contact person 1:", EDITDEPARTMENT_SC_CLN, "Static", WS_CHILD, 9, 105, 65, 12
	CONTROL	"Associated accounts for reporting:", EDITDEPARTMENT_GROUPBOX2, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 8, 147, 246, 32
	CONTROL	"", EDITDEPARTMENT_MACCOUNT1, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 16, 158, 58, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITDEPARTMENT_REK1BUTTON, "Button", WS_CHILD, 73, 158, 15, 13
	CONTROL	"", EDITDEPARTMENT_MACCOUNT2, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 94, 158, 58, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITDEPARTMENT_REK2BUTTON, "Button", WS_CHILD, 151, 158, 15, 13
	CONTROL	"", EDITDEPARTMENT_MACCOUNT3, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 172, 158, 59, 13, WS_EX_CLIENTEDGE
	CONTROL	"v", EDITDEPARTMENT_REK3BUTTON, "Button", WS_CHILD, 230, 158, 15, 13
	CONTROL	"Contact person 2:", EDITDEPARTMENT_SC_CLN1, "Static", WS_CHILD, 9, 128, 65, 12
END

METHOD CancelButton( ) CLASS EditDepartment
	SELF:EndWindow()


METHOD CAPButton( lUnique) CLASS EditDepartment
	LOCAL cfilter as string
	Default(@lUnique,FALSE)
	cfilter:=MakeFilter({self:NbrCAPITAL},{liability},"N",0,false)
	if !self:lNew 
		cfilter+= " and department="+self:mDepId
		AccountSelect(self,iif(Val(self:mDepId)>0,"",oDCmCAPITAL:TEXTValue ),"Net Asset",lUnique,cfilter,self:owner,false)
	endif
	RETURN NIL
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS EditDepartment
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lGotFocus.and.!IsNil(oControl:VALUE)
		IF oControl:Name == "MPERSON1".and.!AllTrim(oControl:Value)==AllTrim(cContactName1)
			IF Empty(oControl:Value) && leeg gemaakt?
				SELF:mCLN1 :=  ""
				SELF:cContactName1 := ""
				SELF:oDCmPerson1:TextValue := ""
         ELSE
				cContactName1:=AllTrim(oControl:Value)
				SELF:PersonButton1(TRUE)
			ENDIF
		ELSEIF oControl:Name == "MPERSON2".and.!AllTrim(oControl:Value)==AllTrim(cContactName2)
			IF Empty(oControl:Value) && leeg gemaakt?
				SELF:mCLN2 :=  ""
				SELF:cContactName2 := ""
				SELF:oDCmPerson2:TextValue := ""
         ELSE
				cContactName2:=AllTrim(oControl:Value)
				SELF:PersonButton2(TRUE)
			ENDIF
		ELSEIF oControl:Name == "MCAPITAL".and.!AllTrim(oControl:Value)==AllTrim(cCAPITALName)
			IF Empty(oControl:Value) && leeg gemaakt?
				SELF:NBrCAPITAL:="  "
				SELF:cCAPITALName := ""
				SELF:oDCmCAPITAL:TEXTValue := ""
            ELSE
				cCAPITALName:=AllTrim(oControl:Value)
				SELF:CAPButton(TRUE)
			ENDIF
		ELSEIF oControl:Name == "MACCOUNT1".and.!AllTrim(oControl:Value)==AllTrim(cAccount1Name)
			cAccount1Name:=AllTrim(oControl:Value)
			SELF:Rek1Button(TRUE)
		ELSEIF oControl:Name == "MACCOUNT2".and.!AllTrim(oControl:Value)==AllTrim(cAccount2Name)
			cAccount2Name:=AllTrim(oControl:Value)
			SELF:Rek2Button(TRUE)
		ELSEIF oControl:Name == "MACCOUNT3".and.!AllTrim(oControl:Value)==AllTrim(cAccount3Name)
			cAccount3Name:=AllTrim(oControl:Value)
			SELF:Rek3Button(TRUE)
ENDIF
	ENDIF

	RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditDepartment 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditDepartment",_GetInst()},iCtlID)

oDCFixedText1 := FixedText{SELF,ResourceID{EDITDEPARTMENT_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Department#:",NULL_STRING,NULL_STRING}

oDCmDepartmntNbr := SingleLineEdit{SELF,ResourceID{EDITDEPARTMENT_MDEPARTMNTNBR,_GetInst()}}
oDCmDepartmntNbr:HyperLabel := HyperLabel{#mDepartmntNbr,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmDepartmntNbr:FieldSpec := Department_DEPTMNTNBR{}

oDCFixedText2 := FixedText{SELF,ResourceID{EDITDEPARTMENT_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Name:",NULL_STRING,NULL_STRING}

oDCmDescription := SingleLineEdit{SELF,ResourceID{EDITDEPARTMENT_MDESCRIPTION,_GetInst()}}
oDCmDescription:HyperLabel := HyperLabel{#mDescription,NULL_STRING,NULL_STRING,NULL_STRING}
oDCmDescription:FieldSpec := Department_DESCRIPTN{}

oDCFixedText3 := FixedText{SELF,ResourceID{EDITDEPARTMENT_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Parent department#:",NULL_STRING,NULL_STRING}

oDCmParentDep := SingleLineEdit{SELF,ResourceID{EDITDEPARTMENT_MPARENTDEP,_GetInst()}}
oDCmParentDep:TooltipText := "Number of department to which this department belongs"
oDCmParentDep:HyperLabel := HyperLabel{#mParentDep,NULL_STRING,NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{EDITDEPARTMENT_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITDEPARTMENT_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCmCAPITAL := SingleLineEdit{SELF,ResourceID{EDITDEPARTMENT_MCAPITAL,_GetInst()}}
oDCmCAPITAL:HyperLabel := HyperLabel{#mCAPITAL,NULL_STRING,"Accountnumber for capital",NULL_STRING}
oDCmCAPITAL:TooltipText := "Account the department closes to at yera end"

oDCSC_SKAP := FixedText{SELF,ResourceID{EDITDEPARTMENT_SC_SKAP,_GetInst()}}
oDCSC_SKAP:HyperLabel := HyperLabel{#SC_SKAP,"Account Net Asset:",NULL_STRING,NULL_STRING}

oCCCAPButton := PushButton{SELF,ResourceID{EDITDEPARTMENT_CAPBUTTON,_GetInst()}}
oCCCAPButton:HyperLabel := HyperLabel{#CAPButton,"v","Browse in accounts",NULL_STRING}
oCCCAPButton:TooltipText := "Browse in accounts"

oDCmPerson1 := SingleLineEdit{SELF,ResourceID{EDITDEPARTMENT_MPERSON1,_GetInst()}}
oDCmPerson1:HyperLabel := HyperLabel{#mPerson1,null_string,"The person, who is contact for the department","HELP_CLN"}
oDCmPerson1:FocusSelect := FSEL_HOME
oDCmPerson1:UseHLforToolTip := True

oCCPersonButton1 := PushButton{SELF,ResourceID{EDITDEPARTMENT_PERSONBUTTON1,_GetInst()}}
oCCPersonButton1:HyperLabel := HyperLabel{#PersonButton1,"v","Browse in persons",NULL_STRING}
oCCPersonButton1:TooltipText := "Browse in Persons"

oDCmPerson2 := SingleLineEdit{SELF,ResourceID{EDITDEPARTMENT_MPERSON2,_GetInst()}}
oDCmPerson2:HyperLabel := HyperLabel{#mPerson2,null_string,"The person, who is contact for the department","HELP_CLN"}
oDCmPerson2:FocusSelect := FSEL_HOME
oDCmPerson2:UseHLforToolTip := True

oCCPersonButton2 := PushButton{SELF,ResourceID{EDITDEPARTMENT_PERSONBUTTON2,_GetInst()}}
oCCPersonButton2:HyperLabel := HyperLabel{#PersonButton2,"v","Browse in persons",NULL_STRING}
oCCPersonButton2:TooltipText := "Browse in Persons"

oDCSC_CLN := FixedText{SELF,ResourceID{EDITDEPARTMENT_SC_CLN,_GetInst()}}
oDCSC_CLN:HyperLabel := HyperLabel{#SC_CLN,"Contact person 1:",NULL_STRING,NULL_STRING}

oDCGroupBox2 := GroupBox{SELF,ResourceID{EDITDEPARTMENT_GROUPBOX2,_GetInst()}}
oDCGroupBox2:HyperLabel := HyperLabel{#GroupBox2,"Associated accounts for reporting:",NULL_STRING,NULL_STRING}

oDCmAccount1 := SingleLineEdit{SELF,ResourceID{EDITDEPARTMENT_MACCOUNT1,_GetInst()}}
oDCmAccount1:HyperLabel := HyperLabel{#mAccount1,null_string,"Number of account associated with the department",null_string}
oDCmAccount1:FocusSelect := FSEL_HOME
oDCmAccount1:TooltipText := "Account to be incorperated in memberstatements"
oDCmAccount1:UseHLforToolTip := True

oCCRek1Button := PushButton{SELF,ResourceID{EDITDEPARTMENT_REK1BUTTON,_GetInst()}}
oCCRek1Button:HyperLabel := HyperLabel{#Rek1Button,"v","Browse in accounts",NULL_STRING}
oCCRek1Button:TooltipText := "Browse in accounts"

oDCmAccount2 := SingleLineEdit{SELF,ResourceID{EDITDEPARTMENT_MACCOUNT2,_GetInst()}}
oDCmAccount2:HyperLabel := HyperLabel{#mAccount2,null_string,"Number of account associated with the department",null_string}
oDCmAccount2:FocusSelect := FSEL_HOME
oDCmAccount2:TooltipText := "Account to be incorperated in memberstatements"
oDCmAccount2:UseHLforToolTip := True

oCCRek2Button := PushButton{SELF,ResourceID{EDITDEPARTMENT_REK2BUTTON,_GetInst()}}
oCCRek2Button:HyperLabel := HyperLabel{#Rek2Button,"v","Browse in accounts",NULL_STRING}
oCCRek2Button:TooltipText := "Browse in accounts"

oDCmAccount3 := SingleLineEdit{SELF,ResourceID{EDITDEPARTMENT_MACCOUNT3,_GetInst()}}
oDCmAccount3:HyperLabel := HyperLabel{#mAccount3,null_string,"Number of account associated with the department",null_string}
oDCmAccount3:FocusSelect := FSEL_HOME
oDCmAccount3:TooltipText := "Account to be incorperated in memberstatements"
oDCmAccount3:UseHLforToolTip := True

oCCRek3Button := PushButton{SELF,ResourceID{EDITDEPARTMENT_REK3BUTTON,_GetInst()}}
oCCRek3Button:HyperLabel := HyperLabel{#Rek3Button,"v","Browse in accounts",NULL_STRING}
oCCRek3Button:TooltipText := "Browse in accounts"

oDCSC_CLN1 := FixedText{SELF,ResourceID{EDITDEPARTMENT_SC_CLN1,_GetInst()}}
oDCSC_CLN1:HyperLabel := HyperLabel{#SC_CLN1,"Contact person 2:",NULL_STRING,NULL_STRING}

self:Caption := "Edit of department"
self:HyperLabel := HyperLabel{#EditDepartment,"Edit of department",null_string,null_string}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mAccount1() CLASS EditDepartment
RETURN SELF:FieldGet(#mAccount1)

ASSIGN mAccount1(uValue) CLASS EditDepartment
SELF:FieldPut(#mAccount1, uValue)
RETURN uValue

ACCESS mAccount2() CLASS EditDepartment
RETURN SELF:FieldGet(#mAccount2)

ASSIGN mAccount2(uValue) CLASS EditDepartment
SELF:FieldPut(#mAccount2, uValue)
RETURN uValue

ACCESS mAccount3() CLASS EditDepartment
RETURN SELF:FieldGet(#mAccount3)

ASSIGN mAccount3(uValue) CLASS EditDepartment
SELF:FieldPut(#mAccount3, uValue)
RETURN uValue

ACCESS mCAPITAL() CLASS EditDepartment
RETURN SELF:FieldGet(#mCAPITAL)

ASSIGN mCAPITAL(uValue) CLASS EditDepartment
SELF:FieldPut(#mCAPITAL, uValue)
RETURN uValue

ACCESS mDepartmntNbr() CLASS EditDepartment
RETURN SELF:FieldGet(#mDepartmntNbr)

ASSIGN mDepartmntNbr(uValue) CLASS EditDepartment
SELF:FieldPut(#mDepartmntNbr, uValue)
RETURN uValue

ACCESS mDescription() CLASS EditDepartment
RETURN SELF:FieldGet(#mDescription)

ASSIGN mDescription(uValue) CLASS EditDepartment
SELF:FieldPut(#mDescription, uValue)
RETURN uValue

ACCESS mParentDep() CLASS EditDepartment
RETURN SELF:FieldGet(#mParentDep)

ASSIGN mParentDep(uValue) CLASS EditDepartment
SELF:FieldPut(#mParentDep, uValue)
RETURN uValue

ACCESS mPerson1() CLASS EditDepartment
RETURN SELF:FieldGet(#mPerson1)

ASSIGN mPerson1(uValue) CLASS EditDepartment
SELF:FieldPut(#mPerson1, uValue)
RETURN uValue

ACCESS mPerson2() CLASS EditDepartment
RETURN SELF:FieldGet(#mPerson2)

ASSIGN mPerson2(uValue) CLASS EditDepartment
SELF:FieldPut(#mPerson2, uValue)
RETURN uValue

METHOD OKButton( ) CLASS EditDepartment
	LOCAL oDep:=self:oDep,oSel as SQLSelect
	LOCAL cMainId  as STRING
	LOCAL cError as STRING
	local cSQLStatement as string
	local oStmnt as SQLStatement

	IF Empty(mDepartmntNbr)
		(ErrorBox{,"Please fill number of department"}):Show()
		RETURN
	ENDIF
	IF lNew.or.!AllTrim(mDepartmntNbr)==AllTrim(OrgDepNbr)
		*Check if Number allready exist:
		IF SQLSelect{"select depid from department where deptmntnbr='"+AllTrim(mDepartmntNbr)+"'",oConn}:Reccount>0
			(ErrorBox{,"department number "+ mDepartmntNbr+ " allready exist!"}):Show()
			RETURN
		ENDIF
	ENDIF
	cError:=ValidateTransition(@cMainId,self:mParentDep,self:mDepId)
	IF !Empty(cError)
 		(Errorbox{,cError}):Show()
 		RETURN
	ENDIF

	IF SELF:lNew
		IF !Empty(SELF:NbrCAPITAL)
			(ErrorBox{,"Net asset account "+self:cCAPITALName+" does not belong to department"+ mDepartmntNbr}):Show()
			RETURN
		ENDIF		
		oDep:Append()
	ENDIF
	cSQLStatement:=iif(self:lNew,"insert into ","update ")+" department set "+; 
	"deptmntnbr='"+AllTrim(self:mDepartmntNbr)+"',"+;
	"descriptn='"+AllTrim(self:mDescription)+"',"+;
	"parentdep='"+cMainId+"',"+;
	"netasset='"+self:NbrCAPITAL+"',"+;
	"assacc1 ='"+ mAcc1+"',"+;
	"assacc2 ='"+ mAcc2+"',"+;
	"assacc3 ='"+ mAcc3+"',"+;
	"persid ='"+ mCLN1+"',"+;
	"persid2 ='"+ mCLN2+"'"+;
	iif(self:lNew,""," where depid='"+self:mDepId+"'")
	oStmnt:=SQLStatement{cSQLStatement,oConn}
	oStmnt:Execute()
	if oStmnt:NumSuccessfulRows>0
		Departments:=true
		oCaller:Refresh()
		IF !lNew
			IF !OrgDescription==mDescription.or.!OrgParent==mParentDep.or.!OrgDepNbr=mDepartmntNbr
				oCaller:RefreshTree()
			ENDIF
		else
			self:mDepId:=SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)
			oCaller:Treeview:AddTreeItem(Val(cMainId),self:mDepId,AllTrim(mDepartmntNbr)+":"+mDescription,false)
		ENDIF
	endif
	self:EndWindow()

RETURN
METHOD PersonButton1(lUnique ) CLASS EditDepartment
	LOCAL cValue := AllTrim(oDCmPerson1:TEXTValue ) AS STRING
	Default(@lUnique,FALSE)
	PersonSelect(self,cValue,lUnique,iif(Empty(self:mCLN2),"","persid<>"+self:mCLN2),"Contactperson1")
	RETURN NIL


METHOD PersonButton2(lUnique ) CLASS EditDepartment
	LOCAL cValue := AllTrim(oDCmPerson2:TEXTValue ) AS STRING
	Default(@lUnique,FALSE)
	PersonSelect(self,cValue,lUnique,iif(Empty(self:mCLN1),"","persid<>"+self:mCLN1),"Contactperson2")
	RETURN NIL

METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditDepartment
	//Put your PostInit additions here
	LOCAL cMainId as STRING
	local oSel as SQLSelect 
	self:SetTexts()
	lNew:=uExtra[1]

	IF lNew
		SELF:oDCmDepartmntNbr:SetFocus()
		cMainId:=uExtra[2]
		NbrCAPITAL :=""
		cCAPITALName :="" 
		IF cMainId=="0"
			mParentDep:=0
			OrgParent :="0"
		ELSE
			oSel:=SQLSelect{"select deptmntnbr from department where depid='"+cMainId+"'",oConn}
			IF self:oDep:Reccount>0
				mParentDep:=oDep:deptmntnbr
				OrgParent :=mParentDep
			endif
		ENDIF

	ELSE
		self:mDepId:=uExtra[4] 
		self:oDep:=SQLSelect{"select d.*,dp.deptmntnbr as deptmntnbrparent,an.description as captital,ass1.description as ass1,ass2.description as ass2,ass3.description as ass3,"+SQLFullName(0,"p1")+" as person1," +;
		SQLFullName(0,"p2")+" as person2 "+;
		"from department d "+;
		"left join account an on (an.accid=d.netasset) "+; 
		"left join department dp on (dp.depid=d.parentdep) "+; 
		"left join person p1 on (p1.persid=d.persid) "+; 
		"left join person p2 on (p2.persid=d.persid2) "+; 
		"left join account as ass1 on (d.assacc1=ass1.accid) "+;
		" left join account as ass2 on (d.assacc2=ass2.accid) "+;
		" left join account as ass3 on (d.assacc3=ass3.accid) "+;
		"where d.depid='"+self:mDepId+"'",oConn} 
		IF !Empty(self:oDep:NetAsset)
			self:NbrCAPITAL :=  Str(self:oDep:NetAsset,-1)
			self:oDCmCAPITAL:TEXTValue := AllTrim(self:oDep:captital)
			self:cCAPITALName := AllTrim(self:oDep:captital)
		ENDIF
		if !Empty(self:oDep:ASSACC1)
			mAcc1 := Str(self:oDep:ASSACC1,-1)
			mAccount1 := AllTrim(self:oDep:ass1)
			cAccount1Name := mAccount1
		endif
		if !Empty(self:oDep:ASSACC2)
			mAcc2 := Str(self:oDep:ASSACC2,-1)
			mAccount2 := AllTrim(self:oDep:ass2)
			cAccount2Name := mAccount2
		endif
		if !Empty(self:oDep:ASSACC3)
			mAcc3 := Str(self:oDep:ASSACC3,-1)
			mAccount3 := AllTrim(self:oDep:ass3)
			cAccount3Name := mAccount3
		endif
		mDepartmntNbr:=self:oDep:deptmntnbr
		OrgDepNbr:=AllTrim(mDepartmntNbr)
		if !Empty(self:oDep:ParentDep)
			cMainId:=Str(self:oDep:ParentDep,-1)
			mParentDep:=oDep:deptmntnbrparent
			OrgParent :=mParentDep
		else
			cMainId:="0"
			mParentDep:=0
			OrgParent :="0"
		ENDIF
		mDescription:=self:oDep:descriptn
		OrgDescription:=mDescription
		if !Empty(self:oDep:persid)
			mCLN1 := Str(self:oDep:persid,-1)
			mPerson1 := self:oDep:Person1
			cContactName1 := mPerson1
		endif
		if !Empty(self:oDep:persid2)
			mCLN2 := Str(self:oDep:persid2,-1)
			mPerson2 := self:oDep:Person2
			cContactName2 := mPerson2
		endif
	ENDIF
	oCaller:=uExtra[5]
	RETURN nil
METHOD RegAccount(oAccA,ItemName) CLASS EditDepartment
IF !Empty(oAccA).and.oAccA:reccount>0
	IF ItemName=="Net Asset"
		self:NbrCAPITAL :=  Str(oAccA:accid,-1)
		self:oDCmCAPITAL:TEXTValue := AllTrim(oAccA:Description)
		self:cCAPITALName := AllTrim(oAccA:Description)
	ELSEIF ItemName=="Associated Account 1"
		self:mAcc1 :=  Str(oAccA:accid,-1)
		self:oDCmAccount1:TEXTValue := AllTrim(oAccA:Description)
		self:cAccount1Name := AllTrim(oAccA:Description)
	ELSEIF ItemName=="Associated Account 2"
		self:mAcc2 :=  Str(oAccA:accid,-1)
		self:oDCmAccount2:TEXTValue := AllTrim(oAccA:Description)
		self:cAccount2Name := AllTrim(oAccA:Description)
	ELSEIF ItemName=="Associated Account 3"
		self:mAcc3 :=  Str(oAccA:accid,-1)
		self:oDCmAccount3:TEXTValue := AllTrim(oAccA:Description)
		self:cAccount3Name := AllTrim(oAccA:Description)
	ENDIF
ELSE
	IF ItemName=="Net Asset"
		self:NbrCAPITAL:="0"
		SELF:oDCmCAPITAL:TEXTValue := " "
		SELF:cCAPITALName := " "
	ELSEIF ItemName=="Associated Account 1"
		self:mAcc1 :=  null_string
		SELF:oDCmAccount1:TEXTValue := NULL_STRING
		self:cAccount1Name := null_string
	ELSEIF ItemName=="Associated Account 2"
		self:mAcc2 :=  null_string
		SELF:oDCmAccount2:TEXTValue := NULL_STRING
		SELF:cAccount2Name := NULL_STRING
	ELSEIF ItemName=="Associated Account 3"
		self:mAcc3 := null_string
		SELF:oDCmAccount3:TEXTValue := NULL_STRING
		SELF:cAccount3Name := NULL_STRING
	ENDIF
ENDIF

RETURN TRUE
METHOD RegPerson(oCLN,ItemName) CLASS EditDepartment
IF !Empty(oCLN).and.!oCLN:EoF
	IF ItemName=="Contactperson1"
		self:mCLN1 :=  Str(oCLN:persid,-1)
		self:cContactName1 := GetFullName(self:mCLN1)
		SELF:oDCmPerson1:TEXTValue := SELF:cContactName1
	ELSEif ItemName=="Contactperson2"
		self:mCLN2 :=  Str(oCLN:persid,-1)
		self:cContactName2 := GetFullName(self:mCLN2)
		SELF:oDCmPerson2:TEXTValue := SELF:cContactName2
	ENDIF
ELSE
	IF ItemName=="Contactperson1"
		SELF:mCLN1 :=  ""
		SELF:cContactName1 := ""
		SELF:oDCmPerson1:TEXTValue := ""
	ELSEIF ItemName=="Contactperson2"
		SELF:mCLN2 :=  ""
		SELF:cContactName2 := ""
		SELF:oDCmPerson2:TEXTValue := ""
	ENDIF		
ENDIF
RETURN TRUE
METHOD Rek1Button(lUnique ) CLASS EditDepartment 
	Default(@lUnique,FALSE)
self:RekButton(logic(_cast,lUnique),AllTrim(oDCmAccount1:TextValue ),"Associated Account 1",mAcc1,mAcc2,mAcc3)
return
METHOD Rek2Button(lUnique ) CLASS EditDepartment
	Default(@lUnique,FALSE)
self:RekButton(lUnique,AllTrim(oDCmAccount2:TextValue ),"Associated Account 2",mAcc2,mAcc1,mAcc3)
return 
METHOD Rek3Button(lUnique ) CLASS EditDepartment
	Default(@lUnique,FALSE)
self:RekButton(lUnique,AllTrim(oDCmAccount3:TextValue ),"Associated Account 3",mAcc3,mAcc2,mAcc3)
return 
METHOD RekButton(lUnique:=false as logic,cValue as string,cName as string,myAcc1 as string,myAcc2 as string,myAcc3 as string ) as void pascal CLASS EditDepartment 
	local aAccIncl:={},aAccExcl:={} as array 
	local cfilter as string
	if !Empty(myAcc1)
		AAdd(aAccIncl,myAcc1)
	endif
	if !Empty(myAcc2)
		AAdd(aAccExcl,myAcc2)
	endif
	if !Empty(myAcc3)
		AAdd(aAccExcl,myAcc3)
	endif
// 	AccountSelect(self,cValue ,cName,lUnique,;
// 		iif(myAcc1==null_string,'','accid='+myAcc1+' or ')+;
// 		'subscriptionprice=0'+iif(self:lNew,'',' and department<>'+Str(self:Server:DEPID,-1))+;
// 		iif(myAcc2==null_string,'',' and accid<>'+myAcc2)+;
// 		iif(myAcc3==null_string,'',' and accid<>'+myAcc3)+;
// 		iif(SKAP==null_string,'',' and accid<>'+SKAP)+;
// 		iif(SKAS==null_string,'',' and accid<>'+SKAS)+;
// 		iif(SDEB==null_string,'',' and accid<>'+SDEB)+;
// 		iif(SAM==null_string,'',' and accid<>'+sam)+;
// 		iif(SHB==null_string,'',' and accid<>'+SHB)+;
// 		iif(SKRUIS==null_string,'',' and accid<>'+SKruis),,false) 
	cfilter:=MakeFilter(aAccIncl,{income,liability,asset,expense},"B",,,aAccExcl)
	AccountSelect(self,cValue,cName,lUnique,cfilter,self:Owner,)

	RETURN 
STATIC DEFINE EDITDEPARTMENT_CANCELBUTTON := 107 
STATIC DEFINE EDITDEPARTMENT_CAPBUTTON := 110 
STATIC DEFINE EDITDEPARTMENT_FIXEDTEXT1 := 100 
STATIC DEFINE EDITDEPARTMENT_FIXEDTEXT2 := 102 
STATIC DEFINE EDITDEPARTMENT_FIXEDTEXT3 := 104 
STATIC DEFINE EDITDEPARTMENT_GROUPBOX2 := 116 
STATIC DEFINE EDITDEPARTMENT_MACCOUNT1 := 117 
STATIC DEFINE EDITDEPARTMENT_MACCOUNT2 := 119 
STATIC DEFINE EDITDEPARTMENT_MACCOUNT3 := 121 
STATIC DEFINE EDITDEPARTMENT_MCAPITAL := 108 
STATIC DEFINE EDITDEPARTMENT_MDEPARTMNTNBR := 101 
STATIC DEFINE EDITDEPARTMENT_MDESCRIPTION := 103 
STATIC DEFINE EDITDEPARTMENT_MPARENTDEP := 105 
STATIC DEFINE EDITDEPARTMENT_MPERSON1 := 111 
STATIC DEFINE EDITDEPARTMENT_MPERSON2 := 113 
STATIC DEFINE EDITDEPARTMENT_OKBUTTON := 106 
STATIC DEFINE EDITDEPARTMENT_PERSONBUTTON1 := 112 
STATIC DEFINE EDITDEPARTMENT_PERSONBUTTON2 := 114 
STATIC DEFINE EDITDEPARTMENT_REK1BUTTON := 118 
STATIC DEFINE EDITDEPARTMENT_REK2BUTTON := 120 
STATIC DEFINE EDITDEPARTMENT_REK3BUTTON := 122 
STATIC DEFINE EDITDEPARTMENT_SC_CLN := 115 
STATIC DEFINE EDITDEPARTMENT_SC_CLN1 := 123 
STATIC DEFINE EDITDEPARTMENT_SC_SKAP := 109 
Function FindDep(cDep ref string) as logic
*	Find a department with the given number/description
*	Returns: True: if unique department found
*			 False: if not found (department:EOF-TRUE) or not unique found (current record found )
*		
*
LOCAL lUnique as LOGIC
local oDep as SQLSelect
IF Empty(cDep).or.cDep=="0"
	cDep:="0"  // Rootvalue
	RETURN true
ENDIF
IF IsDigit(psz(_cast,AllTrim(cDep))) 
	oDep:=SQLSelect{"select depid from department where deptmntnbr='"+AllTrim(cDep)+"'",oConn}
ELSE
	oDep:=SQLSelect{"select depid from department where descriptn like '"+AllTrim(cDep)+"%'",oConn}
ENDIF
IF oDep:Reccount=1
	cDep:=Str(oDep:DEPID,-1) 
	lUnique:=true
ENDIF
RETURN lUnique
Function ValidateTransition(cNewParentId:="0" ref string,cNewParentNbr:="0" as string,curdepid:="" as string) as string
* Check if transition of currentdepartment to new parent is allowed
*
* If not allowed: returns errormessage text
* Input::
*	cNewParentNbr: number of required new parent of current department , or
*	cNewParentId : identifier of required new parent of current department
*
*
LOCAL cError as STRING
local oDepPar,oDepCur as SQLSelect
IF cNewParentNbr=="0" .and. cNewParentId="0"
	RETURN ""
ENDIF
oDepPar:=SQLSelect{"select depid,deptmntnbr,parentdep from department where "+iif(cNewParentId="0".or.Empty(cNewParentId),"deptmntnbr='"+cNewParentNbr,"depid='"+cNewParentId)+"'",oConn}
if oDepPar:Reccount=0
		RETURN "parent department does not exist"	
endif
IF Str(oDepPar:DEPID,-1)==curdepid
	cError:="Parent must be unqual to self"
	RETURN cError
ENDIF
if !curdepid=="0" .and.!Empty(curdepid)
	oDepCur:=SQLSelect{"select depid,deptmntnbr,parentdep from department where depid='"+curdepid+"'",oConn}
	IF oDepPar:deptmntnbr==oDepCur:deptmntnbr
		cError:="Parent must be unqual to self"
		RETURN cError
	endif
endif
cNewParentId:=Str(oDepPar:DEPID,-1)
RETURN cError
