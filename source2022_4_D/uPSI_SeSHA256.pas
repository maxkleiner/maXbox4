unit uPSI_SeSHA256;
{
proepare for blockchain in syndat
https://github.com/ildemartinez/Delphi-Component-for-BlockChain-Dat-Files/blob/master/SeSHA256.pas

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
  TPSImport_SeSHA256 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_SeSHA256(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SeSHA256_Routines(S: TPSExec);

procedure Register;

implementation


uses
   SeSHA256
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SeSHA256]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_SeSHA256(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('seHEADERSIZE','LongInt').SetInt( 80);
 CL.AddConstantN('emptystring','string').setstring('');
 CL.AddTypeS('T32se', 'array [0 .. 31] of byte;');
 CL.AddTypeS('THeaderse', 'array [0 .. seHEADERSIZE - 1] of byte;');
 //T32 = array [0 .. 31] of byte;
 // To store the block header
 // THeader = array [0 .. HEADERSIZE - 1] of byte;
 // CL.AddTypeS('PSHA256HASH', '^TSHA256HASH // will not work');
 CL.AddDelphiFunction('Function CalcSHA256String( Msg : AnsiString) : TSHA256HASH;');
 CL.AddDelphiFunction('Function CalcSHA256Stream( Stream : TStream) : TSHA256HASH;');
 CL.AddDelphiFunction('Function seSHA256ToStr( Hash : TSHA256HASH) : String');
 CL.AddDelphiFunction('Function SHA256ToBinaryStr( Hash : TSHA256HASH) : AnsiString');
 CL.AddDelphiFunction('Function ReverseHash( Hash : string) : string');
 CL.AddDelphiFunction('Function GetMemoryStream : TMemoryStream');
 CL.AddDelphiFunction('Function T32ToString( const at32 : T32se) : string');
 CL.AddDelphiFunction('Function CalcHeaderSHA256( aHeader : THeaderse) : TSHA256HASH;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function CalcHeaderSHA256_P( aHeader : THeader) : TSHA256HASH;
Begin Result := SeSHA256.CalcHeaderSHA256(aHeader); END;

(*----------------------------------------------------------------------------*)
Function CalcSHA256Stream_P( Stream : TStream) : TSHA256HASH;
Begin Result := SeSHA256.CalcSHA256(Stream); END;

(*----------------------------------------------------------------------------*)
Function CalcSHA256String_P( Msg : AnsiString) : TSHA256HASH;
Begin Result := SeSHA256.CalcSHA256(Msg); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SeSHA256_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CalcSHA256String_P, 'CalcSHA256String', cdRegister);
 S.RegisterDelphiFunction(@CalcSHA256Stream_P, 'CalcSHA256Stream', cdRegister);
 S.RegisterDelphiFunction(@SHA256ToStr, 'seSHA256ToStr', cdRegister);
 S.RegisterDelphiFunction(@SHA256ToBinaryStr, 'SHA256ToBinaryStr', cdRegister);
 S.RegisterDelphiFunction(@ReverseHash, 'ReverseHash', cdRegister);
 S.RegisterDelphiFunction(@GetMemoryStream, 'GetMemoryStream', cdRegister);
 S.RegisterDelphiFunction(@T32ToString, 'T32ToString', cdRegister);
 S.RegisterDelphiFunction(@CalcHeaderSHA256, 'CalcHeaderSHA256', cdRegister);
end;

 
 
{ TPSImport_SeSHA256 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SeSHA256.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SeSHA256(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SeSHA256.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SeSHA256_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
