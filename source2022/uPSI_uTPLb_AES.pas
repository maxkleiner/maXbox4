unit uPSI_uTPLb_AES;
{
to enhance a direct wrapper round internals
 set the prove of testcase and the execute of demo
 chain mode CBC , keysize=256  in bits 2048 , locs=682  plus direct cipher
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  //,uLockBox_TestCases
  //,TestFramework
  ;

type
(*----------------------------------------------------------------------------*)
  TPSImport_uTPLb_AES = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

  {TAES256_RefTestCase = class( TAES_Reference_TestCase)
  protected
    class function KeySize: integer; override;
  end;}

      function  Busy: IInterface;
      procedure LogFmt( const Line: string; const Args: array of const);
 // function AESSymetricExecute(const plaintext, password: string): string;
 procedure AESSymetricExecute(const plaintext, ciphertext, password: string);
 procedure AESDecryptFile(const replaintext, ciphertext, password: string);
 function ComputeSHA256(astr: string; amode: char): string;


var
  FBusyObj: TObject; // TBusy


{ compile-time registration functions }
procedure SIRegister_TAES(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_AES(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAES(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_AES(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_AES_Routines(S: TPSExec);


procedure Register;

implementation


uses
   uTPLb_BlockCipher
  ,uTPLb_StreamCipher
  ,uTPLb_Decorators
  ,uTPLb_AES
  ,uTPLb_StreamUtils
  ,uTPLb_Constants
  ,uTPLb_Codec
  ,uTPLb_CryptographicLibrary
  ,uTPLb_SHA2
  ,uTPLb_Hash
  ,fMain
  ;


const
  AKEYSIZEBIT = 2048;
  //AKEYSIZEBIT = 1024;

  ChainIds: array[ 0..6 ] of string = (
   ECB_ProgId, CBC_ProgId, PCBC_ProgId, CFB_ProgId,
   CFB8bit_ProgId, CTR_ProgId, OFB_ProgId);

  CipherIds: array[ 0.. 8 ] of string = (
    'native.AES-128', 'native.AES-192', 'native.AES-256',
    'native.DES', 'native.3DES.1', 'native.3DES.2', 'native.Blowfish',
    'native.Twofish', 'native.XXTEA.Large.Littleend');


type
  TOperation = (opIdle, opSymetricEncrypt, opSymetricDecrypt,
      opSymetricCompare, opScribble, opCustomBlockSymetricEncrypt,
      opCustomBlockSymetricDecrypt, opRSAGen, opRSAEncrypt,
      opRSADecrypt, opSign, opVerify, opHash, opOpenSSL);


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_AES]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAES(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TAES') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TAES') do
  begin
    RegisterMethod('Constructor Create( KeySize1 : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_AES(CL: TPSPascalCompiler);
begin
  SIRegister_TAES(CL);
  CL.AddDelphiFunction('procedure AESSymetricExecute(const plaintext, ciphertext, password: string)');
  CL.AddDelphiFunction('procedure AESEncryptFile(const plaintext, ciphertext, password: string)');
  CL.AddDelphiFunction('procedure AESDecryptFile(const replaintext, ciphertext, password: string)');
  CL.AddDelphiFunction('procedure AESEncryptFile2(const plaintext, ciphertext, password: string)');
  CL.AddDelphiFunction('procedure AESDecryptFile2(const replaintext, ciphertext, password: string)');

  CL.AddDelphiFunction('procedure AESEncryptString(const plaintext: string; var ciphertext: string; password: string)');
  CL.AddDelphiFunction('procedure AESDecryptString(var plaintext: string; const ciphertext: string; password: string)');

  CL.AddDelphiFunction('function ComputeSHA256(astr: string; amode: char): string)');
  CL.AddDelphiFunction('function ComputeSHA512(astr: string; amode: char): string)');
  CL.AddDelphiFunction('function SHA256(astr: string; amode: char): string)');
  CL.AddDelphiFunction('function SHA512(astr: string; amode: char): string)');

  CL.AddDelphiFunction('function EndianWord(w : word): word)');
  CL.AddDelphiFunction('function EndianInt(i : integer): integer)');
  CL.AddDelphiFunction('function EndianLong(L : longint): longint)');
  CL.AddDelphiFunction('function SwapWord(w : word): word)');
  CL.AddDelphiFunction('function SwapInt(i : integer): integer)');
  CL.AddDelphiFunction('function Swap(i : integer): integer)');

  CL.AddDelphiFunction('function SwapLong(L : longint): longint)');

  CL.AddDelphiFunction('procedure SymetricCompareFiles(const plaintext, replaintext: string)');
  CL.AddDelphiFunction('procedure PutLinuxLines(const Value: string)');

end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_AES(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAES(CL);
end;

function Busy: IInterface;
begin
result := nil;
if Supports( FBusyObj, IInterface, result) then exit;
//TBusy.Create( self);
Supports( FBusyObj, IInterface, result)
end;

procedure Log( const Line: string);
begin
  maxform1.memo2.Lines.Add( Line)
end;



procedure LogFmt( const Line: string;
  const Args: array of const);
begin
  Log( Format( Line, Args))
end;

procedure SymetricCompareFiles(const plaintext, replaintext: string);
var
  isSame: boolean;
begin
try
  isSame:= uTPLb_StreamUtils.CompareFiles(Plaintext, RePlaintext,NIL,NIL);
  if isSame then
    Log('Success! The reconstructed plaintext is a faithfull copy of the original.')
  else
    Log('Failure! The reconstructed plaintext differs from the original.')
except on E: Exception do
  LogFmt('Exception (%s) occurred during file comparison.'#13#10 +
          '%s', [E.ClassName, E.Message])
  end
end;


procedure PutLinuxLines(const Value: string);
var
  s: string;
  P: integer;
begin
s:= Value;
while s <> '' do begin
  P:= Pos(#10, s);
    if P > 0 then begin
      Log(Copy(s, 1, P - 1));
      Delete(s, 1, P)
    end
    else begin
      Log(s);
      s:= ''
    end;
  end
end;


  {StreamCipherId = 'native.XXTEA.Large.Littleend'
    BlockCipherId = ''
    ChainId = 'native.CBC'
    StreamCipherId = 'native.StreamToBlock'
    BlockCipherId = 'native.AES-256'
    ChainId = 'native.CFB'
    }


procedure AESSymetricExecute(const plaintext, ciphertext, password: string);
var
  Sz: int64;
  CurrentOperation: TOperation;
  //ciphertext: string;
  codecMain: TCodec;
  //FScribblePad_EntropyBag: TStream;
  CryptographicLibrary1: TCryptographicLibrary;

begin
CryptographicLibrary1:= TCryptographicLibrary.Create(NIL);
codecMain:= TCodec.Create(NIL);
codecMain.CryptoLibrary:= CryptographicLibrary1;
codecMain.AsymetricKeySizeInBits:= AKEYSIZEBIT;
currentOperation:= opIdle;
//FdidPressAbortEncrypt := False;
//memoLog.Clear;
Log('Welcome to the LockBox3 CipherBox4 in maXbox4');
//codecMainDemo.StreamCipherId := BlockCipher_ProgId;
 codecMain.StreamCipherId:= BlockCipher_ProgId; //'native.StreamToBlock';
 codecMain.BlockCipherId:= CipherIds[2];//AES_ProgId;// 'native.AES-256';//CipherIds[rgCipher.ItemIndex]
 codecMain.ChainModeId:= ChainIds[1];//ChainIds[ rgChain.ItemIndex]   CBC
 codecMain.Password:= Password;
//rgChainClick( nil);
//rgCipherClick( nil);
// FScribblePad_EntropyBag:= TMemoryStream.Create;
//TDemoBlockModeCipher.SelfRegister( CryptographicLibrary1)

//Busy;
Sz:= uTPLb_StreamUtils.FileSize(plaintext);  //edtPlaintextFile.Text);
CurrentOperation:= opSymetricEncrypt;
try
  //FdidPressAbortEncrypt:= False;
  LogFmt('Encrypting file "%s" to "%s" using %s cipher and %s chaining mode.',
  [plaintext, ciphertext, codecMain.BlockCipherId, codecMain.ChainModeId]);
  LogFmt('Plaintext size = %d bytes.', [Sz]);
    codecMain.EncryptFile(plaintext, ciphertext);

if codecMain.isUserAborted then
    Log( 'Encryption operation aborted by user.')
  else
    LogFmt('Encryption succeeded. %d bytes processed.',
                         [codecMain.CountBytesProcessed])
except
  on E: EFCreateError do
    LogFmt('Cannot create ciphertext file "%s".', [ciphertext]);
  on E: Exception do
    if (E.ClassType = EFOpenError) and (Pos('Cannot open file', E.Message)=1) then
        LogFmt('Cannot open plaintext file "%s".', [Plaintext])
      else
        LogFmt('%s: %s', [E.ClassName, E.Message])
end;
if codecMain.isUserAborted then begin
 end
  else
    if codecMain.Speed >= 0 then
      LogFmt( 'Speed of encryption was %d KiB per second.',
              [codecMain.Speed]);
codecMain.Reset;
CurrentOperation:= opIdle;
codecMain.Free;
CryptographicLibrary1.Free;
//FScribblePad_EntropyBag.Free
end;



//procedure AESDecrypt(const plaintext, password: string; ciphertext: string);
procedure AESDecryptFile(const replaintext, ciphertext, password: string);
var
CurrentOperation: TOperation;
  //ciphertext: string;
  codecMain: TCodec;
  //FScribblePad_EntropyBag: TStream;
  CryptographicLibrary1: TCryptographicLibrary;
begin
 CryptographicLibrary1:= TCryptographicLibrary.Create(NIL);
 codecMain:= TCodec.Create(NIL);
 codecMain.CryptoLibrary:= CryptographicLibrary1;
 codecMain.AsymetricKeySizeInBits:= AKEYSIZEBIT;
 codecMain.StreamCipherId:= BlockCipher_ProgId; //'native.StreamToBlock';
 codecMain.BlockCipherId:= CipherIds[2];//AES_ProgId;// 'native.AES-256';//CipherIds[rgCipher.ItemIndex]
 codecMain.ChainModeId:= ChainIds[1];//ChainIds[ rgChain.ItemIndex]   CBC
 codecMain.Password:= Password;

//Busy;
CurrentOperation:= opSymetricDecrypt;
try
//FdidPressAbortEncrypt:= False;
LogFmt('Decrypting file "%s" to "%s" using %s cipher and %s chaining mode.',
  [Ciphertext, rePlaintext, codecMain.BlockCipherId, codecMain.ChainModeId]);
LogFmt('Ciphertext size = %d bytes.', [uTPLb_StreamUtils.FileSize(Ciphertext)]);

  //if aMode = 'F' then
    codecMain.DecryptFile(replaintext, ciphertext);
//codecMain.DecryptFile(rePlaintext, Ciphertext);

if codecMain.isUserAborted then
    Log('Decryption operation aborted by user.')
  else
    LogFmt('Decryption succeeded. %d bytes processed.',
                         [codecMain.CountBytesProcessed])
except
  on E: EFCreateError do
    LogFmt('Cannot create reconstructed plaintext file "%s".', [RePlaintext]);
  on E: Exception do
    if (E.ClassType = EFOpenError) and (Pos( 'Cannot open file', E.Message)=1) then
        LogFmt('Cannot open ciphertext file "%s".', [Ciphertext])
      else
        LogFmt('%s: %s', [E.ClassName, E.Message])
end;
if codecMain.isUserAborted then
    begin end // codecMainDemo.Reset
  else
    if codecMain.Speed >= 0 then
      LogFmt('Speed of decryption was %d KiB per second.',
              [codecMain.Speed]);
 codecMain.Reset;
 CurrentOperation:= opIdle;
 codecMain.Free;
 CryptographicLibrary1.Free;
end;


procedure AESEncryptString(const plaintext: string;
                                  var ciphertext: string; password: string);
var
  Sz: int64;
  CurrentOperation: TOperation;
  //ciphertext: string;
  codecMain: TCodec;
  //FScribblePad_EntropyBag: TStream;
  CryptographicLibrary1: TCryptographicLibrary;

begin
CryptographicLibrary1:= TCryptographicLibrary.Create(NIL);
codecMain:= TCodec.Create(NIL);
codecMain.CryptoLibrary:= CryptographicLibrary1;
codecMain.AsymetricKeySizeInBits:= AKEYSIZEBIT;
currentOperation:= opIdle;
//FdidPressAbortEncrypt := False;
//memoLog.Clear;
Log('Welcome to the LockBox3 CipherBox4 in maXbox4');
//codecMainDemo.StreamCipherId := BlockCipher_ProgId;
 codecMain.StreamCipherId:= BlockCipher_ProgId; //'native.StreamToBlock';
 codecMain.BlockCipherId:= CipherIds[2];//AES_ProgId;// 'native.AES-256';//CipherIds[rgCipher.ItemIndex]
 codecMain.ChainModeId:= ChainIds[1];//ChainIds[ rgChain.ItemIndex]   CBC
 codecMain.Password:= Password;
 //FScribblePad_EntropyBag:= TMemoryStream.Create;
//TDemoBlockModeCipher.SelfRegister( CryptographicLibrary1)

//Busy;
Sz:= length(plaintext);  //edtPlaintextFile.Text);
CurrentOperation:= opSymetricEncrypt;
try
  //FdidPressAbortEncrypt:= False;
  LogFmt('Encrypting string "%s" to "%s" using %s cipher and %s chaining mode.',
  [plaintext, ciphertext, codecMain.BlockCipherId, codecMain.ChainModeId]);
  LogFmt('Plaintext size = %d bytes.', [Sz]);
    codecMain.EncryptString(plaintext, ciphertext);

if codecMain.isUserAborted then
    Log( 'Encryption operation aborted by user.')
  else
    LogFmt('Encryption succeeded. %d bytes processed.',
                         [codecMain.CountBytesProcessed])
except
  on E: EFCreateError do
    LogFmt('Cannot create ciphertext string "%s".', [ciphertext]);
  on E: Exception do
    if (E.ClassType = EFOpenError) and (Pos('Cannot open string', E.Message)=1) then
        LogFmt('Cannot open plaintext string "%s".', [Plaintext])
      else
        LogFmt('%s: %s', [E.ClassName, E.Message])
end;
if codecMain.isUserAborted then begin
 end
  else
    if codecMain.Speed >= 0 then
      LogFmt( 'Speed of encryption was %d KiB per second.',
              [codecMain.Speed]);
codecMain.Reset;
CurrentOperation:= opIdle;
codecMain.Free;
CryptographicLibrary1.Free;
//FScribblePad_EntropyBag.Free
end;

procedure AESDecryptString(var plaintext: string;
                                  const ciphertext: string; password: string);
var
  Sz: int64;
  CurrentOperation: TOperation;
  //ciphertext: string;
  codecMain: TCodec;
  CryptographicLibrary1: TCryptographicLibrary;

begin
CryptographicLibrary1:= TCryptographicLibrary.Create(NIL);
codecMain:= TCodec.Create(NIL);
codecMain.CryptoLibrary:= CryptographicLibrary1;
codecMain.AsymetricKeySizeInBits:= AKEYSIZEBIT;
currentOperation:= opIdle;
//FdidPressAbortEncrypt := False;
//memoLog.Clear;
Log('Welcome to the LockBox3 CipherBox3 in maXbox3');
//codecMainDemo.StreamCipherId := BlockCipher_ProgId;
 codecMain.StreamCipherId:= BlockCipher_ProgId; //'native.StreamToBlock';
 codecMain.BlockCipherId:= CipherIds[2];//AES_ProgId;// 'native.AES-256';//CipherIds[rgCipher.ItemIndex]
 codecMain.ChainModeId:= ChainIds[1];//ChainIds[ rgChain.ItemIndex]   CBC
 codecMain.Password:= Password;
//rgChainClick( nil);
//rgCipherClick( nil);
//TDemoBlockModeCipher.SelfRegister( CryptographicLibrary1)
//Busy;
Sz:= length(plaintext);  //edtPlaintextFile.Text);
CurrentOperation:= opSymetricEncrypt;
try
  //FdidPressAbortEncrypt:= False;
  LogFmt('Encrypting string "%s" to "%s" using %s cipher and %s chaining mode.',
  [plaintext, ciphertext, codecMain.BlockCipherId, codecMain.ChainModeId]);
  LogFmt('Plaintext size = %d bytes.', [Sz]);
    codecMain.DecryptString(plaintext, ciphertext);

if codecMain.isUserAborted then
    Log( 'Encryption operation aborted by user.')
  else
    LogFmt('Encryption succeeded. %d bytes processed.',
                         [codecMain.CountBytesProcessed])
except
  on E: EFCreateError do
    LogFmt('Cannot create ciphertext filestring "%s".', [ciphertext]);
  on E: Exception do
    if (E.ClassType = EFOpenError) and (Pos('Cannot open filestring', E.Message)=1) then
        LogFmt('Cannot open plaintext filestring "%s".', [Plaintext])
      else
        LogFmt('%s: %s', [E.ClassName, E.Message])
end;
if codecMain.isUserAborted then begin
 end
  else
    if codecMain.Speed >= 0 then
      LogFmt( 'Speed of encryption was %d KiB per second.',
              [codecMain.Speed]);
codecMain.Reset;
CurrentOperation:= opIdle;
codecMain.Free;
CryptographicLibrary1.Free;
end;

function EndianWord(w : word) : word;
begin
  result:= swap(w);
end;

function EndianInt(i : integer) : integer;
begin
  result:= swap(i);
end;

function EndianLong(L : longint) : longint;
begin
  result:= swap(L shr 16) or
  (longint(swap(L and $ffff)) shl 16);
end;


function ComputeSHA256(astr: string; amode: char): string;
var
  a: ansistring;
  //s: string;
  HashWord: longword;//uint32;
  Xfer: integer;
  fileHash: THash;
  CryptographicLibrary1: TCryptographicLibrary;

begin
  CryptographicLibrary1:= TCryptographicLibrary.Create(NIL);
  fileHash:= THash.Create(NIL);
  fileHash.CryptoLibrary:= CryptographicLibrary1;
  //fileHash.HashId:= 'native.hash.SHA-384';
  fileHash.HashId:= 'native.hash.SHA-256';
  //fileHash.HashId:= 'native.hash.SHA1';
    a:= astr;   //edtHashSource.Text;
    //StringHash.HashAnsiString( a);
    if amode = 'F' then begin
        filehash.HashFile(a);
        LogFmt('SHA-256 of file ''%s'' rendered l-endian base64 is:', [a]);
    end;
    if amode = 'S' then begin
       filehash.HashAnsiString(a);
       LogFmt('SHA-256 of ansistring ''%s'' rendered l-endian base64 is:', [a]);
    end;
  (*else
    begin
    s := edtHashSource.Text;
    StringHash.HashString( s);
//{$IFDEF UNICODE}
    LogFmt( 'SHA-384 of UTF-16 ''%s'' rendered in little-endien base64 is:', [s])
//{$ELSE}
    Log( 'This compiler does not support UTF-16.');
    LogFmt( 'SHA-384 of ansistring ''%s'' rendered in little-endien heximal is:', [s])
//{$ENDIF
    end;  *)
  a:= '$';
 repeat
  HashWord:= 0;
  Xfer:= fileHash.HashOutputValue.Read(HashWord, SizeOf(HashWord));
  if Xfer = 0 then break;
  if a <> '$' then
    a:= a + ' ';
    //a:= a + Format(Format( '%%.%dx', [Xfer * 2]), [HashWord]);
    a:= a + Format('%x', [endianlong(hashword)]);   //max
    //log(a);
    //log(inttostr(hashword)) // debug
   until Xfer < SizeOf(HashWord);
     LogFmt('Hash = %s', [a]);
    result:= a;
    //result:= filehash.hash;
   CryptographicLibrary1.Free;
   fileHash.Free;
end;

function ComputeSHA512(astr: string; amode: char): string;
var
  a: ansistring;
  //s: string;
  HashWord: longword;//uint32;
  Xfer: integer;
  fileHash: THash;
  CryptographicLibrary1: TCryptographicLibrary;

begin
  CryptographicLibrary1:= TCryptographicLibrary.Create(NIL);
  fileHash:= THash.Create(NIL);
  fileHash.CryptoLibrary:= CryptographicLibrary1;
  //fileHash.HashId:= 'native.hash.SHA-384';
  fileHash.HashId:= 'native.hash.SHA-512';
  //fileHash.HashId:= 'native.hash.SHA1';
    a:= astr;   //edtHashSource.Text;
    //StringHash.HashAnsiString( a);
    if amode = 'F' then begin
        filehash.HashFile(a);
      LogFmt( 'SHA-512 of file ''%s'' rendered l-endian base64 is:', [a]);
    end;
    if amode = 'S' then begin
       filehash.HashAnsiString(a);
    LogFmt( 'SHA-512 of ansistring ''%s'' rendered l-endian base64 is:', [a]);
    end;
  a:= '$';
 repeat
  HashWord:= 0;
  Xfer:= fileHash.HashOutputValue.Read(HashWord, SizeOf(HashWord));
  if Xfer = 0 then break;
  if a <> '$' then
    a:= a + ' ';
    //a:= a + Format(Format( '%%.%dx', [Xfer * 2]), [HashWord])
    a:= a + Format('%x', [endianlong(hashword)]);   //max
  until Xfer < SizeOf(HashWord);
    LogFmt('Hash = %s', [a]);
    result:= a;
   CryptographicLibrary1.Free;
   fileHash.Free;
end;

procedure TSHA512_TestCase_ExtraReferenceTests;
var FReferenceTestSource, FReferenceTestRefrnc: string;
begin
FReferenceTestSource := 'abcdefghbcdefghicdefghijdefghijkefghijklfghijk' +
 'lmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu';
FReferenceTestRefrnc := '8E959B75 DAE313DA 8CF4F728 14FC143F ' +
 '8F7779C6 EB9F7FA1 7299AEAD B6889018 501D289E 4900F7E4 ' +
 '331B99DE C4B5433A C7D329EE B6DD2654 5E96E55B 874BE909';
//ReferenceTestVectors
end;



(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TAES(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAES) do
  begin
    RegisterConstructor(@TAES.Create, 'Create');
  end;
end;


procedure RIRegister_uTPLb_AES_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AESSymetricExecute, 'AESSymetricExecute', cdRegister);
 S.RegisterDelphiFunction(@AESSymetricExecute, 'AESEncryptFile', cdRegister);
 S.RegisterDelphiFunction(@AESDecryptFile, 'AESDecryptFile', cdRegister);
 S.RegisterDelphiFunction(@AESSymetricExecute, 'AESEncryptFile2', cdRegister);
 S.RegisterDelphiFunction(@AESDecryptFile, 'AESDecryptFile2', cdRegister);
 S.RegisterDelphiFunction(@AESEncryptString, 'AESEncryptString', cdRegister);
 S.RegisterDelphiFunction(@AESDecryptString, 'AESDecryptString', cdRegister);
 S.RegisterDelphiFunction(@ComputeSHA256, 'ComputeSHA256', cdRegister);
 S.RegisterDelphiFunction(@ComputeSHA256, 'SHA256', cdRegister);
 S.RegisterDelphiFunction(@ComputeSHA512, 'SHA512', cdRegister);
 S.RegisterDelphiFunction(@ComputeSHA512, 'ComputeSHA512', cdRegister);
 S.RegisterDelphiFunction(@SymetricCompareFiles, 'SymetricCompareFiles', cdRegister);
 S.RegisterDelphiFunction(@PutLinuxLines, 'PutLinuxLines', cdRegister);
 S.RegisterDelphiFunction(@EndianWord, 'EndianWord', cdRegister);
 S.RegisterDelphiFunction(@EndianInt, 'EndianInt', cdRegister);
 S.RegisterDelphiFunction(@EndianLong, 'EndianLong', cdRegister);
 S.RegisterDelphiFunction(@EndianWord, 'SwapWord', cdRegister);
 S.RegisterDelphiFunction(@EndianInt, 'SwapInt', cdRegister);
 S.RegisterDelphiFunction(@EndianInt, 'Swap', cdRegister);
 S.RegisterDelphiFunction(@EndianLong, 'SwapLong', cdRegister);

  //S.RegisterDelphiFunction(@GetFileVersion, 'GetFileVersion', cdRegister);
 //S.RegisterDelphiFunction(@Languages, 'Languages', cdRegister);
end;



procedure TBlockMode_TestCase_SetUp;
var
  //Codec_TestAccess: ICodec_TestAccess;
  s: ansistring;
  myaes: TAES;
begin
//FLib   := TCryptographicLibrary.Create( nil);
//Lib.RegisterBlockChainingModel( TPure_ECB.Create as IBlockChainingModel);
   myaes:= TAES.Create(256);
   myaes.Free;
{FCodec := TCodec.Create( nil);
FCodec.CryptoLibrary  := FLib;
FCodec.StreamCipherId := 'native.StreamToBlock';
FCodec.BlockCipherId  := CipherId;
FCodec.ChainModeId    := sPure_ECB_Id;
FOriginal        := TMemoryStream.Create;
FCiphertext      := TMemoryStream.Create;
FKeyStream       := TMemoryStream.Create;
FReferenceStream := TMemoryStream.Create;
if Supports( FCodec, ICodec_TestAccess, Codec_TestAccess) and
   (Codec_TestAccess.GetCodecIntf.BlockCipher <> nil) then
  with Codec_TestAccess.GetCodecIntf.BlockCipher do begin
    FFeatures  := Features;
    FBlockSize := BlockSize div 8;
    {Read_BigEndien_u32_Hex( SelfTest_Key , FKeyStream);
    FKeyStream.Position := 0;
    NormalizeKeyStream;
    FKeyStream.Position := 0;
    s := SelfTest_Plaintext;
    Read_BigEndien_u32_Hex( s , FOriginal);
    // Original MUST be an exact multiple (probably 1) of the block size.
    s := SelfTest_Ciphertext;
    Read_BigEndien_u32_Hex( s, FReferenceStream)
    end else begin
      FFeatures  := [afNotImplementedYet];
      FBlockSize := 1
    end}
end;


{ TPSImport_uTPLb_AES }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_AES.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_AES(CompExec.Comp);
//varfunction randSeed: longint');

end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_AES.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_AES(ri);
  RIRegister_uTPLb_AES_Routines(CompExec.Exec); // comment it if no routines

end;
(*----------------------------------------------------------------------------*)
 
end.
