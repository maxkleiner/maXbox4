{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDBUltimGrid.PAS, released on 2004-07-22.

The Initial Developers of the Original Code are: Fr�d�ric Leneuf-Magaud
Copyright (c) 2004 Fr�d�ric Leneuf-Magaud
All Rights Reserved.

Contributors:
  Niels v/d Spek

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

-----------------------------------------------------------------------------
HOW TO SORT FIELDS:
-----------------------------------------------------------------------------

---= Delphi example =---

// Don't forget to set SortWith and assign OnIndexNotFound/OnUserSort if needed

var
  MyFields: TSortFields;

SetLength(MyFields, 2);
MyFields[0].Name := 'Country';
MyFields[0].Order := JvGridSort_ASC;
MyFields[1].Name := 'Sales';
MyFields[1].Order := JvGridSort_DESC;
MyUltimGrid.Sort(MyFields);

if not MyUltimGrid.SortOK then ...

---= BCB example =---

// Don't forget to set SortWith and assign OnIndexNotFound/OnUserSort if needed

TSortFields MyFields;

MyFields.set_length(2);
MyFields[0].Name = "Country";
MyFields[0].Order = JvGridSort_ASC;
MyFields[1].Name = "Sales";
MyFields[1].Order = JvGridSort_DESC;
MyUltimGrid->Sort(MyFields);

if (!MyUltimGrid->SortOK) ...

---= MANUAL SORTING =---

if TitleButtons is true then...

First click = the selected field is sorted in ascending order
Second click = the selected field is sorted in descending order
Shift+Click / Ctrl+Click = multi-column sorting

-----------------------------------------------------------------------------
HOW TO SEARCH A VALUE:
-----------------------------------------------------------------------------

---= Delphi example =---

var
  // Declare these vars as global vars if you want to use SearchNext
  ResultCol: Integer;
  ResultField: TField;

with MyUltimGrid do
begin
  SearchFields.Clear;
  SearchFields.Add('Category');
  SearchFields.Add('Common_Name');
  SearchFields.Add('Species Name');
  SearchFields.Add('Notes');
  if not Search('fish', ResultCol, ResultField, False, False, True) then ...
end;

// then:
if not MyUltimGrid.SearchNext(ResultCol, ResultField, False, False, True) then ...

---= BCB example =---

// Declare these vars as global vars if you want to use SearchNext
int ResultCol;
TField *ResultField;

MyUltimGrid->SearchFields->Clear();
MyUltimGrid->SearchFields->Add("Category");
MyUltimGrid->SearchFields->Add("Common_Name");
MyUltimGrid->SearchFields->Add("Species Name");
MyUltimGrid->SearchFields->Add("Notes");
if (!MyUltimGrid->Search("fish", ResultCol, ResultField, false, false, true)) ...

// then:
if (!MyUltimGrid->SearchNext(ResultCol, ResultField, false, false, true)) ...

-----------------------------------------------------------------------------
Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvDBUltimGrid.pas 12461 2009-08-14 17:21:33Z obones $

unit JvDBUltimGrid;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  Windows, Variants, Classes, Graphics, Controls, DB,
  JvDBGrid, JvTypes; {JvTypes contains Exception base class}

const
  JvGridSort_ASC = True;
  JvGridSort_UP = True;
  JvGridSort_DESC = False;
  JvGridSort_DOWN = False;

type
  TSortField = record
    Name: string;
    Order: Boolean;
  end;
  TSortFields = array of TSortField;

  TJvDBUltimGrid = class;
  TIndexNotFoundEvent = procedure(Sender: TJvDBUltimGrid; FieldsToSort: TSortFields;
    IndexFieldNames: string; DescFields: string; var Retry: Boolean) of object;
  TUserSortEvent = procedure(Sender: TJvDBUltimGrid; var FieldsToSort: TSortFields;
    SortString: string; var SortOK: Boolean) of object;
  TRestoreGridPosEvent = procedure(Sender: TJvDBUltimGrid; SavedBookmark: TBookmark;
    SavedRowPos: Integer) of object;
  TCheckIfValidSortFieldEvent = function(Sender: TJvDBUltimGrid;
    FieldToSort: TField): Boolean of object;
  TGetSortFieldNameEvent = procedure(Sender: TJvDBUltimGrid; var FieldName: string) of object;

  TSortWith = (swIndex, swFields, swUserFunc, swWhere);

  TJvDBUltimGrid = class(TJvDBGrid)
  private
    FSortedFields: TSortFields;
    FSortWith: TSortWith;
    FSortOK: Boolean;
    FMultiColSort: Boolean;
    FOnIndexNotFound: TIndexNotFoundEvent;
    FOnUserSort: TUserSortEvent;
    FOnCheckIfValidSortField: TCheckIfValidSortFieldEvent;
    FSavedBookmark: {$IFDEF RTL200_UP}TBookmark{$ELSE}TBookmarkStr{$ENDIF RTL200_UP};
    FSavedRowPos: Integer;
    FOnRestoreGridPosition: TRestoreGridPosEvent;
    FValueToSearch: Variant;
    FSearchFields: TStringList;
    FOnGetSortFieldName: TGetSortFieldNameEvent;
    FOnAfterSort: TNotifyEvent;
    procedure SetMultiColSort(const Value: Boolean);
    function PrivateSearch(var ResultCol: Integer; var ResultField: TField;
      const CaseSensitive, WholeFieldOnly, Next: Boolean): Boolean;
  protected
    function SortMarkerAssigned(const AFieldName: string): Boolean; override;
    procedure DoTitleClick(ACol: Longint; AField: TField); override;
    procedure GetSortFieldName(var FieldName: string); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Sort(FieldsToSort: TSortFields);
    property SortedFields: TSortFields read FSortedFields;
    property SortOK: Boolean read FSortOK;
    procedure SaveGridPosition;
    procedure RestoreGridPosition;
    property SearchFields: TStringList read FSearchFields write FSearchFields;
    function Search(const ValueToSearch: Variant; var ResultCol: Integer;
      var ResultField: TField; const CaseSensitive, WholeFieldOnly, Focus: Boolean): Boolean;
    function SearchNext(var ResultCol: Integer; var ResultField: TField;
      const CaseSensitive, WholeFieldOnly, Focus: Boolean): Boolean;
  published
    property SortedField stored False; // Property of JvDBGrid not used in JvDBUltimGrid
    property SortMarker stored False; // Property of JvDBGrid hidden in JvDBUltimGrid

    { SortWith:
      swIndex    : for BDE tables (assignment of OnIndexNotFound is recommended)
      swFields   : for ADO tables
      swUserFunc : for other data providers (assignment of OnUserSort is mandatory) }
    property SortWith: TSortWith read FSortWith write FSortWith default swIndex;

    { MultiColSort: is the sorting allowed on several columns or only one ? }
    property MultiColSort: Boolean read FMultiColSort write SetMultiColSort default True;

    { OnIndexNotFound: fired when SortWith = swIndex and the sorting index is not found }
    property OnIndexNotFound: TIndexNotFoundEvent read FOnIndexNotFound write FOnIndexNotFound;

    { OnUserSort: fired when SortWith = swUserFunc }
    property OnUserSort: TUserSortEvent read FOnUserSort write FOnUserSort;

    { OnCheckIfValidSortField allows to define your own checking routine for sorting fields }
    property OnCheckIfValidSortField: TCheckIfValidSortFieldEvent
      read FOnCheckIfValidSortField write FOnCheckIfValidSortField;

    { OnRestoreGridPosition: fired when RestoreGridPosition is called }
    property OnRestoreGridPosition: TRestoreGridPosEvent
      read FOnRestoreGridPosition write FOnRestoreGridPosition;

    { OnGetSortFieldName: allows to override the sort marker field }
    property OnGetSortFieldName: TGetSortFieldNameEvent read FOnGetSortFieldName Write FOnGetSortFieldName;
    
    { OnAfterSort: fired after the table was sorted. }
    property OnAfterSort: TNotifyEvent read FOnAfterSort write FOnAfterSort;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_40_PREPARATION/run/JvDBUltimGrid.pas $';
    Revision: '$Revision: 12461 $';
    Date: '$Date: 2009-08-14 19:21:33 +0200 (ven., 14 août 2009) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation

uses
  TypInfo, Forms, SysUtils, DBGrids,
  JclStrings,
  JvResources;

constructor TJvDBUltimGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSortedFields := nil;
  FSortWith := swIndex;
  FSortOK := True;
  FMultiColSort := True;
  FOnIndexNotFound := nil;
  FOnUserSort := nil;
  FSavedBookmark := {$IFDEF RTL200_UP}nil{$ELSE}''{$ENDIF RTL200_UP};
  FSavedRowPos := 0;
  FOnRestoreGridPosition := nil;
  FValueToSearch := Null;
  FSearchFields := TStringList.Create;
end;

destructor TJvDBUltimGrid.Destroy;
begin
  FSearchFields.Free;
  inherited Destroy;
end;

function TJvDBUltimGrid.SortMarkerAssigned(const AFieldName: string): Boolean;
var
  SF: Integer;
  SortFieldName: string;
begin
  Result := False;
  if Assigned(FSortedFields) then
  begin
    SortFieldName := AFieldName;
    { Let the user override the sort marker field }
    GetSortFieldName(SortFieldName);

    for SF := 0 to Length(FSortedFields) - 1 do
      if AnsiSameText(SortFieldName, FSortedFields[SF].Name) then
      begin
        if FSortedFields[SF].Order = JvGridSort_UP then
          inherited ChangeSortMarker(smUp)
        else
          inherited ChangeSortMarker(smDown);
        Result := True;
        Break;
      end;
  end;
end;

procedure TJvDBUltimGrid.Sort(FieldsToSort: TSortFields);
const
  cIndexDefs = 'IndexDefs';
  cIndexName = 'IndexName';
  cIndexFieldNames = 'IndexFieldNames';
var
  DSet: TDataSet;

  procedure UpdateProp(const PropName: string; const Value: string);
  begin
    SetStrProp(DSet, PropName, Value);
    FSortedFields := FieldsToSort;
    FSortOK := True;
  end;

var
  SortString, DescString: string;
  MaxFTS: Integer;

  procedure SearchIndex;
  var
    IndexDefs: TIndexDefs;
    I, J: Integer;
  begin
    IndexDefs := TIndexDefs(GetOrdProp(DSet, cIndexDefs));
    IndexDefs.Update;
    for I := 0 to IndexDefs.Count - 1 do
      if AnsiSameText(SortString, IndexDefs.Items[I].Fields) then
      begin
        // The search succeeds if:
        // - no descending order is requested
        //   and the index found has no desc fields nor the flag ixDescending set to true
        // - descending order is requested
        //   and the index found has exactly the same desc fields
        // - descending order is requested
        //   and the index found has no desc fields but its flag ixDescending is true
        if DescString = '' then
        begin
          if (IndexDefs.Items[I].DescFields = '') and
            not (ixDescending in IndexDefs.Items[I].Options) then
          begin
            UpdateProp(cIndexName, IndexDefs.Items[I].Name);
            Break;
          end;
        end
        else
        if AnsiSameText(DescString, IndexDefs.Items[I].DescFields) then
        begin
          UpdateProp(cIndexName, IndexDefs.Items[I].Name);
          Break;
        end
        else
        if (IndexDefs.Items[I].DescFields = '') and
          (ixDescending in IndexDefs.Items[I].Options) then
        begin
          for J := 0 to MaxFTS do
            FieldsToSort[J].Order := JvGridSort_DESC;
          UpdateProp(cIndexName, IndexDefs.Items[I].Name);
          Break;
        end;
      end;
  end;

var
  FTS: Integer;
  SortField: TField;
  Retry: Boolean;
  FieldIsValid: Boolean;
begin
  FSortOK := False;
  if Assigned(DataLink) and DataLink.Active and Assigned(FieldsToSort) then
  begin
    // Dataset must be in browse mode
    DSet := DataSource.DataSet;
    DSet.CheckBrowseMode;

    // Checking of OnUserSort assignment
    if Assigned(OnUserSort) then
      SortWith := swUserFunc;
    if (SortWith = swUserFunc) and not Assigned(OnUserSort) then
      raise EJVCLDbGridException.CreateRes(@RsEJvDBGridUserSortNotAssigned);

    // Checking of index properties
    if (SortWith = swIndex) and
      not (IsPublishedProp(DSet, cIndexDefs) and IsPublishedProp(DSet, cIndexName)) then
      raise EJVCLDbGridException.CreateRes(@RsEJvDBGridIndexPropertyMissing)
    else
    if (SortWith = swFields) and
      not IsPublishedProp(DSet, cIndexFieldNames) then
      raise EJVCLDbGridException.CreateRes(@RsEJvDBGridIndexPropertyMissing);

    // Sorting
    Screen.Cursor := crHourGlass;
    DSet.DisableControls;
    try
      SortString := '';
      DescString := '';
      MaxFTS := Length(FieldsToSort) - 1;
      for FTS := 0 to MaxFTS do
      begin
        FieldsToSort[FTS].Name := Trim(FieldsToSort[FTS].Name);
        if SortWith <> swWhere then
        begin
          SortField := DSet.FieldByName(FieldsToSort[FTS].Name);
          if Assigned(OnCheckIfValidSortField) then
            FieldIsValid := OnCheckIfValidSortField(Self, SortField)
          else
            FieldIsValid := not (SortField is TBlobField) and not (SortField is TBytesField)
              and ((SortField.FieldKind = fkData) or (SortField.FieldKind = fkInternalCalc));
          if not FieldIsValid then
          begin
            // No sorting of binary or special fields
            if BeepOnError then
            begin
              SysUtils.Beep;
              Continue;
            end
            else
              raise EJVCLDbGridException.CreateRes(@RsEJvDBGridBadFieldKind);
          end;
        end;

        if SortWith = swIndex then
        begin
          // Sort with index
          if SortString <> '' then
            SortString := SortString + ';';
          SortString := SortString + FieldsToSort[FTS].Name;
          if FieldsToSort[FTS].Order = JvGridSort_DESC then
          begin
            if DescString <> '' then
              DescString := DescString + ';';
            DescString := DescString + FieldsToSort[FTS].Name;
          end;
          if FTS = MaxFTS then
          begin
            SearchIndex;
            if not SortOK then
            begin
              if Assigned(OnIndexNotFound) then
              begin
                Retry := False;
                OnIndexNotFound(Self, FieldsToSort, SortString, DescString, Retry);
                if Retry then
                begin
                  SearchIndex;
                  if not SortOK then
                    raise EJVCLDbGridException.CreateRes(@RsEJvDBGridIndexMissing);
                end;
              end
              else
                raise EJVCLDbGridException.CreateRes(@RsEJvDBGridIndexMissing);
            end;
          end;
        end
        else
        if SortWith in [swFields, swUserFunc, swWhere] then
        begin
          // Sort with fields (temporary index), user function or where clausel
          if SortString <> '' then
            SortString := SortString + ',';
          if SortWith = swWhere then
            SortString := SortString + FieldsToSort[FTS].Name
          else
            SortString := SortString + '[' + FieldsToSort[FTS].Name + ']';

          if FieldsToSort[FTS].Order = JvGridSort_ASC then
            SortString := SortString + ' ASC'
          else
            SortString := SortString + ' DESC';
          if FTS = MaxFTS then
          begin
            if SortWith = swUserFunc then
            begin
              OnUserSort(Self, FieldsToSort, SortString, FSortOK);
              if SortOK then
                FSortedFields := FieldsToSort;
            end
            else
              UpdateProp(cIndexFieldNames, SortString);
          end;
        end;
      end;
      if FSortOK and Assigned(FOnAfterSort) then
        FOnAfterSort(Self);
    finally
      DSet.EnableControls;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TJvDBUltimGrid.SetMultiColSort(const Value: Boolean);
begin
  if FMultiColSort <> Value then
  begin
    FMultiColSort := Value;
    if Assigned(FSortedFields) and not FMultiColSort then
    begin
      SetLength(FSortedFields, 1);
      Sort(FSortedFields);
    end;
  end;
end;

procedure TJvDBUltimGrid.DoTitleClick(ACol: Longint; AField: TField);
var
  Keys: TKeyboardState;
  Found, ShiftOrCtrlKeyPressed: Boolean;
  SortArraySize: Integer;
  FieldsToSort: TSortFields;
  I: Integer;
  SortFieldName: string;
begin
  FSortOK := False;
  try
    if Assigned(AField) then
    begin
      Found := False;
      SortArraySize := 1;

      SortFieldName := AField.FieldName;
      { Let the user override the sort marker field }
      GetSortFieldName(SortFieldName);

      if Assigned(FSortedFields) then
      begin
        ShiftOrCtrlKeyPressed := MultiColSort and GetKeyboardState(Keys);
        if ShiftOrCtrlKeyPressed then
          ShiftOrCtrlKeyPressed :=
            (((Keys[VK_SHIFT] and $80) <> 0) or ((Keys[VK_CONTROL] and $80) <> 0));
        SetLength(FieldsToSort, Length(FSortedFields));
        for I := 0 to Length(FSortedFields) - 1 do
        begin
          FieldsToSort[I].Name := FSortedFields[I].Name;
          if AnsiSameText(SortFieldName, FSortedFields[I].Name) then
          begin
            Found := True;
            if not ShiftOrCtrlKeyPressed then
            begin
              SetLength(FieldsToSort, 1);
              FieldsToSort[0].Name := SortFieldName;
              FieldsToSort[0].Order := not FSortedFields[I].Order;
              Break;
            end
            else
              FieldsToSort[I].Order := not FSortedFields[I].Order;
          end
          else
            FieldsToSort[I].Order := FSortedFields[I].Order;
        end;
        if (not Found) and ShiftOrCtrlKeyPressed then
          SortArraySize := Length(FSortedFields) + 1;
      end;
      if not Found then
      begin
        SetLength(FieldsToSort, SortArraySize);
        FieldsToSort[SortArraySize - 1].Name := SortFieldName;
        FieldsToSort[SortArraySize - 1].Order := JvGridSort_ASC;
      end;
      Sort(FieldsToSort);
    end;
  finally
    if Assigned(OnTitleBtnClick) then
      OnTitleBtnClick(Self, ACol, AField);
  end;
end;

procedure TJvDBUltimGrid.GetSortFieldName(var FieldName: string);
begin
  if Assigned(FOnGetSortFieldName) then
    FOnGetSortFieldName(Self, FieldName);
end;

procedure TJvDBUltimGrid.SaveGridPosition;
begin
  FSavedBookmark := DataLink.DataSet.Bookmark;
  FSavedRowPos := DataLink.ActiveRecord;
end;

procedure TJvDBUltimGrid.RestoreGridPosition;
begin
  if Assigned(FOnRestoreGridPosition) then
  begin
    // This example for ADO datasets positions the dataset cursor exactly
    // where it was before it moves (put this code into your event):
    //
    // Delphi code:
    // if (MyADODataSet.BookmarkValid(SavedBookmark)) then
    //   MyADODataSet.Recordset.Bookmark := POleVariant(SavedBookmark)^;
    // try MyADODataSet.Resync([rmExact]); except end;
    //
    // BCB code:
    // if (MyADODataSet->BookmarkValid(SavedBookmark))
    //   MyADODataSet->Recordset->Bookmark = *(POleVariant)SavedBookmark;
    // try {MyADODataSet->Resync(TResyncMode() << rmExact);} catch (...) {}
    //
    DataLink.ActiveRecord := FSavedRowPos;
    FOnRestoreGridPosition(Self, Pointer(FSavedBookmark), FSavedRowPos);
  end
  else
  if DataLink.DataSet.BookmarkValid(Pointer(FSavedBookmark)) then
    DataLink.DataSet.GotoBookmark(Pointer(FSavedBookmark));
end;

function TJvDBUltimGrid.PrivateSearch(var ResultCol: Integer; var ResultField: TField;
  const CaseSensitive, WholeFieldOnly, Next: Boolean): Boolean;
var
  DSet: TDataSet;
  Start, ColNo, I: Integer;
  Found: Boolean;
  FieldText: string;
  ValueToSearchStr: string;
begin
  Result := False;
  if Assigned(DataLink) and DataLink.Active then
  begin
    Screen.Cursor := crHourGlass;
    DSet := DataSource.DataSet;
    DSet.DisableControls;
    try
      // Start location
      SaveGridPosition;
      if Next then
      begin
        Start := Col;
        if not (dgIndicator in Options) then
          Inc(Start);
      end
      else
      begin
        Start := 0;
        DSet.First;
      end;

      ValueToSearchStr := VarToStr(FValueToSearch);
      // The search begins...
      while not DSet.Eof do
      begin
        for ColNo := Start to Columns.Count - 1 do
          for I := 0 to SearchFields.Count - 1 do
          begin
            if AnsiSameText(SearchFields[I], Columns[ColNo].FieldName) then
              with Columns[ColNo].Field do
              begin
                if Assigned(OnGetText) then
                  FieldText := DisplayText
                else
                  FieldText := AsString;
                if FieldText <> '' then
                begin
                  // Search inside the field content
                  if CaseSensitive then
                  begin
                    if WholeFieldOnly then
                      Found := AnsiSameStr(ValueToSearchStr, FieldText)
                    else
                      Found := StrSearch(ValueToSearchStr, FieldText) > 0;
                  end
                  else
                  begin
                    if WholeFieldOnly then
                      Found := AnsiSameText(ValueToSearchStr, FieldText)
                    else
                      Found := StrFind(ValueToSearchStr, FieldText) > 0;
                  end;

                  // Text found ! -> exit
                  if Found then
                  begin
                    ResultCol := ColNo;
                    if dgIndicator in Options then
                      Inc(ResultCol);
                    ResultField := Columns[ColNo].Field;
                    Result := True;
                    Exit;
                  end;
                end;
              end;
          end;
        Start := 0;
        DSet.Next;
      end;
    finally
      DSet.EnableControls;
      Screen.Cursor := crDefault;
    end;
  end;
end;

function TJvDBUltimGrid.Search(const ValueToSearch: Variant; var ResultCol: Integer;
  var ResultField: TField; const CaseSensitive, WholeFieldOnly, Focus: Boolean): Boolean;
begin
  Result := False;
  if (SearchFields.Count > 0) and (ValueToSearch <> Null) and (ValueToSearch <> '') then
  begin
    FValueToSearch := ValueToSearch;
    Result := PrivateSearch(ResultCol, ResultField, CaseSensitive, WholeFieldOnly, False);
    if Result and Focus then
    begin
      Self.Col := ResultCol;
      if Self.Visible and Self.CanFocus then
        Self.SetFocus;
    end
    else
      RestoreGridPosition;
  end;
end;

function TJvDBUltimGrid.SearchNext(var ResultCol: Integer; var ResultField: TField;
  const CaseSensitive, WholeFieldOnly, Focus: Boolean): Boolean;
begin
  Result := False;
  if (SearchFields.Count > 0) and (FValueToSearch <> Null) and (FValueToSearch <> '') then
  begin
    Result := PrivateSearch(ResultCol, ResultField, CaseSensitive, WholeFieldOnly, True);
    if Result and Focus then
    begin
      Self.Col := ResultCol;
      if Self.Visible then
        Self.SetFocus;
    end
    else
      RestoreGridPosition;
  end;
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.