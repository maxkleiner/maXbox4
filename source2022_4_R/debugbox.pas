unit DebugBox;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls;

type
  TPositions = (poTopLeft,poBottomLeft,poTopRight,poBottomRight);

  TDebugBox = class(TComponent)
  private
    DebugForm : TForm;
    DebugList : TListBox;
    FPosition : TPositions;
    FVisible  : Boolean;
    FWidth    : Integer;
    FHeight   : Integer;
    FCaption  : String;
    procedure SetPosition(A: TPositions);
    procedure SetVisible(A: Boolean);

    procedure SetWidth(A: Integer);
    procedure SetHeight(A: Integer);
    procedure SetCaption(A: String);
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure Add(A: String);
    procedure Clear;
    //procedure LoadLines(FName: String);
    //procedure SaveLines(FName: String);
  published
    property Caption: String read FCaption write SetCaption;

    property Position: TPositions read FPosition write SetPosition default poTopRight;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Width: Integer read FWidth write SetWidth default 250;
    property Height: Integer read FHeight write SetHeight default 200;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Dialogs', [TDebugBox]);

end;

constructor TDebugBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPosition := poTopRight;
  FVisible := False;
  FWidth := 350;
  FHeight := 400;
  FCaption := 'mX Debug Box';
  if not (csDesigning in ComponentState) then
    begin
      DebugForm := TForm.Create(Application);
      with DebugForm do begin
          Visible := FVisible;
          Caption := FCaption;

          FormStyle := fsStayOnTop;
          BorderStyle := bsSizeable;
          BorderIcons := [biSystemMenu];
        end;
      DebugList := TListBox.Create(DebugForm);
      with DebugList do
        begin
          Parent := DebugForm;
          Align := alClient;
          Sorted := False;
          Font.Name := 'Small Fonts';
          Font.Size := 7;
        end;
    end;
end;

procedure TDebugBox.SetPosition(A: TPositions);

begin
  FPosition := A;
  if not (csDesigning in ComponentState) then with DebugForm do
    case A of
      poTopLeft     : SetBounds(0,0,Width,Height);
      poBottomLeft  : SetBounds(0,Screen.Height-Height,Width,Height);
      poTopRight    : SetBounds(Screen.Width-Width,0,Width,Height);
      poBottomRight : SetBounds(Screen.Width-Width,Screen.Height-Height,Width,Height);
    end;
end;

procedure TDebugBox.SetVisible(A: Boolean);
begin
  FVisible := A;
  if not (csDesigning in ComponentState) then
    begin
      DebugForm.Hide;
      if A then
        begin
          Width := Self.Width;
          Height := Self.Height;
          SetPosition(FPosition);
          DebugForm.Show;
        end;
    end;
end;

procedure TDebugBox.SetWidth(A: Integer);
begin

  FWidth := A;
  if not (csDesigning in ComponentState) then
    begin
      DebugForm.Width := FWidth;
      SetPosition(FPosition);
    end;
end;

procedure TDebugBox.SetHeight(A: Integer);
begin
  FHeight := A;
  if not (csDesigning in ComponentState) then
    begin
      DebugForm.Height := FHeight;
      SetPosition(FPosition);
    end;
end;

procedure TDebugBox.SetCaption(A: String);

begin
  FCaption := A;
  if not (csDesigning in ComponentState) then
    DebugForm.Caption := FCaption;
end;

procedure TDebugBox.Add(A: String);
begin
  DebugList.Items.Add(A);
  {This makes sure the item just added is visible}
  DebugList.ItemIndex := DebugList.Items.Count-1;
end;

procedure TDebugBox.Clear;
begin
  {Remove all items from the list box}
  DebugList.Items.Clear;
end;

end.

Copyright ©1995 - Prime Time Programming