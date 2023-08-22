unit uPSI_NamedPipesImpl;
{
Ta second unit of namedpipes to a class codex
      RIRegister_NamedPipeThreads(X);

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
  TPSImport_NamedPipesImpl = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ENamedPipe(CL: TPSPascalCompiler);
procedure SIRegister_TNamedPipeClient(CL: TPSPascalCompiler);
procedure SIRegister_TNamedPipeServer(CL: TPSPascalCompiler);
procedure SIRegister_TNamedPipe2(CL: TPSPascalCompiler);
procedure SIRegister_NamedPipesImpl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_NamedPipesImpl_Routines(S: TPSExec);
procedure RIRegister_ENamedPipe(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNamedPipeClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNamedPipeServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNamedPipe2(CL: TPSRuntimeClassImporter);
procedure RIRegister_NamedPipesImpl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SyncObjs
  ,Windows
  ,NamedPipesImpl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_NamedPipesImpl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ENamedPipe(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ENamedPipe') do
  with CL.AddClassN(CL.FindClass('Exception'),'ENamedPipe') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNamedPipeClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNamedPipe2', 'TNamedPipeClient') do
  with CL.AddClassN(CL.FindClass('TNamedPipe2'),'TNamedPipeClient') do
  begin
    RegisterMethod('Procedure CheckConnected');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Function Open( const UserName : WideString; const Password : WideString) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNamedPipeServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNamedPipe2', 'TNamedPipeServer') do
  with CL.AddClassN(CL.FindClass('TNamedPipe2'),'TNamedPipeServer') do
  begin
    RegisterMethod('Procedure CheckConnected');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Function Open( const UserName : WideString; const Password : WideString) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNamedPipe2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TNamedPipe2') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TNamedPipe2') do begin
    RegisterMethod('Constructor Create( const PipeName : WideString; const Server : WideString)');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure CheckConnected');
    RegisterMethod('Function Open( const UserName : WideString; const Password : WideString) : Boolean');
    RegisterMethod('Procedure Close');
    RegisterMethod('Function Read : WideString;');
    RegisterMethod('Procedure Read1( var Buffer : WideString);');
    RegisterMethod('Procedure Write( const Message : WideString)');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('TimeOut', 'Cardinal', iptrw);
    RegisterProperty('OnError', 'TError', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_NamedPipesImpl(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('NamedPipeLocalHost','String').SetString( '.');
 CL.AddConstantN('NamedPipeIOBufferSize','LongInt').SetInt( 16384);
 CL.AddConstantN('NamedPipeOutputBufferSize','longint').SetInt(16384);
 CL.AddConstantN('NamedPipeInputBufferSize','longint').SetInt(16384);
  CL.AddTypeS('TError', 'Procedure ( const Msg : string)');
  SIRegister_TNamedPipe2(CL);
  SIRegister_TNamedPipeServer(CL);
  SIRegister_TNamedPipeClient(CL);
  SIRegister_ENamedPipe(CL);
  //CL.AddTypeS('TNamedPipeClass', 'class of TNamedPipe');
 CL.AddDelphiFunction('Function NetLogon( const Server, User, Password : WideString; out ErrorMessage : string) : Boolean');
 CL.AddDelphiFunction('Function NetLogoff( const Server, User, Password : WideString) : Boolean');
 CL.AddDelphiFunction('Procedure ErrorNamedPipe( const Message : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TNamedPipe2OnError_W(Self: TNamedPipe2; const T: TError2);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TNamedPipe2OnError_R(Self: TNamedPipe2; var T: TError2);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TNamedPipe2TimeOut_W(Self: TNamedPipe2; const T: Cardinal);
begin Self.TimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TNamedPipe2TimeOut_R(Self: TNamedPipe2; var T: Cardinal);
begin T := Self.TimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TNamedPipe2Handle_R(Self: TNamedPipe2; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TNamedPipe2Connected_R(Self: TNamedPipe2; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
Procedure TNamedPipe2Read1_P(Self: TNamedPipe2;  var Buffer : WideString);
Begin Self.Read(Buffer); END;

(*----------------------------------------------------------------------------*)
Function TNamedPipe2Read_P(Self: TNamedPipe2) : WideString;
Begin Result := Self.Read; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NamedPipesImpl_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@NetLogon, 'NetLogon', cdRegister);
 S.RegisterDelphiFunction(@NetLogoff, 'NetLogoff', cdRegister);
 S.RegisterDelphiFunction(@ErrorNamedPipe, 'ErrorNamedPipe', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ENamedPipe(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ENamedPipe) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNamedPipeClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNamedPipeClient) do
  begin
    RegisterMethod(@TNamedPipeClient.CheckConnected, 'CheckConnected');
    RegisterMethod(@TNamedPipeClient.Connect, 'Connect');
    RegisterMethod(@TNamedPipeClient.Open, 'Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNamedPipeServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNamedPipeServer) do
  begin
    RegisterMethod(@TNamedPipeServer.CheckConnected, 'CheckConnected');
    RegisterMethod(@TNamedPipeServer.Connect, 'Connect');
    RegisterMethod(@TNamedPipeServer.Open, 'Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNamedPipe2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNamedPipe2) do begin
    RegisterConstructor(@TNamedPipe2.Create, 'Create');
     RegisterMethod(@TNamedPipe2.Destroy, 'Free');

    //RegisterVirtualAbstractMethod(@TNamedPipe2, @!.CheckConnected, 'CheckConnected');
    RegisterVirtualMethod(@TNamedPipe2.Open, 'Open');
    RegisterMethod(@TNamedPipe2.Close, 'Close');
    RegisterMethod(@TNamedPipe2Read_P, 'Read');
    RegisterMethod(@TNamedPipe2Read1_P, 'Read1');
    RegisterVirtualMethod(@TNamedPipe2.Write, 'Write');
    //RegisterVirtualAbstractMethod(@TNamedPipe2, @Connect, 'Connect');
    RegisterVirtualMethod(@TNamedPipe2.Disconnect, 'Disconnect');
    RegisterPropertyHelper(@TNamedPipe2Connected_R,nil,'Connected');
    RegisterPropertyHelper(@TNamedPipe2Handle_R,nil,'Handle');
    RegisterPropertyHelper(@TNamedPipe2TimeOut_R,@TNamedPipe2TimeOut_W,'TimeOut');
    RegisterPropertyHelper(@TNamedPipe2OnError_R,@TNamedPipe2OnError_W,'OnError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NamedPipesImpl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNamedPipe2(CL);
  RIRegister_TNamedPipeServer(CL);
  RIRegister_TNamedPipeClient(CL);
  RIRegister_ENamedPipe(CL);
end;

 
 
{ TPSImport_NamedPipesImpl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_NamedPipesImpl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_NamedPipesImpl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_NamedPipesImpl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_NamedPipesImpl(ri);
  RIRegister_NamedPipesImpl_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
