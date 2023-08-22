unit uPSI_XmlRpcCommon;
{
Intermediate transformations to and from the client - needs the interface type

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
  TPSImport_XmlRpcCommon = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRC4(CL: TPSPascalCompiler);
procedure SIRegister_XmlRpcCommon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_XmlRpcCommon_Routines(S: TPSExec);
procedure RIRegister_TRC4(CL: TPSRuntimeClassImporter);
procedure RIRegister_XmlRpcCommon(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,IdHash
  ,Variants
  ,XmlRpcCommon
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XmlRpcCommon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRC4(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRC4') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRC4') do
  begin
    RegisterMethod('Constructor Create( const EncryptionKey : string)');
    RegisterMethod('Procedure EncryptStream( InStream, OutStream : TMemoryStream)');
    RegisterMethod('Function EncryptString( const Value : string) : string');
    RegisterMethod('Procedure DecryptStream( InStream, OutStream : TMemoryStream)');
    RegisterMethod('Function DecryptString( const Value : string) : string');
    RegisterMethod('Procedure BurnKey');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XmlRpcCommon(CL: TPSPascalCompiler);
begin
  SIRegister_TRC4(CL);
  CL.AddTypeS('TRPCDataType', '( rpNone, rpString, rpInteger, rpBoolean, rpDoub'
   +'le, rpDate, rpBase64, rpStruct, rpArray, rpName, rpError )');
 CL.AddDelphiFunction('Function GetTempDirRPC : string');
 CL.AddDelphiFunction('Function FileIsExpired( const FileName : string; Elapsed : Integer) : Boolean');
 CL.AddDelphiFunction('Function EncodeEntities( const Data : string) : string');
 CL.AddDelphiFunction('Function DecodeEntities( const Data : string) : string');
 CL.AddDelphiFunction('Function ReplaceRPC( const Data : string; const Find : string; const Replace : string) : string');
 CL.AddDelphiFunction('Function InStr( Start : Integer; const Data : string; const Find : string) : Integer');
 CL.AddDelphiFunction('Function Mid( const Data : string; Start : Integer) : string');
 CL.AddDelphiFunction('Function DateTimeToISO( ConvertDate : TDateTime) : string');
 CL.AddDelphiFunction('Function IsoToDateTime( const ISOStringDate : string) : TDateTime');
 CL.AddDelphiFunction('Function ParseStringRPC( const SearchString : string; Delimiter : Char; Substrings : TStrings; const AllowEmptyStrings : Boolean; ClearBeforeParse : Boolean) : Integer');
 CL.AddDelphiFunction('Function ParseStream( SearchStream : TStream; Delimiter : Char; Substrings : TStrings; AllowEmptyStrings : Boolean; ClearBeforeParse : Boolean) : Integer');
 CL.AddDelphiFunction('Function FixEmptyString( const Value : string) : string');
 CL.AddDelphiFunction('Function URLEncodeRPC( const Value : string) : string');
 CL.AddDelphiFunction('Function StreamToStringRPC( Stream : TStream) : string');
 CL.AddDelphiFunction('Procedure StringToStream( const Text : string; Stream : TStream)');
 CL.AddDelphiFunction('Function StreamToVariant( Stream : TStream) : OleVariant');
 CL.AddDelphiFunction('Procedure VariantToStream( V : OleVariant; Stream : TStream)');
 CL.AddDelphiFunction('Function Hash128AsHex( const Hash128Value : T4x4LongWordRecord) : string');
 CL.AddConstantN('ValidURLChars','String').SetString( 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_@.&+-!''*"(),;/#?:');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_XmlRpcCommon_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetTempDir, 'GetTempDirRPC', cdRegister);
 S.RegisterDelphiFunction(@FileIsExpired, 'FileIsExpired', cdRegister);
 S.RegisterDelphiFunction(@EncodeEntities, 'EncodeEntities', cdRegister);
 S.RegisterDelphiFunction(@DecodeEntities, 'DecodeEntities', cdRegister);
 S.RegisterDelphiFunction(@Replace, 'ReplaceRPC', cdRegister);
 S.RegisterDelphiFunction(@InStr, 'InStr', cdRegister);
 S.RegisterDelphiFunction(@Mid, 'Mid', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToISO, 'DateTimeToISO', cdRegister);
 S.RegisterDelphiFunction(@IsoToDateTime, 'IsoToDateTime', cdRegister);
 S.RegisterDelphiFunction(@ParseString, 'ParseStringRPC', cdRegister);
 S.RegisterDelphiFunction(@ParseStream, 'ParseStream', cdRegister);
 S.RegisterDelphiFunction(@FixEmptyString, 'FixEmptyString', cdRegister);
 S.RegisterDelphiFunction(@URLEncode, 'URLEncodeRPC', cdRegister);
 S.RegisterDelphiFunction(@StreamToString, 'StreamToStringRPC', cdRegister);
 S.RegisterDelphiFunction(@StringToStream, 'StringToStream', cdRegister);
 S.RegisterDelphiFunction(@StreamToVariant, 'StreamToVariant', cdRegister);
 S.RegisterDelphiFunction(@VariantToStream, 'VariantToStream', cdRegister);
 S.RegisterDelphiFunction(@Hash128AsHex, 'Hash128AsHex', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRC4(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRC4) do
  begin
    RegisterConstructor(@TRC4.Create, 'Create');
    RegisterMethod(@TRC4.EncryptStream, 'EncryptStream');
    RegisterMethod(@TRC4.EncryptString, 'EncryptString');
    RegisterMethod(@TRC4.DecryptStream, 'DecryptStream');
    RegisterMethod(@TRC4.DecryptString, 'DecryptString');
    RegisterMethod(@TRC4.BurnKey, 'BurnKey');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XmlRpcCommon(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRC4(CL);
end;

 
 
{ TPSImport_XmlRpcCommon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlRpcCommon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XmlRpcCommon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlRpcCommon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XmlRpcCommon(ri);
  RIRegister_XmlRpcCommon_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
