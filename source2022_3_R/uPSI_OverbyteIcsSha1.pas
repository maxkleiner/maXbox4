unit uPSI_OverbyteIcsSha1;
{
fofr bitcoin    woth context    fix input

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
  TPSImport_OverbyteIcsSha1 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_OverbyteIcsSha1(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_OverbyteIcsSha1_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // OverbyteIcsTypes
  OverbyteIcsSha1
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OverbyteIcsSha1]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_OverbyteIcsSha1(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IcsSHA1Version','LongInt').SetInt( 800);
 //CL.AddConstantN('CopyRight','String').SetString( ' IcsSHA1 (c) 2004-2012 F. Piette V8.00 ');
 CL.AddConstantN('shaSuccess','LongInt').SetInt( 0);
 CL.AddConstantN('shaNull','LongInt').SetInt( 1);
 CL.AddConstantN('shaInputTooLong','LongInt').SetInt( 2);
 CL.AddConstantN('shaStateError','LongInt').SetInt( 3);
 CL.AddConstantN('SHA1HashSize','LongInt').SetInt( 20);
  CL.AddTypeS('uint32_t', 'LongWord');
  CL.AddTypeS('uint8_t', 'Byte');
  CL.AddTypeS('int_least16_t', 'LongInt');
  CL.AddTypeS('SHA1DigestString', 'AnsiString');
  CL.AddTypeS('SHA1Digest', 'array[0..19] of AnsiChar;');

  CL.AddTypeS('SHA1Context', 'record Intermediate_Hash: array[0..SHA1HashSize div 4-1] of uint32_t; Length_Low : uint32_t; Length_High : uint3'
   +'2_t; Message_Block_Index : int_least16_t; Message_Block: array[0..63] of uint8_t; Computed : Integer; Corrupted : '
   +'Integer; end');

 // SHA1Digest = array[0..SHA1HashSize-1] of AnsiChar;
 CL.AddDelphiFunction('Function SHA1Reset( var context : SHA1Context) : Integer');
 CL.AddDelphiFunction('Function SHA1Input( var context : SHA1Context; const message_array : String; length : Cardinal) : Integer');
 CL.AddDelphiFunction('Function SHA1Input2( var context : SHA1Context; const message_array : String; length : Cardinal) : Integer');

 CL.AddDelphiFunction('Function SHA1Result( var context : SHA1Context; var Message_Digest : SHA1Digest) : Integer');
 CL.AddDelphiFunction('Function SHA1ofStr( const s : AnsiString) : SHA1DigestString');
 CL.AddDelphiFunction('Function SHA1ofBuf( const buf, buflen : Integer) : SHA1DigestString');
 CL.AddDelphiFunction('Function SHA1ofStream( const strm : TStream) : SHA1DigestString');
 CL.AddDelphiFunction('Function SHA1toHex( const digest : SHA1DigestString) : String');
 CL.AddDelphiFunction('Function StrtoHex1( const digest : SHA1DigestString) : String');

 CL.AddDelphiFunction('Function SHA1DigestToLowerHex( const Digest : SHA1Digest) : String');
 CL.AddDelphiFunction('Function SHA1DigestToLowerHexA( const Digest : SHA1Digest) : RawByteString');
 CL.AddDelphiFunction('Function SHA1DigestToLowerHexW( const Digest : SHA1Digest) : UnicodeString');
 CL.AddDelphiFunction('Procedure HMAC_SHA1( const Data, DataLen : Integer; const Key, KeyLen : Integer; out Digest : SHA1Digest)');
 CL.AddDelphiFunction('Function HMAC_SHA1_EX( const Data : AnsiString; const Key : AnsiString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_OverbyteIcsSha1_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SHA1Reset, 'SHA1Reset', cdRegister);
 S.RegisterDelphiFunction(@SHA1Input, 'SHA1Input', cdRegister);
 S.RegisterDelphiFunction(@SHA1Input2, 'SHA1Input2', cdRegister);

 S.RegisterDelphiFunction(@SHA1Result, 'SHA1Result', cdRegister);
 S.RegisterDelphiFunction(@SHA1ofStr, 'SHA1ofStr', cdRegister);
 S.RegisterDelphiFunction(@SHA1ofBuf, 'SHA1ofBuf', cdRegister);
 S.RegisterDelphiFunction(@SHA1ofStream, 'SHA1ofStream', cdRegister);
 S.RegisterDelphiFunction(@SHA1toHex, 'SHA1toHex', cdRegister);
 S.RegisterDelphiFunction(@SHA1toHex, 'StrtoHex1', cdRegister);

 S.RegisterDelphiFunction(@SHA1DigestToLowerHex, 'SHA1DigestToLowerHex', cdRegister);
 S.RegisterDelphiFunction(@SHA1DigestToLowerHexA, 'SHA1DigestToLowerHexA', cdRegister);
 S.RegisterDelphiFunction(@SHA1DigestToLowerHexW, 'SHA1DigestToLowerHexW', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA1, 'HMAC_SHA1', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA1_EX, 'HMAC_SHA1_EX', cdRegister);
end;

 
 
{ TPSImport_OverbyteIcsSha1 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsSha1.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OverbyteIcsSha1(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsSha1.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OverbyteIcsSha1_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
