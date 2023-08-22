unit AESPassWordDlg;

//dynamic and safe typed for CryptoBox AES

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons;

type
  TPasswordDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
  //PasswordDlg: TPasswordDlg;

implementation

{$R *.dfm}

end.
 
