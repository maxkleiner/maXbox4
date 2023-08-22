unit uPSI_synacode;
{
   synapse 2 
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
  TPSImport_synacode = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_synacode(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_synacode_Routines(S: TPSExec);

procedure Register;

implementation


uses
   synacode
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_synacode]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_synacode(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TSpecials', 'set of Char');
 CL.AddConstantN('SpecialChar','TSpecials').SetSet( '=()[]<>:;,@/?\"_');
 CL.AddConstantN('URLFullSpecialChar','TSpecials').SetSet( ';/?:@=&#+');
 CL.AddConstantN('TableBase64','String').SetString( 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=');
 CL.AddConstantN('TableBase64mod','String').SetString( 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,=');
 CL.AddConstantN('TableUU','String').SetString( '`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_');
 CL.AddConstantN('TableXX','String').SetString( '+-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz');
 CL.AddConstantN('ReTablebase64','Char').SetString( #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$3E + #$40 + #$40 + #$40 + #$3F + #$34 + #$35 + #$36 + #$37 + #$38 + #$39 + #$3A + #$3B + #$3C + #$3D + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$00 + #$01 + #$02 + #$03 + #$04 + #$05 + #$06 + #$07 + #$08 + #$09 + #$0A + #$0B + #$0C + #$0D + #$0E + #$0F + #$10 + #$11 + #$12 + #$13 + #$14 + #$15 + #$16 + #$17 + #$18 + #$19 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$1A + #$1B + #$1C + #$1D + #$1E + #$1F + #$20 + #$21 + #$22 + #$23 + #$24 + #$25 + #$26 + #$27 + #$28 + #$29 + #$2A + #$2B + #$2C + #$2D + #$2E + #$2F + #$30 + #$31 + #$32 + #$33 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40);
 CL.AddConstantN('ReTableUU','Char').SetString( #$01 + #$02 + #$03 + #$04 + #$05 + #$06 + #$07 + #$08 + #$09 + #$0A + #$0B + #$0C + #$0D + #$0E + #$0F + #$10 + #$11 + #$12 + #$13 + #$14 + #$15 + #$16 + #$17 + #$18 + #$19 + #$1A + #$1B + #$1C + #$1D + #$1E + #$1F + #$20 + #$21 + #$22 + #$23 + #$24 + #$25 + #$26 + #$27 + #$28 + #$29 + #$2A + #$2B + #$2C + #$2D + #$2E + #$2F + #$30 + #$31 + #$32 + #$33 + #$34 + #$35 + #$36 + #$37 + #$38 + #$39 + #$3A + #$3B + #$3C + #$3D + #$3E + #$3F + #$00 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40);
 CL.AddConstantN('ReTableXX','Char').SetString( #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$00 + #$40 + #$01 + #$40 + #$40 + #$02 + #$03 + #$04 + #$05 + #$06 + #$07 + #$08 + #$09 + #$0A + #$0B + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$0C + #$0D + #$0E + #$0F + #$10 + #$11 + #$12 + #$13 + #$14 + #$15 + #$16 + #$17 + #$18 + #$19 + #$1A + #$1B + #$1C + #$1D + #$1E + #$1F + #$20 + #$21 + #$22 + #$23 + #$24 + #$25 + #$40 + #$40 + #$40 + #$40 + #$40 + #$40 + #$26 + #$27 + #$28 + #$29 + #$2A + #$2B + #$2C + #$2D + #$2E + #$2F + #$30 + #$31 + #$32 + #$33 + #$34 + #$35 + #$36 + #$37 + #$38 + #$39 + #$3A + #$3B + #$3C + #$3D + #$3E + #$3F + #$40 + #$40 + #$40 + #$40 + #$40 + #$40);
 CL.AddDelphiFunction('Function DecodeTriplet( const Value : AnsiString; Delimiter : Char) : AnsiString');
 CL.AddDelphiFunction('Function DecodeQuotedPrintable( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function DecodeURL( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function EncodeTriplet( const Value : AnsiString; Delimiter : Char; Specials : TSpecials) : AnsiString');
 CL.AddDelphiFunction('Function EncodeQuotedPrintable( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function EncodeSafeQuotedPrintable( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function EncodeURLElement( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function EncodeURL( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function Decode4to3( const Value, Table : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function Decode4to3Ex( const Value, Table : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function Encode3to4( const Value, Table : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function synDecodeBase64( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function synEncodeBase64( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function DecodeBase64mod( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function EncodeBase64mod( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function DecodeUU( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function EncodeUU( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function DecodeXX( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function DecodeYEnc( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function UpdateCrc32( Value : Byte; Crc32 : Integer) : Integer');
 CL.AddDelphiFunction('Function synCrc32( const Value : AnsiString) : Integer');
 CL.AddDelphiFunction('Function UpdateCrc16( Value : Byte; Crc16 : Word) : Word');
 CL.AddDelphiFunction('Function Crc16( const Value : AnsiString) : Word');
 CL.AddDelphiFunction('Function synMD5( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function HMAC_MD5( Text, Key : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function MD5LongHash( const Value : AnsiString; Len : integer) : AnsiString');
 CL.AddDelphiFunction('Function synSHA1( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function HMAC_SHA1( Text, Key : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function SHA1LongHash( const Value : AnsiString; Len : integer) : AnsiString');
 CL.AddDelphiFunction('Function synMD4( const Value : AnsiString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_synacode_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DecodeTriplet, 'DecodeTriplet', cdRegister);
 S.RegisterDelphiFunction(@DecodeQuotedPrintable, 'DecodeQuotedPrintable', cdRegister);
 S.RegisterDelphiFunction(@DecodeURL, 'DecodeURL', cdRegister);
 S.RegisterDelphiFunction(@EncodeTriplet, 'EncodeTriplet', cdRegister);
 S.RegisterDelphiFunction(@EncodeQuotedPrintable, 'EncodeQuotedPrintable', cdRegister);
 S.RegisterDelphiFunction(@EncodeSafeQuotedPrintable, 'EncodeSafeQuotedPrintable', cdRegister);
 S.RegisterDelphiFunction(@EncodeURLElement, 'EncodeURLElement', cdRegister);
 S.RegisterDelphiFunction(@EncodeURL, 'EncodeURL', cdRegister);
 S.RegisterDelphiFunction(@Decode4to3, 'Decode4to3', cdRegister);
 S.RegisterDelphiFunction(@Decode4to3Ex, 'Decode4to3Ex', cdRegister);
 S.RegisterDelphiFunction(@Encode3to4, 'Encode3to4', cdRegister);
 S.RegisterDelphiFunction(@DecodeBase64, 'synDecodeBase64', cdRegister);
 S.RegisterDelphiFunction(@EncodeBase64, 'synEncodeBase64', cdRegister);
 S.RegisterDelphiFunction(@DecodeBase64mod, 'DecodeBase64mod', cdRegister);
 S.RegisterDelphiFunction(@EncodeBase64mod, 'EncodeBase64mod', cdRegister);
 S.RegisterDelphiFunction(@DecodeUU, 'DecodeUU', cdRegister);
 S.RegisterDelphiFunction(@EncodeUU, 'EncodeUU', cdRegister);
 S.RegisterDelphiFunction(@DecodeXX, 'DecodeXX', cdRegister);
 S.RegisterDelphiFunction(@DecodeYEnc, 'DecodeYEnc', cdRegister);
 S.RegisterDelphiFunction(@UpdateCrc32, 'UpdateCrc32', cdRegister);
 S.RegisterDelphiFunction(@Crc32, 'synCrc32', cdRegister);
 S.RegisterDelphiFunction(@UpdateCrc16, 'UpdateCrc16', cdRegister);
 S.RegisterDelphiFunction(@Crc16, 'Crc16', cdRegister);
 S.RegisterDelphiFunction(@MD5, 'synMD5', cdRegister);
 S.RegisterDelphiFunction(@HMAC_MD5, 'HMAC_MD5', cdRegister);
 S.RegisterDelphiFunction(@MD5LongHash, 'MD5LongHash', cdRegister);
 S.RegisterDelphiFunction(@SHA1, 'synSHA1', cdRegister);
 S.RegisterDelphiFunction(@HMAC_SHA1, 'HMAC_SHA1', cdRegister);
 S.RegisterDelphiFunction(@SHA1LongHash, 'SHA1LongHash', cdRegister);
 S.RegisterDelphiFunction(@MD4, 'synMD4', cdRegister);
end;

 
 
{ TPSImport_synacode }
(*----------------------------------------------------------------------------*)
procedure TPSImport_synacode.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_synacode(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_synacode.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_synacode(ri);
  RIRegister_synacode_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
