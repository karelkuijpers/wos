class BigInt
protect Vbits as string // bitstring  
		
declare method Parse, RightRotate, LogicalRightShift, LogicalOR, LogicalXOR,LogicalAND, Add 
/* ,  FindWidth, ArithmeticLeftShift, LogicalLeftShift ,;
LogicalLeftShift, ArithmeticRightShift, LeftRotate,BitsToHexNumeral, InitializeArray;
ToBigInt    */ 
Method __toString()  class BigInt
/**
	This Method is an alias of ToString().
	This Method will be automagically called by print()
	and echo()
*/
return self:ToString()
		
Method Add(Vint as String) as String class BigInt
/**
	Perform a logical Add of BigInt Vint to this one and update its value and return the result.
	All variables are unsigned 32 bits and wrap modulo 2^32 when calculating
*/
local i,fHigh,fSum as int, VRet, VbigStr1:=self:Vbits,VbigStr2  as string 
VbigStr2:=Vint
For i:=1 to 4 
	fSum:=fHigh
	fSum+=Asc(SubStr(VbigStr1,5-i,1) )
	fSum+=Asc(SubStr(VbigStr2,5-i,1) )
	VRet:=CHR(Mod(fSum,256))+VRet
	fHigh:=Integer(fSum/256)
next
if Len(VRet)>4
	VRet:=SubStr(VRet,-4)     //wrap modulo 2^32
endif
self:Vbits:=Vret
return Vret 

		
Access BigInteger Class BigInt
return Vbits
Assign BigInteger(uValue) Class BigInt
if IsString(uValue) 
	// VValue contains bitstring of VWidth
	self:Vbits:=uValue
elseif IsNumeric(uValue)
	self:Parse(uValue) 
else
	Vbits:=CHR(0)+CHR(0)+CHR(0)+CHR(0)+CHR(0)+CHR(0)+CHR(0)+CHR(0)	
endif
return Vbits
Method Init(Vvalue) class BigInt 
if IsString(Vvalue) 
	// VValue contains bitstring of VWidth
	self:Vbits:=Vvalue
elseif IsNumeric(Vvalue)
	self:Parse(Vvalue) 
else
	Vbits:=CHR(0)+CHR(0)+CHR(0)+CHR(0)+CHR(0)+CHR(0)+CHR(0)+CHR(0)	
endif
Return self 
Method LogicalAND( Vbigint as String) as String  class BigInt
/**
	perform a logical AND operation on a BigInt object and Vbigint; update the object value and return the resulting string
*/
local i as int, VRet, VStr:=self:Vbits,VbigStr as string 
Local fBigInt,fBig as LongInt

VbigStr:=Vbigint
For i:=1 to Len(VStr)  
	fBig:=Asc(SubStr(VStr,i,1))
	fBigInt:=Asc(SubStr(VbigStr,i,1))
	VRet+=CHR(_and(fBig,fBigInt))	
next
self:Vbits:=Vret

return Vret
Method LogicalOR(Vbigint as String) as String class BigInt 
/**
	perform a logical OR operation on a BigInt object and Vbigint; update the object value and return the resulting string
*/
local i as int, VRet, VStr:=self:Vbits,VbigStr as string 
Local fBigInt,fBig as LongInt

VbigStr:=Vbigint
For i:=1 to Len(VStr)  
	fBig:=Asc(SubStr(VStr,i,1))
	fBigInt:=Asc(SubStr(VbigStr,i,1))
	VRet+=CHR(_or(fBig,fBigInt))	
next
self:Vbits:=Vret
return Vret
Method LogicalRightShift(Vsteps as int, lRotate as Logic) as String   class BigInt
/**
	Shift this BigInt right by Vsteps positions and return the resulting string.
	This method is only suitable for unsigned BigInts.
*/
Local VRet, Vstr as string, i,nLen:=Len(self:Vbits), iByte,Irest,nShift as int
Vstr:=self:Vbits
if Vsteps>31
	VRet:=L2Bin(0)
else
	nShift:=int(2**Vsteps)
	// shift remaining positions (<8) 
	Irest:=0
	for i:=1 to nLen
		iByte:=Asc(SubStr(Vstr,i,1))+Irest*256
		VRet+= CHR(Integer(iByte/nShift))
		Irest:=Mod(iByte,nShift)
	next
	if lRotate
	 	VRet:=SubStr(VRet,2)
	endif
