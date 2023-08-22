
/////////////////////////////////////////////////////////
//                                                     //
//              Bold for Delphi                        //
//    Copyright (c) 1996-2002 Boldsoft AB              //
//              (c) 2002-2005 Borland Software Corp    //
//                                                     //
/////////////////////////////////////////////////////////


unit BoldGeneratorTemplatesCPP;

interface

uses
  Classes,
  BoldMeta,
  BoldGeneratorTemplates,
  BoldTemplateExpander;

type
  { TBoldGeneratorTemplateCPPDM }
  TBoldGeneratorTemplateCPPDM = class(TDataModule)
    UnitTemplate: TBoldTemplateHolder;
    InterfaceTemplate: TBoldTemplateHolder;
    MethodTemplate: TBoldTemplateHolder;
    DeriveAndSubscribeTemplate: TBoldTemplateHolder;
    IncFileHeaderTemplate: TBoldTemplateHolder;
    ReverseDeriveTemplate: TBoldTemplateHolder;
    ComAdaptersImplTemplate: TBoldTemplateHolder;
    IDLTemplate: TBoldTemplateHolder;
    ComAdaptersHdrTemplate: TBoldTemplateHolder;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  { TBoldCPPTemplateManager }
  TBoldCPPTemplateManager = class(TBoldGeneratorTemplateManager)
  private
    fDataModule: TBoldGeneratorTemplateCPPDM;
    function GetDataModule: TBoldGeneratorTemplateCPPDM;
    function GetCPPSignature(MoldMethod: TMoldMethod): String;
    function EnsureSafeIDLType(const ParamType: String; MoldClass: TMoldClass): String;
  protected
    function GetDerivedMethodTemplate: TBoldTemplateHolder; override;
    function GetReverseDeriveMethodTemplate: TBoldTemplateHolder; override;
    function GetMethodTemplate: TBoldTemplateHolder; override;
    function GetIncFileHeaderTemplate: TBoldTemplateHolder; override;
    procedure InitializeTemplateList(TemplateList: TBoldTemplateList); override;
    procedure InitializeCOMTemplateList(TemplateList: TBoldTemplateList); override;
    function GetDefaultIncFileExtension: string; override;
    property DataModule: TBoldGeneratorTemplateCPPDM read GetDataModule;
  public
    destructor Destroy; override;
    function MethodToCOMHeader(OwningClass: TMoldClass; Method: TMoldMethod; InterfaceCode: Boolean; ParametersToCoerce: TStringList; ParametersToInterfaceCoerce: TStringList; MoldModel: TMoldModel; GenerateMIDLCode: Boolean): String; override;
    function MethodToCOMCall(OwningClass: TMoldClass; Method: TMoldMethod; ParametersToCoerce, ParametersToInterfaceCoerce: TStringList; MoldModel: TMoldModel): String; override;
    function ReadMethodSignature(ClassName, AttributeName, AttributeType: string): string; override;
    function WriteMethodSignature(ClassName, AttributeName, AttributeType: string): string; override;
    function MethodToCodeHeader(OwningClass: TMoldClass; Method: TMoldMethod; TagValue: Integer; AddSignature: Boolean; AutoOverride: Boolean): String; override;
    function StringContainsMethodHeader(s: String): Boolean; override;
    function GetSearchStringfromMethodHeader(header: String; SearchParameterList: Boolean): String; override;
    procedure AddQualifierPropertyParam(var Params: String; ParamName, ParamType: String); override;
    procedure AddQualifierFunctionParam(var Params: String; ParamName, ParamType: String); override;
    function GenerateInheritedCall(MoldClass: TMoldClass; MoldMethod: TMoldMethod): String; override;
    class procedure InstallCPPTemplates;
  end;


implementation

uses
  SysUtils,
  BoldRev,
  BoldUMLTypes,
  BoldTaggedValueSupport,
  BoldMetaSupport;

{$R *.dfm}

{ TBoldCPPTemplateManager }

destructor TBoldCPPTemplateManager.Destroy;
begin
  FreeAndNil(fDataModule);
  inherited;
