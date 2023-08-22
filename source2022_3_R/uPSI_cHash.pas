unit uPSI_cHash;
{
hash512 chash2  rename   mapping to overload
        SHA256DigestAsString(CalcSHA2562_(' const Buf : AnsiString'));

}
interface
 

 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_cHash = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THMAC_SHA512Hash(CL: TPSPascalCompiler);
procedure SIRegister_THMAC_SHA256Hash(CL: TPSPascalCompiler);
procedure SIRegister_THMAC_SHA1Hash(CL: TPSPascalCompiler);
procedure SIRegister_THMAC_MD5Hash(CL: TPSPascalCompiler);
procedure SIRegister_TSHA512Hash(CL: TPSPascalCompiler);
procedure SIRegister_TSHA256Hash2(CL: TPSPascalCompiler);
procedure SIRegister_TSHA1Hash(CL: TPSPascalCompiler);
procedure SIRegister_TMD5Hash(CL: TPSPascalCompiler);
procedure SIRegister_TELFHash(CL: TPSPascalCompiler);
procedure SIRegister_TAdler32Hash(CL: TPSPascalCompiler);
procedure SIRegister_TCRC32Hash(CL: TPSPascalCompiler);
procedure SIRegister_TCRC16Hash(CL: TPSPascalCompiler);
procedure SIRegister_TXOR32Hash(CL: TPSPascalCompiler);
procedure SIRegister_TXOR16Hash(CL: TPSPascalCompiler);
procedure SIRegister_TXOR8Hash(CL: TPSPascalCompiler);
procedure SIRegister_TChecksum32Hash(CL: TPSPascalCompiler);
procedure SIRegister_AHash(CL: TPSPascalCompiler);
procedure SIRegister_EHashError(CL: TPSPascalCompiler);
procedure SIRegister_cHash(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_THMAC_SHA512Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_THMAC_SHA256Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_THMAC_SHA1Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_THMAC_MD5Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSHA512Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSHA256Hash2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSHA1Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMD5Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TELFHash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAdler32Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCRC32Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCRC16Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXOR32Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXOR16Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXOR8Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChecksum32Hash(CL: TPSRuntimeClassImporter);
procedure RIRegister_AHash(CL: TPSRuntimeClassImporter);
procedure RIRegister_EHashError(CL: TPSRuntimeClassImporter);
procedure RIRegister_cHash_Routines(S: TPSExec);

procedure Register;

implementation


uses
   cHash2
  ;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cHash]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THMAC_SHA512Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'THMAC_SHA512Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'THMAC_SHA512Hash') do begin
    RegisterMethod('Function DigestSize : Integer');
    RegisterMethod('Function BlockSize : Integer');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THMAC_SHA256Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'THMAC_SHA256Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'THMAC_SHA256Hash') do begin
    RegisterMethod('Function DigestSize : Integer');
    RegisterMethod('Function BlockSize : Integer');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THMAC_SHA1Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'THMAC_SHA1Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'THMAC_SHA1Hash') do begin
    RegisterMethod('Function DigestSize : Integer');
    RegisterMethod('Function BlockSize : Integer');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THMAC_MD5Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'THMAC_MD5Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'THMAC_MD5Hash') do begin
    RegisterMethod('Function DigestSize : Integer');
    RegisterMethod('Function BlockSize : Integer');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSHA512Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TSHA512Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TSHA512Hash') do begin
  //RegisterMethod('Procedure Free');
    RegisterMethod('Function DigestSize : Integer');
    RegisterMethod('Function BlockSize : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSHA256Hash2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TSHA256Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TSHA256Hash2') do begin
    RegisterMethod('Function DigestSize : Integer');
    RegisterMethod('Function BlockSize : Integer');
    //RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSHA1Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TSHA1Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TSHA1Hash') do begin
    RegisterMethod('Function DigestSize : Integer');
    RegisterMethod('Function BlockSize : Integer');
    //RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMD5Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TMD5Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TMD5Hash') do
  begin
    RegisterMethod('Function DigestSize : Integer');
    RegisterMethod('Function BlockSize : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TELFHash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TELFHash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TELFHash') do
  begin
    RegisterMethod('Function DigestSize : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAdler32Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TAdler32Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TAdler32Hash') do
  begin
    RegisterMethod('Function DigestSize : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCRC32Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TCRC32Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TCRC32Hash') do
  begin
    RegisterMethod('Function DigestSize : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCRC16Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TCRC16Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TCRC16Hash') do
  begin
    RegisterMethod('Function DigestSize : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXOR32Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TXOR32Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TXOR32Hash') do
  begin
    RegisterMethod('Function DigestSize : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXOR16Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TXOR16Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TXOR16Hash') do
  begin
    RegisterMethod('Function DigestSize : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXOR8Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TXOR8Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TXOR8Hash') do
  begin
    RegisterMethod('Function DigestSize : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChecksum32Hash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AHash', 'TChecksum32Hash') do
  with CL.AddClassN(CL.FindClass('AHash'),'TChecksum32Hash') do
  begin
    RegisterMethod('Function DigestSize : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AHash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'AHash') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'AHash') do
  begin
    RegisterMethod('Function DigestSize : Integer');
    RegisterMethod('Function BlockSize : Integer');
    RegisterMethod('Procedure Init( const Digest : string; const Key : AnsiString)');
    RegisterMethod('Procedure HashBuf( const Buf : string; const BufSize : Integer; const FinalBuf : Boolean)');
    RegisterMethod('Procedure HashFile( const FileName : String; const Offset : Int64; const MaxCount : Int64)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EHashError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EHashError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EHashError') do
  begin
    RegisterMethod('Constructor Create( const ErrorCode : LongWord; const Msg : String)');
    RegisterProperty('ErrorCode', 'LongWord', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cHash(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure DigestToHexBuf( const Digest : string; const Size : Integer; const Buf: string)');
 CL.AddDelphiFunction('Function DigestToHex( const Digest : string; const Size : Integer) : AnsiString');

 CL.AddTypeS('T128BitDigest', 'record Bytes  : array[0..15] of Byte; end;');
 CL.AddTypeS('T160BitDigest', 'record Bytes  : array[0..19] of Byte; end;');
 CL.AddTypeS('T224BitDigest', 'record Bytes  : array[0..27] of Byte; end;');
 CL.AddTypeS('T256BitDigest', 'record Bytes  : array[0..31] of Byte; end;');
 CL.AddTypeS('T384BitDigest', 'record Bytes  : array[0..47] of Byte; end;');
 CL.AddTypeS('T512BitDigest', 'record Bytes  : array[0..63] of Byte; end;');
 CL.AddTypeS('T512BitBuf', 'record Bytes  : array[0..63] of Byte; end;');
 CL.AddTypeS('T1024BitBuf', 'record Bytes  : array[0..127] of Byte; end;');

 CL.AddTypeS('THashType','(hashChecksum32,hashXOR8,hashXOR16,hashXOR32,hashCRC16,hashCRC32,hashAdler32,hashELF,hashMD5,hashSHA1,hashSHA256,hashSHA512,hashHMAC_MD5,hashHMAC_SHA1,hashHMAC_SHA256,hashHMAC_SHA512)');
 {type
  THashType = (
      hashChecksum32, hashXOR8, hashXOR16, hashXOR32,
      hashCRC16, hashCRC32,
      hashAdler32,
      hashELF,
      hashMD5, hashSHA1, hashSHA256, hashSHA512,
      hashHMAC_MD5, hashHMAC_SHA1, hashHMAC_SHA256, hashHMAC_SHA512);
  }

 CL.AddDelphiFunction('Function Digest128Equal( const Digest1, Digest2 : T128BitDigest) : Boolean');
 CL.AddDelphiFunction('Function Digest160Equal( const Digest1, Digest2 : T160BitDigest) : Boolean');
 CL.AddDelphiFunction('Function Digest224Equal( const Digest1, Digest2 : T224BitDigest) : Boolean');
 CL.AddDelphiFunction('Function Digest256Equal( const Digest1, Digest2 : T256BitDigest) : Boolean');
 CL.AddDelphiFunction('Function Digest384Equal( const Digest1, Digest2 : T384BitDigest) : Boolean');
 CL.AddDelphiFunction('Function Digest512Equal( const Digest1, Digest2 : T512BitDigest) : Boolean');
 CL.AddConstantN('hashNoError','LongInt').SetInt( 0);
 CL.AddConstantN('hashInternalError','LongInt').SetInt( 1);
 CL.AddConstantN('hashInvalidHashType','LongInt').SetInt( 2);
 CL.AddConstantN('hashInvalidBuffer','LongInt').SetInt( 3);
 CL.AddConstantN('hashInvalidBufferSize','LongInt').SetInt( 4);
 CL.AddConstantN('hashInvalidDigest','LongInt').SetInt( 5);
 CL.AddConstantN('hashInvalidKey','LongInt').SetInt( 6);
 CL.AddConstantN('hashInvalidFileName','LongInt').SetInt( 7);
 CL.AddConstantN('hashFileOpenError','LongInt').SetInt( 8);
 CL.AddConstantN('hashFileSeekError','LongInt').SetInt( 9);
 CL.AddConstantN('hashFileReadError','LongInt').SetInt( 10);
 CL.AddConstantN('hashNotKeyedHashType','LongInt').SetInt( 11);
 CL.AddConstantN('hashTooManyOpenHandles','LongInt').SetInt( 12);
 CL.AddConstantN('hashInvalidHandle','LongInt').SetInt( 13);
 CL.AddConstantN('hashMAX_ERROR','LongInt').SetInt( 13);
 CL.AddDelphiFunction('Function GetHashErrorMessage( const ErrorCode : LongWord) : PChar');
  SIRegister_EHashError(CL);
 CL.AddDelphiFunction('Procedure SecureClear( var Buf : string; const BufSize : Integer)');
 CL.AddDelphiFunction('Procedure SecureClear512( var Buf : T512BitBuf)');
 CL.AddDelphiFunction('Procedure SecureClear1024( var Buf : T1024BitBuf)');
 CL.AddDelphiFunction('Procedure SecureClearStr2( var S : AnsiString)');
 CL.AddDelphiFunction('Function CalcChecksum32( const Buf : AnsiString) : LongWord');
 CL.AddDelphiFunction('Function CalcXOR8( const Buf : AnsiString) : Byte');
 CL.AddDelphiFunction('Function CalcXOR16( const Buf : AnsiString) : Word');
 CL.AddDelphiFunction('Function CalcXOR32( const Buf : AnsiString) : LongWord');
 CL.AddDelphiFunction('Procedure CRC16Init( var CRC16 : Word)');
 CL.AddDelphiFunction('Function CRC16Byte( const CRC16 : Word; const Octet : Byte) : Word');
 CL.AddDelphiFunction('Function CRC16Buf( const CRC16 : Word; const Buf : string; const BufSize : Integer) : Word');
 CL.AddDelphiFunction('Function CalcCRC16( const Buf : AnsiString) : Word');
 CL.AddDelphiFunction('Procedure SetCRC32Poly( const Poly : LongWord)');
 CL.AddDelphiFunction('Procedure CRC32Init( var CRC32 : LongWord)');
 CL.AddDelphiFunction('Function CRC32Byte( const CRC32 : LongWord; const Octet : Byte) : LongWord');
 CL.AddDelphiFunction('Function CRC32Buf( const CRC32 : LongWord; const Buf : string; const BufSize : Integer) : LongWord');
 CL.AddDelphiFunction('Function CRC32BufNoCase( const CRC32 : LongWord; const Buf : string; const BufSize : Integer) : LongWord');
 CL.AddDelphiFunction('Function CalcCRC32( const Buf : AnsiString) : LongWord');
 CL.AddDelphiFunction('Procedure Adler32Init( var Adler32 : LongWord)');
 CL.AddDelphiFunction('Function Adler32Byte( const Adler32 : LongWord; const Octet : Byte) : LongWord');
 CL.AddDelphiFunction('Function Adler32Buf( const Adler32 : LongWord; const Buf : string; const BufSize : Integer) : LongWord');
 CL.AddDelphiFunction('Function CalcAdler32( const Buf : AnsiString) : LongWord');
 CL.AddDelphiFunction('Procedure ELFInit( var Digest : LongWord)');
 CL.AddDelphiFunction('Function ELFBuf( const Digest : LongWord; const Buf : string; const BufSize : Integer) : LongWord');
 CL.AddDelphiFunction('Function CalcELF( const Buf : AnsiString) : LongWord');
 CL.AddDelphiFunction('Function IsValidISBN2( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function IsValidLUHN( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function KnuthHash( const S : AnsiString) : LongWord');
 CL.AddDelphiFunction('Procedure MD5InitDigest( var Digest : T128BitDigest)');
 CL.AddDelphiFunction('Procedure MD5Buf( var Digest : T128BitDigest; const Buf : string; const BufSize : Integer)');
 CL.AddDelphiFunction('Procedure MD5FinalBuf( var Digest : T128BitDigest; const Buf : string; const BufSize : Integer; const TotalSize : Int64)');
 CL.AddDelphiFunction('Function CalcMD5( const Buf : AnsiString) : T128BitDigest');
 CL.AddDelphiFunction('Function MD5DigestAsString( const Digest : T128BitDigest) : AnsiString');
 CL.AddDelphiFunction('Function MD5DigestToHex( const Digest : T128BitDigest) : AnsiString');
 CL.AddDelphiFunction('Procedure SHA1InitDigest( var Digest : T160BitDigest)');
 CL.AddDelphiFunction('Procedure SHA1Buf( var Digest : T160BitDigest; const Buf : string; const BufSize : Integer)');
 CL.AddDelphiFunction('Procedure SHA1FinalBuf( var Digest : T160BitDigest; const Buf : string; const BufSize : Integer; const TotalSize : Int64)');
 CL.AddDelphiFunction('Function CalcSHA1( const Buf : AnsiString) : T160BitDigest');
 CL.AddDelphiFunction('Function SHA1DigestAsString( const Digest : T160BitDigest) : AnsiString');
 CL.AddDelphiFunction('Function SHA1DigestToHex( const Digest : T160BitDigest) : AnsiString');
 CL.AddDelphiFunction('Procedure SHA224InitDigest( var Digest : T256BitDigest)');
 CL.AddDelphiFunction('Procedure SHA224Buf( var Digest : T256BitDigest; const Buf : string; const BufSize : Integer)');
 CL.AddDelphiFunction('Procedure SHA224FinalBuf( var Digest : T256BitDigest; const Buf : string; const BufSize : Integer; const TotalSize : Int64; var OutDigest : T224BitDigest)');
 CL.AddDelphiFunction('Function CalcSHA224( const Buf : AnsiString) : T224BitDigest');
 CL.AddDelphiFunction('Function SHA224DigestAsString( const Digest : T224BitDigest) : AnsiString');
 CL.AddDelphiFunction('Function SHA224DigestToHex( const Digest : T224BitDigest) : AnsiString');
 CL.AddDelphiFunction('Procedure SHA256InitDigest( var Digest : T256BitDigest)');
 CL.AddDelphiFunction('Procedure SHA256Buf( var Digest : T256BitDigest; const Buf : string; const BufSize : Integer)');
 CL.AddDelphiFunction('Procedure SHA256FinalBuf( var Digest : T256BitDigest; const Buf : string; const BufSize : Integer; const TotalSize : Int64)');
 CL.AddDelphiFunction('Function CalcSHA2562( const Buf : AnsiString) : T256BitDigest');
 CL.AddDelphiFunction('Function SHA256DigestAsString( const Digest : T256BitDigest) : AnsiString');
 CL.AddDelphiFunction('Function SHA256DigestToHex( const Digest : T256BitDigest) : AnsiString');
 CL.AddDelphiFunction('Procedure SHA384InitDigest( var Digest : T512BitDigest)');
 CL.AddDelphiFunction('Procedure SHA384Buf( var Digest : T512BitDigest; const Buf : string; const BufSize : Integer)');
 CL.AddDelphiFunction('Procedure SHA384FinalBuf( var Digest : T512BitDigest; const Buf : string; const BufSize : Integer; const TotalSize : Int64; var OutDigest : T384BitDigest)');
 CL.AddDelphiFunction('Function CalcSHA384( const Buf : AnsiString) : T384BitDigest');
 CL.AddDelphiFunction('Function SHA384DigestAsString( const Digest : T384BitDigest) : AnsiString');
 CL.AddDelphiFunction('Function SHA384DigestToHex( const Digest : T384BitDigest) : AnsiString');
 CL.AddDelphiFunction('Procedure SHA512InitDigest( var Digest : T512BitDigest)');
 CL.AddDelphiFunction('Procedure SHA512Buf( var Digest : T512BitDigest; const Buf : string; const BufSize : Integer)');
 CL.AddDelphiFunction('Procedure SHA512FinalBuf( var Digest : T512BitDigest; const Buf : string; const BufSize : Integer; const TotalSize : Int64)');
 CL.AddDelphiFunction('Function CalcSHA512( const Buf : AnsiString) : T512BitDigest');
 CL.AddDelphiFunction('Function SHA512DigestAsString( const Digest : T512BitDigest) : AnsiString');
 CL.AddDelphiFunction('Function SHA512DigestToHex( const Digest : T512BitDigest) : AnsiString');
 CL.AddDelphiFunction('Procedure HMAC_MD5Init( const Key : string; const KeySize : Integer; var Digest : T128BitDigest; var K : T512BitBuf)');
 CL.AddDelphiFunction('Procedure HMAC_MD5Buf( var Digest : T128BitDigest; const Buf : string; const BufSize : Integer)');
 CL.AddDelphiFunction('Procedure HMAC_MD5FinalBuf( const K : T512BitBuf; var Digest : T128BitDigest; const Buf : string; const BufSize : Integer; const TotalSize : Int64)');
 CL.AddDelphiFunction('Function CalcHMAC_MD5( const Key, Buf : AnsiString) : T128BitDigest');
 CL.AddDelphiFunction('Procedure HMAC_SHA1Init( const Key : string; const KeySize : Integer; var Digest : T160BitDigest; var K : T512BitBuf)');
 CL.AddDelphiFunction('Procedure HMAC_SHA1Buf( var Digest : T160BitDigest; const Buf : string; const BufSize : Integer)');
 CL.AddDelphiFunction('Procedure HMAC_SHA1FinalBuf( const K : T512BitBuf; var Digest : T160BitDigest; const Buf : string; const BufSize : Integer; const TotalSize : Int64)');
 CL.AddDelphiFunction('Function CalcHMAC_SHA1( const Key, Buf : AnsiString) : T160BitDigest');
 CL.AddDelphiFunction('Procedure HMAC_SHA256Init( const Key : string; const KeySize : Integer; var Digest : T256BitDigest; var K : T512BitBuf)');
 CL.AddDelphiFunction('Procedure HMAC_SHA256Buf( var Digest : T256BitDigest; const Buf : string; const BufSize : Integer)');
 CL.AddDelphiFunction('Procedure HMAC_SHA256FinalBuf( const K : T512BitBuf; var Digest : T256BitDigest; const Buf : string; const BufSize : Integer; const TotalSize : Int64)');
 CL.AddDelphiFunction('Function CalcHMAC_SHA256( const Key, Buf : AnsiString) : T256BitDigest');
 CL.AddDelphiFunction('Procedure HMAC_SHA512Init( const Key : string; const KeySize : Integer; var Digest : T512BitDigest; var K : T1024BitBuf)');
 CL.AddDelphiFunction('Procedure HMAC_SHA512Buf( var Digest : T512BitDigest; const Buf : string; const BufSize : Integer)');
 CL.AddDelphiFunction('Procedure HMAC_SHA512FinalBuf( const K : T1024BitBuf; var Digest : T512BitDigest; const Buf : string; const BufSize : Integer; const TotalSize : Int64)');
 CL.AddDelphiFunction('Function CalcHMAC_SHA512( const Key, Buf : AnsiString) : T512BitDigest');
  SIRegister_AHash(CL);
  //CL.AddTypeS('THashClass', 'class of AHash');
  SIRegister_TChecksum32Hash(CL);
  SIRegister_TXOR8Hash(CL);
  SIRegister_TXOR16Hash(CL);
  SIRegister_TXOR32Hash(CL);
  SIRegister_TCRC16Hash(CL);
  SIRegister_TCRC32Hash(CL);
  SIRegister_TAdler32Hash(CL);
  SIRegister_TELFHash(CL);
  SIRegister_TMD5Hash(CL);
  SIRegister_TSHA1Hash(CL);
  SIRegister_TSHA256Hash2(CL);
  SIRegister_TSHA512Hash(CL);
  SIRegister_THMAC_MD5Hash(CL);
  SIRegister_THMAC_SHA1Hash(CL);
  SIRegister_THMAC_SHA256Hash(CL);
  SIRegister_THMAC_SHA512Hash(CL);
  CL.AddTypeS('THashType', '( hashChecksum32, hashXOR8, hashXOR16, hashXOR32, h'
   +'ashCRC16, hashCRC32, hashAdler32, hashELF, hashMD5, hashSHA1, hashSHA256, '
   +'hashSHA512, hashHMAC_MD5, hashHMAC_SHA1, hashHMAC_SHA256, hashHMAC_SHA512 )');
 //CL.AddDelphiFunction('Function GetHashClassByType( const HashType : THashType) : THashClass');
 CL.AddDelphiFunction('Function GetDigestSize( const HashType : THashType) : Integer');
 CL.AddDelphiFunction('Procedure CalculateHash( const HashType : THashType; const Buf : AnsiString; const Digest : string; const Key : AnsiString)');
 CL.AddDelphiFunction('Function HashString( const S : AnsiString; const Slots : LongWord; const CaseSensitive : Boolean) : LongWord');
 CL.AddDelphiFunction('Procedure SelfTestHash');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure EHashErrorErrorCode_R(Self: EHashError; var T: LongWord);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THMAC_SHA512Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THMAC_SHA512Hash) do
  begin
    RegisterMethod(@THMAC_SHA512Hash.DigestSize, 'DigestSize');
    RegisterMethod(@THMAC_SHA512Hash.BlockSize, 'BlockSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THMAC_SHA256Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THMAC_SHA256Hash) do
  begin
    RegisterMethod(@THMAC_SHA256Hash.DigestSize, 'DigestSize');
    RegisterMethod(@THMAC_SHA256Hash.BlockSize, 'BlockSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THMAC_SHA1Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THMAC_SHA1Hash) do
  begin
    RegisterMethod(@THMAC_SHA1Hash.DigestSize, 'DigestSize');
    RegisterMethod(@THMAC_SHA1Hash.BlockSize, 'BlockSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THMAC_MD5Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THMAC_MD5Hash) do
  begin
    RegisterMethod(@THMAC_MD5Hash.DigestSize, 'DigestSize');
    RegisterMethod(@THMAC_MD5Hash.BlockSize, 'BlockSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSHA512Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSHA512Hash) do
  begin
    RegisterMethod(@TSHA512Hash.DigestSize, 'DigestSize');
    RegisterMethod(@TSHA512Hash.BlockSize, 'BlockSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSHA256Hash2(CL: TPSRuntimeClassImporter);    //rename
begin
  with CL.Add(TSHA256Hash) do
  begin
    RegisterMethod(@TSHA256Hash.DigestSize, 'DigestSize');
    RegisterMethod(@TSHA256Hash.BlockSize, 'BlockSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSHA1Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSHA1Hash) do
  begin
    RegisterMethod(@TSHA1Hash.DigestSize, 'DigestSize');
    RegisterMethod(@TSHA1Hash.BlockSize, 'BlockSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMD5Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMD5Hash) do
  begin
    RegisterMethod(@TMD5Hash.DigestSize, 'DigestSize');
    RegisterMethod(@TMD5Hash.BlockSize, 'BlockSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TELFHash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TELFHash) do
  begin
    RegisterMethod(@TELFHash.DigestSize, 'DigestSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAdler32Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAdler32Hash) do
  begin
    RegisterMethod(@TAdler32Hash.DigestSize, 'DigestSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCRC32Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCRC32Hash) do
  begin
    RegisterMethod(@TCRC32Hash.DigestSize, 'DigestSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCRC16Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCRC16Hash) do
  begin
    RegisterMethod(@TCRC16Hash.DigestSize, 'DigestSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXOR32Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXOR32Hash) do
  begin
    RegisterMethod(@TXOR32Hash.DigestSize, 'DigestSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXOR16Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXOR16Hash) do
  begin
    RegisterMethod(@TXOR16Hash.DigestSize, 'DigestSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXOR8Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXOR8Hash) do
  begin
    RegisterMethod(@TXOR8Hash.DigestSize, 'DigestSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChecksum32Hash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChecksum32Hash) do
  begin
    RegisterMethod(@TChecksum32Hash.DigestSize, 'DigestSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AHash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(AHash) do begin
    //RegisterVirtualAbstractMethod(@AHash, @!.DigestSize, 'DigestSize');
    RegisterVirtualMethod(@AHash.BlockSize, 'BlockSize');
    RegisterMethod(@AHash.Init, 'Init');
    RegisterMethod(@AHash.HashBuf, 'HashBuf');
    RegisterMethod(@AHash.HashFile, 'HashFile');
  end;
   RIRegister_TChecksum32Hash(CL);
  RIRegister_TXOR8Hash(CL);
  RIRegister_TXOR16Hash(CL);
  RIRegister_TXOR32Hash(CL);
  RIRegister_TCRC16Hash(CL);
  RIRegister_TCRC32Hash(CL);
  RIRegister_TAdler32Hash(CL);
  RIRegister_TELFHash(CL);
  RIRegister_TMD5Hash(CL);
  RIRegister_TSHA1Hash(CL);
  RIRegister_TSHA256Hash2(CL);
  RIRegister_TSHA512Hash(CL);
  RIRegister_THMAC_MD5Hash(CL);
  RIRegister_THMAC_SHA1Hash(CL);
  RIRegister_THMAC_SHA256Hash(CL);
  RIRegister_THMAC_SHA512Hash(CL);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EHashError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EHashError) do
  begin
    RegisterConstructor(@EHashError.Create, 'Create');
    RegisterPropertyHelper(@EHashErrorErrorCode_R,nil,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cHash_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DigestToHexBuf, 'DigestToHexBuf', cdRegister);
 S.RegisterDelphiFunction(@DigestToHex, 'DigestToHex', cdRegister);
 S.RegisterDelphiFunction(@Digest128Equal, 'Digest128Equal', cdRegister);
 S.RegisterDelphiFunction(@Digest160Equal, 'Digest160Equal', cdRegister);
 S.RegisterDelphiFunction(@Digest224Equal, 'Digest224Equal', cdRegister);
 S.RegisterDelphiFunction(@Digest256Equal, 'Digest256Equal', cdRegister);
 S.RegisterDelphiFunction(@Digest384Equal, 'Digest384Equal', cdRegister);
 S.RegisterDelphiFunction(@Digest512Equal, 'Digest512Equal', cdRegister);
 S.RegisterDelphiFunction(@GetHashErrorMessage, 'GetHashErrorMessage', cdRegister);
 // RIRegister_EHashError(CL);
 S.RegisterDelphiFunction(@SecureClear, 'SecureClear', cdRegister);
 S.RegisterDelphiFunction(@SecureClear512, 'SecureClear512', cdRegister);
 S.RegisterDelphiFunction(@SecureClear1024, 'SecureClear1024', cdRegister);
 S.RegisterDelphiFunction(@SecureClearStr, 'SecureClearStr2', cdRegister);
 S.RegisterDelphiFunction(@CalcChecksum32, 'CalcChecksum32', cdRegister);
 S.RegisterDelphiFunction(@CalcXOR8_, 'CalcXOR8', cdRegister);
 S.RegisterDelphiFunction(@CalcXOR16_, 'CalcXOR16', cdRegister);
 S.RegisterDelphiFunction(@CalcXOR32_, 'CalcXOR32', cdRegister);
 S.RegisterDelphiFunction(@CRC16Init, 'CRC16Init', cdRegister);
 S.RegisterDelphiFunction(@CRC16Byte, 'CRC16Byte', cdRegister);
 S.RegisterDelphiFunction(@CRC16Buf, 'CRC16Buf', cdRegister);
 S.RegisterDelphiFunction(@CalcCRC16_, 'CalcCRC16', cdRegister);
 S.RegisterDelphiFunction(@SetCRC32Poly, 'SetCRC32Poly', cdRegister);
 S.RegisterDelphiFunction(@CRC32Init, 'CRC32Init', cdRegister);
 S.RegisterDelphiFunction(@CRC32Byte, 'CRC32Byte', cdRegister);
 S.RegisterDelphiFunction(@CRC32Buf, 'CRC32Buf', cdRegister);
 S.RegisterDelphiFunction(@CRC32BufNoCase, 'CRC32BufNoCase', cdRegister);
 S.RegisterDelphiFunction(@CalcCRC32_, 'CalcCRC32', cdRegister);
 S.RegisterDelphiFunction(@Adler32Init, 'Adler32Init', cdRegister);
 S.RegisterDelphiFunction(@Adler32Byte, 'Adler32Byte', cdRegister);
 S.RegisterDelphiFunction(@Adler32Buf, 'Adler32Buf', cdRegister);
 S.RegisterDelphiFunction(@CalcAdler32_, 'CalcAdler32', cdRegister);
 S.RegisterDelphiFunction(@ELFInit, 'ELFInit', cdRegister);
 S.RegisterDelphiFunction(@ELFBuf, 'ELFBuf', cdRegister);
 S.RegisterDelphiFunction(@CalcELF_, 'CalcELF', cdRegister);
 S.RegisterDelphiFunction(@IsValidISBN, 'IsValidISBN2', cdRegister);
 S.RegisterDelphiFunction(@IsValidLUHN, 'IsValidLUHN', cdRegister);
 S.RegisterDelphiFunction(@KnuthHash, 'KnuthHash', cdRegister);
 S.RegisterDelphiFunction(@MD5InitDigest, 'MD5InitDigest', cdRegister);
 S.RegisterDelphiFunction(@MD5Buf, 'MD5Buf', cdRegister);
 S.RegisterDelphiFunction(@MD5FinalBuf, 'MD5FinalBuf', cdRegister);
 S.RegisterDelphiFunction(@CalcMD5_, 'CalcMD5', cdRegister);
 S.RegisterDelphiFunction(@MD5DigestAsString, 'MD5DigestAsString', cdRegister);
 S.RegisterDelphiFunction(@MD5DigestToHex, 'MD5DigestToHex', cdRegister);
 S.RegisterDelphiFunction(@SHA1InitDigest, 'SHA1InitDigest', cdRegister);
 S.RegisterDelphiFunction(@SHA1Buf, 'SHA1Buf', cdRegister);
 S.RegisterDelphiFunction(@SHA1FinalBuf, 'SHA1FinalBuf', cdRegister);
 S.RegisterDelphiFunction(@CalcSHA1_, 'CalcSHA1', cdRegister);
 S.RegisterDelphiFunction(@SHA1DigestAsString, 'SHA1DigestAsString', cdRegister);
 S.RegisterDelphiFunction(@SHA1DigestToHex, 'SHA1DigestToHex', cdRegister);
 S.RegisterDelphiFunction(@SHA224InitDigest, 'SHA224InitDigest', cdRegister);
 S.RegisterDelphiFunction(@SHA224Buf, 'SHA224Buf', cdRegister);
 S.RegisterDelphiFunction(@SHA224FinalBuf, 'SHA224FinalBuf', cdRegister);
 S.RegisterDelphiFunction(@CalcSHA224_, 'CalcSHA224', cdRegister);
 S.RegisterDelphiFunction(@SHA224DigestAsString, 'SHA224DigestAsString', cdRegister);
 S.RegisterDelphiFunction(@SHA224DigestToHex, 'SHA224DigestToHex', cdRegister);
 S.RegisterDelphiFunction(@SHA256InitDigest, 'SHA256InitDigest', cdRegister);
 S.RegisterDelphiFunction(@SHA256Buf, 'SHA256Buf', cdRegister);
 S.RegisterDelphiFunction(@SHA256FinalBuf, 'SHA256FinalBuf', cdRegister);
 S.RegisterDelphiFunction(@CalcSHA256_, 'CalcSHA2562', cdRegister);
 S.RegisterDelphiFunction(@SHA256DigestAsString, 'SHA256DigestAsString', cdRegister);
 S.RegisterDelphiFunction(@SHA256DigestToHex, 'SHA256DigestToHex', cdRegister);
 S.RegisterDelphiFunction(@SHA384InitDigest, 'SHA384InitDigest', cdRegister);
 S.RegisterDelphiFunction(@SHA384Buf, 'SHA384Buf', cdRegister);
 S.RegisterDelphiFunction(@SHA384FinalBuf, 'SHA384FinalBuf', cdRegister);
 S.RegisterDelphiFunction(@CalcSHA384_, 'CalcSHA384', cdRegister);
 S.RegisterDelphiFunction(@SHA384DigestAsString, 'SHA384DigestAsString', cdRegister);
 S.RegisterDelphiFunction(@SHA384DigestToHex, 'SHA384DigestToHex', cdRegister);
 S.RegisterDelphiFunction(@SHA512InitDigest, 'SHA512InitDigest', cdRegister);
 S.RegisterDelphiFunction(@SHA512Buf, 'SHA512Buf', cdRegister);
 S.RegisterDelphiFunction(@SHA512FinalBuf, 'SHA512FinalBuf', cdRegister);
 S.RegisterDelphiFunction(@CalcSHA512_, 'CalcSHA512', cdRegister);
 S.RegisterDelphiFunction(@SHA512DigestAsString, 'SHA512DigestAsString', cdRegister);
 S.RegisterDelphiFunction(@SHA512DigestToHex, 'SHA512DigestToHex', cdRegister);
 S.RegisterDelphiFunction(@HMAC_MD5Init, 'HMAC_MD5Init', cdRegister);
 S.RegisterDelphiFunction(@HMAC_MD5Buf, 'HMAC_MD5Buf', cdRegister);
 S.RegisterDelphiFunction(@HMAC_MD5FinalBuf, 'HMAC_MD5FinalBuf', cdRegister);
 S.RegisterDelphiFunction(@CalcHMAC_MD5_, 'CalcHMAC_MD5', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA1Init, 'HMAC_SHA1Init', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA1Buf, 'HMAC_SHA1Buf', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA1FinalBuf, 'HMAC_SHA1FinalBuf', cdRegister);
 S.RegisterDelphiFunction(@CalcHMAC_SHA1_, 'CalcHMAC_SHA1', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA256Init, 'HMAC_SHA256Init', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA256Buf, 'HMAC_SHA256Buf', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA256FinalBuf, 'HMAC_SHA256FinalBuf', cdRegister);
 S.RegisterDelphiFunction(@CalcHMAC_SHA256_, 'CalcHMAC_SHA256', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA512Init, 'HMAC_SHA512Init', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA512Buf, 'HMAC_SHA512Buf', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA512FinalBuf, 'HMAC_SHA512FinalBuf', cdRegister);
 S.RegisterDelphiFunction(@CalcHMAC_SHA512_, 'CalcHMAC_SHA512', cdRegister);
  //RIRegister_AHash(CL);
 { RIRegister_TChecksum32Hash(CL);
  RIRegister_TXOR8Hash(CL);
  RIRegister_TXOR16Hash(CL);
  RIRegister_TXOR32Hash(CL);
  RIRegister_TCRC16Hash(CL);
  RIRegister_TCRC32Hash(CL);
  RIRegister_TAdler32Hash(CL);
  RIRegister_TELFHash(CL);
  RIRegister_TMD5Hash(CL);
  RIRegister_TSHA1Hash(CL);
  RIRegister_TSHA256Hash2(CL);
  RIRegister_TSHA512Hash(CL);
  RIRegister_THMAC_MD5Hash(CL);
  RIRegister_THMAC_SHA1Hash(CL);
  RIRegister_THMAC_SHA256Hash(CL);
  RIRegister_THMAC_SHA512Hash(CL);  }
 S.RegisterDelphiFunction(@GetHashClassByType, 'GetHashClassByType', cdRegister);
 S.RegisterDelphiFunction(@GetDigestSize, 'GetDigestSize', cdRegister);
 S.RegisterDelphiFunction(@CalculateHash, 'CalculateHash', cdRegister);
 S.RegisterDelphiFunction(@HashString, 'HashString', cdRegister);
 S.RegisterDelphiFunction(@SelfTestHash, 'SelfTestHash', cdRegister);
end;

 
 
{ TPSImport_cHash }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cHash.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cHash(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cHash.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cHash_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
