unit uPSI_USha256;
{
this is what im looking for pascal coin

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
  TPSImport_USha256 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_USha256(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_USha256_Routines(S: TPSExec);

procedure Register;

implementation


uses
   USha256
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_USha256]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_USha256(CL: TPSPascalCompiler);
begin
 CL.AddTypeS('TSHA256HASH', 'array[0..7] of Cardinal');
 CL.AddTypeS('TSHAChunk', 'array[0..7] of Cardinal');

 //TSHA256HASH = array[0..7] of Cardinal;
  //TChunk = array[0..15] of Cardinal;
 CL.AddDelphiFunction('Function CalcDoubleSHA256( Msg : AnsiString) : TSHA256HASH');
 CL.AddDelphiFunction('Function CalcSHA256( Msg : AnsiString) : TSHA256HASH;');
 CL.AddDelphiFunction('Function GetSHA256( Msg : AnsiString) : string;');

 CL.AddDelphiFunction('Function CalcSHA2561( Stream : TStream) : TSHA256HASH;');
 CL.AddDelphiFunction('Function SHA256ToStr( Hash : TSHA256HASH) : String');
 CL.AddDelphiFunction('Function CanBeModifiedOnLastChunk( MessageTotalLength : Int64; var startBytePos : integer) : Boolean');
 CL.AddDelphiFunction('Procedure PascalCoinPrepareLastChunk( const messageToHash : AnsiString; var stateForLastChunk : TSHA256HASH; var bufferForLastChunk : TSHAChunk)');
 CL.AddDelphiFunction('Function ExecuteLastChunk( const stateForLastChunk : TSHA256HASH; const bufferForLastChunk : TSHAChunk; nPos : Integer; nOnce, Timestamp : Cardinal) : TSHA256HASH');
 CL.AddDelphiFunction('Function ExecuteLastChunkAndDoSha256( const stateForLastChunk : TSHA256HASH; const bufferForLastChunk : TSHAChunk; nPos : Integer; nOnce, Timestamp : Cardinal) : TSHA256HASH');
 CL.AddDelphiFunction('Procedure PascalCoinExecuteLastChunkAndDoSha256( const stateForLastChunk : TSHA256HASH; const bufferForLastChunk : TSHAChunk; nPos : Integer; nOnce, Timestamp : Cardinal; var ResultSha256 : AnsiString)');
 CL.AddDelphiFunction('Function Sha256HashToRaw( const hash : TSHA256HASH) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function CalcSHA2561_P( Stream : TStream) : TSHA256HASH;
Begin Result := USha256.CalcSHA256(Stream); END;

(*----------------------------------------------------------------------------*)
Function CalcSHA256_P( Msg : AnsiString) : TSHA256HASH;
Begin Result := USha256.CalcSHA256(Msg); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_USha256_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CalcDoubleSHA256, 'CalcDoubleSHA256', cdRegister);
 S.RegisterDelphiFunction(@CalcSHA256_P, 'CalcSHA256', cdRegister);
 S.RegisterDelphiFunction(@CalcSHA2561_P, 'CalcSHA2561', cdRegister);
 S.RegisterDelphiFunction(@SHA256ToStr, 'SHA256ToStr', cdRegister);
 S.RegisterDelphiFunction(@CanBeModifiedOnLastChunk, 'CanBeModifiedOnLastChunk', cdRegister);
 S.RegisterDelphiFunction(@PascalCoinPrepareLastChunk, 'PascalCoinPrepareLastChunk', cdRegister);
 S.RegisterDelphiFunction(@ExecuteLastChunk, 'ExecuteLastChunk', cdRegister);
 S.RegisterDelphiFunction(@ExecuteLastChunkAndDoSha256, 'ExecuteLastChunkAndDoSha256', cdRegister);
 S.RegisterDelphiFunction(@PascalCoinExecuteLastChunkAndDoSha256, 'PascalCoinExecuteLastChunkAndDoSha256', cdRegister);
 S.RegisterDelphiFunction(@Sha256HashToRaw, 'Sha256HashToRaw', cdRegister);
  S.RegisterDelphiFunction(@GetSHA256, 'GetSHA256', cdRegister);

end;

 

{ TPSImport_USha256 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_USha256.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_USha256(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_USha256.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_USha256_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
