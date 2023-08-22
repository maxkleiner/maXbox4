unit uPSI_OverbyteIcsLogger;
{
log for microcode      with a log event

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
  TPSImport_OverbyteIcsLogger = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIcsLogger(CL: TPSPascalCompiler);
procedure SIRegister_OverbyteIcsLogger(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIcsLogger(CL: TPSRuntimeClassImporter);
procedure RIRegister_OverbyteIcsLogger(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   OverbyteIcsUtils
  ,OverbyteIcsLogger
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OverbyteIcsLogger]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIcsLogger(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TIcsLogger') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TIcsLogger') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure OpenLogFile');
    RegisterMethod('Procedure CloseLogFile');
    RegisterMethod('Procedure DoDebugLog( Sender : TObject; LogOption : TLogOption; const Msg : String)');
    RegisterMethod('Procedure FreeNotification( AComponent : TComponent)');
    RegisterMethod('Procedure RemoveFreeNotification( AComponent : TComponent)');
    RegisterProperty('TimeStampFormatString', 'String', iptrw);
    RegisterProperty('TimeStampSeparator', 'String', iptrw);
    RegisterProperty('LogFileOption', 'TLogFileOption', iptrw);
    RegisterProperty('LogFileEncoding', 'TLogFileEncoding', iptrw);
    RegisterProperty('LogFileName', 'String', iptrw);
    RegisterProperty('LogOptions', 'TLogOptions', iptrw);
    RegisterProperty('OnIcsLogEvent', 'TIcsLogEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_OverbyteIcsLogger(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('TIcsLoggerVersion','LongInt').SetInt( 800);
 CL.AddConstantN('IcsCopyRight','String').SetString( ' IcsLogger (c) 2005-2012 by François PIETTE V8.00 ');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ELoggerException');
  CL.AddTypeS('TLogOption', '( loDestEvent, loDestFile, loDestOutDebug, loAddSt'
   +'amp, loWsockErr, loWsockInfo, loWsockDump, loSslErr, loSslInfo, loSslDump,'
   +' loProtSpecErr, loProtSpecInfo, loProtSpecDump )');
  CL.AddTypeS('TLogOptions', 'set of TLogOption');
  CL.AddTypeS('TLogFileOption', '( lfoAppend, lfoOverwrite )');
  CL.AddTypeS('TLogFileEncoding', '( lfeUtf8, lfeUtf16 )');
  CL.AddConstantN('LogAllOptErr','LongInt').Value.ts32 := ord(loWsockErr) or ord(loSslErr) or ord(loProtSpecErr);
  CL.AddTypeS('TNTEventType', '( etError, etWarning, etInformation, etAuditSuccess, etAuditFailure )');
  CL.AddTypeS('TIcsLogEvent', 'Procedure ( Sender : TObject; LogOption : TLogOption; const Msg : String)');
  SIRegister_TIcsLogger(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIcsLoggerOnIcsLogEvent_W(Self: TIcsLogger; const T: TIcsLogEvent);
begin Self.OnIcsLogEvent := T; end;

(*----------------------------------------------------------------------------*)
procedure TIcsLoggerOnIcsLogEvent_R(Self: TIcsLogger; var T: TIcsLogEvent);
begin T := Self.OnIcsLogEvent; end;

(*----------------------------------------------------------------------------*)
procedure TIcsLoggerLogOptions_W(Self: TIcsLogger; const T: TLogOptions);
begin Self.LogOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TIcsLoggerLogOptions_R(Self: TIcsLogger; var T: TLogOptions);
begin T := Self.LogOptions; end;

(*----------------------------------------------------------------------------*)
procedure TIcsLoggerLogFileName_W(Self: TIcsLogger; const T: String);
begin Self.LogFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIcsLoggerLogFileName_R(Self: TIcsLogger; var T: String);
begin T := Self.LogFileName; end;

(*----------------------------------------------------------------------------*)
//procedure TIcsLoggerLogFileEncoding_W(Self: TIcsLogger; const T: TLogFileEncoding);
//begin Self.LogFileEncoding := T; end;

(*----------------------------------------------------------------------------*)
//procedure TIcsLoggerLogFileEncoding_R(Self: TIcsLogger; var T: TLogFileEncoding);
//begin T := Self.LogFileEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TIcsLoggerLogFileOption_W(Self: TIcsLogger; const T: TLogFileOption);
begin Self.LogFileOption := T; end;

(*----------------------------------------------------------------------------*)
procedure TIcsLoggerLogFileOption_R(Self: TIcsLogger; var T: TLogFileOption);
begin T := Self.LogFileOption; end;

(*----------------------------------------------------------------------------*)
procedure TIcsLoggerTimeStampSeparator_W(Self: TIcsLogger; const T: String);
begin Self.TimeStampSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TIcsLoggerTimeStampSeparator_R(Self: TIcsLogger; var T: String);
begin T := Self.TimeStampSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TIcsLoggerTimeStampFormatString_W(Self: TIcsLogger; const T: String);
begin Self.TimeStampFormatString := T; end;

(*----------------------------------------------------------------------------*)
procedure TIcsLoggerTimeStampFormatString_R(Self: TIcsLogger; var T: String);
begin T := Self.TimeStampFormatString; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIcsLogger(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIcsLogger) do begin
    RegisterConstructor(@TIcsLogger.Create, 'Create');
    RegisterMethod(@TIcsLogger.Destroy, 'Free');
    RegisterMethod(@TIcsLogger.OpenLogFile, 'OpenLogFile');
    RegisterMethod(@TIcsLogger.CloseLogFile, 'CloseLogFile');
    RegisterMethod(@TIcsLogger.DoDebugLog, 'DoDebugLog');
    RegisterMethod(@TIcsLogger.FreeNotification, 'FreeNotification');
    RegisterMethod(@TIcsLogger.RemoveFreeNotification, 'RemoveFreeNotification');
    RegisterPropertyHelper(@TIcsLoggerTimeStampFormatString_R,@TIcsLoggerTimeStampFormatString_W,'TimeStampFormatString');
    RegisterPropertyHelper(@TIcsLoggerTimeStampSeparator_R,@TIcsLoggerTimeStampSeparator_W,'TimeStampSeparator');
    RegisterPropertyHelper(@TIcsLoggerLogFileOption_R,@TIcsLoggerLogFileOption_W,'LogFileOption');
    //RegisterPropertyHelper(@TIcsLoggerLogFileEncoding_R,@TIcsLoggerLogFileEncoding_W,'LogFileEncoding');
    RegisterPropertyHelper(@TIcsLoggerLogFileName_R,@TIcsLoggerLogFileName_W,'LogFileName');
    RegisterPropertyHelper(@TIcsLoggerLogOptions_R,@TIcsLoggerLogOptions_W,'LogOptions');
    RegisterPropertyHelper(@TIcsLoggerOnIcsLogEvent_R,@TIcsLoggerOnIcsLogEvent_W,'OnIcsLogEvent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_OverbyteIcsLogger(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ELoggerException) do
  RIRegister_TIcsLogger(CL);
end;

 
{ TPSImport_OverbyteIcsLogger }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsLogger.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OverbyteIcsLogger(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsLogger.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OverbyteIcsLogger(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
