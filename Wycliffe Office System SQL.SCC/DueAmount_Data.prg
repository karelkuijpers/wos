CLASS DueAmount_AANTRAPPEL INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_AANTRAPPEL
super:Init(HyperLabel{"ReminderCnt","ReminderCnt","","dueamnt_AANTRAPPEL"},"N",11,0)

RETURN SELF
CLASS DueAmount_BEDRAGFAKT INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_BEDRAGFAKT
super:Init(HyperLabel{"BEDRAGFAKT","Bedragfakt","","dueamnt_BEDRAGFAKT"},"N",13,2)

RETURN SELF
CLASS DueAmount_BEDRAGONTV INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_BEDRAGONTV
super:Init(HyperLabel{"AmountRecvd","AmountRecvd","","dueamnt_BEDRAGONTV"},"N",13,2)

RETURN SELF
CLASS DueAmount_CLN INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_CLN
super:Init(HyperLabel{"persid","persid","","dueamnt_CLN"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS DueAmount_DATLTSAANM INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_DATLTSAANM
super:Init(HyperLabel{"datelstreminder","datelstreminder","","dueamnt_DATLTSAANM"},"D",10,0)

RETURN SELF
CLASS DueAmount_FAKTDAT INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_FAKTDAT
super:Init(HyperLabel{"invoicedate","invoicedate","","dueamnt_FAKTDAT"},"D",10,0)
self:SetRequired(.T.,)

RETURN SELF
CLASS DueAmount_PAYMETHOD INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_PAYMETHOD
super:Init(HyperLabel{"PAYMETHOD","Paymethod","","dueamnt_PAYMETHOD"},"C",1,0)

RETURN SELF
CLASS DueAmount_REK INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_REK
super:Init(HyperLabel{"accid","accid","","dueamnt_REK"},"N",11,0)

RETURN SELF
CLASS DueAmount_SOORT INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_SOORT
super:Init(HyperLabel{"category","category","","dueamnt_SOORT"},"C",1,0)

RETURN SELF
CLASS DueAmount_VOLGNR INHERIT FIELDSPEC
METHOD Init() CLASS DueAmount_VOLGNR
super:Init(HyperLabel{"seqnr","seqnr","","dueamnt_VOLGNR"},"N",11,0)
self:SetRequired(.T.,)

RETURN SELF
Define IDM_DUEAMOUNT_NAME := "DueAmount"
Define IDM_DueAmount_USERID := "parous…ºw@™Ðw"
