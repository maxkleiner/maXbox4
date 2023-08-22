unit RegisterDbTreeLookupComboBox;

{ Registration of TDbTreeLookupComboBox
  Version 0.8  Jun-14-1997  (C) 1997 Christoph R. Kirchner
}
{ Requires the TDBTreeView component, a data-aware TTreeView component that
  you can find in dbTree.PAS. If you do not have it, please look at:
  http://www.geocities.com/SiliconValley/Heights/7874/delphi.htm
}
{ Users of this unit must accept this disclaimer of warranty:
    "This unit is supplied as is. The author disclaims all warranties,
    expressed or implied, including, without limitation, the warranties of
    merchantability and of fitness for any purpose.
    The author assumes no liability for damages, direct or consequential,
    which may result from the use of this unit."

  This unit is donated to the public as public domain.

  This unit can be freely used and distributed in commercial and private
  environments provided this notice is not modified in any way.

  If you do find this unit handy and you feel guilty for using such a
  great product without paying someone - sorry :-)

  Please forward any comments or suggestions to Christoph Kirchner at:
  ckirchner@geocities.com

  Maybe you can find an update of this component at my
  'Delphi Component Building Site':
  http://www.geocities.com/SiliconValley/Heights/7874/delphi.htm
}
{
  Please look at dbTreeCBox.pas first.
  DEFINE RedefineTDBLookupControl if you do not want to change the definition
  of TDBLookupControl in the unit DBCtrls.

  Otherwise you have to do the following: (Tested with Delphi 2.0 only)
  - Copy DBCtrls.PAS from Delphi\Source\VCL into Delphi\Lib
  - Replace the definition of TDBLookupControl in the unit DBCtrls with the
    definition of TDBLookupControl in this unit. (Changes are marked with *)

  This is needed because the TDBLookupControl is useless outside DBCtrls.PAS -
  too many important functions are in the private section. This could happen
  due to a IMHO big mistake in Borlands definition of the Delphi-language:
  Private declarations are not private but protected inside the unit. For this,
  the Borland-programmers did not care about a useful declaration of
  TDBLookupControl - they just declared all decendants in the same unit.
}


interface

uses
  SysUtils, DsgnIntf, Windows, Messages, Classes, Controls,
  CommCtrl, Forms, Dialogs, DB, DBTables, dbTree, dbTreeCBox
{$IFDEF Ver90}
  , Libconst;
{$ELSE DEF Ver90} { Delphi >= 3.0: }
  ;
{$ENDIF DEF Ver90}

procedure Register;

implementation

{$R dbTreeCBox.DCR}

{$IFNDEF Ver90} { Delphi >= 3.0: }
const
  srDControls = 'Data Controls';
{$ENDIF DEF Ver90}


{ Property-Editors ------------------------------------------------------------}

