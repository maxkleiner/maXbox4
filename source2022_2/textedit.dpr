program TextEdit;

uses
  Forms,
  MDIFrame in 'MDIFrame.pas' {FrameForm},
  MDIEdit in 'MDIEdit.pas' {EditForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrameForm, FrameForm);
  Application.Run;
end.
