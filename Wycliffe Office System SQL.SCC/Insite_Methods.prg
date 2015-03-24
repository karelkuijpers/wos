Class Insite
Protect 	oHttp	as cHttp 
export 	cUser			as STRING
export cPw			as STRING
protect LoggedIn as logic
declare method GetAccountChangeReport
Method Close() Class Insite 
	LOCAL cPage			as STRING
	// Logout
	cPage := oHttp:GetDocumentByGetOrPost( "wwwsso.insitehome.org", ;
		"/pls/orasso/ORASSO.wwsso_app_admin.ls_logout?p_done_url=https://www.insitehome.org/pls/apex/f?p=119:1",;
		/*cPostData*/,;
		/*cHeader*/,;
		"GET",;
		INTERNET_DEFAULT_HTTPS_PORT,;
		INTERNET_FLAG_SECURE)

	oHttp:CloseRemote()
	oHttp:Axit()
	
Method GetAccountChangeReport(datelstafl as date) as string Class Insite
	***************************************
	// Download account change report from Insite
	// Returns report as string
	**************************************
	Local p_instance:="517997907262231" as string
	local p_page_submission_id:="8267409146939138" as string
	LOCAL cPage			as STRING
	LOCAL cPostData	as STRING
	LOCAL nPosA			as DWORD
	LOCAL nPosE			as DWORD
	LOCAL cVar2			as STRING
	LOCAL cVar1			as STRING
	LOCAL cUser			as STRING
	LOCAL cPw			as STRING 
	local lSuccess as logic
	Local aMon := {'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'} as ARRAY 

   //cUser			:= "karel_kuijpers"
   //cPw			:= "Wyccavo100"
   cPostData	:= ""
   

if self:LoggedIn .and. IsDate(datelstafl) 
	// get report
	if Empty(datelstafl)
		datelstafl:=Today()-40
	endif 
	cPostData := "p_flow_id=102&"+;
					 "p_flow_step_id=1270&"+;
					 "p_instance="+p_instance+"&"+;
					 "p_page_submission_id="+p_page_submission_id+"&"+;
					 "p_request=RUN&"+;
					 "p_arg_names=7816507099480901&"+;
					 "p_t01=&"+;
					 "p_t02="+StrZero(Day(datelstafl),2)+"-"+aMon[Month(datelstafl)]+"-"+Str(Year(datelstafl),4,0)+"&"+;
					 "p_t03="+StrZero(Day(Today()),2)+"-"+aMon[Month(Today())]+"-"+Str(Year(Today()),4,0)+"&"+;
					 "p_arg_names=&"+;
					 "p_t04=1&"+;
					 "p_md5_checksum="
	cPage := oHttp:GetDocumentByGetOrPost( "www.insitehome.org", ;
			"/pls/apex/wwv_flow.accept",;
			cPostData,;
			/*cHeader*/,;
			"POST",;
			INTERNET_DEFAULT_HTTPS_PORT,;
			INTERNET_FLAG_SECURE)
		
	IF At("Redirecting to the Login Server for authentication", cPage) > 0 
		// now to autorization server page:
		nPosA := At('site2pstoretoken"', cPage)
		nPosA := At3('VALUE="', cPage, nPosA) + 7
		nPosE := At3('">', cPage, nPosA)
		cVar1	:= SubStr(cPage, nPosA, nPosE - nPosA)
		cPostData := "site2pstoretoken=" + cVar1 
		cPage := oHttp:GetDocumentByGetOrPost( "wwwsso.insitehome.org", ;
			"/pls/orasso/orasso.wwsso_app_admin.ls_login?" + cPostData,;
			/*cPostData*/,;
			/*cHeader*/,;
			"GET",;
			INTERNET_DEFAULT_HTTPS_PORT,;
			INTERNET_FLAG_SECURE)
	ENDIF

	cPage := oHttp:GetDocumentByGetOrPost( "www.insitehome.org", ;
		"/pls/apex/f?p=102:1270:"+p_instance+":FLOW_EXCEL_OUTPUT_R26061909913567836_en-us",;
		/*cPostData*/,;
		/*cHeader*/,;
		"GET",;
		INTERNET_DEFAULT_HTTPS_PORT,;
		INTERNET_FLAG_SECURE)

