Function AddSlashes(cString as string) as string
// add backslashes for special characters ',",\,%,_
return StrTran(StrTran(StrTran(cString,'\','\\'),"'","\'"),'"','\"')
Function aDiff(aArr1 as array,aArr2 as Array) as string
// determine difference between two arrays
Local i,j, L1:=Len(aArr1), L2:=Len(aArr2) as int 
Local cDif as string
if !L1==L2
	return "different size"
endif
for i:=1 to L1
	if !aArr1[i]==aArr2[i]
		cDif+=Str(i,-1)+": " 
		for j:=1 to Len(aArr1[i]) step 4
			if SubStr(aArr1[i],j,4)#SubStr(aArr2[i],j,4)
				cDif+= "pos "+Str(int(j/4+1),-1)+": "+Str2Hex(SubStr(aArr1[i],j,4))+" # "+Str2Hex(SubStr(aArr2[i],j,4))+"; "
			endif 
		next
		exit
	endif
next
return cDif
FUNCTION AskFileName(oWindow, cFileName,cMessage,aFilter, aFilterDesc,appendPossible )
// ask for filename and return Filespec with fullpath (or null_object)
// and appendPossible=false if not append
// appendPossible must be passed by reference (@)
//
LOCAL oFileDialog as SaveAsDialog
LOCAL ToFileFS as Filespec
LOCAL oWarn as warningbox
LOCAL lAppend as LOGIC
local cDefFolder as string 
Default(@aFilter,"*.*")
Default(@aFilterDesc,"All files")
Default(@cMessage,"Report to file")
IF !IsLogic(appendPossible)
	appendPossible:=FALSE
ENDIF
DO WHILE true
	// Send up file dialog
	oFileDialog := SaveAsDialog{ oWindow, cFileName  }
	oFileDialog:SetStyle(OFN_HIDEREADONLY+OFN_LONGNAMES+OFN_EXPLORER)
	oFileDialog:SetFilter(aFilter, aFilterDesc,1)
	cDefFolder:=SQLSelect{"select docpath from sysparms",oConn}:DOCPATH
   if Empty(cDefFolder)
     	cDefFolder:=CurPath
   endif

	oFileDialog:InitialDirectory:=cDefFolder
	IF !oFileDialog:Show()
		exit
	ENDIF
	IF !Empty( oFileDialog:FileName )
		// Set the instance var...for later use...if Ok
		ToFileFS:=FileSpec{AllTrim(oFileDialog:FileName)}
		cFileName:=ToFileFS:FullPath
		oFileDialog:Destroy()
		oFileDialog:=null_object
		if !cDefFolder==ToFileFS:Drive+ ToFileFS:Path
			if ToFileFS:Drive == SubStr(WorkDir(),1,2) .or.ToFileFS:Drive == CurDrive()+":"
				// save current location: 
				SQLStatement{"update sysparms set docpath='"+ ToFileFS:Drive+ ToFileFS:Path +"'",oConn}:execute()
			endif
		endif
	
		IF ToFileFS:Find()
			IF appendPossible
				oWarn := WarningBox{oWindow,cMessage,;
				'File'+AllTrim(cFileName)+' already exists; Append to it?'}
				oWarn:type := BOXICONQUESTIONMARK + BUTTONYESNO
				oWarn:Beep:=true
				IF (oWarn:Show() = BOXREPLYYES)
					lAppend:=true
					exit
				ELSE
					lAppend:=FALSE
				ENDIF
				oWarn:Message:="Overwrite " + AllTrim(cFileName + " ?")
				IF (oWarn:Show() = BOXREPLYYES) 
					FErase(ToFileFS:FullPath)
					//ToFileFS:Delete()
					exit
				ENDIF
			ELSE
				oWarn := WarningBox{oWindow,cMessage,;
				'File'+AllTrim(cFileName)+' already exists; Overwrite it?'}
				oWarn:type := BOXICONQUESTIONMARK + BUTTONYESNO
				oWarn:Beep:=true
				IF (oWarn:Show() = BOXREPLYYES)
					FErase(ToFileFS:FullPath)
					IF !ToFileFS:Find()			
						exit
					ENDIF
				ENDIF
			ENDIF
		ELSE
			exit
		ENDIF
	ELSE	
		exit
	ENDIF
ENDDO
IF appendPossible
	appendPossible:=lAppend
ENDIF
RETURN ToFileFS
FUNCTION asum(fu_anaam, fu_start, fu_end, fu_col )
*      sommeren van een array 
*
* fu_start: optional start element
* fu_end  : optional end element
* fu_col  : optional column number to sum in case of two dimensional array
*
LOCAL m_count as int ,m_som as REAL8
Default(@fu_start,1)
Default(@fu_end,ALen(fu_anaam)) 
Default(@fu_col,0) 
m_count:=fu_end-fu_start+1
if Empty(fu_col)
	AEval(fu_anaam,{|x|m_som:=Round(m_som+x,DecAantal)},fu_start,m_count)
else
	AEval(fu_anaam,{|x|m_som:=Round(m_som+x[fu_col],DecAantal)},fu_start,m_count)
endif
RETURN(Round(m_som,DecAantal))
DEFINE CHECKBX:=1
function CheckConsistency(oWindow as object,lCorrect:=false as logic,lShow:=false as logic) as logic 
	local nFromYear,i as int
	local oStmnt as SQLStatement
	local oSel as SQLSelect
	local cError as string
	local lTrMError as logic
	local aMBal:={},aMBalF:={} as array   // array with corrections of Mbalance {{accid,year,month,deb,cre},...}
	nFromYear:=Year(LstYearClosed)  
	if lShow
		oMainWindow:Pointer := Pointer{POINTERHOURGLASS} 
	endif
	oMainWindow:STATUSMESSAGE("Checking consistency financial data"+'...')

	*	Select only monthbalances in years after last balance year for standard currency: 
	oStmnt:=SQLStatement{"drop temporary table if exists transsum",oConn}
	oStmnt:Execute()
	oSel:=SQLSelect{"create temporary table transsum as select accid,year(dat) as year,month(dat) as month,sum(deb) as debtot,sum(cre) as cretot from transaction group by accid,year(dat),month(dat) order by accid,dat",oConn}
	oSel:Execute()
	oSel:=SQLSelect{"alter table transsum add unique (accid,year,month)",oConn}
	oSel:Execute()                                                                                    
	oSel:=SQLSelect{"select m.*,t.debtot,t.cretot,a.accnumber from mbalance m left join transsum t on (m.accid=t.accid and m.year=t.year and m.month=t.month) left join account a on (a.accid=m.accid) where (t.debtot IS NULL and t.cretot IS NULL and (m.deb<>0 or m.cre<>0) or (m.deb<>t.debtot or m.cre<>t.cretot)) and m.year>="+Str(nFromYear,-1)+" and m.currency='"+sCurr+"'",oConn}
	oSel:Execute()
	if oSel:RECCOUNT>0
		cError:="No correspondence between transactions and month balances per account"+CRLF
		lTrMError:=true
		do while !oSel:EoF
			cError+=Space(4)+"Account:"+oSel:accnumber+"("+sCurr+") month:"+Str(oSel:Year,-1)+StrZero(oSel:Month,2)+" Tr.deb:"+Transform(oSel:debtot,"")+" cre:"+Transform(oSel:cretot,"")+"; mbal deb:"+Transform(oSel:deb,"")+" cre:"+Transform(oSel:cre,"")+CRLF
			aadd(aMBal,{oSel:accid,oSel:year,oSel:month,iif(empty(oSel:debtot),0.00,oSel:debtot),iif(empty(oSel:cretot),0.00,oSel:cretot)}) 
			oSel:Skip()
		enddo 
	endif
	oSel:=SQLSelect{"select m.deb,m.cre,t.*,a.accnumber from transsum t left join mbalance m  on (m.accid=t.accid and m.year=t.year and m.month=t.month and m.currency='"+sCurr+"') left join account a on (a.accid=t.accid) where (m.deb IS NULL and m.cre IS NULL and (t.debtot<>0 or t.cretot<>0)) and t.year>="+Str(nFromYear,-1),oConn}
	if oSel:RECCOUNT>0
		if Empty(cError)
			cError:="No correspondence between transactions and month balances per account"+CRLF
		endif
		lTrMError:=true
		do while !oSel:EoF
			cError+=Space(4)+"Account:"+oSel:accnumber+"("+sCurr+") month:"+Str(oSel:Year,-1)+StrZero(oSel:Month,2)+" Tr.deb:"+Str(oSel:debtot,-1)+" cre:"+Str(oSel:cretot,-1)+"; mbal deb:"+Transform(oSel:deb,"")+" cre:"+Transform(oSel:cre,"")+CRLF 
			aadd(aMBal,{oSel:accid,oSel:year,oSel:month,oSel:debtot,oSel:cretot}) 
			oSel:Skip()
		enddo
	endif
	
	// Idem for foreign currencies:
	*	Select only monthbalances in years after last balance year for foreign currency:
	oSel:=SQLSelect{"create temporary table transsumf as select accid,year(dat) as year,month(dat) as month,sum(debforgn) as debtot,sum(creforgn) as cretot from transaction where currency<>'"+sCurr+"' group by accid,year(dat),month(dat) order by accid,dat",oConn}
	oSel:Execute()
	oSel:=SQLSelect{"alter table transsumf add unique (accid,year,month)",oConn}
	oSel:Execute()                                                                                    
	oSel:=SQLSelect{"select m.*,t.debtot,t.cretot,a.accnumber from mbalance m left join transsumf t on (m.accid=t.accid and m.year=t.year and m.month=t.month) left join account a on (a.accid=m.accid) where (t.debtot IS NULL and t.cretot IS NULL and (m.deb<>0 or m.cre<>0) or (m.deb<>t.debtot or m.cre<>t.cretot)) and m.year>="+Str(nFromYear,-1)+" and m.currency<>'"+sCurr+"'",oConn}
	oSel:Execute()
	if oSel:RECCOUNT>0
		if Empty(cError)
			cError:="No correspondence between transactions and month balances per account"+CRLF
		endif
		lTrMError:=true
		do while !oSel:EoF
			cError+=Space(4)+"Account:"+oSel:accnumber+"("+oSel:currency+") month:"+Str(oSel:Year,-1)+StrZero(oSel:Month,2)+" Tr.deb:"+Transform(oSel:debtot,"")+" cre:"+Transform(oSel:cretot,"")+"; mbal deb:"+Transform(oSel:deb,"")+" cre:"+Transform(oSel:cre,"")+CRLF
			AAdd(aMBalF,{oSel:accid,oSel:Year,oSel:Month,iif(Empty(oSel:debtot),0.00,oSel:debtot),iif(Empty(oSel:cretot),0.00,oSel:cretot),oSel:Currency}) 
			oSel:Skip()
		enddo
	endif
	oSel:=SQLSelect{"select m.deb,m.cre,t.*,a.accnumber,a.currency from account a,transsumf t left join mbalance m  on (m.year=t.year and m.month=t.month and m.accid=t.accid and m.currency<>'"+sCurr+"') where a.accid=t.accid and a.currency<>'"+sCurr+"' and a.multcurr=0 and (m.deb IS NULL and m.cre IS NULL and (t.debtot<>0 or t.cretot<>0)) and t.year>="+Str(nFromYear,-1),oConn}
	if oSel:RECCOUNT>0
		if Empty(cError)
			cError:="No correspondence between transactions and month balances per account"+CRLF
		endif
		lTrMError:=true
		do while !oSel:EoF
			cError+=Space(4)+"Account:"+oSel:accnumber+"("+oSel:currency+") month:"+Str(oSel:Year,-1)+StrZero(oSel:Month,2)+" Tr.deb:"+Str(oSel:debtot,-1)+" cre:"+Str(oSel:cretot,-1)+"; mbal deb:"+Transform(oSel:deb,"")+" cre:"+Transform(oSel:cre,"")+CRLF 
			AAdd(aMBalF,{oSel:accid,oSel:Year,oSel:Month,oSel:debtot,oSel:cretot,oSel:Currency}) 
			oSel:Skip()
		enddo
	endif
	
	oSel:=SQLSelect{"select sum(cre-deb) as totdebcre from transaction",oConn}
	oSel:Execute()
	if !oSel:totdebcre==0.00
		cError+="Transactions not balanced for "+sCurr+":"+Str(oSel:totdebcre,-1)+CRLF 
	endif
	oSel:=SQLSelect{"select sum(cre-deb) as totdebcre from mbalance where currency='"+sCurr+"' and year>="+Str(nFromYear,-1),oConn}
	oSel:Execute()
	if !oSel:totdebcre==0.00
		cError+="Month balances not balanced for "+sCurr+":"+Str(oSel:totdebcre,-1)+CRLF
	endif
	oSel:=SQLSelect{"select transid,dat from transaction group by transid having sum(cre-deb)<>0 order by transid",oConn}
	oSel:Execute()
	if oSel:RECCOUNT>0
		cError+="Not all transactions are balanced for "+sCurr+":"+CRLF
		do while !oSel:EoF
			cError+=Space(4)+"Transaction:"+Str(oSel:transid,-1)+" date:"+DToC(oSel:dat)+CRLF 
			oSel:Skip()
		enddo
	endif
	if lShow
		oMainWindow:Pointer := Pointer{POINTERARROW} 
	endif
	if Empty(cError) 
		oMainWindow:STATUSMESSAGE(Space(100))
		if lShow
			TextBox{,"Checking consistency financial data","all data are correct"}:Show()
		endif
		return true
	else
		LogEvent(oWindow,cError,"LogErrors")
		if lShow
			TextBox{,"Checking consistency financial data: correspondence transactions and month balances, each transaction balanced",SubStr(cError,1,3000)}:Show()
			lCorrect:=false
			if lTrMError
				lCorrect:=(TextBox{,"Checking consistency financial data",'Should balances be corrected?',BUTTONYESNO}:Show()=BOXREPLYYES) 
			endif
		endif
		if	lTrMError .and.lCorrect
			if lShow
				oMainWindow:Pointer := Pointer{POINTERHOURGLASS} 
			endif
			for i:=1 to Len(aMBal)
				oStmnt:=SQLStatement{"update mbalance set deb="+Str(aMBal[i,4],-1)+",cre="+Str(aMBal[i,5],-1)+;
					" where accid="+Str(aMBal[i,1],-1)+" and year="+Str(aMBal[i,2],-1)+" and month="+Str(aMBal[i,3],-1),oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows<1
					// insert new one
					oStmnt:=SQLStatement{"insert into mbalance set accid="+Str(aMBal[i,1],-1)+",year="+Str(aMBal[i,2],-1)+",month="+Str(aMBal[i,3],-1)+",currency='"+;
						sCurr+"',deb="+Str(aMBal[i,4],-1)+",cre="+Str(aMBal[i,5],-1),oConn}
					oStmnt:Execute()
				endif				
			next
			for i:=1 to Len(aMBalF)
				oStmnt:=SQLStatement{"update mbalance set deb="+Str(aMBalF[i,4],-1)+",cre="+Str(aMBalF[i,5],-1)+;
					" where accid="+Str(aMBalF[i,1],-1)+" and year="+Str(aMBalF[i,2],-1)+" and month="+Str(aMBalF[i,3],-1)+" and currency='"+aMBalF[i,6]+"'",oConn}
				oStmnt:Execute()
				if oStmnt:NumSuccessfulRows<1
					// insert new one
					oStmnt:=SQLStatement{"insert into mbalance set accid="+Str(aMBalF[i,1],-1)+",year="+Str(aMBalF[i,2],-1)+",month="+Str(aMBalF[i,3],-1)+",currency='"+;
						aMBalF[i,6]+"',deb="+Str(aMBalF[i,4],-1)+",cre="+Str(aMBalF[i,5],-1),oConn}
					oStmnt:Execute()
				endif				
			next
			if lShow
				oMainWindow:Pointer := Pointer{POINTERARROW} 
			endif
		endif
		oMainWindow:STATUSMESSAGE(Space(100))
	endif
	return false
Function CleanFileName(cFileName as string) as string
// removes illegal characters from cFileName to return an for Windows acceptable file name:
LOCAL oFileSpec as Filespec
oFileSpec:=FileSpec{cFileName}
oFileSpec:FileName:=StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(oFileSpec:FileName,'"',''),'/',' '),'\',' '),'?',' '),':',''),'*',''),'<',''),'>','')
if (!empty(oFileSpec:Extension) .and.oFileSpec:Extension $ cFileName) .or. (!empty(oFileSpec:Path) .and.oFileSpec:Path $ cFileName)
	return oFileSpec:FullPath
else
	return oFileSpec:FileName
endif
			
Function CompareKeyString(aKeyW as array, cValue as string ) as logic  
	// compare if each of given keywords in aKey is contained in string cValue
	Local i, lK  as int
	local lKeyFound as logic
	lK:=Len(aKeyW)
	for i:=1 to lK 
		if AtC(aKeyW[i],cValue)=0
			return false
		endif
	next
	return true
FUNCTION Comparr(aStruct1 as array,aStruct2 as array) as logic
	// compare equality of two arrays
	LOCAL nLen2:=ALen(aStruct2),nLen1:=ALen(aStruct1),i as int
	IF nLen2==nLen1
		FOR i=1 to nLen1
			if IsArray(aStruct1[i])
				if IsArray(aStruct2[i])
					if !Comparr(aStruct1[i],aStruct2[i])
						return false
					endif
				else
					return false
				endif
			else
				if !aStruct1[i]==aStruct2[i]
					return false
				endif
			endif
		NEXT
	ELSE
		return false
	ENDIF
	RETURN true
FUNCTION Compress (f_tekst)
** Comprimeren van overbodige spaties
****
IF Empty(f_tekst)
	RETURN null_string
ENDIF
f_tekst:=AllTrim(StrTran(f_tekst,CHR(160),Space(1)))         // replace non-breaking space with normal space
DO WHILE At("  ",f_tekst)>0
   f_tekst:=StrTran(f_tekst,"  "," ")
ENDDO
RETURN f_tekst
Function Correspondence(Str1 as string, Str2 as string) as int
// determine percentage correspondence of Str2 to Str1 
Local i, Len1, Len2, MinL, Score, Divdr as int
Str1:=Lower(AllTrim(Str1))
Str2:=Lower(AllTrim(Str2))
Len1:=Len(Str1)
Len2:=Len(Str2)
Divdr:=Max(Len1,Len2)
if Divdr=0
	return 0  // apparently both empty
endif
MinL:=Min(Len1,Len2)
for i:=1 to MinL
	if !SubStr(Str2,i,1)==SubStr(Str1,i,1) 
		exit
	endif
	Score++
next
Score:=(Score*100)/Divdr
return Score
DEFINE COUPLE := 3
DEFINE CR                   := _chr(12) 
FUNCTION dat_controle(m_date as date, m_no_message:=false as logic)
* This functie check if give date  is valid
* m_no_message: leeg: er wordt een foutboodschap op scherm getoond en
*                       een .t. of .f. waarde teruggegeven
*                 true : er wordt alleen een foutboodschap teruggegeven
LOCAL dat_message:="" as STRING
IF m_date < MinDate
    dat_message := 'Entering of records in closed year not allowed'
ELSEIF m_date > Today() + 31
    dat_message := 'Date more than 1 month from now not allowed'
ENDIF
IF .not.Empty(dat_message)
   IF Empty(m_no_message)
		(ErrorBox{,dat_message}):show()
      RETURN FALSE
   ELSE
      RETURN dat_message
   ENDIF
ELSE
   IF Empty(m_no_message)
      RETURN true
   ELSE
      RETURN ""
   ENDIF
ENDIF
CLASS DataBrowserExtra INHERIT Databrowser
CLASS DataDialogMine INHERIT DataDialog
	EXPORT aMemHome:={} as ARRAY
	EXPORT aMemNonHome:={} as ARRAY
	EXPORT aProjects:={} as ARRAY
	Export oLan as Language 
	declare method FillMbrProjArray
METHOD Close() CLASS DataDialogMine
	CollectForced()
RETURN SUPER:Close() 
METHOD FillMbrProjArray(dummy:=nil as string) as void pascal CLASS DataDialogMine
LOCAL oSQL as SQLSelect

// Fill 3 arrays: home members, non home members, projects

oSQL:=SQLSelect{"select a.accnumber, a.description, a.accid from account as a where (a.giftalwd=1"+iif(Empty(SDON),""," or a.accid="+SDON)+iif(Empty(SPROJ),""," or a.accid="+SPROJ)+") and not exists (select m.accid from member m where m.accid=a.accid)",oConn}
oSQL:GoTop()

DO WHILE !oSQL:EOF
	AAdd(self:aProjects,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid})
	oSQL:Skip()
ENDDO
// select home members: 
oSQL:=SQLSelect{"select m.co,a.accnumber, a.description, a.accid from member as m, account as a where m.accid=a.accid and m.homepp='"+SEntity+"'",oConn}
oSQL:Execute()
oSQL:GoTop()
DO WHILE !oSQL:EOF
	IF oSQL:CO=="M"
		AAdd(self:aMemHome,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid})
	ELSE
		// entities of own WO are regarded as projects:
		AAdd(self:aProjects,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid})
	ENDIF
	oSQL:Skip()
