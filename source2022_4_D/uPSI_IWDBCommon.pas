unit uPSI_IWDBCommon;
{
  first IWDB
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
  TPSImport_IWDBCommon = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IWDBCommon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IWDBCommon_Routines(S: TPSExec);

procedure Register;

implementation


uses
   DB
  ,IWDBCommon
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IWDBCommon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IWDBCommon(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function InEditMode( ADataset : TDataset) : Boolean');
 CL.AddDelphiFunction('Function CheckDataSource( ADataSource : TDataSource) : Boolean;');
 CL.AddDelphiFunction('Function CheckDataSource1( ADataSource : TDataSource; const AFieldName : string; var VField : TField) : boolean;');
 CL.AddDelphiFunction('Function GetFieldText( AField : TField) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function CheckDataSource1_P( ADataSource : TDataSource; const AFieldName : string; var VField : TField) : boolean;
Begin Result := IWDBCommon.CheckDataSource(ADataSource, AFieldName, VField); END;

(*----------------------------------------------------------------------------*)
Function CheckDataSource_P( ADataSource : TDataSource) : Boolean;
Begin Result := IWDBCommon.CheckDataSource(ADataSource); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IWDBCommon_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InEditMode, 'InEditMode', cdRegister);
 S.RegisterDelphiFunction(@CheckDataSource_P, 'CheckDataSource', cdRegister);
 S.RegisterDelphiFunction(@CheckDataSource1_P, 'CheckDataSource1', cdRegister);
 S.RegisterDelphiFunction(@GetFieldText, 'GetFieldText', cdRegister);
end;

 
 
{ TPSImport_IWDBCommon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IWDBCommon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IWDBCommon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IWDBCommon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_IWDBCommon(ri);
  RIRegister_IWDBCommon_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
