program ResXplor;

{%File 'ModelSupport\default.txaPackage'}

uses
  Forms,
  ExeImage,
  RXMain in 'RXMain.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Resource Explorer';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
