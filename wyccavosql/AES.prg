class AES128

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  Copyright (C) 2009 Karel Kuijpers                                    *
 *  Mail: karel_kuijpers@wycliffe.net                                                  *
 *                                                                           *
 *  This Program is free software; you can redistribute it and/or modify     *
 *  it under the terms of the GNU General Public License as published by     *
 *  the Free Software Foundation; either version 2, or (at your option)      *
 *  any later version.                                                       *
 *                                                                           *
 *  This Program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the             *
 *  GNU General Public License for more details.                             *
 *                                                                           *
 *  You should have received a copy of the GNU General Public License        *
 *  along with GNU Make; see the file COPYING.  If not, write to             *
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.    *
 *  http://www.gnu.org/copyleft/gpl.html                                     *
 *                                                                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
  protect keyCounter as int,;
    dim state[4,4] is byte,;
    dim keyshedule128[44,4] is byte,;
    dim initialKey[16] is byte,; 
    byteCounter as int
//   protect keyCounter as int,;
//     state[4,4] as array,;
//     keyshedule128[44,4] as array,;
//     initialKey[16] as array,; 
//     byteCounter as int
  
protect dim sBox[256] as byte
protect dim sBoxInv[256] as byte
protect dim FFlog[256] as byte
protect dim FFpow[510]	as byte 
// protect sBox[256] as array
// protect sBoxInv[256] as array
// protect FFlog[256] as array
// protect FFpow[510]	as array 
export cInitKey,cHash, cStat,cStatVK  as string

protect key_in as string // last value used for key 
protect a := 0x02;
,b := 0x03;
,c := 0x0E;
,d := 0x0B;
,e := 0x0D;
,f := 0x09 as byte

Protect oSha as ShaTwo

declare method encrypt,decrypt;
    ,FFMul;
    ,convertKeyString;
    ,fillState, setkey
method convertKeyString(keyString as string ) as void  class AES128 
// convert hexdecimal string of 16 bytes (32 characters)
local i,j as int, ik as byte
for i := 1 to 32 step 2
	j++ 
	ik:=byte(_cast,Val("0x"+SubStr(keyString, i, 2)))
	initialKey[j] := ik 
	cInitKey+=CHR(initialKey[j]) 
next
return 
method decrypt(f_key as string, f_bufferstr as string) as string   class AES128
local f_out as string , lenBuf,i as int
local f_buffer:={} as array
for i:=1 to Len(f_bufferstr) step 2
	AAdd(f_buffer,Val("0x"+SubStr(f_bufferstr,i,2)) )
next 
 
lenBuf:=Len(f_buffer)
// if lenBuf>16
// 	lenBuf-=16
// endif
byteCounter := 0 
self:setkey(f_key) 

do while byteCounter < lenBuf 
    self:fillState(f_buffer)
    f_out+=self:decryptNextBlock()
enddo
return AllTrim(f_out)
method decryptNextBlock() class AES128
local  i, j as int, my_out as string
  keyCounter := 41
  self:xorRoundKey()
  self:invsubBytes()
  self:invshiftRows()
  keyCounter := keyCounter - 8
  self:xorRoundKey()
  self:invmixcolumns()
  self:invsubBytes()
  self:invshiftRows()
  keyCounter := keyCounter - 8
  self:xorRoundKey()
  self:invmixcolumns()
  self:invsubBytes()
  self:invshiftRows()
  keyCounter := keyCounter - 8
  self:xorRoundKey()
  self:invmixcolumns()
  self:invsubBytes()
  self:invshiftRows()
  keyCounter := keyCounter - 8
  self:xorRoundKey()
  self:invmixcolumns()
  self:invsubBytes()
  self:invshiftRows()
  keyCounter := keyCounter - 8
  self:xorRoundKey()
  self:invmixcolumns()
  self:invsubBytes()
  self:invshiftRows()
  keyCounter := keyCounter - 8
  self:xorRoundKey()
  self:invmixcolumns()
  self:invsubBytes()
  self:invshiftRows()
  keyCounter := keyCounter - 8
  self:xorRoundKey()
  self:invmixcolumns()
  self:invsubBytes()
  self:invshiftRows()
  keyCounter := keyCounter - 8
  self:xorRoundKey()
  self:invmixcolumns()
  self:invsubBytes()
  self:invshiftRows()
  keyCounter := keyCounter - 8
  self:xorRoundKey()
  self:invmixcolumns()
  self:invsubBytes()
  self:invshiftRows()
  keyCounter := 1
  self:xorRoundKey()
  for i := 1 to 4 
    for j := 1 to 4 
      my_out+= CHR(DWORD(_cast,state[i, j]))
//       my_out += SubStr(AsHexString(state[i, j]),-2)

    next
  next
return my_out
method encrypt(f_key as string, f_bufferstr as string ) as string   class AES128
local f_out as string , lenBuf:=Len(f_bufferstr) as int
local f_buffer:={} as array 
// convert string to byte array:
SEval(f_bufferstr,{|x|AAdd(f_buffer,x)})
// if lenBuf>16
// 	lenBuf-=16
// endif
  byteCounter := 0
  self:setkey(f_key)
  do while byteCounter < lenBuf 
    self:fillState(f_buffer)
    f_out+=self:encryptNextBlock()
  enddo  
return f_out
method encryptNextBlock() class AES128
local i, j as int, m_out as string
  keycounter := 1
  self:xorRoundKey()
  self:subBytes()
  self:shiftRows()
  self:mixcolumns()
  self:xorRoundKey()
  self:subBytes()
  self:shiftRows()
  self:mixcolumns()
  self:xorRoundKey()
  self:subBytes()
  self:shiftRows()
  self:mixcolumns()
  self:xorRoundKey()
  self:subBytes()
  self:shiftRows()
  self:mixcolumns()
  self:xorRoundKey()
  self:subBytes()
  self:shiftRows()
  self:mixcolumns()
  self:xorRoundKey()
  self:subBytes()
  self:shiftRows()
  self:mixcolumns()
  self:xorRoundKey()
  self:subBytes()
  self:shiftRows()
  self:mixcolumns()
  self:xorRoundKey()
  self:subBytes()
  self:shiftRows()
  self:mixcolumns()
  self:xorRoundKey()
  self:subBytes()
  self:shiftRows()
  self:mixcolumns()
  self:xorRoundKey()
  self:subBytes()
  self:shiftRows()
  self:xorRoundKey()
  for i := 1 to 4 
    for j := 1 to 4
      m_out += SubStr(AsHexString(state[i, j]),-2)
    next
  next
return m_out
method FFMul(a as byte, b as byte) as byte   class AES128 
Local fPtr,aPtr,bPtr as int
if ((a <> 0) .and. (b <> 0)) 
	aPtr:=a+1
	bPtr:=b+1
	fPtr:=FFlog[aPtr]
	fPtr+=FFlog[bPtr]+1
	if fPtr>0 .and.fPtr<=510 
		return FFPow[fPtr]
	else
		(ErrorBox{,"Err:"+Str(fPtr,-1)}):show()
	endif
endif
return 0x00
method fillState(f_out as array) as void  class AES128
local i,k:=0,l,lb:=Len(f_out) as int 
for i:=1 to 16
	l:=Mod(i-1,4)+1
	if l==1
		k++
	endif
	self:byteCounter+=1
	if byteCounter <=lb
		state[k, l] := byte(_cast,f_out[byteCounter])
	else
		state[k,l]:= 0x20   // default space 
	endif
next
return 
method getkey() class AES128
local i, j as int, fkey as string
for i:=1 to 44
	for j:=1 to 4
		fkey+=SubStr(AsHexString(keyshedule128[i,j]),-2)
	next
