FUNCTION AcceptNorway(oRep,nRow,nPage,oLan,fTotal,invoicenbr,oPers,Destination,INVOICEID)
// printing of acceptgiro part in Norwegian format:
LOCAL oReport:=oRep as PrintDialog
LOCAL cCodeline as STRING

Default(@Destination,null_string)
Default(@InvoiceID,null_string)
	DO WHILE nRow < 40
		oReport:PrintLine(@nRow,@nPage,' ')
	ENDDO
	oReport:PrintLine(@nRow,@nPage,Space(34)+Str(fTotal,8,DecAantal))
	oReport:PrintLine(@nRow,@nPage,' ')
	oReport:PrintLine(@nRow,@nPage," ")
	oReport:PrintLine(@nRow,@nPage,' ')
	oReport:PrintLine(@nRow,@nPage,Space(5)+oLan:get('Invoice number',,"!")+': '+invoicenbr)
	oReport:PrintLine(@nRow,@nPage,Space(5)+AllTrim(Destination))
	oReport:PrintLine(@nRow,@nPage,' ')
	oReport:PrintLine(@nRow,@nPage,' ')
	oReport:PrintLine(@nRow,@nPage,' ')
	oReport:PrintLine(@nRow,@nPage,' ')
	oReport:PrintLine(@nRow,@nPage,' ')
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad("Wycliffe",41)+ oPers:md_address1)
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad("POSTBOKS 6625 ST. OLAVS PLASS ",41)+ oPers:md_address2)
	oReport:PrintLine(@nRow,@nPage,Space(6)+Pad("0129 Oslo",41)+ oPers:md_address3)
	oReport:PrintLine(@nRow,@nPage,Space(47)+ oPers:md_address4)
	oReport:PrintLine(@nRow,@nPage,' ')
	oReport:PrintLine(@nRow,@nPage,' ')
	oReport:PrintLine(@nRow,@nPage,' ')
	oReport:PrintLine(@nRow,@nPage,' ')
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
	oReport:PrintLine(@nRow,@nPage,cCodeline)
		
	RETURN
function ADDMLCodes(NewCodes as string, cCod ref string) as void pascal
// add new mailing NewCodes to current string of mailing codes cCod
LOCAL aPCod,aNCod as ARRAY, iStart as int
if Empty(NewCodes)
	return
endif
	aPCod:=Split(AllTrim(cCod)," ")
	aNCod:=Split(AllTrim(NewCodes)," ")
	iStart:=Len(aPCod)
 
	ASize(aPCod,iStart+Len(aNCod))
	ACopy(aNCod,aPCod,1,Len(aNCod),iStart+1) 
	cCod:=MakeCod(aPCod)
	return
	
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
	self:oPrsBnk:=SQLSelect{"Select banknumber from PersonBank where persid=?",oConn}
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




Function ExtractPostCode(cCity:="" as string,cAddress:="" as string, cPostcode:="" as string) as array
LOCAL oHttp  as cHttp
LOCAL nStart, nPos, nEnd as int
local nPos1,nPos2, nPos3,i,j as int,straat,postcode, woonplaats,housenr,housenrOrg, order, output, bits, httpfile, cSearch as string, aorder:={},abits:={} as array
LOCAL aWord as ARRAY
// Default(@cPostcode,null_string)
// Default(@cCity,null_string)
if Empty(cAddress)
	return {cPostcode,cAddress,cCity}
endif
straat:=cAddress
postcode:=cPostcode
woonplaats:=cCity
housenrOrg:=(GetStreetHousnbr(cAddress))[2]

// remove housenbr addition from address:
aWord:=GetTokens(cAddress)
nEnd:=Len(aWord)
if nEnd>1
	if Empty(aWord[nEnd-1,1])  // separation character?
		nEnd-=2
//	elseif Len(aWord[nEnd,1])=1 .or.aWord[nEnd,2]="-" .or.aWord[nEnd,2]="/"
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
if !Empty(cPostcode) 
	cSearch:="address="+cPostcode+"+"+housenr
elseif !Empty(cCity)
	aWord:=GetTokens(cCity)
	cSearch:="address="+aWord[1,1]+"%2C+"+StrTran(cAddress," ","+")
endif
oHttp := CHttp{"WycOffSy HTP Agent",80,true}
//oHttp:ConnectRemote("http://www.postcode.nl")
httpfile:= oHttp:GetDocumentByURL("http://www.postcode.nl/index?action=search&goto=postcoderesult&"+cSearch)

nPos1:=At("Deze pagina heeft javascript nodig om te functioneren",httpfile)
if nPos1>0
	nPos1:=At3("var order = new Array(",httpfile,nPos1)+22
endif
if nPos1<=22
	// without scrambling:
	nPos1:=At("<p> Uw zoekactie naar <strong>'",httpfile)
	if nPos1>0
		httpfile:=SubStr(httpfile,nPos1)
		aorder:={"0"}
		nPos2:=At3("<ul>",httpfile,10)+5
		if nPos2>0
			httpfile:=SubStr(httpfile,1,nPos2)
		endif
		abits:={httpfile}
	endif
else
	httpfile:=SubStr(httpfile,nPos1)
	nPos2:=At(");",httpfile)
	order := SubStr(httpfile,1,nPos2-1)
	aorder:=Split(order,",")
	httpfile:=SubStr(httpfile,nPos2+22)
	nPos3:=At(");",httpfile)
	bits:=SubStr(httpfile,3,nPos3-3) 
	bits:=StrTran(StrTran(bits,"',"+'"',"','"),'",'+"'","','") 
	nStart:=1
	nEnd:=Len(bits)-1
	DO WHILE true
		nPos:=At3("','", bits,nStart)
		IF nPos==0
			exit
		ENDIF
		AAdd(abits,SubStr(bits,nStart+1,nPos-nStart-1))
		nStart:=nPos+2
	ENDDO
	AAdd(abits,SubStr(bits,nStart+1,nEnd-nStart))
endif
if !Empty(abits)
	output:=""
	for i:=1 to Len(aorder) 
		j:=Val(aorder[i])+1
		if j<=Len(abits)
			output+=abits[j]
			if At("<ul>",output)>0
				exit
			endif
		endif
	next