// else
// 	VRet:=Vstr
endif
Return Vret
Method LogicalXOR(Vbigint as String ) as String class BigInt
/**
	Perform a logical Xor operation on a BigInt object with Vbigint and update its value and return the resulting string.
*/
local i as int, Vret, Vstr:=self:Vbits,VbigStr:=Vbigint as string 
Local fBigInt,fBig as LongInt

For i:=1 to Len(VStr)  
	fBig:=Asc(SubStr(VStr,i,1))
	fBigInt:=Asc(SubStr(VbigStr,i,1))
	VRet+=CHR(_xor(fBig,fBigInt))	
next
self:Vbits:=Vret

return Vret
method Parse(Vvalue as DWORD) as string class BigInt
/**
	Parse a string value containing an integer and
	assign it to the value of the BigInt object that contains the binary
	representation of that integer.    (big endian) 
	Return the parsed value
*/
local nRem as int, i as int, fBig:=Vvalue as DWORD
// Local V1,V2 as string 
  
Vbits:="" 
for i:=1 to 4  // mod 2^32
	nRem:=fBig%256
	fBig:=Floor(fBig/256)
	Vbits:=CHR(nRem)+Vbits            // big indian 
next
return self:Vbits
Method RightRotate(Vsteps as int) as String  class BigInt
/**
	Rotate this BigInt right by Vsteps positions and return the resulting string.
*/
local Voff, VByte as int, VRet, Vshift as string
Vsteps:=Mod(Vsteps,32)  // only one rotate
Voff:=Integer((Vsteps+7)/8)   // nbr of bytes to save 
VByte:=Integer(Vsteps/8)       // nbr of whole bytes to shift
Vsteps:=Mod(Vsteps,8)
Vshift:=SubStr(self:Vbits,-Voff)
VRet:=Vshift+self:Vbits
VRet:=SubStr(VRet,1,Len(VRet)-VByte)     // shift whole bytes
// remaining bits shift: 
if Vsteps>0
	return BigInt{Vret}:LogicalRightShift(Vsteps,true)
else
	return Vret
endif

		
Method ToHex()  class BigInt
local i as int, VRet, VStr:=self:Vbits as string 
Local fBig as shortInt

For i:=1 to Len(VStr)  
	fBig:=Asc(SubStr(VStr,i,1))
	VRet+=SubStr(AsHexString(fBig),-2)	
next


return VRet
Method ToString()  class BigInt
/**
	Return the string representation of this BigInt
*/

return self:Vbits
function sha2(Vstr as string) as string
local oSHA as ShaTwo, cHash as string
oSHA:=ShaTwo{}
cHash:=oSHA:hash(Vstr)
oSHA:=null_object
return cHash 
//  return (ShaTwo{}):hash(Vstr)
class ShaTwo
protect wi as int
protect VK[64] as array
 
export cStat,cStatVK as string  // for debugging 
 declare method hash,pad_message,convert_512_block_to_words,maj, ch, sigma0_256, sigma1_256, bigSigma0_256, bigSigma1_256
method bigSigma0_256(Vx as String) as String class ShaTwo
local Vt1,Vt2, Vt3 as String 
local oBig as BigInt
oBig:=BigInt{Vx}
Vt1 := oBig:RightRotate(2)
Vt2 := oBig:RightRotate(13)
Vt3 := oBig:RightRotate(22)
oBig:BigInteger:=Vt1
oBig:LogicalXOR(Vt2)
return oBig:LogicalXOR(Vt3)
// return (Vt1:LogicalXOR(Vt2)):LogicalXOR(Vt3)
	
method bigSigma1_256(Vx as String) as String class ShaTwo
local Vt1,Vt2, Vt3 as String 
local oBig as BigInt
oBig:=BigInt{Vx}
Vt1 := oBig:RightRotate(6)
Vt2 := oBig:RightRotate(11)
Vt3 := oBig:RightRotate(25)
oBig:BigInteger:=Vt1 
oBig:LogicalXOR(Vt2)
return oBig:LogicalXOR(Vt3)
// return (Vt1:LogicalXOR(Vt2)):LogicalXOR(Vt3)
	
