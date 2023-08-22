{
    $Id: crc.pas,v 1.6 06/08/31 03:07:36 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    CRC and Chekcsum routines    
    
    See License.txt for more information on the licensing terms
    for this source code.
    
 **********************************************************************}
{** @author(Carl Eric Codere) 
    @abstract(CRC and checksum generation unit)
    
    CRC and checksum generation routines, 
    compatible with ISO 3309 and ITU-T-V42 among others.
    
    
}
Unit crc_checks;

Interface

//uses xutils
   {tpautils,
   vpautils,
   fpautils,
   dpautils,
   gpautils }
  // ;


{ Some information:
   Name: The name of the algorithm
   Init: The initial value to use
   XorOut: The final result should be xored
           with this value. 0 indicates no xor
           necessary.
   Check: The resulting value against the
          ASCII string 1234565789

   Name   : "CCITT CRC-32"
   Origin : ITU-T,pkzip,ISO 3309
   Width  : 32 bit
   Init   : FFFFFFFF
   XorOut : FFFFFFFF
   Check  : CBF43926

   Name   : "Adler32"
   Origin : IETF RFC 1950,gzip
   Width  : 32 bit
   Init   : 1
   XorOut : 00000000
   Check  : 091E01DE

   Name   : "CCITT CRC-16"
   Origin : ITU,X.25
   Width  : 16 bit
   Init   : FFFF
   XorOut : 0000
   Check  : 29B1 (unsure, since a particular
     web site this indicates this is wrong,
     but this concords with all other
     implementation).

   Name   : "Fletcher 8-bit"
   Origin : IETF RFC 1146
   Width  : 16 bit
   Init   : 0000
   XorOut : 0000
   Check  : DD15 (to be confirmed against
     another implementation).

   Name   : "CRC-16" (used by ARC)
   Origin : Rocksoft Model CRC Algorithm,ARC,
            'IEEE Micro' Aug 88 - A Tutorial on CRC Computations
   Width  : 16 bit
   Init   : 0000
   XorOut : 0000
   Check  : BB3D
}


{** @abstract(Calculates a CRC-32 CCITT value)
    Routine to get the CRC-32 CCITT value.

    Normally to be compatible with the ISO 3309 standard,
    the first call to this routine should set @code(InitCRC)
    to @code($FFFFFFFF), and the final result of the
    CRC-32 should be @code(XOR)'ed with $FFFFFFFF.
    
    @param(InitCRC The value of the previous CRC)
    @param(b The data byte to get the CRC-32 of)
    @returns(The updated CRC-32 value)
}    
function UpdateCrc32(InitCrc:longword; b: byte):longword;

{** @abstract(Calculates a CRC-16 CCITT value)
    Routine to get the CRC-16 CCITT value.
    
    Normally to be compatible with the CCITT standards,
    the first call to this routine should set @code(InitCRC)
    to @code($FFFF), and the final result of the
    CRC-16 should be taken as is.
    
    p.s : This has not been verified against hardware.
    
    @param(InitCRC The value of the previous CRC)
    @param(b The data byte to get the CRC-16 of)
    @returns(The updated CRC-16 value)
}    
function UpdateCrc16(InitCrc: word; b: byte): word;

{** @abstract(Calculates an Adler-32 checksum value)
    Routine to get the Adler-32 checksum as
    defined in IETF RFC 1950.
    
    Normally to be compatible with the standard,
    the first call to this routine should set @code(InitAdler)
    to @code(1), and the final result of the should be 
    taken as is.
    
    @param(InitAdler The value of the previous Adler32)
    @param(b The data byte to get the Adler32 of)
    @returns(The updated Adler32 value)
}    
function UpdateAdler32(InitAdler: longword; b: byte): longword;

{** @abstract(Calculates an 8-bit fletcher checksum value)
    Routine to get the Fletcher 8-bit checksum as
    defined in IETF RFC 1146
    
    Normally to be compatible with the standard,
    the first call to this routine should set @code(InitFletcher)
    to @code(0), and the final result of the should be 
    taken as is.
    
    @param(InitCRC The value of the previous Adler32)
    @param(b The data byte to get the Adler32 of)
    @returns(The updated Adler32 value)
}    
function UpdateFletcher8(InitFletcher: word; b: byte): word;

{** @abstract(Calculates a standard 16-bit CRC)
    Standard CRC-16 bit algorithm as used in the ARC archiver.
    
    The first call to this routine should set @code(InitCRC)
    to @code(0), and the final result of the should be 
    taken as is.
    
    @param(InitCRC The value of the previous Crc)
    @param(b The data byte to get the Crc of)
    @returns(The updated Crc value)
}    
function UpdateCRC(InitCrc: word; b: byte): word;

