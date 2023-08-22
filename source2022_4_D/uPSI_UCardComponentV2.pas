unit uPSI_UCardComponentV2;
{
   play the card
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_UCardComponentV2 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDeck(CL: TPSPascalCompiler);
procedure SIRegister_TCard(CL: TPSPascalCompiler);
procedure SIRegister_UCardComponentV2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDeck(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCard(CL: TPSRuntimeClassImporter);
procedure RIRegister_UCardComponentV2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,UCardComponentV2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UCardComponentV2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDeck(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TDeck') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TDeck') do begin
    RegisterProperty('DeckObj', 'array of TCard', iptrw);
    RegisterProperty('NextCard', 'integer', iptrw);
    RegisterProperty('DeckLoc', 'TPoint', iptrw);
    RegisterProperty('Decksize', 'integer', iptrw);
    RegisterMethod('Constructor create( Aowner : TForm; newloc : TPoint; newdecksize : integer);');
    RegisterMethod('Constructor create1( Aowner : TForm; newloc : TPoint);');
    RegisterMethod('Procedure shuffle');
    RegisterMethod('Procedure NoShowShuffle');
    RegisterMethod('Function GetNextCard( var card : TCard) : boolean');
    RegisterMethod('Function GetCardNbr( Suit : TCardSuit; Value : TCardValue) : integer');
    RegisterMethod('Procedure hidecards( const hidethem : boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCard(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TCard') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TCard') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SetCard( CValue : Integer; CSuit : TShortSuit)');
    RegisterMethod('Procedure RandomCard');
    RegisterMethod('Procedure Turn');
    RegisterMethod('Function DifferentFrom( FromCard : TCard) : Boolean');
    RegisterProperty('Value', 'TCardValue', iptrw);
    RegisterProperty('Suit', 'TCardSuit', iptrw);
    RegisterProperty('ShowDeck', 'Boolean', iptrw);
    RegisterProperty('DeckType', 'TDecks', iptrw);
    RegisterProperty('Rank', 'Integer', iptrw);
    RegisterProperty('OnPaint', 'TNotifyEvent', iptrw);
    RegisterPublishedProperties;
       RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UCardComponentV2(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCardValue', 'Integer');
  CL.AddTypeS('TCardSuit', '( Spades, Diamonds, Clubs, Hearts )');
  CL.AddTypeS('TShortSuit', '( cardS, cardD, cardC, cardH )');
  CL.AddTypeS('TDecks', '( Standard1, Standard2, Fishes1, Fishes2, Beach, Leaves1, Leaves2, Robot, Roses, Shell, Castle, Hand )');
  SIRegister_TCard(CL);
  SIRegister_TDeck(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TDeckcreate1_P(Self: TClass; CreateNewInstance: Boolean;  Aowner : TForm; newloc : TPoint):TObject;
Begin Result := TDeck.create(Aowner, newloc); END;

(*----------------------------------------------------------------------------*)
Function TDeckcreate_P(Self: TClass; CreateNewInstance: Boolean;  Aowner : TForm; newloc : TPoint; newdecksize : integer):TObject;
Begin Result := TDeck.create(Aowner, newloc, newdecksize); END;

(*----------------------------------------------------------------------------*)
procedure TDeckDecksize_W(Self: TDeck; const T: integer);
Begin Self.Decksize := T; end;

(*----------------------------------------------------------------------------*)
procedure TDeckDecksize_R(Self: TDeck; var T: integer);
Begin T := Self.Decksize; end;

(*----------------------------------------------------------------------------*)
procedure TDeckDeckLoc_W(Self: TDeck; const T: TPoint);
Begin Self.DeckLoc := T; end;

(*----------------------------------------------------------------------------*)
procedure TDeckDeckLoc_R(Self: TDeck; var T: TPoint);
Begin T := Self.DeckLoc; end;

(*----------------------------------------------------------------------------*)
procedure TDeckNextCard_W(Self: TDeck; const T: integer);
Begin Self.NextCard := T; end;

(*----------------------------------------------------------------------------*)
procedure TDeckNextCard_R(Self: TDeck; var T: integer);
Begin T := Self.NextCard; end;

(*----------------------------------------------------------------------------*)
procedure TDeckDeckObj_W(Self: TDeck; const T: array of TCard);
Begin //Self.DeckObj := T;
end;

(*----------------------------------------------------------------------------*)
procedure TDeckDeckObj_R(Self: TDeck; var T: array of TCard);
Begin //T := Self.DeckObj;
end;

(*----------------------------------------------------------------------------*)
procedure TCardOnPaint_W(Self: TCard; const T: TNotifyEvent);
begin Self.OnPaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCardOnPaint_R(Self: TCard; var T: TNotifyEvent);
begin T := Self.OnPaint; end;

(*----------------------------------------------------------------------------*)
procedure TCardRank_W(Self: TCard; const T: Integer);
begin Self.Rank := T; end;

(*----------------------------------------------------------------------------*)
procedure TCardRank_R(Self: TCard; var T: Integer);
begin T := Self.Rank; end;

(*----------------------------------------------------------------------------*)
procedure TCardDeckType_W(Self: TCard; const T: TDecks);
begin Self.DeckType := T; end;

(*----------------------------------------------------------------------------*)
procedure TCardDeckType_R(Self: TCard; var T: TDecks);
begin T := Self.DeckType; end;

(*----------------------------------------------------------------------------*)
procedure TCardShowDeck_W(Self: TCard; const T: Boolean);
begin Self.ShowDeck := T; end;

(*----------------------------------------------------------------------------*)
procedure TCardShowDeck_R(Self: TCard; var T: Boolean);
begin T := Self.ShowDeck; end;

(*----------------------------------------------------------------------------*)
procedure TCardSuit_W(Self: TCard; const T: TCardSuit);
begin Self.Suit := T; end;

(*----------------------------------------------------------------------------*)
procedure TCardSuit_R(Self: TCard; var T: TCardSuit);
begin T := Self.Suit; end;

(*----------------------------------------------------------------------------*)
procedure TCardValue_W(Self: TCard; const T: TCardValue);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TCardValue_R(Self: TCard; var T: TCardValue);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDeck(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDeck) do
  begin
    RegisterPropertyHelper(@TDeckDeckObj_R,@TDeckDeckObj_W,'DeckObj');
    RegisterPropertyHelper(@TDeckNextCard_R,@TDeckNextCard_W,'NextCard');
    RegisterPropertyHelper(@TDeckDeckLoc_R,@TDeckDeckLoc_W,'DeckLoc');
    RegisterPropertyHelper(@TDeckDecksize_R,@TDeckDecksize_W,'Decksize');
    RegisterConstructor(@TDeckcreate_P, 'create');
    RegisterConstructor(@TDeckcreate1_P, 'create1');
    RegisterMethod(@TDeck.shuffle, 'shuffle');
    RegisterMethod(@TDeck.NoShowShuffle, 'NoShowShuffle');
    RegisterMethod(@TDeck.GetNextCard, 'GetNextCard');
    RegisterMethod(@TDeck.GetCardNbr, 'GetCardNbr');
    RegisterMethod(@TDeck.hidecards, 'hidecards');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCard(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCard) do
  begin
    RegisterConstructor(@TCard.Create, 'Create');
    RegisterMethod(@TCard.SetCard, 'SetCard');
    RegisterMethod(@TCard.RandomCard, 'RandomCard');
    RegisterMethod(@TCard.Turn, 'Turn');
    RegisterMethod(@TCard.DifferentFrom, 'DifferentFrom');
    RegisterPropertyHelper(@TCardValue_R,@TCardValue_W,'Value');
    RegisterPropertyHelper(@TCardSuit_R,@TCardSuit_W,'Suit');
    RegisterPropertyHelper(@TCardShowDeck_R,@TCardShowDeck_W,'ShowDeck');
    RegisterPropertyHelper(@TCardDeckType_R,@TCardDeckType_W,'DeckType');
    RegisterPropertyHelper(@TCardRank_R,@TCardRank_W,'Rank');
    RegisterPropertyHelper(@TCardOnPaint_R,@TCardOnPaint_W,'OnPaint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UCardComponentV2(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCard(CL);
  RIRegister_TDeck(CL);
end;

 
 
{ TPSImport_UCardComponentV2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UCardComponentV2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UCardComponentV2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UCardComponentV2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UCardComponentV2(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
