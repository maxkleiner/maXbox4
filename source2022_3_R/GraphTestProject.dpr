program GraphTestProject;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  Unit2 in 'Unit2.pas' {frmCopy};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmCopy, frmCopy);
  Application.Run;
end.
