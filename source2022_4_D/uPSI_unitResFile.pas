unit uPSI_unitResFile;
{
  of XN Res
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
  TPSImport_unitResFile = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TResModule(CL: TPSPascalCompiler);
procedure SIRegister_TResourceList(CL: TPSPascalCompiler);
procedure SIRegister_unitResFile(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TResModule(CL: TPSRuntimeClassImporter);
procedure RIRegister_TResourceList(CL: TPSRuntimeClassImporter);
procedure RIRegister_unitResFile(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ConTnrs
  ,unitResourceDetails
  ,unitResFile
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_unitResFile]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TResModule(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TResourceList', 'TResModule') do
  with CL.AddClassN(CL.FindClass('TResourceList'),'TResModule') do
  begin
    RegisterMethod('Procedure SaveToStream( stream : TStream)');
    RegisterMethod('Procedure LoadFromStream( stream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TResourceList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TResourceModule', 'TResourceList') do
  with CL.AddClassN(CL.FindClass('TResourceModule'),'TResourceList') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Assign( src : TResourceModule)');
    RegisterMethod('Procedure InsertResource( idx : Integer; details : TResourceDetails)');
    RegisterMethod('Procedure DeleteResource( idx : Integer)');
    RegisterMethod('Function AddResource( details : TResourceDetails) : Integer');
    RegisterMethod('Function IndexOfResource( details : TResourceDetails) : Integer');
    RegisterMethod('Procedure SortResources');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_unitResFile(CL: TPSPascalCompiler);
begin
  SIRegister_TResourceList(CL);
  SIRegister_TResModule(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TResModule(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TResModule) do
  begin
    RegisterMethod(@TResModule.SaveToStream, 'SaveToStream');
    RegisterMethod(@TResModule.LoadFromStream, 'LoadFromStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TResourceList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TResourceList) do begin
    RegisterConstructor(@TResourceList.Create, 'Create');
      RegisterMethod(@TResourceList.Destroy, 'Free');
      RegisterMethod(@TResourceList.Assign, 'Assign');
    RegisterMethod(@TResourceList.InsertResource, 'InsertResource');
    RegisterMethod(@TResourceList.DeleteResource, 'DeleteResource');
    RegisterMethod(@TResourceList.AddResource, 'AddResource');
    RegisterMethod(@TResourceList.IndexOfResource, 'IndexOfResource');
    RegisterMethod(@TResourceList.SortResources, 'SortResources');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_unitResFile(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TResourceList(CL);
  RIRegister_TResModule(CL);
end;

 
 
{ TPSImport_unitResFile }
(*----------------------------------------------------------------------------*)
procedure TPSImport_unitResFile.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_unitResFile(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_unitResFile.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_unitResFile(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
