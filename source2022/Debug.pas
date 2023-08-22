unit Debug;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmDebug = class(TForm)
    RichEdit1: TRichEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDebug: TfrmDebug;

implementation

{$R *.DFM}

procedure TfrmDebug.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caNone;
end;

procedure TfrmDebug.FormCreate(Sender: TObject);
begin
  RichEdit1.Perform(EM_SETLIMITTEXT,MAXINT,0);
end;

end.