next
return fkey
method Init() class AES128
local i, j as int, fb:=0x00 as byte
sBox[1]:=0x63
sBox[2]:=0x7C
sBox[3]:=0x77
sBox[4]:=0x7B
sBox[5]:=0xF2
sBox[6]:=0x6B
sBox[7]:=0x6F
sBox[8]:=0xC5
sBox[9]:=0x30
sBox[10]:=0x01
sBox[11]:=0x67
sBox[12]:=0x2B
sBox[13]:=0xFE
sBox[14]:=0xD7
sBox[15]:=0xAB
sBox[16]:=0x76
sBox[17]:=0xCA
sBox[18]:=0x82
sBox[19]:=0xC9
sBox[20]:=0x7D
sBox[21]:=0xFA
sBox[22]:=0x59
sBox[23]:=0x47
sBox[24]:=0xF0
sBox[25]:=0xAD
sBox[26]:=0xD4
sBox[27]:=0xA2
sBox[28]:=0xAF
sBox[29]:=0x9C
sBox[30]:=0xA4
sBox[31]:=0x72
sBox[32]:=0xC0
sBox[33]:=0xB7
sBox[34]:=0xFD
sBox[35]:=0x93
sBox[36]:=0x26
sBox[37]:=0x36
sBox[38]:=0x3F
sBox[39]:=0xF7
sBox[40]:=0xCC
sBox[41]:=0x34
sBox[42]:=0xA5
sBox[43]:=0xE5
sBox[44]:=0xF1
sBox[45]:=0x71
sBox[46]:=0xD8
sBox[47]:=0x31
sBox[48]:=0x15
sBox[49]:=0x04
sBox[50]:=0xC7
sBox[51]:=0x23
sBox[52]:=0xC3
sBox[53]:=0x18
sBox[54]:=0x96
sBox[55]:=0x05
sBox[56]:=0x9A
sBox[57]:=0x07
sBox[58]:=0x12
sBox[59]:=0x80
sBox[60]:=0xE2
sBox[61]:=0xEB
sBox[62]:=0x27
sBox[63]:=0xB2
sBox[64]:=0x75
sBox[65]:=0x09
sBox[66]:=0x83
sBox[67]:=0x2C
sBox[68]:=0x1A
sBox[69]:=0x1B
sBox[70]:=0x6E
sBox[71]:=0x5A
sBox[72]:=0xA0
sBox[73]:=0x52
sBox[74]:=0x3B
sBox[75]:=0xD6
sBox[76]:=0xB3
sBox[77]:=0x29
sBox[78]:=0xE3
sBox[79]:=0x2F
sBox[80]:=0x84
sBox[81]:=0x53
sBox[82]:=0xD1
sBox[83]:=0x00
sBox[84]:=0xED
sBox[85]:=0x20
sBox[86]:=0xFC
sBox[87]:=0xB1
sBox[88]:=0x5B
sBox[89]:=0x6A
sBox[90]:=0xCB
sBox[91]:=0xBE
sBox[92]:=0x39
sBox[93]:=0x4A
sBox[94]:=0x4C
sBox[95]:=0x58
sBox[96]:=0xCF
sBox[97]:=0xD0
sBox[98]:=0xEF
sBox[99]:=0xAA
sBox[100]:=0xFB
sBox[101]:=0x43
sBox[102]:=0x4D
sBox[103]:=0x33
sBox[104]:=0x85
sBox[105]:=0x45
sBox[106]:=0xF9
sBox[107]:=0x02
sBox[108]:=0x7F
sBox[109]:=0x50
sBox[110]:=0x3C
sBox[111]:=0x9F
sBox[112]:=0xA8
sBox[113]:=0x51
sBox[114]:=0xA3
sBox[115]:=0x40
sBox[116]:=0x8F
sBox[117]:=0x92
sBox[118]:=0x9D
sBox[119]:=0x38
sBox[120]:=0xF5
sBox[121]:=0xBC
sBox[122]:=0xB6
sBox[123]:=0xDA
sBox[124]:=0x21
sBox[125]:=0x10
sBox[126]:=0xFF
sBox[127]:=0xF3
sBox[128]:=0xD2
sBox[129]:=0xCD
sBox[130]:=0x0C
sBox[131]:=0x13
sBox[132]:=0xEC
sBox[133]:=0x5F
sBox[134]:=0x97
sBox[135]:=0x44
sBox[136]:=0x17
sBox[137]:=0xC4
sBox[138]:=0xA7
sBox[139]:=0x7E
sBox[140]:=0x3D
sBox[141]:=0x64
sBox[142]:=0x5D
sBox[143]:=0x19
sBox[144]:=0x73
sBox[145]:=0x60
sBox[146]:=0x81
sBox[147]:=0x4F
sBox[148]:=0xDC
sBox[149]:=0x22
sBox[150]:=0x2A
sBox[151]:=0x90
sBox[152]:=0x88
sBox[153]:=0x46
sBox[154]:=0xEE
sBox[155]:=0xB8
sBox[156]:=0x14
sBox[157]:=0xDE
sBox[158]:=0x5E
sBox[159]:=0x0B
sBox[160]:=0xDB
sBox[161]:=0xE0
sBox[162]:=0x32
sBox[163]:=0x3A
sBox[164]:=0x0A
sBox[165]:=0x49
sBox[166]:=0x06
sBox[167]:=0x24
sBox[168]:=0x5C
sBox[169]:=0xC2
sBox[170]:=0xD3
sBox[171]:=0xAC
sBox[172]:=0x62
sBox[173]:=0x91
sBox[174]:=0x95
sBox[175]:=0xE4
sBox[176]:=0x79
sBox[177]:=0xE7
sBox[178]:=0xC8
sBox[179]:=0x37
sBox[180]:=0x6D
sBox[181]:=0x8D
sBox[182]:=0xD5
sBox[183]:=0x4E
sBox[184]:=0xA9
sBox[185]:=0x6C
sBox[186]:=0x56
sBox[187]:=0xF4
sBox[188]:=0xEA
sBox[189]:=0x65
sBox[190]:=0x7A
sBox[191]:=0xAE
sBox[192]:=0x08
sBox[193]:=0xBA
sBox[194]:=0x78
sBox[195]:=0x25
sBox[196]:=0x2E
sBox[197]:=0x1C
sBox[198]:=0xA6
sBox[199]:=0xB4
sBox[200]:=0xC6
sBox[201]:=0xE8
sBox[202]:=0xDD
sBox[203]:=0x74
sBox[204]:=0x1F
sBox[205]:=0x4B
sBox[206]:=0xBD
sBox[207]:=0x8B
sBox[208]:=0x8A
sBox[209]:=0x70
sBox[210]:=0x3E
sBox[211]:=0xB5
sBox[212]:=0x66
sBox[213]:=0x48
sBox[214]:=0x03
sBox[215]:=0xF6
sBox[216]:=0x0E
sBox[217]:=0x61
sBox[218]:=0x35
sBox[219]:=0x57
sBox[220]:=0xB9
sBox[221]:=0x86
sBox[222]:=0xC1
sBox[223]:=0x1D
sBox[224]:=0x9E
sBox[225]:=0xE1
sBox[226]:=0xF8
sBox[227]:=0x98
sBox[228]:=0x11
sBox[229]:=0x69
sBox[230]:=0xD9
sBox[231]:=0x8E
sBox[232]:=0x94
sBox[233]:=0x9B
sBox[234]:=0x1E
sBox[235]:=0x87
sBox[236]:=0xE9
sBox[237]:=0xCE
sBox[238]:=0x55
sBox[239]:=0x28
sBox[240]:=0xDF
sBox[241]:=0x8C
sBox[242]:=0xA1
sBox[243]:=0x89
sBox[244]:=0x0D
sBox[245]:=0xBF
sBox[246]:=0xE6
sBox[247]:=0x42
sBox[248]:=0x68
sBox[249]:=0x41
sBox[250]:=0x99
sBox[251]:=0x2D
sBox[252]:=0x0F
sBox[253]:=0xB0
sBox[254]:=0x54
sBox[255]:=0xBB
sBox[256]:=0x16

