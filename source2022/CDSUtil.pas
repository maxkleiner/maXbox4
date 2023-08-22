unit CDSUtil;

interface

uses
  DbClient, DbTables;

function RetrieveDeltas(const cdsArray : array of TClientDataset): Variant;
function RetrieveProviders(const cdsArray : array of TClientDataset): Variant;
procedure ReconcileDeltas(const cdsArray : array of TClientDataset; vDeltaArray: OleVariant);

procedure CDSApplyUpdates(ADatabase : TDatabase; var vDeltaArray: OleVariant; const vProviderArray: OleVariant; Local: Boolean);

implementation

uses
  SysUtils, Provider, Midas, Variants;

type
  PArrayData = ^TArrayData;
  TArrayData = array[0..1000] of Olevariant;

{Delta is the CDS.Delta on input. On return, Delta will contain a data packet}
{containing all of the records that could not be applied to the database.}
{Remember Delphi needs the provider name, and this is passed in the 1 element}
{of the AProvider variant.}
procedure ApplyDelta(AProvider: OleVariant; var Delta : OleVariant; Local: Boolean);
var
  ErrCount : integer;
  OwnerData: OleVariant;
begin
  if not VarIsNull(Delta) then
  begin
    // ScktSrvr does not support early-binding - TLocalAppServer does not support IAppServerDisp typecast
    if Local then
      Delta := (IDispatch(AProvider[0]) as IAppServer).AS_ApplyUpdates(AProvider[1], Delta, 0, ErrCount, OwnerData) else
      Delta := IAppServerDisp(IDispatch(AProvider[0])).AS_ApplyUpdates(AProvider[1], Delta, 0, ErrCount, OwnerData);
    if ErrCount > 0 then
      SysUtils.Abort;  // This will cause Rollback in the calling procedure
  end;
end;

{Server call}
procedure CDSApplyUpdates(ADatabase : TDatabase; var vDeltaArray: OleVariant; const vProviderArray: OleVariant; Local: Boolean);
var
  i : integer;
  LowArr, HighArr: integer;
  P: PArrayData;
begin
  {Wrap the updates in a transaction. If any step results in an error, raise}
  {an exception, which will Rollback the transaction.}
  ADatabase.Connected:=true;
  ADatabase.StartTransaction;
  try
    LowArr:=VarArrayLowBound(vDeltaArray,1);
    HighArr:=VarArrayHighBound(vDeltaArray,1);
    P:=VarArrayLock(vDeltaArray);
    try
      for i:=LowArr to HighArr do
        ApplyDelta(vProviderArray[i], P^[i], Local);
    finally
      VarArrayUnlock(vDeltaArray);
    end;
    ADatabase.Commit;
  except
    ADatabase.Rollback;
  end;
end;

{Client side calls}
function RetrieveDeltas(const cdsArray : array of TClientDataset): Variant;
var
  i : integer;
  LowCDS, HighCDS : integer;
begin
  Result:=NULL;
  LowCDS:=Low(cdsArray);
  HighCDS:=High(cdsArray);
  for i:=LowCDS to HighCDS do
    cdsArray[i].CheckBrowseMode;

  Result:=VarArrayCreate([LowCDS, HighCDS], varVariant);
  {Setup the variant with the changes (or NULL if there are none)}
  for i:=LowCDS to HighCDS do
  begin
    if cdsArray[i].ChangeCount>0 then
      Result[i]:=cdsArray[i].Delta else
      Result[i]:=NULL;
  end;
end;

{We need to return the provider name AND the
 AppServer from this function. We will use ProviderName to call AS_ApplyUpdates
 in the CDSApplyUpdates function later.}
function RetrieveProviders(const cdsArray : array of TClientDataset): Variant;
var
  i: integer;
  LowCDS, HighCDS: integer;
begin
  Result:=NULL;
  LowCDS:=Low(cdsArray);
  HighCDS:=High(cdsArray);

  Result:=VarArrayCreate([LowCDS, HighCDS], varVariant);
  for i:=LowCDS to HighCDS do
    Result[i]:=VarArrayOf([cdsArray[i].AppServer, cdsArray[i].ProviderName]);
end;

procedure ReconcileDeltas(const cdsArray : array of TClientDataset; vDeltaArray: OleVariant);
var
  bReconcile : boolean;
  i: integer;
  LowCDS, HighCDS : integer;
begin
  LowCDS:=Low(cdsArray);
  HighCDS:=High(cdsArray);

  {If the previous step resulted in errors, Reconcile the error datapackets.}
  bReconcile:=false;
  for i:=LowCDS to HighCDS do
    if not VarIsNull(vDeltaArray[i]) then begin
      cdsArray[i].Reconcile(vDeltaArray[i]);
      bReconcile:=true;
      break;
    end;

  {Refresh the Datasets if needed}
  if not bReconcile then
    for i:=HighCDS downto LowCDS do begin
      cdsArray[i].Reconcile(vDeltaArray[i]);
      cdsArray[i].Refresh;
    end;
end;

end.
