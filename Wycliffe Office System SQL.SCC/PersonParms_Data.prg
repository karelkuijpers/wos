Define IDM_PERSCOD_NAME := "Perscod"
Define IDM_Perscod_USERID := "parous…ºw@™Ðw"
Define IDM_PERSON_PROPERTIES_NAME := "Person_Properties"
Define IDM_Person_Properties_USERID := "parous…ºw@™Ðw"
Define IDM_PERSONTYPE_NAME := "PersonType"
Define IDM_PersonType_USERID := "parous…ºw@™Ðw"
Define IDM_TITLES_NAME := "Titles"
Define IDM_Titles_USERID := "parous…ºw@™Ðw"
CLASS Perscod_ABBRVTN INHERIT FIELDSPEC
METHOD Init() CLASS Perscod_ABBRVTN
super:Init(HyperLabel{"ABBRVTN","Abbrvtn","","perscod_ABBRVTN"},"C",3,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Perscod_OMS INHERIT FIELDSPEC
METHOD Init() CLASS Perscod_OMS
super:Init(HyperLabel{"description","description","","perscod_OMS"},"C",20,0)

RETURN SELF
CLASS Perscod_PERS_CODE INHERIT FIELDSPEC
METHOD Init() CLASS Perscod_PERS_CODE
super:Init(HyperLabel{"PERS_CODE","Pers Code","","perscod_PERS_CODE"},"C",2,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Person_Properties_ID INHERIT FIELDSPEC
METHOD Init() CLASS Person_Properties_ID
super:Init(HyperLabel{"ID","Id","","person_properties_ID"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Person_Properties_NAME INHERIT FIELDSPEC
METHOD Init() CLASS Person_Properties_NAME
super:Init(HyperLabel{"NAME","Name","","person_properties_NAME"},"C",30,0)

RETURN SELF
CLASS Person_Properties_TYPE INHERIT FIELDSPEC
METHOD Init() CLASS Person_Properties_TYPE
super:Init(HyperLabel{"TYPE","Type","","person_properties_TYPE"},"N",11,0)

RETURN SELF
CLASS Person_Properties_VALUES INHERIT FIELDSPEC
METHOD Init() CLASS Person_Properties_VALUES
super:Init(HyperLabel{"VALUES","Values","","person_properties_VALUES"},"M",10,0)

RETURN SELF
CLASS PersonType_ABBRVTN INHERIT FIELDSPEC
METHOD Init() CLASS PersonType_ABBRVTN
super:Init(HyperLabel{"ABBRVTN","Abbrvtn","","persontype_ABBRVTN"},"C",3,0)

RETURN SELF
CLASS PersonType_DESCRPTN INHERIT FIELDSPEC
METHOD Init() CLASS PersonType_DESCRPTN
super:Init(HyperLabel{"DESCRPTN","Descrptn","","persontype_DESCRPTN"},"C",30,0)

RETURN SELF
CLASS PersonType_ID INHERIT FIELDSPEC
METHOD Init() CLASS PersonType_ID
super:Init(HyperLabel{"ID","Id","","persontype_ID"},"N",6,0)

RETURN SELF
CLASS Titles_DESCRPTN INHERIT FIELDSPEC
METHOD Init() CLASS Titles_DESCRPTN
super:Init(HyperLabel{"DESCRPTN","Descrptn","","titles_DESCRPTN"},"C",12,0)

RETURN SELF
CLASS Titles_ID INHERIT FIELDSPEC
METHOD Init() CLASS Titles_ID
super:Init(HyperLabel{"ID","Id","","titles_ID"},"N",6,0)
self:SetRequired(.T.,)

RETURN SELF