ENDIF

RETURN cPage
Method Init() class Insite 
	oHttp	:= CHttp{"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)"} 
	self:Login()
return self
	
Method Login() as logic class Insite
	LOCAL cPage 		as string
	LOCAL cPostData	as STRING
	LOCAL nPosA			as DWORD
	LOCAL nPosE			as DWORD
	LOCAL cVar1,cVar2	as STRING
	local oEmp 			as SQLSelect
	local oAskUidPw as LoginInsite 
	local lAskedUID as logic 
	local UIDCrypt, cKey as string 
	local i as int
	Local cRoot := "WYC\Runtime", cMapping, cError as String
	
	oEmp:=SQLSelect{"select * from Employee where empid="+MYEMPID,oConn}
	IF oEmp:Reccount>0
		cUser:=Crypt(oEmp:INSITEUID,"98hGPB\|jaq^$V| urrRE"+oEmp:EMPID+" oy r#!7ksdltroFGYOW" ) 
		if cUser==Crypt(Space(40),"98hGPB\|jaq^$V| urrRE"+oEmp:EMPID+" oy r#!7ksdltroFGYOW" )     // ignore empty UID
			cUser:="" 
		else
			cUser:=AllTrim(cUser)
		endif
		cMapping:= QueryRTRegString( cRoot, "P"+oEmp:EMPID)
		if Empty(cMapping)
			cPw:=""
		else
			cPw:=AllTrim(Crypt(cMapping,"brxmrotexRUEIHG768&^_|;FJKIOhfqv)"+oEmp:EMPID))
		endif
	else
		return false
	endif 
	// get login-form
	cPage	:= oHttp:GetDocumentByGetOrPost( "www.insitehome.org",;
		 "",;  
		 "",;
		 /*cHeader*/,;
		 "GET",;
		 INTERNET_DEFAULT_HTTPS_PORT,;
		 INTERNET_FLAG_SECURE)
	// send logindata
	nPosA := At3('name="v"', cPage, 0)
	nPosA := At3('value="', cPage, nPosA) + 7
	nPosE := At3('">', cPage, nPosA) 
	if nPosE == 0 .or. nPosE<=nPosA
		return false
	endif
	cVar2	:= SubStr(cPage, nPosA, nPosE - nPosA)
	
	nPosA := At3('name="site2pstoretoken"', cPage, 0)
	nPosA := At3('value="', cPage, nPosA) + 7
	nPosE := At3('">', cPage, nPosA)
	cVar1	:= SubStr(cPage, nPosA, nPosE - nPosA)
	
	for i:=1 to 5 
		if Empty(cUser) .or. Empty(cPw)
			// ask for Insite Uid&Pwd
			lAskedUID:=true 
			if (LoginInsite{,{self,cUser,cError}}):Show()==0
				return false
			endif
		endif

		cPostData := "v=" + cVar2 + "&site2pstoretoken=" + cVar1+;
		"&locale=&submit_url=/sso/auth&locale=&ssousername=" + cUser +;
		"&password=" + cPw  +;
		"&Login=Login&p_request=Cancel"	

		cPage	:= oHttp:GetDocumentByGetOrPost( "wwwsso.insitehome.org",;
		 "/pls/orasso/orasso.wwsso_app_admin.ls_login",;  
		 cPostData,;
		 /*cHeader*/,;
		 "POST",;
		 INTERNET_DEFAULT_HTTPS_PORT,;
		 INTERNET_FLAG_SECURE)
		IF At("Redirecting to the Login Server for authentication", cPage) > 0
			self:LoggedIn:=true 
			if lAskedUID
				// save UID/PWD in Employee:
				cKey:="98hGPB\|jaq^$V| urrRE"+oEmp:EMPID+" oy r#!7ksdltroFGYOW"
				oEmp:INSITEUID:=Crypt(Pad(cUser,40),cKey )
				// save password into registry: 
				cKey:="brxmrotexRUEIHG768&^_|;FJKIOhfqv)"+oEmp:EMPID
				SetRTRegString(cRoot,"P"+oEmp:EMPID, Crypt(cPw,cKey)) 
			endif
			exit
		else
			cError:= "Something wrong with login" 
			if (nPosA:=At('class="error"',cPage))>0
				if (nPosA:=At3(">",cPage,nPosA+12))>0
					if (nPosE:=At3("<",cPage,nPosA+10))>0
						cError:= SubStr(cPage, nPosA+1, nPosE - nPosA-1) 
						cError:=StrTran(cError,'&nbsp;','')
					endif
				endif
			else
				LogEvent(self,cPage)
			endif
		endif
		self:cPw:=""
	next
		
	return true
