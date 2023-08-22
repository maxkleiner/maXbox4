unit uPSI_cmdIntf;
{
   prepare for dll loading
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
  TPSImport_cmdIntf = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCommandModule(CL: TPSPascalCompiler);
procedure SIRegister_TInfoCommand(CL: TPSPascalCompiler);
procedure SIRegister_TmodCommand(CL: TPSPascalCompiler);
procedure SIRegister_ICommandServer(CL: TPSPascalCompiler);
procedure SIRegister_cmdIntf(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCommandModule(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInfoCommand(CL: TPSRuntimeClassImporter);
procedure RIRegister_TmodCommand(CL: TPSRuntimeClassImporter);
procedure RIRegister_cmdIntf(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,cmdIntf
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cmdIntf]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCommandModule(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tObjectList', 'TCommandModule') do
  with CL.AddClassN(CL.FindClass('tObjectList'),'TCommandModule') do begin
    RegisterMethod('Constructor Create( aName : STRING)');
    RegisterMethod('Procedure ServerConnect( aThread : TThread)');
    RegisterMethod('Procedure ServerDisconnect( aThread : TThread)');
    RegisterMethod('Function GetCommandByName( aName : STRING) : TmodCommand');
    RegisterMethod('Procedure Execute( Thread : TThread; Command : STRING; Params, Response : TStrings; Data : TComponent)');
    RegisterProperty('Name', 'STRING', iptr);
    RegisterProperty('Items', 'TmodCommand INTEGER', iptr);
    RegisterProperty('Enabled', 'BOOLEAN', iptrw);
    RegisterProperty('Mananger', 'ICommandServer', iptr);
    RegisterProperty('ModuleFilePath', 'STRING', iptr);
    RegisterProperty('ModuleFileName', 'STRING', iptr);
    RegisterProperty('ModuleHandle', 'THandle', iptr);
    RegisterProperty('Version', 'TStringList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInfoCommand(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TModCommand', 'TInfoCommand') do
  with CL.AddClassN(CL.FindClass('TModCommand'),'TInfoCommand') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TmodCommand(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tObject', 'TmodCommand') do
  with CL.AddClassN(CL.FindClass('tObject'),'TmodCommand') do
  begin
    RegisterMethod('Constructor Create( aOwner : TCommandModule; aName : STRING)');
    RegisterMethod('Procedure Execute( Thread : TThread; Params, Respond : tStrings; Data : TComponent)');
    RegisterProperty('Name', 'STRING', iptr);
    RegisterProperty('Enabled', 'BOOLEAN', iptrw);
    RegisterProperty('Owner', 'TCommandModule', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ICommandServer(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ICommandServer') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ICommandServer, 'ICommandServer') do
  begin
    RegisterMethod('Function InstallModule( aModule : TCommandModule) : INTEGER', cdRegister);
    RegisterMethod('Function GetModuleByName( aName : STRING) : TCommandModule', cdRegister);
    RegisterMethod('Function GetModuleCount : INTEGER', cdRegister);
    RegisterMethod('Function GetModule( i : INTEGER) : TCommandModule', cdRegister);
    RegisterMethod('Procedure Execute( Thread : TThread; Module : STRING; Params, Response : TStrings)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cmdIntf(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCommandModule');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TmodCommand');
  SIRegister_ICommandServer(CL);
  SIRegister_TmodCommand(CL);
  SIRegister_TInfoCommand(CL);
  SIRegister_TCommandModule(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCommandModuleVersion_R(Self: TCommandModule; var T: TStringList);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TCommandModuleModuleHandle_R(Self: TCommandModule; var T: THandle);
begin T := Self.ModuleHandle; end;

(*----------------------------------------------------------------------------*)
procedure TCommandModuleModuleFileName_R(Self: TCommandModule; var T: STRING);
begin T := Self.ModuleFileName; end;

(*----------------------------------------------------------------------------*)
procedure TCommandModuleModuleFilePath_R(Self: TCommandModule; var T: STRING);
begin T := Self.ModuleFilePath; end;

(*----------------------------------------------------------------------------*)
procedure TCommandModuleMananger_R(Self: TCommandModule; var T: ICommandServer);
begin T := Self.Mananger; end;

(*----------------------------------------------------------------------------*)
procedure TCommandModuleEnabled_W(Self: TCommandModule; const T: BOOLEAN);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommandModuleEnabled_R(Self: TCommandModule; var T: BOOLEAN);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TCommandModuleItems_R(Self: TCommandModule; var T: TmodCommand; const t1: INTEGER);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCommandModuleName_R(Self: TCommandModule; var T: STRING);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TmodCommandOwner_R(Self: TmodCommand; var T: TCommandModule);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TmodCommandEnabled_W(Self: TmodCommand; const T: BOOLEAN);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TmodCommandEnabled_R(Self: TmodCommand; var T: BOOLEAN);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TmodCommandName_R(Self: TmodCommand; var T: STRING);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCommandModule(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommandModule) do
  begin
    RegisterConstructor(@TCommandModule.Create, 'Create');
    RegisterVirtualMethod(@TCommandModule.ServerConnect, 'ServerConnect');
    RegisterVirtualMethod(@TCommandModule.ServerDisconnect, 'ServerDisconnect');
    RegisterMethod(@TCommandModule.GetCommandByName, 'GetCommandByName');
    RegisterMethod(@TCommandModule.Execute, 'Execute');
    RegisterPropertyHelper(@TCommandModuleName_R,nil,'Name');
    RegisterPropertyHelper(@TCommandModuleItems_R,nil,'Items');
    RegisterPropertyHelper(@TCommandModuleEnabled_R,@TCommandModuleEnabled_W,'Enabled');
    RegisterPropertyHelper(@TCommandModuleMananger_R,nil,'Mananger');
    RegisterPropertyHelper(@TCommandModuleModuleFilePath_R,nil,'ModuleFilePath');
    RegisterPropertyHelper(@TCommandModuleModuleFileName_R,nil,'ModuleFileName');
    RegisterPropertyHelper(@TCommandModuleModuleHandle_R,nil,'ModuleHandle');
    RegisterPropertyHelper(@TCommandModuleVersion_R,nil,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInfoCommand(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInfoCommand) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TmodCommand(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TmodCommand) do
  begin
    RegisterConstructor(@TmodCommand.Create, 'Create');
    RegisterVirtualMethod(@TmodCommand.Execute, 'Execute');
    RegisterPropertyHelper(@TmodCommandName_R,nil,'Name');
    RegisterPropertyHelper(@TmodCommandEnabled_R,@TmodCommandEnabled_W,'Enabled');
    RegisterPropertyHelper(@TmodCommandOwner_R,nil,'Owner');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cmdIntf(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommandModule) do
  with CL.Add(TmodCommand) do
  RIRegister_TmodCommand(CL);
  RIRegister_TInfoCommand(CL);
  RIRegister_TCommandModule(CL);
end;

 
 
{ TPSImport_cmdIntf }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cmdIntf.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cmdIntf(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cmdIntf.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