{** @exclude }
const crctable32:array[0..255] of longword = (
  $00000000, $77073096, $ee0e612c, $990951ba,
  $076dc419, $706af48f, $e963a535, $9e6495a3,
  $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988,
  $09b64c2b, $7eb17cbd, $e7b82d07, $90bf1d91,
  $1db71064, $6ab020f2, $f3b97148, $84be41de,
  $1adad47d, $6ddde4eb, $f4d4b551, $83d385c7,
  $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec,
  $14015c4f, $63066cd9, $fa0f3d63, $8d080df5,
  $3b6e20c8, $4c69105e, $d56041e4, $a2677172,
  $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b,
  $35b5a8fa, $42b2986c, $dbbbc9d6, $acbcf940,
  $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59,
  $26d930ac, $51de003a, $c8d75180, $bfd06116,
  $21b4f4b5, $56b3c423, $cfba9599, $b8bda50f,
  $2802b89e, $5f058808, $c60cd9b2, $b10be924,
  $2f6f7c87, $58684c11, $c1611dab, $b6662d3d,
  $76dc4190, $01db7106, $98d220bc, $efd5102a,
  $71b18589, $06b6b51f, $9fbfe4a5, $e8b8d433,
  $7807c9a2, $0f00f934, $9609a88e, $e10e9818,
  $7f6a0dbb, $086d3d2d, $91646c97, $e6635c01,
  $6b6b51f4, $1c6c6162, $856530d8, $f262004e,
  $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457,
  $65b0d9c6, $12b7e950, $8bbeb8ea, $fcb9887c,
  $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65,
  $4db26158, $3ab551ce, $a3bc0074, $d4bb30e2,
  $4adfa541, $3dd895d7, $a4d1c46d, $d3d6f4fb,
  $4369e96a, $346ed9fc, $ad678846, $da60b8d0,
  $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9,
  $5005713c, $270241aa, $be0b1010, $c90c2086,
  $5768b525, $206f85b3, $b966d409, $ce61e49f,
  $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4,
  $59b33d17, $2eb40d81, $b7bd5c3b, $c0ba6cad,
  $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a,
  $ead54739, $9dd277af, $04db2615, $73dc1683,
  $e3630b12, $94643b84, $0d6d6a3e, $7a6a5aa8,
  $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1,
  $f00f9344, $8708a3d2, $1e01f268, $6906c2fe,
  $f762575d, $806567cb, $196c3671, $6e6b06e7,
  $fed41b76, $89d32be0, $10da7a5a, $67dd4acc,
  $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5,
  $d6d6a3e8, $a1d1937e, $38d8c2c4, $4fdff252,
  $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b,
  $d80d2bda, $af0a1b4c, $36034af6, $41047a60,
  $df60efc3, $a867df55, $316e8eef, $4669be79,
  $cb61b38c, $bc66831a, $256fd2a0, $5268e236,
  $cc0c7795, $bb0b4703, $220216b9, $5505262f,
  $c5ba3bbe, $b2bd0b28, $2bb45a92, $5cb36a04,
  $c2d7ffa7, $b5d0cf31, $2cd99e8b, $5bdeae1d,
  $9b64c2b0, $ec63f226, $756aa39c, $026d930a,
  $9c0906a9, $eb0e363f, $7785, $05005713,
  $95bf4a82, $e2b87a14, $7bb12bae, $0cb61b38,
  $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21,
  $86d3d2d4, $f1d4e242, $68ddb3f8, $1fda836e,
  $81be16cd, $f6b9265b, $6fb077e1, $18b74777,
  $88085ae6, $ff0f6a70, $66063bca, $11010b5c,
  $8f659eff, $f862ae69, $616bffd3, $166ccf45,
  $a00ae278, $d70dd2ee, $4e048354, $3903b3c2,
  $a7672661, $d06016f7, $4969474d, $3e6e77db,
  $aed16a4a, $d9d65adc, $40df0b66, $37d83bf0,
  $a9bcae53, $debb9ec5, $47b2cf7f, $30b5ffe9,
  $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6,
  $bad03605, $cdd70693, $54de5729, $23d967bf,
  $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94,
  $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d
);

