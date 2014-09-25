FUNCTION AcceptNorway(oRep,nRow,nPage,oLan,fTotal,invoicenbr,oPers,Destination,INVOICEID)
// printing of acceptgiro part in Norwegian format:
LOCAL oReport:=oRep as PrintDialog
LOCAL cCodeline as STRING

Default(@Destination,null_string)
Default(@InvoiceID,null_string)
	DO WHILE nRow < 40
		oReport:PrintLine(@nRow,@nPage,'',{},0)
	ENDDO
	oReport:PrintLine(@nRow,@nPage,Space(34)+Str(fTotal,8,DecAantal),{})
	oReport:PrintLine(@nRow,@nPage,'',{},0)
	oReport:PrintLine(@nRow,@nPage,'',{})
	oReport:PrintLine(@nRow,@nPage,'',{})
	oReport:PrintLine(@nRow,@nPage,Space(5)+oLan:Rget('Invoice number',,"!")+': '+invoicenbr,{})
	oReport:PrintLine(@nRow,@nPage,Space(5)+AllTrim(Destination),{})
	oReport:PrintLine(@nRow,@nPage,'',{})
	oReport:PrintLine(@nRow,@nPage,'',{})
	oReport:PrintLine(@nRow,@nPage,'',{})
	oReport:PrintLine(@nRow,@nPage,'',{})
	oReport:PrintLine(@nRow,@nPage,'',{})
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad("Wycliffe",41)+ oPers:md_address1,{})
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad("POSTBOKS 6625 ST. OLAVS PLASS ",41)+ oPers:md_address2,{})
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad("0129 Oslo",41)+ oPers:md_address3,{})
	oReport:PrintLine(@nRow,@nPage,Space(47)+ oPers:md_address4,{})
	oReport:PrintLine(@nRow,@nPage,'',{})
	oReport:PrintLine(@nRow,@nPage,'',{})
	oReport:PrintLine(@nRow,@nPage,'',{})
	oReport:PrintLine(@nRow,@nPage,'',{})
	IF oReport:Destination == "Printer"
		AAdd(oReport:oPrintJob:aFIFO,ACCEPT_START)
	ENDIF

//	oReport:PrintLine(@nRow,@nPage,' ')
	IF Empty(InvoiceID)
		cCodeline:=Pad(Space(17)+ oPers:banknumber,33)
	ELSE
		cCodeLine:=Pad(Space(17)+ AllTrim(InvoiceID),33)
	ENDIF
	cCodeline+=Str(fTotal,6,0)+Space(4)+StrZero((fTotal*100)%100,2,0)+Space(4)+Mod10(AllTrim(Str(fTotal*100,,0)))+Space(5)+BANKNBRDEB
	oReport:PrintLine(@nRow,@nPage,cCodeline,{})
		
	RETURN
CLASS AmountGift INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS AmountGift
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#AmountGift, "Amount Gift", "Amount of Gift", "" },  "C", 20, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




class  BankAcc  
	protect oPrsBnk as SQLSelect 
	declare method BankAcc
method BankAcc(persid as int) as string class BankAcc
	if !Empty(persid) 
		self:oPrsBnk:Execute(persid)
		IF !self:oPrsBnk:EOF
			// return first bankaccount of person
			RETURN AllTrim(self:oPrsBnk:banknumber)
		endif
	endif
	RETURN null_string
method Init() class BankAcc
	self:oPrsBnk:=SQLSelect{"Select banknumber from personbank where persid=?",oConn}
	return self
CLASS DateGift INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS DateGift
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#dat, "Date Gift", "Date of Gift", "" },  "C", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Destination INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Destination
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#description, "Destination Gift", "Destination Gift", "" },  "C", 40, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




	method FillBankNbr(aBankNbr,cDescr,i) class EditPerson  
	if AScan(self:aBankAcc,{|x|x[1]==aBankNbr[1]})==0  // not yet stored?
		IF Empty(self:oDCmbankNumber:VALUE)
			self:oDCmbankNumber:VALUE:=aBankNbr[1]
			self:oDCSC_BankNumber:TextValue:=cDescr+Str(1,1)
			self:mBic:=aBankNbr[2] 
			ASize(self:aBankAcc,Len(self:aBankAcc)+1)
			AIns(self:aBankAcc,1)   // insert at top
			self:aBankAcc[1]:={aBankNbr[1],aBankNbr[2]} 
			ASize(self:OrigaBank,Len(self:OrigaBank)+1)
			AIns(self:OrigaBank,1)
			self:OrigaBank[1]:=aBankNbr
			i--
		ELSE
			AAdd(self:aBankAcc,{aBankNbr[1],aBankNbr[2]})
			AAdd(self:OrigaBank,aBankNbr)
		endif
	ENDIF
	return i
	
