unit uPSI_ECDataLink;
{
   of dbtreeview
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
  TPSImport_ECDataLink = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TECDataLink(CL: TPSPascalCompiler);
procedure SIRegister_ECDataLink(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TECDataLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_ECDataLink(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Controls
  ,BDE
  ,DB
  ,DBTables
  ,ECDataLink
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ECDataLink]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TECDataLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataLink', 'TECDataLink') do
  with CL.AddClassN(CL.FindClass('TDataLink'),'TECDataLink') do begin
    RegisterMethod('Constructor Create');
         RegisterMethod('Procedure Free');
     RegisterMethod('Procedure CheckRefresh');
    RegisterMethod('Function CanCheckRefresh : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ECDataLink(CL: TPSPascalCompiler);
begin
  SIRegister_TECDataLink(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TECDataLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TECDataLink) do begin
    RegisterConstructor(@TECDataLink.Create, 'Create');
             RegisterMethod(@TECDataLink.Destroy, 'Free');
    RegisterMethod(@TECDataLink.CheckRefresh, 'CheckRefresh');
    RegisterMethod(@TECDataLink.CanCheckRefresh, 'CanCheckRefresh');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ECDataLink(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TECDataLink(CL);
end;

 
 
{ TPSImport_ECDataLink }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ECDataLink.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ECDataLink(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ECDataLink.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ECDataLink(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