(* crctab calculated by Mark G. Mendel, Network Systems Corporation *)
{** @exclude }
CONST crctable16ccitt: ARRAY[0..255] OF WORD = 
(
    $0000,  $1021,  $2042,  $3063,  $4084,  $50a5,  $60c6,  $70e7,
    $8108,  $9129,  $a14a,  $b16b,  $c18c,  $d1ad,  $e1ce,  $f1ef,
    $1231,  $0210,  $3273,  $2252,  $52b5,  $4294,  $72f7,  $62d6,
    $9339,  $8318,  $b37b,  $a35a,  $d3bd,  $c39c,  $f3ff,  $e3de,
    $2462,  $3443,  $0420,  $1401,  $64e6,  $74c7,  $44a4,  $5485,
    $a56a,  $b54b,  $8528,  $9509,  $e5ee,  $f5cf,  $c5ac,  $d58d,
    $3653,  $2672,  $1611,  $0630,  $76d7,  $66f6,  $5695,  $46b4,
    $b75b,  $a77a,  $9719,  $8738,  $f7df,  $e7fe,  $d79d,  $c7bc,
    $48c4,  $58e5,  $6886,  $78a7,  $0840,  $1861,  $2802,  $3823,
    $c9cc,  $d9ed,  $e98e,  $f9af,  $8948,  $9969,  $a90a,  $b92b,
    $5af5,  $4ad4,  $7ab7,  $6a96,  $1a71,  $0a50,  $3a33,  $2a12,
    $dbfd,  $cbdc,  $fbbf,  $eb9e,  $9b79,  $8b58,  $bb3b,  $ab1a,
    $6ca6,  $7c87,  $4ce4,  $5cc5,  $2c22,  $3c03,  $0c60,  $1c41,
    $edae,  $fd8f,  $cdec,  $ddcd,  $ad2a,  $bd0b,  $8d68,  $9d49,
    $7e97,  $6eb6,  $5ed5,  $4ef4,  $3e13,  $2e32,  $1e51,  $0e70,
    $ff9f,  $efbe,  $dfdd,  $cffc,  $bf1b,  $af3a,  $9f59,  $8f78,
    $9188,  $81a9,  $b1ca,  $a1eb,  $d10c,  $c12d,  $f14e,  $e16f,
    $1080,  $00a1,  $30c2,  $20e3,  $5004,  $4025,  $7046,  $6067,
    $83b9,  $9398,  $a3fb,  $b3da,  $c33d,  $d31c,  $e37f,  $f35e,
    $02b1,  $1290,  $22f3,  $32d2,  $4235,  $5214,  $6277,  $7256,
    $b5ea,  $a5cb,  $95a8,  $8589,  $f56e,  $e54f,  $d52c,  $c50d,
    $34e2,  $24c3,  $14a0,  $0481,  $7466,  $6447,  $5424,  $4405,
    $a7db,  $b7fa,  $8799,  $97b8,  $e75f,  $f77e,  $c71d,  $d73c,
    $26d3,  $36f2,  $0691,  $16b0,  $6657,  $7676,  $4615,  $5634,
    $d94c,  $c96d,  $f90e,  $e92f,  $99c8,  $89e9,  $b98a,  $a9ab,
    $5844,  $4865,  $7806,  $6827,  $18c0,  $08e1,  $3882,  $28a3,
    $cb7d,  $db5c,  $eb3f,  $fb1e,  $8bf9,  $9bd8,  $abbb,  $bb9a,
    $4a75,  $5a54,  $6a37,  $7a16,  $0af1,  $1ad0,  $2ab3,  $3a92,
    $fd2e,  $ed0f,  $dd6c,  $cd4d,  $bdaa,  $ad8b,  $9de8,  $8dc9,
    $7c26,  $6c07,  $5c64,  $4c45,  $3ca2,  $2c83,  $1ce0,  $0cc1,
    $ef1f,  $ff3e,  $cf5d,  $df7c,  $af9b,  $bfba,  $8fd9,  $9ff8,
    $6e17,  $7e36,  $4e55,  $5e74,  $2e93,  $3eb2,  $0ed1,  $1ef0
);

