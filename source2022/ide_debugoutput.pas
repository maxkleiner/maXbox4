unit ide_debugoutput;


//registered as runtime output in winform1puzzle

interface

uses
  Windows, Forms, Controls, StdCtrls, Classes;

type
  Tdebugoutput = class(TForm)
    output: TMemo;
  private
  public
    mycaption: string;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  debugout: Tdebugoutput;

implementation

{$R *.dfm}

{ Tdebugoutput }

procedure Tdebugoutput.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
  debugout.Caption:= myCaption;
end;

end.
