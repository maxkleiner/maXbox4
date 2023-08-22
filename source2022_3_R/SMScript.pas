{ Copyright (C) 1998-2002, written by Shkolnik Mike, Scalabium
  E-Mail:  mshkolnik@scalabium.com
           mshkolnik@yahoo.com
  WEB: http://www.scalabium.com
       http://www.geocities.com/mshkolnik
  tel: 380-/44/-552-10-29

  The TSMScript is a wrapper for MS Script Control which allow to
  execute any script for VBScript, JavaScript languages (and any other registred language)

MS ScriptControl:
http://download.microsoft.com/download/winscript56/Install/1.0/W982KMeXP/EN-US/sct10en.exe
must be installed on Win 98, ME and NT 4.0 (in Win 2000 is installed by default)
}
unit SMScript;

interface

uses Classes, ActiveX, variants;

type
  TSMScriptExecutor = class;

  TSMSEError = class
  private
    { Private declarations }
    FScriptExecutor: TSMScriptExecutor;

    FNumber: string;
    FSource: string;
    FDescription: string;
    FText: string;

    FLine: Integer;
    FColumn: Integer;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AScriptExecutor: TSMScriptExecutor);

    procedure Clear;
  published
    { Published declarations }
    property Number: string read FNumber write FNumber;
    property Source: string read FSource write FSource;

    property Description: string read FDescription write FDescription;
    property Text: string read FText write FText;

    property Line: Integer read FLine write FLine;
    property Column: Integer read FColumn write FColumn;
  end;

  TSMSEModule = class;

  {type of procedure: HasReturnValue?}
  TSMSEProcedureType = (ptProcedure, ptFunction);

  {procedure in module}
  TSMSEProcedure = class(TCollectionItem)
  private
    { Private declarations }
    FProcName: string;
    FNumArg: Integer;
    FProcedureType: TSMSEProcedureType;
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property ProcName: string read FProcName write FProcName;
    property NumArg: Integer read FNumArg write FNumArg default 0;
    property ProcedureType: TSMSEProcedureType read FProcedureType write FProcedureType default ptProcedure;
  end;

  {collection of procedures in module}
  TSMSEProcedures = class(TCollection)
  private
    FModule: TSMSEModule;

    function GetProcedure(Index: Integer): TSMSEProcedure;
    procedure SetProcedure(Index: Integer; Value: TSMSEProcedure);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AModule: TSMSEModule);

    property Items[Index: Integer]: TSMSEProcedure read GetProcedure write SetProcedure; default;
  end;

  {module in script}
  TSMSEModule = class(TCollectionItem)
  private
    { Private declarations }
    FModuleName: string;
    FProcedures: TSMSEProcedures;

    function GetProcedures: TSMSEProcedures;
    procedure SetProcedures(Value: TSMSEProcedures);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    procedure AddCode(const Code: string);
    function Eval(const Expression: string): Variant;
    procedure ExecuteStatement(const Statement: string);
    function Run(const ProcedureName: string; Parameters: OLEVariant): OLEVariant;
  published
    { Published declarations }
    property ModuleName: string read FModuleName write FModuleName;
    property Procedures: TSMSEProcedures read GetProcedures write SetProcedures;
  end;

  {module collection}
  TSMSEModules = class(TCollection)
  private
    FScriptExecutor: TSMScriptExecutor;

    function GetModule(Index: Integer): TSMSEModule;
    procedure SetModule(Index: Integer; Value: TSMSEModule);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AScriptExecutor: TSMScriptExecutor);
    function GetModuleByName(const Value: string): TSMSEModule;

    property Items[Index: Integer]: TSMSEModule read GetModule write SetModule; default;
  end;

  TSMScriptLanguage = (slCustom, slVBScript, slJavaScript);
  TSMScriptExecutor = class(TComponent)
  private
    FAllowUI: Boolean;

    FLanguage: TSMScriptLanguage;
    FLanguageStr: string;

    FTimeOut: Integer;

    FScriptPrepared: Boolean;

    FScriptBody: TStrings;
    FUseSafeSubset: Boolean;

    FLastError: TSMSEError;

    FModules: TSMSEModules;

    procedure SetLanguage(Value: TSMScriptLanguage);
    procedure SetLanguageStr(Value: string);

    procedure SetScriptBody(Value: TStrings);
    function GetLastError: TSMSEError;

    function GetModules: TSMSEModules;
    procedure SetModules(Value: TSMSEModules);
  protected
  public
    ScriptControl: Variant;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadScriptFunctions(const ScriptLib: string; list: TStrings; ClearList: Boolean);

    procedure LoadMacro(const FileName: string);

    procedure Prepare;
    procedure ParseModules;

    procedure Reset;
    procedure AddCode(const Code: string);
    function Eval(const Expression: string): Variant;
    procedure ExecuteStatement(const Statement: string);
    function Run(const ProcedureName: string; Parameters: OLEVariant): OLEVariant;
    procedure AddObject(const Name: WideString; const Obj: IDispatch; AddMembers: WordBool);

    property LastError: TSMSEError read GetLastError;
  published
    property AllowUI: Boolean read FAllowUI write FAllowUI default True;

    property Language: TSMScriptLanguage read FLanguage write SetLanguage default slVBScript;
    property LanguageStr: string read FLanguageStr write SetLanguageStr;

    property Modules: TSMSEModules read GetModules write SetModules;
    property TimeOut: Integer read FTimeOut write FTimeOut default -1;
    property UseSafeSubset: Boolean read FUseSafeSubset write FUseSafeSubset default True;
    property ScriptBody: TStrings read FScriptBody write SetScriptBody;
  end;