method ch(Vx as String, Vy as String, Vz as String) as String class ShaTwo
// local Vt1,Vt2, Vt3 as String 
local oBig as BigInt
oBig:=BigInt{Vy}
oBig:LogicalXOR(Vz)
oBig:LogicalAND(Vx)
oBig:LogicalXOR(Vz)
return oBig:BigInteger
 
// Vt1 := Vy:LogicalXOR(Vz)
// Vt2 := Vx:LogicalAND(Vt1)
// Vt3 := Vz:LogicalXOR(Vt2)

// return Vt3
	
method convert_512_block_to_words(Vblock as string) as array class ShaTwo 
local Vret[16] as array, Vi as int  
for Vi := 1 to 16
	Vret[Vi]:=SubStr(Vblock,(Vi-1)*4+1,4)
next
return VRet
method hash(Vstr as string) as string class ShaTwo

/*
	ShaTwo Algorithm
	Copyright (c) 2009 Karel Kuijpers
	Date: 21-04-2009
*/

local VW[16],VWnew[64],VM as array
local Vi,VN,Vt  as int
local ViA,ViB,ViC,ViD,ViE,ViF,ViG,ViH as String
Local ViOldA,ViOldB,ViOldC,ViOldD,ViOldE,ViOldF,ViOldG,ViOldH as String
local Vt1,Vt2,Vt3,Vt7 as String
local oBig as BigInt





oBig:=BigInt{}
VM := self:pad_message(Vstr)
// Initial hash values
ViA := oBig:Parse(1779033703)
ViB := oBig:Parse(3144134277)
ViC := oBig:Parse(1013904242)
ViD := oBig:Parse(2773480762)
ViE := oBig:Parse(1359893119)
ViF := oBig:Parse(2600822924)
ViG := oBig:Parse(528734635)
ViH := oBig:Parse(1541459225)

VN := Len(VM)
for Vi := 1 to VN 
	ViOldA := ViA
	ViOldB := ViB
	ViOldC := ViC
	ViOldD := ViD
	ViOldE := ViE
	ViOldF := ViF
	ViOldG := ViG
	ViOldH := ViH
	VW := self:convert_512_block_to_words(VM[Vi])
	VWnew:=AReplicate(null_string,64)
// 	if Vi==1
// 		self:cStat1:=ViA:ToHex()+ViB:ToHex()+ViC:ToHex()+ViD:ToHex()+ViE:ToHex()+ViF:ToHex()+ViG:ToHex()+ViH:ToHex()
// 	endif

	for Vt := 1 to 64
// 		mStatVK+=", "+VK[18]
		if (Vt <= 16)
			VWnew[Vt] := VW[Vt]
		else
			Vt1:=self:sigma1_256(VWnew[Vt-2])
			Vt2:=self:sigma0_256(VWnew[Vt-15])
			oBig:BigInteger:=Vt1
			oBig:Add(VWnew[Vt-7])
			oBig:Add(Vt2)
			VWnew[Vt] :=oBig:Add(VWnew[Vt-16])
		endif
		Vt2 := self:ch(ViE,ViF,ViG)
		Vt3 := self:bigSigma1_256(ViE)
		oBig:BigInteger:=ViH
		oBig:Add(Vt3)
		oBig:Add(Vt2)
		oBig:Add(VK[Vt])
		Vt1:= oBig:Add(VWnew[Vt])
      oBig:BigInteger:=self:bigSigma0_256(ViA)
      Vt7:=oBig:Add(self:maj(ViA,ViB,ViC) )

		ViH := ViG
		ViG := ViF
		ViF := ViE
		oBig:BigInteger:=ViD
		ViE:=oBig:Add(Vt1)
		ViD := ViC
		ViC := ViB
		ViB := ViA 
		oBig:BigInteger:=Vt1
		ViA:=oBig:Add(Vt7)
