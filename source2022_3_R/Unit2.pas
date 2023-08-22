unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TfrmCopy = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCopy: TfrmCopy;

implementation

{$R *.DFM}

procedure TfrmCopy.FormShow(Sender: TObject);
begin
  Image1.Width := Image1.Picture.Bitmap.Width;
  Image1.Height := Image1.Picture.Bitmap.Height;
end;

end.