endif
output:=StrTran(StrTran(StrTran(StrTran(StrTran(output,"''",""),'""',""),"'"+'"',""),'"'+"'",""),'\',"") 
if !Empty(output)
//	nPos1:=At('</thead> <tbody> <tr class="even"> <td>',output)+39
	nPos1:=At('<td>',output)+4
	if (nPos1>4)
		nPos2:=At3(" </td> ",output,nPos1)
		postcode:=AllTrim(SubStr(output,nPos1,nPos2-nPos1))
		nPos1:=nPos2+11
		nPos2:=At3(" </td> ",output,nPos1+3)
		straat:=AllTrim(AllTrim(SubStr(output,nPos1,nPos2-nPos1))+" "+housenrOrg) 
		nPos1:=At3(" <td> ",output,nPos2+11)+5
		if (nPos1>5)
			nPos2:=At3("</td>",output,nPos1)
			woonplaats:=AllTrim(SubStr(output,nPos1,nPos2-nPos1))
			if (woonplaats=="'S-GRAVENHAGE")
				woonplaats:='DEN HAAG'
			elseif (woonplaats=="'S-HERTOGENBOSCH")
				woonplaats:="DEN BOSCH"
			endif
			woonplaats:=Upper(SubStr(woonplaats,1,1))+Lower(SubStr(woonplaats,2))				
		endif
	else
// 		LogEvent(,"Geen postcode gevonden voor:"+cAddress+" "+cPostcode+" "+cCity+", user:"+LOGON_EMP_ID+CRLF+httpfile, "LogErrors")
	endif	
else
// 	LogEvent(,"Geen postcode gevonden voor:"+cAddress+" "+cPostcode+" "+cCity+", user:"+LOGON_EMP_ID+CRLF+httpfile, "LogErrors")
endif
oHttp:CloseRemote()
oHttp:Axit() 
RETURN {postcode,straat,woonplaats}
function GENDERDSCR(cGnd as int) as string
	// Return Gender description of a person:
	RETURN pers_gender[AScan(pers_gender,{|x|x[2]==cGnd}),1]

function GetBankAccnts(mPersid as string) as array 
local aBankAcc:={} as array
local oSel as SQLSelect 
	* Fill aBankAcc: 
oSel:=SQLSelect{"select group_concat(banknumber separator ',') as bankaccs from PersonBank where persid="+mPersid+" group by persid" ,oConn}
if oSel:RecCount>0
	return Split(oSel:bankaccs,',')
else
	return {}
endif
Function GetFullName(PersNbr:="" as string ,Purpose:=0 as int) as string 
// composition of full name of a person
// PersNbr: Optional ID of person 
// Purpose: optional indicator that the name is used for:
// 	0: addresslist: with surname "," firstname prefix (without salutation) 
//		1: fullname conform address specification
//		2: name for identification: lastname, firstname prefix 
//		3: like 1 but always with firstname 
LOCAL frstnm,naam1, Title,prefix as STRING
local oPers as SQLSelect
oPers:=SQLSelect{"select lastname,prefix,title,firstname,initials,gender from person where persid="+PersNbr,oConn}

IF !IsNil(PersNbr) .and.!oPers:RecCount==1
	RETURN ""
ENDIF
IF sSalutation .and.(Purpose==1.or.Purpose==3) 
	Title := Salutation(oPers:GENDER)
	IF !Empty(Title)
		Title+=" "
	ENDIF
ENDIF
IF TITELINADR.and.!Empty(Title(oPers:Title)) .and.(Purpose==1.or.Purpose==3) 
	Title += Title(oPers:Title)+' '
ENDIF
IF .not. Empty(oPers:FIELDGET(#prefix))
   prefix :=AllTrim(oPers:FIELDGET(#prefix)) +" "
ENDIF
IF .not. Empty(oPers:FIELDGET(#lastname))
   naam1 := AllTrim(oPers:FIELDGET(#lastname))+" "
ENDIF
IF sFirstNmInAdr .or. (Purpose==2.or.Purpose==3)
	IF !Empty(oPers:FIELDGET(#firstname) )
		frstnm += AllTrim(oPers:FIELDGET(#firstname))+' '
	ELSEIF .not. Empty(oPers:FIELDGET(#initials))  && use otherwise initials
		frstnm += AllTrim(oPers:FIELDGET(#initials))+' '
	ENDIF
ELSEIF .not. Empty(oPers:FIELDGET(#initials))  && use otherwise initials
	frstnm += AllTrim(oPers:FIELDGET(#initials))+' '
ENDIF
do CASE
CASE Purpose==0
	//addresslist:
	naam1:=AllTrim(naam1)+iif(!sSurnameFirst.and.!(Empty(frstnm).and.Empty(prefix)),", "," ")+frstnm+prefix
CASE Purpose==1.or.Purpose==3
	// address conform address specifications:
	IF sSurnameFirst
   	naam1 := naam1+Title+frstnm + prefix
	else
		naam1:=Title+frstnm+prefix+naam1
	ENDIF	
CASE Purpose==2
	// identification:
	naam1:=AllTrim(naam1)+iif(!sSurnameFirst.and.!(Empty(frstnm).and.Empty(prefix)),", "," ")+frstnm+prefix
endcase
return (AllTrim(naam1))
Function GetFullNAW(PersNbr as string,country:="" as string,Purpose:=1 as int) as string 
* Compose name and address
* country: default country (optional)
LOCAL f_row:="" as STRING
local oPers as SQLSelect

IF Empty(PersNbr) 
	return null_string
ENDIF
f_row:=GetFullName(PersNbr,Purpose)
oPers:=SQLSelect{"select address,postalcode,city,country from person where persid="+PersNbr,oConn} 
if oPers:RecCount<1
	return null_string
endif

f_row:=f_row+', '
IF .not.Empty(oPers:address)
   f_row+=AllTrim(oPers:address)+" "
ENDIF
IF .not.Empty(oPers:postalcode)
   f_row+=Trim(oPers:postalcode)+" "
ENDIF
IF .not.Empty(oPers:city)
   f_row+=Trim(oPers:city)+" "
ENDIF
IF .not.Empty(oPers:country) 
   f_row+=Trim(oPers:country) 
ELSEIF .not.Empty(country)
   f_row+=country
ENDIF
RETURN AllTrim(f_row)
Function GetStreetHousnbr(Address as string) as array
	* return array {streetname, housnbr} from input Address
	LOCAL aWord as ARRAY
	LOCAL l,j as int
	LOCAL nEnd, nNumPosition as int
	LOCAL StreetName:=null_string, Housenbr:=" " as STRING

	IF !Empty(Address)
		aWord:=GetTokens(Address)
		nEnd := Len(aWord)
		if nEnd==1 .and. IsDigit(aWord[1,1])
			return {"",aWord[1,1]}
		endif
		* Search streetname:
		* Search backwards till housenbr:
		FOR l:=nEnd to 1 step -1
			//		IF IsDigit(aWord[l,1]).and.l>1
			IF IsDigit(aWord[l,1])
				* Housenbr found:
				nNumPosition:=l
				IF l > 1
					* two numbers?
					IF IsDigit(aWord[l-1,1])
						nNumPosition:=l - 1
					ELSEIF l>3 .and.Len(aWord[l-1,1])< 4 .and.IsDigit(aWord[l-2,1])
						* number, short alpha, number?			
						nNumPosition:=l - 2
					ENDIF
				ENDIF
				if nNumPosition=1
					// number at begin
					Housenbr := aWord[1,1] + aWord[1,2]
					FOR j=2 to nEnd
						StreetName:=StreetName+aWord[j,1]+aWord[j,2]
					NEXT
				else
					FOR j=1 to nNumPosition-1
						StreetName:=StreetName+aWord[j,1]+aWord[j,2]
					NEXT
					FOR j = nNumPosition to nEnd
						Housenbr := Housenbr +aWord[j,1] + aWord[j,2]
					NEXT 
				endif
				IF Len(AllTrim(Housenbr)) > 9
					* Large deviation: all in streetname:
					StreetName := Address
					Housenbr := ""
				ENDIF
				exit
			ENDIF
		NEXT
		IF Empty(nNumPosition) // no house# found?
			StreetName:= Address
		ENDIF
	ENDIF
	RETURN {AllTrim(StreetName), AllTrim(Housenbr)}
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


FUNCTION MakeAbrvCod(cCodes as STRING)
* Translates string with mailing code abbravations (separated by space)  to array of mailing code identifiers
LOCAL aAbCodes as ARRAY
LOCAL i,j as int
LOCAL aCode:={} as ARRAY
aAbCodes:=Split(Upper(Compress(cCodes))," ")
FOR i=1 to Len(aAbCodes)
	if (j:=AScan(mail_abrv,{|x|x[1]== aAbCodes[i]}))>0
		AAdd(aCode,mail_abrv[j,2])
	ENDIF
NEXT
RETURN aCode
FUNCTION MakeCod(mCodes as ARRAY)
	* Compose mailingcodes from array with fields mCod1 .. mCodn
	LOCAL aCode := {}
	LOCAL i as int
	LOCAL cCod := "" as STRING
	
	FOR i = 1 to Len(mCodes)
		IF !IsNil(mCodes[i])
			IF Len(AllTrim(mCodes[i]))=2
				IF AScan(aCode,mCodes[i])=0
					AAdd(aCode,mCodes[i])
				ENDIF
			ENDIF
		ENDIF
	NEXT
	return Implode(aCode," ")
FUNCTION MakeCodes(Codes as ARRAY)
* Compose clean array from array with code-objects
	LOCAL aCod as ARRAY
	LOCAL i as int
	aCod := {}
	FOR i = 1 to Len(Codes)
		IF !Empty(Codes[i])
			IF AScan(aCod,Codes[i])=0
				AAdd(aCod,Trim(Codes[i]))
			ENDIF
		ENDIF
	NEXT
RETURN aCod
FUNCTION MarkUpAddress(oPers as SQLSelectPerson,p_recnr:=0 as int,p_width:=0 as int,p_lines:=0 as int) as array
******************************************************************************
*  Name      : MarkUpAddress
*              Composition of full name and address of a person
*  Author    : K. Kuijpers
*  Date      : 01-01-1991
******************************************************************************

************** PARAMETERS and DECLARATION OF VARIABELES ***********************
* p_recnr    : recordnumber recipient in Person; default current
*              person-record
* p_width    : width address lines, default as long as needed for the data
* p_lines	 : required number of lines, default 6
* Global variable sFirstNmInAdr, determined in system parameters:
*            : .t.=use first name within address lines
*              .f.=use initials in address lines (default)
* Global variable sSalutation, specified in systemparams:
*            : .t.=show salutation in Address (default)
*              .f.=no salutation in address 
* Global variable sSTRZIPCITY, specified in system params:
*				0: address, zip, city, country  
*				1: postalcode,city, address, country 
*				2: country, postalcode city, address, 
*				3: address, city, zip, country
* Global CITYUPC: true: City name in uppercase, false± only first character uppercase 
* Global LSTNUPC: true: last name in uppercase, false± only first character uppercase 
* Returns: ARRAY met adressen + IN nederland 1 extra row met Kixkode
LOCAL arraynr:=0 as int,naam1:='',titel:='',naam2:='', lstnm as STRING
LOCAL i,j,aant as int
LOCAL m_AdressLines := {} as ARRAY
LOCAL stoppen := true
LOCAL regel as STRING
LOCAL cKixcd := "" as STRING
LOCAL cHuisnr:="",cToev as STRING
LOCAL nToevPos as int
LOCAL cCity as STRING
LOCAL frstnm as STRING 
// Local oPers:= oMyPers as SQLSelectPerson
local nSTRZIPCITY:=sSTRZIPCITY as int
local cAD1 as string, nLFPos as int, aAd1, aAd2 as array 
IF .not.Empty(p_recnr)
	oPers:Goto(p_recnr)
ENDIF
IF oPers:EOF
	RETURN nil
ENDIF
IF Empty(p_width)
	p_width := 99
ENDIF
IF Empty(p_lines)
	p_lines := 6
ENDIF
arraynr :=  p_lines + if(CountryCode="31",1,0)
ASize(m_AdressLines, arraynr)
AFill(m_AdressLines," ")
if .not. Empty(oPers:country)
	IF Upper(oPers:country)="USA" .or.Upper(oPers:country)="UNITED STATES".or.Upper(oPers:country)="CANADA".or.Upper(oPers:country)="U.S.A."
		nSTRZIPCITY:=3
	ELSEIF Upper(oPers:country)="RUSSIA"
		nSTRZIPCITY:=2
	ENDIF
endif
/* Filling address lines in following sequence:
1: Kixkode in extra line (for dutch addresses)
2: Country in last line (optional)
3: Zip code and City in previous line
4: Street and housenbr in previous lines
5: Attention in previous line
6: Last name and name extenion in first lines
*/
* Determine Kix Barkode:
IF CountryCode="31"
	IF Empty(oPers:country) .or. Upper(oPers:country) == "NEDERLAND"
		* Determine housenbr:
		nLFPos:=At(CRLF,oPers:address)
		if nLFPos>0
			cAD1:=AllTrim(SubStr(oPers:address,1,nLFPos-1))
		else
			cAD1:=AllTrim(oPers:address)
		endif
		FOR i = Len(cAD1) to 2 step -1
			IF IsDigit(psz(_cast,SubStr(cAD1,i,1)))
				IF Empty(cHuisnr)
					nToevPos := i+1
				ENDIF
				cHuisnr := SubStr(cAD1,i,1)+cHuisnr
			ELSE
				IF !Empty(cHuisnr)
					exit
				ENDIF
			ENDIF
		NEXT
		IF nToevPos >0 .and. nToevPos <= Len(cAD1)
			cToev := SubStr(cAD1,nToevPos,6)
		ENDIF
		cKixcd := oPers:postalcode+ cHuisnr+if(!Empty(cToev),"X"+cToev,"")
	ENDIF
	m_AdressLines[arraynr] := cKixcd
	--arraynr
ENDIF
IF .not. Empty(oPers:country).and. nSTRZIPCITY#2 .and.arraynr>0
	IF AScan(OwnCountryNames,{|x| Upper(AllTrim(x))=Upper(AllTrim(oPers:country))})=0
		m_AdressLines[arraynr] := SubStr(AllTrim(oPers:country),1,p_width)
	   --arraynr
	ENDIF
ENDIF
cCity := AllTrim(oPers:city)
if CITYUPC
	cCity:=Upper(cCity)
endif
IF nSTRZIPCITY==3
	cCity:= AllTrim(cCity+ " "+AllTrim(oPers:postalcode))
ELSE
	cCity := AllTrim(AllTrim(oPers:postalcode)+' '+cCity)
ENDIF

IF .not. Empty(cCity).and. nSTRZIPCITY#2.and.nSTRZIPCITY#1 .and.arraynr>0
   m_AdressLines[arraynr] := SubStr(AllTrim(cCity),1,p_width)
   --arraynr
ENDIF
aAd2:={}
IF .not. Empty(oPers:address) .and.arraynr>1
	// fill intermediate array aAd2
	aAd1:=Split(oPers:address,CRLF)
	For j:=1 to Len(aAd1)
   	FOR i=1 to MLCount(aAd1[j],p_width)
			regel	:=	MemoLine(aAd1[j],p_width,i)
			IF	Empty(regel) 
				loop
			ENDIF
			AAdd(aAd2,regel)
   	Next
	NEXT
	if Len(aAd2) >= arraynr.and. arraynr>1
		ASize(aAd2,arraynr-1)
	endif
	for i:=Len(aAd2) to 1 step -1
		m_AdressLines[arraynr] := AllTrim(aAd2[i])
		--arraynr
	next
ENDIF
IF  (nSTRZIPCITY==2 .or. nSTRZIPCITY==1) .and.!Empty(cCity) .and.arraynr>0
   m_AdressLines[arraynr] := SubStr(AllTrim(cCity),1,p_width)
   --arraynr
ENDIF
IF .not. Empty(oPers:country).and. nSTRZIPCITY==2 .and.arraynr>0
	IF AScan(OwnCountryNames,{|x| Upper(AllTrim(x))=Upper(AllTrim(oPers:country))})=0
		m_AdressLines[arraynr] := SubStr(AllTrim(oPers:country),1,p_width)
	   --arraynr
	ENDIF
ENDIF


IF .not. Empty(oPers:attention).and. arraynr >0
	m_AdressLines[arraynr] := AllTrim(oPers:attention)
   --arraynr
ENDIF
IF arraynr > 0
	aant := arraynr
	IF sSalutation
		titel := AllTrim(oPers:Salutation)
	ENDIF
	IF.not.Empty(titel)
	   titel := titel+' '
	ENDIF
	IF TITELINADR .and.!Empty( oPers:Title )
		titel += AllTrim(oPers:Title)+' '
	ENDIF
	IF .not. Empty(oPers:prefix)
	   naam1 += AllTrim(oPers:prefix)+' '
	ENDIF
	IF .not. Empty(oPers:lastname)
		lstnm:=AllTrim(oPers:lastname)
		if LSTNUPC
			lstnm:=Upper(lstnm)
// 		else
// 			lstnm:=Upper(SubStr(lstnm,1,1))+Lower(SubStr(lstnm,2))
		endif
	   naam1 += lstnm+' '
	ENDIF

	IF sFirstNmInAdr
		IF !Empty(oPers:firstname)
  			frstnm += AllTrim(oPers:firstname)+' '
		ELSEIF .not. Empty(oPers:initials)  && anders voorletters gebruiken
  			frstnm += AllTrim(oPers:initials)+' '
		ENDIF
	ELSEIF .not. Empty(oPers:initials)  && anders voorletters gebruiken
  		frstnm += AllTrim(oPers:initials)+' '
	ENDIF		
	IF sSurnameFirst
    	naam1 += frstnm
    ELSE
    	naam1 := frstnm+naam1
    ENDIF
	naam2 := AllTrim(oPers:nameext)
	IF .not.Empty(titel)
	   IF Len(titel)+Len(naam1)+Len(naam2) > p_width
    	  IF aant == 1.or.p_width<25
	      *  Bij weinig ruimte titel verkorten:
    	     titel := AllTrim(SubStr(titel,1,4))+' '
	      ENDIF
	   ENDIF
	ENDIF
	naam1 := titel+naam1
	IF aant == 1
	   * Nog maar 1 regel beschikbaar: samenvoegen en afkappen:
	   naam1 := SubStr(AllTrim(naam1)+' '+naam2,1,p_width)
	   naam2 := ''
	ELSE  && meer regels:
	   IF Len(naam2)>p_width.or.Len(naam1)>p_width
    	  * problemen met breedte, ook samenvoegen:
	      naam1 := naam1+if(Empty(naam2),'',' '+naam2)
    	  naam2 := ''
	   ENDIF
	ENDIF
*	arraynr := 0  && naam aan het begin
	stoppen := FALSE
	IF MLCount(naam1,p_width) < aant .and. !Empty(naam2)
		 m_AdressLines[arraynr] := AllTrim(naam2)
		 --arraynr
	ENDIF
	FOR i=Min(aant,MLCount(naam1,p_width)) to 1 step -1
	   regel := MemoLine(naam1,p_width,i) && verdelen over meerdere regels
    	m_AdressLines[arraynr] := AllTrim(regel)
    	--arraynr
	NEXT
ENDIF
RETURN m_AdressLines
Function MergeMLCodes(CurCodes as string,NewCodes as string) as string
	LOCAL aPCod,aNCod as ARRAY, iStart as int
	if Empty(NewCodes)
		return CurCodes
	endif
	aPCod:=Split(AllTrim(CurCodes)," ")
	aNCod:=Split(AllTrim(NewCodes)," ")
	iStart:=Len(aPCod)
	
	ASize(aPCod,iStart+Len(aNCod))
	ACopy(aNCod,aPCod,1,Len(aNCod),iStart+1) 
	return MakeCod(aPCod)	
METHOD Close( oEvent ) CLASS NewPersonWindow
/*	IF self:lImport
		self:oImport:Close()
	ENDIF  */

SELF:Destroy()
	// force garbage collection
	*CollectForced()

	RETURN SUPER:Close(oEvent)
	method FillBankNbr(cBankNbr,cDescr,i) class NewPersonWindow 
	if AScan(aBankAcc,{|x|x[2]==cBankNbr})==0  // not yest stored?
		IF Empty(self:oDCmbankNumber:VALUE)
			self:oDCmbankNumber:Value:=cBankNbr
			self:oDCSC_BankNumber:TextValue:=cDescr+Str(1,1)
			ASize(aBankAcc,Len(aBankAcc)+1)
			AIns(aBankAcc,1)
			aBankAcc[1]:={cDescr+Str(1,-1)+": "+AllTrim(cBankNbr),cBankNbr}
			ASize(OrigaBank,Len(OrigaBank)+1)
			AIns(OrigaBank,1)
			OrigaBank[1]:=cBankNbr
			i--
		ELSE
			AAdd(aBankAcc,{cDescr+Str(i+1,-1)+": "+AllTrim(cBankNbr),cBankNbr})
			AAdd(OrigaBank,cBankNbr)
		endif
	ENDIF
	return i
	
METHOD Import(apMapping,Checked)  CLASS NewPersonWindow
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
	
METHOD InitExtraProperties() CLASS NewPersonWindow
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
METHOD MatchImport(synctype) CLASS NewPersonWindow
	* Import of a person from import file with match existing person in database
	* synctype:
	* 	1=replace current values with values from import
	*	2=keep current values
	*
	LOCAL oPers:=SELF:Server AS Person
	LOCAL searchname, cSur, cA1, cPA,cVA,cVP as STRING
	LOCAL LencPA AS INT
	LOCAL ntus as int
	LOCAL first, lUnique, lDupl as LOGIC
	LOCAL stRec AS DWORD
	LOCAL aCodsBrev:={}, aMailCodes:={} AS ARRAY
	LOCAL oMail AS Perscod
	
	oMail:=Perscod{}
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

METHOD SetPropExtra( Count, Left) CLASS NewPersonWindow
LOCAL oSingle AS SingleLineEdit
LOCAL oCheck AS CheckBox
LOCAL oDropDown AS COMBOBOX
LOCAL oFix AS FixedText
LOCAL Name AS STRING,Type, ID AS INT, Values AS STRING
LOCAL myDim AS Dimension
LOCAL myOrg AS Point
LOCAL aValues AS ARRAY
LOCAL EditX:=152, FixX:=17 AS INT
Default(@Left,TRUE)
Name:=pers_propextra[Count,1]
Type:=pers_propextra[Count,3]
Values:=pers_propextra[Count,4]
ID := pers_propextra[Count,2]
IF Left
	//
	// enlarge window
	myDim:=SELF:Size
	myDim:Height+=25
	SELF:Size:=myDim
	myOrg:=SELF:Origin
	myOrg:y-=25
	SELF:Origin:=myOrg
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
	myOrg:=SELF:oDCmOPC:Origin
	myOrg:y-=25
	SELF:oDCmOPC:Origin:=myOrg
	myOrg:=self:oDCmPersId:Origin
	myOrg:y-=25
	self:oDCmPersId:Origin:=myOrg
	myOrg:=self:oDCmExternId:Origin
	myOrg:y-=25
	self:oDCmExternId:Origin:=myOrg
	myOrg:=self:oDCGroupBoxSystem:Origin
	myOrg:y-=25
	SELF:oDCGroupBoxSystem:Origin:=myOrg
	myOrg:=SELF:oDCSC_BDAT:Origin
	myOrg:y-=25
	SELF:oDCSC_BDAT:Origin:=myOrg
	myOrg:=SELF:oDCSC_MUTD:Origin
	myOrg:y-=25
	SELF:oDCSC_MUTD:Origin:=myOrg
	myOrg:=SELF:oDCSC_DLG:Origin
	myOrg:y-=25
	SELF:oDCSC_DLG:Origin:=myOrg
	myOrg:=SELF:oDCSC_OPC:Origin
	myOrg:y-=25
	SELF:oDCSC_OPC:Origin:=myOrg
	myOrg:=SELF:oDCSC_CLN:Origin
	myOrg:y-=25
	SELF:oDCSC_CLN:Origin:=myOrg
	myOrg:=self:oDCSC_Externid:Origin
	myOrg:y-=25
	self:oDCSC_Externid:Origin:=myOrg
	// enlarge personal group:
	myDim:=SELF:oDCGroupBoxPersonal:Size
	myDim:Height+=25
	SELF:oDCGroupBoxPersonal:Size:=myDim
	myOrg:=SELF:oDCGroupBoxPersonal:Origin
	myOrg:y-=25
	SELF:oDCGroupBoxPersonal:Origin:=myOrg
ELSE
	EditX:=511
	FixX:=376
	myOrg:=SELF:oDCGroupBoxPersonal:Origin
ENDIF
	//
//	insert extra properties in group personal:
	IF Type==TEXTBX
		oSingle:=SingleLineEdit{self,Count,Point{EditX,myOrg:y+13},Dimension{215,20} }
		oSingle:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name+":"}
		oSingle:FocusSelect := FSEL_HOME
		oSingle:Show()
		AAdd(aPropEx,oSingle)
	ELSEIF Type==CHECKBX
//		oCheck:=CheckBox{SELF,Count,Point{99,88},Dimension{215,20},Name}
		oCheck:=CheckBox{SELF,Count,Point{EditX,myOrg:Y+13},Dimension{215,20},Name}
		oCheck:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name,Name}
		AAdd(aPropEx,oCheck)
		oCheck:Show()
	ELSEIF Type==DROPDOWN
//		oDropDown:=Combobox{SELF,Count,Point{99,28},Dimension{215,80},BOXDROPDOWNLIST,CBS_SORT+CBS_LOWERCASE}
		oDropDown:=Combobox{SELF,Count,Point{EditX,myOrg:Y-47},Dimension{215,80},BOXDROPDOWNLIST,CBS_SORT+CBS_LOWERCASE}
		oDropDown:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name,NULL_STRING,NULL_STRING}
		aValues:=Split(Values,",")
		oDropDown:FillUsing(aValues)
		AAdd(aPropEx,oDropDown)
		oDropDown:Show()
	ENDIF
	IF Type#CHECKBX
//		oFix:=FixedText{SELF,Count,Point{17,88}, Dimension{82,20},Name+":"}
		oFix:=FixedText{SELF,Count,Point{FixX,myOrg:Y+13}, Dimension{135,20},Name+":"}
		oFix:Show()
	ENDIF
RETURN NIL
METHOD SetState() CLASS NewPersonWindow
	LOCAL i:=1,j, pos as int
	LOCAL oPersBank as SQLSelect
	// 	LOCAL oMbr AS Members
	LOCAL oXMLDoc AS XMLDocument
	LOCAL cDescr:="Bank# " as STRING
	local aBank:={} as array
// 	self:oPerson:=SQLSelect{"select p.*,a.accid,group_concat(b.banknumber separator ',') as bankaccounts from person as p left join member m on (m.persid=p.persid) left join account a on (a.accid=m.accid) left join personbank b on (p.persid=b.persid) where p.persid='"+Str(self:mPersid,-1)+"' group by p.persid",oConn}
	self:oPerson:=SQLSelect{"select p.*,m.accid,group_concat(b.banknumber separator ',') as bankaccounts from person as p "+;
	"left join member m on (m.persid=p.persid) left join personbank b on (p.persid=b.persid) "+;
	"where "+iif(!Empty(self:mPersid),"p.persid="+Str(self:mPersid,-1),"p.externid='"+self:mExternid+"'")+" group by p.persid",oConn}
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
	self:oDCmPersId:Value  := self:oPerson:persid
	self:mCodInt   := AllTrim(string(_cast,self:oPerson:mailingcodes))
	self:oDCmbankNumber:Value := ""
	self:oDCmEmail:Value := self:oPerson:Email
	self:oDCmRemarks:Value := self:oPerson:remarks
	self:oDCmAlterDate:Value := self:oPerson:alterdate
	self:oDCmCreationDate:Value := self:oPerson:creationdate
	self:oDCmOPC:Value := self:oPerson:OPC
	self:oDCmDateLastGift:Value := self:oPerson:datelastgift
	self:oDCmExternid:Value:= ZeroTrim(self:oPerson:EXTERNID)
	self:ODCmBirthDate:Value:=self:oPerson:birthdate
	self:oDCmGender:Value:=self:oPerson:GENDER 
	// Fill extra properties: 
	oXMLDoc:=XMLDocument{self:oPerson:PROPEXTR}
	FOR i:=1 to Len(self:aPropEx) 
		IF oXMLDoc:GetElement(aPropEx[i]:Name)
			aPropEx[i]:Value:=oXMLDoc:GetContentCurrentElement()
		ENDIF
	NEXT
	IF Empty(self:oPerson:accid)      // no member
		// remove mbr and ent from listbox:
		pos:=self:oDCmType:FindItem("Member",true)
		IF pos>0
			self:oDCmType:CurrentItemNo:=pos
			self:oDCmType:DeleteItem()
		ENDIF
		pos:=self:oDCmType:FindItem("Wycliffe Entity",true)
		IF pos>0
			self:oDCmType:CurrentItemNo:=pos
			self:oDCmType:DeleteItem()
		ENDIF
	else
		self:oDCmType:Disable()
	ENDIF	
	self:oDCmType:Value:=self:oPerson:TYPE
	IF self:lAddressChanged
		IF !Empty(self:oPersCnt:m51_pos)
			self:mPos := StandardZip(self:oPersCnt:m51_pos)
		ENDIF
		IF !Empty(self:oPersCnt:m51_ad1)
			self:mAddress := self:oPersCnt:m51_ad1
		ENDIF
		IF !Empty(self:oPersCnt:m51_city)
			self:mpla := self:oPersCnt:m51_city
		ENDIF
	ENDIF

	* Fill aBankAcc:
	IF	CountryCode=="47"
		cDescr:="Bank/KID	"
	ENDIF
	if !Empty(self:oPerson:bankaccounts)
		aBank:=Split(self:oPerson:bankaccounts,",")
		i:=1

		for j:=1	to	Len(aBank) 
			i:= self:FillBankNbr(aBank[j],cDescr,i)
		NEXT
	endif
	self:Curlastname:=self:mLastName
	self:curNa2:=self:mInitials
	self:curHisn:=self:mPrefix

	SELF:StateExtra()
	
	RETURN nil
METHOD StateExtra()CLASS NewPersonWindow
	LOCAL i,j:=0 AS INT
	LOCAL mCodH as USUAL, aCod as array
// 	LOCAL oPers AS Person
	LOCAL cDescr:="Bank# " AS STRING

	aCod:=Split(self:mCodInt," ")
	FOR i:=1 to 9 
		mCodH:=""
		if i<=Len(aCod)
			mCodH  :=aCod[i]
		endif
		IF Empty(mCodh).or.AScan(pers_codes,{|x|x[2]==mCodH})=0
			mCodH:=nil
		ENDIF
		++j
		IVarPutSelf(SELF,String2Symbol("mCod"+AllTrim(Str(j,2))),mCodh)
	NEXT

	IF SELF:lImport
		* Analyse name if needed:
/*		IF !lImportAutomatic
			oPers:=SELF:Server
			IF lLastName .and. lAddress
				* m51_lastname and m51_AD1 allready filled within DataWindowextra:MapItems
				IF !lInitials .or. !lMiddleName .or. ! lSalutation
				   * analyse name
					oPers:NameAnalyse(lAddress,lInitials,lSalutation,lMiddleName)
				ENDIF
				IF !lZipCode .or. !lCity
					oPers:Adres_Analyse(GetTokens(oPers:m51_ad1),,lZipCode,lCity)
				ENDIF
			ELSE
				IF !lLastName
					oPers:m51_lastname:=oPers:m51_ad1
				ENDIF
				oPers:m51_ad1 := ""
				oPers:NAW_ANALYSE(lInitials,lSalutation,lMiddleName,lZipCode,lCity)
			ENDIF
			SELF:mLastname:=oPers:m51_lastname
			IF !lInitials
				SELF:oDCmInitials:Value:=oPers:m51_initials
			ENDIF
			IF !lSalutation
				SELF:oDCmTit:Value:=oPers:m51_title
			ENDIF
			IF !lMiddleName
				SELF:oDCmHISN:Value:=oPers:m51_prefix
			ENDIF
			SELF:oDCmAddress:Value:=oPers:m51_ad1
			IF !lCity
				SELF:oDCmPla:Value:=oPers:m51_city
			ENDIF
			IF !lZipCode
				SELF:oDCmPos:Value:=oPers:StandardZip(oPers:m51_pos)
			ENDIF
		ENDIF */
	ENDIF
			
RETURN
METHOD Sync(oPerson,oPersBank,oReport,oAddrs,type,kopregels,nRow,nPage,nver) CLASS NewPersonWindow
// save kidnbr as bank account and telephone#, email, remarks and mailing codes
LOCAL cEml,cFax,cMob,cType, cTelex as STRING
LOCAL  oPers:=oPerson AS Person
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
METHOD ValidatePerson() CLASS NewPersonWindow
 	LOCAL lValid := TRUE, lUnique AS LOGIC
	LOCAL cError, cSelBank as STRING
	LOCAL i, nAnswer AS INT
	LOCAL oPers, oSel as SQLSelect
	LOCAL Housnbr as STRING
	
//RETURN TRUE  // voor testen ============
	if !lNew
		oPers:=SQLSelect{"select * from person where persid='"+Str(self:mPersid,-1)+"'",oConn}
	endif
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
	self:mLastName:=AllTrim(self:oDCmLastName:VALUE)
	self:mPostalcode:=StandardZip(AllTrim(self:oDCmPOStalcode:VALUE))
	self:mFirstname:=AllTrim(self:oDCmFirstname:VALUE)
	self:mAddress:=AllTrim(self:oDCmAddress:VALUE)
	IF lValid.and.(self:lNew.or. !AllTrim(self:mLastName) = AllTrim(oPers:lastname) .or. oPers:postalcode # self:mPostalcode.or.oPers:firstname # self:mFirstname.or.oPers:address # self:mAddress.or. ZeroTrim(oPers:EXTERNID) # self:mExternid)
		* Check duplicate NAC:
		oSel:=SQLSelect{"select persid from person where lastname='"+self:mLastName+"' and postalcode like '"+self:mPostalcode+"%' and (firstname='' or firstname like '"+self:mFirstname+"%') and address like '";
		+self:mAddress+"%'"+iif(self:lNew,""," and persid<>'"+Str(self:mPersid,-1)+"'"),oConn}
		oSel:GoTop()
		IF oSel:RecCount>0
			Housnbr:=GetStreetHousnbr(self:mAddress)[2]
			nAnswer:=(TextBox{self, self:oLan:WGet("Edit Person"), self:oLan:WGet("Person")+" "+AllTrim(self:mLastName)+;
			IF(Empty(self:mPostalcode),""," - "+self:oLan:WGet("zip")+":"+self:mPostalcode) + ;
			IF(Empty(Housnbr),""," - "+self:oLan:WGet("house#")+":"+Housnbr) +; 
			iif(Empty(AllTrim(self:mExternid)),"",' or with external id:'+AllTrim(self:mExternid))+;
			" "+self:oLan:WGet("already exist")+"! "+self:oLan:WGet("Save anyway")+"?",BUTTONYESNO+BOXICONQUESTIONMARK}):Show()
			IF nAnswer==BOXREPLYNO
				lValid := FALSE
			ENDIF
		ENDIF
		IF lValid .and.!Empty(AllTrim(self:mExternid))
			// check if no duplicate external id:
			oSel:SQLString:="select persid from person where externid='"+ZeroTrim(self:mExternid)+"'"+iif(self:lNew,""," and persid<>'"+Str(self:mPersid,-1)+"'")
			oSel:Execute()
			IF oSel:RecCount>0
				cError :=self:oLan:WGet("Person")+" "+GetFullName(oSel:persid,2)+" "+self:oLan:WGet("has already external id")+" "+self:mExternid+"!"
				self:oDCmExternid:SetFocus()
				lValid:=false
			ENDIF
		endif
	ENDIF
	IF 	lValid
		// check type of person:
		IF SELF:oDCmType:CurrentItemNo==0
			cError :=self:oLan:WGet("Select a type for this person")
			SELF:oDCmType:SetFocus()
			lValid:=FALSE
		ENDIF
	ENDIF
	IF 	lValid
		// check gender of person:
		IF SELF:oDCmGender:CurrentItemNo==0
			cError :=self:oLan:WGet("Select a gender for this person")
			SELF:oDCmGender:SetFocus()
			lValid:=FALSE
		ENDIF
	ENDIF
	IF lValid .and. Len(aBankAcc)>0
		* Check duplicate bankaccount:
		FOR i:=1 to Len(aBankAcc)
			IF !Empty(aBankAcc[i,2]).and.!Empty(aBankAcc[1,2])
				cSelBank+=iif(Empty(cSelBank),"("," or ")+"banknumber='"+aBankAcc[i,2]+"'"
			endif
		next
		IF !Empty(cSelBank) 
			cSelBank+=")"
			if !lNew
				cSelBank+=" and persid<>'"+Str(self:mPersid,-1)+"'"
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
		   IF self:lNew .or.Empty(self:oPerson:accid)  
  				lValid := FALSE
				cError := self:oLan:WGet("Mailing code")+" '" +GetMailDesc("MW") + "' "+self:oLan:WGet("only allowed in case of member")
			ENDIF
		ELSE
			IF !self:lNew .and.!Empty(self:oPerson:accid) 
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
METHOD FindPersSubVrn(lCheck,FirstNameFound,FirstNameExactFound,nFoundRec,IsUnique, cSearch) CLASS Person
	// Subroutine of method FindPers
	// lCheck is checkvalue to be set
	// lCheck,FirstNameFound,FirstNameExactFound,nFoundRec,IsUnique are relative addressed value with new values returned
	// cSearch is given value to be searched
	// Returns True: if do loop with search has to be exited, else false
	// refine found record with firstname check:
	LOCAL m51vrn:=Upper(AllTrim(self:m51_firstname)), mFirstname:=Upper(AllTrim(self:firstname)) as STRING
	IF lCheck
		IF !Empty(self:m51_firstname)
			IF !Empty(self:firstname)
				IF m51vrn $ mFirstname .or. mFirstname $ m51vrn
					// first name match:
					IF !FirstNameFound
						FirstNameFound:=true
						nFoundRec:=self:RecNo
						IsUnique := true
						IF m51vrn == mFirstname
							FirstNameExactFound:=true
						ENDIF
					ELSE
						IF m51vrn == mFirstname
							IF FirstNameExactFound
								IsUnique:=FALSE
							ELSE
								nFoundRec:=self:RecNo
								FirstNameExactFound:=true
								IsUnique := true
							ENDIF
                    	ELSEIF !FirstNameExactFound
							IsUnique := FALSE
						ENDIF
					ENDIF
				ELSEIF !FirstNameFound
					IsUnique:=FALSE
				ENDIF
			ELSE
				IF !FirstNameFound
					IsUnique:=FALSE
				ENDIF
			ENDIF
		ELSE
			IsUnique := FALSE
			IF Empty(cSearch)
				// EXIT
				RETURN true
			ENDIF
		ENDIF
	ELSE
		lCheck:=true
		nFoundRec:=self:RecNo
		IF !Empty(self:m51_firstname) .and.!Empty(self:firstname)
			IF m51vrn $ mFirstname .or. mFirstname $ m51vrn
				// first name match:
				FirstNameFound:=true
				IF m51vrn == mFirstname
					FirstNameExactFound:=true
				ENDIF
			ENDIF
		ENDIF
	ENDIF
RETURN FALSE
Method GetBankAccnts(mPersid) class Person 
local aBankAcc:={} as array
local oSel as SQLSelect
Default(@mPersid,self:persid)
 
	* Fill aBankAcc:
	oSel:=SQLSelect{"select banknumber from personbank where persid="+mPersid,oConn}
DO WHILE !oSel:EoF 
	IF !Empty(oSel:banknumber)
		AAdd(aBankAcc,AllTrim(oSel:banknumber))
	ENDIF
	oSel:Skip()
ENDDO 
return aBankAcc
Method GetFullName(PersNbr,Purpose) CLASS Person
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
IF !IsNil(PersNbr) .and.!PersNbr==self:persid
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
if TITELINADR.and.!Empty(self:Title) .and.(Purpose==1.or.Purpose==3) 
	titel += AllTrim(self:Title)+' '
endif
IF .not. Empty(self:prefix)
   prefix :=AllTrim(self:prefix) +" "
ENDIF
IF .not. Empty(self:lastname)
   naam1 := AllTrim(self:lastname)+" "
ENDIF
IF sFirstNmInAdr .or. (Purpose==2.or.Purpose==3)
	IF !Empty(self:firstname)
		frstnm += AllTrim(self:firstname)+' '
	ELSEIF .not. Empty(self:initials)  && anders voorletters gebruiken
		frstnm += AllTrim(self:initials)+' '
	ENDIF
ELSEIF .not. Empty(self:initials)  && anders voorletters gebruiken
	frstnm += AllTrim(self:initials)+' '
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
METHOD GetFullNAW(PersNbr,country,Purpose) CLASS Person
* Samenstellen van te tonen NAW
* country: default country (optional)
LOCAL f_regel:="" as STRING
// LOCAL nCurRec as int
Default(@country,null_string)
Default(@PersNbr,nil)
Default(@Purpose,1)

IF !self:Used
	RETURN null_string
ENDIF 
// nCurRec:=self:RecNo
IF !IsNil(PersNbr) .and.!PersNbr==self:persid
	IF IsString(PersNbr)
		IF Empty(PersNbr)
			RETURN ""
		ENDIF
		self:seek(#persid,PersNbr)
	ENDIF
ENDIF
f_regel:=self:GetFullName(,Purpose)


/*f_regel:=SELF:Salutation
IF .not. Empty(f_regel)
   f_regel+=' '
ENDIF
IF sFirstNmInAdr .and..not.Empty(SELF:firstname)
   f_regel+=AllTrim(SELF:firstname)+' '
ELSEIF .not. Empty(SELF:initials)  && anders voorletters gebruiken
   f_regel+=AllTrim(SELF:initials)+' '
ENDIF
IF .not. Empty(SELF:prefix)
   f_regel+=AllTrim(SELF:prefix)+' '
ENDIF
IF .not. Empty(SELF:lastname)
   f_regel+=AllTrim(SELF:lastname)
ENDIF    */
f_regel:=f_regel+', '
IF .not.Empty(self:address)
   f_regel+=AllTrim(self:address)+" "
ENDIF
IF .not.Empty(self:postalcode)
   f_regel+=Trim(self:postalcode)+" "
ENDIF
IF .not.Empty(self:city)
   f_regel+=Trim(self:city)+" "
ENDIF
IF .not.Empty(self:country)
   f_regel+=Trim(self:country)
ELSEIF .not.Empty(country)
   f_regel+=country
ENDIF
// if !IsNil(PersNbr) .and.!nCurRec==self:RecNo
// 	self:Goto(nCurRec)
// endif
RETURN AllTrim(f_regel)
METHOD GetGiroNAW() CLASS Person
* samenstellen van adres op GiroAccept
LOCAL cPlaats as STRING, i as int, cLan as STRING
LOCAL aAdr:={} as ARRAY
/*naam1 := SELF:Salutation
IF .NOT. Empty(naam1)
	naam1 += ' '
ENDIF
IF .not. Empty(SELF:prefix)
   naam1 += AllTrim(SELF:prefix)+' '
ENDIF
IF .not. Empty(SELF:lastname)
   naam1 += AllTrim(SELF:lastname)+' '
ENDIF
IF sFirstNmInAdr
	IF !Empty(SELF:firstname)
		frstnm += AllTrim(SELF:firstname)+' '
	ELSEIF .not. Empty(SELF:initials)  && anders voorletters gebruiken
		frstnm += AllTrim(SELF:initials)+' '
	ENDIF
ELSEIF .not. Empty(SELF:initials)  && anders voorletters gebruiken
	frstnm += AllTrim(SELF:initials)+' '
ENDIF		
IF sSurnameFirst
   	naam1 += frstnm
ELSE
   	naam1 := frstnm+naam1
ENDIF */

AAdd(aAdr,Upper(self:GetFullName(,1)))
IF .not. Empty(self:country)
	cLan:=Upper(AllTrim(self:country))
	IF AScan(OwnCountryNames,{|x| Upper(AllTrim(x))==cLan})#0
		cLan := ""
	ENDIF
ENDIF

IF .not. Empty(cLan).and. sSTRZIPCITY==2
	AAdd(aAdr,cLan)
ENDIF
IF sSTRZIPCITY#3
	IF self:postalcode # '0001' .and. self:postalcode # '0002'
		cPlaats := AllTrim(AllTrim(self:postalcode) + '   ' + AllTrim(self:city))
	ELSE
		cPlaats := AllTrim(self:city)
	ENDIF
ELSE
	cPlaats := AllTrim(AllTrim(self:city)+'   '+AllTrim(self:postalcode))
ENDIF
IF  (sSTRZIPCITY==2 .or. sSTRZIPCITY==1) .and.!Empty(cPlaats)
	AAdd(aAdr,cPlaats)
ENDIF
AAdd(aAdr,Upper(AllTrim(self:address)))
IF  (sSTRZIPCITY==0 .or. sSTRZIPCITY==3) .and.!Empty(cPlaats)
	AAdd(aAdr,cPlaats)
ENDIF
IF .not. Empty(cLan).and. sSTRZIPCITY#2
	AAdd(aAdr,cLan)
ENDIF
FOR i:=1 to Len(aAdr)
	IVarPutSelf(self,String2Symbol("md_adres"+Str(i,1,0)),aAdr[i])
NEXT
RETURN nil
METHOD GetStreetHousnbr(Address) CLASS Person
	* return array {streetname, housnbr} from input Address
	return GetStreetHousnbr(Address)
METHOD ResetNAW() CLAS Person
* Reset of fields for name and address:
	m51_initials:= m51_firstname:= m51_lastname:= m51_title:= m51_prefix:= m51_pos:=	m51_AD1:=m51_city:=""
RETURN
METHOD SkipExact(nOrd as int,cValue as string) as logic CLASS Person
* search for exact match:
DO WHILE !self:EOF.and.!(nOrd==1.and.Upper(AllTrim(self:lastname))==Upper(self:m51_lastname) .or.;
	nOrd==2.and.Upper(AllTrim(self:postalcode))==cValue.or.nOrd==3)
	self:Skip()
	IF !(nOrd==1.and.Upper(self:lastname)=Upper(self:m51_lastname) .or.;
	nOrd==2.and.Upper(self:postalcode)=cValue)
		*	Not exact match found:
		self:GoBottom()
		self:Skip()  //enforce eof
		RETURN FALSE	
	ENDIF
ENDDO
RETURN true

(nOrd==1.and.Upper(AllTrim(self:lastname))==Upper(self:m51_lastname) .or.nOrd==2.and.Upper(AllTrim(self:postalcode))==cValue.or.nOrd==3)	
METHOD StandardZip(ZipCode) CLASS Person
	* Standardise Ducth Zip-code format: 9999 XX 
	if Empty(ZipCode)
		return null_string
	endif
	ZipCode:=Upper(AllTrim(ZipCode))
	IF Len(ZipCode)==6
		IF isnum(SubStr(ZipCode,1,4)) .and. !isnum(SubStr(ZipCode,5,2))
			RETURN SubStr(ZipCode,1,4)+" "+SubStr(ZipCode,5,2)
		ENDIF
	ENDIF
RETURN ZipCode
METHOD Close( oEvent ) CLASS PersonBrowser
IF SELF:IsVisible() .and. !SELF:oCaller==NULL_OBJECT
	// apparently not clicked on OK
    IF IsMethod(SELF:oCaller, #RegPerson)
   	IF !self:Server==null_object
   		IF self:Server:Used
				self:Hide()
				self:oCaller:RegPerson(,self:cItemName,true,self)
			ENDIF
		ENDIF
	ENDIF
ENDIF

IF !SELF:oEditPersonWindow==NULL_OBJECT
	SELF:oEditPersonWindow:Close()
	SELF:oEditPersonWindow:Destroy()
ENDIF

SELF:osfpersonsubform:Close()
SELF:oSFPersonSubForm:Destroy()
SELF:Destroy()	
	// force garbage collection
	*CollectForced()

	RETURN SUPER:Close(oEvent)
METHOD DeleteButton CLASS PersonBrowser

	LOCAL oTextBox AS TextBox
	LOCAL myCLN as STRING
	local oSel as SQLSelect
	local oSQL as SQLStatement
	IF SELF:Server:EOF.or.SELF:Server:BOF
		(Errorbox{,"Select a person first"}):Show()
		RETURN
	ENDIF
	oTextBox := TextBox{ SELF, "Delete Record",;
		"Delete Person " + FullName( ;
		oPers:lastname, ;
		oPers:firstname ) + "?" }
	
	oTextBox:Type := BUTTONYESNO + BOXICONQUESTIONMARK
	
	IF ( oTextBox:Show() == BOXREPLYYES )
		myCLN:=Str(self:oPers:persid,-1) 
		oSel:=SQLSelect{"select empid from employee where "+Crypt_Emp(false,"persid")+"='"+myCLN+"'",oConn}
		if oSel:RecCount>0
			ErrorBox{self,"This person is an employee! Remove person as employee first"}:Show()
			RETURN
		endif
		oSel:SQLString:="select persid from member where persid='"+myCLN+"'"
		oSel:Execute()
		if oSel:RecCount>0 
			InfoBox { self, "Delete Record",;
				"This person is a member! First remove person as member'"}:Show()
			RETURN
		ENDIF
		oSel:SQLString:="select TransId from transaction where persid='"+myCLN+"'"
		oSel:Execute() 
		if oSel:RecCount>0
			InfoBox { SELF, "Delete Record","Fin.records in not yet balanced years present! Wait untill year balancing"}:Show()
			RETURN
		ENDIF
		oSel:SQLString:="select persid from Subscription where persid='"+myCLN+"'"
		oSel:Execute()
		if oSel:RecCount>0
			InfoBox { SELF, "Delete Record",;
				"Subscript/donation/periodic gift present! Delete them first"}:Show()
			RETURN
		ENDIF
		oSQL:=SQLStatement{"delete from person where persid="+myCLN,oConn}
		oSQL:Execute()
		if Empty(oSQL:Status)
// 			* Ook bijbehorende openposten verwijderen:
// 			oSQL:=SQLStatement{"delete from dueamount where persid='"+myCLN+"'",oConn} 
// 			oSQL:Execute()
			* Remove corresponding bankaccounts in PersonBank : 
			oSQL:=SQLStatement{"delete from personbank where persid="+myCLN,oConn}
			oSQL:Execute() 
		else
			LogEvent(,'Delete person Error:'+oSQL:Status:Description+"; statement:"+oSQL:SQLString,"LogSQL")
			(ErrorBox{self,'Delete person Error:'+oSQL:Status:Description}):Show()
		endif

		oSQL:Commit() 
	endif
	// refresh owner: 
	self:oPers:Execute()
	self:gotop() 

	// 		oSFPersonSubForm:Browser:REFresh()
	// 		oPeriod:Close()
	// 		oTrans:Close()

	RETURN nil
METHOD FilePrint CLASS PersonBrowser

(Selpers{SELF,"MAILINGCODE"}):Show()
RETURN
METHOD GoBottom() CLASS PersonBrowser
	RETURN SELF:oSFPersonSubForm:GoBottom()
METHOD GoTop() CLASS PersonBrowser
	RETURN SELF:oSFPersonSubForm:GoTop()
METHOD NewButton CLASS PersonBrowser

SELF:EditButton(TRUE)

	RETURN NIL
METHOD PersonSelect(oExtCaller as object,cValue as string,Itemname as string,Unique as logic, oPersCnt as PersonContainer) as logic CLASS PersonBrowser
	LOCAL iEnd := At(",",cValue) as int
// 	Default(@cValue,null_string)
	self:oCaller := oExtCaller
	self:oPersCnt:=oPersCnt
	IF !Empty(Itemname)
		self:cItemname := Itemname 
		if cItemname="person to merge with"
			self:oCCUnionButton:Hide()
		endif
	ENDIF
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
			IF Len(cValue)>6 .and.!IsAlpha(psz(_cast,SubStr(cValue,Len(cValue),1)))
				self:SearchBank := cValue
			ELSE				
				self:SearchSZP := cValue
			ENDIF
		ELSE
			self:SearchSLE := AllTrim(SubStr(cValue,1,if(iEnd<2,nil,iEnd-1)))
		ENDIF
		if !Empty(oPersCnt).and.!Empty(oPersCnt:persid)
			self:SearchCLN:=oPersCnt:persid
		endif
	ENDIF
	
// 	IF lUnique.and.(lFoundUnique.or.Empty(cValue))
// 		IF IsMethod(oExtCaller, #RegPerson)
// 			IF Empty(cValue)
// 				oExtCaller:RegPerson(,Itemname)
// 			ELSE
// 				oExtCaller:RegPerson(oPers,Itemname)
// 			ENDIF
// 		ENDIF	
// 	ELSE 

		IF !Empty(oPersCnt).and.!Empty(oPersCnt:m51_lastname)
			self:caption+=Compress(" "+oPersCnt:m51_lastname+","+oPersCnt:m51_title+;
			" "+oPersCnt:m51_initials+" "+oPersCnt:m51_prefix+"; "+oPersCnt:m51_ad1+" "+;
			oPersCnt:m51_pos+" "+oPersCnt:m51_city)
		else
			self:caption+=Compress(" "+cValue)
		ENDIF
		self:Show() 
// 		self:GoTop()
// 	ENDIF
	RETURN true

method RegPerson(oCLN) class PersonBrowser 
Local oTextBox as TextBox 
local CurRec as int
Local oP1:=oCLN, oP2:=self:Server as SQLSelect 
Local Id1, Id2,Name1,Name2 as string
IF !Empty(oCLN)
	Id1:=Str(oP1:persid,-1)
	Id2:=Str(oP2:persid,-1) 
	Name1:=GetFullNAW(Id1,,3)	
	Name2:=GetFullNAW(Id2,,3)	
	oTextBox := TextBox{ self, "Merge Record","Merge "+Name2+"  into person: "+Name1+"?"+ CRLF+ CRLF + "This means that all gifts, donations and standard gift pattens of "+Name2+" will be transfered to "+Name1+CRLF+" and that "+Name2+ " will be removed" }
		
	oTextBox:Type := BUTTONYESNO + BOXICONQUESTIONMARK
	
	IF ( oTextBox:Show() == BOXREPLYYES ) 
		CurRec:=oCLN:RECNO 
		PersonUnion(Id1,Id2)
		self:GoTop() 
		self:oSFPersonSubForm:Browser:refresh()
		self:Server:RECNO:=CurRec 		
	endif

ENDIF
RETURN true
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
METHOD Adres_Analyse(woorden, nStartAnalyse,lZipCode,lCity,lAddress,lFromName) CLASS PersonContainer
*  Determines Zipcode, street and city from an array with NAW-words {{Token, Separator},...}
*	Returns startposition of address in the array
*	nStartAnalyse: startword to start analyses (default=1)
*	lZipCode : True: zipcode is allreeady known
*	lCity : True: city name allready known 
*  lFromName: Find address in name field in stead of address field
*
LOCAL i,j,wp,l,  nNumPosition:=0, nZipPosition, nCityPosition, nStart, nStartAddress as int
LOCAL aStreetPrefix:={"VAN","OP","V/D","V/H","O/H","DEN","VON","VD","DE","HET"} as ARRAY
Default(@nStartAnalyse,1)
Default(@lZipCode,FALSE)
Default(@lCity,FALSE)
Default(@lAddress,FALSE)
Default(@lFromName,FALSE)

* vaststellen of postkode gevonden:
wp:=Len(woorden)
IF wp<2 && (first streetname, housenumber, first part zipcode)
	RETURN wp+1
ENDIF
IF !lZipCode
	m51_pos:=""
	*Search Zipcode:
	FOR i:=nStartAnalyse+1 to wp
		IF isnum(woorden[i-1,1])
			IF Len(woorden[i-1,1])=4
				IF Len(woorden[i,1])=2
					IF IsAlpha(woorden[i,1])
						* postkode gevonden:
						self:m51_pos:=woorden[i-1,1]+" "+woorden[i,1]
						nZipPosition:=i-1
						woorden[i]:={"",""} // empty word
						woorden[i-1]:={"",""} // empty word
						lZipCode:=true
						exit
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	NEXT
ENDIF
IF !Empty(nZipPosition)
	nStart:=nZipPosition-1
	nCityPosition:=nZipPosition+2
	nStartAddress:=nZipPosition
ELSE
	nStart:=Min(6,wp)
ENDIF
IF !lAddress
	m51_ad1:=""
	* Search streetname:
	* Search backwards till housenbr:
	FOR l:=nStart to nStartAnalyse step -1
		IF isnum(woorden[l,1]).and.l>1.and.Empty(nNumPosition)
//		IF IsDigit(woorden[l,1]).and.l>1.and.Empty(nNumPosition)
			* Housenbr found:
			nNumPosition:=l
			// check housenbr addition:
			if l<nStart
				if Empty(woorden[l+1,1]) .and. (l+1)<nStart   // separation for addition: - / 
					nNumPosition+=2
				elseif Len(woorden[l+1,1])=1 .or.woorden[l+1,2]="-" 
					nNumPosition++  // addition part of address
				endif
			endif
		ELSEIF IsAlpha(woorden[l,1]).and.!Empty(nNumPosition)
			* Streetname found:
			if lFromName
				IF l>nStartAnalyse.and.(Len(woorden[l-1,1])<3.or. AScanExact(aStreetPrefix,woorden[l-1,1])>0)
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
				self:m51_ad1:=self:m51_ad1+Upper(SubStr(woorden[j,1],1,1))+Lower(SubStr(woorden[j,1],2))+woorden[j,2]
				woorden[j]:={"",""} // empty word			
				lAddress:=true
			NEXT
			exit
		ENDIF
	NEXT
ENDIF
IF !lCity
	m51_city:=""
	IF nCityPosition<=wp .and. nCityposition>0
		FOR j:=nCityPosition to wp
			IF Len(m51_city)+Len(woorden[j,1])>=18.or.woorden[j,1]=="FAM".or.woorden[j,1]=="GIFT".or.woorden[j,1]=="TGV";
				.or.woorden[j,1]=="TNV".or.woorden[j,1]=="VOOR".or.IsDigit(woorden[j,1])
				exit
			ENDIF
			self:m51_city:=self:m51_city+" "+woorden[j,1]
			woorden[j]:={"",""} // empty word
		NEXT
		self:m51_city:=Pad(AllTrim(self:m51_city),18)
		lCity:=true
	ENDIF
ENDIF
IF Empty(nStartAddress)
	RETURN wp+1
ENDIF
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
LOCAL aFirstPrefix:={"VAN","OP","V/D","V/H","O/H","DEN","VON","VD","DE","HET"} as ARRAY
LOCAL aSecondPrefix:={"DEN","DER","HET","DE"} as ARRAY
LOCAL aSalutation:={"DHR","HR","MW","MEJ","HR/MW","FAM","MR","MRS","PROF","DR","IR","DS","ARTS","DRS"} as ARRAY
LOCAL aSalutationSep:={"EN","E/O",""} as ARRAY
LOCAL nInitialsPos, nSalutationPos, nPrefixPos, nStart, nCityPosition as int
Default(@lAddress,FALSE)
Default(@lInitials,FALSE)
Default(@lSalutation,FALSE)
Default(@lMiddleName,FALSE)
aWord:=GetTokens(m51_lastname)
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
			m51_initials:=m51_initials+Upper(aWord[i,1])+"."
			IF !lInitials
				nInitialsPos:=i
				lInitials:=true
			ENDIF
			aWord[i]:={"",""} // empty word
		ELSEIF lInitials
			exit
		ENDIF
	NEXT
ENDIF

*  Determine salutation:
*
m51_title:=""
IF !lSalutation .and. (!lInitials .or. nInitialsPos> 1 .or. Empty(nInitialsPos))
	* enough space for salutation:
	IF lInitials
		*	Salutation should be before initials:
		IF !Empty(nInitialsPos)
			nLength:=nInitialsPos-1
		ENDIF
	ENDIF
	FOR i:=1 to nLength
		IF AScanExact(aSalutation,aWord[i,1])>0
			m51_title:=m51_title+Upper(SubStr(aWord[i,1],1,1))+Lower(SubStr(aWord[i,1],2))+aWord[i,2]
			IF !lSalutation
				nSalutationPos:=i
				lSalutation:=true
			ENDIF
		ELSE
			IF lSalutation
				IF AScanExact(aSalutationSep,aWord[i,1])>0
					m51_title:=m51_title+Lower(aWord[i,1])+aWord[i,2]
				ELSE
					* search for e/o, etc
					IF i+1< nLength.and.AScanExact(aSalutationSep,aWord[i,1]+aWord[i,2]+aWord[i+1,1])>0
						m51_title:=m51_title+Lower(aWord[i,1]+aWord[i,2]+aWord[i+1,1]+aWord[i+1,2])
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
		m51_title:=""
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
	m51_prefix:=""
	nLength:=Len(aWord)
	*	Prefix direct behind initials/salutation:
	nStart:=Max(nInitialsPos,nSalutationPos)+1
	IF nStart <=nLength
		nStart:=AScanExact(aWord,{|x| !Empty(x[1])},nStart)
		// any word direct after salutation/initial or start
		IF nStart>0
			IF AScanExact(aFirstPrefix,aWord[nStart,1])>0
				m51_prefix:=Lower(aWord[nStart,1])
				nPrefixPos:=nStart
				aWord[nStart]:={"",""} // empty word
				IF nStart<nLength
					IF AScanExact(aSecondPrefix,aWord[nStart+1,1])>0
						m51_prefix:=m51_prefix+" "+Lower(aWord[nStart+1,1])
						aWord[nStart+1]:={"",""} // empty word
					ENDIF
				ENDIF
			ELSE
				* search for o/h, etc:
				IF nStart<nLength .and.AScanExact(aFirstPrefix,aWord[nStart,1]+aWord[nStart,2]+aWord[nStart+1,1])>0
					m51_prefix:=Lower(aWord[nStart,1]+aWord[nStart,2]+aWord[nStart+1,1])
					nPrefixPos:=nStart
					aWord[nStart]:={"",""} // empty word
					aWord[nStart+1]:={"",""} // empty word
				ENDIF
			ENDIF
		ENDIF
	ENDIF
ENDIF
*
*	Determine initials if not yet found from 2 character word:
IF !lInitials
	i:=AScanExact(aWord,{|x| !Empty(x[1])})
	IF !Empty(i).and.Len(aWord[i,1])==2.and.IsAlpha(aWord[i,1])
		nInitialsPos:=i
		lInitials:=true
		m51_initials:=SubStr(aWord[nInitialsPos,1],1,1)+"."+SubStr(aWord[nInitialsPos,1],2,1)+"."
		aWord[nInitialsPos]:={"",""}
	ENDIF
ENDIF
*	Determine City if no address found up till now:
nStart:=Max(nInitialsPos,Max(nSalutationPos,nPrefixPos))+1
IF nStart <=nLength
	nStart:=AScanExact(aWord,{|x| !Empty(x[1])},nStart)
ELSE
	nStart:=0
ENDIF
IF  !lAddress
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
				.and.AScanExact(aFirstPrefix,aWord[nLength-1,1])=0 // no prefix preceding city name
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
m51_lastname:=""
FOR i:=if(Empty(nStart),1,nStart) to nLength
	IF Len(m51_lastname)+Len(aWord[i,1])<=28
		IF !aWord[i,1]=="EN" .and.!aWord[i,1]=="EO".and.!aWord[i,1]=="CJ".and.!aWord[i,1]=="VOOR";
			.and.!aWord[i,1]=="GIFT".and.!aWord[i,1]=="TGV".and.!IsDigit(aWord[i,1])
			m51_lastname:=m51_lastname+Upper(SubStr(aWord[i,1],1,1))+Lower(SubStr(aWord[i,1],2))+if(aWord[i,2]==","," ",aWord[i,2])
		ELSE
			if aWord[i,1]=="EN" .or.!aWord[i,1]=="EO".or.!aWord[i,1]=="CJ"
				self:m51_gender:="couple"
			endif 
			IF i==nStart
				loop
			ELSE
				* Next word probably part of streetname in case of "EN OF". "EO" or "CJ":
				IF lAddress .and. i+2==nLength .and.aWord[i+1,1]=="OF"
					m51_ad1:=Upper(SubStr(aWord[i+2,1],1,1))+Lower(SubStr(aWord[i+2,1],2))+" "+m51_ad1
				ELSEIF lAddress.and.i+1==nLength .and.(aWord[i,1]=="EO".or.aWord[i,1]=="CJ")
					m51_ad1:=Upper(SubStr(aWord[i+1,1],1,1))+Lower(SubStr(aWord[i+1,1],2))+" "+m51_ad1
				ENDIF
				exit
			ENDIF
		ENDIF
	ELSE
		exit
	ENDIF
NEXT
m51_lastname:=Compress(m51_lastname)

RETURN
METHOD NAW_ANALYSE(lInitials,lSalutation,lMiddleName,lZipCode,lCity,lAddress) CLASS PersonContainer
*  Analyse strings m15_achternaam and m51_ad1 containing NAW-data (e.g. from TeleBanking)
LOCAL nLength  as int
LOCAL aWord as ARRAY
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
IF Empty(m51_lastname+" "+m51_AD1)
	RETURN
ENDIF
*	First try te find address within m51_ad1:
aWord:=GetTokens(m51_ad1)
nLength:=self:Adres_Analyse(aWord,,@lZipCode,@lCity,@lAddress,false)-1
/*IF nLength<Len(aWord) .and. nLength >0
	lAddress:=TRUE
ENDIF */
self:NameAnalyse(lAddress,lInitials,lSalutation,lMiddleName,lZipCode,lCity)
RETURN
FUNCTION PersonGetByExID(oCaller as Object,cValue as string,cItemname as String) as logic
// Find a person by means of its external id
	LOCAL oPers as SQLSelect
	if Empty(cValue)
		return false
	endif
	oPers:=SQLSelect{"select persid from person where externid='"+cValue+"'",oConn}
	if oPers:RecCount>0 
		IF IsMethod(oCaller, #RegPerson)
			oCaller:RegPerson(oPers,cItemname)
		ENDIF	
	ENDIF
	RETURN (oPers:RecCount>0)
FUNCTION PersonSelect(oCaller:=null_object as window,cValue:="" as string,lUnique:=false as logic,cFilter:="" as string,;
cItemname:="" as string,oPersCnt:=null_object as PersonContainer) as void pascal
	LOCAL oPersBw as PersonBrowser
	LOCAL lSuccess,lParmUni as LOGIC 
	local cWhere,cFrom:="person as p", cOrder:="lastname" as string
	local oSel as SQLSelect 
	LOCAL iEnd := At(",",cValue) as int
	
	// 	IF lUnique 
	if !Empty(oPersCnt)
		if !Empty(oPersCnt:persid)
			cWhere:="p.persid='"+oPersCnt:persid+"'" 
			lParmUni:=true
		elseif !Empty(oPersCnt:m51_exid)
			cWhere:="externid='"+oPersCnt:m51_exid+"'"
			lParmUni:=true
		elseif !Empty(oPersCnt:m56_banknumber)
			cWhere:="b.banknumber='"+oPersCnt:m56_banknumber+"'"
			cFrom+=",personbank as b"
			lParmUni:=true
		else
			if !Empty(oPersCnt:m51_AD1)
				cWhere+=iif(Empty(cWhere),""," and ")+"address like '"+oPersCnt:m51_ad1+"%'"
			ENDIF
			if !Empty(oPersCnt:m51_lastname)
				cWhere+=iif(Empty(cWhere),""," and ")+"lastname like '"+oPersCnt:m51_lastname+"%'"
			ENDIF
			if !Empty(oPersCnt:m51_city)
				cWhere+=iif(Empty(cWhere),""," and ")+"city like '"+oPersCnt:m51_city+"%'"
			ENDIF
			if !Empty(oPersCnt:m51_pos)
				cWhere+=iif(Empty(cWhere),""," and ")+"postalcode like '"+oPersCnt:m51_pos+"%'"
			ENDIF
			if !Empty(oPersCnt:m51_country)
				cWhere+=iif(Empty(cWhere),""," and ")+"city like '"+oPersCnt:m51_city+"%'"
			ENDIF
		endif
	endif
	if !Empty(cValue) .and.!lParmUni 
		cValue:=AllTrim(SubStr(cValue,1,if(iEnd<2,nil,iEnd-1)))
		If IsDigit(cVALUE)
			if Len(cValue)>=7.and.isnum(cValue) .and.(Empty(oPersCnt).or.Empty(oPersCnt:m56_banknumber))
				cWhere+=iif(Empty(cWhere),""," and ")+"p.persid=b.persid and b.banknumber='"+cValue+"'"
				cFrom+=",personbank as b" 
			elseif Empty(oPersCnt).or.Empty(oPersCnt:m51_pos)
				cWhere+=iif(Empty(cWhere),""," and ")+"postalcode like '"+StandardZip(cValue)+"%'" 
				cOrder:="postalcode"
			endif
		elseif Empty(oPersCnt).or.Empty(oPersCnt:m51_lastname)
			// search on name
			cWhere+=iif(Empty(cWhere),""," and ")+"lastname like '"+cValue+"%'" 
		endif
	endif
// 	if !Empty(cFilter)
// 		cWhere+=iif(Empty(cWhere),""," and ")+"("+cFilter+")" 			
// 	endif
	IF lUnique 
		oSel:=SQLSelect{"select p.persid from "+cFrom+" where "+cWhere+iif(Empty(cFilter),"",iif(Empty(cWhere),""," and ")+"("+cFilter+")")+" order by "+cOrder,oConn}
		if oSel:RecCount=1		
			// 		IF oPersCnt:FindPers(cValue)
			IF IsMethod(oCaller, #RegPerson)
				oCaller:RegPerson(oSel,cItemname)
			ENDIF	
			RETURN
		ENDIF
	ENDIF
	
	oPersBw := PersonBrowser{oCaller:Owner,,,oCaller} 
	oPersBw:cWhere:= cWhere
	oPersBw:cFrom:=cFrom
	oPersBw:cOrder:=cOrder
	oPersBw:cFilter:=cFilter
	oPersBw:oPers:SQLString:="select "+oPersBw:cFields+" from "+cFrom+iif(Empty(cWhere).and.Empty(cFilter),""," where ")+cWhere+;
	iif(Empty(cFilter),"",iif(Empty(cWhere),""," and ")+"("+cFilter+")")+" order by "+cOrder 
	oPersBw:oPers:Execute()
	oPersBw:Found:=Str(oPersBw:oPers:RecCount,-1) 
	//position at current person: 
	if Empty(oPersCnt)
		oPersCnt:=PersonContainer{}
	endif
	if oPersBw:oPers:RecCount>1 .and.!Empty(oPersCnt)
		if !Empty(oPersCnt:current_PersonID) 
			do while !oPersBw:oPers:persid==oPersCnt:current_PersonID
				oPersBw:Skip()
			enddo
		endif
	endif
	oPersBw:PersonSelect(oCaller,cValue,cItemname,lUnique,oPersCnt)	
	RETURN
function Salutation(GENDER as int) as string
	// Return salutation of a person:	
	return pers_salut[iif(Empty(GENDER),5,GENDER),1]

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
	PROTECT oPers as SQLSelect
	PROTECT oPersBank as SQLSelect
	PROTECT m_fieldnames,m_values,m_AdressLines as ARRAY 
	Export Ann as ARRAY
	PROTECT pKondp, pKondA AS _CODEBLOCK
	PROTECT pKond AS _CODEBLOCK
	PROTECT splaats AS STRING
	PROTECT oExtServer AS OBJECT
	PROTECT oEditPersonWindow AS NewPersonWindow
	PROTECT m12_bd AS LOGIC
	PROTECT oWindow AS OBJECT
	PROTECT cType AS USUAL
	EXPORT myFields AS ARRAY
	EXPORT AddMailCds, DelMailCds as ARRAY 
	export aExtraProp:={} as array      // for selecting persons via extra properties: {name,type,{values}} 
	export ExportFormat as string 
	export ReportMonth as string 
	export GrpFormat as string
	export oDB as SQLSelectPerson 
	protect cFrom:="person as p" as string // list with tables to read from
	protect cFields as string  // fields to be retrieved from the database 
	
	declare method ChangeMailCodes,FillText,MarkUpDestination,AnalyseTxt
METHOD AcceptGiro(Rij, Blad , oReport, brief, oSelPers, brief_breedte,ind_openpost,ind_gift,ind_naw,ind_herh) CLASS SelPers
*	Print of acceptgiro (small)
* self: server
* oReport: Printjob
LOCAL brieftxt, regel, cBank AS STRING
LOCAL m96_regels,regel_tel, tel, skiptst:=14  AS INT
LOCAL m12_openbed AS FLOAT

* Test bladskip:
*oReport:PrintLine(@rij,@blad,,,14)
brieftxt:=self:FillText(brief,oSelPers:selx_keus1,ind_openpost,ind_gift,ind_naw,ind_herh,brief_breedte)
IF !Empty(brief)
	m96_regels:=MLCount(brieftxt,35)
	FOR regel_tel=1 TO 3
		IF regel_tel <= m96_regels
			oReport:PrintLine(@Rij,@Blad,Space(41)+MemoLine(brieftxt,35,regel_tel),,skiptst)
			--skiptst
		ELSE
			oReport:PrintLine(@Rij,@Blad,' ',,skiptst)
			--skiptst
		ENDIF
	NEXT
ELSE
	FOR regel_tel = 1 TO 3
		oReport:PrintLine(@Rij,@Blad,' ',,skiptst)
		--skiptst
	NEXT
ENDIF
m12_openbed:=Val(self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%AMOUNTDUE"})])
IF m12_bd
	oReport:PrintLine(@Rij,@Blad,oPers:persid+Space(16)+Str(m12_openbed,5,0)+;
	Space(4)+SubStr(Str(m12_openbed,7,decaantal),6,2)+;
	Space(9)+self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEIDENTIFIER"})])
*	Space(8)+oSelpers:selx_rek+' '+self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEDATE"})])
ELSE
*	oReport:PrintLine(@rij,@blad,oPers:persid+Space(33)+oSelpers:selx_rek+'  '+self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEDATE"})])
	oReport:PrintLine(@Rij,@Blad,oPers:persid+Space(34)+self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEIDENTIFIER"})])
ENDIF
oReport:PrintLine(@Rij,@Blad,' ')
oReport:PrintLine(@Rij,@Blad,' ')
IF m12_bd
*	oReport:PrintLine(@rij,@blad,Str(m12_openbed,6,0)+Space(3)+SubStr(Str(m12_openbed,7,decaantal),6,2))
	regel:=Str(m12_openbed,6,0)+Space(3)+SubStr(Str(m12_openbed,7,decaantal),6,2)
ELSE
	regel:=Space(11)
ENDIF
cBank:=AllTrim(self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%BANKACCOUNT"})])
IF !Empty(cBank)
	regel:=Pad(regel,24)+cBank
ENDIF
oReport:PrintLine(@Rij,@Blad,regel)
oReport:PrintLine(@Rij,@Blad,' ')
*oReport:PrintLine(@rij,@blad,' ')
SELF:oPers:GetGiroNaw()
oReport:PrintLine(@Rij,@Blad,Space(21)+ self:oPers:md_address1)
oReport:PrintLine(@Rij,@Blad,Space(21)+ self:oPers:md_address2)
oReport:PrintLine(@Rij,@Blad,Space(21)+ self:oPers:md_address3)
oReport:PrintLine(@Rij,@Blad,Space(21)+ self:oPers:md_address4)

IF oReport:oPrintJob:PaperHeight-Rij>9  // nog ruimte voor een volgende acceptgiro?
	* Dan: Skip 10 regels:
	FOR tel = 1 TO 10
		oReport:PrintLine(@Rij,@Blad,' ')
	NEXT
ENDIF
	RETURN NIL
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
	IF selectionType==3 .or.selectionType==4.or.selectionType==5  && selection on regulator gifts to a destination
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
// local oSQL as SQLSelect
local cStatmnt as string 
if self:selx_MaxAmnt>0 .or. self:selx_MinAmnt>0
	ErrorBox{self:oWindow,"You can't combine total amount bounderies with change of mailing codes"}:Show()
	return false
endif
(SelPersChangeMailCodes{self}):Show() 
if !self:selx_Ok
	return false
endif
if !Empty(self:DelMailCds)
	// remove mail codes:
	cStatmnt:= "Replace(concat(mailingcodes,' '),'"+self:DelMailCds[1]+" ','')"	
	FOR j:=2 to Len(self:DelMailCds)
		cStatmnt:= "Replace("+cStatmnt+",'"+self:DelMailCds[j]+" ','')"
	next
endif
if !Empty(self:AddMailCds) 
	// add mail codes
	cStatmnt:="concat("+cStatmnt
	FOR j:=1 to Len(self:AddMailCds)
		cStatmnt+=",'"+self:AddMailCds[j]+" '"	
	next
	cStatmnt+=")"
endif
// oSQL:=SQLSelect{"select p.persid from "+cFrom+cWherep+" LOCK IN SHARE MODE",oConn}
// oSQL:Execute()

oStmnt:=SQLStatement{"update "+cFrom+" set p.mailingcodes="+cStatmnt+cWherep,oConn}
fSecStart:=Seconds()
oStmnt:Execute()  
if !Empty(oStmnt:Status)
	ErrorBox{self:oWindow,"Update failed:"+oStmnt:Status:Description}:Show()
	return false
else
	(InfoBox{self:oWindow,"Change of mailing codes",self:oLan:WGet('Mailcodes changed of')+Space(1)+Str(oStmnt:NumSuccessfulRows,-1)+Space(1) + self:oLan:WGet("Persons")}):Show()
endif	
	
RETURN TRUE	
METHOD ExportPersons(oParent,nType,cTitel,cVoorw) CLASS Selpers
	//LOCAL oExhlp AS ExportPerson
	LOCAL oMcd as PersCod
	LOCAL i,j,k, n as int
	LOCAL aMapping, aExpF:={}, aPerF as ARRAY
	LOCAL oSpecPers as SelPersExport
	LOCAL mCodH as USUAL, cCodOms, cCap as STRING
	LOCAL aStreet:={} as ARRAY
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
	local oSQL as SQLSelect 
	local oBnk as BankAcc
	local sField as symbol
	Local fSecStart as float 

	* Determine fields within ExportPersons:
	/*oExhlp := ExportPerson{"hx"}
	IF !oExhlp:Used
	RETURN FALSE
	ENDIF
	aExpF:= oExhlp:FieldDesc
	oExhlp:Close()
	(Filespec{"hx.dbf"}):Delete()
	oExhlp:=NULL_OBJECT    */
	SetPath(CurPath)
	SetDefault(CurPath)
	// AAdd(aExpF,1] := {#PERSONNR, "PERSONNR", persid{} }
	AAdd(aExpF,{#SALUTATN, "SALUTATN", Person_salutation{},"p.gender" })
	AAdd(aExpF,{#TITLE, "TITLE", ExportPerson_TITLE{} ,"p.title"})
	AAdd(aExpF,{#FIRSTNAM, "FIRSTNAM", ExportPerson_VRN{},"p.firstname" })
	AAdd(aExpF,{#INITIALS, "INITIALS", ExportPerson_NA2{} ,"p.initials"})
	AAdd(aExpF,{#MIDDLENM, "MIDDLENM", ExportPerson_Vrvgsl{} ,"p.prefix"})
	AAdd(aExpF,{#LASTNAME, "LASTNAME", ExportPerson_NA1{} ,"p.lastname"})
	AAdd(aExpF,{#NAMEEXT, "NAMEEXT", ExportPerson_NA3{} ,"p.nameext"})
	AAdd(aExpF,{#STREETHN, "STREET+HOUSENR", ExportPerson_AD1{} ,"p.address"})
	AAdd(aExpF,{#STREET, "STREET", ExportPerson_Street{} ,"p.address"})
	AAdd(aExpF,{#HOUSENBR, "HOUSENBR", ExportPerson_HOUSNBR{} ,"p.address"})
	AAdd(aExpF,{#ZIPCODE, "ZIPCODE", ExportPerson_POS{} ,"p.postalcode"})
	AAdd(aExpF,{#CITY, "CITY", ExportPerson_PLA{} ,"p.city"})
	AAdd(aExpF,{#ATTENTN, "ATTENTN", ExportPerson_TAV{} ,"p.attention"})
	AAdd(aExpF,{#COUNTRY, "COUNTRY", ExportPerson_LAN{} ,"p.country"})
	AAdd(aExpF,{#TELWORK, "TELWORK", ExportPerson_TEL1{} ,"p.telbusiness"})
	AAdd(aExpF,{#TELHOME, "TELHOME", ExportPerson_TEL2{} ,"p.telhome"})
	AAdd(aExpF,{#FAX, "FAX", ExportPerson_FAX{} ,"p.fax"})
	AAdd(aExpF,{#TELMOBIL, "TELMOBIL", ExportPerson_Mobile{} ,"p.mobile"})
	AAdd(aExpF,{#EMAIL, "EMAIL", ExportPerson_EMAIL{} ,"p.email"})
	AAdd(aExpF,{#BANKACNT, "BANKACNT", Bank{} ,""})
	AAdd(aExpF,{#CREATION, "CREATION", ExportPerson_BDAT{} ,"p.creationdate"})
	AAdd(aExpF,{#CHANGED, "CHANGED", ExportPerson_MUTD{} ,"p.alterdate"})
	AAdd(aExpF,{#LSTGIFT, "LSTGIFT", ExportPerson_DLG{} ,"p.datelastgift"})
	AAdd(aExpF,{#REMARKS, "REMARKS", ExportPerson_OPM{} ,"p.remarks"})
	AAdd(aExpF,{#MAILCODE, "MAILCODE", ExportPerson_MAILCODE{} ,"p.mailingcodes"})
	AAdd(aExpF,{#MAILABBR, "MAILABBR", ExportPerson_MAILABBR{} ,"p.mailingcodes"})
	AAdd(aExpF,{#TYPE, "TYPE", ExportPerson_TYPE{} ,"p.type"})
	AAdd(aExpF,{#GENDER, "GENDER", ExportPerson_GENDER{} ,"p.gender"})
	AAdd(aExpF,{#BIRTHDAT, "BIRTHDAT", ExportPerson_BIRTHDAT{} ,"p.birthdate"})
	AAdd(aExpF,{#persid, "persid", ExportPerson_CLN{} ,"p.persid"})
	IF self:selx_keus1=4.or.self:selx_keus1=5   && selectie op gift aan bestemming
		AAdd(aExpF,{#GIFTSGRP, "GIFTSGRP", Gifts_group{} ,""})
		AAdd(aExpF, {#TOTAMNT, "TOTAMNT", Total_Amount{} ,""}) 
		AAdd(aExpF, {#AmountGift, "AMOUNTGIFT", AmountGift{} ,""}) 
		AAdd(aExpF, {#DateGift, "DATEGIFT", DateGift{} ,"t.dat"}) 
		AAdd(aExpF, {#ReferenceGift, "REFERENCEGIFT", REFERENCE{},"t.reference" }) 
		AAdd(aExpF, {#DOCUMENTID, "DOCUMENTID", DOCID{},"t.docid" }) 
		AAdd(aExpF, {#Destination, "DESTINATION", Destination{} ,"a.description"}) 
	ENDIF
	// add extra properties:
	FOR i:=1 to Len(pers_propextra) step 1
		Name:=pers_propextra[i,1]
		ID := "V"+AllTrim(Str(pers_propextra[i,2],-1))
		myHyp:=HyperLabel{String2Symbol(ID),Name,Name}
		myField:=FieldSpec{myHyp,"C",10,0}
		AAdd(aExpF,{String2Symbol(ID),Name,myField,"p.propextr"})
	NEXT	

	oSpecPers := SelPersExport{self,{aExpF,cTitel}}
	oSpecPers:Show()
	IF Empty(self:myFields)
		RETURN FALSE
	ENDIF
	lPropXtr:=(AScan(self:myFields,{|x|x[4]="p.propextr"})>0)
	if AScan(self:myFields,{|x|x[1]== #BANKACNT})>0
		oBnk:=BankAcc{}
		if AScan(self:myFields,{|x|x[1]== #persid})=0   // persid needed to determine bank account
			cFields+=",p.persid"
		endif 
	endif 
	// determine group fields:
	cGrFields:=StrTran(StrTran(StrTran(StrTran(StrTran(cFields,"p.","gr."),"t.","gr."),"a.","gr."),"d.","gr."),"s.","gr.")
	IF (j:=AScan(self:myFields,{|x|x[1]== #GIFTSGRP}))>0
		oMarkGrp:=MarkupGiftsGroup{self}
		oMarkGrp:Show()
		IF Empty(self:GrpFormat)
			return false
		endif
		cGiftsLine:=self:GrpFormat
		IF AtC("%DESTINATION",cGiftsLine)>0
			lDestination:=true
			cFields+=",a.description"
		endif
		IF AtC("%DATEGIFT",cGiftsLine)>0
			lgrDat:=true
			cFields+=",t.dat"
		endif
		IF AtC("%REFERENCEGIFT",cGiftsLine)>0
			cFields+=",t.reference"
		endif
		IF AtC("%DOCUMENTID",cGiftsLine)>0
			cFields+=",t.docid"
		endif
		IF AtC("%AMOUNTGIFT",cGiftsLine)>0
			cFields+=",Round(t.CRE-t.DEB,2) as AmountGift"
		endif
		cGiftsLine:="CONCAT('"+StrTran(StrTran(StrTran(StrTran(StrTran(cGiftsLine,"%AMOUNTGIFT","',gr.AmountGift,'"),"%DATEGIFT","',date_format(gr.dat,'"+LocalDateFormat+"'),'"),"%DESTINATION","',gr.description,'"),"%REFERENCEGIFT","',gr.Reference,'"),"%DOCUMENTID","',gr.docid,'")+"')"
		cGiftsLine:=StrTran(StrTran(cGiftsLine,"'',",""),",''","")
		cGrFields+=",GROUP_CONCAT("+cGiftsLine+iif(lgrDat," order by gr.dat","")+" separator '') as "+self:myFields[j,3]:HyperLabel:Name 
		cGroup:=" group by gr.persid"
	endif
	IF (j:=AScan(self:myFields,{|x|x[1]== #TOTAMNT}))>0 .or. self:selx_MinAmnt>0 .or. self:selx_MaxAmnt>0 .or. self:selx_minindamnt>0
		cField:=",Round(t.CRE-t.DEB,2) as AmountGift"
		if AtC(cField,cFields)=0
			cFields+=cField
		endif
		if j>0 .or.self:selx_MinAmnt>0 .or. self:selx_MaxAmnt>0
			cGrFields+=",round(sum(gr.AmountGift),2) as TOTAMNT"
		endif
		if self:selx_minindamnt>0
			cGrFields+=",max(gr.AmountGift) as MAXAMNT" 
		endif
		cGroup:=" group by gr.persid"
		if self:selx_MinAmnt>0 .and. self:selx_MaxAmnt>0
			cHaving:=" having TOTAMNT between "+Str(self:selx_MinAmnt,-1)+" and "+Str(self:selx_MaxAmnt,-1) 
		elseif self:selx_MinAmnt>0
			cHaving:=" having TOTAMNT >= "+Str(self:selx_MinAmnt,-1)
		elseif self:selx_MinAmnt>0
			cHaving:=" having TOTAMNT <= "+Str(self:selx_MaxAmnt,-1)
		endif
		if self:selx_minindamnt>0
			cHaving+=iif(empty(cHaving)," having "," and ")+"MAXAMNT >= "+str(self:selx_minindamnt,-1)
		endif 
	endif
	IF (j:=AScan(self:myFields,{|x|x[1]== #AmountGift}))>0 
		cField:=",Round(t.CRE-t.DEB,2) as AmountGift"
		if AtC(cField,cFields)=0
			cFields+=cField
		endif
		cGrFields+=",gr.AmountGift"
	endif
	// determine fields to extract from the database
	for i:=1 to Len(self:myFields)
		cField:=self:myFields[i,4]
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
		lDistinct:=AScan(self:myFields,{|x|x[1]=#AmountGift.or.x[1]=#DateGift.or.x[1]=#ReferenceGift.or.x[1]=#DOCUMENTID.or.x[1]=#Destination})=0
		if !lDistinct
			if AtC("persid",self:SortOrder)=0
				self:SortOrder+=",persid"
			endif
		endif
	ELSE
		if AtC(",p.persid",cFields)=0
			cFields+=",p.persid"
		endif
		if AtC(self:SortOrder,cFields)=0
			cFields+=",p."+self:SortOrder
		endif
	endif
	cFields:=SubStr(cFields,2)
	cGrFields:=SubStr(cGrFields,2)
	lDestination:=(AtC("a.description",cFields)>0)


	IF lDestination
		if AtC("account",cFrom) =0
			cFrom+=",account as a"
		endif
		cWherep+=" and t.accid=a.accid"
	endif

	cSQLString:=UnionTrans("Select "+iif(lDistinct,"distinct ","")+cFields+" from "+ cFrom+cWherep)
	IF Empty(cGroup)
		oDB:SQLString:=cSQLString+" order by "+StrTran(self:SortOrder,"persid","p.persid")
	else
		oDB:SQLString:="select "+cGrFields+" from ("+cSQLString+") as gr "+cGroup+cHaving+" order by "+ self:SortOrder
	endif
	SQLStatement{"SET group_concat_max_len = 16834",oConn}:Execute()
	LogEvent(self,oDB:SQLString,'logsql')
	fSecStart:=Seconds()
	oDB:Execute() 
	LogEvent(self,"elapsed time for query:"+Str(Seconds()-fSecStart,-1),"LogSql")

	(InfoBox{self:oWindow,'Selection of Persons',AllTrim(Str(oDB:RECCOUNT)+ iif(lDistinct.or.!Empty(cGroup),' persons',' gifts')+' found')}):Show()
	IF oDB:RECCOUNT=0
		return false
	endif

	lAppend:=true
	ToFileFS:=AskFileName(oParent,cTitel+" "+DToS(Today())+"."+self:ExportFormat,"Export to file","*"+self:ExportFormat,iif(self:ExportFormat=="TXT","tab separated spreadsheet","comma separated file"),@lAppend)
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
		oSQL:=SQLSelect{"select ACCNUMBER from account where accid="+SDON,oConn}
		oSQL:Execute()
		if oSQL:RECCOUNT>0
			Donat:=AllTrim(oSQL:ACCNUMBER)
		endif
	endif
	* Determine mapping:
	aMapping := {}
	aExpF:=self:myFields
	for i = 1 to Len(aExpF)
		AAdd(aMapping, {aExpF[i,1],oDB:FieldPos(aExpF[i,3]:HyperLabel:NameSym) })
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
		cLine := aExpF[1,3]:HyperLabel:Caption
		for i = 2 to Len(aExpF)
			cLine:=cLine+cDelim+aExpF[i,3]:HyperLabel:Caption
		next
		FWriteLine(ptrHandle,cApo+cLine+cApo)
	else
		* position file at end:
		FSeek(ptrHandle, 0, FS_END)
	endif
	oDB:GoTop()
	do while !oDB:Eof
		cLine:=""
		if lPropXtr
			oXMLDoc:=XMLDocument{oDB:PROPEXTR}
		endif
		for j = 1 to Len(aMapping)
			IF j>1
				cLine:=cLine+cDelim
			endif
			IF aMapping[j,2]=0
				IF aMapping[j,1]==#MAILCODE
					* Compose mailing codes descriptions:
					* Determine mailcodes:
					cCodOms:=""
					IF .not.Empty(oDB:mailingcodes)
						for n:=1 to 28 step 3
							mCodH  := SubStr(oDB:mailingcodes,n,2)
							IF Empty(mCodH)
								exit
							else
								IF (k:=AScan(pers_codes,{|x|x[2]==mCodH}))>0
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
				ELSEIF aMapping[j,1]==#STREET
					* Determine streetname and housenbr
					cLine:=cLine+GetStreetHousnbr(oDB:address)[1]
				ELSEIF aMapping[j,1]==#HOUSENBR
					cLine:=cLine+GetStreetHousnbr(oDB:address)[2]
				ELSEIF aMapping[j,1]==#SALUTATN
					cLine:=cLine+Salutation(oDB:GENDER)
				ELSEIF aMapping[j,1]==#TITLE
					cLine:=cLine+Title(oDB:Title)
				ELSEIF aMapping[j,1]==#GENDER
					cLine:=cLine+GENDERDSCR(oDB:Gender)
				ELSEIF aMapping[j,1]==#TYPE
					cLine:=cLine+TYPEDSCR(oDB:TYPE)
				ELSEIF aMapping[j,1]==#BANKACNT
					cBank:=oBnk:BankAcc(oDB:persid) 
					if Empty(CBank) .and. CountryCode=="47" 
						// generate kidnbr
						cInvoice:=PadL(oDB:persid,6,"0")+PadL(Donat,6,"0")
						cLine:=cLine+cInvoice+Mod10(cInvoice)
					else
						cLine:=cLine+ CBank
					endif
				ELSEIF aMapping[j,1]==#MAILABBR
					* Compose mailing codes abbreviations:
					* Determine mailcodes:
					cCodOms:=""
					IF .not.Empty(oDB:mailingcodes)
						for n:=1 to 28 step 3
							mCodH  := SubStr(oDB:mailingcodes,n,2)
							IF Empty(mCodH)
								exit
							else
								IF (k:=AScan(mail_abrv,{|x|x[2]==mCodH}))>0
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
				else
					// extra properties:
					IF oXMLDoc:GetElement(Symbol2String(aMapping[j,1]))
						cLine+=oXMLDoc:GetContentCurrentElement()
					endif
				endif
			else
				IF aMapping[j,1]==#CITY
					cPlaats := AllTrim(oDB:city)
					IF CITYUPC
						cPlaats:=Upper(cPlaats)
						// 				else
						// 					cPlaats:=Upper(SubStr(cPlaats,1,1))+Lower(SubStr(cPlaats,2))
					endif
					cLine:=cLine+cPlaats 
				ELSEIF aMapping[j,1]==#LASTNAME
					lstnm:=AllTrim(oDB:lastname)
					IF LSTNUPC
						lstnm:=Upper(lstnm)
						// 				else
						// 					lstnm:=Upper(SubStr(lstnm,1,1))+Lower(SubStr(lstnm,2))
					endif
					cLine:=cLine+lstnm
				ELSEIF aMapping[j,1]==#GIFTSGRP
					cLine+=oDB:GiftsGroup
				else
					cLine:=cLine+ AllTrim(Transform(oDB:FIELDGET(aMapping[j,2]),""))
				endif
			endif
		next
		* Change CRLF to LF (otherwise extra rows:
		cLine:=StrTran(cLine,CRLF,LF)
		FWriteLine(ptrHandle,cApo+cLine+cApo)
		oDB:skip()
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

self:oDue := DueAmount{}
IF !oDue:Used
	self:EndWindow()
	RETURN
ENDIF
// oDue:SetOrder("OPENPOST")
oSub := Subscription{}
IF !oSub:Used
	SELF:EndWindow()
	RETURN
ENDIF
oSub:SetOrder("POL")
oAcc := Account{}
IF !oAcc:Used
	SELF:EndWindow()
	RETURN
ENDIF
oAcc:SetOrder("accid") 
// if oLan==null_object
// 	oLan:=Language{}
// endif
// IF !oLan:Used
// 	SELF:EndWindow()
// 	RETURN
// ENDIF
IF SELF:selx_keus1=4.or.SELF:selx_keus1=5   && selectie op gift aan bestemming
	self:oTransH := TransHistory{"select t.* from transaction as t where "+self:cWhereOther,oConn}
	IF !self:oTransH:Used
		SELF:EndWindow()
		RETURN
	ENDIF
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
		oRange:Max:=Len(aNN)
	ENDIF
ELSE
	oRange:=Range{1,Len(aNN)}
ENDIF
aantal:=oRange:max-oRange:Min+1
IF lAcceptNorway
	ind_openpost:=TRUE
ENDIF
FOR i=oRange:Min TO oRange:Max
	oDB:GoTo(i)
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
    	SELF:oPers:GetGiroNaw()
    	AcceptNorway(oReport,@Rij,@Blad,oLan,Val(self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%TOTALAMOUNT"})]),;
		self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEIDENTIFIER"})],self:oPers,;
    	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DESTINATION"})],self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%INVOICEID"})])
    ENDIF
NEXT
oReport:oRange:=Range{1,aantal} // set range for actual printing of generated pages
IF !oSub==NULL_OBJECT
	IF oSub:Used
		oSub:Close()
	ENDIF
	oSub:=NULL_OBJECT
ENDIF
IF !oAcc==NULL_OBJECT
	IF oAcc:Used
		oAcc:Close()
	ENDIF
	oAcc:=NULL_OBJECT
ENDIF

RETURN
METHOD FillText(Template as string,selectionType as int,DueRequired as logic,GiftsRequired as logic,AddressRequired as logic,RepeatingPossible as logic,brfWidth as int) as string CLASS Selpers
	* Filling of template with actual values from the database and returning of completed text
	LOCAL Content:=Template,Line,Asscln,repltxt as STRING
	LOCAL h2,h1,AddrPntr,i,j,tel as int
	LOCAL repeatTxt,repeatSection,repeatGroup as STRING
	LOCAL TotalAmnt:=0.00 AS FLOAT

	self:m_AdressLines:=MarkUpAddress(self:oDB,0,0,0)
	Asscln:=Str(self:oDB:persid,-1)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%SALUTATION"})]:=AllTrim(self:oDB:Salutation)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%TITLE"})]:=AllTrim(self:oDB:Title)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%INITIALS"})]:=AllTrim(self:oDB:initials)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%PREFIX"})]:=AllTrim(self:oDB:prefix)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%LASTNAME"})]:=AllTrim(self:oDB:lastname)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%FIRSTNAME"})]:=AllTrim(self:oDB:firstname)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%NAMEEXTENSION"})]:=AllTrim(self:oDB:nameext)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%ADDRESS"})]:=AllTrim(self:oDB:address)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%ZIPCODE"})]:=AllTrim(self:oDB:postalcode)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%CITYNAME"})]:=AllTrim(self:oDB:city)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%COUNTRY"})]:=AllTrim(self:oDB:country)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%ATTENTION"})]:=AllTrim(self:oDB:attention)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DATEGIFT"})]:=AllTrim(DToC(self:oDB:datelastgift))
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%BANKACCOUNT"})]:=AllTrim(self:oDB:banknumber)
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%REPORTMONTH"})]:=self:ReportMonth
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%PAGESKIP"})]:=PAGE_END

	/*IF selectionType=4.or.selectionType=5  && selectie op gift aan bestemming
	IF GiftsRequired
	oTransH:BeginCondition:=asscln
	oTransH:EndCondition:='persid=="'+asscln+'"'
	ENDIF
	ENDIF   */

	j:=AScan(self:m_fieldnames,{|x| x[1]=="%NAMEADDRESS"})
	IF j>0
		self:m_values[j]:=""
		FOR i=1 to Len(self:m_AdressLines)
			IF Empty(self:m_AdressLines[i])
				LOOP
			ELSE
				IF Empty(self:m_values[j])
					self:m_values[j]:=self:m_AdressLines[i]
				ELSE
					self:m_values[j]:=self:m_values[j]+CHR(13)+CHR(10)+self:m_AdressLines[i]
				ENDIF
			ENDIF
		NEXT
	ENDIF
	IF RepeatingPossible
		DO WHILE .t.
			repeatGroup:=''
			h1:=AtC("[",Content)
			IF Empty(h1)
				EXIT
			ENDIF
			h2:=AtC("]",SubStr(Content,h1+1))
			IF Empty(h2)
				EXIT
			ENDIF
			h2:=h1+h2
			repeatTxt:=SubStr(Content,h1+1,h2-h1-1)
			IF selectionType=4.or.selectionType=5  && selectie op gift aan bestemming
				* cWhereOther: string met selektiekonditie
				IF GiftsRequired
					oTransH:seek(asscln)
					DO WHILE !oTransH:EOF.and.oTransH:persid==Asscln 
						IF oTransH:Eval(pKond,,,1)  &&&oSelPers:cWhereOther
							IF Empty(self:cWhereOtherA).or.AScan(self:cWhereOtherA,oTransH:accid)>0
								self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DATEGIFT"})]:=AllTrim(DToC(oTransH:dat))
								self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%AMOUNTGIFT"})]:=AllTrim(Str(oTransH:cre-oTransH:deb,10,DecAantal))
								TotalAmnt+=oTransH:cre-oTransH:deb
								self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%TRANSID"})]:=AllTrim(oTransH:TransId)
								self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DOCID"})]:=AllTrim(oTransH:DOCID)
								oAcc:seek(oTransH:accid)
								self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DESTINATION"})]:=AllTrim(oAcc:Description)
								self:MarkUpDestination(oAcc:persid)
								repeatSection:=repeatTxt
								repeatSection:=StrTran(repeatSection,"%DATEGIFT",AllTrim(DToC(oTransH:dat)))
								repeatSection:=StrTran(repeatSection,"%AMOUNTGIFT",AllTrim(Str(oTransH:cre-oTransH:deb,10,DecAantal)))
								repeatSection:=StrTran(repeatSection,"%TRANSID",AllTrim(oTransH:TransId))
								repeatSection:=StrTran(repeatSection,"%DOCID",AllTrim(oTransH:DOCID))
								repeatSection:=StrTran(repeatSection,"%DESTINATION",oAcc:Description)
								repeatSection:=StrTran(repeatSection,"%FRSTNAMEDESTINATION",self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%FRSTNAMEDESTINATION"})])
								repeatSection:=StrTran(repeatSection,"%LSTNAMEDESTINATION",self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%LSTNAMEDESTINATION"})])
								repeatSection:=StrTran(repeatSection,"%SALUTDESTINATION",self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%SALUTDESTINATION"})])
								repeatSection:=StrTran(repeatSection,"%PAGESKIP",PAGE_ENd)
								repeatGroup := repeatGroup + repeatSection
							ENDIF
						ENDIF
						oTransH:skip()
					ENDDO
				ENDIF
			ELSEIF selectionType=2
				IF DueRequired
					oDue:seek(asscln)
					DO WHILE !oDue:EOF.and.oDue:persid=Asscln
						IF oDue:Eval(pKond,,,1) && &oSelfPers:cWhereOther
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%AMOUNTDUE"})]:=AllTrim(Str(oDue:AmountInvoice-oDue:AmountRecvd,10,DecAantal))
							TotalAmnt+=oDue:AmountInvoice-oDue:AmountRecvd
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEDATE"})]:=AllTrim(DToC(oDue:invoicedate))
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEIDENTIFIER"})]:=Mod11(self:oDB:persid+DToS(oDue:invoicedate)+StrZero(Val(oDue:seqnr),2))
							oAcc:seek(oDue:accid)
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DESTINATION"})]:=AllTrim(oAcc:Description)
							oSub:Seek(oDue:persid+oDue:accid)
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%INVOICEID"})]:=AllTrim(oSub:INVOICEID)
							repeatSection:=repeatTxt
							repeatSection:=StrTran(repeatSection,"%AMOUNTDUE",self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%AMOUNTDUE"})])
							repeatSection:=StrTran(repeatSection,"%DUEDATE",self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEDATE"})])
							repeatSection:=StrTran(repeatSection,"%DUEIDENTIFIER",self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEIDENTIFIER"})])
							repeatSection:=StrTran(repeatSection,"%DESTINATION",oAcc:Description)
							repeatSection:=StrTran(repeatSection,"%INVOICEID",AllTrim(oSub:INVOICEID))
							repeatSection:=StrTran(repeatSection,"%PAGESKIP",PAGE_ENd)
							repeatGroup := repeatGroup + repeatSection
						ENDIF
						oDue:skip()
					ENDDO
				ENDIF
			ENDIF
			Content:=Stuff(Content,h1,h2-h1+1,repeatGroup)
		ENDDO
	ELSE
		IF selectionType=2
			IF DueRequired
				oDue:seek( asscln)
				DO WHILE !oDue:EOF.and. oDue:persid==Asscln
					IF oDue:Eval(pKond,,,1) && &oSelPers:cWhereOther
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%AMOUNTDUE"})]:=AllTrim(Str(oDue:AmountInvoice-oDue:AmountRecvd,10,DecAantal))
						TotalAmnt+=oDue:AmountInvoice-oDue:AmountRecvd
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEDATE"})]:=AllTrim(DToC(oDue:invoicedate))
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEIDENTIFIER"})]:=Mod11(self:oDB:persid+DToS(oDue:invoicedate)+StrZero(Val(oDue:seqnr),2))
						oAcc:seek(oDue:accid)
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DESTINATION"})]:=AllTrim(oAcc:Description)
						oSub:Seek(oDue:persid+oDue:accid)
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%INVOICEID"})]:=AllTrim(oSub:INVOICEID)
					ENDIF
					oDue:skip()
				ENDDO
			ENDIF
		ENDIF
		IF selectionType=3   && selectie op periodiek betaling
			IF GiftsRequired
				oSub:seek( asscln)
				DO WHILE !oSub:Eof.and.oSub:personid==Asscln
					IF oSub:Eval(pKond,,,1) && &oSelPers:cWhereOther
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%AMOUNTDUE"})]:=AllTrim(Str(oSub:amount))
						TotalAmnt+=oSub:amount
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DUEDATE"})]:=AllTrim(DToC(oSub:duedate))
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DATEGIFT"})]:=AllTrim(DToC(oSub:duedate))
						self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%AMOUNTGIFT"})]:=AllTrim(Str(oSub:amount))
						*				oAcc:seek(oSub:accid)
						*				self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DESTINATION"})]:=AllTrim(oAcc:description)
						*				SELF:MarkUpDestination(oAcc:persid)
						EXIT
					ENDIF
					oSub:skip()
				ENDDO
			ENDIF
		ENDIF
		IF selectionType=4.or.selectionType=5   && selectie op gift aan bestemming
			* cWhereOther: string met selektiekonditie
			* selx_accid: gewenste bestemming
			IF GiftsRequired
				oTransH:seek( asscln)
				DO WHILE  !oTransH:EOF.and.oTransH:persid==Asscln
					IF oTransH:Eval(pKond,,,1) && &oSelPers:cWhereOther
						IF Empty(self:cWhereOtherA).or.AScan(self:cWhereOtherA,oTransH:accid)>0
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%DATEGIFT"})]:=AllTrim(DToC(oTransH:dat))
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%AMOUNTGIFT"})]:=AllTrim(Str(oTransH:cre-oTransH:deb,10,DecAantal))
							TotalAmnt+=oTransH:cre-oTransH:deb
							self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%TRANSID"})]:=AllTrim(oTransH:TransId)
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
	self:m_values[AScan(self:m_fieldnames,{|x| x[1]=="%TOTALAMOUNT"})]:=AllTrim(Str(TotalAmnt,10,DecAantal))

	FOR i=1 to Len(self:m_fieldnames)
		IF self:m_fieldnames[i,2]#"c"
			Content:=StrTran(Content,self:m_fieldnames[i,1],self:m_values[i])
		ENDIF
	NEXT
	IF AddressRequired
		* Compleet adres invullen:
		DO WHILE TRUE
			FOR tel = 1 to MLCount(Content,brfWidth)
				Line:=MemoLine(Content,brfWidth,tel)
				AddrPntr:=AtC("%NAMEADDRESS",Line)  && Zorgen voor inspringen
				IF AddrPntr>0
					repltxt:=StrTran(self:m_values[AScan(self:m_fieldnames,{|x| x[2]=="c"})],CHR(13)+CHR(10),CHR(13)+CHR(10)+Space(AddrPntr-1))
					Content:=StrTran(Content,"%NAMEADDRESS",repltxt,,1)
					EXIT
				ENDIF
			NEXT
			IF .not."%NAMEADDRESS" $ Content
				EXIT
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


	
METHOD PrintAccepts(oParent,nType,cTitel,oSelPers) CLASS Selpers
LOCAL i AS INT
LOCAL  ind_openpost,ind_gift,ind_naw,ind_herh AS LOGIC
LOCAL nRow as int
LOCAL nPage as int
LOCAL oAccFrm AS AcceptFormat
LOCAL lReady AS LOGIC
LOCAL oFromTo AS Range
LOCAL brfWidth:=79 AS INT
LOCAL Aantal:=0 AS INT
LOCAL cRemarks AS STRING
local oReport as PrintDialog
oFromTo:=Range{}
oDue := DueAmount{}
IF !oDue:Used
	SELF:EndWindow()
	RETURN
ENDIF
oDue:SetOrder("OPENPOST")
oSub := Subscription{}
IF !oSub:Used
	SELF:EndWindow()
	RETURN
ENDIF
oSub:SetOrder("POL")
oAcc := Account{}
IF !oAcc:Used
	SELF:EndWindow()
	RETURN
ENDIF
oAcc:SetOrder("accid")
oTrans := Transaction{}
IF !oTrans:Used
	SELF:EndWindow()
	RETURN
ENDIF
oTrans:setOrder("MUT")

	
DO WHILE !lReady
	oAccFrm := AcceptFormat{oParent}
	oAccFrm:Show()
	IF oAccFrm:lCancel
		RETURN FALSE
	ENDIF
	cRemarks:=oAccFrm:brief
	m12_bd := if(WycIniFS:GetInt( "Runtime", "AccAmount" )==1,TRUE,FALSE)
	oReport := PrintDialog{oParent,cTitel,,brfWidth}
	IF !Empty(oFromTo)
		oReport:InitRange(oFromTo)
	ENDIF
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	oFromTo := oReport:oRange
*	Vul evenveel brieven als maximumrange:
	IF !Empty(oFromTo)
		IF !Empty(oFromTo:Max)
			Aantal:=oFromTo:Max+1
		ELSE
			Aantal:=0
		ENDIF
	ELSE
		Aantal:=0
	ENDIF
	nRow:=0
	nPage:=0
	ind_openpost:=.f.
	ind_gift:=.f.
	ind_naw:=.f.
	ind_herh:=.f.
	self:AnalyseTxt(cRemarks,@ind_openpost,@ind_gift,@ind_naw,@ind_herh,self:selx_keus1,Val(self:selx_rek))
	IF m12_bd
		IF SELF:selx_keus1=2
			ind_openpost:=.t.
		ELSE
			ind_gift:=.t.
		ENDIF
	ENDIF
	FOR i=1 TO Len(aNN)
		oPers:GoTo(aNN[i,2])
		self:AcceptGiro(@nRow,@nPage,oReport,oAccFrm:brief,self,brfWidth, ;
		ind_openpost,ind_gift,ind_naw,ind_herh)
		IF !Empty(aantal) .and. nPage > aantal
			EXIT
		ENDIF
	NEXT
	oReport:prstart()
	lReady := oReport:oPrintJob:lLblFinish
	oReport:prstop()
ENDDO
oReport:prstart()
oReport:prstop()
oDue:Close()
oSub:Close()
oAcc:Close()
oTrans:Close()

RETURN TRUE
METHOD PrintLabels(oParent,nType,cTitel,cVoorw) CLASS Selpers

LOCAL oLblFrm AS LabelFormat
LOCAL lLabel := TRUE AS LOGIC
LOCAL lReady AS LOGIC
LOCAL oFromTo:=Range{1,1} as Range
local nMax as int
local oReport as PrintDialog
cFields:="p.persid, p.lastname,p.gender,p.title,p.attention,p.initials,p.nameext,p.prefix,p.firstname,p.address,p.postalcode,p.city,p.country"  	
	
oDB:SQLString:=UnionTrans("Select distinct "+cFields+" from "+ cFrom+cWherep+" order by "+self:SortOrder) 

oDB:Execute()
(InfoBox{self:oWindow,'Selection of Persons',AllTrim(Str(oDB:RECCOUNT)+ ' persons found')}):Show()
if oDB:RECCOUNT=0
	return false
endif
DO WHILE !lReady
	(oLblFrm := LabelFormat{oParent}):Show()
	IF oLblFrm:lCancel
		RETURN FALSE
	ENDIF
	oReport := PrintDialog{oParent,cTitel,lLabel}
	nMax:=Ceil(oDB:RECCOUNT/ (oReport:oPrintJob:nLblColCnt * oReport:oPrintJob:nLblVertical) )
	oFromTo:Max:=nMax
	IF !Empty(oFromTo)
		oReport:InitRange(oFromTo)
	ENDIF
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	oFromTo:Min := Min(oReport:oRange:Max+1,nMax)
	oDB:GoTop()
	oReport:CopyPers(oDB)
	oReport:prstart()
	lReady := oReport:oPrintJob:lLblFinish
	oReport:prstop()
ENDDO 

RETURN TRUE
METHOD PrintLetters(oParent,nType,cTitel,lAcceptNorway) CLASS Selpers

LOCAL oLtrFrm AS LetterFormat
LOCAL lReady AS LOGIC
LOCAL oFromTo:=Range{} as Range
LOCAL brfWidth AS INT
LOCAL oSys AS Sysparms
LOCAL nTo AS INT
local oReport as PrintDialog
Default(@lAcceptNorway,FALSE)
oSys:=SysParms{}
IF oSys:Used
	sPlaats:=oSys:CityLetter
	oSys:Close()
ENDIF
cFields:="p.persid, p.lastname,p.gender,p.title,p.attention,p.initials,p.nameext,p.prefix,p.firstname,p.address,p.postalcode,p.city,p.country,p.datelastgift"  	
	
oDB:SQLString:= UnionTrans("Select distinct "+cFields+" from "+ cFrom+cWherep+" order by "+self:SortOrder) 

oDB:Execute()
(InfoBox{self:oWindow,'Selection of Persons',AllTrim(Str(oDB:RECCOUNT)+ ' persons found')}):Show()
if !oDB:RECCOUNT=0
DO WHILE !lReady
	(oLtrFrm := LetterFormat{oParent,,,lAcceptNorway}):Show()
	IF oLtrFrm:lCancel
		RETURN FALSE
	ENDIF
	brfWidth := WycIniFS:GetInt( "Runtime", "brfWidth" )
	oReport := PrintDialog{oParent,cTitel,,brfWidth}
	oReport:InitRange(Range{nTo+1,oDB:RECCOUNT})
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	nTo:=oReport:oRange:Max
    self:FillLetters(oLtrFrm:brief,oReport:oRange,lAcceptNorway,oReport)
	oReport:prstart()
	lReady := oReport:oPrintJob:lLblFinish
	oReport:prstop()
	IF lReady
		IF oReport:oRange:Max<Len(aNN)
			lReady:=FALSE
		ENDIF
	ENDIF
ENDDO
endif
RETURN TRUE
METHOD PrintPersonList(oParent,nType,cTitel,cVoorw) CLASS Selpers
	LOCAL kopregels AS ARRAY
	LOCAL nRow as int
	LOCAL nPage as int
	LOCAL i as int
	Local fSecStart as float 
local oReport as PrintDialog
	

	if self:ReportAction=1
		cFields:="p.persid, p.lastname,p.gender,p.title,p.initials,p.prefix,p.firstname,p.address,p.postalcode,p.city,p.country,p.telbusiness,p.telhome,p.fax,p.mobile,p.remarks"  
	else
		cFields:="p.persid, p.lastname,p.gender,p.title,p.attention,p.initials,p.nameext,p.prefix,p.firstname,p.address,p.postalcode,p.city,p.country,p.telbusiness,p.telhome,p.fax,p.mobile,p.remarks,p.mailingcodes"  	
	endif
	
	self:oDB:SQLString:= UnionTrans("Select distinct "+cFields+" from "+ cFrom+cWherep+" order by "+self:SortOrder) 
	
	self:oDB:Execute()
	(InfoBox{self:oWindow,'Selection of Persons',AllTrim(Str(oDB:RECCOUNT)+ ' persons found')}):Show() 
	if self:oDB:RECCOUNT=0
		return false
	endif
  	oReport := PrintDialog{oParent,cTitel,,79}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	self:Pointer := Pointer{POINTERHOURGLASS}
	kopregels := {self:oDB:oLan:get('PERSONS',,"@!")}
	FOR i=1 to MLCount(cVoorw,79)
		AAdd(kopregels,MemoLine(cVoorw,79,i))
	NEXT
	AAdd(kopregels,' ')

	nRow := 0
	nPage := 0

	self:oDB:GoTop()
	fSecStart:=Seconds()
	do while !self:oDB:EOF
		// 	oPers:Goto(aNN[i,2])
		IF nType = 1
			self:oDB:NAW_Compact(@nRow,@nPage, kopregels,oReport)
		ELSE
			self:oDB:NAW_Extended(@nRow,@nPage, kopregels,oReport)
		ENDIF
		self:oDB:Skip()
	enddo
	LogEvent(self,"elapsed time for print:"+Str(Seconds()-fSecStart,-1),"LogSql")

	oReport:PrintLine(@nRow,@nPage,'',kopregels,1)
	oReport:PrintLine(@nRow,@nPage,Str(self:oDB:RECCOUNT,-1)+' '+self:oDB:oLan:get('Persons',,"!"),kopregels)
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
		CASE i=5
			IF CountryCode=="47"
				lSucc:=self:PrintLetters(oWindow,i,aTitle[i]+TitleExtra,true)
			ELSE
				lSucc:=self:PrintAccepts(oWindow,i,aTitle[i]+TitleExtra)
			ENDIF
		CASE i=6
			lSucc:=self:EXPORTPersons(oWindow,i,aTitle[i]+TitleExtra)
		CASE i=7
			lSucc:=self:ChangeMailCodes("")

	ENDCASE
// NEXT 
self:Pointer := Pointer{POINTERARROW}

return lSucc
METHOD Show() CLASS SelPers
// LOCAL kopregels AS ARRAY
// LOCAL nRow AS INT
// LOCAL nPage AS INT
LOCAL i as int, ind as int
LOCAL lSucc AS LOGIC
LOCAL CurCln  as STRING, CurTotal:=0 as FLOAT
LOCAL aPerson:={} AS ARRAY // array with personnbrs, TotalAamount
LOCAL aTitle := {'Compact Person report','Extended Person report','Labels',;
'Letters','Giro accepts','Export persons','Add/Remove Mailing Codes'}
LOCAL RekIdEnd as STRING
LOCAL aRekId as ARRAY // copy of KondA
Local oStmnt as SQLStatement 
// LOCAL oXMLDoc as XMLDocument, uFieldValue as usual, extrafound:=false as logic

self:selx_Ok:=true 
* bepaal gewenste selectie:
aNN := {}
IF cType=="REMINDERS".or.cType=="DONATIONS".or.cType=="SUBSCRIPTIONS"
	selx_keus1 := 2
ELSEIF cType=="STANDARD GIVERS"
	selx_keus1 := 3
ELSEIF cType=="MAILINGCODE"
	selx_keus1 := 1
ELSEIF cType=="THANKYOU"
	selx_keus1 := 4
ELSEIF cType=="FIRSTGIVERS"
	selx_keus1 := 1
ELSEIF cType=="FIRSTNONEAR"
	selx_keus1 := 1
ELSE
	(SelPersPrimary{oWindow,SELF}):Show()
ENDIF 

IF SELF:selx_ok
	IF selx_keus1 == 2
		(SelPersOpen{oWindow,{self,cType}}):Show()
		self:cFrom+=",dueamount as d,subscription as t"
		cWhereOther+=iif(Empty(cWhereOther),""," and ")+"p.persid=t.persid" 
	ELSEIF selx_keus1 == 3
		(SelPersGifts{oWindow,SELF}):Show()
		self:cFrom+=",subscription as t"
		cWhereOther+=iif(Empty(cWhereOther),""," and ")+"p.persid=t.personid" 
	ELSEIF selx_keus1 == 4
//		(SelPersPayments{oWindow,SELF}):Show()
		(SelPersPayments{oWindow,self}):Show()
		IF selx_MinAmnt>0.or.selx_MaxAmnt>0 // selection of minimum total amount:
			selx_keus1 := 5
		ENDIF
		self:cFrom+=",transaction as t"
		cWhereOther+=iif(Empty(cWhereOther),""," and ")+"p.persid=t.persid" 
	ENDIF
ELSE
	SELF:EndWindow()
	RETURN
ENDIF
IF self:selx_Ok
	(SelPersMailCd{oWindow,{SELF,cType}}):Show()
ELSE
	self:EndWindow()
	self:Close()
	RETURN
ENDIF
IF !Selx_OK
	SELF:EndWindow()
	RETURN
ENDIF
IF IsNil(cWhereOther)
	cWhereOther:=null_string
ENDIF
IF IsNil(self:cWherep)
	self:cWherep:=null_string
ENDIF
if !(Empty(self:cWherep).and.Empty(cWhereOther))
	if Empty(self:cWherep)
		self:cWherep:=" where "+cWhereOther
	else
		self:cWherep:=" where "+self:cWherep+iif(Empty(cWhereOther),""," and "+cWhereOther)
	endif
endif
self:cWherep+=" and p.persid>0"
IF !Empty(self:selx_AccStart) .and. !Empty(self:selx_AccStart) .and. !self:selx_AccStart==self:selx_Accend 
	// range of account numbers:
	self:cFrom+=",account as a"
	self:cWherep+=" and a.accid=t.accid and a.accnumber between '"+self:selx_AccStart+"' and '"+self:selx_Accend+"'"	
endif

self:oDB:=SQLSelectPerson{"",oConn}
SELF:oWindow:Pointer := Pointer{POINTERARROW}

oWindow:=GetParentWindow(SELF)

oWindow:Pointer := Pointer{POINTERHOURGLASS}
SELF:oWindow:StatusMessage("Producing reports, please wait...")

* Print the required report: 

lSucc:=self:PrintToOutput(oWindow,aTitle,"")
oWindow:Pointer := Pointer{POINTERARROW}

IF lSucc
	* remove eventually EG/EO-codes:
	IF SELF:lEG .or. SELF:lEO  // EG or EO selected?
		* Ask for removing codes:
		IF (TextBox{oWindow, "Printing of persons", "Has code for "+;
		IF(SELF:lEG,"First gift received","") +;
		IF(SELF:lEO,IF(SELF:lEG," and ","")+"First non-earm gift","")+" to be removed?",;
		BUTTONYESNO}):Show() == BOXREPLYYES
			* remove the codes:
			if self:lEG .and. self:lEO
				oStmnt :=SQLStatement{;
				"update person set mailingcodes=replace(replace(mailingcodes,'EG','FI'),'EO','FI') where instr(mailingcodes,'EG')>0 or instr(mailingcodes,'EO')>0)",oConn}
			elseif self:lEG
				oStmnt :=SQLStatement{;
				"update person set mailingcodes=replace(replace(mailingcodes,'EG','FI'),'FI FI','FI') where instr(mailingcodes,'EG')>0",oConn}
			else //EO
				oStmnt :=SQLStatement{;
				"update person set mailingcodes=replace(replace(mailingcodes,'EO','FI'),'FI FI','FI'), where instr(mailingcodes,'EO')>0",oConn}
			endif
			oStmnt:Execute()
			oStmnt:Commit()
		ENDIF
	ENDIF
ENDIF

RETURN
METHOD FillPerGifts CLASS SelPersGifts
local aAcc as  array 
aAcc:=FillAccount(self, "GiftAlwd")
AAdd(aAcc,{"<All>",""})	
Return aAcc
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
		cExtra+=iif(j==1,"("," or ")+"instr(p.PROPEXTR,'<"+aPropExValues[i,1]+">"+aPropExValues[i,3,j]+"</"+aPropExValues[i,1]+">')>0"      //<name> value </name>			
	next
	cExtra+=")"
next
oCaller:cWherep := if(Empty(oCaller:cWherep),"",;
oCaller:cWherep+" and ") + cExtra 

return 
METHOD InitExtraProperties() CLASS SelPersMailCd
	// Initialize extra properties
	LOCAL count AS INT
	LOCAL left:=1 AS USUAL, first:=TRUE AS LOGIC
	SELF:oDCExtraPropGroup:Hide()	

	FOR count:=1 TO Len(pers_propextra) STEP 1
		SELF:SetPropExtra(count,@left)
		IF first .and.!left=1
			SELF:oDCExtraPropGroup:show()
			first:=FALSE
		ENDIF
	NEXT
RETURN NIL
METHOD MakeAndCod() CLASS SelPersMailCd
* Compose mailingcodes from parts andCod1 .. anandCod
	LOCAL aCod := {}
	LOCAL i AS INT
	LOCAL cCod  AS STRING
	LOCAL cTekst AS STRING
	aCod:=self:oDCandCod:GetSelectedItems()

	IF !Empty(aCod)
		FOR i=1 TO Len(aCod)
			cCod := cCod +if(i=1,'(',' and ')+"instr(p.mailingcodes,'"+aCod[i]+"')>0"
			cTekst := cTekst +if(i=1,'(',' and ')+GetMailAbrv(aCod[i])
			IF "EG"==aCod[i]
				oCaller:lEG:=TRUE
			ENDIF
			IF "EO"==aCod[i]
				oCaller:lEO:=TRUE
			ENDIF
		NEXT
		oCaller:cWherep := if(Empty(oCaller:cWherep),"",;
		oCaller:cWherep+" and ") + cCod + ")"
		oCaller:selx_voorw := if(Empty(oCaller:selx_voorw),"",;
		oCaller:selx_voorw+" and ") + cTekst + ")"
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
			cCod := cCod +if(i=1,'(',' and ')+"instr(p.mailingcodes,'"+aCod3[i]+"')=0"
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
			cCod := cCod +if(i=1,'(',' or ')+"instr(p.mailingcodes,'"+aCod2[i]+"')>0"
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
		FOR i=1 to Len(aGender)
			cGender := cGender +Str(aGender[i],-1)+","
			cTekst := cTekst +if(i=1,'(',' or ')+pers_gender[AScan(pers_gender,{|x|x[2]==aGender[i]}),1]
		NEXT
		oCaller:cWherep := if(Empty(oCaller:cWherep),"",;
		oCaller:cWherep+" and ")+"instr('"+cGender+"',p.gender)"
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
		
		FOR i=1 TO Len(aType)
			cType += Str(aType[i],-1)+","
			cTekst += iif(i=1,'(',' or ')+pers_types[AScan(pers_types,{|x|x[2]==aType[i]}),1]
		NEXT
// 		oCaller:cWherep+" and ")+"(','+Str(Type,-1)+','$'" + cType + "')"
		oCaller:cWherep := iif(Empty(oCaller:cWherep),"",;
		oCaller:cWherep+" and ")+"instr('"+cType+"',p.type)"
		oCaller:selx_voorw := if(Empty(oCaller:selx_voorw),"",;
		oCaller:selx_voorw+" and ") + cTekst + ")"
	ENDIF
RETURN TRUE
METHOD SetPropExtra( Count, Left) CLASS SelPersMailCd
// LOCAL oCheck AS CheckBox
LOCAL oDropDown as Listbox
LOCAL oFix AS FixedText
// LOCAL oDCGroupBoxExtra	AS GroupBox
LOCAL Name AS STRING,Type, ID AS INT, Values AS STRING
LOCAL myDim AS Dimension
LOCAL myOrg AS Point
LOCAL aValues AS ARRAY
LOCAL EditX:=152, FixX:=17 as int, vertDist:=41 as int
Default(@Left,1)
Name:=pers_propextra[Count,1]
Type:=pers_propextra[Count,3]
Values:=pers_propextra[Count,4]
ID := pers_propextra[Count,2]
IF Type==TEXTBX
	RETURN NIL
ENDIF
IF Left==1
	//
	// enlarge window
	myDim:=SELF:Size
	myDim:Height+=vertDist
	SELF:Size:=myDim
	myOrg:=SELF:Origin
	myOrg:y-=vertDist
	SELF:Origin:=myOrg
	//
	// enlarge extra properties group:
	myDim:=SELF:oDCExtraPropGroup:Size
	myDim:Height+=vertDist
	SELF:oDCExtraPropGroup:Size:=myDim
	myOrg:=SELF:oDCExtraPropGroup:Origin
	myOrg:y-=vertDist
	SELF:oDCExtraPropGroup:Origin:=myOrg
ELSE
	EditX:=481
	FixX:=346
	myOrg:=SELF:oDCExtraPropGroup:Origin
ENDIF
	//
//	insert extra properties in group extra properties:	
IF Type==DROPDOWN .or. Type==CHECKBX
	oDropDown:=ListBox{self,Count,Point{EditX,myOrg:y+8},Dimension{185,40},LBS_SORT+LBS_MULTIPLESEL}
	oDropDown:HyperLabel := HyperLabel{String2Symbol("V"+AllTrim(Str(ID,-1))),Name,null_string,null_string}
	IF Type==DROPDOWN
		aValues:=Split(Values,",")
		oDropDown:FillUsing(aValues)
	else
		oDropDown:FillUsing({{"true","T"},{"false","F"}})
	endif
	AAdd(aPropEx,oDropDown)
	oDropDown:Show()
	oFix:=FixedText{self,Count,Point{FixX,myOrg:y+28}, Dimension{135,20},Name+":"}
	oFix:Show()
ENDIF
left:=-1*left

RETURN NIL
	
		
METHOD Abon_Con(dummy:=nil as logic) as array CLASS SelPersOpen
	LOCAL oAcc as SQLSelect
	LOCAL lSuccess AS LOGIC
	LOCAL aAcc := {} as array
	LOCAL cStatement as STRING

	cStatement:="select distinct concat(a.description,' ',a.accnumber) as accdescr, a.accid from account a,Subscription s "+;
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
Method MakeCliop03File(begin_due,end_due, process_date) CLASS SelPersOpen
	// make CLIEOP03 file for automatic collection for Dutch Banks
	LOCAL oDue as SQLSelect 
	local oPers as SQLSelect
	LOCAL ptrHandle
	LOCAL cFilename, cOrgName, cDescr,cTransnr,m56_Payahead,cType,cAccMlCd,cPersId,cAccID,cAmnt as STRING
	LOCAL fSum:=0,fAmnt as FLOAT, GrandTotal:=0 as float
	LOCAL lError as LOGIC
	LOCAL oReport as PrintDialog, headinglines as ARRAY , nRow, nPage,i, nSeq as int
	LOCAL cBank,cCod,cErrMsg,cAccType,cDueIds as STRING
	Local oWarn as TextBox
	Local aTrans:={} as array // persid,Dtos(invoicedate)+seqnr,accid,AmountInvoice, banknumber, Description 
	Local aDir as array
	local oPro as ProgressPer 
	local oSel as SQLSelect
	local oStmnt as SQLStatement

	if Empty(BANKNBRDEB)
		(ErrorBox{,"Bank account invoices/ direct debit not specified in system data"}):Show()
		return
	endif 
	if Len(BANKNBRDEB)=9 .and.!IsDutchBanknbr(BANKNBRDEB)
		(ErrorBox{,"Bank account number "+BANKNBRDEB+;
			" for Payments is not correct"}):Show()
		RETURN FALSE
	ENDIF
	IF Empty(sIDORG)
		(ErrorBox{self,"No own organisation specified in System Parameters"}):Show()
		RETURN
	ENDIF
	cOrgName:=GetFullName(sIDORG,2)
	if Empty(cOrgName)
		(ErrorBox{self,"No own organisation specified in System Parameters"}):Show()
		RETURN false
	ENDIF

	oSel:=SQLSelect{"select PAYAHEAD from BankAccount where banknumber='"+BANKNBRDEB+"' and telebankng=1",oConn}
	if oSel:RecCount<1
		(ErrorBox{,"Bank account number "+BANKNBRDEB+;
			" not specified as telebanking in system data"}):Show()
		RETURN FALSE
	else
		m56_Payahead:=Str(oSel:PAYAHEAD,-1)
		if Empty(m56_Payahead)
			(ErrorBox{,"For bank account number "+BANKNBRDEB+;
				" no account for Payments en route specified in system data"}):Show() 
			return false
		endif
	endif 
	
	// Check if all bankaccounts are valid, belonging to the direct debited person:   

	oDue:=SQLSelect{"select distinct s.bankaccnt,s.personid,"+SQLFullName(0,'ps')+" as fullname from dueamount d,subscription s "+;
		"left join person ps on (ps.persid=s.personid) "+;
		"where s.subscribid=d.subscribid "+;
		"and s.paymethod='C' and invoicedate between '"+SQLdate(begin_due)+;
		"' and '"+SQLdate(end_due)+"' and d.AmountRecvd<d.AmountInvoice and "+;
		"s.bankaccnt not in (select p.banknumber from personbank p where p.persid=s.personid)",oConn}
	if oDue:RecCount>0
		cErrMsg:=self:oLan:WGet("The following direct debit bank accounts don't belong to corresponding person")+":"
		do while !oDue:EoF
			cErrMsg+=CRLF+PadR(oDue:BANKACCNT,20)+space(1)+alltrim(oDue:fullname)+"(intern ID "+str(oDue:personid,-1)+")"
			oDue:skip()
		enddo
		ErrorBox{self,cErrMsg}:Show()
		return false
	endif
	

	oDue:=SQLSelect{"select d.dueid,s.personid,s.accid,d.AmountInvoice,d.invoicedate,d.seqnr,s.term,s.BANKACCNT,a.accnumber,a.clc,b.category as acctype,"+SQLAccType()+" as type,"+;
		"p.datelastgift,"+SQLFullName(0,'p')+" as personname "+;
		" from account a left join member m on (a.accid=m.accid),balanceitem b,person p, DueAmount d,Subscription s "+;
		"where s.subscribid=d.subscribid and s.paymethod='C' and b.balitemid=a.balitemid "+;
		"and invoicedate between '"+SQLdate(begin_due)+;
		"' and '"+SQLdate(end_due)+"' and AmountRecvd<AmountInvoice and p.persid=s.personid and a.accid=s.accid order by personname",oConn}
	IF oDue:RecCount<1
		(WarningBox{self,"Producing CLIEOP03 file","No due amounts to be debited direct!"}):Show()
		RETURN false
	ENDIF

	headinglines:={self:oLan:Get("Overview of generated automatic collection (CLIEOP03)"),self:oLan:Get("Name",41)+self:oLan:Get("Bankaccount",11)+self:oLan:Get("Amount",12,,"R")+" "+self:oLan:Get("Destination",12)+self:oLan:Get("Due Date",11)+" "+self:oLan:Get("Description",20),Replicate('-',120)}
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
	oReport := PrintDialog{self,"Producing of CLIEOP03"+DToS(Today())+Str(nSeq,-1)+" file",,120}
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
		if Len(cBank)=9
			if !IsDutchBanknbr(cBank)
				(ErrorBox{self,"Bankaccount "+cBank+" of person "+oDue:PersonName+"(Intern ID "+Str(oDue:personid,-1)+") is not correct!"}):Show()
				FClose(ptrHandle)
				(FileSpec{cFilename}):DELETE()
				FErase(cFilename)
				self:Pointer := Pointer{POINTERARROW}
				return false
			endif				
		endif
		cBank:=PadL(cBank,10,"0")
		// Transaction record:
		FWriteLine(ptrHandle,"0100A1001"+StrZero(oDue:AmountInvoice*100,12,0)+cBank + PadL(BANKNBRDEB,10,"0")+Space(9))
		GrandTotal:=Round(GrandTotal+Val(BANKNBRDEB)+Val(cBank),0)
		// Payment pattern record:
		FWriteLine(ptrHandle,"0150A"+PadR(Mod11(StrZero(oDue:personid,5,0)+DToS(oDue:invoicedate)+Str(oDue:seqnr,-1)),16)+Space(29))	              
		// determine description from Subscription:
		IF Empty(oDue:term) .or.oDue:term>1000
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
	ArrayProtect(aTrans) 
	self:Pointer := Pointer{POINTERARROW}
	oWarn:=TextBox{self,"Direct Debit",;
		'Printing O.K.? Can shown '+Str(Len(aTrans),-1)+' transactions('+sCurrName+Str(fSum,-1)+') be imported into telebanking?',BOXICONQUESTIONMARK + BUTTONYESNO}
	IF (oWarn:Show() = BOXREPLYNO)
		// remove file:
		(FileSpec{cFilename}):DELETE()
	else 
		oPro:=ProgressPer{,self}
		oPro:Caption:=self:oLan:WGet("Recording direct debit transactions")
		oPro:SetRange(1,Len(aTrans)+2)
		oPro:SetUnit(1)
		oPro:Show() 
		self:oCCCancelButton:Disable()
		self:oCCOKButton:Disable()

		self:Owner:STATUSMESSAGE("Producing cliop03 file, moment please") 
		self:Pointer := Pointer{POINTERHOURGLASS}

		// make transactions:
		oStmnt:=SQLStatement{"start transaction",oConn}
		oStmnt:Execute()
		if !Empty(oStmnt:status)
			lError:=true
		endif
		if !lError
			// Reconcile Due Amounts:
			ArrayDeProtect(aTrans)
			oStmnt:=SQLStatement{"update dueamount set amountrecvd=AmountInvoice where dueid in ("+Implode(aTrans,",",,,8)+")",oConn}
			oStmnt:Execute()
			oPro:AdvancePro()
			ArrayProtect(aTrans)
			if !Empty(oStmnt:status)
				lError:=true
			else
				for i:=1 to Len(aTrans) 
					oPro:AdvancePro()
					// make transaction:
					* add transaction:
					* against DebitAccount: 
					cAccID:=Str(aTrans[i,1],-1)
					cPersId:=Str(aTrans[i,2],-1)
					fAmnt:=float(_cast,aTrans[i,3])
					cDescr:=Transform(aTrans[i,4],"") 
					cAmnt:=Str(fAmnt,-1)
					cType:=Transform(aTrans[i,5],"")
					cAccMlCd:=Transform(aTrans[i,6],"") 
					cAccType:=aTrans[1,7]
					oStmnt:=SQLStatement{"insert into transaction set "+;
						"DAT='"+SQLdate(process_date)+"'"+;
						",DOCID='COL'"+;
						",description ='"+cDescr +"'"+;
						",accid ='"+m56_Payahead+"'"+;
						",deb ='"+cAmnt+"'"+;
						",debforgn ='"+cAmnt+"'"+;
						",seqnr=1,poststatus=2"+;
						",USERID ='"+LOGON_EMP_ID+"',currency='"+sCurr+"'",oConn}
					oStmnt:Execute()
					if oStmnt:NumSuccessfulRows<1
						LogEvent(,"error:"+oStmnt:status:description+CRLF+"stmnt:"+oStmnt:SQLString,"LogSQL")
						lError:=true
						exit
					endif
					if !ChgBalance(m56_Payahead,process_date,fAmnt,0,fAmnt,0,sCURR)
						lError:=true
						exit
					endif
					cTransnr:=SQLSelect{"select LAST_INSERT_ID()",oConn}:FIELDGET(1)
					// record credit on destination account:
					oStmnt:=SQLStatement{"insert into transaction set "+;
						"TransId='"+cTransnr+"'"+;
						",DAT='"+SQLdate(process_date)+"'"+;
						",DOCID='COL'"+;
						",description ='"+cDescr +"'"+;
						",accid ='"+cAccID+"'"+;
						",persid='"+cPersId+"'"+;
						",cre ='"+cAmnt+"'"+;
						",creforgn ='"+cAmnt+"'"+;
						",seqnr=2,poststatus=2"+;
						",USERID ='"+LOGON_EMP_ID+"',currency='"+sCurr+"'"+iif(cType=='M',",GC='AG'",""),oConn}
					oStmnt:Execute()
					if oStmnt:NumSuccessfulRows<1
						LogEvent(,"error:"+oStmnt:status:description+CRLF+"stmnt:"+oStmnt:SQLString,"LogSQL")
						lError:=true
						exit
					endif
					if !ChgBalance(cAccID,process_date,0,fAmnt,0,fAmnt,sCURR)  //accid,Cre
						lError:=true
						exit
					ENDIF
					nSeq:=2
					if !AddToIncome(iif(cType=='M','AG',""),false,cAccID,fAmnt,0.00,0.00,fAmnt,sCurr,cDescr,cAccType,;
							cPersId,process_date,'COL',cTransnr,@nSeq)
						lError:=true
						exit
					endif
					IF !Empty(cType) 
						*  Update person info of giver: 
						if cType == 'G' .or. cType == 'M' .or. cType == 'D'
							oPers:=SQLSelect{"select mailingcodes,datelastgift from person where persid="+ cPersId,oConn} 
							if oPers:RecCount>0
								cCod:=oPers:mailingcodes
								PersonGiftdata(cType,@cCod,oPers:datelastgift,iif(cType=='M','AG',""),,,cAccMlCd)
								&& Update date last gift:
								IF oPers:datelastgift < process_date .or. !AllTrim(cCod)==oPers:mailingcodes 
									SQLStatement{"update person set datelastgift='"+SQLdate(process_date)+"',mailingcodes='"+cCod+"' where persid="+cPersId,oConn}:Execute()
								ENDIF
							endif
						endif
					endif
				next
			endif 
		endif
		oPro:EndDialog()
		oPro:Close() 
		if lError
			SQLStatement{"rollback",oConn}:Execute()
			self:Pointer := Pointer{POINTERARROW}
			LogEvent(self,self:oLan:WGet("could not record direct debit transaction"),"LogErrors")
			ErrorBox{self,self:oLan:WGet("could not record direct debit transaction")}:Show()
			RETURN false
		else
			SQLStatement{"commit",oConn}:Execute()
		endif
		self:oCCCancelButton:Enable()
		self:oCCOKButton:Enable()

		self:Pointer := Pointer{POINTERARROW}
		(InfoBox{self,"Producing CLIEOP03 file","File "+cFilename+" generated with "+Str(Len(aTrans),-1)+" amounts"}):Show()
		LogEvent(self, "CLIEOP03 file "+cFilename+" generated with "+Str(Len(aTrans),-1)+" direct debits")

	endif
	RETURN true
METHOD MakeKIDFile(begin_due,end_due, process_date) CLASS SelPersOpen
	// make KID file for automatic collection for Norwegian Banks
	LOCAL cFilter AS STRING
	LOCAL oDue AS DueAmount, oPers AS Person, oSub AS Subscription
	LOCAL ptrHandle
	LOCAL cFilename AS STRING
	LOCAL nSeq, nLine AS INT, fSum:=0 AS FLOAT
	LOCAL DueDateFirst, DueDateLast AS DATE
	LOCAL Success AS LOGIC
	LOCAL oReport as PrintDialog, headinglines as ARRAY , nRow, nPage as int
	LOCAL oLan AS Language
	LOCAL cSession AS STRING

	cFilter:=	'paymethod="C".and.dtos(invoicedate)>="'+DToS(begin_due)+;
	'".and.dtos(invoicedate)<="'+DToS(end_due)+;
	'".and.AmountRecvd<AmountInvoice'
	cSession:=Str(Year(Today()),4,0)+StrZero((Today()-SToD(Str(Year(Today()),4,0)+"0101"))+1,3)
    oDue:=DueAmount{,DBSHARED,DBREADONLY}
    IF !oDue:Used
    	RETURN
    ENDIF
	oDue:SetOrder("OPENDAT")
	Success:=oDue:SetFilter(cFilter)
	oDue:GoTop()
	IF !oDue:EoF
	   * Datafile aanmaken:
		cFileName := CurPath + "\a-girowycliffe"+StrZero(Day(Today()),2)+StrZero(Month(Today()),2)+SubStr(StrZero(Year(Today()),4),1,4)+'.txt'
		ptrHandle := MakeFile(SELF,cFilename,"Creating KID-file")
		IF ptrHandle = F_ERROR .or. ptrHandle==NIL
			RETURN
		ENDIF
	ELSE
		(WarningBox{SELF,"Producing KID file","No due amounts to be auto collected!"}):Show()
		RETURN
	ENDIF
	oReport := PrintDialog{self,"Producing of KID file",,70}
	oReport:Show()
	IF .not.oReport:lPrintOk
		RETURN FALSE
	ENDIF
	oSub:=SubScription{,DBSHARED,DBREADONLY}
	IF !oSub:Used
		RETURN
	ENDIF
	oSub:SetFilter({||oSub:PAYMETHOD=="C"},"PAYMETHOD=='C'")
	oSub:SetOrder("POL")
	oPers:=Person{,DBSHARED,DBREADONLY}
	IF !oPers:Used
		RETURN
	ENDIF
	oPers:SetOrder("ASSRE")
	oLan:=Language{}
	headinglines:={oLan:Get("Overview of generated automatic collection (KID)"),oLan:Get("Session:")+cSession,oLan:Get("Name",41)+oLan:Get("Amount",12,,"R")+" "+oLan:Get("KID",13),Replicate('-',67)}
	// write Header
	FWriteLine(ptrHandle,"NY000010"+PadL(AllTrim((Sysparms{,DBSHARED,DBREADONLY}):CNTRNRCOLL),8,"0")+padl(cSession,7,"0")+PadR("0000808",57,"0"))
	FWriteLine(ptrHandle,"NY210020000000000"+PadL(cSession,7,"0")+PadL(BANKNBRDEB,11,"0")+Replicate("0",45))
	nLine:=2
	DueDateFirst:=oDue:invoicedate
	DueDateLast:=oDue:invoicedate
	DO WHILE !oDue:EoF
		IF oSub:Seek(oDue:persid+oDue:accid)
			IF oPers:Seek(oDue:persid)
				nSeq++
				FWriteLine(ptrHandle,"NY210230"+StrZero(nSeq,7,0)+StrZero(Day(oDue:invoicedate),2,0)+StrZero(Month(oDue:invoicedate),2,0)+SubStr(StrZero(Year(oDue:invoicedate),4,0),3,2)+;
				Space(11)+StrZero(oDue:AmountInvoice*100,17,0)+Space(12)+PadR(AllTrim(oSub:INVOICEID),19,"0"))
				FWriteLine(ptrHandle,"NY210231"+StrZero(nSeq,7,0)+PadR(oPers:lastname,60)+"00000")
				nLine+=2
				fSum+=oDue:AmountInvoice
				IF DueDateFirst>oDue:invoicedate
					DueDateFirst:=oDue:invoicedate
				ENDIF
				IF DueDateLast<oDue:invoicedate
					DueDateLast:=oDue:invoicedate
				ENDIF
				oReport:PrintLine(@nRow,@nPage,;
				Pad(oPers:GetFullName(),40)+" "+Str(oDue:AmountInvoice,12,2)+' '+Pad(oSub:INVOICEID,13),headinglines)

			ENDIF
		ENDIF		
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
	oDue:Close()
	oSub:Close()
	oPers:Close()
	oLan:Close()
	oDue:=NULL_OBJECT
	oSub:=NULL_OBJECT
	oPers:=NULL_OBJECT
	oLan:=NULL_OBJECT
	oReport:PrintLine(@nRow,@nPage,Replicate('-',67),headinglines,3)
	oReport:PrintLine(@nRow,@nPage,Space(41)+Str(Round(fSum,2),12,2),headinglines)
	oReport:prstart()
	oReport:prstop()
	(InfoBox{SELF,"Producing KID file","File "+cFilename+" generated with "+Str(nSeq,-1)+" amounts"}):Show()
RETURN
METHOD RegAccount(oAcc as Account,ItemName as string) as logic CLASS SelPersPayments
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
		SELF:oDCFixedText7:Show()
		SELF:oDCSubSet:Show()
		SELF:oDCSubSet:AccNbrStart:=SELF:mRekSt
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
Function SQLFullNAC(Purpose:=1 as int,country:="" as string,alias:="" as string) as string 
// composition of SQL code for getting full name and address of a person
// Purpose: see SQLFullName
// country: default country (optional)
LOCAL f_row:="",mAlias as STRING
mAlias:=iif(Empty(ALIAS),"",alias+".")

f_row:=SQLFullName(Purpose,ALIAS)

f_row:=SubStr(f_row,1,Len(f_row)-2)+;   // eliminate ) for trim and concat
',", ",'+"if("+mAlias+'address<>"" and address<>"X",concat('+mAlias+'address," "),""),'+;
"if("+mAlias+'postalcode<>"" and postalcode<>"X",concat('+mAlias+'postalcode," "),""),'+;
"if("+mAlias+'city<>"" and city<>"X" and city<>"??",concat('+mAlias+'city," "),""),country'+;
"))"  // add  )) for trim and concat
RETURN AllTrim(f_row)
Function SQLFullName(Purpose:=0 as int,alias:="" as string) as string 
// composition of SQL code for getting full name of a person
// Purpose: optional indicator that the name is used for:
// 	0: addresslist: with surname "," firstname prefix (without salutation) 
//		1: fullname conform address specification
//		2: name for identification: lastname, firstname prefix 
//		3: like 1 but always with firstname 
LOCAL frstnm,fullname, title,prefix,mAlias as STRING 
local i as int
mAlias:=iif(Empty(ALIAS),"",alias+".")

IF sSalutation .and.(Purpose==1.or.Purpose==3) 
	title:="case "
	for i:=1 to 3
		 title+=" when "+mAlias+"gender="+Str(pers_salut[i,2],-1)+" then '"+pers_salut[i,1]+"'" 
	next
	title+="ELSE '' END"
ENDIF
IF titelINADR.and.!Empty(pers_titles) .and.(Purpose==1.or.Purpose==3)
	if !Empty(Title) 
		title := "concat(("+title+"),"
	endif	
	title+="(case"
	for i:=1 to Len(pers_titles)
		title+=" when "+mAlias+"title="+Str(pers_titles[i,2],-1)+" then '"+pers_gender[i,1]+"'" 
	next
	title+=" END)"+iif(sSalutation .and.(Purpose==1.or.Purpose==3),")","")
ENDIF
prefix :="if("+mAlias+'prefix<>"",concat('+mAlias+'prefix," "),"")'
fullname := mAlias+"lastname"
IF sFirstNmInAdr .or. (Purpose==2.or.Purpose==3)
	frstnm := 'if('+mAlias+'firstname<>"",concat('+mAlias+'firstname," "),if('+mAlias+'initials<>"",concat('+mAlias+'initials," "),""))'
ELSE
	frstnm := 'if('+mAlias+'initials<>"",concat('+mAlias+'initials," "),"")'
ENDIF
do CASE
CASE Purpose==0
	//addresslist:
	fullname:='concat('+fullname+','+iif(sSurnameFirst,'" "','", "')+','+frstnm+','+prefix+')'
CASE Purpose==1.or.Purpose==3
	// address conform address specifications:
	IF sSurnameFirst
   	fullname := 'concat('+fullname+'," ",'+title+'," ",'+frstnm+',' + prefix +')'
	else
		fullname:='concat('+title+'," ",'+frstnm+','+prefix+','+fullname+')'
	ENDIF	
CASE Purpose==2
	// identification:
	fullname:='trim(concat('+fullname+','+iif(sSurnameFirst,'" "','", "')+','+frstnm+','+prefix+'))'
endcase
return fullname
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
METHOD GetFullNAW(PersNbr,country,Purpose) CLASS SQLSelectPerson
* Samenstellen van te tonen NAW
* country: default country (optional)
LOCAL f_regel:="" as STRING
// LOCAL nCurRec as int
Default(@country,null_string)
Default(@PersNbr,nil)
Default(@Purpose,1)

IF !self:Used
	RETURN null_string
ENDIF 
// nCurRec:=self:RecNo
IF !IsNil(PersNbr) .and.!PersNbr==self:FIELDGET(#persid)
	IF IsString(PersNbr)
		IF Empty(PersNbr)
			RETURN ""
		ENDIF
		self:seek(#persid,PersNbr)
	ENDIF
ENDIF
f_regel:=self:GetFullName(,Purpose)


/*f_regel:=SELF:Salutation
IF .not. Empty(f_regel)
   f_regel+=' '
ENDIF
IF sFirstNmInAdr .and..not.Empty(SELF:firstname)
   f_regel+=AllTrim(SELF:firstname)+' '
ELSEIF .not. Empty(SELF:initials)  && anders voorletters gebruiken
   f_regel+=AllTrim(SELF:initials)+' '
ENDIF
IF .not. Empty(SELF:prefix)
   f_regel+=AllTrim(SELF:prefix)+' '
ENDIF
IF .not. Empty(SELF:lastname)
   f_regel+=AllTrim(SELF:lastname)
ENDIF    */
f_regel:=f_regel+', '
IF .not.Empty(self:FIELDGET(#address))
   f_regel+=AllTrim(self:FIELDGET(#address))+" "
ENDIF
IF .not.Empty(self:FIELDGET(#postalcode))
   f_regel+=Trim(self:FIELDGET(#postalcode))+" "
ENDIF
IF .not.Empty(self:FIELDGET(#city))
   f_regel+=Trim(self:FIELDGET(#city))+" "
ENDIF
IF .not.Empty(self:FIELDGET(#country) )
   f_regel+=Trim(self:FIELDGET(#country) )
ELSEIF .not.Empty(country)
   f_regel+=country
ENDIF
// if !IsNil(PersNbr) .and.!nCurRec==self:RecNo
// 	self:Goto(nCurRec)
// endif
RETURN AllTrim(f_regel)
Method Init(cSQLSelect, oSQLConnection) class SQLSelectPerson
	super:Init(cSQLSelect, oSQLConnection)
	self:oLan:=Language{}
	if oLan:Used
		cCouple:= oLan:Rget("Mr&Mrs")
		cMr:= oLan:get("Mr",,"!")
		cMrs:= oLan:get("Mrs",,"!")
		cTel:=oLan:get("Telephone",,"!")
		cDay:=oLan:Rget('at day')
		cNight:=oLan:Rget("at night")
		cAbrv:=oLan:Rget("Abbreviated mailingcodes")
		cFax:=oLan:Rget("fax")
		cMobile:=oLan:Rget("mobile")

	endif
	return self 

	
METHOD NAW_Compact(nRow, nPage ,Heading, oReport) CLASS SQLSelectPerson
* Kompakte NAW-lijst
* self: server
* oReport: Printjob
LOCAL ht, hu as STRING, mopm as STRING

/*ht := AllTrim(SELF:lastname)+', '+AllTrim(SELF:Salutation)+' '+AllTrim(SELF:initials)+' '+AllTrim(SELF:prefix)
IF .not.Empty(SELF:address)
   ht := ht+' '+AllTrim(SELF:address)
ENDIF
*IF .not.Empty(SELF:postalcode).and.Empty(SELF:country)
IF .not.Empty(SELF:postalcode)
   ht := ht+' '+AllTrim(SELF:postalcode)
ENDIF
IF .not.Empty(SELF:city)
   ht := ht+' '+AllTrim(SELF:city)
ENDIF
IF .not.Empty(SELF:country)
   ht := ht+' '+AllTrim(SELF:country)
ENDIF */  
ht:=self:GetFullNAW()
hu := Space(6)
IF .not.Empty(self:FIELDGET(#telbusiness) )
    hu  :=  hu+if(Empty(self:FIELDGET(#telhome)),"",self:cDay+": ");
	+self:FIELDGET(#telbusiness)
ENDIF
IF .not.Empty(self:FIELDGET(#telhome) )
    hu  :=  hu+if(Empty(hu),"",", "+self:cNight+": ");
	+self:FIELDGET(#telhome)
ENDIF
IF .not.Empty(self:FIELDGET(#fax))
    hu  :=  hu+" "+self:cFax+":"+self:FIELDGET(#fax)
ENDIF
IF .not.Empty(self:FIELDGET(#Mobile) )
    hu  :=  hu+" "+self:cMobile+":"+self:FIELDGET(#Mobile)
ENDIF
IF .not.Empty(self:FIELDGET(#firstname))
   hu  :=  Pad(hu,59)+Trim(self:FIELDGET(#firstname))
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
*FOR i=1 TO 4
*   mopm := MemoLine(SELF:remarks,73,i)
*   IF .not.Empty(mopm)
*      oReport:PrintLine(@nRow,@nPage,Space(6) + AllTrim(mopm),Heading)
*   ENDIF
*NEXT
RETURN nil
METHOD NAW_Extended(nRow, nPage ,Heading, oReport) CLASS SQLSelectPerson
	* Uitgebreide personenlijst
	LOCAL roud,i,n, nWidth, nInspr as int,inspring, regel, mopm, cCodOms, cCodAbr as STRING
	LOCAL m_AdressLines as ARRAY
	LOCAL mCodH as USUAL

	inspring := Str(self:persid,-1)+' '
	nWidth:=79-(nInspr:=Len(inspring))
	m_AdressLines := MarkUpAddress(self,0,nWidth,0)
	oReport:PrintLine(@nRow,@nPage,,Heading,6)
	FOR i = 1 to 6
		regel := m_AdressLines[i]
		IF .not. Empty(regel)
			oReport:PrintLine(@nRow,@nPage,inspring + AllTrim(regel),Heading)
			inspring:=Space(nInspr)
		ENDIF
		IF i=1 .and. .not.Empty(self:firstname) .and. !sFirstNmInAdr
			oReport:PrintLine(@nRow,@nPage,inspring + self:firstname,Heading)
			inspring:=Space(nInspr)
		ENDIF
	NEXT
	IF .not.Empty(self:telbusiness).or.!Empty(self:telhome)
		oReport:PrintLine(@nRow,@nPage,inspring + self:cTel+" - "+;
			self:cDay+":"+self:telbusiness+" - "+self:cNight+":"+self:telhome,Heading)
	ENDIF
	IF .not.Empty(self:mobile).or.!Empty(self:fax)
		oReport:PrintLine(@nRow,@nPage,inspring +;
			self:cFax+":"+self:fax+" - "+self:cMobile+":"+self:mobile,Heading)
	ENDIF
	IF .not.Empty(self:mailingcodes)
		FOR i:=1 to 28 step 3
			mCodH  := SubStr(self:mailingcodes,i,2)
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
		mopm:=MemoLine(self:remarks,nWidth,i)
		IF .not.Empty(mopm)
			oReport:PrintLine(@nRow,@nPage,inspring + AllTrim(mopm),Heading)
		ENDIF
	NEXT
	roud:=nRow
	oReport:PrintLine(@nRow,@nPage,,Heading)
	IF nRow=roud
		oReport:PrintLine(@nRow,@nPage,' ',Heading)
	ENDIF

	RETURN nil
ACCESS  Salutation  CLASS SQLSelectPerson
	// Return salutation of a person: 
	local iG:= int(_cast,self:FIELDGET(#GENDER)) as int
	if Empty(iG).or.iG>5 .or.iG<0
		iG:=5
	endif
	return pers_salut[iG,1]  

Function StandardZip(ZipCode:="" as string) as string 
	* Standardise Ducth Zip-code format: 9999 XX 
	if Empty(ZipCode)
		return null_string
	endif
	ZipCode:=Upper(AllTrim(ZipCode))
	IF Len(ZipCode)==6
		IF isnum(SubStr(ZipCode,1,4)) .and. !isnum(SubStr(ZipCode,5,2))
			RETURN SubStr(ZipCode,1,4)+" "+SubStr(ZipCode,5,2)
		ENDIF
	ENDIF
RETURN ZipCode
Function Title(nTit as int) as string 
	// Return Title of a person:
	LOCAL nPtr as int
	if nTit>0
		nPtr:=AScan(pers_titles,{|x|x[2]==nTit})
		if nPtr >0 
			return pers_titles[nPtr,1]
		endif
	endif
	return null_string
Function TYPEDSCR(nTp as int) as string
	// Return Gender description of a person:
	RETURN pers_types[AScan(pers_types,{|x|x[2]==nTp}),1]