procedure Register;

implementation
uses ComObj, SysUtils;

//{$R SMScript.DCR}

procedure Register;
begin
  RegisterComponents('SMComponents', [TSMScriptExecutor]);
end;

const
  DefaultModule = 'Global';

{ TSMSEError }
constructor TSMSEError.Create(AScriptExecutor: TSMScriptExecutor);
begin
  inherited Create;

  FScriptExecutor := AScriptExecutor
end;

procedure TSMSEError.Clear;
begin
  FScriptExecutor.ScriptControl.Error.Clear
end;

{ TSMSEProcedure }
procedure TSMSEProcedure.Assign(Source: TPersistent); 
begin
  if Source is TSMSEProcedure then
  begin
    if Assigned(Collection) then
      Collection.BeginUpdate;
    try
      NumArg := TSMSEProcedure(Source).NumArg;
      ProcedureType := TSMSEProcedure(Source).ProcedureType;
    finally
      if Assigned(Collection) then
        Collection.EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;


{ TSMSEProcedures }
constructor TSMSEProcedures.Create(AModule: TSMSEModule);
begin
  inherited Create(TSMSEProcedure);

  FModule := AModule;
end;

function TSMSEProcedures.GetOwner: TPersistent; 
begin
  Result := FModule;
end;

function TSMSEProcedures.GetProcedure(Index: Integer): TSMSEProcedure;
begin
  Result := TSMSEProcedure(inherited Items[Index]);
end;

procedure TSMSEProcedures.SetProcedure(Index: Integer; Value: TSMSEProcedure);
begin
  Items[Index].Assign(Value);
end;


{ TSMSEModule }
constructor TSMSEModule.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FProcedures := TSMSEProcedures.Create(Self);
end;

destructor TSMSEModule.Destroy;
begin
  FProcedures.Free;

  inherited Destroy
end;

procedure TSMSEModule.Assign(Source: TPersistent);
begin
  if Source is TSMSEModule then
  begin
    if Assigned(Collection) then
      Collection.BeginUpdate;
    try
      Procedures := TSMSEModule(Source).Procedures;
    finally
      if Assigned(Collection) then
        Collection.EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;

function TSMSEModule.GetProcedures: TSMSEProcedures;
begin
  Result := FProcedures;
end;

procedure TSMSEModule.SetProcedures(Value: TSMSEProcedures);
begin
  FProcedures.Assign(Value);
end;

procedure TSMSEModule.AddCode(const Code: string);
begin
end;

function TSMSEModule.Eval(const Expression: string): Variant;
begin
end;

procedure TSMSEModule.ExecuteStatement(const Statement: string);
begin
end;

function TSMSEModule.Run(const ProcedureName: string; Parameters: OLEVariant): OLEVariant;
begin
end;


{ TSMSEModules }
constructor TSMSEModules.Create(AScriptExecutor: TSMScriptExecutor);
begin
  inherited Create(TSMSEModule);

  FScriptExecutor := AScriptExecutor
end;

function TSMSEModules.GetOwner: TPersistent;
begin
  Result := FScriptExecutor
end;

function TSMSEModules.GetModule(Index: Integer): TSMSEModule;
begin
  Result := TSMSEModule(inherited Items[Index]);
end;

procedure TSMSEModules.SetModule(Index: Integer; Value: TSMSEModule);
begin
  Items[Index].Assign(Value);
end;

function TSMSEModules.GetModuleByName(const Value: string): TSMSEModule;
var
  i: Integer;
begin
  i := FScriptExecutor.ScriptControl.Modules[Value].Index;
  Result := Items[i]
end;


