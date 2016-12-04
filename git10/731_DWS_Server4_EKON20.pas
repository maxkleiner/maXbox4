{ $HDR$}
{**********************************************************************}
{  For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com    www.softwareschule.ch                    }
{**********************************************************************}
{}
{ $Log:  110838: fServer.pas #sign: Max: MAXBOX10: 13/11/2016 16:24:24 
{
{   Rev 1.1    26/10/2004 13:04:58  ANeillans    Version: 9.0.17
{ Verified     09/05/2016  _ Exception: to much data to read. solved
}
{-----------------------------------------------------------------------------
 Demo Name: EXE ImageServer
 Authors:    Allen O'Neill   Max Kleiner CancelBuffer size manager
 Copyright: Indy Pit Crew maXbox
 Purpose: *** WINDOWS DEMO ONLY ***
 History:   adapt to maXbox EKON20
-----------------------------------------------------------------------------
 Notes:
 Demonstrates sending images / data using streams using TCP server / client

 Note - adding items to the list box as per this demo is NOT threadsafe - you should  use the demo from "NotifyDemo" to learn how to synchronise safely using Indy sync
}


unit fServer4_EKON20_EXE_DelphiWebStart;

interface

{uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, IdBaseComponent, IdComponent, IdTCPServer, StdCtrls,IdGlobal,
  SyncObjs;
  }
  
//type
  //TfrmServer = class(TForm)
  var  IdTCPServer: TIdTCPServer;
    lstRequests: TListBox;
    Label1: TLabel;
       procedure TfrmServerFormCreate(Sender: TObject);
       procedure TfrmServerIdTCPServerDisconnect(AThread: TIdPeerThread);
       procedure TfrmServerIdTCPServerExecute(AThread: TIdPeerThread);
       procedure TfrmServerIdTCPServerConnect(AThread: TIdPeerThread);
       procedure TfrmServerFormDestroy(Sender: TObject);
     //private
    { Private declarations }
  //public
    { Public declarations }
     var CS : TCriticalSection;
        Function TfrmServerGetList : String;
  //procedure TfrmServerScreenShot(x: integer; y: integer; Width : integer; Height : integer; bm : TBitMap);
  //end;

var
  frmServer: TForm; //TfrmServer;
  sFilePattern : String;
  
Const //Imagepath2 = '\examples\images\';  
      Imagepath = '\imagesServer\';  
      //IP_Socket = '192.168.56.1';
      IP_Socket = '192.168.56.1'; //'192.168.80.1';
      PORT_Socket =  8090;

implementation

//{$R *.DFM}

// activates TCP server
procedure TfrmServerFormCreate(Sender: TObject);
begin
CS := TCriticalSection.Create;
  try
    IdTCPServer.Active:= true;
if IdTCPServer.Active = true then
    lstRequests.items.append('TCP Server Active:  '+datetimetoStr(now));
    maxform1.color:= clgreen;
  except
    writeln(ExceptionToString(ExceptionType, ExceptionParam)); 
  end;  
      
end;

procedure TfrmServerIdTCPServerDisconnect(AThread: TIdPeerThread);
begin
lstRequests.items.append('Dis-Connected at: '+datetimetoStr(now));
//if PlaySound(windir+'\Media\notify.wav', 0, SND_FILENAME or SND_SYNC) then
  //  maxform1.color:= clred;
end;

// interpets request and sends back data
procedure TfrmServerIdTCPServerExecute(AThread: TIdPeerThread);
var
    s, sCommand, sAction : string;
    fStream : TFileStream;
    tBM : tbitmap;
begin
CS.Enter;
try
  s:= uppercase(AThread.Connection.ReadLn('',1000,80));
  sCommand := copy(s,1,3);
  sAction := copy(s,5,100);
  writeln('Execute on IdTCPServerExecute(AThread) at: '+datetimetoStr(now))

if sCommand = 'LST' then begin
    AThread.Connection.WriteLn(TfrmServerGetList);
    AThread.Connection.Disconnect;
    end
else
if sCommand = 'PIC' then begin
    if FileExists(ExtractFileDir(ParamStr(0)) + Imagepath + sAction) then Begin
        lstRequests.items.add('Serving up: ' + sAction);
        // open file stream to image requested
        fStream:= TFileStream.Create(ExtractFileDir(ParamStr(0)) 
              + Imagepath + sAction,fmOpenRead	+ fmShareDenyNone);
        // copy file stream to write stream
       lstRequests.items.add('pic image size: '+itoa(fstream.size))
        AThread.Connection.OpenWriteBuffer(-1);
    //  procedure WriteStream(AStream: TStream; const AAll: Boolean = True;
    // const AWriteByteCount: Boolean = False; const ASize:Integer = 0); virtual;
     //   AThread.Connection.WriteStream1(fStream);
        AThread.Connection.WriteStream(fStream, true, false, 0);
        AThread.Connection.CloseWriteBuffer;
        // free the file stream
        fstream.Free;
        //AndNil(fStream);
        fstream:= NIL;
        lstRequests.items.add('PIC File transfer completed');
        AThread.Connection.WriteLn('MON : PIC File transfer completed / PIC action');
  
        AThread.Connection.Disconnect;
      End
    else
    AThread.Connection.WriteLn('ERR - Requested file does not exist');
    AThread.Connection.Disconnect;
    End
else
if sCommand = 'SRN' then begin
    // in production version you would use a unique file name such as one generated  from a tickcount plus client IP / id etc.
    // take snapshot
    lstRequests.items.add('Taking server screen snap shot');
    tBM := TBitmap.Create;
    //TfrmServerScreenShot(0,0,Screen.Width,Screen.height,tBM);
    //Procedure ScreenShot( bm : TBitmap; Left, Top, Width, Height : Integer; Window : HWND); 
   //Screenshot(tBM, 0,0,Screen.Width,Screen.height, application.handle{hinstance});

    GetScreenShot(tbm)
    if fileExists (ExtractFileDir(ParamStr(0)) + Imagepath+'ScreenShot.BMP') then 
         DeleteFile(ExtractFileDir(ParamStr(0)) + Imagepath+'ScreenShot.BMP');
    tBM.SaveToFile(ExtractFileDir(ParamStr(0)) + Imagepath+'ScreenShot.BMP');
    tBm.FreeImage;
    tbm.free;
    //FreeAndNil(tBM);
    tbm:= NIL;
    lstRequests.items.add('Serving up: SCREENSHOT.BMP');
    // open file stream to image requested
    fStream:= TFileStream.Create(ExtractFileDir(ParamStr(0)) + 
                    Imagepath+'ScreenShot.BMP',fmOpenRead	+ fmShareDenyNone);
    // copy file stream to write stream
   //  AThread.Connection.OpenWriteBuffer(1000);
    AThread.Connection.OpenWriteBuffer(-1);
      //AThread.Connection.FlushWriteBuffer(5)
      //AThread.Connection.ClearWriteBuffer;
      // AThread.Connection.OpenWriteBuffer(fstream.size);
      // AThread.Connection.WriteStream1(fStream);
    lstRequests.items.add('image size: '+itoa(fstream.size))
  //   AThread.Connection.WriteStream(fStream, false, true, fstream.size);
    AThread.Connection.WriteStream(fStream, true, false, 0);
  
  //Exception: Integer overflow.
  // AThread.Connection.WriteFile(exepath+'indystream.bmp',true);
    AThread.Connection.CloseWriteBuffer;
    // free the file stream
    //FreeAndNil(fStream);
    fstream.free;
    fstream:= NIL;
    lstRequests.items.add('File transfer completed');
    AThread.Connection.Disconnect;
    //lstRequests.TopIndex := -1 + lstRequests.Items.Count; 
    End else
  if (sCommand <> 'LST') and (sCommand <> 'PIC') and (sCommand <> 'SRN') then
    Begin
    AThread.Connection.WriteLn('ERR : Unknown TCP Image command/action at '+datetimetoStr(now));
    AThread.Connection.Disconnect;
    end;
    
    lstRequests.TopIndex:= -1 + lstRequests.Items.Count; 

 except
//on E : Exception do
  fStream.Free;
   AThread.Connection.CancelWriteBuffer;
   writeln(ExceptionToString(ExceptionType, ExceptionParam)); 
  //ShowMessage('E.Message');
     // writeln(ExceptionToString(ExceptionType, ExceptionParam)); 
  End;
 CS.Leave;
end;

procedure TfrmServerIdTCPServerConnect(AThread: TIdPeerThread);
begin
  lstRequests.items.add('Image Server connected');
  //AThread.Connection.WriteLn('Indy ImageServer TCP mXServer Ready.');
end;

// Simple function to search given path and return BMP file names in comma delimited format // NOTE! .. assumes in maXbox3 demo version there is a sub-folder off executable called 'images" that contains
// sample valid BMP images
Function TfrmServerGetList : String;
var
    SR : TFindRec; //TSearchRec;
    S : String;
Begin
sFilePattern := ExtractFileDir(ParamStr(0)) + Imagepath+'*.*';
S := '';
writeln(sFilePattern)
if FindFirst3(sFilePattern,SR) then Begin
    s := SR.Name;
    writeln('debug first: '+s)
   // while FindNext3(sr) = true do
    while FindNext3(sr) do
       s := s + ','+SR.Name;
    End;
result := s;
End;

Function TfrmServerGetList2 : String;
var SR : TSearchRec;
    S : String;
Begin
sFilePattern := ExtractFileDir(ParamStr(0)) + Imagepath+'\*.*';
S := '';
writeln(sFilePattern)
if FindFirst2(sFilePattern,faAnyfile, SR) = 0 then Begin
    s := SR.Name;
    //writeln('debug first: '+s)
   // while FindNext3(sr) = true do
    while FindNext2(sr) = 0 do
       s := s + ',' + SR.Name;
    End;
result := s;
End;

// This ScrenShot code taken from the frequent usenet postings of
// Joe C. Hecht <joehecht@gte.net>  http://home1.gte.net/joehecht/index.htm
(*procedure TfrmServerScreenShot(x : integer; y : integer; Width : integer; Height : integer; bm : TBitMap);
var
  dc: HDC; lpPal : PLOGPALETTE;
begin
{test width and height}
  if ((Width = 0) OR (Height = 0)) then exit;
  bm.Width := Width;
  bm.Height := Height;
{get the screen dc}
  dc := GetDc(0);
  if (dc = 0) then exit;
{do we have a palette device?}
  if (GetDeviceCaps(dc, RASTERCAPS) AND
      RC_PALETTE = RC_PALETTE) then
      begin
      {allocate memory for a logical palette}
        GetMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
      {zero it out to be neat}
     FillChar(lpPal^, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)), #0);
      {fill in the palette version}
        lpPal^.palVersion := $300;
      {grab the system palette entries}
        lpPal^.palNumEntries :=
          GetSystemPaletteEntries(dc,0,256,lpPal^.palPalEntry);
        if (lpPal^.PalNumEntries <> 0) then
            begin
            {create the palette}
            bm.Palette := CreatePalette(lpPal^);
            end;
        FreeMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
      end;
{copy from the screen to the bitmap}
BitBlt(bm.Canvas.Handle,0,0,Width,Height,Dc,x,y,SRCCOPY);
{release the screen dc}
ReleaseDc(0, dc);
end; *)


procedure TfrmServerFormDestroy(Sender: TObject);
begin
//FreeAndNil(CS);
  if assigned(cs) then begin
    cs.free
    cs:= NIL;
  end;  
  if assigned(idtcpserver) then begin
    idtcpserver.active:= false;
    idtcpserver.free;
   end; 
   if PlaySound(windir+'\Media\notify.wav', 0, SND_FILENAME or SND_SYNC) then
    maxform1.color:= clred;
  writeln('Free form and CS and TCPServer! at: '+DateTimeToInternetStr(now, true))
end;

procedure tfrmClose(Sender: TObject; var action: TCloseAction);
begin
//FreeAndNil(CS);
  action:= CAFree;
  //cs.free
  //cs:= NIL;
  //writeln('free CS')
end;

procedure loadTCPServerForm;
begin
frmServer:= Tform.create(self); //TfrmServer
with frmserver do begin
  setbounds(360, 124, 355, 465)
  Caption := 'maXbox EKON20 Indy9 - TCP Image EXE Server'
  Color := clBtnFace                            
  formstyle:= fsstayontop;
  Font.Charset := DEFAULT_CHARSET
  Font.Color := clWindowText
  Font.Height := -11
  Font.Name := 'MS Sans Serif'
  Font.Style := []
  formstyle := fsstayontop;
  OldCreateOrder := False
  //OnCreate := FormCreate
  OnDestroy := @tfrmserverFormDestroy
  onclose:=  @tfrmclose;
  PixelsPerInch := 96
  //TextHeight := 13
  show;
  end;
 Label1:= TLabel.create(self)
 with label1 do begin
    parent:= frmserver;
    setBounds(6, 20, 62, 13)
    Caption := 'Server status'
  end;
  lstRequests:= TListBox.create(self)
  with lstrequests do begin
    parent:= frmserver;
    setBounds(4,40,329,367)
    ItemHeight := 13
    TabOrder := 0
  end;
  {object} IdTCPServer:= TIdTCPServer.create(self) 
  try
  
    with idtcpserver do begin
    //bindings.port('');
    //Bindings[0].port:= 8090;
    //active:= true;
    //The Bindings collection has an Add() method, eg:
    //bindings.ADD.port:= 8090;
    defaultport:= PORT_Socket; //8090;
    bindings.add.ip:= IP_Socket; //'192.168.56.1'; //'127.0.0.1';
    //host
    //Bindings.items[0].ip:= '127.0.0.1';
    //active:= true;
    //bindings.items[0].port:= 8090;
    {<  item IP := '127.0.0.1'
        Port := 8090
      end>}
    //CommandHandlers := Nil; //<>
    //peerip:= 
   // DefaultPort := 8090
    Greeting.NumericCode := 0
    MaxConnectionReply.NumericCode := 0 
    active:= true;
    PrintF('Listening TCPServer on %s:%d.',[bindings[0].IP,Bindings[0].Port]);
    OnConnect := @tfrmserverIdTCPServerConnect;
    OnExecute := @tfrmserverIdTCPServerExecute;
    OnDisconnect := @tfrmserverIdTCPServerDisconnect;
    ReplyExceptionCode := 0
    //ReplyTexts := Nil; //<>
    ReplyUnknownCommand.NumericCode := 0
   end; 
   Except
     //IdTCPServer.free
     TfrmServerFormDestroy(self);
     writeln(ExceptionToString(ExceptionType, ExceptionParam));
     writeln('Exception TCP Sock Stop') 
   end;  
    //active:= true;
    //Left := 304
    //Top := 40
  TfrmServerFormCreate(self)
 end; 


 var was: boolean;

begin    //main code

 writeln(TfrmServerGetList);
 //writeln(TfrmServerGetList2);
  loadTCPServerForm;
 
 {  srlist:= TStringlist.create;
  LoadDFMFile2Strings('C:\maXbox\maxbox3\work2015\Indy9Demos_26Oct04\Indy9Demos\ImageServer\Server\fserver.dfm',srlist, was)
  writeln(srlist.text)
  srlist.free; }

End.

//ref: http://stackoverflow.com/questions/27661700/tcpserver-x-tcpclient-problems-on-run-stress-test

//Exception: No data to read.  - solved
//5/10/2016 9:00:02 AM V:4.2.2.90 [max] MAXBOX8 Terminate Thread Timeout. [at:  1405460pgf; mem:504724]

//Covering new languages, adding rules engines, computing advanced metrics can be done through a new code model based on class - component - service - domain view.
//https://www.scribd.com/doc/311485747/A-new-Codemodel-for-Codemetrics

//<p  style=" margin: 12px auto 6px auto; font-family: Helvetica,Arial,Sans-serif; font-style: normal; font-variant: normal; font-weight: normal; font-size: 14px; line-height: normal; font-size-adjust: none; font-stretch: normal; -x-system-font: none; display: block;">   <a title="View A new Codemodel for Codemetrics on Scribd" href="https://www.scribd.com/doc/311485747/A-new-Codemodel-for-Codemetrics"  style="text-decoration: underline;" >A new Codemodel for Codemetrics</a> by <a title="View Max Kleiner's profile on Scribd" href="https://www.scribd.com/user/27861168/Max-Kleiner"  style="text-decoration: underline;" >Max Kleiner</a></p><iframe class="scribd_iframe_embed" src="https://www.scribd.com/embeds/311485747/content?start_page=1&view_mode=scroll&access_key=key-gWyx1I4r0ejZJ6d0Nksx&show_recommendations=true" data-auto-height="false" data-aspect-ratio="1.3323485967503692" scrolling="no" id="doc_941" width="100%" height="600" frameborder="0"></iframe>

{object frmServer: TfrmServer
  Left = 355
  Top = 124
  Width = 348
  Height = 327
  Caption = 'Indy - Image Server'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 20
    Width = 62
    Height = 13
    Caption = 'Server status'
  end
  object lstRequests: TListBox
    Left = 4
    Top = 40
    Width = 329
    Height = 249
    ItemHeight = 13
    TabOrder = 0
  end
  object IdTCPServer: TIdTCPServer
    Bindings = <
      item
        IP = '127.0.0.1'
        Port = 8090
      end>
    CommandHandlers = <>
    DefaultPort = 8090
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = IdTCPServerConnect
    OnExecute = IdTCPServerExecute
    OnDisconnect = IdTCPServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 304
    Top = 40
  end
end
 }
