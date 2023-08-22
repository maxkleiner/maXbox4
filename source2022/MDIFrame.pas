unit MDIFrame;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  Menus;

type
  TFrameForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Window1: TMenuItem;
    Tile1: TMenuItem;
    Cascade1: TMenuItem;
    Arrangeicons1: TMenuItem;
    OpenFileDialog: TOpenDialog;
    procedure Exit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
    procedure Cascade1Click(Sender: TObject);
    procedure Arrangeicons1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure RunMDIForm;


var
  FrameForm: TFrameForm;

implementation

uses MDIEdit;

{$R *.dfm}

  procedure RunMDIForm;
  begin
   //Application.CreateForm(TFrameForm, FrameForm);
   FrameForm:= TFrameForm.Create(NIL);
   FrameForm.Show;
  end;

procedure TFrameForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrameForm.New1Click(Sender: TObject);
begin
 //Application.CreateForm(TEditForm, EditForm);
  EditForm:= TEditForm.Create(self);
  //TEditForm.Create(Self);
end;

procedure TFrameForm.Tile1Click(Sender: TObject);
begin
  Tile;
end;

procedure TFrameForm.Cascade1Click(Sender: TObject);
begin
  Cascade;
end;

procedure TFrameForm.Arrangeicons1Click(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TFrameForm.Open1Click(Sender: TObject);
begin
  if OpenFileDialog.Execute then
  with TEditForm.Create(Self) do
    Open(OpenFileDialog.FileName);
end;

end.
