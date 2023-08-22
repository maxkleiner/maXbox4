{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10243: IdMailBox.pas 
{
{   Rev 1.0    2002.11.12 10:44:54 PM  czhower
}
unit IdMailBox;

{*

  IdMailBox (Created for use with the IdIMAP4 unit)
  By Idan Cohen i_cohen@yahoo.com

  2001-FEB-27 IC: First version, most of the needed MailBox features are implemented,
                  next version should include a MailBox list structure that will hold
                  an entire account mail box structure with the updated information.
  2001-MAY-05 IC:

*}

interface

uses
  Classes,
  IdBaseComponent,
  IdException,
  IdMessage,
  IdMessageCollection,
  SysUtils;

type
  TIdMailBoxState = ( msReadWrite, msReadOnly );

  TIdMailBoxAttributes = ( maNoinferiors, maNoselect, maMarked, maUnmarked );

  TIdMailBoxAttributesSet = set of TIdMailBoxAttributes;

  TLongIntArray = array of LongInt;

  TIdMailBox = class(TIdBaseComponent)
  protected
    FAttributes: TIdMailBoxAttributes;
    FChangeableFlags: TIdMessageFlagsSet;
    FFirstUnseenMsg: LongInt;
    FFlags: TIdMessageFlagsSet;
    FName: String;
    FMessageList: TIdMessageCollection;
    FRecentMsgs: LongInt;
    FState: TIdMailBoxState;
    FTotalMsgs: LongInt;
    FUIDNext: String;
    FUIDValidity: String;
    FUnseenMsgs: LongInt;

    procedure SetMessageList(const Value: TIdMessageCollection);
  public
    DeletedMsgs: TLongIntArray;
    SearchResult: TLongIntArray;
    property Attributes: TIdMailBoxAttributes read FAttributes write FAttributes;
    property ChangeableFlags: TIdMessageFlagsSet read FChangeableFlags write FChangeableFlags;
    property FirstUnseenMsg: LongInt read FFirstUnseenMsg write FFirstUnseenMsg;
    property Flags: TIdMessageFlagsSet read FFlags write FFlags;
    property Name: String read FName write FName;
    property MessageList: TIdMessageCollection read FMessageList write SetMessageList;
    property RecentMsgs: LongInt read FRecentMsgs write FRecentMsgs;
    property State: TIdMailBoxState read FState write FState;
    property TotalMsgs: LongInt read FTotalMsgs write FTotalMsgs;
    property UIDNext: String read FUIDNext write FUIDNext;
    property UIDValidity: String read FUIDValidity write FUIDValidity;
    property UnseenMsgs: LongInt read FUnseenMsgs write FUnseenMsgs;
    procedure Clear; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

const
  MailBoxAttributes : array [maNoinferiors..maUnmarked] of String =
  ( '\Noinferiors', //It is not possible for any child levels of    {Do not Localize}
                   //hierarchy to exist under this name; no child levels
                   //exist now and none can be created in the future.
   '\Noselect',    //It is not possible to use this name as a selectable    {Do not Localize}
                   //mailbox.
   '\Marked',      //The mailbox has been marked "interesting" by the    {Do not Localize}
                   //server; the mailbox probably contains messages that
                   //have been added since the last time the mailbox was
                   //selected.
   '\Unmarked' );  //The mailbox does not contain any additional    {Do not Localize}
                   //messages since the last time the mailbox was
                   //selected.

implementation

{ TIdMailBox }

procedure TIdMailBox.Clear;
begin
     FTotalMsgs := 0;
     FRecentMsgs := 0;
     FUnseenMsgs := 0;
     FFirstUnseenMsg := 0;
     FUIDValidity := '';    {Do not Localize}
     FUIDNext := '';    {Do not Localize}
     FName := '';    {Do not Localize}
     FState := msReadOnly;
     FAttributes := maNoselect;
     SetLength ( DeletedMsgs, 0 );
     SetLength ( SearchResult, 0 );
     FFlags := [];
     FChangeableFlags := [];
     MessageList.Clear;
end;

constructor TIdMailBox.Create(AOwner: TComponent);
begin
     inherited;
     FMessageList := TIdMessageCollection.Create ( TIdMessageItem );
     Clear;
end;

destructor TIdMailBox.Destroy;
begin
     MessageList.Free;
     inherited;
end;

procedure TIdMailBox.SetMessageList(const Value: TIdMessageCollection);
begin
     if Value is TCollection then Beep;
     FMessageList.Assign ( Value );
end;

end.