{ TSMScriptExecutor }
constructor TSMScriptExecutor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FModules := TSMSEModules.Create(Self);

  FScriptBody := TStringList.Create;
  FScriptPrepared := True;

  Language := slVBScript;

  AllowUI := True;
  UseSafeSubset := True;
end;

destructor TSMScriptExecutor.Destroy;
begin
//  ScriptControl.Reset;
  ScriptControl := UnAssigned;

  FScriptBody.Free;
  FModules.Free;

  if Assigned(FLastError) then
    FLastError.Free;

  inherited Destroy;
end;

const
  arrScriptLanguage: array [TSMScriptLanguage] of string =
       ('', 'VBSCRIPT', 'JAVASCRIPT');

procedure TSMScriptExecutor.SetLanguage(Value: TSMScriptLanguage);
begin
  if (FLanguage <> Value) then
  begin
    FLanguage := Value;
    FLanguageStr := arrScriptLanguage[Value]
  end;
end;

procedure TSMScriptExecutor.SetLanguageStr(Value: string);
var
  strUpperValue: string;
begin
  if (FLanguageStr <> Value) then
  begin
    FLanguageStr := Value;
    strUpperValue := UpperCase(Value);
    if (strUpperValue = arrScriptLanguage[slVBScript]) then
      FLanguage := slVBScript
    else
    if (strUpperValue = arrScriptLanguage[slJavaScript]) then
      FLanguage := slJavaScript
    else
      FLanguage := slCustom;
  end;
end;

procedure TSMScriptExecutor.SetScriptBody(Value: TStrings);
begin
  FScriptBody.Assign(Value);
  FScriptPrepared := False;
end;

procedure TSMScriptExecutor.LoadMacro(const FileName: string);
begin
  ScriptBody.LoadFromFile(FileName)
end;

function TSMScriptExecutor.GetModules: TSMSEModules;
begin
  Result := FModules;
end;

procedure TSMScriptExecutor.SetModules(Value: TSMSEModules);
begin
  FModules.Assign(Value);
end;

function TSMScriptExecutor.GetLastError: TSMSEError;
begin
  if not Assigned(FLastError) then
    FLastError := TSMSEError.Create(Self);

  FLastError.Number := '';
  FLastError.Source := '';
  FLastError.Description := '';
  FLastError.Text := '';
  FLastError.Line := -1;
  FLastError.Column := -1;
  try
    if not VarIsEmpty(ScriptControl) and not VarIsEmpty(ScriptControl.Error) then
    begin
      FLastError.Number := ScriptControl.Error.Number;
      FLastError.Source := ScriptControl.Error.Source;
      FLastError.Description := ScriptControl.Error.Description;
      FLastError.Text := ScriptControl.Error.Text;
      FLastError.Line := ScriptControl.Error.Line;
      FLastError.Column := ScriptControl.Error.Column;
    end;
  except
  end;
  Result := FLastError;
end;

procedure TSMScriptExecutor.Prepare;
begin
  if VarIsNull(ScriptControl) or
     VarIsEmpty(ScriptControl) then
  begin
    ScriptControl := CreateOleObject('MSScriptControl.ScriptControl');
  end;

  if (FLanguage = slCustom) then
    ScriptControl.Language := FLanguageStr
  else
    ScriptControl.Language := arrScriptLanguage[FLanguage];
  ScriptControl.AllowUI := AllowUI;
  ScriptControl.UseSafeSubset := UseSafeSubset;
  {set the maximum run time allowed
   PS: -1 stands for unlimited }
  ScriptControl.TimeOut := FTimeOut;

  Reset;

  FScriptPrepared := True;
end;

procedure TSMScriptExecutor.ParseModules;
var
  i, j: Integer;
begin
  {build module and parameter lists}
//  if (ScriptBody.Count > 0) then
//    AddCode(ScriptBody.Text);

  {clear current list of modules}
  Modules.Clear;

  {load a list of modules in current script}
  for i := 1 to ScriptControl.Modules.Count do
  begin
    with (Modules.Add as TSMSEModule) do
    begin
      ModuleName := ScriptControl.Modules.Item[i].Name;

      for j := 1 to ScriptControl.Modules.Item[i].Procedures.Count do
      begin
        with (Procedures.Add as TSMSEProcedure) do
        begin
          { name of subroutine }
          ProcName := ScriptControl.Modules.Item[i].Procedures.Item[j].Name;

          { total number of argument, if any }
          NumArg := ScriptControl.Modules.Item[i].Procedures.Item[j].NumArgs;

          { type of routine }
          if ScriptControl.Modules.Item[i].Procedures.Item[j].HasReturnValue then
            ProcedureType := ptFunction
          else
            ProcedureType := ptProcedure
        end;
      end;
    end;
  end;
