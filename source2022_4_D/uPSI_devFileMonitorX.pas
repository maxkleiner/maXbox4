unit uPSI_devFileMonitorX;
{
   to check change in file
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
  TPSImport_devFileMonitorX = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TdevFileMonitor(CL: TPSPascalCompiler);
procedure SIRegister_devFileMonitorX(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TdevFileMonitor(CL: TPSRuntimeClassImporter);
procedure RIRegister_devFileMonitorX(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Forms
  ,Controls
  ,devMonitorThread
  //,devMonitorTypes
  ,devFileMonitorX
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_devFileMonitorX]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TdevFileMonitor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TdevFileMonitor') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TdevFileMonitor') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Activate');
    RegisterMethod('Procedure Deactivate');
    RegisterMethod('Procedure Refresh( ActivateIfNot : boolean)');
    RegisterMethod('Procedure SubClassWndProc( var Message : TMessage)');
    RegisterProperty('Active', 'boolean', iptrw);
    RegisterProperty('Files', 'TStrings', iptrw);
    RegisterProperty('OnNotifyChange', 'TdevMonitorChange', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_devFileMonitorX(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TdevMonitorChangeType', '( mctChanged, mctDeleted )');
  CL.AddTypeS('TdevMonitorChange', 'Procedure ( Sender : TObject; ChangeType : '
   +'TdevMonitorChangeType; Filename : string)');
  SIRegister_TdevFileMonitor(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TdevFileMonitorOnNotifyChange_W(Self: TdevFileMonitor; const T: TdevMonitorChange);
begin Self.OnNotifyChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TdevFileMonitorOnNotifyChange_R(Self: TdevFileMonitor; var T: TdevMonitorChange);
begin T := Self.OnNotifyChange; end;

(*----------------------------------------------------------------------------*)
procedure TdevFileMonitorFiles_W(Self: TdevFileMonitor; const T: TStrings);
begin Self.Files := T; end;

(*----------------------------------------------------------------------------*)
procedure TdevFileMonitorFiles_R(Self: TdevFileMonitor; var T: TStrings);
begin T := Self.Files; end;

(*----------------------------------------------------------------------------*)
procedure TdevFileMonitorActive_W(Self: TdevFileMonitor; const T: boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TdevFileMonitorActive_R(Self: TdevFileMonitor; var T: boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TdevFileMonitor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TdevFileMonitor) do begin
    RegisterConstructor(@TdevFileMonitor.Create, 'Create');
    RegisterMethod(@TdevFileMonitor.Destroy, 'Free');
    RegisterMethod(@TdevFileMonitor.Activate, 'Activate');
    RegisterMethod(@TdevFileMonitor.Deactivate, 'Deactivate');
    RegisterMethod(@TdevFileMonitor.Refresh, 'Refresh');
    RegisterMethod(@TdevFileMonitor.SubClassWndProc, 'SubClassWndProc');
    RegisterPropertyHelper(@TdevFileMonitorActive_R,@TdevFileMonitorActive_W,'Active');
    RegisterPropertyHelper(@TdevFileMonitorFiles_R,@TdevFileMonitorFiles_W,'Files');
    RegisterPropertyHelper(@TdevFileMonitorOnNotifyChange_R,@TdevFileMonitorOnNotifyChange_W,'OnNotifyChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_devFileMonitorX(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TdevFileMonitor(CL);
end;

 
 
{ TPSImport_devFileMonitorX }
(*----------------------------------------------------------------------------*)
procedure TPSImport_devFileMonitorX.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_devFileMonitorX(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_devFileMonitorX.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_devFileMonitorX(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
