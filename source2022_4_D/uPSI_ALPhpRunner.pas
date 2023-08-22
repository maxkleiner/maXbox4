unit uPSI_ALPhpRunner;
{
   PHP PEP     plus executes!   check virtual constructor
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
  TPSImport_ALPhpRunner = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALPhpCgiRunnerEngine(CL: TPSPascalCompiler);
procedure SIRegister_TALPhpNamedPipeFastCgiManager(CL: TPSPascalCompiler);
procedure SIRegister_TALPhpNamedPipeFastCgiRunnerEngine(CL: TPSPascalCompiler);
procedure SIRegister_TALPhpSocketFastCgiRunnerEngine(CL: TPSPascalCompiler);
procedure SIRegister_TALPhpFastCgiRunnerEngine(CL: TPSPascalCompiler);
procedure SIRegister_TALPhpRunnerEngine(CL: TPSPascalCompiler);
procedure SIRegister_ALPhpRunner(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALPhpCgiRunnerEngine(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALPhpNamedPipeFastCgiManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALPhpNamedPipeFastCgiRunnerEngine(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALPhpSocketFastCgiRunnerEngine(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALPhpFastCgiRunnerEngine(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALPhpRunnerEngine(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALPhpRunner(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
 // ,WinSock2
  ,WinSock
  ,Contnrs
  ,SyncObjs
  ,ALHttpCommon
  ,ALStringList
  ,ALPhpRunner
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALPhpRunner]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALPhpCgiRunnerEngine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALPhpRunnerEngine', 'TALPhpCgiRunnerEngine') do
  with CL.AddClassN(CL.FindClass('TALPhpRunnerEngine'),'TALPhpCgiRunnerEngine') do begin
    RegisterMethod('Constructor Create6;');
    RegisterMethod('Constructor Create7( aPhpInterpreter : AnsiString);');
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( aPhpInterpreter : AnsiString);');
    RegisterMethod('Procedure Execute( ServerVariables : TALStrings; RequestContentStream : Tstream; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader)');
    RegisterProperty('PhpInterpreter', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALPhpNamedPipeFastCgiManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALPhpRunnerEngine', 'TALPhpNamedPipeFastCgiManager') do
  with CL.AddClassN(CL.FindClass('TALPhpRunnerEngine'),'TALPhpNamedPipeFastCgiManager') do begin
    RegisterMethod('Constructor Create4;');
    RegisterMethod('Constructor Create5( aPhpInterpreter : AnsiString);');
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( aPhpInterpreter : AnsiString);');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Execute( ServerVariables : TALStrings; RequestContentStream : Tstream; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader)');
    RegisterProperty('PhpInterpreter', 'AnsiString', iptrw);
    RegisterProperty('ProcessPoolSize', 'integer', iptrw);
    RegisterProperty('MaxRequestCount', 'Integer', iptrw);
    RegisterProperty('Timeout', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALPhpNamedPipeFastCgiRunnerEngine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALPhpFastCgiRunnerEngine', 'TALPhpNamedPipeFastCgiRunnerEngine') do
  with CL.AddClassN(CL.FindClass('TALPhpFastCgiRunnerEngine'),'TALPhpNamedPipeFastCgiRunnerEngine') do begin
    RegisterMethod('Constructor Create2;');
    RegisterMethod('Constructor Create3( aPhpInterpreterFilename : AnsiString);');
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( aPhpInterpreterFilename : AnsiString);');
       RegisterMethod('Procedure Free');
       RegisterMethod('Procedure Connect( aPhpInterpreterFilename : AnsiString)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Procedure Execute( ServerVariables : TALStrings; RequestContentStream : Tstream; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader)');
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterProperty('Timeout', 'integer', iptrw);
    RegisterProperty('MaxRequestCount', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALPhpSocketFastCgiRunnerEngine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALPhpFastCgiRunnerEngine', 'TALPhpSocketFastCgiRunnerEngine') do
  with CL.AddClassN(CL.FindClass('TALPhpFastCgiRunnerEngine'),'TALPhpSocketFastCgiRunnerEngine') do begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( const aHost : AnsiString; const APort : integer);');
    RegisterMethod('Constructor CreateV;');
    RegisterMethod('Constructor Create1V( const aHost : AnsiString; const APort : integer);');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Connect( const aHost : AnsiString; const APort : integer)');
    RegisterMethod('Procedure Disconnect');
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterProperty('SendTimeout', 'Integer', iptrw);
    RegisterProperty('ReceiveTimeout', 'Integer', iptrw);
    RegisterProperty('KeepAlive', 'Boolean', iptrw);
    RegisterProperty('TcpNoDelay', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALPhpFastCgiRunnerEngine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALPhpRunnerEngine', 'TALPhpFastCgiRunnerEngine') do
  with CL.AddClassN(CL.FindClass('TALPhpRunnerEngine'),'TALPhpFastCgiRunnerEngine') do begin
     RegisterMethod('Procedure Execute( ServerVariables : TALStrings; RequestContentStream : Tstream; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALPhpRunnerEngine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TALPhpRunnerEngine') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TALPhpRunnerEngine') do begin
    RegisterMethod('Procedure Execute( ServerVariables : TALStrings; RequestContentStream : Tstream; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader);');
    RegisterMethod('Function Execute1( ServerVariables : TALStrings; RequestContentStream : Tstream) : AnsiString;');
    RegisterMethod('Procedure Execute2( ServerVariables : TALStrings; RequestContentString : AnsiString; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader);');
    RegisterMethod('Function Execute3( ServerVariables : TALStrings; RequestContentString : AnsiString) : AnsiString;');
    RegisterMethod('Procedure ExecutePostUrlEncoded( ServerVariables : TALStrings; PostDataStrings : TALStrings; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader; const EncodeParams : Boolean);');
    RegisterMethod('Function ExecutePostUrlEncoded1( ServerVariables : TALStrings; PostDataStrings : TALStrings; const EncodeParams : Boolean) : AnsiString;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALPhpRunner(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TStartupInfoA', 'TStartupInfo');
  SIRegister_TALPhpRunnerEngine(CL);
  SIRegister_TALPhpFastCgiRunnerEngine(CL);
  SIRegister_TALPhpSocketFastCgiRunnerEngine(CL);
  SIRegister_TALPhpNamedPipeFastCgiRunnerEngine(CL);
  SIRegister_TALPhpNamedPipeFastCgiManager(CL);
  SIRegister_TALPhpCgiRunnerEngine(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALPhpCgiRunnerEnginePhpInterpreter_W(Self: TALPhpCgiRunnerEngine; const T: AnsiString);
begin Self.PhpInterpreter := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpCgiRunnerEnginePhpInterpreter_R(Self: TALPhpCgiRunnerEngine; var T: AnsiString);
begin T := Self.PhpInterpreter; end;

(*----------------------------------------------------------------------------*)
Function TALPhpCgiRunnerEngineCreate7_P(Self: TClass; CreateNewInstance: Boolean;  aPhpInterpreter : AnsiString):TObject;
Begin Result := TALPhpCgiRunnerEngine.Create(aPhpInterpreter); END;

(*----------------------------------------------------------------------------*)
Function TALPhpCgiRunnerEngineCreate6_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TALPhpCgiRunnerEngine.Create; END;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiManagerTimeout_W(Self: TALPhpNamedPipeFastCgiManager; const T: integer);
begin Self.Timeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiManagerTimeout_R(Self: TALPhpNamedPipeFastCgiManager; var T: integer);
begin T := Self.Timeout; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiManagerMaxRequestCount_W(Self: TALPhpNamedPipeFastCgiManager; const T: Integer);
begin Self.MaxRequestCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiManagerMaxRequestCount_R(Self: TALPhpNamedPipeFastCgiManager; var T: Integer);
begin T := Self.MaxRequestCount; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiManagerProcessPoolSize_W(Self: TALPhpNamedPipeFastCgiManager; const T: integer);
begin Self.ProcessPoolSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiManagerProcessPoolSize_R(Self: TALPhpNamedPipeFastCgiManager; var T: integer);
begin T := Self.ProcessPoolSize; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiManagerPhpInterpreter_W(Self: TALPhpNamedPipeFastCgiManager; const T: AnsiString);
begin Self.PhpInterpreter := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiManagerPhpInterpreter_R(Self: TALPhpNamedPipeFastCgiManager; var T: AnsiString);
begin T := Self.PhpInterpreter; end;

(*----------------------------------------------------------------------------*)
Function TALPhpNamedPipeFastCgiManagerCreate5_P(Self: TClass; CreateNewInstance: Boolean;  aPhpInterpreter : AnsiString):TObject;
Begin Result := TALPhpNamedPipeFastCgiManager.Create(aPhpInterpreter); END;

(*----------------------------------------------------------------------------*)
Function TALPhpNamedPipeFastCgiManagerCreate4_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TALPhpNamedPipeFastCgiManager.Create; END;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiRunnerEngineMaxRequestCount_W(Self: TALPhpNamedPipeFastCgiRunnerEngine; const T: Integer);
begin Self.MaxRequestCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiRunnerEngineMaxRequestCount_R(Self: TALPhpNamedPipeFastCgiRunnerEngine; var T: Integer);
begin T := Self.MaxRequestCount; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiRunnerEngineTimeout_W(Self: TALPhpNamedPipeFastCgiRunnerEngine; const T: integer);
begin Self.Timeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiRunnerEngineTimeout_R(Self: TALPhpNamedPipeFastCgiRunnerEngine; var T: integer);
begin T := Self.Timeout; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpNamedPipeFastCgiRunnerEngineConnected_R(Self: TALPhpNamedPipeFastCgiRunnerEngine; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
Function TALPhpNamedPipeFastCgiRunnerEngineCreate3_P(Self: TClass; CreateNewInstance: Boolean;  aPhpInterpreterFilename : AnsiString):TObject;
Begin Result := TALPhpNamedPipeFastCgiRunnerEngine.Create(aPhpInterpreterFilename); END;

(*----------------------------------------------------------------------------*)
Function TALPhpNamedPipeFastCgiRunnerEngineCreate2_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TALPhpNamedPipeFastCgiRunnerEngine.Create; END;

(*----------------------------------------------------------------------------*)
procedure TALPhpSocketFastCgiRunnerEngineTcpNoDelay_W(Self: TALPhpSocketFastCgiRunnerEngine; const T: Boolean);
begin Self.TcpNoDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpSocketFastCgiRunnerEngineTcpNoDelay_R(Self: TALPhpSocketFastCgiRunnerEngine; var T: Boolean);
begin T := Self.TcpNoDelay; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpSocketFastCgiRunnerEngineKeepAlive_W(Self: TALPhpSocketFastCgiRunnerEngine; const T: Boolean);
begin Self.KeepAlive := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpSocketFastCgiRunnerEngineKeepAlive_R(Self: TALPhpSocketFastCgiRunnerEngine; var T: Boolean);
begin T := Self.KeepAlive; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpSocketFastCgiRunnerEngineReceiveTimeout_W(Self: TALPhpSocketFastCgiRunnerEngine; const T: Integer);
begin Self.ReceiveTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpSocketFastCgiRunnerEngineReceiveTimeout_R(Self: TALPhpSocketFastCgiRunnerEngine; var T: Integer);
begin T := Self.ReceiveTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpSocketFastCgiRunnerEngineSendTimeout_W(Self: TALPhpSocketFastCgiRunnerEngine; const T: Integer);
begin Self.SendTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpSocketFastCgiRunnerEngineSendTimeout_R(Self: TALPhpSocketFastCgiRunnerEngine; var T: Integer);
begin T := Self.SendTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TALPhpSocketFastCgiRunnerEngineConnected_R(Self: TALPhpSocketFastCgiRunnerEngine; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
Function TALPhpSocketFastCgiRunnerEngineCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const aHost : AnsiString; const APort : integer):TObject;
Begin Result := TALPhpSocketFastCgiRunnerEngine.Create(aHost, APort); END;

(*----------------------------------------------------------------------------*)
Function TALPhpSocketFastCgiRunnerEngineCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TALPhpSocketFastCgiRunnerEngine.Create; END;

(*----------------------------------------------------------------------------*)
Function TALPhpRunnerEngineExecutePostUrlEncoded1_P(Self: TALPhpRunnerEngine;  ServerVariables : TALStrings; PostDataStrings : TALStrings; const EncodeParams : Boolean) : AnsiString;
Begin Result := Self.ExecutePostUrlEncoded(ServerVariables, PostDataStrings, EncodeParams); END;

(*----------------------------------------------------------------------------*)
Procedure TALPhpRunnerEngineExecutePostUrlEncoded_P(Self: TALPhpRunnerEngine;  ServerVariables : TALStrings; PostDataStrings : TALStrings; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader; const EncodeParams : Boolean);
Begin Self.ExecutePostUrlEncoded(ServerVariables, PostDataStrings, ResponseContentStream, ResponseHeader, EncodeParams); END;

(*----------------------------------------------------------------------------*)
Function TALPhpRunnerEngineExecute3_P(Self: TALPhpRunnerEngine;  ServerVariables : TALStrings; RequestContentString : AnsiString) : AnsiString;
Begin Result := Self.Execute(ServerVariables, RequestContentString); END;

(*----------------------------------------------------------------------------*)
Procedure TALPhpRunnerEngineExecute2_P(Self: TALPhpRunnerEngine;  ServerVariables : TALStrings; RequestContentString : AnsiString; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader);
Begin Self.Execute(ServerVariables, RequestContentString, ResponseContentStream, ResponseHeader); END;

(*----------------------------------------------------------------------------*)
Function TALPhpRunnerEngineExecute1_P(Self: TALPhpRunnerEngine;  ServerVariables : TALStrings; RequestContentStream : Tstream) : AnsiString;
Begin Result := Self.Execute(ServerVariables, RequestContentStream); END;

(*----------------------------------------------------------------------------*)
Procedure TALPhpRunnerEngineExecute_P(Self: TALPhpRunnerEngine;  ServerVariables : TALStrings; RequestContentStream : Tstream; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader);
Begin Self.Execute(ServerVariables, RequestContentStream, ResponseContentStream, ResponseHeader); END;


(*----------------------------------------------------------------------------*)
Procedure TALPhpRunnerEngineExecute1_PE(Self: TALPhpRunnerEngine;  ServerVariables : TALStrings; RequestContentStream : Tstream; ResponseContentStream : Tstream; ResponseHeader : TALHTTPResponseHeader);
Begin Self.Execute(ServerVariables, RequestContentStream, ResponseContentStream, ResponseHeader); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALPhpCgiRunnerEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALPhpCgiRunnerEngine) do begin
    RegisterConstructor(@TALPhpCgiRunnerEngineCreate6_P, 'Create6');
    RegisterConstructor(@TALPhpCgiRunnerEngineCreate7_P, 'Create7');
    RegisterConstructor(@TALPhpCgiRunnerEngineCreate6_P, 'Create');
    RegisterConstructor(@TALPhpCgiRunnerEngineCreate7_P, 'Create1');
    RegisterMethod(@TALPhpCgiRunnerEngine.Execute, 'Execute');
    RegisterPropertyHelper(@TALPhpCgiRunnerEnginePhpInterpreter_R,@TALPhpCgiRunnerEnginePhpInterpreter_W,'PhpInterpreter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALPhpNamedPipeFastCgiManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALPhpNamedPipeFastCgiManager) do begin
    RegisterConstructor(@TALPhpNamedPipeFastCgiManagerCreate4_P, 'Create4');
    RegisterConstructor(@TALPhpNamedPipeFastCgiManagerCreate5_P, 'Create5');
    RegisterConstructor(@TALPhpNamedPipeFastCgiManagerCreate4_P, 'Create');
    RegisterConstructor(@TALPhpNamedPipeFastCgiManagerCreate5_P, 'Create1');
   RegisterMethod(@TALPhpNamedPipeFastCgiManager.Destroy, 'Free');

    RegisterMethod(@TALPhpNamedPipeFastCgiManager.Execute, 'Execute');
    RegisterPropertyHelper(@TALPhpNamedPipeFastCgiManagerPhpInterpreter_R,@TALPhpNamedPipeFastCgiManagerPhpInterpreter_W,'PhpInterpreter');
    RegisterPropertyHelper(@TALPhpNamedPipeFastCgiManagerProcessPoolSize_R,@TALPhpNamedPipeFastCgiManagerProcessPoolSize_W,'ProcessPoolSize');
    RegisterPropertyHelper(@TALPhpNamedPipeFastCgiManagerMaxRequestCount_R,@TALPhpNamedPipeFastCgiManagerMaxRequestCount_W,'MaxRequestCount');
    RegisterPropertyHelper(@TALPhpNamedPipeFastCgiManagerTimeout_R,@TALPhpNamedPipeFastCgiManagerTimeout_W,'Timeout');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALPhpNamedPipeFastCgiRunnerEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALPhpNamedPipeFastCgiRunnerEngine) do begin
    RegisterConstructor(@TALPhpNamedPipeFastCgiRunnerEngineCreate2_P, 'Create2');
    RegisterConstructor(@TALPhpNamedPipeFastCgiRunnerEngineCreate3_P, 'Create3');
    RegisterConstructor(@TALPhpNamedPipeFastCgiRunnerEngineCreate2_P, 'Create');
    RegisterConstructor(@TALPhpNamedPipeFastCgiRunnerEngineCreate3_P, 'Create1');
    RegisterMethod(@TALPhpNamedPipeFastCgiRunnerEngine.Destroy, 'Free');

    RegisterVirtualMethod(@TALPhpNamedPipeFastCgiRunnerEngine.Connect, 'Connect');
    RegisterVirtualMethod(@TALPhpNamedPipeFastCgiRunnerEngine.Disconnect, 'Disconnect');
    RegisterMethod(@TALPhpNamedPipeFastCgiRunnerEngine.Execute, 'Execute');
    RegisterPropertyHelper(@TALPhpNamedPipeFastCgiRunnerEngineConnected_R,nil,'Connected');
    RegisterPropertyHelper(@TALPhpNamedPipeFastCgiRunnerEngineTimeout_R,@TALPhpNamedPipeFastCgiRunnerEngineTimeout_W,'Timeout');
    RegisterPropertyHelper(@TALPhpNamedPipeFastCgiRunnerEngineMaxRequestCount_R,@TALPhpNamedPipeFastCgiRunnerEngineMaxRequestCount_W,'MaxRequestCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALPhpSocketFastCgiRunnerEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALPhpSocketFastCgiRunnerEngine) do begin
    RegisterConstructor(@TALPhpSocketFastCgiRunnerEngineCreate_P, 'Create');
    RegisterConstructor(@TALPhpSocketFastCgiRunnerEngineCreate1_P, 'Create1');
    RegisterVirtualConstructor(@TALPhpSocketFastCgiRunnerEngineCreate_P, 'CreateV');
    RegisterVirtualConstructor(@TALPhpSocketFastCgiRunnerEngineCreate1_P, 'Create1V');
    RegisterMethod(@TALPhpSocketFastCgiRunnerEngine.Destroy, 'Free');

    RegisterVirtualMethod(@TALPhpSocketFastCgiRunnerEngine.Connect, 'Connect');
    RegisterVirtualMethod(@TALPhpSocketFastCgiRunnerEngine.Disconnect, 'Disconnect');
    RegisterPropertyHelper(@TALPhpSocketFastCgiRunnerEngineConnected_R,nil,'Connected');
    RegisterPropertyHelper(@TALPhpSocketFastCgiRunnerEngineSendTimeout_R,@TALPhpSocketFastCgiRunnerEngineSendTimeout_W,'SendTimeout');
    RegisterPropertyHelper(@TALPhpSocketFastCgiRunnerEngineReceiveTimeout_R,@TALPhpSocketFastCgiRunnerEngineReceiveTimeout_W,'ReceiveTimeout');
    RegisterPropertyHelper(@TALPhpSocketFastCgiRunnerEngineKeepAlive_R,@TALPhpSocketFastCgiRunnerEngineKeepAlive_W,'KeepAlive');
    RegisterPropertyHelper(@TALPhpSocketFastCgiRunnerEngineTcpNoDelay_R,@TALPhpSocketFastCgiRunnerEngineTcpNoDelay_W,'TcpNoDelay');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALPhpFastCgiRunnerEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALPhpFastCgiRunnerEngine) do begin
    RegisterMethod(@TALPhpFastCgiRunnerEngine.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALPhpRunnerEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALPhpRunnerEngine) do begin
    //RegisterVirtualAbstractMethod(@TALPhpRunnerEngine, @!.Execute, 'Execute');
    RegisterVirtualMethod(@TALPhpRunnerEngineExecute1_PE, 'Execute');
    RegisterVirtualMethod(@TALPhpRunnerEngineExecute1_P, 'Execute1');
    RegisterVirtualMethod(@TALPhpRunnerEngineExecute2_P, 'Execute2');
    RegisterVirtualMethod(@TALPhpRunnerEngineExecute3_P, 'Execute3');
    RegisterVirtualMethod(@TALPhpRunnerEngineExecutePostUrlEncoded_P, 'ExecutePostUrlEncoded');
    RegisterVirtualMethod(@TALPhpRunnerEngineExecutePostUrlEncoded1_P, 'ExecutePostUrlEncoded1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALPhpRunner(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALPhpRunnerEngine(CL);
  RIRegister_TALPhpFastCgiRunnerEngine(CL);
  RIRegister_TALPhpSocketFastCgiRunnerEngine(CL);
  RIRegister_TALPhpNamedPipeFastCgiRunnerEngine(CL);
  RIRegister_TALPhpNamedPipeFastCgiManager(CL);
  RIRegister_TALPhpCgiRunnerEngine(CL);
end;

 
 
{ TPSImport_ALPhpRunner }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALPhpRunner.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALPhpRunner(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALPhpRunner.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALPhpRunner(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