end;

{clear a cache from previos executed script}
procedure TSMScriptExecutor.Reset;
begin
  ScriptControl.Reset;
end;

{load a script body}
procedure TSMScriptExecutor.AddCode(const Code: string);
begin
  Prepare;

  ScriptControl.Modules.Item[DefaultModule].AddCode(Code{ScriptBody.Text});
//  ParseModules;
end;

{execute a statement within the context of the global module

Sample:
ScriptBody.Text := 'Sub HelloWorld(str)'+
                   '  MsgBox str & " - , Hello from the large world of scripts"'+
                   'End Sub'
SMScriptExecutor.ExecuteStatement('Call Hello("Scalabium TSMScriptExecutor")');
or define a variable:
SMScriptExecutor.ExecuteStatement('str = "Scalabium TSMScriptExecutor"');
}
procedure TSMScriptExecutor.ExecuteStatement(const Statement: string);
begin
  Prepare;

  {Execute it as a direct statement}
  ScriptControl.ExecuteStatement(Statement);
end;

{evaluate an expression within the context of the global module

Sample:
1. check a value of variable:
bool := SMScriptExecutor.Eval('x = 50');

2. return a variable value:
int := SMScriptExecutor.Eval('x');
}
function TSMScriptExecutor.Eval(const Expression: string): Variant;
begin
  Prepare;

  Result := ScriptControl.Eval(Expression);
end;

{run a procedure defined in the global module}
function TSMScriptExecutor.Run(const ProcedureName: string; Parameters: OLEVariant): OLEVariant;
begin
//  if not FScriptPrepared then
//    Prepare;
//    ParseModules;

  if VarIsEmpty(Parameters) then
    ScriptControl.Modules.Item[DefaultModule].Run(ProcedureName)
  else
    ScriptControl.Modules.Item[DefaultModule].Run(ProcedureName, Parameters);
end;

{add to script engine some COM-object which will be "visible" from script}
procedure TSMScriptExecutor.AddObject(const Name: WideString; const Obj: IDispatch; AddMembers: WordBool);
begin
  ScriptControl.Modules.Item[DefaultModule].AddObject(Name, Obj, AddMembers);
end;

procedure TSMScriptExecutor.LoadScriptFunctions(const ScriptLib: string; list: TStrings; ClearList: Boolean);

  procedure LoadInterface(TypeInfo: ITypeInfo; TypeAttr: PTypeAttr);
  var
    AName: WideString;
    ADocString: WideString;
    AHelpContext: LongInt;
    FuncDesc: PFuncDesc;
    i, j: Integer;
    Names: PBStrList;
    cNames: Integer;

    strItem: string;
  begin
    TypeInfo.GetDocumentation(-1, @AName, @ADocString, @AHelpContext, nil);

    New(Names);
    try
      // load functions
      for i := 0 to TypeAttr.cFuncs - 1 do
      begin
        TypeInfo.GetFuncDesc(i, FuncDesc);
        try
          TypeInfo.GetDocumentation(FuncDesc.memid, @AName, @ADocString, @AHelpContext, nil);

          strItem := AName;
          if FuncDesc.cParams > 0 then
          begin
            strItem := strItem + '(';
            // load parameters
            TypeInfo.GetNames(FuncDesc.memid, Names, SizeOf(TBStrList), cNames);

            // Skip Names[0] - it's the function name
            for j := 1 to FuncDesc.cParams do
              if j < 2 then
                strItem := strItem + Names[j]
              else
                strItem := strItem + ', ' + Names[j];
            strItem := strItem + ')';
          end;
          if (ADocString <> '') then
            strItem := strItem + #9 + ADocString;
          list.Add(strItem);
        finally
          TypeInfo.ReleaseFuncDesc(FuncDesc);
        end;
      end;
    finally
      Dispose(Names);
    end;
  end;

var
  FLib: ITypeLib;
  TypeInfo: ITypeInfo;
  TypeAttr: PTypeAttr;
  i: Integer;
begin
  if ClearList then
    list.Clear;

  {load a library}
  OleCheck(LoadTypeLib(PWideChar(WideString(ScriptLib)), FLib));

  for i := 0 to FLib.GetTypeInfoCount - 1 do
  begin
    FLib.GetTypeInfo(i, TypeInfo);
    OleCheck(TypeInfo.GetTypeAttr(TypeAttr));
    try
      if (TypeAttr.typeKind in [TKIND_DISPATCH, TKIND_INTERFACE]) then
        LoadInterface(TypeInfo, TypeAttr);
    finally
      TypeInfo.ReleaseTypeAttr(TypeAttr);
    end;
  end;
end;

end.