RESOURCE LoginInsite DIALOGEX  105, 119, 283, 105
STYLE	DS_3DLOOK|DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU
CAPTION	"                                                       Insite Login"
FONT	10, "Microsoft Sans Serif"
BEGIN
	CONTROL	"Enter your Insite user name and password to login. Passwords are case-sensitive. ", LOGININSITE_FIXEDTEXT1, "Static", WS_CHILD, 7, 5, 281, 10
	CONTROL	"Insite User Name", LOGININSITE_FIXEDTEXT2, "Static", WS_CHILD, 45, 42, 67, 10
	CONTROL	"Password", LOGININSITE_FIXEDTEXT3, "Static", WS_CHILD, 45, 60, 40, 10
	CONTROL	"", LOGININSITE_INSITEUSERID, "Edit", ES_AUTOHSCROLL|WS_TABSTOP|WS_CHILD|WS_BORDER, 117, 42, 100, 10, WS_EX_CLIENTEDGE
	CONTROL	"", LOGININSITE_INSITEPASSWORD, "Edit", ES_AUTOHSCROLL|ES_PASSWORD|WS_TABSTOP|WS_CHILD|WS_BORDER, 117, 60, 100, 10, WS_EX_CLIENTEDGE
	CONTROL	"Login", LOGININSITE_LOGIN, "Button", WS_TABSTOP|WS_CHILD, 118, 80, 28, 11
	CONTROL	"Fixed Text", LOGININSITE_ERRORTEXT, "Static", SS_CENTER|WS_CHILD|NOT WS_VISIBLE, 18, 21, 250, 10
END

CLASS LoginInsite INHERIT DialogWinDowExtra 

	PROTECT oDCFixedText1 AS FIXEDTEXT
	PROTECT oDCFixedText2 AS FIXEDTEXT
	PROTECT oDCFixedText3 AS FIXEDTEXT
	PROTECT oDCInsiteUserId AS SINGLELINEEDIT
	PROTECT oDCInsitePassword AS SINGLELINEEDIT
	PROTECT oCCLogin AS PUSHBUTTON
	PROTECT oDCErrorText AS FIXEDTEXT

  //{{%UC%}} USER CODE STARTS HERE (do NOT remove this line) 
  protect oCaller as Object 
  protect returnVal:=0 as int
method Close(oEvent) class LoginInsite
	super:Close(oEvent)
	//Put your changes here
	return NIL
METHOD Init(oParent,uExtra) CLASS LoginInsite 
LOCAL DIM aFonts[2] AS OBJECT

self:PreInit(oParent,uExtra)

SUPER:Init(oParent,ResourceID{"LoginInsite",_GetInst()},TRUE)

aFonts[1] := Font{,11,"Microsoft Sans Serif"}
aFonts[2] := Font{,11,"Microsoft Sans Serif"}
aFonts[2]:Bold := TRUE