end;

function TBoldCPPTemplateManager.GetDataModule: TBoldGeneratorTemplateCPPDM;
begin
  if not assigned(fDataModule) then
    fDataModule := TBoldGeneratorTemplateCPPDM.Create(nil);
  result := fDataModule;
end;

function TBoldCPPTemplateManager.GetDerivedMethodTemplate: TBoldTemplateHolder;
begin
  result := DataModule.DeriveAndSubscribeTemplate;
end;

function TBoldCPPTemplateManager.GetIncFileHeaderTemplate: TBoldTemplateHolder;
begin
  result := DataModule.IncFileHeaderTemplate;
end;

function TBoldCPPTemplateManager.GetMethodTemplate: TBoldTemplateHolder;
begin
  result := DataModule.MethodTemplate;
end;

function TBoldCPPTemplateManager.GetReverseDeriveMethodTemplate: TBoldTemplateHolder;
begin
  Result := DataModule.ReverseDeriveTemplate;
end;

procedure TBoldCPPTemplateManager.InitializeTemplateList(TemplateList: TBoldTemplateList);
begin
  if TemplateList.Count = 0 then
  begin
    TemplateList.Add(DataModule.UnitTemplate);
    TemplateList.Add(DataModule.InterfaceTemplate);
  end;

end;

procedure TBoldCPPTemplateManager.InitializeCOMTemplateList(TemplateList: TBoldTemplateList);
begin
  if TemplateList.Count = 0 then
  begin
    TemplateList.Add(DataModule.IDLTemplate);
    TemplateList.Add(DataModule.ComAdaptersIMPLTemplate);
    TemplateList.Add(DataModule.ComAdaptersHDRTemplate);
  end;
end;

class procedure TBoldCPPTemplateManager.InstallCPPTemplates;
begin
  BoldGeneratorTemplateManagerClass := TBoldCPPTemplateManager;
end;

function TBoldCPPTemplateManager.EnsureSafeIDLType(const ParamType: String;
  MoldClass: TMoldClass): String;
var
  i: integer;
begin
  for i := 0 to MoldClass.Model.Classes.Count - 1 do
  begin
    if CompareText(ParamType, MoldClass.Model.Classes[i].ExpandedInterfaceName) = 0 then
    begin
      result := MoldClass.LowestCommonSuperClass(MoldClass.Model.Classes[i]).ExpandedInterfaceName;
      exit;
    end;
  end;
  result := ParamType;
end;

function TBoldCPPTemplateManager.MethodToCOMHeader(OwningClass: TMoldClass; Method: TMoldMethod; InterfaceCode: Boolean; ParametersToCoerce: TStringList; ParametersToInterfaceCoerce: TStringList; MoldModel: TMoldModel; GenerateMIDLCode: Boolean): String;
var
  i: integer;
  IsConst: Boolean;
  s,
  params,
  CheckInterface,
  ParamType: String;
  Param: TMoldParameter;
begin
  s := '';

  if Method.HasReturnValue then
  begin
    ParamType := TBoldMetaSupport.ParameterTypeToComType(Method.returnType, MoldModel, IsConst);
    if not GenerateMIDLCode then
      ParamType := EnsureSafeIDLType(ParamType, Method.MoldClass);

    s := s + ParamType + ' ';
  end
  else
    s := s + 'void '; // do not localize

//  if InterfaceCode then
    s := s + '__safecall '; // do not localize
