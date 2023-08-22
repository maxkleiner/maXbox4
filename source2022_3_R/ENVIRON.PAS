unit Environ;

interface

uses SysUtils, WinProcs, DesignIntf, {DesignEditors}TypInfo,Classes;

type
  TEnvironment = class(TComponent)
  private
    FValues: TStringList;
    FKey   : Integer;
    FValue : String;
    function  GetCount : integer;
    function  GetValue(const Name: string): string;
    procedure SetKey(V : integer);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    Function GetKeyName(I: Integer) : string;
    property Count: integer read GetCount;
    property Values[const Name: string]: string Read GetValue;
  published
    property Value: string read FValue write FValue;
    property Key  : integer read Fkey Write SetKey;
  end;

 { TValueProperty = Class(TStringProperty)
    Function GetAttributes: TPropertyAttributes; override;
  end;
  }
 { TKeyProperty = Class(TIntegerProperty)
    Function  GetAttributes: TPropertyAttributes; override;
    Procedure GetValues(Proc : TGetStrProc); override;
    Function  GetValue : string; override;
    Procedure  SetValue(const Value : string); override;
  end;
  }
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('IQProbe', [TEnvironment]);
  //RegisterPropertyEditor(TypeInfo(String), TEnvironment, 'Value', TValueProperty);
  //RegisterPropertyEditor(TypeInfo(Integer), TEnvironment, 'Key',   TKeyProperty);
end;

function TEnvironment.GetKeyName(I : integer):  String;
begin
  Result := FValues.Names[I];
end;

procedure TEnvironment.SetKey(V : integer);
var S : string;
begin
  if V <> FKey then
   begin
     FKey := V;
     S := FValues.Names[V];
     FValue := FValues.Values[S];
   end;
end;


{function TValueProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paReadOnly];
end;

function TKeyProperty.GetValue : String;
begin
  Result := TEnvironment(GetComponent(0)).GetKeyName(GetOrdValue);
end;

function TKeyProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

Procedure TKeyProperty.GetValues(Proc : TGetStrProc);
var I : Integer;
begin
  For I := 0 to TEnvironment(GetComponent(0)).Count-1 do
    Proc(TEnvironment(GetComponent(0)).GetKeyName(I));
end;

Procedure TKeyProperty.SetValue(const Value : string);
var
  I: Integer;
begin
  if (Value <> '') then
    for I :=  0 to TEnvironment(GetComponent(0)).Count-1 do
      if CompareText(TEnvironment(GetComponent(0)).GetKeyName(I), Value) = 0 then
      begin
        SetOrdValue(I);
        Exit;
      end;
  inherited SetValue(Value);
end;     }

constructor TEnvironment.Create(AOwner : TComponent);
var
  EnvStrings: PChar;
  S: string;

begin
  inherited Create(AOwner);
  FValues := TStringList.Create;
  EnvStrings := GetEnvironmentStrings;
  FKey := 0;
  while EnvStrings[0] <> #0 do
    begin
      S := StrPas(EnvStrings);
      FValues.Add(S);
      Inc(EnvStrings,StrLen(EnvStrings)+1);
    end;
   FValue := FValues.Values[FValues.Names[0]];
end;

function TEnvironment.GetCount : integer;
begin
  Result := FValues.Count;
end;

function TEnvironment.GetValue(const Name: string): string;
begin
  Result := FValues.Values[Name];
end;

destructor TEnvironment.Destroy;
begin
  FValues.Free;
  Inherited Destroy;
end;     //}

end.
