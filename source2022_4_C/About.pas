unit About;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, SysUtils;

type
  TRCAboutBox = class(TForm)
    OKButton: TButton;
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProgramName: TLabel;
    Copyright: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RCAboutBox: TRCAboutBox;

procedure ShowAboutBox;

implementation

{$R *.dfm}

const
  SCopyright     = 'Copyleft 1996, 1998-2014 Borland and maXbox';

procedure ShowAboutBox;
begin
  with TRCAboutBox.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TRCAboutBox.FormCreate(Sender: TObject);
begin
  Caption := Format('About %s', [Application.Title]);
  ProgramIcon.Picture.Assign(Application.Icon);
  ProgramName.Caption := Application.Title;
  CopyRight.Caption := SCopyRight;
end;

end.