//  else
//    s := s + '__fastcall '; // do not localize

  if not InterfaceCode then
    s := s + OwningClass.ExpandedDelphiName + 'Adapter::'; // do not localize

  s := s + Method.ExpandedDelphiName;

  params := '';
  for i := 0 to Method.Parameters.Count - 1 do
  begin
    if Params <> '' then
      params := params + ', ';

    Param := tMoldParameter(Method.Parameters[i]);
    ParamType := TBoldMetaSupport.ParameterTypeToComType(Param.ParameterType, MoldModel, IsConst);

    if assigned(MoldModel.Classes.ItemsByName[Param.ParameterType]) or assigned(MoldModel.Classes.ItemsByDelphiName[Param.ParameterType]) then
      ParamType := ParamType + '*';

    if not GenerateMIDLCode then
      ParamType := EnsureSafeIDLType(ParamType, Method.MoldClass);

    if param.ParameterKind in [pdOut, pdInout] then
    begin
      // ISJE params := params + 'var ';
      if assigned(ParametersToCoerce) and
        ((ParamType = BoldWideStringTypeName) or
         (ParamType = BoldWordBoolTypeName)) then
        ParametersToCoerce.Add(Param.ParameterName + '=' + Param.DelphiParameterType);

      if assigned(ParametersToInterfaceCoerce) then
      begin
        CheckInterface := TBoldMetaSupport.ParameterTypeToInterfaceType(Param.ParameterType, MoldModel);

        if (CheckInterface <> '') then
          ParametersToInterfaceCoerce.Add(Param.ParameterName + '=' + Param.DelphiParameterType + '=' + CheckInterface);
      end;

    end
    else if IsConst then
      Params := Params + 'const '; // do not localize
    Params := Params + ParamType + ' ' + Param.ParameterName;
  end;

  if Params <> '' then
    s := s+ '(' + Params + ')'
  else
    s := s + '()';

  result := s;
end;

function TBoldCPPTemplateManager.MethodToCOMCall(OwningClass: TMoldClass; Method: TMoldMethod; ParametersToCoerce, ParametersToInterfaceCoerce: TStringList; MoldModel: TMoldModel): String;
var
  i: integer;
  s: string;
  params: string;
  Interfacename: String;
  Param: TMoldParameter;

  function ParameterNeedsMarshalling(const ParameterType: String; var InterfaceName: string): Boolean;
  begin
    InterfaceName := TBoldMetaSupport.ParameterTypeToInterfaceType(ParameterType, MoldModel);
    Result := InterfaceName <> '';
  end;

begin
  s := 'As' + OwningClass.ExpandedExpressionName + '->' + Method.ExpandedDelphiName; // do not localize

  params := '';
  for i := 0 to Method.Parameters.Count - 1 do
  begin
    if Params <> '' then
      params := params + ', ';
    Param := tMoldParameter(Method.Parameters[i]);
    if ParametersToInterfaceCoerce.IndexOfName(Param.ParameterName)  <> -1 then
      params := params + param.ParameterName + '_temp' // do not localize
    else if ParameterNeedsMarshalling(Param.ParameterType, InterfaceName) then
      Params := Params + '((' + Param.DelphiParameterType + '*)' + '(BoldComInterfaceToObject(' + Param.ParameterName + ')))' // do not localize
    else if parametersToCoerce.IndexOfName(param.ParameterName) <> -1 then
      params := params + param.ParameterName + '_temp' // do not localize
    else
      Params := params + Param.ParameterName;
  end;

  s := s + '(' + Params + ')';

  if Method.HasReturnValue then
  begin
    if ParameterNeedsMarshalling(Trim(method.ReturnType), InterfaceName) then
      s := 'BoldComCreateAdapter(' + s + ', False, ' + '__uuidof(' + Interfacename + '), Result)' // do not localize
    else
      s := 'result := ' + s; // do not localize
  end;
  result := s + ';';
end;

function TBoldCPPTemplateManager.MethodToCodeHeader(
  OwningClass: TMoldClass; Method: TMoldMethod; TagValue: Integer;
  AddSignature, AutoOverride: Boolean): String;
var
  s: string;
  Signature: String;
