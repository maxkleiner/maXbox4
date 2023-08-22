unit SwitchLed;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Menus;

type
  TLedColor=(Aqua, Pink, Purple, Red, Yellow, Green, Blue, Orange, Black); // Type couleur de la LED
  TLedState=(LedOn, LedOff, LedDisabled); // Type état de la LED

type
  TSwitchLed = class(TGraphicControl)
  private
    { Déclarations privées }
    FOnColor: TLedColor; // Champ objet OnColor
    FOffColor: TLedColor; // Champ objet OffColor
    FDisabledColor: TLedColor; // Champ objet DisabledColor
    FLedState: TLedState; // Champ objet LedState
    FAllowChanges: Boolean; // Champ objet AllowChanges
    FVersion, FAuthor: String; // Champs objet de la version et de l'auteur
    procedure SetOnLedColor(Value: TLedColor); // Procédure définition OnColor
    procedure SetOffLedColor(Value: TLedColor); // Procédure définition OffColor
    procedure SetDisabledLedColor(Value: TLedColor); // Procédure définition DisabledColor
    procedure SetLedState(Value: TLedState); // Procédure définition LedState
  protected
    { Déclarations protégées }
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override; // Constucteur hérité
    procedure Paint; override;  // Dessin du composant hérité

    function IntToLedColor(Int: Byte): TLedColor; // Fonctions utiles
    function LedColorToInt(LedColor: TLedColor): Byte;

    property Version: String read FVersion; // Propriétés cachées version et auteur
    property Author: String read FAuthor;
  published
    { Déclarations publiées }
    property OnColor: TLedColor read FOnColor write SetOnLedColor; // Propriété OnColor
    property OffColor: TLedColor read FOffColor write SetOffLedColor; // Propriété OffColor
    property DisabledColor: TLedColor read FDisabledColor write SetDisabledLedColor; // Propriété DisabledColor
    property LedState: TLedState read FLedState write SetLedState;  // Propriété LedState
    property AllowChanges: Boolean read FAllowChanges write FAllowChanges; // Propriété AllowChanges

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnStartDrag;
    property OnDragOver;
    property OnEndDrag; // On remet tous les évenements hérités
    property OnDragDrop;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock; // Je ne suis pas sûr pour les docks ...
    property OnEndDock;
    property PopupMenu; // On remet le popupmenu
    property ShowHint; // On remet ShowHint
    property Visible; // On remet Visible
  end;

procedure Register;

implementation

{$R Leds.res}

procedure Register;
begin
  RegisterComponents('Bacterius', [TSwitchLed]); // Recensement du composant
end;

constructor TSwitchLed.Create(AOwner: TComponent);
begin
  inherited Create(AOwner); // Constructeur hérité
  Parent := TWinControl(AOwner); // Le parent sera un transtypage de AOwner
  FOnColor := Green; // Couleur ON par défaut
  FOffColor := Red; // Couleur OFF par défaut
  FDisabledColor := Black; // Couleur DISABLED par défaut
  FLedState := LedOff; // Etat de la LED par défaut
  FAllowChanges := True; // On autorise la modification des valeurs
  FVersion := '1.3';  // On fixe la version
  FAuthor := 'Bacterius'; // On fixe l'auteur
  Width := 13;
  Height := 13; // C'est la taille des bitmaps LEDs
end;

procedure TSwitchLed.SetOnLedColor(Value: TLedColor);
begin
 if not AllowChanges then Exit;  // Si on peut modifier
 FOnColor := Value; // On définit
 Paint; // On redessine le tout
end;

procedure TSwitchLed.SetOffLedColor(Value: TLedColor);
begin
 if not AllowChanges then Exit;  // Si on peut modifier
 FOffColor := Value; // On définit
 Paint; // On redessine le tout
end;

procedure TSwitchLed.SetDisabledLedColor(Value: TLedColor);
begin
 if not AllowChanges then Exit;  // Si on peut modifier
 FDisabledColor := Value; // On définit
 Paint; // On redessine le tout
end;

procedure TSwitchLed.SetLedState(Value: TLedState);
begin
 if not AllowChanges then Exit; // Si on peut modifier
 FLedState := Value;  // On définit
 Paint; // On redessine le tout
end;

procedure TSwitchLed.Paint;
Var
 Colors: array [1..9] of TBitmap;  // Tableau des bitmaps couleur
 OnID, OffID, DisID: Byte;  // IDs tableau de On et Off
 I: Byte;  // Variable contrôle de boucle
begin
  if Width <> 13 then Width := 13;  // On empeche de redimensionner
  if Height <> 13 then Height := 13;

  for I := 1 to Length(Colors) do
   begin
    Colors[I] := TBitmap.Create; // On crée les bitmaps
    Colors[I].TransparentColor := clGreen;
    Colors[I].Transparent := True; // On fixe la transparence :)
   end;

  Colors[1].LoadFromResourceName(HInstance, 'AQUA');  // On charge tous les bitmaps depuis les ressources
  Colors[2].LoadFromResourceName(HInstance, 'PINK');
  Colors[3].LoadFromResourceName(HInstance, 'PURPLE');
  Colors[4].LoadFromResourceName(HInstance, 'RED');
  Colors[5].LoadFromResourceName(HInstance, 'YELLOW');
  Colors[6].LoadFromResourceName(HInstance, 'GREEN');
  Colors[7].LoadFromResourceName(HInstance, 'BLUE');
  Colors[8].LoadFromResourceName(HInstance, 'ORANGE');
  Colors[9].LoadFromResourceName(HInstance, 'BLACK');

  OnID := LedColorToInt(OnColor) + 1;
  // Définit l'index selon la couleur ON

  OffID := LedColorToInt(OffColor) + 1;
  // Définit l'index selon la couleur OFF

  DisID := LedColorToInt(DisabledColor) + 1;
  // Définit l'index selon la couleur Disabled

  case LedState of
  LedOn: Canvas.Draw(0, 0, Colors[OnID]);  // On dessine selon l'état
  LedOff: Canvas.Draw(0, 0, Colors[OffID]);
  LedDisabled: Canvas.Draw(0, 0, Colors[DisID]);
  end;

  for I := 1 to Length(Colors) do Colors[I].Free; // On libère

  // On dessine
end;

function TSwitchLed.IntToLedColor(Int: Byte): TLedColor;
begin
 if not (Int in [0..8]) then // Si hors limites, on déclenche une exception
  raise Exception.Create('Indice couleur hors limites (' + IntToStr(Int) + ').');

 case Int of
  0: Result := Aqua;
  1: Result := Pink;
  2: Result := Purple;
  3: Result := Red;   // Selon l'integer, on renvoie la couleur
  4: Result := Yellow;
  5: Result := Green;
  6: Result := Blue;
  7: Result := Orange;
  8: Result := Black;
 end;
end;

function TSwitchLed.LedColorToInt(LedColor: TLedColor): Byte;
begin
 case LedColor of
  Aqua: Result := 0;
  Pink: Result := 1;
  Purple: Result := 2;
  Red: Result := 3;   // Selon la couleur, on renvoie l'integer voulu
  Yellow: Result := 4;
  Green: Result := 5;
  Blue: Result := 6;
  Orange: Result := 7;
  Black: Result := 8;
 end;
end;

end.
