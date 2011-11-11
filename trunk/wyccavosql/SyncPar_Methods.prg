Function GetInitials(voornamen as string) as string
local cInit as string, aWord as array , i as int
aWord:=Split(AllTrim(voornamen)) 
AEval(aWord,{|x|cInit+=SubStr(x,1,1)+"."})
return  AllTrim(cInit) 
STATIC DEFINE SELCORRPERSON_CORPERSONS := 100 
STATIC DEFINE SELCORRPERSON_FIXEDTEXT1 := 102 
STATIC DEFINE SELCORRPERSON_FIXEDTEXT2 := 103 
STATIC DEFINE SELCORRPERSON_GIVERSBOX := 104 
STATIC DEFINE SELCORRPERSON_OKBUTTON := 101 
CLASS SelectCorrPerson INHERIT DataDialogMine 

	PROTECT oDCCorPersons AS LISTBOX
	PROTECT oCCOKButton AS PUSHBUTTON
	PROTECT oCCSkipButton AS PUSHBUTTON
	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCGiversBox AS LISTBOX

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line)
   export selCln as int
   protect currGiver as int 
   protect oOwner as object
RESOURCE SelectCorrPerson DIALOGEX  4, 3, 411, 272
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", SELECTCORRPERSON_CORPERSONS, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_NOTIFY|WS_TABSTOP|WS_CHILD|WS_BORDER|WS_VSCROLL, 4, 103, 400, 145, WS_EX_CLIENTEDGE
	CONTROL	"Select", SELECTCORRPERSON_OKBUTTON, "Button", WS_TABSTOP|WS_CHILD, 352, 251, 53, 12
	CONTROL	"Not Existing", SELECTCORRPERSON_SKIPBUTTON, "Button", WS_TABSTOP|WS_CHILD, 4, 251, 53, 12
	CONTROL	"Corresponds with the following person of the website :", SELECTCORRPERSON_FIXEDTEXT1, "Static", WS_CHILD, 4, 84, 200, 13
	CONTROL	"The giver:", SELECTCORRPERSON_FIXEDTEXT2, "Static", WS_CHILD, 6, 3, 182, 13
	CONTROL	"", SELECTCORRPERSON_GIVERSBOX, "ListBox", LBS_DISABLENOSCROLL|LBS_NOINTEGRALHEIGHT|LBS_NOTIFY|WS_CHILD|WS_BORDER|WS_VSCROLL, 4, 15, 400, 58, WS_EX_CLIENTEDGE
END

method AddWebPersons(aCorPers, GivPtr) class SelectCorrPerson	
	self:oDCCorPersons:FillUsing(aCorPers) 
	self:oDCCorPersons:CurrentItemNo:=iif(Empty(GivPtr),1,GivPtr)
	return nil 