sBoxInv[	1	]	:=	0x52
sBoxInv[	2	]	:=	0x09
sBoxInv[	3	]	:=	0x6A
sBoxInv[	4	]	:=	0xD5
sBoxInv[	5	]	:=	0x30
sBoxInv[	6	]	:=	0x36
sBoxInv[	7	]	:=	0xA5
sBoxInv[	8	]	:=	0x38
sBoxInv[	9	]	:=	0xBF
sBoxInv[	10	]	:=	0x40
sBoxInv[	11	]	:=	0xA3
sBoxInv[	12	]	:=	0x9E
sBoxInv[	13	]	:=	0x81
sBoxInv[	14	]	:=	0xF3
sBoxInv[	15	]	:=	0xD7
sBoxInv[	16	]	:=	0xFB
sBoxInv[	17	]	:=	0x7C
sBoxInv[	18	]	:=	0xE3
sBoxInv[	19	]	:=	0x39
sBoxInv[	20	]	:=	0x82
sBoxInv[	21	]	:=	0x9B
sBoxInv[	22	]	:=	0x2F
sBoxInv[	23	]	:=	0xFF
sBoxInv[	24	]	:=	0x87
sBoxInv[	25	]	:=	0x34
sBoxInv[	26	]	:=	0x8E
sBoxInv[	27	]	:=	0x43
sBoxInv[	28	]	:=	0x44
sBoxInv[	29	]	:=	0xC4
sBoxInv[	30	]	:=	0xDE
sBoxInv[	31	]	:=	0xE9
sBoxInv[	32	]	:=	0xCB
sBoxInv[	33	]	:=	0x54
sBoxInv[	34	]	:=	0x7B
sBoxInv[	35	]	:=	0x94
sBoxInv[	36	]	:=	0x32
sBoxInv[	37	]	:=	0xA6
sBoxInv[	38	]	:=	0xC2
sBoxInv[	39	]	:=	0x23
sBoxInv[	40	]	:=	0x3D
sBoxInv[	41	]	:=	0xEE
sBoxInv[	42	]	:=	0x4C
sBoxInv[	43	]	:=	0x95
sBoxInv[	44	]	:=	0x0B
sBoxInv[	45	]	:=	0x42
sBoxInv[	46	]	:=	0xFA
sBoxInv[	47	]	:=	0xC3
sBoxInv[	48	]	:=	0x4E
sBoxInv[	49	]	:=	0x08
sBoxInv[	50	]	:=	0x2E
sBoxInv[	51	]	:=	0xA1
sBoxInv[	52	]	:=	0x66
sBoxInv[	53	]	:=	0x28
sBoxInv[	54	]	:=	0xD9
sBoxInv[	55	]	:=	0x24
sBoxInv[	56	]	:=	0xB2
sBoxInv[	57	]	:=	0x76
sBoxInv[	58	]	:=	0x5B
sBoxInv[	59	]	:=	0xA2
sBoxInv[	60	]	:=	0x49
sBoxInv[	61	]	:=	0x6D
sBoxInv[	62	]	:=	0x8B
sBoxInv[	63	]	:=	0xD1
sBoxInv[	64	]	:=	0x25
sBoxInv[	65	]	:=	0x72
sBoxInv[	66	]	:=	0xF8
sBoxInv[	67	]	:=	0xF6
sBoxInv[	68	]	:=	0x64
sBoxInv[	69	]	:=	0x86
sBoxInv[	70	]	:=	0x68
sBoxInv[	71	]	:=	0x98
sBoxInv[	72	]	:=	0x16
sBoxInv[	73	]	:=	0xD4
sBoxInv[	74	]	:=	0xA4
sBoxInv[	75	]	:=	0x5C
sBoxInv[	76	]	:=	0xCC
sBoxInv[	77	]	:=	0x5D
sBoxInv[	78	]	:=	0x65
sBoxInv[	79	]	:=	0xB6
sBoxInv[	80	]	:=	0x92
sBoxInv[	81	]	:=	0x6C
sBoxInv[	82	]	:=	0x70
sBoxInv[	83	]	:=	0x48
sBoxInv[	84	]	:=	0x50
sBoxInv[	85	]	:=	0xFD
sBoxInv[	86	]	:=	0xED
sBoxInv[	87	]	:=	0xB9
sBoxInv[	88	]	:=	0xDA
sBoxInv[	89	]	:=	0x5E
sBoxInv[	90	]	:=	0x15
sBoxInv[	91	]	:=	0x46
sBoxInv[	92	]	:=	0x57
sBoxInv[	93	]	:=	0xA7
sBoxInv[	94	]	:=	0x8D
sBoxInv[	95	]	:=	0x9D
sBoxInv[	96	]	:=	0x84
sBoxInv[	97	]	:=	0x90
sBoxInv[	98	]	:=	0xD8
sBoxInv[	99	]	:=	0xAB
sBoxInv[	100	]	:=	0x00
sBoxInv[	101	]	:=	0x8C
sBoxInv[	102	]	:=	0xBC
sBoxInv[	103	]	:=	0xD3
sBoxInv[	104	]	:=	0x0A
sBoxInv[	105	]	:=	0xF7
sBoxInv[	106	]	:=	0xE4
sBoxInv[	107	]	:=	0x58
sBoxInv[	108	]	:=	0x05
sBoxInv[	109	]	:=	0xB8
sBoxInv[	110	]	:=	0xB3
sBoxInv[	111	]	:=	0x45
sBoxInv[	112	]	:=	0x06
sBoxInv[	113	]	:=	0xD0
sBoxInv[	114	]	:=	0x2C
sBoxInv[	115	]	:=	0x1E
sBoxInv[	116	]	:=	0x8F
sBoxInv[	117	]	:=	0xCA
sBoxInv[	118	]	:=	0x3F
sBoxInv[	119	]	:=	0x0F
sBoxInv[	120	]	:=	0x02
sBoxInv[	121	]	:=	0xC1
sBoxInv[	122	]	:=	0xAF
sBoxInv[	123	]	:=	0xBD
sBoxInv[	124	]	:=	0x03
sBoxInv[	125	]	:=	0x01
sBoxInv[	126	]	:=	0x13
sBoxInv[	127	]	:=	0x8A
sBoxInv[	128	]	:=	0x6B
sBoxInv[	129	]	:=	0x3A
sBoxInv[	130	]	:=	0x91
sBoxInv[	131	]	:=	0x11
sBoxInv[	132	]	:=	0x41
sBoxInv[	133	]	:=	0x4F
sBoxInv[	134	]	:=	0x67
sBoxInv[	135	]	:=	0xDC
sBoxInv[	136	]	:=	0xEA
sBoxInv[	137	]	:=	0x97
sBoxInv[	138	]	:=	0xF2
sBoxInv[	139	]	:=	0xCF
sBoxInv[	140	]	:=	0xCE
sBoxInv[	141	]	:=	0xF0
sBoxInv[	142	]	:=	0xB4
sBoxInv[	143	]	:=	0xE6
sBoxInv[	144	]	:=	0x73
sBoxInv[	145	]	:=	0x96
sBoxInv[	146	]	:=	0xAC
sBoxInv[	147	]	:=	0x74
sBoxInv[	148	]	:=	0x22
sBoxInv[	149	]	:=	0xE7
sBoxInv[	150	]	:=	0xAD
sBoxInv[	151	]	:=	0x35
sBoxInv[	152	]	:=	0x85
sBoxInv[	153	]	:=	0xE2
sBoxInv[	154	]	:=	0xF9
sBoxInv[	155	]	:=	0x37
sBoxInv[	156	]	:=	0xE8
sBoxInv[	157	]	:=	0x1C
sBoxInv[	158	]	:=	0x75
sBoxInv[	159	]	:=	0xDF
sBoxInv[	160	]	:=	0x6E
sBoxInv[	161	]	:=	0x47
sBoxInv[	162	]	:=	0xF1
sBoxInv[	163	]	:=	0x1A
sBoxInv[	164	]	:=	0x71
sBoxInv[	165	]	:=	0x1D
sBoxInv[	166	]	:=	0x29
sBoxInv[	167	]	:=	0xC5
sBoxInv[	168	]	:=	0x89
sBoxInv[	169	]	:=	0x6F
sBoxInv[	170	]	:=	0xB7
sBoxInv[	171	]	:=	0x62
sBoxInv[	172	]	:=	0x0E
sBoxInv[	173	]	:=	0xAA
sBoxInv[	174	]	:=	0x18
sBoxInv[	175	]	:=	0xBE
sBoxInv[	176	]	:=	0x1B
sBoxInv[	177	]	:=	0xFC
sBoxInv[	178	]	:=	0x56
sBoxInv[	179	]	:=	0x3E
sBoxInv[	180	]	:=	0x4B
sBoxInv[	181	]	:=	0xC6
sBoxInv[	182	]	:=	0xD2
sBoxInv[	183	]	:=	0x79
sBoxInv[	184	]	:=	0x20
sBoxInv[	185	]	:=	0x9A
sBoxInv[	186	]	:=	0xDB
sBoxInv[	187	]	:=	0xC0
sBoxInv[	188	]	:=	0xFE
sBoxInv[	189	]	:=	0x78
sBoxInv[	190	]	:=	0xCD
sBoxInv[	191	]	:=	0x5A
sBoxInv[	192	]	:=	0xF4
sBoxInv[	193	]	:=	0x1F
sBoxInv[	194	]	:=	0xDD
sBoxInv[	195	]	:=	0xA8
sBoxInv[	196	]	:=	0x33
sBoxInv[	197	]	:=	0x88
sBoxInv[	198	]	:=	0x07
sBoxInv[	199	]	:=	0xC7
sBoxInv[	200	]	:=	0x31
sBoxInv[	201	]	:=	0xB1
sBoxInv[	202	]	:=	0x12
sBoxInv[	203	]	:=	0x10
sBoxInv[	204	]	:=	0x59
sBoxInv[	205	]	:=	0x27
sBoxInv[	206	]	:=	0x80
sBoxInv[	207	]	:=	0xEC
sBoxInv[	208	]	:=	0x5F
sBoxInv[	209	]	:=	0x60
sBoxInv[	210	]	:=	0x51
sBoxInv[	211	]	:=	0x7F
sBoxInv[	212	]	:=	0xA9
sBoxInv[	213	]	:=	0x19
sBoxInv[	214	]	:=	0xB5
sBoxInv[	215	]	:=	0x4A
sBoxInv[	216	]	:=	0x0D
sBoxInv[	217	]	:=	0x2D
sBoxInv[	218	]	:=	0xE5
sBoxInv[	219	]	:=	0x7A
sBoxInv[	220	]	:=	0x9F
sBoxInv[	221	]	:=	0x93
sBoxInv[	222	]	:=	0xC9
sBoxInv[	223	]	:=	0x9C
sBoxInv[	224	]	:=	0xEF
sBoxInv[	225	]	:=	0xA0
sBoxInv[	226	]	:=	0xE0
sBoxInv[	227	]	:=	0x3B
sBoxInv[	228	]	:=	0x4D
sBoxInv[	229	]	:=	0xAE
sBoxInv[	230	]	:=	0x2A
sBoxInv[	231	]	:=	0xF5
sBoxInv[	232	]	:=	0xB0
sBoxInv[	233	]	:=	0xC8
sBoxInv[	234	]	:=	0xEB
sBoxInv[	235	]	:=	0xBB
sBoxInv[	236	]	:=	0x3C
sBoxInv[	237	]	:=	0x83
sBoxInv[	238	]	:=	0x53
sBoxInv[	239	]	:=	0x99
sBoxInv[	240	]	:=	0x61
sBoxInv[	241	]	:=	0x17
sBoxInv[	242	]	:=	0x2B
sBoxInv[	243	]	:=	0x04
sBoxInv[	244	]	:=	0x7E
sBoxInv[	245	]	:=	0xBA
sBoxInv[	246	]	:=	0x77
sBoxInv[	247	]	:=	0xD6
sBoxInv[	248	]	:=	0x26
sBoxInv[	249	]	:=	0xE1
sBoxInv[	250	]	:=	0x69
sBoxInv[	251	]	:=	0x14
sBoxInv[	252	]	:=	0x63
sBoxInv[	253	]	:=	0x55
sBoxInv[	254	]	:=	0x21
sBoxInv[	255	]	:=	0x0C
sBoxInv[	256	]	:=	0x7D
    
