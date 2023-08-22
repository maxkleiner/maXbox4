unit uPSI_StWmDCpy;
{
  win api copy   add free
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
  TPSImport_StWmDCpy = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStWMDataCopy(CL: TPSPascalCompiler);
procedure SIRegister_StWmDCpy(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStWMDataCopy(CL: TPSRuntimeClassImporter);
procedure RIRegister_StWmDCpy(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Forms
  ,Controls
  ,Dialogs
  ,StBase
  ,StWmDCpy
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StWmDCpy]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStWMDataCopy(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStWMDataCopy') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStWMDataCopy') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
    RegisterProperty('OnDataReceived', 'TStOnDataReceivedEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StWmDCpy(CL: TPSPascalCompiler);
begin

  CL.AddTypeS('tagCOPYDATASTRUCT','record dwData: DWORD; cbData: DWORD; lpData: integer; end; ');
  //((TCopyDataStruct = tagCOPYDATASTRUCT;

  CL.AddTypeS('TStOnDataReceivedEvent', 'Procedure (Sender : TObject; CopyData'
   +' : tagCOPYDATASTRUCT)');
  SIRegister_TStWMDataCopy(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStWMDataCopyOnDataReceived_W(Self: TStWMDataCopy; const T: TStOnDataReceivedEvent);
begin Self.OnDataReceived := T; end;

(*----------------------------------------------------------------------------*)
procedure TStWMDataCopyOnDataReceived_R(Self: TStWMDataCopy; var T: TStOnDataReceivedEvent);
begin T := Self.OnDataReceived; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStWMDataCopy(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStWMDataCopy) do begin
    RegisterConstructor(@TStWMDataCopy.Create, 'Create');
     RegisterMethod(@TStWMDataCopy.Destroy, 'Free');
       RegisterPropertyHelper(@TStWMDataCopyOnDataReceived_R,@TStWMDataCopyOnDataReceived_W,'OnDataReceived');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StWmDCpy(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStWMDataCopy(CL);
end;

 
 
{ TPSImport_StWmDCpy }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StWmDCpy.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StWmDCpy(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StWmDCpy.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StWmDCpy(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