begin
  s := '';

  if (TagValue in [publicTag..PrivateTag]) and Method.IsClassMethod then
    s := s + 'static '; // do not localize

  if (TagValue in [publicTag..PrivateTag]) and
      (Autooverride or
       (Method.FuncType in [dfvirtual]) or
       method.OverrideInAllSubclasses) then
  begin
    s := s + 'virtual '; // do not localize
  end;

  if Method.HasReturnValue then
    s := s + Method.DelphiReturnType+' '
  else
    s := s + 'void '; // do not localize

  s := s + '__fastcall '; // do not localize

  if TagValue = ImplementationTag then
    s := s + OwningClass.ExpandedDelphiName + '::';
  s := s + Method.ExpandedDelphiName;

  if addSignature then
  begin
    Signature := GetCPPSignature(Method);
    if Signature <> '' then
      s := s + '(' + Signature + ')'
    else
      s := s + '(void)'; // do not localize
  end;

  if Method.FuncType = dfAbstractVirtual then
    s := s + ' = 0'; // do not localize

  result := s;
end;

function TBoldCPPTemplateManager.GetCPPSignature(MoldMethod: TMoldMethod): String;
var
  i: integer;
  Parameter: TMoldParameter;
  function AdaptCPPParameterType(ParamType: String): String;
  begin
    if assigned(MoldMethod.MoldClass.Model.Classes.ItemsByDelphiName[ParamType]) then
      result := ParamType + '*'
    else
      result := ParamType;
  end;
begin
  result := '';
  for i := 0 to MoldMethod.parameters.count-1 do
  begin
    parameter := MoldMethod.Parameters[i] as TMoldParameter;

    if result <> '' then
      result := result + ', ';

{    if Parameter.IsConst then
      Result := Result + 'const ' // do not localize
    else if Parameter.ParameterKind = pdInOut then
      Result := Result + 'var ' // do not localize
    else if Parameter.ParameterKind = pdOut then
      Result := Result + 'out '; // do not localize
}

    result := result + format('%s %s', [ // do not localize
      AdaptCPPParameterType(Parameter.DelphiParameterType),
      Parameter.ParameterName]);
  end;
end;

function TBoldCPPTemplateManager.GetDefaultIncFileExtension: string;
begin
  result := '_impl.cpp'; // do not localize
end;

function TBoldCPPTemplateManager.StringContainsMethodHeader(s: String): Boolean;
begin
  result := pos('::', s) <> 0;
end;

procedure TBoldCPPTemplateManager.AddQualifierPropertyParam(var Params: String; ParamName, ParamType: String);
begin
  if Params <> '' then
    Params := Params + '][';
  Params := Params + ParamType + ' ' + ParamName;
end;

procedure TBoldCPPTemplateManager.AddQualifierFunctionParam(var Params: String; ParamName, ParamType: String);
begin
  if Params <> '' then
    Params := Params + ', ';
  Params := Params + ParamType + ' ' + ParamName;
end;

function TBoldCPPTemplateManager.GetSearchStringfromMethodHeader(header: String; SearchParameterList: Boolean): String;
begin
  result := header;
  if not SearchParameterList and (pos('(', result) <> 0) then
    result := copy(result, 1, pos('(', result) - 1);
end;

function TBoldCPPTemplateManager.GenerateInheritedCall(
  MoldClass: TMoldClass; MoldMethod: TMoldMethod): String;
begin
  result := '';
  if MoldMethod.HasReturnValue then
    result := 'return '; // do not localize
  if assigned(MoldClass.SuperClass) then
    result := result + MoldClass.SuperClass.ExpandedDelphiName
  else
    result := result + 'TBoldObject'; // do not localize

  result := result + format('::%s(%s)', [Moldmethod.Name, MoldMethod.CallSignature]); // do not localize
end;

function TBoldCPPTemplateManager.ReadMethodSignature(ClassName, AttributeName, AttributeType: string): string;
begin
  result := format('%s __fastcall %s::Get%s()', [AttributeType, ClassName, AttributeName]); // do not localize
end;

function TBoldCPPTemplateManager.WriteMethodSignature(ClassName, AttributeName, AttributeType: string): string;
begin
  result := format('void __fastcall %s::Set%s(%s NewValue)', [ClassName, AttributeName, AttributeType]); // do not localize
end;

initialization
  {$IFDEF BOLD_BCB}
  TBoldCPPTemplateManager.InstallCPPTemplates;
  {$ENDIF}
end.
