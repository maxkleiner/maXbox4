unit uPSI_AfDataTerminal;
{
   terminal final
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
  TPSImport_AfDataTerminal = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAfDataTerminal(CL: TPSPascalCompiler);
procedure SIRegister_AfDataTerminal(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAfDataTerminal(CL: TPSRuntimeClassImporter);
procedure RIRegister_AfDataTerminal(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,AfViewers
  ,AfDataDispatcher
  ,AfDataTerminal
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AfDataTerminal]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfDataTerminal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomTerminal', 'TAfDataTerminal') do
  with CL.AddClassN(CL.FindClass('TAfCustomTerminal'),'TAfDataTerminal') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
        RegisterMethod('Procedure Free');
    RegisterPublishedProperties;
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Dispatcher', 'TAfCustomDataDispatcher', iptrw);

   { FAutoScrollBack: Boolean;
    FBkSpcMode: TAfTRMBkSpcMode;
    FCanScrollX: Boolean;
    FDisplayCols: Byte;
    FLogging: TAfTRMLogging;
    FLogFlushTime: TAfTRMLogFlushTime;
    FLogName: String;
    FLogSize: TAfTRMLogSize;
    FScrollBackCaret, FTerminalCaret: TAfCLVCaretType;
    FScrollBackKey: TShortCut;
    FScrollBackRows: Integer;
    FScrollBackMode: Boolean;
    FTermBuffer: TAfTerminalBuffer;
    FTermColorMode: TAfTRMColorMode;
    FUserDataSize: Integer;
    FOnBeepChar: TNotifyEvent;
    FOnDrawBuffer: TNotifyEvent;
    FOnFlushLog: TNotifyEvent;
    FOnGetColors: TAfTRMGetColorsEvent;
    FOnLoggingChange: TNotifyEvent;
    FOptions: TAfCLVOptions;
    FOnNewLine: TAfTRMLineEvent;
    FOnProcessChar: TAfTRMProcessCharEvent;
    FOnScrBckBufChange: TAfTRMScrBckBufChange;
    FOnScrBckModeChange: TNotifyEvent;
    FOnSendChar: TKeyPressEvent;
    FOnUserDataChange: TAfTRMLineEvent;
    LogFileStream: TAfFileStream;
    LogMemStream: TMemoryStream; }
  RegisterProperty('caption', 'string', iptrW);
  RegisterProperty('LogName', 'string', iptrw);
  RegisterProperty('OnSendChar', 'TKeyPressEvent', iptrw);
  RegisterProperty('CaretBlinkTime', 'TAfCLVCaretBlinkTime', iptrw);
  RegisterProperty('LogFileStream', 'TAfFileStream', iptrw);
  RegisterProperty('LogMemStream', 'TMemoryStream', iptrw);
  RegisterProperty('OnBeepChar', 'TNotifyEvent', iptrw);
  RegisterProperty('OnDrawBuffer', 'TNotifyEvent', iptrw);
  RegisterProperty('OnFlushLog', 'TNotifyEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AfDataTerminal(CL: TPSPascalCompiler);
begin
  SIRegister_TAfDataTerminal(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAfDataTerminalDispatcher_W(Self: TAfDataTerminal; const T: TAfCustomDataDispatcher);
begin Self.Dispatcher := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfDataTerminalDispatcher_R(Self: TAfDataTerminal; var T: TAfCustomDataDispatcher);
begin T := Self.Dispatcher; end;

(*----------------------------------------------------------------------------*)
procedure TAfDataTerminalActive_W(Self: TAfDataTerminal; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfDataTerminalActive_R(Self: TAfDataTerminal; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfDataTerminal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfDataTerminal) do begin
    RegisterConstructor(@TAfDataTerminal.Create, 'Create');
    RegisterMethod(@TAfDataTerminal.Destroy, 'Free');
   RegisterPropertyHelper(@TAfDataTerminalActive_R,@TAfDataTerminalActive_W,'Active');
    RegisterPropertyHelper(@TAfDataTerminalDispatcher_R,@TAfDataTerminalDispatcher_W,'Dispatcher');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfDataTerminal(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAfDataTerminal(CL);
end;

 
 
{ TPSImport_AfDataTerminal }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfDataTerminal.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AfDataTerminal(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfDataTerminal.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AfDataTerminal(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
