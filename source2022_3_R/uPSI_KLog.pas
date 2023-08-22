unit uPSI_KLog;
{
@author(Tomas Krysl (tk@@tkweb.eu))
  @created(20 Oct 2001)
  @lastmod(6 Jul 2014)
  apt to maXbox
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
  TPSImport_KLog = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TKLog(CL: TPSPascalCompiler);
procedure SIRegister_KLog(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TKLog(CL: TPSRuntimeClassImporter);
procedure RIRegister_KLog(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   StdCtrls
  ,ComCtrls
  ,ExtCtrls
  ,KFunctions
  ,KLog
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_KLog]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TKLog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TKLog') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TKLog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
        RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Log( Code : TKLogType; const Text : string)');
    RegisterMethod('Procedure LogStr( const BracketText, Text : string; Code : TKLogType)');
    RegisterMethod('Procedure StatusLog( Code : TKLogType; const Text : string)');
    RegisterMethod('Procedure StatusLogStr( const BracketText, Text : string)');
    RegisterProperty('ListBox', 'TListBox', iptrw);
    RegisterProperty('LogDirection', 'TKLogDirection', iptrw);
    RegisterProperty('LogMask', 'TKLogMask', iptrw);
    RegisterProperty('LogText', 'string', iptr);
    RegisterProperty('StatusBar', 'TStatusBar', iptrw);
    RegisterProperty('StatusCode', 'TKLogType', iptr);
    RegisterProperty('StatusPanel', 'Integer', iptrw);
    RegisterProperty('StatusText', 'string', iptrw);
    RegisterProperty('HoverTime', 'Cardinal', iptrw);
    RegisterProperty('OnLog', 'TKLogEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_KLog(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TKLogDirection', '( ldAddTop, ldAddBottom )');
  CL.AddTypeS('TKLogType', '( lgNone, lgError, lgWarning, lgNote, lgHint, lgInf'
   +'o, lgInputError, lgIOError, lgAll )');
 CL.AddConstantN('cHoverTimeDef','LongInt').SetInt( 1000);
 CL.AddConstantN('cLogDirectionDef','longint').Setint(0);
 CL.AddConstantN('cLogMaskDef','LongInt').Value.ts32 := ord(lgAll);
 CL.AddConstantN('cStatusPanelDef','LongInt').SetInt( - 1);
  CL.AddTypeS('TKLogMask', 'set of TKLogType');
  CL.AddTypeS('TKLogEvent', 'Procedure ( Sender : TObject; Code : TKLogType; const Text : string)');
  SIRegister_TKLog(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TKLogOnLog_W(Self: TKLog; const T: TKLogEvent);
begin Self.OnLog := T; end;

(*----------------------------------------------------------------------------*)
procedure TKLogOnLog_R(Self: TKLog; var T: TKLogEvent);
begin T := Self.OnLog; end;

(*----------------------------------------------------------------------------*)
procedure TKLogHoverTime_W(Self: TKLog; const T: Cardinal);
begin Self.HoverTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TKLogHoverTime_R(Self: TKLog; var T: Cardinal);
begin T := Self.HoverTime; end;

(*----------------------------------------------------------------------------*)
procedure TKLogStatusText_W(Self: TKLog; const T: string);
begin Self.StatusText := T; end;

(*----------------------------------------------------------------------------*)
procedure TKLogStatusText_R(Self: TKLog; var T: string);
begin T := Self.StatusText; end;

(*----------------------------------------------------------------------------*)
procedure TKLogStatusPanel_W(Self: TKLog; const T: Integer);
begin Self.StatusPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TKLogStatusPanel_R(Self: TKLog; var T: Integer);
begin T := Self.StatusPanel; end;

(*----------------------------------------------------------------------------*)
procedure TKLogStatusCode_R(Self: TKLog; var T: TKLogType);
begin T := Self.StatusCode; end;

(*----------------------------------------------------------------------------*)
procedure TKLogStatusBar_W(Self: TKLog; const T: TStatusBar);
begin Self.StatusBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TKLogStatusBar_R(Self: TKLog; var T: TStatusBar);
begin T := Self.StatusBar; end;

(*----------------------------------------------------------------------------*)
procedure TKLogLogText_R(Self: TKLog; var T: string);
begin T := Self.LogText; end;

(*----------------------------------------------------------------------------*)
procedure TKLogLogMask_W(Self: TKLog; const T: TKLogMask);
begin Self.LogMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TKLogLogMask_R(Self: TKLog; var T: TKLogMask);
begin T := Self.LogMask; end;

(*----------------------------------------------------------------------------*)
procedure TKLogLogDirection_W(Self: TKLog; const T: TKLogDirection);
begin Self.LogDirection := T; end;

(*----------------------------------------------------------------------------*)
procedure TKLogLogDirection_R(Self: TKLog; var T: TKLogDirection);
begin T := Self.LogDirection; end;

(*----------------------------------------------------------------------------*)
procedure TKLogListBox_W(Self: TKLog; const T: TListBox);
begin Self.ListBox := T; end;

(*----------------------------------------------------------------------------*)
procedure TKLogListBox_R(Self: TKLog; var T: TListBox);
begin T := Self.ListBox; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKLog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKLog) do begin
    RegisterConstructor(@TKLog.Create, 'Create');
     RegisterMethod(@TKLog.Destroy, 'Free');
    RegisterMethod(@TKLog.Clear, 'Clear');
    RegisterMethod(@TKLog.Log, 'Log');
    RegisterMethod(@TKLog.LogStr, 'LogStr');
    RegisterMethod(@TKLog.StatusLog, 'StatusLog');
    RegisterMethod(@TKLog.StatusLogStr, 'StatusLogStr');
    RegisterPropertyHelper(@TKLogListBox_R,@TKLogListBox_W,'ListBox');
    RegisterPropertyHelper(@TKLogLogDirection_R,@TKLogLogDirection_W,'LogDirection');
    RegisterPropertyHelper(@TKLogLogMask_R,@TKLogLogMask_W,'LogMask');
    RegisterPropertyHelper(@TKLogLogText_R,nil,'LogText');
    RegisterPropertyHelper(@TKLogStatusBar_R,@TKLogStatusBar_W,'StatusBar');
    RegisterPropertyHelper(@TKLogStatusCode_R,nil,'StatusCode');
    RegisterPropertyHelper(@TKLogStatusPanel_R,@TKLogStatusPanel_W,'StatusPanel');
    RegisterPropertyHelper(@TKLogStatusText_R,@TKLogStatusText_W,'StatusText');
    RegisterPropertyHelper(@TKLogHoverTime_R,@TKLogHoverTime_W,'HoverTime');
    RegisterPropertyHelper(@TKLogOnLog_R,@TKLogOnLog_W,'OnLog');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KLog(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TKLog(CL);
end;

 
 
{ TPSImport_KLog }
(*----------------------------------------------------------------------------*)
procedure TPSImport_KLog.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_KLog(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_KLog.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_KLog(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