type

  TDBTVProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetTvDataSet: TDataSet; virtual; abstract;
    function IDField: String; virtual; abstract;
    function ParentField: String; virtual; abstract;
    procedure GetValueList(List: TStrings); virtual; abstract;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TParentFieldNamesProperty = class(TDBTVProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TIDFieldNamesProperty = class(TDBTVProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TDataFieldProperty = class(TDBTVProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;


{ TDBTVProperty }

function TDBTVProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

procedure TDBTVProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;


{ TParentFieldNamesProperty }

procedure TParentFieldNamesProperty.GetValueList(List: TStrings);
var
  I: Integer;
  DataSet: TDataSet;
begin
  DataSet := GetTvDataSet;
  if (DataSet <> nil) then
  begin
    for i := 0 to DataSet.FieldCount - 1 do
      with DataSet.Fields[i] do
        case DataType of
          ftString, ftSmallint, ftInteger, ftWord,
          ftFloat, ftCurrency, ftBCD:
            List.Add(FieldName);
        end;
  end;
end;


{ TIDFieldNamesProperty }

procedure TIDFieldNamesProperty.GetValueList(List: TStrings);
var
  I: Integer;
  DataSet: TDataSet;
begin
  DataSet := GetTvDataSet;
  if (DataSet <> nil) then
  begin
    if (DataSet is TTable) then
    begin
      with TTable(DataSet) do
      begin
        IndexDefs.Update;
        for I := 0 to IndexDefs.Count - 1 do
          with IndexDefs[I] do
            if (ixPrimary in Options) then List.Add(Fields);
      end;
    end
    else
    begin
      for i := 0 to DataSet.FieldCount - 1 do
        with DataSet.Fields[i] do
          case DataType of
            ftString, ftSmallint, ftInteger, ftWord,
            ftFloat, ftCurrency, ftBCD:
              List.Add(FieldName);
          end;
    end;
  end;
end;


{ TDataFieldProperty }

procedure TDataFieldProperty.GetValueList(List: TStrings);
var
  I: Integer;
  DataSet: TDataSet;
begin
  DataSet := GetTvDataSet;
  if (DataSet <> nil) then
  begin
    for i := 0 to DataSet.FieldCount - 1 do
      with DataSet.Fields[i] do
        if (FieldName <> IDField) and (FieldName <> ParentField) then
          case DataType of
            ftString, ftSmallint, ftInteger, ftWord, ftBoolean,
            ftFloat, ftCurrency, ftBCD, ftDate, ftTime, ftDateTime:
              List.Add(FieldName);
          end;
  end;
end;


{ Property-Editors for TDbTreeLookupComboBox ----------------------------------}

type

  TDbTreeLookupComboBoxParentFieldNamesProperty =
    class(TParentFieldNamesProperty)
  public
    function GetTvDataSet: TDataSet; override;
  end;

  TDbTreeLookupComboBoxIDFieldNamesProperty = class(TIDFieldNamesProperty)
  public
    function GetTvDataSet: TDataSet; override;
  end;

  TDbTreeLookupComboBoxDataFieldProperty = class(TDataFieldProperty)
  public
    function GetTvDataSet: TDataSet; override;
    function IDField: String; override;
    function ParentField: String; override;
  end;


function TDbTreeLookupComboBoxParentFieldNamesProperty.GetTvDataSet: TDataSet;
begin
  if (GetComponent(0) is TDbTreeLookupComboBox) then
    Result := TDbTreeLookupComboBox(GetComponent(0)).DBTreeViewDataset
  else
    Result := nil;
end;

function TDbTreeLookupComboBoxIDFieldNamesProperty.GetTvDataSet: TDataSet;
begin
  if (GetComponent(0) is TDbTreeLookupComboBox) then
    Result := TDbTreeLookupComboBox(GetComponent(0)).DBTreeViewDataset
  else
    Result := nil;
end;

function TDbTreeLookupComboBoxDataFieldProperty.GetTvDataSet: TDataSet;
begin
  if (GetComponent(0) is TDbTreeLookupComboBox) then
    Result := TDbTreeLookupComboBox(GetComponent(0)).DBTreeViewDataset
  else
    Result := nil;
end;

function TDbTreeLookupComboBoxDataFieldProperty.IDField: String;
begin
  if (GetComponent(0) is TDbTreeLookupComboBox) then
    Result := TDbTreeLookupComboBox(GetComponent(0)).ListTreeIDField
  else
    Result := '';
end;

function TDbTreeLookupComboBoxDataFieldProperty.ParentField: String;
begin
  if (GetComponent(0) is TDbTreeLookupComboBox) then
    Result := TDbTreeLookupComboBox(GetComponent(0)).ListTreeParentField
  else
    Result := '';
end;





{ Register --------------------------------------------------------------------}

procedure Register;
begin
{$IFDEF Ver90}
  RegisterComponents(LoadStr(srDControls), [TDbTreeLookupComboBox]);
{$ELSE DEF Ver90} { Delphi >= 3.0: }
  RegisterComponents(srDControls, [TDbTreeLookupComboBox]);
{$ENDIF DEF Ver90}
  RegisterPropertyEditor(TypeInfo(string), TDbTreeLookupComboBox,
                         'ListTreeIDField',
                         TDbTreeLookupComboBoxIDFieldNamesProperty);
  RegisterPropertyEditor(TypeInfo(string), TDbTreeLookupComboBox,
                         'ListTreeParentField',
                         TDbTreeLookupComboBoxParentFieldNamesProperty);
  RegisterPropertyEditor(TypeInfo(string), TDbTreeLookupComboBox,
                         'ListField',
                         TDbTreeLookupComboBoxDataFieldProperty);
end;

end.
