unit uPSI_CustApp;
{
https://github.com/Kryuski/pas2js-for-delphi

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
  TPSImport_CustApp = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCustomApplication(CL: TPSPascalCompiler);
procedure SIRegister_CustApp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCustomApplication(CL: TPSRuntimeClassImporter);
procedure RIRegister_CustApp(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Types
  //,JS
  ,CustApp
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CustApp]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomApplication(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomApplication') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomApplication') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure HandleException( Sender : TObject)');
    RegisterMethod('Procedure Initialize');
    RegisterMethod('Procedure Run');
    RegisterMethod('Procedure ShowException( E : Exception)');
    RegisterMethod('Procedure Terminate');
    RegisterMethod('Procedure Terminate1( AExitCode : Integer)');
    RegisterMethod('Function FindOptionIndex( const S : String; var Longopt : Boolean; StartAt : Integer) : Integer');
    RegisterMethod('Function GetOptionValue( const S : String) : String');
    RegisterMethod('Function GetOptionValue1( const C : Char; const S : String) : String');
    RegisterMethod('Function GetOptionValues( const C : Char; const S : String) : TStringDynArray');
    RegisterMethod('Function HasOption( const S : String) : Boolean');
    RegisterMethod('Function HasOption1( const C : Char; const S : String) : Boolean');
    RegisterMethod('Function CheckOptions( const ShortOptions : String; const Longopts : TStrings; Opts, NonOpts : TStrings; AllErrors : Boolean) : String');
    RegisterMethod('Function CheckOptions1( const ShortOptions : String; const Longopts : array of string; Opts, NonOpts : TStrings; AllErrors : Boolean) : String');
    RegisterMethod('Function CheckOptions2( const ShortOptions : String; const Longopts : TStrings; AllErrors : Boolean) : String');
    RegisterMethod('Function CheckOptions3( const ShortOptions : String; const LongOpts : array of string; AllErrors : Boolean) : String');
    RegisterMethod('Function CheckOptions4( const ShortOptions : String; const LongOpts : String; AllErrors : Boolean) : String');
    RegisterMethod('Function GetNonOptions( const ShortOptions : String; const Longopts : array of string) : TStringDynArray');
    RegisterMethod('Procedure GetNonOptions1( const ShortOptions : String; const Longopts : array of string; NonOptions : TStrings)');
    RegisterMethod('Procedure GetEnvironmentList( List : TStrings; NamesOnly : Boolean)');
    RegisterMethod('Procedure GetEnvironmentList1( List : TStrings)');
    RegisterMethod('Procedure Log( EventType : TEventType; const Msg : String)');
    RegisterMethod('Procedure Log1( EventType : TEventType; const Fmt : String; const Args : array of string)');
    RegisterProperty('ExeName', 'string', iptr);
    RegisterProperty('Terminated', 'Boolean', iptr);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('OnException', 'TExceptionEvent', iptrw);
    RegisterProperty('ConsoleApplication', 'Boolean', iptr);
    RegisterProperty('Location', 'String', iptr);
    RegisterProperty('Params', 'String integer', iptr);
    RegisterProperty('ParamCount', 'Integer', iptr);
    RegisterProperty('EnvironmentVariable', 'String String', iptr);
    RegisterProperty('OptionChar', 'Char', iptrw);
    RegisterProperty('CaseSensitiveOptions', 'Boolean', iptrw);
    RegisterProperty('StopOnException', 'Boolean', iptrw);
    RegisterProperty('ExceptionExitCode', 'Longint', iptrw);
    RegisterProperty('ExceptObject', 'Exception', iptrw);
    RegisterProperty('ExceptObjectJS', 'JSValue', iptrw);
    RegisterProperty('EventLogFilter', 'TEventLogTypes', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CustApp(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SErrInvalidOption','String').SetString( 'Invalid option at position %s: "%s"');
 CL.AddConstantN('SErrNoOptionAllowed','String').SetString( 'Option at position %s does not allow an argument: %s');
 CL.AddConstantN('SErrOptionNeeded','String').SetString( 'Option at position %s needs an argument : %s');
  CL.AddTypeS('TExceptionEvent2', 'Procedure ( Sender : TObject; E : Exception)');
  CL.AddTypeS('TEventLogTypes', 'set of TEventType');
  CL.AddTypeS('JSValue', 'variant');
  SIRegister_TCustomApplication(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomApplicationEventLogFilter_W(Self: TCustomApplication; const T: TEventLogTypes);
begin Self.EventLogFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationEventLogFilter_R(Self: TCustomApplication; var T: TEventLogTypes);
begin T := Self.EventLogFilter; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationExceptObjectJS_W(Self: TCustomApplication; const T: JSValue);
begin Self.ExceptObjectJS := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationExceptObjectJS_R(Self: TCustomApplication; var T: JSValue);
begin T := Self.ExceptObjectJS; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationExceptObject_W(Self: TCustomApplication; const T: Exception);
begin Self.ExceptObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationExceptObject_R(Self: TCustomApplication; var T: Exception);
begin T := Self.ExceptObject; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationExceptionExitCode_W(Self: TCustomApplication; const T: Longint);
begin Self.ExceptionExitCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationExceptionExitCode_R(Self: TCustomApplication; var T: Longint);
begin T := Self.ExceptionExitCode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationStopOnException_W(Self: TCustomApplication; const T: Boolean);
begin Self.StopOnException := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationStopOnException_R(Self: TCustomApplication; var T: Boolean);
begin T := Self.StopOnException; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationCaseSensitiveOptions_W(Self: TCustomApplication; const T: Boolean);
begin Self.CaseSensitiveOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationCaseSensitiveOptions_R(Self: TCustomApplication; var T: Boolean);
begin T := Self.CaseSensitiveOptions; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationOptionChar_W(Self: TCustomApplication; const T: Char);
begin Self.OptionChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationOptionChar_R(Self: TCustomApplication; var T: Char);
begin T := Self.OptionChar; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationEnvironmentVariable_R(Self: TCustomApplication; var T: String; const t1: String);
begin T := Self.EnvironmentVariable[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationParamCount_R(Self: TCustomApplication; var T: Integer);
begin T := Self.ParamCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationParams_R(Self: TCustomApplication; var T: String; const t1: integer);
begin T := Self.Params[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationLocation_R(Self: TCustomApplication; var T: String);
begin T := Self.Location; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationConsoleApplication_R(Self: TCustomApplication; var T: Boolean);
begin T := Self.ConsoleApplication; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationOnException_W(Self: TCustomApplication; const T: TExceptionEvent);
begin Self.OnException := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationOnException_R(Self: TCustomApplication; var T: TExceptionEvent);
begin T := Self.OnException; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationTitle_W(Self: TCustomApplication; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationTitle_R(Self: TCustomApplication; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationTerminated_R(Self: TCustomApplication; var T: Boolean);
begin T := Self.Terminated; end;

(*----------------------------------------------------------------------------*)
procedure TCustomApplicationExeName_R(Self: TCustomApplication; var T: string);
begin T := Self.ExeName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomApplication(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomApplication) do
  begin
    RegisterConstructor(@TCustomApplication.Create, 'Create');
    RegisterVirtualMethod(@TCustomApplication.HandleException, 'HandleException');
    RegisterVirtualMethod(@TCustomApplication.Initialize, 'Initialize');
    RegisterMethod(@TCustomApplication.Run, 'Run');
    //RegisterVirtualAbstractMethod(@TCustomApplication, @!.ShowException, 'ShowException');
    RegisterVirtualMethod(@TCustomApplication.Terminate, 'Terminate');
    RegisterVirtualMethod(@TCustomApplication.Terminate1, 'Terminate1');
    RegisterMethod(@TCustomApplication.FindOptionIndex, 'FindOptionIndex');
    RegisterMethod(@TCustomApplication.GetOptionValue, 'GetOptionValue');
    RegisterMethod(@TCustomApplication.GetOptionValue1, 'GetOptionValue1');
    RegisterMethod(@TCustomApplication.GetOptionValues, 'GetOptionValues');
    RegisterMethod(@TCustomApplication.HasOption, 'HasOption');
    RegisterMethod(@TCustomApplication.HasOption1, 'HasOption1');
    RegisterMethod(@TCustomApplication.CheckOptions, 'CheckOptions');
    RegisterMethod(@TCustomApplication.CheckOptions1, 'CheckOptions1');
    RegisterMethod(@TCustomApplication.CheckOptions2, 'CheckOptions2');
    RegisterMethod(@TCustomApplication.CheckOptions3, 'CheckOptions3');
    RegisterMethod(@TCustomApplication.CheckOptions4, 'CheckOptions4');
    RegisterMethod(@TCustomApplication.GetNonOptions, 'GetNonOptions');
    RegisterMethod(@TCustomApplication.GetNonOptions1, 'GetNonOptions1');
    //RegisterVirtualAbstractMethod(@TCustomApplication, @!.GetEnvironmentList, 'GetEnvironmentList');
    RegisterVirtualMethod(@TCustomApplication.GetEnvironmentList, 'GetEnvironmentList');
    RegisterMethod(@TCustomApplication.Log, 'Log');
    RegisterMethod(@TCustomApplication.Log1, 'Log1');
    RegisterPropertyHelper(@TCustomApplicationExeName_R,nil,'ExeName');
    RegisterPropertyHelper(@TCustomApplicationTerminated_R,nil,'Terminated');
    RegisterPropertyHelper(@TCustomApplicationTitle_R,@TCustomApplicationTitle_W,'Title');
    RegisterPropertyHelper(@TCustomApplicationOnException_R,@TCustomApplicationOnException_W,'OnException');
    RegisterPropertyHelper(@TCustomApplicationConsoleApplication_R,nil,'ConsoleApplication');
    RegisterPropertyHelper(@TCustomApplicationLocation_R,nil,'Location');
    RegisterPropertyHelper(@TCustomApplicationParams_R,nil,'Params');
    RegisterPropertyHelper(@TCustomApplicationParamCount_R,nil,'ParamCount');
    RegisterPropertyHelper(@TCustomApplicationEnvironmentVariable_R,nil,'EnvironmentVariable');
    RegisterPropertyHelper(@TCustomApplicationOptionChar_R,@TCustomApplicationOptionChar_W,'OptionChar');
    RegisterPropertyHelper(@TCustomApplicationCaseSensitiveOptions_R,@TCustomApplicationCaseSensitiveOptions_W,'CaseSensitiveOptions');
    RegisterPropertyHelper(@TCustomApplicationStopOnException_R,@TCustomApplicationStopOnException_W,'StopOnException');
    RegisterPropertyHelper(@TCustomApplicationExceptionExitCode_R,@TCustomApplicationExceptionExitCode_W,'ExceptionExitCode');
    RegisterPropertyHelper(@TCustomApplicationExceptObject_R,@TCustomApplicationExceptObject_W,'ExceptObject');
    RegisterPropertyHelper(@TCustomApplicationExceptObjectJS_R,@TCustomApplicationExceptObjectJS_W,'ExceptObjectJS');
    RegisterPropertyHelper(@TCustomApplicationEventLogFilter_R,@TCustomApplicationEventLogFilter_W,'EventLogFilter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CustApp(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomApplication(CL);
end;

 
 
{ TPSImport_CustApp }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CustApp.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CustApp(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CustApp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CustApp(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
