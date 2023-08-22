unit uPSI_ChronCheck;
{
   master chron clock  campbell
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
  TPSImport_ChronCheck = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TChron(CL: TPSPascalCompiler);
procedure SIRegister_TCheckArray(CL: TPSPascalCompiler);
procedure SIRegister_ChronCheck(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TChron(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCheckArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_ChronCheck(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   StdCtrls
  ,ChronCheck
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ChronCheck]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TChron(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TChron') do
  with CL.AddClassN(CL.FindClass('TObject'),'TChron') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
    RegisterMethod('Function SetSpecs( var ArraySpec : TCheckArraySpec) : BOOLEAN');
    RegisterMethod('Function IsMatch( const TargetTime : TDateTime) : BOOLEAN');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCheckArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCheckArray') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCheckArray') do begin
    RegisterMethod('Constructor Create( const check : TCheckIndex)');
    RegisterMethod('Procedure ClearArray');
    RegisterMethod('Function CheckName : STRING');
    RegisterMethod('Function SetFlags( var specs : STRING) : BOOLEAN');
    RegisterMethod('Function IsFlagSet( const index : TCheckArrayIndex) : BOOLEAN');
    RegisterMethod('Procedure Show( var Memo : TMemo)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ChronCheck(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MinCheckArrayIndex','LongInt').SetInt( 0);
 CL.AddConstantN('MaxCheckArrayIndex','LongInt').SetInt( 59);
  CL.AddTypeS('TCheck', '( chMinutes, chHours, chDays, chMonths, chWeekdays )');
   CL.AddTypeS('TCheckArraySpec', 'array[0..4] of string');
   // TCheckArraySpec   = ARRAY[0..4] OF STRING;

  SIRegister_TCheckArray(CL);
  SIRegister_TChron(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TChron(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChron) do begin
    RegisterConstructor(@TChron.Create, 'Create');
        RegisterMethod(@TChron.Destroy, 'Free');
       RegisterMethod(@TChron.SetSpecs, 'SetSpecs');
    RegisterMethod(@TChron.IsMatch, 'IsMatch');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCheckArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCheckArray) do begin
    RegisterConstructor(@TCheckArray.Create, 'Create');
    RegisterMethod(@TCheckArray.ClearArray, 'ClearArray');
    RegisterMethod(@TCheckArray.CheckName, 'CheckName');
    RegisterMethod(@TCheckArray.SetFlags, 'SetFlags');
    RegisterMethod(@TCheckArray.IsFlagSet, 'IsFlagSet');
    RegisterMethod(@TCheckArray.Show, 'Show');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ChronCheck(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCheckArray(CL);
  RIRegister_TChron(CL);
end;

 
 
{ TPSImport_ChronCheck }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ChronCheck.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ChronCheck(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ChronCheck.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ChronCheck(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