ENDDO
//select nonhome members: 
oSQL:SQLString:="select m.co,a.accnumber, a.description, a.accid from member as m, account as a where m.accid=a.accid and m.homepp<>'"+SEntity+"'"
oSQL:Execute()
oSQL:GoTop()
DO WHILE !oSQL:EOF
	IF oSQL:CO=="M"
		AAdd(self:aMemNonHome,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid})
	ELSE
		// entities of other WO are also regarded as projects:
		AAdd(self:aProjects,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid})
	ENDIF
	oSQL:Skip()
ENDDO
CLASS DataWindowExtra INHERIT DataWindow
*	PROTECT uControlValue AS USUAL
*	PROTECT cControlName AS STRING
EXPORT lImport,lExists as LOGIC
PROTECT lNew as LOGIC
PROTECT lImportAutomatic:=true as LOGIC // In case of General Import: no asking for confirmation per record
EXPORT lImportFile as LOGIC
EXPORT oImport as ImportMapping
Export oLan as Language
protect nFindRec as int, aKeyW as array 
protect cFindText as string
declare method CompareKeyWords
                         
METHOD Close(oEvent)  CLASS DataWindowExtra
	IF self:lImport
		IF Used()
			DBCLOSEAREA()
		ENDIF
       	self:lImport:=FALSE
       	self:Pointer := Pointer{POINTERARROW}
	ENDIF
/*	CollectForced()
	IF !_DynCheck()
		(errorbox{,"memory error:"+Str(DynCheckError())+" in window:"+SELF:Caption}):show()
	ENDIF    */

RETURN SUPER:Close(oEvent)
method CompareKeyWords(aValue as array) as logic class DataWindowExtra 
// compare if each of given keywords in aKeyW is contained in array aValue
Local i,j, lK:=Len(self:aKeyW), lV:=Len(aValue) as int
Local lKeyFound as logic
for i:=1 to lK
	lKeyFound:=false
	for j:=1 to lV
		if AtC(self:aKeyW[i,1],aValue[j])>0
			lKeyFound:=true
		endif
	next
	if !lKeyFound
		return false
	endif
next
return true
method EditChange(oControlEvent) class DataWindowExtra
	local oControl as Control
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	super:EditChange(oControlEvent)
	//Put your changes here 
	if !IsNil(oControl:TextValue)
		if oControl:Name=="FINDTEXT" .and. !oControl:TextValue== self:cFindText
			self:oCCFindNext:Caption:="Find" 
			self:oCCFindNext:Show()
			self:oCCFindPrevious:hide()
			self:cFindText:=oControl:TextValue
			self:nFindRec:=0
			self:STATUSMESSAGE("",MESSAGEPERMANENT)
		endif
	endif
	return nil

method Find() class DataWindowExtra 
self:oDCGroupBoxFind:show()
self:oDCFindText:show() 
self:oDCFindText:ToolTipText:="Enter one or more keywords the record searched for should contain" 
self:oDCFindText:value:=""
self:oCCFindClose:show()
self:oCCFindNext:show()
self:oCCFindNext:Caption:="Find"
self:oCCFindPrevious:hide()
self:oDCFindText:value:=""
self:nFindRec:=0
self:oDCFindText:SetFocus()
return 
METHOD FindClose( ) CLASS DataWindowExtra 
self:oDCGroupBoxFind:Hide()
self:oDCFindText:Hide()
self:oCCFindClose:Hide()
self:oCCFindNext:Hide()
self:oCCFindPrevious:Hide()

RETURN nil 
method SetWidth(w) class DataWindowExtra
LOCAL myDim as Dimension
	myDim:=self:Size
	myDim:Width:=w
	self:Size:=myDim
 return
CLASS DataWindowMine INHERIT DataWindow
	EXPORT aMemHome:={} as ARRAY
	EXPORT aMemNonHome:={} as ARRAY
	EXPORT aProjects:={} as ARRAY
	Export oLan as Language 
	
	declare method FillMbrProjArray
METHOD Close() CLASS DataWindowMine
	CollectForced()
/*	IF !_DynCheck()
		(errorbox{,"memory error:"+Str(DynCheckError())+" in window:"+SELF:Caption}):show()
	ENDIF   */
RETURN SUPER:close()
METHOD FillMbrProjArray(dummy:=nil as logic) as void pascal CLASS DataWindowMine
LOCAL oSQL as SQLSelect

// Fill 3 arrays: home members, non home members, projects

oSQL:=SQLSelect{"select a.accnumber, a.description, a.accid,a.balitemid,a.department from account as a where (a.giftalwd=1"+iif(Empty(SDON),""," or a.accid="+SDON)+iif(Empty(SPROJ),""," or a.accid="+SPROJ)+") and not exists (select m.accid from member m where m.accid=a.accid)",oConn}
oSQL:GoTop()

DO WHILE !oSQL:EOF
	AAdd(self:aProjects,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid,oSQL:balitemid,oSQL:department})
	oSQL:Skip()
ENDDO
// select home members: 
oSQL:=SQLSelect{"select m.co,a.accnumber, a.description, a.accid,a.balitemid,a.department from member as m, account as a where m.accid=a.accid and m.homepp='"+SEntity+"'",oConn}
oSQL:Execute()
oSQL:GoTop()
DO WHILE !oSQL:EOF
	IF oSQL:CO=="M"
		AAdd(self:aMemHome,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid,oSQL:balitemid,oSQL:department})
	ELSE
		// entities of own WO are regarded as projects:
		AAdd(self:aProjects,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid,oSQL:balitemid,oSQL:department})
	ENDIF
	oSQL:Skip()
ENDDO
//select nonhome members: 
oSQL:SQLString:="select m.co,a.accnumber, a.description, a.accid,a.balitemid,a.department from member as m, account as a where m.accid=a.accid and m.homepp<>'"+SEntity+"'"
oSQL:Execute()
oSQL:GoTop()
DO WHILE !oSQL:EOF
	IF oSQL:CO=="M"
		AAdd(self:aMemNonHome,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid,oSQL:balitemid,oSQL:department})
	ELSE
		// entities of other WO are also regarded as projects:
		AAdd(self:aProjects,{Pad(oSQL:accnumber,LENACCNBR)+" "+AllTrim(oSQL:Description),oSQL:accid,oSQL:balitemid,oSQL:department})
	ENDIF
	oSQL:Skip()
ENDDO

DEFINE DATEFIELD:=3
CLASS DateStandard INHERIT DATETIMEPICKER
	* Standard date for normal use
METHOD INIT(oOwner, nResourceID) CLASS DATEStandard
local currdate:=Today() as date, cY,cM as int
	SUPER:INIT(oOwner, nResourceID)
	cY:=Year(currdate)
	cM:=Month(currdate) +1
	if cM>12
		cY++
		cM:=1
	endif
	currdate:=SToD(Str(cY,4)+StrZero(cM,2)+Str(MonthEnd(cM,cY),2)) // ultimo next month
	
	self:DateRange:=DateRange{MinDate,currdate}
	self:SelectedDate:=Today()

	RETURN self
ACCESS Value CLASS DateStandard
	RETURN  self:SelectedDate
ASSIGN VALUE(uValue) CLASS DateStandard
	RETURN  self:SelectedDate:= uValue
CLASS DBServerExtra INHERIT DBSERVER
	EXPORT lRecreateIndex as LOGIC  // In case of restructuring of the database recreation of the indexes is needed 
	protect aSelRelation:={} as array  // list of relations: {ptr in aRelationChildren} 
	protect lRetry as logic 
	
	declare method CreateDbf
method appendSDF(oMyFileSpec,cSource, aoDFFieldID, cForCondition, cbWhileCondition, nRecords) CLASS DBServerExtra
local aStruct:=self:DBStruct as array , cBuffer as string , i,off,totlen as int
local ptrHandle as MyFile
  	