FFlog[1]:=0x00
FFlog[2]:=0x00
FFlog[3]:=0x19
FFlog[4]:=0x01
FFlog[5]:=0x32
FFlog[6]:=0x02
FFlog[7]:=0x1A
FFlog[8]:=0xC6
FFlog[9]:=0x4B
FFlog[10]:=0xC7
FFlog[11]:=0x1B
FFlog[12]:=0x68
FFlog[13]:=0x33
FFlog[14]:=0xEE
FFlog[15]:=0xDF
FFlog[16]:=0x03
FFlog[17]:=0x64
FFlog[18]:=0x04
FFlog[19]:=0xE0
FFlog[20]:=0x0E
FFlog[21]:=0x34
FFlog[22]:=0x8D
FFlog[23]:=0x81
FFlog[24]:=0xEF
FFlog[25]:=0x4C
FFlog[26]:=0x71
FFlog[27]:=0x08
FFlog[28]:=0xC8
FFlog[29]:=0xF8
FFlog[30]:=0x69
FFlog[31]:=0x1C
FFlog[32]:=0xC1
FFlog[33]:=0x7D
FFlog[34]:=0xC2
FFlog[35]:=0x1D
FFlog[36]:=0xB5
FFlog[37]:=0xF9
FFlog[38]:=0xB9
FFlog[39]:=0x27
FFlog[40]:=0x6A
FFlog[41]:=0x4D
FFlog[42]:=0xE4
FFlog[43]:=0xA6
FFlog[44]:=0x72
FFlog[45]:=0x9A
FFlog[46]:=0xC9
FFlog[47]:=0x09
FFlog[48]:=0x78
FFlog[49]:=0x65
FFlog[50]:=0x2F
FFlog[51]:=0x8A
FFlog[52]:=0x05
FFlog[53]:=0x21
FFlog[54]:=0x0F
FFlog[55]:=0xE1
FFlog[56]:=0x24
FFlog[57]:=0x12
FFlog[58]:=0xF0
FFlog[59]:=0x82
FFlog[60]:=0x45
FFlog[61]:=0x35
FFlog[62]:=0x93
FFlog[63]:=0xDA
FFlog[64]:=0x8E
FFlog[65]:=0x96
FFlog[66]:=0x8F
FFlog[67]:=0xDB
FFlog[68]:=0xBD
FFlog[69]:=0x36
FFlog[70]:=0xD0
FFlog[71]:=0xCE
FFlog[72]:=0x94
FFlog[73]:=0x13
FFlog[74]:=0x5C
FFlog[75]:=0xD2
FFlog[76]:=0xF1
FFlog[77]:=0x40
FFlog[78]:=0x46
FFlog[79]:=0x83
FFlog[80]:=0x38
FFlog[81]:=0x66
FFlog[82]:=0xDD
FFlog[83]:=0xFD
FFlog[84]:=0x30
FFlog[85]:=0xBF
FFlog[86]:=0x06
FFlog[87]:=0x8B
FFlog[88]:=0x62
FFlog[89]:=0xB3
FFlog[90]:=0x25
FFlog[91]:=0xE2
FFlog[92]:=0x98
FFlog[93]:=0x22
FFlog[94]:=0x88
FFlog[95]:=0x91
FFlog[96]:=0x10
FFlog[97]:=0x7E
FFlog[98]:=0x6E
FFlog[99]:=0x48
FFlog[100]:=0xC3
FFlog[101]:=0xA3
FFlog[102]:=0xB6
FFlog[103]:=0x1E
FFlog[104]:=0x42
FFlog[105]:=0x3A
FFlog[106]:=0x6B
FFlog[107]:=0x28
FFlog[108]:=0x54
FFlog[109]:=0xFA
FFlog[110]:=0x85
FFlog[111]:=0x3D
FFlog[112]:=0xBA
FFlog[113]:=0x2B
FFlog[114]:=0x79
FFlog[115]:=0x0A
FFlog[116]:=0x15
FFlog[117]:=0x9B
FFlog[118]:=0x9F
FFlog[119]:=0x5E
FFlog[120]:=0xCA
FFlog[121]:=0x4E
FFlog[122]:=0xD4
FFlog[123]:=0xAC
FFlog[124]:=0xE5
FFlog[125]:=0xF3
FFlog[126]:=0x73
FFlog[127]:=0xA7
FFlog[128]:=0x57
FFlog[129]:=0xAF
FFlog[130]:=0x58
FFlog[131]:=0xA8
FFlog[132]:=0x50
FFlog[133]:=0xF4
FFlog[134]:=0xEA
FFlog[135]:=0xD6
FFlog[136]:=0x74
FFlog[137]:=0x4F
FFlog[138]:=0xAE
FFlog[139]:=0xE9
FFlog[140]:=0xD5
FFlog[141]:=0xE7
FFlog[142]:=0xE6
FFlog[143]:=0xAD
FFlog[144]:=0xE8
FFlog[145]:=0x2C
FFlog[146]:=0xD7
FFlog[147]:=0x75
FFlog[148]:=0x7A
FFlog[149]:=0xEB
FFlog[150]:=0x16
FFlog[151]:=0x0B
FFlog[152]:=0xF5
FFlog[153]:=0x59
FFlog[154]:=0xCB
FFlog[155]:=0x5F
FFlog[156]:=0xB0
FFlog[157]:=0x9C
FFlog[158]:=0xA9
FFlog[159]:=0x51
FFlog[160]:=0xA0
FFlog[161]:=0x7F
FFlog[162]:=0x0C
FFlog[163]:=0xF6
FFlog[164]:=0x6F
FFlog[165]:=0x17
FFlog[166]:=0xC4
FFlog[167]:=0x49
FFlog[168]:=0xEC
FFlog[169]:=0xD8
FFlog[170]:=0x43
FFlog[171]:=0x1F
FFlog[172]:=0x2D
FFlog[173]:=0xA4
FFlog[174]:=0x76
FFlog[175]:=0x7B
FFlog[176]:=0xB7
FFlog[177]:=0xCC
FFlog[178]:=0xBB
FFlog[179]:=0x3E
FFlog[180]:=0x5A
FFlog[181]:=0xFB
FFlog[182]:=0x60
FFlog[183]:=0xB1
FFlog[184]:=0x86
FFlog[185]:=0x3B
FFlog[186]:=0x52
FFlog[187]:=0xA1
FFlog[188]:=0x6C
FFlog[189]:=0xAA
FFlog[190]:=0x55
FFlog[191]:=0x29
FFlog[192]:=0x9D
FFlog[193]:=0x97
FFlog[194]:=0xB2
FFlog[195]:=0x87
FFlog[196]:=0x90
FFlog[197]:=0x61
FFlog[198]:=0xBE
FFlog[199]:=0xDC
FFlog[200]:=0xFC
FFlog[201]:=0xBC
FFlog[202]:=0x95
FFlog[203]:=0xCF
FFlog[204]:=0xCD
FFlog[205]:=0x37
FFlog[206]:=0x3F
FFlog[207]:=0x5B
FFlog[208]:=0xD1
FFlog[209]:=0x53
FFlog[210]:=0x39
FFlog[211]:=0x84
FFlog[212]:=0x3C
FFlog[213]:=0x41
FFlog[214]:=0xA2
FFlog[215]:=0x6D
FFlog[216]:=0x47
FFlog[217]:=0x14
FFlog[218]:=0x2A
FFlog[219]:=0x9E
FFlog[220]:=0x5D
FFlog[221]:=0x56
FFlog[222]:=0xF2
FFlog[223]:=0xD3
FFlog[224]:=0xAB
FFlog[225]:=0x44
FFlog[226]:=0x11
FFlog[227]:=0x92
FFlog[228]:=0xD9
FFlog[229]:=0x23
FFlog[230]:=0x20
FFlog[231]:=0x2E
FFlog[232]:=0x89
FFlog[233]:=0xB4
FFlog[234]:=0x7C
FFlog[235]:=0xB8
FFlog[236]:=0x26
FFlog[237]:=0x77
FFlog[238]:=0x99
FFlog[239]:=0xE3
FFlog[240]:=0xA5
FFlog[241]:=0x67
FFlog[242]:=0x4A
FFlog[243]:=0xED
FFlog[244]:=0xDE
FFlog[245]:=0xC5
FFlog[246]:=0x31
FFlog[247]:=0xFE
FFlog[248]:=0x18
FFlog[249]:=0x0D
FFlog[250]:=0x63
FFlog[251]:=0x8C
FFlog[252]:=0x80
FFlog[253]:=0xC0
FFlog[254]:=0xF7
FFlog[255]:=0x70
FFlog[256]:=0x07

