{ Component wrapper for IFPS3 compiler and executer A component
  wrapper for IFPS3, including debugging support.               }
unit uPSComponent;

interface

uses
  SysUtils, Classes, uPSRuntime, uPSDebugger, uPSUtils,
  uPSCompiler, uPSC_dll, uPSR_dll, uPSPreProcessor;

const
  {alias to @link(ifps3.cdRegister)}
  cdRegister = uPSRuntime.cdRegister;
  {alias to @link(ifps3.cdPascal)}
  cdPascal = uPSRuntime.cdPascal;
  { alias to ifps3.cdCdecl }
  CdCdecl = uPSRuntime.CdCdecl;
  {alias to @link(ifps3.cdStdcall)}
  CdStdCall = uPSRuntime.CdStdCall;

type
  TPSScript = class;
  {Alias to @link(ifps3.TPSCallingConvention)}
  TDelphiCallingConvention = uPSRuntime.TPSCallingConvention;
  {Alias to @link(ifps3.TPSRuntimeClassImporter)}
  TPSRuntimeClassImporter = uPSRuntime.TPSRuntimeClassImporter;
  {Base class for all plugins for the component}
  TPSPlugin = class(TComponent)
  protected
    { Called when the OnUses event occurs. }
    procedure CompOnUses(CompExec: TPSScript); virtual;
    { ExecOnUses event }
    procedure ExecOnUses(CompExec: TPSScript); virtual;
    { Compile import 1 is called in the first round of compile
      imports                                                  }
    procedure CompileImport1(CompExec: TPSScript); virtual;
    { Compile import 1 is called in the second round of compile
      imports                                                   }
    procedure CompileImport2(CompExec: TPSScript); virtual;
    { Exec import 1 is called in the first round of exec imports }
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); virtual;
    { Exec import 2 is called in the second round of exec imports }
    procedure ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); virtual;
  public
  end;
  { Alias for the <LINK uPSComponent.TPSPlugin, TPSPlugin> class. }
  TIFPS3Plugin = class(TPSPlugin);
  { The DLL Plugin allows you to call regular DLLs from the
    script engine                                           }
  TPSDllPlugin = class(TPSPlugin)
  protected
    procedure CompOnUses(CompExec: TPSScript); override;
    procedure ExecOnUses(CompExec: TPSScript); override;
  end;
  { Alias for the <LINK uPSComponent.TPSDllPlugin, TPSDllPlugin> class. }
  TIFPS3DllPlugin = class(TPSDllPlugin);

  { a single plugin item }
  TPSPluginItem = class(TCollectionItem)
  private
    FPlugin: TPSPlugin;
    procedure SetPlugin(const Value: TPSPlugin);
  protected
    { \Returns the display name for this item }
    function GetDisplayName: string; override;
  published
    { Contains the actual plugin }
    property Plugin: TPSPlugin read FPlugin write SetPlugin;
  end;

  { Alias for the <LINK uPSComponent.TPSPluginItem, TPSPluginItem>
    class.                                                         }
  TIFPS3CEPluginItem = class(TPSPluginItem);

  { Collection of plugin items }
  TPSPlugins = class(TCollection)
  private
    FCompExec: TPSScript;
  protected
    { \Returns the owner (the TPSScript) of this object. }
    function GetOwner: TPersistent; override;
  public
    { Create a new instance of this class }
    constructor Create(CE: TPSScript);
  end;
 { Alias for the <LINK uPSComponent.TPSPlugins, TPSPlugins>
   class.                                                   }
 TIFPS3CEPlugins = class(TPSPlugins);

  {Options for the compiler: <br>
  icAllowUnit - Allow 'unit' instead of program headers<br>
  icAllowNoBegin - Allow the user to not have to write a main Begin<br>
  icAllowEnd - Allow that there is no ending End.<bR>
  }
  TPSOnGetNotVariant = function (Sender: TPSScript; const Name: string): Variant of object;
  TPSOnSetNotVariant = procedure (Sender: TPSScript; const Name: string; V: Variant) of object;
  TPSCompOptions = set of (icAllowNoBegin, icAllowUnit, icAllowNoEnd, icBooleanShortCircuit);
  {Script engine event function}
  TPSVerifyProc = procedure (Sender: TPSScript; Proc: TPSInternalProcedure; const Decl: string; var Error: Boolean) of object;
  {Script engine event function}
  TPSEvent = procedure (Sender: TPSScript) of object;
  {Script engine event function}
  TPSOnCompImport = procedure (Sender: TObject; x: TPSPascalCompiler) of object;
  {Script engine event function}
  TPSOnExecImport = procedure (Sender: TObject; se: TPSExec; x: TPSRuntimeClassImporter) of object;
  {Script engine event function}
  TPSOnNeedFile = function (Sender: TObject; const OrginFileName: string; var FileName, Output: string): Boolean of object;
  {TPSScript can be used for compiling and executing scripts}
  TPSScript = class(TComponent)
  private
    FOnGetNotificationVariant: TPSOnGetNotVariant;
    FOnSetNotificationVariant: TPSOnSetNotVariant;
    FCanAdd: Boolean;
    FComp: TPSPascalCompiler;
    FCompOptions: TPSCompOptions;
    FExec: TPSDebugExec;
    FSuppressLoadData: Boolean;
    FScript: TStrings;
    FOnLine: TNotifyEvent;
    FUseDebugInfo: Boolean;
    FOnAfterExecute, FOnCompile, FOnExecute: TPSEvent;
    FOnCompImport: TPSOnCompImport;
    FOnExecImport: TPSOnExecImport;
    RI: TPSRuntimeClassImporter;
    FPlugins: TPSPlugins;
    FPP: TPSPreProcessor;
    FMainFileName: string;
    FOnNeedFile: TPSOnNeedFile;
    FUsePreProcessor: Boolean;
    FDefines: TStrings;
    FOnVerifyProc: TPSVerifyProc;
    function GetRunning: Boolean;
    procedure SetScript(const Value: TStrings);
    function GetCompMsg(i: Integer): TPSPascalCompilerMessage;
    function GetCompMsgCount: Longint;
    function GetAbout: string;
    function ScriptUses(Sender: TPSPascalCompiler; const Name: string): Boolean;
    function GetExecErrorByteCodePosition: Cardinal;
    function GetExecErrorCode: TIFError;
    function GetExecErrorParam: string;
    function GetExecErrorProcNo: Cardinal;
    function GetExecErrorString: string;
    function GetExecErrorPosition: Cardinal;
    procedure OnLineEvent; virtual;
    function GetExecErrorCol: Cardinal;
    function GetExecErrorRow: Cardinal;
    procedure SetMainFileName(const Value: string); virtual;
    function GetExecErrorFileName: string;
    procedure SetDefines(const Value: TStrings);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Find a named type (for example a class) }
    function FindNamedType(const Name: string): TPSTypeRec;
    { Find a basetype (a simple basic type) }
    function FindBaseType(Bt: TPSBaseType): TPSTypeRec;
    { Don't load the data into the script engine }
    property SuppressLoadData: Boolean read FSuppressLoadData write FSuppressLoadData;
    {Load data into the exec, you only need to call this when SuppressLoadData is true}
    function LoadExec: Boolean;
    {Stop the script}
    procedure Stop; virtual;
    {Create an instance of the CompExec component}
    constructor Create(AOwner: TComponent); override;
    {Dstroy the CompExec component}
    destructor Destroy; override;
    {Compile the script}
    function Compile: Boolean; virtual;
    {Execute the compiled script}
    function Execute: Boolean; virtual;
    {Is the script running now?}
    property Running: Boolean read GetRunning;
    {Returns the compiled data, first call @link(Compile)}
    procedure GetCompiled(var data: string);
    {Load compiled data in the script engine}
    procedure SetCompiled(const Data: string);
    {PascalCompiler object}
    property Comp: TPSPascalCompiler read FComp;
    {Exec object}
    property Exec: TPSDebugExec read FExec;
    {Returns the number of compiler messages}
    property CompilerMessageCount: Longint read GetCompMsgCount;
    {Return compiler message number I}
    property CompilerMessages[i: Longint]: TPSPascalCompilerMessage read GetCompMsg;
    {Convert a compiler message to a string}
    function CompilerErrorToStr(I: Longint): string;
    {Runtime errors: error code}
    property ExecErrorCode: TIFError read GetExecErrorCode;
    {Runtime errors: more information for the error}
    property ExecErrorParam: string read GetExecErrorParam;
    {Convert an errorcode + errorparam to a string}
    property ExecErrorToString: string read GetExecErrorString;
    {The procedure number the runtime error occured in}
    property ExecErrorProcNo: Cardinal read GetExecErrorProcNo;
    {The bytecode offset the runtime error occured in}
    property ExecErrorByteCodePosition: Cardinal read GetExecErrorByteCodePosition;
    {The offset in the script the error occured in, does not work when DebugInfo = False}
    property ExecErrorPosition: Cardinal read GetExecErrorPosition;
    {The Row in the script the error occured in, does not work when DebugInfo = False}
    property ExecErrorRow: Cardinal read GetExecErrorRow;
    {The Col in the script the error occured in, does not work when DebugInfo = False}
    property ExecErrorCol: Cardinal read GetExecErrorCol;
    {Runtime errors: Exec Error filename}
    property ExecErrorFileName: string read GetExecErrorFileName;
    {Add a function to the script engine}
    function AddFunctionEx(Ptr: Pointer; const Decl: string; CallingConv: TDelphiCallingConvention): Boolean;
    {Add a function to the script engine, with @link(cdRegister) as a calling convention}
    function AddFunction(Ptr: Pointer; const Decl: string): Boolean;

    {Add a method to the script engine, slf should be the self pointer, ptr should be the procedural pointer, for example:
    Form1.Show<br>
      AddMethod(Form1, @@TForm1.Show, 'procedure Show;', cdRegister);
    }
    function AddMethodEx(Slf, Ptr: Pointer; const Decl: string; CallingConv: TDelphiCallingConvention): Boolean;
    {Add a method to the script engine, with @link(cdRegister) as a calling convention}
    function AddMethod(Slf, Ptr: Pointer; const Decl: string): Boolean;
    {Add a variable to the script engine that can be used at runtime with the @link(GetVariable) function}
    function AddRegisteredVariable(const VarName, VarType: string): Boolean;
    function AddNotificationVariant(const VarName: string): Boolean;
    {Add a variable to the script engine that can be used at runtime with the @link(SetPointerToData) function}
    function AddRegisteredPTRVariable(const VarName, VarType: string): Boolean;
    {Returns the variable with the name Name}
    function GetVariable(const Name: string): PIFVariant;
    {Set a variable to an object instance}
    function SetVarToInstance(const VarName: string; cl: TObject): Boolean;
    {Set a pointer variable to data}
    procedure SetPointerToData(const VarName: string; Data: Pointer; aType: TIFTypeRec);
    {Translate a Proc+ByteCode position into an offset in the script}
    function TranslatePositionPos(Proc, Position: Cardinal; var Pos: Cardinal; var fn: string): Boolean;
    {Translate a Proc+ByteCode position into an row/col in the script}
    function TranslatePositionRC(Proc, Position: Cardinal; var Row, Col: Cardinal; var fn: string): Boolean;
    {Get proc as TMethod, cast this to a method pointer and call it}
    function GetProcMethod(const ProcName: string): TMethod;
    {Execute a function}
    function ExecuteFunction(const Params: array of Variant; const ProcName: string): Variant;
  published
    {About this script engine}
    property About: string read GetAbout;
    {The current script}
    property Script: TStrings read FScript write SetScript;
    {Compiler options}
    property CompilerOptions: TPSCompOptions read FCompOptions write FCompOptions;
    {OnLine event, is called after each bytecode position, useful for checking messages to make sure longer scripts don't block the application} 
    property OnLine: TNotifyEvent read FOnLine write FOnLine;
    {OnCompile event is called when the script is about to be compiled}
    property OnCompile: TPSEvent read FOnCompile write FOnCompile;
    {OnExecute event is called when the script is about to the executed,
    useful for changing variables within the script}
    property OnExecute: TPSEvent read FOnExecute write FOnExecute;
    {OnAfterExecute is called when the script is done executing}
    property OnAfterExecute: TPSEvent read FOnAfterExecute write FOnAfterExecute;
    {OnCompImport is called when you can import your functions and classes into the compiler}
    property OnCompImport: TPSOnCompImport read FOnCompImport write FOnCompImport;
    {OnCompImport is called when you can import your functions and classes into the exec}
    property OnExecImport: TPSOnExecImport read FOnExecImport write FOnExecImport;
    {UseDebugInfo should be true when you want to use debug information, like position information in the script, it does make the executing a bit slower}
    property UseDebugInfo: Boolean read FUseDebugInfo write FUseDebugInfo default True;
    {Plugins for this component}
    property Plugins: TPSPlugins read FPlugins write FPlugins;
    {Main file name, this is only relevant to the errors}
    property MainFileName: string read FMainFileName write SetMainFileName;
    {Use the preprocessor, make sure the OnNeedFile event is assigned}
    property UsePreProcessor: Boolean read FUsePreProcessor write FUsePreProcessor;
    {OnNeedFile is called when the preprocessor is used and an include statement is used}
    property OnNeedFile: TPSOnNeedFile read FOnNeedFile write FOnNeedFile;
    {Compiler Defines}
    property Defines: TStrings read FDefines write SetDefines;
    {OnVerifyProc is called to check if a procedure matches the expected header}
    property OnVerifyProc: TPSVerifyProc read FOnVerifyProc write FOnVerifyProc;
    property OnGetNotificationVariant: TPSOnGetNotVariant read FOnGetNotificationVariant write FOnGetNotificationVariant;
    property OnSetNotificationVariant: TPSOnSetNotVariant read FOnSetNotificationVariant write FOnSetNotificationVariant;  
  end;
  { Alias for the <LINK uPSComponent.TPSScript, TPSScript> class. }
  TIFPS3CompExec = class(TPSScript);

  { Breakpoint information. }
  TPSBreakPointInfo = class
  private
    FLine: Longint;
    FFileNameHash: Longint;
    FFileName: string;
    procedure SetFileName(const Value: string);
  public
    { Filename of the breakpoint. }
    property FileName: string read FFileName write SetFileName;
    { hash on the filename }
    property FileNameHash: Longint read FFileNameHash;
    { Line number. }
    property Line: Longint read FLine write FLine;
  end;
  {OnLineInfo event}
  TPSOnLineInfo = procedure (Sender: TObject; const FileName: string; Position, Row, Col: Cardinal) of object;
  {TPSScriptDebugger has all features of @link(TPSScript) and also supports debugging}
  TPSScriptDebugger = class(TPSScript)
  private
    FOnIdle: TNotifyEvent;
    FBreakPoints: TIFList;
    FOnLineInfo: TPSOnLineInfo;
    FLastRow: Cardinal;
    FOnBreakpoint: TPSOnLineInfo;
    procedure SetMainFileName(const Value: string); override;
    function GetBreakPoint(I: Integer): TPSBreakPointInfo;
    function GetBreakPointCount: Longint;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { Pause the debugger }
    procedure Pause; virtual;
    { Resume debugging }
    procedure Resume; virtual;

    { Step into the current call }
    procedure StepInto; virtual;
    { Step over the current call }
    procedure StepOver; virtual;
    {Set a breakpoint at line Line}
    procedure SetBreakPoint(const Fn: string; Line: Longint);
    {clear the breakpoint at line Line}
    procedure ClearBreakPoint(const Fn: string; Line: Longint);
    {Returns the number of currently set breakpoints}
    property BreakPointCount: Longint read GetBreakPointCount;
    {Return breakpoint number I}
    property BreakPoint[I: Longint]: TPSBreakPointInfo read GetBreakPoint;
    {Has a breakpoint on line(Line) ?}
    function HasBreakPoint(const Fn: string; Line: Longint): Boolean;
    {Clear All Breakpoints}
    procedure ClearBreakPoints;
    {Returns the contents of a variable, formatted for a watch window}
    function GetVarContents(const Name: string): string;
  published
    {The on Idle event is called when the script engine is paused or on a breakpoint. You
    should call Application.ProcessMessages from here and call resume when you are done. If
    you don't assign a handler to this event, the script engine will not pause or breakpoint}
    property OnIdle: TNotifyEvent read FOnIdle write FOnIdle;
    {OnLineInfo is called for each statement the script engine has debuginfo (row, col, pos) for}
    property OnLineInfo: TPSOnLineInfo read FOnLineInfo write FOnLineInfo;
    {OnBreakPoint is called when the script engine is at a breakpoint}
    property OnBreakpoint: TPSOnLineInfo read FOnBreakpoint write FOnBreakpoint;
  end;
  { Alias for the <LINK uPSComponent.TPSScriptDebugger, TPSScriptDebugger>
    class.                                                                 }
  TIFPS3DebugCompExec = class(TPSScriptDebugger);

implementation


function MyGetVariant(Sender: TPSExec; const Name: string): Variant;
begin
  if @TPSScript(Sender.Id).OnGetNotificationVariant = nil then
    raise Exception.Create('Unable to read variant');
  Result := TPSScript(Sender.Id).OnGetNotificationVariant(TPSScript(Sender.Id), Name);
end;

procedure MySetVariant(Sender: TPSExec; const Name: string; V: Variant);
begin
  if @TPSScript(Sender.Id).OnSetNotificationVariant = nil then
    raise Exception.Create('Unable to write variant');
  TPSScript(Sender.Id).OnSetNotificationVariant(TPSScript(Sender.Id), Name, v);
end;

function CompScriptUses(Sender: TPSPascalCompiler; const Name: string): Boolean;
begin
  Result := TPSScript(Sender.ID).ScriptUses(Sender, Name);
end;

procedure ExecOnLine(Sender: TPSExec);
begin
  if assigned(TPSScript(Sender.ID).FOnLine) then
  begin
    TPSScript(Sender.ID).OnLineEvent;
  end;
end;

function CompExportCheck(Sender: TPSPascalCompiler; Proc: TPSInternalProcedure; const ProcDecl: string): Boolean;
begin
  if assigned(TPSScript(Sender.ID).FOnVerifyProc) then
  begin
    Result := false;
    TPSScript(Sender.ID).FOnVerifyProc(Sender.Id, Proc, ProcDecl, Result);
    Result := not Result;
  end else
    Result := True;
end;

{ TPSPlugin }
procedure TPSPlugin.CompileImport1(CompExec: TPSScript);
begin
  // do nothing
end;

procedure TPSPlugin.CompileImport2(CompExec: TPSScript);
begin
  // do nothing
end;

procedure TPSPlugin.CompOnUses(CompExec: TPSScript);
begin
 // do nothing
end;

procedure TPSPlugin.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  // do nothing
end;

procedure TPSPlugin.ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  // do nothing
end;

procedure TPSPlugin.ExecOnUses(CompExec: TPSScript);
begin
 // do nothing
end;


{ TPSScript }

function TPSScript.AddFunction(Ptr: Pointer;
  const Decl: string): Boolean;
begin
  Result := AddFunctionEx(Ptr, Decl, cdRegister);
end;

function TPSScript.AddFunctionEx(Ptr: Pointer; const Decl: string;
  CallingConv: TDelphiCallingConvention): Boolean;
var
  P: TPSRegProc;
begin
  if not FCanAdd then begin Result := False; exit; end;
  p := Comp.AddDelphiFunction(Decl);
  if p <> nil then
  begin
    Exec.RegisterDelphiFunction(Ptr, p.Name, CallingConv);
    Result := True;
  end else Result := False;
end;

function TPSScript.AddRegisteredVariable(const VarName,
  VarType: string): Boolean;
var
  FVar: TPSVar;
begin
  if not FCanAdd then begin Result := False; exit; end;
  FVar := FComp.AddUsedVariableN(varname, vartype);
  if fvar = nil then
    result := False
  else begin
    fvar.exportname := fvar.Name;
    Result := True;
  end;
end;

function CENeedFile(Sender: TPSPreProcessor; const callingfilename: string; var FileName, Output: string): Boolean;
begin
  if @TPSScript(Sender.ID).OnNeedFile = nil then
  begin
    Result := False;
  end else
    Result := TPSScript(Sender.ID).OnNeedFile(Sender.ID, callingfilename, FileName, Output);
end;

procedure CompTranslateLineInfo(Sender: TPSPascalCompiler; var Pos, Row, Col: Cardinal; var Name: string);
var
  res: TPSLineInfoResults;
begin
  if TPSScript(Sender.ID).FPP.CurrentLineInfo.GetLineInfo('',Pos, Res) then
  begin
    Pos := Res.Pos;
    Row := Res.Row;
    Col := Res.Col;
    Name := Res.Name;
  end;
end;

function TPSScript.Compile: Boolean;
var
  i: Longint;
  dta: string;
begin
  FExec.Clear;
  FExec.CMD_Err(erNoError);
  FExec.ClearspecialProcImports;
  FExec.ClearFunctionList;
  if ri <> nil then
  begin
    RI.Free;
    RI := nil;
  end;
  RI := TPSRuntimeClassImporter.Create;
  for i := 0 to FPlugins.Count -1 do
  begin
    if TPSPluginItem(FPlugins.Items[i]) <> nil then
      TPSPluginItem(FPlugins.Items[i]).Plugin.ExecImport1(Self, ri);
  end;
  if assigned(FOnExecImport) then
    FOnExecImport(Self, FExec, RI);
  for i := 0 to FPlugins.Count -1 do
  begin
    if TPSPluginItem(FPlugins.Items[i]) <> nil then
    TPSPluginItem(FPlugins.Items[i]).Plugin.ExecImport2(Self, ri);
  end;
  RegisterClassLibraryRuntime(Exec, RI);
  for i := 0 to FPlugins.Count -1 do
  begin
    TPSPluginItem(FPlugins.Items[i]).Plugin.ExecOnUses(Self);
  end;
  FCanAdd := True;
  FComp.BooleanShortCircuit := icBooleanShortCircuit in FCompOptions;
  FComp.AllowNoBegin := icAllowNoBegin in FCompOptions;
  FComp.AllowUnit := icAllowUnit in FCompOptions;
  FComp.AllowNoEnd := icAllowNoEnd in FCompOptions;
  if FUsePreProcessor then
  begin
    FPP.Defines.Assign(FDefines);
    FComp.OnTranslateLineInfo := CompTranslateLineInfo;
    Fpp.MainFile := FScript.Text;
    Fpp.MainFileName := FMainFileName;
    try
      Fpp.PreProcess(FMainFileName, dta);
      if FComp.Compile(dta) then
      begin
        FCanAdd := False;
        if (not SuppressLoadData) and (not LoadExec) then
        begin
          Result := False;
        end else
          Result := True;
      end else Result := False;
      Fpp.AdjustMessages(Comp);
    finally
      FPP.Clear;
    end;
  end else
  begin
    FComp.OnTranslateLineInfo := nil;
    // debug point
    if FComp.Compile(FScript.Text) then
    begin
      FCanAdd := False;
      if not LoadExec then
      begin
        Result := False;
      end else
        Result := True;
    end else Result := False;
  end;
end;

function TPSScript.CompilerErrorToStr(I: Integer): string;
begin
  Result := CompilerMessages[i].MessageToString;
end;

constructor TPSScript.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComp := TPSPascalCompiler.Create;
  FExec := TPSDebugExec.Create;
  FScript := TStringList.Create;
  FPlugins := TPSPlugins.Create(self);

  FComp.ID := Self;
  FComp.OnUses := CompScriptUses;
  FComp.OnExportCheck := CompExportCheck;
  FExec.Id := Self;
  FExec.OnRunLine:= ExecOnLine;
  FExec.OnGetNVariant := MyGetVariant;
  FExec.OnSetNVariant := MySetVariant;

  FUseDebugInfo := True;

  FPP := TPSPreProcessor.Create;
  FPP.Id := Self;
  FPP.OnNeedFile := CENeedFile;

  FDefines := TStringList.Create;
end;

destructor TPSScript.Destroy;
begin
  FDefines.Free;

  FPP.Free;
  RI.Free;
  FPlugins.Free;
  FScript.Free;
  FExec.Free;
  FComp.Free;
  inherited Destroy;
end;

function TPSScript.Execute: Boolean;
begin
  if SuppressLoadData then
    LoadExec;
  if @FOnExecute <> nil then
    FOnExecute(Self);
  FExec.DebugEnabled := FUseDebugInfo;
  Result := FExec.RunScript and (FExec.ExceptionCode = erNoError) ;
  if @FOnAfterExecute <> nil then
    FOnAfterExecute(Self);
end;

function TPSScript.GetAbout: string;
begin
  Result := TPSExec.About;
end;

procedure TPSScript.GetCompiled(var data: string);
begin
  //wrapper
  if not FComp.GetOutput(Data) then
    raise Exception.Create('Script is not compiled');
end;

function TPSScript.GetCompMsg(i: Integer): TPSPascalCompilerMessage;
begin
  Result := FComp.Msg[i];
end;

function TPSScript.GetCompMsgCount: Longint;
begin
  Result := FComp.MsgCount;
end;

function TPSScript.GetExecErrorByteCodePosition: Cardinal;
begin
  Result := Exec.ExceptionPos;
end;

function TPSScript.GetExecErrorCode: TIFError;
begin
  Result := Exec.ExceptionCode;
end;

function TPSScript.GetExecErrorParam: string;
begin
  Result := Exec.ExceptionString;
end;

function TPSScript.GetExecErrorPosition: Cardinal;
begin
  Result := FExec.TranslatePosition(Exec.ExceptionProcNo, Exec.ExceptionPos);
end;

function TPSScript.GetExecErrorProcNo: Cardinal;
begin
  Result := Exec.ExceptionProcNo;
end;

function TPSScript.GetExecErrorString: string;
begin
  Result := TIFErrorToString(Exec.ExceptionCode, Exec.ExceptionString);
end;

function TPSScript.GetVariable(const Name: string): PIFVariant;
begin
  Result := FExec.GetVar2(name);
end;

function TPSScript.LoadExec: Boolean;
var
  s: string;
begin
  if (not FComp.GetOutput(s)) or (not FExec.LoadData(s)) then
  begin
    Result := False;
    exit;
  end;
  if FUseDebugInfo then
  begin
    FComp.GetDebugOutput(s);
    FExec.LoadDebugData(s);
  end;
  Result := True;
end;

function TPSScript.ScriptUses(Sender: TPSPascalCompiler;
  const Name: string): Boolean;
var
  i: Longint;
begin
  if Name = 'SYSTEM' then
  begin
    for i := 0 to FPlugins.Count -1 do
    begin
      TPSPluginItem(FPlugins.Items[i]).Plugin.CompOnUses(Self);
    end;
    for i := 0 to FPlugins.Count -1 do
    begin
      TPSPluginItem(FPlugins.Items[i]).Plugin.CompileImport1(self);
    end;
    if assigned(FOnCompImport) then
      FOnCompImport(Self, Comp);
    for i := 0 to FPlugins.Count -1 do
    begin
      TPSPluginItem(FPlugins.Items[i]).Plugin.CompileImport2(Self);
    end;
    if assigned(FOnCompile) then
      FOnCompile(Self);
    Result := True;
  end else begin
    Sender.MakeError('', ecUnknownIdentifier, Name);
    Result := False;
  end;
end;

procedure TPSScript.SetCompiled(const Data: string);
var
  i: Integer;
begin
  FExec.Clear;
  FExec.ClearspecialProcImports;
  FExec.ClearFunctionList;
  if ri <> nil then begin
    RI.Free;
    RI:= NIL;
  end;
  RI:= TPSRuntimeClassImporter.Create;
  if assigned(FOnExecImport) then
    FOnExecImport(Self, FExec, RI);
  RegisterClassLibraryRuntime(Exec, RI);
  for i := 0 to FPlugins.Count -1 do begin
    TPSPluginItem(FPlugins.Items[i]).Plugin.ExecOnUses(Self);
  end;
  if not FExec.LoadData(Data) then
    raise Exception.Create(GetExecErrorString);
end;

function TPSScript.SetVarToInstance(const VarName: string; cl: TObject): Boolean;
var
  p: PIFVariant;
begin
  p := GetVariable(VarName);
  if p <> nil then
  begin
    SetVariantToClass(p, cl);
    result := true;
  end else result := false;
end;

procedure TPSScript.SetScript(const Value: TStrings);
begin
  FScript.Assign(Value);
end;


function TPSScript.AddMethod(Slf, Ptr: Pointer;
  const Decl: string): Boolean;
begin
  Result := AddMethodEx(Slf, Ptr, Decl, cdRegister);
end;

function TPSScript.AddMethodEx(Slf, Ptr: Pointer; const Decl: string;
  CallingConv: TDelphiCallingConvention): Boolean;
var
  P: TPSRegProc;
begin
  if not FCanAdd then begin Result := False; exit; end;
  p := Comp.AddDelphiFunction(Decl);
  if p <> nil then
  begin
    Exec.RegisterDelphiMethod(Slf, Ptr, p.Name, CallingConv);
    Result := True;
  end else Result := False;
end;

procedure TPSScript.OnLineEvent;
begin
  if @FOnLine <> nil then FOnLine(Self);
end;

function TPSScript.GetRunning: Boolean;
begin
  Result := FExec.Status = isRunning;
end;

function TPSScript.GetExecErrorCol: Cardinal;
var
  s: string;
  D1: Cardinal;
begin
  if not TranslatePositionRC(Exec.ExceptionProcNo, Exec.ExceptionPos, D1, Result, s) then
    Result := 0;
end;

function TPSScript.TranslatePositionPos(Proc, Position: Cardinal;
  var Pos: Cardinal; var fn: string): Boolean;
var
  D1, D2: Cardinal;
begin
  Result := Exec.TranslatePositionEx(Exec.ExceptionProcNo, Exec.ExceptionPos, Pos, D1, D2, fn);
end;

function TPSScript.TranslatePositionRC(Proc, Position: Cardinal;
  var Row, Col: Cardinal; var fn: string): Boolean;
var
  d1: Cardinal;
begin
  Result := Exec.TranslatePositionEx(Proc, Position, d1, Row, Col, fn);
end;


function TPSScript.GetExecErrorRow: Cardinal;
var
  D1: Cardinal;
  s: string;
begin
  if not TranslatePositionRC(Exec.ExceptionProcNo, Exec.ExceptionPos, Result, D1, s) then
    Result := 0;
end;

procedure TPSScript.Stop;
begin
  if FExec.Status = isRunning then
    FExec.Stop
  else
    raise Exception.Create('Not running');
end;

function TPSScript.GetProcMethod(const ProcName: string): TMethod;
begin
  Result := FExec.GetProcAsMethodN(ProcName)
end;

procedure TPSScript.SetMainFileName(const Value: string);
begin
  FMainFileName := Value;
end;

function TPSScript.GetExecErrorFileName: string;
var
  D1, D2: Cardinal;
begin
  if not TranslatePositionRC(Exec.ExceptionProcNo, Exec.ExceptionPos, D1, D2, Result) then
    Result := '';
end;

procedure TPSScript.SetPointerToData(const VarName: string;
  Data: Pointer; aType: TIFTypeRec);
var
  v: PIFVariant;
  t: TPSVariantIFC;
begin
  v := GetVariable(VarName);
  if (Atype = nil) or (v = nil) then raise Exception.Create('Unable to find variable');
  t.Dta := @PPSVariantData(v).Data;
  t.aType := v.FType;
  t.VarParam := false;
  VNSetPointerTo(t, Data, aType);
end;

function TPSScript.AddRegisteredPTRVariable(const VarName,
  VarType: string): Boolean;
var
  FVar: TPSVar;
begin
  if not FCanAdd then begin Result := False; exit; end;
  FVar := FComp.AddUsedVariableN(varname, vartype);
  if fvar = nil then
    result := False
  else begin
    fvar.exportname := fvar.Name;
    fvar.SaveAsPointer := true;
    Result := True;
  end;
end;

procedure TPSScript.SetDefines(const Value: TStrings);
begin
  FDefines.Assign(Value);
end;

function TPSScript.ExecuteFunction(const Params: array of Variant;
  const ProcName: string): Variant;
begin
  Result := Exec.RunProcPN(Params, ProcName);
end;

function TPSScript.FindBaseType(Bt: TPSBaseType): TPSTypeRec;
begin
  Result := Exec.FindType2(Bt);
end;

function TPSScript.FindNamedType(const Name: string): TPSTypeRec;
begin
  Result := Exec.GetTypeNo(Exec.GetType(Name));
end;

procedure TPSScript.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Longint;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (aComponent is TPSPlugin) then
  begin
    for i := Plugins.Count -1 downto 0 do
    begin
      if (Plugins.Items[i] as TPSPluginItem).Plugin = aComponent then
        Plugins.Delete(i);
    end;
  end;
end;

function TPSScript.AddNotificationVariant(const VarName: string): Boolean;
begin
  Result := AddRegisteredVariable(VarName, '!NOTIFICATIONVARIANT');
end;

{ TPSDllPlugin }

procedure TPSDllPlugin.CompOnUses;
begin
  CompExec.Comp.OnExternalProc := DllExternalProc;
end;

procedure TPSDllPlugin.ExecOnUses;
begin
  RegisterDLLRuntime(CompExec.Exec);
end;



{ TPS3DebugCompExec }

procedure LineInfo(Sender: TPSDebugExec; const FileName: string; Position, Row, Col: Cardinal);
var
  Dc: TPSScriptDebugger;
  h, i: Longint;
  bi: TPSBreakPointInfo;
begin
  Dc := Sender.Id;
  if @dc.FOnLineInfo <> nil then dc.FOnLineInfo(dc, FileName, Position, Row, Col);
  if row = dc.FLastRow then exit;
  dc.FLastRow := row;
  h := MakeHash(filename);
  bi := nil;
  for i := DC.FBreakPoints.Count -1 downto 0 do
  begin
    bi := Dc.FBreakpoints[i];
    if (h = bi.FileNameHash) and (FileName = bi.FileName) and (Cardinal(bi.Line) = Row) then
    begin
      Break;
    end;
    Bi := nil;
  end;
  if bi <> nil then
  begin
    if @dc.FOnBreakpoint <> nil then dc.FOnBreakpoint(dc, FileName, Position, Row, Col);
    dc.Pause;
  end;
end;

procedure IdleCall(Sender: TPSDebugExec);
var
  Dc: TPSScriptDebugger;
begin
  Dc := Sender.Id;
  if @dc.FOnIdle <> nil then
    dc.FOnIdle(DC)
  else
    dc.Exec.Run;
end;

procedure TPSScriptDebugger.ClearBreakPoint(const Fn: string; Line: Integer);
var
  h, i: Longint;
  bi: TPSBreakPointInfo;
begin
  h := MakeHash(Fn);
  for i := FBreakPoints.Count -1 downto 0 do
  begin
    bi := FBreakpoints[i];
    if (h = bi.FileNameHash) and (Fn = bi.FileName) and (bi.Line = Line) then
    begin
      FBreakPoints.Delete(i);
      bi.Free;
      Break;
    end;
  end;
end;

procedure TPSScriptDebugger.ClearBreakPoints;
var
  i: Longint;
begin
  for i := FBreakPoints.Count -1 downto 0 do
    TPSBreakPointInfo(FBreakPoints[i]).Free;
  FBreakPoints.Clear;;
end;

constructor TPSScriptDebugger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBreakPoints := TIFList.Create;
  FExec.OnSourceLine := LineInfo;
  FExec.OnIdleCall := IdleCall;
end;

destructor TPSScriptDebugger.Destroy;
var
  i: Longint;
begin
  for i := FBreakPoints.Count -1 downto 0 do
  begin
    TPSBreakPointInfo(FBreakPoints[i]).Free;
  end;
  FBreakPoints.Free;
  inherited Destroy;
end;

function TPSScriptDebugger.GetBreakPoint(I: Integer): TPSBreakPointInfo;
begin
  Result := FBreakPoints[i];
end;

function TPSScriptDebugger.GetBreakPointCount: Longint;
begin
  Result := FBreakPoints.Count;
end;

function TPSScriptDebugger.GetVarContents(const Name: string): string;
var
  i: Longint;
  pv: PIFVariant;
  s1, s: string;
begin
  s := Uppercase(Name);
  if pos('.', s) > 0 then
  begin
    s1 := copy(s,1,pos('.', s) -1);
    delete(s,1,pos('.', Name));
  end else begin
    s1 := s;
    s := '';
  end;
  pv := nil;
  for i := 0 to Exec.CurrentProcVars.Count -1 do
  begin
    if Exec.CurrentProcVars[i] =  s1 then
    begin
      pv := Exec.GetProcVar(i);
      break;
    end;
  end;
  if pv = nil then
  begin
    for i := 0 to Exec.CurrentProcParams.Count -1 do
    begin
      if Exec.CurrentProcParams[i] =  s1 then
      begin
        pv := Exec.GetProcParam(i);
        break;
      end;
    end;
  end;
  if pv = nil then
  begin
    for i := 0 to Exec.GlobalVarNames.Count -1 do
    begin
      if Exec.GlobalVarNames[i] =  s1 then
      begin
        pv := Exec.GetGlobalVar(i);
        break;
      end;
    end;
  end;
  if pv = nil then
    Result := 'Unknown Identifier'
  else
    Result := PSVariantToString(NewTPSVariantIFC(pv, False), s);
end;

function TPSScriptDebugger.HasBreakPoint(const Fn: string; Line: Integer): Boolean;
var
  h, i: Longint;
  bi: TPSBreakPointInfo;
begin
  h := MakeHash(Fn);
  for i := FBreakPoints.Count -1 downto 0 do
  begin
    bi := FBreakpoints[i];
    if (h = bi.FileNameHash) and (Fn = bi.FileName) and (bi.Line = Line) then
    begin
      Result := true;
      exit;
    end;
  end;
  Result := False;
end;

procedure TPSScriptDebugger.Pause;
begin
  if FExec.Status = isRunning then
    FExec.Pause
  else
    raise Exception.Create('Not running');
end;

procedure TPSScriptDebugger.Resume;
begin
  if FExec.Status = isRunning then
    FExec.Run
  else
    raise Exception.Create('Not running');
end;

procedure TPSScriptDebugger.SetBreakPoint(const fn: string; Line: Integer);
var
  i, h: Longint;
  BI: TPSBreakPointInfo;
begin
  h := MakeHash(fn);
  for i := FBreakPoints.Count -1 downto 0 do
  begin
    bi := FBreakpoints[i];
    if (h = bi.FileNameHash) and (fn = bi.FileName) and (bi.Line = Line) then
      exit;
  end;
  bi := TPSBreakPointInfo.Create;
  FBreakPoints.Add(bi);
  bi.FileName := fn;
  bi.Line := Line;
end;

procedure TPSScriptDebugger.SetMainFileName(const Value: string);
var
  OldFn: string;
  h1, h2,i: Longint;
  bi: TPSBreakPointInfo;
begin
  OldFn := FMainFileName;
  inherited SetMainFileName(Value);
  h1 := MakeHash(OldFn);
  h2 := MakeHash(Value);
  if OldFn <> Value then
  begin
    for i := FBreakPoints.Count -1 downto 0 do
    begin
      bi := FBreakPoints[i];
      if (bi.FileNameHash = h1) and (bi.FileName = OldFn) then
      begin
        bi.FFileNameHash := h2;
        bi.FFileName := Value;
      end else if (bi.FileNameHash = h2) and (bi.FileName = Value) then
      begin
        // It's already the new filename, that can't be right, so remove all the breakpoints there
        FBreakPoints.Delete(i);
        bi.Free;
      end;
    end;
  end;
end;

procedure TPSScriptDebugger.StepInto;
begin
  if (FExec.Status = isRunning) or (FExec.Status = isLoaded) then
    FExec.StepInto
  else
    raise Exception.Create('No script');
end;

procedure TPSScriptDebugger.StepOver;
begin
  if (FExec.Status = isRunning) or (FExec.Status = isLoaded) then
    FExec.StepOver
  else
    raise Exception.Create('No script');
end;



{ TPSPluginItem }

function TPSPluginItem.GetDisplayName: string;
begin
  if FPlugin <> nil then
    Result := FPlugin.Name
  else
    Result := '<nil>';
end;

procedure TPSPluginItem.SetPlugin(const Value: TPSPlugin);
begin
  FPlugin := Value;
  If Value <> nil then
    Value.FreeNotification(TPSPlugins(Collection).FCompExec);
  Changed(False);
end;

{ TPSPlugins }

constructor TPSPlugins.Create(CE: TPSScript);
begin
  inherited Create(TPSPluginItem);
  FCompExec := CE;
end;

function TPSPlugins.GetOwner: TPersistent;
begin
  Result := FCompExec;
end;

{ TPSBreakPointInfo }

procedure TPSBreakPointInfo.SetFileName(const Value: string);
begin
  FFileName := Value;
  FFileNameHash := MakeHash(Value);
end;

end.
