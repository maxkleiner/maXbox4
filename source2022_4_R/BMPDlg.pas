unit BMPDlg;

interface

uses Windows, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls;

type
  TNewBMPForm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    WidthEdit: TEdit;
    Label2: TLabel;
    HeightEdit: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewBMPForm: TNewBMPForm;

implementation

{$R *.dfm}

end.