FFpow[	1	]	:=	0x01
FFpow[	2	]	:=	0x03
FFpow[	3	]	:=	0x05
FFpow[	4	]	:=	0x0F
FFpow[	5	]	:=	0x11
FFpow[	6	]	:=	0x33
FFpow[	7	]	:=	0x55
FFpow[	8	]	:=	0xFF
FFpow[	9	]	:=	0x1A
FFpow[	10	]	:=	0x2E
FFpow[	11	]	:=	0x72
FFpow[	12	]	:=	0x96
FFpow[	13	]	:=	0xA1
FFpow[	14	]	:=	0xF8
FFpow[	15	]	:=	0x13
FFpow[	16	]	:=	0x35
FFpow[	17	]	:=	0x5F
FFpow[	18	]	:=	0xE1
FFpow[	19	]	:=	0x38
FFpow[	20	]	:=	0x48
FFpow[	21	]	:=	0xD8
FFpow[	22	]	:=	0x73
FFpow[	23	]	:=	0x95
FFpow[	24	]	:=	0xA4
FFpow[	25	]	:=	0xF7
FFpow[	26	]	:=	0x02
FFpow[	27	]	:=	0x06
FFpow[	28	]	:=	0x0A
FFpow[	29	]	:=	0x1E
FFpow[	30	]	:=	0x22
FFpow[	31	]	:=	0x66
FFpow[	32	]	:=	0xAA
FFpow[	33	]	:=	0xE5
FFpow[	34	]	:=	0x34
FFpow[	35	]	:=	0x5C
FFpow[	36	]	:=	0xE4
FFpow[	37	]	:=	0x37
FFpow[	38	]	:=	0x59
FFpow[	39	]	:=	0xEB
FFpow[	40	]	:=	0x26
FFpow[	41	]	:=	0x6A
FFpow[	42	]	:=	0xBE
FFpow[	43	]	:=	0xD9
FFpow[	44	]	:=	0x70
FFpow[	45	]	:=	0x90
FFpow[	46	]	:=	0xAB
FFpow[	47	]	:=	0xE6
FFpow[	48	]	:=	0x31
FFpow[	49	]	:=	0x53
FFpow[	50	]	:=	0xF5
FFpow[	51	]	:=	0x04
FFpow[	52	]	:=	0x0C
FFpow[	53	]	:=	0x14
FFpow[	54	]	:=	0x3C
FFpow[	55	]	:=	0x44
FFpow[	56	]	:=	0xCC
FFpow[	57	]	:=	0x4F
FFpow[	58	]	:=	0xD1
FFpow[	59	]	:=	0x68
FFpow[	60	]	:=	0xB8
FFpow[	61	]	:=	0xD3
FFpow[	62	]	:=	0x6E
FFpow[	63	]	:=	0xB2
FFpow[	64	]	:=	0xCD
FFpow[	65	]	:=	0x4C
FFpow[	66	]	:=	0xD4
FFpow[	67	]	:=	0x67
FFpow[	68	]	:=	0xA9
FFpow[	69	]	:=	0xE0
FFpow[	70	]	:=	0x3B
FFpow[	71	]	:=	0x4D
FFpow[	72	]	:=	0xD7
FFpow[	73	]	:=	0x62
FFpow[	74	]	:=	0xA6
FFpow[	75	]	:=	0xF1
FFpow[	76	]	:=	0x08
FFpow[	77	]	:=	0x18
FFpow[	78	]	:=	0x28
FFpow[	79	]	:=	0x78
FFpow[	80	]	:=	0x88
FFpow[	81	]	:=	0x83
FFpow[	82	]	:=	0x9E
FFpow[	83	]	:=	0xB9
FFpow[	84	]	:=	0xD0
FFpow[	85	]	:=	0x6B
FFpow[	86	]	:=	0xBD
FFpow[	87	]	:=	0xDC
FFpow[	88	]	:=	0x7F
FFpow[	89	]	:=	0x81
FFpow[	90	]	:=	0x98
FFpow[	91	]	:=	0xB3
FFpow[	92	]	:=	0xCE
FFpow[	93	]	:=	0x49
FFpow[	94	]	:=	0xDB
FFpow[	95	]	:=	0x76
FFpow[	96	]	:=	0x9A
FFpow[	97	]	:=	0xB5
FFpow[	98	]	:=	0xC4
FFpow[	99	]	:=	0x57
FFpow[	100	]	:=	0xF9
FFpow[	101	]	:=	0x10
FFpow[	102	]	:=	0x30
FFpow[	103	]	:=	0x50
FFpow[	104	]	:=	0xF0
FFpow[	105	]	:=	0x0B
FFpow[	106	]	:=	0x1D
FFpow[	107	]	:=	0x27
FFpow[	108	]	:=	0x69
FFpow[	109	]	:=	0xBB
FFpow[	110	]	:=	0xD6
FFpow[	111	]	:=	0x61
FFpow[	112	]	:=	0xA3
FFpow[	113	]	:=	0xFE
FFpow[	114	]	:=	0x19
FFpow[	115	]	:=	0x2B
FFpow[	116	]	:=	0x7D
FFpow[	117	]	:=	0x87
FFpow[	118	]	:=	0x92
FFpow[	119	]	:=	0xAD
FFpow[	120	]	:=	0xEC
FFpow[	121	]	:=	0x2F
FFpow[	122	]	:=	0x71
FFpow[	123	]	:=	0x93
FFpow[	124	]	:=	0xAE
FFpow[	125	]	:=	0xE9
FFpow[	126	]	:=	0x20
FFpow[	127	]	:=	0x60
FFpow[	128	]	:=	0xA0
FFpow[	129	]	:=	0xFB
FFpow[	130	]	:=	0x16
FFpow[	131	]	:=	0x3A
FFpow[	132	]	:=	0x4E
FFpow[	133	]	:=	0xD2
FFpow[	134	]	:=	0x6D
FFpow[	135	]	:=	0xB7
FFpow[	136	]	:=	0xC2
FFpow[	137	]	:=	0x5D
FFpow[	138	]	:=	0xE7
FFpow[	139	]	:=	0x32
FFpow[	140	]	:=	0x56
FFpow[	141	]	:=	0xFA
FFpow[	142	]	:=	0x15
FFpow[	143	]	:=	0x3F
FFpow[	144	]	:=	0x41
FFpow[	145	]	:=	0xC3
FFpow[	146	]	:=	0x5E
FFpow[	147	]	:=	0xE2
FFpow[	148	]	:=	0x3D
FFpow[	149	]	:=	0x47
FFpow[	150	]	:=	0xC9
FFpow[	151	]	:=	0x40
FFpow[	152	]	:=	0xC0
FFpow[	153	]	:=	0x5B
FFpow[	154	]	:=	0xED
FFpow[	155	]	:=	0x2C
FFpow[	156	]	:=	0x74
FFpow[	157	]	:=	0x9C
FFpow[	158	]	:=	0xBF
FFpow[	159	]	:=	0xDA
FFpow[	160	]	:=	0x75
FFpow[	161	]	:=	0x9F
FFpow[	162	]	:=	0xBA
FFpow[	163	]	:=	0xD5
FFpow[	164	]	:=	0x64
FFpow[	165	]	:=	0xAC
FFpow[	166	]	:=	0xEF
FFpow[	167	]	:=	0x2A
FFpow[	168	]	:=	0x7E
FFpow[	169	]	:=	0x82
FFpow[	170	]	:=	0x9D
FFpow[	171	]	:=	0xBC
FFpow[	172	]	:=	0xDF
FFpow[	173	]	:=	0x7A
FFpow[	174	]	:=	0x8E
FFpow[	175	]	:=	0x89
FFpow[	176	]	:=	0x80
FFpow[	177	]	:=	0x9B
FFpow[	178	]	:=	0xB6
FFpow[	179	]	:=	0xC1
FFpow[	180	]	:=	0x58
FFpow[	181	]	:=	0xE8
FFpow[	182	]	:=	0x23
FFpow[	183	]	:=	0x65
FFpow[	184	]	:=	0xAF
FFpow[	185	]	:=	0xEA
FFpow[	186	]	:=	0x25
FFpow[	187	]	:=	0x6F
FFpow[	188	]	:=	0xB1
FFpow[	189	]	:=	0xC8
FFpow[	190	]	:=	0x43
FFpow[	191	]	:=	0xC5
FFpow[	192	]	:=	0x54
FFpow[	193	]	:=	0xFC
FFpow[	194	]	:=	0x1F
FFpow[	195	]	:=	0x21
FFpow[	196	]	:=	0x63
FFpow[	197	]	:=	0xA5
FFpow[	198	]	:=	0xF4
FFpow[	199	]	:=	0x07
FFpow[	200	]	:=	0x09
FFpow[	201	]	:=	0x1B
FFpow[	202	]	:=	0x2D
FFpow[	203	]	:=	0x77
FFpow[	204	]	:=	0x99
FFpow[	205	]	:=	0xB0
FFpow[	206	]	:=	0xCB
FFpow[	207	]	:=	0x46
FFpow[	208	]	:=	0xCA
FFpow[	209	]	:=	0x45
FFpow[	210	]	:=	0xCF
FFpow[	211	]	:=	0x4A
FFpow[	212	]	:=	0xDE
FFpow[	213	]	:=	0x79
FFpow[	214	]	:=	0x8B
FFpow[	215	]	:=	0x86
FFpow[	216	]	:=	0x91
FFpow[	217	]	:=	0xA8
FFpow[	218	]	:=	0xE3
FFpow[	219	]	:=	0x3E
FFpow[	220	]	:=	0x42
FFpow[	221	]	:=	0xC6
FFpow[	222	]	:=	0x51
FFpow[	223	]	:=	0xF3
FFpow[	224	]	:=	0x0E
FFpow[	225	]	:=	0x12
FFpow[	226	]	:=	0x36
FFpow[	227	]	:=	0x5A
FFpow[	228	]	:=	0xEE
FFpow[	229	]	:=	0x29
FFpow[	230	]	:=	0x7B
FFpow[	231	]	:=	0x8D
FFpow[	232	]	:=	0x8C
FFpow[	233	]	:=	0x8F
FFpow[	234	]	:=	0x8A
FFpow[	235	]	:=	0x85
FFpow[	236	]	:=	0x94
FFpow[	237	]	:=	0xA7
FFpow[	238	]	:=	0xF2
FFpow[	239	]	:=	0x0D
FFpow[	240	]	:=	0x17
FFpow[	241	]	:=	0x39
FFpow[	242	]	:=	0x4B
FFpow[	243	]	:=	0xDD
FFpow[	244	]	:=	0x7C
FFpow[	245	]	:=	0x84
FFpow[	246	]	:=	0x97
FFpow[	247	]	:=	0xA2
FFpow[	248	]	:=	0xFD
FFpow[	249	]	:=	0x1C
FFpow[	250	]	:=	0x24
FFpow[	251	]	:=	0x6C
FFpow[	252	]	:=	0xB4
FFpow[	253	]	:=	0xC7
FFpow[	254	]	:=	0x52
FFpow[	255	]	:=	0xF6
FFpow[	256	]	:=	0x01
FFpow[	257	]	:=	0x03
FFpow[	258	]	:=	0x05
FFpow[	259	]	:=	0x0F
FFpow[	260	]	:=	0x11
FFpow[	261	]	:=	0x33
FFpow[	262	]	:=	0x55
FFpow[	263	]	:=	0xFF
FFpow[	264	]	:=	0x1A
FFpow[	265	]	:=	0x2E
FFpow[	266	]	:=	0x72
FFpow[	267	]	:=	0x96
FFpow[	268	]	:=	0xA1
FFpow[	269	]	:=	0xF8
FFpow[	270	]	:=	0x13
FFpow[	271	]	:=	0x35
FFpow[	272	]	:=	0x5F
FFpow[	273	]	:=	0xE1
FFpow[	274	]	:=	0x38
FFpow[	275	]	:=	0x48
FFpow[	276	]	:=	0xD8
FFpow[	277	]	:=	0x73
FFpow[	278	]	:=	0x95
FFpow[	279	]	:=	0xA4
FFpow[	280	]	:=	0xF7
FFpow[	281	]	:=	0x02
FFpow[	282	]	:=	0x06
FFpow[	283	]	:=	0x0A
FFpow[	284	]	:=	0x1E
FFpow[	285	]	:=	0x22
FFpow[	286	]	:=	0x66
FFpow[	287	]	:=	0xAA
FFpow[	288	]	:=	0xE5
FFpow[	289	]	:=	0x34
FFpow[	290	]	:=	0x5C
FFpow[	291	]	:=	0xE4
FFpow[	292	]	:=	0x37
FFpow[	293	]	:=	0x59
FFpow[	294	]	:=	0xEB
FFpow[	295	]	:=	0x26
FFpow[	296	]	:=	0x6A
FFpow[	297	]	:=	0xBE
FFpow[	298	]	:=	0xD9
FFpow[	299	]	:=	0x70
FFpow[	300	]	:=	0x90
FFpow[	301	]	:=	0xAB
FFpow[	302	]	:=	0xE6
FFpow[	303	]	:=	0x31
FFpow[	304	]	:=	0x53
FFpow[	305	]	:=	0xF5
FFpow[	306	]	:=	0x04
FFpow[	307	]	:=	0x0C
FFpow[	308	]	:=	0x14
FFpow[	309	]	:=	0x3C
FFpow[	310	]	:=	0x44
FFpow[	311	]	:=	0xCC
FFpow[	312	]	:=	0x4F
FFpow[	313	]	:=	0xD1
FFpow[	314	]	:=	0x68
FFpow[	315	]	:=	0xB8
FFpow[	316	]	:=	0xD3
FFpow[	317	]	:=	0x6E
FFpow[	318	]	:=	0xB2
FFpow[	319	]	:=	0xCD
FFpow[	320	]	:=	0x4C
FFpow[	321	]	:=	0xD4
FFpow[	322	]	:=	0x67
FFpow[	323	]	:=	0xA9
FFpow[	324	]	:=	0xE0
FFpow[	325	]	:=	0x3B
FFpow[	326	]	:=	0x4D
FFpow[	327	]	:=	0xD7
FFpow[	328	]	:=	0x62
FFpow[	329	]	:=	0xA6
FFpow[	330	]	:=	0xF1
FFpow[	331	]	:=	0x08
FFpow[	332	]	:=	0x18
FFpow[	333	]	:=	0x28
FFpow[	334	]	:=	0x78
FFpow[	335	]	:=	0x88
FFpow[	336	]	:=	0x83
FFpow[	337	]	:=	0x9E
FFpow[	338	]	:=	0xB9
FFpow[	339	]	:=	0xD0
FFpow[	340	]	:=	0x6B
FFpow[	341	]	:=	0xBD
FFpow[	342	]	:=	0xDC
FFpow[	343	]	:=	0x7F
FFpow[	344	]	:=	0x81
FFpow[	345	]	:=	0x98
FFpow[	346	]	:=	0xB3
FFpow[	347	]	:=	0xCE
FFpow[	348	]	:=	0x49
FFpow[	349	]	:=	0xDB
FFpow[	350	]	:=	0x76
FFpow[	351	]	:=	0x9A
FFpow[	352	]	:=	0xB5
FFpow[	353	]	:=	0xC4
FFpow[	354	]	:=	0x57
FFpow[	355	]	:=	0xF9
FFpow[	356	]	:=	0x10
FFpow[	357	]	:=	0x30
FFpow[	358	]	:=	0x50
FFpow[	359	]	:=	0xF0
FFpow[	360	]	:=	0x0B
FFpow[	361	]	:=	0x1D
FFpow[	362	]	:=	0x27
FFpow[	363	]	:=	0x69
FFpow[	364	]	:=	0xBB
FFpow[	365	]	:=	0xD6
FFpow[	366	]	:=	0x61
FFpow[	367	]	:=	0xA3
FFpow[	368	]	:=	0xFE
FFpow[	369	]	:=	0x19
FFpow[	370	]	:=	0x2B
FFpow[	371	]	:=	0x7D
FFpow[	372	]	:=	0x87
FFpow[	373	]	:=	0x92
FFpow[	374	]	:=	0xAD
FFpow[	375	]	:=	0xEC
FFpow[	376	]	:=	0x2F
FFpow[	377	]	:=	0x71
FFpow[	378	]	:=	0x93
FFpow[	379	]	:=	0xAE
FFpow[	380	]	:=	0xE9
FFpow[	381	]	:=	0x20
FFpow[	382	]	:=	0x60
FFpow[	383	]	:=	0xA0
FFpow[	384	]	:=	0xFB
FFpow[	385	]	:=	0x16
FFpow[	386	]	:=	0x3A
FFpow[	387	]	:=	0x4E
FFpow[	388	]	:=	0xD2
FFpow[	389	]	:=	0x6D
FFpow[	390	]	:=	0xB7
FFpow[	391	]	:=	0xC2
FFpow[	392	]	:=	0x5D
FFpow[	393	]	:=	0xE7
FFpow[	394	]	:=	0x32
FFpow[	395	]	:=	0x56
FFpow[	396	]	:=	0xFA
FFpow[	397	]	:=	0x15
FFpow[	398	]	:=	0x3F
FFpow[	399	]	:=	0x41
FFpow[	400	]	:=	0xC3
FFpow[	401	]	:=	0x5E
FFpow[	402	]	:=	0xE2
FFpow[	403	]	:=	0x3D
FFpow[	404	]	:=	0x47
FFpow[	405	]	:=	0xC9
FFpow[	406	]	:=	0x40
FFpow[	407	]	:=	0xC0
FFpow[	408	]	:=	0x5B
FFpow[	409	]	:=	0xED
FFpow[	410	]	:=	0x2C
FFpow[	411	]	:=	0x74
FFpow[	412	]	:=	0x9C
FFpow[	413	]	:=	0xBF
FFpow[	414	]	:=	0xDA
FFpow[	415	]	:=	0x75
FFpow[	416	]	:=	0x9F
FFpow[	417	]	:=	0xBA
FFpow[	418	]	:=	0xD5
FFpow[	419	]	:=	0x64
FFpow[	420	]	:=	0xAC
FFpow[	421	]	:=	0xEF
FFpow[	422	]	:=	0x2A
FFpow[	423	]	:=	0x7E
FFpow[	424	]	:=	0x82
FFpow[	425	]	:=	0x9D
FFpow[	426	]	:=	0xBC
FFpow[	427	]	:=	0xDF
FFpow[	428	]	:=	0x7A
FFpow[	429	]	:=	0x8E
FFpow[	430	]	:=	0x89
FFpow[	431	]	:=	0x80
FFpow[	432	]	:=	0x9B
FFpow[	433	]	:=	0xB6
FFpow[	434	]	:=	0xC1
FFpow[	435	]	:=	0x58
FFpow[	436	]	:=	0xE8
FFpow[	437	]	:=	0x23
FFpow[	438	]	:=	0x65
FFpow[	439	]	:=	0xAF
FFpow[	440	]	:=	0xEA
FFpow[	441	]	:=	0x25
FFpow[	442	]	:=	0x6F
FFpow[	443	]	:=	0xB1
FFpow[	444	]	:=	0xC8
FFpow[	445	]	:=	0x43
FFpow[	446	]	:=	0xC5
FFpow[	447	]	:=	0x54
FFpow[	448	]	:=	0xFC
FFpow[	449	]	:=	0x1F
FFpow[	450	]	:=	0x21
FFpow[	451	]	:=	0x63
FFpow[	452	]	:=	0xA5
FFpow[	453	]	:=	0xF4
FFpow[	454	]	:=	0x07
FFpow[	455	]	:=	0x09
FFpow[	456	]	:=	0x1B
FFpow[	457	]	:=	0x2D
FFpow[	458	]	:=	0x77
FFpow[	459	]	:=	0x99
FFpow[	460	]	:=	0xB0
FFpow[	461	]	:=	0xCB
FFpow[	462	]	:=	0x46
FFpow[	463	]	:=	0xCA
FFpow[	464	]	:=	0x45
FFpow[	465	]	:=	0xCF
FFpow[	466	]	:=	0x4A
FFpow[	467	]	:=	0xDE
FFpow[	468	]	:=	0x79
FFpow[	469	]	:=	0x8B
FFpow[	470	]	:=	0x86
FFpow[	471	]	:=	0x91
FFpow[	472	]	:=	0xA8
FFpow[	473	]	:=	0xE3
FFpow[	474	]	:=	0x3E
FFpow[	475	]	:=	0x42
FFpow[	476	]	:=	0xC6
FFpow[	477	]	:=	0x51
FFpow[	478	]	:=	0xF3
FFpow[	479	]	:=	0x0E
FFpow[	480	]	:=	0x12
FFpow[	481	]	:=	0x36
FFpow[	482	]	:=	0x5A
FFpow[	483	]	:=	0xEE
FFpow[	484	]	:=	0x29
FFpow[	485	]	:=	0x7B
FFpow[	486	]	:=	0x8D
FFpow[	487	]	:=	0x8C
FFpow[	488	]	:=	0x8F
FFpow[	489	]	:=	0x8A
FFpow[	490	]	:=	0x85
FFpow[	491	]	:=	0x94
FFpow[	492	]	:=	0xA7
FFpow[	493	]	:=	0xF2
FFpow[	494	]	:=	0x0D
FFpow[	495	]	:=	0x17
FFpow[	496	]	:=	0x39
FFpow[	497	]	:=	0x4B
FFpow[	498	]	:=	0xDD
FFpow[	499	]	:=	0x7C
FFpow[	500	]	:=	0x84
FFpow[	501	]	:=	0x97
FFpow[	502	]	:=	0xA2
FFpow[	503	]	:=	0xFD
FFpow[	504	]	:=	0x1C
FFpow[	505	]	:=	0x24
FFpow[	506	]	:=	0x6C
FFpow[	507	]	:=	0xB4
FFpow[	508	]	:=	0xC7
FFpow[	509	]	:=	0x52
FFpow[	510	]	:=	0xF6