ACCESS CorPersons() CLASS SelectCorrPerson
RETURN SELF:FieldGet(#CorPersons)

ASSIGN CorPersons(uValue) CLASS SelectCorrPerson
SELF:FieldPut(#CorPersons, uValue)
RETURN uValue

ACCESS GiversBox() CLASS SelectCorrPerson
RETURN SELF:FieldGet(#GiversBox)

ASSIGN GiversBox(uValue) CLASS SelectCorrPerson
SELF:FieldPut(#GiversBox, uValue)
RETURN uValue

METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS SelectCorrPerson 
LOCAL DIM aBrushes[1] AS OBJECT

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"SelectCorrPerson",_GetInst()},iCtlID)

aBrushes[1] := Brush{Color{202,255,255}}

oDCCorPersons := ListBox{SELF,ResourceID{SELECTCORRPERSON_CORPERSONS,_GetInst()}}
oDCCorPersons:HyperLabel := HyperLabel{#CorPersons,NULL_STRING,"Persons already in the database that correspond with the person to be imported",NULL_STRING}
oDCCorPersons:UseHLforToolTip := True

oCCOKButton := PushButton{SELF,ResourceID{SELECTCORRPERSON_OKBUTTON,_GetInst()}}
oCCOKButton:HyperLabel := HyperLabel{#OKButton,"Select",NULL_STRING,NULL_STRING}

oCCSkipButton := PushButton{SELF,ResourceID{SELECTCORRPERSON_SKIPBUTTON,_GetInst()}}
oCCSkipButton:HyperLabel := HyperLabel{#SkipButton,"Not Existing",NULL_STRING,NULL_STRING}

oDCFixedText1 := FixedText{SELF,ResourceID{SELECTCORRPERSON_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Corresponds with the following person of the website :",NULL_STRING,NULL_STRING}
oDCFixedText1:TextColor := Color{COLORBLUE}

oDCFixedText2 := FixedText{SELF,ResourceID{SELECTCORRPERSON_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"The giver:",NULL_STRING,NULL_STRING}
oDCFixedText2:TextColor := Color{COLORBLUE}

oDCGiversBox := ListBox{SELF,ResourceID{SELECTCORRPERSON_GIVERSBOX,_GetInst()}}
oDCGiversBox:BackGround := aBrushes[1]
oDCGiversBox:HyperLabel := HyperLabel{#GiversBox,NULL_STRING,NULL_STRING,NULL_STRING}

SELF:Caption := "Synchronise givers with person administration"
SELF:HyperLabel := HyperLabel{#SelectCorrPerson,"Synchronise givers with person administration",NULL_STRING,NULL_STRING}
SELF:AllowServerClose := False

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method ListBoxSelect(oControlEvent) class SelectCorrPerson
	local oControl as Control
	oControl := iif(oControlEvent == null_object, null_object, oControlEvent:Control)
	super:ListBoxSelect(oControlEvent)
	//Put your changes here 
	IF oControlEvent:NameSym==#GiversBox
		self:oDCGiversBox:CurrentItemNo:=self:currGiver      // reset on current giver
	endif
	return nil
method MoveGiverPtr(GPTR) class SelectCorrPerson 
local nMax as int
nMax:=Min(GPTR+3,self:oDCGiversBox:ItemCount)
self:oDCGiversBox:CurrentItemNo:=nMax
self:oDCGiversBox:CurrentItemNo:=GPTR
self:currGiver:=GPTR
return
METHOD OKButton(oPersChg ) CLASS SelectCorrPerson 
self:selCln:=self:oDCCorPersons:GetItemValue(self:oDCCorPersons:CurrentItemNo) 

self:EndWindow()
RETURN nil
method PostInit(oWindow,iCtlID,oServer,uExtra) class SelectCorrPerson
	//Put your PostInit additions here 
	self:SetTexts()
	self:oDCGiversBox:FillUsing(uExtra)
	self:oOwner:=oWindow 
	self:selCln:=-1
	return nil
METHOD SkipButton( ) CLASS SelectCorrPerson 
   self:selCln:=0
	self:EndWindow()
RETURN nil
STATIC DEFINE SELECTCORRPERSON_CORPERSONS := 100 
STATIC DEFINE SELECTCORRPERSON_FIXEDTEXT1 := 103 
STATIC DEFINE SELECTCORRPERSON_FIXEDTEXT2 := 104 
STATIC DEFINE SELECTCORRPERSON_GIVERSBOX := 105 
STATIC DEFINE SELECTCORRPERSON_OKBUTTON := 101 
STATIC DEFINE SELECTCORRPERSON_SKIPBUTTON := 102 
RESOURCE Synchronize DIALOGEX  4, 3, 568, 96
STYLE	WS_CHILD
FONT	8, "MS Shell Dlg"
BEGIN
	CONTROL	"", SYNCHRONIZE_INTRODUCTION, "Static", WS_CHILD, 4, 3, 555, 66
	CONTROL	"Synchronize", SYNCHRONIZE_SYNC, "Button", WS_TABSTOP|WS_CHILD, 472, 74, 54, 12
END

CLASS Synchronize INHERIT DataWindowMine 

	PROTECT oDCIntroduction AS FIXEDTEXT
	PROTECT oCCSync AS PUSHBUTTON

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
METHOD Init(oWindow,iCtlID,oServer,uExtra) CLASS Synchronize 

self:PreInit(oWindow,iCtlID,oServer,uExtra)

SUPER:Init(oWindow,ResourceID{"Synchronize",_GetInst()},iCtlID)

oDCIntroduction := FixedText{SELF,ResourceID{SYNCHRONIZE_INTRODUCTION,_GetInst()}}
oDCIntroduction:HyperLabel := HyperLabel{#Introduction,NULL_STRING,NULL_STRING,NULL_STRING}

oCCSync := PushButton{SELF,ResourceID{SYNCHRONIZE_SYNC,_GetInst()}}
oCCSync:HyperLabel := HyperLabel{#Sync,"Synchronize",NULL_STRING,NULL_STRING}
oCCSync:TooltipText := "Start synchronization"

SELF:Caption := "Synchronize Givers with persons of webbased Person Administration"
SELF:HyperLabel := HyperLabel{#Synchronize,"Synchronize Givers with persons of webbased Person Administration",NULL_STRING,NULL_STRING}
SELF:OwnerAlignment := OA_BOTTOM

if !IsNil(oServer)
	SELF:Use(oServer)
ENDIF

self:PostInit(oWindow,iCtlID,oServer,uExtra)

return self

method PostInit(oWindow,iCtlID,oServer,uExtra) class Synchronize
	//Put your PostInit additions here 
self:SetTexts()
	self:oDCIntroduction:TextValue:="1.Bij elke gever of bezoeker bijbehorende adresgegevens zoeken in de persoonsadministratie"+CRLF+; 
"	a.	Indien er meerdere gevonden worden moet de gebruiker aanwijzen wie het betreft."+CRLF+; 
"	b.	Indien persoon partner heeft, deze via persoonsid opzoeken."+CRLF+;
"	c.	In de database wordt tevens persoonsid (bij echtpaar van man) als externalid vastgelegd zodat volgende keer synchronisatie automatisch kan."+CRLF+; 
"	d.	Indien niemand is gevonden, dan wordt persoon op de lijst van niet gevonden personen gezet om eventueel te verwijderen."+CRLF+; 
"	e.	Indien adresgegeven al ingevuld was en dit wijkt af van de persoonsadministratie, dan worden deze ook op lijst van afwijkende adresgegevens gerapporteerd."+CRLF+;
"2.	Vervolgens worden alle andere adressen uit de persoonsadministratie die niet toegewezen zijn aan persoon binnen WOS toegevoegd en krijgen mailingcode Bezoeker."+CRLF+;
"3.	tenslote wordt iIedereen verwijderd die geen gever is maar wel mailing code bezoeker heeft en leeg externid"
  
	return NIL
method Sync() class Synchronize
	LOCAL cSep as STRING
	LOCAL cDelim:=CHR(9) as STRING
	LOCAL ptrHandle, ptrNonEx,ptrAdrCh 
	LOCAL cBuffer,cFileName,cFileNonEx,cFileAddrCh, cNameSearch, cWebPerson, cFirstNames, cGender, MlcdBezoeker,cIntl, CurAdr as STRING
	LOCAL aStruct:={},aImportFiles as ARRAY // array with fieldnames
	LOCAL aFields:={} as ARRAY // array with fieldvalues
	local i, MinL,CorID, nCurRec, nAant,WinPtr,PersPtr, GivPtr,Lnm,idPartner,nAdd as int
	LOCAL ptAchternaam, pttussenvoegsel, ptroepnaam, pttitel, ptStraatnaam, pthuisnummer, ptpostcode, ptwoonplaats,ptland, ptID, ptIDPartner,ptgeslacht as int
	local ptgeboortedatum,ptpersoon_op_adreslijst,ptemailadres,ptDatum_adreswijziging,ptvoornamen,ptpartnernaam,ptTelefoonnr,ptMobielTeln as int
	local hsnr as string, aCorPers:={}, aWOSPers:={} as array
	local oCorSelect as SelectCorrPerson 
	Local oParPers, oPers as SQLSelect
	local oPersChg as SQLSelect
	Local Merged, Skip as logic 
	Local aStr as Array 
	Local RemoveDat as date  
	local oSel as SQLSelect 
	local oPersTypo3 as SQLSelect
	local oStmnt as SQLStatement
	local cMailingcodes as string 
	local cNameSearch as string  
	local parsl as string
	If (i:=AScan( mail_abrv,{|x| x[1]="BZ"}))=0
		(ErrorBox{,"Mailcode bezoeker (BZ) is missing, add it first"}):show()
		return false
	else
		MlcdBezoeker:=mail_abrv[i,2]
	endif
	parsl := GetParAESKEY()
	RemoveDat:=SToD(Str(Year(Today())-1,4,0)+"0101")
	RemoveDat:=Min(MinDate,RemoveDat)
	cFileNonEx := CurPath + "\Gevers niet in persoonsadministratie"+StrZero(Day(Today()),2)+StrZero(Month(Today()),2)+SubStr(StrZero(Year(Today()),4),1,4)+'.xls'
	ptrNonEx := MakeFile(self,cFileNonEx,"Creating report file")
	IF ptrNonEx = F_ERROR .or. Empty(ptrNonEx)
		RETURN false
	ENDIF
	FWriteLine(ptrNonEx,"Persoon"+CHR(9)+"Datum laatset gift")
	cFileAddrCh:= CurPath + "\Adres anders in giften- dan in persoonsadministratie"+StrZero(Day(Today()),2)+StrZero(Month(Today()),2)+SubStr(StrZero(Year(Today()),4),1,4)+'.xls'
	ptrAdrCh := MakeFile(self,cFileAddrCh,"Creating report file")
	IF ptrAdrCh = F_ERROR .or. Empty(ptrAdrCh)
		RETURN false
	ENDIF
	FWriteLine(ptrAdrCh,"Persoonsadmin"+CHR(9)+"Giftenadmin")
	/*
	try to match each giver in WOS Person (datelastgift not empty) with corresponding person in Typo3 Persoon:
	1.	If more than 1 matches let the user point to the correct one 
	2.	In case of a couple lookup the corresponding parner via the id of the partner. 
	3.	Record in WOS the typo3 id of the matching person as extrenid (at a couple the husband one); next time synchronisation will run automatically 
	4.	If no person matches the WOS person can apparently be removed (if datelastgift in a closed year otherwise report this person) 
	5.	When address differs from matching person report about this difference.

	*/  

	oSel:=SqlSelect{"show databases like 'parousia_typo3'",oConn}
	oSel:Execute()
	if !Empty(oSel:Status).or. oSel:RecCount<1
		ErrorBox{self,"database parousia_typo3 not avialbale"}:show()
		return
	endif
	self:Pointer := Pointer{POINTERHOURGLASS}

	//  Read all givers and visitors from WOS:
	oPers:=SqlSelect{"select persid,lastname,initials,postalcode,city,date_format(datelastgift,'%e-%m-%Y') as datelastgift,"+ SQLFullNAC(3)+" as fullnac"+;
		",postalcode,address,externid,mailingcodes "+;
		"from person where datelastgift>'0000-00-00' or instr(mailingcodes,'"+MlcdBezoeker+"')>0 order by lastname",oConn}
	oPers:Execute() 
	// Place all wospersons into array aWosPers: 
	do while !oPers:Eof
		AAdd(aWOSPers,{oPers:FullNAc+" (laatste gift:"+oPers:datelastgift+")",oPers:persid}) 
		oPers:Skip()
	enddo 
	nAant:=Len(aWOSPers)

	//	Try to match each giver/visitor in WOS with corresponding person in Typo3 persoon:
	for PersPtr:=1 to nAant
		// map wos person (oPers) on typo3 person(oPersTypo3):
		Merged:=false
		CorID:=0   //id of corresponding typo3 person
		oPers:GoTo(PersPtr) 
		if !Empty(Val(oPers:externid))
			// this wos person already mapped on typo3 person (via extrenid)
			CorID:=Val(oPers:externid)
		else
			// Select all typo3 persons with corresponding address or name who have not yet been matched i.e. its id 
			// can't be found as externid within wos persons
			hsnr:=GetStreetHousnbr(oPers:address)[2] 
			cNameSearch:=SubStr(GetTokens(oPers:lastname)[1,1],1,10)

			oParPers:=SqlSelect{'select tp.id,tp.achternaam,tp.voornamen,tp.roepnaam,tp.tussenvoegsel,a.straatnaam,a.huisnummer,a.postcode,a.woonplaats'+;
				',concat(tpartner.roepnaam," ",tpartner.tussenvoegsel," ",tpartner.achternaam) as partnernaam'+;
				' from parousia_typo3.adres a,parousia_typo3.persoon tp'+;
				' left join parousia_typo3.persoon as tpartner on (tp.id_partner=tpartner.id and tpartner.verwijderd="nee")'+;
				' where AES_DECRYPT(tp.id_adres,"'+parsl+'" )=a.id'+;
				' and not exists (select 1 from '+dbname+'.person pw where  binary pw.externid = binary tp.id or binary pw.externid = binary tp.id_partner)'+;
				' and ('+iif(!Empty(oPers:postalcode) .and.!Empty(oPers:address),'a.postcode="'+oPers:postalcode+'" and a.huisnummer="'+hsnr+'" or ','')+;
				'tp.achternaam like "'+cNameSearch+'%")'+;
				' and tp.persoon_op_adreslijst="persoon op adreslijst"'+;
				' and (tp.geboortedatum="0000-00-00" or datediff(now(),tp.geboortedatum)> (15*365))'+;
				' and tp.verwijderd="nee" and a.verwijderd="nee"'+;
				' order by a.postcode,a.huisnummer,tp.burgerlijke_staat,tp.geslacht',oConn}
// 				'not exists (select 1 from '+dbname+'.person pw where binary pw.externid=binary tp.id) and ('+;
// 				'tp.achternaam regexp "'+oPers:lastname+'" or "'+oPers:lastname+'" regexp tp.achternaam)'+;

			if oParPers:RecCount>0     // at least one corresponding typo3 person found 
				aCorPers:={} 
				GivPtr:=0
				do	while	!oParPers:Eof
					cWebPerson:=oParPers:achternaam+', '+GetInitials(oParPers:voornamen)+', '+oParPers:roepnaam+') '+oParPers:tussenvoegsel+'; '+oParPers:straatnaam+;
						' '+oParPers:huisnummer+' '+oParPers:postcode+' '+oParPers:woonplaats+iif(Empty(oParPers:partnernaam),'',' (partner:'+oParPers:partnernaam+")")	
					AAdd(aCorPers,{ cWebPerson,oParPers:id})
					cIntl:=StrTran(oPers:initials," ","") 
					if	!Empty(cIntl) .and.cIntl=GetInitials(oParPers:voornamen)
						if	Empty(GivPtr) .or.(!Empty(oPers:Postalcode) .and. oParPers:postcode==oPers:Postalcode).or.;
								(!Empty(oPers:city) .and. Upper(oParPers:woonplaats)==AllTrim(oPers:city))
							GivPtr:=Len(aCorPers)
						endif
					elseif !Empty(oPers:postalcode) .and. oParPers:postcode==oPers:postalcode
						if	 Empty(GivPtr)	.or.!Empty(cIntl)	.and.cIntl=GetInitials(oParPers:voornamen)
							GivPtr:=Len(aCorPers)
						endif
					elseif !Empty(oPers:city) .and. Upper(oParPers:woonplaats)==oPers:city
						if	 Empty(GivPtr)
							GivPtr:=Len(aCorPers)
						endif
					endif
					oParPers:Skip()
				enddo
				// select required corresponding person: 
				oCorSelect:= SelectCorrPerson{self,,,aWOSPers}
				
				oCorSelect:AddWebPersons(aCorPers,GivPtr)
				oCorSelect:MoveGiverPtr(PersPtr)
				oCorSelect:show() 
				CorID:=oCorSelect:selCln 
				if CorID<0            // apparently stopped by the user
					FClose(ptrNonEx) 
					FClose(ptrAdrCh)
					//myApp:Quit() 
					return false
				endif
				self:Pointer := Pointer{POINTERHOURGLASS}
				if !Empty(CorID)     // a person selected by the user?
					// check if it has to be merged with a partner (in WOS all on one address as one person, in typo3 distinct persons)  
					idPartner:=ConI(SqlSelect{"select id_partner from  parousia_typo3.persoon where id="+Str(CorID,-1),oConn}:id_partner)
					if !Empty(idPartner)
						oPersChg:=SqlSelect{'select persid,mailingcodes,'+SQLFullName()+' as fullname from person where externid="'+Str(idPartner,-1)+'"',oConn}
						if oPersChg:RecCount>0 
							if (TextBox{self,"Synchronize Persons",'Do you want to merge '+oPers:FullNAc+CRLF+"with its partner "+oPersChg:FullName+"?",BOXICONQUESTIONMARK + BUTTONYESNO}):show()==BOXREPLYYES
								// Merge persons:
								PersonUnion(Str(oPersChg:persid,-1),Str(oPers:persid,-1))
								if At(MlcdBezoeker,cMailingcodes)=0  
									cMailingcodes:=oPersChg:mailingcodes
									ADDMLCodes(MlcdBezoeker,@cMailingcodes)
									SQLStatement{"update person set mailingcodes='"+cMailingcodes+"' where persid="+Str(oPersChg:persid,-1),oConn}:Execute()
								endif
								Merged:=true
							endif
						endif
					endif
				endif
			endif
		endif
		
		If !Merged  // if not merged, typo3 person has to be saved into WOS
			if !Empty(CorID)
				// update wos person data with corresponding typo3 data:
				oPers:GoTo(PersPtr)
				oPersTypo3:=SqlSelect{'SELECT '+;
				"tp.achternaam, tp.tussenvoegsel, tp.voornamen, tp.roepnaam, tp.titel"+;
				",cast(AES_DECRYPT(tp.mobieltelnr,'"+parsl+"') as char) as mobieltelnr"+;
				",cast(AES_DECRYPT(tp.emailadres,'"+parsl+"') as char) as emailadres"+;
				',tp.geslacht, cast(tp.geboortedatum as date) as geboortedatum'+;
				',concat(tpartner.roepnaam," ",tpartner.tussenvoegsel," ",tpartner.achternaam) as partnernaam'+;
				',straatnaam,huisnummer,postcode,woonplaats,land,cast(ta.datum_wijziging as date) as datum_adreswijziging'+;
				",cast(AES_DECRYPT(telefoonnr_vast,'"+parsl+"') as char) as telefoonnr_vast"+;
				',tp.id, tp.id_partner'+;
				',tpartner.roepnaam as partnerroepnaam'+;
				' FROM parousia_typo3.persoon as tp'+;
				' left join parousia_typo3.persoon as tpartner on tp.id_partner=tpartner.id,'+;
				+'parousia_typo3.adres as ta'+;
				' where tp.verwijderd="nee" and ta.verwijderd="nee" and AES_DECRYPT(tp.id_adres,"'+parsl+'")=ta.id and tp.id='+Str(CorID,-1),oConn}
				oPersTypo3:Execute()
				if oPersTypo3:RecCount>0
					cMailingcodes:= oPers:mailingcodes
					ADDMLCodes(MlcdBezoeker,@cMailingcodes)		
					oStmnt:=SQLStatement{"update person set birthdate='"+SQLdate(iif(Empty(oPersTypo3:geboortedatum),null_date,oPersTypo3:geboortedatum))+"'"+;
						",lastname='"+oPersTypo3:achternaam+"',prefix='"+oPersTypo3:tussenvoegsel+"'"+;
						",firstname='"+iif(Empty(oPersTypo3:id_partner),oPersTypo3:roepnaam,iif(oPersTypo3:geslacht=='man',oPersTypo3:roepnaam+" en "+Transform(oPersTypo3: partnerroepnaam,""),Transform(oPersTypo3:partnerroepnaam,"")+" en "+oPersTypo3:roepnaam))+"'"+;
						",gender="+iif(!Empty(oPersTypo3:id_partner),'3',iif(oPersTypo3:geslacht="vrouw",'1','2'))+",email='"+oPersTypo3:emailadres+"'"+;
						",externid='"+ iif(Empty(oPersTypo3:id_partner).or.oPersTypo3:geslacht="man",Str(oPersTypo3:id,-1),Str(oPersTypo3:id_partner,-1))+"'" +;
						iif(!Empty(oPersTypo3:titel).and. (i:=AScan( pers_titles,{|x|x[1]==Lower(oPersTypo3:titel)}))>0,",title='"+Str(pers_titles[i,2],-1)+"'","")+;
						",mobile='"+oPersTypo3:mobieltelnr+"',telhome='"+oPersTypo3:telefoonnr_vast+"'" +;
						iif(Empty(oPers:address) .or.Empty(oPers:postalcode) .or.oPersTypo3:datum_adreswijziging>CToD(oPers:datelastgift) .and.(Today()-CToD(oPers:datelastgift))< 365,;
						",address='"+oPersTypo3:straatnaam+" "+oPersTypo3:huisnummer+"',city='"+oPersTypo3:woonplaats+"',postalcode='"+oPersTypo3:postcode+"',country='"+oPersTypo3:land+"'","")+;
						",mailingcodes='"+cMailingcodes+"',externid='"+Str(CorID,-1)+"'"+;
						" where persid="+Str(oPers:persid,-1),oConn}
					oStmnt:Execute()
					// address:
					if !(Empty(oPers:address) .or.Empty(oPers:postalcode) .or.(oPersTypo3:datum_adreswijziging>CToD(oPers:datelastgift) .and.(Today()-CToD(oPers:datelastgift))< 365))
						if	!oPers:address == oPersTypo3:straatnaam+" "+oPersTypo3:huisnummer .or.!oPers:postalcode == oPersTypo3:postcode  
							//	if	different report:	
							cWebPerson:=oPersTypo3:achternaam+', '+GetInitials(oPersTypo3:voornamen)+" ("+oPersTypo3:roepnaam+') '+oPersTypo3:tussenvoegsel+'; '+oPersTypo3:straatnaam+;
								' '+oPersTypo3:huisnummer+' '+oPersTypo3:postcode+' '+oPersTypo3:woonplaats+iif(Empty(oPersTypo3:id_partner),"",' (partner: '+Transform(oPersTypo3:partnernaam,"")+")") 
							FWriteLine(ptrAdrCh,cWebPerson+CHR(9)+oPers:FullNAc)
						endif
					endi
				else
				endif
			else
				// person does not belong to church anymore
				if CToD(oPers:datelastgift) < RemoveDat
					// delete person:
					SQLStatement{"delete from person where persid="+Str(oPers:persid,-1),oConn}:Execute()
					FWriteLine(ptrNonEx,oPers:FullNAc+CHR(9)+oPers:datelastgift+" (verwijderd)")
				else
					FWriteLine(ptrNonEx,oPers:FullNAc+CHR(9)+oPers:datelastgift)
				endif
			endif
		endif		
	next
	FClose(ptrNonEx)
	FClose(ptrAdrCh) 
	/*
	4.	At last add all remaining persons from typo3 to WOS persons and give them code Visitor 
	*/
	self:STATUSMESSAGE("Adding all other addresses from person administration, please wait...")
	self:Pointer := Pointer{POINTERHOURGLASS}
	
	oParPers:=SqlSelect{'select p.id,p.id_partner,cast(p.geboortedatum as date) as geboortedatum,p.achternaam,p.tussenvoegsel,p.geslacht,p.roepnaam'+;
		", cast(AES_DECRYPT(p.emailadres,'"+parsl+"' ) as char) as emailadres"+;
		", cast(AES_DECRYPT(telefoonnr_vast,'"+parsl+"' ) as char) as telefoonnr_vast"+;
		", cast(AES_DECRYPT(p.mobieltelnr,'"+parsl+"' ) as char) as mobieltelnr"+;
		',p.voornamen,p.titel,straatnaam,huisnummer,postcode,woonplaats,land,tpartner.roepnaam as roepnaampartner '+;
		'from parousia_typo3.adres a, parousia_typo3.persoon p left join parousia_typo3.persoon tpartner on (tpartner.id=p.id_partner and tpartner.verwijderd="nee")'+;
		' where AES_DECRYPT(p.id_adres,"'+parsl+'" )=a.id '+;
		' and not exists (select 1 from '+dbname+'.person pw where  binary pw.externid = binary p.id or binary pw.externid = binary p.id_partner)'+;
		' and p.persoon_op_adreslijst="persoon op adreslijst"'+;
		' and (p.geboortedatum="0000-00-00" or datediff(now(),p.geboortedatum)> (15*365))'+;
		' and	p.verwijderd="nee" and a.verwijderd="nee" order by postcode,huisnummer,p.burgerlijke_staat,p.geslacht',oConn}
	oParPers:Execute()
	nAdd:=0	  
	do while !oParPers:Eof
		Skip:=false
		CurAdr:=oParPers:postcode+oParPers:huisnummer
		do while  !oParPers:Eof .and. CurAdr==oParPers:postcode+oParPers:huisnummer 
			if !Skip
				oStmnt:=SQLStatement{"insert into person set "+;                                                      
				"creationdate=now()"+;
					",opc='"+LOGON_EMP_ID+"'"+;
					",externid='"+Str(oParPers:id,-1)+"'"+;
					",birthdate='"+SQLdate(iif(Empty(oParPers:geboortedatum),null_date,oParPers:geboortedatum))+"'"+;
					",lastname='"+oParPers:achternaam+"'"+;
					",prefix='"+oParPers:tussenvoegsel+"'"+;
					",firstname='"+iif(Empty(oParPers:id_partner),oParPers:roepnaam,iif(oParPers:geslacht="man",oParPers:roepnaam +"&"+oParPers:roepnaampartner,;
					oParPers:roepnaampartner+"&"+oParPers:roepnaam))+"'"+;
					",gender='"+iif(!Empty(oParPers:id_partner),'3',iif(oParPers:geslacht="vrouw",'1','2'))+"'"+;
					",initials='"+GetInitials(oParPers:voornamen) +"'"+;
					",email='"+oParPers:emailadres+"'"+;
					",address='"+oParPers:straatnaam+" "+oParPers:huisnummer+"'"+;
					",city='"+oParPers:woonplaats+"'"+; 
				",postalcode='"+oParPers:postcode+"'"+;
					",country='"+oParPers:land+"'"+;		   	 
				",mailingcodes='"+MlcdBezoeker+"'"+;
					",mobile='"+oParPers:mobieltelnr+"'"+; 
				",telhome='"+ oParPers:telefoonnr_vast+"'"+;
					iif(!Empty(oParPers:titel).and. (i:=AScan( pers_titles,{|x|x[1]==Lower(oParPers:titel)}))>0,",title="+Str(pers_titles[i,2],-1),""),oConn}			
				oStmnt:Execute( )
				if oStmnt:NumSuccessfulRows>0 
					nAdd++
				endif
			endif
			Skip:=true
			oParPers:Skip()
		enddo
	enddo
	self:Pointer := Pointer{POINTERARROW}
	if nAdd>0
		(TextBox{self,"Synchronisation Parousia",Str(nAdd,-1)+' '+self:oLan:wget('persons added')}):show()
	endif	

	/*
	5.	Remove everyone with mailingcode bezoeker who is not a giver and has an empty externid
	*/ 
	self:STATUSMESSAGE(self:oLan:wget("Deleting all addresses who are no giver and not in person administration, please wait")+"...")
	self:Pointer := Pointer{POINTERHOURGLASS}

	oStmnt:=SQLStatement{"delete from person where mailingcodes like '%"+MlcdBezoeker+"%' and externid='' and datelastgift='0000-00-00'",oConn}
	oStmnt:Execute()
	if oStmnt:NumSuccessfulRows>0
		(TextBox{self,"Synchronisation Parousia",Str(oStmnt:NumSuccessfulRows,-1)+' '+self:oLan:wget('persons removed')}):show()
	endif	
	self:Pointer := Pointer{POINTERARROW}
	(TextBox{self,"Synchronisation Parousia Finished","See report files: "+CRLF+cFileNonEx+" and "+CRLF+cFileAddrCh}):show()
	self:EndWindow()
	return 
STATIC DEFINE SYNCHRONIZE_INTRODUCTION := 100 
STATIC DEFINE SYNCHRONIZE_SYNC := 101 