METHOD Import(apMapping,Checked)  CLASS EditPerson
	* analyse mapping:
	lLastName:=(AScan(apMapping,{|x| x[1] == #mLastname})>0)		// Last name?
	lInitials:=(AScan(apMapping,{|x| x[1] == #mInitials})>0) //  initial field?
	lMiddleName:=(AScan(apMapping,{|x| x[1] == #mPrefix})>0)     //  middle name?
	lSalutation:=(AScan(apMapping,{|x| x[1] == #mTitle})>0)    //  salutation?
	lAddress:=(AScan(apMapping,{|x| x[1] == #mAddress})>0)    //  adress?
	lZipCode:=(AScan(apMapping,{|x| x[1] == #mPOStalcode})>0)    //  zipcode?
	lCity:=(AScan(apMapping,{|x| x[1] == #mCity})>0)    //  city?
	lExId:=(AScan(apMapping,{|x| x[1] == #mExternid})>0)    //  external id?
	lFirstName:=(AScan(apMapping,{|x| x[1] == #mFirstName})>0)    //  first name?
	IF Checked
		lImportAutomatic:=FALSE
		self:oImport:lImportAutomatic:=FALSE
	ENDIF
	self:oImport:Import(self)
	
METHOD InitExtraProperties() CLASS EditPerson
	// Initialize extra properties
	LOCAL count AS INT
	LOCAL left:=true as LOGIC
	if self:lExtraInitialised
		return nil
	endif
	self:lExtraInitialised:=true

	FOR count:=1 TO Len(pers_propextra) STEP 1
		SELF:SetPropExtra(count,left)
		left:=!left
	NEXT
RETURN NIL
METHOD MatchImport(synctype) CLASS EditPerson 
	* Import of a person from import file with match existing person in database
	* synctype:
	* 	1=replace current values with values from import
	*	2=keep current values
	*
	LOCAL oPers:=self:Server as SQLSelect
	LOCAL searchname, cSur, cA1, cPA,cVA,cVP as STRING
	LOCAL LencPA AS INT
	LOCAL ntus as int
	LOCAL first, lUnique, lDupl as LOGIC
	LOCAL stRec AS DWORD
	LOCAL aCodsBrev:={}, aMailCodes:={} AS ARRAY

	// search import name within persons:
	* First find with NAW:
	oPers:m51_pos:=AllTrim(SELF:mPOS)
	oPers:m51_ad1:=AllTrim(self:mAddress)
	oPers:m51_firstname:=AllTrim(self:mFirstname)
	lDupl:=FALSE
	lUnique:=oPers:FindPers(self:mLastname,true)
	IF !oPers:EoF
		IF lUnique
			SELF:Sync(synctype)
	        RETURN TRUE
		ELSE
			lDupl:=TRUE
		ENDIF
    ENDIF
	// try via address and name:
	oPers:SetOrder("ASSADR")
	searchname:=AllTrim(Upper(SubStr(self:mAddress,1,7))+Upper(SubStr(self:mLastname,1,3))+self:mPOS)
	oPers:Seek(searchname)
	first:=TRUE
	stRec:=oPers:RecNo
	ntus:=0
	DO WHILE !oPers:EoF .and. AllTrim(Upper(SubStr(oPers:address,1,7))+Upper(SubStr(oPers:lastname,1,3))+Str(Val(oPers:postalcode),4,0))== searchname
		ntus++
		cPA:=AllTrim(StrTran(StrTran(Upper(oPers:lastname),",",""),".",""))
		LencPA:=Len(cPA)
		cA1:=SubStr(StrTran(StrTran(Upper(self:mLastname),",",""),".",""),1,LencPA)
		IF (cPA==cA1  )
			cVP:=AllTrim(Compress(StrTran(StrTran(StrTran(StrTran(StrTran(Upper(oPers:firstname),",",""),".","")," OG "," "),"&",""),"-"," ")))
			LencPA:=Len(cVP)
			cVA:=SubStr(AllTrim(Compress(StrTran(StrTran(StrTran(StrTran(StrTran(Upper(self:mFirstname),",",""),".","")," OG "," "),"&",""),"-"," "))),1,LencPA)
			IF First
				IF cVa==cVP
					SELF:Sync(synctype)
					RETURN TRUE
				ENDIF
			ELSE
				IF SoundEx(cVA)==SoundEx(cVP)
					SELF:Sync(synctype)
					RETURN TRUE
				ENDIF
			ENDIF
		ENDIF
		oPers:Skip()
		IF first .and. (oPers:EoF .or. AllTrim(SubStr(oPers:postalcode,1,4)+Upper(SubStr(oPers:address,1,7))+Upper(SubStr(oPers:lastname,1,3)))<>searchname)
			IF ntus>1
				first:=FALSE
				oPers:goto(stRec)
			ENDIF
		ENDIF
	ENDDO
	oPers:SetOrder("ASSNA")
	// search import name within persons:
	searchname:=AllTrim(Upper(SubStr(cSur,1,14)))

	oPers:Seek(searchname)
	first:=TRUE
	stRec:=oPers:RecNo
	ntus:=0
	DO WHILE !oPers:EOF .and.  Upper(AllTrim(SubStr(oPers:lastname,1,14)))== searchname
		ntus++
		cPA:=AllTrim(StrTran(StrTran(Upper(oPers:address),",",""),".",""))
		LencPA:=Len(cPA)
		cA1:=SubStr(StrTran(StrTran(Upper(self:mAddress),",",""),".",""),1,LencPA)
		IF (cPA==cA1 .or.SoundEx(cPA)=SoundEx(cA1)) .and. Val(oPers:postalcode)==Val(self:mPos)
			cVP:=AllTrim(Compress(StrTran(StrTran(StrTran(StrTran(StrTran(Upper(oPers:firstname),",",""),".","")," OG "," "),"&",""),"-"," ")))
			LencPA:=Len(cVP)
			cVA:=SubStr(AllTrim(Compress(StrTran(StrTran(StrTran(StrTran(StrTran(Upper(self:mFirstname),",",""),".","")," OG "," "),"&",""),"-"," "))),1,LencPA)
			IF First
				IF cVa==cVP
					SELF:Sync(synctype)
					RETURN TRUE
				ELSE
					IF SoundEx(cVA)==SoundEx(cVP)
						SELF:Sync(synctype)
						RETURN TRUE
					ENDIF
				ENDIF
			ENDIF
			oPers:Skip()
			IF first .and. (oPers:EOF .or.  Upper(AllTrim(SubStr(oPers:lastname,1,14)))<>searchname)
				IF ntus>1
					first:=FALSE
					oPers:goto(stRec)
				ENDIF
			ENDIF
		ENDIF
	ENDDO

// add person:
RETURN FALSE

METHOD SetPropExtra( count, Left) CLASS EditPerson 
	LOCAL oSingle as SingleLineEdit
	LOCAL oCheck as CheckBox
	LOCAL oDropDown as COMBOBOX
	LOCAL oFix as FixedText
	LOCAL Name as STRING,nType, ID as int, Values as STRING
	LOCAL myDim as Dimension
	LOCAL myOrg as Point
	LOCAL aValues as ARRAY
	LOCAL EditX:=152, FixX:=17 as int
	Default(@left,true)
	Name:=pers_propextra[count,1]
	nType:=pers_propextra[count,3]
	Values:=pers_propextra[count,4]
	ID := pers_propextra[count,2]
	IF left
		//
		// enlarge window
		myDim:=self:Size
		myDim:Height+=25
		self:Size:=myDim
		myOrg:=self:Origin
		myOrg:y-=25
		self:Origin:=myOrg
		//
		// shift systemgroup down
		myOrg:=self:oDCmAlterDate:Origin
		myOrg:y-=25
		self:oDCmAlterDate:Origin:=myOrg
		myOrg:=self:oDCmCreationDate:Origin
		myOrg:y-=25
		self:oDCmCreationDate:Origin:=myOrg
		myOrg:=self:oDCmDateLastGift:Origin
		myOrg:y-=25
		self:oDCmDateLastGift:Origin:=myOrg
		myOrg:=self:oDCmOPC:Origin
		myOrg:y-=25
		self:oDCmOPC:Origin:=myOrg
		myOrg:=self:oDCmPersId:Origin
		myOrg:y-=25
		self:oDCmPersId:Origin:=myOrg
		myOrg:=self:oDCmExternId:Origin
		myOrg:y-=25
		self:oDCmExternId:Origin:=myOrg
		myOrg:=self:oDCGroupBoxSystem:Origin
		myOrg:y-=25
		self:oDCGroupBoxSystem:Origin:=myOrg
		myOrg:=self:oDCSC_BDAT:Origin
		myOrg:y-=25
		self:oDCSC_BDAT:Origin:=myOrg
		myOrg:=self:oDCSC_MUTD:Origin
		myOrg:y-=25
		self:oDCSC_MUTD:Origin:=myOrg
		myOrg:=self:oDCSC_DLG:Origin
		myOrg:y-=25
		self:oDCSC_DLG:Origin:=myOrg
		myOrg:=self:oDCSC_OPC:Origin
		myOrg:y-=25
		self:oDCSC_OPC:Origin:=myOrg
		myOrg:=self:oDCSC_CLN:Origin
		myOrg:y-=25
		self:oDCSC_CLN:Origin:=myOrg
		myOrg:=self:oDCSC_Externid:Origin
		myOrg:y-=25
		self:oDCSC_Externid:Origin:=myOrg
		// enlarge personal group:
		myDim:=self:oDCGroupBoxPersonal:Size
		myDim:Height+=25
		self:oDCGroupBoxPersonal:Size:=myDim
		myOrg:=self:oDCGroupBoxPersonal:Origin
		myOrg:y-=25
		self:oDCGroupBoxPersonal:Origin:=myOrg
	ELSE
		EditX:=511
		FixX:=376
		myOrg:=self:oDCGroupBoxPersonal:Origin
	ENDIF
	//
	//	insert extra properties in group personal:
	IF nType==TEXTBX
		oSingle:=SingleLineEdit{self,count,Point{EditX,myOrg:y+13},Dimension{215,20} }
		oSingle:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name+":"}
		oSingle:FocusSelect := FSEL_HOME
		oSingle:show()
		AAdd(self:aPropEx,oSingle)
	ELSEIF nType==CHECKBX
		oCheck:=CheckBox{self,count,Point{EditX,myOrg:y+13},Dimension{215,20},Name}
		oCheck:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name,Name}
		AAdd(self:aPropEx,oCheck)
		oCheck:show()
	ELSEIF nType==DROPDOWN
		oDropDown:=ComboBox{self,count,Point{EditX,myOrg:y-127},Dimension{215,160},BOXDROPDOWNLIST,CBS_SORT+CBS_LOWERCASE}
		oDropDown:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name,null_string,null_string}
		aValues:=Split(Values,",")
		oDropDown:FillUsing(aValues)
		AAdd(self:aPropEx,oDropDown)
		oDropDown:show() 
	ELSEIF nType==DATEFIELD
		oSingle:=SingleLineEdit{self,count,Point{EditX,myOrg:y+13},Dimension{215,20} }
		oSingle:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name+":"}
		oSingle:FocusSelect := FSEL_HOME
		oSingle:Picture:="@D"
		oSingle:FieldSpec:=PropExtra_Date{}
		oSingle:show()
		AAdd(self:aPropEx,oSingle)
	ENDIF
	IF nType#CHECKBX
		oFix:=FixedText{self,count,Point{FixX,myOrg:y+13}, Dimension{135,20},Name+":"}
		oFix:show()
	ENDIF
	RETURN nil
METHOD SetState() CLASS EditPerson 
	LOCAL i:=1,j, pos,posC as int
	LOCAL oPersBank as SQLSelect
	LOCAL oXMLDoc as XMLDocument
	LOCAL cDescr:="Bank# " as STRING
	local aBank:={} as array 
	local oContr as Control
	
	self:oPerson:=SQLSelect{ "select lastname,prefix,title,initials,firstname,nameext,attention,address,postalcode,city,"+;
		"country,telbusiness,telhome,fax,mobile,p.persid,mailingcodes,email,remarks,type,"+;
		"cast(alterdate as date) as alterdate,cast(creationdate as date) as creationdate,cast(datelastgift as date) as datelastgift,cast(birthdate as date) as birthdate,"+;
		"externid,gender,opc,propextr,p.`deleted` as removed,"+;
		"m.mbrid,m.accid,m.depid,group_concat(b.banknumber,'#$#',b.bic separator ',') as bankaccounts from person as p "+;
		"left join member m on (m.persid=p.persid) left join personbank b on (p.persid=b.persid) "+;
		"where "+iif(!Empty(self:oDCmPersid:TextValue),"p.persid="+self:oDCmPersid:TextValue,"p.externid='"+self:oDCmExternid:TextValue+"'")+" group by p.persid",oConn}
	self:oPerson:Execute()
	if !Empty(self:oPerson:Status)
		LogEvent(self,"can not read person, error:"+self:oPerson:errinfo:errormessage+CRLF+"statement:"+self:oPerson:SqlString,"logerrors")
		Break
	endif
	if Empty(self:oPerson:mbrid)
		self:RemoveMemberParms()
	else
		self:oDCmType:Disable()
	endif
	self:oDCmLastname:Value := self:oPerson:lastname
	self:ODCmPrefix:Value  := self:oPerson:prefix
	self:oDCmTitle:Value  := self:oPerson:Title
	self:oDCmInitials:Value  := self:oPerson:initials	
	self:oDCmFirstname:Value  := self:oPerson:firstname
	self:oDCmNameExt:Value  := self:oPerson:nameext
	self:oDCmAttention:Value  := self:oPerson:attention
	self:oDCmAddress:Value  := self:oPerson:address
	self:oDCmPOStalcode:Value  := StandardZip(self:oPerson:postalcode)
	self:ODCmCity:Value  := self:oPerson:city
	self:ODCmCountry:Value  := self:oPerson:country
	self:ODCmTELbusiness:Value  := self:oPerson:telbusiness
	self:oDCmTELhome:Value  := self:oPerson:telhome
	self:oDCmFAX:Value  := self:oPerson:FAX
	self:oDCmMobile:Value:= self:oPerson:Mobile
	self:oDCmPersid:Value  := self:oPerson:persid
	self:mCodInt   := AllTrim(string(_cast,self:oPerson:mailingcodes))
	self:oDCmbankNumber:Value := ""
	self:oDCmEmail:Value := self:oPerson:Email
	self:oDCmRemarks:Value := self:oPerson:remarks
	self:oDCmAlterDate:Value := self:oPerson:alterdate
	self:oDCmCreationDate:Value := self:oPerson:creationdate
	self:oDCmOPC:Value := ConS(self:oPerson:OPC)
	self:oDCmDateLastGift:Value := self:oPerson:datelastgift
	self:oDCmExternid:Value:= ZeroTrim(self:oPerson:EXTERNID)
	self:ODCmBirthDate:Value:=self:oPerson:birthdate
	self:oDCmGender:Value:=self:oPerson:GENDER
	self:oDCmType:Value:=self:oPerson:TYPE
	if ConL(self:oPerson:removed)
		self:oDCDeletedText:Show() 
		self:oCCOKButton:Hide() 
		self:oCCCancelButton:Hide()
		self:oCCDonationsButton:Hide() 
		self:oCCUndelete:Show()
	else
		self:oDCDeletedText:Hide()		
	endif
	
	// Fill extra properties: 
	oXMLDoc:=XMLDocument{self:oPerson:PROPEXTR}
	FOR i:=1 to Len(self:aPropEx) 
		IF oXMLDoc:GetElement(aPropEx[i]:Name)
			oContr:=  aPropEx[i]  
			if ClassName(oContr)=#SingleLineEdit .and.oContr:Picture='@D'
				aPropEx[i]:Value:=SToD(oXMLDoc:GetContentCurrentElement())
			else				
				aPropEx[i]:Value:=oXMLDoc:GetContentCurrentElement()
			endif
		ENDIF
	NEXT
	IF self:lAddressChanged
		IF !Empty(self:oPersCnt:m51_pos)
			self:oDCmPOStalcode:TextValue := StandardZip(self:oPersCnt:m51_pos)
		ENDIF
		IF !Empty(self:oPersCnt:m51_ad1)
			self:oDCmAddress:TextValue := self:oPersCnt:m51_ad1
		ENDIF
		IF !Empty(self:oPersCnt:m51_city)
			self:ODCmCity:TextValue := self:oPersCnt:m51_city
		ENDIF
	ENDIF

	* Fill aBankAcc:
	IF	CountryCode=="47"
		cDescr:="Bank/KID	"
	ENDIF
	if !Empty(self:oPerson:bankaccounts)
		AEval(Split(self:oPerson:bankaccounts,","),{|x|AAdd(aBank,Split(x,'#$#',,true))})
		self:aBankAcc:=ArrayNew(Len(aBank),2) 
		self:OrigaBank:=ArrayNew(Len(aBank),2) 
		ACopy(aBank,self:aBankAcc)
		ACopy(aBank,self:OrigaBank)
		self:mBankNumber:=aBank[1,1]
		self:mBic:=aBank[1,2]
	endif
	self:Curlastname:=self:oDCmLastname:TextValue
	self:curNa2:=self:oDCmInitials:TextValue
	self:curHisn:=self:ODCmPrefix:TextValue

	self:StateExtra() 
	
	RETURN nil
METHOD StateExtra() CLASS EditPerson
	LOCAL i,j:=0 as int
	LOCAL mCodH as string, aCod:={} as array
	if !self==null_object .and.!IsNil(self:mCodInt).and.!Empty(self:mCodInt).and. IsString(self:mCodInt)
		aCod:=Split(self:mCodInt,Space(1))
		FOR i:=1 to 10 
			mCodH:=""
			if i<=Len(aCod)
				mCodH  :=aCod[i]
			endif
			if Empty(mCodH).or.AScan(pers_codes,{|x|x[2]==mCodH})=0
				loop
			endif
			++j
			IVarPutSelf(self,String2Symbol("mCod"+AllTrim(Str(j,2))),mCodH) 
			
		NEXT
	endif
	
	RETURN
METHOD Sync(oPerson,oPersBank,oReport,oAddrs,type,kopregels,nRow,nPage,nver) CLASS EditPerson
// save kidnbr as bank account and telephone#, email, remarks and mailing codes
LOCAL cEml,cFax,cMob,cType, cTelex as STRING
LOCAL  oPers:=oPerson as SQLSelect
// keep original values?
	IF !Empty(oPerson:telbusiness)
		self:mTEL1:=oPerson:telbusiness
	ENDIF
	IF !Empty(cTelex).and.Empty(oPers:telbusiness)
		oPers:telbusiness:=cTelex
	ENDIF
	IF !Empty(cMob).and.Empty(oPers:MOBILE)
		oPers:MOBILE:=cMob
	ENDIF
	IF !Empty(cFax).and.Empty(oPers:FAX)
		oPers:FAX:=cFax
	ENDIF
	IF !Empty(cEml).and.Empty(oPers:EMAIL)
		oPers:EMAIL:=cEml
	ENDIF
	IF !Empty(cType).and.Empty(oPers:GENDER)
		IF cType=="couple"
			oPers:GENDER:=COUPLE
		ELSE
			oPers:GENDER:=0
		ENDIF
	ENDIF
	oPers:alterdate:=Today()
	RETURN
METHOD ValidatePerson() CLASS EditPerson
 	LOCAL lValid := true, lUnique as LOGIC
	LOCAL cError, cSelBank as STRING
	LOCAL i, nAnswer as int
	LOCAL oPers, oSel as SQLSelect
	LOCAL Housnbr as STRING
	
// 	if !lNew
// 		oPers:=SqlSelect{"select lastname,postalcode,firstname,address,externid,m.mbrid from person p left join member m on (m.persid=p.persid) where p.persid='"+self:mPersid+"'",oConn}
// 	endif
	IF lValid .and. Empty(self:mLastName)
		lValid:=FALSE
		cError:= self:oLan:WGet("Lastname is mandatory")+"!"
	ENDIF
	IF lValid .and. 'FI' $ self:mCodInt
		IF lValid .and. Empty(self:mDateLastGift)
 			lValid := FALSE
			cError := self:oLan:WGet("Mailing code")+" '" +GetMailDesc("FI") + "' "+self:oLan:WGet("not applicable before first gift")
        ENDIF
	ENDIF
	self:mLastName:=AllTrim(self:oDCmLastname:VALUE)
	self:mPostalcode:=StandardZip(AllTrim(self:oDCmPOStalcode:VALUE))
	self:mFirstname:=AllTrim(self:oDCmFirstname:VALUE)
	self:mAddress:=AllTrim(self:oDCmAddress:VALUE)
	IF lValid.and.(self:lNew.or. !AllTrim(self:mLastName) = ConS(self:oPerson:lastname) .or. ConS(self:oPerson:postalcode) # self:mPostalcode.or.ConS(self:oPerson:firstname) # self:mFirstname.or.ConS(self:oPerson:address) # self:mAddress.or. ZeroTrim(ConS(self:oPerson:EXTERNID)) # self:mExternid)
		* Check duplicate NAC:
		oSel:=SqlSelect{"select persid from person where deleted=0 and lastname='"+AddSlashes(self:mLastName)+"' and postalcode like '"+self:mPostalcode+"%' and (firstname='' or firstname like '"+self:mFirstname+"%') and address like '";
		+AddSlashes(self:mAddress)+"%'"+iif(self:lNew,""," and persid<>'"+self:mPersid+"'"),oConn}
		oSel:GoTop()
		IF oSel:RecCount>0
			Housnbr:=GetStreetHousnbr(self:mAddress)[2]
			nAnswer:=(TextBox{self, self:oLan:WGet("Edit Person"), self:oLan:WGet("Person")+" "+ConS(self:mLastName)+;
			IF(Empty(self:mPostalcode),""," - "+self:oLan:WGet("zip")+":"+self:mPostalcode) + ;
			IF(Empty(Housnbr),""," - "+self:oLan:WGet("house#")+":"+Housnbr) +; 
			iif(Empty(self:mExternid),"",' or with external id:'+ConS(self:mExternid))+;
			" "+self:oLan:WGet("already exist")+"! "+self:oLan:WGet("Save anyway")+"?",BUTTONYESNO+BOXICONQUESTIONMARK}):Show()
			IF nAnswer==BOXREPLYNO
				lValid := FALSE
			ENDIF
		ENDIF
		if lValid .and. !self:lNew .and. !Empty(self:oPerson:mbrid) .and.!AllTrim(self:mLastName) = ConS(self:oPerson:lastname)
			// check if new accountname already assigned;
			
		endif
		IF lValid .and.!Empty(ConS(self:mExternid))
			// check if no duplicate external id:
			oSel:SQLString:="select persid from person where deleted=0 and externid='"+ZeroTrim(ConS(self:mExternid))+"'"+iif(self:lNew,""," and persid<>'"+self:mPersid+"'")
			oSel:Execute()
			IF oSel:RecCount>0
				cError :=self:oLan:WGet("Person")+" "+GetFullName(Str(oSel:persid,-1),2)+" "+self:oLan:WGet("has already external id")+" "+self:mExternid+"!"
				self:oDCmExternid:SetFocus()
				lValid:=false
			ENDIF
		endif
	ENDIF
	IF 	lValid
		// check type of person:
		IF self:oDCmType:CurrentItemNo==0
			cError :=self:oLan:WGet("Select a type for this person")
			self:oDCmType:SetFocus()
			lValid:=FALSE
		ENDIF
	ENDIF
	IF 	lValid
		// check gender of person:
		IF self:oDCmGender:CurrentItemNo==0
			cError :=self:oLan:WGet("Select a gender for this person")
			self:oDCmGender:SetFocus()
			lValid:=FALSE
		ENDIF
	ENDIF
	IF lValid .and. Len(self:aBankAcc)>0
		* Check duplicate bankaccount:
		FOR i:=1 to Len(self:aBankAcc)
			IF !Empty(self:aBankAcc[i,1]) 
				if sepaenabled
					if !IsSEPA(self:aBankAcc[i,1])
						cError+=self:aBankAcc[i,1]+' '+self:oLan:WGet("is not a valid sepa bank account number")+CRLF+self:oLan:WGet("go to https://www.ibanbicservice.nl/SingleRequest.aspx to convert")+CRLF+ ;
						" or http://www.iban-rechner.de/iban_berechnen_bic.html"+CRLF +" or http://www.ibanbic.be"+CRLF 
						lValid:=false
					endif
					if Empty(self:aBankAcc[i,2])
						cError+=self:aBankAcc[i,1]+' '+self:oLan:WGet("should have a bic")+CRLF 
						lValid:=false
					endif						
				endif
				cSelBank+=iif(Empty(cSelBank),"("," or ")+"banknumber='"+self:aBankAcc[i,1]+"'"
			endif
		next
		IF !Empty(cSelBank) 
			cSelBank+=")"
			if !lNew
				cSelBank+=" and persid<>'"+self:mPersid+"'"
			endif
			oSel:=SQLSelect{"select banknumber,persid from personbank where "+cSelBank,oConn}
			oSel:Execute()
			oSel:GoTop()
			if oSel:RecCount>0
				lValid:=FALSE
				cError:="Bank account"+iif(oSel:RecCount=1," ","s "+CRLF)
				do while !oSel:EoF
					cError += oSel:banknumber+" "+self:oLan:WGet("belongs already to")+" "+GetFullName(Str(oSel:persid,-1),2)+CRLF
					oSel:Skip()
				enddo
			ENDIF
		ENDIF
	ENDIF
	IF lValid                  
		IF 'MW' $ self:mCodInt
		   IF self:lNew .or.Empty(self:oPerson:mbrid)  
  				lValid := FALSE
				cError := self:oLan:WGet("Mailing code")+" '" +GetMailDesc("MW") + "' "+self:oLan:WGet("only allowed in case of member")
			ENDIF
		ELSE
			IF !self:lNew .and.!Empty(self:oPerson:mbrid) 
 				lValid := FALSE
				cError := self:oLan:WGet("Mailing code")+" '" +GetMailDesc("MW") + "' "+self:oLan:WGet("obliged in case of member")
			ENDIF
		ENDIF
	ENDIF
	IF lValid
		IF !IsNil(mCodInt)
			IF !Empty(self:mCodInt).and.AllTrim(self:mCodInt)#'MW'
// 				IF Empty(self:mCity)
// 					lValid := FALSE
// 					cError := self:oLan:WGet("Enter address in case of mail code")+"!"
// 		 		ELSE
// 	 				IF SEntity == 'NED'.and.(Empty(self:mCountry) .or. Upper(AllTrim(self:mCountry))==;
// 		    	      "NEDERLAND".or. Upper(AllTrim(self:mCountry))=="THE NETHERLANDS");
//         			  .and.Empty(self:mPostalcode)
// 						lValid := FALSE
// 						cError := self:oLan:WGet("Postcode obliged in the Netherlands")
// 					ENDIF
// 				ENDIF
			ENDIF
		ENDIF
 	ENDIF
 	IF !lValid .and. !Empty(cError)
 		(ErrorBox{self,cError}):Show()
	ENDIF

	RETURN lValid
Function ExtractPostCode(cCity:="" as string,cAddress:="" as string, cPostcode:="" as string) as array
	LOCAL oHttp  as cHttp
	LOCAL nStart, nPos, nEnd as int
	local nPos1,nPos2, nPos3,i,j as int
	local time0,time1 as float
	local street,zipcode, cityname,housenr,housenrOrg, order, output, bits, httpfile, cSearch as string, aorder:={},abits:={} as array
	local cBuffer as string
	local cHeader as string
	local lSuccess as logic                          
	LOCAL aWord as ARRAY
	if Empty(cAddress) .or. Empty(cPostcode).and.Empty(cCity)
		return {cPostcode,cAddress,cCity}
	endif
	street:=AllTrim(cAddress)
	zipcode:=AllTrim(StrTran(cPostcode,' ',''))  
	if !Len(zipcode)==6 .or. !isnum(SubStr(zipcode,1,4)) .or.!IsAlphabetic(SubStr(zipcode,5,2)) .or. IsPunctuationMark(SubStr(zipcode,5,2))
		//illegal zipcode
		zipcode:=''
		if !Empty(cPostcode)
			// apparently non-dutch postal code:
			return {cPostcode,cAddress,cCity}	
		endif		
	endif 
	cCity:=AllTrim(cCity)
	//cCity:=StrTran(cCity,'Y','IJ')
	cityname:=cCity 

//	housenrOrg:=StrTran((GetStreetHousnbr(cAddress))[2],' ','')
	housenrOrg:=AllTrim(GetStreetHousnbr(cAddress)[2])

	// remove housenbr addition from address:
	aWord:=GetTokens(cAddress)
	nEnd:=Len(aWord)
	if nEnd>1
		if Empty(aWord[nEnd-1,1])  // separation character?
			nEnd-=2
		elseif isnum(aWord[nEnd-1,1])
			nEnd--
		endif
		cAddress:=""
		for i:=1 to nEnd
			cAddress+=aWord[i,1]+iif(i==nEnd,"",aWord[i,2])
		next
		cAddress:=AllTrim(cAddress)
	endif
	housenr:=(GetStreetHousnbr(cAddress))[2]
	if !Empty(zipcode) .and. !Empty(housenr)
		cSearch:=zipcode+' '+housenr
	elseif !Empty(cCity) .and. !Empty(cAddress)
// 		aWord:=GetTokens(cCity)
// 		cSearch:=cAddress+' '+aWord[1,1] 
		cSearch:=cAddress+' '+cCity 
		// check strange address:
		if IsPunctuationMark(cSearch)
			return {cPostcode,cAddress,cCity}
		endif
		if Len(Split(cCity))>4
			return {cPostcode,cAddress,cCity}
		endif
	else
		return {cPostcode,cAddress,cCity}	                             
	endif
	cSearch:=StrTran(cSearch,' ','%20')
	oHttp := CHttp{"WycOffSy",,true}
// 	cHeader:="Content-Type: application/x-www-form-urlencoded" + CRLF + HEADER_ACCEPT +  "User-Agent: Mozilla/5.0 (Windows NT 6.2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36"+CRLF
// 	cHeader:='Content-Type: application/x-www-form-urlencoded'+CRLF+'User-Agent: Mozilla/5.0 (Windows NT 6.2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36'+CRLF+;
//   'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'+CRLF+;
//   'Accept-Language: en-us,en;q=0.5'+CRLF+;
//   'Accept-Encoding: gzip,deflate'+CRLF+;
//   'Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7'+CRLF+;
//   'Keep-Alive: 115'+CRLF+;
//   'Connection: keep-alive'+CRLF
      time0:=Seconds()
		cBuffer 	:= oHttp:GetDocumentByGetOrPost( "www.postcode.nl",;
			"/search/"+cSearch,;
			/*cSearch*/,;
			/*cHeader*/,;
			"POST",;
			/*INTERNET_DEFAULT_HTTPS_PORT*/,;
			INTERNET_FLAG_SECURE)
// 	cBuffer:= oHttp:GetDocumentByURL("www.postcode.nl/search/"+cSearch) 
	time1:=Seconds()   
	httpfile:=(UTF2String{cBuffer}):Outbuf
	if AtC('class="alert warning"',httpfile)>0 
		return {cPostcode,cAddress,cCity}	
	endif		
	nPos1:=At('<section id="main" role="main">',httpfile)
	if nPos1>0
		// search unique string before response
		nPos1:=At3('<h1>',httpfile,nPos1+31)
		if nPos1>0                                                
			output:=SubStr(httpfile,nPos1+4,200) 
		elseif AtC('Value is not a number',httpfile)=0 
			// apparently website changed:
			LogEvent(,"postcode.nl werkt niet voor:"+cSearch+'('+cAddress+", "+cPostcode+", "+cCity+")"+", user:"+LOGON_EMP_ID+iif(Empty(httpfile),", timed out after "+Str(time1-time0,-1)+' sec',CRLF+httpfile),"LogErrors")
		endif 
	else 
		// apparently website changed:
		LogEvent(,"postcode.nl werkt niet voor:"+cSearch+'('+cAddress+", "+cPostcode+", "+cCity+"), user:"+LOGON_EMP_ID+iif(Empty(httpfile),", timed out after "+Str(time1-time0,-1)+' sec',CRLF+httpfile)+CRLF+httpfile,"LogErrors")
	endif
	if !Empty(output)
		nPos2:=At3('<',output,5)
		if nPos2>0
			street:=AllTrim(SubStr(output,1,nPos2-1)) 
			nPos1:=AtC('t/m',street)
			if nPos1>0
				// look for preceding number: 
				for i:=nPos1-2 downto 2 step 1
					if !IsDigit(SubStr(street,i,1))
						nPos1:=i
						exit
					endif
				next                                      
				street:=AllTrim(SubStr(street,1,nPos1)) 
			else
				nPos1:=At3(housenr,street,Len(street)-Len(housenr)-5)
				if nPos1>0
					street:=AllTrim(SubStr(street,1,nPos1-1))
				endif
			endif
			street:=StrTran(StrTran(StrTran(StrTran(street,CRLF,''),TAB,''),LF,''),'&#039;',"'")
			street+=" "+housenrOrg 
			nPos1:=At3('>',output,nPos2+1)  // search end of <small ...>  
			if SubStr(output,nPos1+1,1)=='('
				// look for second <small..>:
				if (nPos2:=At3('<small',output,nPos1+9))>0
					nPos1:=At3('>',output,nPos2+1)  // search end of <small ...>  
				endif
			endif
			if nPos1=0
				return {cPostcode,cAddress,cCity}
			endif	
			zipcode:=StandardZip(SubStr(output,nPos1+1,6))
			nPos1:=At3(',',output,nPos1+1)+1
			nPos2:=At3('<',output,nPos1)
			cityname:=StrTran(AllTrim(SubStr(output,nPos1,nPos2-nPos1)),'&#039;',"'") 
			if (cityname=="'S-GRAVENHAGE")
				cityname:='DEN HAAG'
			elseif (cityname=="'S-HERTOGENBOSCH")
				cityname:="DEN BOSCH" 
			endif
			cityname:=Upper(SubStr(cityname,1,1))+Lower(SubStr(cityname,2))				
		endif
	endif	
	oHttp:CloseRemote()
	oHttp:Axit() 
	RETURN {zipcode,street,cityname}
function GENDERDSCR(cGnd as int) as string
	// Return Gender description of a person:
	RETURN pers_gender[AScan(pers_gender,{|x|x[2]==cGnd}),1]

CLASS GFTNDGRP INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS GFTNDGRP
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#GiftsNoDestGroup, "GiftsNoDest Group", "Group of gifts without destination name", "" },  "M", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF


CLASS Gifts_group INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS Gifts_group
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#Giftsgroup, "Gifts group", "Gifts Group", "" },  "M", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF


CLASS GiftsNoDest_Group INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS GiftsNoDest_Group
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#GiftsNoDestGroup, "GiftsNoDest Group", "Group of gifts without destination name", "" },  "M", 10, 0 )
    cPict       := ""
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF


METHOD DeleteButton CLASS PersonBrowser

	LOCAL myCLN as STRING
	local cError,cErrorMessage 
	local cOrd as string 
	local lError as logic
	local aOrd:={} as array
	local oSel as SQLSelect
	local oStmnt as SQLStatement
	LOCAL oTextBox as TextBox
	
	IF self:Server:EOF.or.self:Server:BOF
		(ErrorBox{,"Select a person first"}):Show()
		RETURN
	ENDIF
	oTextBox := TextBox{ self, self:oLan:WGet("Delete Person"),;
		self:oLan:WGet("Delete Person")+Space(1) + FullName( ;
		oPers:lastname, ;
		oPers:firstname )+iif(Empty(oPers:datelastgift),'',Space(1)+self:oLan:WGet('with last gift on')+Space(1)+DToC(oPers:datelastgift))+ "?" }
	
	oTextBox:Type := BUTTONYESNO + BOXICONQUESTIONMARK
	
	IF ( oTextBox:Show() == BOXREPLYYES )
		myCLN:=Str(self:oPers:persid,-1) 
		oSel:=SQLSelect{"select empid from employee where "+Crypt_Emp(false,"persid")+"='"+myCLN+"'",oConn}
		if oSel:RecCount>0
			ErrorBox{self,self:oLan:WGet("This person is an employee! Remove person as employee first")}:Show()
			RETURN
		endif
		// 		oSel:SQLString:="select transid from transaction where persid='"+myCLN+"'"
		// 		oSel:Execute() 
		// 		if oSel:RecCount>0
		// 			InfoBox { self, self:oLan:WGet("Delete Person"),self:oLan:WGet("Fin.records in not yet balanced years present! Wait untill year balancing")}:Show()
		// 			RETURN
		// 		ENDIF
		oSel:SQLString:="select persid from member where persid='"+myCLN+"'"
		oSel:Execute()
		if oSel:RecCount>0 
			InfoBox { self, self:oLan:WGet("Delete person"),;
				self:oLan:WGet("This person is a member! First remove person as member")}:Show()
			RETURN                      
		ENDIF
		oSel:SQLString:="select "+SQLFullName(0,"p")+" as membername from person as p, member as m where m.persid=p.persid and m.contact='"+myCLN+"'"
		oSel:Execute()
		if oSel:RecCount>0 
			InfoBox { self, self:oLan:WGet("Delete person"),;
				self:oLan:WGet("This person is contact person of member")+Space(1)+oSel:membername}:Show()
			RETURN                      
		ENDIF
		oSel:SQLString:="select d.descriptn from department as d where d.persid="+myCLN+" or d.persid2="+myCLN
		oSel:Execute()
		if oSel:RecCount>0 
			InfoBox { self, self:oLan:WGet("Delete person"),;
				self:oLan:WGet("This person is contact person of department")+Space(1)+oSel:descriptn}:Show()
			RETURN                      
		ENDIF
		oSel:SQLString:="select idorg from sysparms where idorg='"+myCLN+"'"
		oSel:Execute()
		if oSel:RecCount>0 
			InfoBox { self, self:oLan:WGet("Delete person"),;
				self:oLan:WGet("This person is own organisation in system parameters! First remove person as own organisation")}:Show()
			RETURN                      
		ENDIF
		oSel:SQLString:="select pmcmancln from sysparms where pmcmancln='"+myCLN+"'"
		oSel:Execute()
		if oSel:RecCount>0 
			InfoBox { self, self:oLan:WGet("Delete person"),;
				self:oLan:WGet("This person is PMC Manager in system parameters! First remove person as PMC Manager")}:Show()
			RETURN                      
		ENDIF
		oSel:SQLString:="select stordrid from standingorder where persid='"+myCLN+"' and datediff(edat,curdate())>0"
		oSel:Execute()
		if oSel:RecCount>0 
			InfoBox { self, self:oLan:WGet("Delete Person"),;
				self:oLan:WGet("This person is giver in standing order")+Space(1)+Str(oSel:stordrid,-1)+'! '+self:oLan:WGet("First remove person from standing order")}:Show()
			RETURN                      
		ENDIF
		oSel:SQLString:="select l.stordrid from standingorderline l, standingorder s where creditor='"+myCLN+"' and l.stordrid=s.stordrid and datediff(s.edat,curdate())>0"
		oSel:Execute()
		if oSel:RecCount>0 
			InfoBox { self, self:oLan:WGet("Delete Person"),;
				self:oLan:WGet("This person is creditor in standing order")+Space(1)+Str(oSel:stordrid,-1)+'! '+self:oLan:WGet("First remove person from standing order")}:Show()
			RETURN                      
		ENDIF
		oSel:SQLString:="select personid from subscription where personid='"+myCLN+"' and category<>'G' and datediff(enddate,curdate())>0 and datediff(enddate,duedate)>0"
		oSel:Execute()
		if oSel:RecCount>0
			InfoBox { self, self:oLan:WGet("Delete Person"),;
				self:oLan:WGet("Subscript/donation present! Delete them first")}:Show()
			RETURN
		ENDIF 
		oStmnt:=SQLStatement{"set autocommit=0",oConn}
		oStmnt:Execute()
		oStmnt:=SQLStatement{'lock tables `department` write,`member` write,`person` write,`personbank` write,`standingorder` write,`standingorderline` write,`subscription` write,`sysparms` write ',oConn} 
		oStmnt:Execute()
		
		oStmnt:=SQLStatement{"update person set deleted=1,opc='"+LOGON_EMP_ID+"',alterdate=curdate() where persid="+myCLN,oConn}
		oStmnt:Execute()
		if !Empty(oStmnt:Status)
			lError:=true
			cError:='Update person Error:'+oStmnt:ErrInfo:ErrorMessage
			cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
		endif
		if !lError
			* Remove corresponding bankaccounts in PersonBank : 
			oStmnt:=SQLStatement{"delete from personbank where persid="+myCLN,oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:Status)
				lError:=true
				cError:='Delete personbank Error:'+oStmnt:ErrInfo:ErrorMessage
				cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
			endif
		endif
		if !lError
			oStmnt:=SQLStatement{"delete from subscription where personid="+myCLN,oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:Status)
				lError:=true
				cError:='Delete subscription Error:'+oStmnt:ErrInfo:ErrorMessage
				cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
			endif
		endif
		if !lError
			oSel:=SqlSelect{"select stordrid from standingorderline where creditor="+myCLN,oConn}
			if oSel:RecCount>0
				aOrd:=oSel:GetLookupTable(1000,#stordrid,#stordrid)
				cOrd:=Implode(aOrd,',',,,1)
				oStmnt:=SQLStatement{"delete from standingorder where stordrid in ("+cOrd+")",oConn}
				oStmnt:Execute()
				if !Empty(oStmnt:Status)
					lError:=true
					cError:='Delete standingorder Error:'+oStmnt:ErrInfo:ErrorMessage
					cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
				endif
				if	!lError
					oStmnt:=SQLStatement{"delete from standingorderline where stordrid in ("+cOrd+")",oConn}
					oStmnt:Execute()
					if !Empty(oStmnt:Status)
						lError:=true
						cError:='Delete standingorderline Error:'+oStmnt:ErrInfo:ErrorMessage
						cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
					endif
				endif
			endif
		endif
		if !lError
			oStmnt:=SQLStatement{"delete from standingorderline where stordrid in (select stordrid from standingorder where persid="+myCLN+")",oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:Status)
				lError:=true
				cError:='Delete standingorderline Error:'+oStmnt:ErrInfo:ErrorMessage
				cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
			endif
		endif
		if !lError
			oStmnt:=SQLStatement{"delete from standingorder where persid='"+myCLN+"'",oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:Status)
				lError:=true
				cError:='Delete standingorder Error:'+oStmnt:ErrInfo:ErrorMessage
				cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
			endif
		endif
		if !lError
			// remove as contact person from departments:
			oStmnt:=SQLStatement{"update department set persid=if(persid="+myCLN+",0,persid),persid2=if(persid2="+myCLN+",0,persid2) "+;
				"where persid="+myCLN+" or persid2="+myCLN,oConn}
			oStmnt:Execute() 
			if !Empty(oStmnt:Status)
				lError:=true
				cError:='Update department Error:'+oStmnt:ErrInfo:ErrorMessage
				cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
			endif
		endif
		if !lError
			// remove as contact person from member:
			oStmnt:=SQLStatement{"update member set contact=0 where contact="+myCLN,oConn}
			oStmnt:Execute() 
			if !Empty(oStmnt:Status)
				lError:=true
				cError:='Update member Error:'+oStmnt:ErrInfo:ErrorMessage
				cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
			endif
		endif
		if !lError
			// remove as financial contact person from system parameters:
			oStmnt:=SQLStatement{"update sysparms set idcontact=0 where idcontact="+myCLN,oConn}
			oStmnt:Execute() 
			if !Empty(oStmnt:Status)
				lError:=true
				cError:='Update sysparms Error:'+oStmnt:ErrInfo:ErrorMessage
				cErrorMessage:=cError+CRLF+"statement:"+oStmnt:SQLString
			endif
		endif
		if !lError
			SQLStatement{"commit",oConn}:Execute()
			SQLStatement{"unlock tables",oConn}:Execute() 
			SQLStatement{"set autocommit=1",oConn}:Execute()
		else
			SQLStatement{"rollback",oConn}:Execute()
			SQLStatement{"unlock tables",oConn}:Execute() 
			SQLStatement{"set autocommit=1",oConn}:Execute()
			LogEvent(self,cErrorMessage,"LogErrors")
			ErrorBox{self,self:oLan:WGet('Delete person Error')+':'+cError}:Show()
			return false		
		endif
		self:SearchCLN:=''
		self:FindButton()
		self:gotop() 

	endif
	// refresh owner: 
	// 	self:oPers:Execute() 
	// 	self:oSFPersonSubForm:Browser:refresh()

	// 		oSFPersonSubForm:Browser:REFresh()
	// 		oPeriod:Close()
	// 		oTrans:Close()

	RETURN nil
METHOD FilePrint CLASS PersonBrowser

(self:oSelpers:=Selpers{self,"MAILINGCODE"}):Show()
RETURN
METHOD GoBottom() CLASS PersonBrowser
	RETURN SELF:oSFPersonSubForm:GoBottom()
METHOD GoTop() CLASS PersonBrowser
	RETURN SELF:oSFPersonSubForm:GoTop()
METHOD NewButton CLASS PersonBrowser

SELF:EditButton(TRUE)

	RETURN NIL
METHOD PersonSelect(oExtCaller as object,cValue as string,Itemname as string,Unique as logic, oPersCnt as PersonContainer) as logic CLASS PersonBrowser
	LOCAL iEnd  as int
	// 	Default(@cValue,null_string)
	self:oCaller := oExtCaller
	self:oPersCnt:=oPersCnt
	IF !Empty(Itemname)
		self:cItemname := Itemname 
		if cItemname="person to merge with"
			self:oCCUnionButton:Hide()
		endif
	ENDIF
	if !Empty(cValue)
		iEnd:= At(",",cValue)
	endif
	self:caption := "Select "+if(Empty(Itemname),"a person",Itemname)+": "
	IF Empty(Unique)
		self:lUnique := FALSE
	ELSE
		self:lUnique := true
	ENDIF
	IF !Empty(cValue)
		if !Empty(oPersCnt).and. !Empty(oPersCnt:m51_pos)
			self:SearchSZP := oPersCnt:m51_pos
		ENDIF
		IF IsDigit(cValue)
			cValue:=ZeroTrim(cValue)
			IF Len(cValue)>6 .and.!IsAlpha(psz(_cast,SubStr(cValue,Len(cValue),1))) .and.(Empty(oPersCnt).or.Empty(oPersCnt:m56_banknumber))
				self:SearchBank := cValue
			ELSEif Empty(self:SearchSZP) .and.(Empty(oPersCnt).or.Empty(oPersCnt:m56_banknumber).or.!alltrim(oPersCnt:m56_banknumber)==alltrim(cValue))				
				self:SearchSZP := cValue
			else
				self:SearchUni:= cValue
			ENDIF
		ELSE
			// 			self:SearchSLE := AllTrim(SubStr(cValue,1,if(iEnd<2,nil,iEnd-1)))
			self:SearchUni := AllTrim(StrTran(cValue,',',' ')) +iif(empty(oPersCnt) .or. empty(oPersCnt:m51_city),'',' '+oPersCnt:m51_city)
		ENDIF
		if !Empty(oPersCnt).and.!Empty(oPersCnt:persid)
			self:SearchCLN:=oPersCnt:persid
		endif
	ENDIF
	

	IF !Empty(oPersCnt).and.!Empty(oPersCnt:m51_lastname)
		self:caption+=Compress(" "+oPersCnt:m51_lastname+","+oPersCnt:m51_title+;
			" "+oPersCnt:m51_initials+" "+oPersCnt:m51_prefix+"; "+oPersCnt:m51_ad1+" "+;
			oPersCnt:m51_pos+" "+oPersCnt:m51_city)
	else
		self:caption+=Compress(" "+cValue)
	ENDIF
	if self:oPers:RecCount>1 .and.!Empty(oPersCnt)
		if !Empty(oPersCnt:current_PersonID) 
			do while !self:oPers:EoF .and. !self:oPers:persid==oPersCnt:current_PersonID
				self:Skip()
			enddo
		else
			self:GoTop()
		ENDIF
	else
		self:GoTop()		
	ENDIF
   if self:oPersCnt:recognized
		self:oDCSearchCLN:Disable()     // recognized by telebanking so not possible to change person
		self:oCCFindButton:Disable()
	endif
   	
   	
	self:Show()
	self:Found:=Str(self:oPers:RecCount,-1)

	if self:oPers:RecCount>0
		self:oCCOKButton:Enable()
	elseif !(Empty(self:SearchBank).and.Empty(self:SearchCLN).and.Empty(self:SearchSLE).and.Empty(self:SearchSZP).and.Empty(self:SearchUni))
		self:FindButton()
	endif

	RETURN true

method RegPerson(oCLN) class PersonBrowser 
Local oTextBox as TextBox 
local CurRec as int
Local oP1, oP2:=self:Server as SQLSelect 
Local Id1, Id2,Name1,Name2 as string
IF !Empty(oCLN) .and. IsObject(self:Server) 
	oP1:=oCLN
	Id1:=Str(oP1:persid,-1)
	Id2:=Str(oP2:persid,-1) 
	Name1:=GetFullNAW(Id1,,3)	
	Name2:=GetFullNAW(Id2,,3)	
	oTextBox := TextBox{ self, "Merge Record","Merge "+Name2+"  into person: "+Name1+"?"+ CRLF+ CRLF + "This means that all gifts, donations and standard gift pattens of "+Name2+" will be transfered to "+Name1+CRLF+" and that "+Name2+ " will be removed" }
		
	oTextBox:Type := BUTTONYESNO + BOXICONQUESTIONMARK
	
	IF ( oTextBox:Show() == BOXREPLYYES ) 
		CurRec:=oCLN:RECNO 
		if PersonUnion(Id1,Id2)
			self:oPers:Execute()
			self:FOUND :=Str(self:oPers:reccount,-1) 
			self:oSFPersonSubForm:Browser:refresh()
			self:Server:RECNO:=CurRec
		endif 		
	endif

ENDIF
RETURN 
METHOD SkipNext() CLASS PersonBrowser

	SELF:oSFPersonSubForm:Browser:SuspendUpdate()

	SELF:oSFPersonSubForm:SkipNext()
	IF SELF:oSFPersonSubForm:Server:Eof
		SELF:SkipPrevious()
	ENDIF

	SELF:oSFPersonSubForm:Browser:RestoreUpdate()

	RETURN TRUE
METHOD SkipPrevious() CLASS PersonBrowser
	RETURN SELF:oSFPersonSubForm:SkipPrevious()
METHOD Adres_Analyse(aWord as array, nStartAnalyse:=1 as int,lZipCode:=false ref logic,lCity:=false ref logic,lAddress:=false ref logic,lFromName:=false as logic,lZipFromWeb:=true as logic) as int CLASS PersonContainer
*  Determines Zipcode, street and city from an array with NAW-words {{Token, Separator},...}
*	Returns startposition of address in the array
*	nStartAnalyse: startword to start analyses (default=1)
*	lZipCode : True: zipcode is allreeady known
*	lCity : True: city name allready known 
*  lFromName: Find address in name field in stead of address field 
*  lZipFromWeb: get zip code from internet when not found
*
LOCAL i,j,wp,l,  nNumPosition:=0, nZipPosition, nCityPosition, nStart, nStartAddress as int
LOCAL aStreetPrefix:={"VAN","OP","V/D","V/H","O/H","DEN","VON","VD","DE","HET"} as ARRAY 
local lForeign as logic 
local aDrWord:={} as array

* search for zip code:
wp:=Len(aWord)
IF wp<2 && (first streetname, housenumber, first part zipcode)
	RETURN wp+1
ENDIF
i:=iif(isnum(aWord[wp,1]),wp-1,wp)
if aWord[i,1]=='BE' 
	// apparently Belgium:
	self:m51_country:='België'
	ASize(aWord,i-1)
	wp:=i-1 
	lForeign:=true 
elseif !Empty(self:m51_country) .and. AScanExact(OwnCountryNames,self:m51_country)=0 
	lForeign:=true
endif

IF !lZipCode
	self:m51_pos:=""
	*Search Zipcode:
	FOR i:=nStartAnalyse+1 to wp
		IF isnum(aWord[i-1,1])
			IF Len(aWord[i-1,1])=4
				IF Len(aWord[i,1])=2
					IF IsAlpha(aWord[i,1])
						* dutch zipcode found:
						self:m51_pos:=aWord[i-1,1]+" "+aWord[i,1]
						nZipPosition:=i-1
						aWord[i]:={"",""} // empty word
						aWord[i-1]:={"",""} // empty word
						lZipCode:=true
						nStart:=nZipPosition-1
						nCityPosition:=nZipPosition+2
						nStartAddress:=nZipPosition
						exit
					ENDIF
				ENDIF
			ENDIF
			if lForeign .and. Len(aWord[i,1])>=4 .and. isnum(aWord[i,1])
			// probably foreign zip code:
				self:m51_pos:=StandardZip(aWord[i,1])
				nZipPosition:=i
				nStart:=nZipPosition-1
				nCityPosition:=nZipPosition+1
				nStartAddress:=nZipPosition
				aWord[i]:={"",""}	//	empty	word
				lZipCode:=true
				exit
			ENDIF
		ENDIF
	NEXT
ENDIF
IF Empty(nZipPosition)
	nStart:=Min(6,wp)
ENDIF
IF !lAddress
	self:m51_ad1:=""
	* Search streetname:
	* Search backwards till housenbr:
	FOR l:=nStart to nStartAnalyse step -1
		IF isnum(aWord[l,1]).and.l>1.and.Empty(nNumPosition)
//		IF IsDigit(aWord[l,1]).and.l>1.and.Empty(nNumPosition)
			* Housenbr found:
			nNumPosition:=l
			aWord[l,1]:=ZeroTrim(aWord[l,1])  // remove leading zeroes in house number
			// check housenbr addition:
			if l<nStart
				if Empty(aWord[l+1,1]) .and. (l+1)<nStart   // separation for addition: - / 
					nNumPosition+=2
				elseif Len(aWord[l+1,1])=1 .or.aWord[l+1,2]="-" 
					nNumPosition++  // addition part of address
				endif
			endif
		ELSEIF IsAlpha(aWord[l,1]).and.!Empty(nNumPosition)
			* Streetname found:
			if lFromName
				IF l>nStartAnalyse.and.(Len(aWord[l-1,1])<3.or. AScanExact(aStreetPrefix,aWord[l-1,1])>0)
					* join one/two char/prefix before streetname
					nStartAddress:=l-1
				ELSE			
					nStartAddress:=l
				ENDIF
			else
				 nStartAddress:=1    // whole field address
			endif
			IF Empty(nCityPosition)
				nCityPosition:=nNumPosition+1
			ENDIF
			FOR j=nStartAddress to Max(nNumPosition,nZipPosition-1)
				self:m51_ad1:=self:m51_ad1+Upper(SubStr(aWord[j,1],1,1))+Lower(SubStr(aWord[j,1],2))+aWord[j,2]
				aWord[j]:={"",""} // empty word			
				lAddress:=true
			NEXT
			self:m51_ad1:=Compress(self:m51_ad1)
			exit
		ENDIF
	NEXT
ENDIF
IF !lCity
	self:m51_city:=""
	IF nCityPosition<=wp .and. nCityPosition>0
		FOR j:=nCityPosition to wp
			IF Len(self:m51_city)+Len(aWord[j,1])>=18.or.aWord[j,1]=="FAM".or.aWord[j,1]=="GIFT".or.aWord[j,1]=="TGV";
				.or.aWord[j,1]=="TNV".or.aWord[j,1]=="VOOR".or.IsDigit(aWord[j,1])
				exit
			ENDIF
			self:m51_city:=self:m51_city+" "+aWord[j,1]
			aWord[j]:={"",""} // empty word
		NEXT
		self:m51_city:=AllTrim(self:m51_city)
// 		if upper(SubStr(self:m51_city,len(self:m51_city)-2,3))==' BE'
// 			// apperently belgium
// 			self:m51_country:="België"
// 			self:m51_city:=SubStr(self:m51_city,1,Len(self:m51_city)-3)
// 		endif			
		lCity:=true
	ENDIF
ENDIF
IF Empty(nStartAddress)
	RETURN wp+1
ENDIF
// Find zip-code:
If CountryCode="31" .and.lZipFromWeb .and. !lZipCode .and. lCity .and. lAddress
	aDrWord:=ExtractPostCode(self:m51_city,self:m51_ad1,self:m51_pos)
	self:m51_pos:=aDrWord[1]
endif
RETURN nStartAddress
METHOD NameAnalyse(lAddress,lInitials,lSalutation,lMiddleName,lZipCode,lCity) CLASS PersonContainer
	* Disassambly of a assembled name field into lastname, initials, salutation and middlename (and address)
	* Usefull for names from telebanking or import of persons
	*
	* Optional parameters lAddress,lInitials,lSalutation,lMiddleName has value:
	* True: if subfield is allready known
	* False: if the subfield has to be disassembled.
	*
	LOCAL nLength, i,j as int
	LOCAL aWord as ARRAY
	LOCAL aFirstPrefix:={"VAN","OP","V/D","V/H","O/H","DEN","VON","VD","DE","HET","DER"} as ARRAY
	LOCAL aSecondPrefix:={"DEN","DER","HET","DE"} as ARRAY
	LOCAL aSalutation:={"DHR","HR","MW","MEJ","HR/MW","FAM","MR","MRS","PROF","DR","IR","DS","ARTS","DRS","HEER"} as ARRAY
	LOCAL aSalutationSep:={"EN","EO",""} as ARRAY
	LOCAL nInitialsPos, nSalutationPos, nPrefixPos, nStart, nCityPosition as int
	Default(@lAddress,FALSE)
	Default(@lInitials,FALSE)
	Default(@lSalutation,FALSE)
	Default(@lMiddleName,FALSE)
	aWord:=GetTokens(self:m51_lastname)
	IF !lAddress
		* If no address found, try to find within m51_lastname:
		nLength:=self:Adres_Analyse(aWord,2,@lZipCode,@lCity,@lAddress,true)-1
		IF nLength<Len(aWord)
			lAddress:=true
			* Limit to start of address:
			ASize(aWord,nLength)
		ENDIF
	ENDIF
	nLength:=Len(aWord)
	*
	*  Determine initials:
	*
	IF !lInitials
		self:m51_initials:=""
		FOR i:=1 to nLength
			IF Len(aWord[i,1])==1.and.IsAlpha(aWord[i,1]).and.!aWord[i,2]="-".and.!aWord[i,2]="/".and.; //not followed by -/
				!(i>1.and.(aWord[i-1,2]="-".or.aWord[i-1,2]="/")) //no "-/" preceding
				self:m51_initials:=self:m51_initials+Upper(aWord[i,1])+"."
				IF !lInitials
					nInitialsPos:=i
					lInitials:=true
				ENDIF
				aWord[i]:={"",""} // empty word 
// 				ADel(aWord,i)
// 				nLength--
// 				ASize(aWord,nLength)
			ELSEIF lInitials
				exit
			ENDIF
		NEXT
	ENDIF

	*  Determine salutation:
	*
	self:m51_title:=""
	IF !lSalutation .and. (!lInitials .or. nInitialsPos> 1 .or. Empty(nInitialsPos))
		* enough space for salutation:
		IF lInitials
			*	Salutation should be before initials:
			IF !Empty(nInitialsPos)
				nLength:=nInitialsPos-1
			ENDIF
		ENDIF
		FOR i:=1 to nLength
			IF AScanExact(aSalutation,Upper(aWord[i,1]))>0
				self:m51_title:=self:m51_title+Upper(SubStr(aWord[i,1],1,1))+Lower(SubStr(aWord[i,1],2))+aWord[i,2]
				IF !lSalutation
					nSalutationPos:=i
					lSalutation:=true
				ENDIF
			ELSE
				IF lSalutation
					IF AScanExact(aSalutationSep,aWord[i,1])>0
						self:m51_title:=self:m51_title+Lower(aWord[i,1])+aWord[i,2]
					ELSE
						* search for e/o, etc
						IF i+1< nLength.and.AScanExact(aSalutationSep,aWord[i,1]+aWord[i,2]+aWord[i+1,1])>0
							self:m51_title:=self:m51_title+Lower(aWord[i,1]+aWord[i,2]+aWord[i+1,1]+aWord[i+1,2])
							++i
						ELSE
							* End of Salutation:
							exit
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		NEXT
	ENDIF
	IF nSalutationPos>0
		* End of Salutation:
		IF lInitials.and.i<nInitialsPos
			*	Salutation not united with initials:
			self:m51_title:=""
			lSalutation:=FALSE
			nSalutationPos:=0
		ELSE
			*	Remove words with salutation
			FOR j:=nSalutationPos to i-1
				aWord[j]:={"",""} // empty word
			NEXT
		ENDIF
	ENDIF

	IF ! lMiddleName
		* Determine Prefix:
		self:m51_prefix:=""
		nLength:=Len(aWord)
		for i:=1 to nLength 
			if i== nInitialsPos
				loop
			endif 
			IF AScanExact(aFirstPrefix,Upper(aWord[i,1]))>0 
				IF IsAlpha(aWord[i,1]).and.!aWord[i,2]="-".and.!aWord[i,2]="/".and.; //not followed by -/
					!(i>1.and.(aWord[i-1,2]="-".or.aWord[i-1,2]="/")) //no "-/" preceding
					
					self:m51_prefix:=Lower(aWord[i,1])
					nPrefixPos:=i
					aWord[i]:={"",""}	//	empty	word
					IF	i<nLength
						IF	AScanExact(aSecondPrefix,Upper(aWord[i+1,1]))>0
							self:m51_prefix:=self:m51_prefix+" "+Lower(aWord[i+1,1])
							aWord[i+1]:={"",""} // empty word
						ENDIF
					ENDIF
					exit
				endif
			ELSE
				* search	for o/h,	etc:
				IF	i<nLength .and.AScanExact(aFirstPrefix,Upper(aWord[i,1]+aWord[i,2]+aWord[i+1,1]))>0
					self:m51_prefix:=Lower(aWord[i,1]+aWord[i,2]+aWord[i+1,1])
					nPrefixPos:=i
					aWord[i]:={"",""} // empty word
					aWord[i+1]:={"",""} // empty word 
					exit
				ENDIF
			ENDIF
		next
		// 		*	Prefix direct behind initials/salutation:
		// 		nStart:=Max(nInitialsPos,nSalutationPos)+1
		// 		IF nStart <=nLength
		// 			nStart:=AScanExact(aWord,{|x| !Empty(x[1])},nStart)
		// 			// any word direct after salutation/initial or start
		// 			IF nStart>0
		// 				IF AScanExact(aFirstPrefix,aWord[nStart,1])>0
		// 					m51_prefix:=Lower(aWord[nStart,1])
		// 					nPrefixPos:=nStart
		// 					aWord[nStart]:={"",""} // empty word
		// 					IF nStart<nLength
		// 						IF AScanExact(aSecondPrefix,aWord[nStart+1,1])>0
		// 							m51_prefix:=m51_prefix+" "+Lower(aWord[nStart+1,1])
		// 							aWord[nStart+1]:={"",""} // empty word
		// 						ENDIF
		// 					ENDIF
		// 				ELSE
		// 					* search for o/h, etc:
		// 					IF nStart<nLength .and.AScanExact(aFirstPrefix,aWord[nStart,1]+aWord[nStart,2]+aWord[nStart+1,1])>0
		// 						m51_prefix:=Lower(aWord[nStart,1]+aWord[nStart,2]+aWord[nStart+1,1])
		// 						nPrefixPos:=nStart
		// 						aWord[nStart]:={"",""} // empty word
		// 						aWord[nStart+1]:={"",""} // empty word
		// 					ENDIF
		// 				ENDIF
		// 			ENDIF
		// 		ENDIF
	ENDIF
	*
	*	Determine initials if not yet found from 2 character word:
	IF !lInitials
		i:=AScanExact(aWord,{|x| !Empty(x[1])})
		IF !Empty(i).and.Len(aWord[i,1])==2.and.IsAlpha(aWord[i,1])
			nInitialsPos:=i
			lInitials:=true
			self:m51_initials:=SubStr(aWord[nInitialsPos,1],1,1)+"."+SubStr(aWord[nInitialsPos,1],2,1)+"."
			aWord[nInitialsPos]:={"",""}
		ENDIF
	ENDIF
	IF  !lAddress
		*	Determine City if no address found up till now:
		nStart:=Max(nInitialsPos,Max(nSalutationPos,nPrefixPos))+1
		IF nStart <=nLength
			nStart:=AScanExact(aWord,{|x| !Empty(x[1])},nStart)
		ELSE
			nStart:=0
		ENDIF
		IF nLength-nStart>0.and.!Empty(nStart)
			*	>=Two words for name and city:
			* first try to find section after comma:
			nCityPosition:=AScanExact(aWord,{|x| x[2]=","},nStart)
			IF nCityPosition>0
				* all after comma regarded as city name:
				FOR i:=nCityPosition+1 to nLength
					self:m51_city:=self:m51_city+aWord[i,1]+aWord[i,2]
					aWord[i]:={"",""}
				NEXT
			ELSE
				* last word is cityname:
				IF !Upper(aWord[nLength-1,1])=="EN" .and.; // not couple with "EN" between names:
					!Len(aWord[nLength,1])>18.and.!aWord[nLength-1,2]=="-".and.!aWord[nLength-1,2]=="/"; // no double name with - /
					.and.AScanExact(aFirstPrefix,Upper(aWord[nLength-1,1]))=0 // no prefix preceding city name
					self:m51_city:=aWord[nLength,1]
					aWord[nLength]:={"",""}
					IF Len(aWord[nLength-1,1])==1
						* One char before cityname (like s gravenhage):
						self:m51_city:=aWord[nLength-1,1]+aWord[nLength-1,2]+self:m51_city
						aWord[nLength-1]:={"",""}
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	*  Determine Lastname:
	self:m51_lastname:=""
	nStart:=0    // start at beginning to find name
	FOR i:=if(Empty(nStart),1,nStart) to nLength
		if !Empty(aWord[i,1])
			IF Len(self:m51_lastname)+Len(aWord[i,1])<=28
				IF !upper(aWord[i,1])=="EN" .and.!upper(aWord[i,1])=="EO".and.!upper(aWord[i,1])=="CJ".and.!(Upper(aWord[i,1])=='E'.and.aWord[i,2]=='/');
					.and.!Upper(aWord[i,1])=="VOOR".and.!Upper(aWord[i,1])=="GIFT".and.!Upper(aWord[i,1])=="TGV".and.!IsDigit(Upper(aWord[i,1]))
					self:m51_lastname:=self:m51_lastname+Upper(SubStr(aWord[i,1],1,1))+Lower(SubStr(aWord[i,1],2))+if(aWord[i,2]==","," ",aWord[i,2])
					if Upper(aWord[i,1])=="STICHTING" .or. Upper(aWord[i,1])=="BV" .or. Upper(aWord[i,1])=="GEMEENTE"  
						self:m51_gender:="non-person"
					endif
				ELSE
					if Upper(aWord[i,1])=="EN" .or.Upper(aWord[i,1])=="EO".or.Upper(aWord[i,1])=="CJ" .or.(Upper(aWord[i,1])=='E'.and.aWord[i,2]=='/')
						self:m51_gender:="couple"
					endif 
					IF i==nStart
						loop
					ELSE
						* Next word probably part of streetname in case of "EN OF". "EO" or "CJ":
						if lAddress .and. i+2==nLength .and.Upper(aWord[i+1,1])=="OF"
							self:m51_AD1:=Upper(SubStr(aWord[i+2,1],1,1))+Lower(SubStr(aWord[i+2,1],2))+" "+self:m51_AD1
						ELSEIF lAddress.and.i+1==nLength .and.(Upper(aWord[i,1])=="EO".or.Upper(aWord[i,1])=="CJ")
							self:m51_AD1:=Upper(SubStr(aWord[i+1,1],1,1))+Lower(SubStr(aWord[i+1,1],2))+" "+self:m51_AD1
						ENDIF
						exit
					ENDIF
				ENDIF
			ELSE
				exit
			ENDIF
		endif
	NEXT
	self:m51_lastname:=Compress(self:m51_lastname)

	RETURN
METHOD NAW_ANALYSE(lInitials,lSalutation,lMiddleName,lZipCode,lCity,lAddress) CLASS PersonContainer
*  Analyse strings m15_achternaam and m51_ad1 containing NAW-data (e.g. from TeleBanking)
LOCAL nLength  as int
LOCAL aWord as ARRAY
// local lZipCode:=lZipCodeP,lCity:=lCityP,lAddress:=lAddressP as logic
*{" ",",",".","&","/","-"}
* Supposed sequence: salutation initials Prefixname lastname  address

* Decompose text into array of tokens {{token, seperator}, ...}:
*
*	Determine address:
*
Default(@lInitials,FALSE)
Default(@lSalutation,FALSE)
Default(@lMiddleName,FALSE)
Default(@lZipCode,FALSE)
Default(@lCity,FALSE)
Default(@lAddress,FALSE)
IF Empty(self:m51_lastname+" "+self:m51_AD1)
	RETURN
ENDIF
*	First try te find address within m51_ad1:
aWord:=GetTokens(m51_AD1,{" ",",",".","&","/"})
nLength:=self:Adres_Analyse(aWord,,@lZipCode,@lCity,@lAddress,false)-1
self:NameAnalyse(lAddress,lInitials,lSalutation,lMiddleName,lZipCode,lCity)
RETURN
FUNCTION PersonSelect(oCaller:=null_object as window,pValue:="" as string,lUnique:=false as logic,cFilter:="" as string,;
		cItemname:="" as string,oPersCnt:=null_object as PersonContainer) as void pascal
	LOCAL iEnd := At(",",pValue) as int
	local cWhere,cFrom:="person as p", cOrder:="lastname",cValue:=pValue as string
	local cFields:= "p.persid,lastname,initials,firstname,prefix,type,cast(datelastgift as date) as datelastgift,address,postalcode,city,country" as string  
	local oMyWindow as window
	LOCAL lSuccess,lParmUni,lPersid as LOGIC 
	LOCAL oPersBw as PersonBrowser
	local oSel as SqlSelectPagination
	
	// 	IF lUnique 
	if !Empty(oPersCnt)
		if !Empty(oPersCnt:persid)
			cWhere:="p.persid='"+oPersCnt:persid+"'" 
			lParmUni:=true
			lPersid:=true
		elseif !Empty(oPersCnt:m51_exid)
			cWhere:="externid='"+oPersCnt:m51_exid+"'"
			lParmUni:=true
		elseif !Empty(oPersCnt:m56_banknumber)
			cWhere:="b.persid=p.persid and b.banknumber='"+oPersCnt:m56_banknumber+"'"
			cFrom+=",personbank as b"
			lParmUni:=true
		else
			if !Empty(oPersCnt:m51_AD1)
				cWhere+=iif(Empty(cWhere),""," and ")+"address like '"+AddSlashes(oPersCnt:m51_AD1)+"%'"
			ENDIF
			if !Empty(oPersCnt:m51_lastname)
				cWhere+=iif(Empty(cWhere),""," and ")+"lastname like '"+AddSlashes(oPersCnt:m51_lastname)+"%'"
			ENDIF
			if !Empty(oPersCnt:m51_city)
				cWhere+=iif(Empty(cWhere),""," and ")+"city like '"+AddSlashes(oPersCnt:m51_city)+"%'"
			ENDIF
			if !Empty(oPersCnt:m51_pos)
				cWhere+=iif(Empty(cWhere),""," and ")+"postalcode like '"+oPersCnt:m51_pos+"%'"
			ENDIF
			if !Empty(oPersCnt:m51_country)
				cWhere+=iif(Empty(cWhere),""," and ")+"country like '"+AddSlashes(oPersCnt:m51_country)+"%'"
			ENDIF
		endif
	endif
	if !Empty(cValue) .and.!lParmUni 
		// 		cValue:=AllTrim(SubStr(cValue,1,if(iEnd<2,nil,iEnd-1)))
		If IsDigit(cVALUE)
			if Len(cValue)>=7.and.isnum(Right(cValue,7)) .and.(Empty(oPersCnt).or.Empty(oPersCnt:m56_banknumber))
				cWhere+=iif(Empty(cWhere),""," and ")+"p.persid=b.persid and b.banknumber='"+cValue+"'"
				cFrom+=",personbank as b" 
			elseif Empty(oPersCnt).or.Empty(oPersCnt:m51_pos)
				cWhere+=iif(Empty(cWhere),""," and ")+"postalcode like '"+StandardZip(cValue)+"%'" 
				cOrder:="postalcode"
			endif
		else
			if sepaenabled .and. IsIban(cValue)
				lParmUni:=true 
				lUnique:=true
				cFrom+=",personbank as b" 
				cWhere+=iif(Empty(cWhere),""," and ")+"p.persid=b.persid and b.banknumber='"+cValue+"'"
			elseif Empty(oPersCnt).or.Empty(oPersCnt:m51_lastname)
				// search on name
				cWhere+=iif(Empty(cWhere),""," and ")+"lastname like '"+AddSlashes(cValue)+"%'"
			endif 
		endif
	endif
	if Empty(cWhere).and.Empty(cFilter)
		cWhere:="1=0"    // impossible condition
	elseif !lPersid
		cWhere+= iif(Empty(cWhere),""," and ")+"p.deleted=0"
	endif

	oSel:=SQLSelectPagination{"select "+cFields+" from "+cFrom+" where "+cWhere+iif(Empty(cFilter),"",iif(Empty(cWhere),""," and ")+"("+cFilter+")")+" order by "+cOrder+Collate,oConn}
	IF lUnique .and. oSel:RecCount=1		
		IF IsMethod(oCaller, #RegPerson)
			oCaller:RegPerson(oSel,cItemname)
		ENDIF	
		RETURN
	ENDIF
	if !ocaller==null_object .and. IsInstanceOf(ocaller,#window)   
		oMyWindow:=oCaller:Owner
	endif
	oPersBw := PersonBrowser{oMyWindow,,oSel,oCaller} 
// 	oPersBw := PersonBrowser{oCaller:Owner,,oSel,oCaller} 
	oPersBw:cWhere:= cWhere
	oPersBw:cFrom:=cFrom
	oPersBw:cOrder:=cOrder
	oPersBw:cFilter:=cFilter
	// 	oPersBw:Found:=Str(oPersBw:oPers:RecCount,-1)
	if !oSel==null_object .and. oSel:RecCount<1
		// use findbutton fields only: 
		cWhere:=""
		cFrom:="person as p" 
		if !Empty(oPersCnt)
			if !Empty(oPersCnt:m56_banknumber) .and.!Empty(oPersCnt:persid) 
				cWhere:="b.persid=p.persid and b.banknumber='"+oPersCnt:m56_banknumber+"'"
				cFrom+=",personbank as b"
				if Empty(cValue)
					cValue:=oPersCnt:m56_banknumber
				endif
			else
				if !Empty(oPersCnt:m51_pos)
					cWhere+=iif(Empty(cWhere),""," and ")+"postalcode like '"+oPersCnt:m51_pos+"%'"
					if Empty(cValue)
						cValue:=oPersCnt:m51_pos
					endif
				elseif !Empty(oPersCnt:m51_lastname)
					cWhere+=iif(Empty(cWhere),""," and ")+"lastname like '"+AddSlashes(oPersCnt:m51_lastname)+"%'"
					if Empty(cValue)
						cValue:=oPersCnt:m51_lastname
					endif
				ENDIF

			endif
			if !Empty(oPersCnt:persid) 
				oPersCnt:persid:=''  // apparently wrong persid
			endif
		endif
		if !Empty(cValue) .and.(Empty(oPersCnt).or.Empty(oPersCnt:m51_lastname))
			If IsDigit(cValue)
				if Len(cValue)>=7.and.isnum(cValue) .and.(Empty(oPersCnt).or.Empty(oPersCnt:m56_banknumber))
					cWhere+=iif(Empty(cWhere),""," and ")+"p.persid=b.persid and b.banknumber='"+cValue+"'"
					cFrom+=",personbank as b" 
				elseif Empty(oPersCnt).or.Empty(oPersCnt:m51_pos)
					cWhere+=iif(Empty(cWhere),""," and ")+"postalcode like '"+StandardZip(cValue)+"%'" 
					cOrder:="postalcode"
				endif
			else
				if sepaenabled .and. IsIban(cValue)
					lParmUni:=true
					cFrom+=",personbank as b" 
					cWhere+=iif(Empty(cWhere),""," and ")+"p.persid=b.persid and b.banknumber='"+cValue+"'"
				elseif Empty(oPersCnt).or.Empty(oPersCnt:m51_lastname)
					// search on name
					cWhere+=iif(Empty(cWhere),""," and ")+"lastname like '"+AddSlashes(cValue)+"%'"
				endif 
			endif
		endif			
		if Empty(cWhere).and.Empty(cFilter)
			cWhere:="1=0"    // impossible condition
		else
			cWhere+= iif(Empty(cWhere),""," and ")+"p.deleted=0"
		endif

		oPersBw:oPers:SQLString:="select "+oPersBw:cFields+" from "+cFrom+iif(Empty(cWhere).and.Empty(cFilter),""," where ")+cWhere+;
			iif(Empty(cFilter),"",iif(Empty(cWhere),""," and ")+"("+cFilter+")")+" order by "+cOrder+Collate 
		oPersBw:oPers:Execute()
		// 		oPersBw:Found:=Str(oPersBw:oPers:RecCount,-1)
	endif 
	//position at current person: 
	if Empty(oPersCnt)
		oPersCnt:=PersonContainer{}
	ENDIF
	// 	if oPersBw:oPers:RecCount>1 .and.!Empty(oPersCnt)
	// 		if !Empty(oPersCnt:current_PersonID) 
	// 			do while !oPersBw:oPers:persid==oPersCnt:current_PersonID
	// 				oPersBw:Skip()
	// 			enddo
	// 		ENDIF
	// 	ENDIF
	oPersBw:PersonSelect(oCaller,cValue,cItemname,lUnique,oPersCnt)	
	RETURN
CLASS PropExtra_Date INHERIT FIELDSPEC


	//USER CODE STARTS HERE (do NOT remove this line)
METHOD Init() CLASS PropExtra_Date
    LOCAL   cPict                   AS STRING

    SUPER:Init( HyperLabel{#PropExtra_Date, "date", "propextra field of type date", "" },  "D", 8, 0 )
    cPict       := "99-99-9999"
    IF SLen(cPict) > 0
        SELF:Picture := cPict
    ENDIF

    RETURN SELF




CLASS Selpers INHERIT DataWindowExtra
	EXPORT cWhereOther:="" as STRING	&& met selektiekonditie
	EXPORT cWherep:="" as STRING	&& where condition for person
	EXPORT cWhereOtherA:={} as ARRAY	&&  array with allowed acc-id for given range of accountnumbers
	EXPORT selx_voorw:="" AS STRING	&& met beschrijving van selektievoorwaarde
	EXPORT selx_keus1 as int	&& primaire keuze tussen verzencodes OF openstaande posten
	EXPORT selx_rek:="" AS STRING	&& gewenst rekeningid van openstaande post/bestemming
	EXPORT selx_AccStart:="" AS STRING	&& gewenst eerste rekeningnr van bestemming
	EXPORT selx_AccEnd:="" AS STRING && gewenste laatste rekeningnr van bestemming
	EXPORT selx_dat AS STRING    && gewenste startdatum als string
	EXPORT selx_start AS DATE  && gewenste startdatum als datum
	EXPORT selx_End AS DATE  && gewenste einddatum als datum
	EXPORT selx_MinAmnt AS INT    && minimum total of payments of a person within the period
	EXPORT selx_MaxAmnt AS INT    && maxumum total of payments of a person within the period
	EXPORT selx_MinIndAmnt as int    && minimum total of payments of a person within the period
	EXPORT selx_ok as LOGIC
	EXPORT SortOrder:="" AS STRING  && gewenste sorteervolgorde
	EXPORT RepCompact AS LOGIC
	EXPORT RepExt AS LOGIC
	EXPORT RepLabel AS LOGIC
	EXPORT RepLetter AS LOGIC
	EXPORT RepGiro AS LOGIC
	EXPORT RepExport AS LOGIC
	EXPORT RepMailcds as LOGIC
	Export ReportAction as int 
	EXPORT lEG, lEO AS LOGIC	&& EG/EO selected?
	
	
	EXPORT oCaller AS OBJECT
	EXPORT cItemName	AS STRING
	EXPORT lUnique, lFoundUnique AS LOGIC
	PROTECT oDue as SQLSelect   && open
	PROTECT oSub as SQLSelect &&pol
	PROTECT oAcc as SQLSelect
	PROTECT oTrans as SQLSelect
	PROTECT oTransH as SQLSelect
	protect cTransH as string
	PROTECT oPers as SQLSelect
	PROTECT oPersBank as SQLSelect
	PROTECT m_fieldnames,m_values,m_AdressLines as ARRAY 
	Export Ann as ARRAY
	PROTECT pKondp, pKondA AS _CODEBLOCK
	PROTECT pKond AS _CODEBLOCK
	PROTECT splaats AS STRING
	PROTECT oExtServer AS OBJECT
	PROTECT oEditPersonWindow as 
	PROTECT m12_bd AS LOGIC
	PROTECT oWindow AS OBJECT
	PROTECT cType AS USUAL
	EXPORT myFields AS ARRAY
	EXPORT AddMailCds, DelMailCds as ARRAY 
	export aExtraProp:={} as array      // for selecting persons via extra properties: {name,type,{values}} 
	export ExportFormat as string 
	export ReportMonth as string 
	export GrpFormat as string
	export oDB as SQLSelect 
	export cFrom:="person as p" as string // list with tables to read from
	protect cFields as string  // fields to be retrieved from the database 
	export cTel,cDay,cNight,cFax,cMobile,cAbrv,cMr,cMrs,cCouple as string  // texts for use in reports 
	protect oLblFrm as LabelFormat
	protect oSpecPers as SelPersExport



	declare method ChangeMailCodes,FillText,MarkUpDestination,AnalyseTxt ,NAW_Compact,NAW_Extended,PrintLetters,RemovePersons
METHOD AnalyseTxt(template as string,DueRequired ref logic,GiftsRequired ref logic,AddressRequired ref logic,RepeatingPossible ref logic,selectionType as int,selx_accid:=0 as int) as void pascal CLASS Selpers
	* Analyse content of template
	LOCAL h1,h2,i as int,repeatedtxt as STRING
	self:m_fieldnames:=AEvalA(GenKeyword(),{|x| {x[2],x[3]}}) && array with [ keyword,category]
	self:m_values:={}
	ASize(self:m_values,Len(self:m_fieldnames))
	AFill(self:m_values,' ')

	IF selectionType=3 .or.;  && selection on regular gifts
		selectionType=2           && selection on due amounts
		* selx_accid: required destination
		self:oAcc:=SQLSelect{"select a.desciption, m.persid from account left join member m on (m.accid=a.accid) where accid='"+Str(selx_accid,-1)+"'",oConn}
		IF oAcc:reccount>0
			self:m_values[AScan(self:m_fieldnames,{|x| x[2]=="b"})]:=AllTrim(oAcc:Description)
			self:MarkUpDestination(oAcc:persid)
		ENDIF
	ENDIF
	IF selectionType=2
		FOR i=1 to Len(self:m_fieldnames)
			IF self:m_fieldnames[i,2]="o"
				IF self:m_fieldnames[i,1] $ template
					DueRequired:=true
					EXIT
				ENDIF
			ENDIF
		NEXT
	ENDIF
	IF selectionType==3 .or.selectionType==4.or.selectionType==5  && selection on regular gifts to a destination
		FOR i=1 to Len(self:m_fieldnames)
			IF self:m_fieldnames[i,2]="g".or.self:m_fieldnames[i,2]="b"
				IF self:m_fieldnames[i,1] $ template
					GiftsRequired:=true
					EXIT
				ENDIF
			ENDIF
		NEXT
	ENDIF
	IF self:m_fieldnames[AScan(self:m_fieldnames,{|x| x[2]="c"}),1] $ template  && complete address?
		AddressRequired:=.t.
	ENDIF
	* Search for repeating group:
	IF selectionType=2.or.selectionType=4 .or.selectionType==5
		h1:=At("[",template)
		h2:=RAt("]",SubStr(template,h1+1))
		IF .not.Empty(h2)
			repeatedtxt:=SubStr(template,h1+1,h2-1)
			FOR i=1 to Len(self:m_fieldnames)
				IF self:m_fieldnames[i,2]="g".or.self:m_fieldnames[i,2]="b".or.self:m_fieldnames[i,2]="o"
					IF self:m_fieldnames[i,1] $ repeatedtxt
						RepeatingPossible:=true
						EXIT
					ENDIF
				ENDIF
			NEXT
		ENDIF
	ENDIF
	RETURN
METHOD ChangeMailCodes(dummy as string) as logic CLASS Selpers
	// add, change or remove mailingcodes of a selection of persons
	LOCAL i,j,iStart,fSecStart as int
	local oStmnt as SQLStatement
	local osel as sqlselect   
	// local oSQL as SQLSelect
	local cStatmnt as string 
	if self:selx_MaxAmnt>0 .or. self:selx_MinAmnt>0 .or. self:selx_MinIndAmnt>0
		ErrorBox{self:oWindow,"You can't combine total amount bounderies with change of mailing codes"}:Show()
		return false
	endif
	(SelPersChangeMailCodes{self}):Show() 
	if !self:selx_Ok
		return false                                         
	endif
	if !Empty(self:DelMailCds)
		// remove mail codes:
		cStatmnt:= "Replace(concat(mailingcodes,' '),'"+AddSlashes(self:DelMailCds[1])+" ','')"	
		FOR j:=2 to Len(self:DelMailCds)
			cStatmnt:= "Replace("+cStatmnt+",'"+AddSlashes(self:DelMailCds[j])+" ','')"
		next
	endif
	if !Empty(self:AddMailCds) 
		// add mail codes
		cStatmnt:="concat("+iif(Empty(cStatmnt),"concat(mailingcodes,' ')",cStatmnt)
		FOR j:=1 to Len(self:AddMailCds)
			cStatmnt+=",if(instr(mailingcodes,'"+addslashes(self:AddMailCds[j])+"')>0,'','"+addslashes(self:AddMailCds[j])+" ')"	
		next
		cStatmnt+=")"
	endif
	// oSQL:=SQLSelect{"select p.persid from "+cFrom+cWherep+" LOCK IN SHARE MODE",oConn}
	// oSQL:Execute()
	osel:=SqlSelect{"select count(*) as cnt FROM "+self:cFrom+cWherep,oConn} 
	if osel:RecCount>0
		if ConI(osel:cnt) > 0
			if ((TextBox{self:oWindow,self:oLan:WGet("Add/remove mailing codes"),self:oLan:WGet("Do you want to add/remove mailing codes")+"("+ConS(osel:cnt)+" " +self:oLan:WGet("persons affected")+")",BUTTONOKAYCANCEL+BOXICONQUESTIONMARK}):Show() == BOXREPLYCANCEL)
				self:Close() 
				return false
			endif   		
			
			oStmnt:=SQLStatement{"update "+self:cFrom+" set p.mailingcodes="+cStatmnt+self:cWherep,oConn}
			// fSecStart:=Seconds()
			// LogEvent(self,oStmnt:SQLString,"logsql")
			oStmnt:Execute()  
			IF !Empty(oStmnt:Status)
				ErrorBox{self:oWindow,"Update failed:"+oStmnt:Status:Description}:Show()
				return false
			else
				(InfoBox{self:oWindow,"Change of mailing codes",self:oLan:WGet('Mailcodes changed of')+Space(1)+Str(oStmnt:NumSuccessfulRows,-1)+Space(1) + self:oLan:WGet("Persons")}):Show()
			endif 
		else
			
			WarningBox{self:oWindow,self:oLan:WGet("Add/remove mailing codes"),self:oLan:WGet("No persons affected")}:Show()

		endif    
		
	endif
	
	RETURN true	

Method Close() Class SelPers 
	if !self:oLblFrm==null_object
		self:oLblFrm:EndWindow()
	endif
	if !self:oSpecPers==null_object
		self:oSpecPers:EndDialog()
	endif
 super:Close()
METHOD ExportPersons(oParent,nType,cTitel,cVoorw) CLASS Selpers
	LOCAL i,j,k, n as int
	LOCAL aMapping, aExpF:={}, aPerF as ARRAY
	LOCAL cCodOms, cCap as STRING
	LOCAL aStreet:={},aCod:={} as ARRAY
	LOCAL lAppend, lDistinct, lDestination, lPropXtr,lgrDat  as LOGIC
	LOCAL cLine,lstnm as STRING
	LOCAL ToFileFS as Filespec
	LOCAL ptrHandle
	LOCAL Name, ID, cGiftsGroup,cGiftsLine, cInvoice as STRING
	local cDateGift,cAmountGift,cDestination as string
	LOCAL myHyp as HyperLabel
	LOCAL myField as FIELDSPEC
	LOCAL oXMLDoc as XMLDocument
	LOCAL TotalAmnt as FLOAT
	LOCAL Donat, cDelim,cApo:='"', cPlaats, cFields, cField, cGroup,CBank, cSQLString as STRING
	local cGrFields,cHaving,cFileName as string 
	local oMarkGrp as MarkUpGiftsgroup 
	local oSQL,oSel as SQLSelect 
	local oBnk as BankAcc
	local sField as symbol
	Local fSecStart as float
	local aType:={'C','L','C','D'} as array // textbx checkbx dropdown DATEFIELD  

	* Determine fields within ExportPersons:
	SetPath(CurPath)
	SetDefault(CurPath)
	AAdd(aExpF,{#SALUTATN,"p.gender", Person_salutation{} })
	AAdd(aExpF,{#TITLE,"p.title", ExportPerson_TITLE{} })
	AAdd(aExpF,{#FIRSTNAME,"p.firstname", ExportPerson_VRN{} })
	AAdd(aExpF,{#INITIALS,"p.initials", ExportPerson_NA2{} })
	AAdd(aExpF,{#PREFIX,"p.prefix", ExportPerson_Vrvgsl{} })
	AAdd(aExpF,{#LASTNAME,"p.lastname", ExportPerson_NA1{} })
	AAdd(aExpF,{#NAMEEXT,"p.nameext", ExportPerson_NA3{} })
	AAdd(aExpF,{#ADDRESS,"p.address", ExportPerson_AD1{} })
	AAdd(aExpF,{#STREET,"p.address", ExportPerson_Street{} })
	AAdd(aExpF,{#HOUSENBR,"p.address", ExportPerson_HOUSNBR{} })
	AAdd(aExpF,{#POSTALCODE,"p.postalcode", ExportPerson_POS{} })
	AAdd(aExpF,{#CITY,"p.city", ExportPerson_PLA{} })
	AAdd(aExpF,{#ATTENTION,"p.attention", ExportPerson_TAV{} })
	AAdd(aExpF,{#COUNTRY,"p.country", ExportPerson_LAN{} })
	AAdd(aExpF,{#TELBUSINESS,"p.telbusiness", ExportPerson_TEL1{} })
	AAdd(aExpF,{#TELHOME,"p.telhome", ExportPerson_TEL2{} })
	AAdd(aExpF,{#FAX,"p.fax", ExportPerson_FAX{} })
	AAdd(aExpF,{#MOBILE,"p.mobile", ExportPerson_Mobile{} })
	AAdd(aExpF,{#EMAIL,"p.email", ExportPerson_EMAIL{} })
	AAdd(aExpF,{#CREATIONDATE,"cast(p.creationdate as date) as creationdate", ExportPerson_BDAT{} })
	AAdd(aExpF,{#ALTERDATE,"cast(p.alterdate as date) as alterdate", ExportPerson_MUTD{} })
	AAdd(aExpF,{#DATELASTGIFT,"cast(p.datelastgift as date) as datelastgift", ExportPerson_DLG{} })
	AAdd(aExpF,{#REMARKS,"p.remarks", ExportPerson_OPM{} })
	AAdd(aExpF,{#MAILCODE,"p.mailingcodes", ExportPerson_MAILCODE{} })
	AAdd(aExpF,{#MAILABBR,"p.mailingcodes", ExportPerson_MAILABBR{} })
	AAdd(aExpF,{#TYPE,"p.type", ExportPerson_TYPE{} })
	AAdd(aExpF,{#GENDER,"p.gender", ExportPerson_GENDER{} })
	AAdd(aExpF,{#BIRTHDATE,"cast(p.birthdate as date) as birthdate", ExportPerson_BIRTHDAT{} })
	AAdd(aExpF,{#persid,"p.persid", ExportPerson_CLN{} })
	AAdd(aExpF,{#EXTERNID, "p.externid", Person_EXTERNID{} })
	AAdd(aExpF,{#BANKNUMBER,"",Bank{} })
	IF self:selx_keus1=4.or.self:selx_keus1=5   && selectie op gift aan bestemming
		AAdd(aExpF,{#GIFTSGROUP,"", Gifts_group{} })
		AAdd(aExpF, {#TOTAMNT,"", Total_Amount{} }) 
		AAdd(aExpF, {#AmountGift,"", AmountGift{} }) 
		AAdd(aExpF, {#Dat,"cast(t.dat as date) as dat", DateGift{} }) 
		AAdd(aExpF, {#Reference,"t.reference", REFERENCE{} }) 
		AAdd(aExpF, {#DOCID,"t.docid", DOCID{} }) 
		AAdd(aExpF, {#Description,"a.description", Destination{} }) 
	ENDIF
	// add extra properties:
	FOR i:=1 to Len(pers_propextra) step 1
		Name:=pers_propextra[i,1]
		ID := "V"+AllTrim(Str(pers_propextra[i,2],-1))
		myHyp:=HyperLabel{String2Symbol(ID),Name,Name}
		myField:=FieldSpec{myHyp,aType[pers_propextra[i,3]+1],10,0}
		AAdd(aExpF,{String2Symbol(ID),"p.propextr",myField,})
	NEXT	

	self:oSpecPers := SelPersExport{self,{aExpF,cTitel}}
	self:oSpecPers:Show()                                       
	IF Empty(self:myFields)
		RETURN FALSE
	ENDIF
	IF (j:=AScan(self:myFields,{|x|x[1]== #GIFTSGROUP}))>0
		oMarkGrp:=MarkupGiftsGroup{self}
		oMarkGrp:Show()
		IF Empty(self:GrpFormat)
			return false
		endif
		cGiftsLine:=self:GrpFormat
	endif
	lPropXtr:=(AScan(self:myFields,{|x|x[2]="p.propextr"})>0)
	oSel:=SqlSelect{SQLGetPersons(self:myFields,self:cFrom,self:cWherep,self:SortOrder,cGiftsLine,self:selx_MinAmnt,self:selx_MaxAmnt,self:selx_minindamnt),oConn}
// 	fSecStart:=Seconds() 
// 	LogEvent(self,oSel:SQlString,"logsql") 
	self:Pointer := Pointer{POINTERHOURGLASS}
	oSel:Execute() 
// 	LogEvent(self,"elapsed time for query:"+Str(Seconds()-fSecStart,-1),"LogSql")
	self:Pointer := Pointer{POINTERARROW}

	(InfoBox{self:oWindow,'Selection of Persons',AllTrim(Str(oSel:RECCOUNT)+ iif(Empty(self:GrpFormat).and.(self:selx_keus1=4.or.self:selx_keus1=5),' gifts',' persons')+' found')}):Show()
	IF oSel:RECCOUNT=0
		return false
	endif

	lAppend:=true
// 	ToFileFS:=AskFileName(oParent,cTitel+" "+DToS(Today())+"."+self:ExportFormat,"Export to file","*"+self:ExportFormat,iif(self:ExportFormat=="TXT","tab separated spreadsheet","comma separated file"),@lAppend)
	ToFileFS:=AskFileName(oParent,cTitel+" "+DToS(Today()),"Export to file","*."+self:ExportFormat,iif(self:ExportFormat=="TXT","tab separated spreadsheet","comma separated file"),@lAppend)
	IF Empty(ToFileFS)
		return false
	endif
	IF self:ExportFormat=="TXT"
		cDelim:=CHR(9)
	else
		cDelim:=Listseparator
	endif
   cDelim:=cApo+cDelim+cApo       // to protect against special characters in fields like ;,CRLF
   
	self:STATUSMESSAGE("Exporting persons, please wait...")
	IF CountryCode=="47".and.!Empty(SDON)
		// determine default donation nbr 
		oSQL:=SQLSelect{"select accnumber from account where accid="+SDON,oConn}
		oSQL:Execute()
		if oSQL:RECCOUNT>0
			Donat:=AllTrim(oSQL:ACCNUMBER)
		endif
	endif
	* Determine mapping:
	aMapping := {}
	for i = 1 to Len(self:myFields)
// 		AAdd(aMapping, {self:MyFields[i,1],oSel:FieldPos(self:MyFields[i,3]:HyperLabel:NameSym) })
		AAdd(aMapping, oSel:FieldPos(self:myFields[i,1]) )
	next
	cFileName:= ToFileFS:FullPath
	IF lAppend
		ptrHandle := FOpen(cFileName,FO_READWRITE	)
	else
		ptrHandle:=MakeFile(,@cFileName,"Exporting to spreadsheet")
	endif
	IF ptrHandle==nil
		RETURN FALSE
	ELSEIF ptrHandle = F_ERROR
		RETURN true
	endif
	IF !lAppend
		* Write heading TO file:
		cLine := self:myFields[1,3]:HyperLabel:Caption
		for i = 2 to Len(self:myFields)
			cLine:=cLine+cDelim+self:myFields[i,3]:HyperLabel:Caption
		next
		FWriteLine(ptrHandle,cApo+cLine+cApo)
	else
		* position file at end:
		FSeek(ptrHandle, 0, FS_END)
	endif
	oSel:GoTop()
	do while !oSel:Eof
		cLine:=""
		if lPropXtr
			oXMLDoc:=XMLDocument{oSel:PROPEXTR}
		endif
		for j = 1 to Len(self:myFields)
			IF j>1
				cLine:=cLine+cDelim
			endif
			IF aMapping[j]=0
				IF self:myFields[j,1]==#MAILCODE
					* Compose mailing codes descriptions:
					* Determine mailcodes:
					cCodOms:=""
					IF .not.Empty(oSel:mailingcodes)
						aCod:=Split(oSel:mailingcodes)  
						for n:=1 to Len(aCod)
							IF Empty(aCod[n])
								loop
							else
								IF (k:=AScan(pers_codes,{|x|x[2]==aCod[n]}))>0
									IF Empty(cCodOms)
										cCodOms:=pers_codes[k,1]
									else
										cCodOms:=cCodOms+", "+pers_codes[k,1]
									endif
								endif
							endif
						next
					endif
					cLine:=cLine+cCodOms
				ELSEIF self:myFields[j,1]==#STREET
					* Determine streetname and housenbr
					cLine:=cLine+GetStreetHousnbr(oSel:address)[1]
				ELSEIF self:myFields[j,1]==#HOUSENBR
					cLine:=cLine+GetStreetHousnbr(oSel:address)[2]
				ELSEIF self:myFields[j,1]==#SALUTATN
					cLine:=cLine+Salutation(oSel:GENDER)
				ELSEIF self:myFields[j,1]==#BANKNUMBER
					cLine:=cLine+ iif(Empty(oSel:banknumbers),'',oSel:banknumbers)
				ELSEIF self:myFields[j,1]==#MAILABBR
					* Compose mailing codes abbreviations:
					* Determine mailcodes:
					cCodOms:=""
					IF .not.Empty(oSel:mailingcodes)
						aCod:=Split(oSel:mailingcodes)  
						for n:=1 to Len(aCod)
							IF Empty(aCod[n])
								loop
							else
								IF (k:=AScan(mail_abrv,{|x|x[2]==aCod[n]}))>0
									IF Empty(cCodOms)
										cCodOms:=mail_abrv[k,1]
									else
										cCodOms:=cCodOms+", "+mail_abrv[k,1]
									endif
								endif
							endif
						next
					endif		
					cLine:=cLine+cCodOms
				elseif lPropXtr
					// extra properties:
					IF oXMLDoc:GetElement(Symbol2String(self:myFields[j,1]))
						if self:myFields[j,3]:ValType='D'
							cLine+=DToC(stod(oXMLDoc:GetContentCurrentElement()))
						else	
							cLine+=oXMLDoc:GetContentCurrentElement()
						endif
					endif
				endif
			else
				IF self:myFields[j,1]==#CITY
					cPlaats := AllTrim(oSel:city)
					IF CITYUPC
						cPlaats:=Upper(cPlaats)
						// 				else
						// 					cPlaats:=Upper(SubStr(cPlaats,1,1))+Lower(SubStr(cPlaats,2))
					endif
					cLine:=cLine+cPlaats 
				ELSEIF self:myFields[j,1]==#LASTNAME
					lstnm:=AllTrim(oSel:lastname)
					IF LSTNUPC
						lstnm:=Upper(lstnm)
						// 				else
						// 					lstnm:=Upper(SubStr(lstnm,1,1))+Lower(SubStr(lstnm,2))
					endif
					cLine:=cLine+lstnm
				ELSEIF self:myFields[j,1]==#TITLE
					cLine:=cLine+Title(oSel:Title)
				ELSEIF self:myFields[j,1]==#GENDER
					cLine:=cLine+GENDERDSCR(oSel:GENDER)
				ELSEIF self:myFields[j,1]==#TYPE
					cLine:=cLine+TYPEDSCR(oSel:TYPE)
				ELSEIF self:myFields[j,1]==#GIFTSGROUP
// 					cLine+=UTF2String{oSel:giftsgroup}:OutBuf   // convert from utf8 to local characters
					cLine+=oSel:giftsgroup
				else
					cLine:=cLine+ AllTrim(Transform(oSel:FIELDGET(aMapping[j]),""))
				endif
			endif
		next
		* Change CRLF to LF (otherwise extra rows:
		cLine:=StrTran(cLine,CRLF,LF)
		FWriteLine(ptrHandle,cApo+cLine+cApo)
		oSel:skip()
	enddo
	
	FClose(ptrHandle)
	// restore default path
	SetPath(CurPath)

	RETURN true
METHOD FillLetters(brief,oRange,lAcceptNorway,oReport) CLASS Selpers
	* Filling of letters
LOCAL  ind_openpost,ind_gift,ind_naw,ind_herh,brfNAW,brfDAT AS LOGIC
LOCAL brfWidth,	brfCol,	brfregn,brfrega,brfCola,brfColt,i,tel,Rij,Blad,teladdr AS INT
LOCAL m96_regels,skipPos AS INT
LOCAL kenmerk,brieftxt,cRegel AS STRING
LOCAL Aantal AS INT
LOCAL SkipPage:=FALSE AS LOGIC
// LOCAL oLan AS Language
Default(@lAcceptNorway,FALSE)

// self:oDue := DueAmount{}
// IF !oDue:Used
// 	self:EndWindow()
// 	RETURN
// ENDIF
// // oDue:SetOrder("OPENPOST")
// oSub := Subscription{}
// IF !oSub:Used
// 	SELF:EndWindow()
// 	RETURN
// ENDIF
// oSub:SetOrder("POL")
// oAcc := Account{}
// IF !oAcc:Used
// 	SELF:EndWindow()
// 	RETURN
// ENDIF
// oAcc:SetOrder("accid") 
// if oLan==null_object
// 	oLan:=Language{}
// endif
// IF !oLan:Used
// 	SELF:EndWindow()
// 	RETURN
// ENDIF
IF SELF:selx_keus1=4.or.SELF:selx_keus1=5   && selectie op gift aan bestemming
// 	self:oTransH := TransHistory{"select t.* from transaction as t where "+self:cWhereOther,oConn}
ENDIF
SELF:AnalyseTxt(brief,@ind_openpost,@ind_gift,@ind_naw,@ind_herh,SELF:selx_keus1,val(SELF:Selx_Rek))
* Haal waarden posities op:
brfNAW := if(WycIniFS:GetInt( "Runtime", "brfNAW" )==1,TRUE,FALSE)
brfDAT := if(WycIniFS:GetInt( "Runtime", "brfDAT" )==1,TRUE,FALSE)
brfWidth := WycIniFS:GetInt( "Runtime", "brfWidth" )
brfCol := WycIniFS:GetInt( "Runtime", "brfCol" )
brfregn := WycIniFS:GetInt( "Runtime", "brfregn" )
brfrega := WycIniFS:GetInt( "Runtime", "brfrega" )
brfCola := WycIniFS:GetInt( "Runtime", "brfCola" )
brfColt := WycIniFS:GetInt( "Runtime", "brfColt" )
IF brfDAT
	kenmerk:= iif(.not.Empty(self:splaats),Trim(self:splaats)+' ','')+cdate
ELSE
	kenmerk:=''
ENDIF
*	Vul evenveel brieven als maximumrange:
IF !Empty(oRange)
	IF Empty(oRange:Max)
		oRange:Max:=self:oDB:RECCOUNT
	ENDIF
ELSE
	oRange:=Range{1,self:oDB:RECCOUNT}
ENDIF
aantal:=oRange:max-oRange:Min+1
IF lAcceptNorway
	ind_openpost:=TRUE
ENDIF
FOR i=oRange:Min TO oRange:Max
	self:oDB:GoTo(i)
	brieftxt:=self:FillText(brief,self:selx_keus1,ind_openpost,ind_gift,ind_naw,ind_herh,brfWidth)
	blad:=0
	teladdr:=1
	SkipPage:=FALSE
	FOR tel=1 TO Max(if(brfNAW,brfregn+5,0),if(brfDAT,brfrega,0))
		IF tel#if(brfDAT,brfrega,0).and.(tel<brfregn.or.tel>brfregn+5.or..not.brfNAW)
			oReport:PrintLine(@Rij,@Blad,' ')
		ELSEIF tel=if(brfDAT,brfrega,0).and.(tel<brfregn.or.tel>brfregn+5.or..not.brfNAW)
			oReport:PrintLine(@Rij,@Blad,Space(if(brfDAT,brfCola,0))+kenmerk)
		ELSEIF tel#if(brfDAT,brfrega,0).and.tel>=brfregn.and.tel<=brfregn+5.and.brfNAW
			oReport:PrintLine(@Rij,@Blad,Space(brfCol)+self:m_AdressLines[teladdr])
			++teladdr
		ELSE
			IF brfCol < if(brfDAT,brfCola,0) .and.brfNAW
				oReport:PrintLine(@Rij,@Blad,Space(brfCol)+;
				self:m_AdressLines[teladdr]+Space(if(brfDAT,brfCola,0)-brfCol+40)+kenmerk)
				++teladdr
			ELSE
				oReport:PrintLine(@Rij,@blad,Space(if(brfDAT,brfCola,0))+kenmerk+;
				IF(brfNAW,Space(brfCol-if(brfDAT,brfCola,0)+8)+self:m_AdressLines[teladdr],""))
				++teladdr
			ENDIF
		ENDIF
	NEXT
	m96_regels:=MLCount(brieftxt,brfWidth-brfColt)
	IF lAcceptNorway
		m96_regels:= Min(m96_regels,38-rij)     // do not print more than 37 lines above acceptgiro
	ENDIF	
	
	oReport:PrintLine(@Rij,@Blad,' ')
	FOR tel = 1 TO m96_regels
		cRegel:=MemoLine(brieftxt,brfWidth-brfColt,tel)
		SkipPos:=At(PAGE_END,cRegel)
		IF SkipPos>0
			IF SkipPos>1
				// print section before page skip:
				oReport:PrintLine(@Rij,@Blad,Space(brfColt)+SubStr(cRegel,1,skipPos-1),;
				{self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%LASTNAME"})],' '})
			ENDIF
			cRegel:=SubStr(cRegel,SkipPos+Len(PAGE_END))
			SkipPos:=0
			IF Empty(cRegel)
				// nothing after page skip
				LOOP
			ENDIF
			rij:=0
		ENDIF
		oReport:PrintLine(@Rij,@Blad,Space(brfColt)+cRegel,;
		{self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%LASTNAME"})],' '})
	NEXT
    IF lAcceptNorway
    	self:oDB:GetGiroNaw()
    	AcceptNorway(oReport,@Rij,@Blad,oLan,Val(self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%TOTALAMOUNT"})]),;
		self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEIDENTIFIER"})],self:oDB,;
    	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DESTINATION"})],self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%INVOICEID"})])
    ENDIF
NEXT
oReport:oRange:=Range{1,aantal} // set range for actual printing of generated pages
// IF !oSub==NULL_OBJECT
// 	IF oSub:Used
// 		oSub:Close()
// 	ENDIF
// 	oSub:=NULL_OBJECT
// ENDIF
// IF !oAcc==NULL_OBJECT
// 	IF oAcc:Used
// 		oAcc:Close()
// 	ENDIF
// 	oAcc:=NULL_OBJECT
// ENDIF

RETURN
METHOD FillText(Template as string,selectionType as int,DueRequired as logic,GiftsRequired as logic,AddressRequired as logic,RepeatingPossible as logic,brfWidth as int) as string CLASS SelPers
	* Filling of template with actual values from the database and returning of completed text
	LOCAL Content:=Template,Line,Asscln,repltxt as STRING
	LOCAL h2,h1,AddrPntr,i,j,tel as int
	LOCAL repeatTxt,repeatSection,repeatGroup as STRING
	LOCAL TotalAmnt:=0.00 as FLOAT 
	self:oPers:=self:oDB

	self:m_AdressLines:=MarkUpAddress(self:oPers,0,0,0)
	Asscln:=Str(self:oDB:persid,-1)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%SALUTATION"})]:=Salutation(self:oPers:Gender)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%TITLE"})]:=Title(self:oDB:Title)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%INITIALS"})]:=self:oDB:initials
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%PREFIX"})]:=self:oDB:prefix
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%LASTNAME"})]:=self:oDB:lastname
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%FIRSTNAME"})]:=self:oDB:firstname
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%NAMEEXTENSION"})]:=self:oDB:nameext
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%ADDRESS"})]:=self:oDB:address
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%ZIPCODE"})]:=self:oDB:postalcode
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%CITYNAME"})]:=self:oDB:city
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%COUNTRY"})]:=self:oDB:country
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%ATTENTION"})]:=self:oDB:attention
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DATEGIFT"})]:=AllTrim(DToC(iif(Empty(self:oDB:datelastgift),null_date,self:oDB:datelastgift)))
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DATELSTGIFT"})]:=AllTrim(DToC(iif(Empty(self:oDB:datelastgift),null_date,self:oDB:datelastgift)))
	// 	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%BANKACCOUNT"})]:=iif(empty(self:oDB:banknumbers),'',split(self:oDB:banknumbers,',')[1]
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%REPORTMONTH"})]:=self:ReportMonth
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%PAGESKIP"})]:=PAGE_END

	j:=AScan(self:m_fieldnames,{|x| x[1]=="%NAMEADDRESS"})
	IF j>0
		self:m_values[j]:=""
		FOR i:=1 to Len(self:m_AdressLines)
			IF Empty(self:m_AdressLines[i])
				loop
			ELSE
				IF Empty(self:m_values[j])
					self:m_values[j]:=self:m_AdressLines[i]
				ELSE
					self:m_values[j]:=self:m_values[j]+CHR(13)+CHR(10)+self:m_AdressLines[i]
				ENDIF
			ENDIF
		NEXT
	ENDIF
	IF selectionType=4.or.selectionType=5  && selectie op gift aan bestemming
		IF GiftsRequired
			self:oTransH:=sqlselect{strtran(self:cTransH,'?',str(self:oDB:persid,-1)),oConn}
			self:oTransH:Execute()
		endif
	endif
	IF RepeatingPossible
		DO WHILE .t.
			repeatGroup:=''
			h1:=AtC("[",Content)
			IF Empty(h1)
				exit
			ENDIF
			h2:=AtC("]",SubStr(Content,h1+1))
			IF Empty(h2)
				exit
			ENDIF
			h2:=h1+h2
			repeatTxt:=SubStr(Content,h1+1,h2-h1-1)
			IF selectionType=4.or.selectionType=5  && selectie op gift aan bestemming
				IF GiftsRequired
					DO WHILE !oTransH:EOF .and.self:oTransH:persid==self:oDB:persid
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DATEGIFT"})]:=DToC(oTransH:dat)
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%AMOUNTGIFT"})]:=Str(oTransH:amountgift,-1)
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DOCID"})]:=oTransH:DOCID
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%REFERENCE"})]:=oTransH:REFERENCE
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DESTINATION"})]:=AllTrim(oTransH:Destination)
						// 								self:MarkUpDestination(oAcc:persid)
						repeatSection:=repeatTxt
						repeatSection:=StrTran(repeatSection,"%DATEGIFT",AllTrim(DToC(oTransH:dat)))
						repeatSection:=StrTran(repeatSection,"%AMOUNTGIFT",Str(oTransH:amountgift,-1))
						repeatSection:=StrTran(repeatSection,"%DOCID",AllTrim(oTransH:DOCID))
						repeatSection:=StrTran(repeatSection,"%REFERENCE",AllTrim(oTransH:REFERENCE))
						repeatSection:=StrTran(repeatSection,"%DESTINATION",oTransH:Destination)
						repeatSection:=StrTran(repeatSection,"%FRSTNAMEDESTINATION",oTransH:FirstnameDestination)
						repeatSection:=StrTran(repeatSection,"%LSTNAMEDESTINATION",oTransH:lastnameDestination)
						// 								repeatSection:=StrTran(repeatSection,"%SALUTDESTINATION",self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%SALUTDESTINATION"})])
						repeatSection:=StrTran(repeatSection,"%PAGESKIP",PAGE_ENd)
						repeatGroup := repeatGroup + repeatSection
						oTransH:skip()
					ENDDO
					self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%TOTALAMOUNT"})]:=Str(self:oDB:totamnt,-1)
				ENDIF
			ENDIF
			Content:=Stuff(Content,h1,h2-h1+1,repeatGroup)
		ENDDO
	ELSE
		IF selectionType=4.or.selectionType=5   && selectie op gift aan bestemming
			* cWhereOther: string met selektiekonditie
			* selx_accid: gewenste bestemming
			IF GiftsRequired
				oTransH:GoTop()
				DO WHILE !oTransH:EOF .and.self:oTransH:persid==self:oDB:persid
					IF oTransH:Eval(pKond,,,1) && &oSelPers:cWhereOther
						IF Empty(self:cWhereOtherA).or.AScan(self:cWhereOtherA,oTransH:accid)>0
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DATEGIFT"})]:=AllTrim(DToC(oTransH:dat))
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%AMOUNTGIFT"})]:=AllTrim(Str(oTransH:cre-oTransH:deb,10,DecAantal))
							TotalAmnt+=oTransH:cre-oTransH:deb
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%transid"})]:=AllTrim(oTransH:transid)
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DOCID"})]:=AllTrim(oTransH:DOCID)
							oAcc:seek(oTransH:accid)
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DESTINATION"})]:=AllTrim(oAcc:Description)
							self:MarkUpDestination(oAcc:persid)
						ENDIF
					ENDIF
					oTransH:skip()
				ENDDO
			ENDIF
		ENDIF
	ENDIF

	FOR i=1 to Len(self:m_fieldnames)
		IF self:m_fieldnames[i,2]#"c"
			Content:=StrTran(Content,self:m_fieldnames[i,1],self:m_values[i])
		ENDIF
	NEXT
	IF AddressRequired
		* Compleet adres invullen:
		DO WHILE true
			FOR tel = 1 to MLCount(Content,brfWidth)
				Line:=MemoLine(Content,brfWidth,tel)
				AddrPntr:=AtC("%NAMEADDRESS",Line)  && Zorgen voor inspringen
				IF AddrPntr>0
					repltxt:=StrTran(self:m_values[AScan(self:m_fieldnames,{|x| x[2]=="c"})],CHR(13)+CHR(10),CHR(13)+CHR(10)+Space(AddrPntr-1))
					Content:=StrTran(Content,"%NAMEADDRESS",repltxt,,1)
					exit
				ENDIF
			NEXT
			IF .not."%NAMEADDRESS" $ Content
				exit
			ENDIF
		ENDDO
	ENDIF
	RETURN Content
METHOD INIT(oParent , uExtra , oPerson ) CLASS SelPers
	self:oWindow:=oParent
	Default(@uExtra,null_string)
	self:cType:=uExtra
	IF !Empty(oPerson) .and. IsInstanceOf(oPerson,#SQLSelectPerson) 
		self:oDB:=oPerson
		self:oPers:=oPerson
	ENDIF                                                  
	self:oLan:=Language{} 
	cCouple:= oLan:Rget("Mr&Mrs")
	cMr:= oLan:Rget("Mr",,"!")
	cMrs:= oLan:Rget("Mrs",,"!")
	cTel:=oLan:Rget("Telephone",,"!")
	cDay:=oLan:Rget('at day')
	cNight:=oLan:Rget("at night")
	cAbrv:=oLan:Rget("Abbreviated mailingcodes")
	cFax:=oLan:Rget("fax")
	cMobile:=oLan:Rget("mobile")

	RETURN SELF
	
METHOD MarkUpDestination(persid as int) as void pascal CLASS SelPers
	* Markup values for template fields %FRSTNAMEDESTINATION,%LSTNAMEDESTINATION and %SALUTDESTINATION
	LOCAL name as STRING 
	local oPers as SQLSelectPerson
	IF !Empty(persid)   && member
		oPers:=SQLSelectPerson{"select lastname,prefix,firstname,gender from person where persid='"+Str(persid,-1)+"'",oConn}
		IF oPers:reccount>0
			name:=AllTrim(oPers:lastname)
			IF .not. Empty(oPers:prefix)
				name:=AllTrim(oPers:prefix)+' '+name
			ENDIF
			self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%LSTNAMEDESTINATION"})]:=name

			self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%FRSTNAMEDESTINATION"})]:=AllTrim(oPers:firstname)
			self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%SALUTDESTINATION"})]:=AllTrim(oPers:Salutation)
		ENDIF
	ENDIF
	RETURN


	
METHOD NAW_Compact(nRow ref int, nPage ref int ,Heading as array, oReport as Printjob,oSel as SQLSelect)as void pascal CLASS Selpers
* Compact NAC-list
* self: server
LOCAL ht, hu as STRING, mopm as STRING

ht:=GetFullNAW(Str(oSel:persid,-1))
hu := Space(6)
IF .not.Empty(oSel:FIELDGET(#telbusiness) )
    hu  :=  hu+if(Empty(oSel:FIELDGET(#TELHOME)),"",self:cDay+": ");
	+oSel:FIELDGET(#telbusiness)
ENDIF
IF .not.Empty(oSel:FIELDGET(#TELHOME) )
    hu  :=  hu+if(Empty(hu),"",", "+self:cNight+": ");
	+oSel:FIELDGET(#TELHOME)
ENDIF
IF .not.Empty(oSel:FIELDGET(#FAX))
    hu  :=  hu+" "+self:cFax+":"+oSel:FIELDGET(#FAX)
ENDIF
IF .not.Empty(oSel:FIELDGET(#Mobile) )
    hu  :=  hu+" "+self:cMobile+":"+oSel:FIELDGET(#Mobile)
ENDIF
IF .not.Empty(oSel:FIELDGET(#firstname))
   hu  :=  Pad(hu,59)+Trim(oSel:FIELDGET(#firstname))
ENDIF
mopm := MemoLine(ht,73,1)
oReport:PrintLine(@nRow,@nPage,mopm,Heading,if(Empty(hu),nil,2))
mopm := MemoLine(ht,73,2)
IF .not.Empty(mopm)
   oReport:PrintLine(@nRow,@nPage,Space(6) + AllTrim(mopm),Heading)
ENDIF
IF .not.Empty(hu)
   oReport:PrintLine(@nRow,@nPage,hu,Heading)
ENDIF
RETURN 
METHOD NAW_Extended(nRow ref int, nPage ref int ,Heading as array, oReport as Printjob,oSel as SQLSelect) as void pascal CLASS Selpers
	* Uitgebreide personenlijst
	LOCAL roud,i,n, nWidth, nInspr as int,inspring, regel, mopm, cCodOms, cCodAbr as STRING
	LOCAL m_AdressLines as ARRAY
	LOCAL mCodH as USUAL

	inspring := Str(oSel:persid,-1)+' '
	nWidth:=79-(nInspr:=Len(inspring))
	m_AdressLines := MarkUpAddress(oSel,0,nWidth,0)
	oReport:PrintLine(@nRow,@nPage,,Heading,6)
	FOR i = 1 to 6
		regel := m_AdressLines[i]
		IF .not. Empty(regel)
			oReport:PrintLine(@nRow,@nPage,inspring + AllTrim(regel),Heading)
			inspring:=Space(nInspr)
		ENDIF
		IF i=1 .and. .not.Empty(oSel:firstname) .and. !sFirstNmInAdr
			oReport:PrintLine(@nRow,@nPage,inspring + oSel:firstname,Heading)
			inspring:=Space(nInspr)
		ENDIF
	NEXT
	IF .not.Empty(oSel:telbusiness).or.!Empty(oSel:telhome)
		oReport:PrintLine(@nRow,@nPage,inspring + self:cTel+" - "+;
			self:cDay+":"+oSel:telbusiness+" - "+self:cNight+":"+oSel:telhome,Heading)
	ENDIF
	IF .not.Empty(oSel:mobile).or.!Empty(oSel:fax)
		oReport:PrintLine(@nRow,@nPage,inspring +;
			self:cFax+":"+oSel:fax+" - "+self:cMobile+":"+oSel:mobile,Heading)
	ENDIF
	IF .not.Empty(oSel:mailingcodes)
		FOR i:=1 to 28 step 3
			mCodH  := SubStr(oSel:mailingcodes,i,2)
			IF !Empty(mCodh).and.(n:=AScan(pers_codes,{|x|x[2]==mCodH}))>0
				IF Empty(cCodOms)
					cCodOms:=pers_codes[n,1]
				ELSE
					cCodOms:=cCodOms+", "+pers_codes[n,1]
				ENDIF
				IF Empty(cCodAbr)
					cCodAbr:=mail_abrv[n,1]
				ELSE
					cCodAbr+=", "+mail_abrv[n,1]
				ENDIF
			ENDIF
		NEXT
		IF !Empty(cCodAbr)
			oReport:PrintLine(@nRow,@nPage,Space(6)+self:cAbrv+": "+cCodAbr,Heading,2)
			cCodAbr:=""
		ENDIF
		i:=1
		mopm:=MemoLine(cCodOms,nWidth,1)
		DO WHILE !(mopm:=MemoLine(cCodOms,nWidth,i))==null_string
			oReport:PrintLine(@nRow,@nPage,inspring + AllTrim(mopm),Heading)
			++i
		ENDDO
	ENDIF
	FOR i=1 to 6
		mopm:=MemoLine(oSel:remarks,nWidth,i)
		IF .not.Empty(mopm)
			oReport:PrintLine(@nRow,@nPage,inspring + AllTrim(mopm),Heading)
		ENDIF
	NEXT
	roud:=nRow
	oReport:PrintLine(@nRow,@nPage,,Heading)
	IF nRow=roud
		oReport:PrintLine(@nRow,@nPage,' ',Heading)
	ENDIF

	RETURN 
METHOD PrintLabels(oParent,nType,cTitel,cVoorw) CLASS Selpers

LOCAL lLabel := TRUE AS LOGIC
LOCAL lReady AS LOGIC
LOCAL oFromTo:=Range{1,1} as Range
local nMax as int
local oReport as PrintDialog 
local oPers as SQLSelect
cFields:="p.persid, p.lastname,p.gender,p.title,p.attention,p.initials,p.nameext,p.prefix,p.firstname,p.address,p.postalcode,p.city,p.country"  	
	
oPers:=SqlSelect{UnionTrans("Select distinct "+cFields+" from "+ cFrom+cWherep)+" order by "+self:SortOrder+Collate,oConn} 
oPers:Execute()
(InfoBox{self:oWindow,'Selection of Persons',AllTrim(Str(oPers:RECCOUNT)+ ' persons found')}):Show()
if oPers:RECCOUNT=0
	return false
endif
DO WHILE !lReady
	(self:oLblFrm := LabelFormat{oParent}):Show()
	IF self:oLblFrm:lCancel
		RETURN FALSE
	ENDIF
	oReport := PrintDialog{oParent,cTitel,lLabel}
	nMax:=Ceil(oPers:RECCOUNT/ (oReport:oPrintJob:nLblColCnt * oReport:oPrintJob:nLblVertical) )
	oFromTo:Max:=nMax
	IF !Empty(oFromTo)
		oReport:InitRange(oFromTo)
	ENDIF
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	oFromTo := oReport:oRange
// 	nMax:=Ceil(oPers:RECCOUNT/ (oReport:oPrintJob:nLblColCnt * oReport:oPrintJob:nLblVertical) )
// 	oFromTo:Min := Min(oReport:oRange:Min+1,nMax)
	oPers:GoTop()
	oReport:oPrintJob:oPers:=oPers
// 	oReport:CopyPers(oPers)
	oReport:prstart()
	lReady := oReport:oPrintJob:lLblFinish
	oReport:prstop()
ENDDO 

RETURN TRUE
METHOD PrintLetters(oParent as window,nType:=4 as int,cTitel:="" as string,lAcceptNorway:=false as logic) as logic CLASS Selpers

	LOCAL oLtrFrm AS LetterFormat
	LOCAL lReady AS LOGIC
	LOCAL oFromTo:=Range{} as Range
	LOCAL brfWidth AS INT
	LOCAL nTo AS INT
	local oReport as PrintDialog 
	local oSel as SQLSelect 
	local cGroup,cHaving,cSQLString,cGrFields as string 
	
	self:splaats:=SQLSelect{"select cityletter from sysparms",oConn}:cityletter
	cFields:="p.persid, p.lastname,p.gender,p.title,p.attention,p.initials,p.nameext,p.prefix,p.firstname,p.address,p.postalcode,p.city,p.country,"+;
	"cast(p.datelastgift as date) as datelastgift"   	
	IF self:selx_keus1=4.or.self:selx_keus1=5   && selection gifts
		cFields+=",t.cre-t.deb as amountgift"
		cGrFields:="gr.*,sum(gr.amountgift) as totamnt"
		if self:selx_MinIndAmnt>0
			cGrFields+=",max(amountgift) as maxamnt" 
		endif
		cGroup:=" group by p.persid"
		if self:selx_MinAmnt>0 .and. self:selx_MaxAmnt>0
			cHaving:=" having totamnt between "+Str(self:selx_MinAmnt,-1)+" and "+Str(self:selx_MaxAmnt,-1) 
		elseif self:selx_MinAmnt>0
			cHaving:=" having totamnt >= "+Str(self:selx_MinAmnt,-1)
		elseif self:selx_MaxAmnt>0
			cHaving:=" having totamnt <= "+Str(self:selx_MaxAmnt,-1)
		endif
		if self:selx_MinIndAmnt>0
			cHaving+=iif(Empty(cHaving)," having "," and ")+"maxamnt >= "+Str(self:selx_minindamnt,-1)
		endif
      cSQLString:=UnionTrans("Select distinct "+cFields+" from "+ self:cFrom+self:cWherep)
      self:oDB:=SqlSelect{"select "+cGrFields+" from ("+cSQLString+") as gr group by gr.persid "+cHaving+" order by "+self:SortOrder+Collate,oConn}
	else
		self:oDB:=SqlSelect{UnionTrans("Select distinct "+cFields+" from "+ self:cFrom+self:cWherep)+" order by "+self:SortOrder+Collate,oConn} 
	endif
//    LogEvent(self,self:oDB:sqlString,"logsql")
	self:oDB:Execute()
	(InfoBox{self:oWindow,'Selection of Persons',AllTrim(Str(self:oDB:RECCOUNT)+ ' persons found')}):Show()
	if !self:oDB:RECCOUNT=0 
		IF self:selx_keus1=4.or.self:selx_keus1=5   && selection gifts
			self:cTransH:=UnionTrans("select t.cre-t.deb as amountgift,t.dat,t.docid,t.reference,t.persid,a.description as destination,"+;
			"pd.firstname as firstnamedestination,pd.lastname as lastnamedestination "+;
			"from transaction t, person p, account a left join member m on (m.accid=a.accid) left join person pd on(pd.persid=m.persid) "+;
			"where a.accid=t.accid and "+self:cWhereOther+" and t.persid=? order by p."+self:SortOrder+Collate)
		endif
		DO WHILE !lReady
			(oLtrFrm := LetterFormat{oParent,,,lAcceptNorway}):Show()
			IF oLtrFrm:lCancel
				RETURN FALSE
			ENDIF
			brfWidth := WycIniFS:GetInt( "Runtime", "brfWidth" )
			oReport := PrintDialog{oParent,cTitel,,brfWidth}
			oReport:InitRange(Range{nTo+1,self:oDB:RECCOUNT})
			oReport:Show()
			IF .not.oReport:lPrintOk
				RETURN FALSE
			ENDIF
			nTo:=oReport:oRange:Max 
// 			oDB:GoTo(oReport:oRange:Min)
			self:FillLetters(oLtrFrm:brief,oReport:oRange,lAcceptNorway,oReport)
			oReport:prstart()
			lReady := oReport:oPrintJob:lLblFinish
			oReport:prstop()
			IF lReady
				IF oReport:oRange:Max<self:oDB:RECCOUNT
					lReady:=FALSE
				ENDIF
			ENDIF
		ENDDO
	endif
	RETURN true
METHOD PrintPersonList(oParent,nType,cTitel,cVoorw) CLASS Selpers
	LOCAL kopregels AS ARRAY
	LOCAL nRow as int
	LOCAL nPage as int
	LOCAL i as int
	Local fSecStart as float
	local oSel as SQLSelect 
local oReport as PrintDialog
	

	if self:ReportAction=1
		cFields:="p.persid, p.lastname,p.gender,p.title,p.initials,p.prefix,p.firstname,p.address,p.postalcode,p.city,p.country,p.telbusiness,p.telhome,p.fax,p.mobile,ifnull(p.remarks,'') as remarks"  
	else
		cFields:="p.persid, p.lastname,p.gender,p.title,p.attention,p.initials,p.nameext,p.prefix,p.firstname,p.address,p.postalcode,p.city,p.country,p.telbusiness,p.telhome,p.fax,p.mobile,ifnull(p.remarks,'') as remarks,p.mailingcodes"  	
	endif
	
	oSel:= SqlSelect{UnionTrans("Select distinct "+cFields+" from "+ self:cFrom+self:cWherep)+" order by "+self:SortOrder+Collate,oConn} 
	
	oSel:Execute()
	(InfoBox{self:oWindow,'Selection of Persons',AllTrim(Str(oSel:RECCOUNT)+ ' persons found')}):Show() 
	if oSel:RECCOUNT<1
		return false
	endif
  	oReport := PrintDialog{oParent,cTitel,,79}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	oParent:Pointer := Pointer{POINTERHOURGLASS}
	kopregels := {self:oLan:Rget('PERSONS',,"@!")}
	FOR i=1 to MLCount(cVoorw,79)
		AAdd(kopregels,MemoLine(cVoorw,79,i))
	NEXT
	AAdd(kopregels,' ')

	nRow := 0
	nPage := 0

	oSel:GoTop()
// 	fSecStart:=Seconds()
	do while !oSel:Eof
		IF nType = 1
			self:NAW_Compact(@nRow,@nPage, kopregels,oReport,oSel)
		ELSE
			self:NAW_Extended(@nRow,@nPage, kopregels,oReport,oSel)
		ENDIF
		oSel:skip()
	enddo
// 	LogEvent(self,"elapsed time for print:"+Str(Seconds()-fSecStart,-1),"LogSql")

	oReport:PrintLine(@nRow,@nPage,'',kopregels,1)
	oReport:PrintLine(@nRow,@nPage,Str(oSel:RECCOUNT,-1)+' '+self:oLan:Rget('Persons',,"!"),kopregels)
	oReport:prstart()
	oReport:prstop()
	RETURN TRUE
METHOD PrintToOutput(oWindow,aTitle,TitleExtra) CLASS SelPers
	LOCAL lSucc as LOGIC
	LOCAL i:=self:ReportAction as int
	Default(@TitleExtra,null_string)
	* Print de opgegeven reports:
	lSucc:=FALSE 
	self:Pointer := Pointer{POINTERHOURGLASS}

	// FOR i=1 to 7
	DO CASE
	CASE i=1
		lSucc:=self:PrintPersonList(oWindow,i,aTitle[i]+TitleExtra,self:selx_voorw+TitleExtra)
	CASE i=2
		lSucc:=self:PrintPersonList(oWindow,i,aTitle[i]+TitleExtra,self:selx_voorw+TitleExtra)
	CASE i=3
		lSucc:=self:PrintLabels(oWindow,i,aTitle[i]+TitleExtra,self:selx_voorw+TitleExtra)
	CASE i=4
		lSucc:=self:PrintLetters(oWindow,i,aTitle[i]+TitleExtra)
// 	CASE i=5
// 		IF CountryCode=="47"
// 			lSucc:=self:PrintLetters(oWindow,i,aTitle[i]+TitleExtra,true)
// 		ELSE
// 			lSucc:=self:PrintAccepts(oWindow,i,aTitle[i]+TitleExtra)
// 		ENDIF
	CASE i=6
		lSucc:=self:EXPORTPersons(oWindow,i,aTitle[i]+TitleExtra)
	CASE i=7
		lSucc:=self:ChangeMailCodes("")
	CASE i=8
		lSucc:=self:RemovePersons("")
	ENDCASE
	// NEXT 
// 	self:Pointer := Pointer{POINTERARROW}

	return lSucc
METHOD RemovePersons(dummy as string) as logic CLASS Selpers
// add, change or remove mailingcodes of a selection of persons
LOCAL i,j,iStart,fSecStart as int
local oStmnt as SQLStatement 
// local oSQL as SQLSelect
local cStmnt as string
if self:selx_MaxAmnt>0 .or. self:selx_MinAmnt>0 .or. self:selx_MinIndAmnt>0
	ErrorBox{self:oWindow,"You can't combine total amount bounderies with removal of persons"}:Show()
	return false
endif
SelPersRemovePers{self}:Show() 
if !self:selx_Ok
	return false
endif 

METHOD Show() CLASS SelPers
	// LOCAL kopregels AS ARRAY
	// LOCAL nRow AS INT
	// LOCAL nPage AS INT
	LOCAL i as int, ind as int
	LOCAL lSucc as LOGIC
	LOCAL CurCln  as STRING, CurTotal:=0 as FLOAT
	LOCAL aPerson:={} as ARRAY // array with personnbrs, TotalAamount
	LOCAL aTitle := {'Compact Person report','Extended Person report','Labels',;
		'Letters','Giro accepts','Export persons','Add/Remove Mailing Codes'}
	LOCAL RekIdEnd as STRING
	LOCAL aRekId as ARRAY // copy of KondA
	Local oStmnt as SQLStatement 
	// LOCAL oXMLDoc as XMLDocument, uFieldValue as usual, extrafound:=false as logic

	self:selx_Ok:=true 
	* bepaal gewenste selectie:
	IF cType=="REMINDERS".or.cType=="DONATIONS".or.cType=="SUBSCRIPTIONS"
		self:selx_keus1 := 2
	ELSEIF cType=="STANDARD GIVERS"
		self:selx_keus1 := 3
	ELSEIF cType=="MAILINGCODE"
		self:selx_keus1 := 1
	ELSEIF cType=="THANKYOU"
		self:selx_keus1 := 4
	ELSEIF cType=="FIRSTGIVERS"
		self:selx_keus1 := 1
	ELSEIF cType=="FIRSTNONEAR"
		self:selx_keus1 := 1
	ELSE
		(SelPersPrimary{self:oWindow,self}):Show()
	ENDIF 

	IF self:selx_Ok
		IF self:selx_keus1 == 2
			(SelPersOpen{,{self,cType}}):Show()
			self:cFrom+=",dueamount as d,subscription as t"
			self:cWhereOther+=iif(Empty(self:cWhereOther),""," and ")+"p.persid=t.persid" 
			// 		ELSEIF self:selx_keus1 == 3
			// 			(SelPersGifts{oWindow,SELF}):Show()
			// 			self:cFrom+=",subscription as t"
			// 			self:cWhereOther+=iif(Empty(self:cWhereOther),""," and ")+"p.persid=t.personid" 
		ELSEIF self:selx_keus1 == 4
			//		(SelPersPayments{oWindow,SELF}):Show()
			(SelPersPayments{,,,self}):Show()
			IF self:selx_MinAmnt>0.or. self:selx_MaxAmnt>0 // selection of minimum total amount:
				self:selx_keus1 := 5
			ENDIF
			self:cFrom+=",transaction as t"
			self:cWhereOther+=iif(Empty(self:cWhereOther),""," and ")+"p.persid=t.persid" 
		ENDIF
	ELSE
		self:Close()
		RETURN
	ENDIF
	IF self:selx_Ok
		(SelPersMailCd{,{self,cType}}):Show()
	ELSE
// 		self:EndWindow()
		self:Close()
		RETURN
	ENDIF
	IF !self:selx_Ok
// 		self:EndWindow()
		RETURN
	ENDIF
	IF IsNil(self:cWhereOther)
		self:cWhereOther:=null_string
	ENDIF
	IF IsNil(self:cWherep)
		self:cWherep:=null_string
	ENDIF
	if !(Empty(self:cWherep).and.Empty(self:cWhereOther))
		if Empty(self:cWherep)
			self:cWherep:=" where "+self:cWhereOther
		else
			self:cWherep:=" where "+self:cWherep+iif(Empty(self:cWhereOther),""," and "+self:cWhereOther)
		endif
	endif
	// 	self:cWherep+=" and p.persid>0"
	IF !Empty(self:selx_AccStart) .and. !Empty(self:selx_AccStart) .and. !self:selx_AccStart==self:selx_Accend 
		// range of account numbers:
		self:cFrom+=",account as a"
		// 		self:cWherep+=" and a.accid=t.accid and a.accnumber between '"+self:selx_AccStart+"' and '"+self:selx_Accend+"'"	
		self:cWherep+=" and t.accid=a.accid "	
	endif

	self:oDB:=SQLSelect{"",oConn}
// 	self:oWindow:Pointer := Pointer{POINTERARROW}

	self:oWindow:=GetParentWindow(self)

// 	self:oWindow:Pointer := Pointer{POINTERHOURGLASS}
// 	self:oWindow:STATUSMESSAGE("Producing reports, please wait...")

	* Print the required report: 

	lSucc:=self:PrintToOutput(self:oWindow,aTitle,"")
	self:oWindow:Pointer := Pointer{POINTERARROW}

	IF lSucc
		* remove eventually EG/EO-codes:
		IF self:lEG .or. self:lEO  // EG or EO selected?
			* Ask for removing codes:
			IF (TextBox{self:oWindow, "Printing of persons", "Has code for "+;
					IF(self:lEG,"First gift received","") +;
					IF(self:lEO,if(self:lEG," and ","")+"First non-earm gift","")+" to be removed?",;
					BUTTONYESNO}):Show() == BOXREPLYYES
				* remove the codes:
				if self:lEG .and. self:lEO
					oStmnt :=SQLStatement{;
						"update person set mailingcodes=replace(replace(mailingcodes,'EG','FI'),'EO','FI') where instr(mailingcodes,'EG')>0 or instr(mailingcodes,'EO')>0)",oConn}
				elseif self:lEG
					oStmnt :=SQLStatement{;
						"update person set mailingcodes=replace(replace(replace(mailingcodes,'EG','FI'),'FI FI ','FI '),'FI FI','FI') where instr(mailingcodes,'EG')>0",oConn}
				else //EO
					oStmnt :=SQLStatement{;
						"update person set mailingcodes=replace(replace(replace(mailingcodes,'EO','FI'),'FI FI ','FI '),'FI FI','FI') where instr(mailingcodes,'EO')>0",oConn}
				endif
				oStmnt:Execute()
			ENDIF
		ENDIF
	ENDIF
   self:Close()
	RETURN
Method ExtraPropCondition(aPropExValues as array) as void Pascal Class SelPersMailCd
	// compose extra properties selection condition: 
LOCAL cExtra as string
local i,j as int
if Empty(aPropExValues)
	return 
endif
for i:=1 to Len(aPropExValues) 
	if i>1
		cExtra+=" and "
	endif
	for j:=1 to Len(aPropExValues[i,3])
		if aPropExValues[i,2]=DATEFIELD
			cExtra+=iif(j==1,"("," or ")+"p.propextr like '%<"+aPropExValues[i,1]+">_%</"+aPropExValues[i,1]+">%' and substr(p.propextr,instr(p.propextr,'</"+aPropExValues[i,1]+">')-8,8)"+aPropExValues[i,3,j]      			
		else
			cExtra+=iif(j==1,"("," or ")+"p.propextr like '%<"+aPropExValues[i,1]+">"+iif(aPropExValues[i,2]=TEXTBX,'%','')+aPropExValues[i,3,j]+iif(aPropExValues[i,2]=TEXTBX,'%','')+"</"+aPropExValues[i,1]+">%'"      //<name> value </name>
		endif			
	next
	cExtra+=")"
next
oCaller:cWherep := if(Empty(oCaller:cWherep),"",;
oCaller:cWherep+" and ") + cExtra 

return 
METHOD InitExtraProperties() CLASS SelPersMailCd
	// Initialize extra properties
	LOCAL count as int
	LOCAL left:=true as LOGIC, first:=true as LOGIC
// 	if Len(pers_propextra)<1 
// 		self:oDCExtraPropGroup:Hide()
// 	else	
	if Len(pers_propextra)>0 
		FOR count:=1 to Len(pers_propextra) step 1
			self:SetPropExtra(count,Left)
			left:=!left
		NEXT 
	endif
	RETURN nil
METHOD MakeAndCod() CLASS SelPersMailCd
* Compose mailingcodes from parts andCod1 .. anandCod
	LOCAL aCod := {} as array
	LOCAL i AS INT
	LOCAL cCod  AS STRING
	LOCAL cTekst AS STRING
	aCod:=self:oDCandCod:GetSelectedItems()

	IF !Empty(aCod)
		FOR i=1 TO Len(aCod)
			cCod := cCod +if(i=1,'(',' and ')+"instr(p.mailingcodes,'"+AddSlashes(aCod[i])+"')>0"
			cTekst := cTekst +if(i=1,'(',' and ')+GetMailAbrv(aCod[i])
			IF "EG"==aCod[i]
				oCaller:lEG:=TRUE
			ENDIF
			IF "EO"==aCod[i]
				oCaller:lEO:=TRUE
			ENDIF
		NEXT
		self:oCaller:cWherep := if(Empty(self:oCaller:cWherep),"",;
		self:oCaller:cWherep+" and ") + cCod + ")"
		self:oCaller:selx_voorw := if(Empty(self:oCaller:selx_voorw),"",;
		self:oCaller:selx_voorw+" and ") + cTekst + ")"
	ENDIF
RETURN TRUE
METHOD MakeNonCod() CLASS SelPersMailCd
* Compose mailingcodes from parts NonCod1 .. anNonCod
	LOCAL aCod3 AS ARRAY
	LOCAL i AS INT
	LOCAL cCod  AS STRING
	LOCAL cTekst AS STRING
	
	aCod3:=self:oDCNonCod:GetSelectedItems()
	IF !Empty(aCod3)
		FOR i=1 TO Len(aCod3)
			cCod := cCod +if(i=1,'(',' and ')+"instr(p.mailingcodes,'"+AddSlashes(aCod3[i])+"')=0"
			cTekst := cTekst +if(i=1,'(not ',' and not ')+GetMailAbrv(aCod3[i])
			IF "EG"==aCod3[i]
				oCaller:lEG:=FALSE
			ENDIF
			IF "EO"==aCod3[i]
				oCaller:lEO:=FALSE
			ENDIF
		NEXT
		oCaller:cWherep := if(Empty(oCaller:cWherep),"",;
		oCaller:cWherep+" and ") + cCod + ")"
		oCaller:selx_voorw := if(Empty(oCaller:selx_voorw),"",;
		oCaller:selx_voorw+" and ") + cTekst + ")"
	ENDIF
RETURN TRUE
METHOD MakeOrCod() CLASS SelPersMailCd
* Compose mailingcodes from parts orCod1 .. anorCod
	LOCAL aCod2 AS ARRAY
	LOCAL i AS INT
	LOCAL cCod  AS STRING
	LOCAL cTekst AS STRING
	aCod2:=self:oDCOrCod:GetSelectedItems()
	IF !Empty(aCod2)
		FOR i=1 TO Len(aCod2)
			cCod := cCod +if(i=1,'(',' or ')+"instr(p.mailingcodes,'"+AddSlashes(aCod2[i])+"')>0"
			cTekst := cTekst +if(i=1,'(',' or ')+GetMailAbrv(aCod2[i])
			IF "EG"==aCod2[i]
				oCaller:lEG:=TRUE
			ENDIF
			IF "EO"==aCod2[i]
				oCaller:lEO:=TRUE
			ENDIF
		NEXT
		oCaller:cWherep := if(Empty(oCaller:cWherep),"",;
		oCaller:cWherep+" and ") + cCod + ")"
		oCaller:selx_voorw := if(Empty(oCaller:selx_voorw),"",;
		oCaller:selx_voorw+" and ") + cTekst + ")"
	ENDIF
RETURN TRUE
METHOD MakeOrGender() CLASS SelPersMailCd
* Compose Gender condition from selected genders
	LOCAL aGender AS ARRAY
	LOCAL i AS INT
	LOCAL cGender:=","  AS STRING
	LOCAL cTekst AS STRING
	aGender:=self:oDCGenders:GetSelectedItems()

	IF !Empty(aGender)
		cGender := Implode(aGender,",")
		FOR i=1 to Len(aGender)
			cTekst := cTekst +if(i=1,'(',' or ')+pers_gender[AScan(pers_gender,{|x|x[2]==aGender[i]}),1]
		NEXT
		oCaller:cWherep := if(Empty(oCaller:cWherep),"",;
		oCaller:cWherep+" and ")+"p.gender in ("+cGender+")"
		oCaller:selx_voorw := if(Empty(oCaller:selx_voorw),"",;
		oCaller:selx_voorw+" and ") + cTekst + ")"
	ENDIF
RETURN TRUE
METHOD MakeOrType() CLASS SelPersMailCd
* Compose Type condition from selected types
	LOCAL aType AS ARRAY
	LOCAL i AS INT
	LOCAL cType:=","  AS STRING
	LOCAL cTekst AS STRING
	aType:=self:oDCTypes:GetSelectedItems()

	IF !Empty(aType)
		cType :=Implode(aType,",")
		
		FOR i=1 to Len(aType)
			cTekst += iif(i=1,'(',' or ')+pers_types[AScan(pers_types,{|x|x[2]==aType[i]}),1]
		NEXT
// 		oCaller:cWherep+" and ")+"(','+Str(Type,-1)+','$'" + cType + "')"
		oCaller:cWherep := iif(Empty(oCaller:cWherep),"",;
		oCaller:cWherep+" and ")+"p.type in ("+cType+")"
		oCaller:selx_voorw := if(Empty(oCaller:selx_voorw),"",;
		oCaller:selx_voorw+" and ") + cTekst + ")"
	ENDIF
RETURN TRUE
METHOD SetPropExtra( count, Left) CLASS SelPersMailCd
	LOCAL oSingle as SingleLineEdit
	LOCAL oCheck as CheckBox
	LOCAL oDropDown as Listbox
	LOCAL oFix as FixedText
	LOCAL Name as STRING,nType, ID as int, Values as STRING
	LOCAL myDim as Dimension
	LOCAL myOrg as Point
	LOCAL aValues as ARRAY
	LOCAL EditX:=152, FixX:=17 as int, vertDist:=41 as int
	Default(@left,true)
	Name:=pers_propextra[count,1]
	nType:=pers_propextra[count,3]
	Values:=pers_propextra[count,4]
	ID := pers_propextra[count,2]
	IF left
		if pers_propextra[count,3]==DROPDOWN .or. (Len(pers_propextra)>count .and.pers_propextra[count+1,3]==DROPDOWN )
			vertDist:=41
		else
			vertDist:=21
		endif
		//enlarge window
		myDim:=self:Size
		myDim:Height+=vertDist
		self:Size:=myDim
		myOrg:=self:Origin
		myOrg:y-=vertDist
		self:Origin:=myOrg
		// enlarge personal group:
		myDim:=self:oDCGroupBoxPersonal:Size
		myDim:Height+=vertDist
		self:oDCGroupBoxPersonal:Size:=myDim
		myOrg:=self:oDCGroupBoxPersonal:Origin
		myOrg:y-=vertDist
		self:oDCGroupBoxPersonal:Origin:=myOrg 
	ELSE
		EditX:=511
		FixX:=376
		myOrg:=self:oDCGroupBoxPersonal:Origin
	ENDIF
	//
	//	insert extra properties in group extra properties:	
	IF nType==DROPDOWN  
		oDropDown:=ListBox{self,count,Point{EditX,myOrg:y+8},Dimension{185,40},LBS_SORT+LBS_MULTIPLESEL}
		oDropDown:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name,null_string,null_string}
		aValues:=Split(Values,",")
		oDropDown:FillUsing(aValues)
		AAdd(self:aPropEx,oDropDown)
		oDropDown:show()
		oFix:=FixedText{self,count,Point{FixX,myOrg:y+8}, Dimension{135,20},Name+":"}
		oFix:show()
	ENDIF
	IF nType==CHECKBX 
		oCheck:=CheckBox{self,count,Point{EditX,myOrg:y+8},Dimension{185,20}}
		oCheck:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name,null_string,null_string}
		AAdd(self:aPropEx,oCheck)
		oCheck:show()
	ENDIF
	if nType==DATEFIELD
		oFix:=FixedText{self,count,Point{FixX,myOrg:y+8}, Dimension{135,20},Name+":"}
		oFix:show()
		oSingle:=SingleLineEdit{self,count,Point{EditX,myOrg:y+8},Dimension{60,20},EDITAUTOHSCROLL} 
		oSingle:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))+'from'),Name,null_string,null_string}
		oSingle:Picture:='@D'
		oSingle:FieldSpec:=PropExtra_Date{}
		oSingle:FocusSelect := FSEL_HOME	
		oSingle:show()
		AAdd(self:aPropEx,oSingle)
		oFix:=FixedText{self,count,Point{EditX+63,myOrg:y+8}, Dimension{10,20},'- '}
		oFix:show()
		oSingle:=SingleLineEdit{self,count,Point{EditX+75,myOrg:y+8},Dimension{60,20},EDITAUTOHSCROLL} 
		oSingle:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))+'to'),Name,null_string,null_string}
		oSingle:Picture:='@D'
		oSingle:FieldSpec:=PropExtra_Date{}
		oSingle:FocusSelect := FSEL_HOME	
		oSingle:show()
		AAdd(self:aPropEx,oSingle)	
	endif
	IF nType==TEXTBX 
		oSingle:=SingleLineEdit{self,count,Point{EditX,myOrg:y+8},Dimension{185,20},EDITAUTOHSCROLL}
		oSingle:ToolTipText:=self:oLan:WGet("text which should be contained in this field") 
		oSingle:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name,null_string,null_string}
		AAdd(self:aPropEx,oSingle)
		oSingle:show()
		oFix:=FixedText{self,count,Point{FixX,myOrg:y+8}, Dimension{135,20},Name+":"}
		oFix:show()
	ENDIF


	RETURN nil
	
	
METHOD Abon_Con(dummy:=nil as logic) as array CLASS SelPersOpen
	LOCAL oAcc as SQLSelect
	LOCAL lSuccess AS LOGIC
	LOCAL aAcc := {} as array
	LOCAL cStatement as STRING

	cStatement:="select distinct concat(a.description,' ',a.accnumber) as accdescr, a.accid from account a,subscription s "+;
	"where s.accid=a.accid and active=1 and "+; 
	iif(self:cType=="SUBSCRIPTIONS","a.subscriptionprice>0 and s.category='A'","giftalwd=1 and category='D'")
	oAcc:=SQLSelect{cStatement,oConn}
	aAcc:=oAcc:GetLookupTable(1000)
	aSize(aAcc,len(aAcc)+1)
	AIns(aAcc,1)
	aAcc[1]:={"<all>",}
	return aAcc
		
ACCESS keus21 CLASS SelPersOpen
	RETURN Val(SELF:oDCkeus21:Value)
Method MakeCliop03File(begin_due as date,end_due as date, process_date as date,accid as int) as logic CLASS SelPersOpen
	// make CLIEOP03 file for automatic collection for Dutch Banks
	LOCAL oDue,oPers as SQLSelect 
	LOCAL ptrHandle
	LOCAL cFilename, cOrgName, cDescr,cTransnr,m56_Payahead,cType,cAccMlCd,cPersId,cAccID,cAmnt as STRING 
	local cYear:=Str(Year(process_date),-1),cMonth:=Str(Month(process_date),-1) as string
	LOCAL fSum:=0,fAmnt,fMbal as FLOAT, GrandTotal:=0,fLimitInd,fLimitBatch as float
	LOCAL lError as LOGIC
	LOCAL oReport as PrintDialog, headinglines as ARRAY , nRow, nPage,i,j, nSeq,nSeqnbr,nTransId as int
	LOCAL cBank,cCod,cErrMsg,cAccType,cDueIds,cAccs as STRING
	Local oWarn as TextBox
	Local aTrans:={} as array // accid,persid,amount,description,membertype,mailcode,account type,id 
	Local aDir as array
	local oSel as SQLSelect
	local oMBal as Balances
	local oStmnt as SQLStatement 
	local dlg as date
	local cTransDate:=SQLdate(process_date) as string 
	Local oAddInEx as AddToIncExp
	local aTransValues:={} as array  // array with values to be inserted into table transaction:
	//aTransValues: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
	//                1    2     3      4      5      6            7      8   9  10      11         12    13     14       15      16    17   18
	local aTransIncExp:={} as array // array like aTrans for ministry income/expense transactions   
	local avaluesPers:={} as array // {persid,dategift,maillcode},...  array with values to be updated into table person
	local aMbalValues:={} as array // {accid,year,month,currency,deb,cre} 

	if Empty(BANKNBRDEB)
		(ErrorBox{,self:oLan:WGet("Bank account invoices/ direct debit not specified in system data")}):Show()
		return false
	endif 
	if Len(BANKNBRDEB)>7 .and.!IsDutchBanknbr(BANKNBRDEB)
		(ErrorBox{self,self:oLan:WGet("Bank account number")+Space(1)+BANKNBRDEB+;
			Space(1)+self:oLan:WGet("for Payments is not correct")}):Show()
		RETURN FALSE
	ENDIF
	IF Empty(sIDORG)
		(ErrorBox{self,self:oLan:WGet("No own organisation specified in System Parameters")}):Show()
		RETURN FALSE
	ENDIF
	cOrgName:=GetFullName(sIDORG,2)
	if Empty(cOrgName)
		(ErrorBox{self,self:oLan:WGet("No own organisation specified in System Parameters")}):Show()
		RETURN false
	ENDIF 
	oSel:=SqlSelect{"select ddmaxindvdl,ddmaxbatch from sysparms",oConn}
	oSel:Execute()
	fLimitInd:=oSel:ddmaxindvdl
	fLimitBatch:=oSel:ddmaxbatch
	if empty(fLimitBatch) .or. empty(fLimitInd)
		(ErrorBox{self,self:oLan:WGet("no maximum direct debit amounts for individual or batch specified in system data")}):Show() 
		return false		
	endif


	oSel:=SqlSelect{"select payahead from bankaccount where banknumber='"+BANKNBRDEB+"' and telebankng=1",oConn}
	if oSel:RecCount<1
		(ErrorBox{self,self:oLan:WGet("Bank account number")+Space(1)+BANKNBRDEB+Space(1)+;
			self:oLan:WGet("not specified as telebanking in system data")}):Show()
		RETURN FALSE
	else
		m56_Payahead:=Str(oSel:PAYAHEAD,-1)
		if Empty(m56_Payahead)
			(ErrorBox{self,self:oLan:WGet("For bank account number")+Space(1)+BANKNBRDEB+Space(1)+;
				self:oLan:WGet("no account for Payments en route specified in system data")}):Show() 
			return false
		endif
	endif 
	// Check if all bankaccounts are valid, belonging to the direct debited person:   

	oDue:=SqlSelect{"select distinct s.bankaccnt,s.subscribid,s.personid,"+SQLFullName(0,'ps')+" as fullname,group_concat(pb.banknumber separator ',') as bankaccounts from dueamount d,subscription s "+;
		"left join person ps on (ps.persid=s.personid) left join personbank pb on (pb.persid=ps.persid) "+;
		"where s.subscribid=d.subscribid "+;
		"and s.paymethod='C' and invoicedate between '"+SQLdate(begin_due)+;
		"' and '"+SQLdate(end_due)+"' and d.amountrecvd<d.amountinvoice "+;
		iif(Empty(accid),""," and s.accid='"+Str(accid,-1)+"'")+" and "+;
		"s.bankaccnt not in (select p.banknumber from personbank p where p.persid=s.personid)"+;
		" group by s.personid",oConn} 
	if oDue:RecCount>0 
		// try to correct donations: 
		
		// 		cErrMsg:=self:oLan:WGet("The following direct debit bank accounts don't belong to corresponding person")+":"
		do while !oDue:EoF
			if !Empty(oDue:bankaccounts)
				oStmnt:=SQLStatement{"update subscription set bankaccnt='"+Split(oDue:bankaccounts,",")[1]+"' where subscribid="+Str(oDue:subscribid,-1),oConn}
				oStmnt:Execute()
				if !Empty(oStmnt:status)
					cErrMsg+=CRLF+PadR(oDue:BANKACCNT,20)+Space(1)+AllTrim(oDue:FullName)+"(intern ID "+Str(oDue:personid,-1)+")" 
				endif
			else
				cErrMsg+=CRLF+PadR(oDue:BANKACCNT,20)+Space(1)+AllTrim(oDue:FullName)+"(intern ID "+Str(oDue:personid,-1)+")"
			endif
			oDue:skip()
		enddo
		if !Empty(cErrMsg)
			ErrorBox{self,self:oLan:WGet("Of the following donations the bankaccount does not belong to the person")+':'+cErrMsg}:Show()
			return false
		endif
	endif
	

	oDue:=SqlSelect{"select du.dueid,s.personid,s.accid,du.amountinvoice,cast(du.invoicedate as date) as invoicedate,du.seqnr,s.term,s.bankaccnt,a.accnumber,a.clc,b.category as acctype,"+;
		SQLAccType()+" as type,"+;
		"cast(p.datelastgift as date) as datelastgift,"+SQLFullName(0,'p')+" as personname,p.mailingcodes "+;
		" from account a left join member m on (a.accid=m.accid or m.depid=a.department) left join department d on (d.depid=a.department),"+;
		"balanceitem b,person p, dueamount du,subscription s "+;
		"where s.subscribid=du.subscribid and s.paymethod='C' and b.balitemid=a.balitemid "+;
		iif(Empty(accid),''," and s.accid='"+Str(accid,-1)+"'")+;
		" and invoicedate between '"+SQLdate(begin_due)+"'"+;
		" and '"+SQLdate(end_due)+"' and invoicedate<s.enddate and amountrecvd<amountinvoice and p.persid=s.personid and a.accid=s.accid order by personname",oConn}
	IF oDue:RecCount<1
		(WarningBox{self,"Producing CLIEOP03 file","No due amounts to be debited direct!"}):Show()
		RETURN false
	ENDIF
	//    LogEvent(self,oDue:SQLString,"logsql")
	headinglines:={self:oLan:Rget("Overview of generated automatic collection (CLIEOP03)"),self:oLan:Rget("Name",41)+self:oLan:Rget("Bankaccount",11)+self:oLan:Rget("Amount",12,,"R")+" "+self:oLan:Rget("Destination",12)+self:oLan:Rget("Due Date",11)+" "+self:oLan:Rget("Description",20),Replicate('-',120)}
	// write Header
	// remove old clieop03-files:
	aDir := Directory(CurPath +"\CLIEOP03*.txt") 
	nSeq:=1
	FOR i := 1 upto ALen(ADir)
		if ADir[i][F_DATE] < (Today()-12) 	
			(FileSpec{ADir[i][F_NAME]}):DELETE() 
			FErase(ADir[i][F_NAME])
		elseif ADir[i][F_DATE] == Today() 
			nSeq++
		endif
	NEXT
	oReport := PrintDialog{self,self:oLan:WGet("Producing of ")+"CLIEOP03"+DToS(Today())+Str(nSeq,-1)+" file",,120}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	self:Pointer := Pointer{POINTERHOURGLASS}
	* Datafile aanmaken:
	cFilename := CurPath + "\CLIEOP03"+DToS(Today())+Str(nSeq,-1)+'.txt'
	ptrHandle := MakeFile(self,cFilename,"Creating CLIEOP03-file")
	IF ptrHandle = F_ERROR .or. ptrHandle==nil
		self:Pointer := Pointer{POINTERARROW}
		RETURN false
	ENDIF
	// determine sequencenumber per day:
	
	FWriteLine(ptrHandle,"0001A"+StrZero(Day(Today()),2)+StrZero(Month(Today()),2)+SubStr(StrZero(Year(Today()),4,0),3,2) +"CLIEOP03"+"WYCLF"+StrZero(Month(Today()),2)+StrZero(Day(Today()),2)+"1"+Space(21))
	FWriteLine(ptrHandle,"0010B10"+PadL(BANKNBRDEB,10,"0")+"0001"+"EUR"+Space(26) )
	FWriteLine(ptrHandle,"0030B1"+StrZero(Day(process_date),2)+StrZero(Month(process_date),2)+SubStr(StrZero(Year(process_date),4,0),3,2)+PadR(cOrgName,35)+"P"+Space(2))

	do WHILE !oDue:EoF
		cBank:=oDue:BANKACCNT
		cBank:=StrTran(cBank,'P','')
		if Len(cBank)>7
			if !IsDutchBanknbr(cBank)
				(ErrorBox{self,"Bankaccount "+cBank+" of person "+oDue:PersonName+"(Intern ID "+Str(oDue:personid,-1)+") is not correct!"}):Show()
				FClose(ptrHandle)
				(FileSpec{cFilename}):DELETE()
				FErase(cFilename)
				self:Pointer := Pointer{POINTERARROW}
				return false
			endif
			// 		else
			// 			cBank:=StrTran(cBank,'P','')
		endif
		if oDue:AmountInvoice> fLimitInd
			(ErrorBox{self,self:oLan:WGet("Direct debit amount of person")+' '+oDue:PersonName+"(Intern ID "+Str(oDue:personid,-1)+") "+self:oLan:WGet("is above limit")+'! ('+Str(fLimitInd,-1)+sCurr+')'}):Show()
			self:Pointer := Pointer{POINTERARROW}
			return false  
			loop
		endif

		cBank:=PadL(cBank,10,"0")
		// Transaction record:
		FWriteLine(ptrHandle,"0100A1001"+StrZero(oDue:AmountInvoice*100,12,0)+cBank + PadL(BANKNBRDEB,10,"0")+Space(9))
		GrandTotal:=Round(GrandTotal+Val(BANKNBRDEB)+Val(cBank),0)
		// Payment pattern record:
		FWriteLine(ptrHandle,"0150A"+PadR(Mod11(StrZero(oDue:personid,5,0)+DToS(oDue:invoicedate)+Str(oDue:seqnr,-1)),16)+Space(29))	              
		// determine description from Subscription:
		IF Empty(oDue:term) .or.oDue:term>12
			cDescr:="eenmalige gift"
		elseif oDue:term==1
			cDescr:="maandelijkse gift "+Lower(maand[Month(oDue:invoicedate)])+" "+Str(Year(oDue:invoicedate),-1)
		elseif oDue:term==2
			cDescr:="twee maandelijkse gift "+Lower(maand[Month(oDue:invoicedate)])+" "+Str(Year(oDue:invoicedate),-1)
		elseif oDue:term==3
			cDescr:="kwartaal gift "+Str(Floor((Month(oDue:invoicedate)-1)/4)+1,-1)+" "+Str(Year(oDue:invoicedate),-1)
		elseif oDue:term==6
			cDescr:="halfjaarlijkse gift "+Str(Floor((Month(oDue:invoicedate)-1)/6)+1,-1)+" "+Str(Year(oDue:invoicedate),-1)
		elseif oDue:term==12
			cDescr:="jaarlijkse gift "+Str(Year(oDue:invoicedate),-1)
		else
			cDescr:="periodieke gift"
		ENDIF
		FWriteLine(ptrHandle,"0160A"+PadR(cDescr,32)+Space(13))
		fSum:=Round(fSum+oDue:AmountInvoice,DecAantal) 
		oReport:PrintLine(@nRow,@nPage,;
			Pad(oDue:PersonName,40)+" "+Pad(cBank,11)+Str(oDue:AmountInvoice,12,2)+' '+Pad(oDue:ACCNUMBER,12)+DToC(oDue:invoicedate)+"  "+cDescr,headinglines)  
		// add to aTrans:
		AAdd(aTrans,{oDue:accid,oDue:personid,oDue:AmountInvoice,cDescr,oDue:Type,oDue:CLC,oDue:acctype,Str(oDue:dueid,-1)})
		//                 1         2              3               4      5         6         7                 8 
		// aad to aTransValues
		//aTransValues: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
		//                1    2     3      4      5      6            7      8   9  10      11         12    13     14       15      16    17   18
		// first row:
		cType:=Transform(oDue:Type,"")
		fAmnt:=float(_cast,oDue:AmountInvoice)
		cAmnt:=Str(fAmnt,-1)
		cPersId:= ConS(oDue:personid)
		cAccMlCd:= oDue:mailingcodes
		cAccMlCd:=ADDMLCodes(Transform(oDue:CLC,""),cAccMlCd)
		cAccMlCd:=ADDMLCodes('FI',cAccMlCd)	
		cAccID:=ConS(oDue:accid)
		AAdd(aTransValues,{m56_Payahead,cAmnt,cAmnt,'0.00','0.00',sCurr,cDescr,cTransDate,'',LOGON_EMP_ID,'2','1','COL','','0','0','',''})
		// second row:
		AAdd(aTransValues,{cAccID,'0.00','0.00',cAmnt,cAmnt,sCurr,cDescr,cTransDate,iif(cType=='M',"AG",""),LOGON_EMP_ID,'2','2','COL','',iif(Empty(cPersId),'0',cPersId),'0','',''})
		// add person data:
		IF	!Empty(cType) .and. (cType	==	'G' .or.	cType	==	'M' .or.	cType	==	'D') 
			AAdd(avaluesPers,{cPersId,cTransDate,AddSlashes(cAccMlCd)} )
		endif 
		// add to balance values:
		// {accid,year,month,currency,deb,cre} 
		i:=AScan(aMbalValues,{|x|x[1]==cAccID})
		if i>0
			fMBal:=aMbalValues[i,6]
			aMbalValues[i,6]:=Round(fMBal+fAmnt,DecAantal)
		else
			AAdd(aMbalValues,{cAccID,cYear,cMonth,sCurr,0.00,fAmnt})		
		endif
		oDue:skip()		
	ENDDO

	// Write closing lines:
	FWriteLine(ptrHandle,"9990A"+StrZero(fSum*100,18,0)+SubStr(Str(GrandTotal,-1,0),-10)+StrZero(Len(aTrans),7,0)+Space(10))
	FWriteLine(ptrHandle,"9999A"+Space(45))
	
	FClose(ptrHandle)
	oReport:PrintLine(@nRow,@nPage,Replicate('-',120),headinglines,3)
	oReport:PrintLine(@nRow,@nPage,Space(52)+Str(Round(fSum,2),12,2),headinglines)
	oReport:prstart()
	oReport:prstop()
	self:Pointer := Pointer{POINTERARROW}
	if fSum>fLimitBatch
		if TextBox{self,self:oLan:WGet("Direct Debit"),self:oLan:WGet("Total direct debit amount")+' '+Str(fSum,-1)+' '+self:oLan:WGet("is above limit")+'! ('+Str(fLimitBatch,-1)+sCurr+')'+CRLF+self:oLan:WGet("Continue")+'?',BOXICONQUESTIONMARK + BUTTONYESNO}:Show()==BOXREPLYNO
			return false
		endif
	endif

	oWarn:=TextBox{self,"Direct Debit",;
		'Printing O.K.? Can shown '+Str(Len(aTrans),-1)+' transactions('+sCurrName+Str(fSum,-1)+') be imported into telebanking?',BOXICONQUESTIONMARK + BUTTONYESNO}
	IF (oWarn:Show() = BOXREPLYNO)
		// remove file:
		(FileSpec{cFilename}):DELETE()
	else 
		oMainWindow:STATUSMESSAGE("Recording direct debit transactions") 
		self:oCCCancelButton:Disable()
		self:oCCOKButton:Disable()

		self:Pointer := Pointer{POINTERHOURGLASS}

		if !Empty(SINCHOME) .or.!Empty(SINC)
			// add transactions for ministry income/expense:
			oAddInEx:=AddToIncExp{}
			for i:=2 to Len(aTransValues) step 2
				nSeqnbr:=2 
				aTransIncExp:=oAddInEx:AddToIncome(aTransValues[i,9],false,aTransValues[i,1],Val(aTransValues[i,4]),Val(aTransValues[i,2]),Val(aTransValues[i,3]),Val(aTransValues[i,5]),aTransValues[i,6],;
					aTransValues[i,7],aTransValues[i,15],aTransValues[i,8],aTransValues[i,13],@nSeqnbr,aTransValues[i,11]) 
				if Len(aTransIncExp)=2
					ASize(aTransValues,Len(aTransValues)+2)
					i++
					AIns(aTransValues,i)
					aTransValues[i]:=aTransIncExp[1]
					i++
					AIns(aTransValues,i)
					aTransValues[i]:=aTransIncExp[2]
					// add to balance values:
					// {accid,year,month,currency,deb,cre} 
					j:=AScan(aMbalValues,{|x|x[1]==aTransIncExp[1,1]})
					if j>0
						aMbalValues[j,5]:=Round(aMbalValues[j,5]+aTransIncExp[1,2],DecAantal)
						aMbalValues[j,6]:=Round(aMbalValues[j,6]+aTransIncExp[1,4],DecAantal)
					else
						AAdd(aMbalValues,{aTransIncExp[1,1],cYear,cMonth,sCurr,aTransIncExp[1,2],aTransIncExp[1,4]})		
					endif
					j:=AScan(aMbalValues,{|x|x[1]==aTransIncExp[2,1]})
					if j>0
						aMbalValues[j,5]:=Round(aMbalValues[j,5]+aTransIncExp[2,2],DecAantal)
						aMbalValues[j,6]:=Round(aMbalValues[j,6]+aTransIncExp[2,4],DecAantal)
					else
						AAdd(aMbalValues,{aTransIncExp[2,1],cYear,cMonth,sCurr,aTransIncExp[2,2],aTransIncExp[2,4]})		
					endif
				endif
			next			
		endif
		// add line for total against payahead:
		AAdd(aMbalValues,{m56_Payahead,cYear,cMonth,sCurr,fSum,0.00})		
		
		oStmnt:=SQLStatement{"set autocommit=0",oConn}
		oStmnt:Execute()
		oStmnt:=SQLStatement{'lock tables `dueamount` write,`mbalance` write'+iif(Len(avaluesPers)>0,',`person` write','')+',`transaction` write',oConn} 
		oStmnt:Execute()

		// make transactions:
		if !Empty(oStmnt:status)
			lError:=true
		endif
		if !lError
			// Reconcile Due Amounts:
			oStmnt:=SQLStatement{"update dueamount set amountrecvd=amountinvoice where dueid in ("+Implode(aTrans,",",,,8)+")",oConn}
			oStmnt:Execute()
			if	!Empty(oStmnt:status)
				SQLStatement{"rollback",oConn}:Execute() 
				SQLStatement{"unlock tables",oConn}:Execute()
				LogEvent(self,"Due amounts error:"+oStmnt:ErrInfo:ErrorMessage+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
				ErrorBox{,self:oLan:WGet('due amounts could not be updated')+":"+oStmnt:ErrInfo:ErrorMessage}:Show()
				return false 
			endif
		endif
		if !lError
			//	make transaction:
			* add	first	transaction:
			* against DebitAccount:	
			//	insert first line:
			oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp) "+;
				" values	("+Implode(aTransValues[1],"','",1,16)+')',oConn}
			oStmnt:Execute()
			nTransId:=ConI(SqlSelect{"select	LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
			aTransValues[2,18]:=nTransId
			for i:=3	to	Len(aTransValues)	step 2
				//	next line income/expense?
				if	aTransValues[i,12]=='3'
					aTransValues[i,18]:=nTransId
					aTransValues[i+1,18]:=nTransId
					i+=2
				endif		
				nTransId++
				if	i<Len(aTransValues)
					aTransValues[i,18]:=nTransId
					aTransValues[i+1,18]:=nTransId
				endif
			next 
			for i:=2 to Len(aTransValues) step 2000
				oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid)	"+;
					" values	"+Implode(aTransValues,"','",i,2000),oConn}
				oStmnt:Execute()
				if	oStmnt:NumSuccessfulRows<1
					SQLStatement{"rollback",oConn}:Execute() 
					SQLStatement{"unlock	tables",oConn}:Execute()
					LogEvent(self,'Transactions could not be inserted:'+oStmnt:ErrInfo:ErrorMessage+CRLF+"stmnt:"+SubStr(oStmnt:SQLString,1,10000),"LogErrors")
					ErrorBox{,self:oLan:WGet('Transactions could	not be inserted, nothing recorded')+":"+oStmnt:ErrInfo:ErrorMessage}:Show()
					return false 
				endif
			next
			//	adapt	mbalance	values: 
			oStmnt:=SQLStatement{"INSERT INTO mbalance (`accid`,`year`,`month`,`currency`,`deb`,`cre`) VALUES "+Implode(aMbalValues,"','")+;
				" ON DUPLICATE KEY UPDATE deb=round(deb+values(deb),2),cre=round(cre+values(cre),2)",oConn}
			oStmnt:Execute()
			if !Empty(oStmnt:status) 
				SQLStatement{"rollback",oConn}:Execute() 
				SQLStatement{"unlock	tables",oConn}:Execute()
				LogEvent(self,'Month balances could not be inserted:'+oStmnt:ErrInfo:ErrorMessage+CRLF+"stmnt:"+SubStr(oStmnt:SQLString,1,10000),"LogErrors")
				ErrorBox{,self:oLan:WGet('Month balances could	not be inserted, nothing recorded')+":"+oStmnt:ErrInfo:ErrorMessage}:Show()
				return false 
			endif
			// oPro:AdvancePro()
			self:Pointer := Pointer{POINTERHOURGLASS}
			if Len(avaluesPers)>0
				*	Update person info of giver: 
				oStmnt:=SQLStatement{'insert into person (persid,datelastgift,mailingcodes) values '+Implode(avaluesPers,'","')+;
					" ON DUPLICATE	KEY UPDATE datelastgift=if(values(datelastgift)>datelastgift,values(datelastgift),datelastgift),"+;
					"mailingcodes=values(mailingcodes)",oConn} 
				oStmnt:Execute()
				if	!Empty(oStmnt:status)
					SQLStatement{"rollback",oConn}:Execute() 
					SQLStatement{"unlock tables",oConn}:Execute()
					LogEvent(self,"error:"+oStmnt:ErrInfo:ErrorMessage+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
					ErrorBox{,self:oLan:WGet('persons could not be updated, nothing recorded')+":"+oStmnt:ErrInfo:ErrorMessage}:Show()
					return false 
				endif
			endif
		endif
		if !lError
			SQLStatement{"commit",oConn}:Execute()	
			SQLStatement{"unlock tables",oConn}:Execute()
		endif
		SQLStatement{"set autocommit=1",oConn}:Execute()

		self:oCCCancelButton:Enable()
		self:oCCOKButton:Enable()
		self:Pointer := Pointer{POINTERARROW}
		(InfoBox{self,"Producing CLIEOP03 file","File "+cFilename+" generated with "+Str(Len(aTrans),-1)+" amounts("+sCurrName+Str(fSum,-1)+")"}):Show()
		LogEvent(self, "CLIEOP03 file "+cFilename+" generated with "+Str(Len(aTrans),-1)+" direct debits("+sCurrName+Str(fSum,-1)+")")

	endif
	RETURN true

METHOD MakeKIDFile(begin_due as date,end_due as date, process_date as date) as logic CLASS SelPersOpen
	// make KID file for automatic collection for Norwegian Banks
	LOCAL cFilter as STRING
	LOCAL oDue as SQLSelect, oPers as SQLSelect, oSub as SQLSelect
	LOCAL ptrHandle
	LOCAL cFilename as STRING
	Local ToFileFS as Filespec
	LOCAL nSeq, nLine as int, fSum:=0 as FLOAT
	LOCAL DueDateFirst, DueDateLast,DueDate as date
	LOCAL Success as LOGIC
	LOCAL oReport as PrintDialog, headinglines as ARRAY , nRow, nPage as int
	//LOCAL oLan AS Language
	LOCAL cSession as STRING
	Local aDue:={} as array  // array with dueid's to be reconciled 
	local oStmnt as sqlStatement

	cSession:=Str(Year(Today()),4,0)+StrZero((Today()-SToD(Str(Year(Today()),4,0)+"0101"))+1,3)

	oDue:=SqlSelect{"select s.invoiceid,d.amountinvoice,d.dueid,cast(d.invoicedate as date) as invoicedate,p.persid,p.lastname "+;
		" from person p, dueamount d,subscription s "+;
		"where s.subscribid=d.subscribid and s.paymethod='C' "+;
		" and invoicedate between '"+SQLdate(begin_due)+"'"+;
		" and '"+SQLdate(end_due)+"' and amountrecvd<amountinvoice and p.persid=s.personid and s.blocked=0 order by lastname",oConn}
	IF oDue:RecCount<1
		(WarningBox{self,"Producing KID file","No due amounts to be auto collected!"}):Show()
		RETURN false
	ENDIF
	* Datafile aanmaken:
	cFilename := "a-girowycliffe"+StrZero(Day(Today()),2)+StrZero(Month(Today()),2)+SubStr(StrZero(Year(Today()),4),1,4) 
	ToFileFS:=AskFileName(self,cFilename,oLan:WGet("Creating KID-file"),".txt","text file")
	if Empty(ToFileFS)
		return false
	endif
	cFilename:=ToFileFS:FullPath
	ptrHandle := MakeFile(self,@cFilename,oLan:WGet("Creating KID-file"))
	IF ptrHandle = F_ERROR .or. ptrHandle==nil
		RETURN false
	ENDIF
	oReport := PrintDialog{self,"Producing of KID file",,70}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	headinglines:={oLan:Rget("Overview of generated automatic collection (KID)"),oLan:RGet("Session:")+cSession,oLan:RGet("Name",41)+oLan:RGet("Amount",12,,"R")+" "+oLan:RGet("KID",13),Replicate('-',67)}
	// write Header
	FWriteLine(ptrHandle,"NY000010"+PadL(SQLSelect{"select cntrnrcoll from sysparms",oConn}:CNTRNRCOLL,8,"0")+PadL(cSession,7,"0")+PadR("0000808",57,"0"))
	FWriteLine(ptrHandle,"NY210020000000000"+PadL(cSession,7,"0")+PadL(BANKNBRDEB,11,"0")+Replicate("0",45))
	nLine:=2 
	DueDate:=Max(oDue:invoicedate,process_date)
	DueDateFirst:=DueDate
	DueDateLast:=DueDate
	SetDecimalSep(Asc(DecSeparator))
	do WHILE !oDue:EoF
//		IF oPers:Seek(oDue:persid)
			nSeq++ 
			DueDate:=Max(oDue:invoicedate,process_date)
			FWriteLine(ptrHandle,"NY210230"+StrZero(nSeq,7,0)+StrZero(Day(DueDate),2,0)+StrZero(Month(DueDate),2,0)+SubStr(StrZero(Year(DueDate),4,0),3,2)+;
				Space(11)+StrZero(oDue:AmountInvoice*100,17,0)+Space(12)+PadR(AllTrim(oDue:INVOICEID),19,"0"))
			FWriteLine(ptrHandle,"NY210231"+StrZero(nSeq,7,0)+PadR(oDue:lastname,60)+"00000")
			nLine+=2
			fSum+=oDue:AmountInvoice
			IF DueDateFirst>DueDate
				DueDateFirst:=DueDate
			ENDIF
			IF DueDateLast<DueDate
				DueDateLast:=DueDate
			ENDIF
			oReport:PrintLine(@nRow,@nPage,;
				Pad(GetFullName(Str(oDue:persid,-1)),40)+" "+Str(oDue:AmountInvoice,12,2)+' '+Pad(oDue:INVOICEID,13),headinglines)

		//ENDIF 
		AAdd(aDue,Str(oDue:dueid,-1))
		oDue:skip()		
	ENDDO
	// Write closing lines:
	FWriteLine(ptrHandle,"NY210088"+StrZero(nSeq,8,0)+StrZero(nLine,8,0)+StrZero(Round(fSum*100,0),17,0)+;
		StrZero(Day(DueDateFirst),2,0)+StrZero(Month(DueDateFirst),2,0)+SubStr(StrZero(Year(DueDateFirst),4,0),3,2)+;
		StrZero(Day(DueDateLast),2,0)+StrZero(Month(DueDateLast),2,0)+SubStr(StrZero(Year(DueDateLast),4,0),3,2)+;
		Replicate("0",27))
	FWriteLine(ptrHandle,"NY000089"+StrZero(nSeq,8,0)+StrZero(nLine+2,8,0)+StrZero(Round(fSum*100,0),17,0)+;
		StrZero(Day(DueDateLast),2,0)+StrZero(Month(DueDateLast),2,0)+SubStr(StrZero(Year(DueDateLast),4,0),3,2)+;
		Replicate("0",33))
	
	FClose(ptrHandle)
	oReport:PrintLine(@nRow,@nPage,Replicate('-',67),headinglines,3)
	oReport:PrintLine(@nRow,@nPage,Space(41)+Str(Round(fSum,2),12,2),headinglines)
	oReport:prstart()
	oReport:prstop()
	SetDecimal(Asc('.'))
	if (TextBox{self,"Producing KID file","File "+cFilename+" generated with "+Str(nSeq,-1)+" amounts"+CRLF+"Is File OK to be send to the bank?",BUTTONYESNO+BOXICONQUESTIONMARK}):Show()==BOXREPLYYES
		// reconcile due amounts: 
		SQLStatement{"start transaction",oConn}:Execute()
		oStmnt:=sqlStatement{"update dueamount set amountrecvd=amountinvoice where dueid in ("+implode(aDue,',')+")",oConn}
		oStmnt:Execute()
		if Empty(oStmnt:status)
			sqlStatement{"commit",oConn}:execute() 
			LogEvent(self, "KID file "+cFilename+" generated with "+Str(nSeq,-1)+" amounts")
		else
			SQLStatement{"rollback",oConn}:Execute()
			// erase file
			FErase(cFilename)
			ErrorBox{self,"making kid file failed"}:Show()
		endif
	else
		// erase file:
		FErase(cFilename)
	endif
	SetDecimalSep(Asc("."))

	RETURN true
Method SEPADirectDebit(begin_due as date,end_due as date, process_date as date,accid as int) as logic CLASS SelPersOpen
	// produce XML file for SEPA Direct Debit to be imported into telebanking package
	LOCAL cFilename, cOrgName,cOrgAddress, cDescr,cTransnr,m56_Payahead,m56_currency,cType,cAccMlCd,cPersId,cAccID,cAmnt as STRING 
	LOCAL cBank,cBic,cCod,cErrMsg,cAccType,cDueIds,cAccs,CreditorID as STRING
	local cYear:=Str(Year(process_date),-1),cMonth:=Str(Month(process_date),-1) as string
	local cTransDate:=SQLdate(process_date) as string
	local cNextDD:=self:oLan:Rget("next direct debit in") as string 
	local mInvoiceID as string
	LOCAL fSum:=0,fMbal as FLOAT, GrandTotal:=0,AmountInvoice,fLimitInd,fLimitBatch as float
	LOCAL oReport as PrintDialog, headinglines as ARRAY 
	local nRow, nPage,i,j,nTerm, nSeq,nSeqnbr,nTransId,nChecksum,SeqTp,nGrpnbr  as int
	LOCAL lError,lSetAMPM,lAppend:=false as LOGIC
	local dlg,invoicedate,dReqCol,dSenddate as date
	LOCAL ptrHandle 
	
	Local aDir as array
	local aMndt:={} as array
	local abank:={} as array // array with bank accounts of a person
	local aDue:={} as array // array with dueamount values:
	Local aTrans:={} as array // accid,persid,amount,description,membertype,mailcode,account type,id 
	local aTransValues:={} as array  // array with values to be inserted into table transaction:
	//aTransValues: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
	//                1    2     3      4      5      6            7      8   9  10      11         12    13     14       15      16    17   18
	local aTransIncExp:={} as array // array like aTrans for ministry income/expense transactions   
	local avaluesPers:={} as array // {persid,dategift},...  array with values to be updated into table person
	local aMbalValues:={} as array // {accid,year,month,currency,deb,cre} 
	local aSubvalues:={} as array  //{subscribid,firstinvoicedate}  
	local aDD:={} as array // values voor DD-file: {{AmountInvoice,mandateid,begindate,PersonName,banknbrcre,description,invoiceid,seqtp,Bic,Iban previous,Bic previous},...
	local aMndmnt:={} as array // array with subscribids of amendments to be removed: {subscribid,...}   

	local aSeqTp:={{'FRST',null_date},{'RCUR',null_date},{'FNAL',null_date},{'OOFF',null_date}} // array with total per sequencetype: {{sqtype,reqcolldate},...    
	//                 1                2               3              4                                                                    1      2   
	local aGrp:={} // array with total per group: {{sqtype,PmtInfId,reqcolldate,total transactions, ctrl sum},...    
	local aDescr:=ArrayNew(13) as array
	local DrctDbtTxInf:={} as array  // array with output per DrctDbtTxInf 
	local ToFileFS as FileSpec
	Local oWarn as TextBox
	local oMBal as Balances
	local oSel as SQLSelect
	local oStmnt as SQLStatement 
	LOCAL oDue,oPers as SQLSelect 
	Local oAddInEx as AddToIncExp
	Local oSepaConv as SepaConv
	

	if Empty(BANKNBRDEB)
		(ErrorBox{,self:oLan:WGet("Bank account invoices/ direct debit not specified in system data")}):Show()
		return false
	endif 
	if !IsSEPA(BANKNBRDEB)
		(ErrorBox{self,self:oLan:WGet("Bank account number")+Space(1)+BANKNBRDEB+Space(1)+;
			self:oLan:WGet("for Payments is not correct SEPA bank account")}):Show()
		RETURN FALSE
	ENDIF
	IF Empty(Val(sIDORG))
		(ErrorBox{self,self:oLan:WGet("No own organisation specified in System Parameters")}):Show()
		RETURN FALSE
	ENDIF
	oSel:=SqlSelect{"select "+SQLFullName(2)+'as orgname,'+SQLAddress(CRLF)+' as orgaddress from person where persid='+sIDORG,oConn}
	oSel:Execute()
	if oSel:RecCount=1
		cOrgName:=oSel:OrgName
		cOrgAddress:=oSel:orgaddress
	endif
// 	cOrgName:=GetFullName(sIDORG,2)
	if Empty(cOrgName)
		(ErrorBox{self,self:oLan:WGet("No own organisation specified in System Parameters")}):Show()
		RETURN false
	ENDIF

	oSel:=SqlSelect{"select payahead,currency from bankaccount b, account a where banknumber='"+BANKNBRDEB+"' and telebankng=1 and b.accid=a.accid",oConn}
	if oSel:RecCount<1
		(ErrorBox{self,self:oLan:WGet("Bank account number")+Space(1)+BANKNBRDEB+Space(1)+;
			self:oLan:WGet("not specified as telebanking in system data")}):Show()
		RETURN FALSE
	else
		m56_Payahead:=Str(oSel:PAYAHEAD,-1)
		if Empty(Val(m56_Payahead))
			(ErrorBox{self,self:oLan:WGet("For bank account number")+Space(1)+BANKNBRDEB+Space(1)+;
				self:oLan:WGet("no account for Payments en route specified in system data")}):Show() 
			return false
		endif
		m56_currency:=oSel:currency
	endif
	CreditorID:=(oSel:=SqlSelect{"select cntrnrcoll,ddmaxindvdl,ddmaxbatch from sysparms",oConn}):cntrnrcoll
	if Empty(CreditorID)
		(ErrorBox{self,self:oLan:WGet("no chamber of commerce number specified in system data")}):Show() 
		return false
	endif
	fLimitInd:=oSel:ddmaxindvdl
	fLimitBatch:=oSel:ddmaxbatch
	if empty(fLimitBatch) .or. empty(fLimitInd)
		(ErrorBox{self,self:oLan:WGet("no maximum direct debit amounts for individual or batch specified in system data")}):Show() 
		return false		
	endif
	// file description array: 
	
	aDescr[1]:=oLan:Rget("Single gift")
	aDescr[2]:=self:oLan:Rget("Monthly gift")
	aDescr[3]:=self:oLan:Rget("Bimonthly gift")
	aDescr[4]:=self:oLan:Rget("Quarterly gift")
	aDescr[5]:=self:oLan:Rget("Periodic gift")
	aDescr[6]:=self:oLan:Rget("Periodic gift")
	aDescr[7]:=self:oLan:Rget("Half-yearly gift")
	aDescr[8]:=self:oLan:Rget("Periodic gift")
	aDescr[9]:=self:oLan:Rget("Periodic gift")
	aDescr[10]:=self:oLan:Rget("Periodic gift")
	aDescr[11]:=self:oLan:Rget("Periodic gift")
	aDescr[12]:=self:oLan:Rget("Periodic gift")
	aDescr[13]:=self:oLan:Rget("Yearly gift")
	
	// Check if all bankaccounts are valid, belonging to the direct debited person:   
	self:Pointer := Pointer{POINTERHOURGLASS}

	oDue:=SqlSelect{"select distinct s.bankaccnt,s.bic,s.subscribid,s.invoiceid,cast(s.firstinvoicedate as date) as firstinvoicedate,s.personid,"+; 
	"a.banknumber as bankaccntprv,a.bic as bicprv,ac.accnumber,ac.description as accname,"+;
		SQLFullName(0,'ps')+" as fullname,group_concat(pb.banknumber,'#$#',pb.bic separator '#%#') as bankaccounts from dueamount d,subscription s "+;
		"left join person ps on (ps.persid=s.personid) left join personbank pb on (pb.persid=ps.persid) left join amendment a on(a.subscribid=s.subscribid) left join account ac on (ac.accid=s.accid) "+;
		"where s.subscribid=d.subscribid "+;
		"and s.paymethod='C' and invoicedate between '"+SQLdate(begin_due)+;
		"' and '"+SQLdate(end_due)+"' and d.amountrecvd<d.amountinvoice "+;
		iif(Empty(accid),""," and s.accid='"+Str(accid,-1)+"'")+" and "+;
		"s.bankaccnt not in (select p.banknumber from personbank p where p.persid=s.personid) "+;
		" group by s.personid",oConn} 
	if oDue:RecCount>0 
		// try to correct donations: 
		
		// 		cErrMsg:=self:oLan:WGet("The following direct debit bank accounts don't belong to corresponding person")+":"
		do while !oDue:EoF
			if !Empty(oDue:bankaccounts)
				// replace bankaccount in subscription and reset it to frst: 
				abank:= AEvalA(Split(oDue:bankaccounts,'#%#',,true),{|x|x:=Split(x,'#$#',,true) })
				if (i:=AScan(abank,{|x|!Empty(x[2])}))>0
					lError:=false
					SQLStatement{"start transaction",oConn}:Execute()
					if !Empty(oDue:firstinvoicedate)  // not first time 
						if Empty(oDue:bankaccntprv) 
							// insert amendment:
							oStmnt:=SQLStatement{'insert into amendment set subscribid='+Str(oDue:subscribid,-1)+',banknumber="'+oDue:BANKACCNT+'",bic="'+oDue:bic+'"',oConn}
							oStmnt:Execute()
							if !Empty(oStmnt:status)
								cErrMsg+=CRLF+PadR(oDue:BANKACCNT,20)+Space(1)+AllTrim(oDue:FullName)+"(intern ID "+Str(oDue:personid,-1)+")"
								lError:=true
							endif
						else
							if oDue:bankaccntprv==abank[i,1]
								oStmnt:=SQLStatement{'delete from amendment where subscribid='+Str(oDue:subscribid,-1),oConn}
								oStmnt:Execute()
								if !Empty(oStmnt:status)
									cErrMsg+=CRLF+PadR(oDue:BANKACCNT,20)+Space(1)+AllTrim(oDue:FullName)+"(intern ID "+Str(oDue:personid,-1)+")"
									lError:=true
								endif
							endif
						endif
					endif
					/*					mInvoiceID:=oDue:invoiceid
					if oDue:bic==abank[i,2].and. !Empty(oDue:firstinvoicedate)  // not first time
					// same bank? new mandateid needed
					aMndt:=Split(mInvoiceID,'-')
					if Len(aMndt)<7
					mInvoiceID+='-1'
					else
					mInvoiceID:=aMndt[1]+'-'+aMndt[2]+'-'+aMndt[3]+'-'+aMndt[4]+'-'+aMndt[5]+'-'+aMndt[6]+'-'+Str(Val(aMndt[7])+1,-1)
					ENDIF
					ENDIF      
					oStmnt:=SQLStatement{"update subscription set bankaccnt='"+abank[i,1]+"',bic='"+abank[i,2]+"',invoiceid='"+mInvoiceID+"'"+iif(abank[i,2]==oDue:bic,",firstinvoicedate='0000-00-00'",'')+" where subscribid="+Str(oDue:subscribid,-1),oConn}
					*/
					if !lError
						oStmnt:=SQLStatement{"update subscription set bankaccnt='"+abank[i,1]+"',bic='"+abank[i,2]+"' where subscribid="+Str(oDue:subscribid,-1),oConn}
						oStmnt:Execute()
						if !Empty(oStmnt:status)
							cErrMsg+=CRLF+PadR(oDue:BANKACCNT,20)+Space(1)+AllTrim(oDue:FullName)+"(intern ID "+Str(oDue:personid,-1)+")"
							lError:=true 
						endif
						logevent(self,self:oLan:RGet("Updated donation")+':'+; 
						"personid="+ ConS(oDue:personid)+;
						", personname="+oDue:FullName+;
						", account="+ oDue:AccNumber+' '+oDue:AccName+;
						CRLF+self:oLan:Rget("CHANGES automatically by system")+': '+CRLF+oDue:BANKACCNT+' -> '+abank[i,1])
					endif
					if lError
						SQLStatement{"rollback",oConn}:Execute()
					else
						SQLStatement{"commit",oConn}:Execute()
					endif
				else
					cErrMsg+=CRLF+PadR(oDue:BANKACCNT,20)+space(1)+alltrim(oDue:fullname)+"(intern ID "+str(oDue:personid,-1)+")"
				endif
			else
				cErrMsg+=CRLF+PadR(oDue:BANKACCNT,20)+space(1)+alltrim(oDue:fullname)+"(intern ID "+str(oDue:personid,-1)+")"
			endif
			oDue:skip()
		enddo
		if !Empty(cErrMsg)
			ErrorBox{self,self:oLan:WGet("Of the following donations the bankaccount does not belong to the person or has no bic")+':'+cErrMsg}:Show()
			return false
		endif
	endif


	oDue:=SqlSelect{"select cast(group_concat(cast(du.dueid as char),'#$#',cast(du.subscribid as char),'#$#',cast(s.personid as char),'#$#',cast(s.accid as char),'#$#',s.begindate"+;
		",'#$#',case when s.term>=999 or s.term=0 then '4' when s.firstinvoicedate='0000-00-00' then '1' when s.firstinvoicedate>'0000-00-00' then if(extract(year_month from adddate(du.invoicedate,interval s.term month))<extract(year_month from s.enddate),'2','3') end"+;
		",'#$#',cast(du.amountinvoice as char),'#$#',du.invoicedate,'#$#',cast(du.seqnr as char),'#$#',"+;
		"cast(s.term as char),'#$#',s.bankaccnt,'#$#',a.accnumber,'#$#',a.clc,'#$#',b.category,'#$#',"+;
		SQLAccType()+",'#$#',"+SQLFullName(0,'p')+",'#$#',pb.bic,'#$#',p.mailingcodes,'#$#',s.invoiceid,'#$#',s.firstinvoicedate,'#$#',ifnull(am.banknumber,''),'#$#',ifnull(am.bic,'')"+;
		" separator '#%#') as char) as grDue " +;
		" from account a left join member m on (a.accid=m.accid or m.depid=a.department) left join department d on (d.depid=a.department),"+;
		"balanceitem b,person p, dueamount du,subscription s left join amendment am on(am.subscribid=s.subscribid),personbank pb "+;
		"where s.subscribid=du.subscribid and s.paymethod='C' and b.balitemid=a.balitemid and pb.banknumber=s.bankaccnt "+;
		iif(Empty(accid),''," and s.accid='"+Str(accid,-1)+"'")+;
		" and invoicedate between '"+SQLdate(begin_due)+"'"+;
		" and '"+SQLdate(end_due)+"' and extract(year_month from invoicedate)<extract(year_month from s.enddate) and amountrecvd<amountinvoice and p.persid=s.personid and a.accid=s.accid and s.blocked='0' order by p.lastname",oConn}
	oDue:Execute()
	IF oDue:RecCount<1 .or. Empty(oDue:grDue)
		(WarningBox{self,"Producing SEPA Direct Debit file","No due amounts to be debited direct!"}):Show()
		RETURN false
	ENDIF
	// Add to aDue:
	// dueid,subscribid,personid,accid,begindate,seqtype,AmountInvoice,invoicedate,seqnr,term,bankaccnt,accnumber,clc,category,type,personname,bic,mailingcodes,mandate id , firstinvoicedate,bankaccntprv,bicprv
	//    1       2         3       4     5        6         7             8         9    10     11         12     13      14   15     16       17     18            19            20              21        22
	AEval(Split(oDue:grDue,'#%#',,true),{|x|AAdd(aDue,Split(x,'#$#',,true))}) 
	
	//    LogEvent(self,oDue:SQLString,"logsql")
	headinglines:={self:oLan:Rget("Overview of generated automatic collection (SEPA DD)"),self:oLan:Rget("Name",41)+self:oLan:Rget("Bankaccount",25)+;
		self:oLan:Rget("Amount",12,,"R")+" "+self:oLan:Rget("Destination",12)+self:oLan:Rget("Due Date",11)+' '+self:oLan:Rget("Stat",4)+" "+self:oLan:Rget("Description",20),Replicate('-',134)}
	// write Header
	// remove old SEPADD-files:
	aDir := Directory(CurPath +"\SEPADD*.xml") 
	// determine sequencenumber per day:
	nSeq:=1
	FOR i := 1 upto ALen(ADir)
		if ADir[i][F_DATE] < (Today()-12) 	
			(FileSpec{ADir[i][F_NAME]}):DELETE() 
			FErase(ADir[i][F_NAME])
		elseif ADir[i][F_DATE] == Today() 
			nSeq++
		endif
	NEXT
	self:Pointer := Pointer{POINTERARROW}
	oReport := PrintDialog{self,self:oLan:WGet('Producing of')+' SEPA DD'+DToS(Today())+Str(nSeq,-1)+" file",,140}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	self:Pointer := Pointer{POINTERHOURGLASS}
	// calculate date to send and requested collection dates:
	cErrMsg:='' 
	dSenddate:=Today()
	if DoW(dSenddate)=1
		dSenddate+1
	elseif DoW(dSenddate)=7
		dSenddate+2
	endif
	if Month(dSenddate)=12.and.Day(dSenddate)=25
		dSenddate++  // skip christmas
	elseif Month(dSenddate)=1.and.Day(dSenddate)=1
		dSenddate++  // skip new year
	endif
	for SeqTp:=1 to Len(aSeqTp)
		// determine requested collection date:
		// for first and single 5 work days ahead(= 1 week), otherwise 2 work days
		dReqCol:=dSenddate+iif(SeqTp=1.or.SeqTp=4,7,2)  
		if DoW(dReqCol)=1
			dReqCol+=2     // on Sunday go to Tuesday
		elseif DoW(dReqCol)=7
			dReqCol+=2     // on saturday: go to Monday
		endif
		if Month(dReqCol)=12.and.Day(dReqCol)=25
			dReqCol++  // skip christmas
		elseif Month(dReqCol)=1.and.Day(dReqCol)=1
			dReqCol++  // skip new year
		endif
		dReqCol:=Max(dReqCol,process_date)
// 		dMaxReqCol:=Max(dMaxReqCol,dReqCol)
		aSeqTp[SeqTp,2]:=dReqCol
	next
	oSepaConv:=SEPAConv{}
	for i:=1 to Len(aDue)
		cBank:=aDue[i,11] 
		cBic:=aDue[i,17]
		nTerm:=Val(aDue[i,10])
		invoicedate:=SQLDate2Date(aDue[i,8]) 
		AmountInvoice:=Val(aDue[i,7])
		cAmnt:=Str(AmountInvoice,-1,2)
		cType:=aDue[i,15]
		cPersId:= aDue[i,3]
		cAccID:=aDue[i,4]
		if AmountInvoice> fLimitInd
			cErrMsg+=CRLF+self:oLan:WGet("Direct debit amount of person")+' '+aDue[i,16]+"(Intern ID "+cPersId+") "+self:oLan:WGet("is above limit")+'! ('+Str(fLimitInd,-1)+sCurr+')'
			loop
		endif
		
		IF !IsSEPA(cBank)
			cErrMsg+=CRLF+"Bankaccount "+cBank+" of person "+aDue[i,16]+"(Intern ID "+cPersId+") is not correct SEPA bank account!"
			loop
		endif
		// aDue:
		// dueid,subscribid,personid,accid,begindate,seqtype,AmountInvoice,invoicedate,seqnr,term,bankaccnt,accnumber,clc,category,type,personname,bic,mailingcodes,mandate id , firstinvoicedate,bankaccntprv,bicprv
		//    1       2         3       4     5        6         7             8         9    10     11         12     13      14   15     16       17     18            19            20              21        22

		// determine description from Subscription: 
		IF Empty(nTerm) .or.nTerm>12
			cDescr:=aDescr[1] 
		elseif nTerm==1 .or.nTerm==2
			cDescr:=aDescr[nTerm+1]+' ' +Lower(maand[Month(invoicedate)])+" "+Str(Year(invoicedate),-1)  
		elseif nTerm==3
			cDescr:=aDescr[nTerm+1] +' '+Str(Floor((Month(invoicedate)-1)/4)+1,-1)+" "+Str(Year(invoicedate),-1)
		elseif nTerm==6
			cDescr:=aDescr[nTerm+1] +' '+Str(Floor((Month(invoicedate)-1)/6)+1,-1)+" "+Str(Year(invoicedate),-1)
		elseif nTerm==12
			cDescr:=aDescr[nTerm+1] +' '+Str(Year(invoicedate),-1)
		else
			cDescr:=aDescr[nTerm+1] 
		ENDIF
		if !Empty(nTerm) .and. nTerm<=12 .and. aDue[i,6]<>'3' 
			// prenotification:
			// 			cDescr+=', '+self:oLan:RGet("mandate id")+':'+aDue[i,19]+', '+cNextDD+': '+Lower(maand[Mod(Month(invoicedate)+nTerm,12)])+' '+Str(Year(invoicedate)+Floor((Month(invoicedate)+nTerm)/12),-1)
			cDescr+=', '+cNextDD+': '+Lower(maand[Mod(Month(invoicedate)+nTerm-1,12)+1])+' '+Str(Year(invoicedate)+Floor((Month(invoicedate)+nTerm-1)/12),-1)
		endif
// 		oReport:PrintLine(@nRow,@nPage,;
// 			Pad(aDue[i,16],40)+" "+Pad(cBank,25)+Str(AmountInvoice,12,2)+' '+Pad(aDue[i,12],12)+DToC(invoicedate)+'  '+aSeqTp[Val(aDue[i,6]),1]+"  "+cDescr,headinglines)  
		fSum:=Round(fSum+AmountInvoice,DecAantal) 
		// add to aTrans:
		AAdd(aTrans,{cAccID,cPersId,cAmnt,cDescr,cType,aDue[i,13],aDue[i,14],aDue[i,1]})
		//                 1         2              3               4      5         6         7                 8 
		// add to aTransValues
		//aTransValues: accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid 
		//                1    2     3      4      5      6            7      8   9  10      11         12    13     14       15      16    17   18
		// first row:
		AAdd(aTransValues,{m56_Payahead,cAmnt,cAmnt,'0.00','0.00',sCurr,cDescr,cTransDate,'',LOGON_EMP_ID,'2','1','COL','','0','0','',''})
		// second row:
		AAdd(aTransValues,{cAccID,'0.00','0.00',cAmnt,cAmnt,sCurr,cDescr,cTransDate,iif(cType=='M',"AG",""),LOGON_EMP_ID,'2','2','COL','',iif(Empty(cPersId),'0',cPersId),'0','',''})
		// add person data:
		IF	!Empty(cType) .and. (cType	==	'G' .or.	cType	==	'M' .or.	cType	==	'D') 
			cAccMlCd:= aDue[i,18]	
			cAccMlCd:=ADDMLCodes(Transform(aDue[i,13],""),cAccMlCd)
			cAccMlCd:=ADDMLCodes('FI',cAccMlCd)	
			AAdd(avaluesPers,{cPersId,cTransDate,AddSlashes(cAccMlCd)} )
		endif 
		// add to balance values:
		// {accid,year,month,currency,deb,cre} 
		j:=AScan(aMbalValues,{|x|x[1]==cAccID})
		if j>0
			fMbal:=aMbalValues[j,6]
			aMbalValues[j,6]:=Round(fMbal+AmountInvoice,DecAantal)
		else
			AAdd(aMbalValues,{cAccID,cYear,cMonth,sCurr,0.00,AmountInvoice})		
		endif 
		// determine ,SeqTp(1=FRST/2=RECUR,3=FNAL,4=OOFF): 
		SeqTp:=Val(aDue[i,6]) 
		if SeqTp=2 .or. SeqTp=3
			SeqTp:=2  // no FNAL for flexibility to change it later
			if !Empty(aDue[i,21]) .and. !Empty(aDue[i,22])
				// amendment present:
				AAdd(aMndmnt,aDue[i,2]) 
				if !aDue[i,11]==aDue[i,21] .and.!Empty(aDue[i,17]).and.!aDue[i,17]==aDue[i,22]
					// bank account changed to new bank: set in FRST group
					SeqTp:=1
					// generate new mandate id because error in RABO::
// 					aDue[i,19]:=UpdatemandateId(aDue[i,12],aDue[i,3])    // Rabo has promised to accept same mandateid
				endif 
			endif
			aDue[i,6]:=Str(SeqTp,-1)
		endif
		oReport:PrintLine(@nRow,@nPage,;
		Pad(aDue[i,16],40)+" "+Pad(cBank,25)+Str(AmountInvoice,12,2)+' '+Pad(aDue[i,12],12)+DToC(invoicedate)+'  '+aSeqTp[Val(aDue[i,6]),1]+"  "+cDescr,headinglines)  
		if aDue[i,20]="0000-00-00" .or.SeqTp=1
			AAdd(aSubvalues,{aDue[i,2],aDue[i,8],aDue[i,19]}) // save invoice as firstinvoicedate : subscripid,invoicedate,mandateid
		endif
		if (nGrpNbr:=AScan(aGrp,{|x|x[1]==aSeqTp[SeqTp,1] .and.x[4]<1000}))==0
			nGrpNbr:=Len(aGrp)+1
			AAdd(aGrp,{aSeqTp[SeqTp,1],'wosDD'+sEntity+DToS(Today())+Str(nSeq,-1)+Str(nGrpnbr,-1),aSeqTp[SeqTp,2],0,0.00}) //{type,groupid,reqcolldate,total transactions, ctrl sum}
		endif
		aGrp[nGrpNbr,4]++
		aGrp[nGrpNbr,5]:=Round(aGrp[nGrpNbr,5]+AmountInvoice,DecAantal)
		// add to aDD for mailing DD file:
		// aDD: {{AmountInvoice,mandateidid,begindate,PersonName,banknbr,description,invoiceid,seqtp,Bic,Iban previous,Bic previous,nGrpNbr},...
		//               1         2           3         4           5      6            7      8    9    10             11            12
		AAdd(aDD,{cAmnt,aDue[i,19],aDue[i,5],oSepaConv:SepaFormat([i,16]),cBank,oSepaConv:SepaFormat(cDescr),cPersId+'-'+DToS(invoicedate)+'-'+aDue[i,1],SeqTp,cBic,aDue[i,21],aDue[i,22],nGrpnbr})
	next

	oReport:PrintLine(@nRow,@nPage,Replicate('-',134),headinglines,3)
	oReport:PrintLine(@nRow,@nPage,Space(66)+Str(Round(fSum,2),12,2),headinglines)
	oReport:prstart()
	oReport:prstop()
	self:Pointer := Pointer{POINTERARROW} 
	if !Empty(cErrMsg)
		ErrorBox{self,self:oLan:WGet("With the following donations are problems")+':'+cErrMsg}:Show()
		return false
	endif
	if fSum>fLimitBatch
		if TextBox{self,self:oLan:WGet("Direct Debit"),self:oLan:WGet("Total direct debit amount")+' '+Str(fSum,-1)+' '+self:oLan:WGet("is above limit")+'! ('+Str(fLimitBatch,-1)+sCurr+')'+CRLF+self:oLan:WGet("Continue")+'?',BOXICONQUESTIONMARK + BUTTONYESNO}:Show()==BOXREPLYNO
			return false
		endif
	endif 
		* Datafile aanmaken:
	cFilename := "SEPADD"+DToS(Today())+Str(nSeq,-1)+'.xml' 
	oWarn:=TextBox{self,self:oLan:WGet("Direct Debit"),;
		self:oLan:WGet("Printing O.K.")+'? '+self:oLan:WGet("Can file")+;
		Space(1)+cFilename+' '+CRLF+self:oLan:WGet("with shown")+' '+Str(Len(aTrans),-1)+' '+' transactions('+sCurrName+Str(fSum,-1)+') '+self:oLan:WGet("be imported into telebanking")+'?',BOXICONQUESTIONMARK + BUTTONYESNO}
	IF !(oWarn:Show() = BOXREPLYYES)
		Return false
	endif
	oMainWindow:STATUSMESSAGE("Producing SEPA Direct Debit file, moment please")
	self:Pointer := Pointer{POINTERHOURGLASS}
	* Prepare Datafile:
	cFilename:=cFilename := "SEPADD"+DToS(Today())+Str(nSeq,-1) 
	ToFileFS:=AskFileName(self,@cFilename,"Creating SEPA_DD-file","*.XML","XML Data",@lAppend) 
	if Empty(ToFileFS)
		return false
	endif
	cFilename:=ToFileFS:FullPath 
	ptrHandle := MakeFile(self,@cFilename,"Creating SEPA_DD-file")
	IF ptrHandle = F_ERROR .or. ptrHandle==nil
		self:Pointer := Pointer{POINTERARROW}
		RETURN false
	ENDIF
	//	write	document	and group header:	
	lSetAMPM:=SetAmPm(false)
	cOrgName:=oSepaConv:SepaFormat(cOrgName)
	//			'xmnls:xsi="http://www.w3.org/2001/XMLSchema-instance">'+CRLF+;
		FWriteLineUni(ptrHandle,'<?xml version="1.0" encoding="UTF-8"?>'+CRLF+;
		'<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.008.001.02" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+CRLF+;
		'<CstmrDrctDbtInitn>'+CRLF+;
		'<GrpHdr>'+CRLF+;
		'<MsgId>wos'+sEntity+DToS(Today())+Str(nSeq,-1)+'</MsgId>'+CRLF+;
		'<CreDtTm>'+SQLdate(Today())+'T'+Time()+'</CreDtTm>'+CRLF+;
		'<NbOfTxs>'+Str(Len(aTrans),-1)+'</NbOfTxs>'+CRLF+;
		'<CtrlSum>'+Str(fSum,-1,2)+'</CtrlSum>'+CRLF+;
		'<InitgPty>'+CRLF+;
		'<Nm>'+cOrgName+'</Nm>'+CRLF+;
		'</InitgPty>'+CRLF+;                                                                                
	'</GrpHdr>')
	SetAmPm(lSetAMPM)	//	reset	AMPM 
	// write transactions from aDD:
	// aDD: {{AmountInvoice,mandateid,begindate,PersonName,banknbr,description,invoiceid,seqtp,Bic,Iban previous,Bic previous,nGrpnbr},...
	//               1         2           3         4           5      6            7      8    9    10             11          12
	ASort(aDD,,,{|x,y|x[12]<=y[12]})         // sort by groupnbr
// 	ASort(aDD,,,{|x,y|x[8]<y[8] .or. x[8]==y[8].and.x[12]<=y[12]})
	SeqTp:=0
	nGrpnbr:=0 
	for i:=1 to Len(aDD)
		if !nGrpnbr==aDD[i,12]
// 		if !SeqTp==aDD[i,8]
			//new seqtp thus new PmtInf
			SeqTp:=aDD[i,8]
			nGrpnbr:=aDD[i,12] 
			dReqCol:=aGrp[nGrpnbr,3]            //aGrp: {type,PmtInfId,reqdcoll,total transactions, ctrl sum}  
			if aDD[i,10]=='NL16RABO0127266968'
				i:=i
			endif
			AAdd(DrctDbtTxInf,iif(i=1,'','</PmtInf>'+CRLF)+'<PmtInf>'+CRLF+;
				'<PmtInfId>'+aGrp[nGrpnbr,2]+'</PmtInfId>'+CRLF+; 
			'<PmtMtd>DD</PmtMtd>'+CRLF+;
				'<BtchBookg>true</BtchBookg>'+CRLF+;
				'<NbOfTxs>'+Str(aGrp[nGrpnbr,4],-1)+'</NbOfTxs>'+CRLF+;
				'<CtrlSum>'+Str(aGrp[nGrpnbr,5],-1,2)+'</CtrlSum>'+CRLF+; 
			'<PmtTpInf>'+CRLF+;
				'<SvcLvl><Cd>SEPA</Cd></SvcLvl>'+CRLF+;
				'<LclInstrm><Cd>CORE</Cd></LclInstrm>'+CRLF+;
				'<SeqTp>'+aGrp[nGrpnbr,1]+'</SeqTp>'+CRLF+;
				'</PmtTpInf>' +CRLF+;
				'<ReqdColltnDt>'+SQLdate(dReqCol)+'</ReqdColltnDt>'+CRLF+;       
			'<Cdtr>'+CRLF+;
				'<Nm>'+cOrgName+'</Nm>'+CRLF+;
				'</Cdtr>'+CRLF+;
				'<CdtrAcct>'+CRLF+;
				'<Id>'+CRLF+;
				'<IBAN>'+BANKNBRDEB+'</IBAN>'+CRLF+;
				'</Id>'+CRLF+;
				'<Ccy>'+m56_currency+'</Ccy>'+CRLF+;
				'</CdtrAcct>'+CRLF+;
				'<CdtrAgt><FinInstnId><BIC>RABONL2U</BIC></FinInstnId></CdtrAgt>'+CRLF+;
				'<ChrgBr>SLEV</ChrgBr>'+CRLF+; 
			'<CdtrSchmeId><Id><PrvtId><Othr><Id>'+CreditorID+'</Id><SchmeNm><Prtry>SEPA</Prtry></SchmeNm></Othr></PrvtId></Id></CdtrSchmeId>') 
		endif

		// aDD: {{AmountInvoice,mandateid,begindate,PersonName,banknbr,description,invoiceid,seqtp,Bic,Iban previous,Bic previous},...
		//               1         2           3         4           5      6            7      8    9    10             11
		AAdd(DrctDbtTxInf,'<DrctDbtTxInf>'+CRLF+;
			'<PmtId>'+CRLF+; 
		'<EndToEndId>'+aDD[i,7]+'</EndToEndId>'+CRLF+;     // invoiceid
		'</PmtId>'+CRLF+;
			'<InstdAmt  Ccy="EUR">'+aDD[i,1]+'</InstdAmt>'+CRLF+;    //  AmountInvoice
		'<DrctDbtTx><MndtRltdInf><MndtId>'+aDD[i,2]+'</MndtId><DtOfSgntr>'+aDD[i,3]+'</DtOfSgntr>'+; 
		iif(!Empty(aDD[i,10]) .and. !Empty(aDD[i,11]) .and.!aDD[i,5]==aDD[i,10],; // amendment present:
		'<AmdmntInd>true</AmdmntInd>'+CRLF+'<AmdmntInfDtls>'+CRLF+;      
		iif(!Empty(aDD[i,9]).and.!aDD[i,9]==aDD[i,11],; // bank account changed to new bank: orig bic SMNDA
		'<OrgnlDbtrAgt><FinInstnId><Othr><Id>SMNDA</Id></Othr></FinInstnId></OrgnlDbtrAgt>',;
			'<OrgnlDbtrAcct><Id><IBAN>'+aDD[i,10]+'</IBAN></Id></OrgnlDbtrAcct>')+CRLF+'</AmdmntInfDtls>'+CRLF,'')+;
			'</MndtRltdInf></DrctDbtTx>'+CRLF+; 
		'<DbtrAgt><FinInstnId>'+iif(!Empty(aDD[i,9]),'<BIC>'+aDD[i,9]+'</BIC>','')+'</FinInstnId></DbtrAgt>'+CRLF+;
			'<Dbtr>'+CRLF+;
			'<Nm>'+HtmlEncode(aDD[i,4])+'</Nm>'+CRLF+;
			'</Dbtr>'+CRLF+;
			'<DbtrAcct>'+CRLF+;
			'<Id>'+CRLF+;
			'<IBAN>'+aDD[i,5]+'</IBAN>'+CRLF+;
			'</Id>'+CRLF+;
			'</DbtrAcct>'+CRLF+;
			'<RmtInf>'+CRLF+;
			'<Ustrd>'+HtmlEncode(aDD[i,6])+'</Ustrd>'+CRLF+;   // description
		'</RmtInf>'+CRLF+;
			'</DrctDbtTxInf>')
// 		AAdd(DrctDbtTxInf,'<DrctDbtTxInf>'+CRLF+;
// 			'<PmtId>'+CRLF+; 
// 		'<EndToEndId>'+aDD[i,7]+'</EndToEndId>'+CRLF+;     // invoiceid
// 		'</PmtId>'+CRLF+;
// 			'<InstdAmt  Ccy="EUR">'+aDD[i,1]+'</InstdAmt>'+CRLF+;    //  AmountInvoice
// 		'<DrctDbtTx><MndtRltdInf><MndtId>'+aDD[i,2]+'</MndtId><DtOfSgntr>'+aDD[i,3]+'</DtOfSgntr>'+; 
// 		iif(!Empty(aDD[i,10]) .and. !Empty(aDD[i,11]) .and.!aDD[i,5]==aDD[i,10].and.aDD[i,9]==aDD[i,11],; // amendment present for same bank:
// 		'<AmdmntInd>true</AmdmntInd>'+CRLF+'<AmdmntInfDtls>'+CRLF+;      
// 			'<OrgnlDbtrAcct><Id><IBAN>'+aDD[i,10]+'</IBAN></Id></OrgnlDbtrAcct>'+CRLF+'</AmdmntInfDtls>'+CRLF,'')+;
// 			'</MndtRltdInf></DrctDbtTx>'+CRLF+; 
// 		'<DbtrAgt><FinInstnId>'+iif(!Empty(aDD[i,9]),'<BIC>'+aDD[i,9]+'</BIC>','')+'</FinInstnId></DbtrAgt>'+CRLF+;
// 			'<Dbtr>'+CRLF+;
// 			'<Nm>'+HtmlEncode(aDD[i,4])+'</Nm>'+CRLF+;
// 			'</Dbtr>'+CRLF+;
// 			'<DbtrAcct>'+CRLF+;
// 			'<Id>'+CRLF+;
// 			'<IBAN>'+aDD[i,5]+'</IBAN>'+CRLF+;
// 			'</Id>'+CRLF+;
// 			'</DbtrAcct>'+CRLF+;
// 			'<RmtInf>'+CRLF+;
// 			'<Ustrd>'+HtmlEncode(aDD[i,6])+'</Ustrd>'+CRLF+;   // description
// 		'</RmtInf>'+CRLF+;
// 			'</DrctDbtTxInf>')
		if Len(DrctDbtTxInf)>= 100
			FWriteLineUni(ptrHandle,Implode(DrctDbtTxInf,CRLF))		 // write per 100 transactions to reduce I/O
			DrctDbtTxInf:={}
		endif
	next
	if Len(DrctDbtTxInf) > 0
		FWriteLineUni(ptrHandle,Implode(DrctDbtTxInf,CRLF))		 // write latest transactions 
	endif
	// Write closing lines:
	FWriteLineUni(ptrHandle,'</PmtInf>'+CRLF+'</CstmrDrctDbtInitn>'+CRLF+'</Document>')
	FClose(ptrHandle)
	self:Pointer := Pointer{POINTERARROW} 
	if TextBox{self,"Direct Debits",cFilename+' '+self:oLan:WGet("successfully uploaded to your online banking")+'?',BOXICONQUESTIONMARK + BUTTONYESNO}:Show()==BOXREPLYNO
		// remove file:
		(FileSpec{cFilename}):DELETE() 
		cFilename:=""
		return true
	endif


	oMainWindow:STATUSMESSAGE("Recording direct debit transactions") 
	self:oCCCancelButton:Disable()
	self:oCCOKButton:Disable()

	self:Pointer := Pointer{POINTERHOURGLASS}

	if !Empty(SINCHOME) .or.!Empty(SINC)
		// add transactions for ministry income/expense:
		oAddInEx:=AddToIncExp{}
		for i:=2 to Len(aTransValues) step 2
			nSeqnbr:=2 
			aTransIncExp:=oAddInEx:AddToIncome(aTransValues[i,9],false,aTransValues[i,1],Val(aTransValues[i,4]),Val(aTransValues[i,2]),Val(aTransValues[i,3]),Val(aTransValues[i,5]),aTransValues[i,6],;
				aTransValues[i,7],aTransValues[i,15],aTransValues[i,8],aTransValues[i,13],@nSeqnbr,aTransValues[i,11]) 
			if Len(aTransIncExp)=2
				ASize(aTransValues,Len(aTransValues)+2)
				i++
				AIns(aTransValues,i)
				aTransValues[i]:=aTransIncExp[1]
				i++
				AIns(aTransValues,i)
				aTransValues[i]:=aTransIncExp[2]
				// add to balance values:
				// {accid,year,month,currency,deb,cre} 
				j:=AScan(aMbalValues,{|x|x[1]==aTransIncExp[1,1]})
				if j>0
					aMbalValues[j,5]:=Round(aMbalValues[j,5]+aTransIncExp[1,2],DecAantal)
					aMbalValues[j,6]:=Round(aMbalValues[j,6]+aTransIncExp[1,4],DecAantal)
				else
					AAdd(aMbalValues,{aTransIncExp[1,1],cYear,cMonth,sCurr,aTransIncExp[1,2],aTransIncExp[1,4]})		
				endif
				j:=AScan(aMbalValues,{|x|x[1]==aTransIncExp[2,1]})
				if j>0
					aMbalValues[j,5]:=Round(aMbalValues[j,5]+aTransIncExp[2,2],DecAantal)
					aMbalValues[j,6]:=Round(aMbalValues[j,6]+aTransIncExp[2,4],DecAantal)
				else
					AAdd(aMbalValues,{aTransIncExp[2,1],cYear,cMonth,sCurr,aTransIncExp[2,2],aTransIncExp[2,4]})		
				endif
			endif
		next			
	endif
	// add line for total against payahead:
	AAdd(aMbalValues,{m56_Payahead,cYear,cMonth,sCurr,fSum,0.00})		
	lError:=false
	oStmnt:=SQLStatement{"set autocommit=0",oConn}
	oStmnt:Execute()
	oStmnt:=SQLStatement{'lock tables '+iif(Len(aMndmnt)>0,'`amendment` write,','')+'`dueamount` write,`mbalance` write'+iif(Len(avaluesPers)>0,',`person` write','')+',`subscription` write,`transaction` write',oConn}      // alphabetic order
	oStmnt:Execute()

	// make transactions:
	if !Empty(oStmnt:status)
		lError:=true
	endif
	if !lError
		// Reconcile Due Amounts:
		oStmnt:=SQLStatement{"update dueamount set amountrecvd=amountinvoice where dueid in ("+Implode(aTrans,",",,,8)+")",oConn}
		oStmnt:Execute()
		if	!Empty(oStmnt:status)
			SQLStatement{"rollback",oConn}:Execute() 
			SQLStatement{"unlock tables",oConn}:Execute()
			LogEvent(self,"Due amounts error:"+oStmnt:ErrInfo:ErrorMessage+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
			ErrorBox{,self:oLan:WGet('due amounts could not be updated, nothing recorded')+":"+oStmnt:ErrInfo:ErrorMessage}:Show()
			return false 
		endif
	endif
	if !lError
		//	make transaction:
		* add	first	transaction:
		* against DebitAccount:	
		//	insert first line:
		oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp) "+;
			" values	("+Implode(aTransValues[1],"','",1,16)+')',oConn}
		oStmnt:Execute()
		nTransId:=ConI(SqlSelect{"select	LAST_INSERT_ID()",oConn}:FIELDGET(1)) 
		aTransValues[2,18]:=nTransId
		for i:=3	to	Len(aTransValues)	step 2
			//	next line income/expense?
			if	aTransValues[i,12]=='3'
				aTransValues[i,18]:=nTransId
				aTransValues[i+1,18]:=nTransId
				i+=2
			endif		
			nTransId++
			if	i<Len(aTransValues)
				aTransValues[i,18]:=nTransId
				aTransValues[i+1,18]:=nTransId
			endif
		next 
		for i:=2 to Len(aTransValues) step 2000
			oStmnt:=SQLStatement{"insert into transaction (accid,deb,debforgn,cre,creforgn,currency,description,dat,gc,userid,poststatus,seqnr,docid,reference,persid,fromrpp,opp,transid)	"+;
				" values	"+Implode(aTransValues,"','",i,2000),oConn}
			oStmnt:Execute()
			if	oStmnt:NumSuccessfulRows<1
				SQLStatement{"rollback",oConn}:Execute() 
				SQLStatement{"unlock	tables",oConn}:Execute()
				LogEvent(self,'Transactions could not be inserted:'+oStmnt:ErrInfo:ErrorMessage+CRLF+"stmnt:"+SubStr(oStmnt:SQLString,1,10000),"LogErrors")
				ErrorBox{,self:oLan:WGet('Transactions could	not be inserted, nothing recorded')+":"+oStmnt:ErrInfo:ErrorMessage}:Show()
				return false 
			endif
		next
		//	adapt	mbalance	values: 
		oStmnt:=SQLStatement{"INSERT INTO mbalance (`accid`,`year`,`month`,`currency`,`deb`,`cre`) VALUES "+Implode(aMbalValues,"','")+;
			" ON DUPLICATE KEY UPDATE deb=round(deb+values(deb),2),cre=round(cre+values(cre),2)",oConn}
		oStmnt:Execute()
		if !Empty(oStmnt:status) 
			SQLStatement{"rollback",oConn}:Execute() 
			SQLStatement{"unlock	tables",oConn}:Execute()
			LogEvent(self,'Month balances could not be inserted:'+oStmnt:ErrInfo:ErrorMessage+CRLF+"stmnt:"+SubStr(oStmnt:SQLString,1,10000),"LogErrors")
			ErrorBox{,self:oLan:WGet('Month balances could	not be inserted, nothing recorded')+":"+oStmnt:ErrInfo:ErrorMessage}:Show()
			return false 
		endif
		// oPro:AdvancePro()
		self:Pointer := Pointer{POINTERHOURGLASS}
		if Len(avaluesPers)>0
			*	Update person info of giver: 
			oStmnt:=SQLStatement{'insert into person (persid,datelastgift,mailingcodes) values '+Implode(avaluesPers,'","')+;
				" ON DUPLICATE	KEY UPDATE datelastgift=if(values(datelastgift)>datelastgift,values(datelastgift),datelastgift),mailingcodes=values(mailingcodes)",oConn}
			oStmnt:Execute()
			if	!Empty(oStmnt:status)
				SQLStatement{"rollback",oConn}:Execute() 
				SQLStatement{"unlock tables",oConn}:Execute()
				LogEvent(self,"error:"+oStmnt:ErrInfo:ErrorMessage+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
				ErrorBox{,self:oLan:WGet('persons could not be updated, nothing recorded')+":"+oStmnt:ErrInfo:ErrorMessage}:Show()
				return false 
			endif
		endif 
		if Len(aSubvalues)>0
			// update subscription with first invoice date and new mandate id:
			oStmnt:=SQLStatement{'insert into subscription (subscribid,firstinvoicedate,invoiceid) values '+Implode(aSubvalues,'","')+;
				" on duplicate key update firstinvoicedate=values(firstinvoicedate),invoiceid=values(invoiceid)",oConn}
			oStmnt:Execute()
			if	!Empty(oStmnt:status)
				SQLStatement{"rollback",oConn}:Execute() 
				SQLStatement{"unlock tables",oConn}:Execute()
				LogEvent(self,"error:"+oStmnt:ErrInfo:ErrorMessage+CRLF+"stmnt:"+oStmnt:SQLString,"LogErrors")
				ErrorBox{,self:oLan:WGet('subscription could not be updated, nothing recorded')+":"+oStmnt:ErrInfo:ErrorMessage}:Show()
				return false 
			endif
			
		endif
		if Len(aMndmnt)>0
			oStmnt:=SQLStatement{'delete from amendment where subscribid in ('+Implode(aMndmnt,',')+')',oConn}
			oStmnt:Execute()
			if	!Empty(oStmnt:status)
				SQLStatement{"rollback",oConn}:Execute() 
				SQLStatement{"unlock tables",oConn}:Execute()
				LogEvent(self,"error:"+oStmnt:ErrInfo:ErrorMessage+CRLF+"stmnt:"+oStmnt:sqlstring,"LogErrors")
				ErrorBox{,self:oLan:WGet("amendments could'nt be removed, nothing recorded")+":"+oStmnt:ErrInfo:ErrorMessage}:Show()
				return false 
			endif
		endif
	endif
	if !lError
		SQLStatement{"commit",oConn}:Execute()	
		SQLStatement{"unlock tables",oConn}:Execute()
	endif
	SQLStatement{"set autocommit=1",oConn}:Execute()

	self:oCCCancelButton:Enable()
	self:oCCOKButton:Enable()
	self:Pointer := Pointer{POINTERARROW}
	(InfoBox{self,"Producing SEPADD file","File "+cFilename+" generated with "+Str(Len(aTrans),-1)+" amounts("+sCurrName+Str(fSum,-1)+")"}):Show()
	LogEvent(self, "SEPA Direct Debit file "+cFilename+" generated for month:"+SubStr(DToS(begin_due),1,6)+" with "+Str(Len(aTrans),-1)+;
		" direct debits("+sCurrName+Str(fSum,-1)+")"+CRLF+"Payment Information Segments:"+CRLF+Implode(aGrp,', ',,,,')'+CRLF+'('))

	RETURN true
METHOD RegAccount(oAcc as SQLSelect,ItemName as string) as logic CLASS SelPersPayments
	IF Itemname="Account From"
		IF Empty(oAcc).or.oAcc:reccount<1
			self:mRekSt :=  ""
			self:mRekId := ""
			SELF:oDCselx_rek:TEXTValue := ""
			self:cAccountBeginName := ""
			self:oDCTextfrom:TEXTValue:=""
		ELSE		
			SELF:mRekSt :=  LTrimZero(oAcc:ACCNUMBER)
			self:mRekId := Str(oAcc:accid,-1)
			self:oDCselx_rek:TEXTValue := AllTrim(oAcc:Description)
			SELF:selx_rek:= LTrimZero(oAcc:AccNumber)
			self:cAccountBeginName := AllTrim(oAcc:Description)
			self:oDCTextfrom:TEXTValue:=self:cAccountBeginName
		ENDIF
		self:oDCSubSet:AccNbrStart:=self:mRekSt
		self:oDCFixedText7:Show()
		self:oDCSubSet:Show()
	ELSE
		IF Empty(oAcc).or.oAcc:reccount<1
			SELF:mRekEnd :=  ""
			SELF:oDCselx_rekend:TEXTValue := ""
			SELF:cAccountEndName := ""
			self:oDCTextTill:TEXTValue:= ""
		ELSE		
			SELF:mRekEnd :=  LTrimZero(oAcc:ACCNUMBER)
			self:oDCselx_rekend:TEXTValue := AllTrim(oAcc:Description)
			SELF:selx_rekend:= LTrimZero(oAcc:AccNumber)
			self:cAccountEndName := AllTrim(oAcc:Description)
			self:oDCTextTill:TEXTValue:= AllTrim(oAcc:Description)
		ENDIF
		SELF:oDCSubSet:AccNbrEnd:=SELF:mRekEnd
		SELF:oDCFixedText7:Show()
		SELF:oDCSubSet:Show()
	ENDIF
	
	RETURN TRUE		
STATIC DEFINE SELPERSPRIMARY_SELPERSPRBUTTON1 := 101 
STATIC DEFINE SELPERSPRIMARY_SELPERSPRBUTTON2 := 102 
STATIC DEFINE SELPERSPRIMARY_SELPERSPRBUTTON3 := 103 
STATIC DEFINE SELPERSPRIMARY_SELPERSPRBUTTON4 := 104 
STATIC DEFINE SELPERSPRIMARY_SELX_KEUZE1 := 100 
function SQLGetPersons(myFields as array,cFrom as string,cWherep as string,cSortOrder:="" as string, cMarkupText:="" as string,fMinAmnt:=0 as float,fMaxAmnt:=0 as float,fMinIndVidAmnt:=0 as float) as string 
// Generation of SQLString to select persons with all their fields 
// 
// Parameters:
/*	myFields:	array with {fieldsymbolic,tablefield}...  e.g.{#FIRSTNAME,"p.firstname"}  ; p.:person t.: transaction  
																			groupfields like giftsgroup or banknumbers should have an empty tablefield
	cFrom:		
	cWherep:		conditions for selection persons
	cSortOrder:	required sortorder
	cMarkupText: template with reserved fields like  %AMOUNTGIFT to be returned. This can be a letter or email body
	
*/
//
local cFields as string   // all direct required fields
local cGrFields as string // all required fields on group level 
local cGroup as string   // grouping specification 
local cField as string   // text with one field
local cHaving as string  // having conditions
local cSQLString as string // sqlstring to be returned
local lPropXtr as logic  // are extra properties within the fields? 
local lDestination as logic  // is destination of gift required?
local lDistinct as logic   // is DISTINCT required
local lgrDat as logic  // is selection of <= date required
local lBankacc as logic  // is selection bankaccounts required 
local i,j as int
  
	lPropXtr:=(AScan(myFields,{|x|x[2]="p.propextr"})>0)
	// determine group fields:
	if AScan(myFields,{|x|x[1]== #BANKNUMBER})>0
		lBankacc:=true
		if AScan(myFields,{|x|x[1]== #persid})=0   // persid needed to determine bank account
			cFields+=",p.persid"
		endif 
	endif 
	cGrFields:=StrTran(StrTran(StrTran(StrTran(StrTran(cFields,"p.","gr."),"t.","gr."),"a.","gr."),"d.","gr."),"s.","gr.")
	if !Empty(cMarkupText) .and. (j:=AScan(myFields,{|x|x[1]== #GIFTSGROUP}))>0
		IF AtC("%DESTINATION",cMarkupText)>0
			lDestination:=true
			cFields+=",IFNULL(d.descriptn,a.description) as description"
		endif
		IF AtC("%DATEGIFT",cMarkupText)>0
			lgrDat:=true
			cFields+=",cast(t.dat as date) as dat"
		endif
		IF AtC("%REFERENCEGIFT",cMarkupText)>0
			cFields+=",t.reference"
		endif
		IF AtC("%DOCUMENTID",cMarkupText)>0
			cFields+=",t.docid"
		endif
		IF AtC("%AMOUNTGIFT",cMarkupText)>0
			cFields+=",Round(t.cre-t.deb,2) as amountgift"
		endif
		cMarkupText:="CONCAT('"+StrTran(StrTran(StrTran(StrTran(StrTran(cMarkupText,"%AMOUNTGIFT","',gr.AmountGift,'"),"%DATEGIFT","',date_format(gr.dat,'"+LocalDateFormat+"'),'"),"%DESTINATION","',gr.description,'"),"%REFERENCEGIFT","',gr.reference,'"),"%DOCUMENTID","',gr.docid,'")+"')"
		cMarkupText:=StrTran(StrTran(cMarkupText,"'',",""),",''","")
// 		cGrFields+=",GROUP_CONCAT("+cMarkupText+iif(lgrDat," order by gr.dat","")+" separator '') as "+myFields[j,2]:HyperLabel:Name 
		cGrFields+=",cast(GROUP_CONCAT("+cMarkupText+iif(lgrDat," order by gr.dat","")+" separator '') as char) as giftsgroup" 
		cGroup:=" group by gr.persid"
	endif
	IF (j:=AScan(myFields,{|x|x[1]== #TOTAMNT}))>0 .or. fMinAmnt>0 .or. fMaxAmnt>0 .or. fMinIndVidAmnt>0
		cField:=",Round(t.cre-t.deb,2) as amountgift"
		if AtC(cField,cFields)=0
			cFields+=cField
		endif
		if j>0 .or.fMinAmnt>0 .or. fMaxAmnt>0
			cGrFields+=",round(sum(gr.amountgift),2) as totamnt"
		endif
		if fMinIndVidAmnt>0
			cGrFields+=",max(gr.amountgift) as maxamnt" 
		endif
		cGroup:=" group by gr.persid"
		if fMinAmnt>0 .and. fMaxAmnt>0
			cHaving:=" having totamnt between "+Str(fMinAmnt,-1)+" and "+Str(fMaxAmnt,-1) 
		elseif fMinAmnt>0
			cHaving:=" having totamnt >= "+Str(fMinAmnt,-1)
		elseif fMaxAmnt>0
			cHaving:=" having totamnt <= "+Str(fMaxAmnt,-1)
		endif
		if fMinIndVidAmnt>0
			cHaving+=iif(Empty(cHaving)," having "," and ")+"maxamnt >= "+Str(fMinIndVidAmnt,-1)
		endif 
	endif
	IF (j:=AScan(myFields,{|x|x[1]== #AmountGift}))>0 
		cField:=",Round(t.cre-t.deb,2) as amountgift"
		if AtC(cField,cFields)=0
			cFields+=cField
		endif
		cGrFields+=",gr.amountgift"
	endif
	// determine fields to extract from the database
	for i:=1 to Len(myFields)
		cField:=myFields[i,2]
		IF !Empty(cField)
			if AtC(","+cField,cFields)=0
				cFields+=","+cField
			endif
			cField:=StrTran(StrTran(StrTran(cField,"p.","gr."),"t.","gr."),"a.","gr.") 
			if AtC(","+cField,cGrFields)=0
				cGrFields+=","+cField
			endif
		endif 
	next
	IF Empty(cGroup)
		lDistinct:=AScan(myFields,{|x|x[1]=#AmountGift.or.x[1]=#Dat.or.x[1]=#Reference.or.x[1]=#DOCID.or.x[1]=#Description})=0
		if !lDistinct
			if AtC("persid",cSortOrder)=0
				cSortOrder+=",persid"
			endif
		endif
	ELSE
		if AtC(",p.persid",cFields)=0
			cFields+=",p.persid"
		endif
		if AtC(cSortOrder,cFields)=0
			cFields+=",p."+cSortOrder
		endif
	endif
	cFields:=SubStr(cFields,2)
	cGrFields:=SubStr(cGrFields,2)
	lDestination:=(AtC("a.description",cFields)>0)


	IF lDestination
		if AtC("account",cFrom) =0
			cFrom+=",account as a"
		endif
		if AtC("t.accid=",cWherep)=0
			cWherep+=" and t.accid=a.accid"
		endif
		cFrom:=strtran(cFrom,'account as a','account as a left join department d on (a.department=d.depid and (a.accid=d.netasset or a.accid=d.incomeacc))')
	endif

	cSQLString:=UnionTrans("Select "+iif(lDistinct,"distinct ","")+cFields+" from "+ cFrom+cWherep)
	IF Empty(cGroup)
		if !lBankacc
			cSQLString+=" order by "+StrTran(cSortOrder,"persid","p.persid")
		endif
	else
		cSQLString:="select "+cGrFields+" from ("+cSQLString+") as gr "+cGroup+cHaving+iif(lBankacc,''," order by "+cSortOrder+Collate)
	endif
	if AScan(myFields,{|x|x[1]== #BANKNUMBER})>0
		// add group for getting array with bank accounts per person:
		cSQLString:="select gr2.*,group_concat(pb.banknumber separator ',') as banknumbers from ("+cSQLString+") as gr2 left join personbank pb on (pb.persid=gr2.persid) group by gr2.persid order by "+cSortOrder+Collate
	endif 
	return cSQLString
	
class SQLSelectPerson inherit SQLSelect
	export oLan as Language
	export oPrsBnk as SQLSelect 
	export cTel,cDay,cNight,cFax,cMobile,cAbrv,cMr,cMrs,cCouple as string  // texts for use in reports
Method GetFullName(PersNbr,Purpose) CLASS SQLSelectPerson
// composition of full name of a person
// PersNbr: Optional ID of person 
// Purpose: optional indicator that the name is used for:
// 	0: addresslist: with surname "," firstname prefix (without salutation) 
//		1: fullname conform address specification
//		2: name for identification: lastname, firstname prefix 
//		3: like 1 but always with firstname 
LOCAL frstnm,naam1, titel,prefix as STRING
// LOCAL nCurRec as int
Default(@PersNbr,nil)
Default(@Purpose,0)
IF !self:Used
	RETURN null_string
ENDIF
// nCurRec:=self:RecNo
IF !IsNil(PersNbr) .and.!PersNbr==self:FIELDGET(#persid)
	IF Empty(PersNbr)
		RETURN ""
	ENDIF
	self:seek(#persid,PersNbr)
ENDIF
if sSalutation .and.(Purpose==1.or.Purpose==3) 
	titel := self:Salutation
	if !Empty(titel)
		titel+=" "
	endif
endif
IF TITELINADR.and.!Empty(self:Title) .and.(Purpose==1.or.Purpose==3) 
	titel += AllTrim(self:Title)+' '
endif
IF .not. Empty(self:FIELDGET(#prefix))
   prefix :=AllTrim(self:FIELDGET(#prefix)) +" "
ENDIF
IF .not. Empty(self:FIELDGET(#lastname))
   naam1 := AllTrim(self:FIELDGET(#lastname))+" "
ENDIF
IF sFirstNmInAdr .or. (Purpose==2.or.Purpose==3)
	IF !Empty(self:FIELDGET(#firstname) )
		frstnm += AllTrim(self:FIELDGET(#firstname))+' '
	ELSEIF .not. Empty(self:FIELDGET(#initials))  && anders voorletters gebruiken
		frstnm += AllTrim(self:FIELDGET(#initials))+' '
	ENDIF
ELSEIF .not. Empty(self:FIELDGET(#initials))  && anders voorletters gebruiken
	frstnm += AllTrim(self:FIELDGET(#initials))+' '
ENDIF
DO CASE
case Purpose==0
	//addresslist:
	naam1:=AllTrim(naam1)+iif(!sSurnameFirst.and.!(Empty(frstnm).and.Empty(prefix)),", "," ")+frstnm+prefix
Case Purpose==1.or.Purpose==3
	// address conform address specifications:
	IF sSurnameFirst
   	naam1 := naam1+titel+frstnm + prefix
	else
		naam1:=titel+frstnm+prefix+naam1
	endif	
CASE Purpose==2
	// identification:
	naam1:=AllTrim(naam1)+iif(!sSurnameFirst.and.!(Empty(frstnm).and.Empty(prefix)),", "," ")+frstnm+prefix
endcase
// if !IsNil(PersNbr) .and.!nCurRec==self:RecNo
// 	self:Goto(nCurRec)
// endif
return (AllTrim(naam1))
Method Init(cSQLSelect, oSQLConnection) class SQLSelectPerson
	super:Init(cSQLSelect, oSQLConnection)
	self:oLan:=Language{}
		cCouple:= oLan:Rget("Mr&Mrs")
		cMr:= oLan:Rget("Mr",,"!")
		cMrs:= oLan:Rget("Mrs",,"!")
		cTel:=oLan:Rget("Telephone",,"!")
		cDay:=oLan:Rget('at day')
		cNight:=oLan:Rget("at night")
		cAbrv:=oLan:Rget("Abbreviated mailingcodes")
		cFax:=oLan:Rget("fax")
		cMobile:=oLan:Rget("mobile")

	return self 

	
ACCESS  Salutation  CLASS SQLSelectPerson
	// Return salutation of a person: 
	local iG:= int(_cast,self:FIELDGET(#GENDER)) as int
	if Empty(iG).or.iG>5 .or.iG<0
		iG:=5
	endif
	return pers_salut[iG,1]  

Function TYPEDSCR(nTp as int) as string
	// Return Gender description of a person:
	RETURN pers_types[AScan(pers_types,{|x|x[2]==nTp}),1]
