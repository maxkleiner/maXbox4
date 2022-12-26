unit UCardComponentV2;
{TCard component for Delphi 32 - Freeware.
Version 1.2 (1-12-98)
Copyright 1998 by Giulio Ferrari
EMail: giuliof@iol.it
Homepage: www.geocities.com/SiliconValley/Lab/2106

This is Freeware. Feel free to improve the code and to use the component
as you like. Please share your Delphi components and support the
freeware concept. I'm not responsible for any damage on your computer.

PROPERTIES
property Value;
   The value of the card, between 1 and 13 ( 11,12,13 are court cards;
   1 is the ace).
property Suit;
   The suit of the card (Hearts,Clubs,Diamonds,Spades).
property ShowDeck;
   If True shows the back of the card.
property DeckType;
   Select the type of deck that is shown if ShowDeck is True.
property Rank;
   A integer value useful to combine cards in decks.

METHODS
procedure SetCard(CValue: Integer; CSuit: TShortSuit);
   Quickly set card's Value and Suit.
   e.g. Card1.SetCard(1,H);  // set card to Ace of Hearts
procedure Turn;
   Turn the card and show the deck, or viceversa.
procedure RandomCard;
   Randomly choose a card.
function DifferentFrom(FromCard: TCard): Boolean;
   Returns True if the card is different in Value or Suit
   from the specified one.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TCardValue = 1..13;
  TCardSuit = (Spades,Diamonds,Clubs,Hearts);
  TShortSuit = (S,D,C,H);
  TDecks = (Standard1, Standard2, Fishes1, Fishes2,
           Beach, Leaves1, Leaves2, Robot,
           Roses, Shell, Castle, Hand);
  TCard = class(TGraphicControl)
  private
    FValue: TCardValue;
    FSuit: TCardSuit;
    FDeckType: TDecks;
    FShowDeck: Boolean;
    FRank: Integer;
    procedure WMSize(var Message: TWMSize); message WM_PAINT;
    procedure SetValue(Value : TCardValue);
    procedure SetSuit(Suit: TCardSuit);
    procedure SetShowDeck(ShowDeck: Boolean);
    procedure SetDeckType(DeckType: TDecks);
    procedure SetRank(Rank: Integer);
  protected
    FOnMouseUp:TMouseEvent;
    property canvas;   {expose canvas so card image can be modified}  
    property Height default 96;
    property Width default 71;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetCard(CValue: Integer; CSuit: TShortSuit);
    procedure RandomCard;
    procedure Turn;
    function DifferentFrom(FromCard: TCard): Boolean;
  published
    property Value: TCardValue read FValue write SetValue;
    property Suit: TCardSuit read FSuit write SetSuit;
    property ShowDeck: Boolean read FShowDeck write SetShowDeck;
    property DeckType: TDecks read FDeckType write SetDeckType;
    property Rank: Integer read FRank write SetRank;
    property DragMode;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

{procedure Register;}
  TDeck = class(Tobject)
    DeckObj:array of TCard; {TCard is graphics image component for card}
    NextCard:integer; {Card nbr of next card}
    DeckLoc:TPoint; {Top left corner of deck}
    Decksize:integer; {number of cards in the deck}
    constructor create(Aowner:TForm; newloc:TPoint; newdecksize:integer); overload;
    constructor create(Aowner:TForm; newloc:TPoint); overload;
    destructor destroy; override;
    Procedure shuffle;  {Shuffle the deck}
    procedure NoShowShuffle;  {shuffle without making the deck visible}
    function GetNextCard(var card:TCard):boolean; {Get the top card, if any left}
    function GetCardNbr(Suit:TCardSuit; Value:TCardValue):integer;
    procedure hidecards(const hidethem:boolean);
  end;

 var Deck:TDeck;

implementation

{$R UCardComponentV2.RES}
{****$R Cards.RES}

constructor TCard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 96;
  Width := 71;
  FValue := 1;
  FSuit := Hearts;
  FDeckType := Standard1;
  FShowDeck := False;
  {Randomize; }
  dragmode:=dmmanual;
end;

destructor TCard.Destroy;
begin
  inherited Destroy;
end;

procedure TCard.WMSize(var Message: TWMSize); // No resizing allowed !
begin
  inherited;
  Width := 71;
  Height := 96;
end;

procedure TCard.SetValue(Value : TCardValue);
begin
  if Value<1 then Value := 1;
  if Value>13 then Value :=13;
  FValue := Value;
  Paint;
end;

procedure TCard.SetSuit(Suit: TCardSuit);
begin
  FSuit := Suit;
  Paint;
end;

procedure TCard.SetShowDeck(ShowDeck: Boolean);
begin
  FShowDeck := ShowDeck;
  Paint;
end;

procedure TCard.SetDeckType(DeckType: TDecks);
begin
  FDeckType := DeckType;
  paint;
end;

procedure TCard.SetRank(Rank: Integer);
begin
  FRank := Rank;
end;

procedure TCard.SetCard(CValue: Integer; CSuit: TShortSuit);
begin
  if (CValue>0) and (CValue<14) then Value := CValue;
  if CSuit in [C,H,S,D] then
    case CSuit of
      C: Suit := Clubs;
      H: Suit := Hearts;
      S: Suit := Spades;
      D: Suit := Diamonds;
    end;
end;

procedure TCard.Turn;
begin
  ShowDeck := not ShowDeck;
end;

procedure TCard.RandomCard;
var Rand: Integer;
begin
  Rand := Random(4)+1;
  if Rand=1 then FSuit := Hearts
  else if Rand=2 then FSuit := Clubs
  else if Rand=3 then FSuit := Spades
  else FSuit := Diamonds;
  Rand := Random(13)+1;
  FValue := Rand;
  Paint;
end;

function TCard.DifferentFrom(FromCard: TCard): Boolean;
begin
  if (FSuit <> FromCard.Suit)
  or (FValue <> FromCard.Value)
  then DifferentFrom := True
  else DifferentFrom := False;
end;

procedure TCard.Paint;
var CardBitmap: TBitmap;
    ResName: String;
begin
  if not visible then exit;
  CardBitmap := TBitmap.Create;
  if not ShowDeck then
  begin   // show selected card
    case FSuit of
    Hearts: ResName := 'H';
    Spades: ResName := 'S';
    Clubs: ResName := 'C';
    Diamonds: ResName := 'D';

    end;
    ResName := ResName+IntToStr(FValue);
  end
  else                         // show selected deck
    case DeckType of
    Standard1: ResName := 'STD1';
    Standard2: ResName := 'STD2';
    Fishes1: ResName := 'FISHES1';
    Fishes2: ResName := 'FISHES2';
    Beach: ResName := 'BEACH';
    Leaves1: ResName := 'LEAVES1';
    Leaves2: ResName := 'LEAVES2';
    Robot: ResName := 'ROBOT';
    Roses: ResName := 'ROSES';
    Shell: ResName := 'SHELL';
    Castle: ResName := 'CASTLE';
    Hand: ResName := 'HAND';
    end;

  // load bitmap from resources
  CardBitmap.LoadFromResourceName(HInstance,ResName);
  Canvas.Draw(0,0,CardBitmap);
  //Canvas.Brush.Color := (Owner as TForm).Color;
  //Canvas.FloodFill(0,0,clBlack,fsBorder);
  //Canvas.FloodFill(70,0,clBlack,fsBorder);
  //Canvas.FloodFill(0,95,clBlack,fsBorder);
  //Canvas.FloodFill(70,95,clBlack,fsBorder);
  CardBitmap.Free;
end;



{Deck methods}
Constructor TDeck.create(Aowner:TForm; Newloc:TPoint; newdecksize:integer);
var val:TCardValue;
    newsuit:TCardSuit;
    i:integer;
  begin
    inherited create;
    deckloc:=newloc;
    decksize:=newdecksize;
    If decksize>52 then decksize:=52
    else if decksize<1 then decksize:=1;
    setlength(deckobj,decksize);
    i:=0;
    for val := low(TCardValue) to high(TCardValue) do
       for newsuit:=low(TCardSuit) to high(TCardSuit) do
    if i<decksize then
    begin
      deckObj[i]:=TCard.create(Aowner);
      with deckobj[i] do
      Begin   {assign values to the new card}
        parent:=Aowner;
        visible:=false;
        value:=val;
        suit:=newsuit;
        left:=deckloc.x;
        top:=deckloc.y;
      end;
      inc(i);
    end;
    with deckobj[decksize-1] do
    Begin
      showdeck:=true;
      visible:=true;
    end;
    randomize;
  end;

Constructor TDeck.create(Aowner:TForm; Newloc:TPoint);
begin
  create(Aowner, Newloc, 52);
end;

Destructor TDeck.destroy;
var
  i:integer;
Begin
  for i:=0 to decksize-1 do deckobj[i].free;
  inherited;
end;


Procedure tDeck.shuffle;
var
  i,j:integer;
  c:TCard;
begin
  randomize;
  {Modifed 8/30/06 to exchange from back to front of deck
   and to only exchange with cards in positions 0 thru i}
  for i:= decksize-1 downto 1 do
  {swap card i with a random card}
  Begin
    j:=random(i+1 {decksize});
    c:=deckobj[i];
    deckobj[i]:=deckobj[j];
    deckobj[j]:=c;
    {make the deck jiggle a little so user knows that something is happening}
    if i mod 2 = 0 then deckobj[i].left:= 8;
    deckobj[i].paint;
  end;
  for i:= 0 to decksize-1 do
  {reset the cards}
  with deckobj[i] do
  begin
    left:=deckloc.x;
    top:=deckloc.y;
    showdeck:=true;
    visible:=true;
    bringtofront;
  end;
  Nextcard:=decksize-1; {set initial card to top of deck}
end;

Procedure tDeck.NoShowShuffle;
{Shuffle procedure with visuals removed}
var
  i,j:integer;
  c:TCard;
begin
  {randomize; } {moved to create}
  for i:= 0 to decksize-1 do
  {swap card i with a random card}
  Begin
    j:=random(decksize);
    c:=deckobj[i];
    deckobj[i]:=deckobj[j];
    deckobj[j]:=c;
  end;
  Nextcard:=decksize-1; {set initial card to top of deck}

end;

procedure TDeck.hidecards(const hidethem:boolean);
var i:integer;
begin
  for i:= 0 to high(deckobj) do deckobj[i].visible:=not hidethem;
end;

function TDeck.GetNextCard(var card:TCard):boolean;
begin
  If nextcard>=0 then
  Begin
    card:=deckobj[nextcard]; {get the card}
    result:=true;
    dec(nextcard); {move the nextcard pointer down}
    If nextcard>=0 then
    with deckobj[nextcard] do
    Begin
      visible:=true;
      showdeck:=true;
    end;
  end
  else result:=false;
end;

function TDeck.GetCardNbr(Suit:TCardSuit; Value:TCardValue):integer;
var
  i:integer;
begin
  result:=-1;
  for i:=0 to 51 do
  begin
    if (deckobj[i].suit=Suit) and (deckobj[i].value=value)
    then
    begin
      result:=i;
      exit;
    end;
  end;
end;

end.
