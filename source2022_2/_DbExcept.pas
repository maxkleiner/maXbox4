{*******************************************************}
{                                                       }
{       CodeGear Delphi Visual Component Library        }
{                                                       }
{  	    Copyright (c) 1995-2007 CodeGear	        }
{                                                       }
{*******************************************************}

unit DbExcept;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, DB, DBTables;

type
  TDbEngineErrorDlg = class(TForm)
    BasicPanel: TPanel;
    DetailsPanel: TPanel;
    BDELabel: TLabel;
    NativeLabel: TLabel;
    DbMessageText: TMemo;
    DbResult: TEdit;
    DbCatSub: TEdit;
    NativeResult: TEdit;
    BackBtn: TButton;
    NextBtn: TButton;
    ButtonPanel: TPanel;
    DetailsBtn: TButton;
    OKBtn: TButton;
    IconPanel: TPanel;
    IconImage: TImage;
    TopPanel: TPanel;
    ErrorText: TLabel;
    RightPanel: TPanel;
    procedure FormShow(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DetailsBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FPrevOnException: TExceptionEvent;
    FDbException: EDbEngineError;
    FDetailsHeight, CurItem: Integer;
    FDetails: string;
    procedure HandleException(Sender: TObject; E: Exception);
    procedure SwitchDetails;
    procedure ShowError;
  public
    procedure HookExceptions;
    function ShowException(Error: EDbEngineError): TModalResult;
    property DbException: EDbEngineError read FDbException write FDbException;
  end;

var
  DbEngineErrorDlg: TDbEngineErrorDlg;

implementation

{$R *.dfm}

procedure TDbEngineErrorDlg.HandleException(Sender: TObject; E: Exception);
begin
  if (E is EDbEngineError) and (DbException = nil) and
    not Application.Terminated then ShowException(EDbEngineError(E))
  else if Assigned(FPrevOnException) then FPrevOnException(Sender, E)
  else Application.ShowException(E);
end;

procedure TDbEngineErrorDlg.SwitchDetails;
const
  DetailsOn: array [Boolean] of string = ('%s >>', '<< %s');
var
  DEnabling: Boolean;
begin
  DEnabling := not DetailsPanel.Visible;
  if DEnabling then ClientHeight := FDetailsHeight
  else ClientHeight := DetailsPanel.Top;
  DetailsPanel.Visible := DEnabling;
  ButtonPanel.Top := 0;
  DetailsBtn.Caption := Format(DetailsOn[DEnabling], [FDetails]);
end;

procedure TDbEngineErrorDlg.ShowError;
var
  BDEError: TDbError;
begin
  BackBtn.Enabled := CurItem > 0;
  NextBtn.Enabled := CurItem < DbException.ErrorCount - 1;
  BDEError := DbException.Errors[CurItem];
  DbMessageText.Text := BDEError.Message;
  BDELabel.Enabled := True;
  DbResult.Text := IntToStr(BDEError.ErrorCode);
  DbCatSub.Text := Format('[%s%2x] [%0:s%2:2x]', [HexDisplayPrefix,
    BDEError.Category, BDEError.SubCode]);
  NativeLabel.Enabled := BDEError.NativeError <> 0;
  if NativeLabel.Enabled then NativeResult.Text := IntToStr(BDEError.NativeError)
  else NativeResult.Clear
end;

procedure TDbEngineErrorDlg.FormCreate(Sender: TObject);
begin
  FDetailsHeight := ClientHeight;
  FDetails := DetailsBtn.Caption;
  SwitchDetails;
end;

procedure TDbEngineErrorDlg.FormDestroy(Sender: TObject);
begin
  if Assigned(FPrevOnException) then Application.OnException := FPrevOnException;
end;

procedure TDbEngineErrorDlg.FormShow(Sender: TObject);
begin
  ErrorText.Caption := DbException.Message;
  if DetailsPanel.Visible then
  begin
    CurItem := 0;
    ShowError;
  end;
end;

procedure TDbEngineErrorDlg.BackClick(Sender: TObject);
begin
  Dec(CurItem);
  ShowError;
end;

procedure TDbEngineErrorDlg.NextClick(Sender: TObject);
begin
  Inc(CurItem);
  ShowError;
end;

procedure TDbEngineErrorDlg.DetailsBtnClick(Sender: TObject);
begin
  SwitchDetails;
  if DetailsPanel.Visible then
  begin
    CurItem := 0;
    ShowError;
  end;
end;

procedure TDbEngineErrorDlg.HookExceptions;
begin
  FPrevOnException := Application.OnException;
  Application.OnException := HandleException;
end;

function TDbEngineErrorDlg.ShowException(Error: EDbEngineError): TModalResult;
begin
  DbException := Error;
  Result := ShowModal;
  DbException := nil;
end;

end.
