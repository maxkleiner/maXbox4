unit SoapUnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SOAPHTTPTrans, StdCtrls, Menus, ExtCtrls, ComCtrls;

const
  STRRequest    = '  Request: ';
  STRResponse   = '  Response: ';
  STRDateTime   = '  AT: ';
  STRSeperator  = '-----------------------------------------------------------';

type
  TSoapForm = class(TForm)
    HTTPReqResp1: THTTPReqResp;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileOpen: TMenuItem;
    FileSave: TMenuItem;
    FileExit: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    FileNew: TMenuItem;
    Panel1: TPanel;
    Request: TMemo;
    Splitter1: TSplitter;
    Response: TMemo;
    Label1: TLabel;
    PanelTop: TPanel;
    Proxy: TEdit;
    SOAPAction: TEdit;
    URL: TEdit;
    Post: TButton;
    PageControl1: TPageControl;
    tsRequest: TTabSheet;
    tsResponse: TTabSheet;
    tsTransactionLog: TTabSheet;
    TransactionLog: TMemo;
    procedure PostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure FileSaveClick(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure FileNewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  sPOST_FileExt = '.sop';
  sPOST_Filter  = 'SOAP POST Files (*.sop)|*.SOP';
  sPOST_Request = 'Request';
  sPOST_URL     = 'URL';
  sPOST_Action  = 'SOAPAction';
  sPOST_Untitled= 'Untitled' + sPOST_FileExt;
var
  SoapForm: TSoapForm;

implementation

uses EncdDecd;

{$R *.dfm}

procedure TSoapForm.PostClick(Sender: TObject);
var
  Stream: TMemoryStream;
  StrStream: TStringStream;
begin
  Response.Text := '';
  Stream := TMemoryStream.Create;
  try
    HTTPReqResp1.URL := URL.Text;
    HTTPReqResp1.UseUTF8InHeader := True;
    HTTPReqResp1.SoapAction := SOAPAction.Text;
    if Proxy.Text <> '' then
      HTTPReqResp1.Proxy := Proxy.Text;
    HTTPReqResp1.Execute(Request.Text, Stream);
    TransactionLog.Lines.Add(STRSeperator);
    TransactionLog.Lines.Add(STRRequest + URL.Text);
    TransactionLog.Lines.Add(STRDateTime + DateTimeToStr(now));
    TransactionLog.Lines.Add(STRSeperator);
    TransactionLog.Lines.Add(Request.Text);
    StrStream := TStringStream.Create('');
    try
      StrStream.CopyFrom(Stream, 0);
      Response.Text := StrStream.DataString;
      TransactionLog.Lines.Add(STRSeperator);
      TransactionLog.Lines.Add(STRResponse + URL.Text);
      TransactionLog.Lines.Add(STRDateTime + DateTimeToStr(now));
      TransactionLog.Lines.Add(STRSeperator);
      TransactionLog.Lines.Add(Response.Text);
      PageControl1.ActivePage := tsResponse;
    finally
      StrStream.Free;
    end;
  finally
    Stream.Destroy;
  end;
end;

procedure TSoapForm.FormCreate(Sender: TObject);
begin
  Caption := 'mX4 SOAP POSTTool';
end;

procedure TSoapForm.FileOpenClick(Sender: TObject);
var
  SL: TStringList;
begin
  OpenDialog1.DefaultExt := sPOST_FileExt;
  OpenDialog1.Filter := sPOST_Filter;
  if OpenDialog1.Execute then
  begin
    SL := TStringList.Create;
    try
      SL.LoadFromFile(OpenDialog1.FileName);
      Request.Text := DecodeString(SL.Values[sPOST_Request]);
      URL.Text := DecodeString(SL.Values[sPOST_URL]);
      SOAPAction.Text := DecodeString(SL.Values[sPOST_Action]);
      Caption := SaveDialog1.FileName;
      PageControl1.ActivePage := tsRequest;
      Response.Clear;
    finally
      SL.Free;
    end;
  end;
end;

procedure TSoapForm.FileSaveClick(Sender: TObject);
var
  SL: TStringList;
begin
  SaveDialog1.DefaultExt := sPOST_FileExt;
  SaveDialog1.Filter := sPOST_Filter;
  if SaveDialog1.Execute then
  begin
    SL := TStringList.Create;
    try
      SL.Add(sPOST_Request + '=' + EncodeString(Request.Text));
      SL.Add(sPOST_URL     + '=' + EncodeString(URL.Text));
      SL.Add(sPOST_Action  + '=' + EncodeString(SOAPAction.Text));
      SL.SaveToFile(SaveDialog1.FileName);
      Caption := SaveDialog1.FileName;
    finally
      SL.Free;
    end;
  end;
end;

procedure TSoapForm.FileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TSoapForm.FileNewClick(Sender: TObject);
begin
  Request.Text := '';
  Response.Text := '';
  URL.Text := '';
  SOAPAction.Text := '';
  Caption := sPOST_Untitled;
end;

end.
