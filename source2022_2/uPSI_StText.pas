unit uPSI_StText;
{
  text processing routines
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
  TPSImport_StText = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StText(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StText_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,STConst
  ,StBase
  ,StSystem
  ,StText
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StText]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StText(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function TextSeek( var F : TextFile; Target : LongInt) : Boolean');
 CL.AddDelphiFunction('Function TextFileSize( var F : TextFile) : LongInt');
 CL.AddDelphiFunction('Function TextPos( var F : TextFile) : LongInt');
 CL.AddDelphiFunction('Function TextFlush( var F : TextFile) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StText_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TextSeek, 'TextSeek', cdRegister);
 S.RegisterDelphiFunction(@TextFileSize, 'TextFileSize', cdRegister);
 S.RegisterDelphiFunction(@TextPos, 'TextPos', cdRegister);
 S.RegisterDelphiFunction(@TextFlush, 'TextFlush', cdRegister);
end;

 
 
{ TPSImport_StText }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StText.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StText(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StText.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StText(ri);
  RIRegister_StText_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
