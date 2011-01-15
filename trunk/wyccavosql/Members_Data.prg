CLASS DistributionInstruction_AMNTSND INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_AMNTSND
super:Init(HyperLabel{"AMNTSND","Amntsnd","","distributioninstruction_AMNTSND"},"N",12,2)

RETURN SELF
CLASS DistributionInstruction_CHECKSAVE INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_CHECKSAVE
super:Init(HyperLabel{"CHECKSAVE","Checksave","","distributioninstruction_CHECKSAVE"},"C",1,0)

RETURN SELF
CLASS DistributionInstruction_CURRENCY INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_CURRENCY
super:Init(HyperLabel{"CURRENCY","Currency","","distributioninstruction_CURRENCY"},"N",3,0)

RETURN SELF
CLASS DistributionInstruction_DESCRPTN INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DESCRPTN
super:Init(HyperLabel{"DESCRPTN","Descrptn","","distributioninstruction_DESCRPTN"},"C",70,0)

RETURN SELF
CLASS DistributionInstruction_DESTACC INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DESTACC
super:Init(HyperLabel{"DESTACC","Destacc","","distributioninstruction_DESTACC"},"C",70,0)

RETURN SELF
CLASS DistributionInstruction_DESTAMT INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DESTAMT
super:Init(HyperLabel{"DESTAMT","Destamt","","distributioninstruction_DESTAMT"},"N",12,2)

RETURN SELF
CLASS DistributionInstruction_DESTPP INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DESTPP
super:Init(HyperLabel{"DESTPP","Destpp","","distributioninstruction_DESTPP"},"C",3,0)

RETURN SELF
CLASS DistributionInstruction_DESTTYP INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DESTTYP
super:Init(HyperLabel{"DESTTYP","Desttyp","","distributioninstruction_DESTTYP"},"N",11,0)

RETURN SELF
CLASS DistributionInstruction_DFIA INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DFIA
super:Init(HyperLabel{"DFIA","Dfia","","distributioninstruction_DFIA"},"C",17,0)

RETURN SELF
CLASS DistributionInstruction_DFIR INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DFIR
super:Init(HyperLabel{"DFIR","Dfir","","distributioninstruction_DFIR"},"C",9,0)

RETURN SELF
CLASS DistributionInstruction_DISABLED INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_DISABLED
super:Init(HyperLabel{"DISABLED","Disabled","","distributioninstruction_DISABLED"},"N",3,0)

RETURN SELF
CLASS DistributionInstruction_LSTDATE INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_LSTDATE
super:Init(HyperLabel{"LSTDATE","Lstdate","","distributioninstruction_LSTDATE"},"D",10,0)

RETURN SELF
CLASS DistributionInstruction_REK INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_REK
super:Init(HyperLabel{"accid","accid","","distributioninstruction_REK"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS DistributionInstruction_SEQNBR INHERIT FIELDSPEC
METHOD Init() CLASS DistributionInstruction_SEQNBR
super:Init(HyperLabel{"SEQNBR","Seqnbr","","distributioninstruction_SEQNBR"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
Define IDM_DISTRIBUTIONINSTRUCTION_NAME := "DistributionInstruction"
Define IDM_DistributionInstruction_USERID := "parouÿ…ºw@™Ðw"
Define IDM_MEMBERS_NAME := "Members"
Define IDM_Members_USERID := "parous…ºw@™Ðw"
CLASS Members_AOW INHERIT FIELDSPEC
METHOD Init() CLASS Members_AOW
super:Init(HyperLabel{"AOW","Aow","","member_AOW"},"N",8,2)

RETURN SELF
CLASS Members_CLN INHERIT FIELDSPEC
METHOD Init() CLASS Members_CLN
super:Init(HyperLabel{"persid","persid","","member_CLN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Members_CO INHERIT FIELDSPEC
METHOD Init() CLASS Members_CO
super:Init(HyperLabel{"CO","Co","","member_CO"},"C",1,0)

RETURN SELF
CLASS Members_CONTACT INHERIT FIELDSPEC
METHOD Init() CLASS Members_CONTACT
super:Init(HyperLabel{"CONTACT","Contact","","member_CONTACT"},"N",11,0)

RETURN SELF
CLASS Members_GRADE INHERIT FIELDSPEC
METHOD Init() CLASS Members_GRADE
super:Init(HyperLabel{"GRADE","Grade","","member_GRADE"},"C",6,0)

RETURN SELF
CLASS Members_HAS INHERIT FIELDSPEC
METHOD Init() CLASS Members_HAS
super:Init(HyperLabel{"HAS","Has","","member_HAS"},"N",3,0)

RETURN SELF
CLASS Members_HBN INHERIT FIELDSPEC
METHOD Init() CLASS Members_HBN
super:Init(HyperLabel{"householdid","householdid","","member_HBN"},"C",20,0)

RETURN SELF
CLASS Members_HOMEACC INHERIT FIELDSPEC
METHOD Init() CLASS Members_HOMEACC
super:Init(HyperLabel{"HOMEACC","Homeacc","","member_HOMEACC"},"C",70,0)

RETURN SELF
CLASS Members_HOMEPP INHERIT FIELDSPEC
METHOD Init() CLASS Members_HOMEPP
super:Init(HyperLabel{"HOMEPP","Homepp","","member_HOMEPP"},"C",3,0)

RETURN SELF
CLASS Members_OFFCRATE INHERIT FIELDSPEC
METHOD Init() CLASS Members_OFFCRATE
super:Init(HyperLabel{"OFFCRATE","Offcrate","","member_OFFCRATE"},"C",1,0)

RETURN SELF
CLASS Members_REK INHERIT FIELDSPEC
CLASS Members_REK1 INHERIT FIELDSPEC
METHOD Init() CLASS Members_REK1
super:Init(HyperLabel{"REK1","Rek1","","member_REK1"},"N",11,0)

RETURN SELF
METHOD Init() CLASS Members_REK
super:Init(HyperLabel{"accid","accid","","member_REK"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS Members_RPTDEST INHERIT FIELDSPEC
METHOD Init() CLASS Members_RPTDEST
super:Init(HyperLabel{"RPTDEST","Rptdest","","member_RPTDEST"},"N",11,0)

RETURN SELF
CLASS Members_ZKV INHERIT FIELDSPEC
METHOD Init() CLASS Members_ZKV
super:Init(HyperLabel{"ZKV","Zkv","","member_ZKV"},"N",8,2)

RETURN SELF
