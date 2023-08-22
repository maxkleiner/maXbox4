{**********************************************************}
{                                                          }
{       Borland Delphi                                    }
{       InterBase EventAlerter components                  }
{       Copyright (c) 1995, 1999-2002 Borland Corporation  }
{                                                          }
{       Written by:                                        }
{         James Thorpe                                     }
{         CSA Australasia                                  }
{         Compuserve: 100035,2064                          }
{         Internet:   csa@csaa.com.au                      }
{                                                          }
{**********************************************************}

unit IBEvnts;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Grids, IBCtrls;

type
  TIBEAEventsEditor = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    cEvents: TStringGrid;
    RequestedEvents: TLabel;
    bOK: TButton;
    bCancel: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function EditAlerterEvents( Events: TStrings): Boolean;

var
  IBEAEventsEditor: TIBEAEventsEditor;

implementation

{$R *.dfm}

function EditAlerterEvents( Events: TStrings): Boolean;
var
  i: integer;
begin
  result := false;
  with TIBEAEventsEditor.Create(Application) do
  begin
    try
      for i := 0 to Events.Count-1 do
        cEvents.Cells[1, i] := Events[i];
      if ShowModal = idOk then
      begin
        result := true;
        Events.Clear;
        for i := 0 to MaxEvents-1 do
          if length( cEvents.Cells[1, i]) <> 0 then
            Events.Add( cEvents.Cells[1, i]);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TIBEAEventsEditor.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to MaxEvents do
    cEvents.Cells[0, i-1] := IntToStr( i);
end;

end.
