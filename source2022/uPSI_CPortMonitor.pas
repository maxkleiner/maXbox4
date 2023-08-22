unit uPSI_CPortMonitor;
{
  after free detect
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
  TPSImport_CPortMonitor = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCPortMonitor(CL: TPSPascalCompiler);
procedure SIRegister_CPortMonitor(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CPortMonitor_Routines(S: TPSExec);
procedure RIRegister_TCPortMonitor(CL: TPSRuntimeClassImporter);
procedure RIRegister_CPortMonitor(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,Math
  ,CPortCtl
  ,CPort
  ,CPortMonitor
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CPortMonitor]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCPortMonitor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMemo', 'TCPortMonitor') do
  with CL.AddClassN(CL.FindClass('TCustomMemo'),'TCPortMonitor') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure CreateWnd');
    RegisterMethod('Procedure Loaded');
    RegisterProperty('BackColorOutput', 'TColor', iptrw);
    RegisterProperty('BackColorInput', 'TColor', iptrw);
    RegisterProperty('ForeColorOutput', 'TColor', iptrw);
    RegisterProperty('ForeColorInput', 'TColor', iptrw);
    RegisterProperty('MonitorStyle', 'TMonitorStyle', iptrw);
    RegisterProperty('Spacing', 'integer', iptrw);
    RegisterProperty('Enclosed', 'boolean', iptrw);
    RegisterProperty('MaxLines', 'integer', iptrw);
    RegisterProperty('Reverse', 'boolean', iptrw);
    RegisterProperty('OnInput', 'TMonitorEvent', iptrw);
    RegisterProperty('OnOutput', 'TMonitorEvent', iptrw);
    RegisterProperty('ComPort', 'TComPort', iptrw);
    RegisterProperty('MonitorShow', 'TMonitorInfoSet', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CPortMonitor(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMonitorStyle', '( msAscii, msHex, msHexC, msHexVB, msHexPascal,'
   +' msDecimal, msBinary )');
  CL.AddTypeS('TMonitorEvent', 'Procedure ( var DisplayValue : string; const Da'
   +'ta : string; ComPort : TComPort)');
  CL.AddTypeS('TMonitorInfo', '( miCommPort, miDate, miTime, miDirection )');
  CL.AddTypeS('TMonitorInfoSet', 'set of TMonitorInfo');
  SIRegister_TCPortMonitor(CL);
 CL.AddDelphiFunction('Procedure CPortLibRegister');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCPortMonitorMonitorShow_W(Self: TCPortMonitor; const T: TMonitorInfoSet);
begin Self.MonitorShow := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorMonitorShow_R(Self: TCPortMonitor; var T: TMonitorInfoSet);
begin T := Self.MonitorShow; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorComPort_W(Self: TCPortMonitor; const T: TComPort);
begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorComPort_R(Self: TCPortMonitor; var T: TComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorOnOutput_W(Self: TCPortMonitor; const T: TMonitorEvent);
begin Self.OnOutput := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorOnOutput_R(Self: TCPortMonitor; var T: TMonitorEvent);
begin T := Self.OnOutput; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorOnInput_W(Self: TCPortMonitor; const T: TMonitorEvent);
begin Self.OnInput := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorOnInput_R(Self: TCPortMonitor; var T: TMonitorEvent);
begin T := Self.OnInput; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorReverse_W(Self: TCPortMonitor; const T: boolean);
begin Self.Reverse := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorReverse_R(Self: TCPortMonitor; var T: boolean);
begin T := Self.Reverse; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorMaxLines_W(Self: TCPortMonitor; const T: integer);
begin Self.MaxLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorMaxLines_R(Self: TCPortMonitor; var T: integer);
begin T := Self.MaxLines; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorEnclosed_W(Self: TCPortMonitor; const T: boolean);
begin Self.Enclosed := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorEnclosed_R(Self: TCPortMonitor; var T: boolean);
begin T := Self.Enclosed; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorSpacing_W(Self: TCPortMonitor; const T: integer);
begin Self.Spacing := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorSpacing_R(Self: TCPortMonitor; var T: integer);
begin T := Self.Spacing; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorMonitorStyle_W(Self: TCPortMonitor; const T: TMonitorStyle);
begin Self.MonitorStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorMonitorStyle_R(Self: TCPortMonitor; var T: TMonitorStyle);
begin T := Self.MonitorStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorForeColorInput_W(Self: TCPortMonitor; const T: TColor);
begin Self.ForeColorInput := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorForeColorInput_R(Self: TCPortMonitor; var T: TColor);
begin T := Self.ForeColorInput; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorForeColorOutput_W(Self: TCPortMonitor; const T: TColor);
begin Self.ForeColorOutput := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorForeColorOutput_R(Self: TCPortMonitor; var T: TColor);
begin T := Self.ForeColorOutput; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorBackColorInput_W(Self: TCPortMonitor; const T: TColor);
begin Self.BackColorInput := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorBackColorInput_R(Self: TCPortMonitor; var T: TColor);
begin T := Self.BackColorInput; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorBackColorOutput_W(Self: TCPortMonitor; const T: TColor);
begin Self.BackColorOutput := T; end;

(*----------------------------------------------------------------------------*)
procedure TCPortMonitorBackColorOutput_R(Self: TCPortMonitor; var T: TColor);
begin T := Self.BackColorOutput; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CPortMonitor_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'CPortLibRegister', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCPortMonitor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCPortMonitor) do begin
    RegisterConstructor(@TCPortMonitor.Create, 'Create');
    RegisterMethod(@TCPortMonitor.CreateWnd, 'CreateWnd');
    RegisterMethod(@TCPortMonitor.Loaded, 'Loaded');
    RegisterMethod(@TCPortMonitor.Destroy, 'Free');
    RegisterPropertyHelper(@TCPortMonitorBackColorOutput_R,@TCPortMonitorBackColorOutput_W,'BackColorOutput');
    RegisterPropertyHelper(@TCPortMonitorBackColorInput_R,@TCPortMonitorBackColorInput_W,'BackColorInput');
    RegisterPropertyHelper(@TCPortMonitorForeColorOutput_R,@TCPortMonitorForeColorOutput_W,'ForeColorOutput');
    RegisterPropertyHelper(@TCPortMonitorForeColorInput_R,@TCPortMonitorForeColorInput_W,'ForeColorInput');
    RegisterPropertyHelper(@TCPortMonitorMonitorStyle_R,@TCPortMonitorMonitorStyle_W,'MonitorStyle');
    RegisterPropertyHelper(@TCPortMonitorSpacing_R,@TCPortMonitorSpacing_W,'Spacing');
    RegisterPropertyHelper(@TCPortMonitorEnclosed_R,@TCPortMonitorEnclosed_W,'Enclosed');
    RegisterPropertyHelper(@TCPortMonitorMaxLines_R,@TCPortMonitorMaxLines_W,'MaxLines');
    RegisterPropertyHelper(@TCPortMonitorReverse_R,@TCPortMonitorReverse_W,'Reverse');
    RegisterPropertyHelper(@TCPortMonitorOnInput_R,@TCPortMonitorOnInput_W,'OnInput');
    RegisterPropertyHelper(@TCPortMonitorOnOutput_R,@TCPortMonitorOnOutput_W,'OnOutput');
    RegisterPropertyHelper(@TCPortMonitorComPort_R,@TCPortMonitorComPort_W,'ComPort');
    RegisterPropertyHelper(@TCPortMonitorMonitorShow_R,@TCPortMonitorMonitorShow_W,'MonitorShow');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CPortMonitor(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCPortMonitor(CL);
end;

 
 
{ TPSImport_CPortMonitor }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CPortMonitor.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CPortMonitor(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CPortMonitor.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CPortMonitor(ri);
  RIRegister_CPortMonitor_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