oDCFixedText1 := FixedText{SELF,ResourceID{LOGININSITE_FIXEDTEXT1,_GetInst()}}
oDCFixedText1:HyperLabel := HyperLabel{#FixedText1,"Enter your Insite user name and password to login. Passwords are case-sensitive. ",NULL_STRING,NULL_STRING}
oDCFixedText1:Font(aFonts[1], FALSE)
oDCFixedText1:TextColor := Color{COLORBLUE}

oDCFixedText2 := FixedText{SELF,ResourceID{LOGININSITE_FIXEDTEXT2,_GetInst()}}
oDCFixedText2:HyperLabel := HyperLabel{#FixedText2,"Insite User Name",NULL_STRING,NULL_STRING}
oDCFixedText2:Font(aFonts[2], FALSE)
oDCFixedText2:TextColor := Color{COLORBLUE}

oDCFixedText3 := FixedText{SELF,ResourceID{LOGININSITE_FIXEDTEXT3,_GetInst()}}
oDCFixedText3:HyperLabel := HyperLabel{#FixedText3,"Password",NULL_STRING,NULL_STRING}
oDCFixedText3:TextColor := Color{COLORBLUE}
oDCFixedText3:Font(aFonts[2], FALSE)

oDCInsiteUserId := SingleLineEdit{SELF,ResourceID{LOGININSITE_INSITEUSERID,_GetInst()}}
oDCInsiteUserId:HyperLabel := HyperLabel{#InsiteUserId,NULL_STRING,NULL_STRING,"User name to logon into Insite"}
oDCInsiteUserId:UseHLforToolTip := True
oDCInsiteUserId:FieldSpec := Employee_InsiteUID{}
oDCInsiteUserId:FocusSelect := FSEL_HOME

oDCInsitePassword := SingleLineEdit{SELF,ResourceID{LOGININSITE_INSITEPASSWORD,_GetInst()}}
oDCInsitePassword:HyperLabel := HyperLabel{#InsitePassword,NULL_STRING,NULL_STRING,"Password to logon into Insite"}
oDCInsitePassword:UseHLforToolTip := True
oDCInsitePassword:FocusSelect := FSEL_HOME
oDCInsitePassword:FieldSpec := Employee_InsittePW{}
oDCInsitePassword:Picture := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

oCCLogin := PushButton{SELF,ResourceID{LOGININSITE_LOGIN,_GetInst()}}
oCCLogin:HyperLabel := HyperLabel{#Login,"Login",NULL_STRING,NULL_STRING}

oDCErrorText := FixedText{SELF,ResourceID{LOGININSITE_ERRORTEXT,_GetInst()}}
oDCErrorText:HyperLabel := HyperLabel{#ErrorText,"Fixed Text",NULL_STRING,NULL_STRING}
oDCErrorText:TextColor := Color{COLORRED}

SELF:Caption := "                                                       Insite Login"
SELF:HyperLabel := HyperLabel{#LoginInsite,"                                                       Insite Login","Ask for userid and password for Insite",NULL_STRING}

self:PostInit(oParent,uExtra)

return self

METHOD Login( ) CLASS LoginInsite 
	if Empty(self:oDCInsiteUserId:VALUE)
		(ErrorBox{self,"Enter your user name"}):show()
		return nil
	endif
	if Empty(self:oDCInsitePassword:VALUE)
		(ErrorBox{self,"Enter your password"}):show()
		return nil
	endif
	if Len(AllTrim( self:oDCInsitePassword:VALUE))<10
		(ErrorBox{self,"Wrong password"}):show()
		return nil
	endif
	self:oCaller:cUser:=AllTrim(	self:oDCInsiteUserId:VALUE)
	self:oCaller:cPw:=AllTrim(self:oDCInsitePassword:VALUE)
	self:returnVal:=1
	self:EndDialog(1)
RETURN nil
method PostInit(oParent,uExtra) class LoginInsite
	//Put your PostInit additions here 
	self:SetTexts()
	self:oCaller:=uExtra[1]
	self:oDCInsiteUserId:Value:=uExtra[2]
	if Len(uExtra)>2
		if !Empty(uExtra[3])
			self:oDCErrorText:TextValue:=AllTrim(uExtra[3])
			self:oDCErrorText:Show()
		else
			self:oDCErrorText:Hide()
		endif
	else
		self:oDCErrorText:Hide()
	endif
	return NIL
STATIC DEFINE LOGININSITE_ERRORTEXT := 106 
STATIC DEFINE LOGININSITE_FIXEDTEXT1 := 100 
STATIC DEFINE LOGININSITE_FIXEDTEXT2 := 101 
STATIC DEFINE LOGININSITE_FIXEDTEXT3 := 102 
STATIC DEFINE LOGININSITE_INSITEPASSWORD := 104 
STATIC DEFINE LOGININSITE_INSITEUSERID := 103 
STATIC DEFINE LOGININSITE_LOGIN := 105 