// ptrHandle := FOpen2(oMyFileSpec:FullPath,FO_READ + FO_SHARED)
ptrHandle:=MyFile{oMyFileSpec}
IF FError() >0
	(ErrorBox{,"Could not open file "+alltrim(oMyFileSpec:Fullpath)+":"+DOSErrString(FError())}):show()
	RETURN FALSE
ENDIF
cBuffer:=ptrHandle:FReadLine()
IF Empty(cBuffer)
	(ErrorBox{,"Could not read file: "+oMyFileSpec:FullPath+"; Error:"+DosErrString(FError())}):show()
	RETURN FALSE
ENDIF
totlen:=asum(aStruct,,,DBS_LEN)
do while !Empty(cBuffer)  
	if Len(cBuffer)>0
		off:=1
		self:Append()
		for i:=1 to Len(aStruct)
			self:FIELDPUT(i,SubStr(cBuffer,off,aStruct[ i,DBS_LEN]) )
			off+=aStruct[ i,DBS_LEN]
		next
	endif
	cBuffer:=ptrHandle:FReadLine()
enddo
ptrHandle:Close() 
return true
METHOD CreateDbf(oFileSp as FILESPEC,xDriver:='' as STRING) as LOGIC CLASS DBServerExtra
* Creeren van een Dbf-file tijdens pre-init dbserver, indien dbf-file nog niet bestaat
    LOCAL aFieldDesc  as ARRAY
    LOCAL oMyFileSpec   as FILESPEC, oDBFileSpec as DBFileSpec
	LOCAL aStruct as ARRAY
    LOCAL i,nFields   as int
    LOCAL lSuccess := true as LOGIC
    LOCAL cFileName as STRING
    LOCAL toSym as SYMBOL

    oMyFileSpec      := oFileSp
    cFilename:=oFileSp:FileName
	* Determine structure of required database:
   	nFields := ALen(aFieldDesc := self:FieldDesc)
   	aStruct := {}
   	FOR i:=1 upto nFields
			AAdd(aStruct,{aFieldDesc[i][DBC_NAME],;
			aFieldDesc[i][DBC_FIELDSPEC]:ValType,;
			aFieldDesc[i][DBC_FIELDSPEC]:Length,;
			aFieldDesc[i][DBC_FIELDSPEC]:Decimals})
   	NEXT
	IF Empty(oMyFileSpec:Extension)
   		oMyFileSpec:Extension:=".dbf"
   	ENDIF

    IF !oMyFileSpec:Find()
		// create a DBF/DBV file
		lSuccess := (DbFileSpec{}):Create( oMyFileSpec:FullPath,AStruct,xDriver,true)
		if !lSuccess
			(ErrorBox{,"You have no write permission for "+AllTrim(oMyFileSpec:Path)}):Show()
			return false
		endif
    ELSE  && in case of init of program: check structure 
    	if !lInitial
    		return true
    	endif
		* Check if structure has been altered? 
     	lSuccess := DBUSEAREA(true, xDriver, oMyFileSpec:FullPath,,FALSE,true)
     	IF !lSuccess
			RETURN FALSE    // apparently in exclusive use 
     	else
     		DBCLOSEAREA()
		ENDIF
		oDBFileSpec:=DbFileSpec{oMyFileSpec:FullPath,xDriver}
		IF .not. Comparr(oDBFileSpec:DBStruct,aStruct)
			*create new structure:
			oMyFileSpec:FileName:="hlpdbfst"
			oMyFileSpec:DELETE() // delete to be save
			lSuccess := (DbFileSpec{}):Create( oMyFileSpec:FullPath,aStruct,xDriver,true)
	      IF !lSuccess
				RETURN FALSE
			ENDIF
      	lSuccess := DBUSEAREA(true, xDriver, oMyFileSpec:FullPath,"hlpdbfst",FALSE,FALSE)
	     	IF !lSuccess
				RETURN FALSE
			ENDIF
			* append current dbffile
			DbZap()
			oMyFileSpec:FileName:=cFileName
			toSym:=Alias0Sym()
			lSuccess := self:DbfApp(oMyFileSpec:FullPath,toSym,(DbFileSpec{oMyFileSpec:FullPath,xDriver}):DBStruct,aStruct,xDriver)
	      IF !lSuccess
				RETURN FALSE
			ENDIF
			(toSym)->DBCOMMIT()
			(toSym)->DBCLOSEAREA()
            * Remove old file 
			(DbFileSpec{oMyFileSpec:FullPath,xDriver}):DELETE()
			DO WHILE oMyFileSpec:Find()
				Tone(30000,1) // wait 1/18 sec
			ENDDO
			* Rename new file
			oMyFileSpec:FileName:="hlpdbfst"
			lSuccess := (DbFileSpec{oMyFileSpec:FullPath,xDriver}):Rename( cFileName) 
			oMyFileSpec:Extension:=".fpt"
			if oMyFileSpec:Find()            // error in rename
				oMyFileSpec:Rename(cFileName+".fpt")
			endif
			oMyFileSpec:FileName:=cFileName
			oMyFileSpec:Extension:=".dbf"
			* reindex:
*			SELF:oFileSpec:=oMyFileSpec
*			CrIndexes(SELF,,TRUE)
			self:lRecreateIndex:=true
		ENDIF

    ENDIF	
    RETURN lSuccess
METHOD DbfApp(Filename,ToSym,FromStruc,ToStruc,xDriver)  CLASS DBServerExtra
	// Append file Filename to current workarea FToSym with conversion of equal named fields
	// FromStruc: DBStruc of Filename
	// ToStruc: DBstruc of workarea
	LOCAL i,j,ToLen,f as int, p as DWORD
	LOCAL cFieldName,cField as STRING
	LOCAL aGetFld:={} as ARRAY // fieldnumbers to get
	LOCAL aSetFld:={} as ARRAY // fieldnumbers to set
	LOCAL aTrans:={} as ARRAY // translate from to set: 0= copy, 1: val, 2: str, 3:stom, 4:mtoc
	LOCAL sTO, sFrom as SYMBOL //workarea alias

	sTO:=ToSym	
	// Determine match and conversion
	FOR i=1 to Len(ToStruc)
		cFieldName:=ToStruc[i,DBS_NAME]
		p:=AScan(FromStruc,{|x|x[DBS_NAME]==cFieldName})
		IF p>0
			IF FromStruc[p,DBS_TYPE]=ToStruc[i,DBS_TYPE] .or.  FromStruc[p,DBS_TYPE]="C" .and.ToStruc[i,DBS_TYPE]="M" .or.FromStruc[p,DBS_TYPE]="M" .and.ToStruc[i,DBS_TYPE]="C"
				AAdd(aSetFld,i)
				AAdd(aGetFld,p)
				AAdd(aTrans,0)
	/*		ELSEIF FromStruc[p,DBS_TYPE]="C" .and.ToStruc[i,DBS_TYPE]="M"
				AAdd(aSetFld,i)
				AAdd(aGetFld,p)
				AAdd(aTrans,3)
			ELSEIF FromStruc[p,DBS_TYPE]="M" .and.ToStruc[i,DBS_TYPE]="C"
				AAdd(aSetFld,i)
				AAdd(aGetFld,p)
				AAdd(aTrans,4)  */
			ELSEIF FromStruc[p,DBS_TYPE]="N" .and.ToStruc[i,DBS_TYPE]="C"
				AAdd(aSetFld,i)
				AAdd(aGetFld,p)
				AAdd(aTrans,2)
			ELSEIF FromStruc[p,DBS_TYPE]="C" .and.ToStruc[i,DBS_TYPE]="N"
				AAdd(aSetFld,i)
				AAdd(aGetFld,p)
				AAdd(aTrans,1)
			ENDIF
		ENDIF
	NEXT
	// append file:
	IF DBUSEAREA(true, xDriver, FileName,"From",FALSE,FALSE)
		toLen:=Len(aSetFld)
		sFrom:=Alias0Sym()
		SELECT(sTo)
		DO WHILE !((sFrom)->EOF())
			(sTo)->DBAPPEND()
			FOR i:=1 to toLen
				f:=aTrans[i]
				p:=aSetFld[i]
				j:=aGetFld[i]
				DO CASE
					CASE f==0
						(sTo)->FIELDPUT(p,(sFrom)->FIELDGET(j))
					CASE f==1
						(sTo)->FIELDPUT(p,Val((sFrom)->FIELDGET(j)))
					CASE f==2
						IF !Empty((sFrom)->FIELDGET(j))
							(sTo)->FIELDPUT(p,Str((sFrom)->FIELDGET(j),-1))
						ENDIF
				ENDCASE
			NEXT
			(sFrom)->DBSKIP()
		ENDDO
		(sFrom)->DBCLOSEAREA()
	ENDIF

	
RETURN true
METHOD Error(oError,SymMethod) CLASS DBServerExtra
self:lRetry:=	MyError(oError,SymMethod)
	
	RETURN

METHOD INIT(oFileSpec, lSharedMode, lReadOnlyMode , xDriver ) CLASS DBServerExtra
	Default(@xDriver,null_string)
	IF lInitial.or.!Empty(oFileSpec:Path)  // File has to be created:
		IF Empty(oFileSpec:Path)
			oFileSpec:Path := CurPath
		ENDIF
		self:CreateDbf(oFileSpec, xDriver)
	ELSE
		IF Empty(oFileSpec:Path)
			oFileSpec:Path := CurPath
		ENDIF
	ENDIF
SUPER:INIT(oFileSpec, lSharedMode, lReadOnlyMode , xDriver ) 
if !NoErrorMsg .and.!self:Used .and. self:lRetry
	do while !self:Used .and. self:lRetry
		SUPER:INIT(oFileSpec, lSharedMode, lReadOnlyMode , xDriver ) 		
	enddo
