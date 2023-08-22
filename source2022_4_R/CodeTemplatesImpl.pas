unit CodeTemplatesImpl;

interface
uses
  ToolsAPI;
  
type
  TCodeTemplate = record
    Key, Description, IDString, Template: string;
  end;

  ICodeTemplates = interface
    function GetCount: Integer;
    function GetItem(const Index: Integer): TCodeTemplate;
    function GetItemKey(const Key: string): TCodeTemplate;
    function Exists(const Key: string; out Index: Integer): Boolean; overload;
    function Exists(const Key: string): Boolean; overload;
    property Item[const Index: Integer]: TCodeTemplate read GetItem; default;
    property Count: Integer read GetCount;
  end;

  TCodeTemplates = class(TInterfacedObject, ICodeTemplates)
  protected
    FCodeTemplates: array of TCodeTemplate;
    function GetItem(const Index: Integer): TCodeTemplate;
    function GetCount: Integer;
    function GetItemKey(const Key: string): TCodeTemplate;
    function Exists(const Key: string): Boolean; overload;
    function Exists(const Key: string; out Index: Integer): Boolean; overload;
  public
    constructor Create(const ACodeTemplatePath: string);
  end;

implementation
uses
  DeclParserIntf, Classes, SysUtils;

{ TCodeTemplates }

constructor TCodeTemplates.Create(const ACodeTemplatePath: string);
var
  Parser: RegExp;
  FS: TFileStream; SS: TStringStream;
  Template, Data: string;
  MC: IMatchCollection2;
  Match, NextMatch: IMatch2;
  Submatches: ISubMatches;
  I, StartPos, Len: Integer;
begin
  FS := TFileStream.Create(ACodeTemplatePath, fmOpenRead);
  SS := TStringStream.Create('');
  SS.CopyFrom(FS, 0);
  Data := SS.DataString;
  FS.Free;
  SS.Free;

  Parser := CoRegExp.Create;
  Parser.Pattern := '('+
  '^\[(.*)? \| (.*)? \| (.*)?\]'+
  ')+';
  Parser.Global := True;
  Parser.Multiline := True;
  MC := Parser.Execute(Data) as IMatchCollection2;
  SetLength(FCodeTemplates, MC.Count);
  for I := 0 to MC.Count-1 do
    begin
      Match := MC.Item[I] as IMatch2;

      StartPos := Match.FirstIndex+1+Length(Match.Value);
      if I+1<=MC.Count-1 then
        begin
          NextMatch := MC.Item[I+1] as IMatch2;
          Len := NextMatch.FirstIndex+1-StartPos;
        end else
        begin
          Len := Length(Data);
        end;
      Template := Copy(Data, StartPos+2, Len-4);

      Submatches := Match.SubMatches as ISubMatches;
      FCodeTemplates[I].Key := Submatches[1];
      FCodeTemplates[I].Description := Submatches[2];
      FCodeTemplates[I].IDString := Submatches[3];
      FCodeTemplates[I].Template := Template;
    end;
end;

function TCodeTemplates.Exists(const Key: string): Boolean;
var
  I: Integer;
begin
  Result := Exists(Key, I);
end;

function TCodeTemplates.Exists(const Key: string; out Index: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := Low(FCodeTemplates) to High(FCodeTemplates) do
    if Key = FCodeTemplates[I].Key then
      begin
        Index := I;
        Result := True;
        Break;
      end;
end;

function TCodeTemplates.GetCount: Integer;
begin
  Result := Length(FCodeTemplates);
end;

function TCodeTemplates.GetItem(const Index: Integer): TCodeTemplate;
begin
  Result := FCodeTemplates[Index];
end;

function TCodeTemplates.GetItemKey(const Key: string): TCodeTemplate;
var
  I: Integer;
begin
  for I := Low(FCodeTemplates) to High(FCodeTemplates) do
    if Key = FCodeTemplates[I].Key then
      begin
        Result := FCodeTemplates[I];
        Break;
      end;
end;

end.
