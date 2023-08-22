unit TrcView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TTraceForm = class(TForm)
    TraceData: TListBox;
    procedure TraceDataKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TraceForm: TTraceForm;

implementation

{$R *.dfm}

procedure TTraceForm.TraceDataKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

end.