endif
RETURN self
CLASS Description INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD INIT() CLASS Description
    LOCAL   cPict                   as STRING

    SUPER:INIT( HyperLabel{#Description, "Description", "", "" },  "C", 256, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        self:Picture := cPict
    ENDIF

    RETURN self
FUNCTION DetermineUlt(nMonth, nYear)
* Determine date of last day in the given month
LOCAL nDay := 31 as int
IF nMonth == 4 .or. nMonth == 6 .or. nMonth == 9 .or. nMonth == 11
   nDay := 30
ENDIF
IF nMonth == 2
   IF (nYear % 4) == 0
      nDay := 29
   ELSE
      nDay := 28
   ENDIF
ENDIF
RETURN SToD(Str(nYear,4)+StrZero(nMonth,2)+StrZero(nDay,2))
Class DialogWinDowExtra inherit DialogWindow 
Export oLan as Language
method SetWidth(w) class DialogWinDowExtra
LOCAL myDim as Dimension
	myDim:=self:Size
	myDim:Width:=w
	self:Size:=myDim
return
DEFINE DROPDOWN:=2
METHOD Dispatch(oEvent) CLASS Edit
	// Deze wordt later uitgevoerd
	IF oEvent:Message==CN_KILLFOCUS
		self:EditSELECT()
	ENDIF
	RETURN SUPER:Dispatch(oEvent)
METHOD EditSELECT() CLASS Edit

	IF !IsNil(self:VALUE)
		IF IsNumeric(self:VALUE)
			// Selecteer het hele veld
			self:Selection	:= Selection{0,Len(self:CurrentText)}

		ELSEIF IsString(self:VALUE) .and. Empty(self:currenttext)
			// Alleen als niet gevuld is
			self:Selection	:= Selection{0,0}

		ELSEIF IsDate(self:VALUE) .and. Empty(CToD(self:currenttext))
			// Alleen als niet gevuld is
			self:Selection	:= Selection{0,0}
		ENDIF
	ELSE
		self:Selection	:= Selection{0,0}
	ENDIF
CLASS EditBrowser INHERIT DataBrowser
METHOD CellDoubleClick() CLASS EditBrowser
	self:Owner:Owner:EditButton(FALSE)
	RETURN nil
Function EndOfMonth(DateInMonth as date) as date
// get date of end of month given a certain date
return SToD(Str(Year(DateInMonth),4,0)+StrZero(Month(DateInMonth),2,0)+StrZero(MonthEnd(Month(DateInMonth),Year(DateInMonth)),2,0))
DEFINE FEMALE := 1
function FileStart(cFilename as string, OwnerWindow as Window )
// start application for processing given filename, e.g word document 
   LOCAL lpShellInfo is _winShellExecuteInfo
   LOCAL hProc as ptr
   LOCAL lpExitCode as DWORD
   LOCAL lRunning as LOGIC

	lpShellInfo.cbSize := _sizeof( _winSHELLEXECUTEINFO )
	lpShellInfo.hwnd := OwnerWindow:Handle()
	lpShellInfo.lpVerb := String2Psz("open")
	lpShellInfo.lpFile := String2Psz( cFilename )
	lpShellInfo.nShow := SW_ShowNormal
	lpShellInfo.fMask := SEE_MASK_NOCLOSEPROCESS
	
	IF ShellExecuteEx( @lpShellInfo )
		hProc := lpShellInfo.hProcess
		GetExitCodeProcess( hProc, @lpExitCode )
		lRunning := ( lpExitCode == STILL_ACTIVE )
		WHILE lRunning
			GetExitCodeProcess( hProc, @lpExitCode )
			lRunning := ( lpExitCode == STILL_ACTIVE )
   	   Yield()
		END
	END				

	RETURN 
Function FillBalYears()
// determine available balance years:
local oSel as SQLSelect
local cYearMonth as string 
GlBalYears:={} 
AAdd(GlBalYears,{LstYearClosed,"transaction"})
oSel:=SQLSelect{"select * from balanceyear order by yearstart desc,monthstart desc",oConn}
if oSel:RecCount>0
	do while !oSel:EOF
		cYearMonth:=Str(oSel:YEARSTART,4,0)+StrZero(oSel:MONTHSTART,2,0)
		AAdd(GlBalYears,{SToD(cYearMonth+"01"),'tr'+cYearMonth})
		oSel:Skip()
	enddo
endif
return GlBalYears
FUNCTION FillBankAccount( cFilter:="" as string) as array
 
return SQLSelect{"select concat(b.banknumber,' ',a.description) as description,b.banknumber from bankaccount b, account a where a.accid=b.accid"+iif(Empty(cFilter),""," and ("+cFilter+")"),oConn}:GetLookupTable(500,#description,#banknumber)

	
FUNCTION FillPersCode ()
* Fill Array with description + code + abrv of Pers-codes
// LOCAL aPersCd := {}
LOCAL oMailCd as SQLSelect
pers_codes:={}
mail_abrv:={}
oMailCd := SQLSelect{"select * from perscod",oConn}
pers_codes:=oMailCd:GetLookupTable(500,#description,#PERS_CODE)
ASize(pers_codes,Len(pers_codes)+1)
AIns(pers_codes,1) 
pers_codes[1]:={' ',''}
oMailCd:GoTop()
mail_abrv:=oMailCd:GetLookupTable(500,#ABBRVTN,#PERS_CODE)
RETURN 
FUNCTION FillPersGender() as void pascal
* Fill global Arrays with gendertypes and salutations of a person 
local oLan as Language
oLan:=Language{}
pers_gender:=  {{oLan:WGet("female"),FEMALE},{oLan:WGet("male"),MASCULIN},{oLan:WGet("couple"),COUPLE},{oLan:WGet("non-person"),ORGANISATION},{oLan:WGet("unknown"),0}}
pers_salut:={{oLan:RGet("Mrs",,"!"),FEMALE},{oLan:RGet("Mr",,"!"),MASCULIN},{oLan:RGet("Mr&Mrs"),COUPLE},{"",ORGANISATION},{"",0}}
return
FUNCTION FillPersProp ()
	* Fill global Array pers_propextra with description + id of extra person properties
	LOCAL oPersProp as SQLSelect
	pers_propextra:={}
	oPersProp := SQLSelect{"SELECT * FROM `person_properties` order by id",oConn} 
	if oPersProp:RecCount>0
		DO WHILE !oPersProp:EOF
			AAdd(pers_propextra,{oPersProp:FIELDGET(2), oPersProp:ID,oPersProp:type,Lower(oPersProp:VALUES)})
			oPersProp:Skip()
		ENDDO 
	endif
	RETURN 

FUNCTION FillPersTitle ()
	* Fill global Array pers_titles with description + id of Titles
	pers_titles:= SQLSelect{"select descrptn,id from titles",oConn}:GetLookupTable(100)
	RETURN 
FUNCTION FillPersType ()
* Fill global Array with description + id  and abbriviation, id
LOCAL oPersTp as SQLSelect
oPersTp:=SQLSelect{"select lower(descrptn) as descrptn,abbrvtn,id from persontype",oConn} 
Pers_Types:= oPersTp:GetLookupTable(500,#DESCRPTN,#ID) 
oPersTp:GoTop()
pers_types_abrv:=oPersTp:GetLookupTable(500,#ABBRVTN,#ID)
return
FUNCTION FillPropTypes()
* Fill Array with person property types
prop_types:= {{"Text",TEXTBX},{"CheckBox",CHECKBX},{"DropDownList",DROPDOWN},{"Date",DATEFIELD} } 
return
FUNCTION FilterAcc(aAcc as array ,accarr as array,cStart as string,cEnd as string,aBalIncl:=null_array as array,aDepIncl:=null_array as array) as void
	// add conditinally accstr to aAcc
	LOCAL accstr:=LTrimZero(SubStr(accarr[1],1,LENACCNBR)) as STRING
	IF accstr>=cStart .and. accstr<=cEnd
		if (Empty(aBalIncl) .or. AScan(aBalIncl,Str(accarr[3],-1))>0) .and. (Empty(aDepIncl) .or. AScan(aDepIncl,Str(accarr[3],-1))>0) 
			AAdd(aAcc,{accarr[1],accarr[2]})
		endif
	ENDIF
	RETURN
FUNCTION FullName( cFirstName as STRING, cLastName as STRING ) as STRING

	LOCAL cFullName as STRING
	
	cFullName := AllTrim( cFirstName ) + " " + AllTrim( cLastName )
	
	RETURN cFullName
FUNCTION FWriteLineUni(pFile, c) 
// write line c to pFile converted to Unicode
LOCAL oUni as Unicode
//local Start:=_chr(0xFF)+_chr(0xFE) as psz 
local Start:=psz(_cast,_chr(0xEF)+_chr(0xBB)+_chr(0xBF)) as psz
oUni:=Unicode{c+CRLF}
if oUni:Error
	Return 0
ELSE
	if FTell(pFile)==0
		FWrite(pFile,Start,3) // start of unicode
	endif
	Return FWrite(pFile,Mem2String(oUni:BSTR,oUni:Len))
endif
//Return FWriteLine(pFile,c) 
FUNCTION GetBalType(cSoort)
* Translate baltype code to text
RETURN aBalType[AScan(aBalType,{|x| x[1]==cSoort}),2]
Function GetDelimiter(cBuffer as string, aStruct ref array, cLim:="" ref string, nMin as int, nMax as int) as logic
	/* determine delimiter and column names of input file with spreadsheet:
	Input: cBuffer with content of first line of file
	nMin: minimal number of columns  
	nMax: maximum number of columns

	Returns:
	False: if no columns could be determined
	aStruct: array with names of columns
	cLim: used delimiter 
	*/ 
	if Len(cLim)=0
		cLim:=Listseparator
	endif
	aStruct:=Split(Upper(cBuffer),cLim)
	IF Len(aStruct)<nMin .or.Len(aStruct)>nMax
		cLim:=','
		aStruct:=Split(Upper(cBuffer),cLim)
		IF Len(aStruct)<nMin .or.Len(aStruct)>nMax
			cLim:=";"
			aStruct:=Split(Upper(cBuffer),cLim)
			IF Len(aStruct)<nMin .or.Len(aStruct)>nMax
				cLim:=CHR(9)
				aStruct:=Split(Upper(cBuffer),cLim)
				IF Len(aStruct)<nMin .or.Len(aStruct)>nMax
					return false
				endif 
			endif
		endif
	endif 
	return true
FUNC GetError    (oSELF as OBJECT, cDescription as STRING)  as ERROR     PASCAL
    LOCAL oError as ERROR

	oError := ErrorNew()
	oError:Subsystem   := "ODBC"
	oError:FuncSym     := AsSymbol( ProcName(1) )
	oError:CallFuncSym := AsSymbol( ProcName(2) )
    oError:Description := cDescription 
    oError:MethodSelf  := oSELF

    RETURN oError
function GetExplain(SqlString as string) as string
// get explain text from given sqlstring
local oSel as SQLSelect
local cText as string
local Tab:=CHR(9) as string
local i as int
oSel:=SQLSelect{"explain "+SqlString,oConn}
for i:=1 to oSel:FCount 
	cText+=oSel:SQLColumns[i]:colname+Tab
next
cText+=CRLF

do while !oSel:Eof
	for i:=1 to oSel:FCount 
		cText+=Transform(oSel:Getdata(i),"")+iif(i<oSel:FCount,Tab,"")
	next
	cText+=CRLF
	oSel:Skip()
enddo 
return cText
function GetHelpDir()

if Len(Directory("C:\Users\"+myApp:GetUser()+"\AppData\Local\Temp",FA_DIRECTORY))>0
//if nLen>0 
	HelpDir:="C:\Users\"+myApp:GetUser()+"\AppData\Local\Temp"
elseIF Len(Directory("C:\WINDOWS\TEMP",FA_DIRECTORY))>0
	HelpDir:="C:\Windows\Temp"
ELSEIF Len(Directory("C:\TEMP",FA_DIRECTORY))>0
	HelpDir:="C:\TEMP"
ELSE
	HelpDir:="C:"
ENDIF 
Function GetMailAbrv(cCode as string) as string
	* Return abbrivation corresponding with given pers_code
	LOCAL nPtr as int
	nPtr:=AScan(mail_abrv,{|x|x[2]==cCode})
	if nPtr>0
		return mail_abrv[nPtr,2]
	else
		return ""
	endif
Function GetMailDesc(cCode as string) as string
	* Return description corresponding with given pers_code
	LOCAL nPtr as int
	nPtr:=AScan(pers_codes,{|x|x[2]==cCode})
	if nPtr>0
		return pers_codes[nPtr,1]
	else
		return ""
	endi
FUNCTION GetParentWindow(oSelf)
LOCAL oWindow as OBJECT
oWindow:=oSelf
DO WHILE true
	IF IsAccess(oWindow,#Owner)
		IF IsInstanceOf(oWindow:Owner,#Window).or.IsInstanceOf(oWindow:owner,#DataBrowser)
			oWindow:=oWindow:Owner
		ELSE
			exit
		ENDIF
	ENDIF
ENDDO
IF !IsInstanceOf(oWindow,#Window)
	oWindow:=null_object
ENDIF

RETURN oWindow
function GetServername(fullpathname as string) as string 
	// get server name from a path
	local cSearch,cServerName:="localhost" as string
	local nPosbackslash as int
	fullpathname:=AllTrim(fullpathname)
	if Len(fullpathname)>1
		if !SubStr(fullpathname,1,2)=='\\'
			fullpathname:=NetGetConnection(fullpathname)
		endif
		if Len(fullpathname)>2
			cServerName:=SubStr(fullpathname,3,At3('\',fullpathname,3)-3)
		endif
	endif
	return cServerName
FUNCTION GetTokens(cText as string,aSep:=null_array as array) as array
*	Determine Tokens in a string of text
*	aSep: optionaly array with separators
*	Returns array with Tokens {{Token,Seperator},...}

LOCAL Tokens:={} as ARRAY, chText, Token, cSep, cSepPrev:=null_string, cChar as STRING, nLength,i as int,EndOfWord as LOGIC 
if Empty(aSep)
	aSep:= {" ",",",".","&","/","-"}
endif
// Default(@aSep,{" ",",",".","&","/","-"})

chText:=Compress(cText)
nLength:=Len(chText)
FOR i:=1 to nLength
	* bepaal volgende Tokens:
	Token:=""
	cSep:=""
	EndOfWord:=FALSE
	DO WHILE !EndOfWord .and.i<=nLength
		cChar:=SubStr(chText,i,1)
		IF AScanExact(aSep,cChar)>0
			IF Empty(Token)
				IF !Empty(cChar).and.i>1.and.!cChar==cSepPrev
					* only non blank seperator:
					EndOfWord:=true
					cSep:=cChar
					exit
				ENDIF				
			ELSE
				EndOfWord:=true
				cSep:=cChar
				exit
			ENDIF
		ELSE
			IF !Empty(Token) .and. (IsDigit(psz(_cast,cChar)) .and. IsAlpha(psz(_cast,Token)) .or. IsDigit(psz(_cast,Token)) .and.IsAlpha(psz(_cast,cChar)))
				* regard transition from alpha to numeric or numeric to alpha as separate word
				EndOfWord:=true
				cSep:=" "
				--i
				exit
			ELSE				
				Token:=Token+cChar
			ENDIF
		ENDIF
		++i
	ENDDO
	IF !Empty(Token).or.!Empty(cSep)
		AAdd(Tokens,{Token,cSep})
		cSepPrev:=cSep
	ENDIF
NEXT
RETURN Tokens
FUNCTION Getvaliddate (pDay,pMonth,pYear)
* Determination of valid date (if not valid return next valid date)
LOCAL nwdat as date, i as int
IF pDay > 31
   pDay:=31
ENDIF
IF pMonth > 12
   pYear:=pYear+Integer(pMonth/12)
   pMonth := pMonth%12
ELSEIF pMonth<=0
	pYear:=pYear+Round((pMonth-12)/12,0)
	pMonth:=pMonth%12
ENDIF
FOR i=0 to 3  && corrigeer voor kortere maand
    nwdat:=SToD(Str(pYear,4,0)+StrZero(pMonth,2,0)+StrZero(pDay-i,2,0))
    IF .not.Empty(nwdat)
       exit
    ENDIF
NEXT
RETURN(nwdat)
function HtmlDecode(cText as string)
/*
Decode html encoded characters:
'&' (ampersand) becomes '&amp;'
'"' (double quote) becomes '&quot;' when ENT_NOQUOTES is not set.
''' (single quote) becomes '&#039;' only when ENT_QUOTES is set.
'<' (less than) becomes '&lt;'
'>' (greater than) becomes '&gt;'
*/
Local aKey:={'&amp;','&quot;', '&#039;', '&lt;', '&gt;'} as array
Local aRepl:={'&','"',"'",'<','>'} 
local i as int
for i:=1 to 5
 	cText:=StrTran(cText,aKey[i],aRepl[i])
next
Return cText
FUNCTION Implode(aText:={} as array,cSep:=" " as string,nStart:=1 as int,nCount:=0 as int,nCol:=0 as int)
	// Implode array to string seperated by cSep 
	// Optionaly you can indicate a column to implode in case of a multidimenional array
	LOCAL i, l:=Len(aText) as int, cRet:="", cQuote as STRING
	if Len(cSep)>2
		// test if surrounded by quotes:
		cQuote:= Left(cSep,1)
		if cQuote==Right(cSep,1)
			if !(cQuote=="'" .or. cQuote=='"')
				cQuote:=null_string
			endif
		endif
	endif
	if l>0
		if Empty(nCount)
			nCount:=l-nStart+1 
		endif
		nCount:=Min(nCount,l-nStart+1)
		IF nCount>0 
			FOR i:=1 to nCount
				cRet+=iif(Empty(cRet),"",cSep)+AllTrim(Transform(iif(Empty(nCol),aText[nStart+i-1],aText[nStart+i-1][nCol]),""))
			NEXT
		ENDIF 
	endif
	RETURN cQuote+cRet+cQuote
function InitGlobals() 
	LOCAL oLan as Language
// 	Local oPP as PPCodes
	LOCAL nMindate as int
	LOCAL lRefreshMenu as LOGIC
	LOCAL oReg as CLASS_HKLM
	LOCAL excelpath as STRING 
	LOCAL aBalYearFile:={} as ARRAY
	Local ind as int
	local oSel,oSys as SQLSelect
	local oStmnt as SQLStatement 

	oReg:=Class_HKLM{}
	excelpath:=oReg:GetString("SOFTWARE\Microsoft\Office\12.0\Excel\InstallRoot","Path")  // installroot excel
	IF Empty(AllTrim(excelpath))
		excelpath:=oReg:GetString("SOFTWARE\Microsoft\Office\11.0\Excel\InstallRoot","Path")  // installroot excel
	ENDIF	
	IF Empty(AllTrim(excelpath))
		excelpath:=oReg:GetString("SOFTWARE\Microsoft\Office\9.0\Excel\InstallRoot","Path")  // installroot excel
	ENDIF	
	EXCEL:= excelpath +"Excel.exe "
	oReg:=null_object
	oSys:=SQLSelect{"select * from sysparms",oConn}
	IF oSys:RecCount>0
		oSel:=SQLSelect{"select * from balanceyear order by yearstart desc, monthstart desc limit 1",oConn}
		IF oSel:RecCount>0
			nMindate:=oSel:YEARSTART*12+oSel:YEARLENGTH+oSel:MONTHSTART 
			LstYearClosed:=SToD(Str(Integer(nMindate/12),4)+StrZero(nMindate%12,2)+"01")
			if oSys:Mindate < LstYearClosed
				oSys:Mindate:=LstYearClosed
			endif
			if oSys:yearclosed < oSel:YEARSTART
				oSys:yearclosed:= oSel:YEARSTART
			endif
		ENDIF

		sam		:= iif(Empty(oSys:AM),'',Str(oSys:AM,-1))
		samProj	:= iif(Empty(oSys:ASSPROJA),'',Str(oSys:ASSPROJA,-1))
		samFld	:= iif(Empty(oSys:ASSFLDAC),'',Str(oSys:ASSFLDAC,-1))
		SCLC	:= AllTrim(iif(IsNil(oSys:DEFAULTCOD),'',oSys:DEFAULTCOD))
		SFGC	:= AllTrim(iif(IsNil(oSys:FGMLCODES),'',oSys:FGMLCODES))
		SKAP	:= iif(Empty(oSys:Capital),'',Str(oSys:Capital,-1))
		SKAS	:= iif(Empty(oSys:Cash),'',Str(oSys:Cash,-1))
		SDON	:= iif(Empty(oSys:Donors),'',Str(oSys:Donors,-1))
		SDEB	:= iif(Empty(oSys:Debtors),'',Str(oSys:Debtors,-1))
		SCRE	:= iif(Empty(oSys:CREDITORS),'',Str(oSys:CREDITORS,-1))
		SPROJ	:= iif(Empty(oSys:Projects),'',Str(oSys:Projects,-1))
		SINC	:= iif(Empty(oSys:GIFTINCAC),'',Str(oSys:GIFTINCAC,-1))
		SEXP	:= iif(Empty(oSys:GIFTEXPAC),'',Str(oSys:GIFTEXPAC,-1))
		SINCHOME	:= iif(Empty(oSys:HOMEINCAC),SINC,Str(oSys:HOMEINCAC,-1) )
		SEXPHOME	:= iif(Empty(oSys:HOMEEXPAC),SEXP,Str(oSys:HOMEEXPAC,-1)  )
		sInhdKntr := oSys:assmntOffc
		sInhdKntrL := oSys:withldoffl
		sInhdKntrM := oSys:withldoffm
		sInhdKntrH := oSys:withldoffh
		sInhdField := oSys:assmntfield 
		CITYUPC := iif(oSys:CITYNMUPC==1,true,false)
		LSTNUPC := iif(oSys:LSTNMUPC==1,true,false)
		
		SEntity	:= AllTrim(oSys:Entity)
		SHB		:= iif(Empty(oSys:HB),'',Str(oSys:HB,-1))
		SKruis	:= iif(Empty(oSys:CrossAccnt),'',Str(oSys:CrossAccnt,-1))
		SPOSTZ	:= iif(Empty(oSys:Postage),'',Str(oSys:Postage,-1))
		STOPP		:= iif(Empty(oSys:ToPPAcct),'',Str(oSys:ToPPAcct,-1) )
		sCURRNAME:= AllTrim(oSys:CURRNAME) 
		Posting:=iif(oSys:Posting==1,true,false)
		LstCurRate := iif(oSys:LSTCURRT==1,true,false)
		oSel:= SQLSelect{"select * from currencylist where aed='"+AllTrim(oSys:Currency)+"'",oConn}
		if oSel:RecCount>0
			sCURR   :=  oSel:AED
		endif
		BANKNBRDEB:=iif(Empty(oSys:BANKNBRCOL),'',AllTrim(oSys:BANKNBRCOL)) 
		BANKNBRCRE:=iif(Empty(oSys:BANKNBRCRE),'',AllTrim(oSys:BANKNBRCRE)) 
		sIDORG := iif(Empty(oSys:IDORG),'',Str(oSys:IDORG,-1))
		if !Empty(oSys:ADMINTYPE)
			if !Admin==oSys:ADMINTYPE
				lRefreshMenu:=true
			ENDIF
			Admin:=oSys:ADMINTYPE
		ENDIF
		requiredemailclient:=oSys:MAILCLIENT
		sFirstNmInAdr := iif(oSys:FirstName==1,true,false)
		sLand	:= AllTrim(oSys:CountryOwn)
		OwnCountryNames:=Split(AllTrim(oSys:OWNCNTRY),",")
		sFirstNmInAdr := iif(oSys:FirstName==1,true,false)
		sSurnameFirst := iif(oSys:SURNMFIRST==1,true,false)
		sSalutation := iif(oSys:NOSALUT==1,false,true)
		TITELINADR := iif(oSys:TITINADR==1,true,false)
		sSTRZIPCITY := oSys:STRZIPCITY
		ClosingMonth:=oSys:CLOSEMONTH
		Alg_Taal := oSys:CrLanguage
		Mindate:=oSys:Mindate 
		if Empty(LstYearClosed)
			LstYearClosed:=Mindate
		endif

		CountryCode:=AllTrim(oSys:COUNTRYCOD)
		if !Empty(BANKNBRCRE) .and. SEntity="NED"
			// add to PPcodes as destination for distribution instructions for outgooing payments to bank: 
			oSel:=SQLSelect{"select * from ppcodes where ppcode='AAA'",oConn}
			if oSel:RecCount=0
				SQLStatement{"insert into ppcodes set ppcode='AAA',ppname='Bank:"+BANKNBRCRE+"'",oConn}:execute()
			elseif !AllTrim(oSel:PPNAME)=="Bank:"+BANKNBRCRE
				SQLStatement{"update ppcodes set ppname='Bank:"+BANKNBRCRE+"' where ppcode='AAA'",oConn}:execute()
			endif
		endif 
		oSel:=SQLSelect{"select * from ppcodes where ppcode='ACH'",oConn}
		if oSel:RecCount=0
			SQLStatement{"insert into ppcodes set ppcode='ACH',ppname='ACH for member bank deposits'",oConn}:execute()
		endif
	ENDIF 
	// determine available balance years: 
	GlBalYears:=FillBalYears() 
	// determine local date format for retrieval with mysql:
	LocalDateFormat:=StrTran(StrTran(StrTran(DToC(SToD("19991230")),"1999","%Y"),"30","%d"),"12","%m")

	aBalType:={{ASSET,"Assets"},{INCOME,"Income"},{EXPENSE,"Expense"},{LIABILITY,"Liabilities"}}
	USRTypes:={{"System Administrator","A"},{"Financial Administrator","F"},{"Person Administrator","P"}}
	if Admin="WA"
		AAdd(USRTypes,{"Declarer expenses","D"})
	endif 
	if Posting
		AAdd(USRTypes,{"Financial Manager","M"})
	endif

	oLan:=Language{}
		Maand := {	oLan:RGet('January',,"!"),oLan:RGet('February',,"!"),oLan:RGet('March',,"!"),;
			oLan:RGet('April',,"!"),oLan:RGet('May',,"!"),oLan:RGet('June',,"!"),;
			oLan:RGet('July',,"!"),oLan:RGet('August',,"!"),oLan:RGet('September',,"!"),;
			oLan:RGet('October',,"!"),oLan:RGet('November',,"!"),oLan:RGet('December',,"!")}
		PaymentDescription:={;
			oLan:RGet("Donation",,"!"),oLan:RGet("Gift",,"!"),oLan:RGet("Invoice",,"!"),;
			oLan:RGet("subscription",,"!")}
	TeleBanking := FALSE 
	AutoGiro:= FALSE
	
	oSel:=SQLSelect{"select * from bankaccount",oConn}
	IF oSel:RecCount>0
		// fill global array with bank accounts
		BankAccs:={}
		DO WHILE !oSel:EOF
			AAdd(BankAccs,Str(oSel:accid,-1))
			oSel:Skip()
		ENDDO
		oSel:=SQLSelect{"select * from bankaccount where telebankng>0 and accid",oConn}
		IF oSel:RecCount>0
			TeleBanking:=true
		else
			TeleBanking:=false
		ENDIF
		LENBANKNBR:=25
		IF TeleBanking
			lRefreshMenu:=true
		ENDIF

	ENDIF
	FillPersCode()
	FillPersType()
	FillPersGender()
	FillPersTitle()
	FillPropTypes()
	FillPersProp() 
	aAsmt:={{"assessable","AG"},{"charge","CH"},{"membergift","MG"},{"pers.fund","PF"}}
	LENPRSID:=11
	LENEXTID:=11
   if !SQLSelect{"select count(*) as total from department",oConn}:total=="0"
		Departments:=true
	endif

	IF lRefreshMenu
		oMainWindow:RefreshMenu()
		oMainWindow:SetCaption(oSys:sysname)
	ENDIF
	RETURN nil
	
FUNCTION IsAlphabetic(m_str as string) as logic
* Check if string m-str is alphabetic
LOCAL p_str as STRING,p_num_tel as int 
local lAlpha:=true as logic
IF Empty(m_str)
   RETURN FALSE
ENDIF
p_str:=AllTrim(m_str) 
FOR p_num_tel:=1 to Len(p_str)
    IF IsDigit(psz(_cast,SubStr(p_str,p_num_tel,1)))
       RETURN FALSE
    ENDIF
NEXT
RETURN true
FUNCTION isalphanumeric (m_str)
* Check if string m-str is alphanumeric
LOCAL type:=ValType(m_str),p_str as STRING,p_num_tel as int
IF Empty(m_str)
   RETURN FALSE
ENDIF
IF IsNumeric(m_str)
   RETURN true
ELSEIF !IsString(m_str)
   RETURN FALSE
ENDIF
p_str:=AllTrim(m_str)
FOR p_num_tel:=1 to Len(p_str)
    IF !IsAlpha(psz(_cast,SubStr(p_str,p_num_tel,1))) .and.!IsDigit( psz(_cast,SubStr(p_str,p_num_tel,1)))
       RETURN FALSE
    ENDIF
NEXT
RETURN true
FUNCTION IsDutchBanknbr(cGetal)
	* check if bankaccount# of a ducth bank is "11-proef"
	LOCAL nL,i, nCheck as int
	cGetal:=Str(Val(StrTran(cGetal,".","")),-1)
	nL:=Len(cGetal)
	if nL<9 .or. nL>10
		return false
	endif
	if nL==9
		FOR i:=1 to nL
			nCheck+=Val(SubStr(cGetal,i,1))*(10-i)
		NEXT
		return (Mod(nCheck,11)==0)
	else
		return true
	endif
FUNCTION IsMod10(cGetal)
// test if cGetal (string of a mod10 number) satisfies mod10 criteria (Luhn algoritme)
LOCAL sum,i,length:=Len(cGetal),temp as int
LOCAL alt:=FALSE as LOGIC

	FOR i:=length DOWNTO 1 step 1
		IF alt
			temp := Val(SubStr(cGetal,i,1))*2
			IF temp > 9
				temp:= temp - 9
			ENDIF
		ELSE
			temp:=Val(SubStr(cGetal,i,1))
		ENDIF
		sum += temp
		alt := !alt
	NEXT
	RETURN ((sum % 10) == 0)
Function IsMod11(cGetal as string) as logic
// check if cGetal is  modulo 11 for dutch betalingskenmerk 
return (cGetal==Mod11(SubStr(cGetal,2)))
Function IsModulus11(cGetal as string) as logic
local lres as usual
lres:=Modulus11(SubStr(cGetal,1,Len(cGetal)-2))
if IsLogic(lres)
	return false
else
	return (lres==SubStr(cGetal,Len(cGetal)-1,2))
endif

FUNCTION isnum (m_str as string ) as logic
* Check if string m-str is numeric
LOCAL p_str as STRING,p_num_tel as int
IF Empty(m_str)
   RETURN FALSE
ENDIF
p_str:=RTrim(m_str)
FOR p_num_tel:=1 to Len(p_str)
    IF IsAlpha(psz(_cast,SubStr(p_str,p_num_tel,1))) .or.Empty(SubStr(p_str,p_num_tel,1))
       RETURN FALSE
    ENDIF
NEXT
RETURN true
DEFINE LF                   := _chr(10)
CLASS ListboxBal INHERIT ListBox
* Special version of listbox to support multiple selction of Departments
PROTECT cDepStart, cDepStartName as STRING  // range of Departmentnumbers
PROTECT cCurStart as STRING // Current values used in list
protect aItem:={} as array  // container for departments 
declare method AddSubDep
// ACCESS Server CLASS ListBoxBal
// RETURN oDepartment
// ASSIGN Server(oDep) CLASS ListboxBal
// oDepartment:=null_object
// oDepartment:=oDep
// RETURN oDepartment
METHOD AddSubDep(aDep as array,ParentNum:=0 as int, nCurrentRec:=0 as int) as int  CLASS ListBoxBal
	* Find subdepartments and add to arrays with departments
	LOCAL nChildRec			as int
	LOCAL nCurNum			as int

	IF !Empty(nCurrentRec).and.!aItem[nCurrentRec,2]==ParentNum
		nCurrentRec:=0
	endif
	nCurrentRec:=AScan(aItem,{|x|x[2]==ParentNum},nCurrentRec+1)
	IF Empty(nCurrentRec)
		return 0
	endif
	nCurNum:= aItem[nCurrentRec,1]
	if aItem[nCurrentRec,5]>0 // accounts under it? 
		AAdd(aDep,{aItem[nCurrentRec,4]+Space(1)+aItem[nCurrentRec,3],nCurNum})
	endif
   
	// add all child departments:
	DO WHILE true
		nChildRec:=self:AddSubDep(aDep,nCurNum, nChildRec)
		IF Empty(nChildRec)
			exit
		ENDIF
	ENDDO
	RETURN nCurrentRec
ACCESS DepNameStart CLASS ListBoxBal
RETURN cDepStartname
ASSIGN DepNameStart(cValue) CLASS ListBoxBal
cDepStartname:=cValue
RETURN cValue
ACCESS DepNbrStart CLASS ListBoxBal
RETURN cDepStart
ASSIGN DepNbrStart(cValue) CLASS ListBoxBal
cDepStart:=cValue
self:Refill()
RETURN cValue
METHOD GetDepnts() CLASS ListBoxBal
	LOCAL oDep as SQLSelect
	LOCAL aDep:={} as ARRAY
	LOCAL nStart as int, nCurRec as int 
	LOCAL oDep as SQLSelect
	// fill array with departments
	if Empty(aItem)
		// select all departments with accounts:
		oDep:=SQLSelect{"SELECT d.depid,d.parentdep,d.descriptn,d.deptmntnbr,count(a.accid) as acccnt "+;
			"FROM `department` d left join `account` a on(a.department=d.depid) group by d.depid order by parentdep,deptmntnbr",oConn}
		if oDep:RecCount>0
			do while !oDep:EoF
				AAdd(aItem,{oDep:DepId,oDep:parentdep,oDep:descriptn,oDep:deptmntnbr,Val(oDep:acccnt)})
				//          		 1         2           3              4                  5
				oDep:Skip()
			enddo
		else
			return {}
		endif
	endif

	* Enforce correct sequence:
	nStart:=Val(self:cDepStart)


	* Check and fill requested Departments:
	IF Empty(nStart)
		* Top department is WO Office:
		aDep:={{cDepStartName,0}}
	else
		nCurRec:=AScan(aItem,{|x|x[1]==nStart.and.x[5]>0})
		if nCurRec>0 
			aDep:={{aItem[nCurRec,4]+Space(1)+aItem[nCurRec,3],aItem[nCurRec,1]}}
		endif
		nCurRec:=0
	ENDIF

	* Add all subdepartments down from WhoFrom:
	DO WHILE true
		nCurRec:=self:AddSubDep(aDep,nStart,nCurRec)
		IF Empty(nCurrec)
			exit
		ENDIF
	ENDDO

	RETURN aDep
METHOD GetRetValues () CLASS ListBoxBal
	RETURN self:aRetValues
METHOD GetSelectedItems () CLASS ListBoxBal
LOCAL aDep:={} as ARRAY
LOCAL nPos as int
* Check if listbox has been activated since last rnage change:
// IF !self:cDepStart==self:cCurStart
// 	* RETURN all Departments within range:
// 	RETURN (AEvalA(self:GetDepnts(),{|x| x[2]}))
// ENDIF
nPos :=self:FirstSelected()
DO WHILE nPos>0
	AAdd(aDep,self:getItemValue(nPos))
	nPos:=self:NextSelected()
ENDDO
RETURN aDep
METHOD Refill() CLASS ListBoxBal
LOCAL i as int
IF !cDepStart==cCurStart
	* Range has been changed, thus new selection:
	self:FillUsing( self:GetDepnts())
	cCurStart:=cDepStart
	* Select all:
    FOR i = 1 to self:ItemCount
    	self:SelectItem(i)
    NEXT

ENDIF
RETURN nil
CLASS ListBoxExtra INHERIT ListBox
	* Special version of listbox to support multiple selction of accounts
	export cAccStart, cAccEnd as STRING  // range of accountnumbers
	export cCurStart,cCurEnd as STRING // Current values used in list 
	PROTECT oAccount as SQLSelect  
	export aBalIncl,aDepIncl as array 
	EXPORT cDepIncl,cBalIncl as STRING

	declare method GetAccnts,GetAccounts,GetSelectedItems
ACCESS AccNbrEnd CLASS ListBoxExtra
	RETURN cAccEnd
ASSIGN AccNbrEnd(cValue) CLASS ListBoxExtra
	cAccEnd:=cValue
	self:Refill()
	RETURN cValue
ACCESS AccNbrStart CLASS ListBoxExtra
	RETURN self:cAccStart
ASSIGN AccNbrStart(cValue) CLASS ListBoxExtra
	self:cAccStart:=cValue
	self:Refill()
	RETURN cValue
METHOD GetAccnts(dummy:=nil as string) as array CLASS ListBoxExtra
	// LOCAL oAcc as account 
	Local oSQL as SQLSelect
	LOCAL aAcc:={} as ARRAY
	LOCAL cExchAcc, cStart, cEnd, cWhere as STRING
	LOCAL lSuc as LOGIC
	local cBalIncl,cDepIncl as string
	* Enforce correct sequence:
	cStart:=LTrimZero(self:cAccStart)
	cEnd:=LTrimZero(self:cAccEnd)
	IF Empty(cStart).and.Empty(cEnd)
		RETURN {}
	ENDIF
	IF !Empty(cEnd).and. cStart>cEnd
		cExchAcc := cEnd
		cEnd:=cStart
		cStart:=cExchAcc
	ENDIF
	
	if !Empty(cStart).and.!Empty(cEnd)
		cWhere:="accnumber between '"+cStart+"' and '"+cEnd+"'"
	elseif !Empty(cStart)
		cWhere:="accnumber>='"+cStart+"'"
	else
		cWhere:="accnumber<='"+cStart+"'"
	endif
	if !Empty(self:cDepIncl)
		cWhere+=iif(Empty(cWhere),""," and ")+" department in ("+cDepIncl+")" 
	endif
	if !Empty(cBalIncl)
		cWhere+=iif(Empty(cWhere),""," and ")+" balitemid in ("+cBalIncl+")" 
	endif

	oSQL:=SQLSelect{"select accnumber,description,accid,department,balitemid from account where giftalwd=1 and "+cWhere ,oConn}
	oSQL:Execute()
	DO WHILE !oSQL:EoF
		AAdd(aAcc,{Pad(oSQL:accnumber,LENACCNBR)+" "+oSQL:description,oSQL:accid})
		oSQL:Skip()
	ENDDO
	RETURN aAcc
METHOD GetAccounts(dummy:=nil as string) as array CLASS ListBoxExtra
	// get accounts for subset of listbox
	LOCAL aAcc:={} as ARRAY
	LOCAL cExchAcc, cStart, cEnd as STRING
	LOCAL oParent:=self:Owner as DataWindow
	LOCAL aMemHome:=oParent:aMemHome as ARRAY
	LOCAL aMemNonHome:=oParent:aMemNonHome as ARRAY
	LOCAL aProjects:=oParent:aProjects as ARRAY
	LOCAL lHome:=oParent:HomeBox,lNonHome:=oParent:NonHomeBox,lProjects:=oParent:ProjectsBox as LOGIC
	* Enforce correct sequence:
	cStart:=LTrimZero(oParent:selx_rek)
	cEnd:=LTrimZero(oParent:selx_rekend)
	IF Empty(cStart).and.Empty(cEnd)
		RETURN {}
	ENDIF
	IF !Empty(cEnd).and. cStart>cEnd
		cExchAcc := cEnd
		cEnd:=cStart
		cStart:=cExchAcc
	ENDIF
	IF lHome
		AEval(aMemHome,{|x| FilterAcc(aAcc,x,cStart,cEnd,{},{})})
	ENDIF
	IF lNonHome
		AEval(aMemNonHome,{|x| FilterAcc(aAcc,x,cStart,cEnd,,)})
	ENDIF
	IF lProjects
		AEval(aProjects,{|x| FilterAcc(aAcc,x,cStart,cEnd,,)})
	ENDIF
	RETURN aAcc   
METHOD GetRetValues () CLASS ListBoxExtra
	RETURN self:aRetValues
METHOD GetSelectedItems (dummy:=nil as logic) as array CLASS ListBoxExtra
LOCAL aAcc:={} as ARRAY
LOCAL nPos as int
* Check if listbox has been activated since last range change:
// IF !self:cAccStart==self:cCurStart.or.!self:cAccEnd==self:cCurEnd
// 	* RETURN all accounts within range:
// 	RETURN (AEvalA(self:GetAccnts(null_string),{|x| x[2]}))
// ENDIF
nPos :=self:FirstSelected()
DO WHILE nPos>0
	AAdd(aAcc,self:getItemValue(nPos))
	nPos:=self:NextSelected()
ENDDO
RETURN aAcc

		

	
METHOD Refill() CLASS ListBoxExtra
	LOCAL i as int
	// IF !cAccStart==cCurStart.or.!cAccEnd==cCurEnd
	* Range has been changed, thus new selection:
	self:FillUsing( self:GetAccnts(null_string))
	cCurStart:=cAccStart
	cCurEnd:=cAccEnd
	* Select all:
	FOR i = 1 to self:ItemCount
		self:SelectItem(i)
	NEXT

	// ENDIF
	RETURN nil
ACCESS Server CLASS ListBoxExtra
RETURN oAccount
ASSIGN Server(oAcc) CLASS ListBoxExtra
oAccount:=null_object
oAccount:=oAcc
RETURN oAccount
ASSIGN WhatFrom(cValue) CLASS ListBoxExtra 
	self:aBalIncl:={}
	if !Empty(cValue)
		self:cBalIncl:= SetAccFilter(Val(cValue))
		self:aBalIncl:=Split(self:cBalIncl,",")
	endif

	self:Refill()
	RETURN cValue
ASSIGN WhoFrom(cValue) CLASS ListBoxExtra 
	self:aDepIncl:={}
	if !Empty(cValue)
		self:cDepIncl:= SetDepFilter(Val(cValue))
		self:aDepIncl:=Split(self:cDepIncl,',')
	endif

	self:Refill()
	RETURN cValue
Access MyImageIndex() class ListViewItem
RETURN self:nImageIndex
FUNCTION LogEvent(oWindow:=null_object as Window,strText as string, Logname:="Log" as string) as logic
*	Logging of info to file <Logname>.txt
LOCAL ToFileFS as FileSpec
LOCAL cFileName, selftext as STRING
LOCAL ptrHandle 
local oStmnt as SQLStatement
*	Logging of info to table log 
oStmnt:=SQLStatement{"insert into log set "+sIdentChar+"collection"+sIdentChar+"='"+Lower(Logname)+"',logtime=now(),"+sIdentChar+"source"+sIdentChar+"='"+;
iif(IsObject(oWindow),Symbol2String(ClassName(oWindow)),"")+"',"+sIdentChar+"message"+sIdentChar+"='"+strText+"',"+sIdentChar+"userid"+sIdentChar+"='" +LOGON_EMP_ID+"'",oConn}
oStmnt:execute()
If !Empty(oStmnt:status) 
	// write to file
	ToFileFS:=FileSpec{Logname}
	ToFileFS:Extension:="TXT"
	ToFileFS:Path:=CurPath
	cFileName:=ToFileFS:FullPath
	IF	ToFileFS:Find()
		ptrHandle := FOpen(ToFileFS:FullPath,FO_READWRITE+FO_DENYNONE)
	ELSE
		ptrHandle := FCreate(ToFileFS:FullPath)
	ENDIF	
	IF	ptrHandle==nil	.or.ptrHandle = F_ERROR
		RETURN FALSE
	ENDIF
	* position file at end:
	FSeek(ptrHandle, 0, FS_END)
	selftext:=DToS(Today())+" "+Time()+" -	"+strText
	IF	IsObject(oWindow)
		selftext:=Symbol2String(ClassName(oWindow))+": "+selftext
	ENDIF
	FWriteLine(ptrHandle,selftext)
	FClose(ptrHandle) 
endif
if !Empty(oStmnt:status).or.(Lower(Logname)=="logerrors" .and. AtC("MySQL server has gone away",strText) >0)
	ErrorBox{oWindow,"MySQL server has gone away"}:Show()
	if !Empty(oStmnt:status) 
		break
	endif
endif

RETURN true
FUNCTION LogEventNew(oWindow:=null_object as Window,strText as string, Logname:="Log" as string) as logic
*	Logging of info to table log 
SQLStatement{"insert into log set "+sIdentChar+"collection"+sIdentChar+"='"+Lower(Logname)+"',logtime=now(),"+sIdentChar+"source"+sIdentChar+"='"+;
iif(IsObject(oWindow),Symbol2String(ClassName(oWindow)),"")+"',"+sIdentChar+"message"+sIdentChar+"='"+strText+"'",oConn}:execute()
RETURN true
FUNCTION LTrimZero(cString as STRING) as STRING
* Left trim leading zeroes in string
LOCAL i as int
cString:=AllTrim(cString)
FOR i:=1 to Len(cString)
	IF !SubStr(cString,i,1)="0"
		IF i>1
			cString:=SubStr(cString,i)
		ENDIF
		exit
	ENDIF
NEXT
RETURN cString		
FUNCTION MakeFile(oOwner:=null_object as window,cFileName ref string,cDescription as string) as ptr
* Create a file Filename and return handler; in case of error return doserror, in case of cancel returns nil
LOCAL ptrHandle as ptr
LOCAL oFileSpec as Filespec
LOCAL MyFileName,MyPath as STRING, nReturn as int
LOCAL oTextBox as TextBox, oFileDialog as SaveAsDialog 
local fileerror as string 

cFileName:=CleanFileName(cFileName)
oFileSpec:=FileSpec{cFileName}
cFileName:= oFileSpec:FullPath
DO WHILE true
	ptrHandle := FCreate(cFileName)
	IF ptrHandle = F_ERROR 
		fileerror:=DosErrString(FError() )
		oFileSpec:=FileSpec{cFileName}
		MyFileName:=oFileSpec:FileName+oFileSpec:Extension
		MyPath:=StrTran(oFileSpec:FullPath,MyFileName)
		oTextBox:=TextBox{oOwner,cDescription,"Could not create file "+MyFileName+" at "+MyPath+CRLF+"; Error:"+fileerror,;
		BUTTONRETRYCANCEL}
		nReturn:=oTextBox:Show()
		IF nReturn== BOXREPLYRETRY	
			oFileDialog := SaveAsDialog{ oOwner, cFileName  }
			oFileDialog:SetStyle(OFN_HIDEREADONLY)
			IF oFileDialog:Show()
				cFileName:=oFileDialog:FileName
				loop
			ELSE
				exit
			ENDIF
		ELSEIF nReturn==BOXREPLYCANCEL
			RETURN null_ptr
		ENDIF
	ELSE
		exit
	ENDIF
ENDDO
RETURN ptrHandle
DEFINE MASCULIN := 2
Function MLine4(cBuffer as string, ptrN ref DWORD ) as string
/******************************************************************************
// Extract a line of text from a string, specifying a required offset argument. 
// Identical to MLine3 except that LF is sufficient to seprate lines
/******************************************************************************/
Local cLine as string 
Local iEnd as int
iEnd:=At3(LF,cBuffer,ptrN+1)
if Empty(iEnd)
	ptrN:=0
else
	ptrN++
	cLine:= SubStr(cBuffer,ptrN,iEnd-ptrN)
	ptrN:=iEnd
endif	
return cLine 
FUNCTION Mod10(cGetal)
// Calculate modulo 10 (Luhn algoritme) check digit for cGetal and return it
LOCAL alt:=true as LOGIC
LOCAL i, length:=Len(cGetal),modulo,sum,temp as int

	FOR i:=length DOWNTO 1 step 1
		IF alt
			temp := Val(SubStr(cGetal,i,1))*2
			IF temp > 9
				temp:= temp - 9
			ENDIF
			sum += temp
		ELSE
			sum += Val(SubStr(cGetal,i,1))
		ENDIF
		alt := !alt
	NEXT
    modulo := sum % 10
	IF(modulo > 0)
		RETURN Str(10 - modulo,1,0)
	ELSE
		RETURN "0"
	ENDIF
FUNCTION Mod11(cGetal as string) as string
* Calculates modulo check digit for a number (e.g.Betalingskenmerk):
LOCAL aGew:={10,5,8,4,2,1,6,3,7,9}
LOCAL nL,i, nCheck as int
nL:=Len(cGetal)
if nL<13
	cGetal:=Str(Mod(nL,10),1)
endif
FOR i:=1 to nL
	nCheck:=nCheck+Val(SubStr(cGetal,i,1))*aGew[Mod(i-1,10)+1]
NEXT
nCheck:=11-Mod(nCheck,11)
if nCheck==10
	nCheck:=1
elseif nCheck==11
	nCheck:=0
endif
RETURN Str(nCheck,1)+cGetal
FUNCTION Modulus11(cGetal)
* Calculates modulo 11 check digit for Norwegian Social Security Number:
/*
The Norwegian eleven digit birth number is assigned at birth or registration with the National Population Register. 
It is composed of the date of birth (DDMMYY), a three digit individual number, and two check digits. 
The individual number and the check digits are collectively known as the personal number. 
The first check digit is calculated as follows: 
	11 minus the weighted sum modulo 11 of the nine first digits. if the result is 10, the number is invalid and is discarded. 
	if the result is 11, 0 is taken to be the check digit. 
	The last check digit is calculated in a similar manner: 11 minus the weighted sum modulo 11 of the ten first digits 
	(including the first check digit). 
	The weights for the first check digit are 3, 7, 6, 1, 8, 9, 4, 5, 2, 
	the weights for the second check digit are 5, 4, 3, 2, 7, 6, 5, 4, 3, 2.
*/
LOCAL aGew1:={3, 7, 6, 1, 8, 9, 4, 5, 2}, aGew2:={5, 4, 3, 2, 7, 6} as array
LOCAL nL,i, nCheck1, nCheck2 as int
nL:=Len(cGetal)
FOR i:=1 to nL
	nCheck1+=Val(SubStr(cGetal,i,1))*aGew1[Mod(i-1,9)+1]
	nCheck2+=Val(SubStr(cGetal,i,1))*aGew2[Mod(i-1,6)+1]
NEXT
nCheck1:=11-Mod(nCheck1,11)
IF nCheck1=10
	RETURN false
elseIF nCheck1=11
	nCheck1:=0
ENDIF
nCheck2+=nCheck1*aGew2[Mod(i-1,6)+1]
nCheck2:=11-Mod(nCheck2,11)
IF nCheck2=10
	RETURN false
elseIF nCheck2=11
	nCheck2:=0
ENDIF
return Str(nCheck1,1)+Str(nCheck2,1)

FUNCTION MonthEnd (f_month as int, f_year as int) as int
* get last day of given month 
LOCAL f_day := 31 as int
IF f_month == 4 .or. f_month == 6 .or. f_month == 9 .or. f_month == 11
   f_day := 30
ENDIF
IF f_month == 2
   IF (f_year % 4) == 0
      f_day := 29
   ELSE
      f_day := 28
   ENDIF
ENDIF
RETURN f_day
FUNCTION MyError(oError as Error,SymMethod as symbol)
LOCAL cMessage as STRING
// 	IF oError:Canretry .and.oError:Subcode==1101
	IF oError:Subcode==1101
		IF !NoErrorMsg .and.oError:Canretry  
			if (TextBox{,oError:SubCodeText,oError:Filename+" in use by another window or user",BUTTONRETRYCANCEL+BOXICONEXCLAMATION}):Show()==BOXREPLYRETRY
				return true
			else
				Break
			endif
		elseif NoErrorMsg
			Return false
		else
			(TextBox{,oError:SubCodeText,oError:FileName+" in use by another window or user",BOXICONEXCLAMATION}):Show()
			Break			
		ENDIF
	ELSE
		cMessage:="Error: "+ErrString(oError:GenCode)
		IF !Empty(oError:SubCode)
			cMessage += DosErrString(oError:SubCode)
		ENDIF
		IF oError:ArgTypeReq <> 0 .and. oError:ArgTypeReq <> oError:ArgType
	        cMessage += ", Variabletype: "+TypeString(oError:ArgType)+ " requested type:" +TypeString(oError:ArgTypeReq)
	    ENDIF
        IF !oError:Operation == ""
			cMessage += ", Operation:"+oError:Operation
		ENDIF
		cMessage += ", Function:"+Symbol2String(oError:FuncSym)+;
        ", Calling function: "+Symbol2String(oError:CallFuncSym)

		IF oError:ArgNum> 0 .and. oError:ArgNum <= ALen(oError:Args)
			cMessage += ", Argument nbr:"+Str(oError:ArgNum)+" ="+AsString(oError:Args[oError:ArgNum])
		ENDIF
        IF !oError:Description == ""
			cMessage += ", error:" + oError:Description
		ENDIF
		IF oError:MethodSelf <> null_object
			cMessage += ", OBJECT: "+AsString(oError:MethodSelf)
		ENDIF
		(ErrorBox{,CMessage}):Show()
	ENDIF
	IF oError:Severity==ES_CATASTROPHIC	
		_Break(oError)
	ENDIF
RETURN FALSE
CLASS MyFile
PROTECT cBuffer as STRING
PROTECT cDelim as STRING
PROTECT nStart:=0, nIncr:=0 as int
PROTECT ptrHandle
METHOD Close CLASS MyFile
	FClose(ptrHandle)
	ptrHandle:=null_object
RETURN



	
	
		
METHOD FReadLine() CLASS MyFile
	LOCAL nSt,nLen,nPos:=0 as int
	LOCAL cLine:="" as STRING
	nPos:=At3(cDelim, cBuffer,nStart)
	IF nPos==0
		* read next buffer:
		cLine:=SubStr(cBuffer,nStart+1)
	   cBuffer:=FReadStr(ptrHandle,4096)
		IF Empty(cBuffer)
			RETURN null_string
		ENDIF
		nStart:=0
		nPos:=At3(cDelim, cBuffer,nStart)
		IF nPos==0
			RETURN null_string
		ENDIF
	ENDIF
	nSt:=nStart+1
	nLen:=nPos-nStart-1
	nStart:=nPos+nIncr
	RETURN cLine+SubStr(cBuffer,nSt,nLen)
METHOD Init(oFr) CLASS MyFile
	ptrHandle:=FOpen2(oFr:FullPath,FO_READ + FO_SHARED)
	IF ptrHandle = F_ERROR
		(ErrorBox{,"Could not open file: "+oFr:FullPath+"; Error:("+Str(FError(),-1)+")"+DosErrString(FError())+iif(NetErr(),"; used by someone else","")}):Show()
		RETURN self
	ENDIF
   cBuffer:=FReadStr(ptrHandle,4096)
	IF ptrHandle = F_ERROR.or.(cBuffer==null_string .and.FEof(ptrHandle))
		(ErrorBox{,"Could not read file: "+oFr:FullPath+"; Error:("+Str(FError(),-1)+")"+DosErrString(FError())+iif(NetErr(),"; used by someone else","")}):Show()
		RETURN self
	ENDIF
	IF CHR(13)+CHR(10) $ cBuffer
		cDelim:=CHR(13)+CHR(10)
		nIncr:=1
	ELSE
		cDelim:=CHR(10)
	ENDIF
	RETURN self
CLASS MyFileSpec INHERIT Filespec
	PROTECT ptrHandle as ptr
METHOD DELETE() CLASS MyFileSpec
	LOCAL nwSize as USUAL
nwSize := FChSize(ptrHandle, 0)
IF nwSize != F_ERROR
	IF FClose(ptrHandle)
		RETURN SUPER:DELETE()
	ENDIF
ENDIF
RETURN FALSE
	
METHOD FileLock() CLASS MyFileSpec
	* Lock the file specified by the filespec exclusive
	ptrHandle := FOpen2(self:FullPath,FO_READ + FO_SHARED)
	IF ptrHandle = F_ERROR
		RETURN FALSE
	ENDIF
	IF !FFLock(ptrHandle,self:Size+6153,1)  // guaranteed two blocks further
		FClose(ptrHandle)
		ptrHandle:=null_ptr
		RETURN FALSE
	ENDIF
    RETURN true
function NetGetConnection(fullpathname as string) as string  
	// get the UNC from mapped path
	LOCAL lpzUNCName:=Space(129) as psz
	LOCAL UNCName as STRING
	LOCAL nLen:=128 as DWORD
	local nError,nPosColon as int
	nPosColon:=At(":",fullpathname) 
	if nPosColon>0
		IF (nError:=WNetGetConnection(SubStr(fullpathname,1,nPosColon),lpzUNCName,@nLen))==NO_ERROR
			UNCName:=AllTrim(Psz2String(lpzUNCName))
		ENDIF
	endif
	RETURN UNCName
	
CLASS OptionBrowser INHERIT DataBrowser
		
METHOD CellDoubleClick() CLASS OptionBrowser
	self:Owner:ViewForm()
	RETURN nil
DEFINE ORGANISATION := 4
function PersonUnion(id1 as string, id2 as string)
	/* unify two persons id1 and id2 to one id1
	this means:
	1. transfer all transactions of id2 to id1
	2. transfer all subscriptions from id2 to id1
	3. transfer all due amounts from id2 to id1 
	4. transfer all givers/creditors in standing orders from id2 to id1
	5. members?? not allowed 
	*/ 
	Local oPers1,oPers2,oTrans,oSel as SQLSelect
	LOCAL oXMLDocPrs2,oXMLDocPrs1 as XMLDocument 
	local ChildName, cValue as string, recordfound, lSuccess as logic 	
	local oStmt as SQLStatement 
	local cAccId as string
	local cStatement as string 
	local cError as string 
	local aTrTable:={} as array
	local i,nTrans as int


	// transactions:
	// 	cStatement:=UnionTrans("select persid,transid,seqnr from transaction t where t.dat>='"+SQLdate(Today()+80)+"' and persid="+id2)
	// 	oTrans:=SQLSelect{cStatement,oConn}
	// 	if oTrans:RecCount>0  
	// 		do while !oTrans:EOF 
	// 			oTrans:persid:=id1 
	// 			oTrans:Skip()
	// 		enddo
	// 	endif 
	SQLStatement{"start transaction",oConn}:Execute()
	oStmt:=SQLStatement{'',oConn}
	// Unify persons self:
	oPers1:=SQLSelect{"select p.*,m.accid from person p left join member m on (m.persid=p.persid) where p.persid="+id1,oConn}
	oPers2:=SQLSelect{"select p.*,m.accid from person p left join member m on (m.persid=p.persid) where p.persid="+id2,oConn}

	if oPers1:RecCount<1 .or. oPers2:RecCount<1
		return false
	endif
	if !Empty( oPers1:accid) .and. !Empty( oPers2:accid)
		(ErrorBox{,"Not possible to unify two members"}):Show()
		return false
	endif
	oSel:=SQLSelect{"SELECT TABLE_NAME FROM information_schema.TABLES "+;
		"WHERE TABLE_SCHEMA = '"+dbname+"' and TABLE_NAME like 'tr%' order by TABLE_NAME",oConn}
	aTrTable:=oSel:getlookuptable(50, #table_name, #table_name) 
	for i:=1 to Len(aTrTable)
		oStmt:SQLString:="update "+aTrTable[i,1]+" set persid='"+id1+"' where persid="+id2
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
			exit
		elseif oSel:NumSuccessfulRows>0 
			nTrans+=oSel:NumSuccessfulRows
		endif
	next
	if Empty(cError)
		oStmt:SQLString:='update personbank set persid="'+id1+'" where persid="'+id2+'"'
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
		endif
	endif
	if Empty(cError)
		// givers/creditors within standing order:
		oStmt:SQLString:='UPDATE standingorder SET persid="'+id1+'" where persid="'+id2+'"'
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
		endif
	endif
	if Empty(cError)
		oStmt:SQLString:='UPDATE standingorderline SET creditor="'+id1+'" where creditor="'+id2+'"'
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
		endif
	endif
	if Empty(cError)
		oStmt:SQLString:='update subscription set personid="'+id1+'" where personid="'+id2+'"'
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
		endif
	endif
	if Empty(cError)
		// creditor within bankorders:
		oStmt:SQLString:='UPDATE bankorder SET idfrom="'+id1+'" where idfrom="'+id2+'"'
		oStmt:Execute()
		if !Empty(oStmt:status) 
			cError:=oStmt:ErrInfo:ErrorMessage
		endif
	endif

	if Empty(cError)
		cStatement:=""
		if (oPers1:gender==1.or.oPers1:gender==0) .and.oPers2:gender==2 .or.(oPers1:gender==2.or.oPers1:gender==0) .and.oPers2:gender==1 .or.oPers2:gender==3
			cStatement+=",gender=3" //couple
			if oPers1:gender==2
				if !Empty(oPers1:firstname) .and.!Empty(oPers2:firstname)
					cStatement+=",firstname='"+AddSlashes(oPers1:firstname)+"&"+AddSlashes(oPers2:firstname)+"'"
				endif
			elseif !Empty(oPers1:firstname) .and.!Empty(oPers2:firstname) .and.AllTrim(oPers1:firstname)<>AllTrim(oPers2:firstname)
				cStatement+=",firstname='"+AddSlashes(oPers1:firstname)+"&"+AddSlashes(oPers2:firstname)+"'" 
			elseif Empty(oPers1:firstname)
				cStatement+=",firstname='"+AddSlashes(oPers2:firstname)+"'"
			endif
		else
			if Empty(oPers1:firstname)
				cStatement+=",firstname='"+AddSlashes(oPers2:firstname)+"'"
			endif
		endif
		if Empty(oPers1:initials)
			cStatement+=",initials='"+oPers2:initials+"'"
		endif
		if Empty( oPers1:Title)
			cStatement+=",title="+Str(oPers2:Title,-1)
		endif
		if Empty( oPers1:telbusiness)
			cStatement+=",telbusiness='"+ oPers2:telbusiness+"'"
		endif
		if Empty( oPers1:telhome)
			cStatement+=",telhome='"+ oPers2:telhome+"'"
		endif
		if Empty( oPers1:MOBILE)
			cStatement+=",mobile='"+ oPers2:MOBILE+"'"
		endif
		if Empty( oPers1:FAX)
			cStatement+=",fax='"+ oPers2:FAX+"'"
		endif
		if Empty( oPers1:EMAIL)
			cStatement+=",email='"+ AddSlashes(oPers2:EMAIL)+"'"
		endif
		if Empty( oPers1:birthdate)
			cStatement+=",birthdate='"+ SQLdate(oPers2:birthdate)+"'"
		endif
		if !Empty(oPers2:remarks)
			cStatement+=",remarks=concat(remarks,' ','"+AddSlashes(oPers2:remarks)+"')"
		endif
		cStatement+=",mailingcodes='"+MakeCod(Split(oPers1:mailingcodes+" "+oPers2:mailingcodes))+"'"
		if Empty(oPers1:creationdate) .or.(!Empty(oPers2:creationdate) .and.oPers1:creationdate>oPers2:creationdate)
			cStatement+=",creationdate='"+SQLdate(oPers2:creationdate)+"'"
		endif
		if Empty(oPers1:alterdate) .or.oPers1:alterdate< oPers2:alterdate
			cStatement+=",alterdate='"+SQLdate(oPers2:alterdate)  +"'"
		endif
		if Empty(oPers1:datelastgift) .or.oPers1:datelastgift< oPers2:datelastgift
			cStatement+=",datelastgift='"+SQLdate(oPers2:datelastgift)  +"'"
		endif
		if Empty(oPers1:address) .and. Empty(oPers1:city)
			cStatement+=",address='"+AddSlashes(oPers2:address) +"'"
			cStatement+=",postalcode='"+oPers2:postalcode+"'"
			cStatement+=",city='"+AddSlashes(oPers2:city)  +"'"
			cStatement+=",country='"+ AddSlashes(oPers2:country)+"'" 
			cStatement+=",attention='"+AddSlashes(oPers2:attention) +"'"
		endif
		// extra properties:
		oXMLDocPrs2:=XMLDocument{oPers2:PROPEXTR}
		oXMLDocPrs1:=XMLDocument{oPers1:PROPEXTR} 
		if oXMLDocPrs2:GetElement("velden")
			recordfound:=oXMLDocPrs2:GetFirstChild()
			do while recordfound
				ChildName:=oXMLDocPrs2:ChildName
				cValue:=oXMLDocPrs2:ChildContent
				if oXMLDocPrs1:GetElement(ChildName)
					if Empty(oXMLDocPrs1:GetContentCurrentElement())
						oXMLDocPrs1:UpdateContentCurrentElement(cValue)
					endif
				else
					oXMLDocPrs1:AddElement(ChildName,cValue,"velden")
				endif
				recordfound:=oXMLDocPrs2:GetNextChild()			
			ENDDO
			cStatement+=",propextr='"+ AddSlashes(oXMLDocPrs1:GetBuffer()) +"'"
		endif
		if !Empty(oPers2:accid)
			// connect member to Id1:
			cStatement+=",type="+Str(oPers2:type,-1)
		endif
		oStmt:=SQLStatement{"update person set "+SubStr(cStatement,2)+" where persid='"+id1+"'",oConn}
		oStmt:Execute()
		if !Empty(oStmt:status)
			cError:=oStmt:ErrInfo:ErrorMessage 
		endif
		if Empty(cError)
			if !Empty(oPers2:accid) 
				oStmt:=SQLStatement{"update member set persid="+id1+" where persid="+id2,oConn}:Execute()
				if oStmt:NumSuccessfulRows>0 
					oStmt:=SQLStatement{"update account set description='"+GetFullName(id1)+" where accid="+Str(oPers2:accid,-1),oConn}:Execute() 
				endif
			endif 
			
			// update employee if applicable
			SQLStatement{"update employee set persid='"+Crypt_Emp(true,"persid",id1)+"' where persid='"+Crypt_Emp(true,"persid",id2)+"'",oConn}:Execute()
			// delete person id2:
			SQLStatement{"delete from person where persid="+id2,oConn}:Execute() 
			SQLStatement{"commit",oConn}:Execute()
		endif
	endif
	if !Empty(cError)
		SQLStatement{"rollback",oConn}:Execute() 
		ErrorBox{,"could not merge persons: "+cError}:Show()
		return false
	endif
   TextBox{,"Person merge","Person merged"}:Show()
	return true
Function PersTypeValue(abrv as string) as string
// get id of person type with abbriviation abrv
local iPtr as int
iPtr:=AScan(pers_types_abrv,{|x|x[1]=abrv})
if iPtr>0
	return Str(pers_types_abrv[iPtr,2],-1)
else
	return "1"
endif
CLASS ProgressPer INHERIT DIALOGWINDOW 

	PROTECT oDCProgressBar AS PROGRESSBAR

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
   PROTECT oServer as OBJECT
RESOURCE ProgressPer DIALOGEX  5, 17, 263, 34
STYLE	DS_3DLOOK|WS_POPUP|WS_CAPTION|WS_SYSMENU
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	" ", PROGRESSPER_PROGRESSBAR, "msctls_progress32", PBS_SMOOTH|WS_CHILD, 44, 11, 190, 12
END

METHOD AdvancePro(iAdv) CLASS ProgressPer
	ApplicationExec( EXECWHILEEVENT ) 	// This is add to allow closing of the dialogwindow
										// while processing.
	 self:oDCProgressBar:Advance(iAdv)
	RETURN true
METHOD Close(oEvent) CLASS ProgressPer
	SUPER:Close(oEvent)
	//Put your changes here
	RETURN nil
METHOD Init(oParent,uExtra) CLASS ProgressPer 
LOCAL DIM aBrushes[1] AS OBJECT

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"ProgressPer",_GetInst()},FALSE)

aBrushes[1] := Brush{Color{COLORWHITE}}

oDCProgressBar := ProgressBar{SELF,ResourceID{PROGRESSPER_PROGRESSBAR,_GetInst()}}
oDCProgressBar:Range := Range{1,}
oDCProgressBar:HyperLabel := HyperLabel{#ProgressBar,NULL_STRING,NULL_STRING,NULL_STRING}
oDCProgressBar:BackgroundColor := Color{COLORWHITE}

SELF:Caption := ""
SELF:BackGround := aBrushes[1]
SELF:HyperLabel := HyperLabel{#ProgressPer,NULL_STRING,NULL_STRING,NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD PostInit(oParent,uExtra) CLASS ProgressPer
	//Put your PostInit additions here
	oServer:=uExtra
	RETURN nil
METHOD SetRange(nMin,nMax) CLASS ProgressPer
self:oDCProgressBar:Range:=Range{nMin,nMax}
RETURN true
METHOD SetUnit(nUnit) CLASS ProgressPer
self:oDCProgressBar:UnitSize:=1
RETURN true
STATIC DEFINE PROGRESSPER_PROGRESSBAR := 100 
FUNCTION RandSpace(cString as STRING) as STRING
	* Insert random number of leading spaces to a string:
	LOCAL cConv as STRING
	LOCAL nI as int

	cConv:=AllTrim(cString)
	IF (nI:=(Len(cString)-Len(cConv)))>0
		nI:=Round(Rand(0)*nI,0)
		IF nI>0
			cString:=Pad(Space(nI)+cConv,Len(cString))
		ENDIF
	ENDIF
RETURN cString
FUNC ShowError( oSQLErrorInfo as USUAL)    as void PASCAL

	LOCAL cMsg as STRING

    IF oSQLErrorInfo != nil

  	  IF IsInstanceOf( oSQLErrorInfo, #SQLErrorInfo )
	     MessageBox( 0, oSQLErrorInfo:ErrorMessage,	       ;
		 	  	  oSQLErrorInfo:SQLState, MB_ICONINFORMATION)
	  ELSE
		cMsg := "Subsys: " + AsString(oSQLErrorInfo:Subsystem) +  CRLF
        cMsg += "MethodSelf: " + AsString(oSQLErrorInfo:MethodSelf) + CRLF
        cMsg += "FuncSym: " + AsString(oSQLErrorInfo:FuncSym) + CRLF
		cMsg += "CallFuncSym: " + AsString(oSQLErrorInfo:CallFuncSym) + CRLF
		MessageBox( 0, String2Psz(cMsg), String2Psz(oSQLErrorInfo:Description), MB_ICONINFORMATION)
	  ENDIF
    ENDIF

RETURN
method SetWidth(w) class SingleLineEdit
LOCAL myDim as Dimension
	myDim:=self:Size
	myDim:Width:=w
	self:Size:=myDim
 return
FUNCTION Split(cTarget:="" as string,cSep:=' ' as string) as array
	* Split string cTarget into array, seperated by cSep
	LOCAL nIncr as int
	LOCAL aToken:={} as ARRAY
	LOCAL cSearch as STRING
	LOCAL nStart, nPos, nEnd as int
	if !Empty(cTarget)
		nEnd:=Len(cTarget)
		IF SubStr(cTarget,1,1)=='"' .and. SubStr(cTarget,nEnd,1)=='"'
			* apparently CSV-file:
			cSearch:='"'+cSep+'"'
			nStart:=1
			nEnd--
		ELSE
			nStart:=0
			cSearch:=cSep
		ENDIF
		nIncr:=Len(cSearch)-1
		DO WHILE true
			nPos:=At3(cSearch, cTarget,nStart)
			IF nPos==0
				exit
			ENDIF
			AAdd(aToken,Compress(StrTran(SubStr(cTarget,nStart+1,nPos-nStart-1),CHR(160),Space(1))))      // replace non-breaking space by space
			nStart:=nPos+nIncr
		ENDDO
		AAdd(aToken,SubStr(cTarget,nStart+1,nEnd-nStart)) 
	endif
	RETURN aToken
function SQLdate(dat as date) as string
// convert date to sql string format:
local Rdat:=DToS(dat) as string
return substr(Rdat,1,4)+"-"+substr(Rdat,5,2)+"-"+substr(Rdat,7,2)
function SQLDate2Date(sqldat as string) as date
return SToD(StrTran(sqldat,"-",""))
Function SQLGetMyConnection()
return oConn
Method Locate(ForCondition) class SQLTable
// implement locate method like for DBServer
// position table on first occurrence which satisfies ForCondition  
self:GoTop()
Do while !self:EoF .and.!Eval(CODEBLOCK(_cast,ForCondition))
	self:Skip()
enddo
return !self:EoF
METHOD RefreshClients() CLASS SQLTable
LOCAL i as int
FOR i:=1 to self:nClients
	IF IsMethod(self:aClients[i],#refresh)
		self:aClients[i]:refresh()
	ENDIF
NEXT
method SetFilter(cbFilterBlock ,cFilterText ) class SQLTable
local cFilter as string
Default(@cbFilterBlock,null_codeblock) 
Default(@cFilterText,null_string) 
if Empty(cFilterText)
	if IsString(cbFilterBlock)
		cFilterText:=cbFilterBlock
	endif
endif
self:Where(cFilterText) 
return true
DEFINE TEXTBX:=0
FUNCTION ValidateControls( oDW, aControls )

	LOCAL i as word
	LOCAL oCurrentControl as Control
	
	FOR i := 1 to Len( aControls )

		oCurrentControl := aControls[ i ]	
		IF !oCurrentControl:PerformValidations()
			(ErrorBox{,oCurrentControl:Name+": "+Transform(oCurrentControl:Status,"")}):Show()			
			// Set focus to invalid control
			oCurrentControl:SetFocus()
			exit
		ENDIF
	NEXT	

	RETURN i > Len( aControls )
Method Reset() class Window 
	Local aChilds as array, i as int, cName as symbol , oContr as Control, cCaption as string
	aChilds:=self:GetAllChildren() 
	for i:=1 to Len(aChilds)
		cName:=ClassName(aChilds[i])
		if cName==#SINGLELINEEDIT .or. cName==#COMBOBOX .or. cName==#MULTILINEEDIT .or. cName==#LISTBOX
			oContr:=aChilds[i] 
			oContr:TextValue:=null_string
		endif
	next
	return
Method SetTexts() class Window 
	Local aChilds as array, i as int, cName as symbol , oContr as Control, cCaption as string
	local oWLan as Language
	if self:oLan==null_object
		self:oLan:=Language{}
	endif 
	oWLan:=self:oLan
	aChilds:=self:GetAllChildren() 
	for i:=1 to Len(aChilds)
		cName:=ClassName(aChilds[i])
		if cName==#FIXEDTEXT .or. cName==#PUSHBUTTON .or. cName==#GROUPBOX  .or. cName=#RADIOBUTTON .or. cName=#RADIOBUTTONGROUP.or. cName=#CHECKBOX
			oContr:=aChilds[i] 
			cCaption:=oContr:Caption
			if Len(cCaption)>1
				if Right(cCaption,1)==":"
					oContr:Caption:=oWLan:WGet(SubStr(cCaption,1,Len(cCaption)-1))+":"
				else
					oContr:Caption:=oWLan:WGet(cCaption)
				endif								
			endif 
		endif
	next
	self:Caption:=oWLan:WGet(self:Caption)
	return
CLASS WorkDayDate inherit DateStandard
 Method ParentNotify(nNotifyCode, lParam) class WorkDayDate
		if DoW(self:SelectedDate)=1       // not on sunday
			self:SelectedDate++
		elseif DoW(self:SelectedDate)=7   // not on saturday
			self:SelectedDate+=2
		endif
 return 1
 FUNCTION Yield() as LOGIC

	ApplicationExec(EXECWHILEEVENT)
	
RETURN true	




FUNCTION ZeroRTrim(m_str as string) as string
// right trim zeroes from a decimal string
Local commaPos,length as int, DecSep as string 
m_str:=AllTrim(m_str)
DecSep:=CHR(SetDecimalSep())

commaPos:=At(DecSep,m_str)
if commaPos>0
	length:=Len(m_str)
	do WHILE SubStr(m_str,length,1)=="0"
		length-- 
	ENDDO
   m_str:=SubStr(m_str,1,Max(commaPos+1,length))
endif
RETURN m_str
FUNCTION ZeroTrim(m_str as string) as string
// left trim leading zeroes from a string 
m_str:=AllTrim(m_str)
DO WHILE SubStr(m_str,1,1)=="0" 
	m_str:=SubStr(m_str,2)
ENDDO
RETURN m_str
