unit uPSI_CDSUtil;
{
To support CDS  and DB  activate 2 funcs on mX4

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
  TPSImport_CDSUtil = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_CDSUtil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CDSUtil_Routines(S: TPSExec);

procedure Register;

implementation


uses
   DbClient
  ,DbTables
  ,CDSUtil
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CDSUtil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_CDSUtil(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function RetrieveDeltas( const cdsArray : array of TClientDataset) : Variant');
 CL.AddDelphiFunction('Function RetrieveProviders( const cdsArray : array of TClientDataset) : Variant');
 CL.AddDelphiFunction('Procedure ReconcileDeltas( const cdsArray : array of TClientDataset; vDeltaArray : OleVariant)');
 CL.AddDelphiFunction('Procedure CDSApplyUpdates( ADatabase : TDatabase; var vDeltaArray : OleVariant; const vProviderArray : OleVariant; Local : Boolean)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_CDSUtil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RetrieveDeltas, 'RetrieveDeltas', cdRegister);
 S.RegisterDelphiFunction(@RetrieveProviders, 'RetrieveProviders', cdRegister);
 S.RegisterDelphiFunction(@ReconcileDeltas, 'ReconcileDeltas', cdRegister);
 S.RegisterDelphiFunction(@CDSApplyUpdates, 'CDSApplyUpdates', cdRegister);
end;

 
 
{ TPSImport_CDSUtil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CDSUtil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CDSUtil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CDSUtil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_CDSUtil(ri);
  RIRegister_CDSUtil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
