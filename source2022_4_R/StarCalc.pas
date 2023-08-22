unit StarCalc;

interface

uses
  SysUtils, Classes, DB {$ifndef ver130}, Variants {$endif};

type
  TStarCalcExport = class(TComponent)
  private
    { Private declarations }
    FOffice,
    FDesktop,
    FDocument,
    FCoreReflection,
    FSheet : OleVariant;
    FFileName: String;
    FDataset: TDataset;
    FCloseOffice: Boolean;
    FIncludeFieldnames: boolean;
    FColumn: Byte;
    FExcludeFields: TStrings;
    FIncludeFields: TStrings;
    FRow: Word;
    FTemplateFileName: String;
    procedure SetDataset(const Value: TDataset);
    Procedure CreateDeskTop;
    procedure SetExcludeFields(const Value: TStrings);
    procedure SetIncludeFields(const Value: TStrings);
    procedure GetFieldList(L: TStrings);
    procedure SaveSpreadSheet(const AFileName: String);
  protected
    { Protected declarations }
    Procedure CreatePropertyValue(Var PropertyValue : Variant; APropertyName : String);
    Procedure Error(Msg  : String);
    procedure CheckConnect;
    procedure CheckDesktop;
    procedure CheckDocument;
    Procedure Connect;
    Procedure FillCells; Virtual;
    Procedure LoadSpreadSheet(Const AFileName : String); virtual;
    Procedure CreateSheet(Const SheetName : String); virtual;
  public
    Constructor Create(Aowner : TComponent); override;
    Destructor Destroy; override;
    { Public declarations }
    Procedure Execute;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    Property FileName : String Read FFileName Write FFileName;
    Property TemplateFileName : String Read FTemplateFileName Write FTemplateFileName;
    Property Dataset : TDataset Read FDataset Write SetDataset;
    Property Column : Byte Read FColumn Write FColumn;
    Property Row : Word Read FRow Write FRow;
    Property CloseStarCalc : Boolean Read FCloseOffice Write FCloseOffice;
    property ExcludeFields : TStrings read FExcludeFields write SetExcludeFields;
    property IncludeFields : TStrings read FIncludeFields write SetIncludeFields;
    property IncludeFieldnames : boolean read FIncludeFieldnames write FIncludeFieldnames;
    { Published declarations }
  end;

  EStarCalc = Class(Exception);

procedure Register;

implementation

uses comobj;

procedure Register;
begin
//  RegisterComponents('Samples', [TStarCalc]);
end;

Resourcestring
  SErrNoConnect = 'Could not connect to OpenOffice!';
  SErrFailedToOpenDocument = 'Failed to open spreadsheet document';
  SErrFailedToCreateDocument = 'Failed to create spreadsheet document';
  SErrNoDataset = 'No dataset assigned.';
  SErrNoDocument = 'An active document is needed to complete this operation.';
  SErrCouldNotCreateSheet = 'Could not create spreadsheet "%s".';

{ TStarCalc }

procedure TStarCalcExport.Connect;
begin
  if VarIsEmpty(FOffice) then
        FOffice := CreateOleObject('com.sun.star.ServiceManager');
  if (VarIsEmpty(FOffice) or VarIsNull(FOffice)) then
    Error(SErrNoConnect);
end;

procedure TStarCalcExport.CreateSheet(Const SheetName: String);

Var
  Sheets : Variant;
  SN : String;

begin
  CheckDocument;
  Sheets:=FDocument.getSheets;
  SN:=SheetName;
  If (SN='') then
    SN:='Sheet1';
  FSheet:=Sheets.getByName(SN);
  If VarIsEmpty(FSheet) or VarIsNull(FSheet) then
    begin
    Sheets.insertNewByName(SN, 0);
    FSheet:=Sheets.getByName(SN);
    If VarIsEmpty(FSheet) or VarIsNull(FSheet) then
      Error(Format(SErrCouldNotCreateSheet,[SN]));
    end;
end;

procedure TStarCalcExport.Error(Msg: String);
begin
  Raise EStarCalc.Create(Msg);
end;

procedure TStarCalcExport.SaveSpreadSheet(Const AFileName : String);

Var
  SaveParams : Variant;
  FN : String;

