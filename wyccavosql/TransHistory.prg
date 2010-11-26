Class TransHistory inherit SQLSelect
METHOD Init(cStatement, Connection) CLASS TransHistory
*	Init transaction for processing of historic and actual transaction files as one large transaction file. 
* 
* cStatement should be in terms of Transaction table  
* date conditions should be specified as: dat>='yyy-mm-dd' or dat<='yyy-mm-dd'
*
super:Init(UnionTrans(cStatement),oConn)
return self
// 