{** @exclude }
CONST crctable16_2: ARRAY[0..255] OF WORD = 
(
    $00000,$0C0C1,$0C181,$00140,$0C301,$003C0,$00280,$0C241,
    $0C601,$006C0,$00780,$0C741,$00500,$0C5C1,$0C481,$00440,
    $0CC01,$00CC0,$00D80,$0CD41,$00F00,$0CFC1,$0CE81,$00E40,
    $00A00,$0CAC1,$0CB81,$00B40,$0C901,$009C0,$00880,$0C841,
    $0D801,$018C0,$01980,$0D941,$01B00,$0DBC1,$0DA81,$01A40,
    $01E00,$0DEC1,$0DF81,$01F40,$0DD01,$01DC0,$01C80,$0DC41,
    $01400,$0D4C1,$0D581,$01540,$0D701,$017C0,$01680,$0D641,
    $0D201,$012C0,$01380,$0D341,$01100,$0D1C1,$0D081,$01040,
    $0F001,$030C0,$03180,$0F141,$03300,$0F3C1,$0F281,$03240,
    $03600,$0F6C1,$0F781,$03740,$0F501,$035C0,$03480,$0F441,
    $03C00,$0FCC1,$0FD81,$03D40,$0FF01,$03FC0,$03E80,$0FE41,
    $0FA01,$03AC0,$03B80,$0FB41,$03900,$0F9C1,$0F881,$03840,
    $02800,$0E8C1,$0E981,$02940,$0EB01,$02BC0,$02A80,$0EA41,
    $0EE01,$02EC0,$02F80,$0EF41,$02D00,$0EDC1,$0EC81,$02C40,
    $0E401,$024C0,$02580,$0E541,$02700,$0E7C1,$0E681,$02640,
    $02200,$0E2C1,$0E381,$02340,$0E101,$021C0,$02080,$0E041,
    $0A001,$060C0,$06180,$0A141,$06300,$0A3C1,$0A062,$06840,
    $06600,$0A6C1,$0A781,$06740,$0A501,$065C0,$06480,$0A441,
    $06C00,$0ACC1,$0AD81,$06D40,$0AF01,$06FC0,$06E80,$0AE41,
    $0AA01,$06AC0,$06B80,$0AB41,$06900,$0A9C1,$0A881,$06840,
    $07800,$0B8C1,$0B981,$07940,$0BB01,$07BC0,$07A80,$0BA41,
    $0BE01,$07EC0,$07F80,$0BF41,$07D00,$0BDC1,$0BC81,$07C40,
    $0B401,$074C0,$07580,$0B541,$07700,$0B7C1,$0B681,$07640,
    $07200,$0B2C1,$0B381,$07340,$0B101,$071C0,$07080,$0B041,
    $05000,$090C1,$09181,$05140,$09301,$053C0,$05280,$09241,
    $09601,$056C0,$05780,$09741,$05500,$095C1,$09481,$05440,
    $09C01,$05CC0,$05D80,$09D41,$05F00,$09FC1,$09E81,$05E40,
    $05A00,$09AC1,$09B81,$05B40,$09901,$059C0,$05880,$09841,
    $08801,$048C0,$04980,$08941,$04B00,$08BC1,$08A81,$04A40,
    $04E00,$08EC1,$08F81,$04F40,$08D01,$04DC0,$04C80,$08C41,
    $04400,$084C1,$08581,$04540,$08701,$047C0,$04680,$08641,
    $08201,$042C0,$04380,$08341,$04100,$081C1,$08081,$04040
);