begin
  CheckDocument;
  SaveParams:=VarArrayCreate([0, -1], varVariant);
  FN:='file:///'+StringReplace(AFileName,'\','/',[rfReplaceAll]);
  FDocument.StoreAsUrl(FN,SaveParams);
end;

procedure TStarCalcExport.Execute;
begin
  If (FDataset=Nil) then
    Error(SErrNoDataset);
  If (TemplateFileName<>'') and FileExists(TemplateFileName) then
    LoadSpreadSheet(TemplateFileName)
  else
    LoadSpreadSheet('');
  Try
    CreateSheet('');
    Try
      FillCells;
      SaveSpreadSheet(FileName);
    Finally
      VarClear(FSheet);
    end;
  Finally
    If CloseStarCalc then
      Try
        FDocument.Close(true);
        VarClear(FDocument);
      finally
        VarClear(FDesktop);
      end;
  end;
end;

procedure TStarCalcExport.CheckConnect;

begin
  if (VarIsEmpty(FOffice) or VarIsNull(FOffice)) then
    Connect;
end;

procedure TStarCalcExport.CheckDesktop;

begin
  if (VarIsEmpty(FDeskTop) or VarIsNull(FDeskTop)) then
    CreateDesktop;
end;

procedure TStarCalcExport.LoadSpreadSheet(Const AFileName: String);

Var
  FN: String;
  OpenParams : Variant;

begin
  CheckDesktop;
  OpenParams:=VarArrayCreate([0, -1], varVariant);
  FN:=AFileName;
  If (AFileName='') then
    FN:='private:factory/scalc'
  else
    FN:='file:///'+StringReplace(FN,'\','/',[rfReplaceAll]);
  FDocument:=FDesktop.LoadComponentFromURL(FN,'_default',0,OpenParams);
  If (VarIsEmpty(FDocument) or VarIsNull(FDocument)) then
    If (AFileName='') then
      Error(SErrFailedToCreateDocument)
    else
      Error(SErrFailedToOpenDocument);
end;

procedure TStarCalcExport.SetDataset(const Value: TDataset);
begin
  FDataset := Value;
end;

procedure TStarCalcExport.CreatePropertyValue(var PropertyValue: Variant;
  APropertyName: String);
begin
  If VarIsNull(FCoreReflection) or VarIsEmpty(FCoreReflection) then
    FCoreReflection:=FOffice.createInstance('com.sun.star.reflection.CoreReflection');
  FCoreReflection.forName('com.sun.star.beans.PropertyValue').CreateObject(PropertyValue);
  PropertyValue.Name:=APropertyName;
end;

procedure TStarCalcExport.CreateDeskTop;
begin
  CheckConnect;
  FDesktop := FOffice.createInstance('com.sun.star.frame.Desktop');
end;

procedure TStarCalcExport.Notification(AComponent: TComponent; Operation: TOperation);

begin
  Inherited;
  If (Operation=opRemove) and (AComponent=FDataset) then
    FDataset:=Nil;
end;

procedure TStarCalcExport.CheckDocument;
begin
  If VarIsNull(FDocument) or VarIsEmpty(FDocument) then
    Error(SErrNoDocument)
end;

procedure TStarCalcExport.GetFieldList(L : TStrings);

Var
  FN : String;
  I : Integer;

begin
  With FDataset do
    For I:=0 to Fields.Count-1 do
      begin
      FN:=Fields[i].FieldName;
      If FExcludeFields.IndexOf(FN)=-1 then
        If (FIncludeFields.Count=0) or
           (FIncludeFields.IndexOf(FN)<>-1) then
         L.AddObject(FN,Fields[i]);
      end;
end;

procedure TStarCalcExport.FillCells;

Const
  FloatTypes = [ftSmallInt,ftInteger,ftWord,ftFloat,ftCurrency,
                ftBCD,ftAutoInc,ftLargeInt];

Var
  CRow,SCol,I : Integer;
  C : Variant;
  L : TStringList;
  F : TField;
  FN : String;

begin
  CRow:=FRow-1;
  SCol:=FColumn-1;
  If CRow<0 then
    CRow:=0;
  If SCol<1 then
    SCol:=0;
  L:=TStringList.Create;
  Try
    GetFieldList(L);
    If IncludeFieldNames then
      begin
      For I:=0 to L.Count-1 do
        begin
        C:=FSheet.getCellByPosition(SCol+I,CRow);
        C.setString(TField(L.Objects[i]).DisplayName);
        end;
      Inc(CRow);
      end;
    With FDataset do
      While not EOF do
        begin
        For I:=0 to L.Count-1 do
          begin
          F:=TField(L.Objects[i]);
          If Not F.IsNull then
            begin
            C:=FSheet.getCellByPosition(SCol+I,CRow);
            If F.DataType in FloatTypes then
              C.setValue(F.AsVariant)
            else
              C.setString(F.AsString);
            end;
          end;
        Next;
        Inc(CRow)
        end;
  Finally
    L.Free;
  end;
end;

procedure TStarCalcExport.SetExcludeFields(const Value: TStrings);
begin
  FExcludeFields.Assign(Value);
end;

procedure TStarCalcExport.SetIncludeFields(const Value: TStrings);
begin
  FIncludeFields.Assign(Value);
end;

constructor TStarCalcExport.Create(Aowner: TComponent);

begin
  inherited;
  FExcludeFields:=TStringList.Create;
  FIncludeFields:=TStringList.Create;
end;

destructor TStarCalcExport.Destroy;

begin
  FExcludeFields.Free;
  FIncludeFields.Free;
  inherited;
end;

end.
