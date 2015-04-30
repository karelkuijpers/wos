CLASS BalanceItemExplorer INHERIT CustomExplorer 
declare method BuildListViewItems, PrintSubItem
METHOD BuildListViewItems(ParentNum:=0 as int) as void pascal CLASS BalanceItemExplorer
	LOCAL oListView			AS BalanceListView
	LOCAL oListViewItem		AS ListViewItem
	LOCAL FieldValue		as USUAL
	local nCurrentRec,nCurAcc as int
	local category as string
	// store list view locally for faster access
	oListView := SELF:ListView
	oListView:DeleteAll()
	// position the customer server on the specified value
	// 	oSubItemServer:Seek(#NUM,ParentNum)
	self:ListParent:=ParentNum

	// create child tree view items for all
	// child records that satisfy the relation 
	nCurrentRec:=AScan(self:aItem,{|x|x[2]==ParentNum},1)
	DO	WHILE	nCurrentRec>0
		oListViewItem := ListViewItem{}
		oListViewItem:ImageIndex	:=	1
		
		//	for each	field, set the	value	in	the item 
		category:=self:aItem[nCurrentRec,5]
		IF	category==expense
			FieldValue:="Expense"
		ELSEIF category==income
			FieldValue:="Income"
		ELSEIF category==asset
			FieldValue:="Assets"
		ELSE
			FieldValue:="Liabilities&Funds"
		ENDIF
		oListViewItem:SetValue(self:aItem[nCurrentRec,1],self:sListIdentify)  // balitemid
		oListViewItem:SetText(self:aItem[nCurrentRec,4],self:sListIdentify)   //  number
		oListViewItem:SetValue(self:aItem[nCurrentRec,3], self:sListDescription)  // heading
		oListViewItem:SetValue(FieldValue, self:sListType)
		oListView:AddItem(oListViewItem)
		nCurrentRec:=AScan(self:aItem,{|x|x[2]==ParentNum},nCurrentRec+1)
		
	END DO
	// add accounts:
	nCurAcc:=AScan(self:aAccnts,{|x|x[2]==ParentNum},1)
	DO WHILE nCurAcc>0 
		// add each corresponding account to the tree view
		oListViewItem := ListViewItem{}
		oListViewItem:ImageIndex	:=	3
		//	for each	field, set the	value	in	the item
		oListViewItem:SetValue(self:aAccnts[nCurAcc,1],self:sListIdentify)  // accid
		oListViewItem:SetText(self:aAccnts[nCurAcc,4],	self:sListIdentify)  //accnumber
		oListViewItem:SetValue(self:aAccnts[nCurAcc,3],self:sListDescription)  //  description
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
		oListViewItem:SetValue(FieldValue, self:sListType)
		oListView:AddItem(oListViewItem)
		nCurAcc:=AScan(self:aAccnts,{|x|x[2]==ParentNum},nCurAcc+1)
	ENDDO

	RETURN 
METHOD EditButton(lNew,lAccount,lListView) CLASS BalanceItemExplorer
	LOCAL oEditBalanceItemWindow AS EditBalanceItem
	LOCAL oEditAccountWindow AS EditAccount
	LOCAL aParms:={} as ARRAY 
	local oAccCnt as AccountContainer
	Default(@lAccount,FALSE)
	Default(@lNew,FALSE)
	Default(@lListView,true)
	aParms:=SUPER:EditButton(lNew,@lAccount,lListView) 
	IF Empty(aParms)
		RETURN NIL
	ENDIF
	IF lAccount
		oAccCnt:=AccountContainer{}
		oAccCnt:m51_balid:=aParms[1] 
		oAccCnt:ACCID:= aParms[2]
		oEditAccountWindow:= EditAccount{self:Owner,,,{lNew,self,oAccCnt}}
		oEditAccountWindow:Show(SHOWCENTERED)
	ELSE
		oEditBalanceItemWindow := EditBalanceItem{SELF:Owner,,,{lNew,aParms[1],aParms[2],"   ",SELF}  }
		oEditBalanceItemWindow:Show(SHOWCENTERED)
	ENDIF
	RETURN NIL
METHOD FilePrint CLASS BalanceItemExplorer
	LOCAL kopregels AS ARRAY
	LOCAL nRow as int
	LOCAL nPage as int
	LOCAL oReport AS PrintDialog
	LOCAL nCurrRec			as int
	LOCAL nLevel:=0 as int
	local aBal:={} as array
	local oBal as SQLSelect

	oReport := PrintDialog{,"Balance Items structure",,83}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	kopregels := {oLan:RGet("Balance Items structure",,"!")}
	nRow := 0
	nPage := 0
	oReport:PrintLine(@nRow,@nPage,self:cRootName,kopregels)

	oBal:=SQLSelect{"SELECT distinct gr.itemid,gr.parentid,gr.description,gr.number,gr.type from ("+;
		"(SELECT distinct b1.balitemid as itemid,b1.balitemidparent as parentid,b1.heading as description,b1.number as number,'balanceitem' as type "+;
		"from balanceitem b1,balanceitem b2 where b1.balitemidparent=b2.balitemid or not b2.balitemidparent ) "+;
		"union "+;
		"(SELECT a.accid as itemid,a.balitemid as parentid, a.description as description, a.accnumber as number,'account' as type "+;
		"from account a,balanceitem b2 where a.balitemid=b2.balitemid or not a.balitemid)) as gr order by gr.parentid,gr.type desc, gr.number",oConn}

	if oBal:RecCount>0
		do while !oBal:EoF
			AAdd(aBal,{oBal:type,oBal:itemid,oBal:parentid,oBal:description,oBal:number})
			oBal:Skip()
		enddo
		DO WHILE true
			nCurrRec:=self:PrintSubItem(nLevel,@nPage,@nRow,0,aBal,nCurrRec,oReport,kopregels)
			IF Empty(nCurrRec)
				exit
			ENDIF
		ENDDO
	endif

	oReport:prstart()
	oReport:prstop()
	RETURN nil


