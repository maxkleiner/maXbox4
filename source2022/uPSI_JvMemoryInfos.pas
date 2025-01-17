unit uPSI_JvMemoryInfos;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_JvMemoryInfos = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvMemoryInfos(CL: TPSPascalCompiler);
procedure SIRegister_JvMemoryInfos(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvMemoryInfos(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvMemoryInfos(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ExtCtrls
  ,Forms
  ,JvTypes
  ,JvComponent
  ,JvMemoryInfos
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvMemoryInfos]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMemoryInfos(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvMemoryInfos') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvMemoryInfos') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Refresh( Sender : TObject)');
    RegisterProperty('AutoRefresh', 'Boolean', iptrw);
    RegisterProperty('RefreshDelay', 'Integer', iptrw);
    RegisterProperty('TotalMemory', 'string', iptrw);
    RegisterProperty('FreeMemory', 'string', iptrw);
    RegisterProperty('NumberOfPages', 'string', iptrw);
    RegisterProperty('DisponiblePages', 'string', iptrw);
    RegisterProperty('NumberOfRegions', 'string', iptrw);
    RegisterProperty('DisponibleRegions', 'string', iptrw);
    RegisterProperty('MemoryLoad', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvMemoryInfos(CL: TPSPascalCompiler);
begin
  SIRegister_TJvMemoryInfos(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosMemoryLoad_W(Self: TJvMemoryInfos; const T: string);
begin Self.MemoryLoad := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosMemoryLoad_R(Self: TJvMemoryInfos; var T: string);
begin T := Self.MemoryLoad; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosDisponibleRegions_W(Self: TJvMemoryInfos; const T: string);
begin Self.DisponibleRegions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosDisponibleRegions_R(Self: TJvMemoryInfos; var T: string);
begin T := Self.DisponibleRegions; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosNumberOfRegions_W(Self: TJvMemoryInfos; const T: string);
begin Self.NumberOfRegions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosNumberOfRegions_R(Self: TJvMemoryInfos; var T: string);
begin T := Self.NumberOfRegions; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosDisponiblePages_W(Self: TJvMemoryInfos; const T: string);
begin Self.DisponiblePages := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosDisponiblePages_R(Self: TJvMemoryInfos; var T: string);
begin T := Self.DisponiblePages; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosNumberOfPages_W(Self: TJvMemoryInfos; const T: string);
begin Self.NumberOfPages := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosNumberOfPages_R(Self: TJvMemoryInfos; var T: string);
begin T := Self.NumberOfPages; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosFreeMemory_W(Self: TJvMemoryInfos; const T: string);
begin Self.FreeMemory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosFreeMemory_R(Self: TJvMemoryInfos; var T: string);
begin T := Self.FreeMemory; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosTotalMemory_W(Self: TJvMemoryInfos; const T: string);
begin Self.TotalMemory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosTotalMemory_R(Self: TJvMemoryInfos; var T: string);
begin T := Self.TotalMemory; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosRefreshDelay_W(Self: TJvMemoryInfos; const T: Integer);
begin Self.RefreshDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosRefreshDelay_R(Self: TJvMemoryInfos; var T: Integer);
begin T := Self.RefreshDelay; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosAutoRefresh_W(Self: TJvMemoryInfos; const T: Boolean);
begin Self.AutoRefresh := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryInfosAutoRefresh_R(Self: TJvMemoryInfos; var T: Boolean);
begin T := Self.AutoRefresh; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMemoryInfos(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMemoryInfos) do
  begin
    RegisterConstructor(@TJvMemoryInfos.Create, 'Create');
    RegisterMethod(@TJvMemoryInfos.Refresh, 'Refresh');
    RegisterPropertyHelper(@TJvMemoryInfosAutoRefresh_R,@TJvMemoryInfosAutoRefresh_W,'AutoRefresh');
    RegisterPropertyHelper(@TJvMemoryInfosRefreshDelay_R,@TJvMemoryInfosRefreshDelay_W,'RefreshDelay');
    RegisterPropertyHelper(@TJvMemoryInfosTotalMemory_R,@TJvMemoryInfosTotalMemory_W,'TotalMemory');
    RegisterPropertyHelper(@TJvMemoryInfosFreeMemory_R,@TJvMemoryInfosFreeMemory_W,'FreeMemory');
    RegisterPropertyHelper(@TJvMemoryInfosNumberOfPages_R,@TJvMemoryInfosNumberOfPages_W,'NumberOfPages');
    RegisterPropertyHelper(@TJvMemoryInfosDisponiblePages_R,@TJvMemoryInfosDisponiblePages_W,'DisponiblePages');
    RegisterPropertyHelper(@TJvMemoryInfosNumberOfRegions_R,@TJvMemoryInfosNumberOfRegions_W,'NumberOfRegions');
    RegisterPropertyHelper(@TJvMemoryInfosDisponibleRegions_R,@TJvMemoryInfosDisponibleRegions_W,'DisponibleRegions');
    RegisterPropertyHelper(@TJvMemoryInfosMemoryLoad_R,@TJvMemoryInfosMemoryLoad_W,'MemoryLoad');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvMemoryInfos(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvMemoryInfos(CL);
end;

 
 
{ TPSImport_JvMemoryInfos }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvMemoryInfos.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvMemoryInfos(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvMemoryInfos.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvMemoryInfos(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