// 		mStat+=ViA+ViB+ViC+ViD+ViE+ViF+ViG+ViH +CRLF 
// 		mStat+=+Str2Hex(ViA)+" "+Str2Hex(ViB)+" "+Str2Hex(ViC)+" "+Str2Hex(ViD)+" "+Str2Hex(ViE)+" "+Str2Hex(ViF)+" "+Str2Hex(ViG)+" "+Str2Hex(ViH) +CRLF

	next
   oBig:BigInteger:=ViOldA
	ViA := oBig:Add(ViA)
   oBig:BigInteger:=ViOldB
	ViB := oBig:Add(ViB)
   oBig:BigInteger:=ViOldC
	ViC := oBig:Add(ViC)
   oBig:BigInteger:=ViOldD
	ViD := oBig:Add(ViD)
   oBig:BigInteger:=ViOldE
	ViE := oBig:Add(ViE)
   oBig:BigInteger:=ViOldF
	ViF := oBig:Add(ViF)
   oBig:BigInteger:=ViOldG
	ViG := oBig:Add(ViG) 
   oBig:BigInteger:=ViOldH
	ViH := oBig:Add(ViH)
next 
// mStat+=ViA+ViB+ViC+ViD+ViE+ViF+ViG+ViH +CRLF 
// self:cStat:=mStat
// self:cStatVK:=mStatVK
return Str2Hex(ViA)+Str2Hex(ViB)+Str2Hex(ViC)+Str2Hex(ViD)+Str2Hex(ViE)+Str2Hex(ViF)+Str2Hex(ViG)+Str2Hex(ViH)
	
Method Init() class ShaTwo
local oBig as BigInt
oBig:=BigInt{}
// The first sixty-four 32 bit word constants+
// These words represent the first thirty-two bits of
// the fractional parts of the cube roots of the first
// sixty-four prime numbers
VK[1]:=oBig:Parse(1116352408)
VK[2]:=oBig:Parse(1899447441)
VK[3]:=oBig:Parse(3049323471)
VK[4]:=oBig:Parse(3921009573)
VK[5]:=oBig:Parse(961987163)
VK[6]:=oBig:Parse(1508970993)
VK[7]:=oBig:Parse(2453635748)
VK[8]:=oBig:Parse(2870763221)
VK[9]:=oBig:Parse(3624381080)
VK[10]:=oBig:Parse(310598401)
VK[11]:=oBig:Parse(607225278)
VK[12]:=oBig:Parse(1426881987)
VK[13]:=oBig:Parse(1925078388)
VK[14]:=oBig:Parse(2162078206)
VK[15]:=oBig:Parse(2614888103)
VK[16]:=oBig:Parse(3248222580)
VK[17]:=oBig:Parse(3835390401)
VK[18]:=oBig:Parse(4022224774)
VK[19]:=oBig:Parse(264347078)
VK[20]:=oBig:Parse(604807628)
VK[21]:=oBig:Parse(770255983)
VK[22]:=oBig:Parse(1249150122)
VK[23]:=oBig:Parse(1555081692)
VK[24]:=oBig:Parse(1996064986)
VK[25]:=oBig:Parse(2554220882)
VK[26]:=oBig:Parse(2821834349)
VK[27]:=oBig:Parse(2952996808)
VK[28]:=oBig:Parse(3210313671)
VK[29]:=oBig:Parse(3336571891)
VK[30]:=oBig:Parse(3584528711)
VK[31]:=oBig:Parse(113926993)
VK[32]:=oBig:Parse(338241895)
VK[33]:=oBig:Parse(666307205)
VK[34]:=oBig:Parse(773529912)
VK[35]:=oBig:Parse(1294757372)
VK[36]:=oBig:Parse(1396182291)
VK[37]:=oBig:Parse(1695183700)
VK[38]:=oBig:Parse(1986661051)
VK[39]:=oBig:Parse(2177026350)
VK[40]:=oBig:Parse(2456956037)
VK[41]:=oBig:Parse(2730485921)
VK[42]:=oBig:Parse(2820302411)
VK[43]:=oBig:Parse(3259730800)
VK[44]:=oBig:Parse(3345764771)
VK[45]:=oBig:Parse(3516065817)
VK[46]:=oBig:Parse(3600352804)
VK[47]:=oBig:Parse(4094571909)
VK[48]:=oBig:Parse(275423344)
VK[49]:=oBig:Parse(430227734)
VK[50]:=oBig:Parse(506948616)
VK[51]:=oBig:Parse(659060556)
VK[52]:=oBig:Parse(883997877)
VK[53]:=oBig:Parse(958139571)
VK[54]:=oBig:Parse(1322822218)
VK[55]:=oBig:Parse(1537002063)
VK[56]:=oBig:Parse(1747873779)
VK[57]:=oBig:Parse(1955562222)
VK[58]:=oBig:Parse(2024104815)
VK[59]:=oBig:Parse(2227730452)
VK[60]:=oBig:Parse(2361852424)
VK[61]:=oBig:Parse(2428436474)
VK[62]:=oBig:Parse(2756734187)
VK[63]:=oBig:Parse(3204031479)
VK[64]:=oBig:Parse(3329325298)
return self
method maj(Vx as String, Vy as String, Vz as String) as String class ShaTwo
local Vt2 as String 
local oBig as BigInt
oBig:=BigInt{Vx}
oBig:LogicalOR(Vy)
Vt2:=oBig:LogicalAND(Vz) 
oBig:=BigInt{Vx}
oBig:LogicalAND(Vy)
return oBig:LogicalOR(Vt2)

