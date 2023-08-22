unit SwitchLed;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Menus;

type
  TLedColor=(Aqua, Pink, Purple, Red, Yellow, Green, Blue, Orange, Black); // Type couleur de la LED
  TLedState=(LedOn, LedOff, LedDisabled); // Type �tat de la LED

type
  TSwitchLed = class(TGraphicControl)
  private
    { D�clarations priv�es }
    FOnColor: TLedColor; // Champ objet OnColor
    FOffColor: TLedColor; // Champ objet OffColor
    FDisabledColor: TLedColor; // Champ objet DisabledColor
    FLedState: TLedState; // Champ objet LedState
    FAllowChanges: Boolean; // Champ objet AllowChanges
    FVersion, FAuthor: String; // Champs objet de la version et de l'auteur
    procedure SetOnLedColor(Value: TLedColor); // Proc�dure d�finition OnColor
    procedure SetOffLedColor(Value: TLedColor); // Proc�dure d�finition OffColor
    procedure SetDisabledLedColor(Value: TLedColor); // Proc�dure d�finition DisabledColor
    procedure SetLedState(Value: TLedState); // Proc�dure d�finition LedState
  protected
    { D�clarations prot�g�es }
  public
    { D�clarations publiques }
    constructor Create(AOwner: TComponent); override; // Constucteur h�rit�
    procedure Paint; override;  // Dessin du composant h�rit�

    function IntToLedColor(Int: Byte): TLedColor; // Fonctions utiles
    function LedColorToInt(LedColor: TLedColor): Byte;

    property Version: String read FVersion; // Propri�t�s cach�es version et auteur
    property Author: String read FAuthor;
  published
    { D�clarations publi�es }
    property OnColor: TLedColor read FOnColor write SetOnLedColor; // Propri�t� OnColor
    property OffColor: TLedColor read FOffColor write SetOffLedColor; // Propri�t� OffColor
    property DisabledColor: TLedColor read FDisabledColor write SetDisabledLedColor; // Propri�t� DisabledColor
    property LedState: TLedState read FLedState write SetLedState;  // Propri�t� LedState
    property AllowChanges: Boolean read FAllowChanges write FAllowChanges; // Propri�t� AllowChanges

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnStartDrag;
    property OnDragOver;
    property OnEndDrag; // On remet tous les �venements h�rit�s
    property OnDragDrop;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock; // Je ne suis pas s�r pour les docks ...
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
  inherited Create(AOwner); // Constructeur h�rit�
  Parent := TWinControl(AOwner); // Le parent sera un transtypage de AOwner
  FOnColor := Green; // Couleur ON par d�faut
  FOffColor := Red; // Couleur OFF par d�faut
  FDisabledColor := Black; // Couleur DISABLED par d�faut
  FLedState := LedOff; // Etat de la LED par d�faut
  FAllowChanges := True; // On autorise la modification des valeurs
  FVersion := '1.3';  // On fixe la version
  FAuthor := 'Bacterius'; // On fixe l'auteur
  Width := 13;
  Height := 13; // C'est la taille des bitmaps LEDs
end;

procedure TSwitchLed.SetOnLedColor(Value: TLedColor);
begin
 if not AllowChanges then Exit;  // Si on peut modifier
 FOnColor := Value; // On d�finit
 Paint; // On redessine le tout
end;

procedure TSwitchLed.SetOffLedColor(Value: TLedColor);
begin
 if not AllowChanges then Exit;  // Si on peut modifier
 FOffColor := Value; // On d�finit
 Paint; // On redessine le tout
end;

procedure TSwitchLed.SetDisabledLedColor(Value: TLedColor);
begin
 if not AllowChanges then Exit;  // Si on peut modifier
 FDisabledColor := Value; // On d�finit
 Paint; // On redessine le tout
end;

procedure TSwitchLed.SetLedState(Value: TLedState);
begin
 if not AllowChanges then Exit; // Si on peut modifier
 FLedState := Value;  // On d�finit
 Paint; // On redessine le tout
end;

procedure TSwitchLed.Paint;
Var
 Colors: array [1..9] of TBitmap;  // Tableau des bitmaps couleur
 OnID, OffID, DisID: Byte;  // IDs tableau de On et Off
 I: Byte;  // Variable contr�le de boucle
begin
  if Width <> 13 then Width := 13;  // On empeche de redimensionner
  if Height <> 13 then Height := 13;

  for I := 1 to Length(Colors) do
   begin
    Colors[I] := TBitmap.Create; // On cr�e les bitmaps
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
  // D�finit l'index selon la couleur ON

  OffID := LedColorToInt(OffColor) + 1;
  // D�finit l'index selon la couleur OFF

  DisID := LedColorToInt(DisabledColor) + 1;
  // D�finit l'index selon la couleur Disabled

  case LedState of
  LedOn: Canvas.Draw(0, 0, Colors[OnID]);  // On dessine selon l'�tat
  LedOff: Canvas.Draw(0, 0, Colors[OffID]);
  LedDisabled: Canvas.Draw(0, 0, Colors[DisID]);
  end;

  for I := 1 to Length(Colors) do Colors[I].Free; // On lib�re

  // On dessine
end;

function TSwitchLed.IntToLedColor(Int: Byte): TLedColor;
begin
 if not (Int in [0..8]) then // Si hors limites, on d�clenche une exception
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
