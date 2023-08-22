
/////////////////////////////////////////////////////////
//                                                     //
//              Bold for Delphi                        //
//    Copyright (c) 1996-2002 Boldsoft AB              //
//              (c) 2002-2005 Borland Software Corp    //
//                                                     //
/////////////////////////////////////////////////////////


unit BoldEventQueue;

interface

uses
  Classes,
  BoldBase,
  BoldHashIndexes;

type
  { forwar declarations }
  TBoldEventQueueItem = class;
  TBoldEventQueue = class;
  TBoldEventQueueItemReceiverIndex = class;

  { TBoldEventQueueItem }
  TBoldEventQueueItem = class(TBoldMemoryManagedObject)
  private
    fEvent: TNotifyEvent;
    fSender: TObject;
    fReceiver: TObject;
  public
    constructor Create(Event: TNotifyEvent; Sender: TObject; Receiver: TObject);
    property Event: TNotifyEvent read fEvent;
    property Sender: Tobject read fSender;
    property Receiver: TObject read fReceiver;
    procedure SendEvent;
  end;

  { TBoldEventQueue }
  TBoldEventQueue = class(TBoldMemoryManagedObject)
  private
    fItemIndex: TBoldEventQueueItemReceiverIndex;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Event: TNotifyEvent; Sender: TObject; Receiver: TObject);
    procedure DequeueOne;
    procedure DequeueAll;
    procedure RemoveAllForReceiver(Receiver: TObject);
  end;

  { TBoldEventQueueItemReceiverIndex }
  TBoldEventQueueItemReceiverIndex = class(TBoldObjectHashIndex)
  protected
    function ItemAsKeyObject(Item: TObject): TObject; override;
  end;

implementation

uses
  SysUtils,
  BoldGuard;

{ TBoldEventQueueItem }

constructor TBoldEventQueueItem.Create(Event: TNotifyEvent; Sender: TObject; Receiver: TObject);
begin
  fEvent := Event;
  fSender := Sender;
  fReceiver := Receiver;
end;

procedure TBoldEventQueueItem.SendEvent;
begin
  Event(Sender);
end;

{ TBoldEventQueue }

procedure TBoldEventQueue.Add(Event: TNotifyEvent; Sender: TObject; Receiver: TObject);
begin
  fItemIndex.Add(TBoldEventQueueItem.Create(Event, Sender, Receiver));
end;

constructor TBoldEventQueue.Create;
begin
  inherited Create;
  fItemIndex := TBoldEventQueueItemReceiverIndex.Create;
end;

procedure TBoldEventQueue.DequeueAll;
var
  InternalCount,
  i: Integer;
begin
  InternalCount := fItemIndex.Count;
  for i := 0 to InternalCount - 1 do
    DequeueOne;
end;

procedure TBoldEventQueue.DequeueOne;
var
  item: TBoldEventQueueItem;
begin
  item := TBoldEventQueueItem(fItemIndex.Any);
  fItemIndex.Remove(item);
  item.SendEvent;
  Item.Free;
end;

destructor TBoldEventQueue.Destroy;
begin
  FreeAndNil(fItemIndex);
  inherited;
end;

procedure TBoldEventQueue.RemoveAllForReceiver(Receiver: TObject);
var
  i: integer;
  item: TBoldEventQueueItem;
  MatchingItems: TList;
  g: IBoldGuard;
begin
  g := TBoldGuard.Create(MatchingItems);
  MatchingItems := TList.Create;
  fItemIndex.FindAllByObject(Receiver, MatchingItems);
  for i := 0 to MatchingItems.Count - 1 do
  begin
    Item := TBoldEventQueueItem(MatchingItems[i]);
    fItemIndex.Remove(Item);
    Item.Free;
  end;
end;

{ TBoldEventQueueItemReceiverIndex }

function TBoldEventQueueItemReceiverIndex.ItemASKeyObject(Item: TObject): TObject;
begin
  result := TBoldEventQueueItem(Item).Receiver;
end;

end.