// initialise keyshedule128[44,4]:
for i:=1 to 44
	for j:=1 to 4
		keyshedule128[i,j]:=fb
	next
next
for i:=1 to 16
	initialKey[i]:=fb
next
for i:=1 to 4
	for j:=1 to 4
		state[i,j]:=fb
	next
next
oSha:=ShaTwo{}
 
return self
method invMixColumns()   class AES128
local t as array
local i,j as int
t:=ArrayNew(4,4)

for i:=1 to 4
	for j:=1 to 4
		t[i,j]:=state[i,j]
	next
next

for i:=1 to 4
	for j:=1 to 4
		state[i, j] := _xor(;
		Shortint(_cast,self:FFMul(c, t[i, j])),;
		Shortint(_cast,self:FFMul(d, t[i, Mod(j,4)+1])),;
		Shortint(_cast,self:FFMul(e, t[i, Mod(j+1,4)+1])),;
		Shortint(_cast,self:FFMul(f, t[i, Mod(j+2,4)+1]))  )
	next
next
return nil
method invshiftRows()     class AES128
local temp1, temp2 as byte 
  temp1 := state[1, 2]
  temp2 := state[3, 2]
  state[1, 2] := state[4, 2]
  state[3, 2] := state[2, 2]
  state[2, 2] := temp1
  state[4, 2] := temp2
  temp1 := state[4, 3]
  temp2 := state[1, 3]
  state[1, 3] := state[3, 3]
  state[4, 3] := state[2, 3]
  state[2, 3] := temp1
  state[3, 3] := temp2
  temp1 := state[1, 4]
  state[1, 4] := state[2, 4]
  state[2, 4] := state[3, 4]
  state[3, 4] := state[4, 4]
  state[4, 4] := temp1
