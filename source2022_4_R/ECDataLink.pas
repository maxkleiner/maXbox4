unit ECDataLink;

{ TECDataLink: DataLink that captures the OnXXX-events of the DataSet.
  Version 0.84  Nov-10-1997  (C) 1997 Christoph R. Kirchner
}
{ Users of this unit must accept this disclaimer of warranty:
    "This unit is supplied as is. The author disclaims all warranties,
    expressed or implied, including, without limitation, the warranties
    of merchantability and of fitness for any purpose.
    The author assumes no liability for damages, direct or
    consequential, which may result from the use of this unit."

  This Unit is donated to the public as public domain.

  This Unit can be freely used and distributed in commercial and
  private environments provided this notice is not modified in any way.

  If you do find this Unit handy and you feel guilty for using such a
  great product without paying someone - sorry :-)

  Please forward any comments or suggestions to Christoph Kirchner at:
  ckirchner@geocities.com

  Maybe you can find an update of this component at my
  "Delphi Component Building Site":
  http://www.geocities.com/SiliconValley/Heights/7874/delphi.htm

  Thanks to Main Chen for a bug-report with corrected source.
}

interface

uses
  SysUtils, Windows, Messages, Classes, Controls, BDE, DB, DBTables;

type

  TECDataLink = class(TDataLink)
  private
    FBDECallback: TBDECallback;
    FGotEventsOfDataset: TDataset;
    FOldBeforePost: TDataSetNotifyEvent;
    FOldAfterPost: TDataSetNotifyEvent;
    FOldAfterCancel: TDataSetNotifyEvent;
    FOldBeforeDelete: TDataSetNotifyEvent;
    FOldAfterDelete: TDataSetNotifyEvent;
    FOldBeforeEdit: TDataSetNotifyEvent;
    FOldBeforeInsert: TDataSetNotifyEvent;
    FOldAfterEdit: TDataSetNotifyEvent;
    FOldAfterInsert: TDataSetNotifyEvent;
    FOldBeforeCancel: TDataSetNotifyEvent;
    FIgnoreNextRefresh: Boolean; // ignore if we have changed the dataset
    //function RefreshCallBack(CBInfo: Pointer): CBRType;
    procedure GetDatasetEvents;
    procedure ResetDatasetEvents;
  protected
    procedure ActiveChanged; override;
    procedure DatasetRefreshed; virtual;
    procedure DoBeforePost(DataSet: TDataSet); virtual;
    procedure DoAfterPost(DataSet: TDataSet); virtual;
    procedure DoAfterCancel(DataSet: TDataSet); virtual;
    procedure DoBeforeDelete(DataSet: TDataSet); virtual;
    procedure DoAfterDelete(DataSet: TDataSet); virtual;
    procedure DoBeforeEdit(DataSet: TDataSet); virtual;
    procedure DoBeforeInsert(DataSet: TDataSet); virtual;
    procedure DoAfterEdit(DataSet: TDataSet); virtual;
    procedure DoAfterInsert(DataSet: TDataSet); virtual;
    procedure DoBeforeCancel(DataSet: TDataSet); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CheckRefresh;
    function CanCheckRefresh: Boolean;
  end;



implementation



constructor TECDataLink.Create;
begin
  inherited Create;
  FBDECallback := nil;
  FGotEventsOfDataset := nil;
  FIgnoreNextRefresh := false;
end;

destructor TECDataLink.Destroy;
begin
//Active := false; read-only >:(
  if Assigned(FBDECallback) then
  begin
    FBDECallback.Free;
    FBDECallback := nil;
  end;
  ResetDatasetEvents;
  inherited Destroy;
end;

{function TECDataLink.RefreshCallBack(CBInfo: Pointer): CBRType;
begin
  Result := cbrUSEDEF;
  if FIgnoreNextRefresh then
    FIgnoreNextRefresh := false
  else
    DatasetRefreshed;
end;}

function TECDataLink.CanCheckRefresh: Boolean;
begin
  Result := Assigned(FBDECallback);
end;

procedure TECDataLink.CheckRefresh;
var
  iSeqNo: Longint;
begin
  if (DataSet = nil) then
    exit;
{$IFDEF Ver90}
  DBICheckRefresh;
  if (DataSet.State = dsBrowse) then
    DbiGetSeqNo(DataSet.Handle, iSeqNo); // force BDE to look for changes
{$ELSE DEF Ver90} { Delphi >= 3.0: }
  if (Dataset is TBDEDataSet) and (DataSet.State = dsBrowse) then
  begin
    DBICheckRefresh;
    DbiGetSeqNo(TBDEDataSet(Dataset).Handle, iSeqNo);
  end;
{$ENDIF DEF Ver90}
end;

procedure TECDataLink.ActiveChanged;
begin
  if Assigned(FBDECallback) then
  begin
    FBDECallback.Free;
    FBDECallback := nil;
  end;
  if Active then
  begin
    FIgnoreNextRefresh := false;
  {$IFDEF Ver90}
    FBDECallback := TBDECallback.Create(self, Dataset.Handle,
      cbTableChanged, nil, 0, RefreshCallBack, true);
  {$ELSE DEF Ver90} { Delphi >= 3.0: }
    if (Dataset is TBDEDataSet) then
      //FBDECallback := TBDECallback.Create(self, TBDEDataSet(Dataset).Handle,
        //cbTableChanged, nil, 0, RefreshCallBack, true);
  {$ENDIF DEF Ver90}
    GetDatasetEvents;
  end
  else
  begin
    ResetDatasetEvents;
  end;
  inherited ActiveChanged;
