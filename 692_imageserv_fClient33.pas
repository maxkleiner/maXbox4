{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com  - softwareschule.ch                    }
{**********************************************************************}
{}
{ $Log:  110862: fClient.pas  #sign: Max: MAXBOX10: 18/05/2016 13:49:30 
{
{   Rev 1.0    26/10/2004 13:05:04  ANeillans    Version: 9.0.17
{ Verified  #head>Max: MAXBOX10: 18/05/2016 13:49:30 C:\Program Files (x86)\maxbox3\Import\IPC\maxbox4\maxbox4\examples\692_imageserv_fClient33.pas 
    Version 692 #sign: Max: MAXBOX10: 18/05/2016 13:49:30 
}
{-----------------------------------------------------------------------------
 Demo Name: ImageClient  DWS prototype
 Author:    Allen O'Neill   Max Kleiner
 Purpose: *** WINDOWS DEMO ONLY ***
 History:   adapt to maXbox
-----------------------------------------------------------------------------
 Notes:  png in preparation - antifreeze by Connection reset by peer.
 Demonstrates sending images / data using streams using TCP server / client
}

unit fClient;

interface

{uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient,IdGlobal;
 }
 
//type
  //TfrmClient = class(TForm)
  var  btnGetImageList: TButton;
    lstAvailableImages: TListBox;
    Label1: TLabel;
    Shape1: TShape;
    imgMain: TImage;
    btnGetSelectedImage: TButton;
    btnExit: TButton;
    Label2: TLabel;
    edtServerHost: TEdit;
    IdTCPClient: TIdTCPClient;
    Label3: TLabel;
    btnServerScreenShot: TButton;
    Label4: TLabel;
    edtServerPort: TEdit;
    procedure TfrmClientbtnExitClick(Sender: TObject);
    procedure TfrmClientbtnGetImageListClick(Sender: TObject);
    procedure TfrmClientbtnGetSelectedImageClick(Sender: TObject);
    procedure TfrmClientbtnServerScreenShotClick(Sender: TObject);
  //private
    { Private declarations }
  //public
    { Public declarations }
    Procedure TfrmClientLoadItems(S : String);
  //end;

var
  frmClient: TForm; //TfrmClient;
  
  Const IMAGEPATH = '\ImagesClient'; 
        SCREENMAP = '\ServerScreen.bmp';


implementation

//{$R *.DFM}

procedure TfrmClientbtnExitClick(Sender: TObject);
begin
if MessageDlg('Are you sure you wish to exit?', mtInformation, [mbYes, mbNo], 0)
= mrYes then frmclient.close;
 if assigned(IdTCPClient) then
   IdTCPClient.free;
   writeln('tcp free & form close...')
   //application.terminate;
end;

// Get list of available images form server
procedure TfrmClientbtnGetImageListClick(Sender: TObject);
begin
//try
 //idTCPClient:= TIdtcpclient.create(self)
   //writeln('assign IP1: '+'host')
try   
with IdTCPClient do begin
 // try
   if connected then DisConnect;
  //except
  //end;
    //writeln('before connect1 ->')
    Host := edtServerHost.text;
    Port := StrToInt(edtServerPort.text);
    //host:= '127.0.0.1';
    //port:= 8090;
    //writeln('before connect2 ->')
    Connect(1500);
    memo2.lines.add('assign IP2: '+host)
    idtcpclient.WriteLn('LST');
    lstAvailableImages.Clear;
    //memo2.lines.add('first push back: '+ReadLn(LF,500,0))
    TfrmClientLoadItems(idtcpclient.ReadLn(LF,500,2500));
    memo2.lines.add('list back: '+ReadLn(LF,500,2500))
    Disconnect;
  end;
except
//on E : Exception do
    //ShowMessage(E.Message);
     writeln(ExceptionToString(ExceptionType, ExceptionParam)); 
  end;
end;

//get selected image in listbox from server
procedure TfrmClientbtnGetSelectedImageClick(Sender: TObject);
var
    ftmpStream : TFileStream;
begin
Try
if lstAvailableImages.itemindex = -1 then
MessageDlg('Cannot proceed until you select an image from the list !',
                           mtInformation, [mbOK], 0)
else
with IdTCPClient do begin
    if connected then DisConnect;
    Host := edtServerHost.text;
    Port := StrToInt(edtServerPort.text);
    Connect(1500);
    IdTCPClient.WriteLn('PIC:' + lstAvailableImages.Items[lstAvailableImages.itemindex]);
    // delete if exists
    // in production situation you might store binary downloads like this in a cache folder
    if FileExists(ExtractFileDir(ParamStr(0)) + IMAGEPATH+
        '\' + lstAvailableImages.Items[lstAvailableImages.itemindex]) then
        DeleteFile(ExtractFileDir(ParamStr(0)) + IMAGEPATH+
        '\' + lstAvailableImages.Items[lstAvailableImages.itemindex]);
    ftmpStream := TFileStream.Create(ExtractFileDir(ParamStr(0)) + IMAGEPATH+
        '\' + lstAvailableImages.Items[lstAvailableImages.itemindex],fmCreate);
    while connected do
        ReadStream(fTmpStream,-1,true);
    //FreeAndNil(fTmpStream);
    ftmpStream.free;
    ftmpstream:= Nil;
    Disconnect;
    imgMain.Picture.LoadFromFile(ExtractFileDir(ParamStr(0)) + IMAGEPATH+'\' 
                      + lstAvailableImages.Items[lstAvailableImages.itemindex]);
  end;
except
//on E : Exception do
    //ShowMessage('E.Message');
     writeln(ExceptionToString(ExceptionType, ExceptionParam)); 
 end;
end;

// Procedure to break up items in input string
Procedure TfrmClientLoadItems(S : String);
var
    iPosComma : integer;
    sTmp : string;
begin
try
lstAvailableImages.Clear;
s := trim(s);
while pos(',',s) > 0 do Begin
    iPosComma := pos(',',s); // locate commas
    sTmp := copy(s,1,iPosComma - 1); // copy item to tmp string
    lstAvailableImages.items.Add(sTmp); // add to list
    s := copy(s,iPosComma + 1,Length(s)); // delete item from string
    End;
// trap for trailing filename
if length(s) <> 0 then lstAvailableImages.items.Add(s);
except
//on E : Exception do
    //ShowMessage('E.Message');
    writeln(ExceptionToString(ExceptionType, ExceptionParam)); 

end;
End;

// Request screenshot bitmap from server
procedure TfrmClientbtnServerScreenShotClick(Sender: TObject);
var
    ftmpStream : TFileStream;
begin
try
with IdTCPClient do begin
    if connected then DisConnect;
    Host := edtServerHost.text;
    Port := StrToInt(edtServerPort.text);
    Connect(500);
    WriteLn('SRN');
    // delete if exists
    // in production situation you might store binary downloads like this in a cache folder
    if FileExists(ExtractFileDir(ParamStr(0))+ SCREENMAP) then
        DeleteFile(ExtractFileDir(ParamStr(0))+ SCREENMAP);
    ftmpStream:= 
        TFileStream.Create(ExtractFileDir(ParamStr(0))+ SCREENMAP,fmCreate);
    while connected do
        ReadStream(fTmpStream,-1,true);
    //FreeAndNil(fTmpStream);
    fTmpStream.free;
    fTmpStream:= Nil;
    Disconnect;
    imgMain.Picture.LoadFromFile(ExtractFileDir(ParamStr(0)) + SCREENMAP);
    end;
except
//on E : Exception do
   //ftmpStream.Free;
     writeln(ExceptionToString(ExceptionType, ExceptionParam)); 
 end;
end;

procedure loadTCPClientForm;
begin
frmClient:= TForm.create(self)
with frmclient do begin
  setBounds(276, 154, 526, 375);
  Caption := 'TCP Image Client maXbox'
  Color := clBtnFace
  Font.Charset := DEFAULT_CHARSET
  Font.Color := clWindowText
  Font.Height := -11
  Font.Name := 'MS Sans Serif'
  Font.Style := []
  OldCreateOrder := False
  PixelsPerInch := 96
  //TextHeight := 13
  show;
  end;
  Label1:= TLabel.create(self)
  with label1 do begin
    parent:= frmclient;
    setBounds(12,56,80, 13)
    Caption := 'Available Images'
  end;
  Shape1:= TShape.create(self);
  with shape1 do begin
    parent:= frmclient;
    setBounds(220,50,1,266)
    Pen.Color := clGray
  end;
  imgMain:= TImage.create(self)
  with imgmain do begin
    parent:= frmclient;
    SetBounds(235,73,265,197)
    Stretch := True
  end;
  Label2:= TLabel.create(self)
  with label2 do begin
    parent:= frmclient;
    setBounds(11,14,22,13)
    Caption := 'Host'
  end;
  Label3:= TLabel.creAte(self)
    with label3 do begin
    parent:= frmclient;
    setBounds(235, 56, 91,13)
    Caption := 'Downloaded image'
  end;
  Label4:= TLabel.create(self)
  with label4 do begin
    parent:= frmclient;
    setBounds(141, 14, 19,13)
    Caption := 'Port'
  end;
  btnGetImageList:= TButton.creaTE(self)
  with btngetimagelist do begin
    parent:= frmclient;
    setBounds(12, 280, 193, 25)
    Caption := '1 - Get Available Images'
    TabOrder := 0
    OnClick := @TfrmclientbtnGetImageListClick
  end;
  lstAvailableImages:= TListBox.create(self)
  with lstavailableimages do begin
    parent:= frmclient;
    Left := 12
    Top := 72
    Width := 193
    Height := 205
    ItemHeight := 13
    TabOrder := 1
  end;
  btnGetSelectedImage:= TButton.create(self)
  with btngetselectedimage do begin
    parent:= frmclient;
    Left := 235
    Top := 280
    Width := 265
    Height := 25
    Caption := '2 - Get Selected Image'
    TabOrder := 2
    OnClick := @tfrmclientbtnGetSelectedImageClick
  end;
  btnExit:= TButton.create(self)
  with btnexit do begin
    parent:= frmclient;
    Left := 423
    Top := 29
    Width := 75
    Height := 25
    Caption := 'E&xit'
    TabOrder := 3
    OnClick := @tfrmclientbtnExitClick
  end;
  edtServerHost:= TEdit.create(self)
  with edtserverhost do begin
    parent:= frmclient;
    Left := 42
    Top := 11
    Width := 91
    Height := 21
    TabOrder := 4
    Text := '127.0.0.1'
  end;
  btnServerScreenShot:= TButton.create(self)
  with btnserverscreenshot do begin
    parent:= frmclient;
    Left := 12
    Top := 309
    Width := 193
    Height := 25
    Caption := '3 - Get Server Screen Shot'
    TabOrder := 5
    OnClick := @tfrmclientbtnServerScreenShotClick
  end;
  edtServerPort:= TEdit.create(self)
  with edtserverport do begin
    parent:= frmclient;
    Left := 172
    Top := 11
    Width := 57
    Height := 21
    TabOrder := 6
    Text := '8090'
  end;
  IdTCPClient:= TIdTCPClient.create(self)
  with idtcpclient do begin
    //parent:= frmclient;
    MaxLineAction := maException
    RecvBufferSize := 1024
    Host := '127.0.0.1'; //192.168.56.1
    Port := 8090
    //Left := 380
    //Top := 4
  end;
end;


  var was: boolean;

begin

  writeln(getip(gethostname))
  //LoadDFMFile2Strings(const AFile:string; AStrings:TStrings; var WasText:boolean):integer 
  {srlist:= TStringlist.create;
  LoadDFMFile2Strings('C:\maXbox\maxbox3\work2015\Indy9Demos_26Oct04\Indy9Demos\ImageServer\Client\fclient.dfm',srlist, was)
  writeln(srlist.text)
  srlist.free;   }
  
  if not directoryexists(exepath+IMAGEPATH) then 
    MakeDir(exepath+IMAGEPATH);
  
  loadTCPClientForm;
End.


{object frmClient: TfrmClient
  Left = 276
  Top = 154
  Width = 526
  Height = 375
  Caption = 'Image Client'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 56
    Width = 80
    Height = 13
    Caption = 'Available Images'
  end
  object Shape1: TShape
    Left = 220
    Top = 50
    Width = 1
    Height = 266
    Pen.Color = clGray
  end
  object imgMain: TImage
    Left = 235
    Top = 73
    Width = 265
    Height = 197
    Stretch = True
  end
  object Label2: TLabel
    Left = 11
    Top = 14
    Width = 22
    Height = 13
    Caption = 'Host'
  end
  object Label3: TLabel
    Left = 235
    Top = 56
    Width = 91
    Height = 13
    Caption = 'Downloaded image'
  end
  object Label4: TLabel
    Left = 141
    Top = 14
    Width = 19
    Height = 13
    Caption = 'Port'
  end
  object btnGetImageList: TButton
    Left = 12
    Top = 280
    Width = 193
    Height = 25
    Caption = '1 - Get Available Images'
    TabOrder = 0
    OnClick = btnGetImageListClick
  end
  object lstAvailableImages: TListBox
    Left = 12
    Top = 72
    Width = 193
    Height = 205
    ItemHeight = 13
    TabOrder = 1
  end
  object btnGetSelectedImage: TButton
    Left = 235
    Top = 280
    Width = 265
    Height = 25
    Caption = '2 - Get Selected Image'
    TabOrder = 2
    OnClick = btnGetSelectedImageClick
  end
  object btnExit: TButton
    Left = 423
    Top = 29
    Width = 75
    Height = 25
    Caption = 'E&xit'
    TabOrder = 3
    OnClick = btnExitClick
  end
  object edtServerHost: TEdit
    Left = 42
    Top = 11
    Width = 91
    Height = 21
    TabOrder = 4
    Text = '127.0.0.1'
  end
  object btnServerScreenShot: TButton
    Left = 12
    Top = 309
    Width = 193
    Height = 25
    Caption = 'Get Server Screen Shot'
    TabOrder = 5
    OnClick = btnServerScreenShotClick
  end
  object edtServerPort: TEdit
    Left = 172
    Top = 11
    Width = 37
    Height = 21
    TabOrder = 6
    Text = '8090'
  end
  object IdTCPClient: TIdTCPClient
    MaxLineAction = maException
    RecvBufferSize = 1024
    Host = '127.0.0.1'
    Port = 8090
    Left = 380
    Top = 4
  end
end
               }