return nil
method invsubBytes() class AES128
local i,j,nPtr as int
for i:=1 to 4
	for j:=1 to 4
		nPtr:=state[i,j] +1
		state[i,j]:=sBoxinv[nPtr ]
	next
next
return
method keyExpansion128() class AES128
local i, j, nPtr as  int,;
dim temp[4] is byte,;
dim temp2[4] is byte,;
btemp is byte,;
ntemp2:=4 is byte, nt as shortint

for i := 1 to 4 
	for j := 1 to 4 
    	keyshedule128[i, j] := initialKey[4 * (i-1) + j]
	next
next
for i := 5 to 44 
	for j := 1 to 4
		temp[j] := keyshedule128[i - 1, j]
	next
	if Mod(i,4) = 1
		// rotate left:
		btemp:=temp[1]
		temp[1]:=temp[2]
		temp[2]:=temp[3]
		temp[3]:=temp[4]
		temp[4]:=btemp
		// subword:
		for j := 1 to 4 
			nPtr:=temp[j]
		   temp[j] := sBox[nPtr+1]
		next 
		// getRCon:
		for j:=1 to 4
			temp2[j]:=0x00
		next
		nt:=shortint((i-1)/4)-1   // trunc(i/4)
		if nt < 8
			ntemp2:=shortint(2**nt)
    		temp2[1] := ntemp2
		elseif nt  == 8 
		    temp2[1] := 0x1B
		else
			temp2[1] := 0x36
		endif
		// xorWord:
		for j:=1 to 4
			temp[j]:=_xor(shortint(_cast,temp[j]),shortint(_cast,temp2[j]))
		next
	endif
	for j := 1 to 4
      keyshedule128[i, j] := _xor(shortint(_cast,keyshedule128[i - 4, j]),shortint(_cast,temp[j]))
	next