CRCTable16: array[0..255] of Word = (
   $0000, $1021, $2042, $3063, $4084, $50A5, $60C6, $70E7,
   $8108, $9129, $A14A, $B16B, $C18C, $D1AD, $E1CE, $F1EF,
   $1231, $0210, $3273, $2252, $52B5, $4294, $72F7, $62D6,
   $9339, $8318, $B37B, $A35A, $D3BD, $C39C, $F3FF, $E3DE,
   $2462, $3443, $0420, $1401, $64E6, $74C7, $44A4, $5485,
   $A56A, $B54B, $8528, $9509, $E5EE, $F5CF, $C5AC, $D58D,
   $3653, $2672, $1611, $0630, $76D7, $66F6, $5695, $46B4,
   $B75B, $A77A, $9719, $8738, $F7DF, $E7FE, $D79D, $C7BC,
   $48C4, $58E5, $6886, $78A7, $0840, $1861, $2802, $3823,
   $C9CC, $D9ED, $E98E, $F9AF, $8948, $9969, $A90A, $B92B,
   $5AF5, $4AD4, $7AB7, $6A96, $1A71, $0A50, $3A33, $2A12,
   $DBFD, $CBDC, $FBBF, $EB9E, $9B79, $8B58, $BB3B, $AB1A,
   $6CA6, $7C87, $4CE4, $5CC5, $2C22, $3C03, $0C60, $1C41,
   $EDAE, $FD8F, $CDEC, $DDCD, $AD2A, $BD0B, $8D68, $9D49,
   $7E97, $6EB6, $5ED5, $4EF4, $3E13, $2E32, $1E51, $0E70,
   $FF9F, $EFBE, $DFDD, $CFFC, $BF1B, $AF3A, $9F59, $8F78,
   $9188, $81A9, $B1CA, $A1EB, $D10C, $C12D, $F14E, $E16F,
   $1080, $00A1, $30C2, $20E3, $5004, $4025, $7046, $6067,
   $83B9, $9398, $A3FB, $B3DA, $C33D, $D31C, $E37F, $F35E,
   $02B1, $1290, $22F3, $32D2, $4235, $5214, $6277, $7256,
   $B5EA, $A5CB, $95A8, $8589, $F56E, $E54F, $D52C, $C50D,
   $34E2, $24C3, $14A0, $0481, $7466, $6447, $5424, $4405,
   $A7DB, $B7FA, $8799, $97B8, $E75F, $F77E, $C71D, $D73C,
   $26D3, $36F2, $0691, $16B0, $6657, $7676, $4615, $5634,
   $D94C, $C96D, $F90E, $E92F, $99C8, $89E9, $B98A, $A9AB,
   $5844, $4865, $7806, $6827, $18C0, $08E1, $3882, $28A3,
   $CB7D, $DB5C, $EB3F, $FB1E, $8BF9, $9BD8, $ABBB, $BB9A,
   $4A75, $5A54, $6A37, $7A16, $0AF1, $1AD0, $2AB3, $3A92,
   $FD2E, $ED0F, $DD6C, $CD4D, $BDAA, $AD8B, $9DE8, $8DC9,
   $7C26, $6C07, $5C64, $4C45, $3CA2, $2C83, $1CE0, $0CC1,
   $EF1F, $FF3E, $CF5D, $DF7C, $AF9B, $BFBA, $8FD9, $9FF8,
   $6E17, $7E36, $4E55, $5E74, $2E93, $3EB2, $0ED1, $1EF0
    );


Implementation







{$ifopt R+}
{$define Range_Check_On}
{$R-}
{$endif}
Function UpdateCrc32(InitCrc:longword;b: byte):longword;
begin
  InitCRC := longword(InitCRC shr 8) xor longword(crctable32[byte(InitCRC) xor b]);
  UpdateCrc32:=InitCRC;
end;




{$ifdef Range_check_on}
{$R+}
{$undef Range_check_on}
{$endif Range_check_on}


function UpdateCrc16(InitCrc: word; b: byte): word;
begin
   UpdateCrc16 := crctable16ccitt[(((InitCrc SHR 8) XOR B) AND 255)] 
    XOR (InitCrc SHL 8);
end;


{$ifopt R+}
{$define Range_Check_On}
{$R-}
{$endif}
const
  BASE = 65521;
  
function UpdateAdler32(InitAdler: longword; b: byte):longword;
var
 s1,s2: longword;
begin
 s1:=InitAdler and $ffff;
 s2:= (InitAdler shr 16) and $ffff;
 s1:= (s1 + b) mod BASE;
 s2:= (s2 + s1) mod BASE;
 UpdateAdler32:=(s2 shl 16) +s1;
end;
{$ifdef Range_check_on}
{$R+}
{$undef Range_check_on}
{$endif Range_check_on}

function UpdateFletcher8(InitFletcher: word; b: byte): word;
var
 a,c: byte;
begin
  { 1st byte of data in memory }
  a:=(InitFletcher shr 8) and $ff;
  c:=InitFletcher and $ff;
  a:=(a + b) and $ff;
  c:=(c + a) and $ff;
  UpdateFletcher8:=(a shl 8) or c;
end;

function UpdateCRC(InitCrc: word; b: byte): word;
var
 crc: word;
 idx: integer;
begin
  crc:=InitCRC;
  idx:=(crc and $ff) xor b;
  crc:=crc shr 8;
  crc:= (crc xor crctable16[idx]) and $ffff;
  UpdateCrc:=crc;
end;

end.

{
  $Log: crc.pas,v $
  Revision 1.6  2006/08/31 03:07:36  carl
  + Better documentation

  Revision 1.5  2005/07/20 03:14:11  carl
   * Make the CRC tables public

  Revision 1.4  2004/11/19 01:37:27  carl
    + more documentation

  Revision 1.3  2004/08/27 02:10:32  carl
    + support for more checksum algorithms

  Revision 1.2  2004/06/20 18:49:37  carl
    + added  GPC support

  Revision 1.1  2004/05/05 16:28:18  carl
    Release 0.95 updates


}