end;

procedure TECDataLink.GetDatasetEvents;
begin
  if (DataSet <> nil) and not (csDesigning in DataSet.ComponentState) then
  begin
    if (FGotEventsOfDataset <> nil) then
      ResetDatasetEvents;
    FOldBeforePost := DataSet.BeforePost;
    DataSet.BeforePost := DoBeforePost;
    FOldAfterPost := DataSet.AfterPost;
    DataSet.AfterPost := DoAfterPost;
    FOldAfterCancel := DataSet.AfterCancel;
    DataSet.AfterCancel := DoAfterCancel;
    FOldBeforeDelete := DataSet.BeforeDelete;
    DataSet.BeforeDelete := DoBeforeDelete;
    FOldAfterDelete := DataSet.AfterDelete;
    DataSet.AfterDelete := DoAfterDelete;
    FOldBeforeInsert := DataSet.BeforeInsert;
    DataSet.BeforeInsert := DoBeforeInsert;
    FOldBeforeEdit := DataSet.BeforeEdit;
    DataSet.BeforeEdit := DoBeforeEdit;
    FOldAfterInsert := DataSet.AfterInsert;
    DataSet.AfterInsert := DoAfterInsert;
    FOldAfterEdit := DataSet.AfterEdit;
    DataSet.AfterEdit := DoAfterEdit;
    FOldBeforeCancel := DataSet.BeforeCancel;
    DataSet.BeforeCancel := DoBeforeCancel;
    FGotEventsOfDataset := DataSet;
  end;
end;

procedure TECDataLink.ResetDatasetEvents;
begin
  if (FGotEventsOfDataset <> nil) then
  begin
    if not (csDestroying in FGotEventsOfDataset.ComponentState) then
    begin
      FGotEventsOfDataset.BeforePost := FOldBeforePost;
      FGotEventsOfDataset.AfterPost := FOldAfterPost;
      FGotEventsOfDataset.AfterCancel := FOldAfterCancel;
      FGotEventsOfDataset.BeforeDelete := FOldBeforeDelete;
      FGotEventsOfDataset.AfterDelete := FOldAfterDelete;
      FGotEventsOfDataset.BeforeInsert := FOldBeforeInsert;
      FGotEventsOfDataset.BeforeEdit := FOldBeforeEdit;
      FGotEventsOfDataset.AfterInsert := FOldAfterInsert;
      FGotEventsOfDataset.AfterEdit := FOldAfterEdit;
      FGotEventsOfDataset.BeforeCancel := FOldBeforeCancel;
    end;
    FGotEventsOfDataset := nil;
  end;
end;

procedure TECDataLink.DatasetRefreshed;
begin
end;

procedure TECDataLink.DoBeforePost(DataSet: TDataSet);
begin
  if Assigned(FOldBeforePost) then FOldBeforePost(DataSet);
  FIgnoreNextRefresh := true;
end;

procedure TECDataLink.DoAfterCancel(DataSet: TDataSet);
begin
  if Assigned(FOldAfterCancel) then FOldAfterCancel(DataSet);
  FIgnoreNextRefresh := false;
end;

procedure TECDataLink.DoBeforeDelete(DataSet: TDataSet);
begin
  if Assigned(FOldBeforeDelete) then FOldBeforeDelete(DataSet);
  FIgnoreNextRefresh := true;
end;

procedure TECDataLink.DoAfterDelete(DataSet: TDataSet);
begin
  CheckRefresh;
  FIgnoreNextRefresh := false;
  if Assigned(FOldAfterDelete) then FOldAfterDelete(DataSet);
end;

procedure TECDataLink.DoAfterPost(DataSet: TDataSet);
begin
  CheckRefresh;
  FIgnoreNextRefresh := false;
  if Assigned(FOldAfterPost) then FOldAfterPost(DataSet);
end;

procedure TECDataLink.DoBeforeEdit(DataSet: TDataSet);
begin
  CheckRefresh;
  if Assigned(FOldBeforeEdit) then FOldBeforeEdit(DataSet);
end;

procedure TECDataLink.DoBeforeInsert(DataSet: TDataSet);
begin
  CheckRefresh;
  if Assigned(FOldBeforeInsert) then FOldBeforeInsert(DataSet);
end;

procedure TECDataLink.DoBeforeCancel(DataSet: TDataSet);
begin
  if Assigned(FOldBeforeCancel) then FOldBeforeCancel(DataSet);
end;

procedure TECDataLink.DoAfterEdit(DataSet: TDataSet);
begin
  if Assigned(FOldAfterEdit) then FOldAfterEdit(DataSet);
end;

procedure TECDataLink.DoAfterInsert(DataSet: TDataSet);
begin
  if Assigned(FOldAfterInsert) then FOldAfterInsert(DataSet);
end;




end.