next
return
method mixcolumns() class AES128
local t as array
local i,j as int
t:=ArrayNew(4,4)

for i:=1 to 4
	for j:=1 to 4
		t[i,j]:=state[i,j]
	next
next

for i:=1 to 4
	for j:=1 to 4
		state[i, j] := _xor(;
		shortint(_cast,self:FFMul(a, t[i, j])),;
		shortint(_cast,self:FFMul(b, t[i, Mod(j,4)+1])),;
		shortint(_cast,t[i, Mod(j+1,4)+1]),;
		shortint(_cast,t[i, Mod(j+2,4)+1])  )
	next
next
return nil
method setkey(f_key as string ) as void   class AES128 
// set key for encypt/decrypt
Local f_key_hex, f_hash as string
if !f_key==key_in
	key_in:=f_key
	f_hash:=oSha:hash(f_key)
	f_key_hex:=SubStr(f_hash,19,32)
	self:cStat:=oSha:cStat
	self:cStatVK := oSha:cStatVK

	self:convertKeyString(f_key_hex )
	self:keyExpansion128()
endif
return
method shiftRows()   class AES128
local temp1, temp2 as byte 
  temp1 := state[1, 2]
  state[1, 2] := state[2, 2]
  state[2, 2] := state[3, 2]
  state[3, 2] := state[4, 2]
  state[4, 2] := temp1
  temp1 := state[1, 3]
  temp2 := state[2, 3]
  state[1, 3] := state[3, 3]
  state[2, 3] := state[4, 3]
  state[3, 3] := temp1
  state[4, 3] := temp2
  temp1 := state[1, 4]
  state[1, 4] := state[4, 4]
  state[4, 4] := state[3, 4]
  state[3, 4] := state[2, 4]
  state[2, 4] := temp1
return nil
method subBytes() class AES128
local i,j,nPtr as int
for i:=1 to 4
	for j:=1 to 4
		nPtr:=state[i,j] +1
		state[i,j]:=sBox[nPtr]
	next
next
return
method xorRoundKey() class AES128
local i, j as int
for i:=1 to 4
	for j:=1 to 4
		// get next key 
  		self:state[i, j] := _xor(shortint(_cast,self:state[i, j]),shortint(_cast,self:keyshedule128[self:keycounter, j]))
	next
	self:keycounter+=1
next  
return
function AESDecrypt(f_key as string,f_bufferstr as string ) as string 
local oAES as AES128
local cRes as string 
oAES:=AES128{} 
oAES:setkey(f_key)
cRes:=oAES:decrypt(f_key,f_bufferstr)
// if !isalphanumeric(StrTran(cRes," ",""))
// 	oAES:=null_object
// 	oAES:=AES128{}
// 	oAES:setkey(f_key)
// 	cRes:=oAES:decrypt(f_key,f_bufferstr)
// endif
oAES:=null_object

return cRes
// return (AES128{}):decrypt(f_key,f_bufferstr) 
function AESEncrypt(f_key as string,f_bufferstr as string ) as string 
local oAES as AES128
local cRes as string 
oAES:=AES128{} 
oAES:setkey(f_key)
cRes:=oAES:encrypt(f_key,f_bufferstr)
oAES:=null_object

return cRes

// return (AES128{}):encrypt(f_key,f_bufferstr) 