METHOD Init(oOwner,myType,myNum,myCaller,mySearch) CLASS BalanceItemExplorer
	* myType: in case you want only select a record: Balance Item /Department / Account
	* myNum: idem with identifier of current balance item
	* mySearch: idem with searchvalue
	*
	Default(@myType,NULL_STRING)
	Default(@myNum,NULL_STRING)
	Default(@mYCaller,NULL_OBJECT)
	Default(@mySearch,NULL_STRING)
	self:cType:=myType
	self:CItemname:=myType
	self:cNum:=myNum
	self:cSearch:=mySearch
	self:oCaller:= myCaller
	self:nMaxLevel:=2 
	SUPER:Init(oOwner, #BalanceTreeView, #BalanceListView)
	// initialize menu and caption
*	BalMenu:=BrowserEdit{SELF}
*	Balmenu:Insertitem(BalanceSubmenu{},"Insert Record",IDM_BrowserEdit_Edit_Insert_Record_ID)
*	BalMenu:DeleteItem(IDM_BrowserEdit_Edit_Insert_Record_ID)
*	SELF:Menu:=BalMenu
	SELF:Menu:=WOBalanceSubMenu{}
*	SELF:Toolbar:InsertItem(IDT_ARROW,IDM_BalanceSubmenu_Balance_Item_ID,10)
*	SELF:Toolbar:AddTipText(IDT_ARROW,IDM_BalanceSubmenu_Balance_Item_ID,"Insert Balance Item")

*	SELF:Toolbar:InsertItem(IDT_INDENT,IDM_BalanceSubmenu_Account_ID,11)
*	SELF:Toolbar:AddTipText(IDT_INDENT,IDM_BalanceSubmenu_Account_ID,"Insert Account")
*    SELF:Toolbar:DeleteItem(IDM_BrowserEdit_Edit_Insert_Record_ID)
	SaveUse(self)

   	SELF:ListView:ContextMenu := BalListViewMenu{}
    IF Empty(self:cType)
		SELF:Caption := "Exploring Balance Items: What is it"
	ELSE
		SELF:Caption := "Selecting Balance Item: What is it"
	ENDIF		
RETURN SELF
METHOD InitData() CLASS BalanceItemExplorer

	// create, initialize, and set the relation on the data servers
// 	oMainItemServer	:= BalanceItem{}      // order on HFDRUBRNUM 
// 	oSubItemServer:= BalanceItem{} 
	self:cMainItemServer:="balanceitem"
	self:cSubitemserver:="balanceitem"

	self:cRootName:= "0:Balance Items"
	self:cRootValue:=0
	self:sColumnmain:=#balitemidparent
	self:sColumnSub:=#balitemid
	SUPER:InitData()
	RETURN NIL
METHOD PrintSubItem(nLevel as int,nPage ref int,nRow ref int,ParentNum as int,aBal as array, nCurrentRec:=0 as int, oReport as PrintDialog,kopregels as array) as int  CLASS BalanceItemExplorer
	LOCAL nChildRec			as int
	LOCAL cCurNum			as int
	local nCurAcc as int

	IF !Empty(nCurrentRec).and.!aBal[nCurrentRec,3]==ParentNum
		nCurrentRec:=0
	endif
	nCurrentRec:=AScan(aBal,{|x|x[1]=="balanceitem".and.x[3]==ParentNum},nCurrentRec+1)
	IF Empty(nCurrentRec)
		* Append corresponding accounts:
		IF self:lShowAccount
			nCurAcc:=AScan(aBal,{|x|x[1]=="account".and.x[3]==ParentNum},1)
			
			DO WHILE nCurAcc>0 
				// print each corresponding account as part of the tree view
 				oReport:PrintLine(@nRow,@nPage,Space(nLevel*3+1)+"Account: "+aBal[nCurAcc,5]+": "+;
				aBal[nCurAcc,4],kopregels)
				nCurAcc:=AScan(aBal,{|x|x[1]=="account".and.x[3]==ParentNum},nCurAcc+1)
			ENDDO
		ENDIF
		RETURN 0
	ENDIF
	cCurNum:= aBal[nCurrentRec,2]
	// create each tree view item from a record in the
	// customer server and print itas part of the tree view
	oReport:PrintLine(@nRow,@nPage,Space(nLevel*3+1)+aBal[nCurrentRec,5]+": "+aBal[nCurrentRec,4],kopregels)

	// create child tree view items for all
	// child records that satisfy the relation
	DO WHILE true
		nChildRec:=self:PrintSubItem(nLevel+1,@nPage,@nRow,cCurNum,aBal, nChildRec, oReport,kopregels)
		IF Empty(nChildRec)
			exit
		ENDIF
	ENDDO
RETURN nCurrentRec

METHOD TransferItem(aItemDrag as array , oItemDrop as TreeViewItem, lDBUpdate:=false as logic ) as string CLASS BalanceItemExplorer
	* Transfer TreeviewItems from MyDraglist  to oItemDrop, with its childs
	* if lDBUpfate true: Update corresponding database items
	*

	LOCAL nNum as USUAL
	LOCAL nMain,cType as STRING 
	LOCAL cError as STRING
	local oStmnt as SQLStatement

	* determine new main identifier:
	nMain:=self:GetIdFromSymbol(oItemDrop:NameSym)

	IF lDBUpdate
		* Update database first:
		* Dragged item identifier:
		nNum:=self:GetIdFromSymbol(aItemDrag[1] )

		// 		IF self:IsAccountSymbol(sItemDrag) 
		if aItemDrag[2] :ImageIndex==3       // account?
			* update account:
			* check transfer allowed:
			cError:=ValidateAccTransfer(nMain,nNum)
			IF Empty(cError) 
				oStmnt:=SQLStatement{"update account set balitemid='"+nMain+"' where accid='"+nNum+"'",oConn}
				oStmnt:execute()
				if !Empty(oStmnt:Status)
					cError:="Could not transfer account item:"+oStmnt:ErrInfo:ErrorMessage
					return cError
				endif
			ELSE
				(ErrorBox{,cError}):Show()
				RETURN cError
			ENDIF
			// 			ENDIF
		ELSE
			* update balance item:
			cError:=self:ValidateBalanceTransition(nMain,,nNum,@cType)
			IF !Empty(cError)
				(ErrorBox{,cError}):Show()
				RETURN cError
			ENDIF
			// 				ELSE
			// 					(ErrorBox{,cError+"; Classification of destination does not correspond with Balance Item:"+;
			// 					AllTrim(IVarGet(oSubItemServer,#Number))+"  "+AllTrim(IVarGet(oSubItemServer,#Heading))}):Show()
			// 					RETURN cError
			// 				ENDIF 
			// 		update balance item:
			oStmnt:=SQLStatement{"update balanceitem set balitemidparent='"+nMain+"' where balitemid='"+nNum+"'",oConn}
			oStmnt:execute()
			if !Empty(oStmnt:Status)
				cError:="Could not transfer balance item:"+oStmnt:ErrInfo:ErrorMessage
				return cError
			endif
		ENDIF
	ENDIF

	SUPER:TransferItem(aItemDrag,oItemDrop,lDBUpdate)


	RETURN cError
CLASS BalanceListView INHERIT ListView

METHOD SortByDescription(oListViewItem1, oListViewItem2) CLASS BalanceListView
	LOCAL uValue1	AS USUAL
	LOCAL uValue2	AS USUAL

    uValue1 := oListViewItem1:GetValue(self:Owner:sListDescription)
    uValue2 := oListViewItem2:GetValue(self:Owner:sListDescription)

    IF uValue1 > uValue2
    	RETURN 1
    ELSEIF uValue1 < uValue2
    	RETURN -1
    ENDIF

	RETURN 0

METHOD SortByIdentifier(oListViewItem1, oListViewItem2) CLASS BalanceListView
	LOCAL uValue1	AS USUAL
	LOCAL uValue2	AS USUAL

    uValue1 := oListViewItem1:GetText(self:Owner:sListIdentify)
    uValue2 := oListViewItem2:GetText( self:Owner:sListIdentify)

    IF uValue1 > uValue2
    	RETURN 1
    ELSEIF uValue1 < uValue2
    	RETURN -1
    ENDIF

	RETURN 0

METHOD SortByType(oListViewItem1, oListViewItem2) CLASS BalanceListView
	LOCAL uValue1	AS USUAL
	LOCAL uValue2	AS USUAL

    uValue1 := oListViewItem1:GetValue( self:Owner:sListType )
    uValue2 := oListViewItem2:GetValue(self:Owner:sListType)

    IF uValue1 > uValue2
    	RETURN 1
    ELSEIF uValue1 < uValue2
    	RETURN -1
    ENDIF

	RETURN 0

CLASS BalanceTreeView INHERIT TreeView  
declare method AddSubItem, AddTreeItem,ExpandTree,GetChildItem 
METHOD AddSubItem(ParentNum:=0 as int,lShowAccount as logic,aItem as array,aAccnts as array, nCurrentRec:=0 as int,lInclInactive:=false as logic) as int CLASS BalanceTreeView
	LOCAL nChildRec			as int
	LOCAL cCurNum			as int
	local nCurAcc as int
	local oBal,oAcc as SQLSelect
	if Empty(aItem)
		oBal:=SQLSelect{"SELECT balitemid as itemid,balitemidparent as parentid,heading as description,number as number,category from balanceitem order by balitemidparent,balitemid",oConn}
		if oBal:RecCount>0
			do while !oBal:EoF
				AAdd(aItem,{oBal:itemid,oBal:parentid,iif(empty(oBal:description),'',oBal:description),oBal:number,oBal:category}) 
				//                1            2                 3          4          5        
				oBal:Skip()
			enddo
			if lShowAccount
				// collect accounts: 
				oAcc:=SQLSelect{"select a.accid as itemid,a.balitemid as parentid, a.description as description, a.accnumber as number,"+;
					"b.category,if(b.heading<>'',b.heading,b.footer) as balname "+;
					"from account a, balanceitem b where b.balitemid=a.balitemid order by parentid, number",oConn}
				if oAcc:RecCount>0 
					do while !oAcc:EoF
						AAdd(aAccnts,{oAcc:itemid,oAcc:parentid,oAcc:description,oAcc:NUMber,oAcc:category}) 
						//                  1            2           3              4             5
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
		nChildRec:=self:AddSubItem(cCurNum,lShowAccount,aItem,aAccnts,nChildRec,lInclInactive)
		IF Empty(nChildRec)
			exit
		ENDIF
	ENDDO
	
	RETURN nCurrentRec
	
METHOD AddTreeItem(uParentNum:=0 as int,uChildNum as int,mKoptekst as string,lAccount:=false as logic) as void pascal CLASS BalanceTreeView
	LOCAL oTreeViewItem		AS TreeViewItem
	LOCAL lSuccess AS LOGIC
	LOCAL cIdName:="Parent" AS STRING
	oTreeViewItem := TreeViewItem{}
	oTreeViewItem:Value			:= mKoptekst
	IF lAccount
		* Account:
		oTreeViewItem:ImageIndex	:= 3
		oTreeViewItem:SelectedImageIndex := 4
		cIdName:="ACCOUNT"
	ELSE // Balance item
		oTreeViewItem:ImageIndex	:= 1
		oTreeViewItem:SelectedImageIndex := 2
		cIdName:="Parent"
	ENDIF
	oTreeViewItem:NameSym		:= String2Symbol(cIdName+"_" + Str(uChildNum,-1))
	* Save symbolic name in array for search:
	AAdd(SELF:Owner:aSearch,{Upper(mKoptekst),oTreeViewItem:NameSym})
	lSuccess:=self:AddItem(String2Symbol("Parent_" +Str(uParentNum,-1)), oTreeViewItem)
	RETURN
METHOD ExpandTree (oTreeItem as TreeViewItem,nLevel:=0 as int,nMaxLevel:=99 as int) as void pascal CLASS BalanceTreeView
	* Expand a treeitem with its subsiding items
	*	nLevel: current level
	*	nMaxLevel: required max level TO Expand

	LOCAL oTreeViewItem		AS TreeViewItem
	LOCAL aItemValue:={} AS ARRAY
// 	Default(@nMaxLevel,99)
// 	Default(@nLevel,0)
	// store tree view locally for faster access
	IF nLevel>nMaxLevel
		RETURN
	ENDIF
	SELF:Expand(oTreeItem)
	oTreeViewItem:=SELF:GetFirstChildItem(oTreeItem)
	IF !Empty(oTreeViewItem)
		*	Track used items because of system error in next siblling
		aItemValue:={oTreeViewItem:Value}
	ENDIF
	DO WHILE !Empty( oTreeViewItem )
		SELF:ExpandTree(oTreeViewItem,nLevel+1,nMaxLevel)
		oTreeViewItem:=SELF:GetNextSiblingItem(oTreeViewItem)
		IF !Empty(oTreeViewItem)
			IF AScan(aItemValue,oTreeViewItem:Value)>0
				* Allready found: Stop
				EXIT
			ELSE
				AAdd(aItemValue,oTreeViewItem:Value)
			ENDIF
		ENDIF
	ENDDO
	RETURN
METHOD GetChildItem( symItem as symbol ) as Treeviewitem CLASS BalanceTreeView

    LOCAL symFoundItem AS SYMBOL
    LOCAL sItem IS _WINTV_ITEM

    sItem.hItem := SELF:__GetHandleFromSymbol( symItem )
    symFoundItem := SELF:__GetSymbolFromHandle(TreeView_GetChild(SELF:Handle(), sItem.hItem ) )
    RETURN SELF:GetItemAttributes(symFoundItem)
CLASS CustomExplorer INHERIT ExplorerWindow
	// 	PROTECT oMainItemServer	as SQLTable
	// 	PROTECT oSubItemServer	as SQLTable
	// 	PROTECT oAccount		AS Account
	PROTECT uCurrentMain:='' as USUAL
	HIDDEN aDragList AS ARRAY   // array with treeview items to drag
	PROTECT oTVItemDrop AS TreeViewItem
	PROTECT oLVItemDrop AS ListViewItem
	EXPORT lTreeDragging AS LOGIC
	EXPORT lListDragging AS LOGIC
	EXPORT cRootName as STRING, cRootValue as int
	Protect cMainItemServer,cSubitemserver as string 
	
	PROTECT hImageList AS PTR
	PROTECT oCCOKButton AS PUSHBUTTON
	Export oCaller as OBJECT
	Export cType as STRING // type of record to be selected: "Balance Item", "Department","Department member"
	PROTECT cNum AS STRING // identifier of current item when cType is filled
	export cSearch as STRING // searchstring of required item when cType is filled
	Export cItemname as STRING // name of required item when cType is filled
	EXPORT lShowAccount:=true as LOGIC
	Export lInclInactive:=false as logic
	PROTECT ListParent as int
	EXPORT oTreeOptions AS ExplorerOptions
	EXPORT nMaxLevel:=1 as int
	EXPORT aSearch:={} AS ARRAY
	EXPORT nStartSearch as int 
	export SelectedItem as String 
	protect sColumnmain, sColumnSub as Symbol
	Protect oLan as Language
	export aAccnts:={} as array
	export aItem:={} as array 
	export sListIdentify,sListDescription,sListType as symbol // symbols for listview columns
	declare method BuildTreeViewItems,GetChild,GetTreeFromListItem,IsChildOf,ValidateBalanceTransition, GetIdFromSymbol,TransferItem
METHOD Append ()  CLASS CustomExplorer
	SELF:EditButton(TRUE)
	RETURN
METHOD AppendAccount ()  CLASS CustomExplorer
	self:EditButton(true,true,false)
	RETURN
METHOD BuildListViewColumns() CLASS CustomExplorer
	LOCAL oListView			as BalanceListView

	// store list view locally for faster access
	oListView := self:ListView
	oListView:DeleteAllColumns()

	// for each field in the balance item server, create a
	// list view column and add it to the list view
	oListView:AddColumn(ListViewColumn{11,self:oLan:WGet("Identifier")})
	oListView:AddColumn(ListViewColumn{29,self:oLan:WGet("Description")})
	oListView:AddColumn(ListViewColumn{14,self:oLan:WGet("Type")})


	RETURN nil

METHOD BuildTreeViewItems() as void pascal CLASS CustomExplorer
	LOCAL oTreeView			as BalanceTreeView
	LOCAL oTreeViewItem		as TreeViewItem
	LOCAL lSuccess			as LOGIC
	LOCAL nCurrRec			as int

	// store tree view locally for faster access
	oTreeView := self:TreeView

	// add the master tree view item
	oTreeViewItem			:= TreeViewItem{}
	oTreeViewItem:NameSym	:= String2Symbol("Parent_"+Str(cRootValue,-1))
	oTreeViewItem:TextValue	:=cRootName
	oTreeViewItem:Bold		:= true
	lSuccess:=oTreeView:AddItem(#Root, oTreeViewItem)
	* Save symbolic name in array for search:
	self:aSearch:={{Upper(cRootName),oTreeViewItem:NameSym}}
	self:aItem:={}
	self:aAccnts:={} 
	do WHILE true
		nCurrRec:=oTreeView:AddSubItem(self:cRootValue,self:lShowAccount,self:aItem,self:aAccnts,nCurrRec,self:lInclInactive)
		IF Empty(nCurrRec)
			exit
		ENDIF
	ENDDO

	oTreeViewItem:=oTreeView:GetRootItem()
	oTreeView:ExpandTree(oTreeViewItem,0,nMaxLevel)
	self:BuildListViewColumns()
	Send(self,#BuildListViewItems,self:cRootValue)
	// 	self:TreeView:SelectItem(#FIRST)
	RETURN 
METHOD Close(oCloseEvent) CLASS CustomExplorer

	// clean up the open data servers

	RETURN SUPER:Close(oCloseEvent)


METHOD Cut()  CLASS CustomExplorer
	LOCAL oTreeView AS BalanceTreeView
	LOCAL oListView AS BalanceListView
	LOCAL oListViewItem		AS ListViewItem
	LOCAL oTVItemDrag AS TreeViewItem
	LOCAL i AS INT
	oTreeView:=SELF:TreeView
	oListView:=SELF:ListView
	aDragList:={}
	FOR i=1 TO oListView:ItemCount
		oListViewItem:=oListView:GetItemAttributes(i)
		IF oListViewItem:Selected
			* Determine corresponding Treeview item
			AAdd(aDragList,{self:GetTreeFromListItem(oListViewItem),oListViewItem})
			oListViewItem:Selected:=FALSE
			oListView:SetItemAttributes(oListViewItem)
		ENDIF
	NEXT
	IF  ALen(aDragList)>0
		SELF:lListDragging:=TRUE
	ELSE
		oTVItemDrag := oTreeView:GetSelectedItem()
		IF !oTVItemDrag==NULL_OBJECT
			IF oTVItemDrag:NameSym = #ROOT
				oTVItemDrag := NULL_OBJECT
				RETURN
			ENDIF
			SELF:lTreeDragging := TRUE
			self:aDragList:={{oTVItemDrag:NameSym,oTVItemDrag}}
		ENDIF
	ENDIF
RETURN
METHOD DELETE() CLASS CustomExplorer
	LOCAL oTextbox as TextBox
	LOCAL oListView			as BalanceListView
	LOCAL oListViewItem		as ListViewItem
	LOCAL nNum, cNumber as STRING
	local cNameSym as symbol
	LOCAL lAccount as LOGIC
	local oStmnt as SQLStatement
	local oSel as SQLSelect
	local lBalance:=(ClassName(self)==#BALANCEITEMEXPLORER) as logic
	local nPos as int
	local oMem as SQLSelect

	oListView := self:ListView
	oListViewItem:=oListView:GetSelectedItem()
	IF !Empty(oListViewItem)
		nNum:=ConS(oListViewItem:GetValue(self:sListIdentify))
		cNumber:=oListViewItem:GetText(self:sListIdentify)
		lAccount:=(oListViewItem:MyImageIndex==3)
		cNameSym:= self:GetTreeFromListItem(oListViewItem)
	ENDIF
	IF Empty(nNum)
		(ErrorBox{,self:oLan:WGet('Select a record within the right pane first')}):Show()
		RETURN
	ENDIF
	IF lAccount
	   IF AScan(aMenu,{|x| x[4]=="AccountEdit"})>0
			if DeleteAccount(nNum)
				self:ListView:DeleteItem(oListViewItem:ItemIndex)
				self:TreeView:DeleteItem(String2Symbol("ACCOUNT_" + nNum))
				nPos:=AScan(self:aAccnts,{|x|x[1]==Val(nNum)})
				if nPos>0
					ADel(self:aAccnts,nPos)
					aSize(self:aAccnts,len(self:aAccnts)-1)
				endif
			ENDIF
		ENDIF
	ELSE
		oTextbox := TextBox{ self, "Delete Record",;
			self:oLan:WGet('Delete item')+' '+AllTrim(cNumber)+"?" }
		oTextbox:Type := BUTTONYESNO + BOXICONQUESTIONMARK

		IF ( oTextbox:Show() == BOXREPLYYES ) 

			* Check presence of childitems:
			oSel:=SQLSelect{"select	count(*) as ChildCount from "+self:cSubitemserver+" where "+ Lower(Symbol2String(self:sColumnmain))+"='"+nNum+"'",oConn}
			if	oSel:RecCount>0 .and. ConI(oSel:childcount)>0
				(ErrorBox{,self:oLan:WGet('Remove child items first')}):Show()
				RETURN
			ELSE
				* check presence of accounts:
				IF	SqlSelect{"select	accid from	account where "+iif(lBalance,"balitemid","department")+"='"+nNum+"'",oConn}:RecCount>0
//							oAccount:Seek(#NUM,nNum)
					(ErrorBox{,self:oLan:WGet('Remove/replace child accounts first')}):Show()
					RETURN
				ENDIF
			endif
			// check if department belongs to member:
			if !lBalance
				oMem:=SqlSelect{"select m.mbrid,"+SQLFullName(0,"p")+" as membername from member m,person as p where m.depid IS NOT NULL and m.depid="+nNum+" and p.persid=m.persid",oConn}
				if oMem:RecCount>0
					(ErrorBox{,self:oLan:WGet('This department belongs to member'+":"+oMem:membername)}):Show()
					RETURN					
				ENDIF				
			ENDIF
			oStmnt:=SQLStatement{'delete from '+self:cSubitemserver+' where '+Lower(Symbol2String(self:sColumnSub))+"='"+nNum+"'",oConn}
			oStmnt:Execute()	
			if	oStmnt:NumSuccessfulRows>0
				// delete from aItem with all balance items  
				nPos:=AScan(self:aItem,{|x|x[1]==Val(nNum)})
				if nPos>0
					ADel(self:aItem,nPos)
					aSize(self:aItem,len(self:aItem)-1)
				endif
				// delete also from aSearch with searchinfo
				nPos:=AScan(self:aSearch,{|x|x[2]==cNameSym})
				if nPos>0
					ADel(self:aSearch,nPos)
					aSize(self:aSearch,len(self:aSearch)-1)
				endif
				self:ListView:DeleteItem(oListViewItem:ItemIndex)
				self:TreeView:DeleteItem(String2Symbol("Parent_" +	nNum))
			ENDIF
		ENDIF
	ENDIF

RETURN nil
METHOD DeleteListViewItems() CLASS CustomExplorer
	if IsObject(self:ListView) .and. !self:listview==null_object
		RETURN self:listview:DeleteAll()
	endif
	return false
METHOD DeleteTreeViewItems() CLASS CustomExplorer
	RETURN SELF:TreeView:DeleteAll()

METHOD Dispatch( oEvent ) CLASS CustomExplorer

	LOCAL sDispInfo AS _winNM_LISTVIEW

	IF oEvent:Message == WM_MOUSEMOVE
		IF SELF:lTreeDragging .or. SELF:lListDragging
			SELF:TreeViewDragMove( LoWord( oEvent:lParam ) , HiWord( oEvent:lParam ) )
			RETURN 0
		ENDIF
	ENDIF

	IF oEvent:Message == WM_LBUTTONUP
		IF SELF:lTreeDragging .or.SELF:lListDragging
			SELF:TreeViewDragEnd( LoWord( oEvent:lParam ) , HiWord( oEvent:lParam ) )
			RETURN 0
		ENDIF
	ENDIF

	IF oEvent:Message == WM_NOTIFY
		IF !SELF:TreeView==NULL_OBJECT.and.!SELF:ListView==NULL_OBJECT
			IF SELF:TreeView:DragDropEnabled.and.SELF:ListView:DragDropEnabled
				sDispInfo := PTR( _CAST , oEvent:lParam )
				IF sDispInfo != NULL_PTR
					IF sDispInfo.hdr._code == DWORD(TVN_BEGINDRAG) .or. sDispInfo.hdr._code == DWORD(LVN_BEGINDRAG)
						SELF:TreeViewDragBegin( oEvent )
						RETURN 0
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN SUPER:Dispatch( oEvent )
METHOD EditButton(lNew,lAccount, lListView) CLASS CustomExplorer
	*	returns as array:	 nNum: identification of selected record
	*			nMain: identification of parent item
	*
	LOCAL oTreeView			as BalanceTreeView
	LOCAL oTreeViewItem		as TreeViewItem
	LOCAL oListView			as BalanceListView
	LOCAL oListViewItem		as ListViewItem
	LOCAL nNum:="0" 		as STRING
	LOCAL nMain:="0" as STRING 
	local oSel as SQLSelect 

	Default(@lNew,FALSE)
	Default(@lAccount,FALSE)
	Default(@lListView,true) 
	IF !lNew
		if lListView
			oListView := self:ListView
			oListViewItem:=oListView:GetSelectedItem()
			IF !Empty(oListViewItem)
				nNum:=Str(oListViewItem:GetValue(self:sListIdentify),-1)
				// 				nNum:=oListViewItem:GetValue(self:sListIdentify)
				lAccount:=(oListViewItem:MyImageIndex==3)
			else
				oTreeView:=self:TreeView
				oTreeViewItem:=oTreeView:GetSelectedItem()
				nNum:=self:GetIdFromSymbol(oTreeViewItem:NameSym)
// 				lAccount:=self:IsAccountSymbol(oTreeViewItem:NameSym)				
				lAccount:=(oTreeViewItem:ImageIndex==3)				
			endif
		else
			oTreeView:=self:TreeView
			oTreeViewItem:=oTreeView:GetSelectedItem()
			nNum:=self:GetIdFromSymbol(oTreeViewItem:NameSym)
			lAccount:=(oTreeViewItem:ImageIndex==3)				
// 			lAccount:=self:IsAccountSymbol(oTreeViewItem:NameSym)				
		endif
		IF Empty(nNum)
			(ErrorBox{,"Select a record within the right pane first"}):Show()
			RETURN {}
		ENDIF
	ELSE
		oTreeView:=self:TreeView
		oTreeViewItem:=oTreeView:GetSelectedItem()
		if !oTreeViewItem==null_object
			nMain:=self:GetIdFromSymbol(oTreeViewItem:NameSym)
		endif
	ENDIF
	IF lAccount
		oSel:=SQLSelect{"select balitemid from account where accid='"+nNum+"'",oConn} 
		if oSel:RecCount>0
			nMain:=Str(oSel:balitemid,-1)
		ENDIF
	ENDIF
	RETURN {nMain,nNum}
METHOD GetChild(aChild as array, ParentSym as symbol) as void pascal CLASS CustomExplorer
* Add all child of a parent with symbolname ParentSym to array aChild
	LOCAL oTVChild AS TreeViewItem
	oTVChild := SELF:TreeView:GetChildItem( ParentSym )
	DO WHILE oTVChild != NULL_OBJECT
		AAdd( aChild , { ParentSym , oTVChild } )
		SELF:GetChild(aChild, oTVChild:NameSym)
		oTVChild := SELF:TreeView:GetNextSiblingItem( oTVChild:NameSym )
	ENDDO
	RETURN 
METHOD GetIdFromSymbol(NameSym as symbol) as string CLASS CustomExplorer
	LOCAL nId AS STRING
	LOCAL wlen AS INT

	* determine identifier:
	nId:=Symbol2String(NameSym)
	wLen:=At("_",nId)
RETURN SubStr(nId,wLen+1)
METHOD GetTreeFromListItem(oListViewItem as ListViewItem ) as symbol CLASS CustomExplorer
LOCAL nNUm AS STRING, lAccount AS LOGIC
* Determine corresponding Treeview item namesys:
nNum:=ConS(oListViewItem:GetValue(self:sListIdentify))
// lAccount:=(oListViewItem:GetValue(self:sListType)=="Account")
lAccount:=(oListViewItem:ImageIndex == 3)  //  Account?
RETURN String2Symbol(if(lAccount,"ACCOUNT","Parent")+"_" + nNUm)
METHOD Init(oOwner,SymTree,SymList) CLASS CustomExplorer
	LOCAL oDimension	AS Dimension
	LOCAL oImageList	AS ImageList
	LOCAL oTreeView		AS BalanceTreeView
	LOCAL oListView		AS BalanceListView
	

	// initialize super class with no labels, and
	// the specified view control subclasses
*	SUPER:Init(oOwner, !Empty(cType),SymTree,SymList)
self:SetTexts()
	SUPER:Init(oOwner, true,SymTree,SymList) 
	IF Empty(self:cType)
		self:lShowAccount:=true

		oDimension:=SELF:Size
		oDimension:Width:=oDimension:Width*115/100
		oDimension:Height:=oDimension:Height*140/100
		SELF:Size:=oDimension
		SELF:Origin:=Point{0,0}
   else
		self:lShowAccount:=false   	
	ENDIF
	// store the view controls locally for faster access
	oTreeView := SELF:TreeView
	oListView := SELF:ListView

	SELF:Icon := IconTwo{}
	SELF:IconSm := IconTwo{}
	oTreeview:EnableDragDrop(TRUE)
	oListView:EnableDragDrop(TRUE)
	SELF:lTreeDragging := FALSE
	SELF:lListDragging := FALSE

	// initialize components of the list view
	oListView:ViewAs(#ReportView)
	oListView:EnableSort(#SortOrders)

	// create the icon objects for the image lists
	oImageList := ImageList{4, Dimension{20, 20}}
	oImageList:Add(BOOKE2ICO{})
	oImageList:Add(OBOOKE2ICO{})
	oImageList:Add(ICONTWO{})
	oImageList:Add(ICONONE{})
	oTreeView:ImageList := oImageList

	oListView:SmallImageList := oImageList
	oImageList := ImageList{4, Dimension{32, 32}}
	oImageList:Add(OBOOKE2ICO{})
	oImageList:Add(BOOKE2ICO{})
	oImageList:Add(ICONTWO{})
	oImageList:Add(ICONONE{})
	oListView:LargeImageList := oImageList

	// initialize pane sizes
	lShowAccount:=Empty(cType)
	oTreeOptions:=ExplorerOptions{SELF,{lShowAccount,FALSE,cSearch}}
	oDimension := self:GetPaneSize(1)
	oDimension:Height := oTreeOptions:Size:Height
	self:SetPaneSize(oDimension, 1)
	oDimension:Width := oDimension:Width * 3 / 2
	self:SetPaneSize(oDimension, 2) 
	IF Empty(self:cType)
		SELF:SetPaneClient(oTreeOptions,1)
	ELSE
		SELF:SetPaneClient(ExplorerClick{SELF},1)
		SELF:SetPaneClient(oTreeOptions,2)
	ENDIF
	
	// initialize listview column symbols:
	self:sListIdentify:=String2Symbol(self:oLan:WGet("Identifier"))
	self:sListDescription:=String2Symbol(self:oLan:WGet("Description"))
	self:sListType:=String2Symbol(self:oLan:WGet("Type"))
	

	// initialize data
	SELF:InitData()
	IF!Empty(cSearch)
		self:oTreeOptions:SearchButton(FALSE)
	ENDIF

	RETURN SELF

METHOD InitData() CLASS CustomExplorer

	// build list view columns and tree view items; it is unnecessary
	// to build list view items until a tree view item has been selected
*	SELF:BuildListViewColumns(oMainItemServer) 
	self:BuildTreeViewItems()
    IF !Empty(cType).and.!Empty(cNum)
    	  self:TreeView:SelectItem(String2Symbol("Parent_"+cNum))
    	  if cType!="Account"
    	  		self:SelectedItem:=cNum
    	  endif
    ENDIF
	RETURN NIL
METHOD IsAccountSymbol(NameSym) CLASS CustomExplorer
	LOCAL nId AS STRING
	LOCAL wlen AS INT

	* determine identifier:
	nId:=Symbol2String(NameSym)
	wLen:=At("_",nId)
RETURN SubStr(nId,1,wLen-1)=="ACCOUNT"



METHOD IsChildOf(Childid as int,ParentId as int) as logic  CLASS CustomExplorer 
	// check if item with ItemId=ParentId is PARENT of item with ItemId=ChildId
	LOCAL nChildRec,nParentId			as int
	// self:aItem: {itemid,parentid,description,number,category},.. 
	//                 1       2          3       4       5        
	if Childid=0 .or. ParentId=0
		return false
	endif 
	nChildRec:=AScan(self:aItem,{|X|X[1]==Childid})
	do while nChildRec>0 .and.(!self:aItem[nChildRec,2]==ParentId .and.self:aItem[nChildRec,2]>0)
		nParentId:=self:aItem[nChildRec,2]
		// find its Parent
		nChildRec:=AScan(self:aItem,{|X|X[2]==nParentId},nChildRec+1 )
	enddo
	if nChildRec>0 .and. self:aItem[nChildRec,2]==ParentId
// 		LogEvent(self,"nChildRec:"+Str(nChildRec,-1)+";its parent:"+Str(self:aItem[nChildRec,2],-10)+"; Childid:"+Str(Childid,-1)+"; parent searched for:"+Str(ParentId,-1),"logsql") 
		return true
	endif
// 		LogEvent(self,"nChildRec:"+Str(nChildRec,-1)+"; Childid:"+Str(Childid,-1)+"; parent searched for:"+Str(ParentId,-1),"logsql") 
return false

METHOD ListViewColumnClick(oListViewClickEvent) CLASS CustomExplorer
	LOCAL symColumnName AS SYMBOL

	SUPER:ListViewColumnClick(oListViewClickEvent)

	symColumnName := oListViewClickEvent:ListViewColumn:NameSym

	// based on the column name, set the appropriate sort routine name
	DO CASE
		CASE symColumnName == self:sListIdentify
			SELF:ListView:EnableSort(#SortByIdentifier)

		CASE symColumnName == self:sListDescription
			SELF:ListView:EnableSort(#SortByDescription)

		CASE symColumnName == #Type
			SELF:ListView:EnableSort(#SortByType)

	END CASE

	// execute the sort
	SELF:ListView:SortItems()

	RETURN NIL

METHOD ListViewMouseButtonDoubleClick(oListViewMouseEvent)  CLASS CustomExplorer
	LOCAL oListViewItem AS ListViewItem
	oListViewItem:=oListViewMouseEvent:ListViewItem
	IF !Empty(oListViewItem)
		oListViewItem:Selected:=TRUE
		self:EditButton()
	ENDIF
	RETURN
method ListViewMouseButtonDown(oListViewMouseEvent) class CustomExplorer
	LOCAL oListViewItem		as ListViewItem
	oListViewItem:=oListViewMouseEvent:ListViewItem 
	if IsObject( oListViewItem)
		if IsMethod(oListViewItem,#GetValue)
			if !oListViewItem:ImageIndex==1 
				self:SelectedItem:=Str(oListViewItem:GetValue(self:sListIdentify),-1)
			endif
		endif
	endif
   return
METHOD OKButton CLASS CustomExplorer
//Local cItem as string
//	cItem:=self:GetIdFromSymbol((self:oTreeView:GetSelectedItem()):NameSym)
	IF !self:oCaller==null_object
		IF self:cType="Balance"
		    IF IsMethod(SELF:oCaller, #RegBalance)
				self:oCaller:RegBalance(self:SelectedItem,self:cItemName)
			ENDIF
		ELSEIF self:cType="Department"
	    	IF IsMethod(self:oCaller, #RegDepartment)
	    		
				self:oCaller:RegDepartment(self:SelectedItem,self:cItemName)
			ENDIF
		ENDIF
	ENDIF
	SELF:EndWindow()
METHOD Paste()  CLASS CustomExplorer
	LOCAL oTVItem AS TreeViewItem
	LOCAL oLVItem 	AS ListViewItem
	LOCAL oTreeView AS BalanceTreeView
	LOCAL oListView AS BalanceListView
	oTreeView:=SELF:TreeView
	oListView:=SELF:ListView
	SELF:oTVItemDrop:=NULL_OBJECT
	oTVItem := oTreeView:GetSelectedItem()
	oLVItem:=oListView:GetSelectedItem()
	IF !oLVItem==NULL_OBJECT .and. oLVItem:Focused
		IF !(oLVItem:GetValue(#Type)=="Account")
			* determine corresponding treeview item:
			oTVItem:=oTreeView:GetItemAttributes(String2Symbol("Parent_" + oLVItem:GetValue(self:sListIdentify)))
			SELF:oLVItemDrop:= oLVItem
			SELF:oTVItemDrop := oTVItem
			oTreeView:SelectItem( oTVItem:NameSym , #DropHighlight )
		ENDIF
	ELSE
		SELF:oTVItemDrop := oTVItem
	ENDIF
	SELF:TreeViewDragEnd( )
RETURN
METHOD Refresh() CLASS CustomExplorer

	// clear and rebuild the list view items
	*	SELF:DeleteTreeViewItems()
	*	SELF:BuildTreeViewItems()
	self:DeleteListViewItems() 
	// 	self:aItem:={}
	Send(self,#BuildListViewItems,Val(Transform(self:uCurrentMain,"")))
	RETURN
METHOD RefreshTree()  CLASS CustomExplorer
	// clear and rebuild the tree view items
	LOCAL cursym as SYMBOL
	LOCAL oTreeViewItem, oCurItem as TreeViewItem
	LOCAL oTreeView as BalanceTreeView
	oTreeView:=self:TreeView
	if IsObject(oTreeView) .and. !oTreeView==null_object
		oCurItem:=oTreeView:GetSelectedItem()
		self:DeleteTreeViewItems()
		self:BuildTreeViewItems()
		// 	cursym:=String2Symbol("Parent_" + AllTrim(AsString(uCurrentMain)))
		// 	DO WHILE TRUE
		// 		self:TreeView:Expand(cursym)
		// 		oTreeViewItem:=SELF:TreeView:GetParentItem(cursym)
		// 		IF Empty(oTreeViewItem)
		// 			EXIT
		// 		ENDIF
		// 		cursym:=oTreeViewItem:NameSym
		// 	ENDDO
		*	oTreeView:SelectItem(String2Symbol("Parent_" + AllTrim(AsString(uCurrentMain)))) 
		if oCurItem==null_object
			oCurItem:=oTreeView:GetRootItem()
			oTreeView:ExpandTree(oCurItem,0,nMaxLevel)
		else
			self:oTreeView:SelectItem(oCurItem)
			self:TreeView:Expand(oCurItem)
		endif
	endif
	RETURN

METHOD Search(lFirst,cSearchText) CLASS  CustomExplorer
* Search of an item within the tree
LOCAL nPntr AS INT
IF lFirst
	SELF:nStartSearch:=0
ENDIF
++nStartSearch
IF nStartSearch>Len(aSearch)
	RETURN FALSE
ENDIF
nPntr:=AScan(aSearch,{|x| cSearchText$x[1]},nStartSearch)
IF Empty(nPntr)
	RETURN FALSE
ENDIF
nStartSearch:=nPntr
SELF:TreeView:SelectItem( aSearch[nPntr,2])
// if !self:IsAccountSymbol((self:TreeView:GetSelectedItem()):NameSym)
if !(self:TreeView:GetSelectedItem()):ImageIndex==3
	self:SelectedItem:=self:GetIdFromSymbol((self:TreeView:GetSelectedItem()):NameSym)
ENDIF

RETURN true



	

METHOD TransferItem(aItemDrag as array,oItemDrop as TreeViewItem,lDBUpdate:=false as logic) as string CLASS CustomExplorer
* Transfer item on screen:
LOCAL aChilds:={} AS ARRAY
LOCAL oTreeView			AS BalanceTreeView
LOCAL oTreeViewItem		AS TreeViewItem
LOCAL i AS INT
LOCAL lSuccess AS LOGIC

// 	IF SELF:lShowAccount.or.!SELF:IsAccountSymbol(sItemDrag)
	IF self:lShowAccount.or.!aItemDrag[2]:ImageIndex==3   // no account?
		oTreeView:=self:TreeView
		//  Get all childs to move them:
		self:GetChild(aChilds, aItemDrag[1] )
    	oTreeViewItem:=oTreeView:GetItemAttributes(aItemDrag[1] )
		lSuccess:=oTreeView:DeleteItem( aItemDrag[1]  )
		lSuccess:=oTreeView:AddItem( oItemDrop:NameSym , oTreeViewItem )
		FOR i := 1 TO ALen( aChilds )
			oTreeView:AddItem( aChilds[i,1] , aChilds[i,2] )
		NEXT
	ENDIF 
	return ''
METHOD TreeViewDragBegin( oEvent ) CLASS CustomExplorer

	LOCAL ptAction IS _WINPoint
	LOCAL hTV AS PTR
	LOCAL sNMTV AS _WINNM_TreeView
	LOCAL hItem AS PTR
	LOCAL hLV AS PTR
	LOCAL sNMLV AS _WINNM_ListView
	LOCAL oTreeView AS BalanceTreeView
	LOCAL oListView AS BalanceListView
	LOCAL oListViewItem		AS ListViewItem
	LOCAL oTVItemDrag AS TreeViewItem
	LOCAL i AS INT

	oTreeView:=SELF:TreeView
	oListView:=SELF:ListView
	hTV := oTreeView:Handle()
	hLV := oListView:Handle()
	aDragList:={}
	SELF:lTreeDragging:=FALSE
	SELF:lListDragging:=FALSE

	sNMTV := PTR( _CAST , oEvent:lParam )
	hItem := sNMTV.itemNew.hItem
	sNMLV := PTR( _CAST , oEvent:lParam )

	GetCursorPos( @ptAction )

	oTVItemDrag := oTreeView:GetItemAttributes(oTreeView:__GetSymbolFromHandle( hItem ) )
	IF oTVItemDrag==NULL_OBJECT
		* Listview drag:
		FOR i=1 TO oListView:ItemCount
			oListViewItem:=oListView:GetItemAttributes(i)
			IF oListViewItem:Selected
				* Determine corresponding Treeview item namesys:
				AAdd(aDragList,{self:GetTreeFromListItem(oListViewItem),oListViewItem})
			ENDIF
		NEXT
		IF  ALen(aDragList)>0
			SELF:lListDragging:=TRUE
		ENDIF
	ELSE
		IF oTVItemDrag:NameSym = #ROOT
			oTVItemDrag := NULL_OBJECT
			RETURN
		ENDIF
		SELF:lTreeDragging := TRUE
		self:aDragList:={{oTVItemDrag:NameSym,oTVItemDrag}}
	ENDIF

	SELF:oTVItemDrop := NULL_OBJECT
	SELF:oLVItemDrop := NULL_OBJECT

	IF lTreeDragging
		SELF:hImageList := TreeView_CreateDragImage( hTV , hItem )
	ELSE
		SELF:hImageList := ListView_CreateDragImage( hLV, sNMLV.iItem, @ptAction)
	ENDIF

	ImageList_SetDragCursorImage( SELF:hImageList , 0 , 0 , -1000 )
	ImageList_BeginDrag( SELF:hImageList , 0 , 3 , -20 )
	ImageList_DragMove( ptAction.X , ptAction.Y )
*	ImageList_DragEnter( hTV , ptAction.X , ptAction.Y )
	ImageList_DragEnter( SELF:Handle() , ptAction.X , ptAction.Y )

	SetCapture( SELF:Handle() )
	ImageList_DragShowNolock( TRUE )

	RETURN NIL
METHOD TreeViewDragEnd( X , Y ) CLASS CustomExplorer
	LOCAL i as int
	local cError as string
	LOCAL oTreeView AS BalanceTreeView
	LOCAL oListView AS ListView

	ImageList_DragLeave( SELF:Handle() )
	ImageList_EndDrag()

	ReleaseCapture()

	ShowCursor(TRUE)
	oTreeView:=SELF:TreeView
	oListView:=SELF:ListView

	IF oTVItemDrop != NULL_OBJECT .and.!Empty(SELF:aDragList)
		* Determine current selected TreeViewItem for ListView: 
		SQLStatement{"start transaction",oConn}:execute()
		FOR i:=1 to Len(self:aDragList)
			IF self:aDragList[i,1] != self:oTVItemDrop:NameSym
				cError:=self:TransferItem(self:aDragList[i], self:oTVItemDrop, true )
				if !Empty(cError)
					SQLStatement{"rollback",oConn}:execute()
					return nil
				endif
			ENDIF
		NEXT
		SQLStatement{"commit",oConn}:execute()
		oTreeView:SelectItem( oTVItemDrop , #DropHighlight, FALSE )
		SELF:oTVItemDrop := NULL_OBJECT
		SELF:lTreeDragging := FALSE
		SELF:lListDragging := FALSE
		SELF:aDragList:={}
		ShowCursor(TRUE)
		* rebuild current listview:
		Send(self,#BuildListViewItems,self:ListParent)

	ENDIF
	SELF:lTreeDragging:=FALSE
	SELF:lListDragging:=FALSE
	SELF:RefreshTree()
*	oTreeView:SelectItem( NULL_SYMBOL , #DropHighlight )
	RETURN NIL
METHOD TreeViewDragMove( X , Y ) CLASS CustomExplorer

	LOCAL hTV AS PTR
	LOCAL oTVItem AS TreeViewItem
	LOCAL oLVItem AS ListViewItem
	LOCAL oTreeView AS BalanceTreeView
	LOCAL oListView AS BalanceListView
	LOCAL r IS _WINRect
	LOCAL lCanDrop AS LOGIC
	LOCAL Xorig, Yorig as int
	local nDropItemId,nDragItemId,i as int
// 	LOCAL aMyDrags AS ARRAY

	oTreeView:=SELF:TreeView
	oListView:=SELF:ListView

	// Modify X and Y
	Xorig:=X
	Yorig:=Y
	hTV := oTreeView:Handle()
	ImageList_DragMove( X , Y )
	X := X-oTreeView:Origin:X-2  // Subtract Frame Size
*	Y := Y-oTreeView:Origin:Y-30
	Y := Y-oTreeView:Origin:Y-85

	GetClientRect( hTV , @r )
*	IF oTVItem == NULL_OBJECT
	IF ( X < 0 .or. Y < 0 .or. X > r.right .or. Y > r.bottom )  // outside treeview plane?
		* Listview?
		// Modify X and Y
		X:=Xorig
		Y:=Yorig
		hTV := oListView:Handle()
		X := X-oListView:Origin:X-2  // Subtract Frame Size
		Y := Y-oListView:Origin:Y-85
		oLVItem:=oListView:GetItemAtPosition( Point{ X , oListView:Size:Height - Y } )
		GetClientRect( hTV , @r )
	ELSE
		oTVItem := oTreeView:GetItemAtPosition( Point{ X , oTreeView:Size:Height - Y } )
	ENDIF

	IF ( X < 0 .or. Y < 0 .or. X > r.right .or. Y > r.bottom )
		SetCursor( LoadCursor( NULL , IDC_NO ) )
		lCanDrop := FALSE
	ELSE
		SetCursor( LoadCursor( NULL , IDC_ARROW ) )
		lCanDrop := TRUE
	ENDIF

*	ImageList_DragLeave( hTV )
	ImageList_DragLeave(SELF:Handle() )
	IF oTVItem != NULL_OBJECT
		* Drag within TreeView pane:
		IF lCanDrop.and.!oTVItem:ImageIndex==3 //no account
			// check if item to drop on is no child of drag item:
			nDropItemId:=Val(self:GetIdFromSymbol(oTVItem:NameSym))   
			for i:=1 to Len(self:aDragList)
				nDragItemId:=Val(self:GetIdFromSymbol(self:aDragList[i,1])) 
				if nDragItemId==nDropItemId .or. self:IsChildOf(nDropItemId,nDragItemId)
					lCanDrop:=false
					exit
				endif
			next
			if lCanDrop			
				oTreeView:SelectItem( oTVItem:NameSym , #DropHighlight )
				self:oTVItemDrop := oTVItem
			else
				oTreeView:SelectItem( self:oTVItemDrop , #DropHighlight, FALSE )
				self:oTVItemDrop := null_object
			endif
		ELSE
			IF !SELF:oTVItemDrop==NULL_OBJECT
				oTreeView:SelectItem( SELF:oTVItemDrop , #DropHighlight, FALSE )
				SELF:oTVItemDrop := NULL_OBJECT
			ENDIF
			SetCursor( LoadCursor( NULL , IDC_NO ) )
		ENDIF
	ELSE
		* Apperently drag within ListView pane:
		* reset former drophighlights in listview:
		IF !Empty(SELF:oLVItemDrop) .and. (Empty(oLVItem).or.!SELF:oLVItemDrop:ItemIndex==oLVItem:ItemIndex)
			SELF:oLVItemDrop:DROPTARGET:= FALSE
			oListView:SetItemAttributes(SELF:oLVItemDrop)
			oListView:RedrawRange(Range{Max(1,oLVItemDrop:ItemIndex-1),Min(oLVItemDrop:ItemIndex+1,oListView:ItemCount)})
			SELF:oLVItemDrop:=NULL_OBJECT
			oTreeView:SelectItem( SELF:oTVItemDrop , #DropHighlight, FALSE )
		ENDIF
		IF oLVItem != NULL_OBJECT.and.lCanDrop.and.!oLVItem:ImageIndex==3 //no account
			* determine corresponding treeview item:
			oTVItem:=oTreeView:GetItemAttributes(String2Symbol("Parent_" + Str(oLVItem:GetValue(self:sListIdentify),-1)))
			* Check if found Treeview item not a child of a drag item:
			nDropItemId:=Val(self:GetIdFromSymbol(oTVItem:NameSym))   
			for i:=1 to Len(self:aDragList)
				nDragItemId:=Val(self:GetIdFromSymbol(self:aDragList[i,1]))
				if nDragItemId==nDropItemId .or.self:IsChildOf(nDropItemId,nDragItemId)
					lCanDrop:=false
					exit
				endif
			next
			if lCanDrop			
			
				oLVItem:DROPTARGET:=true
				oListView:SetItemAttributes(oLVItem)
				self:oLVItemDrop:= oLVItem
				self:oTVItemDrop := oTVItem
				oTreeView:SelectItem( oTVItem:NameSym , #DropHighlight )
			else
				SetCursor( LoadCursor( null , IDC_NO ) )
				self:oTVItemDrop := null_object
			endif
		ELSE
			IF lCanDrop  // within Listview-pane?
			* Determine parent of Listview:
				SELF:oTVItemDrop := oTreeView:GetSelectedItem()
			ELSE
				SetCursor( LoadCursor( NULL , IDC_NO ) )
				SELF:oTVItemDrop := NULL_OBJECT
			ENDIF
		ENDIF
	ENDIF
	ImageList_DragEnter(SELF:Handle() , Xorig , Yorig )
	ImageList_DragShowNolock( TRUE )
	ShowCursor(TRUE)

	RETURN NIL
METHOD TreeViewMouseButtonDoubleClick(oTreeViewMouseEvent) CLASS CustomExplorer

	LOCAL oTVItem as TreeViewItem
	SUPER:TreeViewMouseButtonDoubleClick(oTreeViewMouseEvent)

	oTVItem := oTreeViewMouseEvent:TreeViewItem

	IF oTVItem != null_object
		self:TreeView:SelectItem( oTVItem:NameSym ) 
		self:EditButton(false,,false)
	ENDIF
	RETURN nil
METHOD TreeViewMouseButtonDown(oTreeViewMouseEvent) CLASS CustomExplorer

	LOCAL oTVItem AS TreeViewItem
	SUPER:TreeViewMouseButtonDown(oTreeViewMouseEvent)

	oTVItem := oTreeViewMouseEvent:TreeViewItem

	IF oTVItem != NULL_OBJECT
		IF oTreeViewMouseEvent:IsRightButton
			self:TreeView:SelectItem( oTVItem:NameSym ) 
// 		elseif !self:IsAccountSymbol(oTVItem:NameSym)
		elseif oTVItem:ImageIndex==1
			self:SelectedItem:=self:GetIdFromSymbol(oTVItem:NameSym)
		ENDIF
	ENDIF
	RETURN NIL
METHOD TreeViewSelectionChanged(oTreeViewSelectionEvent) CLASS CustomExplorer
	LOCAL oTreeViewItem	AS TreeViewItem
	LOCAL wLen AS INT

	SUPER:TreeViewSelectionChanged(oTreeViewSelectionEvent)

	oTreeViewItem := oTreeViewSelectionEvent:NewTreeViewItem
	IF oTreeViewItem != NULL_OBJECT
		// left-click occurred on a customer tree view item
		IF oTreeViewItem:ImageIndex==3 //Account?
			RETURN NIL
		ENDIF
		uCurrentMain:=Symbol2String(oTreeViewItem:NameSym)
		wLen:=At("_",uCurrentMain)
		uCurrentMain:=SubStr(uCurrentMain,wLen+1)
		SELF:DeleteListViewItems()
		Send(self,#BuildListViewItems,Val(uCurrentMain))
	ENDIF

	RETURN NIL
Method ValidateBalanceTransition(cNewParentId:="0" as string,cNewParentNbr:="0" as string,CurBalId:="0" as string,cNewType:="" ref string) as string  class CustomExplorer
	* Check if transition of current balance item to new parent is allowed
	*
	* If not allowed: returns errormessage text
	* Input::
	*	cNewParentNbr: number of required new parent of current BalanceItem , or
	*	cNewParentId : identifier (balitemid)of required new parent of current BalanceItem
	*	cNewType: Current classification of the balance item itself
	*
	* Output: cNewClassification of the parent
	*
	LOCAL cError as STRING
	LOCAL CurType,CurParentId as string
	local oBalCur,oBalPar as SQLSelect
	IF cNewParentNbr=="0" .and. cNewParentId="0"
		RETURN ""
	ENDIF
	
	oBalPar:=SQLSelect{"select balitemid,number,balitemidparent,category from balanceitem where "+"balitemid='"+cNewParentId+"'",oConn}
	IF oBalPar:reccount>0 .and. Str(oBalPar:balitemid,-1)== CurBalId
		cError:="Parent must be unqual to self"
		RETURN cError
	ENDIF
	IF Empty(cNewType)
		cNewType:=oBalPar:category
	ENDIF
	CurParentId:=Str(oBalPar:balitemid,-1)
	if CurBalId=="0" .or.Empty(CurBalId)
		IF Empty(cNewType)
			CurType:=oBalPar:category
		ENDIF
	else
		oBalCur:=SQLSelect{"select balitemid,number,balitemidparent,category from balanceitem where balitemid="+CurBalId,oConn} 
		IF oBalCur:reccount>0 .and. oBalPar:number==oBalCur:number
			cError:="Parent must be unqual to self"
			RETURN cError
		endif
		CurType:=oBalCur:category
	endif
	// check if new parent not a child of itself: 
	// self;aItem: {itemid,parentid,description,number,category},.. 
	//                 1       2          3       4       5        
	if self:IsChildOf(val(cNewParentId),val(CurBalId))
		cError:="Parent must not be a own child"
	else

		*Check correspondence IN classification TO parent:
		IF oBalPar:category $ expense+income
			IF !cNewType $ expense+income
				cError:="Fill as Classification Income or Expense"
			ENDIF
		ELSE
			IF !cNewType $ liability+asset
				cError:="Fill as Classification Liabilities or Assets"
			ENDIF
		endif
	endif
	if Empty(cError) .and.cNewType # CurType
		// check correspondence with child types 
		cError:=ValidateBalanceChilds(cNewType,CurType,CurBalId)
	endif
	RETURN cError
method ViewIcon() class CustomExplorer
	return self:ListView:ViewAs(#IconView)

method ViewList() class CustomExplorer
	return self:ListView:ViewAs(#ListView)

method ViewReport() class CustomExplorer
	return self:ListView:ViewAs(#ReportView)

method ViewSmallIcon() class CustomExplorer
	return self:ListView:ViewAs(#SmallIconView)

CLASS EditBalanceItem INHERIT DataWindowExtra 

	PROTECT oDCSC_NUM AS FIXEDTEXT
	PROTECT oDCSC_KOPTEKST AS FIXEDTEXT
	PROTECT oDCSC_VOETTEKST AS FIXEDTEXT
	PROTECT oDCSC_HFDRBRNUM AS FIXEDTEXT
	PROTECT oDCmNUM AS SINGLELINEEDIT
	PROTECT oDCmKOPTEKST AS SINGLELINEEDIT
	PROTECT oDCmVOETTEKST AS SINGLELINEEDIT
	PROTECT oDCmHFDRBRNUM AS SINGLELINEEDIT
	PROTECT oDCmSOORT AS RADIOBUTTONGROUP
	PROTECT oCCRadioButtonKO AS RADIOBUTTON
	PROTECT oCCRadioButtonBA AS RADIOBUTTON
	PROTECT oCCRadioButtonAK AS RADIOBUTTON
	PROTECT oCCRadioButtonPA AS RADIOBUTTON
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCCancelButton AS PUSHBUTTON

	//{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
	PROTECT lNew AS LOGIC
	PROTECT nCurRec AS INT
	PROTECT oCaller AS OBJECT
	PROTECT OrgKoptekst AS STRING
	PROTECT OrgHFDRBRNUM AS STRING
	PROTECT OrgNum AS STRING
	PROTECT OrgSoort as STRING 
	protect oBal as SQLSelect
	protect cMainId, mBalId,mType  as STRING


	
RESOURCE EditBalanceItem DIALOGEX  26, 24, 358, 200
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Balancegroup#:", EDITBALANCEITEM_SC_NUM, "Static", WS_CHILD, 13, 14, 53, 13
	CONTROL	"Header:", EDITBALANCEITEM_SC_KOPTEKST, "Static", WS_CHILD, 13, 29, 27, 12
	CONTROL	"Footer:", EDITBALANCEITEM_SC_VOETTEKST, "Static", WS_CHILD, 13, 44, 24, 12
	CONTROL	"Parent Group#:", EDITBALANCEITEM_SC_HFDRBRNUM, "Static", WS_CHILD, 13, 73, 59, 13
	CONTROL	"", EDITBALANCEITEM_MNUM, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 76, 14, 50, 13, WS_EX_CLIENTEDGE
	CONTROL	"Header:", EDITBALANCEITEM_MKOPTEKST, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 76, 29, 271, 12, WS_EX_CLIENTEDGE
	CONTROL	"Footer:", EDITBALANCEITEM_MVOETTEKST, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 76, 44, 272, 12, WS_EX_CLIENTEDGE
	CONTROL	"", EDITBALANCEITEM_MHFDRBRNUM, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 76, 73, 50, 13, WS_EX_CLIENTEDGE
	CONTROL	"Classification", EDITBALANCEITEM_MSOORT, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 76, 94, 90, 71
	CONTROL	"Expenses", EDITBALANCEITEM_RADIOBUTTONKO, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 84, 117, 80, 11
	CONTROL	"Income", EDITBALANCEITEM_RADIOBUTTONBA, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 84, 101, 80, 11
	CONTROL	"Assets", EDITBALANCEITEM_RADIOBUTTONAK, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 84, 132, 80, 12
	CONTROL	"Liablities and funds", EDITBALANCEITEM_RADIOBUTTONPA, "Button", BS_AUTORADIOBUTTON|WS_TABSTOP|WS_CHILD, 84, 147, 80, 11
	CONTROL	"OK", EDITBALANCEITEM_OKBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 256, 176, 53, 12
	CONTROL	"Cancel", EDITBALANCEITEM_CANCELBUTTON, "Button", WS_TABSTOP|WS_CHILD, 189, 176, 53, 12
END

METHOD CancelButton( ) CLASS EditBalanceItem
	SELF:ENDWindow()
RETURN NIL
METHOD EditFocusChange(oEditFocusChangeEvent) CLASS EditBalanceItem
	LOCAL oControl AS Control
	LOCAL lGotFocus AS LOGIC
	oControl := IIf(oEditFocusChangeEvent == NULL_OBJECT, NULL_OBJECT, oEditFocusChangeEvent:Control)
	lGotFocus := IIf(oEditFocusChangeEvent == NULL_OBJECT, FALSE, oEditFocusChangeEvent:GotFocus)
	SUPER:EditFocusChange(oEditFocusChangeEvent)
	//Put your changes here
	IF !lNew.or.!Empty(self:oDCmVOETTEKST:VALUE)
		RETURN
	ENDIF
	IF !lGotFocus .and.oControl:NameSym==#mKOPTEKST
		self:mVOETTEKST:=self:mKOPTEKST
	ENDIF
		
	RETURN NIL
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS EditBalanceItem 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"EditBalanceItem",_GetInst()},iCtlID)

oDCSC_NUM := FixedText{SELF,ResourceID{EDITBALANCEITEM_SC_NUM,_GetInst()}}
oDCSC_NUM:HyperLabel := HyperLabel{#SC_NUM,"Balancegroup#:",NULL_STRING,NULL_STRING}

oDCSC_KOPTEKST := FixedText{SELF,ResourceID{EDITBALANCEITEM_SC_KOPTEKST,_GetInst()}}
oDCSC_KOPTEKST:HyperLabel := HyperLabel{#SC_KOPTEKST,"Header:",NULL_STRING,NULL_STRING}

oDCSC_VOETTEKST := FixedText{SELF,ResourceID{EDITBALANCEITEM_SC_VOETTEKST,_GetInst()}}
oDCSC_VOETTEKST:HyperLabel := HyperLabel{#SC_VOETTEKST,"Footer:",NULL_STRING,NULL_STRING}

oDCSC_HFDRBRNUM := FixedText{SELF,ResourceID{EDITBALANCEITEM_SC_HFDRBRNUM,_GetInst()}}
oDCSC_HFDRBRNUM:HyperLabel := HyperLabel{#SC_HFDRBRNUM,"Parent Group#:",NULL_STRING,NULL_STRING}

oDCmNUM := SingleLineEdit{SELF,ResourceID{EDITBALANCEITEM_MNUM,_GetInst()}}
oDCmNUM:HyperLabel := HyperLabel{#mNUM,NULL_STRING,"Number of balance group","Rubriek_NUM"}
oDCmNUM:TooltipText := "Number of balance group"
oDCmNUM:Picture := "XXXXXXXXXXXXXXXXXXXX"

oDCmKOPTEKST := SingleLineEdit{SELF,ResourceID{EDITBALANCEITEM_MKOPTEKST,_GetInst()}}
oDCmKOPTEKST:FieldSpec := BalanceItem_KOPTEKST{}
oDCmKOPTEKST:HyperLabel := HyperLabel{#mKOPTEKST,"Header:","Header of balance group","Rubriek_KOPTEKST"}
oDCmKOPTEKST:TooltipText := "Header printed at beginning of this item on the report"

oDCmVOETTEKST := SingleLineEdit{SELF,ResourceID{EDITBALANCEITEM_MVOETTEKST,_GetInst()}}
oDCmVOETTEKST:FieldSpec := BalanceItem_VOETTEKST{}
oDCmVOETTEKST:HyperLabel := HyperLabel{#mVOETTEKST,"Footer:","Footer of balance group","Rubriek_VOETTEKST"}
oDCmVOETTEKST:TooltipText := "Footer printed at end of this item on the report"

oDCmHFDRBRNUM := SingleLineEdit{SELF,ResourceID{EDITBALANCEITEM_MHFDRBRNUM,_GetInst()}}
oDCmHFDRBRNUM:HyperLabel := HyperLabel{#mHFDRBRNUM,NULL_STRING,"Number of main group item belongs to","Rubriek_HFDRBRNUM"}
oDCmHFDRBRNUM:TooltipText := "Number of main group item belongs to"

oCCRadioButtonKO := RadioButton{SELF,ResourceID{EDITBALANCEITEM_RADIOBUTTONKO,_GetInst()}}
oCCRadioButtonKO:HyperLabel := HyperLabel{#RadioButtonKO,"Expenses",NULL_STRING,NULL_STRING}

oCCRadioButtonBA := RadioButton{SELF,ResourceID{EDITBALANCEITEM_RADIOBUTTONBA,_GetInst()}}
oCCRadioButtonBA:HyperLabel := HyperLabel{#RadioButtonBA,"Income",NULL_STRING,NULL_STRING}

oCCRadioButtonAK := RadioButton{SELF,ResourceID{EDITBALANCEITEM_RADIOBUTTONAK,_GetInst()}}
oCCRadioButtonAK:HyperLabel := HyperLabel{#RadioButtonAK,"Assets",NULL_STRING,NULL_STRING}

oCCRadioButtonPA := RadioButton{SELF,ResourceID{EDITBALANCEITEM_RADIOBUTTONPA,_GetInst()}}
oCCRadioButtonPA:HyperLabel := HyperLabel{#RadioButtonPA,"Liablities and funds",NULL_STRING,NULL_STRING}

oCCOKButton := PushButton{SELF,ResourceID{EDITBALANCEITEM_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"OK",NULL_STRING,NULL_STRING}

oCCCancelButton := PushButton{SELF,ResourceID{EDITBALANCEITEM_CANCELBUTTON,_GetInst()}}
oCCCancelButton:HyperLabel := HyperLabel{#CancelButton,"Cancel",NULL_STRING,NULL_STRING}

oDCmSOORT := RadioButtonGroup{SELF,ResourceID{EDITBALANCEITEM_MSOORT,_GetInst()}}
oDCmSOORT:FillUsing({ ;
						{oCCRadioButtonKO,"KO"}, ;
						{oCCRadioButtonBA,"BA"}, ;
						{oCCRadioButtonAK,"AK"}, ;
						{oCCRadioButtonPA,"PA"} ;
						})
oDCmSOORT:HyperLabel := HyperLabel{#mSOORT,"Classification",NULL_STRING,NULL_STRING}
oDCmSOORT:FieldSpec := BalanceItem_SOORT{}

SELF:Caption := "Edit of a balance items"
SELF:HyperLabel := HyperLabel{#EditBalanceItem,"Edit of a balance items",NULL_STRING,NULL_STRING}
SELF:PreventAutoLayout := True
SELF:AllowServerClose := True

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

ACCESS mHFDRBRNUM() CLASS EditBalanceItem
RETURN SELF:FieldGet(#mHFDRBRNUM)

ASSIGN mHFDRBRNUM(uValue) CLASS EditBalanceItem
SELF:FieldPut(#mHFDRBRNUM, uValue)
RETURN uValue

ACCESS mKOPTEKST() CLASS EditBalanceItem
RETURN SELF:FieldGet(#mKOPTEKST)

ASSIGN mKOPTEKST(uValue) CLASS EditBalanceItem
SELF:FieldPut(#mKOPTEKST, uValue)
RETURN uValue

ACCESS mNUM() CLASS EditBalanceItem
RETURN SELF:FieldGet(#mNUM)

ASSIGN mNUM(uValue) CLASS EditBalanceItem
SELF:FieldPut(#mNUM, uValue)
RETURN uValue

ACCESS mSOORT() CLASS EditBalanceItem
RETURN SELF:FieldGet(#mSOORT)

ASSIGN mSOORT(uValue) CLASS EditBalanceItem
SELF:FieldPut(#mSOORT, uValue)
RETURN uValue

ACCESS mVOETTEKST() CLASS EditBalanceItem
RETURN SELF:FieldGet(#mVOETTEKST)

ASSIGN mVOETTEKST(uValue) CLASS EditBalanceItem
SELF:FieldPut(#mVOETTEKST, uValue)
RETURN uValue

METHOD OKButton( ) CLASS EditBalanceItem
	LOCAL cMainId, mParentClass:="" as STRING
	LOCAL cError as STRING 
	local cSQLStatement as string
	local oStmnt as SQLStatement
	local mType:=cons(self:mSoort),mParent:=cons(self:cMainId) as string 
	local nPos,nBalid as int
	local oSel as SQLSelect

	IF Empty(self:mNum)
		(ErrorBox{,"Please fill number of item"}):Show()
		RETURN
	ENDIF
	IF lNew.or.!AllTrim(self:mNum)==AllTrim(OrgNum)
		*Check if balitemid allready exist:
		if SQLSelect{"select balitemid from balanceitem where number='"+self:mNum+"'",oConn}:RecCount>0
			(ErrorBox{,"Item number "+ self:mNum+ " allready exist!"}):Show()
			RETURN
		ENDIF
	ENDIF
	if !AllTrim(self:OrgHFDRBRNUM)==AllTrim(self:mHFDRBRNUM)
		// find new parent:
		oSel:=SqlSelect{"select balitemid from balanceitem where number='"+AllTrim(self:mHFDRBRNUM)+"'",oConn} 
		if oSel:RecCount>0
			mParent:=ConS(oSel:balitemid)
		endif
	endif
	cError:=self:oCaller:ValidateBalanceTransition(mParent,self:mHFDRBRNUM,self:mBalId,@mType)
	IF !Empty(cError)
		(ErrorBox{,cError}):Show()
		RETURN
	ENDIF
	self:mSoort:=mType
	self:cMainId:=mParent

	cSQLStatement:=iif(self:lNew,"insert into ","update ")+"balanceitem set "+;
		"number='"+addslashes(AllTrim(self:mNUM))+"'"+;
		",heading='"+AddSlashes(AllTrim(self:mKOPTEKST))+"'"+;
		",footer='"+AddSlashes(AllTrim(self:mVOETTEKST))+"'"+;
		",category='"+self:mSoort+"'"+;
		",balitemidparent='"+self:cMainId+"'"+;
		iif(self:lNew,""," where balitemid='"+self:mBalId+"'")
	oStmnt:=SQLStatement{cSQLStatement,oConn}
	oStmnt:Execute() 
	if oStmnt:NumSuccessfulRows>0
		IF self:lNew
			self:mBalId:=ConS(SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
			AAdd(self:oCaller:aItem,{Val(self:mBalId),Val(self:cMainId),AllTrim(self:mKOPTEKST),AllTrim(self:mNum),self:mSoort}) 
			oCaller:Treeview:AddTreeItem(Val(self:cMainId),Val(self:mBalId),AllTrim(self:mNum)+":"+self:mKOPTEKST, false)
			oCaller:Refresh()
		else
			// update aitem:
			nBalid:=Val(self:mBalId)
			nPos:=AScan(self:oCaller:aItem,{|x|x[1]==nBalid} )
			if nPos>0
				self:oCaller:aItem[nPos]:={Val(self:mBalId),Val(self:cMainId),AllTrim(self:mKOPTEKST),AllTrim(self:mNum),self:mSoort}
			endif
			IF !OrgKoptekst==self:mKOPTEKST.or.!self:OrgHFDRBRNUM==self:mHFDRBRNUM.or.!self:OrgNum=self:mNum 
				oCaller:RefreshTree()
			ENDIF
		endif
	elseif !Empty(oStmnt:status)
		ErrorBox{self,self:oLan:WGet("Error")+': '+oStmnt:ErrInfo:ErrorMessage}:Show()
	endif
	self:EndWindow()

	RETURN
METHOD PostInit(oWindow,iCtlID,oServer,uExtra) CLASS EditBalanceItem
	//Put your PostInit additions here
	LOCAL nRecnr AS INT
	self:SetTexts()
	SaveUse(self)
	oBal:=self:Server
	lNew:=uExtra[1]
	IF lNew
		SELF:oDCmNUM:SetFocus()
		self:cMainId:=uExtra[2]
	ELSE
		self:mBalId:=uExtra[3] 
		oBal:=SQLSelect{"select * from balanceitem where balitemid='"+mBalId+"'",oConn} 
		if oBal:RecCount>0
			self:mNUM := oBal:NUMber
			self:mKOPTEKST  := oBal:heading
			self:mVOETTEKST  := oBal:footer
			self:mSoort := iif(IsNil(oBal:category),asset,oBal:category)
			self:OrgSoort:=self:mSoort
			self:OrgKoptekst	:=self:mKopTekst
			self:OrgNum := self:mNum
			self:cMainId:=iif(IsNil(oBal:balitemidparent),"0",Str(oBal:balitemidparent,-1))
			self:mType:=oBal:category 
		endif
	ENDIF

	IF cMainId=="0"
		self:mHFDRBRNUM:="0"
		self:OrgHFDRBRNUM :=self:mHFDRBRNUM
		IF lNew
			self:mSoort:=asset
		ENDIF
	ELSE
		oBal:=SQLSelect{"select number,category from balanceitem where balitemid='"+self:cMainId+"'",oConn}
		if oBal:RecCount>0
			self:mHFDRBRNUM:=oBal:NUMber
			self:OrgHFDRBRNUM :=self:mHFDRBRNUM
			IF lNew
				self:mSoort:=iif(IsNil(oBal:category),asset,oBal:category)
			ENDIF
		endif
	ENDIF
	oCaller:=uExtra[5]
	RETURN NIL
STATIC DEFINE EDITBALANCEITEM_CANCELBUTTON := 114 
STATIC DEFINE EDITBALANCEITEM_MHFDRBRNUM := 107 
STATIC DEFINE EDITBALANCEITEM_MINDHFDRBR := 107
STATIC DEFINE EDITBALANCEITEM_MKOPTEKST := 105 
STATIC DEFINE EDITBALANCEITEM_MNUM := 104 
STATIC DEFINE EDITBALANCEITEM_MSOORT := 108 
STATIC DEFINE EDITBALANCEITEM_MVOETTEKST := 106 
STATIC DEFINE EDITBALANCEITEM_OKBUTTON := 113 
STATIC DEFINE EDITBALANCEITEM_RADIOBUTTONAK := 111 
STATIC DEFINE EDITBALANCEITEM_RADIOBUTTONBA := 110 
STATIC DEFINE EDITBALANCEITEM_RADIOBUTTONKO := 109 
STATIC DEFINE EDITBALANCEITEM_RADIOBUTTONPA := 112 
STATIC DEFINE EDITBALANCEITEM_SC_HFDRBRNUM := 103 
STATIC DEFINE EDITBALANCEITEM_SC_KOPTEKST := 101 
STATIC DEFINE EDITBALANCEITEM_SC_NUM := 100 
STATIC DEFINE EDITBALANCEITEM_SC_VOETTEKST := 102 
RESOURCE ExplorerClick DIALOGEX  9, 8, 263, 28
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Select", EXPLORERCLICK_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 168, 9, 53, 12
	CONTROL	"Select item and click Select", EXPLORERCLICK_FIXEDTEXT1, "Static", WS_CHILD, 42, 8, 102, 13
END

CLASS ExplorerClick INHERIT DIALOGWINDOW 

	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
METHOD Init(oParent,uExtra) CLASS ExplorerClick 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"ExplorerClick",_GetInst()},TRUE)

oCCOKButton := PushButton{SELF,ResourceID{EXPLORERCLICK_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"Select",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{EXPLORERCLICK_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Select item and click Select",NULL_STRING,NULL_STRING}
oDCFixedText1:TextColor := Color{138,0,0}

SELF:Caption := "Dialog Caption"
SELF:HyperLabel := HyperLabel{#ExplorerClick,"Dialog Caption",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

STATIC DEFINE EXPLORERCLICK_FIXEDTEXT1 := 101 
STATIC DEFINE EXPLORERCLICK_OKBUTTON := 100 
STATIC DEFINE EXPLORERCLICKOUD_FIXEDTEXT1 := 101 
STATIC DEFINE EXPLORERCLICKOUD_OKBUTTON := 100 
RESOURCE ExplorerOptions DIALOGEX  14, 17, 282, 29
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"Show accounts", EXPLOREROPTIONS_ACCOUNTSINTREE, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 10, 3, 106, 11
	CONTROL	"Explode Total Tree", EXPLOREROPTIONS_EXPLODEALL, "Button", BS_AUTOCHECKBOX|WS_TABSTOP|WS_CHILD, 10, 14, 93, 11
	CONTROL	"", EXPLOREROPTIONS_SEARCHTREE, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 130, 4, 81, 12, WS_EX_CLIENTEDGE
	CONTROL	"Search", EXPLOREROPTIONS_SEARCHBUTTON, "Button", BS_DEFPUSHBUTTON|WS_TABSTOP|WS_CHILD, 212, 4, 54, 12
	CONTROL	"", EXPLOREROPTIONS_GROUPBOX1, "Button", BS_GROUPBOX|WS_GROUP|WS_CHILD, 6, -1, 120, 28
END

CLASS ExplorerOptions INHERIT DialogWinDowExtra 

	PROTECT oDCAccountsInTree AS CHECKBOX
	PROTECT oDCExplodeAll AS CHECKBOX
	PROTECT oDCSearchTree AS SINGLELINEEDIT
	PROTECT oCCSearchButton AS PUSHBUTTON
	PROTECT oDCGroupBox1 AS GROUPBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
METHOD ButtonClick(oControlEvent) CLASS ExplorerOptions
	LOCAL oControl AS Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:ButtonClick(oControlEvent)
	//Put your changes here
	IF oControl:NameSym == #AccountsInTree
		IF oControl:Value==TRUE
			SELF:Owner:lShowAccount:=TRUE
		ELSE
			SELF:Owner:lShowAccount:=FALSE
		ENDIF
		SELF:Owner:RefreshTree()
	ELSEIF oControl:NameSym == #ExplodeAll
		IF oControl:Value==TRUE
			SELF:Owner:nMaxLevel:=99
		ELSE
			self:Owner:nMaxLevel:=1
		ENDIF
		self:Owner:RefreshTree() 
	ELSEIF oControl:NameSym == #InclInactiveDep
		IF oControl:Value==true
			self:Owner:lInclInactive:=true
		ELSE
			self:Owner:lInclInactive:=FALSE
		ENDIF
		self:Owner:RefreshTree()
	ENDIF
	RETURN NIL
METHOD EditChange(oControlEvent) CLASS ExplorerOptions
	LOCAL oControl AS Control
	oControl := IIf(oControlEvent == NULL_OBJECT, NULL_OBJECT, oControlEvent:Control)
	SUPER:EditChange(oControlEvent)
	//Put your changes here
	IF oControl:NameSym==#SearchTree
		IF !oCCSearchButton:caption==self:oLan:WGet("Search")
			oCCSearchButton:caption:=self:oLan:WGet("Search")
		ENDIF
	ENDIF
	RETURN NIL


METHOD Init(oParent,uExtra) CLASS ExplorerOptions 

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"ExplorerOptions",_GetInst()},TRUE)

oDCAccountsInTree := CheckBox{SELF,ResourceID{EXPLOREROPTIONS_ACCOUNTSINTREE,_GetInst()}}
oDCAccountsInTree:HyperLabel := HyperLabel{#AccountsInTree,"Show accounts",NULL_STRING,NULL_STRING}

oDCExplodeAll := CheckBox{SELF,ResourceID{EXPLOREROPTIONS_EXPLODEALL,_GetInst()}}
oDCExplodeAll:HyperLabel := HyperLabel{#ExplodeAll,"Explode Total Tree",NULL_STRING,NULL_STRING}

oDCSearchTree := SingleLineEdit{SELF,ResourceID{EXPLOREROPTIONS_SEARCHTREE,_GetInst()}}
oDCSearchTree:TooltipText := "Search this item within Tree"
oDCSearchTree:HyperLabel := HyperLabel{#SearchTree,NULL_STRING,NULL_STRING,NULL_STRING}

oCCSearchButton := PushButton{SELF,ResourceID{EXPLOREROPTIONS_SEARCHBUTTON,_GetInst()}}
oCCSearchButton:HyperLabel := HyperLabel{#SearchButton,"Search",NULL_STRING,NULL_STRING}

oDCGroupBox1 := GroupBox{SELF,ResourceID{EXPLOREROPTIONS_GROUPBOX1,_GetInst()}}
oDCGroupBox1:HyperLabel := HyperLabel{#GroupBox1,NULL_STRING,NULL_STRING,NULL_STRING}

SELF:Caption := "Tree options"
SELF:HyperLabel := HyperLabel{#ExplorerOptions,"Tree options",NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD PostInit(oParent,uExtra) CLASS ExplorerOptions
	//Put your PostInit additions here 
	LOCAL EditX:=152, FixX:=17 as int
	LOCAL myDim,oDimension as Dimension
	LOCAL myOrg as Point
	LOCAL oCheck as CheckBox

	self:SetTexts()
	IF IsArray(uExtra)
		self:oDCAccountsInTree:Value:=uExtra[1]
		self:oDCExplodeAll:Value:=uExtra[2]
		self:oDCSearchTree:Value:=uExtra[3]
		if !Empty(uExtra[3])
			self:oDCSearchTree:SetStyle(BS_DEFPUSHBUTTON,true)
		endif
		if IsInstanceOf(oParent,#DepartmentExplorer)
			// enlarge window
			myDim:=self:Size
			myDim:Height+=18
			self:Size:=myDim
			myOrg:=self:Origin
			myOrg:y-=18
			self:Origin:=myOrg
			// enlarge groupbox: 
			myDim:=self:oDCGroupBox1:Size
			myDim:Height+=18
			myOrg:=self:oDCGroupBox1:Origin
			myOrg:y-=18
			self:oDCGroupBox1:Origin:=myOrg
			self:oDCGroupBox1:Size:=myDim
			myOrg:=oDCExplodeAll:Origin
			// insert checkbox:
			oCheck:=CheckBox{self,190,Point{myOrg:X,myOrg:y-18},Dimension{160,18},"InclInactiveDep"}
			oCheck:HyperLabel := HyperLabel{#InclInactiveDep,"Include inactive departments",}
			oCheck:show()
		endif
	ENDIF
	self:oDCSearchTree:SetFocus()
	RETURN NIL
METHOD SearchButton(Shown) CLASS ExplorerOptions
LOCAL lFirst AS LOGIC
IF IsNil(Shown)
	Shown:=TRUE
ENDIF
lFirst:=(self:oCCSearchButton:caption==self:oLan:WGet("Search"))
IF SELF:Owner:Search(lFirst,Upper(AllTrim(SELF:oDCSearchTree:TextValue)))
	IF lFirst
		self:oCCSearchButton:caption:=self:oLan:WGet("Search Next")
		SELF:oCCSearchButton:Show()
	ENDIF
ELSEIF Shown
	(WarningBox{,self:oLan:WGet('Search Tree Item'),oLan:WGet('Not Found')}):Show()
ENDIF
RETURN

STATIC DEFINE EXPLOREROPTIONS_ACCOUNTSINTREE := 100 
STATIC DEFINE EXPLOREROPTIONS_EXPLODEALL := 101 
STATIC DEFINE EXPLOREROPTIONS_GROUPBOX1 := 104 
STATIC DEFINE EXPLOREROPTIONS_SEARCHBUTTON := 103 
STATIC DEFINE EXPLOREROPTIONS_SEARCHTREE := 102 
Function FindBal(cBalItem ref string) as logic
*	Find a BalanceItem with the given number/description
*	Returns: True: if unique BalanceItem found
*			 False: if not found (BalanceItem:EOF-TRUE) or not unique found (current record found )
*		
*
LOCAL lUnique as LOGIC 
local oBal as SQLSelect
IF !Empty(cBalItem).and.IsDigit(psz(_cast,AllTrim(cBalItem)))
	oBal:=SQLSelect{"select balitemid from balanceitem where number='"+cBalItem+"'",oConn}
ELSE
	oBal:=SQLSelect{"select balitemid from balanceitem where heading like '"+AllTrim(cBalItem)+"%'",oConn}
ENDIF
if oBal:RecCount=1
	lUnique := true
	cBalItem:=Str(oBal:balitemid,-1)
ENDIF
RETURN lUnique

Function ValidateBalanceChilds(NewType as string,CurType as string,CurBalId as string)  
* Check correspondence in classification of current balance item with its child records
*
* NewType: new required classification

LOCAL cError as STRING
local oBal,oAcc,oAccB as SQLSelect
local oMBal as Balances

IF CurType $ expense+income .and.NewType $ liability+asset .or.; // global update of classification?
	NewType $ expense+income .and. CurType $ liability+asset
	*Check child items:
	oBal:=SQLSelect{"select balitemid from balanceitem where balitemidparent='"+CurBalId+"'",oConn} 
	IF oBal:RecCount>0
		IF CurType $ expense+income
			 cError:="Child items present; keep as Classification Income or Expense"
		ELSE
			cError:="Child items present; keep as Classification Liabilities or Assets"
		ENDIF
	else
		oAcc:=SQLSelect{"select b.accid from accountbalanceyear b, account a where a.accid=b.accid and (b.svjc-b.svjd)<>0.00 and a.balitemid='"+CurBalId+"'",oConn}
		if oAcc:RecCount>0  
 			cError:="accounts present which are already balanced in previous year, keep as Classification "+;
			iif(CurType==income,"Income",iif(CurType==expense,"Expense",iif(CurType=asset,"Assets","Liabilities/Funds")))
		endif
	ENDIF
ENDIF
IF Empty(cError)
	IF !CurType==NewType //update of classification?
		* Check child accounts: 
		oAcc:=SQLSelect{"select a.accid,m.persid from account a,member m where balitemid='"+CurBalId+"' and a.accid=m.accid ",oConn}
		if oAcc:RecCount>0
	 		cError:="Member accounts present, keep as Classification "+;
			iif(CurType==income,"Income",iif(CurType==expense,"Expense",iif(CurType=asset,"Assets","Liabilities/Funds")))
		ENDIF
	ENDIF
ENDIF
RETURN cError