// Vt1:=Vx:LogicalOR(Vy)
// Vt2:=Vz:LogicalAND(Vt1)
// Vt3:=Vx:LogicalAND(Vy)
// Vt4:=Vt3:LogicalOR(Vt2)
// return Vt4
// return (Vx:LogicalAND(Vy)):LogicalOR(Vz:LogicalAND(Vx:LogicalOR(Vy)))
	
method pad_message(Vstr as string) as array class ShaTwo
Local Vstrlen,Vi,V1,V2:=64,Vblocks, i  as longint,Vbitstr,Vbittmp   as string
local Vret as array
Vstrlen := Len(Vstr) 

// NOTE: 8 is the size in bits of a byte (single char string)
//Vl := Vstrlen * 8 

// calculate the number of bytes with zero bits to add
// so that length modulo 64 is 56 (inclusive 1 bit 1 to be added)
V1:=Mod(Vstrlen,64)
if V1<56
	V2:=56-V1
elseif V1>56
	V2:=56+64-V1
endif
//64 bytes: 1 bit 1 + 511 bits 0 to add

// add 1 bit 1+ V2 bits 0
Vbitstr:=Vstr+CHR(128)   // bit 1 followed by 7 bits 0
if V2>1
	for i:=2 to V2
		Vbitstr+=CHR(0)    // bytes with bit 0
	next
endif
// add 8 bytes with length of string
Vbittmp:=L2Bin(Vstrlen*8)
Vbitstr+=L2Bin(0)+SubStr(Vbittmp,4,1)+SubStr(Vbittmp,3,1)+SubStr(Vbittmp,2,1)+SubStr(Vbittmp,1,1)

// break message into 64-byte chunks:
Vblocks := Integer(Len(Vbitstr) / 64)
Vret := AReplicate(null_string,Vblocks)
for Vi := 1 to Vblocks
	Vret[Vi] := SubStr(Vbitstr,(Vi-1)*64+1,64)
next

return Vret
method sigma0_256(Vx as String) as String class ShaTwo
local Vt1,Vt2, Vt3 as String
local oBig as BigInt
oBig:=BigInt{Vx} 
 
Vt1 := oBig:RightRotate(7)
Vt2 := oBig:RightRotate(18)
Vt3 := oBig:LogicalRightShift(3,false)
oBig:BigInteger:=Vt1
oBig:LogicalXOR(Vt2)
return oBig:LogicalXOR(Vt3)
// return (Vt1:LogicalXOR(Vt2)):LogicalXOR(Vt3)

	
method sigma1_256(Vx as string) as String clas ShaTwo
local Vt1,Vt2, Vt3 as string
local oBig as BigInt
oBig:=BigInt{Vx} 
Vt1 := oBig:RightRotate(17)
Vt2 := oBig:RightRotate(19)
Vt3 := oBig:LogicalRightShift(10,false)
oBig:BigInteger:=Vt1
oBig:LogicalXOR(Vt2)
return oBig:LogicalXOR(Vt3)
// return (Vt1:LogicalXOR(Vt2)):LogicalXOR(Vt3)
Function Str2Hex(Vstr as String) as String
// convert string to hexadecimal string
local i as int, Vret as string 
Local fBig as shortInt

For i:=1 to Len(Vstr)  
	fBig:=Asc(SubStr(Vstr,i,1))
	Vret+=SubStr(AsHexString(fBig),-2)	
next


return Vret

